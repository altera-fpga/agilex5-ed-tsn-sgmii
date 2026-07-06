//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================
`ifndef __MUX_ETH_AGENT_CFG_
`define __MUX_ETH_AGENT_CFG_

class mux_eth_agent_cfg extends svt_ethernet_agent_configuration;
  
  //==============================================
  // Factory
  //==============================================
  `uvm_object_utils(mux_eth_agent_cfg)

  //==============================================
  // Class constructor
  //==============================================
  function new(string name="mux_eth_agent_cfg");
    super.new(name);
  endfunction

  //==============================================
  // Setting configuration values for the Ethernet interface
  //==============================================
  function void set_gmii_default_cfg();
    //Set the Interface Type::GMII
    interface_select = svt_ethernet_enum_pkg::ETH_GMII;
    // Enable functional coverage for MAC frame transactions
    // enable_mac_transaction_cov = 1'b1;
    `uvm_info("mux_eth_agent_cfg", $sformatf("INTF_SEL = %d.", interface_select), UVM_LOW);
  endfunction

  // Add other function as needed
endclass
`endif // __MUX_ETH_AGENT_CFG_
