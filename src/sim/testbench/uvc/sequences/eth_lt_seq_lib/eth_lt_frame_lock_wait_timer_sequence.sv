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


class eth_lt_frame_lock_wait_timer_sequence extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit disable_max_timer;
  bit [4:0] mwt_multiplier;
  bit lt_failure_response; 
  bit wait_for_frame_lock; 
  time training_start_time[4];
  time training_fail_time[4];
  bit [7:0] restart_status[4];
  bit[63:0] time_tolerance= 20000000000;
  bit[3:0] Lane_select_err;
  bit [31:0] count[4];
  `uvm_object_utils(eth_lt_frame_lock_wait_timer_sequence)

  function new(string name = "eth_lt_frame_lock_wait_timer_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
   
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
   dis_stats_chk = 1;
   `uvm_info(get_name(), $sformatf("-Expected max wait timer=%0d ",p_sequencer.env.spy_if.exp_mwt_min), UVM_NONE);
   `uvm_info(get_name(), $sformatf("-Expected max wait timer=%0d ",p_sequencer.env.spy_if.exp_mwt), UVM_NONE);
   `uvm_info(get_name(), $sformatf("-Expected max wait timer=%0d ",p_sequencer.env.spy_if.exp_mwt_max), UVM_NONE);

   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
   Lane_select_err = $urandom_range(1,'hF);
   p_sequencer.env.mac_callback.local_status_reg[15] = 0 ;
   bringup_status_read();

   prbs_select();

   LT_en = 1;
   AN_en = $urandom_range(0,1);
   enable_disable_lt(LT_en);
   enable_disable_an(AN_en);
   reset_sequencer();

   disable_max_timer = 0; 
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
   read_data[1] = disable_max_timer;
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);

  
   mwt_multiplier  = 'h0; 
   wait_for_frame_lock = 0; // this feature is no longer working,
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_params_OFFSET_REG,read_data);
   read_data[8]   = wait_for_frame_lock;
   read_data[9]   = 1; 
   read_data[4:0] = mwt_multiplier;
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_params_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_params_OFFSET_REG,read_data);

   case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR     'b00:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
