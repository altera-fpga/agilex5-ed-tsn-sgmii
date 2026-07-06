class tsn_mphy_dl_regs extends eth_base_sequence;

  `uvm_object_utils(tsn_mphy_dl_regs)

  //--------------------------------------
  //function new
  //--------------------------------------
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif

  endfunction:new

  //---------------------------------------
  // virtual task body()
  //--------------------------------------
  virtual task body();

     #400ns;
     fork
	read_dl_regs();
        send_mphy_tx_rx_traffic();
     join

  endtask


  //--------------------------------------
  //task read_dl_regs();
  //--------------------------------------
  task read_dl_regs();

      if(NUM_PHY == 1)  begin
         mphy_dl_reg(0);
      end
      else if(NUM_PHY == 3)  begin
         mphy_dl_reg(0);
	 mphy_dl_reg(1);
	 mphy_dl_reg(2);
      end

  endtask
      

  //--------------------------------------
  //task mphy_dl_reg(int num_phy);
  //--------------------------------------
  task mphy_dl_reg(int num_phy);
   uvm_reg_data_t  rd_data1;
   bit[31:0]       reg_base_addr;
   int             num_shift;
   bit[3:0]        byte_en;

     case(num_phy)
        0 : reg_base_addr = 'h1002_0100; //MR-PHY0
        1 : reg_base_addr = 'h1002_0180; //MR-PHY1
        2 : reg_base_addr = 'h1002_0200; //MR-PHY2
     endcase

     num_shift = 1;

     //'h18
     p_sequencer.env.reg_read_axi('h18, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1 Read Mphy%0d: addr='h18, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)
     if( (^rd_data1[15:0] === 1'bx) || (^rd_data1[15:0] === 1'bz) )
        `uvm_error(get_name(), $psprintf("Mphy%0d Reg=0'h18, read data has X/Z rd_data1=0x%0h", num_phy, rd_data1[15:0]))	

     //'h19
     p_sequencer.env.reg_read_axi('h19, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1 Read Mphy%0d: addr='h19, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)
     if( (^rd_data1[31:16] === 1'bx) || (^rd_data1[31:16] === 1'bz) )
        `uvm_error(get_name(), $psprintf("Mphy%0d Reg=0'h18, read data has X/Z rd_data1=0x%0h", num_phy, rd_data1[31:16]))

     //'h1a
     p_sequencer.env.reg_read_axi('h1a, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1 Read Mphy%0d: addr='h1a, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)
     if( (^rd_data1[15:0] === 1'bx) || (^rd_data1[15:0] === 1'bz) )
        `uvm_error(get_name(), $psprintf("Mphy%0d Reg=0'h18, read data has X/Z rd_data1=0x%0h", num_phy, rd_data1[15:0]))

     //'h1b
     p_sequencer.env.reg_read_axi('h1b, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1 Read Mphy%0d: addr='h1b, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)
     if( (^rd_data1[31:16] === 1'bx) || (^rd_data1[31:16] === 1'bz) )
        `uvm_error(get_name(), $psprintf("Mphy%0d Reg=0'h18, read data has X/Z rd_data1=0x%0h", num_phy, rd_data1[31:16]))

     //'h1c
     p_sequencer.env.reg_read_axi('h1c, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1 Read Mphy%0d: addr='h1c, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)
     if( (^rd_data1[15:0] === 1'bx) || (^rd_data1[15:0] === 1'bz) )
        `uvm_error(get_name(), $psprintf("Mphy%0d Reg=0'h18, read data has X/Z rd_data1=0x%0h", num_phy, rd_data1[15:0]))

     //'h1d
     p_sequencer.env.reg_read_axi('h1d, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1a Read Mphy%0d: addr='h1d, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)
     if( (^rd_data1[31:16] === 1'bx) || (^rd_data1[31:16] === 1'bz) )
        `uvm_error(get_name(), $psprintf("Mphy%0d Reg=0'h18, read data has X/Z rd_data1=0x%0h", num_phy, rd_data1[31:16]))

     //'h1e
     p_sequencer.env.reg_read_axi('h1e, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1 Read Mphy%0d: addr='h1e, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)
     if( (^rd_data1[15:0] === 1'bx) || (^rd_data1[15:0] === 1'bz) )
        `uvm_error(get_name(), $psprintf("Mphy%0d Reg=0'h18, read data has X/Z rd_data1=0x%0h", num_phy, rd_data1[15:0]))

     //'h1f
     p_sequencer.env.reg_read_axi('h1f, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1 Read Mphy%0d: addr='h1f, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)
     if( (^rd_data1[31:16] === 1'bx) || (^rd_data1[31:16] === 1'bz) )
        `uvm_error(get_name(), $psprintf("Mphy%0d Reg=0'h18, read data has X/Z rd_data1=0x%0h", num_phy, rd_data1[31:16]))

    //'h17
     p_sequencer.env.reg_read_axi('h17, reg_base_addr, rd_data1, num_shift);
     `uvm_info(get_name(),$sformatf("ST1 Read Mphy%0d: addr='h17, rd_data1=0x%0h", num_phy, rd_data1),UVM_NONE)

  endtask

  //--------------------------------------
  //task send_mphy_tx_rx_traffic();
  //--------------------------------------
  task send_mphy_tx_rx_traffic();
    int num_of_frames = 10;

    `ifdef ENABLE_ETH_VIP
        `uvm_info(get_name(),$sformatf("ST1: num_of_frames=%0d", num_of_frames),UVM_NONE);
        fork
           send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);
           send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);
        join

        p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(200us));
        p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(200us));
    `else
        `uvm_info(get_name(),$sformatf("ST1a: num_of_frames=%0d", num_of_frames),UVM_NONE);
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);
    `endif

  endtask


endclass
