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
module alt_mge_x2_encoder_8b10b (
    input clk,
    input rst,
    input [1:0] kin_ena,             // Data in is a special code, not all are legal.      
    input [15 : 0] ein_dat,          // 8b data in
    output [19 : 0] eout_dat           // data out
);

parameter METHOD = 0;

wire [1:0] eout_rdcomb;
wire [1:0] eout_rdreg;
wire [1:0] eout_val;                   // not used, since ein_ena not used in cascaded version

// for simulation visibility
wire [7 : 0] ein_dat1, ein_dat0;
wire [9 : 0] eout_dat1, eout_dat0;
assign {ein_dat1, ein_dat0} = ein_dat;
assign eout_dat = {eout_dat1, eout_dat0};

alt_mge_encoder_8b10b #(
   .METHOD (METHOD)
) enc1(
    .clk (clk),
    .rst (rst),
    .kin_ena(kin_ena[1]),             // Data in is a special code, not all are legal.      
    .ein_ena(1'b1),                   // Data (or code) input enable
    .ein_dat(ein_dat1),       // 8b data in
    .ein_rd(eout_rdcomb[0]),           // running disparity input
    .eout_val(eout_val[1]),           // data out is valid
    .eout_dat(eout_dat1),     // data out
    .eout_rdcomb(eout_rdcomb[1]),     // running disparity output (comb)
    .eout_rdreg(eout_rdreg[1])        // running disparity output (reg)
);
	

alt_mge_encoder_8b10b #(
   .METHOD (METHOD)
) enc0(
    .clk (clk),
    .rst (rst),
    .kin_ena(kin_ena[0]),             // Data in is a special code, not all are legal.      
    .ein_ena(1'b1),                   // Data (or code) input enable
    .ein_dat(ein_dat0),         // 8b data in
    .ein_rd(eout_rdreg[1]),          // running disparity input
    .eout_val(eout_val[0]),           // data out is valid
    .eout_dat(eout_dat0),      // data out
    .eout_rdcomb(eout_rdcomb[0]),     // running disparity output (comb)
    .eout_rdreg(eout_rdreg[0])        // running disparity output (reg)
);

endmodule
