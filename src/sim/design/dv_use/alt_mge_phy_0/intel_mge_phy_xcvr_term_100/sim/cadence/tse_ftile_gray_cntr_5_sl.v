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


`timescale 1ps/1ps

module tse_ftile_gray_cntr_5_sl #(
    parameter SLD_VAL = 5'h0,
    parameter SIM_EMULATE = 1'b0,
    parameter LOAD_IMPLIES_ENA = 1'b1
)(
    input clk,
    input ena,
    input sld,
    output [4:0] cntr
);

// wire [5:0] din = {1'b1,cntr};
wire [5:0] din = {cntr[0],cntr[1],cntr[2],cntr[3],cntr[4],1'b1};
wire [4:0] dout_w;

// tse_ftile_wys_lut w0 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[0]));
tse_ftile_lut6 w0 (.din(din[5:0]),.dout(dout_w[0]));
defparam w0 .MASK = 64'hc33c3cc3c33c3cc3;
defparam w0 .SIM_EMULATE = SIM_EMULATE;

// tse_ftile_wys_lut w1 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[1]));
tse_ftile_lut6 w1 (.din(din[5:0]),.dout(dout_w[1]));
defparam w1 .MASK = 64'h3cc33cc3ffff0000;
defparam w1 .SIM_EMULATE = SIM_EMULATE;

// tse_ftile_wys_lut w2 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[2]));
tse_ftile_lut6 w2 (.din(din[5:0]),.dout(dout_w[2]));
defparam w2 .MASK = 64'hff00ff00c3c3ff00;
defparam w2 .SIM_EMULATE = SIM_EMULATE;

// tse_ftile_wys_lut w3 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[3]));
tse_ftile_lut6 w3 (.din(din[5:0]),.dout(dout_w[3]));
defparam w3 .MASK = 64'hf0f0f0f0f0f033f0;
defparam w3 .SIM_EMULATE = SIM_EMULATE;

// tse_ftile_wys_lut w4 (.a(din[5]),.b(din[4]),.c(din[3]),.d(din[2]),.e(din[1]),.f(din[0]),.out(dout_w[4]));
tse_ftile_lut6 w4 (.din(din[5:0]),.dout(dout_w[4]));
defparam w4 .MASK = 64'hccccccccccccccf0;
defparam w4 .SIM_EMULATE = SIM_EMULATE;

wire mod_ena = LOAD_IMPLIES_ENA ? (sld | ena) : ena;

genvar i;

generate
for (i=0; i<5; i=i+1) begin : rl
        if(i == 0) begin
        dffeas df (.d(dout_w[i]),
                    .clk(clk),
                    .ena(mod_ena),
                    .sload(1'b0),
                    .sclr(1'b0),
                    .clrn(1'b1),
                    .prn(~sld),
                // synthesis translate off
                    .devclrn(1'b1),
                    .devpor(1'b1),
                // synthesis translate on                   
                    .asdata(1'b0),
                    .aload(1'b0),
                    .q(cntr[i])
        );
        defparam df .power_up = "low";
        defparam df .is_wysiwyg = "false";                  
        end else begin
        dffeas df (.d(dout_w[i]),
                    .clk(clk),
                    .ena(mod_ena),
                    .sload(1'b0),
                    .sclr(1'b0),
                    .clrn(~sld),
                    .prn(1'b1),
                // synthesis translate off
                    .devclrn(1'b1),
                    .devpor(1'b1),
                // synthesis translate on                   
                    .asdata(1'b0),
                    .aload(1'b0),
                    .q(cntr[i])
        );
        defparam df .power_up = "low";
        defparam df .is_wysiwyg = "false";
        end
end
endgenerate

endmodule


// FIVEMARK INFO :  5SGXEA7N2F45C2
// FIVEMARK INFO :  Max depth :  1.0 LUTs
// FIVEMARK INFO :  Total registers : 5
// FIVEMARK INFO :  Total pins : 8
// FIVEMARK INFO :  Total virtual pins : 0
// FIVEMARK INFO :  Total block memory bits : 0
// FIVEMARK INFO :  Comb ALUTs :                         ; 8               ;       ;
// FIVEMARK INFO :  ALMs : 4 / 234,720 ( < 1 % )
// FIVEMARK INFO :  Worst setup path @ 468.75MHz : 1.487 ns, From rl[2].df, To rl[1].df}
// FIVEMARK INFO :  Worst setup path @ 468.75MHz : 1.520 ns, From rl[3].df, To rl[1].df}
// FIVEMARK INFO :  Worst setup path @ 468.75MHz : 1.525 ns, From rl[0].df, To rl[2].df}

// BENCHMARK INFO :  10AX115R2F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 13.1a10.0 Build 343 10/23/2013 SJ Full Version
// BENCHMARK INFO :  Total registers : 5
// BENCHMARK INFO :  Total pins : 8
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  8              
// BENCHMARK INFO :  ALMs : 4 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.678 ns, From rl[1].df, To rl[2].df}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.677 ns, From rl[0].df, To rl[4].df}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.659 ns, From rl[2].df, To rl[1].df}
