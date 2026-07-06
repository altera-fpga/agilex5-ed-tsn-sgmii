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

module altera_eth_sideband_crosser_sync #(
    parameter WIDTH = 8,
    parameter SYNC_RESET_N = 1
) (
    input  wire             in_clk,
    input  wire             in_rst_n,
    input  wire             in_valid,
    input  wire [WIDTH-1:0] in_data,
    
    input  wire             out_clk,
    input  wire             out_rst_n,
    output reg              out_valid,
    output reg  [WIDTH-1:0] out_data
);

reg hold;
reg out_valid_tmp;
reg [WIDTH-1:0] out_data_tmp;

// Retain output signals to client for 2 cycles so that slow clock could sample correctly
// In clock: 2x clock
// Out clock: 1x clock
  generate if (SYNC_RESET_N == 1) begin
    always @(posedge in_clk) begin
        if (!in_rst_n) begin
            hold <= 1'b0;
        end
        else begin
            hold <= in_valid;
        end
    end
    
    always @(posedge in_clk) begin
        if (!in_rst_n) begin
            out_valid_tmp <= 1'b0;
            out_data_tmp <= {WIDTH{1'b0}};
        end
        else begin
            if (hold) begin
                out_valid_tmp <= out_valid_tmp;
                out_data_tmp <= out_data_tmp;
            end else begin
                out_valid_tmp <= in_valid;
                out_data_tmp <= in_data;
            end
        end
    end
    
    always @(posedge out_clk) begin
        if (!out_rst_n) begin
            out_valid <= 1'b0;
            out_data <= {WIDTH{1'b0}};
        end
        else begin
            out_valid <= out_valid_tmp;
            out_data <= out_data_tmp;      
        end
    end
  end else begin
    always @(posedge in_clk or negedge in_rst_n) begin
        if (!in_rst_n) begin
            hold <= 1'b0;
        end
        else begin
            hold <= in_valid;
        end
    end
    
    always @(posedge in_clk or negedge in_rst_n) begin
        if (!in_rst_n) begin
            out_valid_tmp <= 1'b0;
            out_data_tmp <= {WIDTH{1'b0}};
        end
        else begin
            if (hold) begin
                out_valid_tmp <= out_valid_tmp;
                out_data_tmp <= out_data_tmp;
            end else begin
                out_valid_tmp <= in_valid;
                out_data_tmp <= in_data;
            end
        end
    end
    
    always @(posedge out_clk or negedge out_rst_n) begin
        if (!out_rst_n) begin
            out_valid <= 1'b0;
            out_data <= {WIDTH{1'b0}};
        end
        else begin
            out_valid <= out_valid_tmp;
            out_data <= out_data_tmp;      
        end
    end
  end
  endgenerate

endmodule
