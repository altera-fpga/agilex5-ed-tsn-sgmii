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


// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
//
// Description : 
//
// Character Decoding and Frame De-Encapsulation for core with embedded 
// SERDES module.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_rx_encapsulation_strx_gx (
   reset,           //input   reset;                  //  Active High Global Reset
   sw_reset,        //input   sw_reset;               //  SW Asynchronous Reset
   clk,             //input   clk;                    //  125MHz Common Clock
   rx_sync,         //input   rx_sync;                //  Link Synchronization
   receive,         //output  receive;                //  Frame Transmission Active
   idle_ena,        //output  idle_ena;               //  Idle Received
   rx_invalid,      //output  rx_invalid;             //  Invalid Signal
   lp_ability,      //output  [15:0] lp_ability;      //  Link Partner Ability Register
   lp_ability_ena,  //output  lp_ability_ena;         //  Link Partner Ability Valid
   kchar,           //input   kchar;                  //  Special Character Indication
   frame,           //input   [15:0] frame;            //  Frame
   char_err,        //input   char_err;               //  Decoder Error
   xmit_data,       //input   xmit_data;              //  Auto-Negotiation Status ( IF AutoNegotiation is disabled, this signal is always high)
   carrier_detect,  //input   carrier_detect;         //  Carrier Detected
   rx_lane_alignment, //output  rx_lane_alignment;    //  Alignment of lane: 0: No realignment, 1: Realigned, add extra half cycle latency
   pcs_dv_single_bit, //output  pcs_dv_single_bit;    //  Data Valid
   soft_rx_sync,         //output  soft_rx_sync;                //  processed Link Synchronization
   gmii_dv,         //output  gmii_dv;                //  Data Valid
   gmii_err,        //output  gmii_err;               //  Data Control
   gmii_data);      //output  [7:0] gmii_data;        //  Data
 
input   reset;                  //  Active High Global Reset
input   sw_reset;               //  SW Asynchronous Reset           
input   clk;                    //  125MHz Common Clock
input   [1:0] rx_sync;                //  Link Synchronization
output  receive;                //  Frame Transmission Active
output  idle_ena;               //  Idle Received
output  rx_invalid;             //  Invalid Signal
output  [15:0] lp_ability;      //  Link Partner Ability Register
output  lp_ability_ena;         //  Link Partner Ability Valid
input   [1:0] kchar;                  //  Special Character Indication
input   [15:0] frame;            //  Frame
input   [1:0] char_err;               //  Decoder Error
input   xmit_data;              //  Auto-Negotiation Status
input   [1:0] carrier_detect;    //  Carrier Detected
output  rx_lane_alignment;
output  pcs_dv_single_bit;
output  [1:0] soft_rx_sync;                //  Processed Link Synchronization
output  [1:0] gmii_dv;                //  Data Valid
output  [1:0] gmii_err;               //  Data Control
output  [15:0] gmii_data;        //  Data

localparam CONST_K28_5  = 8'hBC;
localparam CONST_K28_1  = 8'h3C;
localparam CONST_K28_7  = 8'hFC;
localparam CONST_D0_0   = 8'h00;
localparam CONST_D2_2   = 8'h42;
localparam CONST_D16_2  = 8'h50;
localparam CONST_D21_5  = 8'hB5;
localparam CONST_S      = 8'hFB;
localparam CONST_T      = 8'hFD;
localparam CONST_R      = 8'hF7;

localparam STM_LINK_FAILED                  = 5'h0 ;
localparam STM_WAIT_FOR_K__RX_K             = 5'h1 ;
localparam STM_IDLE_D                       = 5'h2 ;
localparam STM_FALSE_CARRIER                = 5'h3 ;
localparam STM_RX_INVALID                   = 5'h4 ;
localparam STM_RX_CB__RX_CC                 = 5'h5 ;
localparam STM_RX_CD                        = 5'h6 ;
localparam STM_START_OF_PACKET              = 5'h7 ;
localparam STM_RX_DATA__RX_DATA_ERROR       = 5'h8 ;
localparam STM_TRI_RRI                      = 5'h9 ;
localparam STM_EXTEND_TRRR_0                = 5'hA ;
localparam STM_EXTEND_TRR_1                 = 5'hB ;
localparam STM_EXTEND_ERR_TRRE_0            = 5'hC ;
localparam STM_EXTEND_ERR_RRE_1             = 5'hD ;
localparam STM_EXTEND_ERR                   = 5'hE ;
localparam STM_EXTEND_ERR_ERRR_0            = 5'hF ;
localparam STM_EARLY_END_EXT_RRRR_0         = 5'h10;
localparam STM_EARLY_END_EXT_RRR_1          = 5'h11;
localparam STM_EARLY_END_EXTEND_ERR_RRRE_0  = 5'h12;

localparam LOSS_OF_SYNC     = 3'd0; // Synchronization state, see spec Figure 36-9
localparam SYNC_ACQUIRED_1  = 3'd1; // Synchronization state, see spec Figure 36-9
localparam SYNC_ACQUIRED_2  = 3'd2; // Synchronization state, see spec Figure 36-9 
localparam SYNC_ACQUIRED_2A = 3'd3; // Synchronization state, see spec Figure 36-9
localparam SYNC_ACQUIRED_3  = 3'd4; // Synchronization state, see spec Figure 36-9
localparam SYNC_ACQUIRED_3A = 3'd5; // Synchronization state, see spec Figure 36-9
localparam SYNC_ACQUIRED_4  = 3'd6; // Synchronization state, see spec Figure 36-9
localparam SYNC_ACQUIRED_4A = 3'd7; // Synchronization state, see spec Figure 36-9

wire [1:0]  rx_kchar_unaligned_p0;
reg  [1:0]  rx_kchar_unaligned_p05;
reg  [1:0]  rx_kchar_aligned_p1;
reg  [1:0]  rx_kchar_aligned_p2;
reg  [1:0]  rx_kchar_aligned_p3;

