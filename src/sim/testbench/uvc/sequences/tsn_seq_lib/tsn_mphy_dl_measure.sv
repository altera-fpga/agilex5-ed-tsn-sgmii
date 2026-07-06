class tsn_mphy_dl_measure extends eth_base_sequence;

  `uvm_object_utils(tsn_mphy_dl_measure)

  //--------------------------------------
  //function new
  //--------------------------------------
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif

  endfunction:new
  
  //------------------------------------
  // function to calculate delay from int and frac parts
  //-----------------------------------------
  virtual function real calc_delay(int int_part, int frac_part, int num_frac_bits, real clk_time);
	real result;
	int div = (2**num_frac_bits);
	result = (real'(int_part) + (real'(frac_part)/real'(div)))*clk_time;
	return result;
  
  endfunction: calc_delay
  

  //---------------------------------------
  // virtual task body()
  //--------------------------------------
  virtual task body();
   uvm_reg_data_t  rd_data0, rd_data1;
   uvm_reg_data_t  wr_data, wr_data1;
   bit[31:0]       reg_base_addr;
   bit[3:0]        byte_en;
   int             num_shift, offset;
   bit[15:0]       t_rdata0, t_rdata1;
   int             m_frac_txdelay, m_int_txdelay, m_frac_rxdelay, m_int_rxdelay;
   int             m_frac_txsoftpcs, m_int_txsoftpcs, m_frac_rxsoftpcs, m_int_rxsoftpcs;
   //real            dl_tx_delay, dl_rx_delay;
   //real            dl_tx_softpcs, dl_rx_softpcs;
   real            dl_tx_delay_ns, dl_rx_delay_ns;
   real            dl_tx_softpcs_ns, dl_rx_softpcs_ns;
   real            tx_pma_delay_ns, rx_pma_delay_ns;
   real            tx_path_delay, rx_path_delay;
   //real            t_frac_txdelay, t_frac_rxdelay;


     `uvm_info(get_name(),$sformatf("ST2: starting tsn_mphy_dl_measure sequence %0d ", 1),UVM_NONE)
     #400ns;
       //1. check user csr ready status in user csr before reset
      `uvm_info("tsn_mphy_rst_seq", "read status\n",UVM_LOW);
      reg_base_addr = 'h1002_0300;
      offset = 0;
      p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0);
      if(rd_data0[2:0] !== 'b111)
          `uvm_error(get_name(), $psprintf("User Space Status :Addr=0x%0h,read data=%0h", offset*4, rd_data0[2:0]))

      //2. check user csr reset status in user csr before reset
      offset = 1;
      p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0);
      if(rd_data0[2:0] !== 'b111)
        `uvm_error(get_name(), $psprintf("User Space resets:Addr=0x%0h,exp rd[31:7]=0,act rd_data0[31:7]=%0h", offset*4, rd_data0[2:0]))


     //3.checking for reg default value
     reg_base_addr = 'h1002_0100;
     num_shift = 1;

     offset = 'h0;
     p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0, num_shift);
     t_rdata0 = (offset%2 == 0)? rd_data0[15:0] : rd_data0[31:16];
     `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, t_rdata0=0x%0h", offset, t_rdata0),UVM_NONE)

     if(t_rdata0[6] !== 1)
        `uvm_error(get_name(), $psprintf("MRPHY0 Control def Mismatch:Addr=0x%0h, exp t_rdata0[6]=1,act t_rdata0[6]=%0h", offset, t_rdata0[6]))

     if(t_rdata0[8] !== 1)
        `uvm_error(get_name(), $psprintf("MRPHY0 Control def Mismatch:Addr=0x%0h, exp t_rdata0[8]=1,act t_rdata0[8]=%0h", offset, t_rdata0[8]))

     //4. send tx and Rx ethernet packets
     `ifdef ENABLE_ETH_VIP
        fork
           send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 1);
           send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 1);
        join

        p_sequencer.env.wait_client_rx_frames_done(.exp_num(1),.timeout_time(100us));
        p_sequencer.env.wait_tx_frames_received(.exp_num(1),.timeout_time(100us));
    `endif

     for(int k=1; k <14; k++) begin
	#100us;
	`uvm_info(get_name(),$sformatf("ST2 Mphy0 waiting for rx measure valid: k=%0d, time=%0d us", k, k*100),UVM_NONE)
     end

     `ifdef ENABLE_ETH_VIP
        fork
           send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 1);
           send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 1);
        join

        p_sequencer.env.wait_client_rx_frames_done(.exp_num(1),.timeout_time(100us));
        p_sequencer.env.wait_tx_frames_received(.exp_num(1),.timeout_time(100us));
    `endif
     #20us;

     `uvm_info(get_name(),$sformatf("ST2: Ending sending packet %0d", 1),UVM_NONE)

     for(int i=0; i <2; i++) begin
        //5. Read Tx delay and Rx delay from reg 0x18-0x19, 0x1a-0x1b 
        //5a. Read Tx delay
        //'h17
        offset = 'h17;
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
        t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        `uvm_info(get_name(),$sformatf("ST2 TxRead Mphy0: addr='h17,rd_data1=0x%0h, t_rdata1=0x%h, t_rdata1[0]=%d (exp 1)", rd_data1, t_rdata1, t_rdata1[0]),UVM_NONE)
        if(t_rdata1[0] !== 1)
           `uvm_error(get_name(), $psprintf("MRPHY0 Txvalid: Addr=0x%0h, exp t_rdata1[0]=1, act t_rdata1[0]=0x%0h", offset, t_rdata1[0]))

        //'h18
        offset = 'h18;
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
        t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        m_frac_txdelay = t_rdata1[7:0];
        `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, rd_data1=0x%0h, m_frac_txdelay=0x%h", offset, rd_data1, m_frac_txdelay),UVM_NONE)

        //'h19
        offset = 'h19;
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
        t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        m_int_txdelay = t_rdata1[12:0];
        `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, rd_data1=0x%0h, m_int_txdelay=0x%h", offset, rd_data1, m_int_txdelay),UVM_NONE)
		
		dl_tx_delay_ns = calc_delay(m_int_txdelay, m_frac_txdelay, 8, 4.375);
		`uvm_info(get_name(),$sformatf("calculated tx delay from reg Tx_delay=%f", dl_tx_delay_ns),UVM_NONE)

        //5b. Read Rx delay
        //Read'h17 for Tx measurement valid
        //'h17
        offset = 'h17;
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
        t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        `uvm_info(get_name(),$sformatf("ST1 RxRead Mphy0: addr='h17,rd_data1=0x%0h,t_rdata1=0x%h, t_rdata1[1]=%d (exp 1)", rd_data1, t_rdata1, t_rdata1[1]),UVM_NONE)
        if(t_rdata1[1] !== 1)
           `uvm_error(get_name(), $psprintf("MRPHY0: Addr=0x%0h, exp t_rdata1[1]=1, act t_rdata1[1]=0x%0h", offset, t_rdata1[1]))

        //'h1a
        offset = 'h1a;
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
        t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        m_frac_rxdelay = t_rdata1[7:0];
        `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, rd_data1=0x%0h, m_frac_rxdelay=0x%h", offset, rd_data1, m_frac_rxdelay),UVM_NONE)

        //'h1b
        offset = 'h1b;
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
        t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        m_int_rxdelay = t_rdata1[12:0];
        `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, rd_data1=0x%0h, m_int_rxdelay=0x%h", offset, rd_data1, m_int_rxdelay),UVM_NONE)
		
		dl_rx_delay_ns = calc_delay(m_int_rxdelay, m_frac_rxdelay, 8, 4.375);
		`uvm_info(get_name(),$sformatf("calculated rx delay from reg Rx_delay=%f", dl_rx_delay_ns),UVM_NONE)
     end //for


     //6. Read Soft PCS Tx/Rx latency Rx from reg 0x1c-0x1d, 0x1e-0x1f
     //6a. Read Tx delay
     //'h1c
     offset = 'h1c;
     p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
     t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
     m_frac_txsoftpcs = t_rdata1[9:0];
     `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, rd_data1=0x%0h, m_frac_txsoftpcs=0x%h", offset, rd_data1, m_frac_txsoftpcs),UVM_NONE)

     //'h1d
     offset = 'h1d;
     p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
     t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
     m_int_txsoftpcs = t_rdata1[11:0];
     `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, rd_data1=0x%0h, m_int_txsoftpcs=0x%h", offset, rd_data1, m_int_txsoftpcs),UVM_NONE)
	 
	 dl_tx_softpcs_ns = calc_delay(m_int_txsoftpcs, m_frac_txsoftpcs, 10, 16);
	 `uvm_info(get_name(),$sformatf("calculated tx soft pcs delay Tx_softPCS=%f", dl_tx_softpcs_ns),UVM_NONE)

     //'h1e
     offset = 'h1e;
     p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
     t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
     m_frac_rxsoftpcs = t_rdata1[9:0];
     `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, rd_data1=0x%0h, m_frac_rxsoftpcs=0x%h", offset, rd_data1, m_frac_rxsoftpcs),UVM_NONE)

     //'h1f
     offset = 'h1f;
     p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
     t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
     m_int_rxsoftpcs = t_rdata1[11:0];
     `uvm_info(get_name(),$sformatf("ST2 Read Mphy0: addr=0x%0h, rd_data1=0x%0h, m_int_rxsoftpcs=0x%h", offset, rd_data1, m_int_rxsoftpcs),UVM_NONE)
	 
	 dl_rx_softpcs_ns = calc_delay(m_int_rxsoftpcs, m_frac_rxsoftpcs, 10, 16);
	 `uvm_info(get_name(),$sformatf("calculated rx soft pcs delay Rx_softPCS=%f", dl_rx_softpcs_ns),UVM_NONE)
	
     //
     //7. Compare the measurements vs. reading latency from registers. Allow
     //   Allow +/- 5ns
	
	//UI*clk_period for 2.5G
	tx_pma_delay_ns = 49 * 0.32;
	rx_pma_delay_ns = 68 * 0.32;
	`uvm_info(get_name(),$sformatf("calculated tx pma delay TxPMA=%f", tx_pma_delay_ns),UVM_NONE)
	`uvm_info(get_name(),$sformatf("calculated rx pma delay Rx_PMA=%f", rx_pma_delay_ns),UVM_NONE)
	tx_path_delay = dl_tx_delay_ns + dl_tx_softpcs_ns + tx_pma_delay_ns;
	rx_path_delay = dl_rx_delay_ns + dl_rx_softpcs_ns + rx_pma_delay_ns;
	`uvm_info(get_name(),$sformatf("calculated tx path delay tx_path_delay=%f", tx_path_delay),UVM_NONE)
	`uvm_info(get_name(),$sformatf("calculated rx path delay rx_path_delay=%f", rx_path_delay),UVM_NONE)
	
	// enable dalay comparison in scoreboard
	p_sequencer.env.sb_mac_tx_vip_rx.pkt_path_delay=tx_path_delay;
	p_sequencer.env.sb_mac_tx_vip_rx.dl_en=1;
	p_sequencer.env.sb_vip_tx_mac_rx.pkt_path_delay=rx_path_delay;
	p_sequencer.env.sb_vip_tx_mac_rx.dl_en=1;
	#400ns;
	
	//
	//8. Send more packets to compare delay
	//
	
	`uvm_info(get_name(),$sformatf("Packets with dl cmpr. num packet= %0d", 5),UVM_NONE)
     `ifdef ENABLE_ETH_VIP
        fork
           send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 5);
           send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 5);
        join

        p_sequencer.env.wait_client_rx_frames_done(.exp_num(5),.timeout_time(100us));
        p_sequencer.env.wait_tx_frames_received(.exp_num(5),.timeout_time(100us));
    `endif
     #20us;
	
  endtask

endclass
