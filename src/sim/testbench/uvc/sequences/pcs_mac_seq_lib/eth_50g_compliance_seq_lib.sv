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



class eth_testsuite_50g_mode1_base_seq extends eth_base_sequence;
  
   `uvm_object_utils(eth_testsuite_50g_mode1_base_seq)

   integer first_case, last_case;
   bit 	   reg_disable_scram_after_linkup=0;
   uvm_reg_data_t reg_addr;
   uvm_reg_data_t reg_read_data;
   uvm_reg_data_t reg_write_data;
   
   function new(string name = "eth_testsuite_50g_mode1_base_seq");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
      if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
	 `uvm_info("eth_testsuite_50g_mode1_base_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
      end
      else begin
	 first_case = 1;
      end
      if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
	 `uvm_info("eth_testsuite_50g_mode1_base_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
      end
      else begin
	 last_case = 1;
      end
      reg_disable_scram_after_linkup=0;
   endfunction:new
   
   virtual task pre_body();
   endtask; // pre_body
   
   virtual task body();
      apply_hard_reset(0,0,1,11);
      `uvm_info("eth_testsuite_50g_mode1_base_seq", "Executing eth_testsuite_50g_mode1_base_seq ...", UVM_NONE)
      `uvm_info("eth_testsuite_50g_mode1_base_seq", "wait_rx_pcs_ready done ...", UVM_NONE)
      fork 
	 if (reg_disable_scram_after_linkup) begin
	    p_sequencer.env.wait_rx_pcs_ready();
            if((first_case == 11 )&&(last_case == 11))//Shabbir-Need to disable errors before disabling scrambling
            begin 
	      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
	    end
	    p_sequencer.env.ts_tasks_if.wait_for_top_clock(900);	    
	    reg_addr=`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
	    reg_read(reg_addr,reg_read_data);
	    reg_write_data=reg_read_data;
	    reg_write_data[1]=1'b0; // Decrambler bypassed
	    reg_write_data[7]=1'b0; // Scrambler bypassed
	    reg_write(reg_addr,reg_write_data);
	 end
	 begin
	    p_sequencer.env.ts_tasks_if.start_testsuite_test();
	    `uvm_info("eth_testsuite_50g_mode1_base_seq", "start_testsuite_test done ...", UVM_NONE)
	    p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_50G_MODE1_TP",first_case,last_case);
	    `uvm_info("eth_testsuite_50g_mode1_base_seq", $psprintf("testsuite_case_select done. first_case=%0d last_case=%0d ...",first_case,last_case), UVM_NONE)
	 end
      join
      fork
	 p_sequencer.env.ts_tasks_if.monitor_error_event();
	 check_reset_event();
	 p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
	 
      join
      `uvm_info("eth_testsuite_50g_mode1_base_seq", "Exiting eth_testsuite_50g_mode1_base_seq ...", UVM_NONE)
   endtask // body
   
   virtual task check_reset_event();
      fork
	 begin
	    p_sequencer.env.ts_tasks_if.monitor_hard_reset_event();
	    apply_hard_reset(0,0,1,11);
	 end
	 begin
	    while(1) begin
	       #100ns;
	    end
	 end
      join_none
   endtask; // check_reset_event
   
endclass : eth_testsuite_50g_mode1_base_seq

//Class : eth_testsuite_50g_mode1_seq_block_lock_case5
class eth_testsuite_50g_mode1_seq_block_lock_case5 extends eth_testsuite_50g_mode1_base_seq;
  
  `uvm_object_utils(eth_testsuite_50g_mode1_seq_block_lock_case5)

    function new(string name = "eth_testsuite_50g_mode1_seq_block_lock_case5");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 5;
     last_case = 5;
  endtask; // pre_body

endclass : eth_testsuite_50g_mode1_seq_block_lock_case5

//Class : eth_testsuite_50g_mode1_seq_am_lock_case8
class eth_testsuite_50g_mode1_seq_am_lock_case8 extends eth_testsuite_50g_mode1_base_seq;
  
  `uvm_object_utils(eth_testsuite_50g_mode1_seq_am_lock_case8)

    function new(string name = "eth_testsuite_50g_mode1_seq_am_lock_case8");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 8;
     last_case = 8;
  endtask; // pre_body

endclass : eth_testsuite_50g_mode1_seq_am_lock_case8

//Class : eth_testsuite_50g_mode1_seq_deskew_case7
class eth_testsuite_50g_mode1_seq_deskew_case7 extends eth_testsuite_50g_mode1_base_seq;
  
  `uvm_object_utils(eth_testsuite_50g_mode1_seq_deskew_case7)

    function new(string name = "eth_testsuite_50g_mode1_seq_deskew_case7");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 7;
     last_case = 7;
  endtask; // pre_body

endclass : eth_testsuite_50g_mode1_seq_deskew_case7

//Class : eth_testsuite_50g_mode1_seq_reorder_case10
class eth_testsuite_50g_mode1_seq_reorder_case10 extends eth_testsuite_50g_mode1_base_seq;
  
  `uvm_object_utils(eth_testsuite_50g_mode1_seq_reorder_case10)

    function new(string name = "eth_testsuite_50g_mode1_seq_reorder_case10");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 10;
     last_case = 10;
  endtask; // pre_body

endclass : eth_testsuite_50g_mode1_seq_reorder_case10

//Class : eth_testsuite_50g_mode1_seq_scram_case11
class eth_testsuite_50g_mode1_seq_scram_case11 extends eth_testsuite_50g_mode1_base_seq;
  
  `uvm_object_utils(eth_testsuite_50g_mode1_seq_scram_case11)

    function new(string name = "eth_testsuite_50g_mode1_seq_scram_case11");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 11;
     last_case = 11;
     reg_disable_scram_after_linkup=1;
  endtask; // pre_body

endclass : eth_testsuite_50g_mode1_seq_scram_case11
