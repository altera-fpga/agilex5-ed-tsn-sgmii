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

module alt_em10g32_tx_rs_gmii_mii_layer (
    input wire clock_gmii,
    input wire clock_mac,
    
    input wire reset_gmii_n,
    input wire reset_gmii_n_asyn,
    input wire reset_mac_n,
    input wire reset_mac_n_asyn,
    
    output wire [7:0]gmii_source_data,
    output wire gmii_source_control,
    output wire gmii_source_error,
    
    output wire [3:0]mii_source_data,
    output wire mii_source_control,
    output wire mii_source_error,

    // GMII 16 bit Transmit
    output wire [15:0]  gmii16b_tx_d,
    output wire [ 1:0]  gmii16b_tx_en,
    output wire [ 1:0]  gmii16b_tx_err,
    
    input wire [2:0]speed_sel,
    
    input wire tx_clkena,
    input wire tx_clkena_half_rate,
    
    input wire [7:0]ipg_value_1g,
    
    input wire mx2rs_ethfrm_sop,
    input wire mx2rs_ethfrm_valid,
    output reg rs2mx_ethfrm_ready,
    input wire mx2rs_ethfrm_eop,
    input wire [31:0]mx2rs_ethfrm_data,
    input wire [1:0]mx2rs_ethfrm_empty,
    input wire mx2rs_ethfrm_error,
    
    input wire [1:0]mx2rs_frm_type,
    
    input wire csr_crc_inst_en,
    
    input wire crc2rs_result_valid,
    input wire [31:0]crc2rs_result,
    
    input  wire       enable_timestamping,
    input  wire       enable_ptp_1step,
    
    output wire       gmii2ptp_gmii_control,
    output wire [7:0] gmii2ptp_gmii_data,
    output wire       gmii2ptp_gmii_error,
    output wire [1:0] gmii2ptp_gmii_channel,
    
    input  wire       ptp2gmii_gmii_control,
    input  wire [7:0] ptp2gmii_gmii_data,
    input  wire       ptp2gmii_gmii_error,
    
    output wire [ 1:0] gmii16b2ptp_gmii16b_control,
    output wire [15:0] gmii16b2ptp_gmii16b_data,
    output wire [ 1:0] gmii16b2ptp_gmii16b_error,
    output wire [ 1:0] gmii16b2ptp_gmii16b_channel,
    
    input  wire [ 1:0] ptp2gmii16b_gmii16b_control,
    input  wire [15:0] ptp2gmii16b_gmii16b_data,
    input  wire [ 1:0] ptp2gmii16b_gmii16b_error,
    
    // status to report packet in progress
    output wire tx_packet_in_progress_gmii_mii,
    output wire tx_packet_in_progress_gmii16b,
    
    // ECC status
    output wire       tx_gmii_encoder_ecc_err_corrected,
    output wire       tx_gmii_encoder_ecc_err_fatal
);

parameter	W_GMII_WIDTH				=	8;
parameter	BITSPERSYMBOL				=	4;  // Streaming Data symbol width in bits
parameter	SYMBOLSPERBEAT				= 	8;  // Streaming Number of symbols per word
parameter   ENABLE_MEM_ECC              =   0;
parameter   FORWARD_SYNC_DEPTH          =   3;
parameter   BACKWARD_SYNC_DEPTH         =   3;
parameter   ENABLE_GMII16B              =   0;
parameter   SYNC_RESET_N                =   1;

localparam  MAC_WIDTH				    =	BITSPERSYMBOL*SYMBOLSPERBEAT;
localparam  EMPTY_WIDTH				=       $clog2(SYMBOLSPERBEAT);
localparam	W_GMII_CONTROL_WIDTH		=	W_GMII_WIDTH/8;


wire            wire_speed_mii_gmii_bar;
wire    [3:0]   mux_mii_source_data;
wire            mux_mii_source_control;
wire            mux_mii_source_error;

wire  [7:0]     wire_gmii_source_data;
wire            wire_gmii_source_control;
wire            wire_gmii_source_error;  
wire  [1:0]     wire_gmii_source_channel;

wire  [15:0]     wire_gmii16b_source_data;
wire  [ 1:0]     wire_gmii16b_source_control;
wire  [ 1:0]     wire_gmii16b_source_error;  
wire  [ 1:0]     wire_gmii16b_source_channel;

