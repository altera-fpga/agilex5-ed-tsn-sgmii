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

// altera message_off 10720
// altera message_off 13024 

module alt_em10g32_rx_status_aligner (
    // Parameter
    enable_preamble_passthrough,
    
    // Clock & Reset
    mac_rx_clk,
    mac_rx_rst_b,
    
    // Frame Input Data (From RS)
    rx_rs2fctl_frm_data,
    rx_rs2fctl_frm_sop,
    rx_rs2fctl_frm_eop,
    rx_rs2fctl_frm_valid,
    rx_rs2fctl_frm_empty,
    rx_rs2fctl_frm_error,
    
    // Frame Input Data (From Frame Control)
    rx_fctl2align_frm_data,
    rx_fctl2align_frm_sop,
    rx_fctl2align_frm_eop,
    rx_fctl2align_frm_valid,
    rx_fctl2align_frm_empty,
    rx_fctl2align_frm_error,
    rx_align2fctl_frm_ready,
    
    // Avalon-ST Receive (User)
    avalon_st_rx_data,
    avalon_st_rx_sop,
    avalon_st_rx_eop,
    avalon_st_rx_valid,
    avalon_st_rx_empty,
    avalon_st_rx_error,
    avalon_st_rx_ready,
    
    // CRC Status
    csr_rx_crc_chk,
    rx_crc2align_crc32_valid,
    rx_crc2align_crc32_good,
    
    // Frame Info In (Statistics)
    rx_fd2align_statistics_valid,
    rx_fd2align_statistics_data,
    rx_fd2align_statistics_error,
    
    // Frame Info Out (Statistics)
    avalon_st_rx_statistics_valid,
    avalon_st_rx_statistics_data,
    avalon_st_rx_statistics_error,
    
    // Frame Info In (User Logic)
    rx_fd2align_rxstatus_valid,
    rx_fd2align_rxstatus_data,
    rx_fd2align_rxstatus_error,
    
    // Frame Info Out (User Logic)
    avalon_st_rxstatus_valid,
    avalon_st_rxstatus_data,
    avalon_st_rxstatus_error,
    
    // Pause Quanta In
    rx_fd2align_pause_pq_en,
    rx_fd2align_pause_pq,
    
    // Pause Quanta Out
    avalon_st_rx_pause_length_valid,
    avalon_st_rx_pause_length_data,
    
    // PFC Pause Quanta In
    rx_fd2align_pfc_field_valid,
    rx_fd2align_pfc_pq_en,
    rx_fd2align_pfc_pq0,
    rx_fd2align_pfc_pq1,
    rx_fd2align_pfc_pq2,
    rx_fd2align_pfc_pq3,
    rx_fd2align_pfc_pq4,
    rx_fd2align_pfc_pq5,
    rx_fd2align_pfc_pq6,
    rx_fd2align_pfc_pq7,
    
    // PFC Pause Quanta Out
    rx_align2flc_pfc_field_valid,
    rx_align2flc_pfc_pq0_en,
    rx_align2flc_pfc_pq1_en,
    rx_align2flc_pfc_pq2_en,
    rx_align2flc_pfc_pq3_en,
    rx_align2flc_pfc_pq4_en,
    rx_align2flc_pfc_pq5_en,
    rx_align2flc_pfc_pq6_en,
    rx_align2flc_pfc_pq7_en,
    rx_align2flc_pfc_pq0,
    rx_align2flc_pfc_pq1,
    rx_align2flc_pfc_pq2,
    rx_align2flc_pfc_pq3,
    rx_align2flc_pfc_pq4,
    rx_align2flc_pfc_pq5,
    rx_align2flc_pfc_pq6,
    rx_align2flc_pfc_pq7,
    
    // PFC XON/XOFF Status In
    rx_fd2align_pfc_status_valid,
    rx_fd2align_pfc_status_data,
    
    // PFC XON/XOFF Status Out
    avalon_st_rx_pfc_status_valid,
    avalon_st_rx_pfc_status_data
    
);

// Parameter
input               enable_preamble_passthrough;

// Clock & Reset
input               mac_rx_clk;
input               mac_rx_rst_b;

// Frame Input Data (From RS)
input      [31:0]   rx_rs2fctl_frm_data;
input               rx_rs2fctl_frm_sop;
input               rx_rs2fctl_frm_eop;
input               rx_rs2fctl_frm_valid;
input      [ 1:0]   rx_rs2fctl_frm_empty;
input               rx_rs2fctl_frm_error;

