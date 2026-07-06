//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================
`ifndef __TSN_AXI_AGENT_CFG_
`define __TSN_AXI_AGENT_CFG_

class tsn_axi_agent_cfg extends svt_axi_system_configuration;
   
   extern function new(string name="tsn_axi_agent_cfg");
   extern function void set_cfg();

   `uvm_object_utils(tsn_axi_agent_cfg)

endclass

//*******************************************************************************************

function tsn_axi_agent_cfg::new(string name="tsn_axi_agent_cfg");
    super.new(name);
endfunction

//*******************************************************************************************

function void tsn_axi_agent_cfg::set_cfg();
      this.system_coverage_enable=0;
      this.system_monitor_enable=0;//make this 1 for debug;
      common_clock_mode=0;
      this.common_clock_mode=0;
      this.tready_watchdog_timeout='d1000000;
      this.num_masters=1; // (AXI TX)
      this.num_slaves=0;
      this.bus_inactivity_timeout = 0;
      this.manage_objections_enable = 0;
      display_summary_report=1; //make this 1 for debug3;
      //set_addr_range(1,32'h0,32'hffff_ffff);
    this.master_cfg[0].axi_interface_type = svt_axi_port_configuration::AXI4;    
    this.master_cfg[0].axi_port_kind = svt_axi_port_configuration::AXI_MASTER;
    this.master_cfg[0].inst = "axi_mm";//$sformatf("axi_mm_%0d",i);  
    this.master_cfg[0].source_requester_name = "axi_mm";//$sformatf("axi_mm_%0d",i);    
    this.master_cfg[0].set_port_name("axi_mm");//$sformatf("axi_mm_%0d",i));    
  this.master_cfg[0].uvm_reg_enable =0;
    this.master_cfg[0].clock_enable=1'b1;
  this.master_cfg[0].awlen_enable   = 1;    
  this.master_cfg[0].arlen_enable   = 1;    
  this.master_cfg[0].awsize_enable  = 1;    
  this.master_cfg[0].arsize_enable  = 1;    
  this.master_cfg[0].awburst_enable = 1;    
  this.master_cfg[0].arburst_enable = 1;    
    this.master_cfg[0].awlock_enable  = 0;    
    this.master_cfg[0].arlock_enable  = 0;    
    this.master_cfg[0].awcache_enable = 0;    
    this.master_cfg[0].arcache_enable = 0;    
    this.master_cfg[0].wysiwyg_enable = 1;
    this.master_cfg[0].wstrb_enable = 1;
  this.master_cfg[0].wlast_enable   = 1;    
  this.master_cfg[0].rlast_enable   = 1;    
    this.master_cfg[0].is_active = 1;    
    this.master_cfg[0].data_width= 32;  
  //this.master_cfg[0].addr_width= LOG2_FLOWS;   
    this.master_cfg[0].addr_width= 29;   
    this.master_cfg[0].resp_user_width= 2;    
    this.master_cfg[0].toggle_coverage_enable=0;   
    this.master_cfg[0].transaction_coverage_enable=1;   
    this.master_cfg[0].state_coverage_enable=0;    
    this.master_cfg[0].reset_type=svt_axi_port_configuration::EXCLUDE_UNSTARTED_XACT;

endfunction    

//*******************************************************************************************
`endif 

