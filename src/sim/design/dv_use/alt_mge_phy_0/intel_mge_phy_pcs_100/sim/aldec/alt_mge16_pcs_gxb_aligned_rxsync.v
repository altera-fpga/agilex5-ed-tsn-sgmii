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
// RX_SYNC alignment for Alt2gxb, Alt4gxb
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_gxb_aligned_rxsync (

  input clk,
  input reset,

  input [15:0] alt_dataout,
  input [1:0] alt_sync,
  input [1:0] alt_disperr,
  input [1:0] alt_ctrldetect,
  input [1:0] alt_errdetect,
  input alt_runlengthviolation,
  input [1:0] alt_patterndetect,
  input [1:0] alt_runningdisp,

  output reg [15:0] altpcs_dataout,
  output reg [1:0] altpcs_sync,
  output reg [1:0] altpcs_disperr,
  output reg [1:0] altpcs_ctrldetect,
  output reg [1:0] altpcs_errdetect,
  output reg [1:0] altpcs_carrierdetect) ;

  //-------------------------------------------------------------------------------
  // intermediate wires


  //reg altpcs_dataout

  // pipelined 1
  reg [15:0] alt_dataout_reg1;
  reg [1:0] alt_sync_reg1;
  reg [1:0] alt_sync_reg2;
  reg [1:0] alt_disperr_reg1;
  reg [1:0] alt_ctrldetect_reg1;
  reg [1:0] alt_errdetect_reg1;
  reg [1:0] alt_patterndetect_reg1;
  reg [1:0] alt_runningdisp_reg1;
  reg alt_runlengthviolation_latched;
  //-------------------------------------------------------------------------------


  always @(posedge reset or posedge clk)
    begin
        if (reset == 1'b1)
            begin
                // pipelined 1
                alt_dataout_reg1            <= 16'h0000;
                alt_sync_reg1               <= 2'b00;
                alt_disperr_reg1            <= 2'b00;
                alt_ctrldetect_reg1         <= 2'b00;
                alt_errdetect_reg1          <= 2'b00;
                alt_patterndetect_reg1      <= 2'b00;
                alt_runningdisp_reg1        <= 2'b00;
                
                altpcs_sync                 <= 2'b00;
            end
        else
            begin
                // pipelined 1
                alt_dataout_reg1            <= alt_dataout;
                alt_sync_reg1               <= alt_sync;
                alt_disperr_reg1            <= alt_disperr;
                alt_ctrldetect_reg1         <= alt_ctrldetect;
                alt_errdetect_reg1          <= alt_errdetect;
                alt_patterndetect_reg1      <= alt_patterndetect;
                alt_runningdisp_reg1        <= alt_runningdisp;
                
                altpcs_sync                 <= {2{&alt_sync}};
            end
    
    end 
	
		always @ (posedge reset or posedge clk)
		begin
		 if (reset == 1'b1)
			begin
				altpcs_dataout              <= 16'h0000;
				altpcs_disperr              <= 2'b11;
				altpcs_ctrldetect           <= 2'b00;
				altpcs_errdetect            <= 2'b11;
			end
		 else
			begin
			   if (alt_sync == 2'b11 )
				 begin      
					altpcs_dataout              <= alt_dataout_reg1;
					altpcs_disperr              <= alt_disperr_reg1;
					altpcs_ctrldetect           <= alt_ctrldetect_reg1;
					altpcs_errdetect            <= alt_errdetect_reg1;
				 end
			   else
				 begin
					altpcs_dataout              <= 16'h0000;
					altpcs_disperr              <= 2'b01;
					altpcs_ctrldetect           <= 2'b00;
					altpcs_errdetect            <= 2'b11;
				 end
			end
		end




      
   //latched runlength violation assertion for "carrier_detect" signal generation block
   //reset the latch value after carrier_detect goes de-asserted
//   always @ (altpcs_carrierdetect or alt_runlengthviolation or alt_sync_reg1)
//    begin
//       if (altpcs_carrierdetect == 1'b0)
//        begin
//           alt_runlengthviolation_latched <= 1'b0;
//        end 
//       else
//        begin 
//           if (alt_runlengthviolation == 1'b1 & alt_sync_reg1 == 1'b1)
//            begin
//               alt_runlengthviolation_latched <= 1'b1;
//            end
//        end       
//    end
  

//    always @ (posedge reset or posedge clk)
//     begin
//      if (reset == 1'b1)
//         begin
//             alt_runlengthviolation_latched_reg <= 1'b0;
//         end
//      else
//         begin
//             alt_runlengthviolation_latched_reg <= alt_runlengthviolation_latched;
//         end
//     end

    always @ (posedge reset or posedge clk)
     begin
      if (reset == 1'b1)
         begin
             alt_runlengthviolation_latched <= 1'b0;
         end
      else
       begin
           if ((altpcs_carrierdetect != 2'b11) | (alt_sync == 2'b00 ))
            begin
               alt_runlengthviolation_latched <= 1'b0;
            end 
           else
            begin 
               if ((alt_runlengthviolation == 1'b1) & (alt_sync[0] == 1'b1 | alt_sync[1] == 1'b1))
                begin
                   alt_runlengthviolation_latched <= 1'b1;
                end
            end       
       end
     end


   // carrier_detect signal generation
   always @ (posedge reset or posedge clk)
    begin
     if (reset == 1'b1)
        begin
            altpcs_carrierdetect <= 2'b11;
        end
     else
        begin
           if (  (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'h1C & alt_ctrldetect_reg1[0] == 1'b1 & alt_errdetect_reg1[0] == 1'b1  
                    & alt_disperr_reg1[0] ==1'b1 & alt_patterndetect_reg1[0] == 1'b1 & alt_runlengthviolation_latched == 1'b0                 ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'hFC & alt_ctrldetect_reg1[0] == 1'b1 & alt_patterndetect_reg1[0] == 1'b1      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'h9C & alt_ctrldetect_reg1[0] == 1'b1 & alt_patterndetect_reg1[0] == 1'b0      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'hBC & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'hAC & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'hB4 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'hA7 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0 
                    & alt_runningdisp_reg1[0] == 1'b1                                                                                      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'hA1 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0 
                    & alt_runningdisp_reg1[0] == 1'b1 & alt_runlengthviolation_latched == 1'b1                                             ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'hA2 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0 
                   & alt_runningdisp_reg1[0] == 1'b1  
                   & ((alt_runningdisp[0] == 1'b1 & alt_errdetect_reg1[0] == 1'b1 & alt_disperr_reg1[0] == 1'b1)|                                                                                
                      (alt_runningdisp[0] == 1'b0 & alt_errdetect_reg1[0] == 1'b1 & alt_disperr_reg1[0] == 1'b0 ))                               ) |

                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'h43 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'h53 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'h4B & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0      ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'h47 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0
                   & alt_runningdisp_reg1[0] == 1'b0                                                                                       ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'h41 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0
                   & alt_runningdisp_reg1[0] == 1'b0 & alt_runlengthviolation_latched == 1'b1 
                   & ((alt_runningdisp[0] == 1'b1 & alt_errdetect_reg1[0] == 1'b1 & alt_disperr_reg1[0] == 1'b0)|                                                                                
                      (alt_runningdisp[0] == 1'b0 & alt_errdetect_reg1[0] == 1'b1 & alt_disperr_reg1[0] == 1'b1 ))                               ) |
                 (alt_sync_reg1[0] == 1'b1 & alt_dataout_reg1[7:0] == 8'h42 & alt_ctrldetect_reg1[0] == 1'b0 & alt_patterndetect_reg1[0] == 1'b0
                   & alt_runningdisp_reg1[0] == 1'b0 & ((alt_runningdisp[0] == 1'b1 & alt_errdetect_reg1[0] == 1'b1 & alt_disperr_reg1[0] == 1'b0)|
                                                     (alt_runningdisp[0] == 1'b0 & alt_errdetect_reg1[0] == 1'b1 & alt_disperr_reg1[0] == 1'b1)) )  
              )

             begin      
                altpcs_carrierdetect[0]           <= 1'b0;
             end
           else
             begin
                altpcs_carrierdetect[0]           <= 1'b1;
             end
           
           if (  (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'h1C & alt_ctrldetect_reg1[1] == 1'b1 & alt_errdetect_reg1[1] == 1'b1  
                    & alt_disperr_reg1[1] ==1'b1 & alt_patterndetect_reg1[1] == 1'b1 & alt_runlengthviolation_latched == 1'b0                 ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'hFC & alt_ctrldetect_reg1[1] == 1'b1 & alt_patterndetect_reg1[1] == 1'b1      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'h9C & alt_ctrldetect_reg1[1] == 1'b1 & alt_patterndetect_reg1[1] == 1'b0      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'hBC & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'hAC & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'hB4 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'hA7 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0 
                    & alt_runningdisp_reg1[1] == 1'b1                                                                                      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'hA1 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0 
                    & alt_runningdisp_reg1[1] == 1'b1 & alt_runlengthviolation_latched == 1'b1                                             ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'hA2 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0 
                   & alt_runningdisp_reg1[1] == 1'b1  
                   & ((alt_runningdisp[1] == 1'b1 & alt_errdetect_reg1[1] == 1'b1 & alt_disperr_reg1[1] == 1'b1)|                                                                                
                      (alt_runningdisp[1] == 1'b0 & alt_errdetect_reg1[1] == 1'b1 & alt_disperr_reg1[1] == 1'b0 ))                               ) |

                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'h43 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'h53 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'h4B & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0      ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'h47 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0
                   & alt_runningdisp_reg1[1] == 1'b0                                                                                       ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'h41 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0
                   & alt_runningdisp_reg1[1] == 1'b0 & alt_runlengthviolation_latched == 1'b1 
                   & ((alt_runningdisp[1] == 1'b1 & alt_errdetect_reg1[1] == 1'b1 & alt_disperr_reg1[1] == 1'b0)|                                                                                
                      (alt_runningdisp[1] == 1'b0 & alt_errdetect_reg1[1] == 1'b1 & alt_disperr_reg1[1] == 1'b1 ))                               ) |
                 (alt_sync_reg1[1] == 1'b1 & alt_dataout_reg1[15:8] == 8'h42 & alt_ctrldetect_reg1[1] == 1'b0 & alt_patterndetect_reg1[1] == 1'b0
                   & alt_runningdisp_reg1[1] == 1'b0 & ((alt_runningdisp[1] == 1'b1 & alt_errdetect_reg1[1] == 1'b1 & alt_disperr_reg1[1] == 1'b0)|
                                                     (alt_runningdisp[1] == 1'b0 & alt_errdetect_reg1[1] == 1'b1 & alt_disperr_reg1[1] == 1'b1)) )  
              )

             begin      
                altpcs_carrierdetect[1]           <= 1'b0;
             end  
           else
             begin
                altpcs_carrierdetect[1]           <= 1'b1;
             end
        end

    end




endmodule
