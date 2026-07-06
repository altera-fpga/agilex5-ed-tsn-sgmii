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


//==============================================================================
// Cover Properties
//==============================================================================
/*/////////////////////////////////////////////////////////////*/
/* TODO: Put coverage properties for this module here.         */
/*/////////////////////////////////////////////////////////////*/
// <<example>>: `altuvm_sva_cover(LABEL2, signal_a && !signal_b)
//------------------------------------------------------------------------------
// Macro: altuvm_sva_cover
// Macro for assertion coverage which synchronized with CLK and disabled when
// RST is true
//
//|`altuvm_sva_cover(LBL, EXPR, CLK=sva_event, RST=(sva_reset), MSG="")
//
// Example use cases:
//(code)
//`altuvm_sva_cover(D_IsThePastOf_Q, (q == $past(d))
//`altuvm_sva_cover(D_IsThePastOf_Q, (q == $past(d), (posedge myclk))
//`altuvm_sva_cover(D_IsThePastOf_Q, (q == $past(d),, (!myreset))
//`altuvm_sva_cover(D_IsThePastOf_Q,
//   (q == $past(d),,, $sformatf("d=%0d, q=%0d", d, q))
//(end)

// No FCP yet

