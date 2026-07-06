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

module alt_mge_phy_f_ptp_tx_am_muxsel_gen #(
    parameter DL_TOT_MEASURE_CNT      = 10,
    parameter DL_HS_SYNC_PULSE_PERIOD = 48,
    parameter DL_LS_SYNC_PULSE_PERIOD = 264
) (
    input           clk,
    input           reset,
    input           reset_sync_n,
    input           async_pulse,
    input           rate_sel,
    input           valid,
    output          tx_mux_sel,
    output          tx_sync_pulse,
    output          tx_dl_measure_en,
    output          o_tx_sync_pulse_2x_ack
);

    localparam  ASYNC_CNT = DL_TOT_MEASURE_CNT << 1;

    localparam  IDLE                = 3'h0;
    localparam  WAIT_STATE0         = 3'h1;
    localparam  MUX_SEL0            = 3'h2;
    localparam  WAIT_STATE1         = 3'h3;
    localparam  MUX_SEL1            = 3'h4;

    reg [2:0]   state;
    reg         mux_sel_reg;
    reg [8:0]   tot_async_cnt;
    reg [8:0]   cnt_delay0; // Delay between IDLE to async pulses and async pulses to sync pulses
    wire        async_pulse_sync;
    reg         async_pulse_sync_d0;
    reg         dl_measure_en;

    reg [9:0]   sync_counter;
    reg         sync_counter_match;
    reg         hs_sync_counter_match;
    reg         ls_sync_counter_match;
    reg         sync_out;
    reg [1:0]   tx_am_count;
    reg         o_tx_sync_pulse_2x_ack_reg;

    reg         flop_valid_in;
    reg         flop_sync_out;
    reg         reg_and_valid_sync_out;

    wire        wire_valid_sync_out;
    wire        reset_sync;
    wire        reset_n;
    
    assign reset_sync = ~reset_sync_n;
    assign reset_n    = ~reset;

    always@ (posedge clk or posedge reset) begin
        if (reset == 1'b1)  begin
            state               <= IDLE;
            mux_sel_reg         <= 1'b0;
            dl_measure_en       <= 1'b0;
            cnt_delay0          <= 9'b0;
        end else begin
            case (state)
            IDLE: begin
                state           <= WAIT_STATE0;
                mux_sel_reg     <= 1'b0;
                dl_measure_en   <= 1'b0;
                cnt_delay0      <= 9'd0;
            end
            WAIT_STATE0: begin
                if (cnt_delay0 <= 9'd 200) begin
                    cnt_delay0  <= cnt_delay0 + 1'b1;
                    state       <= WAIT_STATE0;
                end else begin
                    state       <= MUX_SEL0;
                    cnt_delay0  <= 9'd0;
                end
                mux_sel_reg     <= 1'b0;
                dl_measure_en   <= 1'b0;
            end
            MUX_SEL0: begin
                if (tot_async_cnt == ASYNC_CNT) begin
                    state       <= WAIT_STATE1;
                end else begin
                    state       <= MUX_SEL0;
                end
                mux_sel_reg     <= 1'b0;
                dl_measure_en   <= 1'b1;
                cnt_delay0      <= 9'd0;
            end
            WAIT_STATE1: begin
                if (cnt_delay0 <= 9'd 200) begin
                    cnt_delay0  <= cnt_delay0 + 1'b1;
                    state       <= WAIT_STATE1;
                end else begin
                    state       <= MUX_SEL1;
                    cnt_delay0  <= 9'd0;
                end
                mux_sel_reg     <= 1'b0;
                dl_measure_en   <= 1'b1;
            end
            MUX_SEL1: begin
                state           <= MUX_SEL1;
                mux_sel_reg     <= 1'b1;
                dl_measure_en   <= 1'b1;
                cnt_delay0      <= 9'd0;
            end
            default: begin
                state           <= IDLE;
                mux_sel_reg     <= 1'b0;
                dl_measure_en   <= 1'b0;
                cnt_delay0      <= 9'd0;
            end
            endcase
        end
    end

    alt_mge_phy_std_synchronizer_nocut #(
            .depth          (2),
            .turn_off_meta  (0)
    ) __syncdata__async_start_sclk_resync (
        .clk        (clk),
        .reset_n    (reset_n),
        .din        (async_pulse),
        .dout       (async_pulse_sync)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            async_pulse_sync_d0 <= 1'b0;
        end else begin
            async_pulse_sync_d0 <= async_pulse_sync;
        end
    end

    // Count the positive edge of sychronized async_pulse
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            tot_async_cnt   <= 9'b0;
        end else begin
            if (async_pulse_sync & ~async_pulse_sync_d0) begin
                tot_async_cnt <= tot_async_cnt + 1'b1;
            end else begin
                tot_async_cnt <= tot_async_cnt;
            end
        end
    end

    always @(posedge clk) begin
        if (reset_sync) begin
            hs_sync_counter_match       <= 1'b0;
        end else begin 
            if (sync_counter == DL_HS_SYNC_PULSE_PERIOD - 2) begin
                hs_sync_counter_match   <= 1'b1;
            end else begin
                hs_sync_counter_match   <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (reset_sync) begin
            ls_sync_counter_match       <= 1'b0;
        end else begin 
            if (sync_counter == DL_LS_SYNC_PULSE_PERIOD - 2) begin
                ls_sync_counter_match   <= 1'b1;
            end else begin
                ls_sync_counter_match   <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (reset_sync) begin
            sync_counter_match  <= 1'b0;
        end else begin 
            sync_counter_match  <= rate_sel? hs_sync_counter_match : ls_sync_counter_match;
        end
    end

    always @(posedge clk) begin
        if (reset_sync) begin
            sync_counter    <= 9'b0;
            sync_out        <= 1'b0;
        end else if (sync_counter_match) begin
            sync_counter    <= 9'b0;
            sync_out        <= 1'b1;
        end else begin
            if (valid) begin
                sync_counter<= sync_counter + 1'b1;
                sync_out    <= 1'b0;
            end else begin
                sync_counter<= sync_counter;
                sync_out    <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (reset_sync) begin
            flop_valid_in <= 1'b0;
        end else begin
            flop_valid_in <= valid;
        end
    end

    always @(posedge clk) begin
        if (reset_sync) begin
            flop_sync_out <= 1'b0;
        end else begin
            flop_sync_out <= sync_out;
        end
    end

    always @(posedge clk) begin
        if (reset_sync) begin
            reg_and_valid_sync_out <= 1'b0;
        end else begin
            reg_and_valid_sync_out <= wire_valid_sync_out;
        end
    end

    // SRC handshake
    always @(posedge clk) begin
        if(reset_sync) begin
            tx_am_count     <= 2'b00;
        end else begin
            if (tx_sync_pulse && (tx_am_count < 2'd2)) begin
                tx_am_count <= tx_am_count + 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if(reset_sync) begin
            o_tx_sync_pulse_2x_ack_reg <= 1'b0;
        end else begin
            if (tx_am_count == 2'd2) begin
                o_tx_sync_pulse_2x_ack_reg <= 1'b1;
            end
        end
    end

    assign tx_mux_sel             = mux_sel_reg;
    assign tx_sync_pulse          = reg_and_valid_sync_out;
    assign tx_dl_measure_en       = dl_measure_en;
    assign wire_valid_sync_out    = flop_valid_in & flop_sync_out;
    assign o_tx_sync_pulse_2x_ack = o_tx_sync_pulse_2x_ack_reg;
 
endmodule
