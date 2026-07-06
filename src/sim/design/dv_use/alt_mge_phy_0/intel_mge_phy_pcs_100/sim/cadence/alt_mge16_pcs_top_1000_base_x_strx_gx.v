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


// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
//
// Description : 
//
// 1000 Base X Top Level (with embedded SERDES)
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_top_1000_base_x_strx_gx (
   rx_carrierdetected,
   
   csr_reset_csr_clk,
   tx_reset_tx_mac_clk,
   tx_reset_tx_phy_clk,
   rx_reset_rx_mac_clk,
   rx_reset_rx_phy_clk,
	tx_reset_tx_mac_clk_125,
	tx_mac_clk_125,
	rx_reset_rx_mac_clk_125,
	rx_mac_clk_125,
   rx_clkena_half,
   tx_clkena_half,
   gmii_rx_dv,
   gmii_rx_d,
   gmii_rx_err,
   gmii_tx_en,
   gmii_tx_d,
   gmii_tx_err,
   mii_rx_dv,
   mii_rx_d,
   mii_rx_err,
   mii_tx_en,
   mii_tx_d,
   mii_tx_err,
   mii_col,
   mii_crs,
   tx_mac_clk,
   rx_mac_clk,
   tx_phy_clk,
   rx_phy_clk,
   tx_kchar,
   tx_frame, 
   rx_kchar,
   rx_frame,
   powerdown,
   sd_loopback,
   reg_clk,
   reg_rd,
   reg_wr,
   reg_addr,
   reg_data_in,
   reg_data_out,
   reg_busy,
   set_10,
   set_100,
   set_1000,
   hd_ena,
   led_col,
   led_panel_link,
   led_an,
   led_char_err,
   led_crs,
   led_link,
   sgmii_speed,      //  SGMII Speed
	sgmii_speed_tx_mac_clk_o,
   sgmii_speed_rx_mac_clk_o,
   sgmii_speed_tx_mac_clk_125_o,
   sgmii_speed_rx_mac_clk_125_o,
	soft_led_link,
   calc_clk,
   rx_latency_adj,
   tx_latency_adj,
   wa_boundary,
   tx_ptp_alignment,
   eccstatus_tx_converter,
   eccstatus_rx_converter,
   latency_sclk,
   latency_sclk_reset_rx,
   latency_sclk_reset_tx,
   latency_xcvr_rx,
	tx_disable,
	adapter_status,
   latency_xcvr_tx
);


parameter PHY_IDENTIFIER        = 32'h 01010101; 
parameter DEV_VERSION           = 16'h 0001; 
parameter ENABLE_SGMII          = 0;                  //  Enable SGMII logic for synthesis
parameter ENABLE_CLK_SHARING    = 0;                  //  Option to share clock for multiple channels (Clocks are rate-matched). 
parameter SYNCHRONIZER_DEPTH 	= 3;	  		      //  Number of synchronizer
parameter ENABLE_PHASE_CALC = 0;
parameter DEVICE_FAMILY    = "ARRIAV";               //  Device family name
parameter ENABLE_ECC = 0;                             //  Enable ECC

