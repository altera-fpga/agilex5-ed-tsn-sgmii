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


class an_10_25g_reconfig_skiplt_sequence extends an_base_sequence;
   `uvm_object_utils(an_10_25g_reconfig_skiplt_sequence)
   function new(string name = "an_10_25g_reconfig_skiplt_sequence");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new
   
   
   virtual task body();
      string func_name = "an_10_25g_reconfig_skiplt_sequence_body";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
	  //`ifdef G25 vinoth2x
          if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
	   p_sequencer.env.mac_callback.link_trans.an73_technology_ability_field_user='h04;
	  // `elsif G10
	  // p_sequencer.env.mac_callback.link_trans.an73_technology_ability_field_user='h200;
	  // p_sequencer.env.reconfig_vip_for_consortium_mode();
          end
	   //`endif vinoth2x

	   
	 `ifdef CRETE3
	  p_sequencer.env.mac_callback.link_trans.an73_break_link_timer = 2750000;
	  p_sequencer.env.mac_callback.link_trans.an73_transmit_nonce_field=$urandom_range(0,31);	  
	  p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
	 `endif
      
`ifdef ENABLE_ETH_VIP
      fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
`endif

	#1us;

      // Reset VIP
      p_sequencer.env.reset_vip();
      // ANLT restarts + wait for PCS + send frames
      p_sequencer.env.reconfig_vip_for_an_mode();
	  //`ifdef G25 vinoth2x
          if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
	  p_sequencer.env.mac_callback.link_trans.an73_technology_ability_field_user='h200;
	   p_sequencer.env.reconfig_vip_for_consortium_mode();
	  //`elsif G10
	  //p_sequencer.env.mac_callback.link_trans.an73_technology_ability_field_user='h04;
          end
	  //`endif vinoth2x
	  
	  p_sequencer.env.mac_callback.link_trans.an73_break_link_timer = 2750000;
	  p_sequencer.env.mac_callback.link_trans.an73_transmit_nonce_field=$urandom_range(0,31);	    
	  
      #5us;
      // Wait link up
      fork : wait_link_up
	 begin
	    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
	    disable wait_link_up;
	 end
	 begin
  `ifdef CRETE3
	       #2ms;
  `else
	       #500us;
  `endif
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for link up",func_name));
	    disable wait_link_up;
	 end
      join
      fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
	  
	#1us;

      // Reset VIP
      p_sequencer.env.reset_vip();
      // ANLT restarts + wait for PCS + send frames
      p_sequencer.env.reconfig_vip_for_an_mode();
	  //`ifdef G25 vinoth2x
          if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
	  p_sequencer.env.mac_callback.link_trans.an73_technology_ability_field_user='h204;
	   p_sequencer.env.reconfig_vip_for_consortium_mode();
	  //`elsif G10
	 // p_sequencer.env.mac_callback.link_trans.an73_technology_ability_field_user='h204;
          end
	  //`endif vinoth2x
	  
	  p_sequencer.env.mac_callback.link_trans.an73_break_link_timer = 2750000;
	  p_sequencer.env.mac_callback.link_trans.an73_transmit_nonce_field=$urandom_range(0,31);	  
	  
      #5us;
      // Wait link up
      fork : wait_link_up2
	 begin
	    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
	    disable wait_link_up2;
	 end
	 begin
  `ifdef CRETE3
	       #2ms;
  `else
	       #500us;
  `endif
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for link up",func_name));
	    disable wait_link_up2;
	 end
      join
      fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join

      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
  endtask
endclass
