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


//-----------------------------------------------------------------------------------------------//
//   Generated with Magillem S.A. MRV generator.                                  
//   MRV generator version : 0.2
//   Protocol :  AVALON
//   Wait State : WS1_OUTPUT                                         
//   Date : Fri Nov 03 19:20:44 MYT 2023           
//-----------------------------------------------------------------------------------------------//


//-----------------------------------------------------------------------------------------------//
//   Verilog Register Bank
//   Component Name: intel_directphy_sip_csr
//   File Ref: /nfs/site/disks/swuser_work_edwinjos/R_23_4_1103_pg_B61/p4/ip/alt_xcvr/intel_monolithic/directphy/intel_directphy_gts/csr_gen/intel_directphy_sip_csr_out/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_intel_directphy_sip_csr_1.0.xml                                             
//   Magillem Version :   5.11.2.1                                                                         
//-----------------------------------------------------------------------------------------------//
// 
module intel_directphy_sip_csr (
// register offset : 0x00, field offset : 0, access : RO, gui_option.line_rate_p1ghz
input  [11:0] gui_option_line_rate_p1ghz_i,
// register offset : 0x00, field offset : 12, access : RO, gui_option.xcvr_type
input   gui_option_xcvr_type_i,
// register offset : 0x00, field offset : 13, access : RO, gui_option.modulation_type
input   gui_option_modulation_type_i,
// register offset : 0x00, field offset : 14, access : RO, gui_option.duplex_mode
input  [2:0] gui_option_duplex_mode_i,
// register offset : 0x00, field offset : 17, access : RO, gui_option.num_xcvr
input  [3:0] gui_option_num_xcvr_i,
// register offset : 0x00, field offset : 21, access : RO, gui_option.fec_enable
input   gui_option_fec_enable_i,
// register offset : 0x04, field offset : 0, access : RW, dhpy_scratch.scratch
// register offset : 0x08, field offset : 0, access : RW, dphy_reset.soft_tx_rst
output  reg dphy_reset_soft_tx_rst,
// register offset : 0x08, field offset : 1, access : RW, dphy_reset.soft_rx_rst
output  reg dphy_reset_soft_rx_rst,
// register offset : 0x08, field offset : 4, access : RW, dphy_reset.tx_rst_ovr
output  reg dphy_reset_tx_rst_ovr,
// register offset : 0x08, field offset : 5, access : RW, dphy_reset.rx_rst_ovr
output  reg dphy_reset_rx_rst_ovr,
// register offset : 0x0c, field offset : 0, access : RO, dphy_reset_status.tx_rst_ack_n
input   dphy_reset_status_tx_rst_ack_n_i,
// register offset : 0x0c, field offset : 1, access : RO, dphy_reset_status.rx_rst_ack_n
input   dphy_reset_status_rx_rst_ack_n_i,
// register offset : 0x0c, field offset : 4, access : RO, dphy_reset_status.tx_ready
input   dphy_reset_status_tx_ready_i,
// register offset : 0x0c, field offset : 5, access : RO, dphy_reset_status.rx_ready
input   dphy_reset_status_rx_ready_i,
// register offset : 0x10, field offset : 0, access : RO, phy_tx_pll_locked.tx_pll_locked
input  [15:0] phy_tx_pll_locked_tx_pll_locked_i,
// register offset : 0x14, field offset : 0, access : RO, phy_rx_cdr_locked.rx_cdr_locked
input  [15:0] phy_rx_cdr_locked_rx_cdr_locked_i,
// register offset : 0x14, field offset : 16, access : RO, phy_rx_cdr_locked.rx_cdr_locked2data
input  [15:0] phy_rx_cdr_locked_rx_cdr_locked2data_i,
// register offset : 0x18, field offset : 0, access : RW, src_ctrl.rx_ignore_locked2data
output  reg src_ctrl_rx_ignore_locked2data,
// register offset : 0x18, field offset : 8, access : RW, src_ctrl.tx_clear_alarm
output  reg[7:0] src_ctrl_tx_clear_alarm,
// register offset : 0x18, field offset : 16, access : RW, src_ctrl.rx_clear_alarm
output  reg[7:0] src_ctrl_rx_clear_alarm,
// register offset : 0x1c, field offset : 8, access : RO, src_alarms.tx_alarm
input  [7:0] src_alarms_tx_alarm_i,
// register offset : 0x1c, field offset : 16, access : RO, src_alarms.rx_alarm
input  [7:0] src_alarms_rx_alarm_i,
//Bus Interface
input clk,
input reset,
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output reg [31:0] readdata,
output reg readdatavalid,
input [4:0] address

);


