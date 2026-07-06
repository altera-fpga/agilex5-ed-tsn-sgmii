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
// $Author: rrajeeva$
//==============================================================================

`ifndef PTP_TX_MON__SV
`define PTP_TX_MON__SV


//==============================================================================
// Class: ptp_tx_mon
// ptp tx monitor collects ptp tx o/p (o_ptp_ets, o_ptp_ets_valid, o_ptp_ets_fp) 
//==============================================================================

class ptp_tx_mon extends uvm_monitor;
  
  uvm_analysis_port #(ptp_tx_tran) m_ap;  //TLM analysis port for mon 
  uvm_analysis_port #(ptp_tx_tran) m_rx_ap;  //TLM analysis port for mon 
  uvm_analysis_port #(ptp_tx_tran) m_wb_ap;  //TLM analysis port for mon 
  uvm_analysis_port #(ptp_tx_tran) m_wb_rx_ap;  //TLM analysis port for mon 
  ptp_tx_monitor_abstract ptp_tx_mon_abs; 
  
  //virtual ptp_tx_interface mon_if;
  virtual spy_interface    spy_if;
  virtual reset_if rst_if;

  registers_urm reg_model;

  ptp_tx_tran m_tran_tx;
  ptp_tx_tran m_tran_rx;
  ptp_tx_tran m_tran_wb_tx;
  ptp_tx_tran m_tran_wb_rx;
  string rtb_path; 

  int transaction_id=0;
  int wb_tx_transaction_id=0;
  int wb_rx_transaction_id=0;
  // last received ptp value
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
  bit[95:0] rx_ing_ts = 0;
  bit[95:0] tx_egr_ts = 0;
  eth_packet local_eth_packet;  
  int num_words;
  int valid_width;
  
  // Dynamic Config Obj
  dyn_rcfg dyn_rcfg_obj_inst;
  
  `uvm_analysis_imp_decl(_from_tx_layering_agt)
  
  uvm_analysis_imp_from_tx_layering_agt #(eth_packet, ptp_tx_mon) a_imp_tx_layering_agt;
  
  
   //`ifdef EN_400G //TODO_GDR: temporary workaround
   //   virtual ptp_tx_interface#(.NUM_WORDS(16)) mon_if;
   //   typedef virtual ptp_tx_interface#(.NUM_WORDS(16)) ptp_tx;
   //`else
   //   virtual ptp_tx_interface#(.NUM_WORDS(1)) mon_if;
   //   typedef virtual ptp_tx_interface#(.NUM_WORDS(1)) ptp_tx;
   //`endif
 
  extern function new(string name = "ptp_tx_mon",uvm_component parent);
  
  `uvm_component_utils_begin(ptp_tx_mon)
  `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
 //  extern virtual task collect_tran();
 //  extern virtual task rx_ptp_monitor();
 //  extern virtual task ptp_accuracy_monitor();
   extern virtual function void report_phase(uvm_phase phase);
  // extern virtual task num_words_update(); 
  // extern virtual task bit_width_update();
   extern function transfer_obj(); 
   
   virtual function void write_from_tx_layering_agt(eth_packet t);

     eth_packet trans;

     trans = eth_packet::type_id::create("trans");
     trans.copy(t);
     // Push all expected ethernet frames.
     tx_eth_frame_q.push_back(trans);
     ptp_tx_mon_abs.mmbox_from_layer_agent.try_put(trans);

   endfunction : write_from_tx_layering_agt


endclass: ptp_tx_mon

//==============================================================================
// Function: new
// Create a object for analysis port for mon
//==============================================================================
function ptp_tx_mon::new(string name = "ptp_tx_mon",uvm_component parent);
  super.new(name, parent);
  m_ap = new ("m_ap",this);
  m_rx_ap = new ("m_rx_ap",this);
  m_wb_ap = new ("m_wb_ap",this);
  m_wb_rx_ap = new ("m_wb_rx_ap",this);
        
   // Creating the analysis ports
   a_imp_tx_layering_agt = new("a_imp_tx_layering_agt",this);
endfunction: new

