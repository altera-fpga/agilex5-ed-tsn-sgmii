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


// $Id: //acds/main/ip/ethernet/ethernet_ucore/altera_eth_gmii_decoder/altera_eth_gmii_decoder.v#40 $
// $Revision: #40 $
// $Date: 2010/02/17 $
// $Author: sattia $
//-----------------------------------------------------------------------------
// altera_eth_gmii_decoder
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
module alt_em10g32_rx_gmii_decoder(
   clk_gmii,
   clk_mac,
   reset_gmii,
   reset_mac,
   gmii_sink_data,
   gmii_sink_control,
   gmii_sink_error,
   rxdata_src_sop,
   rxdata_src_eop,
   rxdata_src_valid,
   rxdata_src_data,
   rxdata_src_error,
   rxdata_src_empty,
   rx_clkena,
   gmii_decoder_ecc_err_corrected,
   gmii_decoder_ecc_err_fatal
);

   parameter	W_GMII_WIDTH				=	8;
   parameter	BITSPERSYMBOL				=	8;  // Streaming Data symbol width in bits
   parameter	SYMBOLSPERBEAT				= 	4;  // Streaming Number of symbols per word
   parameter    ENABLE_MEM_ECC              =   0;
   
   parameter    FORWARD_SYNC_DEPTH          =   3;
   parameter    BACKWARD_SYNC_DEPTH         =   3;
   parameter    SYNC_RESET_N                =   1;
   
   localparam   MAC_WIDTH				=	BITSPERSYMBOL*SYMBOLSPERBEAT;
   localparam   EMPTY_WIDTH				=       $clog2(SYMBOLSPERBEAT);
   localparam	W_GMII_CONTROL_WIDTH			=	W_GMII_WIDTH/8;
   localparam   MAC_TO_GMII_RATIO			=	MAC_WIDTH/W_GMII_WIDTH;

   localparam   USE_DC_FIFO = 0;
   

   input	clk_gmii;
   input	clk_mac;
   input	reset_gmii;	  
   input	reset_mac;	  

   input	[W_GMII_WIDTH-1:0]			gmii_sink_data;
   input	[W_GMII_CONTROL_WIDTH-1:0]		gmii_sink_control;
   input    gmii_sink_error;

   output						rxdata_src_sop;
   output						rxdata_src_eop;
   output	[EMPTY_WIDTH-1:0]			rxdata_src_empty;
   output	[MAC_WIDTH-1:0]				rxdata_src_data;
   output				rxdata_src_error;
   output 						rxdata_src_valid;
   
   input                rx_clkena;
   
   // ECC status
   output   gmii_decoder_ecc_err_corrected;
   output   gmii_decoder_ecc_err_fatal;



   //--------------------------------------------------------------------------
   //--------------------------------------------------------------------------

   localparam PREAMBLE    	=  8'h55;		//Preamble Character
   localparam SFD        	=  8'hD5;		//Start Frame Delimiter
   localparam IDLE        	=  8'h07;		//Idle Character


/////////////////////////////
// GMII to AVST conversion //
// - GMII clock domain     //
/////////////////////////////


