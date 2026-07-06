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
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//------------------------------------------------------------------------------
// TB/UVC Skeleton is created by: utbgen.pl by Hoong Han Leong
//==============================================================================

//------------------------------------------------------------------------------
// Package: client_tx_pkg
//
// This package is imported to each UVM test or environment that uses the
// *client_tx* verification component.  The package is included
// using the following SystemVerilog statement:
//
//(code)
//   import client_tx_pkg::*;
//(end)
//
// Instead of importing the package, it is possible to refer to package
// members using the client_tx_pkg::member syntax.
//
//---------------------------------------------------------------------------

package client_tx_pkg;
   //
   //  Include common library packages.
   //
   import uvm_pkg::*;
   `include "uvm_macros.svh"
 
    
   //
   //  Package-wide constant definitions.
   //
   localparam string DEFAULT_CLIENT_TX_MSG_PREFIX = "CLIENT_TX";
   //
   // Enum:  client_tx_trans_e
   //
   // The type of transaction to or from the CLIENT_TX bus.
   //
   // CLIENT_TX_READ  - Read operation (a single burst)
   // CLIENT_TX_WRITE - Write operation (a single burst)
   //
   typedef enum { CLIENT_TX_READ, CLIENT_TX_WRITE } client_tx_trans_e;

   //------------------------------------------------------------------------
   // Class forward definition
   //------------------------------------------------------------------------
  // typedef class client_tx_agent;
   //typedef class client_tx_tran;

   //------------------------------------------------------------------------
   // Package and includes
   //------------------------------------------------------------------------
   `include "seg_tx_param_defaults.svh"
   `include "seg_tx_param_defines.svh"
   /*
   `include "seg_tx_driver.svh"
   `include "seg_tx_driver_abstract.svh"
   `include "seg_tx_monitor.svh"
   `include "seg_tx_monitor_abstract.svh"
   `include "seg_tx_rtb_module.sv"
   `include "seg_tx_agent.svh"
*/
endpackage : client_tx_pkg
