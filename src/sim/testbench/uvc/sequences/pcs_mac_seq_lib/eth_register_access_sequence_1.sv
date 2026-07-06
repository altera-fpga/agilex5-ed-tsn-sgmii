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


// sequence_name : eth_register_access_sequence_1
// 1. Apply IP reset (maintained by testcase) 
// 2. Performing random read write pattern by shuffling the registers.
// 3. Performing write-check random pattern to reserved spaces
// 4. Performing read check and again random read write pattern by shuffling the registers.
// 5. Apply CSR reset & wait for pcs ready ->Please check whether it is supported or not in GDR
// 6. Read-check all the registers

class eth_register_access_sequence_1 extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	 regs[$];
  int resv_regs[$];
  bit [1:0] compare_disable[integer];
  bit [31:0] max_addr;  
  bit [31:0] min_addr;
  bit [31:0] max_addr_fec;  
  bit [31:0] min_addr_fec;
  bit [31:0] addr;

  `uvm_object_utils(eth_register_access_sequence_1)

  function new(string name = "eth_register_access_sequence_1");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    
    `uvm_info(get_type_name(), "started eth_register_access_sequence_1 ...", UVM_NONE)
    
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
  
    // dsamantx: Don't know why it is being read immediately and this is copied from C3 DB.
    // atiwari2 - removed , please refer HSD - 16011287481
    // p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    // p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    // p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
    // p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
   
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
      `uvm_info("eth_register_access_sequence_1", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end
    
    // 2. Performing random read write pattern by shuffling the registers.
    `uvm_info("eth_register_access_sequence_1", "Performing random read write Pattern...", UVM_LOW)
    `uvm_info("eth_register_access_sequence_1", "2:Write registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
    end
  
    `uvm_info("eth_register_access_sequence_1", "3:Read registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    // 3. Performing write-check random pattern on reserved spaces
    // dsamantx : Add more reserved space if it is required.
     case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
      _25G : begin min_addr = 'h1000; min_addr_fec = 'h6000; max_addr_fec = 'h61FC; 
               if (p_sequencer.env.dyn_rcfg_obj_inst.ptp == 'h1) max_addr = 'h1FFC; 
               else max_addr = 'h12DC;         
             end  
      _50G : begin min_addr = 'h2000; min_addr_fec = 'h6200; max_addr_fec = 'h65FC; 
               if (p_sequencer.env.dyn_rcfg_obj_inst.ptp == 'h1) max_addr = 'h2FFC; 
               else max_addr = 'h22DC;         
             end  
      _100G :begin min_addr = 'h3000; min_addr_fec = 'h6600; max_addr_fec = 'h6DFC; 
               if (p_sequencer.env.dyn_rcfg_obj_inst.ptp == 'h1) max_addr = 'h3FFC; 
               else max_addr = 'h32DC;         
             end  
      _200G :begin min_addr = 'h4000; min_addr_fec = 'h6E00; max_addr_fec = 'h7DFC; 
               if (p_sequencer.env.dyn_rcfg_obj_inst.ptp == 'h1) max_addr = 'h4FFC; 
               else max_addr = 'h42DC;         
             end  
      _400G :begin min_addr = 'h5000; min_addr_fec = 'h7E00; max_addr_fec = 'h9DFC; 
               if (p_sequencer.env.dyn_rcfg_obj_inst.ptp == 'h1) max_addr = 'h5FFC; 
               else max_addr = 'h52DC;         
             end  
     endcase
     `uvm_info("eth_register_access_sequence_1", "Performing read write Pattern on reserved space ", UVM_LOW)
     while(resv_regs.size()!=25) begin
       addr=$urandom_range(min_addr,max_addr);
       addr = {addr[31:2],2'b0};
       if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
        resv_regs.push_back(addr);
     end
     `uvm_info("eth_register_access_sequence_1", "Performing read write Pattern on FEC reserved space ", UVM_LOW)
     if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
       while(resv_regs.size()!=50) begin
         addr=$urandom_range(min_addr_fec,max_addr_fec);
         addr = {addr[31:2],2'b0};
         if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
          resv_regs.push_back(addr);
       end
     end
    
     foreach(resv_regs[i]) begin
      p_sequencer.env.reg_read(resv_regs[i],read_data);
     end
     
     foreach(resv_regs[i]) begin
      p_sequencer.env.reg_write(resv_regs[i],$urandom());
      //p_sequencer.env.reg_read(resv_regs[i],read_data);
     //end
    
     //foreach(resv_regs[i]) begin
      p_sequencer.env.reg_read(resv_regs[i],read_data);
     end
    // 4. Performing read check and again random read write pattern by shuffling the registers.
    `uvm_info("eth_register_access_sequence_1", "Performing random read write Pattern...", UVM_LOW)
    regs.shuffle();
    foreach(regs[i]) begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `uvm_info("eth_register_access_sequence_1", "4:Write registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) begin
      p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
    end
  
    `uvm_info("eth_register_access_sequence_1", "5:Read registers", UVM_NONE)
    regs.shuffle();
    foreach(regs[i]) begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
// TBD venkatkx need to be enabled after SRC ENV is up
//    // 5. Apply CSR reset & wait for pcs ready ->Please check in GDR whether it is supported or not.
//    // dsamantx: Please check this feature in GDR whether it is supported or not. Uncomment if supported.
//     p_sequencer.env.apply_reset("hard",0,0,1,$urandom_range(11,50));
//    
//     wait (p_sequencer.env.sideband_if.tx_lane_stable == 1'b1); 
//     p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
//     p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
//     p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
//     p_sequencer.env.reg_read((`GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data); //Read Immediately
     
     // TBD venkatkx Due to sim_mode wait_for_linkup disabled, because rx_pcs_ready is forced in sim_mode.
     // p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
     
     foreach(regs[i]) 
     begin
       `uvm_info("eth_register_access_sequence_1", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_MEDIUM)
     end

     // 6. Read-check all the registers
     `uvm_info("eth_register_access_sequence_1", "10:Read registers", UVM_NONE)
     foreach(regs[i]) 
     begin
       p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
     end 
    
    `uvm_info(get_type_name(), "finished eth_register_access_sequence_1 ...", UVM_NONE)

  endtask
endclass
