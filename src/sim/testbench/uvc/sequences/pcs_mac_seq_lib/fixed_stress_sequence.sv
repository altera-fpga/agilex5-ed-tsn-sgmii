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


class fixed_stress_sequence extends eth_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(fixed_stress_sequence)
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
   $display("running sanity sequence");
   //p_sequencer.env.apply_reset("hard",0,0,1,11);
   //rx_crc_pass=$urandom;
   //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
//   $display("DONE!!! WRITING TO REG");
 //  tx_seq.start(p_sequencer.tx_seqr);
 `ifdef ENABLE_ETH_VIP
   send_constrained_eth_frame(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP,500,9582);
  `else
  send_constrained_eth_frame(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP,1000,9582);
  `endif

  endtask
endclass
