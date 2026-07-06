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


class eth_stat_shadowcopy_sequence_part_1 extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_shadowcopy_sequence_part_1)

  int transaction_count;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    
    `uvm_info("body", "started eth_stat_shadowcopy_sequence_part_1 ...", UVM_NONE)
    super.body();
    
    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M} ? 2:num_of_frames/6;
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
    
    //2. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence_part_1", "2. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();
    
    //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence_part_1", "3. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);
	
	p_sequencer.env.wait_tx_frames_received(.exp_num(transaction_count),.timeout_time(1ms),.include_fc_pkt(1));
	p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}  ) begin
       #250us;
    end

    //4. Read all stats counter register .
    `uvm_info("eth_stat_shadowcopy_sequence_part_1", "4. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //5. Clear stats register countets.
    `uvm_info("eth_stat_shadowcopy_sequence_part_1", "5. Clear Stat Registers", UVM_NONE)
    randcase
       40 : begin
            `uvm_info("eth_stat_shadowcopy_sequence_part_1", "Clear TX and RX Stat Registers",UVM_NONE) 
            clear_stat_counters();
            end
       30 : begin
            `uvm_info("eth_stat_shadowcopy_sequence_part_1", "Clear TX Stat Registers",UVM_NONE)   
            p_sequencer.env.reg_write(`GET_REG_ADDR(tx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);
            end
       30 : begin
            `uvm_info("eth_stat_shadowcopy_sequence_part_1", "Clear RX Stat Registers",UVM_NONE)   
            p_sequencer.env.reg_write(`GET_REG_ADDR(rx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);
            end
    endcase
    //p_sequencer.env.reg_write(`GET_REG_ADDR(tx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);
    //p_sequencer.env.reg_write(`GET_REG_ADDR(rx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);

    #100ns;  
    //6. Read all stats counter register .
    `uvm_info("eth_stat_shadowcopy_sequence_part_1", "6. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //7. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence_part_1", "7. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);

	p_sequencer.env.wait_tx_frames_received(.exp_num(transaction_count),.timeout_time(1ms),.include_fc_pkt(1));
	p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));

    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}  ) begin
       #250us;
    end

    //8. Read all stats counter register .
    `uvm_info("eth_stat_shadowcopy_sequence_part_1", "8. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    `uvm_info("body", "ended eth_stat_shadowcopy_sequence ...", UVM_NONE)
  endtask:body

endclass:eth_stat_shadowcopy_sequence_part_1
