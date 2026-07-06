// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


//all in unit pico
`define SVT_ETHERNET_SERIAL_BASER_CLOCK                 (96.969/2.0) 
`define SVT_ETHERNET_SERIAL_BASE4X_CLOCK                160
`ifdef ETH_MULTI_PORT
 `define SVT_ETHERNET_SERIAL_BASEX_CLOCK                 400
 `define SVT_ETHERNET_GMII_CLOCK                         4000
`else
 `ifdef ETH_MGE_1G
   `define SVT_ETHERNET_SERIAL_BASEX_CLOCK                 400 //400 for 1G
   `define SVT_ETHERNET_GMII_CLOCK                         4000//4000 for 1G
 `else
     `ifdef 2_5G_SPEED 
   `define SVT_ETHERNET_SERIAL_BASEX_CLOCK                 160 //160 for 2p5G
   `define SVT_ETHERNET_GMII_CLOCK                         1600//1600 for 2p5G
   `else 
   `define SVT_ETHERNET_SERIAL_BASEX_CLOCK                 400 //400 for 1G
   `define SVT_ETHERNET_GMII_CLOCK                         4000//4000 for 1G
   `endif 
 `endif
`endif
 `ifdef ETH_NF_1G
   `define SVT_ETHERNET_SERIAL_BASEX_CLOCK                 400 //400 for 1G
   `define SVT_ETHERNET_GMII_CLOCK                         4000//4000 for 1G
 `endif
`define SVT_ETHERNET_25MHZ_CLOCK                        20000
`define SVT_ETHERNET_2PT5_MHZ_CLOCK                     200000
`define SVT_ETHERNET_SGMII_CLOCK                        80
`define SVT_ETHERNET_QSGMII_CLOCK                       100
`define SVT_ETHERNET_TBI_CLOCK                          4000
`define SVT_ETHERNET_XLGMII_CLOCK                       800
`define SVT_ETHERNET_XXGMII_CLOCK                       1600
`define SVT_ETHERNET_CGMII_CLOCK                        320
`define SVT_ETHERNET_CGMII_MIMIC_DUT_CLOCK              160
`define SVT_ETHERNET_XLGMII_MIMIC_DUT_CLOCK             400
`define SVT_ETHERNET_XGMII_CLOCK                        (6400/2)
`define SVT_ETHERNET_FBI_CLOCK                          1600
`define SVT_ETHERNET_SERIAL_CLOCK_BASEX                 40
`ifdef ETH_MULTI_PORT
 `define SVT_ETHERNET_XSBI_CLOCK                         (1552/2.0)
`else
 `define SVT_ETHERNET_XSBI_CLOCK                         775.7591
`endif
`define SVT_ETHERNET_VSBI_CLOCK                         (3103.04/2.0)
`define SVT_ETHERNET_VSBI_CLOCK_CAUI_25x4_64B_PARALLEL  (3103.03/2.0)
`define SVT_ETHERNET_CAUI_64B_PARALLEL_CLOCK            (2482.424/2)   
`define SVT_ETHERNET_REFERENCE_CLOCK                    50 
`define SVT_ETHERNET_ROUND_TRIP_TIME                    4000
`define SVT_ETHERNET_RMII_CLOCK                         10000
`define SVT_ETHERNET_GMII_RMII_CLOCK                    40000
`define SVT_ETHERNET_MDIO_CLOCK                         200
`define SVT_ETHERNET_PTP_SYS_CLOCK                      500000
`ifdef CRETE3
`define SVT_ETHERNET_KR4_FEC_40_CLOCK                   (38.788*40/2)
`define SVT_ETHERNET_KR4_FEC_66_CLOCK                   (38.788*66/2)
`define SVT_ETHERNET_KR4_FEC_64_CLOCK                   (38.788*64/2)
`define SVT_ETHERNET_SERIAL_12pt5G_CLOCK                (38.788)
`else
`define SVT_ETHERNET_KR4_FEC_40_CLOCK                   (38.75*40/2)
`define SVT_ETHERNET_KR4_FEC_66_CLOCK                   (38.75*66/2)
`define SVT_ETHERNET_KR4_FEC_64_CLOCK                   (38.75*64/2)
`define SVT_ETHERNET_SERIAL_12pt5G_CLOCK                (38.75)
`endif
//`define SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK              (38.75/2)
//`define SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK              (38.788/2)
`define SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK_NEG_PPM      (38.792/2) //25.778 GHZ
`define SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK_POS_PPM      (38.784/2) //25.783 GHZ
`define SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK              (38.788/2) //25.781 GHz
`define SVT_ETHERNET_XXVGMII_CLOCK                      (2560/2)
`define SVT_ETHERNET_LGMII_CLOCK                        640
`define SVT_ETHERNET_XXVSBI_CLOCK                       (620.608/2)
`define SVT_ETHERNET_LSBI_CLOCK                         (620.608)
`define SVT_ETHERNET_PCS66_XGMIICLK                     (640/2)
`define SVT_ETHERNET_PCS66_XSBICLK                      (155.152/2)
`define SVT_ETHERNET_PCS66_SERIAL_BASER_CLK             (9.697/2)
`define SVT_ETHERNET_PCS66_50GX2_XGMIICLK               (1280/2)
`define SVT_ETHERNET_PCS66_50GX2_XSBICLK                (310.304/2)
`define SVT_ETHERNET_PCS66_50GX2_SERIAL_BASER_CLK       (19.394/2)
`define SVT_ETHERNET_CD_CLK0                            18.823
`define SVT_ETHERNET_CD_CLK1                            18.824
`define SVT_ETHERNET_CD_CLK0_POS_PPM                    18.821
`define SVT_ETHERNET_CD_CLK1_POS_PPM                    18.822
`define SVT_ETHERNET_CD_CLK_NEG_PPM                     18.825

