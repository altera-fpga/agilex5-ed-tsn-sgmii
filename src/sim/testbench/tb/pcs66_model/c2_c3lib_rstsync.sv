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


// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_c3lib_rstsync.sv $
// $Revision: #15 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5 
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/c3lib_rstsync.sv
// Date: Fri Mar 17 14:27:26 2017
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
//  Description :
// ****************************************************************************

module  c2_c3lib_rstsync #(

  parameter	RESET_VAL         = 0,		// Reset value is LOW if set to 0, otherwise HIGH
  parameter	DST_CLK_FREQ_MHZ  = 500	// Clock frequency for destination domain in MHz

) (

  input  logic		scan_mode_n,	// Scan mode control
  input  logic		clk,		// Clock to synchronize rst_n to
  input  logic		rst_n,		// Asynchronous reset
  input  logic		rst_n_bypass,	// PLD reset input in scan mode
  output logic		rst_n_sync	// Synchronized rst_n

);



// ****************************************************************************
//  V A R I A B L E S
// ****************************************************************************

var	logic	 rst_n_int;
var	logic	 rst_n_sync_int;



// ****************************************************************************
//  F U N C T I O N
// ****************************************************************************

assign rst_n_int = (scan_mode_n == 1'b0) ? rst_n_bypass : rst_n;

c2_c3lib_sync2_lvt_bitsync #(

  .DWIDTH	( 1 ),
  .RESET_VAL	( 0 )

) rstsync_synchronizer (

  .clk		( clk            ),
  .rst_n	( rst_n_int      ),
  .data_in	( 1'b1           ),
  .data_out	( rst_n_sync_int )

);

assign rst_n_sync = (scan_mode_n == 1'b0) ? rst_n_bypass : rst_n_sync_int;

endmodule

