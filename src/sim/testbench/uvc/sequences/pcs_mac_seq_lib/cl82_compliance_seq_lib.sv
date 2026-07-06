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



class eth_testsuite_100g_cl82_comp_seq extends eth_base_sequence;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq)

   integer first_case, last_case;
   bit 	  ber_test;
   bit [31:0] an_c0_reg;
   bit [31:0] an_b0_reg;
     
  function new(string name = "eth_testsuite_100g_cl82_comp_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
      `uvm_info("eth_testsuite_100g_cl82_comp_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
    end
    else begin
      first_case = 1;
    end
    if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
      `uvm_info("eth_testsuite_100g_cl82_comp_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
    end
    else begin
      last_case = 1;
    end
     ber_test=0;
  endfunction:new

  virtual task pre_body();
  endtask; // pre_body
   
    `ifdef ANLT
   task restart_vip_for_anlt_link_loss();
      forever begin
	 @ (p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready);
	 if (p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==0) begin
	    `uvm_info(get_type_name(), "Resetting VIP + DUT for ANLT", UVM_NONE)
	    reset_vip();
	    p_sequencer.env.reconfig_vip_for_an_mode();
	    #5us;
	    setup_anlt();
	    p_sequencer.env.wait_for_an_complete();
	    p_sequencer.env.wait_for_lt_complete();	    
	 end	   
      end
   endtask // restart_vip_for_anlt_link_loss
    `endif
   
  virtual task body();
     apply_hard_reset(0,0,1,11);
    `ifdef ANLT
     setup_anlt();
     p_sequencer.env.wait_for_an_complete(); 
     p_sequencer.env.wait_for_lt_complete();
     fork
	restart_vip_for_anlt_link_loss();
     join_none;
    `endif
    `uvm_info("eth_testsuite_100g_cl82_comp_seq", "Executing eth_testsuite_100g_cl82_comp_seq ...", UVM_NONE)
    //p_sequencer.env.wait_rx_pcs_ready();
    `uvm_info("eth_testsuite_100g_cl82_comp_seq", "wait_rx_pcs_ready done ...", UVM_NONE)
    p_sequencer.env.ts_tasks_if.start_testsuite_test();
    `uvm_info("eth_testsuite_100g_cl82_comp_seq", "start_testsuite_test done ...", UVM_NONE)
    p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_10G_MULTILANE_CL82_COMP_TP",first_case,last_case);
    `uvm_info("eth_testsuite_100g_cl82_comp_seq", $psprintf("testsuite_case_select done. first_case=%0d last_case=%0d ...",first_case,last_case), UVM_NONE)
      fork
	 if (ber_test==1'b1) begin
	    p_sequencer.env.wait_rx_pcs_ready();
	    reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1000); 
	 end
	 p_sequencer.env.ts_tasks_if.monitor_error_event();
	 check_reset_event();
	 p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
	 
      join
    `uvm_info("eth_testsuite_100g_cl82_comp_seq", "Exiting eth_testsuite_100g_cl82_comp_seq ...", UVM_NONE)
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
   
endclass : eth_testsuite_100g_cl82_comp_seq

//Class : eth_testsuite_100g_cl82_comp_seq_sanity
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_sanity extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_sanity)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_sanity");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 1;
     last_case = 2;
  endtask; // pre_body
   
endclass : eth_testsuite_100g_cl82_comp_seq_sanity

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock1
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock1 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock1)

    function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 3;
     last_case = 3;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock1

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock2
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock2 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock2)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 4;
     last_case = 4;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock2

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock3
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock3 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock3)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock3");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 5;
     last_case = 5;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock3

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock4
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock4 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock4)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock4");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 6;
     last_case = 6;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock4

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock5
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock5 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock5)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock5");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 7;
     last_case = 7;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock5

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock6
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock6 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock6)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock6");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 8;
     last_case = 8;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock6

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock7
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock7 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock7)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock7");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 9;
     last_case = 9;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock7

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock8
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock8 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock8)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock8");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 10;
     last_case = 10;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock8

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock9
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock9 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock9)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock9");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 11;
     last_case = 11;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock9

//Class : eth_testsuite_100g_cl82_comp_seq_block_lock10
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_block_lock10 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_block_lock10)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_block_lock10");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 74;
     last_case = 74;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_block_lock10

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock1
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock1 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock1)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 12;
     last_case = 12;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock1

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock2
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock2 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock2)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 13;
     last_case = 13;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock2

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock3
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock3 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock3)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock3");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 14;
     last_case = 14;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock3

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock4
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock4 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock4)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock4");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 15;
     last_case = 15;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock4

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock5
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock5 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock5)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock5");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 16;
     last_case = 16;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock5

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock6
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock6 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock6)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock6");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 17;
     last_case = 17;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock6

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock7
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock7 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock7)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock7");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 18;
     last_case = 18;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock7

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock8
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock8 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock8)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock8");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 19;
     last_case = 19;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock8

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock9
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock9 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock9)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock9");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 20;
     last_case = 20;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock9

//Class : eth_testsuite_100g_cl82_comp_seq_am_lock10
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_am_lock10 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_am_lock10)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_am_lock10");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 78;
     last_case = 78;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_am_lock10

//Class : eth_testsuite_100g_cl82_comp_seq_decoder1
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_decoder1 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_decoder1)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_decoder1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 22;
     last_case = 22;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_decoder1

