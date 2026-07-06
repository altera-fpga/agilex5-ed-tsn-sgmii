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
// File Name   : intel_src_flow_ctrl.sv
// Project     : SRC
// Version     : 0.86
// Description : SRC Flow Control consists of following to execute HSSI (NonPCIe) Reset sequencing
//              1.Reset FSM
//              2.SRC Lane2Lane
//              3.SRC spec M20K          
//              4.Address generation for SRC spec M20K 
//              5.SRC Monitor
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
module intel_src_flow_ctrl
 #(
    parameter   SIM_EMULATE = 1 ,
    parameter   NUM_LANES = 1 ,
    parameter   SRC_LANE_INDEX = 0,
    parameter   SIM_SCALE_DOWN = 0 ,
    parameter   RX_START_ADDR  = 176 ,
    parameter   TX_START_ADDR  = 72 ,
    parameter   TOTAL_INSTRUCTIONS = 64     
 ) (
    input               clk     ,
    input               sclr    ,
    
    //SRC Lane Control Interface with SIP (or DR MUX)
    input       [0:0]               sync_tx_lane_desired_state ,
    output      [1:0]               tx_lane_current_state ,                 
    output      [0:0]               tx_alarm ,                  
    input       [0:0]               sync_tx_clear_alarm ,
    input       [0:0]               sync_rx_lane_desired_state ,
    output      [1:0]               rx_lane_current_state , 
    output      [0:0]               rx_alarm ,  
    input       [0:0]               sync_rx_clear_alarm ,
    input       [0:0]               sync_sip_rx_ignore_lock2data ,
    input       [0:0]               sync_sip_freeze_tx_SRC_sequence ,
    input       [0:0]               sync_sip_freeze_rx_SRC_sequence ,
    output      [0:0]               sip_freeze_tx_acknowledge , 
    output      [0:0]               sip_freeze_rx_acknowledge , 
    output      [0:0]               sip_am_gen_start  , 
    input       [0:0]               sync_sip_am_gen_2x_ack  ,   
 
    //Reset/Status Interface to HIP
    
    output      [0:0]               ptp_pld_adapter_tx_pld_rst_n ,                  
    output      [0:0]               ptp_pld_adapter_rx_pld_rst_n ,                  
    output      [0:0]               ptp_pld_ready ,                 
    output      [0:0]               ptp_rst_n ,                 
    output      [0:0]               pld_adapter_tx_pld_rst_n ,                  
    output      [0:0]               pld_adapter_rx_pld_rst_n ,                  
    output      [0:0]               ehip_tx_rst_n ,                 
    output      [0:0]               ehip_rx_rst_n ,                 
    output      [0:0]               tx_pcs_sfrz_n ,                 
    output      [0:0]               rx_mac_deskew_sfrz_n ,                  
    output      [0:0]               tx_deskew_sfrz_n ,                  
    output      [0:0]               fec_tx_rst_n ,                  
    output      [0:0]               fec_rx_rst_n ,                  
    output      [0:0]               fec_csr_ret ,                   
    output      [0:0]               tx_fec_sfrz_n ,                 
    output      [0:0]               rx_fec_sfrz_n ,                 
    output      [0:0]               xcvrif_tx_rst_n ,                   
    output      [0:0]               xcvrif_rx_rst_n ,                   
    output      [0:0]               tx_xcvrif_sfrz_n ,                  
    output      [0:0]               rx_xcvrif_sfrz_n ,                  
    output      [0:0]               xcvrif_signal_ok  ,                 
    output      [0:0]               ux_tx_pma_rst_n ,                   
    output      [0:0]               ux_rx_pma_rst_n ,                   
    output      [0:0]               ux_rx_sfrz_n ,                  
    output      [0:0]               iflux_ingress_direct_231 ,         
    output      [0:0]               ehip_signal_ok ,            
    output      [0:0]               pld_ready , 
    input       [0:0]               sync_o_rx_pcs_fully_aligned  ,  
    input       [0:0]               sync_ux_octl_pcs_txstatus  ,
    input       [0:0]               sync_ux_octl_pcs_rxstatus  ,
    input       [0:0]               sync_ux_all_synthlockstatus  ,
    input       [0:0]               sync_ux_rxcdrlockstatus  ,
    input       [0:0]               sync_ux_rxcdrlock2data  ,
    input       [0:0]               sync_flux_cpi_cmn_busy  ,
    input       [0:0]               sync_oflux_rx_srds_rdy  ,
    input       [0:0]               sync_c0_syspll_lockstatus  ,
    input       [0:0]               sync_c1_syspll_lockstatus  ,
    input       [0:0]               sync_c2_syspll_lockstatus  ,
    input       [0:0]               sync_o_fec_rx_rdy_n   ,
    input       [0:0]               sync_hip_ready   , //v0.84
    
    
    //DR Controller Interface
    input       [0:0]               sync_pause_request  ,     
    output      [0:0]               pause_grant    ,
    
    //SRC Lane to lane interface
    input       [NUM_LANES-1:0]   sl2l_trigger_or_error_resp_in   ,
    input       [NUM_LANES-1:0]   sl2l_desired_state_or_ready_in  ,
    input       [NUM_LANES-1:0]   sl2l_tx_rx_in                   ,   
    output      [NUM_LANES-1:0]   sl2l_error_resp_or_trigger_out  , 
    output      [NUM_LANES-1:0]   sl2l_ready_or_desired_state_out ,
    output      [NUM_LANES-1:0]   sl2l_tx_rx_out                  ,
    
    //SRC CSR Interface
    input       [31:0]              src_role_cfg,               
    input       [31:0]              src_target_enable,              
    input       [31:0]              src_functional_mode_cnf,

    //SRC Shoreline Sequencer Interface
    input       [0:0]               sync_sss_grant  ,       
    output      [0:0]               sss_req,

    //SRC FSM
    input                           all_lane_cmn_rsrc_done,
    output                          w_addr_gen_common_block_rst_done_reg
    
 );
 
 
 
