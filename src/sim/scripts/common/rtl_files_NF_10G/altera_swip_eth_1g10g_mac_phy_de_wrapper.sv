//`ifndef ALTERA_SWIP_ETH_1G10G_MAC_PHY_DE_WRAPPER__SV
//`define ALTERA_SWIP_ETH_1G10G_MAC_PHY_DE_WRAPPER__SV

module altera_swip_eth_1g10g_mac_phy_de_wrapper (
    
    input avalon_mm_csr_clk,
    input avalon_st_rx_clk,
    input avalon_st_tx_clk,
    input ref_clk,
    input reset,
    
    ////////////////////////////////////////////////////////////
    // Avalon-MM ports
    ////////////////////////////////////////////////////////////
    
    input   [31:0]  csr_address,
    input           csr_read,
    output  [31:0]  csr_readdata,
    input           csr_write,
    input   [31:0]  csr_writedata,
    output          csr_waitrequest,
    output          csr_readdatavalid,
    input   [2:0]   csr_burstcount,
    input   [3:0]   csr_byteenable,
    input           csr_debugaccess,
    
    
    
    ////////////////////////////////////////////////////////////
    // Transmit path of the DUT
    ////////////////////////////////////////////////////////////
    
    
    // Avalon-ST signals to the MAC
    input   [63:0]  avalon_st_tx_sink_data,
    input           avalon_st_tx_sink_sop,
    input           avalon_st_tx_sink_eop,
    input   [2:0]   avalon_st_tx_sink_empty,
    output          avalon_st_tx_sink_ready,
    input           avalon_st_tx_sink_valid,
    input   [0:0]   avalon_st_tx_sink_error,
    
    
    
    ////////////////////////////////////////////////////////////
    // Receive path of the DUT
    ////////////////////////////////////////////////////////////
    
    // Avalon-ST signals from the MAC
    output  [63:0]  avalon_st_rx_src_data,
    output          avalon_st_rx_src_sop,
    output          avalon_st_rx_src_eop,
    output  [2:0]   avalon_st_rx_src_empty,
    input           avalon_st_rx_src_ready,
    output          avalon_st_rx_src_valid,
    output  [5:0]   avalon_st_rx_src_error,
    
    
   output   sgmii_tx_out,
   input    sgmii_rx_in,
   output   xg_base_r_tx_out,
   input    xg_base_r_rx_in,
   output   xcvr_atx_pll_a10_0_pll_locked_pll_locked,
   output   xcvr_10gkr_a10_0_rx_data_ready_export 
);
    
    
    // Generate 125Mhz clock    
    logic clk_1g_ref;
    logic clk_10g_ref;
    logic reconfig_req;
    logic reconfig_busy;
    `define ETH_XSBI_CLOCK         (1551.52/2.0) 
      
    assign clk_1g_ref = eth_env_top.svt_ethernet_txrx_if[0].gmii_tx_clk;
    initial clk_10g_ref = 1'b0;
    always #((`ETH_XSBI_CLOCK))          clk_10g_ref  = ~clk_10g_ref ;

    
    // Connectivity for U_DUT
    //logic [71:0] xgmii_tx;
    //logic [71:0] xgmii_rx;

    logic pll_locked;
    
    wire                pll_powerdown_1g;
    wire                pll_powerdown_10g;
        
    wire    [15:0]      reconfig_mif_readdata;
    wire                reconfig_mif_read;
    wire    [15:0]      reconfig_mif_address;
    wire                reconfig_mif_waitrequest;
    
    wire                reconfig_mgmt_waitrequest;
    wire    [31:0]      reconfig_mgmt_writedata;
    wire                reconfig_mgmt_write;
    wire    [6:0]       reconfig_mgmt_address;
    wire    [31:0]      reconfig_mgmt_readdata;
    wire                reconfig_mgmt_read;
    
    wire                rst_cntlr_pll_powerdown;
    wire                rst_cntlr_tx_analogreset;
    wire                rst_cntlr_tx_digitalreset;
    wire                rst_cntlr_rx_analogreset;
    wire                rst_cntlr_rx_digitalreset;
    wire                usr_an_lt_reset;
    wire                usr_seq_reset;
    wire [209:0]        reconfig_to_xcvr;
    wire [137:0]        reconfig_from_xcvr;
    wire                phy_pll_locked;
    wire                pll156M_locked;
    wire                hdsk_rc_busy;    
    wire [5:0]          seq_pcs_mode;
    wire [5:0]          seq_pma_vod;
    wire [4:0]          seq_pma_postap1;
    wire [3:0]          seq_pma_pretap;
    wire [2:0]          tap_to_upd;
    wire                seq_start_rc;
    wire                lt_start_rc;
    wire                en_lcl_rxeq;
    wire                rxeq_done;
   
    wire                lcl_rf;
    wire                dmi_mode_en; 
    wire                dmi_frame_lock; 
    wire                dmi_rmt_rx_ready; 
    wire [5:0]          dmi_lcl_coefl; 
    wire [13:12]        dmi_lcl_coefh; 
    wire                dmi_lcl_upd_new; 
    wire                dmi_rx_trained; 
    wire                dmo_frame_lock; 
    wire                dmo_rmt_rx_ready; 
    wire [5:0]          dmo_lcl_coefl; 
    wire [13:12]        dmo_lcl_coefh; 
    wire                dmo_lcl_upd_new; 
    wire                dmo_rx_trained; 
    
    wire                rx_is_lockedtodata;
    
    wire                tx_cal_busy;
    wire                rx_cal_busy;
    wire                pll_cal_busy;
    wire                tx_analogreset;
    wire                tx_clkout_1g_clk;
    wire                rx_clkout_1g_clk;
    wire                rx_10g_blksync_lock;
    wire                rx_hi_ber;
    wire                generic_pll_rst;
    wire                reconfig_busy_rc;
    wire                rx_coreclkin_1g;
    wire                tx_coreclkin_1g;
    wire                rx_analogreset;
    wire                mode_1g_10gbar;
    wire                reset_rc_to_phy;
    wire                rx_syncstatus;
    wire                rx_10g_blk_lock;
    wire                tx_digitalreset;
    wire                rx_digitalreset;
    wire                rx_digitalreset_n;
    wire                tx_digitalreset_n;
    wire                generic_pll_reset;
    wire                baser_ll_mif_done;
    wire                rx_sync_lock;
    wire [71:0] xgmii_rx;
    wire [71:0] xgmii_tx;

