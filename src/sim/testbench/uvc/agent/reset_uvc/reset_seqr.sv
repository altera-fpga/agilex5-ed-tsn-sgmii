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



`ifndef RESET_SEQR__SV
`define RESET_SEQR__SV


typedef class reset_transaction;
class reset_seqr extends uvm_sequencer # (reset_transaction);

   `uvm_component_utils(reset_seqr)
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction:new 
endclass:reset_seqr

`endif // RESET_SEQR__SV
