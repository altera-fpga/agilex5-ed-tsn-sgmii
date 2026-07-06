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
module alt_em10g32_avalon_sc_fifo_secc #(
	// Parameter: ECC
    parameter ENABLE_MEM_ECC        = 0,
    parameter ECC_BLOCK_WIDTH       = 32, // Width of ECC Encoder input, either 32 or 12
    parameter REGISTER_ENC_INPUT    = 0,
    parameter REGISTER_ENC_OUTPUT   = 0,
    parameter REGISTER_DEC_INPUT    = 0,
    parameter REGISTER_DEC_OUTPUT   = 0,
    
    // Parameter: alt_em10g32_avalon_sc_fifo
    parameter SYMBOLS_PER_BEAT  = 1,
    parameter BITS_PER_SYMBOL   = 8,
    parameter FIFO_DEPTH        = 16,
    parameter CHANNEL_WIDTH     = 0,
    parameter ERROR_WIDTH       = 0,
    parameter USE_PACKETS       = 0,
    parameter USE_FILL_LEVEL    = 0,
    parameter USE_STORE_FORWARD = 0,
    parameter USE_ALMOST_FULL_IF = 0,
    parameter USE_ALMOST_EMPTY_IF = 0,
    parameter SYNC_RESET_N      = 0,
 
    parameter EMPTY_LATENCY     = 3,
    parameter USE_MEMORY_BLOCKS = 1,
    
    parameter DATA_WIDTH  = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL,
    parameter EMPTY_WIDTH = log2ceil(SYMBOLS_PER_BEAT)
) (
    input                       clk,
    input                       reset,

    input [DATA_WIDTH-1: 0]     in_data,
    input                       in_valid,
    input                       in_startofpacket,
    input                       in_endofpacket,
    input [((EMPTY_WIDTH>0) ? (EMPTY_WIDTH-1):0) : 0]     in_empty,
    input [((ERROR_WIDTH>0) ? (ERROR_WIDTH-1):0) : 0]     in_error,
    input [((CHANNEL_WIDTH>0) ? (CHANNEL_WIDTH-1):0): 0]  in_channel,
    output                      in_ready,

    output [DATA_WIDTH-1 : 0]   out_data,
    output                      out_valid,
    output                      out_startofpacket,
    output                      out_endofpacket,
    output [((EMPTY_WIDTH>0) ? (EMPTY_WIDTH-1):0) : 0]    out_empty,
    output [((ERROR_WIDTH>0) ? (ERROR_WIDTH-1):0) : 0]    out_error,
    output [((CHANNEL_WIDTH>0) ? (CHANNEL_WIDTH-1):0): 0] out_channel,
    input                       out_ready,

    input [(USE_STORE_FORWARD ? 2 : 1) : 0]   csr_address,
    input                       csr_write,
    input                       csr_read,
    input [31 : 0]              csr_writedata,
    output wire [31 : 0]         csr_readdata,

    output  wire                almost_full_data,
    output  wire                almost_empty_data,
    
    output reg                  ecc_err_corrected,
    output reg                  ecc_err_detected,
    output reg                  ecc_err_fatal
);
    
    // Local Parameters
    localparam PKT_SIGNALS_WIDTH    = 2 + EMPTY_WIDTH;
    localparam PAYLOAD_WIDTH        = (USE_PACKETS == 1) ? 
                                       2 + EMPTY_WIDTH + DATA_WIDTH + ERROR_WIDTH + CHANNEL_WIDTH :
                                       DATA_WIDTH + ERROR_WIDTH + CHANNEL_WIDTH;
    
    localparam ENC_IN_WIDTH         = (ECC_BLOCK_WIDTH == 12) ? 12 : 32;
    localparam ENC_OUT_WIDTH        = (ECC_BLOCK_WIDTH == 12) ? 18 : 39;
    
    localparam ECC_BLOCK_NUM        = divceil(PAYLOAD_WIDTH, ECC_BLOCK_WIDTH);
    localparam CONCAT_WIDTH         = ECC_BLOCK_WIDTH - (PAYLOAD_WIDTH % ECC_BLOCK_WIDTH);
    
    localparam MULTI_ECC_IN_WIDTH   = ECC_BLOCK_NUM * ENC_IN_WIDTH;
    localparam MULTI_ECC_OUT_WIDTH  = ECC_BLOCK_NUM * ENC_OUT_WIDTH;
    localparam FIFO_WIDTH           = ENABLE_MEM_ECC ? MULTI_ECC_OUT_WIDTH : PAYLOAD_WIDTH;
    
    
    wire [PKT_SIGNALS_WIDTH-1 : 0] in_packet_signals;
    wire [PKT_SIGNALS_WIDTH-1 : 0] out_packet_signals;
    
    wire [PAYLOAD_WIDTH-1 : 0] in_payload;
    
    wire                       pipeline_enc_in_sink_valid;
    wire                       pipeline_enc_in_sink_ready;
    wire [PAYLOAD_WIDTH-1 : 0] pipeline_enc_in_sink_data;
    
    wire                       pipeline_enc_in_src_valid;
    wire                       pipeline_enc_in_src_ready;
    wire [PAYLOAD_WIDTH-1 : 0] pipeline_enc_in_src_data;
    
    wire [PAYLOAD_WIDTH-1 : 0] enc_in_data;
    wire [MULTI_ECC_IN_WIDTH-1 : 0] enc_in_data_concat;
    wire [ENC_IN_WIDTH-1 : 0]  enc_in_data_i[ECC_BLOCK_NUM-1:0];
    
    wire [ENC_OUT_WIDTH-1 : 0] enc_out_data_i[ECC_BLOCK_NUM-1:0];
    wire [FIFO_WIDTH-1 : 0]    enc_out_data_concat;
    wire [FIFO_WIDTH-1 : 0]    enc_out_data;
    
    wire                       pipeline_enc_out_sink_valid;
    wire                       pipeline_enc_out_sink_ready;
    wire [FIFO_WIDTH-1 : 0]    pipeline_enc_out_sink_data;
    
    wire                       pipeline_enc_out_src_valid;
    wire                       pipeline_enc_out_src_ready;
    wire [FIFO_WIDTH-1 : 0]    pipeline_enc_out_src_data;
    
    wire                       sc_fifo_sink_valid;
    wire                       sc_fifo_sink_ready;
    wire [FIFO_WIDTH-1 : 0]    sc_fifo_sink_data;
    
    wire                       sc_fifo_src_valid;
    wire                       sc_fifo_src_ready;
    wire [FIFO_WIDTH-1 : 0]    sc_fifo_src_data;
    
    wire                       pipeline_dec_in_sink_valid;
    wire                       pipeline_dec_in_sink_ready;
    wire [FIFO_WIDTH-1 : 0]    pipeline_dec_in_sink_data;
    
    wire                       pipeline_dec_in_src_valid;
    wire                       pipeline_dec_in_src_ready;
    wire [FIFO_WIDTH-1 : 0]    pipeline_dec_in_src_data;
    
    wire [FIFO_WIDTH-1 : 0]    dec_in_data;
    
    wire [ENC_OUT_WIDTH-1 : 0] dec_in_data_i[ECC_BLOCK_NUM-1:0];
    
    wire [ENC_IN_WIDTH-1 : 0]  dec_out_data_i[ECC_BLOCK_NUM-1:0];
    
    wire [MULTI_ECC_IN_WIDTH-1 : 0] dec_out_data_concat;
    wire [PAYLOAD_WIDTH-1 : 0] dec_out_data;
    
    wire [ECC_BLOCK_NUM-1:0]   dec_out_err_corrected_i;
    wire [ECC_BLOCK_NUM-1:0]   dec_out_err_detected_i;
    wire [ECC_BLOCK_NUM-1:0]   dec_out_err_fatal_i;
    
    wire                       dec_out_err_corrected;
    wire                       dec_out_err_detected;
    wire                       dec_out_err_fatal;
    
    wire                       pipeline_dec_out_sink_valid;
    wire                       pipeline_dec_out_sink_ready;
    wire [PAYLOAD_WIDTH-1 : 0] pipeline_dec_out_sink_data;
    wire                       pipeline_dec_out_sink_dec_out_err_corrected;
    wire                       pipeline_dec_out_sink_dec_out_err_detected;
    wire                       pipeline_dec_out_sink_dec_out_err_fatal;
    
    wire                       pipeline_dec_out_src_valid;
    wire                       pipeline_dec_out_src_ready;
    wire [PAYLOAD_WIDTH-1 : 0] pipeline_dec_out_src_data;
    wire                       pipeline_dec_out_src_dec_out_err_corrected;
    wire                       pipeline_dec_out_src_dec_out_err_detected;
    wire                       pipeline_dec_out_src_dec_out_err_fatal;
    
    wire [PAYLOAD_WIDTH-1 : 0] out_payload;
    
    genvar i;
    
    // --------------------------------------------------
    // Define Payload
    //
    // Icky part where we decide which signals form the
    // payload to the FIFO with generate blocks.
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
    
    // Register input for ECC Encoder
    assign pipeline_enc_in_sink_valid = in_valid;
    assign pipeline_enc_in_sink_data = in_payload;
    assign in_ready = REGISTER_ENC_INPUT ? pipeline_enc_in_sink_ready : pipeline_enc_in_src_ready;
    
    alt_em10g32_pipeline_base #(
        .BITS_PER_SYMBOL    (PAYLOAD_WIDTH),
        .SYMBOLS_PER_BEAT   (1),
        .PIPELINE_READY     (0)
    ) pipeline_enc_in (
        .clk        (clk),
        .reset_n    (~reset),
        .in_valid   (pipeline_enc_in_sink_valid),
        .in_ready   (pipeline_enc_in_sink_ready),
        .in_data    (pipeline_enc_in_sink_data),
        .out_valid  (pipeline_enc_in_src_valid),
        .out_ready  (pipeline_enc_in_src_ready),
        .out_data   (pipeline_enc_in_src_data)
    );
    
    assign pipeline_enc_in_src_ready = REGISTER_ENC_OUTPUT ? pipeline_enc_out_sink_ready : pipeline_enc_out_src_ready;
    
    // ECC Encoder
    assign enc_in_data = REGISTER_ENC_INPUT ? pipeline_enc_in_src_data : pipeline_enc_in_sink_data;
    
    generate if(ENABLE_MEM_ECC)
        begin : ecc_enc_gen
            assign enc_in_data_concat = {{CONCAT_WIDTH{1'b0}}, enc_in_data};
			
			for(i = 0; i < ECC_BLOCK_NUM; i = i + 1)
			begin : ecc_enc_gen_loop
				assign enc_in_data_i[i] = enc_in_data_concat[ENC_IN_WIDTH * (i+1) - 1: ENC_IN_WIDTH * i];
				assign enc_out_data_concat[ENC_OUT_WIDTH * (i+1) - 1: ENC_OUT_WIDTH * i] = enc_out_data_i[i];
				
				if(ECC_BLOCK_WIDTH == 12) begin
					alt_em10g32_ecc_enc_12_18 ecc_enc_12_18_inst (
						.data               (enc_in_data_i[i]),
						.q                  (enc_out_data_i[i])
					);
				end
				else begin
					alt_em10g32_ecc_enc_32_39 ecc_enc_32_39_inst (
						.data               (enc_in_data_i[i]),
						.q                  (enc_out_data_i[i])
					);
				end
			end
        end
		else begin
			assign enc_out_data_concat = {FIFO_WIDTH{1'b0}};
		end
    endgenerate
    
    assign enc_out_data = ENABLE_MEM_ECC ? enc_out_data_concat : enc_in_data;
    
    // Register output for ECC Encoder
    assign pipeline_enc_out_sink_valid = REGISTER_ENC_INPUT ? pipeline_enc_in_src_valid : pipeline_enc_in_sink_valid;
    assign pipeline_enc_out_sink_data = enc_out_data;
    
    alt_em10g32_pipeline_base #(
        .BITS_PER_SYMBOL    (FIFO_WIDTH),
        .SYMBOLS_PER_BEAT   (1),
        .PIPELINE_READY     (0)
    ) pipeline_enc_out (
        .clk        (clk),
        .reset_n    (~reset),
        .in_valid   (pipeline_enc_out_sink_valid),
        .in_ready   (pipeline_enc_out_sink_ready),
        .in_data    (pipeline_enc_out_sink_data),
        .out_valid  (pipeline_enc_out_src_valid),
        .out_ready  (pipeline_enc_out_src_ready),
        .out_data   (pipeline_enc_out_src_data)
    );
    
    assign pipeline_enc_out_src_ready = sc_fifo_sink_ready;
    
    // SC FIFO
    assign sc_fifo_sink_valid = REGISTER_ENC_OUTPUT ? pipeline_enc_out_src_valid : pipeline_enc_out_sink_valid;
    assign sc_fifo_sink_data = REGISTER_ENC_OUTPUT ? pipeline_enc_out_src_data : pipeline_enc_out_sink_data;
    
    alt_em10g32_avalon_sc_fifo #(
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (FIFO_WIDTH),
        .FIFO_DEPTH          (FIFO_DEPTH),
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (0),
        .USE_FILL_LEVEL      (USE_FILL_LEVEL),
        .EMPTY_LATENCY       (EMPTY_LATENCY),
        .USE_MEMORY_BLOCKS   (USE_MEMORY_BLOCKS),
        .USE_STORE_FORWARD   (USE_STORE_FORWARD),
        .USE_ALMOST_FULL_IF  (USE_ALMOST_FULL_IF),
        .USE_ALMOST_EMPTY_IF (USE_ALMOST_EMPTY_IF),
        .SYNC_RESET_N        (SYNC_RESET_N)
    ) sc_fifo_inst (
        .clk               (clk),
        .reset             (reset),
        
        .in_data           (sc_fifo_sink_data),
        .in_valid          (sc_fifo_sink_valid),
        .in_startofpacket  (1'b0),
        .in_endofpacket    (1'b0),
        .in_empty          (1'b0),
        .in_error          (1'b0),
        .in_channel        (1'b0),
        .in_ready          (sc_fifo_sink_ready),
        
        .out_data          (sc_fifo_src_data),
        .out_valid         (sc_fifo_src_valid),
        .out_startofpacket (),
        .out_endofpacket   (),
        .out_empty         (),
        .out_error         (),
        .out_channel       (),
        .out_ready         (sc_fifo_src_ready),
        
        .csr_address       (csr_address),
        .csr_read          (csr_read),
        .csr_write         (csr_write),
        .csr_readdata      (csr_readdata),
        .csr_writedata     (csr_writedata),
        
        .almost_full_data  (almost_full_data),
        .almost_empty_data (almost_empty_data)
    );
    
    // Register input for ECC Decoder
    assign pipeline_dec_in_sink_valid = sc_fifo_src_valid;
    assign pipeline_dec_in_sink_data = sc_fifo_src_data;
    assign sc_fifo_src_ready = REGISTER_DEC_INPUT ? pipeline_dec_in_sink_ready : pipeline_dec_in_src_ready;
    
    alt_em10g32_pipeline_base #(
        .BITS_PER_SYMBOL    (FIFO_WIDTH),
        .SYMBOLS_PER_BEAT   (1),
        .PIPELINE_READY     (0)
    ) pipeline_dec_in (
        .clk        (clk),
        .reset_n    (~reset),
        .in_valid   (pipeline_dec_in_sink_valid),
        .in_ready   (pipeline_dec_in_sink_ready),
        .in_data    (pipeline_dec_in_sink_data),
        .out_valid  (pipeline_dec_in_src_valid),
        .out_ready  (pipeline_dec_in_src_ready),
        .out_data   (pipeline_dec_in_src_data)
    );
    assign pipeline_dec_in_src_ready = REGISTER_DEC_OUTPUT ? pipeline_dec_out_sink_ready : pipeline_dec_out_src_ready;
    
    // ECC Decoder
    assign dec_in_data = REGISTER_DEC_INPUT ? pipeline_dec_in_src_data : pipeline_dec_in_sink_data;
    
    generate for(i = 0; i < ECC_BLOCK_NUM; i = i + 1)
        begin : ecc_dec_gen
            if(ENABLE_MEM_ECC) begin
                assign dec_in_data_i[i] = dec_in_data[ENC_OUT_WIDTH * (i+1) - 1: ENC_OUT_WIDTH * i];
                assign dec_out_data_concat[ENC_IN_WIDTH * (i+1) - 1: ENC_IN_WIDTH * i] = dec_out_data_i[i];
                
                if(ECC_BLOCK_WIDTH == 12) begin
                    alt_em10g32_ecc_dec_18_12 ecc_dec_18_12_inst (
                        .data               (dec_in_data_i[i]),
                        .err_corrected      (dec_out_err_corrected_i[i]),
                        .err_detected       (dec_out_err_detected_i[i]),
                        .err_fatal          (dec_out_err_fatal_i[i]),
                        .q                  (dec_out_data_i[i])
                    );
                end
                else begin
                    alt_em10g32_ecc_dec_39_32 ecc_dec_39_32_inst (
                        .data               (dec_in_data_i[i]),
                        .err_corrected      (dec_out_err_corrected_i[i]),
                        .err_detected       (dec_out_err_detected_i[i]),
                        .err_fatal          (dec_out_err_fatal_i[i]),
                        .q                  (dec_out_data_i[i])
                    );
                end
            end
            else begin
                assign dec_out_data_concat[ENC_IN_WIDTH * (i+1) - 1: ENC_IN_WIDTH * i] = {ENC_IN_WIDTH{1'b0}};
                assign dec_out_err_corrected_i[i] = 1'b0;
                assign dec_out_err_detected_i[i] = 1'b0;
                assign dec_out_err_fatal_i[i] = 1'b0;
            end
        end
    endgenerate
    
    // Qualify with valid read event
    assign dec_out_err_corrected = (|dec_out_err_corrected_i) & (pipeline_dec_out_sink_valid & pipeline_dec_in_src_ready);
    assign dec_out_err_detected = (|dec_out_err_detected_i) & (pipeline_dec_out_sink_valid & pipeline_dec_in_src_ready);
    assign dec_out_err_fatal = (|dec_out_err_fatal_i) & (pipeline_dec_out_sink_valid & pipeline_dec_in_src_ready);
    
    assign dec_out_data[PAYLOAD_WIDTH-1:0] = ENABLE_MEM_ECC ? dec_out_data_concat[PAYLOAD_WIDTH-1:0] : dec_in_data[PAYLOAD_WIDTH-1:0];
    
    // Register output for ECC Decoder
    assign pipeline_dec_out_sink_valid = REGISTER_DEC_INPUT ? pipeline_dec_in_src_valid : pipeline_dec_in_sink_valid;
    assign pipeline_dec_out_sink_data = dec_out_data;
    
    alt_em10g32_pipeline_base #(
        .BITS_PER_SYMBOL    (PAYLOAD_WIDTH),
        .SYMBOLS_PER_BEAT   (1),
        .PIPELINE_READY     (0)
    ) pipeline_dec_out (
        .clk        (clk),
        .reset_n    (~reset),
        .in_valid   (pipeline_dec_out_sink_valid),
        .in_ready   (pipeline_dec_out_sink_ready),
        .in_data    (pipeline_dec_out_sink_data),
        .out_valid  (pipeline_dec_out_src_valid),
        .out_ready  (pipeline_dec_out_src_ready),
        .out_data   (pipeline_dec_out_src_data)
    );
    
    assign out_valid = REGISTER_DEC_OUTPUT ? pipeline_dec_out_src_valid : pipeline_dec_out_sink_valid;
    assign out_payload = REGISTER_DEC_OUTPUT ? pipeline_dec_out_src_data : pipeline_dec_out_sink_data;
    assign pipeline_dec_out_src_ready = out_ready;
    
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if(reset) begin
            ecc_err_corrected <= 1'b0;
            ecc_err_detected <= 1'b0;
            ecc_err_fatal <= 1'b0;
        end
        else begin
            ecc_err_corrected <= ENABLE_MEM_ECC ? dec_out_err_corrected : 1'b0;
            ecc_err_detected <= ENABLE_MEM_ECC ? dec_out_err_detected : 1'b0;
            ecc_err_fatal <= ENABLE_MEM_ECC ? dec_out_err_fatal : 1'b0;
        end
    end
    end else begin
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            ecc_err_corrected <= 1'b0;
            ecc_err_detected <= 1'b0;
            ecc_err_fatal <= 1'b0;
        end
        else begin
            ecc_err_corrected <= ENABLE_MEM_ECC ? dec_out_err_corrected : 1'b0;
            ecc_err_detected <= ENABLE_MEM_ECC ? dec_out_err_detected : 1'b0;
            ecc_err_fatal <= ENABLE_MEM_ECC ? dec_out_err_fatal : 1'b0;
        end
    end
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
    
    // --------------------------------------------------
    // Calculates the divceil of the input value (m/n)
    // --------------------------------------------------
    function integer divceil;
        input integer m;
		input integer n;
        integer i;
        
        begin
            i = m % n;
            divceil = (m/n);
            if (i > 0) begin
                divceil = divceil + 1;
			end
        end
    endfunction	

endmodule
