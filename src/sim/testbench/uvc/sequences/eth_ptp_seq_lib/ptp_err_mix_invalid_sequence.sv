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


class ptp_err_mix_invalid_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;
  bit mix_rule;

  `uvm_object_utils(ptp_err_mix_invalid_sequence)
  function new(string name = "ptp_err_mix_invalid_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   `ifdef ENABLE_ETH_VIP
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   `endif
   `uvm_info("eth_seq_lib", "running ptp_err_mix_invalid_sequence\n",UVM_LOW)
   //mix_rule = $urandom();  //VR 1 will send v1 type
   mix_rule = 0;
   p_sequencer.env.m_ptp_tx_ref_model.fp_check_en = 0;
  fork
  begin
    repeat(500) begin
      if(mix_rule)
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB,INS_INVALID_V1,INS_INVALID_CS_EB_V1,INS_INVALID_ETS_V1};};
      else
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP,INS_INVALID_V2,INS_INVALID_CS_EB_V2,INS_INVALID_ETS_V2};};
      std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME,JUMBO_DATA_FRAME,JUMBO_VLAN_FRAME,JUMBO_STACKED_VLAN_FRAME};};
      randcase
        1:send_ptp_frame(ptp_op,f_type,1);  
        1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
      endcase
    end
  end
  begin
   `ifdef ENABLE_ETH_VIP
     send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,100);  
   `endif
  end
  join

  ////Randomize all ptp op with frame type/NON_PTP
  //repeat(100) begin
  //  std::randomize(ptp_op) with {ptp_op inside {INS_2STEP,INS_NOOP};};
  //  std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
  //  randcase
  //  1:send_ptp_frame(ptp_op,f_type,1);  
  //  1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
  //  endcase
  //end 
   
  endtask
endclass : ptp_err_mix_invalid_sequence
