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
// File Name   : intel_src_lane.v
// Project     : SRC 
// Version     : 0.917
// Description : SRC lane instance top. Consists of FSM to execute the HSSI reset sequencing. 
//               Specification is stored as VLIW in M20K
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
module intel_src_lane
 #(
    //parameter          SIM_EMULATE                                           = 1'b0, //To be modified as macro
    parameter          NUM_LANES                                             = 1, 
    parameter          TX_ENABLE                                             = 0,
    parameter          RX_ENABLE                                             = 0,
    parameter          TX_INITIATOR                                          = 1,
    parameter          RX_INITIATOR                                          = 1,
    parameter          TX_INITIATOR_INDEX                                    = 0,
    parameter          RX_INITIATOR_INDEX                                    = 0,
    parameter          TX_TARGET_ENABLE                                      = 0,
    parameter          RX_TARGET_ENABLE                                      = 0,
    parameter          TX_LANE_FUCTIONAL_MODE                                = 0, //v0.916
    parameter          RX_LANE_FUCTIONAL_MODE                                = 0, //v0.916
    parameter          NON_PTP_CHANNEL                                       = 1,
    parameter          TX_PCS_EN                                             = 1, //v0.916
    parameter          RX_PCS_EN                                             = 1, //v0.916
    parameter          UX_EN                                                 = 1,
    parameter          TX_DL_EN                                              = 1, //v0.916
    parameter          RX_DL_EN                                              = 1, //v0.916
    parameter          FLUX_USED_FOR_RX_ADAPTATION                           = 1,
    parameter          PTP_EN                                                = 0,
    parameter          TX_FEC_EN                                             = 1, //v0.916
    parameter          RX_FEC_EN                                             = 1, //v0.916
    parameter          ETHERNET_SYSPLL_CLK_MODE                              = 1,
    parameter          UX_USING_SYSPLL_CLK                                   = 1,
    parameter          FLUX_USING_SYSPLL_CLK                                 = 1,
    parameter          FLUX_EN                                               = 1,
    parameter          TX_LANE_RESET_STATE_POINTER                           = 72, //to be defined based on M20K 
    parameter          RX_LANE_RESET_STATE_POINTER                           = 188, // hip_ready instruction added v0.914
    parameter          TX_LANE_OPERATIONAL_STATE_POINTER                     = 175, //to be defined based on M20K 
    parameter          RX_LANE_OPERATIONAL_STATE_POINTER                     = 255, //to be defined based on M20K 
    parameter          TX_POINTER_COMPLETE_DR                                = 72, //to be defined based on M20K 
    parameter          RX_POINTER_COMPLETE_DR                                = 176, //to be defined based on M20K 
    parameter          TX_POINTER_DIGITAL_DR                                 = 112, //to be defined based on M20K 
    parameter          RX_POINTER_DIGITAL_DR                                 = 196, //to be defined based on M20K 
    parameter          RX_POINTER_LTD                                        = 196, //to be defined based on M20K
    parameter          SRC_LANE_INDEX                                        = 0,
    parameter          LEADER_LANE                                           = 0,
    parameter          SIM_SCALE_DOWN                                        = 0,
    //parameter          DEBUG_MODE                                            = 0, //added on 06 oct 2022 for debug mode
    parameter          TOTAL_INSTRUCTIONS                                    = 71 //PTP DL GB Restart v0.917

    

 )  (
    //SRC Lane Control Interface with SIP (or DR MUX)

    input  tri1 [0:0]       tx_lane_desired_state ,
    output      [1:0]       tx_lane_current_state ,                 
    output      [0:0]       tx_alarm ,                  
    input  tri0 [0:0]       tx_clear_alarm ,
    input  tri1 [0:0]       rx_lane_desired_state ,
    output      [1:0]       rx_lane_current_state , 
    output      [0:0]       rx_alarm ,  
    input  tri0 [0:0]       rx_clear_alarm ,
    input  tri0 [0:0]       sip_rx_ignore_lock2data ,
    input  tri0 [0:0]       sip_freeze_tx_SRC_sequence ,
    input  tri0 [0:0]       sip_freeze_rx_SRC_sequence ,
    output      [0:0]       sip_freeze_tx_acknowledge , 
    output      [0:0]       sip_freeze_rx_acknowledge , 
    output      [0:0]       sip_am_gen_start  , 
    input  tri0 [0:0]       sip_am_gen_2x_ack  ,
    
    //Reset/Status Interface to HIP
    output   reg   [0:0]       ptp_pld_adapter_tx_pld_rst_n ,                  
    output   reg   [0:0]       ptp_pld_adapter_rx_pld_rst_n ,                  
    output   reg   [0:0]       ptp_pld_ready ,                 
    output   reg   [0:0]       ptp_rst_n ,                 
    output   reg   [0:0]       pld_adapter_tx_pld_rst_n ,                  
    output   reg   [0:0]       pld_adapter_rx_pld_rst_n ,                  
    output   reg   [0:0]       ehip_tx_rst_n ,                 
    output   reg   [0:0]       ehip_rx_rst_n ,                 
    output   reg   [0:0]       tx_pcs_sfrz_n ,                 
    output   reg   [0:0]       rx_mac_deskew_sfrz_n ,                  
    output   reg   [0:0]       tx_deskew_sfrz_n ,                  
    output   reg   [0:0]       fec_tx_rst_n ,                  
    output   reg   [0:0]       fec_rx_rst_n ,                  
    output   reg   [0:0]       fec_csr_ret ,                   
    output   reg   [0:0]       tx_fec_sfrz_n ,                 
    output   reg   [0:0]       rx_fec_sfrz_n ,                 
    output   reg   [0:0]       xcvrif_tx_rst_n ,                   
    output   reg   [0:0]       xcvrif_rx_rst_n ,                   
    output   reg   [0:0]       tx_xcvrif_sfrz_n ,                  
    output   reg   [0:0]       rx_xcvrif_sfrz_n ,                  
    output   reg   [0:0]       xcvrif_signal_ok  ,                 
    output   reg   [0:0]       ux_tx_pma_rst_n ,                   
    output   reg   [0:0]       ux_rx_pma_rst_n ,                   
    output   reg   [0:0]       ux_rx_sfrz_n ,                  
    output   reg   [0:0]       iflux_ingress_direct_231 ,  //rename signal comment in HAS 0.5             
    output   reg   [0:0]       ehip_signal_ok ,            
    output   reg   [0:0]       pld_ready , 
    input          [0:0]       o_rx_pcs_fully_aligned  ,  
    input          [0:0]       ux_octl_pcs_txstatus  ,
    input          [0:0]       ux_octl_pcs_rxstatus  ,
    input          [0:0]       ux_all_synthlockstatus  ,
    input          [0:0]       ux_rxcdrlockstatus  ,
    input          [0:0]       ux_rxcdrlock2data  ,
    input          [0:0]       flux_cpi_cmn_busy  ,
    input          [0:0]       oflux_rx_srds_rdy  ,
    input          [0:0]       c0_syspll_lockstatus  ,
    input          [0:0]       c1_syspll_lockstatus  ,
    input          [0:0]       c2_syspll_lockstatus  ,
    input          [0:0]       o_fec_rx_rdy_n   ,
    input          [0:0]       hip_ready   , //v0.913
    
    //Inter SRC Lane Interface
    
    input  tri0 [NUM_LANES-1:0]   i_sl2l_trigger_or_error_resp   ,
    input  tri0 [NUM_LANES-1:0]   i_sl2l_desired_state_or_ready  ,
    input  tri0 [NUM_LANES-1:0]   i_sl2l_tx_rx                   ,   
    output      [NUM_LANES-1:0]   o_sl2l_error_resp_or_trigger   ,                    
    output      [NUM_LANES-1:0]   o_sl2l_ready_or_desired_state  ,                   
    output      [NUM_LANES-1:0]   o_sl2l_tx_rx                   ,
    
    //DR Controller Interface

    input       [0:0]       csr_clk ,
    input       [0:0]       pause_request  ,
    output      [0:0]       pause_grant ,
    input       [20:0]      dr_csr_addr  , //v0.915
    input       [3:0]       dr_csr_be    ,
    input       [0:0]       dr_csr_write ,
    input       [0:0]       dr_csr_read  ,
    input       [31:0]      dr_csr_wdata ,
    output      [31:0]      dr_csr_rdata ,
    output      [0:0]       dr_csr_waitrequest,
    output      [0:0]       dr_csr_rdata_valid,   
    //SRC Shoreline Sequencer Interface
    
    output      [0:0]       sss_req ,   
    input       [0:0]       sss_grant,

    //HAL
    output      [0:0]       src_clk, // Connecting to i_hio_pld_reset_clk_row on HAL

    //SRC FSM
    input tri0 [NUM_LANES-1:0]  i_addr_gen_common_block_rst_done_reg,
    output                      o_addr_gen_common_block_rst_done_reg
    
);


