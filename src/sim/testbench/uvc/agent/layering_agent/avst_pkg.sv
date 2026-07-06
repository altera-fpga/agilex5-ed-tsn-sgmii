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
//  (C) 2014 Altera Corporation. All rights reserved.
//
//  Your use of Altera Corporation's design tools, logic functions and other
//  software and tools, and its AMPP partner logic functions, and any output
//  files from any of the foregoing (including device programming or simulation
//  files), and any associated documentation or information are expressly
//  subject to the terms and conditions of the Altera Program License
//  Subscription Agreement, Altera MegaCore Function License Agreement, or
//  other applicable license agreement, including, without limitation, that
//  your use is for the sole purpose of programming logic devices manufactured
//  by Altera and sold by Altera or its authorized distributors.  Please refer
//  to the applicable agreement for further details.
//------------------------------------------------------------------------------
//  $Id:  $
//  $Change: 4057830 $
//  $Author:  $
//  $DateTime: 2015/09/08 16:01:26 $
//==============================================================================
//------------------------------------------------------------------------------
//  Package:  avst_pkg
//
//  The test package includes the environment and its subcomponents for
//  block-level verifying the Avalon-ST UVC.  The ST data types are also
//  defined here, and can be accessed wherever this package is imported.
//------------------------------------------------------------------------------
package altuvm_avalon_st_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import altuvm_pkg::*;
    `include "altuvm_macros.svh"
    import altuvm_avalon_st_pkg::*;
    `include "altuvm_avalon_st_macros.svh"
    `include "altuvm_avalon_st_tb_defaults.svh"

    //------------------------------------------------------------------------------
    //  Data Types
    //------------------------------------------------------------------------------
    typedef struct packed {
      //  bit  parity;
        bit [7:0] data;
    } my_symbol_t;
    `altuvm_avalon_st_uvc_decl(my_symbol_t, avst)
    //------------------------------------------------------------------------------
    //  Verification Environment
    //------------------------------------------------------------------------------
//    `include "altuvm_avalon_st_test_seqlib.svh"

endpackage : altuvm_avalon_st_test_pkg


