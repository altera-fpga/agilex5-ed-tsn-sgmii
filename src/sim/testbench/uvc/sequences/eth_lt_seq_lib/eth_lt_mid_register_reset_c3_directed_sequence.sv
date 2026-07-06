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


class eth_lt_mid_register_reset_c3_directed_sequence extends eth_lt_base_sequence;

  bit [2:0] reset_bits;
  bit lt_in_middle;
  int reset_point_stage;
  bit [31:0] last_lt_status;

  `uvm_object_utils(eth_lt_mid_register_reset_c3_directed_sequence)

  function new(string name = "eth_lt_mid_register_reset_c3_directed_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   
     p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
     p_sequencer.env.disable_snps_errors();

     bringup_status_read();
     prbs_select();
   `ifdef CRETE3
    //`ifdef G100
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
      #500us;
     end
    //`endif
   `endif
    
   `ifdef CRETE3
    //`ifdef G25
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
    end
    //`endif
   `endif

   `ifdef CRETE3
    //`ifdef G10
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
     #550us;
    end
    //`endif
   `endif

    //`ifdef G100
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     LT_en = 1;
     AN_en = $urandom_range(0,1);
    end
    //`endif

    //`ifdef G25
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
      LT_en = 1;
      AN_en = $urandom_range(0,1);
      end
   //`endif

   //`ifdef G10
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
      LT_en = 1;
      AN_en = $urandom_range(0,1);
      end
   //`endif

    enable_disable_lt(LT_en);
    enable_disable_an(AN_en);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,(($urandom & 'h0000_7006)| 'h0000_0000));
    reset_sequencer();

     //case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR       'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR       'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
     //endcase

    `ifdef CRETE3
    //C3 RAL: model seq_reset bit is "RW" type,temporary patch until RAL is fixed.
    //C3 also takes time to clear the bit.
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR    regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_anlt_seq_cfg_OFFSET_REG);
    read_data[0] = 1'b0;
    regs.predict(.value(read_data),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
   `else
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
   `endif
  //  `ifdef CRETE3
  //    //`ifdef G100
  //     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
  //       reset_spico();
  //    end
  //    //`else
  //    else if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
  //      reset_spico_25g();
  //    end
  //    //`endif
  //  `endif

     `uvm_info(get_name(), $sformatf("******* RTL CONFIG ***************"), UVM_NONE);
     `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
     `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
     `uvm_info(get_name(), $sformatf("Restart AN sequencer    :%0d ",read_data[0]), UVM_NONE);
     `uvm_info(get_name(), $sformatf("Disabl AN Timer         :%0d ",read_data[1]), UVM_NONE);
     `uvm_info(get_name(), $sformatf("Disable LF Timer        :%0d ",read_data[2]), UVM_NONE);
     `uvm_info(get_name(), $sformatf("LT Failure Response     :%0d ",read_data[12]),UVM_NONE);
     `uvm_info(get_name(), $sformatf("LT Fail if Hiber on/off :%0d ",read_data[13]),UVM_NONE);
     `uvm_info(get_name(), $sformatf("Skip LT on AN Timeout   :%0d ",read_data[14]),UVM_NONE);
     `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);

     wait_for_an_vip_event(AN_en);

     //ADD read of co-eff register 

     p_sequencer.env.reconfig_vip_for_lt_mode();
    	//`ifdef G25 
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
      		if(AN_en == 1) begin
      		p_sequencer.env.mac_cfg.cfg[0].interface_select = 1;
      		`uvm_info(get_type_name(), $psprintf("reconfiguring VIP agent config for AN-EN:\n",p_sequencer.env.mac_cfg.print()), UVM_NONE);
       		p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.env.mac_cfg);
      		end
	end
	//`endif

    	//`ifdef G10 
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
      		if(AN_en == 1) begin
      		p_sequencer.env.mac_cfg.cfg[0].interface_select = 1;
      		`uvm_info(get_type_name(), $psprintf("reconfiguring VIP agent config for AN-EN:\n",p_sequencer.env.mac_cfg.print()), UVM_NONE);
       		p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.env.mac_cfg);
      	end
      end
     //`endif
     reset_point_stage = $urandom_range('h10,'h3F);

  
     //`ifdef G100
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
	//FIXME-GDR kr_rst_req not found in spy interface previously.
        `uvm_info(get_name(), $sformatf("waiting for kr_rst_req  :%0h ",p_sequencer.env.spy_if.kr_rst_req),UVM_NONE);
        wait(p_sequencer.env.spy_if.kr_rst_req == 0 );
        `uvm_info(get_name(), $sformatf("kr_rst_req  :%0h ",p_sequencer.env.spy_if.kr_rst_req),UVM_NONE);
      end
     else begin
      //`else
        //wait( p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane0 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
        //`uvm_info("wait_for_lt_complete", $sformatf("lane 0 up "), UVM_NONE);
        //p_sequencer.env.disable_snps_errors();
