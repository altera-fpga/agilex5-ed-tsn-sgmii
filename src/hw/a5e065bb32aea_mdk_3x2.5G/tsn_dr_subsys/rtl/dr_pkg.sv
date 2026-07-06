//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2024 Intel Corporation.
//
//****************************************************************************

package dr_pkg;

    // DR LAVMM channel signals (address, data, strobes, etc)
    typedef struct packed {
        logic [20:0] addr;
        logic [3:0]  be;
        logic        clk;
        logic        read;
        logic        rstn;
        logic [31:0] wdata;
        logic        write;
        logic [31:0] rdata;
        logic        rdata_valid;
        logic        waitreq;
    } dr_lavmm_t;

    // Pause/Grant per channel
    typedef struct packed {
        logic src_pause_request;
        logic src_pause_grant;
    } pause_t;

    // RS Grant/Request per channel
    typedef struct packed {
        logic rs_grant;
        logic rs_request;
    } grant_t;

 endpackage : dr_pkg
