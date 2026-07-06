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
// Top Level SGMII Interface for core with embedded SERDES.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_top_sgmii_strx_gx (
   rx_carrierdetected,
   
   tx_reset_tx_mac_clk,
   tx_reset_tx_phy_clk,
   rx_reset_rx_mac_clk,
   rx_reset_rx_phy_clk,
   rx_clk,
   tx_clk,
   tx_clkena_half,
   rx_clkena_half,
   sw_reset_tx_mac_clk,
   sw_reset_tx_phy_clk,
   sw_reset_rx_mac_clk,
   sw_reset_rx_phy_clk,
   sgmii_speed_tx_mac_clk,
   sgmii_speed_tx_phy_clk,
   sgmii_speed_rx_mac_clk,
   sgmii_speed_rx_phy_clk,
   hd_ena,
   pcs_rx_clk, // connected to rx_clkout
   pcs_tx_clk,
   latency_sclk,
   latency_sclk_reset_rx,
   latency_sclk_reset_tx,
   gmii_rxdv,
   gmii_rxd,
   gmii_rxerr,
   gmii_txen,
   gmii_txd,
   gmii_txerr,
   mii_rxdv,
   mii_rxd,
   mii_rxerr,
   mii_col,
   mii_crs,
   mii_txen,
   mii_txd,
   mii_txerr,
   tx_kchar,
   tx_frame,
   rx_kchar,
   rx_frame,
   rx_detect,
   an_enable,
   unidirectional_enable,
   an_restart,
   an_restart_rst,
   use_sgmii,
   use_sgmii_an,
   an_ability,
   an_link_timer,
   an_done,
   an_ack,
   led_crs,
   page_receive,
   lp_ability,
   lp_ability_ena,
   dec_err,
   rx_sync,
   soft_rx_sync,
   calc_clk,
   rx_latency_adj,
   tx_latency_adj,
   wa_boundary,
   tx_ptp_alignment,
   eccstatus_tx_converter,
   eccstatus_rx_converter,
   latency_xcvr_rx,
   latency_xcvr_tx
);

parameter SYNCHRONIZER_DEPTH    = 3;                     //  Number of synchronizer
parameter ENABLE_SGMII       = 1;                        //  Enable SGMII logic for synthesis         
parameter ENABLE_PHASE_CALC = 0;
parameter DEVICE_FAMILY    = "ARRIAGX";                  //  Device family name
parameter ENABLE_ECC = 0;                                //  Enable ECC

input   [1:0] rx_carrierdetected;

input   tx_reset_tx_mac_clk;
input   tx_reset_tx_phy_clk;
input   rx_reset_rx_mac_clk;
input   rx_reset_rx_phy_clk;

