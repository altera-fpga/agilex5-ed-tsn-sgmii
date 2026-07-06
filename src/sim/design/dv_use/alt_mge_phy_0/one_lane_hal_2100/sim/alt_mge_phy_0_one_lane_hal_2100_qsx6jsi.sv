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



  module alt_mge_phy_0_one_lane_hal_2100_qsx6jsi 
  #(
    //parameter ch_pcs_l_duplex_mode                              = "Disabled ",
    //parameter ch_pcs_l_loopback_mode                            = "DISABLE  ",
    //parameter ch_pcs_l_fec_tx_en                                = "FALSE    ",
    //parameter ch_pcs_l_fec_rx_en                                = "FALSE    ",
    //parameter ch_pcs_l_tx_pcs_mode                              = "DISABLED ",
    //parameter ch_pcs_l_rx_pcs_mode                              = "DISABLED ",
    //parameter ch_pcs_l_rate_mode                                = "RATE_10G", 
//parameter ch_pcs_l_tx_en                                    = "FALSE  ",
//parameter ch_pcs_l_rx_en                                    = "FALSE  ",
//parameter ch_tx_channel_mode  = "PMAD",
//parameter  ch_rx_channel_mode  = "PMAD"
    //parameter ch_fec_l_duplex_mode                              = "Disabled",
    //parameter ch_fec_l_fec_spec                                 = "Disabled",
    //parameter ch_fec_l_loopback_mode                            = "DISABLE ",
    //parameter ch_fec_l_fracture                                 = "UNUSED  ",
    //parameter ch_fec_l_fec_mode                                 = "Disabled",
    //parameter ch_pldif_l_tx_en                                  = "FALSE         ",
    //parameter ch_pldif_l_rx_en                                  = "FALSE       ",
    //parameter ch_pldif_l_duplex_mode                            = "DUPLEX      ",
    //parameter ch_pldif_l_tx_fifo_mode                           = "PHASE_COMP  ",
    //parameter ch_pldif_l_tx_fifo_width                          = "DOUBLE_WIDTH",
    //parameter ch_pldif_l_rx_fifo_mode                           = "PHASE_COMP  ",
    //parameter ch_pldif_l_rx_fifo_width                          = "DOUBLE_WIDTH",
    //parameter ch_pldif_l_tx_clkout1_divider                     = "DIV1        ",
    //parameter ch_pldif_l_tx_clkout2_divider                     = "DIV1        ",
    //parameter ch_pldif_l_rx_clkout1_divider                     = "DIV1        ",
    //parameter ch_pldif_l_rx_clkout2_divider                     = "DIV1        ",
    //parameter ch_pcs_l_tx_bond_size                             = "DISABLED    ",
    //parameter ch_pcs_l_rx_bond_size                             = "DISABLED    ",
    //parameter ch_pldif_l_ptp_enable                             = "DISABLED    ",
    //parameter ch_pldif_l_tx_user1_clk_dynamic_mux               = "UNUSED      ",
    //parameter ch_pldif_l_tx_user2_clk_dynamic_mux               = "UNUSED      ",
    //parameter ch_pldif_l_rx_user1_clk_dynamic_mux               = "UNUSED      ",
    //parameter ch_pldif_l_rx_user2_clk_dynamic_mux               = "UNUSED      ",
    //parameter ch_ehip_l_mac_fec_tx_en                           =   "TRUE"       ,
    //parameter ch_ehip_l_mac_fec_rx_en                           =   "TRUE"       ,
    //parameter ch_ehip_l_mac_fec_mode                            =   "RSFEC"      ,
    //parameter ch_ehip_l_mac_ptp_mode                            =   "Disabled"   ,
    //parameter ch_ehip_l_mac_rate_mode                           =   "RATE_10G"   ,
    //parameter ch_ehip_l_mac_link_fault_mode                     =   "MAC_LF_OFF" ,
    //parameter ch_ehip_l_mac_remove_pads                         =   "Disable"    ,
    //parameter ch_ehip_l_mac_keep_rx_crc                         =   "Disable"    ,
    //parameter ch_ehip_l_mac_forward_rx_pause_requests           =   "Disable"    ,
    //parameter ch_ehip_l_mac_source_address_insertion            =   "Disable"    ,
    //parameter ch_ehip_l_mac_tx_vlan_detection                   =   "Disable"    ,
    //parameter ch_ehip_l_mac_rx_vlan_detection                   =   "Disable"    ,
    //parameter ch_ehip_l_mac_flow_control                        =   "MAC_BOTH"   ,
    //parameter ch_ehip_l_mac_tx_max_frame_size                   =    1518        ,
    //parameter ch_ehip_l_mac_rx_max_frame_size                   =    1518        ,
    //parameter ch_ehip_l_mac_enforce_max_frame_size              =   "Disable"    ,
    //parameter ch_ehip_l_mac_tx_preamble_passthrough             =   "Disable"    ,
    //parameter ch_ehip_l_mac_strict_preamble_checking            =   "Disable"    ,
    //parameter ch_ehip_l_mac_strict_sfd_checking                 =   "Disable"    ,
    //parameter ch_ehip_l_mac_tx_ipg_size                         =   "MAC_IPG_12" ,
    //parameter ch_ehip_l_mac_ipg_removed_per_am_period           =    8           ,
    //parameter ch_ehip_l_mac_custom_cadence                      =   "Disable"    ,
    //parameter ch_ehip_l_mac_rx_en                               =   "FALSE"      ,
    //parameter ch_ehip_l_mac_sim_mode                            =   "Enable"     ,
    //parameter ch_ehip_l_mac_sup_mode                            =   "USER_MODE"  ,
    //parameter ch_ehip_l_mac_tx_en                               =   "FALSE"      ,
    //parameter ch_ehip_l_duplex_mode                             =   "Duplex"     ,
    //parameter ch_ehip_l_mac_tx_mac_data_flow                    =   "Disable"    ,
    //parameter ch_ehip_l_mac_mode                                =   "DISABLED"   ,
    //parameter ch_l_xcvr_tx_preloaded_hardware_configs         =   "NONE"          ,
    //parameter ch_l_xcvr_tx_datarate_bps                       =    ""             ,
    //parameter ch_l_xcvr_tx_prbs_gen_en                        =   "Disable"       ,
    //parameter ch_l_xcvr_tx_bond_size                          =   "Disable"       ,
    //parameter ch_l_xcvr_tx_user_clk_only_mode                 =   "Disable"       ,
    //parameter ch_l_xcvr_tx_width                              =   "Disable"       ,   
    //parameter ch_l_xcvr_tx_dl_enable                          =   "Disable"       ,
    //parameter ch_l_xcvr_rx_preloaded_hardware_configs         =   "NONE"          ,   
    //parameter ch_l_xcvr_rx_datarate_bps                       =    ""             ,   
    //parameter ch_l_xcvr_rx_prbs_monitor_en                    =   "Disable"       ,
    //parameter ch_l_xcvr_rx_width                              =   "Disable"       ,
    //parameter ch_l_xcvr_rx_force_cdr_ltr                      =   "False"         ,   
    //parameter ch_l_xcvr_rx_adaptation_mode                    =   "DISABLED"      ,
    //parameter ch_l_xcvr_rx_dl_enable                          =   "Disable"       ,
    //parameter ch_l_xcvr_cdr_f_ref_hz                          =    ""             ,
    //parameter ch_l_xcvr_cdr_f_vco_hz                          =    ""             ,   
    //parameter ch_ux_l_rx_postdiv_clk_en                       =   "Disable"       ,
    //parameter ch_l_rx_postdiv_clk_divider                     =    ""             ,   
    //parameter ch_l_tx_pll_f_ref_hz                            =    ""             ,   
    //parameter ch_l_tx_pll_f_out_hz                            =    ""             ,   
    //parameter ch_l_tx_postdiv_clk_divider                     =    ""         ,
    //parameter ch_l_loopback_mode                              =   "DISABLE"       ,
    //parameter ch_flux_l_rx_protocol_hint                      =   "DISABLED"      ,
    //parameter ch_flux_l_tx_dl_enable                          =   "Enable"        ,
    //parameter ch_flux_l_rx_dl_enable                          =   "Disable"       ,
    //parameter ch_xcvrif_l_tx_dl_enable                        =   "Disable"       ,
    //parameter ch_xcvrif_l_rx_dl_enable                        =   "Disable"       ,
    //parameter ch_xcvrif_l_loopback_mode                       =   "Disable"       ,
    //parameter ch_xcvrif_l_tx_fifo_mode                        =   "DISABLED"      ,
    //parameter ch_xcvrif_l_rx_fifo_mode                        =   "DISABLED"      ,
    //parameter ch_xcvrif_l_pld_tx_user_clk1                    =   "DISABLED"      ,
    //parameter ch_xcvrif_l_pld_rx_user_clk1                    =   "DISABLED"      ,
    //parameter ch_xcvrif_l_pld_tx_user_clk2                    =   "DISABLED"      ,
    //parameter ch_xcvrif_l_pld_rx_user_clk2                    =   "DISABLED"      ,
    //parameter ch_xcvrif_l_tx_bond_size                        =   "Disabled"      ,
    //parameter ch_l_xcvr_tx_en                                 =   "Disable"       ,
    //parameter ch_l_xcvr_rx_en                                 =   "Disable"       ,
    //parameter ch_l_duplex_mode                                =   "Duplex"        ,
    //parameter ch_xcvrif_l_tx_en                               =   "False"         ,   
    //parameter ch_xcvrif_l_rx_en                               =   "False"         ,   
    //parameter ch_xcvrif_l_duplex_mode                         =   "Duplex"        ,
    //parameter ch_flux_l_rx_fec_type_used                      =   "NONE"          ,   
    //parameter ch_l_sim_mode                                   =    ""         ,   
    //parameter ch_flux_l_rx_sim_mode                           =   "Disable"       ,
    //parameter ch_flux_l_dr_enabled                            =   "DR_DISABLED"   ,
    //parameter ch_xcvrif_l_sup_mode                            =   "USER_MODE"     ,
    //parameter ch_xcvrif_l_sim_mode                            =   "Disable"       ,
    //parameter ch_xcvrif_l_dr_enabled                          =   "DR_DISABLED"      
    parameter ch_pcs_sf_en                                         =   "ENABLED",
    parameter ch_SF_PCS_TXMUX_EN                                   =   "ENABLED",
    parameter ch_SF_PCS_RXMUX_EN                                   =   "ENABLED",
    parameter ch_fec_sf_en                                         =   "ENABLED",
    parameter ch_SF_FEC_TXMUX_EN                                   =   "ENABLED",
    parameter ch_SF_FEC_S_EN                                       =   "ENABLED",
    parameter ch_SF_FEC_INGRESS_EN                                 =   "ENABLED",
    parameter ch_SF_FEC_EGRESS_EN                                  =   "ENABLED",
    parameter ch_pldif_sf_en                                       =   "ENABLED",
    parameter ch_SF_PLDCH_TX_USER1_MUX_EN                          =   "ENABLED",
    parameter ch_SF_PLDCH_TX_USER2_MUX_EN                          =   "ENABLED",
    parameter ch_SF_PLDCH_RX_USER1_MUX_EN                          =   "ENABLED",
    parameter ch_SF_PLDCH_RX_USER2_MUX_EN                          =   "ENABLED",
    parameter ch_SF_DESKEW_EN                                      =   "ENABLED",
    parameter ch_SF_DESKEW_RXMUX_EN                                =   "ENABLED",
    parameter ch_mac_sf_en                                         =   "ENABLED",
    parameter ch_SF_PTP_INGRESS_EN                                 =   "ENABLED",
    parameter ch_SF_PTP_EGRESS_EN                                  =   "ENABLED",
    parameter ch_SF_PTP_S_EN                                       =   "ENABLED",
    parameter ch_SF_PTP_EN                                         =   "ENABLED",
    parameter ch_SF_UX_EN                                          =   "ENABLED",
    parameter ch_SF_FLUX_GLOBAL_MEM_EN                             =   "ENABLED",
    parameter ch_SF_FLUX_S_EN                                      =   "ENABLED",
    parameter ch_SF_FLUX_TXUSER_CLK1_MUX_EN                        =   "ENABLED",
    parameter ch_SF_FLUX_TXUSER_CLK2_MUX_EN                        =   "ENABLED",
    parameter ch_SF_FLUX_RXUSER_CLK1_MUX_EN                        =   "ENABLED",
    parameter ch_SF_FLUX_RXUSER_CLK2_MUX_EN                        =   "ENABLED",
    parameter ch_SF_FLUX_I_EN                                      =   "ENABLED",
    parameter ch_SF_UX_TOOLBOX_EN                                  =   "ENABLED",
    parameter ch_SF_FLUX_CORE_EN                                   =   "ENABLED",
    parameter ch_SF_XCVRIF_1CH_EN                                  =   "ENABLED",
    parameter ch_SF_XCVRIF_TXMUX_EN                                =   "ENABLED",
    parameter ch_SF_XCRIF_TX_RST_MUX_EN                            =   "ENABLED",
    parameter ch_SF_XCRIF_TX_WREN_MUX_EN                           =   "ENABLED",
    parameter ch_SF_XCRIF_TX_RDEN_MUX_EN                           =   "ENABLED",
    parameter ch_SF_XCRIF_TXWORD_CLK_MUX_EN                        =   "ENABLED",
    parameter ch_SF_XCRIF_RXWORD_CLK_MUX_EN                        =   "ENABLED",
    
    parameter ch_tx_channel_mode                                   = "PMAD",
    parameter ch_rx_channel_mode                                   = "PMAD"
)
(
    input  [79:0] i_hio_txdata                          ,
    input  [9:0]  i_hio_txdata_extra                       ,
    input         i_hio_txdata_fifo_wr_en                  ,
    input         i_hio_rxdata_fifo_rd_en                  ,
    input         i_hio_ptp_rst_n                          ,
    input         i_hio_ehip_rx_rst_n                      ,
    input         i_hio_ehip_tx_rst_n                      ,
    input         i_hio_ehip_signal_ok                     ,
    input         i_hio_sfreeze_2_r03f_rx_mac_srfz_n       ,
    input         i_hio_sfreeze_3_c2f_tx_deskew_srfz_n    ,
    input         i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n       ,
    input         i_hio_rstfec_fec_rx_rst_n                ,
    input         i_hio_rstfec_fec_tx_rst_n                ,
    input         i_hio_rstfec_fec_csr_ret                 ,
    input         i_hio_rstfec_rx_fec_sfrz_n               ,
    input         i_hio_rstfec_tx_fec_sfrz_n               ,
    input         i_hio_rstxcvrif_xcvrif_rx_rst_n          ,
    input         i_hio_rstxcvrif_xcvrif_tx_rst_n          ,
    input         i_hio_rstxcvrif_xcvrif_signal_ok         ,
    input         i_hio_rstxcvrif_rx_xcvrif_sfrz_n         ,
    input         i_hio_rstxcvrif_tx_xcvrif_sfrz_n         ,
    input         i_hio_rst_pld_clrhip                     ,
    input         i_hio_rst_pld_clrpcs                     ,
    input         i_hio_rst_pld_perstn                     ,
    input         i_hio_rst_pld_ready                      ,
    input         i_hio_rst_pld_adapter_rx_pld_rst_n       ,
    input         i_hio_rst_pld_adapter_tx_pld_rst_n       ,
    input         i_hio_rst_ux_rx_pma_rst_n                ,
    input         i_hio_rst_ux_rx_sfrz                     ,
    input         i_hio_rst_ux_tx_pma_rst_n                ,
    input         i_hio_pld_reset_clk_row                  ,
    input  [79:0] i_hio_uxquad_async                       ,
    input  [79:0] i_hio_uxquad_async_pcie_mux              ,
    input  [20:0] i_hio_lavmm_addr                         ,
    input   [3:0] i_hio_lavmm_be                           ,
    input         i_hio_lavmm_clk                          ,
    input         i_hio_lavmm_read                         ,
    input         i_hio_lavmm_rstn                         ,
    input [31:0]  i_hio_lavmm_wdata                        ,
    input         i_hio_lavmm_write                        ,
    input         i_hio_pld_rx_clk_in_row_clk              ,
    input         i_hio_pld_tx_clk_in_row_clk              ,
    input         i_hio_det_lat_rx_dl_clk                  ,
    input         i_hio_det_lat_rx_mux_select              ,
    input         i_hio_det_lat_rx_sclk_flop               ,
    input         i_hio_det_lat_rx_sclk_gen_clk            ,
    input         i_hio_det_lat_rx_trig_flop               ,
    input         i_hio_det_lat_sampling_clk               ,
    input         i_hio_det_lat_tx_dl_clk                  ,
    input         i_hio_det_lat_tx_mux_select              ,
    input         i_hio_det_lat_tx_sclk_flop               ,
    input         i_hio_det_lat_tx_sclk_gen_clk            ,
    input         i_hio_det_lat_tx_trig_flop               ,
    input         rx_serial_n                              ,
    input         rx_serial_p                              ,   
    //input  [7:0]  i_hio_tx_pfc                             ,
    //input         i_hio_tx_pause                           ,
    //input         i_hio_clear_internal                     ,
    //input         i_hio_signal_ok                          ,
    //input         i_hio_pld_ready                          ,
    //input         i_hio_pma_rx_sf                          ,
    //input         i_hio_ch_rstxcvrif_lphy_signal_ok        ,
    //input         i_clear_tx_internal_err                  , 
    output        o_hio_txdata_fifo_wr_empty               ,
    input  [99:0] i_hio_txdata_async                       ,     
    input  [9:0 ] i_hio_txdata_direct                      ,     
    output [99:0] o_hio_rxdata_async                       ,     
    output [9:0 ] o_hio_rxdata_direct                      , 
    output        o_hio_txdata_fifo_wr_pempty              ,
    output        o_hio_txdata_fifo_wr_full                ,
    output        o_hio_txdata_fifo_wr_pfull               ,
    output [79:0] o_hio_rxdata                             ,
    output [9:0]  o_hio_rxdata_extra                       ,
    output        o_hio_rxdata_fifo_rd_empty               ,
    output        o_hio_rxdata_fifo_rd_pempty              ,
    output        o_hio_rxdata_fifo_rd_full                ,
    output        o_hio_rxdata_fifo_rd_pfull               ,
    output        o_hio_rstepcs_rx_pcs_fully_aligned       ,
    output        o_hio_rstfec_fec_rx_rdy_n                ,
    output        o_hio_rst_flux0_cpi_cmn_busy             ,
    output        o_hio_rst_oflux_rx_srds_rdy              ,
    output        o_hio_rst_ux_all_synthlockstatus         ,
    output        o_hio_rst_ux_octl_pcs_rxstatus           ,
    output        o_hio_rst_ux_octl_pcs_txstatus           ,
    output        o_hio_rst_ux_rxcdrlock2data              ,
    output        o_hio_rst_ux_rxcdrlockstatus             ,
    output [49:0] o_hio_uxquad_async                       ,
    output [31:0] o_hio_lavmm_rdata                        ,
    output        o_hio_lavmm_rdata_valid                  ,
    output        o_hio_lavmm_waitreq                      ,
    //output [2:0]  k_user_rx_clk1_c0c1c2_sel                ,   // need to remove here
    //output [2:0]  k_user_rx_clk2_c0c1c2_sel                ,
    //output [2:0]  k_user_tx_clk1_c0c1c2_sel                ,
    //output [2:0]  k_user_tx_clk2_c0c1c2_sel                ,
    output        o_hio_user_rx_clk1_clk                   ,
    output        o_hio_user_rx_clk2_clk                   ,
    output        o_hio_user_tx_clk1_clk                   ,
    output        o_hio_user_tx_clk2_clk                   ,
    output        o_hio_ux_chnl_refclk_mux                 ,
    output        o_hio_det_lat_rx_async_dl_sync           ,
    output        o_hio_det_lat_rx_async_pulse             ,
    output        o_hio_det_lat_rx_async_sample_sync       ,
    output        o_hio_det_lat_rx_sclk_sample_sync        ,
    output        o_hio_det_lat_rx_trig_sample_sync        ,
    output        o_hio_det_lat_tx_async_dl_sync           ,
    output        o_hio_det_lat_tx_async_pulse             ,
    output        o_hio_det_lat_tx_async_sample_sync       ,
    output        o_hio_det_lat_tx_sclk_sample_sync        ,
    output        o_hio_det_lat_tx_trig_sample_sync        ,
    output        o_hio_xcvrif_rx_latency_pulse            ,
    output        o_hio_xcvrif_tx_latency_pulse            ,
    output        tx_serial_p                              ,
    output        tx_serial_n                              ,
    //output        o_hio_local_fault                        ,
    //output        o_hio_remote_fault                       ,
    //output        o_hio_rx_pause                           ,
    //output [7:0]  o_hio_rx_pfc                             ,
    //output        o_hio_txfifo_pfull                       ,
    //output        o_hio_dsk_err                            ,
    //output        o_hio_dsk_mon_err                        ,
    //output        o_hio_hip_ready                          ,
    //output        o_hio_rx_block_lock                      ,
    //output        o_hio_rx_dsk_done                        ,
    //output        o_hio_rx_am_lock                         ,
    //output        o_hio_rx_pcs_fully_aligned               ,
    //output        o_hio_hi_ber                             ,
    //output        o_hio_rx_pcs_internal_err                ,
    //output        o_hio_tx_fifo_status_fifo_wr_pfull       ,
    //output        o_hio_tx_fifo_status_fifo_pempty         ,
    //output        o_hio_rx_fifo_status_fifo_pempty         ,
    //output        o_hio_rx_fifo_status_fifo_wr_pfull       ,
    //output        o_hio_rx_fifo_status_fifo_empty          ,
    //output        o_hio_tx_fifo_status_fifo_empty          ,
    //output        o_hio_rx_fifo_status_gb_restarted        ,
    //output        o_hio_tx_fifo_status_gb_restarted        ,

    input  [767:0]  i_uxwrap_bus_in_phy_shared          ,   
    output [703:0]  o_uxwrap_bus_out_phy_shared             , 
//  output          o_flux_sclk_mux_phy_shared          , 
//  input  [79:0]   i_ss_async_pldif_phy_shared         ,       /////
//  output [49:0]   o_ss_async_pldif_phy_shared            ,        /////
//  input  [79:0]   i_ss_async_pldif_pcie_mux_phy_shared   ,        /////
    output [19:0]   o_lavmm_addr_phy_shared                , 
    output [3:0]    o_lavmm_be_phy_shared                  , 
    output          o_lavmm_clk_phy_shared                 , 
    output          o_lavmm_read_phy_shared                , 
    output          o_lavmm_rstn_phy_shared                , 
    output [31:0]   o_lavmm_wdata_phy_shared               , 
    output          o_lavmm_write_phy_shared               , 
    input  [31:0]   i_lavmm_rdata_phy_shared               , 
    input           i_lavmm_rdata_valid_phy_shared          , 
    input           i_lavmm_waitreq_phy_shared              , 
//  input  [2:0]    i_rxpstate_phy_shared                  , 
//  input  [3:0]    i_rxrate_phy_shared                    , 
//  input           i_rxterm_hiz_ena_phy_shared            , 
//  input  [2:0]    i_rxwidth_phy_shared                   , 
//  input           i_tstbus_lane_phy_shared               , 
//  input           i_txbeacona_phy_shared                 , 
//  input  [2:0]    i_txclkdivrate_phy_shared              , 
//  input           i_txdetectrx_reqa_phy_shared           , 
//  input  [5:0]    i_txdrv_levn_phy_shared                , 
//  input  [4:0]    i_txdrv_levnm1_phy_shared              , 
//  input  [2:0]    i_txdrv_levnm2_phy_shared              , 
//  input  [4:0]    i_txdrv_levnp1_phy_shared              , 
//  input  [3:0]    i_txdrv_slew_phy_shared                , 
//  input  [3:0]    i_txelecidle_phy_shared                , 
//  input  [2:0]    i_txpstate_phy_shared                  , 
//  input  [3:0]    i_txrate_phy_shared                    , 
//  input  [2:0]    i_txwidth_phy_shared                   , 
//  output [1:0]    o_rxmargin_status_gray_phy_shared      , 
//  input           i_rst_ux_rx_sfrz_phy_shared             ,       /////
//  output          o_rst_flux0_cpi_cmn_busy_phy_shared ,        /////
//  output          o_rst_oflux_rx_srds_rdy_phy_shared      ,        /////
//  output          o_rst_ux_all_synthlockstatus_phy_shared ,     /////
//  output          o_rst_ux_rxcdrlockstatus_phy_shared     ,     /////
//  output          o_ock_pcs_cdrfbclk_phy_shared           ,     
//  output          o_ock_pcs_ref_phy_shared                ,
//  output          o_ux_tx_ch_ptr_smpl_phy_shared           ,      /////
//  output          o_dat_pcs_measlatrndtripbit_phy_shared  ,
    output          o_sclk_return_sel_rx_phy_shared         ,
    output          o_sclk_return_sel_tx_phy_shared        ,
//  input           i_ick_sclk_rx_phy_shared                 ,      /////
//  input           i_ick_sclk_tx_phy_shared                 ,      /////
    output          o_ick_sclk_rx_phy_shared                  ,
    input   [4:0]   i_sync_common_control_phy_shared         ,
    
    output          o_ft_rx_sclk_sync_ch_phy_shared,        
    output          o_ft_tx_sclk_sync_ch_phy_shared,        
    output          o_rst_ux_rx_pma_rst_n_phy_shared,       
    output          o_rst_ux_tx_pma_rst_n_phy_shared,       
    output          o_ick_pcs_txword_phy_shared,                    
    output          o_tx_dl_ch_bit_phy_shared,                      
    input           i_dat_pcs_measlatbit_phy_shared,                
    input           i_ft_rx_async_pulse_ch_phy_shared,
    input           i_ft_tx_async_pulse_ch_phy_shared,              
    input           i_rx_dl_ch_bit_phy_shared,                  
    input   [1:0]   i_ux_rxuser1_sel_phy_shared,
    input   [1:0]   i_ux_rxuser2_sel_phy_shared,                
    input   [1:0]   i_ux_txuser1_sel_phy_shared,
    input   [1:0]   i_ux_txuser2_sel_phy_shared,                    
    output          o_octl_pcs_txstatus_a_phy_shared,               
    input           i_ictl_pcs_txenable_a_phy_shared,       
    input   [124:0] i_sync_cfg_data_phy_shared,             
    input   [249:0] i_sync_interface_control_phy_shared,            
    output  [79:0]  o_tx_data_phy_shared,                           
    input   [79:0]  i_rx_data_phy_shared,                       
    output  [319:0] o_sm_flux_ingress_phy_shared,               
    input   [256:0] i_sm_flux_egress_phy_shared,                        
    input           i_flux_cpi_int_phy_shared,                      
    input           i_flux_int_phy_shared,                      
    input           i_oflux_octl_pcs_txptr_smpl_lane_phy_shared,    
    output          o_ick_sclk_tx_phy_shared,                       
    input           i_flux_srds_rdy_phy_shared,                 
    input           i_pcs_rxword_phy_shared,                            
    input           i_pcs_rxpostdiv_phy_shared,                 
    input           i_ock_pcs_txword_phy_shared,    
    output          o_dat_pcs_measlatrndtripbit_phy_shared,    
    
    output [19:0]   o_ch_lavmm_fec_addr_fec_wrap,       //fec_ingress interfaces with fec_wrap
    output [3:0]    o_ch_lavmm_fec_be_fec_wrap,
    output          o_ch_lavmm_fec_clk_fec_wrap,
    output          o_ch_lavmm_fec_read_fec_wrap,
    output          o_ch_lavmm_fec_rstn_fec_wrap,
    output [31:0]   o_ch_lavmm_fec_wdata_fec_wrap,
    output          o_ch_lavmm_fec_write_fec_wrap,
    input  [31:0]   i_ch_lavmm_fec_rdata_fec_wrap,
    input           i_ch_lavmm_fec_rdata_valid_fec_wrap,
    input           i_ch_lavmm_fec_waitreq_fec_wrap,
    input  [11:0]   i_ch_eth_fec_rx_async_fec_wrap,
    input           i_ch_eth_fec_rx_direct_fec_wrap,
    output [6:0]    o_ch_eth_fec_tx_async_fec_wrap,
    output          o_ch_eth_fec_tx_direct_fec_wrap,
    output          o_rstfec_fec_csr_ret_fec_wrap,
    input           i_fec_rx_rdy_n_fec_wrap,
    output          o_rstfec_fec_rx_rst_n_fec_wrap,
    output          o_rstfec_fec_tx_rst_n_fec_wrap,
    output          o_rstfec_rx_fec_sfrz_n_fec_wrap,
    output          o_rstfec_tx_fec_sfrz_n_fec_wrap,
    input           i_fec_tx_data_mux_sel_fec_wrap,
    input  [42:0]   i_fec_rx_data_fec_wrap,
    output [42:0]   o_fec_i_tx_mux_data_fec_wrap,
    output [42:0]   o_xcvr_rx_data,                     //fec_egress interfaces with fec_wrap
    input  [42:0]   i_xcvr_tx_data,
    output          o_pma_rx_sf,
    input           i_refclk_tx_p   ,
//    input           i_refclk_tx_n   ,//can derive as negated i_refclk_tx_p
    input           i_syspll_c0_clk ,
    input           i_syspll_c1_clk ,
    input           i_syspll_c2_clk ,
    input           i_flux_clk      ,
    input           i_refclk_rx_p   ,
//    input           i_refclk_rx_n   ,   

    input           i_ux_chnl_refclk_mux_phy_shared,   
    output          o_xcvrif_tx_fifo_rd_en_mux_x1,  
    input           i_xcvrif_tx_fifo_rd_en_mux_x2,  
    input           i_xcvrif_tx_fifo_rd_en_mux_x4,
    input           i_xcvrif_tx_fifo_rd_en_mux_x6_bot,
    input           i_xcvrif_tx_fifo_rd_en_mux_x6_top,
    input           i_xcvrif_tx_fifo_rd_en_mux_x8_bot,
    input           i_xcvrif_tx_fifo_rd_en_mux_x8_top,
    output          o_xcvrif_tx_rst_mux_x1,  
    input           i_xcvrif_tx_rst_mux_x2,  
    input           i_xcvrif_tx_rst_mux_x4,
    input           i_xcvrif_tx_rst_mux_x6_bot,
    input           i_xcvrif_tx_rst_mux_x6_top,
    input           i_xcvrif_tx_rst_mux_x8_bot,
    input           i_xcvrif_tx_rst_mux_x8_top,
    output          o_xcvrif_tx_word_clk_mux_x1,  
    input           i_xcvrif_tx_word_clk_mux_x2,  
    input           i_xcvrif_tx_word_clk_mux_x4,
    input           i_xcvrif_tx_word_clk_mux_x6_bot,
    input           i_xcvrif_tx_word_clk_mux_x6_top,
    input           i_xcvrif_tx_word_clk_mux_x8_bot,
    input           i_xcvrif_tx_word_clk_mux_x8_top,
    input           ioack_cdrdiv_left_ux_bidir_in     ,  
    input           ioack_synthdiv1_left_ux_bidir_in  ,  
    input           ioack_synthdiv2_left_ux_bidir_in  ,  
    output          ioack_cdrdiv_left_ux_bidir_out   ,  
    output          ioack_synthdiv1_left_ux_bidir_out,  
    output          ioack_synthdiv2_left_ux_bidir_out,  
    input           i_marker_found_up,  
    input           i_marker_found_dn,  
    output          o_marker_found,
//1p0 Ports
    output          o_xcvrif_tx_rst_wr_sync_mux_x1,  
    input           i_xcvrif_tx_rst_wr_sync_mux_x2,  
    input           i_xcvrif_tx_rst_wr_sync_mux_x4,
    input           i_xcvrif_tx_rst_wr_sync_mux_x6_bot,
    input           i_xcvrif_tx_rst_wr_sync_mux_x6_top,
    input           i_xcvrif_tx_rst_wr_sync_mux_x8_bot,
    input           i_xcvrif_tx_rst_wr_sync_mux_x8_top,
    output  [7:0]   o_ptp_rx_data_shared_ptp,
    output  [8:0]   o_ptp_tx_intfc_ptp_data_shared_ptp,
    output  [8:0]   o_ptp_tx_data_ld_shared_ptp,
    output          o_ptp_tx_wa_ld_shared_ptp,
    input  [3071:0] i_ptp_cfg_tx_asm_ch1_shared_ptp,
    input  [3071:0] i_ptp_cfg_tx_p2p_ch1_shared_ptp,
    input  [7:0]    i_ingress1_ptp_rx_intfc_ptp_data_shared_ptp,
    input  [8:0]    i_egress1_ptp_tx_data_shared_ptp,
    input  [8:0]    i_egress1_ptp_tx_data_ld_shared_ptp,
    input           i_ch1_ptp_mas_word_align_shared_ptp,
    input           i_egress1_ptp_tx_wa_ld_shared_ptp,
    input           i_ingress1_ptp_rx_dsk_marker_shared_ptp,
    input           i_ptp_ptpi_link_shared_ptp,
    output  [9:0]   o_ptp_rx_data_mux_0_shared_ptp,
    output  [9:0]   o_ptp_rx_data_mux_1_shared_ptp,
    input   [39:0]  i_sm_pld_tx_demux_0_i_eth_shared_ptp,
    output          o_ptp_clk_shared_ptp

);

