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



//This sequence is for coverage purpose
//The following TX stats counter incrementation are done in this usecase
//(non_zero_value)
// tx_fragments_lo,tx_jabbers_lo,tx_pfc_err_lo,tx_pause_err_lo
// HSD: 16013794067
class macstats_tx_coverage_sequence extends eth_stat_base_sequence;

  `uvm_object_utils(macstats_tx_coverage_sequence)
  int frame_num_tx, frame_num_rx;
  bit disable_comparison = 0;
  int frame_size_tx;
  int itr_cnt=20;
  uvm_reg_data_t tx_max_frame_size;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   super.body();
   enable_tx_error_insertion();
 `ifdef ENABLE_ETH_VIP
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_flowcontrol_rsvrd_fields_within_paus_frame_not_zeroes.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G ) begin
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end
 //*************************************************//
      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
          itr_cnt = 1;
      end
      //tx_jabbers_cnt  
      repeat(itr_cnt) begin
         p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size,1);
        `uvm_info("eth_stat_jabbers_cntr", $psprintf("Read JABBER register and configure MAX FRAME SIZE register with random value = %0d",tx_max_frame_size), UVM_NONE)
         frame_size_tx = $urandom_range(tx_max_frame_size+2,tx_max_frame_size+20);
         `uvm_info("eth_stat_jabbers_cntr", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
         send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,frame_size_tx);
      end     

      //tx_fragments_cnt
      repeat(itr_cnt) begin
       `uvm_info("eth_stat_fragments_cntr","Sending packets",UVM_LOW);
       send_eth_frame_with_tx_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,48);
       //send_eth_frame_with_tx_error(1,DATA_FRAME,AVL_TX_ETH_VIP,63);
      end

      //tx_pfc_err_lo & tx_pause_err_lo
      //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
      repeat(itr_cnt) begin
       `uvm_info("eth_stat_pause&pfc_err_cntr","Sending packets",UVM_LOW);
       send_eth_frame_with_tx_error(1,SFC_FRAME,AVL_TX_ETH_VIP,-1);
       send_eth_frame_with_tx_error(1,PFC_FRAME,AVL_TX_ETH_VIP,-1);
       send_eth_frame_with_tx_error(1,CONTROL_FRAME,AVL_TX_ETH_VIP,-1);
     end

      repeat(itr_cnt) begin
       send_eth_frame_with_tx_error(1,DATA_FRAME,AVL_TX_ETH_VIP);
      end
  `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
 `endif

 #500us;//Wait till all packets are reached to VIP/DUT RX 

 //Since there are different stimulus for TX counter incrementation,
 //prediction of MAC STATS logic becomes difficult, hence we are disabling
 //comparison for MAC stats registers
 if(!dis_stats_chk )  
 begin 
    //HSD : 16013665614
       disable_comparison = 1;
       `uvm_info("eth_base_sequence", "disabling comparison for tx_error stats registers", UVM_NONE)
       read_and_compare_tx_error_stats(disable_comparison);  
 end 

 #2us; //Wait till all packets are reached to VIP/DUT RX 
 $display("end macstats_tx_coverage_sequence");
 
 endtask
    
endclass:macstats_tx_coverage_sequence
