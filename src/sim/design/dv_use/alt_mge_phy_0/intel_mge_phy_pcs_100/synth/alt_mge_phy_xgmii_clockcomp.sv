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

module alt_mge_phy_xgmii_clockcomp
   #(
      parameter PCSDWIDTH      = 'd64,      // PCS data width
      parameter PCSCWIDTH      = 'd9,       // PCS control width
                                          // The total FIFO datawdith is (PCSDWIDTH+PCSCWIDTH)
      parameter FAWIDTH        = 'd5,       // FIFO Depth (address width) 
      parameter ISWIDTH        = 'd7,      // Gearbox Selector width
      parameter TSWIDTH        = 'd16,
      parameter IDWIDTH        = 'd40,      // PCS/PMA IF width
      parameter OFFSET         = 16'h29D6,   // PCS latency
	  parameter DEVICE_FAMILY  = "Arria 10"
    )
    (
      input  wire                 wr_rst_n,        // Write Domain Active low Reset
      input  wire                 rd_rst_n,        // Read Domain Active low Reset
      input  wire                 wr_clk,          // Write Domain Clock
      input  wire                 rd_clk,          // Read Domain Clock
//    input  wire [2:0]           r_gb_idwidth,    // Gearbox Input Width
//    input  wire [1:0]           r_gb_odwidth,    // Gearbox Output Width
//    input  wire                 r_bypass_cc,     // Bypass clock compensation
      input  wire [2:0]           r_fifo_mode,     // FIFO Mode: Phase-comp, BaseR RM, Interlaken, Register Mode
      input  wire [4:0]           r_pempty,        // FIFO partially empty threshold
      input  wire [4:0]           r_pfull,         // FIFO partially full threshold
      input  wire [4:0]           r_empty,         // FIFO empty threshold
      input  wire [4:0]           r_full,          // FIFO full threshold
      input  wire                 r_indv,          // Individual Mode
      input  wire                 r_truebac2bac,   // Back-2-back insertion/deletion
//    input  wire                 r_generic_ctrl,  // Select source that controls rd_en in FIFO generic mode. 0: Interlaken Frame Generator, 1: data valid generator
      input  wire [2:0]           r_phcomp_rd_delay,  // Programmable read and write pointer gap in phase comp bonding mode

      input  wire [PCSCWIDTH-1:0] control_in,      // Frame information 
      input  wire [PCSDWIDTH-1:0] data_in,         // Write Data In (Contains CTRL+DATA)
      input  wire                 data_valid_in,   // Write Data In Valid 
      input  wire                 rd_en,           // Read Enable in generic mode 

      input  wire                 comp_dv_en,      // CP Bonding Data Valid Enable
      input  wire                 comp_wren_en,    // CP Bonding Write Enable
      input  wire                 comp_rden_en,    // CP Bonding Read Enable
      input  wire                 comp_intlkn_rden_en,    // Interlaken Read Enable from Agg Bonding

      input  wire [6:0]           gb_idwidth,      // Gearbox Input Width
      input  wire [6:0]           gb_odwidth,      // Gearbox Output Width

      output reg [PCSCWIDTH-1:0]  control_out,     // Frame information 
      output reg [PCSDWIDTH-1:0]  data_out,        // Read Data Out (Contains CTRL+DATA)
      output reg                  data_valid_out,  // Read Data Out Valid 
      output wire                 data_valid_raw,  // Raw Data Valid for Frame-Gen 
      output wire                 wr_empty,        // Write empty
      output wire                 wr_pempty,       // Write partial empty
      output wire                 wr_pfull,        // Write partial full 
      output wire                 wr_full,         // Write overflow error
      output wire                 rd_empty,        // Read empty
      output wire                 rd_pempty,       // Read partial empty
      output wire                 rd_pfull,        // Read partial full 
      output wire                 phcomp_wren,     // Wr Enable to CP Bonding
      output wire                 phcomp_rden,     // Rd Enable to CP Bonding
      output wire                 intlkn_rden,     // Interlaken Rd Enable to Agg Bonding
      output wire                 dv_en,           // Data Valid Enable to CP Bonding
      output wire [TSWIDTH-1:0]   latency_adj,     // Latency Measurement (6-bit cycle, 10-bit frac. cycle)
	  input   wire                latency_sclk,
	  input   wire                latency_sclk_reset,
	  input   wire [11:0]         latency_xcvr_tx,
	
      output reg                  fifo_del,        // 10G BaseR Deletion Flag
      output reg                  fifo_insert,     // 10G BaseR Insertion Flag
      output wire[19:0]           testbus1,        // Test Bus 1
      output wire[19:0]           testbus2         // Test Bus 2

    );


