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

module alt_mge_phy_xgmii_rx_fifo
   #(
    parameter PCSDWIDTH      = 'd64,     // PCS data width
    parameter PCSRXCWIDTH    = 'd10,     // PCS control width
    // The total FIFO datawdith is (PCSDWIDTH+PCSRXCWIDTH+)
    parameter FAWIDTH        = 'd5,      // FIFO Depth (address width) 
    parameter ISWIDTH        = 'd7,      // Gearbox Selector width
    parameter TSWIDTH        = 'd16,
    parameter IDWIDTH        = 'd40,     // PCS/PMA IF width
    parameter OFFSET         = 16'h283D, // PCS latency
	parameter DEVICE_FAMILY = "Arria V",
	parameter ENABLE_IEEE1588 = 0
//  parameter PFULL          = 'd12,     // Partial full level 
//  parameter PEMPTY         = 'd4,      // Partial empty level
     )
     (
    input  wire                     wr_rst_n,             // Write Domain Active low Reset
    input  wire                     rd_rst_n,             // Read Domain Active low Reset
    input  wire                     wr_clk,               // Write Domain Clock
    input  wire                     rd_clk,               // Read Domain Clock
	input  wire                     latency_sclk_reset,
//  input  wire                     bypass_cc,            // Bypass clock compensation
    input  wire                     r_force_align,        // Force alignment  
    input  wire                     r_align_del,          // Delete the alignment pattern   
    input  wire [PCSRXCWIDTH-1:0]   r_mask_del,           // Mask frame words for deletion
//  input  wire                     r_generic_mode,       // 0: 10g PCS, 1: Interlaken
    input  wire [2:0]               r_fifo_mode,          // FIFO Mode: Phase-comp, BaseR RM, Interlaken, Register Mode
    input  wire                     wr_align_mark,        // Alignment Pattern
    input  wire                     rd_align_en,          // This channel is active (rd_clk)
    input  wire                     rd_align_clr,         // Clears the wr_align_val (rd_clk) 
    input  wire                     rd_en,                // Read Data from DSKEW FIFO 
    input  wire [PCSRXCWIDTH-1:0]   control_in,           // Frame information 
    input  wire [PCSDWIDTH-1:0]     data_in,              // Write Data In
    input  wire                     data_valid_in,        // Write Data In Valid 
    input  wire [PCSRXCWIDTH-1:0]   control_in_fast,      // Fast control in 
    input  wire [PCSDWIDTH-1:0]     data_in_fast,         // Fast Write Data In
    input  wire                     data_valid_in_fast,   // Fast Write Data In Valid 


    input  wire [FAWIDTH-1:0]	    r_pempty,        // FIFO partially empty threshold
    input  wire [FAWIDTH-1:0]	    r_pfull,         // FIFO partially full threshold
    input  wire [FAWIDTH-1:0]	    r_empty,         // FIFO empty threshold
    input  wire [FAWIDTH-1:0]	    r_full,          // FIFO full threshold
    input  wire	            	    r_rx_fast_path,  // Fast Path Enable: directly from Gearbox
    input  wire                     r_truebac2bac,   // Back-2-back insertion/deletion
//  input  wire                     r_generic_ctrl,  // Select source that controls wr_en in FIFO generic mode. 0: Interlaken Frame Decoder, 1: data_valid_in
//  input  wire                     r_fifo_comp_type,// Clock Compensation Type. 0: 10G BaseR, 1: Basic Mode
    input  wire                     r_write_ctrl,    // RX FIFO clock comp mode write option
    input  wire	[63:0]              r_skip_word,     // Deletion word in basic clock comp mode
    input  wire	[2:0]               r_skip_ctrl,     // Deletion control in basic clock comp mode
//  input  wire [2:0]               r_gb_odwidth,    // Gearbox Output Width
    input  wire [6:0]               gb_odwidth,      // Gearbox Output Width  

    output  reg  [PCSRXCWIDTH-1:0]  control_out,     // Frame information 
    output  reg  [PCSDWIDTH-1:0]    data_out,        // Read Data Out (Contains CTRL+DATA)
    output  reg                     data_valid_out,  // Read Data Out Valid 
    output  wire                    rd_empty,        // Read empty
    output  wire                    rd_pempty,       // Read partial empty
    output  wire                    rd_pfull,        // Read partial full 
    output  wire                    wr_oflw_err,     // Overflow error 
    output  wire                    rd_align_val,    // Alignment Pattern has been found
//  output  wire                    rd_word_del,     // Flag to identify all words deleted
    output  wire [TSWIDTH-1:0]      latency_adj,     // Latency Measurement (6-bit cycle, 10-bit frac. cycle)
	input   wire                    latency_sclk,
	input   wire [11:0]             latency_xcvr_rx,
	
    output reg                      fifo_insert,     // 10G BaseR Insertion Flag
    output reg                      fifo_del,        // 10G BaseR Insertion Flag (Async)
    output wire[19:0]               testbus1,        // Test Bus 1
    output wire[19:0]               testbus2         // Test Bus 2

 );
   
   
   // Define Parameters 
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
   
   localparam                       WR_IDLE         = 3'd0; 
   localparam                       WR_ADD_NXT_DAT  = 3'd1; 
   localparam                       WR_ADD_STOR_DAT = 3'd2; 
   localparam                       WR_ADD_NULL_DAT = 3'd3; 
   localparam                       WR_ADD_NO_DEL   = 3'd4;
   
   localparam                       RD_IDLE         =2'd0;
   localparam                       RD_ENABLE       =2'd1;
   localparam                       RD_INSERT       =2'd2;
   
   localparam                       WR_IDLE_BASIC         =2'd0;
   localparam                       WR_ENABLE_BASIC       =2'd1;
   
   localparam                       XGMII_IDLE_WORD = {4{XGMII_IDLE}};
   
   localparam                       FIFO_DATA_DEFAULT = LBLOCK_R_10G;
   localparam                       FIFO_CTRL_DEFAULT = 16'h11;       // FIFO CTRL = {6-bits 1588 ctrl-bit, 2-bit 10gbaser ctrl-bit, 8-bit xgmii ctrl-bit}
   localparam                       FIFO_DEFAULT = {FIFO_CTRL_DEFAULT, FIFO_DATA_DEFAULT};  
 
   // 1588 Rate Match Case Parameter
   localparam                       RM_SM_WIDTH = 2;
   localparam                       RM_DEL_INS_WIDTH = 4;
   localparam                       RM_TOTAL_WIDTH = RM_SM_WIDTH + RM_DEL_INS_WIDTH; // affect FIFO_CTRL_DEFAULT
   localparam                       COUNTER_WIDTH = 7;
   localparam                       COUNTER_MAX   = 7'd80; // sampling window size 66 + max possible insertion ~4 + lat_adj clock crossing delay 5
                                                           // COUNTER_MAX set to bigger number than required contributes not much error.
                                                           // insertion case needs about 75. delete case needs about 55.
   localparam                       FDWIDTH = PCSDWIDTH+PCSRXCWIDTH+RM_TOTAL_WIDTH;
   localparam                       FDWIDTH_TRIMMED = (ENABLE_IEEE1588 == 1)? FDWIDTH-3 : FDWIDTH-9;

   // Define variables 
   // Regs
   // Pipelines
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg [FDWIDTH-1:0]                nx1_data_in;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg [FDWIDTH-1:0]                nx0_data_in;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg [FDWIDTH-1:0]                cur_data_in;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg [FDWIDTH-1:0]                pre_data_in;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx1_data_valid_in;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_data_valid_in;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_data_valid_in;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx1_lsoctet_os;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx1_lsoctet_idle;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx1_lsoctet_term;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx1_msoctet_os; 
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx1_msoctet_idle;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx1_msoctet_term;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_lsoctet_os;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_lsoctet_idle;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_lsoctet_term;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_msoctet_os; 
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_msoctet_idle;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_msoctet_term;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_lsoctet_idle;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_lsoctet_os;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_lsoctet_term;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_msoctet_os;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_msoctet_idle;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_msoctet_term;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              pre_lsoctet_os;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              pre_lsoctet_idle;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              pre_lsoctet_term; 
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              pre_msoctet_os;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              pre_msoctet_idle;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              pre_msoctet_term;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_msoctet_del;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              cur_lsoctet_del;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_msoctet_del;
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg                              nx0_lsoctet_del;
   reg                              wr_en;