//---------------------------------------- Register and Wire declaration----------------------------------- 
//SRC Synchronizer 
                
wire [0:0]     sync_sss_grant                  ;                   
wire [0:0]     sync_pause_request              ;                   
wire [0:0]     sync_hip_ready                  ;   //v0.912                
wire [0:0]     sync_o_fec_rx_rdy_n             ;                   
wire [0:0]     sync_c2_syspll_lockstatus       ;                  
wire [0:0]     sync_c1_syspll_lockstatus       ;                  
wire [0:0]     sync_c0_syspll_lockstatus       ;                  
wire [0:0]     sync_oflux_rx_srds_rdy          ;                   
wire [0:0]     sync_flux_cpi_cmn_busy          ;                   
wire [0:0]     sync_ux_rxcdrlock2data          ;                   
wire [0:0]     sync_ux_rxcdrlockstatus         ;                   
wire [0:0]     sync_ux_all_synthlockstatus     ;                   
wire [0:0]     sync_ux_octl_pcs_rxstatus       ;                  
wire [0:0]     sync_ux_octl_pcs_txstatus       ;                   
wire [0:0]     sync_o_rx_pcs_fully_aligned     ;                   
wire [0:0]     sync_sip_am_gen_2x_ack          ;            
wire [0:0]     sync_sip_freeze_rx_SRC_sequence ;                   
wire [0:0]     sync_sip_freeze_tx_SRC_sequence ;                   
wire [0:0]     sync_sip_rx_ignore_lock2data    ;                   
wire [0:0]     sync_rx_clear_alarm             ;            
wire [0:0]     sync_rx_lane_desired_state      ;            
wire [0:0]     sync_tx_clear_alarm             ;            
wire [0:0]     sync_tx_lane_desired_state      ;    

