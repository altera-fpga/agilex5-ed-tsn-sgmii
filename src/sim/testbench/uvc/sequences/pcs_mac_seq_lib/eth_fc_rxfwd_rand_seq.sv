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


class eth_fc_rxfwd_rand_seq extends eth_base_sequence;
  `uvm_object_utils(eth_fc_rxfwd_rand_seq)
  
  uvm_reg_data_t rd_data;
  bit[8:0] port_en;//tx_pause_en 
  
  bit ready_drop;//should pause enable or disable tx transmission,will cause ready to be dropped,tx of en tx pause q no
  bit[8:0] reg_mode; 
  bit rx_fwd_ctrl_pkt;
  bit rx_fwd_pause;
  uvm_event_pool event_pool;
  uvm_event wait_fc_reg_write;

  bit rx_sfc_en;
  bit [2:0] xoff_enable;
  int rx_pkt_cnt_b4_pause;
  int rx_pkt_cnt_after_pause;

  function new(string name = "seq_0");
     super.new(name);
     //pause_seq=new("pause_seq");  
     `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
     `endif
     event_pool = new();
     event_pool = event_pool.get_global_pool();
     wait_fc_reg_write = event_pool.get("fc_reg_write");
     if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
        num_of_frames=100;
     end
    `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
   super.body();

   p_sequencer.env.sb_mac_tx_vip_rx.fc_flag_en = 1;

  `uvm_info("eth_seq_lib", "running eth_fc_rxfwd_rand_seq sequence\n",UVM_LOW)
   

   //wait for tx_lane_Stable
   //wait(p_sequencer.env.sideband_if.tx_lane_stable==1);

   if(p_sequencer.env.dyn_rcfg_obj_inst.mode==PCSMAC) begin
     uvm_hdl_force("eth_env_top.avst_tx_rtb_ip0.source.u.u_bfm.response_timeout",300000);
   end  

 

  repeat(1) begin
   rx_fwd_ctrl_pkt    = $urandom_range(1,0); 
   rx_fwd_pause = $urandom_range(1,0); 
   p_sequencer.env.flow_agent.flow_mon.flow_control=1;


  // reading rx_pause_fwd register
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_pfc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   `uvm_info("fc_rand_seq",$sformatf("writing rx_pfc_control register with value = %0h",rd_data),UVM_NONE);

   // reading from rx_frame_contro register
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   rd_data[3] = rx_fwd_ctrl_pkt ; //0 drops control frmae, 1 Forwards control frames to the client
   rd_data[4] = rx_fwd_pause;     //0 drops pause frmae, 1 Forwards pause frames to the client;

   // Writing to rx_frame_control register
   `uvm_info("fc_rand_seq",$sformatf("writing rx_frame_control register with value = %0h",rd_data),UVM_NONE);
   p_sequencer.env.reg_write(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);

   // checking the value written into control register 
   if(rx_fwd_ctrl_pkt) `uvm_info("eth_fc_rxfwd_rand_seq","Control frames will be forwarded on rx user interface...\n",UVM_LOW)
   else `uvm_info("eth_fc_rxfwd_rand_seq","Control frames will not be forwarded on rx user interface...\n",UVM_LOW)
   if(rx_fwd_pause) `uvm_info("eth_fc_rxfwd_rand_seq","PAUSE_FRAME will be forwarded on rx user interface...\n",UVM_LOW)
   else `uvm_info("eth_fc_rxfwd_rand_seq","PAUSE_FRAME will not be forwarded on rx user interface...\n",UVM_LOW)


   wait_fc_reg_write.trigger();

   `uvm_info("eth_fc_rxfwd_rand_seq", "All fc registers are written, triggered event..\n",UVM_LOW)
   `uvm_info("eth_fc_rxfwd_rand_seq", "This test will run in Pause Mode...\n",UVM_LOW)

   //Disbale SFC interface assertions (dependency on speed :  o_rx_pause assertion to counter increment)
   p_sequencer.env.fc_if.assertion_off = 1;

   `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
     fork
        begin
           send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
        end
        begin
          repeat(1) begin
            send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,5);  
            //send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);  
	    send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,2);  
	    send_eth_frame(PFC_FRAME,ETH_VIP_AVL_RX,2);  
          end
        end
     join
    `else
      fork
        //pause_seq.start(p_sequencer.fc_sqr);
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
    `endif
    
    #10us;
    //rx_pkt_cnt_after_pause = p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt;
   `ifdef ENABLE_ETH_VIP
    p_sequencer.env.wait_client_rx_frames_done(.exp_num((p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count)),.timeout_time(1ms),.include_fc_pkt(1));
    p_sequencer.env.wait_tx_frames_received(.exp_num(10),.timeout_time(1ms));
    `endif

    if(rx_fwd_ctrl_pkt == 1'b0 && rx_fwd_pause == 1'b0) begin
      if(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt == 'h5 && p_sequencer.env.sb_vip_tx_mac_rx.fc_rx_pkt_cnt == 0) begin
     `uvm_info("fc_rxfwd",$sformatf("PAUSE_FRAME CONTROL_FRAMES frames will not be forwarded on rx user interface rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_NONE);
      end else begin
      `uvm_error("eth_fc_rxfwd_rand_seq",$sformatf("CHECK:00 PAUSE_FRAME and CONTROL_FRAMES are forwarded on rx user interface rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt));
      end
    end else if(rx_fwd_ctrl_pkt == 1'b0 && rx_fwd_pause == 1'b1)begin
      if(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt == 'h5 && p_sequencer.env.sb_vip_tx_mac_rx.fc_rx_pkt_cnt == 2) begin
     `uvm_info("fc_rxfwd",$sformatf("CONTROL_FRAMES frames will not be forwarded on rx user interface rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_NONE);
      end else begin
      `uvm_error("fc_rxfwd",$sformatf("CHECK:01 CONTROL_FRAMES are forwarded on rx user interface rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt));
      end
    end else if(rx_fwd_ctrl_pkt == 1'b1 && rx_fwd_pause == 1'b0)begin
      if(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt == 'h5 && p_sequencer.env.sb_vip_tx_mac_rx.fc_rx_pkt_cnt == 2) begin
     `uvm_info("fc_rxfwd",$sformatf("PAUSE_FRAME frames will not be forwarded on rx user interface rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_NONE);
      end else begin
      `uvm_error("fc_rxfwd",$sformatf("CHECK:10 PAUSE_FRAME are forwarded on rx user interface rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt));
      end
    end else begin
      if(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt == 'h5 && p_sequencer.env.sb_vip_tx_mac_rx.fc_rx_pkt_cnt == 4) begin
     `uvm_info("fc_rxfwd",$sformatf("PAUSE_FRAME CONTROL_FRAMES frames will be forwarded on rx user interface rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_NONE);
      end else begin
      `uvm_error("fc_rxfwd",$sformatf("CHECK:00 PAUSE_FRAME and CONTROL_FRAMES are not forwarded on rx user interface rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt));
      end
    end



  end//repeat(2)
   endtask
endclass
