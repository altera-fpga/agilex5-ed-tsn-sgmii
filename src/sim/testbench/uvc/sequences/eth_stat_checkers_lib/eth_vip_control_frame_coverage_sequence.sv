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


class eth_vip_control_frame_coverage_sequence extends eth_stat_base_sequence;

  `uvm_object_utils(eth_vip_control_frame_coverage_sequence)
  int transaction_count;
  frame_type eth_frame;
  `ifdef ENABLE_ETH_VIP
  alt_eth_vip_base_sequence avl_rx_seq;
  `endif
  alt_eth_avalonst_base_sequence avl_tx_seq;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = 100;
    end
  endfunction:new

  virtual task body();
    `uvm_info("body", "started eth_vip_control_frame_coverage_sequence...", UVM_NONE)
    super.body();
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif


    for(int i = 0; i < transaction_count; i++) begin
     std::randomize(eth_frame) with {eth_frame dist {SFC_FRAME := 1, PFC_FRAME := 1}; };
     `ifdef ENABLE_ETH_VIP
       `uvm_create_on(avl_rx_seq, p_sequencer.eth_vip_seqr_inst);
       `uvm_info("eth_vip_control_frame_coverage_sequence", $sformatf("sending %0s frame from vip tx",eth_frame.name()),UVM_NONE);
       avl_rx_seq.send_eth_control_frame(1,eth_frame,,$urandom_range(0,1));
     `endif

      `uvm_create_on(avl_tx_seq, p_sequencer.tx_seqr);
      `uvm_info("eth_vip_control_frame_coverage_sequence", $sformatf("sending %0s frame from avalon tx",eth_frame.name()),UVM_NONE);
      avl_tx_seq.send_eth_control_frame(1,eth_frame,,$urandom_range(0,1));
    end

    //To cover rx_vector_uvc_mon::csr_bcast_frame::broadcast_one*med
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    send_eth_frame_with_fix_size(.eth_frame(BCAST_DATA_FRAME),.frame_size(45),.no_of_frame(1),.path(ETH_VIP_AVL_RX));



  endtask


endclass
