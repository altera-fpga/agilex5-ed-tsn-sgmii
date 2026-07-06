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


//--------------------------------------------------------------------------------------------------------------------------
// File Name   : intel_src_stagger_block.sv
// Project     : SM_SRC 
// Version     : 0.81
// Description : 
//
// Copyright 2019 Intel Corporation.
// This reference design file is subject licensed to you by the terms and
// conditions of the applicable License Terms and Conditions for Hardware
// Reference Designs and/or Design Examples (either as signed by you or
// found at https://www.altera.com/common/legal/leg-license_agreement.html ).
//
// As stated in the license, you agree to only use this reference design
// solely in conjunction with Intel FPGAs or Intel CPLDs.
//
// THE REFERENCE DESIGN IS PROVIDED "AS IS" WITHOUT ANY EXPRESS OR IMPLIED
// WARRANTY OF ANY KIND INCLUDING WARRANTIES OF MERCHANTABILITY,
// NONINFRINGEMENT, OR FITNESS FOR A PARTICULAR PURPOSE. Intel does not
// warrant or assume responsibility for the accuracy or completeness of any
// information, links or other items within the Reference Design and any
// accompanying materials.
//
// In the event that you do not agree with such terms and conditions, do not
// use the reference design file.
///////////////////////////////////////////////////////////////////////////// 
// All rights reserved
//--------------------------------------------------------------------------------------------------------------------------
//Module declaration 
`timescale 1 ps/1 ps 
module intel_src_stagger_block # (
parameter SIM_EMULATE = 1'b0,
parameter SIM_SCALE_DOWN = 0
 

)  (
input          count_start,
input   [13:0] num_of_clocks,
input   [1:0]  scaling_factor,
input          clk,
input          sclr,
output reg     count_done
);
//

//`define SIM_EMULATE SIM_EMULATE //v0.81

// Local Parameter Declaration
`ifndef ALTERA_RESERVED_QIS //v0.81
    localparam CLK_PERIOD = 10 ; //100MHz - 10ns
    localparam MAX_STAGGER = 700000 ; // 700us - Added to reduce stagger time if above 700us during simulation (SM SRC Spec Row 19)
    localparam COUNT_FOR_SIM = MAX_STAGGER / CLK_PERIOD ;
`endif  
//
//---------------------------------------- Register and Wire declaration----------------------------------------------------
reg [17:0] wait_count;
reg [17:0] count;
reg        count_delay;
reg [2:0]  scale ;
//
//------------------- Logic Implementation ------------------ /
//------------------------------------------------------------------
//Brief Description about the Blocks what it does 
//at begining for "sclr" =1, count_delay reg will be cleared
//and at every posedge of clock "count_start" value will be stored to detect rising edge logic for count_start in next always block
//------------------------------------------------------------------
always@(posedge clk)                  
begin
if(sclr)                                          
    begin
     count_delay <= 1'b0;                                            // reg will be cleared if sclr=1
    end
else
    begin
     count_delay <= count_start;                                    //count_delay intoduced to detect rising edge
    end  
end 
//------------------------------------------------------------------
//Brief Description about the Blocks what it does 
//at begining for "sclr" =1 all the signals will be cleared
//after "count_start" =1 , based on "scaling_factor" and "num_of_clocks" i.e scaling_factor to be multiplied with num_of_clocks to get wait/stagger time
//                                                                            2b00 = x1
//                                                                            2b01 = x4
//                                                                            2b10 = x8
//                                                                            2b11 = x16
//and that multiplied value(wait/stagger time) will be stored in "wait_count" and that many times "count" reg will be incremented by 14'd1
//After "count < wait_count" condition satisfied, "count_done " made 1'b1 and registers will be cleared
//At the next clk pulse "count_done" made 1'b0 and ready for next operation
//
//------------------------------------------------------------------
always@(posedge clk) begin
if(sclr)                                                            // registers will clear
    begin
        count_done <= 1'b0;
        wait_count <= 18'd0;
        count <= 18'd0;
    end
else if((count_start) & (!(count_delay))) 
    begin                                                 // multiplied value(wait/stagger time) will be stored in "wait_count"
     count_done <= 1'b0;
    `ifndef ALTERA_RESERVED_QIS                                   // if ALTERA_RESERVED_QIS (a macro, it is for fast simulation with reduce delays)  used `else part of `ifndef will be executed                                               
         if (num_of_clocks << scale >= COUNT_FOR_SIM)
            begin
             wait_count <= (num_of_clocks << scale) >> SIM_SCALE_DOWN; 
            end 
         else
            begin 
             wait_count <= num_of_clocks << scale;
            end
     `else
        begin
         wait_count <= num_of_clocks << scale;
        end
     `endif
   end
else                                                  //that many times of multiplied value "count" reg will be incremented by 18'd1
    begin
     if((count < wait_count) && count_start)  //count_start added in v0.8
        begin 
            count <= count+18'd1;   
        end
     else
        begin
            count_done  <= count_start;              //once after count_done become 1'b1, at the next clock pulse count_done should become 1'b0 for next operation
            wait_count  <=18'd0;                     // FSM will make count_start as 1'b0 if count_done became 1'b1
            count       <=18'd0;
        end
    end
end                                   
//------------------------------------------------------------------
//Brief Description about the Blocks what it does 
//at begining for "sclr" =1 all the signals will be cleared
//after "count_start" =1 , based on "scaling_factor" and "num_of_clocks" i.e scaling_factor to be multiplied with num_of_clocks to get wait/stagger time
//                                                                            2b00 = x1
//                                                                            2b01 = x4
//                                                                            2b10 = x8
//                                                                            2b11 = x16
//and that multiplied value(wait/stagger time) will be stored in "wait_count" and that many times "count" reg will be incremented by 14'd1
//After "count < wait_count" condition satisfied, "count_done " made 1'b1 and registers will be cleared
//At the next clk pulse "count_done" made 1'b0 and ready for next operation
//------------------------------------------------------------------
always@(*) begin
    case (scaling_factor) 
        2'b00: scale = 3'd0 ;
        2'b01: scale = 3'd2 ;
        2'b10: scale = 3'd3 ;
        2'b11: scale = 3'd4 ;
        default: scale = 3'd0 ;
    endcase
end
endmodule
//
//--------------------------------------------------------------------------------------------------------------------------
// Version             |  Changes                                        | Date                 | Owner ID
//--------------------------------------------------------------------------------------------------------------------------
//   0.0               |                                                 |                      | 
//   0.1               | Initial code                                    |  29-Jun-2022         | vvemanab
//   0.2               | Standard file and module name changed           |  30-Jun-2022         | vvemanab
//   0.3               | alignment errors were corrected
//                       count_delay intoduced to detect rising edge     |  13-Jul-2022         | vvemanab
//   0.4               | scale reg intoduced                             |  15-Jul-2022         | vvemanab
//   0.5               | elseif block added                              |  18-Jul-2022         | vvemanab
//   0.6               | logic was changed in else block                 |  03-Aug-2022         | vvemanab
//   0.7               | Added SIM_EMULATE for simulation time stagger   |  22-Aug-2022         | skgr
//   0.8               | Added a stagger abort case to support v0.34     |  07-Dec-2022         | cvignesh
//                     | changes in fsm                                  |                      |
//   0.81              | Modified SIM_EMULATE -> ALTERA_RESERVED_QIS for |  06-Jan-2023         | skgr
//                     | Reduced stagger count during simulation         |                      |
//--------------------------------------------------------------------------------------------------------------------------