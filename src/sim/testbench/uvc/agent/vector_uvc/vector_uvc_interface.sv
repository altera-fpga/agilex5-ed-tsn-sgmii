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

`ifndef VECTOR_UVC_INTERFACE__SV
`define VECTOR_UVC_INTERFACE__SV

//==============================================================================
// Class: vector_uvc_interface
// This is the interface for vector 
//==============================================================================

interface vector_uvc_interface(input bit clk,input bit rst, input bit clk_tx);
   
   logic  [39:0]  status_data;
   logic  [6:0]   status_error;
   logic          status_valid;
   logic  [39:0]  status_data_tx;
   logic  [6:0]   status_error_tx;
   logic          status_valid_tx;
   logic          end_offpacket;

clocking mon_cb@(posedge clk); 
  input status_data;
  input status_error;
  input status_valid;
  input end_offpacket;
endclocking:mon_cb

clocking mon_cb_tx@(posedge clk_tx); 
  input status_data_tx;
  input status_error_tx;
  input status_valid_tx;
endclocking:mon_cb_tx

modport mon_if(clocking mon_cb,input clk,input rst);
modport mon_if_tx(clocking mon_cb_tx,input clk_tx,input rst);

endinterface: vector_uvc_interface

`endif // VECTOR_UVC_INTERFACE__SV
