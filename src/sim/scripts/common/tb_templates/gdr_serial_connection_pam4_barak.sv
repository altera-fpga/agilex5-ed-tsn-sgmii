   ////////////////////////////////////////////////////////////////
   /* This template defined 100G_2 PAM4 connections
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

    wire [`NUM_LANES_IP0-1:0] rx_serial_ip0_an;
    wire [`NUM_LANES_IP0-1:0] rx_serial_n_ip0_an;
    reg [`NUM_LANES_IP0-1:0]  tx_serial_pam4_ip0_an;
    reg [`NUM_LANES_IP0-1:0]  tx_serial_pam4_n_ip0_an;

    wire [`NUM_LANES_IP0-1:0] rx_serial_ip0_tmp;
    wire [`NUM_LANES_IP0-1:0] rx_serial_n_ip0_tmp;
	 
	 
    `ifndef ENABLE_ETH_VIP
    //////////////////////////////////////////////////
    // Loopback serial connection
    /////////////////////////////////////////////////
    assign rx_serial_ip0                        = tx_serial_ip0;
    assign rx_serial_n_ip0                      = tx_serial_n_ip0;
    `else

   
     `ifdef ANLT
     
        //////////////////////////////////////////////////
        // PAM4 serial connection
        /////////////////////////////////////////////////

	generate
          for(genvar i=0; i<`NUM_LANES_IP0;i++) begin
            assign rx_serial_n_ip0_tmp[i] =  svt_ethernet_txrx_if[0].tx_lane[2*i];
            assign rx_serial_ip0_tmp[i] = svt_ethernet_txrx_if[0].tx_lane[(2*i)+1];
	    assign svt_ethernet_txrx_if[0].rx_lane[2*i] =     eth_env_top.spy_if_ip0.an_enable ? ((eth_env_top.spy_if_ip0.an_done == 0) ? tx_serial_pam4_n_ip0_an[0] : tx_serial_n_ip0[i]) : tx_serial_n_ip0[i];
            assign svt_ethernet_txrx_if[0].rx_lane[(2*i)+1] = eth_env_top.spy_if_ip0.an_enable ? ((eth_env_top.spy_if_ip0.an_done == 0) ? tx_serial_pam4_ip0_an[0]   : tx_serial_ip0[i]) : tx_serial_ip0[i];
          end
        endgenerate

       

	 //VIP TX to DUT RX
         assign rx_serial_ip0   =   eth_env_top.spy_if_ip0.an_enable ? ((eth_env_top.spy_if_ip0.an_done == 0) ? rx_serial_ip0_an   :  rx_serial_ip0_tmp) : rx_serial_ip0_tmp;
         assign rx_serial_n_ip0 =   eth_env_top.spy_if_ip0.an_enable ? ((eth_env_top.spy_if_ip0.an_done == 0) ? rx_serial_n_ip0_an :  rx_serial_n_ip0_tmp) :  rx_serial_n_ip0_tmp;


       `ifdef LANES_1


         assign rx_serial_ip0_an[0]    = svt_ethernet_txrx_if[0].tx_lane[0];
         assign rx_serial_n_ip0_an  = ~rx_serial_ip0_an;
         
         //ANCHAN Mux 
         assign tx_serial_pam4_n_ip0_an[0] =  tx_serial_ip0[0];
         assign tx_serial_pam4_ip0_an   =  ~tx_serial_ip0;

       `elsif LANES_2

	 assign rx_serial_ip0_an[0] = (spy_if_ip0.an_ch_sel==0) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[1];
         assign rx_serial_ip0_an[1] = (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[1];
         assign rx_serial_n_ip0_an  = ~rx_serial_ip0_an;

         //ANCHAN mux
	 assign tx_serial_pam4_n_ip0_an[0] = (spy_if_ip0.an_ch_sel==0) ? tx_serial_ip0[0] : tx_serial_ip0[1]; 
         assign tx_serial_pam4_n_ip0_an[1] = (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[0] : tx_serial_ip0[1]; 
         assign tx_serial_pam4_ip0_an   =  ~tx_serial_ip0;

       `elsif LANES_4


	 assign rx_serial_ip0_an[0] = (spy_if_ip0.an_ch_sel==0) ? svt_ethernet_txrx_if[0].tx_lane[0] : 
	                              (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[1] : 
				      (spy_if_ip0.an_ch_sel==2) ? svt_ethernet_txrx_if[0].tx_lane[2] : svt_ethernet_txrx_if[0].tx_lane[3];
         assign rx_serial_ip0_an[1] = (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[1];
         assign rx_serial_ip0_an[2] = (spy_if_ip0.an_ch_sel==2) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[2];
         assign rx_serial_ip0_an[3] = (spy_if_ip0.an_ch_sel==3) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[3];
         assign rx_serial_n_ip0_an  = ~rx_serial_ip0_an;

         //ANCHAN mux
	 assign tx_serial_pam4_n_ip0_an[0] = (spy_if_ip0.an_ch_sel==0) ? tx_serial_ip0[0] : 
	                                     (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[1] : 
					     (spy_if_ip0.an_ch_sel==2) ? tx_serial_ip0[2] : tx_serial_ip0[3]; 
         assign tx_serial_pam4_n_ip0_an[1] = (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[0] : tx_serial_ip0[1]; 
         assign tx_serial_pam4_n_ip0_an[2] = (spy_if_ip0.an_ch_sel==2) ? tx_serial_ip0[0] : tx_serial_ip0[2]; 
         assign tx_serial_pam4_n_ip0_an[3] = (spy_if_ip0.an_ch_sel==3) ? tx_serial_ip0[0] : tx_serial_ip0[3]; 
         assign tx_serial_pam4_ip0_an   =  ~tx_serial_ip0;

       `elsif LANES_8

	 assign rx_serial_ip0_an[0] = (spy_if_ip0.an_ch_sel==0) ? svt_ethernet_txrx_if[0].tx_lane[0] : (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[1] : (spy_if_ip0.an_ch_sel==2) ? svt_ethernet_txrx_if[0].tx_lane[2] : (spy_if_ip0.an_ch_sel==3) ? svt_ethernet_txrx_if[0].tx_lane[3] : (spy_if_ip0.an_ch_sel==4) ? svt_ethernet_txrx_if[0].tx_lane[4] : (spy_if_ip0.an_ch_sel==5) ? svt_ethernet_txrx_if[0].tx_lane[5] : (spy_if_ip0.an_ch_sel==6) ? svt_ethernet_txrx_if[0].tx_lane[6] : svt_ethernet_txrx_if[0].tx_lane[7];
         assign rx_serial_ip0_an[1] = (spy_if_ip0.an_ch_sel==1) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[1];
         assign rx_serial_ip0_an[2] = (spy_if_ip0.an_ch_sel==2) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[2];
         assign rx_serial_ip0_an[3] = (spy_if_ip0.an_ch_sel==3) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[3];
         assign rx_serial_ip0_an[4] = (spy_if_ip0.an_ch_sel==4) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[4];
         assign rx_serial_ip0_an[5] = (spy_if_ip0.an_ch_sel==5) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[5];
         assign rx_serial_ip0_an[6] = (spy_if_ip0.an_ch_sel==6) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[6];
         assign rx_serial_ip0_an[7] = (spy_if_ip0.an_ch_sel==7) ? svt_ethernet_txrx_if[0].tx_lane[0] : svt_ethernet_txrx_if[0].tx_lane[7];
         assign rx_serial_n_ip0_an  = ~rx_serial_ip0_an;

         //ANCHAN mux
	 assign tx_serial_pam4_n_ip0_an[0] = (spy_if_ip0.an_ch_sel==0) ? tx_serial_ip0[0] : (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[1] : (spy_if_ip0.an_ch_sel==2) ? tx_serial_ip0[2] : (spy_if_ip0.an_ch_sel==3) ? tx_serial_ip0[3] : (spy_if_ip0.an_ch_sel==4) ? tx_serial_ip0[4] : (spy_if_ip0.an_ch_sel==5) ? tx_serial_ip0[5] : (spy_if_ip0.an_ch_sel==6) ? tx_serial_ip0[6] : tx_serial_ip0[7]; 
         assign tx_serial_pam4_n_ip0_an[1] = (spy_if_ip0.an_ch_sel==1) ? tx_serial_ip0[0] : tx_serial_ip0[1]; 
         assign tx_serial_pam4_n_ip0_an[2] = (spy_if_ip0.an_ch_sel==2) ? tx_serial_ip0[0] : tx_serial_ip0[2]; 
         assign tx_serial_pam4_n_ip0_an[3] = (spy_if_ip0.an_ch_sel==3) ? tx_serial_ip0[0] : tx_serial_ip0[3]; 
         assign tx_serial_pam4_n_ip0_an[4] = (spy_if_ip0.an_ch_sel==4) ? tx_serial_ip0[0] : tx_serial_ip0[4]; 
         assign tx_serial_pam4_n_ip0_an[5] = (spy_if_ip0.an_ch_sel==5) ? tx_serial_ip0[0] : tx_serial_ip0[5]; 
         assign tx_serial_pam4_n_ip0_an[6] = (spy_if_ip0.an_ch_sel==6) ? tx_serial_ip0[0] : tx_serial_ip0[6]; 
         assign tx_serial_pam4_n_ip0_an[7] = (spy_if_ip0.an_ch_sel==7) ? tx_serial_ip0[0] : tx_serial_ip0[7];
         assign tx_serial_pam4_ip0_an   =  ~tx_serial_ip0;

     `endif



   `else



    //////////////////////////////////////////////////
    // PAM4 serial connection
    /////////////////////////////////////////////////
    //TODO: Temporary workaround p and n Barak serial pin inverse issue for snap46. HSD#https://hsdes.intel.com/appstore/article/#/1508680656
    generate
    for(genvar i=0; i<`NUM_LANES_IP0;i++) begin
      assign rx_serial_n_ip0[i] = svt_ethernet_txrx_if[0].tx_lane[2*i];
      assign rx_serial_ip0[i] = svt_ethernet_txrx_if[0].tx_lane[(2*i)+1];		
      assign svt_ethernet_txrx_if[0].rx_lane[2*i] = tx_serial_n_ip0[i];
      assign svt_ethernet_txrx_if[0].rx_lane[(2*i)+1] = tx_serial_ip0[i];		
    end
    endgenerate


     `endif //not ANLT 

	 
	 `endif //NO LB

