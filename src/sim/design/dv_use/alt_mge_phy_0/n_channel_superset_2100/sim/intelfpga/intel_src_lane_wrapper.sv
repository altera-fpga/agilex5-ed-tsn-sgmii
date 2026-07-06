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
// File Name   : intel_src_lane_wrapper.sv
// Project     : SRC 
// Version     : 0.946
// Description : SRC top wrapper that instantiates SRC lanes based on the QHIP configuration
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

`timescale 1 ps/1 ps
module intel_src_lane_wrapper
 #(
    //parameter          SIM_EMULATE                                           = 0, 
    parameter          NUM_LANES                                             = 4,
    parameter          TX_ENABLE                                             = 1,
    parameter          RX_ENABLE                                             = 1,
    parameter          TX_INITIATOR                                          = 1,
    parameter          RX_INITIATOR                                          = 1,
    parameter          TX_INITIATOR_INDEX                                    = 0,
    parameter          RX_INITIATOR_INDEX                                    = 0,
    parameter   [63:0] TX_TARGET_ENABLE                                      = 0,
    parameter   [63:0] RX_TARGET_ENABLE                                      = 0,
    parameter   [63:0] TX_LANE_FUCTIONAL_MODE                                = 0, //v0.945
    parameter   [63:0] RX_LANE_FUCTIONAL_MODE                                = 0, //v0.945
    parameter          NON_PTP_CHANNEL                                       = 1, 
    parameter          TX_PCS_EN                                             = 1, //v0.945
    parameter          RX_PCS_EN                                             = 1, //v0.945
    parameter          UX_EN                                                 = 1, 
    parameter          TX_DL_EN                                              = 1, //v0.945
    parameter          RX_DL_EN                                              = 1, //v0.945
    parameter          FLUX_USED_FOR_RX_ADAPTATION                           = 1, 
    parameter          PTP_EN                                                = 0,  
    parameter          TX_FEC_EN                                             = 1, //v0.945 
    parameter          RX_FEC_EN                                             = 1, //v0.945
    parameter          ETHERNET_SYSPLL_CLK_MODE                              = 1, 
    parameter          UX_USING_SYSPLL_CLK                                   = 1, 
    parameter          FLUX_USING_SYSPLL_CLK                                 = 1, 
    parameter          FLUX_EN                                               = 1, 
    parameter          SRC_LANE_INDEX                                        = 0,
    parameter          LEADER_LANE                                           = 0,
    parameter          SIM_SCALE_DOWN                                        = 0//,
    //parameter          DEBUG_MODE                                            = 0

 )  (
    
    //SRC Lane Control Interface with SIP (or DR MUX)
    
    input       [NUM_LANES-1:0]       tx_lane_desired_state , //0: operate, 1:reset
    output      [2*NUM_LANES-1:0]     tx_lane_current_state ,                 
    output      [NUM_LANES-1:0]       tx_alarm ,                  
    input       [NUM_LANES-1:0]       tx_clear_alarm ,
    input       [NUM_LANES-1:0]       rx_lane_desired_state , //0: operate, 1:reset
    output      [2*NUM_LANES-1:0]     rx_lane_current_state , 
    output      [NUM_LANES-1:0]       rx_alarm ,  
    input       [NUM_LANES-1:0]       rx_clear_alarm ,
    input       [NUM_LANES-1:0]       sip_rx_ignore_lock2data ,
    input       [NUM_LANES-1:0]       sip_freeze_tx_SRC_sequence ,
    input       [NUM_LANES-1:0]       sip_freeze_rx_SRC_sequence ,
    output      [NUM_LANES-1:0]       sip_freeze_tx_acknowledge , 
    output      [NUM_LANES-1:0]       sip_freeze_rx_acknowledge , 
    output      [NUM_LANES-1:0]       sip_am_gen_start  , 
    input       [NUM_LANES-1:0]       sip_am_gen_2x_ack  ,
    
    //Reset/Status Interface to HIP
    output      [NUM_LANES-1:0]       ptp_pld_adapter_tx_pld_rst_n ,    //TBD              
    output      [NUM_LANES-1:0]       ptp_pld_adapter_rx_pld_rst_n ,    //TBD               
    output      [NUM_LANES-1:0]       ptp_pld_ready ,                   //TBD 
    output      [NUM_LANES-1:0]       ptp_rst_n ,                  
    output      [NUM_LANES-1:0]       pld_adapter_tx_pld_rst_n ,                  
    output      [NUM_LANES-1:0]       pld_adapter_rx_pld_rst_n ,                  
    output      [NUM_LANES-1:0]       ehip_tx_rst_n ,                 
    output      [NUM_LANES-1:0]       ehip_rx_rst_n ,                 
    output      [NUM_LANES-1:0]       tx_pcs_sfrz_n ,                 
    output      [NUM_LANES-1:0]       rx_mac_deskew_sfrz_n ,                  
    output      [NUM_LANES-1:0]       tx_deskew_sfrz_n ,                  
    output      [NUM_LANES-1:0]       fec_tx_rst_n ,                  
    output      [NUM_LANES-1:0]       fec_rx_rst_n ,                  
    output      [NUM_LANES-1:0]       fec_csr_ret ,                   
    output      [NUM_LANES-1:0]       tx_fec_sfrz_n ,                 
    output      [NUM_LANES-1:0]       rx_fec_sfrz_n ,                 
    output      [NUM_LANES-1:0]       xcvrif_tx_rst_n ,                   
    output      [NUM_LANES-1:0]       xcvrif_rx_rst_n ,                   
    output      [NUM_LANES-1:0]       tx_xcvrif_sfrz_n ,                  
    output      [NUM_LANES-1:0]       rx_xcvrif_sfrz_n ,                  
    output      [NUM_LANES-1:0]       xcvrif_signal_ok  ,                 
    output      [NUM_LANES-1:0]       ux_tx_pma_rst_n ,                   
    output      [NUM_LANES-1:0]       ux_rx_pma_rst_n ,                   
    output      [NUM_LANES-1:0]       ux_rx_sfrz_n ,                  
    output      [NUM_LANES-1:0]       iflux_ingress_direct_231 ,               
    output      [NUM_LANES-1:0]       ehip_signal_ok ,            
    output      [NUM_LANES-1:0]       pld_ready , 
    input       [NUM_LANES-1:0]       o_rx_pcs_fully_aligned  ,  
    input       [NUM_LANES-1:0]       ux_octl_pcs_txstatus  ,
    input       [NUM_LANES-1:0]       ux_octl_pcs_rxstatus  ,
    input       [NUM_LANES-1:0]       ux_all_synthlockstatus  ,
    input       [NUM_LANES-1:0]       ux_rxcdrlockstatus  ,
    input       [NUM_LANES-1:0]       ux_rxcdrlock2data  ,
    input       [NUM_LANES-1:0]       flux_cpi_cmn_busy  ,
    input       [NUM_LANES-1:0]       oflux_rx_srds_rdy  ,
    input                             o_spll_lock  ,   // v0.941 SysPLL lock to 1 port fan out to all lanes
    input       [NUM_LANES-1:0]       o_fec_rx_rdy_n   ,
    input       [NUM_LANES-1:0]       hip_ready   , //v0.943
    

    //DR Controller Interface
    input       [0:0]                   csr_clk ,
    input       [NUM_LANES-1:0]         pause_request  ,
    output      [NUM_LANES-1:0]         pause_grant ,
    input       [(21*NUM_LANES)-1:0]    dr_csr_addr  , //v0.944
    input       [NUM_LANES-1:0]         dr_csr_write  , 
    input       [NUM_LANES-1:0]         dr_csr_read  ,
    input       [(4*NUM_LANES)-1:0]     dr_csr_be    ,
    input       [(32*NUM_LANES)-1:0]    dr_csr_wdata  ,
    output      [(32*NUM_LANES)-1:0]    dr_csr_rdata ,
    output      [NUM_LANES-1:0]         dr_csr_waitrequest,
    output      [NUM_LANES-1:0]         dr_csr_rdata_valid,
    
    
    //SRC Shoreline Sequencer Interface
    
    output      [NUM_LANES-1:0]       sss_req ,   
    input       [NUM_LANES-1:0]       sss_grant 
    
    
);



//---------------------------------------- Parameters-----------------------------------------------

localparam DR_CTRL_AWIDTH                      = 21 ; //v0.944
localparam DR_CTRL_DWIDTH                      = 32 ;
localparam DR_CTRL_BEWIDTH                     = DR_CTRL_DWIDTH >> 3 ; //Added on 14-Oct-2022 sushilsh
localparam RESET_CLK_COUNT                     = 32 ;

localparam TX_LANE_RESET_STATE_POINTER          = 72 ;
localparam RX_LANE_RESET_STATE_POINTER          = 188 ; //v0.943
localparam TOTAL_INSTRUCTIONS                   = 71  ; //v0.946


//---------------------------------------- Register and Wire declaration----------------------------

wire  [NUM_LANES*NUM_LANES-1:0] w_sl2l_trigger_or_error_resp_in      ;
wire  [NUM_LANES*NUM_LANES-1:0] w_sl2l_desired_state_or_ready_in     ;
wire  [NUM_LANES*NUM_LANES-1:0] w_sl2l_tx_rx_in                      ;
wire  [NUM_LANES*NUM_LANES-1:0] w_sl2l_error_resp_or_trigger_out     ;
wire  [NUM_LANES*NUM_LANES-1:0] w_sl2l_ready_or_desired_state_out    ;
wire  [NUM_LANES*NUM_LANES-1:0] w_sl2l_tx_rx_out                     ;
wire  [NUM_LANES-1:0]           w_addr_gen_common_block_rst_done_reg ; //v0.945
wire  [NUM_LANES-1:0]           src_clk ;//Exposed to HAL , Used for SRC DV

//-------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------------
// SRC Lane module instantiation based on QHIP configuration
//-------------------------------------------------------------------------------------------------

genvar i,j,k;

generate

    for (i = 0 ; i < NUM_LANES ; i= i + 1) begin : src_lane_instance

    intel_src_lane
    #(
    //Parameters are unique to each SRC Lane , QHIP will share dedicated parameters to each SRC lane in QHIP
    .NUM_LANES                                             ( NUM_LANES                                              ),
    .TX_ENABLE                                             ( TX_ENABLE [i]                                          ), 
    .RX_ENABLE                                             ( RX_ENABLE [i]                                          ),     
    .TX_INITIATOR                                          ( TX_INITIATOR [i]                                       ),
    .RX_INITIATOR                                          ( RX_INITIATOR [i]                                       ),
    .TX_INITIATOR_INDEX                                    ( TX_INITIATOR_INDEX [(((i+1)*4)-1):i*4]                 ),
    .RX_INITIATOR_INDEX                                    ( RX_INITIATOR_INDEX [(((i+1)*4)-1):i*4]                 ),
    .TX_TARGET_ENABLE                                      ( TX_TARGET_ENABLE   [(((i+1)*NUM_LANES)-1):i*NUM_LANES] ),
    .RX_TARGET_ENABLE                                      ( RX_TARGET_ENABLE   [(((i+1)*NUM_LANES)-1):i*NUM_LANES] ),    
    .TX_LANE_FUCTIONAL_MODE                                ( TX_LANE_FUCTIONAL_MODE[(((i+1)*5)-1):i*5]              ),
    .RX_LANE_FUCTIONAL_MODE                                ( RX_LANE_FUCTIONAL_MODE[(((i+1)*5)-1):i*5]              ),
    .NON_PTP_CHANNEL                                       ( NON_PTP_CHANNEL [i]                                    ),
    .TX_PCS_EN                                             ( TX_PCS_EN [i]                                          ),
    .RX_PCS_EN                                             ( RX_PCS_EN [i]                                          ),
    .UX_EN                                                 ( UX_EN  [i]                                             ),
    .TX_DL_EN                                              ( TX_DL_EN  [i]                                          ),
    .RX_DL_EN                                              ( RX_DL_EN  [i]                                          ),
    .FLUX_USED_FOR_RX_ADAPTATION                           ( FLUX_USED_FOR_RX_ADAPTATION [i]                        ),
    .PTP_EN                                                ( PTP_EN  [i]                                            ),
    .TX_FEC_EN                                             ( TX_FEC_EN  [i]                                         ),
    .RX_FEC_EN                                             ( RX_FEC_EN  [i]                                         ),
    .ETHERNET_SYSPLL_CLK_MODE                              ( ETHERNET_SYSPLL_CLK_MODE [i]                           ),
    .UX_USING_SYSPLL_CLK                                   ( UX_USING_SYSPLL_CLK      [i]                           ),
    .FLUX_USING_SYSPLL_CLK                                 ( FLUX_USING_SYSPLL_CLK    [i]                           ),
    .FLUX_EN                                               ( FLUX_EN  [i]                                           ),
    .SRC_LANE_INDEX                                        ( SRC_LANE_INDEX [(((i+1)*4)-1):i*4]                     ),
    .LEADER_LANE                                           ( LEADER_LANE [i]                                        ),
    .SIM_SCALE_DOWN                                        ( SIM_SCALE_DOWN                                         ),
    .TX_LANE_RESET_STATE_POINTER                           (TX_LANE_RESET_STATE_POINTER                             ),
    .RX_LANE_RESET_STATE_POINTER                           (RX_LANE_RESET_STATE_POINTER                             ),
    .TOTAL_INSTRUCTIONS                                    (TOTAL_INSTRUCTIONS                                      ) //V0.941.3

    ) src_lane (
    
    
    //SRC Lane Control Interface with SIP (or DR MUX)

    .tx_lane_desired_state         (tx_lane_desired_state[i]        ),
    .tx_lane_current_state         (tx_lane_current_state[(((i+1)*2)-1):i*2]),                 
    .tx_alarm                      (tx_alarm[i]                     ), 
    .tx_clear_alarm                (tx_clear_alarm[i]               ),
    .rx_lane_desired_state         (rx_lane_desired_state[i]        ),
    .rx_lane_current_state         (rx_lane_current_state[(((i+1)*2)-1):i*2]),
    .rx_alarm                      (rx_alarm[i]                     ),
    .rx_clear_alarm                (rx_clear_alarm[i]               ),
    .sip_rx_ignore_lock2data       (sip_rx_ignore_lock2data[i]      ),
    .sip_freeze_tx_SRC_sequence    (sip_freeze_tx_SRC_sequence[i]   ),
    .sip_freeze_rx_SRC_sequence    (sip_freeze_rx_SRC_sequence[i]   ),
    .sip_freeze_tx_acknowledge     (sip_freeze_tx_acknowledge[i]    ),
    .sip_freeze_rx_acknowledge     (sip_freeze_rx_acknowledge[i]    ),
    .sip_am_gen_start              (sip_am_gen_start[i]             ),
    .sip_am_gen_2x_ack             (sip_am_gen_2x_ack[i]            ),
    
    //Reset/Status Interface to HIP
    .ptp_pld_adapter_tx_pld_rst_n  (ptp_pld_adapter_tx_pld_rst_n [i] ),                  
    .ptp_pld_adapter_rx_pld_rst_n  (ptp_pld_adapter_rx_pld_rst_n [i] ),                
    .ptp_pld_ready                 (ptp_pld_ready                [i] ), 
    .ptp_rst_n                     (ptp_rst_n                    [i] ),
    .pld_adapter_tx_pld_rst_n      (pld_adapter_tx_pld_rst_n     [i] ),             
    .pld_adapter_rx_pld_rst_n      (pld_adapter_rx_pld_rst_n     [i] ),            
    .ehip_tx_rst_n                 (ehip_tx_rst_n                [i] ),
    .ehip_rx_rst_n                 (ehip_rx_rst_n                [i] ),
    .tx_pcs_sfrz_n                 (tx_pcs_sfrz_n                [i] ),
    .rx_mac_deskew_sfrz_n          (rx_mac_deskew_sfrz_n         [i] ),        
    .tx_deskew_sfrz_n              (tx_deskew_sfrz_n             [i] ),     
    .fec_tx_rst_n                  (fec_tx_rst_n                 [i] ), 
    .fec_rx_rst_n                  (fec_rx_rst_n                 [i] ), 
    .fec_csr_ret                   (fec_csr_ret                  [i] ),
    .tx_fec_sfrz_n                 (tx_fec_sfrz_n                [i] ), 
    .rx_fec_sfrz_n                 (rx_fec_sfrz_n                [i] ), 
    .xcvrif_tx_rst_n               (xcvrif_tx_rst_n              [i] ),     
    .xcvrif_rx_rst_n               (xcvrif_rx_rst_n              [i] ),     
    .tx_xcvrif_sfrz_n              (tx_xcvrif_sfrz_n             [i] ),    
    .rx_xcvrif_sfrz_n              (rx_xcvrif_sfrz_n             [i] ),    
    .xcvrif_signal_ok              (xcvrif_signal_ok             [i] ),     
    .ux_tx_pma_rst_n               (ux_tx_pma_rst_n              [i] ),    
    .ux_rx_pma_rst_n               (ux_rx_pma_rst_n              [i] ),    
    .ux_rx_sfrz_n                  (ux_rx_sfrz_n                 [i] ), 
    .iflux_ingress_direct_231      (iflux_ingress_direct_231     [i] ),        
    .ehip_signal_ok                (ehip_signal_ok               [i] ),
    .pld_ready                     (pld_ready                    [i] ),
    .o_rx_pcs_fully_aligned        (o_rx_pcs_fully_aligned       [i] ),
    .ux_octl_pcs_txstatus          (ux_octl_pcs_txstatus         [i] ),
    .ux_octl_pcs_rxstatus          (ux_octl_pcs_rxstatus         [i] ),
    .ux_all_synthlockstatus        (ux_all_synthlockstatus       [i] ),
    .ux_rxcdrlockstatus            (ux_rxcdrlockstatus           [i] ),
    .ux_rxcdrlock2data             (ux_rxcdrlock2data            [i] ),
    .flux_cpi_cmn_busy             (flux_cpi_cmn_busy            [i] ),
    .oflux_rx_srds_rdy             (oflux_rx_srds_rdy            [i] ),
    .c0_syspll_lockstatus          (o_spll_lock                      ), //v0.941.1
    .c1_syspll_lockstatus          (o_spll_lock                      ), //v0.941.1
    .c2_syspll_lockstatus          (o_spll_lock                      ), //v0.941.1
    .o_fec_rx_rdy_n                (o_fec_rx_rdy_n               [i] ),
    .hip_ready                     (hip_ready                    [i] ), //v0.943
    
    //Inter SRC Lane Interface
    .i_sl2l_trigger_or_error_resp        (w_sl2l_trigger_or_error_resp_in   [(((i+1)*NUM_LANES)-1):i*NUM_LANES] ),
    .i_sl2l_desired_state_or_ready       (w_sl2l_desired_state_or_ready_in  [(((i+1)*NUM_LANES)-1):i*NUM_LANES] ),
    .i_sl2l_tx_rx                        (w_sl2l_tx_rx_in                   [(((i+1)*NUM_LANES)-1):i*NUM_LANES] ),
    .o_sl2l_error_resp_or_trigger        (w_sl2l_error_resp_or_trigger_out  [(((i+1)*NUM_LANES)-1):i*NUM_LANES] ),              
    .o_sl2l_ready_or_desired_state       (w_sl2l_ready_or_desired_state_out [(((i+1)*NUM_LANES)-1):i*NUM_LANES] ),              
    .o_sl2l_tx_rx                        (w_sl2l_tx_rx_out                  [(((i+1)*NUM_LANES)-1):i*NUM_LANES] ),
    
    //DR Controller Interface
    //DR controller team confirmed DR-SRC IF will be channelized - Each SRC Lane will have dedicated DR CTRLLER interface signal
    .csr_clk                (csr_clk                            ),
    .pause_request          (pause_request[i]                   ),
    .pause_grant            (pause_grant  [i]                   ),
    .dr_csr_addr            (dr_csr_addr [(((i+1)*DR_CTRL_AWIDTH)-1):i*DR_CTRL_AWIDTH] ),
    .dr_csr_write           (dr_csr_write   [i]                   ),
    .dr_csr_read            (dr_csr_read    [i]                   ),
    .dr_csr_be              (dr_csr_be   [(((i+1)*DR_CTRL_BEWIDTH)-1):i*DR_CTRL_BEWIDTH]),
    .dr_csr_wdata           (dr_csr_wdata[(((i+1)*DR_CTRL_DWIDTH)-1):i*DR_CTRL_DWIDTH] ),
    .dr_csr_rdata           (dr_csr_rdata[(((i+1)*DR_CTRL_DWIDTH)-1):i*DR_CTRL_DWIDTH] ),
    .dr_csr_waitrequest     (dr_csr_waitrequest [i]             ),
    .dr_csr_rdata_valid     (dr_csr_rdata_valid [i]             ),
    
    //SRC Shoreline Sequencer Interface
    
    .sss_req                (sss_req  [i]),
    .sss_grant              (sss_grant[i]),

    .src_clk                (src_clk[i]),//Exposed to HAL
    
    //Debug port interface  
    //`ifdef DEBUG_MODE       //v0.941.4  
    // .src_reset_drive_reg    (src_reset_drive_reg[(((i+1)*32)-1):i*32]), 
    //  //output port  
    // .src_debug_reg          (src_debug_reg[(((i+1)*32)-1):i*32]) ,
    //`endif  
    //SRC FSM
    .i_addr_gen_common_block_rst_done_reg (w_addr_gen_common_block_rst_done_reg     ),
    .o_addr_gen_common_block_rst_done_reg (w_addr_gen_common_block_rst_done_reg [i] )

);  
end

