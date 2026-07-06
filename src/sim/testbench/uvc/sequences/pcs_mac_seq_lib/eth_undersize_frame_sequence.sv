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


class eth_undersize_frame_sequence extends eth_base_sequence;
  
  `uvm_object_utils(eth_undersize_frame_sequence)
  
  function new(string name = "eth_undersize_frame_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   //p_sequencer.env.apply_reset("hard",0,0,1,11);
   `uvm_info("eth_undersize_frame_sequence", "Executing eth_undersize_frame_sequence ...", UVM_LOW)
   //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   `ifdef ENABLE_ETH_VIP 
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   `endif

   send_eth_frame(UNDERSIZE_FRAME,AVL_TX_ETH_VIP,50);
  //`ifdef ENABLE_ETH_VIP 
  // p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
  // p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
  // `endif

   send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,50);
   send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,50);

   send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_MAC_BOTH,10);
   send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
   send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_MAC_BOTH,10);
   send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
   `uvm_info("eth_undersize_frame_sequence", "Exiting eth_undersize_frame_sequence ...", UVM_LOW)
  endtask
endclass
