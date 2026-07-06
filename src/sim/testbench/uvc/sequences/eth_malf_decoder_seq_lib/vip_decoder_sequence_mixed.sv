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


class vip_decoder_sequence_mixed extends vip_error_base_sequence;
      
   `uvm_object_utils(vip_decoder_sequence_mixed)
     alt_eth_error_vip_base_sequence err_seq;
   
   function new(string name = "vip_decoder_sequence_mixed");
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
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);

      /* Number of frames */
      sequence_length = 300;
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
      // Ordered sets outside of frames
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
      // Error blocks outside of frames
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
      // FD after frame
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
      exception_list.add_exception(exception);
      // FD before frame
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
      exception_list.add_exception(exception);
      // FB after frame
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
      exception_list.add_exception(exception);
      // FB before frame
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
      exception_list.add_exception(exception);
      // Replace term by idle
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h1e}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
      exception_list.add_exception(exception);
      // Replace term by OS
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h4b}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
      exception_list.add_exception(exception);
      // Replace term by Start block
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
      exception_list.add_exception(exception);
      // Replace term by bad sync header
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
      exception.baser_encoder_insert_sync_header_error = 2'b00;
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
      exception_list.add_exception(exception);
      // Replace term by bad sync header
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
      exception.baser_encoder_insert_sync_header_error = 2'b11;
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
      exception_list.add_exception(exception);
      // Replace term by bad BTF
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
      exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
      exception_list.add_exception(exception);
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
      exception = new();
      exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
      exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87}};
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
      
      `uvm_info("vip_error_base_sequence", $sformatf("Setting preamble_check=%0d, sfd_check=%0d",preamble_check,sfd_check), UVM_MEDIUM)
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{27'b0,preamble_check,sfd_check,3'b0});
      
      ////////////////////////////////////////////////////
      ////// Phase 1: B2B frames - IFG=16. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(16),.en_short_packet(en_short_packet));
      #200ns;
//      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;
      
      ////////////////////////////////////////////////////
      ////// Phase 2: B2B frames - IFG=24. Allow for <Start><frame><Term><Term><Idle><Term><Start> ////////////////
      ////////////////////////////////////////////////////
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(24),.en_short_packet(en_short_packet));
      #200ns;
//      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      #400ns;
      
      `uvm_info("body", "Exiting ...", UVM_MEDIUM);   
   endtask // body

endclass // vip_decoder_sequence_mixed
