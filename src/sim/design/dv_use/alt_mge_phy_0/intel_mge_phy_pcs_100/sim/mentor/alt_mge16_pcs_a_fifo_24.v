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
// Programmable (Synchronous / Asyncronous) FIFO with Section Flags
// 
//    FIFO Name Coding:
//    ----------------
// 
//       1:      Full
//       2:      Amost Full
//       3       Empty
//       4:      Almost Empty
// 
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_a_fifo_24 (

   reset_wclk,
   reset_rclk,
   wclk,
   wclk_ena,
   wren,
   din,
   rclk,
   rclk_ena,
   rden,
   dout,
   afull,
   aempty,
   af_threshold,
   ae_threshold,

   calc_clk,
   reset_calc_clk,
   clk_125,
   reset_clk_125,
   latadj
);

parameter FF_WIDTH      = 3'b 100;
parameter ADDR_WIDTH    = 3'b 111;
parameter DEPTH         = 8'b 10000000;
parameter SAMPLE_SIZE   = 0;
parameter DEVICE_FAMILY = "Arria 10";

input   reset_wclk; 
input   reset_rclk; 
input   wclk; 
input   wclk_ena;
input   wren; 
input   [FF_WIDTH - 1:0] din; 
input   rclk; 
input   rclk_ena;
input   rden; 
output  [FF_WIDTH - 1:0] dout; 
output  afull; 
output  aempty; 
input   [ADDR_WIDTH - 1:0] af_threshold;
input   [ADDR_WIDTH - 1:0] ae_threshold;

input   calc_clk;
input   reset_calc_clk;
input   clk_125;
input   reset_clk_125;
output  [11:0] latadj;

wire    [FF_WIDTH - 1:0] dout;
wire    [FF_WIDTH - 1:0] w_dout;
wire    afull; 
wire    aempty; 
wire    [ADDR_WIDTH - 1:0] wr_b_ptr; 
wire    [ADDR_WIDTH - 1:0] wr_g_ptr; 
wire    [ADDR_WIDTH - 1:0] rd_g_wptr_sync2;
wire    [ADDR_WIDTH - 1:0] rd_g_wptr;
(* syn_preserve = 1 *)reg     [ADDR_WIDTH - 1:0] rd_b_wptr; 
reg     [ADDR_WIDTH - 1:0] ptr_wck_diff; 
wire    [ADDR_WIDTH - 1:0] rd_b_ptr; 
wire    [ADDR_WIDTH - 1:0] rd_g_ptr; 
wire    [ADDR_WIDTH - 1:0] wr_g_rptr_sync2;
wire    [ADDR_WIDTH - 1:0] wr_g_rptr;
(* syn_preserve = 1 *)reg     [ADDR_WIDTH - 1:0] wr_b_rptr; 
reg     [ADDR_WIDTH - 1:0] ptr_rck_diff; 
reg     afull_flag; 
reg     aempty_flag; 
wire    [ADDR_WIDTH - 1:0]  ff_rd_binval; 
integer loop_index1; 
integer loop_index2; 
wire    [ADDR_WIDTH - 1:0]  ff_wr_binval; 
reg             aempty_low_det;

parameter A_FF_24_HEX_MAX = {{(ADDR_WIDTH){1'b 1}}};

alt_mge16_pcs_sdpm_altsyncram #(FF_WIDTH,DEPTH,ADDR_WIDTH,DEVICE_FAMILY) U_RAM(
        .data(din),
        .rdaddress(rd_b_ptr),
        .rdclock(rclk),
        .wraddress(wr_b_ptr),
        .wrclock(wclk),
        .wren(wren),
        .q(w_dout));


alt_mge16_pcs_gray_cnt #(ADDR_WIDTH,DEPTH) U_WRT (

        .clk(wclk),
        .clkena(wclk_ena),
        .reset(reset_wclk),
        .enable(wren),
        .b_out(wr_b_ptr),
        .g_out(wr_g_ptr));

alt_mge16_pcs_gray_cnt #(ADDR_WIDTH,DEPTH) U_RD (

        .clk(rclk),
        .clkena(rclk_ena),
        .reset(reset_rclk),
        .enable(rden),
        .b_out(rd_b_ptr),
        .g_out(rd_g_ptr));

assign rd_g_wptr = rd_g_wptr_sync2;
assign ff_rd_binval[ADDR_WIDTH-1]   = rd_g_wptr[ADDR_WIDTH-1] ;
assign ff_rd_binval[ADDR_WIDTH-2:0] = gray2bin(rd_g_wptr) ;

alt_mge_phy_std_synchronizer_bundle #(
    .width(ADDR_WIDTH),
    .depth(2)
) rd_g_ptr_sync (
    .clk        (wclk),
    .reset_n    (~reset_wclk),
    .din        (rd_g_ptr),
    .dout       (rd_g_wptr_sync2)
);