wire            avst_gmii_control;
wire [7:0]      avst_gmii_data;
wire            avst_gmii_error;

reg             gmii_control_reg;
reg  [7:0]      gmii_data_reg;
reg             gmii_error_reg;

reg     [1:0]   mx2rs_frm_type_dly;
reg     [1:0]   mx2rs_frm_type_dly1;
reg     [1:0]   mx2rs_frm_type_dly2;
reg     [1:0]   mx2rs_frm_type_dly3;
reg     [1:0]   mx2rs_frm_type_dly4;
reg     [1:0]   mx2rs_frm_type_dly5;
reg     [1:0]   mx2rs_frm_type_dly6;

reg     [1:0]   txdata_sink_channel;

reg             packet_in_progress_gmii_mii;
reg             packet_in_progress_gmii16b;


assign wire_speed_mii_gmii_bar = (speed_sel == 3'b011 || speed_sel == 3'b010)? 1'b1: 1'b0;

assign mii_source_data = wire_speed_mii_gmii_bar ? mux_mii_source_data : 3'b0;
assign mii_source_control = wire_speed_mii_gmii_bar ? mux_mii_source_control : 1'b0;
assign mii_source_error = wire_speed_mii_gmii_bar ? mux_mii_source_error : 1'b0;

assign gmii_source_data = wire_speed_mii_gmii_bar ? 7'b0: avst_gmii_data;
assign gmii_source_control = wire_speed_mii_gmii_bar ? 1'b0: avst_gmii_control;
assign gmii_source_error = wire_speed_mii_gmii_bar ? 1'b0: avst_gmii_error;

// those piece of logic is use to keep track packet in progress 

always @(posedge clock_gmii) begin
    if(~reset_gmii_n) begin
        packet_in_progress_gmii_mii <= 1'b0;
        packet_in_progress_gmii16b <= 1'b0;
    end
    else begin
        packet_in_progress_gmii_mii <= gmii_source_control | mii_source_control;
        packet_in_progress_gmii16b <= |gmii16b_tx_en;
    end
end

    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) sync_gmii_control_to_mac_clock (
        .clk (clock_mac),
        .reset_n (reset_mac_n_asyn),
        .din (packet_in_progress_gmii_mii),
        .dout (tx_packet_in_progress_gmii_mii)
    ); 

    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) sync_gmii16b_to_mac_clock (
        .clk (clock_mac),
        .reset_n (reset_mac_n_asyn),
        .din (packet_in_progress_gmii16b),
        .dout (tx_packet_in_progress_gmii16b)
    ); 

wire reset_gmii;
wire reset_mac;
wire reset_gmii_asyn;

assign reset_gmii = !reset_gmii_n;
assign reset_mac = !reset_mac_n;
assign reset_gmii_asyn = !reset_gmii_n_asyn;

// Set SYNCHRONIZER_IDENTIFICATION=OFF because csr_crc_inst_en is a pseudo-static CSR field
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg mx2rs_ethfrm_sop_dly1;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg mx2rs_ethfrm_valid_dly1;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg rs2mx_ethfrm_ready_dly1;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg mx2rs_ethfrm_eop_dly1;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg [31:0]mx2rs_ethfrm_data_dly1;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg [1:0]mx2rs_ethfrm_empty_dly1;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg mx2rs_ethfrm_error_dly1;

reg mx2rs_ethfrm_sop_dly2;
reg mx2rs_ethfrm_valid_dly2;
reg rs2mx_ethfrm_ready_dly2;
reg mx2rs_ethfrm_eop_dly2;
reg [31:0]mx2rs_ethfrm_data_dly2;
reg [1:0]mx2rs_ethfrm_empty_dly2;
reg mx2rs_ethfrm_error_dly2;

reg mx2rs_ethfrm_sop_dly3;
reg mx2rs_ethfrm_valid_dly3;
reg rs2mx_ethfrm_ready_dly3;
reg mx2rs_ethfrm_eop_dly3;
reg [31:0]mx2rs_ethfrm_data_dly3;
reg [1:0]mx2rs_ethfrm_empty_dly3;
reg mx2rs_ethfrm_error_dly3;

