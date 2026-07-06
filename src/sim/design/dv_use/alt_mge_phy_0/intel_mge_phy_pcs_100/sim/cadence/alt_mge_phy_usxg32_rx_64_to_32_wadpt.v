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


//------------------------------------------------------------------------
// This module is designed to convert XGMII data width from
// N to N/2 with data_valid. This module supports only gearbox
// ratio 32/66, where data_valid_in is not expected to assert
// continuously for more than two clock cycles, otherwise wrong
// output or error is possible.
//------------------------------------------------------------------------

`timescale 1 ps / 1 ps

module alt_mge_phy_usxg32_rx_64_to_32_wadpt #(
    parameter DATA_WIDTH        = 'd64,
    parameter CONTROL_WIDTH     = 'd8
) (
    input  wire                         rst_n,              // Write Domain Active low Reset
    input  wire                         clk,                // Write Domain Clock
    input  wire [CONTROL_WIDTH-1:0]     control_in,         // Frame information 
    input  wire [DATA_WIDTH-1:0]        data_in,            // Write Data In
    input  wire                         data_valid_in,      // Write Data In Valid
    input  wire                         block_lock_in,      // Block Lock In (aligned to data_in)
    
    input  wire                         dl_sync_pulse_in,   // Agilex USXGMII 1588 sync pulse input from eth_f NPHY

    output  reg [CONTROL_WIDTH/2-1:0]   control_out,        // Frame information
    output  reg [DATA_WIDTH/2-1:0]      data_out,           // Read Data Out
    output  reg                         data_valid_out,     // Read Data Out Valid
    output  reg                         block_lock_out,     // Block Lock Out (aligned to data_out)
    
    output  reg                         dl_sync_pulse_out   // Agilex USXGMII 1588 sync pulse output to MAC
);
    
    // ------------------------------------------------------------------
    // Parameters
    // ------------------------------------------------------------------
    localparam STATE_IDLE       = 2'b00;
    localparam STATE_MSB        = 2'b01;
    localparam STATE_LATCH_LSB  = 2'b10;
    // ------------------------------------------------------------------
    // Wires and Registers
    // ------------------------------------------------------------------
    reg  [1:0]                  sm_state;
    reg                         block_lock_r;
    reg                         dl_sync_pulse_out_r;
    reg  [DATA_WIDTH/2-1:0]     data_in_lsb_r;
    reg  [CONTROL_WIDTH/2-1:0]  control_in_lsb_r;
    reg  [DATA_WIDTH/2-1:0]     data_in_msb_r;
    reg  [CONTROL_WIDTH/2-1:0]  control_in_msb_r;
    wire [DATA_WIDTH/2-1:0]     data_in_lsb_w;
    wire [CONTROL_WIDTH/2-1:0]  control_in_lsb_w;
    
    assign data_in_lsb_w    = data_in [DATA_WIDTH/2-1:0];
    assign control_in_lsb_w = control_in [CONTROL_WIDTH/2-1:0];
    // ------------------------------------------------------------------
    // Width conversion state machine
    // ------------------------------------------------------------------
    always @(negedge rst_n or posedge clk) begin
        if (rst_n == 1'b0) begin
            data_in_lsb_r	    <= 'd0;
            control_in_lsb_r	<= 'd0;
            data_in_msb_r	    <= 'd0;
            control_in_msb_r	<= 'd0;
            sm_state            <= STATE_IDLE;
            data_out            <= 'd0;
            control_out         <= 'd0;
            data_valid_out      <= 1'b0;
            block_lock_r        <= 1'b0;
            block_lock_out      <= 1'b0;
            dl_sync_pulse_out  <= 1'b0;
            dl_sync_pulse_out_r<= 1'b0;
        end
        else begin
            // assertion: for every asserted data_valid_in, must followed by 2 data_valid_out
            // assert property (@(posedge clk) data_valid_in |-> ##1 data_valid_out[*2])
            // else $error("data_valid_out is not asserted for 2 cycles after data_valid_in is asserted");
            
            case(sm_state)
            STATE_IDLE: begin
                if (data_valid_in) begin
                    data_in_msb_r       <= data_in [DATA_WIDTH-1:DATA_WIDTH/2];
                    control_in_msb_r    <= control_in [CONTROL_WIDTH-1:CONTROL_WIDTH/2];
                    block_lock_r        <= block_lock_in;
                    data_valid_out      <= 1'b1;
                    data_out            <= data_in_lsb_w;
                    control_out         <= control_in_lsb_w;
                    block_lock_out      <= block_lock_in;
                    sm_state            <= STATE_MSB;
                    dl_sync_pulse_out  <= dl_sync_pulse_in;
                end
                else begin
                    data_valid_out      <= 1'b0;
                end
            end
            STATE_MSB: begin
                data_valid_out          <= 1'b1;
                data_out                <= data_in_msb_r;
                control_out             <= control_in_msb_r;
                block_lock_out          <= block_lock_r;
                dl_sync_pulse_out      <= 1'b0;
                if (data_valid_in) begin
                    data_in_msb_r       <= data_in [DATA_WIDTH-1:DATA_WIDTH/2];
                    control_in_msb_r    <= control_in [CONTROL_WIDTH-1:CONTROL_WIDTH/2];
                    data_in_lsb_r       <= data_in [DATA_WIDTH/2-1:0];
                    control_in_lsb_r    <= control_in [CONTROL_WIDTH/2-1:0];
                    block_lock_r        <= block_lock_in;
                    sm_state            <= STATE_LATCH_LSB;
                    dl_sync_pulse_out_r<= dl_sync_pulse_in;
                end
                else begin
                    sm_state            <= STATE_IDLE;
                end
            end
            STATE_LATCH_LSB: begin
                data_valid_out          <= 1'b1;
                data_out                <= data_in_lsb_r;
                control_out             <= control_in_lsb_r;
                block_lock_out          <= block_lock_r;
                sm_state                <= STATE_MSB;
                dl_sync_pulse_out      <= dl_sync_pulse_out_r;
                
                // assertion: data_valid_in is not expected to assert in this state
                // assert (!data_valid_in) else $error("more than 2 continuous data_valid_in is not expected");
            end
            default: begin
                data_in_lsb_r           <= data_in_lsb_r;
                control_in_lsb_r        <= control_in_lsb_r;
                data_in_msb_r           <= data_in_msb_r;
                control_in_msb_r        <= control_in_msb_r;
                sm_state                <= sm_state;
                data_out                <= data_out;
                control_out             <= control_out;
                data_valid_out          <= 1'b0;
                block_lock_r            <= block_lock_r;
                block_lock_out          <= block_lock_out;
                dl_sync_pulse_out      <= 1'b0;
            end
            endcase
        end
    end
    
    
endmodule // alt_mge_phy_usxg32_rx_64_to_32_wadpt
