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


//------------------------------------------------------------------------
// This is a 32-bit rate match FIFO designed for 10G-Base-R (N-BaseT mode),
// it is a modified version of typical 64-bit rate match FIFO found in 
// hard 10G PCS. Back-to-back insertion is turned on by default.
// 1588 logics are reserved in comment for future implementation.
//------------------------------------------------------------------------

`timescale 1 ps / 1 ps

module alt_mge_phy_usxg32_rx_rm_fifo #(
    parameter DATA_WIDTH        = 'd32,     // PCS data width
    parameter CONTROL_WIDTH     = 'd4,      // PCS control width
    parameter FAWIDTH           = 'd5,      // FIFO Depth (address width)
    parameter TSWIDTH           = 'd16,
    parameter IDWIDTH           = 'd40,     // PCS/PMA IF width
    parameter DEVICE_FAMILY     = "Arria V",
    parameter ENABLE_IEEE1588   = 0,
    parameter OFFSET            = 16'h283D  // PCS latency
) (
    input  wire                     wr_rst_n,               // Write Domain Active low Reset
    input  wire                     rd_rst_n,               // Read Domain Active low Reset
    input  wire                     sample_rst_n,           // Sample Active low Reset
    input  wire                     wr_clk,                 // Write Domain Clock
    input  wire                     rd_clk,                 // Read Domain Clock
    input  wire                     sample_clk,             // Sample Clock
    input  wire [CONTROL_WIDTH-1:0] control_in,             // Frame information 
    input  wire [DATA_WIDTH-1:0]    data_in,                // Write Data In
    input  wire                     data_valid_in,          // Write Data In Valid
    input  wire                     block_lock_in,          // Block Lock In (aligned to data_in)
    input  wire [FAWIDTH-1:0]       r_pempty,               // FIFO partially empty threshold
    input  wire [FAWIDTH-1:0]       r_pfull,                // FIFO partially full threshold
    input  wire [FAWIDTH-1:0]       r_empty,                // FIFO empty threshold
    input  wire [FAWIDTH-1:0]       r_full,                 // FIFO full threshold
    //input  wire                     r_truebac2bac,          // Back-2-back insertion/deletion
    input  wire                     r_write_ctrl,           // RX FIFO clock comp mode write option
    input  wire                     rd_req,                 // control FIFO read rate

    output wire [CONTROL_WIDTH-1:0] control_out,            // Frame information
    output wire [DATA_WIDTH-1:0]    data_out,               // Read Data Out
    output wire                     data_valid_out,         // Read Data Out Valid
    output wire                     block_lock_out,         // Block Lock Out (aligned to data_out)
    output wire                     rd_empty,               // Read empty
    output wire                     rd_pempty,              // Read partial empty
    output wire                     rd_pfull,               // Read partial full 
    output wire                     wr_oflw_err,            // Overflow error
    output wire [TSWIDTH-1:0]       latency_adj,            // Latency Measurement (6-bit cycle, 10-bit frac. cycle)
    // ED
    input  wire [2:0]               speed_mode,             // control FIFO read rate
    //output wire [TSWIDTH-1:0]       latency_adj,            // Latency Measurement (6-bit cycle, 10-bit frac. cycle)
    input  wire                     latency_sclk,
    input  wire                     latency_sclk_reset,
    input  wire [11:0]              latency_xcvr_rx,
    output reg                      fifo_insert,            // 10G BaseR Insertion Flag
    output reg                      fifo_del                // 10G BaseR Insertion Flag (Async)

 );
    
    
    // Define Parameters 
    //import alt_mge_phy_xgmii_params::*;
    ///////////////////////////////////////////////////////////////////////////////
    // Start of import
    ///////////////////////////////////////////////////////////////////////////////
    // 10G, 40G & 100G  Ethernet Parameters
    // Spec Definitions
    // MII Control Characters - Unencoded
    localparam              XGMII_IDLE      = 8'h07;
    localparam              XGMII_START     = 8'hfb;
    localparam              XGMII_TERM      = 8'hfd;
    localparam              XGMII_ERROR     = 8'hfe;
    localparam              XGMII_SEQOS     = 8'h9c;
    localparam              XGMII_RES0      = 8'h1c;
    localparam              XGMII_RES1      = 8'h3c;
    localparam              XGMII_RES2      = 8'h7c;
    localparam              XGMII_RES3      = 8'hbc;
    localparam              XGMII_RES4      = 8'hdc;
    localparam              XGMII_RES5      = 8'hf7;
    localparam              XGMII_SIGOS     = 8'h5c;
    
    localparam              RD_IDLE         = 2'd0;
    localparam              RD_ENABLE       = 2'd1;
    localparam              RD_INSERT       = 2'd2;
    
    localparam              XGMII_IDLE_WORD     = {4{XGMII_IDLE}};
    
    localparam              FIFO_DATA_DEFAULT   = {8'h1,8'h0,8'h0,XGMII_SEQOS};
    localparam              FIFO_CTRL_DEFAULT   = 4'h1;
    localparam              FIFO_BLOCK_LOCK_DEFAULT = 1'b0;
    localparam              FIFO_1588_DEFAULT   = 6'h0;
    localparam              FIFO_DEFAULT        = {FIFO_1588_DEFAULT, FIFO_BLOCK_LOCK_DEFAULT, FIFO_CTRL_DEFAULT, FIFO_DATA_DEFAULT};  
    
    // 1588 Rate Match Case Parameter
    // localparam             RM_SM_WIDTH         = 2;
    localparam              RM_DEL_INS_WIDTH    = 4;
    localparam              RM_TOTAL_WIDTH      = ENABLE_IEEE1588 ? RM_DEL_INS_WIDTH : 0; // see FIFO_1588_DEFAULT
    //localparam              RM_TOTAL_WIDTH      = 0; // remove 1588 data temporarily
    localparam              COUNTER_WIDTH       = 11;
     
    //ED need review value, probably set to 40?
    localparam              COUNTER_MAX         = 10'd150; //2 x sampling window size 66 + max possible insertion ~4 + lat_adj clock crossing delay 5
                                                           // COUNTER_MAX set to bigger number than required contributes not much error.
                                                           // insertion case needs about 141. delete case needs about 55.
    localparam              COUNTER_MAX_1G      = 10'd350; //2 x sampling window size 165 + max possible insertion ~4 + lat_adj clock crossing delay 5
    localparam              COUNTER_MAX_100M    = 11'd1690;//2 x sampling window size 825 + max possible insertion ~4 + lat_adj clock crossing delay 5
    // FIFO Data Width = Data Width + Control Width + 1-bit Block Lock + 1588 bits
    localparam              FDWIDTH = DATA_WIDTH + CONTROL_WIDTH + RM_TOTAL_WIDTH + 1;
    wire [10:0] COUNTER_MAX_SEL ;
    assign COUNTER_MAX_SEL = ((speed_mode == 3'b000) || (speed_mode == 3'b101) || (speed_mode == 3'b100))? COUNTER_MAX : 
                             ((speed_mode == 3'b010) ? COUNTER_MAX_100M : COUNTER_MAX_1G);
    // Define variables 
    // status wires and registers
    wire [FAWIDTH-1:0]                  rd_numdata;
    wire [FAWIDTH-1:0]                  wr_numdata;
    reg  [FAWIDTH-1:0]                  wr_numdata_g;
    wire [FAWIDTH-1:0]                  wr_numdata_g_sync;
    reg  [FAWIDTH-1:0]                  wr_numdata_b;
    wire                                wr_pfull;
    wire                                wr_empty;
    wire                                wr_pempty;
    wire                                wr_full;
    wire                                rd_full;
    
    reg                                 fifo_insert_pre;
    
    wire                                block_lock_sync;
    reg                                 block_lock_lt;
    wire                                cur_block_lock;
    wire                                block_lock_int;
    wire                                rd_srst_n;
    wire                                wr_srst_n;
    wire                                data_valid_in_pre;
    reg                                 data_valid_in_reg;
    
    // Deletion Control wires and registers
    wire [CONTROL_WIDTH-1:0]	        control_in_pre;
    wire [DATA_WIDTH-1:0]	            data_in_pre;
    wire [FDWIDTH-RM_TOTAL_WIDTH-1:0]   wr_data_in;         // data+ctrl+bl
    reg  [FDWIDTH-RM_TOTAL_WIDTH-1:0]   nx0_data_in;        // data+ctrl+bl
    reg  [FDWIDTH-RM_TOTAL_WIDTH-1:0]   cur_data_in;        // data+ctrl+bl
    reg                                 nx0_data_valid_in;
    reg                                 cur_data_valid_in;
    reg                                 cur_data_valid_in_lt;
    reg                                 nx0_lsoctet_os;
    reg                                 nx0_lsoctet_idle;
    reg                                 nx0_lsoctet_term;
    reg                                 cur_lsoctet_os;
    reg                                 cur_lsoctet_idle;
    reg                                 cur_lsoctet_term;
    reg                                 cur_lsoctet_del;
    //reg                                 nx0_lsoctet_del;
    
    reg                                 wr_en;
    reg  [FDWIDTH-RM_TOTAL_WIDTH-1:0]   wr_data;            // data+ctrl+bl
    wire [FDWIDTH-1:0]                  wr_data_10g;        // data+ctrl+bl+1588
    wire [FDWIDTH-1:0]                  wr_data_10g_w;      // data+ctrl+bl+1588
    wire                                wr_en_int;
    wire [FDWIDTH-1:0]                  wr_data_in_int;     // data+ctrl+bl+1588 //43bits
    
    // Insertion Control wires and registers
    reg  [1:0]                          rd_add_sm;
    reg  [1:0]                          rd_add_sm_reg;
    wire                                rd_lw_idle;
    wire                                rd_lw_os;
    wire                                ch_insert; 
    reg                                 first_read;
    wire [FDWIDTH-1:0]                  fifo_out;
    wire [FDWIDTH-1:0]                  fifo_out_next;
    reg  [FDWIDTH-1:0]                  d_out;
    reg                                 d_out_valid;
    
    reg                                 rd_en_10g;
    wire                                rd_en_int;
    reg                                 rd_en_lt;
    reg                                 rd_req_r;
    reg                                 rd_req_r2;
    // ED
    wire [2:0]                          wr_del_sm;

    // 1588 latency measurement wires and registers
    reg                                 octet_del_en_start_wrclk;   // wr_clk
    wire                                octet_del_en_start_rdclk;   // rd_clk
    wire                                octet_del_en_end;           // rd_clk
    wire                                octet_del_en;               // rd_clk
    reg                                 octet_ins_en;               // rd_clk
    reg  [RM_DEL_INS_WIDTH-1:0]         octet_del_num;              // wr_clk
    wire [RM_DEL_INS_WIDTH-1:0]         octet_del_num_out;          // rd_clk
    //wire [RM_SM_WIDTH-1:0]              wr_del_sm_out;              // rd_clk
    reg  [RM_DEL_INS_WIDTH-1:0]         octet_ins_num;              // rd_clk
    reg  [RM_DEL_INS_WIDTH-1:0]         octet_ins_num_hold;         // rd_clk
    reg  [COUNTER_WIDTH-1:0]            octet_del_counter;          // wr_clk
    reg  [COUNTER_WIDTH-1:0]            octet_ins_counter;          // rd_clk

    reg  [CONTROL_WIDTH-1:0]            control_out_1588;           // Frame information +1 pipeline for 1588 variant
    reg  [DATA_WIDTH-1:0]               data_out_1588;              // Read Data Out
    reg                                 data_valid_out_1588;        // Read Data Out Valid
    reg                                 block_lock_out_1588;        // Block Lock Out (aligned to data_out)
    reg  [CONTROL_WIDTH-1:0]            control_out_0;              // Frame information , 0 extra pipeline for non 1588 variant
    reg  [DATA_WIDTH-1:0]               data_out_0;                 // Read Data Out
    reg                                 data_valid_out_0;           // Read Data Out Valid
    reg                                 block_lock_out_0;           // Block Lock Out (aligned to data_out)

    // FIFO mode decode
    //wire intl_generic_mode = (r_fifo_mode == 3'b001);
    //wire basic_generic_mode = (r_fifo_mode == 3'b101);
    //wire register_mode = (r_fifo_mode[1:0] == 2'b11);
    //wire diff_clk_phcomp_mode = (r_fifo_mode == 3'b000);
    //wire same_clk_phcomp_mode = (r_fifo_mode == 3'b100);
    //wire base_r_clkcomp_mode = (r_fifo_mode == 3'b010);
    //wire basic_clkcomp_mode = (r_fifo_mode == 3'b110);
    
    //wire generic_mode = intl_generic_mode || basic_generic_mode;
    //wire clkcomp_mode = base_r_clkcomp_mode || basic_clkcomp_mode;
    //wire phcomp_mode  = diff_clk_phcomp_mode || same_clk_phcomp_mode;


    //********************************************************************
    // Instantiate the Async FIFO 
    // (parameter FDWIDTH,parameter FAWIDTH,parameter FIFO_ALMFULL,parameter FIFO_ALMEMPTY)
    //********************************************************************
    alt_mge_phy_async_fifo_fpga #(
        .DWIDTH         (FDWIDTH),          // FIFO Input data width 
        .AWIDTH         (FAWIDTH),          // FIFO Depth (address width) 
        .SYNCSTAGE      (5),                // Metastable hardening stages
        .RESET_LF       (1),                // Output Local Fault 
        .FIFO_DEFAULT   (FIFO_DEFAULT)      // FIFO DEFAULT VALUE
    ) async_fifo (
        .wr_rst_n       (wr_rst_n),         // Write Domain Active low Reset
        .wr_srst_n      (wr_srst_n),        // Write Domain Active low Reset Synchronous
        .wr_clk         (wr_clk),           // Write Domain Clock
        .wr_en          (wr_en_int),        // Write Data Enable
        .wr_data        (wr_data_in_int),   // Write Data In
        .rd_rst_n       (rd_rst_n),         // Read Domain Active low Reset
        .rd_srst_n      (rd_srst_n),        // Read Domain Active low Reset Synchronous
        .rd_clk         (rd_clk),           // Read Domain Clock
        .rd_en          (rd_en_int),        // Read Data Enable
        .rd_data        (fifo_out),         // Read Data Out 
        .rd_data_next   (fifo_out_next),    // Read Data Out 
        .rd_numdata     (rd_numdata),       // Number of Data available in Read clock
        .wr_numdata     (wr_numdata),       // Number of Data available in Write clock 
        .r_pempty       (r_pempty),         // FIFO partially empty threshold   
        .r_pfull        (r_pfull),          // FIFO partially full threshold   
        .r_empty        (r_empty),          // FIFO empty threshold   
        .r_full         (r_full),           // FIFO full threshold   
        .wr_empty       (wr_empty),         // FIFO Empty
        .wr_pempty      (wr_pempty),        // FIFO Partial Empty
        .wr_full        (wr_full),          // FIFO Full
        .wr_pfull       (wr_pfull),         // FIFO Parial Full
        .rd_empty       (rd_empty),         // FIFO Empty
        .rd_pempty      (rd_pempty),        // FIFO Partial Empty
        .rd_full        (rd_full),          // FIFO Full 
        .rd_pfull       (rd_pfull)          // FIFO Partial Full 
    );
    
    assign  wr_oflw_err = data_valid_in_pre & wr_full;



    //********************************************************************
    // 1588 latency measurement
    // measure the average latency of RX-FIFO using wr_numdata
    // latency number is updated immediately when deletion/insertion occurs
    // (it takes time for latency number change to reflect in averaging output)
    // and ppm is measured using counters
    //********************************************************************
    
    genvar i;
    
    generate if((DEVICE_FAMILY == "Agilex") && ENABLE_IEEE1588) begin : GRAY_CODE_CC
        always @(posedge wr_clk) begin
            if(!wr_rst_n) begin
                wr_numdata_g <= {FAWIDTH{1'b0}};
            end
            else begin
                wr_numdata_g <= bin2gray(wr_numdata);
            end
        end
        
        for(i = 0; i < FAWIDTH; i = i + 1) begin : SYNC_LOOP
            alt_mge_phy_std_synchronizer_nocut #(
                .depth          (2),
                .turn_off_meta  (1)
            ) wr_numdata_g_sclk_sync (
                .clk            (sample_clk),
                .reset_n        (sample_rst_n),
                .din            (wr_numdata_g[i]),
                .dout           (wr_numdata_g_sync[i])
            );
        end
        
        always @(posedge sample_clk) begin
            if(!sample_rst_n) begin
                wr_numdata_b <= {FAWIDTH{1'b0}};
            end
            else begin
                wr_numdata_b <= gray2bin(wr_numdata_g_sync);
            end
        end

        always @(posedge wr_clk) begin
            if(!wr_rst_n) begin
                data_valid_in_reg <= 1'b0;
            end
            else begin
                data_valid_in_reg <= data_valid_in;
            end
        end
    end
    else begin
        always @(*) begin
            wr_numdata_b = wr_numdata;
        end
    end
    endgenerate
    
    alt_mge_phy_usxgmii_1588_latency #(
        .TX_RX              (1),                    // 1: RX FIFO (with ppm correction)
        .OFFSET             (OFFSET),               // RX PCS Offset
        .NUMDATA_WIDTH      (5),                    // the greater number out of FAWIDTH in TX & RX
        .RM_DEL_INS_WIDTH   (RM_DEL_INS_WIDTH),     // RX only - rate match latency adjustment
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .IDWIDTH            (IDWIDTH)               // RX only - ppm correction (Gearbox Input Data Width)
        
    ) alt_mge_phy_usxgmii_1588_latency (
        .sample_clk         (sample_clk),
        .sample_rst_n       (sample_rst_n),    
        .wr_clk             (wr_clk),
        .wr_rst_n           (wr_rst_n),
        .clk                (rd_clk),
        .rst_n              (rd_rst_n),
        .numdata            (wr_numdata_b),
        .octet_del_num      (octet_del_num_out),        // RX only - rate match latency adjustment
        //.wr_del_sm          (2'b00),                  // RX only - rate match latency adjustment , this seems unused for usxgmii mode, review later to remove it.
        .octet_ins_num      (octet_ins_num),            // RX only - rate match latency adjustment
        .octet_del_en       (octet_del_en),             // RX only - rate match latency adjustment
        .octet_ins_en       (octet_ins_en),             // RX only - rate match latency adjustment
        .sample_clk_data_valid  (data_valid_in),        // RX only - ppm correction (pma_clk data_valid)
        .rdclk_data_valid_out   (data_valid_out),       // valid toggle for <10G speed.
        .clk_block_lock     (block_lock_out),           // RX only - ppm correction (mac_clk block_lock/rx_data_ready)
        .latency_sclk       (latency_sclk),
        .latency_sclk_reset (latency_sclk_reset),
        .latency_xcvr       (latency_xcvr_rx),
        // ED
        .speed_mode         (speed_mode),
        .latency_adj        (latency_adj)
    );

    // rd_clk
    assign  octet_del_num_out = ENABLE_IEEE1588 ? fifo_out[FDWIDTH-1:FDWIDTH-RM_DEL_INS_WIDTH] : 4'd0;
    // assign  wr_del_sm_out     = fifo_out[FDWIDTH-1:FDWIDTH-RM_SM_WIDTH];
    assign  octet_del_en_end  = (octet_del_num_out == 4'd0) ? 1'b0 : 1'b1;
    assign  octet_del_en      = octet_del_en_start_rdclk | octet_del_en_end;
    
    // wr_clk
    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (wr_rst_n == 1'b0)
            octet_del_en_start_wrclk <= 1'b0;
        else
            octet_del_en_start_wrclk <= (octet_del_num == 4'd0) ? 1'b0 : 1'b1;
    end

    // Synchronizer wr_clk to rd_clk
    alt_mge16_pcs_std_synchronizer #(
        .depth      (2)         // Sync stages
    ) sync_del_en_rdclk (
        .clk        (rd_clk),
        .reset_n    (rd_rst_n),
        .din        (octet_del_en_start_wrclk),
        .dout       (octet_del_en_start_rdclk)
    );   
   
   
   //********************************************************************
   // Data is stored as follows 
   // TIME   DATA   Comments
   // t+1    nxt    Next
   // t 0    cur    CURRENT  <-------
   // t-1    pre    previous
   //********************************************************************
   // incoming data from hard PCS
   assign  data_in_pre      = data_in;  
   assign  control_in_pre   = control_in;  
   assign  data_valid_in_pre= data_valid_in;
   assign  wr_data_in       = {block_lock_in, control_in_pre, data_in_pre};

    // Data & Write/Read selection for different modes
    assign wr_data_in_int   = wr_data_10g_w;
    assign wr_en_int        = wr_en;
    assign rd_en_int        = rd_en_10g;
    
    // Attach block lock and 1588 data to write data  
    //assign wr_del_sm = {RM_SM_WIDTH{1'b0}}; // to handle deletion with fractional value 0.5. This do not occur in 32-bit data deletion, tie to 0.
    //assign wr_data_10g = {wr_del_sm, octet_del_num, block_lock_lt, wr_data[FDWIDTH-RM_TOTAL_WIDTH-1-1:0]};
    //assign wr_data_10g = {block_lock_lt, wr_data[FDWIDTH-RM_TOTAL_WIDTH-1-1:0]};

    // ED
    //assign wr_del_sm = 4'b0000;

    assign wr_data_10g_w = ENABLE_IEEE1588 ? {octet_del_num, block_lock_lt, wr_data[FDWIDTH-RM_TOTAL_WIDTH-1-1:0]} : {block_lock_lt, wr_data[FDWIDTH-RM_TOTAL_WIDTH-1-1:0]} ;
    //assign wr_data_10g_w = {2'b00, wr_del_sm[RM_SM_WIDTH-1:0], octet_del_num, wr_data[FDWIDTH-3-RM_TOTAL_WIDTH:0]};
    //pipeline data_valid signal
    always @(negedge wr_rst_n or posedge wr_clk) begin
        if (wr_rst_n == 1'b0) begin
            //nx1_data_valid_in  <= 'd0; 
            nx0_data_valid_in  <= 'd0; 
            cur_data_valid_in  <= 'd0; 
            cur_data_valid_in_lt  <= 'd0; 
        end
        else begin
            //nx1_data_valid_in  <= data_valid_in_pre;
            nx0_data_valid_in  <= data_valid_in_pre;
            cur_data_valid_in  <= nx0_data_valid_in;
            cur_data_valid_in_lt  <= cur_data_valid_in;
        end
    end


    // ------------------------------------------------------------------
    // Deletion Control - decode and pipeline received data
    // decode the OS, IDLE, and TERM on each OCTET(4 Bytes), and
    // pipeline the decode result if the received data is valid
    // ------------------------------------------------------------------
    always @(negedge wr_rst_n or posedge wr_clk) begin
        if (wr_rst_n == 1'b0) begin
            nx0_data_in      <= 'd0; 
            cur_data_in      <= 'd0;
            nx0_lsoctet_os   <= 'd0; 
            nx0_lsoctet_idle <= 'd0; 
            nx0_lsoctet_term <= 'd0;
            cur_lsoctet_os   <= 'd0; 
            cur_lsoctet_idle <= 'd0; 
            cur_lsoctet_term <= 'd0;
        end
        else begin
            nx0_data_in      <= (data_valid_in_pre) ? wr_data_in : nx0_data_in;
            cur_data_in      <= (nx0_data_valid_in) ? nx0_data_in : cur_data_in;
            
            cur_lsoctet_os   <= (nx0_data_valid_in) ? nx0_lsoctet_os   : cur_lsoctet_os;     
            cur_lsoctet_idle <= (nx0_data_valid_in) ? nx0_lsoctet_idle : cur_lsoctet_idle; 
            cur_lsoctet_term <= (nx0_data_valid_in) ? nx0_lsoctet_term : cur_lsoctet_term;
    
            // decode Next0 data
            case(wr_data_in[35:32])
            4'b1111: begin
                if (wr_data_in[31:0] == {4{XGMII_IDLE}}) begin
                    nx0_lsoctet_idle  <= 1'b1;
                end
                else begin
                    nx0_lsoctet_idle  <= 1'b0;
                end
                if (wr_data_in[7:0] == XGMII_TERM) begin
                    nx0_lsoctet_term <= 1'b1;
                end
                else begin
                    nx0_lsoctet_term <= 1'b0;
                end
                nx0_lsoctet_os <= 1'b0;
            end
            4'b0001: begin
                if (wr_data_in[7:0] == XGMII_SEQOS) begin
                   nx0_lsoctet_os <= 1'b1;
                end
                else begin
                   nx0_lsoctet_os <= 1'b0;
                end
                nx0_lsoctet_idle  <= 1'b0; 
                nx0_lsoctet_term  <= 1'b0;
            end
            4'b1110: begin 
                if (wr_data_in[15:8] == XGMII_TERM) begin
                    nx0_lsoctet_term <= 1'b1;
                end
                else begin
                    nx0_lsoctet_term <= 1'b0;
                end
                nx0_lsoctet_os       <= 1'b0; 
                nx0_lsoctet_idle     <= 1'b0; 
            end
            4'b1100: begin 
                if (wr_data_in[23:16] == XGMII_TERM) begin
                    nx0_lsoctet_term <= 1'b1;
                end
                else begin
                    nx0_lsoctet_term <= 1'b0;
                end
                nx0_lsoctet_os   <= 1'b0;
                nx0_lsoctet_idle <= 1'b0; 
            end

            4'b1000: begin 
                if (wr_data_in[31:24] == XGMII_TERM) begin
                    nx0_lsoctet_term <= 1'b1;
                end
                else begin
                    nx0_lsoctet_term <= 1'b0;
                end
                nx0_lsoctet_os   <= 1'b0;
                nx0_lsoctet_idle <= 1'b0; 
            end
            default: begin
                nx0_lsoctet_os   <= 1'b0; 
                nx0_lsoctet_idle <= 1'b0; 
                nx0_lsoctet_term <= 1'b0;
            end
            endcase
        end
    end

    // decode block lock on control signal
    assign cur_block_lock = cur_data_in[DATA_WIDTH + CONTROL_WIDTH];  // Frame lock or Block lock status
    assign block_lock_int = r_write_ctrl ? (block_lock_lt ||cur_block_lock) : cur_block_lock;
    
    // cur_block_lock to block_lock_lt = 1 cycle, is aligned to
    // cur_data_in to wr_data = 1cycle
    always @(negedge wr_rst_n or posedge wr_clk) begin
        if (wr_rst_n == 1'b0) begin
            block_lock_lt <= 1'b0;
        end
        else begin
            block_lock_lt <= cur_block_lock || (block_lock_lt && r_write_ctrl);
        end   
    end
   
    // ------------------------------------------------------------------
    // Deletion Control - Deletable word detection
    // ------------------------------------------------------------------
    // Delete the Current OCTET if 
    //  1) Previous Octet is a non-deletable OS, with content identical
    //     to current OCTET (which is also an OS)
    //  2) Previous OCTET is not T & the current octet is IDLE
    //  --> this will make sure that there is miminum of 5 IPG
    // ------------------------------------------------------------------
    /* always @(negedge wr_rst_n or posedge wr_clk) begin
        if (wr_rst_n == 1'b0) begin
            nx0_lsoctet_del <= 1'b0;
        end
        else begin
            if (nx1_data_valid_in) begin
                // Decode for NEXT0 Data Decodes
                if (((nx0_lsoctet_os & nx1_lsoctet_os & !nx0_lsoctet_del) & (nx0_data_in[31:0] == nx1_data_in[31:0])) |
                 (nx0_lsoctet_term == 1'b0 & nx1_lsoctet_idle)) begin
                    nx0_lsoctet_del <= 1'b1;
                end
                else begin
                    nx0_lsoctet_del <= 1'b0;
                end
            end
        end
    end */

    always @(negedge wr_rst_n or posedge wr_clk) begin
        if (wr_rst_n == 1'b0) begin
            cur_lsoctet_del <= 1'b0;
        end
        else begin
            if (nx0_data_valid_in) begin
                // Decode for Current Data Decodes
                if (((cur_lsoctet_os & nx0_lsoctet_os & !cur_lsoctet_del) & (cur_data_in[31:0] == nx0_data_in[31:0])) |
                 (cur_lsoctet_term == 1'b0 & nx0_lsoctet_idle)) begin
                    cur_lsoctet_del <= 1'b1;
                end
                else begin
                    cur_lsoctet_del <= 1'b0;
                end
            end
        end
    end
   
   
    // ------------------------------------------------------------------
    // Deletion Control - write access to FIFO
    // ------------------------------------------------------------------
    // WRITE CLOCK DOMAIN: Delete data when PFULL.
    // In order to stop the writing to the FIFO the following conditions 
    // has to be true
    // 1) Check if the current data is deletable, skip writing the data
    //    to FIFO if it can be deleted - wr_en deassert for 1 cycle.
    // ------------------------------------------------------------------
   
    always @(negedge wr_rst_n or posedge wr_clk) begin
        if (wr_rst_n == 1'b0) begin
            wr_en               <= 1'b0;
            wr_data             <= FIFO_DEFAULT[FDWIDTH-RM_TOTAL_WIDTH-1: 0];
            octet_del_num       <= {RM_DEL_INS_WIDTH{1'b0}};
            octet_del_counter   <= {COUNTER_WIDTH{1'b0}};
        end
        else if (!block_lock_int) begin
            wr_en               <= 1'b0;
            wr_data             <= FIFO_DEFAULT[FDWIDTH-RM_TOTAL_WIDTH-1: 0];
            octet_del_num       <= {RM_DEL_INS_WIDTH{1'b0}};
            octet_del_counter   <= {COUNTER_WIDTH{1'b0}};
        end   
        else if (cur_data_valid_in) begin
        // else if (nx0_data_valid_in) begin
            if (wr_pfull & cur_lsoctet_del) begin // deletion
                wr_en           <= 1'b0;
                octet_del_counter   <= COUNTER_MAX_SEL;
                if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                    octet_del_num   <= 4'd1;
                end
                else begin
                    octet_del_num   <= octet_del_num + 4'd1;
                end
            end
            else begin
                wr_en               <= 1'b1;
                wr_data             <= cur_data_in;
                if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                    octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
                end
                else begin
                    octet_del_num   <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                    octet_del_counter <= octet_del_counter - 11'd1;
                end
            end
            
        end // end of cur_data_valid_in
        else begin
            wr_en <= 1'b0;
            if (octet_del_counter == {COUNTER_WIDTH{1'b0}}) begin
                octet_del_num <= {RM_DEL_INS_WIDTH{1'b0}};
            end
            else begin
                octet_del_num <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                octet_del_counter <= octet_del_counter - 11'd1;
            end
        end
    end // end of Sequential part of SM
    

    // ------------------------------------------------------------------
    // 10G BaseR Deletion Flag
    // ------------------------------------------------------------------
    always @(negedge wr_rst_n or posedge wr_clk) begin
        if (wr_rst_n == 1'b0) begin
            fifo_del <= 1'b0;
        end
        //      else if (wr_en != cur_data_valid_in) begin
        //         fifo_del     <= 1'b1;
        //      end
        //      else if (cur_data_valid_in) begin
        //         fifo_del     <= 1'b0;
        //      end
        //   end     
        // Bug fix: de-assert fifo_del after it's has been written to FIFO
        //      else if (block_lock_lt) begin
        //         fifo_del     <= (wr_en != cur_data_valid_in);
        //      end
        //   end
        else if (block_lock_lt) begin 
            //if (fifo_del && !wr_en) begin <!-- why?
                //fifo_del <= 1'b1;
            //end
            if (wr_en != cur_data_valid_in_lt || (wr_en & wr_full) ) begin
                fifo_del <= 1'b1;
            end
            else begin 
                fifo_del <= 1'b0;
            end
        end
    end   
   
    // ------------------------------------------------------------------
    // Insertion Control - read_data decode
    // ------------------------------------------------------------------
    // READ CLOCK DOMAIN: STOP reading when PEMPTY,
    // This logic stops the read data from the fifo if the FIFO becomes 
    // partial empty, the FIFO read is stopped when the read data is a 
    // IDLE or OS.
    // A new IDLE is inserted after the detected IDLE/OS.
    // ------------------------------------------------------------------
    // rd_add_sm - decode nx_read_data/previous-word
    assign rd_lw_idle = (fifo_out_next[31:0] == {4{XGMII_IDLE}} && fifo_out_next[35:32] == 4'hF) ? 1'b1: 1'b0;
    assign rd_lw_os = (fifo_out_next[7:0] == XGMII_SEQOS && fifo_out_next[35:32] == 4'h1) ? 1'b1: 1'b0;
    assign ch_insert = rd_lw_idle|rd_lw_os;
   
    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0) begin
            first_read  <= 1'b1;
        end
        else if (~rd_pempty && first_read) begin
            first_read  <= 1'b0;
        end
    end
    
    // ------------------------------------------------------------------
    // rd_add_sm - control rd_en
    // RD_IDLE  : exit this state if not first read and no longer pempty.
    // RD_ENABLE: asserts rd_en and stay if not pempty.
    //          : deasserts rd_en and move to RD_INSERT if pempty.
    // RD_INSERT: asserts rd_en and back to RD_ENABLE if not pempty.
    //            deasserts rd_en and stay if pempty.
    // ------------------------------------------------------------------
    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0) begin
            rd_add_sm   <= RD_IDLE;
            rd_en_10g   <= 1'b0;
        end
        else begin
            if (rd_req) begin
                
                case(rd_add_sm)
                RD_IDLE: begin
                    if (~rd_pempty && ~first_read) begin
                        rd_add_sm   <= RD_ENABLE;
                        rd_en_10g   <= 1'b1;
                    end  
                    else begin
                        rd_add_sm   <= RD_IDLE;
                        rd_en_10g   <= 1'b0;
                    end      
                end
                RD_ENABLE: begin
                    
                    if(ch_insert && rd_pempty) begin
                        rd_add_sm   <= RD_INSERT; 
                        rd_en_10g   <= 1'b0;
                    end
                    else begin
                        rd_add_sm   <= RD_ENABLE; 
                        rd_en_10g   <= 1'b1;
                    end
                end
                RD_INSERT: begin
                    //if (rd_pempty && r_truebac2bac) begin <!----- turn on by default
                    if (rd_pempty && 1'b1) begin
                        rd_add_sm   <= RD_INSERT;
                        rd_en_10g   <= 1'b0;
                    end
                    else begin
                        rd_add_sm   <= RD_ENABLE;
                        rd_en_10g   <= 1'b1;
                    end
                end
                default: begin
                    rd_add_sm   <= RD_IDLE;
                    rd_en_10g   <= 1'b1;
                end
                endcase
            end // end of rd_req
            else begin
                rd_en_10g       <= 1'b0;
            end
            
        end
    end
    
    // latch rd_add_sm and rd_req
    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0) begin
            rd_add_sm_reg   <= RD_IDLE;
            rd_req_r        <= 1'b0;
            rd_req_r2       <= 1'b0;
        end
        else begin
            rd_add_sm_reg   <= rd_add_sm;
            rd_req_r        <= rd_req;
            rd_req_r2       <= rd_req_r;
        end
    end 
    // ------------------------------------------------------------------
    // rd_add_sm_reg - push existing fifo_out to d_out, insertion
    // RD_IDLE  : read fifo_out only if not first read and pempty
    // RD_ENABLE: read fifo_out
    // RD_INSERT: insert new IDLEs instead of read fifo_out
    // ------------------------------------------------------------------
    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0) begin
            d_out               <= FIFO_DEFAULT;
            d_out_valid         <= 1'b0;
            octet_ins_num       <= {RM_DEL_INS_WIDTH{1'b0}};
            octet_ins_num_hold  <= {RM_DEL_INS_WIDTH{1'b0}};
            octet_ins_counter   <= {COUNTER_WIDTH{1'b0}};
            octet_ins_en        <= 1'b0;
        end
        else if (rd_req_r2) begin
            if (rd_add_sm_reg==RD_IDLE) begin // use latched rd_add_sm
                if (~rd_pempty && ~first_read) begin
                    d_out       <= fifo_out;
                    d_out_valid <= 1'b1;
                end
                else begin
                    d_out       <= FIFO_DEFAULT;
                    d_out_valid <= 1'b0;
                end
                octet_ins_num  <= octet_ins_num_hold;
                if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
                    octet_ins_num_hold  <= {RM_DEL_INS_WIDTH{1'b0}};
                    octet_ins_en        <= 1'b0;
                end
                else begin
                    octet_ins_num_hold  <= octet_ins_num_hold + {RM_DEL_INS_WIDTH{1'b0}};
                    octet_ins_counter   <= octet_ins_counter - 11'd1;
                end 
            end  
            
            else if (rd_add_sm_reg==RD_ENABLE) begin
                d_out       <= fifo_out;
                d_out_valid <= 1'b1;
                octet_ins_num           <= octet_ins_num_hold;
                if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
                    octet_ins_num_hold  <= {RM_DEL_INS_WIDTH{1'b0}};
                    octet_ins_en        <= 1'b0;
                end
                else begin
                    octet_ins_num_hold  <= octet_ins_num_hold + {RM_DEL_INS_WIDTH{1'b0}};
                    octet_ins_counter   <= octet_ins_counter - 11'd1;
                end 
            end          
                
            else if (rd_add_sm_reg==RD_INSERT) begin
                d_out       <= {FIFO_1588_DEFAULT,1'b1,4'hF,XGMII_IDLE_WORD};
                d_out_valid <= 1'b1;
                octet_ins_counter  <= COUNTER_MAX_SEL;
                octet_ins_en       <= 1'b1;
                octet_ins_num      <= {RM_DEL_INS_WIDTH{1'b0}};
                if (octet_ins_counter == {COUNTER_WIDTH{1'b0}}) begin
                    octet_ins_num_hold  <= 4'd1;
                end
                else begin
                    octet_ins_num_hold  <= octet_ins_num_hold + 4'd1;
                end
            end  // end of RD_INSERT
            
        end
        else begin
            d_out_valid <= 1'b0;
        end
        
    end

    // ------------------------------------------------------------------
    // 10G BaseR insertion flag
    // ------------------------------------------------------------------
    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0) begin
            fifo_insert_pre <= 1'b0;
            fifo_insert     <= 1'b0;
        end
        else begin
            fifo_insert_pre <= rd_add_sm_reg==RD_INSERT;
            fifo_insert     <= fifo_insert_pre;
        end
    end 
   
    // always @(negedge rd_rst_n or posedge rd_clk) begin
        // if (rd_rst_n == 1'b0) begin
            // rd_en_lt <= 1'b0;
        // end
        // else begin
            // rd_en_lt <= rd_en_int || rd_en_lt;
        // end
    // end


    // ------------------------------------------------------------------
    // Output Register and Bypass Logic
    // - 1588 ctrl bits is not sent out
    // - handle empty case: fifo_out to data_out latency matches 
    //                      rd_empty assertion delay
    // ------------------------------------------------------------------
    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0) begin
            data_valid_out_0          <= 1'b1;
            data_out_0                <= FIFO_DATA_DEFAULT;
            control_out_0             <= FIFO_CTRL_DEFAULT[CONTROL_WIDTH-1:0];
            block_lock_out_0          <= FIFO_BLOCK_LOCK_DEFAULT;
        end
        // Output LF when FIFO is empty
        else if (rd_empty) begin
            data_valid_out_0          <= 1'b1;
            data_out_0                <= FIFO_DATA_DEFAULT;
            control_out_0             <= FIFO_CTRL_DEFAULT[CONTROL_WIDTH-1:0];
            block_lock_out_0          <= FIFO_BLOCK_LOCK_DEFAULT;
        end
        else begin // if clkcomp_mode
            if (rd_srst_n == 1'b0) begin
                data_valid_out_0      <= 1'b1;
                data_out_0            <= FIFO_DATA_DEFAULT;
                control_out_0         <= FIFO_CTRL_DEFAULT;
                block_lock_out_0      <= FIFO_BLOCK_LOCK_DEFAULT;
            end   
            else begin
                //data_valid_out       <= rd_en_lt;
                data_valid_out_0      <= d_out_valid;
                //{block_lock_out, control_out, data_out} <= rd_en_lt ? d_out[FDWIDTH-RM_TOTAL_WIDTH-1:0] : {block_lock_out, control_out, data_out}; //exclude 1588 control bit
                {block_lock_out_0, control_out_0, data_out_0} <= d_out_valid ? d_out[FDWIDTH-RM_TOTAL_WIDTH-1:0] : {block_lock_out_0, control_out_0, data_out_0}; //exclude 1588 control bit
            end   
        end
    end
    // Block Lock sync
    alt_mge16_pcs_std_synchronizer #(
        .depth      (2)     // Sync stages
    ) bitsync_block_lock (
        .clk        (rd_clk),
        .reset_n    (rd_rst_n),
        .din        (cur_block_lock),
        .dout       (block_lock_sync)
    );

    // FIFO sync reset 
    assign     wr_srst_n    = (cur_block_lock || r_write_ctrl); 
    assign     rd_srst_n    = (block_lock_sync || r_write_ctrl);
    // Edmond pipeline 1 stage for 1588 variant, align with del_num/ins_num
    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0) begin
            data_valid_out_1588 <= 1'b1;
            data_out_1588       <= FIFO_DATA_DEFAULT;
            control_out_1588    <= FIFO_CTRL_DEFAULT[CONTROL_WIDTH-1:0];
            block_lock_out_1588 <= FIFO_BLOCK_LOCK_DEFAULT;
        end
        else begin
            data_valid_out_1588 <= data_valid_out_0;
            data_out_1588       <= data_out_0;
            control_out_1588    <= control_out_0;
            block_lock_out_1588 <= block_lock_out_0;
        end
    end    
 
    assign data_valid_out = (ENABLE_IEEE1588) ? data_valid_out_1588 : data_valid_out_0;
    assign block_lock_out = (ENABLE_IEEE1588) ? block_lock_out_1588 : block_lock_out_0;
    assign control_out    = (ENABLE_IEEE1588) ? control_out_1588    : control_out_0;
    assign data_out       = (ENABLE_IEEE1588) ? data_out_1588       : data_out_0;

    function [FAWIDTH : 0] bin2gray;
        input [FAWIDTH : 0]  bin_val;
        integer i; 
                
        for (i = 0; i <= FAWIDTH; i = i + 1)
        begin
            if (i == FAWIDTH)
                bin2gray[i] = bin_val[i];
            else
                bin2gray[i] = bin_val[i+1] ^ bin_val[i];
        end
    endfunction

    function [FAWIDTH : 0] gray2bin;
        input [FAWIDTH : 0]  gray_val;
        integer i;
        integer j;
                
        for (i = 0; i <= FAWIDTH; i = i + 1) begin
            
            gray2bin[i] = gray_val[i];

            for (j = FAWIDTH; j > i; j = j - 1) begin
                gray2bin[i] = gray2bin[i] ^ gray_val[j];	
            end

        end
    endfunction
 
endmodule // alt_mge_phy_usxg32_rx_rm_fifo

