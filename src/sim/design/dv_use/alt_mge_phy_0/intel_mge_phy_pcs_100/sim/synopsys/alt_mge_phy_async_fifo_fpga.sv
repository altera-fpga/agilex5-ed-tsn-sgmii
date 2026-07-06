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
// Description: This one use DC fifo to make show ahead FIFO. 
// The latency between rd_en and rd_data is one clock. It depend on the upper layer 
// to check rd_empty to set rd_en
//------------------------------------------------------------------------
`timescale 1ns / 100ps


module alt_mge_phy_async_fifo_fpga
#(
   parameter DWIDTH = 8,                    // FIFO Input data width 
   parameter AWIDTH = 4,                    // FIFO Depth (address width) 
   parameter SYNCSTAGE   = 2,               // Metastable hardening stages
// parameter FIFO_ALMFULL = 12,             // FIFO Almost full level 
// parameter FIFO_ALMEMPTY = 4              // FIFO Almost empty level
   parameter RESET_LF =0,                   // Output Local Fault 
   parameter FIFO_DEFAULT = {DWIDTH{1'b0}}  // FIFO DEFAULT VALUE
)
(
    input  wire              wr_rst_n,   // Write Domain Active low Reset
    input  wire              wr_srst_n,  // Write Domain Active low Reset Synchronous
    input  wire              wr_clk,     // Write Domain Clock
    input  wire              wr_en,      // Write Data Enable
    input  wire [DWIDTH-1:0] wr_data,    // Write Data In
    input  wire              rd_rst_n,   // Read Domain Active low Reset
    input  wire              rd_srst_n,  // Read Domain Active low Reset Synchronous
    input  wire              rd_clk,     // Read Domain Clock
    input  wire              rd_en,      // Read Data Enable
    input  wire [AWIDTH-1:0] r_pempty,   // FIFO partially empty threshold
    input  wire [AWIDTH-1:0] r_pfull,    // FIFO partially full threshold
    input  wire [AWIDTH-1:0] r_empty,    // FIFO empty threshold
    input  wire [AWIDTH-1:0] r_full,     // FIFO full threshold
    output reg  [DWIDTH-1:0] rd_data,    // Read Data Out 
    output wire [DWIDTH-1:0] rd_data_next,    // Read Data Out Next
    output wire [AWIDTH-1:0] rd_numdata, // Number of Data available in Read clock
    output wire [AWIDTH-1:0] wr_numdata, // Number of Data available in Write clock 
    output reg               wr_empty,   // FIFO Empty
    output reg               wr_pempty,  // FIFO Partial Empty
    output reg               wr_full,    // FIFO Full
    output reg               wr_pfull,   // FIFO Parial Full
    output reg               rd_empty,   // FIFO Empty
    output reg               rd_pempty,  // FIFO Partial Empty
    output reg               rd_full,    // FIFO Full 
    output reg               rd_pfull    // FIFO Partial Full 
);

//********************************************************************
// Define Parameters 
//********************************************************************


//********************************************************************
// Define variables 
//********************************************************************
wire dcfifo_aclr;
   integer                   m;
   // Regs
   reg [DWIDTH-1:0]          fifo_mem [((1<<AWIDTH)-1):0];
   reg [AWIDTH:0]            wr_addr_bin;
   reg [AWIDTH:0]            rd_addr_bin;
   reg [AWIDTH:0]            rd_addr_bin_next_item;
   
   reg [AWIDTH:0]            wr_addr_gry;
   reg [AWIDTH:0]            rd_addr_gry;
   
   reg rd_data_valid;
   
   // Wires
   wire [AWIDTH-1:0]         wr_addr_mem;
   wire [AWIDTH-1:0]         rd_addr_mem;
   wire [AWIDTH-1:0]         rd_addr_mem_next;
   
   wire [AWIDTH:0]           wr_addr_bin_nxt;
   wire [AWIDTH:0]           rd_addr_bin_nxt;
   wire [AWIDTH:0]           wr_addr_gry_nxt;
   wire [AWIDTH:0]           rd_addr_gry_nxt;
   wire [AWIDTH:0]           wr_addr_bin_sync;
   wire [AWIDTH:0]           rd_addr_bin_sync;
   wire [AWIDTH:0]           wr_addr_gry_sync;
   wire [AWIDTH:0]           rd_addr_gry_sync;
   
   //********************************************************************
   // Infer Memory or use Dual Port Memory from Quartus/ASIC Memory
   //********************************************************************
 dcfifo #(
       .intended_device_family("Arria 10"),
       .lpm_hint("DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE"),
       .lpm_numwords(2 ** AWIDTH),
       .lpm_showahead("OFF"),
       .lpm_type("dcfifo"),
       .lpm_width(DWIDTH),
       .lpm_widthu(AWIDTH ),
       .overflow_checking("ON"),
       .rdsync_delaypipe(SYNCSTAGE),
       .underflow_checking("ON"),
       .use_eab("ON"),
       .write_aclr_synch("ON"),
       .read_aclr_synch("ON"),
       .wrsync_delaypipe (SYNCSTAGE)
     ) dcfifo_componenet ( 
    .wrclk (wr_clk),
    .wrreq (wr_en),
    .aclr (dcfifo_aclr),
    .rdreq (rd_en),
    .rdclk (rd_clk),
    .data (wr_data),
    .rdempty (),
    .wrusedw (wr_numdata),
    .wrfull (),
    .q (rd_data_next),
    .rdusedw (rd_numdata),
    .eccstatus ()
    // synopsys translate_off
    ,
    .rdfull (),
    .wrempty ()
    // synopsys translate_on
    );


  assign dcfifo_aclr = !( wr_rst_n & wr_srst_n & rd_rst_n & rd_srst_n);

    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0)
            rd_data_valid <= 1'b0;
        else if (rd_srst_n == 1'b0)
            rd_data_valid <= 1'b0;
        else if (rd_en == 1'b1)
            rd_data_valid <= 1'b1;
        else
            rd_data_valid <= rd_data_valid;
    end
    
    always @(negedge rd_rst_n or posedge rd_clk) begin
        if (rd_rst_n == 1'b0)
            rd_data <= (RESET_LF != 0) ? FIFO_DEFAULT : {DWIDTH{1'b0}};
        else if (rd_srst_n == 1'b0) 
            rd_data <= (RESET_LF != 0) ? FIFO_DEFAULT : {DWIDTH{1'b0}};
        else if ((rd_data_valid == 1'b0) && (RESET_LF != 0))
            rd_data <= FIFO_DEFAULT;
        else if (rd_en == 1'b1)
            rd_data <= (rd_empty == 1) ? FIFO_DEFAULT : rd_data_next;
        else
            rd_data <= (rd_empty == 1) ? FIFO_DEFAULT : rd_data;
    end

   //********************************************************************
   // WRITE CLOCK DOMAIN: Generate Fifo Number of Data Present 
   // using Write Address and Synchronized Read Address
   //********************************************************************
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         wr_full   <= 0;
         wr_pfull  <= 0;
         wr_empty  <= 1;
         wr_pempty <= 1;
      end
      else if (wr_srst_n == 1'b0) begin
         wr_full   <= 0;
         wr_pfull  <= 0;
         wr_empty  <= 1;
         wr_pempty <= 1;
      end
      else begin
         
         // Generate FIFO Empty
         wr_empty  <= (wr_numdata == r_empty) ? 1'b1 : 1'b0;  
         // Generate FIFO Almost Empty 
         wr_pempty <= (wr_numdata <= r_pempty) ? 1'b1 : 1'b0;
         // Generate FIFO Full
         wr_full   <= (wr_numdata >= r_full) ? 1'b1 : 1'b0; 
         // Generate FIFO Almost Full
         wr_pfull  <= (wr_numdata >= r_pfull) ? 1'b1 : 1'b0;
         
      end
   end
 
   
   //********************************************************************
   // READ CLOCK DOMAIN: Generate Fifo Number of Data Present
   // using Read Address and Synchronized Write Address
   //********************************************************************
   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         rd_empty    <= 1'b1;
         rd_pempty   <= 1'b1;
         rd_full     <= 1'b0;
         rd_pfull    <= 1'b0;
      end
      else if (rd_srst_n == 1'b0) begin
         rd_empty    <= 1'b1;
         rd_pempty   <= 1'b1;
         rd_full     <= 1'b0;
         rd_pfull    <= 1'b0;
      end
      else begin
         
         // Generate FIFO Empty
         rd_empty    <= (rd_numdata == r_empty) ? 1'b1 : 1'b0;  
         // Generate FIFO Almost Empty
         rd_pempty   <= (rd_numdata <= r_pempty) ? 1'b1 : 1'b0;
         // Generate FIFO Full
         rd_full     <= (rd_numdata >= r_full) ? 1'b1 : 1'b0; 
         // Generate FIFO Almost Full 
         rd_pfull    <= (rd_numdata >= r_pfull) ? 1'b1 : 1'b0;
         
      end
   end
  
endmodule // 