input   sw_reset_tx_mac_clk;    //  SW Synchronous Reset
input   sw_reset_tx_phy_clk;    //  SW Synchronous Reset
input   sw_reset_rx_mac_clk;    //  SW Synchronous Reset
input   sw_reset_rx_phy_clk;    //  SW Synchronous Reset
input   rx_clk;                 //  MAC Receive Clock
input   tx_clk;                 //  MAC Transmit Clock
input   calc_clk;
//output  rx_clkena;              //  MAC Receive clock enable
//output  tx_clkena;              //  MAC Transmit clock enable
output  rx_clkena_half;              //  MAC Receive clock enable
output  tx_clkena_half;              //  MAC Transmit clock enable
input   pcs_rx_clk;             //  125MHx PCS receive clock
input   pcs_tx_clk;             //  125MHx PCS receive clock
input   latency_sclk;           //  Sampling clock for AIB fifo measurement
input   latency_sclk_reset_rx;
input   latency_sclk_reset_tx;
input   [1:0] sgmii_speed_tx_mac_clk; //  Signal Detect from PMA 
input   [1:0] sgmii_speed_tx_phy_clk; //  Signal Detect from PMA 
input   [1:0] sgmii_speed_rx_mac_clk; //  Signal Detect from PMA 
input   [1:0] sgmii_speed_rx_phy_clk; //  Signal Detect from PMA 
input   hd_ena;                 //  Half Duplex Enable     
output  [1:0] gmii_rxdv;        //  GMII Receive Enable
output  [15:0] gmii_rxd;        //  GMII Receive Data
output  [1:0] gmii_rxerr;       //  GMII Receive Error
input   [1:0] gmii_txen;        //  GMII Transmit Enable
input   [15:0] gmii_txd;        //  GMII Transmit Data
input   [1:0] gmii_txerr;        //  GMII Transmit Error
output  mii_rxdv;               //  MII Receive Enable
output  [3:0] mii_rxd;          //  MII Receive Data
output  mii_rxerr;              //  MII Receive Error
output  mii_col;                //  MII Collision
output  mii_crs;                //  MII Carrier Sense           
input   mii_txen;               //  MII Transmit Enable
input   [3:0] mii_txd;          //  MII Transmit Data
input   mii_txerr;              //  MII Transmit Error
input   rx_detect;              //  Signal Detect
input   an_enable;              //  Enable Autonegotiation
input   unidirectional_enable;  //  Enable unidirectional feature
input   an_restart;             //  Restart Autonegotiation        
output  an_restart_rst;         //  Reset Autonegotiation Command
input   use_sgmii;              //  Enable SGMII
input   use_sgmii_an;           //  Autonegotiation SGMII register        
input   [15:0] an_ability;      //  Autonegotiation Ability Register
input   [20:0] an_link_timer;   //  Link Timer Maximum Value (2 clocks)
output  an_done;                //  Autonegotiation Done
output  an_ack;                 //  Acknowledge Indication
output  page_receive;           //  Page Receive Indication
output  [15:0] lp_ability;      //  Link Partner Ability Register
output  lp_ability_ena;         //  Link Partner Ability Valid
input   [1:0] dec_err;          //  Decoded Symbol Error
input   [1:0] rx_sync;          //  Receiver Synchronized
output  [1:0] soft_rx_sync;          //  Receiver Synchronized (processed)
output  led_crs;                //  PCS Carrier Sense
output  [1:0] tx_kchar;         //  Special Character Indication
output  [15:0] tx_frame;        //  Frame
input   [1:0] rx_kchar;         //  Special Character Indication
input   [15:0] rx_frame;        //  Frame
output  [21:0] rx_latency_adj;
output  [21:0] tx_latency_adj;
input   [4:0] wa_boundary;        //  word aligner boundary   
output  tx_ptp_alignment;
output  [1:0] eccstatus_tx_converter;
output  [1:0] eccstatus_rx_converter;
input   [11:0] latency_xcvr_tx;
input   [11:0] latency_xcvr_rx;

wire    [1:0] gmii_rxdv; 
wire    [15:0] gmii_rxd;
wire    [3:0] mii_rxd; 
wire    [1:0] gmii_rxerr; 
wire    mii_col; 
wire    mii_crs; 
wire    an_restart_rst; 
wire    an_done; 
wire    an_ack; 
wire    page_receive; 
wire    [15:0] lp_ability; 
wire    lp_ability_ena; 
wire    dec_disp_err;
wire    led_crs;
wire    rx_clkena;              //  MAC Receive clock enable
wire    tx_clkena;          //
wire          rx_lane_alignment;
wire          pcs_dv_single_bit;
wire    [1:0] gmii_rxdv_int;    //  Enable
wire    [15:0] gmii_rxd_int;    //  Data
wire    [1:0] gmii_rxerr_int;   //  Error 
wire    [1:0] gmii_txen_int;    //  Enable
wire    [15:0] gmii_txd_int;    //  Data
wire    [1:0] gmii_txerr_int;   //  Error 
wire    mii_rxdv_int;           //  MII Data Valid
wire    [1:0] tx_kchar;         //  Special Character Indication
wire    [15:0] tx_frame;        //  Frame
wire    tx_ptp_alignment;
wire    pcs_rx_clkena;
alt_mge16_pcs_sgmii_clk_enable U_TXCLK_ENA (
    .reset_clk(tx_reset_tx_mac_clk),
    .clk(tx_clk),
    .ethernet_mode(sgmii_speed_tx_mac_clk),
	.clk_ena_half (tx_clkena_half),
    .clk_ena(tx_clkena));