wire [15:0] rx_data_unaligned_p0;
reg  [15:0] rx_data_unaligned_p05;
reg  [15:0] rx_data_aligned_p1;
reg  [15:0] rx_data_aligned_p2;
reg  [15:0] rx_data_aligned_p3;

wire [1:0]  rx_char_err_unaligned_p0;
reg  [1:0]  rx_char_err_unaligned_p05;
reg  [1:0]  rx_char_err_aligned_p1;
reg  [1:0]  rx_char_err_aligned_p2;
reg  [1:0]  rx_char_err_aligned_p3;

wire [1:0]  rx_carrier_detect_unaligned_p0;
reg  [1:0]  rx_carrier_detect_unaligned_p05;
reg  [1:0]  rx_carrier_detect_aligned_p1;
reg  [1:0]  rx_carrier_detect_aligned_p2;
reg  [1:0]  rx_carrier_detect_aligned_p3;

reg  [1:0] rx_sync_reg;

reg  is_K28_5_unaligned_lane_0_p1;
reg  is_K28_5_unaligned_lane_1_p1;

reg  is_R_unaligned_lane_0_p1;
reg  is_R_unaligned_lane_1_p1;

reg  is_D0_0_unaligned_lane_0_p1;
reg  is_D0_0_unaligned_lane_1_p1;

reg  is_K28_5_unaligned_lane_1_p15;
reg  is_R_unaligned_lane_1_p15;
reg  is_D0_0_unaligned_lane_1_p15;

reg  is_K28_5_next_lane_0;
reg  is_R_next_lane_0;
reg  is_R_next_lane_1;
reg  is_D0_0_next_lane_0;

reg  is_K28_5_lane_0;
reg  is_R_lane_0;
reg  is_R_lane_1;

reg  is_D2_2_lane_1;
reg  is_D21_5_lane_1;
reg  is_S_lane_0;
reg  is_T_lane_0;
reg  is_T_lane_1;

wire is_D_lane_0;
wire is_D_lane_1;

wire is_char_err_lane_0;
wire is_char_err_lane_1;

wire is_carrier_detect_lane_0;
wire is_carrier_detect_lane_1;

reg  lane_alignment_done;
reg  lane_alignment;
reg reset_lane_alignment;
reg       cgbad;
reg [2:0] sync_state;

reg  [4:0]  next_state;
reg  [4:0]  state;

reg  [15:0] lp_ability;
reg         lp_ability_ena;

reg         idle_ena;
reg         receive;
reg         rx_invalid;

reg         early_end;
reg         early_end_reg;

reg  [1:0]  soft_rx_sync;
reg  [1:0]  gmii_dv;
reg  [1:0]  gmii_err;
reg  [15:0] gmii_data;
reg         pcs_dv_single_bit;
/////////////////////////////////////////////////////////////////////////////
// RX data alignment
/////////////////////////////////////////////////////////////////////////////

// Delay rx_sync to provide time for decoding of K28.5
always @(posedge clk or posedge reset) begin
    if(reset) begin
        rx_sync_reg <= 2'b00;
    end
    else begin
        rx_sync_reg <= rx_sync;
    end
end

