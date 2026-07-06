class tsn_mphy_regs extends eth_base_sequence;

  `uvm_object_utils(tsn_mphy_regs)

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

      concurrent_tx_dis();
      #400ns;
      if(NUM_PHY == 1) mphy_regs(0);
      if(NUM_PHY == 3) begin
	 mphy_regs(0);
	 mphy_regs(1);
	 mphy_regs(2);
      end

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

     `uvm_info(get_name(),$sformatf("ST1 Read Mphy[%0d] registers ", mphy),UVM_NONE)
      case(mphy)
	 0 : reg_base_addr    =    'h1002_0100;
	 1 : reg_base_addr    =    'h1002_0180;
	 2 : reg_base_addr    =    'h1002_0200;
	 default : reg_base_addr = 'h1002_0100;
      endcase

      for(int i =0; i <64; i++) begin
	 num_shift = 1;
	 //byte_en = 'hf; //TODO: is byte_en 'hC for MPHY regs?
	 wr_data = $urandom;
         p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data0, num_shift);
	 t_rdata0 = (i%2 == 0)? rd_data0[15:0] : rd_data0[31:16];
	 `uvm_info(get_name(),$sformatf("ST1 Read Mphy[%0d] reg: addr=0x%0h, t_rdata0=0x%0h", mphy, i, t_rdata0),UVM_NONE)

         //Check write vs. read data
	 case(i)
          'h0 : begin
                   //checking for reg default value				
		   if(t_rdata0[6] !== 1)
                   `uvm_error(get_name(), $psprintf("MRPHY_%0d Control def Mismatch:Addr=0x%0h, exp t_rdata0[6]=1,act t_rdata0[6]=%0h", mphy, i, t_rdata0[6]))

                   if(t_rdata0[8] !== 1)
                   `uvm_error(get_name(), $psprintf("MRPHY_%0d Control def Mismatch: Addr=0x%0h, exp t_rdata0[8]=1, act t_rdata0[8]=%0h", mphy, i, t_rdata0[8]))

		   //Check RW
		   wr_data1 = wr_data;
		   wr_data1[9] = 0; wr_data1[12] = 0; wr_data1[15] = 0;
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
		   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data1, byte_en, num_shift);
		   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];

		   if(t_rdata1[8:0] !== t_rdata0[8:0]) 
	              `uvm_error(get_name(), $psprintf("MRPHY_%0d Control Mismatch: Addr=0x%0h, t_rdata0[8:0]=0x%0h, t_rdata1[8:0]=0x%0h", mphy, i, t_rdata0[8:0], t_rdata1[8:0]))
		end
	  'h1 : begin
                   //checking for reg default value				 
  		   if(t_rdata0[0] !== 1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Stat def Mismatch:Addr=0x%0h, exp t_rdata0[0]=1, act t_rdata0[0]=%0h", mphy,i, t_rdata0[0]))
                   if(t_rdata0[3] !== 1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Stat def Mismatch: Addr=0x%0h, exp t_rdata0[3]=1, act t_rdata0[3]=%0d", mphy, i,t_rdata0[3]))
	           if(t_rdata0[15:4] !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Stat def Mismatch: Addr=0x%0h, exp t_rdata0[15:4]=0, act t_rdata0[15:4]=%0d", mphy, i,t_rdata0[15:4]))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
		   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Stat Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
		end
	  'h2 : begin
                   //checking for reg default value			
	   	   if(t_rdata0 !== mphy)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d PhyID Mismatch:Addr=0x%0h, exp t_rdata0=%0h, act t_rdata0=%0h", mphy, i, mphy, t_rdata0 )) //TODO

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Phy-Id Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
	  'h3 : begin
                   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d PhyID Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy,i, t_rdata0))

                   //Check R0
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Phy-Id Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end

	  'h4 : begin
		   //checking for reg default value          
		   if(t_rdata0[5] !== 1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d dev_ability Mismatch:Addr=0x%0h, exp t_rdata0[5]=1, act t_rdata0[5]=%0d", mphy, i, t_rdata0[5]))
                   if(t_rdata0[7] !== 1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d dev_ability Mismatch:Addr=0x%0h, exp t_rdata0[7]=1, act t_rdata0[7]=%0d", mphy, i, t_rdata0[7]))
		   if(t_rdata0[8] !== 1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d dev_ability Mismatch:Addr=0x%0h, exp t_rdata0[8]=1, act t_rdata0[8]=%0d", mphy, i, t_rdata0[8]))
			
                   //Check RW
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   wr_data1 = wr_data;
		   wr_data1[15:14] = t_rdata0[15:14];
		   wr_data1[11:9]  = t_rdata0[11:9];
		   wr_data1[4:0] = t_rdata0[4:0];
                   if(t_rdata1 !== wr_data1[15:0])
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Dev-Ability Mismatch:Addr=0x%0h, exp wr_data1=0x%0h, act t_rdata1=0x%0h", mphy, i, wr_data1[15:0], t_rdata1))
                end

          'h5 : begin
		   //checking for reg default value
		   `uvm_info(get_name(),$sformatf("ST1 Read Mphy[%0d] reg: addr=0x%0h, t_rdata0=0x%0h", mphy, i, t_rdata0),UVM_NONE)

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Partner-Ability Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'h6 : begin
   	   	   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Expansion Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'h7 : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Dev-NP Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'h8 : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Partner-NP Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'h9 : begin
	  	   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'hA : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i,t_rdata0))

                   //Check RO
		    byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end


          'hB : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   t_rdata0[0] = (i%2 == 0)? wr_data[0] : wr_data[16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'hC : begin
		   //checking for reg default value

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'hD : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'hE : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
          'hF : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))
                  
                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
         'h10 : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RW
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(wr_data[15:0] !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Scatch Mismatch: Addr=0x%0h, exp wr_data=0x%0h, act rd_data1=0x%0h", mphy, i, wr_data[15:0], t_rdata1))
                end
         'h11 : begin
                   //Check default reg value
		   if(t_rdata0 == 0)
		      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Version Mismatch:Addr=0x%0h, exp t_rdata0 != 0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rev Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
         'h12 : begin
		   //checking for reg default value
		   if(t_rdata0[8:0] !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0[8:0]=0, act t_rdata0[8:0]=%0h", mphy, i, t_rdata0))
	   
                   //Check RW
		   //Confirm if the write is legal
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   wr_data1[15:0] = wr_data[15:0];
		   wr_data1[8:0] = 0;
                   if(wr_data1[15:0] !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Link-Timer Low Mismatch: Addr=0x%0h, exp wr_data1=0x%0h, act t_rdata1=0x%0h", mphy, i, wr_data1[15:0], t_rdata1))
                end
         'h13 : begin
		   //checking for reg default value
		   if(rd_data0[8:0] !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0[8:0]=0, act t_rdata0[8:0]=%0h", mphy, i, t_rdata0))

                   //Check RW
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   wr_data1[31:16] = wr_data[31:16];
		   wr_data1[31:21] = 0;

                   if(wr_data1[31:16] !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d LinkTimer Mismatch: Addr=0x%0h, exp wr_data1=0x%0h, act t_rdata1=0x%0h", mphy, i, wr_data1[31:16], t_rdata1))
                end
         'h14 : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))
                   
                   //Check RW
		   //confirm if writing to this register is legal
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   wr_data1 = rd_data0;
		   wr_data1[3:0] = wr_data[3:0];
                   if(wr_data1[15:0] !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d If_mode Mismatch: Addr=0x%0h, exp wr_data=0x%0h, act t_rdata1=0x%0h", mphy, i, wr_data[15:0], t_rdata1))
                end
         'h15 : begin
		   //checking for reg default value
		   if(t_rdata0[15:1] !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RW
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   wr_data = rd_data0;
		   wr_data1[0] = wr_data[0];
                   if(wr_data1[31:16] !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Gmii_adapt Mismatch: Addr=0x%0h, exp wr_data=0x%0h, act rd_data1=0x%0h", mphy, i, wr_data1[31:16], t_rdata1))
                end
         'h16 : begin
		   //checking for reg default value
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0=0, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
         'h17 : begin
		   //checking for reg default value
		   if( (t_rdata0[0] !== 0) && (t_rdata0[0] !== 1) )
		      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0[0]=0/1, act t_rdata0[0]=%0h", mphy, i, t_rdata0[0]))
		   if(t_rdata0[3:1] !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0[3:1]=0, act t_rdata0[3:1]=%0h", mphy, i, t_rdata0[3:1]))
	           if(t_rdata0[15:4] !== 0)
		      `uvm_error(get_name(), $psprintf("MRPHY_%0d Default Value Mismatch:Addr=0x%0h, exp t_rdata0[15:4]=0, act t_rdata0[15:4]=%0h", mphy, i, t_rdata0[15:4]))

                   //Check RW
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
		   `uvm_info(get_name(),$sformatf("ST1c Read Mphy[%0d] reg: addr=0x%0h, wr_data=0x%0h", mphy, i, wr_data),UVM_NONE)
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   if(wr_data[19:18] !== t_rdata1[3:2])
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d DL_cntl Mismatch: Addr=0x%0h, exp wr_data[19:18]=0x%0h, act t_rdata1[3:2]=0x%0h", mphy, i, wr_data[19:18], t_rdata1[3:2]))

	           //clear soft reset
	           #100ns;
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
		   wr_data = rd_data0;
		   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
		   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   `uvm_info(get_name(),$sformatf("ST1c Read Mphy[%0d] reg: addr=0x%0h, wr_data=0x%0h", mphy, i, wr_data),UVM_NONE)
		   `uvm_info(get_name(),$sformatf("ST1c Read Mphy[%0d] reg: addr=0x%0h, t_rdata1=0x%0h", mphy, i, t_rdata1),UVM_NONE)

		   if(t_rdata1[3:2] !== 0)
	              `uvm_error(get_name(), $psprintf("MRPHY_%0d after clear soft-rst: Addr=0x%0h, exp t_rdata1[3:2]=0, act t_rdata1[3:2]=0x%0h", mphy, i, t_rdata1[3:2]))
		   #400ns;
                end
         'h18 : begin
		   //checking for reg default value
		   if( (^t_rdata0 === 1'bx) || (^t_rdata0 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata0=%0h", mphy, i,  t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Tx-delay Low Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
         'h19 : begin
		   //checking for reg default value
		   if( (^t_rdata0 === 1'bx) || (^t_rdata0 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata0=%0h", mphy, i,  t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Tx-delay Hi Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
         'h1A : begin
		   //checking for reg default value
		   if( (^t_rdata0 === 1'bx) || (^t_rdata0 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata0=%0h", mphy, i,  t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rx-delay Low Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
         'h1B : begin
		   //checking for reg default value
		   if( (^t_rdata0 === 1'bx) || (^t_rdata0 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata0=%0h", mphy, i,  t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata0 !== t_rdata1)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rx-delay Hi Mismatch: Addr=0x%0h, exp t_rdata0=0x%0h, act t_rdata1=0x%0h", mphy, i, t_rdata0, t_rdata1))
                end
         'h1C : begin
		   //checking for reg default value
		   if( (^t_rdata0 === 1'bx) || (^t_rdata0 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata0=%0h", mphy, i, t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   if( (^t_rdata1 === 1'bx) || (^t_rdata1 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata1=%0h", mphy, i, t_rdata1))
	        end
         'h1D : begin
		   //checking for reg default value
		   if( (^t_rdata0 === 1'bx) || (^t_rdata0 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata0=%0h", mphy, i,  t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   if( (^t_rdata1 === 1'bx) || (^t_rdata1 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata1=%0h", mphy, i, t_rdata1))
                end
         'h1E : begin
		   //checking for reg default value
		    if( (^t_rdata0 === 1'bx) || (^t_rdata0 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata0=%0h", mphy, i,  t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   if( (^t_rdata1 === 1'bx) || (^t_rdata1 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata1=%0h", mphy, i, t_rdata1))
                end
         'h1F : begin
		   //checking for reg default value
		    if( (^t_rdata0 === 1'bx) || (^t_rdata0 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata0=%0h", mphy, i,  t_rdata0))

                   //Check RO
		   byte_en = (i%2 == 0)? 'h3 : 'hc;
                   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
		   if( (^t_rdata1 === 1'bx) || (^t_rdata1 === 1'bz) )
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d read out x/z Mismatch:Addr=0x%0h, act t_rdata1=%0h", mphy, i, t_rdata1))
                end
          default : begin
		   //Check writew/read invlid regs returned 0
		   if(t_rdata0 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d OUt-of-bound Mismatch: Addr=0x%0h, exp t_rdata0=0, act t_rdata0=0x%0h", mphy, i, t_rdata0))

	           byte_en = 'hf;
		   p_sequencer.env.reg_write_axi(i, reg_base_addr, wr_data, byte_en, num_shift);
                   p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data1, num_shift);
		   t_rdata1 = (i%2 == 0)? rd_data1[15:0] : rd_data1[31:16];
                   if(t_rdata1 !== 0)
                      `uvm_error(get_name(), $psprintf("MRPHY_%0d Rsvd Mismatch: Addr=0x%0h, exp rd_data=0, act rd_data1=0x%0h", mphy, i, t_rdata1))
		end
         endcase
      end //for
  endtask

endclass
