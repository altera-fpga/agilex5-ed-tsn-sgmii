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

module alt_em10g32_rx_rs_xgmii_ultra (
   // Clock and reset
   input wire top2rs_xgmii_rx_clk,
   input wire top2rs_xgmii_rx_rst_b,

   // CSR control path
   input wire csr_preamble_passthru,
   input wire csr_rx_tsfr_en_n,
   
   output reg rx_tsfr_sts_xgmii_ultra,

   // Avalon-ST Data path
   output reg rx_ethfrm_sop_10g,
   output reg rx_ethfrm_eop_10g,
   output reg [1:0] rx_ethfrm_empty_10g,
   output reg rx_ethfrm_valid_10g,
   output reg rx_ethfrm_error_10g,
   output wire [31:0] rx_ethfrm_data_10g,
   output reg packet_in_progress_xgmii_ultra,

   // Link fault status
   output reg [1:0] rx_link_fault_status_xgmii_rx_data,

   // xgmii data
   input wire  [31:0] rx_top2rs_xgmii_rx_data,
   input wire  [3:0] rx_top2rs_xgmii_rx_ctrl,
   input wire rx_top2rs_xgmii_rx_valid
);

parameter SYNC_RESET_N        = 1;

// LOCAL PARAMETERS
localparam SYM_START          = 9'h1FB;
localparam SYM_SFD            = 9'h0D5;
localparam SYM_EFD_DATA       = 8'hFD;
localparam SYM_ERR_DATA       = 8'hFE;
localparam SYM_SEQ            = 9'h19C;
localparam SYM_IDLE           = 9'h107;
localparam SYM_PREAMBLE       = 9'h055;

// Data path state machine parameters
localparam IDLE               = 3'h0;
localparam PREAM0             = 3'h1;
localparam PREAM1             = 3'h2;
localparam DATA               = 3'h3;
localparam END                = 3'h4;

// Data path state machine registers
reg [2:0] state;
reg [2:0] prev_state;
reg [2:0] next_state;

reg [1:0] seq_type;
reg [1:0] last_seq_type;
reg [2:0] seq_cnt_reg;
reg [7:0] col_cnt_reg;


// Data path registers
reg [31:0] xgmii_data_reg_0;
reg [31:0] xgmii_data_reg_1;
reg [31:0] xgmii_data_reg_2;
reg [31:0] xgmii_data_reg_3;
reg [3:0] xgmii_ctrl_reg_0;

wire [7:0] lane_3_data, lane_2_data, lane_1_data, lane_0_data;
wire lane_3_ctrl, lane_2_ctrl, lane_1_ctrl, lane_0_ctrl;
wire [7:0] lane_0_data_prev;
wire lane_0_ctrl_prev;

reg [7:0] mux_3_out, mux_2_out, mux_1_out, mux_0_out;

wire idle_3, idle_2, idle_1, idle_0;
wire data_3, data_2, data_1, data_0;
wire data_is_0_2, data_is_0_1;
wire data_is_lf;
wire seq_0;
wire s_0;
wire sfd_3;
wire err_3, err_2, err_1, err_0;
wire t_3, t_2, t_1, t_0;
wire t_0_prev;

reg idle_3_reg_0, idle_2_reg_0, idle_1_reg_0, idle_0_reg_0;
reg data_3_reg_0, data_2_reg_0, data_1_reg_0, data_0_reg_0;
reg data_3_reg_1, data_2_reg_1, data_1_reg_1, data_0_reg_1;
reg data_is_0_2_reg_0, data_is_0_1_reg_0;
reg data_is_lf_reg_0;
reg seq_0_reg_0;
reg t_3_reg_0, t_2_reg_0, t_1_reg_0, t_0_reg_0;
reg t_3_reg_1, t_2_reg_1, t_1_reg_1;

reg err_0_reg_0, err_1_reg_0, err_2_reg_0, err_3_reg_0;
reg err_1_reg_1, err_2_reg_1, err_3_reg_1;

