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
// Module: Altera Ethernet MAC 32-bit TX Frame Muxer 
//
// Description: 
//  * Grant each frame transmission request at frame boundary based on the selected arbitration scheme.
//	    - By default, the request grant is "parked" to normal data frame	
//      - If multiple requests are asserted together, the priority order is Pause -> PFC -> Normal
//  
// Parameter: 
//
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_frm_muxer #(
    parameter TXDATAWIDTH   = 32,
    parameter TXEMPTYWIDTH  = 2,
    parameter TXSRCERRWIDTH = 2
) (
    
    // Clock and reset
    input wire clk,
    input wire rst_n,

    // Ports from TX data frame generator
    input wire                       frm2mx_normfrm_sop,
    input wire                       frm2mx_normfrm_eop,
    input wire                       frm2mx_normfrm_valid,
    input wire [TXDATAWIDTH-1:0]     frm2mx_normfrm_data,
    input wire [TXEMPTYWIDTH-1:0]    frm2mx_normfrm_empty,
    input wire [TXSRCERRWIDTH-1:0]   frm2mx_normfrm_error,
    
    output wire                      mx2frm_normfrm_ready,

    // Ports from TX pause frame generator
    input wire                       frm2mx_pausefrm_sop,
    input wire                       frm2mx_pausefrm_eop,
    input wire                       frm2mx_pausefrm_valid,
    input wire [TXDATAWIDTH-1:0]     frm2mx_pausefrm_data,
    
    output wire                      mx2frm_pausefrm_ready,

    // Ports from TX PFC
    input wire                       frm2mx_pfcfrm_sop,
    input wire                       frm2mx_pfcfrm_eop,
    input wire                       frm2mx_pfcfrm_valid,
    input wire [TXDATAWIDTH-1:0]     frm2mx_pfcfrm_data,
    
    output wire                      mx2frm_pfcfrm_ready,

    // Output ports
    output wire                       mx2rs_sop,
    output wire                       mx2rs_eop,
    output wire                       mx2rs_valid,
    output wire [TXDATAWIDTH-1:0]     mx2rs_data,
    output wire [TXEMPTYWIDTH-1:0]    mx2rs_empty,
    output wire [TXSRCERRWIDTH-1:0]   mx2rs_error,
    output wire [1:0]                 mx2rs_frm_type, 
    output wire [TXSRCERRWIDTH-1:0]   mx2rs_pre_error,
    input wire                       rs2mx_ready

);

    wire p0_req;
    wire p0_reqlast;
    wire p1_req;
    wire p1_reqlast;
    wire p2_req;
    wire p2_reqlast;
    wire [2:0] frmsel; // one-hot
    wire p2_reqgnt;
    wire p1_reqgnt;
    wire p0_reqgnt;

    reg                       muxed_sop;
    reg                       muxed_eop;
    reg                       muxed_valid;
    reg [TXDATAWIDTH-1:0]     muxed_data;
    reg [TXEMPTYWIDTH-1:0]    muxed_empty;
    reg [TXSRCERRWIDTH-1:0]   muxed_error;

    wire int_mx2frm_ready;
    wire [1:0] frm_type;
    
    wire [39:0] in_data;
    wire [39:0] out_data;




    
    assign mx2rs_pre_error = muxed_error;
    //------------------------------------------------------------------------
    // TX frame arbiter port mapping
    //------------------------------------------------------------------------
    assign p0_req       = frm2mx_pausefrm_valid;
    assign p0_reqlast   = frm2mx_pausefrm_eop;
    assign p1_req       = frm2mx_pfcfrm_valid;
    assign p1_reqlast   = frm2mx_pfcfrm_eop;
    assign p2_req       = frm2mx_normfrm_valid;
    assign p2_reqlast   = frm2mx_normfrm_eop;

    //------------------------------------------------------------------------
    // Arbiter
    //------------------------------------------------------------------------
    alt_em10g32_tx_frm_arbiter arbiter_inst (
        .clk    (clk),
        .rst_n  (rst_n),
        
        .ready  (int_mx2frm_ready),
        
        .p0_req (p0_req),
        .p1_req (p1_req),
        .p2_req (p2_req),

        .p0_reqlast (p0_reqlast),
        .p1_reqlast (p1_reqlast),
        .p2_reqlast (p2_reqlast),

        .p0_reqgnt (p0_reqgnt),
        .p1_reqgnt (p1_reqgnt),
        .p2_reqgnt (p2_reqgnt)
    );

    assign frmsel = {p2_reqgnt, p1_reqgnt, p0_reqgnt};

    //------------------------------------------------------------------------
    // MUX
    //------------------------------------------------------------------------
    always @(*) begin
        case (frmsel)
        3'b000: // Artificial delay
                begin
                    muxed_sop   = 1'b0;
                    muxed_valid = 1'b0;
                    muxed_eop   = 1'b0;
                    muxed_data  = {TXDATAWIDTH{1'b0}};
                    muxed_error = {TXSRCERRWIDTH{1'b0}};
                    muxed_empty = {TXEMPTYWIDTH{1'b0}};
                end
        3'b001: // Pause frame
                begin
                    muxed_sop   = frm2mx_pausefrm_sop;
                    muxed_valid = frm2mx_pausefrm_valid;
                    muxed_eop   = frm2mx_pausefrm_eop;
                    muxed_data  = frm2mx_pausefrm_data;
                    muxed_error = {TXSRCERRWIDTH{1'b0}};
                    muxed_empty = {TXEMPTYWIDTH{1'b0}};
                end
        3'b010:  // PFC frame
                begin
                    muxed_sop   = frm2mx_pfcfrm_sop;
                    muxed_valid = frm2mx_pfcfrm_valid;
                    muxed_eop   = frm2mx_pfcfrm_eop;
                    muxed_data  = frm2mx_pfcfrm_data;
                    muxed_error = {TXSRCERRWIDTH{1'b0}};
                    muxed_empty = {TXEMPTYWIDTH{1'b0}};
                end
        3'b100: // Normal data frame
                begin
                    muxed_sop   = frm2mx_normfrm_sop;
                    muxed_valid = frm2mx_normfrm_valid;
                    muxed_eop   = frm2mx_normfrm_eop;
                    muxed_data  = frm2mx_normfrm_data;
                    muxed_error = frm2mx_normfrm_error;
                    muxed_empty = frm2mx_normfrm_empty;
                end
        default: 
                begin
                    muxed_sop   = frm2mx_normfrm_sop;
                    muxed_valid = frm2mx_normfrm_valid;
                    muxed_eop   = frm2mx_normfrm_eop;
                    muxed_data  = frm2mx_normfrm_data;
                    muxed_error = frm2mx_normfrm_error;
                    muxed_empty = frm2mx_normfrm_empty;
                end
        endcase
    end

    //------------------------------------------------------------------------
    // Backpressure
    //------------------------------------------------------------------------
    assign mx2frm_pausefrm_ready    = frmsel[0] & int_mx2frm_ready;
    assign mx2frm_pfcfrm_ready      = frmsel[1] & int_mx2frm_ready;
    assign mx2frm_normfrm_ready     = frmsel[2] & int_mx2frm_ready;

    //------------------------------------------------------------------------
    // Frame Type
    // 00 : reserved
    // 01 : data frm
    // 10 : pause frm
    // 11 : pfc frm
    //------------------------------------------------------------------------
    assign frm_type = { p0_reqgnt | p1_reqgnt, p1_reqgnt | p2_reqgnt};

    //------------------------------------------------------------------------
    // Registered output pipeline
    //------------------------------------------------------------------------
    assign in_data = {frm_type, muxed_error, muxed_empty, muxed_data, muxed_eop, muxed_sop};

    assign mx2rs_sop    = out_data[0];
    assign mx2rs_eop    = out_data[1];
    assign mx2rs_data   = out_data[33:2];
    assign mx2rs_empty  = out_data[35:34];
    assign mx2rs_error  = out_data[37:36];
    assign mx2rs_frm_type = out_data[39:38];

    alt_em10g32_pipeline_base #(
        .SYMBOLS_PER_BEAT(1),
        .BITS_PER_SYMBOL(40),
        .PIPELINE_READY(1)
    ) st_pl_inst (
        .clk        (clk),
        .reset_n    (rst_n),
        .in_ready   (int_mx2frm_ready),
        .in_valid   (muxed_valid),
        .in_data    (in_data),
        .out_ready  (rs2mx_ready),
        .out_valid  (mx2rs_valid),
        .out_data   (out_data)
    );

endmodule


            
