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


class eth_register_write_reserved_space_anlt_ptp extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit [2:0]     reset_sel; 
  bit compare_disable[integer];
  bit [31:0] max_address = 'h5FF;
  bit [31:0] min_address = 'h300;
  int reg_index[$];

  `uvm_object_utils(eth_register_write_reserved_space_anlt_ptp)

  function new(string name = "eth_register_write_reserved_space_anlt_ptp");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
////dsamantx: FIX_ME for GDR_ANLT   
//    //disabling register coverage
//    p_sequencer.env.dis_reg_cov=1; //disabling register coverage
//    p_sequencer.env.apply_reset("hard",0,0,1,11);
//    enable_disable_anlt_reset();
//
//    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count ==1 )   max_address = 'h9FF; 
//    if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == 1) max_address = 'hDFF;
//    p_sequencer.reg_model.default_map.get_registers(regs_org);
//    
//    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
//   
//    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//    
//    `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h000-'h0AF)...", UVM_LOW)
//    for(int addr = 'h000;addr <= 'h0AF;addr++)
//    begin
//      p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//      p_sequencer.env.reg_read(addr,read_data);
//    end
//    
//    `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h0B2-'h0BF)...", UVM_LOW)
//    for(int addr = 'h0B2;addr <= 'h0BF;addr++)
//    begin
//      p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//      p_sequencer.env.reg_read(addr,read_data);
//    end
//    
//    p_sequencer.env.reg_write('hCF,'hFFFFFFFF);
//    p_sequencer.env.reg_read('hCF,read_data);
//    
//    `ifdef CRETE3
//      `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h0D4-'h0DF)...", UVM_LOW)
//      for(int addr = 'h0D4;addr <= 'h0DF;addr++)
//    `else
//      `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h0D8-'h0DF)...", UVM_LOW)
//      for(int addr = 'h0D8;addr <= 'h0DF;addr++)
//    `endif
//    begin
//      p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//      p_sequencer.env.reg_read(addr,read_data);
//    end
//
//    `ifndef CRETE3
//    `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h0EC-'h0EF)...", UVM_LOW)
//      for(int addr = 'h0EC;addr <= 'h0EF;addr++)
//      begin
//        p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//        p_sequencer.env.reg_read(addr,read_data);
//      end
//    `endif
//
//    `ifdef CRETE3
//    `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h0E1-'h0E3)...", UVM_LOW)
//      for(int addr = 'h0E1;addr <= 'h0E3;addr++)
//      begin
//        p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//        p_sequencer.env.reg_read(addr,read_data);
//      end
//    `endif
//
//    `ifdef CRETE3
//    `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h0E5-'h0E7)...", UVM_LOW)
//      for(int addr = 'h0E5;addr <= 'h0E7;addr++)
//      begin
//        p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//        p_sequencer.env.reg_read(addr,read_data);
//      end
//    `endif
//    
//    `ifdef CRETE3
//    `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h0E9-'h0EF)...", UVM_LOW)
//      for(int addr = 'h0E9;addr <= 'h0EF;addr++)
//      begin
//        p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//        p_sequencer.env.reg_read(addr,read_data);
//      end
//    `endif
//    
//    `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('h0F0-'h2FF)...", UVM_LOW)
//    for(int addr = 'h0F0;addr <= 'h2FF;addr++)
//    begin
//      p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//      p_sequencer.env.reg_read(addr,read_data);
//    end
//    
//    p_sequencer.env.reg_write('hA0F,'hFFFFFFFF);
//    p_sequencer.env.reg_read('hA0F,read_data);
//    
//    `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('hA10-'hAFF)...", UVM_LOW)
//    for(int addr = 'hA10;addr <= 'hAFF;addr++)
//    begin
//      p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//      p_sequencer.env.reg_read(addr,read_data);
//    end
//
//    `ifdef CRETE3 
//      `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('hB12-'hBFF)...", UVM_LOW)
//      for(int addr = 'hB12;addr <= 'hBFF;addr++)
//    `else
//      `uvm_info("eth_register_write_reserved_space_anlt_ptp", " write Pattern on reserved space('hB09-'hBFF)...", UVM_LOW)
//      for(int addr = 'hB09;addr <= 'hBFF;addr++)
//    `endif
//      begin
//        p_sequencer.env.reg_write(addr,'hFFFFFFFF);
//        p_sequencer.env.reg_read(addr,read_data);
//      end
  endtask//body
endclass//eth_register_write_reserved_space_anlt_ptp
