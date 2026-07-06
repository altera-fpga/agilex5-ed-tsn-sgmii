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

`ifndef __EHIP_MII_TX_SEQUENCER_SVH__
`define __EHIP_MII_TX_SEQUENCER_SVH__
typedef class eth_packet;
//------------------------------------------------------------------------------
// Class: ehip_mii_tx_sequencer
//
// This class defines the coverage model for the <ehip_client_tx_agent>.
//
//------------------------------------------------------------------------------
class ehip_mii_tx_sequencer extends uvm_sequencer #(eth_packet);
   //
   // Configuration Properties (can only be set using UVM configutation
   // mechanism).
   //
//   ehip_client_tx_config      m_config;
//   ehip_client_tx_rtb_config  m_rtb_config;

//   protected string  m_msg_id;

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
  `uvm_component_utils(ehip_mii_tx_sequencer)
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
   endfunction: new
   //
   // Function: build_phase
   //
   // Read the configuration information from the environment and use this to
   // locate the BFM.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   function void build_phase(uvm_phase phase);
      //
      // Obtain the generic configuration object.  This reflects
      // the usage and verification environment requirements.
      //
//      `altuvm_get_config_db(ehip_client_tx_config, "m_config", m_config)
//      m_msg_id = {m_config.m_msg_id, ".SQR"};
      super.build_phase(phase);
      //
      // Next obtain the BFM configuration.
      //
//      `altuvm_get_config_db(ehip_client_tx_rtb_config, "m_rtb_config", m_rtb_config)
   endfunction : build_phase

endclass: ehip_mii_tx_sequencer

`endif//__ehip_mii_tx_sequencer_SVH__
