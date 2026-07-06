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
// Module: Altera Ethernet MAC 32-bit TX Data Frame Generator
//
// Description: 
//  * Generates the following frames:
//      - Basic/Traditional frames of 60-1514 bytes each excluding the 4-byte FCS
//      - VLAN frames of 60-1518 bytes each excluding the 4-byte FCS
//      - Stacked VLAN (SVLAN) frames of 60-1522 bytes each excluding the 4-byte FCS
//  * if enabled, padding zero's to the payload field if the frame from the MAC client Avalon data sink interface is less than 60 bytes.
//  * if enabled, replacing Source Address field in the frame from the MAC client Avalon data sink interface
//  * if in preamble pass-through mode, make sure the first 8 bytes of a frame from the MAC client Avalon data sink interface are ignored
//  * back-pressuring the MAC client/user when it is not ready to accept further data bytes
//  * handling of MAC client/user data underflow error
//
// Parameter: 
//  * FFDEPTH = 6 FIFO depth
//  * FULLWTRMRK = 4 Full watermark
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_data_frm_gen #(
    parameter TXDATAWIDTH       = 32,
    parameter TXEMPTYWIDTH      = 2,
    parameter TXSINKERRWIDTH    = 1,
    parameter TXSRCERRWIDTH     = 2,

    parameter FFDEPTH           = 6,
    parameter FULLWTRMRK        = 4,

    parameter DEBUG             = 0
) (
	// Clock and reset
	input wire						clk,
	input wire						rst_n,

	// CSR control path
	input wire						csr_tx_mac_sa_ovrd_en,
	input wire [47:0]				csr_tx_mac_sa,
	input wire						csr_tx_preamble_passthru,
	input wire						csr_tx_pad_insrt_en,
	output reg						csr_tx_backpressure_status,

	// Av-ST sink data path
	input wire						frm_sink_sop,
	input wire						frm_sink_eop,
	input wire						frm_sink_valid,
	input wire [TXDATAWIDTH-1:0]	frm_sink_data,
	input wire [TXEMPTYWIDTH-1:0]	frm_sink_empty,
	input wire [TXSINKERRWIDTH-1:0]	frm_sink_error,

	output wire						frm_sink_ready,

	// Av-ST source data path
	output wire						frm2mx_normfrm_sop,
	output wire						frm2mx_normfrm_eop,
	output wire						frm2mx_normfrm_valid,
	output wire [TXDATAWIDTH-1:0]	frm2mx_normfrm_data,
	output wire [TXEMPTYWIDTH-1:0]	frm2mx_normfrm_empty,
	output wire [TXSRCERRWIDTH-1:0]	frm2mx_normfrm_error,
	
	input wire						mx2frm_normfrm_ready,

	// Flow control
	input wire						flc2dataframe_ready,
	output wire						flc2dataframe_valid,

	// To stat
	output reg						tx_undrflw_pulse,
    
    // status to report packet in progress
    output reg                      tx_packet_in_progress_data_frm,
	
	// Debug
	output reg						dbg_tx_data_frm_gen_fifo_overflow
	//output reg		  dbg_tx_data_frm_gen_fifo_underflow
);

	
	localparam											IDLE = 3'b000;
	localparam											PYLD  = 3'b001;
	localparam											PAD = 3'b010;
	localparam											PREAM0 = 3'b011;
	localparam											PREAM1 = 3'b100;

	wire												arc_IDLE_PAD; 
	wire												arc_IDLE_PYLD;
	wire												arc_IDLE_PREAM0;
	wire												arc_PYLD_PAD;
	wire												arc_PYLD_IDLE;
	wire												arc_PAD_IDLE; 
	wire												arc_PREAM0_PAD;
	wire												arc_PREAM0_PREAM1;
	wire												arc_PREAM1_PAD;
	wire												arc_PREAM1_PYLD;
	
	reg [2:0]											ING_CTRL_SM_ns;
	reg [2:0]											ING_CTRL_SM_ps;
	
	reg									                pyld_state;
	reg									                idle_state;
	reg									                pad_state;

	
	localparam											MINSPPT_FRAMESIZE = 8; // clock cyles = 8 * 4 = 32 bytes 

	reg [3:0]											mindphasecnt;
	reg [3:0]											mindphasecnt_nxt;
	wire[3:0]											mindphasecnt_init;
	wire												mindphasecnt_ld;	 
	wire												mindphasecnt_en1; 
	wire												mindphasecnt_en2;
	wire												mindphasecnt_en; 
	
	wire												wait_pq_expire;

	reg									                mindphcnt_met;
	wire												mindphcnt_met_rise;
	reg									                minspptfrmsz_met;
	reg													dphasecnt_is13_f1;
	
	wire [TXSRCERRWIDTH+TXEMPTYWIDTH+TXDATAWIDTH+1:0]	in_data_p0;
	wire												in_valid_p0;
	wire												in_ready_p0;
	wire [TXSRCERRWIDTH+TXEMPTYWIDTH+TXDATAWIDTH+1:0]	out_data_p0;
	wire												out_valid_p0;
	wire												out_ready_p0;

	
	// Internal wires and regs
	wire [TXDATAWIDTH-1:0]								int_sink_data;
	
	wire												int_sop;
	wire												int_eop;
	wire [TXEMPTYWIDTH-1:0]								int_emp;
	wire [TXSRCERRWIDTH-1:0]							int_err;
	reg													int_err_bit1_f1;

	/*
	reg													user_err_flg;
	reg													udrflw_err_flg;
	reg													minsppt_frmsz_err_flg;
	*/
	
	
	wire	user_err;
	wire	udrflw_err;
	reg		minsppt_frmsz_err;
	reg		hold_after_packet;
	wire	[1:0]src_error;
	reg		[1:0]hold_error;
	reg		hold_mindphcnt_met_rise;
    
	
	
	
	//------------------------------------------------------------------------
	// State Machine Control
	//-----------------------------------------------------------------------
    // SYNC_RESET FLOPS
    always @(posedge clk)
		begin
			if (!rst_n)
				begin
					ING_CTRL_SM_ps <= IDLE;
					
					idle_state <= 1'b1;
					pyld_state <= 1'b0;
					pad_state <= 1'b0;
				end
			else
				begin
					ING_CTRL_SM_ps <= ING_CTRL_SM_ns;
					
					idle_state <= (ING_CTRL_SM_ns == IDLE);
					pyld_state <= (ING_CTRL_SM_ns == PYLD);
					pad_state <= (ING_CTRL_SM_ns == PAD);
				end
		end
	
	always @(*) begin
		case (ING_CTRL_SM_ps)
			IDLE:
				if (arc_IDLE_PREAM0)
					begin
						ING_CTRL_SM_ns = PREAM0;
					end
				else if (arc_IDLE_PYLD) 
					begin
						ING_CTRL_SM_ns = PYLD;
					end
				else if (arc_IDLE_PAD) 
					begin
						ING_CTRL_SM_ns = PAD;
					end
				else
					begin
						ING_CTRL_SM_ns = IDLE;
					end
			PYLD:
				if (arc_PYLD_PAD)
					begin
						ING_CTRL_SM_ns = PAD;
					end
				else if (arc_PYLD_IDLE)
					begin
						ING_CTRL_SM_ns = IDLE;
					end
				else
					begin
						ING_CTRL_SM_ns = PYLD;
					end
			
			PAD:
				if (arc_PAD_IDLE)
					begin
						ING_CTRL_SM_ns = IDLE;
					end
				else
					begin
						ING_CTRL_SM_ns = PAD;
					end
					
			PREAM0:
				if (arc_PREAM0_PREAM1)
					begin
						ING_CTRL_SM_ns = PREAM1;
					end
				else if (arc_PREAM0_PAD)
					begin
						ING_CTRL_SM_ns = PAD;
					end
			
				else
					begin
						ING_CTRL_SM_ns = PREAM0;
					end

			PREAM1:
				if (arc_PREAM1_PYLD)
					begin
						ING_CTRL_SM_ns = PYLD;
					end
				else if (arc_PREAM1_PAD)
					begin
						ING_CTRL_SM_ns = PAD;
					end
			
				else
					begin
						ING_CTRL_SM_ns = PREAM1;
					end
					
			default: ING_CTRL_SM_ns = IDLE;
		endcase
	end

	// ing_ctrl_sm arcs
	// mindphcnt_met and minspptfrmsz_met must be '0' if not in IDLE state
	assign arc_IDLE_PREAM0 = (ING_CTRL_SM_ps == IDLE) & (!wait_pq_expire & frm_sink_sop & frm_sink_valid & in_ready_p0 & !frm_sink_eop & csr_tx_preamble_passthru);
	assign arc_IDLE_PYLD = (ING_CTRL_SM_ps == IDLE) & (!wait_pq_expire & frm_sink_sop & frm_sink_valid & in_ready_p0 & !frm_sink_eop & !csr_tx_preamble_passthru);
	assign arc_IDLE_PAD = (ING_CTRL_SM_ps == IDLE) & (!wait_pq_expire & frm_sink_sop & frm_sink_valid & in_ready_p0 & frm_sink_eop); 
	assign arc_PREAM0_PAD  = (ING_CTRL_SM_ps == PREAM0) & ((!frm_sink_valid & in_ready_p0) | (frm_sink_valid & in_ready_p0 & frm_sink_eop));
	assign arc_PREAM0_PREAM1 = (ING_CTRL_SM_ps == PREAM0) & (frm_sink_valid & in_ready_p0 & !frm_sink_eop);
	assign arc_PREAM1_PAD = (ING_CTRL_SM_ps == PREAM1) & ((!frm_sink_valid & in_ready_p0) | (frm_sink_valid & in_ready_p0 & frm_sink_eop));
	assign arc_PREAM1_PYLD = (ING_CTRL_SM_ps == PREAM1) & (frm_sink_valid & in_ready_p0 & !frm_sink_eop);
	assign arc_PYLD_PAD	= (ING_CTRL_SM_ps == PYLD) & ((((csr_tx_pad_insrt_en & !mindphcnt_met) | !minspptfrmsz_met) & frm_sink_valid & in_ready_p0 & frm_sink_eop) | (!frm_sink_valid & in_ready_p0 & !mindphcnt_met));
	assign arc_PYLD_IDLE = (ING_CTRL_SM_ps == PYLD) & ((((!csr_tx_pad_insrt_en & minspptfrmsz_met) | (mindphcnt_met & minspptfrmsz_met)) & frm_sink_valid & in_ready_p0 & frm_sink_eop) | (!frm_sink_valid & in_ready_p0 & mindphcnt_met));
	assign arc_PAD_IDLE = (ING_CTRL_SM_ps == PAD) & mindphcnt_met & in_ready_p0;

		
	// ing_ctrl_sm output
	assign flc2dataframe_valid = !idle_state; 



	//------------------------------------------------------------------------
	// Minimum data phase count
	//------------------------------------------------------------------------
	// CRC disable with padding enable is not supported.  So, there is no need to have a different initial value.
	// Load to '1' instead since we are using present state to improve Fmax. Otherwise, need to reduce the expected
	// expiration count to by 1.
	assign mindphasecnt_init = 4'd1;
	assign mindphasecnt_ld  = idle_state; //arc_IDLE_PAD | arc_IDLE_PYLD | arc_IDLE_PREAM0;
	assign mindphasecnt_en1 = pyld_state & frm_sink_valid & in_ready_p0;
	assign mindphasecnt_en2 = pad_state & in_ready_p0;
	assign mindphasecnt_en  = (mindphasecnt_en1 | mindphasecnt_en2) & !mindphcnt_met;
	
	//assign mindphcnt_met = (mindphasecnt >= 'd14);
	//assign minspptfrmsz_met = (mindphasecnt >= MINSPPT_FRAMESIZE);

	always @(*)
		begin
			case ({mindphasecnt_ld, mindphasecnt_en})
				2'b11:	mindphasecnt_nxt = mindphasecnt_init;
				2'b10:	mindphasecnt_nxt = mindphasecnt_init;
				2'b01:	mindphasecnt_nxt = mindphasecnt + 4'd1;
				2'b00:	mindphasecnt_nxt = mindphasecnt;
				default: mindphasecnt_nxt = mindphasecnt;
			endcase
			
		end

    // SYNC_RESET FLOPS
    // mindphasecnt will no longer reset to 4'd0 but to 4'd1 (mindphasecnt_init). Increase debug difficulty?
    always @(posedge clk)
        begin
            if(!rst_n)
                begin
                    mindphasecnt <= 4'd0;
                    
                    mindphcnt_met <= 1'b0;
                    minspptfrmsz_met <= 1'b0;
                    dphasecnt_is13_f1 <= 1'b0;
                end
            else
                begin
                    mindphasecnt <= mindphasecnt_nxt;
                    
                    mindphcnt_met <= (mindphasecnt_nxt >= 4'd14);
                    minspptfrmsz_met <= (mindphasecnt_nxt >= MINSPPT_FRAMESIZE);            
                    dphasecnt_is13_f1 <= (mindphasecnt == 4'd13);
                end
        end
	
	assign mindphcnt_met_rise = (mindphasecnt >= 4'd14) & dphasecnt_is13_f1;
	
	//------------------------------------------------------------------------
	// Flow control
	//------------------------------------------------------------------------
	assign wait_pq_expire = !flc2dataframe_ready;
	
	
	
	//------------------------------------------------------------------------
	// Padding
	//------------------------------------------------------------------------
	// empty = 1 means the bit[7:0] does not have valid data
	// Use the empty to force the current invalid data to 0 as part of the padding process
	// Note that IEEE specification does not spell out clearly that the padded bytes must be zeros.
	assign int_sink_data[31:24] = pad_state? 8'h0: frm_sink_data [31:24];
	assign int_sink_data[23:16] = (pad_state | (frm_sink_empty > 2))? 8'h0 : frm_sink_data[23:16];
	assign int_sink_data[15:8] = (pad_state | (frm_sink_empty > 1))? 8'h0 : frm_sink_data[15:8];
	assign int_sink_data[7:0] = (pad_state | (frm_sink_empty > 0))? 8'h0 : frm_sink_data[7:0];
		
	
	
	//------------------------------------------------------------------------
	// Other Avalon ST signals
	//------------------------------------------------------------------------
	assign int_sop = arc_IDLE_PAD | arc_IDLE_PREAM0 | arc_IDLE_PYLD;
	assign int_eop = arc_PYLD_IDLE | arc_PAD_IDLE;
	
	// When the minfrmsz is just met, if empty is non-zero, it indicates the actual bytes transferred could be
	// 57, 58 or 59. The state machine won't transition into the PAD state but back to IDLE.  Padding in the case
	// is "automatically" done by the fact empty is non-zero (zero'ing out the invalid bytes). Then, the empty
	// is forced to 0.
	// During backpressure if without hold, mindphcnt_met_rise will be lose by the time arc_PYLD_IDLE assert
	assign int_emp = (arc_PYLD_IDLE & (!(mindphcnt_met_rise | hold_mindphcnt_met_rise) | !csr_tx_pad_insrt_en))? frm_sink_empty: 2'b0;
	
	assign int_err[0] = user_err; //user_err_flg;
	assign int_err[1] = udrflw_err | minsppt_frmsz_err; //udrflw_err_flg | minsppt_frmsz_err_flg;

    // SYNC_RESET FLOPS
	always @(posedge clk)
        begin
			if(!rst_n)
				begin
					int_err_bit1_f1 <= 1'b0;
					minsppt_frmsz_err <= 1'b0;
					hold_after_packet <= 1'b0;
					hold_error <= 2'b0;
					hold_mindphcnt_met_rise <= 1'b0;
				end
			else
				begin
					int_err_bit1_f1 <= int_err[1];
					
					
					hold_mindphcnt_met_rise <= (mindphcnt_met_rise | hold_mindphcnt_met_rise) & !in_ready_p0;
					//hold_mindphcnt_met_rise <= (mindphcnt_met_rise) | (hold_mindphcnt_met_rise & !in_ready_p0);
										 
					
					// It is OK to flop this signal to improve Fmax since the state machine will stay in PAD state for at least 1 clock
					minsppt_frmsz_err <= !csr_tx_pad_insrt_en & (((arc_PYLD_PAD |arc_PYLD_IDLE) & !minspptfrmsz_met) | arc_PREAM0_PAD | arc_PREAM1_PAD | arc_IDLE_PAD);
					//minsppt_frmsz_err <= (arc_PYLD_IDLE & !minspptfrmsz_met) | arc_PREAM0_PAD | arc_PREAM1_PAD | arc_IDLE_PAD;
					//minsppt_frmsz_err <= (hold_after_packet & !minspptfrmsz_met);
					
					if(int_eop )
						begin
						hold_after_packet <= 1'b1;
						end
					else if(int_sop)
						begin
						hold_after_packet <= 1'b0;
						end
					else
						begin
						hold_after_packet <= hold_after_packet;
						end
						
					// if(!idle_state && src_error != 2'b00)	
						// begin
						// hold_error <= src_error; 
						// end
					if(!idle_state && int_err != 2'b00)	
						begin
						hold_error <= int_err; 
						end
					else if(frm2mx_normfrm_eop && frm2mx_normfrm_valid && mx2frm_normfrm_ready)
						begin
						hold_error <= 2'b0;
						end
					else
						begin
						hold_error <= hold_error;
						end
				end
		end	

    // SYNC_RESET FLOPS
    always @(posedge clk)
        begin
            if (!rst_n)
                begin
                   tx_undrflw_pulse <= 1'b0;
                end
            else
                begin
                    tx_undrflw_pulse <= int_err[1] & !int_err_bit1_f1;
                end
    	end	

	
	assign frm2mx_normfrm_error = frm2mx_normfrm_eop?(hold_error | int_err):2'b0;
	assign user_err = (int_sop | !idle_state) & frm_sink_valid & in_ready_p0 & frm_sink_error; 
	// assign udrflw_err = !idle_state & !frm_sink_valid & in_ready_p0;
	assign udrflw_err = (ING_CTRL_SM_ps == PYLD | ING_CTRL_SM_ps == PREAM0 | ING_CTRL_SM_ps == PREAM1) & !frm_sink_valid & in_ready_p0 & !hold_after_packet;
	

	
	//------------------------------------------------------------------------
	// Pipeline Stage
	//------------------------------------------------------------------------
	
	// pipe0 sink interface
	//assign in_data_p0 = {frm_sink_error, frm_sink_empty, frm_sink_eop, frm_sink_sop, int_sink_data};
	assign in_data_p0 = {int_err, int_emp, int_eop, int_sop, int_sink_data};
	
	// Strictly speaking, should be qualified with frm_sink_ready.  Without is OK to improve Fmax, but may potentially causing
	// 1 extra data to be written.  This is OK since the data is erroneous to begin with.
	assign in_valid_p0 = arc_IDLE_PREAM0 | arc_IDLE_PYLD | arc_IDLE_PAD | !idle_state;
	
	// wait_pq_expire may be qualified at the pipeline output
	// In the case, the client data will not be stopped at client but internal frame boundary.
	assign frm_sink_ready = !(wait_pq_expire & idle_state) & !pad_state & in_ready_p0 ;
	// assign frm_sink_ready = csr_tx_tsfr_en & !pad_state & in_ready_p0;

	
	/*
	// -- DO NOT USE
	// pipe0 source interface - only if no address replacement
	assign frm2mx_normfrm_data = out_data_p0[TXDATAWIDTH-1:0]; 
	assign frm2mx_normfrm_sop = out_data_p0[TXDATAWIDTH];
	assign frm2mx_normfrm_eop = out_data_p0[TXDATAWIDTH+1];
	assign frm2mx_normfrm_empty = out_data_p0[TXEMPTYWIDTH-1+TXDATAWIDTH+2:TXDATAWIDTH+2];
	assign frm2mx_normfrm_error = out_data_p0[TXSRCERRWIDTH-1+TXEMPTYWIDTH-1+TXDATAWIDTH+3:TXEMPTYWIDTH-1+TXDATAWIDTH+3];
	assign frm2mx_normfrm_valid = out_valid_p0;
	assign out_ready_p0 = mx2frm_normfrm_ready;
	// -- DO NOT USE END
	*/
	
	
    alt_em10g32_pipeline_base #(
        .SYMBOLS_PER_BEAT(1),
        .BITS_PER_SYMBOL(TXSRCERRWIDTH+TXEMPTYWIDTH+TXDATAWIDTH+2),
        .PIPELINE_READY(1)
    ) data_st_pl_inst (
        .clk        (clk),
        .reset_n    (rst_n),
        .in_ready   (in_ready_p0),
        .in_valid   (in_valid_p0),
        .in_data    (in_data_p0),
        .out_ready  (out_ready_p0),
        .out_valid  (out_valid_p0),
        .out_data   (out_data_p0)
    );

	///*

	//------------------------------------------------------------------------
	// Source Address Replacement
	//------------------------------------------------------------------------
	alt_em10g32_tx_srcaddr_inserter #(
		.TXDATAWIDTH(TXDATAWIDTH),
		.TXEMPTYWIDTH(TXEMPTYWIDTH),
		.TXSINKERRWIDTH(TXSRCERRWIDTH),
		.TXSRCERRWIDTH(TXSRCERRWIDTH),
		.PIPELINE_READY(0)
	) tx_srcaddr_inserter	(
		.clk				(clk),
		.rst_n				(rst_n),
		.srcaddr_insrt_en	(csr_tx_mac_sa_ovrd_en),
		.srcaddr			(csr_tx_mac_sa),
		.preamble_passthru	(csr_tx_preamble_passthru),
		.sink_sop			(out_data_p0[TXDATAWIDTH]),
		.sink_valid			(out_valid_p0),
		.sink_ready			(out_ready_p0),
		.sink_data			(out_data_p0[TXDATAWIDTH-1:0]),
		.sink_eop			(out_data_p0[TXDATAWIDTH+1]),
		.sink_empty			(out_data_p0[TXEMPTYWIDTH-1+TXDATAWIDTH+2:TXDATAWIDTH+2]),
		.sink_error			(out_data_p0[TXSRCERRWIDTH-1+TXEMPTYWIDTH+TXDATAWIDTH+2:TXEMPTYWIDTH+TXDATAWIDTH+2]),
		.src_sop			(frm2mx_normfrm_sop),
		.src_valid			(frm2mx_normfrm_valid),
		.src_ready			(mx2frm_normfrm_ready),
		.src_data			(frm2mx_normfrm_data),
		.src_eop			(frm2mx_normfrm_eop),
		.src_empty			(frm2mx_normfrm_empty),
		.src_error			(src_error)		
	);
		
	//*/
	
	//------------------------------------------------------------------------
	// Status
	//------------------------------------------------------------------------
    // NON_RESETABLE FLOPS
    // CSR register might have X before frm_sink_ready is stabilized 
	always @(posedge clk) begin
		csr_tx_backpressure_status <= !frm_sink_ready;
	end

    // those piece of logic is use to keep track packet in progress    
    always @ (posedge clk)
        begin
        if(!rst_n)
            begin
            tx_packet_in_progress_data_frm <= 1'b0;
            end
        else
            begin
            if(ING_CTRL_SM_ns == PYLD || ING_CTRL_SM_ns == PAD || ING_CTRL_SM_ns == PREAM0)
                begin
                tx_packet_in_progress_data_frm <= 1'b1;
                end
            else if(ING_CTRL_SM_ns == IDLE)    
                begin
                tx_packet_in_progress_data_frm <= 1'b0;
                end
            end
        end

	//------------------------------------------------------------------------
	// Debug
	//------------------------------------------------------------------------
	generate
	if (DEBUG) begin : debug
        // NON_RESETABLE FLOPS
		always @(posedge clk) begin
			dbg_tx_data_frm_gen_fifo_overflow <= csr_tx_backpressure_status;
		end
	end
	else begin
        wire constant_dbg_tx_data_frm_gen_fifo_overflow;
        assign constant_dbg_tx_data_frm_gen_fifo_overflow = 1'b0;
		always @(*) begin
			dbg_tx_data_frm_gen_fifo_overflow = constant_dbg_tx_data_frm_gen_fifo_overflow;
		end
	end
	endgenerate
	

endmodule



