//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2024 Intel Corporation.
//
//****************************************************************************

package mrphy_pkg;

    // GMII8B MAC TX signals
    typedef struct packed {
        logic       txen;
        logic [7:0] tx_d;
        logic       txer;
        logic [1:0] mac_speed;
    } gmii8b_mac_tx_t;

    // GMII8B MAC RX signals
    typedef struct packed {
        logic       rxdv;
        logic [7:0] rxd;
        logic       rxer;
    } gmii8b_mac_rx_t;

    // CSR read signals
    typedef struct packed {
        logic [15:0] readdata;
        logic        waitrequest;
    } csr_read_t;

    // CSR write signals
    typedef struct packed {
        logic        clk;
        logic [15:0] writedata;
        logic [4:0]  address;
        logic        read;
        logic        write;
        logic        burstcount;
        logic [1:0]  byteenable;
        logic        debugaccess;
    } csr_write_t;

    // LED outputs
    typedef struct packed {
        logic link;
        logic char_err;
        logic disp_err;
        logic an;
    } led_t;

    // Latency outputs
    typedef struct packed {
        logic [21:0] tx_latency;
        logic [21:0] rx_latency;
        logic        measure_clk;
        logic         sclk;
    } latency_t;

    // SERDES signals
    typedef struct packed {
        logic  tx_serial_data;
        logic  tx_serial_data_n;
        logic  rx_serial_data;
        logic  rx_serial_data_n;
    } serdes_t;

    // Reconfiguration interface
    typedef struct packed {
        logic    clk;
        logic    reset;
        logic    write;
        logic    read;
        logic [17:0]  address;
        logic [3:0]   be;
        logic [31:0]  writedata;
        logic [31:0]  readdata;
        logic    waitrequest;
        logic    readdatavalid;
    } reconfig_t;

    // Adapter signals (example, add/modify as needed)
    typedef struct packed {
        logic gmii8b_tx_clkin;
        logic gmii8b_tx_rst_n;
        logic gmii8b_rx_rst_n;
        logic gmii8b_rx_clkout;
        logic gmii8b_tx_clkout;
    } gmii8b_adapter_t;

    // Reset signals (example, add/modify as needed)
    typedef struct packed {
        logic reset;
        logic rx_digitalreset;
        logic tx_digitalreset;
        logic i_rst_n;
        logic i_tx_rst_n;
        logic i_rx_rst_n;
        logic o_rst_ack_n;
        logic o_tx_rst_ack_n;
        logic o_rx_rst_ack_n;
    } reset_t;

    // Misc signals (example, add/modify as needed)
    typedef struct packed {
        logic [1:0] xcvr_mode;
        logic  rx_cdr_refclk_p;
        logic  tx_pll_refclk_p; 
        logic       tx_clkout;
        logic       rx_clkout;
        logic       led_link;
        logic       led_char_err;
        logic       led_disp_err;
        logic       led_an;
        logic [2:0] operating_speed;
        logic       mrphy_pll_lock;
        logic       o_src_rs_req;
        logic       o_refclk_bus_out;
        logic       rx_is_lockedtodata;
        logic       tx_ready;
        logic       rx_ready;
        logic       rx_pma_clkout;
    } misc_t;

endpackage : mrphy_pkg
