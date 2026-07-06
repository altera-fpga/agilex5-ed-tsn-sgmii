//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

//------------------------------------------------------------------------------
// Include File: mux_env_inc
//
// Single include file which has all environment classes of MUX.
//
//------------------------------------------------------------------------------

`ifndef __MUX_ENV_INC_SVH__
`define __MUX_ENV_INC_SVH__

//---------------------------------------------------------------------------
// Class type forward definition to avoid include ordering dependencies
//---------------------------------------------------------------------------
typedef class mux_env;
//typedef class mux_ral;

//---------------------------------------------------------------------------
// UVC Classes
//---------------------------------------------------------------------------
`include "config/mux_plusargs.sv"
`include "config/mux_eth_agent_cfg.sv"
`include "config/mux_axi_agent_cfg.sv"
`include "mux_rtb_config.svh"
`include "mux_env_config.svh"
`include "mux_env_config_cov.svh"
`include "mux_comm_abstract.svh"
//`include "mux_reg_urm.svh"
//`include "mux_reg_urm_ext.svh"
//`include "mux_ral.svh"
`include "mux_scbd.svh"
`include "mux_cov.svh"
//
`include "../agent/eth_agent/mux_eth_driver.svh"
`include "eth_env/mux_eth_env.svh"
//
`include "mux_push_driver.svh"
`include "mux_env.svh"

`endif//__MUX_PKG_SV__
