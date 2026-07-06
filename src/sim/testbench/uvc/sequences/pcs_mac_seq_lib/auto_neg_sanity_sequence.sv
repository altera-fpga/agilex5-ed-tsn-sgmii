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


class auto_neg_sanity_sequence extends eth_base_sequence;

  `uvm_object_utils(auto_neg_sanity_sequence)
  bit [47:0] src_address;
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=10;
   end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
    `uvm_info("eth_seq_lib", "running auto_neg_sanity sequence\n",UVM_LOW)

    //muralasx: Added below logic to insert unique unicast source address when the parameter sa =1
    if(p_sequencer.env.dyn_rcfg_obj_inst.sa==1) begin
       src_address = $random();
       src_address[40]=0;
       $display("Source address %0h",src_address);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[47:32]);
    end
   
    `ifdef ENABLE_ETH_VIP
      fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
      join
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us));
      p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(200us));
    `else
      send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
    `endif
  
  endtask
endclass
