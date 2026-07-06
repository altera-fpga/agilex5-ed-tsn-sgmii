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



`timescale 1ns/1ns

module alt_em10g32_rx_rs_gmii16b (
   // Clock and reset
   input clk,
   input rst_n,

   input csr_rx_tsfr_en_n,

   // GMII 16 bit signals
   input [1:0] gmii16b_rx_dv,    //  GMII Receive Enable
   input [15:0] gmii16b_rx_d,    //  GMII Receive Data
   input [1:0] gmii16b_rx_err,   //  GMII Receive Error
   input rx_clkena,
   
   output reg state_is_idle,
   // Avalon-ST Data path
   output reg rx_ethfrm_sop,
   output reg rx_ethfrm_eop,
   output reg [1:0] rx_ethfrm_empty,
   output reg rx_ethfrm_valid,
   output reg rx_ethfrm_error,
   output reg [31:0] rx_ethfrm_data
);

parameter SYNC_RESET_N                = 1;

localparam SFD = 8'hD5;

localparam STATE_IDLE = 2'd0;
localparam STATE_SOP = 2'd1;
localparam STATE_DATA = 2'd2;
localparam STATE_EOP = 2'd3;

reg [1:0] state;
reg [1:0] next_state;

reg arc_idle_sop;
reg arc_sop_eop;
reg arc_data_eop;

reg data_even;
reg data_select;

reg [1:0] gmii16b_rx_dv_d0;
reg [1:0] gmii16b_rx_dv_d1;
reg [1:0] gmii16b_rx_dv_d2;
reg [1:0] gmii16b_rx_dv_d3;

reg [1:0] gmii16b_rx_err_d0;
reg [1:0] gmii16b_rx_err_d1;
reg [1:0] gmii16b_rx_err_d2;
reg [1:0] gmii16b_rx_err_d3;

reg [15:0] gmii16b_rx_d_d0;
reg [15:0] gmii16b_rx_d_d1;
reg [15:0] gmii16b_rx_d_d2;
reg [15:0] gmii16b_rx_d_d3;

generate if (SYNC_RESET_N == 1) begin
always @(posedge clk)
begin
   if (~rst_n)
   begin
      gmii16b_rx_dv_d0 <= 2'b0;
      gmii16b_rx_dv_d1 <= 2'b0;
      gmii16b_rx_dv_d2 <= 2'b0;
      gmii16b_rx_dv_d3 <= 2'b0;

      gmii16b_rx_err_d0 <= 2'b0;
      gmii16b_rx_err_d1 <= 2'b0;
      gmii16b_rx_err_d2 <= 2'b0;
      gmii16b_rx_err_d3 <= 2'b0;

      gmii16b_rx_d_d0 <= 16'b0;
      gmii16b_rx_d_d1 <= 16'b0;
      gmii16b_rx_d_d2 <= 16'b0;
      gmii16b_rx_d_d3 <= 16'b0;
   end
   else
   begin
     if (rx_clkena)
	  begin
      gmii16b_rx_dv_d0 <= gmii16b_rx_dv;
      gmii16b_rx_dv_d1 <= gmii16b_rx_dv_d0;
      gmii16b_rx_dv_d2 <= gmii16b_rx_dv_d1;
      gmii16b_rx_dv_d3 <= gmii16b_rx_dv_d2;

      gmii16b_rx_err_d0 <= gmii16b_rx_err;
      gmii16b_rx_err_d1 <= gmii16b_rx_err_d0;
      gmii16b_rx_err_d2 <= gmii16b_rx_err_d1;
      gmii16b_rx_err_d3 <= gmii16b_rx_err_d2;

      gmii16b_rx_d_d0 <= gmii16b_rx_d;
      gmii16b_rx_d_d1 <= gmii16b_rx_d_d0;
      gmii16b_rx_d_d2 <= gmii16b_rx_d_d1;
      gmii16b_rx_d_d3 <= gmii16b_rx_d_d2;
      end
   end 
end
end else begin
always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      gmii16b_rx_dv_d0 <= 2'b0;
      gmii16b_rx_dv_d1 <= 2'b0;
      gmii16b_rx_dv_d2 <= 2'b0;
      gmii16b_rx_dv_d3 <= 2'b0;

      gmii16b_rx_err_d0 <= 2'b0;
      gmii16b_rx_err_d1 <= 2'b0;
      gmii16b_rx_err_d2 <= 2'b0;
      gmii16b_rx_err_d3 <= 2'b0;

      gmii16b_rx_d_d0 <= 16'b0;
      gmii16b_rx_d_d1 <= 16'b0;
      gmii16b_rx_d_d2 <= 16'b0;
      gmii16b_rx_d_d3 <= 16'b0;
   end
   else
   begin
     if (rx_clkena)
	  begin
      gmii16b_rx_dv_d0 <= gmii16b_rx_dv;
      gmii16b_rx_dv_d1 <= gmii16b_rx_dv_d0;
      gmii16b_rx_dv_d2 <= gmii16b_rx_dv_d1;
      gmii16b_rx_dv_d3 <= gmii16b_rx_dv_d2;

      gmii16b_rx_err_d0 <= gmii16b_rx_err;
      gmii16b_rx_err_d1 <= gmii16b_rx_err_d0;
      gmii16b_rx_err_d2 <= gmii16b_rx_err_d1;
      gmii16b_rx_err_d3 <= gmii16b_rx_err_d2;

      gmii16b_rx_d_d0 <= gmii16b_rx_d;
      gmii16b_rx_d_d1 <= gmii16b_rx_d_d0;
      gmii16b_rx_d_d2 <= gmii16b_rx_d_d1;
      gmii16b_rx_d_d3 <= gmii16b_rx_d_d2;
      end
   end 
end
end
endgenerate

reg [5:0] count_sfd_check ;
wire [4:0] count_sfd_check_calc ;
reg [1:0] next_state_sfd ;
reg sfd_en ;
wire [1:0] gmii16b_rx_dv_d1_ris ;


assign gmii16b_rx_dv_d1_ris = gmii16b_rx_dv_d1 & (~ gmii16b_rx_dv_d2) ;
assign count_sfd_check_calc = count_sfd_check[4:0] ;

generate if (SYNC_RESET_N == 1) begin 

always @(posedge clk)
begin
	if (~rst_n)
	begin
		count_sfd_check  <= 6'h0;
		sfd_en	   	 <= 1'b0 ;
		next_state_sfd	 <= 2'h0 ; 
	end 
	else if (rx_clkena)  
	begin 
		case(next_state_sfd) 
		2'b0 : begin  
			if(gmii16b_rx_dv_d1_ris[0] == 1'b1 && gmii16b_rx_dv_d1_ris[1] == 1'b1) begin
				count_sfd_check	<=	count_sfd_check_calc + 2 ;
				next_state_sfd	<=	2'h1 ;
				sfd_en	<= 1'b0;
			end 
			else if (gmii16b_rx_dv_d1_ris[0] == 1'b0 && gmii16b_rx_dv_d1_ris[1] == 1'b1) begin 
				count_sfd_check	 <= count_sfd_check_calc + 1  ;
				next_state_sfd   <= 2'h1 ;
				sfd_en	<= 1'b0;
			end	
			else begin 
				count_sfd_check	<= 6'h0 ;
				next_state_sfd   <= 2'h0 ;
				sfd_en	<= 1'b0;
			end 
		end 
		2'b1 : begin 
			if(gmii16b_rx_dv_d1[1] == 1'b1 && gmii16b_rx_dv_d1[0] == 1'b1) begin 
				if(count_sfd_check < 6'h5) begin 
					count_sfd_check	<= count_sfd_check_calc + 2 ;
					next_state_sfd  <= 2'h1 ;
					sfd_en	<= 1'b0;
				end 
				else if (count_sfd_check == 6'h6) begin 
					count_sfd_check <= 6'h0 ;
					next_state_sfd <= 2'h0 ;
					if ( gmii16b_rx_d_d1[15:8] == SFD || gmii16b_rx_d_d1[7:0] == SFD ) 
						sfd_en <= 1'b1; 
					else 
						sfd_en	<= 1'b0;
				end 
				else if (count_sfd_check == 6'h5) begin 
					if ( gmii16b_rx_d_d1[15:8] == SFD ) begin 
						sfd_en <= 1'b1;
						next_state_sfd <= 2'h0 ;
						count_sfd_check <= 6'h0 ;
					end 
					else begin
						sfd_en	<= 1'b0;
						next_state_sfd <= 2'h1 ;
						count_sfd_check <= count_sfd_check_calc + 2 ;
					end
				end		
				else begin 
					count_sfd_check <= 6'h0 ;
					next_state_sfd <= 2'h0 ;
					if ( gmii16b_rx_d_d1[7:0] == SFD) 
						sfd_en <= 1'b1; 
					else 
						sfd_en	<= 1'b0;
				end
			end 
			else begin 
				count_sfd_check <= 6'h0 ;
				next_state_sfd   <= 2'h0 ;
				sfd_en	<= 1'b0;
	
			end
		end
		default : begin 
				sfd_en	<=  1'b0;
				count_sfd_check <= 6'h0 ;
				next_state_sfd <= 2'h0 ;
		end 
		endcase 
	end 
end 
end else begin
always @(posedge clk or negedge rst_n)
begin
	if (~rst_n)
	begin
		count_sfd_check  	 <= 6'h0;
		sfd_en		   	 <= 1'b0 ;
		next_state_sfd	   	 <= 2'h0 ; 
	end 
	else if (rx_clkena)  
	begin 
		case(next_state_sfd) 
		2'b0 : begin  
			if(gmii16b_rx_dv_d1_ris[0] == 1'b1 && gmii16b_rx_dv_d1_ris[1] == 1'b1) begin
				count_sfd_check	<=	count_sfd_check_calc + 2;
				next_state_sfd	<=	2'h1 ;
				sfd_en		<=	1'b0 ;
			end 
			else if (gmii16b_rx_dv_d1_ris[0] == 1'b0 && gmii16b_rx_dv_d1_ris[1] == 1'b1) begin 
				count_sfd_check	 <= count_sfd_check_calc + 1  ;
				next_state_sfd   <= 2'h1 ;
				sfd_en		 <= 1'b0;
			end	
			else begin 
				count_sfd_check	<= 6'h0 ;
				next_state_sfd   <= 2'h0 ;
				sfd_en		<= 1'b0 ;
			end 
		end 
		2'b1 : begin 
			if(gmii16b_rx_dv_d1[1] == 1'b1 && gmii16b_rx_dv_d1[0] == 1'b1) begin 
				if(count_sfd_check < 6'h5) begin 
					count_sfd_check	<= count_sfd_check_calc + 2 ;
						next_state_sfd <= 2'h1 ;
						sfd_en <= 1'b0 ;
				end 
				else if (count_sfd_check == 6'h6) begin 
					count_sfd_check <= 6'h0 ;
					next_state_sfd <= 2'h0 ;
					if ( gmii16b_rx_d_d1[15:8] == SFD || gmii16b_rx_d_d1[7:0] == SFD) 
						sfd_en <= 1'b1; 
					else 
						sfd_en	<= 1'b0;
				end
				else if (count_sfd_check == 6'h5) begin 
					if ( gmii16b_rx_d_d1[15:8] == SFD ) begin 
						sfd_en <= 1'b1;
						next_state_sfd <= 2'h0 ;
						count_sfd_check <= 6'h0 ;
					end 
					else begin
						sfd_en	<= 1'b0;
						next_state_sfd <= 2'h1 ;
						count_sfd_check <= count_sfd_check_calc + 2 ;
					end
				end		
				else begin 
					count_sfd_check <= 6'h0 ;
					next_state_sfd <= 2'h0 ;
					if ( gmii16b_rx_d_d1[7:0] == SFD) 
						sfd_en <= 1'b1; 
					else 
						sfd_en	<= 1'b0;
				end
			end 
			else begin 
				count_sfd_check <= 6'h0 ;
				next_state_sfd   <= 2'h0 ;
				sfd_en	<= 1'b0;
			end
		end 
		default : begin 
			sfd_en	<=  1'b0;
			count_sfd_check <= 6'h0 ;
			next_state_sfd <= 2'h0 ;
		end 
		endcase 
	end 
end 
end 
endgenerate 

generate if (SYNC_RESET_N == 1) begin
always @(posedge clk)
begin
   if (~rst_n)
   begin
      rx_ethfrm_data <= 32'b0;
      rx_ethfrm_valid <= 1'b0;
      rx_ethfrm_error <= 1'b0;
   end
   else
   begin
    if (rx_clkena)
    begin
      if (state == STATE_IDLE)
      begin
         rx_ethfrm_data <= 32'b0;
         rx_ethfrm_valid <= 1'b0;
         rx_ethfrm_error <= 1'b0;
      end
      else
      begin
	 
         rx_ethfrm_valid <= data_even;

         if (data_even)
         begin
            if (data_select)
            begin
               rx_ethfrm_data <= {gmii16b_rx_d_d3 [15:8], gmii16b_rx_d_d2[7:0], gmii16b_rx_d_d2[15:8], gmii16b_rx_d_d1[7:0]};
               rx_ethfrm_error <= |({gmii16b_rx_dv_d1[0], gmii16b_rx_dv_d2, gmii16b_rx_dv_d3 [1]} & {gmii16b_rx_err_d1[0], gmii16b_rx_err_d2, gmii16b_rx_err_d3[1]});
            end
            else
            begin
               rx_ethfrm_data <= {gmii16b_rx_d_d2[7:0], gmii16b_rx_d_d2[15:8], gmii16b_rx_d_d1[7:0], gmii16b_rx_d_d1[15:8]};
               rx_ethfrm_error <= |( {gmii16b_rx_dv_d1, gmii16b_rx_dv_d2} & {gmii16b_rx_err_d1, gmii16b_rx_err_d2});
            end
         end
      end
   end
end
end 
end else begin
always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      rx_ethfrm_data <= 32'b0;
      rx_ethfrm_valid <= 1'b0;
      rx_ethfrm_error <= 1'b0;
   end
   else
   begin
    if (rx_clkena)
    begin
      if (state == STATE_IDLE)
      begin
         rx_ethfrm_data <= 32'b0;
         rx_ethfrm_valid <= 1'b0;
         rx_ethfrm_error <= 1'b0;
      end
      else
      begin
	 
         rx_ethfrm_valid <= data_even;

         if (data_even)
         begin
            if (data_select)
            begin
               rx_ethfrm_data <= {gmii16b_rx_d_d3 [15:8], gmii16b_rx_d_d2[7:0], gmii16b_rx_d_d2[15:8], gmii16b_rx_d_d1[7:0]};
               rx_ethfrm_error <= |({gmii16b_rx_dv_d1[0], gmii16b_rx_dv_d2, gmii16b_rx_dv_d3 [1]} & {gmii16b_rx_err_d1[0], gmii16b_rx_err_d2, gmii16b_rx_err_d3[1]});
            end
            else
            begin
               rx_ethfrm_data <= {gmii16b_rx_d_d2[7:0], gmii16b_rx_d_d2[15:8], gmii16b_rx_d_d1[7:0], gmii16b_rx_d_d1[15:8]};
               rx_ethfrm_error <= |( {gmii16b_rx_dv_d1, gmii16b_rx_dv_d2} & {gmii16b_rx_err_d1, gmii16b_rx_err_d2});
            end
         end
      end
   end
end
end 
end
endgenerate
generate if (SYNC_RESET_N == 1) begin
always @(posedge clk)
begin
   if (~rst_n)
   begin
      rx_ethfrm_sop <= 1'b0;
   end
   else
   begin 
    if (rx_clkena)
    begin
      if (state == STATE_SOP && data_even == 1'b1)
         rx_ethfrm_sop <= 1'b1;
      else
         rx_ethfrm_sop <= 1'b0;
    end
   end 
end

always @(posedge clk)
begin
   if (~rst_n)
   begin
      rx_ethfrm_eop <= 1'b0;
   end
   else
   begin
    if (rx_clkena)
    begin
      if (state == STATE_EOP && data_even == 1'b1)
         rx_ethfrm_eop <= 1'b1;
      else
         rx_ethfrm_eop <= 1'b0;
    end
   end 
end

always @(posedge clk)
begin
   if (~rst_n)
   begin
      rx_ethfrm_empty <= 2'b0;
   end
   else
   begin
     if (rx_clkena)
     begin
      if (state == STATE_EOP && data_even == 1'b1)
         if (data_select)
         begin
            if (~gmii16b_rx_dv_d2[0])
               rx_ethfrm_empty <= 2'd3;
            else if (~gmii16b_rx_dv_d2[1])
               rx_ethfrm_empty <= 2'd2;
            else if (~gmii16b_rx_dv_d1[0])
               rx_ethfrm_empty <= 2'd1;
            else
               rx_ethfrm_empty <= 2'd0;
         end
         else
         begin
            if (~gmii16b_rx_dv_d2[1])
               rx_ethfrm_empty <= 2'd3;
            else if (~gmii16b_rx_dv_d1[0])
               rx_ethfrm_empty <= 2'd2;
            else if (~gmii16b_rx_dv_d1[1])
               rx_ethfrm_empty <= 2'd1;
            else
               rx_ethfrm_empty <= 2'd0;

         end
      else
         rx_ethfrm_empty <= 2'b0;
     end
   end 
end

always @(posedge clk)
begin
   if (~rst_n)
   begin
      data_even <= 1'b0;
   end
   else
   begin 
     if (rx_clkena)
	 begin
      if (arc_idle_sop)
         data_even <= 1'b1;
      else
         data_even <= ~data_even;
     end
   end 
end
end else begin
always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      rx_ethfrm_sop <= 1'b0;
   end
   else
   begin 
    if (rx_clkena)
    begin
      if (state == STATE_SOP && data_even == 1'b1)
         rx_ethfrm_sop <= 1'b1;
      else
         rx_ethfrm_sop <= 1'b0;
    end
   end 
end

always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      rx_ethfrm_eop <= 1'b0;
   end
   else
   begin
    if (rx_clkena)
    begin
      if (state == STATE_EOP && data_even == 1'b1)
         rx_ethfrm_eop <= 1'b1;
      else
         rx_ethfrm_eop <= 1'b0;
    end
   end 
end

always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      rx_ethfrm_empty <= 2'b0;
   end
   else
   begin
     if (rx_clkena)
     begin
      if (state == STATE_EOP && data_even == 1'b1)
         if (data_select)
         begin
            if (~gmii16b_rx_dv_d2[0])
               rx_ethfrm_empty <= 2'd3;
            else if (~gmii16b_rx_dv_d2[1])
               rx_ethfrm_empty <= 2'd2;
            else if (~gmii16b_rx_dv_d1[0])
               rx_ethfrm_empty <= 2'd1;
            else
               rx_ethfrm_empty <= 2'd0;
         end
         else
         begin
            if (~gmii16b_rx_dv_d2[1])
               rx_ethfrm_empty <= 2'd3;
            else if (~gmii16b_rx_dv_d1[0])
               rx_ethfrm_empty <= 2'd2;
            else if (~gmii16b_rx_dv_d1[1])
               rx_ethfrm_empty <= 2'd1;
            else
               rx_ethfrm_empty <= 2'd0;

         end
      else
         rx_ethfrm_empty <= 2'b0;
     end
   end 
end

always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      data_even <= 1'b0;
   end
   else
   begin 
     if (rx_clkena)
	 begin
      if (arc_idle_sop)
         data_even <= 1'b1;
      else
         data_even <= ~data_even;
     end
   end 
end

end
endgenerate

always @(*)
begin
   if (state == STATE_IDLE)
   begin
      if (
         // SFD found and follow by 5 contigous valid bytes
         (gmii16b_rx_dv_d2[0] == 1'b1 && gmii16b_rx_d_d2[7:0] == SFD && gmii16b_rx_dv_d2[1] == 1'b1 && gmii16b_rx_dv_d1 == 2'b11 && gmii16b_rx_dv_d0 == 2'b11 && sfd_en == 1'b1) || 
         (gmii16b_rx_dv_d2[1] == 1'b1 && gmii16b_rx_d_d2[15:8] == SFD && gmii16b_rx_dv_d1 == 2'b11 && gmii16b_rx_dv_d0 == 2'b11 && gmii16b_rx_dv [0] == 1'b1 && sfd_en == 1'b1)
      )
      begin
         arc_idle_sop = 1'b1;
      end
      else
      begin
         arc_idle_sop = 1'b0;
      end
   end
   else
      arc_idle_sop = 1'b0;
end

always @(*)
begin
   if (state == STATE_IDLE)
      state_is_idle = 1'b1;
   else
      state_is_idle = 1'b0;
end

always @(*)
begin
   if (state == STATE_SOP && data_even == 1'b0)
   begin
      if (data_select == 1'b1 && (gmii16b_rx_dv_d1 != 2'b11 || gmii16b_rx_dv_d0 != 2'b11))
         arc_sop_eop = 1'b1;
      else if (data_select == 1'b0 && (gmii16b_rx_dv_d1[1] != 1'b1 || gmii16b_rx_dv_d0 != 2'b11 || gmii16b_rx_dv[0] != 1'b1))
         arc_sop_eop = 1'b1;
      else
         arc_sop_eop = 1'b0;
   end
   else
   begin
      arc_sop_eop = 1'b0;
   end
end

always @(*)
begin
   if (state == STATE_DATA && data_even == 1'b0)
   begin
      if (data_select == 1'b1 && (gmii16b_rx_dv_d1 != 2'b11 || gmii16b_rx_dv_d0 != 2'b11))
         arc_data_eop = 1'b1;
      else if (data_select == 1'b0 && (gmii16b_rx_dv_d1[1] != 1'b1 || gmii16b_rx_dv_d0 != 2'b11 || gmii16b_rx_dv[0] != 1'b1))
         arc_data_eop = 1'b1;
      else
         arc_data_eop = 1'b0;
   end
   else
   begin
      arc_data_eop = 1'b0;
   end
end

generate if (SYNC_RESET_N == 1) begin
  always @(posedge clk)
  begin
     if (~rst_n)
     begin
        data_select <= 1'b0;
     end
     else
     begin
        // Latch location of the SFD
        if (arc_idle_sop == 1'b1)
        begin
           if ((gmii16b_rx_dv_d2[0] == 1'b1 && gmii16b_rx_d_d2[7:0] == SFD))
              data_select <= 1'b1;
           else
              data_select <= 1'b0;
        end
     end
  end
  
  always @(posedge clk)
  begin
     if (~rst_n)
     begin
        state <= STATE_IDLE;
     end
     else
     begin
      if (rx_clkena)
      begin
        state <= next_state;
      end
     end 
  end
end else begin
  always @(posedge clk or negedge rst_n)
  begin
     if (~rst_n)
     begin
        data_select <= 1'b0;
     end
     else
     begin
        // Latch location of the SFD
        if (arc_idle_sop == 1'b1)
        begin
           if ((gmii16b_rx_dv_d2[0] == 1'b1 && gmii16b_rx_d_d2[7:0] == SFD))
              data_select <= 1'b1;
           else
              data_select <= 1'b0;
        end
     end
  end
  
  always @(posedge clk or negedge rst_n)
  begin
     if (~rst_n)
     begin
        state <= STATE_IDLE;
     end
     else
     begin
      if (rx_clkena)
      begin
        state <= next_state;
      end
     end 
  end
end
endgenerate

always @(*)
begin
   case (state)
      STATE_IDLE:
      begin
         if (~csr_rx_tsfr_en_n && (arc_idle_sop == 1'b1))
            next_state = STATE_SOP;
         else
            next_state = STATE_IDLE;
      end
      STATE_SOP:
      begin
         if (data_even == 1'b0)
         begin
            if (arc_sop_eop == 1'b1)
               next_state = STATE_EOP;
            else
               next_state = STATE_DATA;
         end
         else
         begin
            next_state = STATE_SOP;
         end
      end
      STATE_DATA:
      begin
         if (data_even == 1'b0)
         begin
            if (arc_data_eop == 1'b1)
               next_state = STATE_EOP;
            else
               next_state = STATE_DATA;
         end
         else
         begin
            next_state = STATE_DATA;
         end
      end
      STATE_EOP:
      begin
         if (data_even == 1'b0)
            next_state = STATE_IDLE;
         else
            next_state = STATE_EOP;
      end
      default:
      begin
         next_state = STATE_IDLE;
      end
   endcase
end

endmodule
