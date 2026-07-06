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


// sequence_name :eth_register_access_sequence_2
// 1. Apply IP reset (maintained by testcase)
// 2. Read the reset value of registers
// 3. Performing All 1's pattern
// 4. Performing All 0's pattern
// 5. Performing 'h5555_5555 pattern
// 6. Performing 'h3333_3333 pattern
// 7. Performing 'hCCCC_CCCC pattern

class eth_register_access_sequence_2 extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	 regs[$];
  bit [1:0] compare_disable[integer]; // compare_disable is 2 bit variable for read comparision where 0=normal_check; 1=disable_check; 2=WO masked check; 3=both WO & RO masked check

  `uvm_object_utils(eth_register_access_sequence_2)

  function new(string name = "eth_register_access_sequence_2");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    `uvm_info(get_type_name(), "started eth_register_access_sequence_2 ...", UVM_NONE)
    
    // Disabling functional register coverage.
    // p_sequencer.env.dis_reg_cov=1;

    p_sequencer.env.dyn_rcfg_obj_inst.print();

    // Collecting the register bank which needs to be accessed.
    collect_gdr_register_bank(regs);
    enable_disable_anlt_reset();
    // Disabling scoreboard as garbage data comes from DUT resulting to packet count mismatch and also this is no traffic sequence.
    p_sequencer.env.dynamic_enable_disable_scoreboards(1); 

    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_all_snps_errors();
    `endif

    // dsamantx : Don't know why it is kept here, please check.
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
    begin 
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
    end
    
    // 2. Read the reset value of registers
    `uvm_info("eth_register_access_sequence_2", " 1: Read reset value of registers", UVM_NONE)
    foreach(regs[i]) begin
        compare_disable[regs[i].get_address()] = 2;
    end
    // TBD venkatkx need to remove below compare_disable when src env is up
   // compare_disable[`GET_REG_ADDR(fec_e25g_s1_lphy_reg_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    `include "eth_reg_disable_chk_TOG.sv"

       foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    // Deleting the registers which affect other registers to fail. 
    foreach(regs[i]) begin
    if(regs[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG)
      regs.delete(i);
    end

    foreach(regs[i]) begin
    if(regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))
      regs.delete(i);
    end

    foreach(regs[i]) begin
    if(regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))  
      regs.delete(i);
    end
    
    foreach(regs[i]) begin      //HSD:16010937814
    if(regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) 
      regs.delete(i);
    end
    
    foreach(regs[i]) begin      //HSD:22010569085
    if(regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))  
      regs.delete(i);
    end
    // dsamantx : These registers all are clk gating register which affects stat register to fail.please check again after final register model
    if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
      foreach(regs[i]) begin if(regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) regs.delete(i); end
      foreach(regs[i]) begin if(regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) regs.delete(i); end
      foreach(regs[i]) begin if(regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) regs.delete(i); end
      foreach(regs[i]) begin if(regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) regs.delete(i); end
      if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G)) begin 
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
      end
      if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G)) begin 
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
      end
      if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G)) begin 
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
      end
      if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G) ) begin
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_0_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_1_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_3_OFFSET_REG)) regs.delete(i); end
        foreach(regs[i]) begin if(regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_4_OFFSET_REG)) regs.delete(i); end
    end
  end
    

    // Here compare_disable is selected to be 3, so that all WO & RO registers are masked at the time of comparison.
    foreach(regs[i]) begin
        compare_disable[regs[i].get_address()] = 3;
    end
    //ignoring comparison for stats register parameter set by rbc -- Ken
    compare_disable[`GET_REG_ADDR(ehip_stats_txpldfifo_stat_inten_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    //ignoring comparison for W1C registers  
    `include "eth_reg_disable_chk_W1C.sv"
     

    foreach(regs[i]) begin
      `uvm_info("eth_register_access_sequence_2", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end

    // 3. Performing All 1's pattern
    `uvm_info("eth_register_access_sequence_2", "Performing All 1s Pattern...", UVM_LOW)
    foreach(regs[i]) begin
      p_sequencer.env.reg_write(regs[i].get_address(),'hFFFF_FFFF);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    // 4. Performing All 0's pattern
    `uvm_info("eth_register_access_sequence_2", "Performing All 0s Pattern...", UVM_LOW)
    foreach(regs[i]) begin
      p_sequencer.env.reg_write(regs[i].get_address(),'h0000_0000);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    // 5. Performing 'h5555_5555 pattern
    `uvm_info("eth_register_access_sequence_2", "Performing 'h5555_5555 Pattern...", UVM_LOW)
    foreach(regs[i]) begin 
      p_sequencer.env.reg_write(regs[i].get_address(),'h5555_5555);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    // 6. Performing 'h3333_3333 pattern
    `uvm_info("eth_register_access_sequence_2", "Performing 'h3333_3333 Pattern...", UVM_LOW)
    foreach(regs[i]) begin 
      p_sequencer.env.reg_write(regs[i].get_address(),'h3333_3333);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    // 7. Performing 'hCCCC_CCCC pattern
    `uvm_info("eth_register_access_sequence_2", "Performing 'hCCCC_CCCC Pattern...", UVM_LOW)
    foreach(regs[i]) begin 
      p_sequencer.env.reg_write(regs[i].get_address(),'hCCCC_CCCC);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
   // // Due to GDR-HSD:22010569085, accessing the below register explicitely with disabling assertion
   // `ifdef ENABLE_ETH_VIP
   //   p_sequencer.env.ts_tasks_if.avst_set_enable_a_mon_assertion(0);
   // `endif
   // // Disabling scoreboard as garbage data comes from DUT resulting to packet count mismatch and also this is no traffic sequence.
   // p_sequencer.env.dynamic_enable_disable_scoreboards(1); 
   // p_sequencer.env.reg_write((`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'hFFFF_FFFF);
   // p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data);
   // p_sequencer.env.reg_write((`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h0000_0000);
   // p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data);
   // p_sequencer.env.reg_write((`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h5555_5555);
   // p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data);
   // p_sequencer.env.reg_write((`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),$urandom());
   // p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data);
   // p_sequencer.env.dynamic_enable_disable_scoreboards(0); 
   // `ifdef ENABLE_ETH_VIP
   //   p_sequencer.env.ts_tasks_if.avst_set_enable_a_mon_assertion(1);
   // `endif

    `uvm_info(get_type_name(), "finished eth_register_access_sequence_2 ...", UVM_NONE)
    
  endtask
endclass
