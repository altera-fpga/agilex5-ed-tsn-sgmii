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


class eth_phy_frmerr_reg_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;

  `uvm_object_utils(eth_phy_frmerr_reg_sequence)

  function new(string name = "eth_phy_deskew_reg_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();

    //disabling register coverage
    //p_sequencer.env.dis_reg_cov=1; //disabling register coverage
    p_sequencer.env.apply_reset("hard",0,0,1,11);
    
    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    if(read_data != 'h0) `uvm_error("eth_phy_deskew_reg_sequence", $sformatf("REGISTERS_FRM_ERR_OFFSET_REG value must be non reset"));

    p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_err_inj_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),32'hF);
    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_err_inj_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    if(read_data == 'h0) `uvm_error("eth_phy_deskew_reg_sequence", $sformatf("REGISTERS_FRM_ERR_OFFSET_REG value must be non reset"));
    
    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); //sclr_frame_err bit found in this GDR register bit:12
    p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{read_data[31:13],1'b1,read_data[11:0]}); 

    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
    if(read_data != 'h0) `uvm_error("eth_phy_deskew_reg_sequence", $sformatf("REGISTERS_FRM_ERR_OFFSET_REG value is must be reset "));


//    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
//    if(read_data != 'h0) `uvm_error("eth_phy_deskew_reg_sequence", $sformatf("REGISTERS_FRM_ERR_OFFSET_REG value is must be reset "));
//
//    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); //sclr_frame_err bit found in this GDR register bit:12
//    p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{read_data[31:13],1'b0,read_data[11:0]}); 
//    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); //sclr_frame_err bit found in this GDR register bit:12
//
//    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//
// //   p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_err_inj_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1);
////    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_err_inj_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//
//    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    if(read_data == 'h0) `uvm_error("eth_phy_deskew_reg_sequence", $sformatf("REGISTERS_FRM_ERR_OFFSET_REG value must be non reset"));
//    
//    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); //sclr_frame_err bit found in this GDR register bit:12
//    p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{read_data[31:13],1'b1,read_data[11:0]}); 
//
//    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
//    if(read_data != 'h0) `uvm_error("eth_phy_deskew_reg_sequence", $sformatf("REGISTERS_FRM_ERR_OFFSET_REG value is must be reset "));
  endtask
endclass
