//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __GEN_PARAM_OBJ__
`define __GEN_PARAM_OBJ__

   import uvm_pkg::*;
   `include "uvm_macros.svh"
   `include "macsec.svh" 
   `include "macsec_gen_param.sv"

   class gen_param_obj extends gen_param_base;
      //------------------------------------------------------------------------
      // Fixed variable - control using plusargs.
      //------------------------------------------------------------------------
      //    NONE

      //------------------------------------------------------------------------
      // Random variables
      //------------------------------------------------------------------------

      //------------------------------------------------------------------------
      // Register class with factory
      //------------------------------------------------------------------------
      `uvm_object_utils(gen_param_obj)

      //------------------------------------------------------------------------
      // Constraints
      //------------------------------------------------------------------------

      //
      // Constructor: new
      //
      // Creates instance of this UVM object.
      //
      // Parameter(s):
      //  name - Name of the instance.
      //
      function new (string name = "gen_param_obj");
         super.new(name);
      endfunction : new
   endclass : gen_param_obj
`endif
