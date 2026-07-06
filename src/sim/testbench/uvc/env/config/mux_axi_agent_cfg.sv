//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================
`ifndef __MUX_AXI_AGENT_CFG_
`define __MUX_AXI_AGENT_CFG_

class mux_axi_agent_cfg extends svt_axi_system_configuration;
  
  //==============================================
  // Factory
  //==============================================
  `uvm_object_utils(mux_axi_agent_cfg)

  //==============================================
  // Class constructor
  //==============================================
  function new(string name="mux_axi_agent_cfg");
    super.new(name);

    // Create a single AXI master agent and a single slave agent
    this.num_masters = 1;
    this.num_slaves = 1;
    this.tready_watchdog_timeout = 0;
    this.bus_inactivity_timeout = 0;
    this.manage_objections_enable = 0; // Fixme: AXI driving has some issue due to this. Need to fix
    
    // Create port configurations
    this.create_sub_cfgs(`MAX_AXI_PORT, `MAX_AXI_PORT);
    for(int idx=0; idx < `MAX_AXI_PORT; idx++) begin
      // Master
      this.master_cfg[idx].axi_interface_type = svt_axi_port_configuration::AXI4_STREAM;
      this.master_cfg[idx].axi_port_kind = svt_axi_port_configuration::AXI_MASTER;
      this.master_cfg[idx].tdata_width = 64;
      this.master_cfg[idx].tid_width   = 9;
      this.master_cfg[idx].tuser_width = 40;
      // Slave
      this.slave_cfg[idx].axi_interface_type = svt_axi_port_configuration::AXI4_STREAM;
      this.slave_cfg[idx].axi_port_kind = svt_axi_port_configuration::AXI_SLAVE;
      this.slave_cfg[idx].tdata_width  = 64;
      this.slave_cfg[idx].tid_width    = 9;
      this.slave_cfg[idx].tuser_width  = 40;
    end
  endfunction

endclass
`endif // __MUX_AXI_AGENT_CFG_
