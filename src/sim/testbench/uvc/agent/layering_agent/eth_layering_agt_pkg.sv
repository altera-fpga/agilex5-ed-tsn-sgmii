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



package eth_layering_agt_pkg;
   `include "avst_pkg.sv"

   import altuvm_avalon_st_test_pkg::*;
   
   `include "eth_tx_layering_agt_eth_tx_layering_drv.sv"
   `include "eth_tx_layering_agt_eth_tx_layering_mon.sv"
   `include "eth_tx_layering_agt_eth_tx_layering_sqr.sv"
   `include "eth_macseg_rx_layering_mon.sv"
   `include "eth_macseg_tx_layering_mon.sv"

endpackage

