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
virtual class seg_rx_monitor_abstract extends uvm_report_object; // To facilitate concrete classes to use UVM report methods.
   typedef virtual spy_interface spy_intf;
   spy_intf spy_if;
	dyn_rcfg m_config;
	registers_urm reg_model;
	mailbox#(eth_packet) mmbox=new();//unbounded mailbox 
	mailbox#(vector_uvc_packet) mmbox_vec=new();//unbounded mailbox 
	pure virtual task collect_tran();
   	pure virtual function int get_num_words();
endclass
