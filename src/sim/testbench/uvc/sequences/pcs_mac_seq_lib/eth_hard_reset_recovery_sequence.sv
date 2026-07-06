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


class eth_hard_reset_recovery_sequence extends eth_base_sequence;
  uvm_event_pool a_event_pool;
  uvm_event assertion_event;
  bit [2:0] rst_sig;
  int tx_pkt_cnt=0;
  int rx_pkt_cnt=0;
  //int frames=50;//number of frames selection 
  int num_reset;
  int rst_sel; //1 : ip_rst  2: Tx and RX rst 
  int rst_sig_1; //1 : ip_rst  2: Tx and RX rst
  time frame_timeout_time=5us;


  `uvm_object_utils(eth_hard_reset_recovery_sequence)
  
  function new(string name = "eth_hard_reset_recovery_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=50;
   end
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
   a_event_pool = new();
   a_event_pool = a_event_pool.get_global_pool();
   assertion_event = a_event_pool.get("assertion_event");
   assertion_event.trigger();
   p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 0;
   
   `uvm_info(get_full_name(), "Executing eth_hard_reset_recovery_sequence ...", UVM_LOW)
  
   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
       num_of_frames=10;
   end
 
   //Sending traffic in both TX/RX paths
   fork
   send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);
   send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);
   join

   //dsamantx:Need to add this task instead of reading the registers
   //Before applying hard reset, all the frames from both directions should be completed.    
   //wait_all_frames_to_be_done(frames);
   //Ram Add buffer time to allow inflight packets 
   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
     p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(1ms));
     p_sequencer.env.wait_mac_tx_frames_done(.exp_num(num_of_frames),.timeout_time(1ms));
       `ifdef ENABLE_ETH_VIP
     p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(1ms));
     `endif
   end
   else begin
     wait_all_frames_to_be_done(num_of_frames);
   end
   
   //Apply hard tx/rx/ip reset single/multiple times 
   begin
      rst_sel = 2;
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      rst_sig = rst_sig_1 | rst_sig;
       p_sequencer.env.apply_reset("hard",rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50));
	//for coverage: read data default value of tx_pld_status is 0x20
	// we have to read this pld_status register before link is up
        `uvm_info(get_name(),$sformatf("ehip_stats_tx_pld_status_OFFSET_REG register read data : %0d", read_data),UVM_MEDIUM);
       p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
       repeat ($urandom_range(10,15)) @(posedge p_sequencer.env.spy_if.clk);
   end 

   //Parallel threads to apply hard reset while pkt in transmission
   fork :hard_reset
     begin
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,1);
     end
     begin
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);
     end
     begin
        //waiting for some random pkt to transfer
	fork
	 begin
	  //Applying hard tx/rx/ip resets for single/multiple times	 
          rst_sig = 0;
         num_reset = 1;
	  for(int i=0;i<num_reset;i++) begin
             rst_sel = 2;
             if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
             else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
             else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
             else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
             rst_sig = rst_sig_1 | rst_sig;
            `uvm_info(get_full_name(), "stage :3 BEFORE APPLYING VALID ...", UVM_LOW)
               p_sequencer.env.spy_if.t_valid=1;
             `uvm_info(get_full_name(), "stage :3 AFTER APPLYING VALID ...", UVM_LOW)
             repeat(10) @(p_sequencer.env.spy_if.clk);
             `uvm_info(get_full_name(), "BEFORE APPLYING Reset ...", UVM_LOW)
             fork
               p_sequencer.env.apply_reset("hard",rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50));
               begin
                 repeat(2) @(p_sequencer.env.spy_if.clk);
                 `uvm_info(get_full_name(), "making valid to zero ...", UVM_LOW)
                 p_sequencer.env.spy_if.t_valid=0;
               end
             join
	     `uvm_info(get_full_name(), "stage :3 waiting for linkup ...", UVM_LOW)
             p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
             `uvm_info(get_full_name(), "stage :3 Link Up ...", UVM_LOW)
              repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
          end
	 end 
	join
     end
     begin
        `uvm_info(get_full_name(), "stage :3 waiting for Reset ...", UVM_LOW)
        @(negedge p_sequencer.env.reset_if.csr_rst_n , negedge p_sequencer.env.reset_if.tx_rst_n , negedge p_sequencer.env.reset_if.rx_rst_n);
        p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; 
        p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
        p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
        p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
        uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_LOW);
	`ifdef ENABLE_ETH_VIP
	 p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
	 p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
       `endif
         // Disabling  AVST assertion
         uvm_hdl_force("eth_env_top.avst_tx_rtb_ip0.monitor.u_bfm.monitor_assertion.enable_a_non_missing_startofpacket", 0);
         uvm_hdl_force("eth_env_top.avst_tx_rtb_ip0.monitor.u_bfm.monitor_assertion.enable_a_non_missing_endofpacket", 0);
     end
   join 

   `uvm_info(get_full_name(), "stage : 4 Started ...", UVM_LOW)

   //local & remote fault signals are getting deasserted after linkup due to AIB delay.
   //If dut receives packets in this time, will see packet loss in dut rx direction
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {MACSEG,PCSMAC}) begin
     `uvm_info(get_full_name(), "waiting for local/remote fault to become 0", UVM_LOW)
     wait(p_sequencer.env.spy_if.lf_status == 0 && p_sequencer.env.spy_if.rf_status == 0);
     `uvm_info(get_full_name(), "wait done for local/remote fault to become 0", UVM_LOW)
   end

   //p_sequencer.env.dynamic_enable_disable_components(0);
   p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0; 
   p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
   p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=1;  
   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=1; 
   `uvm_info(get_full_name(),$sformatf("TX SCB :%0d & RX SCB:%0d",p_sequencer.env.sb_mac_tx_vip_rx.tx_pkt_cnt,p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt),UVM_LOW)
   `uvm_info(get_full_name(),$sformatf("TX SCB :%0d & RX SCB:%0d",p_sequencer.env.sb_vip_tx_mac_rx.tx_pkt_cnt,p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_LOW)
   tx_pkt_cnt=p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt;
   rx_pkt_cnt=p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt;
   
   //sending traffic in TX & RX paths parallelly
   fork
     begin
       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames/2);
     end
     begin
       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames/2);
     end  
   join
   `uvm_info(get_full_name(),$sformatf("TX SCB :%0d & RX SCB:%0d",p_sequencer.env.sb_vip_tx_mac_rx.tx_pkt_cnt,p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_LOW)
   `uvm_info(get_full_name(),$sformatf("TX SCB :%0d & RX SCB:%0d",p_sequencer.env.sb_mac_tx_vip_rx.tx_pkt_cnt,p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt),UVM_LOW)
     fork
       wait(p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt==(tx_pkt_cnt+(num_of_frames/2)));
       wait(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt==(rx_pkt_cnt+(num_of_frames/2)));
     join  
#5us;

  `uvm_info(get_full_name(), "Exiting eth_hard_reset_recovery_sequence ...", UVM_LOW)
  endtask
endclass