reg [7:0]   gmii_avst_data;
reg         gmii_avst_sop;
wire        gmii_avst_eop;
reg         gmii_avst_valid;
reg         gmii_avst_err;
reg         gmii_packet_in_progress;
reg         receive_sfd;
reg         terminate;

   generate if (SYNC_RESET_N == 1) begin
   always@(posedge clk_gmii)
   begin
      if (reset_gmii)  begin
         gmii_avst_sop    <= 1'b0;
         gmii_avst_valid  <= 1'b0;
         gmii_avst_err    <= 1'b0;
         gmii_avst_data   <= 8'd0;
         gmii_packet_in_progress <= 1'b0;
         receive_sfd      <= 1'b0;
      end 
      else begin
        if(rx_clkena)
        begin
             gmii_avst_sop    <= 1'b0;
             gmii_avst_valid  <= 1'b0;
             gmii_avst_err    <= 1'b0;
             gmii_avst_data   <= gmii_sink_data; 
             gmii_packet_in_progress <= 1'b0;
             receive_sfd      <= 1'b0;
             
             //START
             if (gmii_packet_in_progress == 1'b0 && gmii_sink_control== 1'b1 && gmii_sink_data==SFD && gmii_sink_error==1'b0) begin
                receive_sfd <= 1'b1;
             end 
            
             if (receive_sfd && gmii_sink_control == 1'b1) begin
                gmii_avst_sop <= 1'b1;
                gmii_avst_err <= gmii_sink_error;
                gmii_packet_in_progress <= 1'b1;
                gmii_avst_valid <= 1'b1;
             end
             
             
             if (gmii_packet_in_progress == 1'b1 && gmii_sink_control == 1'b1) begin
                gmii_avst_err <= gmii_sink_error;
                gmii_packet_in_progress <= 1'b1;
                gmii_avst_valid <= 1'b1;
             end
             else if (gmii_packet_in_progress == 1'b1 && gmii_sink_control == 1'b0) begin
                gmii_packet_in_progress <= 1'b0;
                gmii_avst_valid <= 1'b0;
             end
        end     
      end
   end
   end else begin
   always@(posedge clk_gmii or posedge reset_gmii)
   begin
      if (reset_gmii)  begin
         gmii_avst_sop    <= 1'b0;
         gmii_avst_valid  <= 1'b0;
         gmii_avst_err    <= 1'b0;
         gmii_avst_data   <= 8'd0;
         gmii_packet_in_progress <= 1'b0;
         receive_sfd      <= 1'b0;
      end 
      else begin
        if(rx_clkena)
        begin
             gmii_avst_sop    <= 1'b0;
             gmii_avst_valid  <= 1'b0;
             gmii_avst_err    <= 1'b0;
             gmii_avst_data   <= gmii_sink_data; 
             gmii_packet_in_progress <= 1'b0;
             receive_sfd      <= 1'b0;
             
             //START
             if (gmii_packet_in_progress == 1'b0 && gmii_sink_control== 1'b1 && gmii_sink_data==SFD && gmii_sink_error==1'b0) begin
                receive_sfd <= 1'b1;
             end 
            
             if (receive_sfd && gmii_sink_control == 1'b1) begin
                gmii_avst_sop <= 1'b1;
                gmii_avst_err <= gmii_sink_error;
                gmii_packet_in_progress <= 1'b1;
                gmii_avst_valid <= 1'b1;
             end
             
             
             if (gmii_packet_in_progress == 1'b1 && gmii_sink_control == 1'b1) begin
                gmii_avst_err <= gmii_sink_error;
                gmii_packet_in_progress <= 1'b1;
                gmii_avst_valid <= 1'b1;
             end
             else if (gmii_packet_in_progress == 1'b1 && gmii_sink_control == 1'b0) begin
                gmii_packet_in_progress <= 1'b0;
                gmii_avst_valid <= 1'b0;
             end
        end     
      end
   end
   end
   endgenerate
   assign gmii_avst_eop = (gmii_packet_in_progress == 1'b1) && (gmii_sink_control == 1'b0) ;
   

////////////////////////////////
// DC FIFO                    //  
// DC <= AVST-RX <= GMII-RX   //
////////////////////////////////

wire [7:0]  avst_data_8b;
wire        avst_valid_8b;
wire        avst_ready_8b;
wire        avst_sop_8b;
wire        avst_eop_8b;
wire        avst_err_8b;
   
generate if (USE_DC_FIFO && !ENABLE_MEM_ECC)
    begin: dc_fifo_soft_ecc_gen
        alt_em10g32_avalon_dc_fifo_secc #(
            .ENABLE_MEM_ECC     (ENABLE_MEM_ECC),
            .ECC_BLOCK_WIDTH    (12),
            .REGISTER_ENC_INPUT (0),
            .REGISTER_ENC_OUTPUT(0),
            .REGISTER_DEC_INPUT (0),
            .REGISTER_DEC_OUTPUT(0),
            
            .SYMBOLS_PER_BEAT   (1),
            .BITS_PER_SYMBOL    (8),
            .FIFO_DEPTH         (16),
            .CHANNEL_WIDTH      (0),
            .ERROR_WIDTH        (1),
            .USE_PACKETS        (1),
            .USE_IN_FILL_LEVEL  (0),
            .USE_OUT_FILL_LEVEL (0),
            .WR_SYNC_DEPTH      (2),
            .RD_SYNC_DEPTH      (2),
            .SYNC_RESET_N       (SYNC_RESET_N)
        ) gmii_decoder_dc_fifo_secc (
            
            .in_clk(clk_gmii),
            .in_reset_n(~reset_gmii),

            .out_clk(clk_mac),
            .out_reset_n(~reset_mac),

            // sink
            .in_data(gmii_avst_data),
            .in_valid(gmii_avst_valid & rx_clkena),
            .in_ready(),
            .in_startofpacket(gmii_avst_sop),
            .in_endofpacket(gmii_avst_eop),
            .in_error(gmii_avst_err),

            // source
            .out_data(avst_data_8b),
            .out_valid(avst_valid_8b),
            .out_ready(avst_ready_8b),
            .out_startofpacket(avst_sop_8b),
            .out_endofpacket(avst_eop_8b),
            .out_error(avst_err_8b),


            // streaming in status
            .almost_full_valid(),
            .almost_full_data(),

            // streaming out status
            .almost_empty_valid(),
            .almost_empty_data(),
            
            // ECC status
            .ecc_err_corrected(gmii_decoder_ecc_err_corrected),
            .ecc_err_detected(),
            .ecc_err_fatal(gmii_decoder_ecc_err_fatal)

        );
        
    end
else if(USE_DC_FIFO && ENABLE_MEM_ECC)
    begin: dc_fifo_hard_ecc_gen
        alt_em10g32_avalon_dc_fifo_hecc #(
            .SYMBOLS_PER_BEAT   (1),
            .BITS_PER_SYMBOL    (8),
            .FIFO_DEPTH         (16),
            .CHANNEL_WIDTH      (0),
            .ERROR_WIDTH        (1),
            .USE_PACKETS        (1),
            .USE_IN_FILL_LEVEL  (0),
            .USE_OUT_FILL_LEVEL (0),
            .WR_SYNC_DEPTH      (2),
            .RD_SYNC_DEPTH      (2),
            .SYNC_RESET_N       (SYNC_RESET_N)
        ) gmii_decoder_dc_fifo_hecc (
            
            .in_clk(clk_gmii),
            .in_reset_n(~reset_gmii),

            .out_clk(clk_mac),
            .out_reset_n(~reset_mac),

            // sink
            .in_data(gmii_avst_data),
            .in_valid(gmii_avst_valid & rx_clkena),
            .in_ready(),
            .in_startofpacket(gmii_avst_sop),
            .in_endofpacket(gmii_avst_eop),
            .in_error(gmii_avst_err),

            // source
            .out_data(avst_data_8b),
            .out_valid(avst_valid_8b),
            .out_ready(avst_ready_8b),
            .out_startofpacket(avst_sop_8b),
            .out_endofpacket(avst_eop_8b),
            .out_error(avst_err_8b),


            // streaming in status
            .almost_full_valid(),
            .almost_full_data(),

            // streaming out status
            .almost_empty_valid(),
            .almost_empty_data(),
            
            // ECC status
            .ecc_err_corrected(gmii_decoder_ecc_err_corrected),
            .ecc_err_fatal(gmii_decoder_ecc_err_fatal)

        );
        
    end
else begin : rr_cc_gen
        
        alt_em10g32_rr_clock_crosser #(
            .NUM_OF_CHANNEL     (7),
            
            .SYMBOLS_PER_BEAT   (1),
            .BITS_PER_SYMBOL    (8),
            .CHANNEL_WIDTH      (0),
            .ERROR_WIDTH        (1),
            .USE_PACKETS        (1),
            
            .FORWARD_SYNC_DEPTH (3),
            .BACKWARD_SYNC_DEPTH(3),
            .SYNC_RESET_N       (SYNC_RESET_N)
        ) gmii_decoder_rr_clock_crosser (
            
            .in_clk(clk_gmii),
            .in_reset_n(~reset_gmii),

            .out_clk(clk_mac),
            .out_reset_n(~reset_mac),

            // sink
            .in_data(gmii_avst_data),
            .in_valid(gmii_avst_valid & rx_clkena),
            .in_ready(),
            .in_startofpacket(gmii_avst_sop),
            .in_endofpacket(gmii_avst_eop),
            .in_error(gmii_avst_err),
            .in_empty(1'b0),
            .in_channel(1'b0),

            // source
            .out_data(avst_data_8b),
            .out_valid(avst_valid_8b),
            .out_ready(avst_ready_8b),
            .out_startofpacket(avst_sop_8b),
            .out_endofpacket(avst_eop_8b),
            .out_error(avst_err_8b),
            .out_empty(),
            .out_channel()
            
        );
        
        assign gmii_decoder_ecc_err_corrected = 1'b0;
        assign gmii_decoder_ecc_err_fatal = 1'b0;
    end
endgenerate
   
//////////////////////////////////////
// Data Format Adapter              //
// RX uCore <= AVST-64 <= AVST-8    //
//////////////////////////////////////

   alt_em10g32_rx_gmii_decoder_dfa dfa (

      .clk(clk_mac),
      .reset_n(~reset_mac),
      
      // Interface: in
      .in_ready(avst_ready_8b),
      .in_valid(avst_valid_8b),
      .in_data(avst_data_8b),
      .in_error(avst_err_8b & avst_valid_8b),
      .in_startofpacket(avst_sop_8b & avst_valid_8b),
      .in_endofpacket(avst_eop_8b & avst_valid_8b),
      
      
      // Interface: out
      .out_ready(1'b1),
      .out_valid(rxdata_src_valid),
      .out_data(rxdata_src_data),
      .out_error(rxdata_src_error),
      .out_startofpacket(rxdata_src_sop),
      .out_endofpacket(rxdata_src_eop),
      .out_empty(rxdata_src_empty)
      
   );


endmodule
