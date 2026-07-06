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


// (C) 2001-2022 Intel Corporation. All rights reserved.
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

module alt_mge_phy_pcs_rst_sync #(
    parameter SYNCHRONIZER_DEPTH = 3
) (
    // Clock
    input  wire csr_clk,
    
    input  wire tx_xgmii_clk,
    input  wire tx_pma_clk,
    
    input  wire rx_xgmii_clk,
    input  wire rx_pma_clk,
    input  wire rx_rec_div33_clk,
    input  wire rx_fm_ff_sample_clk,
	  input  wire rx_mac_clk_125,
	  input  wire tx_mac_clk_125,
     input  wire rx_mac_clk,
	  input  wire tx_mac_clk,
	input  wire latency_sclk,
    
    // Async Reset Input
    input  wire reset,
    
    input  wire tx_digitalreset,
    input  wire rx_digitalreset,
    
    // Sync Reset Output
    output wire global_reset__csr_clk,
    output wire global_reset__tx_xgmii_clk,
    output wire global_reset__tx_pma_clk,
    output wire global_reset__rx_xgmii_clk,
    output wire global_reset__rx_pma_clk,
    output wire global_reset__rx_rec_div33_clk,
    output wire global_reset__latency_sclk,
     output wire global_reset__rx_mac_clk_125,
     output wire global_reset__tx_mac_clk_125,
  output wire global_reset__rx_mac_clk,
     output wire global_reset__tx_mac_clk,
	 
    output wire tx_reset__csr_clk,
    output wire tx_reset__tx_xgmii_clk,
    output wire tx_reset__tx_pma_clk,
    output wire tx_reset__latency_sclk,
    
    output wire rx_reset__csr_clk,
    output wire rx_reset__rx_xgmii_clk,
    output wire rx_reset__rx_pma_clk,
    output wire rx_reset__rx_rec_div33_clk,
    output wire rx_reset__tx_pma_clk,
    output wire rx_reset__latency_sclk,
    output wire rx_reset__rx_mac_clk_125,
    output wire tx_reset__tx_mac_clk_125,
    output wire rx_reset__rx_mac_clk,
    output wire tx_reset__tx_mac_clk,
	
    output wire gtx_reset__csr_clk,
    output wire gtx_reset__tx_xgmii_clk,
    output wire gtx_reset__tx_pma_clk,
    output wire gtx_reset__latency_sclk,
    output wire gtx_reset__tx_mac_clk_125,
    output wire gtx_reset__tx_mac_clk,

    output wire grx_reset__csr_clk,
    output wire grx_reset__rx_xgmii_clk,
    output wire grx_reset__rx_pma_clk,
    output wire grx_reset__rx_rec_div33_clk,
    output wire grx_reset__rx_fm_ff_sample_clk,
    output wire grx_reset__tx_pma_clk,
	 output wire grx_reset__rx_mac_clk_125,
	 output wire grx_reset__rx_mac_clk,

    output wire grx_reset__latency_sclk
);

