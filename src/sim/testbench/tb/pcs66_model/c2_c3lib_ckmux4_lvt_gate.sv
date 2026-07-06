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


// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_c3lib_ckmux4_lvt_gate.sv $
// $Revision: #13 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5 
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/c3lib_ckmux4_lvt_gate.sv
// Date: Thu Oct 13 09:52:18 2016
//-------------------------------------------------------------------------------
// *****************************************************************************
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
// *****************************************************************************
//  Description :  4-to-1 clock mux w/ no scan support
// *****************************************************************************

module c2_c3lib_ckmux4_lvt_gate(

  ck0,
  ck1,
  ck2,
  ck3,
  s0,
  s1,
  ck_out,

  // Scan IOs
  tst_override,
  tst_s0,
  tst_s1

);

// Functional IOs
input		ck0;
input		ck1;
input		ck2;
input		ck3;
input		s0;
input		s1;
output		ck_out;

// Scan IOs
input		tst_override;
input		tst_s0;
input		tst_s1;

`ifdef INT_C3LIB_RTL_MODE


  var	logic	int_fp_ck_out;
  var	logic	int_tst_ck_out;
  var	logic	int_ck_out;

  always_comb begin
    unique case ( { s1, s0 } )
      2'b00   : int_fp_ck_out = ck0;
      2'b01   : int_fp_ck_out = ck1;
      2'b10   : int_fp_ck_out = ck2;
      2'b11   : int_fp_ck_out = ck3;
      default : int_fp_ck_out = 1'bx;
    endcase
  end

  always_comb begin
    unique case ( { tst_s1, tst_s0 } )
      2'b00   : int_tst_ck_out = ck0;
      2'b01   : int_tst_ck_out = ck1;
      2'b10   : int_tst_ck_out = ck2;
      2'b11   : int_tst_ck_out = ck3;
      default : int_tst_ck_out = 1'bx;
    endcase
  end

  always_comb begin
    unique case ( { tst_override } )
      1'b0    : int_ck_out = int_fp_ck_out;
      1'b1    : int_ck_out = int_tst_ck_out;
      default : int_ck_out = 1'bx;
    endcase
  end
  assign ck_out = int_ck_out;

`else

CKMUX2D4ALTBWP22P90ULVT uu_ehip_ckmux0 (.S(s0), .I0(ck0), .I1(ck1), .Z(ck01));
CKMUX2D4ALTBWP22P90ULVT uu_ehip_ckmux1 (.S(s0), .I0(ck2), .I1(ck3), .Z(ck23));
CKMUX2D4ALTBWP22P90ULVT uu_ehip_ckmux2 (.S(s1), .I0(ck01), .I1(ck23), .Z(ck_out));

`endif

endmodule