// Frame Input Data (From Frame Control)
input      [31:0]   rx_fctl2align_frm_data;
input               rx_fctl2align_frm_sop;
input               rx_fctl2align_frm_eop;
input               rx_fctl2align_frm_valid;
input      [ 1:0]   rx_fctl2align_frm_empty;
input      [ 1:0]   rx_fctl2align_frm_error;
output              rx_align2fctl_frm_ready;

// Avalon-ST Receive (User)
output     [31:0]   avalon_st_rx_data;
output              avalon_st_rx_sop;
output              avalon_st_rx_eop;
output              avalon_st_rx_valid;
output     [ 1:0]   avalon_st_rx_empty;
output     [ 5:0]   avalon_st_rx_error;
input               avalon_st_rx_ready;

// CRC Status
input               csr_rx_crc_chk;
input               rx_crc2align_crc32_valid;
input               rx_crc2align_crc32_good;

// Frame Info In (Statistics)
input               rx_fd2align_statistics_valid;
input      [39:0]   rx_fd2align_statistics_data;
input      [ 2:0]   rx_fd2align_statistics_error;

// Frame Info Out (Statistics)
output              avalon_st_rx_statistics_valid;
output     [39:0]   avalon_st_rx_statistics_data;
output     [ 6:0]   avalon_st_rx_statistics_error;

// Frame Info In (User Logic)
input               rx_fd2align_rxstatus_valid;
input      [39:0]   rx_fd2align_rxstatus_data;
input      [ 2:0]   rx_fd2align_rxstatus_error;

// Frame Info Out (User Logic)
output              avalon_st_rxstatus_valid;
output     [39:0]   avalon_st_rxstatus_data;
output     [ 6:0]   avalon_st_rxstatus_error;

// Pause Quanta In
input               rx_fd2align_pause_pq_en;
input      [15:0]   rx_fd2align_pause_pq;

// Pause Quanta Out
output              avalon_st_rx_pause_length_valid;
output     [15:0]   avalon_st_rx_pause_length_data;

// PFC Pause Quanta Out
input               rx_fd2align_pfc_field_valid;
input      [ 7:0]   rx_fd2align_pfc_pq_en;
input      [15:0]   rx_fd2align_pfc_pq0;
input      [15:0]   rx_fd2align_pfc_pq1;
input      [15:0]   rx_fd2align_pfc_pq2;
input      [15:0]   rx_fd2align_pfc_pq3;
input      [15:0]   rx_fd2align_pfc_pq4;
input      [15:0]   rx_fd2align_pfc_pq5;
input      [15:0]   rx_fd2align_pfc_pq6;
input      [15:0]   rx_fd2align_pfc_pq7;

// PFC Pause Quanta Out
output              rx_align2flc_pfc_field_valid;
output              rx_align2flc_pfc_pq0_en;
output              rx_align2flc_pfc_pq1_en;
output              rx_align2flc_pfc_pq2_en;
output              rx_align2flc_pfc_pq3_en;
output              rx_align2flc_pfc_pq4_en;
output              rx_align2flc_pfc_pq5_en;
output              rx_align2flc_pfc_pq6_en;
output              rx_align2flc_pfc_pq7_en;
output     [15:0]   rx_align2flc_pfc_pq0;
output     [15:0]   rx_align2flc_pfc_pq1;
output     [15:0]   rx_align2flc_pfc_pq2;
output     [15:0]   rx_align2flc_pfc_pq3;
output     [15:0]   rx_align2flc_pfc_pq4;
output     [15:0]   rx_align2flc_pfc_pq5;
output     [15:0]   rx_align2flc_pfc_pq6;
output     [15:0]   rx_align2flc_pfc_pq7;

// PFC XON/XOFF Status In
input               rx_fd2align_pfc_status_valid;
input      [15:0]   rx_fd2align_pfc_status_data;

// PFC XON/XOFF Status Out
output              avalon_st_rx_pfc_status_valid;
output     [15:0]   avalon_st_rx_pfc_status_data;

// CRC Status
reg                 rx_crc2align_crc32_bad_p6;
reg                 rx_crc2align_crc32_bad_p7;
reg                 rx_crc2align_crc32_bad_p8;