// Global Reset
alt_mge16_pcs_reset_synchronizer rsync__global_reset__csr_clk (
    .clk        (csr_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__csr_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__global_reset__tx_xgmii_clk (
    .clk        (tx_xgmii_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__tx_xgmii_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__global_reset__tx_pma_clk (
    .clk        (tx_pma_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__tx_pma_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__global_reset__rx_xgmii_clk (
    .clk        (rx_xgmii_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__rx_xgmii_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__global_reset__rx_pma_clk (
    .clk        (rx_pma_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__rx_pma_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__global_reset__rx_mac_clk_125 (
    .clk        (rx_mac_clk_125),
    .reset_in   (reset),
    .reset_out  (global_reset__rx_mac_clk_125)
);
alt_mge16_pcs_reset_synchronizer rsync__global_reset__tx_mac_clk_125 (
    .clk        (tx_mac_clk_125),
    .reset_in   (reset),
    .reset_out  (global_reset__tx_mac_clk_125)
);
alt_mge16_pcs_reset_synchronizer rsync__global_reset__rx_mac_clk (
    .clk        (rx_mac_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__rx_mac_clk)
);
alt_mge16_pcs_reset_synchronizer rsync__global_reset__tx_mac_clk (
    .clk        (tx_mac_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__tx_mac_clk)	
	);
	
	
alt_mge16_pcs_reset_synchronizer rsync__global_reset__rx_rec_div33_clk (
    .clk        (rx_rec_div33_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__rx_rec_div33_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__global_reset__rx_fm_ff_sample_clk (
    .clk        (rx_fm_ff_sample_clk),
    .reset_in   (reset),
    .reset_out  (global_reset__rx_fm_ff_sample_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__global_reset__latency_sclk (
    .clk        (latency_sclk),
    .reset_in   (reset),
    .reset_out  (global_reset__latency_sclk)
);

// TX Reset
alt_mge16_pcs_reset_synchronizer rsync__tx_reset__csr_clk (
    .clk        (csr_clk),
    .reset_in   (tx_digitalreset),
    .reset_out  (tx_reset__csr_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__tx_reset__tx_xgmii_clk (
    .clk        (tx_xgmii_clk),
    .reset_in   (tx_digitalreset),
    .reset_out  (tx_reset__tx_xgmii_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__tx_reset__tx_pma_clk (
    .clk        (tx_pma_clk),
    .reset_in   (tx_digitalreset),
    .reset_out  (tx_reset__tx_pma_clk)
);
alt_mge16_pcs_reset_synchronizer rsync__tx_reset__tx_mac_clk_125 (
    .clk        (tx_mac_clk_125),
    .reset_in   (tx_digitalreset),
    .reset_out  (tx_reset__tx_mac_clk_125)
);

alt_mge16_pcs_reset_synchronizer rsync__tx_reset__tx_mac_clk (
    .clk        (tx_mac_clk),
    .reset_in   (tx_digitalreset),
    .reset_out  (tx_reset__tx_mac_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__tx_reset__latency_sclk (
    .clk        (latency_sclk),
    .reset_in   (tx_digitalreset),
    .reset_out  (tx_reset__latency_sclk)
);

// RX Reset
alt_mge16_pcs_reset_synchronizer rsync__rx_reset__csr_clk (
    .clk        (csr_clk),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__csr_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__rx_reset__rx_xgmii_clk (
    .clk        (rx_xgmii_clk),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__rx_xgmii_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__rx_reset__rx_pma_clk (
    .clk        (rx_pma_clk),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__rx_pma_clk)
);
alt_mge16_pcs_reset_synchronizer rsync__rx_reset__rx_mac_clk_125 (
    .clk        (rx_mac_clk_125),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__rx_mac_clk_125)
);	
	
alt_mge16_pcs_reset_synchronizer rsync__rx_reset__rx_mac_clk (
    .clk        (rx_mac_clk),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__rx_mac_clk)
);
alt_mge16_pcs_reset_synchronizer rsync__rx_reset__rx_rec_div33_clk (
    .clk        (rx_rec_div33_clk),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__rx_rec_div33_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__rx_reset__rx_fm_ff_sample_clk (
    .clk        (rx_fm_ff_sample_clk),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__rx_fm_ff_sample_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__rx_reset__tx_pma_clk (
    .clk        (tx_pma_clk),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__tx_pma_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__rx_reset__latency_sclk (
    .clk        (latency_sclk),
    .reset_in   (rx_digitalreset),
    .reset_out  (rx_reset__latency_sclk)
);

// Global + TX Reset
alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__csr_clk (
    .clk        (csr_clk),
    .reset_in   (tx_reset__csr_clk | global_reset__csr_clk),
    .reset_out  (gtx_reset__csr_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__tx_xgmii_clk (
    .clk        (tx_xgmii_clk),
    .reset_in   (tx_reset__tx_xgmii_clk | global_reset__tx_xgmii_clk),
    .reset_out  (gtx_reset__tx_xgmii_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__tx_pma_clk (
    .clk        (tx_pma_clk),
    .reset_in   (tx_reset__tx_pma_clk | global_reset__tx_pma_clk),
    .reset_out  (gtx_reset__tx_pma_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__tx_mac_clk_125 (
    .clk        (tx_mac_clk_125),
    .reset_in   (tx_reset__tx_mac_clk_125 | global_reset__tx_mac_clk_125),
    .reset_out  (gtx_reset__tx_mac_clk_125)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__tx_mac_clk (
    .clk        (tx_mac_clk),
    .reset_in   (tx_reset__tx_mac_clk | global_reset__tx_mac_clk),
    .reset_out  (gtx_reset__tx_mac_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__latency_sclk (
    .clk        (latency_sclk),
    .reset_in   (tx_reset__latency_sclk | global_reset__latency_sclk),
    .reset_out  (gtx_reset__latency_sclk)
);

// Global + RX Reset
alt_mge16_pcs_reset_synchronizer rsync__grx_reset__csr_clk (
    .clk        (csr_clk),
    .reset_in   (rx_reset__csr_clk | global_reset__csr_clk),
    .reset_out  (grx_reset__csr_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__rx_xgmii_clk (
    .clk        (rx_xgmii_clk),
    .reset_in   (rx_reset__rx_xgmii_clk | global_reset__rx_xgmii_clk),
    .reset_out  (grx_reset__rx_xgmii_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__rx_pma_clk (
    .clk        (rx_pma_clk),
    .reset_in   (rx_reset__rx_pma_clk | global_reset__rx_pma_clk),
    .reset_out  (grx_reset__rx_pma_clk)
);
alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__rx_mac_clk_125 (
    .clk        (rx_mac_clk_125),
    .reset_in   (rx_reset__rx_mac_clk_125 | global_reset__rx_mac_clk_125),
    .reset_out  (grx_reset__rx_mac_clk_125)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__rx_mac_clk (
    .clk        (rx_mac_clk),
    .reset_in   (rx_reset__rx_mac_clk | global_reset__rx_mac_clk),
    .reset_out  (grx_reset__rx_mac_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__rx_rec_div33_clk (
    .clk        (rx_rec_div33_clk),
    .reset_in   (rx_reset__rx_rec_div33_clk | global_reset__rx_rec_div33_clk),
    .reset_out  (grx_reset__rx_rec_div33_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__gtx_reset__rx_fm_ff_sample_clk (
    .clk        (rx_fm_ff_sample_clk),
    .reset_in   (rx_reset__rx_fm_ff_sample_clk | global_reset__rx_fm_ff_sample_clk),
    .reset_out  (grx_reset__rx_fm_ff_sample_clk)
);

alt_mge16_pcs_reset_synchronizer rsync__grx_reset__latency_sclk (
    .clk        (latency_sclk),
    .reset_in   (rx_reset__latency_sclk | global_reset__latency_sclk),
    .reset_out  (grx_reset__latency_sclk)
);



// Global + RX Reset on TX Clock Domain
alt_mge16_pcs_reset_synchronizer rsync__grx_reset__tx_pma_clk (
    .clk        (tx_pma_clk),
    .reset_in   (rx_reset__tx_pma_clk | global_reset__tx_pma_clk),
    .reset_out  (grx_reset__tx_pma_clk)
);

endmodule
