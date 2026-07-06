// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


class eth_register_write_reserved_space_3 extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit [2:0]     reset_sel; 
  bit compare_disable[integer];
  bit [31:0] max_address = 'hFFFF;
  bit [31:0] min_address = 'h8000;
  int reg_index[$];

  `uvm_object_utils(eth_register_write_reserved_space_3)

  function new(string name = "eth_register_write_reserved_space_3");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    //disabling register coverage
    //p_sequencer.env.dis_reg_cov=1; //disabling register coverage
    p_sequencer.env.apply_reset("hard",0,0,1,11);
    enable_disable_anlt_reset();

    p_sequencer.reg_model.default_map.get_registers(regs_org);
    
    
    `uvm_info(get_name(), $sformatf("max_address =%0d ", max_address), UVM_MEDIUM)

    foreach(regs_org[i]) begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) begin 
      regs.push_back(regs_org[i]);
      end
    end
 

    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    p_sequencer.env.reg_read('h37F,read_data); //Read Immediately
    p_sequencer.env.reg_read('h380,read_data); //Read Immediately
    p_sequencer.env.reg_read('h381,read_data); //Read Immediately
    //`ifndef CRETE3
      p_sequencer.env.reg_read('h382,read_data); //Read Immediately
    //`endif
   
    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

   
    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors(); //pbenittx  
    `endif


    foreach(regs[i]) begin
      `uvm_info("eth_register_write_reserved_space_3", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_MEDIUM)
    end
 

      `uvm_info("eth_register_write_reserved_space_3", "write Pattern on reserved space('h8000-'hBFFF)...", UVM_LOW)
       for(int addr ='h8000;addr <= 'hBFFF;addr++)
       begin
         p_sequencer.env.reg_write(addr,'hAAAAAAAA);
         p_sequencer.env.reg_read(addr,read_data,1);
       end
     
    
     `uvm_info("eth_register_write_reserved_space_3", "write Pattern on reserved space('hC000-'hFFFF)...", UVM_LOW)
      for(int addr ='hC000;addr <= 'hFFFF;addr++)
      begin
        p_sequencer.env.reg_write(addr,'hAAAAAAAA);
        p_sequencer.env.reg_read(addr,read_data,1);
      end
 
 
  endtask
endclass
