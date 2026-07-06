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


class eth_lt_restart_vip_sequence extends uvm_sequence #(svt_ethernet_transaction); 

   `uvm_object_utils(eth_lt_restart_vip_sequence)

   function new (string name = "eth_lt_restart_vip_sequence");
      	super.new(name);
   endfunction : new

   virtual task body();
	for( int i=0;i<1;i++) begin
        `uvm_create(req)
         req.autoadaptation_coeff_update_pos = svt_ethernet_enum_pkg::AUTOADAPTATION_HOLD;
         req.autoadaptation_coeff_update_neg = svt_ethernet_enum_pkg::AUTOADAPTATION_HOLD; 
         req.autoadaptation_coeff_update_zero = svt_ethernet_enum_pkg::AUTOADAPTATION_HOLD;
        `uvm_send(req);
   end
  endtask: body
endclass : eth_lt_restart_vip_sequence


class eth_lt_command_sequence extends uvm_sequence #(svt_ethernet_transaction); 
  eth_lt_command_type cmt_type;
  eth_lt_coeff_upd co_eff_pos,co_eff_neg,co_eff_zero;
  bit [9:0] lane_number;
   `uvm_object_utils(eth_lt_command_sequence)

   function new (string name = "eth_lt_command_sequence");
      	super.new(name);
   endfunction : new

   virtual task body();
   `uvm_info("body", $sformatf("LT command type  %s",cmt_type.name()), UVM_NONE)
   case (cmt_type)
     PRESET     : begin
                    `uvm_create(req)
                    req.autoadaptation_coeff_update_preset = 1'b1;
		    req.enable_command_autodaptation_lane = lane_number;
	            `uvm_send(req); 
                  end
     INITIALIZE : begin
                    `uvm_create(req)
                    req.autoadaptation_coeff_update_init = 1'b1; 
		    req.enable_command_autodaptation_lane = lane_number;
	            `uvm_send(req); 
	          end
     CO_EFF_POS : begin
                    `uvm_create(req)
                    req.autoadaptation_coeff_update_pos = svt_ethernet_enum_pkg::autoadaptation_coeff_update_enum'(co_eff_pos);
		    req.enable_command_autodaptation_lane = lane_number;
	            `uvm_send(req); 
                  end
     CO_EFF_ZERO : begin
                    `uvm_create(req)
                    req.autoadaptation_coeff_update_zero = svt_ethernet_enum_pkg::autoadaptation_coeff_update_enum'(co_eff_zero);
		    req.enable_command_autodaptation_lane = lane_number;
	            `uvm_send(req); 
                  end
     CO_EFF_NEG : begin
                    `uvm_create(req)
                    req.autoadaptation_coeff_update_neg = svt_ethernet_enum_pkg::autoadaptation_coeff_update_enum'(co_eff_neg);
		    req.enable_command_autodaptation_lane = lane_number;
	            `uvm_send(req); 
                  end
     CO_EFF_ALL : begin
                    `uvm_create(req)
		    req.enable_command_autodaptation_lane = lane_number;
                    req.autoadaptation_coeff_update_pos = svt_ethernet_enum_pkg::autoadaptation_coeff_update_enum'(co_eff_pos); 
                    req.autoadaptation_coeff_update_neg = svt_ethernet_enum_pkg::autoadaptation_coeff_update_enum'(co_eff_neg);
                    req.autoadaptation_coeff_update_zero =svt_ethernet_enum_pkg::autoadaptation_coeff_update_enum'(co_eff_zero); 
	            `uvm_send(req); 
                  end
		endcase	  
  endtask: body
endclass : eth_lt_command_sequence
class eth_lt_base_sequence extends an_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit [31:0] restart_lane;
  uvm_reg 	regs;
  bit lt_timeout = 1'b0;

  //---------------------
  bit [6:0] post_preset ='h40;
  bit [6:0] pre_preset  ='h60;
  bit [6:0] main_preset ='h7F;
  bit [31:0] post_co_eff[4]; 
  bit [31:0] pre_co_eff[4] ;
  bit [31:0] main_co_eff[4];

  //---------------------

  `uvm_object_utils(eth_lt_base_sequence)

  function new(string name = "eth_lt_base_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  //task reg_predict_read(bit [11:0] address, bit [31:0] predict_value,int read_cnt=65);
  task reg_predict_read(string reg_name, speed_e speed, int node, bit [31:0] predict_value,int read_cnt=1);
   int i=0;
   //regs = p_sequencer.top_env.env_ip[inst].reg_model.default_map.get_reg_by_offset(address);
   while( i < read_cnt) begin
   `uvm_info(get_name(), $sformatf("reg_read count %0d out of %0d ",i,read_cnt), UVM_NONE);
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,reg_name),read_data,speed,1);
     //p_sequencer.top_env.env_ip[inst].reg_read_anlt(`GET_REGISTER_ANLT(reg_name,speed,node),read_data,1);
     if(read_data != predict_value) begin
         case (i) inside
	   [0:1] : begin #100ns; end
	   [2:5] : begin #1us;   end
	   [5:read_cnt] :begin #10us;  end
	endcase
     end
     else begin
       break;
     end
     i = i + 1;
   end
   //FIXME regs.predict(.value(predict_value),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.top_env.env_ip[inst].reg_model.default_map));//Sequencer is in AN mode.
   //p_sequencer.top_env.env_ip[inst].reg_read_anlt(`GET_REGISTER_ANLT(reg_name,speed,node),read_data);
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,reg_name),read_data,speed);
 endtask

  task enable_disable_lt(bit LT_en, speed_e speed,int node);
    `uvm_info(get_name(), $sformatf("******* enable_disable_lt start ***************"), UVM_NONE);
    `uvm_info(get_name(), $sformatf("LT_en:%0d",LT_en), UVM_NONE);
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
    read_data[0] = LT_en;
    p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
    `uvm_info(get_name(), $sformatf("******* enable_disable_lt end ***************"), UVM_NONE);
  endtask

  task enable_disable_an(bit AN_en, speed_e speed,int node);
    `uvm_info(get_name(), $sformatf("******* enable_disable_an start ***************"), UVM_NONE);
    `uvm_info(get_name(), $sformatf("AN_en:%0d",AN_en), UVM_NONE);
 //   if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
    if(p_sequencer.top_env.kr_cfg_inst.active_100g) begin
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed);
    end
    else begin
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed,1);   //consortium ignored
    end
    read_data[0] = AN_en;
    p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed);
    `uvm_info(get_name(), $sformatf("******* enable_disable_an end ***************"), UVM_NONE);
  endtask

