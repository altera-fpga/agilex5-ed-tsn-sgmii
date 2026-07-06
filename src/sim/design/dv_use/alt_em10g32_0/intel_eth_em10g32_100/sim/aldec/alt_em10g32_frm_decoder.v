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
module alt_em10g32_frm_decoder (
    // Clock & Reset
    clk,
    rst_n,
    
    // Configuration from CSR
    csr_tx_crc_insrt_en,
    csr_txvlandet_dis,
    csr_rx_primaddr,
    csr_rx_suppaddr_en0,
    csr_rx_suppaddr_en1,
    csr_rx_suppaddr_en2,
    csr_rx_suppaddr_en3,
    csr_rx_supp_macaddr_0,
    csr_rx_supp_macaddr_1,
    csr_rx_supp_macaddr_2,
    csr_rx_supp_macaddr_3,
    csr_rx_max_datafrmlen,
    csr_rxvlandet_dis,
    csr_rx_allucast_en,
    csr_rx_allmcast_en,
    csr_rx_ignore_pausefrm,
    csr_rx_pfc_ignore_pausefrm_0,
    csr_rx_pfc_ignore_pausefrm_1,
    csr_rx_pfc_ignore_pausefrm_2,
    csr_rx_pfc_ignore_pausefrm_3,
    csr_rx_pfc_ignore_pausefrm_4,
    csr_rx_pfc_ignore_pausefrm_5,
    csr_rx_pfc_ignore_pausefrm_6,
    csr_rx_pfc_ignore_pausefrm_7,
    csr_rx_frm_info_user_type,
    
    // Frame Data
    frm_data,
    frm_sop,
    frm_eop,
    frm_valid,
    frm_empty,
    frm_error,
    
    // Frame Info (Statistics)
    frm_info_stat_valid,
    frm_info_stat_data,
    frm_info_stat_error,
    
    // Frame Info (User Logic)
    frm_info_user_valid,
    frm_info_user_data,
    frm_info_user_error,
    
    // Frame Info for CRC/Pad Remover
    pad_rem_info_valid,
    pad_rem_info_length_type,
    pad_rem_info_length_frm,
    pad_rem_info_ctrl_frm,
    
    // Frame Drop Info
    frm_drop_info_valid,
    frm_drop_info_da_matched,
    frm_drop_info_unicast,
    frm_drop_info_multicast,
    frm_drop_info_broadcast,
    frm_drop_info_ctrl_frm,
    frm_drop_info_pause_frm,
    frm_drop_info_pfc_frm,
    
    // Pause Quanta
    pause_quanta_valid,
    pause_quanta,
    
    // PFC Pause Quanta
    pfc_status_valid,
    pfc_status_pause_quanta_valid,
    pfc_status_pause_quanta_0,
    pfc_status_pause_quanta_1,
    pfc_status_pause_quanta_2,
    pfc_status_pause_quanta_3,
    pfc_status_pause_quanta_4,
    pfc_status_pause_quanta_5,
    pfc_status_pause_quanta_6,
    pfc_status_pause_quanta_7,
    
    // PFC XON/XOFF Status
    pfc_xonxoff_status_valid,
    pfc_xonxoff_status_data
);

// Clock & Reset
input               clk;
input               rst_n;

// Configuration from CSR
input               csr_tx_crc_insrt_en;
input               csr_txvlandet_dis;
input      [47:0]   csr_rx_primaddr;
input               csr_rx_suppaddr_en0;
input               csr_rx_suppaddr_en1;
input               csr_rx_suppaddr_en2;
input               csr_rx_suppaddr_en3;
input      [47:0]   csr_rx_supp_macaddr_0;
input      [47:0]   csr_rx_supp_macaddr_1;
input      [47:0]   csr_rx_supp_macaddr_2;
input      [47:0]   csr_rx_supp_macaddr_3;
input      [15:0]   csr_rx_max_datafrmlen;
input               csr_rxvlandet_dis;
input               csr_rx_allucast_en;
input               csr_rx_allmcast_en;
input               csr_rx_ignore_pausefrm;
input               csr_rx_pfc_ignore_pausefrm_0;
input               csr_rx_pfc_ignore_pausefrm_1;
input               csr_rx_pfc_ignore_pausefrm_2;
input               csr_rx_pfc_ignore_pausefrm_3;
input               csr_rx_pfc_ignore_pausefrm_4;
input               csr_rx_pfc_ignore_pausefrm_5;
input               csr_rx_pfc_ignore_pausefrm_6;
input               csr_rx_pfc_ignore_pausefrm_7;
input               csr_rx_frm_info_user_type;

// Frame Data
input      [31:0]   frm_data;
input               frm_sop;
input               frm_eop;
input               frm_valid;
input      [ 1:0]   frm_empty;
input               frm_error;

// Frame Info (Statistics)
output              frm_info_stat_valid;
output     [39:0]   frm_info_stat_data;
output     [ 2:0]   frm_info_stat_error;

// Frame Info (User Logic)
output              frm_info_user_valid;
output     [39:0]   frm_info_user_data;
output     [ 2:0]   frm_info_user_error;

// Frame Info for CRC/Pad Remover
output              pad_rem_info_valid;
output     [15:0]   pad_rem_info_length_type;
output              pad_rem_info_length_frm;
output              pad_rem_info_ctrl_frm;

// Frame Drop Info
output              frm_drop_info_valid;
output              frm_drop_info_da_matched;
output              frm_drop_info_unicast;
output              frm_drop_info_multicast;
output              frm_drop_info_broadcast;
output              frm_drop_info_ctrl_frm;
output              frm_drop_info_pause_frm;
output              frm_drop_info_pfc_frm;

// Pause Quanta
output              pause_quanta_valid;
output     [15:0]   pause_quanta;

// PFC Pause Quanta
output              pfc_status_valid;
output     [ 7:0]   pfc_status_pause_quanta_valid;
output     [15:0]   pfc_status_pause_quanta_0;
output     [15:0]   pfc_status_pause_quanta_1;
output     [15:0]   pfc_status_pause_quanta_2;
output     [15:0]   pfc_status_pause_quanta_3;
output     [15:0]   pfc_status_pause_quanta_4;
output     [15:0]   pfc_status_pause_quanta_5;
output     [15:0]   pfc_status_pause_quanta_6;
output     [15:0]   pfc_status_pause_quanta_7;

// PFC XON/XOFF Status
output              pfc_xonxoff_status_valid;
output     [15:0]   pfc_xonxoff_status_data;
    
// One-hot State Machine
localparam STM_IDLE             = 12'b0000_0000_0001;
localparam STM_DA_EXT           = 12'b0000_0000_0010;
localparam STM_SA_EXT           = 12'b0000_0000_0100;
localparam STM_L_T_EXT          = 12'b0000_0000_1000;
localparam STM_VLAN_L_T_EXT     = 12'b0000_0001_0000;
localparam STM_SVLAN_L_T_EXT    = 12'b0000_0010_0000;
localparam STM_PQ_0_EXT         = 12'b0000_0100_0000;
localparam STM_PQ_1_2_EXT       = 12'b0000_1000_0000;
localparam STM_PQ_3_4_EXT       = 12'b0001_0000_0000;
localparam STM_PQ_5_6_EXT       = 12'b0010_0000_0000;
localparam STM_PQ_7_EXT         = 12'b0100_0000_0000;
localparam STM_WAIT_EOP         = 12'b1000_0000_0000;

