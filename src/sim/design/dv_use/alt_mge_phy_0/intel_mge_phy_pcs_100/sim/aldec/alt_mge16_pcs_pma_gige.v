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
// Top level PCS + PMA module for Triple Speed Ethernet PCS + PMA
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
(*altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF;SUPPRESS_DA_RULE_INTERNAL=\"R102,R105,D102,D101,D103\"" } *)
module alt_mge16_pcs_pma_gige /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"R102,R105,D102,D101,D103\"" */(
    // inputs:
    address,
    csr_clk,
    gmii_tx_d,
    gmii_tx_en,
    gmii_tx_err,
    mii_tx_d,
    mii_tx_en,
    mii_tx_err,
    read,
    csr_reset_csr_clk,
    tx_reset_tx_mac_clk,
    tx_reset_tx_phy_clk,
    rx_reset_rx_mac_clk,
    rx_reset_rx_phy_clk,
	 tx_reset_tx_mac_clk_125,
	tx_mac_clk_125,
	rx_reset_rx_mac_clk_125,
	rx_mac_clk_125,
    write,
    writedata,
    rx_runningdisp,
    rx_disp_err,
    rx_char_err_gx,
    rx_patterndetect,
    rx_syncstatus,
    rx_runlengthviolation,
   // rx_frame,
    //rx_kchar,
  //  rx_std_bitslipboundarysel,
    rx_datain,
    // outputs:
    //tx_frame,
    //tx_kchar,
	tx_parallel_data,
    gmii_rx_d,
    gmii_rx_dv,
    gmii_rx_err,
    hd_ena,
    led_an,
    led_panel_link, 
    led_char_err,
    led_col,
    led_crs,
    led_disp_err,
    led_link,
    mii_col,
    mii_crs,
    mii_rx_d,
    mii_rx_dv,
    mii_rx_err,
    readdata,
    tx_mac_clk,
    rx_mac_clk,
    tx_phy_clk,
    rx_phy_clk,
    set_10,
    set_100,
    set_1000,
    sgmii_speed,
	 sgmii_speed_tx_mac_clk_o,
   sgmii_speed_rx_mac_clk_o,
   sgmii_speed_tx_mac_clk_125_o,
   sgmii_speed_rx_mac_clk_125_o,
    rx_clkena_half,    
    tx_clkena_half,    
    waitrequest,
    sd_loopback,
    latency_measure_clk,
    gmii16b_rx_latency,
    gmii16b_tx_latency,
	latency_sclk,
	latency_sclk_reset_tx,
	latency_sclk_reset_rx,
	latency_xcvr_tx,
	tx_disable,
	adapter_status,
	latency_xcvr_rx
);


//  Parameters to configure the core for different variations
//  ---------------------------------------------------------

parameter PHY_IDENTIFIER        = 32'h 00000000; //  PHY Identifier 
parameter DEV_VERSION           = 16'h 0001 ;    //  Customer Phy's Core Version
parameter ENABLE_SGMII          = 0;             //  Enable SGMII logic for synthesis
parameter SYNCHRONIZER_DEPTH 	= 3;	  	 //  Number of synchronizer
parameter ENABLE_IEEE1588       = 0;             //  Enable latency measurement of data path for 1588
parameter DEVICE_FAMILY         = "Arria 10";    //  Device family name

