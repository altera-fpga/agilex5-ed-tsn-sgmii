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
module alt_em10g32_altsyncram_bundle (
	data,
	rd_aclr,
	rdaddress,
	rdclock,
	rden,
	wraddress,
	wrclock,
	wren,
    eccstatus,
	q);
    
    // Parameters
    parameter DEVICE_FAMILY             = "Stratix V";
    parameter WIDTH                     = 32;
    parameter DEPTH                     = 32;
    parameter ENABLE_MEM_ECC            = 0;
    parameter ENABLE_ECC_PIPELINE_STAGE = 0;
    parameter REGISTERED_OUTPUT         = 0;
    parameter RAM_BLOCK_TYPE            = (DEVICE_FAMILY == "Arria V") ? "M10K" : "M20K";
    
    // Local Parameters
    localparam ADDRESS_WIDTH    = log2ceil(DEPTH);
    
    localparam SV_M20K_WIDTH_W_ECC      = 32;
    localparam SV_M20K_MEM_BLOCK_NUM    = ENABLE_MEM_ECC ? divceil(WIDTH, SV_M20K_WIDTH_W_ECC) : 1;
    localparam SV_M20K_WIDTH_PER_BLOCK  = ENABLE_MEM_ECC ? SV_M20K_WIDTH_W_ECC : WIDTH;
    localparam SV_M20K_CONCAT_WIDTH     = ENABLE_MEM_ECC ? (WIDTH % SV_M20K_WIDTH_W_ECC) : 0;
    
    localparam MEM_BLOCK_NUM            = (DEVICE_FAMILY == "Stratix V") ? SV_M20K_MEM_BLOCK_NUM : SV_M20K_MEM_BLOCK_NUM;
    localparam WIDTH_PER_BLOCK          = (DEVICE_FAMILY == "Stratix V") ? SV_M20K_WIDTH_PER_BLOCK : SV_M20K_WIDTH_PER_BLOCK;
    localparam CONCAT_WIDTH             = (DEVICE_FAMILY == "Stratix V") ? SV_M20K_CONCAT_WIDTH : SV_M20K_CONCAT_WIDTH;
    
	input	[WIDTH-1:0]         data;
	input	                    rd_aclr;
	input	[ADDRESS_WIDTH-1:0] rdaddress;
	input	                    rdclock;
	input	                    rden;
	input	[ADDRESS_WIDTH-1:0] wraddress;
	input	                    wrclock;
	input	                    wren;
    output	[1:0]               eccstatus;
	output	[WIDTH-1:0]         q;
    
    wire  [WIDTH_PER_BLOCK-1:0] wrdata[MEM_BLOCK_NUM-1:0];
    wire  [WIDTH_PER_BLOCK-1:0] rddata[MEM_BLOCK_NUM-1:0];
    
    wire  [MEM_BLOCK_NUM-1:0]   eccstatus_int_0;
    wire  [MEM_BLOCK_NUM-1:0]   eccstatus_int_1;
    
    genvar i;
    
    generate for(i = 0; i < MEM_BLOCK_NUM; i = i + 1)
        begin : altsyncram_gen
            
            if((i == MEM_BLOCK_NUM - 1) && (CONCAT_WIDTH != 0)) begin
                assign wrdata[i] = {{CONCAT_WIDTH{1'b0}}, data[WIDTH - 1: WIDTH_PER_BLOCK * i]};
                assign q[WIDTH - 1: WIDTH_PER_BLOCK * i] = rddata[i][CONCAT_WIDTH - 1:0];
            end
            else begin
                assign wrdata[i] = data[WIDTH_PER_BLOCK * (i+1) - 1: WIDTH_PER_BLOCK * i];
                assign q[WIDTH_PER_BLOCK * (i+1) - 1: WIDTH_PER_BLOCK * i] = rddata[i][WIDTH_PER_BLOCK - 1:0];
            end
            
            alt_em10g32_altsyncram #(
                .DEVICE_FAMILY              (DEVICE_FAMILY),
                .WIDTH                      (WIDTH_PER_BLOCK),
                .DEPTH                      (DEPTH),
                .ENABLE_MEM_ECC             (ENABLE_MEM_ECC),
                .ENABLE_ECC_PIPELINE_STAGE  (ENABLE_ECC_PIPELINE_STAGE),
                .REGISTERED_OUTPUT          (REGISTERED_OUTPUT),
                .ADDRESS_WIDTH              (ADDRESS_WIDTH),
                .RAM_BLOCK_TYPE             (RAM_BLOCK_TYPE)
            ) altsyncram_inst (
                .wrclock        (wrclock),
                .wren           (wren),
                .wraddress      (wraddress),
                .data           (wrdata[i]),
                .rd_aclr        (rd_aclr),
                .rdclock        (rdclock),
                .rden           (rden),
                .rdaddress      (rdaddress),
                .eccstatus      ({eccstatus_int_1[i], eccstatus_int_0[i]}),
                .q              (rddata[i])
            );
        end
    endgenerate
    
    assign eccstatus[0] = ENABLE_MEM_ECC ? |eccstatus_int_0 : 1'b0;
    assign eccstatus[1] = ENABLE_MEM_ECC ? |eccstatus_int_1 : 1'b0;
    
    // --------------------------------------------------
    // Calculates the log2ceil of the input value
    // --------------------------------------------------
    function integer log2ceil;
        input integer val;
        integer i;
        
        begin
            i = 1;
            log2ceil = 0;
            
            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction
    
    // --------------------------------------------------
    // Calculates the divceil of the input value (m/n)
    // --------------------------------------------------
    function integer divceil;
        input integer m;
		input integer n;
        integer i;
        
        begin
            i = m % n;
            divceil = (m/n);
            if (i > 0) begin
                divceil = divceil + 1;
			end
        end
    endfunction	

endmodule
