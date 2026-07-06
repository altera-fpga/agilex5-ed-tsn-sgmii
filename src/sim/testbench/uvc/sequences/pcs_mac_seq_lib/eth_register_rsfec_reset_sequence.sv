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


class eth_register_rsfec_reset_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit compare_disable[integer];
  bit [31:0] max_address = 'h500;
  bit [31:0] min_address = 'h000;
  int reg_index[$];

  `uvm_object_utils(eth_register_rsfec_reset_sequence)

  function new(string name = "eth_register_rsfec_reset_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    //p_sequencer.env.dis_reg_cov=1; //disabling register coverage
    p_sequencer.env.dyn_rcfg_obj_inst.print();
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count ==1 ) max_address = 'h9ff; 
    if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == 1) max_address = 'h500;

    p_sequencer.env.apply_reset("hard",0,0,1,11);
    //muralasx: FIXME rsfec_reg_model is unavailable in virtual_sequencer
    //p_sequencer.rsfec_reg_model.default_map.get_registers(regs_org);
    enable_disable_anlt_reset();

    `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)

    //FB:560641
    foreach(regs_org[i]) begin
//FIXME-MISSING_REG_IN_GDR    if(regs_org[i].get_address() == `RSFEC_CFGCSR_CSR_rsfec_misc_cfg_OFFSET_REG)   
//      regs_org.delete(i);
    end 
    
    foreach(regs_org[i]) begin
//FIXME-MISSING_REG_IN_GDR   if(regs_org[i].get_address() == `RSFEC_CFGCSR_CSR_rsfec_top_tx_cfg_OFFSET_REG)   
//     regs_org.delete(i);
    end 
    
    foreach(regs_org[i]) 
    begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
      begin
        regs.push_back(regs_org[i]);
      end
    end
    
    foreach(regs[i]) begin
      if(
//FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s_rsfec_status_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_lane_tx_stat") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s1_rsfec_lane_tx_stat") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s2_rsfec_lane_tx_stat") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_lane_tx_stat") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_lane_rx_stat") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s1_rsfec_lane_rx_stat") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s2_rsfec_lane_rx_stat") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_lane_rx_stat") ||
//FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s_rsfec_lanes_rx_stat") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_lane_tx_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s1_rsfec_lane_tx_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s2_rsfec_lane_tx_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_lane_tx_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_lane_rx_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s1_rsfec_lane_rx_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s2_rsfec_lane_rx_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_lane_rx_hold") ||
//FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s_rsfec_lanes_rx_hold") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_ln_mapping_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s1_rsfec_ln_mapping_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s2_rsfec_ln_mapping_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_ln_mapping_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_ln_skew_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s1_rsfec_ln_skew_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s2_rsfec_ln_skew_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_ln_skew_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_cw_pos_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s1_rsfec_cw_pos_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s2_rsfec_cw_pos_rx") ||
        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_cw_pos_rx") 
//FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s_tx_aib_dsk_status") 
        ) begin
        compare_disable[regs[i].get_address()] = 1;
      end 
      else begin
        compare_disable[regs[i].get_address()] = 0;
      end
    end
  
    //wait for ehip ready
    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
   
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

    foreach(regs[i]) begin
      `uvm_info("eth_register_rsfec_reset_sequence", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end
    
    `uvm_info("eth_register_rsfec_reset_sequence", "1:Read registers", UVM_NONE)
   
    p_sequencer.env.reg_read('hC4,read_data);
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `uvm_info("eth_register_rsfec_reset_sequence", "Performing All 1s Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),'hFFFF_FFFF);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    //Arbiter base cfg value hard coded 1 in RTL so not able to compare again
//FIXME-MISSING_REG_IN_GDR    compare_disable[`RSFEC_CFGCSR_CSR_arbiter_base_cfg_OFFSET_REG] = 1; 
    
    `uvm_info("eth_register_rsfec_reset_sequence", "Performing All 0s Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),'h00000000);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
  endtask
endclass