input   [1:0] rx_carrierdetected;
input   csr_reset_csr_clk;
input   tx_reset_tx_mac_clk;
input   tx_reset_tx_phy_clk;
input   rx_reset_rx_mac_clk;
input   rx_reset_rx_phy_clk;
input   tx_mac_clk;
input   rx_mac_clk;
input   tx_phy_clk;
input   rx_phy_clk;
output  rx_clkena_half;              //  MAC Receive clock enable
output  tx_clkena_half;              //  MAC Transmit clock enable
input   tx_reset_tx_mac_clk_125;
input   tx_mac_clk_125;
input   rx_reset_rx_mac_clk_125;
input   rx_mac_clk_125;
input   calc_clk;
output [21:0] rx_latency_adj;
output [21:0] tx_latency_adj;
input  [4:0] wa_boundary;
output  [1:0] gmii_rx_dv;             //  GMII Receive Enable
output  [15:0] gmii_rx_d;        //  GMII Receive Data
output  [1:0] gmii_rx_err;            //  GMII Receive Error
input   [1:0] gmii_tx_en;             //  GMII Transmit Enable
input   [15:0] gmii_tx_d;        //  GMII Transmit Data
input   [1:0] gmii_tx_err;            //  GMII Transmit Error
output  mii_rx_dv;              //  MII Receive Enable
output  [3:0] mii_rx_d;         //  MII Receive Data
output  mii_rx_err;             //  MII Receive Error
input   mii_tx_en;              //  MII Transmit Enable
input   [3:0] mii_tx_d;         //  MII Transmit Data
input   mii_tx_err;             //  MII Transmit Error
output  mii_col;                //  MII Collision
output  mii_crs;                //  MII Carrier Sense
output  [1:0] tx_kchar;               //  Special Character Indication
output  [15:0] tx_frame;         //  Frame
input   [1:0] rx_kchar;               //  Special Character Indication
input   [15:0] rx_frame;         //  Frame
output  powerdown;              //  Powers down the gxb module
output  sd_loopback;            //  Enable loopback 
input   reg_clk;                //  Register Interface Clock
input   reg_rd;                 //  Register Read Enable
input   reg_wr;                 //  Register Write Enable
input   [4:0] reg_addr;         //  Register Address
input   [15:0] reg_data_in;     //  Register Input Data 
output  [15:0] reg_data_out;    //  Register Output Data
output  reg_busy;               //  Access Busy 
output  led_crs;                //  Carrier Sense
input   [1:0] led_link;               //  Valid Link
output  led_panel_link;         //  Valid Copper and Fiber Link Status
output  [1:0] soft_led_link;               //  Valid Link (processed)
output  hd_ena;                 //  Half-Duplex Enable
output  led_col;                //  Collision Indication
output  led_an;                 //  Auto-Negotiation Status
input   [1:0] led_char_err;           //  Character Error
output  set_10;                 //  10Mbps Link Indication
output  set_100;                //  100Mbps Link Indication
output  set_1000;               //  Gigabit Link Indication
output  tx_ptp_alignment;
output  [1:0] sgmii_speed;      //  SGMII Speed
output    [1:0] sgmii_speed_tx_mac_clk_o;
output    [1:0] sgmii_speed_rx_mac_clk_o;
output    [1:0] sgmii_speed_tx_mac_clk_125_o;
output    [1:0] sgmii_speed_rx_mac_clk_125_o;

output [1:0]  eccstatus_tx_converter;
output [1:0]  eccstatus_rx_converter;

input  latency_sclk;
input  latency_sclk_reset_rx;
input  latency_sclk_reset_tx;
input  [11:0]  latency_xcvr_rx;
input  [11:0]  latency_xcvr_tx;
output  tx_disable;
input  [6:0]  adapter_status;

wire    [1:0] gmii_rx_dv;
wire    [15:0] gmii_rx_d;
wire    [1:0] gmii_rx_err;
wire    mii_rx_dv;
wire    [3:0] mii_rx_d;
wire    mii_rx_err;
wire    mii_col;
wire    mii_crs;
wire	powerdown;
wire    [15:0] reg_data_out;
wire    reg_busy;
wire    led_crs;
wire    hd_ena;
wire    led_col;
wire    led_an;
wire    led_panel_link;
wire    led_panel_link_int;
wire    set_10;
wire    set_100;
wire    set_1000;
wire    sd_loopback;
wire    [1:0] tx_kchar;               //  Special Character Indication
wire    [15:0] tx_frame;         //  Frame

// Clock crossing
wire    led_panel_link_reg;    //  Panel Link Status- synched
// Enable SGMII
wire    use_sgmii;
// use SGMII autonegotiation
wire    use_sgmii_an;


//  Status
//  ------

wire    mii_col_int;            //  Collision Indication

