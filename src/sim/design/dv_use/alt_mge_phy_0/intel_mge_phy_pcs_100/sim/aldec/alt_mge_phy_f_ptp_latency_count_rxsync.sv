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


`timescale 1ps/1ps

module alt_mge_phy_f_ptp_latency_count_rxsync 
#(
    parameter COUNT_WIDTH = 8,
    parameter DL_TOT_MEASURE_CNT = 10
)(
    input wire                      reset,
    input wire                      clk,
    input wire                      start,
    input wire                      stop,
    output reg                      measure_done,
    output reg [COUNT_WIDTH-1:0]    counter_out
);
localparam  INIT         = 2'b00;
localparam  START_CNT    = 2'b01;
localparam  STOP_CNT     = 2'b10;

reg [1:0] cnt_state;
reg stop_d1, stop_d2, stop_d3;
reg start_d1, start_d2, start_d3;
reg [15:0] start_pulse_cnt;
reg [15:0] stop_pulse_cnt;
reg counter_en;
reg [COUNT_WIDTH-1:0] count;
reg [2:0] delay_cnt;

wire start_pulse;
wire stop_pulse;

assign start_pulse = start_d2 ^ start_d3; //detect both edges
assign stop_pulse = stop_d2 & ~stop_d3; // detect rising edge for stop signal (PMA TxData[34], or AM from Tx driver)

always @(posedge clk ) begin
    if(reset) begin
        start_d1 <= 1'b0;
        start_d2 <= 1'b0;
        start_d3 <= 1'b0;
    end else begin
        start_d1 <= start;
        start_d2 <= start_d1;
        start_d3 <= start_d2;
    end
end

always @(posedge clk) begin
    if(reset) begin
        stop_d1 <= 1'b0;
        stop_d2 <= 1'b0;
        stop_d3  <= 1'b0;
    end else begin
        stop_d1 <= stop;
        stop_d2 <= stop_d1;
        stop_d3  <= stop_d2;
    end
end


always@ (posedge clk) begin
    if (reset == 1'b1) begin
        counter_en <= 1'b0;
        start_pulse_cnt <= 16'd0;
        stop_pulse_cnt <= 16'd0;
        delay_cnt <= 3'b000;
        cnt_state <= INIT;
    end
    else if (stop_pulse_cnt < DL_TOT_MEASURE_CNT) begin
        case (cnt_state)
            INIT:begin
                if (stop_pulse) begin
                    delay_cnt <= delay_cnt + 1'b1;
                    if (delay_cnt <= 3'b100)
                        cnt_state <= INIT;
                    else begin 
                        cnt_state <= START_CNT;
                        delay_cnt <= 3'b000;
                    end
                end
            end
        
            START_CNT: begin
                if (start_pulse) begin
                    counter_en <= 1'b1;
                    start_pulse_cnt <= start_pulse_cnt + 1'b1;
                    stop_pulse_cnt <= stop_pulse_cnt;
                    cnt_state <= STOP_CNT;
                end else begin
                    counter_en <= 1'b0;
                    start_pulse_cnt <= start_pulse_cnt;
                    stop_pulse_cnt <= stop_pulse_cnt;
                    cnt_state <= START_CNT;
                end
            end
            
            STOP_CNT: begin
                if(stop_pulse) begin
                    counter_en <= 1'b0;
                    stop_pulse_cnt <= stop_pulse_cnt + 1'b1;
                    start_pulse_cnt <= start_pulse_cnt;
                    cnt_state <= START_CNT;
                end else begin
                    counter_en <= 1'b1;
                    cnt_state <= STOP_CNT;
                    stop_pulse_cnt <= stop_pulse_cnt;
                    start_pulse_cnt <= start_pulse_cnt;
                end
            end
            
            default: begin
                counter_en <= 1'b0;
                start_pulse_cnt <= start_pulse_cnt;
                stop_pulse_cnt <= stop_pulse_cnt;
                cnt_state <= START_CNT;
            end
        endcase
    end
end

always@(posedge clk) begin
    if(reset)begin
        count <= 'd0;
    end
    else if (counter_en) begin
        count <= count + 1'b1;
    end else begin
        count <= count;
    end
end

always@(posedge clk ) begin
    if (reset) begin
        counter_out  <= 'd0;
        measure_done <= 1'b0;
    end else if ((start_pulse_cnt == DL_TOT_MEASURE_CNT ) && (stop_pulse_cnt == DL_TOT_MEASURE_CNT )) begin
        counter_out  <= count;
        measure_done <= 1'b1;
    end
end

endmodule
