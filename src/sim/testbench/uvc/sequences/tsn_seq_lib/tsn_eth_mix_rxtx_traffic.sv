class tsn_eth_mix_rxtx_traffic extends eth_base_sequence;

  `uvm_object_utils(tsn_eth_mix_rxtx_traffic)

  rand int payload_size;
  
  //---------------------------------------
  //function new
  //---------------------------------------
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif

      if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
        num_of_frames = 120;
      end   

  endfunction:new


  //---------------------------------------
  //virtual task body();
  //---------------------------------------
  virtual task body();

    `uvm_info("tsn_eth_mix_rxtx_traffic_seq", "Sending the traffic",UVM_LOW);
    `ifdef ENABLE_ETH_VIP
        fork
          for(int i=0 ; i <num_of_frames ; i++) begin
          void'(std::randomize(payload_size) with {payload_size dist {10:= 70,  540:= 40, 1464:= 10};});
          send_constrained_eth_frame(IPV4_FRAME,ETH_VIP_AVL_RX,1,payload_size,0,payload_size,1);  
          send_constrained_eth_frame(IPV4_FRAME,AVL_TX_ETH_VIP,1,payload_size,1,payload_size+54,1);
          
          end 
   
        join

        p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us), .include_fc_pkt(0));
        p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(200us), .include_fc_pkt(0));
    `endif

  endtask

endclass: tsn_eth_mix_rxtx_traffic