//  Configuration
//  -------------
//wire    [1:0] sgmii_speed;      //  SGMII Speed
wire    sgmii_duplex;           //  SGMI Duplex Mode
wire    sw_reset;               //  PHY Reset
wire    an_enable;              //  Enable Autonegotiation
wire    an_restart;             //  Restart Autonegotiation        
wire    an_restart_rst;         //  Reset Re-Negotiate Command
wire    [15:0] an_ability;      //  Autonegotiation Ability Register
wire    [20:0] link_timer;      //  Link Timer Maximim Value
wire    an_done_int;            //  Autonegotiation Done
wire    an_ack;                 //  Acknowledge Bit
wire    page_receive;           //  Page Receive Indication
wire    [15:0] lp_ability;      //  Link Partner Ability Enable
wire    lp_ability_ena;         //  Link Partner Ability Enable

wire    sw_reset_tx_mac_clk;
wire    sw_reset_tx_phy_clk;
wire    sw_reset_rx_mac_clk;
wire    sw_reset_rx_phy_clk;

wire    [1:0] sgmii_speed_tx_mac_clk;
wire    [1:0] sgmii_speed_tx_phy_clk;
wire    [1:0] sgmii_speed_rx_mac_clk;
wire    [1:0] sgmii_speed_rx_phy_clk;
wire    [1:0] sgmii_speed_tx_mac_clk_125;
wire    [1:0] sgmii_speed_rx_mac_clk_125;

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_SW_RESET_TX_MAC_CLK(
    .clk    (tx_mac_clk),
    .reset_n(~tx_reset_tx_mac_clk),
    .din    (sw_reset),
    .dout   (sw_reset_tx_mac_clk));

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_SW_RESET_TX_PHY_CLK(
    .clk    (tx_phy_clk),
    .reset_n(~tx_reset_tx_phy_clk),
    .din    (sw_reset),
    .dout   (sw_reset_tx_phy_clk));

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_SW_RESET_RX_MAC_CLK(
    .clk    (rx_mac_clk),
    .reset_n(~rx_reset_rx_mac_clk),
    .din    (sw_reset),
    .dout   (sw_reset_rx_mac_clk));

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_SW_RESET_RX_PHY_CLK(
    .clk    (rx_phy_clk),
    .reset_n(~rx_reset_rx_phy_clk),
    .din    (sw_reset),
    .dout   (sw_reset_rx_phy_clk));

alt_mge_phy_std_synchronizer_bundle #(2,SYNCHRONIZER_DEPTH) U_SYNC_SGMII_SPEED_TX_MAC_CLK(
    .clk    (tx_mac_clk),
    .reset_n(~tx_reset_tx_mac_clk),
    .din    (sgmii_speed),
    .dout   (sgmii_speed_tx_mac_clk));
alt_mge_phy_std_synchronizer_bundle #(2,SYNCHRONIZER_DEPTH) U_SYNC_SGMII_SPEED_TX_MAC_CLK_125(
    .clk    (tx_mac_clk_125),
    .reset_n(~tx_reset_tx_mac_clk_125),
    .din    (sgmii_speed),
    .dout   (sgmii_speed_tx_mac_clk_125));

alt_mge_phy_std_synchronizer_bundle #(2,SYNCHRONIZER_DEPTH) U_SYNC_SGMII_SPEED_TX_PHY_CLK(
    .clk    (tx_phy_clk),
    .reset_n(~tx_reset_tx_phy_clk),
    .din    (sgmii_speed),
    .dout   (sgmii_speed_tx_phy_clk));

alt_mge_phy_std_synchronizer_bundle #(2,SYNCHRONIZER_DEPTH) U_SYNC_SGMII_SPEED_RX_MAC_CLK(
    .clk    (rx_mac_clk),
    .reset_n(~rx_reset_rx_mac_clk),
    .din    (sgmii_speed),
    .dout   (sgmii_speed_rx_mac_clk));
