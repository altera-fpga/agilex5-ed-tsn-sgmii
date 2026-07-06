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


`ifndef __CLIENT_RX_PARAM_DEFAULTS_SVH__
`define __CLIENT_RX_PARAM_DEFAULTS_SVH__

   localparam                 DEFAULT_DATA_WIDTH                      = 64;
   localparam                 DEFAULT_EOP_EMPTY_WIDTH                 = 3;
   localparam                 DEFAULT_IN_FRAME_WIDTH                  = 1;
   localparam                 NUM_WORDS		                          = 4;
   localparam                 DEFAULT_SKIP_CRC_WIDTH                  = 1;
   localparam                 DEFAULT_VLD_WIDTH                       = 1;
   localparam                 DEFAULT_RX_ERROR_WIDTH                  = 2;
   localparam                 DEFAULT_RX_STATUS_WIDTH                 = 3;


`endif//__CLIENT_RX_PARAM_DEFAULTS_SVH__