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


`ifndef __PACKET_SEQ_SVH__
`define __PACKET_SEQ_SVH__

import uvm_pkg::*;
`include "uvm_macros.svh"
import altuvm_pkg::*;
`include "altuvm_macros.svh"
class packet_seq extends uvm_sequence;
    `uvm_object_utils(packet_seq)
  `uvm_declare_p_sequencer(avst_sequencer)
       function new(string name = "packet_seq");
        super.new(name);
    endfunction : new

   endclass : packet_seq

`endif  // __PACKET_SEQ_SVH__

