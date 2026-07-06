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


// sequence_name : eth_hip_reg_access_sequence
// Owner : Abhishek Tiwari (atiwari2)
// 1. Setup and prints
// atiwari2 - deleting non HIP registers for testing integrity
// 2. Read the reset value of registers
// 2. Performing random read write pattern by shuffling the registers.
// 3. Performing write-check random pattern to reserved spaces

class eth_hip_reg_access_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	 regs[$];
  uvm_reg 	 temp_regs[$];
  uvm_reg 	 hip_regs[$];
  int        resv_regs[$];
  bit [1:0] compare_disable[integer];
  bit [31:0] max_addr_pcs_stats;  
  bit [31:0] min_addr_pcs_stats;
  bit [31:0] min_addr_mac_config;  
  bit [31:0] max_addr_mac_config;  
  bit [31:0] min_addr_mac_stats;
  bit [31:0] max_addr_mac_stats;
  bit [31:0] max_addr_fec;  
  bit [31:0] min_addr_fec;
  bit [31:0] addr;
  uvm_reg_byte_en_t byteenable;

  bit [31:0] temp_value;
  int end_addr;
  int start_addr;
  `uvm_object_utils(eth_hip_reg_access_sequence)

  function new(string name = "eth_hip_reg_access_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    
    `uvm_info(get_type_name(), "started eth_hip_reg_access_sequence ...", UVM_NONE)
    
    // Disabling functional register coverage.
    p_sequencer.env.reg_cov.dis_reg_cov=1; 
    
    // Collecting the register bank which needs to be accessed.
    collect_gdr_register_bank(regs);
   
    // Disabling scoreboard as garbage data comes from DUT resulting to packet count mismatch and also this is no traffic sequence.
    p_sequencer.env.dynamic_enable_disable_scoreboards(1); 

    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.ts_tasks_if.set_enable_a_byteenable_legal(0);
      p_sequencer.env.disable_all_snps_errors();  
    `endif
    
    // atiwari2 - Collecting registers for testing integrity of HIP & AIB reg
     // EHIP Registers
    start_addr = 'h1000;
    //end_addr   = 'h9FFC;
    //To reduce simulation time, limitting access to only ehip registers HSD:16012691299
    end_addr = 'h5FFC;
    temp_regs = regs.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
    hip_regs = {hip_regs,temp_regs};
    // AIB regiseter
    start_addr = 'h0000;
    end_addr   = 'h00FC;
    temp_regs = regs.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
    hip_regs = {hip_regs,temp_regs};

    // atiwari2 -For resetting TX & RX Statistics Regs and counters
    `ifdef ETH_MULTI_PORT
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
    begin 
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
    end
    `else
    //TODO LL10G    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
    //TODO LL10G    begin 
    //TODO LL10G      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
    //TODO LL10G      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
    //TODO LL10G    end
    `endif

    foreach(hip_regs[i]) begin
      `uvm_info("eth_hip_reg_access_sequence", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",hip_regs[i].get_address(),hip_regs[i].get_name(),compare_disable[hip_regs[i].get_address()]), UVM_NONE)
    end

    
    // atiwari2 - generate radnom value - 
    // 0 - read reset reg followed by write to HIP register, 
    // 1 - write random values to register and read the values,
    
    temp_value = $urandom_range(0,1);

    if (temp_value == 'h0) // 0 - read reset reg followed by write to HIP register,
    begin 
      // 2. Read the reset value of registers
      `uvm_info("eth_hip_reg_access_sequence", " 1: Read reset value of registers", UVM_NONE)
      foreach(hip_regs[i]) begin    // HSD :16011825852
      if(hip_regs[i].get_address() inside {['h1200:'h1ffc],['h2200:'h2ffc],['h3200:'h3ffc],['h4200:'h4ffc],['h5200:'h5ffc]}) 
          compare_disable[hip_regs[i].get_address()] = 2;
      else
          compare_disable[hip_regs[i].get_address()] = 1;
      end
      // HSD: 16011825852: Added this after disscusion with ken.
      `ifdef ETH_MULTI_PORT
      compare_disable[`GET_REG_ADDR(mac_cfg_tx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(mac_cfg_rx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(mac_cfg_rx_pkt_n_ts_rx_ctr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //#HSD:16012691299
      compare_disable[`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(ehip_cfg_tx_fifo_ptr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(ehip_cfg_dprio_control_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //not looking ptp registers so comparedisable
      compare_disable[`ETH_F_ALL_ptp_uim_tam_snapshot_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_rx_tam_adjust_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_tx_tam_adjust_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_ref_lane_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_rx_user_cfg_status_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_dr_cfg_OFFSET_REG] = 1; 
    `else
      //TODO LL10G   compare_disable[`GET_REG_ADDR(mac_cfg_tx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G   compare_disable[`GET_REG_ADDR(mac_cfg_rx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G   compare_disable[`GET_REG_ADDR(mac_cfg_rx_pkt_n_ts_rx_ctr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G   //#HSD:16012691299
      //TODO LL10G   compare_disable[`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G   compare_disable[`GET_REG_ADDR(ehip_cfg_tx_fifo_ptr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G   compare_disable[`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G   compare_disable[`GET_REG_ADDR(ehip_cfg_dprio_control_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G   //not looking ptp registers so comparedisable
      //TODO LL10G compare_disable[`ETH_F_ALL_ptp_uim_tam_snapshot_OFFSET_REG] = 1; 
      //TODO LL10G compare_disable[`ETH_F_ALL_ptp_rx_tam_adjust_OFFSET_REG] = 1; 
      //TODO LL10G compare_disable[`ETH_F_ALL_ptp_tx_tam_adjust_OFFSET_REG] = 1; 
      //TODO LL10G compare_disable[`ETH_F_ALL_ptp_ref_lane_OFFSET_REG] = 1; 
      //TODO LL10G compare_disable[`ETH_F_ALL_ptp_rx_user_cfg_status_OFFSET_REG] = 1; 
      //TODO LL10G compare_disable[`ETH_F_ALL_ptp_dr_cfg_OFFSET_REG] = 1; 
    `endif

      foreach(hip_regs[i]) 
      begin
	std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
        p_sequencer.env.reg_read(hip_regs[i].get_address(),read_data,compare_disable[hip_regs[i].get_address()],.byte_enable(byteenable));
      end

      //atiwari2
      // Deleting the registers which effect other registers to fail after
      // default read.
      `ifdef ETH_MULTI_PORT
      `include "eth_reg_del_failing_TOG.sv"
      `else
      //TODO LL10G `include "eth_reg_del_failing_TOG.sv"
      `endif
      
      // Here compare_disable is selected to be 3, so that all WO & RO registers are masked at the time of comparison.
        foreach(regs[i]) begin
            compare_disable[regs[i].get_address()] = 3;
        end
      //ignoring comparison for stats register parameter set by rbc -- Ken
      `ifdef ETH_MULTI_PORT
      compare_disable[`GET_REG_ADDR(ehip_stats_txpldfifo_stat_inten_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //ignoring comparison for W1C registers  
      `include "eth_reg_disable_chk_W1C.sv"
      `else
      //TODO LL10G   compare_disable[`GET_REG_ADDR(ehip_stats_txpldfifo_stat_inten_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //ignoring comparison for W1C registers  
      //TODO LL10G  `include "eth_reg_disable_chk_W1C.sv"
      `endif

      // 3. Performing random  write pattern by shuffling the registers.
      `uvm_info("eth_hip_reg_access_sequence", "Performing random read write Pattern...", UVM_LOW)
      `uvm_info("eth_hip_reg_access_sequence", "2:Write registers", UVM_NONE)
      hip_regs.shuffle();
      foreach(hip_regs[i]) 
      begin
	std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
        p_sequencer.env.reg_write(hip_regs[i].get_address(),$urandom(),.byte_enable(byteenable));
      end
  
   end // if begin
  else    // 1 - write random values to register and read the values,
   begin 

      //atiwari2
      // Deleting the registers which affect other registers to fail.
      `ifdef ETH_MULTI_PORT
      `include "eth_reg_del_failing_TOG.sv"
      `else
      //TODO LL10G `include "eth_reg_del_failing_TOG.sv"
      `endif

     
      // Here compare_disable is selected to be 3, so that all WO & RO registers are masked at the time of comparison.
        foreach(regs[i]) begin
            compare_disable[regs[i].get_address()] = 3;
        end
      //ignoring comparison for stats register parameter set by rbc -- Ken
      `ifdef ETH_MULTI_PORT
      compare_disable[`GET_REG_ADDR(ehip_stats_txpldfifo_stat_inten_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(mac_cfg_tx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(mac_cfg_rx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //#HSD:16012691299
      compare_disable[`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(ehip_cfg_tx_fifo_ptr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      compare_disable[`GET_REG_ADDR(ehip_cfg_dprio_control_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
      //not looking into ptp registers
      compare_disable[`ETH_F_ALL_ptp_uim_tam_snapshot_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_rx_tam_adjust_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_tx_tam_adjust_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_ref_lane_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_rx_user_cfg_status_OFFSET_REG] = 1; 
      compare_disable[`ETH_F_ALL_ptp_dr_cfg_OFFSET_REG] = 1;   
      //ignoring comparison for W1C registers 
      `include "eth_reg_disable_chk_W1C.sv"
      `else
      //TODO LL10G      compare_disable[`GET_REG_ADDR(ehip_stats_txpldfifo_stat_inten_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G      compare_disable[`GET_REG_ADDR(mac_cfg_tx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G      compare_disable[`GET_REG_ADDR(mac_cfg_rx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G      //#HSD:16012691299
      //TODO LL10G      compare_disable[`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G      compare_disable[`GET_REG_ADDR(ehip_cfg_tx_fifo_ptr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G      compare_disable[`GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
      //TODO LL10G      compare_disable[`GET_REG_ADDR(ehip_cfg_dprio_control_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
      //TODO LL10G    //not looking into ptp registers
      //TODO LL10G    compare_disable[`ETH_F_ALL_ptp_uim_tam_snapshot_OFFSET_REG] = 1; 
      //TODO LL10G    compare_disable[`ETH_F_ALL_ptp_rx_tam_adjust_OFFSET_REG] = 1; 
      //TODO LL10G    compare_disable[`ETH_F_ALL_ptp_tx_tam_adjust_OFFSET_REG] = 1; 
      //TODO LL10G    compare_disable[`ETH_F_ALL_ptp_ref_lane_OFFSET_REG] = 1; 
      //TODO LL10G    compare_disable[`ETH_F_ALL_ptp_rx_user_cfg_status_OFFSET_REG] = 1; 
      //TODO LL10G    compare_disable[`ETH_F_ALL_ptp_dr_cfg_OFFSET_REG] = 1;   
      //TODO LL10G      //ignoring comparison for W1C registers 
      //TODO LL10G     `include "eth_reg_disable_chk_W1C.sv"
      `endif

    // 2. Performing random read write pattern by shuffling the registers.
    `uvm_info("eth_hip_reg_access_sequence", "Performing random read write Pattern...", UVM_LOW)
    `uvm_info("eth_hip_reg_access_sequence", "2:Write registers", UVM_NONE)
    hip_regs.shuffle();
    foreach(hip_regs[i]) 
    begin
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_write(hip_regs[i].get_address(),$urandom(),.byte_enable(byteenable));
      p_sequencer.env.reg_read(hip_regs[i].get_address(),read_data,compare_disable[hip_regs[i].get_address()],.byte_enable(byteenable));
    end
  
    // 3. Performing  read pattern by shuffling the registers.
    /*`uvm_info("eth_hip_reg_access_sequence", "3:Read registers", UVM_NONE)
    hip_regs.shuffle();
    foreach(hip_regs[i]) 
    begin
      std::randomize(byteenable) with{byteenable inside {'hf,'h1,'h2,'h3,'h4,'h6,'h7,'h8,'hc,'he};};
      p_sequencer.env.reg_read(hip_regs[i].get_address(),read_data,compare_disable[hip_regs[i].get_address()],.byte_enable(byteenable));
    end */
   end // else en 

    // 4. Performing write-check random pattern on reserved spaces
     case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
 _25G,_10G : begin min_addr_pcs_stats = 'h11D4; max_addr_pcs_stats = 'h11FC; min_addr_mac_config = 'h13FC; max_addr_mac_config = 'h17FC; min_addr_mac_stats = 'h1C7C; max_addr_mac_stats = 'h1FFC; min_addr_fec = 'h61E4; max_addr_fec = 'h61F8;
             end  
      _50G : begin min_addr_pcs_stats = 'h21D4; max_addr_pcs_stats = 'h21FC; min_addr_mac_config = 'h23FC; max_addr_mac_config = 'h27FC; min_addr_mac_stats = 'h2C7C; max_addr_mac_stats = 'h2FFC; min_addr_fec = 'h62E4; max_addr_fec = 'h62F8;
             end  
 _40G,_100G :begin min_addr_pcs_stats = 'h31D4; max_addr_pcs_stats = 'h31FC; min_addr_mac_config = 'h33FC; max_addr_mac_config = 'h37FC; min_addr_mac_stats = 'h3C7C; max_addr_mac_stats = 'h3FFC; min_addr_fec = 'h66E4; max_addr_fec = 'h66F8;        
             end  
      _200G :begin min_addr_pcs_stats = 'h41D4; max_addr_pcs_stats = 'h41FC; min_addr_mac_config = 'h43FC; max_addr_mac_config = 'h47FC; min_addr_mac_stats = 'h4C7C; max_addr_mac_stats = 'h4FFC; min_addr_fec = 'h6EE4; max_addr_fec = 'h6EF8;         
             end  
      _400G :begin min_addr_pcs_stats = 'h51D4; max_addr_pcs_stats = 'h51FC; min_addr_mac_config = 'h53FC; max_addr_mac_config = 'h57FC; min_addr_mac_stats = 'h5C7C; max_addr_mac_stats = 'h5FFC; min_addr_fec = 'h7EE4; max_addr_fec = 'h7EF8;         
             end  
     endcase
     
     `uvm_info("eth_hip_reg_access_sequence", "Collecting space for read write Pattern on PCS_STATS reserved space ", UVM_LOW)
       addr=$urandom_range(min_addr_pcs_stats,max_addr_pcs_stats);
       addr = {addr[31:2],2'b0};
       `uvm_info(get_type_name(),$sformatf("reserved address collected %0h",addr),UVM_MEDIUM);
       if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
        resv_regs.push_back(addr);


       if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {MACSEG,PCSMAC}) begin //Not accessing unimplemented register in other interfaces

       `uvm_info("eth_hip_reg_access_sequence", "Collecting space for read write Pattern on MAC_STATS reserved space ", UVM_LOW)
       addr=$urandom_range(min_addr_mac_stats,max_addr_mac_stats);
       addr = {addr[31:2],2'b0};
       `uvm_info(get_type_name(),$sformatf("reserved address collected %0h",addr),UVM_MEDIUM);
       if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
        resv_regs.push_back(addr);


      `uvm_info("eth_hip_reg_access_sequence", "Collecting space for read write Pattern on MAC_CONFIG reserved space ", UVM_LOW)
       addr=$urandom_range(min_addr_mac_config,max_addr_mac_config);
       addr = {addr[31:2],2'b0};
       `uvm_info(get_type_name(),$sformatf("reserved address collected %0h",addr),UVM_MEDIUM);
       if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
        resv_regs.push_back(addr);
      end

     `uvm_info("eth_hip_reg_access_sequence", "Collecting space for read write Pattern on FEC reserved space ", UVM_LOW)
     if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
         addr=$urandom_range(min_addr_fec,max_addr_fec);
         addr = {addr[31:2],2'b0};
       `uvm_info(get_type_name(),$sformatf("reserved address collected %0h",addr),UVM_MEDIUM);
         if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
          resv_regs.push_back(addr);
     end

    
     foreach(resv_regs[i]) begin
      p_sequencer.env.reg_write(resv_regs[i],$urandom());
      p_sequencer.env.reg_read(resv_regs[i],read_data);
     end

     //For coverage purpose
     `ifdef ETH_MULTI_PORT
     p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),$urandom()); 
     p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); 
     p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),$urandom()); 
     p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); 
     p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
     p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
     p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),$urandom()); 
     `else
     //TODO LL10G   p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),$urandom()); 
     //TODO LL10G   p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); 
     //TODO LL10G   p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),$urandom()); 
     //TODO LL10G   p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); 
     //TODO LL10G   p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
     //TODO LL10G   p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
     //TODO LL10G   p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),$urandom()); 
     `endif
    `uvm_info(get_type_name(), "finished eth_hip_reg_access_sequence ...", UVM_NONE)

  endtask
endclass


