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


`timescale 1 ps/1 ps
module directphy_word_delay #(
    parameter WIDTH         = 32,
    parameter SIM_EMULATE   = 0
) (
    input               i_clk,
    input               i_reset,//Rg added reset
    input   [2:0]       i_delay,
    input   [WIDTH-1:0] i_data,
    output  [WIDTH-1:0] o_data
);

    wire    [WIDTH-1:0] o_data_int;
    reg     [WIDTH-1:0] o_data_reg;

    reg [2:0]   write_ptr;
    //reg [2:0]   read_ptr = 3'd0;
    reg [2:0]   read_ptr;//RG removed initialization

    //RG :quartus didnt like typecast that was added to make lint happy
    //so added temp variables to make quartus happy too
    wire [3:0] temp_write_ptr;
    wire [3:0] temp_read_ptr;
    assign temp_write_ptr = read_ptr + i_delay;
    assign temp_read_ptr  = read_ptr + 1'b1; 
    always @(posedge i_clk) begin
        if(i_reset)//RG added reset
        begin
            write_ptr <= 3'd0;
            read_ptr <= 3'd0;
        end
        else
        begin
        //write_ptr <= read_ptr + i_delay;
        //write_ptr <= 3'(read_ptr + i_delay);//RG added the width
        write_ptr <= temp_write_ptr[2:0];//RG changed to temp
        //read_ptr <= read_ptr + 1'b1;
        //read_ptr <= 3'(read_ptr + 1'b1);//RG added the width
        read_ptr <= temp_read_ptr[2:0];//RG changed to temp
    end
    end

    directphy_mlab #(
        .WIDTH       (WIDTH),
        .ADDR_WIDTH  (5),
        .SIM_EMULATE (SIM_EMULATE)
    ) sm0 (
        .wclk       (i_clk),
        .wena       (1'b1),
        .waddr_reg  ({2'b00, write_ptr}),
        .wdata_reg  (i_data),
        .raddr      ({2'b00, read_ptr}),
        .rdata      (o_data_int)
    );

    always @(posedge i_clk) o_data_reg <= o_data_int;

    assign o_data = o_data_reg;
endmodule
