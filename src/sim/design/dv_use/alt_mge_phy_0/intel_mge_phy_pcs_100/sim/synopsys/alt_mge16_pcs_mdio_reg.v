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
// MDIO Registers
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_mdio_reg /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"D101,D103,D102\"" */ (

   reset_rx_clk,
   reset_clk,
   clk,
   rx_clk,
   reg_addr,
   reg_write,
   reg_read,
   reg_dout,
   reg_din,
   sw_reset,
   loopback_ena,
   powerdown,
   link_status,
   an_enable,
   an_restart,
   an_ability,
   link_timer,
   an_restart_rst,
   an_done,
   an_ack,
   page_receive,
   lp_ability_ena,
   lp_ability,
   led_panel_link,
   sgmii_speed,
   use_sgmii,
   use_sgmii_an,
   tx_disable,
	adapter_status,
   sgmii_duplex);


parameter PHY_IDENTIFIER     = 32'h 01010101; 
parameter DEV_VERSION        = 16'h 0001; 
parameter ENABLE_SGMII       = 1;                 //  Enable SGMII logic for synthesis
parameter SYNCHRONIZER_DEPTH = 3;                  //  Synchronizer depth

input   reset_rx_clk;           //  Asynchronous Reset - rx_clk Domain
input   reset_clk;              //  Asynchronous Reset - clk Domain
input   clk;                    //  MDIO 2.5MHz Clock
input   rx_clk;                 //  125MHz TBI Line Clock
input   [4:0] reg_addr;         //  Address Register
input   reg_write;              //  Write Register 		
input   reg_read;               //  Read Register 		
output  [15:0] reg_dout;        //  Data Bus OUT
input   [15:0] reg_din;         //  Data Bus IN
output  sw_reset;               //  PHY Reset
output  loopback_ena;           //  PHY Loopback Enable
output  powerdown;              //  Power Down
input   link_status;            //  Valid Link Indication
output  an_enable;              //  Enable Autonegotiation
output  an_restart;             //  Restart Autonegotiation        
output  [15:0] an_ability;      //  Autonegotiation Ability Register
output  [20:0] link_timer;      //  Link Timer Maximim Value
input   an_restart_rst;         //  Reset Re-Negotiate Command
input   an_done;                //  Autonegotiation Done
input   an_ack;                 //  Acknowledge Bit
input   page_receive;           //  Page Receive Indication
input   lp_ability_ena;         //  Link Partner Ability Enable
input   [15:0] lp_ability;      //  Link Partner Ability Enable
output  [1:0] sgmii_speed;      //  SGMII Speed
output  led_panel_link;        //   Panel Link Status ,  MGE SGMII, ed
output  use_sgmii;              //  Enable SGMII
output  use_sgmii_an;           //  Use sgmii autonegotiation 
output  sgmii_duplex;           //  SGMI Duplex Mode
output  tx_disable;           
input  [6:0]  adapter_status;


reg     [15:0] reg_dout; 
reg     sw_reset/* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"R105\"" */; 
reg     [3:0] sw_reset_reg;
reg     loopback_ena; 
reg     powerdown; 
reg     an_enable; 
reg     an_restart; 
wire    [15:0] an_ability; 
wire    [20:0] link_timer; 
reg     [15:0] mdio_control; 
reg     [15:0] mdio_status; 
reg     [15:0] dev_ability; 
reg     [15:0] partner_ability; 
reg     [15:0] scratch_reg; 
reg     [31:0] link_timer_reg; 
reg     [15:0] an_expansion; 
reg     [1:0] sgmii_speed;
reg     led_panel_link_reg;
reg     sgmii_duplex;
wire    led_panel_link;			// Panel Link
wire    sgmii_phy_mode;         // SGMII PHY Mode
wire    use_sgmii_an;
wire    an_done_reg2;           //  Autonegotiation Done
wire    an_ack_reg2;            //  Acknowledge Bit
reg     page_receive_l;         // latched page_receive
wire    page_rcv_l_reg2;
reg     page_rcv_l_reg3;
wire    page_rcv_rxck_reg2;
wire    link_status_reg2;
wire    an_restart_rst_reg2;
reg   [15:0] adapter_reg; 
//  Latch Low Control
//  -----------------

