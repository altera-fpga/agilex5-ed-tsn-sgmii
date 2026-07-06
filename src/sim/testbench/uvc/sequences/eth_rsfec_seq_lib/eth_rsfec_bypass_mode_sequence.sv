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


//class eth_rsfec_bypass_mode_sequence extends eth_base_sequence;
// uvm_reg 	regs; 
//  `uvm_object_utils(eth_rsfec_bypass_mode_sequence)
//
//  function new(string name = "eth_rsfec_bypass_mode_sequence");
//    super.new(name);
//	`ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
// endfunction:new
//
//  virtual task body();
//
//   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
//  
//   //delay based on FB-530700 
//   #10700ns;
//   p_sequencer.env.reg_read(`REGISTERS_RX_FEC_Status_OFFSET_REG,read_data);
//
//   @(posedge p_sequencer.env.spy_if.rx_am_lock);
//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_FEC_Status_OFFSET_REG);
//   regs.predict(.value('h1b0f),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
//   p_sequencer.env.reg_read(`REGISTERS_RX_FEC_Status_OFFSET_REG,read_data);
//
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//
//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_FEC_Status_OFFSET_REG);
//   regs.predict(.value('h1b1f),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
//   p_sequencer.env.reg_read(`REGISTERS_RX_FEC_Status_OFFSET_REG,read_data);
//
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data);
//
//
//   fork
//    begin 
//      send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,5); 
//    end
//    begin
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[0] = 'h3FF;
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.local_160bits_error_pos[0] = 1'b1;
//      @p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection;
//      @(p_sequencer.env.spy_if.cw_insert);
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 1;
//      repeat(15) @(p_sequencer.env.spy_if.cw_insert);
//       p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 0;
//      end
//   join
//   
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(15),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
//
//   p_sequencer.env.reg_read(`REGISTERS_RX_FEC_Status_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data);
//  
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
//
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data); 
//        
//   p_sequencer.env.reg_write(`REGISTERS_RX_Bypass_Reset_OFFSET_REG ,'hFFFF_FFFF);
//   #70ns //Delay based on FB-530776
//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Bypass_Reset_OFFSET_REG);
//   regs.predict(.value(1),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
//   p_sequencer.env.reg_read(`REGISTERS_RX_Bypass_Reset_OFFSET_REG,read_data); 
//
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//   //since correction is bypassed, there will be packet mismatch,
//   // once the new scoreboard is installed, need to update the code.
//   dis_vec_sb();
//   p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; 
//   p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
//   p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
//   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
//   p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis =1; 
//   p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 0;
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
//
//   fork
//    begin 
//      send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,5); 
//    end
//    begin
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[0] = 'h3FF;
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.local_160bits_error_pos[0] = 1'b1;
//      @p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection;
//      @(p_sequencer.env.spy_if.cw_insert);
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 1;
//      repeat(15) @(p_sequencer.env.spy_if.cw_insert);
//       p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 0;
//      end
//   join
//   p_sequencer.env.reg_read(`REGISTERS_RX_FEC_Status_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(15),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data); 
//
//   p_sequencer.env.reg_write(`REGISTERS_RX_Bypass_Reset_OFFSET_REG ,'hFFFF_FFFE);
//   #70ns //Delay based on FB-530776
//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Bypass_Reset_OFFSET_REG);
//   regs.predict(.value(0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
//   p_sequencer.env.reg_read(`REGISTERS_RX_Bypass_Reset_OFFSET_REG,read_data); 
//  
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//   
//   //re-enable the sbs since correction is enabled.
//   //stats will remain disabled since garbage frame collected when correction was off
//   p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0; 
//   p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
//   p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=1;
//   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=1;
//   p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis =0; 
//
//   fork
//    begin 
//      send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,5); 
//    end
//    begin
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[0] = 'h3FF;
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.local_160bits_error_pos[0] = 1'b1;
//      @p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection;
//      @(p_sequencer.env.spy_if.cw_insert);
//      p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 1;
//      repeat(15) @(p_sequencer.env.spy_if.cw_insert);
//       p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 0;
//      end
//   join
//   p_sequencer.env.reg_read(`REGISTERS_RX_FEC_Status_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(15),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data); 
//
// endtask
//endclass
