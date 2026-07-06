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


virtual class snps_eth_bfm_abstract extends altuvm_abstract_base;
      
      function new(string name = "snps_eth_bfm_abstract");
	 super.new(name);
	 m_class_type = name;
      endfunction : new
      
      //
      // Task: do_mon_cfg
      // Wrapper task to call the SNPS Monitor BFM's do_cfg from UVM world
      //
      // Parameter(s):
      // - param : SNPS's Parameter ID
      // - pvalue : Parameter setting value
      //
      pure virtual task do_mon_cfg (input [31:0] param, input [63:0] pvalue);

      endclass // snps_eth_bfm_abstract