//SRC CSR
wire [31:0]     w_src_role_cfg                 ;    
wire [31:0]     w_src_target_enable            ;
wire [31:0]     w_src_functional_mode_cnf      ;
wire [31:0]     w_src_reset_drive_reg          ; //v0.911

//SRC Flow control
reg             all_lane_cmn_rsrc_done         ; //v0.916

//------------------------ Debug port Register and Wire declaration-------------------------------------//
reg [31:0]      reg_debug_src_reset  ;

wire [0:0] w_pld_adapter_tx_pld_rst_n     ;
wire [0:0] w_pld_adapter_rx_pld_rst_n     ;
wire [0:0] w_ehip_tx_rst_n                ;
wire [0:0] w_ehip_rx_rst_n                ;
wire [0:0] w_tx_pcs_sfrz_n                ;
wire [0:0] w_rx_mac_deskew_sfrz_n         ;
wire [0:0] w_tx_deskew_sfrz_n             ;
wire [0:0] w_fec_tx_rst_n                 ;
wire [0:0] w_fec_rx_rst_n                 ;
wire [0:0] w_fec_csr_ret                  ;
wire [0:0] w_tx_fec_sfrz_n                ;
wire [0:0] w_rx_fec_sfrz_n                ;
wire [0:0] w_xcvrif_tx_rst_n              ;
wire [0:0] w_xcvrif_rx_rst_n              ;
wire [0:0] w_tx_xcvrif_sfrz_n             ;
wire [0:0] w_rx_xcvrif_sfrz_n             ;
wire [0:0] w_xcvrif_signal_ok             ;
wire [0:0] w_ux_tx_pma_rst_n              ;
wire [0:0] w_ux_rx_pma_rst_n              ;
wire [0:0] w_ux_rx_sfrz_n                 ;
wire [0:0] w_iflux_ingress_direct_231     ;
wire [0:0] w_ehip_signal_ok               ;
wire [0:0] w_pld_ready                    ;
wire [0:0] w_ptp_pld_adapter_tx_pld_rst_n ;
wire [0:0] w_ptp_pld_adapter_rx_pld_rst_n ;
wire [0:0] w_ptp_pld_ready                ;
wire [0:0] w_ptp_rst_n                    ;

//-------------------------------------------------------------------------------------------------
// Clock and Reset Generation for SRC - To be enabled  after clock component support provided for SM
// //hsd case: 16018567825
// v0.915 - Added clock and reset internal to SRC lane
//-------------------------------------------------------------------------------------------------
localparam RESET_CLK_COUNT = 32 ;
   (* preserve *) logic clk;
   (* preserve *) logic sclr;
   (* preserve *) logic sclr_in;
   (* preserve *) logic [31:0] sclr_count = 'b0;

   always @ (posedge clk) begin :  reset_count
      if (sclr_count == RESET_CLK_COUNT) begin : count_complete
         sclr <= 1'b0;
         sclr_count <= sclr_count;
      end : count_complete
      else begin : count_incomplete
         if (sclr_in == 0) begin : sclr_in_deasserted
            sclr_count <= sclr_count + 1;
            sclr <= 1'b1;
         end : sclr_in_deasserted
         else begin : sclr_in_asserted
            sclr <= 1'b1;
            sclr_count <= 'b0;
         end : sclr_in_asserted
      end : count_incomplete
   end : reset_count


`ifndef ALTERA_RESERVED_QIS //V0.921 - Macro for simulation
    always begin
    `ifdef SIM_125MHz
         #4ns clk = ~clk; //125MHz
    `else   
         #50ps clk = ~clk; //10GHz
    `endif
    end

    initial begin
        clk = 1'b0;
        sclr_in = 1'b1;
    `ifdef SIM_125MHz //v0.943
        #100ns sclr_in = 1'b0;
    `else
        #250ps sclr_in = 1'b0;
    `endif
    end
`else
    wire  osc_clk;
    reg  divided_osc_clk = 1'b0 ; /* synthesis preserve */

    altera_config_clock_source_endpoint clock_endpoint (
        .clk(osc_clk)
        );

    // Dividing SDM oscillator clock frequency in half  -> to check clock frequency for SM
    always @(posedge osc_clk) begin
       if (sclr_in) begin
            divided_osc_clk <= 1'b0;
       end else begin
          divided_osc_clk <= ~divided_osc_clk;
       end
    end

    assign clk = divided_osc_clk;

    altera_agilex_config_reset_release_endpoint rst_release_ip_inst (
        .conf_reset  (sclr_in)
        );
