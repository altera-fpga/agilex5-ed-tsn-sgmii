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
// File Name   : intel_src_synchronizers.v
// Project     : SRC 
// Version     : 0.5
// Description : Provides the Interconnection of SRC lane 2 lane transaction and MUX the status of active lane to FSM
// Limitations : 
//--------------------------------------------------------------------------------------------------------------------------
// Copyright 2019 Intel Corporation. 
//
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


module intel_src_synchronizers #(
    parameter IN_WIDTH   = 23
) (

input           clk,             
input  [IN_WIDTH-1:0]   s_sm_src_sync_in, 
output [IN_WIDTH-1:0]   s_sm_src_sync_out

);


/* Bit positions corresponding to the SRC input signals are as follows

CLK                       
//22            sss_grant,                        
//21            pause_request,                    
//20            hip_ready,  //v0.5                 
//19            o_fec_rx_rdy_n,                   
//18            c2_syspll_lockstatus,             
//17            c1_syspll_lockstatus,             
//16            c0_syspll_lockstatus,             
//15            oflux_rx_srds_rdy,                
//14            flux_cpi_cmn_busy,                
//13            ux_rxcdrlock2data,                
//12            ux_rxcdrlockstatus,               
//11            ux_all_synthlockstatus,           
//10            ux_octl_pcs_rxstatus,             
//9             ux_octl_pcs_txstatus,             
//8             o_rx_pcs_fully_aligned,           
//7             sip_am_gen_2x_ack,          
//6             sip_freeze_rx_SRC_sequence,       
//5             sip_freeze_tx_SRC_sequence,       
//4             sip_rx_ignore_lock2data,          
//3             rx_clear_alarm,             
//2             rx_lane_desired_state,      
//1             tx_clear_alarm,             
//0             tx_lane_desired_state       
*/     

//---------------------------------------- Logic Implementation ----------------------------------- 

//-------------------------------------------------------------------------------------------------
// CDC Block instantiation for HIP signals
//-------------------------------------------------------------------------------------------------
sopc_synchronizer sm_src_sync_hip[IN_WIDTH-1:0](
              .clk      (clk), 
              .reset_n  (1'b1), 
              .din      (s_sm_src_sync_in[IN_WIDTH-1:0]), //v0.4
              .dout     (s_sm_src_sync_out[IN_WIDTH-1:0]) //v0.4
              );    
              
endmodule

//--------------------------------------------------------------------------------------------------------------------------
// Version             |  Changes                                                                  | Date         | Owner ID
//--------------------------------------------------------------------------------------------------------------------------
//   0.0               |                                                                           |              | 
//   0.1               | Initial code                                                              |  17-Jun-2022 | skgr  
//   0.2               | Added header & comments                                                   |  24-Jun-2022 | skgr
//   0.3               | Code optimization for CSR Registers                                       |  01-Aug-2022 | skgr
//   0.4               | Change harded width 22 to IN_WIDTH , remove csr_clk unused - ITF error    |  06-Jan-2023 | skgr
//   0.5               | HSD:16020176490 hip_ready added to SRC Spec                               |  04-Apr-2023 | skgr
//--------------------------------------------------------------------------------------------------------------------------
