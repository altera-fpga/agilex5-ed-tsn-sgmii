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


// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_c3lib_vecsync.sv $
// $Revision: #15 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5 
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/c3lib_vecsync.sv
// Date: Mon Aug 22 11:25:52 2016
//-------------------------------------------------------------------------------
// ****************************************************************************
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
// ****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
// ****************************************************************************
//  Description :  C3 lib vector synchronizer
// ****************************************************************************

module  c2_c3lib_vecsync #(

  parameter	DWIDTH            = 1,		// Width of bus to be sync'ed
  parameter	RESET_VAL         = 0,		// Reset value is LOW if set to 0, otherwise HIGH
  parameter	SRC_CLK_FREQ_MHZ  = 500,	// Clock frequency for source domain (i.e. WR) in MHz
  parameter	DST_CLK_FREQ_MHZ  = 500		// Clock frequency for destination domain (i.e. RD) in MHz

) (

  input  logic				wr_clk,
  input  logic				wr_rst_n,
  input  logic				rd_clk,
  input  logic				rd_rst_n,

  input  logic[ (DWIDTH-1) : 0 ]	data_in,
  output logic[ (DWIDTH-1) : 0 ]	data_out

);



// ****************************************************************************
//  Defines
// ****************************************************************************

localparam SRC_DATA_FREQ_MHZ = (SRC_CLK_FREQ_MHZ*DST_CLK_FREQ_MHZ)/(SRC_CLK_FREQ_MHZ+2*DST_CLK_FREQ_MHZ) + 1;



// ****************************************************************************
//  Variables
// ****************************************************************************

var	logic[ (DWIDTH-1) : 0 ]		data_in_d1;
var	logic				req_wr_clk;
var	logic				req_rd_clk;
var	logic				req_rd_clk_d1;
var	logic				ack_wr_clk;
var	logic				ack_rd_clk;
var	logic				reset_bit_val;



// ****************************************************************************
//  Reset value
// ****************************************************************************

generate
  if (RESET_VAL == 0)
    assign reset_bit_val = 1'b0;
  else
    assign reset_bit_val = 1'b1;
endgenerate



// ****************************************************************************
//  Latch incoming data & generate / process handshake with RD side
// ****************************************************************************

always @(negedge wr_rst_n or posedge wr_clk) begin

  if (!wr_rst_n) begin
    req_wr_clk <= 1'b0;
    data_in_d1 <= { DWIDTH { reset_bit_val } };
  end

  else begin
    req_wr_clk <= ((req_wr_clk == ack_wr_clk) & (data_in_d1 != data_in))? ~req_wr_clk : req_wr_clk;
    data_in_d1 <= (req_wr_clk == ack_wr_clk)? data_in : data_in_d1;
  end

end



// ****************************************************************************
//  Synchonize handskake
// ****************************************************************************

// Sending requets from wr clk domain to rd clk domain
c2_c3lib_bitsync #(

  .DWIDTH		( 1                 ),
  .RESET_VAL		( 0                 ),
  .DST_CLK_FREQ_MHZ	( DST_CLK_FREQ_MHZ  ),
  .SRC_DATA_FREQ_MHZ	( SRC_DATA_FREQ_MHZ )

) request_synchronizer_rd_clk (

  .clk		( rd_clk     ),
  .rst_n	( rd_rst_n   ),
  .data_in	( req_wr_clk ),
  .data_out	( req_rd_clk )

);

// Sending acknowledgement from rd clk domain to wr clk domain
c2_c3lib_bitsync #(

  .DWIDTH		( 1                 ),
  .RESET_VAL		( 0                 ),
  .DST_CLK_FREQ_MHZ	( SRC_CLK_FREQ_MHZ  ),
  .SRC_DATA_FREQ_MHZ	( SRC_DATA_FREQ_MHZ )

) acknowledgement_synchronizer_wr_clk (

  .clk		( wr_clk     ),
  .rst_n	( wr_rst_n   ),
  .data_in	( ack_rd_clk ),
  .data_out	( ack_wr_clk )

);



// ****************************************************************************
//  Latch outgoing data & generate / process handshake with WR side
// ****************************************************************************

assign ack_rd_clk = req_rd_clk;

always @(negedge rd_rst_n or posedge rd_clk) begin

  if (!rd_rst_n) begin
    req_rd_clk_d1 <= 1'b0;
    data_out      <= { DWIDTH { reset_bit_val } };
  end

  else begin
    req_rd_clk_d1 <= req_rd_clk;
    data_out      <= (req_rd_clk_d1 != req_rd_clk)? data_in_d1 : data_out;
  end

end



endmodule

