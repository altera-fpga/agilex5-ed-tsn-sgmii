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


// $Id: //acds/main/ip/ethernet/ethernet_ucore/altera_eth_gmii_encoder/altera_eth_gmii_encoder.v#1 $
// $Revision: #1 $
// $Date: 2010/02/17 $
// $Author: wyleong $
//-----------------------------------------------------------------------------
// altera_eth_gmii_encoder
// Sedny Attia 3/16/2010
//-----------------------------------------------------------------------------
// Copyright (c) 2008 Altera Corporation. All Rights Reserved.
// The information contained in this file is the property of Altera
// Corporation. Except as specifically authorized in writing by Altera 
// Corporation, the holder of this file shall keep all information 
// contained herein confidential and shall protect same in whole or in part 
// from disclosure and dissemination to all third parties. Use of this 
// program confirms your agreement with the terms of this license.
//-----------------------------------------------------------------------------

 
//-----------------------------------------------------------------------------
`timescale 1ns / 1ns
module alt_em10g32_tx_gmii_encoder(
   clk_gmii,
   clk_mac,
   reset_gmii,
   reset_mac,
   flop_eop,
   ipg_value_1g,
   gmii_source_data,
   gmii_source_control,
   gmii_source_error,
   gmii_source_channel,
   txdata_sink_sop,
   txdata_sink_eop,
   txdata_sink_valid,
   txdata_sink_ready,
   txdata_sink_data,
   txdata_sink_error,
   txdata_sink_empty,
   txdata_sink_channel,
   tx_clkena,
   gmii_encoder_ecc_err_corrected,
   gmii_encoder_ecc_err_fatal
);

   parameter	W_GMII_WIDTH				=	8;
   parameter	BITSPERSYMBOL				=	8;  // Streaming Data symbol width in bits
   parameter	SYMBOLSPERBEAT				= 	4;  // Streaming Number of symbols per word
   parameter    ENABLE_MEM_ECC              =   0;
   parameter    FORWARD_SYNC_DEPTH          =   3;
   parameter    BACKWARD_SYNC_DEPTH         =   3;
   parameter    SYNC_RESET_N                =   1;
   
   localparam   MAC_WIDTH				=	BITSPERSYMBOL*SYMBOLSPERBEAT;
   localparam   EMPTY_WIDTH				=       log2ceil(SYMBOLSPERBEAT);
   localparam	W_GMII_CONTROL_WIDTH			=	W_GMII_WIDTH/8;
   localparam   MAC_TO_GMII_RATIO			=	MAC_WIDTH/W_GMII_WIDTH;
   
   localparam   USE_DC_FIFO                 =   0;
   
   //Change to a port if need to configure during run time
   // localparam   TX_MIN_IPG                   = ipg_value_1g;

   

   input	clk_gmii;
   input	clk_mac;
   input	reset_gmii;	  
   input	reset_mac;	  
   input    flop_eop;
   
   input    [7:0]ipg_value_1g;

   output	[W_GMII_WIDTH-1:0]			gmii_source_data;
   output	[W_GMII_CONTROL_WIDTH-1:0]		gmii_source_control;
   output   gmii_source_error;
   output   [1:0]                       gmii_source_channel;


   input						txdata_sink_sop;
   input						txdata_sink_eop;
   input	[EMPTY_WIDTH-1:0]			txdata_sink_empty;
   input	[MAC_WIDTH-1:0]				txdata_sink_data;
   input	[2:0]				txdata_sink_error;
   input	[1:0]				txdata_sink_channel;
   input 						txdata_sink_valid;
   output       					txdata_sink_ready;

   input                        tx_clkena; 
   
   // ECC status
   output                       gmii_encoder_ecc_err_corrected;
   output                       gmii_encoder_ecc_err_fatal;


   //--------------------------------------------------------------------------
   //--------------------------------------------------------------------------

   localparam PREAMBLE    	=  8'h55;		//Preamble Character
   localparam SFD        	=  8'hD5;		//Start Frame Delimiter
   localparam IDLE        	=  8'h00;		//Idle Character

   //---------------------------------------------------------------------------
   // Internal Registers and Wires Declaration
   //---------------------------------------------------------------------------
   wire                     fifo_out_sop;
   wire                     fifo_out_eop;
   wire	[EMPTY_WIDTH-1:0]   fifo_out_empty;
   wire [MAC_WIDTH-1:0]     fifo_out_data;
   wire	[2:0]               fifo_out_error;
   wire	[1:0]               fifo_out_channel;
   wire                     fifo_out_valid;
   wire                     fifo_out_ready;
   
   wire                     dfa_out_sop;
   wire                     dfa_out_eop;
   wire [W_GMII_WIDTH-1:0]  dfa_out_data;
   wire	[2:0]               dfa_out_error;
   wire	[1:0]               dfa_out_channel;
   wire                     dfa_out_valid;
   wire                     dfa_out_ready;
   
   reg                      packet_in_progress;
   
   reg  [7:0]                preamble_insert;
   reg  [3:0]                idle_count;
   wire [3:0]               idle_count_incr;
   
   reg  [W_GMII_WIDTH-1:0]          gmii_data;
   reg                              gmii_enable;
   reg                              gmii_error;
   reg  [1:0]                       gmii_channel;
   
   reg dfa_out_eop_dly1;
      
    generate if (USE_DC_FIFO && !ENABLE_MEM_ECC)
        begin: dc_fifo_soft_ecc_gen
            alt_em10g32_avalon_dc_fifo_secc #(
              .SYNC_RESET_N (SYNC_RESET_N)
            ) gmii_tx_fifo_secc (
               
                .in_clk(clk_mac),
                .in_reset_n(~reset_mac),

                .out_clk(clk_gmii),
                .out_reset_n(~reset_gmii),

                // sink
                .in_data(txdata_sink_data),
                .in_valid(txdata_sink_valid),
                .in_ready(txdata_sink_ready),
                .in_startofpacket(txdata_sink_sop),
                .in_endofpacket(txdata_sink_eop),
                .in_empty(txdata_sink_empty),
                .in_error(txdata_sink_error),
                .in_channel(txdata_sink_channel),

                // source
                .out_data(fifo_out_data),
                .out_valid(fifo_out_valid),
                .out_ready(fifo_out_ready),
                .out_startofpacket(fifo_out_sop),
                .out_endofpacket(fifo_out_eop),
                .out_empty(fifo_out_empty),
                .out_error(fifo_out_error),
                .out_channel(fifo_out_channel),


                // streaming in status
                .almost_full_valid(),
                .almost_full_data(),

                // streaming out status
                .almost_empty_valid(),
                .almost_empty_data(),
               
                // ECC status
                .ecc_err_corrected(gmii_encoder_ecc_err_corrected),
                .ecc_err_detected(),
                .ecc_err_fatal(gmii_encoder_ecc_err_fatal)
            
            );
            defparam
                gmii_tx_fifo_secc.ENABLE_MEM_ECC = ENABLE_MEM_ECC,
                gmii_tx_fifo_secc.ECC_BLOCK_WIDTH = 32, // Width of ECC Encoder input, either 32 or 12
                gmii_tx_fifo_secc.REGISTER_ENC_INPUT = 0,
                gmii_tx_fifo_secc.REGISTER_ENC_OUTPUT = 0,
                gmii_tx_fifo_secc.REGISTER_DEC_INPUT = 0,
                gmii_tx_fifo_secc.REGISTER_DEC_OUTPUT = 0,
                
                gmii_tx_fifo_secc.SYMBOLS_PER_BEAT = SYMBOLSPERBEAT,
                gmii_tx_fifo_secc.BITS_PER_SYMBOL = BITSPERSYMBOL,
                gmii_tx_fifo_secc.FIFO_DEPTH = 16,
                gmii_tx_fifo_secc.ERROR_WIDTH = 3,
                gmii_tx_fifo_secc.USE_PACKETS = 1,
                gmii_tx_fifo_secc.CHANNEL_WIDTH = 2;
                
      end
    else if(USE_DC_FIFO && ENABLE_MEM_ECC)
        begin: dc_fifo_hard_ecc_gen
            alt_em10g32_avalon_dc_fifo_hecc #(
              .SYNC_RESET_N       (SYNC_RESET_N)
            ) gmii_tx_fifo_hecc (
               
                .in_clk(clk_mac),
                .in_reset_n(~reset_mac),

                .out_clk(clk_gmii),
                .out_reset_n(~reset_gmii),

                // sink
                .in_data(txdata_sink_data),
                .in_valid(txdata_sink_valid),
                .in_ready(txdata_sink_ready),
                .in_startofpacket(txdata_sink_sop),
                .in_endofpacket(txdata_sink_eop),
                .in_empty(txdata_sink_empty),
                .in_error(txdata_sink_error),
                .in_channel(txdata_sink_channel),

                // source
                .out_data(fifo_out_data),
                .out_valid(fifo_out_valid),
                .out_ready(fifo_out_ready),
                .out_startofpacket(fifo_out_sop),
                .out_endofpacket(fifo_out_eop),
                .out_empty(fifo_out_empty),
                .out_error(fifo_out_error),
                .out_channel(fifo_out_channel),


                // streaming in status
                .almost_full_valid(),
                .almost_full_data(),

                // streaming out status
                .almost_empty_valid(),
                .almost_empty_data(),
               
                // ECC status
                .ecc_err_corrected(gmii_encoder_ecc_err_corrected),
                .ecc_err_fatal(gmii_encoder_ecc_err_fatal)
            
            );
            defparam
                gmii_tx_fifo_hecc.SYMBOLS_PER_BEAT = SYMBOLSPERBEAT,
                gmii_tx_fifo_hecc.BITS_PER_SYMBOL = BITSPERSYMBOL,
                gmii_tx_fifo_hecc.FIFO_DEPTH = 16,
                gmii_tx_fifo_hecc.ERROR_WIDTH = 3,
                gmii_tx_fifo_hecc.USE_PACKETS = 1,
                gmii_tx_fifo_hecc.CHANNEL_WIDTH = 2;
                
      end
    else begin : rr_cc_gen
            alt_em10g32_rr_clock_crosser #(
                 .SYNC_RESET_N (SYNC_RESET_N)
            ) gmii_encoder_rr_clock_crosser (
               
                .in_clk(clk_mac),
                .in_reset_n(~reset_mac),

                .out_clk(clk_gmii),
                .out_reset_n(~reset_gmii),

                // sink
                .in_data(txdata_sink_data),
                .in_valid(txdata_sink_valid),
                .in_ready(txdata_sink_ready),
                .in_startofpacket(txdata_sink_sop),
                .in_endofpacket(txdata_sink_eop),
                .in_empty(txdata_sink_empty),
                .in_error(txdata_sink_error),
                .in_channel(txdata_sink_channel),

                // source
                .out_data(fifo_out_data),
                .out_valid(fifo_out_valid),
                .out_ready(fifo_out_ready),
                .out_startofpacket(fifo_out_sop),
                .out_endofpacket(fifo_out_eop),
                .out_empty(fifo_out_empty),
                .out_error(fifo_out_error),
                .out_channel(fifo_out_channel)
            );
            defparam
                gmii_encoder_rr_clock_crosser.NUM_OF_CHANNEL = 2,
                
                gmii_encoder_rr_clock_crosser.SYMBOLS_PER_BEAT = SYMBOLSPERBEAT,
                gmii_encoder_rr_clock_crosser.BITS_PER_SYMBOL = BITSPERSYMBOL,
                gmii_encoder_rr_clock_crosser.ERROR_WIDTH = 3,
                gmii_encoder_rr_clock_crosser.USE_PACKETS = 1,
                gmii_encoder_rr_clock_crosser.CHANNEL_WIDTH = 2,
                
                gmii_encoder_rr_clock_crosser.FORWARD_SYNC_DEPTH = 3,
                gmii_encoder_rr_clock_crosser.BACKWARD_SYNC_DEPTH = 3;
            
            assign gmii_encoder_ecc_err_corrected = 1'b0;
            assign gmii_encoder_ecc_err_fatal = 1'b0;
        end
    endgenerate
    
    alt_em10g32_tx_gmii_encoder_dfa #(
      .SYNC_RESET_N (SYNC_RESET_N)
    ) dfa(
        .clk(clk_gmii),
        .reset_n(~reset_gmii),
        
        .in_ready(fifo_out_ready),
        .in_valid(fifo_out_valid),
        .in_data(fifo_out_data),
        .in_error(fifo_out_error),
        .in_channel(fifo_out_channel),
        .in_startofpacket(fifo_out_sop),
        .in_endofpacket(fifo_out_eop),
        .in_empty(fifo_out_empty),
        
        .out_ready(dfa_out_ready & tx_clkena & dfa_out_eop_dly1),
        .out_valid(dfa_out_valid),
        .out_data(dfa_out_data),
        .out_error(dfa_out_error),
        .out_channel(dfa_out_channel),
        .out_startofpacket(dfa_out_sop),
        .out_endofpacket(dfa_out_eop)
    );
    
    
    generate if (SYNC_RESET_N == 1) begin 
    always @(posedge clk_gmii) begin
        if (reset_gmii) begin
            packet_in_progress <= 1'b0;
            dfa_out_eop_dly1 <= 1'b0;
        end
        else begin
            if(tx_clkena)
            begin  
            dfa_out_eop_dly1 <= !dfa_out_eop;
                if(preamble_insert[7]) begin
                    packet_in_progress <= 1'b1;
                end
                else if(dfa_out_eop & dfa_out_valid) begin
                    packet_in_progress <= 1'b0;
                end
            end    
        end
    end
    
    always @(posedge clk_gmii) begin
        if (reset_gmii) begin
            preamble_insert <= {8{1'b0}};
        end
        else begin
            if(tx_clkena)
            begin 
                // Trigger preamble insertion on rising edge of valid SOP
                // to ensure that during backpressure, the same condition will not hit again
                // Insert Preamble when preamble_insert is EMPTY
                preamble_insert[0] <= (dfa_out_sop & dfa_out_valid & (~(|preamble_insert)) & (idle_count_incr >= (ipg_value_1g-1)) & ~packet_in_progress);
                preamble_insert[7:1] <= preamble_insert[6:0];
            end    
        end
    end
    
    assign idle_count_incr = idle_count + {{3{1'b0}}, {~gmii_enable}};
    
    always @(posedge clk_gmii) begin
        if (reset_gmii) begin
            idle_count <= 12; // initialized to 12 to ensure first packet could be sent out immediately
        end
        else begin
            if(tx_clkena)
            begin 
                if(&gmii_enable) begin
                    idle_count <= {4{1'b0}};
                end
                else if(idle_count >= (ipg_value_1g -1)) begin
                    idle_count <= idle_count;
                end
                else begin
                    idle_count <= idle_count_incr;
                end
            end    
        end
    end
    
    assign dfa_out_ready = packet_in_progress;
    
    // reg [3:0]counter;
    
    // always @(posedge clk_gmii or posedge reset_gmii) 
        // begin
        // if(reset_gmii)
            // begin
            // counter <= 4'b0;
            // end
        // else
            // begin
            // if(packet_in_progress)
                // begin
                // counter <= counter + 1;
                // if(counter == 4'b1111)
                    // begin
                    // counter <=counter;
                    // end
                // end
            // else
                // begin
                // counter <= 4'b0;
                // end
            // end
    
        // end
    
    always @(posedge clk_gmii) begin
        if (reset_gmii) begin
            gmii_data   <= {IDLE};
            gmii_enable <= {W_GMII_CONTROL_WIDTH{1'b0}};
            gmii_error  <= {W_GMII_CONTROL_WIDTH{1'b0}};
            gmii_channel<= {2{1'b0}};
        end
        else begin
            if(tx_clkena)
            begin 
                if(|preamble_insert[6:0]) begin
                    gmii_data   <= {PREAMBLE};
                    gmii_enable <= {W_GMII_CONTROL_WIDTH{1'b1}};
                    gmii_error  <= {W_GMII_CONTROL_WIDTH{1'b0}};
                    gmii_channel<= dfa_out_channel;
                end
                else if(preamble_insert[7]) begin
                    gmii_data   <= {SFD};
                    gmii_enable <= {W_GMII_CONTROL_WIDTH{1'b1}};
                    gmii_error  <= {W_GMII_CONTROL_WIDTH{1'b0}};
                    gmii_channel<= dfa_out_channel;
                end
                else if(dfa_out_valid & packet_in_progress) begin
                    gmii_data   <= dfa_out_data;
                    gmii_enable <= 1'b1;
                    gmii_error  <= {W_GMII_CONTROL_WIDTH{|dfa_out_error}};
                    gmii_channel<= dfa_out_channel;
                end
                else begin
                    gmii_data   <= {IDLE};
                    gmii_enable <= {W_GMII_CONTROL_WIDTH{1'b0}};
                    gmii_error  <= {W_GMII_CONTROL_WIDTH{1'b0}};
                    gmii_channel<= {2{1'b0}};
                end
            end    
        end
    end
    end else begin
    always @(posedge clk_gmii or posedge reset_gmii) begin
        if (reset_gmii) begin
            packet_in_progress <= 1'b0;
            dfa_out_eop_dly1 <= 1'b0;
        end
        else begin
            if(tx_clkena)
            begin  
            dfa_out_eop_dly1 <= !dfa_out_eop;
                if(preamble_insert[7]) begin
                    packet_in_progress <= 1'b1;
                end
                else if(dfa_out_eop & dfa_out_valid) begin
                    packet_in_progress <= 1'b0;
                end
            end    
        end
    end
    
    always @(posedge clk_gmii or posedge reset_gmii) begin
        if (reset_gmii) begin
            preamble_insert <= {8{1'b0}};
        end
        else begin
            if(tx_clkena)
            begin 
                // Trigger preamble insertion on rising edge of valid SOP
                // to ensure that during backpressure, the same condition will not hit again
                // Insert Preamble when preamble_insert is EMPTY
                preamble_insert[0] <= (dfa_out_sop & dfa_out_valid & (~(|preamble_insert)) & (idle_count_incr >= (ipg_value_1g-1)) & ~packet_in_progress);
                preamble_insert[7:1] <= preamble_insert[6:0];
            end    
        end
    end
    
    assign idle_count_incr = idle_count + {{3{1'b0}}, {~gmii_enable}};
    
    always @(posedge clk_gmii or posedge reset_gmii) begin
        if (reset_gmii) begin
            idle_count <= 12; // initialized to 12 to ensure first packet could be sent out immediately
        end
        else begin
            if(tx_clkena)
            begin 
                if(&gmii_enable) begin
                    idle_count <= {4{1'b0}};
                end
                else if(idle_count >= (ipg_value_1g -1)) begin
                    idle_count <= idle_count;
                end
                else begin
                    idle_count <= idle_count_incr;
                end
            end    
        end
    end
    
    assign dfa_out_ready = packet_in_progress;
    
    // reg [3:0]counter;
    
    // always @(posedge clk_gmii or posedge reset_gmii) 
        // begin
        // if(reset_gmii)
            // begin
            // counter <= 4'b0;
            // end
        // else
            // begin
            // if(packet_in_progress)
                // begin
                // counter <= counter + 1;
                // if(counter == 4'b1111)
                    // begin
                    // counter <=counter;
                    // end
                // end
            // else
                // begin
                // counter <= 4'b0;
                // end
            // end
    
        // end
    
    always @(posedge clk_gmii or posedge reset_gmii) begin
        if (reset_gmii) begin
            gmii_data   <= {IDLE};
            gmii_enable <= {W_GMII_CONTROL_WIDTH{1'b0}};
            gmii_error  <= {W_GMII_CONTROL_WIDTH{1'b0}};
            gmii_channel<= {2{1'b0}};
        end
        else begin
            if(tx_clkena)
            begin 
                if(|preamble_insert[6:0]) begin
                    gmii_data   <= {PREAMBLE};
                    gmii_enable <= {W_GMII_CONTROL_WIDTH{1'b1}};
                    gmii_error  <= {W_GMII_CONTROL_WIDTH{1'b0}};
                    gmii_channel<= dfa_out_channel;
                end
                else if(preamble_insert[7]) begin
                    gmii_data   <= {SFD};
                    gmii_enable <= {W_GMII_CONTROL_WIDTH{1'b1}};
                    gmii_error  <= {W_GMII_CONTROL_WIDTH{1'b0}};
                    gmii_channel<= dfa_out_channel;
                end
                else if(dfa_out_valid & packet_in_progress) begin
                    gmii_data   <= dfa_out_data;
                    gmii_enable <= 1'b1;
                    gmii_error  <= {W_GMII_CONTROL_WIDTH{|dfa_out_error}};
                    gmii_channel<= dfa_out_channel;
                end
                else begin
                    gmii_data   <= {IDLE};
                    gmii_enable <= {W_GMII_CONTROL_WIDTH{1'b0}};
                    gmii_error  <= {W_GMII_CONTROL_WIDTH{1'b0}};
                    gmii_channel<= {2{1'b0}};
                end
            end    
        end
    end
    end
    endgenerate 
   
   assign gmii_source_data = gmii_data;
   assign gmii_source_control = gmii_enable;
   assign gmii_source_error = gmii_error;
   assign gmii_source_channel = gmii_channel;

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