//---------------------------------------- Register and Wire declaration----------------------------------- 

//SRC FSM <-> SRC Lane2lane Interface 
 wire           [0:0]               w_sl2l_fsm_trigger_or_error_resp_in    ;
 wire           [0:0]               w_sl2l_fsm_error_resp_or_trigger_out   ;  
 wire           [0:0]               w_sl2l_fsm_stagger_within_en           ;  
 wire           [0:0]               w_sl2l_fsm_desired_state_or_ready_in   ;
 wire           [0:0]               w_sl2l_fsm_ready_or_desired_state_out  ;
 wire           [0:0]               w_sl2l_fsm_all_targets_done            ;
 wire           [0:0]               w_sl2l_fsm_tx_rx_in                    ;
 wire           [0:0]               w_sl2l_fsm_tx_rx_out                   ;
 wire           [1:0]               w_interleave_active                    ;
 wire           [0:0]               w_sl2l_tx_init_rst_done_for_err        ;
 wire           [0:0]               w_sl2l_rx_init_rst_done_for_err        ;
 wire           [0:0]               w_sl2l_target_tx_error_resp            ;
 wire           [0:0]               w_sl2l_target_rx_error_resp            ;
 wire           [0:0]               w_sl2l_othr_profile_trigger            ;
 

//SRC FSM <-> SRC Monitor
wire            [1:0]               w_clear_sticky                         ;       
wire            [0:0]               w_tx_plllock_lost_sticky               ;
wire            [0:0]               w_rx_cdr_lock_lost_sticky              ;


//SRC FSM <-> SRC Stagger
wire            [0:0]               w_count_start                          ;  
wire            [13:0]              w_num_of_clocks                        ;
wire            [1:0]               w_scaling_factor                       ;
wire            [0:0]               w_count_done                           ;