localparam PATH_DELAY_WIDTH     = 22;            //  TX and RX phy delay width
output  [19:0] tx_parallel_data;
  output  [15:0] gmii_rx_d;
  output  [1:0] gmii_rx_dv;
  output  [1:0] gmii_rx_err;
  output  hd_ena;
  output  led_an;
  output   led_char_err;
  output  led_col;
  output  led_crs;
  output   led_disp_err;
  output   led_link;
  output  mii_col;
  output  mii_crs;
  output  [3:0] mii_rx_d;
  output  mii_rx_dv;
  output  mii_rx_err;
  output  [15:0] readdata;
  output  set_10;
  output  set_100;
  output  set_1000;
  output  rx_clkena_half;
  output  tx_clkena_half;
  output  [1:0] sgmii_speed;      //  SGMII Speed
  output  [1:0] sgmii_speed_tx_mac_clk_o;
  output  [1:0] sgmii_speed_rx_mac_clk_o;
  output  [1:0] sgmii_speed_tx_mac_clk_125_o;
  output  [1:0] sgmii_speed_rx_mac_clk_125_o;
  output  led_panel_link;         //  Valid Copper and Fiber Link Status  
  output  waitrequest;
  //output  [15:0] tx_frame;
  //output  [1:0] tx_kchar;
   input   [19:0] rx_datain;
  input   tx_mac_clk;
  input   rx_mac_clk;
  input   tx_phy_clk;
  input   rx_phy_clk;
  input   tx_reset_tx_mac_clk_125;
  input   tx_mac_clk_125;
  input   rx_reset_rx_mac_clk_125;
  input   rx_mac_clk_125;
  input   [4:0] address;
  input   csr_clk;
  input   [15:0] gmii_tx_d;
  input   [1:0] gmii_tx_en;
  input   [1:0] gmii_tx_err;
  input   [3:0] mii_tx_d;
  input   mii_tx_en;
  input   mii_tx_err;
  input   read;
  input   csr_reset_csr_clk;
  input   tx_reset_tx_mac_clk;
  input   tx_reset_tx_phy_clk;
  input   rx_reset_rx_mac_clk;
  input   rx_reset_rx_phy_clk;
  input   write;
  input   [15:0] writedata;
  input  [1:0] rx_runningdisp;
  input  [1:0] rx_disp_err;
  input  [1:0] rx_char_err_gx;
  input  [1:0] rx_patterndetect;
  input  [1:0] rx_syncstatus;
  input  rx_runlengthviolation;
  //input  [15:0] rx_frame;
  //input  [1:0] rx_kchar;
 //input  [4:0] rx_std_bitslipboundarysel;
  output       sd_loopback;
  
  input  latency_measure_clk;
  output [PATH_DELAY_WIDTH-1:0] gmii16b_rx_latency;
  output [PATH_DELAY_WIDTH-1:0] gmii16b_tx_latency;
  
  input  latency_sclk;
  input  latency_sclk_reset_tx;
  input  latency_sclk_reset_rx;
  input  [11:0]  latency_xcvr_rx;
  input  [11:0]  latency_xcvr_tx;
  output tx_disable ;
  input  [6:0]  adapter_status;


  wire    [15:0] gmii_rx_d;
  wire    [1:0] gmii_rx_dv;
  wire    [1:0] gmii_rx_err;
  wire    hd_ena;
  wire    led_an;
  wire     led_char_err;
  wire    [1:0] led_char_err_gx;
  wire    led_col;
  wire    led_crs;
  wire     led_disp_err;
  //wire    [1:0] led_link;
  wire    [1:0] link_status;
  wire    [1:0] soft_led_link;
  wire    mii_col;
  wire    mii_crs;
  wire    [3:0] mii_rx_d;
  wire    mii_rx_dv;
  wire    mii_rx_err;
  wire    [15:0] pcs_rx_frame;
  wire    [1:0] pcs_rx_kchar;
 wire    [1:0] disp_err;
  wire    [1:0] char_err;

  wire    [15:0] readdata;
  wire    set_10;
  wire    set_100;
  wire    set_1000;
  wire    [15:0] tx_frame;
  wire    [1:0] tx_kchar;
  wire    [15:0] rx_frame;
  wire    [1:0]  rx_kchar;
  wire    waitrequest;
  wire    gxb_pwrdn_in_sig;
  wire  [4:0] rx_bitslipboundary_sel;
  wire [1:0] rx_carrierdetected;
 wire  [1:0]  rx_sync ;
 wire [19:0]  tx_parallel_data_s;
