//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_BASE_SEQ_SVH__
`define __MUX_BASE_SEQ_SVH__

//------------------------------------------------------------------------------
// Class: mux_base_seq
//
// UVM Register base sequence for MUX that defines common operations.
//
//------------------------------------------------------------------------------
virtual class mux_base_seq extends altuvm_virtual_sequence;

   //
   // Setup the environment handle
   //
   `altuvm_set_sequence_handles(mux_env )

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name - Name of the instance.
   //
   function new(string name = "mux_base_seq");
      super.new(name);
   endfunction : new

   //
   // Task: pre_body
   //
   virtual task pre_body();
     //
     `uvm_info("mux_base_seq", "In mux_base_seq pre_body ...", UVM_LOW);
     //
     super.pre_body();
   endtask : pre_body
   //
   // Task: body
   //
   // UVM sequence's body task
   //
   virtual task body();
   endtask : body

   // post_body
   virtual task post_body();
     //
     `uvm_info("mux_base_seq", "In mux_base_seq post_body ...", UVM_LOW);
     //
     super.post_body();
   endtask : post_body

endclass : mux_base_seq

`endif//__MUX_BASE_SEQ_SVH__
