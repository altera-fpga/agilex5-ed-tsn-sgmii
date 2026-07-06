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


class eth_ptp_config_sequence extends eth_base_sequence;
  `uvm_object_utils(eth_ptp_config_sequence)


 function new(string name = "eth_ptp_config_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 task body();
   eth_ptp_tx_user_flow_sequence eth_ptp_tx_user_flow_sequence_i;
   eth_ptp_rx_user_flow_sequence eth_ptp_rx_user_flow_sequence_i;

   `uvm_info("body", "started eth_ptp_config_sequence ...", UVM_NONE)

   `uvm_do(eth_ptp_tx_user_flow_sequence_i)
   `uvm_do(eth_ptp_rx_user_flow_sequence_i)
   `uvm_info("body", "Completed eth_ptp_config_sequence ...", UVM_NONE)

 endtask : body

endclass : eth_ptp_config_sequence
