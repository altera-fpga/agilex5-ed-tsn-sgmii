//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_DIRECTED_TEST_SVH__
`define __MUX_DIRECTED_TEST_SVH__

//------------------------------------------------------------------------------
// Class: mux_directed_test
//
// Sample Random Register Transaction test for MUX.
//
//------------------------------------------------------------------------------
class mux_directed_test extends mux_base_test;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   //    NONE

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils(mux_directed_test)

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
   // Configure the subcomponents based on the configuration object settings.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual function void build_phase(uvm_phase phase);
      $display("AS_DBG : Enter directed test build phase");
      super.build_phase(phase);
      $display("AS_DBG : super.build phase done of directed test");
      //
   //:w!
//   m_env.m_eth_env[0].m_eth_sqcr.write_cfg(m_eth_mst_agent_cfg);
   endfunction : build_phase
   //
   // Task: run_phase
   //
   // Execute the sequence(s) in this phase.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual task run_phase(uvm_phase phase);
      // Simple register sequence
      mux_directed_seq   dir_seq;

      super.run_phase(phase);

      // Create the sequences
      dir_seq = mux_directed_seq::type_id::create("dir_seq", this);

      phase.raise_objection(this);

      `uvm_info(get_type_name(), "Start running Simple Transactions", UVM_LOW)
      dir_seq.start(m_env.pick_sqcr());
      `uvm_info(get_type_name(), "Complete running Simple Transactions", UVM_LOW)

      phase.drop_objection(this);
   endtask : run_phase

endclass : mux_directed_test

`endif//__MUX_DIRECTED_TEST_SVH__
