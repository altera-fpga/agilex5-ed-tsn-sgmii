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


class eth_pause_xon_frame_during_am_fb596537 extends eth_stat_base_sequence;
  
  bit rx_fc_fwd;//rx frame fwd
  bit[47:0] rx_da; 
  bit[1:0] rx_fc_en;//en dis sfc pfc on rx path
 
   int frame_num_tx,frame_num_rx;

  `uvm_object_utils(eth_pause_xon_frame_during_am_fb596537)

  function new(string name = "eth_pause_xon_frame_during_am_fb596537");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("eth_pause_xon_frame_during_am_fb596537", "Executing eth_pause_xon_frame_during_am_fb596537 ...", UVM_NONE)
    super.body();
   rx_fc_fwd=1;//$urandom;
   rx_da={$urandom,$urandom}; 
   rx_fc_en=3;//rx side en sfc,en pfc
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_fc_fwd); 
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_da[31:0]); //same da for loopback mode only
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_da[47:32]); 
   dest_address=rx_da;
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_fc_en);
    
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif

    `uvm_info("eth_pause_xon_frame_during_am_fb596537", "3. Send one pause control frame with FCS error or without FCS error randomly.", UVM_NONE)

  repeat(500)
    begin
      fork
      begin
        send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,1);
        frame_num_rx++;
        `uvm_info("eth_pause_xon_frame_during_am_fb596537", $sformatf("RX frame_num=%0d, Pause frame ", frame_num_rx), UVM_LOW)
      end
      begin
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,1);
        frame_num_tx++;
        `uvm_info("eth_pause_xon_frame_during_am_fb596537", $sformatf("TX frame_num=%0d Data frame ", frame_num_tx), UVM_LOW)
      end
      join
    end

  endtask 

endclass : eth_pause_xon_frame_during_am_fb596537
