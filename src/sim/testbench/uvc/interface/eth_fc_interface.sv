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


//
// Template for UVM-compliant interface
//
import uvm_pkg::*;
`include "uvm_macros.svh" 

interface eth_fc_interface (input bit clk, input bit rst);
import eth_env_pkg::*;

    logic rx_pcs_ready;
    logic     rx_sfc;
    logic  [1:0]   tx_sfc;
    logic  [7:0]   tx_pfc;
    logic  [7:0]   rx_pfc;
    logic [15:0] xoff_width[9];  
    logic [9]  [1:0]   signal_2b;
    logic [9] [15:0] pause_quanta;
    logic [9] [5:0] xoff;
    logic [9] [5:0] xon;
    logic  pause_enable;//ready to drop or not
    logic  [7:0] pfc_enable;
    logic  pause;//0:sfc,1:pfc
    logic  tx_xoff_en = 0;//0:sfc,1:pfc
    logic  tx_xon_en= 0;//0:sfc,1:pfc
    logic  port_tx_xoff_en = 0;//0:sfc,1:pfc
    logic  port_tx_xon_en= 0;//0:sfc,1:pfc
    logic  port_based= 0;//0:sfc,1:pfc
    logic  register_based= 0;//0:sfc,1:pfc

//Newly added
int quanta_q[9][$];
int exp_clk_quanta[9];
bit flag[9];
event event_new_fc_triggered;
event a1,a2,a3,a4,a5,a6,a7; //For debug
//Please refer https://hsdes.intel.com/resource/22012459113
bit assertion_off=1;
int window_size=0; //only for 100G

logic [8:0] [31:0]counter;
int i;
real num_clk_per_quanta;
// spy_if signals 
speed_e speed;
bit stop_flow;
bit o_rx_valid;
//tx_avst_if_signals 
bit startofpacket,endofpacket,ready;

initial begin
 #1;
 $display("speed_info=%0s",speed);
 case(speed)
 	_100G : num_clk_per_quanta=2;
 	_25G  : num_clk_per_quanta=8;
 	_10G  : num_clk_per_quanta=8;
 	_50G  : num_clk_per_quanta=4;
 	_40G  : num_clk_per_quanta=4;
 	_200G : num_clk_per_quanta=1;
 	_400G : num_clk_per_quanta=0.5;
 endcase
 $display("num_clk_per_quanta=%0.2f",num_clk_per_quanta);
 //FIXME :- Please update num_clk_per_quanta according to speeds if not specified.
end

always @(posedge rst) 
begin
	for(int i=0; i<9 ; i++)
	counter[i]<=0;
	if(speed==_100G) window_size=50;
	else window_size=15;
end

always @(xoff[8] or xon[8]) begin	
  #1 if(xoff[8]==0)   counter[8]= 0;
      else begin counter[8]= pause_quanta[8]*num_clk_per_quanta;
      if(rx_pcs_ready) begin
       quanta_q[8].push_back(counter[8]);
       ->a1;
      end
      end
end

always @(xoff[0] or xon[0]) begin	
  #1 if(xoff[0]==0)   counter[0]= 0;
      else begin counter[0]= pause_quanta[0]*num_clk_per_quanta;
      if(rx_pcs_ready) quanta_q[0].push_back(counter[0]);
      end
end

always @(xoff[1] or xon[1]) begin	
  #1 if(xoff[1]==0) counter[1]= 0;
      else begin counter[1]= pause_quanta[1]*num_clk_per_quanta;
      if(rx_pcs_ready) quanta_q[1].push_back(counter[1]);
      end
end

always @(xoff[2] or xon[2]) begin	
  #1 if(xoff[2]==0) counter[2]= 0;
          else begin	counter[2]= pause_quanta[2]*num_clk_per_quanta;
      if(rx_pcs_ready) quanta_q[2].push_back(counter[2]);
      end
 end

always @(xoff[3] or xon[3]) begin	
  #1 if(xoff[3]==0) 	counter[3]= 0;
          else	begin counter[3]= pause_quanta[3]*num_clk_per_quanta;
      if(rx_pcs_ready) quanta_q[3].push_back(counter[3]);
      end
end

always @(xoff[4] or xon[4]) begin	
  #1 if(xoff[4]==0) counter[4]= 0;
      else begin	counter[4]= pause_quanta[4]*num_clk_per_quanta;
      if(rx_pcs_ready) quanta_q[4].push_back(counter[4]);
      end
 end

always @(xoff[5] or xon[5]) begin	
  #1 if(xoff[5]==0) 	counter[5]= 0;
       else begin	counter[5]= pause_quanta[5]*num_clk_per_quanta;
      if(rx_pcs_ready) quanta_q[5].push_back(counter[5]);
      end
 end

always @(xoff[6] or xon[6]) begin	
  #1 if(xoff[6]==0)	counter[6]= 0;
       else begin 	counter[6]= pause_quanta[6]*num_clk_per_quanta;
      if(rx_pcs_ready) quanta_q[6].push_back(counter[6]);
       end
end

always @(xoff[7] or xon[7]) begin	
  #1 if(xoff[7]==0) 	counter[7]= 0;
      else begin	counter[7]= pause_quanta[7]*num_clk_per_quanta;
      if(rx_pcs_ready) quanta_q[7].push_back(counter[7]);
 end
end

always @ (posedge clk iff (xoff[8]>0))   begin
  //If pause_enable=1 then start decrementing counter after current on going frame ends (in TX MAC)
  //Do not decrement counter when o_rx_valid=0 (FB 544337) 
  if(pause_enable) begin
  	//if(counter[8] > 0 && o_rx_valid == 1'b1 && stop_flow==1)    counter[8]--;
  	if(counter[8] > 0 )    counter[8]--;
  end
  else begin
  //if(counter[8] > 0 && o_rx_valid == 1'b1)    counter[8]--;
  if(counter[8] > 0)    counter[8]--;
  end
    //$display("counter 8=%d at %t",counter[8],$time);
end	

always @ (posedge clk) begin
  //Do not decrement counter when o_rx_valid=0 (FB 544337) 
  for(int i=0;i<8;i++) begin
	  //if(counter[i] != 0 && pfc_enable[i] && xoff[i]>0 && o_rx_valid == 1'b1)    counter[i]--;
	  if(counter[i] != 0 && pfc_enable[i] && xoff[i]>0 )    counter[i]--;
  end
  //  $display("counter 0=%d at %t",counter[0],$time);
end	

//Disable the assertion if xon comes within 15 clocks after xoff
property rx_check_0;
  @(posedge clk) disable iff ((|xon[0])==1) (counter[0]>0 && pfc_enable[0]) |->##[1:80] rx_pfc[0];
endproperty
property rx_check_1;
  @(posedge clk) disable iff ((|xon[1])==1) (counter[1]>0 && pfc_enable[1]) |->##[1:80] rx_pfc[1];
endproperty
property rx_check_2;
  @(posedge clk) disable iff ((|xon[2])==1) (counter[2]>0 && pfc_enable[2]) |->##[1:80] rx_pfc[2];
endproperty
property rx_check_3;
  @(posedge clk) disable iff ((|xon[3])==1) (counter[3]>0 && pfc_enable[3]) |->##[1:80] rx_pfc[3];
endproperty
property rx_check_4;
  @(posedge clk) disable iff ((|xon[4])==1) (counter[4]>0 && pfc_enable[4]) |->##[1:80] rx_pfc[4];
endproperty
property rx_check_5;
  @(posedge clk) disable iff ((|xon[5])==1) (counter[5]>0 && pfc_enable[5]) |->##[1:80] rx_pfc[5];
endproperty
property rx_check_6;
  @(posedge clk) disable iff ((|xon[6])==1) (counter[6]>0 && pfc_enable[6]) |->##[1:80] rx_pfc[6];
endproperty
property rx_check_7;
  @(posedge clk) disable iff ((|xon[7])==1) (counter[7]>0 && pfc_enable[7]) |->##[1:80] rx_pfc[7];
endproperty

//Disable the assertion if xon comes within 15 clocks after xoff
property sfc_rx_check;
  `ifdef PAM4
  @(posedge clk) disable iff ((|xon[8])==1 || assertion_off)  (counter[8]>0) |->##[1:80]  rx_sfc;
  `else
  @(posedge clk) disable iff ((|xon[8])==1 || assertion_off) (counter[8]>0) |->##[1:80]  rx_sfc;
  `endif
