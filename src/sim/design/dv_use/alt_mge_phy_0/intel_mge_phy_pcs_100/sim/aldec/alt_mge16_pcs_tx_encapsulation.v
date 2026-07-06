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
// Frame Encapsulation with Configuration Sequence
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_tx_encapsulation (

   reset,
   sw_reset,
   clk,
   tx_ena,
   tx_idle,
   an_ability,
   an_ena,
   gmii_dv,
   gmii_ctl,
   gmii_data,
   disparity,
   transmit,
   kchar,
   frame);

parameter SYNCHRONIZER_DEPTH = 3;

input   reset;                  //  Active High Global Reset
input   sw_reset;               //  SW Asynchronous Reset           
input   clk;                    //  125MHz Common Clock
input   tx_ena;                 //  Enable Data Transmit - Autonegotiation Complete
input   tx_idle;                //  Enable Idle Transmit
input   [15:0] an_ability;      //  Autonegotiation Ability Register          
input   an_ena;                 //  Enable Autonegotiation
input   [1:0] gmii_dv;                //  Data Valid
input   [1:0] gmii_ctl;               //  Data Control
input   [15:0] gmii_data;        //  Data
input   disparity;              //  Current Disparity
output  transmit;               //  Frame Transmission Active
output  [1:0] kchar;                  //  Special Character Indication
output  [15:0] frame;            //  Frame

// [sxsaw] new code start

localparam CONST_K28_5  = 8'hBC;
localparam CONST_D2_2   = 8'h42;
localparam CONST_D5_6   = 8'hC5;
localparam CONST_D16_2  = 8'h50;
localparam CONST_D21_5  = 8'hB5;
localparam CONST_S      = 8'hFB;
localparam CONST_T      = 8'hFD;
localparam CONST_R      = 8'hF7;
localparam CONST_V      = 8'hFE;

localparam XMIT_IDLE_DATA                       = 4'h0 ;
localparam CONFIGURATION_C1A_C1B                = 4'h1 ;
localparam CONFIGURATION_C1C_C1D                = 4'h2 ;
localparam CONFIGURATION_C2A_C2B                = 4'h3 ;
localparam CONFIGURATION_C2C_C2D                = 4'h4 ;
localparam START_OF_PACKET__START_ERROR_0       = 4'h5 ;
localparam START_OF_PACKET__START_ERROR_1       = 4'h6 ;
localparam TX_DATA                              = 4'h7 ;
localparam END_OF_PACKET_NOEXT_TR               = 4'h8 ;
localparam END_OF_PACKET_NOEXT_DT               = 4'h9 ;
localparam END_OF_PACKET_NOEXT_RR               = 4'hA ;
localparam END_OF_PACKET_EXT_TR                 = 4'hB ;
localparam END_OF_PACKET_EXT__CARRIER_EXT_TR    = 4'hC ;
localparam END_OF_PACKET_EXT__DT                = 4'hD ;
localparam CARRIER_EXTEND                       = 4'hE ;
localparam CARRIER_EXTEND__EXTEND_BY_1          = 4'hF ;

wire        tx_ena_sync;
wire        tx_idle_sync;
wire        an_ena_sync;
wire [15:0] an_ability_sync;

wire        xmit_configuration;
wire        xmit_data;

wire [1:0]  gmii_tx_en;
wire [1:0]  gmii_tx_err;
wire [15:0] gmii_tx_data;
reg  [1:0]  gmii_tx_en_p1;
reg  [1:0]  gmii_tx_err_p1;
reg  [15:0] gmii_tx_data_p1;
reg  [1:0]  gmii_tx_err_p2;

reg  [3:0]  next_state;
reg  [3:0]  state;

reg         transmit;

reg  [1:0]  kchar;
reg  [15:0] frame;

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) sync_tx_ena (
    .clk    (clk),
    .reset_n(~reset),
    .din    (tx_ena),
    .dout   (tx_ena_sync)
);

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) sync_tx_idle (
    .clk    (clk),
    .reset_n(~reset),
    .din    (tx_idle),
    .dout   (tx_idle_sync)
);

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) sync_an_ena (
    .clk    (clk),
    .reset_n(~reset),
    .din    (an_ena),
    .dout   (an_ena_sync)
);