alt_mge16_pcs_sgmii_clk_enable U_RXCLK_ENA (
    .reset_clk(rx_reset_rx_mac_clk),
    .clk(rx_clk),
    .ethernet_mode(sgmii_speed_rx_mac_clk),
	.clk_ena_half (rx_clkena_half),
    .clk_ena(rx_clkena));
    
alt_mge16_pcs_sgmii_clk_enable U_PCSRXCLK_ENA (
    .reset_clk(rx_reset_rx_phy_clk),
    .clk(pcs_rx_clk),
    .ethernet_mode(sgmii_speed_rx_phy_clk),
    .clk_ena_half (),
    .clk_ena(pcs_rx_clkena));

alt_mge16_pcs_top_pcs_strx_gx U_PCS (
          .rx_carrierdetected(rx_carrierdetected),
          
          .tx_reset_tx_phy_clk(tx_reset_tx_phy_clk), // connected to reset_tx_clk
          .rx_reset_rx_phy_clk(rx_reset_rx_phy_clk), // connected to reset_tx_clk
          .sw_reset_tx_phy_clk(sw_reset_tx_phy_clk),
          .sw_reset_rx_phy_clk(sw_reset_rx_phy_clk),
          .pcs_rx_clk(pcs_rx_clk), // connected to rx_clkout in one level above
          .pcs_tx_clk(pcs_tx_clk),
          .rx_lane_alignment(rx_lane_alignment),
          .pcs_dv_single_bit(pcs_dv_single_bit),
          .gmii_rxdv(gmii_rxdv_int),
          .gmii_rxd(gmii_rxd_int),
          .gmii_rxerr(gmii_rxerr_int),
          .gmii_txen(gmii_txen_int),
          .gmii_txd(gmii_txd_int),
          .gmii_txerr(gmii_txerr_int),
          .rx_kchar(rx_kchar),
          .rx_frame(rx_frame),
          .tx_kchar(tx_kchar),
          .tx_frame(tx_frame),
          .rx_sync(rx_sync),
          .soft_rx_sync(soft_rx_sync),
          //sbalasun .unidirectional_enable(unidirectional_enable),
          .an_enable(an_enable),
          .an_restart(an_restart),
          .an_restart_rst(an_restart_rst),
          .an_done(an_done),
          .an_link_timer(an_link_timer),
          .use_sgmii(use_sgmii),
          .use_sgmii_an(use_sgmii_an),
          .an_ability(an_ability),
          .an_ack(an_ack),
          .page_receive(page_receive),
          .lp_ability(lp_ability),
          .lp_ability_ena(lp_ability_ena),
          .gmii_crs(led_crs),
          .dec_err(dec_err));
defparam
        U_PCS.SYNCHRONIZER_DEPTH=SYNCHRONIZER_DEPTH,
        U_PCS.ENABLE_SGMII = ENABLE_SGMII;
alt_mge16_pcs_top_rx_converter U_RXCV (

          .pcs_clk_reset(rx_reset_rx_phy_clk), //connected to reset@rx_clkout
          .mac_clk_reset(rx_reset_rx_mac_clk),
          .pcs_clk(pcs_rx_clk), //connected to rx_clkout in one level above
          .mac_clk(rx_clk),
          .pcs_clkena (pcs_rx_clkena),
          .mac_clkena(rx_clkena),
          .sgmii_speed_rx_mac_clk(sgmii_speed_rx_mac_clk),
          .sgmii_speed_rx_phy_clk(sgmii_speed_rx_phy_clk),
          .sw_reset_rx_mac_clk(sw_reset_rx_mac_clk),
          .sw_reset_rx_phy_clk(sw_reset_rx_phy_clk),
          .pcs_data(gmii_rxd_int),  //sbalasun:doubled the the bit for 1g/2.5g
          .pcs_dv(gmii_rxdv_int),   //sbalasun:doubled the the bit for 1g/2.5g   
          .pcs_err(gmii_rxerr_int), //sbalasun:doubled the the bit for 1g/2.5g
          .rx_lane_alignment(rx_lane_alignment),
          .pcs_dv_single_bit(pcs_dv_single_bit),
          .mac_mii_data(mii_rxd),   
          .mac_mii_dv(mii_rxdv_int),
          .mac_mii_err(mii_rxerr),
          .mac_data(gmii_rxd),      //sbalasun:doubled the the bit for 1g/2.5g
          .mac_dv(gmii_rxdv),       //sbalasun:doubled the the bit for 1g/2.5g
          .mac_err(gmii_rxerr),     //sbalasun:doubled the the bit for 1g/2.5g
          .calc_clk(calc_clk),
          .latency_adj(rx_latency_adj),
          .wa_boundary(wa_boundary),
          .sync_status(soft_rx_sync),
          .eccstatus(eccstatus_rx_converter),
		  .latency_sclk(latency_sclk),
		  .latency_sclk_reset(latency_sclk_reset_rx),
		  .latency_xcvr_rx(latency_xcvr_rx)
       );
