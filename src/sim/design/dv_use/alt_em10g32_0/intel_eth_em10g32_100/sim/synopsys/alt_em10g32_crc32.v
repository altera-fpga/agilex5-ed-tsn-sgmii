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


//////////////////////////////////////////////////////////////////////////////
// 
// Module: Altera Ethernet MAC 32-bit CRC32 Engine
//
// Description: 
//  * Source code from Martin Roberts on 26 Feb, 2013
//  * Calculate CRC32 of input frames
//  * Latency from EOP to CRC Valid is 5 clock cycles
//  * Reuse in both TX and RX data path
//
// Parameter: 
//  * PRELOAD = Do not change
//
// Ports:
//  * input  wire         clk       : Input clock running at 312.5 MHz
//  * input  wire         rst_n     : Active low reset signal
//  * input  wire         clken     : Clock enabled
//                                    10G        : Could be tied to 1'b1
//                                    10M/100M/1G: Asserted when data is valid.
//                                                 After EOP, must remain asserted until crc_valid asserted
//  * input  wire         sop       : Start of Packet
//  * input  wire         eop       : End of Packet
//  * input  wire   [1:0] mty       : Avalon-ST Emtpy
//  * input  wire  [31:0] data      : Frame data
//  * output wire  [31:0] crc_out   : CRC output. Valid if crc_valid = 1'b1
//  * output reg          crc_valid : Indicates CRC is valid (5 clock cycles from EOP)
//  * output reg          crc_good  : Indicates receive packet has good CRC. valid if crc_valid = 1'b1
//
//////////////////////////////////////////////////////////////////////////////

/*
- for 32 bit data, d32_n = {data[31:0]}
crc_i = 0x46af6449
crc_0 = crc_i (x) a32 (+) d32_0
crc_1 = crc_0 (x) a32 (+) d32_1
,,,
crc_n = crc_n-1 (x) a32 (+) d32_n



pipelining
crc_ii =
crc_i = 0x46af6449
d32_i = 0
crc_0 = crc_ii  (x) a64 (+) d32_i   (x) a32 (+) d32_0
crc_1 = crc_i   (x) a64 (+) d32_0   (x) a32 (+) d32_1
crc_2 = crc_0   (x) a64 (+) d32_1   (x) a32 (+) d32_2
crc_3 = crc_1   (x) a64 (+) d32_2   (x) a32 (+) d32_3
,,,
crc_n = crc_n-2 (x) a64 (+) d32_n-1 (x) a32 (+) d32_n



*/
/*

                                            m2
                   +--------------------------------------------------------------+
                   |       __________ __             _________                    |
                   |      |          |  |           |      |  |                   |
                   +--/---|  a^64    |  |-----------|      |  |                   |
                     32   |          |  |   m3      |      |  |                   |
                          |          |  |           |      |  |                   |     |    ____                                             _
                          |          |  |           |      |  |                   |     +   |    |                                          -| \
                          |          |  |           |      |  |                   |     +---| == |-                                         -|  \
                          |          |  |           |      |  |                   |     |   |____|                                           |   \
                          |__________|>_|           |      |  |                   |     |    ____                                            |    \
                                                    |      |  |                   |     +   |    |                                          -|     |
                                    m2c             |      |  |                   |     +---| == |-               __                        -|     |     __
                           __________ __            |      |  |                   |     |    ____               -|  |-                       |     >----|  |--- good
                          |          |  |           |      |  |                   |     |   |    |               |>_|                       -|     |    |>_|
                          |  a^32    |  |-----------| (+)  |  |-------------------+     +---| == |-                                         -|     |
                          |          |  |   data2   |      |  |  m2               |     |   |____|                                           |     |
                          |          |  |           |      |  |  crc2             |     |    ____                                            |    /
               __         |          |  |           |      |  |                   |     |   |    |                                          -|   /
              |  |        |          |  |           |      |  |                   |     +---| == |-                                         -|  /
  d[31:00] -- |  |--+-/---|          |  |           |      |  |                   |     |   |____|                                           |_/
  (MSB)       |>_|  |32   |__________|>_|           |      |  |                   |
                    |                               |      |  |                   |
    data0           |data1      data1c              |      |  |                   |    __________       _                    __________       _
                    |                               |      |  |                   |   |          |     | \                  |          |     | \     +----------------- crc3c
                    +-------------------------------|      |  |                   +---|  a^24    |-----|  \             +---|  a^8     |-----|  \    |
                                            data1   |      |  |                   |   |__________|     |   \      __    |   |__________|     |   \   |  __
                                                    |______|>_|                   |                    |    \    |  |   |                    |    \  | |  |
                                                          m2c                     +--------------------|     >---|  |---+--------------------|     >-+-|  |----------+- crc4
                                                                                                       |    /    |>_|   |    __________      |    /    |>_|          |
                                                                                                       |   /            |   |          |     |   /                   |
                                                                                                       |  /             +---|  a^-8    |-----|  /                    |
                                                                                                       |_/                  |__________|     |_/                     +- crc_out
                                                                                                            crc2c   crc3                          crc3c  crc4           (inverted, bit-reversed)


*/

