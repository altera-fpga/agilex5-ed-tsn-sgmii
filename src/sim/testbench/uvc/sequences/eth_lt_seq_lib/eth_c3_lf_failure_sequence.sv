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


class eth_c3_lf_failure_sequence extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit disable_max_timer;
  bit lt_failure_response; 
  bit err_flag;
  bit dis_lf_timer;
  bit [3:0] restart_lane,Lane_select_err;
  bit [7:0] restart_status[4];
  uvm_reg 	regs;
  bit[3:0] lane_trained;
  int wait_cnt;
  
  `uvm_object_utils(eth_c3_lf_failure_sequence)

  function new(string name = "eth_c3_lf_failure_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
   //reset_spico();

   p_sequencer.env.disable_snps_errors();
   Lane_select_err = 2**($urandom_range(0,3));

   p_sequencer.env.mac_callback.local_status_reg[15] = 0 ;
   bringup_status_read();

   prbs_select();

   LT_en = 1;
   AN_en = $urandom_range(0,1);
   disable_max_timer = 0; 
   enable_disable_lt(LT_en);
   enable_disable_an(AN_en);
   reset_sequencer();

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
   read_data[15:4] = 'h0;
   read_data[1] = disable_max_timer;
   read_data[4] = 1;
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);

//   case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR     'b00:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
// FIXME-MISSING_REG_IN_GDR     'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR     'b10:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
// FIXME-MISSING_REG_IN_GDR     'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
//   endcase

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,($urandom & 'h0000_7007)); 
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
   lt_failure_response =  read_data[12];
   dis_lf_timer = read_data[2];
   `uvm_info(get_name(), $sformatf("******* ERROR INJECTION ***************"), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Restart AN sequencer    :%0d ",read_data[0]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disabl AN Timer         :%0d ",read_data[1]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable LF Timer        :%0d ",read_data[2]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Failure Response     :%0d ",read_data[12]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Fail if Hiber on/off :%0d ",read_data[13]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Skip LT on AN Timeout   :%0d ",read_data[14]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable max wait timer  :%0d ",disable_max_timer), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Lane_select_err      :%0d ",Lane_select_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);

   wait_for_an_vip_event(AN_en);

   p_sequencer.env.reconfig_vip_for_lt_mode(5000);//wait timer is extend not to stop LT traffic from vip and extend the link ready state
   disable_lt_rx_checker();
   disable_lt_tx_checker();

   err_flag = 1;

   fork :lt_failure;
    
     begin
        if(Lane_select_err[0] == 1'b1) 
        begin
          p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
          p_sequencer.env.mac_callback.lane_select[0] = 1'b1;
          p_sequencer.env.mac_callback.local_status_reg = 'h0000;
          `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
          `uvm_info(get_name(), $sformatf("Lane 0 waiting for PRESET command "), UVM_NONE);
          wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h2000);
          `uvm_info(get_name(), $sformatf("Lane 0 PRESET command received "), UVM_NONE);
          p_sequencer.env.mac_callback.local_status_reg = 'h003F;
          wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h0000);
          `uvm_info(get_name(), $sformatf("Lane 0 PRESET command completed "), UVM_NONE);
          p_sequencer.env.mac_callback.local_status_reg = 'h0000;
        end
     end

     begin
        if(Lane_select_err[1] == 1'b1) 
        begin
          p_sequencer.env.mac_callback.lane_select[1] = 1'b1;
          p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
          p_sequencer.env.mac_callback.local_status_reg = 'h0000;
          `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select            :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
          `uvm_info(get_name(), $sformatf("Lane 1 waiting for PRESET command "), UVM_NONE);
          wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h2000);
          `uvm_info(get_name(), $sformatf("Lane 1 PRESET command received "), UVM_NONE);
          p_sequencer.env.mac_callback.local_status_reg = 'h003F;
          wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h0000);
          `uvm_info(get_name(), $sformatf("Lane 1 PRESET command completed "), UVM_NONE);
          p_sequencer.env.mac_callback.local_status_reg = 'h0000;
        end
     end

     begin
        if(Lane_select_err[2] == 1'b1)
        begin 
          p_sequencer.env.mac_callback.lane_select[2] = 1'b1;
          p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
          p_sequencer.env.mac_callback.local_status_reg = 'h0000;
          `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select               :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
          `uvm_info(get_name(), $sformatf("Lane 2 waiting for PRESET command "), UVM_NONE);
          wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h2000);
          `uvm_info(get_name(), $sformatf("Lane 2 PRESET command received "), UVM_NONE);
          p_sequencer.env.mac_callback.local_status_reg = 'h003F;
          wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h0000);
          `uvm_info(get_name(), $sformatf("Lane 2 PRESET command completed "), UVM_NONE);
          p_sequencer.env.mac_callback.local_status_reg = 'h0000;
        end
     end
     
     begin
        if(Lane_select_err[3] == 1'b1) 
        begin 
          p_sequencer.env.mac_callback.lane_select[3] = 1'b1;
          p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
          p_sequencer.env.mac_callback.local_status_reg = 'h0000;
          `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select             :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
          `uvm_info(get_name(), $sformatf("Lane 3 waiting for PRESET command "), UVM_NONE);
          wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h2000);
          `uvm_info(get_name(), $sformatf("Lane 3 PRESET command received "), UVM_NONE);
          p_sequencer.env.mac_callback.local_status_reg = 'h003F;
          wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h0000);
          `uvm_info(get_name(), $sformatf("Lane 3 PRESET command complete "), UVM_NONE);
          p_sequencer.env.mac_callback.local_status_reg = 'h0000;
        end
     end

     begin
       wait( p_sequencer.env.mac_callback.lane_select != 'h0);
       forever 
       begin 
         send_lt_trans_from_vip();
       end
     end 

     begin
         @(p_sequencer.env.spy_if.training_fail);
         err_flag=0;
         `uvm_info(get_name(), $sformatf("1st:wait for p_sequencer.env.spy_if.training_fail(%0h) times",p_sequencer.env.spy_if.training_fail), UVM_NONE);
	 disable lt_failure; 
     end
   join


   wait_cnt = (((p_sequencer.env.dyn_rcfg_obj_inst.ltkr *2 ) - (p_sequencer.env.spy_if.rtl_mwt*10))/50) ;
   `uvm_info(get_name(), $sformatf("wait_cnt                   :%0d ",wait_cnt), UVM_NONE);
     
   if({dis_lf_timer,lt_failure_response} == 2'b00)
   begin
      while(1)
      begin 
// FIXME-MISSING_REG_IN_GDR        p_sequencer.env.reg_read(`REGISTERS_anlt_seq_status_OFFSET_REG,read_data,1);
	if(read_data[2] == 1'b1) begin//LF timeout wait
	 break;
	end
	else begin
        if(read_data != 'h200) `uvm_error(get_name(), "case 1 : sequencer mode is not correct"); 
        end
        #10us;
      end
      p_sequencer.env.reset_vip();
      enable_lt_rx_checker();
      
      if(AN_en) begin
       p_sequencer.env.reconfig_vip_for_an_mode();
      //it would be interestin to add case in which 
      // generate lt timeout ->enable an ->disable lt -> restart sequencer in data mode ->read anlt_seq status - see how lt timeout bit behaves
      // generate lt timeout ->disable an ->disable lt -> restart sequencer in data mode ->read anlt_seq status - see how lt timeout bit behaves
      // lt time out reset by soft reset or hard reset

 //      case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR         'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR         'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h104);
//       endcase
      
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_cfg1_OFFSET_REG,read_data);
       //take care of frame lock and training bits
       restart_status[0]  = {p_sequencer.env.mac_callback.lane_select[0],p_sequencer.env.spy_if.lt_training[0],p_sequencer.env.spy_if.lt_frame_lock[0],~p_sequencer.env.mac_callback.lane_select[0]};//failed,training,frame lock,trained.
   restart_status[1]  = {p_sequencer.env.mac_callback.lane_select[1],p_sequencer.env.spy_if.lt_training[1],p_sequencer.env.spy_if.lt_frame_lock[1],~p_sequencer.env.mac_callback.lane_select[1]};//failed,training,frame lock,trained.
   restart_status[2]  = {p_sequencer.env.mac_callback.lane_select[2],p_sequencer.env.spy_if.lt_training[2],p_sequencer.env.spy_if.lt_frame_lock[2],~p_sequencer.env.mac_callback.lane_select[2]};//failed,training,frame lock,trained.
   restart_status[3]  = {p_sequencer.env.mac_callback.lane_select[3],p_sequencer.env.spy_if.lt_training[3],p_sequencer.env.spy_if.lt_frame_lock[3],~p_sequencer.env.mac_callback.lane_select[3]};//failed,training,frame lock,trained.

// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]});
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_an_status1_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_an_status2_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_an_status3_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_an_status4_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_an_status6_OFFSET_REG,'h0);
       lt_timeout = 1'b1; 
       wait_for_an_vip_event(AN_en);
      end

      if(LT_en) 
       begin
         p_sequencer.env.reconfig_vip_for_lt_mode();
         //This error is coming because if vip reconfiguraiton on tx side monitor.
	 disable_lt_tx_checker();
         wait_for_lt_vip_event();
       end
 
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data,AN_en);
       case({AN_en,LT_en})
        'b00 : begin 
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR                p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data);
               end
        'b01:  begin 
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
                end
        'b10: begin 
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
// FIXME-MISSING_REG_IN_GDR                p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data);
              end
        'b11: begin 
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
              end
       endcase

       `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
       wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
       p_sequencer.env.enable_snps_errors();

       send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
   
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2001);

       case({AN_en,LT_en})
         'b00 : begin 
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0);
                end
         'b01:  begin 
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
                 end
         'b10: begin 
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0);
               end
         'b11: begin 
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
               end
       endcase
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data,AN_en);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data,AN_en);
   end
   else if({dis_lf_timer,lt_failure_response} == 2'b10)
   begin
       for(int i=0;i<10 ;i++)
       begin
          `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
          #10us;
       end
      p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
       p_sequencer.env.mac_callback.enable_lt_status_reg_err = 0;
       p_sequencer.env.disable_snps_errors();
       //reset_spico();
       LT_en = $urandom_range(0,1);
       AN_en = $urandom_range(0,1);
       //This error is coming because if vip reconfiguraiton on tx side monitor.
       disable_lt_tx_checker();
       if(AN_en) begin p_sequencer.env.reconfig_vip_for_an_mode(); end
       enable_disable_lt(LT_en);
       enable_disable_an(AN_en);
       reset_sequencer();
       prbs_select();
 //      case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR         'b00:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
// FIXME-MISSING_REG_IN_GDR         'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR         'b10:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
// FIXME-MISSING_REG_IN_GDR         'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
//       endcase

       wait_for_an_vip_event(AN_en);

       if(LT_en) 
       begin
         p_sequencer.env.reconfig_vip_for_lt_mode();
         wait_for_lt_vip_event();
       end
       
       p_sequencer.env.reconfig_vip_for_datamode();

       `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
       wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
// FIXME-MISSING_REG_IN_GDR       reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2001);
       p_sequencer.env.enable_snps_errors();

       send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
       
       case({AN_en,LT_en})
         'b00 : begin 
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
                 if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
                 if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
                end
         'b01:  begin 
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
                 if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
                 if(read_data != 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
                 end
         'b10: begin 
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
                 if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
                 if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
               end
         'b11: begin 
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff);
// FIXME-MISSING_REG_IN_GDR                 reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
                 if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status1_OFFSET_REG data failed"); 
// FIXME-MISSING_REG_IN_GDR                 p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
                 if(read_data == 'h0000_0000) `uvm_error(get_name(), "REGISTERS_an_status2_OFFSET_REG data failed"); 
               end
       endcase
 
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR       p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
   end
   else
   begin 
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
     p_sequencer.env.reset_vip();//move to data mode.
     p_sequencer.env.reconfig_vip_for_datamode();
     `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
     wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
// FIXME-MISSING_REG_IN_GDR     reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2001);
     p_sequencer.env.enable_snps_errors();
     send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
     restart_status[0]  = {p_sequencer.env.mac_callback.lane_select[0],1'b0,1'b0,~p_sequencer.env.mac_callback.lane_select[0]};//failed,training,frame lock,trained.
     restart_status[1]  = {p_sequencer.env.mac_callback.lane_select[1],1'b0,1'b0,~p_sequencer.env.mac_callback.lane_select[1]};
     restart_status[2]  = {p_sequencer.env.mac_callback.lane_select[2],1'b0,1'b0,~p_sequencer.env.mac_callback.lane_select[2]};
     restart_status[3]  = {p_sequencer.env.mac_callback.lane_select[3],1'b0,1'b0,~p_sequencer.env.mac_callback.lane_select[3]};

     case({AN_en,LT_en})
        'b01:  begin 
// FIXME-MISSING_REG_IN_GDR            //    reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h000030,1); 
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h0,1);
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]},1);
                end
        'b11: begin 
// FIXME-MISSING_REG_IN_GDR          //      reg_predict_read(`REGISTERS_an_status_OFFSET_REG,'h1000F6,1);
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_an_status5_OFFSET_REG,'h300001ff,1);
// FIXME-MISSING_REG_IN_GDR                reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]},1);
              end
      endcase
     end
   endtask
endclass
