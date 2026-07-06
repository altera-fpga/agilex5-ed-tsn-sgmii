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

`ifndef __CLIENT_TX_MONITOR_SVH__
`define __CLIENT_TX_MONITOR_SVH__

//------------------------------------------------------------------------------
// Class: client_tx_monitor
//
// This component implements a bus monitor for the CLIENT_TX bus.
// This class defines the monitor for the <client_tx_agent>.
//
//------------------------------------------------------------------------------
class client_tx_monitor extends uvm_monitor;

   
   uvm_analysis_port #(eth_packet) m_ap;


   //---------------------------------------------------------------------------
   // Variables
   //---------------------------------------------------------------------------
   protected   string   m_trk_filename;
   protected   int      m_trk_fp;
   protected   int      node;
   dyn_rcfg m_config;
   seg_tx_monitor_abstract monitor_abs; 
   string rtb_path; 
   //Object: reg_model
    //This is register model handle
   registers_urm reg_model;
   uvm_reg 	regs;
   uvm_reg_data_t read_data,txmac_ehip_cfg;
   bit txcrc_cover_preamble;

//PTP related decl 
   ptp_kind_e ptp_kind;
   int num_ptp_pkts = 0;
   bit [95:0] q_ptp_tx[$];
   bit [95:0] o_ptp_ets;
   bit [95:0] ts_diff_hex;
   bit [7:0]  mon_ptp_val;
  
   virtual spy_interface spy_if;

   virtual eth_fc_interface fc_if;

   string  file_seg_mon = "seg_mon_pkt.log"; 
   
   integer file_seg_mon_pkt_id = $fopen(file_seg_mon,"a"); 
   eth_packet pkt_trans;


   `uvm_component_utils_begin(client_tx_monitor)
   `uvm_component_utils_end

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase); 
   extern function void end_of_elaboration_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);  
   extern task collect_tran();
   extern task collect_ptp_tx_tran(int _sop_pos);
   extern function int get_num_words();
   extern function bit select_upper_lower(int _sop_pos);
   extern function transfer_obj(); 
endclass


   // Constructor: new
   //
   // Creates instance of this UVM component.
   //
   // Parameter(s):
   //  name   - Name of the instance.
   //  parent - Handle to the hierarchical parent, *null* if none.
   //
   function client_tx_monitor::new(string name, uvm_component parent);
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
   function void client_tx_monitor::build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", m_config))
      	`uvm_error("client_tx_monitor","config object is not found");
      uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
        if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in client_tx_monitor");
      //
      //  Create analysis port(s)
      //
      m_ap           = new("m_ap", this);
      // Get concrete object from RTB module 
      if(rtb_path=="") //null
       	`uvm_fatal("client_tx_monitor","rtb_path is not set");
      if(!uvm_config_db#(seg_tx_monitor_abstract)::get(null,rtb_path,"CONCRETE_MONITOR",monitor_abs))
		`uvm_fatal("client_tx_driver","seg_tx_monitor concrete object is not set");        	

    if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
    `uvm_fatal("SEG MONITOR","Virtual spy interface not configured!");
   end

    if(!uvm_config_db#(virtual eth_fc_interface)::get(this, "", "mst_if", fc_if)) begin
       `uvm_fatal("env_name_tx_layer_mon", "failed to get fc interface");
    end 

      transfer_obj(); 

   endfunction : build_phase

    // this is to transfer objects received in build phase to concrete class 
   function client_tx_monitor::transfer_obj(); 
   	monitor_abs.m_config= m_config; 
   	monitor_abs.reg_model= reg_model;
    monitor_abs.spy_if = spy_if;
    monitor_abs.fc_if = fc_if;
   	endfunction

   function void client_tx_monitor::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
    file_seg_mon_pkt_id = $fopen({"client",file_seg_mon},"a");
    
   endfunction: connect_phase 

	function void client_tx_monitor::report_phase(uvm_phase phase);
	    super.report_phase(phase);
	$fclose(file_seg_mon_pkt_id);
	endfunction:report_phase 

   //
   // Function: end_of_elaboration_phase
   //
   // UVM's end_of_elaboration_phase
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   function void client_tx_monitor::end_of_elaboration_phase(uvm_phase phase);
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
   task client_tx_monitor::run_phase(uvm_phase phase);
   	fork 
   		monitor_abs.collect_tran();
   		begin 
   			forever begin 
   				monitor_abs.mmbox.get(pkt_trans); 
   				m_ap.write(pkt_trans);
   				$fwrite(file_seg_mon_pkt_id,"Transaction no:%0d\n %s \n",pkt_trans.transaction_id,pkt_trans.print_transaction(.frame_count(pkt_trans.transaction_id),.seg_mode(1)));  
   			end 
   		end 
   	join

   endtask : run_phase
   
  
`endif//__CLIENT_TX_MONITOR_SVH__
