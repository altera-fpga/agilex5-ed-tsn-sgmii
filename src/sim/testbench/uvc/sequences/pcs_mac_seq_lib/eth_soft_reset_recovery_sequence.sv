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


class eth_soft_reset_recovery_sequence extends eth_base_sequence;
  bit [2:0] reset_bits,reset_bits_1;
  uvm_event_pool a_event_pool;
  uvm_event assertion_event;
  int tx_pkt_cnt=0;
  int rx_pkt_cnt=0;
  int num_reset;
  rand bit [6:0] random_variable;//random packet number for applying reset in between the traffic. 
  int rst_sel; //1 : ip_rst  2: Tx and RX rst
  int rst_sig_1; //1 : ip_rst  2: Tx and RX rst
  int exp_num_of_frames;

  uvm_reg regs[$];

  `uvm_object_utils(eth_soft_reset_recovery_sequence)
  
  function new(string name = "eth_soft_reset_recovery_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=50;
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
   p_sequencer.reg_model.default_map.get_registers(regs);
   
   `uvm_info("eth_soft_reset_recovery_sequence", "Executing eth_soft_reset_recovery_sequence ...", UVM_LOW)
   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
         num_of_frames=5;
   end 

   //Sending traffic in both TX/RX paths
   `uvm_info("eth_soft_reset_recovery_sequence", "Executing Traffic ...", UVM_LOW)
    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);
    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);
   `uvm_info("eth_soft_reset_recovery_sequence", "Finish  Traffic ...", UVM_LOW)
   //Before applying soft reset, all the frames from both directions should be completed.   
  // wait_all_frames_to_be_done(num_of_frames); 
   p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(1ms));
   p_sequencer.env.wait_mac_tx_frames_done(.exp_num(num_of_frames),.timeout_time(1ms));
   `ifdef ENABLE_ETH_VIP
   p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(1ms));
   `endif
   
   num_reset = 1; //$urandom_range(1,2);
   
   //1st reset: Apply soft tx/rx/ip reset single/multiple times 
   for(int i=0;i<num_reset;i++) begin
      rst_sel = $urandom_range(2,4);
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      reset_bits = rst_sig_1 ;
      `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :1 reset_bits := %0d",i,reset_bits),UVM_LOW)
      p_sequencer.env.apply_reset("soft",reset_bits[2],reset_bits[1],reset_bits[0]);
      //Disable scorboard druing reset
      p_sequencer.env.dynamic_enable_disable_scoreboards(1);
      `uvm_info("eth_soft_reset_recovery_sequence", "wait for Link up ...", UVM_LOW)
      //p_sequencer.env.wait_for_linkup(.tx_sync(reset_bits[2]),.rx_sync(reset_bits[1]),.ip_sync(reset_bits[0]));
      // Enable Scorebaord 
      p_sequencer.env.dynamic_enable_disable_scoreboards(0);
      repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
   end
   reconfig_for_an(reset_bits);

  //only tx/rx datapath will get reset, reading registers to makesure registers are not getting cleared due to soft reset
   `ifdef ETH_MULTI_PORT
   csr_pcs_regs(1);
   `else
   //csr_pcs_regs(1);
   `endif
   foreach(regs[i]) begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data);
    end
    


   
   //Sending traffic in TX & RX paths parallelly
   `uvm_info("eth_soft_reset_recovery_sequence", "Executing Traffic ...", UVM_LOW)
   fork
     begin
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);
     end
     begin
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);
     end  
   join
   `uvm_info("eth_soft_reset_recovery_sequence", "Finish  Traffic ...", UVM_LOW)
   //Before applying hard reset, all the frames from both directions should be completed.    
   //wait_all_frames_to_be_done(num_of_frames); 
   exp_num_of_frames = (2*num_of_frames);
   p_sequencer.env.wait_tx_frames_received(.exp_num(exp_num_of_frames),.timeout_time(1ms));
   p_sequencer.env.wait_mac_tx_frames_done(.exp_num(exp_num_of_frames),.timeout_time(1ms));
   `ifdef ENABLE_ETH_VIP
   p_sequencer.env.wait_client_rx_frames_done(.exp_num(exp_num_of_frames),.timeout_time(1ms));
   `endif
    
   //2nd reset: Applying soft tx/rx/ip resets single/multiple times
   reset_bits = 0;
   for(int i=0;i<num_reset;i++) begin
      rst_sel = $urandom_range(2,4);
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      reset_bits = rst_sig_1 ;
      //reset_bits = reset_bits_1 | reset_bits;
      `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :2 reset_bits := %0d",i,reset_bits),UVM_LOW)
      p_sequencer.env.apply_reset("soft",reset_bits[2],reset_bits[1],reset_bits[0]);
      // Disable Scoreboard during reset
      p_sequencer.env.dynamic_enable_disable_scoreboards(1);
      //p_sequencer.env.wait_for_linkup(.tx_sync(reset_bits[2]),.rx_sync(reset_bits[1]),.ip_sync(reset_bits[0]));
      // Enable Scorebaord
      p_sequencer.env.dynamic_enable_disable_scoreboards(0);
      repeat ($urandom_range(15,25)) @(posedge p_sequencer.env.spy_if.clk);
   end
   reconfig_for_an(reset_bits); 
   `uvm_info("eth_soft_reset_recovery_sequence", "wait for Link up ...", UVM_LOW)

   //3rd reset: Parallel threads to apply soft reset while pkt in transmission
   fork :soft_reset
     begin
         p_tx = process :: self();
         // -----------------------------------fixed size frame---------------------------------------------------------//
         // we are seinding the fixed size packet bCS, if the packet size is more it takes time to reach the score board
         // ONCE we enable the SCB the packet is received from expected side, 
         // -----------------------------------------------------------------------------------------------------------//
 	 send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(50,60)),.no_of_frame(5),.path(AVL_TX_ETH_VIP));
     end
     begin
         p_rx = process :: self();
         // -----------------------------------fixed size frame---------------------------------------------------------//
         // we are seinding the fixed size packet bCS, if the packet size is more it takes time to reach the score board
         // ONCE we enable the SCB the packet is received from expected side, 
         // -----------------------------------------------------------------------------------------------------------//
	 send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(50,60)),.no_of_frame(5),.path(ETH_VIP_AVL_RX));
     end
     begin

       `uvm_info("eth_soft_reset_recovery_sequence", "disabling the score board", UVM_LOW)
	 p_sequencer.env.dynamic_enable_disable_scoreboards(1);  
         if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG || p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin
           @(posedge p_sequencer.env.sideband_if.tx_sop);
           @(posedge p_sequencer.env.sideband_if.rx_sop);
           #20ns;
         end else begin
           #100ns; 
         end
         //p_sequencer.env.dynamic_enable_disable_scoreboards(1);
	     `ifdef ENABLE_ETH_VIP
	       p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
	       p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
        `endif
	    fork
	    begin
	       reset_bits = 0;
	       for(int i=0;i<num_reset;i++) begin
             rst_sel = $urandom_range(2,4);
             if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
             else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
             else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
             else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
             reset_bits = rst_sig_1 ;
             `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :3 reset_bits := %0d",i,reset_bits),UVM_NONE)
             p_sequencer.env.apply_reset("soft",reset_bits[2],reset_bits[1],reset_bits[0]);
             `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :3 Reset Finished:=%0d",i,reset_bits),UVM_NONE)
             repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
          end
          reconfig_for_an(reset_bits);
          //p_sequencer.env.wait_for_linkup(.tx_sync(reset_bits[2]),.rx_sync(reset_bits[1]),.ip_sync(reset_bits[0]));
	    end
	    begin
	       wait(p_sequencer.env.spy_if.eio_soft_rst == 1'b1 || p_sequencer.env.spy_if.tx_soft_rst == 1'b1 || p_sequencer.env.spy_if.rx_soft_rst == 1'b1);
           p_tx.kill();
           p_rx.kill();
	    end
        join
        disable soft_reset;
     end
     join

   `uvm_info(get_full_name(), $sformatf("loop_cnt  stage :3 Reset Done"),UVM_NONE)
   // Some of the packets are in progress before killing the process
   // hence we are waiting for some time, after that we are flushing the packets 
   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M,_1G}) begin
      #200us;
   end
   p_sequencer.env.dynamic_enable_disable_scoreboards(0);

   //Enable avst monitor assertions after getting lock
   `ifdef ENABLE_ETH_VIP
     p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(1);
     p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(1);
   `endif
   //sending traffic in TX & RX paths parallelly
   `uvm_info(get_full_name(), $sformatf("loop_cnt  stage :4 Link Up Traffic started"),UVM_NONE)
   fork
     begin
	send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(50,60)),.no_of_frame(5),.path(ETH_VIP_AVL_RX));
     end
     begin
 	send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(50,60)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
     end  
   join
   
   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})
    #250us;
   else
    #25us;

  `uvm_info(get_full_name(), "stage :4 sent num_frames/2 frames", UVM_LOW) 


  `uvm_info("eth_soft_reset_recovery_sequence", "Exiting eth_soft_reset_recovery_sequence ...", UVM_LOW)
  endtask
endclass
