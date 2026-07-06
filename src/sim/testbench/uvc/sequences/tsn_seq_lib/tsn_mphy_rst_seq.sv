class tsn_mphy_rst_seq extends eth_base_sequence;

  `uvm_object_utils(tsn_mphy_rst_seq)

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
    //muralasx: Newly added 
    if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=5;
    end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new


  //---------------------------------------
  //virtual task body();
  //---------------------------------------
  virtual task body();
     uvm_reg_data_t  rd_data0, rd_data1;
     uvm_reg_data_t  wr_data, wr_data1;
     bit[31:0]       reg_base_addr;
     bit[31:0]       offset;
     bit[3:0]        byte_en;
     int 	     count, num_shift;
     int 	     reset_cfg;
     bit[15:0]       t_rdata1;
	
     reset_cfg = $urandom_range(0,4);
     case(reset_cfg) 
 	1: wr_data = 'h2; // 010 //rx,-,overall reset
	2: wr_data = 'h4; // 100 //-,tx,overall reset
	3: wr_data = 'h6; // 110 //-,-,overall reset
	4: wr_data = 'h1; // 001 //rx,tx,- reset
	default: wr_data = 'h0; //000 //rx,tx,overall reset
     endcase

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

      saddr_en=$urandom_range(0,1);
      saddr_en = 1;
     `uvm_info("tsn_mphy_rst_seq", "csr read write before frames\n",UVM_LOW);
     `uvm_info(get_name(),$sformatf("Saddr_en value is %0d",saddr_en),UVM_NONE);
   
     //3. Send frames before midsim reset
	`uvm_info("tsn_mphy_rst_seq", "frames without midsim reset\n",UVM_LOW);
    `ifdef ENABLE_ETH_VIP
       fork
          send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 2);  
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 2);  
       join
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(2),.timeout_time(100us));
       p_sequencer.env.wait_tx_frames_received(.exp_num(2),.timeout_time(100us));
    `else
       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 2);  
    `endif

     #40us;
  
      //3. write to user csr to reset mphy
      offset = 1;
      wr_data = 'h6;//need to change to random
      `uvm_info("tsn_mphy_rst_seq", "write to csr to reset and read to check\n",UVM_LOW);
      `uvm_info("tsn_mphy_rst_seq", $psprintf("Reset config (rx,tx,overall reset): %h", wr_data[2:0]),UVM_LOW);
       p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
		
      //4. Read user csr reset status and wait until out of reset
      p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
      `uvm_info(get_name(),$sformatf("Read Reset Cntl reg after midsim reset rd_data1-0x%0h", rd_data1),UVM_NONE);
                
      count = 0 ;       
      while (rd_data1[2:0] !== 'b111) begin
	 #400ns;
 	 p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
	 count++;
         if (count > 10) break;
      end

      if (rd_data1[2:0] !== 'b111)
         `uvm_error(get_name(), $psprintf("User Space Reset status unchanged:Addr=0x%0h, exp wr[2:0]=0x%0h, act rd[2:0]=0x%0h", offset, wr_data[2:0], rd_data1[2:0]))

      //5. check ready status and wait until tx,rx ready and pll locked
      `uvm_info("tsn_mphy_rst_seq", "read csr to check ready\n",UVM_LOW);
      offset = 0;
      p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0);
      count = 0 ;       
      while (rd_data0[2:0] !== 'b111) begin
	 #400ns;
	 p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0);
	 count++;
	 if (count > 500) break;
      end
        
      if(rd_data0[2:0] !== 'b111)
         `uvm_error(get_name(), $psprintf("User Space ready Status unchanged:Addr=0x%0h,read data=%0h", offset*4, rd_data0[2:0]))

       //6. read mphy reg 0xb and write 0 to enable transfer
       `uvm_info("tsn_mphy_rst_seq", "Mphy reg read default post midsim reset", UVM_NONE)   
	reg_base_addr = 'h1002_0100;
        offset = 'hb; 
	num_shift = 1;
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
	t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
	`uvm_info(get_name(), $psprintf("Mphy reg read:Addr=0x%h, act t_rdata1=0x%h", offset, t_rdata1), UVM_NONE)
	wr_data='h0;
        byte_en= (offset%2 == 0)? 'h3 : 'hc;
	p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data, byte_en, num_shift);
	#200ns;

	//read 'hb Mphy0 reg
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
        t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        `uvm_info(get_name(), $psprintf("Mphy reg read:Addr=0x%h, act t_rdata1=0x%h", offset, t_rdata1), UVM_NONE)
        if(t_rdata1[0] !== 0)		
	  `uvm_error(get_name(), $psprintf("Mphy0:Addr=0x%0h,exp tx_disable=0, act tx_dis=%0h", offset, t_rdata1[0]))

          //read 'h15 Mphy0 reg
	offset = 'h15;
	num_shift = 1;
        p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1, num_shift);
        t_rdata1 = (offset%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        `uvm_info(get_name(), $psprintf("Mphy reg read:Addr=0x%h, act t_rdata1=0x%h", offset, t_rdata1), UVM_NONE)
        if(t_rdata1[0] !== 0)
          `uvm_error(get_name(), $psprintf("Mphy0:Addr=0x%0h,exp tx_disable=0, act tx_dis=%0h", offset, t_rdata1[0]))

   	//7. send frames post midsim reset
	`uvm_info("tsn_mphy_rst_seq", "frames post midsim reset\n",UVM_LOW);
	`ifdef ENABLE_ETH_VIP
        fork
           send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 3);  
           send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 3);  
	join     // join
        p_sequencer.env.wait_client_rx_frames_done(.exp_num(3),.timeout_time(100us));
        p_sequencer.env.wait_tx_frames_received(.exp_num(3),.timeout_time(100us));
        `else
           send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
        `endif

	#200ns;
  endtask

endclass
