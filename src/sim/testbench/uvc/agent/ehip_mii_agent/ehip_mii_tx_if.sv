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
// $File:
// $Revision:
// $Date: 
// $Author:
// Created by:
//==============================================================================
`ifndef EHIP_MII_TX_IF_SV
`define EHIP_MII_TX_IF_SV
//------------------------------------------------------------------------------
// Interface: ehip_mii_tx_if
//
// This interface defines all the ports of EHIP_MII_TX Agent.
// There are modports and clocking blocks that facilitate the signal toggling.
//
//------------------------------------------------------------------------------
interface ehip_mii_tx_if ();
    // Clocking block's output delay versus the clock period
   parameter real  OUT_DELAY_RATIO = 0.2;
   parameter int   DATA_WIDTH = 64;
   parameter int   CTRL_WIDTH = 8;
   parameter int   NUM_WORDS = 4;
   parameter int   VLD_WIDTH = 1;

   //---------------------------------------------------------------------------
   // Interface signals declaration.
   //---------------------------------------------------------------------------
   logic                   clk;
   logic                   rst_n;

   logic [63:0] data[16];
   logic [7:0]  ctl[16];
   logic [VLD_WIDTH-1:0]   vld;
   logic [VLD_WIDTH-1:0]   rdy;
   logic [VLD_WIDTH-1:0]   mii_dout_tx_lanes_stable;
   logic                   rx_pcs_fully_aligned;
   logic                   rx_dsk_done;
   logic                   rx_am_lock;
   logic                   rx_blk_lock;
   logic                   hip_ready;
   logic[5:0]              dsk_marker;
   logic                   am_insert;
   logic                   cfg_load_done;
   logic                   bfm_rst;
   logic                   am;

   //---------------------------------------------------------------------------
   // Internal Variables and Assignments
   //---------------------------------------------------------------------------
   // Variable which contain the clock cycle's period
   time                    clock_period;

   //---------------------------------------------------------------------------
   // Detecting the clock period automatically
   //---------------------------------------------------------------------------
   initial begin : b_DETECT_CLOCK_PERIOD
      time     start_time;
      // Repeat for every reset de-asserted
      // This is to ensure that the clock is stable
      forever @ (posedge clk) begin
         // Capture the time of the first rising edge
         start_time = $time;
         // Capture the time of the second rising edge and
         // calculate the clock period
         @ (posedge clk);
         clock_period = $time - start_time;
      end
   end : b_DETECT_CLOCK_PERIOD

   //---------------------------------------------------------------------------
   // Clocking block declarations.
   //---------------------------------------------------------------------------
   clocking mst_cb @ (posedge clk);
     // default input #1step output #(clock_period * OUT_DELAY_RATIO);
      output   data;
      output   ctl;
      inout    vld;
      input    rx_pcs_fully_aligned;
      input    rdy;
      input    mii_dout_tx_lanes_stable;
      input    rx_dsk_done;
      input    rx_am_lock;
      input    rx_blk_lock;
      input    hip_ready;
      output   dsk_marker;
      output   am_insert;
      input    cfg_load_done;
      input    bfm_rst;
   endclocking : mst_cb

   clocking mon_cb @ (posedge clk);
      //default input #1step output #(clock_period * OUT_DELAY_RATIO);
      input    data;
      input    ctl;
      input    vld;
      input    rx_pcs_fully_aligned;
      input    rdy;
      input    mii_dout_tx_lanes_stable;
      input    rx_dsk_done;
      input    rx_am_lock;
      input    rx_blk_lock;
      input    hip_ready;
      input    dsk_marker;
      input    am_insert;
      input    cfg_load_done;
      input    bfm_rst;
      input    am;
   endclocking : mon_cb

   //---------------------------------------------------------------------------
   // Modports declaration.
   //---------------------------------------------------------------------------
   modport mst_mp (
      input    clk,
      input    rst_n,
      clocking mst_cb,
      ref      clock_period
   );


endinterface : ehip_mii_tx_if
`endif
