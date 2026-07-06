//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_COV_SVH__
`define __MUX_COV_SVH__

//------------------------------------------------------------------------------
// Class: mux_cov
//
// Coverage Collector for MUX.
// (Constructed using *analysis_imp* Macro Method)
//
//------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_cru_cv)

class mux_cov extends uvm_component;

   //---------------------------------------------------------------------------
   // Analysis ports
   //---------------------------------------------------------------------------
   // TLM Analysis FIFO for CRU Agent
   uvm_analysis_imp_cru_cv               #(altuvm_cru_tran,           mux_cov) m_xport_cru;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   // Top environment pointer
   protected mux_env           m_env;
   // Main configuration pointer
   protected mux_env_config    m_config;
   // Main RTB configuration pointer
   protected mux_rtb_config    m_rtb_config;
   // Register block pointer
//   protected mux_reg_urm              m_ral;

   // Sequence Items
   altuvm_cru_tran              cru_pkt;


   // Coverage Sampling Control Variables
   bit      cru_pkt_sample;
   

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils_begin(mux_cov)
   `uvm_component_utils_end

   //---------------------------------------------------------------------------
   // Covergroup definition
   //---------------------------------------------------------------------------
   covergroup mux_cvg;
      // track coverage information for each instance of cvg in addition
      // to the cumulative coverage information for covergroup type cvg
      option.per_instance = 1;
      type_option.comment = "Coverage model for MUX";

/*/////////////////////////////////////////////////////////////////////////////*/
/* TODO: Put all the coverpoints and crosses captured from the analysis FIFOs. */
/*/////////////////////////////////////////////////////////////////////////////*/
   endgroup : mux_cvg

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
      mux_cvg = new();
      mux_cvg.set_inst_name({get_full_name(), ".mux_cvg"});
   endfunction : new
   //
   // Function: build_phase
   //
   // Cast the m_env, m_config, m_rtb_config and m_ral.
   // Create the subcomponents based on the configuration object settings.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      //---------------------------------------------------------------------------
      // Get the pionter to the top environment and connect all of the common
      // collaterals
      //---------------------------------------------------------------------------
      `altuvm_assert($cast(m_env, get_parent()),              get_type_name(), ("Getting pointer of m_env, parent environment"))
      `altuvm_assert($cast(m_config, m_env.m_env_config),     get_type_name(), ("Getting pointer of m_config"))
      `altuvm_assert($cast(m_rtb_config, m_env.m_rtb_config), get_type_name(), ("Getting pointer of m_rtb_config"))
   //   if (m_env.get_uses_ral())
   //      `altuvm_assert($cast(m_ral, m_env.m_ral.m_ral),      get_type_name(), ("Getting pointer of m_ral"))
      //---------------------------------------------------------------------------
      // Create analysis ports
      //---------------------------------------------------------------------------
      m_xport_cru         = new("m_xport_cru", this);
   endfunction : build_phase
   //
   // Function: write<SFX>
   //
   // Write method with suffix "SFX" that will automatically called whenever
   // there is a write to the analysis_export port with same sequence item type.
   //
   // Parameter(s):
   //  t - transaction (sequence item) type
   //
   virtual function void write_cru_cv(altuvm_cru_tran  t);
      `altuvm_assert($cast(cru_pkt, t), "write_cru_cv",
         "Incoming transaction type casting.")
         /*//////////////////////////////////////////////////////*/
         /* TODO: sample the fields in cru_pkt for coverage      */
         /*       collection.                                    */
         /*       Please refer to ALTUVM_CRU example testbench,  */
         /*       which shows the coverage collection method.    */
         /*//////////////////////////////////////////////////////*/
      cru_pkt_sample = 1;
      mux_cvg.sample();
      cru_pkt_sample = 0;
   endfunction : write_cru_cv

/*///////////////////////////////////////////////////////////////*/
/* TODO: Put your code to capture the packet of each transaction */
/*       with same type in the functions below.                  */
/*///////////////////////////////////////////////////////////////*/
   //
   // Function: report_phase
   //
   // Report out the number of packets being checked.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   function void report_phase(uvm_phase phase);
      int unsigned covered;
      int unsigned total;
      real pct;

      super.report_phase(phase);
      // at the end simulation in the report phase, display coverage results using
      // SV function "get_coverage"
      pct = mux_cvg.get_coverage(covered, total);
      `uvm_info(get_type_name(), $sformatf(
         "Coverage: covered = %0d, total = %0d (%5.2f%%)", covered, total, pct),
            UVM_MEDIUM)
   endfunction : report_phase

endclass : mux_cov

`endif//__MUX_COV_SVH__
