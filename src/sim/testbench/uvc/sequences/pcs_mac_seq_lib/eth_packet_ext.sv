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


class eth_packet_ext extends eth_packet;
  `uvm_object_utils(eth_packet_ext)

   function new(string name = "eth_packet_ext");
      super.new(name);
   endfunction : new

  constraint skip_tx_crc_insertion_c {
    skip_tx_crc_insertion == 1'b0;
  }
endclass
