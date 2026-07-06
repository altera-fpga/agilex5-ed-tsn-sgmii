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



//got from regtest/ip/efifo_f/hsl_dcfifo_v3_ext_ram/rtl/hsl_fifo/ccc_w_fifo.v
//this file taken from ip/alt_xcvr/altera_xcvr_native_phy/directphy_f/source/dphy_f_ccg.v
`timescale 1ps/1ps

module dphy_ccg #(
	parameter TARGET_CHIP           = 7,                                // fm = 7
	parameter WIDTH                 = 80,                               // typical 20,40,60,80
    parameter ADDR_WIDTH            = 3,                                // support 2 only
	parameter RAM_GROUPS            = (WIDTH < 20) ? 1 : (WIDTH / 20),  // min 1, WIDTH must be divisible by RAM_GROUPS
	parameter GROUP_RADDR           = (WIDTH < 20) ? 1'b0 : 1'b1,       // 1 to duplicate RADDR per group as well as WADDR
	parameter FLAG_DUPES            = 1,                                // if > 1 replicate full / empty flags for fanout balancing
	parameter SYNC_STAGES           = 2,                                // meta hardening - min 2 (1 capture 1 harden)
	parameter DISABLE_WUSED         = 1'b1,                             // for debug
	parameter DISABLE_RUSED         = 1'b1,                             // for debug
    parameter DISABLE_RAM           = 1                                 // set this to 1 when opt for external RAM
)(
	input                   aclr, // no domain
	
	input                   wclk,
	input   [WIDTH-1:0]     wdata,
	input                   wreq,
	output [FLAG_DUPES-1:0] wfull,	// optional duplicates for loading
	output [ADDR_WIDTH-1:0] wused,
	
	input                   rclk,
	output [WIDTH-1:0]      rdata,
	input                   rreq,
	output [FLAG_DUPES-1:0] rempty,	// optional duplicates for loading
	output [ADDR_WIDTH-1:0] rused,
    output [FLAG_DUPES-1:0] data_valid
	
);
    // Expected to be used in the condition where wclk = slower clock and rclk = faster clk
    // undeflow protection will generate cadence/data valid for tile
	localparam PREVENT_OVERFLOW      = 1'b1;	// ignore requests that would cause overflow
	localparam PREVENT_UNDERFLOW     = 1'b1;	// ignore requests that would cause underflow
    
//             __    __    __    __    __    __    __
// rclk       |  |  |  |  |  |  |  |  |  |  |  |  |  |
//         ___|  |__|  |__|  |__|  |__|  |__|  |__|  |__
//                _____
// rreq          |     |
//         ______|     |________________________________
//                      _____
// rdata               |     |
//         ____________|     |__________________________


////////////////////////////////////
// resync aclr (replaced aclr_filter with alt_xcvr_resync_std)
////////////////////////////////////

wire waclr, raclr, waclr_n, raclr_n;
    alt_xcvr_resync_etile #(
            .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)	
        ) rst_sync_tx_rd_clk (
            .clk    (rclk),
            .reset  (aclr),
            .d  (1'b1),
            .q  (raclr_n) // active low
        ); 
    alt_xcvr_resync_etile #(
            .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)	
        ) rst_sync_tx_wr_clk (
            .clk    (wclk),
            .reset  (aclr),
            .d  (1'b1),
            .q  (waclr_n) // active low
        ); 

    assign raclr = ~raclr_n;
    assign waclr = ~waclr_n;

////////////////////////////////////
// addr pointers 
////////////////////////////////////

wire winc, rinc;

wire [RAM_GROUPS*ADDR_WIDTH-1:0] rptr;
wire [ADDR_WIDTH-1:0] wptr;
wire [ADDR_WIDTH-1:0] waddr_g;
wire [ADDR_WIDTH-1:0] raddr_g;
assign wptr = waddr_g;

generate
	if (ADDR_WIDTH == 3) begin : a2
		// gray write pointer
		directphy_gray_cntr_3 wcntr (
			.clk(wclk),
			.ena(winc),
			.aclr(waclr),
			.cntr(waddr_g)
		);
		defparam wcntr.INIT_VAL = 2'h1;
		// gray read pointer
		directphy_gray_cntr_3 rcntr (
			.clk(rclk),
			.ena(rinc),
			.aclr(raclr),
			.cntr(raddr_g)
		);
		defparam rcntr.INIT_VAL = 2'h1;
		
	end	 else begin : a5gc
		// gray write pointer
		directphy_gray_cntr_5_sl wcntr (
			.clk(wclk),
			.ena(winc),
			.sld(waclr),
			.cntr(waddr_g)
		);
		defparam wcntr .SLD_VAL = 5'h1;
        defparam wcntr .TARGET_CHIP = TARGET_CHIP;
        
		// gray read pointer
		directphy_gray_cntr_5_sl rcntr (
			.clk(rclk),
			.ena(rinc),
			.sld(raclr),
			.cntr(raddr_g)
		);
		defparam rcntr .SLD_VAL = 5'h1;		
        defparam rcntr .TARGET_CHIP = TARGET_CHIP;
    end
endgenerate

// optional duplication of the read address 	
generate 
	if (GROUP_RADDR) begin : gr
		reg [RAM_GROUPS*ADDR_WIDTH-1:0] raddr_g_r = {RAM_GROUPS{{ADDR_WIDTH{1'b0}} | 1'b1}} 
			/* synthesis preserve */;
		always @(posedge rclk or posedge raclr) begin
			if (raclr) raddr_g_r <= {RAM_GROUPS{{ADDR_WIDTH{1'b0}} | 1'b1}};
			else if (rinc) raddr_g_r <= {RAM_GROUPS{raddr_g}};			
		end		
		assign rptr = raddr_g_r;
	end
	else begin : ngr
		assign rptr = {RAM_GROUPS{raddr_g}};
	end
endgenerate

//////////////////////////////////////////////////
// adjust pointers for RAM latency
//////////////////////////////////////////////////

reg [ADDR_WIDTH-1:0] raddr_g_completed = {ADDR_WIDTH{1'b0}};

always @(posedge rclk or posedge raclr) begin
	if (raclr) begin
		raddr_g_completed <= {ADDR_WIDTH{1'b0}};
	end
	else begin
		if (rinc) raddr_g_completed <= rptr[ADDR_WIDTH-1:0];		
	end
end

reg [ADDR_WIDTH-1:0] waddr_g_d = {ADDR_WIDTH{1'b0}};
reg [ADDR_WIDTH-1:0] waddr_g_completed = {ADDR_WIDTH{1'b0}};

wire [ADDR_WIDTH-1:0] waddr_g_d_w = winc ? waddr_g : waddr_g_d /* synthesis keep */;

always @(posedge wclk or posedge waclr) begin
	if (waclr) begin
		waddr_g_d <= {ADDR_WIDTH{1'b0}};
		waddr_g_completed <= {ADDR_WIDTH{1'b0}};		
	end
	else begin
		waddr_g_d <= waddr_g_d_w;			
		waddr_g_completed <= waddr_g_d;
	end
end

//////////////////////////////////////////////////
// cross clock domains
//////////////////////////////////////////////////
wire [ADDR_WIDTH-1:0] rside_waddr_g_completed;
    alt_xcvr_resync_etile #(
        .SYNC_CHAIN_LENGTH(SYNC_STAGES),    .WIDTH(ADDR_WIDTH),  .INIT_VALUE(0)    
    ) sr0 (
        .clk    (rclk),
        .reset  (raclr),
        .d  (waddr_g_completed),
        .q  (rside_waddr_g_completed) // active low
    ); 

wire [ADDR_WIDTH-1:0] wside_raddr_g_completed;

    alt_xcvr_resync_etile #(
        .SYNC_CHAIN_LENGTH(SYNC_STAGES),    .WIDTH(ADDR_WIDTH),  .INIT_VALUE(0)    
    ) sr1 (
        .clk    (wclk),
        .reset  (waclr),
        .d  (raddr_g_completed),
        .q  (wside_raddr_g_completed) // active low
    ); 

//////////////////////////////////////////////////
// compare pointers
//////////////////////////////////////////////////

genvar i;
generate
	for (i=0; i<FLAG_DUPES; i=i+1) begin : fg
		//assign wfull[i] = ~|(wside_raddr_g_completed ^ waddr_g); 
		//assign rempty[i] = ~|(raddr_g_completed ^ rside_waddr_g_completed);
		
		directphy_eq_5_ena eq0 (
			.da(5'h0 | wside_raddr_g_completed),
			.db(5'h0 | waddr_g),
			.ena(1'b1),
			.eq(wfull[i])
		);
		defparam eq0 .TARGET_CHIP = TARGET_CHIP;   // 0 generic, 1 S4, 2 S5
		
		directphy_eq_5_ena eq1 (
			.da(5'h0 | raddr_g_completed),
			.db(5'h0 | rside_waddr_g_completed),
			.ena(1'b1),
			.eq(rempty[i])
		);
		defparam eq1 .TARGET_CHIP = TARGET_CHIP;   // 0 generic, 1 S4, 2 S5		
	end
endgenerate

//////////////////////////////////////////////////
// storage array - split in addr reg groups
//////////////////////////////////////////////////

generate
    if (DISABLE_RAM == 0) begin: tc_r
reg [ADDR_WIDTH*RAM_GROUPS-1:0] waddr_reg = {(RAM_GROUPS*ADDR_WIDTH){1'b0}} /* synthesis preserve */;
reg [WIDTH-1:0] wdata_reg = {WIDTH{1'b0}};
wire [WIDTH-1:0] ram_q;
reg [WIDTH-1:0] rdata_reg = {WIDTH{1'b0}};

always @(posedge wclk) begin
	waddr_reg <= {RAM_GROUPS{wptr}};
	wdata_reg <= wdata;
end

	for (i=0; i<RAM_GROUPS;i=i+1) begin : sm
			directphy_mlab #( 
            .ADDR_WIDTH(ADDR_WIDTH)
            ) sm0 (
				.wclk(wclk),
				.wena(1'b1),
				.waddr_reg(waddr_reg[((i+1)*ADDR_WIDTH)-1:i*ADDR_WIDTH]),
				.wdata_reg(wdata_reg[(i+1)*(WIDTH/RAM_GROUPS)-1:i*(WIDTH/RAM_GROUPS)]),
				.raddr(rptr[((i+1)*ADDR_WIDTH)-1:i*ADDR_WIDTH]),
				.rdata(ram_q[(i+1)*(WIDTH/RAM_GROUPS)-1:i*(WIDTH/RAM_GROUPS)])		
			);		
			defparam sm0 .WIDTH = WIDTH / RAM_GROUPS;
		end

// output reg - don't defeat clock enable - works really well on S5 MLABs
wire [WIDTH-1:0] rdata_mx = rinc ? ram_q: rdata_reg;
always @(posedge rclk) begin
	rdata_reg <= rdata_mx;
end
assign rdata = rdata_reg;
	end else begin: tc_w
        assign rdata = {WIDTH{1'b0}};
    end
endgenerate

//delay data_valid by one cycle to match rdata if RAM is enabled
reg [FLAG_DUPES-1:0] rempty_reg;
generate
    if (DISABLE_RAM == 0) begin: dvr
        always @(posedge rclk) begin
            rempty_reg <= rempty;
        end
        assign data_valid = !rempty_reg;
    end else begin: dv
        assign data_valid = !rempty;
    end
endgenerate
        
    
//////////////////////////////////////////////////
// write used words
//////////////////////////////////////////////////

generate
	if (DISABLE_WUSED) begin : nwu
		assign wused = {ADDR_WIDTH{1'b0}};
	end
	else begin : wu
	
		wire [ADDR_WIDTH-1:0] wside_raddr_b_completed_w, waddr_b_w;

		if (ADDR_WIDTH == 4) begin : wu4
			directphy_gray_to_bin_4 gtb0 (
				.gray (wside_raddr_g_completed),
				.bin (wside_raddr_b_completed_w)
			);

			directphy_gray_to_bin_4 gtb1 (
				.gray (waddr_g_d),
				.bin (waddr_b_w)
			);
		end else begin : wu5
			directphy_gray_to_bin_5 gtb0 (
				.gray (wside_raddr_g_completed),
				.bin (wside_raddr_b_completed_w)
			);

			directphy_gray_to_bin_5 gtb1 (
				.gray (waddr_g_d),
				.bin (waddr_b_w)
			);	
		end
		
		reg [ADDR_WIDTH-1:0] wside_raddr_b_completed = {ADDR_WIDTH{1'b0}};
		reg [ADDR_WIDTH-1:0] waddr_b = {ADDR_WIDTH{1'b0}};
		reg [ADDR_WIDTH-1:0] wused_r = {ADDR_WIDTH{1'b0}};

		always @(posedge wclk or posedge waclr) begin
			if (waclr) begin
				wused_r <= {ADDR_WIDTH{1'b0}};
				wside_raddr_b_completed <= {ADDR_WIDTH{1'b0}};
				waddr_b <= {ADDR_WIDTH{1'b0}};
			end
			else begin
				wused_r <= waddr_b - wside_raddr_b_completed;
				wside_raddr_b_completed <= wside_raddr_b_completed_w;
				waddr_b <= waddr_b_w;
			end
		end

		assign wused = wused_r;
	end
endgenerate

//////////////////////////////////////////////////
// read used words
//////////////////////////////////////////////////

generate
	if (DISABLE_RUSED) begin : nru
		assign rused = {ADDR_WIDTH{1'b0}};
	end
	else begin : ru
		wire [ADDR_WIDTH-1:0] rside_waddr_b_completed_w, raddr_b_completed_w;

		if (ADDR_WIDTH == 4) begin : ru4
			directphy_gray_to_bin_4 gtb2 (
				.gray (rside_waddr_g_completed),
				.bin (rside_waddr_b_completed_w)
			);

			directphy_gray_to_bin_4 gtb3 (
				.gray (raddr_g_completed),
				.bin (raddr_b_completed_w)
			);
		end else begin : ru5
			directphy_gray_to_bin_5 gtb2 (
				.gray (rside_waddr_g_completed),
				.bin (rside_waddr_b_completed_w)
			);

			directphy_gray_to_bin_5 gtb3 (
				.gray (raddr_g_completed),
				.bin (raddr_b_completed_w)
			);
		end	

		reg [ADDR_WIDTH-1:0] rside_waddr_b_completed = {ADDR_WIDTH{1'b0}};
		reg [ADDR_WIDTH-1:0] raddr_b_completed = {ADDR_WIDTH{1'b0}};
		reg [ADDR_WIDTH-1:0] rused_r = {ADDR_WIDTH{1'b0}};

		always @(posedge rclk or posedge raclr) begin
			if (raclr) begin
				rused_r <= {ADDR_WIDTH{1'b0}};
				rside_waddr_b_completed <= {ADDR_WIDTH{1'b0}};
				raddr_b_completed <= {ADDR_WIDTH{1'b0}};
			end
			else begin
				rused_r <= rside_waddr_b_completed - raddr_b_completed;
				rside_waddr_b_completed <= rside_waddr_b_completed_w;
				raddr_b_completed <= raddr_b_completed_w;
			end
		end

		assign rused = rused_r;
	end
endgenerate

////////////////////////////////////
// qualified requests
////////////////////////////////////

//assign wfull[i] = ~|(wside_raddr_g_completed ^ waddr_g); 
//assign rempty[i] = ~|(raddr_g_completed ^ rside_waddr_g_completed);
//wire winc = wreq & (~wfull[0] | ~PREVENT_OVERFLOW);
//wire rinc = rreq & (~rempty[0] | ~PREVENT_UNDERFLOW);

generate
	if (PREVENT_OVERFLOW) begin
		directphy_neq_5_ena eq2 (
			.da(5'h0 | wside_raddr_g_completed),
			.db(5'h0 | waddr_g),
			.ena(wreq),
			.eq(winc)
		);
		defparam eq2 .TARGET_CHIP = TARGET_CHIP;   // 0 generic, 1 S4, 2 S5
	end
	else assign winc = wreq;
endgenerate
	
generate 
	if (PREVENT_UNDERFLOW) begin
		directphy_neq_5_ena eq3 (
			.da(5'h0 | raddr_g_completed),
			.db(5'h0 | rside_waddr_g_completed),
			.ena(rreq),
			.eq(rinc)
		);
		defparam eq3 .TARGET_CHIP = TARGET_CHIP;   // 0 generic, 1 S4, 2 S5		
	end
	else assign rinc = rreq;
endgenerate


endmodule