endgenerate


//-------------------------------------------------------------------------------------------------
//Interconnection of SRC lane to lane transaction(Orange line)
//-------------------------------------------------------------------------------------------------
for (j = 0; j < NUM_LANES ; j=j+1) begin : src_lane_dest
    for (k = 0; k < NUM_LANES ; k=k+1) begin : src_lane_source
        assign w_sl2l_trigger_or_error_resp_in   [j*NUM_LANES+k] = w_sl2l_error_resp_or_trigger_out  [k*NUM_LANES+j] ;
        assign w_sl2l_desired_state_or_ready_in  [j*NUM_LANES+k] = w_sl2l_ready_or_desired_state_out [k*NUM_LANES+j] ;
        assign w_sl2l_tx_rx_in                   [j*NUM_LANES+k] = w_sl2l_tx_rx_out                  [k*NUM_LANES+j] ;
    end
end

endmodule

//--------------------------------------------------------------------------------------------------------------------------
// Version  |  Changes                                                                       | Date           | Owner ID
//---------------------------------------------------------------------------------------------------------------------------
//   0.0    |                                                                                |                |
//   0.1    | Initial code                                                                   |  17-Jun-2022   | skgr
//   0.2    | Wrapper port connection corrected,Added dedicated parameter passing from QHIP  |  24-Jun-2022   | skgr
//   0.3    | DR Controller interface dedicated for SRC lane                                 |  29-Jun-2022   | skgr
//   0.4    | RTL Compile clean code                                                         |  30-Jun-2022   | skgr
//   0.5    | syspll_lock signal modified to align with SYSPLL IP                            |  27-Jul-2022   | skgr
//   0.6    | LEADER_LANE , SIM_SCALE_DOWN Parameter added                                   |  19-Aug-2022   | skgr
//   0.7    | Added common rsrc done ip and output for FSM                                   |  28-Sep-2022   | cvignesh
//   0.8    | Updated AVMM port                                                              |  14-Oct-2022   | sushilsh
//   0.9    | Tristate ports removed as SRIP,MRIP & DR Controller                            |  14-Oct-2022   | skgr
//          | assign reset values to unused lane signals.Added internal clock and reset      |                |
//          | component for SM SRC Lane                                                      |                |
//   0.91   | Reverted clock & reset component until support for SM enabled.case: 16018567825|  15-Nov-2022   | skgr
//   0.92   | DR AVMM Address width 22                                                       |  24-Nov-2022   | skgr
//   0.921  | Adding ALTERA_RESERVED_QIS similar to GDR SRC for Clk,rst generation in ED     |  20-Dec-2022   | skgr
//   0.93   | Updating default values of parameter in SRC Lane wrapper , SIM CLK 100MHz      |  06-Jan-2023   | skgr
//   0.94   | Removed CLOCK_RST_COMP_BYPASS, SysPLL lock to 1 port fan out to all lanes TBD  |  20-Feb-2023   | skgr
//          | Debug ports changed to Debug registers in CSR                                  |                |
//   0.941  | 1. SysPLL lock to 1 port fan out to all lanes                                  |  22-Feb-2023   | skgr
//          | 2. Parameter SIM_EMULATE is removed and it is replaced with ALTERA_RESERVED_QIS|                |
//          |    Neednot set any macro or parameter, enabled when quartus Synthesis disabled |                |
//          | 3. Address gen paramters brought out to wrapper - added TOTAL_INSTRUCTIONS     |                |
//          | 4. DEBUG_MODE is changed to macro SRC_DEBUG_MODE needs to be enabled at ED     |                |
//          | 5. Macro SIM_125MHz for 125MHz clk , default 10GHz clock for Simulation        |                |
//   0.942  | 2XAM wait period for MAC enabled FEC modes - Spec change 16019815118           |  22-Feb-2023   | skgr
//          | Clearing of sip_am_gen_start after sip_am_gen_2x_ack =1 - 16019769182          |  22-Feb-2023   | skgr
//   0.943  | sclr_in clear time for simulation changed                                      |  04-Apr-2023   | skgr 
//          | HSD:16020176490 hip_ready added to SRC Spec                                    |                | 
//   0.944  | CSR Width set to 21 bit                                                        |  25-May-2023   | skgr        
//   0.945  | HSD : Clock and reset internal to SRC lane & all_cmn_rsrc_done moved internal  |  31-May-2023   | skgr
//          | Rename of lane2lane port                                                       |                | 
//          | Sepatated parameter for TX RX for Dual simplex                                 |                |
//   0.946  | HSD:14019867282 PTP/DL GB Restart delay instruction addition                   |  25-Sep-2023   | skgr  
//--------------------------------------------------------------------------------------------------------------------------

