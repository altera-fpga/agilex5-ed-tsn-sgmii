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


class an_reset_vip_during_np_sequence extends an_base_sequence;
   `uvm_object_utils(an_reset_vip_during_np_sequence)
     function new(string name = "an_reset_vip_during_np_sequence");
	super.new(name);
   `ifdef UVM_POST_VERSION_1_1
	set_automatic_phase_objection(1);
   `endif
     endfunction:new
   
   `ifdef UVM_VERSION_1_1
   virtual task pre_start();
      lt_on=1;
      super.pre_start();
   endtask; // pre_start
 `endif
   
   virtual task body();
   	bit [47:0] next_page;
	bit [31:0] c1_data;
	bit 	 np_bit;
	int 	 vip_np_num=0;
      string func_name = "an_reset_vip_during_np_sequence_body";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
      // Configure VIP to send a random number of next pages
      vip_np_num = $urandom_range(2,10);
       p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NEXT_PAGE_BIT,1);
       p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NMBR_NXT_PGE,vip_np_num);
	  `uvm_info(get_type_name(), $sformatf("%s: VIP will send %0d pages",func_name,vip_np_num), UVM_LOW);
	  randcase
	  1: begin // with DUTnp=1 
	  		 next_page = {$urandom(),$urandom()};
      		// Let first next page have a np_bit SET
		      np_bit = 1;
		      next_page[15] = np_bit;
		      if (np_bit) begin
				 c5_data[15:0] = next_page[15:0];
				 c6_data       = next_page[47:16];
				 c1_data[8] = 1'b1;
// FIXME-MISSING_REG_IN_GDR				 p_sequencer.env.reg_write(`REGISTERS_an_cfg5_OFFSET_REG,c5_data);
// FIXME-MISSING_REG_IN_GDR				 p_sequencer.env.reg_write(`REGISTERS_an_cfg6_OFFSET_REG,c6_data);
     		  end
     		  @ (p_sequencer.env.m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
      		  wait (p_sequencer.env.m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_NEXT_PAGE_WAIT);
      		 `uvm_info(get_type_name(), $sformatf("%s: VIP reached NP_WAIT first time",func_name), UVM_LOW);
     		 `ifdef CRETE3
      			fork: wait_an_page_rec
					 begin
					    wait (p_sequencer.env.spy_if.an_page_rec==1'b1);
					    disable wait_an_page_rec;
					 end // UNMATCHED !!
					 begin
					    #100us;
					    `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for C2.1 (an page received to assert)",func_name));
					 end
				join
			  `endif
		   // Give DUT time to reach ack_finished=true
		      repeat (2)
			@ (p_sequencer.env.m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_dme_page_received);
		      // Let DUT know that NP is loaded
// FIXME-MISSING_REG_IN_GDR		      p_sequencer.env.reg_write(`REGISTERS_an_cfg2_OFFSET_REG,c1_data);
			  
			  // Wait VIP ACK DETECT: If VIP is in ACK detect, then DUT has reached NP WAIT
			       @ (p_sequencer.env.m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
			       wait (p_sequencer.env.m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_ACKNOWLEDGE_DETECT);
	  	 end
	  	 1: begin //with DUT np=0; 
	  	    end

	  endcase

      fork 
	   begin
              p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
	   end // UNMATCHED !!
	   begin
	      wait(p_sequencer.env.m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_NEXT_PAGE_WAIT);
	      // Reset VIP
	      p_sequencer.env.svt_ethernet_txrx_inst.reset = 0;
	      #10;
	      p_sequencer.env.svt_ethernet_txrx_inst.reset = 1;
	      #10us;
	      p_sequencer.env.svt_ethernet_txrx_inst.reset = 0;
	      p_sequencer.env.reconfig_vip_for_an_mode();  
	   end
	join_any
      disable fork;
      p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
      
 `ifdef ENABLE_ETH_VIP
      fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
      join
 `endif
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)      
   endtask // body
endclass // an_reset_vip_during_np_sequence