`define SVT_ETHERNET_CCMII_CLK                          160
`define SVT_ETHERNET_CDXBI_CLK                          188.235
`define SVT_ETHERNET_SERIAL_50G_CLK                     9.412

//25G/50G - 6400, 100G - 6400.68 , 200G/400G - 6399.36 
`define PCS66_XGMII_FREQ(N,F) ((N)/(2*F))
`define PCS66_XSBI_FREQ(F)  ((1551.515)/(2*F))
`define PCS66_BASER_FREQ(F) ((96.97)/(2*F))
  
  /** Signal to generate the clock */
  bit [NUM_PHY-1 : 0]xgmii66_clk;
  bit [NUM_PHY-1 : 0]xsbi66_clk;
  bit [NUM_PHY-1 : 0]serial_baser_clk;
  bit xgmii66_50gx2_clk;
  bit xsbi66_50gx2_clk;
  bit serial_baser_50gx2_clk;
  bit reference_clk        ;
  bit gmii_rx_clk          ; 
  bit gmii_tx_clk          ; 
  bit rgmii_rx_clk         ; 
  bit rgmii_tx_clk         ; 
  bit mii_100M_tx_clk      ;
  bit mii_100M_rx_clk      ;
  bit mii_10M_tx_clk       ;
  bit mii_10M_rx_clk       ;
  bit xgmii_tx_clk         ; 
  bit xgmii_rx_clk         ;
  bit ptp_system_clk       ;
  bit xlgmii_tx_clk        ; 
  bit xlgmii_rx_clk        ;
  bit xxgmii_tx_clk        ;
  bit xxgmii_rx_clk        ;
  bit tbi_tx_clk           ; 
  bit tbi_rx_clk           ; 
  bit rmii_tx_clk          ;
  bit rmii_rx_clk          ;
  bit gmii_rmii_tx_clk     ; 
  bit gmii_rmii_rx_clk     ; 
  bit xfbi_rx_clk          ; 
  bit xfbi_tx_clk          ; 
  bit xsbi_tx_clk          ; 
  bit xsbi_rx_clk          ; 
  bit gmii_mdc             ; 
  bit serial_tx_baser_clk  ; 
  bit serial_rx_baser_clk  ;
  bit serial_tx_basex_clk  ; 
  bit serial_rx_basex_clk  ;
  bit serial_tx_base4x_clk ; 
  bit serial_rx_base4x_clk ; 
  bit vsbi_rx_clk          ; 
  bit vsbi_tx_clk          ; 
  bit cgmii_tx_clk         ; 
  bit cgmii_rx_clk         ; 
  bit caui_64b_clk         ;
  bit mdio_clk             ;
  bit qsgmii_sync_status   ;
  bit qsgmii_sync_status_tx;
  bit qsgmii_sync_status_rx;
  bit smii_tx_clk           ;
  bit smii_rx_clk           ;
  bit clk_66t_tx            ; 
  bit clk_40t_tx            ;
  bit clk_66t_rx            ; 
  bit clk_40t_rx            ;
  bit serial_caui_25g_clk_tx;
  bit serial_caui_25g_clk_rx;
  bit serial_caui_25g_clk_tx_pos_ppm;
  bit serial_caui_25g_clk_rx_pos_ppm;
  bit serial_caui_25g_clk_tx_neg_ppm;
  bit serial_caui_25g_clk_rx_neg_ppm;
  bit caui_64b_clk_tx;
  bit caui_64b_clk_rx;
  bit xxvgmii_tx_clk       ;
  bit xxvgmii_rx_clk       ;
  bit lgmii_tx_clk         ;
  bit lgmii_rx_clk         ;
  bit lsbi_tx_clk          ;
  bit lsbi_rx_clk          ;
  bit xxvsbi_tx_clk        ;
  bit xxvsbi_rx_clk        ;
  bit serial_12pt5g_clk_tx ;
  bit serial_12pt5g_clk_rx ;
  bit serial_cd_tx_clk ;
  bit serial_cd_rx_clk ;
  bit serial_cd_tx_clk_pos_ppm ;
  bit serial_cd_rx_clk_pos_ppm ;
  bit serial_cd_tx_clk_neg_ppm ;
  bit serial_cd_rx_clk_neg_ppm ;

  bit ccmii_tx_clk;
  bit ccmii_rx_clk;
  bit cdxbi_tx_clk;
  bit cdxbi_rx_clk;
  bit serial_50g_tx_clk;
  bit serial_50g_rx_clk;

  svt_ethernet_txrx_if svt_ethernet_txrx_if[NUM_PHY](reference_clk);
  svt_ethernet_txrx_if uif_pcs66[NUM_PHY](reference_clk); 
  eth_testsuite_tasks_intf ts_tasks_if[NUM_PHY]();

  real freq_ratio [NUM_PHY-1 : 0];
  real numerator [NUM_PHY-1 : 0];
  genvar i;
  genvar j;
  genvar z;

  initial begin
    reference_clk         = 1'b0;
    gmii_rx_clk           = 1'b0; 
    gmii_tx_clk           = 1'b0; 
    rgmii_rx_clk          = 1'b0; 
    rgmii_tx_clk          = 1'b0; 
    mii_100M_tx_clk       = 1'b0; 
    mii_100M_rx_clk       = 1'b0; 
    mii_10M_tx_clk        = 1'b0; 
    mii_10M_rx_clk        = 1'b0; 
    xgmii_tx_clk          = 1'b0; 
    xgmii_rx_clk          = 1'b0;
    ptp_system_clk        = 1'b0;
    xlgmii_tx_clk         = 1'b0; 
    xlgmii_rx_clk         = 1'b0;
    xxgmii_tx_clk         = 1'b0;
    xxgmii_rx_clk         = 1'b0;
    tbi_tx_clk            = 1'b0; 
    tbi_rx_clk            = 1'b0; 
    rmii_tx_clk           = 1'b0;
    rmii_rx_clk           = 1'b0;
    gmii_rmii_tx_clk      = 1'b0; 
    gmii_rmii_rx_clk      = 1'b0; 
    xfbi_rx_clk           = 1'b0; 
    xfbi_tx_clk           = 1'b0; 
    xsbi_tx_clk           = 1'b0; 
    xsbi_rx_clk           = 1'b0; 
    gmii_mdc              = 1'b0; 
    serial_tx_baser_clk   = 1'b0; 
    serial_rx_baser_clk   = 1'b0;
    serial_tx_basex_clk   = 1'b0; 
    serial_rx_basex_clk   = 1'b0;
    serial_tx_base4x_clk  = 1'b0; 
    serial_rx_base4x_clk  = 1'b0; 
    vsbi_rx_clk           = 1'b0; 
    vsbi_tx_clk           = 1'b0; 
    cgmii_tx_clk          = 1'b0; 
    cgmii_rx_clk          = 1'b0; 
    caui_64b_clk          = 1'b0;
    mdio_clk              = 1'b0;
    qsgmii_sync_status    = 1'b0;
    qsgmii_sync_status_tx = 1'b0;
    qsgmii_sync_status_rx = 1'b0;
    lgmii_tx_clk          = 1'b0;
    lgmii_rx_clk          = 1'b0;
    xxvgmii_tx_clk        = 1'b0;
    xxvgmii_rx_clk        = 1'b0;
    lsbi_tx_clk           = 1'b0; 
    lsbi_rx_clk           = 1'b0; 
    xxvsbi_tx_clk         = 1'b0; 
    xxvsbi_rx_clk         = 1'b0;
    serial_12pt5g_clk_tx  = 1'b0;
    serial_12pt5g_clk_rx  = 1'b0;
    serial_cd_tx_clk  = 1'b0;
    serial_cd_rx_clk  = 1'b0;
    ccmii_tx_clk          = 1'b0;
    ccmii_rx_clk          = 1'b0;
    cdxbi_tx_clk          = 1'b0;
    cdxbi_rx_clk          = 1'b0;
    serial_50g_tx_clk     = 1'b0;
    serial_50g_rx_clk     = 1'b0;    
    serial_caui_25g_clk_tx_pos_ppm = 1'b0;
    serial_caui_25g_clk_rx_pos_ppm = 1'b0;
    serial_caui_25g_clk_tx_neg_ppm = 1'b0;
    serial_caui_25g_clk_rx_neg_ppm = 1'b0;
    serial_cd_tx_clk_pos_ppm = 1'b0;
    serial_cd_rx_clk_pos_ppm =1'b0;
    serial_cd_tx_clk_neg_ppm = 1'b0;
    serial_cd_rx_clk_neg_ppm =1'b0;

    #1;