wire reset_n = !reset;	
// Protocol management
// combinatorial read data signal declaration
reg [31:0] rdata_comb;

// synchronous process for the read
always @(posedge clk)  
   if (!reset_n) readdata[31:0] <= 32'h0; else readdata[31:0] <= rdata_comb[31:0];

// read data is always returned on the next cycle
always @( posedge clk)
   if (!reset_n) readdatavalid <= 1'b0; else readdatavalid <= read;
//
//  Protocol specific assignment to inside signals
//
wire  we = write;
wire  re = read;
wire [4:0] addr = address[4:0];
wire [31:0] din  = writedata [31:0];
// A write byte enable for each register
// register dhpy_scratch with  writeType: write
wire	[3:0]  we_dhpy_scratch		=	we  & (addr[4:0]  == 5'h04)	?	byteenable[3:0]	:	{4{1'b0}};
// register dphy_reset with  writeType: write
wire	  we_dphy_reset		=	we  & (addr[4:0]  == 5'h08)	?	byteenable[0]	:	1'b0;
// register src_ctrl with  writeType: write
wire	[2:0]  we_src_ctrl		=	we  & (addr[4:0]  == 5'h18)	?	byteenable[2:0]	:	{3{1'b0}};

// A read byte enable for each register

/* Definitions of REGISTER "gui_option" */

// gui_option_line_rate_p1ghz
// bitfield description: Line rate in 0.1GHz
// Line datarate in 0.1GHz per transceiver.
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_line_rate_p1ghz_i 
// outputPort:  "" 
// NO register generated




// gui_option_xcvr_type
// bitfield description: Xcvr type
// 0:FGT tranceiver
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_xcvr_type_i 
// outputPort:  "" 
// NO register generated




// gui_option_modulation_type
// bitfield description: Modulation type
// 0:NRZ
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_modulation_type_i 
// outputPort:  "" 
// NO register generated




// gui_option_duplex_mode
// bitfield description: Duplex mode
// 0:Not used, 1:RX simplex, 2:TX simplex, 3:TX/RX duplex, 4:Dual-Simplex
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_duplex_mode_i 
// outputPort:  "" 
// NO register generated




// gui_option_num_xcvr
// bitfield description: Number of transceivers
// Number of transceivers per system
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_num_xcvr_i 
// outputPort:  "" 
// NO register generated




// gui_option_fec_enable
// bitfield description: RSFEC Enabled?
// 0:RSFEC is disabled, 1:RSFEC is enabled
// customType:  RO
// hwAccess: WO 
// inputPort: gui_option_fec_enable_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dhpy_scratch" */

// dhpy_scratch_scratch
// customType:  RW
// hwAccess: NA 
// reset value : 0x00000000 

reg [31:0] dhpy_scratch_scratch; // 

always @( posedge clk)
   if (!reset_n)  begin
      dhpy_scratch_scratch <= 32'h00000000;
   end
   else begin
   if (we_dhpy_scratch[0]) begin 
      dhpy_scratch_scratch[7:0]   <=  din[7:0];  //
   end
   if (we_dhpy_scratch[1]) begin 
      dhpy_scratch_scratch[15:8]   <=  din[15:8];  //
   end
   if (we_dhpy_scratch[2]) begin 
      dhpy_scratch_scratch[23:16]   <=  din[23:16];  //
   end
   if (we_dhpy_scratch[3]) begin 
      dhpy_scratch_scratch[31:24]   <=  din[31:24];  //
   end
end
/* Definitions of REGISTER "dphy_reset" */

