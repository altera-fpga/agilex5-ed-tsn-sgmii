///==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __HPS_COMM_ABSTRACT_SVH__
`define __HPS_COMM_ABSTRACT_SVH__

//------------------------------------------------------------------------------
// Class: hps_comm_abstract
//
// Base abstract class for HPS Communication interface between
// RTB and Environment.
//
//------------------------------------------------------------------------------
virtual class hps_comm_abstract extends altuvm_abstract_base;

   //---------------------------------------------------------------------------
   // Local variables
   //---------------------------------------------------------------------------
   // Main configuration class
   //hps_env_config          m_config;

   function new(string name = "hps_comm_abstract");
      super.new(name);
      m_class_type = name;
   endfunction : new
   //pure virtual function void set_config(hps_env_config _config);

endclass : hps_comm_abstract

`endif//__HPS_COMM_ABSTRACT_SVH__