/////////////////  MAC Signals  ////////////////////////////
    wire ss_ehip_rx_rst_n;
    wire ss_ehip_tx_rst_n;
    wire ss_sfreeze_2_r03f_rx_mac_srfz_n;
/*    wire ss_ptp_rst_n ;*/
    wire [13:0] ss_eth_mac_rx_async ;
    wire ss_eth_mac_rx_direct;
    wire [13:0] ss_eth_mac_tx_async ;
    wire ss_eth_mac_tx_direct;
    wire ch_tx_mac_ready;
    wire ch_rx_mac_inframe;
    wire ch_tx_mac_valid;
    wire [19:0] lavmm_emac_addr;
    wire [3:0] lavmm_emac_be;
    wire lavmm_emac_clk;
    wire lavmm_emac_read;
    wire lavmm_emac_rstn;
    wire [31:0] lavmm_emac_wdata;
    wire lavmm_emac_write;
    wire [31:0] lavmm_emac_rdata;
    wire lavmm_emac_rdata_valid;
    wire lavmm_emac_waitreq;
/*    wire [19:0] lavmm_ptp_addr;
    wire [3:0] lavmm_ptp_be;
    wire lavmm_ptp_clk;
    wire lavmm_ptp_read;
    wire lavmm_ptp_rstn;
    wire [31:0] lavmm_ptp_wdata;
    wire lavmm_ptp_write;
    wire [31:0] lavmm_ptp_rdata;
    wire lavmm_ptp_rdata_valid;
    wire lavmm_ptp_waitreq; */
    wire [8:0] ch_ptp_tx_deskewed_data;
    wire [7:0] ch_ptp_rx_data;
    wire ptp_rx_dsk_marker;
    wire ptp_mas_wm;
    wire [42:0] ch_pld_tx_deskewed_data;
    wire [42:0] mac_rx_data;
    wire [9:0]  ch_ptp_rx_data_mux;
    wire [10:0] ptp_tx_data_mux_0;
    
