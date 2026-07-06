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


//
// Template for UVM-compliant Coverage Class
//

`ifndef ETH_ENV_COV__SV
`define ETH_ENV_COV__SV

class eth_env_cov extends uvm_component;
   event cov_event;
   eth_packet tr;
   uvm_analysis_imp #(eth_packet, eth_env_cov) cov_export;
   `uvm_component_utils(eth_env_cov)
 
   covergroup cg_trans @(cov_event);
//      coverpoint tr.kind;
      // ToDo: Add required coverpoints, coverbins
   endgroup: cg_trans


   function new(string name, uvm_component parent);
      super.new(name,parent);
      cg_trans = new;
      cov_export = new("Coverage Analysis",this);
   endfunction: new

   virtual function write(eth_packet tr);
      this.tr = tr;
      -> cov_event;
   endfunction: write

endclass: eth_env_cov

`endif // ETH_ENV_COV__SV