`endif

//---------------------------------------- Wire assignments  -----------------------------------

assign src_clk = clk;

//-------------------------------------------------------------------------------------------------
//Start Reset sequence only after common resource bringup is complete for all lanes in QHIP
//v0.915 - Added clock and reset internal to SRC lane
//-------------------------------------------------------------------------------------------------
always @(posedge clk) begin
    if (sclr)
        all_lane_cmn_rsrc_done <= 1'b0;
    else
        all_lane_cmn_rsrc_done <= &i_addr_gen_common_block_rst_done_reg;
end
//-------------------------------------------------------------------------------------------------
// SRC debug port block  
//-------------------------------------------------------------------------------------------------

always @(posedge clk) 
begin

    if(sclr)
      begin
        pld_adapter_tx_pld_rst_n      <= 1'b0 ;
        pld_adapter_rx_pld_rst_n      <= 1'b0 ;
        ehip_tx_rst_n                 <= 1'b0 ;
        ehip_rx_rst_n                 <= 1'b0 ;
        tx_pcs_sfrz_n                 <= 1'b0 ;
        rx_mac_deskew_sfrz_n          <= 1'b0 ;
        tx_deskew_sfrz_n              <= 1'b0 ;
        fec_tx_rst_n                  <= 1'b0 ;
        fec_rx_rst_n                  <= 1'b0 ;
        fec_csr_ret                   <= 1'b0 ;
        tx_fec_sfrz_n                 <= 1'b0 ;
        rx_fec_sfrz_n                 <= 1'b0 ;
        xcvrif_tx_rst_n               <= 1'b0 ;
        xcvrif_rx_rst_n               <= 1'b0 ;
        tx_xcvrif_sfrz_n              <= 1'b0 ;
        rx_xcvrif_sfrz_n              <= 1'b0 ;
        xcvrif_signal_ok              <= 1'b0 ;
        ux_tx_pma_rst_n               <= 1'b0 ;
        ux_rx_pma_rst_n               <= 1'b0 ;
        ux_rx_sfrz_n                  <= 1'b0 ;
        iflux_ingress_direct_231      <= 1'b0 ;
        ehip_signal_ok                <= 1'b0 ;
        pld_ready                     <= 1'b0 ;
        ptp_pld_adapter_tx_pld_rst_n  <= 1'b0 ;
        ptp_pld_adapter_rx_pld_rst_n  <= 1'b0 ;
        ptp_pld_ready                 <= 1'b0 ;
        ptp_rst_n                     <= 1'b0 ;
        end
`ifdef SRC_DEBUG_MODE        
    else if (w_src_reset_drive_reg[0]) begin//0-disabled 1-enabled
        pld_adapter_tx_pld_rst_n      <= w_src_reset_drive_reg[27] ;
        pld_adapter_rx_pld_rst_n      <= w_src_reset_drive_reg[26] ;
        ehip_tx_rst_n                 <= w_src_reset_drive_reg[25] ;
        ehip_rx_rst_n                 <= w_src_reset_drive_reg[24] ;
        tx_pcs_sfrz_n                 <= w_src_reset_drive_reg[23] ;
        rx_mac_deskew_sfrz_n          <= w_src_reset_drive_reg[22] ;
        tx_deskew_sfrz_n              <= w_src_reset_drive_reg[21] ;
        fec_tx_rst_n                  <= w_src_reset_drive_reg[20] ;
        fec_rx_rst_n                  <= w_src_reset_drive_reg[19] ;
        fec_csr_ret                   <= w_src_reset_drive_reg[18] ;
        tx_fec_sfrz_n                 <= w_src_reset_drive_reg[17] ;
        rx_fec_sfrz_n                 <= w_src_reset_drive_reg[16] ;
        xcvrif_tx_rst_n               <= w_src_reset_drive_reg[15] ;
        xcvrif_rx_rst_n               <= w_src_reset_drive_reg[14] ;
        tx_xcvrif_sfrz_n              <= w_src_reset_drive_reg[13] ;
        rx_xcvrif_sfrz_n              <= w_src_reset_drive_reg[12] ;
        xcvrif_signal_ok              <= w_src_reset_drive_reg[11] ;
        ux_tx_pma_rst_n               <= w_src_reset_drive_reg[10] ;
        ux_rx_pma_rst_n               <= w_src_reset_drive_reg[9] ;
        ux_rx_sfrz_n                  <= w_src_reset_drive_reg[8] ;
        iflux_ingress_direct_231      <= w_src_reset_drive_reg[7] ;
        ehip_signal_ok                <= w_src_reset_drive_reg[6] ;
        pld_ready                     <= w_src_reset_drive_reg[5] ;
        ptp_pld_adapter_tx_pld_rst_n  <= w_src_reset_drive_reg[4] ;
        ptp_pld_adapter_rx_pld_rst_n  <= w_src_reset_drive_reg[3] ;
        ptp_pld_ready                 <= w_src_reset_drive_reg[2] ;
        ptp_rst_n                     <= w_src_reset_drive_reg[1] ;
        end 
    else begin
        pld_adapter_tx_pld_rst_n      <= w_pld_adapter_tx_pld_rst_n     ;
        pld_adapter_rx_pld_rst_n      <= w_pld_adapter_rx_pld_rst_n     ;
        ehip_tx_rst_n                 <= w_ehip_tx_rst_n                ;
        ehip_rx_rst_n                 <= w_ehip_rx_rst_n                ;
        tx_pcs_sfrz_n                 <= w_tx_pcs_sfrz_n                ;
        rx_mac_deskew_sfrz_n          <= w_rx_mac_deskew_sfrz_n         ;
        tx_deskew_sfrz_n              <= w_tx_deskew_sfrz_n             ;
        fec_tx_rst_n                  <= w_fec_tx_rst_n                 ;
        fec_rx_rst_n                  <= w_fec_rx_rst_n                 ;
        fec_csr_ret                   <= w_fec_csr_ret                  ;
        tx_fec_sfrz_n                 <= w_tx_fec_sfrz_n                ;
        rx_fec_sfrz_n                 <= w_rx_fec_sfrz_n                ;
        xcvrif_tx_rst_n               <= w_xcvrif_tx_rst_n              ;
        xcvrif_rx_rst_n               <= w_xcvrif_rx_rst_n              ;
        tx_xcvrif_sfrz_n              <= w_tx_xcvrif_sfrz_n             ;
        rx_xcvrif_sfrz_n              <= w_rx_xcvrif_sfrz_n             ;
        xcvrif_signal_ok              <= w_xcvrif_signal_ok             ;
        ux_tx_pma_rst_n               <= w_ux_tx_pma_rst_n              ;
        ux_rx_pma_rst_n               <= w_ux_rx_pma_rst_n              ;
        ux_rx_sfrz_n                  <= w_ux_rx_sfrz_n                 ;
        iflux_ingress_direct_231      <= w_iflux_ingress_direct_231     ;
        ehip_signal_ok                <= w_ehip_signal_ok               ;
        pld_ready                     <= w_pld_ready                    ;
        ptp_pld_adapter_tx_pld_rst_n  <= w_ptp_pld_adapter_tx_pld_rst_n ;
        ptp_pld_adapter_rx_pld_rst_n  <= w_ptp_pld_adapter_rx_pld_rst_n ;
        ptp_pld_ready                 <= w_ptp_pld_ready                ;
        ptp_rst_n                     <= w_ptp_rst_n                    ;
       end   
     
