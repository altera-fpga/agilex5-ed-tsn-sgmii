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


class ptp_link_fault_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;
  bit fault;
  bit mix_rule;
  uvm_reg_data_t read_data, tx_link_reg;
  svt_ethernet_enum_pkg::link_fault_sequence_type_enum local_link_fault_type;
  int node;
  bit link_fault_en,chk_rmt_flt=0;
  int read_cnt=0,random_cnt;



  `uvm_object_utils(ptp_link_fault_sequence)
  function new(string name = "ptp_link_fault_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
    dis_vec_sb();
   
   dis_stats_chk=1;
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //read_data[0]=1;
   //read_data[1]=$urandom_range(0,1);
   //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

   node  = ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G)) ? (($test$plusargs("ETH17A_21"))?17:(($test$plusargs("ETH17A_20"))?18:15)): 
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) ? 7:
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) ? 3:
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) ? 1: 0;

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);

p_sequencer.env.sb_mac_tx_vip_rx.scb_dis=1;
//p_sequencer.env.sb_vip_tx_mac_rx.scb_dis=1;

   //p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
   //p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
   `uvm_info("eth_seq_lib", "running ptp_link_fault_sequence\n",UVM_LOW)
   //mix_rule = $urandom;
   mix_rule = 0;  //V1 frames are not supported for QHIP
   fork
    begin
      repeat(80) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
        std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
        randcase
        1:send_ptp_frame(ptp_op,f_type,1);  
        1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
        endcase
      end
    end
    begin
      repeat(5) begin
       randcase
       1:send_eth_frame_with_fix_size(RANDOM_FRAME,64,1,ETH_VIP_AVL_RX);
       1:send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);  
       endcase
      end
    end
    begin
            repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,$urandom_range(100,500));//sending remote_fault
      `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go high\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
      `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go low\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
      repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,$urandom_range(100,500));//sending local_fault
      `uvm_info("ptp_link_fault_sequence", "Waiting for local_fault to go high\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.local_fault[node] == 1'b1);
      `uvm_info("ptp_link_fault_sequence", "Waiting for local_fault to go low\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.local_fault[node] == 1'b0);
    end  
   join
   #5us;
     // `uvm_info("ptp_link_fault_sequence", "Done 1\n",UVM_LOW)
      `uvm_info("ptp_link_fault_sequence", "Disabling mac_tx_vip_rx scb\n",UVM_LOW)

//p_sequencer.env.sb_mac_tx_vip_rx.scb_dis=1;


   fork
    begin
      repeat(50) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
        std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
        randcase
        1:send_ptp_frame(ptp_op,f_type,1);  
        1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
        endcase
      end
    end
    begin
      repeat(5) begin
       randcase
       1:send_eth_frame_with_fix_size(RANDOM_FRAME,64,1,ETH_VIP_AVL_RX);
       1:send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);  
       endcase
      end
    end
    begin
      repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,$urandom_range(100,500));//sending remote_fault
      `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go high\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
      `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go low\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
      repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      repeat($urandom_range(1,3)) begin
        fault = $urandom_range(0,1);
        if(fault) begin 
          local_link_fault_type = svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT; end
        else begin
          local_link_fault_type = svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT; end
        repeat($urandom_range(200,300)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
        send_link_fault(local_link_fault_type,$urandom_range(100,500));
        if(fault==1) begin
          `uvm_info("ptp_link_fault_sequence", "Waiting for local_fault to go high\n",UVM_LOW)
          wait(p_sequencer.env.spy_if.local_fault[node] == 1'b1);
          `uvm_info("ptp_link_fault_sequence", "Waiting for local_fault to go low\n",UVM_LOW)
          wait(p_sequencer.env.spy_if.local_fault[node] == 1'b0);
	end
        else begin
          `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go high\n",UVM_LOW)
          wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
          `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go low\n",UVM_LOW)
          wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
        end
        repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      end
    end  
   join
   
    #5us;
    
   endtask
endclass : ptp_link_fault_sequence
