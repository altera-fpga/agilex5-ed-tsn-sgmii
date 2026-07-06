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


// sequence_name :eth_register_timeout
// 1. Apply IP reset (maintained by testcase) 
// 2. Disabled the clock for MAC and Lphy
// 3. Performing write-check random pattern to reserved spaces

class eth_register_timeout_seq extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	   regs[$];
  int resv_regs[$];
  int resv_stat_regs[$];
  bit [1:0] compare_disable[integer];
  bit [31:0] max_addr_r1, max_addr_r2;  
  bit [31:0] min_addr_r1, min_addr_r2;
  bit [31:0] max_addr_fec_r1, max_addr_fec_r2;  
  bit [31:0] min_addr_fec_r1, min_addr_fec_r2;
  int addr;
  rand int k;

  `uvm_object_utils(eth_register_timeout_seq)

  function new(string name = "eth_register_timeout_seq");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    
    `uvm_info(get_type_name(), "started eth_register_timeout_seq ...", UVM_NONE)
    
    // Disabling functional register coverage.
    p_sequencer.env.reg_cov.dis_reg_cov=1;

    p_sequencer.env.dyn_rcfg_obj_inst.print();

    // Collecting the register bank which needs to be accessed.
    collect_gdr_register_bank(regs);
    enable_disable_anlt_reset();
    // Disabling scoreboard as garbage data comes from DUT resulting to packet count mismatch and also this is no traffic sequence.
    p_sequencer.env.dynamic_enable_disable_scoreboards(1); 

    
    // Deleting the registers which affect other registers to fail. 
    foreach(regs[i]) begin
    if(regs[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG)
      regs.delete(i);
    end

    foreach(regs[i]) begin
    if(regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))
      regs.delete(i);
    end

    foreach(regs[i]) begin
    if(regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))  
      regs.delete(i);
    end

    foreach(regs[i]) begin      //HSD:22010569085
    if(regs[i].get_address() == (`GET_REG_ADDR(ehip_cfg_rx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))  
      regs.delete(i);
    end

    // Here compare_disable is selected to be 3, so that all WO & RO registers are masked at the time of comparison.
    foreach(regs[i]) begin
        compare_disable[regs[i].get_address()] = 3;
    end
    //ignoring comparison for W1C registers and stats register expected Value  
    compare_disable[`GET_REG_ADDR(fec_e25g_s0_xcvrif_stat_hold_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    compare_disable[`GET_REG_ADDR(fec_e25g_s0_xcvrif_stat_hold_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    compare_disable[`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_aggr_rx_hold_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    compare_disable[`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_lane_rx_hold_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    compare_disable[`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_lane_tx_hold_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
    compare_disable[`GET_REG_ADDR(ehip_stats_txpldfifo_stat_inten_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 

    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.disable_all_snps_errors();  
    `endif
    
    // dsamantx : Don't know why it is kept here, please check.
    if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
    begin 
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
      p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3);
    end

    foreach(regs[i]) begin
      `uvm_info("eth_register_timeout_seq", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end
    
    // 2. Disabled the clock for MAC and Lphy
    `uvm_info("eth_register_timeout_seq", "Disabled the clock for MAC and Lphy...", UVM_LOW)
      p_sequencer.env.reg_write((`GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h11);
     //TBD Venkatkx need to check FEC Clock Gating registers and update 
      p_sequencer.env.reg_write((`GET_REG_ADDR(fec_e25g_s0_lphy_reg_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'hffff);
      p_sequencer.env.reg_write((`GET_REG_ADDR(fec_e25g_s0_lphy_reg_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),'h3ffff);
   

    // 3. Performing Read on MAC and FEC Stat register when clock is disabled 
    // TBD Venkatkx need to update for all the speeds
    `uvm_info("eth_register_timeout_seq", "Performing Read on MAC and FEC Stat register when clock is disabled... ", UVM_LOW)
      p_sequencer.env.reg_read((`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_lane_rx_stat_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data,2'b01);
      p_sequencer.env.reg_read((`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),read_data,2'b01);


 
    // 4. Performing write-check random pattern on reserved spaces
    // TBD Venkatkx need to update for all the speeds
     `uvm_info("eth_register_timeout_seq", "Performing read write Pattern on reserved space... ", UVM_LOW)
     case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
      _25G : begin 
               min_addr_r1 = 'h2000; max_addr_r1 = 'h5FFC; min_addr_fec_r1 = 'h6200; max_addr_fec_r1 = 'h9DFC; 
               min_addr_r2 = 'h2000; max_addr_r2 = 'h5FFC; min_addr_fec_r2 = 'h6200; max_addr_fec_r2 = 'h9DFC; 
             end                                       
      _50G : begin 
               min_addr_r1 = 'h1000; max_addr_r1 = 'h1FFC; min_addr_fec_r1 = 'h6000; max_addr_fec_r1 = 'h61FC; 
               min_addr_r2 = 'h3000; max_addr_r2 = 'h5FFC; min_addr_fec_r2 = 'h6600; max_addr_fec_r2 = 'h9DFC; 
             end                                       
      _100G,_40G:begin 
               min_addr_r1 = 'h1000; max_addr_r1 = 'h2FFC; min_addr_fec_r1 = 'h6000; max_addr_fec_r1 = 'h65FC; 
               min_addr_r2 = 'h4000; max_addr_r2 = 'h5FFC; min_addr_fec_r2 = 'h6E00; max_addr_fec_r2 = 'h9DFC; 
             end                                       
      _200G :begin 
               min_addr_r1 = 'h1000; max_addr_r1 = 'h3FFC; min_addr_fec_r1 = 'h6000; max_addr_fec_r1 = 'h6DFC; 
               min_addr_r2 = 'h5000; max_addr_r2 = 'h5FFC; min_addr_fec_r2 = 'h7E00; max_addr_fec_r2 = 'h9DFC; 
             end                                       
      _400G :begin 
               min_addr_r1 = 'h1000; max_addr_r1 = 'h4FFC; min_addr_fec_r1 = 'h6000; max_addr_fec_r1 = 'h7DFC; 
               min_addr_r2 = 'h1000; max_addr_r2 = 'h4FFC; min_addr_fec_r2 = 'h6000; max_addr_fec_r2 = 'h7DFC; 
             end  
     endcase
     while(resv_regs.size()!=1) begin
       addr=$urandom_range(min_addr_r1,max_addr_r1); //Reserved space access
       addr = {addr[31:2],2'b0};
       if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
        resv_regs.push_back(addr);
     end
     while(resv_regs.size()!=2) begin
       addr=$urandom_range(min_addr_r2,max_addr_r2); //Reserved space access
       addr = {addr[31:2],2'b0};
       if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
        resv_regs.push_back(addr);
     end
     while(resv_regs.size()!=3) begin
       addr=$urandom_range(min_addr_fec_r1,max_addr_fec_r1); //FEC reserved space access
       addr = {addr[31:2],2'b0};
       if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
        resv_regs.push_back(addr);
     end
     while(resv_regs.size()!=4) begin
       addr=$urandom_range(min_addr_fec_r2,max_addr_fec_r2); //FEC reserved space access
       addr = {addr[31:2],2'b0};
       if(p_sequencer.env.reg_model.default_map.get_reg_by_offset(addr)==null)
        resv_regs.push_back(addr);
     end
    
     foreach(resv_regs[i]) begin
      p_sequencer.env.reg_read(resv_regs[i],read_data);
     end
     
     foreach(resv_regs[i]) begin
      p_sequencer.env.reg_write(resv_regs[i],$urandom());
     //end
    
     //foreach(resv_regs[i]) begin
      p_sequencer.env.reg_read(resv_regs[i],read_data);
     end
    
    `uvm_info(get_type_name(), "finished eth_register_timeout_seq ...", UVM_NONE)
  endtask
endclass
