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


`define STRINGIFY(x) `"x`"

class ptp_wo_registers_sequence extends eth_ptp_base_sequence;
  
  
  uvm_reg_data_t read_data;
  uvm_status_e status;
  uvm_reg 	regs_org[$],regs[$];
  bit compare_disable[integer];
  bit [31:0] max_address = 'h810;  
  bit [31:0] min_address = 'h800;
  int reg_index[$];
  string gdr_mac_stats,gdr_mac;
  string gdr_ehip_stats;
  string ptp_csr_ptp_reg;
  string tile_path;

   bit [31:0] backdoor_read_data,temp_write_data;
  `uvm_object_utils(ptp_wo_registers_sequence)

  function new(string name = "ptp_wo_registers_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
  super.body();

  //from stats base

   tile_path = `STRINGIFY(`FTILE_TOP_PATH);
 
    `uvm_info("body", "started ptp wo register sequence ...", UVM_NONE)

if ((p_sequencer.env.spy_if.speed == _25G) || (p_sequencer.env.spy_if.speed == _10G) )
begin
  //rk gdr_mac_stats = "eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.gdr_e4hip_mac1cfgtop.gen_cfg[0].mac_cfg.gdr_mac_stats";
  gdr_mac_stats = {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.gdr_e4hip_mac1cfgtop.gen_cfg[8].mac_cfg.gdr_mac_stats"};
  //rk gdr_mac="eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0";
  gdr_mac= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0"};
  //rk gdr_ehip_stats= "eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.generate_cfg25[0].gdr_ehip_cfgtop_25.gen_ctrl.generate_cfg[0].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats";
  gdr_ehip_stats= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[4].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
end  
else if (p_sequencer.env.spy_if.speed == _400G)
begin
  //rk gdr_mac_stats ="eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_400g_0.genblk1.ehip_mac_400g_0";
  gdr_mac_stats ={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_400g_0.genblk1.ehip_mac_400g_0"};
  //rk gdr_mac="eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_400g_0.genblk1.ehip_mac_400g_0";
  gdr_mac= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_400g_0.genblk1.ehip_mac_400g_0"};
 //rk gdr_ehip_stats="eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[0].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats";
 gdr_ehip_stats= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[0].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
 end
  
 else if (p_sequencer.env.spy_if.speed == _100G)
begin
  //rk gdr_mac_stats ="eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.gdr_e4hip_mac0cfgtop.gen_cfg[1].mac_cfg.gdr_mac_stats";
  gdr_mac_stats ={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.gdr_e4hip_mac0cfgtop.gen_cfg[3].mac_cfg.gdr_mac_stats"};
  //rk gdr_mac="eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_200g_0.genblk1.ehip_mac_200g_0";
  gdr_mac={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_200g_0.genblk1.ehip_mac_200g_0"};
 //rk gdr_ehip_stats="eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[2].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats";
 gdr_ehip_stats={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[2].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
 end
else if (p_sequencer.env.spy_if.speed == _50G)
begin
  gdr_mac_stats = {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.gdr_e4hip_mac1cfgtop.gen_cfg[0].mac_cfg.gdr_mac_stats"};
  gdr_mac={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0"};
  gdr_ehip_stats= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[3].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
end
 else if (p_sequencer.env.spy_if.speed == _200G)    
begin
  gdr_mac_stats = {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.gdr_e4hip_mac0cfgtop.gen_cfg[1].mac_cfg.gdr_mac_stats"};
  gdr_mac={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_200g_0.genblk1.ehip_mac_200g_0"};
  gdr_ehip_stats= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[1].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
end

  ptp_csr_ptp_reg= "eth_env_top.dut.ip0.top_ip0.sip_inst.csr_inst.g_ptp.soft_ptp_csr.ptp_reg";
 
    //Demoting common error
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ip_ext_mobility_header_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    `endif

    // apply_hard_reset(0,0,1,11);
    // `ifdef CRETE3
    //   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    // `else  
    //   rx_pcs_ready_timeout();//Shabbir - FB 534015
    // `endif  

    //For tx error insertion
    //enable_tx_error_insertion();//Disabling Tx error insertion for every tests

    //muralasx: FIXME fix register code as GDR reg_model isn't available
    //rand_regs();
    
    //HSD 16011077291  : TODO : Reset valu needs to match
    //FIXME: Workaround for now is to reset the register fields manually, revisit after HSD fix
    //GDR has a new register to take care of
    p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_config_ctrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b00);

    //Need to clear stat registers as Mlab RAM is not initialized. FB 489113
    clear_stat_counters();
    #400ns;
    //p_sequencer.env.eth_ref_model_inst.dis_fc_assertion=1;
    
    //FIXME Shabbir: currently DV is not able to capture read data x, so clear parity error in any case
    //Read status regsiters for parity error
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_TX_CNTR_STATUS_OFFSET_REG,read_data_tx,1);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_RX_CNTR_STATUS_OFFSET_REG,read_data_rx,1);

    //if(read_data_tx[0]!==0) begin
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end
    //if(read_data_rx[0]!==0) begin
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end

    #100ns;
    //parity error should get cleared now
    //FIXME Shabbir: currently DV is not able to capture read data x
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_TX_CNTR_STATUS_OFFSET_REG,read_data_tx,1);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_RX_CNTR_STATUS_OFFSET_REG,read_data_rx,1);
    #0;
    //FIXME EHIP Shabbir: FB 505364, need to fix DV, scripts
    //VR//p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);
    //Shabbir: disabling en_sfc/pfc, so SFC frames are not processed and traffic will not be halted on TX side even with fc1 which prevents AVST tiemout
    //VR//p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h0);

  //end from stat base

  repeat(20) begin
   send_frames();
   end

//  p_sequencer.env.apply_reset("hard",0,0,1,11); TODO GDR
    p_sequencer.reg_model.default_map.get_registers(regs_org);
    enable_disable_anlt_reset();

        
    `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)

    foreach(regs_org[i]) 
    begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
      begin
        regs.push_back(regs_org[i]);
      end
    end

    `uvm_info("eth_register_access_sequence", "Performing All 1s Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
        $display("\n\nreg_address=%h\n\n",regs[i]);
        p_sequencer.env.reg_write(regs[i].get_address(),32'hFFFFFFFF);
    end
    read_regs_backdoor(32'hFFFFFFFF);

    `uvm_info("eth_register_access_sequence", "Performing All 0s Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
        p_sequencer.env.reg_write(regs[i].get_address(),'h00000000);
        $display("\n\nreg_address_1=%h\n\n",regs[i]);
    end
    read_regs_backdoor(32'h00000000);
    
   `uvm_info("eth_register_access_sequence", "Performing walk 1 Pattern...", UVM_LOW)
    for(int j=0;j<32;j++) 
    begin
      temp_write_data = 1<<j;
     foreach(regs[i]) 
      begin
        $display("\n\nreg_address_2=%h\n\n",regs[i]);
        p_sequencer.env.reg_write(regs[i].get_address(),temp_write_data);
      end
     read_regs_backdoor(temp_write_data);
    end

 `uvm_info("eth_register_access_sequence", "Performing walk 0 Pattern...", UVM_LOW)
    for(int j=0;j<32;j++) 
    begin
      temp_write_data = ~(1<<j);
     foreach(regs[i]) 
      begin
        $display("\n\nreg_address_3=%h\n\n",regs[i]);
        p_sequencer.env.reg_write(regs[i].get_address(),temp_write_data);
      end
     read_regs_backdoor(temp_write_data);
    end

     `uvm_info("eth_register_access_sequence", "Performing random read write Pattern...", UVM_LOW)
    for(int j=0;j<32;j++) 
    begin
      temp_write_data = $urandom;
     foreach(regs[i]) 
      begin
        $display("\n\nreg_address_4=%h\n\n",regs[i]);
        p_sequencer.env.reg_write(regs[i].get_address(),temp_write_data);
      end
     read_regs_backdoor(temp_write_data);
    end


  endtask 

  task read_regs_backdoor(bit [31:0] write_data);
   //uvm_hdl_read({ptp_csr_ptp_reg,".ptp_tx_tam_adjust_tam_adjust"}, backdoor_read_data);
   //if (backdoor_read_data != write_data)
   //  `uvm_error(get_type_name(),$sformatf("ptp_tx_tam reg error, backdoor_read_data=%0d, write_data=%0d", backdoor_read_data, write_data ))

   //uvm_hdl_read({ptp_csr_ptp_reg,".ptp_rx_tam_adjust_tam_adjust"}, backdoor_read_data);
   //if (backdoor_read_data != write_data)
   //  `uvm_error(get_type_name(),$sformatf("ptp_rx_tam reg error, backdoor_read_data=%0d, write_data=%0d", backdoor_read_data, write_data ))

//   uvm_hdl_read({ptp_csr_ptp_reg,".ptp_hip_user_cfg_status_rx_vl_offset_cfg_done"}, backdoor_read_data[0]);
//   if (backdoor_read_data[0] != write_data[0])
//     `uvm_error(get_type_name(),$sformatf("ptp_hip_user_cfg reg error, backdoor_read_data=%0d, write_data=%0d", backdoor_read_data, write_data ))
//
//   uvm_hdl_read({ptp_csr_ptp_reg,".ptp_hip_user_cfg_status_rx_fec_cw_pos_cfg_done"}, backdoor_read_data[1]);
//   if (backdoor_read_data[1] != write_data[1])
//     `uvm_error(get_type_name(),$sformatf("ptp_hip_user_cfg reg error, backdoor_read_data=%0h, write_data=%0h", backdoor_read_data, write_data ))

//   uvm_hdl_read({ptp_csr_ptp_reg,".ptp_dr_cfg_tx_ehip_preamble_passthrough"}, backdoor_read_data[0]);
//   if (backdoor_read_data[0] != write_data[0])
//     `uvm_error(get_type_name(),$sformatf("ptp_rx_user_cfg_status rx_user_cfg_done reg error, backdoor_read_data=%0d, write_data=%0d", backdoor_read_data, write_data ))

   // uvm_hdl_read({ptp_csr_ptp_reg,".ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done"}, backdoor_read_data[1]);
   // if (backdoor_read_data[1] != write_data[1])
   //   `uvm_error(get_type_name(),$sformatf("ptp_rx_user_cfg_status rx_fec_cw_pos_cfg_done reg error, backdoor_read_data=%0h, write_data=%0h", backdoor_read_data, write_data ))

//  uvm_hdl_read({ptp_csr_ptp_reg,".ptp_ref_lane_tx_ref_lane"}, backdoor_read_data[2:0]);
//   if (backdoor_read_data[2:0] != write_data[2:0])
//     `uvm_error(get_type_name(),$sformatf("ptp_ref_lane reg error, backdoor_read_data=%0h, write_data=%0h", backdoor_read_data, write_data ))
// 
//  uvm_hdl_read({ptp_csr_ptp_reg,".ptp_ref_lane_rx_ref_lane"}, backdoor_read_data[5:3]);
//   if (backdoor_read_data[5:3] != write_data[5:3])
//     `uvm_error(get_type_name(),$sformatf("ptp_ref_lane reg error, backdoor_read_data=%0h, write_data=%0h", backdoor_read_data, write_data ))

  // uvm_hdl_read({ptp_csr_ptp_reg,".ptp_uim_tam_snapshot_tam_snapshot"}, backdoor_read_data[0]);
  //  if (backdoor_read_data[0] != write_data[0])
  //    `uvm_error(get_type_name(),$sformatf("ptp_uim_tam_snapshot reg error, backdoor_read_data=%0h, write_data=%0h", backdoor_read_data, write_data ))
   endtask

  task send_frames();
   randcase
   1:begin send_ptp_frame(INS_V2,DATA_FRAME,1);  
     end
   1:begin send_ptp_frame(INS_V2_W_UDP_CS_0,DATA_FRAME,1);  
     end
   1:begin send_ptp_frame(INS_V2_W_EB,DATA_FRAME,1);  
     end
   1:begin send_ptp_frame(INS_CF,DATA_FRAME,1);  
     end
      1:begin send_ptp_frame(INS_V2_W_UDP_CS_0,VLAN_FRAME,1);  
     end
   1:begin send_ptp_frame(INS_V2_W_EB,VLAN_FRAME,1);  
     end
   1:begin send_ptp_frame(INS_CF,VLAN_FRAME,1);  
     end
   1:begin send_ptp_frame(INS_CF_W_UDP_CS_0,VLAN_FRAME,1);  
     end
   1:begin send_ptp_frame(INS_CF_W_EB,VLAN_FRAME,1);
     end
   1:begin send_ptp_frame(INS_2STEP,VLAN_FRAME,1);  
     end
   endcase
  endtask
endclass
