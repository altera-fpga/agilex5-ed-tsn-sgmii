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


class eth_lt_restartlt_reg_sequence extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit [3:0] restart_lane;
  //bit [7:0] restart_lane; vinoth2x
  bit       restart_lane_G25;
  bit [7:0] restart_status[4];
  //bit [7:0] restart_status[8]; vinoth2x
  uvm_reg 	regs;
  bit[3:0] lane_trained;
  //bit[7:0] lane_trained; vinoth2x

  `uvm_object_utils(eth_lt_restartlt_reg_sequence)

  function new(string name = "eth_lt_restartlt_reg_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif

  endfunction:new

  virtual task body();
   
     p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));

   bringup_status_read();
   prbs_select();
   
   `ifdef CRETE3
    //`ifdef G100 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     #500us;
   end
    //`endif vinoth2x
   `endif
  
   `ifdef CRETE3
      //`ifdef G25 vinoth2x
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
      fork : wait_to_initiate
        begin
           `uvm_info(get_name(), $sformatf("******* Wait for Spico Reset start : 1 ***************"), UVM_NONE);
            //reset_spico_25g;
           `uvm_info(get_name(), $sformatf("******* Wait for Spico Reset start : 2 ***************"), UVM_NONE);
            //reset_spico_25g;
            #200us;
        end
        begin
         	#550us;
           `uvm_info(get_name(), $sformatf("******* Wait for Spico Reset over ***************"), UVM_NONE);
            disable wait_to_initiate;
        end
       join
     //`endif vinoth2x
     end
     `endif

     `ifdef CRETE3
      //`ifdef G10 vinoth2x
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
       #550us;
     end
      //`endif vinoth2x
     `endif
    
      LT_en = 1;
      AN_en = $urandom_range(0,1);
 
     enable_disable_lt(LT_en);
     enable_disable_an(AN_en);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,(($urandom & 'h0000_7006)| 'h0000_0000));
     reset_sequencer(); 

   //case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR     'b00:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
// FIXME-MISSING_REG_IN_GDR     'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR     'b10:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
// FIXME-MISSING_REG_IN_GDR     'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
   //endcase

   // need to disable MWT and LT timer since LT process time has increased
   //C2-FB-585909
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
   read_data[1] = 1'b1;
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
    `ifdef CRETE3
    //C3 RAL: model seq_reset bit is "RW" type,temporary patch until RAL is fixed.
    // C3 also takes time to clear the bit.
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR    regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_anlt_seq_cfg_OFFSET_REG);
    read_data[0] = 1'b0;
    regs.predict(.value(read_data),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
   `else
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
   `endif
   // `ifdef CRETE3
   //   `ifdef G100
   //      reset_spico();
   //   `else
   //     reset_spico_25g();
   //   `endif
   // `endif


   `uvm_info(get_name(), $sformatf("******* RTL CONFIG ***************"), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Restart AN sequencer    :%0d ",read_data[0]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disabl AN Timer         :%0d ",read_data[1]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable LF Timer        :%0d ",read_data[2]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Failure Response     :%0d ",read_data[12]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Fail if Hiber on/off :%0d ",read_data[13]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Skip LT on AN Timeout   :%0d ",read_data[14]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);

   wait_for_an_vip_event(AN_en);
   
  //`ifdef G100 vinoth2x
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
   restart_lane = $urandom_range(1,'hF);
   //restart_lane = $urandom_range(1,'hFF); vinoth2x
   `uvm_info(get_name(), $sformatf("1st : restart_lane                   :%0d ",restart_lane), UVM_LOW);
 end
  //`endif vinoth2x

  //`ifdef G25 vinoth2x
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
   restart_lane_G25 = 'h1;
   `uvm_info(get_name(), $sformatf("1st : restart_lane_G25                   :%0d ",restart_lane_G25), UVM_LOW);
 end
   //`endif vinoth2x

   if (LT_en)
   begin
     p_sequencer.env.reconfig_vip_for_lt_mode(300);

     `ifdef CRETE3
     `uvm_info(get_name(), $sformatf("1st : Waiting for frame lock on any lane "), UVM_NONE);
       @(p_sequencer.env.spy_if.lt_frame_lock);
      `else
     `uvm_info(get_name(), $sformatf("1st : Waiting for frame lock on four lanes "), UVM_NONE);
       wait(p_sequencer.env.spy_if.lt_frame_lock == 'hF);
       //wait(p_sequencer.env.spy_if.lt_frame_lock == 'hFF); vinoth2x
     `endif
      `uvm_info(get_name(), $sformatf("1st : completed frame lock on four lanes "), UVM_NONE);
 
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR    // p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR      reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h06060606);
      end
      else begin
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000007);
      end
        
  //`ifdef G100 vinoth2x
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,restart_lane[3:0]);
// FIXME-MISSING_REG_IN_GDR     //p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,restart_lane[7:0]); vinoth2x
   end
  //`else vinoth2x
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,restart_lane_G25);
   end
  //`endif vinoth2x

     //it turns out that to restart LT in middle, we have to restart VIP instead sending restart req since vip and RTL does not remain in sycn 
     // VIP LT cant be restart throguh req trans if lane is not in LT mode.
     p_sequencer.env.reset_vip();
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     p_sequencer.env.reconfig_vip_for_lt_mode(300); //wait timer is expanded not to loose frame lock on rtl lanes
    end
    else begin
     p_sequencer.env.reconfig_vip_for_lt_mode(1000); //wait timer is expanded not to loose frame lock on rtl lanes
    end

     //Since we are restarting VIP , vip will stop sending data for a while , which looses the frame lock in RTL as RTL will restart again on all lanes,which drive VIP to capture errors so disabling error for this period, this disble- enable checker period is tentatively defined since there is no definite time predication
     disable_lt_tx_checker();
     disable_lt_rx_checker();
     //for(int i=0;i<8;i++) begin vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     for(int i=0;i<4;i++) begin
         restart_status[i] = 'h06;
       if(restart_lane[i] == 1'b1) begin
         restart_status[i] = 'h04;
       end
     end
    end
    else begin
       if(restart_lane_G25 == 1'b1)
         restart_status[0] = 'h04;
	else
	 restart_status[0] = 'h06;
	    
    end	    
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_anlt_seq_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]});
// FIXME-MISSING_REG_IN_GDR     //reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[7],restart_status[6],restart_status[5],restart_status[4],restart_status[3],restart_status[2],restart_status[1],restart_status[0]}); vinoth2x
// FIXME-MISSING_REG_IN_GDR   //  p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR      reg_predict_read(`REGISTERS_lt_cfg2_OFFSET_REG,'h0,1);
     end
     else begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[0]},1);
     end	     
     
     lane_trained = $urandom_range(1,3);
     //lane_trained = $urandom_range(1,7); vinoth2x

   `ifndef CRETE3 // C2 specific delay to enable checker again
     #30us;
   `endif
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
   enable_lt_rx_checker();
   enable_lt_tx_checker();
   end
     `ifdef CRETE3//C3 does not provide condinuous LT status, it hardly toggle 2-3 time during LT process
     `uvm_info(get_name(), $sformatf("2nd : Waiting for change in frame lock on any lane "), UVM_NONE);
       @(p_sequencer.env.spy_if.lt_frame_lock);
      `else
     `uvm_info(get_name(), $sformatf("2nd : Waiting for frame lock on four lanes "), UVM_NONE);
       wait(p_sequencer.env.spy_if.lt_frame_lock == 'hF);
       //wait(p_sequencer.env.spy_if.lt_frame_lock == 'hFF); vinoth2x
     `endif
     `uvm_info(get_name(), $sformatf("2nd : completed frame lock on four lanes "), UVM_NONE);
     `uvm_info(get_name(), $sformatf("Wait for %0h lane rx trained",lane_trained), UVM_LOW);

     repeat (lane_trained)
     begin 
       @(p_sequencer.env.spy_if.lt_trained);
       `uvm_info(get_name(), $sformatf("wait for p_sequencer.env.spy_if.lt_trained(%0h) times",p_sequencer.env.spy_if.lt_trained), UVM_LOW);
       //if(p_sequencer.env.spy_if.lt_trained == 'hFF) begin vinoth2x
       if(p_sequencer.env.spy_if.lt_trained == 'hF) begin
	 break;
       `uvm_info(get_name(), $sformatf("breaking loop; p_sequencer.env.spy_if.lt_trained=%0h",p_sequencer.env.spy_if.lt_trained), UVM_LOW);
       end
     end

     `uvm_info(get_name(), $sformatf("Wait done for %0b lane rx trained",p_sequencer.env.spy_if.lt_trained), UVM_LOW);
    
    //ADD lt_status prediction 
    //FB_FIX : FB-578097 and 577811, just read status register wihtout comparision, 
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   //  reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]});
   //   restart_lane = $urandom_range(1,'hF);
   //FB 592397 : 2nd time need to restart all lanes, because of vip limitation,vip not sending data on trained lane causes loctodata signal lose and reset the   //DUT 
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     restart_lane = 'hF;// urandom_range(1,'hF);
     //restart_lane = 'hFF; vinoth2x
     restart_lane_G25 = 'h1;// urandom_range(1,'hF);

     `uvm_info(get_name(), $sformatf("2nd : restart_lane                   :%0h ",restart_lane), UVM_LOW);
     `uvm_info(get_name(), $sformatf("2nd : restart_lane G25               :%0h ",restart_lane_G25), UVM_LOW);

    //`ifdef G100 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,restart_lane[3:0]);
