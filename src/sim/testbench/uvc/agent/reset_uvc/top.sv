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



`ifndef ETH_ENV_TOP__SV
`define ETH_ENV_TOP__SV

    `include "reset_if.sv"
module eth_env_top();
   bit clk=0;

   import uvm_pkg::*;
    `include "uvm_macros.svh"

   reset_if reset_if();
  
   assign reset_if.clock = clk;
   
   always clk = #10 ~ clk;

   initial begin $vcdpluson();end
  
   initial
     begin
     uvm_config_db #(virtual reset_if)::set (null, "*", "slv_if", reset_if);
     run_test ("test1"); 
     #1000000;
     $finish();
     end

endmodule: eth_env_top

`endif // ETH_ENV_TOP__SV
