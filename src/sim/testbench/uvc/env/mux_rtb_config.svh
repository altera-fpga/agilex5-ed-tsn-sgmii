//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_RTB_CONFIG_SVH__
`define __MUX_RTB_CONFIG_SVH__

//------------------------------------------------------------------------------
// Class: mux_rtb_config
//
// Configuration object for MUX's RTB module.
//
//------------------------------------------------------------------------------
class mux_rtb_config extends altuvm_rtb_config;

   //---------------------------------------------------------------------------
   // UVM field Item lists
   //---------------------------------------------------------------------------
   // DUT and TB parameter lists
   `MUX_RTB_PARAM_DEFCFG
   mux_pkg::device_e   E_DEVICE_FAMILY;
   int unsigned		MAX_AXI_PORT;

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_object_utils_begin(mux_rtb_config)
      `MUX_RTB_PARAM_DEFUVM
      `uvm_field_enum(mux_pkg::device_e, E_DEVICE_FAMILY, UVM_PRINT)
      `uvm_field_int( MAX_AXI_PORT,	UVM_PRINT)
   `uvm_object_utils_end

   //---------------------------------------------------------------------------
   // Constraints
   //---------------------------------------------------------------------------
   //    NONE

   //---------------------------------------------------------------------------
   // Covergroup definition
   //---------------------------------------------------------------------------
   covergroup hwtcl_param_cvg;
      // track coverage information for each instance of cvg in addition
      // to the cumulative coverage information for covergroup type cvg
      option.per_instance = 1;
      type_option.comment = "Coverage model for MUX's HWTCL Parameter";

/*///////////////////////////////////////////////////////////////*/
/* TODO: List down all RTB Config variables that capture the     */
/*       values of parameters in this covergroup in the form of  */
/*       coverpoints and crosses.                                */
/*///////////////////////////////////////////////////////////////*/
// NOTE:
// Below are examples.
///////////////////////////////////////////////////////////////////
      bit_rate_cp:         coverpoint BIT_RATE {
                                   bins   all[] = {614, 1228, 2457, 3072,
                                                   4915, 6144, 9830, 10137};
                           illegal_bins   bad   = default;  }

      device_cp:           coverpoint E_DEVICE_FAMILY {
                                   bins   all[] = {mux_pkg::StratixV,
                                                   mux_pkg::Arria10};
                           illegal_bins   bad   = default;  }

      parameters_cross:    cross bit_rate_cp, device_cp;

   endgroup : hwtcl_param_cvg

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name   - Name of the instance.
   //
   function new(string name = "mux_rtb_config");
      super.new(name);
      // Create coverage group instance
      hwtcl_param_cvg = new();
      hwtcl_param_cvg.set_inst_name({m_msg_id, ".hwtcl_param_cvg"});
   endfunction : new
   //
   // Function: sample
   //
   // Method to sample the coverage
   //
   virtual function void sample();
      `uvm_info(get_type_name(),
         "Sampling coverege for hwtcl Parameters", UVM_MEDIUM)
      hwtcl_param_cvg.sample();
   endfunction : sample

endclass : mux_rtb_config

`endif//__MUX_RTB_CONFIG_SVH__
