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


class ipv4_ipv6_user_defined_frame_sequence extends eth_base_sequence;
  bit rx_crc_pass;
  `uvm_object_utils(ipv4_ipv6_user_defined_frame_sequence)
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=50;
   end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
 endfunction:new

  virtual task body();
    uvm_reg_data_t rd_data;
    `uvm_info("eth_seq_lib", "running ipv4 sequence\n",UVM_LOW)
   //p_sequencer.env.apply_reset("hard",0,0,1,11);
   //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   //Shabbir- FB560308 CRC passthrough can not be enabled with remove pads (bytestoremove=2) (rx_bytes_to_remove = "Remove CRC and PAD bytes")
   if(rd_data[8] == 0)
   begin
     rx_crc_pass=$urandom;
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
   end
   `ifdef ENABLE_ETH_VIP
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_ip_ext_mobility_header_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ospf_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_tcp_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_udp_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
    fork
      send_eth_frame(IPV4_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
      send_eth_frame(IPV6_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
      send_eth_frame(USER_DEFINED_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
      send_eth_frame(IPV4_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
      send_eth_frame(IPV6_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
      send_eth_frame(USER_DEFINED_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
    join
  `else
    send_eth_frame(IPV4_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
    send_eth_frame(IPV6_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
    send_eth_frame(USER_DEFINED_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
 `endif
  endtask
endclass
