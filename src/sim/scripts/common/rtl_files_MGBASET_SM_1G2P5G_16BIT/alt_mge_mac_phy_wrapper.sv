`timescale 1 ps / 1 ps

//`include "nvs_eth_top_defines.h"

//  ===================================================================================================
//  *** MGE Variant ***
//  ===================================================================================================
//`ifndef ETH_MGBASET_MAC_PHY_MODE_DE
module alt_mge_mac_phy_wrapper #(
    parameter NUM_OF_CHANNEL = 1
) (     
  
  // clock and reset
  input wire          refclk,
  input wire          reset,
  input               i_rst_n , 
    input               i_tx_rst_n,
    input               i_rx_rst_n,
  // csr interface
  input  wire         csr_read,
  input  wire         csr_write,
  input  wire [31:0]  csr_writedata,
  output wire [31:0]  csr_readdata,
  input  wire [19:0]  csr_address,
  output wire         csr_waitrequest,
  
  //avlon_st tx interface
  input  wire         avalon_st_tx_startofpacket,
  input  wire         avalon_st_tx_endofpacket,
  input  wire         avalon_st_tx_valid,
  input  wire [31:0]  avalon_st_tx_data,
  input  wire  [1:0]  avalon_st_tx_empty,
  input  wire         avalon_st_tx_error,
  output wire         avalon_st_tx_ready,
  
  // avalon_st rx interface
  output wire         avalon_st_rx_startofpacket,
  output wire         avalon_st_rx_endofpacket,
  output wire         avalon_st_rx_valid,
  output wire [31:0]  avalon_st_rx_data,
  output wire  [1:0]  avalon_st_rx_empty,
  input  wire         avalon_st_rx_ready,
  output wire  [5:0]  avalon_st_rx_error,
    
  // additional st interface
  input  wire  [1:0]  avalon_st_pause_data,
  output wire         avalon_st_txstatus_valid,
  output wire [39:0]  avalon_st_txstatus_data, 
  output wire  [6:0]  avalon_st_txstatus_error,
  
  output wire         avalon_st_rxstatus_valid,                                  
  output wire  [6:0]  avalon_st_rxstatus_error,                                  
  output wire [39:0]  avalon_st_rxstatus_data,
  
  output wire         tx_serial_data,
  input wire          rx_serial_data,
  output wire         mac_clk,
  output wire         tx_digitalreset_mac_clk,
  output wire         rx_digitalreset_mac_clk,
  output wire         channel_tx_ready,
  output wire         channel_rx_ready
  
);

wire          mac_csr_read;
wire          mac_csr_write;
wire  [31:0]  mac_csr_readdata;
wire  [31:0]  mac_csr_writedata;
wire          mac_csr_waitrequest;
wire  [9:0]   mac_csr_address;

wire          phy_csr_read;
wire          phy_csr_write;
wire  [15:0]  phy_csr_readdata;
wire  [15:0]  phy_csr_writedata;
wire          phy_csr_waitrequest;
wire  [4:0]   phy_csr_address;

// Reconfig CSR
wire [ 1:0]   rcfg_csr_address;
wire          rcfg_csr_read;
wire          rcfg_csr_write;
wire [31:0]   rcfg_csr_writedata;
wire [31:0]   rcfg_csr_readdata;

// Data Path Readiness
wire          channel_tx_ready;
wire          channel_rx_ready;


// Core PLL
wire        core_pll_locked;
reg         clk_156_25;


