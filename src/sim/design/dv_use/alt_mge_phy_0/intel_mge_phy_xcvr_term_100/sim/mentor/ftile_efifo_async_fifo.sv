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



`timescale 1ns / 100ps

module ftile_efifo_async_fifo # (
    parameter DWIDTH = 8,             // FIFO Input data width 
    parameter AWIDTH = 4,             // FIFO Depth (address width) 
    parameter SYNCSTAGE   = 2         // Metastable hardening stages
)(
    input                   wr_rst_n,   // Write Domain Active low Reset
    input                   wr_clk,     // Write Domain Clock
    input                   wr_en,      // Write Data Enable
    input      [DWIDTH-1:0] wr_data,    // Write Data In
    input                   rd_rst_n,   // Read Domain Active low Reset
    input                   rd_clk,     // Read Domain Clock
    input                   rd_en,      // Read Data Enable
    input      [AWIDTH-1:0] r_pempty,   // FIFO partially empty threshold
    input      [AWIDTH-1:0] r_pfull,    // FIFO partially full threshold
    input      [AWIDTH-1:0] r_empty,    // FIFO empty threshold
    input      [AWIDTH-1:0] r_full,     // FIFO full threshold
    output reg [DWIDTH-1:0] rd_data,    // Read Data Out 
    output reg [AWIDTH-1:0] rd_numdata /* synthesis noprune */, // Number of Data available in Read clock
    output reg [AWIDTH-1:0] wr_numdata /* synthesis noprune */, // Number of Data available in Write clock 
    output                  wr_full,    // FIFO Full - write clock domain
    output                  wr_pfull,   // FIFO Parial Full - write clock domain
    output                  wr_empty,   // FIFO empty - write clock domain
    output                  wr_pempty,  // FIFO Parial empty - write clock domain
    output                  rd_empty,   // FIFO Empty - read clock domain
    output                  rd_pempty,  // FIFO Partial Empty - read clock domain
    output                  rd_full,    // FIFO Full - read clock domain
    output                  rd_pfull    // FIFO Partial Full - read clock domain
);

//********************************************************************
// Define variables 
//********************************************************************
    // Regs
    reg                       wr_full_reg;

    // Wires
    wire dcfifo_aclr;
    wire [DWIDTH-1:0] rd_data_next;

    wire [AWIDTH-1:0] rd_numdata_wire; // Number of Data available in Read clock
    wire [AWIDTH-1:0] wr_numdata_wire; // Number of Data available in Write clock 

    //********************************************************************
    // Infer Memory or use Dual Port Memory from Quartus/ASIC Memory
    //********************************************************************
    dcfifo #(
        .intended_device_family("Agilex 5"),
        .lpm_hint("RAM_BLOCK_TYPE=M20K,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE"),
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
        .rdempty (rd_empty),
        .wrusedw (wr_numdata_wire),
        .wrfull (wr_full),
        .q (rd_data_next),
        .rdusedw (rd_numdata_wire),
        .eccstatus (),
        .rdfull (rd_full),
        .wrempty (wr_empty)
    );

    assign dcfifo_aclr = !(wr_rst_n & rd_rst_n);

    always @(posedge rd_clk, negedge rd_rst_n) begin
        if (!rd_rst_n) rd_data <= {DWIDTH{1'b0}};
        else if(rd_en) rd_data <= rd_data_next;
        else           rd_data <= rd_data;
    end

    //********************************************************************
    // work around for the wrusedw & rdusedw bug
    //********************************************************************
    always @(posedge wr_clk, negedge wr_rst_n) begin
        if(!wr_rst_n) wr_full_reg <= 1'b0;
        else          wr_full_reg <= wr_full;
    end

    always @(posedge wr_clk, negedge wr_rst_n) begin
        if(!wr_rst_n)                    wr_numdata <= 'd0;
        else if(!wr_full)                wr_numdata <= wr_numdata_wire;
        else if(wr_full && !wr_full_reg) wr_numdata <= wr_numdata_wire;
    end

    always @(posedge rd_clk, negedge rd_rst_n) begin
        if(!rd_rst_n)     rd_numdata <= 'd0;
        else  rd_numdata <= rd_numdata_wire;
    end

    //********************************************************************
    // WRITE CLOCK DOMAIN: Generate Fifo Number of Data Present 
    // using Write Address and Synchronized Read Address
    //********************************************************************

    // Generate FIFO Almost Full
    assign wr_pfull  = (wr_numdata >= r_pfull) ? 1'b1 : 1'b0;
    // Generate FIFO Almost Empty
    assign wr_pempty = (wr_numdata <= r_pempty) ? 1'b1 : 1'b0;
    
    //********************************************************************
    // READ CLOCK DOMAIN: Generate Fifo Number of Data Present
    // using Read Address and Synchronized Write Address
    //********************************************************************

    // Generate FIFO Almost Empty
    assign rd_pempty   = (rd_numdata <= r_pempty) ? 1'b1 : 1'b0;
    // Genarate FIFO Almost Full
    assign rd_pfull    = (rd_numdata >= r_pfull) ? 1'b1 : rd_full;
endmodule // 
