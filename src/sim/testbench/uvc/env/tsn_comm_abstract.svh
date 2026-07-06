///==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __TSN_COMM_ABSTRACT_SVH__
`define __TSN_COMM_ABSTRACT_SVH__

//------------------------------------------------------------------------------
// Class: tsn_comm_abstract
//
// Base abstract class for TSN Communication interface between
// RTB and Environment.
//
//------------------------------------------------------------------------------
virtual class tsn_comm_abstract extends altuvm_abstract_base;

   //---------------------------------------------------------------------------
   // Local variables
   //---------------------------------------------------------------------------
   // Main configuration class
   //tsn_env_config          m_config;

   function new(string name = "tsn_comm_abstract");
      super.new(name);
      m_class_type = name;
   endfunction : new
   //pure virtual function void set_config(tsn_env_config _config);

endclass : tsn_comm_abstract

`endif//__TSN_COMM_ABSTRACT_SVH__
