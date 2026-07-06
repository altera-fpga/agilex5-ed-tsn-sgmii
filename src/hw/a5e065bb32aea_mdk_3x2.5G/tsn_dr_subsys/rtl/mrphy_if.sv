//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2024 Intel Corporation.
//
//****************************************************************************

import mrphy_pkg::*;

// MAC TX interface
interface mrphy_mac_tx_if;
    logic       txen;
    logic [7:0] tx_d;
    logic       txer;
    logic [1:0] mac_speed;
    modport phy (
        input  txen, tx_d, txer, mac_speed
    );
endinterface

// MAC RX interface
interface mrphy_mac_rx_if;
    logic       rxdv;
    logic [7:0] rxd;
    logic       rxer;
    modport phy (
        input  rxdv, rxd, rxer);

    modport mac (
        output rxdv, rxd, rxer
    );


endinterface

// CSR interface
interface mrphy_csr_if;
    // Write side
    logic        clk;
    logic [15:0] writedata;
    logic [4:0]  address;
    logic        read;
    logic        write;
    logic        burstcount;
    logic [3:0]  byteenable;
    logic        debugaccess;
    // Read side
    logic [15:0] readdata;
    logic        waitrequest;
    modport phy (
        input  clk, writedata, address, read, write, burstcount, byteenable, debugaccess,
        output readdata, waitrequest
    );
endinterface

// GMII8B adapter interface
interface mrphy_adapter_if;
    logic gmii8b_tx_clkin;
    logic gmii8b_tx_rst_n;
    logic gmii8b_rx_rst_n;
    logic gmii8b_rx_clkout;
    logic gmii8b_tx_clkout;
    modport phy (
        input  gmii8b_tx_clkin, gmii8b_tx_rst_n, gmii8b_rx_rst_n,
        output gmii8b_rx_clkout, gmii8b_tx_clkout
    );
endinterface

// Latency interface
interface mrphy_latency_if;
    logic [21:0] tx_latency;
    logic [21:0] rx_latency;
    logic        measure_clk;
    logic        sclk;
    modport phy (
        input  measure_clk, sclk,
        output tx_latency, rx_latency
    );
endinterface

// Reset interface
interface mrphy_reset_if;
    logic reset;
    logic rx_digitalreset;
    logic tx_digitalreset;
    logic i_rst_n;
    logic i_tx_rst_n;
    logic i_rx_rst_n;
    logic o_rst_ack_n;
    logic o_tx_rst_ack_n;
    logic o_rx_rst_ack_n;
    modport phy (
        input  reset, rx_digitalreset, tx_digitalreset, i_rst_n, i_tx_rst_n, i_rx_rst_n,
        output o_rst_ack_n, o_tx_rst_ack_n, o_rx_rst_ack_n
    );
endinterface

// Reconfig interface
interface mrphy_reconfig_if;
    logic        clk;
    logic        reset;
    logic        write;
    logic        read;
    logic [17:0] address;
    logic [3:0]  be;
    logic [31:0] writedata;
    logic [31:0] readdata;
    logic        waitrequest;
    logic        readdatavalid;
    modport phy (
        input  clk, reset, write, read, address, be, writedata,
        output readdata, waitrequest, readdatavalid
    );
endinterface

// Serial interface
interface mrphy_serial_if;
    logic tx_serial_data;
    logic tx_serial_data_n;
    logic rx_serial_data;
    logic rx_serial_data_n;
    modport phy (
        input  rx_serial_data, rx_serial_data_n,
        output tx_serial_data, tx_serial_data_n
    );
endinterface

// Misc interface
interface mrphy_misc_if;
    logic [1:0] xcvr_mode;
    logic  rx_cdr_refclk_p;
    logic  tx_pll_refclk_p;
    logic  tx_clkout;
    logic  rx_clkout;
    logic  led_link;
    logic  led_char_err;
    logic  led_disp_err;
    logic  led_an;
    logic [2:0] operating_speed;
    logic  mrphy_pll_lock;
    logic  o_src_rs_req;
    logic  o_refclk_bus_out;
    logic  rx_is_lockedtodata;
    logic  tx_ready;
    logic  rx_ready;
    logic  rx_pma_clkout;
    modport phy (
        input  xcvr_mode, rx_cdr_refclk_p, tx_pll_refclk_p,
        output tx_clkout, rx_clkout, led_link, led_char_err, led_disp_err, led_an,
               operating_speed, mrphy_pll_lock, o_src_rs_req, o_refclk_bus_out, rx_is_lockedtodata,
               tx_ready, rx_ready, rx_pma_clkout
    );
endinterface