reg     link_rst; 
reg     reg_read_reg; 
wire    [15:0] mdio_control_wire; 
wire    [15:0] mdio_status_wire; 
wire    [15:0] dev_ability_wire; 
wire    [15:0] an_expansion_wire; 
reg     [5:0] if_mode;

//  SGMII switch
wire    use_sgmii;

// Partner ability clock domain crossing
wire    partner_ability_valid;
wire    [15:0] partner_ability_clock_crossed;
reg     [15:0] partner_ability_reg_clk;


// clock domain crossing

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_1(
			.clk(clk), // INPUT
			.reset_n(~reset_clk), //INPUT
			.din(an_done), //INPUT
			.dout(an_done_reg2));//OUTPUT

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_2(
			.clk(clk), // INPUT
			.reset_n(~reset_clk), //INPUT
			.din(an_ack), //INPUT
			.dout(an_ack_reg2));//OUTPUT

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_3(
			.clk(clk), // INPUT
			.reset_n(~reset_clk), //INPUT
			.din(link_status), //INPUT
			.dout(link_status_reg2));//OUTPUT

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_4(
			.clk(clk), // INPUT
			.reset_n(~reset_clk), //INPUT
			.din(an_restart_rst), //INPUT
			.dout(an_restart_rst_reg2));//OUTPUT


