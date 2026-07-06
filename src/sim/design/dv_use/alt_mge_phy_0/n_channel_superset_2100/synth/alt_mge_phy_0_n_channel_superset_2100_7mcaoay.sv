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


`timescale 1 ps / 1 ps

//Quartus Warnings
// altera message_off 16788

  module alt_mge_phy_0_n_channel_superset_2100_7mcaoay #( 
    parameter           num_of_lanes                                          = 1
  ) 
  
  (
    input                                     i_refclk_tx_p                              ,
//    input                                     i_refclk_tx_n                              ,
    input                                     i_syspll_c0_clk                            ,
    input                                     i_syspll_c1_clk                            ,
    input                                     i_syspll_c2_clk                            ,
    input                                     i_flux_clk_0                               ,
    input                                     i_flux_clk_1                               ,
    input                                     i_refclk_rx_p                              ,
//    input                                     i_refclk_rx_n                              ,
 
    input   [(num_of_lanes*80)-1:0]           i_hio_txdata                               ,
    input   [(num_of_lanes*10)-1:0]           i_hio_txdata_extra                         ,
    input   [num_of_lanes-1:0]                i_hio_txdata_fifo_wr_en                    ,
    input   [num_of_lanes-1:0]                i_hio_rxdata_fifo_rd_en                    ,
    input   [(num_of_lanes*80)-1:0]           i_hio_uxquad_async_rx                      ,
    input   [(num_of_lanes*80)-1:0]           i_hio_uxquad_async_tx                      ,
    input   [(num_of_lanes*80)-1:0]           i_hio_uxquad_async_pcie_mux_rx             ,
    input   [(num_of_lanes*80)-1:0]           i_hio_uxquad_async_pcie_mux_tx             ,

      
    input   [20:0]                            i_hio_ch0_lavmm_addr                    ,
    input   [3:0]                             i_hio_ch0_lavmm_be                      ,
    input                                     i_hio_ch0_lavmm_read                    ,
    input                                     i_hio_ch0_lavmm_write                   ,
    input   [31:0]                            i_hio_ch0_lavmm_wdata                   ,
    output  [31:0]                            o_hio_ch0_lavmm_rdata                   ,
    output                                    o_hio_ch0_lavmm_rdata_valid             ,
    output                                    o_hio_ch0_lavmm_waitreq                 ,
    input                                     i_hio_ch0_lavmm_rstn                    ,
    input                                     i_hio_ch0_lavmm_clk                     ,
    input                                     i_hio_ch0_pld_rx_clk_in_row_clk         ,
    input                                     i_hio_ch0_pld_tx_clk_in_row_clk         ,
    input                                     i_hio_ch0_det_lat_rx_dl_clk             ,
    input                                     i_hio_ch0_det_lat_rx_mux_select         ,
    input                                     i_hio_ch0_det_lat_rx_sclk_flop          ,
    input                                     i_hio_ch0_det_lat_rx_sclk_gen_clk       ,
    input                                     i_hio_ch0_det_lat_rx_trig_flop          ,
    input                                     i_hio_ch0_det_lat_sampling_clk          ,
    input                                     i_hio_ch0_det_lat_tx_dl_clk             ,
    input                                     i_hio_ch0_det_lat_tx_mux_select         ,
    input                                     i_hio_ch0_det_lat_tx_sclk_flop          ,
    input                                     i_hio_ch0_det_lat_tx_sclk_gen_clk       ,
    input                                     i_hio_ch0_det_lat_tx_trig_flop          ,
    output                                    o_hio_ch0_user_rx_clk1_clk              ,
    output                                    o_hio_ch0_user_rx_clk2_clk              ,
    output                                    o_hio_ch0_user_tx_clk1_clk              ,
    output                                    o_hio_ch0_user_tx_clk2_clk              ,
    output                                    o_hio_ch0_ux_chnl_refclk_mux            ,
    output                                    o_hio_ch0_det_lat_rx_async_dl_sync      ,
    output                                    o_hio_ch0_det_lat_rx_async_pulse        ,
    output                                    o_hio_ch0_det_lat_rx_async_sample_sync  ,
    output                                    o_hio_ch0_det_lat_rx_sclk_sample_sync   ,
    output                                    o_hio_ch0_det_lat_rx_trig_sample_sync   ,
    output                                    o_hio_ch0_det_lat_tx_async_dl_sync      ,
    output                                    o_hio_ch0_det_lat_tx_async_pulse        ,
    output                                    o_hio_ch0_det_lat_tx_async_sample_sync  ,
    output                                    o_hio_ch0_det_lat_tx_sclk_sample_sync   ,
    output                                    o_hio_ch0_det_lat_tx_trig_sample_sync   ,
    output                                    o_hio_ch0_xcvrif_rx_latency_pulse       ,
    output                                    o_hio_ch0_xcvrif_tx_latency_pulse       ,
    
    input   [num_of_lanes-1:0]                rx_serial_n                                ,
    input   [num_of_lanes-1:0]                rx_serial_p                                , 
    output  [num_of_lanes-1:0]                o_hio_txdata_fifo_wr_empty                 ,
    output  [num_of_lanes-1:0]                o_hio_txdata_fifo_wr_pempty                ,
    output  [num_of_lanes-1:0]                o_hio_txdata_fifo_wr_full                  ,
    output  [num_of_lanes-1:0]                o_hio_txdata_fifo_wr_pfull                 ,
    output  [(num_of_lanes*80)-1:0]           o_hio_rxdata                               ,
    output  [(num_of_lanes*10)-1:0]           o_hio_rxdata_extra                         ,
    output  [num_of_lanes-1:0]                o_hio_rxdata_fifo_rd_empty                 ,
    output  [num_of_lanes-1:0]                o_hio_rxdata_fifo_rd_pempty                ,
    output  [num_of_lanes-1:0]                o_hio_rxdata_fifo_rd_full                  ,
    output  [num_of_lanes-1:0]                o_hio_rxdata_fifo_rd_pfull                 ,
    output  [(num_of_lanes*50)-1:0]           o_hio_uxquad_async_rx                      ,
    output  [(num_of_lanes*50)-1:0]           o_hio_uxquad_async_tx                      ,
    output  [num_of_lanes-1:0]                tx_serial_p                                ,
    output  [num_of_lanes-1:0]                tx_serial_n                                ,
    input   [(num_of_lanes*100)-1:0]          i_hio_txdata_async_rx                      ,
    input   [(num_of_lanes*100)-1:0]          i_hio_txdata_async_tx                      ,
    input   [(num_of_lanes*10)-1:0]           i_hio_txdata_direct                        ,
    output  [(num_of_lanes*100)-1:0]          o_hio_rxdata_async_rx                      ,
    output  [(num_of_lanes*100)-1:0]          o_hio_rxdata_async_tx                      ,
    output  [(num_of_lanes*10)-1:0]           o_hio_rxdata_direct                        ,
    output  [num_of_lanes-1:0]                o_hio_rst_ux_all_synthlockstatus           ,
    output  [num_of_lanes-1:0]                o_hio_rst_ux_octl_pcs_rxstatus             ,
    output  [num_of_lanes-1:0]                o_hio_rst_ux_octl_pcs_txstatus             ,
    output  [num_of_lanes-1:0]                o_hio_rst_ux_rxcdrlock2data                ,
    output  [num_of_lanes-1:0]                o_hio_rst_ux_rxcdrlockstatus               ,
    input   [num_of_lanes-1:0]                i_hio_ehip_signal_ok                       ,
    output  [num_of_lanes-1:0]                o_cdrdiv_clk                               ,
    output  [num_of_lanes-1:0]                o_hio_ux_tx_ch_ptr_smpl                    ,
    output  [num_of_lanes-1:0]                o_hio_rst_flux0_cpi_cmn_busy               ,
    output  [num_of_lanes-1:0]                o_hio_rstfec_fec_rx_rdy_n                  ,
    output  [num_of_lanes-1:0]                o_hio_rst_oflux_rx_srds_rdy                ,
  
    //PTP PORTS
    input                                     i_hio_lavmm_clk_ptp,
    input                                     i_hio_lavmm_rstn_ptp,
    input    [20:0]                           i_hio_lavmm_addr_ptp,
    input    [31:0]                           i_hio_lavmm_wdata_ptp,
    input    [3:0 ]                           i_hio_lavmm_be_ptp,
    input                                     i_hio_lavmm_read_ptp,
    input                                     i_hio_lavmm_write_ptp,
    output   [31:0]                           o_hio_lavmm_rdata_ptp,
    output                                    o_hio_lavmm_rdata_valid_ptp,
    output                                    o_hio_lavmm_waitreq_ptp,
    input   [79:0]                            i_hio_txdata_ptp,
    input                                     i_hio_det_lat_rx_dl_clk_ptp,
    input                                     i_hio_det_lat_rx_mux_select_ptp  ,
    input                                     i_hio_det_lat_rx_sclk_flop_ptp   ,
    input                                     i_hio_det_lat_rx_sclk_gen_clk_ptp,
    input                                     i_hio_det_lat_rx_trig_flop_ptp   ,
    input                                     i_hio_det_lat_sampling_clk_ptp   ,
    input                                     i_hio_det_lat_tx_dl_clk_ptp      ,
    input                                     i_hio_det_lat_tx_mux_select_ptp  ,
    input                                     i_hio_det_lat_tx_sclk_flop_ptp   ,
    input                                     i_hio_det_lat_tx_sclk_gen_clk_ptp,
    input                                     i_hio_det_lat_tx_trig_flop_ptp   ,
    input                                     i_hio_pld_rx_clk_in_row_clk_ptp,
    input                                     i_hio_pld_tx_clk_in_row_clk_ptp,
    output  [79:0]                            o_hio_rxdata_ptp,
    output                                    o_hio_det_lat_rx_async_dl_sync_ptp    ,
    output                                    o_hio_det_lat_rx_async_pulse_ptp      ,
    output                                    o_hio_det_lat_rx_async_sample_sync_ptp,
    output                                    o_hio_det_lat_rx_sclk_sample_sync_ptp ,
    output                                    o_hio_det_lat_rx_trig_sample_sync_ptp ,
    output                                    o_hio_det_lat_tx_async_dl_sync_ptp    ,
    output                                    o_hio_det_lat_tx_async_pulse_ptp      ,
    output                                    o_hio_det_lat_tx_async_sample_sync_ptp,
    output                                    o_hio_det_lat_tx_sclk_sample_sync_ptp ,
    output                                    o_hio_det_lat_tx_trig_sample_sync_ptp ,
    output                                    o_hio_user_rx_clk1_clk_ptp ,
    output                                    o_hio_user_tx_clk1_clk_ptp ,
    
    //SRC Lane Control Interface with SIP (or DR MUX)
    output  [2*num_of_lanes-1:0]              o_tx_lane_current_state ,                 
    output  [num_of_lanes-1:0]                o_tx_alarm ,                  
    output  [num_of_lanes-1:0]                o_sip_am_gen_start  , 
    output  [2*num_of_lanes-1:0]              o_rx_lane_current_state , 
    output  [num_of_lanes-1:0]                o_rx_alarm ,  
    output  [num_of_lanes-1:0]                o_sip_freeze_rx_acknowledge , 
    output  [num_of_lanes-1:0]                o_sip_freeze_tx_acknowledge , 
    input   [num_of_lanes-1:0]                i_tx_clear_alarm ,
    input   [num_of_lanes-1:0]                i_tx_lane_desired_state , //0: operate, 1:reset
    input   [num_of_lanes-1:0]                i_rx_lane_desired_state , //0: operate, 1:reset
    input   [num_of_lanes-1:0]                i_rx_clear_alarm ,
    input   [num_of_lanes-1:0]                i_sip_rx_ignore_lock2data ,
    input   [num_of_lanes-1:0]                i_sip_freeze_tx_SRC_sequence ,
    input   [num_of_lanes-1:0]                i_sip_freeze_rx_SRC_sequence ,
    input   [num_of_lanes-1:0]                i_sip_am_gen_2x_ack  ,
    //Reset/Status Interface to HIP
    output  [num_of_lanes-1:0]                iflux_ingress_direct_231 ,        //TBD To HAL TOP - Reshmi to update async pldif 9th bit of i_hio_uxquad_async     
    input                                     i_spll_lock  ,                    // modified as per SysPLL IP Signals
    //DR Controller Interface
    input   [num_of_lanes-1:0]                pause_request  ,
    output  [num_of_lanes-1:0]                pause_grant ,
    //SRC Shoreline Sequencer Interface
    output  [num_of_lanes-1:0]                o_sss_req ,   
    input   [num_of_lanes-1:0]                i_sss_grant    
  );


  /* All input/output signals except common signals and ptp signals must go through ncss_common_sip_top (sip atom) where SRC Lane and AVMM DECoder instantiated.

                      |"""""""""""""""""""""""""""""""""""""""""""""""|
  |"""""""""""""|     |   |""""""""""""""""""|     |"""""""""""""|    |           
  |             |<====|===|===>|SRC, DEC|<===|====>|             |    |                             
  | -QHIP/SIP-  |     |   |    -SIP ATOM-    |     |    -HAL-    |    |                  
  |             |<====|===|==================|====>|             |    |                       
  |_____________|     |   |__________________|     |_____________|    |         
         ||           |                                  ||           |
         ||           |   |""""""""""""""""""|           ||           |
         ||           |   |  <PTP Enabled>   |           ||           |       
         ||           |   |    -PTP TOP-     |           ||           | 
         ||===========|===|==================|===========||           |
                      |   |__________________|                        |                                      
                      |__________________________NCSS_________________|
     
  */
 
  //---------------------------------------- Parameters-----------------------------------------------

  localparam TX_ENABLE                           = 1;
  localparam RX_ENABLE                           = 1;
  localparam TX_INITIATOR                        = 1;
  localparam RX_INITIATOR                        = 1;
  localparam TX_INITIATOR_INDEX                  = 0;
  localparam RX_INITIATOR_INDEX                  = 0;
  localparam [(num_of_lanes**2)-1:0] TX_TARGET_ENABLE = 'd0;
  localparam [(num_of_lanes**2)-1:0] RX_TARGET_ENABLE = 'd0;
  localparam [63:0] TX_LANE_FUCTIONAL_MODE       = 'd0;
  localparam [63:0] RX_LANE_FUCTIONAL_MODE       = 'd0;
  localparam NON_PTP_CHANNEL                     = 1;
  localparam TX_PCS_EN                           = 0;
  localparam RX_PCS_EN                           = 0;
  localparam UX_EN                               = 1;
  localparam TX_DL_EN                            = 1;
  localparam RX_DL_EN                            = 1;
  localparam FLUX_USED_FOR_RX_ADAPTATION         = 0;
  localparam PTP_EN                              = 0;
  localparam TX_FEC_EN                           = 0;
  localparam RX_FEC_EN                           = 0;
  localparam ETHERNET_SYSPLL_CLK_MODE            = 1;
  localparam UX_USING_SYSPLL_CLK                 = 0;
  localparam FLUX_USING_SYSPLL_CLK               = 0;
  localparam FLUX_EN                             = 0;
  localparam SRC_LANE_INDEX                      = 0;
  localparam LEADER_LANE                         = 1;
  localparam SIM_SCALE_DOWN                      = 0;


  //---------------------------------------- Register and Wire declaration----------------------------
  // All internal wire decalration are 2D.

  // HAL => SIP ATOM 
  logic  [num_of_lanes-1:0]           w_hio_rstepcs_rx_pcs_fully_aligned   ;
  logic  [num_of_lanes-1:0]           w_hio_rst_flux0_cpi_cmn_busy         ;
  logic  [num_of_lanes-1:0]           w_hio_rst_oflux_rx_srds_rdy          ;
  logic  [num_of_lanes-1:0]           w_hio_rstfec_fec_rx_rdy_n            ;

  // SIP ATOM => HAL 
  logic  [num_of_lanes-1:0]           w_hio_ptp_rst_n                      ;
  logic  [num_of_lanes-1:0]           w_hio_ehip_rx_rst_n                  ;
  logic  [num_of_lanes-1:0]           w_hio_ehip_tx_rst_n                  ;
  logic  [num_of_lanes-1:0]           w_hio_ehip_signal_ok                 ;
  logic  [num_of_lanes-1:0]           w_hio_sfreeze_2_r03f_rx_mac_srfz_n   ;  //doubt
  logic  [num_of_lanes-1:0]           w_hio_sfreeze_3_c2f_tx_deskew_srfz_n ;
  logic  [num_of_lanes-1:0]           w_hio_t03f_sfreeze_1_tx_pcs_sfrz_n   ;
  logic  [num_of_lanes-1:0]           w_hio_rstfec_fec_rx_rst_n            ;
  logic  [num_of_lanes-1:0]           w_hio_rstfec_fec_tx_rst_n            ;
  logic  [num_of_lanes-1:0]           w_hio_rstfec_fec_csr_ret             ;
  logic  [num_of_lanes-1:0]           w_hio_rstfec_rx_fec_sfrz_n           ;
  logic  [num_of_lanes-1:0]           w_hio_rstfec_tx_fec_sfrz_n           ;
  logic  [num_of_lanes-1:0]           w_hio_rstxcvrif_xcvrif_rx_rst_n      ;
  logic  [num_of_lanes-1:0]           w_hio_rstxcvrif_xcvrif_tx_rst_n      ;
  logic  [num_of_lanes-1:0]           w_hio_rstxcvrif_xcvrif_signal_ok     ;
  logic  [num_of_lanes-1:0]           w_hio_rstxcvrif_rx_xcvrif_sfrz_n     ;
  logic  [num_of_lanes-1:0]           w_hio_rstxcvrif_tx_xcvrif_sfrz_n     ;
  logic  [num_of_lanes-1:0]           w_hio_rst_pld_clrhip                 ;  //to SRC doubt
  logic  [num_of_lanes-1:0]           w_hio_rst_pld_clrpcs                 ;  //to SRC doubt
  logic  [num_of_lanes-1:0]           w_hio_rst_pld_perstn                 ;  //to SRC doubt
  logic  [num_of_lanes-1:0]           w_hio_rst_pld_ready                  ;
  logic  [num_of_lanes-1:0]           w_hio_rst_pld_adapter_rx_pld_rst_n   ;
  logic  [num_of_lanes-1:0]           w_hio_rst_pld_adapter_tx_pld_rst_n   ;
  logic  [num_of_lanes-1:0]           w_hio_rst_ux_rx_pma_rst_n            ;
  logic  [num_of_lanes-1:0]           w_hio_rst_ux_rx_sfrz                 ;
  logic  [num_of_lanes-1:0]           w_hio_rst_ux_tx_pma_rst_n            ;
  // I/O <=> SIP ATOM <=> HAL
  logic  [num_of_lanes-1:0]          w_hio_pld_rx_clk_in_row_clk           ;
  logic  [num_of_lanes-1:0]          w_hio_pld_tx_clk_in_row_clk           ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_dl_clk               ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_mux_select           ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_sclk_flop            ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_sclk_gen_clk         ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_trig_flop            ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_sampling_clk            ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_dl_clk               ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_mux_select           ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_sclk_flop            ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_sclk_gen_clk         ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_trig_flop            ;
  logic  [num_of_lanes-1:0]          w_hio_user_rx_clk1_clk                ;
  logic  [num_of_lanes-1:0]          w_hio_user_rx_clk2_clk                ;
  logic  [num_of_lanes-1:0]          w_hio_user_tx_clk1_clk                ;
  logic  [num_of_lanes-1:0]          w_hio_user_tx_clk2_clk                ;
  logic  [num_of_lanes-1:0]          w_hio_ux_chnl_refclk_mux              ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_async_dl_sync        ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_async_pulse          ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_async_sample_sync    ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_sclk_sample_sync     ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_rx_trig_sample_sync     ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_async_dl_sync        ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_async_pulse          ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_async_sample_sync    ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_sclk_sample_sync     ;
  logic  [num_of_lanes-1:0]          w_hio_det_lat_tx_trig_sample_sync     ;
  logic  [num_of_lanes-1:0]          w_hio_xcvrif_rx_latency_pulse         ;
  logic  [num_of_lanes-1:0]          w_hio_xcvrif_tx_latency_pulse         ;
  logic  [(num_of_lanes*80)-1:0]     w_hio_txdata                          ;
  logic  [(num_of_lanes*10)-1:0]     w_hio_txdata_extra                    ;
  logic  [num_of_lanes-1:0]          w_hio_txdata_fifo_wr_en               ;
  logic  [num_of_lanes-1:0]          w_hio_rxdata_fifo_rd_en               ;
  logic  [(num_of_lanes*80)-1:0]     w_hio_uxquad_async_i                  ;
  logic  [(num_of_lanes*80)-1:0]     w_hio_uxquad_async_pcie_mux           ;
  logic  [num_of_lanes-1:0]          w_hio_txdata_fifo_wr_empty            ; 
  logic  [num_of_lanes-1:0]          w_hio_txdata_fifo_wr_pempty           ; 
  logic  [num_of_lanes-1:0]          w_hio_txdata_fifo_wr_full             ; 
  logic  [num_of_lanes-1:0]          w_hio_txdata_fifo_wr_pfull            ; 
  logic  [(num_of_lanes*80)-1:0]     w_hio_rxdata                          ; 
  logic  [(num_of_lanes*10)-1:0]     w_hio_rxdata_extra                    ; 
  logic  [num_of_lanes-1:0]          w_hio_rxdata_fifo_rd_empty            ; 
  logic  [num_of_lanes-1:0]          w_hio_rxdata_fifo_rd_pempty           ; 
  logic  [num_of_lanes-1:0]          w_hio_rxdata_fifo_rd_full             ; 
  logic  [num_of_lanes-1:0]          w_hio_rxdata_fifo_rd_pfull            ; 
  logic  [(num_of_lanes*50)-1:0]     w_hio_uxquad_async_o                  ; 
  logic  [(num_of_lanes*100)-1:0]    w_hio_txdata_async                    ; 
  logic  [(num_of_lanes*10)-1:0]     w_hio_txdata_direct                   ;
  logic  [(num_of_lanes*100)-1:0]    w_hio_rxdata_async                    ; 
  logic  [(num_of_lanes*10)-1:0]     w_hio_rxdata_direct                   ;  
  logic  [num_of_lanes-1:0]          w_hio_rst_ux_all_synthlockstatus      ; 
  logic  [num_of_lanes-1:0]          w_hio_rst_ux_octl_pcs_rxstatus        ; 
  logic  [num_of_lanes-1:0]          w_hio_rst_ux_octl_pcs_txstatus        ; 
  logic  [num_of_lanes-1:0]          w_hio_rst_ux_rxcdrlock2data           ; 
  logic  [num_of_lanes-1:0]          w_hio_rst_ux_rxcdrlockstatus          ; 
  logic  [num_of_lanes-1:0]          w_hio_pld_reset_clk_row               ; 
  logic  [num_of_lanes-1:0]          w_hio_ux_tx_ch_ptr_smpl               ;
  // Addr Decoder LAVMM <=> HAL 
  logic  [num_of_lanes-1:0]          w_hio_lavmm_clk                       ;   
  logic  [num_of_lanes-1:0]          w_hio_lavmm_rstn                      ;  
  logic  [num_of_lanes-1:0][20:0]    w_hio_lavmm_addr                      ;  
  logic  [num_of_lanes-1:0][3:0]     w_hio_lavmm_be                        ;
  logic  [num_of_lanes-1:0]          w_hio_lavmm_read                      ;  
  logic  [num_of_lanes-1:0]          w_hio_lavmm_write                     ;    
  logic  [num_of_lanes-1:0][31:0]    w_hio_lavmm_wdata                     ;    
  logic  [num_of_lanes-1:0][31:0]    w_hio_lavmm_rdata                     ;    
  logic  [num_of_lanes-1:0]          w_hio_lavmm_rdata_valid               ;          
  logic  [num_of_lanes-1:0]          w_hio_lavmm_waitreq                   ;      
  wire   [(num_of_lanes*num_of_lanes)-1:0]  w_sl2l_trigger_or_error_resp   ;
  wire   [(num_of_lanes*num_of_lanes)-1:0]  w_sl2l_desired_state_or_ready  ;
  wire   [(num_of_lanes*num_of_lanes)-1:0]  w_sl2l_tx_rx                   ;
  wire   [num_of_lanes-1:0]          w_addr_gen_common_block_rst_done_reg  ;
  // SRC -> PTP Ports
  logic  [num_of_lanes-1:0]          w_hio_ptp_rst_n_ptp                   ;         
  logic  [num_of_lanes-1:0]          w_hio_rst_pld_adapter_rx_pld_rst_n_ptp;                            
  logic  [num_of_lanes-1:0]          w_hio_rst_pld_adapter_tx_pld_rst_n_ptp;                            
  logic  [num_of_lanes-1:0]          w_hio_rst_pld_ready_ptp               ;   
  
  


  alt_mge_phy_0_n_channel_superset_hal_top_2100_ckyu45q #(
      .num_of_lanes                                          (num_of_lanes                          )                    
  ) hal_top_wrapper_inst (
      .i_refclk_tx_p                                         (i_refclk_tx_p                         ), 
//      .i_refclk_tx_n                                         (i_refclk_tx_n                         ), 
      .i_syspll_c0_clk                                       (i_syspll_c0_clk                       ), 
      .i_syspll_c1_clk                                       (i_syspll_c1_clk                       ), 
      .i_syspll_c2_clk                                       (i_syspll_c2_clk                       ), 
      .i_flux_clk_0                                          (i_flux_clk_0                          ), 
      .i_flux_clk_1                                          (i_flux_clk_1                          ), 
      .i_refclk_rx_p                                         (i_refclk_rx_p                         ), 
//      .i_refclk_rx_n                                         (i_refclk_rx_n                         ), 
      .i_hio_txdata                                          (w_hio_txdata                          ),
      .i_hio_txdata_extra                                    (w_hio_txdata_extra                    ),
      .i_hio_txdata_fifo_wr_en                               (w_hio_txdata_fifo_wr_en               ),
      .i_hio_rxdata_fifo_rd_en                               (w_hio_rxdata_fifo_rd_en               ),
      .i_hio_ehip_rx_rst_n                                   (w_hio_ehip_rx_rst_n                   ),        
      .i_hio_ehip_tx_rst_n                                   (w_hio_ehip_tx_rst_n                   ),        
      .i_hio_ehip_signal_ok                                  (w_hio_ehip_signal_ok                  ),        
      .i_hio_sfreeze_2_r03f_rx_mac_srfz_n                    (w_hio_sfreeze_2_r03f_rx_mac_srfz_n    ),        
      .i_hio_sfreeze_3_c2f_tx_deskew_srfz_n                  (w_hio_sfreeze_3_c2f_tx_deskew_srfz_n  ),        
      .i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n                    (w_hio_t03f_sfreeze_1_tx_pcs_sfrz_n    ),        
      .i_hio_rstfec_fec_rx_rst_n                             (w_hio_rstfec_fec_rx_rst_n             ),        
      .i_hio_rstfec_fec_tx_rst_n                             (w_hio_rstfec_fec_tx_rst_n             ),        
      .i_hio_rstfec_fec_csr_ret                              (w_hio_rstfec_fec_csr_ret              ),        
      .i_hio_rstfec_rx_fec_sfrz_n                            (w_hio_rstfec_rx_fec_sfrz_n            ),        
      .i_hio_rstfec_tx_fec_sfrz_n                            (w_hio_rstfec_tx_fec_sfrz_n            ),        
      .i_hio_rstxcvrif_xcvrif_rx_rst_n                       (w_hio_rstxcvrif_xcvrif_rx_rst_n       ),        
      .i_hio_rstxcvrif_xcvrif_tx_rst_n                       (w_hio_rstxcvrif_xcvrif_tx_rst_n       ),        
      .i_hio_rstxcvrif_xcvrif_signal_ok                      (w_hio_rstxcvrif_xcvrif_signal_ok      ),        
      .i_hio_rstxcvrif_rx_xcvrif_sfrz_n                      (w_hio_rstxcvrif_rx_xcvrif_sfrz_n      ),        
      .i_hio_rstxcvrif_tx_xcvrif_sfrz_n                      (w_hio_rstxcvrif_tx_xcvrif_sfrz_n      ),        
      .i_hio_rst_pld_clrhip                                  (w_hio_rst_pld_clrhip                  ),        
      .i_hio_rst_pld_clrpcs                                  (w_hio_rst_pld_clrpcs                  ),        
      .i_hio_rst_pld_perstn                                  (w_hio_rst_pld_perstn                  ),        
      .i_hio_rst_pld_ready                                   (w_hio_rst_pld_ready                   ),        
      .i_hio_rst_pld_adapter_rx_pld_rst_n                    (w_hio_rst_pld_adapter_rx_pld_rst_n    ),        
      .i_hio_rst_pld_adapter_tx_pld_rst_n                    (w_hio_rst_pld_adapter_tx_pld_rst_n    ),        
      .i_hio_rst_ux_rx_pma_rst_n                             (w_hio_rst_ux_rx_pma_rst_n             ),        
      .i_hio_rst_ux_rx_sfrz                                  (w_hio_rst_ux_rx_sfrz                  ),        
      .i_hio_rst_ux_tx_pma_rst_n                             (w_hio_rst_ux_tx_pma_rst_n             ),
      .i_hio_pld_reset_clk_row                               (w_hio_pld_reset_clk_row               ),
      .i_hio_uxquad_async                                    (w_hio_uxquad_async_i                  ),
      .i_hio_uxquad_async_pcie_mux                           (w_hio_uxquad_async_pcie_mux           ),
      .i_hio_ch0_lavmm_addr                              (w_hio_lavmm_addr[0]                       ),
      .i_hio_ch0_lavmm_be                                (w_hio_lavmm_be[0]                         ),
      .i_hio_ch0_lavmm_read                              (w_hio_lavmm_read[0]                       ),
      .i_hio_ch0_lavmm_wdata                             (w_hio_lavmm_wdata[0]                      ),
      .i_hio_ch0_lavmm_write                             (w_hio_lavmm_write[0]                      ),
      .o_hio_ch0_lavmm_rdata                             (w_hio_lavmm_rdata[0]                      ),
      .o_hio_ch0_lavmm_rdata_valid                       (w_hio_lavmm_rdata_valid[0]                ),
      .o_hio_ch0_lavmm_waitreq                           (w_hio_lavmm_waitreq[0]                    ),
      .i_hio_ch0_lavmm_clk                               (w_hio_lavmm_clk[0]                        ),
      .i_hio_ch0_lavmm_rstn                              (w_hio_lavmm_rstn[0]                       ),
      .i_hio_ch0_pld_rx_clk_in_row_clk                   (w_hio_pld_rx_clk_in_row_clk[0]            ),
      .i_hio_ch0_pld_tx_clk_in_row_clk                   (w_hio_pld_tx_clk_in_row_clk[0]            ),
      .i_hio_ch0_det_lat_rx_dl_clk                       (w_hio_det_lat_rx_dl_clk[0]                ),
      .i_hio_ch0_det_lat_rx_mux_select                   (w_hio_det_lat_rx_mux_select[0]            ),
      .i_hio_ch0_det_lat_rx_sclk_flop                    (w_hio_det_lat_rx_sclk_flop[0]             ),
      .i_hio_ch0_det_lat_rx_sclk_gen_clk                 (w_hio_det_lat_rx_sclk_gen_clk[0]          ),
      .i_hio_ch0_det_lat_rx_trig_flop                    (w_hio_det_lat_rx_trig_flop[0]             ),
      .i_hio_ch0_det_lat_sampling_clk                    (w_hio_det_lat_sampling_clk[0]             ),
      .i_hio_ch0_det_lat_tx_dl_clk                       (w_hio_det_lat_tx_dl_clk[0]                ),
      .i_hio_ch0_det_lat_tx_mux_select                   (w_hio_det_lat_tx_mux_select[0]            ),
      .i_hio_ch0_det_lat_tx_sclk_flop                    (w_hio_det_lat_tx_sclk_flop[0]             ),
      .i_hio_ch0_det_lat_tx_sclk_gen_clk                 (w_hio_det_lat_tx_sclk_gen_clk[0]          ),
      .i_hio_ch0_det_lat_tx_trig_flop                    (w_hio_det_lat_tx_trig_flop[0]             ),
      .o_hio_ch0_det_lat_rx_async_dl_sync                (w_hio_det_lat_rx_async_dl_sync[0]         ),
      .o_hio_ch0_det_lat_rx_async_pulse                  (w_hio_det_lat_rx_async_pulse[0]           ),
      .o_hio_ch0_det_lat_rx_async_sample_sync            (w_hio_det_lat_rx_async_sample_sync[0]     ),
      .o_hio_ch0_det_lat_rx_sclk_sample_sync             (w_hio_det_lat_rx_sclk_sample_sync[0]      ),
      .o_hio_ch0_det_lat_rx_trig_sample_sync             (w_hio_det_lat_rx_trig_sample_sync[0]      ),
      .o_hio_ch0_det_lat_tx_async_dl_sync                (w_hio_det_lat_tx_async_dl_sync[0]         ),
      .o_hio_ch0_det_lat_tx_async_pulse                  (w_hio_det_lat_tx_async_pulse[0]           ),
      .o_hio_ch0_det_lat_tx_async_sample_sync            (w_hio_det_lat_tx_async_sample_sync[0]     ),
      .o_hio_ch0_det_lat_tx_sclk_sample_sync             (w_hio_det_lat_tx_sclk_sample_sync[0]      ),
      .o_hio_ch0_det_lat_tx_trig_sample_sync             (w_hio_det_lat_tx_trig_sample_sync[0]      ),
      .o_hio_ch0_xcvrif_rx_latency_pulse                 (w_hio_xcvrif_rx_latency_pulse[0]          ),
      .o_hio_ch0_xcvrif_tx_latency_pulse                 (w_hio_xcvrif_tx_latency_pulse[0]          ),
      .o_hio_ch0_ux_chnl_refclk_mux                      (w_hio_ux_chnl_refclk_mux[0]               ),
      .o_hio_ch0_user_rx_clk1_clk                        (w_hio_user_rx_clk1_clk[0]                 ),
      .o_hio_ch0_user_rx_clk2_clk                        (w_hio_user_rx_clk2_clk[0]                 ),
      .o_hio_ch0_user_tx_clk1_clk                        (w_hio_user_tx_clk1_clk[0]                 ),
      .o_hio_ch0_user_tx_clk2_clk                        (w_hio_user_tx_clk2_clk[0]                 ),

      .rx_serial_n                                           (rx_serial_n                           ),
      .rx_serial_p                                           (rx_serial_p                           ),
      .o_hio_rxdata                                          (w_hio_rxdata                          ),
      .o_hio_rstepcs_rx_pcs_fully_aligned                    (w_hio_rstepcs_rx_pcs_fully_aligned    ),
      .o_hio_rstfec_fec_rx_rdy_n                             (w_hio_rstfec_fec_rx_rdy_n             ),
      .o_hio_rst_flux0_cpi_cmn_busy                          (w_hio_rst_flux0_cpi_cmn_busy          ),
      .o_hio_rst_oflux_rx_srds_rdy                           (w_hio_rst_oflux_rx_srds_rdy           ),
      .o_hio_rst_ux_all_synthlockstatus                      (w_hio_rst_ux_all_synthlockstatus      ),
      .o_hio_rst_ux_octl_pcs_rxstatus                        (w_hio_rst_ux_octl_pcs_rxstatus        ),
      .o_hio_rst_ux_octl_pcs_txstatus                        (w_hio_rst_ux_octl_pcs_txstatus        ),
      .o_hio_rst_ux_rxcdrlock2data                           (w_hio_rst_ux_rxcdrlock2data           ),
      .o_hio_rst_ux_rxcdrlockstatus                          (w_hio_rst_ux_rxcdrlockstatus          ),
      .o_hio_uxquad_async                                    (w_hio_uxquad_async_o                  ),
      .tx_serial_p                                           (tx_serial_p                           ),
      .tx_serial_n                                           (tx_serial_n                           ),
      .i_hio_txdata_async                                    (w_hio_txdata_async                    ),
      .i_hio_txdata_direct                                   (w_hio_txdata_direct                   ),
      .o_hio_txdata_fifo_wr_empty                            (w_hio_txdata_fifo_wr_empty            ),
      .o_hio_txdata_fifo_wr_pempty                           (w_hio_txdata_fifo_wr_pempty           ),
      .o_hio_txdata_fifo_wr_full                             (w_hio_txdata_fifo_wr_full             ),
      .o_hio_txdata_fifo_wr_pfull                            (w_hio_txdata_fifo_wr_pfull            ),
      .o_hio_rxdata_fifo_rd_empty                            (w_hio_rxdata_fifo_rd_empty            ),
      .o_hio_rxdata_fifo_rd_pempty                           (w_hio_rxdata_fifo_rd_pempty           ),
      .o_hio_rxdata_fifo_rd_full                             (w_hio_rxdata_fifo_rd_full             ),
      .o_hio_rxdata_fifo_rd_pfull                            (w_hio_rxdata_fifo_rd_pfull            ),
      .o_hio_rxdata_async                                    (w_hio_rxdata_async                    ),
      .o_hio_rxdata_direct                                   (w_hio_rxdata_direct                   ),
      .o_hio_rxdata_extra                                    (w_hio_rxdata_extra                    ),
      
      // .o_hio_ux_tx_ch_ptr_smpl                               (w_hio_ux_tx_ch_ptr_smpl               ),
      .ioack_cdrdiv_left_ux_bidir_out                        (o_cdrdiv_clk                          )
    ) ;


      
  //-------------------------------------------------------------------------------------------------
  // NCSS Common SIP Top module instantiation for SRC LANE and Decoder
  //-------------------------------------------------------------------------------------------------
  tennm_sm_hssi_pld_chnl_dp_sip_atom #(
    //Parameters are unique to each SRC Lane , QHIP will share dedicated parameters to each SRC lane in QHIP
    .NUM_LANES                                  (num_of_lanes                                          ),
    .TX_ENABLE                                  (TX_ENABLE [0]                                      ), 
    .RX_ENABLE                                  (RX_ENABLE [0]                                      ),     
    .TX_INITIATOR                               (TX_INITIATOR [0]                                   ),
    .RX_INITIATOR                               (RX_INITIATOR [0]                                   ),
    .TX_INITIATOR_INDEX                         (TX_INITIATOR_INDEX [(((0+1)*4)-1):0*4]          ),
    .RX_INITIATOR_INDEX                         (RX_INITIATOR_INDEX [(((0+1)*4)-1):0*4]          ),
    .TX_TARGET_ENABLE                           (TX_TARGET_ENABLE   [(((0+1)*num_of_lanes)-1):0*num_of_lanes] ),
    .RX_TARGET_ENABLE                           (RX_TARGET_ENABLE   [(((0+1)*num_of_lanes)-1):0*num_of_lanes] ),    
    .TX_LANE_FUCTIONAL_MODE                     (TX_LANE_FUCTIONAL_MODE[(((0+1)*5)-1):0*5]       ),
    .RX_LANE_FUCTIONAL_MODE                     (RX_LANE_FUCTIONAL_MODE[(((0+1)*5)-1):0*5]       ),
    .NON_PTP_CHANNEL                            (NON_PTP_CHANNEL [0]                                ),
    .TX_PCS_EN                                  (TX_PCS_EN [0]                                      ),
    .RX_PCS_EN                                  (RX_PCS_EN [0]                                      ),
    .UX_EN                                      (UX_EN  [0]                                         ),
    .TX_DL_EN                                   (TX_DL_EN  [0]                                      ),
    .RX_DL_EN                                   (RX_DL_EN  [0]                                      ),
`ifdef ALTERA_RESERVED_QIS
    .FLUX_USED_FOR_RX_ADAPTATION                ( 1 ),
    .FLUX_EN                                    ( 1 ),  
