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


typedef class eth_packet;
typedef class dyn_rcfg; 
virtual class seg_tx_driver_abstract extends uvm_report_object; // To facilitate concrete classes to use UVM report methods.
	dyn_rcfg          m_config;
   	registers_urm reg_model;

	pure virtual task monitor_ready(); 
	pure virtual task bfm_drive_idle(); 
	pure virtual task init(); 
	pure virtual task bfm_drive_tran(eth_packet _tran);
	pure virtual task drive_custom_interface(eth_packet _tran); 
	pure virtual task gen_rdy_ltny();
	pure virtual task drive_interm_idle(); 
	pure virtual task num_words_update();
	pure virtual function bit select_upper_lower(int _sop_pos);
   pure virtual function int unsigned get_seg_fp_randc();
endclass 