//==============================================================================
// Function: build_phase
//==============================================================================
function void ptp_tx_mon::build_phase(uvm_phase phase);
  super.build_phase(phase);
  //if(!uvm_config_db#(virtual ptp_tx_interface)::get(this, "", "ptp_tx_interface", mon_if)) begin
  //if(!uvm_config_db#(ptp_tx)::get(this, "", "ptp_tx_interface", mon_if)) begin
  //  `uvm_fatal("PTP_TX_MON","Virtual interface not configured!");
  //end
  //if(!uvm_config_db#(virtual reset_if)::get(this, "", "slv_if", reset_if)) begin
  if(!uvm_config_db#(virtual reset_if)::get(this, "", "slv_if", rst_if)) begin
    `uvm_fatal("PTP_TX_MON","Virtual reset interface not configured!");
  end
  if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
    `uvm_fatal("PTP_TX_MON","Virtual spy interface not configured!");
  end
   // Get Dyn cfg obj
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end

   uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
   if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in ptp_tx_monitor");


   if(rtb_path=="") //null
       	`uvm_fatal("client_tx_monitor","rtb_path is not set");

   if(!uvm_config_db#(ptp_tx_monitor_abstract)::get(null,rtb_path,"CONCRETE_MONITOR",ptp_tx_mon_abs))
		`uvm_fatal("client_tx_monitor","ptp_tx_monitor concrete object is not set");        	
      transfer_obj(); 

endfunction: build_phase

function ptp_tx_mon::transfer_obj(); 
   	ptp_tx_mon_abs.dyn_rcfg_obj_inst= dyn_rcfg_obj_inst; 
    ptp_tx_mon_abs.spy_if = spy_if;
    ptp_tx_mon_abs.rst_if = rst_if;
   	ptp_tx_mon_abs.reg_model= reg_model;
   	endfunction


//==============================================================================
// Function: connect_phase
// get the interface using the configuration database
//==============================================================================
function void ptp_tx_mon::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction: connect_phase

//==============================================================================
// Function: end_of_elaboration_phase
//==============================================================================
function void ptp_tx_mon::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase); 
endfunction: end_of_elaboration_phase

//==============================================================================
// Task: run_phase
//==============================================================================
task ptp_tx_mon::run_phase(uvm_phase phase);
  super.run_phase(phase);
  ptp_tx_mon_abs.num_words_update();
  ptp_tx_mon_abs.bit_width_update();

  fork

  begin
    ptp_tx_mon_abs.collect_tran();
  end
     
begin
    forever begin
    ptp_tx_mon_abs.mmbox_tx.get(m_tran_tx);
    $display("mtran1");
    m_ap.write(m_tran_tx); end
  end

begin
  forever begin

    ptp_tx_mon_abs.mmbox_rx.get(m_tran_rx);
    $display("mtran2");
    m_rx_ap.write(m_tran_rx); end
  end

begin
  forever begin

    ptp_tx_mon_abs.mmbox_wb_tx.get(m_tran_wb_tx);
    $display("mtran3");
    m_wb_ap.write(m_tran_wb_tx); end
  end

begin forever begin

    ptp_tx_mon_abs.mmbox_wb_rx.get(m_tran_wb_rx);
    $display("mtran4");
    m_wb_rx_ap.write(m_tran_wb_rx); end
  end

