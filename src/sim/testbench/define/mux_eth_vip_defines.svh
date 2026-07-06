//====================================================== 
// This file has all the Synopsys ETHERNET VIP defines 
//====================================================== 

`define SVT_ETHERNET_SERIAL_BASER_CLOCK                 (96.97/2.0) 
`define SVT_ETHERNET_SERIAL_BASE4X_CLOCK                160
`define SVT_ETHERNET_SERIAL_BASEX_CLOCK                 400
`define SVT_ETHERNET_GMII_CLOCK                         4000
`define SVT_ETHERNET_25MHZ_CLOCK                        20000

`ifdef ETH_VTC_MII_FASTER_CLK
   `define SVT_ETHERNET_RMII_CLOCK                       1000
   `define SVT_ETHERNET_2PT5_MHZ_CLOCK                   20000
`else
   `define SVT_ETHERNET_RMII_CLOCK                       10000
   `define SVT_ETHERNET_2PT5_MHZ_CLOCK                   200000
`endif

`define SVT_ETHERNET_SGMII_CLOCK                        80
`define SVT_ETHERNET_QSGMII_CLOCK                       100
`define SVT_ETHERNET_TBI_CLOCK                          4000
`define SVT_ETHERNET_XLGMII_CLOCK                       800
`define SVT_ETHERNET_XXGMII_CLOCK                       1600
`define SVT_ETHERNET_CGMII_CLOCK                        320
`define SVT_ETHERNET_CGMII_MIMIC_DUT_CLOCK              160
`define SVT_ETHERNET_XLGMII_MIMIC_DUT_CLOCK             400
`define SVT_ETHERNET_XGMII_CLOCK                        3200
`define SVT_ETHERNET_FBI_CLOCK                          1600
`define SVT_ETHERNET_RXAUI_CLOCK                        800
`define SVT_ETHERNET_SERIAL_RXAUI_CLOCK                 80
`define SVT_ETHERNET_SERIAL_CLOCK_BASEX                 40
`define SVT_ETHERNET_XSBI_CLOCK                         (1551.52/2.0)
`define SVT_ETHERNET_VSBI_CLOCK                         1551.52
`define SVT_ETHERNET_VSBI_CLOCK_CAUI_25x4_64B_PARALLEL  (3103.03/2.0)
`define SVT_ETHERNET_CAUI_64B_PARALLEL_CLOCK            (2482.424/2)   
`define SVT_ETHERNET_REFERENCE_CLOCK                    50 
`define SVT_ETHERNET_ROUND_TRIP_TIME                    4000
`define SVT_ETHERNET_GMII_RMII_CLOCK                    40000
`define SVT_ETHERNET_MDIO_CLOCK                         200
`define SVT_ETHERNET_PTP_SYS_CLOCK                      500000
`define SVT_ETHERNET_KR4_FEC_40_CLOCK                   (38.788*40/2)
`define SVT_ETHERNET_KR4_FEC_66_CLOCK                   (38.788*66/2)
`define SVT_ETHERNET_KR4_FEC_64_CLOCK                   (38.788*64/2)
`define SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK              (38.788/2)
`define SVT_ETHERNET_XXVGMII_CLOCK                      1280
`define SVT_ETHERNET_LGMII_CLOCK                        640
`define SVT_ETHERNET_XXVSBI_CLOCK                       (620.608/2)
`define SVT_ETHERNET_LSBI_CLOCK                         (620.608)
`define SVT_ETHERNET_SERIAL_12pt5G_CLOCK                (38.788)
`define SVT_ETHERNET_CDMII_CLOCK                        (80)
`define SVT_ETHERNET_DCCCMII_CLOCK                      (40)
`define SVT_ETHERNET_CCMII_CLOCK                        (160)
`define SVT_ETHERNET_CDXBI_CLOCK                        (376.48/2)
`define SVT_ETHERNET_SERIAL_CD_CLOCK                    (37.648/2)
`define SVT_ETHERNET_SERIAL_BASET1_CLOCK                (1333.33/2)
`define SVT_ETHERNET_SERIAL_100BASET1_CLOCK             (15000/2)
`define SVT_ETHERNET_SERIAL_50G_CLOCK                   (37.648/4)
`define SVT_ETHERNET_SERIAL_100G_CLOCK                  (37.648/8)
`define SVT_ETHERNET_SERIAL_50G_SINGLE_LANE_CLOCK       (38.788/4)


