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


//==============================================================================
// (C) 2011-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
// $File: 
// $Revision:
// $Date: 
// $Author: 
// Created by: 
//==============================================================================

`ifndef __EHIP_MII_TX_AGENT_SV__
`define __EHIP_MII_TX_AGENT_SV__
 
//-----------------------------------------------------------------------------
// Class: ehip_mii_tx_agent
//
// This class defines the top-level UVM component the EHIP_CLIENT_TX protocol.
//
//------------------------------------------------------------------------------
class ehip_mii_tx_agent extends uvm_agent;

  //---------------------------------------------------------------------------
  // Class Variables
  //---------------------------------------------------------------------------
  ehip_mii_tx_driver       m_drv;
  ehip_mii_tx_sequencer    m_sqr;
  ehip_mii_monitor         mii_tx_mon;
  ehip_mii_monitor         mii_rx_mon;

  // Analysis ports
  uvm_analysis_port #(eth_packet) m_ap;

  //---------------------------------------------------------------------------
  // Register class with factory
  //---------------------------------------------------------------------------
  `uvm_component_utils(ehip_mii_tx_agent)

  //---------------------------------------------------------------------------
  // Constructor: new
  //---------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------------------------------------------
  // Function: build_phase
  //---------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_drv = ehip_mii_tx_driver::type_id::create("m_drv", this);
    m_sqr = ehip_mii_tx_sequencer::type_id::create("m_sqr", this);
    mii_tx_mon = ehip_mii_monitor::type_id::create("mii_tx_mon", this);
    mii_rx_mon = ehip_mii_monitor::type_id::create("mii_rx_mon", this);
    m_ap = new("m_ap", this);
  endfunction : build_phase

  //---------------------------------------------------------------------------
  // Function: connect_phase
  //---------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_drv.seq_item_port.connect(m_sqr.seq_item_export);
  endfunction : connect_phase

endclass : ehip_mii_tx_agent

`endif//__EHIP_MII_TX_AGENT_SV__
