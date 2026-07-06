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


// *****************************************************************************
// This confidential and proprietary software may be used only as authorized by 
// a licensing agreement from ALTERA                                            
// copyright notice must be reproduced on all authorized copies.                
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Project Name:  Crete3                                   
//  Module Name :  c3lib_ckg_lvt_8x                                  
//  Author      :  tschebye                                   
//  Date        :  Thu May 12 10:45:17 2016                                 
//  Description :  Posetive edge clock gater (LVT, 8x drive strength)
// *****************************************************************************

module c2_c3lib_ckg_lvt_8x(

  tst_en,
  clk_en,
  clk,
  gated_clk

); 

input  		tst_en;
input  		clk_en;
input  		clk;
output 		gated_clk;

`ifdef INT_C3LIB_RTL_MODE

  var	logic	latch_d;
  var	logic	latch_q;

  // Formulate control signal
  assign latch_d = clk_en | tst_en;

  // Latch control signal
  always_latch if (~clk) latch_q <= latch_d;

  // Actual clk gating gate
  assign gated_clk = clk & latch_q;

`else

  CKLNQD4ALTBWP22P90ULVT uu_a16lvt16_ckg_a8(

    .TE	( tst_en    ),
    .E			( clk_en    ),
    .CP				( clk       ),
    .Q			( gated_clk )

  );


`endif

endmodule 


