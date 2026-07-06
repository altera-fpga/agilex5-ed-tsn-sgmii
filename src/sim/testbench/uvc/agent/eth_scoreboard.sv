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
// Template for UVM Scoreboard

`ifndef ETH_SCOREBOARD__SV
`define ETH_SCOREBOARD__SV


class eth_scoreboard extends uvm_scoreboard;
  /*Packet counters*/
  bit tx_rx = 0;
  int pass_pkt=0;
  int fail_pkt=0;
  int fc_pass_pkt=0;
  int fc_fail_pkt=0;
  int mismatch_cnt=0;
  int no_pkt=0;
  int skip_comparison_no_pkt=0;
  int fc_no_pkt=0;
  int skip_comparison_fc_no_pkt=0;
  int tx_pkt_cnt=0;
  int fc_tx_pkt_cnt=0;
  int rx_pkt_cnt=0;
  int fc_rx_pkt_cnt=0;

  /*Packet Ques*/
  eth_packet q_tx[$];
  eth_packet q_rx[$];
  eth_packet temp_tx_packet,temp_rx_pkt;
  eth_packet pause_q_tx[$];
  eth_packet pause_q_rx[$];
  eth_packet tx_pkt_f;
  eth_packet rx_pkt;
  
  /*User knobs*/
  bit tx_error_insertion_test=0;
  bit scb_dis=0;
  bit fc_flag_en = 0;
  bit sip_limit = 0;
  uvm_table_printer printer;

  /*Internal variables*/
  semaphore  compare_sem;
  bit flag=0;
  bit [7:0] en_bit_vector;
  int i,crc_match;
	//ptp variables
	bit cf_offset_cmp_skip;
	bit[31:0] cf_offset_sb;
	bit[63:0] cf_offset_tx_val;
	bit[63:0] cf_offset_rx_val;
	bit[63:0] cf_offset_lsb_tol;
	bit[7:0] cf_offset_lsb_tol_r;

  
  /*If pointer*/
  typedef virtual spy_interface v_if2; 
  v_if2 spy_if;

  /*Latency Variables*/
  real first_packet;
  int previous_packet;
  int current_packet;
  real last_packet;
  int data_rate_link;
  int tx_time_one;
  int num_of_bytes,j;
  int bits_per_byte=8;
  int rx_preamble_sfd=8;
  int rx_dst_addr=6;
  int rx_src_addr=6;
  int rx_len=2;
  int rx_crc_pkt=4;
  int ipg=12;
  real payload_size;
  real total_time;
  real rate;
  real accuracy;
  real tolerance =1.3;
  real speed;
  longint unsigned latency;
  
  // path delay calculations
  real q_tx_time[$];
  real q_rx_time[$];
  int dl_en =0;
  real pkt_path_delay;
  real tx_pkt_f_time;
  real rx_pkt_time;
  real pkt_time;

  
  // Dynamic Config Obj
  dyn_rcfg dyn_rcfg_obj_inst;

  /*Current object's parent env name*/
  string env_name; 
  string m_sequence;
  uvm_cmdline_processor inst;
  
  /*File pointers for debug*/
  string  file_exp_1 = "exp_pkt_1.log";
  integer file_exp_log_id_1; 
  string  file_exp = "exp_pkt.log";
  integer file_exp_log_id; 
  string  file_act_1 = "act_pkt_1.log";
  integer file_act_log_id_1; 
  string  file_act = "act_pkt.log";
  integer file_act_log_id; 
  string  file_bw = "bandwidth.txt";
  integer file_bandwidth;
  string  file_lat = "latency.txt";
  integer file_latency;
 	
  /*ump analysis imps ports*/
  `uvm_analysis_imp_decl(_tx)
   uvm_analysis_imp_tx #(eth_packet,eth_scoreboard) before_export;
  `uvm_analysis_imp_decl(_rx)
   uvm_analysis_imp_rx #(eth_packet,eth_scoreboard) after_export;

  `uvm_component_utils_begin(eth_scoreboard)
      `uvm_field_int(scb_dis,UVM_ALL_ON)
  `uvm_component_utils_end

  extern function new(string name = "eth_scoreboard", uvm_component parent = null); 
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase (uvm_phase phase);
  extern virtual function void write_tx (input eth_packet tx_pkt);
  extern virtual function void write_rx (input eth_packet rx_pkt);
  extern virtual task compare_pkt ();
  extern virtual task compare_fc_pkt ();
  extern virtual function void flush();
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
  extern virtual function void check_phase(uvm_phase phase);

endclass: eth_scoreboard


function eth_scoreboard::new(string name = "eth_scoreboard",uvm_component parent);
   super.new(name,parent);
   compare_sem = new(1);
endfunction: new

function void eth_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   before_export = new("before_export", this);
   after_export  = new("after_export", this);
   uvm_config_db#(v_if2)::get(this, "", "spy_interface", spy_if);
   if (spy_if == null)  `uvm_fatal("NO_CONN", "spy if port not connected to the actual interface instance");
   // Get Dyn cfg obj
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end
   if(!uvm_config_db#(string)::get(this,"","env_name", env_name)) begin
        `uvm_fatal("env_name", "failed to get env_name");
   end

   inst = uvm_cmdline_processor::get_inst();
   inst.get_arg_value("+m_sequence=",m_sequence);

   //stumulur: to print the tranaction item with all payload frames 
   printer = new();
   printer.knobs.begin_elements = -1;  
endfunction:build_phase

function void eth_scoreboard::connect_phase(uvm_phase phase);
    file_exp_log_id     =$fopen({env_name,".",get_name(),file_exp},"a");
    file_exp_log_id_1     =$fopen({env_name,".",get_name(),file_exp_1},"a");
    file_act_log_id     =$fopen({env_name,".",get_name(),file_act},"a");
    file_act_log_id_1     =$fopen({env_name,".",get_name(),file_act_1},"a");
    file_bandwidth      =$fopen({env_name,".",get_name(),file_bw} ,"a"); 
    file_latency        =$fopen({env_name,".",get_name(),file_lat},"a");  
endfunction:connect_phase

task eth_scoreboard::run_phase(uvm_phase phase);
  forever begin
    fork
      begin
        @(scb_dis)
        uvm_report_info(get_name(),$psprintf("scb_dis change detected"),UVM_NONE);
        flush();
        flag=1;
      end
      begin
         wait(q_tx.size>0 && q_rx.size>0);
         $display("data thread entered in scb");
         temp_rx_pkt=q_rx[0];
         if(flag) begin
            $display("SCB was disabled ");
            i=0;
            crc_match=0;
            while(i<q_tx.size && !crc_match) begin
               temp_tx_packet=q_tx[i];
               if(temp_tx_packet.fcs==temp_rx_pkt.fcs) begin
                  crc_match=1;
                  flag=0;
                  q_tx=q_tx[i:$];
				  if(dl_en==1) q_tx_time=q_tx_time[i:$];
                  uvm_report_info("eth_scoreboard",$psprintf("found good packet in tx queue after recovering from scb_disable.Deleting %d packets from tx q.tx q size now is %d",i,q_tx.size),UVM_LOW);
                  if( (dyn_rcfg_obj_inst.skew_test == 1) && ( (temp_rx_pkt.rx_error[0]== 1) || (temp_rx_pkt.rx_error[1]== 1)))  uvm_report_info("eth_scoreboard",$psprintf("skew test:%d, malformed frame received:%d dropped from comparison ",dyn_rcfg_obj_inst.skew_test, temp_rx_pkt.rx_error[0]),UVM_LOW);
                  else begin
                  //non blocking thread for compare
                     fork
                        if(temp_rx_pkt.eth_type_or_length==16'h8808) compare_fc_pkt();
                        else  compare_pkt();
                     join_none
                  end
               end
               i++;
            end //while
            if(!crc_match) uvm_report_info("eth_scoreboard",$psprintf("partial pkt received,ignoring it.crc_match: %b",crc_match),UVM_HIGH);
            uvm_report_info("eth_scoreboard",$psprintf("after scb disable,found/not found a matching packet in tx queue.crc_match: %d",crc_match),UVM_LOW);
            
            //TODO_GDR:
            if(dyn_rcfg_obj_inst.ptp == 1)begin
               //set flag to 0
               flag = 0;
            end
            
            
         end//flag hi

        `uvm_info(get_type_name(), $psprintf("tx_error_insertion_test = %0d",tx_error_insertion_test),UVM_LOW);
        
        if((dyn_rcfg_obj_inst.skew_test == 1 && (temp_rx_pkt.rx_error[0] || temp_rx_pkt.rx_error[1]))  || flag) begin
          uvm_report_info("eth_scoreboard",$psprintf("DRopping packet.skew test:%d, malformed frame received:%d dropped from comparison.flag value:%d ",dyn_rcfg_obj_inst.skew_test, temp_rx_pkt.rx_error[0],flag),UVM_LOW);
          q_rx.delete(0);
		  if(dl_en==1) q_rx_time.delete(0);
          rx_pkt_cnt--;
        end
        else  compare_pkt();
      end

      begin
        wait(pause_q_tx.size>0 && pause_q_rx.size>0);
        $display("control thread entered in scb");
        compare_fc_pkt();
      end
    join_any
    disable fork;

  end//forever
endtask

/*Write implementation for TX port*/
// Store TX  packet in TX que
function void eth_scoreboard::write_tx(input eth_packet tx_pkt);
  eth_packet tx_pkt_f2;
  bit mac_seg;
  
  if(dyn_rcfg_obj_inst.mode == MACSEG)begin
   mac_seg = 1;
  end else begin
   mac_seg = 0;
  end  
  
  if(spy_if.o_rx_hi_ber ==1'b1)
    begin 
     `uvm_info(get_full_name(),$sformatf(" hiber is asserted, so RX packet should be dropped hi_ber=%0d ",spy_if.o_rx_hi_ber ==1'b1),UVM_MEDIUM);
     return;
    end

  uvm_report_info(get_name(),$psprintf("Packet received in scoreboard write_tx  function"),UVM_MEDIUM);
  uvm_report_info(get_name(),$psprintf("Packet received in scoreboard write_tx  function  : \n",tx_pkt.print),UVM_DEBUG);
  $cast(tx_pkt_f2,tx_pkt.clone());
`ifdef BANDWIDTH_ON 
	 if(tx_pkt_f2.transaction_id%1000==1) begin
		 this.tx_time_one=$time;
$display ("tx_time_one = %d",this.tx_time_one); end
$display ("transaction id = %d",tx_pkt_f2.transaction_id);
 `endif
 $fwrite(file_exp_log_id,"Transaction no:%0d\n %s \n",tx_pkt_f2.transaction_id,tx_pkt_f2.sprint());
 `ifndef ENABLE_ETH_VIP
 $fwrite(file_exp_log_id_1,"Transaction no:%0d\n %s \n",tx_pkt_f2.transaction_id,tx_pkt_f2.print_transaction(.frame_count(tx_pkt_f2.transaction_id),.seg_mode(mac_seg),.eop_empty(tx_pkt_f2.empty_bytes)));
 `else
 $fwrite(file_exp_log_id_1,"Transaction no:%0d\n %s \n",tx_pkt_f2.transaction_id,tx_pkt_f2.print_transaction(.frame_count(tx_pkt_f2.transaction_id),.seg_mode(0),.eop_empty(tx_pkt_f2.empty_bytes))); //VIP always transmit pack_bytes
 `endif
 
  if(scb_dis) flush();
  else begin
    if(tx_pkt_f2.eth_type_or_length==16'h8808) begin
      pause_q_tx.push_back(tx_pkt_f2);
      fc_tx_pkt_cnt++;
     uvm_report_info("eth_scoreboard",$psprintf("pause_q_tx size=%d ",pause_q_tx.size),UVM_LOW);
    end 
    else begin
      if ((tx_pkt_f2.packed_bytes.size() < 14) && (tx_rx == 'b1))
      begin
            `uvm_info(get_type_name(), $psprintf("SIP_LIMIT_TEST Tx Pkt size less than 14B, Ignoring Packet -> Size  = %0d",tx_pkt_f2.packed_bytes.size),UVM_LOW);
      end
      else
      begin
	 `uvm_info(get_type_name(), $psprintf("ST1: received Tx packet Size  = %0d",tx_pkt_f2.packed_bytes.size()),UVM_LOW);
         q_tx.push_back(tx_pkt_f2);
		 if(dl_en==1) q_tx_time.push_back($realtime);
         tx_pkt_cnt++;
         uvm_report_info("eth_scoreboard",$psprintf("q_tx size=%d ",q_tx.size),UVM_LOW);
      end
    end 
    end 
endfunction: write_tx 

/*Write implementation for RX port*/
// Store RX  packet in TX que
function void eth_scoreboard::write_rx(input eth_packet rx_pkt);
  eth_packet sb_rx_pkt;
  bit mac_seg;
  
  if(dyn_rcfg_obj_inst.mode == MACSEG)begin
   mac_seg = 1;
  end else begin
   mac_seg = 0;
  end

  if(spy_if.o_rx_hi_ber ==1'b1)
    begin 
     `uvm_info(get_full_name(),$sformatf(" hiber is asserted, so RX packet should be dropped hi_ber=%0d ",spy_if.o_rx_hi_ber ==1'b1),UVM_MEDIUM);
     return;
    end

  uvm_report_info(get_name(),$psprintf("Packet received in scoreboard write_rx  function  : \n",rx_pkt.print),UVM_DEBUG);
  $cast(sb_rx_pkt,rx_pkt.clone());

`ifdef BANDWIDTH_ON
    //num_of_bytes= num_of_bytes + (sb_rx_pkt.packed_bytes.size()) + ipg;
    num_of_bytes= num_of_bytes + (sb_rx_pkt.payload.size+rx_preamble_sfd+rx_dst_addr+rx_src_addr+rx_len+rx_crc_pkt+ipg);
   
    uvm_report_info("eth_scoreboard",$psprintf("The packet size is %d,payload = %d, ipg = %d",num_of_bytes,sb_rx_pkt.payload.size,ipg),UVM_NONE);
    if((sb_rx_pkt.transaction_id%1000)==1)
    begin	
      first_packet=$realtime;
      uvm_report_info("eth_scoreboard",$psprintf("the first packet recveiced at : %d ps  ",first_packet),UVM_NONE);
      $display("first_packet = %d, tx_time_one = %d",first_packet,this.tx_time_one);
      latency=first_packet-this.tx_time_one;
      $fwrite(file_latency,"payload is %d and latency is %d \n",num_of_bytes,latency); 
    end
    if((sb_rx_pkt.transaction_id%1000)==0)
    begin	
      last_packet=$realtime;
      uvm_report_info("eth_scoreboard",$psprintf("the last packet recveiced at  : %d ps",last_packet),UVM_NONE);
      uvm_report_info("eth_scoreboard",$psprintf("the difference in time is :    %d ps",last_packet-first_packet),UVM_NONE);
      payload_size= num_of_bytes*bits_per_byte;
      first_packet = first_packet/1000; // ps to ns 
      last_packet  = last_packet/1000; // ps to ns 
      total_time= last_packet-first_packet; // Total time in ns 
      $display("PAYLOAD_SIZE: %f and total_time: %f ns",payload_size,total_time);
      //rate = (num_of_bytes*bits_per_byte)/(last_packet-first_packet) ns;	
      rate=payload_size/total_time; // Rate in Gpbs 
      uvm_report_info("eth_scoreboard",$psprintf("The  RATE is %f Gbps",rate),UVM_NONE);
      $fwrite(file_bandwidth,"payloadsize is %d and difference time is %d the rate is %f \n",num_of_bytes,(last_packet-first_packet),rate);

      case(dyn_rcfg_obj_inst.ll_speed) 
        _2p5G  :  speed = 2.5  ;
        _1G    :  speed = 1  ;
        _10G   :  speed = 10  ;
        _25G   :  speed = 25  ;
        _40G   :  speed = 40  ;
        _50G   :  speed = 50  ;
        _100G  :  speed = 100 ;
        _200G  :  speed = 200 ;
        _400G  :  speed = 400 ;
       endcase
 
        //accuracy = speed *(tolerance/100);
        // 98% of required bandwidth is okay as per Ken  
        accuracy = (speed * 90)/100; 
        if (rate  > accuracy)
            uvm_report_info("eth_scoreboard",$psprintf("RATE Match with precision:Expected = %fGbps Actual = %f Gbps Accuracy = %f ",speed,rate,accuracy),UVM_NONE);
        else
            `uvm_error("eth_scoreboard",$psprintf("RATE Mismatch:Expected = %f Gbps Actual = %f Gbps Accuracy = %f",speed,rate,accuracy));
    end
`endif 

 $fwrite(file_act_log_id,"Transaction no:%0d\n %s \n",sb_rx_pkt.transaction_id,sb_rx_pkt.sprint());
`ifndef ENABLE_ETH_VIP
 $fwrite(file_act_log_id_1,"Transaction no:%0d\n %s \n",sb_rx_pkt.transaction_id,sb_rx_pkt.print_transaction(.frame_count(sb_rx_pkt.transaction_id),.seg_mode(mac_seg),.eop_empty(sb_rx_pkt.empty_bytes)));
`else
 $fwrite(file_act_log_id_1,"Transaction no:%0d\n %s \n",sb_rx_pkt.transaction_id,sb_rx_pkt.print_transaction(.frame_count(sb_rx_pkt.transaction_id),.mode(2'b01),.seg_mode(mac_seg),.eop_empty(sb_rx_pkt.empty_bytes)));  //TODO_GDR: Actually need to consider tx_preamble_passthrough,rx_preamble_passthrough for the mode. Temporary put mode=2'b01.
 //$fwrite(file_act_log_id_1,"Transaction no:%0d\n %s \n",sb_rx_pkt.transaction_id,sb_rx_pkt.print_transaction(sb_rx_pkt.transaction_id,2'b01,mac_seg,sb_rx_pkt.empty_bytes));
`endif

  if(scb_dis) flush();
  else begin
    if(sb_rx_pkt.eth_type_or_length==16'h8808) begin
      pause_q_rx.push_back(sb_rx_pkt);
      fc_rx_pkt_cnt++;
     uvm_report_info("eth_scoreboard",$psprintf("pause_q_rx size=%d ",pause_q_rx.size),UVM_LOW);
    end 
    else begin
      if((sb_rx_pkt.packed_bytes.size() < 14) && (sb_rx_pkt.seen_tx_error_insertion ==1))
      begin
            `uvm_info(get_type_name(), $psprintf("SIP_LIMIT_TEST Rx Pkt size less than 14B and tx_error is set, Ignoring Packet -> Size  = %0d",rx_pkt.payload.size),UVM_LOW);
      end
      else
      begin
	  `uvm_info(get_type_name(), $psprintf("ST1: received Rx packet Size  = %0d",sb_rx_pkt.packed_bytes.size()),UVM_LOW);
          q_rx.push_back(sb_rx_pkt);
		  if(dl_en==1) q_rx_time.push_back($realtime);
          rx_pkt_cnt++;
          uvm_report_info("eth_scoreboard",$psprintf("q_rx size=%d ",q_rx.size),UVM_LOW);
     end
    end 
  end 
endfunction: write_rx 

/* Compare TX fc to RX fc packets */
task eth_scoreboard::compare_fc_pkt();
  $display("in flow control compare task");
  mismatch_cnt=0;
  compare_sem.get(1);
  //uvm_report_fatal("eth_scoreboard",$psprintf("No fc packet in tx Q while rx has arrived,q size= %h",pause_q_tx.size),UVM_LOW);
  //else  
  tx_pkt_f=pause_q_tx.pop_front;
  rx_pkt=pause_q_rx.pop_front;
   
   if(tx_pkt_f.seen_tx_error_insertion == 1 && rx_pkt.seen_tx_error_insertion ==1 && tx_error_insertion_test) begin
    `uvm_info(get_type_name(), $psprintf("Tx error is inserted , skipping comparision for this frame : rx_pkt_cnt = %0d",rx_pkt_cnt),UVM_LOW);
    skip_comparison_fc_no_pkt ++;
   end
   else if(tx_pkt_f.seen_tx_error_insertion == 1 && rx_pkt.seen_tx_error_insertion !=1 && tx_error_insertion_test) begin
     `uvm_error(get_type_name(), $sformatf("Tx error is inserted ,but tx error is not seen in rx  : rx_pkt_cnt = %0d",rx_pkt_cnt));
     skip_comparison_fc_no_pkt ++;
   end
   else begin
     fc_no_pkt++;
     assert(tx_pkt_f.dest_address==rx_pkt.dest_address)
     else begin
       `uvm_error("eth_scoreboard",$psprintf("FC DESTINATION ADDRESS Mismatch:Tx Dest Addr=%h, Rx Dest_Addr= %h",tx_pkt_f.dest_address,rx_pkt.dest_address));
       mismatch_cnt++;
     end 
 
     assert(tx_pkt_f.preamble==rx_pkt.preamble)
     else begin
       `uvm_error("eth_scoreboard",$psprintf("Preamble Mismatch:Tx Preamble=%h, Rx Preamble= %h",tx_pkt_f.preamble,rx_pkt.preamble));
       mismatch_cnt++;
     end
   
     assert(tx_pkt_f.src_address==rx_pkt.src_address)
     else begin
     `uvm_error("eth_scoreboard",$psprintf("FC SOURCE ADDRESS Mismatch:Tx Src Addr=%h, Rx Src Addr= %h",tx_pkt_f.src_address,rx_pkt.src_address));
       mismatch_cnt++;
     end 
   
     assert(tx_pkt_f.eth_type_or_length==rx_pkt.eth_type_or_length)
     else begin
     `uvm_error("eth_scoreboard",$psprintf("FC ETH TYPE Mismatch:Tx Eth type =%h, Rx Eth type= %h",tx_pkt_f.eth_type_or_length,rx_pkt.eth_type_or_length));
       mismatch_cnt++;
     end 
 
     assert(tx_pkt_f.payload.size==rx_pkt.payload.size) begin
       if(fc_flag_en) begin  
         for(int i=0;i<4;i++) begin
           assert(tx_pkt_f.payload[i]==rx_pkt.payload[i])
           else begin
             `uvm_error("eth_scoreboard",$psprintf("Data[%d] Mismatch:Tx Data=%h, Rx Data= %h",i,tx_pkt_f.payload[i],rx_pkt.payload[i]));
             mismatch_cnt++;
           end 
         end//for loop
         if(mismatch_cnt==0) begin
           if(tx_pkt_f.payload[0]==0) begin//sfc packet
             for(int i=4;i<46;i++) begin
               assert(tx_pkt_f.payload[i]==rx_pkt.payload[i])
               else begin
                `uvm_error("eth_scoreboard",$psprintf("Data[%d] Mismatch:Tx Data=%h, Rx Data= %h",i,tx_pkt_f.payload[i],rx_pkt.payload[i]));
                mismatch_cnt++;
               end 
             end //for loop
           end //sfc
           else begin //pfc
             en_bit_vector=tx_pkt_f.payload[3];
             foreach(en_bit_vector[i]) begin
               if(en_bit_vector[i]) begin
                 j=(i+2)*2;
                 assert(tx_pkt_f.payload[j]==rx_pkt.payload[j])
                 else begin
                   `uvm_error("eth_scoreboard",$psprintf("Data[%d] Mismatch:Tx Data=%h, Rx Data= %h",j,tx_pkt_f.payload[j],rx_pkt.payload[j]));
                   mismatch_cnt++;
                 end 
                 assert(tx_pkt_f.payload[j+1]==rx_pkt.payload[j+1])
                 else begin
                   `uvm_error("eth_scoreboard",$psprintf("Data[%d] Mismatch:Tx Data=%h, Rx Data= %h",j+1,tx_pkt_f.payload[j+1],rx_pkt.payload[j+1]));
                   mismatch_cnt++;
                 end 
               end //en_bit hi 
             end //foreach
             for(int i=20;i<46;i++) begin
               assert(tx_pkt_f.payload[i]==rx_pkt.payload[i])
               else begin
                 `uvm_error("eth_scoreboard",$psprintf("Data[%d] Mismatch:Tx Data=%h, Rx Data= %h",i,tx_pkt_f.payload[i],rx_pkt.payload[i]));
                 mismatch_cnt++;
               end 
             end//for loop 
           end//pfc packet
         end //mismatch loop
       end // if(fc_flag_en)
       else begin
         foreach(tx_pkt_f.payload[i])
         assert(tx_pkt_f.payload[i]==rx_pkt.payload[i])
         else begin
           `uvm_error("eth_scoreboard",$psprintf("will break from payload loop.Data[%d] Mismatch:Tx Data=%h, Rx Data= %h",i,tx_pkt_f.payload[i],rx_pkt.payload[i]));
           mismatch_cnt++;
           break;
         end
       end
     end //payload size
   else begin
     if(tx_pkt_f.seen_len_err_with_pad_removal == 1'b1) begin
       `uvm_info("eth_scoreboard",$psprintf("Payload checking disabled due to undefined RTL behavior HSD#16015012533 , Tx payload size=%d, Rx payload size= %d",tx_pkt_f.payload.size,rx_pkt.payload.size),UVM_LOW);
     end
     else begin
       `uvm_error("eth_scoreboard",$psprintf("payload size Mismatch:Tx Payload size=%d, Rx Payload size= %d",tx_pkt_f.payload.size,rx_pkt.payload.size));
       mismatch_cnt++;
     end
   end
   if(tx_pkt_f.seen_tx_fcs_error_insertion==1) begin
     if(rx_pkt.seen_rx_fcs_error_insertion != 1) begin
       `uvm_error(get_type_name(), $sformatf("Expected tx fcs error is not seen at vip rx : seen_fcs_error = %0d",rx_pkt.seen_tx_fcs_error_insertion));
       mismatch_cnt++;
     end
   end
   if(tx_pkt_f.seen_tx_fcs_error_insertion!=1) begin
     if(rx_pkt.seen_rx_fcs_error_insertion == 1) begin
       `uvm_error(get_type_name(), $sformatf("Unexpected tx fcs error is seen at vip rx : seen_fcs_error = %0d",rx_pkt.seen_tx_fcs_error_insertion));
       mismatch_cnt++;
     end
   end
//   if(tx_pkt_f.payload.size()!='d46) begin
//     `uvm_info("eth_scoreboard",$psprintf("FCS checking disblaed temporarily, Tx FCS=%h, Rx FCS= %h",tx_pkt_f.fcs,rx_pkt.fcs),UVM_LOW);
//   end
//   else begin
     assert(tx_pkt_f.fcs==rx_pkt.fcs)
     else begin
       `uvm_info("eth_scoreboard",$psprintf("Tx FCS=%h, Rx FCS= %h",tx_pkt_f.fcs,rx_pkt.fcs),UVM_LOW);
       mismatch_cnt++;
     end
//   end
     
   if(mismatch_cnt==0) begin
     fc_pass_pkt++;
     uvm_report_info("eth_scoreboard",$psprintf("PACKET %d pass ",fc_no_pkt),UVM_LOW);
   end
   else begin
     fc_fail_pkt++; 
     `uvm_error("eth_scoreboard",$psprintf("Packet no %d failed with %d errors",fc_no_pkt,mismatch_cnt));
     uvm_report_info(get_name(),$psprintf("compare_fc_pkt:Expected Transaction : \n",tx_pkt_f.print),UVM_LOW);
     uvm_report_info(get_name(),$psprintf("compare_fc_pkt:Actual   Transaction : \n",rx_pkt.print),UVM_LOW);
   end
 end
 mismatch_cnt=0; 
 compare_sem.put(1);
   
endtask: compare_fc_pkt 

task eth_scoreboard::compare_pkt();
   mismatch_cnt=0;

   compare_sem.get(1);
   //`uvm_report_fatal("eth_scoreboard",$psprintf("No tx packet while rx has arrived,q size= %h",q_tx.size),UVM_LOW);
   //else  
   tx_pkt_f=q_tx.pop_front;
   if(dl_en==1) tx_pkt_f_time=q_tx_time.pop_front;
   rx_pkt=q_rx.pop_front;
   if(dl_en==1) rx_pkt_time=q_rx_time.pop_front;
   pkt_time= (rx_pkt_time - tx_pkt_f_time)/1000;

	if (tx_pkt_f.is_ptp_seq && (tx_pkt_f.m_ptp_op != INS_2STEP) && (tx_pkt_f.m_ptp_op != INS_NOOP)) begin
   
      cf_offset_cmp_skip = 1;
      `uvm_info(get_type_name(), $psprintf("tx_pkt_f.cf_offset = %0h",tx_pkt_f.cf_offset),UVM_MEDIUM);
      
      if((tx_pkt_f.frame_type == ETH_DATA_FRAME) || (tx_pkt_f.frame_type == ETH_JUMBO_DATA_FRAME) || (tx_pkt_f.frame_type == ETH_IPV4_FRAME) || (tx_pkt_f.frame_type == ETH_IPV6_FRAME) || (tx_pkt_f.frame_type == ETH_USER_DEFINED_FRAME))
         cf_offset_sb = tx_pkt_f.cf_offset - 14 ;
      if ((tx_pkt_f.frame_type == ETH_VLAN_FRAME) || (tx_pkt_f.frame_type == ETH_JUMBO_VLAN_FRAME) )
           cf_offset_sb = tx_pkt_f.cf_offset  - 14 - 4;
      if ((tx_pkt_f.frame_type == ETH_STACKED_VLAN_FRAME) || (tx_pkt_f.frame_type == ETH_JUMBO_STACKED_VLAN_FRAME ))  
           cf_offset_sb = tx_pkt_f.cf_offset  - 14 - 8;
         
      cf_offset_tx_val = {tx_pkt_f.payload[cf_offset_sb],tx_pkt_f.payload[cf_offset_sb+1],tx_pkt_f.payload[cf_offset_sb+2],tx_pkt_f.payload[cf_offset_sb+3],tx_pkt_f.payload[cf_offset_sb+4],tx_pkt_f.payload[cf_offset_sb+5],tx_pkt_f.payload[cf_offset_sb+6],tx_pkt_f.payload[cf_offset_sb+7]};
      
      cf_offset_rx_val = {rx_pkt.payload[cf_offset_sb],rx_pkt.payload[cf_offset_sb+1],rx_pkt.payload[cf_offset_sb+2],rx_pkt.payload[cf_offset_sb+3],rx_pkt.payload[cf_offset_sb+4],rx_pkt.payload[cf_offset_sb+5],rx_pkt.payload[cf_offset_sb+6],rx_pkt.payload[cf_offset_sb+7]};
      
      `uvm_info(get_type_name(), $psprintf("cf values of rx value and tx value cf_offset_tx_val = %0h,cf_offset_rx_val= %0h",cf_offset_tx_val,cf_offset_rx_val),UVM_MEDIUM);
      
      //moving rx_packet cf_offset LSB byte to tx_packet cf_offset LSB byte to check crc calculations 
      tx_pkt_f.payload[cf_offset_sb] =rx_pkt.payload[cf_offset_sb];
      tx_pkt_f.payload[cf_offset_sb+1] =rx_pkt.payload[cf_offset_sb+1];
      tx_pkt_f.payload[cf_offset_sb+2] =rx_pkt.payload[cf_offset_sb+2];
      tx_pkt_f.payload[cf_offset_sb+3] =rx_pkt.payload[cf_offset_sb+3];
      tx_pkt_f.payload[cf_offset_sb+4] =rx_pkt.payload[cf_offset_sb+4];
      tx_pkt_f.payload[cf_offset_sb+5] =rx_pkt.payload[cf_offset_sb+5];
      tx_pkt_f.payload[cf_offset_sb+6] =rx_pkt.payload[cf_offset_sb+6];
      tx_pkt_f.payload[cf_offset_sb+7] =rx_pkt.payload[cf_offset_sb+7];
      `uvm_info(get_type_name(),$psprintf("payload data of cf_offset_sb=%h Tx EXP PAYLOAD=%h, ACT PAYLOAD= %h",cf_offset_sb,tx_pkt_f.payload[cf_offset_sb+7],rx_pkt.payload[cf_offset_sb+7]),UVM_MEDIUM);
      
      //cf offset LSB tolerance check  
      if(cf_offset_rx_val > cf_offset_tx_val ) begin  
         cf_offset_lsb_tol = cf_offset_rx_val- cf_offset_tx_val;
      end else begin
         cf_offset_lsb_tol = cf_offset_tx_val - cf_offset_rx_val;
      end
      
               if(cf_offset_lsb_tol <= (8'h80 +tx_pkt_f.ingress_ts[7:0])) begin
               `uvm_info(get_type_name(), $psprintf("cf_offset LSB byte tolerance cf_offset_lsb_tol = %0h,ingress_ts = %0h ",cf_offset_lsb_tol, tx_pkt_f.ingress_ts),UVM_MEDIUM);
      end else begin
               `uvm_error(get_type_name(), $psprintf("cf_offset LSB byte tolerance more than +/-80 cf_offset_lsb_tol = %0h",cf_offset_lsb_tol));
      end
      
      `uvm_info(get_type_name(),$psprintf("Before CRC Calculation TX_PKT_F.FCS %h",tx_pkt_f.fcs),UVM_MEDIUM);
      // Recalculated CRC for tx_pkt because of cf_offset LSB byte updated with rx_packet cf_offset LSB byte 
      tx_pkt_f.calc_crc32();
      `uvm_info(get_type_name(),$psprintf("After crc calculation TX_PKT_F.FCS %h",tx_pkt_f.fcs),UVM_MEDIUM);
      
      `uvm_info(get_type_name(),$psprintf("Before CRC Calculation RX_PKT_F.FCS %h",rx_pkt.fcs),UVM_MEDIUM);
      //------CRC calculations done for rx_pkt once, find the issue with revers fcs need to remove rx_pkt CRC calculations--------
      rx_pkt.calc_crc32();
      `uvm_info("eth_scoreboard",$psprintf("After crc calculation of rx_pkt RX_PKT_F.FCS %h",rx_pkt.fcs),UVM_MEDIUM);
            
   end //tx_pkt_f.is_ptp_seq
   else begin
      cf_offset_cmp_skip = 0;
   end
   
   `uvm_info(get_name(),$psprintf("MS_DBG : expected transaction\n %s",tx_pkt_f.sprint()), UVM_MEDIUM) 
   `uvm_info(get_name(),$psprintf("MS_DBG : actual transaction\n %s",rx_pkt.sprint()), UVM_MEDIUM)

   `uvm_info(get_type_name(), $psprintf("tx_error_insertion_test = %0d",tx_error_insertion_test),UVM_MEDIUM);
  
   // DM : vip_malformed sequence injects "FE" control characters in between frame.
   // RTL will xor corresponding previous cycle lane0/1/2/3 data with 'hF based on in which lane FE character is received.
   // TB prediction will be difficult.. So comparing only payload size instead of data.
   if(m_sequence == "vip_malformed_packet_sequence" || m_sequence == "vip_malformed_packet_sequence2") begin
      `uvm_info(get_type_name(),$sformatf(" Inside vip_malformed_packet_sequence: comparing only payloadsize"),UVM_MEDIUM);
       assert(tx_pkt_f.payload.size==rx_pkt.payload.size)
       else begin
         `uvm_error("eth_scoreboard",$psprintf("payload size Mismatch:Tx Payload size=%d, Rx Payload size= %d",tx_pkt_f.payload.size,rx_pkt.payload.size));
         mismatch_cnt++;
       end
   end else if(tx_pkt_f.seen_tx_error_insertion == 1 && rx_pkt.seen_tx_error_insertion ==1 && tx_error_insertion_test) begin
      `uvm_info(get_type_name(), $psprintf("Tx error is inserted , skipping comparision for this frame : rx_pkt_cnt = %0d",rx_pkt_cnt),UVM_LOW);
      skip_comparison_no_pkt++;
   end
   else if(tx_pkt_f.seen_tx_error_insertion == 1 && rx_pkt.seen_tx_error_insertion !=1 && tx_error_insertion_test) begin
      `uvm_error(get_type_name(), $sformatf("Tx error is inserted ,but tx error is not seen in rx  : rx_pkt_cnt = %0d",rx_pkt_cnt));
      skip_comparison_no_pkt++;
   end else begin
      if(tx_pkt_f.ignore_pkt && tx_pkt_f.transaction_id==rx_pkt.transaction_id) begin
         uvm_report_info("eth_scoreboard",$psprintf("with crc insert 0,length <46,packet not to be compared.crc_insert: %d ",dyn_rcfg_obj_inst.crc_pass),UVM_LOW);
         skip_comparison_no_pkt++;
      end else begin
         no_pkt++;
         //if(dyn_rcfg_obj_inst.preamble_passthrough) begin
         assert(tx_pkt_f.preamble==rx_pkt.preamble)
	      else begin
            `uvm_error("eth_scoreboard",$psprintf("Preamble Mismatch:Tx Preamble=%h, Rx Preamble= %h",tx_pkt_f.preamble,rx_pkt.preamble));
            mismatch_cnt++;
	      end
         //end
         //else uvm_report_info("eth_scoreboard",$psprintf("Preamble not compared.Preamble_passthrough: %d ",dyn_rcfg_obj_inst.preamble_passthrough),UVM_LOW);
	 
         if (!tx_pkt_f.rx_error[0]) begin // not malformed
            assert(tx_pkt_f.dest_address==rx_pkt.dest_address)
            else begin
               `uvm_error("eth_scoreboard",$psprintf("DESTINATION ADDRESS Mismatch:Tx Dest Addr=%h, Rx Dest_Addr= %h",tx_pkt_f.dest_address,rx_pkt.dest_address));
               mismatch_cnt++;
            end 
	    
            assert(tx_pkt_f.src_address==rx_pkt.src_address)
            else begin
               `uvm_error("eth_scoreboard",$psprintf("SOURCE ADDRESS Mismatch:Tx Src Addr=%h, Rx Src Addr= %h",tx_pkt_f.src_address,rx_pkt.src_address));
               mismatch_cnt++;
            end 
            if(tx_pkt_f.m_ptp_kind != PTP_ERR) begin 
               assert(tx_pkt_f.eth_type_or_length==rx_pkt.eth_type_or_length)
               else begin
                  `uvm_error("eth_scoreboard",$psprintf("ETH TYPE OR LEN Mismatch:Tx Eth type or len=%h, Rx Eth type or Len= %h",tx_pkt_f.eth_type_or_length,rx_pkt.eth_type_or_length));
                  mismatch_cnt++;
               end // UNMATCHED !!
            end
			if(dl_en==1)begin
				assert( (pkt_time >= (pkt_path_delay -5) ) && (pkt_time <= (pkt_path_delay +5) ))
				else 
				`uvm_error("eth_scoreboard",$psprintf("Path delay Mismatch:Pkt rx@%f, tx@%f, actual delay=%f, calculated path delay=%f",rx_pkt_time,tx_pkt_f_time, pkt_time, pkt_path_delay));
			end
         end // if (!tx_pkt_f.rx_error[0])
	
         if(tx_pkt_f.seen_tx_fcs_error_insertion==1) begin
            if(rx_pkt.seen_rx_fcs_error_insertion != 1) begin
               `uvm_error(get_type_name(), $sformatf("Expected tx fcs error is not seen at vip rx : seen_fcs_error = %0d",rx_pkt.seen_tx_fcs_error_insertion));
               mismatch_cnt++;
            end
         end
         if(tx_pkt_f.seen_tx_fcs_error_insertion!=1) begin
            if(rx_pkt.seen_rx_fcs_error_insertion == 1) begin
               `uvm_error(get_type_name(), $sformatf("Unexpected tx fcs error is seen at vip rx : seen_fcs_error = %0d",rx_pkt.seen_tx_fcs_error_insertion));
               mismatch_cnt++;
            end
         end
	 
         if (!tx_pkt_f.rx_error[0]) begin // not malformed
            `uvm_info(get_type_name(), $psprintf("ST1b: tx_pkt_f Txpacket Size=%0d", tx_pkt_f.payload.size),UVM_LOW);
            `uvm_info(get_type_name(), $psprintf("ST1b: rx_pkt Rxpacket Size=%0d", rx_pkt.payload.size),UVM_LOW);

            assert(tx_pkt_f.payload.size==rx_pkt.payload.size) begin
               foreach(tx_pkt_f.payload[i])`uvm_info(get_type_name(), $psprintf("tx payload[%d]=%h,rx payload=%h",i,tx_pkt_f.payload[i],rx_pkt.payload[i]),UVM_DEBUG);
                  
               if(tx_pkt_f.m_ptp_kind != PTP_ERR) begin
                  foreach(tx_pkt_f.payload[i])  begin
                     if(((i==cf_offset_sb) ||(i==cf_offset_sb+1)||(i==cf_offset_sb+2)||(i==cf_offset_sb+3)||(i==cf_offset_sb+4)||(i==cf_offset_sb+5)||(i==cf_offset_sb+6)||(i==cf_offset_sb+7)) && cf_offset_cmp_skip ) begin
                        `uvm_info("eth_scoreboard",$psprintf("skip cf_offset value  frm payload loop.Data[%h] match:Tx Data=%h, Rx Data= %h",i,tx_pkt_f.payload[i],rx_pkt.payload[i]),UVM_MEDIUM);
                     end else  begin
                        if(tx_pkt_f.payload[i]==rx_pkt.payload[i]) begin
                           `uvm_info("eth_scoreboard",$psprintf("  payload loop.Data[%d] match:Tx Data=%h, Rx Data= %h",i,tx_pkt_f.payload[i],rx_pkt.payload[i]),UVM_HIGH);
                        end else begin
                           `uvm_error("eth_scoreboard",$psprintf("will break frm payload loop.Data[%d] Mismatch:Tx Data=%h, Rx Data= %h",i,tx_pkt_f.payload[i],rx_pkt.payload[i]));
                           mismatch_cnt++;
                           break;
                        end 
         
                     end
                  end //foreach(tx_pkt_f.payload[i])
               end 
               else begin 
                  `uvm_info("eth_scoreboard",$psprintf("payload comparison is disabled for frames which have invalid ptp operation : ptp_operation = %s",tx_pkt_f.m_ptp_op),UVM_NONE);
               end
            end else begin
            if(tx_pkt_f.seen_len_err_with_pad_removal == 1'b1) begin
              `uvm_info("eth_scoreboard",$psprintf("Payload checking disabled due to undefined RTL behavior HSD#16015012533, Tx payload size=%d, Rx payload size= %d, eth_etype_lenth of Tx packet = %0d",tx_pkt_f.payload.size,rx_pkt.payload.size,tx_pkt_f.eth_type_or_length),UVM_LOW);
            end else begin
               `uvm_error("eth_scoreboard",$psprintf("payload size Mismatch:Tx Payload size=%d, Rx Payload size= %d",tx_pkt_f.payload.size,rx_pkt.payload.size));
            
               mismatch_cnt++;
             end
            end // else: !if(rx_pkt.seen_rx_fcs_error_insertion == 1)
         end // if (!tx_pkt_f.rx_error[0])
	    
         if (!tx_pkt_f.rx_error[0] 
         && !tx_pkt_f.rx_error[1] && tx_pkt_f.m_ptp_kind != PTP_ERR)// no fcs erro// not malformedr
         begin
            `uvm_info("eth_scoreboard",$psprintf("Tx FCS=%h, Rx FCS= %h",tx_pkt_f.fcs,rx_pkt.fcs),UVM_MEDIUM); //for debug
         assert(tx_pkt_f.fcs==rx_pkt.fcs)
         else begin
            `uvm_error("eth_scoreboard",$psprintf("FCS Mismatch:Tx FCS=%h, Rx FCS= %h",tx_pkt_f.fcs,rx_pkt.fcs));
            mismatch_cnt++;
         end
      end
      
      if (dyn_rcfg_obj_inst.mode == PCSMAC) begin
// TBD FIXME Commented to bypass error_bit check till HSD 16010992360 resolves
         assert(tx_pkt_f.rx_error[1:0]==rx_pkt.rx_error[1:0])
         else begin
            `uvm_error("eth_scoreboard",$psprintf("RX Error bits 0,1 Mismatch: Expected Error vector=%h, Actual Error vector = %h",tx_pkt_f.rx_error,rx_pkt.rx_error));
            mismatch_cnt++;
         end // else: !if(!tx_pkt_f.rx_error[0]...

         // If malformed, not required to check rest of the bits
         if (tx_pkt_f.rx_error[0] == 1'b0) begin
//`ifdef G50
            if (dyn_rcfg_obj_inst.speed==_50G) 
               assert(tx_pkt_f.rx_error[5:0]==rx_pkt.rx_error[5:0])
//`else
               else assert(tx_pkt_f.rx_error[1:0]==rx_pkt.rx_error[1:0] && tx_pkt_f.rx_error[5:4]==rx_pkt.rx_error[5:4] )//SHABBIR
//`endif 
                  else begin
                     `uvm_error("eth_scoreboard",$psprintf("RX Error Mismatch: Expected Error vector=%h, Actual Error vector = %h",tx_pkt_f.rx_error,rx_pkt.rx_error));
                     mismatch_cnt++;
                  end // else: !if(!tx_pkt_f.rx_error[0]...
         end
      end	 
      if(mismatch_cnt==0) begin
         pass_pkt++;
         uvm_report_info("eth_scoreboard",$psprintf("PACKET %d pass ",no_pkt),UVM_LOW);
      end
      else begin
         fail_pkt++; 
         `uvm_error("eth_scoreboard",$psprintf("Packet no %d failed with %d errors",no_pkt,mismatch_cnt));
               uvm_report_info(get_name(),$psprintf("compare_pkt:Expected Transaction : %s \n",tx_pkt_f.sprint(printer)),UVM_NONE);
               uvm_report_info(get_name(),$psprintf("compare_pkt:Actual   Transaction : %s \n",rx_pkt.sprint(printer)),UVM_NONE);
   
      end
      mismatch_cnt=0; 

      end // else: !if(tx_pkt_f.ignore_pkt && tx_pkt_f.transaction_id==rx_pkt.transaction_id)
   end
   compare_sem.put(1);
   
endtask: compare_pkt

function void eth_scoreboard::flush();//modified
   string func_name = "flush";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
   
  uvm_report_info(get_name(),$psprintf("Before flushing "),UVM_HIGH);
  uvm_report_info(get_name(),$psprintf("q_tx size=%d q_rx size=%d",q_tx.size,q_rx.size),UVM_HIGH);
  uvm_report_info(get_name(),$psprintf("tx_pkt_cnt=%d rx_pkt_cnt=%d",tx_pkt_cnt,rx_pkt_cnt),UVM_HIGH);
  uvm_report_info(get_name(),$psprintf("pause_q_tx size=%d pause_q_rx size=%d",pause_q_tx.size,pause_q_rx.size),UVM_HIGH);
  uvm_report_info(get_name(),$psprintf("fc_tx_pkt_cnt=%d fc_rx_pkt_cnt=%d",fc_tx_pkt_cnt,fc_rx_pkt_cnt),UVM_HIGH);
  tx_pkt_cnt=tx_pkt_cnt-q_tx.size();
  rx_pkt_cnt=rx_pkt_cnt-q_rx.size();
  q_tx={};
  if(dl_en==1) q_tx_time={};
  q_rx={};
  fc_tx_pkt_cnt=fc_tx_pkt_cnt-pause_q_tx.size();
  fc_rx_pkt_cnt=fc_rx_pkt_cnt-pause_q_rx.size();
  pause_q_tx={};
  pause_q_rx={};
  uvm_report_info(get_name(),$psprintf("tx & rx queue flushed"),UVM_LOW);
  uvm_report_info(get_name(),$psprintf("q_tx size=%d q_rx size=%d",q_tx.size,q_rx.size),UVM_LOW);
  uvm_report_info(get_name(),$psprintf("tx_pkt_cnt=%d rx_pkt_cnt=%d",tx_pkt_cnt,rx_pkt_cnt),UVM_LOW);
  uvm_report_info(get_name(),$psprintf("pause_q_tx size=%d pause_q_rx size=%d",pause_q_tx.size,pause_q_rx.size),UVM_LOW);
  uvm_report_info(get_name(),$psprintf("fc_tx_pkt_cnt=%d fc_rx_pkt_cnt=%d",fc_tx_pkt_cnt,fc_rx_pkt_cnt),UVM_LOW);
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
endfunction
 

function void eth_scoreboard::report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("===================================SCOREBOARD REPORT FOR THIS RUN =================================\n");
    $display("===================================DATA PACKETS =================================\n");
 `uvm_info("SBRPT", $psprintf("TOTAL PACKETS COMPARED:%d,TX PACKETS= %d,RX PACKETS=%d,PACKETS PASS = %0d, PACKETS FAIL = %0d , COMPARISION SKIPPED PACKETS = %0d\n",no_pkt,tx_pkt_cnt,rx_pkt_cnt,pass_pkt,fail_pkt,skip_comparison_no_pkt),UVM_NONE);
    $display("===================================FLOW CONTROL PACKETS =================================\n");
 `uvm_info("SBRPT", $psprintf("TOTAL PACKETS COMPARED:%d,TX PACKETS= %d,RX PACKETS=%d,PACKETS PASS = %0d, PACKETS FAIL = %0d , COMPARISION SKIPPED PACKETS = %0d",fc_no_pkt,fc_tx_pkt_cnt,fc_rx_pkt_cnt,fc_pass_pkt,fc_fail_pkt,skip_comparison_fc_no_pkt),UVM_NONE);
endfunction:report_phase

function void eth_scoreboard::check_phase(uvm_phase phase);
    super.check_phase(phase);
    if(q_tx.size) begin
            `uvm_error("eth_scoreboard",$psprintf(" %d More TX Packets received than RX",q_tx.size()));
    end
    if(pause_q_tx.size) `uvm_error("eth_scoreboard",$psprintf(" %d More TX Packets received than RX",pause_q_tx.size()));
    if(rx_pkt_cnt > tx_pkt_cnt && (dyn_rcfg_obj_inst.skew_test == 0)) `uvm_error(get_full_name(),$sformatf("%0d More RX Packets received than TX",(rx_pkt_cnt-tx_pkt_cnt)))
    if(fc_rx_pkt_cnt > fc_tx_pkt_cnt && (dyn_rcfg_obj_inst.skew_test == 0)) `uvm_error(get_full_name(),$sformatf("%0d More RX flow control Packets received than TX",(fc_rx_pkt_cnt-fc_tx_pkt_cnt)))
 $fclose(file_exp_log_id);
 $fclose(file_exp_log_id_1);
 $fclose(file_act_log_id);
 $fclose(file_act_log_id_1);
$fclose(file_bandwidth); 
$fclose(file_latency);   
endfunction:check_phase

`endif // ETH_SCOREBOARD__SV
