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





class eth_register_pcs_access_sequence extends eth_base_sequence;
uvm_reg_data_t read_data;
  uvm_reg 	regs_pcs[$],regs[$]; 
   bit compare_disable[integer];
   bit[31:0]min_addr='h400;
   bit[31:0]max_addr='h472;
   bit[31:0]write_data; 
	`uvm_object_utils(eth_register_pcs_access_sequence)
    function new(string name="eth_register_pcs_access_sequence");
	  super.new(name);
	    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif

	 endfunction


      virtual task body();   begin
    p_sequencer.reg_model.default_map.get_registers(regs_pcs);

	foreach(regs_pcs[i])
	begin
		if(regs_pcs[i].get_address()>=min_addr && regs_pcs[i].get_address()<=max_addr)
		begin
			regs.push_back(regs_pcs[i]);
		end
	end
        
       
    foreach(regs[i]) begin
      `uvm_info("eth_register_pcs_access_sequence", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
    end
    `uvm_info("eth_register_pcs_access_sequence", "Performing default_read...", UVM_LOW)
 foreach(regs[i]) 
    begin
      p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
    end

	for(int i =0 ; i < 4; i++) begin
       
		if(i ==0) write_data = 'hFFFF_FFFF; 		
       if(i ==1) write_data = 'h0000_0000; 		
       if(i ==2) write_data = 'hAAAA_AAAA; 		
       if(i ==3) write_data = 'h5555_5555; 		
      
       `uvm_info("eth_register_access_sequence", "Performing pcs write and read operations ...", UVM_LOW)
       `ifdef ETH_MULTI_PORT
       compare_disable[`GET_REG_ADDR(FRM_ERR_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;//Write in 'h461 is causing issue with frm_err register read data
       compare_disable[`GET_REG_ADDR(usxgmii_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;//Writing 'h1  into usxgmii_an('h400) bit the link fault is getting low
       `else
       //TODO LL10G       compare_disable[`GET_REG_ADDR(FRM_ERR_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;//Write in 'h461 is causing issue with frm_err register read data
       //TODO LL10G compare_disable[`GET_REG_ADDR(usxgmii_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;//Writing 'h1  into usxgmii_an('h400) bit the link fault is getting low
       `endif
//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
      // compare_disable[`GET_REG_ADDR(RX_PCS_FULLY_ALIGNED_S_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;//write in '461 register is causing issuein rx_pcs_fully aligned register read data
       foreach(regs[i]) 
       begin
         p_sequencer.env.reg_write(regs[i].get_address(),write_data);
         p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
       end
    end   

     
             
    end
endtask    
endclass


