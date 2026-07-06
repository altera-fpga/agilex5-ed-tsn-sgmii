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


class eth_tx_reset_recovery_sequence extends eth_base_sequence;
  uvm_event_pool a_event_pool;
  uvm_event assertion_event;
  bit [2:0] rst_sig;

  `uvm_object_utils(eth_tx_reset_recovery_sequence)
  
  function new(string name = "eth_tx_reset_recovery_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
     int num_frames_wait=0;
   process p_tx;
   process p_rx;
   a_event_pool = new();
   a_event_pool = a_event_pool.get_global_pool();
   assertion_event = a_event_pool.get("assertion_event");
   p_sequencer.env.apply_reset("hard",0,0,1,21);
   assertion_event.trigger();
   p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 0;

   `ifdef ANLT
    uvm_hdl_force("eth_env_top.avst_tx_rtb.source.u.u_bfm.response_timeout",300000);
   `endif

   `uvm_info("eth_tx_reset_recovery_sequence", "Executing eth_tx_reset_recovery_sequence ...", UVM_LOW)
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

 
    fork : reset_thread_1
     begin
         p_tx = process :: self();
         send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,50);
     end
     begin
         p_rx = process :: self();
         send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);
     end
       begin
	  num_frames_wait=$urandom_range (20,40);
   `ifdef ENABLE_ETH_VIP
	  for(int j=0;j<num_frames_wait;j++) begin
	     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
	  end
   `else
	  wait(p_sequencer.env.sb_loopbk.rx_pkt_cnt==num_frames_wait);
   `endif

	  rst_sig = 4;
	  fork 
         begin
           `uvm_info("eth_tx_reset_recovery_sequence", $sformatf("3 : rst_sig := %0p",rst_sig),UVM_NONE)
	         p_sequencer.env.apply_reset("hard",1,0,0,$urandom_range(21,50));
           reconfig_for_an(rst_sig);
           p_sequencer.env.wait_for_linkup(.tx_sync(1),.rx_sync(0),.ip_sync(0));
	  	 end  
         begin
	   //#200ns;
           @ (negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
	   p_tx.kill();
	 end
       join 	 
     //  disable reset_thread_1; 
     end
     begin
     @ (negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
     #1;
   //  p_sequencer.env.sb_vip_tx_mac_rx.scb_dis =  0;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n  & p_sequencer.env.reset_if.rx_rst_n);
    // p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
     //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
      uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_NONE);
     end
   join


  `ifdef ENABLE_ETH_VIP
   //Rx reset can cause DUT tx to transmit fault. This can corrupt DUT tx frame. 
   //Below check will make sure that such erroneous frames are transmitted before we enable VIP rx checkers.

   if((rst_sig[2] == 1 &&  rst_sig[0] == 0) || (rst_sig[1] == 1 && rst_sig[0] == 0)) begin // Tx or Rx reset only
     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
     //bit 0: (set t0 0 to disable checker on tx side)
     //bit 1: (set t0 0 to disable checker on rx side)
     //bit 2: (set t0 0 to disable checker on checker arbiter)
     //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);

     repeat(10) @(p_sequencer.env.spy_if.event_mac_idle_detected_rx); 

      //enable all rule checks 
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
   end


  `endif 

 //  #100ns;//added delay to close previous fork join thead
   
   //Enable scoreboards after pcs ready goes high
  // p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
   p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
  // p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
   //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0; 

   //do some normal frame transfer
   fork
     begin
       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
     end
  
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
     end
   join

   for(int i=0;i<20;i++) begin p_sequencer.env.reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end

   `uvm_info("eth_tx_reset_recovery_sequence", "Exiting eth_avalonst_to_serial_simplex_sequence ...", UVM_LOW)
  endtask

endclass 
