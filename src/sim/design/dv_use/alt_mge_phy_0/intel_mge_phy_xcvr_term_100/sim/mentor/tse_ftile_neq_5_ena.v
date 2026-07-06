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


`timescale 1 ps / 1 ps

// force the decomposition of 5 bit FIFO pointer compare with enable

module tse_ftile_neq_5_ena #(
    parameter SIM_EMULATE = 1'b0
)(
    input [4:0] da,
    input [4:0] db,
    input ena,
    output eq
);

wire w0_o;
tse_ftile_lut6 w0 (
    // .a(da[0]),
    // .b(da[1]),
    // .c(da[2]),
    // .d(db[0]),
    // .e(db[1]),
    // .f(db[2]),
    .din  ({db[2:0],da[2:0]}),
    .dout (w0_o)
);
defparam w0 .SIM_EMULATE = SIM_EMULATE;
defparam w0 .MASK = 64'h8040201008040201; // {a,b,c} == {d,e,f}
    
tse_ftile_lut6 w1 (
    // .a(ena),
    // .b(da[3]),
    // .c(da[4]),
    // .d(db[3]),
    // .e(db[4]),
    // .f(w0_o),
    .din({w0_o,db[4:3],da[4:3],ena}),
    .dout (eq)
);
defparam w1 .SIM_EMULATE = SIM_EMULATE;
defparam w1 .MASK = 64'h2a8aa2a8aaaaaaaa; // (!({b,c} == {d,e}) || !f) && a;
    

endmodule
// BENCHMARK INFO :  10AX115R2F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 13.1a10.0 Build 343 10/23/2013 SJ Full Version
// BENCHMARK INFO :  Total registers : 0
// BENCHMARK INFO :  Total pins : 12
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  3              
// BENCHMARK INFO :  ALMs : 3 / 427,200 ( < 1 % )
