// (C) 2001-2020 Intel Corporation. All rights reserved.
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


//------------------------------------------------------------------------------
// Ethernet IP core top level
//------------------------------------------------------------------------------
`timescale 1ps/1ps
//(* tile_ip,tile_type="f_tile" *) Tag not used anymore

  module top_ip
  
  (

    //Common ports 
    input wire                                    i_src_ip_clk  //          src_ip_ports.clk,                    SRC IP Input clock, Connect to reconfig clock or any user PLL clock 
    );

endmodule