// FIXME-MISSING_REG_IN_GDR     //p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,restart_lane[7:0]); vinoth2x
   end
    //`else vinoth2x
    else if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,restart_lane_G25);
   end
    //`endif vinoth2x

     p_sequencer.env.reset_vip();
     p_sequencer.env.reconfig_vip_for_lt_mode(15); //wait timer is expanded not to loose frame lock on rtl lanes
     //Since we are restarting VIP , vip will stop sending data for a while , which looses the frame lock in RTL as RTL will restart again on all lanes,which drive VIP to capture errors so disabling error for his period, this disble- enable checker period is tentatively defined since there is not definite time predication indication.
     disable_lt_tx_checker();
     disable_lt_rx_checker();

    //ADD lt_status prediction 
    //FB_FIX : FB-578097 and 577811, just read status register wihtout comparision, 
// FIXME-MISSING_REG_IN_GDR    // reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]});
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_anlt_seq_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR  //   p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_cfg2_OFFSET_REG,'h0);
     end
     `ifndef CRETE3 // C2 specific delay to enable checker again
       #30us;
     `endif
   enable_lt_rx_checker();
   enable_lt_tx_checker();

     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
       wait_for_lt_vip_event();
     end
     else begin
      wait( p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane0 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
     `uvm_info("wait_for_lt_complete", $sformatf("lane 0 up "), UVM_NONE);
      p_sequencer.env.disable_snps_errors();
// FIXME-MISSING_REG_IN_GDR      reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR      reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000007);
     end
     
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_lt_cfg2_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_anlt_seq_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR //    p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_lt_cfg2_OFFSET_REG,read_data);
    //`ifdef G100 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
   end
    //`endif vinoth2x
    //`ifdef G25 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
   end
    //`endif vinoth2x

     p_sequencer.env.reconfig_vip_for_datamode();

     `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
     wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
     p_sequencer.env.enable_snps_errors();

     send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
     
    //`ifdef G100 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2001);
   end
    //`endif vinoth2x
    //`ifdef G25 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h0801);
   end
    //`endif vinoth2x
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_lt_cfg2_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR //    p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
   end
   else
   begin
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,restart_lane[3:0]); 
// FIXME-MISSING_REG_IN_GDR     //p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,restart_lane[7:0]); vinoth2x
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_cfg2_OFFSET_REG,'h0);

    //`ifdef G100 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
   end
    //`endif vinoth2x
    //`ifdef G25 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h0800);
   end
    //`endif vinoth2x
// FIXME-MISSING_REG_IN_GDR//     reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h1000F4);

// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_lt_cfg2_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data);

     p_sequencer.env.reconfig_vip_for_datamode();

     `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
     wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
     p_sequencer.env.enable_snps_errors();

     send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
     
    //`ifdef G100 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2001);
   end
    //`endif vinoth2x
    //`ifdef G25 vinoth2x
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h0801);
   end
    //`endif vinoth2x
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_anlt_seq_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   //  p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_lt_cfg2_OFFSET_REG,read_data);
   end
   endtask
endclass
