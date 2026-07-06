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


`timescale 1 ns / 1 ps
module tse_ftile_efifo_rd_en_toggle #(
    parameter                   ENABLE_TIMESTAMPING = 0
) (
    input                       clk,                // fifo read side clock
    input                       rst_n,              // active low reset, synced to read clk
    input                       rd_en,              // fifo read enable
    input       [39:0]          data_in,            // data input <effective 40 bits>
    input       [ 1:0]          sync_pulse_in,      // PTP deterministic latency sync pulse input
    output reg                  rd_en_toggled,      // output toggled read enable
    output      [19:0]          data_out,           // data output <effective 20 bits>
    output                      sync_pulse_out      // PTP deterministic latency sync pulse output
);

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)              rd_en_toggled <= 1'b0;
    else if(!rd_en)         rd_en_toggled <= 1'b0;
    else                    rd_en_toggled <= ~rd_en_toggled;
end

// 20 bits for data output
assign data_out[19:0] = (!rd_en_toggled)? data_in[19:0]:data_in[39:20];
assign sync_pulse_out = (!rd_en_toggled)? (ENABLE_TIMESTAMPING ? sync_pulse_in[0] : 1'b0):
                                          (ENABLE_TIMESTAMPING ? sync_pulse_in[1] : 1'b0);

endmodule
