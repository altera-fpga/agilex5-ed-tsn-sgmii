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


//
// Template for UVM-compliant verification environment
//

`include "mstr_slv_src.incl"
`include "eth_env_cfg.sv"
`include "eth_scoreboard.sv"
`include "eth_env_cov.sv"
`include "altera_data_swip_eth_mac_frame_c.sv"
`include "altera_data_swip_eth_xgmii_ddr_trans_c.sv"
`include "altera_coverage_swip_eth_xgmii_ddr_c.sv"
`include "altera_coverage_swip_eth_mac_frame_mgbaset_c.sv"
//`include "eth_dr_cov.sv"
 `include "eth_rx_mac_cov.sv" 
 `include "parameter_sweep_cov.sv"
`include "mon_2cov.sv"
//`include "eth_scoreboard_link_fault.sv" kanishks: commented for compilation
