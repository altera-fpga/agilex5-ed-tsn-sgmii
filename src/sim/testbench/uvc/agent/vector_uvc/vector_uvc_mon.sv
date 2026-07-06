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

`ifndef VECTOR_UVC_MON__SV
`define VECTOR_UVC_MON__SV

//typedef class vector_uvc_packet;
//typedef class vector_uvc_mon;

//==============================================================================
// Class: vector_uvc_mon
// This vector monitor check status data & error status & send to scoreboard for comparison 
//==============================================================================

class vector_uvc_mon extends uvm_monitor;
  
  uvm_analysis_port #(vector_uvc_packet) m_ap;  //TLM analysis port for mon 
  uvm_analysis_port #(vector_uvc_packet) m_ap_tx;  //TLM analysis port for mon 
  
  virtual vector_uvc_interface mon_if;
  vector_uvc_packet m_tran, m_tran_tx;
  int  cover_disable_for_macseg =0;

  int transaction_id=0;
  int transaction_id_tx=0;
 
  extern function new(string name = "vector_uvc_mon",uvm_component parent);
  
  `uvm_component_utils_begin(vector_uvc_mon)
  `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual task collect_tran();
   extern virtual function void report_phase(uvm_phase phase);
   covergroup cg();
   option.per_instance = 1;
   option.name = $sformatf("VECTOR_CG_%s",get_full_name());

      // Abhishek Tiwari -- removed as per GDR FS
      vlan_stacked_vlan: coverpoint m_tran.status_data[33] iff(mon_if.mon_cb.status_valid==1) {
         bins vlan_stacked_vlan_zero            = {0};
         bins vlan_stacked_vlan_one             = {1};
      }
      control: coverpoint m_tran.status_data[34] iff(mon_if.mon_cb.status_valid==1) {
         bins control_zero         = {0};
         bins control_one          = {1};
      }
      pause: coverpoint m_tran.status_data[35] iff(mon_if.mon_cb.status_valid==1) {
         bins pause_zero           = {0};
         bins pause_one            = {1};
      }
      broadcast_multicast: coverpoint m_tran.status_data[37] iff(mon_if.mon_cb.status_valid==1) {
         bins broadcast_multicast_zero       = {0};
         bins broadcast_multicast_one        = {1};
      }
      flowcontrol: coverpoint m_tran.status_data[35] iff(mon_if.mon_cb.status_valid==1) {
         bins flowcontro_zero      = {0};
         bins flowcontro_one       = {1};
      }

      // Abhishek Tiwari -- removed as per GDR FS
   endgroup

endclass: vector_uvc_mon

//==============================================================================
// Function: new
// Create a object for analysis port for mon
//==============================================================================
function vector_uvc_mon::new(string name = "vector_uvc_mon",uvm_component parent);
  super.new(name, parent);
  if(!get_config_int("cover_disable_for_macseg",cover_disable_for_macseg))
  `uvm_error("vector_uvc_mon","cover_disable_for_macseg is not found");

 $display("cover_disable_for_macseg %d",cover_disable_for_macseg);
  m_ap = new ("m_ap",this);
  m_ap_tx = new ("m_ap_tx",this);
  if (!cover_disable_for_macseg)
  cg = new();
endfunction: new

//==============================================================================
// Function: build_phase
//==============================================================================
function void vector_uvc_mon::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual vector_uvc_interface)::get(this, "", "vector_if", mon_if)) begin
    `uvm_fatal("@Vector_Monitor","Virtul interface not configured!");
  end
endfunction: build_phase

//==============================================================================
// Function: connect_phase
// get the interface using the configuration database
//==============================================================================
function void vector_uvc_mon::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction: connect_phase

//==============================================================================
// Function: end_of_elaboration_phase
//==============================================================================
function void vector_uvc_mon::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase); 
endfunction: end_of_elaboration_phase

//==============================================================================
// Task: run_phase
//==============================================================================
task vector_uvc_mon::run_phase(uvm_phase phase);
  super.run_phase(phase);
  collect_tran();
