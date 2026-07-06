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
// Statistic and Configuration Registers.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_control (   

   rx_clk,
   reset_rx_clk,
   reset_reg_clk,
   reg_clk,
   rd,
   wr,
   sel,
   data_in,
   data_out,
   busy,
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
   use_sgmii,         
   sgmii_speed,
   use_sgmii_an,
	tx_disable ,
	adapter_status ,
   sgmii_duplex);


parameter PHY_IDENTIFIER     = 32'h 01010101; 
parameter DEV_VERSION        = 16'h 0001; 
parameter ENABLE_SGMII       = 0;                 //  Enable SGMII logic for synthesis
parameter SYNCHRONIZER_DEPTH = 3;                 //  Synchronizer depth

input   rx_clk;                 //  125MHz Clock 
input   reset_rx_clk;           //  Asynchronous Reset - rx_clk Domain
input   reset_reg_clk;          //  Asynchronous Reset - reg_clk Domain	
input   reg_clk;                //  Host Interface Clock
input   rd;                     //  Register Read Strobe
input   wr;                     //  Register Write Strobe
input   [4:0] sel;              //  Register Address
input   [15:0] data_in;         //  Write Data for Host Bus
output  [15:0] data_out;        //  Read Data to Host Bus
output  busy;                   //  Interface Busy
output  [1:0] sgmii_speed;      //  SGMII Speed
output  use_sgmii_an;           //  Use autonegotiation
output  sgmii_duplex;           //  SGMI Duplex Mode
output  led_panel_link;         //  Panel Link Status
output  loopback_ena;           //  PHY Loopback Enable
output  powerdown;              //  Power Down
output  an_enable;              //  Enable Autonegotiation
output  an_restart;             //  Restart Autonegotiation
output  [15:0] an_ability;      //  Autonegotiation Ability Register        
output  [20:0] link_timer;      //  Link Timer Maximim Value
output  sw_reset;               //  PHY Reset
input   link_status;            //  Valid Link Indication
input   an_restart_rst;         //  Reset Re-Negotiate Command
input   an_done;                //  Autonegotiation Done
input   an_ack;                 //  Acknowledge Bit
input   page_receive;           //  Page Receive Indication
input   lp_ability_ena;         //  Link Partner Ability Enable
input   [15:0] lp_ability;      //  Link Partner Ability Enable
output  use_sgmii;              //  Enable SGMII
output  tx_disable;
input  [6:0]  adapter_status;


wire  loopback_ena;
wire  powerdown;              
wire  an_enable;           
wire  led_panel_link;   
wire  an_restart;             
wire  [15:0] an_ability;           
wire  [20:0] link_timer; 
wire  sw_reset;
wire  [1:0] sgmii_speed;
wire  sgmii_duplex;
wire  use_sgmii_an;
     
wire    reg_rd;                 //  Register Read Strobe 
wire    reg_wr;                 //  Register Write Strobe
wire    [4:0] reg_sel;          //  Register Address     
wire    [15:0] reg_data_in;     //  Write Data for Host B
wire    [15:0] reg_data_out;    //  Read Data to Host Bus

wire    vcc ;
assign  vcc = 1'b1;
   
alt_mge16_pcs_mdio_reg U_REG (

        .reset_rx_clk(reset_rx_clk),
        .reset_clk(reset_reg_clk),
        .clk(reg_clk),
        .rx_clk(rx_clk),
        .reg_addr(reg_sel),
        .reg_write(reg_wr),
        .reg_read(reg_rd),
        .reg_dout(reg_data_in),
        .reg_din(reg_data_out),
        .sw_reset(sw_reset),
        .loopback_ena(loopback_ena),
        .powerdown(powerdown),
        .link_status(link_status),
        .an_enable(an_enable),
        .an_restart(an_restart),
        .an_ability(an_ability),
        .link_timer(link_timer),
        .an_restart_rst(an_restart_rst),
        .an_done(an_done),
        .an_ack(an_ack),
        .page_receive(page_receive),
        .lp_ability_ena(lp_ability_ena),
        .lp_ability(lp_ability),
        .sgmii_speed(sgmii_speed),
		.use_sgmii (use_sgmii),
		.led_panel_link(led_panel_link),
        .use_sgmii_an(use_sgmii_an),
		  .tx_disable(tx_disable),
		  .adapter_status (adapter_status),

        .sgmii_duplex(sgmii_duplex));

defparam
    U_REG.PHY_IDENTIFIER = PHY_IDENTIFIER,
    U_REG.DEV_VERSION = DEV_VERSION,
    U_REG.ENABLE_SGMII = ENABLE_SGMII,
    U_REG.SYNCHRONIZER_DEPTH = SYNCHRONIZER_DEPTH;

alt_mge16_pcs_host_control U_CTRL (

        .reset(reset_reg_clk),
        .clk(reg_clk),
        .cs(vcc),
        .rd(rd),
        .wr(wr),
        .sel(sel),
        .data_in(data_in),
        .data_out(data_out),
        .busy(busy),
        .reg_rd(reg_rd),
        .reg_wr(reg_wr),
        .reg_sel(reg_sel),
        .reg_data_in(reg_data_in),
        .reg_data_out(reg_data_out));

endmodule // module pcs_control
