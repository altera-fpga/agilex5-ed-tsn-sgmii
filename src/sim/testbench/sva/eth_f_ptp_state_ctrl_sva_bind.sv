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


//   rtl_module vip_module    instance_name
bind eth_f_ptp_state_ctrl  eth_f_ptp_state_ctrl_sva #(
    .ENABLE_DT          (ENABLE_DT),
    .PL                 (PL),
    .WORDS              (WORDS),
    .S_IDLE             (S_IDLE),
    .S_MEAS_WDLY        (S_MEAS_WDLY),
    .S_MEAS_DT          (S_MEAS_DT),
    .S_TOD_VALID_DOWN   (S_TOD_VALID_DOWN),
    .S_MEAS_TIME        (S_MEAS_TIME),
    .S_WAIT_USR_CALC    (S_WAIT_USR_CALC),
    .S_WAIT_TAMLOAD     (S_WAIT_TAMLOAD),
    .S_PTP_READY        (S_PTP_READY)
) i_eth_f_ptp_state_ctrl_bind (.*);