end
generate
   for (j=0; j<NUM_PHY; j++) begin
    assign numerator[j] = (ts_tasks_if[j].speed==_10G) ?  6400.02 : ((ts_tasks_if[j].speed==_25G) ? 6400.02 : ((ts_tasks_if[j].speed==_40G) ? 6399.888 : ((ts_tasks_if[j].speed==_50G) ? 6400.02 : ((ts_tasks_if[j].speed==_100G) ? 6400.68 : ((ts_tasks_if[j].speed==_200G) ? 6399.36 : ((ts_tasks_if[j].speed==_400G) ? 6399.36 : (0)))))));
    
    assign freq_ratio[j] = (ts_tasks_if[j].speed==_10G) ?  1 : ((ts_tasks_if[j].speed==_25G) ? 2.5 : ((ts_tasks_if[j].speed==_40G) ? 4 : ((ts_tasks_if[j].speed==_50G) ? 5: ((ts_tasks_if[j].speed==_100G) ? 10 : ((ts_tasks_if[j].speed==_200G) ? 20 : ((ts_tasks_if[j].speed==_400G) ? 40 : (0)))))));
   end
endgenerate

  /** Clock Generation. */
  always #`SVT_ETHERNET_PCS66_50GX2_XGMIICLK              xgmii66_50gx2_clk       = ~xgmii66_50gx2_clk;
  always #`SVT_ETHERNET_PCS66_50GX2_XSBICLK               xsbi66_50gx2_clk        = ~xsbi66_50gx2_clk;
  always #`SVT_ETHERNET_PCS66_50GX2_SERIAL_BASER_CLK      serial_baser_50gx2_clk  = ~serial_baser_50gx2_clk;
  always #`SVT_ETHERNET_XLGMII_CLOCK                      xlgmii_tx_clk        = ~xlgmii_tx_clk        ;
  always #`SVT_ETHERNET_XLGMII_CLOCK                      xlgmii_rx_clk        = ~xlgmii_rx_clk        ;
  always #`SVT_ETHERNET_XGMII_CLOCK                       xgmii_tx_clk         = ~xgmii_tx_clk         ; 
  always #`SVT_ETHERNET_XGMII_CLOCK                       xgmii_rx_clk         = ~xgmii_rx_clk         ;
  always #`SVT_ETHERNET_PTP_SYS_CLOCK 	                  ptp_system_clk        = ~ptp_system_clk       ; 
  always #`SVT_ETHERNET_XXGMII_CLOCK                      xxgmii_tx_clk        = ~xxgmii_tx_clk        ;
  always #`SVT_ETHERNET_XXGMII_CLOCK                      xxgmii_rx_clk        = ~xxgmii_rx_clk        ;
  always #`SVT_ETHERNET_FBI_CLOCK                         xfbi_tx_clk          = ~xfbi_tx_clk          ;
  always #`SVT_ETHERNET_FBI_CLOCK                         xfbi_rx_clk          = ~xfbi_rx_clk          ;
  always #`SVT_ETHERNET_XSBI_CLOCK                        xsbi_tx_clk          = ~xsbi_tx_clk          ;
  always #`SVT_ETHERNET_XSBI_CLOCK                        xsbi_rx_clk          = ~xsbi_rx_clk          ;
  always #`SVT_ETHERNET_GMII_CLOCK                        gmii_tx_clk          = ~gmii_tx_clk          ;
  always #`SVT_ETHERNET_GMII_CLOCK                        gmii_rx_clk          = ~gmii_rx_clk          ;
  always #`SVT_ETHERNET_GMII_CLOCK                        rgmii_tx_clk         = ~rgmii_tx_clk         ;
  always #`SVT_ETHERNET_GMII_CLOCK                        rgmii_rx_clk         = ~rgmii_rx_clk         ;
  always #`SVT_ETHERNET_25MHZ_CLOCK                       mii_100M_tx_clk      = ~mii_100M_tx_clk      ;
  always #`SVT_ETHERNET_25MHZ_CLOCK                       mii_100M_rx_clk      = ~mii_100M_rx_clk      ;
  always #`SVT_ETHERNET_2PT5_MHZ_CLOCK                    mii_10M_tx_clk       = ~mii_10M_tx_clk       ;
  always #`SVT_ETHERNET_2PT5_MHZ_CLOCK                    mii_10M_rx_clk       = ~mii_10M_rx_clk       ;
  always #`SVT_ETHERNET_TBI_CLOCK                         tbi_tx_clk           = ~tbi_tx_clk           ;
  always #`SVT_ETHERNET_TBI_CLOCK                         tbi_rx_clk           = ~tbi_rx_clk           ;
  always #`SVT_ETHERNET_REFERENCE_CLOCK                   reference_clk        = ~reference_clk        ;
  always #`SVT_ETHERNET_SERIAL_BASER_CLOCK                serial_tx_baser_clk  = ~serial_tx_baser_clk  ;
  always #`SVT_ETHERNET_SERIAL_BASER_CLOCK                serial_rx_baser_clk  = ~serial_rx_baser_clk  ; 
  always #`SVT_ETHERNET_SERIAL_BASE4X_CLOCK               serial_tx_base4x_clk = ~serial_tx_base4x_clk ;
  always #`SVT_ETHERNET_SERIAL_BASE4X_CLOCK               serial_rx_base4x_clk = ~serial_rx_base4x_clk ; 
  always #`SVT_ETHERNET_SERIAL_BASEX_CLOCK                serial_tx_basex_clk  = ~serial_tx_basex_clk  ;
  always #`SVT_ETHERNET_SERIAL_BASEX_CLOCK                serial_rx_basex_clk  = ~serial_rx_basex_clk  ; 
  always #`SVT_ETHERNET_RMII_CLOCK                        rmii_tx_clk          = ~rmii_tx_clk          ;
  always #`SVT_ETHERNET_RMII_CLOCK                        rmii_rx_clk          = ~rmii_rx_clk          ;
  always #`SVT_ETHERNET_GMII_RMII_CLOCK                   gmii_rmii_rx_clk     = ~gmii_rmii_rx_clk     ;
  always #`SVT_ETHERNET_GMII_RMII_CLOCK                   gmii_rmii_tx_clk     = ~gmii_rmii_tx_clk     ;
  always #`SVT_ETHERNET_VSBI_CLOCK                        vsbi_tx_clk          = ~vsbi_tx_clk          ;
  always #`SVT_ETHERNET_VSBI_CLOCK                        vsbi_rx_clk          = ~vsbi_rx_clk          ;
  always #`SVT_ETHERNET_CGMII_CLOCK                       cgmii_tx_clk         = ~cgmii_tx_clk         ;
  always #`SVT_ETHERNET_CGMII_CLOCK                       cgmii_rx_clk         = ~cgmii_rx_clk         ;
  always #`SVT_ETHERNET_MDIO_CLOCK                        mdio_clk             = ~mdio_clk             ;
  always #`SVT_ETHERNET_CAUI_64B_PARALLEL_CLOCK           caui_64b_clk         = !(caui_64b_clk)       ;
  always #`SVT_ETHERNET_GMII_CLOCK                        smii_tx_clk          = ~smii_tx_clk          ;
  always #`SVT_ETHERNET_GMII_CLOCK                        smii_rx_clk          = ~smii_rx_clk          ;
  always #`SVT_ETHERNET_KR4_FEC_66_CLOCK                  clk_66t_tx           = ~clk_66t_tx           ;
  always #`SVT_ETHERNET_KR4_FEC_40_CLOCK                  clk_40t_tx           = ~clk_40t_tx           ;
  always #`SVT_ETHERNET_KR4_FEC_66_CLOCK                  clk_66t_rx           = ~clk_66t_rx           ;
  always #`SVT_ETHERNET_KR4_FEC_40_CLOCK                  clk_40t_rx           = ~clk_40t_rx           ;
  always #`SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK             serial_caui_25g_clk_tx = ~serial_caui_25g_clk_tx;
  always #`SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK             serial_caui_25g_clk_rx = ~serial_caui_25g_clk_rx;
  always #`SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK_POS_PPM     serial_caui_25g_clk_tx_pos_ppm = ~serial_caui_25g_clk_tx_pos_ppm;
  always #`SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK_POS_PPM     serial_caui_25g_clk_rx_pos_ppm = ~serial_caui_25g_clk_rx_pos_ppm;
  always #`SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK_NEG_PPM     serial_caui_25g_clk_tx_neg_ppm = ~serial_caui_25g_clk_tx_neg_ppm;
  always #`SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK_NEG_PPM     serial_caui_25g_clk_rx_neg_ppm = ~serial_caui_25g_clk_rx_neg_ppm;

  always #`SVT_ETHERNET_KR4_FEC_64_CLOCK                  caui_64b_clk_tx      = !(caui_64b_clk_tx)    ;
  always #`SVT_ETHERNET_KR4_FEC_64_CLOCK                  caui_64b_clk_rx      = !(caui_64b_clk_rx)    ;
  always #`SVT_ETHERNET_XXVGMII_CLOCK                    xxvgmii_tx_clk        = ~xxvgmii_tx_clk;
  always #`SVT_ETHERNET_XXVGMII_CLOCK                    xxvgmii_rx_clk        = ~xxvgmii_rx_clk;
  always #`SVT_ETHERNET_LGMII_CLOCK                    lgmii_tx_clk            = ~lgmii_tx_clk;
  always #`SVT_ETHERNET_LGMII_CLOCK                    lgmii_rx_clk            = ~lgmii_rx_clk;
  always #`SVT_ETHERNET_XXVSBI_CLOCK                      xxvsbi_tx_clk        = ~xxvsbi_tx_clk;
  always #`SVT_ETHERNET_XXVSBI_CLOCK                      xxvsbi_rx_clk        = ~xxvsbi_rx_clk;
  always #`SVT_ETHERNET_LSBI_CLOCK                        lsbi_tx_clk          = ~lsbi_tx_clk;
  always #`SVT_ETHERNET_LSBI_CLOCK                        lsbi_rx_clk          = ~lsbi_rx_clk;
  always #`SVT_ETHERNET_SERIAL_12pt5G_CLOCK               serial_12pt5g_clk_tx = ~serial_12pt5g_clk_tx;
  always #`SVT_ETHERNET_SERIAL_12pt5G_CLOCK               serial_12pt5g_clk_rx = ~serial_12pt5g_clk_rx;
  always begin
  #`SVT_ETHERNET_CD_CLK0               serial_cd_tx_clk = ~serial_cd_tx_clk;
  #`SVT_ETHERNET_CD_CLK1               serial_cd_tx_clk = ~serial_cd_tx_clk;
 


  end

