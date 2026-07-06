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


// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $File: $
// $Revision: #1 $
// $Date: 2014/10/07 $
// $Author:  $
//-------------------------------------------------------------------------------
// Description: Back-pressure for a few cycles before allowing data to flow through.
// ---------------------------------------------------------------------

`timescale 1 ns / 1 ps

module alt_em10g32_vldpkt_rddly #(
	//parameter WAIT_TRANSFER_COUNT 	= 2,
	parameter SYMBOLS_PER_BEAT  	= 4,
	parameter BITS_PER_SYMBOL   	= 8,
	parameter CHANNEL_WIDTH	 		= 0,
	parameter ERROR_WIDTH	   		= 1,
	parameter USE_PACKETS			= 1,
        parameter SYNC_RESET_N                  = 1 
) (

	clk,
	rst_n,

	csr_vldpkt_minwt,	// Default watermark, when in_lt_rdwtrmark = 0 at valid in_startofpacket
	csr_rdwtrmrk_dis,	// Default = 0; enable read watermark
	in_lt_rdwtrmark,	// 1: more than read watermark
	
	in_startofpacket,
	in_endofpacket,
	in_valid,
	in_ready,
	in_data,
	in_empty,
	in_error,
	in_channel,

	out_startofpacket,
	out_endofpacket,
	out_valid,
	out_ready,
	out_data,
	out_empty,
	out_error,
	out_channel
);
	
	localparam DATA_WIDTH			= SYMBOLS_PER_BEAT * BITS_PER_SYMBOL;
	localparam EMPTY_WIDTH			= log2ceil(SYMBOLS_PER_BEAT);
	localparam PACKET_SIGNALS_WIDTH	= 2 + EMPTY_WIDTH;
	localparam PAYLOAD_WIDTH		= (USE_PACKETS == 1) ?
										  (2 + EMPTY_WIDTH + DATA_WIDTH + ERROR_WIDTH + CHANNEL_WIDTH):
										  (DATA_WIDTH + ERROR_WIDTH + CHANNEL_WIDTH);

	input clk;
	input rst_n;
	input [2:0] csr_vldpkt_minwt;
	input csr_rdwtrmrk_dis;
	input in_lt_rdwtrmark;
	input in_startofpacket;
	input in_endofpacket;
	input in_valid;
	output in_ready;
	input [DATA_WIDTH - 1 : 0] in_data;
	input [((EMPTY_WIDTH > 0)   ? EMPTY_WIDTH - 1   : 0) : 0] in_empty;
	input [((ERROR_WIDTH > 0)   ? ERROR_WIDTH - 1   : 0) : 0] in_error;
	input [((CHANNEL_WIDTH > 0) ? CHANNEL_WIDTH - 1 : 0) : 0] in_channel;

	output out_startofpacket;
	output out_endofpacket;
	output out_valid;
	input out_ready;
	output [DATA_WIDTH - 1 : 0] out_data;
	output [((EMPTY_WIDTH > 0)   ? EMPTY_WIDTH - 1   : 0) : 0] out_empty;
	output [((ERROR_WIDTH > 0)   ? ERROR_WIDTH - 1   : 0) : 0] out_error;
	output [((CHANNEL_WIDTH > 0) ? CHANNEL_WIDTH - 1 : 0) : 0] out_channel;

										  

	wire [PAYLOAD_WIDTH - 1 : 0] in_payload;
	wire [PAYLOAD_WIDTH - 1 : 0] out_payload;
	wire [PACKET_SIGNALS_WIDTH - 1 : 0] in_packet_signals;
	wire [PACKET_SIGNALS_WIDTH - 1 : 0] out_packet_signals;

	// Egress State Machine
	reg [1:0] EG_CTRL_SM_ns;
	reg [1:0] EG_CTRL_SM_ps;
	reg rdytsfr_state;
	localparam IDLE = 2'd0;
	localparam WTTSFR = 2'd1;
	localparam RDYTSFR = 2'd2;
	wire arc_IDLE_WTTSFR;
	wire arc_WTTSFR_RDYTSFR;
	wire arc_RDYTSFR_IDLE;
	wire arc_IDLE_RDYTSFR;
	reg [1:0] wait_tsfr_cnt;
    reg csr_rdwtrmrk_dis_reg;
    
  generate if (SYNC_RESET_N == 1) begin
    always @ (posedge clk)
        begin
        if(!rst_n)
            begin
            csr_rdwtrmrk_dis_reg <= 1'b0;
            end
        else
            begin
            csr_rdwtrmrk_dis_reg <= csr_rdwtrmrk_dis;
            end
        end
  end else begin
    always @ (posedge clk or negedge rst_n)
        begin
        if(!rst_n)
            begin
            csr_rdwtrmrk_dis_reg <= 1'b0;
            end
        else
            begin
            csr_rdwtrmrk_dis_reg <= csr_rdwtrmrk_dis;
            end
        end
  end
  endgenerate

	
	// ---------------------------------------------------------------------
	// Mapping input and output payload signals
	// ---------------------------------------------------------------------
	generate
		if (EMPTY_WIDTH > 0) begin
			assign in_packet_signals = {in_startofpacket, in_endofpacket, in_empty};
			assign {out_startofpacket, out_endofpacket, out_empty} = out_packet_signals;
		end 
		else begin
			assign in_packet_signals = {in_startofpacket, in_endofpacket};
			assign {out_startofpacket, out_endofpacket} = out_packet_signals;
		end
	endgenerate

	generate
		if (USE_PACKETS) begin
			if (ERROR_WIDTH > 0) begin
				if (CHANNEL_WIDTH > 0) begin
					assign in_payload = {in_packet_signals, in_data, in_error, in_channel};
					assign {out_packet_signals, out_data, out_error, out_channel} = out_payload;
				end
				else begin
					assign in_payload = {in_packet_signals, in_data, in_error};
					assign {out_packet_signals, out_data, out_error} = out_payload;
					assign out_channel = 1'b0;
				end
			end
			else begin
				if (CHANNEL_WIDTH > 0) begin
					assign in_payload = {in_packet_signals, in_data, in_channel};
					assign {out_packet_signals, out_data, out_channel} = out_payload;
				end
				else begin
					assign in_payload = {in_packet_signals, in_data};
					assign {out_packet_signals, out_data} = out_payload;
					assign out_channel = 1'b0;
				end
			end
		end
		else begin
			if (ERROR_WIDTH > 0) begin
				if (CHANNEL_WIDTH > 0) begin
					assign in_payload = {in_data, in_error, in_channel};
					assign {out_data, out_error, out_channel} = out_payload;
				end
				else begin
					assign in_payload = {in_data, in_error};
					assign {out_data, out_error} = out_payload;
					assign out_channel = 1'b0;
				end
			end
			else begin
				if (CHANNEL_WIDTH > 0) begin
					assign in_payload = {in_data, in_channel};
					assign {out_data, out_channel} = out_payload;
				end
				else begin
					assign in_payload = in_data;
					assign out_data = out_payload;
					assign out_channel = 1'b0;
				end
			end
			assign out_packet_signals = 'b0;
		end
	endgenerate

	
	// -----------------------------
	// Start Here
	// -----------------------------

	// Passing the payload as is
	assign out_payload = in_payload;

	// Allow the transfer to go through when
	// 1. read watermark is disabled
	// 2. valid entries >= read watermark
	// 3. state machine has not go to idle.  This is to sustain flow when in_lt_rdwtrmark de-asserts towards EOP while there are still valid entries.
	assign out_valid = in_valid && (rdytsfr_state || csr_rdwtrmrk_dis_reg || !in_lt_rdwtrmark); // || (WAIT_TRANSFER_COUNT == 0));
	assign in_ready = out_ready && (rdytsfr_state || csr_rdwtrmrk_dis_reg || !in_lt_rdwtrmark); // || (WAIT_TRANSFER_COUNT == 0));


	// Do clock counting
      generate if (SYNC_RESET_N == 1) begin
	always @(posedge clk)
		begin
			if (!rst_n)
				begin
					wait_tsfr_cnt <= 2'd1;
				end
			else
				begin
					if (EG_CTRL_SM_ps == IDLE)
						begin
							wait_tsfr_cnt <= 2'd1;
						end
					else if (EG_CTRL_SM_ps == WTTSFR)
						begin
							wait_tsfr_cnt <= wait_tsfr_cnt + 2'd1;
						end
				end
		end
      end else begin
	always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					wait_tsfr_cnt <= 2'd1;
				end
			else
				begin
					if (EG_CTRL_SM_ps == IDLE)
						begin
							wait_tsfr_cnt <= 2'd1;
						end
					else if (EG_CTRL_SM_ps == WTTSFR)
						begin
							wait_tsfr_cnt <= wait_tsfr_cnt + 2'd1;
						end
				end
		end
      end
      endgenerate
	

	// Interesting scenario:
	// 1. SOP-EOP in the same clock at 64b AVST
	// When this happens, it is actually OK to straight away drain the FIFO since the current frame is only
	// consisted of 1 data phase.  As such, the pattern of empty status does not impact the frame.  The same
	// control is used though for the following reasons:
	// (a) To simplify design and maximize Fmax
	// (b) It is OK to delay accepting the frame since it is an erroneous frame to begin with
	// assign arc_IDLE_WTTSFR = (EG_CTRL_SM_ps == IDLE) && in_startofpacket && in_valid && !(WAIT_TRANSFER_COUNT == 0);
	// assign arc_WTTSFR_RDYTSFR = (EG_CTRL_SM_ps == WTTSFR) && (wait_tsfr_cnt == WAIT_TRANSFER_COUNT);
	// assign arc_RDYTSFR_IDLE = (EG_CTRL_SM_ps == RDYTSFR) && in_endofpacket && in_valid && out_ready;
	
	assign arc_IDLE_WTTSFR = (EG_CTRL_SM_ps == IDLE) && in_startofpacket && in_valid && in_lt_rdwtrmark && !csr_rdwtrmrk_dis_reg;
	assign arc_IDLE_RDYTSFR = (EG_CTRL_SM_ps == IDLE) && in_startofpacket && in_valid && !in_lt_rdwtrmark && !csr_rdwtrmrk_dis_reg;
	assign arc_WTTSFR_RDYTSFR = (EG_CTRL_SM_ps == WTTSFR) && (wait_tsfr_cnt >= csr_vldpkt_minwt);
	assign arc_RDYTSFR_IDLE = (EG_CTRL_SM_ps == RDYTSFR) && in_endofpacket && in_valid && out_ready;

	
      generate if (SYNC_RESET_N == 1) begin
	always @(posedge clk)
		begin
			if (!rst_n)
				begin
					EG_CTRL_SM_ps <= IDLE;
					rdytsfr_state <= 1'b0;
				end
			else
				begin
					EG_CTRL_SM_ps <= EG_CTRL_SM_ns;
					rdytsfr_state <= (EG_CTRL_SM_ns == RDYTSFR);
				end
		end
      end else begin
	always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					EG_CTRL_SM_ps <= IDLE;
					rdytsfr_state <= 1'b0;
				end
			else
				begin
					EG_CTRL_SM_ps <= EG_CTRL_SM_ns;
					rdytsfr_state <= (EG_CTRL_SM_ns == RDYTSFR);
				end
		end
      end
      endgenerate
	
	always @(*) begin
		case (EG_CTRL_SM_ps)
			IDLE:
				if (arc_IDLE_WTTSFR)
					begin
						EG_CTRL_SM_ns = WTTSFR;
					end
				else if (arc_IDLE_RDYTSFR)
					begin
						EG_CTRL_SM_ns = RDYTSFR;
					end
				else
					begin
						EG_CTRL_SM_ns = IDLE;
					end
			WTTSFR:
				if (arc_WTTSFR_RDYTSFR)
					begin
						EG_CTRL_SM_ns = RDYTSFR;
					end
				else
					begin
						EG_CTRL_SM_ns = WTTSFR;
					end

			RDYTSFR:
				if (arc_RDYTSFR_IDLE)
					begin
						EG_CTRL_SM_ns = IDLE;
					end
				else
					begin
						EG_CTRL_SM_ns = RDYTSFR;
					end

			default: EG_CTRL_SM_ns = IDLE;
		endcase
	end	
	
	

	// --------------------------------------------------
	// Calculates the log2ceil of the input value
	// --------------------------------------------------
	function integer log2ceil;
		input integer val;
		integer i;

		begin
			i = 1;
			log2ceil = 0;

			while (i < val) begin
				log2ceil = log2ceil + 1;
				i = i << 1;
			end
		end
	endfunction

endmodule
