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
// File Name   : intel_src_lane_rst_sequence_fsm.sv
// Project     : Soft Reset Controller
// Version     : 0.6539
// Description : SRC lane reset sequence FSM. This component is part of SRC IP.
//               This is used to read the instructions from the M20K ROM,
//               decoding them and executing the reset sequence thereby.
//               This involves control, and reset group handling, status signal
//               monitoring and reset signal driving logic.
//               NOTE: It should be instantiated in SRC flow control top.
// Limitations : NA
//
//
// Copyright 2019 Intel Corporation.
// All rights reserved
//--------------------------------------------------------------------------------------------------------------------------

module intel_src_lane_rst_sequence_fsm (
    //SRC Flow Control top
    input  wire        clk,
    input  wire        sclr,
    input  wire        all_lane_cmn_rsrc_done,
    //Address Generator
    //input  wire        addr_gen_inst_rd_req,
    input  wire [08:0] addr_gen_inst_rd_addr,
    output reg         addr_gen_rd_req,//set it in a new state before st_rd_start if 1 clk delay is ok and resource usage needs to be reduced
    output wire        addr_gen_tx_rx_sel,
    output reg         addr_gen_rst_exit_entry_sel,
    input  wire        addr_gen_common_block_rst_done,
    output reg         addr_gen_abort_instr,
    input  wire        addr_gen_tx_fully_op,
    input  wire        addr_gen_rx_fully_op,
    input  wire        addr_gen_tx_fully_rst,
    input  wire        addr_gen_rx_fully_rst,
    output reg         addr_gen_jump_to_rst_entry,
    output wire        addr_gen_initiator_instr_done,
    //M20K
    input  wire [39:0] m20k_rom_data_in,
    //output wire [08:0] m20k_rom_addr_out,
    //SRC Lane to Lane Interface
    input  wire        sl2l_fsm_trigger_or_error_resp_in,
    output reg         sl2l_fsm_error_resp_or_trigger_out,
    input  wire        sl2l_fsm_desired_state_or_ready_in,
    output reg         sl2l_fsm_ready_or_desired_state_out,
    output reg         sl2l_fsm_stagger_within_en,
    input  wire        sl2l_fsm_all_targets_done,
    input  wire        sl2l_fsm_tx_rx_in, // 0- Tx, 1- Rx
    output reg         sl2l_fsm_tx_rx_out,
    output reg         addr_gen_common_block_rst_done_reg,
    output reg         src_fsm_target_instr_done,
    input  wire        sl2l_target_tx_error_resp, //v0.63
    input  wire        sl2l_target_rx_error_resp, //v0.63
    output reg         sl2l_tx_init_rst_done_for_err,//v0.63
    output reg         sl2l_rx_init_rst_done_for_err,//v0.63
    input  wire        sl2l_othr_profile_trigger, //v0.65
    //SRC CSR
    input  wire [31:0] src_csr_role_cfg,//should we use only bits 0,1,10,11?
   // input  wire [31:0] src_csr_target_en,
    input  wire [31:0] src_csr_func_mode_cfg,//should MSB 16 bits be removed?
    //DR Ctrl
    input  wire        sync_pause_request,
    output reg         pause_grant,
    //Stagger Counter
    output reg         stagger_cnt_start,
    output wire [13:0] stagger_num_of_clk,
    output wire [01:0] stagger_scale_factor,
    input  wire        stagger_cnt_done,
    //SRC Shoreline Sequencer
    output reg         sss_req,
    input  wire        sync_sss_grant,
    //SRC Monitor
    output reg  [01:0] src_mon_clr_sticky_flags,
    input  wire        src_mon_rx_cdr_lock_lost,
    input  wire        src_mon_tx_pll_lock_lost,
    //input  wire        src_mon_fec_rst_pull_down,//v0.6534
    //Control interface- SIP/DR mux
    input  wire        sync_tx_lane_desired_state, //0-operate, 1-reset
    output wire [01:0] tx_lane_current_state,
    output reg         tx_alarm,
    input  wire        sync_tx_clear_alarm,
    input  wire        sync_rx_lane_desired_state, //0-operate, 1-reset
    output wire [01:0] rx_lane_current_state,
    output reg         rx_alarm,
    input  wire        sync_rx_clear_alarm,
    input  wire        sync_sip_rx_ignore_lock2data,
    input  wire        sync_sip_freeze_tx_SRC_sequence,
    input  wire        sync_sip_freeze_rx_SRC_sequence,
    output wire        sip_freeze_tx_acknowledge,
    output wire        sip_freeze_rx_acknowledge,
    output reg         sip_am_gen_start,
    input  wire        sync_sip_am_gen_2x_ack,
    //HIP Reset/Status interface
    output reg         ptp_pld_adapter_tx_pld_rst_n,
    output reg         ptp_pld_adapter_rx_pld_rst_n,
    output reg         ptp_pld_ready,
    output reg         ptp_rst_n,
    output reg         pld_adapter_tx_pld_rst_n,
    output reg         pld_adapter_rx_pld_rst_n,
    output reg         ehip_tx_rst_n,
    output reg         ehip_rx_rst_n,
    output reg         tx_pcs_sfrz_n,
    output reg         rx_mac_deskew_sfrz_n,
    output reg         tx_deskew_sfrz_n,
    output reg         fec_tx_rst_n,
    output reg         fec_rx_rst_n,
    output reg         fec_csr_ret,
    output reg         tx_fec_sfrz_n,
    output reg         rx_fec_sfrz_n,
    output reg         xcvrif_tx_rst_n,
    output reg         xcvrif_rx_rst_n,
    output reg         tx_xcvrif_sfrz_n,
    output reg         rx_xcvrif_sfrz_n,
    output reg         xcvrif_signal_ok,
    output reg         ux_tx_pma_rst_n,
    output reg         ux_rx_pma_rst_n,
    output reg         ux_rx_sfrz_n,
    output reg         iflux_ingress_direct_231,
    output reg         ehip_signal_ok,
    output reg         pld_ready,
    input  wire        sync_o_rx_pcs_fully_aligned,
    input  wire        sync_ux_octl_pcs_txstatus,
    input  wire        sync_ux_octl_pcs_rxstatus,
    input  wire        sync_ux_all_synthlockstatus,
    input  wire        sync_ux_rxcdrlockstatus,
    input  wire        sync_ux_rxcdrlock2data,
    input  wire        sync_flux_cpi_cmn_busy,
    input  wire        sync_oflux_rx_srds_rdy,
    input  wire        sync_c0_syspll_lockstatus,
    input  wire        sync_c1_syspll_lockstatus,
    input  wire        sync_c2_syspll_lockstatus,
    input  wire        sync_o_fec_rx_rdy_n,
    input  wire        sync_hip_ready, //v0.653
    
    
    output reg  [1:0]  sl2l_interleave_active //revert change
);

//---------------------------------------- Local Parameter declaration----------------------------------------------------
localparam ST_COMMON_RSRC_RST_EXIT    = 5'd0;
localparam ST_RESET_EXIT_INSTR_START  = 5'd1;
localparam ST_RESET_ENTRY_INSTR_START = 5'd2;
localparam ST_INSTR_RD_START          = 5'd3;
localparam ST_INSTR_RD_WAIT           = 5'd4;
localparam ST_RECV_BYTE0_4            = 5'd5;
localparam ST_RECV_BYTE5_9            = 5'd6;
localparam ST_RECV_BYTE10_14          = 5'd7;
localparam ST_RECV_BYTE15_19          = 5'd8;
localparam ST_INTERLEAVE_MONITOR      = 5'd9;
localparam ST_CUR_PROFILE_MONITOR     = 5'd10;
localparam ST_SHORELINE_REQ           = 5'd11;
localparam ST_DRIVE                   = 5'd12;
localparam ST_ALL_TARGET_DONE         = 5'd13;
localparam ST_STAGGER_AFTER           = 5'd14;
localparam ST_COMPLETE_WAIT           = 5'd15;
localparam ST_1MS_WAIT_DONE           = 5'd16;
localparam ST_FULLY_OP                = 5'd17;
localparam ST_FULLY_RST               = 5'd18;
localparam ST_INTERLEAVED_ST_CHK      = 5'd19;
localparam ST_SFRZ_SHORELINE_REQ      = 5'd20;
localparam ST_INSTR_RD_WAIT1          = 5'd21;
localparam ST_TGT_INSTR_DONE_WAIT_1CLK= 5'd22;


