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


//==============================================================================
// (C) 2011-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
// $File: /data/jbharatk/softip/acds/main/regtest/ip/ethernet/alt_ethernet/testbench/uvc/agent $
// $Revision: #1 $
// $Date: 2017/8/9 $
// $Author: jbharatk $
//==============================================================================
`ifndef VECTOR_UVC_SCOREBOARD__SV
`define VECTOR_UVC_SCOREBOARD__SV

//==============================================================================
// Class: vector_uvc_scoreboard
// This vector scoreboard checks expected & actual transaction for vector status data & error 
//==============================================================================
class vector_uvc_scoreboard extends uvm_scoreboard;
  int pass_pkt=0;
  int fail_pkt=0;
  int mismatch_cnt=0;
  int no_pkt=0;
  int tx_pkt_cnt=0;
  int rx_pkt_cnt=0;
  vector_uvc_packet q_tx[$]; //Vector transaction queue
  vector_uvc_packet pause_q_tx[$]; //Vector transaction queue
  vector_uvc_packet q_rx[$]; //Vector transaction queue
  vector_uvc_packet pause_q_rx[$]; //Vector transaction queue
  vector_uvc_packet tx_pkt_f;
  vector_uvc_packet rx_pkt_f;
  vector_uvc_packet temp_packet;
  vector_uvc_packet temp_rx_pkt;
  int ignore_id;
  string sb_inst;
  bit sb_enable=1;
  bit flag = 0;
  int i,crc_match;
  semaphore  compare_sem;
  bit vector_sb_check_dis[string];
  dyn_rcfg dyn_rcfg_obj_inst;

 /*If pointer*/
  typedef virtual spy_interface v_if2; 
  v_if2 spy_if;

  //Implementation port for actual & expected transaction
  `uvm_analysis_imp_decl(_tx)
   uvm_analysis_imp_tx #(vector_uvc_packet,vector_uvc_scoreboard) before_export;
  `uvm_analysis_imp_decl(_rx)
   uvm_analysis_imp_rx #(vector_uvc_packet,vector_uvc_scoreboard) after_export;

  `uvm_component_utils(vector_uvc_scoreboard)
	extern function new(string name = "vector_uvc_scoreboard", uvm_component parent = null); 
	extern virtual function void build_phase (uvm_phase phase);
	extern virtual function void connect_phase (uvm_phase phase);
	extern virtual task run_phase (uvm_phase phase);
	extern virtual function void write_tx (input vector_uvc_packet tx_pkt);
	extern virtual function void write_rx (input vector_uvc_packet rx_pkt);
	extern virtual task compare_pkt (input bit fc_pkt);
	extern virtual function void flush();
	extern virtual function void report_phase(uvm_phase phase);
	extern virtual function void check_phase(uvm_phase phase);

endclass: vector_uvc_scoreboard


//==============================================================================
// Function: new
//==============================================================================
function vector_uvc_scoreboard::new(string name = "vector_uvc_scoreboard",uvm_component parent);
   super.new(name,parent);
   compare_sem = new(1);
endfunction: new

//==============================================================================
// Function: build_phase
//==============================================================================
function void vector_uvc_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    before_export = new("before_export", this);
    after_export  = new("after_export", this);
    if (!uvm_config_db#()::get(this,"","VECTOR_SB_ENABLE", sb_enable)) begin
      `uvm_info("@Vector_SB","Vector Scoreboard is enable",UVM_MEDIUM);
    end
    // getting spy_if 
    uvm_config_db#(v_if2)::get(this, "", "spy_interface", spy_if);
    if (spy_if == null)  `uvm_fatal("NO_CONN", "spy if port not connected to the actual interface instance");

    if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
       `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
    end

   
endfunction:build_phase

//==============================================================================
// Function: connect_phase
//==============================================================================
function void vector_uvc_scoreboard::connect_phase(uvm_phase phase);
endfunction:connect_phase

//==============================================================================
// Function: run_phase
//==============================================================================
task vector_uvc_scoreboard::run_phase(uvm_phase phase);

