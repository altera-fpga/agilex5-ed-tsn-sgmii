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


// sequence_name : an_register_access_sequence
// 1. Apply IP reset (maintained by testcase) 
// 2. Performing random read write pattern by shuffling the registers.
// 3. Performing write-check random pattern to reserved spaces
// 4. Performing read check and again random read write pattern by shuffling the registers.
// 5. Apply CSR reset & wait for pcs ready ->Please check whether it is supported or not in GDR
// 6. Read-check all the registers

class an_register_access_sequence extends an_base_sequence;
  uvm_reg_data_t read_data,write_data;
  uvm_reg 	 regs[$];
  uvm_reg 	regs_org[$];
  int resv_regs[$];
  bit [1:0] compare_disable[integer];
  // TBD venkatkx bit [31:0] max_address = 'h9DFC;  //Max address of register lists
  bit [31:0] max_address = 'h1FFC;  //Max address of register lists
  bit [31:0] min_address = 'h0;
  bit [31:0] data = 'h0;
  int addr;
  int end_addr;
  int start_addr;
  speed_e speed;
  bit regs_valid = 0;

  `uvm_object_utils(an_register_access_sequence)

  function new(string name = "an_register_access_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  `ifdef UVM_VERSION_1_1
     virtual task pre_start();
       reg_access_seq=1;
       super.pre_start();
     endtask:pre_start
  `endif

  virtual task body();

    uvm_status_e  status;
    
    `uvm_info(get_type_name(), "started an_register_access_sequence ...", UVM_NONE)
    
    // Disabling functional register coverage.
    // p_sequencer.env.dis_reg_cov=1;

    //p_sequencer.env.dyn_rcfg_obj_inst.print();

    start_addr = 'h0;
    end_addr = 'h3FC;
    //FIXME for Multi port Case 
    //p_sequencer.env.reg_model.default_map.get_registers(regs_org);
    if(p_sequencer.top_env.kr_cfg_inst.is_speed_25g) begin
        p_sequencer.top_env.kr25g_reg_model.get_registers(regs_org);
	speed = _25G;
    end 	
    if(p_sequencer.top_env.kr_cfg_inst.is_speed_50g) begin
        p_sequencer.top_env.kr50g_reg_model.get_registers(regs_org);
	speed = _50G;
    end 	
    if(p_sequencer.top_env.kr_cfg_inst.is_speed_100g) begin
        p_sequencer.top_env.kr100g_reg_model.get_registers(regs_org);
	speed = _100G;
    end 	
    if(p_sequencer.top_env.kr_cfg_inst.is_speed_200g) begin
        p_sequencer.top_env.kr200g_reg_model.get_registers(regs_org);
	speed = _200G;
    end 	
    if(p_sequencer.top_env.kr_cfg_inst.is_speed_400g) begin
        p_sequencer.top_env.kr400g_reg_model.get_registers(regs_org);
	speed = _400G;
    end 	
    if(p_sequencer.top_env.kr_cfg_inst.is_speed_10g) begin
        p_sequencer.top_env.kr10g_reg_model.get_registers(regs_org);
	speed = _10G;
    end 	
    if(p_sequencer.top_env.kr_cfg_inst.is_speed_40g) begin
        p_sequencer.top_env.kr40g_reg_model.get_registers(regs_org);
	speed = _40G;
    end 	

    #100ns;
    
    regs.delete(); 
    regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );

    foreach(regs[i]) begin
      `uvm_info("an_register_access_sequence", $sformatf("Register Name %0s %0h",regs[i].get_name(),regs[i].get_address()), UVM_LOW)
    end

    //read Defaut Values
    foreach(regs[i]) begin
       p_sequencer.top_env.reg_read_anlt(regs[i].get_name(),read_data,speed);
      `uvm_info("an_register_access_sequence", $sformatf("Register Read %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),read_data), UVM_LOW)
    end
 
    write_data = $urandom();

    foreach(regs[i]) begin
       write_data = $urandom();
      `uvm_info("an_register_access_sequence", $sformatf("Register write %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),write_data), UVM_LOW)
       p_sequencer.top_env.reg_write_anlt(regs[i].get_name(),write_data,speed);
    end

    foreach(regs[i]) begin
       p_sequencer.top_env.reg_read_anlt(regs[i].get_name(),read_data,speed);
      `uvm_info("an_register_access_sequence", $sformatf("Register Read %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),read_data), UVM_LOW)
    end

    //check other address Data 
    start_addr = 'h400;
    end_addr = 'h3FFC;

    regs.delete();
    regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );


    regs.shuffle();

    for(int i = 0; i < 100;i++) begin
      `uvm_info("an_register_access_sequence", $sformatf("Register Read %0s addr : %0h",regs[i].get_name(),regs[i].get_address()), UVM_LOW)
      write_data = $urandom();
      regs[i].write(status,.value(write_data));
      regs[i].read(status,.value(read_data));

    end

    //apply reconfig Reset 
    p_sequencer.top_env.env_ip[0].apply_reconfig_reset();

     start_addr = 'h0;
    end_addr = 'h3FC;

    #100ns;

    regs.delete(); 
    regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );

    foreach(regs[i]) begin
      `uvm_info("an_register_access_sequence", $sformatf("Register Name %0s %0h",regs[i].get_name(),regs[i].get_address()), UVM_LOW)
    end

    //read Defaut Values
    foreach(regs[i]) begin
       p_sequencer.top_env.reg_read_anlt(regs[i].get_name(),read_data,speed);
      `uvm_info("an_register_access_sequence", $sformatf("Register Read %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),read_data), UVM_LOW)
    end
 
    write_data = $urandom();

    foreach(regs[i]) begin
       write_data = $urandom();
      `uvm_info("an_register_access_sequence", $sformatf("Register write %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),write_data), UVM_LOW)
       p_sequencer.top_env.reg_write_anlt(regs[i].get_name(),write_data,speed);
    end

    foreach(regs[i]) begin
       p_sequencer.top_env.reg_read_anlt(regs[i].get_name(),read_data,speed);
      `uvm_info("an_register_access_sequence", $sformatf("Register Read %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),read_data), UVM_LOW)
    end

    //check other address Data 
    start_addr = 'h400;
    end_addr = 'h3FFC;

    regs.delete();
    regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );


    regs.shuffle();

    for(int i = 0; i < 100;i++) begin
      `uvm_info("an_register_access_sequence", $sformatf("Register Read %0s addr : %0h",regs[i].get_name(),regs[i].get_address()), UVM_LOW)
      write_data = $urandom();
      regs[i].write(status,.value(write_data));
      regs[i].read(status,.value(read_data));

    end
     
    // walking one's 
    start_addr = 'h0;
    end_addr = 'h3FC;

    #100ns;
      `uvm_info("an_register_access_sequence", $sformatf("PCR: walking ones"), UVM_LOW)

    regs.delete(); 
    regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );

    foreach(regs[i]) begin
      `uvm_info("an_register_access_sequence", $sformatf("Register Name %0s %0h",regs[i].get_name(),regs[i].get_address()), UVM_LOW)
    end

    foreach(regs[i]) begin
      for(int j=0;j<32;j++)begin
        data[j]=1;
        write_data = data;
      `uvm_info("an_register_access_sequence", $sformatf("Register write %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),write_data), UVM_LOW)
      p_sequencer.top_env.reg_write_anlt(regs[i].get_name(),write_data,speed);
    end
      data='h0;
  end

    foreach(regs[i]) begin
       p_sequencer.top_env.reg_read_anlt(regs[i].get_name(),read_data,speed);
      `uvm_info("an_register_access_sequence", $sformatf("Register Read %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),read_data), UVM_LOW)
    end

    //walking zero's
      `uvm_info("an_register_access_sequence", $sformatf("PCR: walking zeros"), UVM_LOW)
    #100ns;
    data='hFFFF_FFFF;
    foreach(regs[i]) begin
      for(int j=0;j<32;j++)begin
        data[j]=0;
        write_data = data;
      `uvm_info("an_register_access_sequence", $sformatf("Register write %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),write_data), UVM_LOW)
      p_sequencer.top_env.reg_write_anlt(regs[i].get_name(),write_data,speed);
    end
    data='hFFFF_FFFF;
  end

    foreach(regs[i]) begin
       p_sequencer.top_env.reg_read_anlt(regs[i].get_name(),read_data,speed);
      `uvm_info("an_register_access_sequence", $sformatf("Register Read %0s addr : %0h data : %0h",regs[i].get_name(),regs[i].get_address(),read_data), UVM_LOW)
    end

// Writing to illegal address    
      `uvm_info("an_register_access_sequence", $sformatf("PCR: illegal access"), UVM_LOW)
    start_addr = 'h0;
    end_addr = 'h3FC;

    `uvm_info("eth_register_write_reserved_space", "2:write Pattern on reserved space_new('h000-'h3FC)", UVM_LOW)

    for(int addr='h000 ;addr <= 'h3FC ; addr++)
     begin
     
       foreach(regs[i]) begin
         if(regs[i].get_address()== addr)begin
	      regs_valid=1;
	      break;
          end
       end

      if(regs_valid!=1)begin
      `uvm_info("an_register_access_sequence", $sformatf("Illegal Register write addr : %0h ",addr), UVM_LOW)
        p_sequencer.top_env.reg_write_by_addr_anlt(addr,$random(),speed);
       end
      
       regs_valid=0;
     end



    `uvm_info(get_type_name(), "finished an_register_access_sequence ...", UVM_NONE)

  endtask
endclass
