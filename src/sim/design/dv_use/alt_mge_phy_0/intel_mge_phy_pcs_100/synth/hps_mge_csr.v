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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module hps_mge_csr (
    input               clk,
    input               rst_n,
    input               addr,
    input               read,
    input               write,
    input [31:0]        writedata,
    input               txbuf_overflow,
    input               txbuf_underflow,
    input               pll_locked,
    input               isreset_tx,
    input               isreset_rx,
    input               speed_match,
    input               missalign,

    output reg [31:0]   readdata,
    output              tx_disable

);

reg             ctrl;

wire            ctrl_address_decode;
wire            ctrl_write_en;
wire            ctrl_read_en;
wire [31:0]     readdata_internal;
wire [31:0]     ctrl_readdata_internal;

// address decode
assign ctrl_address_decode  = (addr == 1'b0);
assign status_address_decode  = (addr == 1'b1);

// write decode
assign ctrl_write_en        = write & ctrl_address_decode;
    
// read decode
assign ctrl_read_en         = read & ctrl_address_decode;
assign status_read_en       = read & status_address_decode;

// register implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        ctrl    <= 1'h1;
    else if (ctrl_write_en)
        ctrl    <= writedata[0];
end

assign ctrl_readdata_internal = {31'h0, ctrl};

// readdata path
assign readdata_internal = ctrl_readdata_internal & {32{ctrl_read_en}};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        readdata    <= 32'h0;
    else begin
        if (ctrl_read_en)
            readdata    <= readdata_internal;
        else if (status_read_en)
            readdata    <= {25'h0, missalign, speed_match, isreset_rx, isreset_tx, pll_locked, txbuf_underflow, txbuf_overflow};
    end
end


// Outputs assignment
//assign tx_disable = ctrl;
assign tx_disable = 0;


endmodule
