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


//class tx_padding_sequence extends eth_base_sequence;
//  padding_sequence tx_seq;
//  padding_sequence_cfg tx_seq1;
//  `uvm_object_utils(tx_padding_sequence)
//  function new(string name = "seq_0");
//    super.new(name);
//    `ifdef UVM_POST_VERSION_1_1
//      set_automatic_phase_objection(1);
//    `endif
//    tx_seq=new("tx_seq");  
//    tx_seq1=new("tx_seq1");  
//  endfunction:new
//
//  virtual task body();
//   $display("running padding sequence");
//   //p_sequencer.env.apply_reset("hard",0,0,1,11);
//   //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//  `ifdef ENABLE_ETH_VIP
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE); 
//  `endif
//   //if(p_sequencer.env.dyn_rcfg_obj_inst.crc_pass) tx_seq.start(p_sequencer.tx_seqr);
//   // else tx_seq1.start(p_sequencer.tx_seqr);
//   tx_seq.start(p_sequencer.tx_seqr);
//  endtask
//endclass