reg mx2rs_ethfrm_sop_dly4;
reg mx2rs_ethfrm_valid_dly4;
reg rs2mx_ethfrm_ready_dly4;
reg mx2rs_ethfrm_eop_dly4;
reg [31:0]mx2rs_ethfrm_data_dly4;
reg [1:0]mx2rs_ethfrm_empty_dly4;
reg mx2rs_ethfrm_error_dly4;

reg mx2rs_ethfrm_sop_dly5;
reg mx2rs_ethfrm_valid_dly5;
reg rs2mx_ethfrm_ready_dly5;
reg mx2rs_ethfrm_eop_dly5;
reg [31:0]mx2rs_ethfrm_data_dly5;
reg [1:0]mx2rs_ethfrm_empty_dly5;
reg mx2rs_ethfrm_error_dly5;

// reg txdata_sink_ready_dly1;
// reg txdata_sink_ready_dly2;
// reg txdata_sink_ready_dly3;
// reg txdata_sink_ready_dly4;
// reg txdata_sink_ready_dly5;

// reg mx2rs_ethfrm_valid_dly6; 
reg mx2rs_ethfrm_eop_dly6;   
reg mx2rs_ethfrm_eop_dly7;   
// reg [31:0]mx2rs_ethfrm_data_dly6;  
reg [1:0]mx2rs_ethfrm_empty_dly6; 
reg mx2rs_ethfrm_error_dly6; 

wire    txdata_sink_ready;
wire    txdata_sink_ready_gmii16b;
wire    txdata_sink_ready_gmii;

reg txdata_sink_sop;
reg txdata_sink_eop;
reg txdata_sink_valid;

reg [31:0]txdata_sink_data;
reg [2:0]txdata_sink_error;
reg [1:0]txdata_sink_empty;

reg packet_in_progress;

// reg mx2rs_ethfrm_eop_spe_dly1;

wire    cr_crc_inst_en;
reg    cr_crc_inst_en_hold;
// wire    backpressure_inst_crc_2_no_crc;

assign cr_crc_inst_en = csr_crc_inst_en | (mx2rs_frm_type_dly[1] == 1'b1) | ((mx2rs_frm_type[1] == 1'b1) & !cr_crc_inst_en_hold & txdata_sink_ready);

// Select between GMII 16b and GMII interface
assign txdata_sink_ready = (ENABLE_GMII16B == 1) ? txdata_sink_ready_gmii16b : txdata_sink_ready_gmii;

// assign backpressure_inst_crc_2_no_crc = packet_in_progress & mx2rs_ethfrm_sop & mx2rs_ethfrm_valid;

// assign  rs2mx_ethfrm_ready = csr_crc_inst_en?(txdata_sink_ready_dly5):txdata_sink_ready;
// assign rs2mx_ethfrm_ready = !csr_crc_inst_en?txdata_sink_ready:
                            // mx2rs_ethfrm_eop_dly1?(mx2rs_ethfrm_eop & txdata_sink_ready):
                            // txdata_sink_ready;        
// assign  rs2mx_ethfrm_ready = txdata_sink_ready;
// assign  rs2mx_ethfrm_ready =mx2rs_ethfrm_eop_dly1?(mx2rs_ethfrm_eop & txdata_sink_ready):txdata_sink_ready;

always @ (*)
    begin
    if(!cr_crc_inst_en)
        begin
        rs2mx_ethfrm_ready = txdata_sink_ready;
        end
    else
        begin
        if(mx2rs_ethfrm_eop_dly1)
            begin
            rs2mx_ethfrm_ready = (mx2rs_ethfrm_eop & txdata_sink_ready);
            end
        else if(packet_in_progress &&  mx2rs_frm_type_dly[1] == 1'b1 && mx2rs_frm_type[1] == 1'b0)
            begin
            rs2mx_ethfrm_ready = 1'b0;
            end
        else
            begin
            rs2mx_ethfrm_ready = txdata_sink_ready;
            end
        end
    end