// Constant
localparam TYPE_VLAN_8100            = 16'h8100;
localparam TYPE_VLAN_88A8            = 16'h88A8;
localparam TYPE_VLAN_88F5            = 16'h88F5;
localparam TYPE_VLAN_9100            = 16'h9100;
localparam TYPE_VLAN_9200            = 16'h9200;
localparam TYPE_SVLAN_8100           = 16'h8100;
localparam TYPE_SVLAN_88A8           = 16'h88A8;
localparam TYPE_SVLAN_88F5           = 16'h88F5;
localparam TYPE_SVLAN_9100           = 16'h9100;
localparam TYPE_SVLAN_9200           = 16'h9200;
localparam TYPE_CTRL            = 16'h8808;
localparam OPCODE_PAUSE         = 16'h0001;
localparam OPCODE_PFC           = 16'h0101;
localparam BCAST_ADDR           = 48'hFFFF_FFFF_FFFF;
localparam PAUSE_ADDR           = 48'h0180_C200_0001;
localparam MIN_FRM_SIZE         = 16'd64;


// Internal registers and wires
reg  [11:0] state;
reg  [11:0] next_state;

reg         valid_eop_p1;
reg         valid_eop_p2;
reg         valid_eop_p3;

reg         frm_error_p1;
reg         frm_error_p2;

reg         frm_drop_info_valid_p1;
reg         frm_drop_info_valid_p2;
reg         frm_drop_info_valid_p3;
reg         frm_drop_info_valid_p4;
reg         frm_drop_info_valid_p5;

// Destination address matching
wire [31:0] da_addr_bit47to16;
wire [15:0] da_addr_bit15to0;

reg         primaddr_matched_bit47to40_p1;
reg         suppaddr_0_matched_bit47to40_p1;
reg         suppaddr_1_matched_bit47to40_p1;
reg         suppaddr_2_matched_bit47to40_p1;
reg         suppaddr_3_matched_bit47to40_p1;

reg         primaddr_matched_bit39to32_p1;
reg         suppaddr_0_matched_bit39to32_p1;
reg         suppaddr_1_matched_bit39to32_p1;
reg         suppaddr_2_matched_bit39to32_p1;
reg         suppaddr_3_matched_bit39to32_p1;

reg         primaddr_matched_bit31to24_p1;
reg         suppaddr_0_matched_bit31to24_p1;
reg         suppaddr_1_matched_bit31to24_p1;
reg         suppaddr_2_matched_bit31to24_p1;
reg         suppaddr_3_matched_bit31to24_p1;

reg         primaddr_matched_bit23to16_p1;
reg         suppaddr_0_matched_bit23to16_p1;
reg         suppaddr_1_matched_bit23to16_p1;
reg         suppaddr_2_matched_bit23to16_p1;
reg         suppaddr_3_matched_bit23to16_p1;

reg         primaddr_matched_bit15to8_p2;
reg         suppaddr_0_matched_bit15to8_p2;
reg         suppaddr_1_matched_bit15to8_p2;
reg         suppaddr_2_matched_bit15to8_p2;
reg         suppaddr_3_matched_bit15to8_p2;

reg         primaddr_matched_bit7to0_p2;
reg         suppaddr_0_matched_bit7to0_p2;
reg         suppaddr_1_matched_bit7to0_p2;
reg         suppaddr_2_matched_bit7to0_p2;
reg         suppaddr_3_matched_bit7to0_p2;

reg         primaddr_matched_bit47to16_p2;
reg         suppaddr_0_matched_bit47to16_p2;
reg         suppaddr_1_matched_bit47to16_p2;
reg         suppaddr_2_matched_bit47to16_p2;
reg         suppaddr_3_matched_bit47to16_p2;

reg         primaddr_matched_p3;
reg         suppaddr_0_matched_p3;
reg         suppaddr_1_matched_p3;
reg         suppaddr_2_matched_p3;
reg         suppaddr_3_matched_p3;

// Unicast address detection
reg         ucast_filter_addr_matched;
//reg         ucast_filter_addr_matched_reg;
reg         ucast_addr_matched;
reg         ucast_addr_matched_reg;
reg         ucast_valid;

// Multicast address detection
reg         mcast_addr_matched_bit40_p1_p2;
reg         mcast_addr_matched;
reg         mcast_addr_matched_reg;
reg         mcast_valid;

// Broadcast address detection
reg         bcast_addr_matched_bit47to32_p1;
reg         bcast_addr_matched_bit31to16_p1;
reg         bcast_addr_matched_bit47to16_p2;
reg         bcast_addr_matched_bit15to0_p2;
reg         bcast_addr_matched;
reg         bcast_addr_matched_reg;

// Pause multicast address detection
reg         pause_addr_matched_bit47to32_p1;
reg         pause_addr_matched_bit31to16_p1;
reg         pause_addr_matched_bit47to16_p2;
reg         pause_addr_matched_bit15to0_p2;
reg         pause_addr_matched;

// Length/Type & opcode matching
wire [15:0] length_type_w;
wire [15:0] ctrl_opcode_w;

reg         ctrl_type;
reg         ctrl_frm_reg;
reg         ctrl_frm_valid;

reg         pause_frm;
reg         pause_frm_reg;
reg         pfc_frm;
reg         pfc_frm_reg;

reg         ctrl_type_and_pause_frm;
reg         ctrl_type_and_pfc_frm;

reg         pause_frm_qualify;
reg         pfc_frm_qualify;

// VLAN, SVLAN detection
wire        vlan_frm_w;
reg         vlan_frm;
reg         vlan_frm_reg;
reg         vlan_valid;

wire        svlan_frm_w;
reg         svlan_frm;
reg         svlan_frm_reg;
reg         svlan_valid;

wire        vlan_frm_w_vlandet_dis;
wire        svlan_frm_w_vlandet_dis;
wire        vlandet_dis;

// Length/Type Extraction
reg         length_frm;
reg         length_frm_reg;

reg  [15:0] length_type;
reg  [15:0] length_type_reg;

// Frame Length, Oversized Error, Undersized Error
reg  [16:0] bytes_counter;
reg  [15:0] vlan_len;
reg  [16:0] max_frm_len;
reg  [15:0] frame_len;
reg         oversized_frm;
reg         oversized_any_frm_lsb_gt;
reg         oversized_any_frm_msb_gt;
reg         oversized_any_frm_msb_eq;
reg         oversized_ctrl_frm;
reg         oversized_cntr_ovfl;
wire        oversized_frm_w;
reg         undersized_frm;

// Payload Length, Length Error
reg  [15:0] header_len;
reg  [15:0] count_payload_len;
reg         payload_len_err;

// Pause Frame
wire [15:0] pause_quanta_lsb_w;
wire [15:0] pause_quanta_msb_w;
reg  [15:0] pause_quanta;
// Set SYNCHRONIZER_IDENTIFICATION=OFF because csr_rx_ignore_pausefrm is a pseudo-static CSR field
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg         pause_quanta_valid;

// PFC Frame
reg  [ 7:0] pfc_status_pause_quanta_valid;
reg  [ 7:0] pfc_status_prio_ena;
reg  [15:0] pfc_status_pause_quanta_0;
reg  [15:0] pfc_status_pause_quanta_1;
reg  [15:0] pfc_status_pause_quanta_2;
reg  [15:0] pfc_status_pause_quanta_3;
reg  [15:0] pfc_status_pause_quanta_4;
reg  [15:0] pfc_status_pause_quanta_5;
reg  [15:0] pfc_status_pause_quanta_6;
reg  [15:0] pfc_status_pause_quanta_7;