//Class : eth_testsuite_100g_cl82_comp_seq_decoder2
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_decoder2 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_decoder2)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_decoder2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 34;
     last_case = 34;
     
     p_sequencer.env.eth_ref_model_inst.malformed_test_rx=1'b1;      
     p_sequencer.env.decoder_sb.sb_enabled=1'b1;
     p_sequencer.env.decoder_sb.ignore_bn_frames=1'b1;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_decoder2

//Class : eth_testsuite_100g_cl82_comp_seq_deskew1
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_deskew1 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_deskew1)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_deskew1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 23;
     last_case = 23;
     p_sequencer.env.tb_cfg.skew_test = 1;
     `uvm_info(get_type_name(), $sformatf("Setting skew_test in config :%d", p_sequencer.env.tb_cfg.skew_test), UVM_LOW)
     p_sequencer.env.tb_cfg.enable_stas_count = 0;
     `uvm_info(get_type_name(), $sformatf("Setting enable_stas_count in config :%d", p_sequencer.env.tb_cfg.enable_stas_count), UVM_LOW)
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_deskew1

//Class : eth_testsuite_100g_cl82_comp_seq_deskew2
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_deskew2 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_deskew2)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_deskew2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 69;
     last_case = 69;
     p_sequencer.env.tb_cfg.skew_test = 1;
     `uvm_info(get_type_name(), $sformatf("Setting skew_test in config :%d", p_sequencer.env.tb_cfg.skew_test), UVM_LOW)
     p_sequencer.env.tb_cfg.enable_stas_count = 0;
     `uvm_info(get_type_name(), $sformatf("Setting enable_stas_count in config :%d", p_sequencer.env.tb_cfg.enable_stas_count), UVM_LOW)
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_deskew2

//Class : eth_testsuite_100g_cl82_comp_seq_deskew3
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_deskew3 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_deskew3)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_deskew3");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 29;
     last_case = 29;
     p_sequencer.env.tb_cfg.skew_test = 1;
     `uvm_info(get_type_name(), $sformatf("Setting skew_test in config :%d", p_sequencer.env.tb_cfg.skew_test), UVM_LOW)
     p_sequencer.env.tb_cfg.enable_stas_count = 0;
     `uvm_info(get_type_name(), $sformatf("Setting enable_stas_count in config :%d", p_sequencer.env.tb_cfg.enable_stas_count), UVM_LOW)
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_deskew3

//Class : eth_testsuite_100g_cl82_comp_seq_reorder1
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_reorder1 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_reorder1)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_reorder1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 24;
     last_case = 24;
     p_sequencer.env.tb_cfg.skew_test = 1;
     `uvm_info(get_type_name(), $sformatf("Setting skew_test in config :%d", p_sequencer.env.tb_cfg.skew_test), UVM_LOW)
     p_sequencer.env.tb_cfg.enable_stas_count = 0;
     `uvm_info(get_type_name(), $sformatf("Setting enable_stas_count in config :%d", p_sequencer.env.tb_cfg.enable_stas_count), UVM_LOW)
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_reorder1

//Class : eth_testsuite_100g_cl82_comp_seq_reorder2
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_reorder2 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_reorder2)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_reorder2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 25;
     last_case = 25;
     p_sequencer.env.tb_cfg.skew_test = 1;
     `uvm_info(get_type_name(), $sformatf("Setting skew_test in config :%d", p_sequencer.env.tb_cfg.skew_test), UVM_LOW)
     p_sequencer.env.tb_cfg.enable_stas_count = 0;
     `uvm_info(get_type_name(), $sformatf("Setting enable_stas_count in config :%d", p_sequencer.env.tb_cfg.enable_stas_count), UVM_LOW)
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_reorder2

//Class : eth_testsuite_100g_cl82_comp_seq_scrambler1
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_scrambler1 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_scrambler1)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_scrambler1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 26;
     last_case = 26;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_scrambler1

//Class : eth_testsuite_100g_cl82_comp_seq_descrambler1
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_descrambler1 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_descrambler1)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_descrambler1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 65;
     last_case = 65;
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_rsvrd_opcode_field_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_broadcast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_null_reserved_vlan_id_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_descrambler1

//Class : eth_testsuite_100g_cl82_comp_seq_fcs1
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_fcs1 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_fcs1)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_fcs1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 66;
     last_case = 66;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_fcs1

//Class : eth_testsuite_100g_cl82_comp_seq_fcs2
//This sequence can be used to run CL82 PCS compliance testsuite (ETH_10G_MULTILANE_CL82_COMP_TP)
class eth_testsuite_100g_cl82_comp_seq_fcs2 extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_fcs2)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_fcs2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 73;
     last_case = 73;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_fcs2

class eth_testsuite_100g_cl82_comp_seq_BIP extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_BIP)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_BIP");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 70;
     last_case = 70;
  endtask; // pre_body

endclass : eth_testsuite_100g_cl82_comp_seq_BIP

class eth_testsuite_100g_cl82_comp_seq_ber extends eth_testsuite_100g_cl82_comp_seq;
  
  `uvm_object_utils(eth_testsuite_100g_cl82_comp_seq_ber)

  function new(string name = "eth_testsuite_100g_cl82_comp_seq_ber");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 71;
     last_case = 71;
     ber_test=1;
  endtask; // pre_body

  virtual task post_body();
    uvm_hdl_release("eth_env_top.assertion_on_off_reset");
  endtask // post_body
endclass : eth_testsuite_100g_cl82_comp_seq_ber