forever begin

  fork 
   begin
     @(sb_enable)
     flush();
     flag = 1'b1;
   end
   begin
     wait(q_tx.size>0 && q_rx.size>0);
     temp_rx_pkt=q_rx[0];
      if(flag) 
      begin
        if(q_tx.size>0)
	begin
        i = 0;
        crc_match = 0;
        while(i<q_tx.size && !crc_match)
	begin
          temp_packet=q_tx[i];
          if(temp_packet.status_data==temp_rx_pkt.status_data)
	  begin
            crc_match=1;
            flag=0;
            q_tx=q_tx[i:$];
            `uvm_info(get_full_name(),$sformatf("SCB was disabled i=%0d flag=%0d q_tx.size=%0d",i,flag,q_tx.size),UVM_MEDIUM);
            //in skew tests, DUT can generate spurious frames. Check that they are
            //flagged as malformed/crc_error before dropping from comparison
            if((dyn_rcfg_obj_inst.skew_test == 1) && ( (temp_rx_pkt.status_error[0]== 1) || (temp_rx_pkt.status_error[1]== 1)))  
            begin
              `uvm_info(get_full_name(),$sformatf("skew test:%0d, malformed :%0d /fcs error frame received:%0d dropped from comparison",dyn_rcfg_obj_inst.skew_test, temp_rx_pkt.status_error[0], temp_rx_pkt.status_error[1]),UVM_MEDIUM);
            end//skew
            else 
            begin
              //dont count spurious frames that wont be compared
              //rx_pkt_cnt++; //Count packet rx
              `uvm_info(get_full_name(),$sformatf("RX:VECTOR_SCB:RX PKT CNT=%0d",rx_pkt_cnt),UVM_MEDIUM);
              //fork
                compare_pkt(0);
              //join_none
            end//compare_pkt
          end//temp_packet
          i++;
        end//while
        if(!crc_match) 
        begin
          #1; // In case tx packet is late this #1 delay will ensure less loops of while for code efficiency
          `uvm_info(get_full_name(),$sformatf("partial pkt received,ignoring it.crc_match: %b",crc_match),UVM_HIGH);
        end
      end//q_tx.size
    end//flag
    else
    begin
      if((dyn_rcfg_obj_inst.skew_test == 1) && ( (temp_rx_pkt.status_error[0]== 1) || (temp_rx_pkt.status_error[1]== 1)))  
            begin
        `uvm_info(get_full_name(),$sformatf("skew test:%0d, malformed :%0d /fcs error frame received:%0d dropped from comparison",dyn_rcfg_obj_inst.skew_test, temp_rx_pkt.status_error[0],temp_rx_pkt.status_error[1]),UVM_MEDIUM);
            end
      else 
            begin
        //fork
          compare_pkt(0);
        //join_none
      end
    end
   end 
   begin
     wait(pause_q_tx.size>0 && pause_q_rx.size>0);
     $display("control thread entered in vector scb");
     compare_pkt(1);
   end
   join_any
   disable fork;
 end //forever
endtask

//==============================================================================
// Function: write_tx
// Write function for TX transaction 
//==============================================================================
function void vector_uvc_scoreboard::write_tx(input vector_uvc_packet tx_pkt);
  vector_uvc_packet tx_pkt_clone;
  `uvm_info(get_full_name(),$sformatf("SCB disabled=%0d",sb_enable),UVM_MEDIUM);
   if(spy_if.o_rx_hi_ber ==1'b1)
    begin 
     `uvm_info(get_full_name(),$sformatf(" hiber is asserted, so  TX packet should be dropped hi_ber=%0d ",spy_if.o_rx_hi_ber ==1'b1),UVM_MEDIUM);
     return;
    end
  if(sb_enable == 1 && (dyn_rcfg_obj_inst.mode inside {PCSMAC,MACSEG})) begin
    `uvm_info(get_full_name(),$sformatf("TX:VECTOR_SCB:Received pkt from monitor at %0t",$time),UVM_MEDIUM);
    `uvm_info(get_full_name(),$sformatf("TX:VECTOR_SCB:PACKET %s",tx_pkt.sprint()),UVM_MEDIUM);    
    //Making a copy of tx packet 
    $cast(tx_pkt_clone,tx_pkt.clone());
    //tx_pkt_clone.print; //Print transaction
    
//    `ifdef G100
    //create seperate queue for control frame
    if(tx_pkt_clone.status_data[34] == 1 || tx_pkt_clone.status_data[35] == 1) begin
          pause_q_tx.push_back(tx_pkt_clone); //push transaction in queue
    end
    else begin
          q_tx.push_back(tx_pkt_clone); //push transaction in queue
    end
    // `elsif G50
    // //create seperate queue for control frame
    // if(tx_pkt_clone.status_data[34] == 1) begin
    //       pause_q_tx.push_back(tx_pkt_clone); //push transaction in queue
    // end
    // else begin
    //       q_tx.push_back(tx_pkt_clone); //push transaction in queue
    // end    
    // `elsif G40
    // //create seperate queue for control frame
    // if(tx_pkt_clone.status_data[34] == 1) begin
    //       pause_q_tx.push_back(tx_pkt_clone); //push transaction in queue
    // end
    // else begin
    //       q_tx.push_back(tx_pkt_clone); //push transaction in queue
    // end
    // `else //for G10 and G25
    //       q_tx.push_back(tx_pkt_clone); //push transaction in queue
    // `endif
    
    `uvm_info(get_full_name(),$sformatf("TX:VECTOR_SCB:q_tx size=%0d",q_tx.size),UVM_MEDIUM);
    `uvm_info(get_full_name(),$sformatf("TX:VECTOR_SCB:pause_q_tx size=%0d",q_tx.size),UVM_MEDIUM);
    tx_pkt_cnt++; //Count packet tx
    `uvm_info(get_full_name(),$sformatf("TX:VECTOR_SCB:TX PKT CNT=%0d",tx_pkt_cnt),UVM_MEDIUM);
  end
endfunction: write_tx 

//==============================================================================
// Function: write_rx
// Write function for RX transaction 
//==============================================================================
function void vector_uvc_scoreboard::write_rx(input vector_uvc_packet rx_pkt);
  vector_uvc_packet rx_pkt_clone;
  `uvm_info(get_full_name(),$sformatf("SCB disabled=%0d flag=%0d q_tx.size=%0d",sb_enable,flag,q_tx.size),UVM_MEDIUM);
  if(spy_if.o_rx_hi_ber ==1'b1)
    begin 
     `uvm_info(get_full_name(),$sformatf(" hiber is asserted, so RX packet should be dropped hi_ber=%0d ",spy_if.o_rx_hi_ber ==1'b1),UVM_MEDIUM);
     return;
    end
  if(sb_enable == 1 && (dyn_rcfg_obj_inst.mode inside {PCSMAC,MACSEG})) begin
    `uvm_info(get_full_name(),$sformatf("RX:VECTOR_SCB:Received pkt from monitor at %0t",$time),UVM_MEDIUM);
    //Making a copy of received transaction
    $cast(rx_pkt_clone,rx_pkt.clone()); 
    //rx_pkt_clone.print; //Print transaction
    if(rx_pkt_clone.status_data[34] == 1 || rx_pkt_clone.status_data[35] == 1 ) begin
          pause_q_rx.push_back(rx_pkt_clone); //push transaction in queue
    end
    else begin
          q_rx.push_back(rx_pkt_clone); //push transaction in queue
    end
    `uvm_info(get_full_name(),$sformatf("RX:VECTOR_SCB:q_rx size=%0d",q_rx.size),UVM_MEDIUM);
    `uvm_info(get_full_name(),$sformatf("RX:VECTOR_SCB:pause_q_rx size=%0d",pause_q_rx.size),UVM_MEDIUM);
    rx_pkt_cnt++; //Count packet rx
    `uvm_info(get_full_name(),$sformatf("RX:VECTOR_SCB:RX PKT CNT=%0d",rx_pkt_cnt),UVM_MEDIUM);
  end//scb_enable
endfunction: write_rx

//  if(sb_enable) begin
//    `uvm_info(get_full_name(),$sformatf("RX:VECTOR_SCB:Received pkt from monitor at %0t",$time),UVM_MEDIUM);
//    //Making a copy of received transaction
//    $cast(rx_pkt_clone,rx_pkt.clone()); 
//    //rx_pkt_clone.print; //Print transaction
//    //in skew tests, DUT can generate spurious frames. Check that they are
//    //flagged as malformed/crc_error before dropping from comparison
//    if( (tb_cfg.skew_test == 1) && ( (rx_pkt_clone.status_error[0]== 1) || (rx_pkt_clone.status_error[1]== 1)))  begin
//      uvm_report_info("RX:VECTOR_SCB",$psprintf("skew test:%0d, malformed :%0d /fcs error frame received:%0d dropped from comparison ",tb_cfg.skew_test, rx_pkt_clone.status_error[0], rx_pkt_clone.status_error[1]),UVM_LOW);
//    end
//    else begin
//    rx_pkt_cnt++; //Count packet rx
//    `uvm_info(get_full_name(),$sformatf("RX:VECTOR_SCB:RX PKT CNT=%0d",rx_pkt_cnt),UVM_MEDIUM);
//      fork
//        compare_pkt(rx_pkt_clone);
//      join_none
//    end
//  end
//endfunction: write_rx 

task vector_uvc_scoreboard::compare_pkt(bit fc_pkt);
 `uvm_info(get_full_name(),"VECTOR_SCB:In compare task",UVM_MEDIUM);
  mismatch_cnt=0;
  compare_sem.get(1);
  
//    `ifdef DR
     if(fc_pkt == 1) begin
       tx_pkt_f=pause_q_tx.pop_front;
       rx_pkt_f=pause_q_rx.pop_front;
     end
     else begin
       tx_pkt_f=q_tx.pop_front;
       rx_pkt_f=q_rx.pop_front;
     end
    // if(q_rx.status_data[34] == 1) begin
    //      if(pause_q_tx.size==0) begin
    //           wait(pause_q_tx.size > 0);
    //      end 
    //      tx_pkt_f=pause_q_tx.pop_front;
    // end
    // else begin
    //      if(q_tx.size==0) begin
    //           wait(q_tx.size > 0);
    //      end 
    //      tx_pkt_f=q_tx.pop_front;
    // end
    // `elsif G100  
    //  if(rx_pkt.status_data[34] == 1) begin
    //       if(pause_q_tx.size==0) begin
    //            wait(pause_q_tx.size > 0);
    //       end 
    //       tx_pkt_f=pause_q_tx.pop_front;
    //  end
    //  else begin
    //       if(q_tx.size==0) begin
    //            wait(q_tx.size > 0);
    //       end 
    //       tx_pkt_f=q_tx.pop_front;
    //  end
    // `elsif G50
    //  if(rx_pkt.status_data[34] == 1) begin
    //       if(pause_q_tx.size==0) begin
    //            wait(pause_q_tx.size > 0);
    //       end 
    //       tx_pkt_f=pause_q_tx.pop_front;
    //  end
    //  else begin
    //       if(q_tx.size==0) begin
    //            wait(q_tx.size > 0);
    //       end 
    //       tx_pkt_f=q_tx.pop_front;
    //  end 
    // `elsif G40
    //  if(rx_pkt.status_data[34] == 1) begin
    //       if(pause_q_tx.size==0) begin
    //            wait(pause_q_tx.size > 0);
    //       end 
    //       tx_pkt_f=pause_q_tx.pop_front;
    //  end
    //  else begin
    //       if(q_tx.size==0) begin
    //            wait(q_tx.size > 0);
    //       end 
    //       tx_pkt_f=q_tx.pop_front;
    //  end
    // `else //for G10 and G25
    //       tx_pkt_f=q_tx.pop_front;
    // `endif
    
//  if(q_tx.size==0) 
//  begin 
//    `uvm_fatal("VECTOR_UVC_SB", "No tx packet while rx has arrived"); 
//  end
//  else 
//  begin
//    tx_pkt_f=q_tx.pop_front;
//  end
   
  `uvm_info(get_full_name(),$sformatf("VECTOR_SCB:TX PACKET %s",tx_pkt_f.sprint()),UVM_MEDIUM);
   `uvm_info(get_full_name(),$sformatf("VECTOR_SCB:RX PACKET %s",rx_pkt_f.sprint()),UVM_MEDIUM);
  
  
  no_pkt++;
  `uvm_info(get_full_name(),$sformatf("Number_of_packets=%0h",no_pkt),UVM_MEDIUM);
  `ifndef ETH_MULTI_PORT 
    if(!(tx_pkt_f.status_error[0]) && !(tx_pkt_f.status_error[6])) begin //LL10g error packets payload and frame size need not to be checked
  `else
    if(!(tx_pkt_f.status_error[0])) begin
  `endif
     //Payload Size
     if(vector_sb_check_dis["PAYLOAD_SIZE"] == 0) begin
          if(tx_pkt_f.status_data[15:0]==rx_pkt_f.status_data[15:0]) begin
               `uvm_info(get_full_name(),$sformatf("Payload Size Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[15:0],rx_pkt_f.status_data[15:0]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("Payload Size Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[15:0],rx_pkt_f.status_data[15:0]));
               mismatch_cnt++;
          end
     end
 
     //Frame Size
     if(vector_sb_check_dis["FRAME_SIZE"] == 0) begin
          if(tx_pkt_f.status_data[31:16]==rx_pkt_f.status_data[31:16]) begin
               `uvm_info(get_full_name(),$sformatf("Frame size Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[31:16],rx_pkt_f.status_data[31:16]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("Frame size Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[31:16],rx_pkt_f.status_data[31:16]));
               mismatch_cnt++;
          end 
     end
     
     if(vector_sb_check_dis["SVLAN_FRAME"] == 0) begin
          //STACKED VLAN Frame
          if(tx_pkt_f.status_data[33]==rx_pkt_f.status_data[33]) begin
               `uvm_info(get_full_name(),$sformatf("STACKED VLAN Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[33],rx_pkt_f.status_data[33]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("STACKED VLAN Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[33],rx_pkt_f.status_data[33]));
               mismatch_cnt++;
          end 
     end
     
     if(vector_sb_check_dis["VLAN_FRAME"] == 0) begin
          //VLAN Frame
          if(tx_pkt_f.status_data[33]==rx_pkt_f.status_data[33]) begin
               `uvm_info(get_full_name(),$sformatf("R VLAN Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[33],rx_pkt_f.status_data[33]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("R VLAN Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[33],rx_pkt_f.status_data[33]));
               mismatch_cnt++;
          end 
     end
     
     if(vector_sb_check_dis["CTRL_FRAME"] == 0) begin
          //CONTROL Frame
          if(tx_pkt_f.status_data[34]==rx_pkt_f.status_data[34]) begin
               `uvm_info(get_full_name(),$sformatf("CONTROL FRAME Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[34],rx_pkt_f.status_data[34]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("CONTROL FRAME Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[34],rx_pkt_f.status_data[34]));
               mismatch_cnt++;
          end 
     end
     
     if(vector_sb_check_dis["PAUSE_FRAME"] == 0) begin
          //PAUSE Frame
          if(tx_pkt_f.status_data[35]==rx_pkt_f.status_data[35]) begin
               `uvm_info(get_full_name(),$sformatf("PAUSE FRAME Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[35],rx_pkt_f.status_data[35]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("PAUSE FRAME Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[35],rx_pkt_f.status_data[35]));
               mismatch_cnt++;
          end 
     end

     if(vector_sb_check_dis["BCAST_FRAME"] == 0) begin
          //BRAODCAST Frame
          if(tx_pkt_f.status_data[36]==rx_pkt_f.status_data[36]) begin
               `uvm_info(get_full_name(),$sformatf("BRAODCAST FRAME Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[36],rx_pkt_f.status_data[36]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("BRAODCAST FRAME Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[36],rx_pkt_f.status_data[36]));
               mismatch_cnt++;
          end 
     end
     
     if(vector_sb_check_dis["MCAST_FRAME"] == 0) begin
          //MULTICAST Frame
          if(tx_pkt_f.status_data[37]==rx_pkt_f.status_data[37]) begin
               `uvm_info(get_full_name(),$sformatf("MULTICAST FRAME Match:Expected Status Data=%h, Actual Status Data=%h",tx_pkt_f.status_data[37],rx_pkt_f.status_data[37]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("MULTICAST FRAME Mismatch:Expected Status Data=%h, Actual Status Data=%h",tx_pkt_f.status_data[37],rx_pkt_f.status_data[37]));
               mismatch_cnt++;
          end 
               
     end
     
     if(vector_sb_check_dis["UNICAST_FRAME"] == 0) begin
          //UNICAST Frame
          if(tx_pkt_f.status_data[38]==rx_pkt_f.status_data[38]) begin
               `uvm_info(get_full_name(),$sformatf("UNICAST FRAME Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[38],rx_pkt_f.status_data[38]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("UNICAST FRAME Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[38],rx_pkt_f.status_data[38]));
               mismatch_cnt++;
          end 
     end
     
     if(vector_sb_check_dis["PFC_FRAME"] == 0) begin
          //FLOWCONTROL Frame
          if(tx_pkt_f.status_data[39]==rx_pkt_f.status_data[39]) begin
               `uvm_info(get_full_name(),$sformatf("ETYPE NONFC FRAME Match:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[39],rx_pkt_f.status_data[39]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("ETYPE NONFC FRAME Mismatch:Expected Status Data=%0h, Actual Status Data=%0h",tx_pkt_f.status_data[39],rx_pkt_f.status_data[39]));
               mismatch_cnt++;
          end 
          
     end
  end
  
  sb_inst = get_name();
  if(sb_inst == "sb_vec_mac_tx_vip_rx") begin
  
     if(vector_sb_check_dis["TX_UNDERSIZED_ERROR"] == 0) begin     
          //unused bit-0 check
          if(tx_pkt_f.status_error[0]==rx_pkt_f.status_error[0]) begin
               `uvm_info(get_full_name(),$sformatf("TX_UNDERSIZED_ERROR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[0],rx_pkt_f.status_error[0]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("TX_UNDERSIZED_ERROR Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[0],rx_pkt_f.status_error[0]));
               mismatch_cnt++;
          end
     end    

     if(vector_sb_check_dis["TX_OVERSIZED_ERROR"] == 0) begin
          //CRC Error 
          if(tx_pkt_f.status_error[1]==rx_pkt_f.status_error[1]) begin
               `uvm_info(get_full_name(),$sformatf("TX_OVERSIZED ERROR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[1],rx_pkt_f.status_error[1]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("TX_OVERSIZED ERROR Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[1],rx_pkt_f.status_error[1]));
               mismatch_cnt++;
          end 
     end

     if(vector_sb_check_dis["TX_LEN_ERR"] == 0) begin
          //LENGTH Error
          if(tx_pkt_f.status_error[2]==rx_pkt_f.status_error[2]) begin
               `uvm_info(get_full_name(),$sformatf("LENGTH ERROR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[2],rx_pkt_f.status_error[2]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("LENGTH ERROR Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[2],rx_pkt_f.status_error[2]));
               mismatch_cnt++;
          end 
     end     
     
     if(vector_sb_check_dis["TX_UNUSED_3"] == 0) begin
          //unused bit-3 check
          if(tx_pkt_f.status_error[3]==rx_pkt_f.status_error[3]) begin
               `uvm_info(get_full_name(),$sformatf("UNUSED BIT-3 Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[3],rx_pkt_f.status_error[3]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("UNUSED BIT-3 Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[3],rx_pkt_f.status_error[3]));
               mismatch_cnt++;
          end
     end
     
     if(vector_sb_check_dis["TX_UNDERFLOW_ERROR_STATUS"] == 0) begin
          //unused bit-4 check
          if(tx_pkt_f.status_error[4]==rx_pkt_f.status_error[4]) begin
               `uvm_info(get_full_name(),$sformatf("TX UNDERFLOW_ERROR_STATUS Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[4],rx_pkt_f.status_error[4]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("TX UNDERFLOW_ERROR_STATUS Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[4],rx_pkt_f.status_error[4]));
               mismatch_cnt++;
          end
     end
     
     if(vector_sb_check_dis["TX_CLIENT_ERROR"] == 0) begin
          //unused bit-5 check
          if(tx_pkt_f.status_error[5]==rx_pkt_f.status_error[5]) begin
               `uvm_info(get_full_name(),$sformatf("TX CLIENT ERROR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[5],rx_pkt_f.status_error[5]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("TX CLIENT ERROR BIT-5 Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[5],rx_pkt_f.status_error[5]));
               mismatch_cnt++;
          end
     end
     
     if(vector_sb_check_dis["TX_UNUSED_6"] == 0) begin
          //unused bit-6 check
          if(tx_pkt_f.status_error[6]==rx_pkt_f.status_error[6]) begin
               `uvm_info(get_full_name(),$sformatf("UNUSED BIT-6 Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[6],rx_pkt_f.status_error[6]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("UNUSED BIT-6 Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[6],rx_pkt_f.status_error[6]));
               mismatch_cnt++;
          end
          
     end
  end//sb_vec_mac_tx_vip_rx

  if(sb_inst == "sb_vec_vip_tx_mac_rx") begin
  
     if(vector_sb_check_dis["UNDERSIZE_ERR"] == 0) begin
          //PHY Error
          if(tx_pkt_f.status_error[0]==rx_pkt_f.status_error[0]) begin
               `uvm_info(get_full_name(),$sformatf("UNDERSIZE ERROR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[0],rx_pkt_f.status_error[0]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("UNDERSIZE ERROR Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[0],rx_pkt_f.status_error[0]));
               mismatch_cnt++;
          end 
     end
     
     if(vector_sb_check_dis["OVERSIZE_ERR"] == 0) begin
          //CRC Error
          if(tx_pkt_f.status_error[1]==rx_pkt_f.status_error[1]) begin
               `uvm_info(get_full_name(),$sformatf("OVERSIZE  ERROR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[1],rx_pkt_f.status_error[1]),UVM_MEDIUM);
          end
          else begin
               `uvm_error(get_full_name(),$sformatf("OVERSIZE ERROR Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[1],rx_pkt_f.status_error[1]));
               mismatch_cnt++;
          end 
     end
     
     if(!tx_pkt_f.status_error[6]) begin //not malformed
       //if (dyn_rcfg_obj_inst.speed==_50G) begin
          //UNDERSIZE Error FIXME : temporary removing this check for 100G. We need to remove this define after FB : 580334          
	  //CHK_GDR : this FB: 580334 is for old C2 project, so below checking mechanism is enabled for all speeds.
          if(vector_sb_check_dis["RX_LEN_ERR"] == 0) begin
               if(tx_pkt_f.status_error[2]==rx_pkt_f.status_error[2]) begin
                    `uvm_info(get_full_name(),$sformatf("LENGTH ERROR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[2],rx_pkt_f.status_error[2]),UVM_MEDIUM);
               end
               else begin
                    `uvm_error(get_full_name(),$sformatf("LENGTH ERROR Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[2],rx_pkt_f.status_error[2]));
                    mismatch_cnt++;
               end 
          end

          if(vector_sb_check_dis["RX_CRC_ERR"] == 0) begin
               if(tx_pkt_f.status_error[3]==rx_pkt_f.status_error[3]) begin
                    `uvm_info(get_full_name(),$sformatf("CRC ERROR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[3],rx_pkt_f.status_error[3]),UVM_MEDIUM);
               end
               else begin
                    `uvm_error(get_full_name(),$sformatf("CRC ERROR Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[3],rx_pkt_f.status_error[3]));
                    mismatch_cnt++;
               end
          end
       //end//_50G
          
          
          if(vector_sb_check_dis["RX_UNUSED_4"] == 0) begin
               //LENGTH Error
               if(tx_pkt_f.status_error[4]==rx_pkt_f.status_error[4]) begin
                    `uvm_info(get_full_name(),$sformatf("RX UNUSED BIT 4 Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[4],rx_pkt_f.status_error[4]),UVM_MEDIUM);
               end
               else begin
                    `uvm_error(get_full_name(),$sformatf("RX UNUSED BIT 4 Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[4],rx_pkt_f.status_error[4]));
                    mismatch_cnt++;
               end
          end
          
          if(vector_sb_check_dis["RX_UNUSED_5"] == 0) begin
               //unused bit-5 check
               if(tx_pkt_f.status_error[5]==rx_pkt_f.status_error[5]) begin
                    `uvm_info(get_full_name(),$sformatf("UNUSED BIT-5 Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[5],rx_pkt_f.status_error[5]),UVM_MEDIUM);
               end
               else begin
                    `uvm_error(get_full_name(),$sformatf("UNUSED BIT-5 Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[5],rx_pkt_f.status_error[5]));
                    mismatch_cnt++;
               end
          end    
          if(vector_sb_check_dis["RX_PHY_ERR"] == 0) begin
               //unused bit-5 check
               if(tx_pkt_f.status_error[6]==rx_pkt_f.status_error[6]) begin
                    `uvm_info(get_full_name(),$sformatf("PHY ERR Match:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[6],rx_pkt_f.status_error[6]),UVM_MEDIUM);
               end
               else begin
                    `uvm_error(get_full_name(),$sformatf("PHY ERR Mismatch:Expected Status Error=%0h, Actual Status Error=%0h",tx_pkt_f.status_error[6],rx_pkt_f.status_error[6]));
                    mismatch_cnt++;
               end
          end    
     end//(!tx_pkt_f.status_error[0])
    
  end//sb_vec_vip_tx_mac_rx
  
  if(mismatch_cnt==0) begin
	  pass_pkt++;
	  `uvm_info(get_full_name(),$sformatf("PACKET %0d pass",no_pkt),UVM_MEDIUM);
  end
  else begin
	  fail_pkt++; 
	  `uvm_error(get_full_name(),$sformatf("Packet no %0d failed with %0d errors",no_pkt,mismatch_cnt));
  end
  mismatch_cnt=0; 
  compare_sem.put(1);
endtask: compare_pkt 

function void vector_uvc_scoreboard::flush();//modified
   string func_name = "flush";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
   
  uvm_report_info(get_name(),$psprintf("Before flushing "),UVM_HIGH);
  uvm_report_info(get_name(),$psprintf("q_tx size=%d q_rx size=%d",q_tx.size,q_rx.size),UVM_HIGH);
  uvm_report_info(get_name(),$psprintf("tx_pkt_cnt=%d rx_pkt_cnt=%d",tx_pkt_cnt,rx_pkt_cnt),UVM_HIGH);
  uvm_report_info(get_name(),$psprintf("pause_q_tx size=%d pause_q_rx size=%d",pause_q_tx.size,pause_q_rx.size),UVM_HIGH);
  tx_pkt_cnt=tx_pkt_cnt-q_tx.size();
  rx_pkt_cnt=rx_pkt_cnt-q_rx.size();
  q_tx={};
  q_rx={};
  pause_q_tx={};
  pause_q_rx={};
  uvm_report_info(get_name(),$psprintf("tx & rx queue flushed"),UVM_LOW);
  uvm_report_info(get_name(),$psprintf("q_tx size=%d q_rx size=%d",q_tx.size,q_rx.size),UVM_LOW);
  uvm_report_info(get_name(),$psprintf("tx_pkt_cnt=%d rx_pkt_cnt=%d",tx_pkt_cnt,rx_pkt_cnt),UVM_LOW);
  uvm_report_info(get_name(),$psprintf("pause_q_tx size=%d pause_q_rx size=%d",pause_q_tx.size,pause_q_rx.size),UVM_LOW);
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW);
endfunction

function void vector_uvc_scoreboard::report_phase(uvm_phase phase);
    super.report_phase(phase);
   // if(tx_arrived)  `uvm_info("SBRPT", $sformatf("No RX packet for TX,tx_arrived=%0d",tx_arrived),UVM_LOW);
    `uvm_info(get_full_name(), "===================================VECTOR SCOREBOARD REPORT FOR THIS RUN =================================\n",UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("TOTAL PACKETS COMPARED:%0d,TX PACKETS= %0d,RX PACKETS=%0d,PACKETS PASS = %0d, PACKETS FAIL = %0d",no_pkt,tx_pkt_cnt,rx_pkt_cnt,pass_pkt,fail_pkt),UVM_LOW);
endfunction:report_phase

function void vector_uvc_scoreboard::check_phase(uvm_phase phase);
    super.check_phase(phase);
       if(q_tx.size) `uvm_error(get_full_name(),$sformatf("%0d More TX Packets received than RX",q_tx.size()));
       if(pause_q_tx.size) `uvm_error(get_full_name(),$sformatf("%0d More Control TX Packets received than RX",pause_q_tx.size()));
       if(rx_pkt_cnt > tx_pkt_cnt && (dyn_rcfg_obj_inst.skew_test == 0)) `uvm_error(get_full_name(),$sformatf("%0d More RX Packets received than TX",(rx_pkt_cnt-tx_pkt_cnt)));
endfunction:check_phase

`endif // VECTOR_UVC_SCOREBOARD__SV