// reg                              gen_idle;
   reg [FDWIDTH-3-RM_TOTAL_WIDTH:0] wr_data;
// reg                              rd_halffull;
   reg [2:0]                        wr_del_sm;
   reg [31:0]                       store_lsd;
   reg [3:0]                        store_lsc;
   reg [1:0]                        rd_add_sm;
// reg [ISWIDTH:0]                  sel_cnt;
// reg [1:0]                        gap_cnt;
   
   // Wires
// wire [ISWIDTH:0]                 m_selcnt;
// wire [FDWIDTH-1:0]               rd_data_out;
   wire [FAWIDTH-1:0]               rd_numdata;
   wire [FAWIDTH-1:0]               wr_numdata;
   wire [31:0]                      cur_data_in_lsd;
   wire [31:0]                      cur_data_in_msd;
   wire [3:0]                       cur_data_in_lsc;
   wire [3:0]                       cur_data_in_msc;
   wire [31:0]                      nx0_data_in_lsd;
   wire [31:0]                      nx0_data_in_msd;
   wire [3:0]                       nx0_data_in_lsc;
   wire [3:0]                       nx0_data_in_msc;
   
   
   wire [FDWIDTH-1:0]               fifo_out;
   wire [FDWIDTH_TRIMMED : 0]       fifo_out_w;
   wire [FDWIDTH-1:0]               fifo_out_next;
   wire [FDWIDTH_TRIMMED : 0]       fifo_out_next_w;
   
   reg [FDWIDTH-1:0]                d_out;
// reg [FDWIDTH-1:0]                d_out_next;
   
   
// reg [FDWIDTH-1:0]                data_out_int;
// reg [FDWIDTH-1:0]                control_out_int;
   
   wire                             rd_lw_idle;
   wire                             rd_uw_idle;
   
   wire                             rd_lw_os;
   wire                             rd_uw_os;
// reg                              rd_uw_os_reg;
   
// wire                             rd_lw_os_insert;
// wire                             rd_uw_os_insert;
   
   wire [1:0]                       ch_insert; 
// reg [1:0]                        ch_insert_reg;
   
   wire                             wr_en_int;
   wire [FDWIDTH_TRIMMED:0]         wr_data_in_int;
   
   reg                              first_read;
   
   reg                              insert_after;
   reg                              insert_between;
   
   reg                              rd_en_10g;
   wire [FDWIDTH - 1:0]             wr_data_in;
   
   
// wire [6:0]                       gb_odwidth;
// wire [6:0]                       gb_idwidth;
   
   wire                             rd_en_int;
// wire                             fifo_full;
   wire                             wr_full;
   wire                             rd_full;
   
   // Regs
   reg                              wr_align_val, nxt_wr_align_val;
   reg                              wr_fifo_en;
   reg                              wr_fifo_clr, nxt_wr_fifo_clr;
   
   // Wires
   wire                             wr_align_clr;
   wire                             wr_align_en;
   wire                             rd_srst_n;
   wire                             wr_srst_n;
   wire                             wr_pfull;
// wire                             wr_oflw_err;
   wire                             wr_word_del;
   wire                             ctrl_del;
   
   reg                              rd_val, nxt_rd_val;  
   reg                              rd_val_d1, nxt_rd_val_d1;  
   
   wire                             wr_empty;
   wire                             wr_pempty;
   wire                             data_valid_in_pre;   

reg			phcomp_wren_d0;
reg			phcomp_wren_d1;
wire		phcomp_wren;
wire		phcomp_rden;
wire		phcomp_wren_sync;
reg			phcomp_rden_d0;