always @(posedge reset_clk or posedge clk)
   begin : process_23
   if (reset_clk == 1'b 1)
      begin
      reg_read_reg <= 1'b 0;   
      end
   else
      begin
      reg_read_reg <= reg_read;   
      end
   end

//  Control Register
//  ----------------

assign mdio_control_wire[5:0] = 6'b 000000; 
always @(mdio_control_wire[5:0])
   begin : process_1
   mdio_control[5:0] = mdio_control_wire[5:0];   
   end

assign mdio_control_wire[6] = 1'b 1; 
always @(mdio_control_wire[6])
   begin : process_2
   mdio_control[6] = mdio_control_wire[6];   
   end

assign mdio_control_wire[7] = 1'b 0; 
always @(mdio_control_wire[7])
   begin : process_3
   mdio_control[7] = mdio_control_wire[7];   
   end

assign mdio_control_wire[8] = 1'b 1; 
always @(mdio_control_wire[8])
   begin : process_4
   mdio_control[8] = mdio_control_wire[8];   
   end

assign mdio_control_wire[13] = 1'b 0; 
always @(mdio_control_wire[13])
   begin : process_5
   mdio_control[13] = mdio_control_wire[13];   
   end

always @(posedge reset_clk or posedge clk)
   begin : process_24
   if (reset_clk == 1'b 1)
      begin
      mdio_control[9]  <= 1'b 0;   
      mdio_control[10] <= 1'b 0;   
      mdio_control[11] <= 1'b 0;   
      mdio_control[12] <= 1'b 0; // Do no enable AN by default, as it break backward compatiblity, and not supported in 2.5G mode 
      mdio_control[14] <= 1'b 0;   
      mdio_control[15] <= 1'b 0;   
      end
   else
      begin

   //  Self Clearing Reset
   //  -------------------
   
      if (mdio_control[15] == 1'b 1)
         begin
         mdio_control[15] <= 1'b 0;   
         end
      else if (reg_addr == 5'b 00000 & reg_write == 1'b 1 )
         begin
         mdio_control[15] <= reg_din[15];   
         end

   //  Self Clearing Auto Negotiation Re-Start
   //  ---------------------------------------
   
      if (an_restart_rst_reg2 == 1'b 1)
         begin
         mdio_control[9] <= 1'b 0;   
         end
      else if (reg_addr == 5'b 00000 & reg_write == 1'b 1 )
         begin
         mdio_control[9] <= reg_din[9];
         end
      if (reg_addr == 5'b 00000 & reg_write == 1'b 1)
         begin
         // mdio_control[10] <= reg_din[10];
         // mdio_control[11] <= reg_din[11];
         mdio_control[10] <= 1'b0;   //do not like customer to write, as this is reserved in UG
         mdio_control[11] <= 1'b0;   
         mdio_control[12] <= reg_din[12];
         mdio_control[14] <= reg_din[14];
         end
      end
   end

always @(posedge reset_clk or posedge clk)
   begin : process_25
   if (reset_clk == 1'b 1)
      begin
      an_restart   <= 1'b 0;   
      powerdown    <= 1'b 0;   
      an_enable    <= 1'b 0;   
      loopback_ena <= 1'b 0;   
      sw_reset     <= 1'b 0;   
      sw_reset_reg <= 4'h 0;
      end
   else
      begin
      an_restart   <= mdio_control[9];   
      powerdown    <= mdio_control[11];   
      an_enable    <= mdio_control[12];   
      loopback_ena <= mdio_control[14];   
      sw_reset     <= mdio_control[15] | mdio_control[10] | (|sw_reset_reg); // Ensure sw_reset is asserted long enough to be captured by datapath clocks
      sw_reset_reg <= {sw_reset_reg[2:0], mdio_control[15]};
      end
   end

//  Status Register
//  ---------------

assign mdio_status_wire[0] = 1'b 1; 
always @(mdio_status_wire[0])
   begin : process_6
   mdio_status[0] = mdio_status_wire[0];   
   end

assign mdio_status_wire[1] = 1'b 0; 
always @(mdio_status_wire[1])
   begin : process_7
   mdio_status[1] = mdio_status_wire[1];   
   end

assign mdio_status_wire[3] = 1'b 1; 
always @(mdio_status_wire[3])
   begin : process_8
   mdio_status[3] = mdio_status_wire[3];   
   end

assign mdio_status_wire[4] = 1'b 0; 
always @(mdio_status_wire[4])
   begin : process_9
   mdio_status[4] = mdio_status_wire[4];   
   end

assign mdio_status_wire[6] = 1'b 0; 
always @(mdio_status_wire[6])
   begin : process_10
   mdio_status[6] = mdio_status_wire[6];   
   end

assign mdio_status_wire[7] = 1'b 0; 
always @(mdio_status_wire[7])
   begin : process_11
   mdio_status[7] = mdio_status_wire[7];   
   end

assign mdio_status_wire[8] = 1'b 0; 
always @(mdio_status_wire[8])
   begin : process_12
   mdio_status[8] = mdio_status_wire[8];   
   end

assign mdio_status_wire[15:9] = {7{1'b 0}}; 
always @(mdio_status_wire[15:9])
   begin : process_13
   mdio_status[15:9] = mdio_status_wire[15:9];   
   end

always @(posedge reset_clk or posedge clk)
   begin : process_26
   if (reset_clk == 1'b 1)
      begin
      link_rst <= 1'b 0;   
      end
   else
      begin
      if (reg_addr == 5'b 00001 & reg_read == 1'b 0 & 
      reg_read_reg == 1'b 1)
         begin
         link_rst <= 1'b 0;   
         end
      else if (link_status_reg2 == 1'b 1 & mdio_status[2] == 1'b 1 )
         begin
         link_rst <= 1'b 1;   
         end
      end
   end

always @(posedge reset_clk or posedge clk)
   begin : process_27
   if (reset_clk == 1'b 1)
      begin
      mdio_status[2] <= 1'b 0;   
      mdio_status[5] <= 1'b 0;   
      end
   else
      begin

   //  Latching Low Link Status
   //  ------------------------
   
      if (link_status_reg2 == 1'b 1 & link_rst == 1'b 0)
         begin
         mdio_status[2] <= 1'b 1;   
         end
      else if (link_status_reg2 == 1'b 0 & mdio_status[2] == 1'b 1 )
         begin
         mdio_status[2] <= 1'b 0;   
         end
      if (an_done_reg2 == 1'b 1 & mdio_control[12] == 1'b 1 & mdio_control[15]==1'b 0)
         begin
         mdio_status[5] <= 1'b 1;   
         end
      else
         begin
         mdio_status[5] <= 1'b 0;   
         end
      end
   end

//  ------------------------ //
//  Auto-Negotiation Control //
//  ------------------------ //

//  Device Ability
//  --------------

assign dev_ability_wire[4:0] = {5{1'b 0}}; 
always @(dev_ability_wire[4:0])
   begin : process_14
   dev_ability[4:0] = dev_ability_wire[4:0];   
   end


assign dev_ability_wire[9] = 1'b 0; 
always @(dev_ability_wire[9])
   begin : process_15
   dev_ability[9] = dev_ability_wire[9];   
   end

always @(posedge reset_clk or posedge clk)
   begin : process_28
   if (reset_clk == 1'b 1)
      begin
      dev_ability[8:5]   <= 4'b 1101; // default 1000 Base-X. Fullduplex only, full pause support
      dev_ability[13:12] <= 2'b 0;   
      dev_ability[14] <= 1'b 0; 
      dev_ability[15] <= 1'b 0;	  
	  dev_ability[11:10] <= 2'b 0; 
      end
   else
      begin

      if (reg_addr == 5'h 4 & reg_write == 1'b 1)
         begin
         dev_ability[8:5]   <= reg_din[8:5];   
         dev_ability[13:12] <= reg_din[13:12]; //bit 10,11,12 are copper speed and duplex for SGMII PHY mode.
         //dev_ability[15] <= reg_din[15];       //bit 15 is for SGMII PHY mode, copper link_status.
         end
        dev_ability[14] <= an_ack_reg2;   
         
      end
   end

//assign an_ability = (use_sgmii)? 16'b0000000000000001:dev_ability; // If if_mode[1] is not asserted, there's no need to latch the tx_config_reg as described in table 1 of SGMII spec.
assign an_ability = (use_sgmii & ~sgmii_phy_mode)? 16'b0000_0000_0000_0001: 
                    (use_sgmii & sgmii_phy_mode)? (dev_ability| 16'b0000_0000_0000_0001):
                    dev_ability;
// If if_mode[1] is not asserted, there's no need to latch the tx_config_reg as described in table 1 of SGMII spec.
// For SGMII PHY mode, tx_config_reg[0] must be always 1'b1.
//  Partner Next Page
//  -----------------

always @(posedge reset_rx_clk or posedge rx_clk)
   begin : process_30
   if (reset_rx_clk == 1'b 1)
      begin
      partner_ability <= {16{1'b 0}};   
      end
   else
      begin
          if (lp_ability_ena == 1'b 1)
             begin
             partner_ability <= lp_ability;   
             end         
      end
   end

//  Auto-Negotiation Expansion
//  --------------------------

// handshake page receive event with clk domain

always @(posedge reset_rx_clk or posedge rx_clk)
   begin : prcv_rxck
   if (reset_rx_clk == 1'b 1)
      begin
      page_receive_l    <= 1'b 0;   
      end
   else
      begin
      if (page_receive == 1'b 1)
        begin
        page_receive_l <= 1'b 1;
        end
      else if( page_rcv_rxck_reg2==1'b 1) 
        begin
        page_receive_l <= 1'b 0;
        end
      end
   end

// handshake with clk clock domain
alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_PAGE_RCV_RXCK(
			.clk(rx_clk), // INPUT
			.reset_n(~reset_rx_clk), //INPUT
			.din(page_rcv_l_reg2), //INPUT
			.dout(page_rcv_rxck_reg2));//OUTPUT

// bring page receive indication in clk domain
alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_PAGE_RCV(
			.clk(clk), // INPUT
			.reset_n(~reset_clk), //INPUT
			.din(page_receive_l), //INPUT
			.dout(page_rcv_l_reg2));//OUTPUT



assign an_expansion_wire[15:2] = {14{1'b 0}}; 
always @(an_expansion_wire[15:2])
   begin : process_19
   an_expansion[15:2] = an_expansion_wire[15:2];   
   end

always @(posedge reset_clk or posedge clk)
   begin : process_31
   if (reset_clk == 1'b 1)
      begin
      an_expansion[0] <= 1'b 0;   
      an_expansion[1] <= 1'b 0;   
      page_rcv_l_reg3 <= 1'b 0;
      end
   else
      begin
        
        // bit0: Remote is AN-able. We indicate as long as we receive pages (real-time)
        
        an_expansion[0] <= page_rcv_l_reg2;
        page_rcv_l_reg3 <= page_rcv_l_reg2;
        
        // bit1: latched high, if at least one page was received
        
      if((page_rcv_l_reg2==1'b 1) && (page_rcv_l_reg3 == 1'b 0))
         begin
        //  Latching High
        //  -------------
         an_expansion[1] <= 1'b 1;   
         end
      else if (reg_addr == 5'b 00110 & reg_read == 1'b 0 & reg_read_reg == 1'b 1)
         begin
         an_expansion[1] <= 1'b 0;   
         end
      end
   end

//  ------------------ //
//  Extended Registers //
//  ------------------ // 

//  Scratch Register
//  ----------------

always @(posedge reset_clk or posedge clk)
   begin : process_33
   if (reset_clk == 1'b 1)
      begin
      scratch_reg <= {16{1'b 0}};   
      end
   else
      begin
      if (reg_addr == 5'b 10000 & reg_write == 1'b 1)
         begin
         scratch_reg <= reg_din;   
         end
      end
   end
//  adapter Register
//  ----------------

always @(posedge reset_clk or posedge clk)
   begin
   if (reset_clk == 1'b 1)
      begin
      adapter_reg <= {{15{1'b 0}},1'b1};   
      end
   else
      begin
      if (reg_addr == 5'b 01011 & reg_write == 1'b 1)
         begin
         adapter_reg[0] <= reg_din[0];   
         end
      end
   end

assign tx_disable =  adapter_reg[0];
//  Link Timer Register
//  -------------------

always @(posedge reset_clk or posedge clk)
   begin : process_34
   if (reset_clk == 1'b 1)
      begin
      link_timer_reg[15:0]  <= 16'h8A00;
      link_timer_reg[31:16] <= 16'h9;
      end
   else
      begin
      if (reg_addr == 5'b 10010 & reg_write == 1'b 1)
         begin
         link_timer_reg[15:0] <= {reg_din[15:9], 9'h0};
         end
      if (reg_addr == 5'b 10011 & reg_write == 1'b 1)
         begin
         link_timer_reg[31:16] <= {11'h0, reg_din[4:0]};
         end
      end
   end

assign link_timer = link_timer_reg[20:0];


// Use SGMII Autonegotiation [added for IP 8.0]

assign use_sgmii_an = (ENABLE_SGMII) ? if_mode[1] : 1'b0;
assign use_sgmii = (ENABLE_SGMII) ? if_mode[0] : 1'b0;
assign sgmii_phy_mode = 1'b0;   // reserved register for SGMII PHY mode. Not supported at the moment

//  Interface Mode
//  --------------

   always @(posedge reset_clk or posedge clk)
   begin
   if (reset_clk == 1'b 1)
      begin
      if_mode <= 6'h0 ;
      end
   else
      begin
      if (reg_addr == 5'b 10100 & reg_write == 1'b 1)
         begin
         if_mode <= reg_din[3:0]; 
         end
      end
   end

   
  

// Auto-Negotiation Resolution
// ---------------------------

generate if (ENABLE_SGMII == 1)
    begin

    always @(posedge reset_clk or posedge clk)
       begin
       if (reset_clk == 1'b 1)
          begin
          sgmii_speed  <= 2'b10 ;
          sgmii_duplex <= 1'b0 ;
          end
       else
          begin
      
          // SGMII Disabled - 1000Base-X Mode Enabled
          // ----------------------------------------
      
          if (if_mode[0]==1'b0)
             begin
             sgmii_speed  <= 2'b10; 
             sgmii_duplex <= 1'b0;
             end
         
          // SGMII Enabled, Static Configuration
          // -----------------------------------
         
          else if (if_mode[0]==1'b1 & if_mode[1]==1'b0)
             begin
             sgmii_speed  <= if_mode[3:2];

                 if (if_mode[3:2]==2'b10)
                     begin         
                     sgmii_duplex <= 1'b0 ;                
                     end
                 else
                     begin
                     sgmii_duplex <= if_mode[4];                        
                     end
             end
         
          // SGMII Enabled, Dynamic Configuration
          // ------------------------------------  
         
          else if (an_done_reg2)
		  
		  begin
		  
		 if(if_mode[0]==1'b1 & if_mode[1]==1'b1 & partner_ability_reg_clk[15]==1'b 1  & ~sgmii_phy_mode)
             begin
                 // reload data only when there is a real link and AN has completed                
                 sgmii_speed  <= partner_ability_reg_clk[11:10];

                 if (partner_ability_reg_clk[11:10]==2'b10)
                     begin
                     sgmii_duplex <= 1'b0 ;
                     end
                 else
                     begin
                     sgmii_duplex <= !(partner_ability_reg_clk[12]); // copper status: 0=halfduplex   
                     end
             end // if (if_mode[0]==1'b1 & if_mode[1]==1'b1 & partner_ability[15]==1'b 1 & an_done_reg2==1'b 1)
			 
			 else if (if_mode[0]==1'b1 & if_mode[1]==1'b1 & dev_ability[15]==1'b 1 & sgmii_phy_mode)
			 begin 
			 
			  //reload data only when there is a real link and AN has completed                
                sgmii_speed  <= dev_ability[11:10];

                   if (dev_ability[11:10]==2'b10)
                   begin
                   sgmii_duplex <= 1'b0 ;
                   end
                  
                   else
                   begin
                   sgmii_duplex <= !(dev_ability[12]); // copper status: 0=halfduplex   
                   end
                end 
			 
			 
			 end //else if SGMII Enabled, Dynamic configuration
			 
		
			 
			 
			 
			 
		  end //end else
		  end //end always block
           
      // end //end always block
    end //end of generate if
else
    begin
    always @(posedge reset_clk or posedge clk)
       begin
       if (reset_clk == 1'b 1)
          begin
          sgmii_speed  <= 2'b10 ;
          sgmii_duplex <= 1'b0 ;
          end
       else
          begin
          sgmii_speed  <= 2'b10; 
          sgmii_duplex <= 1'b0;
          end
       end
    end
endgenerate

// ------------------------------------- //
// Partner ability clock domain crossing //
// ------------------------------------- //
alt_mge16_pcs_clock_crosser
#(.BITS_PER_SYMBOL(16))
i_partner_ability_clock_crosser(.in_clk(rx_clk),
                  .in_reset(reset_rx_clk),
                  .in_ready(),
                  .in_valid(1'b1),
                  .in_data(partner_ability),
                  .out_clk(clk),
                  .out_reset(reset_clk),
                  .out_ready(1'b1),
                  .out_valid(partner_ability_valid),
                  .out_data(partner_ability_clock_crossed));

always@(posedge reset_clk or posedge clk)
begin
   if (reset_clk==1'b1)
   begin
      partner_ability_reg_clk <= 16'b0;
   end
   else
   begin
      if (partner_ability_valid == 1'b1)
         partner_ability_reg_clk <= partner_ability_clock_crossed;
      else
         partner_ability_reg_clk <= partner_ability_reg_clk;
   end
end

 // add led_panel_link 
always@(posedge reset_clk or posedge clk)
begin
   if (reset_clk==1'b1)
      led_panel_link_reg <= 1'b0;
   else
   begin
      if (an_enable == 1'b0 & use_sgmii == 1'b0)
         led_panel_link_reg <= link_status_reg2;
      else if (an_enable == 1'b0 & use_sgmii == 1'b1 & use_sgmii_an == 1'b0)
         led_panel_link_reg <= link_status_reg2;
      else if (an_enable == 1'b1 & use_sgmii == 1'b0)
         led_panel_link_reg <= an_done_reg2;
      else if (an_enable == 1'b1 & use_sgmii == 1'b1 & use_sgmii_an == 1'b1 & sgmii_phy_mode == 1'b0)
         led_panel_link_reg <= an_done_reg2 & partner_ability_clock_crossed [15];
      else if (an_enable == 1'b1 & use_sgmii == 1'b1 & use_sgmii_an == 1'b1 & sgmii_phy_mode == 1'b1)
         led_panel_link_reg <= an_done_reg2 & dev_ability[15] ; 
      else
         led_panel_link_reg <= 1'b0;
   end
end

assign led_panel_link = led_panel_link_reg; 

//  Read MUX
//  --------

always@(posedge reset_clk or posedge clk)
begin

        if (reset_clk==1'b1)
        begin
        
                reg_dout <= 16'h0;
                
        end
        else if (reg_read==1'b1)
        begin

                case (reg_addr)
                5'b 00000:
                begin
                        reg_dout <= mdio_control;   
                end
                5'b 00001:
                begin
                        reg_dout <= mdio_status;   
                end
                5'b 00010:
                begin
                        reg_dout <= PHY_IDENTIFIER[15:0];   
                end
                5'b 00011:
                begin
                        reg_dout <= PHY_IDENTIFIER[31:16];   
                end
                5'b 00100:
                begin
                        reg_dout <= dev_ability;
                end
                5'b 00101:
                begin
                        reg_dout <= partner_ability_reg_clk;   
                end
                5'b 00110:
                begin
                        reg_dout <= an_expansion;   
                end
                5'b 00111:
                begin
                        reg_dout <= {16{1'b 0}};   
                end
                5'b 01000:
                begin
                        reg_dout <= {16{1'b 0}};   
                end
                5'b 01001:
                begin
                        reg_dout <= {16{1'b 0}};   
                end
                5'b 01010:
                begin
                        reg_dout <= {16{1'b 0}};   
                end
                5'b 01011:
                begin
                       // reg_dout <= {{15{1'b 0},adapter_reg[0]}};   
					     reg_dout <= adapter_reg;  
                end
                5'b 01100:
                begin
                       // reg_dout <= {16{1'b 0}};   
							   reg_dout <= adapter_status;   
                end
                5'b 01101:
                begin
                        reg_dout <= {16{1'b 0}};   
                end
                5'b 01110:
                begin
                        reg_dout <= {16{1'b 0}};   
                end
                5'b 01111:
                begin
                        reg_dout <= {16{1'b 0}};   
                end
                5'b 10000:
                begin
                        reg_dout <= scratch_reg;   
                end
                5'b 10001:
                begin
                        reg_dout <= DEV_VERSION;   
                end
                5'b 10010:
                begin
                        reg_dout <= link_timer_reg[15:0];   
                end
                5'b 10011:
                begin
                        reg_dout <= link_timer_reg[31:16];     
                end
                5'b 10100:
                begin
                        reg_dout <= if_mode;
                end
                default:
                begin
                        reg_dout <= {16{1'b 0}};   
                end
                endcase
        end
        else
        begin
        
                reg_dout <= 16'h0;
                
        end
        
end        

endmodule // module mdio_reg

