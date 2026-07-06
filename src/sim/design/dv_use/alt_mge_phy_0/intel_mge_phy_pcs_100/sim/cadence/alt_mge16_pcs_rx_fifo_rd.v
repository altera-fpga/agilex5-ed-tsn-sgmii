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
// SGMII De-Skew FIFO Read
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_rx_fifo_rd (

   clk,
   reset,
   clk_ena,
   rclk_ena,
   eth_speed,
   ff_dataout_dv,
   ff_aempty,
   ff_rden,
   sampling_win_size_rd,
   octet_ins_num,
   octet_ins_en,
   pcs_dv_single_bit);

parameter STM_TYP_IDLE    = 1'b0;
parameter STM_TYP_FF_READ = 1'b1;
// 1588's ratematch latency handling
localparam MAX_SHIFT = 7;
parameter RM_DEL_INS_WIDTH = 3;
parameter FRAC_CYCLE = 10;
parameter RM_DEL_INS_WIDTH_ADJ = RM_DEL_INS_WIDTH + MAX_SHIFT + FRAC_CYCLE;
parameter CNTR_WIDTH = 11;
    
input  clk;                                       //  MAC Receive Clock
input  reset;                                     //  Active High Global Reset
input  clk_ena;                                   //  Clock Enable
input  rclk_ena;                              
input  [1:0] eth_speed;                        
input  [1:0] ff_dataout_dv;                       //  Output data valid
input  ff_aempty;                                 //  FIFO Almost Empty
output ff_rden;                                   //  FIFO Read Enable
input [CNTR_WIDTH-1:0] sampling_win_size_rd; // 1588's sampling window size in wr_clk cycle
output [RM_DEL_INS_WIDTH_ADJ-1:0] octet_ins_num;  // 1588's insertion number
output octet_ins_en;                              // 1588's insertion enabled
input  pcs_dv_single_bit;                         //  Data Valid signal from PCS enhancement for 1G/2.5G 

reg ff_rden; 
reg octet_ins_en;
reg [RM_DEL_INS_WIDTH_ADJ-1:0] octet_ins_num;
wire pcs_dv_macclk2;
reg state; 
reg nextstate; 

always @(posedge reset or posedge clk)
   begin : process_1
   if (reset == 1'b 1)
      begin
      state <= STM_TYP_IDLE;   
      end
   else
      begin
      
        if (clk_ena==1'b1)
        begin
      
                state <= nextstate; 
                
        end
          
      end
   end

always @(state or ff_aempty)
   begin : process_2
   case (state)
   STM_TYP_IDLE:
      begin
      if (ff_aempty == 1'b 0)
         begin
         nextstate = STM_TYP_FF_READ;   
         end
      else
         begin
         nextstate = STM_TYP_IDLE;   
         end
      end
   STM_TYP_FF_READ:
      begin
      nextstate = STM_TYP_FF_READ;   
      end
   default:
      begin
      nextstate = STM_TYP_IDLE;
      end
   endcase
   end

// Clock crossing for pcs_dv_single_bit to mac_clk domain
alt_mge16_pcs_std_synchronizer #(4) U_SYNC_PCS_DV(
    .clk    (clk),
    .reset_n(~reset),
    .din    (pcs_dv_single_bit),
    .dout   (pcs_dv_macclk2));

always @(posedge reset or posedge clk)
   begin : process_3
   if (reset == 1'b 1)
      begin
      ff_rden <= 1'b 0; 
      end
   else
      begin
        //if (clk_ena==1'b1)
        //begin
                // The fifo must not reach almost empty. If it did, then data will not
                // be read from the fifo during the invalid state. This will avoid fifo 
                // underrun if there are ppm difference between read and write clocks.
				if (state == STM_TYP_FF_READ && (eth_speed == 2'b10) && ~(ff_aempty & !(pcs_dv_macclk2) & !(ff_dataout_dv[1] & ff_dataout_dv[0]))) //2.5Gbps //Base on PCS
				begin
                        ff_rden <= clk_ena;   
                end
				else if (state == STM_TYP_FF_READ && (eth_speed !=2'b10) && ~(ff_aempty & !ff_dataout_dv)) // 10 or 100mbps
                begin
                        ff_rden <= clk_ena; 
                end
                else
                begin
                        ff_rden <= 1'b 0; 
                end
        //end
      end // end if (reset == 1'b 1)
   end // end begin : process_3

   
// 1588's ratematch latency handling (insertion)
// octet_ins_num_hold is used to accummulate number of continuous insertions.    
// To close timing on AV and CV, the following are derived:
// original equation: octet_ins_num (cycle) = (octet_ins_num_hold<<FRAC_CYCLE)*multi_factor
// 1gbps  : multi_factor = 1
// 100mbps: multi_factor = 10 = (8+2) = (<<3 + <<1)
// 10mbps : multi_factor = 100 = (64+32+4) = (<<6 + <<5 + <<2)

reg stable_stage;
reg [RM_DEL_INS_WIDTH-1:0] octet_ins_num_hold;
reg [CNTR_WIDTH-1:0] octet_ins_counter;

always @(posedge reset or posedge clk) begin
    if (reset == 1'b1) begin
        stable_stage <= 1'b0;
        octet_ins_counter <= {CNTR_WIDTH{1'b0}};
        octet_ins_num_hold <= {RM_DEL_INS_WIDTH{1'b0}};
        octet_ins_num <= {RM_DEL_INS_WIDTH_ADJ{1'b0}};
        octet_ins_en <= 1'b0;
    end
    else begin
        
        if (ff_rden) begin
            stable_stage <= 1'b1;
        end
        
        if (state == STM_TYP_FF_READ && (clk_ena & rclk_ena & ~ff_rden) && stable_stage) begin // insertion detected
            octet_ins_en <= 1'b1;
            octet_ins_num <= {RM_DEL_INS_WIDTH_ADJ{1'b0}};
            octet_ins_counter <= sampling_win_size_rd;
            if (octet_ins_counter == {CNTR_WIDTH{1'b0}}) begin
                octet_ins_num_hold <= 3'd1;
            end
            else begin
                octet_ins_num_hold <= octet_ins_num_hold + 3'd1;
            end
        end
        else begin
        
            if (octet_ins_counter == {CNTR_WIDTH{1'b0}}) begin
                octet_ins_num_hold <= {RM_DEL_INS_WIDTH{1'b0}};
                octet_ins_en <= 1'b0;
                octet_ins_counter <= octet_ins_counter;
            end
            else begin
                octet_ins_num_hold <= octet_ins_num_hold;
                octet_ins_en <= octet_ins_en;
                octet_ins_counter <= octet_ins_counter - 11'd1;
            end
        
            if (clk_ena & rclk_ena) begin // align latency_adj-update to first data-byte after inserted-byte
                if (eth_speed == 2'b10)
                    octet_ins_num <= octet_ins_num_hold<<(FRAC_CYCLE); 
                if (eth_speed == 2'b01)
                    octet_ins_num <= (octet_ins_num_hold<<(FRAC_CYCLE+3)) + (octet_ins_num_hold<<(FRAC_CYCLE+1));
                if (eth_speed == 2'b00)
                    octet_ins_num <= (octet_ins_num_hold<<(FRAC_CYCLE+6)) + (octet_ins_num_hold<<(FRAC_CYCLE+5)) + (octet_ins_num_hold<<(FRAC_CYCLE+2));
            end
        end
    end
end

endmodule // module rx_fifo_rd
