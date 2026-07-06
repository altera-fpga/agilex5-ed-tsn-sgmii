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





`ifndef RESET_IF__SV
`define RESET_IF__SV

interface reset_if(); 

   parameter setup_time = 5/*ns*/;
   parameter hold_time  = 3/*ns*/;

   logic       tx_rst_n;
   logic       rx_rst_n;
   logic       mac_tx_rst_n;
   logic       mac_rx_rst_n;
   logic       mac_rst_n;
   logic       csr_rst_n;
   logic       reconfig_rst_n;
   logic       clock;
   logic       vip_rst;

   logic  rst_ack_n;
   logic  tx_rst_ack_n;
   logic  rx_rst_ack_n;
   logic  mac_tx_rst_ack_n;
   logic  mac_rx_rst_ack_n;
   logic  mac_rst_ack_n;
   

 endinterface: reset_if

`endif // RESET_IF__SV
