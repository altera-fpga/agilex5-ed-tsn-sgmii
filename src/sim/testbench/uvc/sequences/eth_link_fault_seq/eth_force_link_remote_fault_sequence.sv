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


class eth_force_link_remote_fault_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data,tx_link_reg;
  bit remote_fault_disable;
  int read_cnt=0,random_cnt;
  bit link_fault_en,chk_rmt_flt=0;

  `uvm_object_utils(eth_force_link_remote_fault_sequence)

  function new(string name = "eth_force_link_remote_fault_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
//    apply_hard_reset(0,0,1,11);
    dis_vec_sb();
    dis_stats_chk = 1;

//    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);


    p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    link_fault_en =  $urandom_range(0,1);
    read_data[0] = link_fault_en;
    read_data[2:1] = $urandom_range(0,3);
    `uvm_info("main_phase", $sformatf("link_fault_en::%d", link_fault_en), UVM_LOW);
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

    fork
     begin
       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
     end
  
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
     end

     begin
       for(int j=0;j<$urandom_range(10,25);j++)
       begin 
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
         `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
       end
       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
       tx_link_reg[3] = 1; 
       p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
       chk_rmt_flt = 1;
     end
     join_none
     
     random_cnt = $urandom_range(10,50);
    `uvm_info("main_phase", $sformatf("random_cnt::%d", random_cnt), UVM_LOW);
     
    wait(chk_rmt_flt == 1);

     p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
     while(tx_link_reg[3] == 1)
     begin
        if(link_fault_en == 1) begin
          if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
          begin
            if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
            begin
              `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is enabled."), UVM_DEBUG); 
            end
            else
            begin
              `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is enabled."));
            end
          end
        end 
	else
	begin
          if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
          begin
            if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
            begin
              `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is disabl."));
            end
            else
            begin
              `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT :data on tx mii correct when link fault is disable."), UVM_DEBUG); 
            end
          end
        end

       p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
       p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
       read_cnt = read_cnt + 1;

       if(read_cnt == random_cnt)
       begin
         tx_link_reg[3] = 0; 
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
         break;
       end
     end
 
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);

    send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,5);
 
    #1us;
    
  endtask
endclass