endtask: run_phase

//==============================================================================
// Task: collect_trans
// Here collect the transaction from the interface & send it to SB using analysis port
//==============================================================================
task vector_uvc_mon::collect_tran();
//  vector_uvc_packet m_tran;

  fork 
    begin
     forever begin
      @(mon_if.mon_cb);
        `ifndef ETH_MULTI_PORT
	if((mon_if.mon_cb.status_valid && mon_if.mon_cb.end_offpacket)) begin
	`else
	if(mon_if.mon_cb.status_valid) begin
	`endif
          m_tran = vector_uvc_packet::type_id::create("m_tran");
          m_tran.status_data = mon_if.mon_cb.status_data;
          m_tran.status_error =  mon_if.mon_cb.status_error;
          //`uvm_info(get_full_name(),$sformatf("Interface Vector Data Transactions=%0d,Error Transactions=%0d",mon_if.mon_cb.status_data,mon_if.mon_cb.status_error),UVM_MEDIUM)
          `uvm_info(get_full_name(),$sformatf("Vector Data Transactions=%0h,Error Transactions=%0h",m_tran.status_data,m_tran.status_error),UVM_MEDIUM)
          transaction_id = transaction_id + 1; //Increment the transaction id
          m_tran.transaction_id = transaction_id; 
          `uvm_info(get_full_name(),$sformatf("Transaction_ID=%0d",transaction_id),UVM_MEDIUM)
          m_ap.write(m_tran);
          `uvm_info(get_full_name(),$sformatf("Vector Collected transaction ->\n%0s", m_tran.sprint()), UVM_MEDIUM)
          if (!cover_disable_for_macseg)
          cg.sample();
        end//if
     end
    end
    begin
      forever begin
      @(mon_if.mon_cb_tx);
        if((mon_if.mon_cb_tx.status_valid_tx)) begin
          m_tran_tx = vector_uvc_packet::type_id::create("m_tran_tx");
          m_tran_tx.status_data = mon_if.mon_cb_tx.status_data_tx;
          m_tran_tx.status_error =  mon_if.mon_cb_tx.status_error_tx;
          //`uvm_info(get_full_name(),$sformatf("Interface Vector Data Transactions=%0d,Error Transactions=%0d",mon_if.mon_cb.status_data,mon_if.mon_cb.status_error),UVM_MEDIUM)
          `uvm_info(get_full_name(),$sformatf("Vector Data Transactions=%0h,Error Transactions=%0h",m_tran_tx.status_data,m_tran_tx.status_error),UVM_MEDIUM)
          transaction_id_tx = transaction_id_tx + 1; //Increment the transaction id
          m_tran_tx.transaction_id = transaction_id_tx; 
          `uvm_info(get_full_name(),$sformatf("Transaction_ID=%0d",transaction_id_tx),UVM_MEDIUM)
          m_ap_tx.write(m_tran_tx);
          `uvm_info(get_full_name(),$sformatf("Vector Collected transaction ->\n%0s", m_tran_tx.sprint()), UVM_MEDIUM)
          end//if    
      end
    end
    join
endtask//collect_tran

//==============================================================================
// Function: start_of_simulation_phase
//==============================================================================
function void vector_uvc_mon::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
   //ToDo: Implement SOS phase here
endfunction: start_of_simulation_phase

//==============================================================================
// Function: reset_phase
//==============================================================================
task vector_uvc_mon::reset_phase(uvm_phase phase);
  super.reset_phase(phase);
   // ToDo: Implement reset here
endtask: reset_phase

//==============================================================================
// Function: configure_phase
//==============================================================================
task vector_uvc_mon::configure_phase(uvm_phase phase);
  super.configure_phase(phase);
   //ToDo: Configure your component here
endtask:configure_phase

//==============================================================================
// Function: report_phase
//==============================================================================
function void vector_uvc_mon::report_phase(uvm_phase phase);
  super.report_phase(phase);
   // ToDo: Implement report phase here
endfunction:report_phase

`endif // VECTOR_UVC_MON__SV
