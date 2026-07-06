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

module alt_mge_phy_usxg32_umii_fault #(
   parameter SYNCHRONIZER_DEPTH = 3
) (
   // Clock
   input  wire        tx_clk,
   input  wire        rx_clk,

   // Reset
   input  wire        tx_reset_n,
   input  wire        rx_reset_n,

   // RX XGMII
   input  wire        rx_xgmii_valid_in,
   input  wire [3:0]  rx_xgmii_control_in,
   input  wire [31:0] rx_xgmii_data_in,

   // TX XGMII
   output reg         tx_xgmii_valid_out,
   output reg  [3:0]  tx_xgmii_control_out,
   output reg  [31:0] tx_xgmii_data_out,

   // Link fault status
   output reg  [1:0]  rx_umii_fault_status
   
);

// LOCAL PARAMETERS
localparam SYM_SEQ     = 8'h9C;
localparam SYM_IDLE    = 8'h07;
localparam SYM_UMII_LF = 8'h11;
localparam SYM_UMII_RF = 8'h22;

reg [1:0] seq_type;
reg [1:0] last_seq_type;
reg [2:0] seq_cnt_reg;
reg [7:0] col_cnt_reg;

// Data path registers
reg [31:0] xgmii_data_reg_0;
reg [31:0] xgmii_data_reg_1;
reg [3:0] xgmii_ctrl_reg_0;

wire [7:0] lane_3_data, lane_2_data, lane_1_data, lane_0_data;
wire lane_3_ctrl, lane_2_ctrl, lane_1_ctrl, lane_0_ctrl;

wire data_3, data_2, data_1;
wire data_is_0_2, data_is_0_1;
wire data_is_lf;
wire seq_0;

reg data_is_0_2_reg_0, data_is_0_1_reg_0;
reg data_is_lf_reg_0;
reg seq_0_reg_0;

reg fault_sequence_reg;
wire fault_sequence, seq_cnt_is_4, col_cnt_is_128, seq_type_equal;

// TX clock domain signal
wire [1:0] rx_umii_fault_status__tx_clk;

// Spliting XGMII signals to each lanes
assign {lane_3_data, lane_2_data, lane_1_data, lane_0_data} = xgmii_data_reg_0;
assign {lane_3_ctrl, lane_2_ctrl, lane_1_ctrl, lane_0_ctrl} = xgmii_ctrl_reg_0;

assign data_1 = ~ lane_1_ctrl;
assign data_2 = ~ lane_2_ctrl;
assign data_3 = ~ lane_3_ctrl;

