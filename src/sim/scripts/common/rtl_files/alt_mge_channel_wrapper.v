// (C) 2001-2021 Intel Corporation. All rights reserved.
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

module alt_mge_channel_wrapper (
    
    // CSR Clock
    input               csr_clk,
    
    // MAC 32-bit Clock
    input               mac32b_clk,
    
    // MAC 64-bit Clock
    input               mac64b_clk,
    
    // Reset
    input               reset,
    input               avmm_rst_n,
    output              tx_digitalreset,
    output              rx_digitalreset,
    
    // PLL Status for Transceiver Reset Controller
    input               xcvr_pll_10g_pll_locked,
    input               xcvr_pll_10g_pll_cal_busy,
    input               core_pll_locked,
    
    // CSR
    input       [15:0]  csr_ch_address,
    input               csr_ch_read,
    input               csr_ch_write,
    input       [31:0]  csr_ch_writedata,
    output      [31:0]  csr_ch_readdata,
    output              csr_ch_waitrequest,
    
//XCVR
    input                      [19:0]      i_reconfig_xcvr0_address,
    input                                  i_reconfig_xcvr0_read,
    input                                  i_reconfig_xcvr0_write,
    input                      [31:0]      i_reconfig_xcvr0_writedata,
    output                     [31:0]      o_reconfig_xcvr0_readdata,
    output                                 o_reconfig_xcvr0_waitrequest,
    output                                 o_reconfig_xcvr0_readdata_valid,


    // MAC TX User Frame
    input               avalon_st_tx_valid,
    output              avalon_st_tx_ready,
    input               avalon_st_tx_startofpacket,
    input               avalon_st_tx_endofpacket,
    input       [63:0]  avalon_st_tx_data,
    input        [2:0]  avalon_st_tx_empty,
    input               avalon_st_tx_error,
    
    // MAC RX User Frame
    output              avalon_st_rx_valid,
    input               avalon_st_rx_ready,
    output              avalon_st_rx_startofpacket,
    output              avalon_st_rx_endofpacket,
    output      [63:0]  avalon_st_rx_data,
    output       [2:0]  avalon_st_rx_empty,
    output       [5:0]  avalon_st_rx_error,
    
    // MAC TX Frame Status
    output              avalon_st_txstatus_valid,
    output      [39:0]  avalon_st_txstatus_data,
    output       [6:0]  avalon_st_txstatus_error,
    
    // MAC RX Frame Status
    output              avalon_st_rxstatus_valid,
    output      [39:0]  avalon_st_rxstatus_data,
    output       [6:0]  avalon_st_rxstatus_error,
    
    // MAC TX Pause Frame Generation Command
    input        [1:0]  avalon_st_pause_data,
    
    // MAC Status
    output       [1:0]  xgmii_rx_link_fault_status,
    
    // PHY Operating Speed to MAC
    output       [2:0]  operating_speed,
    
    // PHY Status
    output              led_an,
    output              rx_block_lock,
    
    // Transceiver Serial Interface
    input               tx_serial_clk,
    input               rx_cdr_refclk_1,
    output              rx_pma_clkout,
    output              tx_serial_data,
    input               rx_serial_data,
    
    // Data Path Readiness
    output              channel_tx_ready,
    output              channel_rx_ready
    
);
    // CSR
    wire [ 9:0] csr_mac_address;
    wire        csr_mac_read;
    wire        csr_mac_write;
    wire [31:0] csr_mac_writedata;
    wire [31:0] csr_mac_readdata;
    wire        csr_mac_waitrequest;
    
    wire [10:0] csr_phy_address;
    wire        csr_phy_read;
    wire        csr_phy_write;
    wire [31:0] csr_phy_writedata;
    wire [31:0] csr_phy_readdata;
    wire        csr_phy_waitrequest;
    
    wire [10:0] csr_xcvr_rcfg_address;
    wire        csr_xcvr_rcfg_read;
    wire        csr_xcvr_rcfg_write;
    wire [31:0] csr_xcvr_rcfg_writedata;
    wire [31:0] csr_xcvr_rcfg_readdata;
    wire        csr_xcvr_rcfg_waitrequest;
    
    // Transceiver Reset
    wire tx_analogreset;
    wire rx_analogreset;
    wire tx_digitalreset_stat;
    wire rx_digitalreset_stat;
    wire tx_analogreset_stat;
    wire rx_analogreset_stat;
    
    // Transceiver Status
    wire rx_is_lockedtodata;
    wire tx_cal_busy;
    wire rx_cal_busy;
    
    // Reset Controller
    wire reset_ctrl_tx_ready;
    wire reset_ctrl_rx_ready;
    
    // MAC Status
    wire xgmii_rx_link_fault_status_good;
    
    // XGMII TX from MAC to PHY
    wire        xgmii_tx_valid;
    wire [ 3:0] xgmii_tx_control;
    wire [31:0] xgmii_tx_data;
    
    // XGMII RX from PHY to MAC
    wire        xgmii_rx_valid;
    wire [ 3:0] xgmii_rx_control;
    wire [31:0] xgmii_rx_data;
    
    // Channel readiness status
    assign xgmii_rx_link_fault_status_good = (xgmii_rx_link_fault_status == 2'b00);
    
    assign channel_tx_ready = core_pll_locked & reset_ctrl_tx_ready & (xgmii_rx_link_fault_status_good);
    assign channel_rx_ready = core_pll_locked & reset_ctrl_rx_ready & (rx_block_lock);
    
    // Reset Controller for Transceiver Channel
    alt_mge_xcvr_reset_ctrl_channel xcvr_reset_ctrl_ch (
        .clock              (csr_clk),
        .reset              (reset),
        
        .pll_locked         (xcvr_pll_10g_pll_locked & core_pll_locked),
        .pll_select         (1'b0),
        
        // Qualified with core_pll_locked to ensure the PHY RX path is under reset before core clock become stable
        .rx_is_lockedtodata (rx_is_lockedtodata & core_pll_locked),
        
        .tx_digitalreset    (tx_digitalreset),
        .rx_digitalreset    (rx_digitalreset),
        .tx_analogreset     (tx_analogreset),
        .rx_analogreset     (rx_analogreset),
        .tx_digitalreset_stat (tx_digitalreset_stat),
        .rx_digitalreset_stat (rx_digitalreset_stat),
        .tx_analogreset_stat  (tx_analogreset_stat),
        .rx_analogreset_stat  (rx_analogreset_stat),
        
        .pll_cal_busy       (xcvr_pll_10g_pll_cal_busy),
        
        .tx_cal_busy        (tx_cal_busy),
        .rx_cal_busy        (rx_cal_busy),
        
        .tx_ready           (reset_ctrl_tx_ready),
        .rx_ready           (reset_ctrl_rx_ready)
    ); 
    
    // MAC
    //alt_usxgmii_mac mac (
    alt_eth_top mac (
        // CSR Clock
        .csr_clk                        (csr_clk),
        
        // MAC Clock
        .tx_312_5_clk                   (mac32b_clk),
        .rx_312_5_clk                   (mac32b_clk),
        
        .tx_156_25_clk                  (mac64b_clk),
        .rx_156_25_clk                  (mac64b_clk),
        
        // Reset
        .csr_rst_n                      (avmm_rst_n),
        .tx_rst_n                       (~tx_digitalreset),
        .rx_rst_n                       (~rx_digitalreset),
        
        // MAC CSR
        .csr_address                    (csr_mac_address),
        .csr_read                       (csr_mac_read),
        .csr_write                      (csr_mac_write),
        .csr_writedata                  (csr_mac_writedata),
        .csr_readdata                   (csr_mac_readdata),
        .csr_waitrequest                (csr_mac_waitrequest),
        
        // MAC TX User Frame
        .avalon_st_tx_valid             (avalon_st_tx_valid),
        .avalon_st_tx_ready             (avalon_st_tx_ready),
        .avalon_st_tx_startofpacket     (avalon_st_tx_startofpacket),
        .avalon_st_tx_endofpacket       (avalon_st_tx_endofpacket),
        .avalon_st_tx_data              (avalon_st_tx_data),
        .avalon_st_tx_empty             (avalon_st_tx_empty),
        .avalon_st_tx_error             (avalon_st_tx_error),
        
        // MAC RX User Frame
        .avalon_st_rx_valid             (avalon_st_rx_valid),
        .avalon_st_rx_ready             (avalon_st_rx_ready),
        .avalon_st_rx_startofpacket     (avalon_st_rx_startofpacket),
        .avalon_st_rx_endofpacket       (avalon_st_rx_endofpacket),
        .avalon_st_rx_data              (avalon_st_rx_data),
        .avalon_st_rx_empty             (avalon_st_rx_empty),
        .avalon_st_rx_error             (avalon_st_rx_error),
        
        // MAC TX Frame Status
        .avalon_st_txstatus_valid       (avalon_st_txstatus_valid),
        .avalon_st_txstatus_data        (avalon_st_txstatus_data),
        .avalon_st_txstatus_error       (avalon_st_txstatus_error),
        
        // MAC RX Frame Status
        .avalon_st_rxstatus_valid       (avalon_st_rxstatus_valid),
        .avalon_st_rxstatus_data        (avalon_st_rxstatus_data),
        .avalon_st_rxstatus_error       (avalon_st_rxstatus_error),
        
        // MAC TX Pause Frame Generation Command
        .avalon_st_pause_data           (avalon_st_pause_data),
        
        // XGMII TX from MAC to PHY
        .xgmii_tx_valid                 (xgmii_tx_valid),
        .xgmii_tx_control               (xgmii_tx_control),
        .xgmii_tx_data                  (xgmii_tx_data),
        
        // XGMII RX from PHY to MAC
        .xgmii_rx_valid                 (xgmii_rx_valid),
        .xgmii_rx_control               (xgmii_rx_control),
        .xgmii_rx_data                  (xgmii_rx_data),
        
        // XGMII Link Fault Status
        .link_fault_status_xgmii_rx_data(xgmii_rx_link_fault_status),
        
        // PHY Operating Speed to MAC
        .speed_sel                      (operating_speed)
    );
    
    // PHY
    //alt_usxgmii_phy phy (
    alt_mge_channel phy (
        // CSR Clock
        .csr_clk                        (csr_clk),
        
        // Reset
        .reset                          (~avmm_rst_n),
        .tx_digitalreset                (tx_digitalreset),
        .rx_digitalreset                (rx_digitalreset),
        .tx_analogreset                 (tx_analogreset),
        .rx_analogreset                 (rx_analogreset),
        .tx_digitalreset_stat           (tx_digitalreset_stat),
        .rx_digitalreset_stat           (rx_digitalreset_stat),
        .tx_analogreset_stat            (tx_analogreset_stat),
        .rx_analogreset_stat            (rx_analogreset_stat),
        
        // PHY CSR
        .csr_address                    (csr_phy_address),
        .csr_read                       (csr_phy_read),
        .csr_write                      (csr_phy_write),
        .csr_writedata                  (csr_phy_writedata),
        .csr_readdata                   (csr_phy_readdata),
        .csr_waitrequest                (csr_phy_waitrequest),
        
        // XGMII Clock from PLL to PHY
        .xgmii_tx_coreclkin             (mac32b_clk),
        .xgmii_rx_coreclkin             (mac32b_clk),
        
        // XGMII TX from MAC to PHY
        .xgmii_tx_valid                 (xgmii_tx_valid),
        .xgmii_tx_control               (xgmii_tx_control),
        .xgmii_tx_data                  (xgmii_tx_data),
        
        // XGMII RX from PHY to MAC
        .xgmii_rx_valid                 (xgmii_rx_valid),
        .xgmii_rx_control               (xgmii_rx_control),
        .xgmii_rx_data                  (xgmii_rx_data),
        
        // PHY Operating Speed to MAC
        .operating_speed                (operating_speed),
        
        // PHY Status
        .led_an                         (led_an),
        .rx_block_lock                  (rx_block_lock),
        
        // Transceiver Serial Interface
        .tx_serial_clk                  (tx_serial_clk),
        .rx_cdr_refclk_1                (rx_cdr_refclk_1),
        .rx_pma_clkout                  (rx_pma_clkout),
        .tx_serial_data                 (tx_serial_data),
        .rx_serial_data                 (rx_serial_data),
        
        // Transceiver Status
        .rx_is_lockedtodata             (rx_is_lockedtodata),
        .tx_cal_busy                    (tx_cal_busy),
        .rx_cal_busy                    (rx_cal_busy),
        
        // Transceiver Reconfiguration
        /*.reconfig_clk                   (csr_clk),
        .reconfig_reset                 (avmm_rst_n),
        .reconfig_address               (csr_xcvr_rcfg_address),
        .reconfig_read                  (csr_xcvr_rcfg_read),
        .reconfig_write                 (csr_xcvr_rcfg_write),
        .reconfig_writedata             (csr_xcvr_rcfg_writedata),
        .reconfig_readdata              (csr_xcvr_rcfg_readdata),
        .reconfig_waitrequest           (csr_xcvr_rcfg_waitrequest)*/
        .reconfig_clk                   (csr_clk),
        .reconfig_reset                 (~avmm_rst_n),
        .reconfig_address               (i_reconfig_xcvr0_address),
        .reconfig_read                  (i_reconfig_xcvr0_read),
        .reconfig_write                 (i_reconfig_xcvr0_write),
        .reconfig_writedata             (i_reconfig_xcvr0_writedata),
        .reconfig_readdata              (o_reconfig_xcvr0_readdata),
        .reconfig_waitrequest           (o_reconfig_xcvr0_waitrequest)
    );
    
    // Avalon-MM Address Decoder
    address_decoder_channel address_decoder_ch (
        .csr_clk_clk                    (csr_clk),
        .csr_clk_reset_reset_n          (~reset),
        
        // Byte addressing
        .slave_address                  (csr_ch_address),
        .slave_read                     (csr_ch_read),
        .slave_write                    (csr_ch_write),
        .slave_writedata                (csr_ch_writedata),
        .slave_readdata                 (csr_ch_readdata),
        .slave_waitrequest              (csr_ch_waitrequest),
        
        // Word addressing
        .mac_address                    (csr_mac_address),
        .mac_read                       (csr_mac_read),
        .mac_write                      (csr_mac_write),
        .mac_writedata                  (csr_mac_writedata),
        .mac_readdata                   (csr_mac_readdata),
        .mac_waitrequest                (csr_mac_waitrequest),
        
        // Word addressing
        .phy_address                    (csr_phy_address),
        .phy_read                       (csr_phy_read),
        .phy_write                      (csr_phy_write),
        .phy_writedata                  (csr_phy_writedata),
		.phy_readdata                   (csr_phy_readdata),
		.phy_waitrequest                (csr_phy_waitrequest),
        
        // Word addressing
        .xcvr_rcfg_address              (csr_xcvr_rcfg_address),
        .xcvr_rcfg_read                 (csr_xcvr_rcfg_read),
        .xcvr_rcfg_write                (csr_xcvr_rcfg_write),
        .xcvr_rcfg_writedata            (csr_xcvr_rcfg_writedata),
		.xcvr_rcfg_readdata             (csr_xcvr_rcfg_readdata),
		.xcvr_rcfg_waitrequest          (csr_xcvr_rcfg_waitrequest)
    ); 
    
endmodule
