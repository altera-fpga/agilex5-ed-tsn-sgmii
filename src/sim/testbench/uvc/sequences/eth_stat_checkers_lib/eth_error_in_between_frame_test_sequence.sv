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


class eth_error_in_between_frame_test_sequence extends eth_stat_base_sequence;

  `uvm_object_utils(eth_error_in_between_frame_test_sequence)

  int transaction_count;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = 100;
    end
  endfunction:new

  virtual task body();
    `uvm_info("body", "started eth_error_in_between_frame_test_sequence ...", UVM_NONE)
    super.body();

    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
      transaction_count = 5;      
    end
    
    //muralasx: Need to have it in a task //[TODO]
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);

    //25G
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);

    //This is expected as part of inserting xgmii_error_kind (8bytes_inbetween_frame) -SNPS case:01057954
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);

    //muralasx:
    //repeat($urandom_range(20,50)) begin
    repeat(transaction_count) begin
      fork
        begin
          randcase//Rx path 
          //(frame_num,frame_type,direction,frame_size)
            1: send_eth_frame_with_error_in_between(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);//This task will insert malformed error (VIP - tx to DUT - rx)
	  //(frame_type,frame_size,no_of_frame,direction)
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(18,22),1,ETH_VIP_AVL_RX);
          endcase
        end
        begin
          randcase
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP);
	    //(frame_num,frame_type,direction,frame_size,do_no_insert_fcs_err(0-as default))
            1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
          endcase
        end
      join
    end
    
    //updating num of pkts for base test reference

    p_sequencer.env.wait_tx_frames_received(.exp_num(transaction_count),.timeout_time(1ms));
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})begin
         #250us;    
    end

    
  endtask
  
endclass : eth_error_in_between_frame_test_sequence
