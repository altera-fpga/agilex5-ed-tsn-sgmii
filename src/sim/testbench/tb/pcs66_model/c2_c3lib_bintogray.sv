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


// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/c3lib/c2_c3lib_bintogray.sv $
// $Revision: #1 $
// $Date: 2016/08/22 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5 
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/c3lib_extra/c3_rtl/c3lib_bintogray.sv
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
//  Description :  Ported over from Nadder
//-----------------------------------------------------------------------------

module  c2_c3lib_bintogray #(

  parameter	WIDTH = 2 // Data width

) (

   // Inputs
   input  wire [WIDTH-1:0]	data_in,

   // Outputs
   output wire  [WIDTH-1:0]	data_out

);


assign data_out = (data_in>>1) ^ data_in;

endmodule

