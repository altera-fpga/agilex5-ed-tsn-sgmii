///==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_COMM_ABSTRACT_SVH__
`define __MUX_COMM_ABSTRACT_SVH__

//------------------------------------------------------------------------------
// Class: mux_comm_abstract
//
// Base abstract class for MUX Communication interface between
// RTB and Environment.
//
//------------------------------------------------------------------------------
virtual class mux_comm_abstract extends altuvm_abstract_base;

   //---------------------------------------------------------------------------
   // Local variables
   //---------------------------------------------------------------------------
   // Main configuration class
   mux_env_config          m_config;

   function new(string name = "mux_comm_abstract");
      super.new(name);
      m_class_type = name;
   endfunction : new
   pure virtual function void set_config(mux_env_config _config);

endclass : mux_comm_abstract

`endif//__MUX_COMM_ABSTRACT_SVH__
