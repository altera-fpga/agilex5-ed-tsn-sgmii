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


class ptp_err_malformed_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;
  bit mix_rule;
 
  `uvm_object_utils(ptp_err_malformed_sequence)
  function new(string name = "ptp_err_malformed_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_/
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
     
   `uvm_info("eth_seq_lib", "running ptp_err_malformed_sequence\n",UVM_LOW)
   `ifdef ENABLE_ETH_VIP
	disable_snps_err();//disabling VIP checkers
        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   `endif
   p_sequencer.env.eth_ref_model_inst.malformed_case = 1;
   mix_rule = 0;
   
  fork
  begin
    repeat(20) begin
      if(mix_rule)
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
      else
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
      std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME,JUMBO_DATA_FRAME,JUMBO_VLAN_FRAME,JUMBO_STACKED_VLAN_FRAME};};
      send_ptp_frame(ptp_op,f_type,1,0);  // good frame
     end
  end
  begin
   `ifdef ENABLE_ETH_VIP
     repeat (20)
	begin
		randcase
     		1:send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);  // good VIP frame
		1:send_eth_frame_with_malformed_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX); // malformed VIP frame
		endcase
	end
     	
  end 
   `endif
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
    //starting_phase.drop_objection(this, "Ending");
  endtask:post_start
    `endif
endclass : ptp_err_malformed_sequence
