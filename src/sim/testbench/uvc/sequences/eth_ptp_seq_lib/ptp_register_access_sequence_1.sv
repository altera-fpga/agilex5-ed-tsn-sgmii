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


class ptp_register_access_sequence_1 extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit compare_disable[integer];
  bit [31:0] max_address_1;
  bit [31:0] min_address_1;
  bit [31:0] max_address_2 = 'h081c;
  bit [31:0] min_address_2 = 'h0800; 
  int reg_index[$];

  `uvm_object_utils(ptp_register_access_sequence_1)

   function new(string name = "ptp_register_access_sequence_1");
      super.new(name);
      `ifdef UVM_POST_VERSION_1_1
         set_automatic_phase_objection(1);
      `endif
   endfunction:new

   virtual task body();
            
      p_sequencer.reg_model.default_map.get_registers(regs_org);
      
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G)begin
      
         max_address_1 = 'h13f8;
         min_address_1 = 'h12e0;
         
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) begin

         max_address_1 = 'h23f8;
         min_address_1 = 'h22e0;      
      
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
      
         max_address_1 = 'h33f8;
         min_address_1 = 'h32e0;           
      
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) begin
      
         max_address_1 = 'h43f8;
         min_address_1 = 'h42e0;           
      
      end else begin
      
         max_address_1 = 'h53f8;
         min_address_1 = 'h52e0;
      
      end
      
      `uvm_info(get_name(), $sformatf("ptp max_address_1 =%0h , ptp min_address_1 =%0h", max_address_1,min_address_1), UVM_MEDIUM)
      `uvm_info(get_name(), $sformatf("ptp max_address_2 =%0h , ptp min_address_2 =%0h", max_address_2,min_address_2), UVM_MEDIUM)

      foreach(regs_org[i]) 
      begin
         if((regs_org[i].get_address() >= min_address_1 && regs_org[i].get_address() <= max_address_1) || (regs_org[i].get_address() >= min_address_2 && regs_org[i].get_address() <= max_address_2))
         begin
            regs.push_back(regs_org[i]);
         end
      end

    //stumulur : deleting non-existent ral spaces [c02:c0e],'hb09 & deprecated registers. 
    foreach(regs[i])
    begin
// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR    	if(regs[i].get_address() inside {['hc02:'hc0e],'hb09,`REGISTERS_tx_ptp_dp_latency_OFFSET_REG,`REGISTERS_tx_aib_dp_latency_OFFSET_REG,`REGISTERS_rx_ptp_clk_period_OFFSET_REG,`REGISTERS_tx_ptp_clk_period_OFFSET_REG,`REGISTERS_rx_ptp_dp_latency_OFFSET_REG,`REGISTERS_rx_aib_dp_latency_OFFSET_REG})
	//	regs.delete(i);
    end 
 
    //stumulur disabling compare for certain register spaces like status registers c0F to c37 & c40 to c67 & reserved spaces
    foreach(regs[i])
    begin
// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR// FIXME-MISSING_REG_IN_GDR    	if(regs[i].get_address() inside {['hc0f:'hc37],['hc40:'hc67],`GET_REG_ADDR(mac_cfg_rx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),`GET_REG_ADDR(mac_cfg_tx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),`REGISTERS_txptp_name_0_OFFSET_REG,`REGISTERS_txptp_name_1_OFFSET_REG,`REGISTERS_txptp_name_2_OFFSET_REG,`REGISTERS_tx_ptp_clk_period_OFFSET_REG,`REGISTERS_tx_ptp_status_OFFSET_REG,`REGISTERS_rxptp_name_0_OFFSET_REG,`REGISTERS_rxptp_name_1_OFFSET_REG,`REGISTERS_rxptp_name_2_OFFSET_REG,`REGISTERS_rx_ptp_clk_period_OFFSET_REG})
	//	compare_disable[regs[i].get_address()]=1;
    end

    
      if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 )  
      begin 
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
      end

//    foreach(regs[i]) begin
//      `uvm_info("ptp_register_access_sequence_1", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
//    end
//    
//    `uvm_info("eth_register_access_sequence_1", "1:Read registers", UVM_NONE)
//    
//    foreach(regs[i]) 
//    begin
//      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
//    end

      //stumulur : c40 to c67 & extra latency registers are RW 
      //ptp_uim_tam_snapshot
      //tx_ptp_ui
      //rx_ptp_ui
      //rx_pkt_n_ts_rx_ctr
      foreach(regs[i])
      begin
         if((regs[i].get_address() inside {'h81c,
         `GET_REG_ADDR(mac_cfg_tx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),
         `GET_REG_ADDR(mac_cfg_rx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),
         `GET_REG_ADDR(mac_cfg_rx_pkt_n_ts_rx_ctr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)}))begin
            compare_disable[regs[i].get_address()]=1;
            `uvm_info("ptp_register_access_sequence_1", $sformatf("Disabling Register %s compare_disable",regs[i].get_name()), UVM_NONE)
         end
			
			//For firecode FEC, disable the rx ap filter as the reset value is determined by RBC
			if((regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rx_ptp_ap_filter_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == FCFEC))begin
            compare_disable[regs[i].get_address()]=1;
            `uvm_info("ptp_register_access_sequence_1", $sformatf("Disabling Register %s compare_disable",regs[i].get_name()), UVM_NONE)			
			end
			
      end
      
      `uvm_info("eth_register_access_sequence_1", "Performing Read registers after reset", UVM_LOW)
      foreach(regs[i]) 
      begin
         p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end      

      `uvm_info("eth_register_access_sequence_1", "Performing All 1s Pattern...", UVM_LOW)
      foreach(regs[i]) 
      begin
         p_sequencer.env.reg_write(regs[i].get_address(),'hFFFF_FFFF);
         p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end
      
      `uvm_info("eth_register_access_sequence_1", "Performing All 0s Pattern...", UVM_LOW)
      foreach(regs[i]) 
      begin
         p_sequencer.env.reg_write(regs[i].get_address(),'h00000000);
         p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end
      
      `uvm_info("eth_register_access_sequence_1", "Performing 'h5555_5555 Pattern...", UVM_LOW)
      foreach(regs[i]) begin 
         p_sequencer.env.reg_write(regs[i].get_address(),'h5555_5555);
         p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end       

      `uvm_info("eth_register_access_sequence_1", "Performing 'h3333_3333 Pattern...", UVM_LOW)
      foreach(regs[i]) begin 
         p_sequencer.env.reg_write(regs[i].get_address(),'h3333_3333);
         p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end 
      
      `uvm_info("eth_register_access_sequence_1", "Performing 'hCCCC_CCCC Pattern...", UVM_LOW)
      foreach(regs[i]) begin 
         p_sequencer.env.reg_write(regs[i].get_address(),'hCCCC_CCCC);
         p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
      end 

   endtask 
endclass
