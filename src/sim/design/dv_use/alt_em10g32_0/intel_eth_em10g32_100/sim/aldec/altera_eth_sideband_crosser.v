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
module altera_eth_sideband_crosser #(
    parameter WIDTH = 8,
    parameter USE_ASYNC_ADAPTOR = 0,
    parameter SYNC_RESET_N = 1
) (
    input  wire             in_clk,
    input  wire             in_rst_n,
    input  wire             in_valid,
    input  wire [WIDTH-1:0] in_data,
    
    input  wire             out_clk,
    input  wire             out_rst_n,
    output wire             out_valid,
    output wire [WIDTH-1:0] out_data
);

generate if(USE_ASYNC_ADAPTOR)
begin : ADAPTOR
    alt_em10g32_avalon_dc_fifo #(
        .SYMBOLS_PER_BEAT   (1),
        .BITS_PER_SYMBOL    (WIDTH),
        .FIFO_DEPTH         (16),
        .ERROR_WIDTH        (0),
        .USE_PACKETS        (0),
        .STREAM_ALMOST_EMPTY(0),
        .SYNC_RESET_N       (SYNC_RESET_N)
    ) dc_fifo (

        .in_clk                 (in_clk),
        .in_reset_n             (in_rst_n),
        
        .out_clk                (out_clk),
        .out_reset_n            (out_rst_n),
        
        // sink
        .in_data                (in_data),
        .in_valid               (in_valid),
        .in_ready               (),
        .in_startofpacket       (1'b0),
        .in_endofpacket         (1'b0),
        .in_empty               (1'b0),
        .in_error               (1'b0),
        .in_channel             (1'b0),
        
        // source
        .out_data               (out_data),
        .out_valid              (out_valid),
        .out_ready              (1'b1),
        .out_startofpacket      (),
        .out_endofpacket        (),
        .out_empty              (),
        .out_error              (),
        .out_channel            (),
        
        // streaming in status
        .almost_full_valid      (),
        .almost_full_data       (),
        
        // streaming out status
        .almost_empty_valid     (),
        .almost_empty_data      (),
        
        // in clock
        .in_fill_level          (),
        .almost_full_threshold  (5'd0),
        
        // out clock
        .out_fill_level         (),
        .almost_empty_threshold (5'd2),
        
        .space_avail_data       (),
        
        // Latency Measurement
        .sampling_clk           (1'b0),
        .sampling_clk_reset_n   (1'b0),
        
        .latency_out_clk        (1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out            ()
    );
end
else begin
    altera_eth_sideband_crosser_sync #(
        .WIDTH (WIDTH),
        .SYNC_RESET_N(SYNC_RESET_N)
    ) sync_crosser (
        .in_clk     (in_clk),
        .in_rst_n   (in_rst_n),
        
        .out_clk    (out_clk),
        .out_rst_n  (out_rst_n),
        
        .in_valid   (in_valid),
        .in_data    (in_data),
        
        .out_valid  (out_valid),
        .out_data   (out_data)
    );
end
endgenerate

endmodule
