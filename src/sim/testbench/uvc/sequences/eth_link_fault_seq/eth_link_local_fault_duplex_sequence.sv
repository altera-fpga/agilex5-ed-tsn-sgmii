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


class eth_link_local_fault_duplex_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  bit link_fault_en;
  int node;
  `uvm_object_utils(eth_link_local_fault_duplex_sequence)

  function new(string name = "eth_link_local_fault_duplex_sequence");
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

    p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    link_fault_en =  0;//$urandom_range(0,1);
    `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_LOW);
    read_data[0] = link_fault_en; 
    read_data[1] = 0; //Disable (clause-66) unidirection
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
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
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    //if (p_sequencer.env.tb_cfg.pcs_40g_mode) 
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
    //else 
    //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);  
     
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
    

   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
    wait(p_sequencer.env.spy_if.local_fault[node] == 1'b0);

    fork
     begin
       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,5);
     end
  
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,5);
     end

     begin
       for(int j=0;j<$urandom_range(2,4);j++)
       begin 
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
         `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
       end
       generate_hiber();
     end
   join_none

   `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
    p_sequencer.env.spy_if.check_rx_mii_local_fault();
 
   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
    wait(p_sequencer.env.spy_if.local_fault[node] == 1'b1);
    
    //This dummy read is to accomodate thertl internal dealy to update the register
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
    p_sequencer.env.read_data_chk(read_data,'h1);
    
   `uvm_info(get_name(), $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
    while (p_sequencer.env.spy_if.local_fault[node] == 1'b1)
    begin
      if(link_fault_en == 1'b1) begin
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
      //  if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
      //  begin
      //    `uvm_info(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii correct when link fault is disable."), UVM_NONE); 
      //  end
      //  else
      //  begin
      //    `uvm_error(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii incorrect when link fault is disabl."));
      //  end

        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
        begin
          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
          begin
            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is disabl."));
          end
          else
          begin
            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is disable."), UVM_DEBUG); 
          end
        end
      end
    
     p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
    p_sequencer.env.read_data_chk(read_data,'h1);
    end
   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
    wait(p_sequencer.env.spy_if.local_fault[node] == 1'b0);

    fork
     begin
       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
     end
  
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
     end

     begin
       for(int j=0;j<$urandom_range(10,15);j++)
       begin 
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
         `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
       end
       generate_hiber();
     end
   join_none

   `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
    p_sequencer.env.spy_if.check_rx_mii_local_fault();
  
    `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
    wait(p_sequencer.env.spy_if.local_fault[node] == 1'b1);

    //This dummy read is to accomodate thertl internal dealy to update the register
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
    p_sequencer.env.read_data_chk(read_data,'h1);

   `uvm_info(get_name(), $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
    while (p_sequencer.env.spy_if.local_fault[node] == 1'b1)
    begin
      if(link_fault_en == 1'b1) begin
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
     //   if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
     //   begin
     //     `uvm_info(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii correct when link fault is disable."), UVM_NONE); 
     //   end
     //   else
     //   begin
     //     `uvm_error(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii incorrect when link fault is disabl."));
     //   end

        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
        begin
          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
          begin
            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is disabl."));
          end
          else
          begin
            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is disable."), UVM_DEBUG); 
          end
        end
      end
    
     p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
    p_sequencer.env.read_data_chk(read_data,'h1);
    end
   
   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
    wait(p_sequencer.env.spy_if.local_fault[node] == 1'b0);
    
    //This dummy read is to accomodate thertl internal dealy to update the register
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
    #50us; 
  endtask
endclass
