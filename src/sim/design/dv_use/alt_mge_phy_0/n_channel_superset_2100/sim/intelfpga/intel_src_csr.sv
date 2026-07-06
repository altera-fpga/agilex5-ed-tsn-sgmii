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
// File Name   : intel_src_csr.sv
// Project     : SM_SRC 
// Version     : 0.853
// Description : Provides the CSR access for reconfiguration for DR Use case
//
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
//
module intel_src_csr
#(
//
// Global Parameter Declaration
//
parameter        NUM_LANES=1,
parameter        TX_ENABLE =1'b0,
parameter        RX_ENABLE= 1'b0,
parameter        TX_INITIATOR=1'b0,
parameter        RX_INITIATOR=1'b0,
parameter        TX_INITIATOR_INDEX=4'h0,
parameter        RX_INITIATOR_INDEX=4'h0,
parameter        TX_TARGET_ENABLE=16'd0,
parameter        RX_TARGET_ENABLE=16'd0,
parameter        TX_LANE_FUCTIONAL_MODE=5'd0,
parameter        RX_LANE_FUCTIONAL_MODE=5'd0,
parameter        NON_PTP_CHANNEL=1'b0,
parameter        TX_PCS_EN=1'b0,
parameter        RX_PCS_EN=1'b0,
parameter        UX_EN=1'b0,
parameter        TX_DL_EN=1'b0,
parameter        RX_DL_EN=1'b0,
parameter        FLUX_USED_FOR_RX_ADAPTATION=1'b0,
parameter        PTP_EN=1'b0,
parameter        TX_FEC_EN=1'b0,
parameter        RX_FEC_EN=1'b0,
parameter        ETHERNET_SYSPLL_CLK_MODE=1'b0,
parameter        UX_USING_SYSPLL_CLK=1'b0,
parameter        FLUX_USING_SYSPLL_CLK=1'b0,
parameter        FLUX_EN=1'b0,
parameter        LEADER_LANE=1'b0//,
//parameter        SIM_EMULATE=1'b0                                           
) (
    input              csr_clk,
    input              sclr,
    
    input      [20:0]  dr_csr_addr , // v0.852
    input      [3:0]   dr_csr_be,   //added on 30-Sep-2022
    input              dr_csr_write,
    input              dr_csr_read, //added on 30-Sep-2022
    input      [31:0]  dr_csr_wdata,
    
    output reg [31:0]  dr_csr_rdata,
    output reg         dr_csr_rdata_valid,  //added on 30-Sep-2022
    output reg         dr_csr_waitrequest,  //1 indicates that the transaction is complete and DR_controller can issue new transaction
    output reg [31:0]  src_role_cfg,
    output reg [31:0]  src_target_enable,
    output reg [31:0]  src_functional_mode_cnf,
`ifdef SRC_DEBUG_MODE   
    input      [31:0]  src_debug_status_reg, //v0.851
    output reg [31:0]  src_reset_drive_reg, //V0.85
 `endif   
    input      [01:0]  tx_lane_current_state,
    input      [01:0]  rx_lane_current_state
);
//---------------------------------------- Register and Wire declaration----------------------------------------------------
reg        sclr_d1        ;
reg        sclr_d2        ;
reg [0:0]  dr_csr_write_reg ;
reg [0:0]  dr_csr_read_reg  ;

reg [1:0]  csr_read_count_reg  ;

//------------------- Logic Implementation ---------------------------------
//
//--------------------------------------------------------------------------
//Brief Description about the Blocks what it does 
// asynchronous reset asserted and synchronously de-asserted reset circuit
//--------------------------------------------------------------------------
always@(posedge csr_clk, posedge sclr)
begin
    if(sclr)  
        begin
        sclr_d1             <= 1'b1;
        sclr_d2             <= 1'b1;
        dr_csr_write_reg    <= 1'b0;
        dr_csr_read_reg     <= 1'b0;
        end 
    else
        begin
        sclr_d1             <= 1'b0;
        sclr_d2             <= sclr_d1;
        dr_csr_write_reg    <= dr_csr_write ;
        dr_csr_read_reg     <= dr_csr_read ;
        
        if(dr_csr_read && !csr_read_count_reg[1] )
            begin
              csr_read_count_reg <=  csr_read_count_reg + 2'b01;
            end 
        else 
            begin
              csr_read_count_reg <= 2'b00;
            end 
        end         
