//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

//------------------------------------------------------------------------------
// Package: mux_pkg
//
// This package is imported to each UVM test or environment that uses the
// *mux* verification component.  The package is included
// using the following SystemVerilog statement:
//
//(code)
//   import mux_pkg::*;
//(end)
//
// Instead of importing the package, it is possible to refer to package
// members using the mux_pkg::member syntax.
//
//---------------------------------------------------------------------------
package mux_pkg;

   //---------------------------------------------------------------------------
   // Package and includes
   //---------------------------------------------------------------------------
   // UVM methodology
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   // ALTUVM methodology
   import altuvm_pkg::*;
   `include "altuvm_macros.svh"

   // Ethernet package
   import svt_uvm_pkg::*;
   import svt_ethernet_uvm_pkg::*;

   // AXI package
   import svt_uvm_pkg::*;
   import svt_axi_uvm_pkg::*;

   // ALTUVM CRU package
   import altuvm_cru_pkg::*;


   //---------------------------------------------------------------------------
   // Class type forward definition to avoid class include order dependency.
   //---------------------------------------------------------------------------
   //    NONE

   //---------------------------------------------------------------------------
   // Structured Type definition
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // UVC Classes
   //---------------------------------------------------------------------------
   `include "mux.svh"

   `include "mux_defines.svh"
   `include "mux_tb_defaults.svh"  // contains list of localparam
   `include "mux_tb_defines.svh"   // macros that associate with localparam
   `include "mux_eth_vip_defines.svh"

   `include "mux_env_inc.svh"
   `include "mux_seqlib_inc.svh"

endpackage : mux_pkg