// Align the data to ensure K28.5 always show in lane 0
// Realignment happen only when rx_sync_reg is down
always @(posedge clk or posedge reset) begin
    if(reset) begin
        lane_alignment_done <= 1'b0;
        lane_alignment <= 1'b0;
    end
    else begin
        if(sw_reset) begin
            lane_alignment_done <= 1'b0;
            lane_alignment <= 1'b0;
        end
        else if(rx_sync_reg != 2'b11 || reset_lane_alignment) begin
            lane_alignment_done <= 1'b0;
            lane_alignment <= 1'b0;
        end
        else if(!lane_alignment_done && (rx_sync_reg == 2'b11)) begin
            lane_alignment_done <= 1'b1;
            
            // Assumption: Right after rx_sync_reg asserted, K28.5 will always exist in either lane 0 or lane 1
            // Therefore only one comparison result of any lane is required
            lane_alignment <= is_K28_5_unaligned_lane_1_p1;
        end
    end
end

assign rx_lane_alignment = lane_alignment;

/////////////////////////////////////////////////////////////////////////////
// Code-groups Detection
/////////////////////////////////////////////////////////////////////////////

always @(posedge clk or posedge reset) begin
    if(reset) begin
        is_K28_5_unaligned_lane_0_p1        <= 1'b0;
        is_K28_5_unaligned_lane_1_p1        <= 1'b0;
        
        is_R_unaligned_lane_0_p1            <= 1'b0;
        is_R_unaligned_lane_1_p1            <= 1'b0;
        
        is_D0_0_unaligned_lane_0_p1         <= 1'b0;
        is_D0_0_unaligned_lane_1_p1         <= 1'b0;
        
        is_K28_5_unaligned_lane_1_p15       <= 1'b0;
        is_R_unaligned_lane_1_p15           <= 1'b0;
        is_D0_0_unaligned_lane_1_p15        <= 1'b0;
    end
    else begin
        if(sw_reset) begin
            is_K28_5_unaligned_lane_0_p1    <= 1'b0;
            is_K28_5_unaligned_lane_1_p1    <= 1'b0;
            
            is_R_unaligned_lane_0_p1        <= 1'b0;
            is_R_unaligned_lane_1_p1        <= 1'b0;
            
            is_D0_0_unaligned_lane_0_p1     <= 1'b0;
            is_D0_0_unaligned_lane_1_p1     <= 1'b0;
            
            is_K28_5_unaligned_lane_1_p15   <= 1'b0;
            is_R_unaligned_lane_1_p15       <= 1'b0;
            is_D0_0_unaligned_lane_1_p15    <= 1'b0;
        end
        else begin
            is_K28_5_unaligned_lane_0_p1    <= (rx_kchar_unaligned_p0[0] == 1'b1) && (rx_data_unaligned_p0[ 7:0] == CONST_K28_5);
            is_K28_5_unaligned_lane_1_p1    <= (rx_kchar_unaligned_p0[1] == 1'b1) && (rx_data_unaligned_p0[15:8] == CONST_K28_5);
            
            is_R_unaligned_lane_0_p1        <= (rx_kchar_unaligned_p0[0] == 1'b1) && (rx_data_unaligned_p0[ 7:0] == CONST_R);
            is_R_unaligned_lane_1_p1        <= (rx_kchar_unaligned_p0[1] == 1'b1) && (rx_data_unaligned_p0[15:8] == CONST_R);
            
            is_D0_0_unaligned_lane_0_p1     <= (rx_kchar_unaligned_p0[0] == 1'b0) && (rx_data_unaligned_p0[ 7:0] == CONST_D0_0);
            is_D0_0_unaligned_lane_1_p1     <= (rx_kchar_unaligned_p0[1] == 1'b0) && (rx_data_unaligned_p0[15:8] == CONST_D0_0);
            
            is_K28_5_unaligned_lane_1_p15   <= is_K28_5_unaligned_lane_1_p1;
            is_R_unaligned_lane_1_p15       <= is_R_unaligned_lane_1_p1;
            is_D0_0_unaligned_lane_1_p15    <= is_D0_0_unaligned_lane_1_p1;
        end
    end
end

always @(*) begin
    if(lane_alignment == 1'b0) begin
        is_K28_5_next_lane_0 = is_K28_5_unaligned_lane_0_p1;
        is_R_next_lane_0     = is_R_unaligned_lane_0_p1;
        is_R_next_lane_1     = is_R_unaligned_lane_1_p1;
        is_D0_0_next_lane_0  = is_D0_0_unaligned_lane_0_p1;
    end
    else begin
        is_K28_5_next_lane_0 = is_K28_5_unaligned_lane_1_p15;
        is_R_next_lane_0     = is_R_unaligned_lane_1_p15;
        is_R_next_lane_1     = is_R_unaligned_lane_0_p1;
        is_D0_0_next_lane_0  = is_D0_0_unaligned_lane_1_p15;
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        is_K28_5_lane_0 <= 1'b0;
        is_R_lane_0     <= 1'b0;
        is_R_lane_1     <= 1'b0;
        
        is_D2_2_lane_1  <= 1'b0;
        is_D21_5_lane_1 <= 1'b0;
        is_S_lane_0     <= 1'b0;
        is_T_lane_0     <= 1'b0;
        is_T_lane_1     <= 1'b0;
    end
    else begin
        if(sw_reset || !lane_alignment_done) begin
            is_K28_5_lane_0 <= 1'b0;
            is_R_lane_0     <= 1'b0;
            is_R_lane_1     <= 1'b0;
            
            is_D2_2_lane_1  <= 1'b0;
            is_D21_5_lane_1 <= 1'b0;
            is_S_lane_0     <= 1'b0;
            is_T_lane_0     <= 1'b0;
            is_T_lane_1     <= 1'b0;
        end
        else begin
            is_K28_5_lane_0 <= is_K28_5_next_lane_0;
            is_R_lane_0     <= is_R_next_lane_0;
            is_R_lane_1     <= is_R_next_lane_1;
            
            is_D2_2_lane_1  <= (rx_kchar_aligned_p1[1] == 1'b0) && (rx_data_aligned_p1[15:8] == CONST_D2_2);
            is_D21_5_lane_1 <= (rx_kchar_aligned_p1[1] == 1'b0) && (rx_data_aligned_p1[15:8] == CONST_D21_5);
            is_S_lane_0     <= (rx_kchar_aligned_p1[0] == 1'b1) && (rx_data_aligned_p1[ 7:0] == CONST_S);
            is_T_lane_0     <= (rx_kchar_aligned_p1[0] == 1'b1) && (rx_data_aligned_p1[ 7:0] == CONST_T);
            is_T_lane_1     <= (rx_kchar_aligned_p1[1] == 1'b1) && (rx_data_aligned_p1[15:8] == CONST_T);
        end
    end
end

assign is_D_lane_0 = ~rx_kchar_aligned_p2[0];
assign is_D_lane_1 = ~rx_kchar_aligned_p2[1];

assign is_char_err_lane_0 = rx_char_err_aligned_p2[0];
assign is_char_err_lane_1 = rx_char_err_aligned_p2[1];

assign is_carrier_detect_lane_0 = rx_carrier_detect_aligned_p2[0];
assign is_carrier_detect_lane_1 = rx_carrier_detect_aligned_p2[1];

/////////////////////////////////////////////////////////////////////////////
// Data Pipelines
/////////////////////////////////////////////////////////////////////////////

assign rx_kchar_unaligned_p0 = kchar;

assign rx_data_unaligned_p0 = frame;

assign rx_char_err_unaligned_p0 = char_err;

assign rx_carrier_detect_unaligned_p0 = carrier_detect;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        rx_kchar_unaligned_p05 <= 2'b00;
        
        rx_data_unaligned_p05 <= 16'h0;
        
        rx_char_err_unaligned_p05 <= 2'b00;
        
        rx_carrier_detect_unaligned_p05 <= 2'b00;
    end
    else begin
        rx_kchar_unaligned_p05 <= rx_kchar_unaligned_p0;
        
        rx_data_unaligned_p05 <= rx_data_unaligned_p0;
        
        rx_char_err_unaligned_p05 <= rx_char_err_unaligned_p0;
        
        rx_carrier_detect_unaligned_p05 <= rx_carrier_detect_unaligned_p0;
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        rx_kchar_aligned_p1[0] <= 1'b0;
        rx_kchar_aligned_p1[1] <= 1'b0;
        
        rx_data_aligned_p1[7:0] <= 8'h0;
        rx_data_aligned_p1[15:8] <= 8'h0;
        
        rx_char_err_aligned_p1[0] <= 1'b0;
        rx_char_err_aligned_p1[1] <= 1'b0;
        
        rx_carrier_detect_aligned_p1[0] <= 1'b0;
        rx_carrier_detect_aligned_p1[1] <= 1'b0;
    end
    else begin
        if(lane_alignment_done) begin
            if(lane_alignment == 1'b0) begin
                rx_kchar_aligned_p1[0] <= rx_kchar_unaligned_p0[0];
                rx_kchar_aligned_p1[1] <= rx_kchar_unaligned_p0[1];
                
                rx_data_aligned_p1[7:0] <= rx_data_unaligned_p0[7:0];
                rx_data_aligned_p1[15:8] <= rx_data_unaligned_p0[15:8];
                
                rx_char_err_aligned_p1[0] <= rx_char_err_unaligned_p0[0];
                rx_char_err_aligned_p1[1] <= rx_char_err_unaligned_p0[1];
                
                rx_carrier_detect_aligned_p1[0] <= rx_carrier_detect_unaligned_p0[0];
                rx_carrier_detect_aligned_p1[1] <= rx_carrier_detect_unaligned_p0[1];
            end
            else begin
                rx_kchar_aligned_p1[0] <= rx_kchar_unaligned_p05[1];
                rx_kchar_aligned_p1[1] <= rx_kchar_unaligned_p0[0];
                
                rx_data_aligned_p1[7:0] <= rx_data_unaligned_p05[15:8];
                rx_data_aligned_p1[15:8] <= rx_data_unaligned_p0[7:0];
                
                rx_char_err_aligned_p1[0] <= rx_char_err_unaligned_p05[1];
                rx_char_err_aligned_p1[1] <= rx_char_err_unaligned_p0[0];
                
                rx_carrier_detect_aligned_p1[0] <= rx_carrier_detect_unaligned_p05[1];
                rx_carrier_detect_aligned_p1[1] <= rx_carrier_detect_unaligned_p0[0];
            end
        end
        else begin
            // Receive invalid char before the alignment is completed
            rx_kchar_aligned_p1[0] <= 1'b0;
            rx_kchar_aligned_p1[1] <= 1'b0;
            
            rx_data_aligned_p1[7:0] <= 8'h0;
            rx_data_aligned_p1[15:8] <= 8'h0;
            
            rx_char_err_aligned_p1[0] <= 1'b0;
            rx_char_err_aligned_p1[1] <= 1'b0;
            
            rx_carrier_detect_aligned_p1[0] <= 1'b0;
            rx_carrier_detect_aligned_p1[1] <= 1'b0;
        end
    end
end


// After sync_acquired, check if received codegroup is good or bad.
// In worst case, the acquired sync is dropped.
// After alignment above, lane 0 is always rx_even=TRUE
// cgbad  =  ((rx_code-group=/INVALID/) + (rx_code-group=/COMMA/*rx_even=TRUE)) * PMA_UNITDATA.indication ==>  (invalid_cg or lane_1_is_COMMA)
// cggood = !((rx_code-group=/INVALID/) + (rx_code-group=/COMMA/*rx_even=TRUE)) * PMA_UNITDATA.indication ==> !(invalid_cg or lane_1_is_COMMA)
// note 1: lane0 is assumed to always achieve cg_good in 16bit data case
//         a. if lane1 is cgbad, handle cgbad as described in spec
//         b. if lane1 is cggood, this cycles contributes 2-cggood in total
// note 2: invalid_cg is expected checked by hard PCS

always @(*) begin
    if(lane_alignment_done) begin
        if (rx_kchar_aligned_p1[1]==1'b1 && 
            ((rx_data_aligned_p1[15:8] == CONST_K28_5) ||
             (rx_data_aligned_p1[15:8] == CONST_K28_7) || 
             (rx_data_aligned_p1[15:8] == CONST_K28_1))
           ) begin
            cgbad = 1'b1;
        end
        else begin
            cgbad = 1'b0;
        end
    end
    else begin
        cgbad = 1'b0;
    end
end    
        
always @(posedge clk or posedge reset) begin
    if(reset) begin
        sync_state           <= LOSS_OF_SYNC;
        soft_rx_sync         <= 2'b00;
        reset_lane_alignment <= 1'b0;
    end
    else if (rx_sync!=2'b11) begin
        sync_state           <= LOSS_OF_SYNC;
        soft_rx_sync         <= 2'b00;
        reset_lane_alignment <= 1'b0;
    end
    else begin

        if (sync_state == LOSS_OF_SYNC) begin
            soft_rx_sync <= 2'b00;
        end
        else begin
            soft_rx_sync <= rx_sync;
        end
        
        case(sync_state)
            LOSS_OF_SYNC:
            begin
                reset_lane_alignment <= 1'b0;
                if (!reset_lane_alignment && lane_alignment_done) begin
                    sync_state <= SYNC_ACQUIRED_1;
                end
            end
            SYNC_ACQUIRED_1:
            begin
                if (cgbad) begin
                    sync_state <= SYNC_ACQUIRED_2;
                end
                else begin // cggood
                    sync_state <= SYNC_ACQUIRED_1;
                end
            end
            SYNC_ACQUIRED_2:
            begin
                if (cgbad) begin
                    sync_state <= SYNC_ACQUIRED_3;
                end
                else begin // cggood
                    sync_state <= SYNC_ACQUIRED_2A;
                end
            end
            SYNC_ACQUIRED_2A:
            begin
                if (cgbad) begin
                    sync_state <= SYNC_ACQUIRED_3;
                end
                else begin // cggood
                    sync_state <= SYNC_ACQUIRED_1;
                end                
            end
            SYNC_ACQUIRED_3:
            begin
                if (cgbad) begin
                    sync_state <= SYNC_ACQUIRED_4;
                end
                else begin // cggood
                    sync_state <= SYNC_ACQUIRED_3A;
                end
            end
            SYNC_ACQUIRED_3A:
            begin
                if (cgbad) begin
                    sync_state <= SYNC_ACQUIRED_4;
                end
                else begin // cggood
                    sync_state <= SYNC_ACQUIRED_2;
                end  
            end
            SYNC_ACQUIRED_4:
            begin
                if (cgbad) begin
                    sync_state <= LOSS_OF_SYNC;
                    reset_lane_alignment <= 1'b1;
                end
                else begin // cggood
                    sync_state <= SYNC_ACQUIRED_4A;
                end
            end
            SYNC_ACQUIRED_4A:
            begin
                if (cgbad) begin
                    sync_state <= LOSS_OF_SYNC;
                    reset_lane_alignment <= 1'b1;
                end
                else begin // cggood
                    sync_state <= SYNC_ACQUIRED_3;
                end 
            end
            default:
            begin
                sync_state <= LOSS_OF_SYNC;
                reset_lane_alignment <= reset_lane_alignment;
            end
        endcase    
    end
end

// Delay received data to align with state machine
always @(posedge clk or posedge reset) begin
    if(reset) begin
        rx_kchar_aligned_p2 <= 2'b00;
        rx_kchar_aligned_p3 <= 2'b00;
        
        rx_data_aligned_p2 <= 16'h0;
        rx_data_aligned_p3 <= 16'h0;
        
        rx_char_err_aligned_p2 <= 2'b00;
        rx_char_err_aligned_p3 <= 2'b00;
        
        rx_carrier_detect_aligned_p2 <= 2'b00;
        rx_carrier_detect_aligned_p3 <= 2'b00;
    end
    else begin
        rx_kchar_aligned_p2 <= rx_kchar_aligned_p1;
        rx_kchar_aligned_p3 <= rx_kchar_aligned_p2;
        
        rx_data_aligned_p2 <= rx_data_aligned_p1;
        rx_data_aligned_p3 <= rx_data_aligned_p2;
        
        rx_char_err_aligned_p2 <= rx_char_err_aligned_p1;
        rx_char_err_aligned_p3 <= rx_char_err_aligned_p2;
        
        rx_carrier_detect_aligned_p2 <= rx_carrier_detect_aligned_p1;
        rx_carrier_detect_aligned_p3 <= rx_carrier_detect_aligned_p2;
    end
end

/////////////////////////////////////////////////////////////////////////////
// RX State Machine
/////////////////////////////////////////////////////////////////////////////

// ------------------------
// State Machine Transition
// ------------------------
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= STM_WAIT_FOR_K__RX_K;
        early_end_reg <= 1'b0;
    end
    else begin
        if(sw_reset) begin
            state <= STM_WAIT_FOR_K__RX_K;
            early_end_reg <= 1'b0;
        end
        else if(rx_sync != 2'b11) begin
            state <= STM_LINK_FAILED;
            early_end_reg <= 1'b0;
        end
        else begin
            state <= next_state;
            early_end_reg <= early_end;
        end
    end
end

always @(*) begin
    
    early_end = 1'b0;
    
    case(state)
        STM_LINK_FAILED:
        begin
            next_state = STM_WAIT_FOR_K__RX_K;
        end
        
        STM_WAIT_FOR_K__RX_K:
        begin
            // Priority 1
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] == /D21.5/ + /D2.2/)
            if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1)) begin
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 2
            // xmit_data == 0 &&
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] != /D/)
            else if((xmit_data == 1'b0) && is_K28_5_lane_0 && !is_D_lane_1) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 3
            // (rx_kdata[0] == /K28.5/)
            else if(is_K28_5_lane_0) begin
                next_state = STM_IDLE_D;
            end
            
            // Priority 4
            // Else
            else begin
                next_state = STM_WAIT_FOR_K__RX_K;
            end
        end
        
        STM_IDLE_D:
        begin
            // Priority 1
            // xmit_data == 1 && carrier_detect == 1 &&
            // (rx_kdata[0] == /S/)
            if((xmit_data == 1'b1) && (is_carrier_detect_lane_0 == 1'b1) && is_S_lane_0) begin
                next_state = STM_START_OF_PACKET;
            end
            
            // Priority 2
            // xmit_data == 1 && carrier_detect == 1 &&
            // (rx_kdata[0] != /S/) &&
            // (rx_kdata[0] != /K28.5/)
            else if((xmit_data == 1'b1) && (is_carrier_detect_lane_0 == 1'b1) && !is_S_lane_0 && !is_K28_5_lane_0) begin
                next_state = STM_FALSE_CARRIER;
            end
            
            // Priority 3
            // xmit_data == 0 &&
            // (rx_kdata[0] != /K28.5/)
            else if((xmit_data == 1'b0) && !is_K28_5_lane_0) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 4
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] == /D21.5/ + /D2.2/)
            else if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1)) begin
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 5
            // xmit_data == 0 &&
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] != /D/)
            else if((xmit_data == 1'b0) && is_K28_5_lane_0 && !is_D_lane_1) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 6
            // Else
            else begin
                next_state = STM_IDLE_D;
            end
        end
        
        STM_FALSE_CARRIER:
        begin
            // Priority 1
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] == /D21.5/ + /D2.2/)
            if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1)) begin
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 2
            // xmit_data == 0 &&
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] != /D/)
            else if((xmit_data == 1'b0) && is_K28_5_lane_0 && !is_D_lane_1) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 3
            // (rx_kdata[0] == /K28.5/)
            else if(is_K28_5_lane_0) begin
                next_state = STM_IDLE_D;
            end
            
            // Priority 4
            // Else
            else begin
                next_state = STM_FALSE_CARRIER;
            end
        end
        
        STM_RX_INVALID:
        begin
            // Priority 1
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] == /D21.5/ + /D2.2/)
            if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1)) begin
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 2
            // xmit_data == 0 &&
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] != /D/)
            else if((xmit_data == 1'b0) && is_K28_5_lane_0 && !is_D_lane_1) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 3
            // (rx_kdata[0] == /K28.5/)
            else if(is_K28_5_lane_0) begin
                next_state = STM_IDLE_D;
            end
            
            // Priority 4
            // Else
            else begin
                next_state = STM_WAIT_FOR_K__RX_K;
            end
        end
        
        STM_RX_CB__RX_CC:
        begin
            // Priority 1
            // (rx_kdata[0] == /D/) &&
            // (rx_kdata[1] == /D/)
            if(is_D_lane_0 && is_D_lane_1) begin
                next_state = STM_RX_CD;
            end
            
            // Priority 2
            // Else
            else begin
                next_state = STM_RX_INVALID;
            end
        end
        
        STM_RX_CD:
        begin
            // Priority 1
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] == /D21.5/ + /D2.2/)
            if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1)) begin
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 2
            // xmit_data == 0 &&
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] != /D/)
            else if((xmit_data == 1'b0) && is_K28_5_lane_0 && !is_D_lane_1) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 3
            // (rx_kdata[0] == /K28.5/)
            else if(is_K28_5_lane_0) begin
                next_state = STM_IDLE_D;
            end
            
            // Priority 4
            // Else
            else begin
                next_state = STM_RX_INVALID;
            end
        end
        
        STM_START_OF_PACKET:
        begin
            next_state = STM_RX_DATA__RX_DATA_ERROR;
        end
        
        STM_RX_DATA__RX_DATA_ERROR:
        begin
            // Priority 1
            // check_end3_0 == /K28.5/D21.5+D2.2/D0.0/
            if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1) && is_D0_0_next_lane_0) begin
                early_end = 1'b1;
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 2
            // check_end3_0 == /K28.5/D/K28.5/
            else if(is_K28_5_lane_0 && is_D_lane_1 && is_K28_5_next_lane_0) begin
                early_end = 1'b1;
                next_state = STM_IDLE_D;
            end
            
            // Priority 3
            // check_end3_0 == /T/R/K28.5/
            else if(is_T_lane_0 && is_R_lane_1 && is_K28_5_next_lane_0) begin
                next_state = STM_TRI_RRI;
            end
            
            // Priority 4
            // check_end4_0 == /T/R/R/R/
            else if(is_T_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_TRRR_0;
            end
            
            // Priority 5
            // check_end3_1 == /T/R/R/
            else if(is_T_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_TRR_1;
            end
            
            // Priority 6
            // check_end4_0 == /T/R/R/!R/
            else if(is_T_lane_0 && is_R_lane_1 && is_R_next_lane_0 && !is_R_next_lane_1) begin
                next_state = STM_EXTEND_ERR_TRRE_0;
            end
            
            // Priority 7
            // check_end4_0 == /R/R/R/R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EARLY_END_EXT_RRRR_0;
            end
            
            // Priority 8
            // check_end3_1 == /R/R/R/
            else if(is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EARLY_END_EXT_RRR_1;
            end
            
            // Priority 9
            // check_end4_0 == /R/R/R/!R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && !is_R_next_lane_1) begin
                next_state = STM_EARLY_END_EXTEND_ERR_RRRE_0;
            end
            
            // Priority 10
            // Else
            else begin
                next_state = STM_RX_DATA__RX_DATA_ERROR;
            end
        end
        
        STM_TRI_RRI:
        begin
            // Priority 1
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] == /D21.5/ + /D2.2/)
            if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1)) begin
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 2
            // xmit_data == 0 &&
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] != /D/)
            else if((xmit_data == 1'b0) && is_K28_5_lane_0 && !is_D_lane_1) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 3
            // (rx_kdata[0] == /K28.5/)
            // Else
            else begin
                next_state = STM_IDLE_D;
            end
        end
        
        STM_EXTEND_TRRR_0:
        begin
            // Priority 1
            // check_end3_0 == /R/R/K28.5/
            if(is_R_lane_0 && is_R_lane_1 && is_K28_5_next_lane_0) begin
                next_state = STM_TRI_RRI;
            end
            
            // Priority 2
            // check_end4_0 == /R/R/R/R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_TRRR_0;
            end
            
            // Priority 3
            // check_end4_0 == /R/R/R/!R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && !is_R_next_lane_1) begin
                next_state = STM_EXTEND_ERR_TRRE_0;
            end
            
            // Priority 4
            // Else
            // Equivalent: check_end3_0 == /R/R/(!R * !K28.5)/
            else begin
                next_state = STM_EXTEND_ERR_RRE_1;
            end
        end
        
        STM_EXTEND_TRR_1:
        begin
            // Priority 1
            // check_end3_0 == /R/R/K28.5/
            if(is_R_lane_0 && is_R_lane_1 && is_K28_5_next_lane_0) begin
                next_state = STM_TRI_RRI;
            end
            
            // Priority 2
            // check_end4_0 == /R/R/R/R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_TRRR_0;
            end
            
            // Priority 3
            // check_end4_0 == /R/R/R/!R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && !is_R_next_lane_1) begin
                next_state = STM_EXTEND_ERR_TRRE_0;
            end
            
            // Priority 4
            // Else
            // Equivalent: check_end3_0 == /R/R/(!R * !K28.5)/
            else begin
                next_state = STM_EXTEND_ERR_RRE_1;
            end
        end
        
        STM_EXTEND_ERR_TRRE_0:
        begin
            next_state = STM_EXTEND_ERR;
        end
        
        STM_EXTEND_ERR_RRE_1:
        begin
            // Priority 1
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] == /D21.5/ + /D2.2/)
            if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1)) begin
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 2
            // xmit_data == 0 &&
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] != /D/)
            else if((xmit_data == 1'b0) && is_K28_5_lane_0 && !is_D_lane_1) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 3
            // (rx_kdata[0] == /K28.5/)
            else if(is_K28_5_lane_0) begin
                next_state = STM_IDLE_D;
            end
            
            // Priority 4
            // Else
            else begin
                next_state = STM_EXTEND_ERR;
            end
        end
        
        STM_EXTEND_ERR:
        begin
            // Priority 1
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] == /D21.5/ + /D2.2/)
            if(is_K28_5_lane_0 && (is_D21_5_lane_1 || is_D2_2_lane_1)) begin
                next_state = STM_RX_CB__RX_CC;
            end
            
            // Priority 2
            // xmit_data == 0 &&
            // (rx_kdata[0] == /K28.5/) &&
            // (rx_kdata[1] != /D/)
            else if((xmit_data == 1'b0) && is_K28_5_lane_0 && !is_D_lane_1) begin
                next_state = STM_RX_INVALID;
            end
            
            // Priority 3
            // (rx_kdata[0] == /K28.5/)
            else if(is_K28_5_lane_0) begin
                next_state = STM_IDLE_D;
            end
            
            // Priority 4
            // check_end3_0 == /R/R/K28.5/
            if(is_R_lane_0 && is_R_lane_1 && is_K28_5_next_lane_0) begin
                next_state = STM_TRI_RRI;
            end
            
            // Priority 5
            // check_end4_0 == /R/R/R/R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_TRRR_0;
            end
            
            // Priority 6
            // check_end4_0 == /R/R/R/!R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && !is_R_next_lane_1) begin
                next_state = STM_EXTEND_ERR_TRRE_0;
            end
            
            // Priority 7
            // check_end3_0 == /R/R/(!R * !K28.5)/
            else if(is_R_lane_0 && is_R_lane_1 && !is_R_next_lane_0 && !is_K28_5_next_lane_0) begin
                next_state = STM_EXTEND_ERR_RRE_1;
            end
            
            // Priority 8
            // check_end4_0 == /(!R * !K28.5)/R/R/R/
            else if(!is_R_lane_0 && !is_K28_5_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_ERR_ERRR_0;
            end
            
            // Priority 9
            // Else
            else begin
                next_state = STM_EXTEND_ERR;
            end
        end
        
        STM_EXTEND_ERR_ERRR_0:
        begin
            // Priority 1
            // check_end3_0 == /R/R/K28.5/
            if(is_R_lane_0 && is_R_lane_1 && is_K28_5_next_lane_0) begin
                next_state = STM_TRI_RRI;
            end
            
            // Priority 2
            // check_end4_0 == /R/R/R/R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_TRRR_0;
            end
            
            // Priority 3
            // check_end4_0 == /R/R/R/!R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && !is_R_next_lane_1) begin
                next_state = STM_EXTEND_ERR_TRRE_0;
            end
            
            // Priority 4
            // Else
            // Equivalent: check_end3_0 == /R/R/(!R * !K28.5)/
            else begin
                next_state = STM_EXTEND_ERR_RRE_1;
            end
        end
        
        STM_EARLY_END_EXT_RRRR_0:
        begin
            // Priority 1
            // check_end3_0 == /R/R/K28.5/
            if(is_R_lane_0 && is_R_lane_1 && is_K28_5_next_lane_0) begin
                next_state = STM_TRI_RRI;
            end
            
            // Priority 2
            // check_end4_0 == /R/R/R/R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_TRRR_0;
            end
            
            // Priority 3
            // check_end4_0 == /R/R/R/!R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && !is_R_next_lane_1) begin
                next_state = STM_EXTEND_ERR_TRRE_0;
            end
            
            // Priority 4
            // Else
            // Equivalent: check_end3_0 == /R/R/(!R * !K28.5)/
            else begin
                next_state = STM_EXTEND_ERR_RRE_1;
            end
        end
        
        STM_EARLY_END_EXT_RRR_1:
        begin
            // Priority 1
            // check_end3_0 == /R/R/K28.5/
            if(is_R_lane_0 && is_R_lane_1 && is_K28_5_next_lane_0) begin
                next_state = STM_TRI_RRI;
            end
            
            // Priority 2
            // check_end4_0 == /R/R/R/R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && is_R_next_lane_1) begin
                next_state = STM_EXTEND_TRRR_0;
            end
            
            // Priority 3
            // check_end4_0 == /R/R/R/!R/
            else if(is_R_lane_0 && is_R_lane_1 && is_R_next_lane_0 && !is_R_next_lane_1) begin
                next_state = STM_EXTEND_ERR_TRRE_0;
            end
            
            // Priority 4
            // Else
            // Equivalent: check_end3_0 == /R/R/(!R * !K28.5)/
            else begin
                next_state = STM_EXTEND_ERR_RRE_1;
            end
        end
        
        STM_EARLY_END_EXTEND_ERR_RRRE_0:
        begin
            next_state = STM_EXTEND_ERR;
        end
        
        default:
        begin
            next_state = STM_WAIT_FOR_K__RX_K;
        end
    endcase
end

// --------------------
// Link Partner Ability
// --------------------
always @(posedge clk or posedge reset) begin
    if (reset) begin
        lp_ability_ena <= 1'b0;
        lp_ability <= 16'h0;
    end
    else begin
        if (sw_reset) begin
            lp_ability_ena <= 1'b0;
            lp_ability <= 16'h0;
        end
        else begin
            if (state == STM_RX_CD) begin
                lp_ability_ena <= 1'b1;
                lp_ability <= {rx_data_aligned_p3[15:8], rx_data_aligned_p3[7:0]};
            end
            else begin
                lp_ability_ena <= 1'b0;
                lp_ability <= lp_ability;
            end
        end
    end
end

// -----------------------
// Idle Receive Indication
// -----------------------
always @(posedge clk or posedge reset) begin
    if (reset) begin
        idle_ena <= 1'b0;
    end
    else begin
        if (sw_reset) begin
            idle_ena <= 1'b0;
        end
        else begin
            if (state == STM_IDLE_D) begin
                idle_ena <= 1'b1;
            end
            else begin
                idle_ena <= 1'b0;
            end
        end
    end
end

// --------------
// Receive Status
// --------------
always @(posedge clk or posedge reset) begin
    if (reset) begin
        receive <= 1'b0;
    end
    else begin
        if (sw_reset) begin
            receive <= 1'b0;
        end
        else begin
            if(
               (state == STM_START_OF_PACKET) ||
               (state == STM_FALSE_CARRIER) ||
               ((state == STM_RX_INVALID) && (xmit_data == 1'b1))
            ) begin
                receive <= 1'b1;
            end
            else if(
                (state == STM_LINK_FAILED) ||
                (state == STM_WAIT_FOR_K__RX_K) ||
                (state == STM_IDLE_D) ||
                (state == STM_RX_CB__RX_CC) ||
                (state == STM_TRI_RRI)
            ) begin
                receive <= 1'b0;
            end
        end
    end
end

// -----------------
// Character Invalid
// -----------------
always @(posedge clk or posedge reset) begin
    if (reset) begin
        rx_invalid <= 1'b0;
    end
    else begin
        if (sw_reset) begin
            rx_invalid <= 1'b0;
        end
        else begin
            if(((state == STM_LINK_FAILED) || (state == STM_RX_INVALID)) && (xmit_data == 1'b0)) begin
                rx_invalid <= 1'b1;
            end
            else begin
                rx_invalid <= 1'b0;
            end
        end
    end
end

// -----------------------
// GMII
// -----------------------
always @(posedge clk or posedge reset) begin
    if (reset) begin
        gmii_dv   <= 2'b00;
        gmii_err  <= 2'b00;
        gmii_data <= {8'h0, 8'h0};
        pcs_dv_single_bit <= 1'b0;
    end
    else begin
        if (sw_reset) begin
            gmii_dv   <= 2'b00;
            gmii_err  <= 2'b00;
            gmii_data <= {8'h0, 8'h0};
            pcs_dv_single_bit <= 1'b0;
        end
        else begin
            case(state)
                STM_LINK_FAILED:
                begin
                    if(receive) begin
                        gmii_dv   <= 2'b00;
                        gmii_err  <= 2'b11;
                        gmii_data <= {8'h0, 8'h0};
                        pcs_dv_single_bit <= 1'b0;
                    end
                    else begin
                        gmii_dv   <= 2'b00;
                        gmii_err  <= 2'b00;
                        gmii_data <= {8'h0, 8'h0};
                        pcs_dv_single_bit <= 1'b0;
                    end
                end
                
                STM_WAIT_FOR_K__RX_K:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b00;
                    gmii_data <= {8'h0, 8'h0};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_IDLE_D:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= early_end_reg ? 2'b01 : 2'b00;
                    gmii_data <= {8'h0, 8'h0};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_FALSE_CARRIER:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b11;
                    gmii_data <= {8'h0E, 8'h0E};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_RX_CB__RX_CC:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= early_end_reg ? 2'b01 : 2'b00;
                    gmii_data <= {8'h0, 8'h0};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_START_OF_PACKET:
                begin
                    gmii_dv   <= 2'b11;
                    gmii_err  <= {rx_kchar_aligned_p3[1], 1'b0};
                    gmii_data <= {rx_data_aligned_p3[15:8], 8'h55};
                    pcs_dv_single_bit <= 1'b1;
                end
                
                STM_RX_DATA__RX_DATA_ERROR:
                begin
                    gmii_dv   <= 2'b11;
                    gmii_err  <= {rx_kchar_aligned_p3[1], rx_kchar_aligned_p3[0]};
                    gmii_data <= {rx_data_aligned_p3[15:8], rx_data_aligned_p3[7:0]};
                    pcs_dv_single_bit <= 1'b1;
                end
                
                STM_TRI_RRI:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b00;
                    gmii_data <= {8'h0, 8'h0};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_EXTEND_TRRR_0:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b11;
                    gmii_data <= {8'h0F, 8'h0F};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_EXTEND_TRR_1:
                begin
                    gmii_dv   <= 2'b01;
                    gmii_err  <= 2'b10;
                    gmii_data <= {8'h0F, rx_data_aligned_p3[7:0]};
                    pcs_dv_single_bit <= 1'b1;
                end
                
                STM_EXTEND_ERR_TRRE_0:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b11;
                    gmii_data <= {8'h1F, 8'h0F};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_EXTEND_ERR_RRE_1:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b11;
                    gmii_data <= {8'h1F, 8'h1F};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_EXTEND_ERR:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b11;
                    gmii_data <= {8'h1F, 8'h1F};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_EXTEND_ERR_ERRR_0:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b11;
                    gmii_data <= {8'h0F, 8'h1F};
                    pcs_dv_single_bit <= 1'b0;
                end
                
                STM_EARLY_END_EXT_RRRR_0:
                begin
                    gmii_dv   <= 2'b01;
                    gmii_err  <= 2'b11;
                    gmii_data <= {8'h0F, rx_data_aligned_p3[7:0]};
                    pcs_dv_single_bit <= 1'b1;
                end
                
                STM_EARLY_END_EXT_RRR_1:
                begin
                    gmii_dv   <= 2'b11;
                    gmii_err  <= 2'b10;
                    gmii_data <= {rx_data_aligned_p3[15:8], rx_data_aligned_p3[7:0]};
                    pcs_dv_single_bit <= 1'b1;
                end
                
                STM_EARLY_END_EXTEND_ERR_RRRE_0:
                begin
                    gmii_dv   <= 2'b01;
                    gmii_err  <= 2'b11;
                    gmii_data <= {8'h1F, rx_data_aligned_p3[7:0]};
                    pcs_dv_single_bit <= 1'b1;
                end
                
                default:
                begin
                    gmii_dv   <= 2'b00;
                    gmii_err  <= 2'b00;
                    gmii_data <= {8'h0, 8'h0};
                    pcs_dv_single_bit <= 1'b0;
                end
            endcase
        end
    end
end

endmodule // module rx_encapsulation