reg         pfc_status_valid;
reg         pfc_status_xoff_0;
reg         pfc_status_xoff_1;
reg         pfc_status_xoff_2;
reg         pfc_status_xoff_3;
reg         pfc_status_xoff_4;
reg         pfc_status_xoff_5;
reg         pfc_status_xoff_6;
reg         pfc_status_xoff_7;
reg         pfc_status_xon_0;
reg         pfc_status_xon_1;
reg         pfc_status_xon_2;
reg         pfc_status_xon_3;
reg         pfc_status_xon_4;
reg         pfc_status_xon_5;
reg         pfc_status_xon_6;
reg         pfc_status_xon_7;

// CRC/Pad removal pipelines
reg         pad_rem_info_valid_untagged;
reg         pad_rem_info_valid_vlan;
reg         pad_rem_info_valid_svlan;

// vlan/svlan detection disable. this feature is to disable vlan/svlan checking and reflect error during receive frame more than max_framelength.
assign vlandet_dis = csr_txvlandet_dis | csr_rxvlandet_dis;

// SYNC_RESET FLOPS
// State Machine
always @(posedge clk) begin
    if(!rst_n) begin
        state <= STM_IDLE;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        STM_IDLE: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_sop & frm_valid) begin
//                next_state = STM_DA_EXT;
//            end
//            else begin
//                next_state = STM_IDLE;
//            end
				if((frm_sop & frm_valid) && !frm_eop) begin
					next_state = STM_DA_EXT;
				end
				else begin
					next_state = STM_IDLE; 
				end
        end
        
        STM_DA_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_valid) begin
//                next_state = STM_SA_EXT;
//            end
//            else begin
//                next_state = STM_DA_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : STM_SA_EXT;
				end
				else begin
					next_state = STM_DA_EXT;
				end
        end
        
        STM_SA_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_valid) begin
//                next_state = STM_L_T_EXT;
//            end
//            else begin
//                next_state = STM_SA_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : STM_L_T_EXT;
				end
				else begin
					next_state = STM_SA_EXT;
				end
        end
        
        STM_L_T_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(vlan_frm_w & frm_valid) begin
//                next_state = STM_VLAN_L_T_EXT;
//            end
//            else if(frm_valid) begin
//                next_state = STM_PQ_0_EXT;
//            end
//            else begin
//                next_state = STM_L_T_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : 
									 vlan_frm_w ? STM_VLAN_L_T_EXT :
									 STM_PQ_0_EXT;
				end
				else begin
					next_state = STM_L_T_EXT;
				end
        end
        
        STM_PQ_0_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_valid) begin
//                next_state = STM_PQ_1_2_EXT;
//            end
//            else begin
//                next_state = STM_PQ_0_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : STM_PQ_1_2_EXT;
				end
				else begin
					next_state = STM_PQ_0_EXT;
				end
        end
        
        STM_PQ_1_2_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_valid) begin
//                next_state = STM_PQ_3_4_EXT;
//            end
//            else begin
//                next_state = STM_PQ_1_2_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : STM_PQ_3_4_EXT;
				end
				else begin
					next_state = STM_PQ_1_2_EXT;
				end
        end
        
        STM_PQ_3_4_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_valid) begin
//                next_state = STM_PQ_5_6_EXT;
//            end
//            else begin
//                next_state = STM_PQ_3_4_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : STM_PQ_5_6_EXT;
				end
				else begin
					next_state = STM_PQ_3_4_EXT;
				end
        end
        
        STM_PQ_5_6_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_valid) begin
//                next_state = STM_PQ_7_EXT;
//            end
//            else begin
//                next_state = STM_PQ_5_6_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : STM_PQ_7_EXT;
				end
				else begin
					next_state = STM_PQ_5_6_EXT;
				end
        end
        
        STM_PQ_7_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_valid) begin
//                next_state = STM_WAIT_EOP;
//            end
//            else begin
//                next_state = STM_PQ_7_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : STM_WAIT_EOP;
				end
				else begin
					next_state = STM_PQ_7_EXT;
				end
        end
        
        STM_VLAN_L_T_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(svlan_frm_w & frm_valid) begin
//                next_state = STM_SVLAN_L_T_EXT;
//            end
//            else if(frm_valid) begin
//                next_state = STM_WAIT_EOP;
//            end
//            else begin
//                next_state = STM_VLAN_L_T_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : 
									 svlan_frm_w ? STM_SVLAN_L_T_EXT :
									 STM_WAIT_EOP;
				end
				else begin
					next_state = STM_VLAN_L_T_EXT;
				end
        end
        
        STM_SVLAN_L_T_EXT: begin
//            if(frm_eop & frm_valid) begin
//                next_state = STM_IDLE;
//            end
//            else if(frm_valid) begin
//                next_state = STM_WAIT_EOP;
//            end
//            else begin
//                next_state = STM_SVLAN_L_T_EXT;
//            end
				if(frm_valid) begin
					next_state = frm_eop ? STM_IDLE : STM_WAIT_EOP;
				end
				else begin
					next_state = STM_SVLAN_L_T_EXT;
				end
        end
        
        STM_WAIT_EOP: begin
            if(frm_eop & frm_valid) begin
                next_state = STM_IDLE;
            end
            else begin
                next_state = STM_WAIT_EOP;
            end
        end
        
        default: begin
            next_state = STM_IDLE;
        end
    endcase
end

// SYNC_RESET FLOPS
// Pipeline for EOP
always @(posedge clk) begin
    if(!rst_n) begin
        valid_eop_p1 <= 1'b0;
        valid_eop_p2 <= 1'b0;
        valid_eop_p3 <= 1'b0;
        
        frm_error_p1 <= 1'b0;
        frm_error_p2 <= 1'b0;
    end
    else begin
        valid_eop_p1 <= frm_eop & frm_valid;
        valid_eop_p2 <= valid_eop_p1;
        valid_eop_p3 <= valid_eop_p2;
        
        frm_error_p1 <= frm_error;
        frm_error_p2 <= frm_error_p1;
    end
end

// Destination Address matching
assign da_addr_bit47to16[31:0] = frm_data[31:0];
assign da_addr_bit15to0[15:0] = frm_data[31:16];

