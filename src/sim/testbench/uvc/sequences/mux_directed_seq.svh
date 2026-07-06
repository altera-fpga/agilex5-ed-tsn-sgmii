//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_DIRECTED_SEQ_SVH__
`define __MUX_DIRECTED_SEQ_SVH__

//------------------------------------------------------------------------------
// Class: mux_directed_seq
//
// MUX Register Sequence.
//
//------------------------------------------------------------------------------
class mux_directed_seq extends mux_base_seq;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   //    NONE

   //---------------------------------------------------------------------------
   // Variables
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_object_utils(mux_directed_seq)

   //---------------------------------------------------------------------------
   // Constraints
   //---------------------------------------------------------------------------

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name   - Name of the instance.
   //
   function new(string name = "mux_directed_seq");
      super.new(name);
   endfunction : new

   //
   // Task: pre_body
   //
   // UVM sequence's pre_body task.
   //
   virtual task pre_body();
      super.pre_body();
   endtask : pre_body

   //
   // Task: body
   //
   // UVM sequence's body task.
   //
   virtual task body();
     // 
     svt_ethernet_transaction eth_trans;
     //
     //$display("AS_DBG ; Print trans count %d ",m_env.m_env_config.pargs.trans_count); 
     
     repeat(m_env.m_env_config.pargs.trans_count) begin
     //$display("AS_DBG_2 ; Print trans count %d ",m_env.m_env_config.pargs.trans_count); 
       //
       `uvm_create_on(eth_trans, m_env.m_eth_env[0].m_eth_sqcr)
       //
      // if(!eth_trans.randomize() with {eth_trans.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; eth_trans.address  == 48'h112233445566; eth_trans.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR;}) begin
       //  `uvm_fatal(get_type_name(),$sformatf("frame randomization failed"))
     //  end
       //
       `uvm_info("mux_directed_seq", $sformatf("Randomized transaction...\n %s", eth_trans.sprint()), UVM_LOW);
       `uvm_send(eth_trans)
       `uvm_info("mux_directed_seq", $sformatf("transaction driving done..."), UVM_LOW);
     end
   endtask : body

   //
   // Task: post_body
   //
   // UVM sequence's post_body task.
   //
   virtual task post_body();
      super.post_body();
   endtask : post_body

endclass : mux_directed_seq

`endif//__MUX_DIRECTED_SEQ_SVH__
