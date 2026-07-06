
`define HPS_RTB_INST_PARAM(PREFIX, PATH)\
	hps_rtb #(\
      .IP_PATH          	(``PATH``),\
      .IS_ACTIVE           (uvm_pkg::UVM_ACTIVE),\
      .DUT_PATH            ("top_tb.dut.dut"),\
		.NUM_PHY			      (NUM_PHY)\
	) hps_rtb_i ();


`define HPS_RTB_INST_SIG(RTB_INST,PREFIX)\
  if(``RTB_INST``.IS_ACTIVE == uvm_pkg::UVM_ACTIVE) begin\
	//assign ``RTB_INST``.clk_clk					   =  ``PREFIX``.clk_clk;\
	assign ``PREFIX``.h2f_reset_reset            =  ``RTB_INST``.h2f_reset_reset_n;\
	assign ``RTB_INST``.emac_ptp_clk_clk         =  ``PREFIX``.emac_ptp_clk_clk;\
	assign ``RTB_INST``.emac_timestamp_clk_clk   =  ``PREFIX``.emac_timestamp_clk_clk;\
   assign ``PREFIX``.emac0_mac_tx_clk_o         =  ``RTB_INST``.mac_tx_clk_o[0];\
   assign ``RTB_INST``.mac_tx_clk_i[0]          = ``PREFIX``.emac0_mac_tx_clk_i;\
   assign ``RTB_INST``.mac_rx_clk[0]            = ``PREFIX``.emac0_mac_rx_clk;\
   assign ``PREFIX``.emac0_mac_rst_tx_n         =  ``RTB_INST``.mac_rst_tx_n[0];\
   assign ``PREFIX``.emac0_mac_rst_rx_n         =  ``RTB_INST``.mac_rst_rx_n[0];\
   assign ``PREFIX``.emac0_mac_txen             =  ``RTB_INST``.mac_txen[0];\
   assign ``PREFIX``.emac0_mac_txer             =  ``RTB_INST``.mac_txer[0];\
   assign ``RTB_INST``.mac_rxdv[0]              = ``PREFIX``.emac0_mac_rxdv;\
   assign ``RTB_INST``.mac_rxer[0]              = ``PREFIX``.emac0_mac_rxer;\
   assign ``RTB_INST``.mac_rxd[0]               = ``PREFIX``.emac0_mac_rxd;\
   assign ``RTB_INST``.mac_col[0]               = ``PREFIX``.emac0_mac_col;\
   assign ``RTB_INST``.mac_crs[0]               = ``PREFIX``.emac0_mac_crs;\
   assign ``PREFIX``.emac0_mac_speed            =  ``RTB_INST``.mac_speed[0];\
   assign ``PREFIX``.emac0_mac_txd_o            =  ``RTB_INST``.mac_txd_o[0];\
   if(NUM_PHY == 3) begin\
      assign ``PREFIX``.emac1_mac_tx_clk_o   =  ``RTB_INST``.mac_tx_clk_o[1];\
      assign ``RTB_INST``.mac_tx_clk_i[1]    = ``PREFIX``.emac1_mac_tx_clk_i;\
      assign ``RTB_INST``.mac_rx_clk[1]      = ``PREFIX``.emac1_mac_rx_clk;\
      assign ``PREFIX``.emac1_mac_rst_tx_n   =  ``RTB_INST``.mac_rst_tx_n[1];\
      assign ``PREFIX``.emac1_mac_rst_rx_n   =  ``RTB_INST``.mac_rst_rx_n[1];\
      assign ``PREFIX``.emac1_mac_txen       =  ``RTB_INST``.mac_txen[1];\
      assign ``PREFIX``.emac1_mac_txer       =  ``RTB_INST``.mac_txer[1];\
      assign ``RTB_INST``.mac_rxdv[1]        = ``PREFIX``.emac1_mac_rxdv;\
      assign ``RTB_INST``.mac_rxer[1]        = ``PREFIX``.emac1_mac_rxer;\
      assign ``RTB_INST``.mac_rxd[1]         = ``PREFIX``.emac1_mac_rxd;\
      assign ``RTB_INST``.mac_col[1]         = ``PREFIX``.emac1_mac_col;\
      assign ``RTB_INST``.mac_crs[1]         = ``PREFIX``.emac1_mac_crs;\
      assign ``PREFIX``.emac1_mac_speed      =  ``RTB_INST``.mac_speed[1];\
      assign ``PREFIX``.emac1_mac_txd_o      =  ``RTB_INST``.mac_txd_o[1];\
      assign ``PREFIX``.emac2_mac_tx_clk_o   =  ``RTB_INST``.mac_tx_clk_o[2];\
      assign ``RTB_INST``.mac_tx_clk_i[2]    = ``PREFIX``.emac2_mac_tx_clk_i;\
      assign ``RTB_INST``.mac_rx_clk[2]      = ``PREFIX``.emac2_mac_rx_clk;\
      assign ``PREFIX``.emac2_mac_rst_tx_n   =  ``RTB_INST``.mac_rst_tx_n[2];\
      assign ``PREFIX``.emac2_mac_rst_rx_n   =  ``RTB_INST``.mac_rst_rx_n[2];\
      assign ``PREFIX``.emac2_mac_txen       =  ``RTB_INST``.mac_txen[2];\
      assign ``PREFIX``.emac2_mac_txer       =  ``RTB_INST``.mac_txer[2];\
      assign ``RTB_INST``.mac_rxdv[2]        = ``PREFIX``.emac2_mac_rxdv;\
      assign ``RTB_INST``.mac_rxer[2]        = ``PREFIX``.emac2_mac_rxer;\
      assign ``RTB_INST``.mac_rxd[2]         = ``PREFIX``.emac2_mac_rxd;\
      assign ``RTB_INST``.mac_col[2]         = ``PREFIX``.emac2_mac_col;\
      assign ``RTB_INST``.mac_crs[2]         = ``PREFIX``.emac2_mac_crs;\
      assign ``PREFIX``.emac2_mac_speed      =  ``RTB_INST``.mac_speed[2];\
      assign ``PREFIX``.emac2_mac_txd_o      =  ``RTB_INST``.mac_txd_o[2];\
   end\
   else begin\
      //assign ``PREFIX``.emac0_mdio_mac_mdc   =  ``RTB_INST``.emac0_mdio_mac_mdc;\
      //assign ``RTB_INST``.emac0_mdio_mac_mdi =  ``PREFIX``.emac0_mdio_mac_mdi;\
      //assign ``PREFIX``.emac0_mdio_mac_mdo   =  ``RTB_INST``.emac0_mdio_mac_mdo;\
      //assign ``PREFIX``.emac0_mdio_mac_mdoe  =  ``RTB_INST``.emac0_mdio_mac_mdoe;\
   end\
  // assign ``RTB_INST``.reset_reset_n      = ``PREFIX``.reset_reset_n;\
   assign ``PREFIX``.lwhps2fpga_awid      =  ``RTB_INST``.awid;\
   assign ``PREFIX``.lwhps2fpga_awaddr    =  ``RTB_INST``.awaddr;\
   assign ``PREFIX``.lwhps2fpga_awlen     =  ``RTB_INST``.awlen;\
   assign ``PREFIX``.lwhps2fpga_awsize    =  ``RTB_INST``.awsize;\
   assign ``PREFIX``.lwhps2fpga_awburst   =  ``RTB_INST``.awburst;\
   assign ``PREFIX``.lwhps2fpga_awlock    =  ``RTB_INST``.awlock;\
   assign ``PREFIX``.lwhps2fpga_awcache   =  ``RTB_INST``.awcache;\
   assign ``PREFIX``.lwhps2fpga_awprot    =  ``RTB_INST``.awprot;\
   assign ``PREFIX``.lwhps2fpga_awvalid   =  ``RTB_INST``.awvalid;\
   assign ``RTB_INST``.awready            =  ``PREFIX``.lwhps2fpga_awready;\
   assign ``PREFIX``.lwhps2fpga_wdata     =  ``RTB_INST``.wdata;\
   assign ``PREFIX``.lwhps2fpga_wstrb     =  ``RTB_INST``.wstrb;\
   assign ``PREFIX``.lwhps2fpga_wlast     =  ``RTB_INST``.wlast;\
   assign ``PREFIX``.lwhps2fpga_wvalid    =  ``RTB_INST``.wvalid;\
   assign ``RTB_INST``.wready             =  ``PREFIX``.lwhps2fpga_wready;\
   assign ``RTB_INST``.bid                =  ``PREFIX``.lwhps2fpga_bid;\
   assign ``RTB_INST``.bresp              =  ``PREFIX``.lwhps2fpga_bresp;\
   assign ``RTB_INST``.bvalid             =  ``PREFIX``.lwhps2fpga_bvalid;\
   assign ``PREFIX``.lwhps2fpga_bready    =  ``RTB_INST``.bready;\
   assign ``PREFIX``.lwhps2fpga_arid      =  ``RTB_INST``.arid;\
   assign ``PREFIX``.lwhps2fpga_araddr    =  ``RTB_INST``.araddr;\
   assign ``PREFIX``.lwhps2fpga_arlen     =  ``RTB_INST``.arlen;\
   assign ``PREFIX``.lwhps2fpga_arsize    =  ``RTB_INST``.arsize;\
   assign ``PREFIX``.lwhps2fpga_arburst   =  ``RTB_INST``.arburst;\
   assign ``PREFIX``.lwhps2fpga_arlock    =  ``RTB_INST``.arlock;\
   assign ``PREFIX``.lwhps2fpga_arcache   =  ``RTB_INST``.arcache;\
   assign ``PREFIX``.lwhps2fpga_arprot    =  ``RTB_INST``.arprot;\
   assign ``PREFIX``.lwhps2fpga_arvalid   =  ``RTB_INST``.arvalid;\
   assign ``RTB_INST``.arready            =  ``PREFIX``.lwhps2fpga_arready;\
   assign ``RTB_INST``.rid                =  ``PREFIX``.lwhps2fpga_rid;\
   assign ``RTB_INST``.rdata              =  ``PREFIX``.lwhps2fpga_rdata;\
   assign ``RTB_INST``.rresp              =  ``PREFIX``.lwhps2fpga_rresp;\
   assign ``RTB_INST``.rlast              =  ``PREFIX``.lwhps2fpga_rlast;\
   assign ``RTB_INST``.rvalid             =  ``PREFIX``.lwhps2fpga_rvalid;\
   assign ``PREFIX``.lwhps2fpga_rready    =  ``RTB_INST``.rready;\
  end

`HPS_RTB_INST_PARAM(dut.soc_inst.subsys_hps, "uvm_test_top.m_env.parser_env")
`HPS_RTB_INST_SIG(hps_rtb_i, dut.soc_inst.subsys_hps)  
