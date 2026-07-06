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


`timescale 1ps/1ps

module alt_mge_phy_usxg32_tx_32_to_64_wadpt
(

    input wire          clk_312_5,
    input wire          reset_312_5_n,
    
    input wire [31:0]   tx_xgmii_data_in,
    input wire [3:0]    tx_xgmii_control_in,
    input wire          tx_xgmii_valid_in,

    output reg [63:0]   tx_xgmii_data_out,
    output reg [7:0]    tx_xgmii_control_out,
    output reg          tx_xgmii_valid_out
    

);

localparam SYM_IDLE           = 8'h07;

reg [31:0] tx_xgmii_data_in_reg;
reg [3:0] tx_xgmii_control_in_reg;

// NON_RESETABLE FLOPS
always @(posedge clk_312_5)
    begin
    tx_xgmii_data_in_reg <= tx_xgmii_data_in;
    tx_xgmii_control_in_reg <= tx_xgmii_control_in;
    end

always @ (posedge clk_312_5 or negedge reset_312_5_n)
    begin
    if (~reset_312_5_n)
        begin
        // valid can be stick to 1, because during reset next module does not care the input as well. 
        tx_xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
        tx_xgmii_control_out <= 8'hFF;
        tx_xgmii_valid_out <= 1'b1;
        end
    else
        begin
        

        tx_xgmii_data_out <= {tx_xgmii_data_in, tx_xgmii_data_in_reg};
        tx_xgmii_control_out <= {tx_xgmii_control_in, tx_xgmii_control_in_reg};
        if(tx_xgmii_valid_in)
            begin
            tx_xgmii_valid_out <= ~tx_xgmii_valid_out;
            end
        end
    end

endmodule
