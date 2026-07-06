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


`timescale 1ps/1ps
 
module alt_tse16_gmii_16b_conv (
   // Clocks
   input           tx_mac_clk,
   input           rx_mac_clk,
   input           tx_mac_clk_125,
   input           rx_mac_clk_125,
   input           tx_reset_tx_mac_clk_125,      
   input           rx_reset_rx_mac_clk_125, 
   input           tx_reset_tx_mac_clk, 
   input           rx_reset_rx_mac_clk,       
 
   // Clock enables
   output          tx_16b_clkena,
   output          rx_16b_clkena,
   output          tx_clkena,
   output          rx_clkena,
   // SGMII speeds
   input    [1:0]  sgmii_speed_tx_mac_clk,
   input    [1:0]  sgmii_speed_rx_mac_clk,
   input    [1:0]  sgmii_speed_tx_mac_clk_125,
   input    [1:0]  sgmii_speed_rx_mac_clk_125,
 
//   // MII
//   output          mii_rx_en,
//   output [3:0]    mii_rx_d,
//   output          mii_rx_err,
// 
//   input           mii_tx_en,
//   input  [3:0]    mii_tx_d,
//   input           mii_tx_err,
// 
   // GMII 8b
   output          gmii_8b_rx_dv,
   output [7:0]    gmii_8b_rx_d,
   output          gmii_8b_rx_err,
 
   input           gmii_8b_tx_en,
   input [7:0]     gmii_8b_tx_d,
   input           gmii_8b_tx_err,
 
   // GMII 16b
   input  [1:0]    gmii_16b_rx_dv,
   input  [15:0]   gmii_16b_rx_d,
   input  [1:0]    gmii_16b_rx_err,
 
   output [1:0]    gmii_16b_tx_en,
   output [15:0]   gmii_16b_tx_d,
   output [1:0]    gmii_16b_tx_err
);
 
//TX
    wire         tx_16b_clkena_half;
    wire         rx_16b_clkena_half;
    wire         tx_clkena_half;
    wire         rx_clkena_half;
    wire         frm_mii_conv_gmii_8b_tx_en;
    wire [7:0]   frm_mii_conv_gmii_8b_tx_d;
    wire         frm_mii_conv_gmii_tx_err;
    wire         mii_alignment_status;
//    wire         gmii_8b_tx_en_sel;
//    wire [7:0]   gmii_8b_tx_d_sel;
//    wire         gmii_tx_err_sel;
    
//alt_tse16_pcs_mii_rx_if_pcs tx_mii4_gmii8_if(
//    .reset      (tx_reset_tx_mac_clk_125),                  //INPUT :  Reset
//    .rx_clk     (tx_mac_clk_125),                 //INPUT :  MII Clock
//    .rx_clkena  (tx_clkena),                //INPUT :  MII Clock Enable
//    .clk_ena    (tx_clkena_half), //INPUT :  MII Clock Enable (Half rate)
//    .mii_rxd    (mii_tx_d),                //INPUT :  MII receive data 4bit
//    .mii_rxdv   (mii_tx_en),               //INPUT :  MII receive frame enable  
//    .mii_rxerr  (mii_tx_err),              //INPUT :  MII receive frame error
//    .mii_rxd_o  (frm_mii_conv_gmii_8b_tx_d),              //OUTPUT:  MII receive data
//    .mii_rxdv_o (frm_mii_conv_gmii_8b_tx_en),             //OUTPUT:  MII receive frame enable  
//    .mii_rxerr_o(frm_mii_conv_gmii_tx_err),            //OUTPUT:  MII receive frame error
//    .mii_alignment_status(mii_alignment_status)     //OUTPUT:  Status of the alignment for latency calculation
//);
// 
// 
//assign gmii_8b_tx_d_sel =   (sgmii_speed_tx_mac_clk ==2'b10) ? gmii_8b_tx_d  : frm_mii_conv_gmii_8b_tx_d ;
//assign gmii_8b_tx_en_sel =  (sgmii_speed_tx_mac_clk ==2'b10) ? gmii_8b_tx_en : frm_mii_conv_gmii_8b_tx_en ;
//assign gmii_tx_err_sel = (sgmii_speed_tx_mac_clk ==2'b10) ? gmii_8b_tx_err: frm_mii_conv_gmii_tx_err ;
// 
    alt_tse16_8_to_16_gmii_conversion tx_gmii_conversion
    (
       // Fast clock and reset (312.5 MHz)
       .clk_gmii_in         (tx_mac_clk_125),
       .reset_gmii_in_n     (~tx_reset_tx_mac_clk_125),
       
       // Slow clock and reset (156.25 MHz)
       .clk_gmii16b_out     (tx_mac_clk),
       .reset_gmii16b_out_n (~tx_reset_tx_mac_clk),
       //clock ena
       
        .tx_16b_clkena      (tx_16b_clkena_half),
        .tx_clkena          (tx_clkena_half),
        
       // GMII data and control in fast clock domain
       .gmii_data_in        (gmii_8b_tx_d),
       .gmii_control_in     (gmii_8b_tx_en),
       .gmii_error_in       (gmii_8b_tx_err),
       
       // GMII data and control in slow clock domain
       .gmii16b_data_out    (gmii_16b_tx_d),
       .gmii16b_control_out (gmii_16b_tx_en),
       .gmii16b_error_out   (gmii_16b_tx_err)
 
    );
    
//RX
   wire         gmii_rx_dv_gmii_conv;
   wire [7:0]   gmii_rx_d_gmii_conv;
   wire         gmii_rx_err_gmii_conv;
   wire         mii_rx_en_mii_conv;
   wire [3:0]   mii_rx_d_mii_conv;
   wire         mii_rx_err_mii_conv; 
   
assign gmii_8b_rx_d    =  gmii_rx_d_gmii_conv ;
assign gmii_8b_rx_dv   =  gmii_rx_dv_gmii_conv ;
assign gmii_8b_rx_err  =  gmii_rx_err_gmii_conv  ;
 
//assign mii_rx_d    = (sgmii_speed_rx_mac_clk == 2'b10) ? 8'b0 : mii_rx_d_mii_conv;
//assign mii_rx_en   = (sgmii_speed_rx_mac_clk == 2'b10) ? 1'b0 : mii_rx_en_mii_conv;
//assign mii_rx_err  = (sgmii_speed_rx_mac_clk == 2'b10) ? 1'b0 : mii_rx_err_mii_conv;
 
    alt_tse16_16_to_8_gmii_conversion rx_gmii_conversion
    (
       // Slow clock and reset (62.5 MHz)
       .clk_gmii_in          (rx_mac_clk),
       .reset_gmii_in_n      (~rx_reset_rx_mac_clk),
       
       // Fast clock and reset (125 MHz)
       .clk_gmii_out         (rx_mac_clk_125),
       .reset_gmii_out_n     (~rx_reset_rx_mac_clk_125),
       
        //clock enable
        .rx_16b_clkena       (rx_16b_clkena_half),
        .rx_clkena           (rx_clkena_half), 
        
       // GMII data and control in slow clock domain
       .gmii16b_data_in      (gmii_16b_rx_d),
       .gmii16b_control_in   (gmii_16b_rx_dv),
       .gmii16b_error_in     (gmii_16b_rx_err),
       
       // GMII data and control in fast clock domain
       .gmii_data_out        (gmii_rx_d_gmii_conv),
       .gmii_control_out     (gmii_rx_dv_gmii_conv),
       .gmii_error_out       (gmii_rx_err_gmii_conv)
 
    );
 
// for 10M/100M, needs gmii to mii conversion before output to MAC
 
//alt_tse16_pcs_mii_tx_if_pcs rx_gmii8_mii4_if(
//    .reset      (rx_reset_rx_mac_clk_125),                      //INPUT :  Reset
//    .tx_clk     (rx_mac_clk_125),                       //INPUT :  MII Clock
//    .tx_clkena  (rx_clkena),                   //INPUT :  Clock Enable
//    .clk_ena    (rx_clkena_half),
//    .enan       (1'b1),                         //INPUT :  Enable
//    .mii_txd    (mii_rx_d_mii_conv),               //OUTPUT:  MII transmit data
//    .mii_txdv   (mii_rx_en_mii_conv),           //OUTPUT:  MII transmit frame enable  
//    .mii_txerr  (mii_rx_err_mii_conv),            //OUTPUT:  MII transmit frame error
//    .mii_txd_i  (gmii_rx_d_gmii_conv),            //INPUT :  MII transmit data
//    .mii_txdv_i (gmii_rx_dv_gmii_conv),        //INPUT :  MII transmit frame enable  
//    .mii_txerr_i(gmii_rx_err_gmii_conv)          //INPUT :  MII transmit frame error
//);
// 
reg tx_reset_tx_mac_clk_reg;
reg rx_reset_rx_mac_clk_reg;
// reg 1 stage for clock enable counters to align between CLK_ENA and CLK_16B_ENA
always @ (posedge tx_mac_clk_125)
begin
    tx_reset_tx_mac_clk_reg <= tx_reset_tx_mac_clk;
 
end
 
always @ (posedge rx_mac_clk_125)
begin
    rx_reset_rx_mac_clk_reg <= rx_reset_rx_mac_clk;
 
end
//create clkena for fast clock, 
////////////////////////////////125CLKENA////////////////
alt_tse16_pcs_sgmii_clk_enable U_TXCLK_8B_ENA (
    .reset_clk      (tx_reset_tx_mac_clk_reg),
    .clk            (tx_mac_clk_125),
    .ethernet_mode  (sgmii_speed_tx_mac_clk_125),
	.clk_ena_half   (tx_clkena_half), // to 8-16bit conversion
    .clk_ena_2xhalf (),  //20,200
    .clk_ena        (tx_clkena));  // /5, 10 for 125Mhz 
 
alt_tse16_pcs_sgmii_clk_enable U_RXCLK_8B_ENA (
    .reset_clk      (rx_reset_rx_mac_clk_reg),
    .clk            (rx_mac_clk_125),
    .ethernet_mode  (sgmii_speed_rx_mac_clk_125),
	.clk_ena_half   (rx_clkena_half),  //to 16-8bit conversion
    .clk_ena_2xhalf (),  //20,200
    .clk_ena        (rx_clkena));
 
////////////////////////////////62.5CLKENA///////////////////////
alt_tse16_pcs_sgmii_clk_enable U_TXCLK_16B_ENA (
    .reset_clk      (tx_reset_tx_mac_clk),
    .clk            (tx_mac_clk),
    .ethernet_mode  (sgmii_speed_tx_mac_clk),
	.clk_ena_half   (tx_16b_clkena_half), // to 8-16bit conversion
    .clk_ena_2xhalf (),  //20,200
    .clk_ena        (tx_16b_clkena));  //to pcs 1000baseX 
 
alt_tse16_pcs_sgmii_clk_enable U_RXCLK_16B_ENA (
    .reset_clk      (rx_reset_rx_mac_clk),
    .clk            (rx_mac_clk),
    .ethernet_mode  (sgmii_speed_rx_mac_clk),
	.clk_ena_half   (rx_16b_clkena_half), // to 16-8bit conversion
    .clk_ena_2xhalf (),  //20,200
    .clk_ena        (rx_16b_clkena)); // to pcs 1000baseX
 
///////////END
 
 
 
endmodule
