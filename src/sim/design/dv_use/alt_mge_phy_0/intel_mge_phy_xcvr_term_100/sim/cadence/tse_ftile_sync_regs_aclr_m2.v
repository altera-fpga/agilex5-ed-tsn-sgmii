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

module tse_ftile_sync_regs_aclr_m2 #(
    parameter WIDTH = 32,
    parameter DEPTH = 2     // minimum of 2
)(
    input clk,
    input aclr,
    input [WIDTH-1:0] din,
    output [WIDTH-1:0] dout
);
reg [WIDTH-1:0] din_meta = 0;

reg [WIDTH*(DEPTH-1)-1:0] sync_sr = 0;

generate
if (DEPTH == 2) begin : d_eq2
    always @(posedge clk or posedge aclr) begin
        if (aclr) begin 
            din_meta <= {WIDTH{1'b0}};
            sync_sr <= {(WIDTH*(DEPTH-1)){1'b0}};
        end
        else begin
            din_meta <= din;
            sync_sr <= din_meta;
        end
    end
end else begin : d_gt2
    always @(posedge clk or posedge aclr) begin
        if (aclr) begin 
            din_meta <= {WIDTH{1'b0}};
            sync_sr <= {(WIDTH*(DEPTH-1)){1'b0}};
        end
        else begin
            din_meta <= din;
            sync_sr <= {sync_sr[WIDTH*(DEPTH-2)-1:0],din_meta};
        end
    end
end
endgenerate
assign dout = sync_sr[WIDTH*(DEPTH-1)-1:WIDTH*(DEPTH-2)];

endmodule

// BENCHMARK INFO :  5SGXEA7N2F45C2
// BENCHMARK INFO :  Max depth :  0.0 LUTs
// BENCHMARK INFO :  Total registers : 64
// BENCHMARK INFO :  Total pins : 66
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :                         ; 1               ;       ;
// BENCHMARK INFO :  ALMs : 17 / 234,720 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.702 ns, From din_meta[22], To sync_sr[22]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.705 ns, From din_meta[13], To sync_sr[13]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.708 ns, From din_meta[13], To sync_sr[13]}
