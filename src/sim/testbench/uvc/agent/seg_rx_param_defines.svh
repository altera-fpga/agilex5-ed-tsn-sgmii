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
// Parameters definition that will be added into module's parameter definition.
//------------------------------------------------------------------------------
// CLIENT_RX parameters
`define CLIENT_RX__PARAM_ANSI \
   parameter                 DATA_WIDTH                              = client_rx_pkg::DEFAULT_DATA_WIDTH, \
   parameter                 EOP_EMPTY_WIDTH                         = client_rx_pkg::DEFAULT_EOP_EMPTY_WIDTH, \
   parameter                 RX_ERROR_WIDTH                          = client_rx_pkg::DEFAULT_RX_ERROR_WIDTH, \
   parameter                 IN_FRAME_WIDTH                          = client_rx_pkg::DEFAULT_IN_FRAME_WIDTH, \
   parameter                 NUM_WORDS                               = client_rx_pkg::NUM_WORDS, \
   parameter                 SKIP_CRC_WIDTH                          = client_rx_pkg::DEFAULT_SKIP_CRC_WIDTH, \
   parameter                 RX_STATUS_WIDTH                         = client_rx_pkg::DEFAULT_RX_STATUS_WIDTH, \
   parameter                 VLD_WIDTH                               = client_rx_pkg::DEFAULT_VLD_WIDTH