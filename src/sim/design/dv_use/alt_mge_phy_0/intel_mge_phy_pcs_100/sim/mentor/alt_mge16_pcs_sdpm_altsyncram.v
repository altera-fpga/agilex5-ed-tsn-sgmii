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


// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
//
// Description : 
//
// Memory module.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module alt_mge16_pcs_sdpm_altsyncram (
	data,
	rdaddress,
	rdclock,
	wraddress,
	wrclock,
	wren,
	q);

	parameter FF_WIDTH = 3'b 100;
    	parameter DEPTH = 8'b 10000000;
    	parameter ADDR_WIDTH = 3'b 111;
	parameter DEVICE_FAMILY = "Arria 10";

	input	[FF_WIDTH-1:0]  data;
	input	[ADDR_WIDTH-1:0]  rdaddress;
	input	  rdclock;
	input	[ADDR_WIDTH-1:0]  wraddress;
	input	  wrclock;
	input	  wren;
	output	[FF_WIDTH-1:0]  q;

	wire [FF_WIDTH-1:0] sub_wire0;
	wire [FF_WIDTH-1:0] q = sub_wire0[FF_WIDTH-1:0];

	altera_syncram	altera_syncram_component (
				.wren_a (wren),
				.clock0 (wrclock),
				.clock1 (rdclock),
				.address_a (wraddress),
				.address_b (rdaddress),
				.data_a (data),
				.q_b (sub_wire0),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.address2_a (1'b1),
				.address2_b (1'b1),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_b ({FF_WIDTH{1'b1}}),
				.eccencbypass (1'b0),
				.eccencparity ({8{1'b0}}),
				.eccstatus (),
				.q_a (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.sclr (1'b0),
				.wren_b (1'b0));
	defparam
		altera_syncram_component.enable_ecc = "FALSE",
		altera_syncram_component.address_reg_b = "CLOCK1",
		`ifdef NO_PLI
		altera_syncram_component.init_file = "sdpm_altsyncram.rif",
		//`else
		//altera_syncram_component.init_file = "sdpm_altsyncram.hex",
		`endif
		altera_syncram_component.lpm_type = "altera_syncram",
		altera_syncram_component.numwords_a = DEPTH,
		altera_syncram_component.numwords_b = DEPTH,
		altera_syncram_component.operation_mode = "DUAL_PORT",
		altera_syncram_component.outdata_aclr_b = "NONE",
		altera_syncram_component.outdata_sclr_b = "NONE",
		altera_syncram_component.outdata_reg_b = "UNREGISTERED",
		altera_syncram_component.power_up_uninitialized = "FALSE",
		altera_syncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
		altera_syncram_component.widthad_a = ADDR_WIDTH,
		altera_syncram_component.widthad_b = ADDR_WIDTH,
		altera_syncram_component.width_a = FF_WIDTH,
		altera_syncram_component.width_b = FF_WIDTH,
		altera_syncram_component.width_byteena_a = 1,
		altera_syncram_component.intended_device_family = DEVICE_FAMILY;


endmodule


