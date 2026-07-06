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

module alt_mge_phy_usxg32_rx_clockcomp_fifo #(
    parameter FAWIDTH           = 5,
    parameter TSWIDTH           = 16,
    parameter IDWIDTH           = 32,
    parameter RX_DWIDTH         = 64,
    parameter RX_CWIDTH         = 8,
    parameter OFFSET            = 16'h29D6
) (
    input  wire                 rx_xgmii_clk,
    input  wire                 rx_pma_clk,
    
    input  wire                 rx_xgmii_rst_n,
    input  wire                 rx_pma_rst_n,
    
    input  wire                 rx_xgmii_valid_in,
    input  wire [RX_CWIDTH-1:0] rx_xgmii_control_in,
    input  wire [RX_DWIDTH-1:0] rx_xgmii_data_in,
    input  wire                 rx_xgmii_block_lock_in,
    
    output wire                 rx_xgmii_valid_out,
    output wire [RX_CWIDTH-1:0] rx_xgmii_control_out,
    output wire [RX_DWIDTH-1:0] rx_xgmii_data_out,
    output wire                 rx_xgmii_block_lock_out,
    
    input  wire                 rx_xgmii_dl_sync_pulse_in,      // Agilex USXGMII 1588 PTP sync pulse from eth_f NPHY
    output wire                 rx_xgmii_dl_sync_pulse_out      // Agilex USXGMII 1588 PTP sync pulse output to DET_LAT latency measurement module
);

    wire                rd_pempty;
    wire                wr_full;

    wire                fifo_wr_en;
    // ED
    wire [FAWIDTH-1:0]  rd_numdata;
    
    reg                 rd_val;

    // Delay match with read latency of dcfifo
    // To ensure no invalid data transfer to HSSI
    assign rx_xgmii_valid_out   = rd_val;
    assign fifo_wr_en           = (rx_xgmii_valid_in && !(wr_full));
    
    wire                rx_xgmii_dl_sync_pulse;
    
    assign rx_xgmii_dl_sync_pulse_out  = rx_xgmii_valid_out && rx_xgmii_dl_sync_pulse;

    alt_mge_phy_async_fifo_fpga #(
        .DWIDTH         (RX_CWIDTH + RX_DWIDTH + 2), // FIFO Input data width 
        .AWIDTH         (FAWIDTH),          // FIFO Depth (address width) 
        .SYNCSTAGE      (5),                // Metastable hardening stages, internally minus 3 in dcfifo
        .RESET_LF       (0)                 // Output Local Faults
    ) async_fifo (
        // Write
        .wr_clk         (rx_pma_clk),       // Write Domain Clock
        .wr_rst_n       (rx_pma_rst_n),     // Write Domain Active low Reset
        .wr_srst_n      (1'b1),             // Write Domain Active low Reset Synchronous
        
        .wr_en          (fifo_wr_en),       // Write Data Enable
        .wr_data        ({rx_xgmii_block_lock_in, rx_xgmii_dl_sync_pulse_in, rx_xgmii_control_in, rx_xgmii_data_in}), // Write Data In
        
        // Read
        .rd_clk         (rx_xgmii_clk),     // Read Domain Clock
        .rd_rst_n       (rx_xgmii_rst_n),   // Read Domain Active low Reset
        .rd_srst_n      (1'b1),             // Read Domain Active low Reset Synchronous
        
        .rd_en          (rd_val),           // Read Data Enable
        .rd_data        ({rx_xgmii_block_lock_out, rx_xgmii_dl_sync_pulse, rx_xgmii_control_out, rx_xgmii_data_out}), // Read Data Out
        .rd_data_next   (),                 // Read Data Out
        
        // Threshold
        .r_pempty       (5'd2),             // FIFO partially empty threshold
        .r_pfull        (5'd23),            // FIFO partially full threshold
        .r_empty        (5'd0),             // FIFO empty threshold
        .r_full         (5'd31),            // FIFO full threshold
        
        // Fill Level
        .rd_numdata     (rd_numdata),       // Number of Data available in Read clock
        .wr_numdata     (),                 // Number of Data available in Write clock
        
        // Full & empty Status
        .wr_empty       (),                 // FIFO Empty
        .wr_pempty      (),                 // FIFO Partial Empty
        .wr_full        (wr_full),          // FIFO Full
        .wr_pfull       (),                 // FIFO Parial Full
        .rd_empty       (),                 // FIFO Empty
        .rd_pempty      (rd_pempty),        // FIFO Partial Empty
        .rd_full        (),                 // FIFO Full
        .rd_pfull       ()                  // FIFO Partial Full
    );
    
    always @(negedge rx_xgmii_rst_n or posedge rx_xgmii_clk) begin
        if (rx_xgmii_rst_n == 1'b0) begin
            rd_val  <= 1'b0;
        end
        else begin
            rd_val  <= !rd_pempty;          // Data path running at full rate at this point. Valid signal will be always high
        end
    end

endmodule