wire cond_0, cond_1, cond_2, cond_3, cond_4;
wire err_cond_0, err_cond_1, err_cond_2, err_cond_3;
reg is_pream0;
reg is_pream1;

wire sop, eop, valid;
wire [1:0] empty;

reg fault_sequence_reg;
wire fault_sequence, seq_cnt_is_4, col_cnt_is_128, seq_type_equal;

reg xgmii_valid_reg_0;
reg xgmii_valid_reg_1;
reg xgmii_valid_reg_2;

reg csr_rx_tsfr_en_n_dly;

// Convert XGMII data signal to Avalon ST data signals from little endian to big endian
assign rx_ethfrm_data_10g = {
   xgmii_data_reg_3[7:0],
   xgmii_data_reg_3[15:8],
   xgmii_data_reg_3[23:16],
   xgmii_data_reg_3[31:24]
}; 

// Spliting XGMII signals to each lanes
assign {lane_3_data, lane_2_data, lane_1_data, lane_0_data} = xgmii_data_reg_0;
assign {lane_3_ctrl, lane_2_ctrl, lane_1_ctrl, lane_0_ctrl} = xgmii_ctrl_reg_0;

assign lane_0_data_prev = rx_top2rs_xgmii_rx_data[7:0];
assign lane_0_ctrl_prev = rx_top2rs_xgmii_rx_ctrl[0];

// Comparator logic
assign idle_0 = ({lane_0_ctrl, lane_0_data} == SYM_IDLE);
assign idle_1 = ({lane_1_ctrl, lane_1_data} == SYM_IDLE);
assign idle_2 = ({lane_2_ctrl, lane_2_data} == SYM_IDLE);
assign idle_3 = ({lane_3_ctrl, lane_3_data} == SYM_IDLE);

assign data_0 = ~ lane_0_ctrl;
assign data_1 = ~ lane_1_ctrl;
assign data_2 = ~ lane_2_ctrl;
assign data_3 = ~ lane_3_ctrl;