`else
    else begin
        pld_adapter_tx_pld_rst_n        <= w_pld_adapter_tx_pld_rst_n    ;
        pld_adapter_rx_pld_rst_n        <= w_pld_adapter_rx_pld_rst_n    ;
        ehip_tx_rst_n                   <= w_ehip_tx_rst_n               ;
        ehip_rx_rst_n                   <= w_ehip_rx_rst_n               ;
        tx_pcs_sfrz_n                   <= w_tx_pcs_sfrz_n               ;
        rx_mac_deskew_sfrz_n            <= w_rx_mac_deskew_sfrz_n        ;
        tx_deskew_sfrz_n                <= w_tx_deskew_sfrz_n            ;
        fec_tx_rst_n                    <= w_fec_tx_rst_n                ;
        fec_rx_rst_n                    <= w_fec_rx_rst_n                ;
        fec_csr_ret                     <= w_fec_csr_ret                 ;
        tx_fec_sfrz_n                   <= w_tx_fec_sfrz_n               ;
        rx_fec_sfrz_n                   <= w_rx_fec_sfrz_n               ;
        xcvrif_tx_rst_n                 <= w_xcvrif_tx_rst_n             ;
        xcvrif_rx_rst_n                 <= w_xcvrif_rx_rst_n             ;
        tx_xcvrif_sfrz_n                <= w_tx_xcvrif_sfrz_n            ;
        rx_xcvrif_sfrz_n                <= w_rx_xcvrif_sfrz_n            ;
        xcvrif_signal_ok                <= w_xcvrif_signal_ok            ;
        ux_tx_pma_rst_n                 <= w_ux_tx_pma_rst_n             ;
        ux_rx_pma_rst_n                 <= w_ux_rx_pma_rst_n             ;
        ux_rx_sfrz_n                    <= w_ux_rx_sfrz_n                ;
        iflux_ingress_direct_231        <= w_iflux_ingress_direct_231    ;
        ehip_signal_ok                  <= w_ehip_signal_ok              ;
        pld_ready                       <= w_pld_ready                   ;
        ptp_pld_adapter_tx_pld_rst_n    <= w_ptp_pld_adapter_tx_pld_rst_n;
        ptp_pld_adapter_rx_pld_rst_n    <= w_ptp_pld_adapter_rx_pld_rst_n;
        ptp_pld_ready                   <= w_ptp_pld_ready               ;
        ptp_rst_n                       <= w_ptp_rst_n                   ;
    end        
`endif
end
//-------------------------------------------------------------------------------------------------
// SRC Synchronizer module instantiation 
//-------------------------------------------------------------------------------------------------