// NON_RESETABLE FLOPS
// Compare 8-bits by 8-bits to ensure we could meet timing with enough margin
// 
// Comparison only happens when frm_valid is asserted and the result is latched until next frm_valid assertion
// These registers are expected to be in Xs until first frame comes in due to the fact that frm_valid is not
// asserted until a valid frame is received.
//
// Potential issue only occurs if the frm_valid is not asserted continuously in non 10G mode (CASE:176174).
// 
// ucast_filter_addr_matched register is the final consumer for these registers and only using them when
// the state is STM_L_T_EXT, so all the Xs are masked away.
// 
// DO NOT USE these registers directly unless the Xs are handled properly.
always @(posedge clk) begin
    if(frm_valid) begin
        primaddr_matched_bit47to40_p1   <= (da_addr_bit47to16[31:24] == csr_rx_primaddr[47:40]);
        suppaddr_0_matched_bit47to40_p1 <= (da_addr_bit47to16[31:24] == csr_rx_supp_macaddr_0[47:40]);
        suppaddr_1_matched_bit47to40_p1 <= (da_addr_bit47to16[31:24] == csr_rx_supp_macaddr_1[47:40]);
        suppaddr_2_matched_bit47to40_p1 <= (da_addr_bit47to16[31:24] == csr_rx_supp_macaddr_2[47:40]);
        suppaddr_3_matched_bit47to40_p1 <= (da_addr_bit47to16[31:24] == csr_rx_supp_macaddr_3[47:40]);
        
        primaddr_matched_bit39to32_p1   <= (da_addr_bit47to16[23:16] == csr_rx_primaddr[39:32]);
        suppaddr_0_matched_bit39to32_p1 <= (da_addr_bit47to16[23:16] == csr_rx_supp_macaddr_0[39:32]);
        suppaddr_1_matched_bit39to32_p1 <= (da_addr_bit47to16[23:16] == csr_rx_supp_macaddr_1[39:32]);
        suppaddr_2_matched_bit39to32_p1 <= (da_addr_bit47to16[23:16] == csr_rx_supp_macaddr_2[39:32]);
        suppaddr_3_matched_bit39to32_p1 <= (da_addr_bit47to16[23:16] == csr_rx_supp_macaddr_3[39:32]);
        
        primaddr_matched_bit31to24_p1   <= (da_addr_bit47to16[15:8] == csr_rx_primaddr[31:24]);
        suppaddr_0_matched_bit31to24_p1 <= (da_addr_bit47to16[15:8] == csr_rx_supp_macaddr_0[31:24]);
        suppaddr_1_matched_bit31to24_p1 <= (da_addr_bit47to16[15:8] == csr_rx_supp_macaddr_1[31:24]);
        suppaddr_2_matched_bit31to24_p1 <= (da_addr_bit47to16[15:8] == csr_rx_supp_macaddr_2[31:24]);
        suppaddr_3_matched_bit31to24_p1 <= (da_addr_bit47to16[15:8] == csr_rx_supp_macaddr_3[31:24]);
        
        primaddr_matched_bit23to16_p1   <= (da_addr_bit47to16[7:0] == csr_rx_primaddr[23:16]);
        suppaddr_0_matched_bit23to16_p1 <= (da_addr_bit47to16[7:0] == csr_rx_supp_macaddr_0[23:16]);
        suppaddr_1_matched_bit23to16_p1 <= (da_addr_bit47to16[7:0] == csr_rx_supp_macaddr_1[23:16]);
        suppaddr_2_matched_bit23to16_p1 <= (da_addr_bit47to16[7:0] == csr_rx_supp_macaddr_2[23:16]);
        suppaddr_3_matched_bit23to16_p1 <= (da_addr_bit47to16[7:0] == csr_rx_supp_macaddr_3[23:16]);
        
        primaddr_matched_bit15to8_p2    <= (da_addr_bit15to0[15:8] == csr_rx_primaddr[15:8]);
        suppaddr_0_matched_bit15to8_p2  <= (da_addr_bit15to0[15:8] == csr_rx_supp_macaddr_0[15:8]);
        suppaddr_1_matched_bit15to8_p2  <= (da_addr_bit15to0[15:8] == csr_rx_supp_macaddr_1[15:8]);
        suppaddr_2_matched_bit15to8_p2  <= (da_addr_bit15to0[15:8] == csr_rx_supp_macaddr_2[15:8]);
        suppaddr_3_matched_bit15to8_p2  <= (da_addr_bit15to0[15:8] == csr_rx_supp_macaddr_3[15:8]);
        
        primaddr_matched_bit7to0_p2     <= (da_addr_bit15to0[7:0] == csr_rx_primaddr[7:0]);
        suppaddr_0_matched_bit7to0_p2   <= (da_addr_bit15to0[7:0] == csr_rx_supp_macaddr_0[7:0]);
        suppaddr_1_matched_bit7to0_p2   <= (da_addr_bit15to0[7:0] == csr_rx_supp_macaddr_1[7:0]);
        suppaddr_2_matched_bit7to0_p2   <= (da_addr_bit15to0[7:0] == csr_rx_supp_macaddr_2[7:0]);
        suppaddr_3_matched_bit7to0_p2   <= (da_addr_bit15to0[7:0] == csr_rx_supp_macaddr_3[7:0]);
        
        primaddr_matched_bit47to16_p2   <= primaddr_matched_bit47to40_p1 & primaddr_matched_bit39to32_p1 & primaddr_matched_bit31to24_p1 & primaddr_matched_bit23to16_p1;
        suppaddr_0_matched_bit47to16_p2 <= suppaddr_0_matched_bit47to40_p1 & suppaddr_0_matched_bit39to32_p1 & suppaddr_0_matched_bit31to24_p1 & suppaddr_0_matched_bit23to16_p1;
        suppaddr_1_matched_bit47to16_p2 <= suppaddr_1_matched_bit47to40_p1 & suppaddr_1_matched_bit39to32_p1 & suppaddr_1_matched_bit31to24_p1 & suppaddr_1_matched_bit23to16_p1;
        suppaddr_2_matched_bit47to16_p2 <= suppaddr_2_matched_bit47to40_p1 & suppaddr_2_matched_bit39to32_p1 & suppaddr_2_matched_bit31to24_p1 & suppaddr_2_matched_bit23to16_p1;
        suppaddr_3_matched_bit47to16_p2 <= suppaddr_3_matched_bit47to40_p1 & suppaddr_3_matched_bit39to32_p1 & suppaddr_3_matched_bit31to24_p1 & suppaddr_3_matched_bit23to16_p1;
        
        primaddr_matched_p3             <= primaddr_matched_bit47to16_p2 & primaddr_matched_bit15to8_p2 & primaddr_matched_bit7to0_p2;
        suppaddr_0_matched_p3           <= csr_rx_suppaddr_en0 & suppaddr_0_matched_bit47to16_p2 & suppaddr_0_matched_bit15to8_p2 & suppaddr_0_matched_bit7to0_p2;
        suppaddr_1_matched_p3           <= csr_rx_suppaddr_en1 & suppaddr_1_matched_bit47to16_p2 & suppaddr_1_matched_bit15to8_p2 & suppaddr_1_matched_bit7to0_p2;
        suppaddr_2_matched_p3           <= csr_rx_suppaddr_en2 & suppaddr_2_matched_bit47to16_p2 & suppaddr_2_matched_bit15to8_p2 & suppaddr_2_matched_bit7to0_p2;
        suppaddr_3_matched_p3           <= csr_rx_suppaddr_en3 & suppaddr_3_matched_bit47to16_p2 & suppaddr_3_matched_bit15to8_p2 & suppaddr_3_matched_bit7to0_p2;
    end
end

// SYNC_RESET FLOPS
// Unicast address detection
always @(posedge clk) begin
    if(!rst_n) begin
        ucast_filter_addr_matched <= 1'b0;
    end
    else begin
        if(frm_sop & frm_valid) begin
            ucast_filter_addr_matched <= 1'b0;
        end
        // else if(state == STM_L_T_EXT) begin
        else if(state[3]) begin
            ucast_filter_addr_matched <= primaddr_matched_p3 | suppaddr_0_matched_p3 | suppaddr_1_matched_p3 | suppaddr_2_matched_p3 | suppaddr_3_matched_p3;
        end
    end
end

// Unused for now
// always @(posedge clk or negedge rst_n) begin
    // if(!rst_n) begin
        // ucast_filter_addr_matched_reg <= 1'b0;
    // end
    // else begin
        // if(valid_eop_p1) begin
            // ucast_filter_addr_matched_reg <= ucast_filter_addr_matched;
        // end
    // end
