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


class eth_ptp_hard_reset_recovery_sequence extends eth_ptp_base_sequence;
  uvm_event_pool a_event_pool;
  uvm_event assertion_event;
  bit [2:0] rst_sig,rst_sig_1;
  //int tx_pkt_cnt;
  //int rx_pkt_cnt;
  //int frames=50;//number of frames selection 
  int num_reset;
   int rst_sel; //1 : ip_rst  2: Tx and RX rst 
   int rst_sig_1; //1 : ip_rst  2: Tx and RX rst
  ptp_op_e ptp_op;


  `uvm_object_utils(eth_ptp_hard_reset_recovery_sequence)

  eth_ptp_config_sequence eth_ptp_config_seq;
  
  function new(string name = "eth_ptp_hard_reset_recovery_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=5;
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
   
   super.body();
   
   //dsamantx: FIXME for GDR ANLT
   //if(p_sequencer.env.dyn_rcfg_obj_inst.anlt==1) begin
   // uvm_hdl_force("eth_env_top.avst_tx_rtb.source.u.u_bfm.response_timeout",300000);
   //end
   //Sample: spy_if.force_response_timeout(300000);

   uvm_hdl_force("eth_env_top.avmm_rtb_asm.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal",0);
   uvm_hdl_force("eth_env_top.avmm_rtb_p2p.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal",0);

   `uvm_info(get_full_name(), "Executing eth_ptp_hard_reset_recovery_sequence ...", UVM_LOW)


   //Sending traffic in both TX/RX paths
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

   
   //for(int i=0;i<20;i++) begin p_sequencer.env.reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
   
   //dsamantx:Need to add this task instead of reading the registers
   //Before applying hard reset, all the frames from both directions should be completed.    
   //wait_all_frames_to_be_done(frames);
   //Ram Add buffer time to allow inflight packets 
   #10us;
   
   //num_reset = $urandom_range(1,2);
   num_reset = 1;
   //Apply hard tx/rx/ip reset single/multiple times 
   for(int i=0;i<num_reset;i++) begin
      rst_sel = $urandom_range(1,4);
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      rst_sig = rst_sig_1 | rst_sig;
      `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :1 rst_sig_1 := %0d",i,rst_sig_1),UVM_LOW)
       p_sequencer.env.apply_reset("hard",rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50));
       fork
          begin
             `uvm_do(eth_ptp_config_seq)
          end
          begin
             p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
          end
       join
       repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
   end

   reconfig_for_an(rst_sig);
   //p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
   `uvm_info(get_full_name(), "stage :1 Link Up Executing Traffic AFter Reset ...", UVM_LOW)

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
   `uvm_info(get_full_name(), "stage :1 Traffic Done ...", UVM_LOW)
   //for(int i=0;i<20;i++) begin p_sequencer.env.reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
   
   //dsamantx:Need to add this task instead of reading the registers
   //Before applying hard reset, all the frames from both directions should be completed.    
   //wait_all_frames_to_be_done(frames);
   
   //Applying hard tx/rx/ip resets single/multiple times
   rst_sig = 0;
   for(int i=0;i<num_reset;i++) begin
      rst_sel = $urandom_range(1,4);
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      rst_sig = rst_sig_1 | rst_sig;
      `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :2 rst_sig_1 := %0d",i,rst_sig_1),UVM_LOW)
      p_sequencer.env.apply_reset("hard",rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50));
      fork
         begin
            `uvm_do(eth_ptp_config_seq)
         end
         begin
            p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
         end
      join
      `uvm_info(get_full_name(), "stage :2 Link Up ...", UVM_LOW)
      repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
   end
   reconfig_for_an(rst_sig);
   
   //Parallel threads to apply hard reset while pkt in transmission
   num_of_frames=50; //YC
   //write_asym_p2p_latency();
   
   //For MACSEG
   //Disable seg tx assertion
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode == MACSEG)begin      
      uvm_hdl_force("eth_env_top.seg_tx_if_ip0.disable_valid_ready_assertion",1);
   end
   
   fork :hard_reset
   begin
      p_tx = process :: self();
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
      `ifdef ENABLE_ETH_VIP
      for(int j=0;j<$urandom_range (20,40);j++) begin
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
      end
      `endif
      fork
      begin
         //Applying hard tx/rx/ip resets for single/multiple times	 
         rst_sig = 0;
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
            rst_sig = rst_sig_1 | rst_sig;
            `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :3 rst_sig_1 := %0d",i,rst_sig_1),LOW)
            p_sequencer.env.apply_reset("hard",rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50));
            p_sequencer.env.spy_if.delayed_scb_en = 1; //workaround for packet midsim traffic reset issue. It will automatically reset to 0 after come out from reset
               
            fork
            begin
               `uvm_do(eth_ptp_config_seq) 
            end
            begin
               p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
            end
            join
            
            `uvm_info(get_full_name(), "stage :3 Link Up ...", UVM_LOW)
            repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
         end
         
         reconfig_for_an(rst_sig);
      end 
      begin
         #100ns;
         p_tx.kill();
         p_rx.kill();
            //dsamantx: Workaround for a case in C3 DR 
            //need to uncomment if the issue is live. 
         //if(rst_sig[1]) p_sequencer.env.reset_vip();
      end
      join
   
   end
   join

   //p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
   
   `uvm_info(get_full_name(), "stage : 4 Started ...", UVM_LOW)

   //sending traffic in TX & RX paths parallelly
   //write_asym_p2p_latency();
   //Add some delay before sending packet just incase scoreboard enable earlier
   #25us;

   //Enable seg tx assertion
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode == MACSEG)begin      
      uvm_hdl_force("eth_env_top.seg_tx_if_ip0.disable_valid_ready_assertion",0);
   end   
   
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

   //for(int i=0;i<20;i++) begin p_sequencer.env.reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
   
   //dsamantx:updating local pkt cntrs 
   //tx_pkt_cnt = tx_pkt_cnt + frames/2;
   //rx_pkt_cnt = rx_pkt_cnt + frames/2;
 
   //dsamantx:Need to add this task instead of reading the registers
   //Before applying hard reset, all the frames from both directions should be completed.    
   //wait_all_frames_to_be_done(tx_pkt_cnt,rx_pkt_cnt);

  `uvm_info(get_full_name(), "Exiting eth_ptp_hard_reset_recovery_sequence ...", UVM_LOW)
  endtask
endclass
