class tsn_midsim_rst_seq extends eth_base_sequence;

  `uvm_object_utils(tsn_midsim_rst_seq)

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
     bit[31:0]       reg_base_addr, regaddr;
     bit[31:0]       offset;
     int 	     num_shift, count;
     bit[3:0]        byte_en;
     bit 	     value;
     bit[15:0]       t_rdata;

        #400ns;
	//1. After power reset, read Scratch
        reg_base_addr = 'h1002_0100;
        regaddr = 'h10; //Scratch
        num_shift = 1;

	p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
	t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
	if(t_rdata[0] !== 0) `uvm_error(get_name(), $psprintf("ST3 Before reset: Mphy Scratch is not 0,Addr=0x%0h rd_data1=0x%h", regaddr, rd_data1))

	//2. Read and write Mphy0 scratch register
        `uvm_info("tsn_midsim_rst_seq", "ST3: Mphy scatch pad  write/read compare before midsim reset", UVM_NONE)   
	byte_en = (regaddr%2 == 0)? 'h3 : 'hc;
	wr_data   = $urandom;
	reg_base_addr = 'h1002_0100;
	regaddr = 'h10; //scratch reg
	num_shift = 1;

	p_sequencer.env.reg_write_axi(regaddr, reg_base_addr, wr_data, byte_en, num_shift);
	p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
	t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        if(t_rdata !== wr_data[15:0])
	   `uvm_error(get_name(), $psprintf("ST3 Mphy scratch pad Mismatch:Addr=0x%0h,exp rd_data=0x%h,act rd_data1=0x%h", regaddr, wr_data[15:0], t_rdata))
 
        //3. Read Rx and Tx ready, plllock, User CSR reg 0x0
	`uvm_info("tsn_midsim_rst_seq", "ST3 U-CSR status reg before midsim reset", UVM_NONE)
        reg_base_addr = 'h1002_0300;
        regaddr = 'h0; //Status
        num_shift = 2;
        p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
        `uvm_info(get_name(), $psprintf("ST3 U-CSR:Addr=0x%h, exp rd_data=7 act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)

        if(rd_data1[2:0] !== 7) begin
	   `uvm_error(get_name(), $psprintf("ST3 U-CSR status :Addr=0x%h, exp rd_data='b111,act rd_data1[2:0]=0x%h", regaddr, rd_data1[2:0]))
	end

	//4. Read User CSR reset control register and check for 'b111 in Mphy0
	`uvm_info("tsn_midsim_rst_seq", "ST3 U-CSR Reset Control reg before midsim reset", UVM_NONE)
        reg_base_addr = 'h1002_0300;
        regaddr = 'h1; //Reset Control
        num_shift = 2;
        p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
        `uvm_info(get_name(), $psprintf("ST3 U-CSR:Addr=0x%h, exp rd_data=7 act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)
        if(rd_data1[2:0] !== 3'b111)
           `uvm_error(get_name(), $psprintf("ST3 U-CSR Reset Cntl:Addr=0x%h, exp rd_data='b111,act rd_data1[2:0]=0x%h", regaddr, rd_data1[2:0]))

	//5. Read Mphy0 linkup status
	`uvm_info("tsn_midsim_rst_seq", "ST3 Mphy read linkup status before midsim reset", UVM_NONE)   
        reg_base_addr = 'h1002_0100;
        regaddr = 'h1; //status reg
        num_shift = 1;
        p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
        `uvm_info(get_name(), $psprintf("ST3 Mphy status reg read:Addr=0x%h,act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)
	t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
	if(t_rdata[2] !== 1)  
	   `uvm_error(get_name(), $psprintf("ST3 MPHY0 Status Linkup:Addr=0x%h, exp t_rdata[2]=1,act t_rdata[2]=0x%h", regaddr, t_rdata[2]))


	//6. Read Tx_disable, make sure bit[0]=0
	//Addr=0xb
	`uvm_info("tsn_midsim_rst_seq", "ST3 Mphy read Tx_disable before midsim reset addr=0xb", UVM_NONE)
        reg_base_addr = 'h1002_0100;
        regaddr = 'hb; //Tx_disable reg
        num_shift = 1;
        p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
        `uvm_info(get_name(), $psprintf("ST3 Mphy Tx_disable reg read:Addr=0x%h,act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)
        t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
	if(t_rdata[0] !== 0) begin
           `uvm_error(get_name(), $psprintf("ST3 MPHY0 Tx_disable:Addr=0x%h, exp t_rdata[0]=0,act t_rdata=0x%h", regaddr, t_rdata))
	   //write 0 to TYx_disable
	   byte_en = (regaddr%2 == 0)? 'h3 : 'hc;
	   wr_data = 0;
	   p_sequencer.env.reg_write_axi(regaddr, reg_base_addr, wr_data, byte_en, num_shift);
           p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
           t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
           if(t_rdata[0] !== 0)
           `uvm_error(get_name(), $psprintf("ST3 Mphy Tx_disable Mismatch:Addr=0x%0h,exp rd_data=0x%h,act rd_data1=0x%h", regaddr, wr_data[15:0], t_rdata))
	end

        //Addr=0x15
        `uvm_info("tsn_midsim_rst_seq", "ST3 Mphy read Tx_disable before midsim reset addr=0x15", UVM_NONE)
        reg_base_addr = 'h1002_0100;
        regaddr = 'h15; //Tx_disable reg
        num_shift = 1;
        p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
        `uvm_info(get_name(), $psprintf("ST3 Mphy Tx_disable reg read:Addr=0x%h,act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)
        t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
        if(t_rdata[0] !== 0)
           `uvm_error(get_name(), $psprintf("ST3 MPHY0 Tx_disable:Addr=0x%h, exp t_rdata[0]=0,act t_rdata=0x%h", regaddr, t_rdata))

   
       //7. Sending traffic before midsim reset
       `uvm_info("tsn_midsim_rst_seq", "ST3 frames before midsim reset\n",UVM_LOW);
       `ifdef ENABLE_ETH_VIP
          fork
             send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX, 2);  
             send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP, 3);  
	 join
            p_sequencer.env.wait_client_rx_frames_done(.exp_num(2),.timeout_time(100us));
            p_sequencer.env.wait_tx_frames_received(.exp_num(3),.timeout_time(100us));
       `else
            send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
       `endif
	#20us; //wait for all packet received at destination

	//8. =============Starting midsim reset ==============
        //
        `uvm_info("tsn_midsim_rst_seq", "ST4: ===== Starting midsim reset ======",UVM_LOW);
        uvm_hdl_force("top_tb.sys_rst", 0);             //system reset

	uvm_hdl_force("top_tb.dut.rst_ctrl_inst.emac_mac_rst_tx_n[0:0]", 0); //tx digital reset
        uvm_hdl_force("top_tb.dut.rst_ctrl_inst.emac_mac_rst_rx_n[0:0]", 0); //rx digital reset

        #40us;

        //9. Release midsim reset
        `uvm_info("tsn_midsim_rst_seq", "ST4: midsim reset removed\n",UVM_LOW);

        uvm_hdl_release("top_tb.dut.rst_ctrl_inst.emac_mac_rst_tx_n[0:0]");  //emac0_mac_rst_tx_n
        uvm_hdl_release("top_tb.dut.rst_ctrl_inst.emac_mac_rst_rx_n[0:0]");  //emac0_mac_rst_tx_n

        uvm_hdl_force("top_tb.dut.rst_ctrl_inst.emac_mac_rst_tx_n[0:0]", 1); //tx digital reset
        uvm_hdl_force("top_tb.dut.rst_ctrl_inst.emac_mac_rst_rx_n[0:0]", 1); //rx digital reset
	uvm_hdl_release("top_tb.dut.rst_ctrl_inst.emac_mac_rst_tx_n[0:0]");  //emac0_mac_rst_tx_n
        uvm_hdl_release("top_tb.dut.rst_ctrl_inst.emac_mac_rst_rx_n[0:0]");  //emac0_mac_rst_tx_n


        uvm_hdl_release("top_tb.sys_rst");             //system reset
        uvm_hdl_force("top_tb.sys_rst", 1);
        uvm_hdl_release("top_tb.sys_rst");

        #110us;
        //8b. =================== end ======================

	//9a. Read AVMM reset
	 uvm_hdl_read("top_tb.dut.avmm_rst",value);
	 count=0;
	 while (value !== 0) begin
 	    uvm_hdl_read("top_tb.dut.avmm_rst",value);
	    if (value == 0) begin
	       `uvm_info("tsn_midsim_rst_seq", "ST4: avmm_rst deasserted\n",UVM_LOW);
		break;
	    end
	    else begin
	       `uvm_info("tsn_midsim_rst_seq", "ST4: avmm_rst not deasserted\n",UVM_LOW);
		#25us;
	    end
	    count++;
	    if (count > 12) break;
	 end
	 
	if (value !== 0) 
	   `uvm_error(get_name(), $psprintf("ST4: failed to deassert avmm rst and can not read status reg"))
	else
	begin

           //10. Read and write Tx_disable to 0
           //Addr=0xb
           `uvm_info("tsn_midsim_rst_seq", "ST4 After Mphy read Tx_disable after midsim reset addr=0xb", UVM_NONE)
           reg_base_addr = 'h1002_0100;
           regaddr = 'hb; //Tx_disable reg
           num_shift = 1;
           p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
           `uvm_info(get_name(), $psprintf("ST4 After reset: Mphy Tx_disable reg read:Addr=0x%h,act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)

           byte_en = (regaddr%2 == 0)? 'h3 : 'hc;
           wr_data = 0;
           p_sequencer.env.reg_write_axi(regaddr, reg_base_addr, wr_data, byte_en, num_shift);
           p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
           t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
           if(t_rdata[0] !== 0)
              `uvm_error(get_name(), $psprintf("ST4 After reset: MPHY0 Tx_disable:Addr=0x%h, exp t_rdata[0]=0,act t_rdata=0x%h", regaddr, t_rdata))

           //Addr=0x15
           `uvm_info("tsn_midsim_rst_seq", "ST4 After reset: Mphy read Tx_disable after midsim reset addr=0x15", UVM_NONE)
           reg_base_addr = 'h1002_0100;
           regaddr = 'h15; //Tx_disable reg
           num_shift = 1;
           p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
           `uvm_info(get_name(), $psprintf("ST4 After reset: Mphy Tx_disable reg read:Addr=0x%h,act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)
           t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
           if(t_rdata[0] !== 0)
              `uvm_error(get_name(), $psprintf("ST4 After reset MPHY0 Tx_disable:Addr=0x%h, exp t_rdata[0]=0,act t_rdata=0x%h", regaddr, t_rdata))

           #40us; //delay

           //11a. Read User CSR reset control register 
           `uvm_info("tsn_midsim_rst_seq", "ST4 After reset: U-CSR Reset Control reg after midsim reset", UVM_NONE)
           reg_base_addr = 'h1002_0300;
           regaddr = 'h1; //Reset Control
           num_shift = 2;
           p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
           `uvm_info(get_name(), $psprintf("ST4 After reset:  U-CSR:Addr=0x%h, exp rd_data=7 act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)
           if(rd_data1[2:0] !== 3'b111)
              `uvm_error(get_name(), $psprintf("ST4 After reset U-CSR Reset Cntl:Addr=0x%h, exp rd_data='b111,act rd_data1[2:0]=0x%h", regaddr, rd_data1[2:0]))


       	   //11b. Read Rx Tx ready in User csr reg 0x0, and reset Control reg 0x1
           `uvm_info("tsn_midsim_rst_seq", "ST4 After reset: U-CSR status reg after midsim reset", UVM_NONE)
           reg_base_addr = 'h1002_0300;
           regaddr = 'h0; //Status
           num_shift = 2;
           p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
           `uvm_info(get_name(), $psprintf("ST4 After reset U-CSR:Addr=0x%h, exp rd_data=7 act rd_data1=0x%h", regaddr, rd_data1), UVM_NONE)
           if(rd_data1[2:0] !== 3'b111)
              `uvm_error(get_name(), $psprintf("ST4 After reset: U-CSR status :Addr=0x%h, exp rd_data='b111,act rd_data1[2:0]=0x%h", regaddr, rd_data1[2:0]))

	   //12. Read Mphy link status after reset
           `uvm_info("tsn_midsim_rst_seq", "ST4 After reset: Mphy read linkup status after midsim reset", UVM_NONE)
           reg_base_addr = 'h1002_0100;
           regaddr = 'h1; //status reg
           num_shift = 1;
           p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
           `uvm_info(get_name(), $psprintf("ST4 After reset: Mphy status reg read:Addr=0x%h,act rd_data1[31:16]=0x%h", regaddr, rd_data1[31:16]), UVM_NONE)
           t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
           if(t_rdata[2] !== 1)
              `uvm_error(get_name(), $psprintf("ST4 After reset MPHY0 Status:Addr=0x%h, exp t_rdata[2]=1,act t_rdata=0x%h", regaddr, t_rdata))


	   //13. Read Mphy0 scratch register to clear after reset
	   //    Then write with random number and read back to check
           `uvm_info("tsn_midsim_rst_seq", "ST4 After reset: Mphy scatch pad  check default after midsim reset", UVM_NONE)   
	   reg_base_addr = 'h1002_0100;
           regaddr = 'h10; //scratch reg
	   num_shift = 1;
	   p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
	   t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
           if(t_rdata !== 'h0) 
              `uvm_error(get_name(), $psprintf("ST4 After reset: Mphy scratch pad default Mismatch:Addr=0x%h, exp rd_data=0x0h, act rd_data1=0x%h", regaddr, rd_data1))
 	
           //13b. Read and write Mphy0 scratch register
           `uvm_info("tsn_midsim_rst_seq", "ST4 After reset: Mphy scatch pad  write/read compare after midsim reset", UVM_NONE)
           byte_en = (regaddr%2 == 0)? 'h3 : 'hc;
           wr_data   = $urandom;
           reg_base_addr = 'h1002_0100;
           regaddr = 'h10; //scratch reg
           num_shift = 1;

           p_sequencer.env.reg_write_axi(regaddr, reg_base_addr, wr_data, byte_en, num_shift);
           p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
           t_rdata = (regaddr%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
           if(t_rdata !== wr_data[15:0])
              `uvm_error(get_name(), $psprintf("ST4 After Reset Mphy scratch pad Mismatch:Addr=0x%0h,exp rd_data=0x%h,act rd_data1=0x%h", regaddr, wr_data[15:0], t_rdata))

	    //14. Send traffic again after midsim reset
	    `uvm_info("tsn_midsim_rst_seq", "ST4 After reset: Sending traffic again after midsim reset\n",UVM_LOW);
	    `ifdef ENABLE_ETH_VIP
	       fork
	          send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,4);  
	          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
	       join 
  	       p_sequencer.env.wait_client_rx_frames_done(.exp_num(4),.timeout_time(100us));
	       p_sequencer.env.wait_tx_frames_received(.exp_num(5),.timeout_time(100us));
	    `else
	       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
	    `endif
	
	    #10us;
         end

  endtask

endclass
