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


class eth_register_access_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit compare_disable[integer];
  bit [31:0] max_address='h14c;
  bit [31:0] min_address='h100;

  `uvm_object_utils(eth_register_access_sequence)

  function new(string name = "eth_register_access_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    //p_sequencer.env.reg_cov.dis_reg_cov=1; //disabling register coverage
    p_sequencer.env.dyn_rcfg_obj_inst.print();
    //if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count ==1 )   max_address = 'h9ff; 
    //if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == 1) max_address = 'hdff;

    //dsamantx :TO DO:Need to specify the address according to speed
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G) max_address='h1c78;

    p_sequencer.reg_model.default_map.get_registers(regs_org);
    enable_disable_anlt_reset();

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
    if(regs_org[i].get_address() == (`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))
      regs_org.delete(i);
    end
    
    `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)

    foreach(regs_org[i]) 
    begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
      begin
        regs.push_back(regs_org[i]);
      end
    end

    foreach(regs[i]) begin
      if(
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||    
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||    
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||    
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||
	regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||    
        regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) ||
        ((regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))&&(p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G )) || //FB:551395:We cant set 'h1 for pp in env file.It's always take 'h1 in all simulation 
        regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))    
        ) begin
        compare_disable[regs[i].get_address()] = 1;
      end 
      else begin
        compare_disable[regs[i].get_address()] = 0;
      end
    end
    
    //dsamantx: ehip_ready is not available in GDR set up, so wait for tx_lane_Stable
    //wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    wait (p_sequencer.env.master_agent.mast_agt_if.tx_lane_stable == 1'b1); 
    
    p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
   
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors();
    `endif

    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
    begin 
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
    end

    foreach(regs[i]) begin
      `uvm_info("eth_register_access_sequence", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end
    
    `uvm_info("eth_register_access_sequence", "1:Read registers", UVM_NONE)
    
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    //ignoring comparison for CNTR_STATUS,just check it's reset value
    compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
    compare_disable[(`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))] = 1;
    compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;

    `uvm_info("eth_register_access_sequence", "Performing All 1s Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),'hFFFF_FFFF);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    `uvm_info("eth_register_access_sequence", "Performing All 0s Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),'h00000000);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
  
    `uvm_info("eth_register_access_sequence", "Performing walk 1 Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
      for(int j=0;j<32;j++) 
      begin
        p_sequencer.env.reg_write(regs[i].get_address(),1<<j);
        p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end
    end
    
    `uvm_info("eth_register_access_sequence", "Performing walk 0 Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
      for(int j=0;j<32;j++) 
      begin
        p_sequencer.env.reg_write(regs[i].get_address(),~(1<<j));
        p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end
    end

    `uvm_info("eth_register_access_sequence", "Performing random read write Pattern...", UVM_LOW)
    `uvm_info("eth_register_access_sequence", "2:Write registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
    end
  
    `uvm_info("eth_register_access_sequence", "3:Read registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `uvm_info("eth_register_access_sequence", "4:Write registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
    end
  
    `uvm_info("eth_register_access_sequence", "5:Read registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    //dsamantx:No document available for GDR registers spec.So, Need to add the
    //reserved space registers whenever it's available for GDR.
    
    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('h345-'h3FF)...", UVM_LOW)
    //for(int addr='h345; addr < 'h3FF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data);
    //end

    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('h40B-'h4FF)...", UVM_LOW)
    //for(int addr='h40B; addr < 'h4FF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data);
    //end

    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('h50B-'h5FF)...", UVM_LOW)
    //for(int addr='h50B; addr < 'h5FF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data);
    //end

    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('h600-'h6FF)...", UVM_LOW)
    //for(int addr='h600; addr < 'h6FF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data);
    //end

    //`uvm_info("eth_register_access_sequence", "For 100G & 40G:Performing read write Pattern on reserved space('h700-'h7FF)...", UVM_LOW)
    //for(int addr='h700; addr < 'h7FF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data);
    //end

    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('h864-'h8FF)...", UVM_LOW)
    //for(int addr='h864 ;addr < 'h8FF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data,1);
    //end

    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('h964-'h9FF)...", UVM_LOW)
    //for(int addr='h964 ;addr < 'h9FF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data,1);
    //end

    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('hC08-'hCFF)...", UVM_LOW)
    //for(int addr='hC08; addr < 'hCFF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data);
    //end

    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('hD09-'hDFF)...", UVM_LOW)
    //for(int addr='hD09 ;addr < 'hDFF ; addr++)
    //begin
    //  p_sequencer.env.reg_write(addr,$urandom());
    //  p_sequencer.env.reg_read(addr,read_data);
    //end

    //`uvm_info("eth_register_access_sequence", "Performing read write Pattern on reserved space('hE00-'hFFF)...", UVM_LOW)
    //for(int i=0; i < 100 ; i++)
    //begin
    //  p_sequencer.env.reg_write($urandom_range('hE00,'hFFF),$urandom());
    //  p_sequencer.env.reg_read($urandom_range('hE00,'hFFF),read_data);
    //end

    `uvm_info("eth_register_access_sequence", "Performing random read write Pattern...", UVM_LOW)
    regs.shuffle();
    foreach(regs[i]) begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `uvm_info("eth_register_access_sequence", "6:Write registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
    end
  
    `uvm_info("eth_register_access_sequence", "7:Read registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `uvm_info("eth_register_access_sequence", "8:Write registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
    end
  
    `uvm_info("eth_register_access_sequence", "9:Read registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    //dsamantx: Please check this feature in GDR whether it is supported or not
    //p_sequencer.env.apply_reset("hard",0,0,1,$urandom_range(11,50));

    wait (p_sequencer.env.master_agent.mast_agt_if.tx_lane_stable == 1'b1); 
    p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    
    foreach(regs[i]) 
    begin
      `uvm_info("eth_register_access_sequence", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_MEDIUM)
    end

    `uvm_info("eth_register_access_sequence", "10:Read registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data);
    end
  endtask
endclass
