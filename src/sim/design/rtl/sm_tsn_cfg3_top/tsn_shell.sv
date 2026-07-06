module tsn_shell
#(parameter QUADS = 3)
	(
	 input var logic 	app_pp_osc_clk,
	 input var logic 	app_pp_system_clk,
	 //Reset
	 input var logic 	app_pp_system_rst_n,
	 
	 //MDIO Interface
	 input var logic 	app_pp_emac0_mdio_mdi,
	 output var logic 	pp_app_emac0_mdio_mdo,
	 output var logic	pp_app_emac0_mdio_mdoe,
	 output var logic 	pp_app_emac0_mdio_mdc,
	 
	 
	 //MRPHY TX, RX
	 output var logic 	pp_app_tx_serial_data,
	 output var logic 	pp_app_tx_serial_data_n,
	 input var logic 	app_pp_rx_serial_data,
	 input var logic 	app_pp_rx_serial_data_n	
	 

	 //PPS IN, PPS OUT - Add later	 
	 
	 );
	 
	 //PLL - MRPHY
	 logic 				pll_mrphy_pll_lock;
	 logic				pll_mrphy_pll_322_clk;
	 logic				pll_mrphy_pll_156_clk;
	 
	 //HPS - MRPHY
	 logic 		[7:0]	hps_mrphy_data;
	 logic				hps_mrphy_data_vld;
	 logic				hps_mrphy_err;
	 logic 				hps_mrphy_rst, hps_mrphy_tx_rst, hps_mrphy_rx_rst;

	 logic		[7:0]   mrphy_hps_data;
	 logic				mrphy_hps_data_vld;
	 logic				mrphy_hps_err;	 
	 logic				mac_speed;
	 logic 				mac_col_det;
	 logic				mac_car_sense;
	 logic 				mrphy_hps_tx_clk;
	 logic 				mrphy_hps_rx_clk;
	 
	 //AVMM - MRPHY CSR
	 logic	[31:0]		avmm_rd_data, avmm_wr_data;
	 logic 				avmm_rd_vld, avmm_rd, avmm_wr;
	 logic 	[9:0]		avmm_add;
    logic            avmm_byte_en;	 
	 
	 //HPS - Rst controller
	 logic 				h2f_reset;
	 logic 				init_done;
	 
	 //SRC - MRPHY
	 logic 				mrphy_src_req;
	 logic 				src_mrphy_grant;
	 logic 		[QUADS-1:0]	src_mrphy_clk;
	 
	 //IOPLL 
	 logic 				io_pll_clk;
	 logic 				io_pll_locked;
	 
	 //CSR
	 logic 				csr_clk, csr_rst;
	 logic	[31:0]		csr_rd_data, csr_wr_data;
	 logic 				csr_rd_vld, csr_rd, csr_wr;
	 logic 				csr_add, csr_byte_en;
	 
	 logic				reg_mrphy_pll_lock, reg_tx_rdy, reg_rx_rdy, 
						reg_blk_lock, reg_op_speed;
						
	 logic				phy_rst_n, phy_tx_rst_n, phy_rx_rst_n;
	 logic 				ack_rst_n, ack_tx_rst_n, ack_rx_rst_n;
	 logic         phy_waitrequest;

	 assign csr_clk = app_pp_system_clk;
	 
	 

	//System PLL with clock bridge
	
		syspll_clk_bridge syspll_inst (
			.clock_bridge_0_in_clk_clk                   (app_pp_osc_clk),                   //   input,  width = 1,              clock_bridge_0_in_clk.clk
			.clock_bridge_0_out_clk_1_clk                (pll_mrphy_pll_156_clk),                //  output,  width = 1,           clock_bridge_0_out_clk_1.clk
			.intel_systemclk_gts_1_o_pll_lock_o_pll_lock (pll_mrphy_pll_lock), //  output,  width = 1,   intel_systemclk_gts_1_o_pll_lock.o_pll_lock
			.intel_systemclk_gts_1_o_syspll_c0_clk       (pll_mrphy_pll_322_clk),       //  output,  width = 1,  intel_systemclk_gts_1_o_syspll_c0.clk
			.intel_systemclk_gts_1_i_refclk_rdy_data     (1'b1)      // Check with Vasu- connecting it to 1 for now,   input,  width = 1
	);
	
	//IO PLL
		//iopll io_pll_inst (
      iopll_iopll_0 io_pll_inst (
			.refclk    						 (app_pp_system_clk),    //   input,  width = 1,  iopll_0_refclk.clk
			.locked 						 (io_pll_locked), //Check - pll_locked signal is sent to reset controller output,  width = 1,  iopll_0_locked.export
			.rst   						 (app_pp_system_rst_n),   //   input,  width = 1,   iopll_0_reset.reset
			.outclk_0   						 (io_pll_clk)    //  output,  width = 1, iopll_0_outclk0.clk
	);
	
	//Reset Release IP
		//reset_ip rst_rel (
      reset_ip_s10_user_rst_clkgate_0 rst_rel (
			.ninit_done                            (init_done)
	);
	
	//Reset controller
		rst_ctrl rst_ctrl_inst (
			.app_pp_h2f_reset							 (h2f_reset),
			.app_pp_system_rst_n						 (app_pp_system_rst_n),
			.app_pp_system_clk							 (app_pp_system_clk),
			.app_pp_csr_clk								 (csr_clk),
			.app_pp_ninit_done							 (init_done),
			.app_pp_pll_locked							 (io_pll_locked),		//Check1 - 
			.pp_app_phy_rst_n							 (),						//Check1 - Where to connect this				
			.pp_app_csr_rst_n							 (csr_rst)
	);

	
	//HPS Instance with AXI-AVMM adapter at the lwhps Interface
		hps_axi_bridge u0 ( 
			.clk_clk                                          (app_pp_system_clk),	//Check1 - Is this system clk??
			.intel_agilex_5_soc_0_h2f_reset_reset_n           (h2f_reset), 
			.intel_agilex_5_soc_0_emac_ptp_clk_clk            (app_pp_system_clk),  //Check - Temp - Connected system clock  input,   width = 1,         hps_agilex_5_emac_ptp_clk.clk 
			.intel_agilex_5_soc_0_emac_timestamp_clk_clk      (app_pp_system_clk),       //Check - Temp - connected system clock   input,   width = 1,   hps_agilex_5_emac_timestamp_clk.clk 
			.intel_agilex_5_soc_0_emac_timestamp_data_data_in (64'b0),  //Check - Temp connected to 0   input,  width = 64,  hps_agilex_5_emac_timestamp_data.data_in 
			.intel_agilex_5_soc_0_emac0_mdio_mac_mdc          (pp_app_emac0_mdio_mdc),           //  output,   width = 1, 
			.intel_agilex_5_soc_0_emac0_mdio_mac_mdi          (app_pp_emac0_mdio_mdi),           //   input,   width = 1, 
			.intel_agilex_5_soc_0_emac0_mdio_mac_mdo          (pp_app_emac0_mdio_mdo),           //  output,   width = 1, 
			.intel_agilex_5_soc_0_emac0_mdio_mac_mdoe         (pp_app_emac0_mdio_mdoe),          //  output,   width = 1, 
			.intel_agilex_5_soc_0_emac0_app_rst_reset_n       (hps_mrphy_rst),
			.intel_agilex_5_soc_0_emac0_mac_tx_clk_o          (),
			.intel_agilex_5_soc_0_emac0_mac_rx_clk            (mrphy_hps_rx_clk), 
			.intel_agilex_5_soc_0_emac0_mac_rst_tx_n          (hps_mrphy_tx_rst), 
			.intel_agilex_5_soc_0_emac0_mac_rst_rx_n          (hps_mrphy_rx_rst), 
			.intel_agilex_5_soc_0_emac0_mac_txen              (hps_mrphy_data_vld),               //  output,   width = 1, 
			.intel_agilex_5_soc_0_emac0_mac_txer              (hps_mrphy_err),               //  output,   width = 1,      
			.intel_agilex_5_soc_0_emac0_mac_rxdv              (mrphy_hps_data_vld),               //   input,   width = 1, 
			.intel_agilex_5_soc_0_emac0_mac_rxer              (mrphy_hps_err),               //   input,   width = 1,      
			.intel_agilex_5_soc_0_emac0_mac_rxd               (mrphy_hps_data),                //   input,   width = 8,    
			.intel_agilex_5_soc_0_emac0_mac_col               (mac_col_det),                //   input,   width = 1,       
			.intel_agilex_5_soc_0_emac0_mac_crs               (mac_car_sense),                //   input,   width = 1,     
			.intel_agilex_5_soc_0_emac0_mac_speed             (mac_speed),              //  output,   width = 3,           
			.intel_agilex_5_soc_0_emac0_mac_txd_o             (hps_mrphy_data),              //  output,   width = 8,      
			.intel_agilex_5_soc_0_fpga2hps_interrupt_irq      (), 
			.mm_bridge_0_m0_waitrequest                       (phy_waitrequest),					//Check1 - Driving 0, Temp 
			.mm_bridge_0_m0_readdata                          (avmm_rd_data),
			.mm_bridge_0_m0_readdatavalid                     (avmm_rd_vld),			//Check1 - Read data valid is not driven by MRPHY CSR
			.mm_bridge_0_m0_burstcount                        (),						//Check1 - Not needed?
			.mm_bridge_0_m0_writedata                         (avmm_wr_data),
			.mm_bridge_0_m0_address                           (avmm_add),
			.mm_bridge_0_m0_write                             (avmm_wr),
			.mm_bridge_0_m0_read                              (avmm_rd),
			.mm_bridge_0_m0_byteenable                        (avmm_byte_en),
			.mm_bridge_0_m0_debugaccess                       (),
			.reset_reset                                      (csr_rst)					//Check1 - rst
	); 
	 

	
	
		//mrphy_mgbaset mrphy_inst (
      alt_mge_phy_0 mrphy_inst (
		.csr_clk                 (csr_clk),                 //   input,   width = 1,                csr_clk.clk
		.tx_clkout               (),               //  16 bit interface clk
		.rx_clkout               (),               //  16 bit interface clk
		.gmii8b_tx_clkout         (mrphy_hps_tx_clk),         //  output,   width = 1,        gmii8_tx_clkout.clk
		.gmii8b_rx_clkout         (mrphy_hps_rx_clk),         //  output,   width = 1,        gmii8_rx_clkout.clk
		.reset                   (hps_mrphy_rst),                //Check1 - Temp connected to app_rst_reset   //   input,   width = 1,                  reset.reset
		.rx_digitalreset         (hps_mrphy_rx_rst),         //   input,   width = 1,        rx_digitalreset.rx_digitalreset
		.tx_digitalreset         (hps_mrphy_tx_rst),         //   input,   width = 1,        tx_digitalreset.tx_digitalreset
		.csr_readdata            (avmm_rd_data[15:0]),       //Check1     //  output,  width = 16,          avalon_mm_csr.readdata
		.csr_writedata           (avmm_wr_data[15:0]),       //Check1    //   input,  width = 16,                       .writedata
		.csr_address             (avmm_add[4:0]),            //Check1 //   input,   width = 5,                       .address
		.csr_waitrequest         (phy_waitrequest),         //  output,   width = 1,                       .waitrequest
		.csr_read                (avmm_rd),                //   input,   width = 1,                       .read
		.csr_write               (avmm_wr),               //   input,   width = 1,                       .write
		.gmii8b_mac_txen         (hps_mrphy_data_vld),         //   input,   width = 1,        gmii8b_mac_txen.export
		.gmii8b_mac_tx_d         (hps_mrphy_data),        //   input,   width = 8,        gmii8b_mac_tx_d.export
		.gmii8b_mac_txer         (hps_mrphy_err),         //   input,   width = 1,        gmii8b_mac_txer.export
		.gmii8b_mac_rxdv         (mrphy_hps_data_vld),   			        //  output,   width = 1,        gmii8b_mac_rxdv.export
		.gmii8b_mac_rxd          (mrphy_hps_data),       				    //  output,   width = 8,         gmii8b_mac_rxd.export
		.gmii8b_mac_rxer         (mrphy_hps_err),       			        //  output,   width = 1,        gmii8b_mac_rxer.export
		//.gmii8b_mac_col          (mac_col_det),          //  output,   width = 1,         gmii8b_mac_col.export
		//.gmii8b_mac_crs          (mac_car_sense),          //  output,   width = 1,         gmii8b_mac_crs.export
		.gmii8b_mac_speed        (mac_speed),        //   input,   width = 3,       gmii8b_mac_speed.export
		.led_link                (),                //  output,   width = 1,               led_link.export
		.led_char_err            (),            //  output,   width = 1,           led_char_err.export
		.led_disp_err            (),            //  output,   width = 1,           led_disp_err.export
		.led_an                  (),                  //  output,   width = 1,                 led_an.export
		.operating_speed         (reg_op_speed),         //  output,   width = 3,        operating_speed.export
      .i_src_ch_pause_request  (0),
      .o_src_ch_pause_grant    (),
		.i_rst_n                 (phy_rst_n),                 //   input,   width = 1,                i_rst_n.i_rst_n
		.o_rst_ack_n             (ack_rst_n),             //  output,   width = 1,            o_rst_ack_n.o_rst_ack_n
		.i_tx_rst_n              (phy_tx_rst_n),              //   input,   width = 1,             i_tx_rst_n.i_tx_rst_n
		.i_rx_rst_n              (phy_rx_rst_n),              //   input,   width = 1,             i_rx_rst_n.i_rx_rst_n
		.o_tx_rst_ack_n          (ack_tx_rst_n),          //  output,   width = 1,         o_tx_rst_ack_n.o_tx_rst_ack_n
		.o_rx_rst_ack_n          (ack_rx_rst_n),          //  output,   width = 1,         o_rx_rst_ack_n.o_rx_rst_ack_n
		.rx_cdr_refclk_p         (pll_mrphy_pll_156_clk),         //   input,   width = 1,        rx_cdr_refclk_p.clk
		.rx_cdr_refclk_n         (~pll_mrphy_pll_156_clk),          //Check - Vasu, _connected_to_rx_cdr_refclk_n_         //   input,   width = 1,        rx_cdr_refclk_n.clk
		.tx_ready                (reg_tx_rdy),                //  output,   width = 1,               tx_ready.tx_ready
		.rx_ready                (reg_rx_rdy),                //  output,   width = 1,               rx_ready.rx_ready
		//.gmii8b_mac_tx_clk_o     (1'b1),     //Check - Temp - connected to 1'b1//   input,   width = 1,    gmii8b_mac_tx_clk_o.clk
		.rx_pma_clkout           (),           //  output,   width = 1,          rx_pma_clkout.clk
		.xcvr_mode               (2'b01),      //Check1 - Temp Connected, should be driven by DR         //   input,   width = 2,              xcvr_mode.export
		.tx_pll_refclk_p         (pll_mrphy_pll_156_clk),         //   input,   width = 1,        tx_pll_refclk_p.clk
		.tx_pll_refclk_n         (~pll_mrphy_pll_156_clk),   //Check - Vasu,      //   input,   width = 1,        tx_pll_refclk_n.clk
		.i_pma_cu_clk            (src_mrphy_clk[0]),            //   s
		.i_system_pll_clk          (pll_mrphy_pll_322_clk),          //   input,   width = 1,         system_pll_clk.clk
		.i_system_pll_lock       (pll_mrphy_pll_lock),       //Check - Vasu, Temp - Connecting pll_lock signal //   input,   width = 1,        system_pll_lock.system_pll_lock
		.i_src_rs_grant          (src_mrphy_grant),          //   input,   width = 1,         i_src_rs_grant.src_rs_grant
		.o_src_rs_req            (mrphy_src_req),            //  output,   width = 1,           o_src_rs_req.src_rs_req
		.tx_serial_data          (pp_app_tx_serial_data),          //  output,   width = 1,         tx_serial_data.o_tx_serial_data
		.tx_serial_data_n        (pp_app_tx_serial_data_n),        //  output,   width = 1,       tx_serial_data_n.o_tx_serial_data_n
		.rx_serial_data          (app_pp_rx_serial_data),          //   input,   width = 1,         rx_serial_data.i_rx_serial_data
		.rx_serial_data_n        (app_pp_rx_serial_data_n),        //   input,   width = 1,       rx_serial_data_n.i_rx_serial_data_n
		.rx_is_lockedtodata      (),      //  Check - what is this/where to connect this signal //output,   width = 1,     rx_is_lockedtodata.o_rx_is_lockedtodata
		.reconfig_clk            (csr_clk),    //Check        //   input,   width = 1,           reconfig_clk.clk
		.reconfig_reset          (1'b0),          //Check - Connected to 1'b0 for now,//   input,   width = 1,         reconfig_reset.reset
		.reconfig_write          (1'b0),          //Check - Connected to 1'b0 for now,//   input,   width = 1,               reconfig.write
		.reconfig_read           (1'b0),          //Check - Connected to 1'b0 for now, //   input,   width = 1,                       .read
		.reconfig_address        (18'b0),       //Check - Connected to 1'b0 for now, //   input,  width = 18,                       .address
		.reconfig_be             (1'b0),        //Check - Connected to 1'b0 for now,     //   input,   width = 4,                       .byteenable
		.reconfig_writedata      (32'b0),      //Check - Connected to 1'b0 for now,//   input,  width = 32,                       .writedata
		.reconfig_readdata       (),    				   //  output,  width = 32,                       .readdata
		.reconfig_waitrequest    (),   					   //  output,   width = 1,                       .waitrequest
		.reconfig_readdata_valid (), 					   //  output,   width = 1,                       .readdatavalid
		.mrphy_pll_lock          (reg_mrphy_pll_lock)//(pll_mrphy_pll_lock)           //  output,   width = 1,        
	);
	
		//src_sss sss_inst (
      intel_src_sss sss_inst (
		.o_src_rs_grant    (src_mrphy_grant),   			 //  output,  width = 1,    o_src_rs_grant.grant
		.i_src_rs_priority (1'b1), 							 // Check - Setting priority to 1, as there is only one MRPHY
		.i_src_rs_req      (mrphy_src_req),     			 //   input,  width = 1,      i_src_rs_req.in_shoreline_req
		.o_pma_cu_clk      (src_mrphy_clk)    				 //Check - this output is 3 bit
	);
	
		csr_shell usr_csr_space (
		//input
		.csr_clk		     	(csr_clk),
		.reset					(csr_rst),
		.csr_wr_data			(avmm_wr_data),
		.csr_read				(avmm_rd),			
        .csr_write				(avmm_wr),
        .csr_byteenable			(avmm_byte_en),
        .csr_address			(avmm_add),
		.mrphy_pll_lock_i	    (reg_mrphy_pll_lock),
	    .rx_ready_i				(reg_rx_rdy),
	    .tx_ready_i             (reg_tx_rdy),
	    .rx_block_lock_i        (reg_blk_lock),					//Check1 - if this connection is correct
	    .op_speed_i             (reg_op_speed),
	    .ack_i_rst_n            (ack_rst_n),
        .ack_i_tx_rst_n         (ack_tx_rst_n),
        .ack_i_rx_rst_n         (ack_rx_rst_n),
        .we_dr_err_stat_i       (1'b0),							//Check1 - Temp, Driving to 0
        .phy_delay_i			(16'b0),							//Check1 - Temp, Driving to 0
		.csr_rd_data			(csr_rd_data),
		.csr_rd_vld				(csr_rd_vld),
		.o_rst_n				(phy_rst_n),
		.o_tx_rst_n				(phy_tx_rst_n),
		.o_rx_rst_n				(phy_rx_rst_n)
	);
	
	endmodule
		
		
	 /*
	 
	 
	 //System PLL
	 //	sys_pll u0 (
	 //	.sys_pll_156_156_o_pll_lock_o_pll_lock (pll_mrphy_pll_lock),    	//  output,  width = 1,
	 //	.sys_pll_156_156_o_syspll_c0_clk       (pll_mrphy_pll_156_clk),     //  output,  width = 1,
	 //	.sys_pll_156_156_refclk_xcvr_clk       (app_pp_osc_clk),        	//   input,  width = 1,
	 //	.sys_pll_156_156_i_refclk_rdy_data     (),     						//   input,  width = 1,
	 //	.sys_pll_156_322_o_pll_lock_o_pll_lock (), 							//  output,  width = 1,
	 //	.sys_pll_156_322_o_syspll_c0_clk       (pll_mrphy_pll_322_clk), 	//  output,  width = 1,
	 //	.sys_pll_156_322_refclk_xcvr_clk       (app_pp_osc_clk),        	//   input,  width = 1,
	 //	.sys_pll_156_322_i_refclk_rdy_data     ()      						//   input,  width = 1,
	 //);
	
	 
	 //HPS Instance
	 	hps hps_inst (
		.hps_agilex_5_h2f_reset_reset_n            (),            //  output,   width = 1,            hps_agilex_5_h2f_reset.reset_n
		.hps_agilex_5_h2f_mpu_events_eventi_ack    (),    //  output,   width = 1,       hps_agilex_5_h2f_mpu_events.eventi_ack
		.hps_agilex_5_h2f_mpu_events_eventi_req    (1'b0),    //   Check - Temp - connected to 0. input,   width = 1,                                  .eventi_req
		.hps_agilex_5_h2f_mpu_events_evento_ack    (1'b0),    //   Check - input,   width = 1,                                  .evento_ack
		.hps_agilex_5_h2f_mpu_events_evento_req    (),    	  //  output,   width = 1,                                  .evento_req
		.hps_agilex_5_hps_gp_gp_in                 (32'b0),   //Check -               //   input,  width = 32,               hps_agilex_5_hps_gp.gp_in
		.hps_agilex_5_hps_gp_gp_out                (),                //  output,  width = 32,                                  .gp_out
		.hps_agilex_5_lwhps2fpga_axi_clock_clk     (app_pp_system_clk),     //Check - Temp - Connected system clock  input,   width = 1, hps_agilex_5_lwhps2fpga_axi_clock.clk
		.hps_agilex_5_lwhps2fpga_axi_reset_reset_n (1'b1), //Check - Temp - connecting to 1   input,   width = 1, hps_agilex_5_lwhps2fpga_axi_reset.reset_n
		.hps_agilex_5_lwhps2fpga_awid              (),              //  output,   width = 4,           hps_agilex_5_lwhps2fpga.awid
		.hps_agilex_5_lwhps2fpga_awaddr            (),            //  output,  width = 21,                                  .awaddr
		.hps_agilex_5_lwhps2fpga_awlen             (),             //  output,   width = 8,                                  .awlen
		.hps_agilex_5_lwhps2fpga_awsize            (),            //  output,   width = 3,                                  .awsize
		.hps_agilex_5_lwhps2fpga_awburst           (),           //  output,   width = 2,                                  .awburst
		.hps_agilex_5_lwhps2fpga_awlock            (),            //  output,   width = 1,                                  .awlock
		.hps_agilex_5_lwhps2fpga_awcache           (),           //  output,   width = 4,                                  .awcache
		.hps_agilex_5_lwhps2fpga_awprot            (),            //  output,   width = 3,                                  .awprot
		.hps_agilex_5_lwhps2fpga_awvalid           (),           //  output,   width = 1,                                  .awvalid
		.hps_agilex_5_lwhps2fpga_awready           (1'b1),           //Check - Temp connected to 1   input,   width = 1,                                  .awready
		.hps_agilex_5_lwhps2fpga_wdata             (),             //  output,  width = 32,                                  .wdata
		.hps_agilex_5_lwhps2fpga_wstrb             (),             //  output,   width = 4,                                  .wstrb
		.hps_agilex_5_lwhps2fpga_wlast             (),             //  output,   width = 1,                                  .wlast
		.hps_agilex_5_lwhps2fpga_wvalid            (),            //  output,   width = 1,                                  .wvalid
		.hps_agilex_5_lwhps2fpga_wready            (1'b1),           //Check - Temp connected to 1   input,   width = 1,                                  .wready
		.hps_agilex_5_lwhps2fpga_bid               (4'b0),            //Check - Temp connected to 1   //   input,   width = 4,                                  .bid
		.hps_agilex_5_lwhps2fpga_bresp             (2'b0),            //Check - Temp connected to 0   input,   width = 2,                                  .bresp
		.hps_agilex_5_lwhps2fpga_bvalid            (1'b1),            //Check - Temp connected to 1  input,   width = 1,                                  .bvalid
		.hps_agilex_5_lwhps2fpga_bready            (),            //  output,   width = 1,                                  .bready
		.hps_agilex_5_lwhps2fpga_arid              (),              //  output,   width = 4,                                  .arid
		.hps_agilex_5_lwhps2fpga_araddr            (),            //  output,  width = 21,                                  .araddr
		.hps_agilex_5_lwhps2fpga_arlen             (),             //  output,   width = 8,                                  .arlen
		.hps_agilex_5_lwhps2fpga_arsize            (),            //  output,   width = 3,                                  .arsize
		.hps_agilex_5_lwhps2fpga_arburst           (),           //  output,   width = 2,                                  .arburst
		.hps_agilex_5_lwhps2fpga_arlock            (),            //  output,   width = 1,                                  .arlock
		.hps_agilex_5_lwhps2fpga_arcache           (),           //  output,   width = 4,                                  .arcache
		.hps_agilex_5_lwhps2fpga_arprot            (),            //  output,   width = 3,                                  .arprot
		.hps_agilex_5_lwhps2fpga_arvalid           (),           //  output,   width = 1,                                  .arvalid
		.hps_agilex_5_lwhps2fpga_arready           (1'b1),            //Check - Temp connected to 1  input,   width = 1,                                  .arready
		.hps_agilex_5_lwhps2fpga_rid               (4'b0),            //Check - Temp connected to 0   //   input,   width = 4,                                  .rid
		.hps_agilex_5_lwhps2fpga_rdata             (32'b0),           //Check - Temp connected to 0   input,  width = 32,                                  .rdata
		.hps_agilex_5_lwhps2fpga_rresp             (1'b0),             //Check - Temp connected to 0    input,   width = 2,                                  .rresp
		.hps_agilex_5_lwhps2fpga_rlast             (1'b0),            //Check - Temp connected to 0   input,   width = 1,                                  .rlast
		.hps_agilex_5_lwhps2fpga_rvalid            (1'b1),            //Check - Temp connected to 1   input,   width = 1,                                  .rvalid
		.hps_agilex_5_lwhps2fpga_rready            (),            //  output,   width = 1,                                  .rready
		.hps_agilex_5_emac_ptp_clk_clk             (app_pp_system_clk),  //Check - Temp - Connected system clock  input,   width = 1,         hps_agilex_5_emac_ptp_clk.clk
		.hps_agilex_5_emac_timestamp_clk_clk       (app_pp_system_clk),       //Check - Temp - connected system clock   input,   width = 1,   hps_agilex_5_emac_timestamp_clk.clk
		.hps_agilex_5_emac_timestamp_data_data_in  (64'b0),  //Check - Temp connected to 0   input,  width = 64,  hps_agilex_5_emac_timestamp_data.data_in
		.hps_agilex_5_emac0_mdio_mac_mdc           (pp_app_emac0_mdio_mdc),           //  output,   width = 1,           hps_agilex_5_emac0_mdio.mac_mdc
		.hps_agilex_5_emac0_mdio_mac_mdi           (app_pp_emac0_mdio_mdi),           //   input,   width = 1,                                  .mac_mdi
		.hps_agilex_5_emac0_mdio_mac_mdo           (pp_app_emac0_mdio_mdo),           //  output,   width = 1,                                  .mac_mdo
		.hps_agilex_5_emac0_mdio_mac_mdoe          (pp_app_emac0_mdio_mdoe),          //  output,   width = 1,                                  .mac_mdoe
		.hps_agilex_5_emac0_ptp_mac_ptp_trig       (1'b0),       //Check - Temp connected to 0  input,   width = 1,            hps_agilex_5_emac0_ptp.mac_ptp_trig
		.hps_agilex_5_emac0_ptp_mac_ptp_pps        (),        //  output,   width = 1,                                  .mac_ptp_pps
		.hps_agilex_5_emac0_ptp_mac_ptp_tstmp_data (), //  output,   width = 1,                                  .mac_ptp_tstmp_data
		.hps_agilex_5_emac0_ptp_mac_ptp_tstmp_en   (),   //  output,   width = 1,                                  .mac_ptp_tstmp_en
		.hps_agilex_5_emac0_app_rst_reset_n        (),        //  output,   width = 1,        hps_agilex_5_emac0_app_rst.reset_n
		.hps_agilex_5_emac0_mac_tx_clk_o           (),           //  output,   width = 1,                hps_agilex_5_emac0.mac_tx_clk_o
		.hps_agilex_5_emac0_mac_tx_clk_i           (mrphy_hps_tx_clk),           // Check -  Not used in GMII mode according to HPS Manual, But PHY sends out this clock
		.hps_agilex_5_emac0_mac_rx_clk             (mrphy_hps_rx_clk),             //   input,   width = 1,                                  .mac_rx_clk
		.hps_agilex_5_emac0_mac_rst_tx_n           (),           //  output,   width = 1,                                  .mac_rst_tx_n
		.hps_agilex_5_emac0_mac_rst_rx_n           (),           //  output,   width = 1,                                  .mac_rst_rx_n
		.hps_agilex_5_emac0_mac_txen               (hps_mrphy_data_vld),               //  output,   width = 1,                                  .mac_txen
		.hps_agilex_5_emac0_mac_txer               (hps_mrphy_err),               //  output,   width = 1,                                  .mac_txer
		.hps_agilex_5_emac0_mac_rxdv               (mrphy_hps_data_vld),               //   input,   width = 1,                                  .mac_rxdv
		.hps_agilex_5_emac0_mac_rxer               (mrphy_hps_err),               //   input,   width = 1,                                  .mac_rxer
		.hps_agilex_5_emac0_mac_rxd                (mrphy_hps_data),                //   input,   width = 8,                                  .mac_rxd
		.hps_agilex_5_emac0_mac_col                (mac_col_det),                //   input,   width = 1,                                  .mac_col
		.hps_agilex_5_emac0_mac_crs                (mac_car_sense),                //   input,   width = 1,                                  .mac_crs
		.hps_agilex_5_emac0_mac_speed              (mac_speed),              //  output,   width = 3,                                  .mac_speed
		.hps_agilex_5_emac0_mac_txd_o              (hps_mrphy_data),              //  output,   width = 8,                                  .mac_txd_o
		.hps_agilex_5_fpga2hps_interrupt_irq       (64'b0)        // Check - Temp Connected to 0  input,  width = 64,   hps_agilex_5_fpga2hps_interrupt.irq
	);		
	*/
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
