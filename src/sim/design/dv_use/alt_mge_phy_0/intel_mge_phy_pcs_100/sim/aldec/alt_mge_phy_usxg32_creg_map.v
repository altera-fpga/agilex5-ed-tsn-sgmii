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
module alt_mge_phy_usxg32_creg_map (
    // Clock & Reset
    csr_clk,
    csr_clk_rst_n,

    // Register Inputs and Outputs
    usxgmii_en,
    usxgmii_an_en,
    usxgmii_speed,
    usxgmii_an_restart,
    usxgmii_an_restart_clr_internal,
    usxgmii_an_resp_mode,
    stat_reserve_0,
    link_status,
    stat_reserve_3,
    usxgmii_an_complete,
    dev_ability_reserve_0,
    dev_ability_eee_clock_stop,
    dev_ability_eee_capability,
    dev_ability_speed,
    dev_ability_duplex,
    dev_ability_ack,
    partner_ability_bus,
    an_link_timer,
    umii_fault,
    dl_tx_measure_valid,
    dl_rx_measure_valid,
    dl_tx_reset,
    dl_rx_reset,
    dl_tx,
    dl_rx,
    dl_tx_sync_count_valid,
    dl_tx_async_count_valid,
    dl_rx_sync_count_valid,
    dl_rx_async_count_valid,
    dl_tx_sync_count,
    dl_tx_async_count,
    dl_rx_sync_count,
    dl_rx_async_count,

    // Avalon-MM Slave
    avs_address,
    avs_read,
    avs_write,
    avs_writedata,
    avs_readdata,
    avs_waitrequest
);

// Clock & Reset
input                csr_clk;
input                csr_clk_rst_n;

// Register Inputs and Outputs
output reg           usxgmii_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           usxgmii_an_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [ 2:0]    usxgmii_speed /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           usxgmii_an_restart /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
input                usxgmii_an_restart_clr_internal;
output reg           usxgmii_an_resp_mode /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
input                stat_reserve_0;
input                link_status;
input                stat_reserve_3;
input                usxgmii_an_complete;
input                dev_ability_reserve_0;
input                dev_ability_eee_clock_stop;
input                dev_ability_eee_capability;
output reg [ 2:0]    dev_ability_speed;
output reg           dev_ability_duplex;
input                dev_ability_ack;
input      [15:0]    partner_ability_bus;
output reg [ 5:0]    an_link_timer;
output reg           umii_fault;
input                dl_tx_measure_valid;
input                dl_rx_measure_valid;
output reg           dl_tx_reset;
output reg           dl_rx_reset;
input      [20:0]    dl_tx;
input      [20:0]    dl_rx;
input                dl_tx_sync_count_valid;
input                dl_tx_async_count_valid;
input                dl_rx_sync_count_valid;
input                dl_rx_async_count_valid;
input      [19:0]    dl_tx_sync_count;
input      [19:0]    dl_tx_async_count;
input      [19:0]    dl_rx_sync_count;
input      [19:0]    dl_rx_async_count;

// Avalon-MM Slave
input      [ 5:0]    avs_address;
input                avs_read;
input                avs_write;
input      [31:0]    avs_writedata;
output reg [31:0]    avs_readdata;
output               avs_waitrequest;

// Internal Signals for CSR Read
wire       [31:0]    csr_control;
wire       [31:0]    csr_status;
wire       [31:0]    csr_dev_ability;
wire       [31:0]    csr_partner_ability;
wire       [31:0]    csr_an_link_timer;
wire       [31:0]    csr_umii_fault;
wire       [31:0]    dl_flag;
wire       [31:0]    dl_tx_latency;
wire       [31:0]    dl_rx_latency;
wire       [31:0]    dl_count_valid;
wire       [31:0]    dl_tx_sync;
wire       [31:0]    dl_tx_async;
wire       [31:0]    dl_rx_sync;
wire       [31:0]    dl_rx_async;

