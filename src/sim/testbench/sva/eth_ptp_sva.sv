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
// SVA File: eth_ptp_sva
//
// Top (White Box) SVA file for eth_ptp that includes all
// sub-modules' SVA file.
//
//------------------------------------------------------------------------------
/*/////////////////////////////////////////////////////////////*/
/* TODO: List down all the modules' sva files here.            */
/*/////////////////////////////////////////////////////////////*/
//VCS coverage off

`include "gdra_gdr_xcvrif_sva.sv"
`include "gdra_gdr_xcvrif_assertions.sv"
`include "eth_f_ptp_sva.sv"
`include "eth_f_ptp_sva_bind.sv"
`include "eth_f_ptp_state_ctrl_sva.sv"
`include "eth_f_ptp_state_ctrl_sva_bind.sv"
`include "eth_f_ptp_async_dly_meas_sva.sv"
`include "eth_f_ptp_async_dly_meas_sva_bind.sv"
// no FCP yet  `include "eth_f_ptp_tx_tam_capture_sva.sv"
// no FCP yet  `include "eth_f_ptp_tx_tam_capture_sva_bind.sv"
// no FCP yet  `include "eth_f_ptp_rx_tam_capture_sva.sv"
// no FCP yet  `include "eth_f_ptp_rx_tam_capture_sva_bind.sv"
// no FCP yet  `include "eth_f_ptp_rollover_cnt_sva.sv"
// no FCP yet  `include "eth_f_ptp_rollover_cnt_sva_bind.sv"
`include "eth_f_ptp_convert_commands_sva.sv"
`include "eth_f_ptp_convert_commands_sva_bind.sv"
`include "eth_f_ptp_tam_adjust_load_sva.sv"
`include "eth_f_ptp_tam_adjust_load_sva_bind.sv"
`include "eth_f_ptp_tx_pkt_dly_sva.sv"
`include "eth_f_ptp_tx_pkt_dly_sva_bind.sv"
`include "eth_f_ptp_ts_converter_sva.sv"
`include "eth_f_ptp_ts_converter_sva_bind.sv"
`include "eth_f_ptp_rx_pkt_dly_sva.sv"
`include "eth_f_ptp_rx_pkt_dly_sva_bind.sv"
`include "eth_f_ptp_fp_ext_sva.sv"
`include "eth_f_ptp_fp_ext_sva_bind.sv"

//VCS coverage on
