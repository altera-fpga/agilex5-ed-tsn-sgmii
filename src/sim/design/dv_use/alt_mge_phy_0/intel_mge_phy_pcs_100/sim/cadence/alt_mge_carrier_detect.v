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


// (C) 2001-2021 Intel Corporation. All rights reserved.
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
module alt_mge_carrier_detect (
   input          clk,
   input          rst,
   input          sw_reset,
   input          ce,
   input  [9:0]   data_align,
   output reg     carrier
);

reg carrier_wire;
reg carrier_reg;

// Carrier Detection - Code has More than 1 bit difference with K28.5
// ------------------------------------------------------------------
// 
// This is the Table 36.3.2.1 in UNH test plan
// =====================================================
// RD-          code-group     RD+            code-group
// =====================================================
// 001111 1010  /K28.5/        110000 0101    /K28.5/
// 001111 1011  /INVALID/      110000 0100    /INVALID/
// 001111 1000  /K28.7/        110000 0111    /K28.7/
// 001111 1110  /INVALID/      110000 0001    /INVALID/
// 001111 0010  /K28.4/        110000 1101    /K28.4/
// 001110 1010  /D28.5/        110001 0101    /D3.2/
// 001101 1010  /D12.5/        110010 0101    /D19.2/
// 001011 1010  /D20.5/        110100 0101    /D11.2/
// 000111 1010  /D7.5/         111000 0101    /D7.2/
// 011111 1010  /INVALID/      100000 0101    /INVALID/
// 101111 1010  /INVALID/      010000 0101    /INVALID/

always @(data_align)
begin
   case (data_align)
      10'b 1101111100,
      10'b 0001111100,
      10'b 0111111100,
      10'b 0100111100,
      10'b 0101011100,
      10'b 0101101100,
      10'b 0101110100,
      10'b 0101111000,
      10'b 0101111110,
      10'b 0101111101,
      10'b 0101111100,
      10'b 0010000011,
      10'b 1110000011,
      10'b 1000000011,
      10'b 1011000011,
      10'b 1010100011,
      10'b 1010010011,
      10'b 1010001011,
      10'b 1010000111,
      10'b 1010000001,
      10'b 1010000010,
      10'b 1010000011:
         carrier_wire = 1'b0;
      default:
         carrier_wire = 1'b1;
   endcase
end

always @(posedge clk or posedge rst)
   begin
   if (rst == 1'b 1)
      begin
      carrier_reg <= 1'b 1;   
      carrier     <= 1'b 1;   
      end
   else
      begin
      if (sw_reset==1'b1)
         begin
         carrier_reg <= 1'b 1;   
         carrier     <= 1'b 1;
         end
      else if (ce==1'b1)
      begin
            carrier_reg <= carrier_wire;   
            carrier <= carrier_reg; 
         end  
      end
   end
endmodule
