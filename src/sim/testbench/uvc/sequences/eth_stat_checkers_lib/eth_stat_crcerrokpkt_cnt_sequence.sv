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


class eth_stat_crcerrokpkt_cnt_sequence extends eth_stat_base_sequence;
  
   int frame_size_rx,frame_size_tx;
   int frame_num_tx,frame_num_rx;
   int itr_cnt;
   uvm_reg_data_t rd_data;

  `uvm_object_utils(eth_stat_crcerrokpkt_cnt_sequence)

  function new(string name = "eth_stat_crcerrokpkt_cnt_sequence");
    super.new(name);
          `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("eth_stat_crcerrokpkt_cnt_sequence", "Executing eth_stat_crcerrokpkt_cnt_sequence ...", UVM_NONE)
    super.body();

    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
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
       //2. Read CRCERR_OKPKT register and configure MAX PAYLOAD SIZE register with random value.
       `uvm_info("eth_stat_crcerrokpkt_cnt_sequence", $psprintf("2. Read CRCERR_OKPKT register and configure MAX FRAME SIZE register with random value = %0d",rx_max_frame_size), UVM_NONE)
       read_registers();

       `uvm_info("eth_stat_crcerrokpkt_cnt_sequence", "3. Send random frames (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error, undersize with FCS and without FCS error)", UVM_NONE)
       // ETH_9/ETH_5 : high memory & high time is required for eth_9/eth_5. so reduce the iteration count (HSD:16011453560).
       if((p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10M) ||(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _100M) ||(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _1G)) begin
       itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 3:15;
       end else begin
       itr_cnt = 20;
       end 
       $display("iteration count = %0d ",itr_cnt);

       repeat(itr_cnt) begin
         std::randomize(rx_max_frame_size) with {rx_max_frame_size dist {'d64 := 1, 'd16384 := 1, 'd9600 := 1, ['d64:'d16384] := 7}; };
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
         std::randomize(tx_max_frame_size) with {tx_max_frame_size dist {'d64 := 1, 'd16384 := 1, 'd9600 := 1, ['d64:'d16384] := 7}; };
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
         #5us;
         p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
         if(rd_data != tx_max_frame_size) #100us;

         std::randomize(frame_size_tx) with {frame_size_tx dist { [64:tx_max_frame_size] := 1, [tx_max_frame_size+1:tx_max_frame_size+100] := 1};};
         std::randomize(frame_size_rx) with {frame_size_rx dist { [64:rx_max_frame_size] := 1, [rx_max_frame_size+1:rx_max_frame_size+100] := 1};};
         `uvm_info("eth_stat_crcerrokpkt_cnt_sequence", $psprintf("rx_max_frame_size = %0d, tx_max_frame_size=%0d",rx_max_frame_size,tx_max_frame_size), UVM_NONE)
         repeat (itr_cnt) begin
           fork
             begin
               randcase
               1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX); //oversize/normal
               1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,frame_size_rx);//oversize/normal with FCS error
               1:send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,1);
               1:send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX);
               endcase
               frame_num_rx++;
               `uvm_info("eth_stat_crcerrokpkt_cnt_sequence", $sformatf("RX frame_num=%0d random frame", frame_num_rx), UVM_LOW)
             end
             begin
               randcase
               1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP); //oversize/normal
               1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,frame_size_rx);//oversize/normal with FCS error
               1:send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);//undersize frame without fcs
               1:send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1);//undersize frame with fcs
               endcase
               frame_num_tx++;
               `uvm_info("eth_stat_crcerrokpkt_cnt_sequence", $sformatf("TX frame_num=%0d random frame", frame_num_tx), UVM_LOW)
             end
           join
       	#25us; //wait for all transactions to be completed
           // Read registers after 5 packets interval to reduce runtime
       	// removing intermediate reads
           //if((frame_num_tx%5) == 0) read_registers();
         end
         p_sequencer.env.wait_client_rx_frames_done(.exp_num(frame_num_rx),.timeout_time(1ms));
         p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms));
       end

       if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
          #250us;
       end
       //4. Read all stats counter registers 
       read_and_compare_stats();
    end  

  endtask

  task read_registers();
    #2000ns;
//    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  endtask

endclass : eth_stat_crcerrokpkt_cnt_sequence