// FIFO mode decode
wire intl_generic_mode = (r_fifo_mode == 3'b001);
wire basic_generic_mode = (r_fifo_mode == 3'b101);
wire register_mode = (r_fifo_mode[1:0] == 2'b11);
wire diff_clk_phcomp_mode = (r_fifo_mode == 3'b000);
wire same_clk_phcomp_mode = (r_fifo_mode == 3'b100);
wire base_r_clkcomp_mode = (r_fifo_mode == 3'b010);
wire basic_clkcomp_mode = (r_fifo_mode == 3'b110);

wire generic_mode = intl_generic_mode || basic_generic_mode;
wire clkcomp_mode = base_r_clkcomp_mode || basic_clkcomp_mode;
wire phcomp_mode  = diff_clk_phcomp_mode || same_clk_phcomp_mode;

wire				phcomp_wren_int;
wire				wr_fifo_en_int;
wire				wr_align_mark_int;
//wire				wr_del_10g;
//reg				cur_data_valid_in_d0;

reg 				fifo_insert_pre;      
reg					keep_insert;
reg [1:0]			rd_add_sm_reg;

//reg				fifo_del;
//wire 				fifo_del_comb;
wire [FDWIDTH-1:0]	wr_data_10g;
wire [FDWIDTH-1:0]	wr_data_10g_w;

wire				block_lock_sync;
reg					block_lock_lt;
wire				block_lock;
wire				block_lock_int;


reg [1:0]			rd_add_sm_basic;
reg					rd_en_basic;
reg					insert_after_basic;	
wire				rd_pat_match_basic;
reg	[1:0]				rd_add_sm_basic_reg;
reg [FDWIDTH-1:0]	d_out_basic;

wire				wr_pat_match_basic;
reg  [1:0]			wr_del_sm_basic;
reg					wr_en_basic;
reg [FDWIDTH-1:0]	wr_data_basic;

wire [FDWIDTH-1:0]	wr_data_in_phcomp;

reg					rd_en_lt;

wire [PCSRXCWIDTH-1:0]	control_in_pre;
wire [PCSDWIDTH-1:0]	data_in_pre;

   //********************************************************************
   // Instantiate the Async FIFO 
   // (parameter FDWIDTH,parameter FAWIDTH,parameter FIFO_ALMFULL,parameter FIFO_ALMEMPTY)
   //********************************************************************
   alt_mge_phy_async_fifo_fpga
     #(
       .DWIDTH        (FDWIDTH_TRIMMED + 1),       // FIFO Input data width 
       .AWIDTH        (FAWIDTH),         // FIFO Depth (address width) 
       .SYNCSTAGE     (5),               // Metastable hardening stages
       .RESET_LF      (1),               // Output Local Fault 
       .FIFO_DEFAULT  (FIFO_DEFAULT)     // FIFO DEFAULT VALUE
       )
       async_fifo
         (
          .wr_rst_n     (wr_rst_n),      // Write Domain Active low Reset
          .wr_srst_n    (wr_srst_n),     // Write Domain Active low Reset Synchronous
          .wr_clk       (wr_clk),        // Write Domain Clock
          .wr_en        (wr_en_int),     // Write Data Enable
          .wr_data      (wr_data_in_int),// Write Data In
          .rd_rst_n     (rd_rst_n),      // Read Domain Active low Reset
          .rd_srst_n    (rd_srst_n),     // Read Domain Active low Reset Synchronous
          .rd_clk       (rd_clk),        // Read Domain Clock
          .rd_en        (rd_en_int),     // Read Data Enable
          .rd_data      (fifo_out_w),      // Read Data Out 
          .rd_data_next (fifo_out_next_w), // Read Data Out 
          .rd_numdata   (rd_numdata),    // Number of Data available in Read clock
          .wr_numdata   (wr_numdata),    // Number of Data available in Write clock 
          .r_pempty     (r_pempty),      // FIFO partially empty threshold   
          .r_pfull      (r_pfull),       // FIFO partially full threshold   
          .r_empty      (r_empty),       // FIFO empty threshold   
          .r_full       (r_full),        // FIFO full threshold   
          .wr_empty     (wr_empty),      // FIFO Empty
          .wr_pempty    (wr_pempty),     // FIFO Partial Empty
          .wr_full      (wr_full),       // FIFO Full
          .wr_pfull     (wr_pfull),      // FIFO Parial Full
          .rd_empty     (rd_empty),      // FIFO Empty
          .rd_pempty    (rd_pempty),     // FIFO Partial Empty
          .rd_full      (rd_full),       // FIFO Full 
          .rd_pfull     (rd_pfull)       // FIFO Partial Full 
          );
   
   assign  wr_oflw_err = data_valid_in_pre & wr_full;
   assign  fifo_out = (ENABLE_IEEE1588 == 1)? {fifo_out_w[FDWIDTH-1-2 : FDWIDTH-2-RM_TOTAL_WIDTH],2'b00,fifo_out_w[FDWIDTH-3-RM_TOTAL_WIDTH:0]} : {8'h00,fifo_out_w[FDWIDTH-3-RM_TOTAL_WIDTH:0]} ;
   assign  fifo_out_next = (ENABLE_IEEE1588 == 1)? {fifo_out_next_w[FDWIDTH-1-2 : FDWIDTH-2-RM_TOTAL_WIDTH],2'b00,fifo_out_next_w[FDWIDTH-3-RM_TOTAL_WIDTH:0]} : {8'h00,fifo_out_next_w[FDWIDTH-3-RM_TOTAL_WIDTH:0]};


   reg                               octet_del_en_start_wrclk;  // wr_clk
   wire                              octet_del_en_start_rdclk;  // rd_clk
   wire                              octet_del_en_end;          // rd_clk
   wire                              octet_del_en;              // rd_clk
   reg                               octet_ins_en;              // rd_clk
   reg  [RM_DEL_INS_WIDTH-1:0]       octet_del_num;             // wr_clk
   wire [RM_DEL_INS_WIDTH-1:0]       octet_del_num_out;         // rd_clk
   wire [RM_SM_WIDTH-1:0]            wr_del_sm_out;             // rd_clk
   reg  [RM_DEL_INS_WIDTH-1:0]       octet_ins_num;             // rd_clk
   reg  [RM_DEL_INS_WIDTH-1:0]       octet_ins_num_hold;        // rd_clk
   reg  [COUNTER_WIDTH-1:0]          octet_del_counter;         // wr_clk
   reg  [COUNTER_WIDTH-1:0]          octet_ins_counter;         // rd_clk
 

   alt_mge_phy_xgmii_1588_latency
   #(
     .TX_RX            (1),                       // 1: RX FIFO (with ppm correction)
     .OFFSET           (OFFSET),                  // RX PCS Offset
     .NUMDATA_WIDTH    (5),                       // the greater number out of FAWIDTH in TX & RX
     .RM_DEL_INS_WIDTH (RM_DEL_INS_WIDTH),        // RX only - rate match latency adjustment
     .RM_SM_WIDTH      (RM_SM_WIDTH),             // RX only - rate match latency adjustment
     .IDWIDTH          (IDWIDTH),                 // RX only - ppm correction (Gearbox Input Data Width)
	 .DEVICE_FAMILY    (DEVICE_FAMILY)
    )
   alt_mge_phy_xgmii_1588_latency
     (
      .sample_clk(wr_clk),
      .sample_rst_n(wr_rst_n),    
      .clk(rd_clk),
      .rst_n(rd_rst_n),
      .numdata(wr_numdata),
      .octet_del_num(octet_del_num_out),        // RX only - rate match latency adjustment
      .wr_del_sm(wr_del_sm_out),                // RX only - rate match latency adjustment
      .octet_ins_num(octet_ins_num),            // RX only - rate match latency adjustment
      .octet_del_en(octet_del_en),              // RX only - rate match latency adjustment
      .octet_ins_en(octet_ins_en),              // RX only - rate match latency adjustment
      .sample_clk_data_valid(data_valid_in),    // RX only - ppm correction (pma_clk data_valid)
      .clk_block_lock(control_out[CTL_BFL]),    // RX only - ppm correction (mac_clk block_lock/rx_data_ready)
	  .latency_sclk(latency_sclk),
	  .latency_sclk_reset(latency_sclk_reset),
	  .latency_xcvr(latency_xcvr_rx),
      .latency_adj(latency_adj)
      );

   // rd_clk
   assign  octet_del_num_out = fifo_out[FDWIDTH-RM_SM_WIDTH-1:FDWIDTH-RM_TOTAL_WIDTH];
   assign  wr_del_sm_out     = fifo_out[FDWIDTH-1:FDWIDTH-RM_SM_WIDTH];
   assign  octet_del_en_end  = (octet_del_num_out == 4'd0) ? 1'b0 : 1'b1;
   assign  octet_del_en      = octet_del_en_start_rdclk | octet_del_en_end;
   
   // wr_clk
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         octet_del_en_start_wrclk  <= 1'b0; 
      end
      else begin
         if (octet_del_num == 4'd0) begin
            octet_del_en_start_wrclk <= 1'b0;
         end else begin
            octet_del_en_start_wrclk <= 1'b1;
         end
      end
   end

   // Synchronizer wr_clk to rd_clk
   alt_mge16_pcs_std_synchronizer
     #(
       .depth   (2)         // Sync stages
       )
       sync_del_en_rdclk
         (
          .clk      (rd_clk),
          .reset_n  (rd_rst_n),
          .din      (octet_del_en_start_wrclk),
          .dout     (octet_del_en_start_rdclk)
          );   
   
   
   //********************************************************************
   // Data is stored as follows 
   // TIME   DATA   Comments
   // t+1    nxt    Next
   // t 0    cur    CURRENT  <-------
   // t-1    pre    previous
   // decode the OS, IDLE TERM on each OCTET(4 Bytes)
   //********************************************************************
//   assign  wr_data_in = r_rx_fast_path ? {control_in_fast, data_in_fast} : {control_in, data_in};  
   assign  data_in_pre 		= r_rx_fast_path ? 	data_in_fast 	: 	data_in;  
   assign  control_in_pre 	= r_rx_fast_path ? 	control_in_fast	: 	control_in;  
   assign  data_valid_in_pre 	= r_rx_fast_path ? 	data_valid_in_fast : data_valid_in; 
   assign  wr_data_in 		= {control_in_pre, data_in_pre};

   // Insert data valid to control bit[7]
   assign  wr_data_in_phcomp = same_clk_phcomp_mode ? {wr_data_in[FDWIDTH-1: FDWIDTH-2-RM_TOTAL_WIDTH], data_valid_in_pre, wr_data_in[FDWIDTH-4-RM_TOTAL_WIDTH: 0]} : wr_data_in;  
   
//   assign  wr_data_in_int = r_generic_mode ? wr_data_in : wr_data; 
//   assign  wr_en_int = r_generic_mode ? wr_fifo_en : wr_en; 
   
//   assign  rd_en_int = r_generic_mode ? rd_en : rd_en_10g;
   

// Data & Write/Read selection for different modes

assign wr_data_in_int = generic_mode ? wr_data_in[FDWIDTH_TRIMMED : 0] :             // Generic
                        phcomp_mode ?  wr_data_in_phcomp[FDWIDTH_TRIMMED : 0] :      // Phase Comp Indiviual mode 
                        basic_clkcomp_mode ? wr_data_basic[FDWIDTH_TRIMMED : 0]:     // Basic Clcok Comp
                        wr_data_10g_w[FDWIDTH_TRIMMED : 0];				// BaseR Clock Comp

assign wr_en_int = phcomp_mode  ? phcomp_wren_int:		// Phase Comp Indiviual mode
                   generic_mode ? wr_fifo_en_int :		// Generic
                   basic_clkcomp_mode ? wr_en_basic :		// Basic Clcok Comp
                   wr_en;					// BaseR Clock Comp
                   
assign rd_en_int = phcomp_mode  ? phcomp_rden:			// Phase Comp Indiviual mode
                   generic_mode ? rd_en :			// Generic
                   basic_clkcomp_mode ? rd_en_basic :		// Basic Clcok Comp
                   rd_en_10g;					// BaseR Clock Comp

   
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         nx1_data_valid_in  <= 'd0; 
         nx0_data_valid_in  <= 'd0; 
         cur_data_valid_in  <= 'd0; 
//         cur_data_valid_in_d0  <= 'd0; 
      end
      else begin
         nx1_data_valid_in  <= data_valid_in_pre;
         nx0_data_valid_in  <= nx1_data_valid_in;
         cur_data_valid_in  <= nx0_data_valid_in;
//         cur_data_valid_in_d0  <= cur_data_valid_in; 
      end
   end

// 10G BaseR deletion
// Will connect to test bus and/or attatch to data bus
// Remove: redundant
// assign wr_del_10g = ~wr_en && cur_data_valid_in_d0;

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
         nx1_data_in      <= (data_valid_in_pre)     ? wr_data_in     : nx1_data_in;
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
   //	1) Previous LS OCTET has T and Current LS OCTET is IDLE 
   //	--> this will make sure that there is miminum of 5 IPG
   //	2) Previous LS OCTET is not T & the Previous MS Octet is an OS 
   //	and is same as the current LS OCTET which is an OS 
   //	2) Previous MS OCTET is not T & the current LS octet is IDLE  
   //	
   // Delete the Current/Next0 MS OCTET if 
   //	1) Previous MS OCTET has T and Current MS OCTET is IDLE
   //	--> this will make sure that there is a minimum 5 IPG
   //	2) Previous LS OCTET is not T & the Previous MS Octet is an OS 
   //	and is same as the current LS OCTET which is an OS 
   //	2) Previous LS OCTET is not T & the current LS octet is IDLE  
   //********************************************************************
   // Current OS is delete-able if previous word is an OS and it's not delete-able
/*
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
*/
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         nx0_lsoctet_del <= 1'b0;
         nx0_msoctet_del <= 1'b0;
      end
      else begin
      if (nx1_data_valid_in) begin
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
   end

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         cur_lsoctet_del <= 1'b0;
         cur_msoctet_del <= 1'b0;
      end
      else begin
      if (nx0_data_valid_in) begin
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

   assign block_lock 	= 	cur_data_in[PCSDWIDTH + CTL_BFL];	// Frame lock or Block lock status

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         block_lock_lt            <= 1'b0;
      end
      else begin
         block_lock_lt            <= block_lock || (block_lock_lt && r_write_ctrl);
      end   
   end
   
   assign block_lock_int = r_write_ctrl ? (block_lock_lt ||block_lock) : block_lock;
   
   // Sequintial Part of SM
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         wr_en             <= 1'b0;
         wr_del_sm         <= WR_IDLE;
         wr_data	       <= FIFO_DEFAULT[FDWIDTH-3-RM_TOTAL_WIDTH: 0];
         store_lsd         <= 'd0; 
         store_lsc         <= 'd0; 
         octet_del_num     <= {RM_DEL_INS_WIDTH{1'b0}};
         octet_del_counter <= {COUNTER_WIDTH{1'b0}};
      end
      else if (!block_lock_int) begin
         wr_en             <= 1'b0;
         wr_del_sm         <= WR_IDLE;
         wr_data	       <= FIFO_DEFAULT[FDWIDTH-3-RM_TOTAL_WIDTH: 0];
         store_lsd         <= 'd0; 
         store_lsc         <= 'd0; 
         octet_del_num     <= {RM_DEL_INS_WIDTH{1'b0}};
         octet_del_counter <= {COUNTER_WIDTH{1'b0}};
      end   

//      else if (cur_data_valid_in) begin
      else if (nx0_data_valid_in) begin
         
         case(wr_del_sm)
           WR_IDLE: begin
              casez({wr_pfull,  nx0_msoctet_del,nx0_lsoctet_del,  cur_msoctet_del,cur_lsoctet_del})
                5'b1_?0_01: begin
                   wr_del_sm        <= WR_ADD_NXT_DAT; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_msd};    // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_msc};    // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd1;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd1;
                   end
                end
                5'b1_?0_10: begin
                   wr_del_sm        <= WR_ADD_NXT_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_lsd};    // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_lsc};    // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd1;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd1;
                   end
                end
                5'b1_01_01: begin
                   wr_del_sm        <= WR_ADD_NULL_DAT; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_msd};    // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_msc};    // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd2;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd2;
                   end
                end
                5'b1_01_10: begin
                   wr_del_sm        <= WR_ADD_NULL_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_lsd};    // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_lsc};    // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd2;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd2;
                   end
                end
                5'b1_11_01: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b0;
                   store_lsd        <= cur_data_in_msd; // Data Bits
                   store_lsc        <= cur_data_in_msc; // Data Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd1;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd1;
                   end
                end
                5'b1_11_10: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b0; 
                   store_lsd        <= cur_data_in_lsd; // Data Bits
                   store_lsc        <= cur_data_in_lsc; // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd1;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd1;
                   end
                end
                5'b1_??_11: begin
                   wr_del_sm        <= WR_IDLE;
                   wr_en            <= 1'b0;
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd2;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd2;
                   end
                end
                default: begin
                   wr_del_sm        <= WR_IDLE;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd    , cur_data_in_lsd};    // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {cur_data_in_msc    , cur_data_in_lsc};    // Control Bits
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
                   end
                   else begin
                       octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                       octet_del_counter <= octet_del_counter - 7'd1;
                   end
                end
              endcase
           end
           WR_ADD_NXT_DAT: begin 
              casez({wr_pfull,nx0_msoctet_del,nx0_lsoctet_del,cur_msoctet_del})
                4'b1_?_01: begin
                   wr_del_sm        <= WR_IDLE; 
                   wr_en            <= 1'b0;
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd1;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd1;
                   end
                end
                4'b1_0_10: begin
                   wr_del_sm        <= WR_ADD_NULL_DAT; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_msd    , cur_data_in_msd};    // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {nx0_data_in_msc    , cur_data_in_msc};    // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd1;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd1;
                   end
                end
                4'b1_1_10: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b0;
                   store_lsd        <= cur_data_in_msd; // Data Bits
                   store_lsc        <= cur_data_in_msc; // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
                   end
                   else begin
                       octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                   end
                end
                4'b1_0_11: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b0;
                   store_lsd        <= cur_data_in_msd; // HN
                   store_lsc        <= cur_data_in_msc; // HN
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
                   end
                   else begin
                       octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                   end
                end
                4'b1_1_11: begin
                   wr_del_sm        <= WR_ADD_NULL_DAT; 
                   wr_en            <= 1'b0;
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd3;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd3;
                   end
                end
                default: begin
                   wr_del_sm        <= WR_ADD_NXT_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {nx0_data_in_lsd    , cur_data_in_msd};    // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {nx0_data_in_lsc    , cur_data_in_msc};    // Control Bits
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
                   end
                   else begin
                       octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                       octet_del_counter <= octet_del_counter - 7'd1;
                   end
                end
              endcase
           end
           WR_ADD_STOR_DAT: begin
              case({wr_pfull,cur_msoctet_del,cur_lsoctet_del})
                3'b1_01: begin
                   wr_del_sm        <= WR_IDLE; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd , store_lsd}; // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {cur_data_in_msc , store_lsc}; // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd1;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd1;
                   end
                end
                3'b1_10: begin
                   wr_del_sm        <= WR_IDLE; 
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd1;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd1;
                   end
                end
                3'b1_00: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
                   store_lsd        <= cur_data_in_msd;               // Data Bits
                   store_lsc        <= cur_data_in_msc;               // Control Bits
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
                   end 
                   else begin
                       octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                       octet_del_counter <= octet_del_counter - 7'd1;
                   end
                end
                3'b1_11: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b0;
                   octet_del_counter   <= COUNTER_MAX;
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= 4'd2;
                   end
                   else begin
                       octet_del_num    <= octet_del_num + 4'd2;
                   end
                end
                default: begin
                   wr_del_sm        <= WR_ADD_STOR_DAT;
                   wr_en            <= 1'b1;
                   wr_data[PCSDWIDTH-1:0] <= {cur_data_in_lsd , store_lsd}; // Data Bits
                   wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {cur_data_in_lsc , store_lsc}; // Control Bits
                   store_lsd        <= cur_data_in_msd;               // Data Bits
                   store_lsc        <= cur_data_in_msc;               // Control Bits
                   if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                       octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
                   end
                   else begin
                       octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                       octet_del_counter   <= octet_del_counter - 7'd1;
                   end
                end
                
              endcase
           end
           WR_ADD_NULL_DAT: begin 
              wr_del_sm        <= WR_IDLE; 
              wr_en            <= 1'b0;
              if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                  octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
              end
              else begin
                  octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}}; 
                  octet_del_counter   <= octet_del_counter - 7'd1;
              end 
           end
           
           default: begin
              wr_del_sm        <= WR_IDLE;
              wr_en            <= 1'b1;
              wr_data[PCSDWIDTH-1:0] <= {cur_data_in_msd    , cur_data_in_lsd};    // Data Bits
              wr_data[FDWIDTH-3-RM_TOTAL_WIDTH: PCSDWIDTH]<= {cur_data_in_msc    , cur_data_in_lsc};    // Control Bits
              if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                  octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
              end
              else begin
                  octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                  octet_del_counter   <= octet_del_counter - 7'd1;
              end 
           end
           
         endcase
      end
      else begin
        wr_en            <= 1'b0;
        if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
            octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
        end
        else begin
            octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
            octet_del_counter   <= octet_del_counter - 7'd1;
        end
      end
   end



// 10G BaseR Deletion Flag
//   assign fifo_del_comb = (wr_en != cur_data_valid_in) ? 1'b1 : 1'b0;
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         fifo_del  	<= 1'b0;
      end
//      else if (wr_en != cur_data_valid_in) begin
//         fifo_del  	<= 1'b1;
//      end
//      else if (cur_data_valid_in) begin
//         fifo_del  	<= 1'b0;
//      end
//   end     
// Bug fix: de-assert fifo_del after it's has been written to FIFO
//      else if (block_lock_lt) begin
//         fifo_del  	<= (wr_en != cur_data_valid_in);
//      end
//   end
      else if (block_lock_lt) begin 
        if (fifo_del && !wr_en) begin
	      fifo_del <= 1'b1;
	   end
        else if (wr_en != cur_data_valid_in || (wr_en & wr_full) ) begin
            fifo_del  	<= 1'b1; 
        end
        else begin 
            fifo_del  	<= 1'b0;      
        end
     end
   end   
   
   // Attach block lock and deletion flag to write data  
   assign wr_data_10g = {wr_del_sm[RM_SM_WIDTH-1:0], octet_del_num, block_lock_lt, fifo_del, wr_data[FDWIDTH-3-RM_TOTAL_WIDTH:0]};
   assign wr_data_10g_w = {2'b00, wr_del_sm[RM_SM_WIDTH-1:0], octet_del_num, wr_data[FDWIDTH-3-RM_TOTAL_WIDTH:0]};
   
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
         insert_after	<= 1'b0;
         insert_between	<= 1'b0;
         keep_insert		<= 1'b0;
      end
      else begin
        if (data_valid_out) begin
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
                 insert_after	<= 1'b0;
                 insert_between	<= 1'b0;
                 keep_insert		<= 1'b0;
                 
                 if(|ch_insert && rd_pempty) begin
                    rd_add_sm        <= RD_INSERT; 
                    rd_en_10g            <= 1'b0;
                     
                    // Data insertion logic
                    casez(ch_insert)
                       2'b1?: begin // When UW is Idle/OS
                          insert_after	<= 1'b1;
                       end
                       2'b01: begin // When LW is Idle/OS	
                          insert_between	<= 1'b1;
                       end
                       default: begin
                          insert_after	<= 1'b0;
                          insert_between	<= 1'b0;
                       end
                    endcase
                 end
                 else begin
		            rd_add_sm        <= RD_ENABLE; 
		            rd_en_10g            <= 1'b1;
                 end
              end 
              
              
              RD_INSERT: begin

                 keep_insert		<= 1'b0;

                 if (rd_pempty && r_truebac2bac) begin
                    rd_add_sm        <= RD_INSERT;
                    rd_en_10g            <= 1'b0;
                    keep_insert		<= 1'b1;
                   
                 end
                 else if (insert_after) begin
                    rd_add_sm        <= RD_ENABLE;
                    rd_en_10g            <= 1'b1;
                 end   
                 else if (insert_between) begin
                    rd_add_sm        <= RD_ENABLE;
                    rd_en_10g            <= 1'b1;
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
      d_out              <= FIFO_DEFAULT;      
      octet_ins_num      <= {RM_DEL_INS_WIDTH{1'b0}};
      octet_ins_num_hold <= {RM_DEL_INS_WIDTH{1'b0}};
      octet_ins_counter  <= {COUNTER_WIDTH{1'b0}};
      octet_ins_en       <= 1'b0;
   end
// Must use rd_val_d0 as "data_valid" cause rd_add_sm operates on rd_vald
   else if (data_valid_out) begin
      if (rd_add_sm_reg==RD_IDLE) begin
         if (~rd_pempty && ~first_read) begin
            d_out         <= fifo_out;
         end
         else begin         
            d_out         <= FIFO_DEFAULT;
         end
         octet_ins_num         <= octet_ins_num_hold;
         if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
            octet_ins_num_hold  <= {RM_DEL_INS_WIDTH{1'b0}};
            octet_ins_en        <= 1'b0;
         end
         else begin
            octet_ins_num_hold  <= octet_ins_num_hold + {RM_DEL_INS_WIDTH{1'b0}};
            octet_ins_counter   <= octet_ins_counter - 7'd1;
         end 
      end  
      
      else if (rd_add_sm_reg==RD_ENABLE) begin
         // Insert after when UW is Idle/OS
         if (insert_after) begin
            d_out                <= fifo_out;
            octet_ins_num         <= octet_ins_num_hold;
            if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
               octet_ins_num_hold  <= {RM_DEL_INS_WIDTH{1'b0}};
               octet_ins_en        <= 1'b0;
            end
            else begin
               octet_ins_num_hold  <= octet_ins_num_hold + {RM_DEL_INS_WIDTH{1'b0}};
               octet_ins_counter   <= octet_ins_counter - 7'd1;
            end
         end
         // Insert after when LW is Idle/OS and UW is not
         else if (insert_between) begin
            d_out               <=      {fifo_out[FDWIDTH-1:72] ,4'hF, fifo_out[67:64], XGMII_IDLE_WORD, fifo_out[31:0]};
            octet_ins_counter   <= COUNTER_MAX;
            octet_ins_en        <= 1'b1;
            octet_ins_num       <= {RM_DEL_INS_WIDTH{1'b0}};
            if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
               octet_ins_num_hold  <= 4'd2;
            end
            else begin
               octet_ins_num_hold  <= octet_ins_num_hold + 4'd2; // 1 octet insert in RD_ENABLE, another octet insert in next cycle RD_INSERT
            end 
         end
         else begin
            d_out                 <= fifo_out;
            octet_ins_num         <= octet_ins_num_hold;
            if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
               octet_ins_num_hold  <= {RM_DEL_INS_WIDTH{1'b0}};
               octet_ins_en        <= 1'b0;
            end
            else begin
               octet_ins_num_hold  <= octet_ins_num_hold + {RM_DEL_INS_WIDTH{1'b0}};
               octet_ins_counter   <= octet_ins_counter - 7'd1;
            end
         end            
      end
      
      else if (rd_add_sm_reg==RD_INSERT) begin
         if (keep_insert) begin
            d_out                 <= {6'd0,2'b10,8'hFF,{2{XGMII_IDLE_WORD}}};
            octet_ins_counter   <= COUNTER_MAX;
            octet_ins_en        <= 1'b1;
            octet_ins_num       <= {RM_DEL_INS_WIDTH{1'b0}};
            if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
               octet_ins_num_hold  <= 4'd2;
            end
            else begin
               octet_ins_num_hold  <= octet_ins_num_hold + 4'd2;
            end 
         end
         else if (insert_after) begin 
            d_out                 <= {6'd0,2'b10,8'hFF,{2{XGMII_IDLE_WORD}}};
            octet_ins_counter   <= COUNTER_MAX;
            octet_ins_en        <= 1'b1;
            octet_ins_num       <= {RM_DEL_INS_WIDTH{1'b0}};
            if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
               octet_ins_num_hold  <= 4'd2;
            end
            else begin
               octet_ins_num_hold  <= octet_ins_num_hold + 4'd2;
            end 
         end
         else if (insert_between) begin
            d_out                 <= {fifo_out[FDWIDTH-1:68], 4'hF, fifo_out[63:32], XGMII_IDLE_WORD};
            octet_ins_num         <= octet_ins_num_hold;
            if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
               octet_ins_num_hold  <= {RM_DEL_INS_WIDTH{1'b0}};
               octet_ins_en        <= 1'b0;
            end
            else begin
               octet_ins_num_hold  <= octet_ins_num_hold + {RM_DEL_INS_WIDTH{1'b0}}; // already handled in RD_ENABLE
               octet_ins_counter   <= octet_ins_counter - 7'd1;
            end
         end
         else begin
            d_out                 <= fifo_out;
            octet_ins_num         <= octet_ins_num_hold;
            if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
               octet_ins_num_hold  <= {RM_DEL_INS_WIDTH{1'b0}};
               octet_ins_en        <= 1'b0;
            end
            else begin
               octet_ins_num_hold  <= octet_ins_num_hold + {RM_DEL_INS_WIDTH{1'b0}};
               octet_ins_counter   <= octet_ins_counter - 7'd1;
            end
         end
       
      end  
      
   end
end


always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
//      ch_insert_reg	 <= 'd0;
      rd_add_sm_reg	 <= RD_IDLE;
   end
   else begin
//      ch_insert_reg	 <= ch_insert;
      rd_add_sm_reg	 <= rd_add_sm;
   end
end   


// 10G BaseR insertion flag
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         fifo_insert_pre	<= 1'b0;      
         fifo_insert		<= 1'b0;      
      end
      else begin
         fifo_insert_pre	<= (insert_after && (rd_add_sm_reg==RD_INSERT)) || insert_between ;      
         fifo_insert		<= fifo_insert_pre;      
      end
   end 
   
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_en_lt	<= 1'b0;      
      end
      else begin
         rd_en_lt	<= rd_en_int || rd_en_lt;      
      end
   end 


   // Output Register and Bypass Logic
   // 1588 ctrl bits should not be sent out
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         data_valid_out     <= 1'b0;
         data_out           <= FIFO_DATA_DEFAULT;
         control_out		 <= FIFO_CTRL_DEFAULT[PCSRXCWIDTH-1:0]; //exclude 1588 control bit
      end
      else if (register_mode == 1'b1) begin
         data_valid_out     <= data_valid_in_pre;
         data_out           <= data_in_pre;
         control_out		 <= control_in_pre;
      end
      // Output LF when FIFO is empty
      else if (rd_empty) begin
         data_valid_out     <= 1'b0;
         data_out           <= FIFO_DATA_DEFAULT;
         control_out		 <= FIFO_CTRL_DEFAULT[PCSRXCWIDTH-1:0]; //exclude 1588 control bit
      end
// 10G Base-R clock Comp
// Fix iTrack 73441
//      else if (clkcomp_mode) begin
//         data_valid_out     <= 1'b1;
//         {control_out, data_out}           <= rd_en_lt ? (basic_clkcomp_mode ? d_out_basic : d_out) : {control_out, data_out};
// exclude 1588's rate match control bit
      else if (clkcomp_mode) begin
         if (rd_srst_n == 1'b0) begin
            data_valid_out     <= 1'b0;
            data_out           <= FIFO_DATA_DEFAULT;
            control_out		 <= FIFO_CTRL_DEFAULT;
         end   
	 else begin
            data_valid_out     <= 1'b1;
            {control_out, data_out}           <= rd_en_lt ? (basic_clkcomp_mode ? d_out_basic[FDWIDTH-RM_TOTAL_WIDTH-1:0] : d_out[FDWIDTH-RM_TOTAL_WIDTH-1:0]) : {control_out, data_out}; //exclude 1588 control bit
	 end   
      end 
// Interlaken mode and Phase Comp mode
// Use rd_en to gate data_out and generate data_valid_out
      else begin
         data_valid_out     <= rd_en_int ? 1'b1: 1'b0;
         {control_out, data_out}           <= rd_en_int ? fifo_out[FDWIDTH-RM_TOTAL_WIDTH-1:0]: {control_out, data_out}; //exclude 1588 control bit
      end
   end
   

// Phase Comp FIFO mode Write/Read enable logic generation
// Write Enable
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
     phcomp_wren_d0 <= 1'b0;
     phcomp_wren_d1 <= 1'b0;
   end
   else begin
     phcomp_wren_d0 <= 1'b1;
     phcomp_wren_d1 <= phcomp_wren_d0;
   end
end

assign phcomp_wren = phcomp_wren_d1;

// Synchronizer
   alt_mge16_pcs_std_synchronizer
     #(
       .depth   (2)     // Sync stages
       )
       bitsync_phcomp_wren
         (
          .clk      (rd_clk),
          .reset_n  (rd_rst_n),
          .din      (phcomp_wren),
          .dout     (phcomp_wren_sync)
          );

// Read Enable
// assign phcomp_rden = phcomp_wren_sync;
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
     phcomp_rden_d0 <= 1'b0;
   end
   else begin
//     phcomp_rden_d0 <= ~rd_pempty || phcomp_rden_d0;
     phcomp_rden_d0 <= phcomp_rden;
   end
end

assign phcomp_rden = ~rd_pempty || phcomp_rden_d0;

   
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Interlaken Deskew FIFO										   //	
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
   
   // ****************************************************** 
   // structural_code
   
   // Determine what control words shall be deleted
   assign     ctrl_del = |(control_in_pre & r_mask_del);
   
   // TODO Add capability for overflow and underflow (corruption of data)
   
   //********************************************************************
   // WRITE CLOCK DOMAIN: Synchronize data from Read Clock to Write Clock
   //********************************************************************
   // Sync the wr_align_clr
   // TODO Determine if bit sync is the best. Concern about missing short pulse
   alt_mge16_pcs_std_synchronizer
     #(
       .depth   (2)    // Sync stages
       ) 
       bitsync_clr
         (
          .clk      (wr_clk),
          .reset_n  (wr_rst_n),
          .din      (rd_align_clr),
          .dout     (wr_align_clr)
          );
   
   // Sync the align_en
   alt_mge16_pcs_std_synchronizer
     #(
       .depth   (2)    // Sync stages
       ) 
       bitsync_active
         (
          .clk      (wr_clk),
          .reset_n  (wr_rst_n),
          .din      (rd_align_en),
          .dout     (wr_align_en)
          );
   
   
   //********************************************************************
   // Sync the wr_align_val
   //********************************************************************
   alt_mge16_pcs_std_synchronizer
     #(
       .depth   (2)    // Sync stages
       ) 
       bitsync_val
         (
          .clk      (rd_clk),
          .reset_n  (rd_rst_n),
          .din      (wr_align_val),
          .dout     (rd_align_val)
          );
   
   assign     wr_word_del = data_valid_in_pre & ~wr_fifo_en;
   
//   hd_dpcmn_bitsync2
//     #(
//       .DWIDTH      (1)    // Sync Data input
//       ) 
//       hd_dpcmn_bitsync2_del
//         (
//          .clk      (rd_clk),
//          .rst_n    (rd_rst_n),
//          .data_in  (wr_word_del),
//          .data_out (rd_word_del)
//          );
   
   //********************************************************************
   // The following implements a ASYNC FIFO since  
   // clocks used for write & read are different 
   // Write only if data_valid_in is active
   //********************************************************************
   
   // Write enable is not asserted with FIFO is full 
   
//   hd_dpcmn_bitsync2
//     #(
//       .DWIDTH      (1)    // Sync Data input
//       ) 
//       hd_dpcmn_bitsync2_oflw
//         (
//          .clk      (rd_clk),
//          .rst_n    (rd_rst_n),
//          .data_in  (wr_oflw_err),
//          .data_out (rd_oflw_err)
//          );

   // Block Lock sync
   alt_mge16_pcs_std_synchronizer
     #(
       .depth   (2)    // Sync stages
       ) 
       bitsync_block_lock
         (
          .clk      (rd_clk),
          .reset_n  (rd_rst_n),
          .din      (block_lock),
          .dout     (block_lock_sync)
          );

// FIFO sync reset
// Interlaken Generic: reset with rd_align_clr
// Clock comp: reset by block lock or not (depends on r_write_ctrl)
// Other: not allowed
   assign     wr_srst_n    = intl_generic_mode ? ~wr_fifo_clr : clkcomp_mode ? (block_lock || r_write_ctrl) : 1'b1; 
   assign     rd_srst_n    = intl_generic_mode ? ~rd_align_clr : clkcomp_mode ? (block_lock_sync || r_write_ctrl) : 1'b1; 
   
   
   // ****************************************************** 
   // procedural_code
   
   //********************************************************************
   // Dskew FIFO write logic.
   // r_align_del : 1 for 40g/100g
   //             : 0 for interlaken  
   // 40g/100g:
   // This logic waits for the first Alignment Marker to be received before
   // setting a flag "wr_align_val". When the "wr_align_val" flag is set all 
   // data is written into the fifo except the alignment markers.
   // Interlaken:
   // This logic waits for first alignment marker to be received. when it is 
   // recieved all data is written into fifo including alignment 
   // marker data (start of payload data)  
   //********************************************************************
   // combinational_block
// Gate wr_align_mark with frame_lock signal
assign	wr_align_mark_int	=	control_in_pre[CTL_SYNC] & data_valid_in_pre & control_in_pre[CTL_BFL];

// Interlaken generic mode, FIFO write enable signal asserts when data_valid_in is high & wr_fifo_en
// Non-Interlaken (basic) generic mode, FIFO write enable signal asserts when data_valid_in is high
assign wr_fifo_en_int = basic_generic_mode ? data_valid_in_pre: wr_fifo_en & data_valid_in_pre; 

// Same Clock Freq phase comp mode, FIFO write enable signal asserts every cycle
// Diff Clock Freq phase comp mode, FIFO write enable signal asserts when data_valid_in is high
// assign phcomp_wren_int = same_clk_phcomp_mode ? phcomp_wren : phcomp_wren & data_valid_in;
assign phcomp_wren_int = same_clk_phcomp_mode ? phcomp_wren : data_valid_in_pre;

   always @* begin
      // comb_defaults
      nxt_wr_align_val  = wr_align_val;
      nxt_wr_fifo_clr   = wr_fifo_clr;
      wr_fifo_en = 1'b0;
      begin 
         // mainline_code
         
         // Write Clock Domain 
         if (wr_align_clr == 1'b1 || wr_align_en == 1'b0) begin
            // Clear the FIFO if not locked, or val_cr or if not active
            nxt_wr_align_val  = 1'b0;
            wr_fifo_en    = 1'b0;
            nxt_wr_fifo_clr   = 1'b1;
         end else if (wr_align_mark_int || r_force_align) begin
            // Store the first Alignment Pattern received
            // TODO Concern about the requirement of deletion
            nxt_wr_align_val  = 1'b1;
            if (r_align_del) begin 
               // Delete the align if enabled
               wr_fifo_en  = 1'b0;
            end else begin
               wr_fifo_en  = 1'b1;
            end
            nxt_wr_fifo_clr = 1'b0; 
         end else if (wr_align_val) begin
            // Write data in if previously an Alignment Pattern was found
            if (ctrl_del) begin 
               // TODO Add capability to carry error info to next valid cycle
               // Delete specific ctrl words
               wr_fifo_en   = 1'b0; 
            end else begin
               wr_fifo_en   = 1'b1; 
            end
            nxt_wr_fifo_clr   = 1'b0; 
         end else begin
            // Do not write if no Alignment Pattern was found previously 
            wr_fifo_en = 1'b0; 
            nxt_wr_fifo_clr = 1'b0; 
         end
      end
   end
   
   always @* begin
      // comb_defaults
      nxt_rd_val = rd_val;
      nxt_rd_val_d1 = rd_val_d1;
      begin 
         // mainline_code
         
         // Read Clock Domain
         if (rd_en && ~rd_empty) begin
            nxt_rd_val = 1'b1;
         end else begin
            nxt_rd_val = 1'b0;
         end
         nxt_rd_val_d1 = rd_val;
      end
   end
   
   // sequential_block
   always @(posedge wr_clk, negedge wr_rst_n) begin
      if (!wr_rst_n) begin
         // flop_defaults
         wr_align_val <= 1'b0;  
         wr_fifo_clr <= 1'b1; 
      end else begin 
         // flop_assigns
         wr_align_val <= nxt_wr_align_val;  
         wr_fifo_clr <= nxt_wr_fifo_clr; 
      end
   end
   
   always @(posedge rd_clk, negedge rd_rst_n) begin
      if (!rd_rst_n) begin
         // flop_defaults
         rd_val <= 1'b0;
         rd_val_d1 <= 1'b0;
      end else begin 
         // flop_assigns
         rd_val <= nxt_rd_val;
         rd_val_d1 <= nxt_rd_val_d1;
      end
   end

//////////////////////////////////////////////////////////////////////////////////
// Basic Clock Comp
//////////////////////////////////////////////////////////////////////////////////

// Detect deletion pattern
assign	wr_pat_match_basic = (gb_odwidth == 'd64) ? (data_in_pre == r_skip_word) : 						// 64-bit
                             (gb_odwidth == 'd66) ? ({data_in_pre, control_in_pre[2:0]} == {r_skip_word, r_skip_ctrl}) :	// 67-bit
                             ({data_in_pre, control_in_pre[1:0]} == {r_skip_word, r_skip_ctrl[1:0]});				// 66-bit

// Basic Write SM
   always @(posedge wr_clk, negedge wr_rst_n) begin
     if (!wr_rst_n) begin
       wr_del_sm_basic <= WR_IDLE_BASIC;
       wr_en_basic 		<= 1'b0;
       wr_data_basic	<= FIFO_DEFAULT;
     end
     else if (data_valid_in_pre) begin
       case(wr_del_sm_basic)
         WR_IDLE_BASIC: begin
           if (!block_lock) begin
             wr_del_sm_basic <= WR_IDLE_BASIC;
             wr_en_basic 		<= 1'b0;
             wr_data_basic	<= FIFO_DEFAULT;
           end
           else begin
             wr_del_sm_basic <= WR_ENABLE_BASIC;
             wr_en_basic 		<= 1'b1;
             wr_data_basic	<= wr_data_in;
           end
         end
         WR_ENABLE_BASIC: begin
           if (wr_pat_match_basic && wr_pfull) begin
             wr_del_sm_basic <= WR_IDLE_BASIC;
             wr_en_basic 		<= 1'b0;
           end
           else begin
             wr_del_sm_basic <= WR_ENABLE_BASIC;
             wr_en_basic 		<= 1'b1;
             wr_data_basic	<= wr_data_in;
           end
         end
         default: begin
             wr_del_sm_basic <= WR_ENABLE_BASIC;
             wr_en_basic 		<= 1'b1;
             wr_data_basic	<= wr_data_in;
         end
       endcase
     end
   end  
              

// Detect insertion pattern
assign	rd_pat_match_basic = (gb_odwidth == 'd64) ? (fifo_out[63:0] == r_skip_word) : 					// 64-bit
                             (gb_odwidth == 'd67) ? (fifo_out[66:0] == {r_skip_word, r_skip_ctrl}) :	// 67-bit
                             (fifo_out[65:0] == {r_skip_word, r_skip_ctrl[1:0]});			// 66-bit
                          

// Basic Read SM
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_add_sm_basic          <= RD_IDLE;
         rd_en_basic              <= 1'b0;
         insert_after_basic	<= 1'b0;
      end
      else begin
        if (data_valid_out) begin
            case(rd_add_sm_basic)
              RD_IDLE: begin
                 if (~rd_pempty && ~first_read) begin
                    rd_add_sm_basic      <= RD_ENABLE;
                    rd_en_basic          <= 1'b1;
                 end  
                 else begin
                    rd_add_sm_basic      <= RD_IDLE;
                    rd_en_basic          <= 1'b0;
                 end      
              end
              RD_ENABLE: begin
                 insert_after_basic	<= 1'b0;
                 if(rd_pat_match_basic && rd_pempty) begin
                    rd_add_sm_basic        <= RD_INSERT; 
                    rd_en_basic            <= 1'b0;
		    insert_after_basic	<= 1'b1;
                 end
                 else begin
		    rd_add_sm_basic        <= RD_ENABLE; 
		    rd_en_basic            <= 1'b1;
                 end
              end 
              RD_INSERT: begin
                 if (rd_pempty && r_truebac2bac) begin
                    rd_add_sm_basic        <= RD_INSERT;
                    rd_en_basic            <= 1'b0;
                 end
                 else begin
                    rd_add_sm_basic        <= RD_ENABLE;
                    rd_en_basic            <= 1'b1;
                 end   
                                       
              end
              default: begin
                 rd_add_sm_basic      <= RD_IDLE;
                 rd_en_basic          <= 1'b1;
              end
            endcase
            
         end   
         
         else begin
            rd_en_basic              <= 1'b0;
         end
         
      end         
   end

always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      rd_add_sm_basic_reg	 <= RD_IDLE;
   end
   else begin
      rd_add_sm_basic_reg	 <= rd_add_sm_basic;
   end
end   

// Insertion based on rd_add_sm_basic
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      d_out_basic         	<= FIFO_DEFAULT;      
   end
   else if (data_valid_out) begin
      if (rd_add_sm_basic_reg==RD_IDLE) begin
        if (~rd_pempty && ~first_read)
          d_out_basic	  	<= fifo_out;
        else         
          d_out_basic	  	<= FIFO_DEFAULT;
      end  
      else if (rd_add_sm_basic_reg==RD_ENABLE) begin
	  d_out_basic         	<= fifo_out;
      end          
      else if (rd_add_sm_basic_reg==RD_INSERT) begin
        if (insert_after_basic)
          d_out_basic         	<= {7'b100_0000, r_skip_ctrl, r_skip_word};
        else
          d_out_basic         	<= fifo_out;
      end  
   end
end

// Testbus
assign testbus1 =	{cur_msoctet_term, cur_lsoctet_term, cur_msoctet_os, cur_lsoctet_os, cur_msoctet_del, cur_lsoctet_del, wr_empty, wr_pempty, wr_full, wr_pfull , wr_word_del,  wr_numdata, wr_del_sm[1:0], wr_en_int, fifo_del};
assign testbus2 =	{9'd0, rd_numdata, rd_add_sm, rd_en_int, insert_after, insert_between, keep_insert};

   
endmodule // alt_mge_phy_xgmii_rx_fifo

