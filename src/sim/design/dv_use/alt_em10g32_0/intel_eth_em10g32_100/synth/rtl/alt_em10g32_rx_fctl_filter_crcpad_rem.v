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
module alt_em10g32_rx_fctl_filter_crcpad_rem (
    // Clock & Reset
    mac_rx_clk,
    mac_rx_rst_b,
    
    // Configuration from CSR
    csr_rx_allucast_en,
    csr_rx_allmcast_en,
    csr_rx_fwd_ctlfrm,
    csr_rx_fwd_pausefrm,
    csr_rx_pfc_fwd,
    csr_rx_crcpad_rem,
    
    // Frame Input Data
    rx_rs2fctl_frm_data,
    rx_rs2fctl_frm_sop,
    rx_rs2fctl_frm_eop,
    rx_rs2fctl_frm_valid,
    rx_rs2fctl_frm_empty,
    rx_rs2fctl_frm_error,
    
    // Frame Output Data
    rx_fltrpcrem2pa_frm_data,
    rx_fltrpcrem2pa_frm_sop,
    rx_fltrpcrem2pa_frm_eop,
    rx_fltrpcrem2pa_frm_valid,
    rx_fltrpcrem2pa_frm_empty,
    rx_fltrpcrem2pa_frm_error,
    
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
    
    // Frame Drop Behavior
    // 0: csr_rx_fwd_ctlfrm   affects misc control frames and PFC frames
    //    csr_rx_fwd_pausefrm affects pause frames
    //    csr_rx_pfc_fwd      unused
    // 1: csr_rx_fwd_ctlfrm   affects misc control frames
    //    csr_rx_fwd_pausefrm affects pause frames
    //    csr_rx_pfc_fwd      affects PFC frames
    frm_drop_ctrl_pfc_behavior
);

// Clock & Reset
input               mac_rx_clk;
input               mac_rx_rst_b;

// Configuration from CSR
input               csr_rx_allucast_en;
input               csr_rx_allmcast_en;
input               csr_rx_fwd_ctlfrm;
input               csr_rx_fwd_pausefrm;
input               csr_rx_pfc_fwd;
input      [ 1:0]   csr_rx_crcpad_rem;

// Frame Input Data
input      [31:0]   rx_rs2fctl_frm_data;
input               rx_rs2fctl_frm_sop;
input               rx_rs2fctl_frm_eop;
input               rx_rs2fctl_frm_valid;
input      [ 1:0]   rx_rs2fctl_frm_empty;
input               rx_rs2fctl_frm_error;

// Frame Output Data
output     [31:0]   rx_fltrpcrem2pa_frm_data;
output              rx_fltrpcrem2pa_frm_sop;
output              rx_fltrpcrem2pa_frm_eop;
output              rx_fltrpcrem2pa_frm_valid;
output     [ 1:0]   rx_fltrpcrem2pa_frm_empty;
output              rx_fltrpcrem2pa_frm_error;

// Frame Info for CRC/Pad Remover
input               pad_rem_info_valid;
input      [15:0]   pad_rem_info_length_type;
input               pad_rem_info_length_frm;
input               pad_rem_info_ctrl_frm;

// Frame Drop Info
input               frm_drop_info_valid;
input               frm_drop_info_da_matched;
input               frm_drop_info_unicast;
input               frm_drop_info_multicast;
input               frm_drop_info_broadcast;
input               frm_drop_info_ctrl_frm;
input               frm_drop_info_pause_frm;
input               frm_drop_info_pfc_frm;

// Frame Drop Behavior
input               frm_drop_ctrl_pfc_behavior;

// Local Parameters
localparam PIPELINE_WIDTH   = 32 + 2 + 1 + 1 + 1;

// Pipelines
wire [31:0] frm_data_p1;
wire        frm_sop_p1;
wire        frm_eop_p1;
wire        frm_valid_p1;
wire [ 1:0] frm_empty_p1;
wire        frm_ready_p1;
wire        frm_error_p1;