// end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        ucast_addr_matched <= 1'b0;
    end
    else begin
        if(frm_sop & frm_valid) begin
            ucast_addr_matched <= ~da_addr_bit47to16[24];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        ucast_addr_matched_reg <= 1'b0;
    end
    else begin
        if(valid_eop_p1) begin
            ucast_addr_matched_reg <= ucast_addr_matched;
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        ucast_valid <= 1'b0;
    end
    else begin
        if(valid_eop_p1) begin
            ucast_valid <= ucast_addr_matched & (ucast_filter_addr_matched | csr_rx_allucast_en);
        end
    end
end

// SYNC_RESET FLOPS
// Multicast address detection
always @(posedge clk) begin
    if(!rst_n) begin
        mcast_addr_matched_bit40_p1_p2 <= 1'b0;
    end
    else begin
        if(frm_valid & frm_sop) begin
            mcast_addr_matched_bit40_p1_p2 <= da_addr_bit47to16[24];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        mcast_addr_matched <= 1'b0;
    end
    else begin
        if(frm_sop & frm_valid) begin
            mcast_addr_matched <= 1'b0;
        end
        // else if(state == STM_SA_EXT) begin
        else if(state[2]) begin
            mcast_addr_matched <= mcast_addr_matched_bit40_p1_p2 & ~(bcast_addr_matched_bit47to16_p2 & bcast_addr_matched_bit15to0_p2);
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        mcast_addr_matched_reg <= 1'b0;
    end
    else begin
        if(valid_eop_p1) begin
            mcast_addr_matched_reg <= mcast_addr_matched;
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        mcast_valid <= 1'b0;
    end
    else begin
        if(valid_eop_p1) begin
            mcast_valid <= mcast_addr_matched & csr_rx_allmcast_en;
        end
    end
end

// SYNC_RESET FLOPS
// Broadcast address detection
always @(posedge clk) begin
    // if(!rst_n) begin
        // bcast_addr_matched_bit47to32_p1 <= 1'b0;
        // bcast_addr_matched_bit31to16_p1 <= 1'b0;
        // bcast_addr_matched_bit15to0_p2  <= 1'b0;
        // bcast_addr_matched_bit47to16_p2 <= 1'b0;
    // end
    // else begin
        if(frm_valid) begin
            bcast_addr_matched_bit47to32_p1 <= &da_addr_bit47to16[31:16]; // BCAST_ADDR
            bcast_addr_matched_bit31to16_p1 <= &da_addr_bit47to16[15:0];  // BCAST_ADDR
            bcast_addr_matched_bit15to0_p2  <= &da_addr_bit15to0[15:0];   // BCAST_ADDR
            bcast_addr_matched_bit47to16_p2 <= bcast_addr_matched_bit47to32_p1 & bcast_addr_matched_bit31to16_p1;
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // bcast_addr_matched <= 1'b0;
    // end
    // else begin
        if(frm_sop & frm_valid) begin
            bcast_addr_matched <= 1'b0;
        end
        // else if(state == STM_SA_EXT) begin
        else if(state[2]) begin
            bcast_addr_matched <= bcast_addr_matched_bit47to16_p2 & bcast_addr_matched_bit15to0_p2;
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // bcast_addr_matched_reg <= 1'b0;
    // end
    // else begin
        if(valid_eop_p1) begin
            bcast_addr_matched_reg <= bcast_addr_matched;
        end
    // end
end

// SYNC_RESET FLOPS
// Pause multicast address detection
always @(posedge clk) begin
    // if(!rst_n) begin
        // pause_addr_matched_bit47to32_p1 <= 1'b0;
        // pause_addr_matched_bit31to16_p1 <= 1'b0;
        // pause_addr_matched_bit15to0_p2  <= 1'b0;
        // pause_addr_matched_bit47to16_p2 <= 1'b0;
    // end
    // else begin
        if(frm_valid) begin
            pause_addr_matched_bit47to32_p1 <= (da_addr_bit47to16[31:16] == PAUSE_ADDR[47:32]);
            pause_addr_matched_bit31to16_p1 <= (da_addr_bit47to16[15:0] == PAUSE_ADDR[31:16]);
            pause_addr_matched_bit15to0_p2  <= (da_addr_bit15to0[15:0] == PAUSE_ADDR[15:0]);
            pause_addr_matched_bit47to16_p2 <= pause_addr_matched_bit47to32_p1 & pause_addr_matched_bit31to16_p1;
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // pause_addr_matched <= 1'b0;
    // end
    // else begin
        if(frm_sop & frm_valid) begin
            pause_addr_matched <= 1'b0;
        end
        // else if(state == STM_SA_EXT) begin
        else if(state[2]) begin
            pause_addr_matched <= pause_addr_matched_bit47to16_p2 & pause_addr_matched_bit15to0_p2;
        end
    // end
end

// Length/Type & opcode matching
assign length_type_w = frm_data[31:16];
assign ctrl_opcode_w = frm_data[15:0];

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        ctrl_type    <= 1'b0;
        ctrl_type_and_pause_frm <= 1'b0;
        ctrl_type_and_pfc_frm <= 1'b0;
    end
    else begin
        if(frm_sop & frm_valid) begin
            ctrl_type    <= 1'b0;
            ctrl_type_and_pause_frm <= 1'b0;
            ctrl_type_and_pfc_frm <= 1'b0;
        end
        // else if(state == STM_L_T_EXT) begin
        else if(state[3]) begin
            ctrl_type    <= (length_type_w == TYPE_CTRL);
            ctrl_type_and_pause_frm <= (length_type_w == TYPE_CTRL) & (ctrl_opcode_w == OPCODE_PAUSE);
            ctrl_type_and_pfc_frm <= (length_type_w == TYPE_CTRL) & (ctrl_opcode_w == OPCODE_PFC);
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        ctrl_frm_reg  <= 1'b0;
        pause_frm_reg <= 1'b0;
        pfc_frm_reg   <= 1'b0;
    end
    else begin
        if(valid_eop_p1) begin
            ctrl_frm_reg  <= ctrl_type;
            pause_frm_reg <= pause_frm;
            pfc_frm_reg   <= pfc_frm;
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // ctrl_frm_valid <= 1'b0;
    // end
    // else begin
        if(valid_eop_p2) begin
            ctrl_frm_valid <= ctrl_frm_reg & (ucast_valid | mcast_valid | bcast_addr_matched_reg);
        end
    // end
end

// SYNC_RESET FLOPS
/* always @(posedge clk) begin
    if(!rst_n) begin
        pause_frm <= 1'b0;
        pfc_frm   <= 1'b0;
    end
    else begin
        pause_frm <= (ctrl_type & pause_opcode) & (pause_addr_matched | (ucast_addr_matched & (ucast_filter_addr_matched | csr_rx_allucast_en)));
        pfc_frm   <= (ctrl_type & pfc_opcode) & (pause_addr_matched);
    end
end */

always @(posedge clk) begin
    if(!rst_n) begin
        pause_frm_qualify <= 1'b0;
        pfc_frm_qualify <= 1'b0;
    end
    else begin
        pause_frm_qualify <= (pause_addr_matched | (ucast_addr_matched & (ucast_filter_addr_matched | csr_rx_allucast_en)));
        pfc_frm_qualify <= pause_addr_matched;
    
    end
end
    
    
always @ (*) begin

    pause_frm = pause_frm_qualify & ctrl_type_and_pause_frm;
    pfc_frm = pfc_frm_qualify & ctrl_type_and_pfc_frm;
end    

