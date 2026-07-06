   ////////////////////////////////////////////////////////////////
   /* This template defined 100_4 NRZ 
    * Py script will use it as reference
    * create mode specific connections by replaceing indexes
    * Each IP will have a separate connection file generated
    * Generated files will be included in TB_TOP
   */

   //////////////////////////////////////////////////
   // DUT in/out port serial connection wires
   /////////////////////////////////////////////////
    wire [`NUM_LANES_IP0-1:0] tx_serial_ip0;
    wire [`NUM_LANES_IP0-1:0] tx_serial_n_ip0;
    wire [`NUM_LANES_IP0-1:0] rx_serial_ip0;
    wire [`NUM_LANES_IP0-1:0] rx_serial_n_ip0;
    
    `ifndef ENABLE_ETH_VIP
    //////////////////////////////////////////////////
    // Loopback serial connection
    /////////////////////////////////////////////////
    assign rx_serial_ip0                        = tx_serial_ip0;
    assign rx_serial_n_ip0                      = tx_serial_n_ip0;

    `else
    //////////////////////////////////////////////////
    // NRZ serial connection
    /////////////////////////////////////////////////
    //
    //

      `ifdef ANLT
         `ifdef LANES_1
	      assign svt_ethernet_txrx_if[0].rx_lane[`NUM_LANES_IP0-1:0] = tx_serial_ip0; 
              assign rx_serial_ip0                        = svt_ethernet_txrx_if[0].tx_lane[`NUM_LANES_IP0-1:0];
              assign rx_serial_n_ip0                      = ~rx_serial_ip0;
	 `elsif LANES_2
              assign rx_serial_ip0[0] = (spy_if_ip0.an_ch_sel==0) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[1];
              assign rx_serial_ip0[1] = (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[1];
              assign svt_ethernet_txrx_if[0].rx_lane[0] = (spy_if_ip0.an_ch_sel==0) ? tx_serial_ip0[0] : tx_serial_ip0[1]; 
              assign svt_ethernet_txrx_if[0].rx_lane[1] = (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[0] : tx_serial_ip0[1]; 
              assign rx_serial_n_ip0                      = ~rx_serial_ip0;
	 `elsif LANES_4
              assign rx_serial_ip0[0] = (spy_if_ip0.an_ch_sel==0) ? svt_ethernet_txrx_if[0].tx_lane[0] : (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[1] : (spy_if_ip0.an_ch_sel==2) ? svt_ethernet_txrx_if[0].tx_lane[2] : svt_ethernet_txrx_if[0].tx_lane[3];
              assign rx_serial_ip0[1] = (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[1];
              assign rx_serial_ip0[2] = (spy_if_ip0.an_ch_sel==2) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[2];
              assign rx_serial_ip0[3] = (spy_if_ip0.an_ch_sel==3) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[3];
              assign svt_ethernet_txrx_if[0].rx_lane[0] = (spy_if_ip0.an_ch_sel==0) ? tx_serial_ip0[0] : (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[1] : (spy_if_ip0.an_ch_sel==2) ? tx_serial_ip0[2] : tx_serial_ip0[3]; 
              assign svt_ethernet_txrx_if[0].rx_lane[1] = (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[0] : tx_serial_ip0[1]; 
              assign svt_ethernet_txrx_if[0].rx_lane[2] = (spy_if_ip0.an_ch_sel==2) ? tx_serial_ip0[0] : tx_serial_ip0[2]; 
              assign svt_ethernet_txrx_if[0].rx_lane[3] = (spy_if_ip0.an_ch_sel==3) ? tx_serial_ip0[0] : tx_serial_ip0[3]; 
              assign rx_serial_n_ip0                      = ~rx_serial_ip0;
	 `elsif LANES_8
              assign rx_serial_ip0[0] = (spy_if_ip0.an_ch_sel==0) ? svt_ethernet_txrx_if[0].tx_lane[0] : (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[1] : (spy_if_ip0.an_ch_sel==2) ? svt_ethernet_txrx_if[0].tx_lane[2] : (spy_if_ip0.an_ch_sel==3) ? svt_ethernet_txrx_if[0].tx_lane[3] : (spy_if_ip0.an_ch_sel==4) ? svt_ethernet_txrx_if[0].tx_lane[4] : (spy_if_ip0.an_ch_sel==5) ? svt_ethernet_txrx_if[0].tx_lane[5] : (spy_if_ip0.an_ch_sel==6) ? svt_ethernet_txrx_if[0].tx_lane[6] : svt_ethernet_txrx_if[0].tx_lane[7];
              assign rx_serial_ip0[1] = (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[1];
              assign rx_serial_ip0[2] = (spy_if_ip0.an_ch_sel==2) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[2];
              assign rx_serial_ip0[3] = (spy_if_ip0.an_ch_sel==3) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[3];
              assign rx_serial_ip0[4] = (spy_if_ip0.an_ch_sel==4) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[4];
              assign rx_serial_ip0[5] = (spy_if_ip0.an_ch_sel==5) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[5];
              assign rx_serial_ip0[6] = (spy_if_ip0.an_ch_sel==6) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[6];
              assign rx_serial_ip0[7] = (spy_if_ip0.an_ch_sel==7) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[7];
              assign svt_ethernet_txrx_if[0].rx_lane[0] = (spy_if_ip0.an_ch_sel==0) ? tx_serial_ip0[0] : (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[1] : (spy_if_ip0.an_ch_sel==2) ? tx_serial_ip0[2] : (spy_if_ip0.an_ch_sel==3) ? tx_serial_ip0[3] : (spy_if_ip0.an_ch_sel==4) ? tx_serial_ip0[4] : (spy_if_ip0.an_ch_sel==5) ? tx_serial_ip0[5] : (spy_if_ip0.an_ch_sel==6) ? tx_serial_ip0[6] : tx_serial_ip0[7]; 
              assign svt_ethernet_txrx_if[0].rx_lane[1] = (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[0] : tx_serial_ip0[1]; 
              assign svt_ethernet_txrx_if[0].rx_lane[2] = (spy_if_ip0.an_ch_sel==2) ? tx_serial_ip0[0] : tx_serial_ip0[2]; 
              assign svt_ethernet_txrx_if[0].rx_lane[3] = (spy_if_ip0.an_ch_sel==3) ? tx_serial_ip0[0] : tx_serial_ip0[3]; 
              assign svt_ethernet_txrx_if[0].rx_lane[4] = (spy_if_ip0.an_ch_sel==4) ? tx_serial_ip0[0] : tx_serial_ip0[4]; 
              assign svt_ethernet_txrx_if[0].rx_lane[5] = (spy_if_ip0.an_ch_sel==5) ? tx_serial_ip0[0] : tx_serial_ip0[5]; 
              assign svt_ethernet_txrx_if[0].rx_lane[6] = (spy_if_ip0.an_ch_sel==6) ? tx_serial_ip0[0] : tx_serial_ip0[6]; 
              assign svt_ethernet_txrx_if[0].rx_lane[7] = (spy_if_ip0.an_ch_sel==7) ? tx_serial_ip0[0] : tx_serial_ip0[7]; 
              assign rx_serial_n_ip0                      = ~rx_serial_ip0;
         `endif

      `else
        `ifdef COMPL_TC
         `ifdef ETH_MULTI_PORT
           assign svt_ethernet_txrx_if[0].rx_lane[`NUM_LANES_IP0-1][`NUM_LANES_IP0-1] = (eth_env_top.spy_if_ip0.loopback_enable == 1) ? 0 : tx_serial_ip0; 
           assign rx_serial_ip0                        = (eth_env_top.spy_if_ip0.loopback_enable == 1) ? tx_serial_ip0 : svt_ethernet_txrx_if[0].tx_lane[`NUM_LANES_IP0-1][`NUM_LANES_IP0-1];
         `else
           assign svt_ethernet_txrx_if[0].rx_lane[`NUM_LANES_IP0-1:0] = (eth_env_top.spy_if_ip0.loopback_enable == 1) ? 0 : tx_serial_ip0; 
           assign rx_serial_ip0                        = (eth_env_top.spy_if_ip0.loopback_enable == 1) ? tx_serial_ip0 : svt_ethernet_txrx_if[0].tx_lane[`NUM_LANES_IP0-1:0];
         `endif
        `else
           assign svt_ethernet_txrx_if[0].rx_lane[`NUM_LANES_IP0-1:0] = (eth_env_top.spy_if_ip0.loopback_enable == 1) ? 0 : tx_serial_ip0; 
           assign rx_serial_ip0                        = (eth_env_top.spy_if_ip0.loopback_enable == 1) ? tx_serial_ip0 : svt_ethernet_txrx_if[0].tx_lane[`NUM_LANES_IP0-1:0];
        `endif
         assign rx_serial_n_ip0                      = ~rx_serial_ip0;

         
     
       `endif



    `endif


