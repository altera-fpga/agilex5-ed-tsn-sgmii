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
// Template for UVM-compliant interface
//

`ifndef ETH_PCS66_INTERFACE_SV
`define ETH_PCS66_INTERFACE_SV

interface eth_pcs66_interface (input bit clk, input bit rst);

    logic  [65:0]   pcs66_d0;
    logic  [65:0]   pcs66_d1;
`ifdef G100
    logic  [65:0]   pcs66_d2;
    logic  [65:0]   pcs66_d3;
`endif
endinterface: eth_pcs66_interface

`endif