assign avs_waitrequest = 1'b0;
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        usxgmii_en <= 1'b0;
        usxgmii_an_en <= 1'b1;
        usxgmii_speed[ 2:0] <= 3'h0;
        usxgmii_an_restart <= 1'b0;
        usxgmii_an_resp_mode <= 1'b0;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 6'h00) begin
                usxgmii_en <= avs_writedata[0];
            end
        end
        if(avs_write) begin
            if(avs_address == 6'h00) begin
                usxgmii_an_en <= avs_writedata[1];
            end
        end
        if(avs_write) begin
            if(avs_address == 6'h00) begin
                usxgmii_speed[ 2:0] <= avs_writedata[ 4:2];
            end
        end
        if(avs_write) begin
            if(avs_address == 6'h00) begin
                usxgmii_an_restart <= avs_writedata[9];
            end
        end
        else if(usxgmii_an_restart_clr_internal) begin
            usxgmii_an_restart <= 1'b0;
        end
        if(avs_write) begin
            if(avs_address == 6'h00) begin
                usxgmii_an_resp_mode <= avs_writedata[31];
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        dev_ability_speed[ 2:0] <= 3'h0;
        dev_ability_duplex <= 1'b0;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 6'h04) begin
                dev_ability_speed[ 2:0] <= avs_writedata[11:9];
            end
        end
        if(avs_write) begin
            if(avs_address == 6'h04) begin
                dev_ability_duplex <= avs_writedata[12];
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        an_link_timer[ 5:0] <= 6'h1F;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 6'h12) begin
                an_link_timer[ 5:0] <= avs_writedata[19:14];
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        umii_fault <= 1'b0;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 6'h15) begin
                umii_fault <= avs_writedata[0];
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        dl_tx_reset <= 1'b0;
        dl_rx_reset <= 1'b0;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 6'h20) begin
                dl_tx_reset <= avs_writedata[2];
            end
        end
        if(avs_write) begin
            if(avs_address == 6'h20) begin
                dl_rx_reset <= avs_writedata[3];
            end
        end
    end
end

assign csr_control[0] = usxgmii_en;
assign csr_control[1] = usxgmii_an_en;
assign csr_control[2] = usxgmii_speed[0];
assign csr_control[3] = usxgmii_speed[1];
assign csr_control[4] = usxgmii_speed[2];
assign csr_control[5] = 1'b0;
assign csr_control[6] = 1'b0;
assign csr_control[7] = 1'b0;
assign csr_control[8] = 1'b0;
assign csr_control[9] = usxgmii_an_restart;
assign csr_control[10] = 1'b0;
assign csr_control[11] = 1'b0;
assign csr_control[12] = 1'b0;
assign csr_control[13] = 1'b0;
assign csr_control[14] = 1'b0;
assign csr_control[15] = 1'b0;
assign csr_control[16] = 1'b0;
assign csr_control[17] = 1'b0;
assign csr_control[18] = 1'b0;
assign csr_control[19] = 1'b0;
assign csr_control[20] = 1'b0;
assign csr_control[21] = 1'b0;
assign csr_control[22] = 1'b0;
assign csr_control[23] = 1'b0;
assign csr_control[24] = 1'b0;
assign csr_control[25] = 1'b0;
assign csr_control[26] = 1'b0;
assign csr_control[27] = 1'b0;
assign csr_control[28] = 1'b0;
assign csr_control[29] = 1'b0;
assign csr_control[30] = 1'b0;
assign csr_control[31] = usxgmii_an_resp_mode;

assign csr_status[0] = stat_reserve_0;
assign csr_status[1] = 1'b0;
assign csr_status[2] = link_status;
assign csr_status[3] = stat_reserve_3;
assign csr_status[4] = 1'b0;
assign csr_status[5] = usxgmii_an_complete;
assign csr_status[6] = 1'b0;
assign csr_status[7] = 1'b0;
assign csr_status[8] = 1'b0;
assign csr_status[9] = 1'b0;
assign csr_status[10] = 1'b0;
assign csr_status[11] = 1'b0;
assign csr_status[12] = 1'b0;
assign csr_status[13] = 1'b0;
assign csr_status[14] = 1'b0;
assign csr_status[15] = 1'b0;
assign csr_status[16] = 1'b0;
assign csr_status[17] = 1'b0;
assign csr_status[18] = 1'b0;
assign csr_status[19] = 1'b0;
assign csr_status[20] = 1'b0;
assign csr_status[21] = 1'b0;
assign csr_status[22] = 1'b0;
assign csr_status[23] = 1'b0;
assign csr_status[24] = 1'b0;
assign csr_status[25] = 1'b0;
assign csr_status[26] = 1'b0;
assign csr_status[27] = 1'b0;
assign csr_status[28] = 1'b0;
assign csr_status[29] = 1'b0;
assign csr_status[30] = 1'b0;
assign csr_status[31] = 1'b0;

assign csr_dev_ability[0] = dev_ability_reserve_0;
assign csr_dev_ability[1] = 1'b0;
assign csr_dev_ability[2] = 1'b0;
assign csr_dev_ability[3] = 1'b0;
assign csr_dev_ability[4] = 1'b0;
assign csr_dev_ability[5] = 1'b0;
assign csr_dev_ability[6] = 1'b0;
assign csr_dev_ability[7] = dev_ability_eee_clock_stop;
assign csr_dev_ability[8] = dev_ability_eee_capability;
assign csr_dev_ability[9] = dev_ability_speed[0];
assign csr_dev_ability[10] = dev_ability_speed[1];
assign csr_dev_ability[11] = dev_ability_speed[2];
assign csr_dev_ability[12] = dev_ability_duplex;
assign csr_dev_ability[13] = 1'b0;
assign csr_dev_ability[14] = dev_ability_ack;
assign csr_dev_ability[15] = 1'b0;
assign csr_dev_ability[16] = 1'b0;
assign csr_dev_ability[17] = 1'b0;
assign csr_dev_ability[18] = 1'b0;
assign csr_dev_ability[19] = 1'b0;
assign csr_dev_ability[20] = 1'b0;
assign csr_dev_ability[21] = 1'b0;
assign csr_dev_ability[22] = 1'b0;
assign csr_dev_ability[23] = 1'b0;
assign csr_dev_ability[24] = 1'b0;
assign csr_dev_ability[25] = 1'b0;
assign csr_dev_ability[26] = 1'b0;
assign csr_dev_ability[27] = 1'b0;
assign csr_dev_ability[28] = 1'b0;
assign csr_dev_ability[29] = 1'b0;
assign csr_dev_ability[30] = 1'b0;
assign csr_dev_ability[31] = 1'b0;

assign csr_partner_ability[0] = partner_ability_bus[0];
assign csr_partner_ability[1] = partner_ability_bus[1];
assign csr_partner_ability[2] = partner_ability_bus[2];
assign csr_partner_ability[3] = partner_ability_bus[3];
assign csr_partner_ability[4] = partner_ability_bus[4];
assign csr_partner_ability[5] = partner_ability_bus[5];
assign csr_partner_ability[6] = partner_ability_bus[6];
assign csr_partner_ability[7] = partner_ability_bus[7];
assign csr_partner_ability[8] = partner_ability_bus[8];
assign csr_partner_ability[9] = partner_ability_bus[9];
assign csr_partner_ability[10] = partner_ability_bus[10];
assign csr_partner_ability[11] = partner_ability_bus[11];
assign csr_partner_ability[12] = partner_ability_bus[12];
assign csr_partner_ability[13] = partner_ability_bus[13];
assign csr_partner_ability[14] = partner_ability_bus[14];
assign csr_partner_ability[15] = partner_ability_bus[15];
assign csr_partner_ability[16] = 1'b0;
assign csr_partner_ability[17] = 1'b0;
assign csr_partner_ability[18] = 1'b0;
assign csr_partner_ability[19] = 1'b0;
assign csr_partner_ability[20] = 1'b0;
assign csr_partner_ability[21] = 1'b0;
assign csr_partner_ability[22] = 1'b0;
assign csr_partner_ability[23] = 1'b0;
assign csr_partner_ability[24] = 1'b0;
assign csr_partner_ability[25] = 1'b0;
assign csr_partner_ability[26] = 1'b0;
assign csr_partner_ability[27] = 1'b0;
assign csr_partner_ability[28] = 1'b0;
assign csr_partner_ability[29] = 1'b0;
assign csr_partner_ability[30] = 1'b0;
assign csr_partner_ability[31] = 1'b0;

assign csr_an_link_timer[0] = 1'b0;
assign csr_an_link_timer[1] = 1'b0;
assign csr_an_link_timer[2] = 1'b0;
assign csr_an_link_timer[3] = 1'b0;
assign csr_an_link_timer[4] = 1'b0;
assign csr_an_link_timer[5] = 1'b0;
assign csr_an_link_timer[6] = 1'b0;
assign csr_an_link_timer[7] = 1'b0;
assign csr_an_link_timer[8] = 1'b0;
assign csr_an_link_timer[9] = 1'b0;
assign csr_an_link_timer[10] = 1'b0;
assign csr_an_link_timer[11] = 1'b0;
assign csr_an_link_timer[12] = 1'b0;
assign csr_an_link_timer[13] = 1'b0;
assign csr_an_link_timer[14] = an_link_timer[0];
assign csr_an_link_timer[15] = an_link_timer[1];
assign csr_an_link_timer[16] = an_link_timer[2];
assign csr_an_link_timer[17] = an_link_timer[3];
assign csr_an_link_timer[18] = an_link_timer[4];
assign csr_an_link_timer[19] = an_link_timer[5];
assign csr_an_link_timer[20] = 1'b0;
assign csr_an_link_timer[21] = 1'b0;
assign csr_an_link_timer[22] = 1'b0;
assign csr_an_link_timer[23] = 1'b0;
assign csr_an_link_timer[24] = 1'b0;
assign csr_an_link_timer[25] = 1'b0;
assign csr_an_link_timer[26] = 1'b0;
assign csr_an_link_timer[27] = 1'b0;
assign csr_an_link_timer[28] = 1'b0;
assign csr_an_link_timer[29] = 1'b0;
assign csr_an_link_timer[30] = 1'b0;
assign csr_an_link_timer[31] = 1'b0;

assign csr_umii_fault[0] = umii_fault;
assign csr_umii_fault[1] = 1'b0;
assign csr_umii_fault[2] = 1'b0;
assign csr_umii_fault[3] = 1'b0;
assign csr_umii_fault[4] = 1'b0;
assign csr_umii_fault[5] = 1'b0;
assign csr_umii_fault[6] = 1'b0;
assign csr_umii_fault[7] = 1'b0;
assign csr_umii_fault[8] = 1'b0;
assign csr_umii_fault[9] = 1'b0;
assign csr_umii_fault[10] = 1'b0;
assign csr_umii_fault[11] = 1'b0;
assign csr_umii_fault[12] = 1'b0;
assign csr_umii_fault[13] = 1'b0;
assign csr_umii_fault[14] = 1'b0;
assign csr_umii_fault[15] = 1'b0;
assign csr_umii_fault[16] = 1'b0;
assign csr_umii_fault[17] = 1'b0;
assign csr_umii_fault[18] = 1'b0;
assign csr_umii_fault[19] = 1'b0;
assign csr_umii_fault[20] = 1'b0;
assign csr_umii_fault[21] = 1'b0;
assign csr_umii_fault[22] = 1'b0;
assign csr_umii_fault[23] = 1'b0;
assign csr_umii_fault[24] = 1'b0;
assign csr_umii_fault[25] = 1'b0;
assign csr_umii_fault[26] = 1'b0;
assign csr_umii_fault[27] = 1'b0;
assign csr_umii_fault[28] = 1'b0;
assign csr_umii_fault[29] = 1'b0;
assign csr_umii_fault[30] = 1'b0;
assign csr_umii_fault[31] = 1'b0;

assign dl_flag[0] = dl_tx_measure_valid;
assign dl_flag[1] = dl_rx_measure_valid;
assign dl_flag[2] = dl_tx_reset;
assign dl_flag[3] = dl_rx_reset;
assign dl_flag[4] = 1'b0;
assign dl_flag[5] = 1'b0;
assign dl_flag[6] = 1'b0;
assign dl_flag[7] = 1'b0;
assign dl_flag[8] = 1'b0;
assign dl_flag[9] = 1'b0;
assign dl_flag[10] = 1'b0;
assign dl_flag[11] = 1'b0;
assign dl_flag[12] = 1'b0;
assign dl_flag[13] = 1'b0;
assign dl_flag[14] = 1'b0;
assign dl_flag[15] = 1'b0;
assign dl_flag[16] = 1'b0;
assign dl_flag[17] = 1'b0;
assign dl_flag[18] = 1'b0;
assign dl_flag[19] = 1'b0;
assign dl_flag[20] = 1'b0;
assign dl_flag[21] = 1'b0;
assign dl_flag[22] = 1'b0;
assign dl_flag[23] = 1'b0;
assign dl_flag[24] = 1'b0;
assign dl_flag[25] = 1'b0;
assign dl_flag[26] = 1'b0;
assign dl_flag[27] = 1'b0;
assign dl_flag[28] = 1'b0;
assign dl_flag[29] = 1'b0;
assign dl_flag[30] = 1'b0;
assign dl_flag[31] = 1'b0;

assign dl_tx_latency[0] = dl_tx[0];
assign dl_tx_latency[1] = dl_tx[1];
assign dl_tx_latency[2] = dl_tx[2];
assign dl_tx_latency[3] = dl_tx[3];
assign dl_tx_latency[4] = dl_tx[4];
assign dl_tx_latency[5] = dl_tx[5];
assign dl_tx_latency[6] = dl_tx[6];
assign dl_tx_latency[7] = dl_tx[7];
assign dl_tx_latency[8] = dl_tx[8];
assign dl_tx_latency[9] = dl_tx[9];
assign dl_tx_latency[10] = dl_tx[10];
assign dl_tx_latency[11] = dl_tx[11];
assign dl_tx_latency[12] = dl_tx[12];
assign dl_tx_latency[13] = dl_tx[13];
assign dl_tx_latency[14] = dl_tx[14];
assign dl_tx_latency[15] = dl_tx[15];
assign dl_tx_latency[16] = dl_tx[16];
assign dl_tx_latency[17] = dl_tx[17];
assign dl_tx_latency[18] = dl_tx[18];
assign dl_tx_latency[19] = dl_tx[19];
assign dl_tx_latency[20] = dl_tx[20];
assign dl_tx_latency[21] = 1'b0;
assign dl_tx_latency[22] = 1'b0;
assign dl_tx_latency[23] = 1'b0;
assign dl_tx_latency[24] = 1'b0;
assign dl_tx_latency[25] = 1'b0;
assign dl_tx_latency[26] = 1'b0;
assign dl_tx_latency[27] = 1'b0;
assign dl_tx_latency[28] = 1'b0;
assign dl_tx_latency[29] = 1'b0;
assign dl_tx_latency[30] = 1'b0;
assign dl_tx_latency[31] = 1'b0;

assign dl_rx_latency[0] = dl_rx[0];
assign dl_rx_latency[1] = dl_rx[1];
assign dl_rx_latency[2] = dl_rx[2];
assign dl_rx_latency[3] = dl_rx[3];
assign dl_rx_latency[4] = dl_rx[4];
assign dl_rx_latency[5] = dl_rx[5];
assign dl_rx_latency[6] = dl_rx[6];
assign dl_rx_latency[7] = dl_rx[7];
assign dl_rx_latency[8] = dl_rx[8];
assign dl_rx_latency[9] = dl_rx[9];
assign dl_rx_latency[10] = dl_rx[10];
assign dl_rx_latency[11] = dl_rx[11];
assign dl_rx_latency[12] = dl_rx[12];
assign dl_rx_latency[13] = dl_rx[13];
assign dl_rx_latency[14] = dl_rx[14];
assign dl_rx_latency[15] = dl_rx[15];
assign dl_rx_latency[16] = dl_rx[16];
assign dl_rx_latency[17] = dl_rx[17];
assign dl_rx_latency[18] = dl_rx[18];
assign dl_rx_latency[19] = dl_rx[19];
assign dl_rx_latency[20] = dl_rx[20];
assign dl_rx_latency[21] = 1'b0;
assign dl_rx_latency[22] = 1'b0;
assign dl_rx_latency[23] = 1'b0;
assign dl_rx_latency[24] = 1'b0;
assign dl_rx_latency[25] = 1'b0;
assign dl_rx_latency[26] = 1'b0;
assign dl_rx_latency[27] = 1'b0;
assign dl_rx_latency[28] = 1'b0;
assign dl_rx_latency[29] = 1'b0;
assign dl_rx_latency[30] = 1'b0;
assign dl_rx_latency[31] = 1'b0;

assign dl_count_valid[0] = dl_rx_async_count_valid;
assign dl_count_valid[1] = dl_rx_sync_count_valid;
assign dl_count_valid[2] = dl_tx_async_count_valid;
assign dl_count_valid[3] = dl_tx_sync_count_valid;
assign dl_count_valid[4] = 1'b0;
assign dl_count_valid[5] = 1'b0;
assign dl_count_valid[6] = 1'b0;
assign dl_count_valid[7] = 1'b0;
assign dl_count_valid[8] = 1'b0;
assign dl_count_valid[9] = 1'b0;
assign dl_count_valid[10] = 1'b0;
assign dl_count_valid[11] = 1'b0;
assign dl_count_valid[12] = 1'b0;
assign dl_count_valid[13] = 1'b0;
assign dl_count_valid[14] = 1'b0;
assign dl_count_valid[15] = 1'b0;
assign dl_count_valid[16] = 1'b0;
assign dl_count_valid[17] = 1'b0;
assign dl_count_valid[18] = 1'b0;
assign dl_count_valid[19] = 1'b0;
assign dl_count_valid[20] = 1'b0;
assign dl_count_valid[21] = 1'b0;
assign dl_count_valid[22] = 1'b0;
assign dl_count_valid[23] = 1'b0;
assign dl_count_valid[24] = 1'b0;
assign dl_count_valid[25] = 1'b0;
assign dl_count_valid[26] = 1'b0;
assign dl_count_valid[27] = 1'b0;
assign dl_count_valid[28] = 1'b0;
assign dl_count_valid[29] = 1'b0;
assign dl_count_valid[30] = 1'b0;
assign dl_count_valid[31] = 1'b0;

assign dl_tx_sync[0] = dl_tx_sync_count[0];
assign dl_tx_sync[1] = dl_tx_sync_count[1];
assign dl_tx_sync[2] = dl_tx_sync_count[2];
assign dl_tx_sync[3] = dl_tx_sync_count[3];
assign dl_tx_sync[4] = dl_tx_sync_count[4];
assign dl_tx_sync[5] = dl_tx_sync_count[5];
assign dl_tx_sync[6] = dl_tx_sync_count[6];
assign dl_tx_sync[7] = dl_tx_sync_count[7];
assign dl_tx_sync[8] = dl_tx_sync_count[8];
assign dl_tx_sync[9] = dl_tx_sync_count[9];
assign dl_tx_sync[10] = dl_tx_sync_count[10];
assign dl_tx_sync[11] = dl_tx_sync_count[11];
assign dl_tx_sync[12] = dl_tx_sync_count[12];
assign dl_tx_sync[13] = dl_tx_sync_count[13];
assign dl_tx_sync[14] = dl_tx_sync_count[14];
assign dl_tx_sync[15] = dl_tx_sync_count[15];
assign dl_tx_sync[16] = dl_tx_sync_count[16];
assign dl_tx_sync[17] = dl_tx_sync_count[17];
assign dl_tx_sync[18] = dl_tx_sync_count[18];
assign dl_tx_sync[19] = dl_tx_sync_count[19];
assign dl_tx_sync[20] = 1'b0;
assign dl_tx_sync[21] = 1'b0;
assign dl_tx_sync[22] = 1'b0;
assign dl_tx_sync[23] = 1'b0;
assign dl_tx_sync[24] = 1'b0;
assign dl_tx_sync[25] = 1'b0;
assign dl_tx_sync[26] = 1'b0;
assign dl_tx_sync[27] = 1'b0;
assign dl_tx_sync[28] = 1'b0;
assign dl_tx_sync[29] = 1'b0;
assign dl_tx_sync[30] = 1'b0;
assign dl_tx_sync[31] = 1'b0;

assign dl_tx_async[0] = dl_tx_async_count[0];
assign dl_tx_async[1] = dl_tx_async_count[1];
assign dl_tx_async[2] = dl_tx_async_count[2];
assign dl_tx_async[3] = dl_tx_async_count[3];
assign dl_tx_async[4] = dl_tx_async_count[4];
assign dl_tx_async[5] = dl_tx_async_count[5];
assign dl_tx_async[6] = dl_tx_async_count[6];
assign dl_tx_async[7] = dl_tx_async_count[7];
assign dl_tx_async[8] = dl_tx_async_count[8];
assign dl_tx_async[9] = dl_tx_async_count[9];
assign dl_tx_async[10] = dl_tx_async_count[10];
assign dl_tx_async[11] = dl_tx_async_count[11];
assign dl_tx_async[12] = dl_tx_async_count[12];
assign dl_tx_async[13] = dl_tx_async_count[13];
assign dl_tx_async[14] = dl_tx_async_count[14];
assign dl_tx_async[15] = dl_tx_async_count[15];
assign dl_tx_async[16] = dl_tx_async_count[16];
assign dl_tx_async[17] = dl_tx_async_count[17];
assign dl_tx_async[18] = dl_tx_async_count[18];
assign dl_tx_async[19] = dl_tx_async_count[19];
assign dl_tx_async[20] = 1'b0;
assign dl_tx_async[21] = 1'b0;
assign dl_tx_async[22] = 1'b0;
assign dl_tx_async[23] = 1'b0;
assign dl_tx_async[24] = 1'b0;
assign dl_tx_async[25] = 1'b0;
assign dl_tx_async[26] = 1'b0;
assign dl_tx_async[27] = 1'b0;
assign dl_tx_async[28] = 1'b0;
assign dl_tx_async[29] = 1'b0;
assign dl_tx_async[30] = 1'b0;
assign dl_tx_async[31] = 1'b0;

assign dl_rx_sync[0] = dl_rx_sync_count[0];
assign dl_rx_sync[1] = dl_rx_sync_count[1];
assign dl_rx_sync[2] = dl_rx_sync_count[2];
assign dl_rx_sync[3] = dl_rx_sync_count[3];
assign dl_rx_sync[4] = dl_rx_sync_count[4];
assign dl_rx_sync[5] = dl_rx_sync_count[5];
assign dl_rx_sync[6] = dl_rx_sync_count[6];
assign dl_rx_sync[7] = dl_rx_sync_count[7];
assign dl_rx_sync[8] = dl_rx_sync_count[8];
assign dl_rx_sync[9] = dl_rx_sync_count[9];
assign dl_rx_sync[10] = dl_rx_sync_count[10];
assign dl_rx_sync[11] = dl_rx_sync_count[11];
assign dl_rx_sync[12] = dl_rx_sync_count[12];
assign dl_rx_sync[13] = dl_rx_sync_count[13];
assign dl_rx_sync[14] = dl_rx_sync_count[14];
assign dl_rx_sync[15] = dl_rx_sync_count[15];
assign dl_rx_sync[16] = dl_rx_sync_count[16];
assign dl_rx_sync[17] = dl_rx_sync_count[17];
assign dl_rx_sync[18] = dl_rx_sync_count[18];
assign dl_rx_sync[19] = dl_rx_sync_count[19];
assign dl_rx_sync[20] = 1'b0;
assign dl_rx_sync[21] = 1'b0;
assign dl_rx_sync[22] = 1'b0;
assign dl_rx_sync[23] = 1'b0;
assign dl_rx_sync[24] = 1'b0;
assign dl_rx_sync[25] = 1'b0;
assign dl_rx_sync[26] = 1'b0;
assign dl_rx_sync[27] = 1'b0;
assign dl_rx_sync[28] = 1'b0;
assign dl_rx_sync[29] = 1'b0;
assign dl_rx_sync[30] = 1'b0;
assign dl_rx_sync[31] = 1'b0;

assign dl_rx_async[0] = dl_rx_async_count[0];
assign dl_rx_async[1] = dl_rx_async_count[1];
assign dl_rx_async[2] = dl_rx_async_count[2];
assign dl_rx_async[3] = dl_rx_async_count[3];
assign dl_rx_async[4] = dl_rx_async_count[4];
assign dl_rx_async[5] = dl_rx_async_count[5];
assign dl_rx_async[6] = dl_rx_async_count[6];
assign dl_rx_async[7] = dl_rx_async_count[7];
assign dl_rx_async[8] = dl_rx_async_count[8];
assign dl_rx_async[9] = dl_rx_async_count[9];
assign dl_rx_async[10] = dl_rx_async_count[10];
assign dl_rx_async[11] = dl_rx_async_count[11];
assign dl_rx_async[12] = dl_rx_async_count[12];
assign dl_rx_async[13] = dl_rx_async_count[13];
assign dl_rx_async[14] = dl_rx_async_count[14];
assign dl_rx_async[15] = dl_rx_async_count[15];
assign dl_rx_async[16] = dl_rx_async_count[16];
assign dl_rx_async[17] = dl_rx_async_count[17];
assign dl_rx_async[18] = dl_rx_async_count[18];
assign dl_rx_async[19] = dl_rx_async_count[19];
assign dl_rx_async[20] = 1'b0;
assign dl_rx_async[21] = 1'b0;
assign dl_rx_async[22] = 1'b0;
assign dl_rx_async[23] = 1'b0;
assign dl_rx_async[24] = 1'b0;
assign dl_rx_async[25] = 1'b0;
assign dl_rx_async[26] = 1'b0;
assign dl_rx_async[27] = 1'b0;
assign dl_rx_async[28] = 1'b0;
assign dl_rx_async[29] = 1'b0;
assign dl_rx_async[30] = 1'b0;
assign dl_rx_async[31] = 1'b0;

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        avs_readdata <= 32'h0000_0000;
    end
    else begin
        if(avs_read) begin
            case (avs_address)
                6'h00 : avs_readdata <= csr_control;
                6'h01 : avs_readdata <= csr_status;
                6'h04 : avs_readdata <= csr_dev_ability;
                6'h05 : avs_readdata <= csr_partner_ability;
                6'h12 : avs_readdata <= csr_an_link_timer;
                6'h15 : avs_readdata <= csr_umii_fault;
                6'h20 : avs_readdata <= dl_flag;
                6'h21 : avs_readdata <= dl_tx_latency;
                6'h22 : avs_readdata <= dl_rx_latency;
                6'h23 : avs_readdata <= dl_count_valid;
                6'h24 : avs_readdata <= dl_tx_sync;
                6'h25 : avs_readdata <= dl_tx_async;
                6'h26 : avs_readdata <= dl_rx_sync;
                6'h27 : avs_readdata <= dl_rx_async;
                default : avs_readdata <= 32'h0000_0000;
            endcase
        end
        else begin
            avs_readdata <= avs_readdata;
        end
    end
end
endmodule

