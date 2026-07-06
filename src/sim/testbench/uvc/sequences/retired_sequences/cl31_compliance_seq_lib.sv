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



class eth_testsuite_cl31_comp_base_seq extends eth1025_base_sequence;
  
  `uvm_object_utils(eth_testsuite_cl31_comp_base_seq)

  integer first_case, last_case;

function new(string name = "eth_testsuite_cl31_comp_base_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
      `uvm_info("eth_testsuite_cl31_comp_base_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
    end
    else begin
      first_case = 1;
    end
    if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
      `uvm_info("eth_testsuite_cl31_comp_base_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
    end
    else begin
      last_case = 1;
    end
     dis_stats_chk=1;
  endfunction:new

   
  virtual task body();
    apply_hard_reset(0,0,1,11);
    p_sequencer.env.wait_rx_pcs_ready();
     `uvm_info("eth_testsuite_cl31_comp_base_seq", "Executing eth_testsuite_cl31_comp_base_seq ...", UVM_NONE)

     p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_FLOW_CNTRL_CL31_COMP_TP",first_case,last_case);
     `uvm_info("eth_testsuite_cl31_comp_base_seq", $psprintf("testsuite_case_select done. first_case=%0d last_case=%0d ...",first_case,last_case), UVM_NONE)
     p_sequencer.env.ts_tasks_if.start_testsuite_test();
     `uvm_info("eth_testsuite_cl31_comp_base_seq", "start_testsuite_test done ...", UVM_NONE)
//     check_reset_event();
//     check_reg_wr_rd();

//    reg_write(`GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), 1);    //0x605   To enable TX Pause/PFC frames
//    reg_read(`GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data);
//    reg_write(`GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), 2'h2); //0x611  To enable TX Flow Control feature
//    reg_read(`GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data);
    reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), 8'hFF);    //0x705   To enable RX Pause/PFC frames
    reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data);
    reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), 1);    //0x706   To enable RX flow control frames
    reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data);

      fork
         p_sequencer.env.ts_tasks_if.monitor_error_event();
         p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
      join_any

	fork
        begin
	send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);
	`uvm_info("data frame seq", "Sending 10 data frames from VIP to AVL ...", UVM_NONE)
	end
	begin
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);
	`uvm_info("data frame seq", "Sending 10 data frames from AVL to VIP ...", UVM_NONE)
	end
	join

	endtask

endclass : eth_testsuite_cl31_comp_base_seq

class eth_testsuite_cl31_comp_seq1 extends eth_testsuite_cl31_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl31_comp_seq1)

  function new(string name = "eth_testsuite_cl31_comp_seq1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 1;
     last_case = 1;
  endtask; // pre_body

  
endclass : eth_testsuite_cl31_comp_seq1

class eth_testsuite_cl31_comp_seq2 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq2)

  function new(string name = "eth_testsuite_cl31_comp_seq2");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 2;
     last_case = 2;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq2

class eth_testsuite_cl31_comp_seq3 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq3)

  function new(string name = "eth_testsuite_cl31_comp_seq3");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 3;
     last_case = 3;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq3

class eth_testsuite_cl31_comp_seq4 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq4)

  function new(string name = "eth_testsuite_cl31_comp_seq4");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 4;
     last_case = 4;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq4

class eth_testsuite_cl31_comp_seq5 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq5)

  function new(string name = "eth_testsuite_cl31_comp_seq5");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 5;
     last_case = 5;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq5

class eth_testsuite_cl31_comp_seq6 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq6)

  function new(string name = "eth_testsuite_cl31_comp_seq6");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 6;
     last_case = 6;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq6

class eth_testsuite_cl31_comp_seq7 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq7)

  function new(string name = "eth_testsuite_cl31_comp_seq7");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 7;
     last_case = 7;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq7

class eth_testsuite_cl31_comp_seq8 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq8)

  function new(string name = "eth_testsuite_cl31_comp_seq8");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 8;
     last_case = 8;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq8

class eth_testsuite_cl31_comp_seq9 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq9)

  function new(string name = "eth_testsuite_cl31_comp_seq9");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 9;
     last_case = 9;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq9

class eth_testsuite_cl31_comp_seq10 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq10)

  function new(string name = "eth_testsuite_cl31_comp_seq10");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 10;
     last_case = 10;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq10

class eth_testsuite_cl31_comp_seq11 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq11)

  function new(string name = "eth_testsuite_cl31_comp_seq11");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 11;
     last_case = 11;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq11

class eth_testsuite_cl31_comp_seq12 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq12)

  function new(string name = "eth_testsuite_cl31_comp_seq12");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 12;
     last_case = 12;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq12

class eth_testsuite_cl31_comp_seq13 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq13)

  function new(string name = "eth_testsuite_cl31_comp_seq13");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 13;
     last_case = 13;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq13

class eth_testsuite_cl31_comp_seq14 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq14)

  function new(string name = "eth_testsuite_cl31_comp_seq14");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 14;
     last_case = 14;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq14

class eth_testsuite_cl31_comp_seq15 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq15)

  function new(string name = "eth_testsuite_cl31_comp_seq15");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 15;
     last_case = 15;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq15

class eth_testsuite_cl31_comp_seq16 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq16)

  function new(string name = "eth_testsuite_cl31_comp_seq16");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 16;
     last_case = 16;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq16

class eth_testsuite_cl31_comp_seq17 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq17)

  function new(string name = "eth_testsuite_cl31_comp_seq17");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 17;
     last_case = 17;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq17

class eth_testsuite_cl31_comp_seq18 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq18)

  function new(string name = "eth_testsuite_cl31_comp_seq18");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 18;
     last_case = 18;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq18

class eth_testsuite_cl31_comp_seq19 extends eth_testsuite_cl31_comp_base_seq;

  `uvm_object_utils(eth_testsuite_cl31_comp_seq19)

  function new(string name = "eth_testsuite_cl31_comp_seq19");
    super.new(name);
        `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 19;
     last_case = 19;
  endtask; // pre_body


endclass : eth_testsuite_cl31_comp_seq19


