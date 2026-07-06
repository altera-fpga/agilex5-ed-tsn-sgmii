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


class eth_register_ip_hard_reset_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit [2:0]     reset_sel; 
  bit compare_disable[integer];
  bit [31:0] max_address = 'h5FF;
  bit [31:0] min_address = 'h300;
  int reg_index[$];

  `uvm_object_utils(eth_register_ip_hard_reset_sequence)

  function new(string name = "eth_register_ip_hard_reset_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

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
    
    foreach(regs_org[i]) begin
    if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))  
      regs_org.delete(i);
    end
    
    foreach(regs_org[i]) begin
    if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))  
      regs_org.delete(i);
    end
    
    foreach(regs_org[i]) begin
    if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))  
      regs_org.delete(i);
    end
 //mpotnurx
    foreach(regs_org[i]) begin
    if(regs_org[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pause_request_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))  
      regs_org.delete(i);
    end
    //foreach(regs_org[i]) begin
// FIXME-MISSING_REG_IN_GDR    //if(regs_org[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG)
    //  regs_org.delete(i);
    //end

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
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_ber_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_err_block_cnt_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_phy_ehip_mode_muxes_OFFSET_REG ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `ETH_F_ALL_link_fault_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_rx_pld_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_phy_rxpma_status_OFFSET_REG ||    
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
        //`ifdef G50
        ((regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))&&(p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G )) || //FB:551395:We cant set 'h1 for pp in env file.It's always take 'h1 in all simulation 
        //`endif
        //`ifdef CRETE3
// FIXME-MISSING_REG_IN_GDR        //  regs[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG ||    
        //`endif
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)    
        ) begin
        compare_disable[regs[i].get_address()] = 1;
      end 
      else begin
        compare_disable[regs[i].get_address()] = 0;
      end
    end
  
    //wait for ehip ready
    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    p_sequencer.env.reg_read('h37F,read_data); //Read Immediately
    p_sequencer.env.reg_read('h380,read_data); //Read Immediately
    p_sequencer.env.reg_read('h381,read_data); //Read Immediately
    //`ifndef CRETE3
      p_sequencer.env.reg_read('h382,read_data); //Read Immediately
    //`endif
   
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors();  //pbenittx
    `endif  
    
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
    begin 
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
    end

    foreach(regs[i]) begin
      `uvm_info("eth_register_ip_hard_reset_sequence", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end
    
    `uvm_info("eth_register_ip_hard_reset_sequence", "1:Read registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    //ignoring comparison for CNTR_STATUS,just check it's reset value
    compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
    compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
    compare_disable[`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;

    //#4us;
    `uvm_info("eth_register_ip_hard_reset_sequence", "2:Write registers", UVM_NONE)
    foreach(regs[i]) begin
      p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
    end
    
    `uvm_info("eth_register_ip_hard_reset_sequence", "3:Read registers", UVM_NONE)
    foreach(regs[i]) begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    //ignoring comparison for CNTR_STATUS,just check it's reset value
    compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0; 
    compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
    compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
    
    `uvm_info("eth_register_ip_hard_reset_sequence", "4:Applied Hard reset", UVM_NONE)
    p_sequencer.env.apply_reset("hard",0,0,1,$urandom_range(11,50));
    enable_disable_anlt_reset();
   
    if(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1) begin
      wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0);
    end

    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    p_sequencer.env.reg_read('h37F,read_data); //Read Immediately
    p_sequencer.env.reg_read('h380,read_data); //Read Immediately
    p_sequencer.env.reg_read('h381,read_data); //Read Immediately
    //`ifndef CRETE3  //dsamantx: FIX_ME for GDR
      p_sequencer.env.reg_read('h382,read_data); //Read Immediately
    //`endif
    
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1)); 
    
   `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors();  //pbenittx
    `endif
  
    `uvm_info("eth_register_ip_hard_reset_sequence", "5:Read registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    //ignoring comparison for CNTR_STATUS,just check it's reset value
    compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
    compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
    
    `uvm_info("eth_register_ip_hard_reset_sequence", "6:Write registers",UVM_NONE)
    foreach(regs[i]) begin
      p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
    end
    
    `uvm_info("eth_register_ip_hard_reset_sequence", "7:Read registers", UVM_NONE)
    foreach(regs[i]) begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
 
    `uvm_info("eth_register_ip_hard_reset_sequence", "8:Applied Soft reset", UVM_NONE)
    reset_sel = $urandom_range(1,7);
    p_sequencer.env.apply_reset("soft",reset_sel[0],reset_sel[1],reset_sel[2]);
    
    //if(reset_sel[0] == 1 || reset_sel[2] == 1)
    //begin
    //  `uvm_info("eth_register_ip_hard_reset_sequence", "8.2:Applied Soft reset", UVM_NONE)
    //  if(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1) begin
    //    `uvm_info("eth_register_ip_hard_reset_sequence", "8.3:Applied Soft reset", UVM_NONE)
    //    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0);
    //    `uvm_info("eth_register_ip_hard_reset_sequence", "8.4:Applied Soft reset", UVM_NONE)
    //  end
    //end
    
      //pbenittx : check for tx path reset
      if((reset_sel[0] == 1) || (reset_sel[2] ==1)) 
           // wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
           @(posedge (p_sequencer.env.master_agent.mast_agt_if.ehip_ready));

      //pbenittx : check for rx path reset 
      if((reset_sel[1] == 1) || (reset_sel[2] ==1)) 
           // p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
           @(posedge (p_sequencer.env.spy_if.rx_pcs_ready));           
   
// FIXME-MISSING_REG_IN_GDR    //compare_disable[`REGISTERS_PHY_CLK_OFFSET_REG] = 1;
    
    `uvm_info("eth_register_ip_hard_reset_sequence", "9:Read registers", UVM_NONE)
    foreach(regs[i]) begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `uvm_info("eth_register_ip_hard_reset_sequence", "10:Read registers", UVM_NONE)
    foreach(regs[i]) begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    `uvm_info("eth_register_ip_hard_reset_sequence", "11:Applied Hard reset", UVM_NONE)
    p_sequencer.env.apply_reset("hard",0,0,1,$urandom_range(11,50));
    enable_disable_anlt_reset();
    
    if(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1) begin
      wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0);
    end
    
    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    p_sequencer.env.reg_read('h37F,read_data); //Read Immediately
    p_sequencer.env.reg_read('h380,read_data); //Read Immediately
    p_sequencer.env.reg_read('h381,read_data); //Read Immediately
    //`ifndef CRETE3   //dsamantx:FIX_ME for GDR if needed
      p_sequencer.env.reg_read('h382,read_data); //Read Immediately
    //`endif
    
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1)); 
    
    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors();   //pbenittx
    `endif    
    
    //ignoring comparison for CNTR_STATUS,just check it's reset value
    compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0; 
    compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
    compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
// FIXME-MISSING_REG_IN_GDR    compare_disable[`REGISTERS_PHY_CLK_OFFSET_REG] = 0;

    `uvm_info("eth_register_ip_hard_reset_sequence", "12:Read registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

  endtask
endclass
