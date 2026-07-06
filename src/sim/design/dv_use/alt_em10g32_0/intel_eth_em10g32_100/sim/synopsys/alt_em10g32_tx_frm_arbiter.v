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


//////////////////////////////////////////////////////////////////////////////
// 
// Module: Altera Ethernet MAC 32-bit TX Frame Arbiter 
//
// Description: 
//  Data frames arbitration
//  
// Parameter: 
//
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_frm_arbiter (
    
    input wire clk,
    input wire rst_n,

    input wire ready,
    
    input wire p0_req,
    input wire p1_req,
    input wire p2_req,

    input wire p0_reqlast,
    input wire p1_reqlast,
    input wire p2_reqlast,

    output wire p0_reqgnt,
    output wire p1_reqgnt,
    output wire p2_reqgnt

);

    localparam PRGNT0 = 2'b00;
    localparam PRGNT1 = 2'b01;
    localparam PRGNT2 = 2'b10;

    reg [1:0] arb_sm_ps;
    reg [1:0] arb_sm_ns;

    //------------------------------------------------------------------------
    // Arbitration state machine
    //------------------------------------------------------------------------
    // SYNC_RESET FLOPS
    always @(posedge clk) begin
        if (!rst_n) begin
            arb_sm_ps <= PRGNT2;
        end
        else begin
            if (ready) 
                arb_sm_ps <= arb_sm_ns;
            else
                arb_sm_ps <= arb_sm_ps;
        end
    end

    // Priority request to 0 -> 1 ->2
    // Default to priority 2 when no request from 0 or 1
    always @(*) begin
        case (arb_sm_ps)
        PRGNT0: if (!p0_req & p1_req) begin
                    arb_sm_ns = PRGNT1;
                end
                else if (!p0_req & !p1_req) begin //BUG: No full streaming if priority given to continuous control of higher priority
                    arb_sm_ns = PRGNT2;
                end
                else arb_sm_ns = arb_sm_ps;
        PRGNT1: if (p0_req && (!p1_req | p1_reqlast)) begin
                    arb_sm_ns = PRGNT0;
                end
                else if (!p0_req & !p1_req) begin 
                    arb_sm_ns = PRGNT2;
                end
                else arb_sm_ns = arb_sm_ps;
        PRGNT2: if (p0_req & (!p2_req | p2_reqlast)) begin
                    arb_sm_ns = PRGNT0;
                end
                else if (!p0_req & p1_req & (!p2_req | p2_reqlast)) begin
                    arb_sm_ns = PRGNT1;
                end
                else arb_sm_ns = arb_sm_ps;
            default: arb_sm_ns = PRGNT2;
        endcase
    end
    
    assign p0_reqgnt = (arb_sm_ps == PRGNT0)? 1'b1 : 1'b0;
    assign p1_reqgnt = (arb_sm_ps == PRGNT1)? 1'b1 : 1'b0;
    assign p2_reqgnt = (arb_sm_ps == PRGNT2)? 1'b1 : 1'b0;

    
endmodule
