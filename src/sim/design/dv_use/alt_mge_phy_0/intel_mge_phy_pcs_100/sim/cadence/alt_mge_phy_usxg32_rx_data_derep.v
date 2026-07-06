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


//------------------------------------------------------------------------
// This module is designed to down-sample the received data based on
// the speed_mode configuration value.  
//------------------------------------------------------------------------

`timescale 1 ps / 1 ps

module alt_mge_phy_usxg32_rx_data_derep
   #(
    parameter DATA_WIDTH      = 'd32,
    parameter CONTROL_WIDTH    = 'd4
     )
     (
    input  wire                           rst_n,              // Write Domain Active low Reset
    input  wire                           clk,                // Write Domain Clock
    input  wire [2:0]                     speed_mode,
    
    input  wire [CONTROL_WIDTH-1:0]       control_in,         // Frame information 
    input  wire [DATA_WIDTH-1:0]          data_in,            // Write Data In
    input  wire                           data_valid_in,      // Write Data In Valid
    input  wire                           block_lock_in,      // Block Lock In (aligned to data_in)

    output  wire [CONTROL_WIDTH-1:0]       control_out,        // Frame information
    output  wire [DATA_WIDTH-1:0]          data_out,           // Read Data Out
    output  wire                           data_valid_out,     // Read Data Out Valid
    output  wire                           block_lock_out      // Block Lock Out (aligned to data_out)
 );
   
    // ------------------------------------------------------------------
    // Parameters
    // ------------------------------------------------------------------
    // localparam XGMII_IDLE        = 8'h07;
    // localparam XGMII_SEQOS       = 8'h9c;
    localparam XGMII_START          = 8'hFB;
    // localparam XGMII_PREAMBLE    = 8'h55;
    // localparam XGMII_SFD         = 8'hD5;
    // localparam XGMII_EFD         = 8'hFD;
    // localparam XGMII_ERROR       = 8'hFE;
    
    // ------------------------------------------------------------------
    // Wires and Registers
    // ------------------------------------------------------------------
    reg [CONTROL_WIDTH-1:0]       control_p1;
    reg [DATA_WIDTH-1:0]          data_p1;
    reg                           data_valid_p1;
    reg                           block_lock_p1;
    
    wire                          start_char;
    wire [9:0]                    cnt;
    wire                          cnt_zero;
    
    // ------------------------------------------------------------------
    // data pipeline 
    // ------------------------------------------------------------------
    always @(negedge rst_n or posedge clk) begin
        if (rst_n == 1'b0) begin
            data_valid_p1    <= 1'b0;
            data_p1          <= 'd0;
            control_p1       <= 'd0;
            block_lock_p1    <= 1'b0;
        end
        else begin
            data_valid_p1    <= data_valid_in;
            data_p1          <= data_in;
            control_p1       <= control_in;
            block_lock_p1    <= block_lock_in;
        end
    end 
    
    // ------------------------------------------------------------------
    // counter
    // ------------------------------------------------------------------
    // counter configurations
    assign start_char = (control_in[0] & data_in[7:0]==XGMII_START) & data_valid_in;
    
    // up counter instantiation    
    alt_mge_phy_usxg32_incr_cnt rx_data_derep_cnt (
        .clk        (clk),
        .rst_n      (rst_n),
        .soft_reset (start_char),
        .valid      (data_valid_in),
        .speed_mode (speed_mode),
        .cnt        (cnt),
        .cnt_zero   (cnt_zero)
    );
    
    // data output - make sure next module (FIFO) will flop input
    assign data_valid_out  = (cnt_zero) ? data_valid_p1 : 1'b0;
    assign data_out        = data_p1;
    assign control_out     = control_p1;
    assign block_lock_out  = block_lock_p1;
   
   
endmodule // alt_mge_phy_usxg32_rx_data_derep
