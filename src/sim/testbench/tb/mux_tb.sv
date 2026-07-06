//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_TB_SV__
`define __MUX_TB_SV__

//------------------------------------------------------------------------------
// Include File: mux_tb
//
// Implementation of MUX top testbench (to top_tb module).
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Interface instantiation
//------------------------------------------------------------------------------
// Instantiating Clock and Reset interface
// Is it needed??
// altuvm_cru_if #(`MUX_CRU_PARAM_INST) uif_cru();

//------------------------------------------------------------------------------
// RTB instantiation
//------------------------------------------------------------------------------
mux_rtb #(
   `MUX_RTB_PARAM_INST,
   .IS_ACTIVE        (uvm_pkg::UVM_ACTIVE),
   .DUT_PATH         ("top_tb.dut.dut") // FIXME: modify this when we have the DUT 
) rtb (
//<<TO BE UNCOMMENTED>>   .spy_if  (dut.i_mux_spy.uif),
   .*
);

tsn_shell tsn_dut();
//------------------------------------------------------------------------------
// DUT Instantiation Here
//------------------------------------------------------------------------------

`endif//__MUX_TB_SV__