`timescale 1 ps / 1 ps

module alt_em10g32_crc32 (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         clken,
    input  wire         sop,                 //1 on the first word of the packet, ldat is valid, 1st 64 bit word is also valid
    input  wire         eop,                 //1 on the last word of the packet; only used to time the valid out
    input  wire   [1:0] mty,                 //1 if the data word only has 32 bits valid
    input  wire  [31:0] data,
    output wire  [31:0] crc_out,             //inverted and bit-reversed
    output reg          crc_valid,
    output reg          crc_good
);
//parameter PRELOAD = 32'hffffffff;           // if 1st word is 32 bit, then = ffffffff (x) a0 = ffffffff

//if the initial 32 bit value is not required, then use
parameter PRELOAD = 32'h46af6449;          // ffffffff (x) a-32 = 46af6449
parameter ASYNC_RESET = 1'b0;

reg         eop1;
reg         eop2;
reg         eop3;
reg   [1:0] mty1;
reg   [1:0] mty2;
reg   [1:0] mty3;
reg   [1:0] mty4;
wire [31:0] data0;
wire [31:0] data0c;
reg  [31:0] data1;
wire [31:0] data1c;
reg  [31:0] data2;


wire [31:0] m2c;
reg  [31:0] m2;
reg  [31:0] m3;

reg         crc_valid_4;

reg  [31:0] crc2;
wire [31:0] crc2_24c;
wire [31:0] crc2_0;
wire [31:0] crc2c;
reg  [31:0] crc3;
wire [31:0] crc3_8c;
wire [31:0] crc3_0;
wire [31:0] crc3_m8c;
wire [31:0] crc3c;
reg  [31:0] crc4;

wire        good2_0c;
wire        good2_1c;
wire        good2_2c;
wire        good2_3c;

reg         good3_0;
reg         good3_1;
reg         good3_2;
reg         good3_3;

reg         good4_0;
reg         good4_1;
reg         good4_2;
reg         good4_3;



//mask the input data
assign data0 = (eop & (mty == 2'h3)) ? data & 32'hff000000
             : (eop & (mty == 2'h2)) ? data & 32'hffff0000
             : (eop & (mty == 2'h1)) ? data & 32'hffffff00
             : (eop & (mty == 2'h0)) ? data & 32'hffffffff
             :                         data;

//bitreverse the data bytes
assign data0c = {
                data0[ 24],data0[ 25],data0[ 26],data0[ 27],data0[ 28],data0[ 29],data0[ 30],data0[ 31],
                data0[ 16],data0[ 17],data0[ 18],data0[ 19],data0[ 20],data0[ 21],data0[ 22],data0[ 23],
                data0[  8],data0[  9],data0[ 10],data0[ 11],data0[ 12],data0[ 13],data0[ 14],data0[ 15],
                data0[  0],data0[  1],data0[  2],data0[  3],data0[  4],data0[  5],data0[  6],data0[  7]
               };

//invert, bitreverse the answer bytes
assign crc_out  = {
                ~crc4[24],~crc4[25],~crc4[26],~crc4[27],~crc4[28],~crc4[29],~crc4[30],~crc4[31],
                ~crc4[16],~crc4[17],~crc4[18],~crc4[19],~crc4[20],~crc4[21],~crc4[22],~crc4[23],
                ~crc4[ 8],~crc4[ 9],~crc4[10],~crc4[11],~crc4[12],~crc4[13],~crc4[14],~crc4[15],
                ~crc4[ 0],~crc4[ 1],~crc4[ 2],~crc4[ 3],~crc4[ 4],~crc4[ 5],~crc4[ 6],~crc4[ 7]
               };


// 32 bit input, 1 input fixed = a = a^64
alt_em10g32_crc32_gf_mult32_kc #(
    .data_width (32),
    .k          (64)
)gf_mult32_64(
    .d          (m2),
    .m          (m2c)
);


// 32 bit input, 1 input fixed = a = a^32
alt_em10g32_crc32_gf_mult32_kc #(
    .data_width (32),
    .k          (32)
)gf_mult32_32(
    .d          (data1[31:0]),
    .m          (data1c)
);



// 32 bit input, 1 input fixed = a = a^24
alt_em10g32_crc32_gf_mult32_kc #(
    .data_width (32),
    .k          (24)
)gf_mult32_24(
    .d          (crc2),
    .m          (crc2_24c)
);

// 32 bit input, 1 input fixed = a = a^0
assign crc2_0 = crc2;


// 32 bit input, 1 input fixed = a = a^8
alt_em10g32_crc32_gf_mult32_kc #(
    .data_width (32),
    .k          (8)
)gf_mult32_8(
    .d          (crc3),
    .m          (crc3_8c)
);

// 32 bit input, 1 input fixed = a = a^0
assign crc3_0 = crc3;


// 32 bit input, 1 input fixed = a = a^-8
alt_em10g32_crc32_gf_mult32_kc #(
    .data_width (32),
    .k          (-8)
)gf_mult32_m8(
    .d          (crc3),
    .m          (crc3_m8c)
);

// seperate data to annother always block
always @ (posedge clk) begin
    if (clken) begin
    data1 <= (sop) ? 32'hffffffff^data0c : data0c;
    crc3 <= crc2c;
    crc4 <= crc3c;
        if (sop) begin //use sload term
        data2 <= 32'h00000000;
        m2 <= 32'h00000000;
        m3 <= 32'h00000000;
        end
        else begin
        data2 <= data1c;
        m2 <= m3 ^ data2 ^ data1;
        m3 <= m2c;
        end   
    crc_good <= (mty4[1:0] == 2'b00) ? good4_0
                      : (mty4[1:0] == 2'b01) ? good4_1
                      : (mty4[1:0] == 2'b10) ? good4_2
                      : (mty4[1:0] == 2'b11) ? good4_3
                      : 1'b0;        
    end    
end
 

// SYNC_RESET FLOPS
generate
if (ASYNC_RESET == 1'b0) begin
    always @ (posedge clk) begin
        if (!rst_n) begin
            eop1 <= 1'b0;
            eop2 <= 1'b0;
            eop3 <= 1'b0;
            mty1 <= 2'b00;
            mty2 <= 2'b00;
            mty3 <= 2'b00;
            mty4 <= 2'b00;
            // data2 <= 32'h0;
            // m2 <= 32'h00000000;
            // m3 <= 32'h00000000;
            crc2 <= 32'h00000000;
            // crc3 <= 32'h00000000;
            // crc4 <= 32'h00000000;
            crc_valid_4 <= 1'b0;
            crc_valid <= 1'b0;
            // crc_good <= 1'b0;
    
            good3_0 <= 1'b0;
            good3_1 <= 1'b0;
            good3_2 <= 1'b0;
            good3_3 <= 1'b0;
            good4_0 <= 1'b0;
            good4_1 <= 1'b0;
            good4_2 <= 1'b0;
            good4_3 <= 1'b0;
    
            // data1 <= 0;
        end
        else begin
            if (clken) begin
                // data1 <= (sop) ? 32'hffffffff^data0c : data0c;
                
                eop1 <= eop;
                eop2 <= eop1;
                eop3 <= eop2;
                if (eop & ~eop1) mty1 <= mty;
                mty2 <= mty1;
                mty3 <= mty2;
                mty4 <= mty3;
    
    
                // data2 <= data1c;
                // m3 <= m2c;
    
                /* if (sop) begin //use sload term
                    m2 <= 32'h00000000;
                    // data2 <= 32'h00000000;
                    m3 <= 32'h00000000;
                end
                else begin
                    m2 <= m3 ^ data2 ^ data1;
                end */
                if (eop1) begin
                    crc2 <= m3 ^ data2 ^ data1;
                end
    
                // crc3 <= crc2c;
                // crc4 <= crc3c;
    
                good3_0 <= good2_0c;
                good3_1 <= good2_1c;
                good3_2 <= good2_2c;
                good3_3 <= good2_3c;
    
                good4_0 <= good3_0;
                good4_1 <= good3_1;
                good4_2 <= good3_2;
                good4_3 <= good3_3;
    
                crc_valid_4 <= eop3;
                crc_valid <= crc_valid_4;
    
                // crc_good <= (mty4[1:0] == 2'b00) ? good4_0
                          // : (mty4[1:0] == 2'b01) ? good4_1
                          // : (mty4[1:0] == 2'b10) ? good4_2
                          // : (mty4[1:0] == 2'b11) ? good4_3
                          // : 1'b0;
            end
        end
    end
end else begin
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            eop1 <= 1'b0;
            eop2 <= 1'b0;
            eop3 <= 1'b0;
            mty1 <= 2'b00;
            mty2 <= 2'b00;
            mty3 <= 2'b00;
            mty4 <= 2'b00;
            // data2 <= 32'h0;
            // m2 <= 32'h00000000;
            // m3 <= 32'h00000000;
            crc2 <= 32'h00000000;
            // crc3 <= 32'h00000000;
            // crc4 <= 32'h00000000;
            crc_valid_4 <= 1'b0;
            crc_valid <= 1'b0;
            // crc_good <= 1'b0;
    
            good3_0 <= 1'b0;
            good3_1 <= 1'b0;
            good3_2 <= 1'b0;
            good3_3 <= 1'b0;
            good4_0 <= 1'b0;
            good4_1 <= 1'b0;
            good4_2 <= 1'b0;
            good4_3 <= 1'b0;
    
            // data1 <= 0;
        end
        else begin
            if (clken) begin
                // data1 <= (sop) ? 32'hffffffff^data0c : data0c;
                
                eop1 <= eop;
                eop2 <= eop1;
                eop3 <= eop2;
                if (eop & ~eop1) mty1 <= mty;
                mty2 <= mty1;
                mty3 <= mty2;
                mty4 <= mty3;
    
    
                // data2 <= data1c;
                // m3 <= m2c;
    
                /* if (sop) begin //use sload term
                    m2 <= 32'h00000000;
                    // data2 <= 32'h00000000;
                    m3 <= 32'h00000000;
                end
                else begin
                    m2 <= m3 ^ data2 ^ data1;
                end */
                if (eop1) begin
                    crc2 <= m3 ^ data2 ^ data1;
                end
    
                // crc3 <= crc2c;
                // crc4 <= crc3c;
    
                good3_0 <= good2_0c;
                good3_1 <= good2_1c;
                good3_2 <= good2_2c;
                good3_3 <= good2_3c;
    
                good4_0 <= good3_0;
                good4_1 <= good3_1;
                good4_2 <= good3_2;
                good4_3 <= good3_3;
    
                crc_valid_4 <= eop3;
                crc_valid <= crc_valid_4;
    
                // crc_good <= (mty4[1:0] == 2'b00) ? good4_0
                          // : (mty4[1:0] == 2'b01) ? good4_1
                          // : (mty4[1:0] == 2'b10) ? good4_2
                          // : (mty4[1:0] == 2'b11) ? good4_3
                          // : 1'b0;
            end
        end
    end
end
endgenerate

//can pipeline this more to improve fmax
assign good2_0c = (crc2 == 32'hffffffff) ? 1'b1 : 1'b0;            //ffffffff (x) a0
assign good2_1c = (crc2 == 32'h4e08bfb4) ? 1'b1 : 1'b0;            //ffffffff (x) a8
assign good2_2c = (crc2 == 32'h00b7647d) ? 1'b1 : 1'b0;            //ffffffff (x) a16
assign good2_3c = (crc2 == 32'hb7647d00) ? 1'b1 : 1'b0;            //ffffffff (x) a24


//  3:    8 =     0  +8        8
//  2:   16 =   +24  -8       16
//  1:   24 =   +24  +0       24
//  0:   32 =   +24  +8       32

assign crc2c = (mty2[1:0] == 2'b00) ? crc2_24c
             : (mty2[1:0] == 2'b01) ? crc2_24c
             : (mty2[1:0] == 2'b10) ? crc2_24c
             : (mty2[1:0] == 2'b11) ? crc2_0
             : crc2_0;


assign crc3c = (mty3[1:0] == 2'b00) ? crc3_8c
             : (mty3[1:0] == 2'b01) ? crc3_0
             : (mty3[1:0] == 2'b10) ? crc3_m8c
             : (mty3[1:0] == 2'b11) ? crc3_8c
             : crc3_0;


endmodule
