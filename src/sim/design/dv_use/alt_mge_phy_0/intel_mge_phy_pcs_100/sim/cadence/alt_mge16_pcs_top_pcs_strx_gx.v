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
// 1000 Base X Top Level PCS (with embedded SERDES).
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_top_pcs_strx_gx (
   rx_carrierdetected,
   
   tx_reset_tx_phy_clk,
   rx_reset_rx_phy_clk,
   sw_reset_tx_phy_clk,
   sw_reset_rx_phy_clk,
   pcs_rx_clk,
   pcs_tx_clk,
   rx_lane_alignment,
   pcs_dv_single_bit,
   gmii_rxdv,
   gmii_rxd,
   gmii_rxerr,
   gmii_txen,
   gmii_txd,
   gmii_txerr,
   rx_kchar,
   rx_frame,
   tx_kchar,
   tx_frame,   
   rx_sync,
   soft_rx_sync,
   an_enable,
   an_restart,
   an_restart_rst,
   an_done,
   an_link_timer,
   use_sgmii,
   use_sgmii_an,
   an_ability,
   an_ack,
   page_receive,
   lp_ability,
   lp_ability_ena,
   gmii_crs,
   dec_err);

parameter SYNCHRONIZER_DEPTH 	= 3;	  	//  Number of synchronizer   
parameter ENABLE_SGMII       = 1;                 //  Enable SGMII logic for synthesis   
input   [1:0] rx_carrierdetected;
input   tx_reset_tx_phy_clk;
input   rx_reset_rx_phy_clk;
input   sw_reset_tx_phy_clk;    //  SW Synchronous Reset           
input   sw_reset_rx_phy_clk;    //  SW Synchronous Reset           
input   pcs_rx_clk;             //  PCS Receive Clock  
input   pcs_tx_clk;             //  PCS Transmit Clock 
output  rx_lane_alignment;
output  pcs_dv_single_bit;
output  [1:0] gmii_rxdv;              //  Enable
output  [15:0] gmii_rxd;         //  Data
output  [1:0] gmii_rxerr;             //  Error
input   [1:0] gmii_txen;              //  Enable
input   [15:0] gmii_txd;         //  Data
input   [1:0] gmii_txerr;             //  Error
output  [1:0] tx_kchar;               //  Special Character Indication
output  [15:0] tx_frame;         //  Frame
input   [1:0] rx_kchar;               //  Special Character Indication
input   [15:0] rx_frame;         //  Frame

input   [1:0] rx_sync;                //  Receive Synchronized
output  [1:0] soft_rx_sync;                //  Receive Synchronized (processed)
input   an_enable;              //  Enable Autonegotiation
input   an_restart;             //  Restart Autonegotiation
output  an_restart_rst;         //  Reset Autonegotiation Command
output  an_done;                //  Autonegotiation Done
output  an_ack;                 //  Acknowledge Indication
output  page_receive;           //  Page Receive Indication
input   [20:0] an_link_timer;   //  Link Timer Maximum Value (2 clocks)
input   [15:0] an_ability;      //  Autonegotiation Ability Register
input   use_sgmii;              //  Enable SGMII
input   use_sgmii_an;           //  Autonegotiation SGMII Register bit
output  [15:0] lp_ability;      //  Link Partner Ability Register
output  lp_ability_ena;         //  Link Partner Ability Valid
output  gmii_crs;               //  Carrier Sense
input   [1:0] dec_err;                //  Decoded Symbol Error

wire    [1:0] gmii_rxdv; 
wire    [15:0] gmii_rxd; 
wire    [1:0] gmii_rxerr;
wire    an_done; 
wire    page_receive; 
wire    [15:0] lp_ability;
wire    use_sgmii;
wire    use_sgmii_an;  
wire    lp_ability_ena;
wire    [15:0] an_ability;
wire    an_restart_rst;
wire    gmii_crs;

