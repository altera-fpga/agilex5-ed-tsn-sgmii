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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module hps_to_mge_clk_mux_macspeed (
   input          clk_in1,
   input          rstn_clk1,
   input          clk_in2,
   input          rstn_clk2,
   input          clk_in3,
   input          rstn_clk3,
   input [1:0]    sel,
   output         rstn_out,   // async from clk_out
   output         clk_out

);

reg      sel_stg1_clk1;
reg      sel_stg2_clk1;
wire     clk1_gate;
reg      sel_stg1_clk2;
reg      sel_stg2_clk2;
wire     clk2_gate;
reg      sel_stg1_clk3;
reg      sel_stg2_clk3;
wire     clk3_gate;

reg         sel_rstn;
reg [1:0]   sel_sync;
reg [1:0]   sel_sync2;
reg [1:0]   sel_sync3;
reg         speed_chg;

// Gated clock circuitry for CLK1
always @(posedge clk_in1 or negedge rstn_clk1) begin
   if (!rstn_clk1)
      sel_stg1_clk1  <= 1'b0;
   else begin
      if (sel[1] == 1'b0 && sel_stg2_clk2 == 1'b0 && sel_stg2_clk3 == 1'b0)
         sel_stg1_clk1   <= 1'b1;
      else
         sel_stg1_clk1   <= 1'b0;
   end
end

always @(negedge clk_in1 or negedge rstn_clk1) begin
   if (!rstn_clk1)
      sel_stg2_clk1  <= 1'b0;
   else begin
      sel_stg2_clk1   <= sel_stg1_clk1;
   end
end

assign clk1_gate   = sel_stg2_clk1 & clk_in1;

// Gated clock circuitry for CLK2
always @(posedge clk_in2 or negedge rstn_clk2) begin
   if (!rstn_clk2)
      sel_stg1_clk2  <= 1'b0;
   else begin
      if (sel == 2'b11 && sel_stg2_clk1 == 1'b0 && sel_stg2_clk3 == 1'b0)
         sel_stg1_clk2   <= 1'b1;
      else
         sel_stg1_clk2   <= 1'b0;
   end

end

always @(negedge clk_in2 or negedge rstn_clk2) begin
   if (!rstn_clk2)
      sel_stg2_clk2  <= 1'b0;
   else begin
      sel_stg2_clk2   <= sel_stg1_clk2;
   end
end

assign clk2_gate   = sel_stg2_clk2 & clk_in2;

// Gated clock circuitry for CLK3
always @(posedge clk_in3 or negedge rstn_clk3) begin
   if (!rstn_clk3)
      sel_stg1_clk3  <= 1'b0;
   else begin
      if (sel == 2'b10 && sel_stg2_clk1 == 1'b0 && sel_stg2_clk2 == 1'b0)
         sel_stg1_clk3   <= 1'b1;
      else
         sel_stg1_clk3   <= 1'b0;
   end
end

always @(negedge clk_in3 or negedge rstn_clk3) begin
   if (!rstn_clk3)
      sel_stg2_clk3  <= 1'b0;
   else begin
      sel_stg2_clk3   <= sel_stg1_clk3;
   end
end

assign clk3_gate   = sel_stg2_clk3 & clk_in3;


// final clock mux
assign clk_out = clk1_gate | clk2_gate | clk3_gate;

always @(posedge clk_in1) begin
   sel_sync    <= sel;
   sel_sync2   <= sel_sync;
   sel_sync3   <= sel_sync2;
   
   if (sel_sync3 != sel_sync2)
      speed_chg   <= 1'b1;
   else
      speed_chg   <= 1'b0;
end

always @* begin
   if (sel == 2'b11)
      sel_rstn <= rstn_clk2;
   else if (sel == 2'b10)
      sel_rstn <= rstn_clk3;
   else
      sel_rstn <= rstn_clk1;
end

assign rstn_out = ~speed_chg & sel_rstn;

endmodule