always @(posedge reset_wclk or posedge wclk)
   begin : ff_rd
   if (reset_wclk == 1'b 1)
      begin
      rd_b_wptr <= {(ADDR_WIDTH){1'b 0}};       
      end
   else
      begin
      rd_b_wptr <= ff_rd_binval;
      end
   end

//  Asynchronous FIFO, Gray Pointers are Used
//  -----------------------------------------

always @(posedge reset_wclk or posedge wclk)
   begin : ff_aff
   if (reset_wclk == 1'b 1)
      begin
      afull_flag <= 1'b 0;      
      end
   else
      begin
              if (ptr_wck_diff >= (A_FF_24_HEX_MAX - af_threshold))
                 begin
                 afull_flag <= 1'b 1;   
                 end
              else
                 begin
                 afull_flag <= 1'b 0;   
                 end
          end
   end

assign afull = afull_flag;

assign wr_g_rptr = wr_g_rptr_sync2;
assign ff_wr_binval[ADDR_WIDTH-1]   = wr_g_rptr[ADDR_WIDTH-1] ;
assign ff_wr_binval[ADDR_WIDTH-2:0] = gray2bin(wr_g_rptr) ;

alt_mge_phy_std_synchronizer_bundle #(
    .width(ADDR_WIDTH),
    .depth(2)
) wr_g_ptr_sync (
    .clk        (rclk),
    .reset_n    (~reset_rclk),
    .din        (wr_g_ptr),
    .dout       (wr_g_rptr_sync2)
);

always @(posedge reset_rclk or posedge rclk)
   begin : ff_wr
   if (reset_rclk == 1'b 1)
      begin
      wr_b_rptr <= {(ADDR_WIDTH){1'b 0}};       
      end
   else
      begin
      wr_b_rptr <= ff_wr_binval;
      end
   end

//  Asynchronous FIFO
//  -----------------

always @(posedge reset_rclk or posedge rclk)
   begin : aff_ef
   if (reset_rclk == 1'b 1)
      begin
      aempty_flag <= 1'b 1;     
      end
   else
      begin
          if (ptr_rck_diff < ae_threshold)
             begin
             aempty_flag <= 1'b 1;  
             end
          else
             begin
             aempty_flag <= 1'b 0;  
             end
          end
   end

assign aempty = aempty_flag;
 
always @(posedge reset_wclk or posedge wclk)
   begin : process_1
   if (reset_wclk == 1'b 1)
      begin
      ptr_wck_diff <= {(ADDR_WIDTH){1'b 0}};    
      end
   else
      begin
                  if (wclk_ena == 1'b1) begin
              ptr_wck_diff <= wr_b_ptr - rd_b_wptr;     
                  end
          end
end

always @(wr_b_rptr or rd_b_ptr)
   begin : process_2
   ptr_rck_diff = wr_b_rptr - rd_b_ptr; 
   end

always @(posedge reset_rclk or posedge rclk)
        begin
        if (reset_rclk == 1'b1)
                begin
                aempty_low_det <= 1'b0;
                end
        else
                begin
                if (aempty == 1'b0)
                aempty_low_det <= 1'b1;
                else
                aempty_low_det <= aempty_low_det;
                end
        end
        
assign dout = aempty_low_det? w_dout : {FF_WIDTH{1'b0}};

// Gray to Binary Conversion
// -------------------------

function [ADDR_WIDTH-2:0] gray2bin;

        input [ADDR_WIDTH-1:0]  gray_val ;
        
        integer LOOP_IDX1; 
        integer LOOP_IDX2;
                
        for (LOOP_IDX1 = 0; LOOP_IDX1 <= ADDR_WIDTH - 2; LOOP_IDX1 = LOOP_IDX1 + 1)
        begin
         
                gray2bin[LOOP_IDX1] = gray_val[LOOP_IDX1];      

                for (LOOP_IDX2 = ADDR_WIDTH - 1; LOOP_IDX2 >= LOOP_IDX1 + 1; LOOP_IDX2 = LOOP_IDX2 - 1)
                begin
            
                        gray2bin[LOOP_IDX1] = gray2bin[LOOP_IDX1] ^ gray_val[LOOP_IDX2];        
            
                end
                
        end
        
endfunction // for

   generate
      if (SAMPLE_SIZE > 0) begin : phase_calculator
         alt_mge16_pcs_ph_calculator #(
                                    .ADDR_WIDTH     (ADDR_WIDTH),  
                                    .SAMPLE_SIZE    (SAMPLE_SIZE)
                                    ) 
         ph_cal_inst (
                      .rd_clk         (rclk),
                      .reset_rd_clk   (reset_rclk),
                      .wr_clk         (wclk),
                      .reset_wr_clk   (reset_wclk),
                      .clk_125        (clk_125),       // mac_clk
                      .reset_clk_125  (reset_clk_125), // mac_clk_reset
                      .calc_clk       (calc_clk),
                      .reset_calc_clk (reset_calc_clk),
                      .rd_ptr         (rd_g_ptr),
                      .wr_ptr         (wr_g_ptr),
                      .latency_adj    (latadj)
                      );
      end else begin
         assign latadj = {(12){1'b0}};
      end
   endgenerate

endmodule // module a_fifo_24
