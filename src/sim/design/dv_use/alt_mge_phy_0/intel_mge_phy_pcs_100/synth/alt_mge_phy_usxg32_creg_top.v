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
module alt_mge_phy_usxg32_creg_top (
    // Clock & Reset
    csr_clk,
    csr_clk_rst_n,
    tx_clk,
    tx_clk_rst_n,
    rx_clk,
    rx_clk_rst_n,
    dl_clk,
    dl_clk_rst_n,
    
    // Reset for clock crosser
    csr_tx_cc_in_rst_n,
    csr_tx_cc_out_rst_n,
    tx_csr_cc_in_rst_n,
    tx_csr_cc_out_rst_n,
    
    csr_rx_cc_in_rst_n,
    csr_rx_cc_out_rst_n,
    rx_csr_cc_in_rst_n,
    rx_csr_cc_out_rst_n,
    dl_csr_cc_in_rst_n,
    dl_csr_cc_out_rst_n,

    // Register Inputs and Outputs
    csr_usxgmii_en,
    csr_usxgmii_an_en,
    csr_usxgmii_speed,
    csr_usxgmii_an_restart,
    csr_usxgmii_an_restart_clr,
    csr_usxgmii_an_resp_mode,
    status_link_status,
    status_usxgmii_an_complete,
    csr_dev_ability_speed,
    csr_dev_ability_duplex,
    status_dev_ability_ack,
    status_partner_ability,
    csr_usxgmii_an_link_timer,
    csr_umii_fault,
    ptp_dl_tx_measure_valid,
    ptp_dl_rx_measure_valid,
    ptp_dl_tx_reset,
    ptp_dl_rx_reset,
    ptp_dl_tx,
    ptp_dl_rx,
    ptp_dl_tx_sync_count_valid,
    ptp_dl_tx_async_count_valid,
    ptp_dl_rx_sync_count_valid,
    ptp_dl_rx_async_count_valid,
    ptp_dl_tx_sync_count,
    ptp_dl_tx_async_count,
    ptp_dl_rx_sync_count,
    ptp_dl_rx_async_count,
    
    // Avalon-MM Slave
    avs_address,
    avs_read,
    avs_write,
    avs_writedata,
    avs_readdata,
    avs_waitrequest
);

// Parameters
parameter DEVICE_FAMILY = "Arria 10";
parameter ENABLE_MEM_ECC = 0;
parameter SYNCHRONIZER_DEPTH = 2;

// Clock & Reset
input                csr_clk;
input                csr_clk_rst_n;
input                tx_clk;
input                tx_clk_rst_n;
input                rx_clk;
input                rx_clk_rst_n;
input                dl_clk;
input                dl_clk_rst_n;


// Reset for clock crosser
input                csr_tx_cc_in_rst_n;
input                csr_tx_cc_out_rst_n;
input                tx_csr_cc_in_rst_n;
input                tx_csr_cc_out_rst_n;

input                csr_rx_cc_in_rst_n;
input                csr_rx_cc_out_rst_n;
input                rx_csr_cc_in_rst_n;
input                rx_csr_cc_out_rst_n;
input                dl_csr_cc_in_rst_n;
input                dl_csr_cc_out_rst_n;


// Avalon-MM Slave
input      [ 5:0]    avs_address;
input                avs_read;
input                avs_write;
input      [31:0]    avs_writedata;
output reg [31:0]    avs_readdata;
output               avs_waitrequest;

// Register Inputs and Outputs
output               csr_usxgmii_en;
output               csr_usxgmii_an_en;
output     [ 2:0]    csr_usxgmii_speed;
output               csr_usxgmii_an_restart;
input                csr_usxgmii_an_restart_clr;
output               csr_usxgmii_an_resp_mode;
input                status_link_status;
input                status_usxgmii_an_complete;
output     [ 2:0]    csr_dev_ability_speed;
output               csr_dev_ability_duplex;
input                status_dev_ability_ack;
input      [15:0]    status_partner_ability;
output     [ 5:0]    csr_usxgmii_an_link_timer;
output               csr_umii_fault;
input                ptp_dl_tx_measure_valid;
input                ptp_dl_rx_measure_valid;
output               ptp_dl_tx_reset;
output               ptp_dl_rx_reset;
input      [20:0]    ptp_dl_tx;
input      [20:0]    ptp_dl_rx;
input                ptp_dl_tx_sync_count_valid;
input                ptp_dl_tx_async_count_valid;
input                ptp_dl_rx_sync_count_valid;
input                ptp_dl_rx_async_count_valid;
input      [19:0]    ptp_dl_tx_sync_count;
input      [19:0]    ptp_dl_tx_async_count;
input      [19:0]    ptp_dl_rx_sync_count;
input      [19:0]    ptp_dl_rx_async_count;

