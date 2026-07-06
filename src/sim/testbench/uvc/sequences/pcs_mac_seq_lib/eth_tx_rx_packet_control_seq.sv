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


class eth_tx_rx_packet_control_seq extends eth_base_sequence;
  
  fc_pause_sequence pause_seq;
  `uvm_object_utils(eth_tx_rx_packet_control_seq)

  uvm_reg_data_t rd_data;
  bit[15:0] sfc_pause_quanta; //retransmit holdoff_en
  bit[15:0] sfc_holdoff_quanta; //retransmit holdoff_en
  bit[15:0] quanta[]; 
  bit[15:0] hold_quanta[]; 
  bit [8:0] pause_mode;
  uvm_event_pool event_pool;
  uvm_event wait_fc_reg_write;
  
  function new(string name = "seq_0");
    super.new(name);
    pause_seq=new("pause_seq");  
     `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
    event_pool = new();
    event_pool = event_pool.get_global_pool();
    wait_fc_reg_write = event_pool.get("fc_reg_write");
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=10;
   end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
   `uvm_info("eth_seq_lib", "running eth_tx_rx_packet_control sequence\n",UVM_LOW)
   `ifdef ENABLE_ETH_VIP
      p_sequencer.env.mac_cfg.print();
   `endif
   
   sfc_holdoff_quanta = 100;
   sfc_pause_quanta   = 500;
   quanta=new[8];
   hold_quanta=new[8];
   p_sequencer.env.sb_mac_tx_vip_rx.fc_flag_en = 1;
   pause_mode[8] = $urandom_range(0,1); //0 - port based, 1 - reg based //$uranodm();
  
   pause_seq.fc_mode   = pause_mode; //register or port
   pause_seq.pause_pfc = 0;// sfc = 0, pfc =1 //$urandom_range(0,1);

   
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode==PCSMAC) begin
     uvm_hdl_force("eth_env_top.avst_tx_rtb_ip0.source.u.u_bfm.response_timeout",300000);
   end

   foreach(quanta[i]) begin
      quanta[i]=125;
      pause_seq.pause_quanta[i]=quanta[i];
      randcase
      60:  hold_quanta[i]=(quanta[i] *3)/4;
      20:  hold_quanta[i]=quanta[i];
      20:  hold_quanta[i]=(quanta[i] *4)/3;
      endcase
   end
   pause_seq.pause_quanta[8]=sfc_pause_quanta;
   
  // tx_sa[40]=0;
  // tx_da[40]=0;
   
   p_sequencer.env.flow_agent.flow_mon.flow_control=1;
   p_sequencer.env.reg_read(`GET_REG_ADDR(tx_pauseframe_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   rd_data[0]   = $urandom_range(0,1);//1; //enable tx pause frame transmission 
   rd_data[2:1] = {1'b0,pause_mode[8]};
   `uvm_info("eth_tx_rx_packet_control",$sformatf("writing tx_pauseframe_enable register with value = %0h",rd_data),UVM_NONE)
   p_sequencer.env.reg_write(`GET_REG_ADDR(tx_pauseframe_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_pause_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),sfc_pause_quanta); 
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),sfc_holdoff_quanta); 


   `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN || p_sequencer.env.dyn_rcfg_obj_inst.mode == FLEXE) begin
       p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     end
   `endif

   wait_fc_reg_write.trigger();
   p_sequencer.env.fc_if.assertion_off = 1;
   //DM_TODO: enable after test passes
   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;


   fork
     begin // Tx path
      fork
        begin
            send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(500,600)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
            //send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1); //send bigger frame 
        end
        begin
          wait(p_sequencer.env.sideband_if.tx_sop==1);
          p_sequencer.env.reg_read(`GET_REG_ADDR(tx_packet_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
          rd_data[0] = 1 ; //disable the Tx traffic path
          p_sequencer.env.reg_write(`GET_REG_ADDR(tx_packet_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
           `uvm_info("eth_tx_rx_packet_control",$sformatf(" check1: tx_packet_control_OFFSET_REG read value = %0h",rd_data),UVM_NONE)
          //wait for tx_ready to go low
           wait(p_sequencer.env.sideband_if.tx_ready==0);
          //wait_vip_rx frames to be received as 1
            pause_seq.start(p_sequencer.fc_sqr);
          
           fork
             begin
                wait(p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt == 'h1);
                `uvm_info("rxfwd_seq",$sformatf("check1:- rx_pkt_cnt= %0h",p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt),UVM_NONE)
               `uvm_info("eth_tx_rx_packet_control", "the numner of packets transmitted on MAC tX is recieved on VIP RX\n",UVM_LOW)
             end
             begin
               #1ms;
                `uvm_info("rxfwd_seq",$sformatf("check1:- rx_pkt_cnt= %0h",p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt),UVM_NONE)
               `uvm_error("rxfwd_seq",$sformatf("MISMATCH in packets transmitted on MAC_TX is recieved on VIP_RX rx_pkt_cnt= %0h",p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt));
             end
           join_any
          disable fork; 

          #1us;
          p_sequencer.env.reg_read(`GET_REG_ADDR(tx_packet_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
          rd_data[0] = 0 ; //enabling the Tx traffic path
          p_sequencer.env.reg_write(`GET_REG_ADDR(tx_packet_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
          `uvm_info("fc_rand_seq",$sformatf(" check2: tx_packet_control_OFFSET_REG read value = %0h",rd_data),UVM_NONE);
          // wait for tx_ready to go high
          wait(p_sequencer.env.sideband_if.tx_ready==1);
          //send the sfc/pfc/data packets total 10
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
	  send_eth_frame(SFC_FRAME,AVL_TX_ETH_VIP,1);  
	  send_eth_frame(PFC_FRAME,AVL_TX_ETH_VIP,1);  
          //wait_vip_rx_fRAMES TO BE received
          
          if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
             #250us;
          end else begin
             #50us;
          end
 
         `uvm_info("rxfwd_seq",$sformatf("rx_pkt_cnt= %0h,fc_rx_pkt_cnt= %0h",p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt,p_sequencer.env.sb_mac_tx_vip_rx.fc_rx_pkt_cnt),UVM_NONE)
           if(p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt == 'h4 && p_sequencer.env.sb_mac_tx_vip_rx.fc_rx_pkt_cnt == 2) begin
            `uvm_info("eth_tx_rx_packet_control", "the numner of packets transmitted on MAC tX is recieved on VIP RX\n",UVM_LOW)
           end else begin
           `uvm_error("rxfwd_seq",$sformatf("MISMATCH in numner of packets transmitted on MAC_TX is recieved on VIP_RX rx_pkt_cnt= %0h",p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt));
           end 
           
        end
      join
     end //Tx path
     begin // Rx path
      `ifdef ENABLE_ETH_VIP
       fork
         begin
           repeat(1) begin
            send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1200,1500)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
             //send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);  
           end // repeat (200)
         end
         begin
          wait(p_sequencer.env.sideband_if.rx_sop==1);
           p_sequencer.env.reg_read(`GET_REG_ADDR(rx_transfer_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
           rd_data[0] = 1 ; //disable the Rx traffic path
           p_sequencer.env.reg_write(`GET_REG_ADDR(rx_transfer_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
           p_sequencer.env.reg_read(`GET_REG_ADDR(rx_transfer_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
           `uvm_info("fc_rand_seq",$sformatf(" check1: rx_transfer_control_OFFSET_REG read value = %0h",rd_data),UVM_NONE);
           
          `uvm_info("rxfwd_seq",$sformatf("check5:- VIP_TX rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_NONE)
           wait(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt == 'h1);
          `uvm_info("rxfwd_seq",$sformatf("check6:- VIP_TX rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_NONE)
           #10us;
           p_sequencer.env.reg_read(`GET_REG_ADDR(rx_transfer_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
           rd_data[0] = 0 ; //enabling the Rx traffic path
           p_sequencer.env.reg_write(`GET_REG_ADDR(rx_transfer_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
           p_sequencer.env.reg_read(`GET_REG_ADDR(rx_transfer_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
           `uvm_info("fc_rand_seq",$sformatf("check2: rx_transfer_control_OFFSET_REG read value = %0h",rd_data),UVM_NONE);
           #20us;
            send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1200,1500)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    
           //send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,1);  
          `uvm_info("rxfwd_seq",$sformatf("check7:- VIP_TX rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_NONE)
          wait(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt == 'h2);
          `uvm_info("rxfwd_seq",$sformatf("check8:- VIP_TX rx_pkt_cnt= %0h",p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_NONE)
            
         end
       join
      `endif
     end // Rx path
   join     

  // Some drain time to make sure all packetes are processed 
   #10us;

  endtask
endclass : eth_tx_rx_packet_control_seq