always begin
  #`SVT_ETHERNET_CD_CLK0_POS_PPM       serial_cd_tx_clk_pos_ppm = ~ serial_cd_tx_clk_pos_ppm;
  #`SVT_ETHERNET_CD_CLK1_POS_PPM       serial_cd_tx_clk_pos_ppm = ~ serial_cd_tx_clk_pos_ppm;
end

always begin
  #`SVT_ETHERNET_CD_CLK0_POS_PPM       serial_cd_rx_clk_pos_ppm = ~ serial_cd_rx_clk_pos_ppm;
  #`SVT_ETHERNET_CD_CLK1_POS_PPM       serial_cd_rx_clk_pos_ppm = ~ serial_cd_rx_clk_pos_ppm;
end

always #`SVT_ETHERNET_CD_CLK_NEG_PPM serial_cd_tx_clk_neg_ppm = ~serial_cd_tx_clk_neg_ppm;
always #`SVT_ETHERNET_CD_CLK_NEG_PPM serial_cd_rx_clk_neg_ppm = ~serial_cd_rx_clk_neg_ppm;

  always begin
  #`SVT_ETHERNET_CD_CLK0               serial_cd_rx_clk = ~serial_cd_rx_clk;
  #`SVT_ETHERNET_CD_CLK1               serial_cd_rx_clk = ~serial_cd_rx_clk;
  end
  always #`SVT_ETHERNET_CCMII_CLK                          ccmii_tx_clk = ~ccmii_tx_clk;
  always #`SVT_ETHERNET_CCMII_CLK                          ccmii_rx_clk = ~ccmii_rx_clk;
  always #`SVT_ETHERNET_CDXBI_CLK                          cdxbi_tx_clk = ~cdxbi_tx_clk;
  always #`SVT_ETHERNET_CDXBI_CLK                          cdxbi_rx_clk = ~cdxbi_rx_clk;  
  always #`SVT_ETHERNET_SERIAL_50G_CLK                     serial_50g_tx_clk = ~serial_50g_tx_clk;
  always #`SVT_ETHERNET_SERIAL_50G_CLK                     serial_50g_rx_clk = ~serial_50g_rx_clk;    

