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


//------------------------------------------------------------------------------
  module pcs_hal_coreip 
  #(
    parameter ch_pcs_l_duplex_mode_atom         = "DUPLEX_MODE_DUPLEX"       ,
    parameter ch_pcs_l_loopback_mode_atom       = "LOOPBACK_MODE_NO_LOOPBACK",
    parameter ch_pcs_l_fec_tx_en_atom           = "FALSE"                    ,
    parameter ch_pcs_l_fec_rx_en_atom           = "FALSE"                    ,
    parameter ch_pcs_dr_enabled_atom            = "DR_ENABLED_DR_DISABLED"   ,
    parameter ch_pcs_l_rate_mode_atom           = "RATE_MODE_RATE_10G"       ,
    parameter ch_pcs_l_sup_mode_atom            = "SUP_MODE_USER_MODE"       ,
    parameter ch_pcs_l_sim_mode_atom            = "SIM_MODE_DISABLE"         ,
    parameter ch_pcs_l_tx_en_atom               = "FALSE"                    ,
    parameter ch_pcs_l_rx_en_atom               = "FALSE"                    ,
    parameter ch_pcs_tx_dyn_mux_atom            = "TX_DYN_MUX_UNUSED"        ,
    parameter ch_pcs_rx_dyn_mux_atom            = "RX_DYN_MUX_UNUSED"        ,
    parameter ch_pcs_l_pcs_ber_mon_mode_atom    = "PCS_BER_MON_MODE_DISABLED",
    parameter ch_pcs_l_tx_pcs_mode_atom         =  "TX_PCS_MODE_DISABLED"    ,
    parameter ch_pcs_l_rx_pcs_mode_atom         =  "RX_PCS_MODE_DISABLED"    ,
    parameter ch_pcs_l_fec_mode_atom            =  "FEC_MODE_DISABLED"   

)
(
    output [31:0]   o_ch_lavmm_epcs_rdata             ,
    output          o_ch_lavmm_epcs_rdata_valid       ,
    output          o_ch_lavmm_epcs_waitreq           ,
    input  [19:0]   i_ch_lavmm_epcs_addr              ,
    input  [3:0]    i_ch_lavmm_epcs_be                ,
    input           i_ch_lavmm_epcs_clk               ,
    input           i_ch_lavmm_epcs_read              ,
    input           i_ch_lavmm_epcs_rstn              ,
    input  [31:0]   i_ch_lavmm_epcs_wdata             ,
    input           i_ch_lavmm_epcs_write             ,
    input           i_pcs_tx_clk                      ,
    input           i_pcs_rx_clk                      ,
    input  [7:0]    i_hssi_async_dir_eth_pcs_tx_async ,
    input           i_hssi_async_dir_eth_pcs_tx_direct,
    output [13:0]   o_hssi_async_dir_eth_pcs_rx_async ,
    output          o_hssi_async_dir_eth_pcs_rx_direct,
    input           i_ehip_rx_rst_n                   ,
    input           i_ehip_tx_rst_n                   ,
    output          o_rstepcs_rx_pcs_fully_aligned    ,
    input           i_ehip_signal_ok                  ,
    input           i_t03f_sfreeze_1_tx_pcs_sfrz_n    ,
    output [42:0]   o_pcs_tx_data                     ,
    output [42:0]   o_pcs_rx_mii_data                 ,
    output [42:0]   o_pcs_rx_data                     ,
    //dyn muxes taking outside ports
    output          o_tx_mux_sel                      ,  
    output          o_rx_mux_sel                      ,  
    input  [42:0]   i_pcs_tx_data_mux                 ,  
    input  [42:0]   i_pcs_rx_data_mux                 ,   
    input           i_sfreeze_2_r03f_rx_pcs_sfrz_n                    
/*    //dyn mux taking inside ports adding
    input  [42:0]   i_sel_tx_eth                        ,
    input  [42:0]   i_sel_tx_deskew                     ,
    input  [42:0]   i_sel_xcvr,
    input  [42:0]   i_sel_fec */
);



