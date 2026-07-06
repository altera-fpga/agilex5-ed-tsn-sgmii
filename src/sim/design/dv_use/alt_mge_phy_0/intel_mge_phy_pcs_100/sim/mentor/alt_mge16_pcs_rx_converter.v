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
// SGMII Receive Converter
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_rx_converter (

   reset,
   sw_reset,
   clk,
   eth_speed,
   pcs_data,
   pcs_dv,
   pcs_err,
   ff_afull,
   ff_wren,
   ff_data,
   sampling_win_size_wr,
   octet_del_en);

localparam STM_TYP_IDLE      = 2'h0;
localparam STM_TYP_GIGA_MODE = 2'h1;
localparam STM_TYP_WAIT_RD   = 2'h2;
localparam STM_TYP_FF_WRITE  = 2'h3;
// 1588's ratematch latency handling
localparam MAX_SHIFT = 7;
parameter RM_DEL_INS_WIDTH = 3;
parameter FRAC_CYCLE = 10;
parameter RM_DEL_INS_WIDTH_ADJ = RM_DEL_INS_WIDTH + MAX_SHIFT + FRAC_CYCLE;
parameter CNTR_WIDTH = 11;
parameter ENABLE_PHASE_CALC = 0;

localparam DATA_WIDTH = ENABLE_PHASE_CALC == 0 ? 20 : 20 + RM_DEL_INS_WIDTH_ADJ; 

input   reset;                                //  Active High Global Reset
input   sw_reset;                             //  SW Synchronous Reset           
input   clk;                                  //  125MHz Receive Clock
input   [1:0] eth_speed;                      //  Signal Detect from PMA
input   [15:0] pcs_data;                      //  GMII Data enhancement for 1G/2.5G 
input   [1:0] pcs_dv;                         //  GMII Data Valid enhancement for 1G/2.5G         
input   [1:0] pcs_err;                        //  GMII Error enhancement for 1G/2.5G         
input   ff_afull;                             //  FIFO Almost Full
output  ff_wren;                              //  FIFO Write Enable           
output  [DATA_WIDTH-1:0] ff_data;   //  FIFO Data
input   [CNTR_WIDTH-1:0] sampling_win_size_wr; // 1588's sampling window size in wr_clk cycle
output  octet_del_en;                         //  1588's deletion enable

reg     ff_wren; 
wire    [DATA_WIDTH-1:0] ff_data; 
reg     [19:0] ff_data_reg; 
reg 	[1:0] init_count;

reg   [1:0] pcs_dv_int;
reg   [1:0] pcs_err_int;

reg     [1:0] nextstate; 
reg     [1:0] state; 
reg     [6:0] wren_cnt; 
reg     rden_cnt_dec; 
reg     [2:0] rm_cnt;

wire  [RM_DEL_INS_WIDTH_ADJ-1:0]    octet_del_num_adj;     //  1588's deletion number (after speed multiplication)
reg  [RM_DEL_INS_WIDTH-1:0]         octet_del_num;         //  1588's deletion number (before speed multiplication)

reg    octet_del_en;

generate if (ENABLE_PHASE_CALC == 0)
begin
   assign ff_data = ff_data_reg;
   
   always @ (posedge clk)
   begin
   	octet_del_en <= 0;
   end	   
   
