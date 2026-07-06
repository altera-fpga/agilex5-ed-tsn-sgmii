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


class vip_decoder_sequence11_to_14 extends vip_error_base_sequence;
      
   `uvm_object_utils(vip_decoder_sequence11_to_14)
     alt_eth_error_vip_base_sequence err_seq;
   
   function new(string name = "vip_decoder_sequence11_to_14");
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
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_multilane_high_ber.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      // 200G/400G PCS
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
      //25G Error Masking
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);

      // disable VIP TX checker
      //Since we are inserting the exception from tx side disabling the checkers 
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
        //bit 0: (set t0 0 to disable checker on tx side)
        //bit 1: (set t0 0 to disable checker on rx side)
        //bit 2: (set t0 0 to disable checker on checker arbiter)
        p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b000);
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G,_40G,_50G,_100G}) begin
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
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G}) begin
          #20us;
        end
        else if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G)begin
          wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b1);
          wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b0);
        end
        end        
      // Disable short frames
      en_short_packet=1'b1;
      /* Number of frames */
      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
        sequence_length = 10;
      end else begin
        sequence_length = 75;
      end  
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      exception_list = new("exception_list", exception);
      // Replace start by idle
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h1e}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace term by OS
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h4b}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by term block
      // BTF='h87
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by term block
      // BTF='h99
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h99}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by term block
      // BTF='hAA
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hAA}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by term block
      // BTF='hB4
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hB4}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by term block
      // BTF='hCC
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hCC}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by term block
      // BTF='hD2
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hD2}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by term block
      // BTF='hE1
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hE1}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by term block
      // BTF='hFF
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hFF}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by bad sync header
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
      exception.baser_encoder_insert_sync_header_error = 2'b00;
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by bad sync header
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
      exception.baser_encoder_insert_sync_header_error = 2'b11;
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      // Replace start by bad BTF
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
      exception_list.add_exception(exception);
      
      ////////////////////////////////////////////////////
      ////// Phase 1: B2B frames - IFG=8. Allow for <Start><frame><Term><Term><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(40),.en_short_packet(en_short_packet));
      #200ns;
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;
      
      ////////////////////////////////////////////////////
      ////// Phase 2: B2B frames - IFG=16. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
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

endclass // vip_decoder_sequence11_to_14