intel_src_synchronizers #(
    .IN_WIDTH   (23)
) src_sync_inst (

    .clk (clk), 
    .s_sm_src_sync_in ({                 
                       sss_grant,                 
                       pause_request,
                       hip_ready,
                       o_fec_rx_rdy_n,                      
                       c2_syspll_lockstatus,      
                       c1_syspll_lockstatus,      
                       c0_syspll_lockstatus,      
                       oflux_rx_srds_rdy,         
                       flux_cpi_cmn_busy,         
                       ux_rxcdrlock2data,         
                       ux_rxcdrlockstatus,        
                       ux_all_synthlockstatus,    
                       ux_octl_pcs_rxstatus,      
                       ux_octl_pcs_txstatus,      
                       o_rx_pcs_fully_aligned,    
                       sip_am_gen_2x_ack,           
                       sip_freeze_rx_SRC_sequence,
                       sip_freeze_tx_SRC_sequence,
                       sip_rx_ignore_lock2data,   
                       rx_clear_alarm,              
                       rx_lane_desired_state,       
                       tx_clear_alarm,              
                       tx_lane_desired_state} ),    
    .s_sm_src_sync_out ({                 
                       sync_sss_grant,                 
                       sync_pause_request,
                       sync_hip_ready,
                       sync_o_fec_rx_rdy_n,            
                       sync_c2_syspll_lockstatus,      
                       sync_c1_syspll_lockstatus,      
                       sync_c0_syspll_lockstatus,      
                       sync_oflux_rx_srds_rdy,         
                       sync_flux_cpi_cmn_busy,         
                       sync_ux_rxcdrlock2data,         
                       sync_ux_rxcdrlockstatus,        
                       sync_ux_all_synthlockstatus,    
                       sync_ux_octl_pcs_rxstatus,      
                       sync_ux_octl_pcs_txstatus,      
                       sync_o_rx_pcs_fully_aligned,    
                       sync_sip_am_gen_2x_ack,          
                       sync_sip_freeze_rx_SRC_sequence,
                       sync_sip_freeze_tx_SRC_sequence,
                       sync_sip_rx_ignore_lock2data,   
                       sync_rx_clear_alarm,             
                       sync_rx_lane_desired_state,      
                       sync_tx_clear_alarm,             
                       sync_tx_lane_desired_state} )
);

//-------------------------------------------------------------------------------------------------
// SRC CSR module instantiation 
//-------------------------------------------------------------------------------------------------
intel_src_csr
#(
    .TX_ENABLE                         (TX_ENABLE                           ),                   
    .RX_ENABLE                         (RX_ENABLE                           ),
    .TX_INITIATOR                      (TX_INITIATOR                        ),
    .RX_INITIATOR                      (RX_INITIATOR                        ),
    .TX_INITIATOR_INDEX                (TX_INITIATOR_INDEX                  ),
    .RX_INITIATOR_INDEX                (RX_INITIATOR_INDEX                  ),
    .TX_TARGET_ENABLE                  (TX_TARGET_ENABLE                    ),
    .RX_TARGET_ENABLE                  (RX_TARGET_ENABLE                    ),
    .TX_LANE_FUCTIONAL_MODE            (TX_LANE_FUCTIONAL_MODE              ),
    .RX_LANE_FUCTIONAL_MODE            (RX_LANE_FUCTIONAL_MODE              ),
    .NON_PTP_CHANNEL                   (NON_PTP_CHANNEL                     ),
    .TX_PCS_EN                         (TX_PCS_EN                           ),
    .RX_PCS_EN                         (RX_PCS_EN                           ),
    .UX_EN                             (UX_EN                               ),
    .TX_DL_EN                          (TX_DL_EN                            ),
    .RX_DL_EN                          (RX_DL_EN                            ),
    .FLUX_USED_FOR_RX_ADAPTATION       (FLUX_USED_FOR_RX_ADAPTATION         ),
    .PTP_EN                            (PTP_EN                              ),
    .TX_FEC_EN                         (TX_FEC_EN                           ),
    .RX_FEC_EN                         (RX_FEC_EN                           ),
    .ETHERNET_SYSPLL_CLK_MODE          (ETHERNET_SYSPLL_CLK_MODE            ),
    .UX_USING_SYSPLL_CLK               (UX_USING_SYSPLL_CLK                 ),
    .FLUX_USING_SYSPLL_CLK             (FLUX_USING_SYSPLL_CLK               ),
    .FLUX_EN                           (FLUX_EN                             ),
    .LEADER_LANE                       (LEADER_LANE                         )

) sm_src_csr (
       .csr_clk                   (csr_clk)                       ,
       .sclr                      (sclr)                          ,
       .dr_csr_write              (dr_csr_write      )            ,    
       .dr_csr_read               (dr_csr_read      )             ,
       .dr_csr_be                 (dr_csr_be      )               ,
       .dr_csr_addr               (dr_csr_addr    )               ,
       .dr_csr_wdata              (dr_csr_wdata   )               ,
       .dr_csr_rdata              (dr_csr_rdata        )          ,
       .dr_csr_rdata_valid        (dr_csr_rdata_valid        )    ,
       .dr_csr_waitrequest        (dr_csr_waitrequest  )          ,
       .src_role_cfg              (w_src_role_cfg           )     ,
       .src_target_enable         (w_src_target_enable      )     ,
       .src_functional_mode_cnf   (w_src_functional_mode_cnf)     ,
`ifdef SRC_DEBUG_MODE
       .src_reset_drive_reg       (w_src_reset_drive_reg      )   , //v0.911
       .src_debug_status_reg      (32'd0                      )   , //v0.912
`endif
       .tx_lane_current_state     (tx_lane_current_state)         ,
       .rx_lane_current_state     (rx_lane_current_state)
);