end else begin
   assign ff_data = {octet_del_num_adj, ff_data_reg};

	// To close timing on AV and CV, the following are derived:
	// original equation: octet_del_num_adj (cycle) = (octet_del_num<<FRAC_CYCLE)*multi_factor
	// 1gbps  : multi_factor = 1
	// 100mbps: multi_factor = 10 = (8+2) = (<<3 + <<1)
	// 10mbps : multi_factor = 100 = (64+32+4) = (<<6 + <<5 + <<2)
	assign octet_del_num_adj  = (eth_speed == 2'b10) ? (octet_del_num<<(FRAC_CYCLE)) :
								(eth_speed == 2'b01) ? ((octet_del_num<<(FRAC_CYCLE+3)) + (octet_del_num<<(FRAC_CYCLE+1))) :
								((octet_del_num<<(FRAC_CYCLE+6)) + (octet_del_num<<(FRAC_CYCLE+5)) + (octet_del_num<<(FRAC_CYCLE+2)));
								
    //register octet_del_en before synchronizer
    always @ (posedge clk or posedge reset)
    begin
      if (reset) begin
    	octet_del_en <= 1'b0;
      end else begin
    	octet_del_en  <= (octet_del_num == 0) ? 1'b0 : 1'b1;
      end
    end								
   
end
endgenerate

always @(posedge reset or posedge clk)
   begin : process_2
   if (reset == 1'b 1)
      begin
      state <= STM_TYP_IDLE;   
      end
   else
      begin
      state <= nextstate;   
      end
   end

always @(posedge reset or posedge clk)
   begin
   if (reset == 1'b 1)
      begin
      init_count <= 2'b0;   
      end
   else
      begin
		if (init_count == 2'b1) begin
			init_count <= 2'b1;
		end else begin
			init_count <= init_count + 2'b1;   
		end
      end
   end
   
always @(state or rden_cnt_dec or eth_speed or ff_afull or sw_reset or init_count)
   begin : process_3
   case (state)
   STM_TYP_IDLE:
      begin
	  if (init_count != 2'b1) 
		 begin
		 nextstate = STM_TYP_IDLE; 
		 end
      else if (ff_afull == 1'b 0 & eth_speed == 2'b 10 & 
      sw_reset == 1'b 0)
         begin
         nextstate = STM_TYP_GIGA_MODE;   
         end
      else if (ff_afull == 1'b 0 & sw_reset == 1'b 0 )
         begin
         nextstate = STM_TYP_FF_WRITE;   
         end
      else
         begin
         nextstate = STM_TYP_IDLE;   
         end
      end
   STM_TYP_GIGA_MODE:
      begin
      if (eth_speed != 2'b 10 | sw_reset == 1'b 1)
         begin
         nextstate = STM_TYP_IDLE;   
         end
      else
         begin
         nextstate = STM_TYP_GIGA_MODE;   
         end
      end
   STM_TYP_FF_WRITE:
      begin
      nextstate = STM_TYP_WAIT_RD;   
      end
   STM_TYP_WAIT_RD:
      begin
      if (eth_speed == 2'b 10 | sw_reset == 1'b 1)
         begin
         nextstate = STM_TYP_IDLE;   
         end
      else if (rden_cnt_dec == 1'b 1 )
         begin
         nextstate = STM_TYP_FF_WRITE;   
         end
      else
         begin
         nextstate = STM_TYP_WAIT_RD;   
         end
      end
   default:
      begin
      nextstate = STM_TYP_IDLE;
      end
   endcase
   end

//  FIFO Read Control
//  -----------------

always @(posedge reset or posedge clk)
   begin : process_4
   if (reset == 1'b 1)
      begin
      wren_cnt <= {7{1'b 0}};   
      end
   else
      begin
      if (eth_speed == 2'b 00)
         begin
         if (wren_cnt == 8'h 63)
            begin
            wren_cnt <= {7{1'b 0}};   
            end
         else
            begin
            wren_cnt <= wren_cnt + 1'b 1;   
            end
         end
      else if (eth_speed == 2'b 01 )
         begin
         if (wren_cnt >= 8'h 09)
            begin
            wren_cnt <= {7{1'b 0}};   
            end
         else
            begin
            wren_cnt <= wren_cnt + 1'b 1;   
            end
         end
      else
         begin
         wren_cnt <= {7{1'b 0}};   
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_5
   if (reset == 1'b 1)
      begin
      rden_cnt_dec <= 1'b 0;   
      end
   else
      begin
      if (eth_speed == 2'b 00)
         begin
         if (wren_cnt == 8'h 62)
            begin
            rden_cnt_dec <= 1'b 1;   
            end
         else
            begin
            rden_cnt_dec <= 1'b 0;   
            end
         end
      else if (eth_speed == 2'b 01 )
         begin
         if (wren_cnt == 4'h 8)
            begin
            rden_cnt_dec <= 1'b 1;   
            end
         else
            begin
            rden_cnt_dec <= 1'b 0;   
            end
         end
      else
         begin
         rden_cnt_dec <= 1'b 0;   
         end
      end
   end

// 1588's ratematch latency handling (deletion)
reg [CNTR_WIDTH-1:0] octet_del_counter; 

always @(posedge reset or posedge clk) begin : process_6
    if (reset == 1'b 1) begin
      ff_wren           <= 1'b 0;   
      rm_cnt            <= 3'd0;
      octet_del_num     <= {RM_DEL_INS_WIDTH{1'b0}};
      octet_del_counter <= {CNTR_WIDTH{1'b0}};
    end
    else begin
        if (state == STM_TYP_GIGA_MODE && ~(ff_afull & !(pcs_dv|pcs_dv_int))) begin
            ff_wren     <= 1'b 1;
            rm_cnt      <= 3'd0;
    
            if (octet_del_counter == {CNTR_WIDTH{1'b0}}) begin
                octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
            end
            else begin
                octet_del_num    <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                octet_del_counter <= octet_del_counter - 11'd1;
            end
        end
        else if (state == STM_TYP_FF_WRITE && ~(ff_afull & !(pcs_dv|pcs_dv_int))) begin
            ff_wren     <= 1'b 1;
            rm_cnt      <= 3'd0;
            
            if (octet_del_counter == {CNTR_WIDTH{1'b0}}) begin
                octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
            end
            else begin
                octet_del_num     <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                octet_del_counter <= octet_del_counter - 11'd1;
            end
        end
        else begin
        
            if (eth_speed == 2'b10)
            begin
                //begin
                ff_wren     <= rm_cnt[2] ^ rm_cnt[1];  
                //ff_wren     <= 1'b0 ;		   
                if (!(rm_cnt[2] & rm_cnt[1])) begin
                rm_cnt <= rm_cnt + 3'd1;
                 end
                else begin
                rm_cnt <= rm_cnt;
                end
            end
            else begin
                ff_wren     <= 1'b0 ;
            end
            
            if (state == STM_TYP_GIGA_MODE || state == STM_TYP_FF_WRITE) begin
                octet_del_counter <= sampling_win_size_wr;
                if (octet_del_counter == {CNTR_WIDTH{1'b0}}) begin
                    octet_del_num <= 3'd1;
                end
                else begin
                    octet_del_num <= octet_del_num + 3'd1;
                end
            end
            else begin
                if (octet_del_counter == {CNTR_WIDTH{1'b0}}) begin
                    octet_del_num   <= {RM_DEL_INS_WIDTH{1'b0}};
                end
                else begin
                    octet_del_num     <= octet_del_num + {RM_DEL_INS_WIDTH{1'b0}};
                    octet_del_counter <= octet_del_counter - 11'd1;
                end
            end
        end
    end
end

//  PCS GMII Data
//  -------------

always @(posedge reset or posedge clk)
   begin : process_7
   if (reset == 1'b 1)
      begin
      ff_data_reg <= {20{1'b 0}};   
      end
   else
      begin
      if (eth_speed ==2'b11)		//sbalasun:temporary for 1G 
          begin
            ff_data_reg[7:0] <= pcs_data[7:0];   
            ff_data_reg[8]   <= pcs_dv[0] | pcs_dv_int[0];   
            ff_data_reg[9]   <= pcs_err[0] | pcs_err_int[0];
          end
      else
          begin				//sbalasun:temporary for 2.5G
            ff_data_reg[15:0]   <= pcs_data;   
            ff_data_reg[17:16]  <= pcs_dv | pcs_dv_int;   
            ff_data_reg[19:18]  <= pcs_err | pcs_err_int;
          end	
      end
   end

// Fogbugz 20407
// Latching for pcs_dv and pcs_err
// during STM_TYP_WAIT_RD and STM_TYP_FF_WRITE
// so that we won't miss any error condition
// during sampling process
always @(posedge reset or posedge clk)
   begin : process_8
   if (reset == 1'b 1)
      begin
      pcs_dv_int  <= 2'b0;
      pcs_err_int <= 2'b0;
      end
   else
      begin
         if (state == STM_TYP_WAIT_RD)
         begin
            if (pcs_dv[0] & pcs_err[0])
            begin
               pcs_dv_int[0]  <= 1'b1;
               pcs_err_int[0] <= 1'b1;
            end
            if (pcs_dv[1] & pcs_err[1])
            begin
               pcs_dv_int[1]  <= 1'b1;
               pcs_err_int[1] <= 1'b1;
            end
         end
         else if (state == STM_TYP_FF_WRITE)
         begin
            if (pcs_dv[0] & pcs_err[0])
            begin
               pcs_dv_int[0]  <= 1'b1;
               pcs_err_int[0] <= 1'b1;
            end
            else
            begin
               pcs_dv_int[0]  <= 1'b0;
               pcs_err_int[0] <= 1'b0;
            end
            if (pcs_dv[1] & pcs_err[1])
            begin
               pcs_dv_int[1]  <= 1'b1;
               pcs_err_int[1] <= 1'b1;
            end
            else
            begin
               pcs_dv_int[1]  <= 1'b0;
               pcs_err_int[1] <= 1'b0;
            end
         end
         else
         begin
            pcs_dv_int  <= 2'b0;
            pcs_err_int <= 2'b0;
         end
      end
   end

endmodule // module rx_converter

