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


class eth_testsuite_lf_cl81_comp_tc_15_seq extends eth_base_sequence;
  
  `uvm_object_utils(eth_testsuite_lf_cl81_comp_tc_15_seq)

  function new(string name = "eth_testsuite_lf_cl81_comp_tc_15_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

virtual task body();
    `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "Executing eth_testsuite_lf_cl81_comp_tc_15_seq ...", UVM_NONE)
//    apply_hard_reset(0,0,1,11);
    dis_vec_sb();
    dis_stats_chk = 1;
    // `ifdef ANLT
    //     p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    // `endif
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);

    fork :case_15_fork
      begin
	//muralasx: FIXME start_testsuite_test(), testsuite_case_select(), monitor_error_event()& wait_for_testsuite_test_finish() methods in testsuitetasks interface and release below lines. 
        //p_sequencer.env.ts_tasks_if.start_testsuite_test();
        `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "start_testsuite_test done ...", UVM_NONE)
        //p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_XLGMII_CGMII_CL81_COMP_TP",15,15);
        fork
           //p_sequencer.env.ts_tasks_if.monitor_error_event();
           //p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
        join_any
      end
    
      begin
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,1000);  
      end
 
   //   begin
   //     forever 
   //       begin
   //         `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "waiting for local fault is deasserted ...", UVM_NONE)
   //         wait(p_sequencer.env.spy_if.local_fault == 1'b1)
   //         `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "local fault is asserted ...", UVM_NONE)
   //         `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "local fault disabling scoreboard ...", UVM_NONE)
   //         p_sequencer.env.sb_mac_tx_vip_rx.scb_en = 0;
   //         uvm_config_db#(int)::set(null, " *", "scb_en", 0);
   //         wait(p_sequencer.env.spy_if.local_fault == 1'b0)
   //         `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "local fault is deasserted ...", UVM_NONE)
   //         wait(p_sequencer.env.spy_if.avst_tx_eop == 1'b1);
   //         wait(p_sequencer.env.spy_if.avst_tx_sop == 1'b1);
   //         `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "local fault enabling scoreboard ...", UVM_NONE)
   //         uvm_config_db#(int)::set(null, "*", "scb_en", 1);
   //         p_sequencer.env.sb_mac_tx_vip_rx.scb_en = 1;
   //       end
   //   end

   //   begin
   //     forever 
   //       begin
   //        `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "waiting for remote fault ...", UVM_NONE)
   //        wait(p_sequencer.env.spy_if.remote_fault == 1'b1)
   //        `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "remote fault disabling scoreboard ...", UVM_NONE)
   //        p_sequencer.env.sb_mac_tx_vip_rx.scb_en = 0;
   //        uvm_config_db#(int)::set(null, " *", "scb_en", 0);
   //        wait(p_sequencer.env.spy_if.remote_fault == 1'b0)
   //        `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", " waiting for remote fault is deassertion ...", UVM_NONE)
   //        wait(p_sequencer.env.spy_if.avst_tx_eop == 1'b1);
   //        wait(p_sequencer.env.spy_if.avst_tx_sop == 1'b1);
   //        `uvm_info("eth_testsuite_lf_cl81_comp_tc_15_seq", "remote fault enabling scoreboard ...", UVM_NONE)
   //        uvm_config_db#(int)::set(null, "*", "scb_en", 1);
   //        p_sequencer.env.sb_mac_tx_vip_rx.scb_en = 1;
   //      end
   //   end
      
    join
#1us;
  endtask; 

endclass : eth_testsuite_lf_cl81_comp_tc_15_seq
