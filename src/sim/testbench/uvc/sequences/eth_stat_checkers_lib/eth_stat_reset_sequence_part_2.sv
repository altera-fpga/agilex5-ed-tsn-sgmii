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


class eth_stat_reset_sequence_part_2 extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_reset_sequence_part_2)

  int transaction_count;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    uvm_reg_data_t read_data_tx;
    uvm_reg_data_t read_data_rx;
    bit skip_stat_reg_rd_l = 0;
    `uvm_info("body", "started eth_stat_reset_sequence_part_2 ...", UVM_NONE)
    super.body();

    if($test$plusargs("skip_stat_reg_rd")) begin
      skip_stat_reg_rd_l = 1;
    end
    else begin
      skip_stat_reg_rd_l = 0;
    end

    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = num_of_frames/4;
    end

    //Disable vip errors
    demote_error();
    
    //if(skip_stat_reg_rd_l === 0) begin
    //  //read and compare all stats at the begining of sequence
    //  `uvm_info("eth_stat_reset_sequence_part_2", "2. read and compare all stats at the begining of sequence", UVM_NONE)
    //  read_and_compare_stats();
    //end

    //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_reset_sequence_part_2", "3. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_directed_frames();
    send_random_frames(transaction_count);

    #700ns; 
    `uvm_info("eth_stat_reset_sequence_part_2", "3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
    p_sequencer.env.write_stat_regs();

    //4. Read all stats counter register .
    `uvm_info("eth_stat_reset_sequence_part_2", "4. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly
    `uvm_info("eth_stat_reset_sequence_part_2", "7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly", UVM_NONE)
    apply_tx_rx_hard_soft_rst();
    //From apply_tx_rx_hard_soft_rst task, it will again enable vip error so we need to disable vip error again in below task call
    demote_error();

    `uvm_info("eth_stat_reset_sequence_part_2", "8. Read all stats counter register to check they retain value", UVM_NONE)
    read_and_compare_stats();

    `uvm_info("eth_stat_reset_sequence_part_2", "9. Apply eio_sys_rst, csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter and 10. Read all stats counter registers", UVM_NONE)
    apply_rst_to_clear_stat_reg();

    //11. repeat step 6
    `uvm_info("eth_stat_reset_sequence_part_2", "11. Repeat step 6", UVM_NONE)
    `uvm_info("eth_stat_reset_sequence_part_2", "11.6. Repeat step 3 and 4", UVM_NONE)
    `uvm_info("eth_stat_reset_sequence_part_2", "11.6.3. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_directed_frames();
    send_random_frames(transaction_count);

    #700ns; 
    `uvm_info("eth_stat_reset_sequence_part_2", "11.6.3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
    p_sequencer.env.write_stat_regs();

    //4. Read all stats counter register .
    `uvm_info("eth_stat_reset_sequence_part_2", "11.6.4. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();
    #400ns;

    `uvm_info("body", "ended eth_stat_reset_sequence_part_2 ...", UVM_NONE)
  endtask

  task demote_error();
  //Ignore expected VIP errors
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    `endif
  endtask

endclass:eth_stat_reset_sequence_part_2