wire [31:0] frm_data_p2;
wire        frm_sop_p2;
wire        frm_eop_p2;
wire        frm_valid_p2;
wire [ 1:0] frm_empty_p2;
wire        frm_ready_p2;
wire        frm_error_p2;

wire [31:0] frm_data_p3;
wire        frm_sop_p3;
wire        frm_eop_p3;
wire        frm_valid_p3;
wire [ 1:0] frm_empty_p3;
wire        frm_ready_p3;
wire        frm_error_p3;

wire [31:0] frm_data_p4;
wire        frm_sop_p4;
wire        frm_eop_p4;
wire        frm_valid_p4;
wire [ 1:0] frm_empty_p4;
wire        frm_ready_p4;
wire        frm_error_p4;

wire [31:0] frm_data_p5;
wire        frm_sop_p5;
wire        frm_eop_p5;
wire        frm_valid_p5;
wire [ 1:0] frm_empty_p5;
wire        frm_ready_p5;
wire        frm_error_p5;

wire [31:0] frm_data_p6;
wire        frm_sop_p6;
wire        frm_eop_p6;
wire        frm_valid_p6;
wire [ 1:0] frm_empty_p6;
wire        frm_ready_p6;
wire        frm_error_p6;

// CRC Removal
wire [31:0] crc_rem_frm_data_p1;
wire        crc_rem_frm_sop_p1;
wire        crc_rem_frm_eop_p1;
wire        crc_rem_frm_valid_p1;
wire [ 1:0] crc_rem_frm_empty_p1;
wire        crc_rem_frm_ready_p1;
wire        crc_rem_frm_error_p1;

wire [31:0] crc_rem_frm_data_p2;
wire        crc_rem_frm_sop_p2;
wire        crc_rem_frm_eop_p2;
wire        crc_rem_frm_valid_p2;
wire [ 1:0] crc_rem_frm_empty_p2;
wire        crc_rem_frm_ready_p2;
wire        crc_rem_frm_error_p2;

wire        crc_rem_ena_p1;
wire        crc_rem_pipe_ena_p2;

// Pad Removal
wire [31:0] pad_rem_frm_data_p3;
wire        pad_rem_frm_sop_p3;
wire        pad_rem_frm_eop_p3;
wire        pad_rem_frm_valid_p3;
wire [ 1:0] pad_rem_frm_empty_p3;
wire        pad_rem_frm_ready_p3;
wire        pad_rem_frm_error_p3;

wire [31:0] pad_rem_frm_data_p4;
wire        pad_rem_frm_sop_p4;
wire        pad_rem_frm_eop_p4;
wire        pad_rem_frm_valid_p4;
wire [ 1:0] pad_rem_frm_empty_p4;
wire        pad_rem_frm_ready_p4;
wire        pad_rem_frm_error_p4;

wire        pad_rem_info_valid_p1;
wire        pad_rem_info_valid_p2;
wire        pad_rem_info_valid_p2_reg;
reg  [15:0] payload_length_p2;
reg  [15:0] remaining_payload_p3;
wire [ 1:0] frm_empty_pad_rem_p3;
reg         pad_rem_ena_p3;
reg         pad_rem_ena_p4;

// Latch PHY Error
wire [31:0] phy_err_latch_frm_data_p5;
wire        phy_err_latch_frm_sop_p5;
wire        phy_err_latch_frm_eop_p5;
wire        phy_err_latch_frm_valid_p5;
wire [ 1:0] phy_err_latch_frm_empty_p5;
wire        phy_err_latch_frm_ready_p5;
wire        phy_err_latch_frm_error_p5;

// Frame Drop
wire [31:0] frame_drop_frm_data_p6;
wire        frame_drop_frm_sop_p6;
wire        frame_drop_frm_eop_p6;
wire        frame_drop_frm_valid_p6;
wire [ 1:0] frame_drop_frm_empty_p6;
wire        frame_drop_frm_error_p6;

