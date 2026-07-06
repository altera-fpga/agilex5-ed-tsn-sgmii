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
// Module: Altera Ethernet MAC 32bit TX Pause Frame Generator
//
// Description: 
//  Generates 60 bytes of pause frame when a request is receive either from Av-ST or CSR
//  The input is expected to hold its value as long as the pause frame generator has yet to generate the request
//  Request will be lost if input changes value before the requested pause frame is generated
//  pause_frm_empty is always zero

// Parameter: 
//  * TXDATAWIDTH   = 32
//
// Control:
//  * csr_tx_pause_xonxoff_ctrl[0]   = XON
//  * csr_tx_pause_xonxoff_ctrl[1]   = XOFF
//  * pause_ctrl_sink_data[0]       = XON
//  * pause_ctrl_sink_data[1]       = XOFF
//
//  * csr_tx_pause_select            = 0 (Av-ST) / 1 (CSR)
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_pause_frm_gen #(
    parameter TXDATAWIDTH   = 32,
    parameter DEBUG         = 0
) (
    // Clock and reset
    input wire								clk,
    input wire								rst_n,

    // CSR control path
    input wire								csr_tx_preamble_passthru,
	input wire [47:0]						csr_tx_mac_sa,
    input wire								csr_tx_tsfr_en_n,
    input wire								csr_tx_pause_en,
    input wire								csr_tx_pause_xonxoff_valid,
    input wire [1:0]						csr_tx_pause_xonxoff_ctrl,
    input wire [15:0]						csr_tx_pause_pq,
    input wire 								csr_tx_pause_select,
    input wire [15:0]						csr_tx_pause_holdoff_pq,
    output reg								csr_tx_pause_status, 

    // Av-ST control path
    input wire [1:0]						pause_ctrl_sink_data,

    // Pause frame data path
    output wire								frm2mx_pausefrm_sop,
    output wire								frm2mx_pausefrm_eop,
    output wire								frm2mx_pausefrm_valid,
    output wire [TXDATAWIDTH-1:0]			frm2mx_pausefrm_data,
    
    input wire								mx2frm_pausefrm_ready,
    
    // status to report packet in progress
    output reg                              tx_packet_in_progress_pause,
    
    // Debug
    output reg								dbg_tx_pause_trans_in_progress
);

