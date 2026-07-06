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


`timescale 1ns/1ns

module alt_em10g32_tx_rs_gmii16b_top (
   // Clock and reset
   input clk_gmii,
   input reset_gmii_n,
   input reset_gmii_n_asyn,
   input clk_mac,
   input reset_mac_n,

   // IPG setting
   input [7:0] ipg_value_1g,
   input tx_clkena,
   // Avalon-ST Data path
   input tx_ethfrm_sop,
   input tx_ethfrm_eop,
   input tx_ethfrm_valid,
   output tx_ethfrm_ready,
   input [31:0] tx_ethfrm_data,
   input [1:0] tx_ethfrm_empty,
   input tx_ethfrm_error,
   input [1:0] tx_ethfrm_channel,

   // GMII 16 bit signals
   output [1:0] gmii16b_tx_en,
   output [15:0] gmii16b_tx_d,
   output [1:0] gmii16b_tx_err,
   output [1:0] gmii16b_tx_channel
);
parameter SYNC_RESET_N = 1;

wire tx_ethfrm_sop_int;
wire tx_ethfrm_eop_int;
wire tx_ethfrm_valid_int;
wire tx_ethfrm_ready_int;
wire [31:0] tx_ethfrm_data_int;
wire [1:0] tx_ethfrm_empty_int;
wire tx_ethfrm_error_int;
wire [1:0] tx_ethfrm_channel_int; 

 alt_em10g32_rr_clock_crosser #(
    .NUM_OF_CHANNEL     (5),
    
    .SYMBOLS_PER_BEAT   (4),
    .BITS_PER_SYMBOL    (8),
    .CHANNEL_WIDTH      (2),
    .ERROR_WIDTH        (1),
    .USE_PACKETS        (1),
    
    .FORWARD_SYNC_DEPTH (3),
    .BACKWARD_SYNC_DEPTH(3),
    .SYNC_RESET_N       (SYNC_RESET_N)
) i_gmii16b_tx_clock_crosser (
    
    .in_clk(clk_mac),
    .in_reset_n(reset_mac_n),

    .out_clk(clk_gmii),
    .out_reset_n(reset_gmii_n),

    // sink
    .in_data(tx_ethfrm_data),
    .in_valid(tx_ethfrm_valid),
    .in_ready(tx_ethfrm_ready),
    .in_startofpacket(tx_ethfrm_sop),
    .in_endofpacket(tx_ethfrm_eop),
    .in_error(tx_ethfrm_error),
    .in_empty(tx_ethfrm_empty),
    .in_channel(tx_ethfrm_channel),

    // source
    .out_data(tx_ethfrm_data_int),
    .out_valid(tx_ethfrm_valid_int),
    .out_ready(tx_ethfrm_ready_int),
    .out_startofpacket(tx_ethfrm_sop_int),
    .out_endofpacket(tx_ethfrm_eop_int),
    .out_error(tx_ethfrm_error_int),
    .out_empty(tx_ethfrm_empty_int),
    .out_channel(tx_ethfrm_channel_int)    
); 

/* alt_em10g32_avalon_dc_fifo #(
        .DEVICE_FAMILY      ("Stratix 10"),
        .SYMBOLS_PER_BEAT   (4),
        .BITS_PER_SYMBOL    (8),
        .FIFO_DEPTH         (16),
        .ERROR_WIDTH        (1),
        .CHANNEL_WIDTH      (2)
        .USE_PACKETS        (1)
    ) i_gmii16b_tx_clock_crosser (

        .in_clk(clk_mac),
        .in_reset_n(reset_mac_n),

        .out_clk(clk_gmii),
        .out_reset_n(reset_gmii_n),

        // sink
        .in_data(tx_ethfrm_data),
        .in_valid(tx_ethfrm_valid),
        .in_ready(tx_ethfrm_ready),
        .in_startofpacket(tx_ethfrm_sop),
        .in_endofpacket(tx_ethfrm_eop),
        .in_empty(tx_ethfrm_empty),
        .in_error(tx_ethfrm_error),
        .in_channel(tx_ethfrm_channel),

        // source
        .out_data(tx_ethfrm_data_int),
        .out_valid(tx_ethfrm_valid_int),
        .out_ready(tx_ethfrm_ready_int),
        .out_startofpacket(tx_ethfrm_sop_int),
        .out_endofpacket(tx_ethfrm_eop_int),
        .out_empty(tx_ethfrm_empty_int),
        .out_error(tx_ethfrm_error_int),
        .out_channel(tx_ethfrm_channel_int),

        // streaming in status
        .almost_full_valid(),
        .almost_full_data(),

        // streaming out status
        .almost_empty_valid(),
        .almost_empty_data(),
        
        // in clock
        .in_fill_level(),
        .almost_full_threshold(5'd0),
        
        // out clock
        .out_fill_level(),
        .almost_empty_threshold(5'd2),
        
        .space_avail_data(),
        
        // Latency Measurement
        .sampling_clk(1'b0),
        .sampling_clk_reset_n(1'b0),
        
        .latency_out_clk(1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out()
    ); */

alt_em10g32_tx_rs_gmii16b #(
   .SYNC_RESET_N       (SYNC_RESET_N)
) i_tx_rs_gmii16b (
   // Clock and reset
   .clk (clk_gmii),
   .rst_n (reset_gmii_n_asyn),

   // IPG setting
   .ipg_value_1g (ipg_value_1g),

   // Avalon-ST Data path
   .tx_ethfrm_sop (tx_ethfrm_sop_int),
   .tx_ethfrm_eop (tx_ethfrm_eop_int),
   .tx_ethfrm_valid (tx_ethfrm_valid_int),
   .tx_ethfrm_ready (tx_ethfrm_ready_int),
   .tx_ethfrm_data (tx_ethfrm_data_int),
   .tx_ethfrm_empty (tx_ethfrm_empty_int),
   .tx_ethfrm_error (tx_ethfrm_error_int),
   .tx_ethfrm_channel (tx_ethfrm_channel_int),
   .tx_clkena (tx_clkena),
   // GMII 16 bit signals
   .gmii16b_tx_en (gmii16b_tx_en),
   .gmii16b_tx_d (gmii16b_tx_d),
   .gmii16b_tx_err (gmii16b_tx_err),
   .gmii16b_tx_channel (gmii16b_tx_channel)
);
endmodule
