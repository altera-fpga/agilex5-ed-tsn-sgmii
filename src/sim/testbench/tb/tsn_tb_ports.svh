
     wire 	app_pp_osc_clk;
	  wire 	app_pp_system_clk;
	 //Reset
	  wire 	app_pp_system_rst_n;
	  logic [NUM_PHY-1:0] svt_reset;

	 //MDIO Interface
	  wire 	c3_emac0_mdio_mdio0;
	  wire 	c3_emac0_mdio_mdc0;
     //PPS interface
      wire [NUM_PHY-1:0] emac_ptp_trig;
      wire [NUM_PHY-1:0] emac_ptp_pps;
	 
	 
	 //MRPHY TX; RX
	  wire [NUM_PHY-1:0]	pp_app_tx_serial_data;
	  wire [NUM_PHY-1:0]	pp_app_tx_serial_data_n;
	  wire [NUM_PHY-1:0]	app_pp_rx_serial_data;
	  wire [NUM_PHY-1:0]	app_pp_rx_serial_data_n;
