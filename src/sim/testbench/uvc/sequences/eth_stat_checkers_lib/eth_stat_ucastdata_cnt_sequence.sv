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


class eth_stat_ucastdata_cnt_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_ucastdata_cnt_sequence)

  frame_type eth_frame;
  int transaction_count;
  int frame_num_tx, frame_num_rx;
  int temp1, temp2,pl_size;
  int itr_cnt;

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
    `uvm_info("body", "started eth_stat_ucastdata_cnt_sequence ...", UVM_NONE)
    super.body();

    //2. Read ucast stats counter register 
    `uvm_info("eth_stat_ucastdata_cnt_sequence", "2. Read all stats counter register", UVM_NONE)
    read_and_compare_destination_address_regs();
    clear_stat_counters();
    itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 5:50;
    #400ns;

    //muralasx: TODO need to keep snps errors in a method. 
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
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_flowcontrol_rsvrd_fields_within_paus_frame_not_zeroes.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_flowcontrol_rsvrd_fields_within_paus_frame_not_zeroes.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_flowcontrol_cntrl_frame_size_not_64_octets.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    
    //3. Send one multicast frame with FCS error or without FCS Error randomly (i.e oversize,undersize,normal)
    `uvm_info("eth_stat_ucastdata_cnt_sequence", "3. Send one multicast frame with FCS error or without FCS Error randomly (i.e oversize,undersize,normal)", UVM_NONE)
    repeat(itr_cnt) begin
      temp1=$urandom_range(46,63);
      temp2=$urandom_range(1519,1525);
      std::randomize(pl_size) with {pl_size inside{temp1,temp2,-1};};
      std::randomize(eth_frame) with {eth_frame inside {BCAST_CTRL_FRAME,BCAST_DATA_FRAME,UCAST_CTRL_FRAME,UCAST_DATA_FRAME,MCAST_CTRL_FRAME,MCAST_DATA_FRAME};};
      fork
        begin
          randcase//Rx path 
          //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
            1: send_eth_frame_with_fcs_error(1,eth_frame,ETH_VIP_AVL_RX,pl_size);
            1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcs
            1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(1519,1525));//oversize frame with fcs: TODO
            1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
            1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
            1: send_eth_frame_with_fix_size(eth_frame,pl_size,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(46,63),1,ETH_VIP_AVL_RX);//undersize frame without fcs
            1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(1519,1525),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
            1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
            1: send_eth_frame(UCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
          endcase
	  frame_num_rx++;
      #10us;
        end
        begin
          randcase//Tx path 
          //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
            1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(27,63));//undersize frame with fcs
            1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(1519,1525));//oversize frame with fcs: TODO
            1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
            1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//error frame
            1: send_eth_frame_with_fcs_error(1,eth_frame,AVL_TX_ETH_VIP,pl_size);
            1: send_eth_frame_with_fix_size(eth_frame,pl_size,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(27,63),1,AVL_TX_ETH_VIP);//undersize frame without fcs
            1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(1519,1525),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
            1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
            1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
          endcase
	  frame_num_tx++;
      #10us;
        end
      join
      //4. Read MCAST_DATA_OK and MCAST_DATA_ERR counter registers
      `uvm_info("eth_stat_ucastdata_cnt_sequence", "4. Read MCAST_DATA_OK and MCAST_DATA_ERR counter registers)", UVM_NONE)
      // Read bcast registers after 5 packets interval to reduce runtime
 //     if((frame_num_tx%5) == 0) begin 
 //       read_ucast_regs();
 //     end
    end
    
    p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));
    //p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));
    // DUT RX : if vip monitor captures the pkt after dut received, above wait conditions won't be accurate
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})begin
         #250us;    
    end
    // Read all stats counter registers 
    read_and_compare_stats();

  endtask

endclass : eth_stat_ucastdata_cnt_sequence
