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


//////////////////////////////////////////////////////////////////////////////
// 
// Module: Altera Ethernet MAC 32bit TX RS LAYER
//
// Description: 
//  Assembling the final frame STM_DATA and CRC from TX Frame Muxer into the required STM_DATA packet format
//  Indicating the Frame Muxer when a new frame can be taken while the current one is still in flight.
//  For 10G, a packet is in the following sequences:
//	START: 1 byte
//	PREAMBLE: 7 bytes (default value if not in preamble pass-through mode; use client/user preamble bytes if in preamble pass-through mode)
//	SFD: 1 byte
//	frame STM_DATA: 1 or more bytes
//	CRC32: 4 bytes
//	STM_EFD: 1 byte
//  Maintain a Deficit STM_IDLE Count (DIC) logic to track the number of STM_IDLE bytes (9 to 15) to be inserted for maintaining the required Inter Packet STM_GAP (IPG)
//  Sending out link fault characters when link fault has been detected by MAC RX

// Parameter: 
//  * SYMBOLPERBEAT   = d8
//
// Control:
//  * cr_tx_pause_xonxoff_ctrl[0]   = XON
//  * cr_tx_pause_xonxoff_ctrl[1]   = XOFF
//  * pause_ctrl_sink_data[0]       = XON
//  * pause_ctrl_sink_data[1]       = XOFF
//
//  * cr_tx_pause_select            = 0 (Av-ST) / 1 (CSR)
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_rs_xgmii_layer_ultra #(
    parameter SYMBOLPERBEAT   = 8,
    parameter LINK_FAULT_DATAWIDTH = 2,
    parameter SYNC_RESET_N = 1
) (
    // Clock and reset
    input wire clk,
    input wire rst_n,
    
    // CSR control path
    input wire csr_preamble_passthru,
    input wire csr_crc_inst_en,
    input wire csr_tx_unidirectional_en,
    input wire csr_tx_unidirectional_remote_fault_dis,
    input wire csr_tx_unidirectional_force_remote_fault,
	
	input wire enable_unidirectional,

    
    // Av-ST control path
    input wire [LINK_FAULT_DATAWIDTH-1:0]rx_link_fault_status,
    
    // Av-ST STM_DATA path
    
    input wire mx2rs_ethfrm_sop,
    input wire mx2rs_ethfrm_valid,
    output wire rs2mx_ethfrm_ready,
    input wire mx2rs_ethfrm_eop,
    input wire [31:0]mx2rs_ethfrm_data,
    input wire [1:0]mx2rs_ethfrm_empty,
    input wire [1:0]mx2rs_ethfrm_error,
    
    //
    //input 
    input wire [1:0]mx2rs_frm_type,
    
    //output to CRC
    output wire rs2crc_sop,
    output wire rs2crc_eop,
    output wire [1:0]rs2crc_empty,
    output wire [31:0]rs2crc_data,

    
    //input from CRC
    input wire crc2rs_result_valid,
    input wire [31:0]crc2rs_result,
    
    //input for ipg value
    input wire [7:0]ipg_value_10g,
    
    
    
    // xgmii data to top
    output wire  [31:0]rs2top_eth_xgmii_data,
    output wire  [3:0]rs2top_eth_xgmii_ctrl,    
    output reg  rs2top_eth_xgmii_valid,

    // input wire [31:0]mii_sink_column_data,
    // status to report packet in progress
    output reg tx_packet_in_progress_xgmii_ultra,
    
    
    // 1588
    input  wire        enable_timestamping,
    input  wire        enable_ptp_1step,
    
    output wire [3:0]  xgmii2ptp_xgmii_control,
    output wire [31:0] xgmii2ptp_xgmii_data,
    output wire [1:0]  xgmii2ptp_xgmii_channel,
    
    input  wire [3:0]  ptp2xgmii_xgmii_control,
    input  wire [31:0] ptp2xgmii_xgmii_data

);

localparam SYM_START        = 8'hFB;
localparam SYM_PREAMBLE     = 8'h55;
localparam SYM_SFD          = 8'hD5;
localparam SYM_EFD          = 8'hFD;
localparam SYM_ERR          = 8'hFE;
localparam SYM_SEQ          = 8'h9C;
localparam SYM_REMOTE_FAULT      = 8'h02;
localparam SYM_IDLE         = 8'h07;

//PKT_10G_SM_ps machine parameter
localparam   IDLE           = 3'b000;
localparam   PREAM0         = 3'b001;
localparam   PREAM1         = 3'b010;
localparam   DATA           = 3'b011;
localparam   CRC            = 3'b100;
localparam   EFD            = 3'b101;
localparam   GAP            = 3'b110;
localparam   DATAWCRC       = 3'b111;

reg     [2:0]   PKT_10G_SM_ps; 
reg     [2:0]   PKT_10G_SM_ns;

wire	[1:0]		link_fault_status;
//wire from PKTSM_ps
wire    [2:0]   pktdatasel;

reg     [31:0]eth_pkt_data_10g;
reg     [31:0]eth_pkt_data_10g_dly1;
reg     [31:0]eth_pkt_data_10g_dly2;
reg     [3:0]eth_pkt_ctrl_10g;
reg     [3:0]eth_pkt_ctrl_10g_dly1;
reg     [3:0]eth_pkt_ctrl_10g_dly2;



// output depend on PKT_10G_SM_ps machine
// reg    ipg_insrt_done;
wire    ipg_insrt_done;
wire    ipgphcnt_en;
wire    ipgphcnt_ld;

reg    [1:0]ipgphcnt_nxt; // JH


