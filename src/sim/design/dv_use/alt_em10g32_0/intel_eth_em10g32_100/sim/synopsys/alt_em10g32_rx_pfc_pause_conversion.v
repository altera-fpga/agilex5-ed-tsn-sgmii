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


`timescale 1ns / 1ns
module alt_em10g32_rx_pfc_pause_conversion(
    
    //Common clock and Reset
    clk,
    reset_n,
    
    // Pause Quanta Sink
    pfc_pause_quanta_sink_valid,
    pfc_pause_quanta_sink_data,
    
    // Pause Enable Source
    pfc_pause_ena_src_data
    
    );

    // =head1 GLOBAL PARAMETERS
    parameter  PFC_PRIORITY_NUM             = 8;  // Number of PFC priorities
    parameter  SYNC_RESET_N                 = 1;
    
    // =head2 Avalon Streaming
    localparam BITSPERSYMBOL                = 8;  // Streaming Data symbol width in bits
    localparam SYMBOLSPERBEAT               = 4;  // Streaming Number of symbols per word
    
    // =head1 LOCAL PARAMETERS
    
    // =head2 Avalon Streaming
    localparam EMPTY_WIDTH                  = log2ceil(SYMBOLSPERBEAT); 
    localparam DATA_WIDTH                   = BITSPERSYMBOL * SYMBOLSPERBEAT;
    
    localparam PAUSE_QUANTA_WIDTH           = 16;
    localparam PAUSE_BEAT_WIDTH             = 32;
    
    // localparam PAUSEQ_TO_BEATS              = divceil(512, DATA_WIDTH); // Value of 1 pause quanta in beats
    localparam PAUSEQ_TO_BEATS              = 16; // Value of 1 pause quanta in beats
    
    
    
    // =head1 PINS
    
    // =head2 Clock Interface
    input                               clk;
    input                               reset_n;
    
    // =head2 Avalon ST Pause Quanta Sink Interface
    input                                                       pfc_pause_quanta_sink_valid;
    input  [((PAUSE_QUANTA_WIDTH+1) * PFC_PRIORITY_NUM) - 1:0]  pfc_pause_quanta_sink_data;
    
    // =head2 Avalon ST Pause Beat Source Interface
    output [PFC_PRIORITY_NUM - 1:0]     pfc_pause_ena_src_data;
    
    reg    [PFC_PRIORITY_NUM - 1:0]     pfc_pause_quanta_ena;
    wire   [PAUSE_QUANTA_WIDTH - 1:0]   pfc_pause_quanta[PFC_PRIORITY_NUM - 1: 0];
    reg    [PAUSE_BEAT_WIDTH - 1:0]     pfc_pause_beat[PFC_PRIORITY_NUM - 1: 0];
    
    wire   [PFC_PRIORITY_NUM - 1:0]     pfc_pause_ena_int;
    
    genvar i_gen;
    
    generate for (i_gen=0; i_gen < PFC_PRIORITY_NUM; i_gen=i_gen+1)
        begin : PFC_BACKPRESSURE_GEN
            
            // bit[33]    - Pause Quanta Enable for Priority 1
            // bit[32:17] - Pause Quanta for Priority 1
            // bit[16]    - Pause Quanta Enable for Priority 0
            // bit[15:0]  - Pause Quanta for Priority 0
            
            assign pfc_pause_quanta[i_gen]          = pfc_pause_quanta_sink_data[(PAUSE_QUANTA_WIDTH+1) * (i_gen+1) - 2 : (PAUSE_QUANTA_WIDTH+1) * (i_gen)];
            
            assign pfc_pause_ena_src_data[i_gen]    = ~pfc_pause_ena_int[i_gen];
            
            // SYNC_RESET FLOPS
            always @(posedge clk) begin
                if(~reset_n) begin
                    pfc_pause_quanta_ena[i_gen] <= 1'b0;
                    pfc_pause_beat[i_gen]       <= {PAUSE_BEAT_WIDTH{1'b0}};
                end
                else begin
                    pfc_pause_quanta_ena[i_gen] <= pfc_pause_quanta_sink_data[(PAUSE_QUANTA_WIDTH+1) * (i_gen+1) - 1] & pfc_pause_quanta_sink_valid;
                    
                    // Convert pause quanta to number of clock cycles to backpressure
                    // For each pause quanta, 32-bit data width, number of clock cycle to backpressure is 16 clock cycles
                    pfc_pause_beat[i_gen]       <= (pfc_pause_quanta[i_gen] * PAUSEQ_TO_BEATS);
                end
            end
            
            // Use packet backpressure control to generate backpressure for each priorities
            // The generated backpressure signal is inverted to become pause enable signal
            alt_em10g32_rx_pkt_backpressure_control #(
                .BITSPERSYMBOL  (8),
                .SYMBOLSPERBEAT (4),
                .ERROR_WIDTH    (1),
                .USE_READY      (1),
                .SYNC_RESET_N   (SYNC_RESET_N)
            ) pause_quanta_backpressure_conversion (
                .clk                   (clk),
                .reset_n               (reset_n),
                .csr_reset_n           (1'b0),
                .csr_write             (1'b0),
                .csr_read              (1'b0),
                .csr_address           (1'b0),
                .csr_writedata         (32'h00),
                .csr_readdata          (), // dangling output
                .data_src_sop          (), // dangling output
                .data_src_eop          (), // dangling output
                .data_src_valid        (), // dangling output
                .data_src_ready        (1'b1),
                .data_src_data         (), // dangling output
                .data_src_empty        (), // dangling output
                .data_src_error        (), // dangling output
                .data_sink_sop         (1'b0),
                .data_sink_eop         (1'b0),
                .data_sink_valid       (1'b0),
                .data_sink_ready       (pfc_pause_ena_int[i_gen]),
                .data_sink_data        ({DATA_WIDTH{1'b0}}),
                .data_sink_empty       ({EMPTY_WIDTH{1'b0}}),
                .data_sink_error       (1'b0),
                .pausebeats_sink_valid (pfc_pause_quanta_ena[i_gen]),
                .pausebeats_sink_data  (pfc_pause_beat[i_gen])
            );
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

// =head1 SEE ALSO
// 
// =cut
