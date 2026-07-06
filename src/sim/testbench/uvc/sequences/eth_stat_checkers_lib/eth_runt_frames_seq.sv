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


class eth_runt_frames_seq extends eth_stat_base_sequence;
  eth_packet req;
  int rx_pkt_cnt=0;
  time timeout=200us;

  `uvm_object_utils(eth_runt_frames_seq)
  
   `ifdef ENABLE_ETH_VIP
   alt_eth_error_vip_base_sequence err_seq;
   svt_ethernet_transaction_exception_list exception_list;   
   svt_ethernet_transaction_exception exception;
   `endif
   bit 	en_runt_packet=1'b1;
   uvm_reg_data_t rd_data;
  
   function new(string name = "eth_runt_frames_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    
     // eth_stat_base_sequence has few MAC register accessing- will be
     // unimplemented in NONMAC modes
     super.body();
     dis_stats_chk=1;
     `uvm_info("eth_runt_frames_seq", "wait_rx_pcs_ready done ...", UVM_NONE)
      p_sequencer.env.sb_mac_tx_vip_rx.sip_limit=1;
     `uvm_info("instance number",$sformatf("ip instance number is ip%0d",p_sequencer.env.spy_if.inst_num),UVM_NONE);
      // packet_stall is used to find the gap between two packets.
      //  if the gap between two packets are less than 4O packets are dropped its RX MAC Adapter limitations for avst interface.  
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G && p_sequencer.env.dyn_rcfg_obj_inst.mode inside {PCSMAC}) p_sequencer.env.eth_ref_model_inst.packet_stall=1;
      num_of_frames=100;
      en_runt_packet=1;
    `ifdef ENABLE_ETH_VIP
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_broadcast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_ipg_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_four_idle_c_char_or_seq_os_not_before_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);

       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
       if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {FLEXE,OTN}) begin
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
       exception = new();
       ///** Create the exception list */
       exception_list = new("exception_list", exception);
    `endif
    if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {MACSEG,PCSMAC}) begin
      
      // setting preamble and crc pass 1 so that drop frmae size reduce to 9
	     p_sequencer.env.reg_read(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
		 rd_data[0] =0;
		 p_sequencer.env.reg_write(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
    end 
      
	// Send frames
    `ifdef ENABLE_ETH_VIP
          err_seq.send_error_frame(exception_list,num_of_frames,.ifg(12),.en_runt_packet(en_runt_packet),.one_exception(1'b1));
    `endif
	#20us;
	`uvm_info("runt_seq", $sformatf("wating for wait_client_rx_frames_done to become 1"), UVM_MEDIUM);
	`uvm_info("runt_seq", $sformatf("vip_tx_count from sequence is %0d and drop_count is %0d",p_sequencer.env.eth_ref_model_inst.vip_tx_count,p_sequencer.env.eth_ref_model_inst.drop_count), UVM_MEDIUM);
	  p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(200us));
	`uvm_info("runt_seq", $sformatf("vip_tx_count from sequence is %0d and drop_count is %0d",p_sequencer.env.eth_ref_model_inst.vip_tx_count,p_sequencer.env.eth_ref_model_inst.drop_count), UVM_MEDIUM);

     #2us;
      `uvm_info("body", "Exiting ...", UVM_MEDIUM);
          
  endtask
endclass