//********************************************************************
// Define Parameters 
//********************************************************************
//import alt_mge_phy_xgmii_params::*;
///////////////////////////////////////////////////////////////////////////////
// Start of import
///////////////////////////////////////////////////////////////////////////////
// 10G, 40G & 100G  Ethernet Parameters
   // Spec Definitions
      // MII Control Characters - Unencoded
      localparam               XGMII_IDLE  = 8'h07;
      localparam               XGMII_START = 8'hfb;
      localparam               XGMII_TERM  = 8'hfd;
      localparam               XGMII_ERROR = 8'hfe;
      localparam               XGMII_SEQOS = 8'h9c;
      localparam               XGMII_RES0  = 8'h1c;
      localparam               XGMII_RES1  = 8'h3c;
      localparam               XGMII_RES2  = 8'h7c;
      localparam               XGMII_RES3  = 8'hbc;
      localparam               XGMII_RES4  = 8'hdc;
      localparam               XGMII_RES5  = 8'hf7;
      localparam               XGMII_SIGOS = 8'h5c;
      // MII Control Characters - Encoded
      localparam               PCS_IDLE    = 7'h00;
      localparam               PCS_ERROR   = 7'h1e;
      localparam               PCS_SEQOS   = 4'h0;
      localparam               PCS_RES0    = 7'h2d;
      localparam               PCS_RES1    = 7'h33;
      localparam               PCS_RES2    = 7'h4b;
      localparam               PCS_RES3    = 7'h55;
      localparam               PCS_RES4    = 7'h66;
      localparam               PCS_RES5    = 7'h78;
      localparam               PCS_SIGOS   = 4'hf;
      // 64B66B Block Types
      localparam               SYNC_DBLK   = 2'b10;
      localparam               SYNC_CBLK   = 2'b01;
      localparam               BLK_TYPE1   = 8'h1e; 
      localparam               BLK_TYPE2   = 8'h2d; 
      localparam               BLK_TYPE3   = 8'h33; 
      localparam               BLK_TYPE4   = 8'h66; 
      localparam               BLK_TYPE5   = 8'h55; 
      localparam               BLK_TYPE6   = 8'h78; 
      localparam               BLK_TYPE7   = 8'h4b; 
      localparam               BLK_TYPE8   = 8'h87; 
      localparam               BLK_TYPE9   = 8'h99; 
      localparam               BLK_TYPE10  = 8'haa; 
      localparam               BLK_TYPE11  = 8'hb4; 
      localparam               BLK_TYPE12  = 8'hcc; 
      localparam               BLK_TYPE13  = 8'hd2; 
      localparam               BLK_TYPE14  = 8'he1; 
      localparam               BLK_TYPE15  = 8'hff;
      // Local Fault OS and Error Block - Encoded
      localparam               LBLOCK_T_10G        = {8'h1,8'h0,8'h0,PCS_SEQOS,PCS_SEQOS,8'h1,8'h0,8'h0,BLK_TYPE5,SYNC_CBLK};
      localparam               LBLOCK_T_40G100G    = {8'h0,8'h0,8'h0,8'h0,8'h1,8'h0,8'h0,BLK_TYPE5,SYNC_CBLK};
      localparam               EBLOCK_T            = {{8{PCS_ERROR}},BLK_TYPE1,SYNC_CBLK};
      // Local Fault OS and Error Block - Unencoded 
      localparam               EBLOCK_R            = {8{XGMII_ERROR}};
      localparam               LBLOCK_R_10G        = {8'h1,8'h0,8'h0,XGMII_SEQOS,8'h1,8'h0,8'h0,XGMII_SEQOS};
      localparam               LBLOCK_R_40G100G    = {8'h0,8'h0,8'h0,8'h0,8'h1,8'h0,8'h0,XGMII_SEQOS};
   // Implementation specific parameters
      // TX Control Type Encoding  
      localparam               T_TYPE_S    = 3'd0;
      localparam               T_TYPE_T    = 3'd1;
      localparam               T_TYPE_D    = 3'd2;
      localparam               T_TYPE_E    = 3'd3;
      localparam               T_TYPE_C    = 3'd4;
      // RX Block Type Encoding
      localparam               R_TYPE_S    = 3'd0;
      localparam               R_TYPE_T    = 3'd1;
      localparam               R_TYPE_D    = 3'd2;
      localparam               R_TYPE_E    = 3'd3;
      localparam               R_TYPE_C    = 3'd4;
      // TX SM States
      localparam               TX_INIT     = 3'd0;
      localparam               TX_C        = 3'd1;
      localparam               TX_D        = 3'd2;
      localparam               TX_T        = 3'd3;
      localparam               TX_E        = 3'd4;
      // RX SM States
      localparam               RX_INIT          = 3'd0;
      localparam               RX_C             = 3'd1;
      localparam               RX_D             = 3'd2;
      localparam               RX_T             = 3'd3;
      localparam               RX_WAIT_FOR_NXT  = 3'd4;
      localparam               RX_E             = 3'd5;
      // Ethernet Control Bits 
      localparam               CTL_MII0         = 'd0;
      localparam               CTL_MII1         = 'd1;
      localparam               CTL_MII2         = 'd2;
      localparam               CTL_MII3         = 'd3;
      localparam               CTL_MII4         = 'd4;
      localparam               CTL_MII5         = 'd5;
      localparam               CTL_MII6         = 'd6;
      localparam               CTL_MII7         = 'd7;


// Interlaken Parameters
   // Spec Definitions
      // Block Type
      localparam               SYNC_DWRD = 2'b01;
      localparam               SYNC_CWRD = 2'b10;
      localparam               FCTRL = 1'b0;
      localparam               PCTRL = 1'b1;
      localparam               BT_SYNC = 5'b11110;
      localparam               BT_SCRM = 5'b01010;
      localparam               BT_SKIP = 5'b00111;
      localparam               BT_DIAG = 5'b11001;

   // Implementation specific parameters
      // Framing Control Bits 
      localparam               CTL_INVB         = 'd2;
      localparam               CTL_PYLD         = 'd3;
      localparam               CTL_SYNC         = 'd4;
      localparam               CTL_SCRM         = 'd5;
      localparam               CTL_SKIP         = 'd6;
      localparam               CTL_DIAG         = 'd7;


// Shared Parameters
   // Control Bits 
      localparam               CTL_DATA         = 'd0;
      localparam               CTL_CTRL         = 'd1;
      localparam               CTL_ERR          = 'd8;
      localparam               CTL_BFL          = 'd9;
///////////////////////////////////////////////////////////////////////////////
// End of import
///////////////////////////////////////////////////////////////////////////////
localparam WR_IDLE         = 3'd0; 
localparam WR_ADD_NXT_DAT  = 3'd1; 
localparam WR_ADD_STOR_DAT = 3'd2; 
localparam WR_ADD_NULL_DAT = 3'd3; 
localparam WR_ADD_NO_DEL   = 3'd4;

localparam RD_IDLE         =2'd0;
localparam RD_ENABLE       =2'd1;
localparam RD_INSERT       =2'd2;

//localparam  IDWIDTH_5 = 5*IDWIDTH;
//localparam  IDWIDTH_4 = 4*IDWIDTH;
//localparam  IDWIDTH_3 = 3*IDWIDTH;
//localparam  IDWIDTH_2 = 2*IDWIDTH;
//localparam  CC_TX = 1;

localparam XGMII_IDLE_WORD = {4{XGMII_IDLE}};


localparam   FIFO_DATA_DEFAULT = {8{XGMII_IDLE}};
localparam   FIFO_CTRL_DEFAULT = 9'h0FF;
localparam   FIFO_DEFAULT = {FIFO_CTRL_DEFAULT, FIFO_DATA_DEFAULT};  

localparam FDWIDTH = PCSDWIDTH+PCSCWIDTH;

//********************************************************************
// Define variables 
//********************************************************************
// Regs
reg [FDWIDTH-1:0]  nx1_data_in;
reg [FDWIDTH-1:0]  nx0_data_in;
reg [FDWIDTH-1:0]  cur_data_in;
reg [FDWIDTH-1:0]  pre_data_in;
reg                nx1_data_valid_in;
reg                nx0_data_valid_in;
reg                cur_data_valid_in;
reg                nx1_lsoctet_os;
reg                nx1_lsoctet_idle;
reg                nx1_lsoctet_term;
reg                nx1_msoctet_os; 
reg                nx1_msoctet_idle;
reg                nx1_msoctet_term;
reg                nx0_lsoctet_os;
reg                nx0_lsoctet_idle;
reg                nx0_lsoctet_term;
reg                nx0_msoctet_os; 
reg                nx0_msoctet_idle;
reg                nx0_msoctet_term;
reg                cur_lsoctet_os;
reg                cur_lsoctet_idle;
reg                cur_lsoctet_term;
reg                cur_msoctet_os;
reg                cur_msoctet_idle;
reg                cur_msoctet_term;
reg                pre_lsoctet_os;
reg                pre_lsoctet_idle;
reg                pre_lsoctet_term; 
reg                pre_msoctet_os;
reg                pre_msoctet_idle;
reg                pre_msoctet_term;
reg                cur_msoctet_del;
reg                cur_lsoctet_del;
reg                nx0_msoctet_del;
reg                nx0_lsoctet_del;
reg                wr_en;
//reg                rd_en;
//reg                gen_idle;
reg [FDWIDTH-1:0]    wr_data;
//reg                rd_halffull;
reg [2:0]          wr_del_sm;
reg [31:0]         store_lsd;
reg [3:0]          store_lsc;
reg                  store_err;

reg [1:0]          rd_add_sm;
reg [31:0]         sel_cnt_r;
wire [ISWIDTH-1:0] sel_cnt;
reg [2:0]          gap_cnt;
reg                rd_val;
reg                rd_val_d0;
reg                rd_val_d1;
//reg                rd_val_d2;

// Wires
wire [ISWIDTH:0]   m_selcnt;
//wire [FDWIDTH-1:0]   rd_data_out;
wire [FAWIDTH-1:0] rd_numdata;
wire [FAWIDTH-1:0] wr_numdata;
//wire               rd_dout_term_seq_idle;
wire [31:0]        cur_data_in_lsd;
wire [31:0]        cur_data_in_msd;
wire [3:0]         cur_data_in_lsc;
wire [3:0]         cur_data_in_msc;
wire [31:0]        nx0_data_in_lsd;
wire [31:0]        nx0_data_in_msd;
wire [3:0]         nx0_data_in_lsc;
wire [3:0]         nx0_data_in_msc;
//wire               wr_pfull;
//wire               rd_pempty;

wire [FDWIDTH-1:0]  fifo_out;
wire [FDWIDTH-2:0]  fifo_out_w;

wire [FDWIDTH-1:0]  fifo_out_next;
wire [FDWIDTH-2:0]  fifo_out_next_w;

reg [FDWIDTH-1:0]  d_out;
//reg [FDWIDTH-1:0]  d_out_next;


//reg  [FDWIDTH-1:0]     data_out_int;
//reg  [FDWIDTH-1:0]     ctrl_out_int;

wire            rd_lw_idle;
wire            rd_uw_idle;

wire            rd_lw_os;
wire            rd_uw_os;
//reg            rd_uw_os_reg;

//wire            rd_lw_os_insert;
//wire            rd_uw_os_insert;

wire [1:0]        ch_insert; 
reg  [1:0]        ch_insert_reg;

//wire             rd_empty;

wire                  wr_en_int;
wire [FDWIDTH-1:0]    wr_data_in_int;

reg            first_read;

reg              insert_after;
reg              insert_between;
//reg [FDWIDTH-1:0]    fifo_out_next_reg;

reg            rd_en_10g;
wire [FDWIDTH-1:0]    wr_data_in;


//wire [6:0] gb_odwidth;
//wire [6:0] gb_idwidth;

wire            rd_en_int;
//wire            fifo_full;
//wire            wr_full;
wire            rd_full;

reg  [PCSDWIDTH-1:0]     data_in_d0;
reg  [PCSCWIDTH-1:0]     control_in_d0;

//reg            phcomp_rden_d0;
//reg            phcomp_rden_d1;

// To be removed
//assign phcomp_wren = 1'b0;
//assign phcomp_rden = 1'b0;


// FIFO mode decode
// FIFO mode decode
wire intl_generic_mode = (r_fifo_mode == 3'b001);
wire basic_generic_mode = (r_fifo_mode == 3'b101);
wire register_mode = (r_fifo_mode[1:0] == 2'b11);
wire phcomp_mode = (r_fifo_mode[1:0] == 2'b00);
wire clkcomp_mode = (r_fifo_mode[1:0] == 2'b10);

wire generic_mode = intl_generic_mode || basic_generic_mode;


wire             phcomp_rden_int;
wire             comp_rden_en_int;
//wire            phcomp_rden_sync;

wire [FDWIDTH-1:0]       wr_data_in_reg;
wire                wr_en_in_reg;

reg            start_write;

reg            keep_insert;
reg [1:0]              rd_add_sm_reg;

reg [3:0]        insert_cnt;

wire            rd_en_generic;
wire            gap_cnt_en;

reg            phcomp_wren_d0;
reg            phcomp_wren_d1;
reg            phcomp_wren_d2;
reg            phcomp_wren_d3;
reg            phcomp_wren_d4;
reg            phcomp_wren_reg;

wire             comp_dv_en_sync;
wire            phcomp_wren_sync;

reg              dv_en_d0;
reg              dv_en_d1;
reg              dv_en_d2;
reg              dv_en_d3;
reg              dv_en_d4;

//********************************************************************
// Instantiate the Async FIFO 
// (parameter FDWIDTH,parameter FAWIDTH,parameter FIFO_ALMFULL,parameter FIFO_ALMEMPTY)
//********************************************************************
alt_mge_phy_async_fifo_fpga
#(
.DWIDTH        (FDWIDTH-1),      // FIFO Input data width 
.AWIDTH        (FAWIDTH),        // FIFO Depth (address width) 
.SYNCSTAGE     (5),              // Metastable hardening stages
.RESET_LF      (0),              // Output Local Fault 
.FIFO_DEFAULT  (FIFO_DEFAULT)    // FIFO DEFAULT VALUE
)
async_fifo
(
.wr_rst_n      (wr_rst_n),    // Write Domain Active low Reset
.wr_srst_n     (1'b1),       // Write Domain Active low Reset Synchronous
.wr_clk       (wr_clk),     // Write Domain Clock
.wr_en        (wr_en_int),      // Write Data Enable
.wr_data      (wr_data_in_int[71:0]), // Write Data In
.rd_rst_n      (rd_rst_n),    // Read Domain Active low Reset
.rd_srst_n     (1'b1),       // Read Domain Active low Reset Synchronous
.rd_clk       (rd_clk),     // Read Domain Clock
.rd_en        (rd_en_int),      // Read Data Enable
.rd_data      (fifo_out_w),   // Read Data Out 
.rd_data_next (fifo_out_next_w),// Read Data Out 
.rd_numdata   (rd_numdata), // Number of Data available in Read clock
.wr_numdata   (wr_numdata), // Number of Data available in Write clock 
.r_pempty    (r_pempty),         // FIFO partially empty threshold   
.r_pfull    (r_pfull),         // FIFO partially full threshold   
.r_empty    (r_empty),         // FIFO empty threshold   
.r_full            (r_full),         // FIFO full threshold   
.wr_empty (wr_empty),              // FIFO Empty
.wr_pempty (wr_pempty),            // FIFO Partial Empty
.wr_full (wr_full),                // FIFO Full
.wr_pfull (wr_pfull),              // FIFO Parial Full
.rd_empty (rd_empty),              // FIFO Empty
.rd_pempty (rd_pempty),            // FIFO Partial Empty
.rd_full (rd_full),                // FIFO Full 
.rd_pfull (rd_pfull)               // FIFO Partial Full 
);

// assign     wr_oflw_err = data_valid_in & wr_full;
assign fifo_out = {1'b0,fifo_out_w};
assign fifo_out_next = {1'b0,fifo_out_next_w};

alt_mge_phy_xgmii_1588_latency
  #(
    .TX_RX         (0),                      // 0: TX FIFO (without ppm correction)
    .OFFSET        (OFFSET),                 // TX PCS Offset
    .NUMDATA_WIDTH (5),                      // the greater number out of FAWIDTH in TX & RX
    .IDWIDTH       (IDWIDTH),                // RX only - ppm correction (Gearbox Input Data Width)
	.DEVICE_FAMILY (DEVICE_FAMILY)
    )
   alt_mge_phy_xgmii_1588_latency
     (
      .sample_clk(rd_clk),
      .sample_rst_n(rd_rst_n),
      .clk(wr_clk),
      .rst_n(wr_rst_n),
      .numdata(rd_numdata),
      .octet_del_num(4'b0000),                  // RX only - rate match latency adjustment
      .wr_del_sm(2'b00),                        // RX only - rate match latency adjustment
      .octet_ins_num(4'b0000),                  // RX only - rate match latency adjustment
      .octet_del_en(1'b0),                      // RX only - rate match latency adjustment
      .octet_ins_en(1'b0),                      // RX only - rate match latency adjustment
      .sample_clk_data_valid(data_valid_out),   // RX only - ppm correction (pma_clk data_valid)
      .clk_block_lock(1'b0),                    // RX only - ppm correction (mac_clk block_lock/rx_data_ready)
	  .latency_sclk(latency_sclk),
	  .latency_sclk_reset(latency_sclk_reset),
	  .latency_xcvr(latency_xcvr_tx),
      .latency_adj(latency_adj)
      );

//********************************************************************
// Data is stored as follows 
// TIME   DATA   Comments
// t+1    nxt    Next
// t 0    cur    CURRENT  <-------
// t-1    pre    previous
// decode the OS, IDLE TERM on each OCTET(4 Bytes)
//********************************************************************
//assign wr_data_in_int = CC_TX ? data_in : wr_data_in; 
//assign wr_en_int = CC_TX ? data_valid_in : wr_en; 

// Register Data for generic mode
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      data_in_d0         <= 'd0;
      control_in_d0     <= 'd0;
   end
   else begin
      data_in_d0         <= data_in;
      control_in_d0     <= control_in;
   end
end

assign wr_data_in_reg = {control_in_d0, data_in_d0};  
assign wr_en_in_reg   = nx1_data_valid_in;

assign wr_data_in     = {control_in, data_in};  

assign rd_en_generic      = basic_generic_mode ? rd_val : r_indv ? rd_en : rd_en & comp_intlkn_rden_en;

// Data & Write/Read selection for different modes
assign wr_data_in_int = (generic_mode || phcomp_mode) ? wr_data_in_reg : 
                        wr_data;
assign wr_en_int = (phcomp_mode && r_indv) ? phcomp_wren:    // Phase Comp Indiviual mode
                   (phcomp_mode && ~r_indv) ? comp_wren_en:    // Phase Comp Bonding mode
                   generic_mode ? wr_en_in_reg :        // Interlaken
                   wr_en;                    // BaseR Clock Comp
//assign rd_en_int = (phcomp_mode && r_indv) ? phcomp_rden:    // Phase Comp Indiviual mode
assign rd_en_int = (phcomp_mode && r_indv) ? phcomp_rden_int:    // Phase Comp Indiviual mode
                   (phcomp_mode && ~r_indv) ? comp_rden_en_int:    // Phase Comp Bonding mode
                   generic_mode ? rd_en_generic :        // Generic mode
                   rd_en_10g;                    // BaseR Clock Comp


always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      nx1_data_valid_in  <= 'd0; 
      nx0_data_valid_in  <= 'd0; 
      cur_data_valid_in  <= 'd0; 
   end
   else begin
      nx1_data_valid_in  <= data_valid_in;
      nx0_data_valid_in  <= nx1_data_valid_in;
      cur_data_valid_in  <= nx0_data_valid_in;
   end
end

always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      nx1_data_in      <= 'd0; 
      nx0_data_in      <= 'd0; 
      cur_data_in      <= 'd0; 
      pre_data_in      <= 'd0; 

      nx1_lsoctet_os   <= 'd0; 
      nx1_lsoctet_idle <= 'd0; 
      nx1_lsoctet_term <= 'd0; 
      nx1_msoctet_os   <= 'd0; 
      nx1_msoctet_idle <= 'd0; 
      nx1_msoctet_term <= 'd0; 

      nx0_lsoctet_os   <= 'd0; 
      nx0_lsoctet_idle <= 'd0; 
      nx0_lsoctet_term <= 'd0; 
      nx0_msoctet_os   <= 'd0; 
      nx0_msoctet_idle <= 'd0; 
      nx0_msoctet_term <= 'd0; 

      cur_lsoctet_os   <= 'd0; 
      cur_lsoctet_idle <= 'd0; 
      cur_lsoctet_term <= 'd0; 
      cur_msoctet_os   <= 'd0; 
      cur_msoctet_idle <= 'd0; 
      cur_msoctet_term <= 'd0; 

      pre_lsoctet_os   <= 'd0; 
      pre_lsoctet_idle <= 'd0; 
      pre_lsoctet_term <= 'd0; 
      pre_msoctet_os   <= 'd0; 
      pre_msoctet_idle <= 'd0; 
      pre_msoctet_term <= 'd0; 
   end
   else begin  
      nx1_data_in      <= (data_valid_in)     ? wr_data_in : nx1_data_in;
      nx0_data_in      <= (nx1_data_valid_in) ? nx1_data_in : nx0_data_in;
      cur_data_in      <= (nx0_data_valid_in) ? nx0_data_in : cur_data_in;
      pre_data_in      <= (cur_data_valid_in) ? cur_data_in : pre_data_in; 

      nx0_lsoctet_os   <= (nx1_data_valid_in) ? nx1_lsoctet_os   : nx0_lsoctet_os;     
      nx0_lsoctet_idle <= (nx1_data_valid_in) ? nx1_lsoctet_idle : nx0_lsoctet_idle; 
      nx0_lsoctet_term <= (nx1_data_valid_in) ? nx1_lsoctet_term : nx0_lsoctet_term; 
      nx0_msoctet_os   <= (nx1_data_valid_in) ? nx1_msoctet_os   : nx0_msoctet_os;  
      nx0_msoctet_idle <= (nx1_data_valid_in) ? nx1_msoctet_idle : nx0_msoctet_idle; 
      nx0_msoctet_term <= (nx1_data_valid_in) ? nx1_msoctet_term : nx0_msoctet_term;  

      cur_lsoctet_os   <= (nx0_data_valid_in) ? nx0_lsoctet_os   : cur_lsoctet_os;     
      cur_lsoctet_idle <= (nx0_data_valid_in) ? nx0_lsoctet_idle : cur_lsoctet_idle; 
      cur_lsoctet_term <= (nx0_data_valid_in) ? nx0_lsoctet_term : cur_lsoctet_term; 
      cur_msoctet_os   <= (nx0_data_valid_in) ? nx0_msoctet_os   : cur_msoctet_os;  
      cur_msoctet_idle <= (nx0_data_valid_in) ? nx0_msoctet_idle : cur_msoctet_idle; 
      cur_msoctet_term <= (nx0_data_valid_in) ? nx0_msoctet_term : cur_msoctet_term;  

// HN 11/25/08 Un-used
      pre_lsoctet_os   <= (cur_data_valid_in) ? cur_lsoctet_os   : pre_lsoctet_os;     
      pre_lsoctet_idle <= (cur_data_valid_in) ? cur_lsoctet_idle : pre_lsoctet_idle; 
      pre_lsoctet_term <= (cur_data_valid_in) ? cur_lsoctet_term : pre_lsoctet_term; 
      pre_msoctet_os   <= (cur_data_valid_in) ? cur_msoctet_os   : pre_msoctet_os;  
      pre_msoctet_idle <= (cur_data_valid_in) ? cur_msoctet_idle : pre_msoctet_idle; 
      pre_msoctet_term <= (cur_data_valid_in) ? cur_msoctet_term : pre_msoctet_term;  

      // Reset these before decoding
      nx1_lsoctet_os   <= 'd0; 
      nx1_lsoctet_idle <= 'd0; 
      nx1_lsoctet_term <= 'd0; 
      nx1_msoctet_os   <= 'd0; 
      nx1_msoctet_idle <= 'd0; 
      nx1_msoctet_term <= 'd0; 

      // Decode Next1 data
      case(wr_data_in[71:64])
      8'b1111_1111: begin 
         // 2nd row of Figure 49-7, BLOCK_TYPE_FIELD=8'h1e
         // Check if all bits are control, then if true, convert from XGMII to 10GBASE-R
         // C7,C6,C5,C4/C3,C2,C1,C0
         if (wr_data_in[63:32] == {4{XGMII_IDLE}}) begin
             nx1_msoctet_idle <= 1'b1; 
         end
         else begin
             nx1_msoctet_idle <= 1'b0; 
         end
         if (wr_data_in[31:0] == {4{XGMII_IDLE}}) begin
             nx1_lsoctet_idle  <= 1'b1;
         end
         else begin
             nx1_lsoctet_idle  <= 1'b0;
         end
         // 10th row of Figure 49-7, BLOCK_TYPE_FIELD=8'h87
         // C7,C6,C5,C4/C3,C2,C1,T0
         if (wr_data_in[7:0] == XGMII_TERM) begin
            nx1_lsoctet_term <= 1'b1;
         end
         else begin
            nx1_lsoctet_term <= 1'b0;
         end
      end
      8'b0001_1111: begin 
         // 3rd row of Figure 49-7, BLOCK_TYPE_FIELD=8'h2d
         // Check if HIGH ORDERED SET and 1st_XGMII_transfer = all_control. 
         // D7,D6,D5,O4/C3,C2,C1,C0
         if (wr_data_in[39:32] == XGMII_SEQOS) begin
            nx1_msoctet_os <= 1'b1;
         end
         if (wr_data_in[31:0] == {4{XGMII_IDLE}}) begin
            nx1_lsoctet_idle <= 1'b1;
         end
         else begin
            nx1_lsoctet_idle <= 1'b0;
         end
      end
      8'b0001_0001: begin 
         // 6th row of Figure 49-7, BLOCK_TYPE_FIELD=8'h66
         // D7,D6,D5,O4/D3,D2,D1,O0
         if (wr_data_in[39:32] == XGMII_SEQOS) begin
            nx1_msoctet_os <= 1'b1;
         end
         else begin
            nx1_msoctet_os <= 1'b0;
         end
         if (wr_data_in[7:0] == XGMII_SEQOS) begin
            nx1_lsoctet_os <= 1'b1;
         end
         else begin
            nx1_lsoctet_os <= 1'b0;
         end
      end
      8'b1111_0001: begin 
         // 8th row of Figure 49-7, BLOCK_TYPE_FIELD=8'h4b
         // C7,C6,C5,C4/D3,D2,D1,O0
         if (wr_data_in[63:32] == {4{XGMII_IDLE}}) begin
            nx1_msoctet_idle <= 1'b1;
         end
         else begin
            nx1_msoctet_idle <= 1'b0;
         end
         if (wr_data_in[7:0] == XGMII_SEQOS) begin
            nx1_lsoctet_os <= 1'b1;
         end
         else begin
            nx1_lsoctet_os <= 1'b0;
         end
      end
      8'b1111_1110: begin 
         // 10th row of Figure 49-7, BLOCK_TYPE_FIELD=8'h99
         // C7,C6,C5,C4/C3,C2,T1,D0
         if (wr_data_in[15:8] == XGMII_TERM) begin
            nx1_lsoctet_term <= 1'b1;
         end
         else begin
            nx1_lsoctet_term <= 1'b0;
         end
      end
      8'b1111_1100: begin 
         // 11th row of Figure 49-7, BLOCK_TYPE_FIELD=8'haa
         // C7,C6,C5,C4/C3,T2,D1,D0
         if (wr_data_in[23:16] == XGMII_TERM) begin
            nx1_lsoctet_term <= 1'b1;
         end
         else begin
            nx1_lsoctet_term <= 1'b0;
         end
      end
      8'b1111_1000: begin 
         // 12th row of Figure 49-7, BLOCK_TYPE_FIELD=8'hb4
         // C7,C6,C5,C4/T3,D2,D1,D0
         if (wr_data_in[31:24] == XGMII_TERM) begin
            nx1_lsoctet_term <= 1'b1;
         end
         else begin
            nx1_lsoctet_term <= 1'b0;
         end
      end
      8'b1111_0000: begin 
         // 13th row of Figure 49-7, BLOCK_TYPE_FIELD=8'hcc
         // C7,C6,C5,T4/D3,D2,D1,D0
         if (wr_data_in[39:32] == XGMII_TERM) begin
            nx1_msoctet_term <= 1'b1;
         end
         else begin
            nx1_msoctet_term <= 1'b0;
         end
      end
      8'b1110_0000: begin     
         // 14th row of Figure 49-7, BLOCK_TYPE_FIELD=8'hd2
         // C7,C6,T5,D4/D3,D2,D1,D0
         if (wr_data_in[47:40] == XGMII_TERM) begin
            nx1_msoctet_term <= 1'b1;
         end
         else begin
            nx1_msoctet_term <= 1'b0;
         end
      end
      8'b1100_0000: begin  
         // 15th row of Figure 49-7, BLOCK_TYPE_FIELD=8'he1
         // C7,T6,D5,D4/D3,D2,D1,D0
         if (wr_data_in[55:48] == XGMII_TERM) begin
            nx1_msoctet_term <= 1'b1;
         end
         else begin
            nx1_msoctet_term <= 1'b0;
         end
      end
      8'b1000_0000: begin  
         // 16th row of Figure 49-7, BLOCK_TYPE_FIELD=8'hff
         // T7,D6,D5,D4/D3,D2,D1,D0
         if (wr_data_in[63:56] == XGMII_TERM) begin
            nx1_msoctet_term <= 1'b1;
         end
         else begin
            nx1_msoctet_term <= 1'b0;
         end
      end
      default: begin
         nx1_lsoctet_os   <= 'd0; 
         nx1_lsoctet_idle <= 'd0; 
         nx1_lsoctet_term <= 'd0; 
         nx1_msoctet_os   <= 'd0; 
         nx1_msoctet_idle <= 'd0; 
         nx1_msoctet_term <= 'd0; 
      end
      endcase
   end
end

//********************************************************************
// Delete the Current/Next0 LS OCTET if 
//    1) Previous LS OCTET has T and Current LS OCTET is IDLE 
//    --> this will make sure that there is miminum of 5 IPG
//    2) Previous LS OCTET is not T & the Previous MS Octet is an OS 
//    and is same as the current LS OCTET which is an OS 
//    2) Previous MS OCTET is not T & the current LS octet is IDLE  
//    
// Delete the Current/Next0 MS OCTET if 
//    1) Previous MS OCTET has T and Current MS OCTET is IDLE
//    --> this will make sure that there is a minimum 5 IPG
//    2) Previous LS OCTET is not T & the Previous MS Octet is an OS 
//    and is same as the current LS OCTET which is an OS 
//    2) Previous LS OCTET is not T & the current LS octet is IDLE  
//********************************************************************
   // Current OS is delete-able if previous word is an OS and it's not delete-able
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         cur_lsoctet_del <= 1'b0;
         cur_msoctet_del <= 1'b0;
         nx0_lsoctet_del <= 1'b0;
         nx0_msoctet_del <= 1'b0;
      end
      else begin
         // Decode for Current Data Decodes
         if ((((cur_msoctet_os & nx0_lsoctet_os & !cur_msoctet_del) & (cur_data_in[63:32] == nx0_data_in[31:0]))) |
             (cur_msoctet_term == 1'b0 & nx0_lsoctet_idle)) begin
            cur_lsoctet_del <= 1'b1;
         end
         else begin
            cur_lsoctet_del <= 1'b0;
         end
         
         if ((((nx0_lsoctet_os & nx0_msoctet_os & !((cur_msoctet_os & nx0_lsoctet_os & !cur_msoctet_del) & (cur_data_in[63:32] == nx0_data_in[31:0]))) & (nx0_data_in[31:0] == nx0_data_in[63:32]))) | 
             (nx0_lsoctet_term == 1'b0 & nx0_msoctet_idle)) begin
            cur_msoctet_del <= 1'b1;
         end
         else begin
            cur_msoctet_del <= 1'b0;
         end
         
         
         // Decode for NEXT0 Data Decodes
         if ((((nx0_msoctet_os & nx1_lsoctet_os & !nx0_msoctet_del) & (nx0_data_in[63:32] == nx1_data_in[31:0]))) |
             (nx0_msoctet_term == 1'b0 & nx1_lsoctet_idle)) begin
            nx0_lsoctet_del <= 1'b1;
         end
         else begin
            nx0_lsoctet_del <= 1'b0;
         end
         
         if ((((nx1_lsoctet_os & nx1_msoctet_os & !((nx0_msoctet_os & nx1_lsoctet_os & !nx0_msoctet_del) & (nx0_data_in[63:32] == nx1_data_in[31:0]))) & (nx1_data_in[31:0] == nx1_data_in[63:32]))) |
             (nx1_lsoctet_term == 1'b0 & nx1_msoctet_idle)) begin
            nx0_msoctet_del <= 1'b1;
         end
         else begin
            nx0_msoctet_del <= 1'b0;
         end
      end
   end


//********************************************************************
// WRITE CLOCK DOMAIN: Delete 1 OCTET when PFULL. 
// In order to stop the writing to the FOFO the following conditions has to be
// true
// 1) Check in the current received data if any octet can be deleted
//    if it can be deleted, form a 64 it data by borrowing octet from next
//    data  
// 2) Before borrowing an octet from nex data, make sure the octet being
//    borrowed is valid and not a ocetet that is to be deleted.
// 3) If no valid octet are present in the next data, store the current octet
//    until a valid data is received to form a 64 bit data.  
//
// The logic implemented below looks at the current 2 octet (MSB,LSB) and the next
// 2 octet (MSB,LSB).
// 
// WR_IDLE: This is the default state. In this state are the 4 octets are looked
// at to decide how to form the 64 bit data.
// WR_ADD_NXT_DAT : In this state one VALID next data MSB/LSB octet is
// combined with the current data MSB/LSB octet.
// WR_ADD_STOR_DAT : In thei state the current data MSB/LSB is stored if the
// next data does not have a vaid data (MSB/LSB octet of next data to be
// deleted) 
// WR_ADD_NULL_DAT: In this state, no data is formed and the fifo write enable
// is pulled low for a clock cycle.
//********************************************************************
assign cur_data_in_lsd = cur_data_in[31:0];
assign cur_data_in_msd = cur_data_in[63:32];
assign cur_data_in_lsc = cur_data_in[67:64];
assign cur_data_in_msc = cur_data_in[71:68];

assign nx0_data_in_lsd = nx0_data_in[31:0];
assign nx0_data_in_msd = nx0_data_in[63:32];
assign nx0_data_in_lsc = nx0_data_in[67:64];
assign nx0_data_in_msc = nx0_data_in[71:68];

// Sequintial Part of SM
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      wr_en            <= 1'b0;
      wr_del_sm        <= WR_IDLE;
      wr_data[PCSDWIDTH-1:0] <= {8{XGMII_IDLE}};
      wr_data[FDWIDTH-1: PCSDWIDTH]<= 9'h0FF;

      store_lsd        <= 'd0; 
      store_lsc        <= 'd0; 
      store_err        <= 1'b0;
   end
   else if (cur_data_valid_in) begin

   wr_data[FDWIDTH-1: PCSDWIDTH]      <= wr_data_in[FDWIDTH-1: PCSDWIDTH];
   
   case(wr_del_sm)
      WR_IDLE: begin
         casez({wr_pfull,  nx0_msoctet_del,nx0_lsoctet_del,  cur_msoctet_del,cur_lsoctet_del})
         5'b1_?0_01: begin
            wr_del_sm        <= WR_ADD_NXT_DAT; 
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_msd};    // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_msc};    // Control Bits
            wr_data[FDWIDTH-1]         <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit
                    
         end
         5'b1_?0_10: begin
            wr_del_sm        <= WR_ADD_NXT_DAT;
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_lsd};    // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_lsc};    // Control Bits
            wr_data[FDWIDTH-1]         <= 1'b0 ;                // Error Insertion Bit

         end
         5'b1_01_01: begin
            wr_del_sm        <= WR_ADD_NULL_DAT; 
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_msd};    // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_msc};    // Control Bits
            wr_data[FDWIDTH-1]         <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit

         end
         5'b1_01_10: begin
            wr_del_sm        <= WR_ADD_NULL_DAT;
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_lsd};    // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_lsc};    // Control Bits
            wr_data[FDWIDTH-1]         <= 1'b0 ;                // Error Insertion Bit
         end
         5'b1_11_01:  begin
            wr_del_sm        <= WR_ADD_STOR_DAT; 
            wr_en            <= 1'b0;
            store_lsd        <= cur_data_in_msd; // Data Bits
            store_lsc        <= cur_data_in_msc; // Control Bits
            store_err           <= cur_data_in[FDWIDTH-1];    // Error Insertion Bit
         end

         5'b1_11_10: begin
            wr_del_sm        <= WR_ADD_STOR_DAT; 
            wr_en            <= 1'b0;
            store_lsd        <= cur_data_in_lsd; // Data Bits
            store_lsc        <= cur_data_in_lsc; // Control Bits 
            store_err           <= 1'b0;           // Error Insertion Bit
         end
         
         5'b1_??_11: begin
           wr_del_sm        <= WR_IDLE; 
           wr_en            <= 1'b0;
         end
      
      default: begin
            wr_del_sm        <= WR_IDLE;
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd    , cur_data_in_lsd};    // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {cur_data_in_msc    , cur_data_in_lsc};    // Control Bits
            wr_data[FDWIDTH-1]         <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit
         end
         endcase
      end
      WR_ADD_NXT_DAT: begin 
         casez({wr_pfull,nx0_msoctet_del,nx0_lsoctet_del,cur_msoctet_del})
         4'b1_?_01: begin
            wr_del_sm        <= WR_IDLE; 
            wr_en            <= 1'b0;
         end
         4'b1_0_10: begin
            wr_del_sm        <= WR_ADD_NULL_DAT; 
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_msd};    // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_msc};    // Control Bits
            wr_data[FDWIDTH-1]         <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit
     end

         4'b1_1_10:
       begin
             wr_del_sm        <= WR_ADD_STOR_DAT; 
             wr_en            <= 1'b0;
             store_lsd        <= cur_data_in_msd; // Data Bits
             store_lsc        <= cur_data_in_msc; // Control Bits
             store_err        <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit 
           end

     4'b1_0_11: begin
             wr_del_sm        <= WR_ADD_STOR_DAT; 
             wr_en            <= 1'b0;
             store_lsd        <= cur_data_in_msd; // HN
             store_lsc        <= cur_data_in_msc; // HN
             store_err          <= 1'b0;          // Error Insertion Bit
         end 

         4'b1_1_11: begin
            wr_del_sm        <= WR_ADD_NULL_DAT; 
            wr_en            <= 1'b0;
         end
         default: begin
            wr_del_sm        <= WR_ADD_NXT_DAT;
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_msd};    // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_msc};    // Control Bits
            wr_data[FDWIDTH-1]         <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit
         end
         endcase
      end
      WR_ADD_STOR_DAT: begin
         case({wr_pfull,cur_msoctet_del,cur_lsoctet_del})
         3'b1_01: begin
            wr_del_sm        <= WR_IDLE; 
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd , store_lsd}; // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {cur_data_in_msc , store_lsc}; // Control Bits
            wr_data[FDWIDTH-1]         <= store_err || cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit
         end
         3'b1_10: begin
            wr_del_sm        <= WR_IDLE; 
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
            wr_data[FDWIDTH-1]         <= store_err ;    // Error Insertion Bit
         end
         3'b1_00: begin
            wr_del_sm        <= WR_ADD_STOR_DAT;
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
            wr_data[FDWIDTH-1]         <= store_err ;    // Error Insertion Bit
            store_lsd        <= cur_data_in_msd;               // Data Bits
            store_lsc        <= cur_data_in_msc;               // Control Bits
            store_err        <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit 

         end

         3'b1_11: begin 
              wr_del_sm        <= WR_ADD_STOR_DAT;
              wr_en            <= 1'b0;
         end     

         default: begin
            wr_del_sm        <= WR_ADD_STOR_DAT;
            wr_en            <= 1'b1;
            wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
            wr_data[FDWIDTH-2: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
            wr_data[FDWIDTH-1]         <= store_err ;    // Error Insertion Bit
            store_lsd        <= cur_data_in_msd;               // Data Bits
            store_lsc        <= cur_data_in_msc;               // Control Bits
            store_err        <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit 

         end
                  
         endcase
      end
      WR_ADD_NULL_DAT: begin
           wr_del_sm        <= WR_IDLE; 
           wr_en            <= 1'b0;
         end

      WR_ADD_NO_DEL: begin
         wr_del_sm        <= WR_IDLE;
         wr_en            <= 1'b1;
         wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd    , cur_data_in_lsd};    // Data Bits
         wr_data[FDWIDTH-2: PCSDWIDTH]<= {cur_data_in_msc    , cur_data_in_lsc};    // Control Bits
         wr_data[FDWIDTH-1]         <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit

      end

      default: begin
         wr_del_sm        <= WR_IDLE;
         wr_en            <= 1'b1;
         wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd    , cur_data_in_lsd};    // Data Bits
         wr_data[FDWIDTH-2: PCSDWIDTH]<= {cur_data_in_msc    , cur_data_in_lsc};    // Control Bits
         wr_data[FDWIDTH-1]         <= cur_data_in[FDWIDTH-1] ;    // Error Insertion Bit
      end
      
   endcase
   end
   else begin
      wr_en            <= 1'b0;
   end
end

// Deletion Flag
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      start_write       <= 'd0;
      fifo_del        <= 1'b0;
   end
   else begin
      start_write       <= wr_en || start_write;
      fifo_del         <= start_write & (~wr_en || wr_full);
   end
end

//********************************************************************
// READ CLOCK DOMAIN: STOP reading when PEMPTY,
// This logic stops the read data from the fifo if the FIFO becomes partial
// empty, the FIFO read is stopped when the read data has a 
// IDLE/TERM/SEQ_IDLE/IDLE_SEQ
//********************************************************************
// IDLE/OS detection on read side

assign rd_lw_idle = (fifo_out_next[31:0] == {4{XGMII_IDLE}} && fifo_out_next[67:64] == 4'hF) ? 1'b1: 1'b0;
assign rd_uw_idle = (fifo_out_next[63:32] == {4{XGMII_IDLE}} && fifo_out_next[71:68] == 4'hF) ? 1'b1: 1'b0;

// OS detection
// Only delete 2nd OS of consecutive identical OS's
assign rd_lw_os = (fifo_out_next[7:0] == XGMII_SEQOS && fifo_out_next[67:64] == 4'h1) ? 1'b1: 1'b0;
assign rd_uw_os = (fifo_out_next[39:32] == XGMII_SEQOS && fifo_out_next[71:68] == 4'h1) ? 1'b1: 1'b0;

assign ch_insert = {rd_uw_idle||rd_uw_os, rd_lw_idle||rd_lw_os}; 

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      first_read         <= 1'b1;
   end
   else if (~rd_pempty && first_read) begin
      first_read         <= 1'b0;
   end
end


   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_add_sm          <= RD_IDLE;
         rd_en_10g              <= 1'b0;
         insert_after    <= 1'b0;
         insert_between    <= 1'b0;
         keep_insert        <= 1'b0;
      end
      else begin
        if (rd_val) begin
            case(rd_add_sm)
              RD_IDLE: begin
                 if (~rd_pempty && ~first_read) begin
                    rd_add_sm      <= RD_ENABLE;
                    rd_en_10g          <= 1'b1;
                 end  
                 else begin
                    rd_add_sm      <= RD_IDLE;
                    rd_en_10g          <= 1'b0;
                 end      
              end
              RD_ENABLE: begin
                 insert_after    <= 1'b0;
                 insert_between    <= 1'b0;
                 keep_insert        <= 1'b0;
                 
                 if(|ch_insert_reg && rd_pempty) 
                   begin
                      rd_add_sm        <= RD_INSERT; 
                      rd_en_10g            <= 1'b0;
                      
                      // Data insertion logic
                      casez(ch_insert_reg)
                        2'b1?: begin
                           // When UW is Idle/OS
                   insert_after    <= 1'b1;
                        end
                        // When LW is Idle/OS    
                        2'b01: begin
                           insert_between    <= 1'b1;
                        end
                        default: begin
                         insert_after    <= 1'b0;
                       insert_between    <= 1'b0;
            end
                        
                      endcase
                      
                   end
                 
                 else 
                   begin
                      rd_add_sm        <= RD_ENABLE; 
                      rd_en_10g            <= 1'b1;
                   end
              end 
              
              
              RD_INSERT: begin

                 keep_insert        <= 1'b0;

                 if (rd_pempty && r_truebac2bac) begin
                    rd_add_sm        <= RD_INSERT;
                    rd_en_10g            <= 1'b0;
                    keep_insert        <= 1'b1;
                   
                 end
                 else if (insert_after) begin
                    rd_add_sm        <= RD_ENABLE;
                    rd_en_10g            <= 1'b1;
//                    insert_after    <= 1'b0;
                 end   
                 else if (insert_between) begin
                    rd_add_sm        <= RD_ENABLE;
                    rd_en_10g            <= 1'b1;
//                    insert_between    <= 1'b0;
                 end   
                                       
              end
              default: begin
                 rd_add_sm      <= RD_IDLE;
                 rd_en_10g          <= 1'b1;
              end
            endcase
            
         end   
         
         else begin
            rd_en_10g              <= 1'b0;
         end
         
      end         
   end


// Idle insertion based on rd_add_sm
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      d_out             <= FIFO_DEFAULT;      
   end
// Must use rd_val_d0 as "data_valid" cause rd_add_sm operates on rd_vald
   else if (rd_val_d0) begin
      if (rd_add_sm_reg==RD_IDLE) begin
        if (~rd_pempty && ~first_read)
          d_out          <= fifo_out;
        else         
          d_out          <= FIFO_DEFAULT;
      end  
      
      else if (rd_add_sm_reg==RD_ENABLE) begin
// Insert after when UW is Idle/OS
        if (insert_after)
          d_out             <= fifo_out;
// Insert after when LW is Idle/OS and UW is not
        else if (insert_between)
      d_out          <=     {fifo_out[FDWIDTH-1:72] ,4'hF, fifo_out[67:64], XGMII_IDLE_WORD, fifo_out[31:0]};
    else
      d_out             <= fifo_out;
      end          
         
      else if (rd_add_sm_reg==RD_INSERT) begin
        if (keep_insert)
          d_out            <= {9'h0FF,{2{XGMII_IDLE_WORD}}};
        else if (insert_after)
          d_out             <= {9'h0FF,{2{XGMII_IDLE_WORD}}};
        else if (insert_between)
          d_out             <= {fifo_out[FDWIDTH-1:68], 4'hF, fifo_out[63:32], XGMII_IDLE_WORD};
        else
          d_out             <= fifo_out;
      end  
      
   end
end


always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      ch_insert_reg     <= 'd0;
      rd_add_sm_reg     <= RD_IDLE;
   end
   else begin
      ch_insert_reg     <= ch_insert;
      rd_add_sm_reg     <= rd_add_sm;
   end
end   

// Insert Counter
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      insert_cnt     <= 'd0;
   end
   else if (!insert_after && !insert_between) begin
      insert_cnt     <= 'd0;
   end
   else if (insert_cnt < 4'd15 && rd_en_10g != rd_val_d0) begin
      insert_cnt     <= insert_cnt + 1'b1;
   end   
end   


// 10G BaseR insertion flag
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         fifo_insert    <= 1'b0;      
      end
      else begin
         fifo_insert    <= insert_after || insert_between ;      
      end
   end 
   

// Output Register and Bypass Logic
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_valid_out     <= 1'b0;
      data_out           <= FIFO_DATA_DEFAULT;
      control_out         <= FIFO_CTRL_DEFAULT;
   end
   else if (register_mode == 1'b1) begin
      data_valid_out     <= data_valid_in;
      data_out           <= data_in;
      control_out         <= control_in;
   end
// Output LF when FIFO is empty
   else if (rd_empty) begin
      data_valid_out     <= 1'b0;
      data_out           <= FIFO_DATA_DEFAULT;
      control_out         <= FIFO_CTRL_DEFAULT;
   end
// 10G Base-R clock Comp
   else if (clkcomp_mode) begin
      data_valid_out     <= rd_val_d1;
      {control_out, data_out}           <= d_out;
   end 
// Interlaken mode and Phase Comp mode
// Use rd_en to gate data_out and generate data_valid_out
   else begin
      data_valid_out     <= rd_en_int ? 1'b1: 1'b0;
      {control_out, data_out}           <= rd_en_int ? fifo_out: {control_out, data_out};
   end
end


//********************************************************************
// FIFO bonding logic 
//********************************************************************
assign intlkn_rden = ~rd_pempty; 


// Data valid Enable to CP Bonding
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      dv_en_d0         <=     1'b0;
      dv_en_d1         <=     1'b0;
      dv_en_d2         <=     1'b0;
      dv_en_d3         <=     1'b0;
      dv_en_d4         <=     1'b0;
   end
   else begin
      dv_en_d0         <=     1'b1;
      dv_en_d1         <=     dv_en_d0;
      dv_en_d2         <=     dv_en_d1;
      dv_en_d3         <=     dv_en_d2;
      dv_en_d4         <=     dv_en_d3;
   end
end   

assign dv_en = dv_en_d4;

// comp_dv_en Synchronizer
   alt_mge16_pcs_std_synchronizer 
     #(
       .depth   (2)        // Sync stages
       )
       bitsync_comp_dv_en
         (
          .clk      (wr_clk),
          .reset_n  (wr_rst_n),
          .din      (comp_dv_en),
          .dout     (comp_dv_en_sync)
          );


// Phase Comp FIFO mode Write/Read enable logic generation
// Write Enable
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     phcomp_wren_d0 <= 1'b0;
     phcomp_wren_d1 <= 1'b0;
     phcomp_wren_d2 <= 1'b0;
     phcomp_wren_d3 <= 1'b0;
     phcomp_wren_d4 <= 1'b0;
     phcomp_wren_reg <= 1'b0;

   end
   else begin
     phcomp_wren_d0 <= (r_indv || comp_dv_en_sync) || phcomp_wren_d0;    // Indv: 1, Bonding: goes high and stays high when comp_dv_en goes high 
     phcomp_wren_d1 <= phcomp_wren_d0;
     phcomp_wren_d2 <= phcomp_wren_d1;
     phcomp_wren_d3 <= phcomp_wren_d2;
     phcomp_wren_d4 <= phcomp_wren_d3;
     phcomp_wren_reg <= (r_phcomp_rd_delay == 3'b100) ? phcomp_wren_d4: (r_phcomp_rd_delay == 3'b011) ? phcomp_wren_d3 : (r_phcomp_rd_delay == 3'b010) ? phcomp_wren_d2 : (r_phcomp_rd_delay == 3'b001) ? phcomp_wren_d1 : phcomp_wren_d0;

   end
end

assign phcomp_wren = phcomp_wren_d0;

// phcomp_wren Synchronizer
   alt_mge16_pcs_std_synchronizer 
     #(
       .depth   (2)        // Sync stages
       )
       bitsync_phcomp_wren
         (
          .clk      (rd_clk),
          .reset_n  (rd_rst_n),
          .din      (phcomp_wren_reg),
          .dout     (phcomp_wren_sync)
          );

// Read Enable
assign phcomp_rden = phcomp_wren_sync;

// Phase comp mode, FIFO read enable signal asserts when rd_val is high
assign phcomp_rden_int = phcomp_rden & rd_val;

assign comp_rden_en_int = comp_rden_en & rd_val;

//********************************************************************
// READ Valid generation 
// Since the logic after the Clock Comp is running at the same clock,
// generate read valid to have GEARBOX TX continous o/p  
// rd_valid is generated as follows
// 10101010...100101010
//********************************************************************
// assign gb_odwidth = (r_gb_odwidth == 'd4) ? 32 : (r_gb_odwidth == 'd3) ? 40 :  (r_gb_odwidth == 'd2) ? 50 : (r_gb_odwidth == 'd1) ? 67 : 66;
// assign gb_idwidth = (r_gb_idwidth == 'd2) ? 64 : (r_gb_idwidth == 'd1) ? 40 : 32;

//assign gb_idwidth = (r_gb_idwidth == 'd4) ? 'd32 : (r_gb_idwidth == 'd3) ? 'd40 :  (r_gb_idwidth == 'd2) ? 'd50 : (r_gb_idwidth == 'd1) ? 'd67 : 'd66;
//assign gb_odwidth = (r_gb_odwidth == 'd2) ? 64 : (r_gb_odwidth == 'd1) ? 40 : 32;
//assign gb_odwidth = (r_gb_odwidth == 'd2) ? 'd64 : (r_gb_odwidth == 'd1) ? 'd40 : (r_gb_odwidth == 'd3) ? 'd20: 'd32;

assign  m_selcnt = (gb_idwidth+sel_cnt);

assign data_valid_raw = rd_val;

assign gap_cnt_en = ~first_read || (comp_dv_en && ~r_indv) || (intl_generic_mode && dv_en && r_indv);

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      sel_cnt_r <= 'd0;
      gap_cnt   <= 'd0;
      rd_val    <= 'd0;
      rd_val_d0 <= 'd0; 
      rd_val_d1 <= 'd0; 
   end
   else begin  
// rd_val Generation
// 10G BaseR: wait until first_read deasserts
// Phase Comp non-bonding: wait until first_read deasserts
// Phase Comp bonding: doesn't wait for first_read (Need data_valid to be available before write/read enable) 
// Interlaken Generic: doesn't wait for first_read (Interlaken needs data_valid for Frame Generator)
// Basic Generic: wait until first_read deasserts 
//       rd_val  <= (first_read && (~basic_generic_mode || ~(phcomp_mode && r_indv))) ? 1'b0 : 
       rd_val  <= ~gap_cnt_en ? 1'b0 : 
                 (gap_cnt == 'd0) ? 1'b1 
                 : 1'b0;

      rd_val_d0  <= rd_val; 
      rd_val_d1  <= rd_val_d0; 
      
      // Only enable gap_cnt when rd_pempty is low in clk comp mode
      // Or comp_dv_en high in phase comp bonding mode
//      if (~first_read || (comp_dv_en && phcomp_mode && ~r_indv)) begin
      if (gap_cnt_en) begin
        if (gap_cnt == 'd0) begin    
           // calculate next MUX selection
           if (m_selcnt >= gb_odwidth * 'd5) begin
              sel_cnt_r <= (m_selcnt-gb_odwidth * 'd5);
              gap_cnt <= 'd4;
           end
           else if (m_selcnt >= gb_odwidth * 'd4) begin
             sel_cnt_r <= (m_selcnt-gb_odwidth * 'd4);
             gap_cnt <= 'd3;
           end
           else if (m_selcnt >= gb_odwidth * 'd3) begin
             sel_cnt_r <= (m_selcnt-gb_odwidth * 'd3);
             gap_cnt <= 'd2;
           end
           else if (m_selcnt >= gb_odwidth * 'd2) begin
             sel_cnt_r <= (m_selcnt-gb_odwidth * 'd2);
             gap_cnt <= 'd1;
           end
           else begin 
             sel_cnt_r <= (m_selcnt-gb_odwidth);
             gap_cnt <= 'd0;
           end
        end
        else begin
           gap_cnt <= gap_cnt-1'b1;
        end
      
      end

   end
end

assign sel_cnt = sel_cnt_r[ISWIDTH-1:0];

// Testbus
assign testbus1 =    {sel_cnt[6:0],nx0_lsoctet_del,  cur_msoctet_del,cur_lsoctet_del, phcomp_wren, comp_wren_en, wr_numdata[4:0], wr_del_sm[1:0], wr_en_int};
assign testbus2 =    {rd_empty, rd_pempty, rd_full, rd_pfull, rd_val, rd_numdata[4:0], rd_add_sm[1:0], rd_en_int, comp_dv_en, comp_rden_en, comp_intlkn_rden_en, dv_en, phcomp_rden, intlkn_rden, data_valid_out};

 

endmodule