assign data_is_0_2 = ({data_2, lane_2_data} == 9'b1_0000_0000);
assign data_is_0_1 = ({data_1, lane_1_data} == 9'b1_0000_0000);
assign data_is_lf = (data_3 & (lane_3_data == SYM_UMII_LF || lane_3_data == SYM_UMII_RF));

assign seq_0 = ({lane_0_ctrl, lane_0_data} == {1'b1, SYM_SEQ});

// SYNC_RESET FLOPS
// Comparator logic that is flopped
always @ (posedge rx_clk)
begin
   if(~rx_reset_n)
   begin
      seq_0_reg_0 <= 1'b0;
      {data_is_lf_reg_0, data_is_0_2_reg_0, data_is_0_1_reg_0} <= 3'b0;
   end
   else
   begin
      if(rx_xgmii_valid_in)
      begin
        seq_0_reg_0 <= seq_0;
        {data_is_lf_reg_0, data_is_0_2_reg_0, data_is_0_1_reg_0} <= {data_is_lf, data_is_0_2, data_is_0_1};
      end  
   end
end

// SYNC_RESET FLOPS
// Pipeline registers
always @ (posedge rx_clk)
begin
   if(~rx_reset_n)
   begin
      xgmii_ctrl_reg_0 <= 4'b0;
      xgmii_data_reg_0 <= 32'b0;
   end
   else
   begin
      if(rx_xgmii_valid_in)
      begin
        xgmii_ctrl_reg_0 <= rx_xgmii_control_in;
        xgmii_data_reg_0 <= rx_xgmii_data_in;
      end   
   end
end

// NON_RESETABLE FLOPS
always @ (posedge rx_clk)
begin
   if(rx_xgmii_valid_in)
   begin
   xgmii_data_reg_1 <= xgmii_data_reg_0;
   end 
end

// SYNC_RESET FLOPS
// fault_sequence_reg and seq_type
always @ (posedge rx_clk)
begin
   if(~rx_reset_n)
   begin
      fault_sequence_reg <= 1'b0;
      seq_type <= 2'b0;
   end
   else
   begin
      if(rx_xgmii_valid_in)
      begin
        if (fault_sequence)
        begin
            fault_sequence_reg <= 1'b1;
            seq_type <= xgmii_data_reg_1[25:24];
        end
        else
        begin
            fault_sequence_reg <= 1'b0;
        end
      end
   end
end

// SYNC_RESET FLOPS
// Link fault output
always @ (posedge rx_clk)
begin
   if(~rx_reset_n)
   begin
      rx_umii_fault_status <= 2'b0;
   end
   else
   begin
      if (col_cnt_is_128 && rx_xgmii_valid_in)
         rx_umii_fault_status <= 2'b0;
      else if (seq_cnt_is_4 && rx_xgmii_valid_in)
         rx_umii_fault_status <= last_seq_type;
   end
end

assign fault_sequence = seq_0_reg_0 & data_is_0_1_reg_0 & data_is_0_2_reg_0 & data_is_lf_reg_0;
assign seq_cnt_is_4 = seq_cnt_reg[2]; // seq_cnt_reg == 4; 
assign col_cnt_is_128 = col_cnt_reg[7]; // col_cnt_reg > 127;
assign seq_type_equal = (seq_type == last_seq_type) ? 1'b1: 1'b0;

// SYNC_RESET FLOPS
// last_seq_type
always @ (posedge rx_clk)
begin
   if(~rx_reset_n)
   begin
      last_seq_type <= 2'b0;
   end
   else
   begin
      if (fault_sequence_reg && rx_xgmii_valid_in)
      begin
         last_seq_type <= seq_type;
      end
   end
end

// SYNC_RESET FLOPS
// seq_cnt_reg
always @ (posedge rx_clk)
begin
   if(~rx_reset_n)
   begin
      seq_cnt_reg <= 3'b0;
   end
   else
   begin
      if(rx_xgmii_valid_in)
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
end

// SYNC_RESET FLOPS
// col_cnt_reg
always @ (posedge rx_clk)
begin
   if(~rx_reset_n)
   begin
      col_cnt_reg <= 8'b0;
   end
   else
   begin
      if(rx_xgmii_valid_in)
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
end

// Clock cross output to TX clock domain
alt_mge_phy_mbow_clock_crosser #(
    .SYNCHRONIZER_DEPTH     (SYNCHRONIZER_DEPTH),
    .DATA_WIDTH             (2),
    .OUT_DATA_RESET_VALUE   (2'b00),
    .IN_TRANSFER_CYCLE      (6),
    .IN_VALID_LENGTH        (2)
) tx_xgmii_clock_crosser (
    .in_clk         (rx_clk),
    .out_clk        (tx_clk),
    
    .in_reset_n     (rx_reset_n),
    .out_reset_n    (tx_reset_n),
    
    .in_data        (rx_umii_fault_status),
    .out_data       (rx_umii_fault_status__tx_clk)
);

// TX clock domain output
always @ (posedge tx_clk)
begin
   if(~tx_reset_n)
   begin
      tx_xgmii_valid_out   <= 1'b0;
      tx_xgmii_control_out <= 4'h0;
      tx_xgmii_data_out    <= 32'h0;
   end
   else
   begin
      case(rx_umii_fault_status__tx_clk)
         
         SYM_UMII_LF[1:0]:
         begin
            tx_xgmii_valid_out   <= 1'b1;
            tx_xgmii_control_out <= 4'b0001;
            tx_xgmii_data_out    <= {SYM_UMII_RF, 8'h00, 8'h00, SYM_SEQ};
         end
         
         SYM_UMII_RF[1:0]:
         begin
            tx_xgmii_valid_out   <= 1'b1;
            tx_xgmii_control_out <= 4'b1111;
            tx_xgmii_data_out    <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
         end
         
         default:
         begin
            tx_xgmii_valid_out   <= 1'b0;
            tx_xgmii_control_out <= 4'h0;
            tx_xgmii_data_out    <= 32'h0;
         end
      endcase
      
   end
end

endmodule