alt_mge_phy_std_synchronizer_bundle #(16, SYNCHRONIZER_DEPTH) sync_an_ability (
    .clk    (clk),
    .reset_n(~reset),
    .din    (an_ability),
    .dout   (an_ability_sync)
);

assign xmit_configuration = (tx_ena_sync == 1'b0) && (tx_idle_sync == 1'b0);
assign xmit_data          = (tx_ena_sync == 1'b1);

assign gmii_tx_en   = gmii_dv;
assign gmii_tx_err  = gmii_ctl;
assign gmii_tx_data = gmii_data;

// Delay received data to align with state machine
always @(posedge clk or posedge reset) begin
    if(reset) begin
        gmii_tx_en_p1 <= 2'b00;
        gmii_tx_err_p1 <= 2'b00;
        gmii_tx_data_p1 <= 16'h0;
        
        gmii_tx_err_p2 <= 2'b00;
    end
    else begin
        gmii_tx_en_p1 <= gmii_tx_en;
        gmii_tx_err_p1 <= gmii_tx_err;
        gmii_tx_data_p1 <= gmii_tx_data;
        
        gmii_tx_err_p2 <= gmii_tx_err_p1;
    end
end

// ------------------------
// State Machine Transition
// ------------------------
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= XMIT_IDLE_DATA;
    end
    else begin
        if(sw_reset) begin
            state <= XMIT_IDLE_DATA;
        end
        else begin
            state <= next_state;
        end
    end
end

always @(*) begin
    case(state)
        XMIT_IDLE_DATA:
        begin
            // Priority 1
            // (xmit == CONFIGURATION) &&
            // (an_enabled == 1)
            if((xmit_configuration == 1'b1) && (an_ena_sync == 1'b1)) begin
                next_state = CONFIGURATION_C1A_C1B;
            end
            
            // Priority 2
            // (xmit == DATA) && (gmii_tx_en_prev[1] == 1)
            else if((xmit_data == 1'b1) && (gmii_tx_en_p1[1] == 1'b1)) begin
                next_state = START_OF_PACKET__START_ERROR_1;
            end
            
            // Priority 3
            // (xmit == DATA) &&
            // (gmii_tx_en[0] == 1)
            else if((xmit_data == 1'b1) && (gmii_tx_en[0] == 1'b1)) begin
                next_state = START_OF_PACKET__START_ERROR_0;
            end
            
            // Priority 4
            // Else
            else begin
                next_state = XMIT_IDLE_DATA;
            end
        end
        
        CONFIGURATION_C1A_C1B:
        begin
            next_state = CONFIGURATION_C1C_C1D;
        end
        
        CONFIGURATION_C1C_C1D:
        begin
            // Priority 1
            // xmit != CONFIGURATION
            if(xmit_configuration == 1'b0) begin
                next_state = XMIT_IDLE_DATA;
            end
            
            // Priority 2
            // Else
            else begin
                next_state = CONFIGURATION_C2A_C2B;
            end
        end
        
        CONFIGURATION_C2A_C2B:
        begin
            next_state = CONFIGURATION_C2C_C2D;
        end
        
        CONFIGURATION_C2C_C2D:
        begin
            // Priority 1
            // xmit != CONFIGURATION
            if(xmit_configuration == 1'b0) begin
                next_state = XMIT_IDLE_DATA;
            end
            
            // Priority 2
            // Else
            else begin
                next_state = CONFIGURATION_C1A_C1B;
            end
        end
        
        START_OF_PACKET__START_ERROR_0:
        begin
            // Priority 1
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 0)
            if((gmii_tx_en[0] == 1'b0) &&
               (gmii_tx_err[0] == 1'b0)) begin
                next_state = END_OF_PACKET_NOEXT_TR;
            end
            
            // Priority 2
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 0)
            else if((gmii_tx_en[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = END_OF_PACKET_NOEXT_DT;
            end
            
            // Priority 3
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_err[1] == 0) 
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = END_OF_PACKET_EXT_TR;
            end            
            
            // Priority 4
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_err[1] == 1) 
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_err[1] == 1'b1)) begin
                next_state = END_OF_PACKET_EXT__CARRIER_EXT_TR;
            end
            
            // Priority 5
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 1) 
            else if((gmii_tx_en[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b1)) begin
                next_state = END_OF_PACKET_EXT__DT;
            end
            
            // Priority 6
            // Else
            // Equivalent to:
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 1)
            else begin
                next_state = TX_DATA;
            end
        end
        
        START_OF_PACKET__START_ERROR_1:
        begin
            // Priority 1
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 0)
            if((gmii_tx_en[0] == 1'b0) &&
               (gmii_tx_err[0] == 1'b0)) begin
                next_state = END_OF_PACKET_NOEXT_TR;
            end
            
            // Priority 2
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 0)
            else if((gmii_tx_en[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = END_OF_PACKET_NOEXT_DT;
            end
            
            // Priority 3
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_err[1] == 0) 
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = END_OF_PACKET_EXT_TR;
            end            
            
            // Priority 4
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_err[1] == 1) 
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_err[1] == 1'b1)) begin
                next_state = END_OF_PACKET_EXT__CARRIER_EXT_TR;
            end
            
            // Priority 5
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 1) 
            else if((gmii_tx_en[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b1)) begin
                next_state = END_OF_PACKET_EXT__DT;
            end
            
            // Priority 6
            // Else
            // Equivalent to:
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 1)
            else begin
                next_state = TX_DATA;
            end
        end
        
        TX_DATA:
        begin
            // Priority 1
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 0)
            if((gmii_tx_en[0] == 1'b0) &&
               (gmii_tx_err[0] == 1'b0)) begin
                next_state = END_OF_PACKET_NOEXT_TR;
            end
            
            // Priority 2
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 0)
            else if((gmii_tx_en[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = END_OF_PACKET_NOEXT_DT;
            end
            
            // Priority 3
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_err[1] == 0) 
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = END_OF_PACKET_EXT_TR;
            end            
            
            // Priority 4
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_err[1] == 1) 
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_err[1] == 1'b1)) begin
                next_state = END_OF_PACKET_EXT__CARRIER_EXT_TR;
            end
            
            // Priority 5
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 1) 
            else if((gmii_tx_en[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b1)) begin
                next_state = END_OF_PACKET_EXT__DT;
            end
            
            // Priority 6
            // Else
            // Equivalent to:
            // (gmii_tx_en[0] == 1) &&
            // (gmii_tx_en[1] == 1)
            else begin
                next_state = TX_DATA;
            end
        end
        
        END_OF_PACKET_NOEXT_TR:
        begin
            next_state = XMIT_IDLE_DATA;
        end
        
        END_OF_PACKET_NOEXT_DT:
        begin
            next_state = END_OF_PACKET_NOEXT_RR;
        end
        
        END_OF_PACKET_NOEXT_RR:
        begin
            next_state = XMIT_IDLE_DATA;
        end
        
        END_OF_PACKET_EXT_TR:
        begin
            next_state = END_OF_PACKET_NOEXT_RR;
        end
        
        END_OF_PACKET_EXT__CARRIER_EXT_TR:
        begin
            // Priority 1
            // gmii_tx_en[0] == 1
            if(gmii_tx_en[0] == 1'b1) begin
                next_state = START_OF_PACKET__START_ERROR_0;
            end
            
            // Priority 2
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 0)
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b0)) begin
                next_state = END_OF_PACKET_NOEXT_RR;
            end
            
            // Priority 3
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 0)
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = CARRIER_EXTEND__EXTEND_BY_1;
            end            
            
            // Priority 4
            // Else
            else begin
                next_state = CARRIER_EXTEND;
            end
        end
        
        END_OF_PACKET_EXT__DT:
        begin
            // Priority 1
            // gmii_tx_err[0] == 0
            if(gmii_tx_err[0] == 1'b0) begin
                next_state = END_OF_PACKET_NOEXT_RR;
            end
            
            // Priority 2
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 0)
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = CARRIER_EXTEND__EXTEND_BY_1;
            end  
            
            // Priority 3
            // Else
            else begin
                next_state = CARRIER_EXTEND;
            end
        end
        
        CARRIER_EXTEND:
        begin
            // Priority 1
            // gmii_tx_en_prev[1] == 1
            if(gmii_tx_en_p1[1] == 1'b1) begin
                next_state = START_OF_PACKET__START_ERROR_1;
            end
            
            // Priority 2
            // gmii_tx_en[0] == 1
            else if(gmii_tx_en[0] == 1'b1) begin
                next_state = START_OF_PACKET__START_ERROR_0;
            end
            
            // Priority 3
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 0)
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b0)) begin
                next_state = END_OF_PACKET_NOEXT_RR;
            end     
            
            // Priority 4
            // (gmii_tx_en[0] == 0) &&
            // (gmii_tx_err[0] == 1) &&
            // (gmii_tx_en[1] == 0) &&
            // (gmii_tx_err[1] == 0)
            else if((gmii_tx_en[0] == 1'b0) &&
                    (gmii_tx_err[0] == 1'b1) &&
                    (gmii_tx_en[1] == 1'b0) &&
                    (gmii_tx_err[1] == 1'b0)) begin
                next_state = CARRIER_EXTEND__EXTEND_BY_1;
            end             
            
            // Priority 5
            // Else
            else begin
                next_state = CARRIER_EXTEND;
            end
        end
        
        CARRIER_EXTEND__EXTEND_BY_1:
        begin
            next_state = END_OF_PACKET_NOEXT_RR;
        end
        
        default:
        begin
            next_state = XMIT_IDLE_DATA;
        end
    endcase
end

// -----------------------
// Transmit
// -----------------------
always @(posedge clk or posedge reset) begin
    if(reset) begin
        transmit <= 1'b0;
    end
    else begin
        if(sw_reset) begin
            transmit <= 1'b0;
        end
        else if((state == START_OF_PACKET__START_ERROR_0) ||
                (state == START_OF_PACKET__START_ERROR_1)
            ) begin
            transmit <= 1'b1;
        end
        else if((state == XMIT_IDLE_DATA) ||
                (state == END_OF_PACKET_NOEXT_TR) ||
                (state == END_OF_PACKET_NOEXT_DT) ||
                (state == END_OF_PACKET_NOEXT_RR) ||
                (state == END_OF_PACKET_EXT_TR) ||
                (state == END_OF_PACKET_EXT__CARRIER_EXT_TR) ||
                (state == CARRIER_EXTEND) ||
                (state == CARRIER_EXTEND__EXTEND_BY_1)
            ) begin
            transmit <= 1'b0;
        end
    end
end

// -----------------------
// Encapsulated Data
// -----------------------
always @(posedge clk or posedge reset) begin
    if(reset) begin
        kchar[0]    <= 1'b1;
        frame[7:0]  <= CONST_K28_5;
        kchar[1]    <= 1'b1;
        frame[15:8] <= CONST_K28_5;
    end
    else begin
        if(sw_reset) begin
            kchar[0]    <= 1'b1;
            frame[7:0]  <= CONST_K28_5;
            kchar[1]    <= 1'b1;
            frame[15:8] <= CONST_K28_5;
        end
        else begin
            case(state)
                XMIT_IDLE_DATA:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= CONST_K28_5;
                    kchar[1]    <= 1'b0;
                    frame[15:8] <= disparity ? CONST_D5_6 : CONST_D16_2;
                end
                
                CONFIGURATION_C1A_C1B:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= CONST_K28_5;
                    kchar[1]    <= 1'b0;
                    frame[15:8] <= CONST_D21_5;
                end
                
                CONFIGURATION_C1C_C1D:
                begin
                    kchar[0]    <= 1'b0;
                    frame[7:0]  <= an_ability_sync[7:0];
                    kchar[1]    <= 1'b0;
                    frame[15:8] <= an_ability_sync[15:8];
                end
                
                CONFIGURATION_C2A_C2B:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= CONST_K28_5;
                    kchar[1]    <= 1'b0;
                    frame[15:8] <= CONST_D2_2;
                end
                
                CONFIGURATION_C2C_C2D:
                begin
                    kchar[0]    <= 1'b0;
                    frame[7:0]  <= an_ability_sync[7:0];
                    kchar[1]    <= 1'b0;
                    frame[15:8] <= an_ability_sync[15:8];
                end
                
                START_OF_PACKET__START_ERROR_0:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= CONST_S;
                    kchar[1]    <= (gmii_tx_err_p1[0] || gmii_tx_err_p1[1]) ? 1'b1 : 1'b0;
                    frame[15:8] <= (gmii_tx_err_p1[0] || gmii_tx_err_p1[1]) ? CONST_V : gmii_tx_data_p1[15:8];
                end
                
                START_OF_PACKET__START_ERROR_1:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= CONST_S;
                    kchar[1]    <= (gmii_tx_err_p2[1] || gmii_tx_err_p1[0] || gmii_tx_err_p1[1]) ? 1'b1 : 1'b0;
                    frame[15:8] <= (gmii_tx_err_p2[1] || gmii_tx_err_p1[0] || gmii_tx_err_p1[1]) ? CONST_V : gmii_tx_data_p1[15:8];
                end
                
                TX_DATA:
                begin
                    kchar[0]    <= gmii_tx_err_p1[0] ? 1'b1 : 1'b0;
                    frame[7:0]  <= gmii_tx_err_p1[0] ? CONST_V : gmii_tx_data_p1[7:0];
                    kchar[1]    <= gmii_tx_err_p1[1] ? 1'b1 : 1'b0;
                    frame[15:8] <= gmii_tx_err_p1[1] ? CONST_V : gmii_tx_data_p1[15:8];
                end
                
                END_OF_PACKET_NOEXT_TR:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= CONST_T;
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= CONST_R;
                end
                
                END_OF_PACKET_NOEXT_DT:
                begin
                    kchar[0]    <= gmii_tx_err_p1[0] ? 1'b1 : 1'b0;
                    frame[7:0]  <= gmii_tx_err_p1[0] ? CONST_V : gmii_tx_data_p1[7:0];
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= CONST_T;
                end
                
                END_OF_PACKET_NOEXT_RR:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= CONST_R;
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= CONST_R;
                end
                
                END_OF_PACKET_EXT_TR:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= (gmii_tx_data_p1[7:0] == 8'h0F) ? CONST_T : CONST_V;
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= CONST_R;
                end
                
                END_OF_PACKET_EXT__CARRIER_EXT_TR:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= (gmii_tx_data_p1[7:0] == 8'h0F) ? CONST_T : CONST_V;
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= (gmii_tx_data_p1[15:8] == 8'h0F) ? CONST_R : CONST_V;
                end
                
                END_OF_PACKET_EXT__DT:
                begin
                    kchar[0]    <= gmii_tx_err_p1[0] ? 1'b1 : 1'b0;
                    frame[7:0]  <= gmii_tx_err_p1[0] ? CONST_V : gmii_tx_data_p1[7:0];
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= (gmii_tx_data_p1[15:8] == 8'h0F) ? CONST_T : CONST_V;
                end
                
                CARRIER_EXTEND:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= (gmii_tx_data_p1[7:0] == 8'h0F) ? CONST_R : CONST_V;
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= (gmii_tx_data_p1[15:8] == 8'h0F) ? CONST_R : CONST_V;
                end
                
                CARRIER_EXTEND__EXTEND_BY_1:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= (gmii_tx_data_p1[7:0] == 8'h0F) ? CONST_R : CONST_V;
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= CONST_R;
                end
                
                default:
                begin
                    kchar[0]    <= 1'b1;
                    frame[7:0]  <= CONST_K28_5;
                    kchar[1]    <= 1'b1;
                    frame[15:8] <= CONST_K28_5;
                end
                
            endcase
        end
    end
end

endmodule // module tx_encapsulation
