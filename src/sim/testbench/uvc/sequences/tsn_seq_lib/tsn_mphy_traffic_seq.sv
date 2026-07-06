class tsn_mphy_traffic_seq extends eth_base_sequence;

  `uvm_object_utils(tsn_mphy_traffic_seq)

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
         num_of_frames = 300;
    end    

   `uvm_info(get_name(),$sformatf("ST1: number of eth_frames set to = %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new


  //---------------------------------------
  //virtual task body();
  //---------------------------------------
  virtual task body();
     int rxsel, txsel;

      concurrent_tx_dis();

	
	`ifdef ENABLE_ETH_VIP
	`uvm_info(get_name(),$sformatf("ST1: num_of_frames=%0d", num_of_frames),UVM_NONE);
	if($test$plusargs("IPV4"))begin
           `uvm_info(get_name(),$sformatf("ST1 IPV4: num_of_frames=%0d", num_of_frames),UVM_NONE);
	   fork
	      send_eth_frame(IPV4_FRAME, ETH_VIP_AVL_RX, num_of_frames);
	      send_eth_frame(IPV4_FRAME, AVL_TX_ETH_VIP, num_of_frames);
	   join
	end
        else if($test$plusargs("IPV6"))begin	
	   `uvm_info(get_name(),$sformatf("ST1 IPV6: num_of_frames=%0d", num_of_frames),UVM_NONE);
           fork
              send_eth_frame(IPV6_FRAME, ETH_VIP_AVL_RX, num_of_frames);
              send_eth_frame(IPV6_FRAME, AVL_TX_ETH_VIP, num_of_frames);
           join
        end
	else if($test$plusargs("DATA_FRAME"))begin
	   `uvm_info(get_name(),$sformatf("ST1 DATA_FRAME: num_of_frames=%0d", num_of_frames),UVM_NONE);
           fork
              send_eth_frame(DATA_FRAME, ETH_VIP_AVL_RX, num_of_frames);
              send_eth_frame(DATA_FRAME, AVL_TX_ETH_VIP, num_of_frames);
           join
	end
	else if($test$plusargs("VLAN_FRAME"))begin
           `uvm_info(get_name(),$sformatf("ST1 VLAN_FRAME: num_of_frames=%0d", num_of_frames),UVM_NONE);
           fork
              send_eth_frame(VLAN_FRAME, ETH_VIP_AVL_RX, num_of_frames);
              send_eth_frame(VLAN_FRAME, AVL_TX_ETH_VIP, num_of_frames);
           join
        end
	else begin
          fork
             begin
	        for(int i = 0; i <num_of_frames; i++) begin
                   rxsel = $urandom_range(4,0);
	           case(rxsel)
	 	     0 : send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 1);
		     1 : send_eth_frame(IPV4_FRAME,ETH_VIP_AVL_RX, 1);
		     2 : send_eth_frame(IPV6_FRAME,ETH_VIP_AVL_RX, 1);
		     3 : send_eth_frame(VLAN_FRAME,ETH_VIP_AVL_RX, 1);
		     4 : send_eth_frame(JUMBO_DATA_FRAME,ETH_VIP_AVL_RX, 1);
		     default : send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 1);
	           endcase
                end
	     end
             begin
	        for(int k=0; k <num_of_frames; k++) begin
	           txsel = $urandom_range(4,0);
                   case(txsel)
                     0 : send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 1);
                     1 : send_eth_frame(IPV4_FRAME,AVL_TX_ETH_VIP, 1);
                     2 : send_eth_frame(IPV6_FRAME,AVL_TX_ETH_VIP, 1);
                     3 : send_eth_frame(VLAN_FRAME,AVL_TX_ETH_VIP, 1);
                     4 : send_eth_frame(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP, 1);
                     default : send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 1);
                   endcase
	        end
	     end
          join
        end

        p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us));
        p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(200us));
    `endif
  
  endtask

endclass