// VLAN, SVLAN detection
assign vlan_frm_w = ((length_type_w[15:0] == TYPE_VLAN_8100)|| (length_type_w[15:0] == TYPE_VLAN_88A8) || (length_type_w[15:0] == TYPE_VLAN_88F5) || (length_type_w[15:0] == TYPE_VLAN_9100) || (length_type_w[15:0] == TYPE_VLAN_9200)) & ~vlandet_dis;
assign svlan_frm_w = ((length_type_w[15:0] == TYPE_SVLAN_8100)|| (length_type_w[15:0] == TYPE_SVLAN_88A8) || (length_type_w[15:0] == TYPE_SVLAN_88F5) || (length_type_w[15:0] == TYPE_SVLAN_9100) || (length_type_w[15:0] == TYPE_SVLAN_9200))  & ~vlandet_dis;
assign vlan_frm_w_vlandet_dis = ((length_type_w[15:0] == TYPE_VLAN_8100)|| (length_type_w[15:0] == TYPE_VLAN_88A8) || (length_type_w[15:0] == TYPE_VLAN_88F5) || (length_type_w[15:0] == TYPE_VLAN_9100) || (length_type_w[15:0] == TYPE_VLAN_9200)) & vlandet_dis;
assign svlan_frm_w_vlandet_dis = ((length_type_w[15:0] == TYPE_SVLAN_8100)|| (length_type_w[15:0] == TYPE_SVLAN_88A8) || (length_type_w[15:0] == TYPE_SVLAN_88F5) || (length_type_w[15:0] == TYPE_SVLAN_9100) || (length_type_w[15:0] == TYPE_SVLAN_9200)) & vlandet_dis;

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // vlan_frm <= 1'b0;
    // end
    // else begin
        if(frm_sop & frm_valid) begin
            vlan_frm <= 1'b0;
        end
        // else if(state == STM_VLAN_L_T_EXT) begin
        else if(state[4]) begin
            vlan_frm <= ~svlan_frm_w;
        end
        // else if(state == STM_L_T_EXT) begin
        else if(state[3]) begin
            vlan_frm <= vlan_frm_w;
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // svlan_frm <= 1'b0;
    // end
    // else begin
        if(frm_sop & frm_valid) begin
            svlan_frm <= 1'b0;
        end
        // else if(state == STM_VLAN_L_T_EXT) begin
        else if(state[4]) begin
            svlan_frm <= svlan_frm_w;
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // vlan_frm_reg <= 1'b0;
    // end
    // else begin
        if(valid_eop_p1) begin
            vlan_frm_reg <= vlan_frm;
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // vlan_valid <= 1'b0;
    // end
    // else begin
        if(valid_eop_p2) begin
            vlan_valid <= vlan_frm_reg & (ucast_valid | mcast_valid | bcast_addr_matched_reg);
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // svlan_frm_reg <= 1'b0;
    // end
    // else begin
        if(valid_eop_p1) begin
            svlan_frm_reg <= svlan_frm;
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    // if(!rst_n) begin
        // svlan_valid <= 1'b0;
    // end
    // else begin
        if(valid_eop_p2) begin
            svlan_valid <= svlan_frm_reg & (ucast_valid | mcast_valid | bcast_addr_matched_reg);
        end
    // end
end