// Frame Info (Statistics)
reg                 rx_fd2align_statistics_valid_p4;
reg                 rx_fd2align_statistics_valid_p5;

// PHY Error
reg                 rx_rs2fctl_frm_valid_p1;
reg                 rx_rs2fctl_frm_valid_p2;
reg                 rx_rs2fctl_frm_sop_p1;
reg                 rx_rs2fctl_frm_eop_p1;
reg                 rx_rs2fctl_frm_eop_p2;

reg                 rx_rs2fctl_frm_error_p1;
reg                 rx_rs2fctl_frm_error_p2;
reg                 rx_rs2fctl_frm_error_p3;
reg                 rx_rs2fctl_frm_error_p4;
reg                 rx_rs2fctl_frm_error_p5;
reg                 rx_rs2fctl_frm_error_p6;
reg                 rx_rs2fctl_frm_error_p7;
reg                 rx_rs2fctl_frm_error_p8;

// Frame Info (User Logic)
reg                 rx_fd2align_rxstatus_valid_p4;
reg                 rx_fd2align_rxstatus_valid_p5;
reg                 rx_fd2align_rxstatus_valid_p6;
reg                 rx_fd2align_rxstatus_valid_p7;
reg                 rx_fd2align_rxstatus_valid_p8;

reg        [39:0]   rx_fd2align_rxstatus_data_p7;
reg        [39:0]   rx_fd2align_rxstatus_data_p8;

reg        [ 2:0]   rx_fd2align_rxstatus_error_p4;
reg        [ 2:0]   rx_fd2align_rxstatus_error_p5;
reg        [ 2:0]   rx_fd2align_rxstatus_error_p6;
reg        [ 2:0]   rx_fd2align_rxstatus_error_p7;
reg        [ 2:0]   rx_fd2align_rxstatus_error_p8;

// Pause Quanta
reg                 rx_fd2align_pause_pq_en_p4;
reg                 rx_fd2align_pause_pq_en_p5;

// PFC Pause Quanta
reg                 rx_fd2align_pfc_field_valid_p4;
reg                 rx_fd2align_pfc_field_valid_p5;

// PFC XON/XOFF Status
reg                 rx_fd2align_pfc_status_valid_p4;
reg                 rx_fd2align_pfc_status_valid_p5;
reg                 rx_fd2align_pfc_status_valid_p6;
reg                 rx_fd2align_pfc_status_valid_p7;
reg                 rx_fd2align_pfc_status_valid_p8;

reg        [15:0]   rx_fd2align_pfc_status_data_p7;
reg        [15:0]   rx_fd2align_pfc_status_data_p8;

//------------------------------------------------------------------------
// Note:
//------------------------------------------------------------------------
// Latencies of MAC RX sub-modules:
// CRC Checker: 5 clock cycles from EOP to obtain good CRC status
// Frame Filter and CRC/Pad Removal: 6 clock cycles from EOP
// Preamble passthrough: 2 clock cycles
//
// Largest latency would be 6 clock cycles when preamble passthrough mode not enabled
// And 8 clock cycles when preamble passthrough mode enabled
// Thus all data path related interfaces will be registered to meet either 6 or 8 clock cycles depend on configuration
//
// Since the status from Frame Decoder will not be cleaned in a few clock cycles after EOP
// Thus the status need not to be registered if preamble passthrough mode is not enabled

//------------------------------------------------------------------------
// Frame Data
//------------------------------------------------------------------------
// CRC Status
always @(posedge mac_rx_clk) begin
    // if(!mac_rx_rst_b) begin
        // rx_crc2align_crc32_bad_p6 <= 1'b0;
        // rx_crc2align_crc32_bad_p7 <= 1'b0;
        // rx_crc2align_crc32_bad_p8 <= 1'b0;
    // end
    // else begin
        // CASE:284037 - Since bad CRC indicator is valid only at end of packet, thus it must be qualified with EOP indicator (alternative: RX Status Valid)
        rx_crc2align_crc32_bad_p6 <= ~rx_crc2align_crc32_good & rx_crc2align_crc32_valid & csr_rx_crc_chk & rx_fd2align_rxstatus_valid_p5;
        rx_crc2align_crc32_bad_p7 <= rx_crc2align_crc32_bad_p6;
        rx_crc2align_crc32_bad_p8 <= rx_crc2align_crc32_bad_p7;
    // end
end

