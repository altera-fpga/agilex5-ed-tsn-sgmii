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



//`timescale 1 ps/1 ps  .  Lint error.

module alt_xcvr_avmm_arb #(
  parameter TOTAL_MASTERS   = 2,
  parameter CHANNELS        = 1,
  parameter ADDRESS_WIDTH   = 18,
  parameter DATA_WIDTH      = 32,
  parameter BE_WIDTH        = DATA_WIDTH/8
) (
  // Basic AVMM inputs
  input  [CHANNELS-1:0]              ini_clk,
  input  [CHANNELS-1:0]              ini_reset,

  // from Initiators AVMM input
  input  [TOTAL_MASTERS-1:0] [CHANNELS-1:0]               ini_read ,
  input  [TOTAL_MASTERS-1:0] [CHANNELS-1:0]               ini_write ,
  input  [TOTAL_MASTERS-1:0] [CHANNELS*ADDRESS_WIDTH-1:0] ini_address ,
  input  [TOTAL_MASTERS-1:0] [CHANNELS*BE_WIDTH-1:0]      ini_byteenable ,
  input  [TOTAL_MASTERS-1:0] [CHANNELS*DATA_WIDTH-1:0]    ini_writedata ,
  input  [TOTAL_MASTERS-1:0] [CHANNELS-1:0]               ini_read_write ,
  output [TOTAL_MASTERS-1:0] [CHANNELS-1:0]               ini_waitrequest ,
  output [TOTAL_MASTERS-1:0] [CHANNELS-1:0]               ini_readdatavalid , // works only if readdatavalid is only 1 clock later than waitrequest 
  

  // AVMM output the channel and the CSR
  input  [CHANNELS-1:0]               avmm_waitrequest,
  input  [CHANNELS-1:0]               avmm_readdatavalid,
  output [CHANNELS-1:0]               avmm_read,
  output [CHANNELS-1:0]               avmm_write,
  output reg [CHANNELS*ADDRESS_WIDTH-1:0] avmm_address,
  output reg [CHANNELS*BE_WIDTH-1:0]      avmm_byteenable,
  output reg [CHANNELS*DATA_WIDTH-1:0]    avmm_writedata
);

// General wires
wire [CHANNELS*TOTAL_MASTERS-1:0] grant;
wire [TOTAL_MASTERS-1:0]   ini_read_write_lcl [CHANNELS-1:0];

  // internal signals
wire  [TOTAL_MASTERS-1:0]               int_read       [CHANNELS-1:0];
wire  [TOTAL_MASTERS-1:0]               int_write      [CHANNELS-1:0];
wire  [TOTAL_MASTERS*ADDRESS_WIDTH-1:0] int_address    [CHANNELS-1:0];
wire  [TOTAL_MASTERS*BE_WIDTH-1:0]      int_byteenable [CHANNELS-1:0];
wire  [TOTAL_MASTERS*DATA_WIDTH-1:0]    int_writedata  [CHANNELS-1:0];
wire  [TOTAL_MASTERS-1:0]               int_read_write [CHANNELS-1:0];
wire  [TOTAL_MASTERS-1:0]               int_waitrequest [CHANNELS-1:0];
wire  [TOTAL_MASTERS-1:0]               int_readdatavalid [CHANNELS-1:0];

wire  [TOTAL_MASTERS*DATA_WIDTH-1:0]    exp_grant_data [CHANNELS-1:0];  // expanded grant for data bus
wire  [TOTAL_MASTERS*ADDRESS_WIDTH-1:0] exp_grant_addr [CHANNELS-1:0];
wire  [TOTAL_MASTERS*BE_WIDTH-1:0]      exp_grant_be   [CHANNELS-1:0];



