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
// 1000 Base-X Autonegotiation Top Level Entity
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_top_autoneg (

   reset,
   sw_reset,
   clk,
   an_enable,
   an_restart,
   rx_sync,
   rx_invalid,
   idle_ena,
   max_link_timer,
   an_restart_rst,
   lp_ability,
   lp_ability_ena,
   use_sgmii,
   use_sgmii_an,
   an_ability_in,
   an_ability_out,
   page_receive,   
   an_done,
   an_ack,
   an_txidle,
   an_txena);

input   reset;                  //  Active High Global Reset
input   sw_reset;               //  SW Asynchronous Reset           
input   clk;                    //  125MHz Clock
input   an_enable;              //  Enable Autonegotiation
input   an_restart;             //  Restart Autonegotiation
input   rx_invalid;             //  Invalid Signal
input   rx_sync;                //  Link Synchronization
input   idle_ena;               //  Idle Received        
input   [20:0] max_link_timer;  //  Link Timer Maximum Value (2 clocks)
output  an_restart_rst;         //  Reset Re-Negotiate Command
input   [15:0] lp_ability;      //  Link Partner Ability Register
input   lp_ability_ena;         //  Link Partner Ability Valid
input   use_sgmii;              //  Enable SGMII
input   use_sgmii_an;           //  SGMII Auto Negotiation Register bit
input   [15:0] an_ability_in;   //  Device Ability Register
output  [15:0] an_ability_out;  //  Controlled Device Ability Register
output  page_receive;           //  Page Receive
output  an_done;                //  Autonegotiation Done
output  an_ack;                 //  Acknowledge Indication
output  an_txidle;              //  Enable Idle Transmit                       
output  an_txena;               //  Enable Data Transmit                        

wire    an_restart_rst; 
wire    hd_logic_en;
reg     [15:0] an_ability_out /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"D102\"" */;
reg     page_receive;
reg     an_done; 
reg     an_ack; 
reg     an_txidle; 
reg     an_txena; 

parameter STM_TYP_AUTONEG_ENA     = 3'h0;
parameter STM_TYP_AUTONEG_RESTART = 3'h1;
parameter STM_TYP_ABILITY_DETECT  = 3'h2;
parameter STM_TYP_ACK_DETECT      = 3'h3;
parameter STM_TYP_COMPLETE_ACK    = 3'h4;
parameter STM_TYP_IDLE_DETECT     = 3'h5;
parameter STM_TYP_LINK_OK         = 3'h6;
parameter STM_TYP_NO_AN_LINK      = 3'h7;
parameter SYNCHRONIZER_DEPTH 	  = 3;		    //  Number of synchronizer
parameter ENABLE_SGMII       = 1;                 //  Enable SGMII logic for synthesis   

reg     [2:0] state; 
reg     [2:0] nextstate; 

reg     [20:0] link_timer;      //  Link Timer 0 to 16ms
reg     link_timer_dec;         //  Link Timer Expiration Decoding
reg     an_restart_rst_i;       //  Reset Autonegotiation Restart Command

//  Ability / Acknowledge Detect
//  ----------------------------

reg     [1:0] rx_abiliy_cnt;    //  Link Partner Ability Count
reg     [1:0] rx_ack_cnt;       //  Link Partner Acknowledge Count
reg     [15:0] rx_ability_reg;  //  Latched Link Partner Ability
reg     [15:0] rx_ability_match_reg; //  Ability Match Value 

//  Ability Register Decoding
//  -------------------------

reg     ability_match;          //  Ability Match
reg     ability_zero;           //  Partnet Ability is 0x"0000"      
reg     ack_match;              //  Acknowledge Match   
reg     consist_match;          //  Consistancy Match

//  Idle Detect
//  -----------

reg     [1:0] idle_cnt;         //  Idle Count
reg     idle_match;             //  Idle Match

//  Link Status Control
//  -------------------

