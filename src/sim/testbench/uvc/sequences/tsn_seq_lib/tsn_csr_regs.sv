class tsn_csr_regs extends eth_base_sequence;

  `uvm_object_utils(tsn_csr_regs)

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
    //muralasx: Newly added 
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
   bit             l_read_done;
   bit[8:0]        l_err, m_err, val;


	      `uvm_info(get_name(), "PJ:1: seq start tsn_csr_regs", UVM_NONE)
      //1. User Space
      #400ns;
      `uvm_info(get_name(), "ST1 Reading user csr User Space", UVM_NONE)
      for(int k =0; k <64; k++) begin
	 reg_base_addr = 'h1002_0300;
	 offset = k;
         wr_data = $urandom;
         p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data0);
		 `uvm_info(get_name(), $psprintf("PJ:2: reading reg offset =%h",k*4), UVM_NONE)

         case(offset)
            'h0 : begin
		    //Check default reg value
		    //`uvm_info(get_name(), "ST1 Reading User Space 'h0", UVM_NONE)
		    if( (NUM_PHY == 1) && (rd_data0[31:7] !== 0) )
                       `uvm_error(get_name(), $psprintf("User Space Status Mismatch:Addr=0x%0h,exp rd[31:7]=0,act rd_data0[31:7]=%0h", offset*4, rd_data0[31:7]))

                    if( (NUM_PHY == 3) && (rd_data0[20:18] !== 'b100)  ) // default bits 0 0000 0000 0010 0000 0100 0000 //100 //0000
                       `uvm_error(get_name(), $psprintf("User Space Status Mismatch: Addr=0x%0h,exp rd_data0[20:18]='b100,act rd_data0[20:18]=%0b", offset*4, rd_data0[20:18]))
                    if( (NUM_PHY == 3) && (rd_data0[13:11] !== 'b100) ) // default bits 0 0000 0000 0010 0000 0100 0000 //100 //0000
                       `uvm_error(get_name(), $psprintf("User Space Status Mismatch: Addr=0x%0h,exp rd_data0[13:11]='b100,act rd_data0[13:11]=%0b", offset*4, rd_data0[13:11]))

                    if(rd_data0[6:4] !== 'b100)
                       `uvm_error(get_name(), $psprintf("User Space Status Mismatch: Addr=0x%0h,exp rd_data0[6:4]='b100,act rd_data0[6:4]=%0b", offset*4, rd_data0[6:4]))

	            ////Check RO
                    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
                    p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
                    if(rd_data0 !== rd_data1)
                       `uvm_error(get_name(), $psprintf("User Space Status Mismatch: Addr=0x%0h,exp rd_data0=0x%0h, rd_data1=0x%0h", offset*4, rd_data0, rd_data1))
                  end
            'h1 : begin
		    //Check default reg value
		    `uvm_info(get_name(), "ST1 Reading User Space 'h4", UVM_NONE)
		    if((NUM_PHY == 1) && (rd_data0 !== 'h7)) 
                       `uvm_error(get_name(), $psprintf("User Space Reset Cntl Mismatch: Addr=0x%0h, exp rd_data0=0x7,act rd_data0=0x%0h", offset*4, rd_data0))

		    if((NUM_PHY == 3) && (rd_data0 !== 'h1ff)) 
                       `uvm_error(get_name(), $psprintf("User Space Reset Cntl Mismatch: Addr=0x%0h, exp rd_data0='h1ff,act rd_data0=0x%0h", offset*4, rd_data0))

	            //Check RW
                    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
					`uvm_info(get_name(), $psprintf("PJ:2: writing reg offset =%h",k*4), UVM_NONE)
		    l_read_done = 0;
		    m_err[8:0] = 0;
		    l_err[8:0] = 0;

		 if(NUM_PHY == 1) begin
		    fork
		       begin
                          p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
			  if(wr_data[2:0] !== rd_data1[2:0]) begin
			     l_err[0] = (wr_data[0] == rd_data1[0])? 0 : 1;
			     l_err[1] = (wr_data[1] == rd_data1[1])? 0 : 1;
			     l_err[2] = (wr_data[2] == rd_data1[2])? 0 : 1;
			     l_read_done = 1;
			  end
			  else l_read_done = 1;
		       end
	               begin
			  if(wr_data[0] == 0) begin
			     uvm_hdl_read("top_tbdut.soc_inst.subsys_tsn.intel_mge_phy_0.i_rst_n",val[0]);
			     while(!l_read_done && (val[0] !== wr_data[0])) begin
				#2ns;
                                uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_rst_n",val[0]);
			     end
			     m_err[0] = (val[0] == wr_data[0])? 0 : 1;
			  end
                       end
		       begin
                          if(wr_data[1] == 0) begin
                             uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_tx_rst_n",val[1]);
                             while(!l_read_done && (val[1] !== wr_data[1])) begin
                                uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_tx_rst_n",val[1]);
                                #2ns;
                             end
                             m_err[1] = (val[1] == wr_data[1])? 0 : 1;
                          end
                       end
		       begin
                          if(wr_data[2] == 0) begin
                             uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_rx_rst_n",val[2]);
                             while(!l_read_done && (val[2] !== wr_data[2])) begin
                                uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_rx_rst_n",val[2]);
                                #2ns;
                             end
                             m_err[2] = (val[2] == wr_data[2])? 0 : 1;
                          end
                       end
		    join

		    if( (m_err[2:0] !== 0) && (l_err[2:0] !== 0) )
		       `uvm_error(get_name(), $psprintf("User Space Reset Cntl Read Mismatch:Addr=0x%0h, exp rd[2:0]=0, act rd[2:0]=0x%0h", offset*4, rd_data1[2:0]))

	            if(rd_data1[31:3] !== 0) 
                       `uvm_error(get_name(), $psprintf("User Space Reset Cntl Resd Mismatch:Addr=0x%0h, exp rd[31:3]=0, act rd[31:3]=0x%0h", offset*4, rd_data1[31:3]))
				end

				if(NUM_PHY == 3) begin
					fork
						begin
							p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
							if(wr_data[8:0] !== rd_data1[8:0]) begin
								l_err[0] = (wr_data[0] == rd_data1[0])? 0 : 1;
								l_err[1] = (wr_data[1] == rd_data1[1])? 0 : 1;
								l_err[2] = (wr_data[2] == rd_data1[2])? 0 : 1;
								l_err[3] = (wr_data[3] == rd_data1[3])? 0 : 1;
								l_err[4] = (wr_data[4] == rd_data1[4])? 0 : 1;
								l_err[5] = (wr_data[5] == rd_data1[5])? 0 : 1;
								l_err[6] = (wr_data[6] == rd_data1[6])? 0 : 1;
								l_err[7] = (wr_data[7] == rd_data1[7])? 0 : 1;
								l_err[8] = (wr_data[8] == rd_data1[8])? 0 : 1;
								l_read_done = 1;
							end
							else l_read_done = 1;
						end
						begin
							if(wr_data[0] == 0) begin
							uvm_hdl_read("top_tbdut.soc_inst.subsys_tsn.intel_mge_phy_0.i_rst_n",val[0]);
								while(!l_read_done && (val[0] !== wr_data[0])) begin
									#2ns;
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_rst_n",val[0]);
								end
								m_err[0] = (val[0] == wr_data[0])? 0 : 1;
							end
						end
						begin
							if(wr_data[1] == 0) begin
								uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_tx_rst_n",val[1]);
								while(!l_read_done && (val[1] !== wr_data[1])) begin
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_tx_rst_n",val[1]);
									#2ns;
								end
								m_err[1] = (val[1] == wr_data[1])? 0 : 1;
							end
						end
						begin
							if(wr_data[2] == 0) begin
								uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_rx_rst_n",val[2]);
								while(!l_read_done && (val[2] !== wr_data[2])) begin
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_rx_rst_n",val[2]);
									#2ns;
								end
								m_err[2] = (val[2] == wr_data[2])? 0 : 1;
								end
						end
						begin
							if(wr_data[3] == 0) begin
							uvm_hdl_read("top_tbdut.soc_inst.subsys_tsn.intel_mge_phy_1.i_rst_n",val[3]);
								while(!l_read_done && (val[3] !== wr_data[3])) begin
									#2ns;
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_1.i_rst_n",val[3]);
								end
								m_err[3] = (val[3] == wr_data[3])? 0 : 1;
							end
						end
						begin
							if(wr_data[4] == 0) begin
								uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_1.i_tx_rst_n",val[4]);
								while(!l_read_done && (val[4] !== wr_data[4])) begin
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_1.i_tx_rst_n",val[4]);
									#2ns;
								end
								m_err[4] = (val[4] == wr_data[4])? 0 : 1;
							end
						end
						begin
							if(wr_data[5] == 0) begin
								uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_1.i_rx_rst_n",val[5]);
								while(!l_read_done && (val[5] !== wr_data[5])) begin
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_1.i_rx_rst_n",val[5]);
									#2ns;
								end
								m_err[5] = (val[5] == wr_data[5])? 0 : 1;
								end
						end	
						begin
							if(wr_data[6] == 0) begin
							uvm_hdl_read("top_tbdut.soc_inst.subsys_tsn.intel_mge_phy_2.i_rst_n",val[6]);
								while(!l_read_done && (val[6] !== wr_data[6])) begin
									#2ns;
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_2.i_rst_n",val[6]);
								end
								m_err[6] = (val[6] == wr_data[6])? 0 : 1;
							end
						end
						begin
							if(wr_data[7] == 0) begin
								uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_2.i_tx_rst_n",val[7]);
								while(!l_read_done && (val[7] !== wr_data[7])) begin
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_2.i_tx_rst_n",val[7]);
									#2ns;
								end
								m_err[7] = (val[7] == wr_data[7])? 0 : 1;
							end
						end
						begin
							if(wr_data[8] == 0) begin
								uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_2.i_rx_rst_n",val[8]);
								while(!l_read_done && (val[8] !== wr_data[8])) begin
									uvm_hdl_read("top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_2.i_rx_rst_n",val[8]);
									#2ns;
								end
								m_err[8] = (val[8] == wr_data[8])? 0 : 1;
								end
						end	
				join

					if( (m_err[8:0] !== 0) && (l_err[8:0] !== 0) )
					   `uvm_error(get_name(), $psprintf("User Space Reset Cntl Read Mismatch:Addr=0x%0h, exp rd[8:0]=0, act rd[8:0]=0x%0h", offset*4, rd_data1[8:0]))

					if(rd_data1[31:9] !== 0) 
						`uvm_error(get_name(), $psprintf("User Space Reset Cntl Resd Mismatch:Addr=0x%0h, exp rd[31:3]=0, act rd[31:3]=0x%0h", offset*4, rd_data1[31:3]))
				end // NUM_PHY = 3
				end // 'h1
				
            'h2 : begin
		    //Check default reg value
		    `uvm_info(get_name(), "ST1 Reading User Space 'h8", UVM_NONE)
		    if(rd_data0 !== 0)
                       `uvm_error(get_name(), $psprintf("User Space Logic Delay Mismatch: Addr=0x%0h, exp rd_data0=0,act rd_data0=%0h", offset*4, rd_data0))

	            //Check RO
                    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
                    p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
                    if(rd_data0 !== rd_data1)
                       `uvm_error(get_name(), $psprintf("User Space TxLogic Delay Mismatch: Addr=0x%0h, exp rd_data0=0x%0h, act rd_data1=0x%0h", offset*4, rd_data0, rd_data1))
                  end
            'h3 : begin
		    //Check default reg value
		    `uvm_info(get_name(), "ST1 Reading User Space 'hC", UVM_NONE)
		    if(rd_data0 !== 0)
                       `uvm_error(get_name(), $psprintf("User Space RxLogic Delay Mismatch: Addr=0x%0h, exp rd_data0=0,act rd_data0=%0h", offset*4, rd_data0))

	            //Check RO
                    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
                    p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
                    if(rd_data0 !== rd_data1)
                       `uvm_error(get_name(), $psprintf("User Space Logic Delay Mismatch: Addr=0x%0h, exp rd_data0=0x%0h, act rd_data1=0x%0h", offset*4, rd_data0, rd_data1))
                  end
           'h4 : begin
		    //Check default reg value
		    `uvm_info(get_name(), "ST1 Reading User Space 'h10", UVM_NONE)
		    if(rd_data0 !== 0)
                       `uvm_error(get_name(), $psprintf("User Space Error Stat Mismatch: Addr=0x%0h, exp rd_data0=0,act rd_data0=%0h", offset*4, rd_data0))
              
	            //Check Rsvd, RO
                    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
                    p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
		    if(rd_data1[31:3] !== 0)
                       `uvm_error(get_name(), $psprintf("User Space Error Stat Mismatch:Addr=0x%0h, exp rd_data1[31:3]=0, act rd_data1[31:3]=0x%0h", offset*4, rd_data1[31:3]))

	            if( (NUM_PHY == 1) && (wr_data[0] !== rd_data1[0]) )
                       `uvm_error(get_name(), $psprintf("User Space Error Stat Mismatch:Addr=0x%0h, exp wr[0]=0x%0h, act rd[0]=0x%0h", offset*4, wr_data[0], rd_data1[0]))

                    if( (NUM_PHY == 3) && (wr_data[2:0] !== rd_data1[2:0]) )
                       `uvm_error(get_name(), $psprintf("User Space Error Stat Mismatch:Addr=0x%0h, exp wr[2:0]=0x%0h, act rd[2:0]=0x%0h", offset*4, wr_data[2:0], rd_data1[2:0]))
                  end
           'h5 : begin
		    //Check default reg value
		    `uvm_info(get_name(), "ST1 Reading User Space 'h14", UVM_NONE)
                    if(rd_data0 !== 0)
                       `uvm_error(get_name(), $psprintf("User Space RxLogic Delay Mismatch: Addr=0x%0h, exp rd_data0=0,act rd_data0=%0h", offset*4, rd_data0))

	            //Check Rsvd, RW
                    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
                    p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
		    if(rd_data1[31:1] !== 0)
                       `uvm_error(get_name(), $psprintf("User Space DR Error Mismatch:Addr=0x%0h, exp rd_data1[31:1]=0, act rd_data1[31:1]=0x%0h", offset*4, rd_data1[31:1]))

                    if(wr_data[0] !== rd_data1[0])
                       `uvm_error(get_name(), $psprintf("User Space DR Error Mismatch:Addr=0x%0h, exp wr[0]=0x%0h, act rd[0]=0x%0h", offset*4, wr_data[0], rd_data1[0]))
                  end
           'h6 : begin
		    //Check default reg value
		    `uvm_info(get_name(), "ST1 Reading User Space 'h18", UVM_NONE)
		    if(rd_data0 !== 0)
                       `uvm_error(get_name(), $psprintf("User Space RxLogic Delay Mismatch: Addr=0x%0h, exp rd_data0=0,act rd_data0=%0h", offset*4, rd_data0))

	            //Check Rsvd, RW
                    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
                    p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
		    if(rd_data1[31:6] !== 0)
                       `uvm_error(get_name(), $psprintf("User Space DR Stat Mismatch:Addr=0x%0h, exp rd_data1[31:6]=0, act rd_data1[31:6]=0x%0h", offset*4, rd_data1[31:6]))

	            if( (NUM_PHY ==1) && (wr_data[1:0] !== rd_data1[1:0]) )
                       `uvm_error(get_name(), $psprintf("User Space DR Stat Mismatch:Addr=0x%0h, exp wr[1:0]=0x%0h, act rd[1:0]=0x%0h", offset*4, wr_data[1:0], rd_data1[1:0]))

                    if( (NUM_PHY ==3) && (wr_data[5:0] !== rd_data1[5:0]) )
                       `uvm_error(get_name(), $psprintf("User Space DR Stat Mismatch:Addr=0x%0h, exp wr[5:0]=0x%0h, act rd[5:0]=0x%0h", offset*4, wr_data[5:0], rd_data1[5:0]))
                  end
           'h7 : begin
		    //Check default reg value
		    `uvm_info(get_name(), "ST1 Reading User Space 'h1C", UVM_NONE)
		    if(rd_data0 !== 0)
                       `uvm_error(get_name(), $psprintf("User Space RxLogic Delay Mismatch: Addr=0x%0h, exp rd_data0=0,act rd_data0=%0h", offset*4, rd_data0))

	            //Check RO
                    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
                    p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
                    if(rd_data0  !== rd_data1)
                       `uvm_error(get_name(), $psprintf("User Space Phy Delay Mismatch:Addr=0x%0h, exp rd_data0=0x%0h, act rd_data1=0x%0h", offset*4, rd_data0, rd_data1))
                  end
           default: begin
		    //Check invalid registers
		    if(rd_data0 !== 0)
                       `uvm_error(get_name(), $psprintf("User Space RxLogic Delay Mismatch: Addr=0x%0h, exp rd_data0=0,act rd_data0=%0h", offset*4, rd_data0))
		    p_sequencer.env.reg_write_axi(offset, reg_base_addr, wr_data);
		    p_sequencer.env.reg_read_axi(offset, reg_base_addr, rd_data1);
		    if(rd_data1 !== 0)
		       `uvm_error(get_name(), $psprintf("User Space Rsvd Mismatch: Addr=0x%0h, exp rd_data=0, act rd_data1=0x%0h", offset*4, rd_data1))
		  end
          endcase
       end
 

      //2. MDIO-PHY
      //`uvm_info(get_name(), "Reading user csr MDIO-PHY Management space", UVM_NONE)

      //3. I2C-PHY
      //`uvm_info(get_name(), "Reading user csr I2C-PHY Management space", UVM_NONE)

  endtask

endclass
