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

module alt_em10g32_tx_flow_control #(
    parameter ENABLE_1G10G_MAC         = 0,
    parameter ENABLE_10GBASER_REG_MODE = 0
) (

    input wire clk,
    input wire reset_n,
    
    
    input wire rx2flc_pause_field_valid,
    input wire [15:0]rx2flc_pause_pq,
    
    input wire  [2:0]speed_sel,
    input wire  flc2dataframe_valid,
    
    output reg flc2dataframe_ready

);
    localparam TIMER_WIDTH = 32;
    
    
    wire    pause_beat_src_valid;
    wire    [31:0]pause_beat_src_data;
    
    wire    pause_beat_sink_valid;
    wire    [31:0]pause_beat_sink_data;
    
    wire     pq_is_xon;

    
    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Pause Timer 
    // The timer would only be loaded when the pausebeats is valid. It will only decrements until zero.
    // ---------------------------------------------------------------------------
    // ###########################################################################################
    
    // wire [TIMER_WIDTH - 1:0]timer;
    reg [15:0]timer_lsb;
    reg [15:0]timer_msb;
    
    // assign timer = {timer_msb,timer_lsb};

    alt_em10g32_tx_pause_beat_conversion #(
        .ENABLE_1G10G_MAC(ENABLE_1G10G_MAC),
        .ENABLE_10GBASER_REG_MODE (ENABLE_10GBASER_REG_MODE)
    ) pausebeat_convertion (
    .clk                        (clk),
    .reset_n                    (reset_n),
    .pause_quanta_sink_valid    (rx2flc_pause_field_valid),
    .pause_quanta_sink_data     (rx2flc_pause_pq),
    .pause_beat_src_valid       (pause_beat_src_valid),
    .pause_beat_src_data        (pause_beat_src_data),
    .pq_is_xon                  (pq_is_xon),
    .speed_sel                  (speed_sel)
    );
    
    reg [2:0]state;
    reg [2:0]next_state;
    
    localparam IDLE = 3'b000;
    localparam LOAD = 3'b001;
    localparam LSBD = 3'b011;
    localparam MSBD = 3'b101;
    localparam PEND = 3'b111;
    
    
    // SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!reset_n)
            begin
            state <= IDLE;
            end
        else
            begin
            state <= next_state;
            end
        end
        
    always @ (*)
        begin
        case(state)
        IDLE    :   if(pause_beat_sink_valid && pq_is_xon)
                        begin
                        next_state =  IDLE;
                        end
                    else if(pause_beat_sink_valid && (!pq_is_xon))  
                        begin
                        next_state = LOAD;
                        end
                    else
                        begin
                        next_state = IDLE;
                        end
        LOAD    :   if(pause_beat_sink_valid && pq_is_xon)
                        begin
                        next_state =  IDLE;
                        end
                    else
                        begin
                        next_state =  PEND;
                        end
        PEND    :   if(pause_beat_sink_valid && pq_is_xon)
                        begin
                        next_state =  IDLE;
                        end
                    else if(pause_beat_sink_valid && (!pq_is_xon))
                        begin
                        next_state =  LOAD;
                        end
                    else if(flc2dataframe_valid)
                        begin
                        next_state =  PEND;
                        end
                    else 
                        begin
                        next_state =  LSBD;
                        end
        LSBD    :   if(pause_beat_sink_valid && pq_is_xon)
                        begin
                        next_state = IDLE;
                        end
                    else if(pause_beat_sink_valid && (!pq_is_xon))
                        begin
                        next_state = LOAD;
                        end
                    else if(timer_lsb != 0)
                        begin
                        next_state = LSBD;
                        end
                    else
                        begin
                        next_state = MSBD;
                        end
        MSBD    :   if(pause_beat_sink_valid && pq_is_xon)
                        begin
                        next_state =  IDLE;
                        end
                    else if(pause_beat_sink_valid && (!pq_is_xon))
                        begin
                        next_state = LOAD;
                        end
                    else if(timer_msb !=0)
                        begin
                        next_state = LSBD;
                        end
                    else
                        begin
                        next_state = IDLE;
                        end
        default:    next_state = IDLE;                
        endcase
        end
    
    
    assign pause_beat_sink_valid = pause_beat_src_valid;
    assign pause_beat_sink_data = pause_beat_src_data;
    
    // SYNC_RESET FLOPS
    always @ (posedge clk)        
        begin
        case(state)
        IDLE:   begin
                timer_lsb <= 16'b0;
                timer_msb <= 16'b0;
                end
        LOAD:   begin
                timer_lsb <= pause_beat_sink_data[15:0];
                timer_msb <= pause_beat_sink_data[31:16];
                end
        PEND:   begin
                timer_lsb <= timer_lsb;
                timer_msb <= timer_msb;
                end
        LSBD:   begin
                timer_lsb <= timer_lsb -1'b1;
                timer_msb <= timer_msb;
                end
        MSBD:   begin
                timer_lsb <= 16'hFFFF;
                timer_msb <= timer_msb -1'b1;
                end
        default:begin
                timer_lsb <= 16'b0;
                timer_msb <= 16'b0;
                end
        endcase        
        end

    
    /* always @(posedge clk or negedge reset_n) 
        begin
        if (!reset_n) 
            begin	
            timer <= 32'b0;
            end
        else 
            begin
            if (pause_beat_sink_valid  && (!pq_is_xon)) 
                begin
                timer <= pause_beat_sink_data[15:0];
                end
            else 
                begin	               
                if(timer == 0)  
                    begin
                    timer <=timer; 
                    end
                else
                    begin
                    timer <= timer - 1'b1;
                    end               
                end
            end
        end */
    
    // SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!reset_n)
            begin
            flc2dataframe_ready <= 1'b1;
            end
        else
            begin
            if(state[0])
                begin
                flc2dataframe_ready <= 1'b0;
                end
            else
                begin
                flc2dataframe_ready <= 1'b1;
                end
            end
        end


endmodule
