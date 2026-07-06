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

module alt_mge_phy_usxg32_tx_top #(
    parameter XGMII_32_DWIDTH   = 32,
    parameter XGMII_32_CWIDTH   = 4,
    parameter XGMII_64_DWIDTH   = 64,
    // ED
    //parameter TX_DWIDTH         = 64,
    //parameter TX_CWIDTH         = 8,
    parameter DEVICE_FAMILY     = "Arria V",
    parameter ENABLE_IEEE1588   = 0,
    parameter FAWIDTH           = 5,
    parameter TSWIDTH           = 16,
    parameter IDWIDTH           = 40,
    parameter TX_OFFSET         = 16'h29D6,
    parameter XGMII_64_CWIDTH   = 8
) (
    input  wire                         tx_xgmii_clk,
    input  wire                         tx_pma_clk,
    
    input  wire                         tx_xgmii_rst_n,
    input  wire                         tx_pma_rst_n,
    
    input  wire                         tx_xgmii_32_valid_in,
    input  wire [XGMII_32_CWIDTH-1:0]   tx_xgmii_32_control_in,
    input  wire [XGMII_32_DWIDTH-1:0]   tx_xgmii_32_data_in,
    
    input  wire                         tx_xgmii_32_an_valid_in,
    input  wire [XGMII_32_CWIDTH-1:0]   tx_xgmii_32_an_control_in,
    input  wire [XGMII_32_DWIDTH-1:0]   tx_xgmii_32_an_data_in,
    
    input  wire                         tx_xgmii_32_lf_valid_in,
    input  wire [XGMII_32_CWIDTH-1:0]   tx_xgmii_32_lf_control_in,
    input  wire [XGMII_32_DWIDTH-1:0]   tx_xgmii_32_lf_data_in,
    // ED
    input  wire                         tx_reset_latency_sclk,
    output wire [TSWIDTH-1:0]           tx_latency_adj,
    input  wire                         latency_sclk,
	input  wire [11:0]                  latency_xcvr_tx,
    output wire                         tx_xgmii_64_valid_out,
    output wire [XGMII_64_CWIDTH-1:0]   tx_xgmii_64_control_out,
    output wire [XGMII_64_DWIDTH-1:0]   tx_xgmii_64_data_out,
    
    // Deterministic Latency for Agilex USXGMII with 1588
    input  wire                         tx_xgmii_dl_sync_pulse_in,
    output wire                         tx_xgmii_dl_sync_pulse_out,
    output wire                         tx_xgmii_dl_valid
);

    wire                        tx_xgmii_32_mac2drep_valid;
    wire [XGMII_32_CWIDTH-1:0]  tx_xgmii_32_mac2drep_control;
    wire [XGMII_32_DWIDTH-1:0]  tx_xgmii_32_mac2drep_data;

    wire                        tx_xgmii_32_drep2dmux_valid;
    wire [XGMII_32_CWIDTH-1:0]  tx_xgmii_32_drep2dmux_control;
    wire [XGMII_32_DWIDTH-1:0]  tx_xgmii_32_drep2dmux_data;

    wire                        tx_xgmii_32_an2dmux_valid;
    wire [XGMII_32_CWIDTH-1:0]  tx_xgmii_32_an2dmux_control;
    wire [XGMII_32_DWIDTH-1:0]  tx_xgmii_32_an2dmux_data;

    wire                        tx_xgmii_32_dmux2wadpt_valid;
    wire [XGMII_32_CWIDTH-1:0]  tx_xgmii_32_dmux2wadpt_control;
    wire [XGMII_32_DWIDTH-1:0]  tx_xgmii_32_dmux2wadpt_data;

    wire                        tx_xgmii_64_wadpt2ff_valid;
    wire [XGMII_64_CWIDTH-1:0]  tx_xgmii_64_wadpt2ff_control;
    wire [XGMII_64_DWIDTH-1:0]  tx_xgmii_64_wadpt2ff_data;

    wire                        tx_xgmii_64_ff2xcvr_valid;
    wire [XGMII_64_CWIDTH-1:0]  tx_xgmii_64_ff2xcvr_control;
    wire [XGMII_64_DWIDTH-1:0]  tx_xgmii_64_ff2xcvr_data;

    assign tx_xgmii_32_mac2drep_valid   = tx_xgmii_32_valid_in;
    assign tx_xgmii_32_mac2drep_control = tx_xgmii_32_control_in;
    assign tx_xgmii_32_mac2drep_data    = tx_xgmii_32_data_in;

    alt_mge_phy_usxg32_tx_data_rep data_rep (
        .clk_312_5              (tx_xgmii_clk),
        .reset_312_5_n          (tx_xgmii_rst_n),
        
        .tx_xgmii_valid_in      (tx_xgmii_32_mac2drep_valid),
        .tx_xgmii_control_in    (tx_xgmii_32_mac2drep_control),
        .tx_xgmii_data_in       (tx_xgmii_32_mac2drep_data),
        
        .tx_xgmii_valid_out     (tx_xgmii_32_drep2dmux_valid),
        .tx_xgmii_control_out   (tx_xgmii_32_drep2dmux_control),
        .tx_xgmii_data_out      (tx_xgmii_32_drep2dmux_data)
    );

    alt_mge_phy_usxg32_tx_data_mux data_mux (
        .clk_312_5                      (tx_xgmii_clk),
        .reset_312_5_n                  (tx_xgmii_rst_n),
        
        .tx_xgmii_rep_valid_in          (tx_xgmii_32_drep2dmux_valid),
        .tx_xgmii_rep_control_in        (tx_xgmii_32_drep2dmux_control),
        .tx_xgmii_rep_data_in           (tx_xgmii_32_drep2dmux_data),
        
        .tx_xgmii_auto_neg_valid_in     (tx_xgmii_32_an_valid_in),
        .tx_xgmii_auto_neg_control_in   (tx_xgmii_32_an_control_in),
        .tx_xgmii_auto_neg_data_in      (tx_xgmii_32_an_data_in),
        
        .tx_xgmii_umii_fault_valid_in   (tx_xgmii_32_lf_valid_in),
        .tx_xgmii_umii_fault_control_in (tx_xgmii_32_lf_control_in),
        .tx_xgmii_umii_fault_data_in    (tx_xgmii_32_lf_data_in),
        
        .tx_xgmii_mux_valid_out         (tx_xgmii_32_dmux2wadpt_valid),
        .tx_xgmii_mux_control_out       (tx_xgmii_32_dmux2wadpt_control),
        .tx_xgmii_mux_data_out          (tx_xgmii_32_dmux2wadpt_data)
    );

    alt_mge_phy_usxg32_tx_32_to_64_wadpt width_adpt_32_to_64 (
        .clk_312_5              (tx_xgmii_clk),
        .reset_312_5_n          (tx_xgmii_rst_n),
        
        .tx_xgmii_valid_in      (tx_xgmii_32_dmux2wadpt_valid),
        .tx_xgmii_control_in    (tx_xgmii_32_dmux2wadpt_control),
        .tx_xgmii_data_in       (tx_xgmii_32_dmux2wadpt_data),
        
        .tx_xgmii_valid_out     (tx_xgmii_64_wadpt2ff_valid),
        .tx_xgmii_control_out   (tx_xgmii_64_wadpt2ff_control),
        .tx_xgmii_data_out      (tx_xgmii_64_wadpt2ff_data)
    );
    
    assign tx_xgmii_dl_valid = tx_xgmii_64_wadpt2ff_valid;
    
    wire wire_tx_xgmii_dl_sync_pulse_in;
    wire wire_tx_xgmii_dl_sync_pulse_out;
    
    // Agilex USXGMII 1588 sync pulse to TX clock compensation FIFO. Set to "0" for other variants to avoid impacting FIFO's performance
    assign wire_tx_xgmii_dl_sync_pulse_in  = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? tx_xgmii_dl_sync_pulse_in       : 1'b0;
    assign tx_xgmii_dl_sync_pulse_out      = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? wire_tx_xgmii_dl_sync_pulse_out : 1'b0;

    alt_mge_phy_usxg32_tx_clockcomp_fifo #(
        .TX_DWIDTH              (XGMII_64_DWIDTH),      // FIFO Data input width  
        .TX_CWIDTH              (XGMII_64_CWIDTH),
        .FAWIDTH                (FAWIDTH),
        //.ISWIDTH                (7),                    // RX Gearbox Selector width
        .TSWIDTH                (TSWIDTH),
        .IDWIDTH                (IDWIDTH),              // PCS/PMA IF width
        .OFFSET                 (TX_OFFSET),            // PCS latency //32.508Clock - 13.148Clock =19.36Clocks
        .DEVICE_FAMILY          (DEVICE_FAMILY),
        .ENABLE_IEEE1588        (ENABLE_IEEE1588)
    ) tx_fifo (
        .tx_xgmii_clk           (tx_xgmii_clk),
        .tx_pma_clk             (tx_pma_clk),
        
        .tx_xgmii_rst_n         (tx_xgmii_rst_n),
        .tx_pma_rst_n           (tx_pma_rst_n),
        
        .tx_xgmii_valid_in      (tx_xgmii_64_wadpt2ff_valid),
        .tx_xgmii_control_in    (tx_xgmii_64_wadpt2ff_control),
        .tx_xgmii_data_in       (tx_xgmii_64_wadpt2ff_data),
        
        .tx_xgmii_valid_out     (tx_xgmii_64_ff2xcvr_valid),
        .tx_xgmii_control_out   (tx_xgmii_64_ff2xcvr_control),
        .tx_xgmii_data_out      (tx_xgmii_64_ff2xcvr_data),
        // ED
        .latency_sclk_reset     (tx_reset_latency_sclk),
        .tx_latency_adj         (tx_latency_adj),       // Latency adjustment for timestamping
        .latency_sclk           (latency_sclk),
        .latency_xcvr_tx        (latency_xcvr_tx),
        
        .tx_xgmii_dl_sync_pulse_in  (wire_tx_xgmii_dl_sync_pulse_in),
        .tx_xgmii_dl_sync_pulse_out (wire_tx_xgmii_dl_sync_pulse_out)
    );

    assign tx_xgmii_64_valid_out   = tx_xgmii_64_ff2xcvr_valid;
    assign tx_xgmii_64_control_out = tx_xgmii_64_ff2xcvr_control;
    assign tx_xgmii_64_data_out    = tx_xgmii_64_ff2xcvr_data;

endmodule