assign data_is_0_2 = ({data_2, lane_2_data} == 9'b1_0000_0000);
assign data_is_0_1 = ({data_1, lane_1_data} == 9'b1_0000_0000);
assign data_is_lf = (data_3 & (lane_3_data == 8'h1 || lane_3_data == 8'h2));

assign seq_0 = ({lane_0_ctrl, lane_0_data} == SYM_SEQ);
assign s_0   = ({lane_0_ctrl, lane_0_data} == SYM_START);
assign sfd_3 = ({lane_3_ctrl, lane_3_data} == SYM_SFD);

// Potential error character detection
// First control character in frame and it is not EFD
assign err_0 = (lane_0_ctrl & (lane_0_data != SYM_EFD_DATA));
assign err_1 = (lane_1_ctrl & (lane_1_data != SYM_EFD_DATA));
assign err_2 = (lane_2_ctrl & (lane_2_data != SYM_EFD_DATA));
assign err_3 = (lane_3_ctrl & (lane_3_data != SYM_EFD_DATA));

assign t_0 = (lane_0_ctrl & (lane_0_data != SYM_ERR_DATA));
assign t_1 = (lane_1_ctrl & (lane_1_data != SYM_ERR_DATA));
assign t_2 = (lane_2_ctrl & (lane_2_data != SYM_ERR_DATA));
assign t_3 = (lane_3_ctrl & (lane_3_data != SYM_ERR_DATA));

assign t_0_prev = (lane_0_ctrl_prev & (lane_0_data_prev != SYM_ERR_DATA));

// SYNC_RESET FLOPS
// Comparator logic that is flopped
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      {idle_3_reg_0, idle_2_reg_0, idle_1_reg_0, idle_0_reg_0} <= 4'b0;
      {data_3_reg_0, data_2_reg_0, data_1_reg_0, data_0_reg_0} <= 4'b1110;
      {data_3_reg_1, data_2_reg_1, data_1_reg_1, data_0_reg_1} <= 4'b1110;
      seq_0_reg_0 <= 1'b1;
      {t_3_reg_0, t_2_reg_0, t_1_reg_0, t_0_reg_0} <= 4'b0001;
      {t_3_reg_1, t_2_reg_1, t_1_reg_1} <= 3'b0;
      {data_is_lf_reg_0, data_is_0_2_reg_0, data_is_0_1_reg_0} <= 3'b111;
      {err_0_reg_0, err_1_reg_0, err_2_reg_0, err_3_reg_0} <= 4'b1000;
      {err_1_reg_1, err_2_reg_1, err_3_reg_1} <= 3'b0;
   end
   else
   begin
      {idle_3_reg_0, idle_2_reg_0, idle_1_reg_0, idle_0_reg_0} <= {idle_3, idle_2, idle_1, idle_0};
      {data_3_reg_0, data_2_reg_0, data_1_reg_0, data_0_reg_0} <= {data_3, data_2, data_1, data_0};
      {data_3_reg_1, data_2_reg_1, data_1_reg_1, data_0_reg_1} <= {data_3_reg_0, data_2_reg_0, data_1_reg_0, data_0_reg_0};
      seq_0_reg_0 <= seq_0;
      {t_3_reg_0, t_2_reg_0, t_1_reg_0, t_0_reg_0} <= {t_3, t_2, t_1, t_0};
      {t_3_reg_1, t_2_reg_1, t_1_reg_1} <= {t_3_reg_0, t_2_reg_0, t_1_reg_0};
      {data_is_lf_reg_0, data_is_0_2_reg_0, data_is_0_1_reg_0} <= {data_is_lf, data_is_0_2, data_is_0_1};
      {err_0_reg_0, err_1_reg_0, err_2_reg_0, err_3_reg_0} <= {err_0, err_1, err_2, err_3};
      {err_1_reg_1, err_2_reg_1, err_3_reg_1} <= {err_1_reg_0, err_2_reg_0, err_3_reg_0};
   end
end

// Error condition at each lane
// First control character in the frame and it is not an EFD
assign err_cond_0 = valid & data_3_reg_1 & data_2_reg_1 & data_1_reg_1 & data_0_reg_1 & err_0_reg_0; 
assign err_cond_1 = valid & data_0_reg_1 & err_1_reg_1;
assign err_cond_2 = valid & data_1_reg_1 & err_2_reg_1;
assign err_cond_3 = valid & data_2_reg_1 & err_3_reg_1;

// SYNC_RESET FLOPS
// Pipeline registers
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      xgmii_ctrl_reg_0 <= 4'h01;
      xgmii_data_reg_0 <= 32'h0100009C;
      xgmii_valid_reg_0 <= 1'b0;
   end
   else
   begin
      if (rx_top2rs_xgmii_rx_valid)
      begin
         xgmii_ctrl_reg_0 <= rx_top2rs_xgmii_rx_ctrl;
         xgmii_data_reg_0 <= rx_top2rs_xgmii_rx_data;
         xgmii_valid_reg_0 <= rx_top2rs_xgmii_rx_valid;
      end
      else
      begin
         xgmii_ctrl_reg_0 <= xgmii_ctrl_reg_0;
         xgmii_data_reg_0 <= xgmii_data_reg_0;
         xgmii_valid_reg_0 <= 1'b0;
      end
   end
end

// NON_RESETABLE FLOPS
always @ (posedge top2rs_xgmii_rx_clk)
begin
      xgmii_valid_reg_1 <= xgmii_valid_reg_0;
      xgmii_valid_reg_2 <= xgmii_valid_reg_1;
      xgmii_data_reg_1 <= xgmii_data_reg_0;
      xgmii_data_reg_2 <= xgmii_data_reg_1;
      xgmii_data_reg_3 <= {mux_3_out, mux_2_out, mux_1_out, mux_0_out};
end

// MUX_0
always @(*)
begin
   if (err_cond_0)
   begin
      mux_0_out = xgmii_data_reg_2[7:0] ^ 8'hFF;
   end
   else
   begin
      mux_0_out = xgmii_data_reg_2[7:0];
   end
end

// MUX_1
always @(*)
begin
   if (err_cond_1)
   begin
      mux_1_out = xgmii_data_reg_2[15:8] ^ 8'hFF;
   end
   else
   begin
      mux_1_out = xgmii_data_reg_2[15:8];
   end
end

// MUX_2
always @(*)
begin
   if (err_cond_2)
   begin
      mux_2_out = xgmii_data_reg_2[23:16] ^ 8'hFF;
   end
   else
   begin
      mux_2_out = xgmii_data_reg_2[23:16];
   end
end

// MUX_3
always @(*)
begin
   if (err_cond_3)
   begin
      mux_3_out = xgmii_data_reg_2[31:24] ^ 8'hFF;
   end
   else
   begin
      mux_3_out = xgmii_data_reg_2[31:24];
   end
end

// SYNC_RESET FLOPS
// Data path state machine
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      state <= IDLE;
      prev_state <= IDLE;
   end
   else
   begin
      state <= next_state;
      prev_state <= state;
   end
end

// SYNC_RESET FLOPS
// Data path state machine transition logic
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      is_pream0 <= 1'b0;
      is_pream1 <= 1'b0;
   end
   else
   begin
      // 4 IDLE or SEQ follow by a preamble word 0
      is_pream0 <= ((idle_0_reg_0 & idle_1_reg_0 & idle_2_reg_0 & idle_3_reg_0) |
                  (seq_0_reg_0 & data_1_reg_0 & data_2_reg_0 & data_3_reg_0)) & 
                  (s_0 & data_1 & data_2 & data_3);
      // Preamble word 1
      is_pream1 <= (data_0 & data_1 & data_2 & data_3) & (sfd_3 | csr_preamble_passthru);
   end
end

// State machine state transition conditions
// Ensure we are getting the first preamble column
assign cond_0 = is_pream0;
// Ensure we are getting the second preamble column
assign cond_1 = is_pream1;
// Transition to DATA state
// We need to make sure we are not gettting any terminate character in this column
// we are getting terminate character in this column, we will ignore the whole frame
assign cond_2 = ~(t_0 | t_1_reg_0 | t_2_reg_0 | t_3_reg_0);
// Transition to END state
assign cond_3 = (t_0 | t_1_reg_0 | t_2_reg_0 | t_3_reg_0);
assign cond_4 = (t_0_prev & !xgmii_valid_reg_0);

always @ (posedge top2rs_xgmii_rx_clk)
    begin
    if(~top2rs_xgmii_rx_rst_b)
        begin
        rx_tsfr_sts_xgmii_ultra <= 1'b0;
        end
    else    
        begin
        if(state == IDLE)
            begin
            rx_tsfr_sts_xgmii_ultra <= csr_rx_tsfr_en_n;
            end
        end
    end

always @(*)
begin
   case (state)
   IDLE:
   begin
      // if csr_rx_tsfr_en_n == 1 mean rx path disable. hence if csr_rx_tsfr_en_n == 0(enabled) then only can go to next state
      if (~csr_rx_tsfr_en_n && cond_0 && xgmii_valid_reg_1)
         next_state = PREAM0;
      else if (~csr_rx_tsfr_en_n && !xgmii_valid_reg_1)
         next_state = state;
      else
         next_state = IDLE;
   end
   PREAM0:
   begin
      if (cond_1 && xgmii_valid_reg_1)
         next_state = PREAM1;
      else if (!xgmii_valid_reg_1)
         next_state = state;
      else
         next_state = IDLE;
   end
   PREAM1:
   begin
      if (cond_2 && xgmii_valid_reg_1)
         next_state = DATA;
      else if (!xgmii_valid_reg_1)
         next_state = state;
      else
         next_state = IDLE;
   end
   DATA:
   begin
      if ((cond_3 && xgmii_valid_reg_1) || cond_4)
         next_state = END;
      else if (!xgmii_valid_reg_1)
         next_state = state;
      else
         next_state = DATA;
   end
   END:
   begin
         next_state = IDLE;
   end
   default:
   begin
      next_state = IDLE;
   end
   endcase
end

// sop, eop, valid and empty signals
assign sop = (state == DATA) & (prev_state == PREAM1);
assign eop = (state == END) ? 1'b1 : 1'b0;
assign valid = ((state == DATA || state == END) && xgmii_valid_reg_2) ? 1'b1 : 1'b0;
assign empty = (state == END & t_1_reg_1) ? 2'h3:
   (state == END & t_2_reg_1) ? 2'h2:
   (state == END & t_3_reg_1) ? 2'h1:
   (state == END & t_0_reg_0) ? 2'b0:
   2'h0;

// SYNC_RESET FLOPS
// rx_ethfrm_error_10g is asserted once error condition is detected
// and latched until eop of the packet
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      rx_ethfrm_error_10g <= 1'b0;
   end
   else
   begin
      if (rx_ethfrm_eop_10g)
      begin
         rx_ethfrm_error_10g <= 1'b0;
      end
      else
      begin
         if (err_cond_0 | err_cond_1 | err_cond_2 | err_cond_3)
         begin
            rx_ethfrm_error_10g <= 1'b1;
         end
      end
   end
end

// SYNC_RESET FLOPS
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      rx_ethfrm_sop_10g <= 1'b0;
      rx_ethfrm_eop_10g <= 1'b0;
      rx_ethfrm_valid_10g <= 1'b0;
      rx_ethfrm_empty_10g <= 2'b0;
   end
   else
   begin
      rx_ethfrm_sop_10g <= sop;
      rx_ethfrm_eop_10g <= eop;
      rx_ethfrm_valid_10g <= valid;
      rx_ethfrm_empty_10g <= empty;
   end
end

// SYNC_RESET FLOPS
// fault_sequence_reg and seq_type
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      fault_sequence_reg <= 1'b1;
      seq_type <= 2'b01;
   end
   else
   begin
      if (fault_sequence)
      begin
         fault_sequence_reg <= xgmii_valid_reg_1;
         seq_type <= xgmii_data_reg_1[25:24];
      end
      else
      begin
         fault_sequence_reg <= 1'b0;
      end
   end
end

// SYNC_RESET FLOPS
// Link fault output
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      rx_link_fault_status_xgmii_rx_data <= 2'b01;
   end
   else
   begin
      if (col_cnt_is_128)
         rx_link_fault_status_xgmii_rx_data <= 2'b0;
      else if (seq_cnt_is_4)
         rx_link_fault_status_xgmii_rx_data <= last_seq_type;
   end
end

assign fault_sequence = seq_0_reg_0 & data_is_0_1_reg_0 & data_is_0_2_reg_0 & data_is_lf_reg_0;
assign seq_cnt_is_4 = seq_cnt_reg[2]; // seq_cnt_reg == 4; 
assign col_cnt_is_128 = col_cnt_reg[7]; // col_cnt_reg > 127;
assign seq_type_equal = (seq_type == last_seq_type) ? 1'b1: 1'b0;

// SYNC_RESET FLOPS
// last_seq_type
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      last_seq_type <= 2'b01;
   end
   else
   begin
      if (fault_sequence_reg)
      begin
         last_seq_type <= seq_type;
      end
   end
end

// SYNC_RESET FLOPS
// seq_cnt_reg
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      seq_cnt_reg <= 3'b0;
   end
   else
   begin
      if (col_cnt_is_128)
      begin
         if (fault_sequence_reg)
            seq_cnt_reg <= 3'b1;
         else
            seq_cnt_reg <= 3'b0;
      end
      else
      begin
         if (fault_sequence_reg & ~seq_type_equal)
         begin
            seq_cnt_reg <= 3'h1;
         end
         else if (fault_sequence_reg & ~seq_cnt_is_4)
         begin
            seq_cnt_reg <= seq_cnt_reg + 3'h1;
         end
      end
   end
end

// SYNC_RESET FLOPS
// col_cnt_reg
always @ (posedge top2rs_xgmii_rx_clk)
begin
   if(~top2rs_xgmii_rx_rst_b)
   begin
      col_cnt_reg <= 8'b0;
   end
   else
   begin
      if (fault_sequence_reg)
      begin
         col_cnt_reg <= 8'b0;
      end
      else
      begin
         if (col_cnt_is_128)
            col_cnt_reg <= col_cnt_reg;
         else
            col_cnt_reg <= col_cnt_reg + 8'h1;
      end
   end
end

// packet in progress should asserted when disable rx path and there is still got packet. 
generate if (SYNC_RESET_N == 1) begin
  always @ (posedge top2rs_xgmii_rx_clk)
    begin
    if(~top2rs_xgmii_rx_rst_b)
        begin
        packet_in_progress_xgmii_ultra <= 1'b0;
        csr_rx_tsfr_en_n_dly <= 1'b0;
        end
    else
        begin
        // reason to use delayed transfer enable because if there is one clock delay between rx_tsfr_sts_xgmii and csr_rx_tsfr_en_n.
        // if use csr_rx_tsfr_en_n, then there will be a clock packet_in_progress_xgmii will be 1 during no packet transfer
        // hence need to use csr_rx_tsfr_en_n_dly
        csr_rx_tsfr_en_n_dly <= csr_rx_tsfr_en_n;
        if(!csr_rx_tsfr_en_n_dly)
            begin
            if(next_state == PREAM0)
                begin
                packet_in_progress_xgmii_ultra <= 1'b1;
                end
            else if(next_state == IDLE)
                begin
                packet_in_progress_xgmii_ultra <= 1'b0;
                end
            end
        else
            begin
            // rx_tsfr_sts_xgmii 1 mean disable rx path
            if(rx_tsfr_sts_xgmii_ultra)
                begin
                packet_in_progress_xgmii_ultra <= 1'b0;
                end
            else
                begin
                packet_in_progress_xgmii_ultra <= 1'b1;
                end
            end
        end
    end
end else begin
  always @ (posedge top2rs_xgmii_rx_clk or negedge top2rs_xgmii_rx_rst_b)
    begin
    if(~top2rs_xgmii_rx_rst_b)
        begin
        packet_in_progress_xgmii_ultra <= 1'b0;
        csr_rx_tsfr_en_n_dly <= 1'b0;
        end
    else
        begin
        // reason to use delayed transfer enable because if there is one clock delay between rx_tsfr_sts_xgmii and csr_rx_tsfr_en_n.
        // if use csr_rx_tsfr_en_n, then there will be a clock packet_in_progress_xgmii will be 1 during no packet transfer
        // hence need to use csr_rx_tsfr_en_n_dly
        csr_rx_tsfr_en_n_dly <= csr_rx_tsfr_en_n;
        if(!csr_rx_tsfr_en_n_dly)
            begin
            if(next_state == PREAM0)
                begin
                packet_in_progress_xgmii_ultra <= 1'b1;
                end
            else if(next_state == IDLE)
                begin
                packet_in_progress_xgmii_ultra <= 1'b0;
                end
            end
        else
            begin
            // rx_tsfr_sts_xgmii 1 mean disable rx path
            if(rx_tsfr_sts_xgmii_ultra)
                begin
                packet_in_progress_xgmii_ultra <= 1'b0;
                end
            else
                begin
                packet_in_progress_xgmii_ultra <= 1'b1;
                end
            end
        end
    end
end
endgenerate

endmodule
