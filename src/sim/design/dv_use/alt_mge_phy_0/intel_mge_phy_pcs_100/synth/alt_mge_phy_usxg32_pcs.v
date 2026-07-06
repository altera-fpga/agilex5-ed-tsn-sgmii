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

module alt_mge_phy_usxg32_pcs #(
    parameter SYNCHRONIZER_DEPTH    = 3,
    parameter PMA_MODE              = 32,
    parameter TSWIDTH               = 24,
    parameter XGMII_32_DWIDTH       = 32,
    parameter XGMII_32_CWIDTH       = 4,
    parameter XGMII_64_DWIDTH       = 64,
    parameter DEVICE_FAMILY         = "Arria V",
    parameter ENABLE_IEEE1588       = 0,
    parameter XGMII_64_CWIDTH       = 8,
    parameter ENABLE_UMII_FAULT     = 0,
    parameter ENABLE_USXGMII_AN_RESP_MODE   = 0
) (
    // Clock
    input  wire                         csr_clk,
    
    input  wire                         tx_xgmii_clk,
    input  wire                         tx_pma_clk,
    
    input  wire                         rx_xgmii_clk,
    input  wire                         rx_pma_clk,
    input  wire                         rx_rec_div33_clk,
    input  wire                         rx_fm_ff_sample_clk,
    
    // Reset
    input  wire                         tx_digital_rst_n,
    input  wire                         rx_digital_rst_n,
    
    input  wire                         global_rst_n,
    
    input  wire                         global_rst_n__csr_clk,
    input  wire                         global_rst_n__sclk,
    input  wire                         global_rst_n__tx_xgmii_clk,
    input  wire                         global_rst_n__rx_xgmii_clk,
    input  wire                         global_rst_n__rx_rec_div33_clk,
    
    input  wire                         gtx_rst_n__csr_clk,
    input  wire                         gtx_rst_n__tx_xgmii_clk,
    input  wire                         gtx_rst_n__tx_pma_clk,
    
    input  wire                         grx_rst_n__csr_clk,
    input  wire                         grx_rst_n__rx_xgmii_clk,
    input  wire                         grx_rst_n__rx_pma_clk,
    input  wire                         grx_rst_n__rx_rec_div33_clk,
    input  wire                         grx_rst_n__rx_fm_ff_sample_clk,
    
    // 1588 latency
    input  wire                         tx_reset_latency_sclk,
    output wire         [TSWIDTH-1:0]   tx_latency_adj,
    input  wire                         latency_sclk,    
    input  wire                [11:0]   latency_xcvr_tx,    
    input  wire                         rx_reset_latency_sclk,
    output wire         [TSWIDTH-1:0]   rx_latency_adj,   
    input  wire                [11:0]   latency_xcvr_rx,       
    // CSR
    input  wire                 [5:0]   csr_address,
    input  wire                         csr_read,
    input  wire                         csr_write,
    input  wire                [31:0]   csr_writedata,
    output wire                [31:0]   csr_readdata,
    output wire                         csr_waitrequest,
    
    // TX
    input  wire                         tx_xgmii_32_valid_in,
    input  wire [XGMII_32_CWIDTH-1:0]   tx_xgmii_32_control_in,
    input  wire [XGMII_32_DWIDTH-1:0]   tx_xgmii_32_data_in,
    
    output wire                         tx_xgmii_64_valid_out,
    output wire [XGMII_64_CWIDTH-1:0]   tx_xgmii_64_control_out,
    output wire [XGMII_64_DWIDTH-1:0]   tx_xgmii_64_data_out,
    
    // RX
    input  wire                         rx_xgmii_64_valid_in,
    input  wire [XGMII_64_CWIDTH-1:0]   rx_xgmii_64_control_in,
    input  wire [XGMII_64_DWIDTH-1:0]   rx_xgmii_64_data_in,
    
    output wire                         rx_xgmii_32_valid_out,
    output wire [XGMII_32_CWIDTH-1:0]   rx_xgmii_32_control_out,
    output wire [XGMII_32_DWIDTH-1:0]   rx_xgmii_32_data_out,
    
    input  wire                         rx_block_lock_in,
    output wire                         rx_block_lock_out,
    
    // Status
    output wire                         led_an,
    output wire                 [1:0]   rx_umii_fault_status,
    
    // Operating Speed
    output reg                  [2:0]   operating_speed,
    
    // Agilex USXGMII 1588
    output wire                         tx_xgmii_dl_sync_pulse_out,
    input  wire                         rx_xgmii_dl_sync_pulse_in,
    
    input  wire                         tx_dl_async_pulse,
    input  wire                         rx_dl_async_pulse,
    output wire                         tx_dl_measure_sel,
    output wire                         rx_dl_measure_sel,
    
    output wire                         dl_async_cal_pulse,
    
    input  wire                         tx_stable,
    input  wire                         rx_stable
);

    // CSR
    wire        csr_usxgmii_en;
    wire        csr_usxgmii_an_en;
    wire [ 2:0] csr_usxgmii_speed;
    wire        csr_usxgmii_an_restart;
    wire        csr_usxgmii_an_restart_clr;
    wire        csr_usxgmii_an_resp_mode;
    wire        status_usxgmii_an_complete;
    wire [ 2:0] csr_dev_ability_speed;
    wire        csr_dev_ability_duplex;
    wire        status_dev_ability_ack;
    wire [15:0] status_partner_ability;
    wire [19:0] csr_usxgmii_an_link_timer;
    wire        csr_umii_fault;

    reg         link_status_reg;

    wire        csr_usxgmii_en__rx_pma_clk;
    wire        csr_usxgmii_an_en__rx_pma_clk;
    wire        csr_usxgmii_an_restart__rx_pma_clk;
    wire        csr_usxgmii_an_resp_mode__rx_pma_clk;

    wire        tx_dl_reset;
    wire        rx_dl_reset;
    wire        tx_measure_valid;
    wire        rx_measure_valid;
    wire        tx_sync_valid;
    wire        tx_async_valid;
    wire        rx_sync_valid;
    wire        rx_async_valid;
    wire [19:0] tx_sync_count;
    wire [19:0] tx_async_count;
    wire [19:0] rx_sync_count;
    wire [19:0] rx_async_count;
    wire [20:0] tx_dl_latency;
    wire [20:0] rx_dl_latency;
    
    wire [TSWIDTH-1:0] tx_latency_adj_fifo;
    
    // AN & UMII Fault Handling
    wire                         rx_xgmii_32_ext_valid;
    wire [XGMII_32_CWIDTH-1:0]   rx_xgmii_32_ext_control;
    wire [XGMII_32_DWIDTH-1:0]   rx_xgmii_32_ext_data;

    wire                         tx_xgmii_32_an_valid;
    wire [XGMII_32_CWIDTH-1:0]   tx_xgmii_32_an_control;
    wire [XGMII_32_DWIDTH-1:0]   tx_xgmii_32_an_data;

    wire                         tx_xgmii_32_lf_valid;
    wire [XGMII_32_CWIDTH-1:0]   tx_xgmii_32_lf_control;
    wire [XGMII_32_DWIDTH-1:0]   tx_xgmii_32_lf_data;

    wire        w_tx_xgmii_32_lf_valid_in;
    wire        w_csr_usxgmii_an_resp_mode;
    
    wire        tx_dl_sync_pulse;
    wire        tx_xgmii_dl_valid;
    wire        rx_xgmii_dl_sync_pulse_out;
    
    wire        wire_tx_dl_reset;
    wire        wire_rx_dl_reset;
    wire        wire_tx_measure_valid;
    wire        wire_rx_measure_valid;
    wire [20:0] wire_tx_dl_latency;
    wire [20:0] wire_rx_dl_latency;
    wire        wire_tx_sync_valid;
    wire        wire_tx_async_valid;
    wire        wire_rx_sync_valid;
    wire        wire_rx_async_valid;
    wire [19:0] wire_tx_sync_count;
    wire [19:0] wire_tx_async_count;
    wire [19:0] wire_rx_sync_count;
    wire [19:0] wire_rx_async_count;
    

    reg         grx_rst_n__rx_pma_clk_sync0;
    always @ (posedge rx_pma_clk) begin
        grx_rst_n__rx_pma_clk_sync0 <= grx_rst_n__rx_pma_clk;
    end


    assign tx_dl_reset           = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? wire_tx_dl_reset : 1'b0;
    assign rx_dl_reset           = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? wire_rx_dl_reset : 1'b0;
    
    assign wire_tx_measure_valid = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? tx_measure_valid : 1'b0;
    assign wire_rx_measure_valid = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_measure_valid : 1'b0;
    assign wire_tx_dl_latency    = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? tx_dl_latency    : {21{1'b0}};
    assign wire_rx_dl_latency    = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_dl_latency    : {21{1'b0}};
    assign wire_tx_sync_valid    = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? tx_sync_valid    : 1'b0;
    assign wire_tx_async_valid   = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? tx_async_valid   : 1'b0;
    assign wire_rx_sync_valid    = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_sync_valid    : 1'b0;
    assign wire_rx_async_valid   = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_async_valid   : 1'b0;
    assign wire_tx_sync_count    = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? tx_sync_count    : {20{1'b0}};
    assign wire_tx_async_count   = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? tx_async_count   : {20{1'b0}};
    assign wire_rx_sync_count    = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_sync_count    : {20{1'b0}};
    assign wire_rx_async_count   = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_async_count   : {20{1'b0}};


    // CSR
    alt_mge_phy_usxg32_creg_top #(
        .SYNCHRONIZER_DEPTH         (SYNCHRONIZER_DEPTH)
    ) csr (
        // Clock & Reset
        .csr_clk                    (csr_clk),
        .csr_clk_rst_n              (global_rst_n__csr_clk),
        .tx_clk                     (tx_xgmii_clk),
        .tx_clk_rst_n               (gtx_rst_n__tx_xgmii_clk),
        .rx_clk                     (rx_pma_clk),
        .rx_clk_rst_n               (grx_rst_n__rx_pma_clk), //async reset
        .dl_clk                     (latency_sclk),
        .dl_clk_rst_n               (global_rst_n__sclk),
        
        // Reset for clock crosser
        .csr_tx_cc_in_rst_n         (gtx_rst_n__csr_clk),
        .csr_tx_cc_out_rst_n        (gtx_rst_n__tx_xgmii_clk),
        .tx_csr_cc_in_rst_n         (gtx_rst_n__tx_xgmii_clk),
        .tx_csr_cc_out_rst_n        (gtx_rst_n__csr_clk),
        
        .csr_rx_cc_in_rst_n         (grx_rst_n__csr_clk),
        .csr_rx_cc_out_rst_n        (grx_rst_n__rx_pma_clk), //async reset
        .rx_csr_cc_in_rst_n         (grx_rst_n__rx_pma_clk), //async reset
        .rx_csr_cc_out_rst_n        (grx_rst_n__csr_clk),
        .dl_csr_cc_in_rst_n         (global_rst_n__sclk),
        .dl_csr_cc_out_rst_n        (global_rst_n__csr_clk),
        
        // Avalon-MM Slave
        .avs_address                (csr_address),
        .avs_read                   (csr_read),
        .avs_write                  (csr_write),
        .avs_writedata              (csr_writedata),
        .avs_readdata               (csr_readdata),
        .avs_waitrequest            (csr_waitrequest),
        
        // Register Inputs and Outputs
        .csr_usxgmii_en             (csr_usxgmii_en),
        .csr_usxgmii_an_en          (csr_usxgmii_an_en),
        .csr_usxgmii_speed          (csr_usxgmii_speed),
        .csr_usxgmii_an_restart     (csr_usxgmii_an_restart),
        .csr_usxgmii_an_restart_clr (csr_usxgmii_an_restart_clr),
        .csr_usxgmii_an_resp_mode   (csr_usxgmii_an_resp_mode),
        .status_link_status         (link_status_reg),
        .status_usxgmii_an_complete (status_usxgmii_an_complete),
        .csr_dev_ability_speed      (csr_dev_ability_speed),
        .csr_dev_ability_duplex     (csr_dev_ability_duplex),
        .status_dev_ability_ack     (status_dev_ability_ack),
        .status_partner_ability     (status_partner_ability),
        .csr_usxgmii_an_link_timer  (csr_usxgmii_an_link_timer[19:14]),
        .csr_umii_fault             (csr_umii_fault),
        
        .ptp_dl_tx_measure_valid    (wire_tx_measure_valid),
        .ptp_dl_rx_measure_valid    (wire_rx_measure_valid),
        .ptp_dl_tx_reset            (wire_tx_dl_reset),
        .ptp_dl_rx_reset            (wire_rx_dl_reset),
        .ptp_dl_tx                  (wire_tx_dl_latency),
        .ptp_dl_rx                  (wire_rx_dl_latency),
        .ptp_dl_tx_sync_count_valid (wire_tx_sync_valid),
        .ptp_dl_tx_async_count_valid(wire_tx_async_valid),
        .ptp_dl_rx_sync_count_valid (wire_rx_sync_valid),
        .ptp_dl_rx_async_count_valid(wire_rx_async_valid),
        .ptp_dl_tx_sync_count       (wire_tx_sync_count),
        .ptp_dl_tx_async_count      (wire_tx_async_count),
        .ptp_dl_rx_sync_count       (wire_rx_sync_count),
        .ptp_dl_rx_async_count      (wire_rx_async_count)
    );
    
    
    // for hardware needs add extra 1 fast clock( due to silicon bug) and another 0.763 fast clock due to diff value found btw hardware and sim ( aib_hssi_rx_data_out and *_data_in to/from both TX and RX offset value) total 1.763 fast clock (322Mhz x 2)
    // TX: 10G,5G,2.5G,1G and 100M all having same latency value measured from xgmii_tx to tx_serializer input. 
    //     OFFSET value of 19.384 via simulation waveform, +1.763 fastclock cycle (2 x 322Mhz) or 0.8547 xgmii clk(312Mhz).
    //     For C2prevA ( with AIB bug),needs -0.4847 clk/1.5515ns via tx adjust register. For C2prevB and C2e ( AIB bug fixed),dont need to - 1.5515ns
    // RX: 10G,5G,2.5G,1G and 100M ,diff latency value depending on FIFO level (numdata value) and speed_constant (refer usxgmii latency module).The 
    //     OFFSET value obtained via simulation waveform is 19.109. +1.763 fastclock cycle (2 x 322Mhz) or 0.8547 xgmii clk(312Mhz).For simulation, these extra 0.4847 will be cancelled out via adding same value rx adjust register.
    //     For C2prevA ( with AIB bug),needs -0.4847 clk/1.5515ns via tx adjust register. For C2prevB and C2e ( AIB bug fixed),dont need to - 1.5515ns
    localparam TX_OFFSET = {6'd20,10'd245};                                                              // 20.239
    localparam RX_OFFSET = ((DEVICE_FAMILY == "Agilex") && (ENABLE_IEEE1588 == 1)) ? {6'd1,10'd0}        // 1.0 - RX Derep
                                                                                   + {6'd6,10'd0}        // 6.0 - Pipeline in RX RM FIFO
                                                                                   + {6'd2,10'd0}        // 2.0 - Hard PCS 64b/66b decoder AM shift
                                                                                   + {6'd0,10'd993}      // 0.9696 (32UI) - Latency from the first flop in the RX XCVRIF to the assertion of rx_async_pulse
                                                                                   - {6'd2,10'd0}   :    // 2.0 - Delay of RX Sync pulse in DL logic
                                                                                     {6'd19,10'd987};    // 19.964
    assign w_tx_xgmii_32_lf_valid_in = tx_xgmii_32_lf_valid && csr_umii_fault && (ENABLE_UMII_FAULT != 0);
    
    
    // TX
    wire wire_tx_dl_sync_pulse;
    wire wire_tx_xgmii_dl_sync_pulse_out;
    wire wire_tx_xgmii_dl_valid;
    
    // Set wire to "0" for non-Agilex USXGMII 1588 variant
    assign wire_tx_dl_sync_pulse       = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? tx_dl_sync_pulse                : 1'b0;
    assign tx_xgmii_dl_sync_pulse_out  = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? wire_tx_xgmii_dl_sync_pulse_out : 1'b0;
    assign tx_xgmii_dl_valid           = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? wire_tx_xgmii_dl_valid          : 1'b0;
    
    alt_mge_phy_usxg32_tx_top #(
        .FAWIDTH            (5),
        .TSWIDTH            (TSWIDTH),
        .IDWIDTH            (PMA_MODE),
        .TX_OFFSET          (TX_OFFSET),
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .ENABLE_IEEE1588    (ENABLE_IEEE1588)
    ) tx (
        .tx_xgmii_clk               (tx_xgmii_clk),
        .tx_pma_clk                 (tx_pma_clk),
        
        .tx_xgmii_rst_n             (gtx_rst_n__tx_xgmii_clk),
        .tx_pma_rst_n               (gtx_rst_n__tx_pma_clk),
        
        .tx_xgmii_32_valid_in       (tx_xgmii_32_valid_in),
        .tx_xgmii_32_control_in     (tx_xgmii_32_control_in),
        .tx_xgmii_32_data_in        (tx_xgmii_32_data_in),
        
        .tx_xgmii_32_an_valid_in    (tx_xgmii_32_an_valid),
        .tx_xgmii_32_an_control_in  (tx_xgmii_32_an_control),
        .tx_xgmii_32_an_data_in     (tx_xgmii_32_an_data),
        
        .tx_xgmii_32_lf_valid_in    (w_tx_xgmii_32_lf_valid_in),
        .tx_xgmii_32_lf_control_in  (tx_xgmii_32_lf_control),
        .tx_xgmii_32_lf_data_in     (tx_xgmii_32_lf_data),
        // ED
        .tx_reset_latency_sclk      (tx_reset_latency_sclk),
        .tx_latency_adj             (tx_latency_adj_fifo),
        .latency_sclk               (latency_sclk),
        .latency_xcvr_tx            (latency_xcvr_tx),
        .tx_xgmii_64_valid_out      (tx_xgmii_64_valid_out),
        .tx_xgmii_64_control_out    (tx_xgmii_64_control_out),
        .tx_xgmii_64_data_out       (tx_xgmii_64_data_out),
        
        .tx_xgmii_dl_sync_pulse_in  (wire_tx_dl_sync_pulse),
        .tx_xgmii_dl_sync_pulse_out (wire_tx_xgmii_dl_sync_pulse_out),
        .tx_xgmii_dl_valid          (wire_tx_xgmii_dl_valid)
    );
    
    
    // RX
    wire wire_rx_rec_div33_clk;
    wire wire_rx_fm_ff_sample_clk;
    wire wire_rx_rec_div33_clk_rst;
    wire wire_rx_fm_ff_sample_clk_rst;
    wire wire_rx_xgmii_dl_sync_pulse_in;
    wire wire_rx_xgmii_dl_sync_pulse_out;
    
    // Set wire to "0" for non-Agilex USXGMII 1588 variant
    assign wire_rx_rec_div33_clk            = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_rec_div33_clk                : 1'b0;
    assign wire_rx_fm_ff_sample_clk         = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_fm_ff_sample_clk             : 1'b0;
    assign wire_rx_rec_div33_clk_rst        = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? grx_rst_n__rx_rec_div33_clk     : 1'b0;
    assign wire_rx_fm_ff_sample_clk_rst     = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? grx_rst_n__rx_fm_ff_sample_clk  : 1'b0;
    assign wire_rx_xgmii_dl_sync_pulse_in   = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? rx_xgmii_dl_sync_pulse_in       : 1'b0;
    assign rx_xgmii_dl_sync_pulse_out       = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? wire_rx_xgmii_dl_sync_pulse_out : 1'b0;
    
    alt_mge_phy_usxg32_rx_top #(
        .FF_ADDR_WIDTH      (5),
        .TSWIDTH            (TSWIDTH),
        .IDWIDTH            (PMA_MODE),
        .RX_OFFSET          (RX_OFFSET),
        .ENABLE_IEEE1588    (ENABLE_IEEE1588),
        .DEVICE_FAMILY      (DEVICE_FAMILY)
    ) rx (
        .rx_xgmii_clk                   (rx_xgmii_clk),
        .rx_pma_clk                     (rx_pma_clk),
        .rx_rec_div33_clk               (wire_rx_rec_div33_clk),
        .rx_fm_ff_sample_clk            (wire_rx_fm_ff_sample_clk),
        
        .rx_xgmii_rst_n                 (grx_rst_n__rx_xgmii_clk),
        .rx_pma_rst_n                   (grx_rst_n__rx_pma_clk),    // Async reset
        .rx_rec_div33_clk_rst_n         (wire_rx_rec_div33_clk_rst),
        .rx_fm_ff_sample_clk_rst_n      (wire_rx_fm_ff_sample_clk_rst),
        
        .rx_xgmii_64_valid_in           (rx_xgmii_64_valid_in),
        .rx_xgmii_64_control_in         (rx_xgmii_64_control_in),
        .rx_xgmii_64_data_in            (rx_xgmii_64_data_in),
        
        .rx_xgmii_32_valid_out          (rx_xgmii_32_valid_out),
        .rx_xgmii_32_control_out        (rx_xgmii_32_control_out),
        .rx_xgmii_32_data_out           (rx_xgmii_32_data_out),
        
        .rx_xgmii_32_ext_valid_out      (rx_xgmii_32_ext_valid),
        .rx_xgmii_32_ext_control_out    (rx_xgmii_32_ext_control),
        .rx_xgmii_32_ext_data_out       (rx_xgmii_32_ext_data),
        // ED
        .rx_reset_latency_sclk          (rx_reset_latency_sclk),
        .rx_latency_adj                 (rx_latency_adj),
        .latency_sclk                   (latency_sclk),
        .latency_xcvr_rx                (latency_xcvr_rx),
        .rx_block_lock_in               (rx_block_lock_in),
        .rx_block_lock_out              (rx_block_lock_out),
        
        .operating_speed                (operating_speed),
        
        // Agilex USXGMII 1588 PTP sync pulse in/out from MAC to eth_f NPHY
        .rx_xgmii_dl_sync_pulse_in      (wire_rx_xgmii_dl_sync_pulse_in),
        .rx_xgmii_dl_sync_pulse_out     (wire_rx_xgmii_dl_sync_pulse_out)
    );


    assign w_csr_usxgmii_an_resp_mode = csr_usxgmii_an_resp_mode && (ENABLE_USXGMII_AN_RESP_MODE != 0);

    // AN
    // Clock cross CSR settings to RX clock domain
    alt_mge_phy_mbow_clock_crosser #(
        .SYNCHRONIZER_DEPTH     (SYNCHRONIZER_DEPTH),
        .DATA_WIDTH             (4),
        .OUT_DATA_RESET_VALUE   ({1'b0, 1'b0, 1'b0, 1'b0}),
        .IN_TRANSFER_CYCLE      (4),
        .IN_VALID_LENGTH        (2)
    ) csr_an_clock_crosser (
        .in_clk         (csr_clk),
        .out_clk        (rx_pma_clk),
        
        .in_reset_n     (global_rst_n__csr_clk),
        .out_reset_n    (grx_rst_n__rx_pma_clk_sync0), //sync reset
        
        .in_data        ({w_csr_usxgmii_an_resp_mode, csr_usxgmii_an_restart, csr_usxgmii_an_en, csr_usxgmii_en}),
        .out_data       ({csr_usxgmii_an_resp_mode__rx_pma_clk, csr_usxgmii_an_restart__rx_pma_clk, csr_usxgmii_an_en__rx_pma_clk, csr_usxgmii_en__rx_pma_clk})
    );

    assign csr_usxgmii_an_link_timer[13:0] = 14'h0;
    assign led_an = status_usxgmii_an_complete;

    alt_mge_phy_usxg32_an_top #(
        .SYNCHRONIZER_DEPTH     (SYNCHRONIZER_DEPTH)
    ) an (
        // Clock
        .tx_clk                 (tx_xgmii_clk),
        .rx_clk                 (rx_pma_clk),
        
        // Reset
        .tx_reset_n             (gtx_rst_n__tx_xgmii_clk),
        .rx_reset_n             (grx_rst_n__rx_pma_clk_sync0), //sync reset
        .rx_areset_n            (grx_rst_n__rx_pma_clk), //async reset
        
        // RX XGMII In
        .rx_xgmii_valid_in      (rx_xgmii_32_ext_valid),
        .rx_xgmii_control_in    (rx_xgmii_32_ext_control),
        .rx_xgmii_data_in       (rx_xgmii_32_ext_data),
        
        // TX XGMII Out
        .tx_xgmii_valid_out     (tx_xgmii_32_an_valid),
        .tx_xgmii_control_out   (tx_xgmii_32_an_control),
        .tx_xgmii_data_out      (tx_xgmii_32_an_data),
        
        // Input from CSR
        .an_enable              (csr_usxgmii_en__rx_pma_clk & csr_usxgmii_an_en__rx_pma_clk),
        .an_restart             (csr_usxgmii_an_restart__rx_pma_clk),
        .an_resp_mode           (csr_usxgmii_an_resp_mode__rx_pma_clk),
        .an_ability_in          ({3'b000, csr_dev_ability_duplex, csr_dev_ability_speed, 9'b0_0000_0001}),
        .max_link_timer         (csr_usxgmii_an_link_timer),
        
        // Output to CSR
        .lp_ability_ena         (), // Unused, validity of lp_ability is controlled in an_top module
        .lp_ability             (status_partner_ability),
        .an_restart_rst         (csr_usxgmii_an_restart_clr),
        .page_receive           (), // Unused, not supporting page
        .an_done                (status_usxgmii_an_complete),
        .an_ack                 (status_dev_ability_ack),
        
        // Input for State Machine
        .rx_sync                (rx_block_lock_in)
    );

    // UMII Fault Handling
    alt_mge_phy_usxg32_umii_fault #(
        .SYNCHRONIZER_DEPTH     (SYNCHRONIZER_DEPTH)
    ) lf (
        // Clock
        .tx_clk                 (tx_xgmii_clk),
        .rx_clk                 (rx_pma_clk),
        
        // Reset
        .tx_reset_n             (gtx_rst_n__tx_xgmii_clk),
        .rx_reset_n             (grx_rst_n__rx_pma_clk_sync0), //sync reset
        
        // RX XGMII In
        .rx_xgmii_valid_in      (rx_xgmii_32_ext_valid),
        .rx_xgmii_control_in    (rx_xgmii_32_ext_control),
        .rx_xgmii_data_in       (rx_xgmii_32_ext_data),
        
        // TX XGMII Out
        .tx_xgmii_valid_out     (tx_xgmii_32_lf_valid),
        .tx_xgmii_control_out   (tx_xgmii_32_lf_control),
        .tx_xgmii_data_out      (tx_xgmii_32_lf_data),
        
        .rx_umii_fault_status   (rx_umii_fault_status)
    );

    // |---------------------------------------------|-------------------------|
    // | Speed | operating_speed | csr_usxgmii_speed |  csr_dev_ability_speed  |
    // |       |                 |                   | status_partner_ability  |
    // |---------------------------------------------|-------------------------|
    // | 10G   |       000       |       011         |           011           |
    // | 5G    |       101       |       101         |           101           |
    // | 2.5G  |       100       |       100         |           100           |
    // | 1G    |       001       |       010         |           010           |
    // | 100M  |       010       |       001         |           001           |
    // | 10M   |       011       |       000         |           000           |
    // |---------------------------------------------|-------------------------|

    always @(posedge csr_clk) begin
        if(~global_rst_n__csr_clk) begin
            operating_speed <= 3'b000; // 10G
        end
        else begin
            if(csr_usxgmii_en) begin
                if(csr_usxgmii_an_en) begin
                    // Use AN speed
                    if(status_usxgmii_an_complete) begin
                        case(status_partner_ability[11:9])
                            3'b011 : operating_speed <= 3'b000; // 10G
                            3'b101 : operating_speed <= 3'b101; // 5G
                            3'b100 : operating_speed <= 3'b100; // 2.5G
                            3'b010 : operating_speed <= 3'b001; // 1G
                            3'b001 : operating_speed <= 3'b010; // 100M
                            3'b000 : operating_speed <= 3'b011; // 10M
                            default: operating_speed <= 3'b000; // 10G
                        endcase
                    end
                    else begin
                        operating_speed <= operating_speed;
                    end
                end
                else begin
                    // Use CSR configured speed
                    case(csr_usxgmii_speed)
                        3'b011 : operating_speed <= 3'b000; // 10G
                        3'b101 : operating_speed <= 3'b101; // 5G
                        3'b100 : operating_speed <= 3'b100; // 2.5G
                        3'b010 : operating_speed <= 3'b001; // 1G
                        3'b001 : operating_speed <= 3'b010; // 100M
                        3'b000 : operating_speed <= 3'b011; // 10M
                        default: operating_speed <= 3'b000; // 10G
                    endcase
                end
            end
            else begin
                operating_speed <= 3'b000; // 10G
            end
        end
    end

    // Since this register is running based on recovered clock, no clock is running upon reset
    // Therefore async reset is used to ensure CSR status are reflected correctly upon reset
    always @(posedge rx_pma_clk or negedge grx_rst_n__rx_pma_clk) begin
        if(~grx_rst_n__rx_pma_clk) begin
            link_status_reg <= 1'b0;
        end
        else begin
            if(csr_usxgmii_en__rx_pma_clk & csr_usxgmii_an_en__rx_pma_clk) begin
                link_status_reg <= rx_block_lock_in & status_usxgmii_an_complete;
            end
            else begin
                link_status_reg <= rx_block_lock_in;
            end
        end
    end
    
    // Agilex USXGMII 1588 deterministic latency module
    generate
    if ((DEVICE_FAMILY == "Agilex") && (ENABLE_IEEE1588 == 1)) begin: DET_LAT_1588
        alt_mge_phy_usxg32_f_ptp_latency_measure_top latency_measure_inst_top (
            .i_latency_sclk         (latency_sclk),                 // 6.5ns sampling clock
            .i_tx_xgmii_clk         (tx_xgmii_clk),                 // Clock for transmit parallel data
            .i_rx_xgmii_clk         (rx_rec_div33_clk),             // Clock for receive parallel data
            
            .i_rst_n_async_pulse_clk(gtx_rst_n__tx_xgmii_clk),

            .i_tx_digital_rst_n     (tx_digital_rst_n),
            .i_rx_digital_rst_n     (rx_digital_rst_n),

            .i_global_rst_n         (global_rst_n),
            .i_global_rst_n_tx_xgmii_clk    (global_rst_n__tx_xgmii_clk),
            .i_global_rst_n_rx_xgmii_clk    (global_rst_n__rx_rec_div33_clk),

            .i_tx_stable            (tx_stable),
            .i_rx_stable            (rx_stable),                    // To initiate TX SYNC Pulse generation
            
            .i_tx_dl_rst            (tx_dl_reset),                  // DL reset from register
            .i_rx_dl_rst            (rx_dl_reset),                  // DL reset from register
            
            .i_tx_dl_valid          (tx_xgmii_dl_valid),
            
            .i_rx_dl_sync_pulse     (rx_xgmii_dl_sync_pulse_out),
            .i_rx_dl_async_pulse    (rx_dl_async_pulse),
            .i_tx_dl_async_pulse    (tx_dl_async_pulse),

            .o_tx_dl_sync_pulse     (tx_dl_sync_pulse),             // Start pulse for Tx sync count
            .o_dl_async_cal_pulse   (dl_async_cal_pulse),           // Input to send pulse to measure tx/rx async path (latency_sclk)
            
            .o_tx_dl_measure_sel    (tx_dl_measure_sel),
            .o_rx_dl_measure_sel    (rx_dl_measure_sel),
            
            .o_tx_dl_latency        (tx_dl_latency),                // Calculated tx delay => fixed point - N.M
            .o_rx_dl_latency        (rx_dl_latency),                // Calculated rx delay => fixed point - N.M
            
            .o_tx_sync_count        (tx_sync_count),
            .o_tx_async_count       (tx_async_count),
            .o_rx_sync_count        (rx_sync_count),
            .o_rx_async_count       (rx_async_count),
            
            .o_tx_measure_valid     (tx_measure_valid),
            .o_rx_measure_valid     (rx_measure_valid),
            
            .o_tx_sync_valid        (tx_sync_valid),
            .o_tx_async_valid       (tx_async_valid),
            .o_rx_sync_valid        (rx_sync_valid),
            .o_rx_async_valid       (rx_async_valid)
        );

        assign tx_latency_adj = {13'd4,10'd0} + // 4.0 - TX data path delay before TX phase comp FIFO
                                {13'd2,10'd0};  // 2.0 - Delay of TX Sync pulse in DL logic
    end
    
    else begin
        assign tx_latency_adj       = tx_latency_adj_fifo;
        assign tx_dl_sync_pulse     = 1'b0;
        assign dl_async_cal_pulse   = 1'b0;
        assign tx_dl_measure_sel    = 1'b0;
        assign rx_dl_measure_sel    = 1'b0;
    end
    endgenerate

endmodule