// Wire for register map input and output ports
wire                 usxgmii_en;
wire                 usxgmii_an_en;
wire       [ 2:0]    usxgmii_speed;
wire                 usxgmii_an_restart;
wire                 usxgmii_an_restart_clr_internal;
wire                 usxgmii_an_resp_mode;
wire                 stat_reserve_0;
wire                 link_status;
wire                 stat_reserve_3;
wire                 usxgmii_an_complete;
wire                 dev_ability_reserve_0;
wire                 dev_ability_eee_clock_stop;
wire                 dev_ability_eee_capability;
wire       [ 2:0]    dev_ability_speed;
wire                 dev_ability_duplex;
wire                 dev_ability_ack;
wire       [15:0]    partner_ability_bus;
wire       [ 5:0]    an_link_timer;
wire                 umii_fault;
wire                 dl_tx_measure_valid;
wire                 dl_rx_measure_valid;
wire                 dl_tx_reset;
wire                 dl_rx_reset;
wire       [20:0]    dl_tx;
wire       [20:0]    dl_rx;
wire                 dl_tx_sync_count_valid;
wire                 dl_tx_async_count_valid;
wire                 dl_rx_sync_count_valid;
wire                 dl_rx_async_count_valid;
wire       [19:0]    dl_tx_sync_count;
wire       [19:0]    dl_tx_async_count;
wire       [19:0]    dl_rx_sync_count;
wire       [19:0]    dl_rx_async_count;

reg                  waitrequest_reg;

reg                  reg_map_avs_read;
reg                  reg_map_avs_write;
wire       [ 5:0]    reg_map_avs_address;
wire       [31:0]    reg_map_avs_readdata;
wire       [31:0]    reg_map_avs_writedata;


// Reset for clock crosser
wire                csr_tx_clk_cc_in_rst_n;
wire                csr_tx_clk_cc_out_rst_n;
wire                tx_clk_csr_cc_in_rst_n;
wire                tx_clk_csr_cc_out_rst_n;

wire                csr_rx_clk_cc_in_rst_n;
wire                csr_rx_clk_cc_out_rst_n;
wire                rx_clk_csr_cc_in_rst_n;
wire                rx_clk_csr_cc_out_rst_n;

wire                dl_clk_csr_cc_in_rst_n;
wire                dl_clk_csr_cc_out_rst_n;


// assign csr_tx_clk_cc_in_rst_n               = csr_tx_cc_in_rst_n;
// assign csr_tx_clk_cc_out_rst_n              = csr_tx_cc_out_rst_n;
// assign tx_clk_csr_cc_in_rst_n               = tx_csr_cc_in_rst_n;
// assign tx_clk_csr_cc_out_rst_n              = tx_csr_cc_out_rst_n;


assign csr_rx_clk_cc_in_rst_n               = csr_rx_cc_in_rst_n;
assign csr_rx_clk_cc_out_rst_n              = csr_rx_cc_out_rst_n;
assign rx_clk_csr_cc_in_rst_n               = rx_csr_cc_in_rst_n;
assign rx_clk_csr_cc_out_rst_n              = rx_csr_cc_out_rst_n;
assign dl_clk_csr_cc_in_rst_n               = dl_csr_cc_in_rst_n;
assign dl_clk_csr_cc_out_rst_n              = dl_csr_cc_out_rst_n;


// Avalon-MM Address Decoding
assign reg_map_avs_address = avs_address;

assign reg_map_avs_writedata = avs_writedata;

always @(*) begin
    // Prevent multiple read/write during waitrequest
    reg_map_avs_read          = avs_read & waitrequest_reg;
    
    reg_map_avs_write         = avs_write & waitrequest_reg;
    
    avs_readdata = reg_map_avs_readdata;
end

