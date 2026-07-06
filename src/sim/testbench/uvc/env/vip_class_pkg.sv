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


package vip_class_pkg;
virtual class vip_test_suite; 

pure virtual task vip_do_drv_cfg (input [31:0] param, input [63:0] pvalue);
pure virtual task vip_do_mon_cfg (input [31:0] param, input [63:0] pvalue); 
pure virtual task vip_wait_vip_rx_link_down();
pure virtual task vip_wait_vip_rx_link_up();
pure virtual task vip_do_drv_cfg_pcs66(input [31:0] param, input [63:0] pvalue);
pure virtual task vip_do_mon_cfg_pcs66 (input [31:0] param, input [63:0] pvalue);
pure virtual function avst_set_enable_a_non_missing_startofpacket(bit en);
pure virtual function avst_set_enable_a_non_missing_endofpacket(bit en);
pure virtual function avst_set_enable_a_mon_assertion(bit en);
pure virtual task vip_do_drv_err (input [31:0] param, input [71:0] pvalue);
pure virtual task vip_do_drv_cmd (input [31:0] cmd, input [63:0] address, input [31:0] byte_count);
pure virtual task vip_do_drv_pkt (input [7:0] idx, input [7:0] data);
endclass
endpackage
