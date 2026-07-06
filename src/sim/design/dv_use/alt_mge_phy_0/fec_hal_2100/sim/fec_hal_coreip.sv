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



 
  module fec_hal_coreip 
  #(
    parameter ch_fec_l_duplex_mode_atom      = "DUPLEX_MODE_DUPLEX"     ,
    parameter ch_fec_l_fec_spec_atom         = "FEC_SPEC_DISABLED"      ,
    parameter ch_fec_l_fracture_atom         = "FRACTURE_F25G"          ,
    parameter ch_fec_l_dyn_tx_mux_atom       = "DYN_TX_MUX_UNUSED"      ,
    parameter ch_fec_l_tx_en_atom            = "FALSE"                  ,
    parameter ch_fec_l_rx_en_atom            = "FALSE"                  ,
    parameter ch_fec_dr_enabled_atom         = "DR_ENABLED_DR_ENABLED"  ,
    parameter ch_fec_l_sup_mode_atom         = "SUP_MODE_USER_MODE"     ,
    parameter ch_fec_l_sim_mode_atom         = "SIM_MODE_DISABLE"       ,
    parameter ch_fec_l_pcs_tx_en_atom        = "FALSE"               ,
    parameter ch_fec_l_pcs_rx_en_atom        = "FALSE"              ,
    parameter ch_fec_l_loopback_mode_atom    = "LOOPBACK_MODE_DISABLE",
    parameter ch_fec_l_fec_error_atom        = "FALSE"                ,
    parameter ch_fec_l_fec_mode_atom         = "FEC_MODE_DISABLED" 

)
(
    input   [19:0]  i_ch_lavmm_fec_addr       ,
    input   [3:0]   i_ch_lavmm_fec_be         ,
    input           i_ch_lavmm_fec_clk        , 
    input           i_ch_lavmm_fec_read       , 
    input           i_ch_lavmm_fec_rstn       ,
    input   [31:0]  i_ch_lavmm_fec_wdata      ,
    input           i_ch_lavmm_fec_write      , 
    output  [31:0]  o_ch_lavmm_fec_rdata      ,
    output          o_ch_lavmm_fec_rdata_valid, 
    output          o_ch_lavmm_fec_waitreq    , 
    input   [6:0]   i_ch_eth_fec_tx_async     ,
    input           i_ch_eth_fec_tx_direct    , 
    output  [11:0]  o_ch_eth_fec_rx_async     ,
    output          o_ch_eth_fec_rx_direct    , 
    input           i_rstfec_fec_csr_ret      , 
    output          o_fec_rx_rdy_n            , 
    input           i_rstfec_rx_fec_sfrz_n    , 
    input           i_rstfec_fec_rx_rst_n     , 
    input           i_rstfec_tx_fec_sfrz_n    , 
    input           i_rstfec_fec_tx_rst_n     , 
    output  [42:0]  o_fec_rx_data             ,
    input           i_fec_clk                 , 
    input   [42:0]  i_xcvr_rx_data            ,
    output  [42:0]  o_xcvr_tx_data            ,
    input           i_pma_rx_sf               ,
    
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
    
/*     //adding dyn mux taking inside interface
    input  [42:0]   i_sel_ethpcs,
    input  [42:0]   i_sel_deskew, */
    //adding dyn mux taking outside ports
    output          o_fec_tx_data_mux_sel     , 
    input   [42:0]  i_fec_i_tx_mux_data        

);  

