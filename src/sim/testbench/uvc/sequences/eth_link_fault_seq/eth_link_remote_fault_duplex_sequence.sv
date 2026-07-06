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


class eth_link_remote_fault_duplex_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  bit link_fault_en;
  int data_on_mii = 0 ;
  int read_count=0;
  `uvm_object_utils(eth_link_remote_fault_duplex_sequence)
  int node;
  function new(string name = "eth_link_remote_fault_duplex_sequence");
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

    dis_vec_sb();
    dis_stats_chk = 1;
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

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);

   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip

    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //link_fault_en =$urandom_range(0,1);
    link_fault_en =1;
    `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_NONE);
    read_data[0]  = link_fault_en; 
    read_data[1]  = 0; //Disable (clause-66) unidirection
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
 
   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
    //wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
    read_data[1]='h1;
    while (read_data[1] ==1) begin
     p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
    end
    
    // Send good packets & link fault packet in between
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
       send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,50);//start
     end
   join_none

   //`uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
   // p_sequencer.env.spy_if.check_rx_mii_remote_fault();
   //`uvm_info(get_name(), $sformatf("received remote fault order set on rx mii"), UVM_NONE);
   
   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
   //wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b1);
   read_data[1]='h0;
   fork
    begin
     fork 
      begin
       while (read_data[1] ==0) begin
        p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
	read_count++;
       end
      end
      begin
       wait(read_count>700);
       `uvm_error(get_name(), $sformatf("Waiting timeout for remote fault signal to high as read_count=%0d",read_count))
      end
     join_any
     #2ns;
     disable fork;
    end
    join

    //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
    
    repeat(6) @(posedge p_sequencer.env.spy_if.clk); 

   `uvm_info("eth_link_remote_fault_duplex_sequence", $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
    
    read_count=0;
    read_data[1]='h1;
    fork
      begin
       fork 
        begin
         while (read_data[1] ==1) begin
          if(link_fault_en == 1'b1) begin
           p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
           read_count++;
          end
         end
        end
        begin
         wait(read_count>100);
         `uvm_error(get_name(), $sformatf("Waiting timeout for remote fault signal to low",read_count))
        end
       join_any
       #2ns;
       disable fork;
      end
     join 

    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);

    //while (p_sequencer.env.spy_if.remote_fault[node] == 1'b1)
    //begin
    //  if(link_fault_en == 1'b1) begin
    //    if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1) 
    //    begin
    //      if(p_sequencer.env.spy_if.check_idle_tx_mii())
    //      begin
    //        `uvm_info("eth_link_remote_fault_duplex_sequence", $sformatf("CHECK_IDLE_TX_MII:data on tx mii correct when link fault is enabled."), UVM_NONE); 
    //      end
    //      else
    //      begin
    //        `uvm_error("eth_link_remote_fault_duplex_sequence", $sformatf("CHECK_IDLE_TX_MII:data on tx mii incorrect when link fault is enabled."));
    //      end
    //    end
    //  end
    //  else
    //  begin
    //    if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
    //    begin
    //       data_on_mii = data_on_mii + 1;
    //    end
    //  end
    //
    // //p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
    // //p_sequencer.env.read_data_chk(read_data,'h2);
    // repeat(1) @(posedge p_sequencer.env.spy_if.clk);
    //end
    //  
    //if(data_on_mii == 0 && link_fault_en == 0)
    //begin
    //  `uvm_warning(get_name(), $sformatf("data on tx mii has idle symbol value, please take a look at waves and confirm it is not caused by remote fault when link fault is off."));
    //end
   
    //`uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
    //wait(p_sequencer.env.spy_if.remote_fault[node] == 1'b0);
    //
    ////p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    ////p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    ////p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //p_sequencer.env.reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
    
    //FIXME : check why objection drop is not working
    #50us;

  endtask
endclass