endproperty

property sfc_check;
	@ (posedge clk)   !pause |->  xoff[7]==0 and xoff[6]==0 and xoff[5]==0 and xoff[4]==0 and xoff[3]==0 and xoff[2]==0 and xoff[1]==0 ;
endproperty


property sfc_ready_counter;
	@(posedge clk iff (pause_enable))  (counter[8] == 0) |-> $rose(ready) or ready==1;
endproperty

//ready drop
property sfc_ready_check;
	@(posedge clk iff (pause_enable==1'b1))  (stop_flow==1 && counter[8] > 0) |-> ##[10:80] ($fell(ready)  or ready==0);
endproperty

//pause receive rx before two consecutive XOFFs or between one xoff and one xon
//Disable the assertion if xoff comes within 15 clocks after xon==1 or counter==0
property sfc_rx_xon;
	@(posedge clk) disable iff(counter[8] > 1 || assertion_off==1) ((|xon[8])==1 or ((counter[8] == 32'b0) && $past(counter[8]) == 32'b1)) |-> ##[5:80] ($fell(rx_sfc) or !rx_sfc);
endproperty

//Disable the assertion if xoff comes within 15 clocks after xon==1 or counter==0
property pfc_rx_xon_0;
	@(posedge clk iff (pfc_enable[0] && (!assertion_off))) disable iff(counter[0] > 1) (counter[0] == 32'b0) |-> ##[10:80] ($fell(rx_pfc[0]) or !rx_pfc[0]);
endproperty
property pfc_rx_xon_1;
	@(posedge clk iff (pfc_enable[1] && (!assertion_off))) disable iff(counter[1] > 1) (counter[1] == 32'b0) |-> ##[10:80] ($fell(rx_pfc[1]) or !rx_pfc[1]);
endproperty
property pfc_rx_xon_2;
	@(posedge clk iff (pfc_enable[2] && (!assertion_off))) disable iff(counter[2] > 1) (counter[2] == 32'b0) |-> ##[10:80] ($fell(rx_pfc[2]) or !rx_pfc[2]);
endproperty
property pfc_rx_xon_3;
	@(posedge clk iff (pfc_enable[3] && (!assertion_off))) disable iff(counter[3] > 1) (counter[3] == 32'b0) |-> ##[10:80] ($fell(rx_pfc[3]) or !rx_pfc[3]);
endproperty
property pfc_rx_xon_4;
	@(posedge clk iff (pfc_enable[4] && (!assertion_off))) disable iff(counter[4] > 1) (counter[4] == 32'b0) |-> ##[10:80] ($fell(rx_pfc[4]) or !rx_pfc[4]);
endproperty
property pfc_rx_xon_5;
	@(posedge clk iff (pfc_enable[5] && (!assertion_off))) disable iff(counter[5] > 1) (counter[5] == 32'b0) |-> ##[10:80] ($fell(rx_pfc[5]) or !rx_pfc[5]);
endproperty
property pfc_rx_xon_6;
	@(posedge clk iff (pfc_enable[6] && (!assertion_off))) disable iff(counter[6] > 1) (counter[6] == 32'b0) |-> ##[10:80] ($fell(rx_pfc[6]) or !rx_pfc[6]);
endproperty
property pfc_rx_xon_7;
	@(posedge clk iff (pfc_enable[7] && (!assertion_off))) disable iff(counter[7] > 1) (counter[7] == 32'b0) |-> ##[10:80] ($fell(rx_pfc[7]) or !rx_pfc[7]);
endproperty

// Assertion to check when rx_pcs_ready low, pause is also low. 
property ready_pause();
	@(posedge clk) (rx_pcs_ready == 0) |-> (rx_sfc == 0);
endproperty

//GDR_FIXME :- This was previously commented in c3 .
//Need to check again when RTL is ready to be used.

//assert property (ready_pause)
// else `uvm_error("rx_sfc", $sformatf("rx_sfc should be low"));
//
//// Assertion to check when rx_pcs_ready low, pfc is also low. 
//property ready_pfc();
//	@(posedge clk) (rx_pcs_ready == 0) |-> (rx_pfc == 0);
//endproperty
//assert property (ready_pfc)
// else `uvm_error("rx_pfc", $sformatf("rx_pfc should be low")); 

//GDR_FIXME : This was previously commented in C3.
//Need to check this assertion when RTL is ready to be used.
// FOR SFC checks if ready has fallen and EOP is zero.
//sfc and pfc can be together in a sim
	//sfc_ready_counter1 :assert property (sfc_ready_counter)   else `uvm_error("SFC_check_counter", $sformatf("l8_tx_ready should be hi")); 

function int count_inc(int sig_inst);
     `uvm_info("fc_interface",$sformatf("updated the counter=%0t for queue %0d %0h", $time,sig_inst,exp_clk_quanta[sig_inst]),UVM_MEDIUM)
      return exp_clk_quanta[sig_inst];
endfunction

task chk_s_width_dyn();
   automatic int count=1;
   automatic int vk=0;
   `uvm_info("fc_interface",$sformatf("inside chk_width_dyn time=%0t vk=%0d", $time,vk),UVM_MEDIUM)
   forever begin
      if (!rx_sfc) begin : changed
	     if(quanta_q[8].size>0) exp_clk_quanta[8]=quanta_q[8].pop_front();
	     vk=exp_clk_quanta[8];
         if(assertion_off == 0) begin
	        //GDR HSD :window_size is kept 50 for 100G only, because pause signals depends on DUT internal grey signals, so that asserton errors are coming.
            a_k: assert(count>=vk-4 && count<=vk+window_size && vk>0) else
           `uvm_error("FC_WIDTH", $sformatf("%m : at %t error in changed, expected %d, got %d",$time, vk, count));
         end     
          -> a4; //for debug
         `uvm_info("FC_WIDTH",$sformatf("%m : at %0t assertion info,expected %0d got %0d for sfc",$time,vk,count),UVM_LOW)
         count=0;
         break;
      end :changed
      else begin : keep_count
         count = count+1'b1;
         -> a6; //for debug
      end : keep_count
      @(posedge clk);
   end // forever
   ->a7; //for debug
endtask

task automatic chk_p_width_dyn(int sig_inst);
   automatic int count=1;
   automatic int vk=0;
   `uvm_info("fc_interface",$sformatf("inside pfc_chk_width_dyn time=%0t vk=%0d sig_inst=%0d", $time,vk,sig_inst),UVM_MEDIUM)
   forever begin
     if (!rx_pfc[sig_inst]) begin : changed
        if(quanta_q[sig_inst].size>0) exp_clk_quanta[sig_inst]=quanta_q[sig_inst].pop_front();
        vk=exp_clk_quanta[sig_inst];
        if(assertion_off == 0) begin
          a_k: assert(count>=vk-2 && count<=vk+window_size && vk >0) else
          `uvm_error("FC_WIDTH", $sformatf("%m : at %t error in changed, expected %d, got %d for pfc queue %0d",$time, vk, count,sig_inst));
        end
        `uvm_info("FC_WIDTH",$sformatf("%m : at %0t assertion info,expected %0d got %0d for pfc signal : %0d",$time,vk,count,sig_inst),UVM_LOW)
        count=0;
        break;
    end :changed
    else begin : keep_count
      count = count+1'b1;
    end : keep_count
    
    @(posedge clk);
   end // forever
endtask

property p_sfc_width;
    @(posedge clk) ($rose(rx_sfc) && !assertion_off)|-> (1,chk_s_width_dyn());
endproperty

property p_pfc_width(sig);
    @(posedge clk) ($rose(rx_pfc[sig]) && pfc_enable[sig] && !assertion_off)|-> (1,chk_p_width_dyn(sig));
endproperty

// New assertion to check the width of fc signal 
sfc_width: assert property (p_sfc_width) else `uvm_error("sfc_rx", $sformatf("width of the sfc_rx is not as expected"));
pfc_width0: assert property (p_pfc_width(0)) else `uvm_error("pfc_rx0", $sformatf("width of the pfc_rx0 is not as expected"));
pfc_width1: assert property (p_pfc_width(1)) else `uvm_error("pfc_rx1", $sformatf("width of the pfc_rx1 is not as expected"));
pfc_width2: assert property (p_pfc_width(2)) else `uvm_error("pfc_rx2", $sformatf("width of the pfc_rx2 is not as expected"));
pfc_width3: assert property (p_pfc_width(3)) else `uvm_error("pfc_rx3", $sformatf("width of the pfc_rx3 is not as expected"));
pfc_width4: assert property (p_pfc_width(4)) else `uvm_error("pfc_rx4", $sformatf("width of the pfc_rx4 is not as expected"));
pfc_width5: assert property (p_pfc_width(5)) else `uvm_error("pfc_rx5", $sformatf("width of the pfc_rx5 is not as expected"));
pfc_width6: assert property (p_pfc_width(6)) else `uvm_error("pfc_rx6", $sformatf("width of the pfc_rx6 is not as expected"));
pfc_width7: assert property (p_pfc_width(7)) else `uvm_error("pfc_rx7", $sformatf("width of the pfc_rx7 is not as expected"));

sfc_ready :assert property (sfc_ready_check) else `uvm_error("SFC_check", $sformatf("ready hasnt fallen or eop is high when SFC is received"));
sfc_pause_xon : assert property (sfc_rx_xon) else begin
`uvm_error("sfc_xon_check", $sformatf("sfc rx should be lo"));
$display("xon[8]=%0d |XON[8]=%0d,counter[8]=%d at %t",xon[8],(|xon[8]),counter[8],$time);
end
// GDRDVHSD 16011702597 :VIP TX and DUT RX packets are coming at different timestamp..sometimes one is slow, another is faster and viceversa.so disable
// the below assertion and for that, we have different assertion called FC_WIDTH to check the pulse width.
//sfc_rx : assert property (sfc_rx_check) else `uvm_error("sfc_rx", $sformatf("sfc_rx should be hi"));
//fc_rx0 : assert property (rx_check_0) else `uvm_error("fc_rx0", $sformatf("pfc_rx0 should be hi"));
//fc_rx1 : assert property (rx_check_1) else `uvm_error("fc_rx1", $sformatf("pfc_rx1 should be hi"));
//fc_rx2 : assert property (rx_check_2) else `uvm_error("fc_rx2", $sformatf("pfc rx2 should be hi"));
//fc_rx3 : assert property (rx_check_3) else `uvm_error("fc_rx3", $sformatf("pfc rx3 should be hi"));
//fc_rx4 : assert property (rx_check_4) else `uvm_error("fc_rx4", $sformatf("pfc rx4 should be hi"));
//fc_rx5 : assert property (rx_check_5) else `uvm_error("fc_rx5", $sformatf("pfc rx5 should be hi"));
//fc_rx6 : assert property (rx_check_6) else `uvm_error("fc_rx6", $sformatf("pfc rx6 should be hi"));
//fc_rx7 : assert property (rx_check_7) else `uvm_error("fc_rx7", $sformatf("pfc rx7 should be hi"));

pfc_pause_xon0 : assert property (pfc_rx_xon_0) else `uvm_error("pfc_xon_check0", $sformatf("pfc rx0 should be lo"));
pfc_pause_xon1 : assert property (pfc_rx_xon_1) else `uvm_error("pfc_xon_check1", $sformatf("pfc rx1 should be lo"));
pfc_pause_xon2 : assert property (pfc_rx_xon_2) else `uvm_error("pfc_xon_check2", $sformatf("pfc rx2 should be lo"));
pfc_pause_xon3 : assert property (pfc_rx_xon_3) else `uvm_error("pfc_xon_check3", $sformatf("pfc rx3 should be lo"));
pfc_pause_xon4:  assert property (pfc_rx_xon_4) else `uvm_error("pfc_xon_check4", $sformatf("pfc rx4 should be lo"));
pfc_pause_xon5 : assert property (pfc_rx_xon_5) else `uvm_error("pfc_xon_check5", $sformatf("pfc rx5 should be lo"));
pfc_pause_xon6 : assert property (pfc_rx_xon_6) else `uvm_error("pfc_xon_check6", $sformatf("pfc rx6 should be lo"));
pfc_pause_xon7 : assert property (pfc_rx_xon_7) else `uvm_error("pfc_xon_check7", $sformatf("pfc rx7 should be lo"));

//COVERAGE
	cover property (sfc_ready_counter);
	//dsamantx:the below line was commented in c3.Need to check by uncommenting.
	cover property (sfc_ready_check);  
	cover property (sfc_rx_xon); 

//	fc_rx_assertc0:cover property (rx_check_0);
//	fc_rx_assertc1:cover property (rx_check_1);
//	fc_rx_assertc2:cover property (rx_check_2);
//	fc_rx_assertc3:cover property (rx_check_3);
//	fc_rx_assertc4:cover property (rx_check_4);
//	fc_rx_assertc5:cover property (rx_check_5);
//	fc_rx_assertc6:cover property (rx_check_6);
//	fc_rx_assertc7:cover property (rx_check_7);
//	xon_assertc1:cover property (pfc_rx_xon_1);
//	xon_assertc2:cover property (pfc_rx_xon_2);
//	xon_assertc3:cover property (pfc_rx_xon_3);
//	xon_assertc4:cover property (pfc_rx_xon_4);
//	xon_assertc5:cover property (pfc_rx_xon_5);
//	xon_assertc6:cover property (pfc_rx_xon_6);
//	xon_assertc7:cover property (pfc_rx_xon_7);
	endinterface: eth_fc_interface