ch4_fec #(

    .x_std_sm_hssi_fec_ingress_0__dr_enabled         (ch_fec_dr_enabled_atom    ),
    .x_std_sm_hssi_fec_ingress_0__duplex_mode        (ch_fec_l_duplex_mode_atom ),
    .x_std_sm_hssi_fec_ingress_0__dyn_tx_mux         (ch_fec_l_dyn_tx_mux_atom  ),
    .x_std_sm_hssi_fec_ingress_0__fec_error          (ch_fec_l_fec_error_atom   ),
    .x_std_sm_hssi_fec_ingress_0__fec_mode           (ch_fec_l_fec_mode_atom        ),
    .x_std_sm_hssi_fec_ingress_0__fec_spec           (ch_fec_l_fec_spec_atom        ),
    .x_std_sm_hssi_fec_ingress_0__fracture           (ch_fec_l_fracture_atom        ),
    .x_std_sm_hssi_fec_ingress_0__loopback_mode      (ch_fec_l_loopback_mode_atom),
    .x_std_sm_hssi_fec_ingress_0__pcs_rx_en          (ch_fec_l_pcs_rx_en_atom   ),
    .x_std_sm_hssi_fec_ingress_0__pcs_tx_en          (ch_fec_l_pcs_tx_en_atom   ),
    .x_std_sm_hssi_fec_ingress_0__rx_en              (ch_fec_l_rx_en_atom       ),
    `ifdef ALTERA_RESERVED_QIS
        .x_std_sm_hssi_fec_ingress_0__sim_mode       ("SIM_MODE_DISABLE"),
    `else
        .x_std_sm_hssi_fec_ingress_0__sim_mode       (ch_fec_l_sim_mode_atom        ),
    `endif 
    .x_std_sm_hssi_fec_ingress_0__sup_mode           (ch_fec_l_sup_mode_atom        ),
    .x_std_sm_hssi_fec_ingress_0__tx_en              (ch_fec_l_tx_en_atom       )


) ch4_fec_inst (

 /*    .x_dynMux_sm_hssi_fec_tx_mux_0__i_sel_ethpcs                        (i_sel_ethpcs                         ),
    .x_dynMux_sm_hssi_fec_tx_mux_0__i_sel_deskew                        (i_sel_deskew                         )  , */
    .x_std_sm_hssi_fec_egress_0__i_xcvr_tx_data                         (i_xcvr_tx_data                       )  ,
    .x_std_sm_hssi_fec_egress_0__i_xcvr_rx_data                         (i_xcvr_rx_data                       )  ,
    .x_std_sm_hssi_fec_egress_0__o_xcvr_tx_data                         (o_xcvr_tx_data                       )  ,
    .x_std_sm_hssi_fec_egress_0__o_xcvr_rx_data                         (o_xcvr_rx_data                       )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_addr_fec_wrap          (o_ch_lavmm_fec_addr_fec_wrap        )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_eth_fec_tx_async_fec_wrap        (o_ch_eth_fec_tx_async_fec_wrap      )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_eth_fec_rx_async                 (o_ch_eth_fec_rx_async               )  ,
    .x_std_sm_hssi_fec_ingress_0__i_fec_rx_data_fec_wrap                (i_fec_rx_data_fec_wrap              )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_be_fec_wrap            (o_ch_lavmm_fec_be_fec_wrap          )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_eth_fec_rx_async_fec_wrap        (i_ch_eth_fec_rx_async_fec_wrap      )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_rdata                  (o_ch_lavmm_fec_rdata                )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_eth_fec_tx_async                 (i_ch_eth_fec_tx_async               )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_wdata_fec_wrap         (o_ch_lavmm_fec_wdata_fec_wrap       )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_addr                   (i_ch_lavmm_fec_addr                 )  ,
    .x_std_sm_hssi_fec_ingress_0__o_fec_rx_data                         (o_fec_rx_data                       )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_rdata_fec_wrap         (i_ch_lavmm_fec_rdata_fec_wrap       )  ,
    .x_std_sm_hssi_fec_ingress_0__o_fec_i_tx_mux_data_fec_wrap          (o_fec_i_tx_mux_data_fec_wrap        )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_be                     (i_ch_lavmm_fec_be                   )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_wdata                  (i_ch_lavmm_fec_wdata                )  ,
    .x_std_sm_hssi_fec_ingress_0__o_rstfec_tx_fec_sfrz_n_fec_wrap       (o_rstfec_tx_fec_sfrz_n_fec_wrap     )  ,
    .x_std_sm_hssi_fec_ingress_0__o_rstfec_rx_fec_sfrz_n_fec_wrap       (o_rstfec_rx_fec_sfrz_n_fec_wrap     )  ,
    .x_std_sm_hssi_fec_ingress_0__o_rstfec_fec_rx_rst_n_fec_wrap        (o_rstfec_fec_rx_rst_n_fec_wrap      )  ,
    .x_std_sm_hssi_fec_ingress_0__o_rstfec_fec_csr_ret_fec_wrap         (o_rstfec_fec_csr_ret_fec_wrap       )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_write_fec_wrap         (o_ch_lavmm_fec_write_fec_wrap       )  ,
    .x_std_sm_hssi_fec_ingress_0__i_fec_clk                             (i_fec_clk                           )  ,
    .x_std_sm_hssi_fec_ingress_0__o_rstfec_fec_tx_rst_n_fec_wrap        (o_rstfec_fec_tx_rst_n_fec_wrap      )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_clk                    (i_ch_lavmm_fec_clk                  )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_waitreq_fec_wrap       (i_ch_lavmm_fec_waitreq_fec_wrap     )  ,
    .x_std_sm_hssi_fec_ingress_0__i_fec_tx_data_mux_sel_fec_wrap        (i_fec_tx_data_mux_sel_fec_wrap      )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_eth_fec_rx_direct_fec_wrap       (i_ch_eth_fec_rx_direct_fec_wrap     )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_rstn                   (i_ch_lavmm_fec_rstn                 )  ,
    .x_std_sm_hssi_fec_ingress_0__i_fec_rx_rdy_n_fec_wrap               (i_fec_rx_rdy_n_fec_wrap             )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_write                  (i_ch_lavmm_fec_write                )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_eth_fec_tx_direct                (i_ch_eth_fec_tx_direct              )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_rdata_valid_fec_wrap   (i_ch_lavmm_fec_rdata_valid_fec_wrap )  ,
    .x_std_sm_hssi_fec_ingress_0__i_ch_lavmm_fec_read                   (i_ch_lavmm_fec_read                 )  ,
    .x_std_sm_hssi_fec_ingress_0__i_rstfec_fec_csr_ret                  (i_rstfec_fec_csr_ret                )  ,
    .x_std_sm_hssi_fec_ingress_0__i_rstfec_fec_rx_rst_n                 (i_rstfec_fec_rx_rst_n               )  ,
    .x_std_sm_hssi_fec_ingress_0__i_rstfec_fec_tx_rst_n                 (i_rstfec_fec_tx_rst_n               )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_eth_fec_tx_direct_fec_wrap       (o_ch_eth_fec_tx_direct_fec_wrap     )  ,
    .x_std_sm_hssi_fec_ingress_0__i_rstfec_tx_fec_sfrz_n                (i_rstfec_tx_fec_sfrz_n              )  ,
    .x_std_sm_hssi_fec_ingress_0__o_fec_rx_rdy_n                        (o_fec_rx_rdy_n                      )  ,
    .x_std_sm_hssi_fec_ingress_0__i_rstfec_rx_fec_sfrz_n                (i_rstfec_rx_fec_sfrz_n              )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_clk_fec_wrap           (o_ch_lavmm_fec_clk_fec_wrap         )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_eth_fec_rx_direct                (o_ch_eth_fec_rx_direct              )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_waitreq                (o_ch_lavmm_fec_waitreq              )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_rdata_valid            (o_ch_lavmm_fec_rdata_valid          )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_read_fec_wrap          (o_ch_lavmm_fec_read_fec_wrap        )  ,
    .x_std_sm_hssi_fec_ingress_0__o_ch_lavmm_fec_rstn_fec_wrap          (o_ch_lavmm_fec_rstn_fec_wrap        )  ,
    .x_std_sm_hssi_fec_egress_0__o_pma_rx_sf                            (o_pma_rx_sf )  ,
    .x_std_sm_hssi_fec_egress_0__i_pma_rx_sf                            (i_pma_rx_sf )  ,
    .x_std_sm_hssi_fec_ingress_0__o_fec_tx_data_mux_sel                 (o_fec_tx_data_mux_sel  ),      
    .x_std_sm_hssi_fec_ingress_0__i_fec_i_tx_mux_data                   (i_fec_i_tx_mux_data    )



);
    

endmodule
