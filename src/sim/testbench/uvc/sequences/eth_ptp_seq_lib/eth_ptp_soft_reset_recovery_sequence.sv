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


class eth_ptp_soft_reset_recovery_sequence extends eth_ptp_base_sequence;
  bit [2:0] reset_bits,reset_bits_1;
  uvm_event_pool a_event_pool;
  uvm_event assertion_event;
  //int tx_pkt_cnt;
  //int rx_pkt_cnt;
  //int frames=50;//number of frames selection 
  int num_reset;
  rand bit [6:0] random_variable;//random packet number for applying reset in between the traffic. 
  int rst_sel; //1 : ip_rst  2: Tx and RX rst
  int rst_sig_1; //1 : ip_rst  2: Tx and RX rst
  ptp_op_e ptp_op;

  `uvm_object_utils(eth_ptp_soft_reset_recovery_sequence)

  eth_ptp_config_sequence eth_ptp_config_seq;
 
  function new(string name = "eth_ptp_soft_reset_recovery_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=5; //50 to 5
   end
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
   process p_tx;
   process p_rx;
   a_event_pool = new();
   a_event_pool = a_event_pool.get_global_pool();
   assertion_event = a_event_pool.get("assertion_event");
   assertion_event.trigger();
   p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 0;
   
   //dsamantx :FIXME for GDR_ANLT
   //if(p_sequencer.env.dyn_rcfg_obj_inst.anlt==1)
   // uvm_hdl_force("eth_env_top.avst_tx_rtb.source.u.u_bfm.response_timeout",300000);
   //`endif
   //Sample: spy_if.force_response_timeout(300000);

   `uvm_info("eth_ptp_soft_reset_recovery_sequence", "Executing eth_ptp_soft_reset_recovery_sequence ...", UVM_NONE)
   super.body();

   uvm_hdl_force("eth_env_top.avmm_rtb_asm.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal",0);
   uvm_hdl_force("eth_env_top.avmm_rtb_p2p.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal",0);

   //Sending traffic in both TX/RX paths
   `uvm_info("eth_ptp_soft_reset_recovery_sequence", "stage :1 Executing Traffic before reset...", UVM_NONE)
   //write_asym_p2p_latency();
