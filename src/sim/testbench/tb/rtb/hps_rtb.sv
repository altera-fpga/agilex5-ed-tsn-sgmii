//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

//------------------------------------------------------------------------------
// Module: hps_rtb
//
// This module implements the top-level connection entity for TSN.
//
//------------------------------------------------------------------------------

module hps_rtb #(
//VCS coverage off
      `TSN_RTB_PARAM_ANSI,
      parameter IP_PATH = "uvm_test_top.m_env",
      parameter NUM_PHY = 1,
      //`include "hps_rtb_param_ansi.svh"
      // parameters IS_ACTIVE and DUT_PATH
      `altuvm_env_rtb_param_def
)(
      `include "hps_rtb_ports.svh"
);

   
   // UVM methology
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   // ALTUVM methology
   import altuvm_pkg::*;
   `include "altuvm_macros.svh"
   import altuvm_avalon_st_test_pkg::*;
   import altuvm_avalon_mm_test_pkg::*;

   import svt_uvm_pkg::*;

   import svt_axi_uvm_pkg::*;
   
   // Ethernet package
   import svt_uvm_pkg::*;
   import svt_ethernet_uvm_pkg::*;
   import svt_ethernet_enum_pkg::*;
   import tsn_pkg::*;
   import eth_env_pkg::*;

   //`include "hps_tcam_ppbb_rtl_inst.svh"
   //`include "hps_tcam_ppbb_rtb_inst.svh"

   //---------------------------------------------------------------------------
   // Internal signals/variables
   //---------------------------------------------------------------------------
   // Instantiating Clock and Reset interface
   //altuvm_cru_if #(`TSN_CRU_PARAM_INST) uif_cru();

   //---------------------------------------------------------------------------
   // RTB Instantiation
   //---------------------------------------------------------------------------
   // CRU RTB instantiation
   /*
   altuvm_cru_rtb #(
      `TSN_CRU_PARAM_INST,
      .IS_ACTIVE (uvm_active_passive_enum'(IS_ACTIVE)))
   cru_rtb (.uif (uif_cru));
   */
   //`include "hps_overrides.svh"
   // Ethernet interface connection
   //`include "eth_vip_mst_slv_connections.svh"
   `include "tsn_defines.svh"
   `include "tsn_tb_defines.svh"
   `include "avst_params_10G.sv"
   `include "avst_params_25G.sv"
   `include "avst_params_50G.sv"
   `include "avst_params_40G.sv"
   `include "avst_params_100G.sv"
   `include "params_avmm.sv"

   localparam NUM_INST = `NUM_INST;
   

   //`include "vip_clk_gen.sv" 
   `include "mac_rtl_inst.svh"
   `include "hps_mac_connection.svh"
   // AXI interface connection
   //`include "hps_svt_axi_connections.svh"
   //`include "axi_mstr_slv_connections.svh"
   // RTB drive and monitor to drive/monitor individual pin
   `include "hps_rtb_drive_monitor.svh"
   //`include "ppbb_sig_probe.svh"

   // Configuration class's handle
   `set_rtb_config_pre(hps_rtb_config)

   // Set IS_ACTIVE value and set DUT_PATH
   `altuvm_env_rtb_param_set

   // Assign the parameter value to variables in m_rtb_config
   `TSN_RTB_PARAM_SETCFG
   //`include "hps_rtb_param_setcfg.svh"

   /*////////////////////////////////////////////////////////*/
   /* TODO: For string parameters, use enum type variable to */
   /*       capture the parameter value.                     */
   /*////////////////////////////////////////////////////////*/
   //m_rtb_config.E_DEVICE_FAMILY = `altuvm_str2e(tsn_pkg::device_e, DEVICE_FAMILY)
   m_rtb_config.NUM_PHY = NUM_PHY;
   `altuvm_set_rtb_config_post(hps_rtb_config)

endmodule : hps_rtb