wire    tx_active;              //  Frame Transmission Active
wire    rx_active;              //  Frame Receive Active
wire    [1:0] tx_kchar;               //  Special Character Indication
wire    [15:0] tx_frame;         //  Frame

//  Autonegotiation
//  ---------------

wire    an_txena;               //  Transmit Enable
wire    an_txidle;              //  Idle Transmit Enable
wire    [15:0] lp_ability_i;    //  Link Partner Ability Register
wire    lp_ability_ena_i;       //  Link Partner Ability Valid
wire    [15:0] an_ability_out;  //  Ability Register
wire    rx_idle_ena;            //  Idle Received   
wire    rx_invalid;             //  Invalid Signal       
wire    an_ack;                 //  Acknowledge Indication

wire    gnd; 
assign  gnd = 1'b 0; 


alt_mge16_pcs_top_autoneg U_AUTONEG (

          .reset(rx_reset_rx_phy_clk),
          .sw_reset(sw_reset_rx_phy_clk),
          .clk(pcs_rx_clk),
          .an_enable(an_enable),
          .an_restart(an_restart),
          .an_restart_rst(an_restart_rst),
          .rx_sync(&soft_rx_sync),
          .rx_invalid(rx_invalid),
          .lp_ability(lp_ability_i),
          .lp_ability_ena(lp_ability_ena_i),
          .idle_ena(rx_idle_ena),
          .max_link_timer(an_link_timer),
          .use_sgmii(use_sgmii),
          .use_sgmii_an(use_sgmii_an),
          .an_ability_in(an_ability),
          .an_ability_out(an_ability_out),
          .page_receive(page_receive),
          .an_done(an_done),
          .an_ack(an_ack),
          .an_txidle(an_txidle),
          .an_txena(an_txena));
defparam
	U_AUTONEG.SYNCHRONIZER_DEPTH =SYNCHRONIZER_DEPTH,
	U_AUTONEG.ENABLE_SGMII = ENABLE_SGMII;
alt_mge16_pcs_rx_encapsulation_strx_gx U_RCAPS (
          
          .reset(rx_reset_rx_phy_clk),
          .sw_reset(sw_reset_rx_phy_clk),
          .clk(pcs_rx_clk),
          .rx_invalid(rx_invalid),
          .rx_sync(rx_sync),
          .receive(rx_active),
          .idle_ena(rx_idle_ena),
          .lp_ability(lp_ability_i),
          .lp_ability_ena(lp_ability_ena_i),
          .kchar(rx_kchar),
          .frame(rx_frame),
          .char_err(dec_err),
          .carrier_detect(rx_carrierdetected),
          .xmit_data(an_txena),
          .soft_rx_sync(soft_rx_sync),
          .rx_lane_alignment(rx_lane_alignment),
          .pcs_dv_single_bit(pcs_dv_single_bit),
          .gmii_dv(gmii_rxdv),
          .gmii_err(gmii_rxerr),
          .gmii_data(gmii_rxd));

assign lp_ability     = lp_ability_i; 
assign lp_ability_ena = lp_ability_ena_i; 

alt_mge16_pcs_tx_encapsulation U_TCAPS (

          .reset(tx_reset_tx_phy_clk),
          .sw_reset(sw_reset_tx_phy_clk),
          .clk(pcs_tx_clk),
          .tx_ena(an_txena),
          .tx_idle(an_txidle),
          .an_ability(an_ability_out),
          .an_ena(an_enable),
          .gmii_dv(gmii_txen),
          .gmii_ctl(gmii_txerr),
          .gmii_data(gmii_txd),
          .disparity(gnd),
          .transmit(tx_active),
          .kchar(tx_kchar),
          .frame(tx_frame));

alt_mge16_pcs_carrier_sense U_SENS (

          .reset(tx_reset_tx_phy_clk),
          .sw_reset(sw_reset_tx_phy_clk),
          .clk(pcs_tx_clk),
          .clkena(1'b1),
          .transmit(tx_active),
          .receive(rx_active),
          .gmii_crs(gmii_crs));

endmodule // module top_pcs