//localparam INTRLV_OR_TRIG_WAIT_NUM_CLK= 14'd200;
localparam TRIG_WAIT_NUM_CLK= 14'd200;
localparam INTRLV_WAIT_NUM_CLK= 14'd16;
localparam INTRLV_OR_TRIG_WAIT_SCALE_FACTOR = 2'b00;
`ifdef SIM_EMULATE //1ms fo SI and 200us for Sim
localparam DES_ST_CHG_WAIT_NUM_CLK = 14'd5000;
localparam DES_ST_CHG_WAIT_SCALE_FACTOR = 2'b01;
localparam RX_MON_FAIL_NUM_CLK = 14'd5000;
localparam RX_MON_FAIL_SCALE_FACTOR = 2'b01;
`else
localparam DES_ST_CHG_WAIT_NUM_CLK = 14'd12500;
localparam DES_ST_CHG_WAIT_SCALE_FACTOR = 2'b10;
localparam RX_MON_FAIL_NUM_CLK = 14'd12500;
localparam RX_MON_FAIL_SCALE_FACTOR = 2'b10;
`endif
//scaling factor 2??b00 = x1; 2??b01 = x4; 2??b10 = x8; 2??b11 = x16
//actual wait count = scaling factor x stagger_num_of_clk
//this uses stagger after path
//for stagger after, total_clk=wait_time/clk period;
// wait num clk = total_clk/16 >16383 ? invalid :
//                ( total_clk/8  >16383 ? total_clk/16 : 
//                  ( total_clk/4  >16383 ? total_clk/8 :
//                    ( total_clk    >16383 ? total_clk/4 : total_clk)));

//---------------------------------------- Register and Wire declaration----------------------------------------------------

wire        mux_txrx_desired_state;
wire [13:0] concatenated_monitor_signals; //v0.653
wire        initiator;
wire        sip_freeze_req;
wire        tx_leader;
wire        tx_or_rx_fully_des_st_not_reached;
wire        interleave_initiator;
//v0.3472
wire        tx_des_st_reached;
wire        rx_des_st_reached;
//v0.37
wire        cur_prof_des_st_reached;
wire        other_prof_fully_rst   ;
wire        other_prof_fully_op    ;
//v0.381
wire        other_prof_des_st_reached;

reg  [4:0]  src_fsm_state;
reg  [4:0]  return_state;
reg         mux_txrx_desired_state_reg;
reg         interleave_active;
reg  [13:0] vliw_monitor_reg; //v0.653
reg         vliw_instr_type;
reg         vliw_leader_follower_val_chk;
reg  [27:0] vliw_drive_reg;
reg         vliw_condition_pass;
reg         vliw_fn_mode_chk_pass;
reg         vliw_wait_point;
reg         vliw_monitor_value;
reg         vliw_drive_val;
reg  [13:0] interleave_monitor_reg; //v0.653
reg         interleave_monitor_val;
reg  [4:0]  interleave_return_state;
reg         interleave_des_st_reg;
reg         stagger_sel; //0- within, 1-after
reg  [7:0]  stagger_within_num_of_clk;
reg  [1:0]  scaling_fac_within;
reg  [13:0] stagger_after_num_of_clk;
reg  [1:0]  scaling_fac_after;
reg         sl2l_fsm_trigger_or_error_resp_in_dly;
reg         fec_rst_deassert_done;
//reg         addr_gen_common_block_rst_done_reg;
reg  [13:0] monitoring_status;             //v0.653
reg  [13:0] interleave_monitoring_status;  //v0.653
reg         is_duplex; //checks if duplex(or dual simplex) for interleaving
reg         sip_freeze_ack;
reg         initiator_mon_fail;
reg         initiator_instr_done;
reg         inter_flag;
reg  [31:0] src_csr_role_cfg_reg;
reg         des_st_change_flag;
reg         sfreeze_tx_rx_sel;
reg         tx_fully_des_st_reached;
reg         rx_fully_des_st_reached;
reg         alarm_active;
reg         alarm_active_tx;
reg         alarm_active_rx;
reg         rx_en;
reg         tx_en;
reg         go_back_to_trig_wait;
//reg         fsm_common_initiator;
reg   [1:0] wait_4clk;//0.3461
reg         sl2l_fsm_tx_rx_out_reg;
reg   [4:0] src_fsm_state_reg;
//v0.3472
reg  tx_des_st_reached_reg;
reg  rx_des_st_reached_reg;
//v0.38
reg         tx_desired_state_reg;
reg         rx_desired_state_reg;
//v0.52
reg         entry_btwn_exit_flag;
//v0.55
reg         des_st_change_flag_reg;
//v0.62
reg         error_from_target_flag;

//v0.6532
wire [0:0]  src_csr_func_mode_cfg_fec_en ;
wire [0:0]  src_csr_func_mode_cfg_pcs_en ;
wire [0:0]  src_csr_func_mode_cfg_dl_en  ;
wire [4:0]  src_csr_func_mode_cfg_tx_rx  ;

//v0.6536
wire [0:0]   src_error_init_rst_done ;

//---------------------------------------- Wire assignments ----------------------------------------------------------------
assign initiator              = !addr_gen_common_block_rst_done || (is_duplex ? (sl2l_fsm_tx_rx_out ? src_csr_role_cfg_reg[1] : src_csr_role_cfg_reg[0]) : 
                                  ((!src_csr_role_cfg_reg[10]&&src_csr_role_cfg_reg[1]) || (!src_csr_role_cfg_reg[11]&&src_csr_role_cfg_reg[0]))); 
                                   //rx:tx //v0.35 if simplex - tx disabled->set rx initiator and vice versa
assign tx_leader              = src_csr_role_cfg_reg[12]; 
assign mux_txrx_desired_state = sl2l_fsm_tx_rx_out ? sync_rx_lane_desired_state : sync_tx_lane_desired_state;
//assign tx_lane_current_state  = (addr_gen_tx_fully_op ? 2'd1 : (addr_gen_tx_fully_rst ? 2'd0 : 2'd2));
assign tx_lane_current_state = (addr_gen_tx_fully_op ? 2'd1 : (addr_gen_tx_fully_rst ? 2'd0 : (addr_gen_common_block_rst_done? 2'd2: 2'd3)));//V0.652
//assign rx_lane_current_state  = (addr_gen_rx_fully_op ? 2'd1 : (addr_gen_rx_fully_rst ? 2'd0 : 2'd2));
assign rx_lane_current_state = (addr_gen_rx_fully_op ? 2'd1 : (addr_gen_rx_fully_rst ? 2'd0 : (addr_gen_common_block_rst_done? 2'd2: 2'd3)));//V0.652

assign addr_gen_tx_rx_sel          = sl2l_fsm_tx_rx_out;
assign addr_gen_rst_exit_entry_sel = mux_txrx_desired_state_reg;

assign stagger_num_of_clk   = stagger_sel ? stagger_after_num_of_clk : {6'd0,stagger_within_num_of_clk};
assign stagger_scale_factor = stagger_sel ? scaling_fac_after : scaling_fac_within;

assign concatenated_monitor_signals = {sync_hip_ready,sync_sip_am_gen_2x_ack,sync_o_fec_rx_rdy_n,sync_c2_syspll_lockstatus,
                                       sync_c1_syspll_lockstatus,sync_c0_syspll_lockstatus,sync_oflux_rx_srds_rdy,
                                       sync_flux_cpi_cmn_busy,sync_ux_rxcdrlock2data,sync_ux_rxcdrlockstatus,
                                       sync_ux_all_synthlockstatus,sync_ux_octl_pcs_rxstatus,
                                       sync_ux_octl_pcs_txstatus,sync_o_rx_pcs_fully_aligned};
//v0.6532 
assign sip_freeze_req = sync_sip_freeze_rx_SRC_sequence || sync_sip_freeze_tx_SRC_sequence;
assign sip_freeze_tx_acknowledge = sync_sip_freeze_tx_SRC_sequence && sip_freeze_ack ;
assign sip_freeze_rx_acknowledge = sync_sip_freeze_rx_SRC_sequence && sip_freeze_ack ;

assign addr_gen_initiator_instr_done = initiator_instr_done;
assign tx_or_rx_fully_des_st_not_reached = !(tx_fully_des_st_reached || rx_fully_des_st_reached);
assign interleave_initiator = sl2l_fsm_tx_rx_out ? src_csr_role_cfg_reg[0] : src_csr_role_cfg_reg[1]; //reverse of initiator (rx and tx reverse) 
//assign interleave_initiator = go_back_to_trig_wait ? initiator : (sl2l_fsm_tx_rx_out ? src_csr_role_cfg_reg[0] : src_csr_role_cfg_reg[1]); 
//reverse of initiator (rx and tx reverse) //set to intiator incase of trigger wait interleave since tx_rx_out changes before hand in that case

assign tx_des_st_reached = tx_desired_state_reg ? addr_gen_tx_fully_rst : addr_gen_tx_fully_op ;
assign rx_des_st_reached = rx_desired_state_reg ? addr_gen_rx_fully_rst : addr_gen_rx_fully_op ;

assign cur_prof_des_st_reached   = sl2l_fsm_tx_rx_out ? rx_des_st_reached : tx_des_st_reached;
assign other_prof_des_st_reached = sl2l_fsm_tx_rx_out ? tx_des_st_reached : rx_des_st_reached;
assign other_prof_fully_rst    = sl2l_fsm_tx_rx_out ? addr_gen_tx_fully_rst : addr_gen_rx_fully_rst;
assign other_prof_fully_op     = sl2l_fsm_tx_rx_out ? addr_gen_tx_fully_op  : addr_gen_rx_fully_op;
//v0.37


//v0.6532
assign src_csr_func_mode_cfg_fec_en = sl2l_fsm_tx_rx_out ? src_csr_func_mode_cfg[15] : src_csr_func_mode_cfg[14];
assign src_csr_func_mode_cfg_pcs_en = sl2l_fsm_tx_rx_out ? src_csr_func_mode_cfg[22] : src_csr_func_mode_cfg[21];
assign src_csr_func_mode_cfg_dl_en  = sl2l_fsm_tx_rx_out ? src_csr_func_mode_cfg[19] : src_csr_func_mode_cfg[18];
assign src_csr_func_mode_cfg_tx_rx  = sl2l_fsm_tx_rx_out ? src_csr_func_mode_cfg[9:5] : src_csr_func_mode_cfg[4:0];

//v0.6536
assign src_error_init_rst_done      = sl2l_fsm_tx_rx_out ? sl2l_rx_init_rst_done_for_err : sl2l_tx_init_rst_done_for_err ; 

//---------------------------------------- Logic Implementation -------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------
// Block description : FSM block which reads the instructions from the M20K ROM,
//                     decoding them and executing the reset sequence thereby.
//---------------------------------------------------------------------------------------------------------------------------


always @(posedge clk) begin
    if (sclr) begin
        src_fsm_state                       <= ST_COMMON_RSRC_RST_EXIT;
        //src_fsm_state_reg                   <= ST_COMMON_RSRC_RST_EXIT; //revert change
        return_state                        <= 5'd0;
        mux_txrx_desired_state_reg          <= 1'd0;
        interleave_active                   <= 1'd0;
        vliw_monitor_reg                    <= 14'd0; //v0.653
        vliw_instr_type                     <= 1'd0;
        vliw_leader_follower_val_chk        <= 1'd0;
        vliw_drive_reg                      <= 28'd0;
        vliw_condition_pass                 <= 1'd0;
        vliw_fn_mode_chk_pass               <= 1'd0;
        vliw_wait_point                     <= 1'd0;
        vliw_monitor_value                  <= 1'd0;
        vliw_drive_val                      <= 1'd0;
        interleave_monitor_reg              <= 14'd0; //v0.653
        interleave_monitor_val              <= 1'd0;
        interleave_return_state             <= 5'd0;
        interleave_des_st_reg               <= 1'd0;
        stagger_sel                         <= 1'd0;
        addr_gen_rd_req                     <= 1'd0;
        sl2l_fsm_tx_rx_out                  <= 1'd0;
        sl2l_fsm_ready_or_desired_state_out <= 1'd0;
        src_mon_clr_sticky_flags            <= 2'd0;
        stagger_within_num_of_clk           <= 8'd0;
        scaling_fac_within                  <= 2'd0;
        stagger_after_num_of_clk            <= 14'd0;
        scaling_fac_after                   <= 2'd0;
        sl2l_fsm_error_resp_or_trigger_out  <= 1'd0;
        sss_req                             <= 1'd0;
        stagger_cnt_start                   <= 1'd0;
        sl2l_fsm_stagger_within_en          <= 1'd0;
        tx_alarm                            <= 1'd0;
        rx_alarm                            <= 1'd0;
        addr_gen_jump_to_rst_entry          <= 1'd0;
        addr_gen_common_block_rst_done_reg  <= 1'd0;
        pause_grant                         <= 1'd0;
        sip_freeze_ack                      <= 1'd0;
        initiator_mon_fail                  <= 1'd0;
        initiator_instr_done                <= 1'd0;
        addr_gen_abort_instr                <= 1'd0;
        inter_flag                          <= 1'd0; //revert change
        sl2l_interleave_active              <= 2'd0; //revert change
        des_st_change_flag                  <= 1'd0;
        sfreeze_tx_rx_sel                   <= 1'd0;
        alarm_active                        <= 1'b0;
        alarm_active_tx                     <= 1'b0;
        alarm_active_rx                     <= 1'b0;
        go_back_to_trig_wait                <= 1'b0;
        src_fsm_target_instr_done           <= 1'b0;
        wait_4clk                           <= 2'd0;//0.3461
        tx_des_st_reached_reg               <= 1'd0;//0.3472
        rx_des_st_reached_reg               <= 1'd0;//0.3472
        tx_desired_state_reg                <= 1'd0;//0.38
        rx_desired_state_reg                <= 1'd0;//0.38
        entry_btwn_exit_flag                <= 1'd0;
        error_from_target_flag              <= 1'd0;
        sl2l_tx_init_rst_done_for_err       <= 1'd0;
        sl2l_rx_init_rst_done_for_err       <= 1'd0;
    end
    else begin
        //src_fsm_state_reg <= src_fsm_state; //revert change
        //inter_flag <= ( src_fsm_state_reg == ST_INTERLEAVED_ST_CHK);//revert change
        case (src_fsm_state)
            ST_COMMON_RSRC_RST_EXIT: begin //5'd0 //Start of every instruction in common rsrc rst exit sequence
                sss_req              <= 1'd0;
                addr_gen_abort_instr <= 1'd0; //after instr abort due to any condn check fail, control comes back to this state. so clear abort
                addr_gen_common_block_rst_done_reg <= addr_gen_common_block_rst_done;
                initiator_instr_done <= 1'd0;
                if(addr_gen_common_block_rst_done && all_lane_cmn_rsrc_done) begin // if common rsrc rst exit done, go to reset exit sequence //revert change ww42.5
                    src_fsm_state        <= ST_FULLY_RST;
                    //sl2l_fsm_tx_rx_out   <= (src_csr_role_cfg_reg[11] && (addr_gen_inst_rd_addr>=TX_LANE_OPERATIONAL_STATE_POINTER)) || !src_csr_role_cfg_reg[10]; //cmntd v0.55
                    sl2l_fsm_tx_rx_out   <= !src_csr_role_cfg_reg[10]; //v0.55 set to tx if tx is enabled. if not set to RX (addr will always be at tx reset addr at this point
                    tx_desired_state_reg <= 1'd1;//0.54
                    rx_desired_state_reg <= 1'd1;//0.54
                end
                else if (!addr_gen_common_block_rst_done)begin 
                         //initiate instr by sending rd req to addr_gen //no wait for trigger for common rsrc rst exit //revert change ww42.5
                    sl2l_fsm_tx_rx_out<= 1'd0;
                    return_state      <= ST_COMMON_RSRC_RST_EXIT;
                    addr_gen_rd_req   <= 1'd1;//1st 40bit read
                    src_fsm_state     <= ST_INSTR_RD_START;
                    sl2l_fsm_ready_or_desired_state_out <= 1'd0;
                end
            end//ST_COMMON_RSRC_RST_EXIT
            ST_RESET_EXIT_INSTR_START: begin //5'd1 //Start of every instruction in rst exit sequence
                sss_req                    <= 1'd0;
                addr_gen_abort_instr       <= 1'd0; //after instr abort due to any condn check fail, control comes back to this state. so clear abort
                mux_txrx_desired_state_reg <= 1'd0;
                src_fsm_target_instr_done  <= 1'd0; //v0.58
                // tx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? tx_desired_state_reg : 1'd0; //commented in v0.46
                // rx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? 1'd0 : rx_desired_state_reg; //commented in v0.46
                initiator_instr_done       <= 1'd0;
                tx_des_st_reached_reg      <= tx_des_st_reached;//v0.3472
                rx_des_st_reached_reg      <= rx_des_st_reached;//v0.3472
                //if((src_csr_role_cfg_reg[11]&&addr_gen_rx_fully_op&&(!src_csr_role_cfg_reg[10] || addr_gen_tx_fully_op)) || 
                    //if rx enabled and rx fully op address is complete and tx disabled or fully op complete
                if((cur_prof_des_st_reached && (((other_prof_des_st_reached)&& is_duplex) || !is_duplex)) ||  //v0.37 //v0.381
                   //(!src_csr_role_cfg_reg[11]&&addr_gen_tx_fully_op)|| //if rx disabled and tx fully op address is complete
                   //(interleave_active&&(addr_gen_rx_fully_op||addr_gen_tx_fully_op))) //if interleave_active and other profile is fully_op
                   ((|sl2l_interleave_active) &&(addr_gen_rx_fully_op||addr_gen_tx_fully_op))) //if interleave_active and other profile is fully_op //revert_change
                begin
                    inter_flag <= 1'b0;  //revert_change
                    src_fsm_state <= ST_FULLY_OP;
                    //src_fsm_target_instr_done <= 1'd0; //0.346 //commented in 0.58
                    //sl2l_fsm_ready_or_desired_state_out <= !initiator;//v0.18
                    if (!initiator) begin
                        sl2l_fsm_ready_or_desired_state_out <= 1'b1;//v0.19 //v0.31 changing to 1 instead of 0
                    end
                end
                /* if(src_csr_role_cfg[11]&&addr_gen_rx_fully_op)//if rx enabled and rx fully op address is complete, go to rx fully op state
                    src_fsm_state <= ST_FULLY_OP;
                else if (!src_csr_role_cfg[11]&&addr_gen_tx_fully_op)//if rx disabled and tx fully op address is complete, go to tx fully op state
                    src_fsm_state <= ST_FULLY_OP; */
                else if(initiator) begin
                    /*if(des_st_change_flag)
                        //sl2l_fsm_tx_rx_out   <= !(src_csr_role_cfg_reg[10] && addr_gen_tx_fully_rst && !sync_tx_lane_desired_state);
                           //set to 1 if rx desired st is changed to 0. set to 0 if tx des st is 0 
                        //sl2l_fsm_tx_rx_out   <= !tx_desired_state_reg ? 1'd0 : (!rx_desired_state_reg ? 1'd1 : sl2l_fsm_tx_rx_out) ; //v0.53
                        sl2l_fsm_tx_rx_out   <= is_duplex ? tx_desired_state_reg : src_csr_role_cfg_reg[11]; 
                           // V0.53 optimized - either tx or rx des st reg will be 0 when des_st_change_flag is set. if both 0, preference to tx.
                    else*/ //commented in v0.55; same condition can be used for both des_st_change_flag and !des_st_change_flag cases
                        //sl2l_fsm_tx_rx_out   <= (src_csr_role_cfg_reg[11] && (addr_gen_inst_rd_addr>=TX_LANE_OPERATIONAL_STATE_POINTER)) || !src_csr_role_cfg_reg[10];
                           //if tx not enabled, rx valid. if rx enabled and addr crossed tx last addr, rx valid
                        //sl2l_fsm_tx_rx_out   <= (is_duplex && addr_gen_rx_fully_op && !addr_gen_tx_fully_op) ? 1'd0 : 
                           //(src_csr_role_cfg_reg[11] && (addr_gen_inst_rd_addr>=TX_LANE_OPERATIONAL_STATE_POINTER)) || !src_csr_role_cfg_reg[10];
                               //if tx not enabled, rx valid. if rx enabled and addr crossed tx last addr, rx valid//cmntd in v0.3472
                        //sl2l_fsm_tx_rx_out   <= (is_duplex && rx_des_st_reached && !tx_des_st_reached) ? 1'd0 : 
                                                    //(src_csr_role_cfg_reg[11] && (addr_gen_inst_rd_addr>=TX_LANE_OPERATIONAL_STATE_POINTER)) || !src_csr_role_cfg_reg[10];
                                                       //if tx not enabled, rx valid. if rx enabled and addr crossed tx last addr, rx valid //v0.3472
                        sl2l_fsm_tx_rx_out       <= is_duplex ? (tx_des_st_reached ? 1'd1 : (rx_des_st_reached ? 1'd0 : sl2l_fsm_tx_rx_out)) : sl2l_fsm_tx_rx_out; //v0.37
                        des_st_change_flag       <= 1'b0; //v0.55 clear des_st_change_flag in 1 clk so that the read proceeds for des_st_change_flag case
                    //else begin
                    if(!des_st_change_flag_reg && (sl2l_fsm_tx_rx_out_reg^sl2l_fsm_tx_rx_out) && (src_fsm_state_reg==ST_RESET_EXIT_INSTR_START)) begin 
                        //v0.3471 des_st_change_flag to avoid unnecessary transition to st19 
                        //v0.55 use reg version of des_st_change_flag since des_st_change_flag is now cleared in 1 clk
                        src_fsm_state            <= ST_INTERLEAVED_ST_CHK;
                    end
                    else if(!des_st_change_flag && ((sl2l_fsm_tx_rx_out&&!rx_des_st_reached) || (!sl2l_fsm_tx_rx_out&&!tx_des_st_reached))) begin 
                            // v0.48 don't start instr if des state is reached (//v0.55 =>) or if des_st has changed; give 1 clk for tx_rx_out to change
                        tx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? tx_desired_state_reg : 1'd0;
                        rx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? 1'd0 : rx_desired_state_reg; 
                        if((tx_des_st_reached_reg~^tx_des_st_reached) && (rx_des_st_reached_reg~^rx_des_st_reached)) begin //v0.3472
                            //des_st_change_flag       <= 1'b0; //v0.55 taking it outside the if
                            return_state             <= ST_RESET_EXIT_INSTR_START;
                            //src_fsm_state          <= st_clear_sticky_flags;
                            src_mon_clr_sticky_flags <= 2'b11;
                            addr_gen_rd_req          <= 1'd1;//1st 40bit read
                            src_fsm_state            <= ST_INSTR_RD_START; //cmntd in v0.63 sl2l_fsm_trigger_or_error_resp_in ? ST_RESET_ENTRY_INSTR_START : ST_INSTR_RD_START;
                            //error_from_target_flag   <= sl2l_fsm_trigger_or_error_resp_in; //cmntd in v0.63
                        end
                    end
                    //end
                end
                else begin //if target
                    //if( (interleave_active || (|sl2l_interleave_active)) && !stagger_cnt_start) begin //16 clk wait added in v0.34
                    /*if(!stagger_cnt_start) begin //16 clk wait added in v0.34 //intlv chk removed in v0.347 //moved to else in v0.3471
                        stagger_cnt_start         <= 1'd1;
                        stagger_sel               <= 1'd1;
                        stagger_after_num_of_clk  <= TRIG_WAIT_NUM_CLK;
                        scaling_fac_after         <= INTRLV_OR_TRIG_WAIT_SCALE_FACTOR;
                    end*/
                    //sl2l_fsm_tx_rx_out        <= (inter_flag )?sl2l_fsm_tx_rx_out: sl2l_fsm_tx_rx_in; //v0.33
                    //src_mon_clr_sticky_flags  <= 2'b11; //moved inside else in v0.3471
                    /*if(sl2l_fsm_desired_state_or_ready_in) begin//if ({mux_txrx_desired_state,mux_txrx_desired_state_reg}==2'b10) begin
                        src_fsm_state                      <= ST_RESET_ENTRY_INSTR_START;
                        addr_gen_jump_to_rst_entry         <= 1'd1;
                        sl2l_fsm_error_resp_or_trigger_out <= 1'd1;
                    end*/
                    //sl2l_fsm_tx_rx_out            <= is_duplex ? (addr_gen_tx_fully_op ? 1'd1 : 
                                                         //(addr_gen_rx_fully_op ? 1'd0 : sl2l_fsm_tx_rx_out)) : sl2l_fsm_tx_rx_out; //v0.345//cmntd in v0.3472
                    sl2l_fsm_tx_rx_out           <= is_duplex ? (tx_des_st_reached ? 1'd1 : (rx_des_st_reached ? 1'd0 : sl2l_fsm_tx_rx_out)) : sl2l_fsm_tx_rx_out; //v0.345 //v0.3472
                    if((sl2l_fsm_tx_rx_out_reg^sl2l_fsm_tx_rx_out) && (src_fsm_state_reg==ST_RESET_EXIT_INSTR_START)) begin //v0.3471
                        src_fsm_state            <= ST_INTERLEAVED_ST_CHK;
                        //src_fsm_target_instr_done<= 1'd0; //v0.49 //commented in 0.58
                    end
                    else begin
                        tx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? tx_desired_state_reg : 1'd0;
                        rx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? 1'd0 : rx_desired_state_reg;
                        if(!stagger_cnt_start && is_duplex) begin //16 clk wait added in v0.34 //intlv chk removed in v0.347 //duplex check added in v0.45
                            stagger_cnt_start         <= 1'd1;
                            stagger_sel               <= 1'd1;
                            stagger_after_num_of_clk  <= TRIG_WAIT_NUM_CLK;
                            scaling_fac_after         <= INTRLV_OR_TRIG_WAIT_SCALE_FACTOR;
                        end
                        src_mon_clr_sticky_flags  <= 2'b11;
                        if (sl2l_fsm_trigger_or_error_resp_in && !sl2l_fsm_trigger_or_error_resp_in_dly && (sl2l_fsm_tx_rx_out~^sl2l_fsm_tx_rx_in) ) begin 
                            //v0.47 added txrx in out check. accept trigger only if tx rx in/out are same
                            des_st_change_flag                  <= 1'b0;
                            stagger_cnt_start                   <= 1'd0; //aborting the wait since trigger is received
                            //sl2l_fsm_tx_rx_out                  <= (inter_flag )?sl2l_fsm_tx_rx_out: sl2l_fsm_tx_rx_in; //v0.33
                            //sl2l_fsm_tx_rx_out                  <= fsm_common_initiator ? sl2l_fsm_tx_rx_in : ( (inter_flag )?sl2l_fsm_tx_rx_out: sl2l_fsm_tx_rx_in); //v0.341
                            //sl2l_fsm_tx_rx_out                  <= (fsm_common_initiator || !inter_flag) ? sl2l_fsm_tx_rx_in : sl2l_fsm_tx_rx_out; //v0.341 //commented in v0.345
                            //sl2l_fsm_ready_or_desired_state_out <= 1'd0; //commented in 0.346
                            return_state                        <= ST_RESET_EXIT_INSTR_START;
                            //src_fsm_target_instr_done           <= 1'd0; //0.344 //commented in 0.58
                            /*if(mux_txrx_desired_state_reg != sl2l_fsm_desired_state_or_ready_in) begin
                                src_fsm_state                       <= ST_RESET_ENTRY_INSTR_START;
                                addr_gen_jump_to_rst_entry          <= 1'd1;
                                sl2l_fsm_error_resp_or_trigger_out  <= 1'd1;
                                addr_gen_rd_req                     <= 1'd0;
                            end
                            else begin*/
                            if(sl2l_fsm_desired_state_or_ready_in) begin//if ({mux_txrx_desired_state,mux_txrx_desired_state_reg}==2'b10) begin
                                src_fsm_state                       <= ST_RESET_ENTRY_INSTR_START;
                                addr_gen_jump_to_rst_entry          <= 1'd1;
                                //sl2l_fsm_error_resp_or_trigger_out  <= 1'd1;//commented in 0.52
                                addr_gen_rd_req                     <= 1'd0;
                                entry_btwn_exit_flag                <= 1'd1;
                                //sl2l_fsm_ready_or_desired_state_out <= 1'd1; //0.346//commented in 0.52
                                //src_fsm_target_instr_done           <= 1'd1; //v0.50//commented in 0.52
                            end
                            else begin
                                src_fsm_state                       <= ST_INSTR_RD_START;
                                addr_gen_rd_req                     <= 1'd1;//1st 40bit read
                                sl2l_fsm_error_resp_or_trigger_out  <= 1'd0;
                                sl2l_fsm_ready_or_desired_state_out <= 1'd0; //0.346
                            end
                        end
                        /*else if(mux_txrx_desired_state) begin //v0.50 change st of target if desired st is changed to entry //commented in 0.52
                            if(src_fsm_target_instr_done) //v0.50 if done is set already, clear and set again for posedge of done for current instr (last exit instr before des_st change to entry)
                                src_fsm_target_instr_done           <= 1'd0;
                            else begin
                                src_fsm_target_instr_done           <= 1'd1;
                                src_fsm_state                       <= ST_RESET_ENTRY_INSTR_START;
                                addr_gen_jump_to_rst_entry          <= 1'd1;
                                sl2l_fsm_error_resp_or_trigger_out  <= 1'd1;
                                addr_gen_rd_req                     <= 1'd0;
                                sl2l_fsm_ready_or_desired_state_out <= 1'd1;
                            end
                        end*/
                        else begin
                            //sl2l_fsm_ready_or_desired_state_out <= 1'd1; //set ready 1 initially for target
                            //if( (interleave_active || (|sl2l_interleave_active))&& stagger_cnt_start && stagger_cnt_done) begin//2nd profile interleave status not reached after 16 clks wait, go check 1st
                            if(stagger_cnt_start && stagger_cnt_done) begin//2nd profile interleave status not reached after 16 clks wait, go check 1st //intlv chk removed in v0.347
                                stagger_cnt_start         <= 1'd0; //completing the wait
                                sl2l_fsm_tx_rx_out        <= !sl2l_fsm_tx_rx_out; //switch tx_rx_out in case of trig wait check
                                //src_fsm_target_instr_done <= 1'd0; //v0.49  //commented in 0.58
                                if(interleave_active || (|sl2l_interleave_active)) begin //v0.347
                                    go_back_to_trig_wait <= 1'd1;
                                    sl2l_fsm_ready_or_desired_state_out <= 1'd0; //v0.342 set ready to 0 since fsm moves to interleaved profile
                                    return_state         <= ST_RESET_EXIT_INSTR_START;
                                    src_fsm_state        <= ST_INTERLEAVE_MONITOR; //is_duplex can be rmvd here as interleave_active will not be set when is_duplex is 0?
                                    //src_fsm_target_instr_done <= 1'd0; //0.344 //commented in v0.49
                                end
                                else src_fsm_state       <= ST_INTERLEAVED_ST_CHK; //v0.3471
                            end
                            else begin
                                sl2l_fsm_ready_or_desired_state_out <= 1'd1; //set ready 1 initially for target
                                go_back_to_trig_wait                <= 1'd0;
                            end
                        end
                    end
                end
            end//ST_RESET_EXIT_INSTR_START
            ST_RESET_ENTRY_INSTR_START: begin  //5'd2 // no interleave for reset entry
                sss_req                    <= 1'd0;
                addr_gen_abort_instr       <= 1'd0; //after instr abort due to any condn check fail, control comes back to this state. so clear abort
                //tx_alarm                   <= sl2l_fsm_tx_rx_out ? tx_alarm : 1'd0; //v0.64 clear only for tx //v0.6533
                addr_gen_jump_to_rst_entry <= 1'd0;
                mux_txrx_desired_state_reg <= 1'd1;
                src_fsm_target_instr_done  <= 1'd0; //v0.58
                sl2l_tx_init_rst_done_for_err <= addr_gen_tx_fully_rst ? 1'd0 : sl2l_tx_init_rst_done_for_err;//v0.63 clear once rst entry is done
                sl2l_rx_init_rst_done_for_err <= addr_gen_rx_fully_rst ? 1'd0 : sl2l_rx_init_rst_done_for_err;//v0.63 clear once rst entry is done
                if(!((sl2l_fsm_tx_rx_out_reg^sl2l_fsm_tx_rx_out) && (src_fsm_state_reg==ST_RESET_ENTRY_INSTR_START))) begin 
                      //dont update if tx rx out changed in this same state due to des_st_reach condition of 1 profile //v0.46
                    tx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? tx_desired_state_reg : 1'd1;
                    rx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? 1'd1 : rx_desired_state_reg;
                end
                initiator_instr_done       <= 1'd0;
                tx_des_st_reached_reg      <= tx_des_st_reached;//v0.3472
                rx_des_st_reached_reg      <= rx_des_st_reached;//v0.3472
                //if(sync_rx_clear_alarm) //v0.6537 
                    //rx_alarm               <= 1'd0; //0.v6537             
                /* if((src_csr_role_cfg[11]&&addr_gen_rx_fully_rst)|| //addr_gen_inst_rd_addr==RX_LANE_RESET_STATE_POINTER) ||
                    (!src_csr_role_cfg[11]&&addr_gen_tx_fully_rst)) //addr_gen_inst_rd_addr==TX_LANE_RESET_STATE_POINTER  ))//fully_rst */
                /*if((src_csr_role_cfg_reg[11]&&addr_gen_rx_fully_rst&&(!src_csr_role_cfg_reg[10] || addr_gen_tx_fully_rst)) || 
                        //if rx enabled and rx fully rst address is complete and tx disabled or tx fully rst
                   (!src_csr_role_cfg_reg[11]&&addr_gen_tx_fully_rst)|| //if rx disabled and tx fully rst address is complete
                   //(interleave_active&&(addr_gen_rx_fully_rst||addr_gen_tx_fully_rst))) 
                   ((|sl2l_interleave_active) &&(addr_gen_rx_fully_rst||addr_gen_tx_fully_rst)))//revert_change*/
                //if((rx_en&&addr_gen_rx_fully_rst&&(!tx_en || addr_gen_tx_fully_rst)) || //if rx enabled and rx fully rst address is complete and tx disabled or tx fully rst
                //if((!error_from_target_flag && cur_prof_des_st_reached && (((other_prof_des_st_reached) && is_duplex) || !is_duplex)) ||  //v0.37 //v0.381 //v0.62 added error flag
                if((!error_from_target_flag && !src_error_init_rst_done && cur_prof_des_st_reached && (((other_prof_des_st_reached) && is_duplex) || !is_duplex)) ||  //0.6536 added error flag
                  // (!rx_en&&addr_gen_tx_fully_rst)|| //if rx disabled and tx fully rst address is complete //commented in v0.51
                   //(interleave_active&&(addr_gen_rx_fully_rst||addr_gen_tx_fully_rst))) 
                   ((|sl2l_interleave_active) &&(addr_gen_rx_fully_rst||addr_gen_tx_fully_rst)))//revert_change
                begin
                    src_fsm_state <= ST_FULLY_RST;
                    //src_fsm_target_instr_done <= 1'd0; //0.346 //commented in 0.58
                    //inter_flag <= 1'b0; //revert_change
                    //sl2l_fsm_ready_or_desired_state_out <= !initiator;//v0.18
                    if (!initiator) begin
                        sl2l_fsm_ready_or_desired_state_out <= 1'b1;//v0.19 //v0.31 changing to 1 instead of 0
                    end
                end
                else if(initiator) begin
                    //sl2l_fsm_tx_rx_out  <= (src_csr_role_cfg_reg[11] && (addr_gen_inst_rd_addr>=TX_LANE_OPERATIONAL_STATE_POINTER)) || 
                                               //!src_csr_role_cfg_reg[10];//if tx not enabled, rx valid. if rx enabled and addr crossed tx last addr, rx valid
                    //sl2l_fsm_tx_rx_out  <= (rx_en && (addr_gen_inst_rd_addr>=TX_LANE_OPERATIONAL_STATE_POINTER)) || !tx_en;
                         //if tx not enabled, rx valid. if rx enabled and addr crossed tx last addr, rx valid
                    //sl2l_fsm_tx_rx_out  <= (is_duplex && addr_gen_tx_fully_rst && !addr_gen_rx_fully_rst) || 
                                                 //(rx_en && (addr_gen_inst_rd_addr>=TX_LANE_OPERATIONAL_STATE_POINTER)) || !tx_en;
                                                //if rx not enabled, tx valid. if tx enabled and addr crossed tx last addr, rx valid //cmntd in v0.3472
                    //sl2l_fsm_tx_rx_out    <= (is_duplex && rx_des_st_reached && !tx_des_st_reached) ? 1'd0 : 
                                                   //(src_csr_role_cfg_reg[11] && (addr_gen_inst_rd_addr>=TX_LANE_OPERATIONAL_STATE_POINTER)) || !src_csr_role_cfg_reg[10];
                    sl2l_fsm_tx_rx_out            <= (is_duplex && !error_from_target_flag) ? (tx_des_st_reached ? 1'd1 : (rx_des_st_reached ? 1'd0 : sl2l_fsm_tx_rx_out)) : sl2l_fsm_tx_rx_out; //v0.37
                                                                   //error_from_target_flag added in 0.62 - no tx_rx_out change based on des_st_reached if error is present
                    //if (mux_txrx_desired_state) begin //desired st is checked at the beginning of instr sequence
                    if((sl2l_fsm_tx_rx_out_reg^sl2l_fsm_tx_rx_out) && (src_fsm_state_reg==ST_RESET_ENTRY_INSTR_START)) begin //v0.3471
                        src_fsm_state            <= ST_INTERLEAVED_ST_CHK;
                    end
                    else if( (error_from_target_flag || (sl2l_fsm_tx_rx_out&&!rx_des_st_reached) || (!sl2l_fsm_tx_rx_out&&!tx_des_st_reached)) && //error flag addeed in 0.62
                                (tx_des_st_reached_reg~^tx_des_st_reached) && (rx_des_st_reached_reg~^rx_des_st_reached)) begin 
                                 //v0.3472 //v0.48 don't start instr if des state is reached
                        return_state             <= ST_RESET_ENTRY_INSTR_START;
                        //src_fsm_state          <= st_clear_sticky_flags;
                        src_mon_clr_sticky_flags[0]  <= alarm_active_tx;//tx
                        src_mon_clr_sticky_flags[1]  <= alarm_active_rx;//rx
                        addr_gen_rd_req          <= 1'd1;//1st 40bit read
                        src_fsm_state            <= ST_INSTR_RD_START;
                        error_from_target_flag   <= 1'd0; //v0.62
                        tx_alarm                   <= sl2l_fsm_tx_rx_out ? tx_alarm : 1'd0; // clear only for tx //v0.6533
                        rx_alarm                   <= sl2l_fsm_tx_rx_out ? 1'b0 : rx_alarm; //v0.6537
                    end
                    //end
                end
                else begin//if target
                    //if( (interleave_active || (|sl2l_interleave_active)) && !stagger_cnt_start) begin //16 clk wait added in v0.34
                    /*if(!stagger_cnt_start) begin //16 clk wait added in v0.34 //intlv chk removed in v0.347 //moved to else in v0.3471
                        stagger_cnt_start         <= 1'd1;
                        stagger_sel               <= 1'd1;
                        stagger_after_num_of_clk  <= TRIG_WAIT_NUM_CLK;
                        scaling_fac_after         <= INTRLV_OR_TRIG_WAIT_SCALE_FACTOR;
                    end*/
                    //sl2l_fsm_tx_rx_out                 <= is_duplex ? (addr_gen_tx_fully_rst ? 1'd1 : 
                                                             //(addr_gen_rx_fully_rst ? 1'd0 : sl2l_fsm_tx_rx_out)) : sl2l_fsm_tx_rx_out; //v0.345 //cmntd in v0.3472
                    sl2l_fsm_tx_rx_out                 <= (is_duplex && !src_error_init_rst_done) ? (tx_des_st_reached ? 1'd1 : (rx_des_st_reached ? 1'd0 : sl2l_fsm_tx_rx_out)) : sl2l_fsm_tx_rx_out;  //v0.3536

                    //sl2l_fsm_tx_rx_out                 <= is_duplex ? (tx_des_st_reached ? 1'd1 : (rx_des_st_reached ? 1'd0 : sl2l_fsm_tx_rx_out)) : sl2l_fsm_tx_rx_out; //v0.345 //v0.3472
                    //sl2l_fsm_tx_rx_out                 <= (inter_flag )?sl2l_fsm_tx_rx_out: sl2l_fsm_tx_rx_in; //0.33
                    /*src_mon_clr_sticky_flags[0]        <= alarm_active_tx;//tx //moved to else in v0.3471
                    src_mon_clr_sticky_flags[1]        <= alarm_active_rx;//rx
                    initiator_mon_fail                 <= 1'd0;*/
                    //sl2l_fsm_error_resp_or_trigger_out <= 1'd0;
                    if((sl2l_fsm_tx_rx_out_reg^sl2l_fsm_tx_rx_out) && (src_fsm_state_reg==ST_RESET_ENTRY_INSTR_START)) begin //v0.3471
                        src_fsm_state            <= ST_INTERLEAVED_ST_CHK;
                        //src_fsm_target_instr_done<= 1'd0;//v0.49 //commented in 0.58
                    end
                    else begin
                        if(!stagger_cnt_start && is_duplex) begin //16 clk wait added in v0.34 //intlv chk removed in v0.347 //duplex check added in v0.45
                            stagger_cnt_start         <= 1'd1;
                            stagger_sel               <= 1'd1;
                            stagger_after_num_of_clk  <= TRIG_WAIT_NUM_CLK;
                            scaling_fac_after         <= INTRLV_OR_TRIG_WAIT_SCALE_FACTOR;
                        end
                        src_mon_clr_sticky_flags[0]        <= alarm_active_tx;//tx
                        src_mon_clr_sticky_flags[1]        <= alarm_active_rx;//rx
                        initiator_mon_fail                 <= 1'd0;
                        if (entry_btwn_exit_flag || initiator_mon_fail || (sl2l_fsm_trigger_or_error_resp_in && !sl2l_fsm_trigger_or_error_resp_in_dly && 
                              (sl2l_fsm_tx_rx_out~^sl2l_fsm_tx_rx_in) && sl2l_fsm_desired_state_or_ready_in)) begin
                               //v0.47 added txrx in out check. accept trigger only if tx rx in/out are same //v0.50 accept trigger only if l2l des st is rst entry 
                               //added entry_btwn_exit_flag in v0.52
                            entry_btwn_exit_flag               <= 1'd0;
                            stagger_cnt_start                  <= 1'd0; //aborting the wait since trigger is received
                            //sl2l_fsm_tx_rx_out                  <= (inter_flag )?sl2l_fsm_tx_rx_out: sl2l_fsm_tx_rx_in; //0.33
                            //sl2l_fsm_tx_rx_out                  <= fsm_common_initiator ? sl2l_fsm_tx_rx_in : ( (inter_flag )?sl2l_fsm_tx_rx_out: sl2l_fsm_tx_rx_in); //v0.35
                            //sl2l_fsm_tx_rx_out                  <= (fsm_common_initiator || !inter_flag) ? sl2l_fsm_tx_rx_in : sl2l_fsm_tx_rx_out; //v0.341 //commented in v0.345
                            sl2l_fsm_ready_or_desired_state_out <= 1'd0;
                            return_state                        <= ST_RESET_ENTRY_INSTR_START;
                            src_fsm_state                       <= ST_INSTR_RD_START;
                            addr_gen_rd_req                     <= 1'd1;//1st 40bit read
                            sl2l_fsm_error_resp_or_trigger_out  <= 1'd0;
                            //src_fsm_target_instr_done           <= 1'd0; //commented in 0.58
                            tx_alarm                   <= sl2l_fsm_tx_rx_out ? tx_alarm : 1'd0; // clear only for tx //v0.6533
                            rx_alarm                   <= sl2l_fsm_tx_rx_out ? 1'b0 : rx_alarm; //v0.6537
                        end
                        else begin
                            //sl2l_fsm_ready_or_desired_state_out <= 1'd1; //set ready 1 initially for target
                            //if( (interleave_active || (|sl2l_interleave_active))&& stagger_cnt_start && stagger_cnt_done) begin
                                  //2nd profile interleave status not reached after 16 clks wait, go check 1st
                            if(stagger_cnt_start && stagger_cnt_done) begin
                                  //2nd profile interleave status not reached after 16 clks wait, go check 1st //intlv chk removed in v0.347
                                stagger_cnt_start         <= 1'd0; //completing the wait
                                sl2l_fsm_tx_rx_out        <= !sl2l_fsm_tx_rx_out; //switch tx_rx_out in case of trig wait check
                                //src_fsm_target_instr_done <= 1'd0; //v0.49 //commented in 0.58
                                if(interleave_active || (|sl2l_interleave_active)) begin //v0.347
                                    go_back_to_trig_wait                <= 1'd1;
                                    sl2l_fsm_ready_or_desired_state_out <= 1'd0; //v0.342 set ready to 0 since fsm moves to interleaved profile
                                    return_state                        <= ST_RESET_ENTRY_INSTR_START;
                                    src_fsm_state                       <= ST_INTERLEAVE_MONITOR; //is_duplex can be rmvd here as interleave_active will not be set when is_duplex is 0?
                                    //src_fsm_target_instr_done <= 1'd0; //0.344 //commented in v0.49
                                end
                                else src_fsm_state       <= ST_INTERLEAVED_ST_CHK; //v0.3471
                            end
                            else begin 
                                sl2l_fsm_ready_or_desired_state_out <= 1'd1; //set ready 1 initially for target
                                go_back_to_trig_wait                <= 1'd0;
                            end
                        end
                    end
                end
            end//ST_RESET_ENTRY_INSTR_START
            ST_INSTR_RD_START: begin  //5'd3 //rd addr sent to m20k
                inter_flag               <= 1'b0; //revert change
                sfreeze_tx_rx_sel        <= sl2l_fsm_tx_rx_out;
                src_mon_clr_sticky_flags <= 2'd0;
                addr_gen_rd_req          <= 1'd1;//2nd 40bit read
                src_fsm_state            <= ST_INSTR_RD_WAIT;
            end//ST_INSTR_RD_START
            ST_INSTR_RD_WAIT: begin //5'd4
                addr_gen_rd_req          <= 1'd1;//3rd 40bit read
                src_fsm_state            <= ST_INSTR_RD_WAIT1;
            end//ST_INSTR_RD_WAIT
            ST_INSTR_RD_WAIT1: begin //5'd21
                addr_gen_rd_req          <= 1'd1;//4th 40bit read
                src_fsm_state            <= ST_RECV_BYTE0_4;
            end//ST_INSTR_RD_WAIT1
            ST_RECV_BYTE0_4: begin  //5'd5
                //check0: if shared resource (common)
                //check1: for reset entry/exit (invalid if check0 is true)
                //check2: for condn to check- 13 cases for condn to chk: for each case check corresponding fn_mode_reg bit.
                //Check3: for fn mode- 14 cases for each possible value of fn_mode_reg[4:0] - check corresponding bit from vliw data.
                addr_gen_rd_req               <= 1'd0;//4 rd req to addr gen completed
                vliw_monitor_reg[7:0]         <= m20k_rom_data_in[39:32];
                vliw_instr_type               <= m20k_rom_data_in[8];
                vliw_leader_follower_val_chk  <= tx_leader ? m20k_rom_data_in[9] : m20k_rom_data_in[10];
                //v0.6533
                case(m20k_rom_data_in[7:3]) //make it combo logic if 1 clk needs to be saved and if it's ok to increase resource usage
                    5'd1:    vliw_condition_pass <= src_csr_func_mode_cfg[10]    ;  //FLUX enable
                    5'd2:    vliw_condition_pass <= src_csr_func_mode_cfg[11]    ;  //FLUX using system clock
                    5'd3:    vliw_condition_pass <= src_csr_func_mode_cfg[12]    ;  //UX DPMA using system clock
                    5'd4:    vliw_condition_pass <= src_csr_func_mode_cfg[13]    ;  //Ethernet Mode and System clock
                    5'd5:    vliw_condition_pass <= src_csr_func_mode_cfg_fec_en ;  //FEC is enabled
                    5'd6:    vliw_condition_pass <= !src_csr_func_mode_cfg_fec_en; //FEC is disabled
                    5'd7:    vliw_condition_pass <= src_csr_func_mode_cfg[16]    ; //PTP Enable
                    5'd8:    vliw_condition_pass <= src_csr_func_mode_cfg[17]    ; //Flux is used for RX adaptation
                    5'd9:    vliw_condition_pass <= !src_csr_func_mode_cfg[17]   ;//Flux is not used for RX adaptation
                    5'd10:   vliw_condition_pass <= src_csr_func_mode_cfg_dl_en  ; //dl_en = 1
                    5'd11:   vliw_condition_pass <= src_csr_func_mode_cfg[20]    ; //UX_en = 1
                    5'd12:   vliw_condition_pass <= src_csr_func_mode_cfg_pcs_en ; //PCS enabled
                    5'd13:   vliw_condition_pass <= src_csr_func_mode_cfg[23]    ; //Non PTP Chanel
                    5'd17:   vliw_condition_pass <= src_csr_func_mode_cfg[16] && src_csr_func_mode_cfg_dl_en ; //PTP_enable & dl_en
                    default: vliw_condition_pass <= 1'd1;
                endcase
                case(src_csr_func_mode_cfg_tx_rx[4:0]) //make it combo logic if 1 clk needs to be saved and if it's ok to increase resource usage
                    5'd0:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[11]; //Normal-Mode PMA Direct  (!SOFT PIPE)
                    5'd1:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[12]; //Normal-Mode PMA Direct  (SOFT PIPE)
                    5'd2:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[13]; //Normal-Mode FEC Direct
                    5'd3:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[14]; //Normal-Mode PCS Direct  (w/o FEC)
                    5'd4:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[15]; //Normal-Mode PCS Direct  (with FEC)
                    5'd5:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[16]; //Normal-Mode MAC (w/o FEC)
                    5'd6:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[17]; //Normal-Mode MAC (w/FEC)
                    5'd7:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[18]; //PLL-Master-Mode PMA Direct  (!SOFT PIPE)
                    5'd8:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[19]; //PLL-Master-Mode FEC Direct
                    5'd9:    vliw_fn_mode_chk_pass <= m20k_rom_data_in[20]; //PLL-Master-Mode PCS Direct  (w/o FEC)
                    5'd10:   vliw_fn_mode_chk_pass <= m20k_rom_data_in[21]; //PLL-Master-Mode PCS Direct  (with FEC)
                    5'd11:   vliw_fn_mode_chk_pass <= m20k_rom_data_in[22]; //PLL-Master-Mode MAC (w/o FEC)
                    5'd12:   vliw_fn_mode_chk_pass <= m20k_rom_data_in[23]; //PLL-Master-Mode MAC (w/FEC)
                    5'd13:   vliw_fn_mode_chk_pass <= m20k_rom_data_in[24]; //PCIE
                    default: vliw_fn_mode_chk_pass <= 1'd0;
                endcase
                if (!addr_gen_common_block_rst_done_reg || (m20k_rom_data_in[0] && !mux_txrx_desired_state_reg) ||
                   (m20k_rom_data_in[1] && mux_txrx_desired_state_reg) ) begin //if not common resource and if instr not valid for rst entry/exit ->abort instr
                    //addr_gen_rd_req   <= 1'd1;//4th 40bit read
                    src_fsm_state     <= ST_RECV_BYTE5_9;
                end
                else begin // check fail; abort read;
                    //addr_gen_rd_req      <= 1'd0;
                    addr_gen_abort_instr <= 1'd1;
                    if (initiator) begin
                        sl2l_fsm_error_resp_or_trigger_out  <= 1'd1;
                        sl2l_fsm_ready_or_desired_state_out <= mux_txrx_desired_state_reg;
                        src_fsm_state                       <= ST_COMPLETE_WAIT;
                        initiator_instr_done                <= 1'd1;
                    end
                    else begin
                        sl2l_fsm_ready_or_desired_state_out <= 1'd1;
                        //src_fsm_state                       <= return_state; //v0.343
                        src_fsm_state                       <= ST_TGT_INSTR_DONE_WAIT_1CLK; //v0.343
                    end
                end
            end//ST_RECV_BYTE0_4
            ST_RECV_BYTE5_9: begin //5'd6
                //addr_gen_rd_req        <= 1'd0;//4 rd req to addr gen completed
                vliw_monitor_reg[13:8] <= m20k_rom_data_in[5:0]; //v0.653
                vliw_monitor_value     <= m20k_rom_data_in[10];
                vliw_wait_point        <= |m20k_rom_data_in[9:8];
               //Don't check for reset entry- store unconditionally;
               //update at next state if reset exit:
                stagger_within_num_of_clk [7:0]  <= m20k_rom_data_in[23:16];
                scaling_fac_within[1:0]          <= m20k_rom_data_in[25:24];
                stagger_after_num_of_clk [11:0]  <= m20k_rom_data_in[39:28]; //msb 2 bits updated in next state
                scaling_fac_after[1:0]           <= m20k_rom_data_in[27:26];
                if(vliw_condition_pass && vliw_fn_mode_chk_pass && vliw_leader_follower_val_chk) begin
                    src_fsm_state     <= ST_RECV_BYTE10_14;
                end
                else begin // check fail; abort read;
                    addr_gen_abort_instr <= 1'd1;
                    if (initiator) begin
                        sl2l_fsm_error_resp_or_trigger_out      <= 1'd1;
                        sl2l_fsm_ready_or_desired_state_out <= mux_txrx_desired_state_reg;
                        src_fsm_state                       <= ST_COMPLETE_WAIT;
                        initiator_instr_done                <= 1'd1;
                    end
                    else begin
                        sl2l_fsm_ready_or_desired_state_out <= 1'd1;
                        //src_fsm_state                       <= return_state; //v0.343
                        src_fsm_state                       <= ST_TGT_INSTR_DONE_WAIT_1CLK; //v0.343
                    end
                end
            end//ST_RECV_BYTE5_9
            ST_RECV_BYTE10_14: begin //5'd7
                if (!mux_txrx_desired_state_reg) begin
                    stagger_within_num_of_clk [7:0]  <= m20k_rom_data_in[15:8];
                    scaling_fac_within[1:0]          <= m20k_rom_data_in[3:2];
                    stagger_after_num_of_clk [13:0]  <= m20k_rom_data_in[29:16];
                    scaling_fac_after[1:0]           <= m20k_rom_data_in[5:4];
                end
                else // for reset entry
                    stagger_after_num_of_clk [13:12] <= m20k_rom_data_in[1:0];

                vliw_drive_reg[7:0] <= m20k_rom_data_in[39:32];
                src_fsm_state       <= ST_RECV_BYTE15_19;
            end//ST_RECV_BYTE10_14
            ST_RECV_BYTE15_19: begin //5'd8
                vliw_drive_reg[27:8]<= m20k_rom_data_in[19:0];
                if (!mux_txrx_desired_state_reg)
                    vliw_drive_val <= m20k_rom_data_in[22];
                else
                    vliw_drive_val <= m20k_rom_data_in[23];

                if (!vliw_instr_type) begin // monitor valid (trigger all targets if initiator and) go to st_monitor
                    sl2l_fsm_error_resp_or_trigger_out  <= initiator; //trigger all targets if initiator
                    sl2l_fsm_ready_or_desired_state_out <= initiator && mux_txrx_desired_state_reg;
                    src_fsm_state                       <= (addr_gen_common_block_rst_done_reg && vliw_wait_point && is_duplex && tx_or_rx_fully_des_st_not_reached) ? ST_INTERLEAVE_MONITOR : ST_CUR_PROFILE_MONITOR;
                end
                else begin//if drive
                    /*sss_req       <= initiator; // send request to shoreline sequencer for initiator lanes
                    src_fsm_state <= initiator ? ST_SHORELINE_REQ : ST_DRIVE; // wait for grant for initiator lanes */
                    sss_req       <= 1'd1; // send request to shoreline sequencer for all lanes v0.57
                    src_fsm_state <= ST_SHORELINE_REQ; // wait for grant for all lanes v0.57 //v0.61 fixed the shoreline req/grant issue
                end
            end//ST_RECV_BYTE15_19
            ST_INTERLEAVE_MONITOR: begin //5'd9
                //if (vliw_wait_point) begin
                // double interleave possible; wait to be added later.
                //if(interleave_active) begin // if double interleaving
               // if(!initiator) sl2l_fsm_ready_or_desired_state_out <= 1'd0; //v0.34 clearing ready (for target) when it comes from trigger wait to interleave
                if(|sl2l_interleave_active) begin // if double interleaving //revert_change
                    //if(&(concatenated_monitor_signals[12:0] | (~interleave_monitor_reg) )) begin //1st profile interleave status reached, store 2nd prof's details and go to 1st
                        //if ((&(concatenated_monitor_signals[12:0] | (~interleave_monitor_reg) )) == 1'd1) begin
                        //signal to monitor will be 0 on right side and when it is 1 on left, OR output=1; for other signals, right side will be 1, so OR output will be 1
                        //store 2nd interleave details
                    if(!stagger_cnt_start) begin //16 clk wait added in v0.34
                        stagger_cnt_start         <= 1'd1;
                        stagger_sel               <= 1'd1;
                        stagger_after_num_of_clk  <= INTRLV_WAIT_NUM_CLK;
                        scaling_fac_after         <= INTRLV_OR_TRIG_WAIT_SCALE_FACTOR;
                    end

                    if(&interleave_monitoring_status) begin // if true interleave is already active for 1 , and that is finished
                        stagger_cnt_start       <= 1'd0; //aborting the wait v0.34
                        go_back_to_trig_wait    <= 1'd0; //v0.34
                        sl2l_fsm_error_resp_or_trigger_out <= 1'd0; //clear trigger when interleaving happens
                        //interleave_active       <= 1'd1;//commented in v0.34
                        interleave_active       <= !go_back_to_trig_wait;//v0.34
                        sl2l_interleave_active  <= go_back_to_trig_wait ? 2'd0 : ((sl2l_fsm_tx_rx_out)? {1'b0,1'b1} : {1'b1,1'b0}); //revert_change  
                                                                                   // If TX is active , RX interleave is completed and viceversa[0]: RX , [1] TX
                        //sl2l_interleave_active  <= 2'b0 ; //revert_change 
                        interleave_monitor_reg  <= vliw_monitor_reg;
                        interleave_monitor_val  <= vliw_monitor_value;
                        interleave_return_state <= return_state;
                        interleave_des_st_reg   <= mux_txrx_desired_state_reg;
                        //store 2nd interleave details
                        if(!go_back_to_trig_wait) sl2l_fsm_tx_rx_out    <= !sl2l_fsm_tx_rx_out;
                        inter_flag <= 1'd1; //revert change
                        if((!go_back_to_trig_wait&&interleave_initiator) || (go_back_to_trig_wait && initiator)) begin
                             //check initiator incase of trigger wait interleave since tx_rx_out changes before hand in that case
                            src_fsm_state              <= ST_COMPLETE_WAIT;
                            initiator_instr_done       <= 1'd1;
                            return_state               <= interleave_return_state;
                            mux_txrx_desired_state_reg <= interleave_des_st_reg;
                            if(go_back_to_trig_wait) begin
                                tx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? tx_desired_state_reg : interleave_des_st_reg;
                                rx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? interleave_des_st_reg : rx_desired_state_reg;
                            end
                            else begin
                                tx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? interleave_des_st_reg : tx_desired_state_reg;
                                rx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? rx_desired_state_reg : interleave_des_st_reg;
                            end
                        end
                        else begin
                            sl2l_fsm_ready_or_desired_state_out <= 1'd1;
                            //src_fsm_state                       <= interleave_return_state; //v0.343
                            src_fsm_state                       <= ST_TGT_INSTR_DONE_WAIT_1CLK; //v0.343
                            return_state                        <= interleave_return_state;
                        end
                    end
                    else if(stagger_cnt_start && stagger_cnt_done) begin 
                            //if interleaved status isn't reached after 16clk wait, check current status //16 clk wait added in v0.34
                        stagger_cnt_start       <= 1'd0; //completing the wait
                        //src_fsm_state           <= go_back_to_trig_wait ? return_state : ST_CUR_PROFILE_MONITOR; //update v0.34
                        if(go_back_to_trig_wait) begin
                            src_fsm_state           <= return_state;
                            sl2l_fsm_tx_rx_out      <= !sl2l_fsm_tx_rx_out;//switch tx rx out for trig wait case
                            go_back_to_trig_wait    <= 1'd0;
                        end
                        else begin
                            src_fsm_state           <= ST_CUR_PROFILE_MONITOR; //update v0.34
                            inter_flag              <= 1'b0; //revert change
                            sl2l_interleave_active  <= 2'd3; //revert_change // Since both monitoring is not satisfied TX ,RX interleave is active
                        end
                    end
                end
                else begin // if no double interleaving
                    sl2l_fsm_error_resp_or_trigger_out <= 1'd0; //clear trigger when interleaving happens
                    interleave_active       <= 1'd1;
                    sl2l_interleave_active  <= (sl2l_fsm_tx_rx_out)? {sl2l_interleave_active[1],1'b1} : {1'b1,sl2l_interleave_active[0]}; //revert_change
                    sl2l_fsm_tx_rx_out      <= !sl2l_fsm_tx_rx_out;
                    inter_flag              <= 1'b1;//revert change
                    interleave_monitor_reg  <= vliw_monitor_reg;
                    interleave_monitor_val  <= vliw_monitor_value;
                    interleave_return_state <= return_state;
                    interleave_des_st_reg   <= mux_txrx_desired_state_reg;
                    src_fsm_state           <= ST_INTERLEAVED_ST_CHK;
                end
            end//ST_INTERLEAVE_MONITOR
            ST_CUR_PROFILE_MONITOR: begin //5'd10
                //if (&(concatenated_monitor_signals[12:0] | (~vliw_monitor_reg) )) begin
                if (&monitoring_status) begin
                //signal to monitor will be 0 on right side and when it is 1 on left, OR output=1; for other signals, right side will be 1, so OR output will be 1
                    stagger_cnt_start       <= 1'd0; //aborting the wait since monitoring_status is reached
                    sl2l_interleave_active  <= (sl2l_fsm_tx_rx_out)? {sl2l_interleave_active[1],1'b0} : {1'b0,sl2l_interleave_active[0]}; //revert_change  
                                               // If TX is active , TX interleave is completed and viceversa[0]: RX , [1] TX
                    if(initiator) begin
                        src_fsm_state        <= ST_COMPLETE_WAIT;
                        initiator_instr_done <= 1'd1;
                    end
                    else begin
                        sl2l_fsm_ready_or_desired_state_out <= 1'd1;
                        //src_fsm_state                       <= return_state; //v0.343
                        src_fsm_state                       <= ST_TGT_INSTR_DONE_WAIT_1CLK; //v0.343
                    end
                end
                //else if(interleave_active && vliw_wait_point && is_duplex)//double interleave; 2nd profile interleave status not reached, go check 1st
                //else if((interleave_active || (|sl2l_interleave_active)) && vliw_wait_point && is_duplex) begin
                else if((interleave_active || (|sl2l_interleave_active) || tx_or_rx_fully_des_st_not_reached ) && vliw_wait_point && is_duplex && addr_gen_common_block_rst_done_reg) begin //v0.6538
                        //double interleave; 2nd profile interleave status not reached, go check 1st //revert_change
                    if(!stagger_cnt_start) begin //16 clk wait added in v0.34
                        stagger_cnt_start         <= 1'd1;
                        stagger_sel               <= 1'd1;
                        stagger_after_num_of_clk  <= INTRLV_WAIT_NUM_CLK;
                        scaling_fac_after         <= INTRLV_OR_TRIG_WAIT_SCALE_FACTOR;
                    end
                    if(stagger_cnt_start && stagger_cnt_done) begin//2nd profile interleave status not reached after 16 clks wait, go check 1st
                        stagger_cnt_start <= 1'd0; //completing the wait
                        src_fsm_state     <= ST_INTERLEAVE_MONITOR; //is_duplex can be rmvd here as interleave_active will not be set when is_duplex is 0?
                    end
                    else src_fsm_state <= ST_CUR_PROFILE_MONITOR;
                end
                else//no interleave and no wait point or long wait
                    src_fsm_state <= ST_CUR_PROFILE_MONITOR;
            end//ST_CUR_PROFILE_MONITOR
            ST_INTERLEAVED_ST_CHK: begin  //5'd19 // to check desired state for new profile (tx or rx) after interleaving
                /*src_fsm_state <= mux_txrx_desired_state ? ST_RESET_ENTRY_INSTR_START : ST_RESET_EXIT_INSTR_START;
                tx_desired_state_reg <= sl2l_fsm_tx_rx_out ? tx_desired_state_reg : mux_txrx_desired_state; //v0.382
                rx_desired_state_reg <= sl2l_fsm_tx_rx_out ? mux_txrx_desired_state : rx_desired_state_reg; //v0.382 */ //commented in v0.45 
                if(sl2l_fsm_tx_rx_out) begin // v0.45 if sequence started, retain prev registered desired st else use current desired state
                    rx_desired_state_reg <= rx_lane_current_state[1] ? rx_desired_state_reg : mux_txrx_desired_state;//v0.45 
                    //src_fsm_state        <= rx_lane_current_state[1] ? (rx_desired_state_reg ? ST_RESET_ENTRY_INSTR_START : ST_RESET_EXIT_INSTR_START ) : (mux_txrx_desired_state ? ST_RESET_ENTRY_INSTR_START : ST_RESET_EXIT_INSTR_START );//v0.45 
                    src_fsm_state        <= ((!rx_lane_current_state[1] && mux_txrx_desired_state) || 
                                               (rx_lane_current_state[1] && rx_desired_state_reg)|| rx_alarm)? ST_RESET_ENTRY_INSTR_START : ST_RESET_EXIT_INSTR_START;//v0.45 //0.6533 alarm condition
                end
                else begin
                    tx_desired_state_reg <= tx_lane_current_state[1] ? tx_desired_state_reg : mux_txrx_desired_state;//v0.45 
                    //src_fsm_state        <= tx_lane_current_state[1] ? (tx_desired_state_reg ? ST_RESET_ENTRY_INSTR_START : ST_RESET_EXIT_INSTR_START ) : (mux_txrx_desired_state ? ST_RESET_ENTRY_INSTR_START : ST_RESET_EXIT_INSTR_START );//v0.45 
                    src_fsm_state        <= ((!tx_lane_current_state[1] && mux_txrx_desired_state) || 
                                               (tx_lane_current_state[1] && tx_desired_state_reg)|| tx_alarm)? ST_RESET_ENTRY_INSTR_START : ST_RESET_EXIT_INSTR_START;//v0.45 //0.6533 alarm condition
                end
            end//ST_INTERLEAVED_ST_CHK
            ST_SHORELINE_REQ: begin //5'd11
                if(sync_sss_grant)
                    src_fsm_state <= ST_DRIVE;
            end//ST_SHORELINE_REQ
            ST_DRIVE: begin //5'd12
                //drive logic in separate always block
                stagger_cnt_start <= |stagger_within_num_of_clk;
                stagger_sel       <= 1'd0;
                if(stagger_cnt_done || !(|stagger_within_num_of_clk)) begin
                    stagger_cnt_start                   <= 1'd0;
                    sss_req                             <= 1'd0; //v0.57
                    if(initiator) begin
                        sl2l_fsm_error_resp_or_trigger_out  <= 1'd1;
                        sl2l_fsm_ready_or_desired_state_out <= mux_txrx_desired_state_reg;
                        sl2l_fsm_stagger_within_en          <= |stagger_within_num_of_clk;
                        src_fsm_state                       <= |stagger_within_num_of_clk ? ST_ALL_TARGET_DONE : ST_STAGGER_AFTER;
                    end
                    else begin
                        sl2l_fsm_ready_or_desired_state_out <= 1'd1;
                        //src_fsm_state                       <= return_state; //v0.343
                        src_fsm_state                       <= ST_TGT_INSTR_DONE_WAIT_1CLK; //v0.343
                    end
                end
            end//ST_DRIVE
            ST_ALL_TARGET_DONE: begin //5'd13
                if(sl2l_fsm_all_targets_done) begin//no check for common rsrc done as there's no stagger after for common rsrcs
                    src_fsm_state                      <= ST_STAGGER_AFTER;
                    //sl2l_fsm_error_resp_or_trigger_out <= 1'd0; sahana - revert back
                    sl2l_fsm_stagger_within_en         <= 1'd0;
                end
            end//ST_ALL_TARGET_DONE
            ST_STAGGER_AFTER: begin //5'd14
                stagger_cnt_start          <= |stagger_after_num_of_clk;
                stagger_sel                <= 1'd1;
                if(stagger_cnt_done || !(|stagger_after_num_of_clk)) begin
                    src_fsm_state        <= ST_COMPLETE_WAIT;
                    stagger_cnt_start    <= 1'd0;
                    initiator_instr_done <= 1'd1;
                end
            end//ST_STAGGER_AFTER
            ST_COMPLETE_WAIT: begin //5'd15
                //sss_req              <= 1'd0; //commented in v0.57
                if(addr_gen_abort_instr) //v0.43 added 1 clk delay for aborted instructions
                    addr_gen_abort_instr <= 1'd0; //after instr abort due to any condn check fail, control comes back to this state. so clear abort
                else if(!addr_gen_common_block_rst_done_reg || sl2l_fsm_all_targets_done) begin //no wait for complete in case of common rsrc rst
                    sl2l_fsm_error_resp_or_trigger_out   <= 1'd0;
                    //initiator_instr_done                 <= 1'd0; //moving it to other states to make it atleast 2 clks, to make sure addr_gen doesn't miss this in cases where it is high for only 1 clk
                    //if (({mux_txrx_desired_state,mux_txrx_desired_state_reg}==2'b10) || sl2l_fsm_trigger_or_error_resp_in) begin //reset entry during exit
                    //if ((mux_txrx_desired_state && !mux_txrx_desired_state_reg && addr_gen_common_block_rst_done_reg) || sl2l_fsm_trigger_or_error_resp_in) begin
                    if ((mux_txrx_desired_state && !mux_txrx_desired_state_reg && addr_gen_common_block_rst_done_reg) || ((sl2l_target_tx_error_resp && !sl2l_fsm_tx_rx_out) ||(sl2l_target_rx_error_resp && sl2l_fsm_tx_rx_out))) begin //v0.6531
                        //reset entry during exit //v0.36
                        stagger_cnt_start         <= 1'd1;
                        stagger_sel               <= 1'd1;
                        stagger_after_num_of_clk  <= DES_ST_CHG_WAIT_NUM_CLK;//parameter 1ms in Si;200us in sim.
                        scaling_fac_after         <= DES_ST_CHG_WAIT_SCALE_FACTOR;//parameter 1ms in Si;200us in sim.
                        src_fsm_state             <= ST_1MS_WAIT_DONE;
                        error_from_target_flag    <= sl2l_fsm_trigger_or_error_resp_in;
                        sl2l_tx_init_rst_done_for_err <= sl2l_target_tx_error_resp && !sl2l_fsm_tx_rx_out; //v0.6531
                        sl2l_rx_init_rst_done_for_err <= sl2l_target_rx_error_resp && sl2l_fsm_tx_rx_out; //v0.6531
                    end
                    else if (sip_freeze_req) begin
                        sss_req       <= 1'd1;
                        src_fsm_state <= ST_SFRZ_SHORELINE_REQ;
                    end
                    else
                        src_fsm_state <= return_state;
                end
                /*else if (sl2l_fsm_trigger_or_error_resp_in) begin//reset entry during exit at target
                    stagger_cnt_start         <= 1'd1;
                    stagger_sel               <= 1'd1;
                    stagger_after_num_of_clk  <= DES_ST_CHG_WAIT_NUM_CLK;//parameter 1ms in Si;200us in sim.
                    scaling_fac_after         <= DES_ST_CHG_WAIT_SCALE_FACTOR;//parameter 1ms in Si;200us in sim.
                    src_fsm_state             <= ST_1MS_WAIT_DONE;
                end*/
            end//ST_COMPLETE_WAIT
            ST_SFRZ_SHORELINE_REQ: begin //5'd20
                initiator_instr_done <= 1'd0;
                if(!sip_freeze_req) begin
                    sip_freeze_ack <= 1'd0;
                    sss_req        <= 1'd0;
                    src_fsm_state  <= return_state;
                end
                else if(sync_sss_grant) begin
                    sip_freeze_ack <= 1'd1;
                end
            end//ST_SFRZ_SHORELINE_REQ
            ST_1MS_WAIT_DONE: begin //5'd16
                initiator_instr_done           <= 1'd0;
                if(stagger_cnt_done) begin
                    stagger_cnt_start          <= 1'd0;
                    src_fsm_state              <= ST_RESET_ENTRY_INSTR_START;
                    addr_gen_jump_to_rst_entry <= 1'd1;
                    sl2l_fsm_error_resp_or_trigger_out <= !initiator; //set error for target; happens in case of rx alarm
                end
            end//ST_1MS_WAIT_DONE
            ST_FULLY_OP: begin //5'd17
                //if(addr_gen_rx_fully_rst && sync_rx_clear_alarm) //v0.59 //commented v0.6537
                //    rx_alarm               <= 1'd0;
                //if(interleave_active && ((&(concatenated_monitor_signals[12:0] | (~interleave_monitor_reg) )) == 1'd1)) begin 
                     // if interleaving happened, go back and check signal status
                //if(interleave_active && (&interleave_monitoring_status)) begin // if interleaving happened, go back and check signal status
                if((interleave_active || (|sl2l_interleave_active)) && (&interleave_monitoring_status)  ) begin
                      // if interleaving happened, go back and check signal status // revert_change
                    //if ((&(concatenated_monitor_signals[12:0] | (~interleave_monitor_reg) )) == 1'd1) begin
                    //signal to monitor will be 0 on right side and when it is 1 on left, OR output=1; for other signals, right side will be 1, so OR output will be 1
                    interleave_active <= 1'd0;
                    //sl2l_interleave_active  <= (sl2l_fsm_tx_rx_out)? {sl2l_interleave_active[1],1'b0} : {1'b0,sl2l_interleave_active[0]}; //revert_change
                    sl2l_interleave_active  <= (sl2l_fsm_tx_rx_out)? {1'b0,sl2l_interleave_active[0]} : {sl2l_interleave_active[1],1'b0}; //revert_change 
                                                                      // If TX is active , RX interleave is completed and viceversa[0]: RX , [1] TX
                    sl2l_fsm_tx_rx_out    <= !sl2l_fsm_tx_rx_out;
                    //inter_flag <= 1'b1; // revert change
                    if(interleave_initiator) begin
                        src_fsm_state              <= ST_COMPLETE_WAIT;
                        initiator_instr_done       <= 1'd1;
                        return_state               <= interleave_return_state;
                        mux_txrx_desired_state_reg <= interleave_des_st_reg;
                        tx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? interleave_des_st_reg : tx_desired_state_reg;//use reverse tx rx as tx_rx_out changes in this clk
                        rx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? rx_desired_state_reg : interleave_des_st_reg;//use reverse tx rx as tx_rx_out changes in this clk
                    end
                    else begin
                        sl2l_fsm_ready_or_desired_state_out <= 1'd0;//v0.18 made to 0 from 1
                        //src_fsm_state                       <= interleave_return_state; //v0.343
                        src_fsm_state                       <= ST_TGT_INSTR_DONE_WAIT_1CLK; //v0.343
                        return_state                        <= interleave_return_state;
                    end
                end
                //else if (initiator && (sync_sip_freeze_tx_SRC_sequence || sync_sip_freeze_rx_SRC_sequence)) begin //v0.56
                else if ((src_csr_role_cfg_reg[0] && sync_sip_freeze_tx_SRC_sequence) || (src_csr_role_cfg_reg[1] && sync_sip_freeze_rx_SRC_sequence)) begin //v0.56 check separate initaitor bit
                    sfreeze_tx_rx_sel <= src_csr_role_cfg_reg[1] && sync_sip_freeze_rx_SRC_sequence; //set to 1 if rx freeze req. set to 0 if tx freeze req 0
                    sss_req           <= 1'd1;
                    src_fsm_state     <= ST_SFRZ_SHORELINE_REQ;
                    pause_grant       <= 1'd0;
                    return_state      <= ST_FULLY_OP;
                end
                else if (addr_gen_tx_fully_op && src_mon_tx_pll_lock_lost) begin
                    tx_alarm        <= 1'd1;
                    alarm_active    <= 1'b1;
                    alarm_active_tx <= 1'b1;
                    //if(mux_txrx_desired_state || sync_tx_clear_alarm) begin
                    if(sync_rx_lane_desired_state || sync_tx_lane_desired_state || sync_tx_clear_alarm) begin
                        //sl2l_fsm_error_resp_or_trigger_out <= (sync_tx_lane_desired_state || sync_tx_clear_alarm) && !initiator; //set error for target //v0.62 set error only if tx rst_entry is triggered
                        sl2l_fsm_error_resp_or_trigger_out <= (sync_tx_lane_desired_state || sync_tx_clear_alarm) && !src_csr_role_cfg_reg[0]; //set error for target v0.6536
                        src_fsm_state              <= ST_RESET_ENTRY_INSTR_START;
                        sl2l_tx_init_rst_done_for_err <= 1'd1; //v0.63
                        //addr_gen_jump_to_rst_entry <= 1'd1;
                        if(sync_rx_lane_desired_state || sync_tx_lane_desired_state) begin
                            //sl2l_fsm_tx_rx_out     <= sync_rx_lane_desired_state;//set to 1 if rx desired st is changed to 1. set to 0 if tx des st is 1
                            sl2l_fsm_tx_rx_out     <= !(sync_tx_lane_desired_state && !addr_gen_tx_fully_rst);//set to 1 if rx desired st is changed to 1. set to 0 if tx des st is 1 
                            tx_desired_state_reg   <= sync_tx_lane_desired_state ? 1'd1 : tx_desired_state_reg; //update tx or rx based on which profile des st is changed
                            rx_desired_state_reg   <= sync_rx_lane_desired_state ? 1'd1 : rx_desired_state_reg; //update tx or rx based on which profile des st is changed
                        end
                        else begin//sync_tx_clear_alarm v0.40
                            sl2l_fsm_tx_rx_out     <= 1'd0;
                            tx_desired_state_reg   <= 1'd1;
                        end
                    end
                end
                else if (addr_gen_rx_fully_op && src_mon_rx_cdr_lock_lost) begin
                    rx_alarm                  <= 1'd1;
                    alarm_active              <= 1'b1;
                    alarm_active_rx           <= 1'b1;
                    stagger_cnt_start         <= 1'd1;
                    stagger_sel               <= 1'd1;
                    stagger_after_num_of_clk  <= RX_MON_FAIL_NUM_CLK;//parameter 1ms in Si;200us in sim.
                    scaling_fac_after         <= RX_MON_FAIL_SCALE_FACTOR;//parameter 1ms in Si;200us in sim.
                    src_fsm_state             <= ST_1MS_WAIT_DONE;
                    sl2l_rx_init_rst_done_for_err <= 1'd1; //v0.63
                    sl2l_fsm_tx_rx_out        <= 1'd1;// v0.40
                    rx_desired_state_reg      <= 1'd1;// v0.40
                end
                //else if (mux_txrx_desired_state || (initiator && sl2l_fsm_trigger_or_error_resp_in) || (!initiator && (sl2l_fsm_trigger_or_error_resp_in && !sl2l_fsm_trigger_or_error_resp_in_dly))) begin
                          // go to rst entry if error seen at initiator or trigger seen at target
                else if ((src_csr_role_cfg_reg[11] && sync_rx_lane_desired_state && addr_gen_rx_fully_op) || (src_csr_role_cfg_reg[10] && sync_tx_lane_desired_state && addr_gen_tx_fully_op) || //v0.651
                         //(initiator && sl2l_fsm_trigger_or_error_resp_in) ||
                         ((src_csr_role_cfg_reg[0] && sl2l_target_tx_error_resp) || (src_csr_role_cfg_reg[1] && sl2l_target_rx_error_resp)) || //v0.64 separated tx rx initiator
                         (!initiator && (sl2l_fsm_trigger_or_error_resp_in && !sl2l_fsm_trigger_or_error_resp_in_dly && (sl2l_fsm_tx_rx_out~^sl2l_fsm_tx_rx_in)))) begin
                         // go to rst entry if error seen at initiator or trigger seen at target //v0.42 added tx rx en //v0.47 added txrx in out check. 
                    mux_txrx_desired_state_reg <= 1'd1; //register desired st for every instr; at instr end, compare if desired st has changed
                    src_fsm_state              <= ST_RESET_ENTRY_INSTR_START;
                    //error_from_target_flag     <= initiator && (sl2l_target_tx_error_resp || sl2l_target_rx_error_resp);//v0.63
                    error_from_target_flag     <= ((src_csr_role_cfg_reg[0] && sl2l_target_tx_error_resp) || (src_csr_role_cfg_reg[1] && sl2l_target_rx_error_resp));//v0.64
                    initiator_mon_fail         <= (!initiator && (sl2l_fsm_trigger_or_error_resp_in && !sl2l_fsm_trigger_or_error_resp_in_dly && (sl2l_fsm_tx_rx_out~^sl2l_fsm_tx_rx_in)));//set this only if target receives a trigger
                    //addr_gen_jump_to_rst_entry <= 1'd1;
                    if((src_csr_role_cfg_reg[11] && sync_rx_lane_desired_state && addr_gen_rx_fully_op) || (src_csr_role_cfg_reg[10] && sync_tx_lane_desired_state && addr_gen_tx_fully_op)) begin //v0.42 added tx rx en //v0.651
                        //sl2l_fsm_tx_rx_out     <= src_csr_role_cfg_reg[11] && sync_rx_lane_desired_state;//set to 1 if rx desired st is changed to 1. set to 0 if tx des st is 1 //v0.44
                        sl2l_fsm_tx_rx_out     <= src_csr_role_cfg_reg[11] && sync_rx_lane_desired_state && addr_gen_rx_fully_op ;//set to 1 if rx desired st is changed to 1. set to 0 if tx des st is 1 //v0.6535

                        tx_desired_state_reg   <= (src_csr_role_cfg_reg[10] && sync_tx_lane_desired_state) ? 1'd1 : tx_desired_state_reg; //update tx or rx based on which profile des st is changed //v0.44
                        rx_desired_state_reg   <= (src_csr_role_cfg_reg[11] && sync_rx_lane_desired_state) ? 1'd1 : rx_desired_state_reg; //update tx or rx based on which profile des st is changed //v0.44
                    end
                    else begin //if no des st change, update based on tx_rx_out
                        if((src_csr_role_cfg_reg[0] && sl2l_target_tx_error_resp) || (src_csr_role_cfg_reg[1] && sl2l_target_rx_error_resp)) begin //for initiator error scenario //v0.63 //v0.64
                            sl2l_fsm_tx_rx_out     <= (src_csr_role_cfg_reg[1] && sl2l_target_rx_error_resp); //v0.64
                            sl2l_tx_init_rst_done_for_err <= !(src_csr_role_cfg_reg[1] && sl2l_target_rx_error_resp); //v0.64
                            sl2l_rx_init_rst_done_for_err <= (src_csr_role_cfg_reg[1] && sl2l_target_rx_error_resp);
                            tx_desired_state_reg   <= (src_csr_role_cfg_reg[1] && sl2l_target_rx_error_resp) ? tx_desired_state_reg : 1'd1;//if rx err is not set, update tx_des_st_reg
                            rx_desired_state_reg   <= (src_csr_role_cfg_reg[1] && sl2l_target_rx_error_resp) ? 1'd1 : rx_desired_state_reg;//if rx err is set, update rx_des_st_reg
                        end
                        else begin
                            tx_desired_state_reg   <= sl2l_fsm_tx_rx_out ? tx_desired_state_reg : 1'd1;
                            rx_desired_state_reg   <= sl2l_fsm_tx_rx_out ? 1'd1 : rx_desired_state_reg;
                        end
                        addr_gen_jump_to_rst_entry <= 1'd1; //brought inside else v0.39
                    end
                end
                // if one prof is fully op and other is fully rst, and if desired st changes (to reset exit) for the profile in fully op, go execute reset exit for that profile
                else if( all_lane_cmn_rsrc_done && ((src_csr_role_cfg_reg[11] && addr_gen_rx_fully_rst && !sync_rx_lane_desired_state)||
                           (src_csr_role_cfg_reg[10] && addr_gen_tx_fully_rst && !sync_tx_lane_desired_state)) && !rx_alarm) begin
                     //|| (!sl2l_fsm_desired_state_or_ready_in && !initiator) //moving to reset exit sequence only if alarm is cleared //wait for all lanes to complete cmn rsrcs
                    mux_txrx_desired_state_reg <= 1'd0; //register desired st for every instr; at instr end, compare if desired st has changed
                    tx_desired_state_reg       <= (src_csr_role_cfg_reg[10] && addr_gen_tx_fully_rst && !sync_tx_lane_desired_state) ? 1'd0 : tx_desired_state_reg;//if both des st chg, tx is given pref
                    rx_desired_state_reg       <= (src_csr_role_cfg_reg[10] && addr_gen_tx_fully_rst && !sync_tx_lane_desired_state) ? rx_desired_state_reg : 1'd0;//if both des st chg, tx is given pref
                    src_fsm_state              <= ST_RESET_EXIT_INSTR_START;
                    if ((src_csr_role_cfg_reg[11] && addr_gen_rx_fully_rst && !sync_rx_lane_desired_state)||
                        (src_csr_role_cfg_reg[10] && addr_gen_tx_fully_rst && !sync_tx_lane_desired_state)) begin
                        des_st_change_flag     <= 1'd1;
                    end
                end
                else if (sl2l_othr_profile_trigger) begin //v0.65 if there's an outstanding trigger in the other profile
                    if (sl2l_fsm_tx_rx_out && addr_gen_tx_fully_op) //if current profile is rx and other profile(tx) is fully_op set tx_rx_out to tx
                        sl2l_fsm_tx_rx_out <= 1'd0;
                    else if (!sl2l_fsm_tx_rx_out && addr_gen_rx_fully_op) //if current profile is tx and other profile(rx) is fully_op set tx_rx_out to rx
                        sl2l_fsm_tx_rx_out <= 1'd1;
                end
            end//ST_FULLY_OP
            ST_FULLY_RST: begin //5'd18
                alarm_active    <= 1'b0;
                alarm_active_tx <= 1'b0;
                alarm_active_rx <= 1'b0;
                //if(sync_rx_clear_alarm) //commented 0.v3567
                //    rx_alarm               <= 1'd0;
                if(sync_pause_request) begin//DR ctrl to make sure pause req is sent when the profile (tx/rx) is reset
                    pause_grant <= 1'd1;
                    if(src_csr_role_cfg_reg[11]) sl2l_fsm_tx_rx_out <= 1'd1; //v0.41
                    else if (src_csr_role_cfg_reg[10]) sl2l_fsm_tx_rx_out <= 1'd0; //v0.41
                end
                else begin
                    pause_grant <= 1'd0;
                    //if(interleave_active && ((&(concatenated_monitor_signals[12:0] | (~interleave_monitor_reg) )) == 1'd1)) begin 
                         // if interleaving happened, go back and check signal status
                    //if(interleave_active && (&interleave_monitoring_status)) begin // if interleaving happened, go back and check signal status
                    if((interleave_active || (|sl2l_interleave_active)) && (&interleave_monitoring_status)  ) begin
                         // if interleaving happened, go back and check signal status // revert_change
                        //if ((&(concatenated_monitor_signals[12:0] | (~interleave_monitor_reg) )) == 1'd1) begin
                        //signal to monitor will be 0 on right side and when it is 1 on left, OR output=1; for other signals, right side will be 1, so OR output will be 1
                        interleave_active <= 1'd0;
                        //sl2l_interleave_active  <= (sl2l_fsm_tx_rx_out)? {sl2l_interleave_active[1],1'b0} : {1'b0,sl2l_interleave_active[0]}; //revert_change
                        sl2l_interleave_active  <= (sl2l_fsm_tx_rx_out)? {1'b0,sl2l_interleave_active[0]} : {sl2l_interleave_active[1],1'b0}; //revert_change
                                                    // If TX is active , RX interleave is completed and viceversa[0]: RX , [1] TX
                        sl2l_fsm_tx_rx_out    <= !sl2l_fsm_tx_rx_out;
                        //inter_flag <= 1'b1; // revert change
                        if(interleave_initiator) begin
                            src_fsm_state              <= ST_COMPLETE_WAIT;
                            initiator_instr_done       <= 1'd1;
                            return_state               <= interleave_return_state;
                            mux_txrx_desired_state_reg <= interleave_des_st_reg;
                            tx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? interleave_des_st_reg : tx_desired_state_reg;//use reverse tx rx as tx_rx_out changes in this clk
                            rx_desired_state_reg       <= sl2l_fsm_tx_rx_out ? rx_desired_state_reg : interleave_des_st_reg;//use reverse tx rx as tx_rx_out changes in this clk
                        end
                        else begin
                            sl2l_fsm_ready_or_desired_state_out <= 1'd0;//v0.18 made to 0 from 1
                            //src_fsm_state                       <= interleave_return_state; //v0.343
                            src_fsm_state                       <= ST_TGT_INSTR_DONE_WAIT_1CLK; //v0.343
                            return_state                        <= interleave_return_state;
                        end
                    end 
                    //else if (initiator && (sync_sip_freeze_tx_SRC_sequence || sync_sip_freeze_rx_SRC_sequence)) begin //v0.56
                    else if ((src_csr_role_cfg_reg[0] && sync_sip_freeze_tx_SRC_sequence) || (src_csr_role_cfg_reg[1] && sync_sip_freeze_rx_SRC_sequence)) begin //v0.56 check separate initaitor bit
                        sfreeze_tx_rx_sel <= src_csr_role_cfg_reg[1] && sync_sip_freeze_rx_SRC_sequence; //set to 1 if rx freeze req. set to 0 if tx freeze req 0
                        sss_req           <= 1'd1;
                        src_fsm_state     <= ST_SFRZ_SHORELINE_REQ;
                        pause_grant       <= 1'd0;
                        return_state      <= ST_FULLY_RST;
                    end
                    //else if(all_lane_cmn_rsrc_done && !(sync_rx_lane_desired_state&&sync_tx_lane_desired_state) && !rx_alarm) begin
                    //|| (!sl2l_fsm_desired_state_or_ready_in && !initiator) //moving to reset exit sequence only if alarm is cleared //wait for all lanes to complete cmn rsrcs
                    else if(all_lane_cmn_rsrc_done && ((src_csr_role_cfg_reg[11] && addr_gen_rx_fully_rst && !sync_rx_lane_desired_state)||
                            (src_csr_role_cfg_reg[10] && addr_gen_tx_fully_rst && !sync_tx_lane_desired_state)) && !rx_alarm) begin
                            //|| (!sl2l_fsm_desired_state_or_ready_in && !initiator) //moving to reset exit sequence only if alarm is cleared //wait for all lanes to complete cmn rsrcs
                        mux_txrx_desired_state_reg <= 1'd0; //register desired st for every instr; at instr end, compare if desired st has changed
                        tx_desired_state_reg       <= (src_csr_role_cfg_reg[10] && addr_gen_tx_fully_rst && !sync_tx_lane_desired_state) ? 1'd0 : tx_desired_state_reg;
                        rx_desired_state_reg       <= (src_csr_role_cfg_reg[11] && addr_gen_rx_fully_rst && !sync_rx_lane_desired_state) ? 1'd0 : rx_desired_state_reg;
                        src_fsm_state              <= ST_RESET_EXIT_INSTR_START;
                        if ((src_csr_role_cfg_reg[11] && addr_gen_rx_fully_rst && !sync_rx_lane_desired_state)||
                            (src_csr_role_cfg_reg[10] && addr_gen_tx_fully_rst && !sync_tx_lane_desired_state)) begin
                            des_st_change_flag     <= 1'd1;
                        end
                    end
					else if (all_lane_cmn_rsrc_done && ((src_csr_role_cfg_reg[11] && sync_rx_lane_desired_state  && !rx_desired_state_reg) ||
							(src_csr_role_cfg_reg [10] && sync_tx_lane_desired_state && !tx_desired_state_reg))) begin
							sl2l_fsm_tx_rx_out         <= !addr_gen_rx_fully_rst && addr_gen_tx_fully_rst ;
							mux_txrx_desired_state_reg <= 1'b1 ;
							tx_desired_state_reg       <= addr_gen_tx_fully_rst ? tx_desired_state_reg : sync_tx_lane_desired_state ;
                            rx_desired_state_reg       <= addr_gen_rx_fully_rst ? rx_desired_state_reg : sync_rx_lane_desired_state ;
							src_fsm_state              <= ST_RESET_ENTRY_INSTR_START ;
							addr_gen_jump_to_rst_entry <= 1'd1;
							interleave_active          <= 1'd0;
							sl2l_interleave_active     <= (sl2l_fsm_tx_rx_out)? {1'b0,sl2l_interleave_active[0]} : {sl2l_interleave_active[1],1'b0};
					end		
                    else if(addr_gen_rx_fully_op||addr_gen_tx_fully_op)
                        src_fsm_state              <= ST_FULLY_OP;
                end
            end//ST_FULLY_RST
            ST_TGT_INSTR_DONE_WAIT_1CLK: begin ///5'd22 // added in v0.343
                sl2l_fsm_ready_or_desired_state_out <= 1'd1;
                src_fsm_target_instr_done           <= 1'd1;
                wait_4clk                           <= wait_4clk + 2'd1; //0.3461
                src_fsm_state                       <= (&wait_4clk) ? return_state : src_fsm_state;//0.3461
            end//ST_FULLY_RST
            default: begin
                src_fsm_state                       <= ST_COMMON_RSRC_RST_EXIT;
                return_state                        <= 5'd0;
                mux_txrx_desired_state_reg          <= 1'd0;
                interleave_active                   <= 1'd0;
                vliw_monitor_reg                    <= 14'd0; //v0.653
                vliw_instr_type                     <= 1'd0;
                vliw_leader_follower_val_chk        <= 1'd0;
                vliw_drive_reg                      <= 28'd0;
                vliw_condition_pass                 <= 1'd0;
                vliw_fn_mode_chk_pass               <= 1'd0;
                vliw_wait_point                     <= 1'd0;
                vliw_monitor_value                  <= 1'd0;
                vliw_drive_val                      <= 1'd0;
                interleave_monitor_reg              <= 14'd0; //v0.653
                interleave_monitor_val              <= 1'd0;
                interleave_return_state             <= 5'd0;
                interleave_des_st_reg               <= 1'd0;
                stagger_sel                         <= 1'd0;
                addr_gen_rd_req                     <= 1'd0;
                sl2l_fsm_tx_rx_out                  <= 1'd0;
                sl2l_fsm_ready_or_desired_state_out <= 1'd0;
                src_mon_clr_sticky_flags            <= 2'd0;
                stagger_within_num_of_clk           <= 8'd0;
                scaling_fac_within                  <= 2'd0;
                stagger_after_num_of_clk            <= 14'd0;
                scaling_fac_after                   <= 2'd0;
                sl2l_fsm_error_resp_or_trigger_out  <= 1'd0;
                sss_req                             <= 1'd0;
                stagger_cnt_start                   <= 1'd0;
                sl2l_fsm_stagger_within_en          <= 1'd0;
                tx_alarm                            <= 1'd0;
                rx_alarm                            <= 1'd0;
                addr_gen_jump_to_rst_entry          <= 1'd0;
                addr_gen_common_block_rst_done_reg  <= 1'd0;
                pause_grant                         <= 1'd0;
                sip_freeze_ack                      <= 1'd0;
                initiator_mon_fail                  <= 1'd0;
                initiator_instr_done                <= 1'd0;
                addr_gen_abort_instr                <= 1'd0;
                inter_flag                          <= 1'd0; //revert change
                sl2l_interleave_active              <= 2'd0; //revert change
                des_st_change_flag                  <= 1'd0;
                sfreeze_tx_rx_sel                   <= 1'd0;
                alarm_active                        <= 1'b0;
                alarm_active_tx                     <= 1'b0;
                alarm_active_rx                     <= 1'b0;
                go_back_to_trig_wait                <= 1'b0;
                src_fsm_target_instr_done           <= 1'b0;
                tx_des_st_reached_reg               <= 1'd0;//0.3472
                rx_des_st_reached_reg               <= 1'd0;//0.3472
                tx_desired_state_reg                <= 1'd0;//0.38
                rx_desired_state_reg                <= 1'd0;//0.38
                rx_desired_state_reg                <= 1'd0;//0.38
                entry_btwn_exit_flag                <= 1'd0;
                error_from_target_flag              <= 1'd0;
                sl2l_tx_init_rst_done_for_err       <= 1'd0;
                sl2l_rx_init_rst_done_for_err       <= 1'd0;
            end//default
        endcase
    end
end

//---------------------------------------------------------------------------------------------------------------------------
// Block description : Registering block
//---------------------------------------------------------------------------------------------------------------------------

always @(posedge clk) begin
    if (sclr) begin
        sl2l_fsm_trigger_or_error_resp_in_dly <= 1'd0;
        is_duplex                             <= 1'd0;
        src_csr_role_cfg_reg                  <= 32'd0;
        tx_fully_des_st_reached               <= 1'd0;
        rx_fully_des_st_reached               <= 1'd0;
        rx_en                                 <= 1'b0;
        tx_en                                 <= 1'b0;
        sl2l_fsm_tx_rx_out_reg                <= 1'b0;
        src_fsm_state_reg                     <= 1'b0;
        des_st_change_flag_reg                <= 1'b0;
        //fsm_common_initiator                  <= 1'b0;//v0.341
    end
    else begin
        sl2l_fsm_trigger_or_error_resp_in_dly <= sl2l_fsm_trigger_or_error_resp_in;
        is_duplex                             <= &src_csr_role_cfg_reg[11:10];
        src_csr_role_cfg_reg                  <= src_csr_role_cfg;
        tx_fully_des_st_reached               <= sync_tx_lane_desired_state ? addr_gen_tx_fully_rst : addr_gen_tx_fully_op;
        rx_fully_des_st_reached               <= sync_rx_lane_desired_state ? addr_gen_rx_fully_rst : addr_gen_rx_fully_op;
        //rx_en                                 <= alarm_active ? (alarm_active_rx && src_csr_role_cfg_reg[11]) : src_csr_role_cfg_reg[11];
        //tx_en                                 <= alarm_active ? (alarm_active_tx && src_csr_role_cfg_reg[10]) : src_csr_role_cfg_reg[10];
        rx_en                                 <= src_csr_role_cfg_reg[11]; //v0.51 removed alarm check a separate desired state
        tx_en                                 <= src_csr_role_cfg_reg[10]; //v0.51 removed alarm check a separate desired state
        sl2l_fsm_tx_rx_out_reg                <= sl2l_fsm_tx_rx_out;
        src_fsm_state_reg                     <= src_fsm_state;
        des_st_change_flag_reg                <= des_st_change_flag;
        //fsm_common_initiator                  <= (src_csr_role_cfg_reg[9:6] == src_csr_role_cfg_reg[5:2]);//v0.341
    end
end


//---------------------------------------------------------------------------------------------------------------------------
// Block description : Drive block which drives all the reset signals and other signals
//                     to the HIP/SIP based on the VLIW instruction
//---------------------------------------------------------------------------------------------------------------------------

always @(posedge clk) begin
    if (sclr) begin //check reset value of all signals
        sip_am_gen_start             <= 1'd0;
        ptp_rst_n                    <= 1'd0;
        ptp_pld_ready                <= 1'd0;
        ptp_pld_adapter_rx_pld_rst_n <= 1'd0;
        ptp_pld_adapter_tx_pld_rst_n <= 1'd0;
        xcvrif_signal_ok             <= 1'd0;
        ux_tx_pma_rst_n              <= 1'd0;
        ux_rx_pma_rst_n              <= 1'd0;
        ux_rx_sfrz_n                 <= 1'd0;
        iflux_ingress_direct_231     <= 1'd1;//v0.6534
        ehip_signal_ok               <= 1'd0;
        pld_ready                    <= 1'd0;
        fec_rx_rst_n                 <= 1'd0;//v0.6534
        fec_csr_ret                  <= 1'd1;//v0.6534
        tx_fec_sfrz_n                <= 1'd0;
        rx_fec_sfrz_n                <= 1'd0;
        xcvrif_tx_rst_n              <= 1'd0;
        xcvrif_rx_rst_n              <= 1'd0;
        tx_xcvrif_sfrz_n             <= 1'd0;
        rx_xcvrif_sfrz_n             <= 1'd0;
        pld_adapter_tx_pld_rst_n     <= 1'd0;
        pld_adapter_rx_pld_rst_n     <= 1'd0;
        ehip_tx_rst_n                <= 1'd0;
        ehip_rx_rst_n                <= 1'd0;
        tx_pcs_sfrz_n                <= 1'd0;
        rx_mac_deskew_sfrz_n         <= 1'd0;
        tx_deskew_sfrz_n             <= 1'd0;
        fec_tx_rst_n                 <= 1'd0;//v0.6534
        fec_rst_deassert_done        <= 1'd0;
    end
    else begin
        if (src_fsm_state == ST_DRIVE) begin
            sip_am_gen_start             <= vliw_drive_reg[27] ? vliw_drive_val : sip_am_gen_start            ;
            ptp_rst_n                    <= vliw_drive_reg[26] ? vliw_drive_val : ptp_rst_n                   ;
            ptp_pld_ready                <= vliw_drive_reg[25] ? vliw_drive_val : ptp_pld_ready               ;
            ptp_pld_adapter_tx_pld_rst_n <= vliw_drive_reg[24] ? vliw_drive_val : ptp_pld_adapter_tx_pld_rst_n;
            ptp_pld_adapter_rx_pld_rst_n <= vliw_drive_reg[23] ? vliw_drive_val : ptp_pld_adapter_rx_pld_rst_n;
            xcvrif_signal_ok             <= vliw_drive_reg[22] ? vliw_drive_val : xcvrif_signal_ok            ;
            ux_tx_pma_rst_n              <= vliw_drive_reg[21] ? vliw_drive_val : ux_tx_pma_rst_n             ;
            ux_rx_pma_rst_n              <= vliw_drive_reg[20] ? vliw_drive_val : ux_rx_pma_rst_n             ;
            ux_rx_sfrz_n                 <= vliw_drive_reg[19] ? vliw_drive_val : ux_rx_sfrz_n                ;
            iflux_ingress_direct_231     <= vliw_drive_reg[18] ? vliw_drive_val : iflux_ingress_direct_231    ;
            ehip_signal_ok               <= vliw_drive_reg[17] ? vliw_drive_val : ehip_signal_ok              ;
            pld_ready                    <= vliw_drive_reg[16] ? vliw_drive_val : pld_ready                   ;
            fec_rx_rst_n                 <= vliw_drive_reg[15] ? vliw_drive_val : fec_rx_rst_n                ;
            fec_csr_ret                  <= vliw_drive_reg[14] ? vliw_drive_val : fec_csr_ret                 ;
            tx_fec_sfrz_n                <= vliw_drive_reg[13] ? vliw_drive_val : tx_fec_sfrz_n               ;
            rx_fec_sfrz_n                <= vliw_drive_reg[12] ? vliw_drive_val : rx_fec_sfrz_n               ;
            xcvrif_tx_rst_n              <= vliw_drive_reg[11] ? vliw_drive_val : xcvrif_tx_rst_n             ;
            xcvrif_rx_rst_n              <= vliw_drive_reg[10] ? vliw_drive_val : xcvrif_rx_rst_n             ;
            tx_xcvrif_sfrz_n             <= vliw_drive_reg[9]  ? vliw_drive_val : tx_xcvrif_sfrz_n            ;
            rx_xcvrif_sfrz_n             <= vliw_drive_reg[8]  ? vliw_drive_val : rx_xcvrif_sfrz_n            ;
            pld_adapter_tx_pld_rst_n     <= vliw_drive_reg[7]  ? vliw_drive_val : pld_adapter_tx_pld_rst_n    ;
            pld_adapter_rx_pld_rst_n     <= vliw_drive_reg[6]  ? vliw_drive_val : pld_adapter_rx_pld_rst_n    ;
            ehip_tx_rst_n                <= vliw_drive_reg[5]  ? vliw_drive_val : ehip_tx_rst_n               ;
            ehip_rx_rst_n                <= vliw_drive_reg[4]  ? vliw_drive_val : ehip_rx_rst_n               ;
            tx_pcs_sfrz_n                <= vliw_drive_reg[3]  ? vliw_drive_val : tx_pcs_sfrz_n               ;
            rx_mac_deskew_sfrz_n         <= vliw_drive_reg[2]  ? vliw_drive_val : rx_mac_deskew_sfrz_n        ;
            tx_deskew_sfrz_n             <= vliw_drive_reg[1]  ? vliw_drive_val : tx_deskew_sfrz_n            ;
            fec_tx_rst_n                 <= vliw_drive_reg[0]  ? vliw_drive_val : fec_tx_rst_n                ;
        end
        //v0.6534 FEC asserted only after syspll lock 
        //else if(!fec_rst_deassert_done && src_mon_fec_rst_pull_down) begin // If FEC is enabled in the QHIP, de-assert FEC reset before reset sequence
        //    fec_rst_deassert_done <= 1'd1;
        //    fec_tx_rst_n          <= 1'd0;
        //    fec_rx_rst_n          <= 1'd0;
        //end
    end
end


//---------------------------------------------------------------------------------------------------------------------------
// Block description : Drive block which drives all the reset signals and other signals
//                     to the HIP/SIP based on the VLIW instruction
//---------------------------------------------------------------------------------------------------------------------------

always @(posedge clk) begin
    if (sclr) begin //check reset value of all signals
        monitoring_status            <= 14'd0;
        interleave_monitoring_status <= 14'd0;
    end
    else begin
        monitoring_status[0]  <= !vliw_monitor_reg[0]  || (vliw_monitor_value == concatenated_monitor_signals[0] );
        monitoring_status[1]  <= !vliw_monitor_reg[1]  || (vliw_monitor_value == concatenated_monitor_signals[1] );
        monitoring_status[2]  <= !vliw_monitor_reg[2]  || (vliw_monitor_value == concatenated_monitor_signals[2] );
        monitoring_status[3]  <= !vliw_monitor_reg[3]  || (vliw_monitor_value == concatenated_monitor_signals[3] );
        monitoring_status[4]  <= !vliw_monitor_reg[4]  || (vliw_monitor_value == concatenated_monitor_signals[4] );
        monitoring_status[5]  <= !vliw_monitor_reg[5]  || (vliw_monitor_value == concatenated_monitor_signals[5] );
        monitoring_status[6]  <= !vliw_monitor_reg[6]  || (vliw_monitor_value == concatenated_monitor_signals[6] );
        monitoring_status[7]  <= !vliw_monitor_reg[7]  || (vliw_monitor_value == concatenated_monitor_signals[7] );
        monitoring_status[8]  <= !vliw_monitor_reg[8]  || (vliw_monitor_value == concatenated_monitor_signals[8] );
        monitoring_status[9]  <= !vliw_monitor_reg[9]  || (vliw_monitor_value == concatenated_monitor_signals[9] );
        monitoring_status[10] <= !vliw_monitor_reg[10] || (vliw_monitor_value == concatenated_monitor_signals[10]);
        monitoring_status[11] <= !vliw_monitor_reg[11] || (vliw_monitor_value == concatenated_monitor_signals[11]);
        monitoring_status[12] <= !vliw_monitor_reg[12] || (vliw_monitor_value == concatenated_monitor_signals[12]);
        monitoring_status[13] <= !vliw_monitor_reg[13] || (vliw_monitor_value == concatenated_monitor_signals[13]); //v0.653
        
        
        interleave_monitoring_status[0]  <= !interleave_monitor_reg[0]  || (interleave_monitor_val == concatenated_monitor_signals[0] );
        interleave_monitoring_status[1]  <= !interleave_monitor_reg[1]  || (interleave_monitor_val == concatenated_monitor_signals[1] );
        interleave_monitoring_status[2]  <= !interleave_monitor_reg[2]  || (interleave_monitor_val == concatenated_monitor_signals[2] );
        interleave_monitoring_status[3]  <= !interleave_monitor_reg[3]  || (interleave_monitor_val == concatenated_monitor_signals[3] );
        interleave_monitoring_status[4]  <= !interleave_monitor_reg[4]  || (interleave_monitor_val == concatenated_monitor_signals[4] );
        interleave_monitoring_status[5]  <= !interleave_monitor_reg[5]  || (interleave_monitor_val == concatenated_monitor_signals[5] );
        interleave_monitoring_status[6]  <= !interleave_monitor_reg[6]  || (interleave_monitor_val == concatenated_monitor_signals[6] );
        interleave_monitoring_status[7]  <= !interleave_monitor_reg[7]  || (interleave_monitor_val == concatenated_monitor_signals[7] );
        interleave_monitoring_status[8]  <= !interleave_monitor_reg[8]  || (interleave_monitor_val == concatenated_monitor_signals[8] );
        interleave_monitoring_status[9]  <= !interleave_monitor_reg[9]  || (interleave_monitor_val == concatenated_monitor_signals[9] );
        interleave_monitoring_status[10] <= !interleave_monitor_reg[10] || (interleave_monitor_val == concatenated_monitor_signals[10]);
        interleave_monitoring_status[11] <= !interleave_monitor_reg[11] || (interleave_monitor_val == concatenated_monitor_signals[11]);
        interleave_monitoring_status[12] <= !interleave_monitor_reg[12] || (interleave_monitor_val == concatenated_monitor_signals[12]);
        interleave_monitoring_status[13] <= !interleave_monitor_reg[13] || (interleave_monitor_val == concatenated_monitor_signals[13]);//v0.653
    end
end

endmodule


//--------------------------------------------------------------------------------------------------------------------------
// Version |  Changes                                        | Date                 | Owner ID
//--------------------------------------------------------------------------------------------------------------
//   0.1   | Initial code                                    |  29-Jun-2022         | cvignesh
//   0.2   | Updated based on initial internal review        |  11-Jul-2022         | cvignesh
//   0.3   | Default value of FEC rst updated to 1,          |  15-Jul-2022         | cvignesh
//         | desired st check added before going into rst    |                      |
//         | entry or exit, interleaving check added when    |                      |
//         | only one profile reaches fully op or rst state  |                      |
//   0.4   | Fix added -sample common rsrc done at instr strt|  20-Jul-2022         | cvignesh
//   0.5   | Unused parameters removed                       |  22-Jul-2022         | cvignesh
//   0.6   | Added fix for removing interleaving in simplex  |  22-Jul-2022         | cvignesh
//         | modes & cmn rsrc rst exit issue in rx only mode |                      |
//   0.7   | Added DR, Sfreeze logic, fully_rst/op state     |  01-Aug-2022         | cvignesh
//         | logic added for target, considering all lanes as|                      |
//         | initiators for common resources                 |                      |
//   0.8   | Fix for count start always high for target issue|  08-Aug-2022         | cvignesh
//   0.9   | Fix for tx_rx_sel issue during tx rst entry     |  16-Aug-2022         | cvignesh
//   0.10  | Updated for leader/follower valid check         |  22-Aug-2022         | cvignesh
//   0.11  | Added tx st check for going to fully op/rst st  |  26-Aug-2022         | cvignesh
//         | Added monitoring fn in fully op st for targets  |                      |
//   0.12  | Added signals to indicate initiator instr done  |  30-Aug-2022         | cvignesh
//         | and initiator monitor condn fail (in target)    |                      |
//   0.13  | Setting clear_sticky_flag bits for target too   |  01-Sep-2022         | cvignesh
//   0.14  | Setting initiator instr done for abort case too |  02-Sep-2022         | cvignesh
//   0.15  | Fixed issue of setting initiator_mon_fail       |  07-Sep-2022         | cvignesh
//         | without trigger                                 |                      | 
//   0.16  | Extending initiator done to atleast 2 clks,     |  08-Sep-2022         | cvignesh
//         | clearing rx_alarm based on clear_rx_alarm input |                      | 
//         | and moving to reset exit sequence only if alarm |                      | 
//         | is cleared                                      |                      | 
//   0.17  | 1 clk dly in rd to accomodate dly from addr_gen |  09-Sep-2022         | cvignesh
//   0.18  | Clearing trigger when interleaving happens,     |  12-Sep-2022         | cvignesh
//         | Ensuring a posedge for fsm_ready when           |                      |
//         | interleaving is complete for target             |                      |
//   0.19  | Corrected clearing only for target              |  13-Sep-2022         | cvignesh
//   0.20  | Not clearing trigger when FSM moves from State 9|  14-Sep-2022         | cvignesh
//         | to 10 as interleave doesn't happen in this case |                      |
//   0.21  | Registering csr inputs to avoid timing issues   |  19-Sep-2022         | cvignesh
//   0.22  | Correcting reg/wire type                        |  26-Sep-2022         | cvignesh
//   0.23  | Added input to notify cmnrsrc done for all lanes|  28-Sep-2022         | cvignesh
//   0.24  | In fully_op/rst st, check for des st change in  |  12-Oct-2022         | cvignesh
//         | both tx and rx; Adding scenarios where one prof |                      |
//         | is fully rst and the other is fully op          |                      |
//   0.25  | Dedicated interleave active and inter_flag added|  13-Oct-2022         | skgr
//   0.26  | Fix for freeze req service in fully op/rst state|  17-Oct-2022         | cvignesh
//   0.27  | Updating des st change check for simplex cases  |  18-Oct-2022         | cvignesh
//   0.28  | Removed des st chg check at target              |  19-Oct-2022         | cvignesh
//   0.29  | For alarm condition, do reset for only profile  |  19-Oct-2022         | cvignesh
//         | where alarm is there                            |                      |
//   0.30  | Updated error check at initiator for desired st |  27-Oct-2022         | cvignesh
//         | change in target. check after instr done        |                      |
//   0.31  | Correcting ready value to be 1 for target in st |  17-Nov-2022         | cvignesh
//         | 1 and 2                                         |                      |
//   0.32  | sl2l_fsm_tx_rx_out updated for corner cases     |  23-Nov-2022         | cvignesh
//   0.33  | Wait 1 clk before interleaving for initator to  |  02-Dec-2022         | cvignesh
//         | be updated                                      |                      |
//         | In case of target, tx_rx_out changed only when  |                      |
//         | trigger is received                             |                      |
//   0.34  | Added fix for interleave deadlock scenario:     |  07-Dec-2022         | cvignesh
//         | Wait 16 clk to check if monitoring condn is done|                      |
//         | before switching to other profile               |                      |
//         | If there is no trigger for a target lane for 16 |                      |
//         | clks and if interleave_active, move to other    |                      |
//         | profile                                         |                      |
//   0.341 | If trgt has cmn initiator, txrxout=tx_rx_in     |  08-Dec-2022         | cvignesh
//         | Increased delay for trig wait thrshld and diff  |
//         | parameter used for intrlv wait                  |
//   0.342 | Set ready to 0 in state 1or2 instead of 9 for   |  08-Dec-2022         | cvignesh
//         | when moving to intlv monitor after trig wait    |
//   0.343 | Added 1 clk wait st for target after instr done |  13-Dec-2022         | cvignesh 
//           // if needed, remove the logic for abort cases, drive cases and fully rst/op cases afrter analysis //needed now because of instr done generation
//         | to account for sl2l timing                      |
//   0.344 | Added signal to indicate target instr done      |  14-Dec-2022         | cvignesh 
//         | Wait time increased to 2 clks in instr done st  |
//   0.345 | Tx_rx_out for target changes only if desired st |  15-Dec-2022         | cvignesh 
//         | is reached for one profile in duplex case       |// check #919 in FULLY OP st (should fully op condn and tx/rx en condn be checked? 4th else if
//         | Removed fsm_common_initiator register           |
//   0.346 | Target instr done added when fsm goes from 1->17|  16-Dec-2022         | cvignesh 
//         | and 2->18                                       |
//   0.3461| Added 4 clk wait for tgt instr done in fully op |  16-Dec-2022         | skgr
//   0.347 | Switch to other prof if no trig in current prof |  19-Dec-2022         | cvignesh 
//         | even when interlv is not active                 |
//   0.3471| When switching profiles always check desired st |  19-Dec-2022         | cvignesh 
//   0.3472| To switch tx_rx_out, check if des st is reached |  27-Dec-2022         | cvignesh 
//         | instead of fully_op or fully_rst signals        |
//         | Updated tx_rx_out logic for rst entry initiator |
//   0.35  | Updated initator for simplex case (DR case fix) |  28-Dec-2022         | cvignesh 
//   0.36  | Not checking des_st change if common rsrc rst is|  30-Dec-2022         | cvignesh 
//         | not done                                        |
//   0.37  | Update tx_rx_out based on des_st_reached        |  30-Dec-2022         | cvignesh 
//         | Go to FULLY RST/OP st based on des_st_reached   |
//   0.38  | Added separate des_st_reg for tx and rx. Using  |  02-Jan-2023         | cvignesh 
//         | that for checking if des_st_reached             |
//   0.381 | Go to FULLY RST/OP st based on des_st_reached   |  02-Jan-2023         | cvignesh 
//         | for cur prof and fullyop/rst for other profile  |
//   0.382 | Update des_st_reg in ST_INTERLEAVED_ST_CHK to   |  03-Jan-2023         | cvignesh 
//         | avoid delays in des_st_reached update           |
//   0.39  | Removing unwanted setting of jump_to_rst_entry  |  03-Jan-2023         | cvignesh 
//   0.40  | Update tx_rx_out for alarm conditions           |  03-Jan-2023         | cvignesh 
//   0.41  | Update tx_rx_out post DR                        |  04-Jan-2023         | cvignesh 
//   0.42  | In FULLY_OP st check tx rx en while checking    |  05-Jan-2023         | cvignesh 
//         | desired state change                            |
//   0.43  | Added 1 clk delay for aborted instructions to   |  06-Jan-2023         | cvignesh 
//         | account for update of cur_prof_des_st_reached   |
//   0.44  | In FULLY_OP st check tx rx en while updating    |  10-Jan-2023         | cvignesh 
//         | txrxout and des_st_reg during des_st change     |
//   0.45  | In st.19, check registered des st or current    |  10-Jan-2023         | cvignesh 
//         | des st based on whether sequence has started    |
//         | Duplex check added in st1 and st2 before switch |
//         | of profiles after trigger wait                  |
//   0.46  | While going to st.19, from st1 or 2, des_st_reg |  12-Jan-2023         | cvignesh 
//         | should not be updated                           |
//   0.47  | Added txrx in out check while accepting triggers|  16-Jan-2023         | cvignesh 
//   0.48  | Don't start initiator instr if des_st is reached|  18-Jan-2023         | cvignesh 
//   0.49  | Clear instr_done if tx_rx_out changes           |  19-Jan-2023         | cvignesh 
//   0.50  | Switch from exit start to entry start st for    |  19-Jan-2023         | cvignesh 
//         | targets when desired st changes to reset entry  |
//   0.51  | Removed alarm dependency for rx_en and tx_en    |  20-Jan-2023         | cvignesh 
//   0.52  | Revert 0.50 & set a flag in st1 when l2l_des_st |  20-Jan-2023         | cvignesh 
//         | is 1. In st2 start instr if this flag is set    |
//   0.53  | Update tx_rx_out based on tx_desired_state_reg  |  23-Jan-2023         | cvignesh 
//         | for des_st_chg_flag case in st1                 |
//   0.54  | Initialize tx,rx _des_st_reg to 1 in cmn rsrc as|  23-Jan-2023         | cvignesh 
//         | all lanes are initially considered to be in rst |
//   0.55  | In st1, for des_st_chg_flag case, wait 1 clk for|  24-Jan-2023         | cvignesh 
//         | tx_rx_out to update. Instr read to be held at   |
//         | this point for initiator to be updated          |
//         | tx_rx_out updated after cmn rsrc done st0       |
//         | Partial code cleanup done - Alignment issues fix|
//   0.56  | In st17,18 check tx rx initiator bit separately |  24-Jan-2023         | cvignesh 
//   0.57  | Fix for sss_req ack issue in diff role case.send|  06-Feb-2023         | cvignesh 
//         | req for each lane irrespective of role(tgt/init)|
//   0.58  | Clear tgt_instr_done after it moves to st1/st2  |  06-Feb-2023         | cvignesh 
//   0.59  | Check for rx_clear alarm in fully_op st         |  09-Feb-2023         | cvignesh 
//   0.60  | Removed unused param txOPERATIONAL_STATE_POINTER|  22-Feb-2023         | cvignesh 
//   0.61  | Fixed issue of fsm not waiting for sss grant    |  09-Mar-2023         | cvignesh 
//   0.62  | Fixed issue of reset entry not happening when   |  14-Mar-2023         | cvignesh 
//         | target lane gets alarm                          |
//         | For target set error for tx_alarm only if tx rst|
//         | entry is triggered                              |
//   0.63  | Added separate error in from l2l for tx,rx      |  15-Mar-2023         | cvignesh 
//         | Switch tx_rx_out if error occurs in any of tx/rx|
//         | Added output to sl2l to denote that rst entry   |
//         | started in response to error input              |
//   0.64  | Separate initiator checks for tx/rx error resp, |  20-Mar-2023         | cvignesh 
//         | Clear tx_alarm only when Tx entry happens       |
//   0.65  | Switch tx_rx_out if there's an outstanding trig |  21-Mar-2023         | cvignesh 
//         | in the FULLY_OP state                           |                    
//   0.651 | Check for fully_op flag in FULLY_OP state to    |  23-Mar-2023         | skgr
//         | identify change in desired state                |                      |
//   0.652 | current state 2'd3 before clock stable based on |                      |
//         | HSD: 16020176030                                |  03-Apr-2023         | skgr                             
//   0.653 | HSD:16020176490 hip_ready added to SRC Spec     |  04-Apr-2023         | skgr
//   0.6531| Complete wait - alarm condition fix             |  05-Apr-2023         | skgr
//   0.6532| HSD:22018515268 tx rx frz service simultaneuosly|  13-Jul-2023         | skgr                      
//   0.6533| DS support HSD : 14019397856                    |  29-May-2023         | skgr 
//         | Alarm check added when in Interleave_chk state &|  05-Jul-2023         | skgr
//         | tx_alarm cleared after reset entry started      |                      |     
//   0.6534| HSD:16021677025 PFE power on review comment     |  09-Aug-2023         | skgr
//   0.6535| HSD:14019867282 condition check added for ptp/dl|  25-Sep-2023         | skgr            
//   0.6536| HSD:16021626900 Link Rst entry during TX alarm  |  03-Oct-2023         | skgr
//   0.6537| HSD:16022101313 RX alarm auto recovery. No wait |
//         | for rx_clear_alarm to de-assert rx_alarm        |  05-Oct-2023         | skgr
//   0.6538| HSD:16022196823 Ach des_st_change in monitor st |  12-Oct-2023         | skgr
//   0.6539| 16022034910 Reset entry btw exit when fully rst |  01-Nov-2023         | skgr
//--------------------------------------------------------------------------------------------------------------------------