ch4_pcs #(

          .x_std_sm_hssi_elane_pcs_1ch_0__dr_enabled                  (ch_pcs_dr_enabled_atom),
          .x_std_sm_hssi_elane_pcs_1ch_0__duplex_mode                 (ch_pcs_l_duplex_mode_atom),  
          .x_std_sm_hssi_elane_pcs_1ch_0__fec_mode                    (ch_pcs_l_fec_mode_atom),   
          .x_std_sm_hssi_elane_pcs_1ch_0__fec_rx_en                   (ch_pcs_l_fec_rx_en_atom),   
          .x_std_sm_hssi_elane_pcs_1ch_0__fec_tx_en                   (ch_pcs_l_fec_tx_en_atom),   
          .x_std_sm_hssi_elane_pcs_1ch_0__loopback_mode               (ch_pcs_l_loopback_mode_atom),    
          .x_std_sm_hssi_elane_pcs_1ch_0__pcs_ber_mon_mode            (ch_pcs_l_pcs_ber_mon_mode_atom),
          .x_std_sm_hssi_elane_pcs_1ch_0__rate_mode                   (ch_pcs_l_rate_mode_atom),   
          .x_std_sm_hssi_elane_pcs_1ch_0__rx_dyn_mux                  (ch_pcs_rx_dyn_mux_atom),   
          .x_std_sm_hssi_elane_pcs_1ch_0__rx_en                       (ch_pcs_l_rx_en_atom),
          .x_std_sm_hssi_elane_pcs_1ch_0__rx_pcs_mode                 (ch_pcs_l_rx_pcs_mode_atom),  
       `ifdef ALTERA_RESERVED_QIS
          .x_std_sm_hssi_elane_pcs_1ch_0__sim_mode                    ("SIM_MODE_DISABLE"),
       `else
          .x_std_sm_hssi_elane_pcs_1ch_0__sim_mode                    (ch_pcs_l_sim_mode_atom), 
       `endif 
          .x_std_sm_hssi_elane_pcs_1ch_0__sup_mode                    (ch_pcs_l_sup_mode_atom),   
          .x_std_sm_hssi_elane_pcs_1ch_0__tx_dyn_mux                  (ch_pcs_tx_dyn_mux_atom),   
          .x_std_sm_hssi_elane_pcs_1ch_0__tx_en                       (ch_pcs_l_tx_en_atom),
          .x_std_sm_hssi_elane_pcs_1ch_0__tx_pcs_mode                 (ch_pcs_l_tx_pcs_mode_atom)
    
) ch4_pcs_inst (

//    .x_dynMux_sm_pcs_tx_mux_0__i_sel_tx_eth                              (i_sel_tx_eth),
//    .x_dynMux_sm_pcs_tx_mux_0__i_sel_tx_deskew                           (i_sel_tx_deskew),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_hssi_async_dir_eth_pcs_tx_async    (i_hssi_async_dir_eth_pcs_tx_async),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ch_lavmm_epcs_wdata                (i_ch_lavmm_epcs_wdata),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ch_lavmm_epcs_addr                 (i_ch_lavmm_epcs_addr),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ch_lavmm_epcs_be                   (i_ch_lavmm_epcs_be),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_pcs_rx_mii_data                    (o_pcs_rx_mii_data),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_pcs_tx_data                        (o_pcs_tx_data),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_pcs_rx_data                        (o_pcs_rx_data),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_hssi_async_dir_eth_pcs_rx_async    (o_hssi_async_dir_eth_pcs_rx_async),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_ch_lavmm_epcs_rdata                (o_ch_lavmm_epcs_rdata),
//    .x_dynMux_sm_pcs_rx_mux_0__i_sel_xcvr                                (i_sel_xcvr),
//    .x_dynMux_sm_pcs_rx_mux_0__i_sel_fec                                 (i_sel_fec),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ehip_rx_rst_n                      (i_ehip_rx_rst_n),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_hssi_async_dir_eth_pcs_tx_direct   (i_hssi_async_dir_eth_pcs_tx_direct),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ch_lavmm_epcs_rstn                 (i_ch_lavmm_epcs_rstn),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ch_lavmm_epcs_clk                  (i_ch_lavmm_epcs_clk),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ch_lavmm_epcs_write                (i_ch_lavmm_epcs_write),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_hssi_async_dir_eth_pcs_rx_direct   (o_hssi_async_dir_eth_pcs_rx_direct),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ch_lavmm_epcs_read                 (i_ch_lavmm_epcs_read),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ehip_signal_ok                     (i_ehip_signal_ok),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_t03f_sfreeze_1_tx_pcs_sfrz_n       (i_t03f_sfreeze_1_tx_pcs_sfrz_n),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_ch_lavmm_epcs_rdata_valid          (o_ch_lavmm_epcs_rdata_valid),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_ehip_tx_rst_n                      (i_ehip_tx_rst_n),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_rstepcs_rx_pcs_fully_aligned       (o_rstepcs_rx_pcs_fully_aligned),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_ch_lavmm_epcs_waitreq              (o_ch_lavmm_epcs_waitreq),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_pcs_tx_clk                         (i_pcs_tx_clk),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_pcs_rx_clk                         (i_pcs_rx_clk),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_sfreeze_2_r03f_rx_pcs_sfrz_n       (i_sfreeze_2_r03f_rx_pcs_sfrz_n),
//dyn mux taking outside
    .x_std_sm_hssi_elane_pcs_1ch_0__o_tx_mux_sel                         (o_tx_mux_sel      ),
    .x_std_sm_hssi_elane_pcs_1ch_0__o_rx_mux_sel                         (o_rx_mux_sel      ),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_pcs_tx_data_mux                    (i_pcs_tx_data_mux ),
    .x_std_sm_hssi_elane_pcs_1ch_0__i_pcs_rx_data_mux                    (i_pcs_rx_data_mux )


);
    



endmodule