assign avs_waitrequest = waitrequest_reg;
        
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        waitrequest_reg <= 1'b1;
    end
    else begin
        
        // Read from or write to other registers latency = 1
        if((avs_read | avs_write) && waitrequest_reg) begin
            waitrequest_reg <= 1'b0;
        end
        else begin
            waitrequest_reg <= 1'b1;
        end
    end
end

// Clock Crossing and Connection
// Pseudo-static signal for csr_usxgmii_en
assign csr_usxgmii_en = usxgmii_en;

// Pseudo-static signal for csr_usxgmii_an_en
assign csr_usxgmii_an_en = usxgmii_an_en;

// Pseudo-static signal for csr_usxgmii_speed
assign csr_usxgmii_speed = usxgmii_speed;

// Pseudo-static signal for csr_usxgmii_an_restart
assign csr_usxgmii_an_restart = usxgmii_an_restart;

// External clear based on positive edge for csr_usxgmii_an_restart_clr
reg  csr_usxgmii_an_restart_clr_rx_clk_reg;
wire csr_usxgmii_an_restart_clr_rx_clk_pulse;

always @(posedge rx_clk or negedge rx_clk_rst_n) begin
    if(!rx_clk_rst_n) begin
        csr_usxgmii_an_restart_clr_rx_clk_reg <= 1'b0;
    end
    else begin
        csr_usxgmii_an_restart_clr_rx_clk_reg <= csr_usxgmii_an_restart_clr;
    end
end

assign csr_usxgmii_an_restart_clr_rx_clk_pulse = ~csr_usxgmii_an_restart_clr_rx_clk_reg & csr_usxgmii_an_restart_clr;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_usxgmii_an_restart_clr(
    .in_clk      (rx_clk),
    .in_reset    (~rx_clk_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (csr_usxgmii_an_restart_clr_rx_clk_pulse),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset   (~rx_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (usxgmii_an_restart_clr_internal),
    .out_data    ()
);

// Pseudo-static signal for csr_usxgmii_an_resp_mode
assign csr_usxgmii_an_resp_mode = usxgmii_an_resp_mode;

// Constant signal for stat_reserve_0
assign stat_reserve_0 = 1'b1;

// Single-bit clock crossing (in) for status_link_status
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_status_link_status (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_link_status),
    .dout(link_status)
);

// Constant signal for stat_reserve_3
assign stat_reserve_3 = 1'b1;

// Single-bit clock crossing (in) for status_usxgmii_an_complete
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_status_usxgmii_an_complete (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_usxgmii_an_complete),
    .dout(usxgmii_an_complete)
);

// Constant signal for dev_ability_reserve_0
assign dev_ability_reserve_0 = 1'b1;

// Constant signal for dev_ability_eee_clock_stop
assign dev_ability_eee_clock_stop = 1'b0;

// Constant signal for dev_ability_eee_capability
assign dev_ability_eee_capability = 1'b0;

// Multi-bits clock crossing (out) for csr_dev_ability_speed
wire csr_dev_ability_speed_csr_clk_ready;
wire csr_dev_ability_speed_csr_clk_valid;
wire csr_dev_ability_speed_rx_clk_valid;
wire [2:0] csr_dev_ability_speed_rx_clk_data;
reg  [2:0] csr_dev_ability_speed_rx_clk_reg;

assign csr_dev_ability_speed_csr_clk_valid = csr_dev_ability_speed_csr_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (3),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_dev_ability_speed(
    .in_clk      (csr_clk),
    .in_reset    (~csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_dev_ability_speed_csr_clk_ready),
    .in_valid    (csr_dev_ability_speed_csr_clk_valid),
    .in_data     (dev_ability_speed),
    .out_clk     (rx_clk),
    .out_reset   (~csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_dev_ability_speed_rx_clk_valid),
    .out_data    (csr_dev_ability_speed_rx_clk_data)
);

always @(posedge rx_clk or negedge rx_clk_rst_n) begin
    if(!rx_clk_rst_n) begin
        csr_dev_ability_speed_rx_clk_reg <= 3'h0;
    end
    else begin
        if(csr_dev_ability_speed_rx_clk_valid) begin
            csr_dev_ability_speed_rx_clk_reg <= csr_dev_ability_speed_rx_clk_data;
        end
    end
end

assign csr_dev_ability_speed = csr_dev_ability_speed_rx_clk_reg;