// dphy_reset_soft_tx_rst
// bitfield description: Soft TX Reset
// 1:Reset the TX datapath if tx_rst_ovr is also set
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dphy_reset_soft_tx_rst <= 1'h0;
   end
   else begin
   if (we_dphy_reset) begin 
      dphy_reset_soft_tx_rst   <=  din[0];  //
   end
end

// dphy_reset_soft_rx_rst
// bitfield description: Soft RX Reset
// 1:Reset the RX datapath if tx_rst_ovr is also set
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dphy_reset_soft_rx_rst <= 1'h0;
   end
   else begin
   if (we_dphy_reset) begin 
      dphy_reset_soft_rx_rst   <=  din[1];  //
   end
end

// dphy_reset_tx_rst_ovr
// bitfield description: TX Reset Override
// 0:Use TX Reset from user interface, 1:use Soft TX Reset
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dphy_reset_tx_rst_ovr <= 1'h0;
   end
   else begin
   if (we_dphy_reset) begin 
      dphy_reset_tx_rst_ovr   <=  din[4];  //
   end
end

// dphy_reset_rx_rst_ovr
// bitfield description: RX Reset Override
// 0:Use RX Reset from user interface, 1:use Soft RX Reset
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dphy_reset_rx_rst_ovr <= 1'h0;
   end
   else begin
   if (we_dphy_reset) begin 
      dphy_reset_rx_rst_ovr   <=  din[5];  //
   end
end
/* Definitions of REGISTER "dphy_reset_status" */

// dphy_reset_status_tx_rst_ack_n
// bitfield description: TX Reset acknowledge. Active low (either the hard tx reset or the soft_tx_rst )
// 1:acknowledge the reset completed.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_tx_rst_ack_n_i 
// outputPort:  "" 
// NO register generated




// dphy_reset_status_rx_rst_ack_n
// bitfield description: RX Reset acknowledge. Active high (either the hard rx reset or the soft_rx_rst )
// 1:acknowledge the reset completed.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_rx_rst_ack_n_i 
// outputPort:  "" 
// NO register generated




// dphy_reset_status_tx_ready
// bitfield description: tx_ready state
// Current state of TX side:
// [0]: Not ready to accept user data
// [1]: Ready to send user data, indicates tx pll locked and data path reset done
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_tx_ready_i 
// outputPort:  "" 
// NO register generated




// dphy_reset_status_rx_ready
// bitfield description: rx_ready state
// Current state of RX side:
// [0]: Not ready to recover line data to paralell interface
// [1]: Ready to deliver recovered line data to parallel interface, indicates rx CDR locked and data path reset done
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dphy_reset_status_rx_ready_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "phy_tx_pll_locked" */

// phy_tx_pll_locked_tx_pll_locked
// bitfield description: TX PLL Locked
// 1=TX PLL used by this lane physical lane is locked
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: phy_tx_pll_locked_tx_pll_locked_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "phy_rx_cdr_locked" */

// phy_rx_cdr_locked_rx_cdr_locked
// bitfield description: CDR PLL locked
// 1:Corresponding physical lane's CDR has locked to reference
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: phy_rx_cdr_locked_rx_cdr_locked_i 
// outputPort:  "" 
// NO register generated




// phy_rx_cdr_locked_rx_cdr_locked2data
// bitfield description: CDR PLL locked to data
// 1:Corresponding physical lane's CDR has locked to data
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: phy_rx_cdr_locked_rx_cdr_locked2data_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "src_ctrl" */

// src_ctrl_rx_ignore_locked2data
// bitfield description: Ignore RX CDR Locked2data status
// 1:ignore
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      src_ctrl_rx_ignore_locked2data <= 1'h0;
   end
   else begin
   if (we_src_ctrl[0]) begin 
      src_ctrl_rx_ignore_locked2data   <=  din[0];  //
   end
end

// src_ctrl_tx_clear_alarm
// bitfield description: Clear tx_clear_alarm
// 1:Clear Alarm
// customType:  RW
// hwAccess: RO 
// reset value : 0x00 


always @( posedge clk)
   if (!reset_n)  begin
      src_ctrl_tx_clear_alarm <= 8'h00;
   end
   else begin
   if (we_src_ctrl[1]) begin 
      src_ctrl_tx_clear_alarm[7:0]   <=  din[15:8];  //
   end
