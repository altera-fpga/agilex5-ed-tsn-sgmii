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


//------------------------------------------------------------------------------
// Include File: eth_f_ptp_tx_pkt_dly_assrt
//
// (White Box) Assertions declaration eth_f_ptp module.
//
//------------------------------------------------------------------------------
/*/////////////////////////////////////////////////////////////*/
/* TODO: Put assertion properties for this module here.        */
/*/////////////////////////////////////////////////////////////*/
// Example:
// sequence tx_wdly_done;
//      $rose(tx_apulse_wdly_valid);
// endsequence
// property SPTP_DT_VALUE_EQ_0_WHEN_INACTIVE;
//     (ENABLE_DT==0 & !samp_sync_rst) |->  (o_dt==32'h0 && o_dt_valid==1'b0);
// endproperty
// SPTP_DT_VALUE_EQ_0_WHEN_INACTIVE_CHECK_i: assert property (@(posedge i_samp_clk)SPTP_DT_VALUE_EQ_0_WHEN_INACTIVE) else `uvm_error("ERROR: [%dns] SPTP_DT_VALUE_EQ_0_WHEN_INACTIVE ENABLE_DT=0 case, dt/dt_valid is not zero!", $time);
