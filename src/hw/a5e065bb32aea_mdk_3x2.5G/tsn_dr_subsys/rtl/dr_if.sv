//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2024 Intel Corporation.
//
//****************************************************************************
import dr_pkg::*;

// DR LAVMM channel interface
interface dr_lavmm_if;
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

    modport dr (
        input  addr, be, clk, read, rstn, wdata, write,
        output rdata, rdata_valid, waitreq
    );
endinterface

// Pause/Grant interface
interface pause_if;
    logic src_pause_request;
    logic src_pause_grant;

    modport dr (
        input  src_pause_request,
        output src_pause_grant
    );
endinterface

// RS Grant/Request interface
interface grant_if;
    logic rs_grant;
    logic rs_request;

    modport dr (
        input  rs_grant,
        output rs_request
    );
endinterface
