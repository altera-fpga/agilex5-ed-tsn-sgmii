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



class eth_testsuite_cl73_comp_base_seq extends eth_base_sequence;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_base_seq)

   integer first_case, last_case;
   uvm_reg_data_t read_data;
   bit 	   send_frames=0;
   bit 	   wait_an_complete=0;
   bit [31:0] an_c0_reg;
   bit 	      an_np_ctrl=0;
   bit  nonce_possibility_en;
           
  function new(string name = "eth_testsuite_cl73_comp_base_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
      `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
    end
    else begin
      first_case = 1;
    end
    if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
      `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
    end
    else begin
      last_case = 1;
    end
     dis_stats_chk=1;
  endfunction:new

  virtual task pre_body();
  endtask; // pre_body
   
  virtual task body();
    apply_hard_reset(0,0,1,11);
     `uvm_info("eth_testsuite_cl73_comp_base_seq", "Executing eth_testsuite_cl73_comp_base_seq ...", UVM_NONE)

     // Configure DUT
     // Set ignore nonce field to 0
       p_sequencer.env.mac_callback.link_trans.an73_transmit_nonce_field=$urandom_range(0,31);
       an_c0_reg = {16'h737D,12'b0,1'b0,an_np_ctrl,1'b0,1'b1};
// FIXME-MISSING_REG_IN_GDR     reg_write(`REGISTERS_an_cfg1_OFFSET_REG,an_c0_reg); 
     // Disable Link training
// FIXME-MISSING_REG_IN_GDR     reg_write(`REGISTERS_lt_cfg1_OFFSET_REG,32'h0);
     p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_AN_CL73_COMP_TP",first_case,last_case);
     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("testsuite_case_select done. first_case=%0d last_case=%0d ...",first_case,last_case), UVM_NONE)
     p_sequencer.env.ts_tasks_if.start_testsuite_test();
     `uvm_info("eth_testsuite_cl73_comp_base_seq", "start_testsuite_test done ...", UVM_NONE)
     check_reset_event();
     check_reg_wr_rd();
     fork
	forever begin
        `ifdef CRETE3
	   p_sequencer.env.nonce_possibility();
        `else
	   p_sequencer.env.nonce_possibility(nonce_possibility_en);
        `endif
	end
     join_none
     #10ns;
     p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
     p_sequencer.env.disable_an_snps_errors();
     
     if (wait_an_complete)
       t_wait_an_complete();
     
     if (send_frames) begin
	p_sequencer.env.wait_rx_pcs_ready();
	t_send_frames();
     end
     `uvm_info("eth_testsuite_cl73_comp_base_seq", "Exiting eth_testsuite_cl73_comp_base_seq ...", UVM_NONE)   
  endtask // body

   task t_send_frames();
      fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
   endtask // send_frames
   
   
   task t_wait_an_complete();
     
     // Wait for AN complete     
     `uvm_info("eth_testsuite_cl73_comp_base_seq", "Wait for AN complete", UVM_NONE)
     read_data=32'h0;
     fork: wait_an_done
// FIXME-MISSING_REG_IN_GDR	while (read_data[`REGISTERS_an_status_an_complete_BITOFFSET_FIELD]==1'b0) begin
// FIXME-MISSING_REG_IN_GDR	   reg_read(.addr(`REGISTERS_an_status_OFFSET_REG),.read_data(read_data),.disable_check(1));
	   #500ns;
	end
	begin
	   #500us;
	   `uvm_error(get_type_name(), $sformatf("AN timeout"));	   
	end
     join_any
     disable wait_an_done;
     `uvm_info("eth_testsuite_cl73_comp_base_seq", "AN complete", UVM_NONE)
     
     ///////////////////// Read and check results in 0xC2 ////////////////////////////////////////
     // Wait for RX idle
    `ifndef CRETE3
     `uvm_info("eth_testsuite_cl73_comp_base_seq", "Wait for RX idle", UVM_NONE)
