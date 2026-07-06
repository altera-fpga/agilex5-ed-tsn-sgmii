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

module alt_mge_phy_f_ptp_calc_delay #(
    parameter DL_TOT_MEASURE_CNT = 10,
    parameter COUNT_WIDTH        = 8,
    parameter N                  = COUNT_WIDTH - $clog2(DL_TOT_MEASURE_CNT), // Engineering parameter - DON'T CHANGE
                                                                             // integer portion of the calculated delay
    parameter M                  = $clog2(DL_TOT_MEASURE_CNT) + 1,           // Engineering parameter - DON'T CHANGE
                                                                             // fraction portion of the calculated delay
    parameter CALC_WIDTH         = N + M                                     // Engineering parameter - DON'T CHANGE
) (
    input                        i_tx_reset,            // active high tx reset
    input                        i_rx_reset,            // active high rx reset
    input                        i_smpl_clk,            // 250MHz sampling clock
    input                        tx_measure_valid,      // measurement valid flag
    input                        rx_measure_valid,      // measurement valid flag
    input      [COUNT_WIDTH-1:0] tx_sync_count,         // tx sync counts
    input      [COUNT_WIDTH-1:0] tx_async_count,        // tx async counts
    input      [COUNT_WIDTH-1:0] rx_sync_count,         // rx sync counts
    input      [COUNT_WIDTH-1:0] rx_async_count,        // rx async counts
    output reg [CALC_WIDTH-1:0]  tx_delay_sclk,         // calculated tx delay => fixed point - N.M
    output reg [CALC_WIDTH-1:0]  rx_delay_sclk,         // calculated rx delay => fixed point - N.M
    output reg                   tx_calc_delay_valid,   // calculated delay valid
    output reg                   rx_calc_delay_valid    // calculated delay valid
);

    /********************************************************************
     * localparam                                                       *
     ********************************************************************/
    localparam [31:0] shift_sync  = $clog2(DL_TOT_MEASURE_CNT);
    localparam [31:0] shift_async = $clog2(DL_TOT_MEASURE_CNT) + 1;
    localparam [9:0]  ASYNC_ADJUST = 10'h2F4;   // 6 * 3.2ns due to rising edge start counter and falling edge stop counter used in async delay measurement
                                                // Divided by 6.5ns to convert to number of sampling clock cycle

    /********************************************************************
     * wire                                                             *
     ********************************************************************/
    wire [COUNT_WIDTH-1+M:0]            tx_delay_sclk_wire;
    wire [COUNT_WIDTH-1+M:0]            rx_delay_sclk_wire;

    /********************************************************************
     * logic                                                            *
     ********************************************************************/
    // -- tx delay calculation
    assign tx_delay_sclk_wire = ({tx_sync_count, {M{1'b0}}} >> shift_sync) -
                                ({tx_async_count,{M{1'b0}}} >> shift_async) + ASYNC_ADJUST;

    // -- rx delay calculation
    assign rx_delay_sclk_wire = ({rx_sync_count, {M{1'b0}}} >> shift_sync) +
                                ({rx_async_count,{M{1'b0}}} >> shift_async) - ASYNC_ADJUST;

    // -- measure valid
    always @(posedge i_smpl_clk) begin
        if(i_tx_reset) begin
            tx_calc_delay_valid <= 1'b0;
        end else begin
            tx_calc_delay_valid <= tx_measure_valid;
        end
    end

    always @(posedge i_smpl_clk) begin
        if(i_rx_reset) begin
            rx_calc_delay_valid <= 1'b0;
        end else begin
            rx_calc_delay_valid <= rx_measure_valid;
        end
    end

    // -- output calculated delays
    always @(posedge i_smpl_clk) begin
        if(i_tx_reset) begin
            tx_delay_sclk <= 'd0;
        end else begin
            tx_delay_sclk <= tx_delay_sclk_wire[CALC_WIDTH-1:0];
        end
    end

    always @(posedge i_smpl_clk) begin
        if(i_rx_reset) begin
            rx_delay_sclk <= 'd0;
        end else begin
            rx_delay_sclk <= rx_delay_sclk_wire[CALC_WIDTH-1:0];
        end
    end

endmodule