reg     an_sync_status;         //  Link Status
reg     [20:0] an_sync_cnt;     //  Link Sync Timeout

//  Asynchronous Signals Synchronization
//  ------------------------------------

wire     an_restart_reg2; 
wire     an_enable_reg2;
reg     an_enable_reg3;
wire     sw_reset_reg2; 

// False path that is safe for clock domain crossing
// as the register setting should be stable before it is used
// in valid use cases.
wire     use_sgmii_reg;
wire     use_sgmii_an_reg;
//  Synchronization Registers
//  -------------------------

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_1(
			.clk(clk), // INPUT
			.reset_n(~reset), //INPUT
			.din(an_enable), //INPUT
			.dout(an_enable_reg2));// OUTPUT

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_2(
			.clk(clk), // INPUT
			.reset_n(~reset), //INPUT
			.din(an_restart), //INPUT
			.dout(an_restart_reg2));// OUTPUT

assign sw_reset_reg2 = sw_reset;

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_USE_SGMII(
   .clk (clk),
   .reset_n (~reset),
   .din (use_sgmii),
   .dout (use_sgmii_reg)
);

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_USE_SGMII_AN(
   .clk (clk),
   .reset_n (~reset),
   .din (use_sgmii_an),
   .dout (use_sgmii_an_reg)
);

