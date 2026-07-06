class tsn_mid_txreset_seq extends eth_base_sequence;

  `uvm_object_utils(tsn_mid_txreset_seq)

  uvm_reg_data_t read_data;
 
  //---------------------------------------
  //function new
  //---------------------------------------
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif

  endfunction:new


  //---------------------------------------
  //virtual task body();
  //---------------------------------------
  virtual task body();
     bit[31:0]       reg_base_addr;
     uvm_reg_data_t  rd_data1;
     int             count;

    //1. Sending traffic after power reset
     fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 30);  
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 2);  
     join_any

     `uvm_info(get_name(),$sformatf("ST1c: I am in %0d", 1), UVM_MEDIUM);
     p_sequencer.env.wait_tx_frames_received(.exp_num(2),.timeout_time(100us));


    #1us;
    //2. Write to Reset Control reg to set Tx reset on last Tx packet
    reg_base_addr = 'h1002_0300;
    p_sequencer.env.reg_write_axi('h1, reg_base_addr, 'b101); //Tx reset
    p_sequencer.env.reg_read_axi('h1, reg_base_addr, rd_data1);
    if(rd_data1[2:0] !== 'b101) 
       `uvm_error(get_name(), $psprintf("User reset:Addr=0x%0h,exp rd[2:0]='b101,act rd_data1[2:0]=%0h", 'h1*4, rd_data1[2:0]))

    `uvm_info(get_name(),$sformatf("ST1c: rd_data1[2:0]=%0d", rd_data1[2:0]), UVM_MEDIUM);

    //4. wait for Tx reset self clear by HW
    #400ns;
    p_sequencer.env.reg_read_axi('h1, reg_base_addr, rd_data1);
    count = 0;
    while( (count <400) && (rd_data1[2:0] !== 'b111) ) begin
       #250ns;
       p_sequencer.env.reg_read_axi('h1, reg_base_addr, rd_data1);
       `uvm_info(get_name(),$sformatf("ST1: rd_data1[2:0]=%0d", rd_data1[2:0]),UVM_NONE);
       count++;
    end

    `uvm_info(get_name(),$sformatf("ST1c:  I am in %0d", 2), UVM_MEDIUM);

    //5. Sending traffic after Tx midsim reset
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 10);

        p_sequencer.env.wait_client_rx_frames_done(.exp_num(30),.timeout_time(100us));
        p_sequencer.env.wait_tx_frames_received(.exp_num(10),.timeout_time(100us));

	`uvm_info(get_name(),$sformatf("ST1c:  I am in %0d", 3), UVM_MEDIUM);
  
  endtask

endclass
