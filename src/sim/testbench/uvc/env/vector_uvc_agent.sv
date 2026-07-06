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


//==============================================================================
// (C) 2011-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
// $File: /data/jbharatk/softip/acds/main/regtest/ip/ethernet/alt_ethernet/testbench/uvc/agent $
// $Revision: #1 $
// $Date: 2017/8/9 $
// $Author: jbharatk $
//==============================================================================

`ifndef VECTOR_UVC_AGENT__SV
`define VECTOR_UVC_AGENT__SV

//==============================================================================
// Class: vector_uvc_agent
// vector agent 
//==============================================================================
class vector_uvc_agent extends uvm_agent;
   
   vector_uvc_mon uvc_mon;
   uvm_analysis_port #(vector_uvc_packet) m_ap;  //TLM analysis port for mon
   uvm_analysis_port #(vector_uvc_packet) m_ap_tx;  //TLM analysis port for mon

   `uvm_component_utils_begin(vector_uvc_agent)
    //ToDo: add field utils macros here if required
   `uvm_component_utils_end

//==============================================================================
// Function: new
//==============================================================================
function new(string name = "vector_uvc_agent", uvm_component parent = null);
   super.new(name, parent);
   m_ap = new ("m_ap",this);
   m_ap_tx = new ("m_ap_tx",this);
endfunction

//==============================================================================
// Function: build_phase
// Create method for vector_uvc_mon
//==============================================================================
virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   uvc_mon = vector_uvc_mon::type_id::create({get_name(),"_mon"}, this);
   `uvm_info(get_full_name(),$sformatf("Agent_Get_Name=%0s",{get_name(),"_mon"}),UVM_LOW);
endfunction: build_phase

//==============================================================================
// Function: connect_phase
//==============================================================================
virtual function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvc_mon.m_ap.connect(m_ap);
   uvc_mon.m_ap_tx.connect(m_ap_tx);
endfunction

//==============================================================================
// Function: start_of_simulation_phase
//==============================================================================
virtual function void start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
   //ToDo :: Implement here
endfunction

//==============================================================================
// Function: run_phase
//==============================================================================
virtual task run_phase(uvm_phase phase);
   super.run_phase(phase);
   //ToDo :: Implement here
endtask

//==============================================================================
// Function: report_phase
//==============================================================================
virtual function void report_phase(uvm_phase phase);
   super.report_phase(phase);
   //ToDo :: Implement here
endfunction

endclass: vector_uvc_agent

`endif // VECTOR_UVC_AGENT__SV
