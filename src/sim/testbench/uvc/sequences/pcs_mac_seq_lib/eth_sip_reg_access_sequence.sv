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


// sequence_name : eth_sip_reg_access_sequence
// Owner : Abhishek Tiwari (atiwari2)
// 1. Deleting non SIP registers for testing thoroughly
// 2. Read the reset value of registers
// 3. Performing random read write pattern by shuffling the registers.
// 4. Performing All 1's pattern
// 5. Performing All 0's pattern
// 7. Performing All A's pattern
// 7. Performing All 5's pattern

class eth_sip_reg_access_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	 regs[$];
  uvm_reg 	 temp_regs[$];
  uvm_reg 	 sip_regs[$];
  int rsvd_temp_regs[$];
  // compare_disable is 2 bit variable for read comparision where 0=normal_check; 1=disable_check; 2=WO masked check; 3=both WO & RO masked check
  bit [1:0] compare_disable[integer];
  uvm_reg_byte_en_t byteenable;

  int end_addr;
  int start_addr;
  bit[31:0] rsvd_end_addr;
  bit[31:0] rsvd_start_addr;
  bit[31:0] addr;

  int aib_addr;
  `uvm_object_utils(eth_sip_reg_access_sequence)

  function new(string name = "eth_sip_reg_access_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new
    
  task compare_disable_sip_regs();
     //DE HSD : 16012342157, 16012712462
     //DV HSD: 16012971982
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G}) begin
        compare_disable[`ETH_F_ALL_pcs_status_OFFSET_REG] = 0; //disabling only bit 0,1
	compare_disable[`ETH_F_ALL_pcs_control_OFFSET_REG] = 1;
      end	
        compare_disable[`ETH_F_ALL_aib_transfer_ready_status_OFFSET_REG] = 1; 
  endtask 

  virtual task body();
    
    // Disabling functional register coverage.
    p_sequencer.env.reg_cov.dis_reg_cov=1; 
   
    // Disabling scoreboard as garbage data comes from DUT resulting to packet count mismatch and also this is no traffic sequence.
    p_sequencer.env.dynamic_enable_disable_scoreboards(1); 

    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.ts_tasks_if.set_enable_a_byteenable_legal(0);
      p_sequencer.env.disable_all_snps_errors();  
    `endif

    #600us; //Delay prev added for stabilization of clock mon
    
    `uvm_info(get_type_name(), "started eth_sip_reg_access_sequence ...", UVM_NONE)
    
    // Collecting the register bank which needs to be accessed.
    collect_gdr_register_bank(regs);

    // atiwari2 - deleting non SIP registers for testing integrity
    //Skip testing PTP registers for non-PTP modes
    if(p_sequencer.env.dyn_rcfg_obj_inst.ptp == 0) begin
      start_addr = 'h100;
      end_addr   = 'h07FC;
    end else begin
      start_addr = 'h100;
      end_addr   = 'h0FFC;
    end
    temp_regs = regs.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
    sip_regs = {sip_regs,temp_regs};
 
    // Masking the WO registers read comparison only for default read
    foreach(sip_regs[i]) begin
        compare_disable[sip_regs[i].get_address()] = 2;
    end
    compare_disable_sip_regs();

    // Register Read for default values
    foreach(sip_regs[i]) 
    begin
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_read(sip_regs[i].get_address(),read_data,compare_disable[sip_regs[i].get_address()],.byte_enable(byteenable));
    end
  
    // removing soft reset register, as they may fail the test.
    foreach(sip_regs[i]) begin
        if(sip_regs[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG)
            sip_regs.delete(i);
    end



    // Re-Enable the comparision for all registers
    foreach(sip_regs[i]) begin
        compare_disable[sip_regs[i].get_address()] = 0;
    end

    // Below are WO register , hence making the comapre with WO mask (Reason: Sim failed with mismatch)
    compare_disable[`ETH_F_ALL_ptp_uim_tam_snapshot_OFFSET_REG] = 3; // SW Access - Return to Zero
    compare_disable[`ETH_F_ALL_ptp_rx_tam_adjust_OFFSET_REG] = 2; 
    compare_disable[`ETH_F_ALL_ptp_tx_tam_adjust_OFFSET_REG] = 2; 
    compare_disable[`ETH_F_ALL_ptp_ref_lane_OFFSET_REG] = 2; 
    //compare_disable[`ETH_F_ALL_ptp_hip_user_cfg_status_OFFSET_REG] = 2; 
    compare_disable[`ETH_F_ALL_ptp_rx_user_cfg_status_OFFSET_REG] = 2; 
    compare_disable[`ETH_F_ALL_ptp_dr_cfg_OFFSET_REG] = 2; 

    // 3. Performing random read write pattern by shuffling the registers.
    `uvm_info("eth_sip_reg_access_sequence", "Performing random read write Pattern...", UVM_LOW)
    `uvm_info("eth_sip_reg_access_sequence", "2:Write registers", UVM_NONE)
    sip_regs.shuffle();
    foreach(sip_regs[i]) 
    begin
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_write(sip_regs[i].get_address(),$urandom(),.byte_enable(byteenable));
    end
    `uvm_info("eth_sip_reg_access_sequence", "3:Read registers", UVM_NONE)
    compare_disable_sip_regs();
    sip_regs.shuffle();
    foreach(sip_regs[i]) 
    begin
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_read(sip_regs[i].get_address(),read_data,compare_disable[sip_regs[i].get_address()],.byte_enable(byteenable));
    end

    // 4. Performing All 1's pattern
    sip_regs.shuffle();
    compare_disable_sip_regs();
    `uvm_info("eth_sip_reg_access_sequence", "Performing All 1s Pattern...", UVM_LOW)
    foreach(sip_regs[i]) begin
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_write(sip_regs[i].get_address(),'hFFFF_FFFF,.byte_enable(byteenable));
      p_sequencer.env.reg_read(sip_regs[i].get_address(),read_data,compare_disable[sip_regs[i].get_address()],.byte_enable(byteenable));
    end
    
    // 5. Performing All 0's pattern
    `uvm_info("eth_sip_reg_access_sequence", "Performing All 0s Pattern...", UVM_LOW)
    sip_regs.shuffle();
    compare_disable_sip_regs();
    foreach(sip_regs[i]) begin
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_write(sip_regs[i].get_address(),'h0000_0000,.byte_enable(byteenable));
      p_sequencer.env.reg_read(sip_regs[i].get_address(),read_data,compare_disable[sip_regs[i].get_address()],.byte_enable(byteenable));
    end
    
    // 6. Performing 'h5555_5555 pattern
    `uvm_info("eth_sip_reg_access_sequence", "Performing 'h5555_5555 Pattern...", UVM_LOW)
    sip_regs.shuffle();
    compare_disable_sip_regs();
    foreach(sip_regs[i]) begin 
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_write(sip_regs[i].get_address(),'h5555_5555,.byte_enable(byteenable));
      p_sequencer.env.reg_read(sip_regs[i].get_address(),read_data,compare_disable[sip_regs[i].get_address()],.byte_enable(byteenable));
    end

    // 7. Performing 'hAAAA_AAAA pattern
    sip_regs.shuffle();
    compare_disable_sip_regs();
    `uvm_info("eth_sip_reg_access_sequence", "Performing 'hAAAA_AAAA Pattern...", UVM_LOW)
    foreach(sip_regs[i]) begin 
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_write(sip_regs[i].get_address(),'hAAAA_AAAA,.byte_enable(byteenable));
      p_sequencer.env.reg_read(sip_regs[i].get_address(),read_data,compare_disable[sip_regs[i].get_address()],.byte_enable(byteenable));
    end
    
    //drajasek-banking reserved spaces
    rsvd_start_addr = 'h0150;
    rsvd_end_addr = 'h07FC;

    `uvm_info("eth_sip_reg_access_sequence",$sformatf(" Reserved start = %0h end = %0h",rsvd_start_addr,rsvd_end_addr), UVM_NONE)
    `uvm_info("eth_sip_reg_access_sequence", "Collecting space for read write Pattern on reserved space ", UVM_LOW)
    addr=$urandom_range(rsvd_start_addr,rsvd_end_addr);
    addr = {addr[31:2],2'b0};
    `uvm_info(get_type_name(),$sformatf("reserved address collected %0h",addr),UVM_MEDIUM);
    
    if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
       rsvd_temp_regs.push_back(addr);
     
    foreach(rsvd_temp_regs[i]) begin
       p_sequencer.env.reg_write(rsvd_temp_regs[i],$urandom());
       p_sequencer.env.reg_read(rsvd_temp_regs[i],read_data);
    end


//Accessing AIB address space - 10 random addresses
  for(int i=0; i<10;i++)begin
    //aib_addr = $urandom_range(0,252);  // AIB address range (0x0000 - 0x00FC)
    // GDR :aib registers are not available in Ral model, if we randomize, it affects our assertions, need to check only with fixed addresses.
    std::randomize(aib_addr) with{aib_addr inside {'h38,'h70,'h4,'hd8,'h28,'hc0,'he8,'h84,'h44};};
    aib_addr[1:0] = 2'b00;
   
    `uvm_info("AIB_ADDRESS",$sformatf("Iteration no=%0d AIB address = %0h",i,aib_addr),UVM_MEDIUM)
  `uvm_info("AIB_WRITE", $sformatf("Writing to AIB address %0h",aib_addr), UVM_MEDIUM)
    p_sequencer.env.reg_write(aib_addr,$urandom());
  `uvm_info("AIB_READ", $sformatf("Reading from AIB address %0h",aib_addr), UVM_MEDIUM)
    p_sequencer.env.reg_read(aib_addr,read_data,1,'hf);
  `uvm_info("AIB_READ", $sformatf("Read data of aib address  = %0h",read_data), UVM_MEDIUM)
  end

    `uvm_info(get_type_name(), "finished eth_sip_reg_access_sequence ...", UVM_NONE)

  endtask


endclass