// SYNC_RESET FLOPS
// Length/Type Extraction
always @(posedge clk) begin
    // if(!rst_n) begin
        // length_frm <= 1'b0;
    // end
    // else begin
        if(frm_sop & frm_valid) begin
            length_frm <= 1'b0;
        end
        // else if((state == STM_L_T_EXT) || (state == STM_VLAN_L_T_EXT) || (state == STM_SVLAN_L_T_EXT)) begin
        else if(|state[5:3]) begin
            // Explicitly specify the comparison logic
            //length_frm <= ~((|length_type_w[15:11]) | (&length_type_w[10:9])); // < 16'h0600
            length_frm <= (length_type_w < 16'h0600)  ;
        end
    // end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(valid_eop_p1) begin
        // if vlandet_dis is 1, then only normal frame will check for payload length, vlan and svlan will not check.
        length_frm_reg <= length_frm & ~(vlan_frm_w_vlandet_dis || svlan_frm_w_vlandet_dis);
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        length_type <= 16'h0;
    end
    else begin
        if(frm_sop & frm_valid) begin
            length_type <= 16'h0;
        end
        // else if((state == STM_L_T_EXT) || (state == STM_VLAN_L_T_EXT) || (state == STM_SVLAN_L_T_EXT)) begin
        else if(|state[5:3]) begin
            length_type <= length_type_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if (!rst_n) begin
        length_type_reg <= 16'h0;
    end
    else begin
        if(valid_eop_p1) begin
            length_type_reg <= length_type;
        end
    end
end

// SYNC_RESET FLOPS
// Frame Length, Oversized Error, Undersized Error
always @(posedge clk) begin
  if(!rst_n) begin
      bytes_counter <= 17'h0;
  end
  else begin
        if(frm_valid) begin
            // Count up every clock cycles based on empty value
            // Inverting empty value + 1 will give us the number of bytes for the particular cycle
            // CSR CRC insertion is used to cater for TX architecture which receive the input frame before 4-bytes are allocated at the end
            bytes_counter <= frm_sop             ? (csr_tx_crc_insrt_en ? (16'h5 + {14'h0, ~frm_empty[1:0]}) : (16'h1 + {14'h0, ~frm_empty[1:0]})) :    // initialise on frm_sop
                             bytes_counter[16]   ? bytes_counter                                             : // If overflow, stop counting. Wait for next SOP to reset
                             (bytes_counter + 16'h1 + {14'h0, ~frm_empty[1:0]});    // Else, increment as usual
        end
  end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        vlan_len    <= 16'h0;
        max_frm_len <= 17'h0;
    end
    else begin
        vlan_len    <= svlan_frm ? 16'h8 : (vlan_frm ? 16'h4 : 16'h0);
        
        // Maximum frame length are determined by VLAN or SVLAN tag
        // Eg: when CSR max frame length register is configured to 1518, SVLAN frame could be as large as 1526
        max_frm_len <= csr_rx_max_datafrmlen + (vlandet_dis?16'h0:vlan_len);
    end
end

// NON_RESETABLE FLOPS
always @(posedge clk) begin
    if(valid_eop_p1) begin
        frame_len <= bytes_counter[16] ? 16'hFFFF : bytes_counter[15:0];
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        oversized_frm            <= 1'b0;
        oversized_any_frm_lsb_gt <= 1'b0;
        oversized_any_frm_msb_gt <= 1'b0;
        oversized_any_frm_msb_eq <= 1'b0;
        oversized_ctrl_frm       <= 1'b0;
        oversized_cntr_ovfl      <= 1'b0;
    end
    else begin
        if(valid_eop_p1) begin
            // Control frame > 16'd64, other frames > CSR Max Frame Length register
            // Could not meet timing with enough marging using 16-bits comparator in Arria V
            // Thus the comparator are splitted to multiple 8-bits comparators
            // And use the 1-bit output from each comparator to determine if it is oversized
            // Stratix V or above might be able to meet timing, however the code will be kept for easier porting in the future if slow devices need to be supported
            // Internal counter and max frm len has a max value of 64k. In the event of counter overflow, assert oversized_frm_w to notify user of an error
            oversized_any_frm_lsb_gt <= (bytes_counter[7:0] > max_frm_len[7:0]);
            oversized_any_frm_msb_gt <= (bytes_counter[15:8] > max_frm_len[15:8]) & (max_frm_len[16] == 1'b0);
            oversized_any_frm_msb_eq <= (bytes_counter[15:8] == max_frm_len[15:8]) & (max_frm_len[16] == 1'b0);
            //oversized_ctrl_frm       <= (|bytes_counter[15:6] & (|bytes_counter[5:0]) & ctrl_type);
            oversized_ctrl_frm       <= ((bytes_counter[16:0] > 16'd64) && ctrl_type);
            oversized_cntr_ovfl       <= bytes_counter[16];
        end
        
        if(valid_eop_p2) begin
            oversized_frm            <= oversized_frm_w;
        end
    end
end

assign oversized_frm_w = (oversized_any_frm_msb_gt | (oversized_any_frm_msb_eq & oversized_any_frm_lsb_gt)) | oversized_ctrl_frm | oversized_cntr_ovfl;

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        undersized_frm <= 1'b0;
    end
    else begin
        if(valid_eop_p1) begin
            // Explicitly specify the condition to determine undersized frame
            // To reduce number of bits usage
            //undersized_frm <= ~(|bytes_counter[15:6]); // < 16'd64
            undersized_frm <= (bytes_counter[15:0] < 16'd64) & (bytes_counter[16] == 1'b0);
        end
    end
end

// NON_RESETABLE FLOPS
// Payload Length, Length Error
always @(posedge clk) begin
    header_len <= ctrl_type ? 16'd20 : (svlan_frm ? 16'd26 : (vlan_frm ? 16'd22 : 16'd18));
end

// NON_RESETABLE FLOPS
always @(posedge clk) begin
    if(valid_eop_p1) begin
        count_payload_len <= bytes_counter[16] ? 16'hFFFF : bytes_counter[15:0] - header_len[15:0];
    end
end

// NON_RESETABLE FLOPS
always @(posedge clk) begin
    payload_len_err <= (length_type_reg[15:0] > count_payload_len[15:0]) & length_frm_reg;
end

// Pause Frame
assign pause_quanta_lsb_w[15:0] = frm_data[31:16];
assign pause_quanta_msb_w[15:0] = frm_data[15:0];

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pause_quanta <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_0_EXT) begin
        if(state[6]) begin
            pause_quanta <= pause_quanta_lsb_w;
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pause_quanta_valid <= 1'b0;
    end
    else begin
        pause_quanta_valid <= pause_frm_reg & ~csr_rx_ignore_pausefrm & ~(oversized_frm_w | undersized_frm | frm_error_p2) & valid_eop_p2;
    end
end

// SYNC_RESET FLOPS
// PFC Frame
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_valid[7:0] <= 8'h0;
    end
    else begin
        // if(state == STM_PQ_0_EXT) begin
        if(state[6]) begin
            pfc_status_pause_quanta_valid[0] <= pause_quanta_lsb_w[0] & ~csr_rx_pfc_ignore_pausefrm_0;
            pfc_status_pause_quanta_valid[1] <= pause_quanta_lsb_w[1] & ~csr_rx_pfc_ignore_pausefrm_1;
            pfc_status_pause_quanta_valid[2] <= pause_quanta_lsb_w[2] & ~csr_rx_pfc_ignore_pausefrm_2;
            pfc_status_pause_quanta_valid[3] <= pause_quanta_lsb_w[3] & ~csr_rx_pfc_ignore_pausefrm_3;
            pfc_status_pause_quanta_valid[4] <= pause_quanta_lsb_w[4] & ~csr_rx_pfc_ignore_pausefrm_4;
            pfc_status_pause_quanta_valid[5] <= pause_quanta_lsb_w[5] & ~csr_rx_pfc_ignore_pausefrm_5;
            pfc_status_pause_quanta_valid[6] <= pause_quanta_lsb_w[6] & ~csr_rx_pfc_ignore_pausefrm_6;
            pfc_status_pause_quanta_valid[7] <= pause_quanta_lsb_w[7] & ~csr_rx_pfc_ignore_pausefrm_7;
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_prio_ena[7:0] <= 8'h0;
    end
    else begin
        // if(state == STM_PQ_0_EXT) begin
        if(state[6]) begin
            pfc_status_prio_ena[7:0] <= pause_quanta_lsb_w[7:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_0[15:0] <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_0_EXT) begin
        if(state[6]) begin
            pfc_status_pause_quanta_0[15:0] <= pause_quanta_msb_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_1[15:0] <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_1_2_EXT) begin
        if(state[7]) begin
            pfc_status_pause_quanta_1[15:0] <= pause_quanta_lsb_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_2[15:0] <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_1_2_EXT) begin
        if(state[7]) begin
            pfc_status_pause_quanta_2[15:0] <= pause_quanta_msb_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_3[15:0] <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_3_4_EXT) begin
        if(state[8]) begin
            pfc_status_pause_quanta_3[15:0] <= pause_quanta_lsb_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_4[15:0] <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_3_4_EXT) begin
        if(state[8]) begin
            pfc_status_pause_quanta_4[15:0] <= pause_quanta_msb_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_5[15:0] <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_5_6_EXT) begin
        if(state[9]) begin
            pfc_status_pause_quanta_5[15:0] <= pause_quanta_lsb_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_6[15:0] <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_5_6_EXT) begin
        if(state[9]) begin
            pfc_status_pause_quanta_6[15:0] <= pause_quanta_msb_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_pause_quanta_7[15:0] <= 16'h0;
    end
    else begin
        // if(state == STM_PQ_7_EXT) begin
        if(state[10]) begin
            pfc_status_pause_quanta_7[15:0] <= pause_quanta_lsb_w[15:0];
        end
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_valid <= 1'b0;
    end
    else begin
        pfc_status_valid <= pfc_frm_reg & ~(oversized_frm_w | undersized_frm | frm_error_p2) & valid_eop_p2;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xoff_0 <= 1'b0;
    end
    else begin
        pfc_status_xoff_0 <= |pfc_status_pause_quanta_0[15:0] & pfc_status_prio_ena[0] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xoff_1 <= 1'b0;
    end
    else begin
        pfc_status_xoff_1 <= |pfc_status_pause_quanta_1[15:0] & pfc_status_prio_ena[1] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xoff_2 <= 1'b0;
    end
    else begin
        pfc_status_xoff_2 <= |pfc_status_pause_quanta_2[15:0] & pfc_status_prio_ena[2] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xoff_3 <= 1'b0;
    end
    else begin
        pfc_status_xoff_3 <= |pfc_status_pause_quanta_3[15:0] & pfc_status_prio_ena[3] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xoff_4 <= 1'b0;
    end
    else begin
        pfc_status_xoff_4 <= |pfc_status_pause_quanta_4[15:0] & pfc_status_prio_ena[4] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xoff_5 <= 1'b0;
    end
    else begin
        pfc_status_xoff_5 <= |pfc_status_pause_quanta_5[15:0] & pfc_status_prio_ena[5] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xoff_6 <= 1'b0;
    end
    else begin
        pfc_status_xoff_6 <= |pfc_status_pause_quanta_6[15:0] & pfc_status_prio_ena[6] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xoff_7 <= 1'b0;
    end
    else begin
        pfc_status_xoff_7 <= |pfc_status_pause_quanta_7[15:0] & pfc_status_prio_ena[7] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xon_0 <= 1'b0;
    end
    else begin
        pfc_status_xon_0 <= ~(|pfc_status_pause_quanta_0[15:0]) & pfc_status_prio_ena[0] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xon_1 <= 1'b0;
    end
    else begin
        pfc_status_xon_1 <= ~(|pfc_status_pause_quanta_1[15:0]) & pfc_status_prio_ena[1] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xon_2 <= 1'b0;
    end
    else begin
        pfc_status_xon_2 <= ~(|pfc_status_pause_quanta_2[15:0]) & pfc_status_prio_ena[2] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xon_3 <= 1'b0;
    end
    else begin
        pfc_status_xon_3 <= ~(|pfc_status_pause_quanta_3[15:0]) & pfc_status_prio_ena[3] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xon_4 <= 1'b0;
    end
    else begin
        pfc_status_xon_4 <= ~(|pfc_status_pause_quanta_4[15:0]) & pfc_status_prio_ena[4] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xon_5 <= 1'b0;
    end
    else begin
        pfc_status_xon_5 <= ~(|pfc_status_pause_quanta_5[15:0]) & pfc_status_prio_ena[5] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xon_6 <= 1'b0;
    end
    else begin
        pfc_status_xon_6 <= ~(|pfc_status_pause_quanta_6[15:0]) & pfc_status_prio_ena[6] & pfc_frm_reg;
    end
