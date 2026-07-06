// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

`timescale 1 ps / 1 ps

module alt_mge_rd #(
    parameter NUM_OF_CHANNEL = 2
) (
    
    // CSR Clock
    input                                   csr_clk,
    
    // MAC Clock
    input                                   mac_clk,
    
    // XGMII Clock
    input                                   mac64b_clk,
    
    // Reference Clock
    input                                   refclk_1g2p5g,
    input                                   refclk_10g,
    
    // Reset
    input                                   reset,
    output [NUM_OF_CHANNEL-1:0]             tx_digitalreset,
    output [NUM_OF_CHANNEL-1:0]             rx_digitalreset,
	output [NUM_OF_CHANNEL-1:0]             rx_digitalreset_stat,
    
    // MAC CSR
    input  [NUM_OF_CHANNEL-1:0][ 9:0]       csr_mac_address,
    input  [NUM_OF_CHANNEL-1:0]             csr_mac_read,
    input  [NUM_OF_CHANNEL-1:0]             csr_mac_write,
    input  [NUM_OF_CHANNEL-1:0][31:0]       csr_mac_writedata,
    output [NUM_OF_CHANNEL-1:0][31:0]       csr_mac_readdata,
    output [NUM_OF_CHANNEL-1:0]             csr_mac_waitrequest,
    
    // MAC TX User Frame
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_tx_valid,
    output [NUM_OF_CHANNEL-1:0]             avalon_st_tx_ready,
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_tx_startofpacket,
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_tx_endofpacket,
    input  [NUM_OF_CHANNEL-1:0][63:0]       avalon_st_tx_data,
    input  [NUM_OF_CHANNEL-1:0][ 2:0]       avalon_st_tx_empty,
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_tx_error,
    
    // MAC RX User Frame
    output [NUM_OF_CHANNEL-1:0]             avalon_st_rx_valid,
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_rx_ready,
    output [NUM_OF_CHANNEL-1:0]             avalon_st_rx_startofpacket,
    output [NUM_OF_CHANNEL-1:0]             avalon_st_rx_endofpacket,
    output [NUM_OF_CHANNEL-1:0][63:0]       avalon_st_rx_data,
    output [NUM_OF_CHANNEL-1:0][ 2:0]       avalon_st_rx_empty,
    output [NUM_OF_CHANNEL-1:0][ 5:0]       avalon_st_rx_error,
    
    // MAC TX Frame Status
    output [NUM_OF_CHANNEL-1:0]             avalon_st_txstatus_valid,
    output [NUM_OF_CHANNEL-1:0][39:0]       avalon_st_txstatus_data,
    output [NUM_OF_CHANNEL-1:0][ 6:0]       avalon_st_txstatus_error,
    
    // MAC RX Frame Status
    output [NUM_OF_CHANNEL-1:0]             avalon_st_rxstatus_valid,
    output [NUM_OF_CHANNEL-1:0][39:0]       avalon_st_rxstatus_data,
    output [NUM_OF_CHANNEL-1:0][ 6:0]       avalon_st_rxstatus_error,
    
    // MAC TX Pause Frame Generation Command
    input  [NUM_OF_CHANNEL-1:0][ 1:0]       avalon_st_pause_data,
    
    // MAC Status
    output [NUM_OF_CHANNEL-1:0][ 1:0]       xgmii_rx_link_fault_status,
    
    // PHY CSR
    input  [NUM_OF_CHANNEL-1:0][10:0]       csr_phy_address,
    input  [NUM_OF_CHANNEL-1:0]             csr_phy_read,
    input  [NUM_OF_CHANNEL-1:0]             csr_phy_write,
    input  [NUM_OF_CHANNEL-1:0][31:0]       csr_phy_writedata,
    output [NUM_OF_CHANNEL-1:0][31:0]       csr_phy_readdata,
    output [NUM_OF_CHANNEL-1:0]             csr_phy_waitrequest,
    
    // PHY Status
    output [NUM_OF_CHANNEL-1:0]             led_link,
    output [NUM_OF_CHANNEL-1:0]             led_char_err,
    output [NUM_OF_CHANNEL-1:0]             led_disp_err,
    output [NUM_OF_CHANNEL-1:0]             led_an,
    output [NUM_OF_CHANNEL-1:0]             rx_block_lock,
    
    // Transceiver Serial Interface
    output [NUM_OF_CHANNEL-1:0]             tx_serial_data,
    input  [NUM_OF_CHANNEL-1:0]             rx_serial_data,
    output [NUM_OF_CHANNEL-1:0]             rx_pma_clkout,
    
    // Data Path Readiness
    output [NUM_OF_CHANNEL-1:0]             channel_tx_ready,
    output [NUM_OF_CHANNEL-1:0]             channel_rx_ready,
    
    // Reconfig CSR
    input                      [ 1:0]       csr_rcfg_address,
    input                                   csr_rcfg_read,
    input                                   csr_rcfg_write,
    input                      [31:0]       csr_rcfg_writedata,
    output                     [31:0]       csr_rcfg_readdata,
    
    // Native PHY Reconfig CSR
    input  [NUM_OF_CHANNEL-1:0][10:0]       csr_native_phy_rcfg_address,
    input  [NUM_OF_CHANNEL-1:0]             csr_native_phy_rcfg_read,
    input  [NUM_OF_CHANNEL-1:0]             csr_native_phy_rcfg_write,
    input  [NUM_OF_CHANNEL-1:0][31:0]       csr_native_phy_rcfg_writedata,
    output [NUM_OF_CHANNEL-1:0][31:0]       csr_native_phy_rcfg_readdata,
    output [NUM_OF_CHANNEL-1:0]             csr_native_phy_rcfg_waitrequest
    
);
    
    // Local parameter
    localparam NUM_OF_CH_WIDTH = log2ceil(NUM_OF_CHANNEL);
    
    // Loop Control Variable
    genvar i;
    
    // Transceiver PLL
    wire                            xcvr_pll_10g_pll_powerdown;
    wire                            xcvr_pll_10g_pll_locked;
    wire                            xcvr_pll_10g_pll_cal_busy;
    wire                            xcvr_pll_10g_serial_clk;
    
    wire                            xcvr_pll_2p5g_pll_powerdown;
    wire                            xcvr_pll_2p5g_pll_locked;
    wire                            xcvr_pll_2p5g_pll_cal_busy;
    wire                            xcvr_pll_2p5g_serial_clk;
    
    wire                            xcvr_pll_1g_pll_powerdown;
    wire                            xcvr_pll_1g_pll_locked;
    wire                            xcvr_pll_1g_pll_cal_busy;
    wire                            xcvr_pll_1g_serial_clk;
    
    // Transceiver Reset
    wire [NUM_OF_CHANNEL-1:0]       tx_analogreset;
    wire [NUM_OF_CHANNEL-1:0]       rx_analogreset;
	 
	 wire [NUM_OF_CHANNEL-1:0]       tx_analogreset_stat;
    wire [NUM_OF_CHANNEL-1:0]       rx_analogreset_stat;
	 wire [NUM_OF_CHANNEL-1:0]       tx_digitalreset_stat;
    //wire [NUM_OF_CHANNEL-1:0]       rx_digitalreset_stat;
    
    // Reset Controller
    wire [NUM_OF_CHANNEL-1:0]       reset_ctrl_tx_ready;
    wire [NUM_OF_CHANNEL-1:0]       reset_ctrl_rx_ready;
    
    // Reset Synchronization
    wire                            reset_csr_clk;
    
    // MAC Status
    wire [NUM_OF_CHANNEL-1:0]       xgmii_rx_link_fault_status_good;
    
    // Transceiver Status
    wire [NUM_OF_CHANNEL-1:0]       rx_is_lockedtodata;
    wire [NUM_OF_CHANNEL-1:0]       tx_cal_busy;
    wire [NUM_OF_CHANNEL-1:0]       rx_cal_busy;
    
    // Transceiver Reconfiguration
    wire    [NUM_OF_CH_WIDTH +10:0] mge_rcfg_address;
    wire                            mge_rcfg_read;
    wire                            mge_rcfg_write;
    wire                     [31:0] mge_rcfg_writedata;
    wire [NUM_OF_CHANNEL-1:0][31:0] mge_rcfg_readdata;
    wire [NUM_OF_CHANNEL-1:0]       mge_rcfg_waitrequest;
    
    wire [NUM_OF_CHANNEL-1:0][10:0] reconfig_xcvr_address;
    wire [NUM_OF_CHANNEL-1:0]       reconfig_xcvr_read;
    wire [NUM_OF_CHANNEL-1:0]       reconfig_xcvr_write;
    wire [NUM_OF_CHANNEL-1:0][31:0] reconfig_xcvr_writedata;
    wire [NUM_OF_CHANNEL-1:0][31:0] reconfig_xcvr_readdata;
    wire [NUM_OF_CHANNEL-1:0]       reconfig_xcvr_waitrequest;
    
    // Reconfiguration Signals
    wire [NUM_OF_CHANNEL-1:0][ 2:0] operating_speed;
    wire [NUM_OF_CHANNEL-1:0][ 1:0] xcvr_mode;
    wire [NUM_OF_CHANNEL-1:0][ 1:0] pll_select;
    wire [NUM_OF_CHANNEL-1:0]       reconfig_busy;
    
    // TX PLL for 10G
    alt_mge_xcvr_atx_pll_10g u_xcvr_atx_pll_10g (
        .pll_refclk0     (refclk_10g),
        .tx_serial_clk   (xcvr_pll_10g_serial_clk),
        .pll_locked      (xcvr_pll_10g_pll_locked),
        .pll_cal_busy    (xcvr_pll_10g_pll_cal_busy)
    );
    
    // TX PLL for 2.5G
    alt_mge_xcvr_atx_pll_2p5g u_xcvr_atx_pll_2p5g (
        .pll_refclk0     (refclk_1g2p5g),
        .tx_serial_clk   (),
        .pll_locked      (xcvr_pll_2p5g_pll_locked),
        .pll_cal_busy    (xcvr_pll_2p5g_pll_cal_busy),
        .mcgb_serial_clk (xcvr_pll_2p5g_serial_clk)
    );
    
    // TX PLL for 1G
    alt_mge_xcvr_fpll_1g u_xcvr_fpll_1g (
        .pll_refclk0     (refclk_1g2p5g),
        .pll_locked      (xcvr_pll_1g_pll_locked),
        .tx_serial_clk   (),
        .pll_cal_busy    (xcvr_pll_1g_pll_cal_busy),
        .mcgb_serial_clk (xcvr_pll_1g_serial_clk)
    );
    
    // Reset Synchronization
    alt_mge_reset_synchronizer #(
        .ASYNC_RESET    (1),
        .DEPTH          (3)
    ) u_rst_sync_csr_clk (
        .clk            (csr_clk),
        .reset_in       (reset),
        .reset_out      (reset_csr_clk)
    );
    
    generate for(i = 0; i < NUM_OF_CHANNEL; i = i + 1)
    begin : CHANNEL_GEN
        
        // Avalon-MM Mux for Transceiver Reconfiguration
        alt_mge_rd_avmm_mux_xcvr_rcfg avmm_mux_xcvr_rcfg (
            .csr_clk_clk                                (csr_clk),
			.csr_clk_reset_reset_n                      (~reset_csr_clk),
            
            .user_rcfg_master_address                   (csr_native_phy_rcfg_address[i]),
            .user_rcfg_master_read                      (csr_native_phy_rcfg_read[i]),
            .user_rcfg_master_write                     (csr_native_phy_rcfg_write[i]),
            .user_rcfg_master_writedata                 (csr_native_phy_rcfg_writedata[i]),
            .user_rcfg_master_readdata                  (csr_native_phy_rcfg_readdata[i]),
            .user_rcfg_master_waitrequest               (csr_native_phy_rcfg_waitrequest[i]),
            
            .mge_rcfg_master_address                    (mge_rcfg_address[10:0]),
            .mge_rcfg_master_read                       (mge_rcfg_read && (mge_rcfg_address[NUM_OF_CH_WIDTH+10:11] == i[NUM_OF_CH_WIDTH-1:0])),
            .mge_rcfg_master_write                      (mge_rcfg_write && (mge_rcfg_address[NUM_OF_CH_WIDTH+10:11] == i[NUM_OF_CH_WIDTH-1:0])),
            .mge_rcfg_master_writedata                  (mge_rcfg_writedata),
            .mge_rcfg_master_readdata                   (mge_rcfg_readdata[i]),
            .mge_rcfg_master_waitrequest                (mge_rcfg_waitrequest[i]),
            
            .xcvr_rcfg_slave_address                    (reconfig_xcvr_address[i]),
            .xcvr_rcfg_slave_read                       (reconfig_xcvr_read[i]),
            .xcvr_rcfg_slave_write                      (reconfig_xcvr_write[i]),
            .xcvr_rcfg_slave_writedata                  (reconfig_xcvr_writedata[i]),
            .xcvr_rcfg_slave_readdata                   (reconfig_xcvr_readdata[i]),
            .xcvr_rcfg_slave_waitrequest                (reconfig_xcvr_waitrequest[i])
        );
        
        // MAC + PHY
        alt_mge_channel u_channel (
            
            // CSR Clock
            .csr_clk                    (csr_clk),
            
            // MAC Clock
            .mac_clk                    (mac_clk),
            
            // XGMII Clock
            .mac64b_clk                 (mac64b_clk),
            
            // Reset
            .reset                      (reset),
            .tx_digitalreset            (tx_digitalreset[i]),
				.tx_digitalreset_stat       (tx_digitalreset_stat[i]),
            .rx_digitalreset            (rx_digitalreset[i]),
				.rx_digitalreset_stat       (rx_digitalreset_stat[i]),
            .tx_analogreset             (tx_analogreset[i]),
				.tx_analogreset_stat        (tx_analogreset_stat[i]),
            .rx_analogreset             (rx_analogreset[i]),
				.rx_analogreset_stat        (rx_analogreset_stat[i]),
            
            // MAC CSR
            .csr_mac_address            (csr_mac_address[i]),
            .csr_mac_read               (csr_mac_read[i]),
            .csr_mac_write              (csr_mac_write[i]),
            .csr_mac_writedata          (csr_mac_writedata[i]),
            .csr_mac_readdata           (csr_mac_readdata[i]),
            .csr_mac_waitrequest        (csr_mac_waitrequest[i]),
            
            // MAC TX User Frame
            .avalon_st_tx_valid         (avalon_st_tx_valid[i]),
            .avalon_st_tx_ready         (avalon_st_tx_ready[i]),
            .avalon_st_tx_startofpacket (avalon_st_tx_startofpacket[i]),
            .avalon_st_tx_endofpacket   (avalon_st_tx_endofpacket[i]),
            .avalon_st_tx_data          (avalon_st_tx_data[i]),
            .avalon_st_tx_empty         (avalon_st_tx_empty[i]),
            .avalon_st_tx_error         (avalon_st_tx_error[i]),
            
            // MAC RX User Frame
            .avalon_st_rx_valid         (avalon_st_rx_valid[i]),
            .avalon_st_rx_ready         (avalon_st_rx_ready[i]),
            .avalon_st_rx_startofpacket (avalon_st_rx_startofpacket[i]),
            .avalon_st_rx_endofpacket   (avalon_st_rx_endofpacket[i]),
            .avalon_st_rx_data          (avalon_st_rx_data[i]),
            .avalon_st_rx_empty         (avalon_st_rx_empty[i]),
            .avalon_st_rx_error         (avalon_st_rx_error[i]),
            
            // MAC TX Frame Status
            .avalon_st_txstatus_valid   (avalon_st_txstatus_valid[i]),
            .avalon_st_txstatus_data    (avalon_st_txstatus_data[i]),
            .avalon_st_txstatus_error   (avalon_st_txstatus_error[i]),
            
            // MAC RX Frame Status
            .avalon_st_rxstatus_valid   (avalon_st_rxstatus_valid[i]),
            .avalon_st_rxstatus_data    (avalon_st_rxstatus_data[i]),
            .avalon_st_rxstatus_error   (avalon_st_rxstatus_error[i]),
            
            // MAC TX Pause Frame Generation Command
            .avalon_st_pause_data       (avalon_st_pause_data[i]),
            
            // MAC Status
            .xgmii_rx_link_fault_status (xgmii_rx_link_fault_status[i]),
            
            // PHY CSR
            .csr_phy_address            (csr_phy_address[i]),
            .csr_phy_read               (csr_phy_read[i]),
            .csr_phy_write              (csr_phy_write[i]),
            .csr_phy_writedata          (csr_phy_writedata[i]),
            .csr_phy_readdata           (csr_phy_readdata[i]),
            .csr_phy_waitrequest        (csr_phy_waitrequest[i]),
            
            // PHY Operating Speed
            .operating_speed            (operating_speed[i]),
            
            // PHY Operating Mode from Reconfig Block
            .xcvr_mode                  (xcvr_mode[i]),
            
            // PHY Status
            .led_link                   (led_link[i]),
            .led_char_err               (led_char_err[i]),
            .led_disp_err               (led_disp_err[i]),
            .led_an                     (led_an[i]),
            .rx_block_lock              (rx_block_lock[i]),
            
            // Transceiver Serial Interface
            .tx_serial_clk              ({xcvr_pll_10g_serial_clk, xcvr_pll_1g_serial_clk, xcvr_pll_2p5g_serial_clk}),
            .rx_cdr_refclk              (refclk_1g2p5g),
            .rx_cdr_refclk_1            (refclk_10g),
            .rx_pma_clkout              (rx_pma_clkout[i]),
            .tx_serial_data             (tx_serial_data[i]),
            .rx_serial_data             (rx_serial_data[i]),
            
            // Transceiver Status
            .rx_is_lockedtodata         (rx_is_lockedtodata[i]),
            .tx_cal_busy                (tx_cal_busy[i]),
            .rx_cal_busy                (rx_cal_busy[i]),
            
            // Transceiver Reconfiguration
            .reconfig_clk               (csr_clk),
            .reconfig_reset             (reset),
            .reconfig_address           (reconfig_xcvr_address[i]),
            .reconfig_read              (reconfig_xcvr_read[i]),
            .reconfig_write             (reconfig_xcvr_write[i]),
            .reconfig_writedata         (reconfig_xcvr_writedata[i]),
            .reconfig_readdata          (reconfig_xcvr_readdata[i]),
            .reconfig_waitrequest       (reconfig_xcvr_waitrequest[i])
        );
        
        // PLL select based on MIF configuration
        // Following table shows default configuration in Reference Design
        // ------------------------------
        // | MIF Mode |  Speed   | PLL  |
        // ------------------------------
        // |   2'b00  |     1G   | 2'h1 |
        // |   2'b01  |   2.5G   | 2'h0 |
        // |   2'b10  |     5G   | 2'h2 |
        // |   2'b11  |    10G   | 2'h2 |
        // ------------------------------
        assign pll_select[i] = (xcvr_mode[i] == 2'b00) ? 2'h1 :
                               (xcvr_mode[i] == 2'b01) ? 2'h0 : 2'h2;
        
        // Reset Controller for Transceiver Channel
        alt_mge_xcvr_reset_ctrl_channel u_xcvr_reset_ctrl_ch (
            .clock              (refclk_1g2p5g),
           // .reset              (reset | reconfig_busy[i]),
		    .reset              (reset),
            .tx_analogreset     (tx_analogreset[i]),
			.tx_digitalreset    (tx_digitalreset[i]),
			.tx_ready           (reset_ctrl_tx_ready[i]),
            .pll_locked         ({xcvr_pll_10g_pll_locked, xcvr_pll_1g_pll_locked, xcvr_pll_2p5g_pll_locked}),
            .pll_select         (pll_select[i]),
            .tx_cal_busy        (tx_cal_busy[i]),
			.rx_analogreset     (rx_analogreset[i]),
			.rx_digitalreset    (rx_digitalreset[i]),
			.rx_analogreset_stat(rx_analogreset_stat[i]),
			.rx_digitalreset_stat (rx_digitalreset_stat[i]),
			.tx_analogreset_stat(tx_analogreset_stat[i]),
			.tx_digitalreset_stat(tx_digitalreset_stat[i]),
			.rx_ready           (reset_ctrl_rx_ready[i]),
            .rx_is_lockedtodata (rx_is_lockedtodata[i]),
            .rx_cal_busy        (rx_cal_busy[i]) 
            //.pll_cal_busy       ({xcvr_pll_10g_pll_cal_busy, xcvr_pll_1g_pll_cal_busy, xcvr_pll_2p5g_pll_cal_busy}),   
        );
        
        // Channel readiness status
        assign xgmii_rx_link_fault_status_good[i] = ((operating_speed[i] == 3'b000) || (operating_speed[i] == 3'b101)) ? (xgmii_rx_link_fault_status[i] == 2'b00) : 1'b1;
        
        assign channel_tx_ready[i] = reset_ctrl_tx_ready[i] & (xgmii_rx_link_fault_status_good[i]);
        assign channel_rx_ready[i] = reset_ctrl_rx_ready[i] & (led_link[i] | rx_block_lock[i]);
        
    end
    endgenerate
    
    // Reconfig Block
    alt_mge_rcfg_a10 #(
        .NUM_OF_CHANNEL             (NUM_OF_CHANNEL),
        .DEVICE_FAMILY              ("Arria 10")
    ) u_rcfg_a10 ( 
        .clk                        (csr_clk),
		.rst_n                      (~reset_csr_clk),
        
        .csr_rcfg_address           (csr_rcfg_address),
        .csr_rcfg_read              (csr_rcfg_read),
        .csr_rcfg_readdata          (csr_rcfg_readdata),
        .csr_rcfg_write             (csr_rcfg_write),
        .csr_rcfg_writedata         (csr_rcfg_writedata),
        
        .mode_selected              (xcvr_mode),
        
        .reconfig_busy              (reconfig_busy),
        
        .reconfig_xcvr_address      (mge_rcfg_address),
        .reconfig_xcvr_read         (mge_rcfg_read),
        .reconfig_xcvr_write        (mge_rcfg_write),
        .reconfig_xcvr_writedata    (mge_rcfg_writedata),
        .reconfig_xcvr_readdata     (mge_rcfg_readdata[mge_rcfg_address[NUM_OF_CH_WIDTH+10:11]]),
        .reconfig_xcvr_waitrequest  (mge_rcfg_waitrequest[mge_rcfg_address[NUM_OF_CH_WIDTH+10:11]])

    );
    
    // --------------------------------------------------
    // Calculates the log2ceil of the input value
    // --------------------------------------------------
    function integer log2ceil;
        input integer val;
        integer i;
        
        begin
            i = 1;
            log2ceil = 0;
            
            if (val == 1) begin
                return 1;
            end
            
            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1; 
            end
        end
    endfunction
    
endmodule
