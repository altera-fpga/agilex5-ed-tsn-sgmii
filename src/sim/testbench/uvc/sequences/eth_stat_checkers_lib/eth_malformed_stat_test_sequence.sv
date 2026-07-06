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


class eth_malformed_stat_test_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_malformed_stat_test_sequence)

  frame_type eth_frame;
  int frame_num_rx,frame_num_tx;
  int transaction_count;
  uvm_reg_data_t rd_data;
  bit [47:0] dest_address;
  //bit rx_crc_pass;

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
    `uvm_info("body", "started eth_malformed_stat_test_sequence ...", UVM_NONE)
    super.body();

    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
      transaction_count = 5; 
    end
    
    //muralasx: TODO need to keep snps errors in a method. 
    `ifdef ENABLE_ETH_VIP
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
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G) begin
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   end
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G || p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G) begin
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   end
    `endif
    
//    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    dest_address[31:0] = rd_data;
//    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    dest_address[47:32] = rd_data;
    p_sequencer.env.eth_ref_model_inst.malformed_case = 1;

    //2. Randomly send frames with incorrect terminate character.(DATA/VLAN/SVLAN) 
    repeat(transaction_count) begin
      std::randomize(eth_frame) with {eth_frame inside {DATA_FRAME,ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME};};
      fork
        begin
          randcase//Rx path 
          //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
	      //muralasx: FIXME difference between fcs_error & malformed_error tasks
          //This task will insert malformed error (VIP - tx to DUT - rx)
            1: send_eth_frame_with_malformed_error(1,eth_frame,ETH_VIP_AVL_RX,-1);
            1: send_eth_frame_with_fix_size(eth_frame,-1,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_malformed_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(18,22),1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_malformed_error(1,PFC_FRAME,ETH_VIP_AVL_RX,64,dest_address); //COV:- SFC/PFC frame X  Malformed
            1: send_eth_frame_with_malformed_error(1,SFC_FRAME,ETH_VIP_AVL_RX,64,dest_address); //COV:- SFC/PFC frame X  Malformed
            1: send_eth_frame_with_malformed_error(1,DATA_FRAME,ETH_VIP_AVL_RX,1530);  //COV :- Illegal length type frame X  Malformed
            1: send_eth_frame_with_malformed_error(1,CONTROL_FRAME,ETH_VIP_AVL_RX,1560); // COV:- FC frame (control frame, but not sfc/pfc) X Malformed
          endcase
	  frame_num_rx++;
        end
        begin
          randcase
            1: send_eth_frame_with_fix_size(eth_frame,-1,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fcs_error(1,eth_frame,AVL_TX_ETH_VIP,-1);
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
          endcase
	  frame_num_tx++;
        end
      join
    end

    p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
       #250us;
    end
    //4. Read all stats registers.Malfomed stats registers should be updated accordingly.
    read_and_compare_malformed_stats();

  endtask

endclass : eth_malformed_stat_test_sequence
