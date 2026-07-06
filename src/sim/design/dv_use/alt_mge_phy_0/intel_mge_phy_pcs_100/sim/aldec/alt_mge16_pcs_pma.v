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


`timescale 1ns/1ns
module alt_mge16_pcs_pma #(
    parameter DEVICE_FAMILY     ="Arria V",
    parameter PHY_IDENTIFIER    = 32'h00000000,
    parameter DEV_VERSION       = 16'h0F00,
    parameter ENABLE_IEEE1588   = 0,
    parameter ENABLE_SGMII   = 0,
    parameter SYNCHRONIZER_DEPTH= 3
) (
    // Clock
    input  	       csr_clk,
	
	input          tx_mac_clk,
	input          tx_phy_clk,
    
	input          rx_mac_clk,
	input          rx_phy_clk,
   input   rx_mac_clk_125 ,
   input   tx_mac_clk_125 ,

    // Reset
    input  	       csr_reset_csr_clk,
    input  	       tx_reset_tx_mac_clk,
	input  	       tx_reset_tx_phy_clk,
	input  	       rx_reset_rx_mac_clk,
	input  	       rx_reset_rx_phy_clk,
    input   tx_reset_tx_mac_clk_125,
  input   rx_reset_rx_mac_clk_125,
 
    // CSR
	input  [4:0]   address,
	input  	       read,
	input  	       write,
	input  [15:0]  writedata,
	output [15:0]  readdata,
	output 	       waitrequest,
	
    // GMII 16-bit
    input  [15:0]  gmii_tx_d,
	input  [1:0]   gmii_tx_en,
	input  [1:0]   gmii_tx_err,
    
    output [15:0]  gmii_rx_d,
	output [1:0]   gmii_rx_dv,
	output [1:0]   gmii_rx_err,
    
    // PHY Status
    output 	       led_an,
	output         led_disp_err,
	output         led_char_err,
	output         led_link,
	output         led_panel_link,
	output         rx_clkena_half,
	output         tx_clkena_half,
    output  [1:0]  sgmii_speed,      //  SGMII Speed
	 output  [1:0] sgmii_speed_tx_mac_clk_o,
  output  [1:0] sgmii_speed_rx_mac_clk_o,
  output  [1:0] sgmii_speed_tx_mac_clk_125_o,
  output  [1:0] sgmii_speed_rx_mac_clk_125_o,
    // XCVR Data Path
//    output [15:0]  tx_parallel_data,
//	output [1:0]   tx_datak,
//    input  [15:0]  rx_parallel_data,
//	input  [1:0]   rx_datak,
    input  [19:0]  rx_parallel_data,
output [19:0]  tx_parallel_data,
    
    // XCVR Status
	input  [1:0]   rx_syncstatus,
    input  [1:0]   rx_runningdisp,
	input  [1:0]   rx_disperr,
	input  [1:0]   rx_errdetect,
	input  [1:0]   rx_patterndetect,
	input  [4:0]   rx_std_bitslipboundarysel,
	
    // Settings to XCVR
    output         rx_seriallpbken,
    
    // 1588
    input          latency_measure_clk,
    output [21:0]  gmii16b_rx_latency,
    output [21:0]  gmii16b_tx_latency,
	//8bit tsn signals
	output           mii_crs ,
	output           mii_col ,
	input          latency_sclk,
	input          latency_sclk_reset_tx,
	input          latency_sclk_reset_rx,
	input  [11:0]  latency_xcvr_rx,
	input  [6:0]  adapter_status,
	output         tx_disable,
	input  [11:0]  latency_xcvr_tx
);
	
    wire     led_disp_err_int;
	wire      led_char_err_int;
	wire  [1:0]    led_link_int;
    
    // Only provide 1-bit status
//    assign led_disp_err = |led_disp_err_int;
//	assign led_char_err = |led_char_err_int;
	assign led_link = |led_link_int;
      assign led_disp_err = led_disp_err_int;
	assign led_char_err = led_char_err_int; 
    alt_mge16_pcs_pma_gige	alt_mge16_pcs_pma_gige_inst(
		// Clock
        .csr_clk(csr_clk),
		.tx_mac_clk(tx_mac_clk),
		.rx_mac_clk(rx_mac_clk),
        .tx_phy_clk(tx_phy_clk),
		.rx_phy_clk(rx_phy_clk),
		.rx_mac_clk_125 (rx_mac_clk_125),
       .tx_mac_clk_125 (tx_mac_clk_125),

        // Reset
        .csr_reset_csr_clk(csr_reset_csr_clk),
        .tx_reset_tx_mac_clk(tx_reset_tx_mac_clk),
        .tx_reset_tx_phy_clk(tx_reset_tx_phy_clk),
        .rx_reset_rx_mac_clk(rx_reset_rx_mac_clk),
        .rx_reset_rx_phy_clk(rx_reset_rx_phy_clk),
		  .tx_reset_tx_mac_clk_125 (tx_reset_tx_mac_clk_125),
        .rx_reset_rx_mac_clk_125 (rx_reset_rx_mac_clk_125),

		
        // CSR
        .address(address),
		.read(read),
		.write(write),
		.writedata(writedata),
    	.readdata(readdata),
		.waitrequest(waitrequest),
		.tx_parallel_data (tx_parallel_data),
		.rx_datain (rx_parallel_data),
        .hd_ena(),
		.led_an(led_an),
		.led_disp_err(led_disp_err_int),
		.led_char_err(led_char_err_int),
		.led_col(),
		.led_crs(),
		.led_link(led_link_int),
		.led_panel_link(led_panel_link),   
		.rx_clkena_half(rx_clkena_half),  
		.tx_clkena_half(tx_clkena_half),         
        .mii_col(mii_col),
        .mii_crs(mii_crs),
        .mii_rx_d(),
        .mii_rx_dv(),
        .mii_rx_err(),
		.gmii_tx_d(gmii_tx_d),
		.gmii_tx_en(gmii_tx_en),
		.gmii_tx_err(gmii_tx_err),
        .gmii_rx_d(gmii_rx_d),
		.gmii_rx_dv(gmii_rx_dv),
		.gmii_rx_err(gmii_rx_err),
		.mii_tx_d(4'h0),
		.mii_tx_en(1'b0),
		.mii_tx_err(1'b0),
		.rx_runningdisp(rx_runningdisp),
    	.rx_disp_err(rx_disperr),
    	.rx_char_err_gx(rx_errdetect),
    	.rx_patterndetect(rx_patterndetect),
    	.rx_syncstatus(rx_syncstatus),
    	.rx_runlengthviolation(1'b0),
    	//.rx_frame(rx_parallel_data),
    //	.rx_kchar(rx_datak),
    	//.rx_std_bitslipboundarysel(rx_std_bitslipboundarysel),
    	//.tx_frame(tx_parallel_data),
    //	.tx_kchar(tx_datak),		
		.sd_loopback(rx_seriallpbken),
        .latency_measure_clk(latency_measure_clk),
        .gmii16b_rx_latency(gmii16b_rx_latency),
        .gmii16b_tx_latency(gmii16b_tx_latency),
        .set_10(),
        .set_100(),
        .set_1000(),
        .sgmii_speed (sgmii_speed),      //  SGMII Speed
		  .sgmii_speed_tx_mac_clk_125_o (sgmii_speed_tx_mac_clk_125_o), 
		  .sgmii_speed_rx_mac_clk_125_o (sgmii_speed_rx_mac_clk_125_o), 
        .sgmii_speed_rx_mac_clk_o (sgmii_speed_rx_mac_clk_o), 
        .sgmii_speed_tx_mac_clk_o (sgmii_speed_tx_mac_clk_o),

		.latency_sclk(latency_sclk),
		.latency_sclk_reset_tx(latency_sclk_reset_tx),
		.latency_sclk_reset_rx(latency_sclk_reset_rx),
		.latency_xcvr_tx(latency_xcvr_tx),
		.tx_disable(tx_disable),
       .adapter_status (adapter_status),		
		.latency_xcvr_rx(latency_xcvr_rx)
		);

	defparam
		alt_mge16_pcs_pma_gige_inst.PHY_IDENTIFIER = PHY_IDENTIFIER,
		alt_mge16_pcs_pma_gige_inst.DEV_VERSION = DEV_VERSION,
		alt_mge16_pcs_pma_gige_inst.ENABLE_SGMII = ENABLE_SGMII,
		alt_mge16_pcs_pma_gige_inst.SYNCHRONIZER_DEPTH = SYNCHRONIZER_DEPTH,
		alt_mge16_pcs_pma_gige_inst.ENABLE_IEEE1588 = ENABLE_IEEE1588,
		alt_mge16_pcs_pma_gige_inst.DEVICE_FAMILY = DEVICE_FAMILY;

endmodule
