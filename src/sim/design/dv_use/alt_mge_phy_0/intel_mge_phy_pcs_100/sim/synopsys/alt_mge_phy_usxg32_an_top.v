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

module alt_mge_phy_usxg32_an_top #(
    parameter SYNCHRONIZER_DEPTH = 3,
    parameter TIMER_WIDTH = 20
) (
    // Clock
    input                   tx_clk,         // Clock 312.5 MHz
    input                   rx_clk,         // Clock 322.265625 MHz
    
    // Reset
    input                   tx_reset_n,     //  Active High Global Reset
    input                   rx_reset_n,     //  Active High Global Reset
    input                   rx_areset_n,     //  Active High Global Reset
    
    // RX XGMII In
    input                   rx_xgmii_valid_in,
    input             [3:0] rx_xgmii_control_in,
    input            [31:0] rx_xgmii_data_in,
    
    // TX XGMII Out
    output                  tx_xgmii_valid_out,
    output            [3:0] tx_xgmii_control_out,
    output           [31:0] tx_xgmii_data_out,
    
    // Input from CSR
    input                   an_enable,      //  Enable Autonegotiation
    input                   an_restart,     //  Restart Autonegotiation
    input                   an_resp_mode,   //  Autonegotiation Response Mode
    input            [15:0] an_ability_in,  //  Device Ability Register
    input [TIMER_WIDTH-1:0] max_link_timer, //  Link Timer Maximum Value (2 clocks)
    
    // Output to CSR
    output reg              lp_ability_ena, //  Link Partner Ability Valid
    output reg  [15:0]      lp_ability,     //  Link Partner Ability Register
    output                  an_restart_rst, //  Reset Re-Negotiate Command
    output reg              page_receive,   //  Page Receive
    output reg              an_done,        //  Autonegotiation Done
    output reg              an_ack,         //  Acknowledge Indication
    
    // Input for State Machine
    input                   rx_sync         //  Link Synchronization (Block lock)
    
);

// State Machine
localparam STM_TYP_AUTONEG_ENA      = 3'h0;
localparam STM_TYP_AUTONEG_RESTART  = 3'h1;
localparam STM_TYP_ABILITY_DETECT   = 3'h2;
localparam STM_TYP_ACK_DETECT       = 3'h3;
localparam STM_TYP_COMPLETE_ACK     = 3'h4;
localparam STM_TYP_IDLE_DETECT      = 3'h5;
localparam STM_TYP_LINK_OK          = 3'h6;
localparam STM_TYP_NO_AN_LINK       = 3'h7;

// XGMII Constants
localparam CONST_UXGMII_SEQ_ORDER   = 8'h9C;
localparam CONST_UXGMII_AUTONEG     = 8'h03;
localparam CONST_UXGMII_IDLE        = 8'h07;

// Input to the state machine, decoded from RX XGMII input
reg         idle_ena;               //  Idle Received
wire        rx_invalid;             //  Invalid Signal

// TX config words to be transmitted
reg  [ 2:0] lp_ability_speed;
reg  [15:0] an_ability_out;

// Control XGMII output based on current states
reg         xmit_idle;
reg         xmit_data;

// XGMII output at rx_clk domain
reg         xgmii_valid_out;
reg  [3:0]  xgmii_control_out;
reg  [31:0] xgmii_data_out;

// State Machine
reg  [2:0]  state;
reg  [2:0]  nextstate;

reg  [TIMER_WIDTH-1:0] link_timer;  //  Link Timer 1 to 2ms
reg         link_timer_dec;         //  Link Timer Expiration Decoding
reg         an_restart_rst_i;       //  Reset Autonegotiation Restart Command

//  Ability / Acknowledge Detect
reg  [1:0]  rx_abiliy_cnt;          //  Link Partner Ability Count
reg  [1:0]  rx_ack_cnt;             //  Link Partner Acknowledge Count
reg  [15:0] rx_ability_reg;         //  Latched Link Partner Ability
reg  [15:0] rx_ability_match_reg;   //  Ability Match Value

