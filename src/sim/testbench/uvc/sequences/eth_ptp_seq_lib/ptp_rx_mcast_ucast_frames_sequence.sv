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


class ptp_rx_mcast_ucast_frames_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type, f_type_vip;
  bit mix_rule;

  `uvm_object_utils(ptp_rx_mcast_ucast_frames_sequence)
  function new(string name = "ptp_rx_mcast_ucast_frames_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   `ifdef ENABLE_ETH_VIP 
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_ip_ext_mobility_header_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_tcp_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_udp_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
   `uvm_info("eth_seq_lib", "running ptp_rx_mcast_ucast_frames_sequence\n",UVM_LOW)
    //mix_rule = $urandom(); 
    mix_rule = 0; //disabling v1 frames 
   fork
    begin
      repeat(200) begin
        if(mix_rule)  
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
        std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};}; 
        
        randcase
        1:send_ptp_frame(ptp_op,f_type,1);  
        1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
        endcase
      end
    end
    begin
      `ifdef ENABLE_ETH_VIP
      repeat(200) begin
       randcase
       1:send_eth_frame(MCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);  
       1:send_eth_frame(MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);  
       1:send_eth_frame(BCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);  
       1:send_eth_frame(BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);  
       1:send_eth_frame(IPV4_FRAME,ETH_VIP_AVL_RX,1);  
       1:send_eth_frame(IPV6_FRAME,ETH_VIP_AVL_RX,1);  
       endcase
      end
      `endif
    end
   join

  endtask

endclass : ptp_rx_mcast_ucast_frames_sequence