end   

//--------------------------------------------------------------------------
//Brief Description about the Blocks what it does 
//In  if-block will intialize registers with respective parameters when sclr=1 and
//In else if-block we will do write operation to registers based on dr_csr_addr  
//after pause_grant signal=1 (from SRC Lane FSM)
//In else-block we will do read operation to dr_csr_rdata  based on dr_csr_addr 
//
//supported byte enable
//1111, 0001, 0010, 0100, 1000, 0011, 1100
//
//--------------------------------------------------------------------------
always@(posedge csr_clk, posedge sclr_d2)
begin
if(sclr_d2)        // for sclr=1 all registers should initialized
   begin 
     src_role_cfg [31:13]            <= 19'd0;   /* reserved*/       
     src_role_cfg [12]               <= LEADER_LANE;
     src_role_cfg [11]               <= RX_ENABLE;
     src_role_cfg [10]               <= TX_ENABLE;
     src_role_cfg [9:6]              <= RX_INITIATOR_INDEX;
     src_role_cfg [5:2]              <= TX_INITIATOR_INDEX;
     src_role_cfg [1]                <= RX_INITIATOR;
     src_role_cfg [0]                <= TX_INITIATOR;
     src_target_enable [31:16]       <= (16'd0 | RX_TARGET_ENABLE);
     src_target_enable [15:0]        <= (16'd0 | TX_TARGET_ENABLE);
     src_functional_mode_cnf [31:24] <= 16'd0;                     /* reserved*/       
     src_functional_mode_cnf [23]    <= NON_PTP_CHANNEL;
     src_functional_mode_cnf [22]    <= RX_PCS_EN;
     src_functional_mode_cnf [21]    <= TX_PCS_EN; 
     src_functional_mode_cnf [20]    <= UX_EN;
     src_functional_mode_cnf [19]    <= RX_DL_EN ;
     src_functional_mode_cnf [18]    <= TX_DL_EN; 
     src_functional_mode_cnf [17]    <= FLUX_USED_FOR_RX_ADAPTATION;
     src_functional_mode_cnf [16]    <= PTP_EN;
     src_functional_mode_cnf [15]    <= RX_FEC_EN;
     src_functional_mode_cnf [14]    <= TX_FEC_EN; 
     src_functional_mode_cnf [13]    <= ETHERNET_SYSPLL_CLK_MODE;
     src_functional_mode_cnf [12]    <= UX_USING_SYSPLL_CLK;
     src_functional_mode_cnf [11]    <= FLUX_USING_SYSPLL_CLK;
     src_functional_mode_cnf [10]    <= FLUX_EN;   
     src_functional_mode_cnf [9:5]   <= RX_LANE_FUCTIONAL_MODE [4:0];
     src_functional_mode_cnf [4:0]   <= TX_LANE_FUCTIONAL_MODE [4:0];   
     dr_csr_rdata  [31:0]            <= 32'd0;
     dr_csr_rdata_valid              <= 1'b0;
   end
else if (dr_csr_write)  //if dr_csr_write =1 ,based on dr_csr_addr  registers should fill with wdata
begin
    case (dr_csr_addr [7:0])
    //case (dr_csr_addr_reg [7:0])
    8'h   00: begin
                src_role_cfg [7 :0 ] <= dr_csr_be [0]? dr_csr_wdata[7 :0 ] : src_role_cfg [7 :0 ];
                src_role_cfg [15:8 ] <= dr_csr_be [1]? dr_csr_wdata[15:8 ] : src_role_cfg [15:8 ];
                src_role_cfg [23:16] <= dr_csr_be [2]? dr_csr_wdata[23:16] : src_role_cfg [23:16];
                src_role_cfg [31:24] <= dr_csr_be [3]? dr_csr_wdata[31:24] : src_role_cfg [31:24];
              end                  
    8'h   04: begin       
                src_target_enable [7 :0 ] <= dr_csr_be [0]? dr_csr_wdata[7 :0 ] : src_target_enable [7 :0 ];
                src_target_enable [15:8 ] <= dr_csr_be [1]? dr_csr_wdata[15:8 ] : src_target_enable [15:8 ];
                src_target_enable [23:16] <= dr_csr_be [2]? dr_csr_wdata[23:16] : src_target_enable [23:16];
                src_target_enable [31:24] <= dr_csr_be [3]? dr_csr_wdata[31:24] : src_target_enable [31:24];                
        end
    8'h   08: begin
                src_functional_mode_cnf [7 :0 ] <= dr_csr_be [0]? dr_csr_wdata[7 :0 ] : src_functional_mode_cnf [7 :0 ];
                src_functional_mode_cnf [15:8 ] <= dr_csr_be [1]? dr_csr_wdata[15:8 ] : src_functional_mode_cnf [15:8 ];
                src_functional_mode_cnf [23:16] <= dr_csr_be [2]? dr_csr_wdata[23:16] : src_functional_mode_cnf [23:16];
                src_functional_mode_cnf [31:24] <= dr_csr_be [3]? dr_csr_wdata[31:24] : src_functional_mode_cnf [31:24];
         end
`ifdef SRC_DEBUG_MODE //v0.85
    8'h   14: begin
                src_reset_drive_reg [7 :0 ] <= dr_csr_be [0]? dr_csr_wdata[7 :0 ]: src_reset_drive_reg [7 :0 ];
                src_reset_drive_reg [15:8 ] <= dr_csr_be [1]? dr_csr_wdata[15:8 ]: src_reset_drive_reg [15:8 ];
                src_reset_drive_reg [23:16] <= dr_csr_be [2]? dr_csr_wdata[23:16]: src_reset_drive_reg [23:16];
                src_reset_drive_reg [31:24] <= dr_csr_be [3]? {4'd0,dr_csr_wdata[27:24]}: src_reset_drive_reg [31:24] ;
              end
`endif
     endcase    
end
//else if(dr_csr_read_reg) //if dr_csr_read =1 ,based on dr_csr_addr  dr_csr_rdata reg should fill with corresponding reg values
else if(csr_read_count_reg[1]) 
    begin 
        case (dr_csr_addr [7:0]) 
        8'h   00: begin 
                    dr_csr_rdata [31:0] <= src_role_cfg [31:0];
                    dr_csr_rdata_valid  <= 1'b1;
                  end       
        8'h   04: begin       
                    dr_csr_rdata [31:0] <= src_target_enable [31:0];
                    dr_csr_rdata_valid  <= 1'b1;                  
                  end 
        8'h   08: begin        
                    dr_csr_rdata [31:0] <= src_functional_mode_cnf [31:0];  
                    dr_csr_rdata_valid  <= 1'b1;                  
                  end
        8'h   0C: begin        
                    dr_csr_rdata [31:0] <= {28'd0,rx_lane_current_state,tx_lane_current_state};  //src_status_reg 
                    dr_csr_rdata_valid  <= 1'b1;                   
                  end
`ifdef SRC_DEBUG_MODE //v0.85
        8'h   10: begin 
                    dr_csr_rdata [31:0] <= src_debug_status_reg; //Debug: INTERNAL status registers from SRC - HAS 10.2.5
                    dr_csr_rdata_valid  <= 1'b1;
                  end
        8'h   14: begin 
                    dr_csr_rdata [31:0] <= src_reset_drive_reg ; //Debug: Override HIP inputs - HAS 10.2.5
                    dr_csr_rdata_valid  <= 1'b1;
                  end
`endif
        default : begin      
                    dr_csr_rdata [31:0] <= 32'h00000000;   
                    dr_csr_rdata_valid  <= 1'b0;                 
                  end
        endcase
    end
else
    begin
       dr_csr_rdata [31:0] <= 32'h00000000;
       dr_csr_rdata_valid  <= 1'b0;
    end   
end

//--------------------------------------------------------------------------
//Brief Description about the Blocks what it does 
//This block will generate wait request based on write or raed input
//--------------------------------------------------------------------------
always@(dr_csr_write, dr_csr_write_reg, dr_csr_read, csr_read_count_reg, sclr_d2)
begin
if(sclr_d2)        // for sclr=1 all registers should initialized
    begin 
        dr_csr_waitrequest  <= 1'b0;
    end
else if((dr_csr_write && !dr_csr_write_reg) ) //logical OR operation
    begin
        dr_csr_waitrequest  <= 1'b1;
    end
    
else if(dr_csr_read && !csr_read_count_reg[1]) //logical OR operation
    begin
        dr_csr_waitrequest  <= 1'b1;
    end 
else
    begin
        dr_csr_waitrequest  <= 1'b0;
    end 
end  
endmodule

//------------------------------------------------------------------------------------------------------------------------------------------
// Version             |  Changes                                                                          | Date         | Owner ID
//----------------------------------------------------------------------------------------------------------------------------------------
//   0.0               |                                                                                   |              |
//   0.1               | Initial code                                                                      |              |
//   0.11              | Header added                                                                      | 16-Jun-2022  | vvemanab
//   0.2               | Made changes to pass the parameters from src_lane top to CSR, sclr signal included| 17-Jun-2022  | vvemanab
//                       Made changes for src flow control ports to get updated based on DR Controller     |              |
//                       Multiple driver issue resolved                                                    |              |
//                                                                                                         |              |
//   0.3               | pause_grant , sync_pause_request signals are removed                              | 27-Jun-2022  | vvemanab         
//   0.4               | NUM_LANES parameter introduced                                                    | 01-Jul-2022  | vvemanab
//   0.5               | input signal port names were changed                                              | 07-Jul-2022  | vvemanab               
//   0.6               | names of the ports were modified                                                  | 01-Aug-2022  | vvemanab
//   0.7               | Update of src_status_reg as in Sec 10.2.4                                         | 18-Aug-2022  | skgr 
//   0.8               | Added AVMM port                                                                   | 30-Sep-2022  | sushilsh
//   0.81              | Timing closure fixes  on byte enable                                              | 04-Nov-2022  | skgr
//   0.82              | Fix added for dr_csr_waitrequest                                                  | 18-Nov-2022  | sushilsh
//   0.83              | added 22 bits address line                                                        | 24-Nov-2022  | sushilsh
//   0.84              | added fix for HSD 16018851803                                                     | 28-Nov-2022  | sushilsh
//   0.85              | Debug registers added as in SM SRC HAS 10.2.5 & 10.2.6 enabled when               |              |
//                     | DEBUG_MODE macro is enabled                                                       | 06-Jan-2023  | skgr
//   0.851             | DEBUG_MODE renamed as SRC_DEBUG_MODE                                              | 22-Feb-2023  | skgr
//                     | SIM_EMULATE param replaced with ALTERA_QIS_RESERVED macro                         |              |
//                     | Added src_debug_status_reg as input                                               |              |
//   0.852             | AVMM width 21 bit                                                                 | 25-May-2023  | skgr                  
//   0.853             | Parameter separated out for Dual simplex case                                     | 29-May-2023  | skgr
//------------------------------------------------------------------------------------------------------------------------------------------