task restart_link_training_from_vip(speed_e speed, int node, int inst);
   //eth_lt_restart_vip_sequence eth_seq;
   //`uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
   //`uvm_info("restart_link_training_from_vip", $sformatf("sending restart link trans to vip"), UVM_NONE);
   //eth_seq.start(p_sequencer.eth_vip_seqr_inst);
   p_sequencer.top_env.env_ip[inst].reset_vip();
   p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,node);
endtask

task send_lt_trans_from_vip(int inst);
   eth_lt_restart_vip_sequence eth_seq;
   `uvm_create_on(eth_seq, p_sequencer.virtual_sequencer_inst[inst].eth_vip_seqr_inst);
   `uvm_info("send_lt_trans_from_vip", $sformatf("sending link trans to vip"), UVM_NONE);
   eth_seq.start(p_sequencer.virtual_sequencer_inst[inst].eth_vip_seqr_inst);
endtask

 task wait_for_lt_vip_event(bit lt_timeout=1'b0,speed_e speed, int node, int inst);
   string func_name = "wait_for_lt_vip_event";
   uvm_reg_data_t read_data,lt_cfg;
   bit [31:0] lane_status;
   bit [31:0] exp_lane_status;
   bit max_timeout_expire;
   event ev_lt_lane_up;
   bit [7:0] vip_lt_done;
    `uvm_info(get_name(), $sformatf("******* wait_for_lt_vip_event start ***************"), UVM_NONE);
   //enable checker to see cheker failure during LT process 
   enable_lt_rx_checker(inst);
   //enable_lt_tx_checker();
     if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) begin
	   exp_lane_status = 'h1;
         end else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) begin
	   exp_lane_status = 'h11;
         end else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) begin
	   exp_lane_status = 'h11_11;
         end else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8) begin
	   exp_lane_status = 'h11_11_11_11;
         end
      fork: lt_comp 
	 begin
             @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ad_traning_complete_lane0;
             disable_lt_rx_checker(inst);
             disable_lt_tx_checker(inst);
	     wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane0 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
             vip_lt_done[0] = 1'b1;
            `uvm_info("wait_for_lt_complete", $psprintf("lane 0 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	     wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] && !p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0]);
	    `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 0 trained"), UVM_NONE);
	    lane_status[0] = 1'b1;
	    -> ev_lt_lane_up;
	 end	 
	 begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 1) begin
                @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ad_traning_complete_lane1;
                disable_lt_rx_checker(inst);
                disable_lt_tx_checker(inst);
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane1 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[1] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 1 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	       wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[1] && !p_sequencer.top_env.env_ip[inst].spy_if.lt_training[1]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 1 trained"), UVM_NONE);
	      lane_status[4] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end
	 begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 2) begin  
                @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ad_traning_complete_lane2;
                disable_lt_rx_checker(inst);
                disable_lt_tx_checker(inst);
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane2 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[2] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 2 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[2] && !p_sequencer.top_env.env_ip[inst].spy_if.lt_training[2]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 2 trained"), UVM_NONE);
	      lane_status[8] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end	    
	 begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 2) begin
                @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ad_traning_complete_lane3;
                disable_lt_rx_checker(inst);
                disable_lt_tx_checker(inst);
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane3 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[3] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 3 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[3] && !p_sequencer.top_env.env_ip[inst].spy_if.lt_training[3]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 3 trained"), UVM_NONE);
	      lane_status[12] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end 
	 begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
                @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ad_traning_complete_lane4;
                disable_lt_rx_checker(inst);
                disable_lt_tx_checker(inst);
	        wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane4 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
                vip_lt_done[4] = 1'b1;
               `uvm_info("wait_for_lt_complete", $psprintf("lane 4 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	       wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[4] && !p_sequencer.top_env.env_ip[inst].spy_if.lt_training[4]);
	       `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 4 trained"), UVM_NONE);
	       lane_status[16] = 1'b1;
	       -> ev_lt_lane_up;
	    end
	 end
	  begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
                @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ad_traning_complete_lane5;
                disable_lt_rx_checker(inst);
                disable_lt_tx_checker(inst);
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane5 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[5] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 5 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[5] && !p_sequencer.top_env.env_ip[inst].spy_if.lt_training[5]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 5 trained"), UVM_NONE);
	      lane_status[20] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end
	  begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
                @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ad_traning_complete_lane6;
                disable_lt_rx_checker(inst);
                disable_lt_tx_checker(inst);
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane6 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[6] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 6 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[6] && !p_sequencer.top_env.env_ip[inst].spy_if.lt_training[6]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 6 trained"), UVM_NONE);
	      lane_status[24] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end
	  begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
                @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ad_traning_complete_lane7;
                disable_lt_rx_checker(inst);
                disable_lt_tx_checker(inst);
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane7 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[7] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 7 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[7] && !p_sequencer.top_env.env_ip[inst].spy_if.lt_training[7]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 7 trained"), UVM_NONE);
	      lane_status[28] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end
         begin
	    #2ms;
	    `uvm_error(get_type_name(), $sformatf("%s: LT timeout",func_name)); 

            p_sequencer.top_env.reg_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"lt_status1")),.read_data(read_data),.speed(speed)); 
           `uvm_info(get_name(), $sformatf("%s: LT STATUS register read data :%0h",func_name,read_data), UVM_NONE);
           if(read_data != 'h0808_0808) `uvm_error(get_type_name(), $sformatf("%s: LT STATUS(addr : 0xd2) data is  incorrect ",func_name)); 

	   max_timeout_expire = 1;
           `uvm_error(get_type_name(), $sformatf("%s: LT timed out ",func_name))
          disable lt_comp; 

	 end
	 begin
	    forever
	      begin
		  @(ev_lt_lane_up);
		 `uvm_info(get_type_name(), $sformatf("%s: lane_status =%0h exp_lane_status =%0h",func_name,lane_status,exp_lane_status), UVM_LOW);
                   p_sequencer.top_env.reg_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_status")),.read_data(read_data),.speed(speed)); 
		 `uvm_info(get_name(), $sformatf("%s: AN SEQ STATUS register read data :%0h",func_name,read_data), UVM_NONE);
		 //Ram this is Late check. by this time DUT chnage mode from
		 //LT to Data. 
		 //if(read_data[13:8] != 'h2) 
		 //  `uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect ",func_name));

                 if (lane_status == exp_lane_status)begin
                         #30us;
			disable lt_comp; 
		 end
	      end // forever begin
	 end // fork branch
        begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) begin
             wait(vip_lt_done==1'b1);
            end
	    else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) begin
             wait(vip_lt_done==2'b11);
            end
	    else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) begin
             wait(vip_lt_done==4'b1111);
            end
	    else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8) begin
             wait(vip_lt_done==8'b1111_1111);
            end
            p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
        end
      join

     //some time LT does not end gracefully so VIP shouts error for incomplete frame
    `uvm_info(get_name(), $sformatf("******* wait_for_lt_vip_event end ***************"), UVM_NONE);
 endtask

task wait_for_an_vip_event(bit AN,speed_e speed, int node, int inst,bit lt_exception=0,bit[31:0] lt_exception_value='h0,bit AN_event_exception=0);
    `uvm_info(get_name(), $sformatf("******* wait_for_an_vip_event start ***************"), UVM_NONE);
    if (AN) 
    begin
      fork :an_complete
        begin
             p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_AN73_COMPLETE.wait_trigger();
             `uvm_info(get_name(), $sformatf("AN is up from VIP side "), UVM_NONE);
             wait (p_sequencer.top_env.env_ip[inst].spy_if.an_done==1'b1);
	         `uvm_info(get_name(), $sformatf("AN  is up from DUT side"), UVM_NONE);
	     disable an_complete;
        end
	    begin
            #2000us;
	    `uvm_fatal(get_type_name(), $sformatf("%s: AN timeout",UVM_NONE));
	    disable an_complete;
	    end
      join
    if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
              reg_predict_read($sformatf("%s","seq_status"),speed,node,('h100| (lt_timeout << 2) ));
    end
    else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G})begin
    if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type) begin
             reg_predict_read($sformatf("%s","seq_status"),speed,node,('h40100| (lt_timeout << 2) ));
    end
    else begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,('h100| (lt_timeout << 2) ));
    end
   end

      if(lt_exception == 1'b1)begin
               reg_predict_read($sformatf("%s","lt_status1"),speed,node,lt_exception_value );
      end
      else
      begin
                 p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
      end
            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);
      
            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
          //  reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300001ff);
      end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
        if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type) begin
        //      reg_predict_read($sformatf("%s","an_status5"),speed,node,'h378007ff);
        end
        else begin
         //     reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300007ff);
        end
      end

           reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
  
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node) data failed"); 
              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node) data failed"); 
       end
     else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node) data failed"); 
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node) data failed"); 
       end
    end
    `uvm_info(get_name(), $sformatf("******* wait_for_an_vip_event end ***************"), UVM_NONE);
  endtask

task wait_for_an_vip_event_force(bit AN,speed_e speed, int node, int inst,bit lt_exception=0,bit[31:0] lt_exception_value='h0,bit AN_event_exception=0);
    if (AN) 
    begin
         if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
           if(AN_event_exception == 1'b1) 
	   begin
	     if(p_sequencer.top_env.env_ip[inst].spy_if.an_complete_vip_mon == 1'b0) 
	     begin
               p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_AN73_COMPLETE.wait_trigger();
             end
           end
	end
        else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G})begin
          p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_AN73_COMPLETE.wait_trigger();
        end
      `uvm_info(get_name(), $sformatf("AN is up from VIP side "), UVM_NONE);
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
           reg_predict_read($sformatf("%s","seq_status"),speed,node,('h100| (lt_timeout << 2) ));
     end
     else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G})begin
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type) begin
           reg_predict_read($sformatf("%s","seq_status"),speed,node,('h40100| (lt_timeout << 2) ));
     end
     else begin
           reg_predict_read($sformatf("%s","seq_status"),speed,node,('h100| (lt_timeout << 2) ));
    end
   end

      if(lt_exception == 1'b1)begin
              reg_predict_read($sformatf("%s","lt_status1"),speed,node,lt_exception_value);
      end
      else
      begin
              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
      end
            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);

            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
       //     reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300001ff);
     end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
        if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type) begin
         //     		reg_predict_read($sformatf("%s","an_status5"),speed,node,'h378007ff);
        end
        else begin
         //     		reg_predict_read($sformatf("%s","an_status5"),speed,node,'h30000004);
        end
      end

        //   reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
  
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
         #300us;
                  p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node) data failed"); 
                  p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node) data failed"); 
       end
     else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
                 p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node) data failed"); 
                 p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node) data failed"); 
       end
    end
  endtask

task wait_for_an_vip_event_after_reset(bit AN,speed_e speed, int node, int inst,bit lt_exception=0,bit[31:0] lt_exception_value='h0);
    if (AN) 
    begin
      p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_AN73_COMPLETE.wait_trigger();
     
      `uvm_info(get_name(), $sformatf("AN is up from VIP side "), UVM_NONE);
         reg_predict_read($sformatf("%s","seq_status"),speed,node,('h100| (lt_timeout << 2) ));

      if(lt_exception == 1'b1)begin
              reg_predict_read($sformatf("%s","lt_status1"),speed,node,lt_exception_value);
      end
      else
      begin
              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
      end
            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);

            p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
      //`ifdef G100 vinoth2x
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
        //    reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300001ff);
    end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
       //     reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300007ff);
    end

         //   reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
         #300us;
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_info(get_name(),$sformatf("GET_REG_ANLT(an_status1,speed,node) data failed"),UVM_NONE); 
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_info(get_name(),$sformatf("GET_REG_ANLT(an_status2,speed,node) data failed"),UVM_NONE);
       end
      else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status1,speed,node) data failed"); 
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,1);
         if(read_data == 'h0000_0000) `uvm_error(get_name(), "GET_REG_ANLT(an_status2,speed,node) data failed"); 
       end
    end
  endtask

  task prbs_select(speed_e speed, int node, int inst);
 //  if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.cl72prbs == 'b1)
 //  begin
 //              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg3_ln0"),read_data,speed);
 //              p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg3_ln0"),{read_data[31:3],'h4},speed);
 //              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg3_ln1"),read_data,speed);
 //              p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg3_ln1"),{read_data[31:3],'h4},speed);
 //              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg3_ln2"),read_data,speed);
 //              p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg3_ln2"),{read_data[31:3],'h4},speed);
 //              p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg3_ln3"),read_data,speed);
 //              p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg3_ln3"),{read_data[31:3],'h4},speed);
 //  end
  endtask

   task bringup_status_read(speed_e speed, int node, int inst);
    `uvm_info(get_name(), $sformatf("******* bringup_status start ***************"), UVM_NONE);
  
   //C2 AN SEQ status changes quickly to AN mode
   if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
             p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed);
   end

       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg2"),read_data,speed);
       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed);
       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed);
       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);
      // p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status5"),read_data,speed);
       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
      // p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed); //this register gets reset value after some time -FB-577724
    `uvm_info(get_name(), $sformatf("******* bringup_status end ***************"), UVM_NONE);
  endtask

  task reset_sequencer(speed_e speed, int node, int inst);
    fork
      begin
       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed);
      read_data[0] = 1;
       p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed);
      read_data[0] = 0;
            reg_predict_read($sformatf("%s","seq_cfg"),speed,node,read_data);
      end
    join

  endtask

  task disable_lt_tx_checker(int inst);
      `uvm_info(get_name(), $sformatf("******* disable lt tx start ***************"), UVM_NONE);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::NOTE);
      `uvm_info(get_name(), $sformatf("******* disable lt tx end ***************"), UVM_NONE);
  endtask

  task enable_lt_tx_checker(int inst);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::ERROR);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::ERROR);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::ERROR);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::ERROR);
  endtask

  task disable_lt_rx_checker(int inst);
      `uvm_info(get_name(), $sformatf("******* disable lt rx start ***************"), UVM_NONE);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::NOTE);
      `uvm_info(get_name(), $sformatf("******* disable lt rx end ***************"), UVM_NONE);
  endtask

  task enable_lt_rx_checker(int inst);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::ERROR);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::ERROR);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::ERROR);
       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::ERROR);
  endtask