//SRC FSM  <->  SRC Addr Generation
wire            [0:0]               w_read_start                           ;
wire            [0:0]               w_tx_rx_valid                          ;
wire            [0:0]               w_reset_exit_entry                     ;
wire            [0:0]               w_addr_gen_abort_instr                 ;
wire            [0:0]               w_addr_gen_jump_to_rst_entry           ;
wire            [0:0]               w_addr_gen_initiator_instr_done        ;

wire            [8:0]               w_rd_addr                              ;
wire            [0:0]               w_common_resources_done                ;
wire            [0:0]               w_addr_gen_tx_fully_op                 ;
wire            [0:0]               w_addr_gen_rx_fully_op                 ;
wire            [0:0]               w_addr_gen_tx_fully_rst                ;
wire            [0:0]               w_addr_gen_rx_fully_rst                ;


//SRC FSM  <->  SRC M20K VLIW Specification
wire            [39:0]              w_rd_data                              ;
wire            [0:0]               w_rd_req                               ;  
//-------------------------------------------------------------------------------------------------
// SRC Lane2lane module instantiation 
//------------------------------------------------------------------------------------------------- 

intel_src_lane2lane  #(
    .NUM_LANES      (NUM_LANES          ),
    .SRC_LANE_INDEX (SRC_LANE_INDEX)
) src_lane2lane (

    .clk                                    (clk                ),
    .sclr                                   (sclr               ),
    
    //SRC CSR Interface
    .src_role_cfg                           (src_role_cfg[9:0]  ),
    .src_target_enable                      (src_target_enable  ),
    
    //FSM 
    .addr_gen_common_block_rst_done_reg     (w_addr_gen_common_block_rst_done_reg),
    
    
    //SRC FSM Interface
    .sl2l_fsm_trigger_or_error_resp_in      (w_sl2l_fsm_trigger_or_error_resp_in    ),
    .sl2l_fsm_error_resp_or_trigger_out     (w_sl2l_fsm_error_resp_or_trigger_out   ),
    .sl2l_fsm_stagger_within_en             (w_sl2l_fsm_stagger_within_en           ),
    .sl2l_fsm_desired_state_or_ready_in     (w_sl2l_fsm_desired_state_or_ready_in   ),
    .sl2l_fsm_ready_or_desired_state_out    (w_sl2l_fsm_ready_or_desired_state_out  ),
    .sl2l_fsm_all_targets_done              (w_sl2l_fsm_all_targets_done            ),
    .sl2l_fsm_tx_rx_in                      (w_sl2l_fsm_tx_rx_in                    ),
    .sl2l_fsm_tx_rx_out                     (w_sl2l_fsm_tx_rx_out                   ),
    .src_fsm_target_instr_done              (w_src_fsm_target_instr_done            ),

    //SRC Lane to lane interface
    .sl2l_trigger_or_error_resp_in          (sl2l_trigger_or_error_resp_in      ),
    .sl2l_desired_state_or_ready_in         (sl2l_desired_state_or_ready_in     ),
    .sl2l_tx_rx_in                          (sl2l_tx_rx_in                      ),
    .sl2l_error_resp_or_trigger_out         (sl2l_error_resp_or_trigger_out     ),
    .sl2l_ready_or_desired_state_out        (sl2l_ready_or_desired_state_out    ),
    .sl2l_tx_rx_out                         (sl2l_tx_rx_out                     ),
    .interleave_active                      (w_interleave_active                ),
    .stagger_cnt_done                       (w_count_done                       ),
    .sl2l_tx_init_rst_done_for_err          (w_sl2l_tx_init_rst_done_for_err    ),  //v0.82
    .sl2l_rx_init_rst_done_for_err          (w_sl2l_rx_init_rst_done_for_err    ),  //v0.82
    .sl2l_target_tx_error_resp              (w_sl2l_target_tx_error_resp        ),  //v0.82
    .sl2l_target_rx_error_resp              (w_sl2l_target_rx_error_resp        ),  //v0.82             
    .sl2l_othr_profile_trigger              (w_sl2l_othr_profile_trigger        )   //v0.83            


);


