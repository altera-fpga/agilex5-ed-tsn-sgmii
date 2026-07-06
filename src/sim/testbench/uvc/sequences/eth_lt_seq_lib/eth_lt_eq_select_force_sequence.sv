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


class eth_lt_eq_select_force_sequence extends eth_lt_base_sequence;
 
  bit[ 11:0] address;
  bit[11:0]  int_seed[4];
  `uvm_object_utils(eth_lt_eq_select_force_sequence)

  function new(string name = "eth_lt_eq_select_force_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
   p_sequencer.env.disable_snps_errors();
   dis_stats_chk = 1;

   int_seed[0] = 'h57E;
   int_seed[1] = 'h645;
   int_seed[2] = 'h72D;
   int_seed[3] = 'h7B6;

   //p_sequencer.env.mac_callback.lane_select = $urandom_range(0,3); vinoth2x
   p_sequencer.env.mac_callback.lane_select = p_sequencer.env.dyn_rcfg_obj_inst.ch_num;
   p_sequencer.env.mac_callback.local_init_seed = $urandom();
   p_sequencer.env.mac_callback.enable_lt_seed_err = 0;

   `ifdef CRETE3
    //`ifdef G25
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
    fork : wait_to_initiate
    begin
       `uvm_info(get_name(), $sformatf("******* Wait for Spico Reset start : 1 ***************"), UVM_NONE);
	//reset_spico_25g;
       `uvm_info(get_name(), $sformatf("******* Wait for Spico Reset start : 2 ***************"), UVM_NONE);
	//reset_spico_25g;
	#200us;
    end
    begin
     	#550us;
       `uvm_info(get_name(), $sformatf("******* Wait for Spico Reset over ***************"), UVM_NONE);
	disable wait_to_initiate;
    end
    join
   end
    //`endif 
   `endif

   `ifdef CRETE3
    //`ifdef G10 
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
     #550us;
   end
    //`endif 
   `endif
   
   //`ifdef G25 
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
      LT_en = 1;
      AN_en = 1;
    end
   //`endif 

   //`ifdef G10 
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
      LT_en = 1;
      AN_en = 1;
    end
   //`endif 
   
   `uvm_info(get_name(), $sformatf("******* ERROR INJECTION ***************"), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT_en                                                      :%0d ",LT_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0d ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.local_init_seed               :%0d ",p_sequencer.env.mac_callback.local_init_seed), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.enable_lt_seed_err            :%0d ",p_sequencer.env.mac_callback.enable_lt_seed_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("**********************************"), UVM_NONE);

   //`ifdef G25 
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
    read_data[7:4] = 3'b101;
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG, read_data);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
       if(read_data[7:4] != 3'b101) begin 
   	  `uvm_error(get_name(), "REGISTERS_anlt_seq_cfg_OFFSET_REG force mode failed");
       end
       else begin
   	  `uvm_info(get_name(), $sformatf(" Force Mode Configured 25G-->10G"),UVM_NONE);
	end
   end
   //`endif

   //`ifdef G10
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
    read_data[7:4] = 3'b001;
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG, read_data);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
       if(read_data[7:4] != 3'b001) begin 
   	  `uvm_error(get_name(), "REGISTERS_anlt_seq_cfg_OFFSET_REG force mode failed");
       end
       else begin
   	  `uvm_info(get_name(), $sformatf(" Force Mode Configured 10G-->25G"),UVM_NONE);
	end
   end
   //`endif

   //`ifdef G25
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
    p_sequencer.env.mac_callback.link_trans.an73_technology_ability_field_user='h04;
    p_sequencer.env.mac_callback.link_trans.an73_break_link_timer = 2750000;
    p_sequencer.env.mac_callback.link_trans.an73_transmit_nonce_field=$urandom_range(0,31);
   //`else
    //p_sequencer.env.mac_callback.link_trans.an73_technology_ability_field_user='h200;
    //p_sequencer.env.mac_callback.link_trans.an73_break_link_timer = 2750000;
    //p_sequencer.env.mac_callback.link_trans.an73_transmit_nonce_field=$urandom_range(0,31);
   //`endif
   end
	
   //`ifndef G100
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G})begin
    enable_disable_lt(LT_en);
   end
   //`endif
   enable_disable_an(AN_en);
   reset_sequencer();

   `uvm_info(get_name(), $sformatf("p_sequencer.env.dyn_rcfg_obj_inst.cl72prbs                  :%0d ",p_sequencer.env.dyn_rcfg_obj_inst.cl72prbs), UVM_NONE);
   //VIP limitation: Case 8001127277,8001116997 
   // VIP does not allow to programe other than ieee poly nomial for cl93/cl72 i.e CL92 cant execute CL72 poly so it wont be tested
   // VIP also not allow to check non-ieee seed checking so error must be demoted when error is injected in perticular lane.
   // so in referance to our RTL, even RTL support different combination of poly vs init seed, not all of them are tested.
   // only practial usage of cl72 and cl93 will be tested.

   if(p_sequencer.env.dyn_rcfg_obj_inst.cl72prbs == 'b1)
   begin
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln0_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln0_OFFSET_REG,{read_data[31:3],'h4});
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln1_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln1_OFFSET_REG,{read_data[31:3],'h4});
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln2_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln2_OFFSET_REG,{read_data[31:3],'h4});
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln3_OFFSET_REG,{read_data[31:3],'h4});
   end
   else
   begin
      //`ifdef G100 vinoth2x
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
       for(int i=0;i<4;i++) begin
         p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[i]=$urandom_range(0,3);
       end
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln0_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln0_OFFSET_REG,{read_data[31:27],int_seed[p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[0]],read_data[15:3],1'b0,p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[0]});
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln1_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln1_OFFSET_REG,{read_data[31:27],int_seed[p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[1]],read_data[15:3],1'b0,p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[1]});
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln2_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln2_OFFSET_REG,{read_data[31:27],int_seed[p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[2]],read_data[15:3],1'b0,p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[2]});
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln3_OFFSET_REG,{read_data[31:27],int_seed[p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[3]],read_data[15:3],1'b0,p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[3]});
        end
     //`endif vinoth2x
     //`ifdef G25 vinoth2x
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
          p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[0]=0;
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_read(`REGISTERS_lt_cfg3_ln0_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR          p_sequencer.env.reg_write(`REGISTERS_lt_cfg3_ln0_OFFSET_REG,{read_data[31:27],int_seed[p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[0]],read_data[15:3],1'b0,p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_cl93_prbs_lane[0]});
        end
     //`endif vinoth2x
   end

   if (p_sequencer.env.mac_callback.enable_lt_seed_err == 1'b1)
   begin
     //case (p_sequencer.env.mac_callback.lane_select)
// FIXME-MISSING_REG_IN_GDR      0: address = `REGISTERS_lt_cfg3_ln0_OFFSET_REG;
// FIXME-MISSING_REG_IN_GDR      1: address = `REGISTERS_lt_cfg3_ln1_OFFSET_REG;
// FIXME-MISSING_REG_IN_GDR      2: address = `REGISTERS_lt_cfg3_ln2_OFFSET_REG;
// FIXME-MISSING_REG_IN_GDR      3: address = `REGISTERS_lt_cfg3_ln3_OFFSET_REG;
     //endcase
     p_sequencer.env.reg_read(address,read_data);
     p_sequencer.env.reg_write(address ,(($urandom() & 'hF800_FFF8) | {5'h0,p_sequencer.env.mac_callback.local_init_seed,13'h0,read_data[2:0]}));
     p_sequencer.env.reg_read(address,read_data);
     `uvm_info(get_name(), $sformatf("Lane%0d selected polynomial            :%0d ",p_sequencer.env.mac_callback.lane_select,read_data[2:0]), UVM_NONE);
     `uvm_info(get_name(), $sformatf("Lane%0d selected seed                  :%0d ",p_sequencer.env.mac_callback.lane_select,read_data[26:16]), UVM_NONE);
    end
          
    wait_for_an_vip_event_force(AN_en);
    //PRBS SEED Error is injected then tx and rx side checker will fire since vip does not support other than IEEE seed value for PRBS pattern.
    //solvnet - 8001127277
    if(p_sequencer.env.mac_callback.enable_lt_seed_err == 1'b1) 
    begin
        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::NOTE);
        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::NOTE);
    end
    //`ifdef G25
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
     p_sequencer.env.reconfig_vip_for_lt_mode();
    end
    //`endif
    
    //`ifdef G10  
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
       p_sequencer.evn.mac_cfg.cfg[0].enable_autoadaptation = 1;
       p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_training_complete_count = 10;
       p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_wait_timer = 15;
       p_sequencer.evn.mac_cfg.cfg[0].autoadaptation_max_wait_timer = 90000000;
       `uvm_info("wait_for_lt_complete", $psprintf("reconfiguring VIP agent config for LT mode:\n",p_sequencer.evn.mac_cfg.cfg[0].print()), UVM_NONE);
       p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.evn.mac_cfg.cfg[0]);
      end
    
     //`endif 
    send_lt_trans_from_vip();

   //`ifdef G100 vinoth2x
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
    fork
       begin
         wait( p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane0 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
         `uvm_info("wait_for_lt_complete", $sformatf("lane 0 up "), UVM_NONE);
// FIXME-MISSING_REG_IN_GDR         reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
       end

       begin
         wait( p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane1 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
         `uvm_info("wait_for_lt_complete", $sformatf("lane 1 up "), UVM_NONE);
// FIXME-MISSING_REG_IN_GDR         reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
       end

       begin
         wait( p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane2 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
         `uvm_info("wait_for_lt_complete", $sformatf("lane 2 up "), UVM_NONE);
// FIXME-MISSING_REG_IN_GDR         reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
       end

       begin
         wait( p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane3 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
         `uvm_info("wait_for_lt_complete", $sformatf("lane 3 up "), UVM_NONE);
// FIXME-MISSING_REG_IN_GDR         reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
       end
    join
     //some time LT does not end gracefully so VIP shouts error for incomplete frame
    disable_lt_rx_checker();
    disable_lt_tx_checker();
// FIXME-MISSING_REG_IN_GDR    reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
  end
  else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
   //`else vinoth2x
      wait( p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane0 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
     `uvm_info("wait_for_lt_complete", $sformatf("lane 0 up "), UVM_NONE);
      p_sequencer.env.disable_snps_errors();
      //`ifdef RSFEC vinoth2x
      if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type) begin
// FIXME-MISSING_REG_IN_GDR      reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h40200);
    end
      //`else vinoth2x
      else begin
// FIXME-MISSING_REG_IN_GDR      reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
    end
      //`endif vinoth2x
// FIXME-MISSING_REG_IN_GDR      reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000007);
    end
   //`endif vinoth2x

    //`ifdef G25
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
     p_sequencer.env.reconfig_vip_for_datamode();
   end
     //`endif 

    //`ifdef G10 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
      p_sequencer.evn.mac_cfg.cfg[0].enable_autoadaptation = 0;
     `uvm_info("reconfig_vip_for_datamode", $psprintf("reconfiguring VIP agent for data xfer",p_sequencer.evn.mac_cfg.cfg[0].print()), UVM_NONE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.evn.mac_cfg.cfg[0]);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
    //`endif
      end

    `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
    wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
    p_sequencer.env.enable_snps_errors();
    
    send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,5);

   endtask
endclass  //Force Mode
