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


`timescale 1 ps / 1 ps

module alt_mge_phy_xgmii_pcs #(
  parameter PMA_MODE         = 32,
  parameter TSWIDTH          = 16,
  parameter RX_DWIDTH        = 64,
  parameter RX_CWIDTH        = 8,
  parameter TX_DWIDTH        = 64,
  parameter TX_CWIDTH        = 8,
  parameter DEVICE_FAMILY    = "Arria V",
  parameter ENABLE_IEEE1588  = 0
  )(
    input wire                   rx_xgmii_clk,
    input wire                   tx_xgmii_clk,
    input wire                   rx_pma_clk,
    input wire                   tx_pma_clk,
    input wire                   rx_xgmii_rst_n,
    input wire                   rx_pma_rst_n,
    input wire                   tx_xgmii_rst_n,
    input wire                   tx_pma_rst_n,
	input wire                   tx_reset_latency_sclk,
	input wire                   rx_reset_latency_sclk,
    input wire  [RX_DWIDTH-1:0]  rx_data_in,
    input wire  [RX_CWIDTH-1:0]  rx_control_in,
    input wire  [          1:0]  rx_control_fec_in,
    input wire                   rx_data_valid_in,
    input wire  [TX_DWIDTH-1:0]  tx_data_in,
    input wire  [TX_CWIDTH-1:0]  tx_control_in,
    //input wire                   tx_data_valid_in,
    output wire [RX_DWIDTH-1:0]  rx_data_out,
    output wire [RX_CWIDTH-1:0]  rx_control_out,
    //output wire                  rx_data_valid_out,
    output wire [TX_DWIDTH-1:0]  tx_data_out,
    output wire [TX_CWIDTH-1:0]  tx_control_out,
    output wire                  tx_data_valid_out,
    //output wire                  rxfifofull,
    //output wire                  txfifofull,
    output wire [TSWIDTH-1:0]    rx_latency_adj,
    output wire [TSWIDTH-1:0]    tx_latency_adj,
	input   wire                 latency_sclk,
	input   wire [11:0]          latency_xcvr_tx,
	input   wire [11:0]          latency_xcvr_rx
);
    
    // xgmii_clk_cycle = latency(in ps)/6400
    //
    // soft-FIFO's latency = {6-bit cycle, 6-bit fractional cycle}
    // Cycle in decimal = fractional_cycle / 64
    //   e.g. Latency = 12'h2C6 = 12'b001011_000110 = {11,6}
    //          cycle = 11
    //        decimal = 6/64 = 0.09375
    //        Hence, latency in xgmii_clk_cycle = 11.09375
    //
    // OFFSET (PCS latency) = {6-bit cycle, 10-bit fractional cycle}
    // Fractional cycle = decimal x 1024
    //   e.g. Latency = 12.28199219 cycles
    //          cycle = 12
    //        fractional cycle = 0.28199219 * 1024 = 289
    
    //*********************************************************************************
    // 1588's RX PCS Latency (excluding 1588's soft-FIFO) in unit of xgmii clock cycle
    //*********************************************************************************
    // 32-bit PMA:
    // 1588's soft-FIFO (in) to PMA serial (out)        = 132599   ps
    // - PMA constant latency (measure at serial bit-0) =   5583.5 ps
    // PCS latency (inc. soft-FIFO)                     = 127015.5 ps (xgmii_clk_cycle: 19.84617188)
    // - soft-FIFO's latency in cycles (latency_quo)    = 12'h29F     (xgmii_clk_cycle: 10.484375)
    //------------------------------------------------------------------
    // PCS latency in cycles (exc. soft-FIFO)           = 9.36179688
    //------------------------------------------------------------------
    // 40-bit PMA:
    // 1588's soft-FIFO (in) to PMA serial (out)        = 142035.25 ps
    // - PMA constant latency (measure at serial bit-0) =   6349.00 ps
    // PCS latency (inc. soft-FIFO)                     = 135686.25 ps (xgmii_clk_cycle: 21.20097656)
    // - soft-FIFO's latency in cycles (latency_quo)    = 12'h2C6      (xgmii_clk_cycle: 11.09375)
    //------------------------------------------------------------------
    // PCS latency in cycles (exc. soft-FIFO)           = 10.10722656
    //------------------------------------------------------------------
	// Stratix 10
    // 40-bit PMA:
    // 1588's soft-FIFO (in) to PMA serial (out)        =  176820.00 ps
    // - PMA constant latency (measure at serial bit-0) =   6015.00 ps
    // PCS latency (inc. soft-FIFO)                     = 170805.00 ps (xgmii_clk_cycle: 26.688281)
    // - soft-FIFO's latency in cycles (latency_quo)    = 12'h345      (xgmii_clk_cycle: 13.078125)
    // - AIB FIFO latency in cycle                      = 16'h1a36  (xgmii_clk_cycle: 2.9734847)
    //------------------------------------------------------------------
    // PCS latency in cycles (exc. soft-FIFO)           = 10.6366713
    //------------------------------------------------------------------
	
    localparam RX_OFFSET = (DEVICE_FAMILY == "Arria 10")? ((PMA_MODE == 32) ? {6'd9,10'd370}     // 9.36179688 cycles
                                                                             : {6'd10,10'd110})
									                                         : {6'd10,10'd651};
																			 
    //*********************************************************************************
    // 1588's TX PCS Latency (excluding 1588's soft-FIFO) in unit of xgmii clock cycle
    //*********************************************************************************
    // 32-bit PMA:
    // 1588's soft-FIFO (in) to PMA serial (out)        = 104275 ps
    // - PMA constant latency (measure at serial bit-0) =   9272 ps
    // PCS latency (inc. soft-FIFO)                     =  95003 ps (xgmii_clk_cycle: 14.84421875)
    // - soft-FIFO's latency in cycles (latency_quo)    = 12'h101   (xgmii_clk_cycle: 4.015625)
    //------------------------------------------------------------------
    // PCS latency in cycles (exc. soft-FIFO)           = 12.28199219
    //------------------------------------------------------------------
    // 40-bit PMA:
    // 1588's soft-FIFO (in) to PMA serial (out)        = 120448.75 ps
    // - PMA constant latency (measure at serial bit-0) =  10844.00 ps
    // PCS latency (inc. soft-FIFO)                     = 109604.75 ps (xgmii_clk_cycle: 17.12574219)
    // - soft-FIFO's latency in cycles (latency_quo)    = 12'h136      (xgmii_clk_cycle: 4.84375)
    //------------------------------------------------------------------
    // PCS latency in cycles (exc. soft-FIFO)           = 12.28199219
    //------------------------------------------------------------------
	
	//*********************************************************************************
	// Stratix 10 TX PCS (excluding 1588's soft-FIFO and async FIFO) in unit of xgmii clock cycle
	//*********************************************************************************
	// 40-bit PMA:
	// 1588's soft-FIFO (in) to PMA serial (out)        = 129214 ps
	// - PMA constant latency (measure at serial bit-0) =   4063 ps  
	// PCS latency (inc. soft-FIFO)                     = 125151 ps (xgmii_clk_cycle: 19.5548438)
	// - soft-FIFO's latency in cycles (latency_quo)    = 12'h136   (xgmii_clk_cycle: 4.84375)
	// - AIB FIFO latency in cycle                      = 16'h1a36  (xgmii_clk_cycle: 2.9734847)
	 //------------------------------------------------------------------
    // PCS latency in cycles (exc. soft-FIFO & aib fifo)  = 11.7376091
    //------------------------------------------------------------------
	
    localparam TX_OFFSET = (DEVICE_FAMILY == "Arria 10")? ((PMA_MODE == 32) ? {6'd10,10'd848}    // 10.82859375 cycles
                                                           : {6'd12,10'd289})   // 12.28199219 cycles
                                                           : {6'd11,10'd755}; 	  // 12.018123  cycles												   
    
    
    wire unused_tx_control_out;
    wire [1:0] unused_rx_control_out;
    
    alt_mge_phy_xgmii_soft_fifo #(
        .FAWIDTH   (5),
        .TSWIDTH   (TSWIDTH),
        .IDWIDTH   (PMA_MODE),
        .RX_DWIDTH (RX_DWIDTH),
        .RX_CWIDTH (RX_CWIDTH+2),
        .TX_DWIDTH (TX_DWIDTH),
        .TX_CWIDTH (TX_CWIDTH+1),
        .RX_OFFSET (RX_OFFSET),
        .TX_OFFSET (TX_OFFSET),
		.DEVICE_FAMILY (DEVICE_FAMILY),
		.ENABLE_IEEE1588 (ENABLE_IEEE1588)
    ) soft_fifo (
        .rx_xgmii_clk       (rx_xgmii_clk),
        .tx_xgmii_clk       (tx_xgmii_clk),
        .rx_pma_clk         (rx_pma_clk),
        .tx_pma_clk         (tx_pma_clk),
        .rx_xgmii_rst_n     (rx_xgmii_rst_n),
        .rx_pma_rst_n       (rx_pma_rst_n),
        .tx_xgmii_rst_n     (tx_xgmii_rst_n),
        .tx_pma_rst_n       (tx_pma_rst_n),
		.rx_reset_latency_sclk  (rx_reset_latency_sclk),
		.tx_reset_latency_sclk  (tx_reset_latency_sclk),
        .rx_data_in         (rx_data_in),
        .rx_control_in      ({rx_control_fec_in, rx_control_in}),
        .rx_data_valid_in   (rx_data_valid_in),
        .tx_data_in         (tx_data_in),
        .tx_control_in      ({1'b0, tx_control_in}),
        .tx_data_valid_in   (1'b1),
        .rx_data_out        (rx_data_out),
        .rx_control_out     ({unused_rx_control_out, rx_control_out}),
        //.rx_data_valid_out  (),
        .tx_data_out        (tx_data_out),
        .tx_control_out     ({unused_tx_control_out, tx_control_out}),
        .tx_data_valid_out  (tx_data_valid_out),
        .rxfifofull         (),
        .txfifofull         (),
        .rx_latency_adj     (rx_latency_adj),
        .tx_latency_adj     (tx_latency_adj),
		.latency_sclk        (latency_sclk),
	    .latency_xcvr_tx     (latency_xcvr_tx),
		.latency_xcvr_rx     (latency_xcvr_rx)
    );

endmodule
