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


class eth_avalonst_to_serial_simplex_sequence extends eth_base_sequence;
  
  
  `uvm_object_utils(eth_avalonst_to_serial_simplex_sequence)
  
  function new(string name = "eth_avalonst_to_serial_simplex_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   //p_sequencer.env.apply_reset("hard",0,0,1,11);
   `uvm_info("eth_avalonst_to_serial_simplex_sequence", "Executing eth_avalonst_to_serial_simplex_sequence ...", UVM_LOW)
   //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,50);
   send_eth_frame(VLAN_FRAME,ETH_VIP_AVL_RX,50);
   send_eth_frame(STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,50);
   send_eth_frame(JUMBO_DATA_FRAME,ETH_VIP_AVL_RX,50);
   send_eth_frame(JUMBO_VLAN_FRAME,ETH_VIP_AVL_RX,50);
   send_eth_frame(JUMBO_STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,50);
  // send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);
   send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,100);
   p_sequencer.env.read_status_registers();
   send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,50);
   send_eth_frame(VLAN_FRAME,AVL_TX_ETH_VIP,50);
   send_eth_frame(STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,50);
   send_eth_frame(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP,50);
   send_eth_frame(JUMBO_VLAN_FRAME,AVL_TX_ETH_VIP,50);
   send_eth_frame(JUMBO_STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,50);
  // send_eth_frame(CONTROL_FRAME,AVL_TX_ETH_VIP,50);
  send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,100);
  p_sequencer.env.read_status_registers();
   `uvm_info("eth_avalonst_to_serial_simplex_sequence", "Exiting eth_avalonst_to_serial_simplex_sequence ...", UVM_LOW)
  endtask
endclass
