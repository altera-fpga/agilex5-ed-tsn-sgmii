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


// (C) 2001-2021 Intel Corporation. All rights reserved.
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


`timescale 1ps / 1ps
module alt_mge_pcs20 (
	input wire [0:0]  rx_clk,
	input wire [19:0] rx_datain,
	input wire [0:0]  rx_digitalreset,
	//input wire [0:0]  rx_enapatternalign,
	input wire [1:0]  tx_ctrlenable,
	input wire [15:0] tx_datain,
	input wire [0:0]  tx_digitalreset,
	output reg [1:0]  rx_ctrldetect,
	output reg [15:0] rx_dataout,
	output reg        rx_patterndetect,
	output reg [4:0]  rx_bitslipboundary_sel,
	output reg [1:0]  rx_disperr,
	output reg [1:0]  rx_errdetect,
   output wire [1:0] carrier_detected,
   output wire [1:0] rx_sync,
	input wire [0:0]  tx_clk,
	output wire [19:0] tx_dataout
);
parameter ALIGN_PATTERN1 = 10'h17C; // K28.5-
parameter ALIGN_PATTERN2 = 10'h283; // K28.5+
// parameter ALIGN_PATTERN2 = 10'h17C; // K28.5-

parameter EDGE_MODE = 1;
parameter FIRST_WORD_VALID = 1;

// Hook up RX word aligner
wire [1:0]  rx_disperr_w;
wire [1:0]  rx_errdetect_w;
wire [19 : 0] rx_dataout_wa;
wire          rx_patterndetect_wa;
reg  [1:0]    rx_patterndetect_wa_reg;                //1 cycle in decoder + 1 cycle at pcs20
wire [4:0]    rx_bitslipboundary_sel_wa;
reg  [4:0]    rx_bitslipboundary_sel_wa_reg [1:0];    //1 cycle in decoder + 1 cycle at pcs20

//sync clear at rx input
reg [19:0]  rx_datain_reg_sc;
//reg [0:0]   rx_enapatternalign_reg_sc;
wire [1:0]  rx_ctrldetect_wire;
wire [15:0] rx_dataout_wire;
wire [1:0]  rx_disperr_wire;
wire [1:0]  rx_errdetect_wire;
always @ (posedge rx_clk) begin
    if (rx_digitalreset) begin
        rx_datain_reg_sc <= 20'b0;        
        //rx_enapatternalign_reg_sc <= 1'b0;        
        rx_ctrldetect <= 2'b0;
        rx_dataout <= 16'b0;
        rx_patterndetect <= 1'b0;
        rx_bitslipboundary_sel <= 5'b0;
        rx_disperr <= 2'b0;
        rx_errdetect <= 2'b0;        
    end else begin
        rx_datain_reg_sc <= rx_datain;  
        //rx_enapatternalign_reg_sc <= rx_enapatternalign;  
        rx_ctrldetect <= rx_ctrldetect_wire;
        rx_dataout <=  rx_dataout_wire;
        rx_patterndetect <= rx_patterndetect_wa_reg[1];
        rx_bitslipboundary_sel <= rx_bitslipboundary_sel_wa_reg[1];
        rx_disperr <= rx_disperr_wire;
        rx_errdetect <= rx_errdetect_wire;
    end
end

//sync clear at tx input
reg [15:0] tx_datain_reg_sc;
reg [1:0] tx_ctrlenable_reg_sc;
always @ (posedge tx_clk) begin
    if (tx_digitalreset) begin
        tx_datain_reg_sc <= 16'b0;
        tx_ctrlenable_reg_sc <= 2'b0;
    end else begin
        tx_datain_reg_sc <= tx_datain;
        tx_ctrlenable_reg_sc <= tx_ctrlenable;
    end
end

//hyper pipeline and hyper retimer flop
reg [19:0] rx_dataout_wa_reg;
        
always @(posedge rx_clk)
begin
    rx_dataout_wa_reg <= rx_dataout_wa;
end

alt_mge_wordalign20 #(
   .ALIGN_PATTERN1   (ALIGN_PATTERN1),
	.ALIGN_PATTERN2   (ALIGN_PATTERN2),
	.EDGE_MODE        (EDGE_MODE),
	.FIRST_WORD_VALID (FIRST_WORD_VALID)
) wa (
	.clk(rx_clk),
	.rx_digitalreset(rx_digitalreset),
	.rx_enapatternalign(!rx_sync),
    //.rx_enapatternalign(rx_enapatternalign_reg_sc),
	.rx_datain(rx_datain_reg_sc),
	.rx_patterndetect(rx_patterndetect_wa),
	.rx_bitslipboundary_sel(rx_bitslipboundary_sel_wa),
	.rx_dataout(rx_dataout_wa)
);

// Delay rx_patterndetect by latency of 8b10b
always @(posedge rx_clk)
begin
   rx_patterndetect_wa_reg[0] <= rx_patterndetect_wa;
   rx_patterndetect_wa_reg[1] <= rx_patterndetect_wa_reg[0];

   rx_bitslipboundary_sel_wa_reg[0] <= rx_bitslipboundary_sel_wa;
   rx_bitslipboundary_sel_wa_reg[1] <= rx_bitslipboundary_sel_wa_reg[0];
end

// Hook up RX 8b10b
alt_mge_x2_decoder_8b10b dec20(
	.clk(rx_clk),
	.rst(rx_digitalreset),
	.din_dat(rx_dataout_wa_reg),
	.dout_dat(rx_dataout_wire),
	.dout_k(rx_ctrldetect_wire),
	.dout_kerr(rx_errdetect_wire),
	.dout_rderr(rx_disperr_wire),
	.dout_rdcomb(),   // UNUSED
	.dout_rdreg()     // UNUSED
);

// Carrier detect logic
alt_mge_x2_carrier_detect det20(
   .clk(rx_clk),
   .rst(rx_digitalreset),
   .din_dat(rx_dataout_wa_reg),
   .carrier_detected(carrier_detected)
);

// RX synchronization state machine
alt_mge_x2_rx_sync rxsync20 (
   .clk(rx_clk),
   .reset(rx_digitalreset),
   .signal_detect(1'b1),
   .kchar(rx_ctrldetect_wire),
   .data(rx_dataout_wire),
   .char_err(rx_errdetect_wire | rx_disperr_wire), // cgbad includes also RD error.
   .sync_lost(),  // UNUSED
   .sync_acqurd(),// UNUSED
   .rx_even(),    // UNUSED
   .rx_sync(rx_sync)
);

// Hook up TX 8b10b
alt_mge_x2_encoder_8b10b enc20(
	.clk(tx_clk),
	.rst(tx_digitalreset),
	.kin_ena(tx_ctrlenable_reg_sc),
	.ein_dat(tx_datain_reg_sc),
	.eout_dat(tx_dataout)
);

endmodule