always @(posedge reset or posedge clk)
   begin : process_1
   if (reset == 1'b 1)
      begin
      an_enable_reg3  <= 1'b 0; 
      end
   else
      begin
      an_enable_reg3  <= an_enable_reg2;  
      end
   end



always @(posedge reset or posedge clk)
   begin : process_2
   if (reset == 1'b 1)
      begin
      state <= STM_TYP_AUTONEG_ENA;   
      end
   else
      begin
      if (an_sync_status == 1'b 0 | an_restart_rst_i == 1'b 1 | 
          sw_reset_reg2 == 1'b 1 | 
          (rx_invalid == 1'b 1 & (state != STM_TYP_IDLE_DETECT & state != STM_TYP_LINK_OK & state != STM_TYP_NO_AN_LINK )) |
          (an_enable_reg2^an_enable_reg3))
         begin
         state <= STM_TYP_AUTONEG_ENA;   
         end
      else
         begin
         state <= nextstate;   
         end
      end
   end

always @(state or link_timer_dec or ability_match or ability_zero or ack_match
         or consist_match or idle_match or an_enable_reg2)
   begin : process_3
   case (state)
   STM_TYP_AUTONEG_ENA:
      begin

   //  Autonegotiation Disabled
   //  ------------------------
   
      if (an_enable_reg2 == 1'b 0)
         begin
         nextstate = STM_TYP_NO_AN_LINK;   
         end
      else
         begin
         nextstate = STM_TYP_AUTONEG_RESTART;   
         end
      end
   STM_TYP_AUTONEG_RESTART:
      begin
      if (link_timer_dec == 1'b 1)
         begin
         nextstate = STM_TYP_ABILITY_DETECT;   
         end
      else
         begin
         nextstate = STM_TYP_AUTONEG_RESTART;   
         end
      end
   STM_TYP_ABILITY_DETECT:
      begin
      if (ability_match == 1'b 1 & ability_zero == 1'b 0)
         begin
         nextstate = STM_TYP_ACK_DETECT;   
         end
      else
         begin
         nextstate = STM_TYP_ABILITY_DETECT;   
         end
      end
   STM_TYP_ACK_DETECT:
      begin
      if (consist_match == 1'b 1 & ack_match == 1'b 1)
         begin
         nextstate = STM_TYP_COMPLETE_ACK;   
         end
      else if (ability_match == 1'b 1 & ability_zero == 1'b 1 )
         begin
         nextstate = STM_TYP_AUTONEG_ENA;   
         end
      else if (ack_match == 1'b 1 & consist_match == 1'b 0 )
         begin
         nextstate = STM_TYP_AUTONEG_ENA;   
         end
      else
         begin
         nextstate = STM_TYP_ACK_DETECT;   
         end
      end
   STM_TYP_COMPLETE_ACK:
      begin
      if (link_timer_dec == 1'b 1 & (ability_match == 1'b 0 | 
      ability_zero == 1'b 0))
         begin
         nextstate = STM_TYP_IDLE_DETECT;   
         end
      else if (ability_match == 1'b 1 & ability_zero == 1'b 1 )
         begin
         nextstate = STM_TYP_AUTONEG_ENA;   
         end
      else
         begin
         nextstate = STM_TYP_COMPLETE_ACK;   
         end
      end
   STM_TYP_IDLE_DETECT:
      begin
      if (idle_match == 1'b 1 & link_timer_dec == 1'b 1)
         begin
         nextstate = STM_TYP_LINK_OK;   
         end
      else if (ability_match == 1'b 1 & ability_zero == 1'b 1 )
         begin
         nextstate = STM_TYP_AUTONEG_ENA;   
         end
      else
         begin
         nextstate = STM_TYP_IDLE_DETECT;   
         end
      end
   STM_TYP_LINK_OK:
      begin
      if (ability_match == 1'b 1)
         begin
         nextstate = STM_TYP_AUTONEG_ENA;   
         end
      else
         begin
         nextstate = STM_TYP_LINK_OK;   
         end
      end
   STM_TYP_NO_AN_LINK:
      begin
      if (an_enable_reg2 == 1'b 1)
         begin
         nextstate = STM_TYP_AUTONEG_ENA;   
         end
      else
         begin
         nextstate = STM_TYP_NO_AN_LINK;   
         end
      end
   default:
      begin
      nextstate = STM_TYP_AUTONEG_ENA;
      end
   endcase
   end

//  Ability Latch and Decoding
//  --------------------------

always @(posedge reset or posedge clk)
   begin : process_4
   if (reset == 1'b 1)
      begin
      rx_ability_reg   <= {16{1'b 0}};   
      ability_zero     <= 1'b 0;   
      rx_ability_match_reg     <= {16{1'b 0}};   
      end
   else
      begin
      if (sw_reset_reg2==1'b1)
         begin
         rx_ability_reg <= {16{1'b 0}};   
         ability_zero   <= 1'b 0;   
         rx_ability_match_reg   <= {16{1'b 0}};
         end
      else
         begin
         if (state == STM_TYP_AUTONEG_ENA)
            begin
            rx_ability_reg   <= {16{1'b 0}};   
            ability_zero     <= 1'b 0;   
            rx_ability_match_reg     <= {16{1'b 0}};   

   //  Reset Ability Available Handshake with Rx Clock Domain
   //  ------------------------------------------------------
   
            end
         else
            begin
         
   // ------------- //
   // Reset Ability //
   // ------------- //
         
            if (idle_ena == 1'b1)
               begin
               rx_ability_reg   <= {16{1'b 0}};
               end

   //  ---------------------------------------------------------------------- //
   //  Ability is Latched when Three Concecutive Matching Values are Received //
   //  Used for Consitency Check                                              //
   //  ---------------------------------------------------------------------- //
   
            else if (lp_ability_ena == 1'b1)
               begin
               rx_ability_reg <= lp_ability;   
               end

   //  Latch Match Value for Consistancy Check
   //  ---------------------------------------
   
            // Use rx_abiliy_cnt and rx_ack_cnt instead of ability_match and ack_match,
            // to ensure we are latching the same value that cause ability_match and ack_match to assert
            if ((rx_abiliy_cnt == 2'h2) & state == STM_TYP_ABILITY_DETECT)
               begin
               rx_ability_match_reg <= rx_ability_reg;
               end
            
   //  Link Partner Ability Set to 0x0000 Detection
   //  --------------------------------------------
   
            if (rx_ability_reg == 16'h 0000)
               begin
               ability_zero <= 1'b 1;   
               end
            else
               begin
               ability_zero <= 1'b 0;   
               end
            end
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_5
   if (reset == 1'b 1)
      begin
      rx_abiliy_cnt <= 2'h0;   
      rx_ack_cnt    <= 2'h0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         rx_abiliy_cnt <= 2'h0;   
         rx_ack_cnt    <= 2'h0;   
         end
      else
         begin
         if (lp_ability_ena == 1'b1)
            begin
            
            //  Check for three Consecutive Matching Values
            //  -------------------------------------------
            
            if (
                ((state == STM_TYP_AUTONEG_RESTART) && (nextstate == STM_TYP_ABILITY_DETECT)) ||
                ((state == STM_TYP_ACK_DETECT) && (nextstate == STM_TYP_COMPLETE_ACK))
               )
               begin
               rx_abiliy_cnt <= 2'h0;
               end
            else if (lp_ability[15] == rx_ability_reg[15] & lp_ability[13:0] == rx_ability_reg[13:0])
               begin
               if (rx_abiliy_cnt != 2'h2)
                  begin               
                  rx_abiliy_cnt <= rx_abiliy_cnt + 2'h 1;   
                  end
               end
            else
               begin
               rx_abiliy_cnt <= 2'h0;   
               end
            end
         else if (idle_ena == 1'b 1 )
            begin
            
            //  Idle Received (/I/ Characters)
            //  ------------------------------
            
            rx_abiliy_cnt <= 2'h0;   
            end
         
         
         if (lp_ability_ena == 1'b1)
            begin
            
            //  Check for three Consecutive Matching Values
            //  -------------------------------------------
            
            if (
                ((state == STM_TYP_ABILITY_DETECT) && (nextstate == STM_TYP_ACK_DETECT))
               )
               begin
                  rx_ack_cnt <= 2'h0;
               end
            else if (lp_ability == rx_ability_reg & rx_ability_reg[14] == 1'b 1)
               begin
               if (rx_ack_cnt != 2'h2)
                  begin
                  rx_ack_cnt <= rx_ack_cnt + 2'h 1;
                  end
               end
            else
               begin
               rx_ack_cnt <= 2'h0;   
               end
            end
         else if (idle_ena == 1'b 1 )
            begin
            
            //  Idle Received (/I/ Characters)
            //  ------------------------------
            
            rx_ack_cnt <= 2'h0;   
            end
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_6
   if (reset == 1'b 1)
      begin
      ability_match <= 1'b 0;   
      ack_match     <= 1'b 0;   
      consist_match <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         ability_match <= 1'b 0;   
         ack_match     <= 1'b 0;   
         consist_match <= 1'b 0;   

   //  Ability Match
   //  -------------
   
         end
      else
         begin
         if (rx_abiliy_cnt == 2'h2 & state==nextstate)
            begin         
            ability_match <= 1'b 1;   
            end
         else
            begin
            ability_match <= 1'b 0;   
            end

   //  Acknowledge Match
   //  -----------------
         
         if (rx_ack_cnt == 2'h2 & rx_abiliy_cnt == 2'h2 & state==nextstate)
            begin
            ack_match <= 1'b 1;   
            end
         else
            begin
            ack_match <= 1'b 0;   
            end
         
   //  Consistancy Match
   //  -----------------
   
         if (rx_ability_match_reg[15] == rx_ability_reg[15] & rx_ability_match_reg[13:0] == rx_ability_reg[13:0])
            begin
            consist_match <= 1'b 1;   
            end
         else
            begin
            consist_match <= 1'b 0;   
            end
         end
      end
   end

//  Link Timer
//  ----------

always @(posedge reset or posedge clk)
   begin : process_7
   if (reset == 1'b 1)
      begin
      link_timer <= {21{1'b 0}};   
      end
   else
      begin
      if (sw_reset_reg2==1'b1)
         begin
         link_timer <= {21{1'b 0}};
         end
      else
         begin
         if (state == STM_TYP_AUTONEG_ENA | state == STM_TYP_ACK_DETECT | 
             (state == STM_TYP_COMPLETE_ACK & nextstate == STM_TYP_IDLE_DETECT))
            begin
            link_timer <= {21{1'b 0}};
            end
         else if (nextstate == STM_TYP_AUTONEG_RESTART | 
                  nextstate == STM_TYP_IDLE_DETECT | nextstate == STM_TYP_COMPLETE_ACK )
            begin
            if (link_timer_dec == 1'b 0)
               begin
               link_timer <= link_timer + 21'h 1;
               end
            end
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_8
   if (reset == 1'b 1)
      begin
      link_timer_dec <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2==1'b1)
         begin
         link_timer_dec <= 1'b 0;
         end
      else
         begin
         if (state == STM_TYP_AUTONEG_ENA | state == STM_TYP_ACK_DETECT |
             (state==STM_TYP_COMPLETE_ACK & nextstate==STM_TYP_IDLE_DETECT))
            begin
            link_timer_dec <= 1'b 0;   
            end
         else
            begin
            // Reduce lsb in comparator so that link_timer_dec could be asserted a cycle earlier,
            // and used to stop counting of link_timer, to save resource by not using 21-bit comparator
            if (link_timer[20:1] == max_link_timer[20:1])
               begin
               link_timer_dec <= 1'b 1;
               end
            else
               begin
               link_timer_dec <= 1'b 0;   
               end
            end
         end
      end
   end

//  Device Advertissement Register
//  ------------------------------

always @(posedge reset or posedge clk)
   begin : process_9
   if (reset == 1'b 1)
      begin
      an_ability_out <= {16{1'b 0}};   
      end
   else
      begin
      if (sw_reset_reg2==1'b1)
         begin
         an_ability_out <= {16{1'b 0}};
         end
      else
         begin
         if (state == STM_TYP_AUTONEG_ENA)
            begin
            an_ability_out <= {16{1'b 0}};   
            end
         else if (nextstate == STM_TYP_ABILITY_DETECT )
            begin
            an_ability_out[15]   <= an_ability_in[15];   
            an_ability_out[14]   <= 1'b 0;   
            an_ability_out[13:0] <= an_ability_in[13:0];   
            end
         else if (nextstate == STM_TYP_ACK_DETECT )
            begin
            an_ability_out[15]   <= an_ability_in[15];   
            an_ability_out[14]   <= 1'b 1;   //  Acknowledge
            an_ability_out[13:0] <= an_ability_in[13:0];   
            end
         end
      end
   end

//  Transmit Control
//  ----------------

always @(posedge reset or posedge clk)
   begin : process_10
   if (reset == 1'b 1)
      begin
      an_txena  <= 1'b 0;   
      an_txidle <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         an_txena  <= 1'b 0;   
         an_txidle <= 1'b 0;   
         end
      else
         begin
         if (state == STM_TYP_LINK_OK | state == STM_TYP_NO_AN_LINK)
            begin
            an_txena <= 1'b 1;   
            end
         else
            begin
            an_txena <= 1'b 0;   
            end
         if (state == STM_TYP_LINK_OK | state == STM_TYP_IDLE_DETECT)
            begin
            an_txidle <= 1'b 1;   
            end
         else
            begin
            an_txidle <= 1'b 0;   
            end
         end
      end
   end

//  Idle Detection
//  --------------

always @(posedge reset or posedge clk)
   begin : process_11
   if (reset == 1'b 1)
      begin
      idle_cnt <= 2'h0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         idle_cnt <= 2'h0;   

   //  Three Idle /I/ Sequence Count - 0xBC / Data / 0xBC / ...
   //  --------------------------------------------------------
   
         end
      else
         begin
         if (idle_ena == 1'b 1 & idle_cnt != 2'h3)
            begin
            idle_cnt <= idle_cnt + 2'h 1;   
            end
         else if (idle_ena == 1'b 0 )
            begin
            idle_cnt <= 2'h0;   
            end
         else if (lp_ability_ena == 1'b1)
            begin
            idle_cnt <= 2'h0;   
            end
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_12
   if (reset == 1'b 1)
      begin
      idle_match <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         idle_match <= 1'b 0;   
         end
      else
         begin
         if (idle_cnt == 2'h3 & state==nextstate)
            begin
            idle_match <= 1'b 1;   
            end
         else
            begin
            idle_match <= 1'b 0;   
            end
         end
      end
   end

//  Acknowledge Indication
//  ----------------------

always @(posedge reset or posedge clk)
   begin : process_13
   if (reset == 1'b 1)
      begin
      an_ack <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         an_ack <= 1'b 0;   
         end
      else
         begin
         if (nextstate == STM_TYP_ACK_DETECT)
            begin
            an_ack <= 1'b 1;   
            end
         else if (nextstate == STM_TYP_AUTONEG_RESTART )
            begin
            an_ack <= 1'b 0;   
            end
         end
      end
   end

//  Autonegotiation Done
//  --------------------

always @(posedge reset or posedge clk)
   begin : process_14
   if (reset == 1'b 1)
      begin
      an_done <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         an_done <= 1'b 0;   
         end
      else
         begin
         if (nextstate == STM_TYP_LINK_OK)
            begin
            an_done <= 1'b 1;   
            end
         else
            begin
            an_done <= 1'b 0;   
            end
         end
      end
   end

//  Reset Re-Negotiation Command Bit
//  --------------------------------

always @(posedge reset or posedge clk)
   begin : process_15
   if (reset == 1'b 1)
      begin
      an_restart_rst_i <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         an_restart_rst_i <= 1'b 0;   
         end
      else
         begin
         if (an_restart_reg2 == 1'b 1)
            begin
            an_restart_rst_i <= 1'b 1;   
            end
         else if (an_restart_reg2 == 1'b 0 )
            begin
            an_restart_rst_i <= 1'b 0;   
            end
         end
      end
   end

assign an_restart_rst = an_restart_rst_i; 

//  Link Status Detecttion
//  ---------------------- 

always @(posedge reset or posedge clk)
   begin : process_16
   if (reset == 1'b 1)
      begin
      an_sync_cnt <= {21{1'b 0}};   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         an_sync_cnt <= {21{1'b 0}};
         end
      else
         begin
         if (rx_sync == 1'b 1)
            begin

   //  Link Acquired
   //  -------------
   
            an_sync_cnt <= {21{1'b 0}};
            
   //  Link Lost
   //  ---------
   
            end
         else
            begin
            if (an_sync_status == 1'b 1)
               begin
               an_sync_cnt <= an_sync_cnt + 21'h 1;   
               end
            end
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_17
   if (reset == 1'b 1)
      begin
      an_sync_status <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         an_sync_status <= 1'b 0;   
         end
      else
         begin
         if (rx_sync == 1'b 1)
            begin
            an_sync_status <= 1'b 1;   
            end
         else if (an_sync_cnt[20:1] == max_link_timer[20:1])
            begin
            an_sync_status <= 1'b 0;   
            end
         end
      end
   end


//  Page Reception Indication
//  -------------------------

always @(posedge reset or posedge clk)
   begin : process_18
   if (reset == 1'b 1)
      begin
      page_receive <= 1'b 0;   
      end
   else
      begin
      if (sw_reset_reg2 == 1'b 1)
         begin
         page_receive <= 1'b 0;   
         end
      else
         begin
         if (nextstate == STM_TYP_COMPLETE_ACK)
            begin
            page_receive <= 1'b 1;   
            end
         else if ((nextstate == STM_TYP_AUTONEG_ENA) || (nextstate == STM_TYP_ABILITY_DETECT ) || (nextstate == STM_TYP_AUTONEG_RESTART ))
            begin
            page_receive <= 1'b 0;   
            end
         end
      end
   end

endmodule // module top_autoneg