// FIXME-MISSING_REG_IN_GDR     'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR     'b10:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
// FIXME-MISSING_REG_IN_GDR     'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
   endcase

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,($urandom & 'h0000_7007)); 
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
   lt_failure_response =  read_data[12];
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
   `uvm_info(get_name(), $sformatf("wait_for_frame_lock:%0d ",wait_for_frame_lock), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.enable_lt_status_reg_err            :%0d ",p_sequencer.env.mac_callback.enable_lt_status_reg_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0d ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Lane_select_err                   :%0d ",Lane_select_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.local_status_reg               :%0d ",p_sequencer.env.mac_callback.local_status_reg), UVM_NONE);
   `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);


   wait_for_an_vip_event(AN_en);

   p_sequencer.env.reconfig_vip_for_lt_mode(2000);

   fork : max_wait_timer
     begin
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 waiting for INIT command "), UVM_NONE);
        wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h1000);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 Init command received "), UVM_NONE);
        wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h0000);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 Init command complete "), UVM_NONE);
        if(Lane_select_err[0] == 1'b1) begin
        p_sequencer.env.mac_callback.lane_select[0] = 1'b1;
      p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
        `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
        end
      end

      begin
//      wait(p_sequencer.env.spy_if.lt_train_state[1][3:0]=='h3);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 waiting for INIT command "), UVM_NONE);
        wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h1000);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 Init command received "), UVM_NONE);
        wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h0000);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 Init command complete "), UVM_NONE);
      if(Lane_select_err[1] == 1'b1) begin
        p_sequencer.env.mac_callback.lane_select[1] = 1'b1;
      p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
        `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
      end
      end

      begin
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 waiting for INIT command "), UVM_NONE);
        wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h1000);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 Init command received "), UVM_NONE);
        wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h0000);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 Init command complete "), UVM_NONE);
      if(Lane_select_err[2] == 1'b1) begin 
        p_sequencer.env.mac_callback.lane_select[2] = 1'b1;
      p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
        `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
       end
      end
      
      begin
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 waiting for INIT command "), UVM_NONE);
        wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h1000);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 Init command received "), UVM_NONE);
        wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h0000);
      `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 Init command complete "), UVM_NONE);
        if(Lane_select_err[3] == 1'b1) begin 
          p_sequencer.env.mac_callback.lane_select[3] = 1'b1;
      p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
          `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
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
      if(Lane_select_err[0] == 1'b1) 
      begin
        if (p_sequencer.env.dyn_rcfg_obj_inst.anchan == 8) begin
         @(posedge p_sequencer.env.spy_if.lt_training[3])

         while(p_sequencer.env.spy_if.training_fail[3] =='h0)
         begin
           #10us;
           count[0] = count[0] + 1;
          `uvm_info(get_name(), $sformatf(" count[0] =%0d ", count[0]), UVM_NONE);
           if(count[0] > 64) begin
             break;
           end
         end
        end
        else if (p_sequencer.env.dyn_rcfg_obj_inst.anchan == 4) begin
         @(posedge p_sequencer.env.spy_if.lt_training[2])

         while(p_sequencer.env.spy_if.training_fail[2] =='h0)
         begin
           #10us;
           count[0] = count[0] + 1;
          `uvm_info(get_name(), $sformatf(" count[0] =%0d ", count[0]), UVM_NONE);
           if(count[0] > 64) begin
             break;
           end
         end
        end
        else if (p_sequencer.env.dyn_rcfg_obj_inst.anchan == 2) begin
         @(posedge p_sequencer.env.spy_if.lt_training[1])

         while(p_sequencer.env.spy_if.training_fail[1] =='h0)
         begin
           #10us;
           count[0] = count[0] + 1;
          `uvm_info(get_name(), $sformatf(" count[0] =%0d ", count[0]), UVM_NONE);
           if(count[0] > 64) begin
             break;
           end
         end
        end
        else if (p_sequencer.env.dyn_rcfg_obj_inst.anchan == 1) begin
         @(posedge p_sequencer.env.spy_if.lt_training[0])

         while(p_sequencer.env.spy_if.training_fail[0] =='h0)
         begin
           #10us;
           count[0] = count[0] + 1;
          `uvm_info(get_name(), $sformatf(" count[0] =%0d ", count[0]), UVM_NONE);
           if(count[0] > 64) begin
             break;
           end
         end
       end
     end
    end

     begin
       if(Lane_select_err[1] == 1'b1 )
       begin
        if (p_sequencer.env.dyn_rcfg_obj_inst.anchan == 2) begin
         @(posedge p_sequencer.env.spy_if.lt_training[0])

         while(p_sequencer.env.spy_if.training_fail[0] =='h0)
         begin
           #10us;
           count[1] = count[1] + 1;
          `uvm_info(get_name(), $sformatf(" count[1] =%0d ", count[1]), UVM_NONE);
           if(count[1] > 64) begin
             break;
           end
         end
        end
        else begin
         @(posedge p_sequencer.env.spy_if.lt_training[1])

         while(p_sequencer.env.spy_if.training_fail[1] =='h0)
         begin
           #10us;
           count[1] = count[1] + 1;
          `uvm_info(get_name(), $sformatf(" count[1] =%0d ", count[1]), UVM_NONE);
           if(count[1] > 64) begin
             break;
           end
         end
        end
       end
     end

     begin
       if(Lane_select_err[2] == 1'b1 ) 
       begin
        if (p_sequencer.env.dyn_rcfg_obj_inst.anchan == 4) begin
         @(posedge p_sequencer.env.spy_if.lt_training[0])
         
         while(p_sequencer.env.spy_if.training_fail[0] =='h0)
         begin
           #10us;
           count[2] = count[2] + 1;
          `uvm_info(get_name(), $sformatf(" count[2] =%0d ", count[2]), UVM_NONE);
           if(count[2] > 64) begin
             break;
           end
         end
        end
        else begin
         @(posedge p_sequencer.env.spy_if.lt_training[2])
         
         while(p_sequencer.env.spy_if.training_fail[2] =='h0)
         begin
           #10us;
           count[2] = count[2] + 1;
          `uvm_info(get_name(), $sformatf(" count[2] =%0d ", count[2]), UVM_NONE);
           if(count[2] > 64) begin
             break;
           end
         end
        end
       end
     end

     begin
       if(Lane_select_err[3] == 1'b1 ) 
       begin
        if (p_sequencer.env.dyn_rcfg_obj_inst.anchan == 8) begin
         @(posedge p_sequencer.env.spy_if.lt_training[0])
         
         while(p_sequencer.env.spy_if.training_fail[0] =='h0)
         begin
           #10us;
           count[3] = count[3] + 1;
          `uvm_info(get_name(), $sformatf(" count[3] =%0d ", count[3]), UVM_NONE);
           if(count[3] > 64) begin
             break;
           end
         end
        end
        else begin
         @(posedge p_sequencer.env.spy_if.lt_training[3])
         
         while(p_sequencer.env.spy_if.training_fail[3] =='h0)
         begin
           #10us;
           count[3] = count[3] + 1;
          `uvm_info(get_name(), $sformatf(" count[3] =%0d ", count[3]), UVM_NONE);
           if(count[3] > 64) begin
             break;
           end
         end
        end
       end
     end

     begin
       wait(p_sequencer.env.spy_if.training_fail!='h0);
       `uvm_info(get_name(), $sformatf("checker disable :p_sequencer.env.spy_if.training_fail=%0d ",p_sequencer.env.spy_if.training_fail), UVM_NONE);
       disable_lt_rx_checker();
       disable_lt_tx_checker();
     end

     begin
      @(p_sequencer.env.spy_if.lt_training);
      `uvm_info(get_name(), $sformatf("p_sequencer.env.spy_if.lt_training=%0d ",p_sequencer.env.spy_if.lt_training), UVM_NONE);
 
      for(int i=0;i<(p_sequencer.env.spy_if.rtl_mwt + 5) ;i++)
      begin
        `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
        #10us;
      end

      `uvm_info(get_name(), $sformatf(" disabled max_wait_timer "), UVM_NONE);
       disable max_wait_timer;
     end
   join

      for(int i;i<4;i++) begin
          `uvm_info(get_name(), $sformatf(" count[%0d] =%0d ", i,count[i]), UVM_NONE);
	if(Lane_select_err[i] == 1'b1) begin
          if(count[i] > 63)
          begin
            `uvm_error(get_name(), $sformatf("Lane:%0d-MWT is Greater than configured value(%0d)",i,count[i]));
          end

          if(count[i] < 57)
          begin
            `uvm_error(get_name(), $sformatf("Lane:%0d-MWT is less than configured value(%0d)",i,count[i]));
          end
        end
      end

      //LT failure status is checked in other cases, make robust checking in 18.1.1 in this case
     // restart_status[0]  = {p_sequencer.env.mac_callback.lane_select[0],1'b0,1'b0,~p_sequencer.env.mac_callback.lane_select[0]};//failed,training,frame lock,trained.
     // restart_status[1]  = {p_sequencer.env.mac_callback.lane_select[1],1'b0,1'b0,~p_sequencer.env.mac_callback.lane_select[1]};
     // restart_status[2]  = {p_sequencer.env.mac_callback.lane_select[2],1'b0,1'b0,~p_sequencer.env.mac_callback.lane_select[2]};
     // restart_status[3]  = {p_sequencer.env.mac_callback.lane_select[3],1'b0,1'b0,~p_sequencer.env.mac_callback.lane_select[3]};

     // 
// FIXME-MISSING_REG_IN_GDR     // reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]});
   end

    endtask
endclass
