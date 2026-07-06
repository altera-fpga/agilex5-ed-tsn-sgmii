//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_ENV_SVH__
`define __MUX_ENV_SVH__

//------------------------------------------------------------------------------
// Class: mux_env
//
// UVM Environment for MUX.
//
//------------------------------------------------------------------------------
//class mux_env extends altuvm_env #(mux_ral);
class mux_env extends altuvm_env ;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   // Main configuration class
   mux_env_config        m_env_config;
   // Main RTB configuration class
   mux_rtb_config        m_rtb_config;
   // Main environment and RTB communication object
   mux_comm_abstract     m_comm;

   // Clock and Reset Unit Agent
   altuvm_cru_agent         m_cru_agent;
   altuvm_cru_config        m_cru_config;

   // Ethernet agent
   svt_ethernet_agent       m_vip_ethernet_mac_mst;

`ifdef MUX_DEBUG
   svt_ethernet_agent       ethernet_mac_mst[];
   svt_ethernet_agent       ethernet_mac_slv[];
`endif
   //
   mux_eth_env           m_eth_env[];

   // Axi environment
   svt_axi_system_env       m_axi_st_env;

   // Other components
   mux_push_driver       m_push_drvr[];

   // Coverage collector
   mux_cov               m_coverage;
   // Coverage collector for configurations
   mux_env_config_cov    m_config_cov;

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils_begin(mux_env)
      `uvm_field_object(m_env_config,          UVM_PRINT)
      `uvm_field_object(m_rtb_config,          UVM_PRINT)
   `uvm_component_utils_end

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
      $display ("AS_DBG:: function new called in mux env   ");
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
      //------------------------------------------------------------------------
      // Get the main configuration object
      //------------------------------------------------------------------------
      $display("AS_DBG : Inside build phase of mux env");
      `altuvm_get_config_db(mux_env_config, "mux_env_config", m_env_config)

      //
      // The super.build_phase needs to be after the set_sva_cfg!
      //
      $display("AS_DBG : Inside build phase of mux env before super build");
      super.build_phase(phase);
      $display("AS_DBG : Inside build phase of mux env after super build");

      // Get the RTB configuration object
      `altuvm_get_rtb_config(mux_rtb_config)
      set_dut_path(m_rtb_config.get_dut_path());

      // Get the pointer to the communication object
      `altuvm_get_concrete(mux_comm_abstract, {get_rtb_path(), ".", "get_comm()"}, m_comm)
      m_comm.set_config(m_env_config);

      // Create CRU Agent
      m_cru_agent = altuvm_cru_agent::type_id::create("m_cru_agent", this);
      m_cru_agent.set_rtb_path({get_rtb_path(), ".", "cru_rtb"});
      // Get the CRU configuration object pointer from upstream
      `altuvm_get_config_db(altuvm_cru_config, "m_cru_config", m_cru_config)
      // Set the CRU configuration object pointer to CRU Agent and other downstreams
      `altuvm_set_config_db(altuvm_cru_config, "m_config", m_cru_config, "m_cru_agent")

      // Ethernet
    `ifdef MUX_DEBUG
      $display("AS_DBG : MUX_DEBUG is set to 1 in MUX env");
      ethernet_mac_mst = new[`MAX_AXI_PORT];
      ethernet_mac_slv = new[`MAX_AXI_PORT];
      //
      for(int i=0; i<`MAX_AXI_PORT; i++) begin
      $display("AS_DBG : Inside for loop of creating master slave in mux env");
        ethernet_mac_mst[i] = svt_ethernet_agent::type_id::create($psprintf("ethernet_mac_mst[%0d]", i), this);
        ethernet_mac_slv[i] = svt_ethernet_agent::type_id::create($psprintf("ethernet_mac_slv[%0d]", i), this);
      end
    `endif
        $display("AS_DBG_0 : m_eth_env created in mux env is_block=0");
      if(m_env_config.is_block) begin
        m_eth_env = new[`MAX_AXI_PORT];
        $display("AS_DBG : m_eth_env created in mux env is_block=1");
        //
        for(int i=0; i<`MAX_AXI_PORT; i++) begin
          m_eth_env[i]  = mux_eth_env::type_id::create($psprintf("m_eth_env[%0d]",i), this);
          m_eth_env[i].port_num  = i;
        end
      end
      else begin
        // Fixme: Update for FC level later with num_axi_port, if needed
        m_vip_ethernet_mac_mst = svt_ethernet_agent::type_id::create("m_vip_ethernet_mac_mst", this);
      end

      // Axi
      m_axi_st_env = svt_axi_system_env::type_id::create("m_axi_st_env", this);

      //
      if(m_env_config.is_block) begin
        m_push_drvr = new[`MAX_AXI_PORT];
        //
        for(int i=0; i<`MAX_AXI_PORT; i++) begin
          m_push_drvr[i] = mux_push_driver::type_id::create($psprintf("m_push_drvr[%0d]",i), this);
          m_push_drvr[i].port_num = i;
          m_push_drvr[i].m_env = this;
        end
      end
      //------------------------------------------------------------------------
      // Set HDL path to the RAL
      //------------------------------------------------------------------------
      /*///////////////////////////////////////////////////*/
      /* TODO: Once the RTL is ready, set the correct      */
      /*       hierarchical path to the CSR to line below. */
      /*       After modify, please remove the line marked */
      /*       with <<TO_BE_REMOVED>>.                     */
      /*///////////////////////////////////////////////////*/
  //    if (get_uses_ral())
  //       // <<example>>: m_ral.set_hdl_path({get_dut_path(), ".", "mux_inst.inst_mux_ii", ".", "mux_inst.csr_inst.gen_mux_reg"});
  //       m_ral.set_hdl_path({get_dut_path()});

      //------------------------------------------------------------------------
      // Create Coverage collector
      //------------------------------------------------------------------------
      m_coverage = mux_cov::type_id::create("m_coverage", this);

      //------------------------------------------------------------------------
      // Create Coverage collector for configurations
      //------------------------------------------------------------------------
      m_config_cov = mux_env_config_cov::type_id::create("m_config_cov", this);

   endfunction : build_phase
   //
   // Function: connect_phase
   //
   // Connect the subcomponents together based on the configuration object
   // settings.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      //
      // Connect the device's monitor analysis port to Coverage Collector
      //
      m_cru_agent.m_ap.connect(m_coverage.m_xport_cru);
      //
      // Add the sequencers of each sub-component to virtual sequencer
      //
     for(int i=0; i<`MAX_AXI_PORT; i++) begin
       `altuvm_add_sqcr(m_eth_env[i].m_eth_sqcr, $psprintf("eth_sqcr_%0d", i));
       `ifdef MUX_DEBUG
          `altuvm_add_sqcr(ethernet_mac_mst[i].sequencer, $psprintf("vip_eth_sqcr_%0d", i));
       `endif
      end

     `ifdef MUX_DEBUG
        for(int i =0;i<`MAX_AXI_PORT;i++) begin
          ethernet_mac_mst[i].monitor.item_collected_port_tx.connect(m_push_drvr[i].vip_debug);
        end
     `endif
      
      // Ethernet collected transaction connection
      if(m_env_config.is_block) begin
        for(int i=0; i<`MAX_AXI_PORT; i++) begin
          m_eth_env[i].m_eth_drvr.put_port.connect(m_push_drvr[i].put_imp0);
          m_axi_st_env.slave[i].monitor.item_observed_port.connect(m_push_drvr[i].axi_egress);
        end
      end
      else begin
        // Fixme: This will not be needed for FC
        // m_vip_ethernet_mac_mst.monitor.item_collected_port_tx.connect(m_push_drvr.eth_vip_tx);
      end
   endfunction : connect_phase
   //
   // Function: end_of_elaboration_phase
   //
   // UVM end_of_elaboration phase.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);

      // Sample configuration coverage by directly calling "write" function
      // without connect analysis_export
      m_config_cov.write(m_env_config);

      // Sample the RTB config coverage (HWTCL Parameter coverage)
      m_rtb_config.sample();

      // Initialize RAL
//      if (get_uses_ral()) begin
//         // Set back the registers to its reset value
//         // m_ral.m_ral --> handle of mux_ral.mux_reg_urm
//         //                 extend from altuvm_ral_env.uvm_reg_block
//         m_ral.m_ral.reset();
//         // Set the randomized configuration value into the register model
//         m_ral.set_config();
//         // Print all RAL content, offset, field reset value, randomized value in table format
//         /*/////////////////////////////////////////////////////////////*/
//         /* TODO: Now the URM coverpoint file generation is enabled.    */
//         /*       Once the URM is finalized, run simulation once to get */
//         /*       this file and turn it off for subsequent simulation   */
//         /*       by setting m_ral.m_print_urm_cps = 0;                 */
//         /*       Move the generated file from test result directory to */
//         /*       testbench/uvc/register directory.                     */
//         /*/////////////////////////////////////////////////////////////*/
//         m_ral.m_print_urm_cps = 1;
//         m_ral.ral_print(phase);
      //end
   endfunction : end_of_elaboration_phase
   //
   // Task: run_phase
   //
   // UVM run phase.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual task run_phase(uvm_phase phase);
     super.run_phase(phase);
   endtask : run_phase
   //
   // Task: extract_phase
   //
   // UVM extract phase
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual function void extract_phase(uvm_phase phase);
   endfunction : extract_phase

endclass : mux_env

`endif//__MUX_ENV_SVH__