//-------------------------------------------------------------------------------------------------
// SRC Flow control  module instantiation 
//-------------------------------------------------------------------------------------------------

intel_src_flow_ctrl
 #(
    .NUM_LANES          (NUM_LANES) ,
    .SRC_LANE_INDEX     (SRC_LANE_INDEX),
    .SIM_SCALE_DOWN     (SIM_SCALE_DOWN),
    .RX_START_ADDR      (RX_LANE_RESET_STATE_POINTER) ,
    .TX_START_ADDR      (TX_LANE_RESET_STATE_POINTER) ,
    .TOTAL_INSTRUCTIONS (TOTAL_INSTRUCTIONS)
    
 ) src_flow_ctrl (
    .clk                    (clk  ),
    .sclr                   (sclr ),
    
    //SRC Lane Control Interface with SIP (or DR MUX)
    .sync_tx_lane_desired_state             (sync_tx_lane_desired_state     ),
    .tx_lane_current_state                  (tx_lane_current_state          ),                 
    .tx_alarm                               (tx_alarm                       ),                  
    .sync_tx_clear_alarm                    (sync_tx_clear_alarm            ),
    .sync_rx_lane_desired_state             (sync_rx_lane_desired_state     ),
    .rx_lane_current_state                  (rx_lane_current_state          ), 
    .rx_alarm                               (rx_alarm                       ),  
    .sync_rx_clear_alarm                    (sync_rx_clear_alarm            ),
    .sync_sip_rx_ignore_lock2data           (sync_sip_rx_ignore_lock2data   ),
    .sync_sip_freeze_tx_SRC_sequence        (sync_sip_freeze_tx_SRC_sequence),
    .sync_sip_freeze_rx_SRC_sequence        (sync_sip_freeze_rx_SRC_sequence),
    .sip_freeze_tx_acknowledge              (sip_freeze_tx_acknowledge      ), 
    .sip_freeze_rx_acknowledge              (sip_freeze_rx_acknowledge      ), 
    .sip_am_gen_start                       (sip_am_gen_start               ), 
    .sync_sip_am_gen_2x_ack                 (sync_sip_am_gen_2x_ack         ),   
 
    //Reset/Status Interface to HIP
    
    .ptp_pld_adapter_tx_pld_rst_n           (w_ptp_pld_adapter_tx_pld_rst_n   ),                  
    .ptp_pld_adapter_rx_pld_rst_n           (w_ptp_pld_adapter_rx_pld_rst_n   ),                  
    .ptp_pld_ready                          (w_ptp_pld_ready                  ),                 
    .ptp_rst_n                              (w_ptp_rst_n                      ),                 
    .pld_adapter_tx_pld_rst_n               (w_pld_adapter_tx_pld_rst_n       ),                  
    .pld_adapter_rx_pld_rst_n               (w_pld_adapter_rx_pld_rst_n       ),                  
    .ehip_tx_rst_n                          (w_ehip_tx_rst_n                  ),                 
    .ehip_rx_rst_n                          (w_ehip_rx_rst_n                  ),                 
    .tx_pcs_sfrz_n                          (w_tx_pcs_sfrz_n                  ),                 
    .rx_mac_deskew_sfrz_n                   (w_rx_mac_deskew_sfrz_n           ),                  
    .tx_deskew_sfrz_n                       (w_tx_deskew_sfrz_n               ),                  
    .fec_tx_rst_n                           (w_fec_tx_rst_n                   ),                  
    .fec_rx_rst_n                           (w_fec_rx_rst_n                   ),                  
    .fec_csr_ret                            (w_fec_csr_ret                    ),                   
    .tx_fec_sfrz_n                          (w_tx_fec_sfrz_n                  ),                 
    .rx_fec_sfrz_n                          (w_rx_fec_sfrz_n                  ),                 
    .xcvrif_tx_rst_n                        (w_xcvrif_tx_rst_n                ),                   
    .xcvrif_rx_rst_n                        (w_xcvrif_rx_rst_n                ),                   
    .tx_xcvrif_sfrz_n                       (w_tx_xcvrif_sfrz_n               ),                  
    .rx_xcvrif_sfrz_n                       (w_rx_xcvrif_sfrz_n               ),                  
    .xcvrif_signal_ok                       (w_xcvrif_signal_ok               ),                 
    .ux_tx_pma_rst_n                        (w_ux_tx_pma_rst_n                ),                   
    .ux_rx_pma_rst_n                        (w_ux_rx_pma_rst_n                ),                   
    .ux_rx_sfrz_n                           (w_ux_rx_sfrz_n                   ),                  
    .iflux_ingress_direct_231               (w_iflux_ingress_direct_231       ),         
    .ehip_signal_ok                         (w_ehip_signal_ok                 ),            
    .pld_ready                              (w_pld_ready                      ), 
    .sync_o_rx_pcs_fully_aligned            (sync_o_rx_pcs_fully_aligned    ),  
    .sync_ux_octl_pcs_txstatus              (sync_ux_octl_pcs_txstatus      ),
    .sync_ux_octl_pcs_rxstatus              (sync_ux_octl_pcs_rxstatus      ),
    .sync_ux_all_synthlockstatus            (sync_ux_all_synthlockstatus    ),
    .sync_ux_rxcdrlockstatus                (sync_ux_rxcdrlockstatus        ),
    .sync_ux_rxcdrlock2data                 (sync_ux_rxcdrlock2data         ),
    .sync_flux_cpi_cmn_busy                 (sync_flux_cpi_cmn_busy         ),
    .sync_oflux_rx_srds_rdy                 (sync_oflux_rx_srds_rdy         ),
    .sync_c0_syspll_lockstatus              (sync_c0_syspll_lockstatus      ),
    .sync_c1_syspll_lockstatus              (sync_c1_syspll_lockstatus      ),
    .sync_c2_syspll_lockstatus              (sync_c2_syspll_lockstatus      ),
    .sync_o_fec_rx_rdy_n                    (sync_o_fec_rx_rdy_n            ),
    .sync_hip_ready                         (sync_hip_ready                 ),
    
    
    //DR Controller Interface
    .sync_pause_request                     (sync_pause_request             ),     
    .pause_grant                            (pause_grant                    ),
    
    //SRC Lane to lane interface
    .sl2l_trigger_or_error_resp_in          (i_sl2l_trigger_or_error_resp   ),
    .sl2l_desired_state_or_ready_in         (i_sl2l_desired_state_or_ready  ),
    .sl2l_tx_rx_in                          (i_sl2l_tx_rx                   ),   
    .sl2l_error_resp_or_trigger_out         (o_sl2l_error_resp_or_trigger   ), 
    .sl2l_ready_or_desired_state_out        (o_sl2l_ready_or_desired_state  ),
    .sl2l_tx_rx_out                         (o_sl2l_tx_rx                   ),
    
    //SRC CSR Interface
    .src_role_cfg                           (w_src_role_cfg           ),               
    .src_target_enable                      (w_src_target_enable      ),              
    .src_functional_mode_cnf                (w_src_functional_mode_cnf),

    //SRC Shoreline Sequencer Interface
    .sync_sss_grant                         (sync_sss_grant),       
    .sss_req                                (sss_req       ),
    //SRC FSM
    .all_lane_cmn_rsrc_done                 (all_lane_cmn_rsrc_done               ),
    .w_addr_gen_common_block_rst_done_reg   (o_addr_gen_common_block_rst_done_reg )
);
endmodule

