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

// Round robin clock crosser
module alt_em10g32_rr_buffer (
    
    clk,
    reset_n,

    // sink
    in_data,
    in_valid,
    in_ready,
    in_startofpacket,
    in_endofpacket,
    in_empty,
    in_error,
    in_channel,

    // source
    out_data,
    out_valid,
    out_ready,
    out_startofpacket,
    out_endofpacket,
    out_empty,
    out_error,
    out_channel

);
    // ---------------------------------------------------------------------
    // Parameters
    // ---------------------------------------------------------------------
    parameter NUM_OF_CHANNEL    = 2;
    
    parameter SYMBOLS_PER_BEAT  = 4;
    parameter BITS_PER_SYMBOL   = 8;
    parameter CHANNEL_WIDTH     = 2;
    parameter ERROR_WIDTH       = 1;
    parameter USE_PACKETS       = 1;
    
    parameter FORWARD_SYNC_DEPTH = 2;
    parameter BACKWARD_SYNC_DEPTH = 2;
    
    parameter USE_OUTPUT_PIPELINE = 0;
    parameter SYNC_RESET_N        = 1;
    
    // Local Parameters
    localparam DATA_WIDTH   = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL;
    localparam EMPTY_WIDTH  = log2ceil(SYMBOLS_PER_BEAT);
    localparam PACKET_SIGNALS_WIDTH = 2 + EMPTY_WIDTH;
    localparam PAYLOAD_WIDTH        = (USE_PACKETS == 1) ?
                                          2 + EMPTY_WIDTH + DATA_WIDTH + ERROR_WIDTH + CHANNEL_WIDTH:
                                          DATA_WIDTH + ERROR_WIDTH + CHANNEL_WIDTH;
    
    // ---------------------------------------------------------------------
    // Input/Output Signals
    // ---------------------------------------------------------------------
    input clk;
    input reset_n;


    input [DATA_WIDTH - 1 : 0] in_data;
    input in_valid;
    input in_startofpacket;
    input in_endofpacket;
    input [((EMPTY_WIDTH > 0)   ? EMPTY_WIDTH - 1   : 0) : 0] in_empty;
    input [((ERROR_WIDTH > 0)   ? ERROR_WIDTH - 1   : 0) : 0] in_error;
    input [(CHANNEL_WIDTH -1):0]in_channel;
    output in_ready;

    output [DATA_WIDTH - 1 : 0] out_data;
    output out_valid;
    output out_startofpacket;
    output out_endofpacket;
    output [((EMPTY_WIDTH > 0)   ? EMPTY_WIDTH - 1   : 0) : 0] out_empty;
    output [((ERROR_WIDTH > 0)   ? ERROR_WIDTH - 1   : 0) : 0] out_error;
    output [(CHANNEL_WIDTH -1):0]out_channel;
    input out_ready;
    
    // ---------------------------------------------------------------------
    // Internal signals
    // ---------------------------------------------------------------------
    wire [PACKET_SIGNALS_WIDTH - 1 : 0] in_packet_signals;
    wire [PACKET_SIGNALS_WIDTH - 1 : 0] out_packet_signals;
    
    wire [PAYLOAD_WIDTH-1 : 0] in_payload;
    
    wire                       pipeline_enc_in_sink_valid;
    wire                       pipeline_enc_in_sink_ready;
    wire [PAYLOAD_WIDTH-1 : 0] pipeline_enc_in_sink_data;
    
    wire                       pipeline_enc_in_src_valid;
    wire                       pipeline_enc_in_src_ready;
    wire [PAYLOAD_WIDTH-1 : 0] pipeline_enc_in_src_data;
    
    wire                       dc_fifo_sink_valid;
    wire                       dc_fifo_sink_ready;
    wire [PAYLOAD_WIDTH-1 : 0] dc_fifo_sink_data;
    
    wire                       dc_fifo_src_valid;
    wire                       dc_fifo_src_ready;
    wire [PAYLOAD_WIDTH-1 : 0] dc_fifo_src_data;
    
    wire [PAYLOAD_WIDTH-1 : 0] out_payload;
    
    genvar i;
    
    // --------------------------------------------------
    // Define Payload
    //
    // Icky part where we decide which signals form the
    // payload to the FIFO.
    // --------------------------------------------------
    generate
        if (EMPTY_WIDTH > 0) begin
            assign in_packet_signals = {in_startofpacket, in_endofpacket, in_empty};
            assign {out_startofpacket, out_endofpacket, out_empty} = out_packet_signals;
        end 
        else begin
            assign out_empty = in_empty;
            assign in_packet_signals = {in_startofpacket, in_endofpacket};
            assign {out_startofpacket, out_endofpacket} = out_packet_signals;
        end
    endgenerate

    generate
        if (USE_PACKETS) begin
            if (ERROR_WIDTH > 0) begin
                if (CHANNEL_WIDTH > 0) begin
                    assign in_payload = {in_packet_signals, in_data, in_error, in_channel};
                    assign {out_packet_signals, out_data, out_error, out_channel} = out_payload;
                end
                else begin
                    assign out_channel = in_channel;
                    assign in_payload = {in_packet_signals, in_data, in_error};
                    assign {out_packet_signals, out_data, out_error} = out_payload;
                end
            end
            else begin
                assign out_error = in_error;
                if (CHANNEL_WIDTH > 0) begin
                    assign in_payload = {in_packet_signals, in_data, in_channel};
                    assign {out_packet_signals, out_data, out_channel} = out_payload;
                end
                else begin
                    assign out_channel = in_channel;
                    assign in_payload = {in_packet_signals, in_data};
                    assign {out_packet_signals, out_data} = out_payload;
                end
            end
        end
        else begin 
            assign out_packet_signals = in_packet_signals;
            if (ERROR_WIDTH > 0) begin
                if (CHANNEL_WIDTH > 0) begin
                    assign in_payload = {in_data, in_error, in_channel};
                    assign {out_data, out_error, out_channel} = out_payload;
                end
                else begin
                    assign out_channel = in_channel;
                    assign in_payload = {in_data, in_error};
                    assign {out_data, out_error} = out_payload;
                end
            end
            else begin
                assign out_error = in_error;
                if (CHANNEL_WIDTH > 0) begin
                    assign in_payload = {in_data, in_channel};
                    assign {out_data, out_channel} = out_payload;
                end
                else begin
                    assign out_channel = in_channel;
                    assign in_payload = in_data;
                    assign out_data = out_payload;
                end
            end
        end
    endgenerate
    
    
    wire [NUM_OF_CHANNEL-1:0] in_valid_ch;
    wire [NUM_OF_CHANNEL-1:0] in_ready_ch;
    wire [PAYLOAD_WIDTH-1:0]  in_data_ch [NUM_OF_CHANNEL-1:0];
    
    wire [NUM_OF_CHANNEL-1:0] out_valid_ch;
    wire [NUM_OF_CHANNEL-1:0] out_ready_ch;
    wire [PAYLOAD_WIDTH-1:0]  out_data_ch [NUM_OF_CHANNEL-1:0];
    
    reg  [NUM_OF_CHANNEL-1:0] in_ch_select;
    reg  [NUM_OF_CHANNEL-1:0] out_ch_select;
    
  generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if(~reset_n) begin
            in_ch_select <= {NUM_OF_CHANNEL{1'b0}};
        end
        else begin
            if(in_valid & in_ready) begin
                if(in_ch_select >= NUM_OF_CHANNEL - 1) begin
                    in_ch_select <= {NUM_OF_CHANNEL{1'b0}};
                end
                else begin
                    in_ch_select <= in_ch_select + 1'b1;
                end
            end
        end
    end
    
    always @(posedge clk) begin
        if(~reset_n) begin
            out_ch_select <= {NUM_OF_CHANNEL{1'b0}};
        end
        else begin
            if(out_valid & out_ready) begin
                if(out_ch_select >= NUM_OF_CHANNEL - 1) begin
                    out_ch_select <= {NUM_OF_CHANNEL{1'b0}};
                end
                else begin
                    out_ch_select <= out_ch_select + 1'b1;
                end
            end
        end
    end
  end else begin
    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            in_ch_select <= {NUM_OF_CHANNEL{1'b0}};
        end
        else begin
            if(in_valid & in_ready) begin
                if(in_ch_select >= NUM_OF_CHANNEL - 1) begin
                    in_ch_select <= {NUM_OF_CHANNEL{1'b0}};
                end
                else begin
                    in_ch_select <= in_ch_select + 1'b1;
                end
            end
        end
    end
    
    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            out_ch_select <= {NUM_OF_CHANNEL{1'b0}};
        end
        else begin
            if(out_valid & out_ready) begin
                if(out_ch_select >= NUM_OF_CHANNEL - 1) begin
                    out_ch_select <= {NUM_OF_CHANNEL{1'b0}};
                end
                else begin
                    out_ch_select <= out_ch_select + 1'b1;
                end
            end
        end
    end
  end
  endgenerate
    
    assign in_ready = in_ready_ch[in_ch_select];
    assign out_valid = out_valid_ch[out_ch_select];
    assign out_payload = out_data_ch[out_ch_select];
    
    generate for(i = 0; i < NUM_OF_CHANNEL; i = i + 1)
        begin: clock_crosser_gen
            
            assign in_valid_ch[i] = (i == in_ch_select) && in_valid;
            assign in_data_ch[i] = in_payload;
            
            assign out_ready_ch[i] = (i == out_ch_select) && out_ready;
            
                alt_em10g32_pipeline_base #(
                    .SYMBOLS_PER_BEAT(1),
                    .BITS_PER_SYMBOL(PAYLOAD_WIDTH),
                    .PIPELINE_READY(1)
                ) pream_st_pl_inst (
                    .clk        (clk),
                    .reset_n    (reset_n),
                    .in_ready   (in_ready_ch[i]),
                    .in_valid   (in_valid_ch[i]),
                    .in_data    (in_data_ch[i]),
                    .out_ready  (out_ready_ch[i]),
                    .out_valid  (out_valid_ch[i]),
                    .out_data   (out_data_ch[i])
                );
            
           /*  alt_em10g32_clock_crosser #(
                .SYMBOLS_PER_BEAT    (1),
                .BITS_PER_SYMBOL     (PAYLOAD_WIDTH),
                .FORWARD_SYNC_DEPTH  (FORWARD_SYNC_DEPTH),
                .BACKWARD_SYNC_DEPTH (BACKWARD_SYNC_DEPTH),
                .USE_OUTPUT_PIPELINE (USE_OUTPUT_PIPELINE)
            ) clock_crosser_ch (
                .clk      (clk),
                .reset_n  (reset_n),
                .in_ready    (in_ready_ch[i]),
                .in_valid    (in_valid_ch[i]),
                .in_data     (in_data_ch[i]),
                .out_clk     (out_clk),
                .out_reset_n (out_reset_n),
                .out_ready   (out_ready_ch[i]),
                .out_valid   (out_valid_ch[i]),
                .out_data    (out_data_ch[i])
            ); */
            
        end
    endgenerate
    
    
    // --------------------------------------------------
    // Calculates the log2ceil of the input value
    // --------------------------------------------------
    function integer log2ceil;
        input integer val;
        integer i;
        
        begin
            i = 1;
            log2ceil = 0;
            
            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction
    
endmodule
