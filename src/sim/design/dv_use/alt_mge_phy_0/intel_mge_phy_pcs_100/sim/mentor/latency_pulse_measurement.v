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

module latency_pulse_measurement #(
    parameter SAMPLE_SIZE = 128,
	parameter FIFO_DEPTH = 16
) (
    input             clk,
	input             reset,
    input             latency_pulse,
    output [11:0]     latency_fifo,
    output reg        result_ready
);

    localparam COUNT_WIDTH = log2(SAMPLE_SIZE);
	
	// output 4 fractional bits. Calculate the number of 0 to be padded based on different fifo depth. 
	// Example: FIFO_DEPTH = 8, SAMPLE_SIZE = 128,  latency = sum_fifo * 8 / 128
	// latency = (sum_fifo << 4) >> 8, 4 fractional bit, no padding needed. 
	localparam SHIFT_LEFT_CNT  = log2(FIFO_DEPTH);
	localparam SHIFT_RIGHT_CNT = COUNT_WIDTH;
	localparam FRAC_WIDTH      = 6;

    reg [11:0]                    sum_fifo;
	reg [COUNT_WIDTH:0]           counter;
	reg [COUNT_WIDTH + 11 - 1 : 0] latency_fifo_r;	
						
	always @ (posedge clk or posedge reset) begin
        if (reset) begin
            result_ready   <= 1'b0;
			counter        <= {8{1'b0}};
			sum_fifo       <= {12{1'b0}};
			latency_fifo_r <= {(COUNT_WIDTH + 11){1'b0}};
        end
        else begin
               
            if (counter == SAMPLE_SIZE-1) begin
			    latency_fifo_r <= ({sum_fifo,{FRAC_WIDTH{1'b0}}} << SHIFT_LEFT_CNT) >> SHIFT_RIGHT_CNT;
                
				result_ready <= 1'b1;
				counter <= 7'b0;		
				sum_fifo  <= {{11{1'b0}},latency_pulse};				
            end
            else begin
                counter <= counter + 7'd1;
			    result_ready <= result_ready;
			    sum_fifo  <= sum_fifo + latency_pulse;
				
				latency_fifo_r <= latency_fifo_r;	
            end
        end
    end
	
	assign latency_fifo = latency_fifo_r[11:0]; // Trim down to 6 bit fraction 
	
	function integer log2;
    input [31:0] value;
    begin
        for (log2=0; value>0; log2=log2+1) begin
            value = value>>1;
        end
        log2 = log2-1;
    end
    endfunction

endmodule
