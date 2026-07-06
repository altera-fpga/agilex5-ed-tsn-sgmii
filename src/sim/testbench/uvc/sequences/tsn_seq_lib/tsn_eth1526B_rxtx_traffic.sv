class tsn_eth1526B_rxtx_traffic extends eth_base_sequence;

    `uvm_object_utils(tsn_eth1526B_rxtx_traffic)
  
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
           num_of_frames = 40;
      end    
  
     `uvm_info(get_name(),$sformatf("ST1: number of eth_frames set to = %0d-frames",num_of_frames),UVM_NONE)
    endfunction:new
  
  
    //---------------------------------------
    //virtual task body();
    //---------------------------------------
    virtual task body();
  
      `ifdef ENABLE_ETH_VIP
          fork
            send_tx_dvlan_pkts();
	    send_eth_frame_with_fix_size(.eth_frame(STACKED_VLAN_FRAME),.frame_size(1526),.no_of_frame(num_of_frames),.path(ETH_VIP_AVL_RX));
          join

          p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us), .include_fc_pkt(0));
          p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(200us), .include_fc_pkt(0));
      `endif
    
    endtask


    task send_tx_dvlan_pkts();
       for(int i=0; i<num_of_frames; i++) begin
	  send_eth_frame_with_fix_size(.eth_frame(STACKED_VLAN_FRAME),.frame_size(1526),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
	  #20ns;
       end
    endtask

  endclass: tsn_eth1526B_rxtx_traffic
  