// Internal wires and regs
	wire									pause_tsfr_en;
	reg										req;
	reg										xon;
	wire [15:0] 							pq;
	wire									sm_out_sop;
	reg						                sm_out_eop;
	wire									sm_out_valid;
	reg [TXDATAWIDTH-1:0]					sm_out_data;
	
	wire									int_ready;
	wire									pause_frm_src_sop;
	wire									pause_frm_src_eop;
	wire									pause_frm_src_valid;
	wire									pause_frm_src_ready;
	wire [TXDATAWIDTH-1:0]					pause_frm_src_data;
	
	wire [TXDATAWIDTH+1:0]					in_data;
	wire [TXDATAWIDTH+1:0]					out_data;

	reg										tx_pause_select;

	// ****** JH modify start	
	
	reg	[1:0]								st_xonxoff_ctrl;
	//reg									st_xon_xoffb;
	wire									st_final_xonxoff_req;
	wire									st_final_xon_req;
	reg	[1:0]								mm_xonxoff_ctrl;
	//reg									mm_xon_xoffb;
	wire									mm_final_xonxoff_req;
	wire									mm_final_xon_req;
	
	reg						last_frmdat_done;
	reg						frmdat14_state;

	localparam								FRMDAT0		= 4'b0000;	// Default to DA or Preamble
	localparam								FRMDAT1		= 4'b0001;	// DA, SA
	localparam								FRMDAT2		= 4'b0010;	// DA
	localparam								FRMDAT3		= 4'b0011;	// LT, Opcode
	localparam								FRMDAT4		= 4'b0100;	// PQ, 0 (PFC = PQE, PQ0)
	localparam								FRMDAT5		= 4'b0101;	// 0 (PFC = PQ1, PQ2)
	localparam								FRMDAT6		= 4'b0110;	// 0 (PFC = PQ3, PQ4)
	localparam								FRMDAT7		= 4'b0111;	// 0 (PFC = PQ5, PQ6)
	localparam								FRMDAT8		= 4'b1000;	// 0 (PFC = PQ7, 0)
	localparam								FRMDAT9		= 4'b1001;	// 0
	localparam								FRMDAT10	= 4'b1010;	// 0
	localparam								FRMDAT11	= 4'b1011;	// 0
	localparam								FRMDAT12	= 4'b1100;	// 0
	localparam								FRMDAT13	= 4'b1101;	// 0
	localparam								FRMDAT14	= 4'b1110;	// 0
	localparam								FRMGAP		= 4'b1111;	// 0
	
	wire									arc_FRMDAT0_FRMDAT1;
	wire									arc_FRMDAT1_FRMDAT2;
	wire									arc_FRMDAT2_FRMDAT3;
	wire									arc_FRMDAT3_FRMDAT4;
	wire									arc_FRMDAT4_FRMDAT5;
	wire									arc_FRMDAT5_FRMDAT6;
	wire									arc_FRMDAT6_FRMDAT7;
	wire									arc_FRMDAT7_FRMDAT8;
	wire									arc_FRMDAT8_FRMDAT9;
	wire									arc_FRMDAT9_FRMDAT10;
	wire									arc_FRMDAT10_FRMDAT11;
	wire									arc_FRMDAT11_FRMDAT12;
	wire									arc_FRMDAT12_FRMDAT13;
	wire									arc_FRMDAT13_FRMDAT14;
	wire									arc_FRMDAT14_FRMGAP;
	wire									arc_FRMGAP_FRMDAT0;

	reg	[3:0]								PAUSEGEN_SM_ps;
	reg	[3:0]								PAUSEGEN_SM_ns;	
	
	// hold XOFF value. Because XON can only be generated after XFF
	reg		st_hold_xoff;
	
	
    //------------------------------------------------------------------------
    // Input

    //------------------------------------------------------------------------

    // Selector can only be changed during idle
    /*always @(*)
		begin
			tx_pause_select <= csr_tx_pause_select;
        end
	*/
	
    //------------------------------------------------------------------------
    // ST XON XOFF Control
    //------------------------------------------------------------------------
    // SYNC_RESET FLOPS
    always @(posedge clk)
		begin
			if (!rst_n)
				begin
					st_xonxoff_ctrl[1:0] <= 2'b0;
					mm_xonxoff_ctrl[1:0] <= 2'b0;
					st_hold_xoff <= 1'b0;
				end
			else
				begin
					// update when xoff is true. also update when pause tsfr en is true to avoid when back2back xoff xon then xon will be clear
					if (st_xonxoff_ctrl[1])
						begin
						st_hold_xoff <= 1'b1;
						end
					else if (st_xonxoff_ctrl[0] & pause_tsfr_en)	
						begin
						st_hold_xoff <= 1'b0;
						end
					else
						begin
						st_hold_xoff <= st_hold_xoff;
						end 

						
					// ST trigger. Force the control to be 'b00 when pause is not enabled or triggered
					if (pause_tsfr_en & !csr_tx_pause_select & mx2frm_pausefrm_ready)
						begin
							st_xonxoff_ctrl[1] <= (pause_ctrl_sink_data[1:0] == 2'b10);
							st_xonxoff_ctrl[0] <= (pause_ctrl_sink_data[1:0] == 2'b01) & st_hold_xoff;
						end
					else
						begin
							st_xonxoff_ctrl[1:0] <= 2'b0;
						end

					// CSR trigger. Force the control to be 'b00 when pause is not enabled or triggered
					if (csr_tx_pause_xonxoff_valid & pause_tsfr_en & csr_tx_pause_select)
						begin
							mm_xonxoff_ctrl[1] <= (csr_tx_pause_xonxoff_ctrl[1:0] == 2'b10);
							mm_xonxoff_ctrl[0] <= (csr_tx_pause_xonxoff_ctrl[1:0] == 2'b01);
						end
					else
						begin
							mm_xonxoff_ctrl[1:0] <= 2'b0;
						end
				end
		end
						
    alt_em10g32_tx_pause_req
		st_pause_req_inst (
			.clk					(clk),
			.rst_n					(rst_n),
			.xoff_holdpq_en			(1'b1),
			.xoff_holdpq			(csr_tx_pause_holdoff_pq[15:0]),
			.sink_xon_req			(st_xonxoff_ctrl[0]),
			.sink_xoff_req			(st_xonxoff_ctrl[1]),
			.sink_xonxoff_done		(last_frmdat_done),
			.src_xon_req_pulse		(),
			.src_xoff_req_pulse		(),
			.src_xonxoff_req_pulse	(),
			.src_xon_req_lvl		(st_final_xon_req),
			.src_xoff_req_lvl		(),
			.src_xonxoff_req_lvl	(st_final_xonxoff_req)
    );

	
    //------------------------------------------------------------------------
    // CSR XON XOFF Control
    //------------------------------------------------------------------------
	
    // Setting XONXOFF register will only generate a single pause frame.

    alt_em10g32_tx_pause_req
		csr_pause_req_inst (
			.clk					(clk),
			.rst_n					(rst_n),
			.xoff_holdpq_en			(1'b0),
			.xoff_holdpq			(16'b0),
			.sink_xon_req			(mm_xonxoff_ctrl[0]),
			.sink_xoff_req			(mm_xonxoff_ctrl[1]),
			.sink_xonxoff_done		(last_frmdat_done),
			.src_xon_req_pulse		(),
			.src_xoff_req_pulse		(),
			.src_xonxoff_req_pulse	(),
			.src_xon_req_lvl		(mm_final_xon_req),
			.src_xoff_req_lvl		(),
			.src_xonxoff_req_lvl	(mm_final_xonxoff_req)
    );

	
	
    //------------------------------------------------------------------------
    // Select between CSR and Av-ST XON, XOFF control
    //------------------------------------------------------------------------
    //Part of the circuit (from input to this mux) is still toggling. This might affect power consumption
	// req only needs to last until the SOP data has been taken.  It will be re-sampled again at the
	// EOP.  If req is 1 at EOP, frame generation should be back-to-back.
	// Note that req is cleared by last_frmdat_done.
    /*
	always @(*) begin : ctrl_select
        case (tx_pause_select)
            1'b0:   begin
                        req = st_final_xonxoff_req;
                        xon = st_final_xon_req;
                    end
            1'b1:   begin 
                        req = mm_final_xonxoff_req;
                        xon = mm_final_xon_req;
                    end
        endcase
    end
	*/
	always @(*) 
		begin : ctrl_select
                        req = st_final_xonxoff_req | mm_final_xonxoff_req;
                        xon = st_final_xon_req | mm_final_xon_req;
        end

		
    // SYNC_RESET FLOPS	
    always @(posedge clk) begin
        if (!rst_n) begin
            last_frmdat_done <= 1'b0;
        end
        else begin
            last_frmdat_done <= (PAUSEGEN_SM_ns == FRMGAP);
        end
    end

	
	assign pause_tsfr_en = csr_tx_pause_en & !csr_tx_tsfr_en_n & (PAUSEGEN_SM_ps == FRMDAT0);
	assign pq[15:0] = xon? 16'h0000 : csr_tx_pause_pq[15:0];

	
	// ------------------------------------------------------------------------
	// Pause Frame Generation state machine (Same for PFC)
	// ------------------------------------------------------------------------

	// No need to further qualify with pause_tsfr_en as req won't assert unless pause_tsfr_en is 1
	assign arc_FRMDAT0_FRMDAT1 = (PAUSEGEN_SM_ps == FRMDAT0) & req & int_ready;
	assign arc_FRMDAT1_FRMDAT2 = (PAUSEGEN_SM_ps == FRMDAT1) & int_ready;
	assign arc_FRMDAT2_FRMDAT3 = (PAUSEGEN_SM_ps == FRMDAT2) & int_ready;
	assign arc_FRMDAT3_FRMDAT4 = (PAUSEGEN_SM_ps == FRMDAT3) & int_ready;
	assign arc_FRMDAT4_FRMDAT5 = (PAUSEGEN_SM_ps == FRMDAT4) & int_ready;
	assign arc_FRMDAT5_FRMDAT6 = (PAUSEGEN_SM_ps == FRMDAT5) & int_ready;
	assign arc_FRMDAT6_FRMDAT7 = (PAUSEGEN_SM_ps == FRMDAT6) & int_ready;
	assign arc_FRMDAT7_FRMDAT8 = (PAUSEGEN_SM_ps == FRMDAT7) & int_ready;
	assign arc_FRMDAT8_FRMDAT9 = (PAUSEGEN_SM_ps == FRMDAT8) & int_ready;
	assign arc_FRMDAT9_FRMDAT10 = (PAUSEGEN_SM_ps == FRMDAT9) & int_ready;
	assign arc_FRMDAT10_FRMDAT11 = (PAUSEGEN_SM_ps == FRMDAT10) & int_ready;
	assign arc_FRMDAT11_FRMDAT12 = (PAUSEGEN_SM_ps == FRMDAT11) & int_ready;
	assign arc_FRMDAT12_FRMDAT13 = (PAUSEGEN_SM_ps == FRMDAT12) & int_ready;
	assign arc_FRMDAT13_FRMDAT14 = (PAUSEGEN_SM_ps == FRMDAT13) & int_ready;
	//assign arc_FRMDAT14_FRMGAP = (PAUSEGEN_SM_ps == FRMDAT14) & int_ready;
	
	// artificially create a gap between two back-to-back frames for better Fmax.
	// This is because last_frmdat_done is flopped, and hence, the req won't be de-asserted until 1 clock after FRMDAT14.
	// Rather than de-asserting the req, we choose to not sample it for one clock in (FRMGAP state).
	assign arc_FRMDAT14_FRMGAP = (PAUSEGEN_SM_ps == FRMDAT14) & int_ready;
	assign arc_FRMGAP_FRMDAT0 = (PAUSEGEN_SM_ps == FRMGAP);
	
	
    // SYNC_RESET FLOPS	
	always @(posedge clk)
        begin
			if(!rst_n)
				begin
					PAUSEGEN_SM_ps <= FRMDAT0;
				end
			else
				begin
					PAUSEGEN_SM_ps <= PAUSEGEN_SM_ns;
				end
		end

		
    always @(*)
        begin
			case(PAUSEGEN_SM_ps)  
				FRMDAT0:
					if (arc_FRMDAT0_FRMDAT1)
						begin
							PAUSEGEN_SM_ns = FRMDAT1;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT0;
						end
						
				FRMDAT1:
					if (arc_FRMDAT1_FRMDAT2)
						begin
							PAUSEGEN_SM_ns = FRMDAT2;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT1;
						end
						
				FRMDAT2:
					if (arc_FRMDAT2_FRMDAT3)
						begin
							PAUSEGEN_SM_ns = FRMDAT3;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT2;
						end
						
				FRMDAT3:
					if (arc_FRMDAT3_FRMDAT4)
						begin
							PAUSEGEN_SM_ns = FRMDAT4;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT3;
						end
						
				FRMDAT4:
					if (arc_FRMDAT4_FRMDAT5)
						begin
							PAUSEGEN_SM_ns = FRMDAT5;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT4;
						end
						
				FRMDAT5:
					if (arc_FRMDAT5_FRMDAT6)
						begin
							PAUSEGEN_SM_ns = FRMDAT6;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT5;
						end
						
				FRMDAT6:
					if (arc_FRMDAT6_FRMDAT7)
						begin
							PAUSEGEN_SM_ns = FRMDAT7;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT6;
						end
						
				FRMDAT7:
					if (arc_FRMDAT7_FRMDAT8)
						begin
							PAUSEGEN_SM_ns = FRMDAT8;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT7;
						end
						
				FRMDAT8:
					if (arc_FRMDAT8_FRMDAT9)
						begin
							PAUSEGEN_SM_ns = FRMDAT9;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT8;
						end
						
				FRMDAT9:
					if (arc_FRMDAT9_FRMDAT10)
						begin
							PAUSEGEN_SM_ns = FRMDAT10;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT9;
						end
						
				FRMDAT10:
					if (arc_FRMDAT10_FRMDAT11)
						begin
							PAUSEGEN_SM_ns = FRMDAT11;
						end						
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT10;
						end
						
				FRMDAT11:
					if (arc_FRMDAT11_FRMDAT12)
						begin
							PAUSEGEN_SM_ns = FRMDAT12;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT11;
						end
						
				FRMDAT12:
					if (arc_FRMDAT12_FRMDAT13)
						begin
							PAUSEGEN_SM_ns = FRMDAT13;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT12;
						end
						
				FRMDAT13:
					if (arc_FRMDAT13_FRMDAT14)
						begin
							PAUSEGEN_SM_ns = FRMDAT14;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT13;
						end
						
				FRMDAT14:
					if (arc_FRMDAT14_FRMGAP)
						begin
							PAUSEGEN_SM_ns = FRMGAP;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMDAT14;
						end
						
				FRMGAP:
					if (arc_FRMGAP_FRMDAT0)
						begin
							PAUSEGEN_SM_ns = FRMDAT0;
						end
					else 
						begin
							PAUSEGEN_SM_ns = FRMGAP;
						end

				default:	PAUSEGEN_SM_ns = FRMDAT0;             
				
			endcase    
        end		
			

	// -----------------------------------------------------------------------
	// Pause Frame
	// -----------------------------------------------------------------------
	//
	// --------------------------------------------------------------------------------------------------------------
	// | Destination Address | Source Address | Length/Type | MAC Control Opcode | MAC COntrol Parameter | Reserved |
	// --------------------------------------------------------------------------------------------------------------
	//
	// Frame Description:
	// Destination Address   : 6 Bytes, Static Multicast Address value of 01-80-C2-00-00-01
	// Source Address        : 6 Bytes, Source address. Default to 00-00-00-00-00-00 if MAC configured to not insert source address. 
	// Length/Type           : 2 Bytes, MAC Control value of 88-08
	// MAC Control Opcode    : 2 Bytes, PAUSE control opcode of 00-01
	// MAC Control Parameter : 2 BYtes, Pause Quanta info. Range from 00-00 to FF-FF
	// Reserved              : 42 Bytes, Static Value of all zeros
	
    always @(*) 
		begin
			case (PAUSEGEN_SM_ps)
				FRMDAT0:
					begin
						sm_out_data = {32'h01_80_C2_00}; // DA
					end
					
				FRMDAT1:
					begin
						sm_out_data = {16'h00_01, csr_tx_mac_sa[47:32]}; // DA, SA
					end
					
				FRMDAT2:
					begin
						sm_out_data = {csr_tx_mac_sa[31:0]}; // SA
					end
					
				FRMDAT3:
					begin
						sm_out_data = {16'h88_08, 16'h00_01}; // length type, opcode
					end
				
				FRMDAT4:
					begin
						sm_out_data = {pq[15:0], 16'h0}; // pq, reserved
					end
											
				default:
					begin
						sm_out_data = {TXDATAWIDTH{1'b0}}; // reserved
					end
			endcase
		end


    // SYNC_RESET FLOPS	
	always @(posedge clk)
		begin
			if (!rst_n)
				begin
					sm_out_eop <= 1'b0;
				end
			else
				begin
					sm_out_eop <= (PAUSEGEN_SM_ns == FRMDAT14);
				end
		end

	// The req must be level-based, and only clear when int_ready = 1. Otherwise, there will be
	// issues:
	// (1) chicken-and-egg, where int_ready won't assert until there is a sop, but sop won't
	// assert either since no int_ready
	// (2) the signal is "lost" if int_ready doesn't assert when req is still 1
	assign sm_out_sop = (PAUSEGEN_SM_ps == FRMDAT0) & req;
	assign sm_out_valid = sm_out_sop | (!(PAUSEGEN_SM_ps == FRMDAT0) & !(PAUSEGEN_SM_ps == FRMGAP));
	

    // -----------------------------------------------------------------------
    // Pipeline for better Fmax
    // -----------------------------------------------------------------------
	
    assign in_data = {sm_out_data, sm_out_eop, sm_out_sop};
	
    // Registered output
    alt_em10g32_pipeline_base #(
        .SYMBOLS_PER_BEAT(1),
        .BITS_PER_SYMBOL(34),
        .PIPELINE_READY(0)
    ) pause_st_pl_inst (
        .clk        (clk),
        .reset_n    (rst_n),
        .in_ready   (int_ready),
        .in_valid   (sm_out_valid),
        .in_data    (in_data),
        .out_ready  (pause_frm_src_ready),
        .out_valid  (pause_frm_src_valid),
        .out_data   (out_data)
    );

    assign pause_frm_src_sop = out_data[0];
    assign pause_frm_src_eop = out_data[1];
    assign pause_frm_src_data = out_data[33:2];
	

	/*
	// Non pipeline - DO NOT USE
	assign pause_frm_src_sop = sm_out_sop;
	assign pause_frm_src_eop = sm_out_eop;
	assign pause_frm_src_data = sm_out_data; 
	assign pause_frm_src_valid = sm_out_valid;
	assign int_ready = pause_frm_src_ready;
	// - END DO NOT USE
	*/
	
	
	//=====================================================
	
    // Output port mapping - without preamble inserter
    assign frm2mx_pausefrm_sop      = pause_frm_src_sop;
    assign frm2mx_pausefrm_eop      = pause_frm_src_eop;
    assign frm2mx_pausefrm_valid    = pause_frm_src_valid;
    assign frm2mx_pausefrm_data     = pause_frm_src_data;
    assign pause_frm_src_ready      = mx2frm_pausefrm_ready;
	
	
	
	///*
	
	// Insert preamble bytes in preamble pass-through mode
	
	/*
	alt_em10g32_tx_preamble_inserter #(
		.TXDATAWIDTH(32),
		.PIPELINE_READY(1)
	) tx_preamble_inserter	(
		.clk				(clk),
		.rst_n				(rst_n),
		.preamble_passthru	(1'b0),
		.sink_sop			(pause_frm_src_sop),
		.sink_valid			(pause_frm_src_valid),
		.sink_ready			(pause_frm_src_ready),
		.sink_data			(pause_frm_src_data),
		.sink_eop			(pause_frm_src_eop),
		.src_sop			(frm2mx_pausefrm_sop),
		.src_valid			(frm2mx_pausefrm_valid),
		.src_ready			(mx2frm_pausefrm_ready),
		.src_data			(frm2mx_pausefrm_data),
		.src_eop			(frm2mx_pausefrm_eop)	
	); */
	
	//*/
	

	
	
    // -------------------------------------------------
	// Status output
	// -------------------------------------------------
    // CSR module is expecting a negative edge to clear the associated
    // register
    // SYNC_RESET FLOPS
    // Need to reset,otherwise potentiel negative edge loss
    always @(posedge clk) begin
        if (!rst_n) begin
            csr_tx_pause_status <= 1'b0;
        end
        else begin
			// Need to create a negative edge for every frame sent
            csr_tx_pause_status <= ((arc_FRMDAT0_FRMDAT1 & csr_tx_pause_select) | csr_tx_pause_status) & !arc_FRMDAT14_FRMGAP;
        end
    end
	
    // those piece of logic is use to keep track packet in progress    
    always @(posedge clk) 
        begin
        if(!rst_n)
            begin
            tx_packet_in_progress_pause <= 1'b0;
            end
        else
            begin
            if(PAUSEGEN_SM_ns == FRMDAT1)
                begin
                tx_packet_in_progress_pause <= 1'b1;
                end
            else if(PAUSEGEN_SM_ns == FRMDAT0)
                begin
                tx_packet_in_progress_pause <= 1'b0;
                end
            end
        end
    
    
    // -------------------------------------------------
	// Debug output
	// -------------------------------------------------
    generate
    if (DEBUG) begin
        // NON_RESETABLE FLOPS
        always @(posedge clk) begin
            dbg_tx_pause_trans_in_progress   <=  ((arc_FRMDAT0_FRMDAT1) | dbg_tx_pause_trans_in_progress) & !arc_FRMDAT14_FRMGAP;
        end
    end
    else begin
        wire constant_dbg_tx_pause_trans_in_progress;
        assign constant_dbg_tx_pause_trans_in_progress = 1'b0;
        always @(*) begin
            dbg_tx_pause_trans_in_progress = constant_dbg_tx_pause_trans_in_progress;
        end
    end
    endgenerate


endmodule