end

// src_ctrl_rx_clear_alarm
// bitfield description: Clear rx_clear_alarm
// 1:Clear Alarm
// customType:  RW
// hwAccess: RO 
// reset value : 0x00 


always @( posedge clk)
   if (!reset_n)  begin
      src_ctrl_rx_clear_alarm <= 8'h00;
   end
   else begin
   if (we_src_ctrl[2]) begin 
      src_ctrl_rx_clear_alarm[7:0]   <=  din[23:16];  //
   end
end
/* Definitions of REGISTER "src_alarms" */

// src_alarms_tx_alarm
// bitfield description: tx alarm status 
// 1:Corresponding physical lane's tx alarm status
// customType:  RO
// hwAccess: WO 
// reset value : 0x00 
// inputPort: src_alarms_tx_alarm_i 
// outputPort:  "" 
// NO register generated




// src_alarms_rx_alarm
// bitfield description: rx alarm status
// 1:Corresponding physical lane's rx alarm status
// customType:  RO
// hwAccess: WO 
// reset value : 0x00 
// inputPort: src_alarms_rx_alarm_i 
// outputPort:  "" 
// NO register generated





// read process
always @ (*)
begin
rdata_comb = 32'h00000000;
   if(re) begin
      case (addr)  
	5'h00 : begin
		rdata_comb [11:0]	= gui_option_line_rate_p1ghz_i [11:0] ;		// readType = read   writeType =illegal
		rdata_comb [12]	= gui_option_xcvr_type_i  ;		// readType = read   writeType =illegal
		rdata_comb [13]	= gui_option_modulation_type_i  ;		// readType = read   writeType =illegal
		rdata_comb [16:14]	= gui_option_duplex_mode_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [20:17]	= gui_option_num_xcvr_i [3:0] ;		// readType = read   writeType =illegal
		rdata_comb [21]	= gui_option_fec_enable_i  ;		// readType = read   writeType =illegal
	end
	5'h04 : begin
		rdata_comb [31:0]	= dhpy_scratch_scratch [31:0] ;		// readType = read   writeType =write
	end
	5'h08 : begin
		rdata_comb [0]	= dphy_reset_soft_tx_rst  ;		// readType = read   writeType =write
		rdata_comb [1]	= dphy_reset_soft_rx_rst  ;		// readType = read   writeType =write
		rdata_comb [4]	= dphy_reset_tx_rst_ovr  ;		// readType = read   writeType =write
		rdata_comb [5]	= dphy_reset_rx_rst_ovr  ;		// readType = read   writeType =write
	end
	5'h0c : begin
		rdata_comb [0]	= dphy_reset_status_tx_rst_ack_n_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dphy_reset_status_rx_rst_ack_n_i  ;		// readType = read   writeType =illegal
		rdata_comb [4]	= dphy_reset_status_tx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [5]	= dphy_reset_status_rx_ready_i  ;		// readType = read   writeType =illegal
	end
	5'h10 : begin
		rdata_comb [15:0]	= phy_tx_pll_locked_tx_pll_locked_i [15:0] ;		// readType = read   writeType =illegal
	end
	5'h14 : begin
		rdata_comb [15:0]	= phy_rx_cdr_locked_rx_cdr_locked_i [15:0] ;		// readType = read   writeType =illegal
		rdata_comb [31:16]	= phy_rx_cdr_locked_rx_cdr_locked2data_i [15:0] ;		// readType = read   writeType =illegal
	end
	5'h18 : begin
		rdata_comb [0]	= src_ctrl_rx_ignore_locked2data  ;		// readType = read   writeType =write
		rdata_comb [15:8]	= src_ctrl_tx_clear_alarm [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= src_ctrl_rx_clear_alarm [7:0] ;		// readType = read   writeType =write
	end
	5'h1c : begin
		rdata_comb [15:8]	= src_alarms_tx_alarm_i [7:0] ;		// readType = read   writeType =illegal
		rdata_comb [23:16]	= src_alarms_rx_alarm_i [7:0] ;		// readType = read   writeType =illegal
	end
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