// FIXME-MISSING_REG_IN_GDR        //reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR        //reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000007);
        `uvm_info(get_name(), $sformatf("waiting for kr_rst_req  :%0h ",p_sequencer.env.spy_if.kr_rst_req),UVM_NONE);
        wait(p_sequencer.env.spy_if.kr_rst_req == 0 );
        `uvm_info(get_name(), $sformatf("kr_rst_req  :%0h ",p_sequencer.env.spy_if.kr_rst_req),UVM_NONE);
     end
     //`endif

     `ifndef CRETE3
      //upon LT disabled/seq restart, RTL stops sending LT data but VIP still in LT mode C2-FB-566672 point-3
      disable_lt_tx_checker();
      disable_lt_rx_checker();
     `endif

    //`ifdef G100
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     LT_en = $urandom_range(0,1);
     AN_en = $urandom_range(0,1);
     end
     //`endif

    //`ifdef G25
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
     LT_en = $urandom_range(0,1);
     AN_en = $urandom_range(0,1);
     end
     //`endif

    //`ifdef G10
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
     LT_en = $urandom_range(0,1);
     AN_en = $urandom_range(0,1);
     end
     //`endif

   
     `uvm_info(get_name(), $sformatf("******* RTL CONFIG ***************"), UVM_NONE);
     `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
     `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
     `uvm_info(get_name(), $sformatf("**********************************"), UVM_NONE);

     p_sequencer.env.disable_snps_errors();
     enable_disable_lt(LT_en);
     enable_disable_an(AN_en);
     reset_sequencer();
     p_sequencer.env.reset_vip();
    
     //AN restart takes time so it wont clear the an_statusx register until 870us from sequencer
     //restart
     `ifdef CRETE3
       if(AN_en) begin
        #500us;
       end
     `endif
 
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_an_status1_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_an_status2_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR//     reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h0030);

     case({AN_en,LT_en})
       'b00:begin
	    //`ifdef G100
            if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR	     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000); 
            end
            //`endif
	    //`ifdef G25
            if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR	     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h800); 
            end
	    //`endif
	    //`ifdef G10
            if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR	     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h400); 
            end
	    //`endif
// FIXME-MISSING_REG_IN_GDR             reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0);
	    end
       'b01:begin 
// FIXME-MISSING_REG_IN_GDR              reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200); 
	     //can't predict exact status, fix it in 18.1.1 for robust testing
// FIXME-MISSING_REG_IN_GDR            //  reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0);
	    end
       'b10:begin 
// FIXME-MISSING_REG_IN_GDR              reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
// FIXME-MISSING_REG_IN_GDR              reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0);
	    end
       'b11:begin 
