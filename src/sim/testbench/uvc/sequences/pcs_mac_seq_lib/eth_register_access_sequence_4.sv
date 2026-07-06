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


// sequence_name :eth_register_access_sequence_4
// 1. Apply IP reset (maintained by testcase) 
// 2. Performing walk 0 pattern in all registers sequentially.

class eth_register_access_sequence_4 extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	 regs[$];
  bit [1:0] compare_disable[integer];
  rand int k;

  `uvm_object_utils(eth_register_access_sequence_4)

  function new(string name = "eth_register_access_sequence_4");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    
    `uvm_info(get_type_name(), "started eth_register_access_sequence_4 ...", UVM_NONE)
    
    // Disabling functional register coverage.
    // p_sequencer.env.dis_reg_cov=1;

    p_sequencer.env.dyn_rcfg_obj_inst.print();

    // Collecting the register bank which needs to be accessed.
    collect_gdr_register_bank(regs);
    enable_disable_anlt_reset();
    // Disabling scoreboard as garbage data comes from DUT resulting to packet count mismatch and also this is no traffic sequence.
    p_sequencer.env.dynamic_enable_disable_scoreboards(1); 

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
     
    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_all_snps_errors();  
    `endif
    
    // dsamantx : Don't know why it is kept here, please check.
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
    begin 
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
    end

    foreach(regs[i]) begin
      `uvm_info("eth_register_access_sequence_4", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end
    
    // 2. Performing walk 0 pattern.
    randomize(k) with {k inside {0,4,8,12,16,20,24,28};};
    `uvm_info("eth_register_access_sequence_4", "Performing walk 0 Pattern...", UVM_LOW)
    foreach(regs[i]) 
     begin
      for(int j=k;j<=k+3;j++) 
      begin
        p_sequencer.env.reg_write(regs[i].get_address(),~(1<<j));
        p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end
    end
    `uvm_info(get_type_name(), "finished eth_register_access_sequence_4 ...", UVM_NONE)
  endtask
endclass