reg     [1:0]diccnt;
reg     [1:0]ipgphcnt;
reg     ipgphcnt_eq0;
wire    arc_GAP_IDLE;
wire    arc_GAP_PREAM0;

wire    arc_DATA_CRC;
reg     arc_DATA_CRC_dly1;
reg     arc_DATA_CRC_dly2;
reg     arc_DATA_CRC_dly3;
reg     arc_DATA_CRC_dly4;
wire    arc_DATAWCRC_GAP;


reg     mx2rs_ethfrm_sop_dly1;
reg     mx2rs_ethfrm_sop_dly2;

wire    [31:0]mx2rs_ethfrm_revdata;
wire    [31:0]crc2rs_result_revdata;

reg     [31:0]mx2rs_ethfrm_revdata_dly1;

// XGMII  interface
reg     [1:0]link_fault_sts_dly1; 
reg     [1:0]rx_link_fault_status_dly1;
reg     [31:0]result_mux_link_fault_status; 

// interface for new statemachine
wire    	   mode;
// reg             new_eop;
// reg             new_eop_dly1;

reg             int_eop;
reg     [1:0]   int_empty;

reg     [1:0]   int_empty_holdreg;
reg             int_eop_holdreg;
reg             int_eop_holdreg_dly;

reg     [1:0]   eth_pkt_frm_type_10g;

	
reg	[31:0]	temp_rs2top_eth_xgmii_data;
reg	[3:0]	temp_rs2top_eth_xgmii_ctrl;

reg	[31:0]	temp_rs2top_eth_xgmii_data_flop;
reg	[31:0]	temp_rs2top_eth_xgmii_data_flop2;
reg [3:0]	temp_rs2top_eth_xgmii_ctrl_flop;
reg [3:0]	temp_rs2top_eth_xgmii_ctrl_flop2;

// new declare
wire 			out_sop_p1;
wire 			out_valid_p1;
wire 			out_ready_p1;
wire 	[31:0]	out_data_p1;
wire 			out_eop_p1;
wire			in_ready_p1;

wire			mx2rs_sop;
wire	[31:0]	mx2rs_data;
wire			mx2rs_valid; 
wire			mx2rs_eop; 
wire	[1:0]   mx2rs_empty; 

wire    [31:0]  buff_data;
wire    [0:0]   buff_startofpacket;
wire    [0:0]   buff_endofpacket;
wire            buff_ready;
wire    [0:0]   buff_valid;
wire    [1:0]   buff_empty;
wire	[0:0]	buff_error;
wire    [1:0]   buff_frm_type;
reg     [1:0]   buff_frm_type_dly1;
reg     [1:0]   buff_frm_type_hold;


// backpressure after eop
reg after_eop_hold;


// double buffer 
wire     cr_crc_inst_en;
wire     cr_preamble_passthru;

// state machine controller that various due to turn on/off preamble pass through mode
// wire    state_sop;
wire    [31:0]  state_data;
wire    [1:0]   state_error;

wire            state_arc_data_crc_dly1;
wire            state_arc_data_crc;
wire    [31:0]  state_eth_pkt_data_10g;
wire    [3:0]   state_eth_pkt_ctrl_10g;

// control signal for Unidirectional
reg			detect_EFD;
reg			detect_EFD_flop;
reg			detect_EFD_flop2;



