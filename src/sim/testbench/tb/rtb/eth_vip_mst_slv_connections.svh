`ifdef FM7_FC

svt_ethernet_txrx_if vip_mst_ethernet_if(reference_clk);
svt_ethernet_xxm_bfm_driver ethernet_mac_txrx(vip_mst_ethernet_if);
svt_ethernet_xxm_mon_chk_driver ethernet_mac_mon(vip_mst_ethernet_if);

initial begin
  uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(), "uvm_test_top.m_env.m_vip_ethernet_mac_mst*", "if_port", vip_mst_ethernet_if);
end
`endif

`ifdef MUX_DEBUG
 /** Signal to generate the clock */
  bit reference_clk                  ;
  bit gmii_rx_clk                    ; 
  bit gmii_tx_clk                    ; 
  bit rgmii_rx_clk                   ; 
  bit rgmii_tx_clk                   ; 
  bit mii_100M_tx_clk                ;
  bit mii_100M_rx_clk                ;
  bit mii_10M_tx_clk                 ;
  bit mii_10M_rx_clk                 ;
  bit xgmii_tx_clk                   ; 
  bit xgmii_rx_clk                   ;
  bit ptp_system_clk                 ;
  bit xlgmii_tx_clk                  ; 
  bit xlgmii_rx_clk                  ;
  bit xxgmii_tx_clk                  ;
  bit xxgmii_rx_clk                  ;
  bit tbi_tx_clk                     ; 
  bit tbi_rx_clk                     ; 
  bit rmii_tx_clk                    ;
  bit rmii_rx_clk                    ;
  bit gmii_rmii_tx_clk               ; 
  bit gmii_rmii_rx_clk               ; 
  bit xfbi_rx_clk                    ; 
  bit xfbi_tx_clk                    ; 
  bit rxaui_tx_clk                   ;
  bit rxaui_rx_clk                   ;
  bit serial_rxaui_tx_clk            ;
  bit serial_rxaui_rx_clk            ;
  bit xsbi_tx_clk                    ; 
  bit xsbi_rx_clk                    ; 
  bit gmii_mdc                       ; 
  bit serial_tx_baser_clk            ; 
  bit serial_rx_baser_clk            ;
  bit serial_tx_basex_clk            ; 
  bit serial_rx_basex_clk            ;
  bit serial_tx_base4x_clk           ; 
  bit serial_rx_base4x_clk           ; 
  bit vsbi_rx_clk                    ; 
  bit vsbi_tx_clk                    ; 
  bit cgmii_tx_clk                   ; 
  bit cgmii_rx_clk                   ; 
  bit caui_64b_clk                   ;
  bit mdio_clk                       ;
  bit qsgmii_sync_status             ;
  bit qsgmii_sync_status_tx          ;
  bit qsgmii_sync_status_rx          ;
  bit smii_tx_clk                    ;
  bit smii_rx_clk                    ;
  bit clk_66t_tx                     ; 
  bit clk_40t_tx                     ;
  bit clk_66t_rx                     ; 
  bit clk_40t_rx                     ;
  bit serial_caui_25g_clk_tx         ;
  bit serial_caui_25g_clk_rx         ;
  bit caui_64b_clk_tx                ;
  bit caui_64b_clk_rx                ;
  bit xxvgmii_tx_clk                 ;
  bit xxvgmii_rx_clk                 ;
  bit lgmii_tx_clk                   ;
  bit lgmii_rx_clk                   ;
  bit lsbi_tx_clk                    ;
  bit lsbi_rx_clk                    ;
  bit xxvsbi_tx_clk                  ;
  bit xxvsbi_rx_clk                  ;
  bit serial_12pt5g_clk_tx           ;
  bit serial_12pt5g_clk_rx           ;
  bit cdmii_tx_clk                   ;
  bit cdmii_rx_clk                   ;
  bit dcccmii_tx_clk                 ;
  bit dcccmii_rx_clk                 ;
  bit ccmii_tx_clk                   ;
  bit ccmii_rx_clk                   ;
  bit cdxbi_tx_clk                   ;
  bit cdxbi_rx_clk                   ;
  bit serial_cd_tx_clk               ;
  bit serial_cd_rx_clk               ;
  bit serial_baset1_tx_clk           ;
  bit serial_baset1_rx_clk           ;
  bit serial_100baset1_tx_clk        ;
  bit serial_100baset1_rx_clk        ;
  bit serial_50g_tx_clk              ;
  bit serial_50g_rx_clk              ;
  bit serial_50g_single_lane_tx_clk  ;
  bit serial_50g_single_lane_rx_clk  ;
  bit serial_100g_tx_clk             ;
  bit serial_100g_rx_clk             ;

  /** Signal used to provide the reset */
  bit reset;

  genvar idx;
  generate
  for(idx=0; idx < `MAX_AXI_PORT; idx++) begin
    svt_ethernet_txrx_if vip_mst_ethernet_if[idx](reference_clk);
    svt_ethernet_xxm_bfm_driver ethernet_mac_txrx(vip_mst_ethernet_if[idx]);
    svt_ethernet_xxm_mon_chk_driver ethernet_mac_mon(vip_mst_ethernet_if[idx]);

    svt_ethernet_txrx_if vip_slv_ethernet_if[idx](reference_clk);
    svt_ethernet_xxm_bfm_driver ethernet_phy_txrx(vip_slv_ethernet_if[idx]);
    svt_ethernet_xxm_mon_chk_driver ethernet_phy_mon(vip_slv_ethernet_if[idx]);

    /***********************************************************************************************************************************************/
    /************************ Assigning Reset and Tying Virtual Interface with Physical Reset ******************************************************/
    assign vip_mst_ethernet_if[idx].reset = reset;
    assign vip_slv_ethernet_if[idx].reset = reset;

    /********************* Performing the Criss Cross Connection between MAC VIP Tx lane- PHY VIP RX lane and vice versa ***********************/
    /** Connecting the tx_lane of MAC Interface with rx_lane of PHY interface and vice versa */
    assign vip_mst_ethernet_if[idx].rx_lane  = vip_slv_ethernet_if[idx].tx_lane;
    assign vip_slv_ethernet_if[idx].rx_lane  = vip_mst_ethernet_if[idx].tx_lane;
    
    assign vip_mst_ethernet_if[idx].mdio_din = vip_slv_ethernet_if[idx].mdio_dout;
    assign vip_slv_ethernet_if[idx].mdio_din = vip_mst_ethernet_if[idx].mdio_dout;
    
    /** Unique stream id for MAC and PHY interfaces */ 
    assign vip_mst_ethernet_if[idx].stream_id = 0;
    assign vip_slv_ethernet_if[idx].stream_id = 1 ;
    
    assign vip_slv_ethernet_if[idx].mdio_outputenable = 0;
    assign vip_mst_ethernet_if[idx].mdio_outputenable = 0;
   /*****************************************************************************************************************************************/

     assign  vip_mst_ethernet_if[idx].cgmii_tx_clk           =  cgmii_tx_clk         ;
     assign  vip_mst_ethernet_if[idx].xgmii_tx_clk           =  xgmii_tx_clk         ; 
     assign  vip_mst_ethernet_if[idx].xxgmii_tx_clk          =  xxgmii_tx_clk        ; 
     assign  vip_mst_ethernet_if[idx].xxgmii_rx_clk          =  xxgmii_rx_clk        ; 
     assign  vip_mst_ethernet_if[idx].vsbi_rx_clk            =  vsbi_rx_clk          ;
     assign  vip_mst_ethernet_if[idx].rmii_tx_clk            =  rmii_tx_clk          ;
     assign  vip_mst_ethernet_if[idx].xlgmii_tx_clk          =  xlgmii_tx_clk        ;
     assign  vip_mst_ethernet_if[idx].serial_rx_basex_clk    =  serial_rx_basex_clk  ; 
     assign  vip_mst_ethernet_if[idx].gmii_tx_clk            =  gmii_tx_clk          ;
     assign  vip_mst_ethernet_if[idx].reference_clk          =  reference_clk        ;
     assign  vip_mst_ethernet_if[idx].xgmii_rx_clk           =  xgmii_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].cgmii_rx_clk           =  cgmii_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].vsbi_tx_clk            =  vsbi_tx_clk          ;
     assign  vip_mst_ethernet_if[idx].xsbi_rx_clk            =  xsbi_rx_clk          ;
     assign  vip_mst_ethernet_if[idx].xsbi_tx_clk            =  xsbi_tx_clk          ;
     assign  vip_mst_ethernet_if[idx].serial_tx_basex_clk    =  serial_tx_basex_clk  ;
     assign  vip_mst_ethernet_if[idx].xlgmii_rx_clk          =  xlgmii_rx_clk        ;
     assign  vip_mst_ethernet_if[idx].gmii_rx_clk            =  gmii_rx_clk          ;
     assign  vip_mst_ethernet_if[idx].rgmii_tx_clk           =  rgmii_tx_clk         ;
     assign  vip_mst_ethernet_if[idx].rgmii_rx_clk           =  rgmii_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].mii_100M_tx_clk        =  mii_100M_tx_clk      ;
     assign  vip_mst_ethernet_if[idx].mii_100M_rx_clk        =  mii_100M_rx_clk      ;
     assign  vip_mst_ethernet_if[idx].mii_10M_tx_clk         =  mii_10M_tx_clk       ;
     assign  vip_mst_ethernet_if[idx].mii_10M_rx_clk         =  mii_10M_rx_clk       ;
     assign  vip_mst_ethernet_if[idx].serial_rx_baser_clk    =  serial_rx_baser_clk  ; 
     assign  vip_mst_ethernet_if[idx].gmii_rmii_tx_clk       =  gmii_rmii_tx_clk     ;
     assign  vip_mst_ethernet_if[idx].serial_tx_base4x_clk   =  serial_tx_base4x_clk ;
     assign  vip_mst_ethernet_if[idx].mdio_clk               =  mdio_clk             ;
     assign  vip_mst_ethernet_if[idx].rmii_rx_clk            =  rmii_rx_clk          ;
     assign  vip_mst_ethernet_if[idx].serial_rx_base4x_clk   =  serial_rx_base4x_clk ; 
     assign  vip_mst_ethernet_if[idx].serial_tx_baser_clk    =  serial_tx_baser_clk  ;
     assign  vip_mst_ethernet_if[idx].xfbi_tx_clk            =  xfbi_tx_clk          ;
     assign  vip_mst_ethernet_if[idx].rxaui_tx_clk           =  rxaui_tx_clk         ;
     assign  vip_mst_ethernet_if[idx].rxaui_rx_clk           =  rxaui_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].serial_rxaui_tx_clk    =  serial_rxaui_tx_clk  ;
     assign  vip_mst_ethernet_if[idx].serial_rxaui_rx_clk    =  serial_rxaui_rx_clk  ;
     assign  vip_mst_ethernet_if[idx].gmii_rmii_rx_clk       =  gmii_rmii_rx_clk     ;
     assign  vip_mst_ethernet_if[idx].xfbi_rx_clk            =  xfbi_rx_clk          ;
     assign  vip_mst_ethernet_if[idx].smii_tx_clk            =  smii_tx_clk          ;
     assign  vip_mst_ethernet_if[idx].smii_rx_clk            =  smii_rx_clk          ;
     assign  vip_mst_ethernet_if[idx].clk_66t_rx             =  clk_66t_rx           ; 
     assign  vip_mst_ethernet_if[idx].clk_66t_tx             =  clk_66t_tx           ; 
     assign  vip_mst_ethernet_if[idx].clk_40t_rx             =  clk_40t_rx           ;
     assign  vip_mst_ethernet_if[idx].clk_40t_tx             =  clk_40t_tx           ;
     assign  vip_mst_ethernet_if[idx].serial_caui_25g_clk_tx =  serial_caui_25g_clk_tx;
     assign  vip_mst_ethernet_if[idx].serial_caui_25g_clk_rx =  serial_caui_25g_clk_rx;
     assign  vip_mst_ethernet_if[idx].caui_64b_clk_rx        =  caui_64b_clk_rx      ;
     assign  vip_mst_ethernet_if[idx].caui_64b_clk_tx        =  caui_64b_clk_tx      ;
     assign  vip_mst_ethernet_if[idx].xxvsbi_tx_clk         =   xxvsbi_tx_clk        ;
     assign  vip_mst_ethernet_if[idx].xxvsbi_rx_clk         =   xxvsbi_rx_clk        ;
     assign  vip_mst_ethernet_if[idx].lsbi_tx_clk           =   lsbi_tx_clk          ;
     assign  vip_mst_ethernet_if[idx].lsbi_rx_clk           =   lsbi_rx_clk          ;
     assign  vip_mst_ethernet_if[idx].xxvgmii_tx_clk        =   xxvgmii_tx_clk       ;
     assign  vip_mst_ethernet_if[idx].xxvgmii_rx_clk        =   xxvgmii_rx_clk       ;
     assign  vip_mst_ethernet_if[idx].lgmii_tx_clk          =   lgmii_tx_clk         ;
     assign  vip_mst_ethernet_if[idx].lgmii_rx_clk          =   lgmii_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].serial_12pt5g_clk_tx  =   serial_12pt5g_clk_tx ;
     assign  vip_mst_ethernet_if[idx].serial_12pt5g_clk_rx  =   serial_12pt5g_clk_rx ;
     assign  vip_mst_ethernet_if[idx].cdmii_tx_clk          =   cdmii_tx_clk         ;
     assign  vip_mst_ethernet_if[idx].cdmii_rx_clk          =   cdmii_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].dcccmii_tx_clk        =   dcccmii_tx_clk         ;
     assign  vip_mst_ethernet_if[idx].dcccmii_rx_clk        =   dcccmii_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].ccmii_tx_clk          =   ccmii_tx_clk         ;
     assign  vip_mst_ethernet_if[idx].ccmii_rx_clk          =   ccmii_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].serial_cd_rx_clk      =   serial_cd_rx_clk     ;
     assign  vip_mst_ethernet_if[idx].serial_cd_tx_clk      =   serial_cd_tx_clk     ;
     assign  vip_mst_ethernet_if[idx].serial_baset1_rx_clk  =   serial_baset1_rx_clk ;
     assign  vip_mst_ethernet_if[idx].serial_baset1_tx_clk  =   serial_baset1_tx_clk ;
     assign  vip_mst_ethernet_if[idx].serial_50g_rx_clk     =   serial_50g_rx_clk    ;
     assign  vip_mst_ethernet_if[idx].serial_50g_tx_clk     =   serial_50g_tx_clk    ;
     assign  vip_mst_ethernet_if[idx].serial_50g_single_lane_rx_clk  = serial_50g_single_lane_rx_clk;
     assign  vip_mst_ethernet_if[idx].serial_50g_single_lane_tx_clk  = serial_50g_single_lane_tx_clk;
     assign  vip_mst_ethernet_if[idx].serial_100g_rx_clk    =   serial_100g_rx_clk   ;
     assign  vip_mst_ethernet_if[idx].serial_100g_tx_clk    =   serial_100g_tx_clk   ;
     assign  vip_mst_ethernet_if[idx].cdxbi_tx_clk          =   cdxbi_tx_clk         ;
     assign  vip_mst_ethernet_if[idx].cdxbi_rx_clk          =   cdxbi_rx_clk         ;
     assign  vip_mst_ethernet_if[idx].serial_100baset1_rx_clk  = serial_100baset1_rx_clk;
     assign  vip_mst_ethernet_if[idx].serial_100baset1_tx_clk  = serial_100baset1_tx_clk;
  
     /** PHY VIP Interface Clocks for each VIP Instance */
     assign  vip_slv_ethernet_if[idx].cgmii_tx_clk           =  cgmii_tx_clk         ;
     assign  vip_slv_ethernet_if[idx].xgmii_tx_clk           =  xgmii_tx_clk         ; 
     assign  vip_slv_ethernet_if[idx].xxgmii_tx_clk          =  xxgmii_tx_clk        ; 
     assign  vip_slv_ethernet_if[idx].xxgmii_rx_clk          =  xxgmii_rx_clk        ; 
     assign  vip_slv_ethernet_if[idx].vsbi_rx_clk            =  vsbi_rx_clk          ;
     assign  vip_slv_ethernet_if[idx].rmii_tx_clk            =  rmii_tx_clk          ;
     assign  vip_slv_ethernet_if[idx].xlgmii_tx_clk          =  xlgmii_tx_clk        ;
     assign  vip_slv_ethernet_if[idx].serial_rx_basex_clk    =  serial_rx_basex_clk  ; 
     assign  vip_slv_ethernet_if[idx].gmii_tx_clk            =  gmii_tx_clk          ;
     assign  vip_slv_ethernet_if[idx].reference_clk          =  reference_clk        ;
     assign  vip_slv_ethernet_if[idx].xgmii_rx_clk           =  xgmii_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].cgmii_rx_clk           =  cgmii_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].vsbi_tx_clk            =  vsbi_tx_clk          ;
     assign  vip_slv_ethernet_if[idx].xsbi_rx_clk            =  xsbi_rx_clk          ;
     assign  vip_slv_ethernet_if[idx].xsbi_tx_clk            =  xsbi_tx_clk          ;
     assign  vip_slv_ethernet_if[idx].serial_tx_basex_clk    =  serial_tx_basex_clk  ;
     assign  vip_slv_ethernet_if[idx].xlgmii_rx_clk          =  xlgmii_rx_clk        ;
     assign  vip_slv_ethernet_if[idx].gmii_rx_clk            =  gmii_rx_clk          ;
     assign  vip_slv_ethernet_if[idx].rgmii_tx_clk           =  rgmii_tx_clk         ;
     assign  vip_slv_ethernet_if[idx].rgmii_rx_clk           =  rgmii_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].mii_100M_tx_clk        =  mii_100M_tx_clk      ;
     assign  vip_slv_ethernet_if[idx].mii_100M_rx_clk        =  mii_100M_rx_clk      ;
     assign  vip_slv_ethernet_if[idx].mii_10M_tx_clk         =  mii_10M_tx_clk       ;
     assign  vip_slv_ethernet_if[idx].mii_10M_rx_clk         =  mii_10M_rx_clk       ;
     assign  vip_slv_ethernet_if[idx].serial_rx_baser_clk    =  serial_rx_baser_clk  ; 
     assign  vip_slv_ethernet_if[idx].gmii_rmii_tx_clk       =  gmii_rmii_tx_clk     ;
     assign  vip_slv_ethernet_if[idx].serial_tx_base4x_clk   =  serial_tx_base4x_clk ;
     assign  vip_slv_ethernet_if[idx].mdio_clk               =  mdio_clk             ;
     assign  vip_slv_ethernet_if[idx].rmii_rx_clk            =  rmii_rx_clk          ;
     assign  vip_slv_ethernet_if[idx].serial_rx_base4x_clk   =  serial_rx_base4x_clk ; 
     assign  vip_slv_ethernet_if[idx].serial_tx_baser_clk    =  serial_tx_baser_clk  ;
     assign  vip_slv_ethernet_if[idx].xfbi_tx_clk            =  xfbi_tx_clk          ;
     assign  vip_slv_ethernet_if[idx].rxaui_tx_clk           =  rxaui_tx_clk         ;
     assign  vip_slv_ethernet_if[idx].rxaui_rx_clk           =  rxaui_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].serial_rxaui_tx_clk    =  serial_rxaui_tx_clk  ;
     assign  vip_slv_ethernet_if[idx].serial_rxaui_rx_clk    =  serial_rxaui_rx_clk  ;
     assign  vip_slv_ethernet_if[idx].gmii_rmii_rx_clk       =  gmii_rmii_rx_clk     ;
     assign  vip_slv_ethernet_if[idx].xfbi_rx_clk            =  xfbi_rx_clk          ;
     assign  vip_slv_ethernet_if[idx].smii_tx_clk            =  smii_tx_clk          ;
     assign  vip_slv_ethernet_if[idx].smii_rx_clk            =  smii_rx_clk          ;
     assign  vip_slv_ethernet_if[idx].clk_66t_rx             =  clk_66t_rx           ; 
     assign  vip_slv_ethernet_if[idx].clk_66t_tx             =  clk_66t_tx           ; 
     assign  vip_slv_ethernet_if[idx].clk_40t_rx             =  clk_40t_rx           ;
     assign  vip_slv_ethernet_if[idx].clk_40t_tx             =  clk_40t_tx           ;
     assign  vip_slv_ethernet_if[idx].serial_caui_25g_clk_tx =  serial_caui_25g_clk_tx;
     assign  vip_slv_ethernet_if[idx].serial_caui_25g_clk_rx =  serial_caui_25g_clk_rx;
     assign  vip_slv_ethernet_if[idx].caui_64b_clk_rx        =  caui_64b_clk_rx      ;
     assign  vip_slv_ethernet_if[idx].caui_64b_clk_tx        =  caui_64b_clk_tx      ;
     assign  vip_slv_ethernet_if[idx].xxvsbi_tx_clk         =   xxvsbi_tx_clk        ;
     assign  vip_slv_ethernet_if[idx].xxvsbi_rx_clk         =   xxvsbi_rx_clk        ;
     assign  vip_slv_ethernet_if[idx].lsbi_tx_clk           =   lsbi_tx_clk          ;
     assign  vip_slv_ethernet_if[idx].lsbi_rx_clk           =   lsbi_rx_clk          ;
     assign  vip_slv_ethernet_if[idx].xxvgmii_tx_clk        =   xxvgmii_tx_clk       ;
     assign  vip_slv_ethernet_if[idx].xxvgmii_rx_clk        =   xxvgmii_rx_clk       ;
     assign  vip_slv_ethernet_if[idx].lgmii_tx_clk          =   lgmii_tx_clk         ;
     assign  vip_slv_ethernet_if[idx].lgmii_rx_clk          =   lgmii_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].serial_12pt5g_clk_tx  =   serial_12pt5g_clk_tx ;
     assign  vip_slv_ethernet_if[idx].serial_12pt5g_clk_rx  =   serial_12pt5g_clk_rx ;
     assign  vip_slv_ethernet_if[idx].cdmii_tx_clk          =   cdmii_tx_clk         ;
     assign  vip_slv_ethernet_if[idx].cdmii_rx_clk          =   cdmii_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].dcccmii_tx_clk        =   dcccmii_tx_clk         ;
     assign  vip_slv_ethernet_if[idx].dcccmii_rx_clk        =   dcccmii_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].ccmii_tx_clk          =   ccmii_tx_clk         ;
     assign  vip_slv_ethernet_if[idx].ccmii_rx_clk          =   ccmii_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].serial_cd_rx_clk      =   serial_cd_rx_clk     ;
     assign  vip_slv_ethernet_if[idx].serial_cd_tx_clk      =   serial_cd_tx_clk     ;
     assign  vip_slv_ethernet_if[idx].serial_baset1_rx_clk  =   serial_baset1_rx_clk ;
     assign  vip_slv_ethernet_if[idx].serial_baset1_tx_clk  =   serial_baset1_tx_clk ;
     assign  vip_slv_ethernet_if[idx].serial_50g_rx_clk     =   serial_50g_rx_clk    ;
     assign  vip_slv_ethernet_if[idx].serial_50g_tx_clk     =   serial_50g_tx_clk    ;
     assign  vip_slv_ethernet_if[idx].serial_50g_single_lane_rx_clk  = serial_50g_single_lane_rx_clk;
     assign  vip_slv_ethernet_if[idx].serial_50g_single_lane_tx_clk  = serial_50g_single_lane_tx_clk;
     assign  vip_slv_ethernet_if[idx].serial_100g_rx_clk    =   serial_100g_rx_clk   ;
     assign  vip_slv_ethernet_if[idx].serial_100g_tx_clk    =   serial_100g_tx_clk   ;
     assign  vip_slv_ethernet_if[idx].cdxbi_tx_clk          =   cdxbi_tx_clk         ;
     assign  vip_slv_ethernet_if[idx].cdxbi_rx_clk          =   cdxbi_rx_clk         ;
     assign  vip_slv_ethernet_if[idx].serial_100baset1_rx_clk  = serial_100baset1_rx_clk;
     assign  vip_slv_ethernet_if[idx].serial_100baset1_tx_clk  = serial_100baset1_tx_clk;

     // Interface broadcast
     initial begin
       uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(), {"uvm_test_top.m_env.",$psprintf("ethernet_mac_mst[%0d]*",idx)}, "if_port", vip_mst_ethernet_if[idx]);
       uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(), {"uvm_test_top.m_env.",$psprintf("ethernet_mac_slv[%0d]*",idx)}, "if_port", vip_slv_ethernet_if[idx]);
     end
  end
  endgenerate
  

  /** Clock Generation. */
  always #`SVT_ETHERNET_XLGMII_CLOCK                      xlgmii_tx_clk        = ~xlgmii_tx_clk        ;
  always #`SVT_ETHERNET_XLGMII_CLOCK                      xlgmii_rx_clk        = ~xlgmii_rx_clk        ;
  always #`SVT_ETHERNET_XGMII_CLOCK                       xgmii_tx_clk         = ~xgmii_tx_clk         ; 
  always #`SVT_ETHERNET_XGMII_CLOCK                       xgmii_rx_clk         = ~xgmii_rx_clk         ;
  always #`SVT_ETHERNET_PTP_SYS_CLOCK 	                 ptp_system_clk        = ~ptp_system_clk      ; 
  always #`SVT_ETHERNET_XXGMII_CLOCK                      xxgmii_tx_clk        = ~xxgmii_tx_clk        ;
  always #`SVT_ETHERNET_XXGMII_CLOCK                      xxgmii_rx_clk        = ~xxgmii_rx_clk        ;
 `ifdef DXAUI_MODE
  always #(`SVT_ETHERNET_FBI_CLOCK/2)                     xfbi_tx_clk          = ~xfbi_tx_clk          ;
  always #(`SVT_ETHERNET_FBI_CLOCK/2)                     xfbi_rx_clk          = ~xfbi_rx_clk          ;
 `else
  always #`SVT_ETHERNET_FBI_CLOCK                         xfbi_tx_clk          = ~xfbi_tx_clk          ;
  always #`SVT_ETHERNET_FBI_CLOCK                         xfbi_rx_clk          = ~xfbi_rx_clk          ;
 `endif
  always #`SVT_ETHERNET_RXAUI_CLOCK                       rxaui_tx_clk         = ~rxaui_tx_clk         ;
  always #`SVT_ETHERNET_RXAUI_CLOCK                       rxaui_rx_clk         = ~rxaui_rx_clk         ;
  always #`SVT_ETHERNET_SERIAL_RXAUI_CLOCK                serial_rxaui_tx_clk  = ~serial_rxaui_tx_clk  ;
  always #`SVT_ETHERNET_SERIAL_RXAUI_CLOCK                serial_rxaui_rx_clk  = ~serial_rxaui_rx_clk  ;
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
  always #`SVT_ETHERNET_CDMII_CLOCK                        cdmii_tx_clk        = ~cdmii_tx_clk;
  always #`SVT_ETHERNET_CDMII_CLOCK                        cdmii_rx_clk        = ~cdmii_rx_clk;
  always #`SVT_ETHERNET_DCCCMII_CLOCK                      dcccmii_tx_clk      = ~dcccmii_tx_clk;
  always #`SVT_ETHERNET_DCCCMII_CLOCK                      dcccmii_rx_clk      = ~dcccmii_rx_clk;
  always #`SVT_ETHERNET_CCMII_CLOCK                        ccmii_tx_clk        = ~ccmii_tx_clk;
  always #`SVT_ETHERNET_CCMII_CLOCK                        ccmii_rx_clk        = ~ccmii_rx_clk;
  always #`SVT_ETHERNET_SERIAL_CD_CLOCK                    serial_cd_tx_clk    = ~serial_cd_tx_clk;
  always #`SVT_ETHERNET_SERIAL_CD_CLOCK                    serial_cd_rx_clk    = ~serial_cd_rx_clk;
  always #`SVT_ETHERNET_SERIAL_BASET1_CLOCK            serial_baset1_tx_clk    = ~serial_baset1_tx_clk;
  always #`SVT_ETHERNET_SERIAL_BASET1_CLOCK            serial_baset1_rx_clk    = ~serial_baset1_rx_clk;
  always #`SVT_ETHERNET_SERIAL_100BASET1_CLOCK      serial_100baset1_tx_clk    = ~serial_100baset1_tx_clk;
  always #`SVT_ETHERNET_SERIAL_100BASET1_CLOCK      serial_100baset1_rx_clk    = ~serial_100baset1_rx_clk;
  always #`SVT_ETHERNET_SERIAL_50G_CLOCK                   serial_50g_tx_clk   = ~serial_50g_tx_clk;
  always #`SVT_ETHERNET_SERIAL_50G_CLOCK                   serial_50g_rx_clk   = ~serial_50g_rx_clk;
  always #`SVT_ETHERNET_SERIAL_100G_CLOCK                 serial_100g_tx_clk  = ~serial_100g_tx_clk;
  always #`SVT_ETHERNET_SERIAL_100G_CLOCK                 serial_100g_rx_clk  = ~serial_100g_rx_clk;
  always #`SVT_ETHERNET_CDXBI_CLOCK                       cdxbi_tx_clk        = ~cdxbi_tx_clk;
  always #`SVT_ETHERNET_CDXBI_CLOCK                       cdxbi_rx_clk        = ~cdxbi_rx_clk;
  always #`SVT_ETHERNET_SERIAL_50G_SINGLE_LANE_CLOCK   serial_50g_single_lane_tx_clk   = ~serial_50g_single_lane_tx_clk;
  always #`SVT_ETHERNET_SERIAL_50G_SINGLE_LANE_CLOCK   serial_50g_single_lane_rx_clk   = ~serial_50g_single_lane_rx_clk;
  always #`SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK             serial_caui_25g_clk_tx = ~serial_caui_25g_clk_tx;
  always #`SVT_ETHERNET_SERIAL_CAUI_25G_CLOCK             serial_caui_25g_clk_rx = ~serial_caui_25g_clk_rx;

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
    rxaui_tx_clk          = 1'b0; 
    rxaui_rx_clk          = 1'b0; 
    serial_rxaui_tx_clk   = 1'b0; 
    serial_rxaui_rx_clk   = 1'b0; 
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
    serial_12pt5g_clk_rx = 1'b0;
    cdmii_tx_clk   = 1'b0;
    cdmii_rx_clk   = 1'b0;
    dcccmii_tx_clk = 1'b0;
    dcccmii_rx_clk = 1'b0;
    ccmii_tx_clk   = 1'b0;
    ccmii_rx_clk   = 1'b0;
    cdxbi_tx_clk   = 1'b0;
    cdxbi_rx_clk   = 1'b0;
    serial_cd_tx_clk= 1'b0;
    serial_cd_rx_clk= 1'b0;
    serial_baset1_tx_clk= 1'b0;
    serial_baset1_rx_clk= 1'b0;
    serial_100baset1_tx_clk= 1'b0;
    serial_100baset1_rx_clk= 1'b0;

    serial_50g_tx_clk= 1'b0;
    serial_50g_rx_clk= 1'b0;
    serial_50g_single_lane_tx_clk= 1'b0;
    serial_50g_single_lane_rx_clk= 1'b0;
    serial_100g_tx_clk= 1'b0;
    serial_100g_rx_clk= 1'b0;               
    
    /** Testbench generated reset to be connected to the VIP interface reset pin */
    repeat(2) @(posedge xgmii_rx_clk);
    reset = 1;
    repeat(2) @(posedge xgmii_rx_clk);
    reset = 0;

  end

`endif
