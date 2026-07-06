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


// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_c3lib_mux2_ctn.sv $
// $Revision: #13 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5 
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/c3lib_mux2_ctn.sv
// Date: Fri Mar 17 14:27:26 2017
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
//  Description :  2-to-1 clock mux w/ support fro scan
// *****************************************************************************

module c2_c3lib_mux2_ctn(

  input  logic	ck0,
  input	 logic	ck1,
  input  logic	s0,
  output logic	ck_out

);

  c2_c3lib_ckmux4_lvt_gate c3lib_ckmux4_gate(

    // Functional IOs
    .ck0	( ck0    ),
    .ck1	( ck1    ),
    .ck2	( 1'b0   ),
    .ck3	( 1'b0   ),
    .s0		( s0     ),
    .s1		( 1'b0   ),
    .ck_out	( ck_out ),

    // Scan IOs
    .tst_override	( 1'b0 ),
    .tst_s0		( 1'b0 ),
    .tst_s1		( 1'b0 )

  );

endmodule

