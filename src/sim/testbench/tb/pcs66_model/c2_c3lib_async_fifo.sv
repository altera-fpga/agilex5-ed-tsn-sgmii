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


// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/c3lib/c2_c3lib_async_fifo.sv $
// $Revision: #1 $
// $Date: 2016/08/22 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5 
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/c3lib_extra/c3_rtl/c3lib_async_fifo.sv
// Date: Wed Aug 17 11:11:55 2016
//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//-----------------------------------------------------------------------------
//  Description :  async_fifo ported over from Nadder
//-----------------------------------------------------------------------------

module  c2_c3lib_async_fifo #(

  parameter DWIDTH		= 8,	// FIFO Input data width
  parameter AWIDTH		= 4,	// FIFO Depth (address width)
  parameter DST_CLK_FREQ_MHZ	= 500,	// Clock frequency for destination domain in MHz
  parameter SRC_CLK_FREQ_MHZ	= 500	// Clock frequency for source domain in MHz

) (

    input  wire                   wr_rst_n,     // Write Domain Active low Reset
    input  wire                   wr_clk,       // Write Domain Clock
    input  wire                   wr_en,        // Write Data Enable
    input  wire [1055:0]          wr_data,      // Write Data In
    input  wire [10:0]            dst_clk_freq_mhz,
    input  wire [10:0]            src_clk_freq_mhz,
    input  wire                   rd_rst_n,     // Read Domain Active low Reset
    input  wire                   rd_clk,       // Read Domain Clock
    input  wire                   rd_en,        // Read Data Enable
    input  wire [AWIDTH-1:0]      r_pempty,     // FIFO partially empty threshold
    input  wire [AWIDTH-1:0]      r_pfull,      // FIFO partially full threshold
    input  wire [AWIDTH-1:0]      r_empty,      // FIFO empty threshold
    input  wire [AWIDTH-1:0]      r_full,       // FIFO full threshold

    output wire [1055:0]          rd_data,      // Read Data Out
    output wire [AWIDTH-1:0]      rd_numdata,   // Number of Data available in Read clock
    output wire [AWIDTH-1:0]      wr_numdata,   // Number of Data available in Write clock

    output reg                    wr_empty,     // FIFO Empty
    output reg                    wr_pempty,    // FIFO Partial Empty
    output reg                    wr_full,      // FIFO Full
    output reg                    wr_pfull,     // FIFO Parial Full
    output reg                    rd_empty,     // FIFO Empty
    output reg                    rd_pempty,    // FIFO Partial Empty
    output reg                    rd_full,      // FIFO Full
    output reg                    rd_pfull     // FIFO Partial Full
     );

   //********************************************************************
   // Define variables
   //********************************************************************
   integer                   m;
   // Regs
   reg [1055:0]              fifo_mem [((1<<AWIDTH)-1):0];
   reg [AWIDTH:0]            wr_addr_bin;
   reg [AWIDTH:0]            rd_addr_bin;

   reg [AWIDTH:0]            wr_addr_gry;
   reg [AWIDTH:0]            rd_addr_gry;

   // Wires
   wire [AWIDTH-1:0]         wr_addr_mem;
   wire [AWIDTH-1:0]         rd_addr_mem;

   wire [AWIDTH:0]           wr_addr_bin_nxt;
   wire [AWIDTH:0]           rd_addr_bin_nxt;
   wire [AWIDTH:0]           wr_addr_gry_nxt;
   wire [AWIDTH:0]           rd_addr_gry_nxt;
   wire [AWIDTH:0]           wr_addr_bin_sync;
   wire [AWIDTH:0]           rd_addr_bin_sync;
   wire [AWIDTH:0]           wr_addr_gry_sync;
   wire [AWIDTH:0]           rd_addr_gry_sync;


   //********************************************************************
   // Infer Memory or use Dual Port Memory from Quartus/ASIC Memory
   //********************************************************************

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         for (m='d0; m<=((1<<AWIDTH)-1'b1); m=m+1'b1) begin
            fifo_mem[m] <= 'd0;
         end
      end
