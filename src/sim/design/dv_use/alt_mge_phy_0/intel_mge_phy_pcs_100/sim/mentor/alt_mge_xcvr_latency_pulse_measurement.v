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

module alt_mge_xcvr_latency_pulse_measurement #(
    parameter SAMPLE_SIZE = 128,
	parameter FIFO_DEPTH = 16,
	parameter PCS_FIFO_DEPTH = 16
) (

  input                  fifo_latency_pulse,
  input                  pcs_fifo_latency_pulse,
  
  input                  latency_sclk,
  input                  reset,
  
  output reg [11:0]      latency_xcvr,
  output reg             result_ready
);

    wire [11:0]   fifo_latency;
	wire          fifo_result_ready;
	
    latency_pulse_measurement #(
	    .FIFO_DEPTH    (FIFO_DEPTH),
		.SAMPLE_SIZE   (SAMPLE_SIZE)
	) FIFO_LATENCY (
	    .clk            (latency_sclk),
		.reset          (reset),
	    .latency_pulse  (fifo_latency_pulse),
		.latency_fifo   (fifo_latency),
		.result_ready   (fifo_result_ready)
	);
	

	wire [11:0]   pcs_fifo_latency;
	wire          pcs_fifo_result_ready;
	
    latency_pulse_measurement #(
	    .FIFO_DEPTH    (PCS_FIFO_DEPTH),
		.SAMPLE_SIZE   (SAMPLE_SIZE)
	) PCS_FIFO_LATENCY (
	    .clk            (latency_sclk),
		.reset          (reset),
	    .latency_pulse  (pcs_fifo_latency_pulse),
		.latency_fifo   (pcs_fifo_latency),
		.result_ready   (pcs_fifo_result_ready)
	);
	
	always @ (posedge latency_sclk or posedge reset) begin
	    if (reset) begin
		    result_ready <= 1'b0;
			latency_xcvr <= {12{1'b0}};
		end
		else begin
		    result_ready <= fifo_result_ready & pcs_fifo_result_ready;
			
			if (result_ready)
			    latency_xcvr  <= pcs_fifo_latency + fifo_latency;
		    else 
			    latency_xcvr <= latency_xcvr;
        end
	end

endmodule