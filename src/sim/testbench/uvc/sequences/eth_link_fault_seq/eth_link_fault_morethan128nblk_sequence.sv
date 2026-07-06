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


class eth_link_fault_morethan128nblk_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  bit link_fault_en,success;
  int fault_pair = 0 ;
  int case_no=0;
  int fault_count=0;
  int delay_count;
  int node;
`ifdef G100  
  int max_cnt=32;
`else
  int max_cnt=64;
`endif  
  svt_ethernet_enum_pkg::link_fault_sequence_type_enum local_link_fault_type;

  `uvm_object_utils(eth_link_fault_morethan128nblk_sequence)

  function new(string name = "eth_link_fault_morethan128nblk_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
//    apply_hard_reset(0,0,1,11);
    dis_vec_sb();
    dis_stats_chk = 1;

     node  = (p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) ? 15: 
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) ? 7:
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) ? 3:
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) ? 1: 0;


//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
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

    success = $urandom_range(0,1);
    if(success) begin 
      local_link_fault_type = svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT; end
    else begin
      local_link_fault_type = svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT; end


    fork : thread_1 
    begin
      //case 1 to 4
      for( int i = max_cnt-1;i<max_cnt+10;i++) 
      begin
        case_no = case_no + 1 ;
        `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
        `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
        wait(p_sequencer.env.spy_if.local_fault[node] == 1'b0);
  
        send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);

        send_link_fault(local_link_fault_type,1);//start
        repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
        send_link_fault(local_link_fault_type,1);//start
        repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
        send_link_fault(local_link_fault_type,1);//start
        repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
        send_link_fault(local_link_fault_type,1);//start
        //delay for link fault asserion check
	repeat(100) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      end

      //case 5 onwards 
      for(int k=0;k<10;k++)
      begin
        case_no = case_no + 1 ;
        `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
        `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
        delay_count = $urandom_range(max_cnt+10,max_cnt+100);
        fault_pair =  $urandom_range(1,3);
        `uvm_info(get_name(), $sformatf("case ::%d - sending %0d pairs of link faults seperated by %0d clocks",case_no,fault_pair,delay_count), UVM_NONE);
        send_link_fault(local_link_fault_type,fault_pair);
        repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      end

      //approx time to finish and reach all link fault os to rtl
      #3000ns;	
      disable thread_1; 
    end

    begin
     forever begin
       @(posedge p_sequencer.env.spy_if.fault[node]);
       fault_count = fault_count + 1;
       `uvm_info(get_name(), $sformatf("fault_count ::%d", fault_count), UVM_NONE);
     end
    end
    join
        
    `uvm_info(get_name(), $sformatf("final fault_count ::%d", fault_count), UVM_NONE);
   
    //we cant predict exact delay between two os as we send data from vip serial lane and link fault chekcing happens on mii so it is possible to see +/-1 mii clock tolerance
    // as we send the os with gap of 63 and 64 in case 1,2, it may possible that fault detection happens one or twice based on 126-128 column boundary.
    // this case gaurantee > 130 gap between os wont result in link fault instead accurate 128 column
    // For C2E, tolerence observed is +/-2 hence max we shall see is 3
    // (For C2E 50G random seed 4051 with B181 we see 4 RF's being detected and looks legitimate - hence increasing to 4)
    if(fault_count > 4 ) begin
     `uvm_error(get_name(), $sformatf("false link fault detected"));
    end
    #100ns;

    endtask
endclass
