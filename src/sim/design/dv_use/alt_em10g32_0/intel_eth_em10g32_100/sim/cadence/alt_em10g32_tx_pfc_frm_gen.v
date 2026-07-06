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
// Module: Altera Ethernet MAC 32bit TX Priority Flow Control Frame Generator
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
//  * pause_ctrl_sink_data[0]       = XON
//  * pause_ctrl_sink_data[1]       = XOFF
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_pfc_frm_gen #(
    parameter PFC_PRIORITY_NUM  = 8,
    parameter TXDATAWIDTH       = 32,
    parameter DEBUG             = 0
) (
    // Clock and reset
    input wire								clk,
    input wire								rst_n,

    // CSR control path
    // These CSR signals must be static except for csr_tx_tsfr_en_n
    input wire								csr_tx_preamble_passthru,
	input wire [47:0]						csr_tx_mac_sa,
    input wire								csr_tx_tsfr_en_n,

    input wire								csr_tx_pfc0_en,
    input wire [15:0]						csr_tx_pfc0_pqt,
    input wire [15:0]						csr_tx_pfc0_hqt,

    input wire								csr_tx_pfc1_en,
    input wire [15:0]						csr_tx_pfc1_pqt,
    input wire [15:0]						csr_tx_pfc1_hqt,

    input wire								csr_tx_pfc2_en,
    input wire [15:0]						csr_tx_pfc2_pqt,
    input wire [15:0]						csr_tx_pfc2_hqt,

    input wire								csr_tx_pfc3_en,
    input wire [15:0]						csr_tx_pfc3_pqt,
    input wire [15:0]						csr_tx_pfc3_hqt,

    input wire								csr_tx_pfc4_en,
    input wire [15:0]						csr_tx_pfc4_pqt,
    input wire [15:0]						csr_tx_pfc4_hqt,

    input wire								csr_tx_pfc5_en,
    input wire [15:0]						csr_tx_pfc5_pqt,
    input wire [15:0]						csr_tx_pfc5_hqt,

    input wire								csr_tx_pfc6_en,
    input wire [15:0]						csr_tx_pfc6_pqt,
    input wire [15:0]						csr_tx_pfc6_hqt,

    input wire		 						csr_tx_pfc7_en,
    input wire [15:0]						csr_tx_pfc7_pqt,
    input wire [15:0]						csr_tx_pfc7_hqt,

    // Av-ST control path
    input wire [(PFC_PRIORITY_NUM*2)-1: 0]	pfc_ctrl_sink_data,

    // Pause frame data path
    output wire								frm2mx_pfcfrm_sop,
    output wire								frm2mx_pfcfrm_eop,
    output wire								frm2mx_pfcfrm_valid,
    output wire [TXDATAWIDTH-1:0]			frm2mx_pfcfrm_data,
    
    input wire								mx2frm_pfcfrm_ready,
    
    // busy status
    output reg                              tx_packet_in_progress_pfc,
    
    // Debug
    output reg								dbg_tx_pfc_trans_in_progress
);


    // Internal wires and regs
    wire									sm_out_sop;
	(*preserve*) reg						sm_out_eop;
	wire									sm_out_valid;
    reg [TXDATAWIDTH-1:0] 					sm_out_data;

    wire									int_ready;

    wire [15:0]								csr_tx_pfc_holdoff_pq[PFC_PRIORITY_NUM-1:0];
    wire [15:0]								csr_tx_pfc_pq[PFC_PRIORITY_NUM-1:0];
    wire [PFC_PRIORITY_NUM-1:0]				csr_tx_pfc_en;

    wire [15:0]								pfc_pq[7:0];
    wire [PFC_PRIORITY_NUM-1:0]				pfc_en;
    wire									pfc_xoff[PFC_PRIORITY_NUM-1:0];
    wire									pfc_xon[PFC_PRIORITY_NUM-1:0];

	wire									pfc_frm_src_sop;
	wire									pfc_frm_src_eop;
	wire									pfc_frm_src_valid;
	wire									pfc_frm_src_ready;
	wire [TXDATAWIDTH-1:0]					pfc_frm_src_data;

    wire [TXDATAWIDTH+1:0]					in_data;
    wire [TXDATAWIDTH+1:0]					out_data;
	
	wire									pause_tsfr_en;
	reg										req;
	// Set SYNCHRONIZER_IDENTIFICATION=OFF because csr_tx_pfc_en is pseudo-static CSR field
	(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg [(PFC_PRIORITY_NUM*2)-1:0]			st_xonxoff_ctrl;
	reg [(PFC_PRIORITY_NUM*2)-1:0]			st_xonxoff_ctrl_f1;
	wire [PFC_PRIORITY_NUM-1:0]				st_xonxoff_req_pulse;
	wire [PFC_PRIORITY_NUM-1:0]				st_xon_req;

	
	reg						last_frmdat_done;
	(*preserve*) reg						frmdat14_state;
	
	reg										arc_FRMGAP_FRMDAT0_dly;
		
		
	// State machine
	localparam		FRMDAT0		= 4'b0000;	// Default to DA or Preamble
	localparam		FRMDAT1		= 4'b0001;	// DA, SA
	localparam		FRMDAT2		= 4'b0010;	// DA
	localparam		FRMDAT3		= 4'b0011;	// LT, Opcode
	localparam		FRMDAT4		= 4'b0100;	// PQ, 0 (PFC = PQE, PQ0)
	localparam		FRMDAT5		= 4'b0101;	// 0 (PFC = PQ1, PQ2)
	localparam		FRMDAT6		= 4'b0110;	// 0 (PFC = PQ3, PQ4)
	localparam		FRMDAT7		= 4'b0111;	// 0 (PFC = PQ5, PQ6)
	localparam		FRMDAT8		= 4'b1000;	// 0 (PFC = PQ7, 0)
	localparam		FRMDAT9		= 4'b1001;	// 0
	localparam		FRMDAT10	= 4'b1010;	// 0
	localparam		FRMDAT11	= 4'b1011;	// 0
	localparam		FRMDAT12	= 4'b1100;	// 0
	localparam		FRMDAT13	= 4'b1101;	// 0
	localparam		FRMDAT14	= 4'b1110;	// 0
	localparam		FRMGAP		= 4'b1111;	// 0
	
	wire			arc_FRMDAT0_FRMDAT1;
	wire			arc_FRMDAT1_FRMDAT2;
	wire			arc_FRMDAT2_FRMDAT3;
	wire			arc_FRMDAT3_FRMDAT4;
	wire			arc_FRMDAT4_FRMDAT5;
	wire			arc_FRMDAT5_FRMDAT6;
	wire			arc_FRMDAT6_FRMDAT7;
	wire			arc_FRMDAT7_FRMDAT8;
	wire			arc_FRMDAT8_FRMDAT9;
	wire			arc_FRMDAT9_FRMDAT10;
	wire			arc_FRMDAT10_FRMDAT11;
	wire			arc_FRMDAT11_FRMDAT12;
	wire			arc_FRMDAT12_FRMDAT13;
	wire			arc_FRMDAT13_FRMDAT14;
	wire			arc_FRMDAT14_FRMGAP;
	wire			arc_FRMGAP_FRMDAT0;
	
	reg	[3:0]		PAUSEGEN_SM_ps;
	reg	[3:0]		PAUSEGEN_SM_ns;
	
	// hold xoff so that xon can be generated after xoff
	wire	[(PFC_PRIORITY_NUM)-1:0]		st_hold_xoff;
	wire	[(PFC_PRIORITY_NUM)-1:0]		st_hold_xon;
	reg	[(PFC_PRIORITY_NUM)-1:0]			st_hold_xoff_flop;
		
	
	// ----------------------------------------------------------------
	
    genvar i;

    generate
		for (i=PFC_PRIORITY_NUM; i<8; i=i+1) begin : MAP_NULL
			assign csr_tx_pfc_holdoff_pq[i]    = 16'h0000;
			assign csr_tx_pfc_pq[i]            = 16'h0000;
			assign csr_tx_pfc_en[i]            = 1'b0;
		end

		for (i=PFC_PRIORITY_NUM; i<8; i=i+1) begin : PFC_PRIO_GEN_NULL
			assign pfc_en[i] = 1'b0;
			assign pfc_xoff[i] = 1'b0;
			assign pfc_xon[i] = 1'b0;
			assign pfc_pq[i] = 16'h0000;
		end
	
	
		for (i=0; i<PFC_PRIORITY_NUM; i=i+1) begin : MAP
			//------------------------------------------------------------------------
			// Mapping
			//------------------------------------------------------------------------
			case (i)
			0:  begin
					assign csr_tx_pfc_holdoff_pq[i]    = csr_tx_pfc0_hqt;
					assign csr_tx_pfc_pq[i]            = csr_tx_pfc0_pqt;
					assign csr_tx_pfc_en[i]            = csr_tx_pfc0_en;
				end
			1:  begin
					assign csr_tx_pfc_holdoff_pq[i]    = csr_tx_pfc1_hqt;
					assign csr_tx_pfc_pq[i]            = csr_tx_pfc1_pqt;
					assign csr_tx_pfc_en[i]            = csr_tx_pfc1_en;
				end
			2:  begin
					assign csr_tx_pfc_holdoff_pq[i]    = csr_tx_pfc2_hqt;
					assign csr_tx_pfc_pq[i]            = csr_tx_pfc2_pqt;
					assign csr_tx_pfc_en[i]            = csr_tx_pfc2_en;
				end
			3:  begin
					assign csr_tx_pfc_holdoff_pq[i]    = csr_tx_pfc3_hqt;
					assign csr_tx_pfc_pq[i]            = csr_tx_pfc3_pqt;
					assign csr_tx_pfc_en[i]            = csr_tx_pfc3_en;
				end
			4:  begin
					assign csr_tx_pfc_holdoff_pq[i]    = csr_tx_pfc4_hqt;
					assign csr_tx_pfc_pq[i]            = csr_tx_pfc4_pqt;
					assign csr_tx_pfc_en[i]            = csr_tx_pfc4_en;
				end
			5:  begin
					assign csr_tx_pfc_holdoff_pq[i]    = csr_tx_pfc5_hqt;
					assign csr_tx_pfc_pq[i]            = csr_tx_pfc5_pqt;
					assign csr_tx_pfc_en[i]            = csr_tx_pfc5_en;
				end
			6:  begin
					assign csr_tx_pfc_holdoff_pq[i]    = csr_tx_pfc6_hqt;
					assign csr_tx_pfc_pq[i]            = csr_tx_pfc6_pqt;
					assign csr_tx_pfc_en[i]            = csr_tx_pfc6_en;
				end
			7:  begin
					assign csr_tx_pfc_holdoff_pq[i]    = csr_tx_pfc7_hqt;
					assign csr_tx_pfc_pq[i]            = csr_tx_pfc7_pqt;
					assign csr_tx_pfc_en[i]            = csr_tx_pfc7_en;
				end
			default:
				begin
						assign csr_tx_pfc_holdoff_pq[i]    = 16'h0000;
						assign csr_tx_pfc_pq[i]            = 16'h0000;
						assign csr_tx_pfc_en[i]            = 1'b0;
				end
			endcase
		end
		
		for (i=0; i<PFC_PRIORITY_NUM; i=i+1) begin : PFC_PRIO_GEN
			alt_em10g32_tx_pause_req
				st_pause_req_inst (
					.clk					(clk),
					.rst_n					(rst_n),
					.xoff_holdpq_en			(1'b1),
					.xoff_holdpq			(csr_tx_pfc_holdoff_pq[i]),
					.sink_xon_req			(st_xonxoff_ctrl_f1[2*i]),
					.sink_xoff_req			(st_xonxoff_ctrl_f1[2*i+1]),
					.sink_xonxoff_done		(last_frmdat_done),
					.src_xon_req_pulse		(),
					.src_xoff_req_pulse		(),
					.src_xonxoff_req_pulse	(),
					.src_xon_req_lvl		(pfc_xon[i]),
					.src_xoff_req_lvl		(pfc_xoff[i]),
					.src_xonxoff_req_lvl	(pfc_en[i])
			);
		end
		
		for (i=0; i<PFC_PRIORITY_NUM; i=i+1) begin : PFC_XONXOFF_CTRL
			// Force the control to be 'b00 when pause is not enabled or triggered
			//assign st_xonxoff_ctrl[2*i] = pause_tsfr_en? (csr_tx_pfc_en[i] & (pfc_ctrl_sink_data[2*i+1:2*i] == 2'b01) & st_hold_xoff_flop[i]  ): 1'b0;
			//assign st_xonxoff_ctrl[2*i+1] = pause_tsfr_en? (csr_tx_pfc_en[i] & (pfc_ctrl_sink_data[2*i+1:2*i] == 2'b10)): 1'b0;
            always @(posedge clk)
                begin
                if(!rst_n)
                    begin
                    st_xonxoff_ctrl[2*i] <= 'b0;
                    st_xonxoff_ctrl[2*i+1] <= 'b0;
                    end
                else
                    begin
                    st_xonxoff_ctrl[2*i] <= pause_tsfr_en? (csr_tx_pfc_en[i] & (pfc_ctrl_sink_data[2*i+1:2*i] == 2'b01) & st_hold_xoff_flop[i]  ): 1'b0;
                    st_xonxoff_ctrl[2*i+1] <= pause_tsfr_en? (csr_tx_pfc_en[i] & (pfc_ctrl_sink_data[2*i+1:2*i] == 2'b10)): 1'b0;    
                    end
                end
            
			assign st_hold_xoff[i] = st_xonxoff_ctrl[2*i+1];
			assign st_hold_xon[i] = st_xonxoff_ctrl[2*i];
			assign pfc_pq[i] = pfc_xoff[i]? csr_tx_pfc_pq[i]: 16'h0000;
		end
		
	// This signal can be flopped for potential Fmax improvement
    // SYNC_RESET FLOPS
	always @(posedge clk)
		begin
			if (!rst_n)
				begin
					// st_xonxoff_ctrl_f1[15:0] <= 16'b0;
					req <= 'd0;
				end
			else
				begin
					// st_xonxoff_ctrl_f1[15:0] <= st_xonxoff_ctrl[15:0];
					req <= |(pfc_en);
				end
		end
        
	for(i=0; i<PFC_PRIORITY_NUM; i=i+1) begin : PFC_XONXOFF
		always @(posedge clk)
			begin
				if (!rst_n)
					begin
						st_hold_xoff_flop[i] <= 'd0;
					end
				else
					begin
					if(st_hold_xoff[i])
						begin
						st_hold_xoff_flop[i] <= st_hold_xoff[i];
						end
					else if (pfc_xon[i])
						begin
						st_hold_xoff_flop[i] <= !pfc_xon[i];
						end
					else
						begin
						st_hold_xoff_flop[i] <= st_hold_xoff_flop[i];
						end
					end

			end
		end	

    endgenerate

	
		

	
    // SYNC_RESET FLOPS	
	always @(posedge clk) begin
        last_frmdat_done <= (PAUSEGEN_SM_ns == FRMGAP);
        st_xonxoff_ctrl_f1[15:0] <= st_xonxoff_ctrl[15:0];
    end


	assign pause_tsfr_en = !csr_tx_tsfr_en_n & (PAUSEGEN_SM_ps == FRMDAT0);
	
	
	
	// ------------------------------------------------------------------------
	// PFC Frame Generation state machine (Same for Pause)
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
	
	
    // NON_RESETABLE FLOPS	
	always @(posedge clk) 
        begin
            arc_FRMGAP_FRMDAT0_dly <= arc_FRMGAP_FRMDAT0;
        end

    // SYNC_RESET FLOP
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
					if (arc_FRMGAP_FRMDAT0_dly)
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
	// MAC Control Opcode    : 2 Bytes, PFC control opcode of 01-01
	// MAC Control Parameter : 4 BYtes, Class Enable Vector
	// Time (Class 0 - 7)    : 16 Bytes, Class Time (PQ)
	// Reserved              : 28 Bytes, Static Value of all zeros

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
						sm_out_data = {16'h88_08, 16'h01_01}; // length type, opcode
					end
				
				FRMDAT4:
					begin
						sm_out_data = {8'h00, pfc_en, pfc_pq[0]}; // pq, reserved
					end
					
				FRMDAT5:
					begin
						sm_out_data = {pfc_pq[1], pfc_pq[2]};
					end
					
				FRMDAT6:
					begin
						sm_out_data = {pfc_pq[3], pfc_pq[4]};
					end

				FRMDAT7:
					begin
						sm_out_data = {pfc_pq[5], pfc_pq[6]};
					end

				FRMDAT8:
					begin
						sm_out_data = {pfc_pq[7], 16'b0};
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
    ) pfc_st_pl_inst (
        .clk        (clk),
        .reset_n    (rst_n),
        .in_ready   (int_ready),
        .in_valid   (sm_out_valid),
        .in_data    (in_data),
        .out_ready  (pfc_frm_src_ready),
        .out_valid  (pfc_frm_src_valid),
        .out_data   (out_data)
    );

    assign pfc_frm_src_sop = out_data[0];
    assign pfc_frm_src_eop = out_data[1];
    assign pfc_frm_src_data = out_data[33:2];
	
	
	/*
	// Non pipeline - DO NOT USE
	assign pfc_frm_src_sop = sm_out_sop;
	assign pfc_frm_src_eop = sm_out_eop;
	assign pfc_frm_src_data = sm_out_data; 
	assign pfc_frm_src_valid = sm_out_valid;
	assign int_ready = pfc_frm_src_ready;
	// - END DO NOT USE
	*/
	
	
    // Output port mapping - without preamble inserter
    assign frm2mx_pfcfrm_sop      = pfc_frm_src_sop;
    assign frm2mx_pfcfrm_eop      = pfc_frm_src_eop;
    assign frm2mx_pfcfrm_valid    = pfc_frm_src_valid;
    assign frm2mx_pfcfrm_data     = pfc_frm_src_data;
    assign pfc_frm_src_ready      = mx2frm_pfcfrm_ready;
    
        // those piece of logic is use to keep track packet in progress    
    always @(posedge clk) 
        begin
        if(!rst_n)
            begin
            tx_packet_in_progress_pfc <= 1'b0;
            end
        else
            begin
            if(PAUSEGEN_SM_ns == FRMDAT1)
                begin
                tx_packet_in_progress_pfc <= 1'b1;
                end
            else if(PAUSEGEN_SM_ns == FRMDAT0)
                begin
                tx_packet_in_progress_pfc <= 1'b0;
                end
            end
        end
	
	
	/*
	// Insert preamble bytes in preamble pass-through mode
	alt_em10g32_tx_preamble_inserter #(
		.TXDATAWIDTH(32),
		.PIPELINE_READY(1)
	) tx_preamble_inserter	(
		.clk				(clk),
		.rst_n				(rst_n),
		.preamble_passthru	(1'b0),
		.sink_sop			(pfc_frm_src_sop),
		.sink_valid			(pfc_frm_src_valid),
		.sink_ready			(pfc_frm_src_ready),
		.sink_data			(pfc_frm_src_data),
		.sink_eop			(pfc_frm_src_eop),
		.src_sop			(frm2mx_pfcfrm_sop),
		.src_valid			(frm2mx_pfcfrm_valid),
		.src_ready			(mx2frm_pfcfrm_ready),
		.src_data			(frm2mx_pfcfrm_data),
		.src_eop			(frm2mx_pfcfrm_eop)	
	);
	*/


    // -----------------------------------------------------------------------
    // Debug
    // -----------------------------------------------------------------------
    generate
    if (DEBUG) begin: debug
        // NON_RESETABLE FLOPS
        always @(posedge clk) begin
            dbg_tx_pfc_trans_in_progress   <= ((arc_FRMDAT0_FRMDAT1) | dbg_tx_pfc_trans_in_progress) & !arc_FRMDAT14_FRMGAP;
        end
    end
    else begin
        always @(*) begin
            dbg_tx_pfc_trans_in_progress = 1'b0;
        end
    end
    endgenerate


endmodule


