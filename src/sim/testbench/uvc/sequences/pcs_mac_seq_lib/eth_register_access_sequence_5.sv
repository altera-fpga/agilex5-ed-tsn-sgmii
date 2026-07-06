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


class eth_register_access_sequence_5 extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$],regs_temp[$];
  bit compare_disable[integer];
  bit [31:0] max_address = 'h5FF;
  bit [31:0] min_address = 'h300;
  int reg_index[$];
  int unique_nonce_field; 


  `uvm_object_utils(eth_register_access_sequence_5)

  function new(string name = "eth_register_access_sequence_5");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   //dsamantx:FIX_ME for GDR_ANLT
    dis_stats_chk =1 ;	
    //p_sequencer.env.dis_reg_cov=1; //disabling register coverage
    p_sequencer.env.dyn_rcfg_obj_inst.print();
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count ==1 ) max_address = 'h9ff; 
    if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == 1) max_address = 'hdff;

    p_sequencer.env.apply_reset("hard",0,0,1,11);
    p_sequencer.reg_model.default_map.get_registers(regs_org);

    `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)

    foreach(regs_org[i]) 
    begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
      begin
        regs.push_back(regs_org[i]);
      end
    end
    
    //Status registers value not predictable
    foreach(regs[i]) begin
//      if(
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_anlt_seq_status_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_an_status_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_an_status1_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_an_status2_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_an_status3_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_an_status4_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_an_status5_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_an_status6_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_anlt_seq_cfg_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_an_cfg2_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_lt_cfg2_OFFSET_REG ||
// FIXME-MISSING_REG_IN_GDR        regs[i].get_address() == `REGISTERS_lt_status1_OFFSET_REG 
// FIXME-GDR        ) begin
// FIXME-GDR        compare_disable[regs[i].get_address()] = 1;
// FIXME-GDR      end 
// FIXME-GDR      else begin
// FIXME-GDR        compare_disable[regs[i].get_address()] = 0;
// FIXME-GDR      end
    end
    `ifdef ANLT
    /*if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
    begin 
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
    end */
    
    foreach(regs[i]) begin
      `uvm_info("eth_register_access_sequence_5", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end
    
    `uvm_info("eth_register_access_sequence_5", "1:Read registers", UVM_NONE)
    p_sequencer.env.reg_read('hB0,read_data,1);
    p_sequencer.env.reg_read('hC1,read_data,1);
    p_sequencer.env.reg_read('hD1,read_data,1);
    
    //Checking WRC field for below 3 registers
    p_sequencer.env.reg_write('hB0,'hFFFF_FFFF);
    p_sequencer.env.reg_read('hB0,read_data,1);
    p_sequencer.env.reg_read('hB0,read_data,1);
    
    p_sequencer.env.reg_write('hC1,'hFFFF_FFFF);
    p_sequencer.env.reg_read('hC1,read_data,1);
    p_sequencer.env.reg_read('hC1,read_data,1);

    p_sequencer.env.reg_write('hD1,'hFFFF_FFFF);
    p_sequencer.env.reg_read('hD1,read_data,1);
    p_sequencer.env.reg_read('hD1,read_data,1);
    
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `ifndef CRETE3
      //FB:552974
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_frame_ln0_OFFSET_REG] = 1; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_frame_ln1_OFFSET_REG] = 1; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_frame_ln2_OFFSET_REG] = 1; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_frame_ln3_OFFSET_REG] = 1;
      //RO registers but status register so not able to predict
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_txeq1_ln0_OFFSET_REG] = 1; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_txeq1_ln1_OFFSET_REG] = 1; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_txeq1_ln2_OFFSET_REG] = 1; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_txeq1_ln3_OFFSET_REG] = 1; 
    `endif

    `uvm_info("eth_register_access_sequence_5", "Performing All 1s Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),'hFFFF_FFFF);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
    
    `ifndef CRETE3
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_frame_ln0_OFFSET_REG] = 0; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_frame_ln1_OFFSET_REG] = 0; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_frame_ln2_OFFSET_REG] = 0; 
// FIXME-MISSING_REG_IN_GDR      compare_disable[`REGISTERS_lt_frame_ln3_OFFSET_REG] = 0; 
    `endif
    
    `uvm_info("eth_register_access_sequence_5", "Performing All 0s Pattern...", UVM_LOW)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_write(regs[i].get_address(),'h00000000);
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

    `uvm_info("eth_register_access_sequence_5", "Applied hard reset", UVM_LOW)
    p_sequencer.env.apply_reset("hard",0,0,1,11);
    
    `uvm_info("eth_register_access_sequence_5", "2:Read registers", UVM_NONE)
    foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end
  `else
  `uvm_info("eth_register_access_sequence_5", "THIS SEQUENCE SHOULD BE RUN WITH ANLT1 AS IT CONTAINS ALL THE ANLT REGSITERS", UVM_LOW)
   `endif
    #5us;
`ifdef ANLT
  `ifndef CRETE3
    p_sequencer.env.apply_reset("hard",0,0,1,11);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_an_cfg1_OFFSET_REG,read_data,.disable_check(1'b1));
    read_data[0] = 1'b1;
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_an_cfg1_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
    read_data[0] = 1;
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG, read_data);

    wait (p_sequencer.env.spy_if.an_arb_state ==1);//TRANSMIT_DISABLE
    unique_nonce_field = $urandom();
    p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TRANSMIT_NONCE_FIELD,unique_nonce_field);

      p_sequencer.env.reg_read('h302,read_data);
      p_sequencer.env.reg_read('h303,read_data);
      p_sequencer.env.reg_read('h304,read_data);
      p_sequencer.env.reg_read('h402,read_data);
      p_sequencer.env.reg_read('h403,read_data);
      p_sequencer.env.reg_read('h404,read_data);
      p_sequencer.env.reg_read('h502,read_data);
      p_sequencer.env.reg_read('h503,read_data);
      p_sequencer.env.reg_read('h504,read_data);
      p_sequencer.env.reg_read('h602,read_data);
      p_sequencer.env.reg_read('h603,read_data);
      p_sequencer.env.reg_read('h604,read_data);
      p_sequencer.env.reg_read('h702,read_data);
      p_sequencer.env.reg_read('h703,read_data);
      p_sequencer.env.reg_read('h704,read_data);
      p_sequencer.env.reg_read('h842,read_data);
      p_sequencer.env.reg_read('h843,read_data);
      p_sequencer.env.reg_read('h844,read_data);
      p_sequencer.env.reg_read('h942,read_data);
      p_sequencer.env.reg_read('h943,read_data);
      p_sequencer.env.reg_read('h944,read_data);
   `endif
  `endif
    
endtask
endclass 
