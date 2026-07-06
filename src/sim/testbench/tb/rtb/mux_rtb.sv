//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

//------------------------------------------------------------------------------
// Module: mux_rtb
//
// This module implements the top-level connection entity for MUX.
//
//------------------------------------------------------------------------------
`include "altuvm_macros.svh"
`include "mux_defines.svh"
`include "mux_tb_defines.svh"
`include "mux_eth_vip_defines.svh"

module mux_rtb #(
//VCS coverage off
      `MUX_RTB_PARAM_ANSI,
      // parameters IS_ACTIVE and DUT_PATH
      `altuvm_env_rtb_param_def
)(
);

   //---------------------------------------------------------------------------
   // Package and includes
   //---------------------------------------------------------------------------
   // UVM methology
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   // ALTUVM methology
   import altuvm_pkg::*;
   // Altera MUX package
   import mux_pkg::*;

   //---------------------------------------------------------------------------
   // Internal signals/variables
   //---------------------------------------------------------------------------
   // Instantiating Clock and Reset interface
   altuvm_cru_if #(`MUX_CRU_PARAM_INST) uif_cru();

   //---------------------------------------------------------------------------
   // RTB Instantiation
   //---------------------------------------------------------------------------
   // CRU RTB instantiation
   altuvm_cru_rtb #(
      `MUX_CRU_PARAM_INST,
      .IS_ACTIVE (uvm_active_passive_enum'(IS_ACTIVE)))
   cru_rtb (.uif (uif_cru));

   // Ethernet interface connection
   `include "eth_vip_mst_slv_connections.svh"

   // AXI interface connection
   `include "svt_axi_connections.svh"

   // RTB drive and monitor to drive/monitor individual pin
   `include "mux_rtb_drive_monitor.svh"

   // Configuration class's handle
   `altuvm_set_rtb_config_pre(mux_rtb_config)

   // Set IS_ACTIVE value and set DUT_PATH
   `altuvm_env_rtb_param_set

   // Assign the parameter value to variables in m_rtb_config
   `MUX_RTB_PARAM_SETCFG

   /*////////////////////////////////////////////////////////*/
   /* TODO: For string parameters, use enum type variable to */
   /*       capture the parameter value.                     */
   /*////////////////////////////////////////////////////////*/
   m_rtb_config.E_DEVICE_FAMILY = `altuvm_str2e(mux_pkg::device_e, DEVICE_FAMILY)

   `altuvm_set_rtb_config_post(mux_rtb_config)

endmodule : mux_rtb
