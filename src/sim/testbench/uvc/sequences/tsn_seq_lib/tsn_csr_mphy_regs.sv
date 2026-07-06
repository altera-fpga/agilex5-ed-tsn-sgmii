class tsn_csr_mphy_regs extends eth_base_sequence;

  `uvm_object_utils(tsn_csr_mphy_regs)

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
   uvm_reg_data_t  rd_data0, rd_data1;
   uvm_reg_data_t  wr_data, wr_data1;
   bit[31:0]       reg_base_addr;
   bit[31:0]       offset;
   bit[31:0]       exp_reg_ucsr[64];
   bit[15:0]       exp_reg_mphy[3][64], exp_reg_mphy[3][64], exp_reg_mphy[3][64];
   int             sel_ip, num_shift, idx;
   bit[31:0]       regaddr;
   bit[3:0]        byte_en;

      //1. User Space
      #400ns;
      //Read User CSR  registers: exp values
      `uvm_info(get_name(), "ST1 Reading User Csr registers", UVM_NONE)
      for(int k =0; k <64; k++) begin
	 reg_base_addr = 'h1002_0300;
	 offset = k;
         p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0);
	 exp_reg_ucsr[offset] = rd_data0;
	 `uvm_info(get_name(),$sformatf("ST1 Read User Csr: addr=0x%0h, rd_data0=0x%0h", offset, rd_data0),UVM_NONE)
	 `uvm_info(get_name(),$sformatf("ST1 exp_reg_ucsr[%0h]=0x%0h", offset, exp_reg_ucsr[offset]),UVM_NONE)
      end

      //Read MR-PHY registers: exp values
      `uvm_info(get_name(), "ST1 Reading expected MR-PHY registers", UVM_NONE)
      if(NUM_PHY == 1) begin
         for(int i =0; i <64; i++) begin
            reg_base_addr = 'h1002_0100;
            num_shift = 1;
            byte_en = 'hf; //TODO: is byte_en 'hC for MPHY regs?
            p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data0, num_shift);
	    if( (i%2) == 0 ) exp_reg_mphy[0][i] = rd_data0[15:0];
	    else   exp_reg_mphy[0][i] = rd_data0[31:16];

            `uvm_info(get_name(),$sformatf("ST1 Read Mphy reg: addr=0x%0h, rd_data0=0x%0h", i, rd_data0),UVM_NONE)
            `uvm_info(get_name(),$sformatf("ST1 exp_reg_mphy[0][%0h]=0x%0h", i, exp_reg_mphy[0][i]),UVM_NONE)
         end
      end
      else if(NUM_PHY == 3) begin
         for(int j =0; j <3; j++) begin
	    case(j)
               0 : reg_base_addr = 'h1002_0100; //MR-PHY0
               1 : reg_base_addr = 'h1002_0180; //MR-PHY1
               2 : reg_base_addr = 'h1002_0200; //MR-PHY2
            endcase

            for(int i =0; i <64; i++) begin
	       num_shift = 1;
               byte_en = 'hf; //TODO: is byte_en 'hC for MPHY regs?
               p_sequencer.env.reg_read_axi(i, reg_base_addr, rd_data0, num_shift);
	       if( (i%2) == 0 ) exp_reg_mphy[j][i] = rd_data0[15:0];
               else   exp_reg_mphy[j][i] = rd_data0[31:16];

	       `uvm_info(get_name(),$sformatf("ST1 Read Mphy reg: addr=0x%0h, rd_data0=0x%0h", i, rd_data0),UVM_NONE)
	       `uvm_info(get_name(),$sformatf("ST1 exp_reg_mphy[%0d][%0h]=0x%0h", j, i, exp_reg_mphy[j][i]),UVM_NONE)
            end
	 end
      end

      /* Note:
      //sel_ip = 0 : user csr regsiters
      //sel_ip = 1 : mphy0
      //sel_ip = 2 : mphy1
      //sel_ip = 3 : mphy2
      */

      for(int j =0; j <200; j++) begin
	 if(NUM_PHY == 1)  sel_ip = $urandom_range(1, 0);
	 if(NUM_PHY == 3)  sel_ip = $urandom_range(3, 0);
         regaddr  = $urandom_range(63,0);
      
         if(sel_ip == 0) begin //read User csr reg 
	    reg_base_addr = 'h1002_0300;
	    p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1);
	    `uvm_info(get_name(),$sformatf("ST1a Read User Csr: addr=0x%0h, rd_data1=0x%0h", regaddr, rd_data1),UVM_NONE)

	    if(rd_data1 !== exp_reg_ucsr[regaddr])
               `uvm_error(get_name(), $psprintf("User Space Mismatch:Addr=0x%0h,exp rd_data=0x%0h,act rd_data1=0x%0h", regaddr, exp_reg_ucsr[regaddr], rd_data1))
         end
	 else begin
	    case(sel_ip)
	       1 : begin
		     reg_base_addr = 'h1002_0100; //MR-PHY0
		     idx = 0;
		   end
	       2 : begin
		     reg_base_addr = 'h1002_0180; //MR-PHY1
		     idx = 1;
		   end
	       3 : begin
		     reg_base_addr = 'h1002_0200; //MR-PHY2
		     idx = 2;
		   end
	       default : begin
		     reg_base_addr = 'h1002_0100; //MR-PHY0
		     idx = 0;
		   end
	    endcase

	    num_shift = 1;
            byte_en   = 'hf; //TODO: is byte_en 'hC for MPHY regs?
            wr_data   = $urandom;

            //Check addr for scatch pad then write/read and update exp value
	    if(regaddr == 'h10) begin //scratch reg
	       p_sequencer.env.reg_write_axi(regaddr, reg_base_addr, wr_data, byte_en, num_shift);
	       exp_reg_mphy[idx][regaddr] = wr_data;
	       p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
               `uvm_info(get_name(),$sformatf("ST1b Read Mphy%0d: addr=0x%0h, rd_data1=0x%0h", idx, regaddr, rd_data1),UVM_NONE)
	       if( (regaddr%2) == 0 ) begin
                  if(rd_data1[15:0] !== exp_reg_mphy[idx][regaddr])
		     `uvm_error(get_name(), $psprintf("Mphy%0d Mismatch:Addr=0x%0h,exp rd_data=0x%0h,act rd_data1=0x%0h", idx, regaddr, exp_reg_mphy[idx][regaddr], rd_data1[15:0]))
	       end
	       else begin
	          if(rd_data1[31:16] !== exp_reg_mphy[idx][regaddr])
                     `uvm_error(get_name(), $psprintf("Mphy%0d Mismatch:Addr=0x%0h,exp rd_data=0x%0h,act rd_data1=0x%0h", idx, regaddr, exp_reg_mphy[idx][regaddr], rd_data1[31:16]))
	       end
            end
	    else begin
	       p_sequencer.env.reg_read_axi(regaddr, reg_base_addr, rd_data1, num_shift);
	       `uvm_info(get_name(),$sformatf("ST1a Read Mphy%0d: addr=0x%0h, rd_data1=0x%0h", idx, regaddr, rd_data1),UVM_NONE)

               if( (regaddr%2) == 0 ) begin
                  if(rd_data1[15:0] !== exp_reg_mphy[idx][regaddr])
	             if( (regaddr == 'h1c) ||  (regaddr == 'h1d) ||  (regaddr == 'h1e) || (regaddr == 'h1f) )
			`uvm_info(get_name(),$sformatf("ST1 soft PCS latency Mphy%0d: addr=0x%0h, rd_data1=0x%0h", idx, regaddr, rd_data1),UVM_NONE)
                     else   `uvm_error(get_name(), $psprintf("Mphy%0d Mismatch:Addr=0x%0h,exp rd_data=0x%0h,act rd_data1=0x%0h", idx, regaddr, exp_reg_mphy[idx][regaddr], rd_data1[15:0]))
               end
               else begin
                  if(rd_data1[31:16] !== exp_reg_mphy[idx][regaddr])
		     if( (regaddr == 'h1c) ||  (regaddr == 'h1d) ||  (regaddr == 'h1e) || (regaddr == 'h1f) )
                        `uvm_info(get_name(),$sformatf("ST1 soft PCS latency Mphy%0d: addr=0x%0h, rd_data1=0x%0h", idx, regaddr, rd_data1),UVM_NONE)
                     else `uvm_error(get_name(), $psprintf("Mphy%0d Mismatch:Addr=0x%0h,exp rd_data=0x%0h,act rd_data1=0x%0h", idx, regaddr, exp_reg_mphy[idx][regaddr], rd_data1[31:16]))
               end
            end
         end
      end //for

  endtask

endclass