/////////////////  MUX Signals  ////////////////////////////    
    wire [42:0] tx_eth_data;
    wire [42:0] pcs_tx_mux_data;
    wire tx_mux_sel;
    wire rx_mux_sel;
    wire [42:0] fec_rx_data;
    wire [42:0] xcvr_rx_data;
    wire [42:0] pcs_rx_mux_data;
    wire [42:0] pcs_tx_data;
    wire [42:0] fec_i_tx_mux_data;
    wire [42:0] xcvr_tx_data;
    wire [42:0] mac_rx_data_deskew;
    wire [42:0] pcs_rx_data_deskew;
    wire [42:0] ch_muxed_rx_data;
    wire fec_tx_data_mux_sel;
    wire [1:0] tx_source_sel;
    wire [2:0] deskew_rx_source_sel;
    wire [2:0] rx_fifo_en_sel;
    wire [2:0] tx_rst_source_sel;
    wire [1:0] rx_xcvr_wordclk_sel;
    wire ch_xcvrif_rx_fifo_rd_en;
    wire ch_xcvrif_tx_fifo_rd_en;
    wire ch_xcvrif_rx_fifo_rd_en_mux;
    wire ch_xcvrif_tx_fifo_rd_en_mux;
    wire xcvr_rx_ch_clk;
    wire xcvr_tx_ch_clk;
    wire  o_ux_rx_user1_clk;                                                   //NA in ch4_phy Sujoy RTL
    wire  o_ux_rx_user2_clk;                                                   //NA in ch4_phy Sujoy RTL
    wire  o_ux_tx_user1_clk;                                                   //NA in ch4_phy Sujoy RTL
    wire  o_ux_tx_user2_clk;                                                   //NA in ch4_phy Sujoy RTL
    wire pcs_rxpostdiv;
    wire pcs_rxword;
    wire ux_txlc_clk;
    wire ock_pcs_txword;
    wire [2:0] tx_xcvr_wordclk_sel;
    wire ss_user_rx_clk1_clk;
    wire ss_user_rx_clk2_clk;
    wire ss_user_tx_clk1_clk;
    wire ss_user_tx_clk2_clk;
    wire [2:0] user_rx_clk1_c0c1c2_sel;
    wire [2:0] user_rx_clk2_c0c1c2_sel;
    wire [2:0] user_tx_clk1_c0c1c2_sel;
    wire [2:0] user_tx_clk2_c0c1c2_sel;

/////////////////  PHY Signals  ////////////////////////////
    wire [79:0] ss_uxquad_async;                                                                                        
    wire [79:0] ss_uxquad_async_pcie_mux;
    wire [49:0] ss_uxquad_async_i;
    wire [19:0] lavmm_ux_addr;
    wire [3:0] lavmm_ux_be;
    wire lavmm_ux_clk;
    wire lavmm_ux_read;
    wire lavmm_ux_rstn;
    wire [31:0] lavmm_ux_wdata;
    wire lavmm_ux_write;
    wire [31:0] lavmm_ux_rdata;
    wire lavmm_ux_rdata_valid;
    wire lavmm_ux_waitreq;
    wire ss_det_lat_rx_sclk_sync;
    wire ss_det_lat_tx_sclk_sync;
    wire ss_det_lat_rx_async_pulse;
    wire ss_det_lat_tx_async_pulse;
    wire ss_rst_ux_rxcdrlock2data;
    wire ss_rst_ux_rx_sfrz;            
    wire ss_rst_flux0_cpi_cmn_busy;    
    wire ss_rst_oflux_rx_srds_rdy;     
    wire ss_rst_ux_all_synthlockstatus;
    wire ss_rst_ux_rxcdrlockstatus;
    wire ux_tx_ch_ptr_smpl;
    wire ss_det_lat_rx_sclk_clk;
    wire ss_det_lat_tx_sclk_clk;
    wire ss_rst_ux_rx_pma_rst_n;
    wire ss_rst_ux_tx_pma_rst_n;
    wire [19:0] lavmm_xcvrif_addr;
    wire [3:0] lavmm_xcvrif_be;
    wire lavmm_xcvrif_clk;
    wire lavmm_xcvrif_read;
    wire lavmm_xcvrif_rstn;
    wire [31:0] lavmm_xcvrif_wdata;
    wire lavmm_xcvrif_write;
    wire [31:0] lavmm_xcvrif_rdata;
    wire lavmm_xcvrif_rdata_valid;
    wire lavmm_xcvrif_waitreq;
    //wire ss_det_lat_rx_sclk_clk    ;
    //wire ss_det_lat_tx_sclk_clk    ;
    wire ss_xcvrif_rx_latency_pulse;
    wire ss_xcvrif_tx_latency_pulse;
    wire [13:0] ss_eth_xcvrif_rx_async ;
    wire ss_eth_xcvrif_rx_direct;
    wire [6:0] ss_eth_xcvrif_tx_async ;
    wire ss_eth_xcvrif_tx_direct;
    wire ss_rstxcvrif_xcvrif_signal_ok;
    wire ss_rstxcvrif_rx_xcvrif_sfrz_n;
    wire ss_rstxcvrif_xcvrif_rx_rst_n ;
    wire ss_rstxcvrif_tx_xcvrif_sfrz_n;
    wire ss_rstxcvrif_xcvrif_tx_rst_n ;
    wire ss_rstxcvrif_xcvrif_tx_rst_n_mux ;
    wire pma_rx_sf ;
    wire [42:0] xcvrif_tx_mux_data ;
    wire [1:0] ux_rxuser1_sel ;
    wire [1:0] ux_rxuser2_sel ;
    wire [1:0] ux_txuser1_sel ;
    wire [1:0] ux_txuser2_sel ;
    wire  eth_rxword_clk ;
    wire  eth_txword_clk ;
    wire  ux_rx_user1_clk ;
    wire  ux_rx_user2_clk ;
    wire  ux_tx_user1_clk ;
    wire  ux_tx_user2_clk ;
    wire  eth_tx_ch_clk ;
    wire  eth_rx_ch_clk ;
    wire  rxstatusa ;
    wire  txstatusa ;
    wire  ux_chnl_refclk_mux ;
//Alligned 1p0
    wire  tx_rst_rd_sync_rst_n ;        
    wire  tx_rst_wr_sync_rst_n ;
    wire  ss_rstxcvrif_xcvrif_tx_rst_wr_sync_n_mux ;
    
    
/////////////////  PCS Signals  ////////////////////////////
    wire [19:0] lavmm_epcs_addr ;
    wire [3:0] lavmm_epcs_be ;
    wire lavmm_epcs_clk ;
    wire lavmm_epcs_read ;
    wire lavmm_epcs_rstn ;
    wire [31:0] lavmm_epcs_wdata ;
    wire lavmm_epcs_write ;
    wire [31:0] lavmm_epcs_rdata ;
    wire lavmm_epcs_rdata_valid ;
    wire lavmm_epcs_waitreq ;
    wire [13:0] ss_eth_pcs_rx_async  ;
    wire ss_eth_pcs_rx_direct ;
    wire [7:0] ss_eth_pcs_tx_async  ;
    wire ss_eth_pcs_tx_direct ;
    //wire ss_ehip_rx_rst_n ;
    //wire ss_ehip_tx_rst_n ;
    wire ss_rstepcs_rx_pcs_fully_aligned ;
    wire ss_t03f_sfreeze_1_tx_pcs_sfrz_n ;
    wire ehip_signal_ok ;



/////////////////  FEC Signals  ////////////////////////////
    wire [19:0] lavmm_fec_addr ;    
    wire [3:0] lavmm_fec_be ;   
    wire lavmm_fec_clk ;    
    wire lavmm_fec_read ;   
    wire lavmm_fec_rstn ;   
    wire [31:0] lavmm_fec_wdata ;   
    wire lavmm_fec_write ;  
    wire [31:0] lavmm_fec_rdata ;   
    wire lavmm_fec_rdata_valid ;    
    wire lavmm_fec_waitreq ;    
    wire [11:0] ss_eth_fec_rx_async  ;  
    wire ss_eth_fec_rx_direct ; 
    wire [6:0] ss_eth_fec_tx_async  ;   
    wire ss_eth_fec_tx_direct ; 
    wire ss_rstfec_fec_csr_ret  ;   
    wire ss_rstfec_fec_rx_rdy_n ;   
    wire ss_rstfec_rx_fec_sfrz_n ;  
    wire ss_rstfec_fec_rx_rst_n  ;  
    wire ss_rstfec_tx_fec_sfrz_n ;  
    wire ss_rstfec_fec_tx_rst_n  ;  

//Quartus Warnings

if ((ch_tx_channel_mode != "ETH_MODE") || (ch_rx_channel_mode != "ETH_MODE")) begin
    assign ss_eth_mac_rx_async      = 14'b0;
    assign ss_eth_mac_rx_direct     = 1'b0;
    assign ch_tx_mac_ready          = 1'b0;
    assign ch_rx_mac_inframe        = 1'b0;
    assign ch_ptp_rx_data           = 8'b0;
    assign ptp_rx_dsk_marker        = 1'b0;
    assign ptp_mas_wm               = 1'b0;
    assign ptp_tx_data_mux_0        = 11'b0;
end 
///*************************************************************************//
////***************** GENERATE ALL HAL ELEMENT ******************* ////
//***************************************************************************//
generate


///*************************************************************************//
////***************** PLDIF HAL ELEMENT ******************* ////
//***************************************************************************//
//  if (ch_pldif_sf_en == "ENABLED") begin    /// Superset includes ubiquitous HAL blocks. Hence removing the dependency of SF enable

//if ((ch_tx_channel_mode == "ETH_MODE") || (ch_rx_channel_mode == "ETH_MODE") || (ch_tx_channel_mode == "PCSD") || (ch_rx_channel_mode == "PCSD") || (ch_tx_channel_mode == "PCSD+FEC") || (ch_rx_channel_mode == "PCSD+FEC") || (ch_tx_channel_mode == "FECD") || (ch_rx_channel_mode == "FECD") || (ch_tx_channel_mode == "PMAD") || (ch_rx_channel_mode == "PMAD")) begin

