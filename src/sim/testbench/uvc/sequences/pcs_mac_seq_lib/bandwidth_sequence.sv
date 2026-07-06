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


class bandwidth_sequence extends eth_base_sequence;
  bit preamble_pass;
  int ipg;
     eth_packet req_mac;
     uvm_reg_data_t rd_data;
     uvm_reg_data_t txmac_ehip_cfg;
     uvm_reg_data_t rxmac_ehip_cfg;
  `uvm_object_utils(bandwidth_sequence)
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   `uvm_info(get_type_name(), "Executing bandwidth_sequence ...", UVM_LOW)
   //dsamantx : FIXME :Bandwidth should be calculated with loopback mode 
   //make sure that checking mechanism for the latency and BW in scoreboard should be synchronized with no of packets sent in sequence
   //sending packets for each payload size 46(min),47,48,49,50,51,52,53,54,55 to put stess on MII boundary
      p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0; 
      p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0; 
     if (p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10G,_5G,_2p5G})
        p_sequencer.env.reg_read(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
     else
        p_sequencer.env.reg_read(`GET_REG_ADDR(tx_ipg_10M_100M_1G_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
     txmac_ehip_cfg=rd_data; 
     //txmac_ehip_cfg = {rd_data[31:1],preamble_pass};
     
     p_sequencer.env.reg_write(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1'b1); 
     p_sequencer.env.reg_write(`GET_REG_ADDR(rx_custom_preamble_forward_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1'b1); 
     //p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough =0;
     p_sequencer.env.dyn_rcfg_obj_inst.ipg =12;

     `uvm_create_on(req_mac, p_sequencer.tx_seqr);
     for(int i = 0; i < 500; i++) begin
       req_mac.payload_size_c.constraint_mode(0);
       req_mac.interpacket_gap_c.constraint_mode(0);
       req_mac.skip_tx_crc_insertion_c.constraint_mode(0);
       `uvm_rand_send_with(req_mac,{frame_type == ETH_DATA_FRAME;frame_payload_type == NORMAL; payload.size == 'd46; bus_rate == BUSY;interpacket_gap == 0;num_words == 4; skip_tx_crc_insertion ==1;})
     end 
    p_sequencer.env.wait_tx_frames_received(.exp_num(500),.timeout_time(500us));
#40us;
    `uvm_info(get_type_name(), "Exiting bandwidth_sequence ...", UVM_LOW)
`uvm_info(get_type_name(), "Exiting bandwidth_sequence ...", UVM_LOW)
  endtask
endclass
