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


class eth_link_remote_fault_128blk_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  bit link_fault_en,success;
  int data_on_mii = 0 ;
  int case_no=1;
  int delay_count;
  int node;
`ifdef G100  
  int max_colm=29;
`else
  int max_colm=63;
`endif  
  `uvm_object_utils(eth_link_remote_fault_128blk_sequence)

  function new(string name = "eth_link_remote_fault_128blk_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   node  = (p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) ? 15: 
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) ? 7:
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) ? 3:
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) ? 1: 0;

//    apply_hard_reset(0,0,1,11);
    dis_vec_sb();
    dis_stats_chk = 1;

//    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);

    //p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    // ***** No need to set any registers in ehip, parameter already takes care of it *****//
    link_fault_en = 1 ;//$urandom_range(0,1);
    `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_NONE);
    //read_data[0]  = link_fault_en; 
    //read_data[1]  = $urandom_range(0,1);
    //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

    //case - 1 //send alternate patter of fault symbol
    `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
    send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);

    `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
    wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
       
`ifdef G100  
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    repeat(8) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    repeat(16) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    repeat(24) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
`else
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    repeat(10) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    repeat(20) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    repeat(30) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
`endif  

    `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
    wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
     
    for( int i =(max_colm - 5)  ;i<max_colm;i++) 
    begin
      case_no = case_no + 1 ;
      `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
      `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
  
      //case -2 // send fault oreder set such that they exact meet 128 column boundary
      send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);

      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
      repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
      repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
      repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
`ifdef G100
      repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
      repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
`endif  

    `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
      
      send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);

    end

    case_no = case_no + 1 ;
    `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
    `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
    wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
 
    send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
  
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    
`ifdef G100  
    success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
`else
    success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
`endif  
    `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
    if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
    repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
    
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    
`ifdef G100  
    success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
`else
    success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
`endif  
    `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
    if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
    repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
    
    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
    
`ifdef G100  
    success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
`else
    success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
`endif  
    `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
    if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
    repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);

    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start

    `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
    wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
    
    `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
    wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);

    #100ns;

    endtask
endclass
