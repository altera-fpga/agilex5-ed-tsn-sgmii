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


class eth_stat_shadowcopy_sequence_part_2 extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_shadowcopy_sequence_part_2)

  int transaction_count;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    `uvm_info("body", "started eth_stat_shadowcopy_sequence_part_2 ...", UVM_NONE)
    super.body();

    `uvm_info("eth_stat_shadowcopy_sequence", "1. Reset is done in the reset phase of base test", UVM_NONE)

    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = num_of_frames/6;
    end

    //Ignore expected VIP errors
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    
    
    //Read register to get max_frame_size
    read_max_frame_size();

    // 200G/400G:As high memory is required for this speed, ignoring to read status registers(HSD 16011453560)
    if(!(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_200G,_400G})) begin
      //2. Read all stats counter register 
      `uvm_info("eth_stat_shadowcopy_sequence_part_2", "2. Read all stats counter register", UVM_NONE)
      read_and_compare_stats();
    end

    //17. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
    `uvm_info("eth_stat_shadowcopy_sequence_part_2", "17. Apply Shadow Request", UVM_NONE)
    apply_shadow_request();
    
    //18. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence_part_2", "18. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);

    #800ns;
    //19. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence_part_2", "19. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //20. Set CNTR_CONFIG bit 1 to clear the counter. 
    `uvm_info("eth_stat_shadowcopy_sequence_part_2", "20. Set CNTR_CONFIG bit 0 to clear the stat counter.", UVM_NONE)
    clear_stat_counters(); 
    #400ns;

    //21. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence_part_2", "21. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //22. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence_part_2", "22. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);

    #800ns;
    //23. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence_part_2", "23. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    // 200G/400G:As high memory is required for this speed, ignoring this below codes(HSD 16011453560)
    // BTW this logic was already covered by shadow_sequence_part_1
    if(!(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_200G,_400G})) begin
      //24. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
      `uvm_info("eth_stat_shadowcopy_sequence_part_2", "24. Clear Shadow Request", UVM_NONE)
      clear_shadow_request();

      #0;
      `uvm_info("eth_stat_shadowcopy_sequence_part_2", "24.1. Read all stats counter register", UVM_NONE)
      read_and_compare_stats();

      //25. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
      `uvm_info("eth_stat_shadowcopy_sequence_part_2", "25. Send random frames such that all stats counts have non reset value", UVM_NONE)
      send_random_frames(transaction_count);
      #800ns;
      
      //26. Read all stats counter register 
      `uvm_info("eth_stat_shadowcopy_sequence", "25. Read all stats counter register", UVM_NONE)
      read_and_compare_stats();
    end
    `uvm_info("body", "ended eth_stat_shadowcopy_sequence_part_2 ...", UVM_NONE)
  endtask:body

endclass:eth_stat_shadowcopy_sequence_part_2
