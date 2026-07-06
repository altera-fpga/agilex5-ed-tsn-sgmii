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


class eth_txrx_crc_cover_preamble_sequence extends eth_base_sequence;

  `uvm_object_utils(eth_txrx_crc_cover_preamble_sequence)
  function new(string name = "eth_txrx_crc_cover_preamble_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    //factory.set_type_override_by_type(eth_packet::get_type(),eth_packet_ext::get_type());
 endfunction:new

 virtual task body();
   //eth_packet tx_pkt;
   `uvm_info("eth_txrx_crc_cover_preamble_sequence", "running eth_txrx_crc_cover_preamble_sequence sequence\n",UVM_LOW)
   p_sequencer.env.rand_crc_cover_preamble=1'b1;
   p_sequencer.env.apply_reset("hard",0,0,1,11);
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));


   `ifdef ENABLE_ETH_VIP
      fork
        send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,10);  
        send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,10);  
      join
   `else
    // repeat (10)
	  //  `uvm_do_on_with(tx_pkt, 
	  //	  p_sequencer.tx_seqr,
	  //	 {tx_pkt.frame_type==ETH_DATA_FRAME;
	  //	  tx_pkt.skip_tx_crc_insertion==1'b0;
	  //	 })         
        send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,10);  
   `endif
  endtask


endclass : eth_txrx_crc_cover_preamble_sequence
