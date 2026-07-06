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


// (C) 2001-2021 Intel Corporation. All rights reserved.
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


`timescale 1ns/1ns
module alt_mge_x2_carrier_detect (
   input          clk,
   input          rst,
   input  [19:0]  din_dat,
   output [1:0]   carrier_detected
);

alt_mge_carrier_detect det1 (
   .clk        (clk),
   .rst        (rst),
   .sw_reset   (1'b0),
   .ce         (1'b1),
   .data_align (din_dat[19:10]),
   .carrier    (carrier_detected[1])
);

alt_mge_carrier_detect det0 (
   .clk        (clk),
   .rst        (rst),
   .sw_reset   (1'b0),
   .ce         (1'b1),
   .data_align (din_dat[9:0]),
   .carrier    (carrier_detected[0])
);

endmodule
