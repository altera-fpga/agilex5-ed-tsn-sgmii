      //inout from phy;
      inout [NUM_PHY-1:0]        gmii16b_tx_clk,
      inout [NUM_PHY-1:0]        gmii16b_rx_clk,
      inout [NUM_PHY-1:0] [2:0]  operating_speed,
      inout [NUM_PHY-1:0]        pll_125m_clk,
      inout [NUM_PHY-1:0]        pll_25m_clk,
      inout [NUM_PHY-1:0]        pll_2_5m_clk,
      inout [NUM_PHY-1:0]        phy_tx_clkena,
      inout [NUM_PHY-1:0]        phy_rx_clkena,
      inout [NUM_PHY-1:0]        iopll_lock,
      //inout from external;
      inout [NUM_PHY-1:0]        avalon_st_pause_data,
      inout [NUM_PHY-1:0]        i_mac_tx_rst_n,
      inout [NUM_PHY-1:0]        i_mac_rx_rst_n,
      inout                      csr_clk,
      inout [NUM_PHY-1:0]        adpt_mac_rx_rst_n,
      inout [NUM_PHY-1:0]        adpt_mac_tx_rst_n,
      inout [NUM_PHY-1:0]        avalon_st_tx_error,
      inout [NUM_PHY-1:0]        avalon_st_tx_valid,
      inout [NUM_PHY-1:0]        avalon_st_tx_endofpacket,         
      inout [NUM_PHY-1:0]        avalon_st_rx_error,
      inout [NUM_PHY-1:0]        avalon_st_rx_endofpacket,
      inout [NUM_PHY-1:0]        tx_avst_if_reset,
      inout [NUM_PHY-1:0]        rx_avst_if_reset,
      inout [NUM_PHY-1:0]        csr_reset,
      inout                      mac_clk,
      // MAC TX Frame Status
      inout [NUM_PHY-1:0]        avalon_st_txstatus_valid,
      inout [NUM_PHY-1:0] [39:0] avalon_st_txstatus_data,
      inout [NUM_PHY-1:0] [6:0]  avalon_st_txstatus_error,
      // MAC RX Frame Status
      inout [NUM_PHY-1:0]        avalon_st_rxstatus_valid,
      inout [NUM_PHY-1:0] [39:0] avalon_st_rxstatus_data,
      inout [NUM_PHY-1:0] [6:0]  avalon_st_rxstatus_error,
      //inout to external
      inout [NUM_PHY-1:0]        tx_skip_crc,
      inout [NUM_PHY-1:0]        avalon_st_tx_ready,
      inout [NUM_PHY-1:0]        avalon_st_rx_valid,
      inout [NUM_PHY-1:0]        avalon_st_rx_startofpacket,
      inout [NUM_PHY-1:0]        avalon_st_tx_startofpacket,
      inout [NUM_PHY-1:0]        adapter_rx_clk,

      inout                      emac0_mdio_mac_mdc,          
		inout                      emac0_mdio_mac_mdi,          
		inout                      emac0_mdio_mac_mdo,          
		inout                      emac0_mdio_mac_mdoe,        

		inout                      h2f_reset_reset_n,           //           h2f_reset.reset_n
      inout                      reset_reset_n,
		inout                      emac_ptp_clk_clk,            //        emac_ptp_clk.clk
		inout                      emac_timestamp_clk_clk,      //  emac_timestamp_clk.clk

      inout [NUM_PHY-1:0]        mac_tx_clk_o,              //                   emac0.mac_tx_clk_o
		inout [NUM_PHY-1:0]        mac_tx_clk_i,              //                        .mac_tx_clk_i
		inout [NUM_PHY-1:0]        mac_rx_clk,                //                        .mac_rx_clk
		inout [NUM_PHY-1:0]        mac_rst_tx_n,              //                        .mac_rst_tx_n
		inout [NUM_PHY-1:0]        mac_rst_rx_n,              //                        .mac_rst_rx_n
		inout [NUM_PHY-1:0]        mac_txen,                  //                        .mac_txen
		inout [NUM_PHY-1:0]        mac_txer,                  //                        .mac_txer
		inout [NUM_PHY-1:0]        mac_rxdv,                  //                        .mac_rxdv
		inout [NUM_PHY-1:0]        mac_rxer,                  //                        .mac_rxer
		inout [NUM_PHY-1:0][7:0]   mac_rxd,                   //                        .mac_rxd
		inout [NUM_PHY-1:0]        mac_col,                   //                        .mac_col
		inout [NUM_PHY-1:0]        mac_crs,                   //                        .mac_crs
		inout [NUM_PHY-1:0][2:0]   mac_speed,                 //                        .mac_speed
		inout [NUM_PHY-1:0][7:0]   mac_txd_o,

      inout                      emif_hps_emif_mem_0_mem_ck_t,    //     emif_hps_emif_mem_0.mem_ck_t
		inout                      emif_hps_emif_mem_0_mem_ck_c,    //                        .mem_ck_c
		inout                      emif_hps_emif_mem_0_mem_cke,     //                        .mem_cke
		inout                      emif_hps_emif_mem_0_mem_odt,     //                        .mem_odt
		inout                      emif_hps_emif_mem_0_mem_cs_n,    //                        .mem_cs_n
		inout [16:0]               emif_hps_emif_mem_0_mem_a,       //                        .mem_a
		inout [1:0]                emif_hps_emif_mem_0_mem_ba,      //                        .mem_ba
		inout                      emif_hps_emif_mem_0_mem_bg,      //                        .mem_bg
		inout                      emif_hps_emif_mem_0_mem_act_n,   //                        .mem_act_n
		inout                      emif_hps_emif_mem_0_mem_par,     //                        .mem_par
		inout                      emif_hps_emif_mem_0_mem_alert_n, //                        .mem_alert_n
		inout                      emif_hps_emif_mem_0_mem_reset_n, //                        .mem_reset_n
		inout [31:0]               emif_hps_emif_mem_0_mem_dq,      //                        .mem_dq
		inout [3:0]                emif_hps_emif_mem_0_mem_dqs_t,   //                        .mem_dqs_t
		inout [3:0]                emif_hps_emif_mem_0_mem_dqs_c,   //                        .mem_dqs_c
		inout                      emif_hps_emif_oct_0_oct_rzqin,   //     emif_hps_emif_oct_0.oct_rzqin
		inout                      emif_hps_emif_ref_clk_0_clk,     // emif_hps_emif_ref_clk_0.clk
	   
      inout                      clk_clk,              //          clk.clk
		inout                      rst_reset_n,          //          rst.reset_n
		inout [3:0]                awid,                 //              lwhps2fpga.awid
		inout [28:0]               awaddr,               //                        .awaddr
		inout [7:0]                awlen,                //                        .awlen
		inout [2:0]                awsize,               //                        .awsize
		inout [1:0]                awburst,              //                        .awburst
		inout                      awlock,               //                        .awlock
		inout [3:0]                awcache,              //                        .awcache
		inout [2:0]                awprot,               //                        .awprot
		inout                      awvalid,              //                        .awvalid
		inout                      awready,              //                        .awready
		inout [31:0]               wdata,                //                        .wdata
		inout [3:0]                wstrb,                //                        .wstrb
		inout                      wlast,                //                        .wlast
		inout                      wvalid,               //                        .wvalid
		inout                      wready,               //                        .wready
		inout [3:0]                bid,                  //                        .bid
		inout [1:0]                bresp,                //                        .bresp
		inout                      bvalid,               //                        .bvalid
		inout                      bready,               //                        .bready
		inout [3:0]                arid,                 //                        .arid
		inout [28:0]               araddr,               //                        .araddr
		inout [7:0]                arlen,                //                        .arlen
		inout [2:0]                arsize,               //                        .arsize
		inout [1:0]                arburst,              //                        .arburst
		inout                      arlock,               //                        .arlock
		inout [3:0]                arcache,              //                        .arcache
		inout [2:0]                arprot,               //                        .arprot
		inout                      arvalid,              //                        .arvalid
		inout                      arready,              //                        .arready
		inout [3:0]                rid,                  //                        .rid
		inout [31:0]               rdata,                //                        .rdata
		inout [1:0]                rresp,                //                        .rresp
		inout                      rlast,                //                        .rlast
		inout                      rvalid,               //                        .rvalid
		inout                      rready               //                        .rready
