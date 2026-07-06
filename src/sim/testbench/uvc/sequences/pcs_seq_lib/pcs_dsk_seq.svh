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


class pcs_dsk_sequence extends pcs_base_sequence;
  bit rx_crc_pass;
  bit[3:0] last_lane;
  time       frame_timeout_time=50us;
  `uvm_object_utils(pcs_dsk_sequence)

  seq_var m_seq_var;

  function new(string name = "pcs_dsk_sequence");
    super.new(name);
    m_seq_var = new(); 
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  function void pre_randomize; 
    super.pre_randomize(); 
  endfunction

  virtual task body();
    bit am_lock_lost;
    bit am_lock;
    integer timeout_cntr=0;
    int error_cnt=0;
    bit link_down;
    bit link_up;
    int loop_cnt = 2;
    uvm_reg_data_t lanes_deskewed_rd_data;
    uvm_reg_data_t rxpcs_fully_aligned_rd_data;
    uvm_reg_data_t am_lock_rd_data;
    uvm_reg_data_t fec_align_rd_data;

    $display("start pcs dsk sequence");
    rx_crc_pass=$urandom;
    dis_stats_chk = 1;

    p_sequencer.env.dyn_rcfg_obj_inst.skew_test = 1;
    `uvm_info(get_type_name(), $sformatf("Setting skew_test in config :%d, stats check disabled :%d", p_sequencer.env.dyn_rcfg_obj_inst.skew_test, dis_stats_chk), UVM_LOW)
 
    //pcs_mac register not accessible in pcs_only mode   
    //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
    $display("DONE!!! WRITING TO REG");
    
    for(int i=0;i<loop_cnt;i++) begin

      link_down = 0; 
      link_up = 0; 
      timeout_cntr = 0;
      error_cnt=0;
      //Since skew will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      //bit 0: (set t0 0 to disable checker on tx side)
      //bit 1: (set t0 0 to disable checker on rx side)
      //bit 2: (set t0 0 to disable checker on checker arbiter)
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
      if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
         p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
         p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
      end

      //Disable vip(TX)-> DUT(RX) scoreboard, Need to do this additionlly because of one VIP issue. Solvnet case No. : 8001091531
     // p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
     
      `ifdef ENABLE_ETH_VIP
	    p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
	    p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
      `endif

      m_seq_var.speed = p_sequencer.env.dyn_rcfg_obj_inst.speed;
      //randomize num of lanes, skew on each lane
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G) 
        m_seq_var.randomize() with {skew_0 == 'd22;};
      else if (!m_seq_var.randomize()) begin
        `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
      end
      
      `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)
      last_lane = find_last_lane(m_seq_var);
      `uvm_info(get_name(), $sformatf("last_lane= %d",last_lane), UVM_LOW)

      //am_lock for single lane are always LOW -HSD 14011594751
      //25/10G - single lanes
      //Sequence will inject skew on PCS lanes/VLs, not on physical lanes. 100/40/50G with FEC modes are not applicable.
      if((p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}) ||
         (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_100G,_50G,_40G} && p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC)) begin
	     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,50);
         #500ns;
         `uvm_info(get_type_name(),$sformatf("loop_cnt=%0d, vip_tx_cnt=%0d, pkt_drop_count=%0d",i,p_sequencer.env.eth_ref_model_inst.vip_tx_count,-p_sequencer.env.eth_ref_model_inst.drop_count),UVM_MEDIUM);
         p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
         `uvm_info(get_type_name(), "Sent 50 frames", UVM_LOW)
      end else begin
        //Disable vip(TX)-> DUT(RX) scoreboard, Need to do this additionlly because of one VIP issue. Solvnet case No. : 8001091531
        p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
         //insert skew on PCS lanes
         insert_skew(m_seq_var);
      
         fork 
         begin
           //check to see if lock lsot
           am_lock_lost = 0;
           wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0);
	       //if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G)  #200ns;
           //For 40G, block_lock deassertion will take time due to invalid sync hdr corruption ( check below threads)
           if((p_sequencer.env.dyn_rcfg_obj_inst.speed ==_40G) & (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC)) begin
             #1us;
           end else begin
             #750ns;
           end

           if(p_sequencer.env.spy_if.rx_am_lock == 1'b0) begin
             am_lock_lost = 1;
           end

           if((p_sequencer.env.spy_if.rx_block_lock == 1'b1) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC)) begin //HSD:16014121004
             error_cnt++;
             `uvm_info(get_type_name(), $sformatf("error count increased due to block lock"), UVM_LOW)
           end
           //dsk_done 
           if(p_sequencer.env.spy_if.rx_dsk_done == 1'b1) begin
             error_cnt++;
             `uvm_info(get_type_name(), $sformatf("error count increased due to rx_dsk_done"), UVM_LOW)
           end

           //Final alignment lock comes after deskew, cant check for alignment to be lost as required by spec
           link_down=1;
        end
        begin
          //timeout check
          while(link_down== 0) begin
	      if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)  )
             @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
	      else
	         @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
          `uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr), UVM_LOW)
          timeout_cntr++;
          if((timeout_cntr == 200 && p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G)||
	       (timeout_cntr == 200 && p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G)||
	       (timeout_cntr == 100 && p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_40G,_50G})||
	       (timeout_cntr == 400 && p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) ||
	       (timeout_cntr == 50  && p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G)) begin
              break;
          end
          end
        end
	    begin
          wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0);
          `uvm_info(get_type_name(), $sformatf("pcs ready is going down"), UVM_LOW)
	      // HSD : & Solv-01114862 : In 40G Nofec mode, difference between linkup and link down
	      // is very short, so here we added invalid sync header to extend the link down.
          if((p_sequencer.env.dyn_rcfg_obj_inst.speed ==_40G) & (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC)) begin
	         `uvm_info(get_name(), $sformatf("Insert 65 INVALID SYNC Headers"),UVM_MEDIUM);
             insert_invalid_sync_hdr_callback(65);
             `uvm_info(get_name(), $sformatf("INVALID SYNC HDRS inserted, wait for blk lock loss at time :%t", $time), UVM_MEDIUM)
          end

          if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside {NOFEC,FCFEC}) begin
            //Read am lock status register to reflect loss
            //DM p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), am_lock_rd_data, 1);
            if(am_lock_rd_data !== 'h0 || am_lock_rd_data === 'hdead_c0de) begin
             `uvm_error(get_type_name(), $sformatf("am lock register does not reflect am lock loss am_lock_read_data:%h ", am_lock_rd_data))
            end 
            else begin
              `uvm_info(get_type_name(), $sformatf("am lock lock register read:%h", am_lock_rd_data), UVM_LOW)
            end

            // Not reading below register in crete3. Create 3 register read takes more time.
	        // Rx PCS fully alignedis assert back befor we read the register at this point. Due to that below check fails randomly. 
            //Read rxpcs_fully_aligned status register to reflect loss
           //DM p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rxpcs_fully_aligned_rd_data, 1);
            if(rxpcs_fully_aligned_rd_data[0] !== 0) begin
             `uvm_error(get_type_name(), $sformatf("rxpcs fully aligned register does not reflect word/am lock loss rxpcs_fully_aligned_rd_data:%h ", rxpcs_fully_aligned_rd_data))
            end 
            else begin
              `uvm_info(get_type_name(), $sformatf("rxpcs fully aligned register read:%h", rxpcs_fully_aligned_rd_data), UVM_LOW)
            end
	      end
          else begin //HSD : 16011780662 
            //DM p_sequencer.env.reg_read(`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_aggr_rx_stat_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), fec_align_rd_data, 1);
            if(fec_align_rd_data[0] === 'h0) begin
             `uvm_error(get_type_name(), $sformatf("fec align lock register does not reflect align status fec_align_read_data:%h ",fec_align_rd_data))
            end 
            else begin
              `uvm_info(get_type_name(), $sformatf("am lock lock register read:%h", fec_align_rd_data), UVM_LOW)
            end
            if(fec_align_rd_data[5:2] !== 'h0) begin
	          `uvm_error(get_type_name(), $sformatf("fec align lock register does not reflect last lane status fec_align_read_data:%h ",fec_align_rd_data))
            end 
            else begin
              `uvm_info(get_type_name(), $sformatf("fec_align register last_lane field read:%h", fec_align_rd_data[5:2]), UVM_LOW)
            end
          end

          while(link_down== 0) begin
	        if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)  )
               @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
	        else
	           @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
          end
	  end
      join_any


      `uvm_info(get_type_name(), $sformatf("after first fork exit  timeout_cntr:%d", timeout_cntr), UVM_LOW)

      if((timeout_cntr >= 50) && (am_lock_lost == 0)) begin
       `uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR AM LOCK LOSS after skew inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
      end
      if((am_lock_lost == 1) && (error_cnt == 0))  begin
        `uvm_info(get_type_name(), $sformatf("AM LOCK LOST AS EXPECTED am_lock_lost :%d", am_lock_lost), UVM_LOW)
      end
      else if((am_lock_lost == 1) && (error_cnt != 0))  begin
        `uvm_error(get_type_name(), $sformatf("AM LOCK LOST AS EXPECTED am_lock_lost :%d, BLOCK LOCK LOST UNEXPECTEDLY : error_cnt :%d", am_lock_lost, error_cnt))
      end
      
      //HSD :16011780662 :for fec mode, it will take time to reassert the signal.
      if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC) repeat(1500) @(p_sequencer.env.spy_if.clk);
      else repeat(4500) @(p_sequencer.env.spy_if.clk);

      //am lock should have reassert now
      fork 
        begin
          am_lock = 0;
          timeout_cntr = 0;
          wait ((p_sequencer.env.spy_if.rx_am_lock == 1'b1) && (p_sequencer.env.spy_if.rx_dsk_done == 1'b1));
          link_up = 1;
        end
        begin
          while(link_up == 0) begin
            #2ns;
            if(p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G) #2ns;
            timeout_cntr++;
            if(timeout_cntr == 2500) begin
              break;
            end
          end
        end
      join_any

      //am lock did not happen within timeout interval
      if((timeout_cntr >= 2500) && (link_up== 0)) begin
       `uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP AFTER SKEW link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
      end
      if(link_up == 1) begin
        `uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d timeout_cntr=%0d", link_up,timeout_cntr), UVM_LOW)
      end

      repeat(2) @(p_sequencer.env.spy_if.clk);

      if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside {NOFEC,FCFEC}) begin
        //DM p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), am_lock_rd_data, 1);
        if(am_lock_rd_data === 'h0 || am_lock_rd_data === 'hdead_c0de) begin
         `uvm_error(get_type_name(), $sformatf("am lock register does not reflect am lock am_lock_read_data:%h ", am_lock_rd_data))
        end 
        else begin
          `uvm_info(get_type_name(), $sformatf("am lock lock register read:%h", am_lock_rd_data), UVM_LOW)
        end

        //Read rxpcs_fully_aligned status register to reflect lock 
        //DM p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rxpcs_fully_aligned_rd_data, 1);
        if(rxpcs_fully_aligned_rd_data[0] !== 1) begin
         `uvm_error(get_type_name(), $sformatf("rxpcs fully aligned register does not reflect word/am lock regained rxpcs_fully_aligned_rd_data:%h ", rxpcs_fully_aligned_rd_data))
        end 
        else begin
          `uvm_info(get_type_name(), $sformatf("rxpcs fully aligned register read:%h", rxpcs_fully_aligned_rd_data), UVM_LOW)
        end 

        //GDR_HSD :this register is not sticky on read, so register can not be read by DV.
        //Read rxpcs_fully_aligned status register to reflect lock 
        //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),lanes_deskewed_rd_data, 1);
        //if(lanes_deskewed_rd_data[0] !== 1) begin
        // `uvm_error(get_type_name(), $sformatf("lane_deskewed register does not reflect word/am lock loss lanes_deskewed_rd_data:%h ", lanes_deskewed_rd_data))
        //end 
        //else begin
        //  `uvm_info(get_type_name(), $sformatf("lane_deskewed register read:%h", lanes_deskewed_rd_data), UVM_LOW)
        //end 
      end
      else begin
       //DM  p_sequencer.env.reg_read(`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_aggr_rx_stat_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), fec_align_rd_data, 1);
        if(fec_align_rd_data[0] !== 'h0) begin
         `uvm_error(get_type_name(), $sformatf("fec align lock register does not reflect align status fec_align_read_data:%h ",fec_align_rd_data))
        end 
        else begin
          `uvm_info(get_type_name(), $sformatf("am lock lock register read:%h", fec_align_rd_data), UVM_LOW)
        end
        if(fec_align_rd_data[5:2] !== last_lane) begin
	//Commenting this error, will revert it once we have information on
	//last lane
         // `uvm_error(get_type_name(), $sformatf("fec align lock register does not reflect last lane status fec_align_last_lane_read_data:%h expected last_lane:%h",fec_align_rd_data[5:2],last_lane))
        end 
        else begin
          `uvm_info(get_type_name(), $sformatf("fec_align register last_lane field read:%h", fec_align_rd_data[5:2]), UVM_LOW)
        end
      end

      //wait before sending frames
      for(int i=0;i<2;i++) begin
      if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)  )
               @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
	     else
               @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
      end

      if (p_sequencer.env.dyn_rcfg_obj_inst.mode == FLEXE || p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN) begin
         wait( p_sequencer.env.spy_if.gearbox_valid == 1);
         `uvm_info(get_type_name(), $sformatf(" wait for gearbox_valid high is done"),UVM_MEDIUM);
         repeat(50) @(p_sequencer.env.spy_if.clk);
      end

      //enable all rule checks after lock regained
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);

      if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {FLEXE,OTN}) begin
         p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_ENABLE_ALL_RULE,1);
         p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b111);
      end

      //Enable vip(TX)-> DUT(RX) scoreboard
      p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;      

      send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
      `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(100),.timeout_time(100us));
       
      //wait before next iteration
      #50us;

      //Disable vip(TX)-> DUT(RX) scoreboard
      p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;

      //Since skew will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      //bit 0: (set t0 0 to disable checker on tx side)
      //bit 1: (set t0 0 to disable checker on rx side)
      //bit 2: (set t0 0 to disable checker on checker arbiter)
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
      
      if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})begin
         p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
         p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
      end

      //reset skew on all lanes before next iteration
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE0, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE1, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE2, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE3, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE4, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE5, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE6, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE7, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE8, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE9, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE10, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE11, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE12, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE13, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE14, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE15, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE16, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE17, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE18, 0);
      p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE19, 0);

      #8us;
      //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
      wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b1);
      `uvm_info(get_type_name(), "DUT linkup after skew reset", UVM_LOW)
      
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.EVENT_LINK_UP.wait_trigger();
      `uvm_info(get_type_name(), "VIP linkup after skew reset", UVM_LOW)
      
	  #5us;

      end // speed ! {25g,10g}

    end //loop_cnt

    `uvm_info(get_type_name(), "PCS RX VIP DSK SEQ END", UVM_LOW)
  endtask
  endclass
