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
// $File: /data/jbharatk/softip/acds/main/regtest/ip/ethernet/alt_ethernet/testbench/uvc/agent $
// $Revision: #1 $
// $Date: 2017/8/9 $
// $Author: jbharatk $
//==============================================================================
//------------------------------------------------------------------------------
//  Package:  ptp_tx_pkg
//
//  package includes the ptp tx components 
//------------------------------------------------------------------------------
package ptp_tx_pkg;
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   `include "ptp_tx_tran.svh"
   `include "ptp_config.svh"
   `include "ptp_tod_drv_abstract.svh"
   `include "ptp_tod_drv.svh"
   `include "ptp_tx_monitor_abstract.svh"
   `include "ptp_tx_mon.svh" 
   `include "ptp_tx_agent.svh" 
   `include "ptp_tx_ref_model.svh"

endpackage : ptp_tx_pkg