defparam
  U_RXCV.SYNCHRONIZER_DEPTH=SYNCHRONIZER_DEPTH,
  U_RXCV.DEVICE_FAMILY=DEVICE_FAMILY,
  U_RXCV.ENABLE_PHASE_CALC = ENABLE_PHASE_CALC,
  U_RXCV.ENABLE_ECC = ENABLE_ECC;

alt_mge16_pcs_top_tx_converter U_TXCV (

          .pcs_clk_reset(tx_reset_tx_phy_clk),
          .mac_clk_reset(tx_reset_tx_mac_clk),
          .pcs_clk(pcs_tx_clk),
          .mac_clk(tx_clk),
          .mac_clkena(tx_clkena),
		  .latency_sclk(latency_sclk),
		  .latency_sclk_reset(latency_sclk_reset_tx),
          .sgmii_speed_tx_mac_clk(sgmii_speed_tx_mac_clk),
          .sgmii_speed_tx_phy_clk(sgmii_speed_tx_phy_clk),
          .sw_reset_tx_mac_clk(sw_reset_tx_mac_clk),
          .sw_reset_tx_phy_clk(sw_reset_tx_phy_clk),
          .mac_data(gmii_txd),
          .mac_en(gmii_txen),
          .mac_err(gmii_txerr),
          .mac_mii_data(mii_txd),
          .mac_mii_en(mii_txen),
          .mac_mii_err(mii_txerr),
          .pcs_data(gmii_txd_int),
          .pcs_en(gmii_txen_int),
          .pcs_err(gmii_txerr_int),
          .calc_clk(calc_clk),
          .latency_adj(tx_latency_adj),
          .ptp_alignment(tx_ptp_alignment),
          .eccstatus(eccstatus_tx_converter),
		  .latency_xcvr_tx(latency_xcvr_tx)
       );
defparam
  U_TXCV.SYNCHRONIZER_DEPTH=SYNCHRONIZER_DEPTH,
  U_TXCV.DEVICE_FAMILY=DEVICE_FAMILY,
  U_TXCV.ENABLE_PHASE_CALC = ENABLE_PHASE_CALC,
  U_TXCV.ENABLE_ECC = ENABLE_ECC;
          
assign mii_rxdv = mii_rxdv_int ;
          
alt_mge16_pcs_carrier_sense U_SENSE (
          .reset(tx_reset_tx_mac_clk),
          .sw_reset(sw_reset_tx_mac_clk),
          .clk(tx_clk),
          .clkena(tx_clkena),
          .transmit(mii_txen),
          .receive(mii_rxdv_int),
          .gmii_crs(mii_crs));
defparam
   U_SENSE.SYNCHRONIZER_DEPTH=SYNCHRONIZER_DEPTH;

alt_mge16_pcs_colision_detect U_COL (
          .reset(tx_reset_tx_phy_clk),
          .sw_reset(sw_reset_tx_phy_clk),
          .clk(pcs_tx_clk),
          .transmit(gmii_txen_int),
          .receive(gmii_rxdv_int),
          .hd_ena(hd_ena),
          .gmii_col(mii_col));
defparam
   U_COL.SYNCHRONIZER_DEPTH=SYNCHRONIZER_DEPTH;

endmodule // module top_sgmii
