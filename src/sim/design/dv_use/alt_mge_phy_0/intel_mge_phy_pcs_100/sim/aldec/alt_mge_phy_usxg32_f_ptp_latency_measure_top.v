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


module alt_mge_phy_usxg32_f_ptp_latency_measure_top (
    input           i_latency_sclk,
    input           i_tx_xgmii_clk,
    input           i_rx_xgmii_clk,

    input           i_rst_n_async_pulse_clk,

    input           i_tx_digital_rst_n,
    input           i_rx_digital_rst_n,
    
    input           i_global_rst_n,
    input           i_global_rst_n_tx_xgmii_clk,
    input           i_global_rst_n_rx_xgmii_clk,

    input           i_tx_stable,
    input           i_rx_stable,
    
    input           i_tx_dl_rst,
    input           i_rx_dl_rst,
    
    input           i_tx_dl_valid,
    input           i_rx_dl_sync_pulse,
    input           i_rx_dl_async_pulse,
    input           i_tx_dl_async_pulse,
    
    output          o_tx_dl_sync_pulse,
    output          o_dl_async_cal_pulse,

    output          o_tx_dl_measure_sel,
    output          o_rx_dl_measure_sel,

    output [20:0]   o_tx_dl_latency,
    output [20:0]   o_rx_dl_latency,
    
    output          o_tx_measure_valid,
    output          o_rx_measure_valid,
    
    output [19:0]   o_tx_sync_count,
    output [19:0]   o_tx_async_count,
    output [19:0]   o_rx_sync_count,
    output [19:0]   o_rx_async_count,
    
    output          o_tx_sync_valid,
    output          o_tx_async_valid,
    output          o_rx_sync_valid,
    output          o_rx_async_valid
);
    
    wire gtx_rst_n_async_pulse_clk_async_tx_xgmii_clk;
    wire global_rst_n_sclk;
    wire tx_rst_n_sclk, tx_stable_sclk, tx_dl_rst_n_sclk;
    wire rx_rst_n_sclk, rx_stable_sclk, rx_dl_rst_n_sclk;
    wire tx_rst_n_tx_xgmii_clk, tx_stable_tx_xgmii_clk, tx_dl_rst_n_tx_xgmii_clk;
    wire rx_rst_n_rx_xgmii_clk, rx_stable_rx_xgmii_clk, rx_dl_rst_n_rx_xgmii_clk;
    
    wire tx_dl_rst_n, rx_dl_rst_n;
    wire sclk_tx_rst, sclk_rx_rst, txclk_tx_rst, rxclk_rx_rst;
    
    wire gtx_rst_sync_sclk, gtx_rst_async_sclk, gtx_rst_sync_tx_xgmii_clk, gtx_rst_async_tx_xgmii_clk;
    wire grx_rst_sync_sclk, grx_rst_async_sclk, grx_rst_sync_rx_xgmii_clk, grx_rst_async_rx_xgmii_clk;
    
    wire gtx_rst_async_pulse_clk_async_tx_xgmii_clk;
    wire sclk_tx_rst_n, txclk_tx_rst_n;
    wire sclk_rx_rst_n, rxclk_rx_rst_n;
    
    wire gtx_rst_n_async_sclk, gtx_rst_n_async_tx_xgmii_clk;
    wire grx_rst_n_async_sclk, grx_rst_n_async_rx_xgmii_clk;

    assign tx_dl_rst_n = ~i_tx_dl_rst;
    assign rx_dl_rst_n = ~i_rx_dl_rst;
    

    // Async pulse clock reset_n
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__async_pulse_reset_sync_txclk (
        .clk            (i_tx_xgmii_clk),
        .reset_n        (i_rst_n_async_pulse_clk),
        .din            (1'b1),
        .dout           (gtx_rst_n_async_pulse_clk_async_tx_xgmii_clk)
    );
    
    
    // Latency sampling clock domain
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__global_reset_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (i_global_rst_n),
        .din            (1'b1),
        .dout           (global_rst_n_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_digital_reset_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (i_tx_digital_rst_n),
        .din            (1'b1),
        .dout           (tx_rst_n_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_digital_reset_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (i_rx_digital_rst_n),
        .din            (1'b1),
        .dout           (rx_rst_n_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_stable_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (i_tx_stable),
        .din            (1'b1),
        .dout           (tx_stable_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_stable_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (i_rx_stable),
        .din            (1'b1),
        .dout           (rx_stable_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_dl_reset_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (tx_dl_rst_n),
        .din            (1'b1),
        .dout           (tx_dl_rst_n_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_dl_reset_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (rx_dl_rst_n),
        .din            (1'b1),
        .dout           (rx_dl_rst_n_sclk)
    );
    
    
    // TX clock domain
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_digital_reset_async_txclk (
        .clk            (i_tx_xgmii_clk),
        .reset_n        (i_tx_digital_rst_n),
        .din            (1'b1),
        .dout           (tx_rst_n_tx_xgmii_clk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_stable_async_txclk (
        .clk            (i_tx_xgmii_clk),
        .reset_n        (i_tx_stable),
        .din            (1'b1),
        .dout           (tx_stable_tx_xgmii_clk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_dl_reset_async_txclk (
        .clk            (i_tx_xgmii_clk),
        .reset_n        (tx_dl_rst_n),
        .din            (1'b1),
        .dout           (tx_dl_rst_n_tx_xgmii_clk)
    );
    
    
    // RX clock domain
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_digital_reset_async_rxclk (
        .clk            (i_rx_xgmii_clk),
        .reset_n        (i_rx_digital_rst_n),
        .din            (1'b1),
        .dout           (rx_rst_n_rx_xgmii_clk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_stable_async_rxclk (
        .clk            (i_rx_xgmii_clk),
        .reset_n        (i_rx_stable),
        .din            (1'b1),
        .dout           (rx_stable_rx_xgmii_clk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_dl_reset_async_rxclk (
        .clk            (i_rx_xgmii_clk),
        .reset_n        (rx_dl_rst_n),
        .din            (1'b1),
        .dout           (rx_dl_rst_n_rx_xgmii_clk)
    );
    
    
    assign gtx_rst_async_pulse_clk_async_tx_xgmii_clk = ~gtx_rst_n_async_pulse_clk_async_tx_xgmii_clk;
    
    assign sclk_tx_rst    = ~(global_rst_n_sclk & tx_rst_n_sclk & tx_stable_sclk & tx_dl_rst_n_sclk);
    assign sclk_rx_rst    = ~(global_rst_n_sclk & rx_rst_n_sclk & rx_stable_sclk & rx_dl_rst_n_sclk);
    assign txclk_tx_rst   = ~(i_global_rst_n_tx_xgmii_clk & tx_rst_n_tx_xgmii_clk & tx_stable_tx_xgmii_clk & tx_dl_rst_n_tx_xgmii_clk);
    assign rxclk_rx_rst   = ~(i_global_rst_n_rx_xgmii_clk & rx_rst_n_rx_xgmii_clk & rx_stable_rx_xgmii_clk & rx_dl_rst_n_rx_xgmii_clk);
    
    assign sclk_tx_rst_n  = ~sclk_tx_rst;
    assign sclk_rx_rst_n  = ~sclk_rx_rst;
    assign txclk_tx_rst_n = ~txclk_tx_rst;
    assign rxclk_rx_rst_n = ~rxclk_rx_rst;
    
    
    // Latency sampling clock domain Sync/Async reset
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_reset_sync_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (1'b1),
        .din            (sclk_tx_rst_n),
        .dout           (gtx_rst_n_sync_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_reset_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (sclk_tx_rst_n),
        .din            (1'b1),
        .dout           (gtx_rst_n_async_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_reset_sync_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (1'b1),
        .din            (sclk_rx_rst_n),
        .dout           (grx_rst_n_sync_sclk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_reset_async_sclk (
        .clk            (i_latency_sclk),
        .reset_n        (sclk_rx_rst_n),
        .din            (1'b1),
        .dout           (grx_rst_n_async_sclk)
    );
    
    
    // TX clock domain Sync/Async reset
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_reset_sync_txclk (
        .clk            (i_tx_xgmii_clk),
        .reset_n        (1'b1),
        .din            (txclk_tx_rst_n),
        .dout           (gtx_rst_n_sync_tx_xgmii_clk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__tx_reset_async_txclk (
        .clk            (i_tx_xgmii_clk),
        .reset_n        (txclk_tx_rst_n),
        .din            (1'b1),
        .dout           (gtx_rst_n_async_tx_xgmii_clk)
    );
    
    
    // RX clock domain Sync/Async reset
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_reset_sync_rxclk (
        .clk            (i_rx_xgmii_clk),
        .reset_n        (1'b1),
        .din            (rxclk_rx_rst_n),
        .dout           (grx_rst_n_sync_rx_xgmii_clk)
    );
    
    alt_mge_phy_std_synchronizer_nocut #(
        .depth          (2),
        .turn_off_meta  (0)
    ) __syncreset__rx_reset_async_rxclk (
        .clk            (i_rx_xgmii_clk),
        .reset_n        (rxclk_rx_rst_n),
        .din            (1'b1),
        .dout           (grx_rst_n_async_rx_xgmii_clk)
    );


    assign gtx_rst_sync_sclk   = ~gtx_rst_n_sync_sclk;
    assign grx_rst_sync_sclk   = ~grx_rst_n_sync_sclk;
    assign gtx_rst_async_sclk  = ~gtx_rst_n_async_sclk;
    assign grx_rst_async_sclk  = ~grx_rst_n_async_sclk;
    
    assign gtx_rst_sync_tx_xgmii_clk  = ~gtx_rst_n_sync_tx_xgmii_clk;
    assign grx_rst_sync_rx_xgmii_clk  = ~grx_rst_n_sync_rx_xgmii_clk;
    assign gtx_rst_async_tx_xgmii_clk = ~gtx_rst_n_async_tx_xgmii_clk;
    assign grx_rst_async_rx_xgmii_clk = ~grx_rst_n_async_rx_xgmii_clk;
    
    
    alt_mge_phy_f_ptp_latency_measure #(
        .DL_TOT_MEASURE_CNT         (128),
        .COUNT_WIDTH                (20)
    ) latency_measure_inst (
        .i_tx_reset_sync_sclk       (gtx_rst_sync_sclk),
        .i_rx_reset_sync_sclk       (grx_rst_sync_sclk),
        .i_tx_reset_async           (gtx_rst_async_sclk),
        .i_rx_reset_async           (grx_rst_async_sclk),
        
        .i_reset_sync_txclk         (gtx_rst_sync_tx_xgmii_clk),
        .i_reset_sync_rxclk         (grx_rst_sync_rx_xgmii_clk),
        .i_reset_async_txclk        (gtx_rst_async_tx_xgmii_clk),
        .i_reset_async_rxclk        (grx_rst_async_rx_xgmii_clk),
        
        .i_reset_async_pulse_clk    (gtx_rst_async_pulse_clk_async_tx_xgmii_clk),
        
        .i_tx_parallel_clk          (i_tx_xgmii_clk),
        .i_rx_parallel_clk          (i_rx_xgmii_clk),
        .i_smpl_clk                 (i_latency_sclk),
        
        .i_tx_dl_valid              (i_tx_dl_valid),
        .i_rx_sync_pulse            (i_rx_dl_sync_pulse),
        
        .i_tx_async_pulse           (i_tx_dl_async_pulse),
        .i_rx_async_pulse           (i_rx_dl_async_pulse),
        
        .o_tx_sync_pulse            (o_tx_dl_sync_pulse),
        .o_async_pulse              (o_dl_async_cal_pulse),
        
        .o_tx_measure_sel           (o_tx_dl_measure_sel),
        .o_rx_measure_sel           (o_rx_dl_measure_sel),
        
        .o_tx_delay_sclk            (o_tx_dl_latency),
        .o_rx_delay_sclk            (o_rx_dl_latency),
        
        .o_tx_measure_valid         (o_tx_measure_valid),
        .o_rx_measure_valid         (o_rx_measure_valid),
        .o_tx_sync_count            (o_tx_sync_count),
        .o_tx_async_count           (o_tx_async_count),
        .o_rx_sync_count            (o_rx_sync_count),
        .o_rx_async_count           (o_rx_async_count),
        
        .o_tx_sync_valid            (o_tx_sync_valid),
        .o_tx_async_valid           (o_tx_async_valid),
        .o_rx_sync_valid            (o_rx_sync_valid),
        .o_rx_async_valid           (o_rx_async_valid)
    );

endmodule
