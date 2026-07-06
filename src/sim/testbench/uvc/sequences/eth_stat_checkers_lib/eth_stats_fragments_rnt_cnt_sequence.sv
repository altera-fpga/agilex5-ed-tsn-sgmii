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


class eth_stats_fragments_rnt_cnt_sequence extends eth_stat_base_sequence;

  `uvm_object_utils(eth_stats_fragments_rnt_cnt_sequence)
  int frame_num_tx, frame_num_rx;
  int iter_cnt;

  function new(string name = "eth_stats_fragments_rnt_cnt_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    
    `uvm_info("eth_stats_fragments_rnt_cnt_sequence", "Started eth_stats_fragments_rnt_cnt_sequence...", UVM_NONE)
    super.body();

    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
   
    iter_cnt = (p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 10:50;
    $display("iteration count = %0d ",iter_cnt);
    // Inject Different types of Frament and Runt frames
    repeat(iter_cnt) begin
      fork
        begin
          randcase 
            1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(DATA_FRAME,63,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(VLAN_FRAME,63,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,63,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(DATA_FRAME,64,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(VLAN_FRAME,64,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,64,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,-1);
            1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);
            1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,63);
            1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,63);
            1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,63);
            1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,64);
            1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,64);
            1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,64);
          endcase
          frame_num_rx++;
	end  
        begin
          randcase 
            1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(DATA_FRAME,63,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(VLAN_FRAME,63,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,63,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(DATA_FRAME,64,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(VLAN_FRAME,64,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,64,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1);
            1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
            1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,63);
            1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,63);
            1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,63);
            1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,64);
            1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,64);
            1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,64);
          endcase
          frame_num_tx++;
	end  
      join	
      // Read registers after 5 packets interval to reduce runtime
    end

//    p_sequencer.env.ts_tasks_if.force_dut_signal("eth_env_top.dut.top.alt_s100.alt_e100s10_mac.u_stats_counters.u_rx_stats_counters.stats_ram_0_15.view_wdata",32'hFFFF_FFFE);
//    #1ns;
//    p_sequencer.env.ts_tasks_if.release_dut_signal("eth_env_top.dut.top.alt_s100.alt_e100s10_mac.u_stats_counters.u_rx_stats_counters.stats_ram_0_15.view_wdata");


    // Fixme : add code for the remaining part of the sequence after support for forcing register to fix value is added 

//    force $root.eth_env_top.dut.top.alt_s100.csr.write = 1'b1;
//    force $root.eth_env_top.dut.top.alt_s100.csr.address = 16'h900;
//    force $root.eth_env_top.dut.top.alt_s100.csr.data_in = 32'hFFFF_FFFE;
//    repeat(12) @(posedge $root.eth_env_top.dut.top.alt_s100.csr.csr_clk);
//    release $root.eth_env_top.dut.top.alt_s100.csr.write;
//    release $root.eth_env_top.dut.top.alt_s100.csr.address;
//    release $root.eth_env_top.dut.top.alt_s100.csr.data_in;

//    uvm_hdl_force($root.eth_env_top.dut.top.alt_s100.csr.write,1'b1);
//    uvm_hdl_force($root.eth_env_top.dut.top.alt_s100.csr.address,16'h900);
//    uvm_hdl_force($root.eth_env_top.dut.top.alt_s100.csr.data_in,32'hFFFF_FFFE);
//   // (12) @(posedge $root.eth_env_top.dut.top.alt_s100.csr.csr_clk);
//    #120ns; 
//    uvm_hdl_release($root.eth_env_top.dut.top.alt_s100.csr.write);
//    uvm_hdl_release($root.eth_env_top.dut.top.alt_s100.csr.address);
//    uvm_hdl_release($root.eth_env_top.dut.top.alt_s100.csr.data_in);


    `uvm_info("eth_stats_fragments_rnt_cnt_sequence", " Read all stats counter registers", UVM_NONE)
    p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));
    p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
       #250us;
    end
    read_and_compare_stats();
  
  endtask

  task read_registers();
    #2000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read. 
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

  endtask

endclass : eth_stats_fragments_rnt_cnt_sequence
