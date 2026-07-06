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


class vip_decoder_sequence17_to_19 extends vip_error_base_sequence;
      
   `uvm_object_utils(vip_decoder_sequence17_to_19)
     alt_eth_error_vip_base_sequence err_seq;
   
   function new(string name = "vip_decoder_sequence17_to_19");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
   endfunction:new

   virtual task body();
      
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);  
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);      
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);     
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_multilane_high_ber.set_default_fail_effect(svt_err_check_stats::IGNORE);
            // disable VIP TX checker
      //Since we are inserting the exception from tx side disabling the checkers 
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
        //bit 0: (set t0 0 to disable checker on tx side)
        //bit 1: (set t0 0 to disable checker on rx side)
        //bit 2: (set t0 0 to disable checker on checker arbiter)
        p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b000);

      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G,_40G,_50G,_100G}) begin
     // p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),2000); // Configuring BER timer for 2000 clock cycles        
      case(p_sequencer.env.dyn_rcfg_obj_inst.speed)
      _50G : begin
                 `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                  p_sequencer.env.`MAC_CFG.enable_ber     = 1;
                  p_sequencer.env.`MAC_CFG.lsbi_ber_limit = 1000;
                  p_sequencer.env.`MAC_CFG.lsbi_ber_timer = 300;
                  p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.`MAC_CFG);
                  end
      _100G : begin
                 `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                  p_sequencer.env.`MAC_CFG.enable_ber     = 1;
                  p_sequencer.env.`MAC_CFG.csbi_ber_timer = 300;
                  p_sequencer.env.`MAC_CFG.csbi_ber_limit = 1000;
                  p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.`MAC_CFG);
                  end
      _40G : begin
                 `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                  p_sequencer.env.`MAC_CFG.enable_ber     = 1;
                  p_sequencer.env.`MAC_CFG.xlsbi_ber_timer = 300;
                  p_sequencer.env.`MAC_CFG.xlsbi_ber_limit = 1000;
                  p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.`MAC_CFG);
                  end
      _10G : begin
                 `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                  p_sequencer.env.`MAC_CFG.enable_ber     = 1;
                  p_sequencer.env.`MAC_CFG.csbi_ber_timer = 300;
                  p_sequencer.env.`MAC_CFG.csbi_ber_limit = 1000;
                  p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.`MAC_CFG);
                  end                  
      _25G : begin
                 `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                  p_sequencer.env.`MAC_CFG.enable_ber     = 1;
                  p_sequencer.env.`MAC_CFG.xxvsbi_ber_timer = 300;
                  p_sequencer.env.`MAC_CFG.xxvsbi_ber_limit = 1000;
                  p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.`MAC_CFG);
                  end                   
        endcase
        
		if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G)) begin
            #20us;
        end
        else if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G)begin
           wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b1);
           wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b0);
        end        
        end

      /* Number of frames */
      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
        sequence_length = 5;
      end else begin
        sequence_length = 30;
      end
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      exception_list = new("exception_list", exception);
      // Add a data block before and after a frames
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
      exception.baser_encoder_insert_sync_header_error = 2'b10;
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
      exception_list.add_exception(exception);
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
      exception.baser_encoder_insert_sync_header_error = 2'b10;
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
      exception_list.add_exception(exception);
      `uvm_info("vip_error_base_sequence", $sformatf("Setting preamble_check=%0d, sfd_check=%0d",preamble_check,sfd_check), UVM_MEDIUM)
     // p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{27'b0,preamble_check,sfd_check,3'b0});
      
      ////////////////////////////////////////////////////
      ////// Phase 1: B2B frames - IFG=16. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(40),.en_short_packet(en_short_packet));
      #200ns;
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;
      
      ////////////////////////////////////////////////////
      ////// Phase 2: B2B frames - IFG=24. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(70),.en_short_packet(en_short_packet));
      #200ns;
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;
      
      // Ordered sets outside of frames
      exception_list = new("exception_list", exception);
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h4B}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
      exception_list.add_exception(exception);
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h4B}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
      exception_list.add_exception(exception);
      ////////////////////////////////////////////////////
      ////// Phase 1: B2B frames - IFG=16. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(16),.en_short_packet(en_short_packet));
      #200ns;
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;
      ////////////////////////////////////////////////////
      ////// Phase 2: B2B frames - IFG=24. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(24),.en_short_packet(en_short_packet));
      #200ns;
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;
      
      // Error blocks outside of frames
      exception_list = new("exception_list", exception);
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
      exception_list.add_exception(exception);
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
      exception_list.add_exception(exception);
      ////////////////////////////////////////////////////
      ////// Phase 1: B2B frames - IFG=16. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(40),.en_short_packet(en_short_packet));
      #200ns;
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;
      ////////////////////////////////////////////////////
      ////// Phase 2: B2B frames - IFG=24. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(70),.en_short_packet(en_short_packet));
      #200ns;
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;

      // wait_client_rx_frame task terminates before VIP transmits all packets for 10m due to this will see 1 More TX than RX error
      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})begin
        #100us;    
      end

      `uvm_info("body", "Exiting ...", UVM_MEDIUM);   
   endtask // body

endclass // vip_decoder_sequence17_to_19
