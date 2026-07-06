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

// Generates async_pulse 
module alt_mge_phy_f_ptp_async_pulse_gen #(
    parameter DL_ASYNC_PULSE_WIDTH = 11
) (
    input       clk,
    input       reset,
    (* altera_attribute = "-name MESSAGE_DISABLE 332060" *) output reg  async_pulse  // This is not a clock, disable warning message
);

reg [3:0] cnt;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        cnt <= 4'd0;
    end else begin
        if (cnt == DL_ASYNC_PULSE_WIDTH)
            cnt <= 4'd0;
        else
            cnt <= cnt + 4'd1;
    end
end

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        async_pulse <= 1'b0;
    end else begin
        if (cnt == DL_ASYNC_PULSE_WIDTH)
            async_pulse <= ~async_pulse;
        else
            async_pulse <= async_pulse;
    end
end

endmodule
