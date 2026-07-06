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


class fcs_error_sequence extends eth_stat_base_sequence;
//  sequence_0 tx_seq;
//  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(fcs_error_sequence)
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
//   $display("running stat sanity sequence");
//   apply_hard_reset(0,0,1,11);
//   rx_crc_pass=$urandom;
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
//   $display("DONE!!! WRITING TO REG");
//   clear_stat_counters();
//   #400ns;
 //  tx_seq.start(p_sequencer.tx_seqr);
    super.body();
 `ifdef ENABLE_ETH_VIP
        send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
  `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
 `endif
   $display("end stat sanity sequence");
  endtask
  //`ifdef UVM_VERSION_1_1
  // virtual task post_start();
  //  if ((get_parent_sequence() == null) && (starting_phase != null))
  //    starting_phase.phase_done.set_drain_time(this, 2us);
  //    read_and_compare_stats();
  //    starting_phase.drop_objection(this, "Ending");
  //endtask:post_start
  //`endif
endclass:fcs_error_sequence
