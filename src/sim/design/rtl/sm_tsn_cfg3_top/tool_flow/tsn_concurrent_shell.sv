`ifdef CONCURRENT_TSN
	parameter NUM_PHY = 3;
	parameter NUM_IF = 4;
`else
	parameter NUM_PHY = 1;
	parameter NUM_IF = 2;
`endif	


module tsn_concurrent_shell
#(parameter NUM_PHY = 3, NUM_IF = 4)
	(
	 input var logic 	app_pp_osc_clk,
	 input var logic 	app_pp_system_clk,
	 //Reset
	 input var logic 	app_pp_system_rst_n,
	 
	 //MDIO Interface
	 input var logic 	[NUM_PHY-1:0]	app_pp_emac0_mdio_mdi,
	 output var logic 	[NUM_PHY-1:0]	pp_app_emac0_mdio_mdo,
	 output var logic	[NUM_PHY-1:0]	pp_app_emac0_mdio_mdoe,
	 output var logic 	[NUM_PHY-1:0]	pp_app_emac0_mdio_mdc,
	 
	 
	 //MRPHY TX, RX
	 output var logic 	[NUM_PHY-1:0]  pp_app_tx_serial_data,
	 output var logic 	[NUM_PHY-1:0]  pp_app_tx_serial_data_n,
	 input var logic 	[NUM_PHY-1:0]  app_pp_rx_serial_data,
	 input var logic 	[NUM_PHY-1:0]  app_pp_rx_serial_data_n	
	 

	 //PPS IN, PPS OUT - Add later	 pp_app_csr_rst_n
	 
	 );
	 
	 
	 //HPS - MRPHY
	 logic 		[NUM_PHY-1:0][7:0]	hps_mrphy_data;
	 logic		[NUM_PHY-1:0]		hps_mrphy_data_vld;
	 logic		[NUM_PHY-1:0]		hps_mrphy_err;
	 logic 		[NUM_PHY-1:0]		hps_mrphy_rst, hps_mrphy_tx_rst, hps_mrphy_rx_rst;

	 logic		[NUM_PHY-1:0][7:0]  mrphy_hps_data;
	 logic		[NUM_PHY-1:0]		mrphy_hps_data_vld;
	 logic		[NUM_PHY-1:0]		mrphy_hps_err;	 
	 logic		[NUM_PHY-1:0]		mac_speed;
	 logic 		[NUM_PHY-1:0]		mac_col_det;
	 logic		[NUM_PHY-1:0]		mac_car_sense;
	 logic 		[NUM_PHY-1:0]		mrphy_hps_tx_clk;
	 logic 		[NUM_PHY-1:0]		mrphy_hps_rx_clk;
	 
	 //AVMM - MRPHY CSR
	 logic	[31:0]		avmm_rd_data, avmm_wr_data;
	 logic 				avmm_rd_vld, avmm_rd, avmm_wr;
	 logic 				avmm_add, avmm_byte_en;	 
	 
	 //HPS - Rst controller
	 logic 				h2f_reset;
	 logic 				init_done;
	 logic 				csr_rst;
	 logic 				phy_rst;	 
	 
	 //IOPLL 
	 logic 				io_pll_clk;
	 logic 				io_pll_locked;
	 
	 //PLL - MRPHY
	 logic 				pll_mrphy_pll_lock;
	 logic				pll_mrphy_pll_322_clk;
	 logic				pll_mrphy_pll_156_clk;
	 
	 
	 logic	[NUM_PHY-1:0] reg_mrphy_pll_lock, reg_tx_rdy, reg_rx_rdy, 
						  reg_blk_lock, reg_op_speed;
						
	 logic	[NUM_PHY-1:0] phy_rst_n, phy_tx_rst_n, phy_rx_rst_n;
	 logic 	[NUM_PHY-1:0] ack_rst_n, ack_tx_rst_n, ack_rx_rst_n;
	 
	 //AXI interface wires
	 logic [3:0]  awid;
	 logic [11:0] awaddr;
	 logic [7:0]  awlen;
	 logic [2:0]  awsize;
	 logic [1:0]  awburst;
	 logic [0:0]  awlock;
	 logic [3:0]  awcache;
	 logic [2:0]  awprot;
	 logic        awvalid;
	 logic        awready;
	 logic [31:0] wdata;
	 logic [3:0]  wstrb; 
	 logic        wlast; 
	 logic        wvalid;
	 logic        wready;
	 logic [7:0]  bid;   
	 logic [1:0]  bresp; 
	 logic        bvalid;
	 logic        bready;
	 logic [7:0]  arid;  
	 logic [11:0] araddr;
	 logic [7:0]  arlen; 
	 logic [2:0]  arsize;
	 logic [1:0]  arburst;
	 logic [0:0]  arlock;
	 logic [3:0]  arcache;
	 logic [2:0]  arprot;
	 logic        arvalid;
	 logic        arready;
	 logic [7:0]  rid;   
	 logic [31:0] rdata; 
	 logic [1:0]  rresp; 
	 logic        rlast; 
	 logic        rvalid;
	 logic        rready;
	 
	 //Avalon interface wires
	 logic [NUM_IF-1:0]       waitrequest; 
	 logic [NUM_IF-1:0][31:0] readdata;     
	 logic [NUM_IF-1:0]       readdatavalid;
	 logic [NUM_IF-1:0][0:0]  burstcount;   
	 logic [NUM_IF-1:0][31:0] writedata;    
	 logic [NUM_IF-1:0][10:0] address;      
	 logic [NUM_IF-1:0]       write;        
	 logic [NUM_IF-1:0]       read;         
	 logic [NUM_IF-1:0][3:0]  byteenable;  
	 logic [NUM_IF-1:0]       debugaccess;
	 
	 //AXI - Avalon wires
	 logic 		csr_clk;
	 
	 
	 assign csr_clk = app_pp_system_clk;
	 
	
		//Reset Release IP
		reset_ip u0 (
			.s10_user_rst_clkgate_0_ninit_done_ninit_done (init_done)
		);
		
	
		//Reset controller
		rst_ctrl rst_ctrl_inst (
			.app_pp_h2f_reset							 (h2f_reset),
			.app_pp_system_rst_n						 (app_pp_system_rst_n),
			.app_pp_system_clk							 (app_pp_system_clk),
			//.app_pp_csr_clk							 (csr_clk),
			.app_pp_ninit_done							 (init_done),
			.app_pp_pll_locked							 (1'b1), //(io_pll_locked),				//Check - Connected to 1 to get around iopll error
			.pp_app_phy_rst_n							 (phy_rst),						//Check - Where to connect this				
			.pp_app_csr_rst_n							 (csr_rst)
		);
	
	/*
		//IO PLL
		iopll iopll_inst (
			.iopll_0_refclk_clk    						(app_pp_system_clk),  	 					//   input
			.iopll_0_locked_export						(io_pll_locked),		                    //  output
			.iopll_0_reset_reset 						(app_pp_system_rst_n),                      //   input
			.iopll_0_outclk0_clk   						(io_pll_clk)   			                    //  output - Check - Connect this to MRPHY after DL feature is implemented
		);
	*/
	
		//System PLL - Clock Bridge
		syspll_clk_bridge syspll_inst (
			.clock_bridge_0_in_clk_clk                   (app_pp_osc_clk),
			.clock_bridge_0_out_clk_1_clk                (pll_mrphy_pll_156_clk),
			.intel_systemclk_gts_0_o_pll_lock_o_pll_lock (pll_mrphy_pll_lock),
			.intel_systemclk_gts_0_o_syspll_c0_clk       (pll_mrphy_pll_322_clk),
			.intel_systemclk_gts_0_i_refclk_rdy_data     (1'b1)										//Input - Check - See if there is any refclk on board
		);
	
	
	 
	 
	 
	 generate
				if(NUM_PHY == 1)
					begin
						hps hps_inst (
							.intel_agilex_5_soc_0_h2f_reset_reset_n            (h2f_reset),
							.intel_agilex_5_soc_0_lwhps2fpga_axi_clock_clk     (csr_clk),
							.intel_agilex_5_soc_0_lwhps2fpga_axi_reset_reset_n (csr_rst),
							.intel_agilex_5_soc_0_lwhps2fpga_awid              (awid   ),
							.intel_agilex_5_soc_0_lwhps2fpga_awaddr            (awaddr ),
							.intel_agilex_5_soc_0_lwhps2fpga_awlen             (awlen  ),
							.intel_agilex_5_soc_0_lwhps2fpga_awsize            (awsize ),
							.intel_agilex_5_soc_0_lwhps2fpga_awburst           (awburst),
							.intel_agilex_5_soc_0_lwhps2fpga_awlock            (awlock ),
							.intel_agilex_5_soc_0_lwhps2fpga_awcache           (awcache),
							.intel_agilex_5_soc_0_lwhps2fpga_awprot            (awprot ),
							.intel_agilex_5_soc_0_lwhps2fpga_awvalid           (awvalid),
							.intel_agilex_5_soc_0_lwhps2fpga_awready           (awready),
							.intel_agilex_5_soc_0_lwhps2fpga_wdata             (wdata  ),
							.intel_agilex_5_soc_0_lwhps2fpga_wstrb             (wstrb  ),
							.intel_agilex_5_soc_0_lwhps2fpga_wlast             (wlast  ),
							.intel_agilex_5_soc_0_lwhps2fpga_wvalid            (wvalid ),
							.intel_agilex_5_soc_0_lwhps2fpga_wready            (wready ),
							.intel_agilex_5_soc_0_lwhps2fpga_bid               (bid    ),
							.intel_agilex_5_soc_0_lwhps2fpga_bresp             (bresp  ),
							.intel_agilex_5_soc_0_lwhps2fpga_bvalid            (bvalid ),
							.intel_agilex_5_soc_0_lwhps2fpga_bready            (bready ),
							.intel_agilex_5_soc_0_lwhps2fpga_arid              (arid   ),
							.intel_agilex_5_soc_0_lwhps2fpga_araddr            (araddr ),
							.intel_agilex_5_soc_0_lwhps2fpga_arlen             (arlen  ),
							.intel_agilex_5_soc_0_lwhps2fpga_arsize            (arsize ),
							.intel_agilex_5_soc_0_lwhps2fpga_arburst           (arburst),
							.intel_agilex_5_soc_0_lwhps2fpga_arlock            (arlock ),
							.intel_agilex_5_soc_0_lwhps2fpga_arcache           (arcache),
							.intel_agilex_5_soc_0_lwhps2fpga_arprot            (arprot ),
							.intel_agilex_5_soc_0_lwhps2fpga_arvalid           (arvalid),
							.intel_agilex_5_soc_0_lwhps2fpga_arready           (arready),
							.intel_agilex_5_soc_0_lwhps2fpga_rid               (rid    ),
							.intel_agilex_5_soc_0_lwhps2fpga_rdata             (rdata  ),
							.intel_agilex_5_soc_0_lwhps2fpga_rresp             (rresp  ),
							.intel_agilex_5_soc_0_lwhps2fpga_rlast             (rlast  ),
							.intel_agilex_5_soc_0_lwhps2fpga_rvalid            (rvalid ),
							.intel_agilex_5_soc_0_lwhps2fpga_rready            (rready ),
							.intel_agilex_5_soc_0_emac_ptp_clk_clk             (),
							.intel_agilex_5_soc_0_emac_timestamp_clk_clk       (),
							.intel_agilex_5_soc_0_emac_timestamp_data_data_in  (),
							.intel_agilex_5_soc_0_emac0_mdio_mac_mdc           (pp_app_emac0_mdio_mdc[0]),
							.intel_agilex_5_soc_0_emac0_mdio_mac_mdi           (app_pp_emac0_mdio_mdi[0]),
							.intel_agilex_5_soc_0_emac0_mdio_mac_mdo           (pp_app_emac0_mdio_mdo[0]),
							.intel_agilex_5_soc_0_emac0_mdio_mac_mdoe          (pp_app_emac0_mdio_mdoe[0]),
							.intel_agilex_5_soc_0_emac0_app_rst_reset_n        (),									//Output - Check - Should i connect this?
							.intel_agilex_5_soc_0_emac0_mac_tx_clk_o           (),
							.intel_agilex_5_soc_0_emac0_mac_rx_clk             (mrphy_hps_rx_clk[0]	),
							.intel_agilex_5_soc_0_emac0_mac_rst_tx_n           (hps_mrphy_tx_rst[0]	),
							.intel_agilex_5_soc_0_emac0_mac_rst_rx_n           (hps_mrphy_rx_rst[0]	),
							.intel_agilex_5_soc_0_emac0_mac_txen               (hps_mrphy_data_vld[0]),
							.intel_agilex_5_soc_0_emac0_mac_txer               (hps_mrphy_err[0]     ),
							.intel_agilex_5_soc_0_emac0_mac_rxdv               (mrphy_hps_data_vld[0]),
							.intel_agilex_5_soc_0_emac0_mac_rxer               (mrphy_hps_err[0]     ),
							.intel_agilex_5_soc_0_emac0_mac_rxd                (mrphy_hps_data[0]	),
							.intel_agilex_5_soc_0_emac0_mac_col                (),
							.intel_agilex_5_soc_0_emac0_mac_crs                (),
							.intel_agilex_5_soc_0_emac0_mac_speed              (mac_speed[0]			),
							.intel_agilex_5_soc_0_emac0_mac_txd_o              (hps_mrphy_data[0]	),
							.intel_agilex_5_soc_0_fpga2hps_interrupt_irq       ()									//Input - Check - Comes from CSR in block diagram?
						);	

					
						axi_avmm_bridge axi_avmm_inst (
							.axi_bridge_0_s0_awid         (awid   ),
							.axi_bridge_0_s0_awaddr       (awaddr ),
							.axi_bridge_0_s0_awlen        (awlen  ),
							.axi_bridge_0_s0_awsize       (awsize ),
							.axi_bridge_0_s0_awburst      (awburst),
							.axi_bridge_0_s0_awlock       (awlock ),
							.axi_bridge_0_s0_awcache      (awcache),
							.axi_bridge_0_s0_awprot       (awprot ),
							.axi_bridge_0_s0_awvalid      (awvalid),
							.axi_bridge_0_s0_awready      (awready),
							.axi_bridge_0_s0_wdata        (wdata  ),
							.axi_bridge_0_s0_wstrb        (wstrb  ),
							.axi_bridge_0_s0_wlast        (wlast  ),
							.axi_bridge_0_s0_wvalid       (wvalid ),
							.axi_bridge_0_s0_wready       (wready ),
							.axi_bridge_0_s0_bid          (bid    ),
							.axi_bridge_0_s0_bresp        (bresp  ),
							.axi_bridge_0_s0_bvalid       (bvalid ),
							.axi_bridge_0_s0_bready       (bready ),
							.axi_bridge_0_s0_arid         (arid   ),
							.axi_bridge_0_s0_araddr       (araddr ),
							.axi_bridge_0_s0_arlen        (arlen  ),
							.axi_bridge_0_s0_arsize       (arsize ),
							.axi_bridge_0_s0_arburst      (arburst),
							.axi_bridge_0_s0_arlock       (arlock ),
							.axi_bridge_0_s0_arcache      (arcache),
							.axi_bridge_0_s0_arprot       (arprot ),
							.axi_bridge_0_s0_arvalid      (arvalid),
							.axi_bridge_0_s0_arready      (arready),
							.axi_bridge_0_s0_rid          (rid    ),
							.axi_bridge_0_s0_rdata        (rdata  ),
							.axi_bridge_0_s0_rresp        (rresp  ),
							.axi_bridge_0_s0_rlast        (rlast  ),
							.axi_bridge_0_s0_rvalid       (rvalid ),
							.axi_bridge_0_s0_rready       (rready ),
							.clk_clk                      (csr_clk),
							.mm_bridge_0_m0_waitrequest   (waitrequest[0]  ),
							.mm_bridge_0_m0_readdata      (readdata[0]     ),
							.mm_bridge_0_m0_readdatavalid (readdatavalid[0]),
							.mm_bridge_0_m0_burstcount    (burstcount[0]   ),
							.mm_bridge_0_m0_writedata     (writedata[0]    ),
							.mm_bridge_0_m0_address       (address[0]      ),
							.mm_bridge_0_m0_write         (write[0]        ),
							.mm_bridge_0_m0_read          (read[0]         ),
							.mm_bridge_0_m0_byteenable    (byteenable[0]   ),
							.mm_bridge_0_m0_debugaccess   (debugaccess[0]  ),
							.mm_bridge_1_m0_waitrequest   (),
							.mm_bridge_1_m0_readdata      (),
							.mm_bridge_1_m0_readdatavalid (),
							.mm_bridge_1_m0_burstcount    (),
							.mm_bridge_1_m0_writedata     (),
							.mm_bridge_1_m0_address       (),
							.mm_bridge_1_m0_write         (),
							.mm_bridge_1_m0_read          (),
							.mm_bridge_1_m0_byteenable    (),
							.mm_bridge_1_m0_debugaccess   (),
							.reset_reset                  (csr_rst)
						);					
					end

				else
					begin
						hps_gmii hps_gmii_inst (
							.intel_agilex_5_soc_0_h2f_reset_reset_n            (h2f_reset),
							.intel_agilex_5_soc_0_lwhps2fpga_axi_clock_clk     (csr_clk),
							.intel_agilex_5_soc_0_lwhps2fpga_axi_reset_reset_n (csr_rst),
							.intel_agilex_5_soc_0_lwhps2fpga_awid              (awid   ),
							.intel_agilex_5_soc_0_lwhps2fpga_awaddr            (awaddr ),
							.intel_agilex_5_soc_0_lwhps2fpga_awlen             (awlen  ),
							.intel_agilex_5_soc_0_lwhps2fpga_awsize            (awsize ),
							.intel_agilex_5_soc_0_lwhps2fpga_awburst           (awburst),
							.intel_agilex_5_soc_0_lwhps2fpga_awlock            (awlock ),
							.intel_agilex_5_soc_0_lwhps2fpga_awcache           (awcache),
							.intel_agilex_5_soc_0_lwhps2fpga_awprot            (awprot ),
							.intel_agilex_5_soc_0_lwhps2fpga_awvalid           (awvalid),
							.intel_agilex_5_soc_0_lwhps2fpga_awready           (awready),
							.intel_agilex_5_soc_0_lwhps2fpga_wdata             (wdata  ),
							.intel_agilex_5_soc_0_lwhps2fpga_wstrb             (wstrb  ),
							.intel_agilex_5_soc_0_lwhps2fpga_wlast             (wlast  ),
							.intel_agilex_5_soc_0_lwhps2fpga_wvalid            (wvalid ),
							.intel_agilex_5_soc_0_lwhps2fpga_wready            (wready ),
							.intel_agilex_5_soc_0_lwhps2fpga_bid               (bid    ),
							.intel_agilex_5_soc_0_lwhps2fpga_bresp             (bresp  ),
							.intel_agilex_5_soc_0_lwhps2fpga_bvalid            (bvalid ),
							.intel_agilex_5_soc_0_lwhps2fpga_bready            (bready ),
							.intel_agilex_5_soc_0_lwhps2fpga_arid              (arid   ),
							.intel_agilex_5_soc_0_lwhps2fpga_araddr            (araddr ),
							.intel_agilex_5_soc_0_lwhps2fpga_arlen             (arlen  ),
							.intel_agilex_5_soc_0_lwhps2fpga_arsize            (arsize ),
							.intel_agilex_5_soc_0_lwhps2fpga_arburst           (arburst),
							.intel_agilex_5_soc_0_lwhps2fpga_arlock            (arlock ),
							.intel_agilex_5_soc_0_lwhps2fpga_arcache           (arcache),
							.intel_agilex_5_soc_0_lwhps2fpga_arprot            (arprot ),
							.intel_agilex_5_soc_0_lwhps2fpga_arvalid           (arvalid),
							.intel_agilex_5_soc_0_lwhps2fpga_arready           (arready),
							.intel_agilex_5_soc_0_lwhps2fpga_rid               (rid    ),
							.intel_agilex_5_soc_0_lwhps2fpga_rdata             (rdata  ),
							.intel_agilex_5_soc_0_lwhps2fpga_rresp             (rresp  ),
							.intel_agilex_5_soc_0_lwhps2fpga_rlast             (rlast  ),
							.intel_agilex_5_soc_0_lwhps2fpga_rvalid            (rvalid ),
							.intel_agilex_5_soc_0_lwhps2fpga_rready            (rready ),
							.intel_agilex_5_soc_0_emac_ptp_clk_clk             (),
							.intel_agilex_5_soc_0_emac_timestamp_clk_clk       (),
							.intel_agilex_5_soc_0_emac_timestamp_data_data_in  (),
							.intel_agilex_5_soc_0_emac0_mdio_mac_mdc           (pp_app_emac0_mdio_mdc[0]),
							.intel_agilex_5_soc_0_emac0_mdio_mac_mdi           (app_pp_emac0_mdio_mdi[0]),
							.intel_agilex_5_soc_0_emac0_mdio_mac_mdo           (pp_app_emac0_mdio_mdo[0]),
							.intel_agilex_5_soc_0_emac0_mdio_mac_mdoe          (pp_app_emac0_mdio_mdoe[0]),
							.intel_agilex_5_soc_0_emac0_app_rst_reset_n        (),
							.intel_agilex_5_soc_0_emac0_mac_tx_clk_o           (),
							.intel_agilex_5_soc_0_emac0_mac_rx_clk             (mrphy_hps_rx_clk[0]	),
							.intel_agilex_5_soc_0_emac0_mac_rst_tx_n           (hps_mrphy_tx_rst[0]	),
							.intel_agilex_5_soc_0_emac0_mac_rst_rx_n           (hps_mrphy_rx_rst[0]	),
							.intel_agilex_5_soc_0_emac0_mac_txen               (hps_mrphy_data_vld[0]),
							.intel_agilex_5_soc_0_emac0_mac_txer               (hps_mrphy_err[0]     ),
							.intel_agilex_5_soc_0_emac0_mac_rxdv               (mrphy_hps_data_vld[0]),
							.intel_agilex_5_soc_0_emac0_mac_rxer               (mrphy_hps_err[0]     ),
							.intel_agilex_5_soc_0_emac0_mac_rxd                (mrphy_hps_data[0]	),
							.intel_agilex_5_soc_0_emac0_mac_col                (),
							.intel_agilex_5_soc_0_emac0_mac_crs                (),
							.intel_agilex_5_soc_0_emac0_mac_speed              (mac_speed[0]			   ),
							.intel_agilex_5_soc_0_emac0_mac_txd_o              (hps_mrphy_data[0]	   ),
							.intel_agilex_5_soc_0_emac1_mdio_mac_mdc           (pp_app_emac0_mdio_mdc[1]),
							.intel_agilex_5_soc_0_emac1_mdio_mac_mdi           (app_pp_emac0_mdio_mdi[1]),
							.intel_agilex_5_soc_0_emac1_mdio_mac_mdo           (pp_app_emac0_mdio_mdo[1]),
							.intel_agilex_5_soc_0_emac1_mdio_mac_mdoe          (pp_app_emac0_mdio_mdoe[1]),
							.intel_agilex_5_soc_0_emac1_app_rst_reset_n        (),
							.intel_agilex_5_soc_0_emac1_mac_tx_clk_o           (),
							.intel_agilex_5_soc_0_emac1_mac_rx_clk             (mrphy_hps_rx_clk[1]	),
							.intel_agilex_5_soc_0_emac1_mac_rst_tx_n           (hps_mrphy_tx_rst[1]	),
							.intel_agilex_5_soc_0_emac1_mac_rst_rx_n           (hps_mrphy_rx_rst[1]	),
							.intel_agilex_5_soc_0_emac1_mac_txen               (hps_mrphy_data_vld[1]),
							.intel_agilex_5_soc_0_emac1_mac_txer               (hps_mrphy_err[1]     ),
							.intel_agilex_5_soc_0_emac1_mac_rxdv               (mrphy_hps_data_vld[1]),
							.intel_agilex_5_soc_0_emac1_mac_rxer               (mrphy_hps_err[1]     ),
							.intel_agilex_5_soc_0_emac1_mac_rxd                (mrphy_hps_data[1]	),
							.intel_agilex_5_soc_0_emac1_mac_col                (),
							.intel_agilex_5_soc_0_emac1_mac_crs                (),
							.intel_agilex_5_soc_0_emac1_mac_speed              (mac_speed[1]),
							.intel_agilex_5_soc_0_emac1_mac_txd_o              (hps_mrphy_data[1]),
							.intel_agilex_5_soc_0_emac2_i2c_mac_scl_i          (),
							.intel_agilex_5_soc_0_emac2_i2c_mac_scl_oe         (),
							.intel_agilex_5_soc_0_emac2_i2c_mac_sda_i          (),
							.intel_agilex_5_soc_0_emac2_i2c_mac_sda_oe         (),
							.intel_agilex_5_soc_0_emac2_app_rst_reset_n        (),
							.intel_agilex_5_soc_0_emac2_mac_tx_clk_o           (),
							.intel_agilex_5_soc_0_emac2_mac_rx_clk             (mrphy_hps_rx_clk[2]	),
							.intel_agilex_5_soc_0_emac2_mac_rst_tx_n           (hps_mrphy_tx_rst[2]	),
							.intel_agilex_5_soc_0_emac2_mac_rst_rx_n           (hps_mrphy_rx_rst[2]	),
							.intel_agilex_5_soc_0_emac2_mac_txen               (hps_mrphy_data_vld[2]),
							.intel_agilex_5_soc_0_emac2_mac_txer               (hps_mrphy_err[2]     ),
							.intel_agilex_5_soc_0_emac2_mac_rxdv               (mrphy_hps_data_vld[2]),
							.intel_agilex_5_soc_0_emac2_mac_rxer               (mrphy_hps_err[2]     ),
							.intel_agilex_5_soc_0_emac2_mac_rxd                (mrphy_hps_data[2]	),
							.intel_agilex_5_soc_0_emac2_mac_col                (),
							.intel_agilex_5_soc_0_emac2_mac_crs                (),
							.intel_agilex_5_soc_0_emac2_mac_speed              (mac_speed[2]),
							.intel_agilex_5_soc_0_emac2_mac_txd_o              (hps_mrphy_data[2]),
							.intel_agilex_5_soc_0_fpga2hps_interrupt_irq       ()									//Input - Check - Comes from CSR in block diagram?
							);
							
							
						axi_avmm_4s axi_avmm_4s_inst (	
							.axi_bridge_0_s0_awid         (awid   ),
							.axi_bridge_0_s0_awaddr       (awaddr ),	
							.axi_bridge_0_s0_awlen        (awlen  ),	
							.axi_bridge_0_s0_awsize       (awsize ),	
							.axi_bridge_0_s0_awburst      (awburst),	
							.axi_bridge_0_s0_awlock       (awlock ),	
							.axi_bridge_0_s0_awcache      (awcache),	
							.axi_bridge_0_s0_awprot       (awprot ),	
							.axi_bridge_0_s0_awvalid      (awvalid),	
							.axi_bridge_0_s0_awready      (awready),	
							.axi_bridge_0_s0_wid          (),	
							.axi_bridge_0_s0_wdata        (wdata  ),	
							.axi_bridge_0_s0_wstrb        (wstrb  ),	
							.axi_bridge_0_s0_wlast        (wlast  ),	
							.axi_bridge_0_s0_wvalid       (wvalid ),	
							.axi_bridge_0_s0_wready       (wready ),	
							.axi_bridge_0_s0_bid          (bid    ),	
							.axi_bridge_0_s0_bresp        (bresp  ),	
							.axi_bridge_0_s0_bvalid       (bvalid ),	
							.axi_bridge_0_s0_bready       (bready ),	
							.axi_bridge_0_s0_arid         (arid   ),	
							.axi_bridge_0_s0_araddr       (araddr ),	
							.axi_bridge_0_s0_arlen        (arlen  ),	
							.axi_bridge_0_s0_arsize       (arsize ),	
							.axi_bridge_0_s0_arburst      (arburst),	
							.axi_bridge_0_s0_arlock       (arlock ),	
							.axi_bridge_0_s0_arcache      (arcache),	
							.axi_bridge_0_s0_arprot       (arprot ),		
							.axi_bridge_0_s0_arvalid      (arvalid),		
							.axi_bridge_0_s0_arready      (arready),		
							.axi_bridge_0_s0_rid          (rid    ),		
							.axi_bridge_0_s0_rdata        (rdata  ),		
							.axi_bridge_0_s0_rresp        (rresp  ),		
							.axi_bridge_0_s0_rlast        (rlast  ),		
							.axi_bridge_0_s0_rvalid       (rvalid ),		
							.axi_bridge_0_s0_rready       (rready ),		
							.clk_clk                      (csr_clk),		
							.mm_bridge_0_m0_waitrequest   (waitrequest[0]  ),		
							.mm_bridge_0_m0_readdata      (readdata[0]     ),		
							.mm_bridge_0_m0_readdatavalid (readdatavalid[0]),		
							.mm_bridge_0_m0_burstcount    (burstcount[0]   ),		
							.mm_bridge_0_m0_writedata     (writedata[0]    ),		
							.mm_bridge_0_m0_address       (address[0]      ),		
							.mm_bridge_0_m0_write         (write[0]        ),		
							.mm_bridge_0_m0_read          (read[0]         ),		
							.mm_bridge_0_m0_byteenable    (byteenable[0]   ),				//Check - How to feed this as part of address??
							.mm_bridge_0_m0_debugaccess   (debugaccess[0]  ),		
							.mm_bridge_1_m0_waitrequest   (waitrequest[1]  ),		
							.mm_bridge_1_m0_readdata      (readdata[1]     ),		
							.mm_bridge_1_m0_readdatavalid (readdatavalid[1]),		
							.mm_bridge_1_m0_burstcount    (burstcount[1]   ),		
							.mm_bridge_1_m0_writedata     (writedata[1]    ),		
							.mm_bridge_1_m0_address       (address[1]      ),		
							.mm_bridge_1_m0_write         (write[1]        ),		
							.mm_bridge_1_m0_read          (read[1]         ),		
							.mm_bridge_1_m0_byteenable    (byteenable[1]   ),		
							.mm_bridge_1_m0_debugaccess   (debugaccess[1]  ),		
							.mm_bridge_2_m0_waitrequest   (waitrequest[2]  ),		
							.mm_bridge_2_m0_readdata      (readdata[2]     ),		
							.mm_bridge_2_m0_readdatavalid (readdatavalid[2]),		
							.mm_bridge_2_m0_burstcount    (burstcount[2]   ),		
							.mm_bridge_2_m0_writedata     (writedata[2]    ),		
							.mm_bridge_2_m0_address       (address[2]      ),		
							.mm_bridge_2_m0_write         (write[2]        ),		
							.mm_bridge_2_m0_read          (read[2]         ),		
							.mm_bridge_2_m0_byteenable    (byteenable[2]   ),		
							.mm_bridge_2_m0_debugaccess   (debugaccess[2]  ),		
							.mm_bridge_3_m0_waitrequest   (),		
							.mm_bridge_3_m0_readdata      (csr_rd_data),		
							.mm_bridge_3_m0_readdatavalid (csr_rd_vld),		
							.mm_bridge_3_m0_burstcount    (),		
							.mm_bridge_3_m0_writedata     (avmm_wr_data),		
							.mm_bridge_3_m0_address       (avmm_add),		
							.mm_bridge_3_m0_write         (avmm_wr),		
							.mm_bridge_3_m0_read          (avmm_rd),		
							.mm_bridge_3_m0_byteenable    (),		
							.mm_bridge_3_m0_debugaccess   (),		  
							.reset_reset                  (csr_rst)	  
						);		                                 
					end                                               
	                                                                  
	                                                                  
	                                                                  
		genvar i;                                                     
		for(i=0; i<NUM_PHY-1; i++)                                    
			begin	
				mrphy mrphy_inst (
						.intel_mge_phy_0_csr_clk_clk                                   (csr_clk), 
						.intel_mge_phy_0_gmii8b_tx_clkin_clk                           (), 					//Check what to connect ??
						.intel_mge_phy_0_tx_clkout_clk                                 (),
						.intel_mge_phy_0_rx_clkout_clk                                 (),
						.intel_mge_phy_0_gmii8b_tx_rst_n_gmii8b_tx_rst_n               (),
						.intel_mge_phy_0_gmii8b_rx_rst_n_gmii8b_rx_rst_n               (),
						.intel_mge_phy_0_gmii8b_rx_clkout_clk                          (mrphy_hps_rx_clk[i]),
						.intel_mge_phy_0_gmii8b_tx_clkout_clk                          (mrphy_hps_tx_clk[i]),
						.intel_mge_phy_0_reset_reset                                   (phy_rst),              
						.intel_mge_phy_0_rx_digitalreset_rx_digitalreset               (hps_mrphy_rx_rst[i]),  
						.intel_mge_phy_0_tx_digitalreset_tx_digitalreset               (hps_mrphy_tx_rst[i]),  
						.intel_mge_phy_0_avalon_mm_csr_readdata                        (readdata[i][15:0]),    
						.intel_mge_phy_0_avalon_mm_csr_writedata                       (writedata[i][15:0]),   
						.intel_mge_phy_0_avalon_mm_csr_address                         (address[i][4:0]),      
						.intel_mge_phy_0_avalon_mm_csr_waitrequest                     (waitrequest[i]),       
						.intel_mge_phy_0_avalon_mm_csr_read                            (read[i]),              
						.intel_mge_phy_0_avalon_mm_csr_write                           (write[i]),             
						.intel_mge_phy_0_gmii8b_mac_txen_export                        (hps_mrphy_data_vld[i]),
						.intel_mge_phy_0_gmii8b_mac_tx_d_export                        (hps_mrphy_data[i]),    
						.intel_mge_phy_0_gmii8b_mac_txer_export                        (hps_mrphy_err[i]),     
						.intel_mge_phy_0_gmii8b_mac_rxdv_export                        (mrphy_hps_data_vld[i]),
						.intel_mge_phy_0_gmii8b_mac_rxd_export                         (mrphy_hps_data[i]),    
						.intel_mge_phy_0_gmii8b_mac_rxer_export                        (mrphy_hps_err[i]),     
						.intel_mge_phy_0_gmii8b_mac_speed_export                       (mac_speed[i]),   
						.intel_mge_phy_0_led_link_export                               (),    
						.intel_mge_phy_0_led_char_err_export                           (),       	
						.intel_mge_phy_0_led_disp_err_export                           (),
						.intel_mge_phy_0_led_an_export                                 (),
						.intel_mge_phy_0_operating_speed_export                        (reg_op_speed[i]),
						.intel_mge_phy_0_mrphy_pll_lock_pll_locked_stable              (reg_mrphy_pll_lock[i]),
						.intel_mge_phy_0_i_src_ch_pause_request_o_src_ch_pause_request (),
						.intel_mge_phy_0_o_src_ch_pause_grant_i_src_ch_pause_grant     (),
						.intel_mge_phy_0_i_rst_n_i_rst_n                               (phy_rst_n[i]),          
						.intel_mge_phy_0_o_rst_ack_n_o_rst_ack_n                       (ack_rst_n[i]),          
						.intel_mge_phy_0_i_tx_rst_n_i_tx_rst_n                         (phy_tx_rst_n[i]),       
						.intel_mge_phy_0_i_rx_rst_n_i_rx_rst_n                         (phy_rx_rst_n[i]),       
						.intel_mge_phy_0_o_tx_rst_ack_n_o_tx_rst_ack_n                 (ack_tx_rst_n[i]),       
						.intel_mge_phy_0_o_rx_rst_ack_n_o_rx_rst_ack_n                 (ack_rx_rst_n[i]),       
						.intel_mge_phy_0_rx_cdr_refclk_p_clk                           (pll_mrphy_pll_156_clk), 
						.intel_mge_phy_0_rx_cdr_refclk_n_clk                           (~pll_mrphy_pll_156_clk),
						.intel_mge_phy_0_tx_ready_tx_ready                             (reg_tx_rdy[i]),            
						.intel_mge_phy_0_rx_ready_rx_ready                             (reg_rx_rdy[i]),            
						.intel_mge_phy_0_rx_pma_clkout_clk                             (),
						.intel_mge_phy_0_xcvr_mode_export                              (2'b00),      					
						.intel_mge_phy_0_tx_pll_refclk_p_clk                           (pll_mrphy_pll_156_clk),        
						.intel_mge_phy_0_tx_pll_refclk_n_clk                           (~pll_mrphy_pll_156_clk),       
						.intel_mge_phy_0_i_pma_cu_clk_clk                              (),				//(src_mrphy_clk[0]), 
						.intel_mge_phy_0_i_system_pll_clk_clk                          (pll_mrphy_pll_322_clk),        
						.intel_mge_phy_0_i_system_pll_lock_system_pll_lock             (pll_mrphy_pll_lock),       	
						.intel_mge_phy_0_i_src_rs_grant_src_rs_grant                   (1'b1),					//(src_mrphy_grant[i]),
						.intel_mge_phy_0_o_src_rs_req_src_rs_req                       (),					//(mrphy_src_req[i]),  
						.intel_mge_phy_0_tx_serial_data_o_tx_serial_data               (pp_app_tx_serial_data[i]),     
						.intel_mge_phy_0_tx_serial_data_n_o_tx_serial_data_n           (pp_app_tx_serial_data_n[i]),   
						.intel_mge_phy_0_rx_serial_data_i_rx_serial_data               (app_pp_rx_serial_data[i]),     
						.intel_mge_phy_0_rx_serial_data_n_i_rx_serial_data_n           (app_pp_rx_serial_data_n[i]),   
						.intel_mge_phy_0_rx_is_lockedtodata_o_rx_is_lockedtodata       (),     						
						.intel_mge_phy_0_reconfig_clk_clk                              (csr_clk),   					
						.intel_mge_phy_0_reconfig_reset_reset                          (1'b0), 
						.intel_mge_phy_0_reconfig_write                                (1'b0), 
						.intel_mge_phy_0_reconfig_read                                 (1'b0), 
						.intel_mge_phy_0_reconfig_address                              (18'b0),
						.intel_mge_phy_0_reconfig_byteenable                           (1'b0), 
						.intel_mge_phy_0_reconfig_writedata                            (32'b0),
						.intel_mge_phy_0_reconfig_readdata                             (),    	
						.intel_mge_phy_0_reconfig_waitrequest                          (),   	
						.intel_mge_phy_0_reconfig_readdatavalid                        () 	
					);
			end
		
	endgenerate
/*
								
						mrphy mrphy_inst (
						.csr_clk                 				(csr_clk),                 				//   input,   width = 1,                csr_clk.clk
						.tx_clkout               				(),             						    //  16 bit interface clk
						.rx_clkout               				(),              							//  16 bit interface clk
						.gmii8_tx_clkout         				(mrphy_hps_tx_clk[i]),         			//  output,   width = 1,        gmii8_tx_clkout.clk
						.gmii8_rx_clkout         				(mrphy_hps_rx_clk[i]),         				//  output,   width = 1,        gmii8_rx_clkout.clk
						.reset                   				(phy_rst),                					//   input,   width = 1		Check - Changed to phy_rst
						.rx_digitalreset         				(hps_mrphy_rx_rst[i]),         				//   input,   width = 1,        rx_digitalreset.rx_digitalreset
						.tx_digitalreset         				(hps_mrphy_tx_rst[i]),         				//   input,   width = 1,        tx_digitalreset.tx_digitalreset
						.csr_readdata            				(readdata[i][15:0]),       				//Check1     //  output,  width = 16,          avalon_mm_csr.readdata
						.csr_writedata           				(writedata[i][15:0]),      				//Check1    //   input,  width = 16,                       .writedata
						.csr_address             				(address[i][4:0]),          			        //Check1 //   input,   width = 5,                       .address
						.csr_waitrequest         				(waitrequest[i]),        							    //  output,   width = 1,                       .waitrequest
						.csr_read                				(read[i]),              				    //   input,   width = 1,                       .read
						.csr_write               				(write[i]),              					//   input,   width = 1,                       .write
						.gmii8b_mac_txen         				(hps_mrphy_data_vld[i]),         				//   input,   width = 1,        gmii8b_mac_txen.export
						.gmii8b_mac_tx_d         				(hps_mrphy_data[i]),        					//   input,   width = 8,        gmii8b_mac_tx_d.export
						.gmii8b_mac_txer         				(hps_mrphy_err[i]),         					//   input,   width = 1,        gmii8b_mac_txer.export
						.gmii8b_mac_rxdv         				(mrphy_hps_data_vld[i]),   			        //  output,   width = 1,        gmii8b_mac_rxdv.export
						.gmii8b_mac_rxd          				(mrphy_hps_data[i]),       				    //  output,   width = 8,         gmii8b_mac_rxd.export
						.gmii8b_mac_rxer         				(mrphy_hps_err[i]),       			        //  output,   width = 1,        gmii8b_mac_rxer.export
						.gmii8b_mac_col          				(mac_col_det[i]),         					//  output,   width = 1,         gmii8b_mac_col.export
						.gmii8b_mac_crs          				(mac_car_sense[i]),         					//  output,   width = 1,         gmii8b_mac_crs.export
						.gmii8b_mac_speed        				(mac_speed[i]),       						//   input,   width = 3,       gmii8b_mac_speed.export
						.led_link                				(),                						//  output,   width = 1,               led_link.export
						.led_char_err            				(),            							//  output,   width = 1,           led_char_err.export
						.led_disp_err            				(),            							//  output,   width = 1,           led_disp_err.export
						.led_an                  				(),                  						//  output,   width = 1,                 led_an.export
						.operating_speed         				(reg_op_speed),       						//  output,   width = 3,        operating_speed.export
						.o_src_ch_pause_request  				(),  										//   input,   width = 1, o_src_ch_pause_request.o_src_ch_pause_request
						.i_src_ch_pause_grant    				(),   										//  output,   width = 1,   i_src_ch_pause_grant.i_src_ch_pause_grant
						.i_rst_n                 				(phy_rst_n[i]),                				//   input,   width = 1,                i_rst_n.i_rst_n
						.o_rst_ack_n             				(ack_rst_n[i]),           					//  output,   width = 1,            o_rst_ack_n.o_rst_ack_n
						.i_tx_rst_n              				(phy_tx_rst_n[i]),              				//   input,   width = 1,             i_tx_rst_n.i_tx_rst_n
						.i_rx_rst_n              				(phy_rx_rst_n[i]),              				//   input,   width = 1,             i_rx_rst_n.i_rx_rst_n
						.o_tx_rst_ack_n          				(ack_tx_rst_n[i]),        					//  output,   width = 1,         o_tx_rst_ack_n.o_tx_rst_ack_n
						.o_rx_rst_ack_n          				(ack_rx_rst_n[i]),          					//  output,   width = 1,         o_rx_rst_ack_n.o_rx_rst_ack_n
						.rx_cdr_refclk_p         				(pll_mrphy_pll_156_clk),         			//   input,   width = 1,        rx_cdr_refclk_p.clk
						.rx_cdr_refclk_n         				(~pll_mrphy_pll_156_clk),          		//Check - Vasu, _connected_to_rx_cdr_refclk_n_         //   input,   width = 1,        rx_cdr_refclk_n.clk
						.tx_ready                				(reg_tx_rdy),              				//  output,   width = 1,               tx_ready.tx_ready
						.rx_ready                				(reg_rx_rdy),                				//  output,   width = 1,               rx_ready.rx_ready
						.gmii8b_mac_tx_clk_o     				(1'b1),     								//Check - Temp - connected to 1'b1//   input,   width = 1,    gmii8b_mac_tx_clk_o.clk
						.rx_pma_clkout           				(),           								//  output,   width = 1,          rx_pma_clkout.clk
						.xcvr_mode               				(2'b00),      							    //Check1 - Temp Connected, should be driven by DR         //   input,   width = 2,              xcvr_mode.export
						.tx_pll_refclk_p         				(pll_mrphy_pll_156_clk),        		    //   input,   width = 1,        tx_pll_refclk_p.clk
						.tx_pll_refclk_n         				(~pll_mrphy_pll_156_clk),                  //Check - Vasu,      //   input,   width = 1,        tx_pll_refclk_n.clk
						.i_pma_cu_clk            				(csr_clk),//(src_mrphy_clk[0]),                        //Check - Output should be from SRC SSS
						.system_pll_clk          				(pll_mrphy_pll_322_clk),                   //   input,   width = 1,         system_pll_clk.clk
						.i_system_pll_lock       				(pll_mrphy_pll_lock),       				//Check - Vasu, Temp - Connecting pll_lock signal //   input,   width = 1,        system_pll_lock.system_pll_lock
						.i_src_rs_grant          				(1'b1),//(src_mrphy_grant[i]),         				//   input,   width = 1,         i_src_rs_grant.src_rs_grant
						.o_src_rs_req            				(1'b0),//(mrphy_src_req[i]),            				//  output,   width = 1,           o_src_rs_req.src_rs_req
						.tx_serial_data          				(pp_app_tx_serial_data[i]),         			//  output,   width = 1,         tx_serial_data.o_tx_serial_data
						.tx_serial_data_n        				(pp_app_tx_serial_data_n[i]),        			//  output,   width = 1,       tx_serial_data_n.o_tx_serial_data_n
						.rx_serial_data          				(app_pp_rx_serial_data[i]),         			//   input,   width = 1,         rx_serial_data.i_rx_serial_data
						.rx_serial_data_n        				(app_pp_rx_serial_data_n[i]),      			//   input,   width = 1,       rx_serial_data_n.i_rx_serial_data_n
						.rx_is_lockedtodata      				(),     									//  Check - what is this/where to connect this signal //output,   width = 1,     rx_is_lockedtodata.o_rx_is_lockedtodata
						.reconfig_clk            				(csr_clk),   							    //Check        //   input,   width = 1,           reconfig_clk.clk
						.reconfig_reset          				(1'b0),         							//Check - Connected to 1'b0 for now,//   input,   width = 1,         reconfig_reset.reset
						.reconfig_write          				(1'b0),         							//Check - Connected to 1'b0 for now,//   input,   width = 1,               reconfig.write
						.reconfig_read           				(1'b0),         							//Check - Connected to 1'b0 for now, //   input,   width = 1,                       .read
						.reconfig_address        				(18'b0),       							//Check - Connected to 1'b0 for now, //   input,  width = 18,                       .address
						.reconfig_be             				(1'b0),        							//Check - Connected to 1'b0 for now,     //   input,   width = 4,                       .byteenable
						.reconfig_writedata      				(32'b0),      								//Check - Connected to 1'b0 for now,//   input,  width = 32,                       .writedata
						.reconfig_readdata       				(),    				   					//  output,  width = 32,                       .readdata
						.reconfig_waitrequest    				(),   					   					//  output,   width = 1,                       .waitrequest
						.reconfig_readdata_valid 				(), 					   					//  output,   width = 1,                       .readdatavalid
						.mrphy_pll_lock          				(reg_mrphy_pll_lock[i])//(pll_mrphy_pll_lock)           //  output,   width = 1,        
	);*/

	 
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