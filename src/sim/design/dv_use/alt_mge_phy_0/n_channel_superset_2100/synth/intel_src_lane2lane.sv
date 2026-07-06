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
// File Name   : intel_src_lane2lane.sv
// Project     : SRC 
// Version     : 0.963
// Description : Provides the Interconnection of SRC lane 2 lane transaction and MUX the status of active lane to FSM
// 
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

module intel_src_lane2lane 
#(
parameter  NUM_LANES = 1,
parameter  SRC_LANE_INDEX = 0
)(

input                     clk  ,
input                     sclr ,

input  [9:0]              src_role_cfg,
input  [31:0]             src_target_enable,
input                     addr_gen_common_block_rst_done_reg,

output     reg            sl2l_fsm_trigger_or_error_resp_in   ,
input                     sl2l_fsm_error_resp_or_trigger_out   ,
input                     sl2l_fsm_stagger_within_en       ,
output     reg            sl2l_fsm_desired_state_or_ready_in  ,
input                     sl2l_fsm_ready_or_desired_state_out  ,
output                    sl2l_fsm_all_targets_done        ,
output     reg            sl2l_fsm_tx_rx_in                ,
input                     sl2l_fsm_tx_rx_out               ,
input      [1:0]          interleave_active                ,
input                     stagger_cnt_done                 ,
input                     src_fsm_target_instr_done        ,
input                     sl2l_tx_init_rst_done_for_err   ,
input                     sl2l_rx_init_rst_done_for_err   ,
output     reg            sl2l_target_tx_error_resp        ,
output     reg            sl2l_target_rx_error_resp        ,
output                    sl2l_othr_profile_trigger        ,

// Top signal from SRC Lane
input             [NUM_LANES-1:0]   sl2l_trigger_or_error_resp_in    ,
input             [NUM_LANES-1:0]   sl2l_desired_state_or_ready_in   ,
input             [NUM_LANES-1:0]   sl2l_tx_rx_in                    ,
output     reg    [NUM_LANES-1:0]   sl2l_error_resp_or_trigger_out   ,
output     reg    [NUM_LANES-1:0]   sl2l_ready_or_desired_state_out  ,
output     reg    [NUM_LANES-1:0]   sl2l_tx_rx_out                   
                   


);

//---------------------------------------- Parameters ----------------------------------- 

localparam ST_INIT                           = 2'd0;
localparam ST_TGT_MASK                       = 2'd1;
localparam ST_TGT_TRIG                       = 2'd2;
localparam ST_TGT_DONE                       = 2'd3;


//---------------------------------------- Register and Wire declaration----------------------------------- 

reg     [NUM_LANES-1:0]     t_lane_mask_out;
reg     [1:0]               trig_state ;
reg                         sl2l_fsm_error_resp_or_trigger_out_reg ;
reg     [NUM_LANES-1:0]     sl2l_desired_state_or_ready_in_reg ;
reg     [NUM_LANES-1:0]     sl2l_trigger_or_error_resp_in_reg ;
reg     [NUM_LANES-1:0]     sl2l_instr_complete_ready_tx ;  //v0.883
reg     [NUM_LANES-1:0]     sl2l_instr_complete_ready_rx ;  //v0.883
wire    [NUM_LANES-1:0]     sl2l_instr_complete_ready ;     //v0.883
reg                         rx_all_targets_done ;
reg                         tx_all_targets_done ;
reg                         sl2l_fsm_tx_rx_out_current ;
reg                         sl2l_fsm_error_resp_or_trigger_out_reg2 ;
reg                         sl2l_fsm_ready_or_desired_state_out_reg ;
reg                         sl2l_fsm_ready_or_desired_state_out_reg2 ;
reg     [1:0]               trig_state_reg ;


reg                         i_lane_mask_out;
reg    [NUM_LANES-1:0]      i_lane_mask_out_tx_rx;
wire   [NUM_LANES-1:0]      rx_target_en;
wire   [NUM_LANES-1:0]      tx_target_en;
wire   [NUM_LANES-1:0]      t_target_en_out;
wire   [NUM_LANES-1:0]      t_lane_mask_out_tx_rx;

wire   [31:0]               t_lane_mask_out_wire;
 
wire                        error_or_trigger_from_fsm ; //v0.961

reg    [31:0]               tx_initiator  ;
reg    [31:0]               rx_initiator  ;
reg    [1:0]                init_state  ;
reg                         common_initiator  ;
reg                         sl2l_fsm_tx_rx_out_reg  ;
reg                         src_fsm_target_instr_done_reg  ;
reg                         target_trigger_tx     ;
reg                         target_trigger_rx     ;
reg                         target_desired_st_tx  ;
reg                         target_desired_st_rx  ;
wire                        clear_target_trigger_tx ;
wire                        clear_target_trigger_rx ;
reg    [1:0]                interleave_active_reg  ;

wire    [NUM_LANES-1:0]     ready_from_target_tx; //v0.94
wire    [NUM_LANES-1:0]     ready_from_target_rx; //v0.94
reg                         tx_triggered              ; //v.0.952
reg                         rx_triggered              ; //v.0.952
reg                         sl2l_fsm_desired_state_or_ready_in_reg              ; //v.0.954
reg                         sl2l_fsm_tx_rx_in_reg                               ; //v.0.954


