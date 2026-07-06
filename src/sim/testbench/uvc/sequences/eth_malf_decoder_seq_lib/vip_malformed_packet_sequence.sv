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


class vip_malformed_packet_sequence extends vip_error_base_sequence;
      
   `uvm_object_utils(vip_malformed_packet_sequence)
     alt_eth_error_vip_base_sequence err_seq;
   
   function new(string name = "vip_malformed_packet_sequence");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=200;
   end
   endfunction:new

   virtual task body();
     
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_100G,_50G,_40G}) begin
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end
      else if(p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G) begin
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end
      
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);     
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);      
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);      
      
      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
         num_of_frames = 10;      
      end
      /* Number of frames */
      sequence_length = num_of_frames;
      total_num_frames_sent=sequence_length;
      exception_list = new("exception_list", exception);
      // FE block inserted within frame
   //   exception = new();
   //   exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
   //   exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_INSERT_8BYTES_INBETWEEN_FRAME;
   //   exception.xgmii_insert_8bytes_inbetween_frame_error = 72'hfffefefefefefefefe;
   //   exception_list.add_exception(exception);
      // Control block inserted within frame (idles)
  //    exception = new();
  //    exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
  //    exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_INSERT_8BYTES_INBETWEEN_FRAME;
  //    exception.xgmii_insert_8bytes_inbetween_frame_error = 72'hff0707070707070707;
  //    exception_list.add_exception(exception);
      // Control block inserted within frame (ordered set) LF
  //    exception = new();
  //    exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
  //    exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_INSERT_8BYTES_INBETWEEN_FRAME;
  //    exception.xgmii_insert_8bytes_inbetween_frame_error = 72'h110100009c0100009c;
  //    exception_list.add_exception(exception);
      // Control block inserted within frame (start block)
    //  exception = new();
    //  exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
    //  exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_INSERT_8BYTES_INBETWEEN_FRAME;
    //  exception.xgmii_insert_8bytes_inbetween_frame_error = 72'h80fb555555555555d5;
    //  exception_list.add_exception(exception);
      // Incorrect FCS
    //  exception = new();
    //  exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
    //  exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INCORRECT_FCS;
    //  exception_list.add_exception(exception);
      // Replace start block with (ordered set) LF
   //   exception = new();
   //   exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
   //   exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_INSERT_8BYTES_INBETWEEN_FRAME;
   //   exception.xgmii_insert_8bytes_inbetween_frame_error = 72'h0100000000_0100009c;
   //   exception.xgmii_clk_count_inbetween_frame_error = 0;
   //   exception.reasonable_xgmii_clk_count_inbetween_frame_error.constraint_mode(0);
   //   exception_list.add_exception(exception);
      // Replace start block with idle block
 //     exception = new();
 //     exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
 //     exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_INSERT_8BYTES_INBETWEEN_FRAME;
 //     exception.xgmii_insert_8bytes_inbetween_frame_error = 72'hff0707070707070707;
 //     exception.xgmii_clk_count_inbetween_frame_error = 0;
 //     exception.reasonable_xgmii_clk_count_inbetween_frame_error.constraint_mode(0);
 //     exception_list.add_exception(exception);
      // Replace start character with fd
   //   exception = new();
   //   exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
   //   exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_REPLACE_START_CONTROL_CHAR_ON_LANE0;
   //   exception.xgmii_replace_start_control_char_on_lane0_error = 9'h1_fd;
   //   exception_list.add_exception(exception);
   //   
   //   // Replace start character with 07
   //   exception = new();
   //   exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
   //   exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_REPLACE_START_CONTROL_CHAR_ON_LANE0;
   //   exception.xgmii_replace_start_control_char_on_lane0_error = 9'h1_07;
   //   exception_list.add_exception(exception);
      
      // Replace term character with fb
   //   exception = new();
   //   exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
   //   exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_REPLACE_TERMINATE_CONTROL_CHAR;
   //   exception.xgmii_replace_terminate_control_char_error = 9'h1_fb;
   //   exception_list.add_exception(exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      //GDR : `uvm_info("vip_error_base_sequence", $sformatf("Setting preamble_check=%0d, sfd_check=%0d",preamble_check,sfd_check), UVM_MEDIUM)
      //GDR : p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{27'b0,preamble_check,sfd_check,3'b0}); 
      // Send frames
      err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(sequence_length),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(50),.en_short_packet(en_short_packet));
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));      
      #200ns;

      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})begin
         #500us;    
      end

      `uvm_info("body", "Exiting ...", UVM_MEDIUM);   
   endtask // body

endclass // vip_malformed_packet_sequence
