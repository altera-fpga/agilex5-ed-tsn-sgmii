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


class eth_soft_kr_register_access_sequence extends eth_base_sequence;
  
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit compare_disable[integer];
  bit [31:0] max_address = 'hBFF;
  bit [31:0] min_address = 'h020;
  bit [31:0] addr = 'h0;
  int reg_index[$];
  `uvm_object_utils(eth_soft_kr_register_access_sequence)

  function new(string name = "eth_soft_kr_register_access_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    //p_sequencer.env.dis_reg_cov=1; //disabling register coverage
    p_sequencer.env.dyn_rcfg_obj_inst.print();

    p_sequencer.env.apply_reset("hard",0,0,1,11);
    p_sequencer.reg_model.default_map.get_registers(regs_org);
    enable_disable_anlt_reset();

    foreach(regs_org[i]) 
    begin
        if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address)
      begin
         if(regs_org[i].get_address inside {['h0B0:'h0FF],['h311:'h322],['h329:329],['h32B:'h32C]})
        regs.push_back(regs_org[i]);
      end
    end

    `uvm_info("eth_soft_kr_register_access_sequence", "Performing All F's Pattern...", UVM_LOW)

    foreach(regs[i]) 
     begin
        p_sequencer.env.reg_write(regs[i].get_address(),'hFFFF_FFFF);
        p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
     end

    // Test will hung if we try to access ehip registers before ehip_ready is asserted-->1409741466
    //fork : process_1 
    //  begin
    //	  `uvm_info("eth_soft_kr_register_access_sequence", "Entered in first process", UVM_LOW)
// FIXME-MISSING_REG_IN_GDR    //       p_sequencer.env.reg_read(`REGISTERS_phy_revid_OFFSET_REG,read_data);
    //  end
    //    
    //  begin
    //       #455945ns;
    //	   `uvm_info("eth_soft_kr_register_access_sequence", "Entered in second process", UVM_LOW)
    //  end
    //join_any
    //disable process_1;

    //wait for ehip ready
    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);


    foreach(regs_org[i]) 
    begin
        if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address)
      begin
         if(regs_org[i].get_address inside {['h0B0:'h0FF],['h311:'h322],['h329:329],['h32B:'h32C],['h510:'h510],['h300:'h305]})
        regs.push_back(regs_org[i]);
      end
    end

    `uvm_info("eth_soft_kr_register_access_sequence", "Performing read and write access", UVM_LOW)
    foreach(regs[i]) 
     begin
         p_sequencer.env.reg_write(regs[i].get_address(),'hFFFF_FFFF);
         p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
     end
   
    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors(); //pbenittx
    `endif

      endtask
endclass
