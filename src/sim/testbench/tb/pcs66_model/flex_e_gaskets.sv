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


//==============================================================================
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//-----------------------------------------------------------------------------
// This file contains Testbench Gaskets used to interface the EHIP to
// the FLEX E BFM.
// The modules include:
//     flex_e_avst_tx_if 
//     flex_e_1to4_gearbox
//     flex_e_4to1_gearbox
//-------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Module: flex_e_avst_if
//
// This module implements a verilog AVST-IF for use with the Flex E gearbox.  
//------------------------------------------------------------------------------  
 module flex_e_avst_tx_if  # (
    parameter DWIDTH = 264)
(
     input                    i_clk,            //  EHIP clock
     input                    i_rst_n,          // async reset for EHIP 
     input[5:0]               i_avst_latency,   // AVST latency in # of i_clk
     input                    i_avst_ready,     // AVST ready
     input[1055:0]            i_data_null,      // what to send if no data is available
     input                    i_data_available, // From BFM -- indicates i_data is valid
     input[1055:0]            i_data,           // BFM data to transmit
     input                    i_am_insert,      // BFM's am_insert  -- only valid when i_avst_ready=1

     output reg[1055:0]       o_avst_data,      // AVST data to DUT
     output reg               o_am_insert,      // to DUT 
     output reg               o_avst_valid      // when 1, o_data_x is valid    
);
//VCS coverage off
    reg[63:0]                 ready_shift_reg;
    reg[63:0]                 am_shift_reg;
    reg[(1056*64)-1:0]        data_shift_reg;
    integer                   i;

 
    always @ (posedge i_clk or negedge i_rst_n) begin   
        if (~i_rst_n) begin     
            ready_shift_reg <= 'h0;
            data_shift_reg  <= {(1056*64){1'b0}};
            am_shift_reg    <= 'h0;
        end
        else begin   
            // Delay pipes for AVST latency
            ready_shift_reg <= {ready_shift_reg[62:0], i_avst_ready}; 
            data_shift_reg  <= i_data_available ? {data_shift_reg[(1056*63)-1:0], i_data} : {data_shift_reg[(1056*63)-1:0], i_data_null};
            am_shift_reg    <= {am_shift_reg[62:0], i_am_insert}; 
        end
    end

    always @ (*) begin
        for (i=0; i<64; i=i+1) begin
            if (i==0) begin    // zero latency
               o_avst_data  = i_data;
               o_avst_valid = i_avst_ready;
               o_am_insert  = i_am_insert;
            end
            else if (i_avst_latency == i) begin   // tap the data/valid off of the delay pipe, depending on the AVST latency value
                o_avst_data  = data_shift_reg[(1056*i) +: 1056];
                o_avst_valid = ready_shift_reg[i];
                o_am_insert  = am_shift_reg[i];
            end
        end
    end
//VCS coverage on
endmodule : flex_e_avst_tx_if


//------------------------------------------------------------------------------
// Module: flex_e_1toN_gearbox
//
// This module collects N cycles worth of data from i_clk_a, and gearboxes it to
// NX the datawidth on i_clk_b.  
// An async FIFO is used to rate-match the i_clk_a and i_clk_b domains.  
//------------------------------------------------------------------------------ 
module flex_e_1toN_gearbox  # (
    parameter DWIDTH = 66,
    parameter AWIDTH = 6,
    parameter SOURCE_FREQ_MHZ = 1562.5)
(
     input                       i_clk_a,            // EHIP clk x 4 x 64/66
     input                       i_rst_a_n,          // async reset  
     input[65:0]                 i_bfm_data,         // data input from OTN BFM
     input[10:0]                 source_freq_mhz,
     input[4:0]                  gear,
     input                       i_bfm_dvalid,       // when 1, i_bfm_data is valid  

     input                       i_clk_b,            // EHIP clk
     input                       i_rst_b_n,          // async reset  
     input                       i_pop,              // advances the look-ahead output 
     output[1055:0]              o_data,             // 264b data output
     output                      o_data_available,   // when 1, o_data_x is valid 
     output                      o_err_underflow,
     output                      o_err_overflow   
);
//VCS coverage off
    reg[1055:0]          data_shift_reg_a;        // collect 4 cycles worth of i_bfm_data before offloading 
    reg[3:0]             data_count_a;            // number of i_bfm_data received in data_shift_reg_a
    reg[1055:0]          fifo_wrdata_a;
    reg                  fifo_wr_en_a;
    wire                 fifo_full_a;
    reg                  rd_domain_active_sync_a;      // means the Read domain is out of reset & popping data
                                                       // hold off the writes until read domain is active - to prevent overflow
    reg                  rd_domain_active_meta_a;      // meta stage

    wire                 fifo_empty_b;  
    reg                  allow_reads_b;
    wire[AWIDTH-1:0]     fifo_count_b;
    wire                 fifo_rd_b;
    reg                  rd_domain_active_b;

    wire[65:0]           debug_out_data[16];   // lowest 66b chunk of o_data //version3.0
    wire[65:0]           debug_out_data64[16];   // lowest 66b chunk of o_data//version 3.0


    generate
      for (genvar G=0;G<16;G++) begin
              assign debug_out_data[G]   =(gear>G)?o_data[G*66+:66]:0;
              assign debug_out_data64[G] =(gear>G)?o_data[((G*66)+2)+:64]:0;
      end
    endgenerate

    initial begin
       data_count_a     = 'h0; 
       data_shift_reg_a = 'h0; 
       fifo_wr_en_a     = 1'b0; 
       fifo_wrdata_a    = 'h0;        
    end
    
    assign o_err_overflow = fifo_wr_en_a && fifo_full_a;
    always @ (posedge i_clk_a or negedge i_rst_a_n) begin   // 1562.5MHz
        if (~i_rst_a_n) begin
            data_count_a            <= 'h0;  
            fifo_wr_en_a            <= 1'b0; 
            fifo_wrdata_a           <= 'h0;
            rd_domain_active_meta_a <= 1'b0;
            rd_domain_active_sync_a <= 1'b0;
        end
        else begin
            rd_domain_active_meta_a <=  rd_domain_active_b;
            rd_domain_active_sync_a <=  rd_domain_active_meta_a;        
            if (i_bfm_dvalid && rd_domain_active_sync_a) begin    // do not start write domain until read domain is active
                data_count_a      <= (data_count_a==(gear-1))? 0:(data_count_a + 1);                              // count # of data cycles received 
                fifo_wr_en_a      <= (data_count_a==(gear-1));
                fifo_wrdata_a     <= (gear==1)?{i_bfm_data,990'b0}:{i_bfm_data, fifo_wrdata_a[66 +:(15*66)]};  // first data on line is rightmost//version3.0
            end 
            else begin
                fifo_wr_en_a <= 1'b0;
            end
        end
    end
   
    always @ (posedge i_clk_b or negedge i_rst_b_n) begin   // 390Mhz
        if (~i_rst_b_n) begin 
            allow_reads_b      <= 1'b0; 
            rd_domain_active_b <= 1'b0;
        end
        else begin 
            rd_domain_active_b  <= i_pop ? 1'b1 : rd_domain_active_b;
            allow_reads_b       <= (fifo_count_b > 1'b1) ? 1'b1 : allow_reads_b;  // allow reads once we receive some minimum # of entries
                                                                            // thereafter, the FIFO should never go empty
           
        end
    end 
 
    assign o_data_available = fifo_rd_b;
    assign fifo_rd_b        = allow_reads_b && ~fifo_empty_b && i_pop;    
    assign o_err_underflow  = i_pop && fifo_empty_b;              // means input bandwidth could not keep up with output
 

   
    c2_c3lib_async_fifo #( .DWIDTH (4*DWIDTH),                      // FIFO Input data width 
                        .AWIDTH (AWIDTH),                        // FIFO Depth (address width)
                        .DST_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ/4),   // Clock frequency for destination domain in MHz
                        .SRC_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ)      // Clock frequency for source domain in MHz

     ) u_fifo ( 
    .wr_rst_n (i_rst_a_n ),                    // Write Domain Active low Reset
    .wr_clk   (i_clk_a ),                      // Write Domain Clock
    .wr_en    (fifo_wr_en_a && !fifo_full_a),  // Write Data Enable
    .wr_data  (fifo_wrdata_a ),                // Write Data In
    .rd_rst_n (i_rst_b_n ),                    // Read Domain Active low Reset
    .rd_clk   (i_clk_b ),                      // Read Domain Clock
    .dst_clk_freq_mhz(source_freq_mhz/gear), //new port
    .src_clk_freq_mhz(source_freq_mhz), //new port
    .rd_en    (fifo_rd_b ),                    // Read Data Enable
    .r_pempty ({AWIDTH{1'b0}}  ),              // FIFO partially empty threshold
    .r_pfull  ({AWIDTH{1'b1}}  ),              // FIFO partially full threshold
    .r_empty  ({AWIDTH{1'b0}}  ),              // FIFO empty threshold
    .r_full   ({AWIDTH{1'b1}}  ),              // FIFO full threshold
    
    .rd_data    (o_data),           // Read Data Out 
    .rd_numdata (fifo_count_b ),    // Number of Data available in Read clock
    .wr_numdata ( ),                // Number of Data available in Write clock 
    
    .wr_empty  (  ),                // FIFO Empty
    .wr_pempty ( ),                 // FIFO Partial Empty
    .wr_full   (fifo_full_a ),      // FIFO Full
    .wr_pfull  ( ),                 // FIFO Parial Full
    .rd_empty  (fifo_empty_b ),     // FIFO Empty
    .rd_pempty ( ),                 // FIFO Partial Empty
    .rd_full   ( ),                 // FIFO Full 
    .rd_pfull  ( )                  // FIFO Partial Full 
     );
//VCS coverage on
endmodule : flex_e_1toN_gearbox 


//------------------------------------------------------------------------------
// Module: flex_e_Nto1_gearbox
//
// This module collects 1 cycle of data from i_clk_a, and gearboxes it to
// 1/N the datawidth @ NX the frequency on i_clk_b..  
//   
//------------------------------------------------------------------------------  
 module flex_e_Nto1_gearbox  # (
    parameter DWIDTH = 66,
    parameter AWIDTH = 6,
    parameter SOURCE_FREQ_MHZ = 390
)
(
     input                    i_clk_a,       // EHIP clk
     input                    i_rst_a_n,     // async reset  
     input[1055:0]            i_data,        // 264b data input -- first quad on line is right-most
     input                    i_dvalid,      // when 1, i_data is valid   

     input                    i_clk_b,       // EHIP clk x 4 x 64/66
     input                    i_rst_b_n,     // async reset  
     input [10:0]             source_freq_mhz,
     input [4:0]              gear,
     input                    i_pop, 
     output reg[65:0]         o_bfm_data,    // 66b data output
     output reg               o_bfm_dvalid,  // when 1, o_data_x is valid    
     output                   o_err_overflow 
);
//VCS coverage off
    wire                 fifo_full_a;
    reg                  rd_domain_active_sync_a;      // means the Read domain is out of reset & popping data
                                                       // hold off the writes until read domain is active - to prevent overflow
    reg                  rd_domain_active_meta_a;      // meta stage

    reg[3:0]             data_count_b;     // keep track of which quad of data is being forwarded
    wire                 fifo_empty_b;
    wire[1055:0]         fifo_rddata_b;  
    reg[1055:0]          fifo_rddata_hold_b; 
    wire                 fifo_rd_b;
    reg                  rd_domain_active_b; 
    reg                  burst_b; 
    wire[AWIDTH-1:0]     rd_numdata_b;

    wire[65:0]           debug_in_data[16];   // lowest 66b chunk of o_data
    wire[65:0]           debug_in_data64[16];   // lowest 66b chunk of o_data

    wire[63:0]           debug_out_data64;

    reg[9:0]             debug_count_clka;
    reg[9:0]             debug_count_clkb;

    initial begin
        debug_count_clka = 0;
        debug_count_clkb = 0;
    end
    always @ (posedge i_clk_a) debug_count_clka <= (debug_count_clka=='d66) ? debug_count_clka : (debug_count_clka + 1);
    always @ (posedge i_clk_b) debug_count_clkb <= (debug_count_clkb=='d256) ? debug_count_clkb : (debug_count_clkb + 1);

    generate
      for (genvar G=0;G<16;G++) begin
              assign debug_in_data[G]   = i_data[G*66+:66];
              assign debug_in_data64[G] = i_data[((G*66)+2)+:64];
      end
    endgenerate

    assign debug_out_data64 = o_bfm_data[65:2];

    initial begin
       data_count_b       = 'h0;
       fifo_rddata_hold_b = 'h0;
       o_bfm_dvalid       = 1'b0;
       o_bfm_data         = 'h0;
    end

    always @ (posedge i_clk_a or negedge i_rst_a_n) begin   // 1562.5MHz
        if (~i_rst_a_n) begin 
            rd_domain_active_meta_a <= 1'b0;
            rd_domain_active_sync_a <= 1'b0;
        end
        else begin
            rd_domain_active_meta_a <=  rd_domain_active_b;
            rd_domain_active_sync_a <=  rd_domain_active_meta_a;    
        end
    end
    
    assign o_err_overflow = i_dvalid && fifo_full_a;

    always @ (posedge i_clk_b or negedge i_rst_b_n) begin  // 1562.5Mhz 
        if (~i_rst_b_n) begin 
            data_count_b       <= 'h0; 
            fifo_rddata_hold_b <= 'h0;
            o_bfm_dvalid       <= 1'b0; 
            o_bfm_data         <= 'h0;
            rd_domain_active_b <= 1'b0;
            burst_b            <= 1'b0; 
        end
        else begin  
            rd_domain_active_b <= 1'b1; 
            data_count_b       <= (data_count_b==(gear-1)) ? 0 : (fifo_rd_b || burst_b) ? (data_count_b + 1) : data_count_b;   // when data_count_b=0, wait for fifo_rd.  else, burst data out.
            burst_b            <= fifo_rd_b ? 1'b1 : (data_count_b ==(gear-1)) ? 1'b0 : burst_b;
            fifo_rddata_hold_b <= fifo_rd_b ? fifo_rddata_b : fifo_rddata_hold_b; 
            o_bfm_dvalid       <= fifo_rd_b || burst_b;
            case (data_count_b)          // TDM out the data  
                4'h0:  o_bfm_data <= fifo_rddata_b[66*0 +: 66];                                
                4'h1:  o_bfm_data <= fifo_rddata_hold_b[66*1 +: 66];
                4'h2:  o_bfm_data <= fifo_rddata_hold_b[66*2 +: 66];
                4'h3:  o_bfm_data <= fifo_rddata_hold_b[66*3 +: 66];
                4'h4:  o_bfm_data <= fifo_rddata_hold_b[66*4 +: 66];
                4'h5:  o_bfm_data <= fifo_rddata_hold_b[66*5 +: 66];
                4'h6:  o_bfm_data <= fifo_rddata_hold_b[66*6 +: 66];
                4'h7:  o_bfm_data <= fifo_rddata_hold_b[66*7 +: 66];
                4'h8:  o_bfm_data <= fifo_rddata_hold_b[66*8 +: 66];
                4'h9:  o_bfm_data <= fifo_rddata_hold_b[66*9 +: 66];
                4'ha:  o_bfm_data <= fifo_rddata_hold_b[66*10 +: 66];
                4'hb:  o_bfm_data <= fifo_rddata_hold_b[66*11 +: 66];
                4'hc:  o_bfm_data <= fifo_rddata_hold_b[66*12 +: 66];
                4'hd:  o_bfm_data <= fifo_rddata_hold_b[66*13 +: 66];
                4'he:  o_bfm_data <= fifo_rddata_hold_b[66*14 +: 66];
                4'hf:  o_bfm_data <= fifo_rddata_hold_b[66*15 +: 66];
                default:  o_bfm_data <= 'h0;
            endcase             
        end
    end

    assign fifo_rd_b = (data_count_b == 'h0) && ~fifo_empty_b && i_pop;
  
    // This is a look-ahead FIFO 
    c2_c3lib_async_fifo #( .DWIDTH (4*DWIDTH),                    // FIFO Input data width 
                        .AWIDTH (AWIDTH),                      // FIFO Depth (address width)
                        .DST_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ),   // Clock frequency for destination domain in MHz
                        .SRC_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ/4)  // Clock frequency for source domain in MHz

     ) u_fifo ( 
    .wr_rst_n (i_rst_a_n ),                // Write Domain Active low Reset
    .wr_clk   (i_clk_a ),                  // Write Domain Clock
    .wr_en    (i_dvalid && !fifo_full_a && rd_domain_active_sync_a),  // Write Data Enable
    .wr_data  (i_data ),                   // Write Data In
    .rd_rst_n (i_rst_b_n ),                // Read Domain Active low Reset
    .rd_clk   (i_clk_b ),                  // Read Domain Clock
    .rd_en    (fifo_rd_b ),                // Read Data Enable
    .r_pempty ({AWIDTH{1'b0}} ),           // FIFO partially empty threshold
    .r_pfull  ({AWIDTH{1'b0}} ),           // FIFO partially full threshold
    .r_empty  ({AWIDTH{1'b0}} ),           // FIFO empty threshold
    .r_full   ({AWIDTH{1'b1}} ),           // FIFO full threshold
    
    .rd_data    (fifo_rddata_b ),   // Read Data Out 
    .rd_numdata (rd_numdata_b ),    // Number of Data available in Read clock
    .wr_numdata ( ),                // Number of Data available in Write clock 
    
    .dst_clk_freq_mhz(source_freq_mhz), //new port
    .src_clk_freq_mhz(source_freq_mhz/gear), //new port
    .wr_empty  (  ),                // FIFO Empty
    .wr_pempty ( ),                 // FIFO Partial Empty
    .wr_full   (fifo_full_a ),      // FIFO Full
    .wr_pfull  ( ),                 // FIFO Parial Full
    .rd_empty  (fifo_empty_b ),     // FIFO Empty
    .rd_pempty ( ),                 // FIFO Partial Empty
    .rd_full   ( ),                 // FIFO Full 
    .rd_pfull  ( )                  // FIFO Partial Full 
     );
//VCS coverage on
endmodule : flex_e_Nto1_gearbox 


//------------------------------------------------------------------------------
// Module: flex_e_1to1_tx_gearbox
//
// This module collects 1 cycles worth of data from i_clk_wr, and gearboxes it to
// 1X the datawidth on i_clk_rd.  
// An async FIFO is used to rate-match the i_clk_wi_clk_wr_clk_b domains.  
//------------------------------------------------------------------------------ 
module flex_e_1to1_tx_gearbox  # (
    parameter DWIDTH = 66,
    parameter AWIDTH = 6,
    parameter SOURCE_FREQ_MHZ = 156.25)
(
     input                       i_clk_wr,            // EHIP clk x 4 x 64/66
     input                       i_rst_wr_n,          // async reset  
     input[DWIDTH-1:0]           i_wr_data,         // data input from OTN BFM
     input                       i_wr_valid,       // when 1, i_wr_data is valid  

     input                       i_clk_rd,            // EHIP clk
     input                       i_rst_rd_n,          // async reset  
     input                       i_pop,              // advances the look-ahead output 
     output[(DWIDTH)-1:0]        o_rd_data,             // 264b data output
     output                      o_rd_valid,   // when 1, o_data_x is valid 
     output                      o_err_underflow,
     output                      o_err_overflow   
);
//VCS coverage off
    reg[(4*DWIDTH)-1:0]  data_shift_reg_a;        // collect 4 cycles worth of i_wr_data before offloading 
    reg[1:0]             data_count_a;            // number of i_wr_data received in data_shift_reg_a
    reg[(4*DWIDTH)-1:0]  fifo_wrdata_a;
    reg                  fifo_wr_en_a;
    wire                 fifo_full_a;
    reg                  rd_domain_active_sync_a;      // means the Read domain is out of reset & popping data
                                                       // hold off the writes until read domain is active - to prevent overflow
    reg                  rd_domain_active_meta_a;      // meta stage

    wire                 fifo_empty_b;  
    reg                  allow_reads_b;
    wire[AWIDTH-1:0]     fifo_count_b;
    wire                 fifo_rd_b;
    reg                  rd_domain_active_b;

    wire[65:0]           debug_out_data_0;   // lowest 66b chunk of o_rd_data

    wire[63:0]           debug_out_data64_0;   // lowest 64b chunk of o_rd_data -- sync bits stripped off


    assign debug_out_data_0 = o_rd_data[0*66 +: 66];

    assign debug_out_data64_0 = o_rd_data[((0*66)+2) +: 64];

    initial begin
       data_count_a     = 2'h0; 
       data_shift_reg_a = 'h0; 
       fifo_wr_en_a     = 1'b0; 
       fifo_wrdata_a    = 'h0;        
    end
    
    always @ (posedge i_clk_wr or negedge i_rst_wr_n) begin   // 1562.5MHz
        if (~i_rst_wr_n) begin
            data_count_a      <= 2'h0;  
            fifo_wr_en_a      <= 1'b0; 
            fifo_wrdata_a     <= 'h0;
            rd_domain_active_meta_a <= 1'b0;
            rd_domain_active_sync_a <= 1'b0;
        end
        else begin
            rd_domain_active_meta_a <=  rd_domain_active_b;
            rd_domain_active_sync_a <=  rd_domain_active_meta_a;        
            if (i_wr_valid && rd_domain_active_sync_a) begin    // do not start write domain until read domain is active
                fifo_wr_en_a      <= (data_count_a==2'h0);
            end 
            else begin
                fifo_wr_en_a <= 1'b0;
            end
        end
    end
   
    always @ (posedge i_clk_rd or negedge i_rst_rd_n) begin   // 390Mhz
        if (~i_rst_rd_n) begin 
            allow_reads_b <= 1'b0; 
            rd_domain_active_b <= 1'b0;
        end
        else begin 
            rd_domain_active_b  <= i_pop ? 1'b1 : rd_domain_active_b;
            allow_reads_b <= (fifo_count_b > 1'b1) ? 1'b1 : allow_reads_b;  // allow reads once we receive some minimum # of entries
                                                                            // thereafter, the FIFO should never go empty
           
        end
    end 
 
    assign o_rd_valid = fifo_rd_b;
    assign fifo_rd_b = allow_reads_b && ~fifo_empty_b && i_pop;    

    assign o_err_underflow = i_pop && fifo_empty_b;              // means input bandwidth could not keep up with output
    assign o_err_overflow = fifo_wr_en_a && fifo_full_a;
 

   
    c2_c3lib_async_fifo #( .DWIDTH (DWIDTH),                      // FIFO Input data width 
                        .AWIDTH (AWIDTH),                        // FIFO Depth (address width)
                        .DST_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ),   // Clock frequency for destination domain in MHz
                        .SRC_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ)      // Clock frequency for source domain in MHz

     ) u_fifo ( 
    .wr_rst_n (i_rst_wr_n ),                    // Write Domain Active low Reset
    .wr_clk   (i_clk_wr ),                      // Write Domain Clock
    .wr_en    (fifo_wr_en_a && !fifo_full_a),  // Write Data Enable
    .wr_data  (i_wr_data ),                // Write Data In
    .rd_rst_n (i_rst_rd_n ),                    // Read Domain Active low Reset
    .rd_clk   (i_clk_rd ),                      // Read Domain Clock
    .rd_en    (fifo_rd_b ),                    // Read Data Enable
    .r_pempty ({AWIDTH{1'b0}}  ),              // FIFO partially empty threshold
    .r_pfull  ({AWIDTH{1'b1}}  ),              // FIFO partially full threshold
    .r_empty  ({AWIDTH{1'b0}}  ),              // FIFO empty threshold
    .r_full   ({AWIDTH{1'b1}}  ),              // FIFO full threshold
    
    .rd_data    (o_rd_data),           // Read Data Out 
    .rd_numdata (fifo_count_b ),    // Number of Data available in Read clock
    .wr_numdata ( ),                // Number of Data available in Write clock 
    
    .wr_empty  (  ),                // FIFO Empty
    .wr_pempty ( ),                 // FIFO Partial Empty
    .wr_full   (fifo_full_a ),      // FIFO Full
    .wr_pfull  ( ),                 // FIFO Parial Full
    .rd_empty  (fifo_empty_b ),     // FIFO Empty
    .rd_pempty ( ),                 // FIFO Partial Empty
    .rd_full   ( ),                 // FIFO Full 
    .rd_pfull  ( )                  // FIFO Partial Full 
     );
//VCS coverage on
endmodule : flex_e_1to1_tx_gearbox 

//------------------------------------------------------------------------------
// Module: flex_e_1to1_rx_gearbox
//
// This module collects 1 cycle of data from i_clk_wr, and gearboxes it to
// 1 cycle the datawidth @ frequency on i_clk_b..  
//   
//------------------------------------------------------------------------------  
 module flex_e_1to1_rx_gearbox  # (
    parameter DWIDTH = 66,
    parameter AWIDTH = 6,
    parameter SOURCE_FREQ_MHZ = 156.25
)
(
     input                    i_clk_wr,       // EHIP clk
     input                    i_rst_wr_n,     // async reset  
     input[(DWIDTH)-1:0]      i_wr_data,        // 264b data input -- first quad on line is right-most
     input                    i_wr_dvalid,      // when 1, i_wr_data is valid   

     input                    i_clk_rd,       // EHIP clk x 4 x 64/66
     input                    i_rst_rd_n,     // async reset  
     output reg[DWIDTH-1:0]   o_rd_data,    // 66b data output
     output reg               o_rd_dvalid,  // when 1, o_data_x is valid    
     output                   o_err_overflow 
);
//VCS coverage off
    wire                 fifo_full_a;
    reg                  rd_domain_active_sync_a;      // means the Read domain is out of reset & popping data
                                                       // hold off the writes until read domain is active - to prevent overflow
    reg                  rd_domain_active_meta_a;      // meta stage

    wire                 fifo_empty_b;
    wire[(DWIDTH)-1:0]   fifo_rddata_b;  
    reg[(DWIDTH)-1:0]    fifo_rddata_hold_b; 
    wire                 fifo_rd_b;
    reg                  rd_domain_active_b; 
    wire[AWIDTH-1:0]     rd_numdata_b;

    wire[65:0]           debug_in_data_0;   // lowest 66b chunk of o_data

    wire[63:0]           debug_in_data64_0;   // lowest 64b chunk of o_data -- sync bits stripped off

    wire[63:0]           debug_out_data64;

    assign debug_in_data_0 = i_wr_data[0*66 +: 66];

    assign debug_in_data64_0 = i_wr_data[((0*66)+2) +: 64];

    assign debug_out_data64 = o_rd_data[65:2];

    initial begin
       fifo_rddata_hold_b = 'h0;
       o_rd_dvalid       = 1'b0;
       o_rd_data         = 'h0;
    end

    always @ (posedge i_clk_wr or negedge i_rst_wr_n) begin   // 1562.5MHz
        if (~i_rst_wr_n) begin 
            rd_domain_active_meta_a <= 1'b0;
            rd_domain_active_sync_a <= 1'b0;
        end
        else begin
            rd_domain_active_meta_a <=  rd_domain_active_b;
            rd_domain_active_sync_a <=  rd_domain_active_meta_a;    
        end
    end
    
    assign o_err_overflow = i_wr_dvalid && fifo_full_a;

    always @ (posedge i_clk_rd or negedge i_rst_rd_n) begin  // 1562.5Mhz 
        if (~i_rst_rd_n) begin 
            fifo_rddata_hold_b <= 'h0;
            o_rd_dvalid       <= 1'b0; 
            o_rd_data         <= 'h0;
            rd_domain_active_b <= 1'b0;
        end
        else begin  
            rd_domain_active_b <= 1'b1; 
            //fifo_rddata_hold_b <= fifo_rd_b ? fifo_rddata_b : fifo_rddata_hold_b; 
            o_rd_dvalid       <= fifo_rd_b ;
            o_rd_data <= fifo_rddata_b[DWIDTH*0 +: DWIDTH];                                
        end
    end

    assign fifo_rd_b = ~fifo_empty_b ;
  
    // This is a look-ahead FIFO 
    c2_c3lib_async_fifo #( .DWIDTH (DWIDTH),                    // FIFO Input data width 
                        .AWIDTH (AWIDTH),                      // FIFO Depth (address width)
                        .DST_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ),   // Clock frequency for destination domain in MHz
                        .SRC_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ)  // Clock frequency for source domain in MHz

     ) u_fifo ( 
    .wr_rst_n (i_rst_wr_n ),                // Write Domain Active low Reset
    .wr_clk   (i_clk_wr ),                  // Write Domain Clock
    .wr_en    (i_wr_dvalid && !fifo_full_a && rd_domain_active_sync_a),  // Write Data Enable
    .wr_data  (i_wr_data ),                   // Write Data In
    .rd_rst_n (i_rst_rd_n ),                // Read Domain Active low Reset
    .rd_clk   (i_clk_rd ),                  // Read Domain Clock
    .rd_en    (fifo_rd_b ),                // Read Data Enable
    .r_pempty ({AWIDTH{1'b0}} ),           // FIFO partially empty threshold
    .r_pfull  ({AWIDTH{1'b0}} ),           // FIFO partially full threshold
    .r_empty  ({AWIDTH{1'b0}} ),           // FIFO empty threshold
    .r_full   ({AWIDTH{1'b1}} ),           // FIFO full threshold
    
    .rd_data    (fifo_rddata_b ),   // Read Data Out 
    .rd_numdata (rd_numdata_b ),    // Number of Data available in Read clock
    .wr_numdata ( ),                // Number of Data available in Write clock 
    
    .wr_empty  (  ),                // FIFO Empty
    .wr_pempty ( ),                 // FIFO Partial Empty
    .wr_full   (fifo_full_a ),      // FIFO Full
    .wr_pfull  ( ),                 // FIFO Parial Full
    .rd_empty  (fifo_empty_b ),     // FIFO Empty
    .rd_pempty ( ),                 // FIFO Partial Empty
    .rd_full   ( ),                 // FIFO Full 
    .rd_pfull  ( )                  // FIFO Partial Full 
     );
//VCS coverage on
endmodule : flex_e_1to1_rx_gearbox 

//------------------------------------------------------------------------------
// Module: flex_e_avst_elane_if
//
// This module implements a verilog AVST-IF for use with the Flex E gearbox.  
//------------------------------------------------------------------------------  
 module flex_e_avst_elane_tx_if  # (
    parameter DWIDTH = 264)
(
     input                    i_clk,            //  EHIP clock
     input                    i_rst_n,          // async reset for EHIP 
     input[5:0]               i_avst_latency,   // AVST latency in # of i_clk
     input                    i_avst_ready,     // AVST ready
     input[DWIDTH-1:0]        i_data_null,      // what to send if no data is available
     input                    i_data_available, // From BFM -- indicates i_data is valid
     input[DWIDTH-1:0]        i_data,           // BFM data to transmit
     input                    i_am_insert,      // BFM's am_insert  -- only valid when i_avst_ready=1

     output reg[DWIDTH-1:0]   o_avst_data,      // AVST data to DUT
     output reg               o_am_insert,      // to DUT 
     output reg               o_avst_valid      // when 1, o_data_x is valid    
);
//VCS coverage off
    reg[63:0]              ready_shift_reg;
    reg[63:0]              am_shift_reg;
    reg[(DWIDTH*64)-1:0]   data_shift_reg;
    integer                i;

 
    always @ (posedge i_clk or negedge i_rst_n) begin   
        if (~i_rst_n) begin     
            ready_shift_reg <= 'h0;
            data_shift_reg  <= {(DWIDTH*64){1'b0}};
            am_shift_reg    <= 'h0;
        end
        else begin   
            // Delay pipes for AVST latency
            ready_shift_reg <= i_data_available ? {ready_shift_reg[62:0], i_avst_ready} : {ready_shift_reg[62:0], 1'b0}; 
            data_shift_reg  <= i_data_available ? {data_shift_reg[(DWIDTH*63)-1:0], i_data} : {data_shift_reg[(DWIDTH*63)-1:0], i_data_null};
            am_shift_reg    <= i_data_available ? {am_shift_reg[62:0], i_am_insert} : {am_shift_reg[62:0], 1'b0}; 
        end
    end

    always @ (*) begin
        for (i=0; i<64; i=i+1) begin
            if (i==0) begin    // zero latency
               o_avst_data  = i_data;
               o_avst_valid = i_avst_ready;
               o_am_insert  = i_am_insert;
            end
            else if (i_avst_latency == i) begin   // tap the data/valid off of the delay pipe, depending on the AVST latency value
                o_avst_data  = data_shift_reg[(DWIDTH*i) +: DWIDTH];
                o_avst_valid = ready_shift_reg[i];
                o_am_insert  = am_shift_reg[i];
            end
        end
    end
//VCS coverage on
endmodule : flex_e_avst_elane_tx_if

//------------------------------------------------------------------------------
// Module: flex_e_1to2_gearbox
//
// This module collects 2 cycles worth of data from i_clk_a, and gearboxes it to
// 2X the datawidth on i_clk_b.  
// An async FIFO is used to rate-match the i_clk_a and i_clk_b domains.  
//------------------------------------------------------------------------------ 
module flex_e_1to2_gearbox  # (
    parameter DWIDTH = 66,
    parameter AWIDTH = 6,
    //parameter SOURCE_FREQ_MHZ = 1562.5)
    parameter SOURCE_FREQ_MHZ = 781.25)
(
     input                       i_clk_a,            // EHIP clk x 2 x 64/66
     input                       i_rst_a_n,          // async reset  
     input[DWIDTH-1:0]           i_bfm_data,         // data input from OTN BFM
     input                       i_bfm_dvalid,       // when 1, i_bfm_data is valid  

     input                       i_clk_b,            // EHIP clk
     input                       i_rst_b_n,          // async reset  
     input                       i_pop,              // advances the look-ahead output 
     output[(DWIDTH*2)-1:0]      o_data,             // 132b data output
     output                      o_data_available,   // when 1, o_data_x is valid 
     output                      o_err_underflow,
     output                      o_err_overflow   
);
//VCS coverage off
    reg[(2*DWIDTH)-1:0]  data_shift_reg_a;        // collect 4 cycles worth of i_bfm_data before offloading 
    //reg[1:0]             data_count_a;            // number of i_bfm_data received in data_shift_reg_a
    reg             data_count_a;            // number of i_bfm_data received in data_shift_reg_a
    reg[(2*DWIDTH)-1:0]  fifo_wrdata_a;
    reg                  fifo_wr_en_a;
    wire                 fifo_full_a;
    reg                  rd_domain_active_sync_a;      // means the Read domain is out of reset & popping data
                                                       // hold off the writes until read domain is active - to prevent overflow
    reg                  rd_domain_active_meta_a;      // meta stage

    wire                 fifo_empty_b;  
    reg                  allow_reads_b;
    wire[AWIDTH-1:0]     fifo_count_b;
    wire                 fifo_rd_b;
    reg                  rd_domain_active_b;

    wire[65:0]           debug_out_data_0;   // lowest 66b chunk of o_data
    wire[65:0]           debug_out_data_1;   
   // wire[65:0]           debug_out_data_2;
   // wire[65:0]           debug_out_data_3;    // highest 66b chunk of o_data

    wire[63:0]           debug_out_data64_0;   // lowest 64b chunk of o_data -- sync bits stripped off
    wire[63:0]           debug_out_data64_1;   
  //  wire[63:0]           debug_out_data64_2;
  //  wire[63:0]           debug_out_data64_3;   // highest 64b chunk of o_data


    assign debug_out_data_0 = o_data[0*66 +: 66];
    assign debug_out_data_1 = o_data[1*66 +: 66];   
  //  assign debug_out_data_2 = o_data[2*66 +: 66];
 //   assign debug_out_data_3 = o_data[3*66 +: 66];

    assign debug_out_data64_0 = o_data[((0*66)+2) +: 64];
    assign debug_out_data64_1 = o_data[((1*66)+2) +: 64];   
 //   assign debug_out_data64_2 = o_data[((2*66)+2) +: 64];
 //   assign debug_out_data64_3 = o_data[((3*66)+2) +: 64];

    initial begin
       data_count_a     = 1'b0; 
       data_shift_reg_a = 'h0; 
       fifo_wr_en_a     = 1'b0; 
       fifo_wrdata_a    = 'h0;        
    end
    
    assign o_err_overflow = fifo_wr_en_a && fifo_full_a;
    always @ (posedge i_clk_a or negedge i_rst_a_n) begin   // 1562.5MHz
        if (~i_rst_a_n) begin
            data_count_a      <= 1'b0;  
            fifo_wr_en_a      <= 1'b0; 
            fifo_wrdata_a     <= 'h0;
            rd_domain_active_meta_a <= 1'b0;
            rd_domain_active_sync_a <= 1'b0;
        end
        else begin
            rd_domain_active_meta_a <=  rd_domain_active_b;
            rd_domain_active_sync_a <=  rd_domain_active_meta_a;        
            if (i_bfm_dvalid && rd_domain_active_sync_a) begin    // do not start write domain until read domain is active
                data_count_a      <= data_count_a + 1'b1;                              // count # of data cycles received 
                fifo_wr_en_a      <= (data_count_a==1'b1);
                fifo_wrdata_a     <= {i_bfm_data, fifo_wrdata_a[DWIDTH +:(1*DWIDTH)]};  // first data on line is rightmost
            end 
            else begin
                fifo_wr_en_a <= 1'b0;
            end
        end
    end
   
    always @ (posedge i_clk_b or negedge i_rst_b_n) begin   // 390Mhz
        if (~i_rst_b_n) begin 
            allow_reads_b <= 1'b0; 
            rd_domain_active_b <= 1'b0;
        end
        else begin 
            rd_domain_active_b  <= i_pop ? 1'b1 : rd_domain_active_b;
            allow_reads_b <= (fifo_count_b > 1'b1) ? 1'b1 : allow_reads_b;  // allow reads once we receive some minimum # of entries
                                                                            // thereafter, the FIFO should never go empty
           
        end
    end 
 
    assign o_data_available = fifo_rd_b;
    assign fifo_rd_b = allow_reads_b && ~fifo_empty_b && i_pop;    
    assign o_err_underflow = i_pop && fifo_empty_b;              // means input bandwidth could not keep up with output
 

   
    c2_c3lib_async_fifo #( .DWIDTH (2*DWIDTH),                      // FIFO Input data width 
                        .AWIDTH (AWIDTH),                        // FIFO Depth (address width)
                        .DST_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ/2),   // Clock frequency for destination domain in MHz
                        .SRC_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ)      // Clock frequency for source domain in MHz

     ) u_fifo ( 
    .wr_rst_n (i_rst_a_n ),                    // Write Domain Active low Reset
    .wr_clk   (i_clk_a ),                      // Write Domain Clock
    .wr_en    (fifo_wr_en_a && !fifo_full_a),  // Write Data Enable
    .wr_data  (fifo_wrdata_a ),                // Write Data In
    .rd_rst_n (i_rst_b_n ),                    // Read Domain Active low Reset
    .rd_clk   (i_clk_b ),                      // Read Domain Clock
    .rd_en    (fifo_rd_b ),                    // Read Data Enable
    .r_pempty ({AWIDTH{1'b0}}  ),              // FIFO partially empty threshold
    .r_pfull  ({AWIDTH{1'b1}}  ),              // FIFO partially full threshold
    .r_empty  ({AWIDTH{1'b0}}  ),              // FIFO empty threshold
    .r_full   ({AWIDTH{1'b1}}  ),              // FIFO full threshold
    
    .rd_data    (o_data),           // Read Data Out 
    .rd_numdata (fifo_count_b ),    // Number of Data available in Read clock
    .wr_numdata ( ),                // Number of Data available in Write clock 
    
    .wr_empty  (  ),                // FIFO Empty
    .wr_pempty ( ),                 // FIFO Partial Empty
    .wr_full   (fifo_full_a ),      // FIFO Full
    .wr_pfull  ( ),                 // FIFO Parial Full
    .rd_empty  (fifo_empty_b ),     // FIFO Empty
    .rd_pempty ( ),                 // FIFO Partial Empty
    .rd_full   ( ),                 // FIFO Full 
    .rd_pfull  ( )                  // FIFO Partial Full 
     );
//VCS coverage on
endmodule : flex_e_1to2_gearbox 


//------------------------------------------------------------------------------
// Module: flex_e_4to1_gearbox
//
// This module collects 1 cycle of data from i_clk_a, and gearboxes it to
// 1/2 the datawidth @ 2X the frequency on i_clk_b..  
//   
//------------------------------------------------------------------------------  
 module flex_e_2to1_gearbox  # (
    parameter DWIDTH = 66,
    parameter AWIDTH = 6,
    parameter SOURCE_FREQ_MHZ = 390
)
(
     input                    i_clk_a,       // EHIP clk
     input                    i_rst_a_n,     // async reset  
     input[(DWIDTH*2)-1:0]    i_data,        // 132b data input -- first quad on line is right-most
     input                    i_dvalid,      // when 1, i_data is valid   

     input                    i_clk_b,       // EHIP clk x 2 x 64/66
     input                    i_rst_b_n,     // async reset  
     output reg[DWIDTH-1:0]   o_bfm_data,    // 66b data output
     output reg               o_bfm_dvalid,  // when 1, o_data_x is valid    
     output                   o_err_overflow 
);
//VCS coverage off
    wire                 fifo_full_a;
    reg                  rd_domain_active_sync_a;      // means the Read domain is out of reset & popping data
                                                       // hold off the writes until read domain is active - to prevent overflow
    reg                  rd_domain_active_meta_a;      // meta stage

    //reg[1:0]             data_count_b;     // keep track of which quad of data is being forwarded
    reg             data_count_b;     // keep track of which quad of data is being forwarded
    wire                 fifo_empty_b;
    wire[(DWIDTH*2)-1:0] fifo_rddata_b;  
    reg[(DWIDTH*2)-1:0]  fifo_rddata_hold_b; 
    wire                 fifo_rd_b;
    reg                  rd_domain_active_b; 
    reg                  burst_b; 
    wire[AWIDTH-1:0]     rd_numdata_b;

    wire[65:0]           debug_in_data_0;   // lowest 66b chunk of o_data
    wire[65:0]           debug_in_data_1;   
    //wire[65:0]           debug_in_data_2;
    //wire[65:0]           debug_in_data_3;    // highest 66b chunk of o_data

    wire[63:0]           debug_in_data64_0;   // lowest 64b chunk of o_data -- sync bits stripped off
    wire[63:0]           debug_in_data64_1;   
    //wire[63:0]           debug_in_data64_2;
    //wire[63:0]           debug_in_data64_3;   // highest 64b chunk of o_data

    wire[63:0]           debug_out_data64;

    reg[9:0]             debug_count_clka;
    reg[9:0]             debug_count_clkb;

    initial begin
        debug_count_clka = 0;
        debug_count_clkb = 0;
    end
    always @ (posedge i_clk_a) debug_count_clka <= (debug_count_clka=='d66) ? debug_count_clka : (debug_count_clka + 1);
    always @ (posedge i_clk_b) debug_count_clkb <= (debug_count_clkb=='d256) ? debug_count_clkb : (debug_count_clkb + 1);

    assign debug_in_data_0 = i_data[0*66 +: 66];
    assign debug_in_data_1 = i_data[1*66 +: 66];   
    //assign debug_in_data_2 = i_data[2*66 +: 66];
    //assign debug_in_data_3 = i_data[3*66 +: 66];

    assign debug_in_data64_0 = i_data[((0*66)+2) +: 64];
    assign debug_in_data64_1 = i_data[((1*66)+2) +: 64];   
    //assign debug_in_data64_2 = i_data[((2*66)+2) +: 64];
    //assign debug_in_data64_3 = i_data[((3*66)+2) +: 64];

    assign debug_out_data64 = o_bfm_data[65:2];

    initial begin
       data_count_b       = 1'b0;
       fifo_rddata_hold_b = 'h0;
       o_bfm_dvalid       = 1'b0;
       o_bfm_data         = 'h0;
    end

    always @ (posedge i_clk_a or negedge i_rst_a_n) begin   // 1562.5MHz
        if (~i_rst_a_n) begin 
            rd_domain_active_meta_a <= 1'b0;
            rd_domain_active_sync_a <= 1'b0;
        end
        else begin
            rd_domain_active_meta_a <=  rd_domain_active_b;
            rd_domain_active_sync_a <=  rd_domain_active_meta_a;    
        end
    end
    
    assign o_err_overflow = i_dvalid && fifo_full_a;

    always @ (posedge i_clk_b or negedge i_rst_b_n) begin  // 1562.5Mhz 
        if (~i_rst_b_n) begin 
            data_count_b       <= 1'b0; 
            fifo_rddata_hold_b <= 'h0;
            o_bfm_dvalid       <= 1'b0; 
            o_bfm_data         <= 'h0;
            rd_domain_active_b <= 1'b0;
            burst_b            <= 1'b0; 
        end
        else begin  
            rd_domain_active_b <= 1'b1; 
            data_count_b       <= (fifo_rd_b || burst_b) ? (data_count_b + 1'b1) : data_count_b;   // when data_count_b=0, wait for fifo_rd.  else, burst data out.
            burst_b            <= fifo_rd_b ? 1'b1 : (data_count_b == 1'b1) ? 1'b0 : burst_b;
            fifo_rddata_hold_b <= fifo_rd_b ? fifo_rddata_b : fifo_rddata_hold_b; 
            o_bfm_dvalid       <= fifo_rd_b || burst_b;
            case (data_count_b)          // TDM out the data  
                2'h0:  o_bfm_data <= fifo_rddata_b[DWIDTH*0 +: DWIDTH];                                
                2'h1:  o_bfm_data <= fifo_rddata_hold_b[DWIDTH*1 +: DWIDTH];
                //2'h2:  o_bfm_data <= fifo_rddata_hold_b[DWIDTH*2 +: DWIDTH];
                //2'h3:  o_bfm_data <= fifo_rddata_hold_b[DWIDTH*3 +: DWIDTH];
                default:  o_bfm_data <= 'h0;
            endcase             
        end
    end

    assign fifo_rd_b = (data_count_b == 1'b0) && ~fifo_empty_b ;
  
    // This is a look-ahead FIFO 
    c2_c3lib_async_fifo #( .DWIDTH (2*DWIDTH),                    // FIFO Input data width 
                        .AWIDTH (AWIDTH),                      // FIFO Depth (address width)
                        .DST_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ),   // Clock frequency for destination domain in MHz
                        .SRC_CLK_FREQ_MHZ (SOURCE_FREQ_MHZ/2)  // Clock frequency for source domain in MHz

     ) u_fifo ( 
    .wr_rst_n (i_rst_a_n ),                // Write Domain Active low Reset
    .wr_clk   (i_clk_a ),                  // Write Domain Clock
    .wr_en    (i_dvalid && !fifo_full_a && rd_domain_active_sync_a),  // Write Data Enable
    .wr_data  (i_data ),                   // Write Data In
    .rd_rst_n (i_rst_b_n ),                // Read Domain Active low Reset
    .rd_clk   (i_clk_b ),                  // Read Domain Clock
    .rd_en    (fifo_rd_b ),                // Read Data Enable
    .r_pempty ({AWIDTH{1'b0}} ),           // FIFO partially empty threshold
    .r_pfull  ({AWIDTH{1'b0}} ),           // FIFO partially full threshold
    .r_empty  ({AWIDTH{1'b0}} ),           // FIFO empty threshold
    .r_full   ({AWIDTH{1'b1}} ),           // FIFO full threshold
    
    .rd_data    (fifo_rddata_b ),   // Read Data Out 
    .rd_numdata (rd_numdata_b ),    // Number of Data available in Read clock
    .wr_numdata ( ),                // Number of Data available in Write clock 
    
    .wr_empty  (  ),                // FIFO Empty
    .wr_pempty ( ),                 // FIFO Partial Empty
    .wr_full   (fifo_full_a ),      // FIFO Full
    .wr_pfull  ( ),                 // FIFO Parial Full
    .rd_empty  (fifo_empty_b ),     // FIFO Empty
    .rd_pempty ( ),                 // FIFO Partial Empty
    .rd_full   ( ),                 // FIFO Full 
    .rd_pfull  ( )                  // FIFO Partial Full 
     );
//VCS coverage on
endmodule : flex_e_2to1_gearbox 
