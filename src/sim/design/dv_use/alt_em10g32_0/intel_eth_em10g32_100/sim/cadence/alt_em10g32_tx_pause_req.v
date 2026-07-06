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
// Module: Altera Ethernet MAC 32bit TX st pause request
//
// Description: 
//  Handles XON and XOFF pause request from client
//
// Parameter: 
//  * TXDATAWIDTH   = 32
//
// Control:
//  * pause_ctrl_sink_data[0]       = XON
//  * pause_ctrl_sink_data[1]       = XOFF
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_pause_req (

    // Clock and reset
    input wire clk,
    input wire rst_n,

    input wire          xoff_holdpq_en,
    input wire [15:0]   xoff_holdpq,
	
	// Outside logic needs to make sure sink_xon_req, sink_xoff_req are mutually exclusive
    input wire		    sink_xon_req, 
	input wire 		    sink_xoff_req,
    input wire			sink_xonxoff_done,

	output wire			src_xon_req_pulse,
	output wire			src_xoff_req_pulse,
	output wire			src_xonxoff_req_pulse,
	output wire			src_xon_req_lvl,
	output wire			src_xoff_req_lvl,
	output wire			src_xonxoff_req_lvl
	
);


	reg	xon_req_pulse_i;
	reg	xoff_req_pulse_i;
	reg	xonxoff_req_pulse_i;
	reg	xon_req_lvl_i;
	reg	xoff_req_lvl_i;
	reg	xonxoff_req_lvl_i; 
	
	// XON, XOFF request state machine
	localparam			XIDLE			= 2'b00;
	localparam			XON				= 2'b01;
	localparam			XOFF			= 2'b10;
	localparam			XOFFHLD			= 2'b11;

	
	reg	[1:0]			XONXOFF_SM_ps;
	reg	[1:0]			XONXOFF_SM_ns;
	
	wire				arc_XIDLE_XON;
	wire				arc_XIDLE_XOFF;
	wire				arc_XON_XOFF;
	wire				arc_XON_XIDLE;
	wire				arc_XOFF_XON;
	wire				arc_XOFF_XIDLE;
	wire				arc_XOFF_XOFFHLD;
	wire				arc_XOFFHLD_XON;
	wire				arc_XOFFHLD_XOFF;
	wire				arc_XOFFHLD_XIDLE;

	// internal wires, registers
					
	reg	holdoff_cnt_en;
	wire				holdoff_cnt_ld;
	reg	holdoff_cnt_exp;
	wire				hold_xoff;
	reg [19:0]			holdoff_cnt_nxt;
	reg [19:0]			holdoff_cnt;
	wire [19:0]			holdoff_pq_init;

	/*
	reg [3:0]			pqcnt_nxt;
	reg [3:0]			pqcnt;
	wire				pqcnt_en;
	wire				pqcnt_ld;

	wire				holdoff_cnt_B0_ld;
	wire				holdoff_cnt_B1_ld;
	wire				holdoff_cnt_B2_ld;
	wire				holdoff_cnt_B3_ld;
	wire				holdoff_cnt_B4_ld;
	wire				holdoff_cnt_B0_en;
	wire				holdoff_cnt_B1_en;
	wire				holdoff_cnt_B2_en;
	wire				holdoff_cnt_B3_en;
	wire				holdoff_cnt_B4_en;
	reg					holdoff_cnt_B0_exp;
	reg					holdoff_cnt_B1_exp;
	reg					holdoff_cnt_B2_exp;
	reg					holdoff_cnt_B3_exp;
	reg					holdoff_cnt_B4_exp;
	reg [3:0]			holdoff_cnt_B0_nxt;
	reg [3:0]			holdoff_cnt_B1_nxt;
	reg [3:0]			holdoff_cnt_B2_nxt;
	reg [3:0]			holdoff_cnt_B3_nxt;
	reg [3:0]			holdoff_cnt_B4_nxt;
	reg [3:0]			holdoff_cnt_B0;
	reg [3:0]			holdoff_cnt_B1;
	reg [3:0]			holdoff_cnt_B2;
	reg [3:0]			holdoff_cnt_B3;	
	reg [3:0]			holdoff_cnt_B4;	
	*/
	
	
	//assign holdoff_pq_init = xoff_holdpq;
	assign holdoff_pq_init = {xoff_holdpq, 4'b0000};
		
	
	// ------------------------------------------------------------------------
	// XON, XOFF triggering state machine
	// ------------------------------------------------------------------------
    
    // SYNC_RESET
	always @(posedge clk)
        begin
			if(!rst_n)
				begin
					XONXOFF_SM_ps <= XIDLE;
				end
			else
				begin
					XONXOFF_SM_ps <= XONXOFF_SM_ns;
				end
		end
	
	
	/*
	assign arc_XIDLE_XOFF = (XONXOFF_SM_ps == XIDLE) & sink_xonxoff_req & !sink_xon_xoffb;
	assign arc_XIDLE_XON = (XONXOFF_SM_ps == XIDLE) & sink_xonxoff_req & sink_xon_xoffb;
	assign arc_XON_XIDLE = (XONXOFF_SM_ps == XON) & sink_xonxoff_done & !sink_xonxoff_req;
	assign arc_XON_XOFF = (XONXOFF_SM_ps == XON) & sink_xonxoff_done & sink_xonxoff_req & !sink_xon_xoffb;
	assign arc_XOFF_XIDLE = (XONXOFF_SM_ps == XOFF) & sink_xonxoff_done & !sink_xonxoff_req;
	assign arc_XOFF_XON = (XONXOFF_SM_ps == XOFF) & sink_xonxoff_done & sink_xonxoff_req & sink_xon_xoffb;
	assign arc_XOFF_XOFFHLD = (XONXOFF_SM_ps == XOFF) & sink_xonxoff_done & sink_xonxoff_req & !sink_xon_xoffb & hold_xoff;
	assign arc_XOFFHLD_XON = (XONXOFF_SM_ps == XOFFHLD) & sink_xonxoff_req & sink_xon_xoffb;
	assign arc_XOFFHLD_XOFF = (XONXOFF_SM_ps == XOFFHLD) & sink_xonxoff_req & !sink_xon_xoffb & !hold_xoff;
	// sink_xon_xoffb should not assert 1 when sink_xonxoff_req is 0. If it does, force s/m back to 0
	assign arc_XOFFHLD_XIDLE = (XONXOFF_SM_ps == XOFFHLD) & !sink_xonxoff_req & (sink_xon_xoffb | !hold_xoff);
	*/

	///*
	assign arc_XIDLE_XOFF = (XONXOFF_SM_ps == XIDLE) & !sink_xon_req & sink_xoff_req;
	assign arc_XIDLE_XON = (XONXOFF_SM_ps == XIDLE) & sink_xon_req & !sink_xoff_req;
	assign arc_XON_XIDLE = (XONXOFF_SM_ps == XON) & sink_xonxoff_done & !(sink_xon_req ^ sink_xoff_req);
	assign arc_XON_XOFF = (XONXOFF_SM_ps == XON) & sink_xonxoff_done & !sink_xon_req & sink_xoff_req;
	// assign arc_XOFF_XIDLE = (XONXOFF_SM_ps == XOFF) & sink_xonxoff_done & !(sink_xon_req ^ sink_xoff_req);
	assign arc_XOFF_XIDLE = (XONXOFF_SM_ps == XOFF) & sink_xonxoff_done & ((sink_xon_req & sink_xoff_req) || !(hold_xoff & sink_xon_req & sink_xoff_req));
	assign arc_XOFF_XON = (XONXOFF_SM_ps == XOFF) & sink_xonxoff_done & sink_xon_req & !sink_xoff_req;
	//assign arc_XOFF_XOFFHLD = (XONXOFF_SM_ps == XOFF) & sink_xonxoff_done & !sink_xon_req & sink_xoff_req & hold_xoff;
	assign arc_XOFF_XOFFHLD = (XONXOFF_SM_ps == XOFF) & sink_xonxoff_done & !sink_xon_req & hold_xoff;
	assign arc_XOFFHLD_XON = (XONXOFF_SM_ps == XOFFHLD) & sink_xon_req & !sink_xoff_req;
	assign arc_XOFFHLD_XOFF = 1'b0;
	assign arc_XOFFHLD_XIDLE = (XONXOFF_SM_ps == XOFFHLD) & !(sink_xon_req & !sink_xoff_req) & !hold_xoff;
	//assign arc_XOFFHLD_XOFF = (XONXOFF_SM_ps == XOFFHLD) & !sink_xon_req & sink_xoff_req & !hold_xoff;
	//assign arc_XOFFHLD_XIDLE = (XONXOFF_SM_ps == XOFFHLD) & !(sink_xon_req ^ sink_xoff_req) & !hold_xoff;
	//*/
	
	
	always @(*)
        begin
			case(XONXOFF_SM_ps)  
				XIDLE:
					if(arc_XIDLE_XOFF)
						begin
							XONXOFF_SM_ns = XOFF;
						end
					else if (arc_XIDLE_XON)
						begin
							XONXOFF_SM_ns = XON;
						end
					else
						begin
							XONXOFF_SM_ns = XIDLE;
						end

				XON:
					if(arc_XON_XIDLE)
						begin
							XONXOFF_SM_ns = XIDLE;
						end
					else if (arc_XON_XOFF)
						begin
							XONXOFF_SM_ns = XOFF;
						end
					else
						begin
							XONXOFF_SM_ns = XON;
						end
						
				XOFF:
					if (arc_XOFF_XOFFHLD)
						begin
							XONXOFF_SM_ns = XOFFHLD;
						end
					else if (arc_XOFF_XIDLE)
						begin
							XONXOFF_SM_ns = XIDLE;
						end
					else if(arc_XOFF_XON)
						begin
							XONXOFF_SM_ns = XON;
						end
					else
						begin
							XONXOFF_SM_ns = XOFF;
						end
						
				XOFFHLD:
					if(arc_XOFFHLD_XIDLE)
						begin
							XONXOFF_SM_ns = XIDLE;
						end
					else if(arc_XOFFHLD_XOFF)
						begin
							XONXOFF_SM_ns = XOFF;
						end
					else if(arc_XOFFHLD_XON)
						begin
							XONXOFF_SM_ns = XON;
						end
					else
						begin
							XONXOFF_SM_ns = XOFFHLD;
						end

				default:	XONXOFF_SM_ns = XIDLE;		
			endcase    
        end	

	
    // NON_RESETABLE FLOPS
	always @(posedge clk)
        begin
			xon_req_pulse_i <= arc_XIDLE_XON | arc_XOFF_XON | arc_XOFFHLD_XON;
			xoff_req_pulse_i <= arc_XIDLE_XOFF | arc_XON_XOFF | arc_XOFFHLD_XOFF;
			xonxoff_req_pulse_i <= (arc_XIDLE_XON | arc_XOFF_XON | arc_XOFFHLD_XON) | (arc_XIDLE_XOFF | arc_XON_XOFF | arc_XOFFHLD_XOFF);
			
			xon_req_lvl_i <= (XONXOFF_SM_ns == XON);
			xoff_req_lvl_i <= (XONXOFF_SM_ns == XOFF);
			xonxoff_req_lvl_i <= (XONXOFF_SM_ns == XON) | (XONXOFF_SM_ns == XOFF);
		end

	assign src_xon_req_pulse = xon_req_pulse_i;
	assign src_xoff_req_pulse = xoff_req_pulse_i;
	assign src_xonxoff_req_pulse = xonxoff_req_pulse_i;
	assign src_xon_req_lvl = xon_req_lvl_i;
	assign src_xoff_req_lvl = xoff_req_lvl_i;
	assign src_xonxoff_req_lvl = xonxoff_req_lvl_i;
		
		
	// Counting logic to determine back-to-back XOFF duration
	assign holdoff_cnt_ld = xoff_req_pulse_i;
	//assign holdoff_cnt_ld = xoff_req_lvl_i;
	
	
	always @(*)
		begin
			case ({holdoff_cnt_ld, holdoff_cnt_en})
				2'b11:	holdoff_cnt_nxt = holdoff_pq_init;
				2'b10:	holdoff_cnt_nxt = holdoff_pq_init;
				2'b01:	holdoff_cnt_nxt = holdoff_cnt - 1'd1;
				2'b00:	holdoff_cnt_nxt = holdoff_cnt;
				default: holdoff_cnt_nxt = 20'b0;
			endcase
			
		end
	
    // SYNC_RESET FLOPS	
	always @(posedge clk)
        begin
			if(!rst_n)
				begin
					holdoff_cnt_en <= 1'b0;
					holdoff_cnt <= 20'b0;
					holdoff_cnt_exp <= 1'b0;
					
					//holdoff_cnt_B0_exp <= 1'b0;
					//holdoff_cnt_B1_exp <= 1'b0;
					//holdoff_cnt_B2_exp <= 1'b0;
					//holdoff_cnt_B3_exp <= 1'b0;
					//holdoff_cnt_B4_exp <= 1'b0;					
				end
			else
				begin
					holdoff_cnt_en <= (XONXOFF_SM_ns == XOFFHLD);
					holdoff_cnt <= holdoff_cnt_nxt;
					
					// Use present state instead of next to improve resource and Fmax
					// with the assumption it is OK to hold the next consecutive XOFF by 1 addtional clock.
					// In the case of no data transmission but only pause frames, 1 additional clock shouldn't be visible
					// on XGMII due to IPG
					// In the case of data and pause frames both compete for transmission, it doesn't matter since
					// the pause frame data frames may go through regardless of whether there is 1 additional clock.
					// In the case of pause quanta equal 0, the 1 additional clock is moot as holdoff_cnt_exp is always 1.
					holdoff_cnt_exp <= (holdoff_cnt == 0);
					
					//holdoff_cnt_B0_exp <= (holdoff_cnt[3:0] == 0);
					//holdoff_cnt_B1_exp <= (holdoff_cnt[7:4] == 0);
					//holdoff_cnt_B2_exp <= (holdoff_cnt[11:8] == 0);
					//holdoff_cnt_B3_exp <= (holdoff_cnt[15:12] == 0);
					//holdoff_cnt_B4_exp <= (holdoff_cnt[19:16] == 0);
					
				end
		end	

	assign hold_xoff = !holdoff_cnt_exp & xoff_holdpq_en;
	
	
	
	
	//assign hold_xoff = !(holdoff_cnt_B0_exp & holdoff_cnt_B1_exp & holdoff_cnt_B2_exp & holdoff_cnt_B3_exp & holdoff_cnt_B4_exp) & xoff_holdpq_en;
	
	/*
	assign pqcnt_ld = 1'b0;
	assign pqcnt_en = !holdoff_cnt_exp;
	
	always @(*)
		begin
			case ({pqcnt_ld, pqcnt_en})
				2'b11:	pqcnt_nxt = 4'b0000;
				2'b10:	pqcnt_nxt = 4'b0000;
				2'b01:	pqcnt_nxt = pqcnt - 4'b0001;
				2'b00:	pqcnt_nxt = pqcnt;
				default: pqcnt_nxt = 4'bXXXX;
			endcase
		end

	always @(posedge clk or negedge rst_n)
        begin
			if(!rst_n)
				begin
					pqcnt <= 1'b0;	
				end
			else
				begin
					pqcnt <= pqcnt_nxt;
				end
			end
	
	*/
	
	/*	
	assign holdoff_cnt_B0_en = holdoff_cnt_en;
	assign holdoff_cnt_B1_en = holdoff_cnt_B0_exp;
	assign holdoff_cnt_B2_en = holdoff_cnt_B1_exp;
	assign holdoff_cnt_B3_en = holdoff_cnt_B2_exp;
	assign holdoff_cnt_B4_en = holdoff_cnt_B3_exp;
	assign holdoff_cnt_B0_ld = holdoff_cnt_ld;
	assign holdoff_cnt_B1_ld = holdoff_cnt_ld;
	assign holdoff_cnt_B2_ld = holdoff_cnt_ld;
	assign holdoff_cnt_B3_ld = holdoff_cnt_ld;
	assign holdoff_cnt_B4_ld = holdoff_cnt_ld;
	
	always @(*)
		begin
			case ({holdoff_cnt_B0_ld, holdoff_cnt_B0_en})
				2'b11:	holdoff_cnt_B0_nxt = holdoff_pq_init[3:0];
				2'b10:	holdoff_cnt_B0_nxt = holdoff_pq_init[3:0];
				2'b01:	holdoff_cnt_B0_nxt = holdoff_cnt_B0 - 4'd1;
				2'b00:	holdoff_cnt_B0_nxt = holdoff_cnt_B0;
				default: holdoff_cnt_B0_nxt = 4'bX;
			endcase
			
			case ({holdoff_cnt_B1_ld, holdoff_cnt_B1_en})
				2'b11:	holdoff_cnt_B1_nxt = holdoff_pq_init[7:4];
				2'b10:	holdoff_cnt_B1_nxt = holdoff_pq_init[7:4];
				2'b01:	holdoff_cnt_B1_nxt = holdoff_cnt_B1 - 4'd1;
				2'b00:	holdoff_cnt_B1_nxt = holdoff_cnt_B1;
				default: holdoff_cnt_B1_nxt = 4'bX;
			endcase
	
			case ({holdoff_cnt_B2_ld, holdoff_cnt_B2_en})
				2'b11:	holdoff_cnt_B2_nxt = holdoff_pq_init[11:8];
				2'b10:	holdoff_cnt_B2_nxt = holdoff_pq_init[11:8];
				2'b01:	holdoff_cnt_B2_nxt = holdoff_cnt_B2 - 4'd1;
				2'b00:	holdoff_cnt_B2_nxt = holdoff_cnt_B2;
				default: holdoff_cnt_B2_nxt = 4'bX;
			endcase
			
			case ({holdoff_cnt_B3_ld, holdoff_cnt_B3_en})
				2'b11:	holdoff_cnt_B3_nxt = holdoff_pq_init[15:12];
				2'b10:	holdoff_cnt_B3_nxt = holdoff_pq_init[15:12];
				2'b01:	holdoff_cnt_B3_nxt = holdoff_cnt_B3 - 4'd1;
				2'b00:	holdoff_cnt_B3_nxt = holdoff_cnt_B3;
				default: holdoff_cnt_B3_nxt = 4'bX;
			endcase
			
			case ({holdoff_cnt_B4_ld, holdoff_cnt_B4_en})
				2'b11:	holdoff_cnt_B4_nxt = holdoff_pq_init[19:16];
				2'b10:	holdoff_cnt_B4_nxt = holdoff_pq_init[19:16];
				2'b01:	holdoff_cnt_B4_nxt = holdoff_cnt_B4 - 4'd1;
				2'b00:	holdoff_cnt_B4_nxt = holdoff_cnt_B4;
				default: holdoff_cnt_B4_nxt = 4'bX;
			endcase
		end
	
	always @(posedge clk or negedge rst_n)
        begin
			if(!rst_n)
				begin
					holdoff_cnt_en <= 1'b0;
						
					holdoff_cnt_B0_exp <= 1'b0;
					holdoff_cnt_B1_exp <= 1'b0;
					holdoff_cnt_B2_exp <= 1'b0;
					holdoff_cnt_B3_exp <= 1'b0;
					holdoff_cnt_B4_exp <= 1'b0;
					
					holdoff_cnt_B0 <= 4'b0;
					holdoff_cnt_B1 <= 4'b0;
					holdoff_cnt_B2 <= 4'b0;
					holdoff_cnt_B3 <= 4'b0;
					holdoff_cnt_B4 <= 4'b0;
				end
			else
				begin
					holdoff_cnt_en <= ;

					holdoff_cnt_B0_exp <= (holdoff_cnt_B0_nxt == 0);
					holdoff_cnt_B1_exp <= (holdoff_cnt_B1_nxt == 0);
					holdoff_cnt_B2_exp <= (holdoff_cnt_B2_nxt == 0);
					holdoff_cnt_B3_exp <= (holdoff_cnt_B3_nxt == 0);
					holdoff_cnt_B4_exp <= (holdoff_cnt_B4_nxt == 0);
					
					holdoff_cnt_B0 <= holdoff_cnt_B0_nxt;
					holdoff_cnt_B1 <= holdoff_cnt_B1_nxt;
					holdoff_cnt_B2 <= holdoff_cnt_B2_nxt;
					holdoff_cnt_B3 <= holdoff_cnt_B3_nxt;
					holdoff_cnt_B4 <= holdoff_cnt_B4_nxt;
				end
		end	
		
	//assign hold_xoff = |xoff_holdpq[7:0]; 
	assign hold_xoff = !(holdoff_cnt_B0_exp & holdoff_cnt_B1_exp & holdoff_cnt_B2_exp & holdoff_cnt_B3_exp & holdoff_cnt_B4_exp) & xoff_holdpq_en;
	
	*/
	
endmodule

