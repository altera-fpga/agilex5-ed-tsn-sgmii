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


`timescale 1 ps / 1 ps

module alt_mge_phy_bitsync
  #(
    parameter DWIDTH = 1,    // Sync Data input
    parameter SYNCSTAGE = 2, // Sync stages
    parameter RESET_VAL = 0  // Reset value
    )
    (
    input  wire              clk,     // clock
    input  wire              rst_n,   // async reset
    input  wire [DWIDTH-1:0] data_in, // data in
    output wire [DWIDTH-1:0] data_out // data out
     );

   // Define wires/regs
   reg [(DWIDTH*SYNCSTAGE)-1:0] sync_regs;
   wire                         reset_value;
   
   assign reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;  // To eliminate truncating warning

   // Sync Always block
   always @(negedge rst_n or posedge clk) begin
      if (rst_n == 1'b0) begin
         sync_regs[(DWIDTH*SYNCSTAGE)-1:DWIDTH] <= {(DWIDTH*(SYNCSTAGE-1)){reset_value}};
      end
      else begin
         sync_regs[(DWIDTH*SYNCSTAGE)-1:DWIDTH] <= sync_regs[((DWIDTH*(SYNCSTAGE-1))-1):0];
      end
   end
   
   // Separated out the first stage of FFs without reset
   always @(posedge clk) begin
         sync_regs[DWIDTH-1:0] <= data_in;
   end

   assign data_out = sync_regs[((DWIDTH*SYNCSTAGE)-1):(DWIDTH*(SYNCSTAGE-1))];

endmodule // alt_mge_phy_bitsync