begin
    if (dyn_rcfg_obj_inst.ptp) begin
      `uvm_info(get_full_name(), $sformatf("RX-PTP monitor started"), UVM_NONE)
      ptp_tx_mon_abs.rx_ptp_monitor(); 
    end
  end

begin
    if (dyn_rcfg_obj_inst.ptp) begin
      ptp_tx_mon_abs.ptp_accuracy_monitor();
    end 
  end

join
endtask: run_phase

/*task ptp_tx_mon::num_words_update(); 
	num_words  = (dyn_rcfg_obj_inst.speed == _10G) ? 1: //[TODO] Need to update with actual values
                     (dyn_rcfg_obj_inst.speed == _25G) ? 1:
                     (dyn_rcfg_obj_inst.speed == _40G) ? 2:
                     (dyn_rcfg_obj_inst.speed == _50G) ? 2:
                     (dyn_rcfg_obj_inst.speed == _100G)? 4:
                     (dyn_rcfg_obj_inst.speed == _200G)? 8:16;

endtask

task ptp_tx_mon::bit_width_update();

   if(dyn_rcfg_obj_inst.speed == _400G) begin
      valid_width = 2;
   end else begin
      valid_width = 1;
   end

endtask

//==============================================================================
// Task: collect_trans
// Here collect the transaction from the interface & send it to SB using analysis port
//==============================================================================
task ptp_tx_mon::collect_tran();
//  ptp_tx_tran m_tran;
   fork 
   begin
      forever begin
         @(mon_if.mon_cb);
         //`uvm_info(get_full_name(),$sformatf("o_ptp_ets_valid %d", mon_if.mon_cb.o_ptp_ets_valid), UVM_LOW)
         // Seg rule is from LSB to MSB
         //foreach(mon_if.mon_cb.o_ptp_ets_valid[i])begin
         for(int i=0; i< valid_width ; i++)begin
            if(mon_if.mon_cb.o_ptp_ets_valid[i]) begin
               m_tran = ptp_tx_tran::type_id::create("m_tran");
               m_tran.o_ptp_ets = mon_if.mon_cb.o_ptp_ets[(i*96) +:96];
               m_tran.o_ptp_ets_fp =  mon_if.mon_cb.o_ptp_ets_fp[(i*8) +: 8];
               m_tran.o_ptp_ets_vl =  mon_if.mon_cb.o_ptp_ets_vl[(i*5) +: 5];
               m_tran.o_ptp_ets_valid =  mon_if.mon_cb.o_ptp_ets_valid[i];
               transaction_id = transaction_id + 1; //Increment the transaction id
               m_tran.transaction_id = transaction_id; 
               m_ap.write(m_tran);
               `uvm_info(get_full_name(),$sformatf("Vector Collected transaction Tx ->\n%0s", m_tran.sprint()), UVM_MEDIUM)
            end//if
         end
      end//forever
   end
   begin
      forever begin
         @(mon_if.mon_cb);
         //foreach(mon_if.mon_cb.o_ptp_rx_its_valid[i]) begin
         for(int i=0; i< valid_width ; i++)begin
            if (mon_if.mon_cb.o_ptp_rx_sop & mon_if.mon_cb.o_ptp_rx_its_valid[i] & mon_if.mon_cb.o_ptp_rx_valid) begin
               m_tran_rx = ptp_tx_tran::type_id::create("m_tran_rx");
               m_tran_rx.o_ptp_its_vl_valid = mon_if.mon_cb.o_ptp_rx_its_valid[i];
               m_tran_rx.o_ptp_its_vl = mon_if.mon_cb.o_ptp_its_vl[(i*5) +: 5];
               m_rx_ap.write(m_tran_rx);
               `uvm_info(get_full_name(),$sformatf("Vector Collected transaction Rx ->\n%0s", m_tran_rx.sprint()), UVM_MEDIUM)
            end//if
         end//foreach
      end//forever
   end
   begin
      forever begin
         @(negedge spy_if.tx_mac_clk);
            if(spy_if.wb_tx_ets_valid==1) begin
               m_tran_wb = ptp_tx_tran::type_id::create("m_tran_wb");
               m_tran_wb.i_ptp_ets_vl_valid = spy_if.wb_tx_ets_valid;
               m_tran_wb.i_ptp_ets_vl = spy_if.wb_tx_ets_vl;
               wb_tx_transaction_id = wb_tx_transaction_id + 1; //Increment the transaction id
               m_tran_wb.transaction_id = wb_tx_transaction_id;
               m_wb_ap.write(m_tran_wb);
               `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO: Tx VL =%0d, pkt_cnt=%0d ",spy_if.wb_tx_ets_vl, wb_tx_transaction_id), UVM_MEDIUM);             
               `uvm_info(get_full_name(),$sformatf("Vector Collected transaction Tx wb VL ->\n%0s", m_tran_wb.sprint()), UVM_MEDIUM)
            end //if
      end//forever
   end
   begin
      forever begin
         @(negedge spy_if.rx_mac_mii_clk); 
            if(spy_if.wb_rx_its_valid==1) begin
               m_tran_wb_rx = ptp_tx_tran::type_id::create("m_tran_wb_rx");
               m_tran_wb_rx.i_ptp_its_vl_valid = spy_if.wb_rx_its_valid;
               m_tran_wb_rx.i_ptp_its_vl = spy_if.wb_rx_its_vl;
               wb_rx_transaction_id = wb_rx_transaction_id + 1; //Increment the transaction id
               m_tran_wb_rx.transaction_id = wb_rx_transaction_id;
               m_wb_rx_ap.write(m_tran_wb_rx);
               `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO: Rx VL =%0d, pkt_cnt=%0d ",spy_if.wb_rx_its_vl, wb_rx_transaction_id), UVM_MEDIUM);             
               `uvm_info(get_full_name(),$sformatf("Vector Collected transaction Rx wb VL ->\n%0s", m_tran_wb_rx.sprint()), UVM_MEDIUM)
         end //if
      end//forever
   end

  join
