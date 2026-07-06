//---------------------------------------------------------------------------
//  UVC Instances 
//---------------------------------------------------------------------------

`ifdef JSON_EN
  `define TOP_PATH dut_top__tiles.dut_top__tile_0 
`else
  `define TOP_PATH dut_top__tiles.z1577a_x0_y0_n0 
`endif

reg i_kr_reconfig_write_kr25g;
reg i_kr_reconfig_read_kr25g;
reg [19:0] i_kr_reconfig_addr_kr25g;
reg [31:0] i_kr_reconfig_writedata_kr25g;
wire [31:0] o_kr_reconfig_readdata_kr25g;
wire o_kr_reconfig_waitrequest_kr25g;
wire o_kr_reconfig_readdata_valid_kr25g;
wire i_clk_kr25g;
wire i_reset_kr25g;
reg [3:0] i_kr_reconfig_byte_en_kr25g;

altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_kr25g (
							  .clk                       (i_clk_kr25g),
							  .reset                     (i_reset_kr25g)
							  );
altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,		
		  .IS_ACTIVE                 (UVM_ACTIVE),
		  .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
		  ) avmm_rtb_kr25g (.uif(avmm_if_kr25g));

//CSR
assign i_kr_reconfig_write_kr25g           = avmm_if_kr25g.write;
assign i_kr_reconfig_read_kr25g            = avmm_if_kr25g.read;
assign i_kr_reconfig_addr_kr25g         = {3'b0,avmm_if_kr25g.address[17:2]};
assign i_kr_reconfig_writedata_kr25g       = avmm_if_kr25g.writedata;
assign avmm_if_kr25g.readdata             = o_kr_reconfig_readdata_kr25g;
assign avmm_if_kr25g.waitrequest          = o_kr_reconfig_waitrequest_kr25g;    
assign avmm_if_kr25g.readdatavalid        = o_kr_reconfig_readdata_valid_kr25g;
assign i_kr_reconfig_byte_en_kr25g        = avmm_if_kr25g.byteenable;

assign spy_if_ip0.o_tx_lanes_stable = eth_env_top.dut.o_tx_lanes_stable_ip0;
assign spy_if_ip0.an_chan = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.AN_CHAN0;
assign spy_if_ip0.tx_serial = eth_env_top.dut.o_tx_serial_ip0;
assign spy_if_ip0.an_enable = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_an_cfg1_csr_enable_an; 
assign spy_if_ip0.seq_mode =  eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_seq_status_csr_seq_reconfig_mode;
assign spy_if_ip0.an_timeout = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_seq_status_csr_seq_an_timeout;
assign spy_if_ip0.lt_timeout = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_seq_status_csr_seq_lt_timeout;
assign spy_if_ip0.reset_seq = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_seq_cfg_csr_reset_seq;
assign spy_if_ip0.an_done  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_an_status_csr_an_complete;
assign spy_if_ip0.an_page_rec  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_an_status_csr_an_page_received;
assign spy_if_ip0.an_negfail  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_an_status_csr_negotiation_failure;
assign spy_if_ip0.lt_trained[0]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_trained_ln0;
assign spy_if_ip0.lt_training[0]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_startup_ln0;
assign spy_if_ip0.lt_trained[1]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_trained_ln1;
assign spy_if_ip0.lt_training[1]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_startup_ln1;
assign spy_if_ip0.lt_trained[2]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_trained_ln2;
assign spy_if_ip0.lt_training[2]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_startup_ln2;
assign spy_if_ip0.lt_trained[3]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_trained_ln3;
assign spy_if_ip0.lt_training[3]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_startup_ln3;
assign spy_if_ip0.lt_trained[4]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_trained_ln4;
assign spy_if_ip0.lt_training[4]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_startup_ln4;
assign spy_if_ip0.lt_trained[5]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_trained_ln5;
assign spy_if_ip0.lt_training[5]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_startup_ln5;
assign spy_if_ip0.lt_trained[6]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_trained_ln6;
assign spy_if_ip0.lt_training[6]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_startup_ln6;
assign spy_if_ip0.lt_trained[7]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_trained_ln7;
assign spy_if_ip0.lt_training[7]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_startup_ln7;
assign spy_if_ip0.lt_failure[0]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_failure_ln0;
assign spy_if_ip0.lt_failure[1]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_failure_ln1;
assign spy_if_ip0.lt_failure[2]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_failure_ln2;
assign spy_if_ip0.lt_failure[3]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_failure_ln3;
assign spy_if_ip0.lt_failure[4]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_failure_ln4;
assign spy_if_ip0.lt_failure[5]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_failure_ln5;
assign spy_if_ip0.lt_failure[6]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_failure_ln6;
assign spy_if_ip0.lt_failure[7]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_failure_ln7;
//assign spy_if_ip0.lt_frame_lock[0]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_frame_lock_ln0;
//assign spy_if_ip0.lt_frame_lock[1]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_frame_lock_ln1;
//assign spy_if_ip0.lt_frame_lock[2]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_frame_lock_ln2;
//assign spy_if_ip0.lt_frame_lock[3]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_frame_lock_ln3;
//assign spy_if_ip0.lt_frame_lock[4]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_frame_lock_ln4;
//assign spy_if_ip0.lt_frame_lock[5]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_frame_lock_ln5;
//assign spy_if_ip0.lt_frame_lock[6]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_frame_lock_ln6;
//assign spy_if_ip0.lt_frame_lock[7]  = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_lt_status1_csr_link_training_frame_lock_ln7;
assign spy_if_ip0.xus_timer_done_25g  = `TOP_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.u_rx_pcs.ehiplane_ber.xus_timer_done;
assign spy_if_ip0.xus_timer_done_anlt  = `TOP_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer_done;

assign spy_if_ip0.debug_signal =  eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_kr_debug_0_csr_scratch[31:0];
assign spy_if_ip0.an_status_c2[6] = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_an_status_csr_an_status;
assign spy_if_ip0.seq_link_ready = eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_seq_status_csr_seq_link_ready;

assign spy_if_ip0.lt_frame_lock[0]  = `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.flux_core_mem_ins.flux_core_ins.serdes_ctrl_ins.serdes_lane_wrap_ins.serdes_lane_ctrl_lane3_ins.tfl_interrupt_frame_locked;
assign spy_if_ip0.lt_frame_lock[1]  = `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.flux_core_mem_ins.flux_core_ins.serdes_ctrl_ins.serdes_lane_wrap_ins.serdes_lane_ctrl_lane2_ins.tfl_interrupt_frame_locked;
assign spy_if_ip0.lt_frame_lock[2]  = `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.flux_core_mem_ins.flux_core_ins.serdes_ctrl_ins.serdes_lane_wrap_ins.serdes_lane_ctrl_lane1_ins.tfl_interrupt_frame_locked;
assign spy_if_ip0.lt_frame_lock[3]  = `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.flux_core_mem_ins.flux_core_ins.serdes_ctrl_ins.serdes_lane_wrap_ins.serdes_lane_ctrl_lane0_ins.tfl_interrupt_frame_locked;
assign spy_if_ip0.lt_frame_lock[4]  = `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_2.flux_top.flux_core_mem_ins.flux_core_ins.serdes_ctrl_ins.serdes_lane_wrap_ins.serdes_lane_ctrl_lane3_ins.tfl_interrupt_frame_locked;
assign spy_if_ip0.lt_frame_lock[5]  = `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_2.flux_top.flux_core_mem_ins.flux_core_ins.serdes_ctrl_ins.serdes_lane_wrap_ins.serdes_lane_ctrl_lane2_ins.tfl_interrupt_frame_locked;
assign spy_if_ip0.lt_frame_lock[6]  = `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_2.flux_top.flux_core_mem_ins.flux_core_ins.serdes_ctrl_ins.serdes_lane_wrap_ins.serdes_lane_ctrl_lane1_ins.tfl_interrupt_frame_locked;
assign spy_if_ip0.lt_frame_lock[7]  = `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_2.flux_top.flux_core_mem_ins.flux_core_ins.serdes_ctrl_ins.serdes_lane_wrap_ins.serdes_lane_ctrl_lane1_ins.tfl_interrupt_frame_locked;



//current connected with AVMM reconfig reset. 
assign i_clk_kr25g = clk_status_ip0;
assign i_reset_kr25g = reconfig_reset_ip0;

initial begin
  uvm_config_db#(string)::set(uvm_root::get(),"*top_env","kr25g_avmm_rtb_path","avmm_rtb_kr25g");
  avmm_rtb_kr25g.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
  avmm_rtb_kr25g.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;
  `ifdef MACSEG_MODE
    eth_env_top.seg_tx_if_ip0.disable_valid_ready_assertion = 1;
  `endif  
  force eth_env_top.avmm_rtb_kr25g.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;
  avmm_rtb_kr25g.master.u.u_bfm.set_idle_state_output_configuration(0);

end

//For Eth_16 fix. 
//initial 
//begin
//#10;
//if(spy_if_ip0.speed == _40G) begin
//  force `TOP_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[2].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_cfgcsr_crssm.rxpcs_conf_am_interval = 'h3f;
//end
//end


