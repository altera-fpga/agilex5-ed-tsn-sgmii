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


class eth_stat_counter_overflow extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_counter_overflow)
  `ifdef ENABLE_ETH_VIP
   alt_eth_error_vip_base_sequence err_seq;
   `endif
     int transaction_count;
     bit [15:0] frame_size_min = 4;
     bit [15:0] frame_size_max = 30;
     int total_num_frames_sent=0;
     time frame_timeout_time=5us;
     bit en_short_packet=1'b1;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = $urandom_range(500,1000);//FIXME Shabbir: increase later after sequence is stable
    end
  endfunction:new

  virtual task body();
    uvm_reg_data_t read_data_tx;
    uvm_reg_data_t read_data_rx;
    `uvm_info("body", "started eth_stat_counter_overflow ...", UVM_NONE)
    super.body();

   rx_max_frame_size = $urandom_range(1800,2000);
   tx_max_frame_size = $urandom_range(1800,2000);
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);

    //Ignore expected VIP errors
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);

    `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
    exception = new();
    /** Create the exception list */
    exception_list = new("exception_list", exception);
    `endif

    `uvm_info("eth_stat_counter_overflow", "1. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_directed_frames();
    read_and_check_non_zero_stats();


    `uvm_info("eth_stat_counter_overflow", "2. Force tx/rx stat registers", UVM_NONE)
    force_stat_regs(1);

    //p_sequencer.env.ts_tasks_if.force_lsb_stat_regs();
    //p_sequencer.env.eth_ref_model_inst.force_lsb_stat_regs();

    `uvm_info("eth_stat_counter_overflow", "3. read and compare all stats after force", UVM_NONE)
    read_and_compare_stats();

    //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_counter_overflow", "4. Send random frames such that all stats counts have non reset value", UVM_NONE)
    repeat(4) begin
      send_directed_frames();
      read_and_compare_stats();
    end

    `uvm_info("eth_stat_counter_overflow", "5. Force tx/rx stat registers", UVM_NONE)
    force_stat_regs(0);

    `uvm_info("eth_stat_counter_overflow", "6. Send random frames such that all stats counts have non reset value", UVM_NONE)
    repeat(4) begin
      send_directed_frames();
      read_and_compare_stats();
    end

    send_random_frames(transaction_count);
    read_and_compare_stats();

    //Shabbir: below piece of code is to validate rx adaptor register rollover
    `uvm_info("eth_stat_counter_overflow", "7. Force tx/rx stat registers including rx adapt counters", UVM_NONE)
    force_stat_regs(2);
    #50ns;

    send_directed_frames();
    #1000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read.  
    num_of_frames = $urandom_range(50,100);
    total_num_frames_sent=num_of_frames;
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G)
      p_sequencer.env.eth_ref_model_inst.packet_stall=1;

    //Shabbir: demoting errors specific to short packet
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
    //`endif

    `uvm_info("eth_stat_counter_overflow","8:Sending short frames randomly", UVM_MEDIUM)
    err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
    // Wait for frames to be received
    p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
    p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));   
    `endif
    #2000ns;//Shabbir: increasing time because wait functions will not work due to previous frames sent using send_directed_frames and send_random_frames 

    p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data);
    p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_63_32_OFFSET_REG,read_data);

  endtask: body

  task force_stat_regs(int sel = 2);
    bit [63:0] val;
    string cr_stats;
    string adapt_stats_1;
    string adapt_stats_2;
    string adapt_stats_3;
    string adapt_stats_4;
    bit G50_pp0;
    G50_pp0=0;
    // Initalised stat counters values
    val[63:0] = 'hffff_ffff_ffff_fffd;

    `uvm_info("eth_stat_counter_overflow", $psprintf("Sel = %0d ",sel), UVM_NONE)

    if(sel == 0) begin
      val[63:0] = {32'h0000_0000,$urandom_range(32'hffff_fffd,32'hffff_ffff)};
    end
    else if(sel == 1) begin
      val[63:0] = {32'hffff_ffff,$urandom_range(32'hffff_fffd,32'hffff_ffff)};
    end
    else begin
      randcase
      //  4: begin val[31:0] = $urandom(); val[63:32] = $urandom(); end
      //  1: begin val[7:0] = $urandom(); end
      //  1: begin val[15:8] = $urandom(); end
      //  1: begin val[23:16] = $urandom(); end
      //  1: begin val[31:24] = $urandom(); end
      //  1: begin val[39:32] = $urandom(); end
      //  1: begin val[47:40] = $urandom(); end
      //  1: begin val[55:48] = $urandom(); end
      //  1: begin val[63:56] = $urandom(); end
        1: begin val[63:0] = {32'h0000_0000,$urandom_range(32'hffff_fff0,32'hffff_ffff)}; end
        1: begin val[63:0] = {32'hffff_ffff,$urandom_range(32'hffff_fff0,32'hffff_ffff)}; end
        1: begin val[63:0] = {$urandom_range(32'hffff_fff0,32'hffff_ffff),32'hffff_ffff}; end
      endcase
    end
    `uvm_info("eth_stat_counter_overflow", $psprintf("Forced signals with value:64'h%h ",val), UVM_NONE)

   // `ifdef CRETE3       //muralasx: FIXME for GDR
   //  `ifdef ACDS_19_1
   //    `ifdef FALCON_MESA
   //      cr_stats="eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram";
   //   //`else
   //     cr_stats="eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram";
     //   `endif //FALCON_MESA
     // `else
   //   cr_stats="eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram";
   //   `endif
   // `else
   //  `ifdef ACDS_19_1
      //cr_stats="eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.die_specific_inst.x_c2_ehip_core.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram";
   //   `else
      //cr_stats="eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram";
    //`endif
    //`endif

    //Shabbir: forcing RX adaptor registers FB 605413
     //`ifndef CRETE3//muralasx: FIXME for GDR
       //`ifdef G100
       if(p_sequencer.env.spy_if.speed == _100G) begin
         adapt_stats_1="eth_env_top.dut.top.RX_ADAPTER_100G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc0.dout[15:0]";
         adapt_stats_2="eth_env_top.dut.top.RX_ADAPTER_100G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc1.dout[15:0]";
         adapt_stats_3="eth_env_top.dut.top.RX_ADAPTER_100G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc0.dout[15:0]";
         adapt_stats_4="eth_env_top.dut.top.RX_ADAPTER_100G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc1.dout[15:0]";
       end
       //`ifdef G50
       if(p_sequencer.env.spy_if.speed == _50G) begin
	 if(p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough == 1) begin
           adapt_stats_1="eth_env_top.dut.top.RX_ADAPTER_PP_50G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc0.dout[15:0]";
           adapt_stats_2="eth_env_top.dut.top.RX_ADAPTER_PP_50G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc1.dout[15:0]";
           adapt_stats_3="eth_env_top.dut.top.RX_ADAPTER_PP_50G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc0.dout[15:0]";
           adapt_stats_4="eth_env_top.dut.top.RX_ADAPTER_PP_50G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc1.dout[15:0]";
         end
         //Shabbir:drop counter doesn't exist for pp0 in 50G HSD 1606884346
         else begin
           G50_pp0=1;
         //  adapt_stats_1="eth_env_top.dut.top.RX_ADAPTER_50G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc0.dout[15:0]";
         //  adapt_stats_2="eth_env_top.dut.top.RX_ADAPTER_50G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc1.dout[15:0]";
         //  adapt_stats_3="eth_env_top.dut.top.RX_ADAPTER_50G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc0.dout[15:0]";
         //  adapt_stats_4="eth_env_top.dut.top.RX_ADAPTER_50G.genblk1.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc1.dout[15:0]";
         end
       end
     else
       //`ifndef PTP_MODE//muralasx: FIXME for GDR
         //`ifdef G100
	 if(p_sequencer.env.spy_if.speed == _100G)begin
           //if(p_sequencer.env.tb_cfg.async == 0)//muralasx: FIXME for GDR
           if(p_sequencer.env.dyn_rcfg_obj_inst.en_async_adp == 0)
           begin
           adapt_stats_1="eth_env_top.dut.top.RX_ADAPTER_100G.NON_PTP_CASE.RX_ADAPTER.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc0.dout[15:0]";
           adapt_stats_2="eth_env_top.dut.top.RX_ADAPTER_100G.NON_PTP_CASE.RX_ADAPTER.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc1.dout[15:0]";
           adapt_stats_3="eth_env_top.dut.top.RX_ADAPTER_100G.NON_PTP_CASE.RX_ADAPTER.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc0.dout[15:0]";
           adapt_stats_4="eth_env_top.dut.top.RX_ADAPTER_100G.NON_PTP_CASE.RX_ADAPTER.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc1.dout[15:0]";
          end
          else
          begin
         adapt_stats_1="eth_env_top.dut.top.RX_ADAPTER_100G.NON_PTP_CASE.RX_ASYNC_ADAPTER.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc0.dout[15:0]";
         adapt_stats_2="eth_env_top.dut.top.RX_ADAPTER_100G.NON_PTP_CASE.RX_ASYNC_ADAPTER.adater_rx_inst.drop_frm_counter_inst.acc0.acc0.acc1.dout[15:0]";
         adapt_stats_3="eth_env_top.dut.top.RX_ADAPTER_100G.NON_PTP_CASE.RX_ASYNC_ADAPTER.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc0.dout[15:0]";
         adapt_stats_4="eth_env_top.dut.top.RX_ADAPTER_100G.NON_PTP_CASE.RX_ASYNC_ADAPTER.adater_rx_inst.drop_frm_counter_inst.acc0.acc1.acc1.dout[15:0]";
          end

         //`endif
	 end
       //`endif
      //`endif

    //{eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram[35:0][129:0]}
    for(int k=0;k<36;k++) begin
      uvm_hdl_force({cr_stats,$psprintf("[%0d][31:0]",k)},  val[31:0]);
      uvm_hdl_force({cr_stats,$psprintf("[%0d][63:32]",k)}, val[63:32]);
      uvm_hdl_force({cr_stats,$psprintf("[%0d][95:64]",k)}, val[31:0]);
      uvm_hdl_force({cr_stats,$psprintf("[%0d][127:96]",k)},val[63:32]);
    end

    //Shabbir:drop counter doesn't exist for pp0 in 50G HSD 1606884346
    if(G50_pp0==0) begin
      uvm_hdl_force({adapt_stats_1},val[15:0]);
      uvm_hdl_force({adapt_stats_2},val[31:16]);
      uvm_hdl_force({adapt_stats_3},val[47:32]);
      uvm_hdl_force({adapt_stats_4},val[63:48]);
    end

    p_sequencer.env.eth_ref_model_inst.force_lsb_stat_regs(val);
    //repeat(50) @(posedge spy_vif.u_ehip_core_u_tx_mac_i_clk);
    #5ns;
    `uvm_info("eth_stat_counter_overflow", $psprintf("Released signals\n"), UVM_NONE)
    for(int k=0;k<36;k++) begin
      uvm_hdl_release({cr_stats,$psprintf("[%0d][31:0]",k)});
      uvm_hdl_release({cr_stats,$psprintf("[%0d][63:32]",k)});
      uvm_hdl_release({cr_stats,$psprintf("[%0d][95:64]",k)});
      uvm_hdl_release({cr_stats,$psprintf("[%0d][127:96]",k)});
    end

    if(G50_pp0==0) begin
      uvm_hdl_release({adapt_stats_1});
      uvm_hdl_release({adapt_stats_2});
      uvm_hdl_release({adapt_stats_3});
      uvm_hdl_release({adapt_stats_4});
    end

  endtask : force_stat_regs

endclass : eth_stat_counter_overflow
