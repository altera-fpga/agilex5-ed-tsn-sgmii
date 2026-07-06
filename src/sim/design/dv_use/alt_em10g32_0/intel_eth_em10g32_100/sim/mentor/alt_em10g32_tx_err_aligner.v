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

// altera message_off 10720
// altera message_off 13024 

module alt_em10g32_tx_err_aligner #(
    parameter DELAY = 3
) (
    input wire clk,
    input wire rst_n,
    
    // From frm decoder
    input wire          frm_info_valid,
    input wire [39:0]   frm_info_data,
    input wire [2:0]    frm_info_error,
    
    // From rs layer
    //input wire [31:0]   frm_data,
    //input wire          frm_sop,
    //input wire          frm_eop,
    input wire          frm_valid,
    //input wire [2:0]    frm_empty,
    input wire [1:0]    frm_error,

    output wire          txstatus_valid,
    output wire [39:0]   txstatus_data,
    output wire [6:0]    txstatus_error

);

reg [1:0] shift_reg [(DELAY-1):0];
genvar i;

generate for (i=1; i<DELAY; i=i+1) begin : shift_register
// SYNC_RESET FLOPS
always @(posedge clk) begin
    if (!rst_n) begin
       shift_reg[i] <= 2'b0;
    end
    else begin
        shift_reg[i] <= shift_reg[i-1];
    end
end
end
endgenerate

// TBD error
// SYNC_RESET FLOPS
always @(posedge clk) begin
    if (!rst_n) begin
        shift_reg[0] <= 2'b0;
    end
    else begin
        if (frm_valid)
            shift_reg[0] <= frm_error;
        else
            shift_reg[0] <= 2'b0;
    end
end

assign txstatus_valid   = frm_info_valid;
assign txstatus_data    = frm_info_data;
assign txstatus_error   = {1'b0,shift_reg[(DELAY-1)][0],shift_reg[(DELAY-1)][1],1'b0,frm_info_error}; 


endmodule

