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
// Include File: eth_f_ptp_state_ctrl_assrt
//
// (White Box) Assertions declaration eth_f_ptp module.
//
//------------------------------------------------------------------------------
/*/////////////////////////////////////////////////////////////*/
/* TODO: Put assertion properties for this module here.        */
/*/////////////////////////////////////////////////////////////*/
property SPTP_NO_SIMUL_CNT_START_STOP;
    $rose(i_rst_n) |-> ##[1:$] !(count_start & count_stop & ~dly_total_count_valid);
endproperty
SPTP_NO_SIMUL_CNT_START_STOP_CHECK_i: assert property (@(posedge i_samp_clk)SPTP_NO_SIMUL_CNT_START_STOP) else `uvm_error($sformatf("%m"),"ERROR: SPTP_NO_SIMUL_CNT_START_STOP sampling counter start and stop asserts simultaneously!");

// SPTP_WDLY_AND_DT_DO_NOT_ASSERT_SIMUL asserted 
property SPTP_WDLY_AND_DT_DO_NOT_ASSERT_SIMUL;
    $rose(i_rst_n) |-> ##[1:$] !(calibrate_wdly_samp & calibrate_dt_samp);
endproperty
SPTP_WDLY_AND_DT_DO_NOT_ASSERT_SIMUL_CHECK_i: assert property (@(posedge i_samp_clk)SPTP_WDLY_AND_DT_DO_NOT_ASSERT_SIMUL) else `uvm_error($sformatf("%m"),"ERROR: SPTP_WDLY_AND_DT_DO_NOT_ASSERT_SIMUL wire delay and dt measurement switch assert simultaneously!");
