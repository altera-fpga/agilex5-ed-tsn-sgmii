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


    // Deleting the registers which affect other registers to fail. 
   
    foreach(hip_regs[i]) begin
    if(hip_regs[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG)
      hip_regs.delete(i);
    end

    foreach(hip_regs[i]) begin
    if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))
      hip_regs.delete(i);
    end

    foreach(hip_regs[i]) begin      //HSD:16010937814
    if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) 
      hip_regs.delete(i);
    end
    
    foreach(hip_regs[i]) begin      //HSD:22010569085
    if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))  
      hip_regs.delete(i);
    end

    // dsamantx : These registers all are clk gating register which affects stat register to fail.please check again after final register model
    if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_lphy_reg_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
      if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G)) begin 
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end    
      end
      if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G)|| (p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G)) begin 
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
      end
      if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G)) begin 
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
      end
      if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G) ) begin
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_0_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_1_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_3_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_4_OFFSET_REG)) hip_regs.delete(i); end
        foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_lphy_reg_6_OFFSET_REG)) hip_regs.delete(i); end
    end
  end

  //16012712462: clk is getting stopped after writing into these registers (clk_rec_div_khz register mismatch)  
  foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_xcvrif_reg_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
  foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(fec_e25g_s0_xcvrif_reg_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
  if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G)) begin
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e50_fec_e25g_s1_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
  end
  if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G)|| (p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G)) begin
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s1_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s2_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e100_fec_e25g_s3_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
  end
  if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G)) begin
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s1_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s2_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s3_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s4_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s5_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s6_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e200_fec_e25g_s7_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
  end
  if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) begin
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s1_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s2_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s3_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s4_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s5_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s6_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s7_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s8_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s9_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s10_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s11_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s12_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s13_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s14_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_xcvrif_reg_18_OFFSET_REG)) hip_regs.delete(i); end
      foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`ETH_F_ALL_e400_fec_e25g_s15_xcvrif_reg_19_OFFSET_REG)) hip_regs.delete(i); end
  end

  // PTP Registers are not accessable in non PTP Modes
  if (p_sequencer.env.dyn_rcfg_obj_inst.ptp == 'h0) begin
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end 
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_rx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end 
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_fec_mode_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end 
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_rx_ptp_fec_mode_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end 
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_phy_lane_num_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_rx_ptp_phy_lane_num_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(mac_cfg_tx_ptp_vl_offset_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_lo_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
    foreach(hip_regs[i]) begin if(hip_regs[i].get_address() == (`GET_REG_ADDR(ehip_stats_ptp_vl_data_hi_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))) hip_regs.delete(i); end
  end