//-------------------------------------------------------------------------------------------------
// SRC Monitor module instantiation 
//------------------------------------------------------------------------------------------------- 
 
intel_src_monitor #(


) src_monitor (

    .clk                            (clk), 
    .sclr                           (sclr), 
    
    
    //HSSI Outputs - HIP signals
    
    .sync_oflux_rx_srds_rdy         (sync_oflux_rx_srds_rdy        ), //Input from HIP (HSSI)
    .sync_ux_all_synthlockstatus    (sync_ux_all_synthlockstatus   ), //Input from HIP (HSSI)
    .sync_ux_rxcdrlockstatus        (sync_ux_rxcdrlockstatus       ), //Input from HIP (HSSI)
    .sync_ux_rxcdrlock2data         (sync_ux_rxcdrlock2data        ), //Input from HIP (HSSI)
    
    //SIP/DR MUX signals
    .sync_sip_rx_ignore_lock2data   (sync_sip_rx_ignore_lock2data  ), // Input from SIP to ignore lock2data during loopback
    
    //SRC Flow Control
    .is_flux_used_rx_for_rx_adpt    (src_functional_mode_cnf[17]   ), //v0.86
    .tx_fully_operational           (tx_lane_current_state [0]     ),
    .rx_fully_operational           (rx_lane_current_state [0]     ),
    //SRC FSM
    .clear_sticky                   (w_clear_sticky                ), //[0] - clear tx_plllock_lost_sticky  [1] - clear rx_cdr_lock_lost_sticky 
    .tx_plllock_lost_sticky         (w_tx_plllock_lost_sticky      ), // Sticky flag indicates FSM to raise tx_alarm to SIP
    .rx_cdr_lock_lost_sticky        (w_rx_cdr_lock_lost_sticky     ) // Sticky flag indicates FSM to raise rx_alarm to SIP 
            

);


//-------------------------------------------------------------------------------------------------
// Address Generation  - SRC M20K Specification VLIW  
//-------------------------------------------------------------------------------------------------
intel_src_addr_gen
#(
    .ADDR_WIDTH      (9                ),
    .RX_START_ADDR   (RX_START_ADDR    ),  //total rx 26 inst 
    .TX_START_ADDR   (TX_START_ADDR    ),   //after common resource 
    .TOTAL_INSTRUCTIONS (TOTAL_INSTRUCTIONS)
) src_addr_gen (   //input port
    .clk                                (clk                        ),    //100mhz input clock
    .sclr                               (sclr                       ),    //active low signal
    .addr_gen_read_start                (w_read_start               ),
    .addr_gen_tx_rx_sel                 (w_tx_rx_valid              ),    //0-tx, 1-rx
    .addr_gen_rst_exit_entry_sel        (w_reset_exit_entry         ),    //0-exit, 1-entry
    .addr_gen_abort_instr               (w_addr_gen_abort_instr     ),
    .addr_gen_jump_to_rst_entry         (w_addr_gen_jump_to_rst_entry),
    .sl2l_fsm_ready_or_desired_state_out(w_sl2l_fsm_ready_or_desired_state_out), //v0.3 fix
    .src_role_cfg                       (src_role_cfg[1:0]          ),           //v0.3 fix
    .addr_gen_initiator_instr_done      (w_addr_gen_initiator_instr_done),       //v0.4 fix
    .sl2l_fsm_all_targets_done          (w_sl2l_fsm_all_targets_done    ),       //v0.4 fix

    //output port               
    .rd_addr                            (w_rd_addr                  ),    //9bit
    .rd_req                             (w_rd_req                   ),
    .addr_gen_common_block_rst_done     (w_common_resources_done    ),
    .addr_gen_tx_fully_op               (w_addr_gen_tx_fully_op     ),
    .addr_gen_rx_fully_op               (w_addr_gen_rx_fully_op     ),
    .addr_gen_tx_fully_rst              (w_addr_gen_tx_fully_rst    ),
    .addr_gen_rx_fully_rst              (w_addr_gen_rx_fully_rst    )

    
);