always @ (posedge clock_mac)
    if(!reset_mac_n)
        begin
        mx2rs_ethfrm_sop_dly1       <= 0;
        mx2rs_ethfrm_valid_dly1     <= 0;
        mx2rs_ethfrm_eop_dly1       <= 0;
        mx2rs_ethfrm_empty_dly1     <= 0;
        mx2rs_ethfrm_error_dly1     <= 0;
        
        mx2rs_ethfrm_sop_dly2       <= 0;
        mx2rs_ethfrm_valid_dly2     <= 0;
        mx2rs_ethfrm_eop_dly2       <= 0;
        mx2rs_ethfrm_empty_dly2     <= 0;
        mx2rs_ethfrm_error_dly2     <= 0;
        
        mx2rs_ethfrm_sop_dly3       <= 0;
        mx2rs_ethfrm_valid_dly3     <= 0;
        mx2rs_ethfrm_eop_dly3       <= 0;
        mx2rs_ethfrm_empty_dly3     <= 0;
        mx2rs_ethfrm_error_dly3     <= 0;
        
        mx2rs_ethfrm_sop_dly4       <= 0;
        mx2rs_ethfrm_valid_dly4     <= 0;
        mx2rs_ethfrm_eop_dly4       <= 0;
        mx2rs_ethfrm_empty_dly4     <= 0;
        mx2rs_ethfrm_error_dly4     <= 0;
        
        mx2rs_ethfrm_sop_dly5       <= 0;
        mx2rs_ethfrm_valid_dly5     <= 0;
        mx2rs_ethfrm_eop_dly5       <= 0;
        mx2rs_ethfrm_empty_dly5     <= 0;
        mx2rs_ethfrm_error_dly5     <= 0;
        
        // mx2rs_ethfrm_valid_dly6     <= 0;
        mx2rs_ethfrm_eop_dly6       <= 0;
        // mx2rs_ethfrm_data_dly6      <= 0;
        mx2rs_ethfrm_empty_dly6     <= 0;
        mx2rs_ethfrm_error_dly6     <= 0;
        
        mx2rs_ethfrm_eop_dly7       <= 0;
        
        mx2rs_frm_type_dly1         <= 0;
        mx2rs_frm_type_dly2         <= 0;
        mx2rs_frm_type_dly3         <= 0;
        mx2rs_frm_type_dly4         <= 0;      
        mx2rs_frm_type_dly5         <= 0;
        mx2rs_frm_type_dly6         <= 0;
              
        // txdata_sink_ready_dly1      <= 0;
        // txdata_sink_ready_dly2      <= 0;
        // txdata_sink_ready_dly3      <= 0;
        // txdata_sink_ready_dly4      <= 0;
        // txdata_sink_ready_dly5      <= 0;
        
        mx2rs_frm_type_dly          <= 0;
        
        // mx2rs_ethfrm_eop_spe_dly1   <= 0;
        
        txdata_sink_channel         <= 0;
        
        packet_in_progress          <= 0;
        
        cr_crc_inst_en_hold         <= 0;
        end                        
    else
        begin
        cr_crc_inst_en_hold         <= cr_crc_inst_en;
        // mx2rs_ethfrm_eop_spe_dly1       <=mx2rs_ethfrm_eop;
        if(mx2rs_ethfrm_eop && txdata_sink_ready && cr_crc_inst_en)
            begin
            packet_in_progress <= 1'b1;
            end
        else if(txdata_sink_eop && txdata_sink_ready)
            begin
            packet_in_progress <= 1'b0;
            end
        else
            begin
            packet_in_progress <= packet_in_progress;
            end
        
        if(txdata_sink_ready && packet_in_progress &&  mx2rs_frm_type_dly[1] == 1'b1 && mx2rs_frm_type[1] == 1'b0)
            begin
            mx2rs_ethfrm_sop_dly1       <= 0;
            mx2rs_ethfrm_valid_dly1     <= 0;
            mx2rs_ethfrm_eop_dly1       <= 0;
            mx2rs_ethfrm_empty_dly1     <= 0;
            mx2rs_ethfrm_error_dly1     <= 0;
           
            
            mx2rs_frm_type_dly1         <= mx2rs_frm_type_dly1; 
            mx2rs_frm_type_dly2         <= mx2rs_frm_type_dly2 ;
            mx2rs_frm_type_dly3         <= mx2rs_frm_type_dly3;
            mx2rs_frm_type_dly4         <= mx2rs_frm_type_dly4; 
            mx2rs_frm_type_dly5         <= mx2rs_frm_type_dly5 ;
            mx2rs_frm_type_dly6         <= mx2rs_frm_type_dly6; 
            txdata_sink_channel         <= txdata_sink_channel;
            
            end       
        else if(txdata_sink_ready && cr_crc_inst_en)
            begin
            mx2rs_ethfrm_sop_dly1       <= mx2rs_ethfrm_sop;
            mx2rs_ethfrm_valid_dly1     <= mx2rs_ethfrm_valid;
            mx2rs_ethfrm_eop_dly1       <= mx2rs_ethfrm_eop;
            mx2rs_ethfrm_empty_dly1     <= mx2rs_ethfrm_empty;
            mx2rs_ethfrm_error_dly1     <= mx2rs_ethfrm_error;
            
              
            
            
            mx2rs_frm_type_dly1         <= mx2rs_frm_type; 
            mx2rs_frm_type_dly2         <= mx2rs_frm_type_dly1 ;
            mx2rs_frm_type_dly3         <= mx2rs_frm_type_dly2;
            mx2rs_frm_type_dly4         <= mx2rs_frm_type_dly3; 
            mx2rs_frm_type_dly5         <= mx2rs_frm_type_dly4 ;
            mx2rs_frm_type_dly6         <= mx2rs_frm_type_dly5;
            txdata_sink_channel         <= mx2rs_frm_type_dly5;
            
            end
        else if(txdata_sink_ready && !cr_crc_inst_en)      
            begin
            mx2rs_ethfrm_sop_dly1       <= 0;
            mx2rs_ethfrm_valid_dly1     <= 0;
            mx2rs_ethfrm_eop_dly1       <= 0;
            mx2rs_ethfrm_empty_dly1     <= 0;
            mx2rs_ethfrm_error_dly1     <= 0;
           
            
            mx2rs_frm_type_dly1         <= mx2rs_frm_type; 
            mx2rs_frm_type_dly2         <= mx2rs_frm_type_dly1 ;
            mx2rs_frm_type_dly3         <= mx2rs_frm_type_dly2;
            mx2rs_frm_type_dly4         <= mx2rs_frm_type_dly3; 
            mx2rs_frm_type_dly5         <= mx2rs_frm_type_dly4 ;
            mx2rs_frm_type_dly6         <= mx2rs_frm_type_dly5; 
            txdata_sink_channel         <= mx2rs_frm_type;    
            end
         
        
        
        if(txdata_sink_ready)
            begin
            mx2rs_ethfrm_sop_dly2       <= mx2rs_ethfrm_sop_dly1;
            mx2rs_ethfrm_valid_dly2     <= mx2rs_ethfrm_valid_dly1;
            mx2rs_ethfrm_eop_dly2       <= mx2rs_ethfrm_eop_dly1;
            mx2rs_ethfrm_empty_dly2     <= mx2rs_ethfrm_empty_dly1;
            mx2rs_ethfrm_error_dly2     <= mx2rs_ethfrm_error_dly1;
            
            mx2rs_ethfrm_sop_dly3       <= mx2rs_ethfrm_sop_dly2;
            mx2rs_ethfrm_valid_dly3     <= mx2rs_ethfrm_valid_dly2;
            mx2rs_ethfrm_eop_dly3       <= mx2rs_ethfrm_eop_dly2;
            mx2rs_ethfrm_empty_dly3     <= mx2rs_ethfrm_empty_dly2;
            mx2rs_ethfrm_error_dly3     <= mx2rs_ethfrm_error_dly2;
            
            mx2rs_ethfrm_sop_dly4       <= mx2rs_ethfrm_sop_dly3;
            mx2rs_ethfrm_valid_dly4     <= mx2rs_ethfrm_valid_dly3;
            mx2rs_ethfrm_eop_dly4       <= mx2rs_ethfrm_eop_dly3;
            mx2rs_ethfrm_empty_dly4     <= mx2rs_ethfrm_empty_dly3;
            mx2rs_ethfrm_error_dly4     <= mx2rs_ethfrm_error_dly3;
    
            mx2rs_ethfrm_sop_dly5       <= mx2rs_ethfrm_sop_dly4;
            mx2rs_ethfrm_valid_dly5     <= mx2rs_ethfrm_valid_dly4;
            mx2rs_ethfrm_eop_dly5       <= mx2rs_ethfrm_eop_dly4;
            mx2rs_ethfrm_empty_dly5     <= mx2rs_ethfrm_empty_dly4;
            mx2rs_ethfrm_error_dly5     <= mx2rs_ethfrm_error_dly4;
    
            // mx2rs_ethfrm_valid_dly6     <= mx2rs_ethfrm_valid_dly5;
            mx2rs_ethfrm_eop_dly6       <= mx2rs_ethfrm_eop_dly5;
            // mx2rs_ethfrm_data_dly6      <= mx2rs_ethfrm_data_dly5;
            mx2rs_ethfrm_empty_dly6     <= mx2rs_ethfrm_empty_dly5;
            mx2rs_ethfrm_error_dly6     <= mx2rs_ethfrm_error_dly5;
            
            mx2rs_ethfrm_eop_dly7       <= mx2rs_ethfrm_eop_dly6;           
            end
        
        if((mx2rs_ethfrm_sop & rs2mx_ethfrm_ready) || mx2rs_ethfrm_eop_dly7)
            begin
            mx2rs_frm_type_dly <= mx2rs_frm_type;
            end
        else
            begin
            mx2rs_frm_type_dly <= mx2rs_frm_type_dly;
            end
        end
    
    always @ (posedge clock_mac)
        begin
        /* if(txdata_sink_ready && packet_in_progress &&  mx2rs_frm_type_dly[1] == 1'b1 && mx2rs_frm_type[1] == 1'b0)
            begin
            mx2rs_ethfrm_data_dly1      <= 0;            
            end       
        else if(txdata_sink_ready && cr_crc_inst_en)
            begin
            mx2rs_ethfrm_data_dly1      <= mx2rs_ethfrm_data;
            end
        else if(txdata_sink_ready && !cr_crc_inst_en)      
            begin
            mx2rs_ethfrm_data_dly1      <= 0;
            end   */
        if(txdata_sink_ready && (!cr_crc_inst_en || (packet_in_progress &&  mx2rs_frm_type_dly[1] == 1'b1 && mx2rs_frm_type[1] == 1'b0)))
            begin
            mx2rs_ethfrm_data_dly1      <= 0;            
            end         
        else if(txdata_sink_ready && cr_crc_inst_en)
            begin
            mx2rs_ethfrm_data_dly1      <= mx2rs_ethfrm_data;
            end
            
        if(txdata_sink_ready)
            begin
            mx2rs_ethfrm_data_dly5      <= mx2rs_ethfrm_data_dly4;
            mx2rs_ethfrm_data_dly4      <= mx2rs_ethfrm_data_dly3;
            mx2rs_ethfrm_data_dly3      <= mx2rs_ethfrm_data_dly2;
            mx2rs_ethfrm_data_dly2      <= mx2rs_ethfrm_data_dly1;
            end
        end
   
    reg flop_eop;
    always @ (posedge clock_mac)    
        begin
        if(!reset_mac_n)
            begin
            flop_eop <= 1'b1;           
            end
        else
            begin
            if(mx2rs_ethfrm_eop && txdata_sink_ready)
                begin
                flop_eop <= 1'b0;
                end
            else
                begin
                flop_eop <=1'b1;
                end
            end
        end    
    
    
    always @ (posedge clock_mac)    
        begin
        if(!reset_mac_n)
            begin
            txdata_sink_sop <= 1'b0;
            txdata_sink_eop <= 1'b0;
            txdata_sink_valid <= 1'b0;
            txdata_sink_error <= 3'b0;
            txdata_sink_empty <= 2'b0;
            end
        else
            begin
            if(txdata_sink_ready)
                begin
                if(cr_crc_inst_en )
                    begin
                    if(mx2rs_ethfrm_eop_dly5)
                        begin
                        txdata_sink_sop <= 1'b0;
                        txdata_sink_eop <= 1'b0;
                        txdata_sink_valid <= 1'b1;               
                        txdata_sink_error <= 3'b0;
                        txdata_sink_empty <= 2'b0;
                        end
                    else if (mx2rs_ethfrm_eop_dly6)
                        begin
                        txdata_sink_sop <= 1'b0;
                        txdata_sink_eop <= 1'b1;
                        txdata_sink_valid <= 1'b1;
                        txdata_sink_error <= mx2rs_ethfrm_error_dly6;
                        txdata_sink_empty <= mx2rs_ethfrm_empty_dly6;
                        end
                    else
                        begin
                        txdata_sink_sop <= mx2rs_ethfrm_sop_dly5;
                        txdata_sink_eop <= 1'b0;
                        txdata_sink_valid <= mx2rs_ethfrm_valid_dly5;
                        txdata_sink_error <= mx2rs_ethfrm_error_dly5;
                        txdata_sink_empty <= mx2rs_ethfrm_empty_dly5;                    
                        end
                    end
                else
                    begin
                    txdata_sink_sop <= mx2rs_ethfrm_sop;
                    txdata_sink_eop <= mx2rs_ethfrm_eop;
                    txdata_sink_valid <= mx2rs_ethfrm_valid;
                    txdata_sink_error <= mx2rs_ethfrm_error;
                    txdata_sink_empty <= mx2rs_ethfrm_empty;                   
                    end
                end    
            else
                begin
                txdata_sink_sop <= txdata_sink_sop;
                txdata_sink_eop <= txdata_sink_eop;
                txdata_sink_valid <= txdata_sink_valid;
                txdata_sink_error <= txdata_sink_error;
                txdata_sink_empty <= txdata_sink_empty;  
                end
            end
        end
        
    always @ (posedge clock_mac)
        begin
        if(txdata_sink_ready)
            begin
            if(cr_crc_inst_en )
                begin
                if(mx2rs_ethfrm_eop_dly5)
                    begin
                    case(mx2rs_ethfrm_empty_dly5)
                    2'b00:txdata_sink_data <= mx2rs_ethfrm_data_dly5;
                    2'b01:txdata_sink_data <= {mx2rs_ethfrm_data_dly5[31:8],crc2rs_result[31:24]};
                    2'b10:txdata_sink_data <= {mx2rs_ethfrm_data_dly5[31:16],crc2rs_result[31:16]};
                    2'b11:txdata_sink_data <= {mx2rs_ethfrm_data_dly5[31:24],crc2rs_result[31:8]};
                    default:txdata_sink_data <= mx2rs_ethfrm_data_dly5;
                    endcase
                    end
                else if (mx2rs_ethfrm_eop_dly6)
                    begin
                    case(mx2rs_ethfrm_empty_dly6)
                    2'b00:txdata_sink_data <= crc2rs_result;
                    2'b01:txdata_sink_data <= {crc2rs_result[23:0],8'b0};
                    2'b10:txdata_sink_data <= {crc2rs_result[15:0],16'b0};
                    2'b11:txdata_sink_data <= {crc2rs_result[7:0],24'b0};
                    default:txdata_sink_data <= crc2rs_result;
                    endcase
                    end
                else
                    begin
                    txdata_sink_data <= mx2rs_ethfrm_data_dly5;                
                    end
                end
            else
                begin
                txdata_sink_data <= mx2rs_ethfrm_data;        
                end
            end    
        else
            begin
            txdata_sink_data <= txdata_sink_data; 
            end                    
        end
        
