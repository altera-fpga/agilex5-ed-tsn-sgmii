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


class sanity_1k_sequence extends eth_base_sequence;

  `uvm_object_utils(sanity_1k_sequence)

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
       num_of_frames=500; //Reducing num_of_frames from 1000 to 500 beacuse for 1000 frames it taking more than 4 days to execute time for 100m
   end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
    `uvm_info("eth_seq_lib", "running sanity 1k sequence\n",UVM_LOW)

    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _100M) begin
        num_of_frames = 100;     
    end else if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10M) begin
        num_of_frames = 30;     
    end

    `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
   
    `ifdef ENABLE_ETH_VIP
      fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
        if (p_sequencer.env.dyn_rcfg_obj_inst.mode == FLEXE) begin
          send_eth_frame(DATA_FRAME,FLEXE_MODE,num_of_frames);  
        end else if (p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN) begin
          send_eth_frame(DATA_FRAME,OTN_MODE,num_of_frames);  
        end	else begin
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
	    end  
      join
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(250us));
      p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(250us));
    `else
      send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
    `endif
 
  endtask
endclass
