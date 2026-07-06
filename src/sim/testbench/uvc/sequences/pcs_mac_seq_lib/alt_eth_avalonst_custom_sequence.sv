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


class alt_eth_avalonst_custom_sequence extends uvm_sequence #(eth_packet);
  `uvm_object_utils(alt_eth_avalonst_custom_sequence)
  int byte_count;
 
  function new(string name = "alt_eth_avalonst_custom_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

virtual task body();
    bit status;
      `uvm_info("body", $sformatf("Calling alt_eth_avalonst_custom_sequence byte count %0d", byte_count), UVM_LOW)
      `uvm_create(req)
      req.payload_size_c.constraint_mode(0);
      if(byte_count < 'h600)
      `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}; payload.size == byte_count;})
      else
      `uvm_rand_send_with(req,{frame_type inside {ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}; payload.size == byte_count;})
  endtask: body

endclass
