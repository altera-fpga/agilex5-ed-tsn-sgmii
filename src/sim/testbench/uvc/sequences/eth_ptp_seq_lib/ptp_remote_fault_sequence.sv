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


class ptp_remote_fault_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;
  bit fault;
  bit mix_rule;
  uvm_reg_data_t read_data, tx_link_reg;
  svt_ethernet_enum_pkg::link_fault_sequence_type_enum local_link_fault_type;
  int node;
  bit link_fault_en,chk_rmt_flt=0;
  int read_cnt=0,random_cnt;



  `uvm_object_utils(ptp_remote_fault_sequence)
  function new(string name = "ptp_remote_fault_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
    dis_vec_sb();
   
   dis_stats_chk=1;
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //read_data[0]=1;
   //read_data[1]=$urandom_range(0,1);
   //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

   node  = ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G)) ? (($test$plusargs("ETH17A_21"))?17:(($test$plusargs("ETH17A_20"))?18:15)): 
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) ? 7:
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) ? 3:
            (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) ? 1: 0;

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);

p_sequencer.env.sb_mac_tx_vip_rx.scb_dis=1;
//p_sequencer.env.sb_vip_tx_mac_rx.scb_dis=1;

   //p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
   //p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
   `uvm_info("eth_seq_lib", "running ptp_remote_fault_sequence\n",UVM_LOW)
   //mix_rule = $urandom;
   mix_rule = 0;  //V1 frames are not supported for QHIP
 /*  fork
    begin
      repeat(80) begin
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
      repeat(5) begin
       randcase
       1:send_eth_frame_with_fix_size(RANDOM_FRAME,64,1,ETH_VIP_AVL_RX);
       1:send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);  
       endcase
      end
    end
    begin
            repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,$urandom_range(100,500));//sending remote_fault
      `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go high\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
      `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go low\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
      repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,$urandom_range(100,500));//sending local_fault
      `uvm_info("ptp_link_fault_sequence", "Waiting for local_fault to go high\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.local_fault[node] == 1'b1);
      `uvm_info("ptp_link_fault_sequence", "Waiting for local_fault to go low\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.local_fault[node] == 1'b0);
    end  
   join
   #5us;
     // `uvm_info("ptp_link_fault_sequence", "Done 1\n",UVM_LOW)
      `uvm_info("ptp_link_fault_sequence", "Disabling mac_tx_vip_rx scb\n",UVM_LOW)

//p_sequencer.env.sb_mac_tx_vip_rx.scb_dis=1;


   fork
    begin
      repeat(50) begin
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
      repeat(5) begin
       randcase
       1:send_eth_frame_with_fix_size(RANDOM_FRAME,64,1,ETH_VIP_AVL_RX);
       1:send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);  
       endcase
      end
    end
    begin
      repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,$urandom_range(100,500));//sending remote_fault
      `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go high\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
      `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go low\n",UVM_LOW)
      wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
      repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      repeat($urandom_range(1,3)) begin
        fault = $urandom_range(0,1);
        if(fault) begin 
          local_link_fault_type = svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT; end
        else begin
          local_link_fault_type = svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT; end
        repeat($urandom_range(200,300)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
        send_link_fault(local_link_fault_type,$urandom_range(100,500));
        if(fault==1) begin
          `uvm_info("ptp_link_fault_sequence", "Waiting for local_fault to go high\n",UVM_LOW)
          wait(p_sequencer.env.spy_if.local_fault[node] == 1'b1);
          `uvm_info("ptp_link_fault_sequence", "Waiting for local_fault to go low\n",UVM_LOW)
          wait(p_sequencer.env.spy_if.local_fault[node] == 1'b0);
	end
        else begin
          `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go high\n",UVM_LOW)
          wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
          `uvm_info("ptp_link_fault_sequence", "Waiting for remote_fault to go low\n",UVM_LOW)
          wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
        end
        repeat($urandom_range(200,800)) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk[node]);
      end
    end  
   join
*/
     // `uvm_info("ptp_link_fault_sequence", "Done 2\n",UVM_LOW)

   p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    link_fault_en =  $urandom_range(0,1);
    read_data[0] = link_fault_en;
    read_data[2:1] = $urandom_range(0,3);
    `uvm_info("main_phase", $sformatf("link_fault_en::%d", link_fault_en), UVM_LOW);
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

    fork
     begin
     // send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
     repeat(100) begin
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


    //  `uvm_info("ptp_link_fault_sequence", "Done 3\n",UVM_LOW)


//p_sequencer.env.sb_mac_tx_vip_rx.scb_dis=0;



/*    fork
     begin
      // send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
      send_ptp_frame(ptp_op,f_type,25);
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

      `uvm_info("ptp_link_fault_sequence", "Done 4\n",UVM_LOW)
      */
    #5us;
    
   endtask
endclass : ptp_remote_fault_sequence
