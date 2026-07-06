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


//////////////////////////////////////////////////////////////////////////////
// 
// Module: Altera Ethernet MAC 32bit TX Source Address Replacement
//
// Description: 
//  Handles Source Address Replacement
//
// Parameter: 
//  * TXDATAWIDTH       = 32,
//  * TXEMPTYWIDTH		= 2,
//  * TXSINKERRWIDTH	= 1,
//  * TXSRCERRWIDTH		= 1,
//  * PIPELINE_READY	= 0		// 1 = src_ready is registered output
//
// Control:
//  * Avalon ST sink, src interface
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_srcaddr_inserter #(
    parameter TXDATAWIDTH       = 32,
	parameter TXEMPTYWIDTH		= 2,
	parameter TXSINKERRWIDTH	= 1,
	parameter TXSRCERRWIDTH		= 1,
	parameter PIPELINE_READY	= 0		// 1 = src_ready is registered output
	)
(

    // Clock and reset
    input wire						clk,
    input wire						rst_n,

	input wire						preamble_passthru,
	input wire						srcaddr_insrt_en,
	input [47:0]					srcaddr,
    
	input wire          			sink_sop,
	input wire          			sink_valid,
	output wire						sink_ready,
	input wire [TXDATAWIDTH-1:0]	sink_data,
	input wire [TXEMPTYWIDTH-1:0]	sink_empty,
	input wire [TXSINKERRWIDTH-1:0]	sink_error,
	input wire          			sink_eop,

	output wire          			src_sop,
	output wire          			src_valid,
	input wire						src_ready,
	output [TXDATAWIDTH-1:0]		src_data,
	output wire  [TXEMPTYWIDTH-1:0]	src_empty,
	output wire [TXSRCERRWIDTH-1:0]	src_error,
	output wire						src_eop	
);

	
	// State Machine
	localparam												ST0	= 3'b000;
	localparam												ST1	= 3'b001;
	localparam												ST2	= 3'b010;
	localparam												ST3	= 3'b011; // Override SA here
	localparam												ST4	= 3'b100; // Override SA here
	localparam												ST5	= 3'b101; 
		
	reg	[2:0]												STCNT_SM_ps;
	reg	[2:0]												STCNT_SM_ns;
	
	wire													arc_ST0_ST1;
	wire													arc_ST0_ST3;
	wire													arc_ST1_ST2;
	wire													arc_ST2_ST3;
	wire													arc_ST3_ST4;
	wire													arc_ST4_ST5;
	wire													arc_ST5_ST0;

	// internal wires, registers
	reg														int_sink_ready;
	reg [TXDATAWIDTH-1:0]									int_sink_data;
	
	wire													in_valid_p0;
	wire													in_ready_p0;
	wire [(TXSRCERRWIDTH+TXEMPTYWIDTH+TXDATAWIDTH+2)-1:0]	in_data_p0;
	wire													out_valid_p0;
	wire													out_ready_p0;
	wire [(TXSRCERRWIDTH+TXEMPTYWIDTH+TXDATAWIDTH+2)-1:0]	out_data_p0;


	//
	// *********************************************************************
	// 

    // SYNC_RESET FLOPS
	always @(posedge clk)
        begin
			if(!rst_n)
				begin
					STCNT_SM_ps <= ST0;
				end
			else
				begin
					STCNT_SM_ps <= STCNT_SM_ns;
				end
		end

	assign arc_ST0_ST1 = (STCNT_SM_ps == ST0) & sink_sop & sink_valid & in_ready_p0 & srcaddr_insrt_en & preamble_passthru;
	assign arc_ST0_ST3 = (STCNT_SM_ps == ST0) & sink_sop & sink_valid & in_ready_p0 & srcaddr_insrt_en & !preamble_passthru;
	assign arc_ST1_ST2 = (STCNT_SM_ps == ST1) & sink_valid & in_ready_p0;
	assign arc_ST2_ST3 = (STCNT_SM_ps == ST2) & sink_valid & in_ready_p0;
	assign arc_ST3_ST4 = (STCNT_SM_ps == ST3) & sink_valid & in_ready_p0;
	assign arc_ST4_ST5 = (STCNT_SM_ps == ST4) & sink_valid & in_ready_p0;
	assign arc_ST5_ST0 = (STCNT_SM_ps == ST5) & sink_eop & sink_valid & in_ready_p0;

	
	
	always @(*)
        begin
			case(STCNT_SM_ps)  
				ST0:
					if(arc_ST0_ST1)
						begin
							STCNT_SM_ns = ST1;
						end
					else if(arc_ST0_ST3)
						begin
							STCNT_SM_ns = ST3;
						end
					else
						begin
							STCNT_SM_ns = ST0;
						end

				ST1:
					if(arc_ST1_ST2)
						begin
							STCNT_SM_ns = ST2;
						end
					else
						begin
							STCNT_SM_ns = ST1;
						end
						
				ST2:
					if(arc_ST2_ST3)
						begin
							STCNT_SM_ns = ST3;
						end
					else
						begin
							STCNT_SM_ns = ST2;
						end

				ST3:
					if(arc_ST3_ST4)
						begin
							STCNT_SM_ns = ST4;
						end
					else
						begin
							STCNT_SM_ns = ST3;
						end
				ST4:
					if(arc_ST4_ST5)
						begin
							STCNT_SM_ns = ST5;
						end
					else
						begin
							STCNT_SM_ns = ST4;
						end
				ST5:
					if(arc_ST5_ST0)
						begin
							STCNT_SM_ns = ST0;
						end
					else
						begin
							STCNT_SM_ns = ST5;
						end

				default:	STCNT_SM_ns = ST0;		
			endcase    
        end	
		

	// No need to further qualify with srcaddr_insrt_en and preamble_passthru since the state machine
	// has taken the terms into consideration
	// Use present state is OK since the Source Address start at the 2nd data phase of a frame
	always @(*)
        begin
			case(STCNT_SM_ps)

				ST3:
					begin
						int_sink_data[7:0] = srcaddr[39:32];
						int_sink_data[15:8] = srcaddr[47:40];
						int_sink_data[31:16] = sink_data[31:16];
					end
					
				ST4:
					begin
						int_sink_data = srcaddr[31:0];
					end

				default:
					begin
						int_sink_data = sink_data;
					end
			endcase    
        end	
		

	// pipe0 sink interface
	assign in_data_p0 = {sink_error, sink_empty, sink_eop, sink_sop, int_sink_data};
	assign in_valid_p0 = sink_valid;
	assign sink_ready = in_ready_p0;

	// pipe0 source interface
	assign src_data = out_data_p0[TXDATAWIDTH-1:0]; 
	assign src_sop = out_data_p0[TXDATAWIDTH];
	assign src_eop = out_data_p0[TXDATAWIDTH+1];
	assign src_empty = out_data_p0[(TXEMPTYWIDTH-1+TXDATAWIDTH+2):(TXDATAWIDTH+2)];
	assign src_error = out_data_p0[(TXSRCERRWIDTH-1+TXEMPTYWIDTH-1+TXDATAWIDTH+3):(TXEMPTYWIDTH-1+TXDATAWIDTH+3)];
	assign src_valid = out_valid_p0;
	assign out_ready_p0 = src_ready;
	
	
	// This pipe is probably not required but included to improve Fmax.
    alt_em10g32_pipeline_base #(
        .SYMBOLS_PER_BEAT(1),
        .BITS_PER_SYMBOL(TXSRCERRWIDTH+TXEMPTYWIDTH+TXDATAWIDTH+2),
        .PIPELINE_READY(PIPELINE_READY)
    ) pream_st_pl_inst (
        .clk        (clk),
        .reset_n    (rst_n),
        .in_ready   (in_ready_p0),
        .in_valid   (in_valid_p0),
        .in_data    (in_data_p0),
        .out_ready  (out_ready_p0),
        .out_valid  (out_valid_p0),
        .out_data   (out_data_p0)
    );

	
endmodule