// FIXME-MISSING_REG_IN_GDR              reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100); 
// FIXME-MISSING_REG_IN_GDR              p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data,1);
              last_lt_status = read_data;
              if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_lt_status1_OFFSET_REG data failed"); 
	    end
     endcase

   if(AN_en) begin p_sequencer.env.reconfig_vip_for_an_mode(); end
   wait_for_an_vip_event(AN_en,1,last_lt_status); //LT wont get cleared because of seq reset

   //ADD read of co-eff register 
   if(LT_en) 
   begin
     p_sequencer.env.reconfig_vip_for_lt_mode();
    	//`ifdef G25 
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
      		if(AN_en == 1) begin
      		p_sequencer.env.mac_cfg.cfg[0].interface_select = 1;
      		`uvm_info(get_type_name(), $psprintf("reconfiguring VIP agent config for AN-EN:\n",p_sequencer.env.mac_cfg.print()), UVM_NONE);
       		p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.env.mac_cfg);
      		end
	end
	//`endif
    	//`ifdef G10 
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
      		if(AN_en == 1) begin
      		p_sequencer.env.mac_cfg.cfg[0].interface_select = 1;
      		`uvm_info(get_type_name(), $psprintf("reconfiguring VIP agent config for AN-EN:\n",p_sequencer.env.mac_cfg.print()), UVM_NONE);
       		p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.env.mac_cfg);
      	end
      end
     //`endif
     `ifndef CRETE3
      //Dont enable checker to address FB-592981 , LT timer expirees in after seq. restart
     // enable_lt_rx_checker();
     `endif
// FIXME-MISSING_REG_IN_GDR     //reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0); //FB_FIX-577811 for C2
    //`ifdef G100
     if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
      wait_for_lt_vip_event();
     end
     else begin
     //`else
        wait( p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane0 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
       `uvm_info("wait_for_lt_complete", $sformatf("lane 0 up "), UVM_NONE);
        p_sequencer.env.disable_snps_errors();
// FIXME-MISSING_REG_IN_GDR        reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR        reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000007);
      end
    //`endif
   end

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);

   case({AN_en,LT_en})
       'b00 : begin 
// FIXME-MISSING_REG_IN_GDR         //      reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h0030);
// FIXME-MISSING_REG_IN_GDR               reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data,1);
	       if(read_data != last_lt_status) `uvm_error(get_name(), "REGISTERS_lt_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
	      end
       'b01:  begin 
// FIXME-MISSING_REG_IN_GDR	 //      reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h000030); 
// FIXME-MISSING_REG_IN_GDR               reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
	       //`ifdef G100
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
	       end
	       //`endif
	       //`ifdef G25
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
	       end
	       //`endif
	       //`ifdef G10
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
	       end
               //`endif
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
	       end
       'b10: begin 
