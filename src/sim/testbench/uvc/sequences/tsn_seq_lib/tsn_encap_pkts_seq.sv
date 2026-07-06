class tsn_encap_pkts_seq extends eth_base_sequence;

  `uvm_object_utils(tsn_encap_pkts_seq)

  bit [47:0] src_address;
  rand bit saddr_en;

  `ifdef ETH_MULTI_PORT
  //constraint saddr_range { saddr_en dist {0 := 1,1:= 1};}
  `else
  constraint saddr_range { saddr_en dist {0 := 1,1:= 1};}
  `endif

  uvm_reg_data_t read_data;
 
  //---------------------------------------
  //function new
  //---------------------------------------
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif

    if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames = 3;
    end    

   `uvm_info(get_name(),$sformatf("ST1: number of eth_frames set to = %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new


  //---------------------------------------
  //virtual task body();
  //---------------------------------------
  virtual task body();
     bit l_encap;

     l_encap = 1; //Tx encap IPV4 packets

    `ifdef ENABLE_ETH_VIP
	   fork
	      send_constrained_eth_frame(IPV4_FRAME, ETH_VIP_AVL_RX, num_of_frames, 128, 0, 128, 0);
	      send_constrained_eth_frame(IPV4_FRAME, AVL_TX_ETH_VIP, num_of_frames, 258, 1, 276, l_encap);
	   join

           p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us));
           p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(200us));
    `endif
  
  endtask

endclass
