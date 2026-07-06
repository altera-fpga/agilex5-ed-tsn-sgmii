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
// (C) 2011-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
// $File: //depot/altuvm/rel/0.8/product/altuvm_avalon_mm/testbench/altuvm_avalon_mm_test_pkg.sv $
// $Revision: #1 $
// $Date: 2015/09/08 $
// $Author: abmpkhan $
//==============================================================================

//------------------------------------------------------------------------------
// Package: altuvm_avalon_mm_test_pkg
//
// This file describes the package that bundles the Avalon-MM agent
// unit test environment.
//
//------------------------------------------------------------------------------
package altuvm_avalon_mm_test_pkg;
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   import altuvm_pkg::*;
   `include "altuvm_macros.svh"

   import altuvm_avalon_mm_pkg::*;

   //
   // Testbench constants
   //
   `include "altuvm_avalon_mm_tb_defaults.svh"

   //
   // Forward Declarations
   //
 //  typedef class altuvm_avalon_mm_env_config;
 //  typedef class altuvm_avalon_mm_scoreboard;
 //  typedef class altuvm_avalon_mm_env;
   //
   // Environment, Components, and Test Library
   //
  // `include "altuvm_avalon_mm_env_config.svh"
  // `include "altuvm_avalon_mm_scoreboard.svh"
 //  `include "altuvm_avalon_mm_env.svh"
 //  `include "altuvm_avalon_mm_test_seqlib.svh"
   //
   // Test Library
   //
  // `include "base_test.svh"
  // `include "config_test.svh"
 //  `include "simple_test.svh"
 //  `include "pipelined_test.svh"
 //  `include "byte_enables_test.svh"

endpackage : altuvm_avalon_mm_test_pkg
