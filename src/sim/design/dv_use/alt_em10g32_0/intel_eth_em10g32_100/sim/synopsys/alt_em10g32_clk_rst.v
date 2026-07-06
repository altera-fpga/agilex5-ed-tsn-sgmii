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
module alt_em10g32_clk_rst #(
    parameter DEPTH                       = 4,
    parameter INSERT_XGMII_ADAPTOR        = 1,
    parameter INSERT_ST_ADAPTOR           = 0,
    parameter USE_ASYNC_ADAPTOR           = 0,
    parameter ENABLE_TIMESTAMPING         = 0,
    parameter SYNC_RESET_N                = 1
) (   
    
    input wire  tx_clk,
    input wire  tx_rst_n,
    
    input wire  rx_clk,
    input wire  rx_rst_n,
    
    input wire  csr_clk,
    input wire  csr_rst_n,
    
    input wire  gmii_tx_clk,
    input wire  gmii_rx_clk,

    input wire  tx_156_25_clk,
    input wire  rx_156_25_clk,
    
    input wire  latency_measure_sampling_clk,
    
    output wire tx_clk_sync,
    output wire tx_rst_n_sync,
    
    output wire rx_clk_sync,
    output wire rx_rst_n_sync,
    
    output wire csr_clk_sync,
    output wire csr_rst_n_sync,
    
    output wire gmii_tx_clk_sync,
    output wire gmii_tx_rst_n_sync,
    
    output wire gmii_rx_clk_sync,
    output wire gmii_rx_rst_n_sync,

    output wire tx_156_25_clk_sync,
    output wire tx_156_25_rst_n_sync,
    output wire rx_156_25_clk_sync,
    output wire rx_156_25_rst_n_sync,
    
    output wire tx_sampling_rst_n_sync,
    output wire rx_sampling_rst_n_sync,
    
    // Reset for statistics in TX/RX clock domain
    output wire csr_rst_tx_clk_n,
    output wire csr_rst_rx_clk_n,
    
    // Reset for clock crosser
    output wire csr_tx_cc_in_rst_n,
    output wire csr_tx_cc_out_rst_n,
    output wire tx_csr_cc_in_rst_n,
    output wire tx_csr_cc_out_rst_n,
    
    output wire csr_gmii_tx_cc_in_rst_n,
    output wire csr_gmii_tx_cc_out_rst_n,
    output wire gmii_tx_csr_cc_in_rst_n,
    output wire gmii_tx_csr_cc_out_rst_n,
    
    output wire csr_rx_cc_in_rst_n,
    output wire csr_rx_cc_out_rst_n,
    output wire rx_csr_cc_in_rst_n,
    output wire rx_csr_cc_out_rst_n,
    
    output wire csr_gmii_rx_cc_in_rst_n,
    output wire csr_gmii_rx_cc_out_rst_n,
    output wire gmii_rx_csr_cc_in_rst_n,
    output wire gmii_rx_csr_cc_out_rst_n,
    
    output wire tx_rx_cc_in_rst_n,
    output wire tx_rx_cc_out_rst_n,
    output wire rx_tx_cc_in_rst_n,
    output wire rx_tx_cc_out_rst_n
    
);
    wire    tx_rst;
    wire    rx_rst;
    wire    csr_rst;
    wire    csr_rst_sync;
    wire    gmii_tx_rst_sync;
    wire    gmii_rx_rst_sync;
    
    wire    csr_rst_tx_clk;
    wire    csr_rst_rx_clk;
    
    wire    tx_156_25_rst_sync;
    wire    rx_156_25_rst_sync;
    
    wire    tx_sampling_rst_sync;
    wire    rx_sampling_rst_sync;
    
    wire    csr_tx_cc_out_int_rst_n;
    reg     csr_tx_cc_out_int_rst_n_reg1;
    reg     csr_tx_cc_out_int_rst_n_reg2;
    
    wire    tx_csr_cc_out_int_rst_n;
    reg     tx_csr_cc_out_int_rst_n_reg1;
    reg     tx_csr_cc_out_int_rst_n_reg2;
    
    wire    csr_gmii_tx_cc_out_int_rst_n;
    reg     csr_gmii_tx_cc_out_int_rst_n_reg1;
    reg     csr_gmii_tx_cc_out_int_rst_n_reg2;
    
    wire    gmii_tx_csr_cc_out_int_rst_n;
    reg     gmii_tx_csr_cc_out_int_rst_n_reg1;
    reg     gmii_tx_csr_cc_out_int_rst_n_reg2;
    
    wire    csr_rx_cc_out_int_rst_n;
    reg     csr_rx_cc_out_int_rst_n_reg1;
    reg     csr_rx_cc_out_int_rst_n_reg2;
    
    wire    rx_csr_cc_out_int_rst_n;
    reg     rx_csr_cc_out_int_rst_n_reg1;
    reg     rx_csr_cc_out_int_rst_n_reg2;
    
    wire    csr_gmii_rx_cc_out_int_rst_n;
    reg     csr_gmii_rx_cc_out_int_rst_n_reg1;
    reg     csr_gmii_rx_cc_out_int_rst_n_reg2;
    
    wire    gmii_rx_csr_cc_out_int_rst_n;
    reg     gmii_rx_csr_cc_out_int_rst_n_reg1;
    reg     gmii_rx_csr_cc_out_int_rst_n_reg2;
    
    wire    tx_rx_cc_out_int_rst_n;
    reg     tx_rx_cc_out_int_rst_n_reg1;
    reg     tx_rx_cc_out_int_rst_n_reg2;
    
    wire    rx_tx_cc_out_int_rst_n;
    reg     rx_tx_cc_out_int_rst_n_reg1;
    reg     rx_tx_cc_out_int_rst_n_reg2;
    
    assign tx_rst   = ~tx_rst_n_sync;
    assign rx_rst   = ~rx_rst_n_sync;
    assign csr_rst  = ~csr_rst_n;

    assign csr_rst_n_sync   = ~csr_rst_sync;
    
    assign gmii_tx_rst_n_sync   = ~gmii_tx_rst_sync;
    assign gmii_rx_rst_n_sync   = ~gmii_rx_rst_sync;
    
    assign tx_156_25_rst_n_sync = ~tx_156_25_rst_sync;
    assign rx_156_25_rst_n_sync = ~rx_156_25_rst_sync;
    
    assign tx_sampling_rst_n_sync = ~tx_sampling_rst_sync;
    assign rx_sampling_rst_n_sync = ~rx_sampling_rst_sync;
    
    assign tx_clk_sync  = tx_clk;
    assign rx_clk_sync  = rx_clk;
    assign csr_clk_sync = csr_clk;
    
    assign gmii_tx_clk_sync = gmii_tx_clk;
    assign gmii_rx_clk_sync = gmii_rx_clk;
    
    assign csr_rst_tx_clk_n = ~csr_rst_tx_clk;
    assign csr_rst_rx_clk_n = ~csr_rst_rx_clk;

    assign tx_156_25_clk_sync = tx_156_25_clk;
    assign rx_156_25_clk_sync = rx_156_25_clk;

    alt_em10g32_rst_cnt # (
       .RESET_SYNC_DEPTH    (DEPTH),
       .RESET_COUNT         (32),
       .SYNC_RESET_N        (SYNC_RESET_N)
    ) tx_reset_count_inst (
        .clk (tx_clk),
        .rst_n_in (tx_rst_n),
        .rst_n_out (tx_rst_n_sync)
    );

    alt_em10g32_rst_cnt # (
       .RESET_SYNC_DEPTH    (DEPTH),
       .RESET_COUNT         (32),
       .SYNC_RESET_N        (SYNC_RESET_N)
    ) rx_reset_count_inst (
        .clk (rx_clk),
        .rst_n_in (rx_rst_n),
        .rst_n_out (rx_rst_n_sync)
    );
    
    alt_em10g32_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (DEPTH)  
    ) csr_reset_synchronizer_inst(
        .clk(csr_clk),
        .reset_in(csr_rst),
        .reset_out(csr_rst_sync)
    );
    
    alt_em10g32_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (2) // Fixed to 2 to ensure GMII logic is released before packet reach 10G-1G clock crosser
    ) gmii_tx_reset_synchronizer_inst(
        .clk(gmii_tx_clk),
        .reset_in(tx_rst),
        .reset_out(gmii_tx_rst_sync)
    );

    alt_em10g32_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (2) 
    ) gmii_rx_reset_synchronizer_inst(
        .clk(gmii_rx_clk),
        .reset_in(rx_rst),
        .reset_out(gmii_rx_rst_sync)
    );
    
    // Reset for statistics in TX/RX clock domain
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(1),
        .DEPTH      (DEPTH)  
    ) csr_rst_tx_clk_reset_sync (
        .clk        (tx_clk),
        .reset_in   (csr_rst),
        .reset_out  (csr_rst_tx_clk)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(1),
        .DEPTH      (DEPTH)  
    ) csr_rst_rx_clk_reset_sync (
        .clk        (rx_clk),
        .reset_in   (csr_rst),
        .reset_out  (csr_rst_rx_clk)
    );
    
    // Reset for clock crosser
    // CSR Clock to TX Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) csr_tx_cc_in_reset_sync (
        .clk        (csr_clk),
        .reset_in   (csr_tx_cc_out_rst_n),
        .reset_out  (csr_tx_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) csr_tx_cc_out_reset_sync (
        .clk        (tx_clk),
        .reset_in   (csr_rst_n & tx_rst_n_sync),
        .reset_out  (csr_tx_cc_out_int_rst_n)
    );
    
    always @(posedge tx_clk) begin
        csr_tx_cc_out_int_rst_n_reg1 <= csr_tx_cc_out_int_rst_n;
        csr_tx_cc_out_int_rst_n_reg2 <= csr_tx_cc_out_int_rst_n_reg1;
    end
    
    assign csr_tx_cc_out_rst_n = csr_tx_cc_out_int_rst_n_reg2;
    
    // TX Clock to CSR Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) tx_csr_cc_in_reset_sync (
        .clk        (tx_clk),
        .reset_in   (tx_csr_cc_out_rst_n),
        .reset_out  (tx_csr_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) tx_csr_cc_out_reset_sync (
        .clk        (csr_clk),
        .reset_in   (csr_rst_n & tx_rst_n_sync),
        .reset_out  (tx_csr_cc_out_int_rst_n)
    );
    
    always @(posedge csr_clk) begin
        tx_csr_cc_out_int_rst_n_reg1 <= tx_csr_cc_out_int_rst_n;
        tx_csr_cc_out_int_rst_n_reg2 <= tx_csr_cc_out_int_rst_n_reg1;
    end
    
    assign tx_csr_cc_out_rst_n = tx_csr_cc_out_int_rst_n_reg2;
    
    
    // CSR Clock to GMII TX Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) csr_gmii_tx_cc_in_reset_sync (
        .clk        (csr_clk),
        .reset_in   (csr_gmii_tx_cc_out_rst_n),
        .reset_out  (csr_gmii_tx_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) csr_gmii_tx_cc_out_reset_sync (
        .clk        (gmii_tx_clk),
        .reset_in   (csr_rst_n & tx_rst_n_sync),
        .reset_out  (csr_gmii_tx_cc_out_int_rst_n)
    );
    
    always @(posedge gmii_tx_clk) begin
        csr_gmii_tx_cc_out_int_rst_n_reg1 <= csr_gmii_tx_cc_out_int_rst_n;
        csr_gmii_tx_cc_out_int_rst_n_reg2 <= csr_gmii_tx_cc_out_int_rst_n_reg1;
    end
    
    assign csr_gmii_tx_cc_out_rst_n = csr_gmii_tx_cc_out_int_rst_n_reg2;

    
    
    // GMII TX Clock to CSR Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) gmii_tx_csr_cc_in_reset_sync (
        .clk        (gmii_tx_clk),
        .reset_in   (gmii_tx_csr_cc_out_rst_n),
        .reset_out  (gmii_tx_csr_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) gmii_tx_csr_cc_out_reset_sync (
        .clk        (csr_clk),
        .reset_in   (csr_rst_n & tx_rst_n_sync),
        .reset_out  (gmii_tx_csr_cc_out_int_rst_n)
    );
    
    always @(posedge csr_clk) begin
        gmii_tx_csr_cc_out_int_rst_n_reg1 <= gmii_tx_csr_cc_out_int_rst_n;
        gmii_tx_csr_cc_out_int_rst_n_reg2 <= gmii_tx_csr_cc_out_int_rst_n_reg1;
    end
    
    assign gmii_tx_csr_cc_out_rst_n = gmii_tx_csr_cc_out_int_rst_n_reg2;
    
    // CSR Clock to RX Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) csr_rx_cc_in_reset_sync (
        .clk        (csr_clk),
        .reset_in   (csr_rx_cc_out_rst_n),
        .reset_out  (csr_rx_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) csr_rx_cc_out_reset_sync (
        .clk        (rx_clk),
        .reset_in   (csr_rst_n & rx_rst_n_sync),
        .reset_out  (csr_rx_cc_out_int_rst_n)
    );
    
    always @(posedge rx_clk) begin
        csr_rx_cc_out_int_rst_n_reg1 <= csr_rx_cc_out_int_rst_n;
        csr_rx_cc_out_int_rst_n_reg2 <= csr_rx_cc_out_int_rst_n_reg1;
    end
    
    assign csr_rx_cc_out_rst_n = csr_rx_cc_out_int_rst_n_reg2;
    
    // RX Clock to CSR Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) rx_csr_cc_in_reset_sync (
        .clk        (rx_clk),
        .reset_in   (rx_csr_cc_out_rst_n),
        .reset_out  (rx_csr_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) rx_csr_cc_out_reset_sync (
        .clk        (csr_clk),
        .reset_in   (csr_rst_n & rx_rst_n_sync),
        .reset_out  (rx_csr_cc_out_int_rst_n)
    );
    
    always @(posedge csr_clk) begin
        rx_csr_cc_out_int_rst_n_reg1 <= rx_csr_cc_out_int_rst_n;
        rx_csr_cc_out_int_rst_n_reg2 <= rx_csr_cc_out_int_rst_n_reg1;
    end
    
    assign rx_csr_cc_out_rst_n = rx_csr_cc_out_int_rst_n_reg2;
    
    // CSR Clock to GMII RX Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) csr_gmii_rx_cc_in_reset_sync (
        .clk        (csr_clk),
        .reset_in   (csr_gmii_rx_cc_out_rst_n),
        .reset_out  (csr_gmii_rx_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) csr_gmii_rx_cc_out_reset_sync (
        .clk        (gmii_rx_clk),
        .reset_in   (csr_rst_n & rx_rst_n_sync),
        .reset_out  (csr_gmii_rx_cc_out_int_rst_n)
    );
    
    always @(posedge gmii_rx_clk) begin
        csr_gmii_rx_cc_out_int_rst_n_reg1 <= csr_gmii_rx_cc_out_int_rst_n;
        csr_gmii_rx_cc_out_int_rst_n_reg2 <= csr_gmii_rx_cc_out_int_rst_n_reg1;
    end
    
    assign csr_gmii_rx_cc_out_rst_n = csr_gmii_rx_cc_out_int_rst_n_reg2;
    
    // GMII RX Clock to CSR Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) gmii_rx_csr_cc_in_reset_sync (
        .clk        (gmii_rx_clk),
        .reset_in   (gmii_rx_csr_cc_out_rst_n),
        .reset_out  (gmii_rx_csr_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) gmii_rx_csr_cc_out_reset_sync (
        .clk        (csr_clk),
        .reset_in   (csr_rst_n & rx_rst_n_sync),
        .reset_out  (gmii_rx_csr_cc_out_int_rst_n)
    );
    
    always @(posedge csr_clk) begin
        gmii_rx_csr_cc_out_int_rst_n_reg1 <= gmii_rx_csr_cc_out_int_rst_n;
        gmii_rx_csr_cc_out_int_rst_n_reg2 <= gmii_rx_csr_cc_out_int_rst_n_reg1;
    end
    
    assign gmii_rx_csr_cc_out_rst_n = gmii_rx_csr_cc_out_int_rst_n_reg2;
    
    // TX Clock to RX Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) tx_rx_cc_in_reset_sync (
        .clk        (tx_clk),
        .reset_in   (tx_rx_cc_out_rst_n),
        .reset_out  (tx_rx_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) tx_rx_cc_out_reset_sync (
        .clk        (rx_clk),
        .reset_in   (tx_rst_n_sync & rx_rst_n_sync),
        .reset_out  (tx_rx_cc_out_int_rst_n)
    );
    
    always @(posedge rx_clk) begin
        tx_rx_cc_out_int_rst_n_reg1 <= tx_rx_cc_out_int_rst_n;
        tx_rx_cc_out_int_rst_n_reg2 <= tx_rx_cc_out_int_rst_n_reg1;
    end
    
    assign tx_rx_cc_out_rst_n = tx_rx_cc_out_int_rst_n_reg2;
    
    // RX Clock to TX Clock
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) rx_tx_cc_in_reset_sync (
        .clk        (rx_clk),
        .reset_in   (rx_tx_cc_out_rst_n),
        .reset_out  (rx_tx_cc_in_rst_n)
    );
    
    alt_em10g32_reset_synchronizer #(
        .ASYNC_RESET(0),
        .DEPTH      (DEPTH)  
    ) rx_tx_cc_out_reset_sync (
        .clk        (tx_clk),
        .reset_in   (tx_rst_n_sync & rx_rst_n_sync),
        .reset_out  (rx_tx_cc_out_int_rst_n)
    );
    always @(posedge tx_clk) begin
        rx_tx_cc_out_int_rst_n_reg1 <= rx_tx_cc_out_int_rst_n;
        rx_tx_cc_out_int_rst_n_reg2 <= rx_tx_cc_out_int_rst_n_reg1;
    end
    
    assign rx_tx_cc_out_rst_n = rx_tx_cc_out_int_rst_n_reg2;

   //------------------------------------------------------------------------
   // XGMII adaptor reset synchronizer
   //------------------------------------------------------------------------
    generate
    if (INSERT_XGMII_ADAPTOR || INSERT_ST_ADAPTOR) begin : tx_156_25_rst_sync_block
        alt_em10g32_reset_synchronizer # (
            .ASYNC_RESET(1),
            .DEPTH      (DEPTH)  
        ) tx_156_25_reset_synchronizer_inst(
            .clk        (tx_156_25_clk),
            .reset_in   (tx_rst),
            .reset_out  (tx_156_25_rst_sync)
        );
    end
    else begin
       assign tx_156_25_rst_sync = 1'b1;
    end
    endgenerate
   
   //------------------------------------------------------------------------
   // ST adaptor reset synchronizer
   //------------------------------------------------------------------------
    generate 
    if (INSERT_XGMII_ADAPTOR || INSERT_ST_ADAPTOR) begin : rx_156_25_rst_sync_block
        alt_em10g32_reset_synchronizer # (
            .ASYNC_RESET(1),
            .DEPTH      (DEPTH)  
        ) rx_156_25_reset_synchronizer_inst(
            .clk        (rx_156_25_clk),
            .reset_in   (rx_rst),
            .reset_out  (rx_156_25_rst_sync)
        );
    end
    else begin
       assign rx_156_25_rst_sync = 1'b1;
    end
    endgenerate
    
    //------------------------------------------------------------------------
    // XGMII adaptor sampling clock reset synchronizer
    //------------------------------------------------------------------------
    generate
    if (INSERT_XGMII_ADAPTOR && USE_ASYNC_ADAPTOR && ENABLE_TIMESTAMPING) begin : tx_sampling_rst_sync_block
        alt_em10g32_reset_synchronizer # (
            .ASYNC_RESET(1),
            .DEPTH      (DEPTH)  
        ) tx_sampling_reset_synchronizer_inst(
            .clk        (latency_measure_sampling_clk),
            .reset_in   (tx_rst),
            .reset_out  (tx_sampling_rst_sync)
        );
    end
    else begin
       assign tx_sampling_rst_sync = 1'b1;
    end
    endgenerate
    
    generate
    if (INSERT_XGMII_ADAPTOR && USE_ASYNC_ADAPTOR && ENABLE_TIMESTAMPING) begin : rx_sampling_rst_sync_block
        alt_em10g32_reset_synchronizer # (
            .ASYNC_RESET(1),
            .DEPTH      (DEPTH)  
        ) rx_sampling_reset_synchronizer_inst(
            .clk        (latency_measure_sampling_clk),
            .reset_in   (rx_rst),
            .reset_out  (rx_sampling_rst_sync)
        );
    end
    else begin
       assign rx_sampling_rst_sync = 1'b1;
    end
    endgenerate

endmodule