reg         pipeline_read;
wire        ucast_frm_fwd_valid;
wire        mcast_frm_fwd_valid;
wire        bcast_frm_fwd_valid;
wire        ctrl_frm_fwd_valid;
wire        pause_frm_fwd_valid;
wire        pfc_frm_fwd_valid;
reg         frm_fwd_valid;

////////////////////////////////////////////////////////////////////////////////
// Pipeline
////////////////////////////////////////////////////////////////////////////////

// Pipelines
// Pipeline 1: Store data for frame drop
// Pipeline 2, 3 input: For CRC removal
// Pipeline 4, 5 input: For pad removal
// Pipeline 5: Delay data for frame drop
// Pipeline 6: For frame drop

alt_em10g32_pipeline_base #(
    .BITS_PER_SYMBOL    (PIPELINE_WIDTH),
    .SYMBOLS_PER_BEAT   (1),
    .PIPELINE_READY     (0)
) frm_pipeline_1 (
    .clk        (mac_rx_clk),
    .reset_n    (mac_rx_rst_b),
    .in_ready   (),
    .in_valid   (rx_rs2fctl_frm_valid),
    .in_data    ({rx_rs2fctl_frm_error, rx_rs2fctl_frm_sop, rx_rs2fctl_frm_eop, rx_rs2fctl_frm_empty, rx_rs2fctl_frm_data}),
    .out_ready  (frm_ready_p1),
    .out_valid  (frm_valid_p1),
    .out_data   ({frm_error_p1, frm_sop_p1, frm_eop_p1, frm_empty_p1, frm_data_p1})
);

////////////////////////////////////////////////////////////////////////////////
// CRC Removal
////////////////////////////////////////////////////////////////////////////////

// Since CRC removal involve 4-bytes, which is one clock cycle in 32-bits architecture
// Which is equivalent to holding the data a clock cycle before EOP and use the empty value of EOP cycle
// Error for both EOP and a cycle before EOP must be ORed together
// Data for whole frames are written to the pipelines, by the data a cycle before EOP will be deasserted at the output of the pipelines
assign crc_rem_ena_p1       = (csr_rx_crcpad_rem[0] | csr_rx_crcpad_rem[1]) & (frm_eop_p1 & frm_valid_p1);

assign crc_rem_frm_valid_p1 = frm_valid_p1;
assign crc_rem_frm_data_p1  = crc_rem_ena_p1 ? frm_data_p2 : frm_data_p1;
assign crc_rem_frm_sop_p1   = crc_rem_ena_p1 ? frm_sop_p2 : frm_sop_p1;
assign crc_rem_frm_eop_p1   = frm_eop_p1;
assign crc_rem_frm_empty_p1 = frm_empty_p1;
assign crc_rem_frm_error_p1 = crc_rem_ena_p1 ? (frm_error_p2 | frm_error_p1) : frm_error_p1;
assign frm_ready_p1         = crc_rem_frm_ready_p1;

// pad_rem_info_valid_p2_reg are stored in the pipeline so that it is aligned to the packet data, else if will misaligned due to backpressure by frm_ready_p2

alt_em10g32_pipeline_base #(
    .BITS_PER_SYMBOL    (PIPELINE_WIDTH + 1),
    .SYMBOLS_PER_BEAT   (1),
    .PIPELINE_READY     (0)
) frm_pipeline_2 (
    .clk        (mac_rx_clk),
    .reset_n    (mac_rx_rst_b),
    .in_ready   (crc_rem_frm_ready_p1),
    .in_valid   (crc_rem_frm_valid_p1),
    .in_data    ({pad_rem_info_valid_p1, crc_rem_frm_error_p1, crc_rem_frm_sop_p1, crc_rem_frm_eop_p1, crc_rem_frm_empty_p1, crc_rem_frm_data_p1}),
    .out_ready  (frm_ready_p2),
    .out_valid  (frm_valid_p2),
    .out_data   ({pad_rem_info_valid_p2_reg, frm_error_p2, frm_sop_p2, frm_eop_p2, frm_empty_p2, frm_data_p2})
);

