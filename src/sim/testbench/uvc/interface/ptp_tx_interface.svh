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


//==============================================================================
// (C) 2011-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
// $File: /data/jbharatk/softip/acds/main/regtest/ip/ethernet/alt_ethernet/testbench/uvc/interface $
// $Revision: #1 $
// $Date: 2017/8/9 $
// $Author: jbharatk $
//==============================================================================

`ifndef PTP_TX_INTERFACE__SV
`define PTP_TX_INTERFACE__SV

//==============================================================================
// Class: ptp_tx_interface
//==============================================================================

interface ptp_tx_interface #(
//VCS coverage off
   //`ifdef LAY__PARAM_ANSI
      //`LAY__PARAM_ANSI
   //parameter                 WIDTH_0_TO_1_BIT_CHANGE                            = 0, 
   //parameter                 WIDTH_7_TO_15_BIT_CHANGE                           = 7,
   //parameter                 WIDTH_6_TO_13_BIT_CHANGE                           = 6,
   //parameter                 WIDTH_15_TO_31_BIT_CHANGE                          = 15,
   //parameter                 WIDTH_95_TO_191_BIT_CHANGE                         = 95,
   //parameter                 WIDTH_4_TO_9_BIT_CHANGE                            = 4
   parameter                 NUM_WORDS                   = 1,
   parameter                 FP_WIDTH                    = 8,
   parameter                 FP_WIDTH_BIT_CHANGE         = (NUM_WORDS < 16) ? FP_WIDTH : (FP_WIDTH*2),
   parameter                 WIDTH_0_TO_1_BIT_CHANGE     = (NUM_WORDS < 16) ?0 : 1, 
   parameter                 WIDTH_7_TO_15_BIT_CHANGE    = (NUM_WORDS < 16) ?7 : 15,
   parameter                 WIDTH_6_TO_13_BIT_CHANGE    = (NUM_WORDS < 16) ?6 : 13,
   parameter                 WIDTH_15_TO_31_BIT_CHANGE   = (NUM_WORDS < 16) ?15 : 31,
   parameter                 WIDTH_95_TO_191_BIT_CHANGE  = (NUM_WORDS < 16) ?95 : 191,
   parameter                 WIDTH_4_TO_9_BIT_CHANGE     = (NUM_WORDS < 16) ?4 : 9   
   
  // `endif
  // parameter   real           OUT_DELAY_RATIO = 0.2
)(input bit tx_clk,input bit rx_clk,input bit rst);
   
   //logic  [95:0]  o_ptp_ets;
   logic  [WIDTH_95_TO_191_BIT_CHANGE:0]  o_ptp_ets;
   logic  [WIDTH_0_TO_1_BIT_CHANGE:0]     o_ptp_ets_valid;
   logic  [FP_WIDTH_BIT_CHANGE-1:0]       o_ptp_ets_fp;
   logic  [WIDTH_4_TO_9_BIT_CHANGE:0]     o_ptp_ets_vl;
   logic  [WIDTH_4_TO_9_BIT_CHANGE:0]     o_ptp_its_vl;
   logic  [WIDTH_95_TO_191_BIT_CHANGE:0]  o_ptp_rx_its;
   logic  [WIDTH_0_TO_1_BIT_CHANGE:0]     o_ptp_rx_sop;
   logic       o_ptp_rx_valid; //Obselete, to be removed
   logic  [WIDTH_0_TO_1_BIT_CHANGE:0]     o_ptp_rx_its_valid;

//TX clock domain
clocking mon_tx_cb@(posedge tx_clk); 
  input o_ptp_ets;
  input o_ptp_ets_valid;
  input o_ptp_ets_fp;
  input o_ptp_ets_vl;
endclocking:mon_tx_cb

//RX clock domain
clocking mon_rx_cb@(posedge rx_clk); 
  input o_ptp_its_vl;
  input o_ptp_rx_its;
  input o_ptp_rx_sop;
  input o_ptp_rx_valid;
  input o_ptp_rx_its_valid;
endclocking:mon_rx_cb

modport mon_if(clocking mon_tx_cb,input tx_clk,input rst);

endinterface: ptp_tx_interface

`endif // PTP_TX_INTERFACE__SV
