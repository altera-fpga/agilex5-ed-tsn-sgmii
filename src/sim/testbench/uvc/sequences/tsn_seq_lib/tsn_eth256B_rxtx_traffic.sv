class tsn_eth256B_rxtx_traffic extends eth_base_sequence;

    `uvm_object_utils(tsn_eth256B_rxtx_traffic)
  
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
           num_of_frames = 100;
      end    
  
     `uvm_info(get_name(),$sformatf("ST1: number of eth_frames set to = %0d-frames",num_of_frames),UVM_NONE)
    endfunction:new
  
  
    //---------------------------------------
    //virtual task body();
    //---------------------------------------
    virtual task body();
  
      `ifdef ENABLE_ETH_VIP
          fork
            send_constrained_eth_frame(USER_DEFINED_FRAME,ETH_VIP_AVL_RX,num_of_frames,238,0,238);  
            send_constrained_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames,238,1,256);  
	    //send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(50)),.no_of_frame(2),.path(ETH_VIP_AVL_RX));
          join
  
          p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us), .include_fc_pkt(0));
          p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(200us), .include_fc_pkt(0));
      `endif
    
    endtask
  
  endclass: tsn_eth256B_rxtx_traffic
  
