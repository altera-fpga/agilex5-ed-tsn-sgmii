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


class ptp_length_err_mix_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  bit mix_rule;
  int iter_no;
  bit eop_detect;
  `uvm_object_utils(ptp_length_err_mix_sequence)
  function new(string name = "ptp_length_err_mix_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   enable_tx_error_insertion();
   `ifdef ENABLE_ETH_VIP
	disable_snps_err();//disabling VIP checkers
   `endif
  `uvm_info("eth_seq_lib", "running ptp_length_err_mix_sequence\n",UVM_LOW)
   mix_rule = 0;
  
  fork
  begin
    `ifdef ENABLE_ETH_VIP
        p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1'b1;
      `else 
        p_sequencer.env.sb_loopbk.scb_dis = 1'b1;
      `endif
      p_sequencer.env.m_ptp_tx_ref_model.bypass_queue = 1; //disable ptp_tx_ref_model
      p_sequencer.env.m_ptp_tx_ref_model.flush_frames();
      p_sequencer.env.m_ptp_tx_ref_model.reset_model();    

    //Disable SVA checker
    p_sequencer.env.spy_if.dis_sva = 1;
      
    repeat(50) begin
     ++iter_no;
     `ifdef ENABLE_ETH_VIP
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      `endif
      if(mix_rule)
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
      else
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
      
        send_eth_frame_with_length_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,,1,ptp_op);  // PTP Error frame with tx error	  
    end
  end
  begin
   `ifdef ENABLE_ETH_VIP
     repeat(50) begin
     send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);  // good non PTP frame VIP tx - DUT rx  
     end
   `endif
  end

   begin
      
      if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG)begin      
         repeat(50)begin
            wait(p_sequencer.env.spy_if.TX_SEG_PKT_SENT.triggered);
         end         
      end else begin
         //TODO: Find better AVST EOP signal event
         #5us;
      
      end
     eop_detect = 1'b1;
     
  end
  join
 
  if(eop_detect)   #1us;

  fork
  begin
    //Enable scoreboard
    `ifdef ENABLE_ETH_VIP
        p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1'b0;
      `else 
        p_sequencer.env.sb_loopbk.scb_dis = 1'b0;
      `endif
       p_sequencer.env.m_ptp_tx_ref_model.bypass_queue = 0;
       
    //Enable SVA
    p_sequencer.env.spy_if.dis_sva = 0;    
    
    repeat(20) begin
   `ifdef ENABLE_ETH_VIP
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
   `endif
      if(mix_rule)
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
      else
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
      
        send_ptp_frame(ptp_op,RANDOM_FRAME,1,0);  // good PTP frame
    end
  end
  begin
   `ifdef ENABLE_ETH_VIP
     repeat(20) begin
     send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);  // good non PTP frame VIP tx - DUT rx  
     end
   `endif
  end
  join

  endtask
  `ifdef UVM_VERSION_1_1
  virtual task post_start();
    //use no_traffic for tests which doesn't send any traffic like some of CL73 testsuite cases
    if ((get_parent_sequence() == null) && (starting_phase != null) && no_traffic==0) begin
      starting_phase.phase_done.set_drain_time(this, 10us);
    end
    `ifdef ENABLE_ETH_VIP
      if(no_traffic==0)
      begin
        #4000ns;//Wait till all packets are reached to VIP/DUT RX
      end
      //read and compare all stats at the end of all stat sequence
      if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 && !dis_stats_chk )  
      begin 
        `uvm_info("eth_base_sequence", "read and compare all stats at the end of sequence", UVM_NONE)
        read_and_compare_tx_error_stats();
      end 
    `endif
   // starting_phase.drop_objection(this, "Ending");
  endtask:post_start
    `endif
endclass : ptp_length_err_mix_sequence