`else
    .FLUX_USED_FOR_RX_ADAPTATION                (FLUX_USED_FOR_RX_ADAPTATION [0]                    ), 
    .FLUX_EN                                    (FLUX_EN  [0]                                       ),   
`endif  
    .PTP_EN                                     (PTP_EN  [0]                                        ),
    .TX_FEC_EN                                  (TX_FEC_EN  [0]                                     ),
    .RX_FEC_EN                                  (RX_FEC_EN  [0]                                     ),
    .ETHERNET_SYSPLL_CLK_MODE                   (ETHERNET_SYSPLL_CLK_MODE [0]                       ),
    .UX_USING_SYSPLL_CLK                        (UX_USING_SYSPLL_CLK      [0]                       ),
    .FLUX_USING_SYSPLL_CLK                      (FLUX_USING_SYSPLL_CLK    [0]                       ),
    .SRC_LANE_INDEX                             (SRC_LANE_INDEX [(((0+1)*4)-1):0*4]              ),
    .LEADER_LANE                                (LEADER_LANE [0]                                    ),
    .SIM_SCALE_DOWN                             (SIM_SCALE_DOWN                                        )
  ) ncss_common_sip_top_0 (
    //SRC Lane Control Interface with SIP (or DR MUX)
    .tx_lane_desired_state                      (i_tx_lane_desired_state[0]                         ),
    .tx_lane_current_state                      (o_tx_lane_current_state[(((0+1)*2)-1):0*2]      ),                 
    .tx_alarm                                   (o_tx_alarm[0]                                      ), 
    .tx_clear_alarm                             (i_tx_clear_alarm[0]                                ),
    .rx_lane_desired_state                      (i_rx_lane_desired_state[0]                         ),
    .rx_lane_current_state                      (o_rx_lane_current_state[(((0+1)*2)-1):0*2]      ),
    .rx_alarm                                   (o_rx_alarm[0]                                      ),
    .rx_clear_alarm                             (i_rx_clear_alarm[0]                                ),
    .sip_rx_ignore_lock2data                    (i_sip_rx_ignore_lock2data[0]                       ),
    .sip_freeze_tx_SRC_sequence                 (i_sip_freeze_tx_SRC_sequence[0]                    ),
    .sip_freeze_rx_SRC_sequence                 (i_sip_freeze_rx_SRC_sequence[0]                    ),
    .sip_freeze_tx_acknowledge                  (o_sip_freeze_tx_acknowledge[0]                     ),
    .sip_freeze_rx_acknowledge                  (o_sip_freeze_rx_acknowledge[0]                     ),
    .sip_am_gen_start                           (o_sip_am_gen_start[0]                              ),
    .sip_am_gen_2x_ack                          (i_sip_am_gen_2x_ack[0]                             ),
    //Reset/Status Interface to HIP
    // SRC Lane to HAL interfaaces
    .d_i_hio_rst_pld_adapter_tx_pld_rst_n       (w_hio_rst_pld_adapter_tx_pld_rst_n[0]              ),             
    .d_i_hio_rst_pld_adapter_rx_pld_rst_n       (w_hio_rst_pld_adapter_rx_pld_rst_n[0]              ),            
    .d_i_hio_ehip_tx_rst_n                      (w_hio_ehip_tx_rst_n[0]                             ),
    .d_i_hio_ehip_rx_rst_n                      (w_hio_ehip_rx_rst_n[0]                             ),
    .d_i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n       (w_hio_t03f_sfreeze_1_tx_pcs_sfrz_n[0]              ),
    .d_i_hio_sfreeze_2_r03f_rx_mac_srfz_n       (w_hio_sfreeze_2_r03f_rx_mac_srfz_n[0]              ),        
    .d_i_hio_sfreeze_3_c2f_tx_deskew_srfz_n     (w_hio_sfreeze_3_c2f_tx_deskew_srfz_n[0]            ),     
    .d_i_hio_rstfec_fec_tx_rst_n                (w_hio_rstfec_fec_tx_rst_n[0]                       ), 
    .d_i_hio_rstfec_fec_rx_rst_n                (w_hio_rstfec_fec_rx_rst_n[0]                       ), 
    .d_i_hio_rstfec_fec_csr_ret                 (w_hio_rstfec_fec_csr_ret[0]                        ),  
    .d_i_hio_rstfec_tx_fec_sfrz_n               (w_hio_rstfec_tx_fec_sfrz_n[0]                      ), 
    .d_i_hio_rstfec_rx_fec_sfrz_n               (w_hio_rstfec_rx_fec_sfrz_n[0]                      ), 
    .d_i_hio_rstxcvrif_xcvrif_tx_rst_n          (w_hio_rstxcvrif_xcvrif_tx_rst_n[0]                 ),     
    .d_i_hio_rstxcvrif_xcvrif_rx_rst_n          (w_hio_rstxcvrif_xcvrif_rx_rst_n[0]                 ),     
    .d_i_hio_rstxcvrif_tx_xcvrif_sfrz_n         (w_hio_rstxcvrif_tx_xcvrif_sfrz_n[0]                ),    
    .d_i_hio_rstxcvrif_rx_xcvrif_sfrz_n         (w_hio_rstxcvrif_rx_xcvrif_sfrz_n[0]                ),    
    .d_i_hio_rstxcvrif_xcvrif_signal_ok         (w_hio_rstxcvrif_xcvrif_signal_ok[0]                ),     
    .d_i_hio_rst_ux_tx_pma_rst_n                (w_hio_rst_ux_tx_pma_rst_n[0]                       ),    
    .d_i_hio_rst_ux_rx_pma_rst_n                (w_hio_rst_ux_rx_pma_rst_n[0]                       ),    
    .d_i_hio_rst_ux_rx_sfrz                     (w_hio_rst_ux_rx_sfrz[0]                            ), 
    .iflux_ingress_direct_231                   (iflux_ingress_direct_231[0]                        ),
    .d_i_hio_rst_pld_ready                      (w_hio_rst_pld_ready[0]                             ),
    // HAL to SRC Lane interfaaces
    .d_o_hio_rstepcs_rx_pcs_fully_aligned       (w_hio_rstepcs_rx_pcs_fully_aligned[0]              ),
    .o_hio_rstfec_fec_rx_rdy_n                  (o_hio_rstfec_fec_rx_rdy_n[0]                       ),
    .d_o_hio_rst_ux_octl_pcs_txstatus           (w_hio_rst_ux_octl_pcs_txstatus[0]                  ),
    .d_o_hio_rst_ux_octl_pcs_rxstatus           (w_hio_rst_ux_octl_pcs_rxstatus[0]                  ),
    .d_o_hio_rst_ux_all_synthlockstatus         (w_hio_rst_ux_all_synthlockstatus[0]                ),
    .d_o_hio_rst_ux_rxcdrlockstatus             (w_hio_rst_ux_rxcdrlockstatus[0]                    ),
    .d_o_hio_rst_ux_rxcdrlock2data              (w_hio_rst_ux_rxcdrlock2data[0]                     ),
    .d_o_hio_rstfec_fec_rx_rdy_n                (w_hio_rstfec_fec_rx_rdy_n[0]                       ),
    .d_o_hio_rst_flux0_cpi_cmn_busy             (w_hio_rst_flux0_cpi_cmn_busy[0]                    ),
    .o_hio_rst_flux0_cpi_cmn_busy               (o_hio_rst_flux0_cpi_cmn_busy[0]                    ),
    .d_o_hio_rst_oflux_rx_srds_rdy              (w_hio_rst_oflux_rx_srds_rdy[0]                     ),
    .o_hio_rst_oflux_rx_srds_rdy                (o_hio_rst_oflux_rx_srds_rdy[0]                     ),
    .i_spll_lock                                (i_spll_lock                                           ),   
    //Inter SRC Lane Interface
    .io_sl2l_trigger_or_error_resp              (w_sl2l_trigger_or_error_resp                          ),
    .io_sl2l_desired_state_or_ready             (w_sl2l_desired_state_or_ready                         ),
    .io_sl2l_tx_rx                              (w_sl2l_tx_rx                                          ),
    //DR Controller Interface
    .pause_request                              (pause_request[0]                                   ),
    .pause_grant                                (pause_grant[0]                                     ),
    //SRC Shoreline Sequencer Interface
    .sss_request                                (o_sss_req[0]                                       ),
    .sss_grant                                  (i_sss_grant[0]                                     ),
    //SRC FSM
    .io_addr_gen_common_block_rst_done_reg      (w_addr_gen_common_block_rst_done_reg                  ),          
    // User QHIP LAVMM <=> Decoder 
    .i_hio_lavmm_rstn                           (i_hio_ch0_lavmm_rstn                               ),            
    .i_hio_lavmm_clk                            (i_hio_ch0_lavmm_clk                                ),  
    .i_hio_lavmm_addr                           (i_hio_ch0_lavmm_addr                               ),                      
    .i_hio_lavmm_be                             (i_hio_ch0_lavmm_be                                 ),          
    .i_hio_lavmm_read                           (i_hio_ch0_lavmm_read                               ),            
    .i_hio_lavmm_write                          (i_hio_ch0_lavmm_write                              ),              
    .i_hio_lavmm_wdata                          (i_hio_ch0_lavmm_wdata                              ),              
    .o_hio_lavmm_rdata                          (o_hio_ch0_lavmm_rdata                              ),              
    .o_hio_lavmm_rdata_valid                    (o_hio_ch0_lavmm_rdata_valid                        ),                    
    .o_hio_lavmm_waitreq                        (o_hio_ch0_lavmm_waitreq                            ),                
    // Addr Decoder LAVMM <=> HAL 
    .d_i_hio_lavmm_rstn                         (w_hio_lavmm_rstn[0]                                ),            
    .d_i_hio_lavmm_clk                          (w_hio_lavmm_clk[0]                                 ), 
    .d_i_hio_lavmm_addr                         (w_hio_lavmm_addr[0]                                ),                      
    .d_i_hio_lavmm_be                           (w_hio_lavmm_be[0]                                  ),          
    .d_i_hio_lavmm_read                         (w_hio_lavmm_read[0]                                ),            
    .d_i_hio_lavmm_write                        (w_hio_lavmm_write[0]                               ),              
    .d_i_hio_lavmm_wdata                        (w_hio_lavmm_wdata[0]                               ),              
    .d_o_hio_lavmm_rdata                        (w_hio_lavmm_rdata[0]                               ),              
    .d_o_hio_lavmm_rdata_valid                  (w_hio_lavmm_rdata_valid[0]                         ),                    
    .d_o_hio_lavmm_waitreq                      (w_hio_lavmm_waitreq[0]                             ),
    // I/O <=> SIP ATOM <=> HA
    .i_hio_pld_rx_clk_in_row_clk                (i_hio_ch0_pld_rx_clk_in_row_clk                    ),
    .i_hio_pld_tx_clk_in_row_clk                (i_hio_ch0_pld_tx_clk_in_row_clk                    ),
    .i_hio_det_lat_rx_dl_clk                    (i_hio_ch0_det_lat_rx_dl_clk                        ),
    .i_hio_det_lat_rx_mux_select                (i_hio_ch0_det_lat_rx_mux_select                    ),
    .i_hio_det_lat_rx_sclk_flop                 (i_hio_ch0_det_lat_rx_sclk_flop                     ),
    .i_hio_det_lat_rx_sclk_gen_clk              (i_hio_ch0_det_lat_rx_sclk_gen_clk                  ),
    .i_hio_det_lat_rx_trig_flop                 (i_hio_ch0_det_lat_rx_trig_flop                     ),
    .i_hio_det_lat_sampling_clk                 (i_hio_ch0_det_lat_sampling_clk                     ),
    .i_hio_det_lat_tx_dl_clk                    (i_hio_ch0_det_lat_tx_dl_clk                        ),
    .i_hio_det_lat_tx_mux_select                (i_hio_ch0_det_lat_tx_mux_select                    ),
    .i_hio_det_lat_tx_sclk_flop                 (i_hio_ch0_det_lat_tx_sclk_flop                     ),
    .i_hio_det_lat_tx_sclk_gen_clk              (i_hio_ch0_det_lat_tx_sclk_gen_clk                  ),
    .i_hio_det_lat_tx_trig_flop                 (i_hio_ch0_det_lat_tx_trig_flop                     ),
    .o_hio_user_rx_clk1_clk                     (o_hio_ch0_user_rx_clk1_clk                         ),
    .o_hio_user_rx_clk2_clk                     (o_hio_ch0_user_rx_clk2_clk                         ),
    .o_hio_user_tx_clk1_clk                     (o_hio_ch0_user_tx_clk1_clk                         ),
    .o_hio_user_tx_clk2_clk                     (o_hio_ch0_user_tx_clk2_clk                         ),
    .o_hio_ux_chnl_refclk_mux                   (o_hio_ch0_ux_chnl_refclk_mux                       ),
    .o_hio_det_lat_rx_async_dl_sync             (o_hio_ch0_det_lat_rx_async_dl_sync                 ),
    .o_hio_det_lat_rx_async_pulse               (o_hio_ch0_det_lat_rx_async_pulse                   ),
    .o_hio_det_lat_rx_async_sample_sync         (o_hio_ch0_det_lat_rx_async_sample_sync             ),
    .o_hio_det_lat_rx_sclk_sample_sync          (o_hio_ch0_det_lat_rx_sclk_sample_sync              ),
    .o_hio_det_lat_rx_trig_sample_sync          (o_hio_ch0_det_lat_rx_trig_sample_sync              ),
    .o_hio_det_lat_tx_async_dl_sync             (o_hio_ch0_det_lat_tx_async_dl_sync                 ),
    .o_hio_det_lat_tx_async_pulse               (o_hio_ch0_det_lat_tx_async_pulse                   ),
    .o_hio_det_lat_tx_async_sample_sync         (o_hio_ch0_det_lat_tx_async_sample_sync             ),
    .o_hio_det_lat_tx_sclk_sample_sync          (o_hio_ch0_det_lat_tx_sclk_sample_sync              ),
    .o_hio_det_lat_tx_trig_sample_sync          (o_hio_ch0_det_lat_tx_trig_sample_sync              ),
    .o_hio_xcvrif_rx_latency_pulse              (o_hio_ch0_xcvrif_rx_latency_pulse                  ),
    .o_hio_xcvrif_tx_latency_pulse              (o_hio_ch0_xcvrif_tx_latency_pulse                  ),
    
    .d_i_hio_pld_rx_clk_in_row_clk              (w_hio_pld_rx_clk_in_row_clk[0]                     ),
    .d_i_hio_pld_tx_clk_in_row_clk              (w_hio_pld_tx_clk_in_row_clk[0]                     ),
    .d_i_hio_det_lat_rx_dl_clk                  (w_hio_det_lat_rx_dl_clk[0]                         ),
    .d_i_hio_det_lat_rx_mux_select              (w_hio_det_lat_rx_mux_select[0]                     ),
    .d_i_hio_det_lat_rx_sclk_flop               (w_hio_det_lat_rx_sclk_flop[0]                      ),
    .d_i_hio_det_lat_rx_sclk_gen_clk            (w_hio_det_lat_rx_sclk_gen_clk[0]                   ),
    .d_i_hio_det_lat_rx_trig_flop               (w_hio_det_lat_rx_trig_flop[0]                      ),
    .d_i_hio_det_lat_sampling_clk               (w_hio_det_lat_sampling_clk[0]                      ),
    .d_i_hio_det_lat_tx_dl_clk                  (w_hio_det_lat_tx_dl_clk[0]                         ),
    .d_i_hio_det_lat_tx_mux_select              (w_hio_det_lat_tx_mux_select[0]                     ),
    .d_i_hio_det_lat_tx_sclk_flop               (w_hio_det_lat_tx_sclk_flop[0]                      ),
    .d_i_hio_det_lat_tx_sclk_gen_clk            (w_hio_det_lat_tx_sclk_gen_clk[0]                   ),
    .d_i_hio_det_lat_tx_trig_flop               (w_hio_det_lat_tx_trig_flop[0]                      ), 
    .d_o_hio_user_rx_clk1_clk                   (w_hio_user_rx_clk1_clk[0]                          ),
    .d_o_hio_user_rx_clk2_clk                   (w_hio_user_rx_clk2_clk[0]                          ),
    .d_o_hio_user_tx_clk1_clk                   (w_hio_user_tx_clk1_clk[0]                          ),
    .d_o_hio_user_tx_clk2_clk                   (w_hio_user_tx_clk2_clk[0]                          ),
    .d_o_hio_ux_chnl_refclk_mux                 (w_hio_ux_chnl_refclk_mux[0]                        ),
    .d_o_hio_det_lat_rx_async_dl_sync           (w_hio_det_lat_rx_async_dl_sync[0]                  ),
    .d_o_hio_det_lat_rx_async_pulse             (w_hio_det_lat_rx_async_pulse[0]                    ),
    .d_o_hio_det_lat_rx_async_sample_sync       (w_hio_det_lat_rx_async_sample_sync[0]              ),
    .d_o_hio_det_lat_rx_sclk_sample_sync        (w_hio_det_lat_rx_sclk_sample_sync[0]               ),
    .d_o_hio_det_lat_rx_trig_sample_sync        (w_hio_det_lat_rx_trig_sample_sync[0]               ),
    .d_o_hio_det_lat_tx_async_dl_sync           (w_hio_det_lat_tx_async_dl_sync[0]                  ),
    .d_o_hio_det_lat_tx_async_pulse             (w_hio_det_lat_tx_async_pulse[0]                    ),
    .d_o_hio_det_lat_tx_async_sample_sync       (w_hio_det_lat_tx_async_sample_sync[0]              ),
    .d_o_hio_det_lat_tx_sclk_sample_sync        (w_hio_det_lat_tx_sclk_sample_sync[0]               ),
    .d_o_hio_det_lat_tx_trig_sample_sync        (w_hio_det_lat_tx_trig_sample_sync[0]               ),
    .d_o_hio_xcvrif_rx_latency_pulse            (w_hio_xcvrif_rx_latency_pulse[0]                   ),
    .d_o_hio_xcvrif_tx_latency_pulse            (w_hio_xcvrif_tx_latency_pulse[0]                   ),

    .i_hio_txdata                           (i_hio_txdata[0*80 +: 80]                           ),
    .i_hio_txdata_extra                     (i_hio_txdata_extra[0*10 +: 10]                     ),
    .i_hio_txdata_fifo_wr_en                    (i_hio_txdata_fifo_wr_en[0]                         ),
    .i_hio_rxdata_fifo_rd_en                    (i_hio_rxdata_fifo_rd_en[0]                         ),
    .i_hio_uxquad_async_rx                      (i_hio_uxquad_async_rx[0*80 +: 80]                  ),
    .i_hio_uxquad_async_tx                      (i_hio_uxquad_async_tx[0*80 +: 80]                  ),
    .i_hio_uxquad_async_pcie_mux_rx             (i_hio_uxquad_async_pcie_mux_rx[0*80 +: 80]         ),
    .i_hio_uxquad_async_pcie_mux_tx             (i_hio_uxquad_async_pcie_mux_tx[0*80 +: 80]         ),
    .o_hio_txdata_fifo_wr_empty                 (o_hio_txdata_fifo_wr_empty[0]                      ),
    .o_hio_txdata_fifo_wr_pempty                (o_hio_txdata_fifo_wr_pempty[0]                     ),
    .o_hio_txdata_fifo_wr_full                  (o_hio_txdata_fifo_wr_full[0]                       ),
    .o_hio_txdata_fifo_wr_pfull                 (o_hio_txdata_fifo_wr_pfull[0]                      ),
    .o_hio_rxdata                               (o_hio_rxdata[0*80 +: 80]                           ),
    .o_hio_rxdata_extra                         (o_hio_rxdata_extra[0*10 +: 10]                     ),
    .o_hio_rxdata_fifo_rd_empty                 (o_hio_rxdata_fifo_rd_empty[0]                      ),
    .o_hio_rxdata_fifo_rd_pempty                (o_hio_rxdata_fifo_rd_pempty[0]                     ),
    .o_hio_rxdata_fifo_rd_full                  (o_hio_rxdata_fifo_rd_full[0]                       ),
    .o_hio_rxdata_fifo_rd_pfull                 (o_hio_rxdata_fifo_rd_pfull[0]                      ),
    .o_hio_uxquad_async_rx                      (o_hio_uxquad_async_rx[0*50 +: 50]                  ),
    .o_hio_uxquad_async_tx                      (o_hio_uxquad_async_tx[0*50 +: 50]                  ),
    .i_hio_txdata_async_rx                      (i_hio_txdata_async_rx[0*100 +: 100]                ),
    .i_hio_txdata_async_tx                      (i_hio_txdata_async_tx[0*100 +: 100]                ),
    .i_hio_txdata_direct                        (i_hio_txdata_direct[0*10 +: 10]                    ),
    .o_hio_rxdata_async_rx                      (o_hio_rxdata_async_rx[0*100 +: 100]                ),
    .o_hio_rxdata_async_tx                      (o_hio_rxdata_async_tx[0*100 +: 100]                ),
    .o_hio_rxdata_direct                        (o_hio_rxdata_direct[0*10 +: 10]                    ),
    .o_hio_rst_ux_octl_pcs_txstatus             (o_hio_rst_ux_octl_pcs_txstatus[0]                  ),
    .o_hio_rst_ux_octl_pcs_rxstatus             (o_hio_rst_ux_octl_pcs_rxstatus[0]                  ),
    .o_hio_rst_ux_all_synthlockstatus           (o_hio_rst_ux_all_synthlockstatus[0]                ),
    .o_hio_rst_ux_rxcdrlockstatus               (o_hio_rst_ux_rxcdrlockstatus[0]                    ),
    .o_hio_rst_ux_rxcdrlock2data                (o_hio_rst_ux_rxcdrlock2data[0]                     ),
    .i_hio_ehip_signal_ok                       (i_hio_ehip_signal_ok[0]                            ),

    .d_i_hio_txdata                             (w_hio_txdata[0*80 +: 80]                           ),
    .d_i_hio_txdata_extra                       (w_hio_txdata_extra[0*10 +: 10]                     ),
    .d_i_hio_txdata_fifo_wr_en                  (w_hio_txdata_fifo_wr_en[0]                         ),
    .d_i_hio_rxdata_fifo_rd_en                  (w_hio_rxdata_fifo_rd_en[0]                         ),
    .d_i_hio_uxquad_async                       (w_hio_uxquad_async_i[0*80 +: 80]                   ),
    .d_i_hio_uxquad_async_pcie_mux              (w_hio_uxquad_async_pcie_mux[0*80 +: 80]            ),
    .d_o_hio_txdata_fifo_wr_empty               (w_hio_txdata_fifo_wr_empty[0]                      ),
    .d_o_hio_txdata_fifo_wr_pempty              (w_hio_txdata_fifo_wr_pempty[0]                     ),
    .d_o_hio_txdata_fifo_wr_full                (w_hio_txdata_fifo_wr_full[0]                       ),
    .d_o_hio_txdata_fifo_wr_pfull               (w_hio_txdata_fifo_wr_pfull[0]                      ),
    .d_o_hio_rxdata                             (w_hio_rxdata[0*80 +: 80]                           ),
    .d_o_hio_rxdata_extra                       (w_hio_rxdata_extra[0*10 +: 10]                     ),
    .d_o_hio_rxdata_fifo_rd_empty               (w_hio_rxdata_fifo_rd_empty[0]                      ),
    .d_o_hio_rxdata_fifo_rd_pempty              (w_hio_rxdata_fifo_rd_pempty[0]                     ),
    .d_o_hio_rxdata_fifo_rd_full                (w_hio_rxdata_fifo_rd_full[0]                       ),
    .d_o_hio_rxdata_fifo_rd_pfull               (w_hio_rxdata_fifo_rd_pfull[0]                      ),
    .d_o_hio_uxquad_async                       (w_hio_uxquad_async_o[0*50 +: 50]                   ),
    .d_i_hio_txdata_async                       (w_hio_txdata_async[0*100 +: 100]                   ),
    .d_i_hio_txdata_direct                      (w_hio_txdata_direct[0*10 +: 10]                    ),
    .d_o_hio_rxdata_async                       (w_hio_rxdata_async[0*100 +: 100]                   ),
    .d_o_hio_rxdata_direct                      (w_hio_rxdata_direct[0*10 +: 10]                    ),
    .d_i_hio_ehip_signal_ok                     (w_hio_ehip_signal_ok[0]                            ),
    .d_i_hio_pld_reset_clk_row                  (w_hio_pld_reset_clk_row[0]                         ),
    .o_hio_ux_tx_ch_ptr_smpl                    (o_hio_ux_tx_ch_ptr_smpl[0]                         ),
    .d_o_hio_ux_tx_ch_ptr_smpl                  (w_hio_ux_tx_ch_ptr_smpl[0]                         ),
    .d_i_hio_rst_pld_clrhip                     (w_hio_rst_pld_clrhip[0]                            ),
    .d_i_hio_rst_pld_clrpcs                     (w_hio_rst_pld_clrpcs[0]                            ),
    .d_i_hio_rst_pld_perstn                     (w_hio_rst_pld_perstn[0]                            ),
    // SRC -> PTP Ports
    .ptp_pld_adapter_tx_pld_rst_n               (w_hio_rst_pld_adapter_tx_pld_rst_n_ptp[0]          ),                  
    .ptp_pld_adapter_rx_pld_rst_n               (w_hio_rst_pld_adapter_rx_pld_rst_n_ptp[0]          ),                
    .ptp_pld_ready                              (w_hio_rst_pld_ready_ptp[0]                         ),
    .d_i_hio_ptp_rst_n                          (w_hio_ptp_rst_n_ptp[0]                             )
  );  



//PTP 
 
endmodule