//  Ability Register Decoding
reg         ability_match;          //  Ability Match
reg         ability_zero;           //  Partnet Ability is 0x"0000"
reg         ack_match;              //  Acknowledge Match
reg         consist_match;          //  Consistancy Match

//  Idle Detect
reg  [1:0]  idle_cnt;               //  Idle Count
reg         idle_match;             //  Idle Match

//  Link Status Control
reg         an_sync_status;         //  Link Status
reg  [TIMER_WIDTH-1:0] an_sync_cnt; //  Link Sync Timeout

//  Asynchronous Signals Synchronization
reg         an_enable_reg;
reg         rx_sync_reg;

// Flop the block_lock signal from HSSI once before used in counter for better timing
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        rx_sync_reg <= 1'b0;
    end
    else begin
        rx_sync_reg <= rx_sync;
    end
end

// Flop to detect change of AN enable CSR
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        an_enable_reg <= 1'b0;
    end
    else begin
        an_enable_reg <= an_enable;
    end
end

// Decode RX XGMII input to extract RX config words from AN sequence order set
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        lp_ability_ena <= 1'b0;
        lp_ability     <= 16'h0;
    end
    else begin
        if(rx_xgmii_valid_in) begin
            
            if((rx_xgmii_control_in == 4'b0001) &&
               (rx_xgmii_data_in[7:0] == CONST_UXGMII_SEQ_ORDER) &&
               (rx_xgmii_data_in[31:24] == CONST_UXGMII_AUTONEG)
            ) begin
                lp_ability_ena <= 1'b1;
                lp_ability <= {rx_xgmii_data_in[15:8], rx_xgmii_data_in[23:16]};
            end
            else begin
                lp_ability_ena <= 1'b0;
            end
        end
    end
end

// Link partner dev abilitiy of external PHY
// This info is used to transmit back to external USXGMII PHY
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        lp_ability_speed <= 3'b000;
    end
    else begin
        // Default to 10G when link partner ability received are all zero
        // Set the speed according to partner ability received
        lp_ability_speed <= (|lp_ability == 1'b0) ? 3'b011 : lp_ability[11:9];
    end
end

// Decode RX XGMII input to detect received IDLEs
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        idle_ena <= 1'b0;
    end
    else begin
        if(rx_xgmii_valid_in) begin
            if(
               ((rx_xgmii_control_in[0] == 1'b1) && (rx_xgmii_data_in[ 7: 0] == CONST_UXGMII_IDLE)) &&
               ((rx_xgmii_control_in[1] == 1'b1) && (rx_xgmii_data_in[15: 8] == CONST_UXGMII_IDLE)) &&
               ((rx_xgmii_control_in[2] == 1'b1) && (rx_xgmii_data_in[23:16] == CONST_UXGMII_IDLE)) &&
               ((rx_xgmii_control_in[3] == 1'b1) && (rx_xgmii_data_in[31:24] == CONST_UXGMII_IDLE))
            ) begin
                idle_ena <= 1'b1;
            end
            else begin
                idle_ena <= 1'b0;
            end
        end
    end
end

// RUDI(Invalid) in IEEE 802.3 Clause 37 changed to IDLE in USXGMII AN
assign rx_invalid = idle_ena;

// State Machine
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        state <= STM_TYP_AUTONEG_ENA;
    end
    else begin
        if((an_sync_status == 1'b0) ||
           ((an_enable == 1'b1) && (an_restart_rst_i == 1'b1)) ||
           (rx_invalid == 1'b1 && ((state == STM_TYP_AUTONEG_RESTART) || (state == STM_TYP_ABILITY_DETECT) || (state == STM_TYP_ACK_DETECT))) ||
           (an_enable ^ an_enable_reg)) begin
            state <= STM_TYP_AUTONEG_ENA;
        end
        else begin
            state <= nextstate;
        end
    end
end

always @(*) begin
    case(state)
        
        STM_TYP_AUTONEG_ENA: begin
            
            //  Autonegotiation Disabled
            if(an_enable == 1'b0) begin
                nextstate = STM_TYP_NO_AN_LINK;
            end
            
            else begin
                nextstate = STM_TYP_AUTONEG_RESTART;
            end
        end
        
        STM_TYP_AUTONEG_RESTART: begin
            if(link_timer_dec == 1'b1) begin
                nextstate = STM_TYP_ABILITY_DETECT;
            end
            
            else begin
                nextstate = STM_TYP_AUTONEG_RESTART;
            end
        end
        
        STM_TYP_ABILITY_DETECT: begin
            if(ability_match == 1'b1 & ability_zero == 1'b0) begin
                nextstate = STM_TYP_ACK_DETECT;
            end
            
            else begin
                nextstate = STM_TYP_ABILITY_DETECT;
            end
        end
        
        STM_TYP_ACK_DETECT: begin
            if((consist_match == 1'b1) && (ack_match == 1'b1)) begin
                nextstate = STM_TYP_COMPLETE_ACK;
            end
            
            else if((ability_match == 1'b1) && (ability_zero == 1'b1)) begin
                nextstate = STM_TYP_AUTONEG_ENA;
            end
            
            else if((ack_match == 1'b1) && (consist_match == 1'b0)) begin
                nextstate = STM_TYP_AUTONEG_ENA;
            end
            
            else begin
                nextstate = STM_TYP_ACK_DETECT;
            end
        end
        
        STM_TYP_COMPLETE_ACK: begin
            if((link_timer_dec == 1'b1) && ((ability_match == 1'b0) || (ability_zero == 1'b0))) begin
                nextstate = STM_TYP_IDLE_DETECT;
            end
            
            else if((ability_match == 1'b1) && (ability_zero == 1'b1)) begin
                nextstate = STM_TYP_AUTONEG_ENA;
            end
            
            else begin
                nextstate = STM_TYP_COMPLETE_ACK;
            end
        end
        
        STM_TYP_IDLE_DETECT: begin
            if((idle_match == 1'b1) && (link_timer_dec == 1'b1)) begin
                nextstate = STM_TYP_LINK_OK;
            end
            
            else if((ability_match == 1'b1) && (ability_zero == 1'b1)) begin
                nextstate = STM_TYP_AUTONEG_ENA;
            end
            
            else begin
                nextstate = STM_TYP_IDLE_DETECT;
            end
        end
        
        STM_TYP_LINK_OK: begin
            if(ability_match == 1'b1) begin
                nextstate = STM_TYP_AUTONEG_ENA;
            end
            
            else begin
                nextstate = STM_TYP_LINK_OK;
            end
        end
        
        STM_TYP_NO_AN_LINK: begin
            if(an_enable == 1'b1) begin
                nextstate = STM_TYP_AUTONEG_ENA;
            end
            
            else begin
                nextstate = STM_TYP_NO_AN_LINK;
            end
        end
        
        default: begin
                nextstate = STM_TYP_AUTONEG_ENA;
        end
        
    endcase
end

//  Ability Latch and Decoding
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        rx_ability_reg       <= {16{1'b0}};
        rx_ability_match_reg <= {16{1'b0}};
        
        rx_abiliy_cnt        <= 2'h0;
        rx_ack_cnt           <= 2'h0;
        
        ability_match        <= 1'b0;
        ack_match            <= 1'b0;
        consist_match        <= 1'b0;
        ability_zero         <= 1'b0;
    end
    else begin
        if(rx_xgmii_valid_in) begin
            if(state == STM_TYP_AUTONEG_ENA) begin
                rx_ability_reg       <= {16{1'b0}};
                rx_ability_match_reg <= {16{1'b0}};
                
                rx_abiliy_cnt        <= 2'h0;
                rx_ack_cnt           <= 2'h0;
                
                ability_match        <= 1'b0;
                ack_match            <= 1'b0;
                consist_match        <= 1'b0;
                ability_zero         <= 1'b0;
            end
            
            else begin
                
                // Latch Match Value for Consistancy Check
                if(lp_ability_ena == 1'b1) begin
                    rx_ability_reg <= lp_ability;
                end
                else begin
                    rx_ability_reg <= {16{1'b0}};
                end
                
                // Use rx_abiliy_cnt and rx_ack_cnt instead of ability_match and ack_match,
                // to ensure we are latching the same value that cause ability_match and ack_match to assert
                if((rx_abiliy_cnt == 2'h2) && (state == STM_TYP_ABILITY_DETECT)) begin
                    rx_ability_match_reg <= rx_ability_reg;
                end
                
                // Check for three consecutive ability match
                if(lp_ability_ena == 1'b1) begin
                    
                    // Check for three consecutive ability match
                    if(
                        ((state == STM_TYP_AUTONEG_RESTART) && (nextstate == STM_TYP_ABILITY_DETECT)) ||
                        ((state == STM_TYP_ACK_DETECT) && (nextstate == STM_TYP_COMPLETE_ACK))
                       ) begin
                        rx_abiliy_cnt <= 2'h0;
                    end
                    else if((lp_ability[15] == rx_ability_reg[15]) && (lp_ability[13:0] == rx_ability_reg[13:0])) begin
                        if(rx_abiliy_cnt != 2'h2) begin
                            rx_abiliy_cnt <= rx_abiliy_cnt + 2'h1;
                        end
                    end
                    else begin
                        rx_abiliy_cnt <= 2'h0;
                    end
                    
                    // Check for three consecutive acknowledge match
                    if(
                        ((state == STM_TYP_ABILITY_DETECT) && (nextstate == STM_TYP_ACK_DETECT))
                       ) begin
                        rx_ack_cnt <= 2'h0;
                    end
                    else if((lp_ability == rx_ability_reg) && (rx_ability_reg[14] == 1'b1)) begin
                        if(rx_ack_cnt != 2'h2) begin
                            rx_ack_cnt <= rx_ack_cnt + 2'h1;
                        end
                    end
                    else begin
                        rx_ack_cnt <= 2'h0;
                    end
                end
                else begin
                    rx_abiliy_cnt <= 2'h0;
                    rx_ack_cnt <= 2'h0;
                end
                
                // Ability is Latched when Three Concecutive Matching Values are Received
                // Used for Consitency Check
                
                // Ability Match
                if((rx_abiliy_cnt == 2'h2) && (state==nextstate)) begin
                    ability_match <= 1'b1;
                end
                else begin
                    ability_match <= 1'b0;
                end
                
                //  Acknowledge Match
                if((rx_ack_cnt == 2'h2) && (rx_abiliy_cnt == 2'h2) && (state==nextstate)) begin
                    ack_match <= 1'b1;
                end
                else begin
                    ack_match <= 1'b0;
                end
                
                // Consistancy Match
                if((rx_ability_match_reg[15] == rx_ability_reg[15]) && (rx_ability_match_reg[13:0] == rx_ability_reg[13:0])) begin
                    consist_match <= 1'b1;
                end
                else begin
                    consist_match <= 1'b0;
                end
                
                //  Link Partner Ability Set to 0x0000 Detection
                if(rx_ability_reg == 16'h0000) begin
                    ability_zero <= 1'b1;
                end
                else begin
                    ability_zero <= 1'b0;
                end
            end
        end
    end
end

//  Idle Detection
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        idle_cnt <= 2'h0;
    end
    else begin
        if(rx_xgmii_valid_in) begin
            if((idle_ena == 1'b1) && (idle_cnt != 2'h3)) begin
                idle_cnt <= idle_cnt + 2'h1;
            end
            else if(idle_ena == 1'b0) begin
                idle_cnt <= 2'h0;
            end
            else if(lp_ability_ena == 1'b1) begin
                idle_cnt <= 2'h0;
            end
        end
    end
end

always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        idle_match <= 1'b0;
    end
    else begin
        if(rx_xgmii_valid_in) begin
            if((idle_cnt == 2'h3) && (state==nextstate)) begin
                idle_match <= 1'b1;
            end
            else begin
                idle_match <= 1'b0;
            end
        end
    end
end

// Acknowledge Indication
// Since this register is running based on recovered clock, no clock is running upon reset
// Therefore async reset is used to ensure CSR status are reflected correctly upon reset
always @(posedge rx_clk or negedge rx_areset_n) begin
    if(~rx_areset_n) begin
        an_ack <= 1'b0;
    end
    else begin
        if(nextstate == STM_TYP_ACK_DETECT) begin
            an_ack <= 1'b1;
        end
        else if(nextstate == STM_TYP_AUTONEG_RESTART) begin
            an_ack <= 1'b0;
        end
    end
end

// Autonegotiation Done
// Since this register is running based on recovered clock, no clock is running upon reset
// Therefore async reset is used to ensure CSR status are reflected correctly upon reset
always @(posedge rx_clk or negedge rx_areset_n) begin
    if(~rx_areset_n) begin
        an_done <= 1'b0;
    end
    else begin
        if(nextstate == STM_TYP_LINK_OK) begin
            an_done <= 1'b1;
        end
        else begin
            an_done <= 1'b0;
        end
    end
end

// Reset Re-Negotiation Command Bit
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        an_restart_rst_i <= 1'b0;
    end
    else begin
        if(an_restart == 1'b1) begin
            an_restart_rst_i <= 1'b1;
        end
        else if(an_restart == 1'b0) begin
            an_restart_rst_i <= 1'b0;
        end
    end
end

assign an_restart_rst = an_restart_rst_i;

// Link Timer
// This is running at 322.265625 MHz clock domain
// We qualify the logic with rx_xgmii_valid_in which toggle effectively at 312.5 MHz clock rate
// Therefore the link_timer counted as in 312.5 MHz clock
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        link_timer <= {TIMER_WIDTH{1'b0}};
    end
    else begin
        if(rx_xgmii_valid_in) begin
            if((state == STM_TYP_AUTONEG_ENA) || (state == STM_TYP_ACK_DETECT) ||
              ((state == STM_TYP_COMPLETE_ACK) && (nextstate == STM_TYP_IDLE_DETECT))) begin
                link_timer <= {TIMER_WIDTH{1'b0}};
            end
            else if((state == STM_TYP_AUTONEG_RESTART) || (state == STM_TYP_IDLE_DETECT) || (state == STM_TYP_COMPLETE_ACK)) begin
                if(link_timer_dec == 1'b0) begin
                    link_timer <= link_timer + {{(TIMER_WIDTH-1){1'b0}}, 1'b1};
                end
            end
        end
    end
end

always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        link_timer_dec <= 1'b0;
    end
    else begin
        if(rx_xgmii_valid_in) begin
            if((state == STM_TYP_AUTONEG_ENA) || (state == STM_TYP_ACK_DETECT) ||
              ((state == STM_TYP_COMPLETE_ACK) && (nextstate == STM_TYP_IDLE_DETECT))) begin
                link_timer_dec <= 1'b0;
            end
            else begin
                // Reduce lsb in comparator so that link_timer_dec could be asserted a cycle earlier,
                // and used to stop counting of link_timer, to save resource by not using 17-bit comparator
                if(link_timer[TIMER_WIDTH-1:1] == max_link_timer[TIMER_WIDTH-1:1]) begin
                    link_timer_dec <= 1'b1;
                end
                else begin
                    link_timer_dec <= 1'b0;
                end
            end
        end
    end
end

// Link Status Detection
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        an_sync_cnt <= {TIMER_WIDTH{1'b0}};
    end
    else begin
        // Link Acquired
        if(rx_sync_reg == 1'b1) begin
            an_sync_cnt <= {TIMER_WIDTH{1'b0}};
        end
        
        // Link Lost
        else begin
            if(an_sync_status == 1'b1) begin
                an_sync_cnt <= an_sync_cnt + {{(TIMER_WIDTH-1){1'b0}}, 1'b1};
            end
        end
    end
end

always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        an_sync_status <= 1'b0;
    end
    else begin
        if(rx_sync_reg == 1'b1) begin
            an_sync_status <= 1'b1;
        end
        else if(an_sync_cnt[TIMER_WIDTH-1:1] == max_link_timer[TIMER_WIDTH-1:1]) begin
            an_sync_status <= 1'b0;
        end
    end
end

// Page Reception Indication
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        page_receive <= 1'b0;
    end
    else begin
        if(state == STM_TYP_COMPLETE_ACK) begin
            page_receive <= 1'b1;
        end
        
        else if((state == STM_TYP_AUTONEG_ENA) || (state == STM_TYP_ABILITY_DETECT) || (state == STM_TYP_AUTONEG_RESTART)) begin
            page_receive <= 1'b0;
        end
    end
end

// Device Advertisement Register
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        an_ability_out <= {16{1'b0}};
    end
    else begin
        if(state == STM_TYP_AUTONEG_ENA) begin
            an_ability_out <= {16{1'b0}};
        end
        else if(state == STM_TYP_ABILITY_DETECT) begin
            an_ability_out[15]    <= an_ability_in[15];
            an_ability_out[14]    <= 1'b0;
            an_ability_out[13]    <= an_ability_in[13];
            an_ability_out[12]    <= an_resp_mode ? 1'b1 : an_ability_in[12]; // Duplex
            an_ability_out[11:9]  <= an_resp_mode ? lp_ability_speed : an_ability_in[11:9]; // Speed
            an_ability_out[8:0]   <= an_ability_in[8:0];
        end
        else if(state == STM_TYP_ACK_DETECT) begin
            an_ability_out[15]    <= an_ability_in[15];
            an_ability_out[14]    <= 1'b1; //  Acknowledge
            an_ability_out[13]    <= an_ability_in[13];
            an_ability_out[12]    <= an_resp_mode ? 1'b1 : an_ability_in[12]; // Duplex
            an_ability_out[11:9]  <= an_resp_mode ? lp_ability_speed : an_ability_in[11:9]; // Speed
            an_ability_out[8:0]   <= an_ability_in[8:0];
        end
    end
end

// Transmit Control
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        xmit_data <= 1'b0;
        xmit_idle <= 1'b0;
    end
    else begin
        if((state == STM_TYP_LINK_OK) || (state == STM_TYP_NO_AN_LINK)) begin
            xmit_data <= 1'b1;
        end
        else begin
            xmit_data <= 1'b0;
            
            if((state == STM_TYP_LINK_OK) || (state == STM_TYP_IDLE_DETECT)) begin
                xmit_idle <= 1'b1;
            end
            else begin
                xmit_idle <= 1'b0;
            end
        end
    end
end

// XGMII output to TX Mux
always @(posedge rx_clk) begin
    if(~rx_reset_n) begin
        xgmii_valid_out   <= 1'b0;
        xgmii_control_out <= 4'h0;
        xgmii_data_out    <= 32'h0;
    end
    else begin
        if(xmit_data) begin
            xgmii_valid_out   <= 1'b0;
            xgmii_control_out <= {4{1'b1}};
            xgmii_data_out    <= {4{CONST_UXGMII_IDLE}};
        end
        else if(xmit_idle) begin
            xgmii_valid_out   <= 1'b1;
            xgmii_control_out <= {4{1'b1}};
            xgmii_data_out    <= {4{CONST_UXGMII_IDLE}};
        end
        else begin
            xgmii_valid_out   <= 1'b1;
            xgmii_control_out <= 4'b0001;
            xgmii_data_out    <= {CONST_UXGMII_AUTONEG, an_ability_out[7:0], an_ability_out[15:8], CONST_UXGMII_SEQ_ORDER};
        end
    end
end

// Clock cross output to TX clock domain
alt_mge_phy_mbow_clock_crosser #(
    .SYNCHRONIZER_DEPTH     (SYNCHRONIZER_DEPTH),
    .DATA_WIDTH             (1 + 4 + 32),
    .OUT_DATA_RESET_VALUE   ({1'b0, 4'h0, 32'h0}),
    .IN_TRANSFER_CYCLE      (6),
    .IN_VALID_LENGTH        (2)
) tx_xgmii_clock_crosser (
    .in_clk         (rx_clk),
    .out_clk        (tx_clk),
    
    .in_reset_n     (rx_reset_n),
    .out_reset_n    (tx_reset_n),
    
    .in_data        ({xgmii_valid_out, xgmii_control_out, xgmii_data_out}),
    .out_data       ({tx_xgmii_valid_out, tx_xgmii_control_out, tx_xgmii_data_out})
);

endmodule