// Hold the data a cycle before EOP in below 10G mode, so that we could make the data aligned to EOP when CRC removal happen
// assign crc_rem_pipe_ena_p2  = (frm_valid_p1 & frm_valid_p2) | (frm_valid_p2 & frm_eop_p2);
assign crc_rem_pipe_ena_p2  = frm_valid_p2 & (frm_valid_p1 | frm_eop_p2);

// When CRC removal happen, deassert the data valid for data a cycle before EOP
assign crc_rem_frm_valid_p2 = frm_valid_p2 & ((crc_rem_pipe_ena_p2 & ~crc_rem_ena_p1) | frm_eop_p2);
assign crc_rem_frm_data_p2  = frm_data_p2;
assign crc_rem_frm_sop_p2   = frm_sop_p2;
assign crc_rem_frm_eop_p2   = frm_eop_p2;
assign crc_rem_frm_empty_p2 = frm_empty_p2;
assign crc_rem_frm_error_p2 = frm_error_p2;
assign frm_ready_p2         = crc_rem_frm_ready_p2 & crc_rem_pipe_ena_p2;

alt_em10g32_pipeline_base #(
    .BITS_PER_SYMBOL    (PIPELINE_WIDTH),
    .SYMBOLS_PER_BEAT   (1),
    .PIPELINE_READY     (0)
) frm_pipeline_3 (
    .clk        (mac_rx_clk),
    .reset_n    (mac_rx_rst_b),
    .in_ready   (crc_rem_frm_ready_p2),
    .in_valid   (crc_rem_frm_valid_p2),
    .in_data    ({crc_rem_frm_error_p2, crc_rem_frm_sop_p2, crc_rem_frm_eop_p2, crc_rem_frm_empty_p2, crc_rem_frm_data_p2}),
    .out_ready  (frm_ready_p3),
    .out_valid  (frm_valid_p3),
    .out_data   ({frm_error_p3, frm_sop_p3, frm_eop_p3, frm_empty_p3, frm_data_p3})
);

////////////////////////////////////////////////////////////////////////////////
// Pad Removal
////////////////////////////////////////////////////////////////////////////////

// pad_rem_info_valid_p1 is aligned to data in pipeline_1, which is same clock cycle with L/T field
assign pad_rem_info_valid_p1 = pad_rem_info_valid;

// pad_rem_info_valid_p2_reg must be qualified with valid and ready signal to generate a cycle pulse
assign pad_rem_info_valid_p2 = pad_rem_info_valid_p2_reg & frm_valid_p2 & frm_ready_p2;

