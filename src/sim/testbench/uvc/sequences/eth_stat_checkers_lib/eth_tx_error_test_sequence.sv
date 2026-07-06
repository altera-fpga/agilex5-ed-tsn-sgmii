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


// Sequence name :eth_tx_error_test_sequence
// CHK_GDR: please check FB-515409 BEFORE STARTING THE SEQUENCE as some commented codes in this used task "read_and_compare_tx_error_stats"

class eth_tx_error_test_sequence extends eth_stat_base_sequence;

  `uvm_object_utils(eth_tx_error_test_sequence)
  int frame_num_tx, frame_num_rx;
  bit disable_comparison = 0;

  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
   super.body();
   enable_tx_error_insertion();
 `ifdef ENABLE_ETH_VIP
     //muralasx: need to keep snps errors in a method. 
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
      
	  if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
         send_random_frames(10);
	     // wait for all frames to be done
		 #250us; 
	  end else begin
	     send_directed_frames();
         send_random_frames(10);
        //adding delay for the random frame transmission to complete as it is getting mixed with the next set of fixed frames  
         #10us
         repeat($urandom_range(100,200)) begin
         fork
           begin
             randcase//Rx path 
             //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
               1: send_eth_frame_with_fix_size(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);//error frame
               1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
             endcase
	         frame_num_rx++;
           end
           begin
             //To avoid grey window for stat counters , sending frames with fixed length 
             //tx_error + random length, DUT will finish frame with error -->
             // err_byte_cnt calculation will be based on speed + eop in DUT , cann't predict exp error bytes which causing the wrong stat count increment
             randcase
               //1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_tx_error(1,DATA_FRAME,AVL_TX_ETH_VIP,512);//This task will insert Tx error in the frame(Tx side)
               //1: send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
               1: send_eth_frame_with_tx_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,512);//for coverage
               1: send_eth_frame_with_tx_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,512);//for coverage
               1: send_eth_frame_with_tx_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,512);//for coverage
               1: send_eth_frame_with_tx_error(1,SFC_FRAME,AVL_TX_ETH_VIP,96);//for coverage HSD: 16012991453
               1: send_eth_frame_with_tx_error(1,PFC_FRAME,AVL_TX_ETH_VIP,96);//for coverage
               //1: send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(30,48));
             endcase
             frame_num_tx++;
           end
           join
         end
         `else
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
        `endif
          
        //read and compare all stats at the end of all stat sequence
        #2000ns;//Wait till all packets are reached to VIP/DUT RX
        if(!dis_stats_chk )  
        begin 
           //HSD : 16013665614
           if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_10G,_25G}) begin
              disable_comparison = 1;
              `uvm_info("eth_base_sequence", "disabling comparison for tx_error stats registers for 25G", UVM_NONE)
           end
           `uvm_info("eth_base_sequence", "read and compare all stats at the end of sequence", UVM_NONE)
           read_and_compare_tx_error_stats(disable_comparison);  
        end 
       
        //For Coverage: to hit tx_error 1->0 transition
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
        #2us; //Wait till all packets are reached to VIP/DUT RX 
     end
     $display("end eth_tx_error_test_sequence");
 
 endtask
    
endclass:eth_tx_error_test_sequence