alt_mge_phy_std_synchronizer_bundle #(2,SYNCHRONIZER_DEPTH) U_SYNC_SGMII_SPEED_RX_MAC_CLK_125(
    .clk    (rx_mac_clk_125),
    .reset_n(~rx_reset_rx_mac_clk_125),
    .din    (sgmii_speed),
    .dout   (sgmii_speed_rx_mac_clk_125));


alt_mge_phy_std_synchronizer_bundle #(2,SYNCHRONIZER_DEPTH) U_SYNC_SGMII_SPEED_RX_PHY_CLK(
    .clk    (rx_phy_clk),
    .reset_n(~rx_reset_rx_phy_clk),
    .din    (sgmii_speed),
    .dout   (sgmii_speed_rx_phy_clk));

//assign use_sgmii = 1'b1;

alt_mge16_pcs_top_sgmii_strx_gx U_SGMII (
    .rx_carrierdetected(rx_carrierdetected),
    
    .tx_reset_tx_mac_clk(tx_reset_tx_mac_clk),
    .tx_reset_tx_phy_clk(tx_reset_tx_phy_clk),
    .rx_reset_rx_mac_clk(rx_reset_rx_mac_clk),
    .rx_reset_rx_phy_clk(rx_reset_rx_phy_clk),
    .rx_clk(rx_mac_clk),
    .tx_clk(tx_mac_clk),
    .rx_clkena_half(rx_clkena_half),
    .tx_clkena_half(tx_clkena_half),
    .sw_reset_tx_mac_clk(sw_reset_tx_mac_clk),
    .sw_reset_tx_phy_clk(sw_reset_tx_phy_clk),
    .sw_reset_rx_mac_clk(sw_reset_rx_mac_clk),
    .sw_reset_rx_phy_clk(sw_reset_rx_phy_clk),
    .sgmii_speed_tx_mac_clk(sgmii_speed_tx_mac_clk),
    .sgmii_speed_tx_phy_clk(sgmii_speed_tx_phy_clk),
    .sgmii_speed_rx_mac_clk(sgmii_speed_rx_mac_clk),
    .sgmii_speed_rx_phy_clk(sgmii_speed_rx_phy_clk),
    .hd_ena(sgmii_duplex),
    .pcs_rx_clk(rx_phy_clk),
    .pcs_tx_clk(tx_phy_clk),
	.latency_sclk(latency_sclk),
	.latency_sclk_reset_rx(latency_sclk_reset_rx),
	.latency_sclk_reset_tx(latency_sclk_reset_tx),
    .gmii_rxdv(gmii_rx_dv),
    .gmii_rxd(gmii_rx_d),
    .gmii_rxerr(gmii_rx_err),
    .gmii_txen(gmii_tx_en),
    .gmii_txd(gmii_tx_d),
    .gmii_txerr(gmii_tx_err),
    .mii_rxdv(mii_rx_dv),
    .mii_rxd(mii_rx_d),
    .mii_rxerr(mii_rx_err),
    .mii_col(mii_col_int),
    .mii_crs(mii_crs),
    .mii_txen(mii_tx_en),
    .mii_txd(mii_tx_d),
    .mii_txerr(mii_tx_err),
    .tx_kchar(tx_kchar),
    .tx_frame(tx_frame),
    .rx_kchar(rx_kchar),
    .rx_frame(rx_frame),
    .rx_detect(1'b1),
    .led_crs(led_crs),
    .unidirectional_enable(1'b0),
    .use_sgmii(use_sgmii),
    .use_sgmii_an(use_sgmii_an),
    .an_enable(an_enable),
    .an_restart(an_restart),
    .an_restart_rst(an_restart_rst),
    .an_ability(an_ability),
    .an_link_timer(link_timer),
    .an_done(an_done_int),
    .an_ack(an_ack),
    .page_receive(page_receive),
    .lp_ability(lp_ability),
    .lp_ability_ena(lp_ability_ena),
    .dec_err(led_char_err),
    .rx_sync(led_link),
    .soft_rx_sync(soft_led_link),
    .calc_clk(calc_clk),
    .rx_latency_adj(rx_latency_adj),
    .tx_latency_adj(tx_latency_adj),
    .wa_boundary(wa_boundary),
    .tx_ptp_alignment(tx_ptp_alignment),
    .eccstatus_tx_converter(eccstatus_tx_converter),
    .eccstatus_rx_converter(eccstatus_rx_converter),
	.latency_xcvr_tx(latency_xcvr_tx),
	.latency_xcvr_rx(latency_xcvr_rx)
 );
defparam
  U_SGMII.SYNCHRONIZER_DEPTH=SYNCHRONIZER_DEPTH,
  U_SGMII.ENABLE_SGMII = ENABLE_SGMII,
  U_SGMII.DEVICE_FAMILY = DEVICE_FAMILY,
  U_SGMII.ENABLE_PHASE_CALC = ENABLE_PHASE_CALC,
  U_SGMII.ENABLE_ECC = ENABLE_ECC;

assign set_10   = (sgmii_speed==2'b00) ? 1'b1 : 1'b0 ;
assign set_100  = (sgmii_speed==2'b01) ? 1'b1 : 1'b0 ;
assign set_1000 = (sgmii_speed==2'b10) ? 1'b1 : 1'b0 ;
assign hd_ena   = sgmii_duplex;

assign mii_col  = mii_col_int ;
assign led_col  = mii_col_int ;
assign hd_ena   = sgmii_duplex ;
assign led_an   = an_done_int ;

alt_mge16_pcs_control U_REG (   

        .rx_clk(rx_phy_clk),
        .reset_rx_clk(rx_reset_rx_phy_clk),
        .reset_reg_clk(csr_reset_csr_clk),
        .reg_clk(reg_clk),
        .rd(reg_rd),
        .wr(reg_wr),
        .sel(reg_addr),
        .data_in(reg_data_in),
        .data_out(reg_data_out),
        .busy(reg_busy),
        .sw_reset(sw_reset),
        .loopback_ena(sd_loopback),
        .powerdown(powerdown),
        .link_status(&soft_led_link),
        .an_enable(an_enable),
        .an_restart(an_restart),
        .an_ability(an_ability),
        .link_timer(link_timer),
        .an_restart_rst(an_restart_rst),
        .an_done(an_done_int),
        .an_ack(an_ack),
        .page_receive(page_receive),
        .lp_ability_ena(lp_ability_ena),
        .lp_ability(lp_ability),
        .sgmii_speed(sgmii_speed),
		.led_panel_link(led_panel_link_int),
        .use_sgmii (use_sgmii),
        .use_sgmii_an(use_sgmii_an),
		  .tx_disable(tx_disable),
		  .adapter_status (adapter_status),

        .sgmii_duplex(sgmii_duplex));

defparam
    U_REG.PHY_IDENTIFIER = PHY_IDENTIFIER,
    U_REG.DEV_VERSION = DEV_VERSION,
    U_REG.ENABLE_SGMII = ENABLE_SGMII,
    U_REG.SYNCHRONIZER_DEPTH = SYNCHRONIZER_DEPTH;

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_1(
   .clk(rx_phy_clk), // INPUT
   .reset_n(~rx_reset_rx_phy_clk), //INPUT
   .din(led_panel_link_int), //INPUT
   .dout(led_panel_link_reg));// OUTPUT
   
assign led_panel_link   = led_panel_link_reg ;
assign sgmii_speed_tx_mac_clk_o = sgmii_speed_tx_mac_clk;
assign sgmii_speed_rx_mac_clk_o = sgmii_speed_rx_mac_clk;
assign sgmii_speed_tx_mac_clk_125_o = sgmii_speed_tx_mac_clk_125;
assign sgmii_speed_rx_mac_clk_125_o= sgmii_speed_rx_mac_clk_125;

endmodule // module top_1000_base_x_strx_gx