initial clk_156_25 = 1'b0;
always #3200 clk_156_25 = ~clk_156_25;
assign mac_clk = clk_156_25; 


    alt_mge_rd #(
        .NUM_OF_CHANNEL                 (1)
    ) U_DUT (

        // CSR Clock
        .csr_clk                        (refclk),
        
        // MAC Clock
        .mac_clk                        (mac_clk),
        
		// Reference Clock
		.refclk                         (refclk),
		
        // Reset
        .reset                          (reset),
        .tx_digitalreset                (tx_digitalreset),
        .rx_digitalreset                (rx_digitalreset),
        
        // MAC CSR
           .i_rst_n                     (i_rst_n), 
           .i_tx_rst_n               (i_tx_rst_n),
           .i_rx_rst_n               (i_rx_rst_n),
        .csr_mac_address                (mac_csr_address),
        .csr_mac_read                   (mac_csr_read),
        .csr_mac_write                  (mac_csr_write),
        .csr_mac_writedata              (mac_csr_writedata),
        .csr_mac_readdata               (mac_csr_readdata),
        .csr_mac_waitrequest            (mac_csr_waitrequest),
        
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
        .avalon_st_txstatus_valid       (),
        .avalon_st_txstatus_data        (),
        .avalon_st_txstatus_error       (),
        
        // MAC RX Frame Status
        .avalon_st_rxstatus_valid       (),
        .avalon_st_rxstatus_data        (),
        .avalon_st_rxstatus_error       (),
        
        // MAC TX Pause Frame Generation Command
        .avalon_st_pause_data           (2'b00),
        
        // PHY CSR
        .csr_phy_address                (phy_csr_address),
        .csr_phy_read                   (phy_csr_read),
        .csr_phy_write                  (phy_csr_write),
        .csr_phy_writedata              (phy_csr_writedata),
        .csr_phy_readdata               (phy_csr_readdata),
        .csr_phy_waitrequest            (phy_csr_waitrequest),
        
        // PHY Status
        .led_link                       (),
        .led_char_err                   (),
        .led_disp_err                   (),
        
        // Transceiver Serial Interface
        .tx_serial_data                 (tx_serial_data),
        .rx_serial_data                 (rx_serial_data),
        
        // Data Path Readiness
        .channel_tx_ready               (channel_tx_ready),
        .channel_rx_ready               (channel_rx_ready),
        
        // Reconfig CSR
        .csr_rcfg_address               (rcfg_csr_address),
        .csr_rcfg_read                  (rcfg_csr_read),
        .csr_rcfg_write                 (rcfg_csr_write),
        .csr_rcfg_writedata             (rcfg_csr_writedata),
        .csr_rcfg_readdata              (rcfg_csr_readdata)
        
    );


 
       
endmodule 
//`endif

//  ===================================================================================================
//  *** MGBASET Variant ***
//  ===================================================================================================
/*`ifdef ETH_MGBASET_MAC_PHY_MODE_DE
module altera_bic_mgbaset_mac_phy_wrapper (
  
  // clock and reset
  input wire          refclk_1g2p5g,
  //input wire          refclk_10g,
  input wire          reset,
  
  // csr interface
  input  wire         csr_read,
  input  wire         csr_write,
  input  wire [31:0]  csr_writedata,
  output wire [31:0]  csr_readdata,
  input  wire [19:0]  csr_address,
  output wire         csr_waitrequest,
  
  //avlon_st tx interface
  input  wire         avalon_st_tx_startofpacket,
  input  wire         avalon_st_tx_endofpacket,
  input  wire         avalon_st_tx_valid,
  input  wire [63:0]  avalon_st_tx_data,
  input  wire  [2:0]  avalon_st_tx_empty,
  input  wire         avalon_st_tx_error,
  output wire         avalon_st_tx_ready,
  
  // avalon_st rx interface
  output wire         avalon_st_rx_startofpacket,
  output wire         avalon_st_rx_endofpacket,
  output wire         avalon_st_rx_valid,
  output wire [63:0]  avalon_st_rx_data,
  output wire  [2:0]  avalon_st_rx_empty,
  input  wire         avalon_st_rx_ready,
  output wire  [5:0]  avalon_st_rx_error,
    
  // additional st interface
  input  wire  [1:0]  avalon_st_pause_data,
  output wire         avalon_st_txstatus_valid,
  output wire [39:0]  avalon_st_txstatus_data, 
  output wire  [6:0]  avalon_st_txstatus_error,
  
  output wire         avalon_st_rxstatus_valid,                                  
  output wire  [6:0]  avalon_st_rxstatus_error,                                  
  output wire [39:0]  avalon_st_rxstatus_data,
  
  output wire         tx_serial_data,
  input wire          rx_serial_data,
  output wire         mac_clk,
  output wire         tx_digitalreset_mac_clk,
  output wire         mac64b_clk,
  output  			  refclk_10g_out,
  output wire         rx_pma_clkout

);

wire          mac_csr_read;
wire          mac_csr_write;
wire  [31:0]  mac_csr_readdata;
wire  [31:0]  mac_csr_writedata;
wire          mac_csr_waitrequest;
wire  [9:0]   mac_csr_address;

wire          phy_csr_read;
wire          phy_csr_write;
wire  [31:0]  phy_csr_readdata;
wire  [31:0]  phy_csr_writedata;
wire          phy_csr_waitrequest;
wire  [10:0]  phy_csr_address;

// Reconfig CSR
wire [ 1:0]   rcfg_csr_address;
wire          rcfg_csr_read;
wire          rcfg_csr_write;
wire [31:0]   rcfg_csr_writedata;
wire [31:0]   rcfg_csr_readdata;

// Data Path Readiness
wire          channel_tx_ready;
wire          channel_rx_ready;

wire [71:0] xgmii_sdr_rx_avst;
wire [71:0] xgmii_sdr_tx_avst;

// Core PLL
wire        core_pll_locked;

// wire         mac64b_clk; 	// 156.25 Mhz

reg refclk_10g;

initial begin
	refclk_10g  = 1'b0; 
end

//always #((`ETH_XSBI_CLOCK)*2) refclk_10g = ~refclk_10g; //322.265625
always #((`ETH_XSBI_CLOCK)) refclk_10g = ~refclk_10g; //644.53125

assign refclk_10g_out = refclk_10g;

    // Core PLL
    alt_mge_core_pll core_pll (
        .pll_refclk0        (refclk_10g),
        .pll_powerdown      (reset),
        .outclk0            (mac64b_clk),
        .outclk1            (mac_clk),
        .pll_locked         (core_pll_locked),
        .pll_cal_busy       ()
    );


    alt_mge_rd #(
        .NUM_OF_CHANNEL                 (1)
    ) U_DUT (

        // CSR Clock
        .csr_clk                        (refclk_1g2p5g),
        
        // MAC Clock
        .mac_clk                        (mac_clk),
        
		// XGMII Clock
		.mac64b_clk                     (mac64b_clk), 
			
		// Reference Clock
		.refclk_1g2p5g                  (refclk_1g2p5g),
		.refclk_10g                     (refclk_10g),
			
		// MAC Status
		.xgmii_rx_link_fault_status     (),
			
		// PHY
		.rx_block_lock                  (),
		.rx_pma_clkout                  (rx_pma_clkout),
			
        // Reset
        .reset                          (reset),
        .tx_digitalreset                (tx_digitalreset),
        .rx_digitalreset                (rx_digitalreset),
        
        // MAC CSR
        .csr_mac_address                (mac_csr_address),
        .csr_mac_read                   (mac_csr_read),
        .csr_mac_write                  (mac_csr_write),
        .csr_mac_writedata              (mac_csr_writedata),
        .csr_mac_readdata               (mac_csr_readdata),
        .csr_mac_waitrequest            (mac_csr_waitrequest),
        
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
        .avalon_st_txstatus_valid       (),
        .avalon_st_txstatus_data        (),
        .avalon_st_txstatus_error       (),
        
        // MAC RX Frame Status
        .avalon_st_rxstatus_valid       (),
        .avalon_st_rxstatus_data        (),
        .avalon_st_rxstatus_error       (),
        
        // MAC TX Pause Frame Generation Command
        .avalon_st_pause_data           (2'b00),
 	
        // PHY CSR
        .csr_phy_address                (phy_csr_address),
        .csr_phy_read                   (phy_csr_read),
        .csr_phy_write                  (phy_csr_write),
        .csr_phy_writedata              (phy_csr_writedata),
        .csr_phy_readdata               (phy_csr_readdata),
        .csr_phy_waitrequest            (phy_csr_waitrequest),
        
        // PHY Status
        .led_link                       (),
        .led_char_err                   (),
        .led_disp_err                   (),

		 
        // Transceiver Serial Interface
        .tx_serial_data                 (tx_serial_data),
        .rx_serial_data                 (rx_serial_data),
		 
        // Data Path Readiness
        .channel_tx_ready               (channel_tx_ready),
        .channel_rx_ready               (channel_rx_ready),
        
        // Reconfig CSR
        .csr_rcfg_address               (rcfg_csr_address),
        .csr_rcfg_read                  (rcfg_csr_read),
        .csr_rcfg_write                 (rcfg_csr_write),
        .csr_rcfg_writedata             (rcfg_csr_writedata),
        .csr_rcfg_readdata              (rcfg_csr_readdata),
        
        // Native PHY Reconfig CSR
        .csr_native_phy_rcfg_address(),
        .csr_native_phy_rcfg_read(),
        .csr_native_phy_rcfg_write(),
        .csr_native_phy_rcfg_writedata(),
        .csr_native_phy_rcfg_readdata(),
        .csr_native_phy_rcfg_waitrequest()
        
    );


 
    // Avalon-MM Address Decoder
    alt_mge_rd_addrdec_mch csr_address_decoder (
		.csr_clk_clk                (refclk_1g2p5g),
		.csr_clk_reset_reset_n      (~reset),

		.mac_clk_clk               (mac64b_clk),                  
		.mac_clk_reset_reset_n     (~reset), 
		          
		.jtag_slave_address        (32'h0),
		.jtag_slave_write          (1'b0),
		.jtag_slave_read           (1'b0),
		.jtag_slave_writedata      (32'h0),
		.jtag_slave_readdata       (),
		.jtag_slave_readdatavalid  (),
		.jtag_slave_waitrequest    (),

		.slave_address             ({csr_address,2'b0}),
		.slave_write               (csr_write),
		.slave_read                (csr_read),
		.slave_writedata           (csr_writedata),
		.slave_readdata            (csr_readdata),
		.slave_waitrequest         (csr_waitrequest),
        
		.mge_reconfig_address      (rcfg_csr_address),
		.mge_reconfig_read         (rcfg_csr_read),
		.mge_reconfig_write        (rcfg_csr_write),
		.mge_reconfig_writedata    (rcfg_csr_writedata),
		.mge_reconfig_readdata     (rcfg_csr_readdata),
		
		.channel_0_mac_address     (mac_csr_address),
		.channel_0_mac_read        (mac_csr_read),
		.channel_0_mac_write       (mac_csr_write),
		.channel_0_mac_writedata   (mac_csr_writedata),
		.channel_0_mac_readdata    (mac_csr_readdata),
		.channel_0_mac_waitrequest (mac_csr_waitrequest),
        
		.channel_0_phy_address     (phy_csr_address),
		.channel_0_phy_read        (phy_csr_read),
		.channel_0_phy_write       (phy_csr_write),
		.channel_0_phy_writedata   (phy_csr_writedata),
		.channel_0_phy_readdata    (phy_csr_readdata),
		.channel_0_phy_waitrequest (phy_csr_waitrequest),

		.channel_0_1_traffic_controller_address     (),
		.channel_0_1_traffic_controller_read        (),
		.channel_0_1_traffic_controller_write       (),
		.channel_0_1_traffic_controller_writedata   (),
		.channel_0_1_traffic_controller_readdata    (32'h0),
		.channel_0_1_traffic_controller_waitrequest (1'b0)
	);

        // Reset Synchronizer
        altera_reset_synchronizer #(
            .DEPTH      (2),
            .ASYNC_RESET(1)
        ) tx_digitalreset_sync (
            //.clk        (mac_clk),
			.clk        (mac64b_clk),	
            .reset_in   (tx_digitalreset),
            .reset_out  (tx_digitalreset_mac_clk)
        );
        
        altera_reset_synchronizer #(
            .DEPTH      (2),
            .ASYNC_RESET(1)
        ) rx_digitalreset_sync (
            .clk        (mac_clk),
            .reset_in   (rx_digitalreset),
            .reset_out  (rx_digitalreset_mac_clk)
        );

        // Override MIF file parameter for simulation only
        defparam `ETH_TB_TOP_WRAPPER.U_TOP_DUT_WRAPPER.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_0_INIT_FILE = "rcfg/alt_mge_rcfg_a10_xcvr_1g.mif";
        defparam `ETH_TB_TOP_WRAPPER.U_TOP_DUT_WRAPPER.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_1_INIT_FILE = "rcfg/alt_mge_rcfg_a10_xcvr_2p5g.mif";
        defparam `ETH_TB_TOP_WRAPPER.U_TOP_DUT_WRAPPER.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_2_INIT_FILE = "rcfg/alt_mge_rcfg_a10_xcvr_10g.mif";
    
endmodule 
`endif */
