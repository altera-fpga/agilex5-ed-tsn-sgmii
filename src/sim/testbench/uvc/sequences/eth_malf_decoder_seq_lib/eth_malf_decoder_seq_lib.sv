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


`include "vip_error_base_sequence.sv"

//DM_TODO: Uncomment `include "vip_rx_short_random_frames.sv"
 
`include "vip_rx_short_random_frames_with_crc_pp_cov_seq.sv"
 
`include "vip_strict_sfd_sequence.sv"
 
`include "vip_strict_sfd_sequence_statson.sv"
 
`include "vip_malformed_packet_sequence.sv"
 
`include "vip_malformed_packet_sequence2.sv"
 
`include "vip_decoder_sequence1.sv"
 
`include "vip_decoder_sequence2.sv"
 
`include "vip_decoder_sequence15_25.sv"
 
`include "vip_decoder_sequence15_25_ext.sv"
 
`include "vip_decoder_sequence16_21.sv"
 
`include "vip_decoder_sequence28.sv"

`include "vip_decoder_sequence20_22_23.sv"
 
`include "vip_decoder_sequence24_26_27.sv"
 
`include "vip_decoder_sequence5_to_10.sv"

`include "vip_decoder_sequence11_to_14.sv"
 
`include "vip_decoder_sequence17_to_19.sv"

`include "vip_decoder_rand_sequence.sv"
