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

`ifndef PTP_TX_AGENT__SV
`define PTP_TX_AGENT__SV

//==============================================================================
// Class: ptp_tx_agent
// vector agent 
//==============================================================================
class ptp_tx_agent extends uvm_agent;
   
   ptp_tod_drv m_ptp_tod_drv;
   ptp_tx_mon m_ptp_tx_mon;
   ptp_config m_ptp_config;
   string rtb_path;

   uvm_analysis_port #(ptp_tx_tran) m_ap;  //TLM analysis port for mon

   `uvm_component_utils_begin(ptp_tx_agent)
   `uvm_component_utils_end

//==============================================================================
// Function: new
//==============================================================================
function new(string name = "ptp_tx_agent", uvm_component parent = null);
   super.new(name, parent);
   m_ap = new ("m_ap",this);
endfunction

//==============================================================================
// Function: build_phase
// Create method for vector_uvc_mon
//==============================================================================
virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   m_ptp_tod_drv = ptp_tod_drv::type_id::create({get_name(),"_drv"}, this);
   m_ptp_tx_mon = ptp_tx_mon::type_id::create({get_name(),"_mon"}, this);
   if(!uvm_config_db#(ptp_config)::get(this, "", "ptp_config", m_ptp_config))
     `uvm_fatal(get_full_name(),"Failed to get ptp_config");
   m_ptp_tod_drv.set_config(m_ptp_config);
   `uvm_info(get_full_name(),$sformatf("Agent_Get_Name=%0s",{get_name(),"_mon"}),UVM_LOW);
   m_ptp_tx_mon.rtb_path = rtb_path;
  m_ptp_tod_drv.rtb_path = rtb_path;

endfunction: build_phase

function set_rtb_path(string path); 
   	if(rtb_path!="")
   		`uvm_error("set_rtb_path", $sformatf(
            {"Shall not set the m_rtb_path after you've set it once!",
            " Current value is %0s"},rtb_path))
   	else 
   		rtb_path=path; 

   endfunction

//==============================================================================
// Function: connect_phase
//==============================================================================
virtual function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   m_ptp_tx_mon.m_ap.connect(m_ap);
endfunction

//==============================================================================
// Function: start_of_simulation_phase
//==============================================================================
virtual function void start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
endfunction

//==============================================================================
// Function: run_phase
//==============================================================================
virtual task run_phase(uvm_phase phase);
   super.run_phase(phase);
endtask

//==============================================================================
// Function: report_phase
//==============================================================================
virtual function void report_phase(uvm_phase phase);
   super.report_phase(phase);
endfunction

endclass: ptp_tx_agent

`endif // PTP_TX_AGENT__SV
