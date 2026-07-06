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


`timescale 1 ps/1 ps
module dphy_tx_dsk_gen 
  #(
    parameter WIDTH         = 64,
    parameter LANES         = 2,
 //   parameter SYS_COP       = 1,
    parameter FEC_ON       = 1,
    parameter FEC_MODE       = "IEEE 802.3 RS(528,514) (CL 91,KR)",
    parameter pldif_tx_fifo_mode  = "phase_comp", // PLDIF TX FIFO Mode
    parameter DOUBLE_WIDTH_ON   = 1
    )(
      input logic 		     i_clk,
 //   input   logic [SYS_COP-1:0]        i_reset,
      input logic [LANES*WIDTH-1:0]  i_data,
      output logic [LANES*WIDTH-1:0] o_data
      );
//For RSFEC patterns, tx deskew pulses are matching with the valid counts for
//each RSFEC mode. It's either 32 or 16 based on modes.
// 16 -> LLFEC or KP(544,514), tx deskew pulses are toggling every 16 cycles
// 32 -> KR(528,514),tx deskew pulses are toggling every 32 cycles.
// 16 means counter counts up to 15, so [3:0], WIDTH_CNT = 4.
// 32 means counter counts up to 31, so [4:0], WIDTH_CNT = 5
//
// For PMA patterns, tx deskew pulses are generated every 32 cycles.
   localparam WIDTH_CNT = FEC_ON ? 
			  (((FEC_MODE == "IEEE 802.3 RS(528,514) (CL 91,KR)") || 
	                    (FEC_MODE == "Ethernet Consortium RS(528,514)") || 
		            (FEC_MODE == "FC RS(528,514)") ||
		            (FEC_MODE == "FlexO RS(528,514)")) ? 5 : 4)
     : 5;
   
   logic [WIDTH_CNT-1:0] 	     counter = 'b0;
   logic 			     tx_dsk_pulse;
   logic [LANES-1:0] write_enable;
   assign tx_dsk_pulse = &counter;
   always @ (posedge i_clk) begin : increment_deskew_counter
      counter <= counter + 1'b1;
   end : increment_deskew_counter
generate
   genvar l;
   for(l=0;l<LANES;l=l+1)  begin:lane
      //assign o_data[l*80+:80] = DOUBLE_WIDTH_ON ? {1'b1/*i_data[l*80+79]*/, tx_dsk_pulse, i_data[l*80+:78]} 
//	                                            : {i_data[l*80+79 : l*80+37], tx_dsk_pulse, i_data[l*80+:36]};
      
	assign write_enable[l] = (pldif_tx_fifo_mode=="elastic") ? i_data[l*80+79] : 1'b1;

	assign o_data[l*80+:80] = DOUBLE_WIDTH_ON ? {write_enable[l], tx_dsk_pulse, i_data[l*80+:78]} 
	                                            : {i_data[l*80+79 : l*80+37], tx_dsk_pulse, i_data[l*80+:36]};

   end : lane

endgenerate
endmodule
