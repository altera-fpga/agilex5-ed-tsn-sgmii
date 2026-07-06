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


module hps_mge_data_unpacker (
    input                  rx_clk,
    input                  rst_n,
    input   [19:0]         rd_data_pack,
    input                  sel,
    output  reg            rx_buf_rd_en,
    output  reg   [7:0]    mac_rxd,
	 output  reg            mac_rxdv,
    output  reg            mac_rxer
);

reg   [7:0]    mac_rxd_buf1;
reg   [7:0]    mac_rxd_buf2;
reg   [3:0]    mac_rxd_buf3;
reg   [3:0]    mac_rxd_buf4;
reg            mac_rxdv_buf1;
reg            mac_rxdv_buf2;
reg            mac_rxdv_buf3;
reg            mac_rxdv_buf4;
reg            mac_rxer_buf1;
reg            mac_rxer_buf2;
reg            mac_rxer_buf3;
reg            mac_rxer_buf4;

reg   [1:0]    counter;
reg            run;

always @(posedge rx_clk or negedge rst_n) begin
   if (!rst_n) begin
      mac_rxd_buf1   <= 8'b0;
      mac_rxd_buf2   <= 8'b0;
      mac_rxd_buf3   <= 4'b0;
      mac_rxd_buf4   <= 4'b0;
      mac_rxdv_buf1  <= 1'b0;
      mac_rxdv_buf2  <= 1'b0;
      mac_rxdv_buf3  <= 1'b0;
      mac_rxdv_buf4  <= 1'b0;
      mac_rxer_buf1  <= 1'b0;
      mac_rxer_buf2  <= 1'b0;
      mac_rxer_buf3  <= 1'b0;
      mac_rxer_buf4  <= 1'b0;
      
      mac_rxd        <= 8'b0;
      mac_rxdv       <= 1'b0;
      mac_rxer       <= 1'b0;
      
      counter        <= 2'b0;
      run            <= 1'b0;
      rx_buf_rd_en          <= 1'b0;
   end else begin
      if (sel == 1'b0) begin
         if (counter[0] == 2'b1) begin
            mac_rxd_buf1   <= rd_data_pack[7:0];
            mac_rxd_buf2   <= rd_data_pack[15:8];
            mac_rxdv_buf1  <= rd_data_pack[16];
            mac_rxdv_buf2  <= rd_data_pack[17];
            mac_rxer_buf1  <= rd_data_pack[18];
            mac_rxer_buf2  <= rd_data_pack[19];
         end else begin
            mac_rxd_buf1   <= mac_rxd_buf2;
            mac_rxdv_buf1  <= mac_rxdv_buf2;
            mac_rxer_buf1  <= mac_rxer_buf2;
         end
      end else begin
         if (counter == 2'b1) begin
            mac_rxd_buf1   <= {4'b0,rd_data_pack[3:0]};
            mac_rxd_buf2   <= {4'b0,rd_data_pack[7:4]};
            mac_rxd_buf3   <= rd_data_pack[11:8];
            mac_rxd_buf4   <= rd_data_pack[15:12];
            mac_rxdv_buf1  <= rd_data_pack[16];
            mac_rxdv_buf2  <= rd_data_pack[16];
            mac_rxdv_buf3  <= rd_data_pack[17];
            mac_rxdv_buf4  <= rd_data_pack[17];
            mac_rxer_buf1  <= rd_data_pack[18];
            mac_rxer_buf2  <= rd_data_pack[18];
            mac_rxer_buf3  <= rd_data_pack[19];
            mac_rxer_buf4  <= rd_data_pack[19];
         end else begin
            mac_rxd_buf1   <= mac_rxd_buf2;
            mac_rxd_buf2   <= {4'b0,mac_rxd_buf3};
            mac_rxd_buf3   <= mac_rxd_buf4;
            mac_rxdv_buf1  <= mac_rxdv_buf2;
            mac_rxdv_buf2  <= mac_rxdv_buf3;
            mac_rxdv_buf3  <= mac_rxdv_buf4;
            mac_rxer_buf1  <= mac_rxer_buf2;
            mac_rxer_buf2  <= mac_rxer_buf3;
            mac_rxer_buf3  <= mac_rxer_buf4;
         end
      end
      
      mac_rxd  <= mac_rxd_buf1;
      mac_rxdv <= mac_rxdv_buf1;
      mac_rxer <= mac_rxer_buf1;
      
      counter  <= counter + 2'b1;
      
      //safely ignore the first cycle out from reset.
      if (run == 1'b0 && counter >0) begin
         run <= 1'b1;
      end
      
      if (run == 1'b1) begin
         if (sel == 1'b0)
            rx_buf_rd_en <= ~counter[0];
         else
            rx_buf_rd_en <= ~(|counter);
      end
      
   end
end

endmodule