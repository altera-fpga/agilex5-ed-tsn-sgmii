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
// Template for UVM-compliant Monitor to Coverage Connector Callbacks
//

`ifndef ETH_TX_LAYERING_MON_2COV_CONNECT
`define ETH_TX_LAYERING_MON_2COV_CONNECT
class eth_tx_layering_mon_2cov_connect extends uvm_component;
   eth_env_cov cov;
   uvm_analysis_export # (eth_packet) an_exp;
   `uvm_component_utils(eth_tx_layering_mon_2cov_connect)
   function new(string name="", uvm_component parent=null);
   	super.new(name, parent);
   endfunction: new

   virtual function void write(eth_packet tr);
      cov.tr = tr;
      -> cov.cov_event;
   endfunction:write 
endclass: eth_tx_layering_mon_2cov_connect

`endif // ETH_TX_LAYERING_MON_2COV_CONNECT
