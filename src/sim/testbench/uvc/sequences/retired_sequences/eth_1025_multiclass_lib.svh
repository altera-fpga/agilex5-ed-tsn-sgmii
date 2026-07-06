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


`MULTICLASS(eth1025_sanity_sequence)
`MULTICLASS(eth1025_tx_padding_sequence)
`MULTICLASS(eth1025_rx_padding_sequence)
`MULTICLASS(preamble1025_pass_sequence)
`MULTICLASS(crc1025_pass_sequence)
`MULTICLASS(rx_crc1025_pass_sequence)
`MULTICLASS(fc1025_rand_seq)
`MULTICLASS(vip1025_sanity_sequence)
`MULTICLASS(eth1025_register_ip_hard_reset_sequence)
`MULTICLASS(eth1025_register_access_sequence_1)
`MULTICLASS(eth1025_register_access_sequence_2)
`MULTICLASS(eth1025_register_access_sequence_3)
`MULTICLASS(eth1025_register_access_sequence_4)
`MULTICLASS(eth1025_register_access_sequence_reset)
`MULTICLASS(bandwidth1025_sequence)
`MULTICLASS(fixed1025_stress_sequence)
`MULTICLASS(updown1025_stress_sequence)
`MULTICLASS(fb1025_495115_hard_rst_seq)
`MULTICLASS(fb1025_495115_soft_rst_seq)
`MULTICLASS(jumbo_frame_sequences)

`ifdef ENABLE_ETH_VIP
`MULTICLASS(eth1025_rxmax_payload_frame_sequence)
`MULTICLASS(eth1025_txmax_payload_frame_sequence)
`MULTICLASS(eth1025_ipg_sequence)
`MULTICLASS(vip1025_error_base_sequence)
`MULTICLASS(vip1025_strict_sfd_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
//`MULTICLASS(bandwidth1025_sequence)
`endif
