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


`timescale 1ps/1ps

module directphy_gray_cntr_3 #(
	parameter INIT_VAL = 4'h0
)(
	input clk,
	input ena,
	input aclr,
	output reg [2:0] cntr
);

initial cntr = INIT_VAL;

always @(posedge clk or posedge aclr) begin
	if (aclr) cntr <= INIT_VAL;
	else begin
		if (ena) begin
			case (cntr) 
				3'h0 : cntr <= 3'h1;
				3'h1 : cntr <= 3'h3;
				3'h2 : cntr <= 3'h6;
				3'h3 : cntr <= 3'h2;
				3'h4 : cntr <= 3'h0;
				3'h5 : cntr <= 3'h4;
				3'h6 : cntr <= 3'h7;
				3'h7 : cntr <= 3'h5;
			endcase
		end
	end
end

endmodule
