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


// (C) 2001-2021 Intel Corporation. All rights reserved.
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


`timescale 1ps / 1ps

// This is not guaranteed to work the same as ALTGXB and is derived from different source. 
// As an example, this always aligns K28.5 to LSB of 40-bit word and has different latency

// FIRST_WORD_VALID = 1: data internally delayed so that when K28.5 found, K28.5 is in rx_dataout with first
//                       rx_patterndetect. Additional cost of 162 registers
// FIRST_WORD_VALID = 0: internal delay from finding position of K28.5 and rotation of output. Result is that
//                       at initial alignment indicated by rx_patterndetect, data is valid 2 words later and
//                       2 words after the first K28.5. No difference in operation after initial alignment


module alt_mge_wordalign20
#(
   parameter ALIGN_PATTERN1   =  10'h17C,  // K28.5-
	parameter ALIGN_PATTERN2   =  10'h283,  // K28.5+
	parameter FIRST_WORD_VALID = 0,       // 1 =>first dataout 
	parameter EDGE_MODE        = 1
)
(
	input wire clk, 
	input wire rx_digitalreset,
	input wire rx_enapatternalign,
	input wire [19 : 0] rx_datain, 

	output wire         rx_patterndetect,             // Only output if rx_enapatternalign is high
	output wire [4:0]   rx_bitslipboundary_sel,       
	output reg [19 : 0] rx_dataout
);
	localparam WORD_SIZE  = 10;
	localparam WORD_COUNT = 2;
	localparam ALIGN_PATTERN_LENGTH = 10;
	localparam DATA_WIDTH = 20;


integer                      pos; 
reg [3 : 0]                  position;     // Increase size if WORD_SIZE > 2^4 = 16
reg [1 : 0]                  input_pattern_detect;
reg [10 * WORD_COUNT - 1 : 0] position_found;
reg [10 * WORD_COUNT - 1 : 0] position_found_old;
reg [3 * WORD_SIZE - 1 : 0] rx_dataout_coarse;
wire [1 : 0]                 rx_patterndetect_new_align;
wire [1:0]                   rx_patterndetect_old_align;
reg                          do_alignment;
reg                          rx_enapatternalign_d;

reg [DATA_WIDTH - 1 : 0]    rx_datain_d; 

wire [2 * DATA_WIDTH - 1 : 0] search_wire = {rx_datain, rx_datain_d}; // {older data in LSB}

reg  [2 * DATA_WIDTH - 1 : 0] search_wire_d;
reg  [2 * DATA_WIDTH - 1 : 0] search_wire_dd;

reg rx_patterndetect_1;
reg rx_patterndetect_2;
reg rx_patterndetect_3;
reg [4:0] rx_bitslipboundary_sel_1;
reg [4:0] rx_bitslipboundary_sel_2;
reg [4:0] rx_bitslipboundary_sel_3;

wire [2 * DATA_WIDTH - 1 : 0] data_wire = (FIRST_WORD_VALID==1) ? search_wire_dd : search_wire;
assign rx_patterndetect = (FIRST_WORD_VALID==1) ? rx_patterndetect_3 : rx_patterndetect_1;
assign rx_bitslipboundary_sel = (FIRST_WORD_VALID==1) ? rx_bitslipboundary_sel_3 : rx_bitslipboundary_sel_1;

integer i;
integer word_count;

always @(posedge clk ) 
begin
	if (rx_digitalreset) 
	begin
		position <= 0;
		do_alignment <= 0;
		rx_enapatternalign_d <= 0;
		input_pattern_detect <= 0;
		rx_patterndetect_1 <= 0;
		rx_patterndetect_2 <= 0;
		rx_patterndetect_3 <= 0;
		rx_bitslipboundary_sel_1 <= 0;
		rx_bitslipboundary_sel_2 <= 0;
		rx_bitslipboundary_sel_3 <= 0;
    
	end
	else
	begin
		// If EDGE_MODE, do_alignment given transition on rx_enapatternalign until find pattern
		// otherwise do_alignment whenever rx_enapatternalign
		if (EDGE_MODE) begin
			if (!rx_enapatternalign_d && rx_enapatternalign) do_alignment <= 1'b1;
			//else if (rx_patterndetect) do_alignment <= 1'b0;
			else if (do_alignment && |rx_patterndetect_new_align) do_alignment <= 1'b0;
		end
		else 
		begin
			do_alignment <= rx_enapatternalign;
		end
		
		rx_enapatternalign_d <= rx_enapatternalign;

		// If not in do_alignment or alignment not found, keep old value of input_pattern_detect and position
		for (word_count = 0; word_count < WORD_COUNT; word_count = word_count + 1)
		begin : loop3
			if (do_alignment)
			begin
				if (rx_patterndetect_new_align[word_count]) 
				begin
					position <= position_found[0+word_count*10] ? 4'h0 :
                                position_found[1+word_count*10] ? 4'h1 :
                                position_found[2+word_count*10] ? 4'h2 :
                                position_found[3+word_count*10] ? 4'h3 :
                                position_found[4+word_count*10] ? 4'h4 :
                                position_found[5+word_count*10] ? 4'h5 :
                                position_found[6+word_count*10] ? 4'h6 :
                                position_found[7+word_count*10] ? 4'h7 :
                                position_found[8+word_count*10] ? 4'h8 :
                                position_found[9+word_count*10] ? 4'h9 :
                                4'h0;
					rx_bitslipboundary_sel_1 <= position_found[0+word_count*10] ? 0+word_count*10 :
                                                position_found[1+word_count*10] ? 1+word_count*10 :
                                                position_found[2+word_count*10] ? 2+word_count*10 :
                                                position_found[3+word_count*10] ? 3+word_count*10 :
                                                position_found[4+word_count*10] ? 4+word_count*10 :
                                                position_found[5+word_count*10] ? 5+word_count*10 :
                                                position_found[6+word_count*10] ? 6+word_count*10 :
                                                position_found[7+word_count*10] ? 7+word_count*10 :
                                                position_found[8+word_count*10] ? 8+word_count*10 :
                                                position_found[9+word_count*10] ? 9+word_count*10 :
                                                5'h0;
					input_pattern_detect <= rx_patterndetect_new_align;
					//do_alignment <= 0;
				end
				rx_patterndetect_1 <= |rx_patterndetect_new_align;
			end
			else
			begin
				rx_patterndetect_1 <= |rx_patterndetect_old_align;
			end
		end

		rx_patterndetect_2 <= rx_patterndetect_1;
		rx_patterndetect_3 <= rx_patterndetect_2;
		rx_bitslipboundary_sel_2 <= rx_bitslipboundary_sel_1;
		rx_bitslipboundary_sel_3 <= rx_bitslipboundary_sel_2;
	end
end

// Move input data through buffer
// Set output data
always @(posedge clk)
begin
	//if (rx_digitalreset) 
	//begin
	//	rx_dataout <= 0;
	//	search_wire_d <= 0;
	//	search_wire_dd <= 0;
	//end
	//else
	//begin
	
		// move the data through the buffer. New buffer = old search_wire
		rx_datain_d <= rx_datain;
		search_wire_d <= search_wire;
		search_wire_dd <= search_wire_d;

		// First align to closest word. 
		// Need to store 3 WORDS so that enough overlap to move by up to 10 bits on fine-grain adjustment
		// Do coarse grain first to reduce intermediate storage
		// search lower portion of search_wire
		if      (input_pattern_detect[1]) rx_dataout_coarse <= data_wire[39 - 1 * WORD_SIZE -: 30];
		else                              rx_dataout_coarse <= data_wire[39 - 0 * WORD_SIZE -: 30];

		// fine-grain adjustment
		rx_dataout <= rx_dataout_coarse[29 - position -: 20];
	//end
end

// search for pos where buffer equals RX_ALIGN_PATTERN 
// position keeps old value if no match found
// For each pos, check each 10-bit word within 40-bit input for match
assign rx_patterndetect_new_align[0] = |position_found[9:0];
assign rx_patterndetect_new_align[1] = |position_found[19:10];
assign rx_patterndetect_old_align[0] = (|position_found[19:0]) && (position_found[9:0] == position_found_old[9:0]);
assign rx_patterndetect_old_align[1] = (|position_found[19:0]) && (position_found[19:10] == position_found_old[19:10]);

always @(posedge clk) 
begin
	//if (rx_digitalreset) 
	//begin
	//	position_found <= 0;
	//end
	//else
	//begin
        position_found_old <= position_found;
		for (pos = 0; pos < WORD_SIZE; pos = pos + 1) 
		begin : loop1
			for (word_count = 0; word_count < WORD_COUNT; word_count = word_count + 1)
			begin : loop2
				// search lower portion of search_wire. Pattern always at LSB of 40-bits
				if (search_wire[29 - word_count * WORD_SIZE - pos -: ALIGN_PATTERN_LENGTH] == ALIGN_PATTERN1 ||
					search_wire[29 - word_count * WORD_SIZE - pos -: ALIGN_PATTERN_LENGTH] == ALIGN_PATTERN2)
				begin				
					position_found[pos+10*word_count] <= 1'b1;
				end
                else begin
                    position_found[pos+10*word_count] <= 0;
                end
			end
		end
	//end
end

endmodule
