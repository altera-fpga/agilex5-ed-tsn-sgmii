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

module alt_mge_phy_usxg32_incr_cnt
    #(
    parameter COUNTER_WIDTH  = 'd10,
    parameter SPEED_WIDTH    = 'd3
    
    )
    (
    input  wire                             rst_n,          // Active low Reset
    input  wire                             clk,            // Clock
    input  wire                             soft_reset,     // Counter soft reset
    input  wire                             valid,          // valid for counter increment
    input  wire [SPEED_WIDTH-1:0]           speed_mode,      // counter auto reset value
    
    output  reg [COUNTER_WIDTH-1:0]         cnt,             // Counter value
    output  reg                             cnt_zero         // Counter value equals zero
 );

    localparam SPEED_10G         = 3'b000;
    localparam SPEED_1G          = 3'b001;
    localparam SPEED_100M        = 3'b010;
    localparam SPEED_10M         = 3'b011;
    localparam SPEED_2P5G        = 3'b100;
    localparam SPEED_5G          = 3'b101;
    localparam COUNTER_MAX_10G   = 10'd0;   // 1-1
    localparam COUNTER_MAX_5G    = 10'd1;   // 2-1
    localparam COUNTER_MAX_2P5G  = 10'd3;   // 4-1
    localparam COUNTER_MAX_1G    = 10'd9;   // 10-1
    localparam COUNTER_MAX_100M  = 10'd99;  // 100-1
    localparam COUNTER_MAX_10M   = 10'd999; // 1000-1
    
    wire [COUNTER_WIDTH-1:0] max_value;
    reg  [SPEED_WIDTH-1:0]   speed_mode_r;
    wire speed_switch;
    
    assign max_value = (speed_mode == SPEED_10G)   ? COUNTER_MAX_10G   :
                       (speed_mode == SPEED_5G)    ? COUNTER_MAX_5G    :
                       (speed_mode == SPEED_2P5G)  ? COUNTER_MAX_2P5G  :
                       (speed_mode == SPEED_1G)    ? COUNTER_MAX_1G    :
                       (speed_mode == SPEED_100M)  ? COUNTER_MAX_100M  :
                       COUNTER_MAX_10M;
    
    assign speed_switch = (speed_mode_r != speed_mode) ? 1'b1 : 1'b0;
    
    always @(negedge rst_n or posedge clk) begin
        if (rst_n == 1'b0) begin
            cnt <= {COUNTER_WIDTH{1'b0}};
            cnt_zero <= 1'b1;
            speed_mode_r <= SPEED_10G;
        end
        else begin
            speed_mode_r <= speed_mode;
            
            if (soft_reset | speed_switch) begin
                cnt <= {COUNTER_WIDTH{1'b0}};
                cnt_zero <= 1'b1;
            end
            else if (valid) begin
                if (cnt == max_value) begin
                    cnt <= {COUNTER_WIDTH{1'b0}};
                cnt_zero <= 1'b1;
                end
                else begin
                    cnt <= cnt + 1'b1;
                    cnt_zero <= 1'b0;
                end
            end
            
        end
    end
   
endmodule // alt_mge_phy_usxg32_incr_cnt