// assign state_sop = cr_preamble_passthru?(rs2crc_sop):mx2rs_ethfrm_sop;
// assign state_data = mx2rs_ethfrm_revdata;
assign state_error = {1'b0,buff_error};
assign state_data = mx2rs_ethfrm_revdata_dly1;

assign state_arc_data_crc_dly1 = arc_DATA_CRC_dly2;
assign state_arc_data_crc = arc_DATA_CRC_dly1;
assign state_eth_pkt_data_10g = eth_pkt_data_10g;
assign state_eth_pkt_ctrl_10g = eth_pkt_ctrl_10g;
//  mx2rs_ethfrm_data is in big endian format
// need to ask Arch, something not right. how come preamble passthrough got related to mx2rs_ethfrm_data.it should be different value come from different place. 
assign mx2rs_ethfrm_revdata[7:0] = mx2rs_data[31:24];
assign mx2rs_ethfrm_revdata[15:8] = mx2rs_data[23:16];
assign mx2rs_ethfrm_revdata[23:16] = mx2rs_data[15:8];
assign mx2rs_ethfrm_revdata[31:24] = mx2rs_data[7:0];

assign crc2rs_result_revdata[7:0] = crc2rs_result[31:24];
assign crc2rs_result_revdata[15:8] = crc2rs_result[23:16];
assign crc2rs_result_revdata[23:16] = crc2rs_result[15:8];
assign crc2rs_result_revdata[31:24] = crc2rs_result[7:0];

wire    [31:0]dummy_crc;

assign dummy_crc = 32'b0;
reg		[1:0]hold_empty;

// assign output for CRC
assign rs2crc_sop = (cr_preamble_passthru & mx2rs_frm_type[1] != 1'b1)?(rs2mx_ethfrm_ready & mx2rs_ethfrm_sop_dly2):(rs2mx_ethfrm_ready & mx2rs_ethfrm_sop);
assign rs2crc_eop = mx2rs_ethfrm_eop;
assign rs2crc_empty = mx2rs_ethfrm_empty;
assign rs2crc_data = mx2rs_ethfrm_data;

assign cr_crc_inst_en = csr_crc_inst_en | buff_frm_type[1] | buff_frm_type_hold[1];
assign cr_preamble_passthru = csr_preamble_passthru ;

// rs2top_eth_xgmii_valid counter. this counter will control rs2top_eth_xgmii_valid to make sure that it will asserted for 32 clock cycle out of 33 clock cycle
// reg tx_clkena;

reg [4:0]counter;
reg counter2;

generate if (SYNC_RESET_N == 1) begin
always @ (posedge clk)
    begin
    if(!rst_n)
        begin
        counter <= 5'd0;
        counter2 <= 1'b0;
        rs2top_eth_xgmii_valid <= 1'b0;
        end
    else
        begin
        if(counter != 5'b1_1111 && counter2 != 1'b1)
            begin
            counter <= counter + 5'd1;
            end
        else    
            begin
            counter <= 5'd0;       
            end
        if(counter == 5'b1_1111)
            begin
            counter2 <= 1'b1;
            end
        else
            begin
            counter2 <= 1'b0;
            end
        if(counter2 == 1'b1)
            begin
            rs2top_eth_xgmii_valid <= 1'b0;
            end
        else 
            begin
            rs2top_eth_xgmii_valid <= 1'b1;
            end
        end
    end
end else begin
always @ (posedge clk or negedge rst_n)
    begin
    if(!rst_n)
        begin
        counter <= 5'd0;
        counter2 <= 1'b0;
        rs2top_eth_xgmii_valid <= 1'b0;
        end
    else
        begin
        if(counter != 5'b1_1111 && counter2 != 1'b1)
            begin
            counter <= counter + 5'd1;
            end
        else    
            begin
            counter <= 5'd0;       
            end
        if(counter == 5'b1_1111)
            begin
            counter2 <= 1'b1;
            end
        else
            begin
            counter2 <= 1'b0;
            end
        if(counter2 == 1'b1)
            begin
            rs2top_eth_xgmii_valid <= 1'b0;
            end
        else 
            begin
            rs2top_eth_xgmii_valid <= 1'b1;
            end
        end
    end
end
endgenerate

// SYNC_RESET FLOPS
always @ (posedge clk)
	begin
	if(!rst_n)
		begin
        mx2rs_ethfrm_revdata_dly1 <= 32'b0;
		end
	else
		begin
        if(rs2top_eth_xgmii_valid)
            begin
            mx2rs_ethfrm_revdata_dly1 <= mx2rs_ethfrm_revdata;  
            end
		end
	end   

// SYNC_RESET FLOPS
always @ (posedge clk)
	begin
	if(!rst_n)
		begin
		hold_empty <= 2'b0;
		end
	else
		begin
		if(mx2rs_ethfrm_eop && mx2rs_ethfrm_valid && rs2mx_ethfrm_ready)
			begin
			hold_empty <= mx2rs_ethfrm_empty;
			end          
		end	
	end
    
// SYNC_RESET FLOPS
always @ (posedge clk)
	begin
	if(!rst_n)
		begin
		buff_frm_type_hold <= 2'b0;

		end
	else
		begin
        if(mx2rs_sop && mx2rs_valid && PKT_10G_SM_ns == PREAM1 && rs2top_eth_xgmii_valid)
            begin
            buff_frm_type_hold <= buff_frm_type;
            end
        else if(state_arc_data_crc_dly1 && rs2top_eth_xgmii_valid)    
            begin
            buff_frm_type_hold <= 2'b0;
            end
		end	
	end

// SYNC_RESET FLOPS
always @ (posedge clk)
	begin
	if(!rst_n)
		begin
		after_eop_hold <= 1'b0;
		end
	else
		begin
		if(mx2rs_eop && mx2rs_valid && rs2top_eth_xgmii_valid)
			begin
			after_eop_hold <= 1'b1;
			end
        else if ((PKT_10G_SM_ns == EFD | PKT_10G_SM_ns == GAP) && rs2top_eth_xgmii_valid)
            begin
            after_eop_hold <= 1'b0;    
            end
		end	
	end

    
// NON_RESETABLE FLOPS
// Pipeline flops for eth_pkt_data_10g and eth_pkt_ctrl_10g
always @(posedge clk)
    begin
    if(rs2top_eth_xgmii_valid)
        begin
        eth_pkt_data_10g_dly1 <= eth_pkt_data_10g;
        eth_pkt_data_10g_dly2 <= eth_pkt_data_10g_dly1;
        
        eth_pkt_ctrl_10g_dly1 <= eth_pkt_ctrl_10g;
        eth_pkt_ctrl_10g_dly2 <= eth_pkt_ctrl_10g_dly1;
        end
    end

// SYNC_RESET FLOPS
// flop those delay
always @ (posedge clk)
    begin
    if(!rst_n)
        begin
        
        mx2rs_ethfrm_sop_dly1 <= 1'b0;
        mx2rs_ethfrm_sop_dly2 <= 1'b0;     
       
        arc_DATA_CRC_dly1 <=0;
        arc_DATA_CRC_dly2 <=0;
        arc_DATA_CRC_dly3 <=0;
        arc_DATA_CRC_dly4 <=0;
        
        buff_frm_type_dly1 <= 2'b0;
        end
    else
        begin
        if(rs2top_eth_xgmii_valid)
            begin
            if(mx2rs_ethfrm_valid & rs2mx_ethfrm_ready)
                begin
                mx2rs_ethfrm_sop_dly1 <= mx2rs_ethfrm_sop;
                end
            else
                begin
                mx2rs_ethfrm_sop_dly1 <= 1'b0;
                end
            if(rs2mx_ethfrm_ready)	
                begin
                mx2rs_ethfrm_sop_dly2 <= mx2rs_ethfrm_sop_dly1;
                end

            
            arc_DATA_CRC_dly1 <= arc_DATA_CRC;
            arc_DATA_CRC_dly2 <= arc_DATA_CRC_dly1;
            arc_DATA_CRC_dly3 <= arc_DATA_CRC_dly2;
            arc_DATA_CRC_dly4 <= arc_DATA_CRC_dly3;
        
            buff_frm_type_dly1 <= buff_frm_type;

            end       
        end       
    end
    


    //insert buffer. Can consider this buffer as swallow SC FIFO
    alt_em10g32_rr_buffer #(
           .SYNC_RESET_N(SYNC_RESET_N)
    ) buffer_inst(
    
        .clk        (clk),
        .reset_n    (rst_n),
    
        // sink
        .in_data    (mx2rs_ethfrm_data),
        .in_valid   (mx2rs_ethfrm_valid),
        .in_ready   (in_ready_p1),
        .in_startofpacket   (mx2rs_ethfrm_sop),
        .in_endofpacket     (mx2rs_ethfrm_eop),
        .in_empty   (mx2rs_ethfrm_empty),
        .in_error   (|mx2rs_ethfrm_error),
        .in_channel (mx2rs_frm_type),
    
        // source
        .out_data   (buff_data),
        .out_valid  (buff_valid),
        .out_ready  (buff_ready & rs2top_eth_xgmii_valid),
        .out_startofpacket  (buff_startofpacket),
        .out_endofpacket    (buff_endofpacket),
        .out_empty  (buff_empty),
        .out_error  (buff_error),
        .out_channel (buff_frm_type)
    ); 
	
	
	// To be complete
	
	// Final unit-level source interface
    assign mx2rs_sop    =  buff_startofpacket;
    assign mx2rs_data   = buff_data;
	assign mx2rs_valid = buff_valid;
	assign mx2rs_empty = buff_empty;
	assign mx2rs_eop = buff_endofpacket;
    assign buff_ready = (PKT_10G_SM_ns == GAP | after_eop_hold | (!(cr_preamble_passthru & mx2rs_frm_type[1] != 1'b1) & (PKT_10G_SM_ns == PREAM0 | PKT_10G_SM_ns == PREAM1 )))?1'b0:1'b1;
	
	assign rs2mx_ethfrm_ready = in_ready_p1;
    
	// SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!rst_n)
            begin
            int_empty_holdreg <= 2'b0;   
            int_eop_holdreg <= 1'b0;
            int_eop_holdreg_dly <= 1'b0;
            ipgphcnt_eq0 <= 0;
            end
        else
            begin
            if(rs2top_eth_xgmii_valid)
                begin
                ipgphcnt_eq0 <= (ipgphcnt_nxt == 2'b00);
                end
    
            case({(mx2rs_valid && buff_ready && mx2rs_eop),ipg_insrt_done})
            2'b00:int_empty_holdreg <= int_empty_holdreg[1:0];
            2'b01:int_empty_holdreg <= 2'b00;
            2'b10:int_empty_holdreg <= mx2rs_empty;
            2'b11:int_empty_holdreg <= mx2rs_empty;
            default:int_empty_holdreg <= mx2rs_empty;
            endcase
            
            
            case({(mx2rs_valid && rs2top_eth_xgmii_valid && mx2rs_eop),(PKT_10G_SM_ns == GAP | PKT_10G_SM_ns == EFD)})
            2'b00:int_eop_holdreg <= int_eop_holdreg;
            2'b01:int_eop_holdreg <= 1'b0;
            2'b10:int_eop_holdreg <= 1'b1;
            2'b11:int_eop_holdreg <= 1'b1;
            default:int_eop_holdreg <= int_eop_holdreg;
            endcase 
            
            if(rs2top_eth_xgmii_valid)
                begin
                int_eop_holdreg_dly <= int_eop_holdreg;         
                end       
            end             
        end
    
    always @ (*)
        begin
		int_eop = int_eop_holdreg;
		int_empty = int_empty_holdreg;
        end
 
        
    // SYNC_RESET FLOPS
    // PKT_10G_SM_ps machine
    always @ (posedge clk)
        begin
        if(!rst_n)
            begin
            PKT_10G_SM_ps <= IDLE;
            end
        else
            begin
            if(rs2top_eth_xgmii_valid)
                begin
                PKT_10G_SM_ps <= PKT_10G_SM_ns;
                end
            end
        end
    
        
     always @ (*)
        begin
        case(PKT_10G_SM_ps)  
        IDLE:       if(mx2rs_sop && mx2rs_valid)    
                        begin
                        PKT_10G_SM_ns = PREAM0;
                        end
                    else
                        begin
                        PKT_10G_SM_ns = IDLE;
                        end
        PREAM0:     PKT_10G_SM_ns = PREAM1;                          
        PREAM1:     if(cr_crc_inst_en)
                        begin
                        PKT_10G_SM_ns = DATA;
                        end
                    else
                        begin
                        PKT_10G_SM_ns = DATAWCRC;
                        end                      
        DATA:       if((int_eop && rs2top_eth_xgmii_valid) || int_eop_holdreg_dly)      // if valid deasserted during data?
                        begin
                        PKT_10G_SM_ns = CRC;
                        end
                    else
                        begin
                        PKT_10G_SM_ns = DATA;
                        end
        CRC:        if(int_empty == 0)
                        begin
                        PKT_10G_SM_ns = EFD;
                        end
                    else
                        begin
                        PKT_10G_SM_ns = GAP;
                        end                        
                    
        EFD:        begin
                    PKT_10G_SM_ns = GAP;
                    end
                    
        GAP:        if(ipgphcnt_eq0)  // no need int_ready?
                        begin
                        if(mx2rs_sop && mx2rs_valid) 
                            begin
                            PKT_10G_SM_ns = PREAM0;
                            end
                        else
                            begin
                            PKT_10G_SM_ns = IDLE;
                            end
                        end
                    else
                        begin
                        PKT_10G_SM_ns = GAP;
                        end                        
        DATAWCRC:   if(int_eop & rs2top_eth_xgmii_valid)
                        begin
                        if(int_empty == 0)
                            begin
                            PKT_10G_SM_ns = EFD;
                            end
                        else
                            begin
                            PKT_10G_SM_ns = GAP;
                            end
                        end
                    else
                        begin
                        PKT_10G_SM_ns = DATAWCRC;
                        end
        default:PKT_10G_SM_ns = SYM_IDLE;             
        endcase    
        end

    // Output depends only on the PKT_10G_SM_ps machine
    assign ipgphcnt_en = ((PKT_10G_SM_ps == GAP) && (!ipgphcnt_eq0)) ? 1'b1 : 1'b0;
    assign ipgphcnt_ld = ((PKT_10G_SM_ps != GAP) || (arc_GAP_IDLE) || (arc_GAP_PREAM0))? 1'b1:1'b0;
    
    assign pktdatasel = PKT_10G_SM_ps;
    

	
    // DIC algoritihm logics
    // assign ipg_insrt_done = (ipgphcnt[1:0] == 0) ? 1'b1 : 1'b0;
    assign arc_GAP_IDLE = (PKT_10G_SM_ps == GAP && PKT_10G_SM_ns == IDLE ) ? 1'b1 : 1'b0;
    assign arc_GAP_PREAM0 = (PKT_10G_SM_ps == GAP && PKT_10G_SM_ns == PREAM0) ? 1'b1 : 1'b0;
    
    // wire for CRC
    assign arc_DATA_CRC = (PKT_10G_SM_ps == DATA && PKT_10G_SM_ns == CRC) ? 1'b1:1'b0;
    assign arc_DATAWCRC_GAP = (PKT_10G_SM_ps == DATAWCRC && PKT_10G_SM_ns == GAP) ? 1'b1:1'b0;

    assign ipg_insrt_done = arc_GAP_IDLE || arc_GAP_PREAM0;
    
	// SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!rst_n)
            begin
            diccnt <= 2'b00;
            end
        else
            begin
            // some doubt whether disable tx need to reset DIC or not, MAS got the mux, need to discuss with Architecture later
            if(arc_GAP_IDLE || arc_GAP_PREAM0)
            // if(PKT_10G_SM_ps == GAP)
                begin
                // case(mx2rs_ethfrm_empty)
                case(int_empty)
                2'b00:diccnt <= diccnt;
                2'b01:diccnt <= diccnt + 2'b11;
                2'b10:diccnt <= diccnt + 2'b10; 
                2'b11:diccnt <= diccnt + 2'b01;
                default:diccnt <= 0;
                endcase
                end
            end
        end
    

    
    // JH ********************* START
    
    always @ (*)
        begin
        if(ipgphcnt_ld)
            begin
            if(diccnt == 0 || (diccnt == 1 && int_empty != 1) || ((diccnt == 2 && int_empty != 1) && (diccnt == 2 && int_empty != 2)) || ((diccnt == 3 && int_empty  == 0)) )
                begin
                //ipgphcnt_nxt = 2'b00; 
                // This should be changed to = input port
                ipgphcnt_nxt = ipg_value_10g[1:0];
                end
            else
                begin
                //ipgphcnt_nxt = 2'b01;
                // This should be changed to = input port
                ipgphcnt_nxt = ipg_value_10g[1:0] + 1'b1;
                end
            end
        else
            begin
            if(ipgphcnt_en)
                begin
                ipgphcnt_nxt = ipgphcnt - 1'b1; 
                end
            else
                begin
                ipgphcnt_nxt = ipgphcnt;
                end
            end
        end

        
    // SYNC_RESET FLOPS    
    always @ (posedge clk)
        begin
          if(!rst_n)
              begin
              ipgphcnt <= 2'b10;
              end
          else
              begin
                if(rs2top_eth_xgmii_valid) 
                   begin
                   ipgphcnt <= ipgphcnt_nxt;
                   end
              end
          end

    
    // SYNC_RESET FLOPS    
    // Xgmii interface    
    always @ (posedge clk)
        begin
        if(!rst_n)
            begin
            eth_pkt_data_10g <= 32'h07070707;
            eth_pkt_ctrl_10g <= 4'hF;
            eth_pkt_frm_type_10g <= 2'h0;
            end
        else
            begin
            if(rs2top_eth_xgmii_valid)
                begin
                eth_pkt_frm_type_10g <= buff_frm_type_dly1;
                case(pktdatasel)
                IDLE    :   begin
                            eth_pkt_data_10g <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
                            eth_pkt_ctrl_10g <= {4'b1111};                              
                            end 
                PREAM0  :   begin
                            if(csr_preamble_passthru & !buff_frm_type[1])
                                begin
                                eth_pkt_data_10g <= {state_data[31:8],SYM_START};
                                eth_pkt_ctrl_10g <= {4'b0001};
                                end
                            else
                                begin
                                eth_pkt_data_10g <= {SYM_PREAMBLE,SYM_PREAMBLE,SYM_PREAMBLE,SYM_START};
                                eth_pkt_ctrl_10g <= {4'b0001};
                                end		                              
                            end 
                PREAM1  :   begin
                            if(csr_preamble_passthru & !buff_frm_type[1])
                                begin
                                eth_pkt_data_10g <= {SYM_SFD,state_data[23:0]};
                                eth_pkt_ctrl_10g <= {4'b0000};
                                end
                            else
                                begin
                                eth_pkt_data_10g <= {SYM_SFD,SYM_PREAMBLE,SYM_PREAMBLE,SYM_PREAMBLE};
                                eth_pkt_ctrl_10g <= {4'b0000};
                                end		                              
                            end 			
                DATA    :   begin  
                            
                            if(state_error != 0)
                                begin
                                eth_pkt_data_10g <= {SYM_ERR,SYM_ERR,SYM_ERR,SYM_ERR};   
                                eth_pkt_ctrl_10g <= {4'b1111};
                                end
                            else
                                begin
                                eth_pkt_ctrl_10g <= {4'b0000};
                                eth_pkt_data_10g <= state_data; 
                                end
                            end
                CRC     :   begin
                            case(int_empty)
                            2'b00:  begin
                                    eth_pkt_data_10g <= dummy_crc;
                                    eth_pkt_ctrl_10g <= {4'b0000};
                                    end
                            2'b01:  begin
                                    eth_pkt_data_10g <= {SYM_EFD,dummy_crc[31:8]};
                                    eth_pkt_ctrl_10g <= {4'b1000};
                                    end
                            2'b10:  begin
                                    eth_pkt_data_10g <= {SYM_IDLE,SYM_EFD,dummy_crc[31:16]};
                                    eth_pkt_ctrl_10g <= {4'b1100};
                                    end
                            2'b11:  begin
                                    eth_pkt_data_10g <= {SYM_IDLE,SYM_IDLE,SYM_EFD,dummy_crc[31:24]};
                                    eth_pkt_ctrl_10g <= {4'b1110};
                                    end
                            default:begin
                                    eth_pkt_data_10g <= dummy_crc; 
                                    eth_pkt_ctrl_10g <= {4'b0000};
                                    end
                            endcase        
                            end
                EFD     :   begin
                            eth_pkt_data_10g <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_EFD}; // seen like fishy, everytime EFD will be that place?    
                            eth_pkt_ctrl_10g <= {4'b1111};        
                            end
                GAP     :   begin
                            eth_pkt_data_10g <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
                            eth_pkt_ctrl_10g <= {4'b1111};
                            end
                DATAWCRC  : begin
                            if(state_error != 0)
                                begin
                                eth_pkt_data_10g <= {SYM_ERR,SYM_ERR,SYM_ERR,SYM_ERR};   
                                eth_pkt_ctrl_10g <= {4'b1111};
                                end
                            else
                                begin
                                eth_pkt_ctrl_10g <= {4'b0000};
                                case(int_empty)
                                2'b00:  begin
                                        eth_pkt_data_10g <= state_data;
                                        eth_pkt_ctrl_10g <= {4'b0000};
                                        end
                                2'b01:  begin
                                        eth_pkt_data_10g <= {SYM_EFD,state_data[23:0]};
                                        eth_pkt_ctrl_10g <= {4'b1000};
                                        end
                                2'b10:  begin
                                        eth_pkt_data_10g <= {SYM_IDLE,SYM_EFD,state_data[15:0]};
                                        eth_pkt_ctrl_10g <= {4'b1100};
                                        end
                                2'b11:  begin
                                        eth_pkt_data_10g <= {SYM_IDLE,SYM_IDLE,SYM_EFD,state_data[7:0]};
                                        eth_pkt_ctrl_10g <= {4'b1110};
                                        end
                                default:begin
                                        eth_pkt_data_10g <= state_data; 
                                        eth_pkt_ctrl_10g <= {4'b0000};
                                        end
                                endcase 
                                end
                            end
                default:    begin
                            eth_pkt_data_10g <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
                            eth_pkt_ctrl_10g <= {4'b1111};                              
                            end        
                endcase
                end
            end
        end
    
    // 1588
    assign xgmii2ptp_xgmii_control  = (enable_timestamping) ? eth_pkt_ctrl_10g : 4'h0;
    assign xgmii2ptp_xgmii_data     = (enable_timestamping) ? eth_pkt_data_10g : 32'h0;
    assign xgmii2ptp_xgmii_channel  = (enable_timestamping) ? eth_pkt_frm_type_10g : 2'h0;
	

	
	// SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!rst_n)
			begin
			detect_EFD <= 1'b0;
			detect_EFD_flop <= 1'b1;
			detect_EFD_flop2 <= 1'b0;
			end
		else
			begin
            if(rs2top_eth_xgmii_valid)
                begin
                detect_EFD_flop2 <= detect_EFD_flop;
                
                if((temp_rs2top_eth_xgmii_ctrl[0] == 1'b1 && temp_rs2top_eth_xgmii_data[7:0] == SYM_EFD) || 
                (temp_rs2top_eth_xgmii_ctrl[1] == 1'b1 && temp_rs2top_eth_xgmii_data[15:8] == SYM_EFD) || 
                (temp_rs2top_eth_xgmii_ctrl[2] == 1'b1 && temp_rs2top_eth_xgmii_data[23:16] == SYM_EFD) || 
                (temp_rs2top_eth_xgmii_ctrl[3] == 1'b1 && temp_rs2top_eth_xgmii_data[31:24] == SYM_EFD))
                    begin
                    detect_EFD <= 1'b1;
                    end
                else 
                    begin
                    detect_EFD <= 1'b0;
                    end
    
                
                if(detect_EFD)
                    begin
                    detect_EFD_flop <= 1'b1;
                    end
                else if(temp_rs2top_eth_xgmii_ctrl[0] == 1'b1 && (temp_rs2top_eth_xgmii_data[7:0] == SYM_START))
                    begin
                    detect_EFD_flop <= 1'b0;
                    end
                else
                    begin
                    detect_EFD_flop <= detect_EFD_flop;
                    end              
                end
			end	
		end

        
	////
	assign rs2top_eth_xgmii_data = (enable_unidirectional)?temp_rs2top_eth_xgmii_data_flop2:temp_rs2top_eth_xgmii_data;
	assign rs2top_eth_xgmii_ctrl = (enable_unidirectional)?temp_rs2top_eth_xgmii_ctrl_flop2:temp_rs2top_eth_xgmii_ctrl;
	
     always @ (posedge clk)
		begin
		if(!rst_n)
            begin
            rx_link_fault_status_dly1 <= 2'b0;            
            end
        else
            begin
            if(rs2top_eth_xgmii_valid)
                begin
                if (csr_tx_unidirectional_force_remote_fault)
                    begin
                    rx_link_fault_status_dly1 <= 2'b0;
                    end
                else 
                    begin
                    rx_link_fault_status_dly1 <= rx_link_fault_status;
                    end       
                end
            end
        end    

    
	// SYNC_RESET FLOPS
	always @ (posedge clk)
		begin
		if(!rst_n)
			begin
			temp_rs2top_eth_xgmii_data_flop <= 32'b0;
			temp_rs2top_eth_xgmii_data_flop2 <= 32'b0;
			temp_rs2top_eth_xgmii_ctrl_flop <= 4'b0;
			temp_rs2top_eth_xgmii_ctrl_flop2 <= 4'b0;
			end
		else
			begin
            if(rs2top_eth_xgmii_valid)
                begin
                temp_rs2top_eth_xgmii_data_flop <= temp_rs2top_eth_xgmii_data;
                temp_rs2top_eth_xgmii_ctrl_flop <= temp_rs2top_eth_xgmii_ctrl;
                
                case(rx_link_fault_status_dly1)
                // local fault
                2'b01:	begin
                        // 3 condition. 
                        case({csr_tx_unidirectional_en,csr_tx_unidirectional_remote_fault_dis})
                        2'b00:	begin
                                temp_rs2top_eth_xgmii_data_flop2 <= {SYM_REMOTE_FAULT,8'h00,8'h00,SYM_SEQ};
                                temp_rs2top_eth_xgmii_ctrl_flop2 <= 4'b0001;
                                end
                        2'b01:	begin
                                temp_rs2top_eth_xgmii_data_flop2 <= {SYM_REMOTE_FAULT,8'h00,8'h00,SYM_SEQ};
                                temp_rs2top_eth_xgmii_ctrl_flop2 <= 4'b0001;
                                end		
                        2'b10:	begin
                                if(detect_EFD_flop2 == 1'b1 && detect_EFD_flop != 1'b0)
                                    begin
                                    temp_rs2top_eth_xgmii_data_flop2 <= {SYM_REMOTE_FAULT,8'h00,8'h00,SYM_SEQ};
                                    temp_rs2top_eth_xgmii_ctrl_flop2 <= 4'b0001;
                                    end
                                else
                                    begin
                                    temp_rs2top_eth_xgmii_data_flop2 <= temp_rs2top_eth_xgmii_data_flop;
                                    temp_rs2top_eth_xgmii_ctrl_flop2 <= temp_rs2top_eth_xgmii_ctrl_flop;                               
                                    end
                                end
                        2'b11:	begin                            
                                temp_rs2top_eth_xgmii_data_flop2 <= temp_rs2top_eth_xgmii_data_flop;
                                temp_rs2top_eth_xgmii_ctrl_flop2 <= temp_rs2top_eth_xgmii_ctrl_flop;
                                end
                        default:begin
                                temp_rs2top_eth_xgmii_data_flop2 <= temp_rs2top_eth_xgmii_data_flop;
                                temp_rs2top_eth_xgmii_ctrl_flop2 <= temp_rs2top_eth_xgmii_ctrl_flop;
                                end
                        endcase
                        end
                //remote fault
                2'b10:	begin
                        if(csr_tx_unidirectional_en == 1'b0)
                            begin
                            temp_rs2top_eth_xgmii_data_flop2 <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
                            temp_rs2top_eth_xgmii_ctrl_flop2 <= 4'b1111;
                            end
                        else
                            begin
                            temp_rs2top_eth_xgmii_data_flop2 <= temp_rs2top_eth_xgmii_data_flop;
                            temp_rs2top_eth_xgmii_ctrl_flop2 <= temp_rs2top_eth_xgmii_ctrl_flop;
                            end
                        end	
                // normal mode        
                default:begin
                        if(csr_tx_unidirectional_force_remote_fault)
                            begin
                            temp_rs2top_eth_xgmii_data_flop2 <= {SYM_REMOTE_FAULT,8'h00,8'h00,SYM_SEQ};
                            temp_rs2top_eth_xgmii_ctrl_flop2 <= 4'b0001;
                            end
                        else
                            begin
                            temp_rs2top_eth_xgmii_data_flop2 <= temp_rs2top_eth_xgmii_data_flop;
                            temp_rs2top_eth_xgmii_ctrl_flop2 <= temp_rs2top_eth_xgmii_ctrl_flop;
                            end
                        end
                endcase
                end
			end
		end
	
	////
	assign link_fault_status = enable_unidirectional?2'b00:rx_link_fault_status;
	
	// SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!rst_n)
            begin
            temp_rs2top_eth_xgmii_data <= 32'h07070707;
            temp_rs2top_eth_xgmii_ctrl <= 4'hF;
            link_fault_sts_dly1 <= 2'h0;
            result_mux_link_fault_status <= 32'h0;
            end
        else
            begin
            if(rs2top_eth_xgmii_valid)
                begin
                link_fault_sts_dly1 <= link_fault_status;
                case(link_fault_status)
                2'b00:result_mux_link_fault_status <= 32'b0;
                2'b01:result_mux_link_fault_status <= {SYM_REMOTE_FAULT,8'h00,8'h00,SYM_SEQ};
                2'b10:result_mux_link_fault_status <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
                2'b11:result_mux_link_fault_status <= 32'b0;
                default:result_mux_link_fault_status <= 32'b0;
                endcase        
                if(link_fault_sts_dly1 == 2'b10 || link_fault_sts_dly1 == 2'b01)
                    begin
                    temp_rs2top_eth_xgmii_data <= result_mux_link_fault_status;                
                    end
                else
                    begin                
                    if(cr_crc_inst_en & ~(enable_timestamping & enable_ptp_1step))
                        begin
                        // if(rs2crc_eop_dly2)
                        if(state_arc_data_crc_dly1)
                            begin
                            // ASK ARC crc2rs_result or crc2rs_result_hold
                            case(hold_empty)
                            2'b00:temp_rs2top_eth_xgmii_data <= crc2rs_result_revdata;
                            2'b01:temp_rs2top_eth_xgmii_data <= {SYM_EFD,crc2rs_result_revdata[31:8]};
                            2'b10:temp_rs2top_eth_xgmii_data <= {SYM_IDLE,SYM_EFD,crc2rs_result_revdata[31:16]};
                            2'b11:temp_rs2top_eth_xgmii_data <= {SYM_IDLE,SYM_IDLE,SYM_EFD,crc2rs_result_revdata[31:24]};
                            default: temp_rs2top_eth_xgmii_data <= crc2rs_result_revdata;
                            endcase
                            end
                        else
                            begin
                            case({state_arc_data_crc,hold_empty})
                            3'b100:temp_rs2top_eth_xgmii_data <= state_eth_pkt_data_10g;
                            3'b101:temp_rs2top_eth_xgmii_data <= {crc2rs_result_revdata[7:0],state_eth_pkt_data_10g[23:0]};
                            3'b110:temp_rs2top_eth_xgmii_data <= {crc2rs_result_revdata[15:0],state_eth_pkt_data_10g[15:0]};
                            3'b111:temp_rs2top_eth_xgmii_data <= {crc2rs_result_revdata[23:0],state_eth_pkt_data_10g[7:0]};
                            default:temp_rs2top_eth_xgmii_data <= state_eth_pkt_data_10g;
                            endcase
                            end
                        end
                    else
                        begin
                        
                        temp_rs2top_eth_xgmii_data <= (enable_timestamping & enable_ptp_1step) ? ptp2xgmii_xgmii_data : state_eth_pkt_data_10g;    
                        end                       
                    end   
                    
    
                if(link_fault_sts_dly1 == 2'b00 || link_fault_sts_dly1 == 2'b11)    
                    begin  
                    if(cr_crc_inst_en & ~(enable_timestamping & enable_ptp_1step))
                        begin
                        // if(rs2crc_eop_dly2)
                        if(state_arc_data_crc_dly1)
                            begin
                            case(hold_empty)
                            2'b00:temp_rs2top_eth_xgmii_ctrl <= 4'b0000;
                            2'b01:temp_rs2top_eth_xgmii_ctrl <= 4'b1000;
                            2'b10:temp_rs2top_eth_xgmii_ctrl <= 4'b1100;
                            2'b11:temp_rs2top_eth_xgmii_ctrl <= 4'b1110;
                            default:temp_rs2top_eth_xgmii_ctrl <= 4'b0000;
                            endcase
                            end
                        else
                            begin
                            temp_rs2top_eth_xgmii_ctrl <= state_eth_pkt_ctrl_10g;
                            end
                        end
                    else
                        begin
                        temp_rs2top_eth_xgmii_ctrl <= (enable_timestamping & enable_ptp_1step) ? ptp2xgmii_xgmii_control : state_eth_pkt_ctrl_10g;
                        end
                    end
                else
                    begin
                    case(link_fault_sts_dly1)
                    2'b00:temp_rs2top_eth_xgmii_ctrl <= 4'b0000;
                    2'b01:temp_rs2top_eth_xgmii_ctrl <= 4'b0001;
                    2'b10:temp_rs2top_eth_xgmii_ctrl <= 4'b1111;
                    2'b11:temp_rs2top_eth_xgmii_ctrl <= 4'b0000;
                    default:temp_rs2top_eth_xgmii_ctrl <= 4'b0000;
                    endcase
                    end
                end    
            end
        end
        
    // those piece of logic is use to keep track packet in progress    
    generate if (SYNC_RESET_N == 1) begin
    always @ (posedge clk)
        begin
        if(!rst_n)
            begin
            tx_packet_in_progress_xgmii_ultra <= 1'b0;
            end
        else    
            begin
            if(PKT_10G_SM_ns == PREAM0)
                begin
                tx_packet_in_progress_xgmii_ultra <= 1'b1;
                end
            else if (detect_EFD)  
                begin
                tx_packet_in_progress_xgmii_ultra <= 1'b0;
                end
            end
        end
    end else begin
    always @ (posedge clk or negedge rst_n)
        begin
        if(!rst_n)
            begin
            tx_packet_in_progress_xgmii_ultra <= 1'b0;
            end
        else    
            begin
            if(PKT_10G_SM_ns == PREAM0)
                begin
                tx_packet_in_progress_xgmii_ultra <= 1'b1;
                end
            else if (detect_EFD)  
                begin
                tx_packet_in_progress_xgmii_ultra <= 1'b0;
                end
            end
        end
    end
    endgenerate

endmodule 