endtask//collect_tran

task ptp_tx_mon::rx_ptp_monitor();
      int frame_cnt;
      int sop_idle_cnt;

      forever begin
         @(posedge mon_if.clk);
         //foreach (mon_if.o_ptp_rx_its_valid[i]) begin
         for(int i=0; i< valid_width ; i++)begin
            if (mon_if.o_ptp_rx_sop & mon_if.o_ptp_rx_its_valid[i] & mon_if.o_ptp_rx_valid) begin
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
                  $sformatf("C3DV_PTP_INFO:lane_en_num=0_0,Packet->%0d, act_rx_ts=x%0x", 
                      frame_cnt, last_ptp_its), UVM_NONE)
            end else begin //if (mon_if.o_ptp_rx_sop & mon_if.o_ptp_rx_valid[i])
               sop_idle_cnt++;
            end //else  
         end //foreach (mon_if.o_ptp_rx_valid[i])
      end//forever begin
endtask//rx_ptp_monitor

//==============================================================================
// Task: ptp_accuracy_monitor
// Here collects the ITS and ETS from the interfaces & compare them
//==============================================================================
task ptp_tx_mon::ptp_accuracy_monitor();

   num_ptp_pkts = 0 ;
   num_pkts = 0 ;
   num_rx_ing_pkts = 0;
 
   //`ifndef ENABLE_ETH_VIP
   fork 
      begin
         forever begin
            @(mon_if.clk);
            // venkatkx : need to fix reset_if.recfg_rst_n
            //@(negedge reset_if.tx_rst_n & reset_if.rx_rst_n & reset_if.csr_rst_n & reset_if.recfg_rst_n);
            //if ( (reset_if.tx_rst_n == 1'b0) | (reset_if.rx_rst_n == 1'b0) | (reset_if.csr_rst_n == 1'b0) | (reset_if.recfg_rst_n == 1'b0) ) begin
            if ( (reset_if.tx_rst_n == 1'b0) | (reset_if.rx_rst_n == 1'b0) | (reset_if.csr_rst_n == 1'b0)) begin
               q_ptp_tx={};
//             `uvm_info(get_type_name(), $sformatf("q_ptp_tx size %d: ",q_ptp_tx.size), UVM_NONE);
//             `uvm_info(get_type_name(), $sformatf("tx queue flushed"),UVM_NONE);
            end
         end
      end
      begin
         //Store TX Egress TS
         forever begin
            @(mon_if.mon_cb);
            for(int i=0; i< valid_width ; i++)begin
               if(mon_if.mon_cb.o_ptp_ets_valid[i]) begin
                  q_ptp_tx.push_back(mon_if.mon_cb.o_ptp_ets[(i*96) +:96]);
                  `uvm_info(get_type_name(), $sformatf("q_ptp_tx size %d: ",q_ptp_tx.size), UVM_NONE);
                  num_ptp_pkts++;
                  `uvm_info(get_type_name(), $sformatf("num_ptp_pkts  %d: ",num_ptp_pkts), UVM_NONE);
                  //For VIP
                  `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO: egr_ptp_tx_ts=0x%x, egr_ts_cnt=%0d ",mon_if.mon_cb.o_ptp_ets[(i*96) +:96], num_ptp_pkts), UVM_NONE);             
               end
            end
         end
      end
      begin
         //Store RX Ingress TS
         forever begin
            @(mon_if.mon_cb);
            for(int i=0; i< valid_width ; i++)begin
               if (mon_if.mon_cb.o_ptp_rx_sop & mon_if.mon_cb.o_ptp_rx_its_valid[i] & mon_if.mon_cb.o_ptp_rx_valid) begin            
                  q_ptp_rx_ing.push_back(mon_if.mon_cb.o_ptp_rx_its[(i*96) +:96]);
                  `uvm_info(get_type_name(), $sformatf("q_ptp_rx_ing size %d: ",q_ptp_rx_ing.size), UVM_NONE);
                  num_rx_ing_pkts++;
                  `uvm_info(get_type_name(), $sformatf("num_rx_ing_pkts  %d: ",num_rx_ing_pkts), UVM_NONE);
                  //For VIP
                  `uvm_info(get_type_name(), $sformatf("SSDV_PTP_INFO: igr_ptp_rx_ts = 0x%x, igr_ts_cnt = %0d ",mon_if.mon_cb.o_ptp_rx_its[(i*96) +:96],num_rx_ing_pkts), UVM_NONE);            
               end
            end
         end
      end
      begin
         forever
         begin
      
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
                     `uvm_info(get_full_name(), $sformatf("PTP ACCURACY : Difference of ETS and ITS for PTP loopback for packet %0d  +++ Accuracy sec:ns:fractional = -%0dsec:%0d.%0dns ++++",num_pkts,ts_diff_hex[95:48],ts_diff_hex[47:16],(ts_diff_hex[15:0]/65536.0*10000)), UVM_NONE);
                     
                  end
                  else if( rx_ing_ts>tx_egr_ts) begin 
                     ts_diff_hex = rx_ing_ts - tx_egr_ts;  
                     `uvm_info(get_full_name(), $sformatf("PTP ACCURACY : Difference of ITS and ETS for PTP loopback for packet %0d  +++ Accuracy sec:ns:fractional = +%0dsec:%0d.%0dns ++++",num_pkts,ts_diff_hex[95:48],ts_diff_hex[47:16],(ts_diff_hex[15:0]/65536.0*10000)), UVM_NONE);
                  end
                  //Default accuracy is on
                  //`ifdef QHIP_ACC_TESTING
                     //Error if more than 0.8ns
                     if((ts_diff_hex[47:16] != 32'h0) || (ts_diff_hex[15:0] > 16'hCCCD))begin
                        `uvm_error(get_full_name(), $sformatf("ACC LOOPBACK - RX Ingress TS VS TX Egress TS > 0.8 ns for packet %0d. Diff= %0dsec:%0d.%0d ns",num_pkts,ts_diff_hex[95:48],ts_diff_hex[47:16],(ts_diff_hex[15:0]/65536.0*10000)))
                     end                  
                  //`endif
                  
                  
               `endif
               
            end
 
         end
      end      
   join
// `endif
endtask//ptp_accuracy_monitor

*/

//==============================================================================
// Function: start_of_simulation_phase
//==============================================================================
function void ptp_tx_mon::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction: start_of_simulation_phase

//==============================================================================
// Function: reset_phase
//==============================================================================
task ptp_tx_mon::reset_phase(uvm_phase phase);
  super.reset_phase(phase);
endtask: reset_phase

//==============================================================================
// Function: configure_phase
//==============================================================================
task ptp_tx_mon::configure_phase(uvm_phase phase);
  super.configure_phase(phase);
endtask:configure_phase

//==============================================================================
// Function: report_phase
//==============================================================================
function void ptp_tx_mon::report_phase(uvm_phase phase);
  super.report_phase(phase);
endfunction:report_phase

`endif // PTP_TX_MON__SV
