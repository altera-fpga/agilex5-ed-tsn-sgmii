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


`ifndef RESET_TRANSACTION
`define RESET_TRANSACTION


class reset_transaction extends uvm_sequence_item;

  rand bit assert_transmit_reset=0;
  
  rand bit assert_receiver_reset=0;
  
  rand bit assert_ip_reset=0;

  rand bit assert_reconfig_reset=0;
  rand bit assert_vip_reset = 0;
  
  int transmit_reset_clock_cnt = 10;
  
  int receiver_reset_clock_cnt = 20;
  
  int ip_reset_clock_cnt = 30;
  rand bit hold_reset = 0;

  `uvm_object_utils_begin(reset_transaction) 
    `uvm_field_int(assert_transmit_reset, UVM_ALL_ON)  
    `uvm_field_int(assert_receiver_reset, UVM_ALL_ON)
    `uvm_field_int(assert_ip_reset, UVM_ALL_ON)
    `uvm_field_int(assert_reconfig_reset, UVM_ALL_ON)
    `uvm_field_int(assert_vip_reset, UVM_ALL_ON)
    `uvm_field_int(transmit_reset_clock_cnt, UVM_ALL_ON)
    `uvm_field_int(receiver_reset_clock_cnt, UVM_ALL_ON)
    `uvm_field_int(ip_reset_clock_cnt, UVM_ALL_ON)
    `uvm_field_int(hold_reset, UVM_ALL_ON)
  `uvm_object_utils_end
 
   extern function new(string name = "reset_transaction");
endclass: reset_transaction


function reset_transaction::new(string name = "reset_transaction");
   super.new(name);
endfunction: new

`endif // RESET_TRANSACTION
