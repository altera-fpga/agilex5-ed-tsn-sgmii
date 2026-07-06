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


class alt_eth_vip_pcs66_base_sequence extends alt_eth_vip_base_sequence;
  svt_ethernet_transaction xact;
   `uvm_object_utils(alt_eth_vip_pcs66_base_sequence)
  function new (string name = "alt_eth_vip_pcs66_base_sequence");
      	super.new(name);
   endfunction : new

  virtual task body();
    `uvm_info("body", $sformatf("Calling alt_eth_vip_pcs66_base_sequence number of frames %0d", sequence_length), UVM_LOW)
    for(int i = 0; i < sequence_length; i++) begin
      `uvm_create(xact)
      if(eth_frame == UNDERSIZE_FRAME) begin
         xact.reasonable_command_type.constraint_mode(0);
         xact.reasonable_byte_count.constraint_mode(0);
	       xact.disable_mac_pad = 1;
         `uvm_rand_send_with (xact, {xact.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME};xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR;xact.byte_count inside {[26:63]};})
         `uvm_info("body", $sformatf("Calling alt_eth_vip_pcs66_base_sequence sending undersized frame :  %0d", xact.byte_count), UVM_LOW)
      end
      else begin 
        `uvm_rand_send_with (xact, {xact.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME};xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR;})
      end
    end
   
  endtask: body

endclass
