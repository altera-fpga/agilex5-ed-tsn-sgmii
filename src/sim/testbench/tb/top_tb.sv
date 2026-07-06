//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

//------------------------------------------------------------------------------
// Module: top_tb
//
// This module is the top_tb module for MUX.
// This is the main include file that has all of the testbenchs.
// This file will be included under this top_tb module.
// Create different top_tb module if you have multiple TB, then set it through
// the config block accordingly.
//
//------------------------------------------------------------------------------

`include "eth_alt_defines.sv"
`include "reset_if.sv"
`include "mstr_slv_intfs.incl"
`include "eth_testsuite_tasks_intf.sv"
`include "svt_ethernet.uvm.pkg"
`include "svt_ethernet_txrx_if.svi"

module top_tb();

   //---------------------------------------------------------------------------
   // Package and includes
   //---------------------------------------------------------------------------
   // UVM methodology
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   // ALTUVM methodology
   import altuvm_pkg::*;
   `include "altuvm_macros.svh"
   import altuvm_avalon_st_test_pkg::*;
   import altuvm_avalon_mm_test_pkg::*;
   import reset_uvc_pkg::*;

   // Ethernet package
   import svt_uvm_pkg::*;
   import svt_ethernet_uvm_pkg::*;
   import svt_axi_uvm_pkg::*;
   //`include "vip_clk_gen.sv"
   //Tasks to call testsuite tasks/events
   `include "eth_testsuite_tasks.sv"

   // AXI package
   //import svt_uvm_pkg::*;
   //import svt_axi_uvm_pkg::*;

   // ALTUVM CRU package
   //import altuvm_cru_pkg::*;
   import tsn_pkg::*;
   import vector_uvc_pkg::*;
   import eth_env_pkg::*;

   initial $display("***** TSN_TB *****");

   // Define the top level DUT and RTB parameters
   `include "tsn_defines.svh"
   `include "tsn_tb_defines.svh"
   `include "params_avmm.sv"
   `include "eth_ipg_chk_defines.vh"

   `TSN_RTB_PARAM_BODY
   `TSN_RTB_PARAM_PRINT

   // Include clock and reset generation information
   //`include "mux_gen_cru.svh"

   // Include tests files here
   //`include "mux_tests_inc.svh"

   // Include testbench file here
   `include "tsn_tb.sv"
   
   //qsys_top qsys_top_i();
   //ghrd_agilex5_top ghrd_agilex5_top_i();

   // Enable UVM Transaction Recording
   function bit enable_transaction_recording();
      if (`altuvm_test_parg("ALTUVM_RECORDING_DETAIL_ON",
         {"Turn on the recording viewing of data objects as transactions ",
         "in waveform GUI"})) begin
         uvm_config_db#(uvm_bitstream_t)::set(null, "*", "recording_detail", UVM_FULL);
         return 1;
      end
      else
         return 0;
   endfunction : enable_transaction_recording

   // Bit which indicate the transaction recording is set or not
   bit recording_enabled = enable_transaction_recording();

   //---------------------------------------------------------------------------
   // Set global time printing format and Call UVM's run_test task
   //---------------------------------------------------------------------------
   initial begin : b_RUN_TEST
      $timeformat(-9, 6, " ns", 18);
      run_test();
   end : b_RUN_TEST

//   // To assign test status into coverage database.
//   // At the beginning of the test, assign the test status as fail,
//   // it will be overwritten at the end of simulation.
//`ifdef VCS
//   initial begin
//      $cm_post(`CM_TEST_STATUS, "fail");
//   end
//`endif
   `ifdef FSDB
   initial begin
      $fsdbDumpfile("test.fsdb");
      $fsdbDumpvars(0,"/","+all");
      $fsdbDumpon;
   end
   `endif
endmodule : top_tb