//initial begin
//
//force dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.brk_tfl_wrap_ins.brk_tfl_glue_lane3_ins.training_top_core_ins.i_training_top_tx.i_tx_coder.cfg_cl136_prbs_encoder_select_even = 0;
//force dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.brk_tfl_wrap_ins.brk_tfl_glue_lane2_ins.training_top_core_ins.i_training_top_tx.i_tx_coder.cfg_cl136_prbs_encoder_select_even = 0;
//force dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.brk_tfl_wrap_ins.brk_tfl_glue_lane1_ins.training_top_core_ins.i_training_top_tx.i_tx_coder.cfg_cl136_prbs_encoder_select_even = 0;
//force dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.brk_tfl_wrap_ins.brk_tfl_glue_lane0_ins.training_top_core_ins.i_training_top_tx.i_tx_coder.cfg_cl136_prbs_encoder_select_even = 0;
//
//end


  initial begin
      //$fsdbDumpvars(0,"+all",dut_top__tiles.dut_top__tile_0__reset_controller);
      `ifdef FSDB_ON
         $fsdbAutoSwitchDumpfile(20480, "novas.fsdb",100);
         $fsdbDumpvars(0,`TOP_PATH.z1577a.z1577a_inst.u_barak_quad);
      `endif

       force eth_env_top.dut.i_rst_n_ip0  = 0;
       force eth_env_top.dut.i_tx_rst_n_ip0  = 0;
       force eth_env_top.dut.i_rx_rst_n_ip0  = 0;
       force eth_env_top.reconfig_reset_ip0 = 1;


       wait (eth_env_top.dut.o_rst_ack_n_ip0 === 1'b0);

          #10us;
          $display("---Bring KR IP out of reset -----");
          force eth_env_top.reconfig_reset_ip0 = 0;
          force eth_env_top.dut.i_tx_rst_n_ip0  = 1;
          force eth_env_top.dut.i_rx_rst_n_ip0  = 1;
          force eth_env_top.dut.i_rst_n_ip0  = 1;
          
        $display("---Reset Seq Finished -----");

        #1us;

       release eth_env_top.dut.i_rst_n_ip0;
       release eth_env_top.reconfig_reset_ip0;
       release eth_env_top.dut.i_tx_rst_n_ip0;
       release eth_env_top.dut.i_rx_rst_n_ip0;


end

 `ifndef AN_OVRD_SET_UX_BASE_FREQ
  `define AN_OVRD_SET_UX_BASE_FREQ(UX_QUAD, UX_H, UX_V, FREQ) `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_``UX_QUAD``.flux_top.ux_wrapper_ins.ux_wrapper_2l_``UX_H``_ins.i_``UX_V``_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``); 
  `endif

  `ifndef LT_OVRD_SET_UX_BASE_FREQ
  `define LT_OVRD_SET_UX_BASE_FREQ(UX_QUAD, UX_H, UX_V, FREQ) `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_``UX_QUAD``.flux_top.ux_wrapper_ins.ux_wrapper_2l_``UX_H``_ins.i_``UX_V``_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``, ``FREQ``);
  `endif


   initial begin
        #1;
	forever begin
	if(spy_if_ip0.speed == _10G) begin
	  $display("Ram speed %s ",spy_if_ip0.speed);
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);

	end
	if(spy_if_ip0.speed == _40G) begin //need to get this from DE
	  $display("Ram speed %s ",spy_if_ip0.speed);
                            `AN_OVRD_SET_UX_BASE_FREQ(3,right,top,1.25e+10)
                            `AN_OVRD_SET_UX_BASE_FREQ(3,right,bot,1.25e+10)
                            `AN_OVRD_SET_UX_BASE_FREQ(3,left,top,1.25e+10)
                            `AN_OVRD_SET_UX_BASE_FREQ(3,left,bot,1.25e+10)
	end
	if(spy_if_ip0.speed == _25G) begin
	  $display("Ram speed %s ",spy_if_ip0.speed);
          // Temporary hack to set VCO frequency to 12.5 GHz for AN mode
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);

	end
	if(spy_if_ip0.speed == _100G && spy_if_ip0.ch_num == 4) begin
	  $display("Ram speed %s ",spy_if_ip0.speed);
          // Temporary hack to set VCO frequency to 12.5 GHz for AN mode
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_right_ins.i_top_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_right_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_top_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);
	end
	if(spy_if_ip0.speed == _50G && spy_if_ip0.ch_num == 2) begin
	  $display("Ram speed %s ",spy_if_ip0.speed);
          // Temporary hack to set VCO frequency to 12.5 GHz for AN mode
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_right_ins.i_top_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_right_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_top_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);
	  `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10, 1.25e+10);
	end
	  
	if(spy_if_ip0.speed == _50G && spy_if_ip0.ch_num == 1) begin
	  $display("Ram speed %s ",spy_if_ip0.speed);
	  `AN_OVRD_SET_UX_BASE_FREQ(3,left,bot,1.25e+10)
	end

	if(spy_if_ip0.speed == _400G || spy_if_ip0.speed == _200G || (spy_if_ip0.speed == _100G && spy_if_ip0.ch_num == 2)) begin
	  $display("Ram speed %s ",spy_if_ip0.speed);
	  `AN_OVRD_SET_UX_BASE_FREQ(2,right,top,1.25e+10)
	  `AN_OVRD_SET_UX_BASE_FREQ(2,right,bot,1.25e+10)
	  `AN_OVRD_SET_UX_BASE_FREQ(2,left,top, 1.25e+10)
	  `AN_OVRD_SET_UX_BASE_FREQ(2,left,bot, 1.25e+10)
	  `AN_OVRD_SET_UX_BASE_FREQ(3,right,top,1.25e+10)
	  `AN_OVRD_SET_UX_BASE_FREQ(3,right,bot,1.25e+10)
	  `AN_OVRD_SET_UX_BASE_FREQ(3,left,top, 1.25e+10)
	  `AN_OVRD_SET_UX_BASE_FREQ(3,left,bot, 1.25e+10)
	  
	end
	   $display("AN set_base wait for data mode  speed %s ",spy_if_ip0.speed);
	 wait(eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_kr_debug_7_csr_scratch !== 32'd0);
	   $display("AN set_base enter data mode  speed %s ",spy_if_ip0.speed);
         wait(eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_kr_debug_7_csr_scratch === 32'd0); //reset state
	   $display("AN set_base wait for reset  speed %s ",spy_if_ip0.speed);
     end	
    end

    initial begin 
      
      forever begin
	   $display("set_base wait for reset  speed %s ",spy_if_ip0.speed);
           wait(eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_kr_debug_7_csr_scratch === 32'd0); //reset state
	   $display("set_base wait for data  speed %s ",spy_if_ip0.speed);
           wait(eth_env_top.dut.kr_dut.eth_anlt_f_ip0.sip_inst.u_eth_anlt_f_csr_top.CSR.PORT[0].u_eth_anlt_f_csr.port0_kr_debug_7_csr_scratch === 32'd2);
	   $display("set_base data mode done   speed %s ",spy_if_ip0.speed);
	if(spy_if_ip0.speed == _10G) begin
	   `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(5.15625e+9, 5.15625e+9, 5.15625e+9, 5.15625e+9, 5.15625e+9, 1.03125e+10, 1e+10, 1e+10, 1e+10, 1e+10, 5.15625e+9, 5.15625e+9, 5.15625e+9, 5.15625e+9, 5.15625e+9, 1.03125e+10, 5.15625e+9, 5.15625e+9, 5.15625e+9, 5.15625e+9);
	end
	if(spy_if_ip0.speed == _40G) begin //need to get this from DE
                            `LT_OVRD_SET_UX_BASE_FREQ(3,right,top,1.03125e+10)                            
                            `LT_OVRD_SET_UX_BASE_FREQ(3,right,bot,1.03125e+10)                            
                            `LT_OVRD_SET_UX_BASE_FREQ(3,left,top,1.03125e+10)                            
                            `LT_OVRD_SET_UX_BASE_FREQ(3,left,bot,1.03125e+10) 
	end

	if(spy_if_ip0.speed == _25G) begin
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
	end

	if(spy_if_ip0.speed == _100G && spy_if_ip0.ch_num == 4) begin
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_right_ins.i_top_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_right_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_top_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
	end

	if(spy_if_ip0.speed == _50G && spy_if_ip0.ch_num == 2) begin
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_right_ins.i_top_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_right_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_top_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
          `TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3.flux_top.ux_wrapper_ins.ux_wrapper_2l_left_ins.i_bot_ip7581serdes_uxs2t1r1pgd_pipe_pma_ux_s2t1r1_pipe.set_base_freq(1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10, 1.2890625e+10);
	end
	  
	if(spy_if_ip0.speed == _50G && spy_if_ip0.ch_num == 1) begin
          `LT_OVRD_SET_UX_BASE_FREQ(3,left,bot,1.328125e+10)
	end

	if(spy_if_ip0.speed == _400G || spy_if_ip0.speed == _200G || (spy_if_ip0.speed == _100G && spy_if_ip0.ch_num == 2)) begin
          `LT_OVRD_SET_UX_BASE_FREQ(2,right,top,1.328125e+10)                            
          `LT_OVRD_SET_UX_BASE_FREQ(2,right,bot,1.328125e+10)                            
          `LT_OVRD_SET_UX_BASE_FREQ(2,left,top,1.328125e+10)                            
          `LT_OVRD_SET_UX_BASE_FREQ(2,left,bot,1.328125e+10)                            
          `LT_OVRD_SET_UX_BASE_FREQ(3,right,top,1.328125e+10)                            
          `LT_OVRD_SET_UX_BASE_FREQ(3,right,bot,1.328125e+10)                            
          `LT_OVRD_SET_UX_BASE_FREQ(3,left,top,1.328125e+10)                            
          `LT_OVRD_SET_UX_BASE_FREQ(3,left,bot,1.328125e+10)
	end
      end//forever	
    end //initial