alt_em10g32_tx_rs_gmii16b_top #(
  .SYNC_RESET_N(SYNC_RESET_N)
) tx_rs_gmii16b_top(
    .clk_mac            (clock_mac),
    .reset_mac_n        (reset_mac_n),
    .clk_gmii           (clock_gmii),
    .reset_gmii_n       (reset_gmii_n),
    .reset_gmii_n_asyn  (reset_gmii_n_asyn),

    .ipg_value_1g       (ipg_value_1g),
    
    .tx_ethfrm_sop      (txdata_sink_sop),
    .tx_ethfrm_eop      (txdata_sink_eop),
    .tx_ethfrm_valid    (txdata_sink_valid),
    .tx_ethfrm_ready    (txdata_sink_ready_gmii16b),
    .tx_ethfrm_data     (txdata_sink_data),
    .tx_ethfrm_empty    (txdata_sink_empty),
    .tx_ethfrm_error    (|txdata_sink_error),
    .tx_ethfrm_channel  (txdata_sink_channel),
    .tx_clkena          (tx_clkena),
    .gmii16b_tx_en      (wire_gmii16b_source_control),
    .gmii16b_tx_d       (wire_gmii16b_source_data),
    .gmii16b_tx_err     (wire_gmii16b_source_error),
    .gmii16b_tx_channel (wire_gmii16b_source_channel)
);

