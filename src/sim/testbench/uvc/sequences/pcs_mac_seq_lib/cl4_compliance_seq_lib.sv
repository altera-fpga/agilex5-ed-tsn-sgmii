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


class eth_testsuite_1g_cl4_comp_seq extends eth_base_sequence;
  
  `uvm_object_utils(eth_testsuite_1g_cl4_comp_seq)

   integer first_case, last_case;
   bit 	  ber_test;
   bit [31:0] an_c0_reg;
   bit [31:0] an_b0_reg;
     
  function new(string name = "eth_testsuite_1g_cl4_comp_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
      `uvm_info("eth_testsuite_1g_cl4_comp_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
    end
    else begin
      first_case = 1;
    end
    if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
      `uvm_info("eth_testsuite_1g_cl4_comp_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
    end
    else begin
      last_case = 1;
    end
     ber_test=0;
  endfunction:new

  virtual task pre_body();
  endtask; // pre_body
   
   
  virtual task body();
      `uvm_info("eth_testsuite_1g_cl4_comp_seq", "Exiting eth_testsuite_1g_cl4_comp_seq ...", UVM_NONE)
      endtask // body

endclass : eth_testsuite_1g_cl4_comp_seq
class eth_testsuite_1g_cl4_comp_seq2 extends eth_testsuite_1g_cl4_comp_seq;
  
  `uvm_object_utils(eth_testsuite_1g_cl4_comp_seq2)

  function new(string name = "eth_testsuite_1g_cl4_comp_seq2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
  endtask; // pre_body
   
endclass : eth_testsuite_1g_cl4_comp_seq2