// Single-bit clock crossing (out) for csr_dev_ability_duplex
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_csr_dev_ability_duplex (
    .clk(rx_clk),
    .reset_n(rx_clk_rst_n),
    .din(dev_ability_duplex),
    .dout(csr_dev_ability_duplex)
);

// Single-bit clock crossing (in) for status_dev_ability_ack
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_status_dev_ability_ack (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_dev_ability_ack),
    .dout(dev_ability_ack)
);

// Multi-bits clock crossing (in) for status_partner_ability
wire status_partner_ability_rx_clk_ready;
wire status_partner_ability_rx_clk_valid;
wire status_partner_ability_csr_clk_valid;
wire [15:0] status_partner_ability_csr_clk_data;
reg  [15:0] status_partner_ability_csr_clk_reg;

assign status_partner_ability_rx_clk_valid = status_partner_ability_rx_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_status_partner_ability(
    .in_clk      (rx_clk),
    .in_reset    (~rx_clk_csr_cc_in_rst_n),
    .in_ready    (status_partner_ability_rx_clk_ready),
    .in_valid    (status_partner_ability_rx_clk_valid),
    .in_data     (status_partner_ability),
    .out_clk     (csr_clk),
    .out_reset   (~rx_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (status_partner_ability_csr_clk_valid),
    .out_data    (status_partner_ability_csr_clk_data)
);

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        status_partner_ability_csr_clk_reg <= 16'h0000;
    end
    else begin
        if(status_partner_ability_csr_clk_valid) begin
            status_partner_ability_csr_clk_reg <= status_partner_ability_csr_clk_data;
        end
    end
end

assign partner_ability_bus = status_partner_ability_csr_clk_reg;

// Multi-bits clock crossing (out) for csr_usxgmii_an_link_timer
wire csr_usxgmii_an_link_timer_csr_clk_ready;
wire csr_usxgmii_an_link_timer_csr_clk_valid;
wire csr_usxgmii_an_link_timer_rx_clk_valid;
wire [5:0] csr_usxgmii_an_link_timer_rx_clk_data;
reg  [5:0] csr_usxgmii_an_link_timer_rx_clk_reg;

assign csr_usxgmii_an_link_timer_csr_clk_valid = csr_usxgmii_an_link_timer_csr_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (6),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_usxgmii_an_link_timer(
    .in_clk      (csr_clk),
    .in_reset    (~csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_usxgmii_an_link_timer_csr_clk_ready),
    .in_valid    (csr_usxgmii_an_link_timer_csr_clk_valid),
    .in_data     (an_link_timer),
    .out_clk     (rx_clk),
    .out_reset   (~csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_usxgmii_an_link_timer_rx_clk_valid),
    .out_data    (csr_usxgmii_an_link_timer_rx_clk_data)
);

always @(posedge rx_clk or negedge rx_clk_rst_n) begin
    if(!rx_clk_rst_n) begin
        csr_usxgmii_an_link_timer_rx_clk_reg <= 6'h1F;
    end
    else begin
        if(csr_usxgmii_an_link_timer_rx_clk_valid) begin
            csr_usxgmii_an_link_timer_rx_clk_reg <= csr_usxgmii_an_link_timer_rx_clk_data;
        end
    end
end

assign csr_usxgmii_an_link_timer = csr_usxgmii_an_link_timer_rx_clk_reg;

// Single-bit clock crossing (out) for csr_umii_fault
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_tx_clk_csr_umii_fault (
    .clk(tx_clk),
    .reset_n(tx_clk_rst_n),
    .din(umii_fault),
    .dout(csr_umii_fault)
);

// Single-bit clock crossing (in) for ptp_dl_tx_measure_valid
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_dl_clk_ptp_dl_tx_measure_valid (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(ptp_dl_tx_measure_valid),
    .dout(dl_tx_measure_valid)
);

// Single-bit clock crossing (in) for ptp_dl_rx_measure_valid
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_dl_clk_ptp_dl_rx_measure_valid (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(ptp_dl_rx_measure_valid),
    .dout(dl_rx_measure_valid)
);

// Single-bit clock crossing (out) for ptp_dl_tx_reset
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_dl_clk_ptp_dl_tx_reset (
    .clk(dl_clk),
    .reset_n(dl_clk_rst_n),
    .din(dl_tx_reset),
    .dout(ptp_dl_tx_reset)
);

// Single-bit clock crossing (out) for ptp_dl_rx_reset
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_dl_clk_ptp_dl_rx_reset (
    .clk(dl_clk),
    .reset_n(dl_clk_rst_n),
    .din(dl_rx_reset),
    .dout(ptp_dl_rx_reset)
);

// Multi-bits clock crossing (in) for ptp_dl_tx
wire ptp_dl_tx_dl_clk_ready;
wire ptp_dl_tx_dl_clk_valid;
wire ptp_dl_tx_csr_clk_valid;
wire [20:0] ptp_dl_tx_csr_clk_data;
reg  [20:0] ptp_dl_tx_csr_clk_reg;

assign ptp_dl_tx_dl_clk_valid = ptp_dl_tx_dl_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (21),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_dl_clk_ptp_dl_tx(
    .in_clk      (dl_clk),
    .in_reset    (~dl_clk_csr_cc_in_rst_n),
    .in_ready    (ptp_dl_tx_dl_clk_ready),
    .in_valid    (ptp_dl_tx_dl_clk_valid),
    .in_data     (ptp_dl_tx),
    .out_clk     (csr_clk),
    .out_reset   (~dl_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (ptp_dl_tx_csr_clk_valid),
    .out_data    (ptp_dl_tx_csr_clk_data)
);

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        ptp_dl_tx_csr_clk_reg <= 21'h00000;
    end
    else begin
        if(ptp_dl_tx_csr_clk_valid) begin
            ptp_dl_tx_csr_clk_reg <= ptp_dl_tx_csr_clk_data;
        end
    end
end

assign dl_tx = ptp_dl_tx_csr_clk_reg;

// Multi-bits clock crossing (in) for ptp_dl_rx
wire ptp_dl_rx_dl_clk_ready;
wire ptp_dl_rx_dl_clk_valid;
wire ptp_dl_rx_csr_clk_valid;
wire [20:0] ptp_dl_rx_csr_clk_data;
reg  [20:0] ptp_dl_rx_csr_clk_reg;

assign ptp_dl_rx_dl_clk_valid = ptp_dl_rx_dl_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (21),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_dl_clk_ptp_dl_rx(
    .in_clk      (dl_clk),
    .in_reset    (~dl_clk_csr_cc_in_rst_n),
    .in_ready    (ptp_dl_rx_dl_clk_ready),
    .in_valid    (ptp_dl_rx_dl_clk_valid),
    .in_data     (ptp_dl_rx),
    .out_clk     (csr_clk),
    .out_reset   (~dl_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (ptp_dl_rx_csr_clk_valid),
    .out_data    (ptp_dl_rx_csr_clk_data)
);

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        ptp_dl_rx_csr_clk_reg <= 21'h00000;
    end
    else begin
        if(ptp_dl_rx_csr_clk_valid) begin
            ptp_dl_rx_csr_clk_reg <= ptp_dl_rx_csr_clk_data;
        end
    end
end

assign dl_rx = ptp_dl_rx_csr_clk_reg;

// Single-bit clock crossing (in) for ptp_dl_tx_sync_count_valid
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_dl_clk_ptp_dl_tx_sync_count_valid (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(ptp_dl_tx_sync_count_valid),
    .dout(dl_tx_sync_count_valid)
);

// Single-bit clock crossing (in) for ptp_dl_tx_async_count_valid
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_dl_clk_ptp_dl_tx_async_count_valid (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(ptp_dl_tx_async_count_valid),
    .dout(dl_tx_async_count_valid)
);

// Single-bit clock crossing (in) for ptp_dl_rx_sync_count_valid
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_dl_clk_ptp_dl_rx_sync_count_valid (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(ptp_dl_rx_sync_count_valid),
    .dout(dl_rx_sync_count_valid)
);

// Single-bit clock crossing (in) for ptp_dl_rx_async_count_valid
alt_mge16_pcs_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_dl_clk_ptp_dl_rx_async_count_valid (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(ptp_dl_rx_async_count_valid),
    .dout(dl_rx_async_count_valid)
);

// Multi-bits clock crossing (in) for ptp_dl_tx_sync_count
wire ptp_dl_tx_sync_count_dl_clk_ready;
wire ptp_dl_tx_sync_count_dl_clk_valid;
wire ptp_dl_tx_sync_count_csr_clk_valid;
wire [19:0] ptp_dl_tx_sync_count_csr_clk_data;
reg  [19:0] ptp_dl_tx_sync_count_csr_clk_reg;

assign ptp_dl_tx_sync_count_dl_clk_valid = ptp_dl_tx_sync_count_dl_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (20),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_dl_clk_ptp_dl_tx_sync_count(
    .in_clk      (dl_clk),
    .in_reset    (~dl_clk_csr_cc_in_rst_n),
    .in_ready    (ptp_dl_tx_sync_count_dl_clk_ready),
    .in_valid    (ptp_dl_tx_sync_count_dl_clk_valid),
    .in_data     (ptp_dl_tx_sync_count),
    .out_clk     (csr_clk),
    .out_reset   (~dl_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (ptp_dl_tx_sync_count_csr_clk_valid),
    .out_data    (ptp_dl_tx_sync_count_csr_clk_data)
);

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        ptp_dl_tx_sync_count_csr_clk_reg <= 20'h0000;
    end
    else begin
        if(ptp_dl_tx_sync_count_csr_clk_valid) begin
            ptp_dl_tx_sync_count_csr_clk_reg <= ptp_dl_tx_sync_count_csr_clk_data;
        end
    end
end

assign dl_tx_sync_count = ptp_dl_tx_sync_count_csr_clk_reg;

// Multi-bits clock crossing (in) for ptp_dl_tx_async_count
wire ptp_dl_tx_async_count_dl_clk_ready;
wire ptp_dl_tx_async_count_dl_clk_valid;
wire ptp_dl_tx_async_count_csr_clk_valid;
wire [19:0] ptp_dl_tx_async_count_csr_clk_data;
reg  [19:0] ptp_dl_tx_async_count_csr_clk_reg;

assign ptp_dl_tx_async_count_dl_clk_valid = ptp_dl_tx_async_count_dl_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (20),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_dl_clk_ptp_dl_tx_async_count(
    .in_clk      (dl_clk),
    .in_reset    (~dl_clk_csr_cc_in_rst_n),
    .in_ready    (ptp_dl_tx_async_count_dl_clk_ready),
    .in_valid    (ptp_dl_tx_async_count_dl_clk_valid),
    .in_data     (ptp_dl_tx_async_count),
    .out_clk     (csr_clk),
    .out_reset   (~dl_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (ptp_dl_tx_async_count_csr_clk_valid),
    .out_data    (ptp_dl_tx_async_count_csr_clk_data)
);

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        ptp_dl_tx_async_count_csr_clk_reg <= 20'h0000;
    end
    else begin
        if(ptp_dl_tx_async_count_csr_clk_valid) begin
            ptp_dl_tx_async_count_csr_clk_reg <= ptp_dl_tx_async_count_csr_clk_data;
        end
    end
end

assign dl_tx_async_count = ptp_dl_tx_async_count_csr_clk_reg;

// Multi-bits clock crossing (in) for ptp_dl_rx_sync_count
wire ptp_dl_rx_sync_count_dl_clk_ready;
wire ptp_dl_rx_sync_count_dl_clk_valid;
wire ptp_dl_rx_sync_count_csr_clk_valid;
wire [19:0] ptp_dl_rx_sync_count_csr_clk_data;
reg  [19:0] ptp_dl_rx_sync_count_csr_clk_reg;

assign ptp_dl_rx_sync_count_dl_clk_valid = ptp_dl_rx_sync_count_dl_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (20),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_dl_clk_ptp_dl_rx_sync_count(
    .in_clk      (dl_clk),
    .in_reset    (~dl_clk_csr_cc_in_rst_n),
    .in_ready    (ptp_dl_rx_sync_count_dl_clk_ready),
    .in_valid    (ptp_dl_rx_sync_count_dl_clk_valid),
    .in_data     (ptp_dl_rx_sync_count),
    .out_clk     (csr_clk),
    .out_reset   (~dl_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (ptp_dl_rx_sync_count_csr_clk_valid),
    .out_data    (ptp_dl_rx_sync_count_csr_clk_data)
);

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        ptp_dl_rx_sync_count_csr_clk_reg <= 20'h0000;
    end
    else begin
        if(ptp_dl_rx_sync_count_csr_clk_valid) begin
            ptp_dl_rx_sync_count_csr_clk_reg <= ptp_dl_rx_sync_count_csr_clk_data;
        end
    end
end

assign dl_rx_sync_count = ptp_dl_rx_sync_count_csr_clk_reg;

// Multi-bits clock crossing (in) for ptp_dl_rx_async_count
wire ptp_dl_rx_async_count_dl_clk_ready;
wire ptp_dl_rx_async_count_dl_clk_valid;
wire ptp_dl_rx_async_count_csr_clk_valid;
wire [19:0] ptp_dl_rx_async_count_csr_clk_data;
reg  [19:0] ptp_dl_rx_async_count_csr_clk_reg;

assign ptp_dl_rx_async_count_dl_clk_valid = ptp_dl_rx_async_count_dl_clk_ready;

alt_mge16_pcs_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (20),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_dl_clk_ptp_dl_rx_async_count(
    .in_clk      (dl_clk),
    .in_reset    (~dl_clk_csr_cc_in_rst_n),
    .in_ready    (ptp_dl_rx_async_count_dl_clk_ready),
    .in_valid    (ptp_dl_rx_async_count_dl_clk_valid),
    .in_data     (ptp_dl_rx_async_count),
    .out_clk     (csr_clk),
    .out_reset   (~dl_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (ptp_dl_rx_async_count_csr_clk_valid),
    .out_data    (ptp_dl_rx_async_count_csr_clk_data)
);

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        ptp_dl_rx_async_count_csr_clk_reg <= 20'h0000;
    end
    else begin
        if(ptp_dl_rx_async_count_csr_clk_valid) begin
            ptp_dl_rx_async_count_csr_clk_reg <= ptp_dl_rx_async_count_csr_clk_data;
        end
    end
end

assign dl_rx_async_count = ptp_dl_rx_async_count_csr_clk_reg;


// Register Map Instance
alt_mge_phy_usxg32_creg_map alt_mge_phy_usxg32_creg_map_inst(
    // Clock & Reset
    .csr_clk(csr_clk),
    .csr_clk_rst_n(csr_clk_rst_n),

    // Register Inputs and Outputs
    .usxgmii_en(usxgmii_en),
    .usxgmii_an_en(usxgmii_an_en),
    .usxgmii_speed(usxgmii_speed),
    .usxgmii_an_restart(usxgmii_an_restart),
    .usxgmii_an_restart_clr_internal(usxgmii_an_restart_clr_internal),
    .usxgmii_an_resp_mode(usxgmii_an_resp_mode),
    .stat_reserve_0(stat_reserve_0),
    .link_status(link_status),
    .stat_reserve_3(stat_reserve_3),
    .usxgmii_an_complete(usxgmii_an_complete),
    .dev_ability_reserve_0(dev_ability_reserve_0),
    .dev_ability_eee_clock_stop(dev_ability_eee_clock_stop),
    .dev_ability_eee_capability(dev_ability_eee_capability),
    .dev_ability_speed(dev_ability_speed),
    .dev_ability_duplex(dev_ability_duplex),
    .dev_ability_ack(dev_ability_ack),
    .partner_ability_bus(partner_ability_bus),
    .an_link_timer(an_link_timer),
    .umii_fault(umii_fault),
    .dl_tx_measure_valid(dl_tx_measure_valid),
    .dl_rx_measure_valid(dl_rx_measure_valid),
    .dl_tx_reset(dl_tx_reset),
    .dl_rx_reset(dl_rx_reset),
    .dl_tx(dl_tx),
    .dl_rx(dl_rx),
    .dl_tx_sync_count_valid(dl_tx_sync_count_valid),
    .dl_tx_async_count_valid(dl_tx_async_count_valid),
    .dl_rx_sync_count_valid(dl_rx_sync_count_valid),
    .dl_rx_async_count_valid(dl_rx_async_count_valid),
    .dl_tx_sync_count(dl_tx_sync_count),
    .dl_tx_async_count(dl_tx_async_count),
    .dl_rx_sync_count(dl_rx_sync_count),
    .dl_rx_async_count(dl_rx_async_count),

    // Avalon-MM Slave
    .avs_address(reg_map_avs_address),
    .avs_read(reg_map_avs_read),
    .avs_write(reg_map_avs_write),
    .avs_writedata(reg_map_avs_writedata),
    .avs_readdata(reg_map_avs_readdata),
    .avs_waitrequest()
);

endmodule

