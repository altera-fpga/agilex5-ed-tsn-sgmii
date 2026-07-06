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


class eth_stat_fcs_err_frame_seq extends eth_stat_base_sequence;

   int frame_num_rx,frame_num_tx;
   int itr_cnt;

  `uvm_object_utils(eth_stat_fcs_err_frame_seq)

  function new(string name = "eth_stat_fcs_err_frame_seq");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    super.body();

    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif

    itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 5:50;

    //3. Send one frame with FCS error (i.e oversize,undersize,normal)
    // ETH_9 : high memory & high runtime is required. so reduce the iteration count & register access.
    
    `uvm_info("eth_stat_fcs_err_frame_seq", "3. Send one frame with FCS error (i.e oversize,undersize,normal)", UVM_NONE)
    repeat(itr_cnt) begin
      fork
        begin
          randcase 
            1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,-1); // undersize
            1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);// Normal frame
            1: begin 
                 if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) // its taking long simulation time
                    send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(1550,1560));// Oversize frame
                 else
                    send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,10000));// Oversize frame
               end
            1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX); //undresize
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX); //Normal
            1: begin
                 if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})// its taking long simulation time
                   send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(1550,1560),1,ETH_VIP_AVL_RX); //Oversize
                 else
                   send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(9601,10000),1,ETH_VIP_AVL_RX); //Oversize
               end
          endcase
	  frame_num_rx++;
	end  
        begin
          randcase 
            1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1); // undersize
            1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);// Normal frame
            1:begin
                if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})// its taking long simulation time
                  send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(1550,1560));// Oversize frame
                else
                  send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,10000));// Oversize frame
              end
            1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP); //undresize
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP); //Normal
            1: begin 
                 if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})// its taking long simulation time
                   send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(1550,1560),1,AVL_TX_ETH_VIP); //Oversize
                 else
                  send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(9601,10000),1,AVL_TX_ETH_VIP); //Oversize
               end
          endcase
	  frame_num_tx++;
	end  
      join	
      // 4. Read FCSERR counter register 
      `uvm_info("eth_stat_fcs_err_frame_seq", "4. Read FCSERR counter register", UVM_NONE)
      //if((frame_num_tx%5) == 0) read_registers();
    end

    //15. Read all stats counter registers 
    #10us;
    p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));
    //p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})
     #250us;

    `uvm_info("eth_stat_fcs_err_frame_seq", "15. Read all stats counter registers", UVM_NONE)
    read_and_compare_stats();

  endtask

  task read_registers();
    #2000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read. 
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
 //   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  endtask

endclass : eth_stat_fcs_err_frame_seq
