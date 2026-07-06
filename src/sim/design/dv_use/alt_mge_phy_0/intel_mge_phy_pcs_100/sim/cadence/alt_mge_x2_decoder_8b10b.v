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


`timescale 1ps / 1ps
module alt_mge_x2_decoder_8b10b (
	input         clk,
	input         rst,
	input [19:0]  din_dat,         // 10b data input
	output [15:0] dout_dat,        // data out
	output [1:0]  dout_k,          // special code
	output [1:0]  dout_kerr,       // coding mistake detected
	output [1:0]  dout_rderr,      // running disparity mistake detected
	output [1:0]  dout_rdcomb,     // running dispartiy output (comb)
	output [1:0]  dout_rdreg       // running disparity output (reg)
);

parameter METHOD = 0;

alt_mge_decoder_8b10b #(
   .METHOD (METHOD)
) dec1(
    .clk (clk),
    .rst (rst),
    .din_ena(1'b1),                   // Data (or code) input enable
    .din_dat(din_dat[19 : 10]),       // 8b data in
    .din_rd(dout_rdcomb[0]),           // running disparity input
    .dout_val(),
    .dout_kerr(dout_kerr[1]),
    .dout_dat(dout_dat[15 : 8]),     // data out
    .dout_k(dout_k[1]),
    .dout_rderr(dout_rderr[1]),
    .dout_rdcomb(dout_rdcomb[1]),     // running disparity output (comb)
    .dout_rdreg(dout_rdreg[1])        // running disparity output (reg)
);

alt_mge_decoder_8b10b #(
   .METHOD (METHOD)
) dec0(
    .clk (clk),
    .rst (rst),
    .din_ena(1'b1),                   // Data (or code) input enable
    .din_dat(din_dat[9 : 0]),         // 8b data in
    .din_rd(dout_rdreg[1]),          // running disparity input
    .dout_val(),
    .dout_kerr(dout_kerr[0]),
    .dout_dat(dout_dat[7 : 0]),       // data out
    .dout_k(dout_k[0]),
    .dout_rderr(dout_rderr[0]),
    .dout_rdcomb(dout_rdcomb[0]),     // running disparity output (comb)
    .dout_rdreg(dout_rdreg[0])        // running disparity output (reg)
);

endmodule
