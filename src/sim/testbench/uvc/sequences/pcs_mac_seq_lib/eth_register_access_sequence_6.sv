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


// sequence_name : eth_register_access_sequence_6
// 1. Apply IP reset (maintained by testcase) 
// 2. Performing random read write pattern by shuffling the registers.
// 3. Performing write-check random pattern to reserved spaces
// 4. Performing read check and again random read write pattern by shuffling the registers.
// 5. Apply CSR reset & wait for pcs ready ->Please check whether it is supported or not in GDR
// 6. Read-check all the registers

class eth_register_access_sequence_6 extends eth_base_sequence;
  uvm_reg_data_t read_data;
  uvm_reg 	 regs[$];
  uvm_reg 	regs_pcs[$]; 
  uvm_reg 	regs_mac[$]; 
  bit[31:0]pcs_min_addr='h6000;
  bit[31:0]pcs_max_addr='h601f;
  bit[31:0]mac_min_addr='h0010;
  bit[31:0]mac_max_addr='h01fd;
  uvm_reg 	 hip_regs[$],org_regs[$],temp_regs[$];
  bit [1:0] compare_disable[integer];
  int end_addr;
  int start_addr;

  `uvm_object_utils(eth_register_access_sequence_6)

  function new(string name = "eth_register_access_sequence_6");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new
 
//1.Get RAL handle
//2.get registers into regs
//3.shuffle the registers
//4.write random data into registers
//5.apply reconfig reset
//6.read all registers
  
  virtual task body();
    
    `uvm_info(get_type_name(), "started eth_register_access_sequence_6 ...", UVM_NONE)
    // Disabling functional register coverage.
    p_sequencer.env.reg_cov.dis_reg_cov=1;
    p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
    p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
    p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
    p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;

    p_sequencer.reg_model.default_map.get_registers(regs);
    regs.shuffle();

   `uvm_info(get_type_name(),$sformatf("writing Random data into registers"), UVM_NONE) 
   foreach(regs[i]) begin
      if(regs[i].get_address() == (`GET_REG_ADDR(mac_reset_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))
        randcase 
          1 : p_sequencer.env.reg_write(regs[i].get_address(),32'h0101);
          1 : p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
        endcase
      else
          p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
   end
   

	foreach(regs[i])
	begin
		if(regs[i].get_address()>=pcs_min_addr && regs[i].get_address()<=pcs_max_addr)
		begin
			regs_pcs.push_back(regs[i]);
		end
	end

  foreach(regs[i])
  begin
     if(regs[i].get_address()>=mac_min_addr && regs[i].get_address()<=mac_max_addr && !(regs[i].get_address() inside {['h12:'h1D]} )&& !(regs[i].get_address() inside {['h60:'h6F]} )&& !(regs[i].get_address() inside {['h71:'h9F]} ))
	begin
       	regs_mac.push_back(regs[i]);
	end
  end
   

  randcase
    1:begin
   `uvm_info(get_type_name(),$sformatf("Entered regiters in parallel thred"), UVM_NONE) 
      fork
        begin
           foreach(regs_pcs[i]) begin
               p_sequencer.env.reg_write(regs_pcs[i].get_address(),$urandom());
           end
         end
        begin
           foreach(regs_mac[i]) begin
              if(regs_mac[i].get_address() == (`GET_REG_ADDR(mac_reset_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))
                randcase 
                  1 : p_sequencer.env.reg_write(regs_mac[i].get_address(),32'h0101);
                  1 : p_sequencer.env.reg_write(regs_mac[i].get_address(),$urandom());
                endcase
              else
                  p_sequencer.env.reg_write(regs_mac[i].get_address(),$urandom());
           end
         end
      join
      end
    1:begin
   `uvm_info(get_type_name(),$sformatf("Entered regiters in serial thred"), UVM_NONE) 
        foreach(regs[i]) begin
           if(regs[i].get_address() == (`GET_REG_ADDR(mac_reset_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)))
             randcase 
               1 : p_sequencer.env.reg_write(regs[i].get_address(),32'h0101);
               1 : p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
             endcase
           else
               p_sequencer.env.reg_write(regs[i].get_address(),$urandom());
        end
      end
       
  endcase

   // Wait cylces for reset assertion  
   #1us;
   
   `uvm_info(get_type_name(),$sformatf("Applying reset"), UVM_MEDIUM) 
   p_sequencer.env.apply_reset("hard",1);
   p_sequencer.env.apply_reconfig_reset ();
       

   fork 
     begin
       #100us;
       `uvm_error ("","Link is not up after applying soft reset")
     end
     begin
       `uvm_info(get_type_name(), $sformatf("waiting for Block lock to go high"), UVM_NONE)
       wait(p_sequencer.env.spy_if.rx_block_lock == 1'b1);
     end
   join_any

   `uvm_info(get_type_name(), $sformatf("Done waiting for Block lock to go high"), UVM_NONE)

    // Check if soft reset, resets the entire register space as well.
    foreach(regs[i]) begin
       regs[i].reset();
    end
   
    //with avmm_rst, by default an_enable will become 1, so link status will be always 0
    `ifdef ETH_MULTI_PORT
    compare_disable[`GET_REG_ADDR(usxgmii_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
    //updating default values for pcs regs
    csr_pcs_regs(1);
    `else
    //TODO LL10G compare_disable[`GET_REG_ADDR(usxgmii_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
    //csr_pcs_regs(1);
    `endif 
     p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("sgmii_status"),read_data,1);
     if(read_data[2]==1'b1) begin //sgmii_status bit 2 is LINK_STATUS bit and it should be high after linkup
     	p_sequencer.env.reg_model.sgmii_status.predict(.value(read_data[31:0]),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.env.reg_model.default_map));//Updating the RO register with mirrored value
     end
   `uvm_info(get_type_name(),$sformatf("Reading registers after applying reset"), UVM_NONE) 
   randcase
     1: begin
       `uvm_info(get_type_name(),$sformatf("Entered regiters in serial thred"), UVM_NONE) 
       foreach(regs[i]) begin
       p_sequencer.env.reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
       end
     end
     1: begin
       `uvm_info(get_type_name(),$sformatf("Entered regiters in parallel thred"), UVM_NONE) 
       fork
       begin
         foreach(regs_pcs[i]) begin
         p_sequencer.env.reg_read(regs_pcs[i].get_address(),read_data,compare_disable[regs_pcs[i].get_address()]);
         end
       end
       begin
         foreach(regs_mac[i]) begin
         p_sequencer.env.reg_read(regs_mac[i].get_address(),read_data,compare_disable[regs_mac[i].get_address()]);
         end
       end
       join
     end
  endcase

   `uvm_info(get_type_name(), "finished eth_register_access_sequence_6 ...", UVM_NONE)

  endtask
endclass
