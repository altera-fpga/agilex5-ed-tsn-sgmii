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


typedef  bit[95:0] bit96;
module ptp_tx_rtb_module(ptp_tx_interface mon_if,client_tx_if v_if_seg, input int inst_num);

  import uvm_pkg::*;
   `include "uvm_macros.svh"
   import eth_env_pkg::*;
   
   string speed;

 //  logic tx_word_align[4:0];
 //  logic [63:0] tx_mii_d[4:0];
 //  logic [7:0] tx_mii_c[4:0];
 //  logic tx_mii_valid[4:0];
 //  logic tx_am_valid[4:0];
 //  logic tx_mii_clk[4:0];
 //  logic rx_word_align[4:0];
 //  logic [63:0] rx_mii_d[4:0];
 //  logic [7:0] rx_mii_c[4:0];
 //  logic rx_mii_valid[4:0];
 //  logic rx_am_valid[4:0];
 //  logic rx_mii_clk[4:0];
 //  logic tx_load_data_valid[4:0];
 //  logic tx_tam_adj_load_data_valid[4:0];
 //  logic [95:0]tx_load_data[4:0];
 //  logic [95:0]tx_tam_adj_load_data[4:0];

 //  logic rx_load_data_valid[4:0];
 //  logic rx_tam_adj_load_data_valid[4:0];
 //  logic [95:0]rx_load_data[4:0];
 //  logic [95:0]rx_tam_adj_load_data[4:0];

 //  logic i_tx_ptp_sync_am;
 //  logic i_tx_ptp_async_pulse;
 //  logic i_rx_ptp_async_pulse;

   time rx_async_pulse;

   int node;
   bit start_find_eop_tx;
   bit start_find_eop_rx;

   assign tx_ptp_ready_ip0 = eth_env_top.dut.o_tx_ptp_ready_ip0;
   assign rx_ptp_ready_ip0 = eth_env_top.dut.o_rx_ptp_ready_ip0;
 
//   `include "acc_mon_sig_assigns.sv"
    //25G acc testing

   
  class ptp_tx_monitor_concrete extends ptp_tx_monitor_abstract;
    uvm_reg  regs;
    uvm_reg_data_t read_data;
    int num_words;
   // dyn_rcfg dyn_rcfg_obj_inst;
    int valid_width;
    int transaction_id=0;
    int wb_rx_transaction_id=0;
    int wb_tx_transaction_id=0;

    bit [95:0] last_ptp_its = 0;
    bit [47:0] diff_its = 0; // Assuming difference will not be in seconds
    bit [95:0] q_ptp_tx[$],q_ptp_rx_ing[$];
    bit dis_ptp_accuracy = 1'b0;
    bit [95:0] o_ptp_ets;
    bit [95:0] ts_diff_hex;
    int num_ptp_pkts = 0 ;
    int num_pkts = 0 ;
    int num_rx_ing_pkts = 0 ;
    eth_packet tx_eth_frame_q[$];
    eth_packet tx_eth_frame_mailbox_item;
    bit[95:0] rx_ing_ts = 0;
    bit[95:0] tx_egr_ts = 0;
    eth_packet local_eth_packet;  
    bit tx_am_insert,rx_am_insert;


   // virtual spy_interface    spy_if;
   // virtual reset_if rst_if;

    
    ptp_tx_tran m_tran;
    ptp_tx_tran m_tran_rx;
    ptp_tx_tran m_tran_wb;
    ptp_tx_tran m_tran_wb_rx;




    extern task collect_tran;
    extern task rx_ptp_monitor;
    extern task ptp_accuracy_monitor;
    extern task num_words_update;
    extern task bit_width_update();

  endclass


  class ptp_tod_drv_concrete extends ptp_tod_drv_abstract;

  bit [47:0] tod_secs,ing_secs;
  bit [31:0] tod_nsecs,ing_nsecs;
  bit [15:0] tod_fnsecs;
  int ing_ref_ns=0;
  logic ptp_cf_r;

    extern function bit96 get_tod_timestamp;
    extern function bit96 get_ing_timestamp;
    extern task drv_tod_timestamp;
    extern task drv_ing_timestamp;
    extern task update_tod_ns;
	extern task update_tod_seconds;
    extern task update_ing_ns;
	extern task update_ing_seconds;
    extern task drv_rx_tod;
    extern task seg_tx_tod_drv;
    extern task drv_tx_its;
    extern task drv_seg_rx_tod;
    extern function clear_all_ts;

  endclass
  
   task ptp_tx_monitor_concrete::collect_tran();

      int node_25g;
      int node_200g;
      node_25g = (inst_num == 0) ? 15:
                 (inst_num == 1) ? 16:
                 (inst_num == 2) ? 17:
                 (inst_num == 3) ? 18:
                 (inst_num == 4) ? 19:
                 (inst_num == 5) ? 20:
                 (inst_num == 6) ? 21:
                 (inst_num == 7) ? 22:
                 (inst_num == 8) ? 23:
                 (inst_num == 9) ? 24:
                 (inst_num == 10) ? 25:
                 (inst_num == 11) ? 26:
                 (inst_num == 12) ? 27:
                 (inst_num == 13) ? 28:
                 (inst_num == 14) ? 29: 30;
      node_200g = (inst_num == 0) ? 1:
                  (inst_num == 1) ? 2: 1;

      fork 
      begin forever @(mon_if.mon_tx_cb)
      begin
         //TODO: for different non default node
         node  = ( dyn_rcfg_obj_inst.speed == _10G || dyn_rcfg_obj_inst.speed == _25G) ? (($test$plusargs("ETH17A_21"))?17:(($test$plusargs("ETH17A_20"))?18:node_25g)):
            (dyn_rcfg_obj_inst.speed == _50G) ? 7:
            (dyn_rcfg_obj_inst.speed == _100G) ? 3:
            (dyn_rcfg_obj_inst.speed == _200G) ? node_200g: 0;
         //`uvm_info(get_full_name(),$sformatf("Node selected is %0d, inst_num is %0d", node, inst_num), UVM_MEDIUM)
      end
      end
   begin
      forever begin
         @(mon_if.mon_tx_cb);
         //`uvm_info(get_full_name(),$sformatf("o_ptp_ets_valid %d", mon_if.mon_tx_cb.o_ptp_ets_valid), UVM_LOW)
         // Seg rule is from LSB to MSB
         //foreach(mon_if.mon_tx_cb.o_ptp_ets_valid[i])begin
         for(int i=0; i< valid_width ; i++)begin
            if(mon_if.mon_tx_cb.o_ptp_ets_valid[i]) begin
               m_tran = ptp_tx_tran::type_id::create("m_tran");
               m_tran.o_ptp_ets = mon_if.mon_tx_cb.o_ptp_ets[(i*96) +:96];
               //m_tran.o_ptp_ets_fp =  mon_if.mon_tx_cb.o_ptp_ets_fp[(i*8) +: 8];
					
               for(int j=0; j<dyn_rcfg_obj_inst.fp_width ; j++)begin
                  m_tran.o_ptp_ets_fp[j] =  mon_if.mon_tx_cb.o_ptp_ets_fp[i*dyn_rcfg_obj_inst.fp_width+j];
               end
					
               m_tran.o_ptp_ets_vl =  mon_if.mon_tx_cb.o_ptp_ets_vl[(i*5) +: 5];
               m_tran.o_ptp_ets_valid =  mon_if.mon_tx_cb.o_ptp_ets_valid[i];
               transaction_id = transaction_id + 1; //Increment the transaction id
               m_tran.transaction_id = transaction_id; 
               //m_ap.write(m_tran);
               mmbox_tx.put(m_tran);
               `uvm_info(get_full_name(),$sformatf("Vector Collected transaction Tx ->\n%0s", m_tran.sprint()), UVM_MEDIUM)
            end//if
         end
      end//forever
   end
   begin
      forever begin
         @(mon_if.mon_rx_cb);
         //foreach(mon_if.mon_rx_cb.o_ptp_rx_its_valid[i]) begin
         for(int i=0; i< valid_width ; i++)begin
            //if (mon_if.mon_rx_cb.o_ptp_rx_sop & mon_if.mon_rx_cb.o_ptp_rx_its_valid[i] & mon_if.mon_rx_cb.o_ptp_rx_valid) begin
            if (((mon_if.mon_rx_cb.o_ptp_rx_sop[i] & mon_if.mon_rx_cb.o_ptp_rx_its_valid[i] & mon_if.mon_rx_cb.o_ptp_rx_valid) && ($test$plusargs("PTP_DEBUG_ACC_EN"))) || 
               ((mon_if.mon_rx_cb.o_ptp_rx_sop[i] & mon_if.mon_rx_cb.o_ptp_rx_valid) && (!($test$plusargs("PTP_DEBUG_ACC_EN"))))) begin            
               m_tran_rx = ptp_tx_tran::type_id::create("m_tran_rx");
               m_tran_rx.o_ptp_its_vl_valid = mon_if.mon_rx_cb.o_ptp_rx_its_valid[i];
               m_tran_rx.o_ptp_its_vl = mon_if.mon_rx_cb.o_ptp_its_vl[(i*5) +: 5];
               //m_rx_ap.write(m_tran_rx);
               mmbox_rx.put(m_tran_rx);
               `uvm_info(get_full_name(),$sformatf("Vector Collected transaction Rx ->\n%0s", m_tran_rx.sprint()), UVM_MEDIUM)
            end//if
         end//foreach
      end//forever
   end
   begin
      forever begin
         @(negedge spy_if.tx_mac_clk[node]);
            if(spy_if.wb_tx_ets_valid[node]==1) begin
               m_tran_wb = ptp_tx_tran::type_id::create("m_tran_wb");
               m_tran_wb.i_ptp_ets_vl_valid = spy_if.wb_tx_ets_valid[node];
               m_tran_wb.i_ptp_ets_vl = spy_if.wb_tx_ets_vl[node];
               wb_tx_transaction_id = wb_tx_transaction_id + 1; //Increment the transaction id
               m_tran_wb.transaction_id = wb_tx_transaction_id;
               //m_wb_ap.write(m_tran_wb);
               mmbox_wb_tx.put(m_tran_wb);
               `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO: inst_num = ip%0d, Tx VL =%0d, pkt_cnt=%0d ",inst_num, spy_if.wb_tx_ets_vl[node], wb_tx_transaction_id), UVM_MEDIUM);             
               `uvm_info(get_full_name(),$sformatf("Vector Collected transaction Tx wb VL ->\n%0s", m_tran_wb.sprint()), UVM_MEDIUM)
            end //if
      end//forever
   end
   begin
      forever begin
         @(negedge spy_if.rx_mac_mii_clk[node]); 
            if(spy_if.wb_rx_its_valid[node]==1) begin
               m_tran_wb_rx = ptp_tx_tran::type_id::create("m_tran_wb_rx");
               m_tran_wb_rx.i_ptp_its_vl_valid = spy_if.wb_rx_its_valid[node];
               m_tran_wb_rx.i_ptp_its_vl = spy_if.wb_rx_its_vl[node];
               wb_rx_transaction_id = wb_rx_transaction_id + 1; //Increment the transaction id
               m_tran_wb_rx.transaction_id = wb_rx_transaction_id;
               //m_wb_rx_ap.write(m_tran_wb_rx);
               mmbox_wb_rx.put(m_tran_wb_rx);
               `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO: inst_num = ip%0d, Rx VL =%0d, pkt_cnt=%0d ",inst_num, spy_if.wb_rx_its_vl[node], wb_rx_transaction_id), UVM_MEDIUM);             
               `uvm_info(get_full_name(),$sformatf("Vector Collected transaction Rx wb VL ->\n%0s", m_tran_wb_rx.sprint()), UVM_MEDIUM)
         end //if
      end//forever
   end

  join
  endtask

  task ptp_tx_monitor_concrete::rx_ptp_monitor();
     int frame_cnt;
      int sop_idle_cnt;

      forever begin
         @(posedge mon_if.rx_clk);
         if(!(spy_if.its_check_disable)) begin
         //foreach (mon_if.o_ptp_rx_its_valid[i]) begin
         for(int i=0; i< valid_width ; i++)begin
            //if (mon_if.o_ptp_rx_sop & mon_if.o_ptp_rx_its_valid[i] & mon_if.o_ptp_rx_valid) begin
            if (((mon_if.mon_rx_cb.o_ptp_rx_sop[i] & mon_if.mon_rx_cb.o_ptp_rx_its_valid[i] & mon_if.mon_rx_cb.o_ptp_rx_valid) && ($test$plusargs("PTP_DEBUG_ACC_EN"))) || 
                ((mon_if.mon_rx_cb.o_ptp_rx_sop[i] & mon_if.mon_rx_cb.o_ptp_rx_valid) && (!($test$plusargs("PTP_DEBUG_ACC_EN"))))) begin            
               if (last_ptp_its > mon_if.o_ptp_rx_its) begin
                 if(last_ptp_its[95:48] == mon_if.o_ptp_rx_its[95:48]) begin // Ignore if there is seconds rollover
                    `uvm_info (get_full_name(), $sformatf("++++ Last RX-PTP TS=0x%0X and Current RX-PTP TS=0x%0X ++++",last_ptp_its, mon_if.o_ptp_rx_its), UVM_NONE)
                    diff_its = last_ptp_its - mon_if.o_ptp_rx_its;
   `ifdef SER_MON_EN
   `ifdef RSFEC
                    if (diff_its[47:16] > 100) // w/FEC accuracy mode - report error if diff > 100 ns 
                       `uvm_error(get_full_name(), $sformatf("ACC - Last RX-PTP TS is greater than Current RX-PTP +++ Diff=%0d.%0d ns - Cycles_Between_SOPs=%0d ++++",diff_its[47:16],(diff_its[15:0]/65536.0*10000),sop_idle_cnt))
                    else 
                       `uvm_warning(get_full_name(), $sformatf("ACC - Last RX-PTP TS is greater than Current RX-PTP +++ Diff=%0d.%0d ns - Cycles_Between_SOPs=%0d ++++",diff_its[47:16],(diff_its[15:0]/65536.0*10000),sop_idle_cnt))
   `else
                    if (diff_its[47:16] > 180) // w/o FEC accuracy mode - report error if diff > 180 ns 
                       `uvm_error(get_full_name(), $sformatf("ACC - Last RX-PTP TS is greater than Current RX-PTP +++ Diff=%0d.%0d ns - Cycles_Between_SOPs=%0d ++++",diff_its[47:16],(diff_its[15:0]/65536.0*10000),sop_idle_cnt))
                    else 
                       `uvm_warning(get_full_name(), $sformatf("ACC - Last RX-PTP TS is greater than Current RX-PTP +++ Diff=%0d.%0d ns - Cycles_Between_SOPs=%0d ++++",diff_its[47:16],(diff_its[15:0]/65536.0*10000),sop_idle_cnt))
   `endif
   `else
   `ifdef ENABLE_ETH_VIP
                    if (sop_idle_cnt <= 10) begin
                       if (diff_its[47:16] <= 1) 
                        `uvm_warning(get_full_name(), $sformatf("Last RX-PTP TS is greater than Current RX-PTP +++ Diff=%0d.%0d ns - Cycles_Between_SOPs=%0d ++++",diff_its[47:16],(diff_its[15:0]/65536.0*10000),sop_idle_cnt))
                       else   
                        `uvm_error(get_full_name(), $sformatf("Last RX-PTP TS is greater than Current RX-PTP +++ Diff=%0d.%0d ns - Cycles_Between_SOPs=%0d ++++",diff_its[47:16],(diff_its[15:0]/65536.0*10000),sop_idle_cnt))
                    end else //if (sop_idle_cnt <= 10) begin
                        `uvm_error(get_full_name(), $sformatf("Last RX-PTP TS is greater than Current RX-PTP +++ Diff=%0d.%0d ns - Cycles_Between_SOPs=%0d ++++",diff_its[47:16],(diff_its[15:0]/65536.0*10000),sop_idle_cnt))
   `else
                    `uvm_warning(get_full_name(), $sformatf("BW MODE - Last RX-PTP TS is greater than Current RX-PTP +++ Diff=%0d.%0d ns - Cycles_Between_SOPs=%0d ++++",diff_its[47:16],(diff_its[15:0]/65536.0*10000),sop_idle_cnt))
   `endif
   `endif      
                 end //if(last_ptp_its[95:48] == mon_if.o_ptp_rx_its[95:48])
               end //if (last_ptp_its > mon_if.o_ptp_rx_its)
               else 
                    `uvm_info(get_full_name(), $sformatf("Current RX-PTP TS=0x%0X and Last RX-PTP TS=0x%0X...",mon_if.o_ptp_rx_its, last_ptp_its), UVM_MEDIUM)
   
               last_ptp_its = mon_if.o_ptp_rx_its[(i*96) +:96];
               sop_idle_cnt = 0;
               frame_cnt++;
               // For PTP Accuracy checks.
               `uvm_info(get_name(), 
                  $sformatf("C3DV_PTP_INFO: inst_num = ip%0d, lane_en_num=0_0,Packet->%0d, act_rx_ts=x%0x", 
                      inst_num, frame_cnt, last_ptp_its), UVM_NONE)
            end else begin //if (mon_if.o_ptp_rx_sop & mon_if.o_ptp_rx_valid[i])
               sop_idle_cnt++;
            end //else  
         end //foreach (mon_if.o_ptp_rx_valid[i])
      end
    end
  endtask

  task ptp_tx_monitor_concrete::ptp_accuracy_monitor();


    num_ptp_pkts = 0 ;                                                                         
   num_pkts = 0 ;
   num_rx_ing_pkts = 0;

   //get the am_insert value from hip registers
   //DM_TODO: regs =reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,dyn_rcfg_obj_inst.speed),1 );
   read_data = regs.get();

   tx_am_insert = read_data[4];
   rx_am_insert = read_data[25];

   `uvm_info(get_full_name(), $sformatf("TX use_am_insert = %0d, RX use_am_insert = %0d",tx_am_insert, rx_am_insert), UVM_MEDIUM)
 
 
   //`ifndef ENABLE_ETH_VIP
   fork
     begin
        forever begin
  	   mmbox_from_layer_agent.get(tx_eth_frame_mailbox_item) ;
           if(!(spy_if.ptp_acc_check_disable)) begin
              tx_eth_frame_q.push_back(tx_eth_frame_mailbox_item)   ;
           end
	end
      end
      begin
         forever begin
            @(mon_if.tx_clk);
            // venkatkx : need to fix reset_if.recfg_rst_n
            //@(negedge reset_if.tx_rst_n & reset_if.rx_rst_n & reset_if.csr_rst_n & reset_if.recfg_rst_n);
            //if ( (reset_if.tx_rst_n == 1'b0) | (reset_if.rx_rst_n == 1'b0) | (reset_if.csr_rst_n == 1'b0)/* | (reset_if.recfg_rst_n == 1'b0)*\ ) begin
            if ( (rst_if.tx_rst_n == 1'b0) | (rst_if.rx_rst_n == 1'b0) | (rst_if.csr_rst_n == 1'b0)) begin
               q_ptp_tx={};
//             `uvm_info(get_type_name(), $sformatf("q_ptp_tx size %d: ",q_ptp_tx.size), UVM_NONE);
//             `uvm_info(get_type_name(), $sformatf("tx queue flushed"),UVM_NONE);
            end
         end
      end
      begin
         //Store TX Egress TS
         forever begin
            @(mon_if.mon_tx_cb);
            if(!(spy_if.ptp_acc_check_disable)) begin
               for(int i=0; i< valid_width ; i++)begin
                  if(mon_if.mon_tx_cb.o_ptp_ets_valid[i]) begin
                     q_ptp_tx.push_back(mon_if.mon_tx_cb.o_ptp_ets[(i*96) +:96]);
                     `uvm_info(get_type_name(), $sformatf("q_ptp_tx size %d: ",q_ptp_tx.size), UVM_NONE);
                     num_ptp_pkts++;
                     `uvm_info(get_type_name(), $sformatf("num_ptp_pkts  %d: ",num_ptp_pkts), UVM_NONE);
                     //For VIP
                     `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO: egr_ptp_tx_ts=0x%x, egr_ts_cnt=%0d ",mon_if.mon_tx_cb.o_ptp_ets[(i*96) +:96], num_ptp_pkts), UVM_NONE);             
                  end
               end
            end
         end
      end
      begin
         //Store RX Ingress TS
         forever begin
            @(mon_if.mon_rx_cb);
            if(!(spy_if.ptp_acc_check_disable)) begin
               for(int i=0; i< valid_width ; i++)begin
                  //if (mon_if.mon_rx_cb.o_ptp_rx_sop & mon_if.mon_rx_cb.o_ptp_rx_its_valid[i] & mon_if.mon_rx_cb.o_ptp_rx_valid) begin
                  if (((mon_if.mon_rx_cb.o_ptp_rx_sop[i] & mon_if.mon_rx_cb.o_ptp_rx_its_valid[i] & mon_if.mon_rx_cb.o_ptp_rx_valid) && ($test$plusargs("PTP_DEBUG_ACC_EN"))) || 
		   				 ((mon_if.mon_rx_cb.o_ptp_rx_sop[i] & mon_if.mon_rx_cb.o_ptp_rx_valid) && (!($test$plusargs("PTP_DEBUG_ACC_EN"))))) begin
                     q_ptp_rx_ing.push_back(mon_if.mon_rx_cb.o_ptp_rx_its[(i*96) +:96]);
                     `uvm_info(get_type_name(), $sformatf("q_ptp_rx_ing size %d: ",q_ptp_rx_ing.size), UVM_NONE);
                     num_rx_ing_pkts++;
                     `uvm_info(get_type_name(), $sformatf("num_rx_ing_pkts  %d: ",num_rx_ing_pkts), UVM_NONE);
                     //For VIP
                     `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO: igr_ptp_rx_ts = 0x%x, igr_ts_cnt = %0d ",mon_if.mon_rx_cb.o_ptp_rx_its[(i*96) +:96],num_rx_ing_pkts), UVM_NONE);            
                  end
               end
            end
         end
      end
      begin
         forever
         begin
      
         if(!(spy_if.ptp_acc_check_disable)) begin
            //Checking Tx Egress TS VS Rx Ingress TS for loopback
            wait((q_ptp_rx_ing.size()>0) && (q_ptp_tx.size()>0) && (tx_eth_frame_q.size()>0));
            `uvm_info(get_type_name(),$sformatf("Q sizes: q_ptp_rx_ing=%0d, q_ptp_tx=%0d, tx_eth_frame_q=%0d", q_ptp_rx_ing.size(), q_ptp_tx.size(), tx_eth_frame_q.size()), UVM_MEDIUM)
      
            while((q_ptp_rx_ing.size()>0) && (q_ptp_tx.size()>0) && (tx_eth_frame_q.size()>0))begin

               // Keep popping the rx ingress TS queue until tx eth frame is ptp packet
               rx_ing_ts        = q_ptp_rx_ing.pop_front();
               local_eth_packet = tx_eth_frame_q.pop_front();
               num_pkts++;
               
               if((local_eth_packet.is_ptp_seq)  && (local_eth_packet.m_ptp_kind !== PTP_ERR))begin
                  tx_egr_ts = q_ptp_tx.pop_front();
                  break;
               end
            
            end
            

            if((local_eth_packet.is_ptp_seq)  && (local_eth_packet.m_ptp_kind !== PTP_ERR))begin
              
               `ifndef ENABLE_ETH_VIP

                  `uvm_info(get_type_name(), $sformatf("mon_if.o_ptp_rx_its = 0x%x, o_ptp_ets = 0x%x ",rx_ing_ts,tx_egr_ts), UVM_NONE);
                  `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO_LB: igr_ptp_rx_ts = 0x%x, igr_ts_cnt = %0d ",rx_ing_ts,num_pkts), UVM_NONE);
                  `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO_LB: egr_ptp_tx_ts=0x%x, egr_ts_cnt=%0d ",tx_egr_ts, num_pkts), UVM_NONE); 
               
                  if( tx_egr_ts>rx_ing_ts) begin 
                     ts_diff_hex = tx_egr_ts - rx_ing_ts;  
                     `uvm_info(get_full_name(), $sformatf("PTP ACCURACY : Difference of ETS and ITS for PTP loopback for packet %0d  +++ Accuracy sec:ns:fractional = -%0dsec:%0f ns ++++",num_pkts,ts_diff_hex[95:48],ts_diff_hex[47:0]/65536.0), UVM_NONE);
                     
                  end
                  else if( rx_ing_ts>tx_egr_ts) begin 
                     ts_diff_hex = rx_ing_ts - tx_egr_ts;  
                     `uvm_info(get_full_name(), $sformatf("PTP ACCURACY : Difference of ITS and ETS for PTP loopback for packet %0d  +++ Accuracy sec:ns:fractional = +%0dsec:%0f ns ++++",num_pkts,ts_diff_hex[95:48],ts_diff_hex[47:0]/65536.0), UVM_NONE);
                  end
                  //Default accuracy is on in RTL
                  //`ifdef QHIP_ACC_TESTING
                     //Error if more than 0.8ns
                     if(!($test$plusargs("DIS_RX_VS_TX_ING_TS_CHK")))begin
                        $display("enabled qhip acc testin");
                        if($test$plusargs("PTP_DEBUG_ACC_EN"))begin // ACC Advance mode
                           if((ts_diff_hex[47:16] != 32'h0) || (ts_diff_hex[15:0] > 16'hCCCD))begin
                              `uvm_error(get_full_name(), $sformatf("ACC LOOPBACK - RX Ingress TS VS TX Egress TS > 0.8 ns for packet %0d. Diff= %0dsec:%0f ns",num_pkts,ts_diff_hex[95:48],ts_diff_hex[47:0]/65536.0))
                           end
                        end else begin // ACC Basic mode
                           if(ts_diff_hex > 48'h2199A)begin
                              `uvm_error(get_full_name(), $sformatf("ACC LOOPBACK - RX Ingress TS VS TX Egress TS > 2.1 ns for packet %0d. Diff= %0dsec:%0f ns",num_pkts,ts_diff_hex[95:48],ts_diff_hex[47:0]/65536.0))
                           end
                        end                           
                     end
                  //`endif
                        
               
                  
               `endif
            end //if((local_eth_packet.is_ptp_seq)  && (local_eth_packet.m_ptp_kind !== PTP_ERR))begin
         end//if(!(spy_if.ptp_acc_check_disable)) begin
         end
      end
 
     /*  begin forever @(mon_if.mon_tx_cb)
     begin
       i  = (dyn_rcfg_obj_inst.speed == _10G || dyn_rcfg_obj_inst.speed == _25G) ? 15: 
            (dyn_rcfg_obj_inst.speed == _50G) ? 7:
            (dyn_rcfg_obj_inst.speed == _100G) ? 3:
            (dyn_rcfg_obj_inst.speed == _200G) ? 1: 0;
            //$display("VR speed= %s, i = %0d", dyn_rcfg_obj_inst.speed, i);
    end
                end*/
       
             

     begin
        forever @(posedge spy_if.rx_mii_clk[node] ) 
                  begin 
         //Only for 10G/25G
// `ifdef QHIP_ACC_TESTING
         //if (rx_ptp_ready_ip0 == 1 && rx_mii_valid[i] == 1 && !rx_am_valid[i]) begin
         if (spy_if.o_rx_ptp_ready== 1 && spy_if.rx_mii_valid[node] == 1 && (!spy_if.rx_am_valid[node] || (rx_am_insert == 0) )) begin
            for(int j = 0; j< 8; j++)begin
               if (spy_if.rx_mii_d[node][(8*j) +:8] == 8'hfb && ((spy_if.rx_mii_c[node] == 8'h08) || (spy_if.rx_mii_c[node] == 8'h88)) && start_find_eop_rx == 0) begin
                  start_find_eop_rx = 1;
                  $display ("GDR_PTP_INFO: inst_num = ip%0d, Word align rx = %0d, time = %t", inst_num, ~spy_if.rx_word_align[node], $time);
               end
            end
         end
         start_find_eop_rx = 0;
//         `endif

      end
         end  

   begin
          forever @(posedge spy_if.tx_mii_clk[node])
                   begin 
//                   `ifdef QHIP_ACC_TESTING
                  //Only for 10G/25G
                      //if (tx_ptp_ready_ip0 == 1 && tx_mii_valid[i] == 1 && !tx_am_valid[i]) begin
                      if (spy_if.o_tx_ptp_ready == 1 && spy_if.tx_mii_valid[node] == 1 && (!spy_if.tx_am_valid[node] ||(tx_am_insert == 0))) begin
                       for(int j = 0; j< 8; j++)begin
                      if (spy_if.tx_mii_d[node][(8*j) +:8] == 8'hfb && spy_if.tx_mii_c[node] == 8'h01 && start_find_eop_tx == 0) begin
                       start_find_eop_tx = 1;
                    $display ("GDR_PTP_INFO: inst_num = ip%0d, Word align tx = %0d, time = %t", inst_num, ~spy_if.tx_word_align[node], $time);
                  end
                end
              end
                    start_find_eop_tx = 0;
//               `endif

                end
               end
 
     begin  forever @(posedge spy_if.tx_load_data_valid[node])
           begin
             $display ("GDR_PTP_INFO: inst_num = ip%0d, Tx TAM value = 0x%x, time = %t", inst_num, spy_if.tx_load_data[node] , $time);
           end end


         begin   forever @(posedge spy_if.rx_load_data_valid[node])
           begin
             $display ("GDR_PTP_INFO: inst_num = ip%0d, Rx TAM value = 0x%x, time = %t", inst_num, spy_if.rx_load_data[node] , $time);
           end end

         begin forever @(posedge spy_if.tx_tam_adj_load_data_valid[node])
           begin
             $display ("GDR_PTP_INFO: inst_num = ip%0d, Tx TAM adjust value = 0x%x, time = %t", inst_num, spy_if.tx_tam_adj_load_data[node] , $time);
           end end

         begin    forever @(posedge spy_if.rx_tam_adj_load_data_valid[node])
           begin
             $display ("GDR_PTP_INFO: inst_num = ip%0d, Rx TAM adjust value = 0x%x, time = %t", inst_num, spy_if.rx_tam_adj_load_data[node] , $time);
           end end

         begin forever @(posedge spy_if.i_tx_ptp_sync_am) begin
           @(spy_if.i_tx_ptp_async_pulse)
         $display ("GDR_PTP_INFO: inst_num = ip%0d, Tx async pulse time = %t", inst_num, $time );
       end end
          
     begin  forever @(negedge spy_if.i_rx_ptp_async_pulse) begin
         rx_async_pulse = $time;
        end 
      end

    begin forever @(posedge spy_if.i_rx_ptp_sync_am) begin
         $display ("GDR_PTP_INFO: inst_num = ip%0d, Rx async pulse time = %t", inst_num, rx_async_pulse);
    end
  end

   join

  endtask

  task ptp_tx_monitor_concrete::num_words_update(); 
	num_words  = (dyn_rcfg_obj_inst.speed == _10G) ? 1: //[TODO] Need to update with actual values
                     (dyn_rcfg_obj_inst.speed == _25G) ? 1:
                     (dyn_rcfg_obj_inst.speed == _40G) ? 2:
                     (dyn_rcfg_obj_inst.speed == _50G) ? 2:
                     (dyn_rcfg_obj_inst.speed == _100G)? 4:
                     (dyn_rcfg_obj_inst.speed == _200G)? 8:16;

  speed =            (dyn_rcfg_obj_inst.speed == _10G) ? "_10G": 
                     (dyn_rcfg_obj_inst.speed == _25G) ? "_25G":
                     (dyn_rcfg_obj_inst.speed == _40G) ? "_40G":
                     (dyn_rcfg_obj_inst.speed == _50G) ? "_50G":
                     (dyn_rcfg_obj_inst.speed == _100G)? "_100G":
                     (dyn_rcfg_obj_inst.speed == _200G)? "_200G": "_400G";
            endtask

task ptp_tx_monitor_concrete::bit_width_update();

   if(dyn_rcfg_obj_inst.speed == _400G) begin
      valid_width = 2;
   end else begin
      valid_width = 1;
   end

endtask


// TOD DRIVER //
//Assumption: Can work for rollover happen once only (increment to 1s), wont work for 2s.
function bit96 ptp_tod_drv_concrete::get_tod_timestamp();
   bit [95:0] tod_timestamp,timestamp;
   bit [16:0] tod_fns_part;
   bit [31:0] tod_ns_max;

   timestamp[95:48] = tod_secs;
   v_if.debug_tod_secs = tod_secs;
   

   tod_ns_max = $floor($realtime/1000) + tod_nsecs; 
      
   v_if.debug_tod_ns_max_b4 = tod_ns_max;
   v_if.debug_realtime   = $floor($realtime/1000);
   v_if.debug_tod_nsecs  = tod_nsecs;
   
   //tod_fnsecs can be remove
   tod_fns_part  = $floor(((($realtime - $floor($realtime/1000) * 1000)/1000.0) + tod_fnsecs) * 65536); 
   
   v_if.debug_tod_fns_part = tod_fns_part;
   v_if.debug_tod_fnsecs   = tod_fnsecs;
   
   tod_ns_max = tod_ns_max + tod_fns_part[16] ;
   
   v_if.debug_tod_ns_max_after = tod_ns_max;

   timestamp[15:0]  = tod_fns_part[15:0];

   //if tod_ns_max is >= 1 billion ns then add seconds field by 1,reset ns
   //& fns fields & capture the timestamp, to use it as reference for
   //further TOD calculations.   
   if(tod_ns_max >= 32'd1000000000)begin
      timestamp[47:16] = tod_ns_max - 32'd1000000000;
      timestamp[95:48]= timestamp[95:48]+1;      
   end
   else begin
      timestamp[47:16]=tod_ns_max;
   end
   
   //timestamp[15:0]  = tod_fns_part[15:0];
   tod_timestamp = timestamp;
   return tod_timestamp;

endfunction

//function bit96 ptp_tod_drv_concrete::get_ing_timestamp;
// bit [95:0] ing_timestamp,timestamp;
//      bit [31:0] ing_ns_max;
//      bit [47:0] ing_seconds;
//
//      timestamp[95:48] = ing_secs;
//      ing_ns_max = $floor($realtime/1000) + ing_nsecs - ing_ref_ns;
//      if(ing_ns_max >= 32'd1000000000)begin
//         ing_ref_ns <= $floor($realtime/1000);
//         timestamp[95:48]=timestamp[95:48]+1;
//         timestamp[47:16]=0;
//      	timestamp[15:0] =0;
//        ing_secs=timestamp[95:48];
//         ing_nsecs=0;
//      end
//      else begin
//         timestamp[47:16]=ing_ns_max;
//         timestamp[15:0]  = $floor((($realtime) - ing_ns_max[31:0] * 1000)/1000.0 * 65536);
//      end
//      
//      ing_timestamp = timestamp;
//      return ing_timestamp;
//
//endfunction

//Assumption: Can work for rollover happen once only (increment to 1s), wont work for 2s.
function bit96 ptp_tod_drv_concrete::get_ing_timestamp;
   bit [95:0] ing_timestamp,timestamp;
   bit [31:0] ing_ns_max;
   bit [47:0] ing_seconds;

   timestamp[95:48] = ing_secs;
   ing_ns_max = $floor($realtime/1000) + ing_nsecs;

   timestamp[15:0]  = $floor(((($realtime - $floor($realtime/1000) * 1000)/1000.0)) * 65536); 
   
   if(ing_ns_max >= 32'd1000000000)begin
      //ing_ref_ns <= $floor($realtime/1000);
      timestamp[47:16]=ing_ns_max - 32'd1000000000;
      timestamp[95:48]=timestamp[95:48]+1;
      //timestamp[47:16]=0;
      //timestamp[15:0] =0;
      //ing_secs=timestamp[95:48];
      //ing_nsecs=0;
    end
    else begin
      timestamp[47:16] = ing_ns_max;
      //timestamp[15:0]  = $floor((($realtime) - ing_ns_max[31:0] * 1000)/1000.0 * 65536);
    end    
    
    ing_timestamp = timestamp;
    return ing_timestamp;

endfunction

function ptp_tod_drv_concrete::clear_all_ts;
`ifndef QHIP_ACC_TESTING  
  tod_secs= m_ptp_config.tod_seconds_part;
  tod_nsecs=m_ptp_config.tod_ns_part;
  tod_fnsecs=m_ptp_config.tod_fns_part;
  ing_secs= m_ptp_config.ing_seconds_part;
  ing_nsecs=m_ptp_config.ing_ns_part;
`else
  tod_secs=0;
  tod_nsecs=0;
  tod_fnsecs=0;
  ing_secs=0;
  ing_nsecs=0;
`endif  
 
endfunction

task ptp_tod_drv_concrete::drv_tod_timestamp;
 @(v_if.drv_tx_tod_cb);
 v_if.drv_tx_tod_cb.ptp_tx_tod <= get_tod_timestamp();
// $display("VR driving");
endtask

task ptp_tod_drv_concrete::drv_ing_timestamp;
   @(v_if.drv_cb);
         if(spy_if.ptp_cf_r) v_if.drv_cb.ptp_ts <= get_ing_timestamp;
         else v_if.drv_cb.ptp_ts <= 96'hFFFFFFFF_EEEEEEEE_DDDDDDDD;
endtask

task ptp_tod_drv_concrete::update_tod_ns;
 // @(m_ptp_config.tod_ns_part) begin
    tod_nsecs=m_ptp_config.tod_ns_part;
 // end
endtask

task ptp_tod_drv_concrete::update_tod_seconds;
 // @(m_ptp_config.tod_ns_part) begin
    tod_secs=m_ptp_config.tod_seconds_part;
 // end
endtask

task ptp_tod_drv_concrete::update_ing_ns;
         //   @(m_ptp_config.ing_ns_part)
            ing_nsecs=m_ptp_config.ing_ns_part;
endtask

task ptp_tod_drv_concrete::update_ing_seconds;
         //   @(m_ptp_config.ing_ns_part)
            ing_secs=m_ptp_config.ing_seconds_part;
endtask

task ptp_tod_drv_concrete::drv_rx_tod;
  @(v_if.drv_rx_tod_cb);
         
         //v_if.drv_cb.ptp_tx_tod <= get_tod_timestamp;
         v_if.drv_rx_tod_cb.ptp_rx_tod <= get_tod_timestamp();

endtask

task ptp_tod_drv_concrete::seg_tx_tod_drv;
  @(v_if_seg.drv_tx_tod_cb);
     v_if_seg.drv_tx_tod_cb.ptp_tx_tod <= get_tod_timestamp();  
endtask

task ptp_tod_drv_concrete::drv_tx_its;
   @(v_if_seg.mst_cb);
            if(dyn_rcfg_obj_inst.speed == _400G) begin
               //Duplicate 2 times and let seg_tx_if select upper or lower
               v_if_seg.mst_cb.temp_i_ptp_tx_its <= {2{get_ing_timestamp}};
            end else begin
               v_if_seg.mst_cb.temp_i_ptp_tx_its <= get_ing_timestamp;
            end

endtask

task ptp_tod_drv_concrete::drv_seg_rx_tod;
   @(v_if_seg.drv_rx_tod_cb);
     v_if_seg.drv_rx_tod_cb.ptp_rx_tod <= get_tod_timestamp();     //need to check rx clock may required to change cb
endtask
// TOD DRIVER END //

  ptp_tx_monitor_concrete conc_obj_ptp_tx_mon;
  ptp_tod_drv_concrete conc_obj_ptp_tod_drv;

  initial
  begin
    conc_obj_ptp_tx_mon = new();
    uvm_config_db #(ptp_tx_monitor_abstract)::set(null,$sformatf("%m"),"CONCRETE_MONITOR",conc_obj_ptp_tx_mon);

    conc_obj_ptp_tod_drv = new();
    uvm_config_db #(ptp_tod_drv_abstract)::set(null,$sformatf("%m"),"CONCRETE_DRIVER",conc_obj_ptp_tod_drv);
  end
  
endmodule
