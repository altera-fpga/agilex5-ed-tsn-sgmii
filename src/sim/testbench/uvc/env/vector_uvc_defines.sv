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


//==============================================================================
// (C) 2011-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
// $File: /data/jbharatk/softip/acds/main/regtest/ip/ethernet/alt_ethernet/testbench/uvc/env $
// $Revision: #1 $
// $Date: 2017/8/9 $
// $Author: jbharatk $
//==============================================================================

//STATUS VECTOR DATA
`define PAYLOAD_LENGTH_START     0 
`define PAYLOAD_LENGTH_END      15 
`define FRAME_LENGTH_START      16 
`define FRAME_LENGTH_END        31 
`define S_VLAN_FRAME            32 // Stacked VLAN
`define R_VLAN_FRAME            33 // VLAN
`define CONTROL_FRAME           34
`define PAUSE_FRAME             35 // SFC/PFC
`define BRAODCAST_FRAME         36 
`define MULTICAST_FRAME         37
`define UNICAST_FRAME           38 
`define FLOWCONTROL_FRAME       35 // FC 
`define ILLEGAL_LT_FRAME        38 // Illegal lrngth type frame (38) 
`define PFC_FRAME               39 // ethertye that was non FC

//TX STATUS VECTOR ERROR
`define TX_UNDERSIZED_ERROR          0 
`define TX_OVERSIZED_ERROR           1
`define TX_LENGTH_ERROR              2
`define TX_UNDERFLOW_ERROR_STATUS    4 
`define TX_CLIENT_ERROR              5 

//RX STATUS VECTOR ERROR
`define RX_PHY_ERROR             6
`define RX_CRC_ERROR             3 
`define RX_UNDERSIZED_ERROR      0 
`define RX_OVERSIZED_ERROR       1  
`define RX_LENGTH_ERROR          2 