generate 
   for (z=0; z<NUM_PHY; z++) begin
    always #`PCS66_XGMII_FREQ(numerator[z],freq_ratio[z])        xgmii66_clk[z]             = ~xgmii66_clk[z];
    always #`PCS66_XSBI_FREQ(freq_ratio[z])         xsbi66_clk[z]              = ~xsbi66_clk[z];
    always #`PCS66_BASER_FREQ(freq_ratio[z])        serial_baser_clk[z]        = ~serial_baser_clk[z];
   end
endgenerate 

`include "vip_otn_flexe.sv"

generate
for (i=0;i<NUM_PHY;i++) begin : SVT_ASSGN_INST
  assign  svt_ethernet_txrx_if[i].cgmii_tx_clk          =  cgmii_tx_clk ;
  assign  svt_ethernet_txrx_if[i].xgmii_tx_clk          =  xgmii_tx_clk         ; 
  assign  svt_ethernet_txrx_if[i].vsbi_rx_clk           =  vsbi_rx_clk          ;
  assign  svt_ethernet_txrx_if[i].rmii_tx_clk           =  rmii_tx_clk          ;
  assign  svt_ethernet_txrx_if[i].xlgmii_tx_clk         =  xlgmii_tx_clk        ;
  assign  svt_ethernet_txrx_if[i].serial_rx_basex_clk   =  serial_rx_basex_clk  ; 
  assign  svt_ethernet_txrx_if[i].gmii_tx_clk           =  gmii_tx_clk          ;
  assign  svt_ethernet_txrx_if[i].reference_clk         =  reference_clk        ;
  assign  svt_ethernet_txrx_if[i].xgmii_rx_clk          =  xgmii_rx_clk         ;
  assign  svt_ethernet_txrx_if[i].cgmii_rx_clk          =  cgmii_rx_clk         ;
  assign  svt_ethernet_txrx_if[i].vsbi_tx_clk           =  vsbi_tx_clk          ;
  assign  svt_ethernet_txrx_if[i].xsbi_rx_clk           =  xsbi_rx_clk          ;
  assign  svt_ethernet_txrx_if[i].xsbi_tx_clk           =  xsbi_tx_clk          ;
  assign  svt_ethernet_txrx_if[i].serial_tx_basex_clk   =  serial_tx_basex_clk  ;
  assign  svt_ethernet_txrx_if[i].xlgmii_rx_clk         =  xlgmii_rx_clk        ;
  assign  svt_ethernet_txrx_if[i].gmii_rx_clk           =  gmii_rx_clk          ;
  assign  svt_ethernet_txrx_if[i].rgmii_tx_clk          =  rgmii_tx_clk         ;
  assign  svt_ethernet_txrx_if[i].rgmii_rx_clk          =  rgmii_rx_clk         ;
  assign  svt_ethernet_txrx_if[i].mii_100M_tx_clk       =  mii_100M_tx_clk      ;
  assign  svt_ethernet_txrx_if[i].mii_100M_rx_clk       =  mii_100M_rx_clk      ;
  assign  svt_ethernet_txrx_if[i].mii_10M_tx_clk        =  mii_10M_tx_clk       ;
  assign  svt_ethernet_txrx_if[i].mii_10M_rx_clk        =  mii_10M_rx_clk       ;
  assign  svt_ethernet_txrx_if[i].serial_rx_baser_clk   =  serial_rx_baser_clk  ; 
  assign  svt_ethernet_txrx_if[i].gmii_rmii_tx_clk      =  gmii_rmii_tx_clk     ;
  assign  svt_ethernet_txrx_if[i].serial_tx_base4x_clk  =  serial_tx_base4x_clk ;
  assign  svt_ethernet_txrx_if[i].mdio_clk              =  mdio_clk             ;
  assign  svt_ethernet_txrx_if[i].rmii_rx_clk           =  rmii_rx_clk          ;
  assign  svt_ethernet_txrx_if[i].serial_rx_base4x_clk  =  serial_rx_base4x_clk ; 
  assign  svt_ethernet_txrx_if[i].serial_tx_baser_clk   =  serial_tx_baser_clk  ;
  assign  svt_ethernet_txrx_if[i].xfbi_tx_clk           =  xfbi_tx_clk          ;
  assign  svt_ethernet_txrx_if[i].gmii_rmii_rx_clk      =  gmii_rmii_rx_clk     ;
  assign  svt_ethernet_txrx_if[i].xfbi_rx_clk           =  xfbi_rx_clk          ;
  assign  svt_ethernet_txrx_if[i].smii_tx_clk            = smii_tx_clk          ;
  assign  svt_ethernet_txrx_if[i].smii_rx_clk            = smii_rx_clk          ;
  assign  svt_ethernet_txrx_if[i].clk_66t_rx             = clk_66t_rx            ; 
  assign  svt_ethernet_txrx_if[i].clk_66t_tx             = clk_66t_tx            ; 
  assign  svt_ethernet_txrx_if[i].clk_40t_rx             = clk_40t_rx            ;
  assign  svt_ethernet_txrx_if[i].clk_40t_tx             = clk_40t_tx            ;
 // assign  svt_ethernet_txrx_if[i].serial_caui_25g_clk_tx = serial_caui_25g_clk_tx;
//  assign  svt_ethernet_txrx_if[i].serial_caui_25g_clk_rx = serial_caui_25g_clk_rx;
  assign  svt_ethernet_txrx_if[i].serial_caui_25g_clk_tx = ($test$plusargs("POS_PPM")) ? serial_caui_25g_clk_tx_pos_ppm : ($test$plusargs("NEG_PPM")) ? serial_caui_25g_clk_tx_neg_ppm: serial_caui_25g_clk_tx;
  assign  svt_ethernet_txrx_if[i].serial_caui_25g_clk_rx = ($test$plusargs("POS_PPM")) ? serial_caui_25g_clk_rx_pos_ppm : ($test$plusargs("NEG_PPM")) ? serial_caui_25g_clk_rx_neg_ppm:  serial_caui_25g_clk_rx;

assign svt_ethernet_txrx_if[i].serial_cd_tx_clk = ($test$plusargs("POS_PPM_50G")) ? serial_cd_tx_clk_pos_ppm: ($test$plusargs("NEG_PPM_50G")) ? serial_cd_tx_clk_neg_ppm: serial_cd_tx_clk;
assign svt_ethernet_txrx_if[i].serial_cd_rx_clk = ($test$plusargs("POS_PPM_50G")) ? serial_cd_rx_clk_pos_ppm: ($test$plusargs("NEG_PPM_50G")) ? serial_cd_rx_clk_neg_ppm:  serial_cd_rx_clk;

  assign  svt_ethernet_txrx_if[i].caui_64b_clk_rx        = caui_64b_clk_rx       ;
  assign  svt_ethernet_txrx_if[i].caui_64b_clk_tx        = caui_64b_clk_tx       ;
  assign  svt_ethernet_txrx_if[i].xxvsbi_tx_clk         =  xxvsbi_tx_clk        ;
  assign  svt_ethernet_txrx_if[i].xxvsbi_rx_clk         =  xxvsbi_rx_clk        ;
  assign  svt_ethernet_txrx_if[i].lsbi_tx_clk           =  lsbi_tx_clk          ;
  assign  svt_ethernet_txrx_if[i].lsbi_rx_clk           =  lsbi_rx_clk          ;
  assign  svt_ethernet_txrx_if[i].xxvgmii_tx_clk        =  xxvgmii_tx_clk       ;
  assign  svt_ethernet_txrx_if[i].xxvgmii_rx_clk        =  xxvgmii_rx_clk       ;
  assign  svt_ethernet_txrx_if[i].lgmii_tx_clk          =  lgmii_tx_clk         ;
  assign  svt_ethernet_txrx_if[i].lgmii_rx_clk          =  lgmii_rx_clk         ;  
  assign  svt_ethernet_txrx_if[i].serial_12pt5g_clk_tx  = serial_12pt5g_clk_tx  ;
  assign  svt_ethernet_txrx_if[i].serial_12pt5g_clk_rx  = serial_12pt5g_clk_rx  ;
  //assign  svt_ethernet_txrx_if[i].serial_cd_tx_clk      = serial_cd_tx_clk  ;
  //assign  svt_ethernet_txrx_if[i].serial_cd_rx_clk      = serial_cd_rx_clk  ;
  assign  svt_ethernet_txrx_if[i].ccmii_tx_clk          = ccmii_tx_clk;
  assign  svt_ethernet_txrx_if[i].ccmii_rx_clk          = ccmii_rx_clk;
  assign  svt_ethernet_txrx_if[i].cdxbi_tx_clk          = cdxbi_tx_clk;
  assign  svt_ethernet_txrx_if[i].cdxbi_rx_clk          = cdxbi_rx_clk;
  assign  svt_ethernet_txrx_if[i].serial_50g_tx_clk     = serial_50g_tx_clk;
  assign  svt_ethernet_txrx_if[i].serial_50g_rx_clk     = serial_50g_rx_clk;
end
endgenerate
      

