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


// --------------------------------------------------------------------------------
//| Avalon Streaming Data Format Adapter
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module sideband_adapter # ( 
      parameter TSTAMP_FP_WIDTH = 4
) ( 
      // Interface: clk
      input wire             tx_clk,
      input wire             rx_clk,
      // Interface: reset
      input wire             tx_reset_n,
      input wire             rx_reset_n,
      
      
      // TX 1588 signals
      output wire [95:0]                 out_tx_egress_timestamp_96b_data,
      output wire                        out_tx_egress_timestamp_96b_valid,
      output wire [TSTAMP_FP_WIDTH-1:0]  out_tx_egress_timestamp_96b_fingerprint,
      output wire [63:0]                 out_tx_egress_timestamp_64b_data,
      output wire                        out_tx_egress_timestamp_64b_valid,
      output wire [TSTAMP_FP_WIDTH-1:0]  out_tx_egress_timestamp_64b_fingerprint,

      input  wire [95:0]                 in_tx_egress_timestamp_96b_data,
      input  wire                        in_tx_egress_timestamp_96b_valid,
      input  wire [TSTAMP_FP_WIDTH-1:0]  in_tx_egress_timestamp_96b_fingerprint,
      input  wire [63:0]                 in_tx_egress_timestamp_64b_data,
      input  wire                        in_tx_egress_timestamp_64b_valid,
      input  wire [TSTAMP_FP_WIDTH-1:0]  in_tx_egress_timestamp_64b_fingerprint,

      //TX Status Signals
      input wire                         in_avalon_st_txstatus_valid,
      input wire [39:0]                  in_avalon_st_txstatus_data,
      input wire [6:0]                   in_avalon_st_txstatus_error,

      output  wire                       out_avalon_st_txstatus_valid,
      output  wire [39:0]                out_avalon_st_txstatus_data,
      output  wire [6:0]                 out_avalon_st_txstatus_error,
      
      //TX PFC Status Signals
      input wire  [15:0]                 in_avalon_st_tx_pfc_data,       
      output wire                        out_avalon_st_tx_pfc_status_valid,
      output wire  [15:0]                out_avalon_st_tx_pfc_status,

      output wire [15:0]                 out_avalon_st_tx_pfc_data,       
      input  wire                        in_avalon_st_tx_pfc_status_valid,
      input  wire [15:0]                 in_avalon_st_tx_pfc_status,    

	  // TX Pause Data
	  input wire [1:0]					 in_avalon_st_tx_pause_data,
	  output wire [1:0]					 out_avalon_st_tx_pause_data,

      // Pause Quanta (For TX only variant)
      input  wire                        in_avalon_st_tx_pause_length_valid,
      input  wire [15:0]                 in_avalon_st_tx_pause_length_data,
      
      output  wire                        out_avalon_st_tx_pause_length_valid,
      output  wire [15:0]                 out_avalon_st_tx_pause_length_data,         

      //RX PFC Status Signals
      input  wire [7:0]                  in_avalon_st_rx_pfc_pause_data,
      input  wire                        in_avalon_st_rx_pfc_status_valid,
      input  wire [15:0]                 in_avalon_st_rx_pfc_status_data,      
      
      output wire [7:0]                  out_avalon_st_rx_pfc_pause_data,
      output wire                        out_avalon_st_rx_pfc_status_valid,
      output wire [15:0]                 out_avalon_st_rx_pfc_status_data,

      // Pause Quanta (For RX only variant)
      input wire                        in_avalon_st_rx_pause_length_valid,
      input wire [15:0]                 in_avalon_st_rx_pause_length_data,  
      
      output wire                        out_avalon_st_rx_pause_length_valid,
      output wire [15:0]                 out_avalon_st_rx_pause_length_data          

);

