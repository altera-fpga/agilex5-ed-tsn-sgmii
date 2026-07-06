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


class eth_stat_ucast_ctrl_cnt_sequence extends eth_stat_base_sequence;
   frame_type eth_frame;
   int frame_num_rx=0;
   int frame_num_tx=0;
   int itr_cnt;

  `uvm_object_utils(eth_stat_ucast_ctrl_cnt_sequence)

  function new(string name = "eth_stat_ucast_ctrl_cnt_sequence");
    super.new(name);
          `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("eth_stat_ucast_ctrl_cnt_sequence", "Started eth_stat_ucast_ctrl_cnt_sequence...", UVM_NONE)
    super.body();
    
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif

    `uvm_info("eth_stat_ucast_ctrl_cnt_sequence", "2. Read UCAST CTRL ERR & OK registers.", UVM_NONE)
    
    read_and_compare_destination_address_regs();
    itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 5:50;

    //Step 3:Send one unicast control frame with FCS error and without FCS randomly.
    `uvm_info("eth_stat_ucast_ctrl_cnt_sequence", "3. Send UCAST Control frame with an FCS error or without an FCS Error randomly.", UVM_NONE)
    repeat(itr_cnt) 
    begin
        std::randomize(eth_frame) with {eth_frame inside {BCAST_CTRL_FRAME,BCAST_DATA_FRAME,UCAST_CTRL_FRAME,UCAST_DATA_FRAME,MCAST_CTRL_FRAME,MCAST_DATA_FRAME};};
        fork 
        begin
          randcase
            1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control frame with fcs RX
            1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//Data frame with FCS error RX
            1: send_eth_frame_with_fcs_error(1,eth_frame,ETH_VIP_AVL_RX,-1);//Control Frame with fcs RX
            1: send_eth_frame_with_fix_size(eth_frame,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
            1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
            1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,ETH_VIP_AVL_RX);//Data Frame RX
          endcase
          frame_num_rx++;
          `uvm_info("eth_stat_ucast_ctrl_cnt_sequence", $sformatf("3. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
        end
        begin
          randcase 
            1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with fcs TX
            1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//Data frame with FCS error TX
            1: send_eth_frame_with_fcs_error(1,eth_frame,AVL_TX_ETH_VIP,-1);//Control frame with FCS TX
            1: send_eth_frame_with_fix_size(eth_frame,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
            1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
            1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);//Data Frame RX
          endcase
          frame_num_tx++;
          `uvm_info("eth_stat_ucast_ctrl_cnt_sequence", $sformatf("3. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
        end
        join

        //Step 4:Read UCAST_CTRL_ERR and UCAST_CTRL_OK  counter registers.
        `uvm_info("eth_stat_ucast_ctrl_cnt_sequence", "4. Read UCAST CTRL ERR & OK registers.", UVM_NONE)
        // Read bcast registers after 5 packets interval to reduce runtime
  //      if((frame_num_tx%5) == 0) begin 
  //        #10us;
  //        read_ucast_regs();
  //      end
    end
    p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));
    //p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));
    // DUT RX : if vip monitor captures the pkt after dut received, above wait conditions won't be accurate
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})begin
         #250us;    
    end
    read_and_compare_stats();

    `uvm_info("eth_stat_ucast_ctrl_cnt_sequence", "Ended eth_stat_ucast_ctrl_cnt_sequence...", UVM_NONE)
  endtask:body

endclass:eth_stat_ucast_ctrl_cnt_sequence