assign avalon_st_rx_data        = rx_fctl2align_frm_data;
assign avalon_st_rx_sop         = rx_fctl2align_frm_sop;
assign avalon_st_rx_eop         = rx_fctl2align_frm_eop;
assign avalon_st_rx_valid       = rx_fctl2align_frm_valid;
assign avalon_st_rx_empty       = rx_fctl2align_frm_empty;
assign avalon_st_rx_error[0]    = rx_fctl2align_frm_error[0]; // PHY Error
assign avalon_st_rx_error[1]    = enable_preamble_passthrough ? rx_crc2align_crc32_bad_p8 : rx_crc2align_crc32_bad_p6; // CRC Error
assign avalon_st_rx_error[2]    = enable_preamble_passthrough ? rx_fd2align_rxstatus_error_p8[0] : rx_fd2align_rxstatus_error_p6[0]; // Undersized Error
assign avalon_st_rx_error[3]    = enable_preamble_passthrough ? rx_fd2align_rxstatus_error_p8[1] : rx_fd2align_rxstatus_error_p6[1]; // Oversized Error
assign avalon_st_rx_error[4]    = enable_preamble_passthrough ? rx_fd2align_rxstatus_error_p8[2] : rx_fd2align_rxstatus_error_p6[2]; // Payload Length Error
assign avalon_st_rx_error[5]    = rx_fctl2align_frm_error[1]; // Overflow Error
assign rx_align2fctl_frm_ready  = avalon_st_rx_ready;

//------------------------------------------------------------------------
// Frame Info (Statistics)
//------------------------------------------------------------------------
always @(posedge mac_rx_clk) begin
    rx_rs2fctl_frm_error_p1 <= rx_rs2fctl_frm_error;
        
    // Latch the error starting from SOP
    if(rx_rs2fctl_frm_valid_p1 & rx_rs2fctl_frm_sop_p1) begin
        rx_rs2fctl_frm_error_p2 <= rx_rs2fctl_frm_error_p1;
    end
    // Clear the latched error the next clock cycle after EOP
    else if(rx_rs2fctl_frm_valid_p2 & rx_rs2fctl_frm_eop_p2) begin
        rx_rs2fctl_frm_error_p2 <= 1'b0;
    end
    // Latch the error for any valid data other than SOP and EOP
    else if(rx_rs2fctl_frm_valid_p1) begin
        rx_rs2fctl_frm_error_p2 <= rx_rs2fctl_frm_error_p2 | rx_rs2fctl_frm_error_p1;
    end
    // Keep the error for invalid cycle
    else begin
        rx_rs2fctl_frm_error_p2 <= rx_rs2fctl_frm_error_p2;
    end
    
    rx_rs2fctl_frm_error_p3 <= rx_rs2fctl_frm_error_p2;
    rx_rs2fctl_frm_error_p4 <= rx_rs2fctl_frm_error_p3;
    rx_rs2fctl_frm_error_p5 <= rx_rs2fctl_frm_error_p4;
    rx_rs2fctl_frm_error_p6 <= rx_rs2fctl_frm_error_p5;
    rx_rs2fctl_frm_error_p7 <= rx_rs2fctl_frm_error_p6;
    rx_rs2fctl_frm_error_p8 <= rx_rs2fctl_frm_error_p7;
end

