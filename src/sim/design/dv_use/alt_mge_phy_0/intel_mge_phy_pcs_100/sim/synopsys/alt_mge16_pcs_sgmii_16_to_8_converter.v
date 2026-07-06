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
module alt_mge16_pcs_sgmii_16_to_8_converter (

   reset,
   clk,
   tx_ena,
   pcs_data_out,
   pcs_en_out,
   pcs_err_out,
   pcs_data_in,
   pcs_en_in,
   pcs_err_in
);
input clk;
input  reset;
input  tx_ena;
input  [15:0] pcs_data_in;        //  GMII Data to support 1G and 2.5G
input  [1:0] pcs_en_in;           //  GMII Data Valid to support 1G and 2.5G        
input  [1:0] pcs_err_in;          //  GMII Errorto support 1G and 2.5G
output  [15:0] pcs_data_out;        //  GMII Data to support 1G and 2.5G
output  [1:0] pcs_en_out;           //  GMII Data Valid to support 1G and 2.5G        
output  [1:0] pcs_err_out;          //  GMII Errorto support 1G and 2.5G


reg [15:0] pcs_data_in_reg;
reg [1:0] pcs_en_in_reg;
reg [1:0] pcs_err_in_reg;

reg [7:0] pcs_data_in_reg_8h;
reg  pcs_en_in_reg_8h;
reg  pcs_err_in_reg_8h ;
reg [7:0] pcs_data_in_reg_8l;
reg  pcs_en_in_reg_8l;
reg  pcs_err_in_reg_8l;


reg byte_select;
always@(posedge reset or posedge clk)
begin
    if (reset==1'b1)
        byte_select <= 1'b0;       
    else
    begin
        if (pcs_en_in_reg == 2'b00 && (pcs_en_in == 2'b10 || pcs_en_in == 2'b11))         
            byte_select <= 1'b1;      
        else if (tx_ena)
            byte_select <= ~ byte_select;
    end
end

always@(posedge reset or posedge clk)
begin
    if (reset==1'b1)
    begin
        pcs_data_in_reg <= 16'h0;
        pcs_en_in_reg <= 2'b00;
        pcs_err_in_reg <= 2'b00;
    end
    else
    begin
        pcs_data_in_reg <= pcs_data_in;
        pcs_en_in_reg <= pcs_en_in;
        pcs_err_in_reg <= pcs_err_in;
    end        
end
//use byte_select to choose Lower/upper byte from pcs_data_in_reg to downsample the data x5/x50 for 100/10Mbps. etc: 16'h1111 for 5 tx_clk cycles
always@(posedge reset or posedge clk)
begin
    if (reset==1'b1)
    begin
        pcs_data_in_reg_8h <= 8'b0;
        pcs_en_in_reg_8h <=  1'b0;
        pcs_err_in_reg_8h <= 1'b0; 
        pcs_data_in_reg_8l <= 8'b0;
        pcs_en_in_reg_8l <=  1'b0;
        pcs_err_in_reg_8l <= 1'b0;
    end 
    else 
    begin
    if (tx_ena ==1'b1)
        begin
            if (byte_select == 1'b1)
            begin
                pcs_data_in_reg_8h <= pcs_data_in_reg[7:0];
                pcs_en_in_reg_8h <= pcs_en_in_reg[0];
                pcs_err_in_reg_8h <= pcs_err_in_reg[0]; 
                pcs_data_in_reg_8l <= pcs_data_in_reg[7:0];
                pcs_en_in_reg_8l <= pcs_en_in_reg[0];
                pcs_err_in_reg_8l <= pcs_err_in_reg[0];
            end
            else
            begin
                pcs_data_in_reg_8h <= pcs_data_in_reg[15:8];
                pcs_en_in_reg_8h <= pcs_en_in_reg[1];
                pcs_err_in_reg_8h <= pcs_err_in_reg[1];
                pcs_data_in_reg_8l <= pcs_data_in_reg[15:8];
                pcs_en_in_reg_8l <= pcs_en_in_reg[1];
                pcs_err_in_reg_8l <= pcs_err_in_reg[1];
            end
        end
    end
end

assign pcs_data_out = {pcs_data_in_reg_8h , pcs_data_in_reg_8l};
assign pcs_en_out = {pcs_en_in_reg_8h , pcs_en_in_reg_8l};
assign pcs_err_out = {pcs_err_in_reg_8h , pcs_err_in_reg_8l};


endmodule