//  Assign the character error and link status to top level leds
//  ------------------------------------------------------------
//assign led_char_err = led_char_err_gx;
assign led_link =  | soft_led_link;
assign led_char_err = | char_err;
assign led_disp_err = | disp_err;
assign  tx_parallel_data = tx_parallel_data_s;
// Instantiation of the PCS core that connects to a PMA
// --------------------------------------------------------
  alt_mge16_pcs_top_1000_base_x_strx_gx alt_mge16_pcs_top_1000_base_x_strx_gx_inst
    (
        .rx_carrierdetected(rx_carrierdetected),
        .gmii_rx_d(gmii_rx_d),
		.gmii_rx_dv(gmii_rx_dv),
		.gmii_rx_err(gmii_rx_err),
        .gmii_tx_d(gmii_tx_d),
		.gmii_tx_en(gmii_tx_en),
		.gmii_tx_err(gmii_tx_err),
        .hd_ena (hd_ena),
        .led_an (led_an),   
        .led_panel_link (led_panel_link),
        .led_char_err (char_err | disp_err),   //check RD error for sync,
        .led_col (led_col),
        .led_crs (led_crs),
        .led_link ({rx_sync[0],rx_sync[1]}),
        .soft_led_link (soft_led_link),
        .mii_col (mii_col),
        .mii_crs (mii_crs),
        .mii_rx_d (mii_rx_d),
        .mii_rx_dv (mii_rx_dv),
        .mii_rx_err (mii_rx_err),
        .mii_tx_d (mii_tx_d),
        .mii_tx_en (mii_tx_en),
        .mii_tx_err (mii_tx_err),
        .powerdown (),
        .reg_addr (address),
        .reg_busy (waitrequest),
        .reg_clk (csr_clk),
        .reg_data_in (writedata),
        .reg_data_out (readdata),
        .reg_rd (read),
        .reg_wr (write),
        .csr_reset_csr_clk (csr_reset_csr_clk),
        .tx_reset_tx_mac_clk (tx_reset_tx_mac_clk),
		  .tx_reset_tx_mac_clk_125 (tx_reset_tx_mac_clk_125),

        .tx_reset_tx_phy_clk (tx_reset_tx_phy_clk),
        .rx_reset_rx_mac_clk (rx_reset_rx_mac_clk),
		   .rx_reset_rx_mac_clk_125 (rx_reset_rx_mac_clk_125),

        .rx_reset_rx_phy_clk (rx_reset_rx_phy_clk),
        .rx_mac_clk (rx_mac_clk),
		   .rx_mac_clk_125 (rx_mac_clk_125),

        .rx_phy_clk (rx_phy_clk),
        .rx_frame (rx_frame),
        .rx_kchar (rx_kchar),
        .sd_loopback (sd_loopback),
        .set_10 (set_10),
        .set_100 (set_100),
        .set_1000 (set_1000),
        .sgmii_speed (sgmii_speed),      //  SGMII Speed
		  .sgmii_speed_tx_mac_clk_125_o (sgmii_speed_tx_mac_clk_125_o), 
		  .sgmii_speed_rx_mac_clk_125_o (sgmii_speed_rx_mac_clk_125_o), 
        .sgmii_speed_rx_mac_clk_o (sgmii_speed_rx_mac_clk_o), 
        .sgmii_speed_tx_mac_clk_o (sgmii_speed_tx_mac_clk_o),

        .rx_clkena_half(rx_clkena_half),
        .tx_clkena_half(tx_clkena_half),        
        .tx_mac_clk (tx_mac_clk),
		   .tx_mac_clk_125 (tx_mac_clk_125),

        .tx_phy_clk (tx_phy_clk),
        .tx_frame (tx_frame),
        .tx_kchar (tx_kchar),
        .calc_clk(latency_measure_clk),
        .rx_latency_adj(gmii16b_rx_latency),
        .tx_latency_adj(gmii16b_tx_latency),
        .wa_boundary(rx_bitslipboundary_sel),
        .tx_ptp_alignment(),
        .eccstatus_tx_converter(),
        .eccstatus_rx_converter(),
		.latency_sclk(latency_sclk),
		.latency_sclk_reset_tx(latency_sclk_reset_tx),
		.latency_sclk_reset_rx(latency_sclk_reset_rx),
		.latency_xcvr_rx(latency_xcvr_rx),
		.tx_disable(tx_disable),
		.adapter_status (adapter_status),

		.latency_xcvr_tx(latency_xcvr_tx)
    );    
    defparam
        alt_mge16_pcs_top_1000_base_x_strx_gx_inst.PHY_IDENTIFIER = PHY_IDENTIFIER,
        alt_mge16_pcs_top_1000_base_x_strx_gx_inst.DEV_VERSION = DEV_VERSION,
        alt_mge16_pcs_top_1000_base_x_strx_gx_inst.ENABLE_SGMII = ENABLE_SGMII,
        alt_mge16_pcs_top_1000_base_x_strx_gx_inst.SYNCHRONIZER_DEPTH = SYNCHRONIZER_DEPTH,
        alt_mge16_pcs_top_1000_base_x_strx_gx_inst.ENABLE_PHASE_CALC = ENABLE_IEEE1588,
        alt_mge16_pcs_top_1000_base_x_strx_gx_inst.DEVICE_FAMILY = DEVICE_FAMILY;
		  
		  
		  
		  
		  
		  
		  alt_mge_pcs20 #(
    .EDGE_MODE      (0) //set EDGE_MODE=0 and rx_enapatternalign=1 so that word aligner will always do alignment
) alt_mge_pcs20_inst (
	.rx_clk                 (rx_phy_clk),
	.rx_datain              (rx_datain),
	.rx_digitalreset        (rx_reset_rx_phy_clk),
	//.rx_enapatternalign     (1'b1), //set EDGE_MODE=0 and rx_enapatternalign=1 so that word aligner will always do alignment
	.tx_ctrlenable          (tx_kchar),
	.tx_datain              (tx_frame),
	.tx_digitalreset        (tx_reset_tx_phy_clk),
	.rx_ctrldetect          (rx_kchar),
	.rx_dataout             (rx_frame),
	.rx_patterndetect       (), // UNUSED
	.rx_bitslipboundary_sel (rx_bitslipboundary_sel), // Open for PTP calculation
	.rx_disperr             (disp_err),
	.rx_errdetect           (char_err),
   .carrier_detected        (rx_carrierdetected),
   .rx_sync                 (rx_sync),
	.tx_clk                 (tx_phy_clk),
	.tx_dataout             (tx_parallel_data_s)
);



    // Aligned Rx_sync from gxb
    // -------------------------------
//    alt_mge16_pcs_gxb_aligned_rxsync the_alt_mge16_pcs_gxb_aligned_rxsync
//      (
//        .clk(rx_phy_clk),
//        .reset(rx_reset_rx_phy_clk),
//        //input (from transceiver)
//        .alt_dataout(rx_frame),
//        .alt_sync(rx_syncstatus),
//        .alt_disperr(rx_disp_err),
//        .alt_ctrldetect(rx_kchar),
//        .alt_errdetect(rx_char_err_gx),
//        .alt_runlengthviolation(rx_runlengthviolation),
//        .alt_patterndetect(rx_patterndetect),
//        .alt_runningdisp(rx_runningdisp),
//
//        //output (to PCS)
//        .altpcs_dataout(pcs_rx_frame),
//        .altpcs_sync(link_status),
//        .altpcs_disperr(led_disp_err),
//        .altpcs_ctrldetect(pcs_rx_kchar),
//        .altpcs_errdetect(led_char_err_gx),
//        .altpcs_carrierdetect(pcs_rx_carrierdetected)
//
//       ) ;
//       //defparam
//           //the_alt_mge16_pcs_gxb_aligned_rxsync.DEVICE_FAMILY = DEVICE_FAMILY;		


endmodule

