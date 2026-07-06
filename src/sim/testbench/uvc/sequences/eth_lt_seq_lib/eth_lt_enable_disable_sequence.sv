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


class lt_enable_disable_sequence extends eth_lt_base_sequence;
  bit prev_LT_en; 
  `uvm_object_utils(lt_enable_disable_sequence)

  function new(string name = "lt_enable_disable_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 task lt_enable_disable(speed_e speed, int node, int inst);
   
   p_sequencer.top_env.env_ip[inst].disable_snps_errors();

   bringup_status_read(speed,node,inst);
   prbs_select(speed,node,inst);

   LT_en = 1;
   AN_en = 1;
   prev_LT_en = LT_en;
   enable_disable_lt(LT_en,speed,node);
   enable_disable_an(AN_en,speed,node);
   p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),(($urandom & 'h0000_7006)| 'h0000_0000),speed);
   reset_sequencer(speed,node,inst);

   case({AN_en,LT_en})
        'b00:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h2000);
        'b01:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
        'b10:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h100);
     'b11:begin
          if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
             reg_predict_read($sformatf("%s","seq_status"),speed,node,'h100);
          end
        end
   endcase

   
    //C3 RAL: model seq_reset bit is "RW" type,temporary patch until RAL is fixed.
    // C3 also takes time to clear the bit.
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed,1);
    //regs = p_sequencer.top_env.env_ip[inst].reg_model.default_map.get_reg_by_offset($sformatf("port%0d_%0s_csr",node,"anlt_seq_cfg"));
    //read_data[0] = 1'b0;
    //regs.predict(.value(read_data),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.top_env.env_ip[inst].reg_model.default_map));
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed);


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
  

   
   wait_for_an_vip_event(AN_en,speed,node,inst);

   if(LT_en) 
   begin
     p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,node);

      wait_for_lt_vip_event(0,speed,node,inst);

      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
         reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
         reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
         reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
         reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
          reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
          reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
          reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
      end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_40G, _200G}) begin
         reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
         reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
      end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
         reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
         reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h11111111);
      end
   end

   case({AN_en,LT_en})
       'b00 : begin 
                //      reg_predict_read($sformatf("%s","an_status"),speed,node,'h0030);
                //vshridhx revistreg_predict_read($sformatf("%s","an_status5"),speed,node,'h0);
                p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
	      end
       'b01:  begin 
               //	       reg_predict_read($sformatf("%s","an_status"),speed,node,'h000030); 
               // reg_predict_read($sformatf("%s","an_status5"),speed,node,'h0);
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
	      end
       'b10: begin 
               //reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
               //reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300001ff);
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
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
             end
   endcase
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,AN_en);
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,AN_en);
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed,AN_en);
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed,AN_en);
    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed,AN_en);

  //  p_sequencer.top_env.reconfig_vip_for_datamode(speed,node);

     `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
    `uvm_info(get_name(), $sformatf("******* wait_for_rx_pcs_ready start line number 121 ***************"), UVM_NONE);
     //p_sequencer.top_env.wait_rx_pcs_ready(speed,node,inst);
    pcs_link_up(inst);
    `uvm_info(get_name(), $sformatf("******* wait_for_rx_pcs_ready end ***************"), UVM_NONE);
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


     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed,AN_en);

     case({AN_en,LT_en})
       'b00 : begin 
                //reg_predict_read($sformatf("%s","an_status"),speed,node,'h0030);
                //reg_predict_read($sformatf("%s","an_status5"),speed,node,'h0);
                p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
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
    	     end
       'b10: begin 
               //    reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
              // reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300001ff);
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
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
             end
     endcase

     //AN reset
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),read_data,speed);
     read_data[0] = 1;
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"), read_data,speed);
     read_data[0] = 0;
     //vshridhx reg_predict_read($sformatf("%s","an_cfg2"),speed,node,read_data);

     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed,AN_en);

     case({AN_en,LT_en})
       'b00 : begin 
               //    reg_predict_read($sformatf("%s","an_status"),speed,node,'h0030);
              // reg_predict_read($sformatf("%s","an_status5"),speed,node,'h0);
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
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
            end
       'b10: begin 
               //reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
               //reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300001ff);
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed);
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
            end
     endcase
     `uvm_info(get_name(), $sformatf("******* PCR**************************"), UVM_NONE);
     #500ns;
     `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);

     LT_en = 0;
     AN_en = 1;

     `uvm_info(get_name(), $sformatf("******* RTL CONFIG ***************"), UVM_NONE);
     `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
     `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
     `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);

    p_sequencer.top_env.env_ip[inst].disable_snps_errors();

    enable_disable_lt(LT_en,speed,node);
    enable_disable_an(AN_en,speed,node);
    reset_sequencer(speed,node,inst);
    p_sequencer.top_env.env_ip[inst].reset_vip();

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
       'b00:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h2000);
       'b01:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
       'b10:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h100);
       'b11:reg_predict_read($sformatf("%s","seq_status"),speed,node,'h100);
     endcase


          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed);
       //   reg_predict_read($sformatf("%s","an_status"),speed,node,'h30);
          reg_predict_read($sformatf("%s","an_status1"),speed,node,'h0);
          reg_predict_read($sformatf("%s","an_status2"),speed,node,'h0);
          reg_predict_read($sformatf("%s","an_status3"),speed,node,'h0);
          reg_predict_read($sformatf("%s","an_status4"),speed,node,'h0);
        //  reg_predict_read($sformatf("%s","an_status5"),speed,node,'h0);
          reg_predict_read($sformatf("%s","an_status6"),speed,node,'h0);

     if(LT_en)
     begin
        if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
         if (prev_LT_en == 1'b1) begin 
                  reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
         end
         else begin 
                  reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h0,1);
     end
     //vshridhx else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
     //vshridhx    if (prev_LT_en == 1'b1)begin 
     //vshridhx             reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
     //vshridhx     end
     //vshridhx    else begin 
     //vshridhx             reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h0,1);
     //vshridhx    end
     end
     end
     else begin
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h0); 
     end

   wait_for_an_vip_event(AN_en,speed,node,inst);

      //FIX ME : wait for LT status to go un-trained.
      if(LT_en) 
      begin
        p_sequencer.top_env.reconfig_vip_for_lt_mode();

        disable_lt_tx_checker(inst); 
        wait_for_lt_vip_event(0,speed,node,inst);
        disable_lt_rx_checker(inst);
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
         reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
         reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
         reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
         reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
          reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000001);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
          reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
          reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
          reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00000011);
      end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_40G, _200G}) begin
         reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
         reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h00001111);
      end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
         reg_predict_read($sformatf("%s","seq_status"),speed,node,'h200);
         reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h11111111);
      end
    end
      case({AN_en,LT_en})
       'b00 : begin 
                //  reg_predict_read($sformatf("%s","an_status"),speed,node,'h0030);
               // reg_predict_read($sformatf("%s","an_status5"),speed,node,'h0);
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h0);
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
              end
       'b10: begin 
               //reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
              // reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300001ff);
               reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h0);
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
             end
     endcase
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed,AN_en);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed,AN_en);

     p_sequencer.top_env.reconfig_vip_for_datamode(speed,node);

     `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);

    `uvm_info(get_name(), $sformatf("******* wait_for_rx_pcs_ready start line no 359 ***************"), UVM_NONE);
     //p_sequencer.top_env.wait_rx_pcs_ready(speed,node,inst);
     pcs_link_up(inst);
    `uvm_info(get_name(), $sformatf("******* wait_for_rx_pcs_ready end ***************"), UVM_NONE);
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
                // reg_predict_read($sformatf("%s","an_status"),speed,node,'h0030);
               // reg_predict_read($sformatf("%s","an_status5"),speed,node,'h0);
                reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h0);
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
	     end
       'b10: begin 
              //reg_predict_read($sformatf("%s","an_status"),speed,node,'h1000F6);
           //   reg_predict_read($sformatf("%s","an_status5"),speed,node,'h300001ff);
              reg_predict_read($sformatf("%s","lt_status1"),speed,node,'h0);
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
            end
     endcase
          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed,AN_en);
          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed,AN_en);
          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed,AN_en);
          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed,AN_en);
          p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed,AN_en);
  endtask

  virtual task body();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
     string func_name = "lt_enable_disable_sequence_body";
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
                     `uvm_info(get_type_name(), $sformatf("Speed 10G - lt_enable_disable Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
                     lt_enable_disable(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 25G - lt_enable_disable Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
                     lt_enable_disable(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 40G - lt_enable_disable Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
                     lt_enable_disable(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 50G - lt_enable_disable Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_50g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]), UVM_NONE);
                     lt_enable_disable(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 100G - lt_enable_disable Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_100g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]), UVM_NONE);
                     lt_enable_disable(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 200G - lt_enable_disable Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_200g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]), UVM_NONE);
                     lt_enable_disable(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 400G - lt_enable_disable Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
                     lt_enable_disable(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
 
endclass:lt_enable_disable_sequence
