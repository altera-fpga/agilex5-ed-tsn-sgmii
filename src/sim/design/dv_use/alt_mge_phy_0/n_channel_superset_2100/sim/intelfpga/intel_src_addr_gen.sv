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

// File Name   : intel_src_addr_gen.sv

// Project     : <SRC> 

// Version     : <1.58>

// Description : SM SRC Address generator module. This module is being use to generate Tx and Rx address 

//               based on the commands receive from SM state machine. This address is being use to read 

//               the instruction from M20K memory.

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

`timescale 1 ps/1 ps               // time-unit = 1 ns, precision = 10 ps

module intel_src_addr_gen

#(

    parameter                      ADDR_WIDTH         = 9,

    parameter [ADDR_WIDTH-1:0]     RX_START_ADDR      = 176, 

    parameter [ADDR_WIDTH-1:0]     TX_START_ADDR      = 72,   //after common resource

    parameter [ADDR_WIDTH-1:0]     TOTAL_INSTRUCTIONS = 71

)

(   //input port

    input                          clk,                         //100mhz input clock

    input                          sclr,                        //*active low signal

    input                          addr_gen_read_start,

    input                          addr_gen_tx_rx_sel,           //0-tx, 1-rx

    input                          addr_gen_rst_exit_entry_sel , //0-exit, 1-entry

    input                          addr_gen_abort_instr,

    input                          addr_gen_jump_to_rst_entry,

    input [1:0]                    src_role_cfg,

    input                          sl2l_fsm_ready_or_desired_state_out,  

    input                          addr_gen_initiator_instr_done,      //for target should be = 1

    input                          sl2l_fsm_all_targets_done,          //for target should be = 1

    //output port  

    output reg                     addr_gen_common_block_rst_done,

    output reg                     addr_gen_tx_fully_op,

    output reg                     addr_gen_rx_fully_op,

    output reg                     addr_gen_tx_fully_rst,

    output reg                     addr_gen_rx_fully_rst,

    output reg [ADDR_WIDTH-1:0]    rd_addr, 

    output reg                     rd_req    

);

// Global Parameter Declaration

// Local Parameter Declaration 

//localparam [ADDR_WIDTH-1:0]    RX_LAST_ADDR    = 256;

localparam rst_st = 4'b0000, comm_rsorc_st  = 4'b0001, tx_st  = 4'b0010, 

           rx_st = 4'b0011, tx_exit_st  = 4'b0100, tx_entry_st  = 4'b0101,

           rx_exit_st = 4'b0110, rx_entry_st  = 4'b0111, tx_exit_jmp_st  = 4'b1000, 

           tx_entry_jmp_st  = 4'b1001, rx_exit_jmp_st = 4'b1010, rx_entry_jmp_st = 4'b1011;

localparam [ADDR_WIDTH-1:0] TX_LAST_ADDR = RX_START_ADDR - 9'd1;
localparam [ADDR_WIDTH-1:0] RX_NEXT_ADDR = RX_START_ADDR + 9'd5;
localparam [ADDR_WIDTH-1:0] RX_LAST_ADDR = ((TOTAL_INSTRUCTIONS-9'd2) << 2) - 9'd1 ;//v1.58
           


//---------------------------------------- Register and Wire declaration----------------------------------------------------

reg                       tx_spe_case;

reg                       rx_spe_case;

reg [2:0]                 inst_counter;

reg [ADDR_WIDTH-1:0]      tx_counter;

reg [ADDR_WIDTH-1:0]      rx_counter;

reg [ADDR_WIDTH-1:0]      tmp_tx_counter;

reg [ADDR_WIDTH-1:0]      tmp_rx_counter;

//reg [ADDR_WIDTH-1:0]      tx_last_addr; //v0.54

//reg [ADDR_WIDTH-1:0]      rx_last_addr; //v0.54

//reg [ADDR_WIDTH-1:0]      rx_next_addr; //v0.54

reg [3:0]                 nxt_state ;

reg                       sl2l_fsm_ready_or_desired_state;  

reg                       sl2l_fsm_ready_or_desired_state_d;

reg                       sl2l_fsm_ready_or_desired_state_d2;

reg                       abort_flag;

reg                       addr_gen_read_start_d;

reg                       addr_gen_abort_instr_d;

//---------------------------------------- Wire assignments -----------------------------------------------------------------

//---------------------------------------- Logic Implementation -------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------

//Block description :1       

//This is combination logic 

//This always block is basically used to select the

//read address bassed on addr_gen_tx_rx_sel

//addr_gen_tx_rx_sel = 0, read addr will be tx addr

//addr_gen_tx_rx_sel = 1, read addr will be rx addr                       

//---------------------------------------------------------------------------------------------------------------------------

//always @(*)

always @(posedge clk)

begin

    if(sclr)

       begin

          rd_addr                         <= 9'b000000000;

          sl2l_fsm_ready_or_desired_state <= 1'b0;

          abort_flag                      <= 1'b0;
          
          sl2l_fsm_ready_or_desired_state_d2 <= 1'b0; //v1.55
          
          sl2l_fsm_ready_or_desired_state_d  <= 1'b0 ;

        end  

    else 

        begin
        
            sl2l_fsm_ready_or_desired_state       <= sl2l_fsm_ready_or_desired_state_out;

            sl2l_fsm_ready_or_desired_state_d     <= (sl2l_fsm_ready_or_desired_state_out && (!sl2l_fsm_ready_or_desired_state)); //rising edge
            
            sl2l_fsm_ready_or_desired_state_d2    <= sl2l_fsm_ready_or_desired_state_d ; //v1.55
 
            if(rx_counter > RX_START_ADDR &&  rx_counter < RX_NEXT_ADDR && addr_gen_abort_instr_d)
           begin        
            abort_flag <= 1'b1;
              end

            else if(nxt_state == comm_rsorc_st)
           begin        
            abort_flag <= 1'b0;
               end
           
            if(addr_gen_tx_rx_sel)

                begin

                   rd_addr <= rx_counter;

                end

            else

                begin

                   rd_addr <= tx_counter;

                end               

        end      

end

//---------------------------------------------------------------------------------------------------------------------------

//Block description :2         

//SM_SRC control logic                

//This block will be using to generate the addr            

//based on the input command receive from SRC state machine      

//---------------------------------------------------------------------------------------------------------------------------

always @(posedge clk)

begin

    if(sclr)

        begin

            rx_counter             <= RX_START_ADDR;

            nxt_state              <= rst_st;

            tx_counter             <= 9'b000000000;

            tmp_tx_counter         <= 9'b000000000;

            tmp_rx_counter         <= 9'b000000000;

            rd_req                 <= 1'b0;

            tx_spe_case            <= 1'b0;

            rx_spe_case            <= 1'b0;

            inst_counter           <= 3'b000;

            addr_gen_tx_fully_op   <= 1'b0; //added on 29/06/2022

            addr_gen_rx_fully_op   <= 1'b0; 

            addr_gen_tx_fully_rst  <= 1'b0; 

            addr_gen_rx_fully_rst  <= 1'b0; 
            
            addr_gen_read_start_d  <= 1'b0;
            
            addr_gen_abort_instr_d <= 1'b0;
            
            addr_gen_common_block_rst_done <= 1'b0; //added on 23/06/2022

        end 

    else

    begin

            //tx_last_addr           <= RX_START_ADDR - 9'd1;

            //rx_next_addr           <= RX_START_ADDR + 9'd5;

            //rx_last_addr           <= 9'd259;//64 instruction  * 4 address each(256)
            
            addr_gen_read_start_d  <= addr_gen_read_start;
            
        addr_gen_abort_instr_d <= addr_gen_abort_instr;

//---------------------------------------------------------------------------------------------------------------------------

//rst_st is reset state. after power cycle this state  

//will generate addr 0 to common resource last addr and move to comm_rsorc_st state                             

//---------------------------------------------------------------------------------------------------------------------------

        case(nxt_state)

        rst_st:begin//0

            if(tx_counter >= TX_START_ADDR)

                begin 

                    nxt_state              <= comm_rsorc_st;

                    rd_req                 <= 1'b0;

                    addr_gen_tx_fully_rst  <= 1'b1;  //added on 15/07/2022

                    addr_gen_rx_fully_rst  <= 1'b1;

                    addr_gen_common_block_rst_done <= 1'b1;

                end

            else if(addr_gen_abort_instr_d && inst_counter[1:0] != 2'b00) //common resource abort added on 13/07/2022

                begin  

                    nxt_state    <= rst_st;

                    tx_counter   <= tx_counter + 9'd1;

                    rd_req       <= 1'b0;

                    inst_counter <= 0;

                end

            else if(addr_gen_read_start_d)

                begin  

                    nxt_state  <= rst_st;

                    tx_counter <= tx_counter + 9'd1;

                    rd_req     <= 1'b1;

                    inst_counter <=  inst_counter + 3'd1;

                end                 

            else 

                begin

                    nxt_state  <= rst_st;

                    rd_req     <= 1'b0;

                end

        end

//---------------------------------------------------------------------------------------------------------------------------

//comm_rsorc_st is selection of tx or rx state.

//when addr_gen_tx_rx_sel is 0 move to tx_st, when addr_gen_tx_rx_sel =1

//move to rx_st else comm_rsorc_st

//---------------------------------------------------------------------------------------------------------------------------   

        comm_rsorc_st:begin//1

            if(!addr_gen_tx_rx_sel && addr_gen_jump_to_rst_entry)begin//jump to tx reset entry //v1.53

                //nxt_state  <= tx_st;

                nxt_state    <= comm_rsorc_st;

                tx_counter   <= TX_LAST_ADDR - 9'd3; //added on 04/07/2022

                addr_gen_tx_fully_op  <= 1'b0;

            end



            else if((!addr_gen_tx_rx_sel) && (!addr_gen_rst_exit_entry_sel) && addr_gen_read_start_d) //tx exit

            begin

                addr_gen_tx_fully_rst  <= 1'b0;

                inst_counter <= inst_counter + 3'd1;

                nxt_state    <= tx_exit_st;

                tx_counter   <= tx_counter + 9'd1;

                rd_req       <= 1'b1;

            end
            
            else if((!addr_gen_tx_rx_sel) && (!addr_gen_rst_exit_entry_sel)) //tx exit no address selection

            begin

                //addr_gen_tx_fully_rst  <= 1'b0;

                nxt_state    <= tx_exit_st;

            end         

            else if((!addr_gen_tx_rx_sel) && addr_gen_rst_exit_entry_sel && addr_gen_read_start_d)//tx entry

            begin

                addr_gen_tx_fully_rst  <= 1'b0;
                
                addr_gen_tx_fully_op   <= 1'b0;

                inst_counter <= inst_counter + 3'd1;

                nxt_state    <= tx_entry_st;

                tx_counter   <= tx_counter + 9'd1;

                rd_req       <= 1'b1;

            end
            else if(addr_gen_tx_rx_sel && addr_gen_jump_to_rst_entry )begin//jump to rx reset entry

                // nxt_state  <= rx_st;

                nxt_state  <= comm_rsorc_st;

                rx_counter <= RX_LAST_ADDR - 9'd3;

                addr_gen_rx_fully_op  <= 1'b0;

            end         
            

            else if(addr_gen_tx_rx_sel && (!addr_gen_rst_exit_entry_sel) && addr_gen_read_start_d) //rx exit

            begin

                addr_gen_rx_fully_rst  <= 1'b0;

                inst_counter <= inst_counter + 3'd1;

                nxt_state    <= rx_exit_st;

                rx_counter   <= rx_counter + 9'd1;

                rd_req       <= 1'b1;

            end

            else if(addr_gen_tx_rx_sel && (!addr_gen_rst_exit_entry_sel)) //rx exit no address selection

            begin

                //addr_gen_rx_fully_rst  <= 1'b0;

                nxt_state    <= rx_exit_st;

            end

            else if(addr_gen_tx_rx_sel && addr_gen_rst_exit_entry_sel && addr_gen_read_start_d)//rx entry

            begin

                addr_gen_rx_fully_rst  <= 1'b0;
        
                addr_gen_rx_fully_op   <= 1'b0;

                inst_counter <= inst_counter + 3'd1;

                nxt_state    <= rx_entry_st;

                rx_counter   <= rx_counter + 9'd1;

                rd_req       <= 1'b1;

            end           

            else begin

                nxt_state             <= comm_rsorc_st;

                rd_req                <= 1'b0;

                inst_counter          <= 3'd0;

            end 

        end



//---------------------------------------------------------------------------------------------------------------------------

//tx exit

//tx_exit_st is for tx exit. it will generate tx exit addr upto 

//TX_LAST_ADDR. it will move tx_entry_jmp_st once "addr_gen_read_start_d" become

//low                                                    

//---------------------------------------------------------------------------------------------------------------------------  

        tx_exit_st:begin//4

            if(addr_gen_tx_rx_sel)begin

                inst_counter <= 0;

                nxt_state    <= comm_rsorc_st;

                rd_req       <= 1'b0;                

            end
            
            else if(!addr_gen_tx_rx_sel && addr_gen_jump_to_rst_entry)begin//jump to tx reset entry //v1.52

                //nxt_state  <= tx_st;

                nxt_state    <= comm_rsorc_st;

                tx_counter   <= TX_LAST_ADDR - 9'd3; //added on 04/07/2022

                addr_gen_tx_fully_op  <= 1'b0;

            end
            
            

            else if(tx_counter > TX_LAST_ADDR && ((src_role_cfg[0] && addr_gen_initiator_instr_done && sl2l_fsm_all_targets_done) || 

        ((!src_role_cfg[0]) && (sl2l_fsm_ready_or_desired_state_d||sl2l_fsm_ready_or_desired_state_d2))))begin //v1.55

                nxt_state             <= comm_rsorc_st;

                rd_req                <= 1'b0;

                addr_gen_tx_fully_op  <= 1'b1;

                tx_counter            <= TX_LAST_ADDR - 9'd3;

                addr_gen_tx_fully_rst <= 1'b0;

            end 

            

            else if(!addr_gen_read_start_d && addr_gen_rst_exit_entry_sel)begin

                inst_counter <= 0;

                nxt_state    <= comm_rsorc_st;

                rd_req       <= 1'b0;

            end

             

            else if(addr_gen_abort_instr_d && inst_counter[1:0] != 2'b00)begin

                inst_counter <= 0;

                nxt_state    <= tx_exit_st;

                rd_req       <= 1'b0;

                tx_counter   <= tx_counter + 9'd1;

                addr_gen_tx_fully_rst <= 1'b0;

            end

            

            else if(addr_gen_read_start_d)begin

                inst_counter <= inst_counter + 3'd1;

                nxt_state    <= tx_exit_st;

                tx_counter   <= tx_counter + 9'd1;

                addr_gen_tx_fully_rst <= 1'b0;

                rd_req       <= 1'b1;

                tx_spe_case  <= 1'b1;

            end

            

        else begin

                nxt_state    <= tx_exit_st;

                rd_req       <= 1'b0;

        end 

  

        end  

//---------------------------------------------------------------------------------------------------------------------------

//tx entry 

//tx_entry_st is for tx entry. it will gegerate tx entry addr upto    

//TX_START_ADDR and it will move tx_exit_jmp_st once "addr_gen_read_start_d" become 

//low                                                               

//---------------------------------------------------------------------------------------------------------------------------            

        tx_entry_st:begin//5

            if(addr_gen_tx_rx_sel)begin

                inst_counter <= 0;

                nxt_state    <= comm_rsorc_st;

                rd_req       <= 1'b0;                

            end

            else if(tx_counter < TX_START_ADDR && (src_role_cfg[0] && addr_gen_initiator_instr_done && sl2l_fsm_all_targets_done))begin

                nxt_state             <= comm_rsorc_st;

                rd_req                <= 1'b0;

                tx_counter            <= TX_START_ADDR;

                tx_spe_case           <= 1'b0;

                addr_gen_tx_fully_rst <= 1'b1;

            end 

           else if(tx_counter < TX_START_ADDR && (!src_role_cfg[0]) && (sl2l_fsm_ready_or_desired_state_d || sl2l_fsm_ready_or_desired_state_d2|| abort_flag))begin//target //v0.51 , v1.55

                nxt_state             <= comm_rsorc_st;

                rd_req                <= 1'b0;

                tx_counter            <= TX_START_ADDR;

                rx_spe_case           <= 1'b0;

                addr_gen_tx_fully_rst <= 1'b1;

            end

            else if(addr_gen_abort_instr_d && inst_counter[1:0] != 2'b00)begin

                //inst_counter <= 0;

                nxt_state    <= tx_entry_st;

                rd_req       <= 1'b0;

                tx_counter   <= tx_counter + 9'd1;

            end

            

            else if(addr_gen_read_start_d)begin

                inst_counter <= inst_counter + 3'd1;

                nxt_state    <= tx_entry_st;

                tx_counter   <= tx_counter + 9'd1;

                rd_req       <= 1'b1;

            end 



        else if(inst_counter == 3'd3 || inst_counter == 3'd4)begin

                rd_req       <= 1'b0;

            tx_counter   <= tx_counter - 9'd8;

        inst_counter <= 3'd0;

        end

            

            else begin

                nxt_state    <=tx_entry_st ;

                rd_req       <= 1'b0;

            end 



        end 

//---------------------------------------------------------------------------------------------------------------------------

//rx exit

//rx_exit_st is for rx exit. it will gegerate rx exit addr upto     

//RX_LAST_ADDR and it will move rx_exit_jmp_st once "addr_gen_read_start_d" become 

//low                                                               

//---------------------------------------------------------------------------------------------------------------------------

        rx_exit_st:begin//6

        if(!addr_gen_tx_rx_sel)begin

                inst_counter <= 0;

                nxt_state    <= comm_rsorc_st;

                rd_req       <= 1'b0;                

            end

            else if(rx_counter > RX_LAST_ADDR && ((src_role_cfg[1] && addr_gen_initiator_instr_done && sl2l_fsm_all_targets_done) ||

        ((!src_role_cfg[1]) && (sl2l_fsm_ready_or_desired_state_d || sl2l_fsm_ready_or_desired_state_d2))))begin //v1.55

                nxt_state             <= comm_rsorc_st;

                rd_req                <= 1'b0;

                rx_counter            <= RX_LAST_ADDR - 9'd3;

                addr_gen_rx_fully_rst <= 1'b0;

                addr_gen_rx_fully_op  <= 1'b1;

            end 

             else if(addr_gen_tx_rx_sel && addr_gen_jump_to_rst_entry )begin//jump to rx reset entry //v1.52

                // nxt_state  <= rx_st;

                nxt_state  <= comm_rsorc_st;

                rx_counter <= RX_LAST_ADDR - 9'd3;

                addr_gen_rx_fully_op  <= 1'b0;

            end           

            else if(!addr_gen_read_start_d && addr_gen_rst_exit_entry_sel)begin

                inst_counter <= 0;

                nxt_state    <= comm_rsorc_st;

                rd_req       <= 1'b0;

            end

             

            else if(addr_gen_abort_instr_d && inst_counter[1:0] != 2'b00)begin

                inst_counter <= 0;

                nxt_state    <= rx_exit_st;

                rd_req       <= 1'b0;

                rx_counter   <= rx_counter + 9'd1;

                addr_gen_rx_fully_rst <= 1'b0;

            end 

            

            else if(addr_gen_read_start_d)begin

                inst_counter <= inst_counter + 3'd1;

                nxt_state    <= rx_exit_st;

                rx_counter   <= rx_counter + 9'd1;

                addr_gen_rx_fully_rst <= 1'b0;

                rd_req       <= 1'b1;

                rx_spe_case  <= 1'b1;

            end

            

        else begin

                nxt_state    <=rx_exit_st;

                rd_req       <= 1'b0;

        end

        end  

//---------------------------------------------------------------------------------------------------------------------------

//rx entry

//rx_entry_st is for rx entry. it will gegerate rx entry addr upto

//RX_START_ADDR and it will move rx_entry_jmp_st once "addr_gen_read_start_d" become low      

//---------------------------------------------------------------------------------------------------------------------------              

        rx_entry_st:begin//7

           if(!addr_gen_tx_rx_sel)begin

                inst_counter <= 0;

                nxt_state    <= comm_rsorc_st;

                rd_req       <= 1'b0;                

            end

            else if(rx_counter < RX_START_ADDR  && src_role_cfg[1] && addr_gen_initiator_instr_done && sl2l_fsm_all_targets_done)begin//initiator

                nxt_state             <= comm_rsorc_st;

                rd_req                <= 1'b0;

                rx_counter            <= RX_START_ADDR;

                rx_spe_case           <= 1'b0;

                addr_gen_rx_fully_rst <= 1'b1;

            end 

        else if(rx_counter < RX_START_ADDR && (!src_role_cfg[1]) && (sl2l_fsm_ready_or_desired_state_d || sl2l_fsm_ready_or_desired_state_d2 || abort_flag))begin//target v1.55

                nxt_state             <= comm_rsorc_st;

                rd_req                <= 1'b0;

                rx_counter            <= RX_START_ADDR;

                rx_spe_case           <= 1'b0;

                addr_gen_rx_fully_rst <= 1'b1;

            end 

            else if(addr_gen_abort_instr_d && inst_counter[1:0] != 2'b00)begin

                nxt_state    <= rx_entry_st;

                rd_req       <= 1'b0;

                rx_counter   <= rx_counter + 9'd1;
            end           

            else if(addr_gen_read_start_d)begin

                inst_counter <= inst_counter + 3'd1;

                nxt_state    <= rx_entry_st;

                rx_counter   <= rx_counter + 9'd1;
                rd_req       <= 1'b1;
            end

            else if(inst_counter == 3'd3 || inst_counter == 3'd4 )begin

                rd_req       <= 1'b0;

                rx_counter   <= rx_counter - 9'd8;

                inst_counter <= 3'd0;

            end

           else begin
 
                nxt_state    <=rx_entry_st;
        
                rd_req       <= 1'b0;

           end
       end 

//---------------------------------------------------------------------------------------------------------------------------       

//default case 

//---------------------------------------------------------------------------------------------------------------------------   

        default:begin 

             nxt_state  <= comm_rsorc_st;    

             rd_req     <= 1'b0;

            end

        endcase

    end

end

endmodule

//--------------------------------------------------------------------------------------------------------------------------

// Version             |  Changes                                                          | Date                 | Owner ID

//--------------------------------------------------------------------------------------------------------------------------

//   0.0               |                                                                   |                      | 

//   0.1               | Initial code                                                      |  13-Jun-2022         | sushilsh

//   0.2               | Optimized the cade and added four output ports                    |  29-Jun-2022         | sushilsh

//   0.3               | Added reordering of instructions                                  |  11-Jul-2022         | sushilsh

//   0.4               | Added read enb sync to read addr and remove once clcok latency.   |  12-Jul-2022         | sushilsh

//   0.5               | Added fully tx&rx rst status at out of common resource            |  15-Jul-2022         | sushilsh

//   0.6               | Added fix for tx exit                                             |  21-Jul-2022         | sushilsh

//   0.7               | Added fix for tx and rx entry                                     |  17-Aug-2022         | sushilsh 

//   0.8               | Added fix for tx and rx interleaving                              |  25-Aug-2022         | sushilsh 

//   0.9               | Added two more input port for interleaving                        |  30-Aug-2022         | sushilsh

//   1.0               | Added fix for jump issue                                          |  02-Sep-2022         | sushilsh

//   1.1               | Added fix for addr_gen_rx_fully_op                                |  07-Sep-2022         | sushilsh

//   1.2               | Added fix for addr_gen_tx_fully_op                                |  08-Sep-2022         | sushilsh

//   1.3               | Added fix for rx entry abort inst                                 |  09-Sep-2022         | sushilsh

//   1.4               | Added fix for incorrect clear of tx fully rst                     |  20-Oct-2022         | cvignesh

//   1.5               | Added fix for tx entry abort inst                                 |  13-Jan-2023         | cvignesh

//   1.51              | src_role_CFG bit checked incorrectly for TX                       |  13-Jan-2023         | skgr

//   1.52              | Jump to reset entry added in state 4 and state 6                  |  20-Jan-2023         | skgr

//   1.53              | Fix Jump to reset entry missed in common resource due to priority |  21-Jan-2023         | skgr
//   1.54              | Parameterize the address pointers and bring out as parameters     |  22-Feb-2023         | skgr
//   1.55              | Last instruction done missed when completed at intrlv_mon state   |  08-Mar-2023         | skgr
//   1.56              | RX fully operational after driving xcvrif_signal_ok in SRC Spec   |  03-Apr-2023         | skgr
//   1.58              | HSD:14019867282 PTP DL GB restart. Total instruction change in RX |  25-Sep-2023         | skgr
//--------------------------------------------------------------------------------------------------------------------------

