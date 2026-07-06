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


class eth_testsuite_cl49_comp_base_seq extends eth_base_sequence;
     `uvm_object_utils(eth_testsuite_cl49_comp_base_seq)

bit send_frames = 1;
integer first_case;
integer last_case;
logic send_frames;

 function new(string name = "eth_testsuite_cl49_comp_base_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction

 virtual task pre_body();
 endtask;

virtual task body();
    apply_hard_reset(0,0,1,11);
     `uvm_info("eth_testsuite_cl49_comp_base_seq", "Executing eth_testsuite_cl49_comp_base_seq ...", UVM_LOW)
      
      p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_XSBI_CL49_COMP_TP",first_case,last_case);
      p_sequencer.env.ts_tasks_if.start_testsuite_test();

     // nvs_eth_10g_cl49_tp(first_case,last_case);
        p_sequencer.env.wait_rx_pcs_ready();
       if (send_frames) begin
	t_send_frames();
        end
 //`uvm_info("eth_testsuite_cl49_comp_base_seq",UVM_LOW) 
endtask

 task t_send_frames();
      fork
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
      join
 endtask // send_frames

endclass

//CL49.1.1
class eth_testsuite_cl49__1_1_comp_seq extends eth_testsuite_cl49_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl49__1_1_comp_seq)

  function new(string name = "eth_testsuite_cl49__1_1_comp_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 1;
     last_case = 1;
     send_frames = 0;
  endtask; // pre_body
   
endclass : eth_testsuite_cl49__1_1_comp_seq

//CL49.1.2
class eth_testsuite_cl49__1_2_comp_seq extends eth_testsuite_cl49_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl49__1_2_comp_seq)

  function new(string name = "eth_testsuite_cl49__1_2_comp_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 2;
     last_case = 2;
     send_frames = 0;
  endtask; // pre_body
   
endclass : eth_testsuite_cl49__1_2_comp_seq

//CL49.1.2
class eth_testsuite_cl49__1_3_comp_seq extends eth_testsuite_cl49_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl49__1_3_comp_seq)

  function new(string name = "eth_testsuite_cl49__1_3_comp_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 3;
     last_case = 3;
     send_frames = 0;
  endtask; // pre_body
   
endclass : eth_testsuite_cl49__1_3_comp_seq