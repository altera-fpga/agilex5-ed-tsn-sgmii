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


module hps_mge_data_packer (
    input                  tx_clk,
    input                  rst_n,
    input   [7:0]          mac_txd,
    input                  mac_txen,
    input                  mac_txer,
    input                  sel,
    output  reg   [19:0]   wr_data_pack,
	 output  reg            wr_en_pack
);


reg   [7:0]    mac_txd_d1;
reg   [3:0]    mac_txd_d2;
reg   [3:0]    mac_txd_d3;
reg   [3:0]    mac_txd_d4;
reg            mac_txen_d1;
reg            mac_txen_d2;
reg            mac_txen_d3;
reg            mac_txen_d4;
reg            mac_txer_d1;
reg            mac_txer_d2;
reg            mac_txer_d3;
reg            mac_txer_d4;
wire           mac_txen_combine1_even;
wire           mac_txen_combine2_even;
wire           mac_txer_combine1_even;
wire           mac_txer_combine2_even;
wire           mac_txen_combine1_odd;
wire           mac_txen_combine2_odd;
wire           mac_txer_combine1_odd;
wire           mac_txer_combine2_odd;

reg            run;
reg            is_even;

reg   [1:0]    counter;
reg   [19:0]   wr_data_pack_even;
reg   [19:0]   wr_data_pack_odd;

assign mac_txen_combine1_even = mac_txen_d1 | mac_txen;
assign mac_txen_combine2_even = mac_txen_d3 | mac_txen_d2;
assign mac_txer_combine1_even = (mac_txen_d1 | mac_txen) ? mac_txer_d1 | mac_txer : 1'b0;
assign mac_txer_combine2_even = (mac_txen_d3 | mac_txen_d2) ? mac_txer_d3 | mac_txer_d2 : 1'b0;

assign mac_txen_combine1_odd = mac_txen_d2 | mac_txen_d1;
assign mac_txen_combine2_odd = mac_txen_d4 | mac_txen_d3;
assign mac_txer_combine1_odd = (mac_txen_d2 | mac_txen_d1) ? mac_txer_d2 | mac_txer_d1 : 1'b0;
assign mac_txer_combine2_odd = (mac_txen_d4 | mac_txen_d3) ? mac_txer_d4 | mac_txer_d3 : 1'b0;
    
always @(posedge tx_clk or negedge rst_n) begin
   if (!rst_n) begin
      wr_data_pack   <= 20'd0;
      wr_data_pack_even   <= 20'd0;
      wr_data_pack_odd    <= 20'd0;
      wr_en_pack     <= 1'b0;
      counter        <= 2'b0;
      run            <= 1'b0;
      is_even        <= 1'b0;
      
      mac_txd_d1     <= 8'h0;
      mac_txd_d2     <= 4'h0;
      mac_txd_d3     <= 4'h0;
      mac_txd_d4     <= 4'h0;
         
      mac_txen_d1    <= 1'b0;
      mac_txen_d2    <= 1'b0;
      mac_txen_d3    <= 1'b0;
      mac_txen_d4    <= 1'b0;
         
      mac_txer_d1    <= 1'b0;
      mac_txer_d2    <= 1'b0;
      mac_txer_d3    <= 1'b0;
      mac_txer_d4    <= 1'b0;
   end 
   else begin
      counter  <= counter + 2'b1;
         
      if (run == 1'b0) begin
         if (mac_txen) begin
            run <= 1'b1;
            is_even <= counter[0];
         end
      end else begin
         if (sel == 1'b1 && mac_txen == 1'b0 && wr_data_pack[17:16] == 2'b00)
            run <= 1'b0;
      end
         
      mac_txd_d1  <= mac_txd;
      mac_txd_d2  <= mac_txd_d1[3:0];
      mac_txd_d3  <= mac_txd_d2;
      mac_txd_d4  <= mac_txd_d3;
      
      mac_txen_d1 <= mac_txen;
      mac_txen_d2 <= mac_txen_d1;
      mac_txen_d3 <= mac_txen_d2;
      mac_txen_d4 <= mac_txen_d3;
      
      mac_txer_d1 <= mac_txer;
      mac_txer_d2 <= mac_txer_d1;
      mac_txer_d3 <= mac_txer_d2;
      mac_txer_d4 <= mac_txer_d3;
      
      if (sel == 1'b0) begin
         //GMII
         wr_data_pack   <= {mac_txer,mac_txer_d1,mac_txen,mac_txen_d1,mac_txd[7:0], mac_txd_d1[7:0]};
         wr_en_pack     <= counter[0];
      end else begin
         //MII
         wr_data_pack_even   <= {mac_txer_combine1_even, mac_txer_combine2_even, mac_txen_combine1_even, mac_txen_combine2_even, mac_txd[3:0], mac_txd_d1[3:0], mac_txd_d2[3:0], mac_txd_d3[3:0]};
         wr_data_pack_odd    <= {mac_txer_combine1_odd, mac_txer_combine2_odd, mac_txen_combine1_odd, mac_txen_combine2_odd, mac_txd_d1[3:0], mac_txd_d2[3:0], mac_txd_d3[3:0], mac_txd_d4[3:0]};

         if (is_even == 1'b1)
            wr_data_pack   <= wr_data_pack_even;
         else
            wr_data_pack   <= wr_data_pack_odd;
            
         if (counter == 2'h3)
            wr_en_pack  <= 1'b1;
         else
            wr_en_pack  <= 1'b0;
      end
   end
end

endmodule