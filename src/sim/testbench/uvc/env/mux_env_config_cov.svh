//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_ENV_CONFIG_COV_SVH__
`define __MUX_ENV_CONFIG_COV_SVH__

//------------------------------------------------------------------------------
// Class: mux_env_config_cov
//
// Coverage collector for main configuration object of
// MUX's Top environment.
//
//------------------------------------------------------------------------------
class mux_env_config_cov extends altuvm_subscriber #(mux_env_config);

   //---------------------------------------------------------------------------
   // Class's variable
   //---------------------------------------------------------------------------
   // Coverage enable for the config class
   bit                     m_cov_en;
   // Main configuration object that we want to sample the coverage
   mux_env_config  m_config;

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils_begin(mux_env_config_cov)
      `uvm_field_int(m_cov_en, UVM_PRINT)
   `uvm_component_utils_end

   //---------------------------------------------------------------------------
   // Covergroup definition
   //---------------------------------------------------------------------------
   covergroup mux_env_config_cvg;
      // track coverage information for each instance of cvg in addition
      // to the cumulative coverage information for covergroup type cvg
      option.per_instance = 1;
      type_option.comment = "Coverage model for MUX Configuration";

// <<example>>: // Coverpoint for supported L range
// <<example>>: l_num_cp : coverpoint m_config.m_l_num iff (m_cov_en) {
// <<example>>:    bins one[] = {1};
// <<example>>:    bins more_than_1 = {[2:$]}; }
   endgroup : mux_env_config_cvg

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
      // Create coverage group instance
      mux_env_config_cvg = new();
      mux_env_config_cvg.set_inst_name({get_full_name(), ".mux_env_config_cvg"});
   endfunction : new

   //
   // Function: build_phase
   //
   // Create the subcomponents based on the configuration object settings.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Get the configuration of coverage collector enable
      if (`altuvm_test_parg("MUX_COVER_OFF",
         "Turn off the Env Config Coverage"))
         m_cov_en = 0;
      else
         `altuvm_get_config_db_default(bit, "m_cov_en", m_cov_en, 1)
   endfunction : build_phase
   //
   // Function: write
   //
   // A write method. This method will automatically called whenever
   // there is a write to the analysis_export port.
   //
   // Parameter(s):
   //  t - input sequence item
   //
   virtual function void write(mux_env_config t);
      // Copy the current values
      m_config = t;
      // Sampling coverage
      `uvm_info(get_type_name(), $sformatf("Sampling coverege"), UVM_MEDIUM)
      mux_env_config_cvg.sample();
   endfunction : write

endclass : mux_env_config_cov

`endif//__MUX_ENV_CONFIG_COV_SVH__
