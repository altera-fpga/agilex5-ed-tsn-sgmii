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

module alt_em10g32_xgmii_data_format_adapter
(
    input  wire        tx_clk,
    input  wire        tx_reset_n,
    input  wire        rx_clk,
    input  wire        rx_reset_n,
    input  wire [31:0] tx_in_data,
    input  wire [3:0]  tx_in_control,
    input  wire        tx_in_valid,
    output wire        tx_in_ready,
    output wire [63:0] tx_out_data,
    output wire [7:0]  tx_out_control,
    output wire        tx_out_valid,
    input  wire        tx_out_ready,
    input  wire [63:0] rx_in_data,
    input  wire [7:0]  rx_in_control,
    input  wire        rx_in_valid,
    // output wire        rx_in_ready,
    output wire [31:0] rx_out_data,
    output wire [3:0]  rx_out_control,
    output wire        rx_out_valid,
    input  wire        rx_out_ready
);
parameter SYNC_RESET_N = 1;
wire [35:0] xgmii_tx_in;
wire [71:0] xgmii_tx_out;
wire [71:0] xgmii_rx_in;
wire [35:0] xgmii_rx_out;

assign xgmii_tx_in = {
   tx_in_control[3], tx_in_data[31:24],
   tx_in_control[2], tx_in_data[23:16],
   tx_in_control[1], tx_in_data[15:8],
   tx_in_control[0], tx_in_data[7:0]
};

assign xgmii_rx_in = {
   rx_in_control[7], rx_in_data[63:56],
   rx_in_control[6], rx_in_data[55:48],
   rx_in_control[5], rx_in_data[47:40],
   rx_in_control[4], rx_in_data[39:32],
   rx_in_control[3], rx_in_data[31:24],
   rx_in_control[2], rx_in_data[23:16],
   rx_in_control[1], rx_in_data[15:8],
   rx_in_control[0], rx_in_data[7:0]
};

assign tx_out_data = {
   xgmii_tx_out[70:63],
   xgmii_tx_out[61:54],
   xgmii_tx_out[52:45],
   xgmii_tx_out[43:36],
   xgmii_tx_out[34:27],
   xgmii_tx_out[25:18],
   xgmii_tx_out[16:9],
   xgmii_tx_out[7:0]
};

assign tx_out_control = {
   xgmii_tx_out[71],
   xgmii_tx_out[62],
   xgmii_tx_out[53],
   xgmii_tx_out[44],
   xgmii_tx_out[35],
   xgmii_tx_out[26],
   xgmii_tx_out[17],
   xgmii_tx_out[8]
};

assign rx_out_data = {
   xgmii_rx_out[34:27],
   xgmii_rx_out[25:18],
   xgmii_rx_out[16:9],
   xgmii_rx_out[7:0]
};

assign rx_out_control = {
   xgmii_rx_out[35],
   xgmii_rx_out[26],
   xgmii_rx_out[17],
   xgmii_rx_out[8]
};

    alt_em10g32_xgmii_32_to_64_adapter #(
      .SYNC_RESET_N(SYNC_RESET_N)
    ) tx_data_step_up (
        .clk           (tx_clk),
        .reset_n       (tx_reset_n),
        .in_data       (xgmii_tx_in),
        .in_valid      (tx_in_valid),
        .in_ready      (tx_in_ready),
        .out_data      (xgmii_tx_out),
        .out_valid     (tx_out_valid),
        .out_ready     (tx_out_ready)
    );
    
    alt_em10g32_xgmii_64_to_32_adapter #(
      .SYNC_RESET_N(SYNC_RESET_N)
    ) rx_data_step_down (
        .clk           (rx_clk),
        .reset_n       (rx_reset_n),
        .in_data       (xgmii_rx_in),
        .in_valid      (rx_in_valid),
        .out_data      (xgmii_rx_out),
        .out_valid     (rx_out_valid)
    );


endmodule
