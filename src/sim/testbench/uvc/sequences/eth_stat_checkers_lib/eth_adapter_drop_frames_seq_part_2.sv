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


class eth_adapter_drop_frames_seq_part_2 extends eth_stat_base_sequence;

  `uvm_object_utils(eth_adapter_drop_frames_seq_part_2)
  
   `ifdef ENABLE_ETH_VIP
   alt_eth_error_vip_base_sequence err_seq;
   `endif
     bit [15:0] frame_size_min = 8;
     bit [15:0] frame_size_max = 30;
     int 	      total_num_frames_sent=0;
     time       frame_timeout_time=5us;
     bit 	      en_short_packet=1'b1;
     bit [2:0]  reset_bits;


  function new(string name = "eth_adapter_drop_frames_seq_part_2");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
  uvm_reg_data_t read_data_tx;
  uvm_reg_data_t read_data_rx;
  bit skip_stat_reg_rd_l = 0;
  super.body();
  //dis_vec_sb();
  //  uvm_reg_data_t read_data_tx;
  //  uvm_reg_data_t read_data;
      `ifdef G100
        p_sequencer.env.eth_ref_model_inst.packet_stall=1;
      `endif
      `uvm_info("eth_adapter_drop_frames_seq_part_2", "1. Apply csr reset", UVM_NONE)
       p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
      `uvm_info("eth_adapter_drop_frames_seq_part_2", "wait_rx_pcs_ready done ...", UVM_NONE)
      p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
      `ifdef G100
      p_sequencer.env.eth_ref_model_inst.packet_stall=1;
      `endif
      num_of_frames=500;
      total_num_frames_sent=num_of_frames;
  //  frame_size_max=30;
    //frame_size_min=8;
      en_short_packet=1;
//apply_shadow_request
    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_broadcast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      //`endif

      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      exception = new();
      /** Create the exception list */
      exception_list = new("exception_list", exception);
      `endif

      `uvm_info("eth_adapter_drop_frames_seq_part_2", "2. Apply Shadow Request", UVM_NONE)
      apply_adapter_shadow_request();
      #50ns;

             
      `ifdef ENABLE_ETH_VIP
      `uvm_info("eth_adapter_drop_frames_seq_part_2","3. Sending frames", UVM_MEDIUM)
      err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
      `endif
      #500ns;

      reset_bits = $urandom_range (1,7);

      `uvm_info("eth_adapter_drop_frames_seq_part_2", "4. Apply tx/rx/csr soft reset", UVM_MEDIUM)
       p_sequencer.env.apply_reset(.rst_type("soft"),.tx_rst(reset_bits[2]),.rx_rst(reset_bits[1]),.ip_rst(reset_bits[0]));
       p_sequencer.env.wait_for_linkup(reset_bits[2],reset_bits[1],reset_bits[0]);


      //. Read stats counter register 
      `uvm_info("eth_adapter_drop_frames_seq_part_2", "5. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      #500ns;

      `uvm_info("eth_adapter_drop_frames_seq_part_2", "6. Clear Shadow Request", UVM_NONE)
      clear_shadow_request();
      #100ns;
 
      //. Read stats counter register 
      `uvm_info("eth_adapter_drop_frames_seq_part_2", "7. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      #500ns;
 
     // Set CNTR_CONFIG bit 1 to clear the counter. 
      `uvm_info("eth_adapter_drop_frames_seq_part_2", "8. Set CNTR_CONFIG bit 0 to clear the stat counter.", UVM_NONE)
      p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h1);
      #400ns;
      p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h0);
      #400ns;
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data);

      `uvm_info("body", "Exiting ...", UVM_MEDIUM);
 endtask

endclass  
