class tsn_ucsr_mphy_cov_regs extends eth_base_sequence;

  `uvm_object_utils(tsn_ucsr_mphy_cov_regs)

  bit [47:0]      src_address;
  rand bit        saddr_en;
  

  `ifdef ETH_MULTI_PORT
  //constraint saddr_range { saddr_en dist {0 := 1,1:= 1};}
  `else
  constraint saddr_range { saddr_en dist {0 := 1,1:= 1};}
  `endif

  uvm_reg_data_t read_data;
 
  //--------------------------------------
  //function new
  //--------------------------------------
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif

    if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=10;
    end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)

  endfunction:new

  //---------------------------------------
  // virtual task body()
  //--------------------------------------
  virtual task body();

      #400ns;
      `uvm_info(get_name(),$sformatf("Read out-of-bound MR-PHY and User CSR registers for coverage %0d", 1),UVM_NONE)
      mphy_regs(0);
	  mphy_regs(1);
      mphy_regs(2);
      user_csr_regs();
	  mdio();
	  i2c();

  endtask

  //-----------------------------------------------
  //task mphy_regs(int mphy);
  //----------------------------------------------
  task mphy_regs(int mphy);
   uvm_reg_data_t  rd_data0, rd_data1;
   uvm_reg_data_t  wr_data, wr_data1;
   bit[31:0]    reg_base_addr;
   bit[3:0]     byte_en;
   int          num_shift;
   bit[15:0]    t_rdata0, t_rdata1;
   int          num_regs;

     `uvm_info(get_name(),$sformatf("ST1 Read Mphy[%0d] registers ", mphy),UVM_NONE)
      case(mphy)
	  0 : begin
	        reg_base_addr ='h1002_0140;
	        num_regs = 32;
	      end
	  1 : begin
			if(NUM_PHY == 1) begin
	        reg_base_addr ='h1002_0180;
		num_regs = 64;
			end
			else begin
	        reg_base_addr ='h1002_01c0;
		num_regs = 32;
	      end
		end
	  2 : begin
			if(NUM_PHY == 1) begin
		reg_base_addr = 'h1002_0200;
		num_regs = 64;
              end
			else begin 
		reg_base_addr = 'h1002_0240;
		num_regs = 32;
			end
		  end
      endcase

      for(int i =0; i < num_regs; i++) begin
	 num_shift = 1;
	 wr_data = $urandom;
         byte_en = (i%2 == 0)? 'h3 : 'hc;
         p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
         p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data0, num_shift);
	 t_rdata0 = (i%2 == 0)? rd_data0[15:0] : rd_data0[31:16];
	 `uvm_info(get_name(),$sformatf("ST1 Read Mphy[%0d] reg: addr=0x%0h, t_rdata0=0x%0h", mphy, i, t_rdata0),UVM_NONE)

	 //Check write/read out of bound regs returned 0
	 if(t_rdata0 !== 0)
            `uvm_error(get_name(), $psprintf("MRPHY_%0d OUt-of-bound Mismatch: offset=%d, Addr=0x%0h, expected rdata0=0, rdata0=0x%0h", mphy, i, reg_base_addr+(i*2), t_rdata0))

      end 
  endtask

  task user_csr_regs();
   uvm_reg_data_t  rd_data0;
   uvm_reg_data_t  wr_data;
   bit[31:0]       reg_base_addr;
   bit[31:0]       offset;
   int 			num_regs;

      //1. User csr
      #100ns;
      `uvm_info(get_name(), "ST1 Reading User CSR out of bound regs", UVM_NONE)
         reg_base_addr = 'h1002_0280;
		 num_regs = 32;
      for(int k =0; k <num_regs; k++) begin
         wr_data = $urandom;
	 p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
         p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0);
         if(rd_data0 !== 0)
            `uvm_error(get_name(), $psprintf("User Space out-of-bound regs Mismatch: offset=%d, Addr=0x%0h, expected rdata0=0, rdata0=0x%0h", offset, reg_base_addr+(offset*4), rd_data0))
      end
	  
         reg_base_addr = 'h1002_0380;
		 num_regs = 32 ;
      for(int k =0; k <num_regs; k++) begin
         wr_data = $urandom;
	 p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
         p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0);
         if(rd_data0 !== 0)
            `uvm_error(get_name(), $psprintf("User Space out-of-bound regs Mismatch: offset=%d, Addr=0x%0h, expected rdata0=0, rdata0=0x%0h", offset, reg_base_addr+(offset*4), rd_data0))
      end


  endtask

  task mdio();
   uvm_reg_data_t  rd_data0, rd_data1;
   uvm_reg_data_t  wr_data, wr_data1;
   bit[31:0]    reg_base_addr;
   bit[3:0]     byte_en;
   int          num_shift;
   bit[15:0]    t_rdata0, t_rdata1;
   int          num_regs;

      //1. MDIO csr is not reserved space in concurrent mode
      #100ns;
     `uvm_info(get_name(),$sformatf("ST1 Read MDIO registers "),UVM_NONE)

	if(NUM_PHY == 1) begin
	    reg_base_addr ='h1002_0500;
		num_regs = 64;
			end
			else begin
	        reg_base_addr ='h1002_0500;
		num_regs = 0;
	      end


      for(int i =0; i < num_regs; i++) begin
	 num_shift = 1;
	 wr_data = $urandom;
         byte_en = (i%2 == 0)? 'h3 : 'hc;
         p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
         p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data0, num_shift);
	 t_rdata0 = (i%2 == 0)? rd_data0[15:0] : rd_data0[31:16];
	 `uvm_info(get_name(),$sformatf("ST1 Read MDIO reg: addr=0x%0h, t_rdata0=0x%0h", i, t_rdata0),UVM_NONE)

	 //Check write/read out of bound regs returned 0
	 if(t_rdata0 !== 0)
            `uvm_error(get_name(), $psprintf("MDIO OUt-of-bound Mismatch: offset=%d, Addr=0x%0h, expected rdata0=0, rdata0=0x%0h", i, reg_base_addr+(i*2), t_rdata0))

      end 
  endtask
  
  task i2c();
   uvm_reg_data_t  rd_data0, rd_data1;
   uvm_reg_data_t  wr_data, wr_data1;
   bit[31:0]    reg_base_addr;
   bit[3:0]     byte_en;
   int          num_shift;
   bit[15:0]    t_rdata0, t_rdata1;
   int          num_regs;

      //1. I2C csr is not reserved space in concurrent mode
      #100ns;
     `uvm_info(get_name(),$sformatf("ST1 Read I2C registers "),UVM_NONE)

	if(NUM_PHY == 1) begin
	    reg_base_addr ='h1002_0600;
		num_regs = 64;
			end
			else begin
	        reg_base_addr ='h1002_0600;  //
		num_regs = 0;
	      end


      for(int i =0; i < num_regs; i++) begin
	 num_shift = 1;
	 wr_data = $urandom;
         byte_en = (i%2 == 0)? 'h3 : 'hc;
         p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
         p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data0, num_shift);
	 t_rdata0 = (i%2 == 0)? rd_data0[15:0] : rd_data0[31:16];
	 `uvm_info(get_name(),$sformatf("ST1 Read I2C reg: addr=0x%0h, t_rdata0=0x%0h", i, t_rdata0),UVM_NONE)

	 //Check write/read out of bound regs returned 0
	 if(t_rdata0 !== 0)
            `uvm_error(get_name(), $psprintf("I2C OUt-of-bound Mismatch: offset=%d, Addr=0x%0h, expected rdata0=0, rdata0=0x%0h", i, reg_base_addr+(i*2), t_rdata0))

      end 
  endtask

endclass
