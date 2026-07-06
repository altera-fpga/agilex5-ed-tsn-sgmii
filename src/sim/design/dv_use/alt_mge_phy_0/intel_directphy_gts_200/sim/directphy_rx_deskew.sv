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


`timescale 1 ps/1 ps
module directphy_rx_deskew #(
    parameter WIDTH         = 64,
    parameter LANES         = 2,
    parameter SIM_EMULATE   = 0
) (
    input   logic                           i_clk,
    input   logic                           i_reset,
    input   logic [0:LANES-1][WIDTH-1:0]    i_data,
    input   logic [0:LANES-1]               i_sync_pulse,
    output  logic [0:LANES-1][WIDTH-1:0]    o_data,
    output  logic                           o_deskew_done
);

    logic   initial_sync_received;
    logic   [15:0]  startup_timer;
    logic           ready;

    logic   [15:0]              gap_timer;
    logic   [0:LANES-1]         incr_delay;
    logic   [0:LANES-1]         incr_delay_masked;
    logic   [0:LANES-1][2:0]    delay;
    logic   [0:LANES-1]         sync_pulses_delay;


    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            initial_sync_received   <= 1'b0;
        end else begin
            initial_sync_received   <= initial_sync_received | (|i_sync_pulse);//RG added paranthesis to make spyglass happy
        end 

        if (i_reset) begin
            startup_timer           <= 16'b0;
        end else begin
            startup_timer           <= {initial_sync_received, startup_timer[14:1]};
        end

        if (i_reset) begin
            gap_timer           <= 16'b0;
        end else begin
            if (sync_pulses_delay) begin
                gap_timer           <= 16'b0;
            end else begin
                gap_timer           <= {1'b1, gap_timer[14:1]};
            end
        end

        if (i_reset) begin
            incr_delay  <= {LANES{1'b0}};
        end else begin
            if (gap_timer[0]) begin
                case (sync_pulses_delay)
                    {LANES{1'b0}}   : incr_delay    <= {LANES{1'b0}};
                    {LANES{1'b1}}   : incr_delay    <= {LANES{1'b0}};
                    default         : incr_delay    <= sync_pulses_delay;
                endcase
            end else begin
                incr_delay    <= {LANES{1'b0}};
            end
        end

        if (i_reset) begin
            incr_delay_masked   <= {LANES{1'b0}};
        end else begin
            if (ready) begin
                incr_delay_masked    <= incr_delay;
            end else begin
                incr_delay_masked   <= {LANES{1'b0}};
            end
        end

        if (i_reset) begin
            o_deskew_done   <= 1'b0;
        end else begin
            o_deskew_done   <= o_deskew_done || &sync_pulses_delay;
        end

    end

    assign ready = startup_timer[0];

    genvar i;
    generate
        for (i = 0; i < LANES; i++) begin : lane_loop

            directphy_word_delay #(
                .WIDTH       (WIDTH+1),
                .SIM_EMULATE (SIM_EMULATE)
            ) lane_delay (
                .i_clk      (i_clk),
                .i_reset    (i_reset),
                .i_delay    (delay[i]),
                .i_data     ({i_sync_pulse[i], i_data[i]}),
                .o_data     ({sync_pulses_delay[i], o_data[i]})
            );

            always_ff @(posedge i_clk) begin
                if (i_reset) begin
                    delay[i]    <= 3'd2;  // 2 is minimum delay
                end else begin
                    delay[i]    <= 3'(delay[i] + incr_delay_masked[i]);//RG added width
                end
            end
        end
    endgenerate

endmodule
