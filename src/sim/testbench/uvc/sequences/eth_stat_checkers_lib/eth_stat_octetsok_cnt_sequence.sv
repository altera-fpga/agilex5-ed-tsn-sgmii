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


class eth_stat_octetsok_cnt_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_octetsok_cnt_sequence)

  int transaction_count;
  int frame_num_tx,frame_num_rx;
  int iter_cnt;
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
    `uvm_info("body", "started eth_stat_octetsok_cnt_sequence ...", UVM_NONE)
    super.body();

    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10M)begin
       fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,2);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,2);  
       join
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(2),.timeout_time(1ms));
       p_sequencer.env.wait_tx_frames_received(.exp_num(2),.timeout_time(1ms));    
    end else begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M})begin
          tx_max_frame_size = $urandom_range(1560,2000);
          rx_max_frame_size = $urandom_range(1560,2000);
       end else begin
          tx_max_frame_size = $urandom_range(9500,10000);
          rx_max_frame_size = $urandom_range(9500,10000);
       end

       p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
       p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
       $display("tx_max_frame_size = %0d , rx_max_frame_size",tx_max_frame_size,rx_max_frame_size);
       itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 5:50;

       //3. Send normal, oversize data or control frames without an Error.
       //4. Read PayloadOctetsOK and FrameOctetsOK counter registers 
       //5. Repeat step 3 and step 4 five to ten time to ensure PayloadOctetsOK and FrameOctetsOK counters increments cumulatively. 
       // ETH_9/ETH_5 : high memory & high time is required for eth_9/eth_5. so reduce the iteration count (HSD:16011453560).
       iter_cnt = p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G} ? 100:250;
       $display("iteration count = %0d ",itr_cnt);

       repeat(itr_cnt) begin
         fork
           begin
             randcase//Rx path 
             //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
               1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
               1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcserror: TODO
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size/10,rx_max_frame_size/7+50));//normal frame with fcs error
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10));//oversize frame with fcs error
               1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
               1: send_eth_frame_with_fix_size(DATA_FRAME,rx_max_frame_size+1,1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
               1: send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,1);
               1: send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
               1: send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);//Control frame without fcs RX
             endcase
             frame_num_rx++;
             #10us;
           end
           begin
             randcase//Tx path 
             //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
               1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
               1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,$urandom_range(46,63));//undersize frame with fcserror: TODO
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size/10,tx_max_frame_size/7+50));//normal frame with fcs error
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10));//oversize frame with fcs error
           1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
               1: send_eth_frame_with_fix_size(DATA_FRAME,tx_max_frame_size+1,1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
               1: send_eth_frame(UNDERSIZE_FRAME,AVL_TX_ETH_VIP,1);
               1: send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
               1: send_eth_frame_with_fix_size(CONTROL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
             endcase
             frame_num_tx++;
             #10us;
           end
         join
         // Read registers after 5 packets interval to reduce runtime
 //        if((frame_num_tx%5) == 0) begin 
 //          #10us;
 //          read_registers();
 //        end
       end

       p_sequencer.env.wait_client_rx_frames_done(.exp_num(frame_num_rx-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));
       p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));

       if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
         #250us;
       end
  
       read_and_compare_stats();
    end    
    `uvm_info("body", "Completed eth_stat_octetsok_cnt_sequence ...", UVM_NONE)

endtask

    task read_registers();
    #2000ns;
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    endtask
endclass : eth_stat_octetsok_cnt_sequence
