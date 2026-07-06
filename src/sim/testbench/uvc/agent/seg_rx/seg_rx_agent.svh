// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


///==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//------------------------------------------------------------------------------
// TB/UVC Skeleton is created by: utbgen.pl by Hoong Han Leong
//==============================================================================

`ifndef __CLIENT_RX_AGENT_SVH__
`define __CLIENT_RX_AGENT_SVH__

//-----------------------------------------------------------------------------
// Class: client_rx_agent
//
// This class defines the top-level UVM component the CLIENT_RX protocol.
//
//------------------------------------------------------------------------------
class client_rx_agent extends uvm_agent;

   //---------------------------------------------------------------------------
   // Monitor of this agent
   protected client_rx_monitor         m_mon;
   
   //Coverage instance
 //  client_rx_coverage                  m_coverage;   
   
   // Analysis ports
   uvm_analysis_port #(eth_packet) m_ap;
   uvm_analysis_port #(vector_uvc_packet) m_ap_vec;
   string rtb_path; 



  `uvm_component_utils_begin(client_rx_agent)
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
   endfunction : new
   //
   // Function: build_phase
   //
   // Read the configuration information from the environment and use this to
   // locate the BFM.  Whether this agent is active or passive is determined
   // by the BFM that the agent is connected to.  Once obtained, this
   // configuation information is set for the sub-commponents, which are
   // then created using the UVM component factory.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   function void build_phase(uvm_phase phase);
       //
      // The super.build_phase needs to be after the set_sva_cfg!
      //
      super.build_phase(phase);

      // Printing debug message for the configuration of this component
      `uvm_info(get_type_name(), $sformatf(
         "Printing configurations of this component\n%0s", this.sprint()), UVM_FULL)

      // Create the monitor
      m_mon = client_rx_monitor::type_id::create("m_mon", this);
 
      // Create analysis ports
      m_ap = new("m_ap", this);
      m_ap_vec = new("m_ap_vec", this);
      m_mon.rtb_path=rtb_path;
      
   //   m_coverage = client_rx_coverage::type_id::create("m_coverage", this);
     
      
   endfunction : build_phase
   //
   // Function: connect_phase
   //
   // Export the transaction port from the monitor sub-component and wire up
   // the coverage collector.  If this agent is active, interconnect the
   // seqencer and driver.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
 
      // Connect analysis ports
      m_mon.m_ap.connect(m_ap);
      m_mon.m_ap_vec.connect(m_ap_vec);
   endfunction : connect_phase
 
    function set_rtb_path(string path); 
   	if(rtb_path!="")
   		`uvm_error("set_rtb_path", $sformatf(
            {"Shall not set the m_rtb_path after you've set it once!",
            " Current value is %0s"},rtb_path))
   	else 
   		rtb_path=path; 

   endfunction

   

/*////////////////////////////////////////////////////////////////////////////*/
/* TODO: Add methods to link the methods defined in client_rx_config */
/*       if any. This is due to client_rx_config is protected.       */
/*////////////////////////////////////////////////////////////////////////////*/

endclass : client_rx_agent

`endif//__CLIENT_RX_AGENT_SVH__
