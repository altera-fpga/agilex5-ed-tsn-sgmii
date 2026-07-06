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




`ifndef REG_TOP_CONFIG_SV
`define REG_TOP_CONFIG_SV

// You can insert code here by setting top_env_config_inc_before_class in file common.tpl

class reg_top_config extends uvm_object;

  // Do not register config class with the factory

  //virtual bus_if           bus_vif;            

  uvm_active_passive_enum  is_active_bus       = UVM_ACTIVE;
  bit                      checks_enable_bus;  
  bit                      coverage_enable_bus;

  // You can insert variables here by setting config_var in file common.tpl

  // You can remove new by setting top_env_config_generate_methods_inside_class = no in file common.tpl

  extern function new(string name = "");

  // You can insert code here by setting top_env_config_inc_inside_class in file common.tpl

endclass : reg_top_config 


// You can remove new by setting top_env_config_generate_methods_after_class = no in file common.tpl

function reg_top_config::new(string name = "");
  super.new(name);

  // You can insert code here by setting top_env_config_append_to_new in file common.tpl

endfunction : new


// You can insert code here by setting top_env_config_inc_after_class in file common.tpl

`endif // REG_TOP_CONFIG_SV