//-------------------------------------------------------------------------------------------------
// SRC M20K Specification VLIW MIF  
//-------------------------------------------------------------------------------------------------

//`ifdef ALTERA_SYNCRAM_BYPASS_SYNTH  //Provided to bypass altera syncram during synthesis with sm7 part number.
//                                    // Added temporarily,to be removed after family support added in quartus
//
//  
//    m20k_synth_bfm rom_synth (  
//    
//    .clk (clk),
//    .addres (w_rd_addr),
//    .data_out (w_rd_data),
//    .en (w_rd_req)
//
//    );
//
//`else

    altera_syncram  altera_syncram_component (
                    .address_a (w_rd_addr),
                    .clock0 (clk),
                    .q_a (w_rd_data),
                    .aclr0 (1'b0),
                    .aclr1 (1'b0),
                    .address2_a (1'b1),
                    .address2_b (1'b1),
                    .address_b (1'b1),
                    .addressstall_a (1'b0),
                    .addressstall_b (1'b0),
                    .byteena_a (1'b1),
                    .byteena_b (1'b1),
                    .clock1 (1'b1),
                    .clocken0 (1'b1),
                    .clocken1 (1'b1),
                    .clocken2 (1'b1),
                    .clocken3 (1'b1),
                    .data_a ({40{1'b1}}),
                    .data_b (1'b1),
                    .eccencbypass (1'b0),
                    .eccencparity (8'd0),
                    .eccstatus ( ),
                    .q_b ( ),
                    .rden_a (w_rd_req),
                    .rden_b (1'b1),
                    .sclr (1'b0),
                    .wren_a (1'b0),
                    .wren_b (1'b0));
        defparam
            altera_syncram_component.address_aclr_a  = "NONE",
            altera_syncram_component.clock_enable_input_a  = "BYPASS",
            altera_syncram_component.clock_enable_output_a  = "BYPASS",
            altera_syncram_component.enable_ecc  = "FALSE",
            altera_syncram_component.ecc_pipeline_stage_enabled  = "FALSE",
            altera_syncram_component.enable_ecc_encoder_bypass  = "FALSE",
            altera_syncram_component.init_file = "SM_SRC_VLIW_MIF.mif",
            altera_syncram_component.intended_device_family  = "Stratix 10",
            altera_syncram_component.lpm_type  = "altera_syncram",      
            altera_syncram_component.maximum_depth  = 512,
            altera_syncram_component.numwords_a  = 512,
            altera_syncram_component.operation_mode  = "ROM",
            altera_syncram_component.outdata_aclr_a  = "NONE",
            altera_syncram_component.outdata_sclr_a  = "NONE",
            //altera_syncram_component.outdata_reg_a  = "CLOCK0",
            altera_syncram_component.power_up_uninitialized  = "FALSE",
            altera_syncram_component.ram_block_type  = "M20K",
            altera_syncram_component.widthad_a  = 9,
            altera_syncram_component.width_a  = 40,
            altera_syncram_component.width_byteena_a  = 1,
            altera_syncram_component.width_eccstatus  = 2;
//`endif

//-------------------------------------------------------------------------------------------------
// SRC Wait/ Staggering module
//-------------------------------------------------------------------------------------------------
 intel_src_stagger_block  # (
    .SIM_EMULATE    (SIM_EMULATE),
    .SIM_SCALE_DOWN (SIM_SCALE_DOWN)
 ) src_stagger (

    .clk                    (clk    ),
    .sclr                   (sclr   ),
    .count_start            (w_count_start      ),
    .num_of_clocks          (w_num_of_clocks    ),
    .scaling_factor         (w_scaling_factor   ),
    .count_done             (w_count_done       )

);

//-------------------------------------------------------------------------------------------------
// SRC FSM
//-------------------------------------------------------------------------------------------------
 
 intel_src_lane_rst_sequence_fsm #(
 
    //.TX_LANE_OPERATIONAL_STATE_POINTER  (175) //v0.81
    
) src_lane_rst_seq_fsm (

    //SRC Flow Control top
    .clk                                (clk    ),
    .sclr                               (sclr   ),
    .all_lane_cmn_rsrc_done             (all_lane_cmn_rsrc_done   ),
    //Address Generator 
    
    .addr_gen_inst_rd_addr              (w_rd_addr              ),
    .addr_gen_rd_req                    (w_read_start           ),//set it in a new state before st_rd_start if 1 clk delay is ok and resource usage needs to be reduced
    .addr_gen_tx_rx_sel                 (w_tx_rx_valid          ),
    .addr_gen_rst_exit_entry_sel        (w_reset_exit_entry     ),
    .addr_gen_common_block_rst_done     (w_common_resources_done),
    .addr_gen_abort_instr               (w_addr_gen_abort_instr), 
    .addr_gen_tx_fully_op               (w_addr_gen_tx_fully_op ),
    .addr_gen_rx_fully_op               (w_addr_gen_rx_fully_op ),
    .addr_gen_tx_fully_rst              (w_addr_gen_tx_fully_rst),
    .addr_gen_rx_fully_rst              (w_addr_gen_rx_fully_rst),
    .addr_gen_jump_to_rst_entry         (w_addr_gen_jump_to_rst_entry ),
    .addr_gen_initiator_instr_done      (w_addr_gen_initiator_instr_done),
    
    //M20K  
    .m20k_rom_data_in                   (w_rd_data), //for compilation , add signal TBD
    //output wire [08:0] m20k_rom_addr_out,
    
    //SRC Lane to Lane Interface
    
    .sl2l_fsm_trigger_or_error_resp_in  (w_sl2l_fsm_trigger_or_error_resp_in    ),
    .sl2l_fsm_error_resp_or_trigger_out (w_sl2l_fsm_error_resp_or_trigger_out   ),
    .sl2l_fsm_desired_state_or_ready_in (w_sl2l_fsm_desired_state_or_ready_in   ),
    .sl2l_fsm_ready_or_desired_state_out(w_sl2l_fsm_ready_or_desired_state_out  ),
    .sl2l_fsm_stagger_within_en         (w_sl2l_fsm_stagger_within_en           ),
    .sl2l_fsm_all_targets_done          (w_sl2l_fsm_all_targets_done            ),
    .sl2l_fsm_tx_rx_in                  (w_sl2l_fsm_tx_rx_in                    ), // 0- Tx, 1- Rx
    .sl2l_fsm_tx_rx_out                 (w_sl2l_fsm_tx_rx_out                   ),
    .addr_gen_common_block_rst_done_reg (w_addr_gen_common_block_rst_done_reg   ),
    .src_fsm_target_instr_done          (w_src_fsm_target_instr_done            ),
    .sl2l_tx_init_rst_done_for_err      (w_sl2l_tx_init_rst_done_for_err        ), //v0.82
    .sl2l_rx_init_rst_done_for_err      (w_sl2l_rx_init_rst_done_for_err        ), //v0.82
    .sl2l_target_tx_error_resp          (w_sl2l_target_tx_error_resp            ), //v0.82
    .sl2l_target_rx_error_resp          (w_sl2l_target_rx_error_resp            ), //v0.82
    .sl2l_othr_profile_trigger          (w_sl2l_othr_profile_trigger            ), //v0.83


    //SRC CSR
    .src_csr_role_cfg                   (src_role_cfg                           ),      //should we use only bits 0,1,10,11?,
    .src_csr_func_mode_cfg              (src_functional_mode_cnf                ),      //should MSB 16 bits be removed?
    
    //DR Ctrl
    .sync_pause_request                 (sync_pause_request ),
    .pause_grant                        (pause_grant        ),
    
    //Stagger Counter
    .stagger_cnt_start                  (w_count_start      ),
    .stagger_num_of_clk                 (w_num_of_clocks    ),
    .stagger_scale_factor               (w_scaling_factor   ),
    .stagger_cnt_done                   (w_count_done       ),
    
    //SRC Shoreline Sequencer
    .sss_req                            (sss_req            ),
    .sync_sss_grant                     (sync_sss_grant     ),
    
    //SRC Monitor
    .src_mon_clr_sticky_flags           (w_clear_sticky),
    .src_mon_rx_cdr_lock_lost           (w_rx_cdr_lock_lost_sticky),
    .src_mon_tx_pll_lock_lost           (w_tx_plllock_lost_sticky),
    
    //Control interface- SIP/DR mux
    .sync_tx_lane_desired_state         (sync_tx_lane_desired_state     ), //0-operate, 1-reset
    .tx_lane_current_state              (tx_lane_current_state          ),
    .tx_alarm                           (tx_alarm                       ),
    .sync_tx_clear_alarm                (sync_tx_clear_alarm            ),
    .sync_rx_lane_desired_state         (sync_rx_lane_desired_state     ), //0-operate, 1-reset
    .rx_lane_current_state              (rx_lane_current_state          ),
    .rx_alarm                           (rx_alarm                       ),
    .sync_rx_clear_alarm                (sync_rx_clear_alarm            ),
    .sync_sip_rx_ignore_lock2data       (sync_sip_rx_ignore_lock2data   ),
    .sync_sip_freeze_tx_SRC_sequence    (sync_sip_freeze_tx_SRC_sequence),
    .sync_sip_freeze_rx_SRC_sequence    (sync_sip_freeze_rx_SRC_sequence),
    .sip_freeze_tx_acknowledge          (sip_freeze_tx_acknowledge      ),
    .sip_freeze_rx_acknowledge          (sip_freeze_rx_acknowledge      ),
    .sip_am_gen_start                   (sip_am_gen_start               ),
    .sync_sip_am_gen_2x_ack             (sync_sip_am_gen_2x_ack         ),
    
    
    //HIP Reset/Status interface
    .ptp_pld_adapter_tx_pld_rst_n        (ptp_pld_adapter_tx_pld_rst_n   ),
    .ptp_pld_adapter_rx_pld_rst_n        (ptp_pld_adapter_rx_pld_rst_n   ),
    .ptp_pld_ready                       (ptp_pld_ready                  ),
    .ptp_rst_n                           (ptp_rst_n                      ),
    .pld_adapter_tx_pld_rst_n            (pld_adapter_tx_pld_rst_n       ),
    .pld_adapter_rx_pld_rst_n            (pld_adapter_rx_pld_rst_n       ),
    .ehip_tx_rst_n                       (ehip_tx_rst_n                  ),
    .ehip_rx_rst_n                       (ehip_rx_rst_n                  ),
    .tx_pcs_sfrz_n                       (tx_pcs_sfrz_n                  ),
    .rx_mac_deskew_sfrz_n                (rx_mac_deskew_sfrz_n           ),
    .tx_deskew_sfrz_n                    (tx_deskew_sfrz_n               ),
    .fec_tx_rst_n                        (fec_tx_rst_n                   ),
    .fec_rx_rst_n                        (fec_rx_rst_n                   ),
    .fec_csr_ret                         (fec_csr_ret                    ),
    .tx_fec_sfrz_n                       (tx_fec_sfrz_n                  ),
    .rx_fec_sfrz_n                       (rx_fec_sfrz_n                  ),
    .xcvrif_tx_rst_n                     (xcvrif_tx_rst_n                ),
    .xcvrif_rx_rst_n                     (xcvrif_rx_rst_n                ),
    .tx_xcvrif_sfrz_n                    (tx_xcvrif_sfrz_n               ),
    .rx_xcvrif_sfrz_n                    (rx_xcvrif_sfrz_n               ),
    .xcvrif_signal_ok                    (xcvrif_signal_ok               ),
    .ux_tx_pma_rst_n                     (ux_tx_pma_rst_n                ),
    .ux_rx_pma_rst_n                     (ux_rx_pma_rst_n                ),
    .ux_rx_sfrz_n                        (ux_rx_sfrz_n                   ),
    .iflux_ingress_direct_231            (iflux_ingress_direct_231       ),
    .ehip_signal_ok                      (ehip_signal_ok                 ),
    .pld_ready                           (pld_ready                      ),
    .sync_o_rx_pcs_fully_aligned         (sync_o_rx_pcs_fully_aligned    ),
    .sync_ux_octl_pcs_txstatus           (sync_ux_octl_pcs_txstatus      ),
    .sync_ux_octl_pcs_rxstatus           (sync_ux_octl_pcs_rxstatus      ),
    .sync_ux_all_synthlockstatus         (sync_ux_all_synthlockstatus    ),
    .sync_ux_rxcdrlockstatus             (sync_ux_rxcdrlockstatus        ),
    .sync_ux_rxcdrlock2data              (sync_ux_rxcdrlock2data         ),
    .sync_flux_cpi_cmn_busy              (sync_flux_cpi_cmn_busy         ),
    .sync_oflux_rx_srds_rdy              (sync_oflux_rx_srds_rdy         ),
    .sync_c0_syspll_lockstatus           (sync_c0_syspll_lockstatus      ),
    .sync_c1_syspll_lockstatus           (sync_c1_syspll_lockstatus      ),
    .sync_c2_syspll_lockstatus           (sync_c2_syspll_lockstatus      ),
    .sync_o_fec_rx_rdy_n                 (sync_o_fec_rx_rdy_n            ),
    .sync_hip_ready                      (sync_hip_ready                 ), //v0.84
    .sl2l_interleave_active              (w_interleave_active            ) //revert change
);
 
 
 
 endmodule
 
 //----------------------------------------------------------------------------------------------------------------
// Version             |  Changes                                                   | Date         | Owner ID 
//----------------------------------------------------------------------------------------------------------------
//   0.0               |                                                            |              |   
//   0.1               | Initial code                                               |  24-Jun-2022 |  skgr 
//   0.2               | Module instantiation and connection (lane2lane, monitor )  |  27-Jun-2022 |  skgr
//   0.3               | Address generate interleave scenario fix                   |  26-Aug-2022 |  skgr
//   0.4               | Address generate RX Alarm - CDR Lock lost fix              |  30-Aug-2022 |  skgr
//   0.41              | Provided to bypass altera syncram during synthesis with sm7|              |
//                     | part number.Added temporarily,to be removed after family   |              |
//                     | support added in quartus                                   |  19-Sep-2022 | skgr 
//   0.5               | Added input to notify cmnrsrc done for all lanes           |  28-Sep-2022 | cvignesh
//   0.6               | Added input to Lane2lane for TX & RX Interleave active     |  13-Oct-2022 | skgr
//   0.7               | Reverted 0.41 support for ROM BFM - 22.4 B43               |  03-Nov-2022 | skgr 
//   0.8               | stagger_cnt_done to Lane2lane for HSD 15012445890          |  07-Dec-2022 | skgr 
//   0.81              | VLIW Address Parameters brought out to SRC Wrapper         |  22-Feb-2023 | skgr
//                     | Removed unused parameter in FSM                            |              | 
//   0.82              | Error resp from target for TX, RX sent to FSM added        |  16-Mar-2023 | skgr
//   0.83              | Flag to FSM to indicate outstanding trigger for TX/RX      |              |
//                     | alarm reset entry initiated INIT, when profile is in       |              |
//                     | fully operational state                                    |  21-Mar-2023 | skgr 
//   0.84              | HSD:16020176490 hip_ready added to SRC Spec                |  04-Apr-2023 | skgr
//   0.85              | HSD:16021677025 PFE review FEC reset irrespective of FEC_EN|  09-Aug=2023 | skgr
//   0.86              | HSD:16021677025 ignore srds_rdy for CDR LOL in flux bypass |  01-Sep-2023 | skgr 
//----------------------------------------------------------------------------------------------------------------
