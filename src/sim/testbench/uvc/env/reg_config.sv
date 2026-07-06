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




`ifndef REG_CONFIG_SV
`define REG_CONFIG_SV

// You can insert code here by setting agent_config_inc_before_class in file bus.tpl

class reg_config extends uvm_object;

  // Do not register config class with the factory

 // virtual bus_if           vif;
                  
  registers_urm             reg_model;
  rsfec_cfgcsr_csr_urm      rsfec_reg_model;
  xcvr_reconfig_urm         xcvr_reg_model, xcvr_reg_model_0,xcvr_reg_model_1,xcvr_reg_model_2,xcvr_reg_model_3;           
  uvm_active_passive_enum   is_active = UVM_ACTIVE;
  bit                       coverage_enable;       
  bit                       checks_enable;         

  // You can insert variables here by setting config_var in file bus.tpl

  // You can remove new by setting agent_config_generate_methods_inside_class = no in file bus.tpl

  extern function new(string name = "");

  // You can insert code here by setting agent_config_inc_inside_class in file bus.tpl

endclass : reg_config 


// You can remove new by setting agent_config_generate_methods_after_class = no in file bus.tpl

function reg_config::new(string name = "");
  super.new(name);
endfunction : new


// You can insert code here by setting agent_config_inc_after_class in file bus.tpl

`endif // REG_CONFIG_SV

