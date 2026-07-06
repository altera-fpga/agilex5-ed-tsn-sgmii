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
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//------------------------------------------------------------------------------
// TB/UVC Skeleton is created by: utbgen.pl by Hoong Han Leong
//==============================================================================

`ifndef __CLIENT_RX_MONITOR_SVH__
`define __CLIENT_RX_MONITOR_SVH__

//------------------------------------------------------------------------------
// Class: client_rx_monitor
//
// This component implements a bus monitor for the CLIENT_RX bus.
// This class defines the monitor for the <client_rx_agent>.
//
//------------------------------------------------------------------------------
class client_rx_monitor extends uvm_monitor;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   // Agent's configuration class
   dyn_rcfg	m_config;
   // RTB configuration class
   seg_rx_monitor_abstract monitor_abs; 
   string rtb_path;
   uvm_analysis_port #(eth_packet) m_ap;
   uvm_analysis_port #(vector_uvc_packet) m_ap_vec;
   //Object: reg_model
    //This is register model handle
   registers_urm reg_model;
   uvm_reg 	regs;
   uvm_reg_data_t read_data;
   eth_packet pkt_trans;
   vector_uvc_packet pkt_trans_vec;
   
   virtual spy_interface spy_if;
   
   //---------------------------------------------------------------------------
   // Variables
   //---------------------------------------------------------------------------
   protected   string   m_trk_filename;
   protected   int      m_trk_fp;
   protected   int      node;


  `uvm_component_utils_begin(client_rx_monitor)
  `uvm_component_utils_end

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern function void end_of_elaboration_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
   extern task collect_tran();
   extern function int get_num_words();
   extern function transfer_obj();
endclass

   //
   // Constructor: new
   //
   // Creates instance of this UVM component.
   //
   // Parameter(s):
   //  name   - Name of the instance.
   //  parent - Handle to the hierarchical parent, *null* if none.
   //
   function client_rx_monitor::new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   //
   // Function: build_phase
   //
   // Read the configuration information from the environment and use this to
   // locate the BFM.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   function void client_rx_monitor::build_phase(uvm_phase phase);
      super.build_phase(phase);
    
      if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", m_config))
      	`uvm_error("client_rx_monitor","config object is not found");
      uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
        if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in client_rx_monitor");
      // Printing debug message for the configuration of this component
      `uvm_info(get_type_name(), $sformatf(
         "Printing configurations of this component\n%0s", this.sprint()), UVM_DEBUG)
      //
      // Pass the configuration object of this component to its BFM concrete class
           
      //
      //  Create analysis port(s)
      //
      m_ap = new("m_ap", this);
      m_ap_vec = new("m_ap_vec", this);
      // Get concrete object from RTB module 
      if(rtb_path=="") //null
       	`uvm_fatal("client_rx_monitor","rtb_path is not set");
      if(!uvm_config_db#(seg_rx_monitor_abstract)::get(null,rtb_path,"CONCRETE_MONITOR",monitor_abs))
		`uvm_fatal("client_rx_driver","seg_rx_monitor concrete object is not set"); 

      if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
         `uvm_fatal("SEG RX MONITOR","Virtual spy interface not configured!");
      end
      
      transfer_obj(); 
      
   endfunction : build_phase

   // this is to transfer objects received in build phase to concrete class 
   function client_rx_monitor::transfer_obj(); 
   	monitor_abs.m_config= m_config; 
   	monitor_abs.reg_model= reg_model;
      monitor_abs.spy_if = spy_if;
   endfunction
   //
   // Function: end_of_elaboration_phase
   //
   // UVM's end_of_elaboration_phase
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   function void client_rx_monitor::end_of_elaboration_phase(uvm_phase phase);
      string   s = "";
      super.end_of_elaboration_phase(phase);
 
   endfunction : end_of_elaboration_phase
   //
   // Task: run_phase
   //
   // Wait for messages from the monitor BFM and pass these to the
   // analysis port.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   task client_rx_monitor::run_phase(uvm_phase phase);
   	fork 
   		monitor_abs.collect_tran();
   		begin 
   			forever begin 
   				monitor_abs.mmbox.get(pkt_trans); 
   				m_ap.write(pkt_trans);
   				monitor_abs.mmbox_vec.get(pkt_trans_vec); 
   				m_ap_vec.write(pkt_trans_vec);
   			end 
   		end 
   	join
   endtask : run_phase

      
  
`endif//__CLIENT_RX_MONITOR_SVH__
