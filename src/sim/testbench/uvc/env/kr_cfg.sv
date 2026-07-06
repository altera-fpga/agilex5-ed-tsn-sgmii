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


`ifndef KR_CFG_SV
`define KR_CFG_SV
//Class : kr_cfg
//This is config object class for KR bandwidths and nodes
class kr_cfg extends uvm_object;
   
   /* Following fields stores active bandwidths, 0=inactive, 1=active*/
   bit is_speed_10g;       
   bit is_speed_25g;       
   bit is_speed_40g;       
   bit is_speed_50g;       
   bit is_speed_100g;
   bit is_speed_200g;
   bit is_speed_400g;

   bit [15:0] node_sel_10g;
   bit [15:0] node_sel_25g;
   bit [7:0] node_sel_40g;
   bit [7:0]  node_sel_50g;
   bit [3:0]  node_sel_100g;
   bit [1:0]  node_sel_200g;
   bit        node_sel_400g;

   bit [15:0] active_10g;
   bit [15:0] active_25g;
   bit [7:0] active_40g;
   bit [7:0]  active_50g;
   bit [3:0]  active_100g;
   bit [1:0]  active_200g;
   bit        active_400g;
   
   /* dont any of these anymore.PLz Delete :NEHA 
 Following fields store anlt enabled channels */
   /* Index identifies channel number */
   /* value identifies anle enabled or not 1=enabled, 0=disabled */
   bit channel_anlt[$];
   bit channel_start_node[$];
   bit channel_end_node[$];

   `uvm_object_utils_begin(kr_cfg)
     `uvm_field_int(is_speed_10g,UVM_ALL_ON)
     `uvm_field_int(is_speed_25g,UVM_ALL_ON)
     `uvm_field_int(is_speed_40g,UVM_ALL_ON)
     `uvm_field_int(is_speed_50g,UVM_ALL_ON)
     `uvm_field_int(is_speed_100g,UVM_ALL_ON)
     `uvm_field_int(is_speed_200g,UVM_ALL_ON)
     `uvm_field_int(is_speed_400g,UVM_ALL_ON)
     `uvm_field_queue_int(channel_anlt,UVM_ALL_ON)
     `uvm_field_queue_int(channel_start_node,UVM_ALL_ON)
     `uvm_field_queue_int(channel_end_node,UVM_ALL_ON)
     `uvm_field_int(node_sel_10g,UVM_ALL_ON)
     `uvm_field_int(node_sel_25g,UVM_ALL_ON)
     `uvm_field_int(node_sel_40g,UVM_ALL_ON)
     `uvm_field_int(node_sel_50g,UVM_ALL_ON)
     `uvm_field_int(node_sel_100g,UVM_ALL_ON)
     `uvm_field_int(node_sel_200g,UVM_ALL_ON)
     `uvm_field_int(node_sel_400g,UVM_ALL_ON)
     `uvm_field_int(active_10g,UVM_ALL_ON)
     `uvm_field_int(active_25g,UVM_ALL_ON)
     `uvm_field_int(active_40g,UVM_ALL_ON)
     `uvm_field_int(active_50g,UVM_ALL_ON)
     `uvm_field_int(active_100g,UVM_ALL_ON)
     `uvm_field_int(active_200g,UVM_ALL_ON)
     `uvm_field_int(active_400g,UVM_ALL_ON)
   `uvm_object_utils_end

   function new(string name = "kr_cfg");
      super.new(name);
   endfunction : new

endclass // kr_cfg
`endif
