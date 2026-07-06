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


class eth_xcvr_register_access_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg   regs[$];
  bit compare_disable[integer];
  uvm_reg_data_t avmm2_addr[$];
   dyn_rcfg dyn_rcfg_obj_inst;
  `uvm_object_utils(eth_xcvr_register_access_sequence)

  function new(string name = "eth_xcvr_register_access_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("eth_xcvr_register_access_sequence", "Starting XCVR register Access", UVM_NONE)

    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_snps_errors();
    `endif

    p_sequencer.env.xcvr_reg_model_0.default_map.get_registers(regs);
    
    enable_disable_anlt_reset();
 
   // Plan is to do a integration testing so, accessing only 10 registers randomly
    regs.shuffle();
    foreach(regs[i]) begin
       if(i > 10)
         regs.delete(i);
        `uvm_info("UX REG NAME",$sformatf("Register Name :: Reg name %0s ",regs[i].get_name()),UVM_MEDIUM)
          regs.delete(i);
     end


    `uvm_info("eth_xcvr_register_access_sequence", "1:Reading DEFAULT values of registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,0,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,1,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,2,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,3,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,4,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,5,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,6,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,7,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,8,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,9,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,10,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,11,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,12,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,13,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,14,0);
      p_sequencer.env.gdr_ral_read_ux(regs[i].get_address(),read_data,15,0);
    end
    //Writing and reading from regs based on different speeds
    if (dyn_rcfg_obj_inst.speed == _25G)
      begin
        foreach(regs[i])
          begin
           avmm2_addr[i] = regs[i].get_address()>>2;
          `uvm_info("UX REG ADDR", $sformatf("UX Register Address :'h%0h",avmm2_addr[i]), UVM_MEDIUM)
          `uvm_info("eth_xcvr_register_access_sequence", ":Write registers", UVM_NONE)
            p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),0);
            `uvm_info("eth_xcvr_register_access_sequence", ":Read registers", UVM_NONE)
            p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,0,3'b000);
          end 
      end
      else if (dyn_rcfg_obj_inst.speed == _50G)
      begin
        foreach(regs[i])
          begin
           avmm2_addr[i] = regs[i].get_address()>>2 ;
           `uvm_info("UX REG ADDR", $sformatf("UX Register Address :'h%0h",avmm2_addr[i]), UVM_MEDIUM)
           `uvm_info("eth_xcvr_register_access_sequence", ":Write registers", UVM_NONE)
            fork
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),0);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),1);  //only 2 lanes for 50G // write for 100G too
            join
            `uvm_info("eth_xcvr_register_access_sequence", ":Read registers", UVM_NONE)
            fork
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,0,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,1,3'b000);
            join
          end 
     end

      else if (dyn_rcfg_obj_inst.speed == _100G)
      begin
        foreach(regs[i])
          begin
           avmm2_addr[i] = regs[i].get_address()>>2 ;
           `uvm_info("UX REG ADDR", $sformatf("UX Register Address :'h%0h",avmm2_addr[i]), UVM_MEDIUM)
           `uvm_info("eth_xcvr_register_access_sequence", ":Write registers", UVM_NONE)
            fork
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),0);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),1);  //only 2 lanes for 50G // write for 100G too
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),2);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),3);
            join
            `uvm_info("eth_xcvr_register_access_sequence", ":Read registers", UVM_NONE)
            fork
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,0,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,1,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,2,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,3,3'b000);
            join
          end 
     end
     else if (dyn_rcfg_obj_inst.speed ==  _200G)
     begin
        foreach(regs[i])
          begin
            avmm2_addr[i] = regs[i].get_address()>>2;
            `uvm_info("UX REG ADDR", $sformatf("UX Register Address :'h%0h",avmm2_addr[i]), UVM_MEDIUM)
            `uvm_info("eth_xcvr_register_access_sequence", ":Write registers", UVM_NONE)
            fork
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),0);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),1);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),2);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),3);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),4);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),5);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),6);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),7);
            join
            `uvm_info("eth_xcvr_register_access_sequence", ":Read registers", UVM_NONE)
            fork
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,0,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,1,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,2,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,3,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,4,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,5,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,6,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,7,3'b000);
           join
          end 
     end
     else if (dyn_rcfg_obj_inst.speed ==  _400G)
     begin
        foreach(regs[i])
          begin
            avmm2_addr[i] = regs[i].get_address>>2;
            `uvm_info("UX REG ADDR", $sformatf("UX Register Address :'h%0h",avmm2_addr[i]), UVM_MEDIUM)
           `uvm_info("eth_xcvr_register_access_sequence", ":Write registers", UVM_NONE)
            fork
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),0);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),1);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),2);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),3);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),4);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),5);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),6);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),7);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),8);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),9);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),10);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),11);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),12);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),13);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),14);
              p_sequencer.env.gdr_ral_write_ux(avmm2_addr[i],$urandom(),15);
            join
            `uvm_info("eth_xcvr_register_access_sequence", ":Read registers", UVM_NONE)
            fork
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,0,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,1,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,2,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,3,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,4,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,5,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,6,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,7,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,8,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,9,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,10,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,11,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,12,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,13,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,14,3'b000);
              p_sequencer.env.gdr_ral_read_ux(avmm2_addr[i],read_data,15,3'b000);
            join
        end 
     end
endtask
endclass
