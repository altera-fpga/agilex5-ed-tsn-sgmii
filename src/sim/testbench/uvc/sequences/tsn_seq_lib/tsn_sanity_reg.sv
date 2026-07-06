class tsn_sanity_reg extends eth_base_sequence;

  `uvm_object_utils(tsn_sanity_reg)
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
         num_of_frames=10;
    end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new


  //---------------------------------------
  //virtual task body();
  //---------------------------------------
  virtual task body();
  //  bit [31:0] data_read;
   uvm_reg_data_t data_read;

   `uvm_info(get_name(),$sformatf("ST1: NUM_PHY=%0d", NUM_PHY),UVM_NONE)
   `uvm_info(get_name(),$sformatf("ST1: NUM_PHY=%0d", NUM_PHY),UVM_MEDIUM)

   `uvm_info(get_name(), "Reading user csr space", UVM_NONE)
   p_sequencer.env.reg_read_axi('h1, 'h1002_0300, data_read); //after shift=2 Addr='h04
   //if(data_read !== 'h1ff)
   //   `uvm_error(get_name(), $psprintf("reset (csr) = %0h expected = 'h1ff", data_read))

   if( (NUM_PHY == 1) && (data_read !== 'h7) )
      `uvm_error(get_name(), $psprintf("reset (csr) = %0h expected = 'h7", data_read))

   if( (NUM_PHY == 3) && (data_read !== 'h1ff) )
      `uvm_error(get_name(), $psprintf("reset (csr) = %0h expected = 'h1ff", data_read))

   p_sequencer.env.reg_write_axi('h0, 'h1002_0280, 32'hffffffff);
   p_sequencer.env.reg_read_axi('h0, 'h1002_0280, data_read);
   if(data_read != 'h0)
      `uvm_error(get_name(), $psprintf("reserved (csr) = %0h expected = 'h0", data_read))
  endtask
endclass
