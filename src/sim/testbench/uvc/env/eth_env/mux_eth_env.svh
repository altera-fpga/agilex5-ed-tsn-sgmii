//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_ETH_ENV_SVH__
`define __MUX_ETH_ENV_SVH__

//------------------------------------------------------------------------------
// Class: mux_eth_env
//
// UVM Environment for all ethernet components
//
//------------------------------------------------------------------------------
class mux_eth_env extends uvm_env;
  //
  // Instantiate Driver and Sequencer
  mux_eth_driver                   m_eth_drvr;
  svt_ethernet_transaction_sequencer  m_eth_sqcr;

  //
  int  port_num;

  //---------------------------------------------------------------------------
  // Register class with factory
  //---------------------------------------------------------------------------
  `uvm_component_utils_begin(mux_eth_env)
  `uvm_component_utils_end

  //
  // Constructor: new
  //
  // Creates instance of this UVM component.
  //
  // Parameter(s):
  //  name   - Name of the instance.
  //  parent - Handle to the hierarchical parent, *null* if none.
  //
  function new(string name, uvm_component parent);
     super.new(name, parent);
  endfunction : new

  //
  // Function: build_phase
  //
  // Create the subcomponents based on the configuration object settings.
  //
  // Parameter(s):
  //  phase - Current UVM phase.
  //
  virtual function void build_phase(uvm_phase phase);
    //------------------------------------------------------------------------
    // 
    //------------------------------------------------------------------------
    super.build_phase(phase);
    //
    m_eth_drvr = mux_eth_driver::type_id::create("m_eth_drvr", this);
    m_eth_sqcr = svt_ethernet_transaction_sequencer::type_id::create("m_eth_sqcr", this);
  endfunction

   //
   // Function: connect_phase
   //
   // Connect the subcomponents together based on the configuration object
   // settings.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      // Ethernet collected transaction connection
      m_eth_drvr.seq_item_port.connect(m_eth_sqcr.seq_item_export);
   endfunction : connect_phase


endclass : mux_eth_env

`endif //
