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


class pcs_wrong_am_interval_sequence extends pcs_base_sequence;
  
  bit rx_crc_pass;
  `uvm_object_utils(pcs_wrong_am_interval_sequence)


  function new(string name = "pcs_wrong_am_interval_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
     int num_frames;
     bit link_lost;
     bit am_lock_lost;
     bit am_lock;
     bit lock_lost;
     integer timeout_cntr=0;
     int error_cnt=0;
     uvm_status_e status;
     bit [31:0] am_lock_rd_data;
     bit [31:0] phy_rxpcs_status_rd_data;
     bit [31:0] lanes_deskewed_rd_data;
     bit link_down=0;
     bit link_up=0;
     bit [31:0] align_timer;
     bit [31:0] act_align_timer;
     bit [31:0] val;


    `uvm_info(get_type_name(), "PCS WRONG AM INTERVAL SEQ BEGIN", UVM_LOW)
     
    rx_crc_pass=$urandom;
    //pcs_mac register not accessible in pcs_only mode   
    //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 

    `uvm_info(get_type_name(), "DONE!!! WRITING TO REG", UVM_LOW)
    
    //Guarding this TC for non FEC type variants
    if((p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G}) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC)) begin
       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);
       `uvm_info(get_type_name(), "Sent 10 frames", UVM_LOW)
        #200ns;
        p_sequencer.env.wait_client_rx_frames_done(.exp_num(10),.timeout_time(100us));
    end
    else begin

     // Refer HSD : 16011731659
     ////Disable vip(TX)-> DUT(RX) scoreboard
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;  
     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0;
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;

    //HSD : 16013867175
    val = $urandom_range(1,((2^32)-1)); 
    `uvm_info(get_type_name(),$sformatf("val assigned=%0d",val),UVM_LOW);
    //Changing align timer for VIP
    case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
      _25G  : begin
              //Todo : with FE : 16C
              act_align_timer = p_sequencer.env.`MAC_CFG.xxvsbi_rs_fec_mode_align_timer;
              `uvm_info(get_type_name(),$sformatf("VIP 25G align timer=%0d",act_align_timer),UVM_LOW);
              align_timer = act_align_timer + (val%(act_align_timer));
            //  align_timer = act_align_timer + ($urandom()%(act_align_timer));
              `uvm_info(get_type_name(),$sformatf(" Programming VIP 25G align timer as %0d",align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_XXVSBI_ALIGN_TIMER, align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_XXVSBI_ALIGN_TIMER, align_timer);
              end
      _40G  : begin
              //TOdo : check VIP cfg  signal
              act_align_timer = p_sequencer.env.`MAC_CFG.csbi_100g_align_timer;
              `uvm_info(get_type_name(),$sformatf("VIP 40G align timer=%0d",act_align_timer),UVM_LOW);
              align_timer = act_align_timer + (val%(act_align_timer));
            //  align_timer = act_align_timer + ($urandom()%(act_align_timer));
              `uvm_info(get_type_name(),$sformatf(" Programming VIP 40G align timer as %0d",align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_100G_ALIGN_TIMER, align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_100G_ALIGN_TIMER, align_timer);
              end
      _50G  : begin
              act_align_timer = p_sequencer.env.`MAC_CFG.lsbi_50g_align_timer;
              `uvm_info(get_type_name(),$sformatf("VIP 50G align timer=%0d",act_align_timer),UVM_LOW);
              align_timer = act_align_timer + (val%(act_align_timer));
            //  align_timer = act_align_timer + ($urandom()%(act_align_timer));
              `uvm_info(get_type_name(),$sformatf(" Programming VIP 50G align timer as %0d",align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_ALIGN_TIMER, align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_10G_MULTILANE_ALIGN_TIMER, align_timer);
              end        
      _100G : begin
              act_align_timer = p_sequencer.env.`MAC_CFG.csbi_100g_align_timer;
              `uvm_info(get_type_name(),$sformatf("VIP 100G align timer=%0d",act_align_timer),UVM_LOW);
              align_timer = act_align_timer + (val%(act_align_timer));
           //   align_timer = act_align_timer + ($urandom()%(act_align_timer));
              `uvm_info(get_type_name(),$sformatf(" Programming VIP 100G align timer as %0d",align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_100G_ALIGN_TIMER, align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_100G_ALIGN_TIMER, align_timer);
              end
      _200G : begin
              act_align_timer = p_sequencer.env.`MAC_CFG.ccbi_rs_fec_mode_align_timer;
              `uvm_info(get_type_name(),$sformatf("VIP 200G align timer=%0d",act_align_timer),UVM_LOW);
              align_timer = act_align_timer + (val%(act_align_timer));
           //   align_timer = act_align_timer + ($urandom()%(act_align_timer));
              `uvm_info(get_type_name(),$sformatf(" Programming VIP 200G align timer as %0d",align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_CDXBI_ALIGN_TIMER, align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CDXBI_ALIGN_TIMER, align_timer);
              end
      _400G : begin
              act_align_timer = p_sequencer.env.`MAC_CFG.cdbi_rs_fec_mode_align_timer;
              `uvm_info(get_type_name(),$sformatf("VIP 400G align timer=%0d",act_align_timer),UVM_LOW);
              align_timer = act_align_timer + (val%(act_align_timer));
           //  align_timer = act_align_timer + ($urandom()%(act_align_timer));
              `uvm_info(get_type_name(),$sformatf(" Programming VIP 400G align timer as %0d",align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_CDXBI_ALIGN_TIMER, align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CDXBI_ALIGN_TIMER, align_timer); 
              end
    endcase

 
   `uvm_info(get_type_name(), "Changed align timer for VIP", UVM_LOW)

   //Since am at wrong interval will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
   //bit 0: (set t0 0 to disable checker on tx side)
   //bit 1: (set t0 0 to disable checker on rx side)
   //bit 2: (set t0 0 to disable checker on checker arbiter)
   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
   
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
      p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
      p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
   end
     
   fork 
     begin
       //check to see if lock gained 
       am_lock_lost = 0;
       wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0);
       link_down=1;
     end
     begin
       //timeout check
       while(link_down== 0) begin
         if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
         else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);      
         `uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr), UVM_LOW)
         timeout_cntr++;
         if(timeout_cntr == 50) begin
           break;
         end
       end
     end
   join_any


   if(link_down == 1) begin
     `uvm_info(get_type_name(), $sformatf("LINK DOWN AS EXPECTED am_lock_lost :%d", link_down), UVM_LOW)
   end else begin
     `uvm_fatal(get_type_name(), $sformatf("LINKUP with wrong am interval after timeout cntr lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
   end

   //if(link_up == 1) begin
   //  `uvm_fatal(get_type_name(), $sformatf("LINKUP with wrong am interval after timeout cntr lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
   //end

   if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) begin
     repeat (25) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);      
   end 
   else if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
     repeat (25) @(p_sequencer.env.ts_tasks_if.event_insert_xxvsbi_align_marker); 
   end  
   else begin
     repeat (25) @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
   end   
   
   if(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b1) begin
     `uvm_fatal(get_type_name(), $sformatf("LINKUP with wrong am interval after 2nd timeout lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
   end
   else begin
     `uvm_info(get_type_name(), $sformatf("LINK DOWN AS EXPECTED after 2nd timeout am_lock_lost :%d", link_down), UVM_LOW)
   end

   `uvm_info(get_type_name(),$sformatf("Applying VIP reset\n"),UVM_LOW);
   p_sequencer.env.apply_vip_reset();

   //Changing align timer for VIP
    case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
      _25G  : begin
              //Todo : with FE : 16C
              `uvm_info(get_type_name(),$sformatf(" Programming default VIP 25G align timer as %0d",act_align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_XXVSBI_ALIGN_TIMER, act_align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_XXVSBI_ALIGN_TIMER, act_align_timer);
              end
      _40G  : begin
              //TOdo : check the value
              //align_timer =  32'd512 + ($urandom()%512);
              `uvm_info(get_type_name(),$sformatf(" Programming default VIP 40G align timer as %0d",act_align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_100G_ALIGN_TIMER, act_align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_100G_ALIGN_TIMER, act_align_timer);
              end
      _50G  : begin
              // 320
              align_timer =  32'd320 + ($urandom()%320);
              `uvm_info(get_type_name(),$sformatf(" Programming default VIP 50G align timer as %0d",act_align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_ALIGN_TIMER, act_align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_10G_MULTILANE_ALIGN_TIMER, act_align_timer);
              end        
      _100G : begin
              //256
              `uvm_info(get_type_name(),$sformatf(" Programming default VIP 100G align timer as %0d",act_align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_100G_ALIGN_TIMER, act_align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_100G_ALIGN_TIMER, act_align_timer);
              end
      _200G : begin
              //64
              `uvm_info(get_type_name(),$sformatf(" Programming default VIP 200G align timer as %0d",act_align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_CDXBI_ALIGN_TIMER, act_align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CDXBI_ALIGN_TIMER, act_align_timer);
              end
      _400G : begin
              `uvm_info(get_name(),$sformatf(" 400G align timer is %0d", p_sequencer.env.`MAC_CFG.cdbi_rs_fec_mode_align_timer),UVM_LOW);
              `uvm_info(get_type_name(),$sformatf(" Programming default VIP 400G align timer as %0d",act_align_timer),UVM_LOW);
              p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_CDXBI_ALIGN_TIMER, act_align_timer);
              p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CDXBI_ALIGN_TIMER, act_align_timer);  
              end
    endcase

    fork 
      begin
         timeout_cntr = 0;
         wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b1);
         //p_sequencer.top_env.wait_rx_pcs_ready();
         link_up = 1;
      end
      begin
         while(link_up == 0) begin
           #2ns;
           timeout_cntr++;
           if(timeout_cntr == 60000) begin
             break;
            end
         end
      end
    join_any

    //lock did not happen within timeout interval
    if((timeout_cntr >= 60000) && (link_up== 0)) begin
      `uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP AFTER ERRORS link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
    end
    if(link_up == 1) begin
       `uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d", link_up), UVM_LOW)
    end

    if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) begin
       @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);      
    end 
    else if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
      repeat (25) @(p_sequencer.env.ts_tasks_if.event_insert_xxvsbi_align_marker); 
    end
    else begin
       @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
    end

    if (p_sequencer.env.dyn_rcfg_obj_inst.mode == FLEXE || p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN) begin
       wait( p_sequencer.env.spy_if.gearbox_valid == 1);
       `uvm_info(get_type_name(), $sformatf(" wait for gearbox_valid high is done"),UVM_MEDIUM);
       repeat(1000) @(p_sequencer.env.spy_if.clk);
    end

    //enable all rule checks after lock regained
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);

    if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_ENABLE_ALL_RULE,1);
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b111);
	end

    //Enable vip(TX)-> DUT(RX) scoreboard
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0; 
     if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE,PCSONLY})) begin
       p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
       p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
     end

    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);
    `uvm_info(get_type_name(), "Sent 10 frames", UVM_LOW)
    p_sequencer.env.wait_client_rx_frames_done(.exp_num(10),.timeout_time(100us));

    `uvm_info(get_type_name(), "PCS WRONG AM INTERVAL TEST END", UVM_LOW)
   end 
  endtask
endclass
