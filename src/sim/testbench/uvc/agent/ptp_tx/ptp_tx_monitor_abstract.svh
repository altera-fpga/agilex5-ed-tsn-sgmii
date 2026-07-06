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


typedef class dyn_rcfg; 
typedef class eth_packet;
typedef class ptp_tx_tran;
virtual class ptp_tx_monitor_abstract extends uvm_report_object;
  dyn_rcfg dyn_rcfg_obj_inst;
 // spy_interface spy_if;
 // reset_if reset_if;
 typedef virtual spy_interface spy_intf;
 spy_intf spy_if;
typedef virtual reset_if rst_intf;
rst_intf rst_if;
	registers_urm reg_model;
  mailbox#(eth_packet) mmbox_from_layer_agent= new();
  mailbox#(ptp_tx_tran) mmbox_tx= new();
  mailbox#(ptp_tx_tran) mmbox_rx= new();
  mailbox#(ptp_tx_tran) mmbox_wb_tx= new();
  mailbox#(ptp_tx_tran) mmbox_wb_rx= new();
  
  pure virtual task collect_tran;
  pure virtual task rx_ptp_monitor;
  pure virtual task ptp_accuracy_monitor;
  pure virtual task num_words_update;
  pure virtual task bit_width_update;

endclass