// FIXME-MISSING_REG_IN_GDR            //   reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h1000F6);
               //`ifdef G100
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR               reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
	       end
	       //`endif
               //`ifdef G25
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR               reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300007ff);
	       end
	       //`endif
               //`ifdef G10
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR               reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300007ff);
	       end
	       //`endif
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data,1);
	       if(read_data != last_lt_status) `uvm_error(get_name(), "REGISTERS_lt_status1_OFFSET_REG data failed"); 
             end
       'b11: begin 
// FIXME-MISSING_REG_IN_GDR	  //     reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h1000F6);
	       //`ifdef G100
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
               end
	       //`endif
	       //`ifdef G25
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300007ff);
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
               end
	       //`endif
	       //`ifdef G10
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300007ff);
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
               end
		//`endif
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
             end
     endcase
 
   p_sequencer.env.reconfig_vip_for_datamode();

    	//`ifdef G25 
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
      		if(AN_en == 1) begin
      		p_sequencer.env.mac_cfg.cfg[0].interface_select = 1;
      		`uvm_info(get_type_name(), $psprintf("reconfiguring VIP agent config for AN-EN:\n",p_sequencer.env.mac_cfg.print()), UVM_NONE);
       		p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.env.mac_cfg);
      		end
	end
	//`endif

    	//`ifdef G10 
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
      		if(AN_en == 1) begin
      		p_sequencer.env.mac_cfg.cfg[0].interface_select = 1;
      		`uvm_info(get_type_name(), $psprintf("reconfiguring VIP agent config for AN-EN:\n",p_sequencer.env.mac_cfg.print()), UVM_NONE);
       		p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.env.mac_cfg);
      	end
       end
       //`endif
   
   `ifdef CRETE3
    	//`ifdef G100 
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
         `uvm_info(get_name(), $sformatf("Waiting for data mode transiton  "), UVM_NONE);
         wait(p_sequencer.env.spy_if.seq_mode[5] ==1);
	end
      //`endif
      //`ifdef G25 
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
        `uvm_info(get_name(), $sformatf("Waiting for data mode transiton  "), UVM_NONE);
        wait(p_sequencer.env.spy_if.seq_mode[3] ==1);
       end
	//`endif
      //`ifdef G10 
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
         `uvm_info(get_name(), $sformatf("Waiting for data mode transiton  "), UVM_NONE);
         wait(p_sequencer.env.spy_if.seq_mode[2] ==1);
	end
        //`endif
   `endif

   `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
   wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
   p_sequencer.env.enable_snps_errors();

   send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
  
  //`ifdef G100 
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2001);
  end
  //`endif

  //`ifdef G25 
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h0801);
  end
  //`endif

  //`ifdef G10 
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h0401);
  end
  //`endif

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);

   `ifndef CRETE3 //FB-566592 LT resetart is not implemented in C3 for 18.1.1
   //LT restart in data mode
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,'hF);
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_cfg2_OFFSET_REG,'h0);
   `endif
   //AN reset in data mode
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_cfg2_OFFSET_REG,read_data);
   read_data[0] = 1;
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_an_cfg2_OFFSET_REG, read_data);
   read_data[0] = 0;
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_an_cfg2_OFFSET_REG,read_data); 

   case({AN_en,LT_en})
       'b00 : begin 
// FIXME-MISSING_REG_IN_GDR         //      reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h0030);
// FIXME-MISSING_REG_IN_GDR               reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data,1);
	       if(read_data != last_lt_status) `uvm_error(get_name(), "REGISTERS_lt_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
	      end
       'b01:  begin 
// FIXME-MISSING_REG_IN_GDR	 //      reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h000030); 
// FIXME-MISSING_REG_IN_GDR               reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
  	       //`ifdef G100 
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR               reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
               end
	       //`endif
  	       //`ifdef G25 
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
               end
	       //`endif
  	       //`ifdef G10 
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
               end
	       //`endif
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
	       end
       'b10: begin 
// FIXME-MISSING_REG_IN_GDR            //   reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h1000F6);
	         //`ifdef G100
                 if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR                  reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
	         end
                 //`endif
	         //`ifdef G25
                 if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR                  reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300007ff);
	         end
	         //`endif
	         //`ifdef G10
                 if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR                  reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300007ff);
	         end
	         //`endif

// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data,1);
	       if(read_data != last_lt_status) `uvm_error(get_name(), "REGISTERS_lt_status1_OFFSET_REG data failed"); 
             end
       'b11: begin 
// FIXME-MISSING_REG_IN_GDR	  //     reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h1000F6);
  		 //`ifdef G100 
                 if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
// FIXME-MISSING_REG_IN_GDR                   reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
// FIXME-MISSING_REG_IN_GDR                   reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
	         end
		 //`endif
  		 //`ifdef G25 
                 if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
// FIXME-MISSING_REG_IN_GDR                  reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300007ff);
// FIXME-MISSING_REG_IN_GDR                  reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
	         end
		//`endif
  		//`ifdef G10 
                 if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
// FIXME-MISSING_REG_IN_GDR                  reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300007ff);
// FIXME-MISSING_REG_IN_GDR                  reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h00000001);
                end
		//`endif
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR               p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
             end
     endcase
   endtask
 endclass
