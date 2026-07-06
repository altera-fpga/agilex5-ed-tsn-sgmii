//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_ENV_CONFIG_SVH__
`define __MUX_ENV_CONFIG_SVH__

//------------------------------------------------------------------------------
// Class: mux_env_config
//
// Main configuration object for MUX's Top environment.
//
//------------------------------------------------------------------------------
class mux_env_config extends altuvm_config;

   mux_plusargs pargs;

   // Variables
   speed_e         eth_speed;
   bit             is_block;
   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_object_utils_begin(mux_env_config)
      `uvm_field_string   (m_msg_id, UVM_PRINT)
   `uvm_object_utils_end

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
   function new(string name = "mux_env_config");
      super.new(name);
      // Set checking errors control
      // By default the scoreboard is enabled
      m_ignore["scoreboard"] = 0;
      //
      eth_speed = mux_pkg::_25G;
      is_block = 1'b1;
   endfunction : new

   //
   function void init();
     //
     pargs = mux_plusargs::type_id::create("pargs");
   endfunction

   //
   // Function: post_randomize
   //
   // Adding the tasks for post randomize.
   //
   function void post_randomize();
      super.post_randomize();
      `uvm_info(get_type_name(), {"randomize called ->\n", this.sprint}, UVM_HIGH)
   endfunction : post_randomize

endclass : mux_env_config

`endif//__MUX_ENV_CONFIG_SVH__