always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        rx_fd2align_statistics_valid_p4 <= 1'b0;
        rx_fd2align_statistics_valid_p5 <= 1'b0;
        
        rx_rs2fctl_frm_valid_p1 <= 1'b0;
        rx_rs2fctl_frm_valid_p2 <= 1'b0;
        rx_rs2fctl_frm_sop_p1 <= 1'b0;
        rx_rs2fctl_frm_eop_p1 <= 1'b0;
        rx_rs2fctl_frm_eop_p2 <= 1'b0;
        
        // rx_rs2fctl_frm_error_p1 <= 1'b0;
        // rx_rs2fctl_frm_error_p2 <= 1'b0;
        // rx_rs2fctl_frm_error_p3 <= 1'b0;
        // rx_rs2fctl_frm_error_p4 <= 1'b0;
        // rx_rs2fctl_frm_error_p5 <= 1'b0;
        // rx_rs2fctl_frm_error_p6 <= 1'b0;
        // rx_rs2fctl_frm_error_p7 <= 1'b0;
        // rx_rs2fctl_frm_error_p8 <= 1'b0;
    end
    else begin
        rx_fd2align_statistics_valid_p4 <= rx_fd2align_statistics_valid;
        rx_fd2align_statistics_valid_p5 <= rx_fd2align_statistics_valid_p4;
        
        rx_rs2fctl_frm_valid_p1 <= rx_rs2fctl_frm_valid;
        rx_rs2fctl_frm_valid_p2 <= rx_rs2fctl_frm_valid_p1;
        rx_rs2fctl_frm_sop_p1 <= rx_rs2fctl_frm_sop;
        rx_rs2fctl_frm_eop_p1 <= rx_rs2fctl_frm_eop;
        rx_rs2fctl_frm_eop_p2 <= rx_rs2fctl_frm_eop_p1;
        
        /* rx_rs2fctl_frm_error_p1 <= rx_rs2fctl_frm_error;
        
        // Latch the error starting from SOP
        if(rx_rs2fctl_frm_valid_p1 & rx_rs2fctl_frm_sop_p1) begin
            rx_rs2fctl_frm_error_p2 <= rx_rs2fctl_frm_error_p1;
        end
        // Clear the latched error the next clock cycle after EOP
        else if(rx_rs2fctl_frm_valid_p2 & rx_rs2fctl_frm_eop_p2) begin
            rx_rs2fctl_frm_error_p2 <= 1'b0;
        end
        // Latch the error for any valid data other than SOP and EOP
        else if(rx_rs2fctl_frm_valid_p1) begin
            rx_rs2fctl_frm_error_p2 <= rx_rs2fctl_frm_error_p2 | rx_rs2fctl_frm_error_p1;
        end
        // Keep the error for invalid cycle
        else begin
            rx_rs2fctl_frm_error_p2 <= rx_rs2fctl_frm_error_p2;
        end
        
        rx_rs2fctl_frm_error_p3 <= rx_rs2fctl_frm_error_p2;
        rx_rs2fctl_frm_error_p4 <= rx_rs2fctl_frm_error_p3;
        rx_rs2fctl_frm_error_p5 <= rx_rs2fctl_frm_error_p4;
        rx_rs2fctl_frm_error_p6 <= rx_rs2fctl_frm_error_p5;
        rx_rs2fctl_frm_error_p7 <= rx_rs2fctl_frm_error_p6;
        rx_rs2fctl_frm_error_p8 <= rx_rs2fctl_frm_error_p7; */
    end
end

assign avalon_st_rx_statistics_valid = rx_fd2align_statistics_valid_p5;
assign avalon_st_rx_statistics_data = rx_fd2align_statistics_data;
assign avalon_st_rx_statistics_error[2:0] = rx_fd2align_statistics_error[2:0]; // Undersized Error, Oversized Error, Payload Length Error
assign avalon_st_rx_statistics_error[3] = ~rx_crc2align_crc32_good & rx_crc2align_crc32_valid & csr_rx_crc_chk; // CRC Error
assign avalon_st_rx_statistics_error[4] = 1'b0; // Underflow Error <Unused>
assign avalon_st_rx_statistics_error[5] = 1'b0; // User Error <Unused>
assign avalon_st_rx_statistics_error[6] = rx_rs2fctl_frm_error_p5; // PHY Error

