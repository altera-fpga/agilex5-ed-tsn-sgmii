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


class eth_register_write_reserved_space_FF extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit [2:0]     reset_sel; 
  bit compare_disable[integer];
  bit [31:0] max_address = 'h5FF;
  bit [31:0] min_address = 'h300;
  int reg_index[$];

  `uvm_object_utils(eth_register_write_reserved_space_FF)

  function new(string name = "eth_register_write_reserved_space_FF");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    //disabling register coverage
    //p_sequencer.env.dis_reg_cov=1; //disabling register coverage
    p_sequencer.env.apply_reset("hard",0,0,1,11);
    enable_disable_anlt_reset();

    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count ==1 )   max_address = 'h9FF; 
    if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == 1) max_address = 'hDFF;
    p_sequencer.reg_model.default_map.get_registers(regs_org);
    
    foreach(regs_org[i]) begin
       if(regs_org[i].get_address() == `ETH_F_ALL_clk_tx_khz_OFFSET_REG ||
          regs_org[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG || 
          regs_org[i].get_address() == `ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG )
      regs_org.delete(i);
    end
    
    foreach(regs_org[i]) begin
    if(regs_org[i].get_address() == `ETH_F_ALL_clk_rx_khz_OFFSET_REG) //FB:551427 for KHZ_RX 
      regs_org.delete(i);
    end

    `uvm_info(get_name(), $sformatf("max_address =%0d ", max_address), UVM_MEDIUM)

    foreach(regs_org[i]) begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) begin 
        regs.push_back(regs_org[i]);
      end
    end
 
    foreach(regs[i]) begin
      if(
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        //`ifdef G50
        ((regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))&&(p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G )) || //FB:551395:We cant set 'h1 for pp in env file.It's always take 'h1 in all simulation 
        //`endif
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)    
        ) begin
        compare_disable[regs[i].get_address()] = 1;
      end 
      else begin
        compare_disable[regs[i].get_address()] = 0;
      end
    end

    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    p_sequencer.env.reg_read('h37F,read_data); //Read Immediately
    p_sequencer.env.reg_read('h380,read_data); //Read Immediately
    p_sequencer.env.reg_read('h381,read_data); //Read Immediately
    //`ifndef CRETE3
      p_sequencer.env.reg_read('h382,read_data); //Read Immediately
    //`endif
   
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    

     
    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors();   //pbenittx
    `endif

    //mpotnurx:To ignore the errors from vip.
//     `ifdef ENABLE_ETH_VIP
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
//	p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//
//        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);//pbenittx added this ignore statement due to got error from vip for 19.2/31 
//      
//      `endif	
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1)  
    begin 
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
    end

    foreach(regs[i]) begin
      `uvm_info("eth_register_write_reserved_space_FF", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_MEDIUM)
    end

    `uvm_info("eth_register_write_reserved_space_FF", "1:Read registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    `uvm_info("eth_register_write_reserved_space_FF", "2:Read registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `uvm_info("eth_register_write_reserved_space_FF", "3:Read registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    `uvm_info("eth_register_write_reserved_space_FF", " write Pattern on reserved space('h401-'h4FF)...", UVM_LOW)
    for(int addr = 'h401;addr <= 'h4FF;addr++)
    begin
      p_sequencer.env.reg_write(addr,'h55555555);
      p_sequencer.env.reg_read(addr,read_data);
    end
    
    `uvm_info("eth_register_write_reserved_space_FF", " write Pattern on reserved space('hF401-'hF4FF)...", UVM_LOW)
    for(int addr = 'hF401;addr <= 'hF4FF;addr++)
    begin
      p_sequencer.env.reg_write(addr,'hAAAAAAAA);
      p_sequencer.env.reg_read(addr,read_data);
    end
    
    `uvm_info("eth_register_write_reserved_space_FF", " write Pattern on reserved space('h401-'h4FF)...", UVM_LOW)
    for(int addr = 'h401;addr <= 'h4FF; addr++)
    begin
      //p_sequencer.env.reg_write(addr,'h55555555);
      p_sequencer.env.reg_read(addr,read_data);
    end

    `uvm_info("eth_register_write_reserved_space_FF", " write Pattern on reserved space('hF401-'hF4FF)...", UVM_LOW)
    for(int addr = 'hF401;addr <= 'hF4FF; addr++)
    begin
      //p_sequencer.env.reg_write(addr,'hAAAAAAAA);
      p_sequencer.env.reg_read(addr,read_data);
    end

  endtask//body
endclass//write_reserved_space_ff
