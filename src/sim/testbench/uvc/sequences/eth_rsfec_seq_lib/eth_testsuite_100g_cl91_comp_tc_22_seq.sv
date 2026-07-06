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


class eth_testsuite_100g_cl91_comp_tc_22_seq extends eth_testsuite_100g_cl91_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl91_comp_tc_22_seq)

  function new(string name = "eth_testsuite_100g_cl91_comp_tc_22_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 22;
     last_case = 22;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl91_comp_tc_22_seq
