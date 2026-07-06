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


`timescale 1ns / 1ns

module alt_em10g32_std_synchronizer (
                                clk, 
                                reset_n, 
                                din, 
                                dout
                                );

    // GLOBAL PARAMETER DECLARATION
    parameter depth = 3; // This value must be >= 2 !
    parameter rst_value = 0;

    // INPUT PORT DECLARATION 
    input   clk;
    input   reset_n;    
    input   din;

    // OUTPUT PORT DECLARATION 
    output  dout;

    altera_std_synchronizer_nocut #(
        .depth(depth),
        .rst_value(rst_value)
    ) std_sync_no_cut (
        .clk        (clk),
        .reset_n    (reset_n),
        .din        (din),
        .dout       (dout)
    );
   
endmodule  // alt_em10g32_std_synchronizer
// END OF MODULE
                        
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "hhHrmD23DhpZS+BnEXgTmm77LvJsnMkKLtUYhXuD/CH9hNxze5JVhFzKYAx8yfBiDSU9XwcLX1rP5qptau165gnqPKnRRR3mDVYIplbnly03Qh1/tRXzu2dmF7mZniN0YvWHx6aHAjsaaESImRa+RxJwo6wbN6kjJZGjcCzeGszmpNpzf1s05uESQUJsYGGStdkZHrjsGYrEgadkS1eKIVnUuBAVs6JIbibVTzssDvID38ceQx89LYQ+4IyA5Yhkd+3+JJ2U1nktlYasHMqKyypzuR9q79PK9Ai/Ct6rvM3oXgMXzO5dmF3ygRZKGka7O5keDVGxHdCIRcyeOiHxxsQ3JzgG/hGqgJCfPXcWbCWhAroPJLnkogoE8d7p6AqypQK03pqD1dMtLjnSPMyI7WXdzBL4kU7NbXCxEm1QH24QSqkT7MFFcOo1OukjtYf4YzwWatsgjF2UUJNs4ISJdWCeVd10Qv5AK4BxbngyqI6Heap5Y+wclOxbdcUK4Mth43nR5OPPLEx72qnLmFfoYG6jE8JnNjiV/d5Y3XmB+K0urJ73Ul67VaTZHW9hzMMv66391yNWi+8UpPfTGnAWLWezatYk7Q4W0/vhsjjTm08tNmFxdWKDIqfsF915Nf9sSiajH3F07RZ+j7bzyfRfNThY54Py2vFUKszhpqXmiZW85fDyeLEl/tXCUA0Fmjvu+8XXs3eQwO5I1gR/BI8GhOib3aqn+ciqLsroP5ArtjCBKUiBuUyuclaMNJ+0BL8Wctbtl0D9cgls/y2piBck7ARwqRNI/ckXp4/mNZve4QXW69yW6nIM2rR9rVESBUrc23WkRrtsmlrv+Q/kvpRN7SJqMWRF2YuOJO9VEQK9ikBXeyo4sUvDHlEN5gpCrlo5DQM/yYTsqWpt8/qjdo+EU4/ZBfh459DBEaNv2ilKcHgiCOQzSuL209j4TjALBKvZ5qytt+88evLX6rYSyayBm3bTL4/NqSTUSQ36hpSd+5axzQMIVgYiVt/8XU/dja0y"
`endif