//--------------------------------------------------------------------------------------------------------------------------
// Version             |  Changes                                                       | Date          | Owner ID
//--------------------------------------------------------------------------------------------------------------------------
//   0.0               |                                                                |               |
//   0.1               | Initial code                                                   |  17-Jun-2022  | skgr 
//   0.2               | Update as per SM SRC HAS 0.8 RC                                |  24-Jun-2022  | skgr                           
//   0.3               | Update CSR and flow control top, changed SIM_EMULATE to macro  |  27-Jun-2022  | skgr
//   0.4               | Updated CSR Port names based on HAS                            |  08-Jul-2022  | skgr
//   0.5               | Code optimization of DR CSR Registers sync                     |  01-Aug-2022  | skgr 
//   0.6               | Update of src_status_reg as in Sec 10.2.4                      |  18-Aug-2022  | skgr                          
//   0.7               | Added common rsrc done ip and output for FSM                   |  28-Sep-2022  | cvignesh
//   0.8               | Added debug ports                                              |  14-Oct-2022  | skgr
//   0.9               | Added DR AVMM ports                                            |  14-Oct-2022  | sushilsh
//   0.91              | Added DR AVMM address width 22                                 |  24-Nov-2022  | skgr
//   0.911             | Debug ports modified to debug registers in CSR                 |  20-Feb-2023  | skgr
//   0.912             | VLIW Address Parameters brought out to SRC Wrapper             |  22-Feb-2023  | skgr
//                     | Removed SIM_EMULATE , replaced by ALTERA_QIS_RESERVED Macro    |               |
//                     | Removed DEBUG_MODE parameter , replaced by SRC_DEBUG_MODE macro|               |
//                     | added src_debug_status_reg input for Debug                     |               |             
//   0.913             | HSD:16020176490 hip_ready added to SRC Spec                    |  04-Apr-2023  | skgr            
//   0.914             | Parameters moved internally to SRC lane, removed on NCSS       |  20-Apr-2023  | skgr   
//   0.915             | Edited DR AVMM width to 21                                     |  25-May-2023  | skgr
//   0.916             | HSD :  All Common resource done logic                          |  31-May-2023  | skgr
//                     | Clock and reset internally moved to SRC lane                   |               |   
//                     | Lane2lane IF port modified                                     |               | 
//                     | Sepatated parameter for TX RX for Dual simplex                 |               |
//   0.917             |HSD:14019867282 PTP DL GB Restart- delay added                  |  25-Sep-2023  | skgr 
//--------------------------------------------------------------------------------------------------------------------------
