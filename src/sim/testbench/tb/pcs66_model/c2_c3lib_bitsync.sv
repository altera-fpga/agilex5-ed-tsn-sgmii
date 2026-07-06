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


// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_c3lib_bitsync.sv $
// $Revision: #15 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5 
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/c3lib_bitsync.sv
// Date: Fri Mar 17 14:27:26 2017
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
//  Description :
//-----------------------------------------------------------------------------

module  c2_c3lib_bitsync #(

  parameter	DWIDTH            = 1,		// Width of bus to be sync'ed
  parameter	RESET_VAL         = 0,		// Reset value is LOW if set to 0, otherwise HIGH
  parameter	DST_CLK_FREQ_MHZ  = 500,	// Clock frequency for destination domain in MHz
  parameter	SRC_DATA_FREQ_MHZ = 100		// Average source data 'frequency' in MHz

) (

  input  logic				clk,
  input  logic				rst_n,
  input  logic [10:0] 			dst_clk_freq_mhz,
  input  logic [10:0] 			src_data_freq_mhz,

  input  logic[ (DWIDTH-1) : 0 ]	data_in,
  output logic[ (DWIDTH-1) : 0 ]	data_out

);
  reg [(DWIDTH-1):0] reset_ulvt_data_out;
  reg [(DWIDTH-1):0] reset_lvt_data_out;
  reg [(DWIDTH-1):0] set_ulvt_data_out;
  reg [(DWIDTH-1):0] set_lvt_data_out;


  generate


      if (RESET_VAL == 0) begin : ULVT_RESET
        c2_c3lib_sync2_reset_ulvt_gate u_c3lib_sync2_reset_ulvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk && (dst_clk_freq_mhz>500) ), .rst_n( rst_n), .data_in( data_in), .data_out( reset_ulvt_data_out ) );
      end
      else begin : ULVT_SET
        c2_c3lib_sync2_set_ulvt_gate u_c3lib_sync2_set_ulvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk && (dst_clk_freq_mhz>500) ), .rst_n( rst_n ), .data_in( data_in), .data_out( set_ulvt_data_out ) );
      end


      if (RESET_VAL == 0) begin : LVT_RESET
        c2_c3lib_sync2_reset_lvt_gate u_c3lib_sync2_reset_lvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk && !(dst_clk_freq_mhz>500) ), .rst_n( rst_n ), .data_in( data_in ), .data_out( reset_lvt_data_out ) );
      end
      else begin : LVT_SET
        c2_c3lib_sync2_set_lvt_gate u_c3lib_sync2_set_lvt_gate[ (DWIDTH-1) : 0 ] ( .clk( clk && !(dst_clk_freq_mhz>500) ), .rst_n( rst_n ), .data_in( data_in ), .data_out( set_lvt_data_out ) );
      end


  endgenerate

  assign data_out = ((reset_ulvt_data_out === {DWIDTH{1'bx}})?0:reset_ulvt_data_out )+
                    ((reset_lvt_data_out === {DWIDTH{1'bx}})?0:reset_lvt_data_out )+
		    ((set_ulvt_data_out === {DWIDTH{1'bx}})?0:set_ulvt_data_out) +
		    ((set_lvt_data_out === {DWIDTH{1'bx}})?0:set_lvt_data_out);


endmodule