// FIXME-MISSING_REG_IN_GDR     while (read_data[`REGISTERS_an_status_an_rxsm_idle_BITOFFSET_FIELD]==1'b0) begin
// FIXME-MISSING_REG_IN_GDR	reg_read(.addr(`REGISTERS_an_status_OFFSET_REG),.read_data(read_data),.disable_check(1));
	#100ns;
     end
    `endif
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.EVENT_AN73_COMPLETE.wait_trigger();
     // RF avd ability
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("Remote fault ability advertiized = %0b",read_data[`REGISTERS_an_status_an_adv_remote_fault_BITOFFSET_FIELD]), UVM_NONE)
     // AN Ability
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("AN Ability = %0b",read_data[`REGISTERS_an_status_an_ability_BITOFFSET_FIELD]), UVM_NONE)
// FIXME-MISSING_REG_IN_GDR     if (!read_data[`REGISTERS_an_status_an_ability_BITOFFSET_FIELD])
       `uvm_error(get_type_name(), $sformatf("PHY is not able to perform Auto-Negotiation"));
     // Link status
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("Link Status = %0b",read_data[`REGISTERS_an_status_an_status_BITOFFSET_FIELD]), UVM_NONE)
     // Negotiated FEC ability
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("Negotiated FEC ability = %0b",read_data[`REGISTERS_an_status_baser_fec_negotiated_en_BITOFFSET_FIELD]), UVM_NONE)
     // Seq  AN Failure
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("AN failure = %0b",read_data[`REGISTERS_an_status_an_failure_BITOFFSET_FIELD]), UVM_NONE)     
// FIXME-MISSING_REG_IN_GDR     if (read_data[`REGISTERS_an_status_an_failure_BITOFFSET_FIELD])
       `uvm_error(get_type_name(), $sformatf("AN failure detected"));
     // Negotiation failure
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("Negotiation failure = %0b",read_data[`REGISTERS_an_status_negotiation_failure_BITOFFSET_FIELD]), UVM_NONE)   
// FIXME-MISSING_REG_IN_GDR     if (read_data[`REGISTERS_an_status_negotiation_failure_BITOFFSET_FIELD])
       `uvm_error(get_type_name(), $sformatf("AN Complete, but unable to negotiate HCD (Highest Common Denominator) and FEC mode"));
     // IEEE Negotiated Port Type 
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("IEEE Negotiated Port Type = %0b",read_data[(`REGISTERS_an_status_ieee_negotiated_port_type_BITOFFSET_FIELD+`REGISTERS_an_status_ieee_negotiated_port_type_WIDTH_FIELD-1):`REGISTERS_an_status_ieee_negotiated_port_type_BITOFFSET_FIELD]), UVM_NONE)   
     // RS FEC Negotiated 
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("RS FEC Negotiated = %0b",read_data[`REGISTERS_an_status_rs_fec_negotiated_BITOFFSET_FIELD]), UVM_NONE)   

     ///////////////////// Read and check results in 0xCB /////////////////////////////
// FIXME-MISSING_REG_IN_GDR     reg_read(.addr(`REGISTERS_an_status5_OFFSET_REG),.read_data(read_data),.disable_check(1));
     // AN LP ADV Tech_A
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("AN LP ADV Tech_A[22:0] = %0b",read_data[(`REGISTERS_an_status5_an_lp_adv_tech_a_BITOFFSET_FIELD+`REGISTERS_an_status5_an_lp_adv_tech_a_WIDTH_FIELD-1):`REGISTERS_an_status5_an_lp_adv_tech_a_BITOFFSET_FIELD]), UVM_NONE)
     // AN LP ADV FEC_F
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("AN LP ADV FEC_F[3:0] = %0b",read_data[(`REGISTERS_an_status5_an_lp_adv_fec_f_BITOFFSET_FIELD+`REGISTERS_an_status5_an_lp_adv_fec_f_WIDTH_FIELD-1):`REGISTERS_an_status5_an_lp_adv_fec_f_BITOFFSET_FIELD]), UVM_NONE)
     // AN LP ADV Remote Fault
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("AN LP ADV Remote Fault = %0b",read_data[(`REGISTERS_an_status5_an_lp_adv_remote_fault_BITOFFSET_FIELD+`REGISTERS_an_status5_an_lp_adv_remote_fault_WIDTH_FIELD-1):`REGISTERS_an_status5_an_lp_adv_remote_fault_BITOFFSET_FIELD]), UVM_NONE)
     // AN LP ADV Pause 
// FIXME-MISSING_REG_IN_GDR     `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("AN LP ADV Pause  = %0b",read_data[(`REGISTERS_an_status5_an_lp_adv_pause_BITOFFSET_FIELD+`REGISTERS_an_status5_an_lp_adv_pause_WIDTH_FIELD-1):`REGISTERS_an_status5_an_lp_adv_pause_BITOFFSET_FIELD]), UVM_NONE)
   endtask; // wait_an_complete

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
endclass : eth_testsuite_cl73_comp_base_seq

class eth_testsuite_cl73_comp_seq1 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq1)

  function new(string name = "eth_testsuite_cl73_comp_seq1");
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
   
endclass : eth_testsuite_cl73_comp_seq1

class eth_testsuite_cl73_comp_seq2 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq2)

  function new(string name = "eth_testsuite_cl73_comp_seq2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 2;
     last_case = 2;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq2

class eth_testsuite_cl73_comp_seq3 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq3)

  function new(string name = "eth_testsuite_cl73_comp_seq3");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 3;
     last_case = 3;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq3

class eth_testsuite_cl73_comp_seq4 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq4)

  function new(string name = "eth_testsuite_cl73_comp_seq4");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 4;
     last_case = 4;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq4

class eth_testsuite_cl73_comp_seq5 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq5)

  function new(string name = "eth_testsuite_cl73_comp_seq5");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 5;
     last_case = 5;
     `ifndef CRETE3
       nonce_possibility_en = 0;
     `endif
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq5

class eth_testsuite_cl73_comp_seq6 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq6)

  function new(string name = "eth_testsuite_cl73_comp_seq6");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 6;
     last_case = 6;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq6

class eth_testsuite_cl73_comp_seq7 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq7)

  function new(string name = "eth_testsuite_cl73_comp_seq7");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 7;
     last_case = 7;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq7

class eth_testsuite_cl73_comp_seq8 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq8)

  function new(string name = "eth_testsuite_cl73_comp_seq8");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 8;
     last_case = 8;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq8

class eth_testsuite_cl73_comp_seq9 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq9)

  function new(string name = "eth_testsuite_cl73_comp_seq9");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 9;
     last_case = 9;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq9

class eth_testsuite_cl73_comp_seq10 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq10)

  function new(string name = "eth_testsuite_cl73_comp_seq10");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 10;
     last_case = 10;
     //no_traffic = 1;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq10

class eth_testsuite_cl73_comp_seq11 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq11)

  function new(string name = "eth_testsuite_cl73_comp_seq11");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 11;
     last_case = 11;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq11

class eth_testsuite_cl73_comp_seq12 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq12)

  function new(string name = "eth_testsuite_cl73_comp_seq12");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 12;
     last_case = 12;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq12

class eth_testsuite_cl73_comp_seq13 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq13)

  function new(string name = "eth_testsuite_cl73_comp_seq13");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 13;
     last_case = 13;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq13

class eth_testsuite_cl73_comp_seq14 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq14)

  function new(string name = "eth_testsuite_cl73_comp_seq14");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 14;
     last_case = 14;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq14

class eth_testsuite_cl73_comp_seq15 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq15)

  function new(string name = "eth_testsuite_cl73_comp_seq15");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 15;
     last_case = 15;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq15

class eth_testsuite_cl73_comp_seq16 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq16)

  function new(string name = "eth_testsuite_cl73_comp_seq16");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 16;
     last_case = 16;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq16
class eth_testsuite_cl73_comp_seq17 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq17)

  function new(string name = "eth_testsuite_cl73_comp_seq17");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 17;
     last_case = 17;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq17

class eth_testsuite_cl73_comp_seq18 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq18)

  function new(string name = "eth_testsuite_cl73_comp_seq18");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 18;
     last_case = 18;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq18

class eth_testsuite_cl73_comp_seq19 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq19)

  function new(string name = "eth_testsuite_cl73_comp_seq19");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 19;
     last_case = 19;
     `ifndef CRETE3
       nonce_possibility_en = 0;
     `endif
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq19

class eth_testsuite_cl73_comp_seq24 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq24)

  function new(string name = "eth_testsuite_cl73_comp_seq24");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 24;
     last_case = 24;
     `ifndef CRETE3
       nonce_possibility_en = 0;
     `endif
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq24

class eth_testsuite_cl73_comp_seq25 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq25)

  function new(string name = "eth_testsuite_cl73_comp_seq25");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 25;
     last_case = 25;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq25

class eth_testsuite_cl73_comp_seq26 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq26)

  function new(string name = "eth_testsuite_cl73_comp_seq26");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 26;
     last_case = 26;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq26

class eth_testsuite_cl73_comp_seq27 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq27)

  function new(string name = "eth_testsuite_cl73_comp_seq27");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 27;
     last_case = 27;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq27

class eth_testsuite_cl73_comp_seq28 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq28)

  function new(string name = "eth_testsuite_cl73_comp_seq28");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 28;
     last_case = 28;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq28

class eth_testsuite_cl73_comp_seq29 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq29)

  function new(string name = "eth_testsuite_cl73_comp_seq29");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 29;
     last_case = 29;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq29

class eth_testsuite_cl73_comp_seq30 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq30)

  function new(string name = "eth_testsuite_cl73_comp_seq30");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 30;
     last_case = 30;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq30

class eth_testsuite_cl73_comp_seq31 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq31)

  function new(string name = "eth_testsuite_cl73_comp_seq31");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 31;
     last_case = 31;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq31

class eth_testsuite_cl73_comp_seq32 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq32)

  function new(string name = "eth_testsuite_cl73_comp_seq32");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 32;
     last_case = 32;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq32

class eth_testsuite_cl73_comp_seq33 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq33)

  function new(string name = "eth_testsuite_cl73_comp_seq33");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 33;
     last_case = 33;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq33

class eth_testsuite_cl73_comp_seq34 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq34)

  function new(string name = "eth_testsuite_cl73_comp_seq34");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 34;
     last_case = 34;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq34

class eth_testsuite_cl73_comp_seq35 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq35)

  function new(string name = "eth_testsuite_cl73_comp_seq35");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 35;
     last_case = 35;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq35

class eth_testsuite_cl73_comp_seq36 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq36)

  function new(string name = "eth_testsuite_cl73_comp_seq36");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 36;
     last_case = 36;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq36

class eth_testsuite_cl73_comp_seq37 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq37)

  function new(string name = "eth_testsuite_cl73_comp_seq37");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 37;
     last_case = 37;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq37

class eth_testsuite_cl73_comp_seq38 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq38)

  function new(string name = "eth_testsuite_cl73_comp_seq38");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 38;
     last_case = 38;
     an_np_ctrl=1;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq38

class eth_testsuite_cl73_comp_seq39 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq39)

  function new(string name = "eth_testsuite_cl73_comp_seq39");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 39;
     last_case = 39;
     an_np_ctrl=1;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq39

class eth_testsuite_cl73_comp_seq40 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq40)

  function new(string name = "eth_testsuite_cl73_comp_seq40");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 40;
     last_case = 40;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq40

class eth_testsuite_cl73_comp_seq41 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq41)

  function new(string name = "eth_testsuite_cl73_comp_seq41");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 41;
     last_case = 41;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq41

class eth_testsuite_cl73_comp_seq45 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq45)

  function new(string name = "eth_testsuite_cl73_comp_seq45");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 45;
     last_case = 45;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq45

class eth_testsuite_cl73_comp_seq46 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq46)

  function new(string name = "eth_testsuite_cl73_comp_seq46");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 46;
     last_case = 46;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq46

class eth_testsuite_cl73_comp_seq49 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq49)

  function new(string name = "eth_testsuite_cl73_comp_seq49");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 49;
     last_case = 49;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq49

class eth_testsuite_cl73_comp_seq50 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq50)

  function new(string name = "eth_testsuite_cl73_comp_seq50");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 50;
     last_case = 50;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq50

class eth_testsuite_cl73_comp_seq51 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq51)

  function new(string name = "eth_testsuite_cl73_comp_seq51");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 51;
     last_case = 51;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq51

class eth_testsuite_cl73_comp_seq52 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq52)

  function new(string name = "eth_testsuite_cl73_comp_seq52");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 52;
     last_case = 52;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq52

class eth_testsuite_cl73_comp_seq53 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq53)

  function new(string name = "eth_testsuite_cl73_comp_seq53");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 53;
     last_case = 53;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq53

class eth_testsuite_cl73_comp_seq54 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq54)

  function new(string name = "eth_testsuite_cl73_comp_seq54");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 54;
     last_case = 54;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq54

class eth_testsuite_cl73_comp_seq55 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq55)

  function new(string name = "eth_testsuite_cl73_comp_seq55");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 55;
     last_case = 55;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq55

class eth_testsuite_cl73_comp_seq56 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq56)

  function new(string name = "eth_testsuite_cl73_comp_seq56");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 56;
     last_case = 56;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq56

class eth_testsuite_cl73_comp_seq57 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq57)

  function new(string name = "eth_testsuite_cl73_comp_seq57");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 57;
     last_case = 57;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq57

class eth_testsuite_cl73_comp_seq58 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq58)

  function new(string name = "eth_testsuite_cl73_comp_seq58");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 58;
     last_case = 58;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq58

class eth_testsuite_cl73_comp_seq59 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq59)

  function new(string name = "eth_testsuite_cl73_comp_seq59");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 59;
     last_case = 59;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq59

class eth_testsuite_cl73_comp_seq60 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq60)

  function new(string name = "eth_testsuite_cl73_comp_seq60");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 60;
     last_case = 60;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq60

class eth_testsuite_cl73_comp_seq65 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq65)

  function new(string name = "eth_testsuite_cl73_comp_seq65");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 65;
     last_case = 65;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq65

class eth_testsuite_cl73_comp_seq66 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq66)

  function new(string name = "eth_testsuite_cl73_comp_seq66");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 66;
     last_case = 66;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq66

class eth_testsuite_cl73_comp_seq67 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq67)

  function new(string name = "eth_testsuite_cl73_comp_seq67");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 67;
     last_case = 67;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq67

class eth_testsuite_cl73_comp_seq68 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq68)

  function new(string name = "eth_testsuite_cl73_comp_seq68");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 68;
     last_case = 68;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq68

class eth_testsuite_cl73_comp_seq69 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq69)

  function new(string name = "eth_testsuite_cl73_comp_seq69");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 69;
     last_case = 69;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq69

class eth_testsuite_cl73_comp_seq70 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq70)

  function new(string name = "eth_testsuite_cl73_comp_seq70");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 70;
     last_case = 70;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq70

class eth_testsuite_cl73_comp_seq71 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq71)

  function new(string name = "eth_testsuite_cl73_comp_seq71");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 71;
     last_case = 71;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq71

class eth_testsuite_cl73_comp_seq72 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq72)

  function new(string name = "eth_testsuite_cl73_comp_seq72");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 72;
     last_case = 72;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq72

class eth_testsuite_cl73_comp_seq73 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq73)

  function new(string name = "eth_testsuite_cl73_comp_seq73");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 73;
     last_case = 73;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq73


class eth_testsuite_cl73_comp_seq74 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq74)

  function new(string name = "eth_testsuite_cl73_comp_seq74");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 74;
     last_case = 74;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq74

class eth_testsuite_cl73_comp_seq75 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq75)

  function new(string name = "eth_testsuite_cl73_comp_seq75");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 75;
     last_case = 75;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq75

class eth_testsuite_cl73_comp_seq76 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq76)

  function new(string name = "eth_testsuite_cl73_comp_seq76");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 76;
     last_case = 76;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq76

class eth_testsuite_cl73_comp_seq77 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq77)

  function new(string name = "eth_testsuite_cl73_comp_seq77");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 77;
     last_case = 77;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq77

class eth_testsuite_cl73_comp_seq78 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq78)

  function new(string name = "eth_testsuite_cl73_comp_seq78");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 78;
     last_case = 78;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq78

class eth_testsuite_cl73_comp_seq79 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq79)

  function new(string name = "eth_testsuite_cl73_comp_seq79");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 79;
     last_case = 79;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq79

class eth_testsuite_cl73_comp_seq83 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq83)

  function new(string name = "eth_testsuite_cl73_comp_seq83");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 83;
     last_case = 83;
     `ifndef CRETE3
       nonce_possibility_en = 0;
     `endif
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq83

class eth_testsuite_cl73_comp_seq84 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq84)

  function new(string name = "eth_testsuite_cl73_comp_seq84");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 84;
     last_case = 84;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq84

class eth_testsuite_cl73_comp_seq87 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq87)

  function new(string name = "eth_testsuite_cl73_comp_seq87");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 87;
     last_case = 87;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq87

class eth_testsuite_cl73_comp_seq88 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq88)

  function new(string name = "eth_testsuite_cl73_comp_seq88");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 88;
     last_case = 88;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq88

class eth_testsuite_cl73_comp_seq89 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq89)

  function new(string name = "eth_testsuite_cl73_comp_seq89");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 89;
     last_case = 89;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq89

class eth_testsuite_cl73_comp_seq90 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq90)

  function new(string name = "eth_testsuite_cl73_comp_seq90");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 90;
     last_case = 90;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq90

class eth_testsuite_cl73_comp_seq91 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq91)

  function new(string name = "eth_testsuite_cl73_comp_seq91");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 91;
     last_case = 91;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq91

class eth_testsuite_cl73_comp_seq92 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq92)

  function new(string name = "eth_testsuite_cl73_comp_seq92");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 92;
     last_case = 92;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq92

class eth_testsuite_cl73_comp_seq93 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq93)

  function new(string name = "eth_testsuite_cl73_comp_seq93");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 93;
     last_case = 93;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq93

class eth_testsuite_cl73_comp_seq97 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq97)

  function new(string name = "eth_testsuite_cl73_comp_seq97");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 97;
     last_case = 97;
     an_np_ctrl=1;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq97

class eth_testsuite_cl73_comp_seq101 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq101)

  function new(string name = "eth_testsuite_cl73_comp_seq101");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 101;
     last_case = 101;
     an_np_ctrl=1;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq101

class eth_testsuite_cl73_comp_seq102 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq102)

  function new(string name = "eth_testsuite_cl73_comp_seq102");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 102;
     last_case = 102;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq102

class eth_testsuite_cl73_comp_seq103 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq103)

  function new(string name = "eth_testsuite_cl73_comp_seq103");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 103;
     last_case = 103;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq103

class eth_testsuite_cl73_comp_seq104 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq104)

  function new(string name = "eth_testsuite_cl73_comp_seq104");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 104;
     last_case = 104;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq104

class eth_testsuite_cl73_comp_seq107 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq107)

  function new(string name = "eth_testsuite_cl73_comp_seq107");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 107;
     last_case = 107;
     `ifndef CRETE3
       nonce_possibility_en = 0;
     `endif
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq107

class eth_testsuite_cl73_comp_seq110 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq110)

  function new(string name = "eth_testsuite_cl73_comp_seq110");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 110;
     last_case = 110;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq110

class eth_testsuite_cl73_comp_seq111 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq111)

  function new(string name = "eth_testsuite_cl73_comp_seq111");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 111;
     last_case = 111;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq111


class eth_testsuite_cl73_comp_seq112 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq112)

  function new(string name = "eth_testsuite_cl73_comp_seq112");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 112;
     last_case = 112;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq112

class eth_testsuite_cl73_comp_seq113 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq113)

  function new(string name = "eth_testsuite_cl73_comp_seq113");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 113;
     last_case = 113;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq113


class eth_testsuite_cl73_comp_seq116 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_seq116)

  function new(string name = "eth_testsuite_cl73_comp_seq116");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 116;
     last_case = 116;
  endtask; // pre_body
   
endclass : eth_testsuite_cl73_comp_seq116