//---------------------------------------- Wire assignments  ----------------------------------- 

assign is_initiator         = (sl2l_fsm_tx_rx_out) ? src_role_cfg [1] : src_role_cfg [0]; // For trig state FSM
assign rx_target_en         = src_target_enable [NUM_LANES+16-1:16];
assign tx_target_en         = src_target_enable [NUM_LANES-1:0];
//assign t_target_en_out      = (sl2l_fsm_tx_rx_out ^ is_initiator)? tx_target_en :  rx_target_en; //v0.85
assign t_target_en_out      = (sl2l_fsm_tx_rx_out_current && src_role_cfg[1])? rx_target_en :  (!sl2l_fsm_tx_rx_out_current && src_role_cfg[0]) ? tx_target_en : {NUM_LANES{1'b0}}; //v0.9581
assign t_lane_mask_out_wire = (|t_lane_mask_out) ? (t_lane_mask_out << 1) : (1 <<SRC_LANE_INDEX) ;

assign sl2l_fsm_all_targets_done  = sl2l_fsm_tx_rx_out ? rx_all_targets_done : tx_all_targets_done ;
assign sl2l_instr_complete_ready  = sl2l_fsm_tx_rx_out_current ? sl2l_instr_complete_ready_rx : sl2l_instr_complete_ready_tx ; //v0.883
assign error_or_trigger_from_fsm  = sl2l_fsm_error_resp_or_trigger_out && !sl2l_fsm_error_resp_or_trigger_out_reg;
assign t_lane_mask_out_tx_rx      = t_target_en_out ;
assign ready_from_target_tx   =  (sl2l_desired_state_or_ready_in & ~sl2l_desired_state_or_ready_in_reg & ~sl2l_tx_rx_in );//v0.94
assign ready_from_target_rx   =  (sl2l_desired_state_or_ready_in & ~sl2l_desired_state_or_ready_in_reg & sl2l_tx_rx_in );//v0.94

assign clear_target_trigger_tx  = ~src_fsm_target_instr_done_reg && src_fsm_target_instr_done && !sl2l_fsm_tx_rx_out && target_trigger_tx ;
assign clear_target_trigger_rx  = ~src_fsm_target_instr_done_reg && src_fsm_target_instr_done && sl2l_fsm_tx_rx_out && target_trigger_rx  ;
assign sl2l_othr_profile_trigger = sl2l_fsm_tx_rx_out ? target_trigger_tx : target_trigger_rx ; //v0.962
//---------------------------------------- Logic Implementation ----------------------------------- 

//-------------------------------------------------------------------------------------------------
// MUX the status of Active SRC lane to the FSM of SRC Lane control 
//-------------------------------------------------------------------------------------------------
always@ (posedge clk) begin
    if(sclr) begin
        sl2l_fsm_trigger_or_error_resp_in          <= 1'b0 ;
        sl2l_fsm_desired_state_or_ready_in         <= 1'b0 ;
        sl2l_fsm_tx_rx_in                          <= 1'b0 ;
        sl2l_fsm_desired_state_or_ready_in_reg     <= 1'b0 ;
        sl2l_fsm_tx_rx_in_reg                      <= 1'b0 ;
    end
    else if (addr_gen_common_block_rst_done_reg) begin
        // When lane is initiator, send all status from target based on active pointer
        if (is_initiator) begin 
            sl2l_fsm_trigger_or_error_resp_in  <= |(sl2l_trigger_or_error_resp_in  & t_lane_mask_out)  ;
            sl2l_fsm_desired_state_or_ready_in <= |(sl2l_desired_state_or_ready_in & t_lane_mask_out_tx_rx)  ;
            sl2l_fsm_tx_rx_in                  <= |(sl2l_tx_rx_in & t_lane_mask_out_tx_rx) ;
        end  
        // When lane is target , if ready, sends out trigger, desired state
        //Lane2lane waits till common resources instruction is done at target to send trigger to Target FSM     
        else  begin 
            sl2l_fsm_trigger_or_error_resp_in      <=  i_lane_mask_out ;
            sl2l_fsm_desired_state_or_ready_in_reg <=  sl2l_fsm_tx_rx_out ? target_desired_st_rx : target_desired_st_tx   ;
            sl2l_fsm_tx_rx_in_reg                  <=  sl2l_fsm_tx_rx_out ? 1'b1 : 1'b0   ;
            sl2l_fsm_desired_state_or_ready_in     <= sl2l_fsm_desired_state_or_ready_in_reg ;
            sl2l_fsm_tx_rx_in                      <= sl2l_fsm_tx_rx_in_reg ;
        end
    end
end


//-------------------------------------------------------------------------------------------
// Update the status to Other SRC lane based on inputs from FSM in SRC lane control 

//Previous state needs to be retained as other target or initiator is still processing and updated based on mask
//The input is MUXED to FSM based on target mask /initiator mask  
//All transition of ready / trigger is taken care by fsm , only muxing is carried out in lane2lane
//In case of when the all targets are triggered , the ready is not lowered until the instruction is complete.
//So the condition if(target_en == ready) is enough for all targets done condition(in both stagger within enable /disable)
//Though other lanes communicates , the target mask is the main flag to indicate the active lane.
//Inputs from other lanes are also masked with target /initiator mask and ORed to send to FSM

//If FSM is driving a signal , it should wait for ready if stagger_within is enabled , otherwise should wait for all targets done
//Interleaving is not possible when a signal is driven.
//Therefore the t_lane_mask_out does not conflict during Interleaving.
//-------------------------------------------------------------------------------------------

always @(posedge clk) begin
    if(sclr) begin
        t_lane_mask_out <= {NUM_LANES{1'b0}};
        sl2l_error_resp_or_trigger_out  <= {NUM_LANES{1'b0}};
        sl2l_ready_or_desired_state_out <= {NUM_LANES{1'b0}};
        sl2l_tx_rx_out                  <= {NUM_LANES{1'b0}};
        rx_all_targets_done             <= 1'b0;
        tx_all_targets_done             <= 1'b0;
        trig_state                      <= ST_INIT ;
        rx_triggered <= 1'b0; //v0.952
        tx_triggered <= 1'b0; //v0.952
        sl2l_fsm_tx_rx_out_current      <= 1'b0;
    end
    //Lane2lane waits till common resources instruction is done at target to send trigger to Target FSM 
    else if (addr_gen_common_block_rst_done_reg) begin
        case (trig_state)
        ST_INIT: begin
            //Holds the current profile is TX/RX and used to handle interleave scenario
            sl2l_fsm_tx_rx_out_current <= sl2l_fsm_tx_rx_out;

            if(is_initiator) begin
                //New trigger received or (profile changed due to interleave instruction & interleave is active for current profile)
                trig_state <= (error_or_trigger_from_fsm)? ST_TGT_MASK  : 
                              (((interleave_active[1] && (!sl2l_fsm_tx_rx_out)) || (interleave_active[0] && sl2l_fsm_tx_rx_out)) 
                              && (sl2l_fsm_tx_rx_out_current!= sl2l_fsm_tx_rx_out)) //profile changed due to interleave instruction
                              ? ST_TGT_DONE :   ST_INIT ; //v0.95
                sl2l_error_resp_or_trigger_out  <=  {NUM_LANES{1'b0}};
                sl2l_ready_or_desired_state_out <=  {NUM_LANES{1'b0}};
                sl2l_tx_rx_out                  <=  {NUM_LANES{sl2l_fsm_tx_rx_out}} & t_target_en_out;
                t_lane_mask_out                 <=  {NUM_LANES{1'b0}};
                if (sl2l_instr_complete_ready == t_target_en_out) begin //v0.95
                    rx_all_targets_done       <= sl2l_fsm_tx_rx_out_current ? 1'b1: rx_all_targets_done; 
                    tx_all_targets_done       <= sl2l_fsm_tx_rx_out_current ? tx_all_targets_done : 1'b1;
                    tx_triggered <= !sl2l_fsm_tx_rx_out_current ? 1'b0 : tx_triggered ; //v0.952
                    rx_triggered <= sl2l_fsm_tx_rx_out_current  ? 1'b0 : rx_triggered ; //v0.952
                end
                else begin
                    rx_all_targets_done       <=  sl2l_fsm_tx_rx_out  ?  error_or_trigger_from_fsm? 1'b0 : (rx_all_targets_done && sl2l_fsm_error_resp_or_trigger_out) : rx_all_targets_done;
                    tx_all_targets_done       <=  !sl2l_fsm_tx_rx_out ? error_or_trigger_from_fsm? 1'b0 : (tx_all_targets_done && sl2l_fsm_error_resp_or_trigger_out) : tx_all_targets_done;
                end //v0.95              
            end
            else begin // When a target, FSM outputs is MUXed to intended initiator lane based on mask
                sl2l_error_resp_or_trigger_out     <= {NUM_LANES{sl2l_fsm_error_resp_or_trigger_out_reg }} & i_lane_mask_out_tx_rx; // Take the trigger down after receiving ready for the same
                sl2l_ready_or_desired_state_out    <= {NUM_LANES{src_fsm_target_instr_done_reg}} & i_lane_mask_out_tx_rx ; //v0.955
                sl2l_tx_rx_out                     <= ({NUM_LANES{sl2l_fsm_tx_rx_out_reg }} & i_lane_mask_out_tx_rx) ;  
                trig_state <= ST_INIT;
                t_lane_mask_out <= {NUM_LANES{1'b0}};
            end
        end
        ST_TGT_MASK: begin

                if (sl2l_fsm_stagger_within_en) begin //expected to be high through out the entire instrution
                    t_lane_mask_out <= (t_lane_mask_out_wire [NUM_LANES-1:0]) ; //target mask is staggered each target lane at a time
                    sl2l_error_resp_or_trigger_out  <= {NUM_LANES{1'b0}}; 
                    sl2l_ready_or_desired_state_out <= t_lane_mask_out_tx_rx & {NUM_LANES{1'b0}}; 
                    sl2l_tx_rx_out                  <= t_lane_mask_out_tx_rx & {NUM_LANES{sl2l_fsm_tx_rx_out_current}};
                    
                    //Instruction complete for stagger_within_enabled instruction
                    if (((sl2l_instr_complete_ready == t_target_en_out) || rx_all_targets_done) && sl2l_fsm_tx_rx_out_current )begin //0.958
                        rx_all_targets_done       <=  1'b1 ; 
                        tx_all_targets_done       <=  tx_all_targets_done ;                      
                        tx_triggered              <=  tx_triggered ; //v0.952
                        rx_triggered              <=  1'b0         ; //v0.952
                        trig_state <=  ST_INIT;
                    end
                    
                    else if (((sl2l_instr_complete_ready == t_target_en_out) || tx_all_targets_done) && !sl2l_fsm_tx_rx_out_current) begin //0.958
                        rx_all_targets_done       <=  rx_all_targets_done;  
                        tx_all_targets_done       <=  1'b1;                      
                        tx_triggered              <=  1'b0 ; //v0.952
                        rx_triggered              <=  rx_triggered ; //v0.952
                        trig_state                <=  ST_INIT;
                    end

                    //Stagger instruction not complete
                    else begin
                        rx_all_targets_done       <= sl2l_fsm_tx_rx_out_current ? 1'b0 : rx_all_targets_done ;
                        tx_all_targets_done       <= sl2l_fsm_tx_rx_out_current ? tx_all_targets_done :1'b0 ;
                        trig_state <=  ST_TGT_TRIG; //0.84
                    end
                end
                
                //When instruction has stagger within = 0
                else begin
                    t_lane_mask_out <= t_target_en_out;
                    trig_state <= ST_TGT_TRIG; //0.84
                    rx_all_targets_done       <= sl2l_fsm_tx_rx_out_current ? 1'b0 : rx_all_targets_done ;
                    tx_all_targets_done       <= sl2l_fsm_tx_rx_out_current ? tx_all_targets_done :1'b0 ;
                end

            end
        ST_TGT_TRIG: begin          
                rx_all_targets_done       <= rx_all_targets_done ;
                tx_all_targets_done       <= tx_all_targets_done ;
                t_lane_mask_out <= t_lane_mask_out;
                
                //Based on Initiator FSM outputs, Target receives trigger, desired state and profile for instruction
                sl2l_error_resp_or_trigger_out  <= (t_lane_mask_out & t_target_en_out & {NUM_LANES{sl2l_fsm_error_resp_or_trigger_out_reg2}}) | ((~t_lane_mask_out) & sl2l_error_resp_or_trigger_out) ;
                sl2l_ready_or_desired_state_out <= (t_lane_mask_out_tx_rx & {NUM_LANES{sl2l_fsm_ready_or_desired_state_out_reg2}}) | ((~t_lane_mask_out_tx_rx) & sl2l_ready_or_desired_state_out);
                sl2l_tx_rx_out                  <= (t_lane_mask_out_tx_rx & {NUM_LANES{sl2l_fsm_tx_rx_out_current}}) | ((~t_lane_mask_out_tx_rx) & sl2l_tx_rx_out); 
                
                //When target mask is set for valid targets OR initiator has no targets
                if (|( t_lane_mask_out & t_target_en_out) || !(|t_target_en_out)) begin //v0.955
                    trig_state <=  ST_TGT_DONE;
                    tx_triggered <= !sl2l_fsm_tx_rx_out_current ? 1'b1 : tx_triggered ; //v0.952
                    rx_triggered <= sl2l_fsm_tx_rx_out_current  ? 1'b1 : rx_triggered ; //v0.952
                end
                else begin
                    trig_state <=   ST_TGT_MASK;
                end 
         end
           
         ST_TGT_DONE: begin
            
                // v0.87 - Removing dependency of ready from targets to arrive simultaneously as targets finish instruction at different timing
                // When instruction has stagger within = 0 OR When the initiator lane has no targets (single lane)
                if ((!sl2l_fsm_stagger_within_en) || !(|t_target_en_out)) begin
                    //RX instrcution complete
                    if (((sl2l_instr_complete_ready == t_target_en_out) || rx_all_targets_done) && sl2l_fsm_tx_rx_out_current) begin //0.958
                        rx_all_targets_done                <=  1'b1                ;  //v0.883
                        tx_all_targets_done                <=  tx_all_targets_done ;  //v0.883
                        t_lane_mask_out                    <= {NUM_LANES{1'b0}};
                        trig_state                         <=  ST_INIT; 
                        rx_triggered                       <= 1'b0 ;//v0.952
                    end
                    //TX instruction complete
                    else if (((sl2l_instr_complete_ready == t_target_en_out) || tx_all_targets_done)&& !sl2l_fsm_tx_rx_out_current) begin //0.958
                        rx_all_targets_done                <=   rx_all_targets_done;  
                        tx_all_targets_done                <=   1'b1; 
                        t_lane_mask_out                    <= {NUM_LANES{1'b0}};
                        trig_state                         <=  ST_INIT; 
                        tx_triggered                       <= 1'b0 ;//v0.952
                    end
                    //Wait for instruction complete OR recognise interleave instruction
                    else begin
                        rx_all_targets_done       <= rx_all_targets_done ;  
                        tx_all_targets_done       <= tx_all_targets_done ; 
                        t_lane_mask_out           <= t_lane_mask_out;
                        trig_state                <=  ((sl2l_fsm_tx_rx_out_current!= sl2l_fsm_tx_rx_out) )? ST_INIT:  ST_TGT_DONE ;
                    end
                    
                end
                //When drive instruction stagger within is enabled and instruction is complete for intended target
                //else if ((|(~sl2l_desired_state_or_ready_in_reg  & sl2l_desired_state_or_ready_in  &t_lane_mask_out & ({NUM_LANES{sl2l_fsm_tx_rx_out_current}} ~^ sl2l_tx_rx_in)))  && sl2l_fsm_stagger_within_en ) begin //v0.957
                else if ((|(~sl2l_desired_state_or_ready_in_reg  & sl2l_desired_state_or_ready_in  &t_lane_mask_out & ({NUM_LANES{sl2l_fsm_tx_rx_out_current}} ~^ sl2l_tx_rx_in)))  /*&& sl2l_fsm_stagger_within_en*/ ) begin //v0.959
                    rx_all_targets_done   <= rx_all_targets_done ;
                    tx_all_targets_done   <= tx_all_targets_done ;
                    t_lane_mask_out       <= t_lane_mask_out;
                    trig_state            <=  ST_TGT_MASK;
                end
                //Wait for instruction complete OR recognise interleave instruction
                else begin
                    rx_all_targets_done   <= rx_all_targets_done ;
                    tx_all_targets_done   <= tx_all_targets_done ;
                    trig_state            <=  (sl2l_fsm_tx_rx_out_current!= sl2l_fsm_tx_rx_out)? ST_INIT:  ST_TGT_DONE ; //v0.93
                    t_lane_mask_out       <= (sl2l_fsm_stagger_within_en)?t_lane_mask_out : t_target_en_out;
                end                    
            end
            default : trig_state <=  ST_INIT;
        endcase
    end
end



//-------------------------------------------------------------------------------------------------
// Delayed register for Inputs from FSM to capture posedge
//-------------------------------------------------------------------------------------------------
always@ (posedge clk) begin
    if(sclr) begin
        sl2l_fsm_error_resp_or_trigger_out_reg   <= 1'b0 ;
        sl2l_fsm_error_resp_or_trigger_out_reg2  <= 1'b0 ;
        sl2l_desired_state_or_ready_in_reg       <= {NUM_LANES{1'b0}};
        sl2l_trigger_or_error_resp_in_reg        <= {NUM_LANES{1'b0}};
        sl2l_fsm_ready_or_desired_state_out_reg  <= 1'b0;
        sl2l_fsm_ready_or_desired_state_out_reg2 <= 1'b0;
        trig_state_reg                           <= 2'd0;
        src_fsm_target_instr_done_reg            <= 1'b0 ;
    end
    else begin
        sl2l_fsm_error_resp_or_trigger_out_reg   <= sl2l_fsm_error_resp_or_trigger_out ;
        sl2l_fsm_error_resp_or_trigger_out_reg2  <= sl2l_fsm_error_resp_or_trigger_out_reg ;
        sl2l_desired_state_or_ready_in_reg       <= sl2l_desired_state_or_ready_in ;
        sl2l_fsm_ready_or_desired_state_out_reg  <= sl2l_fsm_ready_or_desired_state_out     ;
        sl2l_fsm_ready_or_desired_state_out_reg2 <= sl2l_fsm_ready_or_desired_state_out_reg ;
        sl2l_trigger_or_error_resp_in_reg        <= sl2l_trigger_or_error_resp_in ; //v0.90
        trig_state_reg                           <= trig_state ;
        src_fsm_target_instr_done_reg            <= src_fsm_target_instr_done ;
    end
end



//-------------------------------------------------------------------------------------------------
// Target FSM - TX and RX sequence handling in Target based on update in HAS section 3.3.1 Interleaving 
// scenarios - v0.90
// v0.956 - Target Trigger and desired state updated in separate blocks
//-------------------------------------------------------------------------------------------------

always@ (posedge clk) begin
    if (sclr) begin
        target_trigger_tx         <= 1'b0 ;
        target_trigger_rx         <= 1'b0 ;
        target_desired_st_tx      <= 1'b0 ;
        target_desired_st_rx      <= 1'b0 ;
    end
    else begin
		
        //Capture and hold tx trigger and desired state until instruction is complete & clear based on clear_tx_trigger
        if (|(~sl2l_trigger_or_error_resp_in_reg & sl2l_trigger_or_error_resp_in & (~sl2l_tx_rx_in))) begin
            target_trigger_tx      <= (|(~sl2l_trigger_or_error_resp_in_reg & sl2l_trigger_or_error_resp_in & tx_initiator[NUM_LANES-1:0] & (~sl2l_tx_rx_in)) && !clear_target_trigger_tx )? 1'b1: target_trigger_tx && !clear_target_trigger_tx ; 
            
            target_desired_st_tx   <= |(~sl2l_trigger_or_error_resp_in_reg & sl2l_trigger_or_error_resp_in & sl2l_desired_state_or_ready_in & tx_initiator[NUM_LANES-1:0] & (~sl2l_tx_rx_in)) ;
        end
        
        else begin
            target_trigger_tx    <= target_trigger_tx && !clear_target_trigger_tx ;
            target_desired_st_tx <= target_desired_st_tx ;
        end
        
        //Capture and hold rx trigger and desired state until instruction is complete & clear based on clear_rx_trigger
        if (|(~sl2l_trigger_or_error_resp_in_reg & sl2l_trigger_or_error_resp_in & sl2l_tx_rx_in) ) begin
            target_trigger_rx      <= (|(~sl2l_trigger_or_error_resp_in_reg & sl2l_trigger_or_error_resp_in & rx_initiator[NUM_LANES-1:0] & sl2l_tx_rx_in   ) && !clear_target_trigger_rx )? 1'b1: target_trigger_rx && !clear_target_trigger_rx ;
            
            target_desired_st_rx   <= |(~sl2l_trigger_or_error_resp_in_reg & sl2l_trigger_or_error_resp_in & sl2l_desired_state_or_ready_in & rx_initiator[NUM_LANES-1:0] & sl2l_tx_rx_in   ) ;
        end
        else begin
            target_trigger_rx    <= target_trigger_rx && !clear_target_trigger_rx ;  
            target_desired_st_rx <= target_desired_st_rx ;
        end
    end
end


//-------------------------------------------------------------------------------------------------
// Initiator FSM - TX and RX sequence handling based on update in HAS section 3.3.1 Interleaving 
// scenarios - v0.94
// Captures posedge of ready & trigger=1 for each target lane and accumulate till instruction is 
// complete 
//-------------------------------------------------------------------------------------------------

always@ (posedge clk) begin
    if (sclr) begin
        sl2l_instr_complete_ready_rx      <= {NUM_LANES{1'b0}} ;
        sl2l_instr_complete_ready_tx      <= {NUM_LANES{1'b0}} ;
        //sl2l_target_tx_error_resp         <= {NUM_LANES{1'b0}} ; //v0.963
        //sl2l_target_rx_error_resp         <= {NUM_LANES{1'b0}} ; //v0.063
    end
    else begin

        //RX instruction complete & TX captured for each target lane
        if ((sl2l_instr_complete_ready == t_target_en_out) && sl2l_fsm_tx_rx_out_current) begin
            sl2l_instr_complete_ready_rx       <= {NUM_LANES{1'b0}};             
            sl2l_instr_complete_ready_tx       <= (({NUM_LANES{tx_triggered}} & ready_from_target_tx & tx_target_en ) | sl2l_instr_complete_ready_tx) ; //v0.955
        end
        
        //TX instruction complete & RX captured for each target lane
        else if ((sl2l_instr_complete_ready == t_target_en_out) && !sl2l_fsm_tx_rx_out_current) begin 
            sl2l_instr_complete_ready_rx <= (({NUM_LANES{rx_triggered}} & ready_from_target_rx  & rx_target_en ) | sl2l_instr_complete_ready_rx) ;   //v0.955
            sl2l_instr_complete_ready_tx <=  {NUM_LANES{1'b0}}; 
        end
        
        //TX & RX instruction complete captured for each target lane
        else begin
            sl2l_instr_complete_ready_rx <=  (({NUM_LANES{rx_triggered}} & ready_from_target_rx  & rx_target_en ) | sl2l_instr_complete_ready_rx) ; //v0.955
            sl2l_instr_complete_ready_tx <=  (({NUM_LANES{tx_triggered}} & ready_from_target_tx & tx_target_en ) | sl2l_instr_complete_ready_tx ) ; //v0.955
        end
    end
end

//-------------------------------------------------------------------------------------------------
// Initiator FSM -  
// v0.960 - Error response from target to be captured and held until FSM has addressed it
//-------------------------------------------------------------------------------------------------
always@ (posedge clk) begin
    if (sclr) begin
        sl2l_target_tx_error_resp         <= 1'b0 ;
        sl2l_target_rx_error_resp         <= 1'b0 ; 
    end
    else begin
        //TX Error response captured from target
        if (|(~sl2l_trigger_or_error_resp_in_reg & sl2l_trigger_or_error_resp_in & (~sl2l_tx_rx_in) &  tx_target_en)) begin //v0.960
            sl2l_target_tx_error_resp <= 1'b1 ;
        end
        else begin
            sl2l_target_tx_error_resp <= !sl2l_tx_init_rst_done_for_err & sl2l_target_tx_error_resp;
        end
        
        //RX Error response captured from target
        if (|(~sl2l_trigger_or_error_resp_in_reg & sl2l_trigger_or_error_resp_in & (sl2l_tx_rx_in) &  rx_target_en)) begin //v0.960
            sl2l_target_rx_error_resp <= 1'b1 ;
        end
        else begin
            sl2l_target_rx_error_resp <= !sl2l_rx_init_rst_done_for_err & sl2l_target_rx_error_resp;
        end
                
    end
end

//-------------------------------------------------------------------------------------------------
// TARGET FSM: 
//1. Handles TX and RX triggers with dedicated registers.
//2. Interleaving due to monitor scenario
//3. Interleaving due to outstanding triggers in FSM
//-------------------------------------------------------------------------------------------------
always@ (posedge clk) begin
    if(sclr) begin  
        i_lane_mask_out             <= 1'b0 ;
        i_lane_mask_out_tx_rx       <= {NUM_LANES{1'b0}};
        tx_initiator                <= 32'd0;
        rx_initiator                <= 32'd0;
        init_state                  <= 2'd0;
        common_initiator            <= 1'b1; //v0.881
        sl2l_fsm_tx_rx_out_reg      <= 1'b0;
        interleave_active_reg       <= 2'd0;
    end
    else begin
        tx_initiator           <=   (1 << src_role_cfg[5:2]) ;
        rx_initiator           <=   (1 << src_role_cfg[9:6]) ;
        common_initiator        <= (src_role_cfg[9:6] == src_role_cfg[5:2]); 
        sl2l_fsm_tx_rx_out_reg <= sl2l_fsm_tx_rx_out;
        interleave_active_reg  <= interleave_active ;

        
        case (init_state)
        2'd0: begin
		    if (error_or_trigger_from_fsm & !is_initiator) begin //v0.961
				i_lane_mask_out_tx_rx <= sl2l_fsm_tx_rx_out ? rx_initiator[NUM_LANES-1:0] :tx_initiator[NUM_LANES-1:0] ;
				i_lane_mask_out <= i_lane_mask_out;
				init_state      <= init_state;
			end
			
           // When TX & RX receives Trigger at the same time
            else if (target_trigger_tx && target_trigger_rx) begin
                    i_lane_mask_out <= sl2l_fsm_tx_rx_out ? target_trigger_rx : target_trigger_tx  ;
                    i_lane_mask_out_tx_rx <= sl2l_fsm_tx_rx_out ? rx_initiator[NUM_LANES-1:0] :tx_initiator[NUM_LANES-1:0] ;
                    init_state  <= (sl2l_fsm_tx_rx_out)? 2'd1 : 2'd2 ;
            end
            else begin
                //TX new instruction trigger , not interleaved
                if (target_trigger_tx && !interleave_active[1] && !sl2l_fsm_tx_rx_out) begin //TX //v0.86
                    i_lane_mask_out <= target_trigger_tx;
                    i_lane_mask_out_tx_rx <= tx_initiator[NUM_LANES-1:0] ;
                    init_state  <= 2'd2;
                end
                //RX new instruction trigger , not interleaved
                else if (target_trigger_rx && !interleave_active[0] && sl2l_fsm_tx_rx_out ) begin //RX //v0.86
                    i_lane_mask_out <= target_trigger_rx ;
                    i_lane_mask_out_tx_rx <= rx_initiator[NUM_LANES-1:0] ;
                    init_state  <= 2'd1;
                end
                //Interleave for outstanding trigger in FSM - HAS 3.3.1 update
                else if (stagger_cnt_done) begin //v0.87
                    i_lane_mask_out <= (sl2l_fsm_tx_rx_out && interleave_active[0])? 1'b0 :((!sl2l_fsm_tx_rx_out && interleave_active[1]) ? 1'b0 : i_lane_mask_out) ; //v0.92
                    i_lane_mask_out_tx_rx <= (sl2l_fsm_tx_rx_out && interleave_active[0])? rx_initiator[NUM_LANES-1:0] :((!sl2l_fsm_tx_rx_out && interleave_active[1]) ? tx_initiator[NUM_LANES-1:0] : i_lane_mask_out_tx_rx) ;
                    init_state <= (sl2l_fsm_tx_rx_out && interleave_active[0])? 2'd1 :((!sl2l_fsm_tx_rx_out && interleave_active[1]) ? 2'd2 : 2'd0) ;
                end
                else begin
                    i_lane_mask_out <=  common_initiator ? 1'b0 : i_lane_mask_out; //v0.86
                    i_lane_mask_out_tx_rx <= i_lane_mask_out_tx_rx;
                    init_state  <= 2'd0;
                end
            end
        end
        
        2'd1: begin //RX
            //No need to capture new trigger in end of instruction because it will be captured when moved to state 0
            // End of instruction for RX
            if (~src_fsm_target_instr_done_reg && src_fsm_target_instr_done && sl2l_fsm_tx_rx_out && target_trigger_rx) begin //v0.90
                i_lane_mask_out <=  1'b0 ;
                i_lane_mask_out_tx_rx <= i_lane_mask_out_tx_rx  ;
                init_state  <=  2'd0;
            end
            // Current profile changed to TX because of interleaving
            else if (!sl2l_fsm_tx_rx_out) begin
                i_lane_mask_out <=  1'b0  ; //v0.92
                i_lane_mask_out_tx_rx <=  tx_initiator[NUM_LANES-1:0] ;
                init_state      <= (is_initiator)?init_state: (interleave_active_reg[1] && ~interleave_active [1] && target_trigger_tx) ? 2'd2 : (interleave_active [1] && target_trigger_tx) ? 2'd2 : 2'd0 ;
            end         
            
            else begin
                i_lane_mask_out <= target_trigger_rx ;
                i_lane_mask_out_tx_rx <= rx_initiator[NUM_LANES-1:0] ;
                init_state      <= init_state;

            end
        end
        
        2'd2: begin //TX
            //No need to capture new trigger in end of instruction because it will be captured when moved to state 0
            // End of instruction for TX
            if (~src_fsm_target_instr_done_reg && src_fsm_target_instr_done && !sl2l_fsm_tx_rx_out && target_trigger_tx) begin //v0.882
                i_lane_mask_out <=  1'b0 ;
                i_lane_mask_out_tx_rx <= i_lane_mask_out_tx_rx  ;
                init_state  <=  2'd0; 
            end
            // Current profile changed to TX because of interleaving
            else if ( sl2l_fsm_tx_rx_out) begin
                i_lane_mask_out <=  1'b0 ; //v0.92
                i_lane_mask_out_tx_rx <= rx_initiator[NUM_LANES-1:0] ;
                init_state      <= (is_initiator)?init_state: (interleave_active_reg[0] && ~interleave_active [0] && target_trigger_rx) ? 2'd1: (interleave_active[0] && target_trigger_rx) ? 2'd1 : 2'd0;
            end
            else begin
                i_lane_mask_out <= target_trigger_tx ;
                i_lane_mask_out_tx_rx <= tx_initiator[NUM_LANES-1:0] ;
                init_state      <= init_state;
            end
        end

        default : init_state <= 1'b0;
        endcase
    end 
end

endmodule



//------------------------------------------------------------------------------------------------------- ------------------
// Version             |  Changes                                                         | Date          | Owner ID
//------------------------------------------------------------------------------------------------------- ------------------
//   0.0               |                                                                  |               | 
//   0.1               | Initial code                                                     |  17-Jun-2022  | skgr
//   0.2               | Update SRC_LANE_INDEX parameter                                  |  21-Jun-2022  | skgr
//   0.3               | Bit wise ANDing modified , State name change                     |  28-Jun-2022  | skgr
//   0.4               | sl2l_fsm_ready_or_desired_state_out port name updated            |  29-Jun-2022  | skgr
//   0.5               | all_targets_done & sl2l_error_resp_or_trigger_out fixed          |  18-Jul-2022  | skgr
//   0.6               | Multi lane TX RX Entry fix                                       |  22-Aug-2022  | skgr
//   0.7               | Interleaving fix for all targets done                            |  07-Sep-2022  | skgr
//   0.8               | Interleaving fix for multiple lanes - double interleaving        |  13-Sep-2022  | skgr
//   0.81              | Corner case scenario for interleave complete                     |  13-Sep-2022  | skgr
//   0.82              | Initiator mask issue fix                                         |  29-Sep-2022  | skgr
//   0.83              | Initiator mask issue fix for interleave scenario                 |  13-Oct-2022  | skgr
//   0.84              | Fix for lane that is both init and tgt at diff modes             |  03-Nov-2022  | skgr
//   0.85              |  Add mask_trigger_till_inst_done                                 |  24-Nov-2022  | skgr
//   0.86              | Wait to send trigger unti tx_rx_out is in target profile         |  02-Dec-2022  | skgr
//   0.87              | Fix for trig_state-ST_TGT_DONE, when stagger disabled,           |               |
//                     | "ready" not expected to arrive simulataneuosly                   |  05-Dec-2022  | skgr
//   0.88              | HSD 15012445890: Interleave scenario HAS 3.3.1                   |  07-Dec-2022  | skgr
//   0.90              | Added src_fsm_target_instr_done to detect end of tgt instr       |  14-Dec-2022  | skgr
//   0.91              | clear i_lane_mask_out at end of instruction                      |  15-Dec-2022  | skgr
//   0.92              | clear i_lane_mask_out to not send trigger again during           |  16-Dec-2022  | skgr
//                     | interleaving                                                     |               |
//   0.93              | Removing condition to move back to st_init when no interleave    |  19-Dec-2022  | skgr
//   0.94              | Initiator FSM, Instruction complete check updated                |  30-Dec-2022  | skgr
//                     | Capture end of instruction of TX&RX irrespective of current      |               |
//                     | profile in initiator                                             |               |
//   0.95              | When TX_RX_out changes at initiator, the check for if current    |               |
//                     | current profile is interleaved or new instruction check is added |  03-Jan-2023  | skgr
//   0.951             | INIT:RX_triggered and TX_triggered needs to be cleared at ST_INIT|  05-Jan-2023  | skgr
//   0.952             | INIT:Capture instruction state ready continuously, not just ST.2 |  11-Jan-2023  | skgr
//   0.953             | INIT:instr_complete_tgt_mask register separately for tx & rx     |  13-Jan-2023  | skgr
//   0.954             | TGT:1 clock sync missed between trigger and tx_rx_in sent to FSM |  16-Jan-2023  | skgr
//   0.955             | INIT & TGT: ready sent from tgt to init is assigned with tgt     |  17-Jan-2023  | skgr
//                     | instruction done ,init fsm does not check ready to send trigger  |               |
//   0.956             | Target Trigger and desired state updated in separate blocks      |  20-Jan-2022  | skgr
//   0.957             | Init: FSM accepting ready for other profile for current instr.   |  25-Jan-2022  | skgr
//                     | Included tx_rx_in check                                          |               |
//   0.958             | INIT:When init monitor instr gets completed after all_target_done|  06-Feb-2023  | skgr
//                     | sl2l_instr_complete_ready is 0,for St3->st0 check all tgts done  |               |
//   0.9581            | INIT:Lane Target enable based on  sl2l_fsm_tx_rx_out_current     |  20-Feb-2023  | skgr
//   0.959             | Comments added and removed redundant registers                   |  17-Feb-2023  | skgr
//   0.960             | Error resp from target for TX, RX sent to FSM added              |  16-Mar-2023  | skgr
//   0.961             | Error resp from target fix for init maskerror_or_trigger_from_fsm|  20-Mar-2023  | skgr
//   0.962             | Flag to FSM to indicate outstanding trigger for TX/RX alarm      |               |
//                       reset entry initiated INIT, when profile is in fully operational |               |
//                     | state                                                            |  21-Mar-2023  | skgr
//   0.963             | Fix multi driver issue                                           |  28-Mar-2023  | skgr     
//--------------------------------------------------------------------------------------------------------------------------