`ifdef ETH_QUAD_SPEED_MAC
    wire [1:0]     speed_select;
    wire           tx_clkena;
    wire           rx_clkena;
    wire           tx_clkena_half_rate;
    wire           rx_clkena_half_rate;
    wire [3:0]     mii_tx_d_export;
    wire           mii_tx_en_export;
    wire           mii_tx_err_export;
    wire [3:0]     mii_rx_d_export;
    wire           mii_rx_en_export;
    wire           mii_rx_err_export;
`else

`endif
    
    assign tx_digitalreset_n = !tx_digitalreset;
    assign rx_digitalreset_n = !rx_digitalreset;
    
    
 // chethan altera_eth_10g_mac_1g10g_phy_10g_mode_de U_DUT (
altera_eth_10g_mac_nf_phy U_DUT (
        .mm_clk_clk                                                  (avalon_mm_csr_clk),                                                  //                                          mm_clk.clk
        .mm_reset_reset_n                                            (~reset),                                            //                                        mm_reset.reset_n
        .ref_clk_10g_clk_clk                                         (clk_10g_ref),                                         //                                 ref_clk_10g_clk.clk
        .ref_clk_10g_reset_reset_n                                   (~reset),                                   //                               ref_clk_10g_reset.reset_n
        .ref_clk_1g_clk_clk                                          (clk_1g_ref),                                          //                                  ref_clk_1g_clk.clk
        .ref_clk_1g_reset_reset_n                                    (~reset),                                    //                                ref_clk_1g_reset.reset_n
        .merlin_master_translator_0_avalon_anti_master_0_address     (csr_address),     // merlin_master_translator_0_avalon_anti_master_0.address
        .merlin_master_translator_0_avalon_anti_master_0_waitrequest (csr_waitrequest), //                                                .waitrequest
        .merlin_master_translator_0_avalon_anti_master_0_read        (csr_read),        //                                                .read
        .merlin_master_translator_0_avalon_anti_master_0_readdata    (csr_readdata),    //                                                .readdata
        .merlin_master_translator_0_avalon_anti_master_0_write       (csr_write),       //                                                .write
        .merlin_master_translator_0_avalon_anti_master_0_writedata   (csr_writedata),   //                                                .writedata
        .reset_controller_0_reset_in1_reset                          (baser_ll_mif_done),                          //                    reset_controller_0_reset_in1.reset
        .reset_controller_0_reset_in0_reset                          (reset),                          //                    reset_controller_0_reset_in0.reset
        .reset_controller_1_reset_in1_reset                          (),                          //                    reset_controller_1_reset_in1.reset
        .reset_controller_1_reset_in0_reset                          (),                          //                    reset_controller_1_reset_in0.reset
        .reset_controller_mac_tx_0_reset_in0_reset                   (reset),                   //             reset_controller_mac_tx_0_reset_in0.reset
        .reset_controller_mac_tx_0_reset_in1_reset                   (rst_cntlr_tx_digitalreset),                   //             reset_controller_mac_tx_0_reset_in1.reset
        .reset_controller_mac_tx_1_reset_in0_reset                   (),                   //             reset_controller_mac_tx_1_reset_in0.reset
        .reset_controller_mac_tx_1_reset_in1_reset                   (),                   //             reset_controller_mac_tx_1_reset_in1.reset
        .reset_controller_mac_rx_0_reset_in0_reset                   (reset),                   //             reset_controller_mac_rx_0_reset_in0.reset
        .reset_controller_mac_rx_0_reset_in1_reset                   (rst_cntlr_rx_digitalreset),                   //             reset_controller_mac_rx_0_reset_in1.reset
        .reset_controller_mac_rx_1_reset_in0_reset                   (),                   //             reset_controller_mac_rx_1_reset_in0.reset
        .reset_controller_mac_rx_1_reset_in1_reset                   (),                   //             reset_controller_mac_rx_1_reset_in1.reset
        .alt_em10g32_1_avalon_st_tx_startofpacket                    (),                    //                      alt_em10g32_1_avalon_st_tx.startofpacket
        .alt_em10g32_1_avalon_st_tx_endofpacket                      (),                      //                                                .endofpacket
        .alt_em10g32_1_avalon_st_tx_valid                            (),                            //                                                .valid
        .alt_em10g32_1_avalon_st_tx_data                             (),                             //                                                .data
        .alt_em10g32_1_avalon_st_tx_empty                            (),                            //                                                .empty
        .alt_em10g32_1_avalon_st_tx_error                            (),                            //                                                .error
        .alt_em10g32_1_avalon_st_tx_ready                            (),                            //                                                .ready
        .alt_em10g32_1_avalon_st_pause_data                          (0),       //this tied off is for xprop enabling due to seeing Z.
        .alt_em10g32_1_avalon_st_txstatus_valid                      (),                      //                alt_em10g32_1_avalon_st_txstatus.valid
        .alt_em10g32_1_avalon_st_txstatus_data                       (),                       //                                                .data
        .alt_em10g32_1_avalon_st_txstatus_error                      (),                      //                                                .error
        .alt_em10g32_1_avalon_st_rx_data                             (),                             //                      alt_em10g32_1_avalon_st_rx.data
        .alt_em10g32_1_avalon_st_rx_startofpacket                    (),                    //                                                .startofpacket
        .alt_em10g32_1_avalon_st_rx_valid                            (),                            //                                                .valid
        .alt_em10g32_1_avalon_st_rx_empty                            (),                            //                                                .empty
        .alt_em10g32_1_avalon_st_rx_error                            (),                            //                                                .error
        .alt_em10g32_1_avalon_st_rx_ready                            (),                            //                                                .ready
        .alt_em10g32_1_avalon_st_rx_endofpacket                      (),                      //                                                .endofpacket
        .alt_em10g32_1_avalon_st_rxstatus_valid                      (),                      //                alt_em10g32_1_avalon_st_rxstatus.valid
        .alt_em10g32_1_avalon_st_rxstatus_data                       (),                       //                                                .data
        .alt_em10g32_1_avalon_st_rxstatus_error                      (),                      //                                                .error
        .alt_em10g32_1_link_fault_status_xgmii_rx_data               (),               //        alt_em10g32_1_link_fault_status_xgmii_rx.data
        .alt_em10g32_0_link_fault_status_xgmii_rx_data               (),               //        alt_em10g32_0_link_fault_status_xgmii_rx.data
        .xcvr_10gkr_a10_0_led_an_export                              (),                              //                         xcvr_10gkr_a10_0_led_an.export
        .xcvr_10gkr_a10_0_led_char_err_export                        (),                        //                   xcvr_10gkr_a10_0_led_char_err.export
        .xcvr_10gkr_a10_0_led_disp_err_export                        (),                        //                   xcvr_10gkr_a10_0_led_disp_err.export
        .xcvr_10gkr_a10_0_led_link_export                            (),                            //                       xcvr_10gkr_a10_0_led_link.export
        .xcvr_10gkr_a10_0_tx_pcfifo_error_1g_export                  (),                  //             xcvr_10gkr_a10_0_tx_pcfifo_error_1g.export
        .xcvr_10gkr_a10_0_rx_pcfifo_error_1g_export                  (),                  //             xcvr_10gkr_a10_0_rx_pcfifo_error_1g.export
        .xcvr_10gkr_a10_0_rx_syncstatus_export                       (rx_syncstatus),                       //                  xcvr_10gkr_a10_0_rx_syncstatus.export
        .xcvr_10gkr_a10_0_rx_clkslip_export                          (1'b0),                          //                     xcvr_10gkr_a10_0_rx_clkslip.export
        //.xcvr_10gkr_a10_0_usr_seq_reset_usr_seq_reset                (1'b0),                //                  might not be used
        .xcvr_10gkr_a10_0_rx_data_ready_export                       (xcvr_10gkr_a10_0_rx_data_ready_export),                       //                  xcvr_10gkr_a10_0_rx_data_ready.export
        .xcvr_10gkr_a10_0_rx_block_lock_export                       (),                       //                  xcvr_10gkr_a10_0_rx_block_lock.export
        .xcvr_10gkr_a10_0_rx_hi_ber_export                           (),                           //                      xcvr_10gkr_a10_0_rx_hi_ber.export

       `ifdef ETH_NF_1G
          .xcvr_10gkr_a10_0_rx_serial_data_export (sgmii_rx_in),
          .xcvr_10gkr_a10_0_tx_serial_data_export (sgmii_tx_out),
          .xcvr_10gkr_a10_0_mode_1g_10gbar_export        (1'b1),
          .xcvr_10gkr_a10_1_mode_1g_10gbar_export        (1'b1),
          .xcvr_cdr_pll_a10_0_pll_powerdown_pll_powerdown(rst_cntlr_pll_powerdown),
       `elsif ETH_NF_10G
          .xcvr_10gkr_a10_0_rx_serial_data_export (xg_base_r_rx_in),
          .xcvr_10gkr_a10_0_tx_serial_data_export (xg_base_r_tx_out),
       `else
       `endif

        .alt_em10g32_0_xgmii_rx_data(xgmii_rx),                                 //                          alt_em10g32_0_xgmii_rx.data
        .xcvr_10gkr_a10_0_xgmii_tx_dc_export(xgmii_tx),                         //                    xcvr_10gkr_a10_0_xgmii_tx_dc.export
        .xcvr_10gkr_a10_0_xgmii_rx_dc_export(xgmii_rx),                         //                    xcvr_10gkr_a10_0_xgmii_rx_dc.export
        .alt_em10g32_0_xgmii_tx_data(xgmii_tx),                                  //                          alt_em10g32_0_xgmii_tx.data

        .xcvr_reset_control_1_pll_locked_pll_locked                  (),                  //                 xcvr_reset_control_1_pll_locked.pll_locked
        .xcvr_reset_control_1_pll_powerdown_pll_powerdown            (),            //              xcvr_reset_control_1_pll_powerdown.pll_powerdown
        .xcvr_reset_control_0_pll_locked_pll_locked                  (pll_locked),                  //                 xcvr_reset_control_0_pll_locked.pll_locked
        .xcvr_reset_control_0_pll_powerdown_pll_powerdown            (rst_cntlr_pll_powerdown),            //              xcvr_reset_control_0_pll_powerdown.pll_powerdown
        .xcvr_10gkr_a10_1_led_an_export                              (),                              //                         xcvr_10gkr_a10_1_led_an.export
        .xcvr_10gkr_a10_1_led_char_err_export                        (),                        //                   xcvr_10gkr_a10_1_led_char_err.export
        .xcvr_10gkr_a10_1_led_disp_err_export                        (),                        //                   xcvr_10gkr_a10_1_led_disp_err.export
        .xcvr_10gkr_a10_1_led_link_export                            (),                            //                       xcvr_10gkr_a10_1_led_link.export
        .xcvr_10gkr_a10_1_tx_pcfifo_error_1g_export                  (),                  //             xcvr_10gkr_a10_1_tx_pcfifo_error_1g.export
        .xcvr_10gkr_a10_1_rx_pcfifo_error_1g_export                  (),                  //             xcvr_10gkr_a10_1_rx_pcfifo_error_1g.export
        .xcvr_10gkr_a10_1_rx_syncstatus_export                       (),                       //                  xcvr_10gkr_a10_1_rx_syncstatus.export
        .xcvr_10gkr_a10_1_rx_clkslip_export                          (),                          //                     xcvr_10gkr_a10_1_rx_clkslip.export
        .xcvr_10gkr_a10_1_rx_data_ready_export                       (),                       //                  xcvr_10gkr_a10_1_rx_data_ready.export
        .xcvr_10gkr_a10_1_rx_block_lock_export                       (),                       //                  xcvr_10gkr_a10_1_rx_block_lock.export
        .xcvr_10gkr_a10_1_rx_hi_ber_export                           (),                           //                      xcvr_10gkr_a10_1_rx_hi_ber.export
        .xcvr_10gkr_a10_1_tx_serial_data_export                      (),                      //                 xcvr_10gkr_a10_1_tx_serial_data.export
        .xcvr_10gkr_a10_1_rx_serial_data_export                      (),                      //                 xcvr_10gkr_a10_1_rx_serial_data.export
        .alt_em10g32_0_avalon_st_tx_startofpacket                    (avalon_st_tx_sink_sop),                    //                      alt_em10g32_0_avalon_st_tx.startofpacket
        .alt_em10g32_0_avalon_st_tx_endofpacket                      (avalon_st_tx_sink_eop),                      //                                                .endofpacket
        .alt_em10g32_0_avalon_st_tx_valid                            (avalon_st_tx_sink_valid),                            //                                                .valid
        .alt_em10g32_0_avalon_st_tx_data                             (avalon_st_tx_sink_data),                             //                                                .data
        .alt_em10g32_0_avalon_st_tx_empty                            (avalon_st_tx_sink_empty),                            //                                                .empty
        .alt_em10g32_0_avalon_st_tx_error                            (avalon_st_tx_sink_error),                            //                                                .error
        .alt_em10g32_0_avalon_st_tx_ready                            (avalon_st_tx_sink_ready),                            //                                                .ready
        .alt_em10g32_0_avalon_st_pause_data                          (0),          //this tied off is for xprop enabling due to seeing Z.
        .alt_em10g32_0_avalon_st_txstatus_valid                      (),                      //                alt_em10g32_0_avalon_st_txstatus.valid
        .alt_em10g32_0_avalon_st_txstatus_data                       (),                       //                                                .data
        .alt_em10g32_0_avalon_st_txstatus_error                      (),                      //                                                .error
        .alt_em10g32_0_avalon_st_rx_data                             (avalon_st_rx_src_data),                             //                      alt_em10g32_0_avalon_st_rx.data
        .alt_em10g32_0_avalon_st_rx_startofpacket                    (avalon_st_rx_src_sop),                    //                                                .startofpacket
        .alt_em10g32_0_avalon_st_rx_valid                            (avalon_st_rx_src_valid),                            //                                                .valid
        .alt_em10g32_0_avalon_st_rx_empty                            (avalon_st_rx_src_empty),                            //                                                .empty
        .alt_em10g32_0_avalon_st_rx_error                            (avalon_st_rx_src_error),                            //                                                .error
        .alt_em10g32_0_avalon_st_rx_ready                            (avalon_st_rx_src_ready),                            //                                                .ready
        .alt_em10g32_0_avalon_st_rx_endofpacket                      (avalon_st_rx_src_eop),                      //                                                .endofpacket
        .alt_em10g32_0_avalon_st_rxstatus_valid                      (),                      //                alt_em10g32_0_avalon_st_rxstatus.valid
        .alt_em10g32_0_avalon_st_rxstatus_data                       (),                       //                                                .data
        .alt_em10g32_0_avalon_st_rxstatus_error                      (),                      //                                                .error
        .alt_em10g32_0_speed_sel_export                              (speed_select),                              //                         alt_em10g32_0_speed_sel.export
        .alt_em10g32_1_speed_sel_export                              (),                              //                         alt_em10g32_1_speed_sel.export
        .xcvr_10gkr_a10_0_mii_speed_sel_export                       (speed_select),                       //                  xcvr_10gkr_a10_0_mii_speed_sel.export
        .xcvr_10gkr_a10_1_mii_speed_sel_export                       (),                       //                  xcvr_10gkr_a10_1_mii_speed_sel.export
        .pll_80_reset_reset                                          (reset),                                          //                                    pll_80_reset.reset
        .pll_0_reset_reset                                           (reset),                                            //                                     pll_0_reset.reset
        .xcvr_10gkr_a10_0_rx_cal_busy_export                         (rx_cal_busy),//                    xcvr_10gkr_a10_0_rx_cal_busy.export
        .xcvr_10gkr_a10_0_tx_cal_busy_export                         (tx_cal_busy),//                    xcvr_10gkr_a10_0_tx_cal_busy.export
        .xcvr_10gkr_a10_0_rx_is_lockedtodata_export                  (rx_is_lockedtodata),//             xcvr_10gkr_a10_0_rx_is_lockedtodata.export
        .xcvr_reset_control_0_tx_cal_busy_tx_cal_busy                ((tx_cal_busy && pll_cal_busy)),//                xcvr_reset_control_0_tx_cal_busy.tx_cal_busy
        .xcvr_reset_control_0_rx_cal_busy_rx_cal_busy                (rx_cal_busy),//                xcvr_reset_control_0_rx_cal_busy.rx_cal_busy
        .xcvr_reset_control_0_rx_is_lockedtodata_rx_is_lockedtodata   (rx_is_lockedtodata),   //         xcvr_reset_control_0_rx_is_lockedtodata.rx_is_lockedtodata
        .xcvr_atx_pll_a10_0_pll_locked_pll_locked(xcvr_atx_pll_a10_0_pll_locked_pll_locked),
        .xcvr_atx_pll_a10_0_pll_powerdown_pll_powerdown(rst_cntlr_pll_powerdown),              //                xcvr_atx_pll_a10_0_pll_powerdown.pll_powerdown
        .xcvr_atx_pll_a10_0_pll_cal_busy_pll_cal_busy(pll_cal_busy),                 //                 xcvr_atx_pll_a10_0_pll_cal_busy.pll_cal_busy
        .xcvr_reset_control_0_pll_select_pll_select(1'b0)
    );
   
    //assign pll_locked = phy_pll_locked & pll156M_locked;
    assign pll_locked =xcvr_atx_pll_a10_0_pll_locked_pll_locked;
    assign pll_powerdown_10g = pll_powerdown_1g; 
    
endmodule

//`endif