endclass

`include "eth_lt_eq_select_sequence.sv"
`include "eth_lt_hard_reset_sequence.sv"
`include "eth_lt_soft_reset_sequence.sv"
`include "eth_lt_enable_disable_sequence.sv"
`include "eth_lt_mid_register_reset_sequence.sv"
`include "eth_lt_c3_restartlt_reg_sequence.sv"
`include "eth_lt_c3_dis_max_timer_sequence.sv"
`include "cl72_compliance_seq_lib.sv"
`include "cl136_compliance_seq_lib.sv"

////
//////`ifndef G100 vinoth2x
////`ifndef G100 
////`include "eth_lt_enable_disable_sequence.sv"
//////`endif vinoth2x
////`endif 
////
//////`ifdef G100 vinoth2x
////`ifdef G100
//////`endif
////`endif
////
////
//////This sequence applies to C3 only
//`include "eth_lt_eq_select_force_sequence.sv"
//`include "eth_lt_c3_mwt_exp_sequence.sv"
////
//`include "eth_lt_mid_register_reset_c3_directed_sequence.sv"
////
////
////
//`include "eth_lt_restartlt_reg_sequence.sv"
////
////
//`include "eth_lt_dis_max_timer_sequence_case2.sv"
////
//`include "eth_lt_dis_max_timer_sequence_case1.sv"
////
//`include "eth_lf_failure_sequence.sv"
////
////`ifdef CRETE3
////
//`include "eth_c3_lf_failure_sequence.sv"
////
//////This sequence applies to C3 only
//`endif
////*****************************************************************************************************
