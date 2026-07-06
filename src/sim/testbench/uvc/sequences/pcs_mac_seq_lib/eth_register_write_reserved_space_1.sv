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


class eth_register_write_reserved_space_1 extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit [2:0]     reset_sel; 
  bit compare_disable[integer];
  bit [31:0] max_address = 'h5FF;
  bit [31:0] min_address = 'h300;
  int reg_index[$];

  `uvm_object_utils(eth_register_write_reserved_space_1)

  function new(string name = "eth_register_write_reserved_space_1");
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
        regs[i].get_address() == `GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
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

    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    p_sequencer.env.reg_read('h37F,read_data); //Read Immediately
    p_sequencer.env.reg_read('h380,read_data); //Read Immediately
    p_sequencer.env.reg_read('h381,read_data); //Read Immediately
    //`ifndef CRETE3   dsamantx:FIX_ME for GDR if needed
      p_sequencer.env.reg_read('h382,read_data); //Read Immediately
    //`endif
   
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

   
    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors(); //pbenittx  
    `endif

	   
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1)  
    begin 
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
    end

    foreach(regs[i]) begin
      `uvm_info("eth_register_write_reserved_space_1", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_MEDIUM)
    end

    //pbenittx : Splitting the 'hc00 register space according to their attributes
   //`ifdef PTP_MODE  //dsamantx:FIX_ME for GDR_PTP mode
    `uvm_info("eth_register_write_reserved_space_1", "write Pattern on reserved space('hC00-'hCFF)...", UVM_LOW)
    
    //pbenittx: RW register space
    for(int addr = 'hC00;addr <= 'hC01;addr++)
    begin
      p_sequencer.env.reg_write(addr,'h55555555);
      p_sequencer.env.reg_read(addr,read_data);
    end

    //pbenittx: RO register space
    for(int addr = 'hC02;addr <= 'hC3F;addr++)
    begin
      p_sequencer.env.reg_write(addr,'h55555555);
      p_sequencer.env.reg_read(addr,read_data,1);
    end

    //pbenittx: RW register space
    for(int addr = 'hC40;addr <= 'hC67;addr++)
    begin
      p_sequencer.env.reg_write(addr,'h55555555);
      p_sequencer.env.reg_read(addr,read_data);
    end
    //`endif

    `uvm_info("eth_register_write_reserved_space_1", "write Pattern on reserved space('hD00-'hDFF)...", UVM_LOW)
    for(int addr = 'hD00;addr <= 'hDFF;addr++)
    begin
      p_sequencer.env.reg_write(addr,'h55555555);
      p_sequencer.env.reg_read(addr,read_data);
    end


    `uvm_info("eth_register_write_reserved_space_1", "write Pattern on reserved space('hE00-'hEFF)...", UVM_LOW)
    for(int addr ='hE00;addr <= 'hEFF;addr++)
    begin
      p_sequencer.env.reg_write(addr,'hAAAAAAAA);
      p_sequencer.env.reg_read(addr,read_data);
    end

    //pbenittx : Splitting the 'hc00 register space according to their attributes
    //`ifdef PTP_MODE //dsamantx :FIX_ME for GDR_PTP mode
    `uvm_info("eth_register_write_reserved_space_1", "read Pattern on reserved space('hC00-'hCFF)...", UVM_LOW)
     //pbenittx: RW register space
     for(int addr = 'hC00;addr <= 'hC01;addr++)  
    begin
      p_sequencer.env.reg_read(addr,read_data);
    end

     //pbenittx: RO register space
    for(int addr = 'hC02;addr <= 'hC3F;addr++)
    begin
      p_sequencer.env.reg_read(addr,read_data,1);
    end

     //pbenittx: RW register space
    for(int addr = 'hC40;addr <= 'hC67;addr++)
    begin
      p_sequencer.env.reg_read(addr,read_data);
    end

    // `endif     //dsamantx :FIX_ME for GDR_PTP mode

    `uvm_info("eth_register_write_reserved_space_1", "write Pattern on reserved space('hD00-'hEFF)...", UVM_LOW)
    for(int addr = 'hD00;addr <= 'hEFF;addr++)
    begin
      p_sequencer.env.reg_read(addr,read_data);
    end

   
    `uvm_info("eth_register_write_reserved_space_1", "write Pattern on reserved space('h300-'h9FF)...", UVM_LOW)
    for(int addr ='h300;addr <= 'h9FF;addr++)
    begin
      if (addr == 'h340 || addr == 'h341 || addr == 'h342)
    `uvm_info("eth_register_write_reserved_space_1", "addr is 340 or 341 or 342:fb", UVM_NONE) //fb:551427 these registers need to be check in last
       else
      begin
    //`ifdef CRETE3   //dsamantx:FIXME for GDR
      if((addr >'h839 && addr <= 'h8FF) ||(addr >'h939 && addr <= 'h9FF) || addr == 'h315 || addr == 'h329 || addr == 'h320 || addr == 'h37c ||  addr == 'h323 || addr == 'h313 ||  addr == 'h326 || (addr >= 'h361 && addr <= 'h374) ||  addr == 'h328 || (addr >= 'h330 && addr <= 'h333) || (addr >= 'h37F && addr <= 'h382) || addr == 'h340 || addr == 'h341 || addr == 'h342 || addr == 'h32b) //pbenittx:skipping `h32b register since it is not present in crete_3 register set.
    //`else
     // if((addr >'h839 && addr <= 'h8FF) ||(addr >'h939 && addr <= 'h9FF) || addr == 'h315 || addr == 'h329 || addr == 'h320 || addr == 'h32a || addr == 'h37c ||  addr == 'h323 || addr == 'h326 || addr == 'h328 || (addr >= 'h330 && addr <= 'h333) || (addr >= 'h37F && addr <= 'h382) ||(addr >= 'h361 && addr <= 'h374) ||  addr == 'h340 || addr == 'h341 || addr == 'h342) 
    //`endif
        p_sequencer.env.reg_read(addr,read_data,1);
      else
        p_sequencer.env.reg_read(addr,read_data,1);
      end
    end
   
    `uvm_info("eth_register_write_reserved_space_1", "Due to fb:551427 these regs need to check in last", UVM_LOW)
    for(int addr ='h340;addr <= 'h343;addr++)
    begin
    if(addr =='h341 || addr =='h342 || addr == 'h343)
    begin
      p_sequencer.env.reg_write(addr,'hAAAAAAAA);
      p_sequencer.env.reg_read(addr,read_data,1);
    end
    end

  endtask
endclass
