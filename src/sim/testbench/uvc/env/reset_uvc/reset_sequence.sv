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


class reset_sequence extends uvm_sequence #(reset_transaction);
  bit assert_transmit_reset=0;
  bit assert_receiver_reset=0;
  bit assert_ip_reset=1;
  bit assert_vip_reset=0;
  bit assert_reconfig_reset=1;
  int transmit_reset_clock_cnt = 11;
  int receiver_reset_clock_cnt = 11 ;
  int ip_reset_clock_cnt = 11;
  bit hold_reset=0;
  
  reset_transaction req;
  `uvm_object_utils(reset_sequence)

  function new(string name = "reset_sequence");
    super.new(name);
  endfunction: new

  virtual task body();
    `uvm_info("reset_sequence", "generating reset packet...",UVM_LOW)
    `uvm_create(req)
    req.assert_transmit_reset    = assert_transmit_reset;
    req.assert_receiver_reset    = assert_receiver_reset;
    req.assert_ip_reset          = assert_ip_reset;
    req.assert_vip_reset         = assert_vip_reset;
    req.assert_reconfig_reset    = assert_reconfig_reset;
    req.transmit_reset_clock_cnt = transmit_reset_clock_cnt;
    req.receiver_reset_clock_cnt = receiver_reset_clock_cnt ;
    req.ip_reset_clock_cnt       = ip_reset_clock_cnt;
    req.hold_reset               = hold_reset;
	
    `uvm_info("reset_sequence", $sformatf("\n %0s",req.sprint()), UVM_DEBUG);
    `uvm_send(req)
  endtask: body
  
  virtual task pre_body();
    `uvm_info("reset_sequence", "RAISE OBJECTION...",UVM_HIGH)
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  endtask: pre_body

  virtual task post_body();
    `uvm_info("reset_sequence", "DROPPING OBJECTION...",UVM_HIGH)
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask: post_body

endclass: reset_sequence
