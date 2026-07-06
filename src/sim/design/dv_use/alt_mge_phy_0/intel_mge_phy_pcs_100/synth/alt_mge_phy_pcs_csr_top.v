// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1 ps / 1 ps

module alt_mge_phy_pcs_csr_top #(
    // Variant
    parameter IS_2P5G           = 0,
    parameter IS_1G_2P5G        = 1,
    parameter IS_1G_10G         = 0,
    parameter IS_MGBASE_T       = 0,
    parameter IS_10G_USXGMII    = 0,
    
    // CSR
    // 0: 1G/2.5G        - address  5-bit, databus 16-bit
    // 1: 1G/2.5G/5G/10G - address 11-bit, databus 32-bit
    parameter CSR_IF_MODE       = (IS_2P5G || IS_1G_2P5G) ? 0: 1,
    parameter CSR_ADDRESS_WIDTH = (CSR_IF_MODE == 1) ? 11 : 5,
    parameter CSR_DATABUS_WIDTH = (CSR_IF_MODE == 1) ? 32 : 16
) (
    // Clock
    input                               csr_clk,
    
    // Reset
    input                               global_rst_n__csr_clk,
    
    // User CSR Interface
    input       [CSR_ADDRESS_WIDTH-1:0] csr_address,
    input                               csr_read,
    input                               csr_write,
    input       [CSR_DATABUS_WIDTH-1:0] csr_writedata,
    output      [CSR_DATABUS_WIDTH-1:0] csr_readdata,
    output                              csr_waitrequest,
    
    // GMII 16-bit PCS
    output                       [ 4:0] csr_gmii16b_pcs_address,
    output                              csr_gmii16b_pcs_read,
    output                              csr_gmii16b_pcs_write,
    output                       [15:0] csr_gmii16b_pcs_writedata,
    input                        [15:0] csr_gmii16b_pcs_readdata,
    input                               csr_gmii16b_pcs_waitrequest,
    
    // USXGMII PCS
    output                       [ 5:0] csr_usxgmii_pcs_address,
    output                              csr_usxgmii_pcs_read,
    output                              csr_usxgmii_pcs_write,
    output                       [31:0] csr_usxgmii_pcs_writedata,
    input                        [31:0] csr_usxgmii_pcs_readdata,
    input                               csr_usxgmii_pcs_waitrequest,
    
    // CSR Registers
    output                              serial_loopback
);

// CSR region access valid
wire csr_gmii16b_pcs_access_valid;
wire csr_usxgmii_pcs_access_valid;
wire csr_serial_lb_access_valid;

// CSR Registers
reg  serial_loopback_reg;

generate if(CSR_IF_MODE == 1)
    begin : CSR_IF_MODE_GEN
        
        // GMII 16-bit PCS - 0x000 : 0x01F
        assign csr_gmii16b_pcs_access_valid = (csr_address[CSR_ADDRESS_WIDTH-1:5] == 6'b000_000);
        
        // USXGMII PCS - 0x400 : 0x43F
        assign csr_usxgmii_pcs_access_valid = (csr_address[CSR_ADDRESS_WIDTH-1:6] == 5'b100_00) && (IS_10G_USXGMII != 0);
        
        // Serial Loopback - 0x461
        assign csr_serial_lb_access_valid   = (csr_address[CSR_ADDRESS_WIDTH-1:0] == 11'h461);
        
        assign csr_readdata = csr_gmii16b_pcs_access_valid ? {16'h0, csr_gmii16b_pcs_readdata[15:0]} :
                              csr_usxgmii_pcs_access_valid ? {csr_usxgmii_pcs_readdata} :
                              csr_serial_lb_access_valid   ? {31'h0, serial_loopback} :
                                                             32'h0;
        
        assign csr_waitrequest = csr_gmii16b_pcs_access_valid ? csr_gmii16b_pcs_waitrequest :
                                 csr_usxgmii_pcs_access_valid ? csr_usxgmii_pcs_waitrequest :
                                                                1'b0;
        
        assign csr_usxgmii_pcs_address   = csr_address[5:0];
        assign csr_usxgmii_pcs_read      = csr_read & csr_usxgmii_pcs_access_valid;
        assign csr_usxgmii_pcs_write     = csr_write & csr_usxgmii_pcs_access_valid;
        assign csr_usxgmii_pcs_writedata = csr_writedata[31:0];
    end
else
    begin
        assign csr_gmii16b_pcs_access_valid = 1'b1;
        assign csr_readdata = csr_gmii16b_pcs_readdata;
        assign csr_waitrequest = csr_gmii16b_pcs_waitrequest;
        
        assign csr_usxgmii_pcs_access_valid = 1'b0;
        assign csr_serial_lb_access_valid = 1'b0;
        
        assign csr_usxgmii_pcs_address   = 5'h0;
        assign csr_usxgmii_pcs_read      = 1'b0;
        assign csr_usxgmii_pcs_write     = 1'b0;
        assign csr_usxgmii_pcs_writedata = 32'h0;
    end
endgenerate

assign csr_gmii16b_pcs_address   = csr_address[4:0];
assign csr_gmii16b_pcs_read      = csr_read & csr_gmii16b_pcs_access_valid;
assign csr_gmii16b_pcs_write     = csr_write & csr_gmii16b_pcs_access_valid;
assign csr_gmii16b_pcs_writedata = csr_writedata[15:0];

generate if(CSR_IF_MODE == 1)
    begin : CSR_REG_GEN
        
        // Serial Loopback
        always @(posedge csr_clk) begin
            if(~global_rst_n__csr_clk) begin
                serial_loopback_reg <= 1'b0;
            end
            else begin
                if(csr_write & csr_serial_lb_access_valid) begin
                    serial_loopback_reg <= csr_writedata[0];
                end
            end
        end
        
        assign serial_loopback = serial_loopback_reg;
        
    end
    
    else begin
        assign serial_loopback = 1'b0;
    end
endgenerate

endmodule