//fork  /////
//  begin  /////
   fork
     begin
       repeat(num_of_frames) begin
         std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_NOOP,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         randcase
         4:send_ptp_frame(ptp_op,RANDOM_FRAME,1);
         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
         endcase
       end
     end
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,num_of_frames);
     end
   join

   `uvm_info("eth_ptp_soft_reset_recovery_sequence", "stage :1 Finish  Traffic ...", UVM_NONE)
    #10us;
   //for(int i=0;i<20;i++) begin p_sequencer.env.reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
   
   //dsamantx:Need to add this task instead of reading the registers
   //Before applying soft reset, all the frames from both directions should be completed.    
   //wait_all_frames_to_be_done(frames);
   
   //num_reset = $urandom_range(1,2);
   num_reset = 1;
   //1st reset: Apply soft tx/rx/ip reset single/multiple times 
   for(int i=0;i<num_reset;i++) begin
      rst_sel = $urandom_range(1,4);
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      //reset_bits = rst_sig_1 | reset_bits;
      reset_bits = rst_sig_1 ;
      `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :1 reset_bits := %0d",i,reset_bits),UVM_NONE)
      p_sequencer.env.apply_reset("soft",reset_bits[2],reset_bits[1],reset_bits[0]);
      fork
         begin
            `uvm_do(eth_ptp_config_seq)
         end
         begin
            `uvm_info("eth_ptp_soft_reset_recovery_sequence", "stage :1 After reset wait for Link up ...", UVM_NONE)
            p_sequencer.env.wait_for_linkup(.tx_sync(reset_bits[2]),.rx_sync(reset_bits[1]),.ip_sync(reset_bits[0]));
         end
      join
      repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
   end
   reconfig_for_an(reset_bits);

   `uvm_info("eth_ptp_soft_reset_recovery_sequence", "stage :2 Executing Traffic before reset ...", UVM_NONE)
   //Sending traffic in TX & RX paths parallelly
   //write_asym_p2p_latency();

   fork
     begin
       repeat(num_of_frames) begin
         std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_NOOP,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         randcase
         4:send_ptp_frame(ptp_op,RANDOM_FRAME,1);
         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
         endcase
       end
     end
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,num_of_frames);
     end
   join

   #10us;

   `uvm_info("eth_ptp_soft_reset_recovery_sequence", "stage :2 Finish  Traffic ...", UVM_NONE)
   //for(int i=0;i<20;i++) begin p_sequencer.env.reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end

   //dsamantx:Need to add this task instead of reading the registers
   //Before applying hard reset, all the frames from both directions should be completed.    
   //wait_all_frames_to_be_done(frames);
   
   //2nd reset: Applying soft tx/rx/ip resets single/multiple times
   reset_bits = 0;
   for(int i=0;i<num_reset;i++) begin
      rst_sel = $urandom_range(1,4);
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      reset_bits = rst_sig_1 ;
      //reset_bits = reset_bits_1 | reset_bits;
      `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :2 reset_bits := %0d",i,reset_bits),UVM_NONE)
      
      p_sequencer.env.apply_reset("soft",reset_bits[2],reset_bits[1],reset_bits[0]);
      fork
         begin
            `uvm_do(eth_ptp_config_seq)
         end
         begin
            `uvm_info("eth_ptp_soft_reset_recovery_sequence", "stage :2 After reset wait for Link up ...", UVM_NONE)
            p_sequencer.env.wait_for_linkup(.tx_sync(reset_bits[2]),.rx_sync(reset_bits[1]),.ip_sync(reset_bits[0]));
         end
      join
      repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
   end
   reconfig_for_an(reset_bits);

   //3rd reset: Parallel threads to apply soft reset while pkt in transmission
   num_of_frames=50;
   //write_asym_p2p_latency();
   
   //For MACSEG
   //Disable seg tx assertion
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode == MACSEG)begin      
      uvm_hdl_force("eth_env_top.seg_tx_if_ip0.disable_valid_ready_assertion",1);
   end   
   
//fork  /////
//begin  /////
   fork :soft_reset
   begin
      p_tx = process :: self();
      `uvm_info("eth_ptp_soft_reset_recovery_sequence", "stage :3 Executing Traffic before reset ...", UVM_NONE)
      repeat(num_of_frames) begin
         std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_NOOP,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         randcase
            4:send_ptp_frame(ptp_op,RANDOM_FRAME,1);
            1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
         endcase
      end
   end
   begin
         p_rx = process :: self();         
         send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,num_of_frames);
   end
   begin
        //waiting for some random pkt to transfer
	//randomize (random_variable) with {random_variable == 125;}; 
        //wait(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt == random_variable);
      if(p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC)begin
         @(posedge p_sequencer.env.spy_if.avst_tx_sop);
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.mode == MACSEG)begin
         @(posedge p_sequencer.env.spy_if.seg_tx_found_sop);
      end
      #20ns;
      `ifdef ENABLE_ETH_VIP
      p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
      p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
      `endif
      fork
      begin
         reset_bits = 0;
         for(int i=0;i<num_reset;i++) begin
            rst_sel = $urandom_range(1,4);
            if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
            else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
            else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
            else if(rst_sel == 4) begin
               rst_sig_1 = 2; // Rx only Reset
                  
               if(p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC)begin
                  //For RX only reset, to ignore ready back preassure respond time
                  uvm_hdl_force("eth_env_top.avst_tx_rtb_ip0.source.u.u_bfm.response_timeout",0); //Note: No need for 1st and 2nd reset on top because packet is send until finish               
               end
            end
            reset_bits = rst_sig_1 ;
            `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :3 reset_bits := %0d",i,reset_bits),UVM_NONE)
            p_sequencer.env.apply_reset("soft",reset_bits[2],reset_bits[1],reset_bits[0]);
            p_sequencer.env.spy_if.delayed_scb_en = 1; //workaround for packet midsim traffic reset issue. It will automatically reset to 0 after come out from reset
            `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :3 Reset Finished",i,reset_bits),UVM_NONE)
            fork
            begin
               `uvm_do(eth_ptp_config_seq)
            end
            begin
               `uvm_info("eth_ptp_soft_reset_recovery_sequence", "stage :3 After reset wait for Link up ...", UVM_NONE)
               p_sequencer.env.wait_for_linkup(.tx_sync(reset_bits[2]),.rx_sync(reset_bits[1]),.ip_sync(reset_bits[0]));
            end
            join
            repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
         end
         reconfig_for_an(reset_bits);

      end
      begin
         wait(p_sequencer.env.spy_if.eio_soft_rst == 1'b1 || p_sequencer.env.spy_if.tx_soft_rst == 1'b1 || p_sequencer.env.spy_if.rx_soft_rst == 1'b1);
            p_tx.kill();
            p_rx.kill();
            //muralasx: Workaround for a case in C3 DR 
         //if(reset_bits[1]) p_sequencer.env.reset_vip();
      end
      join
//      disable soft_reset;
   end
   join
//end  /////
//join  /////

   `uvm_info(get_full_name(), $sformatf("loop_cnt  stage :3 Reset Done"),UVM_NONE)
   //p_sequencer.env.wait_for_linkup(.tx_sync(reset_bits[2]),.rx_sync(reset_bits[1]),.ip_sync(reset_bits[0]));
   //dsamantx:updating local pkt cntrs 
   //tx_pkt_cnt = p_sequencer.env.sb_mac_tx_vip_rx.tx_pkt_cnt-p_sequencer.txdp_pkt_cnt;
   //rx_pkt_cnt = p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt-p_sequencer.rxdp_pkt_cnt;

//  `ifdef ENABLE_ETH_VIP
//   //Rx reset can cause DUT tx to transmit fault. This can corrupt DUT tx frame. 
//   //Below check will make sure that such erroneous frames are transmitted before we enable VIP rx checkers.
//   if((reset_bits[2] == 1 &&  reset_bits[0] == 0) || (reset_bits[1] == 1 && reset_bits[0] == 0)) begin // Tx or Rx reset only
//      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
//      //bit 0: (set to 0 to disable checker on tx side)
//      //bit 1: (set to 0 to disable checker on rx side)
//      //bit 2: (set to 0 to disable checker on checker arbiter)
//      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
//      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
//     repeat(100) @(p_sequencer.env.spy_if.event_mac_idle_detected_rx); 
//      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1); 
//      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);  
//   end
//  `endif

   //sending traffic in TX & RX paths parallelly
   `uvm_info(get_full_name(), $sformatf("loop_cnt  stage :4 Link Up Traffic started"),UVM_NONE)
   //write_asym_p2p_latency();

   //Add some delay before sending packet just incase scoreboard enable earlier
   #15us;
   
   //Enable seg tx assertion
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode == MACSEG)begin      
      uvm_hdl_force("eth_env_top.seg_tx_if_ip0.disable_valid_ready_assertion",0);
   end      

   fork
     begin
       repeat(num_of_frames/2) begin
         std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_NOOP,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         randcase
         4:send_ptp_frame(ptp_op,RANDOM_FRAME,1);
         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
         endcase
       end
     end
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,num_of_frames/2);
     end
   join

   //dsamantx:updating local pkt cntrs 
   //tx_pkt_cnt = tx_pkt_cnt + frames/2;
   //rx_pkt_cnt = rx_pkt_cnt + frames/2;
 
   //dsamantx:Need to add this task instead of reading the registers
   //Before applying hard reset, all the frames from both directions should be completed.    
   //wait_all_frames_to_be_done(tx_pkt_cnt,rx_pkt_cnt);
// end  /////
//join  /////  

  `uvm_info("eth_ptp_soft_reset_recovery_sequence", "Exiting eth_ptp_soft_reset_recovery_sequence ...", UVM_NONE)
  endtask
endclass