//      else if (wr_srst_n == 1'b0) begin
//         for (m='d0; m<=((1<<AWIDTH)-1'b1); m=m+1'b1) begin
//            fifo_mem[m] <= 'd0;
//         end
//      end
   // Add option to allow write when full
      else if (wr_en && ~wr_full) begin
         fifo_mem[wr_addr_mem] <= wr_data;
      end
   end

   assign rd_data = fifo_mem[rd_addr_mem];



   //********************************************************************
   // WRITE CLOCK DOMAIN: Generate WRITE Address & WRITE Address GREY
   //********************************************************************
   // Memory write-address pointer
   assign wr_addr_mem = wr_addr_bin[AWIDTH-1:0];
   always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      wr_addr_bin <= {(AWIDTH+1){1'b0}};
      wr_addr_gry <= {(AWIDTH+1){1'b0}};
   end
   else begin
      wr_addr_bin <= wr_addr_bin_nxt;
      wr_addr_gry <= wr_addr_gry_nxt;
   end
   end
   // Binary Next Write Address
   assign wr_addr_bin_nxt = wr_addr_bin + (wr_en & ~wr_full);

   // Grey Next Write Address
//   assign wr_addr_gry_nxt = ((wr_addr_bin_nxt>>1) ^ wr_addr_bin_nxt);

   c2_c3lib_bintogray #(

     .WIDTH	( AWIDTH+1 )

   ) wr_addr_nxt_bintogray (

      .data_in	( wr_addr_bin_nxt ),
      .data_out	( wr_addr_gry_nxt )

   );



   //********************************************************************
   // WRITE CLOCK DOMAIN: Synchronize Read Address to Write Clock
   //********************************************************************

    c2_c3lib_bitsync #(

      .DWIDTH		( AWIDTH+1 ),
      .RESET_VAL	( 0 ),
      .DST_CLK_FREQ_MHZ	( SRC_CLK_FREQ_MHZ ),
      .SRC_DATA_FREQ_MHZ( DST_CLK_FREQ_MHZ/4 )

    ) rd_addr_bitsync (

       .clk              (wr_clk),
       .rst_n            (wr_rst_n),
       .dst_clk_freq_mhz (src_clk_freq_mhz),
       .src_data_freq_mhz(dst_clk_freq_mhz/4),
       .data_in          (rd_addr_gry),
       .data_out         (rd_addr_gry_sync)

    );

//   assign rd_addr_bin_sync = greytobin(rd_addr_gry_sync);

   c2_c3lib_graytobin #(

      .WIDTH	( AWIDTH+1 )

    ) rd_addr_graytobin (

      .data_in	( rd_addr_gry_sync ),
      .data_out	( rd_addr_bin_sync )

    );

   assign wr_numdata       = (wr_addr_bin_nxt - rd_addr_bin_sync);

   //********************************************************************
   // WRITE CLOCK DOMAIN: Generate Fifo Number of Data Present
   // using Write Address and Synchronized Read Address
   //********************************************************************
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         wr_full  <= 1'b0;
         wr_pfull <= 1'b0;
         wr_empty <= 1'b1;
         wr_pempty<= 1'b1;
      end
      else begin

         // Generate FIFO Empty
         wr_empty  <= (wr_numdata <= r_empty) ? 1'b1 : 1'b0;
         // Generate FIFO Almost Empty
         wr_pempty <= (wr_numdata <= r_pempty) ? 1'b1 : 1'b0;
         // Generate FIFO Full
         wr_full   <= (wr_numdata >= r_full) ? 1'b1 : 1'b0;
         // Generate FIFO Almost Full
         wr_pfull  <= (wr_numdata >= r_pfull) ? 1'b1 : 1'b0;

      end
   end

   //********************************************************************
   // READ CLOCK DOMAIN: Generate READ Address & READ Address GREY
   //********************************************************************
   // Memory read-address pointer
   assign rd_addr_mem = rd_addr_bin[AWIDTH-1:0];

   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_addr_bin <= {(AWIDTH+1){1'b0}};
         rd_addr_gry <= {(AWIDTH+1){1'b0}};
      end
      else begin
         rd_addr_bin <= rd_addr_bin_nxt;
         rd_addr_gry <= rd_addr_gry_nxt;
      end
   end
   // Binary Next Read Address
   assign rd_addr_bin_nxt = rd_addr_bin + (rd_en & ~rd_empty);

   // Grey Next Read Address
   c2_c3lib_bintogray #(

      .WIDTH	( AWIDTH+1 )

    ) rd_addr_nxt_bintogray (

      .data_in	( rd_addr_bin_nxt ),
      .data_out	( rd_addr_gry_nxt )

    );


   //********************************************************************
   // READ CLOCK DOMAIN: Synchronize Write Address to Read Clock
   //********************************************************************

    c2_c3lib_bitsync #(

      .DWIDTH		( AWIDTH+1 ),
      .RESET_VAL	( 0 ),
      .DST_CLK_FREQ_MHZ	( DST_CLK_FREQ_MHZ ),
      .SRC_DATA_FREQ_MHZ( SRC_CLK_FREQ_MHZ/4 )

    ) wr_addr_bitsync (

          .clk              (rd_clk),
          .rst_n            (rd_rst_n),
          .dst_clk_freq_mhz (src_clk_freq_mhz),
          .src_data_freq_mhz(dst_clk_freq_mhz/4),
          .data_in          (wr_addr_gry),
          .data_out         (wr_addr_gry_sync)

    );

   c2_c3lib_graytobin #(

      .WIDTH	( AWIDTH+1 )

    ) wr_addr_graytobin (

      .data_in	( wr_addr_gry_sync ),
      .data_out	( wr_addr_bin_sync )

    );

   assign rd_numdata       = (wr_addr_bin_sync - rd_addr_bin_nxt);

   //********************************************************************
   // READ CLOCK DOMAIN: Generate Fifo Number of Data Present
   // using Read Address and Synchronized Write Address
   //********************************************************************
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_empty    <= 1'b1;
         rd_pempty   <= 1'b1;
         rd_full     <= 1'b0;
         rd_pfull    <= 1'b0;
      end
      else begin
         // Generate FIFO Empty
         rd_empty    <= (rd_numdata <= r_empty) ? 1'b1 : 1'b0;
         // Generate FIFO Almost Empty
         rd_pempty   <= (rd_numdata <= r_pempty) ? 1'b1 : 1'b0;
         // Generate FIFO Full
         rd_full     <= (rd_numdata >= r_full) ? 1'b1 : 1'b0;
         // Generate FIFO Almost Full
         rd_pfull    <= (rd_numdata >= r_pfull) ? 1'b1 : 1'b0;

      end
   end

endmodule // c3lib_async_fifo







