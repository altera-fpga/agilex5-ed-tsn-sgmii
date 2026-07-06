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


class eth_ipg_sequence extends eth_base_sequence;
   bit preamble_pass;
   bit [1:0] tx_avg_ipg;
     uvm_reg_data_t rd_data;
     uvm_reg_data_t txmac_ehip_cfg;
     uvm_reg_data_t rxmac_ehip_cfg; 
     int frame_cnt;
     int exp_frame_cnt;
     int ipg_value;
  
  `uvm_object_utils(eth_ipg_sequence)
  
  function new(string name = "eth_ipg_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new


  virtual task pre_body();
   p_sequencer.env.ipg_checker.ipg_check_enable = 1'b1;
  endtask

  virtual task body();
   `uvm_info("eth_ipg_sequence", "Executing eth_ipg_sequence ...", UVM_LOW)

   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
       frame_cnt = 20;	   
   end else begin
       frame_cnt = 100;	   
   end
   ipg_value = $urandom_range(8,15);
   
   if (p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10G,_5G,_2p5G})
      p_sequencer.env.reg_write(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1);
   else
      p_sequencer.env.reg_write(`GET_REG_ADDR(tx_ipg_10M_100M_1G_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),ipg_value);

   exp_frame_cnt = frame_cnt/2;
   send_eth_frame(IPG_STRESS,AVL_TX_ETH_VIP,frame_cnt/2);
   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
   p_sequencer.env.wait_tx_frames_received(.exp_num(exp_frame_cnt),.timeout_time(2ms));
   end
   else 
   begin 
   p_sequencer.env.wait_tx_frames_received(.exp_num(exp_frame_cnt),.timeout_time(1ms));
   end

   if (p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10G,_5G,_2p5G})
      p_sequencer.env.reg_write(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),0);
   else
      p_sequencer.env.reg_write(`GET_REG_ADDR(tx_ipg_10M_100M_1G_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),ipg_value);
   exp_frame_cnt = frame_cnt;
   send_eth_frame(IPG_STRESS,AVL_TX_ETH_VIP,frame_cnt);

   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
   p_sequencer.env.wait_tx_frames_received(.exp_num(exp_frame_cnt),.timeout_time(2ms));
   p_sequencer.env.wait_tx_frames_received(.exp_num(exp_frame_cnt),.timeout_time(1ms));
   end
   else 
   begin 
   p_sequencer.env.wait_tx_frames_received(.exp_num(exp_frame_cnt),.timeout_time(1ms));
   end 
       
   `uvm_info("eth_ipg_sequence", "Exiting eth_ipg_sequence ...", UVM_LOW)
  endtask
endclass
