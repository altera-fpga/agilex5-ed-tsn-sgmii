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


class eth_stat_mcastdata_cnt_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_mcastdata_cnt_sequence)

  frame_type eth_frame_tx, eth_frame_rx;
  int frame_num_tx, frame_num_rx;
  int temp1, temp2,pl_size;
  int itr_cnt;

  function new(string name = "eth_stat_mcastdata_cnt_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("body", "started eth_stat_mcastdata_cnt_sequence ...", UVM_NONE)
    super.body();

    //2. Read mcast stats counter register 
    `uvm_info("eth_stat_mcastdata_cnt_sequence", "2. Read all stats counter register", UVM_NONE)
    read_and_compare_destination_address_regs();
    clear_stat_counters();
    #400ns;
    itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 10:50;

    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_flowcontrol_cntrl_frame_size_not_64_octets.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE); 
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif

    //3. Send one multicast frame with FCS error or without FCS Error randomly (i.e oversize,undersize,normal)
    `uvm_info("eth_stat_mcastdata_cnt_sequence", "3. Send one multicast frame with FCS error or without FCS Error randomly (i.e oversize,undersize,normal)", UVM_NONE)
    repeat(itr_cnt) begin
      fork
        begin
          std::randomize(eth_frame_rx) with {eth_frame_rx inside {BCAST_DATA_FRAME,UCAST_DATA_FRAME,MCAST_DATA_FRAME};};
          randcase//Rx path 
            //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
            1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
            1: send_eth_frame(MCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
            1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(46,63),1,ETH_VIP_AVL_RX);//undersize frame without fcs
            1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(1519,1525),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
            1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcs
            1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(1519,1525));//oversize frame with fcs: TODO
            1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
            1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
            1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
            1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
            1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
            1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
            1: send_eth_frame_with_fcs_error(1,eth_frame_rx,ETH_VIP_AVL_RX,$urandom_range(1519,1525));
            1: send_eth_frame_with_fix_size(eth_frame_rx,$urandom_range(1519,1525),1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fcs_error(1,eth_frame_rx,ETH_VIP_AVL_RX,$urandom_range(46,63));
            1: send_eth_frame_with_fix_size(eth_frame_rx,$urandom_range(46,63),1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fcs_error(1,eth_frame_rx,ETH_VIP_AVL_RX,-1);//Control/Data Frame with fcs RX
            1: send_eth_frame_with_fix_size(eth_frame_rx,64,1,ETH_VIP_AVL_RX);//Control/Data frame without fcs RX
          endcase
	    frame_num_rx++;
        end
        begin
          std::randomize(eth_frame_tx) with {eth_frame_tx inside {BCAST_DATA_FRAME,UCAST_DATA_FRAME,MCAST_DATA_FRAME};};
          randcase//Tx path 
          //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
            1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//error frame
            1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(27,63),1,AVL_TX_ETH_VIP);//undersize frame without fcs
            1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(1519,1525),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
            1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(27,63));//undersize frame with fcs
            1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(1519,1525));//oversize frame with fcs: TODO
            1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
            1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
            1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
            1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
            1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
            1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
            1: send_eth_frame_with_fcs_error(1,eth_frame_tx,AVL_TX_ETH_VIP,$urandom_range(27,63));
            1: send_eth_frame_with_fix_size(eth_frame_tx,$urandom_range(27,63),1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fcs_error(1,eth_frame_tx,AVL_TX_ETH_VIP,$urandom_range(1519,1525));
            1: send_eth_frame_with_fix_size(eth_frame_tx,$urandom_range(1519,1525),1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fcs_error(1,eth_frame_tx,AVL_TX_ETH_VIP,-1);//Control/Data frame with FCS TX
            1: send_eth_frame_with_fix_size(eth_frame_tx,64,1,AVL_TX_ETH_VIP);//Control/Data frame without fcs TX
          endcase
	      frame_num_tx++;
        end
      join
      `uvm_info("eth_stat_mcastdata_cnt_sequence", "4. Read MCAST_DATA_OK and MCAST_DATA_ERR counter registers)", UVM_NONE)
      // Read bcast registers after 5 packets interval to reduce runtime
//      if((frame_num_tx%5) == 0) begin
//        #10us;
//        read_mcast_regs();
//      end
    end

    // Read all stats counter registers 
    p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));
    //p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));
    // DUT RX : if vip monitor captures the pkt after dut received, above wait conditions won't be accurate
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})begin
         #250us;    
    end
    read_and_compare_stats();

  endtask : body

endclass : eth_stat_mcastdata_cnt_sequence
