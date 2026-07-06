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


class eth_rx_overflow_seq extends eth_base_sequence;
  
  `uvm_object_utils(eth_rx_overflow_seq)
 bit overflow_en;
  uvm_reg_data_t rd_data;
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
   
   
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode==PCSMAC) begin
     uvm_hdl_force("eth_env_top.avst_tx_rtb_ip0.source.u.u_bfm.response_timeout",300000);
   end

   
   `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   `endif
    
  //Disable vip(TX)-> DUT(RX) scoreboard
  p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
  p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0; 

   wait_fc_reg_write.trigger();
   p_sequencer.env.fc_if.assertion_off = 1;
   //DM_TODO: enable after test passes
   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;


  `ifdef ENABLE_ETH_VIP
   p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
   p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
  `endif

   fork
     begin // TX path 
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
     end
     begin // Rx path
      `ifdef ENABLE_ETH_VIP
       fork
         begin
            send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(700,800)),.no_of_frame(50),.path(ETH_VIP_AVL_RX));
            // send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
         end
         begin
          wait(p_sequencer.env.sideband_if.rx_sop==1);
          
          if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})
            #2us;
          else
            #20ns;

          //forcing avst_rx_ready_i to zero 
           p_sequencer.env.ts_tasks_if.force_avst_rx_ready(.value(0));
           
          //waiting for some delay to de-assert rx_ready
          if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})
             #150us;
          else 
             #5us; 

          //release avst_rx_ready_i  
          p_sequencer.env.ts_tasks_if.release_avst_rx_ready();
          
          fork
            begin 
             wait(p_sequencer.env.spy_if.sig_avalon_st_rx_error[5] == 1 && p_sequencer.env.spy_if.sig_avalon_st_rx_endofpacket == 1 );
            `uvm_info("eth_rx_overflow_seq",$sformatf("  st_rx_error  = %0h rx_endofpacket = %0h ",p_sequencer.env.spy_if.sig_avalon_st_rx_error[5], p_sequencer.env.spy_if.sig_avalon_st_rx_endofpacket),UVM_NONE)
            end
            begin 
              if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
               #1ms;
              end else begin
               #50us;
              end
             `uvm_error(get_type_name(), $sformatf(" Timeout waiting RX_OVERFLOW bit = %0d EOP BIT = %0h",p_sequencer.env.spy_if.sig_avalon_st_rx_error[5], p_sequencer.env.spy_if.sig_avalon_st_rx_endofpacket));
            end
          join_any
          disable fork; 

          #5us
          //send trafic these packets should not be dropped
           send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,2);
         end
       join
      `endif
     end // Rx path
   join     

          p_sequencer.env.reg_read(`GET_REG_ADDR(rx_pktovrflow_error0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
           `uvm_info("eth_rx_overflow_seq",$sformatf("  rx_pktovrflow_error0 read value = %0h",rd_data),UVM_NONE)
          p_sequencer.env.reg_read(`GET_REG_ADDR(rx_pktovrflow_error1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
           `uvm_info("eth_rx_overflow_seq",$sformatf(" rx_pktovrflow_error1 read value = %0h",rd_data),UVM_NONE)
          p_sequencer.env.reg_read(`GET_REG_ADDR(rx_pktovrflow_etherStatsDropEvents0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
           `uvm_info("eth_rx_overflow_seq",$sformatf("rx_pktovrflow_etherStatsDropEvents0 read value = %0h",rd_data),UVM_NONE)
          p_sequencer.env.reg_read(`GET_REG_ADDR(rx_pktovrflow_etherStatsDropEvents1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
           `uvm_info("eth_rx_overflow_seq",$sformatf("rx_pktovrflow_etherStatsDropEvents1 read value = %0h",rd_data),UVM_NONE)
   #10us;

  endtask
endclass : eth_rx_overflow_seq

