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


`include "pcs_base_seq.svh"
//DM_TODO: uncomment `include "pcs_am_lock_loss_seq.svh"
//DM_TODO: uncomment `include "pcs_am_lock_negchk2_seq.svh"
//DM_TODO: uncomment `include "pcs_am_lock_negchk3_seq.svh"
//DM_TODO: uncomment `include "pcs_am_lock_negchk_seq.svh"
//DM_TODO: uncomment `include "pcs_bitslip_seq.svh"
`include "pcs_blk_lock_loss_seq.svh"
`include "pcs_cable_pull_no_data_seq.svh"
`include "pcs_cable_pull_rand_data_seq.svh"
//DM_TODO: uncomment `include "frame_size_dist_seq.svh"
//DM_TODO: uncomment //`include "pcs_dsk_limit_seq.svh"
//DM_TODO: uncomment //`include "pcs_dsk_limit_serial_seq.svh"
//DM_TODO: uncomment //`include "pcs_dsk_over_limit_seq.svh"
//DM_TODO: uncomment `include "pcs_dsk_seq.svh"
//DM_TODO: uncomment //`include "pcs_duplicate_am_seq.svh"
`include "pcs_err_during_lock_seq.svh"
//DM_TODO: uncomment `include "pcs_hiber_seq.svh"
`include "pcs_lock_on_data_seq.svh"
//DM_TODO: uncomment //`include "pcs_toggle_rxpma_rdy_seq.svh"
`include "pcs_wrong_am_interval_seq.svh"
//DM_TODO: uncomment //`include "frame_size_dist_stress_sequence.svh"