sideband_adapter_tx # ( 
      .TSTAMP_FP_WIDTH(TSTAMP_FP_WIDTH)
) xsideband_adapter_tx ( 
      .clk(tx_clk),
      .reset_n(tx_reset_n),      
      .out_tx_egress_timestamp_96b_data(out_tx_egress_timestamp_96b_data),
      .out_tx_egress_timestamp_96b_valid(out_tx_egress_timestamp_96b_valid),
      .out_tx_egress_timestamp_96b_fingerprint(out_tx_egress_timestamp_96b_fingerprint),
      .out_tx_egress_timestamp_64b_data(out_tx_egress_timestamp_64b_data),
      .out_tx_egress_timestamp_64b_valid(out_tx_egress_timestamp_64b_valid),
      .out_tx_egress_timestamp_64b_fingerprint(out_tx_egress_timestamp_64b_fingerprint),
      .in_tx_egress_timestamp_96b_data(in_tx_egress_timestamp_96b_data),
      .in_tx_egress_timestamp_96b_valid(in_tx_egress_timestamp_96b_valid),
      .in_tx_egress_timestamp_96b_fingerprint(in_tx_egress_timestamp_96b_fingerprint),
      .in_tx_egress_timestamp_64b_data(in_tx_egress_timestamp_64b_data),
      .in_tx_egress_timestamp_64b_valid(in_tx_egress_timestamp_64b_valid),
      .in_tx_egress_timestamp_64b_fingerprint(in_tx_egress_timestamp_64b_fingerprint),
      .in_avalon_st_txstatus_valid(in_avalon_st_txstatus_valid),
      .in_avalon_st_txstatus_data(in_avalon_st_txstatus_data),
      .in_avalon_st_txstatus_error(in_avalon_st_txstatus_error),
      .out_avalon_st_txstatus_valid(out_avalon_st_txstatus_valid),
      .out_avalon_st_txstatus_data(out_avalon_st_txstatus_data),
      .out_avalon_st_txstatus_error(out_avalon_st_txstatus_error),
      .in_avalon_st_tx_pfc_data(in_avalon_st_tx_pfc_data),
	  .in_avalon_st_tx_pause_data(in_avalon_st_tx_pause_data),	  
      .out_avalon_st_tx_pause_data(out_avalon_st_tx_pause_data),
      .out_avalon_st_tx_pfc_status_valid(out_avalon_st_tx_pfc_status_valid),
      .out_avalon_st_tx_pfc_status(out_avalon_st_tx_pfc_status),
      .out_avalon_st_tx_pfc_data(out_avalon_st_tx_pfc_data),       
      .in_avalon_st_tx_pfc_status_valid(in_avalon_st_tx_pfc_status_valid),
      .in_avalon_st_tx_pfc_status(in_avalon_st_tx_pfc_status),
      .in_avalon_st_tx_pause_length_valid(in_avalon_st_tx_pause_length_valid),
      .in_avalon_st_tx_pause_length_data(in_avalon_st_tx_pause_length_data),
      .out_avalon_st_tx_pause_length_valid(out_avalon_st_tx_pause_length_valid),
      .out_avalon_st_tx_pause_length_data(out_avalon_st_tx_pause_length_data)       
);

sideband_adapter_rx xsideband_adapter_rx( 
      .clk(rx_clk),
      .reset_n(rx_reset_n),
      .in_avalon_st_rx_pfc_pause_data(in_avalon_st_rx_pfc_pause_data),
      .in_avalon_st_rx_pfc_status_valid(in_avalon_st_rx_pfc_status_valid),
      .in_avalon_st_rx_pfc_status_data(in_avalon_st_rx_pfc_status_data),      
      .out_avalon_st_rx_pfc_pause_data(out_avalon_st_rx_pfc_pause_data),
      .out_avalon_st_rx_pfc_status_valid(out_avalon_st_rx_pfc_status_valid),
      .out_avalon_st_rx_pfc_status_data(out_avalon_st_rx_pfc_status_data),
      .in_avalon_st_rx_pause_length_valid(in_avalon_st_rx_pause_length_valid),
      .in_avalon_st_rx_pause_length_data(in_avalon_st_rx_pause_length_data),  
      .out_avalon_st_rx_pause_length_valid(out_avalon_st_rx_pause_length_valid),
      .out_avalon_st_rx_pause_length_data(out_avalon_st_rx_pause_length_data)        
);

endmodule

