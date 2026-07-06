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


////=============================================================================================================
///*`ifdef ENABLE_ETH_VIP
//class eth_testsuite_40g_cl31_comp_seq extends eth_base_sequence;
//  
//  `uvm_object_utils(eth_testsuite_40g_cl31_comp_seq)
//
//  integer first_case, last_case;
//  
//  function new(string name = "eth_testsuite_100g_cl81_comp_seq");
//    super.new(name);
//	`ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
//    if($value$plusargs("ETH_FIRST_TEST=%d",first_case))   `uvm_info("eth_testsuite_40g_cl31_comp_seq", $psprintf("First case selected from run define %d",first_case), UVM_LOW)
//    else  first_case = 1;
//    if($value$plusargs("ETH_LAST_TEST=%d",last_case))  `uvm_info("eth_testsuite_100g_cl81_comp_seq", $psprintf("Last case selected from run define %d",last_case), UVM_LOW)
//    else last_case = 19;
//  endfunction:new
//
//  virtual task pre_body();
//  endtask; // pre_body
//   
//  virtual task body();
//    p_sequencer.env.apply_reset("hard",0,0,1,11);
//    `uvm_info("eth_testsuite_40g_cl31_comp_seq", "Executing eth_testsuite_40g_cl31_comp_seq ...", UVM_LOW)
//   p_sequencer.env.reg_write(`REGISTERS_TX_Pause_Enable_OFFSET_REG,1); 
//   p_sequencer.env.reg_write(`REGISTERS_TX_Flow_Control_Select_OFFSET_REG,0);//pause 
//  //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//    `uvm_info("eth_testsuite_40g_cl31_comp_seq", "wait_rx_pcs_ready done ...", UVM_LOW)
//    p_sequencer.env.ts_tasks_if.start_testsuite_test();
//    `uvm_info("eth_testsuite_40g_cl31_comp_seq", "start_testsuite_test done ...", UVM_LOW)
//    p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_FLOW_CNTRL_CL31_TP",first_case,last_case);
//    `uvm_info("eth_testsuite_40g_cl31_comp_seq", $psprintf("testsuite_case_select done. first_case=%0d last_case=%0d ...",first_case,last_case), UVM_LOW)
//      fork
//	 p_sequencer.env.ts_tasks_if.monitor_error_event();
//	 p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
//      join_any
//    `uvm_info("eth_testsuite_40g_cl31_comp_seq", "Exiting eth_testsuite_40g_cl31_comp_seq ...", UVM_LOW)
//  endtask
//endclass : eth_testsuite_40g_cl31_comp_seq
//`endif//ENABLE_ETH_VIP
//*/
