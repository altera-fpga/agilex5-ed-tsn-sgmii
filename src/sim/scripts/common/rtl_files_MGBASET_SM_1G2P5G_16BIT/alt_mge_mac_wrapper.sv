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

module alt_mge_mac_wrapper #(
) ( 
    // CSR Clock
    input               csr_clk,
    // MAC User Clock
    input               mac_clk,
    // Reset
    input               reset,
    input               rx_digitalreset,
    input               tx_digitalreset,
    // MAC CSR
    input       [9:0]   csr_mac_address,
    input               csr_mac_read,
    input               csr_mac_write,
    input       [31:0]  csr_mac_writedata,
    output      [31:0]  csr_mac_readdata,
    output              csr_mac_waitrequest,
    // PHY CSR
    input        [4:0]  csr_phy_address,
    input               csr_phy_read,
    input               csr_phy_write,
    input       [15:0]  csr_phy_writedata,
    output      [15:0]  csr_phy_readdata,
    output              csr_phy_waitrequest,
    // PHY Status
    output              led_link,
    output              led_char_err,
    output              led_disp_err,
    output              led_an,
    // PLL Status
    output              iopll_lock,
    //SRC
    input               o_src_ch_pause_request,  
    output              i_src_ch_pause_grant,
    //RST
    input               i_rst_n , 
    output              o_rst_ack_n,             
    input               i_tx_rst_n,
    input               i_rx_rst_n,
    output              o_tx_rst_ack_n,          
    output              o_rx_rst_ack_n,
    // MAC RST
    input               i_mac_tx_rst_n,
    input               i_mac_rx_rst_n,
    output              o_mac_tx_rst_ack_n,          
    output              o_mac_rx_rst_ack_n,
    output              o_mac_rst_ack_n,
    //Connecting CDR clk's
    input      	        refclk,
    input      	        refclk_n,
    output              rx_pma_clkout,
    input               system_pll_clk,          
    input               system_pll_lock,          
    // PHY Operating Mode from Reconfig Block
    input        [1:0]  xcvr_mode,
    //FLUX Clk 
    input               flux_clk,
    output              sss_req,
    input              sss_grant,
    //Serial Data 
    output              tx_serial_data,
    output              tx_serial_data_n,
    input               rx_serial_data,
    input               rx_serial_data_n,
    // Transceiver Status
    output              rx_is_lockedtodata,
    // MAC TX User Frame
    input               avalon_st_tx_valid,
    output              avalon_st_tx_ready,
    input               avalon_st_tx_startofpacket,
    input               avalon_st_tx_endofpacket,
    input       [31:0]  avalon_st_tx_data,
    input       [1:0]   avalon_st_tx_empty,
    input               avalon_st_tx_error,
    // MAC RX User Frame
    output              avalon_st_rx_valid,
    input               avalon_st_rx_ready,
    output              avalon_st_rx_startofpacket,
    output              avalon_st_rx_endofpacket,
    output      [31:0]  avalon_st_rx_data,
    output      [1:0]   avalon_st_rx_empty,
    output      [5:0]   avalon_st_rx_error,
	// Data Path Readiness
    output              channel_tx_ready,
    output              channel_rx_ready,
    // MAC TX Frame Status
    output              avalon_st_txstatus_valid,
    output      [39:0]  avalon_st_txstatus_data,
    output      [6:0]   avalon_st_txstatus_error,
    // MAC RX Frame Status
    output              avalon_st_rxstatus_valid,
    output      [39:0]  avalon_st_rxstatus_data,
    output      [6:0]   avalon_st_rxstatus_error,
    // MAC TX Pause Frame Generation Command
    input        [1:0]  avalon_st_pause_data,
    // Transceiver Reconfiguration
    input               reconfig_clk,
    input               reconfig_reset,
    input               reconfig_write,
    input               reconfig_read,
    input       [20:0]  reconfig_address,
	input       [3:0]   reconfig_be,             
    input       [31:0]  reconfig_writedata,
    output      [31:0]  reconfig_readdata,
    output              reconfig_waitrequest,
    output              reconfig_readdata_valid
);
    
    // GMII Clock from PHY to MAC
    wire        gmii16b_tx_clk;
    wire        gmii16b_rx_clk;
    
    // GMII TX from MAC to PHY
    wire  [1:0] gmii16b_tx_en;
    wire [15:0] gmii16b_tx_d;
    wire  [1:0] gmii16b_tx_err;
    
    // GMII RX from PHY to MAC
    wire  [1:0] gmii16b_rx_dv;
    wire [15:0] gmii16b_rx_d;
    wire  [1:0] gmii16b_rx_err;
    
    // PHY Operating Speed to MAC
    wire  [2:0] operating_speed;
  
         
    alt_em10g32_0 mac (
        // CSR Clock
        .csr_clk                        (csr_clk),
        
        // MAC User Clock
        .tx_156_25_clk                  (mac_clk),
        .rx_156_25_clk                  (mac_clk),
        
        // Reset
        .csr_rst_n                      (~reset),
        .tx_rst_n                       (i_mac_tx_rst_n),
        .rx_rst_n                       (i_mac_rx_rst_n),
        
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
        
        // GMII Clock from PHY to MAC
        .gmii16b_tx_clk                 (gmii16b_tx_clk),
        .gmii16b_rx_clk                 (gmii16b_rx_clk),
       
        // GMII TX from MAC to PHY
        .gmii16b_tx_en                  (gmii16b_tx_en),
        .gmii16b_tx_d                   (gmii16b_tx_d),
        .gmii16b_tx_err                 (gmii16b_tx_err),
        
        // GMII RX from PHY to MAC
        .gmii16b_rx_dv                  (gmii16b_rx_dv),
        .gmii16b_rx_d                   (gmii16b_rx_d),
        .gmii16b_rx_err                 (gmii16b_rx_err),
        
        // PHY Operating Speed to MAC
        .speed_sel                      (operating_speed)
    );
    
    alt_mge_phy_0 phy (
        // CSR Clock
        .csr_clk                        (csr_clk),
        //Reset
        .reset                          (reset),
        .rx_digitalreset                (rx_digitalreset),        
		.tx_digitalreset                (tx_digitalreset),  
        // PHY CSR
        .csr_address                    (csr_phy_address),
        .csr_read                       (csr_phy_read),
        .csr_write                      (csr_phy_write),
        .csr_writedata                  (csr_phy_writedata),
        .csr_readdata                   (csr_phy_readdata),
        .csr_waitrequest                (csr_phy_waitrequest),
        // GMII TX from MAC to PHY
        .gmii16b_tx_en                  (gmii16b_tx_en),
        .gmii16b_tx_d                   (gmii16b_tx_d),
        .gmii16b_tx_err                 (gmii16b_tx_err),
        // GMII RX from PHY to MAC
        .gmii16b_rx_dv                  (gmii16b_rx_dv),
        .gmii16b_rx_d                   (gmii16b_rx_d),
        .gmii16b_rx_err                 (gmii16b_rx_err),
        // PHY Status
        .led_link                       (led_link),
        .led_char_err                   (led_char_err),
        .led_disp_err                   (led_disp_err),
        .led_an                         (led_an),
        // PHY Status
        .mrphy_pll_lock                 (iopll_lock),
        // PHY Operating Speed to MAC
        .operating_speed                (operating_speed),
        .i_src_ch_pause_request         (o_src_ch_pause_request),
        .o_src_ch_pause_grant           (i_src_ch_pause_grant), 
        //RST
        .i_rst_n                        (i_rst_n),
        .o_rst_ack_n                    (o_rst_ack_n),
        .i_tx_rst_n                     (i_tx_rst_n),
        .i_rx_rst_n                     (i_rx_rst_n),
        .o_tx_rst_ack_n                 (o_tx_rst_ack_n),
        .o_rx_rst_ack_n                 (o_rx_rst_ack_n),
        //CDR clk 
        .rx_cdr_refclk_p                (refclk),
        .rx_cdr_refclk_n                (refclk_n),
        // PHY Clock Out
        .tx_clkout                      (gmii16b_tx_clk),
        .rx_clkout                      (gmii16b_rx_clk),
      //  .rx_pma_clkout                  (rx_pma_clkout), // Need to confirm
		.i_system_pll_clk                 (system_pll_clk),          
		     .i_system_pll_lock                 (system_pll_lock),          
        // PHY Operating Mode from Reconfig Block
        .xcvr_mode                      (xcvr_mode),
        .tx_pll_refclk_p                (refclk),
        .tx_pll_refclk_n                (refclk_n),
        .i_pma_cu_clk                   (flux_clk),
        .i_src_rs_grant                 (sss_grant),
        .o_src_rs_req                   (sss_req),
        .tx_serial_data                 (tx_serial_data),
        .tx_serial_data_n               (tx_serial_data_n),
        .rx_serial_data                 (rx_serial_data),
        .rx_serial_data_n                (rx_serial_data_n),
        // Transceiver Status
        .rx_is_lockedtodata             (rx_is_lockedtodata),   
        // Transceiver Reconfiguration
        .reconfig_clk                   (csr_clk),
        .reconfig_reset                 (i_rst_n),
        .reconfig_write                 (reconfig_write),
        .reconfig_read                  (reconfig_read),
        .reconfig_address               (reconfig_address),
		.reconfig_be                    (reconfig_be),  
        .reconfig_writedata             (reconfig_writedata),
        .reconfig_readdata              (reconfig_readdata),
        .reconfig_waitrequest           (reconfig_waitrequest),  
		.reconfig_readdata_valid        (reconfig_readdata_valid)      
);
    
assign channel_tx_ready = eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.o_tx_ready[0:0] ;
assign channel_rx_ready = eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.o_rx_ready[0:0] & led_link;
assign o_mac_tx_rst_ack_n = eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.o_tx_ready[0:0]  & iopll_lock ;
assign o_mac_rx_rst_ack_n = eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.o_rx_ready[0:0] & iopll_lock ;
assign o_mac_rst_ack_n = eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.o_tx_ready[0:0] & iopll_lock ; 

endmodule
