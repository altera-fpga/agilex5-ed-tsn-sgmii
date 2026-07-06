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


class eth_supplementary_addr_chk_seq extends eth_base_sequence;
  `uvm_object_utils(eth_supplementary_addr_chk_seq)
  
  uvm_reg_data_t rd_data;
  time       frame_timeout_time=1500us;
  bit[47:0] dest_addr; 
  bit[47:0] primary_addr; 
  bit[47:0] supplementary_da_0; 
  bit[47:0] supplementary_da_1; 
  bit[47:0] supplementary_da_2; 
  bit[47:0] supplementary_da_3;
  bit[3:0]  supplementary_addr_sel;
  bit[47:0] supplementary_addr; 
  bit supplementary_addr_en =1'b1;
  bit[1:0]  allucast_mcast;
  int num_pack_sent = 0;
  
  uvm_event_pool event_pool;
  uvm_event wait_fc_reg_write;

  function new(string name = "seq_0");
     super.new(name);
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
  `uvm_info("eth_seq_lib", "running eth_supplementary_addr_chk_seq sequence\n",UVM_LOW)

   if(p_sequencer.env.dyn_rcfg_obj_inst.mode==PCSMAC) begin
     uvm_hdl_force("eth_env_top.avst_tx_rtb_ip0.source.u.u_bfm.response_timeout",300000);
   end  

   ///////////////////////////////////////////////
   // read/write from rx_frame_contro register  //
   ///////////////////////////////////////////////
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   rd_data[3] = 1; //rx_fwd_ctrl_pkt 0 drops control frmae, 1 Forwards control frames to the client
   rd_data[4] = 1; //rx_fwd_pause 0 drops pause frmae, 1 Forwards pause frames to the client;
   `uvm_info("fc_rand_seq",$sformatf("writing rx_frame_control register with value = %0h",rd_data),UVM_NONE);
   p_sequencer.env.reg_write(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);


   ////////////////////////////////////////////////////////////////
   // UNICAST - write Random value into primary address register //
   ///////////////////////////////////////////////////////////////
   primary_addr             = {$urandom,$urandom};
   primary_addr[40]         = 0; //0-UNICAST
   `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("primary address value = %0h",primary_addr),UVM_NONE);
   p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),primary_addr[31:0]);
   p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),primary_addr[47:32]);

   ///////////////////////////////////////////////////////////////////////
   //writing  random supplementary  address to 4 supplementary register// 
   ///////////////////////////////////////////////////////////////////////
   supplementary_da_0     = {$urandom,$urandom};
   supplementary_da_0[40] = 0;
   `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_da_0 address value = %0h",supplementary_da_0),UVM_NONE);
   p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr0_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_0[31:0]);
   p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr0_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_0[47:32]);

   supplementary_da_1     = {$urandom,$urandom};
   supplementary_da_1[40] = 0;
   `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_da_1 address value = %0h",supplementary_da_1),UVM_NONE);
   p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr1_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_1[31:0]);
   p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr1_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_1[47:32]);

   supplementary_da_2     = {$urandom,$urandom};
   supplementary_da_2[40] = 0;
   `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_da_2 address value = %0h",supplementary_da_2),UVM_NONE);
   p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr2_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_2[31:0]);
   p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr2_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_2[47:32]);

   supplementary_da_3     = {$urandom,$urandom};
   supplementary_da_3[40] = 0;
   `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_da_3 address value = %0h",supplementary_da_3),UVM_NONE);
   p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr3_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_3[31:0]);
   p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr3_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_3[47:32]);
  //////////////////////////////////////////////////////////////////////////
 
   /////////////////////////////////////////////////////////////////////////////////// 
   //randomly selecting the supplementary address based on supplementary select bit//
   /////////////////////////////////////////////////////////////////////////////////// 
   //  std::randomize(supplementary_addr_sel) with {supplementary_addr_sel inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b1111};};
   //`uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_addr_sel value = %0h",supplementary_addr_sel),UVM_NONE);
   //case(supplementary_addr_sel)
   //  4'b0001: supplementary_addr =supplementary_da_0; 
   //  4'b0010: supplementary_addr =supplementary_da_1;   
   //  4'b0100: supplementary_addr =supplementary_da_2;
   //  4'b1000: supplementary_addr =supplementary_da_3;
   //  4'b1111: supplementary_addr =supplementary_da_0;
   //endcase
   //`uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_addr value = %0h",supplementary_addr),UVM_NONE);
   ///////////////////////////////////////////////////////////////////////////////// 
   

     wait_fc_reg_write.trigger();
   `uvm_info("eth_supplementary_addr_chk_seq", "All ADDRESS registers are written, triggered event..\n",UVM_LOW)


   `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
     fork
        begin
           send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
        end

        begin
          for(int i =1; i <5; i++) begin
            /////////////////////////////////////////////////////////////////////////////////// 
            //randomly selecting the supplementary address based on supplementary select bit//
            /////////////////////////////////////////////////////////////////////////////////// 
            std::randomize(supplementary_addr_sel) with {supplementary_addr_sel inside {4'b0001,4'b0010,4'b0100,4'b1000};};
            `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_addr_sel value = %0h",supplementary_addr_sel),UVM_NONE);
            case(supplementary_addr_sel)
              4'b0001: supplementary_addr =supplementary_da_0; 
              4'b0010: supplementary_addr =supplementary_da_1;   
              4'b0100: supplementary_addr =supplementary_da_2;
              4'b1000: supplementary_addr =supplementary_da_3;
            endcase
           `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_addr value = %0h",supplementary_addr),UVM_NONE);
      
            /////////////////////////////////////////// 
            //randomly select UCAST/MCAST EANBLE BIT//
            ////////////////////////////////////////// 
            randcase
              25: allucast_mcast = 2'b00;
              25: allucast_mcast = 2'b01;
              25: allucast_mcast = 2'b10;
              25: allucast_mcast = 2'b11;
            endcase
            `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("Iteration: %0d, supplementary_addr_sel = %0h, supplementary_addr= %0h, allucast_mcast= %0h",i,supplementary_addr_sel,supplementary_addr,allucast_mcast),UVM_NONE);

            
            //////////////////////////////////////////////////////////////////////
            //randomly select dest_addr asprimary address OR Supplementary_addr //
            //////////////////////////////////////////////////////////////////////
            randcase
             50: dest_addr = primary_addr;
             50: dest_addr = supplementary_addr;
            endcase
            `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("Iteration: %0d dest_addr value = %0h",i,dest_addr),UVM_NONE);
          

            //////////////////////////////////////////////////////////////////////////////////////////
            // read/write to rx_frame_contro register with random UCAST/MCAST and supplementary_sel //
            //////////////////////////////////////////////////////////////////////////////////////////
            p_sequencer.env.reg_read(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
            rd_data[1:0]     = allucast_mcast;       // EN_ALLUCAST EN_ALLMCAST 
            rd_data[19:16] = supplementary_addr_sel;     //   supplementary_addr select
            `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("Iteration: %0d rx_frame_control with allucast_mcast = %0h,supplementary_addr_sel =%0h",i,rd_data[1:0], rd_data[19:16]),UVM_NONE);
            p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),rd_data);
            send_eth_frame(UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1,0,supplementary_addr_en,dest_addr); 
            send_eth_frame(MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);
            num_pack_sent = (i*2);
            if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
              #50us;
            end else begin
              #10us;
            end
           
            p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_pack_sent - p_sequencer.env.spy_if.rx_frame_dropped_cntr),.timeout_time(frame_timeout_time),.include_fc_pkt(1) );
  
            `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("Iteration: %0d fc_rx_pkt_cnt = %0h,num_pack_sent =%0h, rx_frame_dropped_cntr =%0h",i,p_sequencer.env.sb_vip_tx_mac_rx.fc_rx_pkt_cnt,num_pack_sent,p_sequencer.env.spy_if.rx_frame_dropped_cntr),UVM_NONE);
           #5us;
          end //for
        end // 2nd thread
     join
    `else
      fork
        //pause_seq.start(p_sequencer.fc_sqr);
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
    `endif
 
        p_sequencer.env.wait_mac_tx_frames_done(.exp_num(10));
        p_sequencer.env.wait_tx_frames_received(.exp_num(10));

   endtask

endclass
