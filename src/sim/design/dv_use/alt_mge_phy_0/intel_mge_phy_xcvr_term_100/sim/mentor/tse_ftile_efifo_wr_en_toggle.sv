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
module tse_ftile_efifo_wr_en_toggle #(
    parameter                   ENABLE_TIMESTAMPING = 0
) (
    input                       clk,                // fifo write side clock
    input                       rst_n,              // active low reset, synced to write clk
    input                       wr_en,              // fifo write enable
    input       [19:0]          data_in,            // data input <effective 20 bits>
    input                       sync_pulse_in,      // PTP deterministic latency sync pulse input
    output reg                  wr_en_toggled,      // output toggled write enable
    output      [39:0]          data_out,           // data output <effective 40 bits>
    output      [ 1:0]          sync_pulse_out      // PTP deterministic latency sync pulse output; sync_pulse_out[1] - Sync pulse output
                                                    //                                              sync_pulse_out[0] - Sync pulse output delayed by 1 system clock div2 cycle
);

reg [19:0]    data_in_d;
reg           sync_pulse_d;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)              wr_en_toggled <= 1'b0;
    else if(!wr_en)         wr_en_toggled <= 1'b0;
    else                    wr_en_toggled <= ~wr_en_toggled;
end

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin        data_in_d <= 20'd0;
                            sync_pulse_d <= 1'b0;
    end
    else begin              data_in_d <= data_in;
                            sync_pulse_d <= sync_pulse_in;
    end
end

assign data_out[39:0]  = {data_in[19:0],data_in_d[19:0]};
assign sync_pulse_out  = ENABLE_TIMESTAMPING ? {sync_pulse_in, sync_pulse_d} : 2'b00;

endmodule

