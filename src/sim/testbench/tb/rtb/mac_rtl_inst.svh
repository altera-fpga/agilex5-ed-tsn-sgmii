
    
    // GMII TX from MAC to PHY
    wire [NUM_PHY-1:0] [1:0]  gmii16b_tx_en;
    wire [NUM_PHY-1:0] [15:0] gmii16b_tx_d;
    wire [NUM_PHY-1:0] [1:0]  gmii16b_tx_err;
    
    
    
    // GMII RX from PHY to MAC
    wire [NUM_PHY-1:0] [1:0]  gmii16b_rx_dv;
    wire [NUM_PHY-1:0] [15:0] gmii16b_rx_d;
    wire [NUM_PHY-1:0] [1:0]  gmii16b_rx_err;
    //csr pins 
    wire [NUM_PHY-1:0][9:0]   csr_mac_address;
    wire [NUM_PHY-1:0]        csr_mac_read;
    wire [NUM_PHY-1:0]        csr_mac_write;
    wire [NUM_PHY-1:0] [31:0] csr_mac_writedata;
    wire [NUM_PHY-1:0] [31:0] csr_mac_readdata;
    wire [NUM_PHY-1:0]        csr_mac_waitrequest;
    
    wire [NUM_PHY-1:0] [31:0] avalon_st_tx_data;
    wire [NUM_PHY-1:0] [1:0]  avalon_st_tx_empty;
    
    wire [NUM_PHY-1:0]        avalon_st_rx_ready;
    wire [NUM_PHY-1:0] [31:0] avalon_st_rx_data;
    wire [NUM_PHY-1:0] [1:0]  avalon_st_rx_empty;
    //logic                     mac_clk;
    
    logic [NUM_PHY-1:0]       mac_rxdv_i;
    logic [NUM_PHY-1:0] [7:0] mac_rxd_i;
    logic [NUM_PHY-1:0]       mac_rxer_i;


    logic [NUM_PHY-1:0] clk1_gated;
    logic [NUM_PHY-1:0] clk2_gated;
    logic [NUM_PHY-1:0] clk3_gated;
    logic [NUM_PHY-1:0] gated_clk;


    //always #3200 mac_clk = ~mac_clk;

    generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin: mac_gen

         alt_em10g32_0 mac (
        // CSR Clock
        .csr_clk                        (csr_clk),
        
        // MAC User Clock
        .tx_156_25_clk                  (mac_clk),
        .rx_156_25_clk                  (mac_clk),
        
        // Reset
        .csr_rst_n                      (i_mac_tx_rst_n[n]),
        .tx_rst_n                       (i_mac_tx_rst_n[n]),
        .rx_rst_n                       (i_mac_rx_rst_n[n]),
        
        // MAC CSR
        .csr_address                    (csr_mac_address[n]),
        .csr_read                       (csr_mac_read[n]),
        .csr_write                      (csr_mac_write[n]),
        .csr_writedata                  (csr_mac_writedata[n]),
        .csr_readdata                   (csr_mac_readdata[n]),
        .csr_waitrequest                (csr_mac_waitrequest[n]),
        //clk enable  
    //    .rx_clkena                       (rx_clkena),
    //    .tx_clkena                       (tx_clkena),
        
        // MAC TX User Frame
        .avalon_st_tx_valid             (avalon_st_tx_valid[n]),
        .avalon_st_tx_ready             (avalon_st_tx_ready[n]),
        .avalon_st_tx_startofpacket     (avalon_st_tx_startofpacket[n]),
        .avalon_st_tx_endofpacket       (avalon_st_tx_endofpacket[n]),
        .avalon_st_tx_data              (avalon_st_tx_data[n]),
        .avalon_st_tx_empty             (avalon_st_tx_empty[n]),
        .avalon_st_tx_error             (avalon_st_tx_error[n]),
        
        // MAC RX User Frame
        .avalon_st_rx_valid             (avalon_st_rx_valid[n]),
        .avalon_st_rx_ready             (avalon_st_rx_ready[n]),
        .avalon_st_rx_startofpacket     (avalon_st_rx_startofpacket[n]),
        .avalon_st_rx_endofpacket       (avalon_st_rx_endofpacket[n]),
        .avalon_st_rx_data              (avalon_st_rx_data[n]),
        .avalon_st_rx_empty             (avalon_st_rx_empty[n]),
        .avalon_st_rx_error             (avalon_st_rx_error[n]),
        
        // MAC TX Frame Status
        .avalon_st_txstatus_valid       (avalon_st_txstatus_valid[n]),
        .avalon_st_txstatus_data        (avalon_st_txstatus_data[n]),
        .avalon_st_txstatus_error       (avalon_st_txstatus_error[n]),
        
        // MAC RX Frame Status
        .avalon_st_rxstatus_valid       (avalon_st_rxstatus_valid[n]),
        .avalon_st_rxstatus_data        (avalon_st_rxstatus_data[n]),
        .avalon_st_rxstatus_error       (avalon_st_rxstatus_error[n]),
        
        // MAC TX Pause Frame Generation Command
        .avalon_st_pause_data           (avalon_st_pause_data[n]),
        
        // GMII Clock from PHY to MAC
        .gmii16b_tx_clk                 (gmii16b_tx_clk[n]),
        .gmii16b_rx_clk                 (gmii16b_rx_clk[n]),
        
        // [Atchaiah] GMII TX from MAC to 16bto8b adapter
        .gmii16b_tx_en                  (gmii16b_rx_dv[n]),
        .gmii16b_tx_d                   (gmii16b_rx_d[n]),
        .gmii16b_tx_err                 (gmii16b_rx_err[n]),
        
        //[Atchaiah] GMII RX from 8bto16b adapter to MAC
        .gmii16b_rx_dv                  (gmii16b_tx_en[n]),
        .gmii16b_rx_d                   (gmii16b_tx_d[n]),
        .gmii16b_rx_err                 (gmii16b_tx_err[n]),


        
        // PHY Operating Speed to MAC
        .speed_sel                      (operating_speed[n])
      );

        // Gate each clock signal with its respective enable
    assign clk1_gated[n] = pll_125m_clk[n] & (operating_speed[n] == 1'd1 | operating_speed[n] == 3'd4);
    assign clk2_gated[n] = pll_25m_clk[n] & operating_speed[n] == 3'd2;
    assign clk3_gated[n] = pll_2_5m_clk[n] & operating_speed[n] == 3'd3;

    // Generate the final gated clock by OR-ing the gated clocks together
    assign gated_clk[n] = clk1_gated[n] | clk2_gated[n] | clk3_gated[n];

    assign adapter_rx_clk[n] = gated_clk[n];
    //HPS MAC adapter 
    
      hps_to_mge_gmii_adapter_core reverse_adapter (
        
        //8 bit clk
         .mac_rx_clk                   (),
        .mac_tx_clk_i                 (),
        .mac_tx_clk_o                (mac_rx_clk[n]),
        //16 bit clk
        .phy_tx_clkout                 (gmii16b_rx_clk[n]),
        .phy_rx_clkout                  (gmii16b_tx_clk[n]),
         //pll clocks 
         .pll_125m_clk                 (pll_125m_clk[n]),//`DUT_IOPLL_CLK.outclk_0),
        .pll_25m_clk                    (pll_25m_clk[n]),//`DUT_IOPLL_CLK.outclk_2),
        .pll_2_5m_clk                  (pll_2_5m_clk[n]),//`DUT_IOPLL_CLK.outclk_3),
         //Adapter reset 
        .mac_rst_rx_n                    (adpt_mac_rx_rst_n[n]),
        .mac_rst_tx_n                    (adpt_mac_tx_rst_n[n]),
        
        //GMII TX from 16bto8b adapter to PHY
        .mac_rxdv                 (mac_txen[n]),
        .mac_rxd                   (mac_txd_o[n]),
        .mac_rxer                  (mac_txer[n]),
         /* 
        .mac_rxdv                 (mac_rxdv_i[n]),
        .mac_rxd                   (mac_rxd_i[n]),
        .mac_rxer                  (mac_rxer[n]),
        */
        /*
        .mac_rxdv                 (intel_agilex_5_soc_0_emac0_mac_txen[n]),
        .mac_rxd                   (intel_agilex_5_soc_0_emac0_mac_txd_o[n]),
        .mac_rxer                  (intel_agilex_5_soc_0_emac0_mac_txer[n]),
        .tx_disable                (intel_agilex_5_soc_0_emac0_mac_rst_rx_n[n]),
         */

        // GMII RX from PHY to 8bto16b adapter
        .mac_txen                  (mac_rxdv[n]),
        .mac_txd                   (mac_rxd[n]),
        .mac_txer                  (mac_rxer[n]),
  
         .mac_col                  (),
         .mac_crs                  (),

        //clk enable  
        .phy_tx_clkena                       (phy_tx_clkena[n]),//`DUT_ADAPTER_ENA.phy_tx_clkena),
        .phy_rx_clkena                       (phy_tx_clkena[n]),//(`DUT_ADAPTER_ENA.phy_tx_clkena),

        //  GMII TX from MAC to 16bto8b adapter
        .gmii16b_rx_dv                  (gmii16b_rx_dv[n]),
        .gmii16b_rx_d                   (gmii16b_rx_d[n]),
        .gmii16b_rx_err                 (gmii16b_rx_err[n]),
        
        //PLL locked - TODO : earlier planned to connect from IOPLL instance - now directly connecting mrphy - to     //cross check with sudhir 
        .pll_locked                          (iopll_lock[n]),
       

        // GMII RX from 8bto16b adapter to MAC
        .gmii16b_tx_en                  (gmii16b_tx_en[n]),
        .gmii16b_tx_d                   (gmii16b_tx_d[n]),
        .gmii16b_tx_err                 (gmii16b_tx_err[n]),

  
        .phy_speed                           (operating_speed[n]),
        .mac_speed                            ({operating_speed[n][1],~operating_speed[n][0]})
        
         );
         /* 
         initial begin
            force intel_agilex_5_soc_0_emac0_mac_txen[n] = mac_txen[n];
            force intel_agilex_5_soc_0_emac0_mac_txd_o[n] = mac_txd_o[n];
            force intel_agilex_5_soc_0_emac0_mac_txer[n] = mac_txer[n];
         end
         */
      end
   endgenerate

