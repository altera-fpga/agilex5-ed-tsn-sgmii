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

module alt_mge_phy_usxg32_rx_rm_fifo_top #(
    parameter DATA_WIDTH        = 'd32,     // PCS data width
    parameter CONTROL_WIDTH     = 'd4,      // PCS control width
    parameter FAWIDTH           = 'd5,      // FIFO Depth (address width)
    parameter TSWIDTH           = 'd16,
    parameter IDWIDTH           = 'd40,     // PCS/PMA IF width
    parameter DEVICE_FAMILY     = "Arria V",
    parameter ENABLE_IEEE1588   = 0,
    parameter OFFSET            = 16'h283D  // PCS latency
) (
    input  wire                     wr_rst_n,               // Write Domain Active low Reset
    input  wire                     rd_rst_n,               // Read Domain Active low Reset
    input  wire                     sample_rst_n,           // Sampling Active low Reset
    input  wire                     wr_clk,                 // Write Domain Clock
    input  wire                     rd_clk,                 // Read Domain Clock
    input  wire                     sample_clk,             // Sampling Clock
    input  wire [CONTROL_WIDTH-1:0] control_in,             // Frame information 
    input  wire [DATA_WIDTH-1:0]    data_in,                // Write Data In
    input  wire                     data_valid_in,          // Write Data In Valid
    input  wire                     block_lock_in,          // Block Lock In (aligned to data_in)
    input  wire [FAWIDTH-1:0]       r_pempty,               // FIFO partially empty threshold
    input  wire [FAWIDTH-1:0]       r_pfull,                // FIFO partially full threshold
    input  wire [FAWIDTH-1:0]       r_empty,                // FIFO empty threshold
    input  wire [FAWIDTH-1:0]       r_full,                 // FIFO full threshold
    //input  wire                     r_truebac2bac,          // Back-2-back insertion/deletion
    input  wire                     r_write_ctrl,           // RX FIFO clock comp mode write option
    input  wire [2:0]               speed_mode,             // control FIFO read rate

    output  wire [CONTROL_WIDTH-1:0]    control_out,        // Frame information
    output  wire [DATA_WIDTH-1:0]   data_out,               // Read Data Out
    output  wire                    data_valid_out,         // Read Data Out Valid
    output  wire                    block_lock_out,         // Block Lock Out (aligned to data_out)
    output  wire                    rd_empty,               // Read empty
    output  wire                    rd_pempty,              // Read partial empty
    output  wire                    rd_pfull,               // Read partial full 
    output  wire                    wr_oflw_err,            // Overflow error
    output  wire [TSWIDTH-1:0]      latency_adj,            // Latency Measurement (6-bit cycle, 10-bit frac. cycle)
    input  wire                     latency_sclk_reset,
    input   wire                    latency_sclk,
    input   wire [11:0]             latency_xcvr_rx,
    output wire                     fifo_insert,            // 10G BaseR Insertion Flag
    output wire                     fifo_del                // 10G BaseR Insertion Flag (Async)
);
    wire rd_req;
    
    // up counter instantiation    
    alt_mge_phy_usxg32_incr_cnt rx_rm_fifo_cnt (
        .clk            (rd_clk),
        .rst_n          (rd_rst_n),
        .soft_reset     (1'b0),
        .valid          (1'b1),
        .speed_mode     (speed_mode),
        .cnt            (),
        .cnt_zero       (rd_req)
    );
    
    alt_mge_phy_usxg32_rx_rm_fifo #(
        .DATA_WIDTH         (DATA_WIDTH),       // PCS data width
        .CONTROL_WIDTH      (CONTROL_WIDTH),    // PCS control width
        .FAWIDTH            (FAWIDTH),          // FIFO Depth (address width) 
        .TSWIDTH            (TSWIDTH),
        .IDWIDTH            (IDWIDTH),          // PCS/PMA IF width
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .ENABLE_IEEE1588    (ENABLE_IEEE1588),
        .OFFSET             (OFFSET)            // PCS latency
    ) rx_rm_fifo_inst (
        // Clock and Reset
        .wr_clk                 (wr_clk),
        .rd_clk                 (rd_clk),
        .sample_clk             (sample_clk),
        .wr_rst_n               (wr_rst_n),
        .rd_rst_n               (rd_rst_n),
        .sample_rst_n           (sample_rst_n),
        
        // Mode
        //r_fifo_mode            (3'b010),

        // Data Sink
        .control_in             (control_in),
        .data_in                (data_in),
        .data_valid_in          (data_valid_in),
        .block_lock_in          (block_lock_in),
        
        // FIFO settings
        .r_pempty               (r_pempty),
        .r_pfull                (r_pfull),
        .r_empty                (r_empty),
        .r_full                 (r_full),
        //.r_truebac2bac          (1'b1),
        .r_write_ctrl           (r_write_ctrl),
        .rd_req                 (rd_req),
        
        // Data Source
        .control_out            (control_out),
        .data_out               (data_out),
        .data_valid_out         (data_valid_out),
        .block_lock_out         (block_lock_out),
        // ED
        .speed_mode             (speed_mode),
        .latency_sclk_reset     (latency_sclk_reset),
        //latency_adj             (latency_adj),      // Latency adjustment for timestamping
        .latency_sclk           (latency_sclk),
        .latency_xcvr_rx        (latency_xcvr_rx),
        // FIFO status signal
        .rd_empty               (rd_empty),
        .rd_pempty              (rd_pempty),
        .rd_pfull               (rd_pfull),
        .wr_oflw_err            (wr_oflw_err),
        .latency_adj            (latency_adj),
        .fifo_insert            (fifo_insert),
        .fifo_del               (fifo_del)
    );

endmodule // alt_mge_phy_usxg32_rx_rm_fifo_top
