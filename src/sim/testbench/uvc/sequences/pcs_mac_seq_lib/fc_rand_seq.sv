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


class fc_rand_seq extends eth_base_sequence;
  fc_pause_sequence pause_seq;
  `uvm_object_utils(fc_rand_seq)
  uvm_reg_data_t rd_data;
  bit[8:0] port_en;//tx_pause_en 
  bit[8:0] holdoff_en; //retransmit holdoff_en
  bit[15:0] sfc_holdoff_quanta; //retransmit holdoff_en
  bit[15:0] sfc_pause_quanta; //retransmit holdoff_en
  
  bit ready_drop;//should pause enable or disable tx transmission,will cause ready to be dropped,tx of en tx pause q no
  bit same_holdoff_en;//only in pfc
  bit [15:0] same_holdoff_quanta;
  bit [47:0] tx_da; 
  bit [47:0] tx_sa; 
  bit [1:0] tx_fc_en;//ehip cfg for tx path 
  //GDR : bit[8:0] reg_mode;//to control port or signal/for tb use only 
  bit[15:0] quanta[]; 
  bit[15:0] hold_quanta[]; 
  bit[7:0] rx_pfc_en;//rx_pause_en 
  bit rx_fc_fwd;//rx frame fwd
  bit[47:0] rx_da; 
  bit[1:0] rx_fc_en;//en dis sfc pfc on rx path 

  bit [8:0] pause_mode;
  int  itr_cnt;

  uvm_event_pool event_pool;
  uvm_event wait_fc_reg_write;

function new(string name = "seq_0");
    super.new(name);
    pause_seq=new("pause_seq");  
   `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
   `endif
    event_pool = new();
    event_pool = event_pool.get_global_pool();
    wait_fc_reg_write = event_pool.get("fc_reg_write");
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=100;
   end
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
 endfunction:new

  virtual task body();
   super.body();
   holdoff_en=0;//9'h1ff;//$urandom;//retransmit xoff en
   ready_drop=1;//$urandom;
   same_holdoff_en=0;//$urandom;
   same_holdoff_quanta=100;//$urandom;
   tx_da={$urandom,$urandom}; 
   tx_sa={$urandom,$urandom};
   tx_fc_en=3;//$urandom; 
   rx_pfc_en=8'hff;//$urandom; 
   rx_da={$urandom,$urandom}; 
   rx_fc_en=$urandom;//dynamic xoff/xon generation
   
   // When sfc_holdoff_quanta decrement from programmed value to 0, DUT generates the multiple XOFF based on the sfc_pause_quanta value
   // 10M/100M needs more time to decrement sfc_holdoff_quanta value  so we are programming to 1
   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})
     sfc_holdoff_quanta = 1;
   else
     sfc_holdoff_quanta = 100;

   sfc_pause_quanta   = 500;
   rx_fc_fwd          = $urandom_range(1,0);
   rx_fc_en           = 2'b11;//dynamic xoff/xon generation
   quanta=new[8];
   hold_quanta=new[8];
   p_sequencer.env.sb_mac_tx_vip_rx.fc_flag_en = 1;
   pause_mode[8] = $urandom_range(0,1); //0 - port based, 1 - reg based //$uranodm();

  `uvm_info("eth_seq_lib", "running fc_rand sequence\n",UVM_LOW)
   pause_seq.fc_mode   = pause_mode; //register or port
   pause_seq.pause_pfc = 0;// sfc = 0, pfc =1 //$urandom_range(0,1);

   foreach(quanta[i]) begin
      quanta[i]=125;
      pause_seq.pause_quanta[i]=quanta[i];
      randcase
      60:  hold_quanta[i]=(quanta[i] *3)/4;
      20:  hold_quanta[i]=quanta[i];
      20:  hold_quanta[i]=(quanta[i] *4)/3;
      endcase
   end
   pause_seq.pause_quanta[8]=sfc_pause_quanta;
   
   tx_sa[40]=0;
   tx_da[40]=0;

   
   p_sequencer.env.flow_agent.flow_mon.flow_control=1;
   p_sequencer.env.reg_read(`GET_REG_ADDR(tx_pauseframe_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   rd_data[0]   = $urandom_range(0,1);//1; //enable tx pause frame transmission 
   rd_data[2:1] = {1'b0,pause_mode[8]};
   `uvm_info("fc_rand_seq",$sformatf("writing tx_pauseframe_enable register with value = %0h",rd_data),UVM_NONE);
   p_sequencer.env.reg_write(`GET_REG_ADDR(tx_pauseframe_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_pause_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),sfc_pause_quanta); 
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),sfc_holdoff_quanta); 

   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   rd_data[4] = rx_fc_fwd;
   rd_data[5] = $urandom_range(0,1);//0 - process pause frame, 1- ignores pause frame //$urandom_range(0,1);
   `uvm_info("fc_rand_seq",$sformatf("writing rx_frame_control register with value = %0h",rd_data),UVM_NONE);
   p_sequencer.env.reg_write(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 

   wait_fc_reg_write.trigger();
   `uvm_info("fc_rand_seq", "All fc registers are written, triggered event..\n",UVM_LOW)

   `uvm_info("fc_rand_seq", "This test will run in Pause Mode...\n",UVM_LOW)
   `uvm_info("fc_rand_seq",$sformatf("PAUSE TIME=%dns\n",12.8*sfc_pause_quanta),UVM_LOW)
   `uvm_info("fc_rand_seq",$sformatf("HOLD TIME=%dns\n",12.8*sfc_holdoff_quanta),UVM_LOW)

   p_sequencer.env.fc_if.assertion_off = 1;
   //DM_TODO: enable after test passes
   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;

   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
      itr_cnt = 2;      
   end else begin
      itr_cnt = 4;      
   end
   
   `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
     fork
        pause_seq.start(p_sequencer.fc_sqr);
        // we are seidng the fixed size packet BCS, if DATA_FRAME paket size is more  DUT will not captures the FC request.
	send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(50,100)),.no_of_frame(10),.path(AVL_TX_ETH_VIP));
        begin
          repeat(itr_cnt) begin
	         send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1200,1500)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
	         if(rx_fc_en[0]) send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,1);  
	         if(rx_fc_en[1]) send_eth_frame(PFC_FRAME,ETH_VIP_AVL_RX,1);  
	         send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1200,1500)),.no_of_frame(14),.path(ETH_VIP_AVL_RX));
	      end
	     //GDRDVHSD:16011702597:Minimal features of fc are verified, back to back sfc/pfc packets are not handled by our tb assertion because of uncertain delay in between VIP and DUT for different variants 
          repeat(itr_cnt) begin
	         p_sequencer.env.fc_if.assertion_off=1;
	         p_sequencer.env.eth_ref_model_inst.dis_fc_assertion=1;
             send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,3);  
	         if(rx_fc_en[0]) send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,1);  
	         if(rx_fc_en[1]) send_eth_frame(PFC_FRAME,ETH_VIP_AVL_RX,1);  
          end
        end 
     join
   `else
      fork
        pause_seq.start(p_sequencer.fc_sqr);
        // we are seidng the fixed size packet BCS, if DATA_FRAME paket size is more  DUT will not captures the FC request.
	send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(100,150)),.no_of_frame(100),.path(AVL_TX_ETH_VIP));
      join
   `endif

    #5us;
   endtask
endclass
