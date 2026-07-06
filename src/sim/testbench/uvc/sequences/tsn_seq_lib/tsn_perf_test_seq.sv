class tsn_perf_test_seq extends eth_base_sequence;

    `uvm_object_utils(tsn_perf_test_seq)
  
    bit [47:0] src_address;
    rand bit saddr_en;
    
    constraint saddr_range { saddr_en dist {0 := 1,1:= 1};}
    
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
           num_of_frames = 1000;
      end    
  
     `uvm_info(get_name(),$sformatf("ST1: number of eth_frames set to = %0d-frames",num_of_frames),UVM_NONE)
    endfunction:new
  
  
    //---------------------------------------
    //virtual task body();
    //---------------------------------------
    virtual task body();
  
       saddr_en=$urandom_range(0,1);
       saddr_en = 1;
       `uvm_info(get_name(),$sformatf("ST1: running MR-PHY traffic %0d", 1),UVM_NONE);
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
  
     
      `ifdef ENABLE_ETH_VIP
            `uvm_info(get_name(),$sformatf("ST1: num_of_frames=%0d", num_of_frames),UVM_NONE);
          fork
            send_constrained_eth_frame(USER_DEFINED_FRAME,ETH_VIP_AVL_RX,num_of_frames,46,0,46);  
            send_constrained_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames,46,1,64);  
          join
  
          p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us), .include_fc_pkt(0));
          p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(200us), .include_fc_pkt(0));
      `else
          `uvm_info(get_name(),$sformatf("ST1a: num_of_frames=%0d", num_of_frames),UVM_NONE);
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
      `endif
    
    endtask
  
  endclass: tsn_perf_test_seq
  