alt_em10g32_tx_gmii_encoder #(
    .SYMBOLSPERBEAT(4),
    .ENABLE_MEM_ECC(ENABLE_MEM_ECC),
    .FORWARD_SYNC_DEPTH(FORWARD_SYNC_DEPTH),
    .BACKWARD_SYNC_DEPTH(BACKWARD_SYNC_DEPTH),
    .SYNC_RESET_N(SYNC_RESET_N)

    ) gmii_encoder (

    .clk_gmii(clock_gmii),
    .clk_mac(clock_mac), 
    .reset_gmii(reset_gmii_asyn),
    .reset_mac(reset_mac), 
    .flop_eop(flop_eop),
    .ipg_value_1g(ipg_value_1g),    
    .gmii_source_data(wire_gmii_source_data),
    .gmii_source_control(wire_gmii_source_control),
    .gmii_source_error(wire_gmii_source_error),  
    .gmii_source_channel(wire_gmii_source_channel),
    .txdata_sink_sop(txdata_sink_sop),
    .txdata_sink_eop(txdata_sink_eop),
    .txdata_sink_valid(txdata_sink_valid),
    .txdata_sink_ready(txdata_sink_ready_gmii),
    .txdata_sink_data(txdata_sink_data),
    .txdata_sink_error(txdata_sink_error),
    .txdata_sink_empty(txdata_sink_empty),
    .txdata_sink_channel(txdata_sink_channel),
    .tx_clkena(tx_clkena_half_rate),
    .gmii_encoder_ecc_err_corrected(tx_gmii_encoder_ecc_err_corrected),
    .gmii_encoder_ecc_err_fatal(tx_gmii_encoder_ecc_err_fatal)
);

