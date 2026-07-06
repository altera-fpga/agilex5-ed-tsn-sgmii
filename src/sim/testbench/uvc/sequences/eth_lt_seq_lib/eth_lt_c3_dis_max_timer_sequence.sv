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


class lt_c3_dis_max_timer_sequence extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit disable_max_timer;
  bit lt_failure_response,dis_lf_timer; 
  bit[31:0] last_lt_status;
  bit [7:0] restart_status[8]; 
  uvm_reg 	regs;
  bit[7:0] lane_trained; 
  bit[7:0] Lane_select_err; 
  bit      Lane_select_err_25g;
  bit lf_timer_approx_start=0;
  int time_count;
  bit [31:0] predict_data;
  `uvm_object_utils(lt_c3_dis_max_timer_sequence)

  function new(string name = "lt_c3_dis_max_timer_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

   
 task lt_c3_dis_max_timer(speed_e speed, int node, int inst);

  LT_en = 1;
  AN_en = 0;
   disable_max_timer = 1;
   enable_disable_lt(LT_en,speed,node);
   enable_disable_an(AN_en,speed,node);
   //dis_lf_timer = (AN_en) ? 0 : 1;
   dis_lf_timer = 1'b1;
   p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),({16'h0,4'h7,8'h0,1'b0,1'b1,2'b10}),speed);
   reset_sequencer(speed,node,inst);

   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
   read_data[1] = 0;
   read_data[3:2] = 2'b01;
   p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);

   case({AN_en,LT_en})
     'b00:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h2000);
     'b01:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
     'b10:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h100);
     'b11:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h100);
   endcase

    //C3 RAL: model seq_reset bit is "RW" type,temporary patch until RAL is fixed.
    // C3 also takes time to clear the bit.
        p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed,1);
//        regs = p_sequencer.top_env.env_ip[inst].reg_model.default_map.get_reg_by_offset(`REGISTERS_anlt_seq_cfg"),speed,node);
//    read_data[0] = 1'b0;
//    //    regs.predict(.value(read_data),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.top_env.env_ip[inst].reg_model.default_map));

   `uvm_info(get_name(), $sformatf("******* ERROR INJECTION ***************"), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable max wait timer  :%0d ",disable_max_timer), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Restart AN sequencer    :%0d ",read_data[0]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disabl AN Timer         :%0d ",read_data[1]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable LF Timer        :%0d ",read_data[2]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Failure Response     :%0d ",read_data[12]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Fail if Hiber on/off :%0d ",read_data[13]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Skip LT on AN Timeout   :%0d ",read_data[14]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err            :%0d ",p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Lane_select_err                   :%0d ",Lane_select_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Lane_select_err_25g               :%0d ",Lane_select_err_25g), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg               :%0d ",p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg), UVM_NONE);
   `uvm_info(get_name(), $sformatf("*********************************"), UVM_NONE);
 
   wait_for_an_vip_event(AN_en,speed,node,inst);
   if(AN_en) begin
     `uvm_info(get_name(), $sformatf("LF timer started after AN mode :%0h ",lf_timer_approx_start), UVM_NONE);
     lf_timer_approx_start = 1'b1;
   end

   lf_timer_approx_start = 1'b1;
   p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,node);
   disable_lt_tx_checker(inst);
   //RTL does not end LT gracefully when error injection happens on either lane,
   // VIP does not support each lane disable checker so have to disable the checker for all lanes.
   disable_lt_rx_checker(inst);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_AD_MAX_WAIT_TIMER, 4000000);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_AD_HOLDOFF_TIMER, 100);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_AD_COEFF_INR_CNT, 32'd1000000);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_AD_PAM4_COEFF_PAM4_TRAIN_COUNT, 32'd1000000);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_AD_PAM4_COEFF_PAM4_NO_PRECODE_TRAIN_COUNT, 32'd1000000);

   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_AD_MAX_WAIT_TIMER, 4000000);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_AD_HOLDOFF_TIMER, 100);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_AD_COEFF_INR_CNT, 32'd1000000);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_AD_PAM4_COEFF_PAM4_TRAIN_COUNT, 32'd1000000);
   p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_AD_PAM4_COEFF_PAM4_NO_PRECODE_TRAIN_COUNT, 32'd1000000);
//   fork : dis_max_timer_1
//   begin
//       if(Lane_select_err[0] == 1'b1) 
//       begin
//         p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.lane_select[0] = 1'b1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//         `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.lane_select                   :%0h ",p_sequencer.top_env.env_ip[inst].mac_callback.lane_select), UVM_NONE);
//         `uvm_info(get_name(), $sformatf("Lane 0 waiting for PRESET command "), UVM_NONE);
//         wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h2000);
//         `uvm_info(get_name(), $sformatf("Lane 0 PRESET command received "), UVM_NONE);
//         `uvm_info(get_name(), $sformatf("LF timer started after Lane 0 PRESET command received :%0h ",lf_timer_approx_start), UVM_NONE);
//         lf_timer_approx_start = 1'b1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h003F;
//         wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h0000);
//         `uvm_info(get_name(), $sformatf("Lane 0 PRESET command completed "), UVM_NONE);
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//       end
//   end
//
//   begin
//     if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 1) begin
//       if(Lane_select_err[1] == 1'b1) 
//       begin
//         p_sequencer.top_env.env_ip[inst].mac_callback.lane_select[1] = 1'b1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//         `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.lane_select            :%0h ",p_sequencer.top_env.env_ip[inst].mac_callback.lane_select), UVM_NONE);
//         `uvm_info(get_name(), $sformatf("Lane 1 waiting for PRESET command "), UVM_NONE);
//         wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h2000);
//         `uvm_info(get_name(), $sformatf("Lane 1 PRESET command received "), UVM_NONE);
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h003F;
//         wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h0000);
//         `uvm_info(get_name(), $sformatf("Lane 1 PRESET command completed "), UVM_NONE);
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//       end
//    end
//   end
//
//   begin
//     if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 2) begin
//       if(Lane_select_err[2] == 1'b1)
//       begin 
//         p_sequencer.top_env.env_ip[inst].mac_callback.lane_select[2] = 1'b1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//         `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.lane_select               :%0h ",p_sequencer.top_env.env_ip[inst].mac_callback.lane_select), UVM_NONE);
//         `uvm_info(get_name(), $sformatf("Lane 2 waiting for PRESET command "), UVM_NONE);
//         wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h2000);
//         `uvm_info(get_name(), $sformatf("Lane 2 PRESET command received "), UVM_NONE);
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h003F;
//         wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h0000);
//         `uvm_info(get_name(), $sformatf("Lane 2 PRESET command completed "), UVM_NONE);
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//       end
//     end
//   end
//   
//   begin
//     if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 2) begin
//       if(Lane_select_err[3] == 1'b1) 
//       begin 
//         p_sequencer.top_env.env_ip[inst].mac_callback.lane_select[3] = 1'b1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 1;
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//         `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.lane_select             :%0h ",p_sequencer.top_env.env_ip[inst].mac_callback.lane_select), UVM_NONE);
//         `uvm_info(get_name(), $sformatf("Lane 3 waiting for PRESET command "), UVM_NONE);
//         wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h2000);
//         `uvm_info(get_name(), $sformatf("Lane 3 PRESET command received "), UVM_NONE);
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h003F;
//         wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h0000);
//         `uvm_info(get_name(), $sformatf("Lane 3 PRESET command complete "), UVM_NONE);
//         p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//       end
//     end
//   end
//
//   //Fix lane 4 to lane 7: revisit vinoth2x
//   begin
//     if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
//     if(Lane_select_err[4] == 1'b1) 
//     begin
//       p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 1;
//       p_sequencer.top_env.env_ip[inst].mac_callback.lane_select[4] = 1'b1;
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//       `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.lane_select                   :%0h ",p_sequencer.top_env.env_ip[inst].mac_callback.lane_select), UVM_NONE);
//       `uvm_info(get_name(), $sformatf("Lane 4 waiting for PRESET command "), UVM_NONE);
//       wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane4.received_autoadaptation_control_page[15:0]=='h2000);
//       `uvm_info(get_name(), $sformatf("Lane 4 PRESET command received "), UVM_NONE);
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h003F;
//       wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane4.received_autoadaptation_control_page[15:0]=='h0000);
//       `uvm_info(get_name(), $sformatf("Lane 4 PRESET command completed "), UVM_NONE);
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//     end
//   end
//   end
//
//   begin
//     if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
//     if(Lane_select_err[5] == 1'b1) 
//     begin
//       p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 1;
//       p_sequencer.top_env.env_ip[inst].mac_callback.lane_select[5] = 1'b1;
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//       `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.lane_select                   :%0h ",p_sequencer.top_env.env_ip[inst].mac_callback.lane_select), UVM_NONE);
//       `uvm_info(get_name(), $sformatf("Lane 5 waiting for PRESET command "), UVM_NONE);
//       wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane5.received_autoadaptation_control_page[15:0]=='h2000);
//       `uvm_info(get_name(), $sformatf("Lane 5 PRESET command received "), UVM_NONE);
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h003F;
//       wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane5.received_autoadaptation_control_page[15:0]=='h0000);
//       `uvm_info(get_name(), $sformatf("Lane 5 PRESET command completed "), UVM_NONE);
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//     end
//   end
//   end
//
//   begin
//     if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
//     if(Lane_select_err[6] == 1'b1) 
//     begin
//       p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 1;
//       p_sequencer.top_env.env_ip[inst].mac_callback.lane_select[6] = 1'b1;
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//       `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.lane_select                   :%0h ",p_sequencer.top_env.env_ip[inst].mac_callback.lane_select), UVM_NONE);
//       `uvm_info(get_name(), $sformatf("Lane 6 waiting for PRESET command "), UVM_NONE);
//       wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane6.received_autoadaptation_control_page[15:0]=='h2000);
//       `uvm_info(get_name(), $sformatf("Lane 6 PRESET command received "), UVM_NONE);
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h003F;
//       wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane6.received_autoadaptation_control_page[15:0]=='h0000);
//       `uvm_info(get_name(), $sformatf("Lane 6 PRESET command completed "), UVM_NONE);
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//     end
//   end
//   end
//
//   begin
//     if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
//     if(Lane_select_err[7] == 1'b1) 
//     begin
//       p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 1;
//       p_sequencer.top_env.env_ip[inst].mac_callback.lane_select[7] = 1'b1;
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//       `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].mac_callback.lane_select                   :%0h ",p_sequencer.top_env.env_ip[inst].mac_callback.lane_select), UVM_NONE);
//       `uvm_info(get_name(), $sformatf("Lane 7 waiting for PRESET command "), UVM_NONE);
//       wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane7.received_autoadaptation_control_page[15:0]=='h2000);
//       `uvm_info(get_name(), $sformatf("Lane 7 PRESET command received "), UVM_NONE);
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h003F;
//       wait(p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane7.received_autoadaptation_control_page[15:0]=='h0000);
//       `uvm_info(get_name(), $sformatf("Lane 7 PRESET command completed "), UVM_NONE);
//       p_sequencer.top_env.env_ip[inst].mac_callback.local_status_reg = 'h0000;
//     end
//   end
//   end
//
//   begin
//     wait( p_sequencer.top_env.env_ip[inst].mac_callback.lane_select != 'h0);
//     forever 
//     begin 
//       send_lt_trans_from_vip(inst);
//     end
//   end
//
//   join_none
     
   `uvm_info(get_name(), $sformatf("p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ltkr: %0d ",p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ltkr), UVM_NONE);
    time_count = (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ltkr  * 3.27 )/10;
   `uvm_info(get_name(), $sformatf("time_count: %0d ",time_count), UVM_NONE);
   //wait to start LF timer based on AN/LT enable disable
   wait(lf_timer_approx_start == 1'b1);
   fork : train_fail
       begin
          for(int i=0;i<500 ;i++)
           begin
              `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
              #10us;
           end
           //disable dis_max_timer_1;
       end
       begin
            `uvm_info(get_name(), $sformatf("1st : waiting for training failure "), UVM_NONE);
            wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0]==1'b1);
            `uvm_info(get_name(), $sformatf("1st : completed training failure "), UVM_NONE);
            disable train_fail;
      end
      join
   //FIXME-GDR p_sequencer.top_env.env_ip[inst].mac_callback.enable_lt_status_reg_err = 0;

   //upon link faulure RTL stop sending data on all lanes,
   // LT restart stop data on transmit lanes
   disable_lt_rx_checker(inst);
 //  restart_status[0]  = {5'b00000,Lane_select_err[0],1'b0,1'b1};//faied,training,frame lock,trained.
 //  restart_status[1]  = {5'b00000,Lane_select_err[1],1'b0,1'b1};
 //  restart_status[2]  = {5'b00000,Lane_select_err[2],1'b0,1'b1};
 //  restart_status[3]  = {5'b00000,Lane_select_err[3],1'b0,1'b1};
 //  //Fix lane 4 to lane 8: revisit vinoth2x
 //  restart_status[4]  = {5'b00000,Lane_select_err[3],1'b0,1'b1};
 //  restart_status[5]  = {5'b00000,Lane_select_err[3],1'b0,1'b1};
 //  restart_status[6]  = {5'b00000,Lane_select_err[3],1'b0,1'b1};
 //  restart_status[7]  = {5'b00000,Lane_select_err[3],1'b0,1'b1};

 //  if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
 //     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed,1);
 //  last_lt_status = read_data;
 //  if((read_data & 'hF1_F1_F1_F1) != {restart_status[3] & 8'hF1,restart_status[2] & 8'hF1,restart_status[1] & 8'hF1,restart_status[0] & 8'hF1})begin
 //     `uvm_error(get_name(), "GET_REG_ANLT(lt_status1,speed,node),rdata failed");
 //  end
 //  else begin
 //     reg_predict_read($sformatf("%s","lt_status1"),speed,node,1'b1);
 //  end
 //  end

 //  if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
 //  if(dis_lf_timer == 1'b0) 
 //  begin
 //       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed,1);
 //    if((read_data & 'h0000_0004) != 'h0000_0004)begin
 //     `uvm_error(get_name(), "LT time out flag is not set upon LF timer timeout");
 //    end
 //  end
 //  else begin
 //     reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200,1);
 //  end
 //  end
 

   if(AN_en == 1'b1 && dis_lf_timer ==1'b0)
   begin
     lt_timeout =1'b1;
     disable_lt_tx_checker(inst);

     if(AN_en) begin
      p_sequencer.top_env.reconfig_vip_for_an_mode(speed,node);
      if(anlt_std == IEEE) begin
        p_sequencer.top_env.vip_dme_page_cfg(speed,inst,0,0,anlt_std);
      end
      else if(anlt_std == CONSORTIUM) begin
        p_sequencer.top_env.vip_dme_page_cfg_consortium_mode(speed,inst,1,1,anlt_std);
      end
      else if(anlt_std == IEEE_CONSORTIUM) begin
        p_sequencer.top_env.vip_dme_page_cfg(speed,inst,1,1,anlt_std);
        p_sequencer.top_env.vip_dme_page_cfg_consortium_mode(speed,inst,1,1,anlt_std);
      end
     end

     case({AN_en,LT_en})
            'b01:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h204);
            'b11:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h104);
     endcase

     //  wait_for_an_vip_event(AN_en,1,last_lt_status); //LT wont get cleared because of seq reset
   wait_for_an_vip_event(AN_en,speed,node,inst);
   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
   read_data[1] = 1;
   read_data[3:2] = 0;
   p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);

     //ADD read of co-eff register

     if(LT_en) 
     begin
       	p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,node);
        wait_for_lt_vip_event(0,speed,node,inst);
     end     
             p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
             p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);
             p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
     

             `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
             //p_sequencer.top_env.wait_rx_pcs_ready(speed,node,inst);
             pcs_link_up(inst);
    `        uvm_info(get_name(), $sformatf("******* wait_for_rx_pcs_ready end ***************"), UVM_NONE);
             p_sequencer.top_env.env_ip[inst].enable_snps_errors();
             fork
               send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,inst);  
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,inst);  
             join
             reg_predict_read($sformatf("%s","seq_status"),speed,node,'h2001);

     case({AN_en,LT_en})
       'b00 : begin 
                          //    reg_predict_read($sformatf("%s","an_status"),speed,node,'h0030);
                              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
                              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node),rdata failed"); 
                              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node),rdata failed"); 
              end
       'b01:  begin
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
                end
                if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                  reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
                end
               if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_40G, _200G}) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
                end
               if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h11111111);
                end 
                  p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node),rdata failed"); 
                              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
               if(read_data != 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node),rdata failed"); 
               end
       'b10: begin 
                         //     reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
		//`endif vinoth2x
                              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
                              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node),rdata failed"); 
                              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node),rdata failed"); 
             end
       'b11: begin
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
                end
                if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                  reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
                end
               if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_40G, _200G}) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
                end
               if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h11111111);
                end 
                       
                   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node),rdata failed"); 
                              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
               if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node),rdata failed"); 
             end
     endcase
 
         p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
         p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);
         p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);

   end
   else begin
    predict_data = 'h200;
    predict_data[2] = ~dis_lf_timer;

   for(int i=0;i<10 ;i++)
   begin
      `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
      #10us;
        reg_predict_read($sformatf("%s","seq_status"),speed,node,predict_data,1);
   end
     p_sequencer.top_env.env_ip[inst].apply_reset(.rst_type("hard"),.ip_rst(1));
   
          if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
   		p_sequencer.top_env.env_ip[inst].disable_snps_errors();
              end
          if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
          	p_sequencer.top_env.env_ip[inst].disable_snps_errors();
              end


        p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed);
        p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed);
        p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
        p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);
        p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
        p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
     //   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed); 

     AN_en = 1;
     LT_en = 1;

     //This error is coming because if vip reconfiguraiton on tx side monitor.
     disable_lt_tx_checker(inst);

   if(AN_en) begin
     p_sequencer.top_env.reconfig_vip_for_an_mode(speed,node);
     if(anlt_std == IEEE) begin
        p_sequencer.top_env.vip_dme_page_cfg(speed,inst,0,0,anlt_std);
      end
      else if(anlt_std == CONSORTIUM) begin
        p_sequencer.top_env.vip_dme_page_cfg_consortium_mode(speed,inst,1,1,anlt_std);
      end
      else if(anlt_std == IEEE_CONSORTIUM) begin
        p_sequencer.top_env.vip_dme_page_cfg(speed,inst,1,1,anlt_std);
        p_sequencer.top_env.vip_dme_page_cfg_consortium_mode(speed,inst,1,1,anlt_std);
      end
    end

   enable_disable_lt(LT_en,speed,node);
   enable_disable_an(AN_en,speed,node);
   reset_sequencer(speed,node,inst);
   
   prbs_select(speed,node,inst);

   case({AN_en,LT_en})
   'b00:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h2000);
   'b01:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
   'b10:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h100);
   'b11:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h100);
   endcase

   wait_for_an_vip_event(AN_en,speed,node,inst);
   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
   read_data[1] = 1;
   read_data[3:2] = 0;
   p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);

   //ADD read of co-eff register

   if(LT_en) 
   begin
     p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,node);
     wait_for_lt_vip_event(0,speed,node,inst);
   end
   
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
   
   if(!LT_en) 
   begin
   p_sequencer.top_env.reconfig_vip_for_datamode(speed,node);
   end

             `uvm_info("lt_c3_dis_max_wait_timer_sequence", $sformatf(" Waiting for seq ready"), UVM_NONE);
             //p_sequencer.top_env.wait_rx_pcs_ready(speed,node,inst);
             pcs_link_up(inst);
    `        uvm_info(get_name(), $sformatf("******* wait_for_rx_pcs_ready end ***************"), UVM_NONE);
             p_sequencer.top_env.env_ip[inst].enable_snps_errors();
             fork
               send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,inst);  
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,inst);  
             join


             if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h2001);
     end

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h8001);
     end

     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h0801);
     end

     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _10G) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h0401);
     end

     if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h1001);
     end
     
     if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h10001);
     end
    
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h40001);
     end
     
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _40G) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h4001);
     end
     
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h20001);
     end 


   case({AN_en,LT_en})
     'b00 : begin 
                      //    reg_predict_read($sformatf("%s","an_status"),speed,node,'h0030);
                          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
                          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
             if(read_data != 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node),rdata failed"); 
                          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
             if(read_data != 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node),rdata failed"); 
            end
     'b01:  begin
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
                end
                if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                  reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
                end
               if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_40G, _200G}) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
                end
               if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h11111111);
                end
 
            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
             if(read_data != 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node),rdata failed"); 
                          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
             if(read_data != 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node),rdata failed"); 
             end
     'b10: begin 
                     //     reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
                          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
                          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
             if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node),rdata failed"); 
                          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
             if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node),rdata failed"); 
           end
     'b11: begin 
              if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
                end
                if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
                end
                if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                  reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
                end
               if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_40G, _200G}) begin
                 reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
                end
               if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h11111111);
                end 
              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
             if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node),rdata failed"); 
                          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
             if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node),rdata failed"); 
           end
   endcase
 
           p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
           p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);
           p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
 end
  endtask

  virtual task body();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
     string func_name = "lt_c3_dis_max_timer_sequence_body";
     `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
     fork
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_10g) begin
           node_idx_10g = get_start_node(_10G);
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g + num_inst_25g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g + num_inst_25g + num_inst_10g);inst++) begin
             automatic int idx;
             automatic int i = inst;
             if(i != 0) 
                node_idx_10g++;
             idx = node_idx_10g;
             `uvm_info(get_type_name(), $sformatf("Speed 10G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_10g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 10G - lt_c3_dis_max_timer Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
                     lt_c3_dis_max_timer(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 10G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_25g) begin
           node_idx_25g = get_start_node(_25G);
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g + num_inst_25g);inst++) begin
             automatic int idx;
             automatic int i = inst;
             if(i != 0) 
                node_idx_25g++;
             idx = node_idx_25g;
             `uvm_info(get_type_name(), $sformatf("Speed 25G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_25g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 25G - lt_c3_dis_max_timer Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
                     lt_c3_dis_max_timer(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 25G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_40g) begin
           node_idx_40g = get_start_node(_40G);
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g);inst++) begin
             automatic int idx;
             automatic int i = inst;
             if(i != 0) 
                node_idx_40g++;
             idx = node_idx_40g;
             `uvm_info(get_type_name(), $sformatf("Speed 40G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_40g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 40G - lt_c3_dis_max_timer Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
                     lt_c3_dis_max_timer(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 40G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_50g) begin
           node_idx_50g = get_start_node(_50G);
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_50g++;
             idx = node_idx_50g;
             `uvm_info(get_type_name(), $sformatf("Speed 50G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_50g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_50g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 50G - lt_c3_dis_max_timer Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_50g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]), UVM_NONE);
                     lt_c3_dis_max_timer(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 50G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end
       
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_100g) begin
           node_idx_100g = get_start_node(_100G);
           for(int inst=(num_inst_400g + num_inst_200g);inst<(num_inst_400g + num_inst_200g + num_inst_100g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_100g++;
             idx = node_idx_100g;
             `uvm_info(get_type_name(), $sformatf("Speed 100G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_100g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_100g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 100G - lt_c3_dis_max_timer Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_100g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]), UVM_NONE);
                     lt_c3_dis_max_timer(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 100G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end
   
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_200g) begin
           node_idx_200g = get_start_node(_200G);
           for(int inst=num_inst_400g;inst<(num_inst_400g + num_inst_200g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_200g++;
             idx = node_idx_200g;
             `uvm_info(get_type_name(), $sformatf("Speed 200G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_200g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_200g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 200G - lt_c3_dis_max_timer Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_200g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]), UVM_NONE);
                     lt_c3_dis_max_timer(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 200G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end
       
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_400g) begin
           node_idx_400g = get_start_node(_400G);
           for(int inst=0;inst<num_inst_400g;inst++) begin
             automatic int idx = node_idx_400g;
             automatic int i=inst;
             `uvm_info(get_type_name(), $sformatf("Speed 400G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_400g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 400G - lt_c3_dis_max_timer Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
                     lt_c3_dis_max_timer(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 400G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end
     join
     `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
   endtask:body
 
endclass:lt_c3_dis_max_timer_sequence
