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


class sanity_loopback_sequence extends eth_base_sequence;

  `uvm_object_utils(sanity_loopback_sequence)
  bit [47:0] src_address;
  rand bit saddr_en;
  //constraint saddr_range { saddr_en dist {0 := 1,1:= 1};}
  uvm_reg_data_t read_data;
 
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
	  saddr_en=$urandom_range(0,1);
     `uvm_info("eth_seq_lib", "running sanity sequence\n",UVM_LOW);
     `uvm_info(get_name(),$sformatf("Saddr_en value is %0d",saddr_en),UVM_NONE);
	if(saddr_en ==1)begin
       src_address = $random();
	   `uvm_info(get_name(),$sformatf("Source address is %0h",src_address),UVM_NONE);
       p_sequencer.env.reg_read(`GET_REG_ADDR(tx_src_addr_override_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
	   read_data[0]=1;
       p_sequencer.env.reg_write(`GET_REG_ADDR(tx_src_addr_override_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

	   read_data[31:0] =src_address[31:0] ;
 	   p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data[31:0]);
	   read_data[15:0] =src_address[47:32] ;
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data[15:0]);
       
    end

    // Retain CRC on RX side
    p_sequencer.env.reg_write((`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),32'h0);
   
    p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
    p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;

    p_sequencer.env.reg_write((`GET_REG_ADDR(phy_serial_loopback_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),1);
    wait( p_sequencer.env.spy_if.rx_block_lock == 1'b0);
    wait( p_sequencer.env.spy_if.rx_block_lock == 1'b1);
    #10us;
   
    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
    //p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us));
    #200us;
  
  endtask
endclass