alt_em10g32_tx_gmii_mii_encoder_if #(.SYNC_RESET_N(SYNC_RESET_N)) mii_tx_if(
    .reset(reset_gmii_asyn),                      //INPUT :  Reset
    .tx_clk(clock_gmii),                       //INPUT :  MII Clock
    .tx_clkena(tx_clkena),                   //INPUT :  Clock Enable
    .enan(1'b0),                         //INPUT :  Enable
    .mii_txd(mux_mii_source_data),               //OUTPUT:  MII transmit data
    .mii_txdv(mux_mii_source_control),           //OUTPUT:  MII transmit frame enable  
    .mii_txerr(mux_mii_source_error),            //OUTPUT:  MII transmit frame error
    .mii_txd_i(avst_gmii_data),            //INPUT :  MII transmit data
    .mii_txdv_i(avst_gmii_control),        //INPUT :  MII transmit frame enable  
    .mii_txerr_i(avst_gmii_error)          //INPUT :  MII transmit frame error
);

assign gmii2ptp_gmii_control = (enable_timestamping) ? wire_gmii_source_control : 1'b0;
assign gmii2ptp_gmii_data    = (enable_timestamping) ? wire_gmii_source_data : 8'h0;
assign gmii2ptp_gmii_error   = (enable_timestamping) ? wire_gmii_source_error : 1'b0;
assign gmii2ptp_gmii_channel = (enable_timestamping) ? wire_gmii_source_channel : 2'h0;