//------------------------------------------------------------------------
// Frame Info (User Logic)
//------------------------------------------------------------------------
always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        rx_fd2align_rxstatus_valid_p4 <= 1'b0;
        rx_fd2align_rxstatus_valid_p5 <= 1'b0;
        rx_fd2align_rxstatus_valid_p6 <= 1'b0;
        rx_fd2align_rxstatus_valid_p7 <= 1'b0;
        rx_fd2align_rxstatus_valid_p8 <= 1'b0;
        
        // rx_fd2align_rxstatus_data_p7  <= 40'h0;
        // rx_fd2align_rxstatus_data_p8  <= 40'h0;
        
        // rx_fd2align_rxstatus_error_p4 <= 3'h0;
        // rx_fd2align_rxstatus_error_p5 <= 3'h0;
        // rx_fd2align_rxstatus_error_p6 <= 3'h0;
        // rx_fd2align_rxstatus_error_p7 <= 3'h0;
        // rx_fd2align_rxstatus_error_p8 <= 3'h0;
    end
    else begin
        rx_fd2align_rxstatus_valid_p4 <= rx_fd2align_rxstatus_valid;
        rx_fd2align_rxstatus_valid_p5 <= rx_fd2align_rxstatus_valid_p4;
        rx_fd2align_rxstatus_valid_p6 <= rx_fd2align_rxstatus_valid_p5;
        rx_fd2align_rxstatus_valid_p7 <= rx_fd2align_rxstatus_valid_p6;
        rx_fd2align_rxstatus_valid_p8 <= rx_fd2align_rxstatus_valid_p7;
        
        // Registered value in frame decoder could be used until pipeline 6 before it get updated during worst case
        // rx_fd2align_rxstatus_data_p7  <= rx_fd2align_rxstatus_data;
        // rx_fd2align_rxstatus_data_p8  <= rx_fd2align_rxstatus_data_p7;
        
        // Have more pipelines for error, and qualified with valid, to ensure that error will not show until EOP
        // rx_fd2align_rxstatus_error_p4 <= rx_fd2align_rxstatus_error & {3{rx_fd2align_rxstatus_valid}};
        // rx_fd2align_rxstatus_error_p5 <= rx_fd2align_rxstatus_error_p4;
        // rx_fd2align_rxstatus_error_p6 <= rx_fd2align_rxstatus_error_p5;
        // rx_fd2align_rxstatus_error_p7 <= rx_fd2align_rxstatus_error_p6;
        // rx_fd2align_rxstatus_error_p8 <= rx_fd2align_rxstatus_error_p7;
    end
end

// data no need to reset
always @(posedge mac_rx_clk) begin
// Registered value in frame decoder could be used until pipeline 6 before it get updated during worst case
    rx_fd2align_rxstatus_data_p7  <= rx_fd2align_rxstatus_data;
    rx_fd2align_rxstatus_data_p8  <= rx_fd2align_rxstatus_data_p7;
    
    rx_fd2align_rxstatus_error_p4 <= rx_fd2align_rxstatus_error & {3{rx_fd2align_rxstatus_valid}};
    rx_fd2align_rxstatus_error_p5 <= rx_fd2align_rxstatus_error_p4;
    rx_fd2align_rxstatus_error_p6 <= rx_fd2align_rxstatus_error_p5;
    rx_fd2align_rxstatus_error_p7 <= rx_fd2align_rxstatus_error_p6;
    rx_fd2align_rxstatus_error_p8 <= rx_fd2align_rxstatus_error_p7;
end

assign avalon_st_rxstatus_valid = enable_preamble_passthrough ? rx_fd2align_rxstatus_valid_p8 : rx_fd2align_rxstatus_valid_p6;
assign avalon_st_rxstatus_data = enable_preamble_passthrough ? rx_fd2align_rxstatus_data_p8 : rx_fd2align_rxstatus_data;
assign avalon_st_rxstatus_error[2:0] = enable_preamble_passthrough ? rx_fd2align_rxstatus_error_p8[2:0] : rx_fd2align_rxstatus_error_p6[2:0]; // Undersized Error, Oversized Error, Payload Length Error
assign avalon_st_rxstatus_error[3] = enable_preamble_passthrough ? rx_crc2align_crc32_bad_p8 : rx_crc2align_crc32_bad_p6; // CRC Error
assign avalon_st_rxstatus_error[4] = 1'b0; // Underflow Error <Unused>
assign avalon_st_rxstatus_error[5] = 1'b0; // User Error <Unused>
assign avalon_st_rxstatus_error[6] = enable_preamble_passthrough ? rx_rs2fctl_frm_error_p8 : rx_rs2fctl_frm_error_p6; // PHY Error

//------------------------------------------------------------------------
// Pause Quanta
//------------------------------------------------------------------------
always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        rx_fd2align_pause_pq_en_p4 <= 1'b0;
        rx_fd2align_pause_pq_en_p5 <= 1'b0;
    end
    else begin
        rx_fd2align_pause_pq_en_p4 <= rx_fd2align_pause_pq_en;
        rx_fd2align_pause_pq_en_p5 <= rx_fd2align_pause_pq_en_p4;
    end
end

