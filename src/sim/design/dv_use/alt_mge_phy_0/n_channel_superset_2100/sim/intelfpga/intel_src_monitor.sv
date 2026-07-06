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
// File Name   : intel_src_monitor.sv
// Project     : SM_SRC 
// Version     : 0.52
// Description : Performs Montoring of special cases (PLL/CDR Lock , FEC Block reset)  
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

module intel_src_monitor #(


)  (

    input       [0:0]        clk  , //management clock,  100 MHz
    input       [0:0]        sclr , //Hold at 1 until clock is stable / fpga is ready
    
    
    //HSSI Outputs - HIP signals
    
    input       [0:0]       sync_oflux_rx_srds_rdy         , //Input from HIP (HSSI)
    input       [0:0]       sync_ux_all_synthlockstatus    , //Input from HIP (HSSI)
    input       [0:0]       sync_ux_rxcdrlockstatus        , //Input from HIP (HSSI)
    input       [0:0]       sync_ux_rxcdrlock2data         , //Input from HIP (HSSI)
    
    //SIP/DR MUX signals
    input       [0:0]       sync_sip_rx_ignore_lock2data   , // Input from SIP to ignore lock2data during loopback
    
    //SRC Flow Control
    input       [0:0]       is_flux_used_rx_for_rx_adpt    , // v0.52 - ignore srds_rdy for flux bypass
    input       [0:0]       tx_fully_operational           , //1: TX is in fully operational state 0: Reset/Transition
    input       [0:0]       rx_fully_operational           , //1: RX is in fully operational state 0: Reset/Transition
    
    
    //SRC FSM
    input       [1:0]       clear_sticky                   , //[0] - clear tx_plllock_lost_sticky  [1] - clear rx_cdr_lock_lost_sticky 
    output reg  [0:0]       tx_plllock_lost_sticky         , // Sticky flag indicates FSM to raise tx_alarm to SIP
    output reg  [0:0]       rx_cdr_lock_lost_sticky          // Sticky flag indicates FSM to raise rx_alarm to SIP 
           

);  
  
//---------------------------------------- Logic Implementation ---------------------------------------------------------- 

//------------------------------------------------------------------------------------------------------------------------
// Loss of TX PLL / RX CDR Lock
// Assert Sticky flag if TX PLL Lock or RX CDR Lock is lost to FSM when in Fully operational state
// When clear sticky is asserted , clear the sticky flags respectively - indicates PLL / CDR Lock is recovered
//------------------------------------------------------------------------------------------------------------------------
always@ (posedge clk) begin
    if(sclr) begin
        tx_plllock_lost_sticky  <= 1'b0 ;
        rx_cdr_lock_lost_sticky <= 1'b0 ;
    end
    else begin
        if (tx_fully_operational) begin
            tx_plllock_lost_sticky <=  ~sync_ux_all_synthlockstatus | tx_plllock_lost_sticky ;
        end
        else begin
            tx_plllock_lost_sticky <= (clear_sticky[0])? 1'b0 :  tx_plllock_lost_sticky ;
        end
        if (rx_fully_operational) begin
            rx_cdr_lock_lost_sticky  <= sync_sip_rx_ignore_lock2data ?((sync_oflux_rx_srds_rdy|| !is_flux_used_rx_for_rx_adpt)  && ~sync_ux_rxcdrlockstatus)|| rx_cdr_lock_lost_sticky:((sync_oflux_rx_srds_rdy || !is_flux_used_rx_for_rx_adpt)  && (~sync_ux_rxcdrlockstatus || ~sync_ux_rxcdrlock2data)) || rx_cdr_lock_lost_sticky;
        end
        else begin
            rx_cdr_lock_lost_sticky <= (clear_sticky[1])? 1'b0 : rx_cdr_lock_lost_sticky ;
        end
    end
end 

endmodule 

//--------------------------------------------------------------------------------------------------------------------------
// Version  |  Changes                                                                         | Date         | Owner ID
//--------------------------------------------------------------------------------------------------------------------------
//   0.0    |                                                                                  |              | 
//   0.1    | Initial code                                                                     |  24-Jun-2022 | skgr
//   0.2    | Loss of TX PLL / RX CDR Lock Case added ,included  sync_sip_rx_ignore_lock2data  |  27-Jun-2022 | skgr
//   0.3    | Added TX & RX Operational state ports added                                      |  28-Jun-2022 | skgr
//   0.4    | Comments added                                                                   |  30-Jun-2022 | skgr
//   0.5    | Added logic to hold rx sticky flag                                               |  02-Sep-2022 | skgr
//   0.51   | HAS 3.5.3 , FEC reset only after Sysl pll lock irrespective of FEC_EN            |  09-Aug-2023 | skgr
//   0.52   | HSD: Ignore srds_rdy for CDR LOL when flux bypass                                |  04-Sep-2023 | skgr
//--------------------------------------------------------------------------------------------------------------------------
