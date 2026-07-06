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


class ptp_asm_p2p_read_write_reg_sequence extends eth_ptp_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(ptp_asm_p2p_read_write_reg_sequence)
  function new(string name = "ptp_asm_p2p_read_write_reg_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
    super.body();
    //write_ptp_reg;
    `uvm_info("eth_seq_lib", "running ptp_asm_p2p_read_write_reg_sequence\n",UVM_LOW)
   p_sequencer.top_env.write_asym_p2p_latency();
   p_sequencer.top_env.read_asym_p2p_latency();
 
  endtask
endclass

