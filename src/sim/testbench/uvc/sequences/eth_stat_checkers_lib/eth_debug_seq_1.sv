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


class eth_debug_seq_1 extends eth_stat_base_sequence;

  `uvm_object_utils(eth_debug_seq_1)

  function new(string name = "eth_debug_seq_1");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    //Enable vector scoreboard
    //en_vec_sb();

    //apply_hard_reset(0,0,1,11);
    //`uvm_info("eth_debug_seq_1", "1. Apply csr reset", UVM_NONE)
    //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    //`uvm_info("eth_debug_seq_1", "wait_rx_pcs_ready done ...", UVM_NONE)
    super.body();

    send_directed_frames();

    //#600ns;
    //read_and_compare_stats();


  endtask

endclass: eth_debug_seq_1
