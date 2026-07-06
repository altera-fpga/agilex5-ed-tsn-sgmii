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

// Multi-bit One Way Clock Crosser
module alt_mge_phy_mbow_clock_crosser #(
    parameter SYNCHRONIZER_DEPTH = 3,
    
    // Data related
    parameter DATA_WIDTH = 8,
    parameter OUT_DATA_RESET_VALUE = {DATA_WIDTH{1'b0}},
    
    // Transfer cycle related
    // The parameter must be set by users depending on worst case scenario of in and out clock frequencies
    parameter IN_TRANSFER_CYCLE = 6,    // Number of clock cycles to repeat the transfer
    
    // Number of clock cycles for valid = 1, need to ensure the data valid pulse is long enough to be sampled by out_clock
    parameter IN_VALID_LENGTH = 2
) (
    // Clock
    input                           in_clk,
    input                           out_clk,
    
    // Reset
    input                           in_reset_n,
    input                           out_reset_n,
    
    // Data
    input       [DATA_WIDTH-1:0]    in_data,
    output reg  [DATA_WIDTH-1:0]    out_data
    
);

// Number of clock cycles for valid = 0
localparam IN_TRANSFER_CYCLE_0 = IN_TRANSFER_CYCLE - IN_VALID_LENGTH;

// Number of clock cycles for valid = 1
localparam IN_TRANSFER_CYCLE_1 = IN_VALID_LENGTH;

// Variable to control the loop
reg [IN_TRANSFER_CYCLE-2:0] in_cycling_valid;

// Data valid pulse to clock cross from in clock to out clock
reg  in_transfer_valid;

// Data valid to update in_data_buffer for the transfer
wire in_transfer_valid_posedge;

// Data valid at out clock domain that indicates success of the transfer
wire out_transfer_valid;

// Flop for posedge detection
reg  out_transfer_valid_reg;

// Posedge indication for success transfer
wire out_transfer_valid_posedge;

// Data buffer for clock crossing
reg [DATA_WIDTH-1:0] in_data_buffer;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg [DATA_WIDTH-1:0] out_data_buffer;

// Initiate the transfer every N-cycle
always @(posedge in_clk) begin
    if(~in_reset_n) begin
        in_transfer_valid <= 1'b0;
        in_cycling_valid[IN_TRANSFER_CYCLE_0-2:0] <= {(IN_TRANSFER_CYCLE_0-1){1'b0}};
        in_cycling_valid[IN_TRANSFER_CYCLE-2:IN_TRANSFER_CYCLE_0-1] <= {IN_TRANSFER_CYCLE_1{1'b1}};
    end
    else begin
        // MSB to LSB, bit-0 to MSB
        {in_cycling_valid[IN_TRANSFER_CYCLE-2:0], in_transfer_valid} <= {in_transfer_valid, in_cycling_valid[IN_TRANSFER_CYCLE-2:0]};
    end
end

// Posedge detect to update in_data_buffer once every N-cycle
assign in_transfer_valid_posedge = (in_transfer_valid == 1'b0) && (in_cycling_valid[0] == 1'b1);

// Clock cross the data valid
alt_mge16_pcs_std_synchronizer #(
    SYNCHRONIZER_DEPTH
) sync_transfer_valid (
    .clk        (out_clk),
    .reset_n    (out_reset_n),
    .din        (in_transfer_valid),
    .dout       (out_transfer_valid)
);

// Positive edge detect
always @(posedge out_clk) begin
    if(~out_reset_n) begin
        out_transfer_valid_reg <= 1'b0;
    end
    else begin
        out_transfer_valid_reg <= out_transfer_valid;
    end
end

assign out_transfer_valid_posedge = (out_transfer_valid_reg == 1'b0) && (out_transfer_valid == 1'b1);

// Update the data only when posedge of data valid detected
always @(posedge in_clk) begin
    if(in_transfer_valid_posedge) begin
        in_data_buffer <= in_data;
    end
end

// Clock cross the multi-bit data
always @(posedge out_clk) begin
    out_data_buffer <= in_data_buffer;
end

// Output data
always @(posedge out_clk) begin
    if(~out_reset_n) begin
        out_data <= OUT_DATA_RESET_VALUE;
    end
    else if(out_transfer_valid_posedge) begin
        out_data <= out_data_buffer;
    end
end

endmodule
