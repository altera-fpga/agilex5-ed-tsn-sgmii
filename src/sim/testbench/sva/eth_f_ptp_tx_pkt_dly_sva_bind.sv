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
bind eth_f_ptp_tx_pkt_dly  eth_f_ptp_tx_pkt_dly_sva #(
    .PKT_CYL          (PKT_CYL),
    .WORDS            (WORDS),
    .TX_PTP_DLY       (TX_PTP_DLY)
) i_eth_f_ptp_tx_pkt_dly_bind (.*);