// Variables for the generate loops 
genvar jg, mst; // jg for Channels; mst for channels
generate for(jg=0;jg<CHANNELS;jg=jg+1) begin: g_arb

    /*********************************************************************/
    // case: 309705
    // Simulation fix.  When the user inputs drive x at the beginning of simulation,
    // then even after a reset, the grant will have been assigned a value of x.
    // since there is a loopback in the RTL, the value will continue to be x,
    // and gets reflected on avmm_readdata and avmm_waitrequest.  once an avmm master
    // requests a read or write, the x value for grant will correct itself.
    /**********************************************************************/
    for (mst=0; mst<TOTAL_MASTERS; mst=mst+1) begin: g_mst
        assign ini_read_write_lcl[jg][mst] = 
                                     // synthesis translate_off
                                       (ini_read_write[mst][jg] === 1'bx) ? 1'b0 : 
                                     // synthesis translate_on
                                       ini_read_write[mst][jg];
	assign int_read[jg][mst]                                    = ini_read[mst][jg];
	assign int_write[jg][mst]                                   = ini_write[mst][jg];
	assign int_read_write[jg][mst]                              = ini_read_write_lcl[jg][mst];
	assign int_address[jg][mst*ADDRESS_WIDTH+:ADDRESS_WIDTH]    = ini_address[mst][jg*ADDRESS_WIDTH+:ADDRESS_WIDTH];
	assign int_byteenable[jg][mst*BE_WIDTH+:BE_WIDTH]           = ini_byteenable[mst][jg*BE_WIDTH+:BE_WIDTH];
	assign int_writedata[jg][mst*DATA_WIDTH+:DATA_WIDTH]        = ini_writedata[mst][jg*DATA_WIDTH+:DATA_WIDTH];

        assign exp_grant_addr[jg][mst*ADDRESS_WIDTH+:ADDRESS_WIDTH] = { ADDRESS_WIDTH{grant[jg*TOTAL_MASTERS+mst]} };                                    
        assign exp_grant_be[jg][mst*BE_WIDTH+:BE_WIDTH]             = { BE_WIDTH{grant[jg*TOTAL_MASTERS+mst]} };                                    
        assign exp_grant_data[jg][mst*DATA_WIDTH+:DATA_WIDTH]       = { DATA_WIDTH{grant[jg*TOTAL_MASTERS+mst]} };  

	assign ini_waitrequest[mst][jg]                             = int_waitrequest[jg][mst];
	assign ini_readdatavalid[mst][jg]                           = int_readdatavalid[jg][mst];
    end // g_mst

    /**********************************************************************/
    // Per Instance instantiations and assignments
    // Priority in decreasing order is embedded reconfig -> odi -> user AVMM -> JTAG
    /**********************************************************************/
    alt_xcvr_arbiter #(
          .width (TOTAL_MASTERS)
    ) arbiter_inst (
          .clock (ini_clk[jg]),
          .req   (ini_read_write_lcl[jg]),
          .grant (grant[jg*TOTAL_MASTERS+:TOTAL_MASTERS])
    );
   
      
    // Use the grant as a mask for the varoius read and writs signals
    // if you or them all together, it will generate the read/write request if any are high
    // For streamer write/read condition - if broadcasting, wait for all CHANNELS to receive grant before asserting write/read
    assign avmm_write[jg] =  |(grant[jg*TOTAL_MASTERS+:TOTAL_MASTERS] & int_write[jg]);
    assign avmm_read[jg]  =  |(grant[jg*TOTAL_MASTERS+:TOTAL_MASTERS] & int_read[jg]);
    
    // Split the wait request, and if the grant is asserted to any one master, assert wait request to all others
    assign int_waitrequest[jg] = ( ~grant[jg*TOTAL_MASTERS+:TOTAL_MASTERS] | {TOTAL_MASTERS{avmm_waitrequest[jg]}} );
     // Split the readdatavalid, and if the grant is asserted to any one master, zero valid to all others
     assign int_readdatavalid[jg] = ( grant[jg*TOTAL_MASTERS+:TOTAL_MASTERS] & {TOTAL_MASTERS{avmm_readdatavalid[jg]}} );

    logic [ADDRESS_WIDTH-1:0] ch_addr;
    logic [DATA_WIDTH-1:0]    ch_data;
    logic [BE_WIDTH-1:0]      ch_be;


    always @ (*) begin
	    ch_addr = { ADDRESS_WIDTH{1'b0} };
	    for (int m=0; m<TOTAL_MASTERS; m=m+1) begin
		    ch_addr = ch_addr | (exp_grant_addr[jg][m*ADDRESS_WIDTH+:ADDRESS_WIDTH] & int_address[jg][m*ADDRESS_WIDTH+:ADDRESS_WIDTH]);
	    end
            avmm_address[jg*ADDRESS_WIDTH+:ADDRESS_WIDTH]     =  ch_addr;
    end

    always @ (*) begin
	    ch_data = { DATA_WIDTH{1'b0} };
	    for (int m=0; m<TOTAL_MASTERS; m=m+1) begin
		    ch_data = ch_data | (exp_grant_data[jg][m*DATA_WIDTH+:DATA_WIDTH] & int_writedata[jg][m*DATA_WIDTH+:DATA_WIDTH]);
	    end
            avmm_writedata[jg*DATA_WIDTH+:DATA_WIDTH]   =  ch_data;
    end

    always @ (*) begin
	    ch_be   = { BE_WIDTH{1'b0} };
	    for (int m=0; m<TOTAL_MASTERS; m=m+1) begin
		    ch_be   = ch_be | (exp_grant_be[jg][m*BE_WIDTH+:BE_WIDTH] & int_byteenable[jg][m*BE_WIDTH+:BE_WIDTH]);
	    end
            avmm_byteenable[jg*BE_WIDTH+:BE_WIDTH]  =  ch_be;
    end

  
  end //End for channel-wise for loop
endgenerate // End generate 
endmodule
