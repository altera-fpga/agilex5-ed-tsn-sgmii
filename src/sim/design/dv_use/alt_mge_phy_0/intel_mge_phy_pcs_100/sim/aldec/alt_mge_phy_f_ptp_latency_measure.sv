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


// *********************************************************************************
// Parameter definition
// 1) DL_SYNC_PULSE_PERIOD - Period after which Tx Sync Pulse is generated
// 2) DL_ASYNC_PULSE_WIDTH - Width of the Tx/Rx Async Pulse
// 3) DL_TOT_MEASURE_CNT   - # of times measurement is averaged
// 4) COUNT_WIDTH          - Counter width 
// *********************************************************************************

`timescale 1ps/1ps

module alt_mge_phy_f_ptp_latency_measure
import alt_mge_phy_f_ptp_package::*;
#(
    parameter DL_HS_SYNC_PULSE_PERIOD = 48,
    parameter DL_LS_SYNC_PULSE_PERIOD = 264,
    parameter DL_ASYNC_PULSE_WIDTH    = 11,
    parameter DL_TOT_MEASURE_CNT      = 10,
    parameter COUNT_WIDTH             = 8,
    parameter N = COUNT_WIDTH - $clog2(DL_TOT_MEASURE_CNT), // Engineering parameter - DON'T CHANGE
    parameter M = $clog2(DL_TOT_MEASURE_CNT) + 1,           // Engineering parameter - DON'T CHANGE
    parameter CALC_WIDTH = N + M                            // Engineering parameter - DON'T CHANGE
) (
    input                       i_tx_reset_sync_sclk,
    input                       i_rx_reset_sync_sclk,
    input                       i_reset_async_pulse_clk,
    input                       i_reset_sync_txclk,
    input                       i_reset_sync_rxclk,
    input                       i_reset_async_txclk,
    input                       i_reset_async_rxclk,
    input                       i_tx_reset_async,
    input                       i_rx_reset_async,
    input                       i_tx_parallel_clk,      // Clock for transmit parallel data
    input                       i_rx_parallel_clk,      // Clock for receive parallel data
    input                       i_smpl_clk,             // 250MHz sampling clock
    input                       i_tx_dl_valid,
    input                       i_rx_sync_pulse,        // Stop pulse for Rx Sync Count
    input                       i_rx_async_pulse,       // Start pulse for Rx sync count and stop pulse for Rx Async count
    input                       i_tx_async_pulse,       // Stop pulse for Tx sync count and Tx Async count

    output                      o_tx_sync_pulse,        // Start pulse for Tx sync count
    output                      o_async_pulse,          // Input to send pulse to measure tx/rx async path (latency_sclk)
    output                      o_tx_measure_sel,
    output                      o_rx_measure_sel,
    output [CALC_WIDTH-1:0]     o_tx_delay_sclk,        // Calculated tx delay => fixed point - N.M
    output [CALC_WIDTH-1:0]     o_rx_delay_sclk,        // Calculated rx delay => fixed point - N.M
    output                      o_tx_measure_valid,
    output                      o_rx_measure_valid,
    output [COUNT_WIDTH-1:0]    o_tx_sync_count,
    output [COUNT_WIDTH-1:0]    o_tx_async_count,
    output [COUNT_WIDTH-1:0]    o_rx_sync_count,
    output [COUNT_WIDTH-1:0]    o_rx_async_count,
    output                      o_tx_sync_valid,
    output                      o_tx_async_valid,
    output                      o_rx_sync_valid,
    output                      o_rx_async_valid,
    output                      o_tx_sync_pulse_2x_ack
);
    
    wire    reset_sync_n_txclk;
    wire    start_tx_sync_int_sclk_sync, tx_async_pulse_sclk_sync, tx_start_async_int_sclk_sync, rx_start_async_int_sclk_sync;
    wire    rx_async_pulse_sclk_sync, rx_stop_sync_int_sclk_sync;
    
    wire    valid_txsync, valid_rxsync;
    wire    valid_txasync, valid_rxasync;
    
    reg     rx_sync_d1, rx_sync_d2, rx_sync_d3, rx_sync_d4, rx_sync_d5, rx_sync_d6;
    reg     tx_sync_d1, tx_sync_d2, tx_sync_d3, tx_sync_d4, tx_sync_d5, tx_sync_d6;
    wire    rx_sync_pulse_stretch, tx_sync_pulse_stretch;
    wire    tx_sync_int, rx_sync_int;
    wire    tx_measure_valid, rx_measure_valid;
    wire    tx_calc_delay_valid, rx_calc_delay_valid;
    reg     tx_sync_int_reg, rx_sync_int_reg;
    
    wire    tx_dl_measure_en;
    wire    rx_dl_measure_en;
    
    wire    tx_dl_measure_en_sclk_sync;
    wire    rx_dl_measure_en_sclk_sync;
    
    wire    tx_measure_sel_sclk_sync;
    wire    rx_measure_sel_sclk_sync;

    wire [COUNT_WIDTH-1:0]      tx_sync_count;
    wire [COUNT_WIDTH-1:0]      tx_async_count;
    wire [COUNT_WIDTH-1:0]      rx_sync_count;
    wire [COUNT_WIDTH-1:0]      rx_async_count;
    
    assign reset_sync_n_txclk = ~i_reset_sync_txclk;
    
    assign o_tx_measure_valid = tx_calc_delay_valid;
    assign o_rx_measure_valid = rx_calc_delay_valid;

    assign o_tx_sync_count  = tx_sync_count;
    assign o_tx_async_count = tx_async_count;
    assign o_rx_sync_count  = rx_sync_count;
    assign o_rx_async_count = rx_async_count;

    assign o_tx_sync_valid  = valid_txsync;
    assign o_tx_async_valid = valid_txasync;
    assign o_rx_sync_valid  = valid_rxsync;
    assign o_rx_async_valid = valid_rxasync;

    assign tx_measure_valid = valid_txsync & valid_txasync;
    assign rx_measure_valid = valid_rxsync & valid_rxasync;
    assign rx_sync_pulse_stretch = rx_sync_d1 | rx_sync_d2 | rx_sync_d3 | rx_sync_d4 | rx_sync_d5 | rx_sync_d6;
    assign tx_sync_pulse_stretch = tx_sync_d1 | tx_sync_d2 | tx_sync_d3 | tx_sync_d4 | tx_sync_d5 | tx_sync_d6;

    assign tx_sync_int = tx_sync_int_reg;
    assign rx_sync_int = rx_sync_int_reg;

    
    wire tx_sync_count_start_pulse;
    wire tx_sync_count_stop_pulse;
    wire tx_async_count_start_pulse;
    wire tx_async_count_stop_pulse;
    wire rx_sync_count_start_pulse;
    wire rx_sync_count_stop_pulse;
    wire rx_async_count_start_pulse;
    wire rx_async_count_stop_pulse;
    
    wire tx_reset_async_n;
    wire rx_reset_async_n;
    
    assign tx_sync_count_start_pulse  = start_tx_sync_int_sclk_sync  & tx_measure_sel_sclk_sync  & tx_dl_measure_en_sclk_sync;
    assign tx_sync_count_stop_pulse   = tx_async_pulse_sclk_sync     & tx_measure_sel_sclk_sync  & tx_dl_measure_en_sclk_sync;
    assign tx_async_count_start_pulse = tx_start_async_int_sclk_sync & ~tx_measure_sel_sclk_sync & tx_dl_measure_en_sclk_sync;
    assign tx_async_count_stop_pulse  = tx_async_pulse_sclk_sync     & ~tx_measure_sel_sclk_sync & tx_dl_measure_en_sclk_sync;
    assign rx_sync_count_start_pulse  = rx_async_pulse_sclk_sync     & rx_measure_sel_sclk_sync  & rx_dl_measure_en_sclk_sync;
    assign rx_sync_count_stop_pulse   = rx_stop_sync_int_sclk_sync   & rx_measure_sel_sclk_sync  & rx_dl_measure_en_sclk_sync;
    assign rx_async_count_start_pulse = rx_start_async_int_sclk_sync & ~rx_measure_sel_sclk_sync & rx_dl_measure_en_sclk_sync;
    assign rx_async_count_stop_pulse  = rx_async_pulse_sclk_sync     & ~rx_measure_sel_sclk_sync & rx_dl_measure_en_sclk_sync;
    
    assign tx_reset_async_n = ~i_tx_reset_async;
    assign rx_reset_async_n = ~i_rx_reset_async;

    // Always pulse stretch no matter what speed, to simplify logic
    always @(posedge i_rx_parallel_clk) begin
        if(i_reset_sync_rxclk) begin
            rx_sync_d1 <= 1'b0;
            rx_sync_d2 <= 1'b0;
            rx_sync_d3 <= 1'b0;
            rx_sync_d4 <= 1'b0;
            rx_sync_d5 <= 1'b0;
            rx_sync_d6 <= 1'b0;
        end
        else begin
            rx_sync_d1 <= i_rx_sync_pulse;
            rx_sync_d2 <= rx_sync_d1;
            rx_sync_d3 <= rx_sync_d2;
            rx_sync_d4 <= rx_sync_d3;
            rx_sync_d5 <= rx_sync_d4;
            rx_sync_d6 <= rx_sync_d5;
      end
    end

    // Always pulse stretch no matter what speed, to simplify logic
    always @(posedge i_tx_parallel_clk) begin
        if(i_reset_sync_txclk) begin
            tx_sync_d1 <= 1'b0;
            tx_sync_d2 <= 1'b0;
            tx_sync_d3 <= 1'b0;
            tx_sync_d4 <= 1'b0;
            tx_sync_d5 <= 1'b0;
            tx_sync_d6 <= 1'b0;
        end
        else begin
            tx_sync_d1 <= o_tx_sync_pulse;
            tx_sync_d2 <= tx_sync_d1;
            tx_sync_d3 <= tx_sync_d2;
            tx_sync_d4 <= tx_sync_d3;
            tx_sync_d5 <= tx_sync_d4;
            tx_sync_d6 <= tx_sync_d5;
      end
    end

    // Register to avoid combi logic before synchronizer
    always @(posedge i_tx_parallel_clk) begin
        if(i_reset_sync_txclk) begin
            tx_sync_int_reg <= 1'b0;
        end
        else begin
            tx_sync_int_reg <= tx_sync_pulse_stretch;
        end
    end

    always @(posedge i_rx_parallel_clk) begin
        if(i_reset_sync_rxclk) begin
            rx_sync_int_reg <= 1'b0;
        end
        else begin
            rx_sync_int_reg <= rx_sync_pulse_stretch;
        end
    end
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (0)
    ) __syncdata__tx_dl_measure_en_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (tx_reset_async_n),
        .din                (tx_dl_measure_en),
        .dout               (tx_dl_measure_en_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (0)
    ) __syncdata__rx_dl_measure_en_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (rx_reset_async_n),
        .din                (rx_dl_measure_en),
        .dout               (rx_dl_measure_en_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (0)
    ) __syncdata__tx_mux_sel_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (tx_reset_async_n),
        .din                (o_tx_measure_sel),
        .dout               (tx_measure_sel_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (0)
    ) __syncdata__rx_mux_sel_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (rx_reset_async_n),
        .din                (o_rx_measure_sel),
        .dout               (rx_measure_sel_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (1)
    ) __syncdata__tx_sync_start_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (tx_reset_async_n),
        .din                (tx_sync_int),
        .dout               (start_tx_sync_int_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (1)
    ) __syncdata__tx_async_stop_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (tx_reset_async_n),
        .din                (i_tx_async_pulse),
        .dout               (tx_async_pulse_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (1)
    ) __syncdata__rx_sync_stop_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (rx_reset_async_n),
        .din                (rx_sync_int),
        .dout               (rx_stop_sync_int_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (1)
    ) __syncdata__rx_async_start_stop_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (rx_reset_async_n),
        .din                (i_rx_async_pulse),
        .dout               (rx_async_pulse_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (1)
    ) __syncdata__tx_async_start_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (tx_reset_async_n),
        .din                (o_async_pulse),
        .dout               (tx_start_async_int_sclk_sync)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth              (2),
        .turn_off_meta      (1)
    ) __syncdata__rx_async_start_sclk_resync (
        .clk                (i_smpl_clk),
        .reset_n            (rx_reset_async_n),
        .din                (o_async_pulse),
        .dout               (rx_start_async_int_sclk_sync)
    );

    alt_mge_phy_f_ptp_async_pulse_gen #(
        .DL_ASYNC_PULSE_WIDTH       (DL_ASYNC_PULSE_WIDTH)
    ) async_pulse_gen_inst (
        .clk                (i_tx_parallel_clk),
        .reset              (i_reset_async_pulse_clk),
        .async_pulse        (o_async_pulse)
    );

    alt_mge_phy_f_ptp_tx_am_muxsel_gen #(
        .DL_TOT_MEASURE_CNT         (DL_TOT_MEASURE_CNT),
        .DL_HS_SYNC_PULSE_PERIOD    (DL_HS_SYNC_PULSE_PERIOD),
        .DL_LS_SYNC_PULSE_PERIOD    (DL_LS_SYNC_PULSE_PERIOD)
    ) tx_am_muxsel_gen_inst (
        .clk                    (i_tx_parallel_clk),
        .reset                  (i_reset_async_txclk),
        .reset_sync_n           (reset_sync_n_txclk),
        .rate_sel               (1'b1),
        .valid                  (i_tx_dl_valid),
        .async_pulse            (o_async_pulse),
        .tx_mux_sel             (o_tx_measure_sel),
        .tx_sync_pulse          (o_tx_sync_pulse),
        .tx_dl_measure_en       (tx_dl_measure_en),
        .o_tx_sync_pulse_2x_ack (o_tx_sync_pulse_2x_ack)
    );

    alt_mge_phy_f_ptp_rx_am_muxsel_gen #(
        .DL_TOT_MEASURE_CNT (DL_TOT_MEASURE_CNT)
    ) rx_am_muxsel_gen_inst (
        .clk                (i_rx_parallel_clk),
        .reset              (i_reset_async_rxclk),
        .async_pulse        (o_async_pulse),
        .rx_mux_sel         (o_rx_measure_sel),
        .rx_dl_measure_en   (rx_dl_measure_en)
    );
    
    alt_mge_phy_f_ptp_latency_count_txsync #(
        .COUNT_WIDTH        (COUNT_WIDTH),
        .DL_TOT_MEASURE_CNT (DL_TOT_MEASURE_CNT)
    ) tx_sync_count_inst (
        .reset              (i_tx_reset_sync_sclk),
        .clk                (i_smpl_clk),
        .start              (tx_sync_count_start_pulse),
        .stop               (tx_sync_count_stop_pulse),
        .counter_out        (tx_sync_count),
        .measure_done       (valid_txsync)
    );
    
    alt_mge_phy_f_ptp_latency_count_async #(
        .COUNT_WIDTH        (COUNT_WIDTH),
        .DL_TOT_MEASURE_CNT (DL_TOT_MEASURE_CNT)
    ) tx_async_count_inst (
        .reset              (i_tx_reset_sync_sclk),
        .clk                (i_smpl_clk),
        .start              (tx_async_count_start_pulse),
        .stop               (tx_async_count_stop_pulse),
        .counter_out        (tx_async_count),
        .measure_done       (valid_txasync)
    );
    
    alt_mge_phy_f_ptp_latency_count_rxsync #(
        .COUNT_WIDTH        (COUNT_WIDTH),
        .DL_TOT_MEASURE_CNT (DL_TOT_MEASURE_CNT)
    ) rx_sync_count_inst (
        .reset              (i_rx_reset_sync_sclk),
        .clk                (i_smpl_clk),
        .start              (rx_sync_count_start_pulse),
        .stop               (rx_sync_count_stop_pulse),
        .counter_out        (rx_sync_count),
        .measure_done       (valid_rxsync)
    );

    alt_mge_phy_f_ptp_latency_count_async #(
        .COUNT_WIDTH        (COUNT_WIDTH),
        .DL_TOT_MEASURE_CNT (DL_TOT_MEASURE_CNT)
    ) rx_async_count_inst (
        .reset              (i_rx_reset_sync_sclk),
        .clk                (i_smpl_clk),
        .start              (rx_async_count_start_pulse),
        .stop               (rx_async_count_stop_pulse),
        .counter_out        (rx_async_count),
        .measure_done       (valid_rxasync)
    );

    alt_mge_phy_f_ptp_calc_delay #(
        .DL_TOT_MEASURE_CNT      (DL_TOT_MEASURE_CNT),
        .COUNT_WIDTH             (COUNT_WIDTH)
    ) calc_delay_0 (
        .i_tx_reset              (i_tx_reset_sync_sclk),
        .i_rx_reset              (i_rx_reset_sync_sclk),
        .i_smpl_clk              (i_smpl_clk),
        .tx_measure_valid        (tx_measure_valid),
        .rx_measure_valid        (rx_measure_valid),
        .tx_sync_count           (tx_sync_count),
        .tx_async_count          (tx_async_count),
        .rx_sync_count           (rx_sync_count),
        .rx_async_count          (rx_async_count),
        .tx_delay_sclk           (o_tx_delay_sclk),
        .rx_delay_sclk           (o_rx_delay_sclk),
        .tx_calc_delay_valid     (tx_calc_delay_valid),
        .rx_calc_delay_valid     (rx_calc_delay_valid)
    );

endmodule