assign avalon_st_rx_pause_length_valid = rx_fd2align_pause_pq_en_p5 & (csr_rx_crc_chk ? (rx_crc2align_crc32_good & rx_crc2align_crc32_valid) : 1'b1);
assign avalon_st_rx_pause_length_data = rx_fd2align_pause_pq;

//------------------------------------------------------------------------
// PFC Pause Quanta
//------------------------------------------------------------------------
always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        rx_fd2align_pfc_field_valid_p4 <= 1'b0;
        rx_fd2align_pfc_field_valid_p5 <= 1'b0;
    end
    else begin
        rx_fd2align_pfc_field_valid_p4 <= rx_fd2align_pfc_field_valid;
        rx_fd2align_pfc_field_valid_p5 <= rx_fd2align_pfc_field_valid_p4;
    end
end

assign rx_align2flc_pfc_field_valid = rx_fd2align_pfc_field_valid_p5 & (csr_rx_crc_chk ? (rx_crc2align_crc32_good & rx_crc2align_crc32_valid) : 1'b1);
assign rx_align2flc_pfc_pq0_en = rx_fd2align_pfc_pq_en[0];
assign rx_align2flc_pfc_pq1_en = rx_fd2align_pfc_pq_en[1];
assign rx_align2flc_pfc_pq2_en = rx_fd2align_pfc_pq_en[2];
assign rx_align2flc_pfc_pq3_en = rx_fd2align_pfc_pq_en[3];
assign rx_align2flc_pfc_pq4_en = rx_fd2align_pfc_pq_en[4];
assign rx_align2flc_pfc_pq5_en = rx_fd2align_pfc_pq_en[5];
assign rx_align2flc_pfc_pq6_en = rx_fd2align_pfc_pq_en[6];
assign rx_align2flc_pfc_pq7_en = rx_fd2align_pfc_pq_en[7];
assign rx_align2flc_pfc_pq0 = rx_fd2align_pfc_pq0;
assign rx_align2flc_pfc_pq1 = rx_fd2align_pfc_pq1;
assign rx_align2flc_pfc_pq2 = rx_fd2align_pfc_pq2;
assign rx_align2flc_pfc_pq3 = rx_fd2align_pfc_pq3;
assign rx_align2flc_pfc_pq4 = rx_fd2align_pfc_pq4;
assign rx_align2flc_pfc_pq5 = rx_fd2align_pfc_pq5;
assign rx_align2flc_pfc_pq6 = rx_fd2align_pfc_pq6;
assign rx_align2flc_pfc_pq7 = rx_fd2align_pfc_pq7;

//------------------------------------------------------------------------
// PFC XON/XOFF Status
//------------------------------------------------------------------------
always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        rx_fd2align_pfc_status_valid_p4 <= 1'b0;
        rx_fd2align_pfc_status_valid_p5 <= 1'b0;
        rx_fd2align_pfc_status_valid_p6 <= 1'b0;
        rx_fd2align_pfc_status_valid_p7 <= 1'b0;
        rx_fd2align_pfc_status_valid_p8 <= 1'b0;
        
        // rx_fd2align_pfc_status_data_p7  <= 16'h0;
        // rx_fd2align_pfc_status_data_p8  <= 16'h0;
    end
    else begin
        rx_fd2align_pfc_status_valid_p4 <= rx_fd2align_pfc_status_valid;
        rx_fd2align_pfc_status_valid_p5 <= rx_fd2align_pfc_status_valid_p4;
        rx_fd2align_pfc_status_valid_p6 <= rx_fd2align_pfc_status_valid_p5;
        rx_fd2align_pfc_status_valid_p7 <= rx_fd2align_pfc_status_valid_p6;
        rx_fd2align_pfc_status_valid_p8 <= rx_fd2align_pfc_status_valid_p7;
        
        // rx_fd2align_pfc_status_data_p7  <= rx_fd2align_pfc_status_data;
        // rx_fd2align_pfc_status_data_p8  <= rx_fd2align_pfc_status_data_p7;
    end
end

always @(posedge mac_rx_clk) begin
    rx_fd2align_pfc_status_data_p7  <= rx_fd2align_pfc_status_data;
    rx_fd2align_pfc_status_data_p8  <= rx_fd2align_pfc_status_data_p7;
end

assign avalon_st_rx_pfc_status_valid = enable_preamble_passthrough ? rx_fd2align_pfc_status_valid_p8 : rx_fd2align_pfc_status_valid_p6;
assign avalon_st_rx_pfc_status_data = enable_preamble_passthrough ? rx_fd2align_pfc_status_data_p8 : rx_fd2align_pfc_status_data;

endmodule