end

// SYNC_RESET FLOPS
always @(posedge clk) begin
    if(!rst_n) begin
        pfc_status_xon_7 <= 1'b0;
    end
    else begin
        pfc_status_xon_7 <= ~(|pfc_status_pause_quanta_7[15:0]) & pfc_status_prio_ena[7] & pfc_frm_reg;
    end
end

// PFC status valid asserts only when pfc_xonxoff_status_data does not equal to zeros
assign pfc_xonxoff_status_valid = valid_eop_p3 & (|pfc_xonxoff_status_data[15:0]);

assign pfc_xonxoff_status_data = {pfc_status_xoff_7, pfc_status_xon_7,
                                  pfc_status_xoff_6, pfc_status_xon_6,
                                  pfc_status_xoff_5, pfc_status_xon_5,
                                  pfc_status_xoff_4, pfc_status_xon_4,
                                  pfc_status_xoff_3, pfc_status_xon_3,
                                  pfc_status_xoff_2, pfc_status_xon_2,
                                  pfc_status_xoff_1, pfc_status_xon_1,
                                  pfc_status_xoff_0, pfc_status_xon_0};

// SYNC_RESET FLOPS
// Frame Drop Info
always @(posedge clk) begin
    if(!rst_n) begin
        frm_drop_info_valid_p1 <= 1'b0;
        frm_drop_info_valid_p2 <= 1'b0;
        frm_drop_info_valid_p3 <= 1'b0;
        frm_drop_info_valid_p4 <= 1'b0;
        frm_drop_info_valid_p5 <= 1'b0;
    end
    else begin
        // Clear all the pipelines to ensure it will not affect subsequent packet of extreme-undersized frames
        if(frm_valid & frm_sop) begin
            frm_drop_info_valid_p1 <= 1'b1;
            frm_drop_info_valid_p2 <= 1'b0;
            frm_drop_info_valid_p3 <= 1'b0;
            frm_drop_info_valid_p4 <= 1'b0;
            frm_drop_info_valid_p5 <= 1'b0;
        end
        else begin
            // Shift the valid signal, so that it is aligned to 4th cycle data (L/T)
            if(frm_valid) begin
                frm_drop_info_valid_p1 <= 1'b0;
                frm_drop_info_valid_p2 <= frm_drop_info_valid_p1;
                frm_drop_info_valid_p3 <= frm_drop_info_valid_p2;
            end
            
            // Delay the valid signal to align with pause/PFC frame indicator
            frm_drop_info_valid_p4 <= frm_drop_info_valid_p3 & frm_valid;
            frm_drop_info_valid_p5 <= frm_drop_info_valid_p4;
        end
    end
end

assign frm_drop_info_valid      = frm_drop_info_valid_p5;
assign frm_drop_info_da_matched = ucast_filter_addr_matched;
assign frm_drop_info_unicast    = ucast_addr_matched;
assign frm_drop_info_multicast  = mcast_addr_matched;
assign frm_drop_info_broadcast  = bcast_addr_matched;
assign frm_drop_info_ctrl_frm   = ctrl_type;
assign frm_drop_info_pause_frm  = pause_frm;
assign frm_drop_info_pfc_frm    = pfc_frm;

// SYNC_RESET FLOPS
// Frame Info for CRC/Pad Remover
always @(posedge clk) begin
    if(!rst_n) begin
        pad_rem_info_valid_untagged <= 1'b0;
        pad_rem_info_valid_vlan     <= 1'b0;
        pad_rem_info_valid_svlan    <= 1'b0;
    end
    else begin
        // if(state == STM_L_T_EXT) begin
        if(state[3]) begin
            pad_rem_info_valid_untagged <= frm_valid;
        end
        else begin
            pad_rem_info_valid_untagged <= 1'b0;
        end
        
        // if(state == STM_VLAN_L_T_EXT) begin
        if(state[4]) begin
            pad_rem_info_valid_vlan <= frm_valid;
        end
        else begin
            pad_rem_info_valid_vlan <= 1'b0;
        end
        
        // if(state == STM_SVLAN_L_T_EXT) begin
        if(state[5]) begin
            pad_rem_info_valid_svlan <= frm_valid;
        end
        else begin
            pad_rem_info_valid_svlan <= 1'b0;
        end
    end
end

assign pad_rem_info_valid = (pad_rem_info_valid_untagged & ~vlan_frm) | (pad_rem_info_valid_vlan & ~svlan_frm) | (pad_rem_info_valid_svlan);

assign pad_rem_info_length_type = length_type;
assign pad_rem_info_length_frm = length_frm;
assign pad_rem_info_ctrl_frm = ctrl_type;

// Frame Info (Statistics)
assign frm_info_stat_valid = valid_eop_p3;

assign frm_info_stat_data[15:0] = count_payload_len[15:0];
assign frm_info_stat_data[31:16] = frame_len[15:0];
assign frm_info_stat_data[32] = svlan_valid;
assign frm_info_stat_data[33] = vlan_valid;
assign frm_info_stat_data[34] = ctrl_frm_valid;
assign frm_info_stat_data[35] = pause_frm_reg;
assign frm_info_stat_data[36] = bcast_addr_matched_reg;
assign frm_info_stat_data[37] = mcast_valid;
assign frm_info_stat_data[38] = ucast_valid;
assign frm_info_stat_data[39] = pfc_frm_reg;

assign frm_info_stat_error[0] = undersized_frm;
assign frm_info_stat_error[1] = oversized_frm;
assign frm_info_stat_error[2] = payload_len_err;

// Frame Info (User Logic)
assign frm_info_user_valid = valid_eop_p3;

assign frm_info_user_data[15:0] = count_payload_len[15:0];
assign frm_info_user_data[31:16] = frame_len[15:0];
assign frm_info_user_data[32] = csr_rx_frm_info_user_type ? svlan_frm_reg : svlan_valid;
assign frm_info_user_data[33] = csr_rx_frm_info_user_type ? vlan_frm_reg : vlan_valid;
assign frm_info_user_data[34] = csr_rx_frm_info_user_type ? ctrl_frm_reg : ctrl_frm_valid;
assign frm_info_user_data[35] = pause_frm_reg;
assign frm_info_user_data[36] = bcast_addr_matched_reg;
assign frm_info_user_data[37] = csr_rx_frm_info_user_type ? mcast_addr_matched_reg : mcast_valid;
assign frm_info_user_data[38] = csr_rx_frm_info_user_type ? ucast_addr_matched_reg : ucast_valid;
assign frm_info_user_data[39] = pfc_frm_reg;

assign frm_info_user_error[0] = undersized_frm;
assign frm_info_user_error[1] = oversized_frm;
assign frm_info_user_error[2] = payload_len_err;

endmodule
