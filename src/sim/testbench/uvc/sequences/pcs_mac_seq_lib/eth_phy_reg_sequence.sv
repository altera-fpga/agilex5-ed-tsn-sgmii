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


class eth_phy_reg_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  bit [4:0] vlan_al_mkr[20];

  `uvm_object_utils(eth_phy_reg_sequence)

  function new(string name = "eth_phy_reg_sequence");
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
    //this delay is to accomocate vlan register initialisation
    #8us;
    wait (p_sequencer.env.master_agent.mast_agt_if.ehip_ready);

    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
// FIXME-MISSING_REG_IN_GDR    //p_sequencer.env.reg_read(`REGISTERS_PHY_CLK_OFFSET_REG,read_data);

    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

      
    //`ifdef G100
    //`endif
    //
    //`ifdef G40
    //`endif

    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
   // if(read_data != 'h1) `uvm_error("PCS VLAN UNIQUE", $sformatf("REGISTERS_RX_PCS_FULLY_ALIGNED_S_OFFSET_REG read value is not correct"));
    
    p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
    if(read_data != 'h1) `uvm_error("PCS VLAN UNIQUE", $sformatf("REGISTERS_AM_LOCK_OFFSET_REG value is not correct"));
    
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_PHY_CLK_OFFSET_REG,read_data,1);
    if(read_data != 'b1) `uvm_error("PCS VLAN UNIQUE", $sformatf("REGISTERS_PHY_CLK_OFFSET_REG value is not correct"));

    //`ifdef G100
     if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G ) begin
      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
      vlan_al_mkr[0] = read_data[4:0]; // 0,1,2,3,4
      vlan_al_mkr[1] = read_data[9:5]; // 5,6,7,8,9
      vlan_al_mkr[2] = read_data[14:10];// 10,11,12,13,14
      vlan_al_mkr[3] = read_data[19:15];//15,16,17,18,19
      vlan_al_mkr[4] = read_data[24:20];//20,21,22,23,24
      vlan_al_mkr[5] = read_data[29:25];

      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
      vlan_al_mkr[6] = read_data[4:0]; // 0,1,2,3,4
      vlan_al_mkr[7] = read_data[9:5]; // 5,6,7,8,9
      vlan_al_mkr[8] = read_data[14:10];// 10,11,12,13,14
      vlan_al_mkr[9] = read_data[19:15];//15,16,17,18,19
      vlan_al_mkr[10] = read_data[24:20];//20,21,22,23,24
      vlan_al_mkr[11] = read_data[29:25];
      
      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
      vlan_al_mkr[12] = read_data[4:0];
      vlan_al_mkr[13] = read_data[9:5];
      vlan_al_mkr[14] = read_data[14:10];
      vlan_al_mkr[15] = read_data[19:15];
      vlan_al_mkr[16] = read_data[24:20];
      vlan_al_mkr[17] = read_data[29:25];
    
      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
      vlan_al_mkr[18] = read_data[4:0];
      vlan_al_mkr[19] = read_data[9:5];

      for(int m=0;m<20;m++)
       `uvm_info("body", $sformatf("vlan_al_mkr[%0d]=%0d", m,vlan_al_mkr[m]), UVM_MEDIUM)

      for(int j=0;j<20;j++)
      begin
        for(int i=0;i<20;i++) 
        begin
	        if(i != j )
	        begin
             if(vlan_al_mkr[j] == vlan_al_mkr[i])
             `uvm_error("PCS VLAN UNIQUE", $sformatf("alignment marker received on virtual lane %d and %d are in same number",j,i));
	        end
        end
      end
    end
    //`endif

    //`ifdef G50
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G )  begin
      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
      vlan_al_mkr[0] = read_data[4:0];
      vlan_al_mkr[1] = read_data[9:5];
      vlan_al_mkr[2] = read_data[14:10];
      vlan_al_mkr[3] = read_data[19:15];
      for(int j=0;j<4;j++)
      begin
        for(int i=0;i<4;i++)
        begin
	        if(i != j)
	        begin
            if(vlan_al_mkr[j] == vlan_al_mkr[i])
             `uvm_error("PCS VLAN UNIQUE", $sformatf("alignment marker received on virtual lane %d and %d are in same number",j,i));
	        end
        end
      end
     end
    //`endif

  endtask
endclass
