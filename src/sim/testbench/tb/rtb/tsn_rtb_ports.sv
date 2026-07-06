   
   input [NUM_PHY-1:0]   svt_reset,     //used by tb
   inout    app_pp_osc_clk,
   inout  	app_pp_system_clk,

	//Reset
	inout 	app_pp_system_rst_n,
	 
	//MDIO Interface
	inout   c3_emac0_mdio_mdio0,
	inout 	c3_emac0_mdio_mdc0,

    //PPS interface
    inout  [NUM_PHY-1:0]  emac_ptp_trig,
    inout  [NUM_PHY-1:0]  emac_ptp_pps,
	 
	inout    hps_osc_clk,
    inout    fpga_reset_n,
    inout    osc_clk,
    inout    fpga_clk_100,

	//MRPHY TX, RX
	inout [NUM_PHY-1:0]	pp_app_tx_serial_data,
	inout [NUM_PHY-1:0]	pp_app_tx_serial_data_n,
	inout [NUM_PHY-1:0]	app_pp_rx_serial_data,
	inout [NUM_PHY-1:0]	app_pp_rx_serial_data_n
