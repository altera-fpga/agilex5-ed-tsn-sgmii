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


class eth_stat_pause_cnt_sequence extends eth_stat_base_sequence;
  
   int frame_num_tx,frame_num_rx;
   int iter_cnt;
   int itr_cnt;

  `uvm_object_utils(eth_stat_pause_cnt_sequence)

  function new(string name = "eth_stat_pause_cnt_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("eth_stat_pause_cnt_sequence", "Executing eth_stat_pause_cnt_sequence ...", UVM_NONE)
    super.body();
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10M)begin
       fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,2);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,2);  
       join
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(2),.timeout_time(1ms));
       p_sequencer.env.wait_tx_frames_received(.exp_num(2),.timeout_time(1ms));    
    end else begin
        //Clearing stat counters
        clear_stat_counters();
        itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 10:50;
        #400ns;

        `uvm_info("eth_stat_pause_cnt_sequence", "2. Read PAUSE_ERR and PAUSE registers", UVM_NONE)
        read_registers();
        // ETH_9/ETH_5 : high memory & high time is required for eth_9/eth_5. so reduce the iteration count (HSD:16011453560).
        iter_cnt = p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G} ? 100:250;
        $display("iteration count = %0d ",iter_cnt);
        
        `uvm_info("eth_stat_pause_cnt_sequence", "3. Send one pause control frame with FCS error or without FCS error randomly.", UVM_NONE)
        repeat(itr_cnt) begin
          fork
          begin
            randcase
            1:send_eth_frame_with_fcs_error(1,SFC_FRAME,ETH_VIP_AVL_RX);
            1:send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,1);
            1:send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);
            1:send_eth_frame_with_fcs_error(1,CONTROL_FRAME,ETH_VIP_AVL_RX);
            1:send_eth_frame(PFC_FRAME,ETH_VIP_AVL_RX,1);               //in C3,it was commented
            1:send_eth_frame_with_fcs_error(1,PFC_FRAME,ETH_VIP_AVL_RX);//In C3,It was commented
            1:send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);
            1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX);
            endcase
            frame_num_rx++;
            `uvm_info("eth_stat_pause_cnt_sequence", $sformatf("RX frame_num=%0d, Pause frame with or without FCS error", frame_num_rx), UVM_LOW)
          end
          begin
            randcase
            1:send_eth_frame_with_fcs_error(1,SFC_FRAME,AVL_TX_ETH_VIP);
            1:send_eth_frame(SFC_FRAME,AVL_TX_ETH_VIP,1);
            1:send_eth_frame(CONTROL_FRAME,AVL_TX_ETH_VIP,1);
            1:send_eth_frame_with_fcs_error(1,CONTROL_FRAME,AVL_TX_ETH_VIP);
            1:send_eth_frame(PFC_FRAME,AVL_TX_ETH_VIP,1);               //In C3,it was commented
            1:send_eth_frame_with_fcs_error(1,PFC_FRAME,AVL_TX_ETH_VIP);//In C3,It was commented.
            1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
            1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP);
            endcase 
            frame_num_tx++;
            `uvm_info("eth_stat_pause_cnt_sequence", $sformatf("TX frame_num=%0d Pause frame with or without FCS error", frame_num_tx), UVM_LOW)
          end
          join
          // Read registers after 5 packets interval to reduce runtime
       //   if((frame_num_tx%5) == 0) begin 
       //     #5us;
       //     read_registers();
       //   end
        end

        //15. Read all stats counter registers 
        #10us;
        p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));
        p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));

        if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
          #250us;
        end

        read_and_compare_stats();
     end  
  endtask

  task read_registers();
    #3500ns;
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  endtask

endclass : eth_stat_pause_cnt_sequence