// NON_RESETABLE FLOPS
// Calculate the length of the valid payload, to determine when will the pad being removed
always @(posedge mac_rx_clk) begin
    if(pad_rem_info_ctrl_frm) begin
        payload_length_p2 <= 16'd60 - 16'd12; // Exclude DA, SA
    end
    else begin
        payload_length_p2 <= pad_rem_info_length_type + (16'd2); // Exclude DA, SA, include Length/Type field
    end
end

// SYNC_RESET FLOPS
// Calculate remaining payload, to determine when pad will be removed
// The number includes data in pipeline p3
always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        remaining_payload_p3 <= 16'hFFFF;
    end
    else begin
        if(pad_rem_info_valid_p2) begin
            remaining_payload_p3 <= payload_length_p2;
        end
        else if((frm_valid_p2 & frm_ready_p2) && ~(remaining_payload_p3 < 16'h4)) begin
            remaining_payload_p3 <= remaining_payload_p3 - 16'h4;
        end
    end
end

always @(posedge mac_rx_clk) begin
// Determine when pad will be removed
        // Include 4 remaining bytes in the checking so that last valid data could be on hold until arrival of EOP
        pad_rem_ena_p4 <= pad_rem_ena_p3 & (remaining_payload_p3[15:0] <= 16'h4);
end

// SYNC_RESET FLOPS
always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        pad_rem_ena_p3 <= 1'b0;
        // pad_rem_ena_p4 <= 1'b0;
    end
    else begin        
        if(pad_rem_info_valid_p2) begin
            pad_rem_ena_p3 <= csr_rx_crcpad_rem[1] & (pad_rem_info_length_frm | pad_rem_info_ctrl_frm);
        end
        // Reset status right after EOP so that effect of previous packet would not impact next packet
        else if(frm_eop_p3 & frm_valid_p3) begin
            pad_rem_ena_p3 <= 1'b0;
        end
        
        // Determine when pad will be removed
        // Include 4 remaining bytes in the checking so that last valid data could be on hold until arrival of EOP
        // pad_rem_ena_p4 <= pad_rem_ena_p3 & (remaining_payload_p3[15:0] <= 16'h4);
    end
end

// -----------------------------------
// | Remaining Payload |    Empty    |
// -----------------------------------
// |    Dec    |  Bin  |  Dec  | Bin |
// ----------------------------------|
// |     0     |   00  |   0   |  00 |
// |     1     |   01  |   3   |  11 |
// |     2     |   10  |   2   |  10 |
// |     3     |   11  |   1   |  01 |
// -----------------------------------
// Use K-map to generate simplified logic:
// http://www.ee.calpoly.edu/media/uploads/resources/KarnaughExplorer_1.html
assign frm_empty_pad_rem_p3[0] = remaining_payload_p3[0];
assign frm_empty_pad_rem_p3[1] = remaining_payload_p3[0] ^ remaining_payload_p3[1];

// Deassert the data valid when pad removal happen, and hold the last valid data until EOP for alignment
// Latch the error signal for all pad data that are removed
assign pad_rem_frm_valid_p3 = frm_valid_p3 & (~pad_rem_ena_p4 | frm_eop_p3);
assign pad_rem_frm_data_p3  = pad_rem_ena_p4 ? frm_data_p4 : frm_data_p3;
assign pad_rem_frm_sop_p3   = frm_sop_p3;
assign pad_rem_frm_eop_p3   = frm_eop_p3;
assign pad_rem_frm_empty_p3 = pad_rem_ena_p4 ? frm_empty_pad_rem_p3 : frm_empty_p3;
assign pad_rem_frm_error_p3 = pad_rem_ena_p4 ? (frm_error_p3 | frm_error_p4) : frm_error_p3;
assign frm_ready_p3         = pad_rem_frm_ready_p3;

alt_em10g32_pipeline_base #(
    .BITS_PER_SYMBOL    (PIPELINE_WIDTH),
    .SYMBOLS_PER_BEAT   (1),
    .PIPELINE_READY     (0)
) frm_pipeline_4 (
    .clk        (mac_rx_clk),
    .reset_n    (mac_rx_rst_b),
    .in_ready   (pad_rem_frm_ready_p3),
    .in_valid   (pad_rem_frm_valid_p3),
    .in_data    ({pad_rem_frm_error_p3, pad_rem_frm_sop_p3, pad_rem_frm_eop_p3, pad_rem_frm_empty_p3, pad_rem_frm_data_p3}),
    .out_ready  (frm_ready_p4),
    .out_valid  (frm_valid_p4),
    .out_data   ({frm_error_p4, frm_sop_p4, frm_eop_p4, frm_empty_p4, frm_data_p4})
);

// Deassert valid during pad removal, and assert when EOP arrived
assign pad_rem_frm_valid_p4 = frm_valid_p4 & (~pad_rem_ena_p4 | frm_eop_p4);
assign pad_rem_frm_data_p4  = frm_data_p4;
assign pad_rem_frm_sop_p4   = frm_sop_p4;
assign pad_rem_frm_eop_p4   = frm_eop_p4;
assign pad_rem_frm_empty_p4 = frm_empty_p4;
assign pad_rem_frm_error_p4 = frm_error_p4;
assign frm_ready_p4         = pad_rem_frm_ready_p4;

alt_em10g32_pipeline_base #(
    .BITS_PER_SYMBOL    (PIPELINE_WIDTH),
    .SYMBOLS_PER_BEAT   (1),
    .PIPELINE_READY     (0)
) frm_pipeline_5 (
    .clk        (mac_rx_clk),
    .reset_n    (mac_rx_rst_b),
    .in_ready   (pad_rem_frm_ready_p4),
    .in_valid   (pad_rem_frm_valid_p4),
    .in_data    ({pad_rem_frm_error_p4, pad_rem_frm_sop_p4, pad_rem_frm_eop_p4, pad_rem_frm_empty_p4, pad_rem_frm_data_p4}),
    .out_ready  (frm_ready_p5),
    .out_valid  (frm_valid_p5),
    .out_data   ({frm_error_p5, frm_sop_p5, frm_eop_p5, frm_empty_p5, frm_data_p5})
);

////////////////////////////////////////////////////////////////////////////////
// Frame Drop & Latch PHY Error
////////////////////////////////////////////////////////////////////////////////

// ASYNC_RESET FLOPS
// Frame Drop
// Hold the data for below 10G mode, until we are able to analyze the frame and decide whether it should be dropped
// For short frames (< 4 clock cycles or 16-bytes), the data will be forwarded to ensure pipelines are not stalled
always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        pipeline_read <= 1'b0;
    end
    else begin
        // Read when EOP or when required information for frame drop is available
        // Do not backpressure when following conditions happen:
        // 1. Back-to-back SOP-EOP (due to CRC removal block always ensure both continuous cycles come in together)
        // 2. Same cycle SOP-EOP (due to CRC removal of 2 cycles frames)
        
        // To avoid scenario where pipeline_read is asserted earlier than frm_fwd_valid due to frm_eop_p1, that cause missing SOP
        // We use frm_eop_p2 to start read from the pipeline, as it will be aligned to (or come later than) frm_drop_info_valid for 4-cycle packet, which is also 2 pipelines from L/T field
        if( (frm_drop_info_valid) |
            (frm_eop_p2 & frm_valid_p2)
            ) begin
            pipeline_read <= 1'b1;
        end
        
        // ASSUMPTION: No back-to-back packet
        else if(frm_eop_p6 & frm_valid_p6) begin
            pipeline_read <= 1'b0;
        end
        
    end
end

assign ucast_frm_fwd_valid = frm_drop_info_unicast & (frm_drop_info_da_matched | csr_rx_allucast_en);
assign mcast_frm_fwd_valid = frm_drop_info_multicast & csr_rx_allmcast_en;
assign bcast_frm_fwd_valid = frm_drop_info_broadcast;
assign ctrl_frm_fwd_valid = frm_drop_ctrl_pfc_behavior ?
                            (ucast_frm_fwd_valid | mcast_frm_fwd_valid | bcast_frm_fwd_valid) & (frm_drop_info_ctrl_frm & ~(frm_drop_info_pause_frm | frm_drop_info_pfc_frm)) & csr_rx_fwd_ctlfrm :
                            (ucast_frm_fwd_valid | mcast_frm_fwd_valid | bcast_frm_fwd_valid) & (frm_drop_info_ctrl_frm & ~(frm_drop_info_pause_frm)) & csr_rx_fwd_ctlfrm;
assign pause_frm_fwd_valid = frm_drop_info_pause_frm & csr_rx_fwd_pausefrm;
assign pfc_frm_fwd_valid = frm_drop_ctrl_pfc_behavior ?
                           frm_drop_info_pfc_frm & csr_rx_pfc_fwd :
                           1'b0;

// SYNC_RESET FLOPS
always @(posedge mac_rx_clk) begin
    if(!mac_rx_rst_b) begin
        frm_fwd_valid <= 1'b0;
    end
    else begin
        // Drop all frames by default, until enough data are received and decoded properly
        // Meaning that minimum of 17-bytes are required for frame decoder to assert frm_drop_info_valid signal
        // Frames < 17-bytes are dropped
        if(frm_drop_info_valid) begin
            // Unicast, multicast, broadcast valid apply only to non-control frames
            frm_fwd_valid <= ((ucast_frm_fwd_valid | mcast_frm_fwd_valid | bcast_frm_fwd_valid) & ~frm_drop_info_ctrl_frm) | ctrl_frm_fwd_valid | pause_frm_fwd_valid | pfc_frm_fwd_valid;
        end
        else if(frm_valid_p6 & frm_ready_p6 & frm_eop_p6) begin
            frm_fwd_valid <= 1'b0;
        end
    end
end

// Latch PHY error until EOP
assign phy_err_latch_frm_valid_p5 = frm_valid_p5;
assign phy_err_latch_frm_data_p5  = frm_data_p5;
assign phy_err_latch_frm_sop_p5   = frm_sop_p5;
assign phy_err_latch_frm_eop_p5   = frm_eop_p5;
assign phy_err_latch_frm_empty_p5 = frm_empty_p5;
assign phy_err_latch_frm_error_p5 = (frm_valid_p5 & frm_sop_p5) ? frm_error_p5 :    // Latch the error starting from SOP
                                    (frm_valid_p6 & frm_eop_p6) ? 1'b0 :            // Clear the latched error the next clock cycle after EOP
                                    (frm_valid_p5) ? frm_error_p6 | frm_error_p5 :  // Latch the error for any valid data other than SOP and EOP
                                    frm_error_p6;                                   // Keep the error for invalid cycle
assign frm_ready_p5               = phy_err_latch_frm_ready_p5;

alt_em10g32_pipeline_base #(
    .BITS_PER_SYMBOL    (PIPELINE_WIDTH),
    .SYMBOLS_PER_BEAT   (1),
    .PIPELINE_READY     (0)
) frm_pipeline_6 (
    .clk        (mac_rx_clk),
    .reset_n    (mac_rx_rst_b),
    .in_ready   (phy_err_latch_frm_ready_p5),
    .in_valid   (phy_err_latch_frm_valid_p5),
    .in_data    ({phy_err_latch_frm_error_p5, phy_err_latch_frm_sop_p5, phy_err_latch_frm_eop_p5, phy_err_latch_frm_empty_p5, phy_err_latch_frm_data_p5}),
    .out_ready  (frm_ready_p6),
    .out_valid  (frm_valid_p6),
    .out_data   ({frm_error_p6, frm_sop_p6, frm_eop_p6, frm_empty_p6, frm_data_p6})
);

assign frame_drop_frm_valid_p6 = frm_fwd_valid & frm_valid_p6 & pipeline_read;
assign frame_drop_frm_data_p6  = frm_data_p6;
assign frame_drop_frm_sop_p6   = frm_sop_p6;
assign frame_drop_frm_eop_p6   = frm_eop_p6;
assign frame_drop_frm_empty_p6 = frm_empty_p6;
assign frame_drop_frm_error_p6 = frm_error_p6;
assign frm_ready_p6            = pipeline_read;

assign rx_fltrpcrem2pa_frm_data  = frame_drop_frm_data_p6;
assign rx_fltrpcrem2pa_frm_sop   = frame_drop_frm_sop_p6;
assign rx_fltrpcrem2pa_frm_eop   = frame_drop_frm_eop_p6;
assign rx_fltrpcrem2pa_frm_valid = frame_drop_frm_valid_p6;
assign rx_fltrpcrem2pa_frm_empty = frame_drop_frm_empty_p6;
assign rx_fltrpcrem2pa_frm_error = frame_drop_frm_error_p6;

endmodule