alt_mge_phy_0_one_lane_hal_pldif_hal_2100_g7omyzi pldif_hal_top_inst(
    .i_hio_txdata                        (i_hio_txdata) ,      
    .i_hio_txdata_extra                  (i_hio_txdata_extra) ,     
    .i_hio_txdata_fifo_wr_en             (i_hio_txdata_fifo_wr_en) ,     
    .o_hio_txdata_fifo_wr_empty          (o_hio_txdata_fifo_wr_empty) ,     
    .o_hio_txdata_fifo_wr_pempty         (o_hio_txdata_fifo_wr_pempty) ,     
    .o_hio_txdata_fifo_wr_full           (o_hio_txdata_fifo_wr_full) ,     
    .o_hio_txdata_fifo_wr_pfull          (o_hio_txdata_fifo_wr_pfull) ,     
    .o_hio_rxdata                        (o_hio_rxdata) ,     
    .o_hio_rxdata_extra                  (o_hio_rxdata_extra) ,     
    .o_hio_rxdata_fifo_rd_empty          (o_hio_rxdata_fifo_rd_empty) ,     
    .o_hio_rxdata_fifo_rd_pempty         (o_hio_rxdata_fifo_rd_pempty) ,     
    .o_hio_rxdata_fifo_rd_full           (o_hio_rxdata_fifo_rd_full) , 
    .o_hio_rxdata_fifo_rd_pfull          (o_hio_rxdata_fifo_rd_pfull) , 
    .i_hio_rxdata_fifo_rd_en             (i_hio_rxdata_fifo_rd_en) ,     
    .i_hio_ptp_rst_n                     (i_hio_ptp_rst_n) ,
    .i_hio_ehip_rx_rst_n                 (i_hio_ehip_rx_rst_n) ,
    .i_hio_ehip_tx_rst_n                 (i_hio_ehip_tx_rst_n) ,
    .i_hio_ehip_signal_ok                (i_hio_ehip_signal_ok) ,
    .i_hio_sfreeze_2_r03f_rx_mac_srfz_n  (i_hio_sfreeze_2_r03f_rx_mac_srfz_n) ,              
    .i_hio_sfreeze_3_c2f_tx_deskew_srfz_n(i_hio_sfreeze_3_c2f_tx_deskew_srfz_n),                    
    .i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n  (i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n) ,           
    .o_hio_rstepcs_rx_pcs_fully_aligned  (o_hio_rstepcs_rx_pcs_fully_aligned) ,     
    .i_hio_rstfec_fec_rx_rst_n           (i_hio_rstfec_fec_rx_rst_n) ,   
    .i_hio_rstfec_fec_tx_rst_n           (i_hio_rstfec_fec_tx_rst_n) ,   
    .i_hio_rstfec_fec_csr_ret            (i_hio_rstfec_fec_csr_ret) ,     
    .o_hio_rstfec_fec_rx_rdy_n           (o_hio_rstfec_fec_rx_rdy_n) ,   
    .i_hio_rstfec_rx_fec_sfrz_n          (i_hio_rstfec_rx_fec_sfrz_n) ,
    .i_hio_rstfec_tx_fec_sfrz_n          (i_hio_rstfec_tx_fec_sfrz_n) , 
    .i_hio_rstxcvrif_xcvrif_rx_rst_n     (i_hio_rstxcvrif_xcvrif_rx_rst_n) ,    
    .i_hio_rstxcvrif_xcvrif_tx_rst_n     (i_hio_rstxcvrif_xcvrif_tx_rst_n) ,    
    .i_hio_rstxcvrif_xcvrif_signal_ok    (i_hio_rstxcvrif_xcvrif_signal_ok) ,       
    .i_hio_rstxcvrif_rx_xcvrif_sfrz_n    (i_hio_rstxcvrif_rx_xcvrif_sfrz_n) ,
    .i_hio_rstxcvrif_tx_xcvrif_sfrz_n    (i_hio_rstxcvrif_tx_xcvrif_sfrz_n) ,
    .i_hio_rst_pld_clrhip                (i_hio_rst_pld_clrhip) ,     
    .i_hio_rst_pld_clrpcs                (i_hio_rst_pld_clrpcs) ,     
    .i_hio_rst_pld_perstn                (i_hio_rst_pld_perstn) ,     
    .i_hio_rst_pld_ready                 (i_hio_rst_pld_ready) ,     
    .i_hio_rst_pld_adapter_rx_pld_rst_n  (i_hio_rst_pld_adapter_rx_pld_rst_n) ,     
    .i_hio_rst_pld_adapter_tx_pld_rst_n  (i_hio_rst_pld_adapter_tx_pld_rst_n) ,     
    .i_hio_rst_ux_rx_pma_rst_n           (i_hio_rst_ux_rx_pma_rst_n) ,     
    .i_hio_rst_ux_rx_sfrz                (i_hio_rst_ux_rx_sfrz) ,     
    .i_hio_rst_ux_tx_pma_rst_n           (i_hio_rst_ux_tx_pma_rst_n) ,     
    .o_hio_rst_flux0_cpi_cmn_busy        (o_hio_rst_flux0_cpi_cmn_busy) ,     
    .o_hio_rst_oflux_rx_srds_rdy         (o_hio_rst_oflux_rx_srds_rdy) ,     
    .o_hio_rst_ux_all_synthlockstatus    (o_hio_rst_ux_all_synthlockstatus) ,     
    .o_hio_rst_ux_octl_pcs_rxstatus      (o_hio_rst_ux_octl_pcs_rxstatus) ,     
    .o_hio_rst_ux_octl_pcs_txstatus      (o_hio_rst_ux_octl_pcs_txstatus) ,     
    .o_hio_rst_ux_rxcdrlock2data         (o_hio_rst_ux_rxcdrlock2data) ,     
    .o_hio_rst_ux_rxcdrlockstatus        (o_hio_rst_ux_rxcdrlockstatus) ,     
/*    .o_ss_ptp_rst_n                      (ss_ptp_rst_n) , */
    .o_ss_ehip_rx_rst_n                  (ss_ehip_rx_rst_n) ,
    .o_ss_ehip_tx_rst_n                  (ss_ehip_tx_rst_n) ,
    .o_ss_ehip_signal_ok                 (ehip_signal_ok) ,                                           
    .o_ss_sfreeze_2_r03f_rx_mac_srfz_n   (ss_sfreeze_2_r03f_rx_mac_srfz_n) ,     //Not Available in r8 ch4_pldif
    .o_ss_sfreeze_3_c2f_tx_deskew_srfz_n (),                                     //Not Available in r8 ch4_pldif                    
    .i_ss_rstepcs_rx_pcs_fully_aligned   (ss_rstepcs_rx_pcs_fully_aligned) ,     
    .o_ss_t03f_sfreeze_1_tx_pcs_sfrz_n   (ss_t03f_sfreeze_1_tx_pcs_sfrz_n) ,              
    .o_ss_rstfec_fec_rx_rst_n            (ss_rstfec_fec_rx_rst_n) ,   
    .o_ss_rstfec_fec_tx_rst_n            (ss_rstfec_fec_tx_rst_n) ,   
    .o_ss_rstfec_fec_csr_ret             (ss_rstfec_fec_csr_ret ) ,     
    .i_ss_rstfec_fec_rx_rdy_n            (ss_rstfec_fec_rx_rdy_n) ,   
    .o_ss_rstfec_rx_fec_sfrz_n           (ss_rstfec_rx_fec_sfrz_n) ,
    .o_ss_rstfec_tx_fec_sfrz_n           (ss_rstfec_tx_fec_sfrz_n) ,
    .o_ss_rstxcvrif_xcvrif_rx_rst_n      (ss_rstxcvrif_xcvrif_rx_rst_n ) ,    
    .o_ss_rstxcvrif_xcvrif_tx_rst_n      (ss_rstxcvrif_xcvrif_tx_rst_n ) ,    
    .o_ss_rstxcvrif_xcvrif_signal_ok     (ss_rstxcvrif_xcvrif_signal_ok) ,       
    .o_ss_rstxcvrif_rx_xcvrif_sfrz_n     (ss_rstxcvrif_rx_xcvrif_sfrz_n) ,
    .o_ss_rstxcvrif_tx_xcvrif_sfrz_n     (ss_rstxcvrif_tx_xcvrif_sfrz_n) ,
//    .o_ss_pcie_rst_pld_clrhip            () ,                                   //Not Available in r8 ch4_pldif                                         
//    .o_ss_pcie_rst_pld_clrpcs            () ,                                   //Not Available in r8 ch4_pldif   
//    .o_ss_pcie_rst_pld_perstn            () ,                                   //Not Available in r8 ch4_pldif   
    .o_ss_rst_ux_rx_pma_rst_n            (ss_rst_ux_rx_pma_rst_n) ,     
    .o_ss_rst_ux_rx_sfrz                 (ss_rst_ux_rx_sfrz) ,     
    .o_ss_rst_ux_tx_pma_rst_n            (ss_rst_ux_tx_pma_rst_n) ,     
    .i_ss_rst_flux0_cpi_cmn_busy         (ss_rst_flux0_cpi_cmn_busy    ) ,     
    .i_ss_rst_oflux_rx_srds_rdy          (ss_rst_oflux_rx_srds_rdy     ) ,     
    .i_ss_rst_ux_all_synthlockstatus     (ss_rst_ux_all_synthlockstatus) ,     
    .i_ss_rst_ux_octl_pcs_rxstatus       (rxstatusa) ,                                       
    .i_ss_rst_ux_octl_pcs_txstatus       (txstatusa) ,     
    .i_ss_rst_ux_rxcdrlock2data          (ss_rst_ux_rxcdrlock2data) ,     
    .i_ss_rst_ux_rxcdrlockstatus         (ss_rst_ux_rxcdrlockstatus) ,     
    .i_hio_pld_reset_clk_row             (i_hio_pld_reset_clk_row) ,     
    .i_ss_eth_fec_rx_async               (ss_eth_fec_rx_async ) ,     
    .i_ss_eth_fec_rx_direct              (ss_eth_fec_rx_direct) ,     
    .o_ss_eth_fec_tx_async               (ss_eth_fec_tx_async ) ,     
    .o_ss_eth_fec_tx_direct              (ss_eth_fec_tx_direct) ,     
    .i_ss_eth_mac_rx_async               (ss_eth_mac_rx_async) ,     
    .i_ss_eth_mac_rx_direct              (ss_eth_mac_rx_direct) ,     
    .o_ss_eth_mac_tx_async               (ss_eth_mac_tx_async) ,     
    .o_ss_eth_mac_tx_direct              (ss_eth_mac_tx_direct) ,     
    .i_ss_eth_pcs_rx_async               (ss_eth_pcs_rx_async ) ,     
    .i_ss_eth_pcs_rx_direct              (ss_eth_pcs_rx_direct) ,     
    .o_ss_eth_pcs_tx_async               (ss_eth_pcs_tx_async ) ,     
    .o_ss_eth_pcs_tx_direct              (ss_eth_pcs_tx_direct) ,     
    .i_ss_eth_xcvrif_rx_async            (ss_eth_xcvrif_rx_async ) ,     
    .i_ss_eth_xcvrif_rx_direct           (ss_eth_xcvrif_rx_direct) ,     
    .o_ss_eth_xcvrif_tx_async            (ss_eth_xcvrif_tx_async ) ,     
    .o_ss_eth_xcvrif_tx_direct           (ss_eth_xcvrif_tx_direct) ,     
    .i_ss_pcie_ctrl_rx_async             () ,                                                 
    .i_ss_pcie_ctrl_rx_direct            () ,     
//    .o_ss_pcie_ctrl_tx_async             () ,     
//    .o_ss_pcie_ctrl_tx_direct            () ,     
    .o_ss_uxquad_async                   (ss_uxquad_async) ,
    .o_ss_uxquad_async_pcie_mux          (ss_uxquad_async_pcie_mux) ,                   
    .i_ss_uxquad_async                   (ss_uxquad_async_i) , 
    .i_hio_uxquad_async                  (i_hio_uxquad_async) ,
    .i_hio_uxquad_async_pcie_mux         (i_hio_uxquad_async_pcie_mux) ,                    
    .o_hio_uxquad_async                  (o_hio_uxquad_async) ,  
    .i_hio_txdata_async                  (i_hio_txdata_async ) ,     
    .i_hio_txdata_direct                 (i_hio_txdata_direct) ,     
    .o_hio_rxdata_async                  (o_hio_rxdata_async ) ,     
    .o_hio_rxdata_direct                 (o_hio_rxdata_direct) ,     
    .o_hio_lavmm_rdata                   (o_hio_lavmm_rdata) ,     
    .o_hio_lavmm_rdata_valid             (o_hio_lavmm_rdata_valid) ,     
    .o_hio_lavmm_waitreq                 (o_hio_lavmm_waitreq) ,     
    .i_hio_lavmm_addr                    (i_hio_lavmm_addr) ,     
    .i_hio_lavmm_be                      (i_hio_lavmm_be) ,     
    .i_hio_lavmm_clk                     (i_hio_lavmm_clk) ,     
    .i_hio_lavmm_read                    (i_hio_lavmm_read) ,     
    .i_hio_lavmm_rstn                    (i_hio_lavmm_rstn) ,     
    .i_hio_lavmm_wdata                   (i_hio_lavmm_wdata) ,     
    .i_hio_lavmm_write                   (i_hio_lavmm_write) ,     
    .i_ss_lavmm_pcie_rdata               () ,     
    .i_ss_lavmm_pcie_rdata_valid         (1'b0) ,     
    .i_ss_lavmm_pcie_waitreq             (1'b1) ,     
    .o_ss_lavmm_pcie_addr                () ,     
    .o_ss_lavmm_pcie_be                  () ,     
    .o_ss_lavmm_pcie_clk                 () ,     
    .o_ss_lavmm_pcie_read                () ,     
    .o_ss_lavmm_pcie_rstn                () ,     
    .o_ss_lavmm_pcie_wdata               () ,     
    .o_ss_lavmm_pcie_write               () ,     
    .k_user_rx_clk1_c0c1c2_sel           (user_rx_clk1_c0c1c2_sel) ,     
    .k_user_rx_clk2_c0c1c2_sel           (user_rx_clk2_c0c1c2_sel) ,     
    .k_user_tx_clk1_c0c1c2_sel           (user_tx_clk1_c0c1c2_sel) ,     
    .k_user_tx_clk2_c0c1c2_sel           (user_tx_clk2_c0c1c2_sel) ,
    .i_ss_user_rx_clk1_clk               (ss_user_rx_clk1_clk) ,     
    .i_ss_user_rx_clk2_clk               (ss_user_rx_clk2_clk) ,     
    .i_ss_user_tx_clk1_clk               (ss_user_tx_clk1_clk) ,     
    .i_ss_user_tx_clk2_clk               (ss_user_tx_clk2_clk) ,   
    .o_hio_user_rx_clk1_clk              (o_hio_user_rx_clk1_clk) ,     
    .o_hio_user_rx_clk2_clk              (o_hio_user_rx_clk2_clk) ,     
    .o_hio_user_tx_clk1_clk              (o_hio_user_tx_clk1_clk) ,     
    .o_hio_user_tx_clk2_clk              (o_hio_user_tx_clk2_clk) ,     
    .i_ux_chnl_refclk_mux                (ux_chnl_refclk_mux) ,                    //Connected tx_pll_refclk 
    .o_hio_ux_chnl_refclk_mux            (o_hio_ux_chnl_refclk_mux) ,     
/*     .i_ss_tx_fifo_clk                    () ,                                               //Extra confirm and remove RR  
    .i_ss_rx_fifo_clk                    () ,   */   
    .i_hio_pld_rx_clk_in_row_clk         (i_hio_pld_rx_clk_in_row_clk  ) ,     
    .i_hio_pld_tx_clk_in_row_clk         (i_hio_pld_tx_clk_in_row_clk  ) ,     
    .i_hio_det_lat_rx_dl_clk             (i_hio_det_lat_rx_dl_clk      ) ,       
    .i_hio_det_lat_rx_mux_select         (i_hio_det_lat_rx_mux_select  ) ,       
    .i_hio_det_lat_rx_sclk_flop          (i_hio_det_lat_rx_sclk_flop   ) ,       
    .i_hio_det_lat_rx_sclk_gen_clk       (i_hio_det_lat_rx_sclk_gen_clk) ,       
    .i_hio_det_lat_rx_trig_flop          (i_hio_det_lat_rx_trig_flop   ) ,       
    .i_hio_det_lat_sampling_clk          (i_hio_det_lat_sampling_clk   ) ,       
    .i_hio_det_lat_tx_dl_clk             (i_hio_det_lat_tx_dl_clk      ) ,       
    .i_hio_det_lat_tx_mux_select         (i_hio_det_lat_tx_mux_select  ) ,       
    .i_hio_det_lat_tx_sclk_flop          (i_hio_det_lat_tx_sclk_flop   ) ,       
    .i_hio_det_lat_tx_sclk_gen_clk       (i_hio_det_lat_tx_sclk_gen_clk) ,       
    .i_hio_det_lat_tx_trig_flop          (i_hio_det_lat_tx_trig_flop   ) ,       
    .o_hio_det_lat_rx_async_dl_sync      (o_hio_det_lat_rx_async_dl_sync    ) ,       
    .o_hio_det_lat_rx_async_pulse        (o_hio_det_lat_rx_async_pulse      ) ,       
    .o_hio_det_lat_rx_async_sample_sync  (o_hio_det_lat_rx_async_sample_sync) ,       
    .o_hio_det_lat_rx_sclk_sample_sync   (o_hio_det_lat_rx_sclk_sample_sync ) ,       
    .o_hio_det_lat_rx_trig_sample_sync   (o_hio_det_lat_rx_trig_sample_sync ) ,       
    .o_hio_det_lat_tx_async_dl_sync      (o_hio_det_lat_tx_async_dl_sync    ) ,       
    .o_hio_det_lat_tx_async_pulse        (o_hio_det_lat_tx_async_pulse      ) ,       
    .o_hio_det_lat_tx_async_sample_sync  (o_hio_det_lat_tx_async_sample_sync) ,       
    .o_hio_det_lat_tx_sclk_sample_sync   (o_hio_det_lat_tx_sclk_sample_sync ) ,       
    .o_hio_det_lat_tx_trig_sample_sync   (o_hio_det_lat_tx_trig_sample_sync ) ,       
    .o_hio_xcvrif_rx_latency_pulse       (o_hio_xcvrif_rx_latency_pulse     ) ,
    .o_hio_xcvrif_tx_latency_pulse       (o_hio_xcvrif_tx_latency_pulse     ) ,
    .o_ss_det_lat_rx_sclk_clk            (ss_det_lat_rx_sclk_clk) ,       
    .o_ss_det_lat_rx_sclk_sync           (ss_det_lat_rx_sclk_sync) ,       
    .o_ss_det_lat_tx_sclk_clk            (ss_det_lat_tx_sclk_clk) ,       
    .o_ss_det_lat_tx_sclk_sync           (ss_det_lat_tx_sclk_sync) ,       
    .i_ss_det_lat_rx_async_pulse         (ss_det_lat_rx_async_pulse) ,       
    .i_ss_det_lat_tx_async_pulse         (ss_det_lat_tx_async_pulse) ,       
    .i_ss_xcvrif_rx_latency_pulse        (ss_xcvrif_rx_latency_pulse) ,
    .i_ss_xcvrif_tx_latency_pulse        (ss_xcvrif_tx_latency_pulse) ,
    .i_ux_tx_ch_ptr_smpl                 (ux_tx_ch_ptr_smpl) ,
    .o_hio_ux_tx_ch_ptr_smpl             () ,
    .i_deskew_rx_ch_clk                  (eth_rx_ch_clk) ,
    .i_deskew_tx_ch_clk                  (eth_tx_ch_clk) ,
    .o_marker_found                      (o_marker_found) ,
    .i_marker_found_up                   (i_marker_found_up) ,
    .i_marker_found_dn                   (i_marker_found_dn) ,
    .o_deskew_rx_source_sel              (deskew_rx_source_sel) ,
    .i_ch_muxed_rx_data                  (ch_muxed_rx_data) ,
    .o_ch_pld_tx_deskewed_data           (ch_pld_tx_deskewed_data) ,
    .o_ch_ptp_tx_deskewed_data           (ch_ptp_tx_deskewed_data) ,
    .i_ch_ptp_rx_data                    (ch_ptp_rx_data) ,
    .i_ch_tx_mac_ready                   (ch_tx_mac_ready) ,
    .i_ch_rx_mac_inframe                 (ch_rx_mac_inframe) ,
    .o_ch_tx_mac_valid                   (ch_tx_mac_valid) ,
    .i_ptp_rx_dsk_marker                 (ptp_rx_dsk_marker) ,
    .i_ptp_mas_wm                        (ptp_mas_wm) ,
    .i_tx_pcs_data                       (pcs_tx_data) ,                                                //From PCS to DESKEW
    .i_tx_mac_data                       () ,                                                           //From MAC to DESKEW
    .o_lavmm_xcvrif_addr                 (lavmm_xcvrif_addr) ,
    .o_lavmm_xcvrif_be                   (lavmm_xcvrif_be) ,
    .o_lavmm_xcvrif_clk                  (lavmm_xcvrif_clk) ,
    .o_lavmm_xcvrif_read                 (lavmm_xcvrif_read) ,
    .o_lavmm_xcvrif_rstn                 (lavmm_xcvrif_rstn) ,
    .o_lavmm_xcvrif_wdata                (lavmm_xcvrif_wdata) ,
    .o_lavmm_xcvrif_write                (lavmm_xcvrif_write) ,
    .i_lavmm_xcvrif_rdata                (lavmm_xcvrif_rdata) ,
    .i_lavmm_xcvrif_rdata_valid          (lavmm_xcvrif_rdata_valid) ,
    .i_lavmm_xcvrif_waitreq              (lavmm_xcvrif_waitreq) ,
    .o_lavmm_emac_addr                   (lavmm_emac_addr) ,
    .o_lavmm_emac_be                     (lavmm_emac_be) ,
    .o_lavmm_emac_clk                    (lavmm_emac_clk) ,
    .o_lavmm_emac_read                   (lavmm_emac_read) ,
    .o_lavmm_emac_rstn                   (lavmm_emac_rstn) ,
    .o_lavmm_emac_wdata                  (lavmm_emac_wdata) ,
    .o_lavmm_emac_write                  (lavmm_emac_write) ,
    .i_lavmm_emac_rdata                  (lavmm_emac_rdata) ,
    .i_lavmm_emac_rdata_valid            (lavmm_emac_rdata_valid) ,
    .i_lavmm_emac_waitreq                (lavmm_emac_waitreq) ,
    .o_lavmm_epcs_addr                   (lavmm_epcs_addr       ) ,
    .o_lavmm_epcs_be                     (lavmm_epcs_be         ) ,
    .o_lavmm_epcs_clk                    (lavmm_epcs_clk        ) ,
    .o_lavmm_epcs_read                   (lavmm_epcs_read       ) ,
    .o_lavmm_epcs_rstn                   (lavmm_epcs_rstn       ) ,
    .o_lavmm_epcs_wdata                  (lavmm_epcs_wdata      ) ,
    .o_lavmm_epcs_write                  (lavmm_epcs_write      ) ,
    .i_lavmm_epcs_rdata                  (lavmm_epcs_rdata      ) ,
    .i_lavmm_epcs_rdata_valid            (lavmm_epcs_rdata_valid) ,
    .i_lavmm_epcs_waitreq                (lavmm_epcs_waitreq    ) ,
    .o_lavmm_fec_addr                    (lavmm_fec_addr) ,
    .o_lavmm_fec_be                      (lavmm_fec_be) ,
    .o_lavmm_fec_clk                     (lavmm_fec_clk) ,
    .o_lavmm_fec_read                    (lavmm_fec_read) ,
    .o_lavmm_fec_rstn                    (lavmm_fec_rstn) ,
    .o_lavmm_fec_wdata                   (lavmm_fec_wdata) ,
    .o_lavmm_fec_write                   (lavmm_fec_write) ,
    .i_lavmm_fec_rdata                   (lavmm_fec_rdata) ,
    .i_lavmm_fec_rdata_valid             (lavmm_fec_rdata_valid) ,
    .i_lavmm_fec_waitreq                 (lavmm_fec_waitreq) ,
/*    .o_lavmm_ptp_addr                    (lavmm_ptp_addr) ,
    .o_lavmm_ptp_be                      (lavmm_ptp_be) ,
    .o_lavmm_ptp_clk                     (lavmm_ptp_clk) ,
    .o_lavmm_ptp_read                    (lavmm_ptp_read) ,
    .o_lavmm_ptp_rstn                    (lavmm_ptp_rstn) ,
    .o_lavmm_ptp_wdata                   (lavmm_ptp_wdata) ,
    .o_lavmm_ptp_write                   (lavmm_ptp_write) ,
    .i_lavmm_ptp_rdata                   (lavmm_ptp_rdata) ,
    .i_lavmm_ptp_rdata_valid             (lavmm_ptp_rdata_valid) ,
    .i_lavmm_ptp_waitreq                 (lavmm_ptp_waitreq) ,  */
    .o_lavmm_ux_addr                     (lavmm_ux_addr) ,
    .o_lavmm_ux_be                       (lavmm_ux_be) ,
    .o_lavmm_ux_clk                      (lavmm_ux_clk) ,
    .o_lavmm_ux_read                     (lavmm_ux_read) ,
    .o_lavmm_ux_rstn                     (lavmm_ux_rstn) ,
    .o_lavmm_ux_wdata                    (lavmm_ux_wdata) ,
    .o_lavmm_ux_write                    (lavmm_ux_write) ,
    .i_lavmm_ux_rdata                    (lavmm_ux_rdata) ,
    .i_lavmm_ux_rdata_valid              (lavmm_ux_rdata_valid) ,
    .i_lavmm_ux_waitreq                  (lavmm_ux_waitreq),
    
    .i_ptp_tx_data                                      (ptp_tx_data_mux_0),
    .o_ch_ptp_rx_data                                   (ch_ptp_rx_data_mux),
    .sm_pld_tx_demux_0_o_pcie                           (),
    /* .sm_hssi_pld_chnl_user_mux_0_i_c0                   (i_syspll_c0_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_2_i_c0                   (i_syspll_c0_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_3_i_c0                   (i_syspll_c0_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_1_i_c0                   (i_syspll_c0_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_0_i_c1                   (i_syspll_c1_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_2_i_c1                   (i_syspll_c1_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_3_i_c1                   (i_syspll_c1_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_1_i_c1                   (i_syspll_c1_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_0_i_c2                   (i_syspll_c2_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_2_i_c2                   (i_syspll_c2_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_3_i_c2                   (i_syspll_c2_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_1_i_c2                   (i_syspll_c2_clk),//should come from top */
    .sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0_i_eth_or_ptp (eth_rx_ch_clk),
    .sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0_i_eth_or_ptp (eth_tx_ch_clk),
    /* .sm_deskew_rx_mux_0_i_ethmac                        (mac_rx_data_deskew),
    .sm_deskew_rx_mux_0_i_ethpcs                        (pcs_rx_data_deskew),
    .sm_deskew_rx_mux_0_i_fec                           (fec_rx_data), */
    .sm_pld_rx_mux_0_i_pcie                             (),
    .sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0_i_pcie       (),
    .sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0_i_pcie       (),
    .sm_pld_rx_mux_0_i_pcie_bond                        (),
    .sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0_i_pcie_top   (),
    .sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0_i_pcie_top   ()
    /* .sm_hssi_pld_chnl_user_mux_0_i_ux                   (o_ux_rx_user1_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_2_i_ux                   (o_ux_tx_user1_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_3_i_ux                   (o_ux_tx_user2_clk),//should come from top
    .sm_hssi_pld_chnl_user_mux_1_i_ux                   (o_ux_rx_user2_clk),//should come from top
    .sm_deskew_rx_mux_0_i_xcvrif                        (xcvr_rx_data) */

);
//end


// *************All Muxes taken oustide ********************** //

    tennm_sm_hssi_pld_chnl_user_mux_module x_dynMux_sm_hssi_pld_chnl_user_mux_0 (
        .i_c0               (i_syspll_c0_clk),
        .i_c1               (i_syspll_c1_clk),
        .i_c2               (i_syspll_c2_clk),
        .i_ux               (ux_rx_user1_clk),
//        .k_dfx_tdr_static_clock_mux(0),                 //0p8 sujoy rtl not available
        .k_c0c1c2_sel       (user_rx_clk1_c0c1c2_sel),
        .o_usr_clk          (ss_user_rx_clk1_clk)
    );

    tennm_sm_hssi_pld_chnl_user_mux_module x_dynMux_sm_hssi_pld_chnl_user_mux_1 (
        .i_c0               (i_syspll_c0_clk),
        .i_c1               (i_syspll_c1_clk),
        .i_c2               (i_syspll_c2_clk),
        .i_ux               (ux_rx_user2_clk),
//        .k_dfx_tdr_static_clock_mux(0),
        .k_c0c1c2_sel       (user_rx_clk2_c0c1c2_sel),
        .o_usr_clk          (ss_user_rx_clk2_clk)
    );

    tennm_sm_hssi_pld_chnl_user_mux_module x_dynMux_sm_hssi_pld_chnl_user_mux_2 (
        .i_c0               (i_syspll_c0_clk),
        .i_c1               (i_syspll_c1_clk),
        .i_c2               (i_syspll_c2_clk),
        .i_ux               (ux_tx_user1_clk),
//        .k_dfx_tdr_static_clock_mux(0),
        .k_c0c1c2_sel       (user_tx_clk1_c0c1c2_sel),
        .o_usr_clk          (ss_user_tx_clk1_clk)
    );

    tennm_sm_hssi_pld_chnl_user_mux_module x_dynMux_sm_hssi_pld_chnl_user_mux_3 (
        .i_c0               (i_syspll_c0_clk),
        .i_c1               (i_syspll_c1_clk),
        .i_c2               (i_syspll_c2_clk),
        .i_ux               (ux_tx_user2_clk),
//        .k_dfx_tdr_static_clock_mux(0),
        .k_c0c1c2_sel       (user_tx_clk2_c0c1c2_sel),
        .o_usr_clk          (ss_user_tx_clk2_clk)
    );  
    
    tennm_sm_deskew_rx_mux_module x_dynMux_sm_deskew_rx_mux_0 (
        .i_ethmac           (mac_rx_data_deskew),
        .i_ethpcs           (pcs_rx_data_deskew),
        .i_fec              (fec_rx_data),                      //need to check one more time
        .i_sel              (deskew_rx_source_sel),
        .i_xcvrif           (xcvr_rx_data),
        .o_ch_rxdata        (ch_muxed_rx_data)          //need to check one more time
    
    );

/*     ch4_pldif_dynmux ch4_pldif_dynmux_inst(
        .x_dynMux_sm_deskew_rx_mux_0__i_xcvrif                      (xcvr_rx_data),
        .x_dynMux_sm_deskew_rx_mux_0__i_ethpcs                      (pcs_rx_data_deskew),
        .x_dynMux_sm_deskew_rx_mux_0__o_ch_rxdata                   (ch_muxed_rx_data),
        .x_dynMux_sm_deskew_rx_mux_0__i_ethmac                      (mac_rx_data_deskew),
        .x_dynMux_sm_deskew_rx_mux_0__i_fec                         (fec_rx_data),
        .x_dynMux_sm_deskew_rx_mux_0__i_sel                         (deskew_rx_source_sel),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_3__k_c0c1c2_sel         (user_tx_clk2_c0c1c2_sel),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_2__k_c0c1c2_sel         (user_tx_clk1_c0c1c2_sel),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_0__k_c0c1c2_sel         (user_rx_clk1_c0c1c2_sel),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_1__k_c0c1c2_sel         (user_rx_clk2_c0c1c2_sel),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_3__i_ux                 (ux_tx_user2_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_3__o_usr_clk            (ss_user_tx_clk2_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_3__i_c2                 (i_syspll_c2_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_3__i_c0                 (i_syspll_c0_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_3__i_c1                 (i_syspll_c1_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_2__i_ux                 (ux_tx_user1_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_2__o_usr_clk            (ss_user_tx_clk1_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_2__i_c2                 (i_syspll_c2_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_2__i_c0                 (i_syspll_c0_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_2__i_c1                 (i_syspll_c1_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_0__i_ux                 (ux_rx_user2_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_0__o_usr_clk            (ss_user_rx_clk2_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_0__i_c2                 (i_syspll_c2_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_0__i_c0                 (i_syspll_c0_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_0__i_c1                 (i_syspll_c1_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_1__i_ux                 (ux_rx_user1_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_1__o_usr_clk            (ss_user_rx_clk1_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_1__i_c2                 (i_syspll_c2_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_1__i_c0                 (i_syspll_c0_clk),
        .x_dynMux_sm_hssi_pld_chnl_user_mux_1__i_c1                 (i_syspll_c1_clk)
    );
 */

// *************All Muxes taken oustide ********************** //


//***************************************************************************//
////***************** MAC  HAL ELEMENT ******************* ////
///// non-ubiquitous HAL BLock generates only if SF enable is high which is 
//    generated using channel_mode from QHIP IP from TCL //////
//***************************************************************************//

//  if (ch_mac_sf_en == "ENABLED") begin

if ((ch_tx_channel_mode == "ETH_MODE") || (ch_rx_channel_mode == "ETH_MODE")) begin

 ehip_hal_top_inst(
    .i_ehip_rx_rst_n                (ss_ehip_rx_rst_n),
    .i_ehip_tx_rst_n                (ss_ehip_tx_rst_n),
    .i_sfreeze_2_r03f_rx_mac_sfrz_n (ss_sfreeze_2_r03f_rx_mac_srfz_n),
    .i_eth_rx_clk                   (eth_rx_ch_clk),                                    //(i_syspll_c0_clk),                               //AG: Review with Reshmi As Per Kumaran Mapped
    .i_eth_tx_clk                   (eth_tx_ch_clk),                                    //(i_syspll_c0_clk),                               //AG: Review with Reshmi As Per Kumaran Mapped
    .i_eth_mac_tx_async             (ss_eth_mac_tx_async),
    .i_eth_mac_tx_direct            (ss_eth_mac_tx_direct),
    .o_eth_mac_rx_async             (ss_eth_mac_rx_async),
    .o_eth_mac_rx_direct            (ss_eth_mac_rx_direct),
    .i_mac_rx_data                  (mac_rx_data),
    .o_mac_tx_data                  (tx_eth_data),
    .o_mac_rx_data                  (mac_rx_data_deskew),                                           //Going to DESKEW
    .i_mac_tx_data                  (ch_pld_tx_deskewed_data),
    .i_tx_mac_valid                 (ch_tx_mac_valid),
    .o_tx_mac_ready                 (ch_tx_mac_ready),
    .o_rx_mac_inframe               (ch_rx_mac_inframe),
    .o_ch_lavmm_emac_rdata          (lavmm_emac_rdata),
    .o_ch_lavmm_emac_rdata_valid    (lavmm_emac_rdata_valid),
    .o_ch_lavmm_emac_waitreq        (lavmm_emac_waitreq),
    .i_ch_lavmm_emac_addr           (lavmm_emac_addr),
    .i_ch_lavmm_emac_be             (lavmm_emac_be),
    .i_ch_lavmm_emac_clk            (lavmm_emac_clk),
    .i_ch_lavmm_emac_read           (lavmm_emac_read),
    .i_ch_lavmm_emac_rstn           (lavmm_emac_rstn),
    .i_ch_lavmm_emac_wdata          (lavmm_emac_wdata),
    .i_ch_lavmm_emac_write          (lavmm_emac_write),
/*    .i_ch_lavmm_ptp_addr            (lavmm_ptp_addr),
    .i_ch_lavmm_ptp_be              (lavmm_ptp_be),
    .i_ch_lavmm_ptp_clk             (lavmm_ptp_clk),
    .i_ch_lavmm_ptp_read            (lavmm_ptp_read),
    .i_ch_lavmm_ptp_rstn            (lavmm_ptp_rstn),
    .i_ch_lavmm_ptp_wdata           (lavmm_ptp_wdata),
    .i_ch_lavmm_ptp_write           (lavmm_ptp_write),
    .o_ch_lavmm_ptp_rdata           (lavmm_ptp_rdata),
    .o_ch_lavmm_ptp_rdata_valid     (lavmm_ptp_rdata_valid),
    .o_ch_lavmm_ptp_waitreq         (lavmm_ptp_waitreq),
    .i_ptp_rst_n                    (ss_ptp_rst_n), */
    .i_ch_ptp_tx_deskewed_data      (ch_ptp_tx_deskewed_data),
    .o_ch_ptp_rx_data               (ch_ptp_rx_data),
    .o_ptp_rx_dsk_marker            (ptp_rx_dsk_marker),
    .o_ptp_mas_word_align           (ptp_mas_wm),
    .i_status_rx_pcs_fully_aligned  (ss_rstepcs_rx_pcs_fully_aligned),
    .i_t03f_sfreeze_1_tx_pcs_sfrz_n (ss_t03f_sfreeze_1_tx_pcs_sfrz_n),
    .i_ptp_cfg_intfc_tx_asm         (i_ptp_cfg_tx_asm_ch1_shared_ptp),
    .i_ptp_cfg_intfc_tx_p2p         (i_ptp_cfg_tx_p2p_ch1_shared_ptp),
    .i_ptp_rx_intfc_ptp_data        (i_ingress1_ptp_rx_intfc_ptp_data_shared_ptp),
    .i_ptp0_data                    (i_sm_pld_tx_demux_0_i_eth_shared_ptp[8:0]),
    .i_ptp_tx_data                  (i_egress1_ptp_tx_data_shared_ptp),
    .i_ptp_tx_data_ld               (i_egress1_ptp_tx_data_ld_shared_ptp),
    .i_ptp_mas_word_align           (i_ch1_ptp_mas_word_align_shared_ptp),
    .i_ptp_tx_wa_ld                 (i_egress1_ptp_tx_wa_ld_shared_ptp),
    .i_ch_pld_ptp_wa_deskew_bypass  (i_sm_pld_tx_demux_0_i_eth_shared_ptp[39]),
    .i_ptp_rx_dsk_marker            (i_ingress1_ptp_rx_dsk_marker_shared_ptp),
    .i_ptps_ptpi_link               (i_ptp_ptpi_link_shared_ptp),
    .o_ptp_rx_data                  (o_ptp_rx_data_shared_ptp),
    .o_ptp_tx_data_ld               (o_ptp_tx_data_ld_shared_ptp),
    .o_ptp_tx_intfc_ptp_data        (o_ptp_tx_intfc_ptp_data_shared_ptp),
    .o_ptp_tx_wa_ld                 (o_ptp_tx_wa_ld_shared_ptp),
    .i_ptp_tx_data_a_mux_0          ({i_sm_pld_tx_demux_0_i_eth_shared_ptp[39],i_sm_pld_tx_demux_0_i_eth_shared_ptp[38],i_sm_pld_tx_demux_0_i_eth_shared_ptp[8:0]}),
    .i_ptp_tx_data_b_mux_0          ({i_sm_pld_tx_demux_0_i_eth_shared_ptp[39],i_sm_pld_tx_demux_0_i_eth_shared_ptp[38],i_sm_pld_tx_demux_0_i_eth_shared_ptp[17:9]}),
    .i_ptp_tx_data_a_mux_1          ({i_sm_pld_tx_demux_0_i_eth_shared_ptp[39],i_sm_pld_tx_demux_0_i_eth_shared_ptp[38],i_sm_pld_tx_demux_0_i_eth_shared_ptp[8:0]}),
    .i_ptp_tx_data_b_mux_1          ({i_sm_pld_tx_demux_0_i_eth_shared_ptp[39],i_sm_pld_tx_demux_0_i_eth_shared_ptp[38],i_sm_pld_tx_demux_0_i_eth_shared_ptp[17:9]}),
    .o_ptp_tx_data_mux_0            (ptp_tx_data_mux_0),
    .o_ptp_tx_data_mux_1            (),
    .i_ptp_rx_data_a_mux_1          (ch_ptp_rx_data_mux),
    .i_ptp_rx_data_b_mux_1          (),
    .o_ptp_rx_data_mux_0            (o_ptp_rx_data_mux_0_shared_ptp),
    .o_ptp_rx_data_mux_1            (o_ptp_rx_data_mux_1_shared_ptp),
    .i_bot_clk                      (),
    .i_middle_clk                   (i_syspll_c0_clk),
    .i_top_clk                      (),
    .o_ptp_clk                      (o_ptp_clk_shared_ptp)
    
);
end
else begin
    assign lavmm_emac_waitreq = 1'b1;
    assign lavmm_emac_rdata_valid = 1'b0; 
    assign lavmm_emac_rdata = 32'd0;
end 


//***************************************************************************//
////***************** PCS  HAL ELEMENT ******************* ////
//***************************************************************************//
//  if (ch_pcs_sf_en == "ENABLED") begin   /// Superset includes ubiquitous HAL blocks. Hence removing the dependency of SF enable
//if ((ch_tx_channel_mode == "ETH_MODE") || (ch_rx_channel_mode == "ETH_MODE") || (ch_tx_channel_mode == "PCSD") || (ch_rx_channel_mode == "PCSD") || (ch_tx_channel_mode == "PCSD+FEC") || (ch_rx_channel_mode == "PCSD+FEC")) begin

alt_mge_phy_0_one_lane_hal_pcs_hal_2100_msmb2ci pcs_hal_top_inst(
    .o_ch_lavmm_epcs_rdata             (lavmm_epcs_rdata      ),
    .o_ch_lavmm_epcs_rdata_valid       (lavmm_epcs_rdata_valid),
    .o_ch_lavmm_epcs_waitreq           (lavmm_epcs_waitreq    ),
    .i_ch_lavmm_epcs_addr              (lavmm_epcs_addr ),
    .i_ch_lavmm_epcs_be                (lavmm_epcs_be   ),
    .i_ch_lavmm_epcs_clk               (lavmm_epcs_clk  ),
    .i_ch_lavmm_epcs_read              (lavmm_epcs_read ),
    .i_ch_lavmm_epcs_rstn              (lavmm_epcs_rstn ),
    .i_ch_lavmm_epcs_wdata             (lavmm_epcs_wdata),
    .i_ch_lavmm_epcs_write             (lavmm_epcs_write),
    .i_pcs_tx_clk                      (eth_tx_ch_clk),                         //(i_syspll_c0_clk),                       //AG: Review with Reshmi As Per Kumaran Mapped
    .i_pcs_rx_clk                      (eth_rx_ch_clk),                         //(i_syspll_c0_clk),                       //AG: Review with Reshmi As Per Kumaran Mapped
    .i_hssi_async_dir_eth_pcs_tx_async (ss_eth_pcs_tx_async),
    .i_hssi_async_dir_eth_pcs_tx_direct(ss_eth_pcs_tx_direct),
    .o_hssi_async_dir_eth_pcs_rx_async (ss_eth_pcs_rx_async),
    .o_hssi_async_dir_eth_pcs_rx_direct(ss_eth_pcs_rx_direct),
    .i_ehip_rx_rst_n                   (ss_ehip_rx_rst_n),
    .i_ehip_tx_rst_n                   (ss_ehip_tx_rst_n),
    .o_rstepcs_rx_pcs_fully_aligned    (ss_rstepcs_rx_pcs_fully_aligned),
    .i_ehip_signal_ok                  (ehip_signal_ok),
    .i_t03f_sfreeze_1_tx_pcs_sfrz_n    (ss_t03f_sfreeze_1_tx_pcs_sfrz_n),
    .o_tx_mux_sel                      (tx_mux_sel),
    .o_rx_mux_sel                      (rx_mux_sel),
    .i_pcs_tx_data_mux                 (pcs_tx_mux_data), 
    .o_pcs_tx_data                     (pcs_tx_data),
    .o_pcs_rx_mii_data                 (mac_rx_data),
    .o_pcs_rx_data                     (pcs_rx_data_deskew),                                            //Going to DESKEW
    .i_pcs_rx_data_mux                 (pcs_rx_mux_data),
    .i_sfreeze_2_r03f_rx_pcs_sfrz_n    (ss_sfreeze_2_r03f_rx_mac_srfz_n)                                    //where to connect
    /* .i_sel_tx_eth                      (tx_eth_data),
    .i_sel_tx_deskew                   (ch_pld_tx_deskewed_data),
    .i_sel_xcvr                        (xcvr_rx_data),
    .i_sel_fec                         (fec_rx_data) */
    
);
//end


// *************All Muxes taken outside ********************** //

    tennm_sm_pcs_tx_mux_module x_dynMux_sm_pcs_tx_mux_0 (
        .i_tx_deskew          (ch_pld_tx_deskewed_data),
        .i_tx_eth             (tx_eth_data),
        .i_tx_mux             (tx_mux_sel),
        .o_pcs_tx             (pcs_tx_mux_data)
    );

    tennm_sm_pcs_rx_mux_module x_dynMux_sm_pcs_rx_mux_0 (
        .i_rx_mux             (rx_mux_sel),
        .i_fec                (fec_rx_data),
        .i_xcvr               (xcvr_rx_data),
        .o_pcs_rx             (pcs_rx_mux_data)
    );

/*     ch4_pcs_dynmux ch4_pcs_dynmux_inst(
        .x_dynMux_sm_pcs_tx_mux_0__i_sel_tx_eth         (tx_eth_data),
        .x_dynMux_sm_pcs_tx_mux_0__o_pcs_tx             (pcs_tx_mux_data),
        .x_dynMux_sm_pcs_tx_mux_0__i_sel_tx_deskew      (ch_pld_tx_deskewed_data),
        .x_dynMux_sm_pcs_rx_mux_0__i_sel_xcvr           (xcvr_rx_data),
        .x_dynMux_sm_pcs_rx_mux_0__o_pcs_rx             (pcs_rx_mux_data),
        .x_dynMux_sm_pcs_rx_mux_0__i_sel_fec            (fec_rx_data),
        .x_dynMux_sm_pcs_tx_mux_0__i_tx_mux_sel         (tx_mux_sel),
        .x_dynMux_sm_pcs_rx_mux_0__i_rx_mux_sel         (rx_mux_sel)
    ); */
// *************All Muxes taken outside ********************** //


//***************************************************************************//
////***************** FEC  HAL ELEMENT ******************* ////
//***************************************************************************//
///  if (ch_fec_sf_en == "ENABLED") begin    /// Superset includes ubiquitous HAL blocks. Hence removing the dependency of SF enable.

//if ((ch_tx_channel_mode == "ETH_MODE") || (ch_rx_channel_mode == "ETH_MODE") || (ch_tx_channel_mode == "PCSD") || (ch_rx_channel_mode == "PCSD") || (ch_tx_channel_mode == "PCSD+FEC") || (ch_rx_channel_mode == "PCSD+FEC") || (ch_tx_channel_mode == "FECD") || (ch_rx_channel_mode == "FECD")) begin

alt_mge_phy_0_one_lane_hal_fec_hal_2100_gsknnly fec_hal_top_inst(
    .i_ch_lavmm_fec_addr        (lavmm_fec_addr),
    .i_ch_lavmm_fec_be          (lavmm_fec_be),
    .i_ch_lavmm_fec_clk         (lavmm_fec_clk),
    .i_ch_lavmm_fec_read        (lavmm_fec_read),
    .i_ch_lavmm_fec_rstn        (lavmm_fec_rstn),
    .i_ch_lavmm_fec_wdata       (lavmm_fec_wdata),
    .i_ch_lavmm_fec_write       (lavmm_fec_write),
    .o_ch_lavmm_fec_rdata       (lavmm_fec_rdata),
    .o_ch_lavmm_fec_rdata_valid (lavmm_fec_rdata_valid),
    .o_ch_lavmm_fec_waitreq     (lavmm_fec_waitreq),
    .i_ch_eth_fec_tx_async      (ss_eth_fec_tx_async),
    .i_ch_eth_fec_tx_direct     (ss_eth_fec_tx_direct),
    .o_ch_eth_fec_rx_async      (ss_eth_fec_rx_async),
    .o_ch_eth_fec_rx_direct     (ss_eth_fec_rx_direct),
    .i_rstfec_fec_csr_ret       (ss_rstfec_fec_csr_ret ),
    .o_fec_rx_rdy_n             (ss_rstfec_fec_rx_rdy_n),
    .i_rstfec_rx_fec_sfrz_n     (ss_rstfec_rx_fec_sfrz_n),
    .i_rstfec_fec_rx_rst_n      (ss_rstfec_fec_rx_rst_n ),
    .i_rstfec_tx_fec_sfrz_n     (ss_rstfec_tx_fec_sfrz_n),
    .i_rstfec_fec_tx_rst_n      (ss_rstfec_fec_tx_rst_n ),
    .o_fec_tx_data_mux_sel      (fec_tx_data_mux_sel),
    .i_fec_i_tx_mux_data        (fec_i_tx_mux_data),
    .o_fec_rx_data              (fec_rx_data),
    .i_fec_clk                  (i_syspll_c0_clk),
    .i_xcvr_rx_data             (xcvr_rx_data),                         //need to check one more time
    .o_xcvr_tx_data             (xcvr_tx_data),
    .i_pma_rx_sf                (pma_rx_sf),
    
    .o_ch_lavmm_fec_addr_fec_wrap           (o_ch_lavmm_fec_addr_fec_wrap       ),
    .o_ch_lavmm_fec_be_fec_wrap             (o_ch_lavmm_fec_be_fec_wrap         ),
    .o_ch_lavmm_fec_clk_fec_wrap            (o_ch_lavmm_fec_clk_fec_wrap        ),
    .o_ch_lavmm_fec_read_fec_wrap           (o_ch_lavmm_fec_read_fec_wrap       ),
    .o_ch_lavmm_fec_rstn_fec_wrap           (o_ch_lavmm_fec_rstn_fec_wrap       ),
    .o_ch_lavmm_fec_wdata_fec_wrap          (o_ch_lavmm_fec_wdata_fec_wrap      ),
    .o_ch_lavmm_fec_write_fec_wrap          (o_ch_lavmm_fec_write_fec_wrap      ),
    .i_ch_lavmm_fec_rdata_fec_wrap          (i_ch_lavmm_fec_rdata_fec_wrap      ),
    .i_ch_lavmm_fec_rdata_valid_fec_wrap    (i_ch_lavmm_fec_rdata_valid_fec_wrap),
    .i_ch_lavmm_fec_waitreq_fec_wrap        (i_ch_lavmm_fec_waitreq_fec_wrap    ),
    .i_ch_eth_fec_rx_async_fec_wrap         (i_ch_eth_fec_rx_async_fec_wrap     ),
    .i_ch_eth_fec_rx_direct_fec_wrap        (i_ch_eth_fec_rx_direct_fec_wrap    ),
    .o_ch_eth_fec_tx_async_fec_wrap         (o_ch_eth_fec_tx_async_fec_wrap     ),
    .o_ch_eth_fec_tx_direct_fec_wrap        (o_ch_eth_fec_tx_direct_fec_wrap    ),
    .o_rstfec_fec_csr_ret_fec_wrap          (o_rstfec_fec_csr_ret_fec_wrap      ),
    .i_fec_rx_rdy_n_fec_wrap                (i_fec_rx_rdy_n_fec_wrap            ),
    .o_rstfec_fec_rx_rst_n_fec_wrap         (o_rstfec_fec_rx_rst_n_fec_wrap     ),
    .o_rstfec_fec_tx_rst_n_fec_wrap         (o_rstfec_fec_tx_rst_n_fec_wrap     ),
    .o_rstfec_rx_fec_sfrz_n_fec_wrap        (o_rstfec_rx_fec_sfrz_n_fec_wrap    ),
    .o_rstfec_tx_fec_sfrz_n_fec_wrap        (o_rstfec_tx_fec_sfrz_n_fec_wrap    ),
    .i_fec_tx_data_mux_sel_fec_wrap         (i_fec_tx_data_mux_sel_fec_wrap     ),
    .i_fec_rx_data_fec_wrap                 (i_fec_rx_data_fec_wrap             ),
    .o_fec_i_tx_mux_data_fec_wrap           (o_fec_i_tx_mux_data_fec_wrap       ),
    .o_xcvr_rx_data                         (o_xcvr_rx_data                     ),
    .i_xcvr_tx_data                         (i_xcvr_tx_data                     ),
    .o_pma_rx_sf                            (o_pma_rx_sf                        )
    /* .i_sel_ethpcs                            (pcs_tx_data),
    .i_sel_deskew                            (ch_pld_tx_deskewed_data) */
);
//end


// *************All Muxes taken outside ********************** //   
  
    tennm_sm_hssi_fec_tx_mux_module x_dynMux_sm_hssi_fec_tx_mux_0 (
        .i_deskew             (ch_pld_tx_deskewed_data),
        .i_ethpcs             (pcs_tx_data),
        .k_sel                (fec_tx_data_mux_sel),
        .o_ch_tx_data         (fec_i_tx_mux_data)
    );

   /*  ch4_fec_dynmux ch4_fec_dynmux_inst(
        .x_dynMux_sm_hssi_fec_tx_mux_0__i_sel_ethpcs        (pcs_tx_data),
        .x_dynMux_sm_hssi_fec_tx_mux_0__o_ch_tx_data        (fec_i_tx_mux_data),
        .x_dynMux_sm_hssi_fec_tx_mux_0__i_sel_deskew        (ch_pld_tx_deskewed_data),
        .x_dynMux_sm_hssi_fec_tx_mux_0__k_sel               (fec_tx_data_mux_sel)
    ); */



//***************************************************************************//
////***************** PHY  HAL ELEMENT ******************* ////
//***************************************************************************//
////  if (ch_SF_XCVRIF_1CH_EN == "ENABLED") begin   /// Superset includes ubiquitous HAL blocks. Hence removing the dependency of SF enable.

//if ((ch_tx_channel_mode == "ETH_MODE") || (ch_rx_channel_mode == "ETH_MODE") || (ch_tx_channel_mode == "PCSD") || (ch_rx_channel_mode == "PCSD") || (ch_tx_channel_mode == "PCSD+FEC") || (ch_rx_channel_mode == "PCSD+FEC") || (ch_tx_channel_mode == "FECD") || (ch_rx_channel_mode == "FECD") || (ch_tx_channel_mode == "PMAD") || (ch_rx_channel_mode == "PMAD")) begin

        assign ux_chnl_refclk_mux = i_refclk_rx_p;
alt_mge_phy_0_one_lane_hal_phy_hal_2100_hfv7ity phy_hal_top_inst(
    .oflux_xoa_tx_n_l0_ux               (tx_serial_n),
    .oflux_xoa_tx_p_l0_ux               (tx_serial_p),
    .iflux_xia_rx_n_l0_ux               (rx_serial_n),
    .iflux_xia_rx_p_l0_ux               (rx_serial_p),
    .i_ss_async_pldif                   (ss_uxquad_async),
    .o_ss_async_pldif                   (ss_uxquad_async_i),
    .i_ss_async_pldif_pcie_mux          (ss_uxquad_async_pcie_mux),
    .i_lavmm_addr                       (lavmm_ux_addr),
    .i_lavmm_be                         (lavmm_ux_be),
    .i_lavmm_clk                        (lavmm_ux_clk),
    .i_lavmm_read                       (lavmm_ux_read),
    .i_lavmm_rstn                       (lavmm_ux_rstn),
    .i_lavmm_wdata                      (lavmm_ux_wdata),
    .i_lavmm_write                      (lavmm_ux_write),
    .o_lavmm_rdata                      (lavmm_ux_rdata),
    .o_lavmm_rdata_valid                (lavmm_ux_rdata_valid),
    .o_lavmm_waitreq                    (lavmm_ux_waitreq),
    .i_ft_rx_sclk_sync_ch               (ss_det_lat_rx_sclk_sync),
    .i_ft_tx_sclk_sync_ch               (ss_det_lat_tx_sclk_sync),
    .o_ft_rx_async_pulse_ch             (ss_det_lat_rx_async_pulse),
    .o_ft_tx_async_pulse_ch             (ss_det_lat_tx_async_pulse),
    .o_rxcdrlock2dataa                  (ss_rst_ux_rxcdrlock2data),
    .i_rst_ux_rx_sfrz                   (ss_rst_ux_rx_sfrz            ),
    .o_rst_flux0_cpi_cmn_busy           (ss_rst_flux0_cpi_cmn_busy    ),
    .o_rst_oflux_rx_srds_rdy            (ss_rst_oflux_rx_srds_rdy     ),
    .o_rst_ux_all_synthlockstatus       (ss_rst_ux_all_synthlockstatus),
    .o_rst_ux_rxcdrlockstatus           (ss_rst_ux_rxcdrlockstatus),
    .o_ux_tx_ch_ptr_smpl                (ux_tx_ch_ptr_smpl),            //In r11 this port is not available, Raised to Sujoy
    .i_ick_sclk_tx                      (ss_det_lat_tx_sclk_clk),
    .i_ick_sclk_rx                      (ss_det_lat_rx_sclk_clk),
    .i_rst_pld_ux_tx_pma_rst_n          (ss_rst_ux_tx_pma_rst_n),
    .i_rst_pld_ux_rx_pma_rst_n          (ss_rst_ux_rx_pma_rst_n),
    .o_ch_lavmm_xcvrif_rdata            (lavmm_xcvrif_rdata),
    .o_ch_lavmm_xcvrif_rdata_valid      (lavmm_xcvrif_rdata_valid),
    .o_ch_lavmm_xcvrif_waitreq          (lavmm_xcvrif_waitreq),
    .i_ch_lavmm_xcvrif_addr             (lavmm_xcvrif_addr),
    .i_ch_lavmm_xcvrif_be               (lavmm_xcvrif_be),
    .i_ch_lavmm_xcvrif_clk              (lavmm_xcvrif_clk),
    .i_ch_lavmm_xcvrif_read             (lavmm_xcvrif_read),
    .i_ch_lavmm_xcvrif_rstn             (lavmm_xcvrif_rstn),
    .i_ch_lavmm_xcvrif_wdata            (lavmm_xcvrif_wdata),
    .i_ch_lavmm_xcvrif_write            (lavmm_xcvrif_write),
//    .i_pld_rx_lat_sclk_ch               (ss_det_lat_rx_sclk_clk    ),     //In r11 Removed
//    .i_pld_tx_lat_sclk_ch               (ss_det_lat_tx_sclk_clk    ),     //In r11 Removed
    .o_rx_latency_pulse                 (ss_xcvrif_rx_latency_pulse),
    .o_tx_latency_pulse                 (ss_xcvrif_tx_latency_pulse),
    .i_xcvrif_tx_mux_data               (xcvrif_tx_mux_data ),
    .o_rx_data                          (xcvr_rx_data ),
    .o_tx_source_sel                    (tx_source_sel ),
    .i_ch_eth_xcvrif_tx_async           (ss_eth_xcvrif_tx_async ),
    .i_ch_eth_xcvrif_tx_direct          (ss_eth_xcvrif_tx_direct),
    .o_ch_eth_xcvrif_rx_async           (ss_eth_xcvrif_rx_async),
    .o_ch_eth_xcvrif_rx_direct          (ss_eth_xcvrif_rx_direct),
    .i_rstxcvrif_xcvrif_signal_ok       (ss_rstxcvrif_xcvrif_signal_ok),
    .i_rstxcvrif_rx_xcvrif_sfrz_n       (ss_rstxcvrif_rx_xcvrif_sfrz_n),
    .i_rstxcvrif_xcvrif_rx_rst_n        (ss_rstxcvrif_xcvrif_rx_rst_n ),
    .i_rstxcvrif_tx_xcvrif_sfrz_n       (ss_rstxcvrif_tx_xcvrif_sfrz_n),
    .i_rstxcvrif_xcvrif_tx_rst_n        (ss_rstxcvrif_xcvrif_tx_rst_n),     //(ss_rstxcvrif_xcvrif_tx_rst_n_mux),
    .o_pma_rx_sf                        (pma_rx_sf),
    .o_rx_fifo_en_sel                   (rx_fifo_en_sel),
    .o_tx_rst_source_sel                (tx_rst_source_sel),
    .i_ch_xcvrif_rx_fifo_rd_en          (ch_xcvrif_rx_fifo_rd_en),
    .o_ch_xcvrif_rx_fifo_rd_en          (ch_xcvrif_rx_fifo_rd_en_mux),
    .i_ch_xcvrif_tx_fifo_rd_en          (ch_xcvrif_tx_fifo_rd_en),
    .o_ch_xcvrif_tx_fifo_rd_en          (ch_xcvrif_tx_fifo_rd_en_mux),
//    .i_xcvr_rx_ch_clk                   (xcvr_rx_ch_clk),             //In r11 Removed
//    .i_xcvr_tx_ch_clk                   (xcvr_tx_ch_clk),             //In r11 Removed
    .o_ux_rxuser1_sel                   (ux_rxuser1_sel),
    .o_ux_rxuser2_sel                   (ux_rxuser2_sel),
    .o_ux_txuser1_sel                   (ux_txuser1_sel),
    .o_ux_txuser2_sel                   (ux_txuser2_sel),
    .o_pcs_rxpostdiv                    (pcs_rxpostdiv),
    .o_pcs_rxword                       (pcs_rxword),
    .o_ux_txlc_clk                      (ux_txlc_clk),    ///Review with Choonyip
    .o_ock_pcs_txword                   (ock_pcs_txword),
    .o_tx_xcvr_wordclk_sel              (tx_xcvr_wordclk_sel),
    .o_rx_xcvr_wordclk_sel              (rx_xcvr_wordclk_sel),  //In r11 this port is not available, Raised to Sujoy
    .o_eth_rx_ch_clk                    (eth_rx_ch_clk),
    .i_eth_rx_ch_clk                    (i_syspll_c0_clk),
//    .i_eth_tx_ch_clk                    (eth_tx_ch_clk),          //In r11 this port is not available, Raised to Sujoy
    .uxwrap_bus_in                      (i_uxwrap_bus_in_phy_shared                 ),
    .uxwrap_bus_out                     (o_uxwrap_bus_out_phy_shared                ),
    .o_lavmm_addr                       (o_lavmm_addr_phy_shared                    ),
    .o_lavmm_be                         (o_lavmm_be_phy_shared                      ),
    .o_lavmm_clk                        (o_lavmm_clk_phy_shared                     ),
    .o_lavmm_read                       (o_lavmm_read_phy_shared                    ),
    .o_lavmm_rstn                       (o_lavmm_rstn_phy_shared                    ),
    .o_lavmm_wdata                      (o_lavmm_wdata_phy_shared                   ),
    .o_lavmm_write                      (o_lavmm_write_phy_shared                   ),
    .i_lavmm_rdata                      (i_lavmm_rdata_phy_shared                   ),
    .i_lavmm_rdata_valid                (i_lavmm_rdata_valid_phy_shared             ),
    .i_lavmm_waitreq                    (i_lavmm_waitreq_phy_shared                 ),
    .o_sclk_return_sel_rx               (o_sclk_return_sel_rx_phy_shared            ),
    .o_sclk_return_sel_tx               (o_sclk_return_sel_tx_phy_shared            ),
    .o_ick_sclk_rx                      (o_ick_sclk_rx_phy_shared                   ),
    .i_sync_common_control              (i_sync_common_control_phy_shared           ),
    .o_ft_rx_sclk_sync_ch               (o_ft_rx_sclk_sync_ch_phy_shared            ),
    .o_ft_tx_sclk_sync_ch               (o_ft_tx_sclk_sync_ch_phy_shared            ),
    .o_rst_ux_rx_pma_rst_n              (o_rst_ux_rx_pma_rst_n_phy_shared           ),
    .o_rst_ux_tx_pma_rst_n              (o_rst_ux_tx_pma_rst_n_phy_shared           ),
    .o_ick_pcs_txword                   (o_ick_pcs_txword_phy_shared                ),
    .o_tx_dl_ch_bit                     (o_tx_dl_ch_bit_phy_shared                  ),
    .i_dat_pcs_measlatbit               (i_dat_pcs_measlatbit_phy_shared            ),
    .i_ft_rx_async_pulse_ch             (i_ft_rx_async_pulse_ch_phy_shared          ),
    .i_ft_tx_async_pulse_ch             (i_ft_tx_async_pulse_ch_phy_shared          ),
    .i_rx_dl_ch_bit                     (i_rx_dl_ch_bit_phy_shared                  ),
    .i_ux_rxuser1_sel                   (i_ux_rxuser1_sel_phy_shared                ),
    .i_ux_rxuser2_sel                   (i_ux_rxuser2_sel_phy_shared                ),
    .i_ux_txuser1_sel                   (i_ux_txuser1_sel_phy_shared                ),
    .i_ux_txuser2_sel                   (i_ux_txuser2_sel_phy_shared                ),
    .o_octl_pcs_txstatus_a              (o_octl_pcs_txstatus_a_phy_shared           ),
    .i_ictl_pcs_txenable_a              (i_ictl_pcs_txenable_a_phy_shared           ),
    .i_sync_cfg_data                    (i_sync_cfg_data_phy_shared                 ),
    .i_sync_interface_control           (i_sync_interface_control_phy_shared        ),
    .o_tx_data                          (o_tx_data_phy_shared                       ),
    .i_rx_data                          (i_rx_data_phy_shared                       ),
    .o_sm_flux_ingress                  (o_sm_flux_ingress_phy_shared               ),
    .i_sm_flux_egress                   (i_sm_flux_egress_phy_shared                ),
    .i_flux_cpi_int                     (i_flux_cpi_int_phy_shared                  ),
    .i_flux_int                         (i_flux_int_phy_shared                      ),
    .i_oflux_octl_pcs_txptr_smpl_lane   (i_oflux_octl_pcs_txptr_smpl_lane_phy_shared),
    .o_ick_sclk_tx                      (o_ick_sclk_tx_phy_shared                   ),
    .i_flux_srds_rdy                    (i_flux_srds_rdy_phy_shared                 ),
    .i_pcs_rxword                       (i_pcs_rxword_phy_shared                    ),
    .i_pcs_rxpostdiv                    (i_pcs_rxpostdiv_phy_shared                 ),
    .i_ock_pcs_txword                   (i_ock_pcs_txword_phy_shared                ),
    .o_dat_pcs_measlatrndtripbit        (o_dat_pcs_measlatrndtripbit_phy_shared     ),
//    .i_dpma_refclk                      (),                                               //AG:Connected this from cnoc atom in phy_hal_coreip.sv
    .o_ock_pcs_cdrfbclk                 (),                                                 //Input to sm_flux_ref_clk_mux. As of we dont no the use case so not connected
    .o_ock_pcs_ref                      (),                                                 //Input to sm_flux_ref_clk_mux. As of we dont no the use case so not connected
    .o_pcie_pcs                         (),                                                 //PCIE PCS
    .i_pcie_pcs                         (),                                                 //PCIE PCS
    .o_pcie_rxword_clk                  (),                                                 //PCIE PCS                                                  
    .o_pcie_txword_clk                  (),                                                 //PCIE PCS                                                  
//    .i_sel_txword_clk                   (xcvr_tx_ch_clk),                                 //In r11 this port is not available, Raised to Sujoy                                               
    .i_sel_rxword_clk                   (xcvr_rx_ch_clk),                                                   
    .i_xcvr_txword_clk                  (xcvr_tx_ch_clk),                                                   
    .o_eth_rxword_clk                   (eth_rxword_clk),                                                   
    .o_eth_txword_clk                   (eth_txword_clk),                                                    
    .o_eth_tx_ch_clk                    (eth_tx_ch_clk),                                                   
//    .ioack_ref_left_n_ux_bidir_in       ({5'bZ, i_refclk_tx_n}),                                          
    .ioack_ref_left_p_ux_bidir_in       ({5'bZ, i_refclk_tx_p}),                  
//    .ioack_hsref_left_n_ux_bidir_in     (i_refclk_rx_n),                                                   
    .ioack_hsref_left_p_ux_bidir_in     (i_refclk_rx_p),                                                   
    .ioack_cdrdiv_left_ux_bidir_in      (ioack_cdrdiv_left_ux_bidir_in     ),                                                   
    .ioack_synthdiv1_left_ux_bidir_in   (ioack_synthdiv1_left_ux_bidir_in  ),                                                   
    .ioack_synthdiv2_left_ux_bidir_in   (ioack_synthdiv2_left_ux_bidir_in  ),                                                   
    .ioack_cdrdiv_left_ux_bidir_out     (ioack_cdrdiv_left_ux_bidir_out   ),                                                   
    .ioack_synthdiv1_left_ux_bidir_out  (ioack_synthdiv1_left_ux_bidir_out),                                                   
    .ioack_synthdiv2_left_ux_bidir_out  (ioack_synthdiv2_left_ux_bidir_out),                                                   
    .o_rxstatusa                        (rxstatusa),                                                   
    .o_txstatusa                        (txstatusa),
    .i_quartus_flux_s_to_ingress        (i_flux_clk),
    .i_rstxcvrif_xcvrif_tx_rd_rst_n     (ss_rstxcvrif_xcvrif_tx_rst_n_mux),
    .i_rstxcvrif_xcvrif_tx_wr_rst_n     (ss_rstxcvrif_xcvrif_tx_rst_wr_sync_n_mux),
    .o_tx_rst_rd_sync_rst_n             (tx_rst_rd_sync_rst_n),
    .o_tx_rst_wr_sync_rst_n             (tx_rst_wr_sync_rst_n)
); 

//end

// *************All Muxes taken outside ********************** //

    tennm_sm_xcvrif_tx_mux_module x_dynMux_sm_xcvrif_tx_mux_0( 
        .i_deskew                   (ch_pld_tx_deskewed_data),
        .i_ethpcs                   (pcs_tx_data),
        .i_fec                      (xcvr_tx_data),
        .k_sel                      (tx_source_sel),
        .o_xcvrif_tx_mux_data       (xcvrif_tx_mux_data)
    );
 
/*     tennm_sm_xcvrif_rx_fifo_rd_en_mux_module x_dynMux_sm_xcvrif_rx_fifo_rd_en_mux_0 (
        .i_ground_en                (),
        .i_sel_ch0                  (ch_xcvrif_rx_fifo_rd_en_mux),
        .i_sel_ch0_top              (i_ch0_top_xcvrif_rx_fifo_rd_en),
        .i_sel_ch1                  (i_ch1_xcvrif_rx_fifo_rd_en),
        .i_sel_ch2                  (i_ch2_xcvrif_rx_fifo_rd_en),
        .i_sel_ch3                  (i_ch3_xcvrif_rx_fifo_rd_en),
        .k_sel                      (rx_fifo_en_sel),
        .o_ch_xcvrif_rx_fifo_rd_en  (ch_xcvrif_rx_fifo_rd_en)
    ); */

    tennm_sm_xcvrif_rx_fifo_rd_en_mux_module x_dynMux_sm_xcvrif_rx_fifo_rd_en_mux_0 (
        .i_x1                       (ch_xcvrif_rx_fifo_rd_en_mux),
        .i_x2                       (),
        .i_x4                       (),
        .i_x6_bot                   (),
        .i_x6_top                   (),
        .i_x8_bot                   (),
        .i_x8_top                   (),
        .k_sel                      (rx_fifo_en_sel),
        .o_ch_xcvrif_rx_fifo_rd_en  (ch_xcvrif_rx_fifo_rd_en)
    );

//    assign o_xcvrif_rx_fifo_rd_en_mux_x1 = ch_xcvrif_rx_fifo_rd_en_mux;

/*     tennm_sm_xcvrif_tx_fifo_rd_en_mux_module x_dynMux_sm_xcvrif_tx_fifo_rd_en_mux_0 (
        .i_ground_en                (),
        .i_sel_ch0                  (ch_xcvrif_tx_fifo_rd_en_mux),
        .i_sel_ch0_top              (i_ch0_top_xcvrif_tx_fifo_rd_en),
        .i_sel_ch1                  (i_ch1_xcvrif_tx_fifo_rd_en),
        .i_sel_ch2                  (i_ch2_xcvrif_tx_fifo_rd_en),
        .i_sel_ch3                  (i_ch3_xcvrif_tx_fifo_rd_en),
        .k_sel                      (tx_rst_source_sel),
        .o_ch_xcvrif_tx_fifo_rd_en  (ch_xcvrif_tx_fifo_rd_en)
    ); */

    tennm_sm_xcvrif_tx_fifo_rd_en_mux_module x_dynMux_sm_xcvrif_tx_fifo_rd_en_mux_0 (
        .i_x1                       (ch_xcvrif_tx_fifo_rd_en_mux),
        .i_x2                       (i_xcvrif_tx_fifo_rd_en_mux_x2),
        .i_x4                       (i_xcvrif_tx_fifo_rd_en_mux_x4),
        .i_x6_bot                   (i_xcvrif_tx_fifo_rd_en_mux_x6_bot),
        .i_x6_top                   (i_xcvrif_tx_fifo_rd_en_mux_x6_top),
        .i_x8_bot                   (i_xcvrif_tx_fifo_rd_en_mux_x8_bot),
        .i_x8_top                   (i_xcvrif_tx_fifo_rd_en_mux_x8_top),
        .k_sel                      (tx_rst_source_sel),
        .o_ch_xcvrif_tx_fifo_rd_en  (ch_xcvrif_tx_fifo_rd_en)
    );

    assign o_xcvrif_tx_fifo_rd_en_mux_x1 = ch_xcvrif_tx_fifo_rd_en_mux;
    
    tennm_sm_xcvrif_rx_word_clk_mux_module x_dynMux_sm_xcvrif_rx_word_clk_mux_0 (
        .i_ground_clk               (),
        .i_rxword_clk               (eth_rxword_clk),                      
        .i_txword_clk               (xcvr_tx_ch_clk),
        .k_sel                      (rx_xcvr_wordclk_sel),
        .o_xcvr_rxword_ch_clk       (xcvr_rx_ch_clk)
    );
    
/*     tennm_sm_xcvrif_tx_word_clk_mux_module x_dynMux_sm_xcvrif_tx_word_clk_mux_0 (
        .i_ground_clk               (),
        .i_sel_ux0                  (eth_txword_clk),
        .i_sel_ux0_top              (i_ux0_top_xcvrif_tx_word_clk),
        .i_sel_ux1                  (i_ux1_xcvrif_tx_word_clk),
        .i_sel_ux2                  (i_ux2_xcvrif_tx_word_clk),
        .i_sel_ux3                  (i_ux3_xcvrif_tx_word_clk),
        .k_sel                      (tx_xcvr_wordclk_sel),
        .o_xcvr_txword_ch_clk       (xcvr_tx_ch_clk)
    ); */

    tennm_sm_xcvrif_tx_word_clk_mux_module x_dynMux_sm_xcvrif_tx_word_clk_mux_0 (
        .i_ground_clk               (),
        .i_x1                       (eth_txword_clk),
        .i_x2                       (i_xcvrif_tx_word_clk_mux_x2),
        .i_x4                       (i_xcvrif_tx_word_clk_mux_x4),
        .i_x6_bot                   (i_xcvrif_tx_word_clk_mux_x6_bot),
        .i_x6_top                   (i_xcvrif_tx_word_clk_mux_x6_top),
        .i_x8_bot                   (i_xcvrif_tx_word_clk_mux_x8_bot),
        .i_x8_top                   (i_xcvrif_tx_word_clk_mux_x8_top),
        .k_sel                      (tx_xcvr_wordclk_sel),
        .o_xcvr_txword_ch_clk       (xcvr_tx_ch_clk)
    );

    assign o_xcvrif_tx_word_clk_mux_x1 = eth_txword_clk;

/*     tennm_sm_xcvrif_tx_rst_mux_module x_dynMux_sm_xcvrif_tx_rst_mux_0 (
        .i_ground_rst               (),
        .i_sel_ch0                  (ss_rstxcvrif_xcvrif_tx_rst_n),
        .i_sel_ch0_top              (i_ch0_top_xcvrif_tx_rst_mux),
        .i_sel_ch1                  (i_ch1_xcvrif_tx_rst_mux),
        .i_sel_ch2                  (i_ch2_xcvrif_tx_rst_mux),
        .i_sel_ch3                  (i_ch3_xcvrif_tx_rst_mux),
        .k_sel                      (tx_rst_source_sel),    
        .o_ch_xcvrif_tx_rst_n       (ss_rstxcvrif_xcvrif_tx_rst_n_mux)
    ); */

    tennm_sm_xcvrif_tx_rst_mux_module x_dynMux_sm_xcvrif_tx_rst_mux_0 (
        .i_x1                       (tx_rst_rd_sync_rst_n),         //(ss_rstxcvrif_xcvrif_tx_rst_n),
        .i_x2                       (i_xcvrif_tx_rst_mux_x2),
        .i_x4                       (i_xcvrif_tx_rst_mux_x4),
        .i_x6_bot                   (i_xcvrif_tx_rst_mux_x6_bot),
        .i_x6_top                   (i_xcvrif_tx_rst_mux_x6_top),
        .i_x8_bot                   (i_xcvrif_tx_rst_mux_x8_bot),
        .i_x8_top                   (i_xcvrif_tx_rst_mux_x8_top),
        .k_sel                      (tx_rst_source_sel),
        .o_ch_xcvrif_tx_rst_n       (ss_rstxcvrif_xcvrif_tx_rst_n_mux)
    );

    assign o_xcvrif_tx_rst_mux_x1 = tx_rst_rd_sync_rst_n;           //ss_rstxcvrif_xcvrif_tx_rst_n;

//1p0 Allignment
    tennm_sm_xcvrif_tx_rst_mux_module x_dynMux_sm_xcvrif_tx_rst_mux_1 (
        .i_x1                       (tx_rst_wr_sync_rst_n),
        .i_x2                       (i_xcvrif_tx_rst_wr_sync_mux_x2),
        .i_x4                       (i_xcvrif_tx_rst_wr_sync_mux_x4),
        .i_x6_bot                   (i_xcvrif_tx_rst_wr_sync_mux_x6_bot),
        .i_x6_top                   (i_xcvrif_tx_rst_wr_sync_mux_x6_top),
        .i_x8_bot                   (i_xcvrif_tx_rst_wr_sync_mux_x8_bot),
        .i_x8_top                   (i_xcvrif_tx_rst_wr_sync_mux_x8_top),
        .k_sel                      (tx_rst_source_sel),
        .o_ch_xcvrif_tx_rst_n       (ss_rstxcvrif_xcvrif_tx_rst_wr_sync_n_mux)
    );

    assign o_xcvrif_tx_rst_wr_sync_mux_x1 = tx_rst_wr_sync_rst_n;
    
    tennm_sm_flux_rx_user_clk_mux_module x_dynMux_sm_flux_rx_user_clk_mux_0 (
        .i_ock_pcs_rxpostdiv        (pcs_rxpostdiv),
        .i_ock_pcs_rxword           (pcs_rxword),
        .i_sel                      (ux_rxuser1_sel),
        .o_ux_rxuser_clk            (ux_rx_user1_clk)
    );

    tennm_sm_flux_rx_user_clk_mux_module x_dynMux_sm_flux_rx_user_clk_mux_1 (
        .i_ock_pcs_rxpostdiv        (pcs_rxpostdiv),
        .i_ock_pcs_rxword           (pcs_rxword),
        .i_sel                      (ux_rxuser2_sel),
        .o_ux_rxuser_clk            (ux_rx_user2_clk)
    );
    
    tennm_sm_flux_tx_user_clk_mux_module x_dynMux_sm_flux_tx_user_clk_mux_0 (
        .i_ock_pcs_txword_clk       (ock_pcs_txword),
        .i_sel                      (ux_txuser1_sel),
        .i_ux_txlc_clk              (ux_txlc_clk), 
        .o_ux_txuser_clk            (ux_tx_user1_clk)
    );
    
    tennm_sm_flux_tx_user_clk_mux_module x_dynMux_sm_flux_tx_user_clk_mux_1 (
        .i_ock_pcs_txword_clk       (ock_pcs_txword),
        .i_sel                      (ux_txuser2_sel),
        .i_ux_txlc_clk              (ux_txlc_clk),
        .o_ux_txuser_clk            (ux_tx_user2_clk)
    );

/*    ch4_phy_dynmux  ch4_phy_dynmux_inst(    
        .x_dynMux_sm_flux_rx_user_clk_mux_0__i_sel                              (ux_rxuser1_sel),
        .x_dynMux_sm_flux_rx_user_clk_mux_1__i_sel                              (ux_rxuser2_sel),
        .x_dynMux_sm_flux_tx_user_clk_mux_0__i_sel                              (ux_txuser1_sel),
        .x_dynMux_sm_flux_tx_user_clk_mux_1__i_sel                              (ux_txuser2_sel),
        .x_dynMux_sm_xcvrif_tx_mux_0__k_sel                                     (tx_source_sel),
        .x_dynMux_sm_xcvrif_rx_fifo_rd_en_mux_0__k_sel                          (rx_fifo_en_sel),
        .x_dynMux_sm_xcvrif_tx_fifo_rd_en_mux_0__k_sel                          (tx_rst_source_sel),
        .x_dynMux_sm_xcvrif_tx_rst_mux_0__k_sel                                 (tx_rst_source_sel),
        .x_dynMux_sm_xcvrif_tx_word_clk_mux_0__k_sel                            (tx_xcvr_wordclk_sel),
        .x_dynMux_sm_xcvrif_tx_mux_0__i_sel_deskew                              (ch_pld_tx_deskewed_data),
        .x_dynMux_sm_xcvrif_tx_mux_0__i_sel_ethpcs                              (pcs_tx_data),
        .x_dynMux_sm_xcvrif_tx_mux_0__i_sel_fec                                 (xcvr_tx_data),
        .x_dynMux_sm_flux_rx_user_clk_mux_0__i_ock_pcs_rxpostdiv                (pcs_rxpostdiv),
        .x_dynMux_sm_flux_rx_user_clk_mux_0__i_ock_pcs_rxword                   (pcs_rxword),
        .x_dynMux_sm_flux_tx_user_clk_mux_0__i_ock_pcs_txword                   (ock_pcs_txword),
        .x_dynMux_sm_flux_tx_user_clk_mux_0__i_ux_txlc_clk                      (ux_txlc_clk),
        .x_dynMux_sm_xcvrif_rx_fifo_rd_en_mux_0__i_sel_ch0                      (ch_xcvrif_rx_fifo_rd_en_mux),                     
        .x_dynMux_sm_xcvrif_rx_fifo_rd_en_mux_0__i_sel_ch2                      (i_ch2_xcvrif_rx_fifo_rd_en),                   //Where to connect?Should it come from Top?
        .x_dynMux_sm_xcvrif_rx_fifo_rd_en_mux_0__i_sel_ch3                      (i_ch3_xcvrif_rx_fifo_rd_en),                   //Where to connect?Should it come from Top?
        .x_dynMux_sm_xcvrif_rx_word_clk_mux_0__i_sel_rxword_clk                 (eth_rxword_clk),
        .x_dynMux_sm_xcvrif_tx_fifo_rd_en_mux_0__i_sel_ch0                      (ch_xcvrif_tx_fifo_rd_en_mux),                     
        .x_dynMux_sm_xcvrif_tx_fifo_rd_en_mux_0__i_sel_ch2                      (i_ch2_xcvrif_tx_fifo_rd_en),                  //Where to connect?Should it come from Top?
        .x_dynMux_sm_xcvrif_tx_fifo_rd_en_mux_0__i_sel_ch3                      (i_ch3_xcvrif_tx_fifo_rd_en),                  //Where to connect?Should it come from Top?
        .x_dynMux_sm_xcvrif_tx_rst_mux_0__i_sel_ch2                             (i_ch2_xcvrif_tx_rst_mux),                     //Where to connect?Should it come from Top?
        .x_dynMux_sm_xcvrif_tx_rst_mux_0__i_sel_ch3                             (i_ch3_xcvrif_tx_rst_mux),                     //Where to connect?Should it come from Top?
//        .x_dynMux_sm_xcvrif_tx_rst_mux_0__i_sel_ch0                             (ss_rstxcvrif_xcvrif_tx_rst_n),              //This is missing Needs to review
        .x_dynMux_sm_xcvrif_tx_word_clk_mux_0__i_sel_ux0_top                    (i_ux0_top_xcvrif_tx_word_clk),                //Where to connect?Should it come from Top?
        .x_dynMux_sm_xcvrif_tx_word_clk_mux_0__i_sel_ux2                        (i_ux2_xcvrif_tx_word_clk),                    //Where to connect?Should it come from Top?
        .x_dynMux_sm_xcvrif_tx_word_clk_mux_0__i_sel_ux3                        (i_ux3_xcvrif_tx_word_clk),                    //Where to connect?Should it come from Top?
//        .x_dynMux_sm_xcvrif_tx_word_clk_mux_0__i_sel_ux0                       (eth_txword_clk),                             //This is missing Needs to review
        .x_dynMux_sm_xcvrif_tx_mux_0__o_xcvrif_tx_mux_data                      (xcvrif_tx_mux_data),
        .x_dynMux_sm_flux_rx_user_clk_mux_0__o_ux_rxuser_clk                    (ux_rx_user1_clk),
        .x_dynMux_sm_flux_rx_user_clk_mux_1__o_ux_rxuser_clk                    (ux_rx_user2_clk),
        .x_dynMux_sm_flux_tx_user_clk_mux_0__o_ux_txuser_clk                    (ux_tx_user1_clk),
        .x_dynMux_sm_flux_tx_user_clk_mux_1__o_ux_txuser_clk                    (ux_tx_user2_clk),
        .x_dynMux_sm_xcvrif_rx_fifo_rd_en_mux_0__o_ch_xcvrif_rx_fifo_rd_en      (ch_xcvrif_rx_fifo_rd_en),
        .x_dynMux_sm_xcvrif_rx_word_clk_mux_0__o_xcvr_rxword_ch_clk             (xcvr_rx_ch_clk),
        .x_dynMux_sm_xcvrif_tx_fifo_rd_en_mux_0__o_ch_xcvrif_tx_fifo_rd_en      (ch_xcvrif_tx_fifo_rd_en),
        .x_dynMux_sm_xcvrif_tx_rst_mux_0__o_ch_xcvrif_tx_rst_n                  (ss_rstxcvrif_xcvrif_tx_rst_n_mux),
        .x_dynMux_sm_xcvrif_tx_word_clk_mux_0__o_xcvr_txword_ch_clk             (xcvr_tx_ch_clk)

    ); */
    
// *************All Muxes taken outside ********************** //

endgenerate

endmodule