assign avst_gmii_control     = (enable_timestamping) ? ptp2gmii_gmii_control : wire_gmii_source_control;
assign avst_gmii_data        = (enable_timestamping) ? ptp2gmii_gmii_data : wire_gmii_source_data;
assign avst_gmii_error       = (enable_timestamping) ? ptp2gmii_gmii_error : wire_gmii_source_error;
    
assign gmii16b2ptp_gmii16b_control = (enable_timestamping) ? wire_gmii16b_source_control : 2'b0;
assign gmii16b2ptp_gmii16b_data    = (enable_timestamping) ? wire_gmii16b_source_data : 16'h0;
assign gmii16b2ptp_gmii16b_error   = (enable_timestamping) ? wire_gmii16b_source_error : 2'b0;
assign gmii16b2ptp_gmii16b_channel = (enable_timestamping) ? wire_gmii16b_source_channel : 2'h0;

assign gmii16b_tx_en               = (enable_timestamping) ? ptp2gmii16b_gmii16b_control : wire_gmii16b_source_control;
assign gmii16b_tx_d                = (enable_timestamping) ? ptp2gmii16b_gmii16b_data : wire_gmii16b_source_data;
assign gmii16b_tx_err              = (enable_timestamping) ? ptp2gmii16b_gmii16b_error : wire_gmii16b_source_error;
endmodule 
