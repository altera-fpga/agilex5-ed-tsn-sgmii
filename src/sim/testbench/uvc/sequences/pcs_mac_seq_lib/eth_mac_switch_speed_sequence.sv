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


class  eth_mac_switch_speed_sequence extends eth_base_sequence;

 `uvm_object_utils(eth_mac_switch_speed_sequence)

 string array[$] = '{"_10G","_5G","_2p5G","_1G","_100M","_10M"};
 string mystring;
 int num_of_frames_new=0;
 
 function new(string name = "eth_mac_switch_speed_sequence");
 	super.new(name);
     `ifdef UVM_POST_VERSION_1_1
     	 set_automatic_phase_objection(1);
     `endif
     if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=10;
     end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
 endfunction:new

 virtual task body();
   bit [2:0] j;
   bit [31:0] data_read;
      
   `uvm_info("eth_seq_lib", "running  eth_mac_switch_speed_sequence \n",UVM_LOW);
	
    /*for(int k=0;k<array.size();k++)begin
		mystring=p_sequencer.env.dyn_rcfg_obj_inst.ll_speed.name;
		if( array[k] == mystring )begin
		$display("dm speed is %0s",mystring);
		$display("array speed_list[%0d]=%0s",k,array[k]);
		array.delete(k);
  		end 
	end*/
	array.shuffle();
	`uvm_info(get_name(),$sformatf("speed array values are : %0p",array),UVM_NONE);
	for(int i=0;i<array.size();i++)begin
	   $display("array[%0d]=%s",i,array[i]);
	   case(array[i])
	   "_10G" : j = 3'b011;
	   "_5G"  : j = 3'b101;
	   "_2p5G": j = 3'b100;
	   "_1G"  : j = 3'b010;
	   "_10M" : j = 3'b000;
	   "_100M": j = 3'b001;
	   endcase
	   `ifdef ETH_MULTI_PORT
   		p_sequencer.env.reg_read(`usxgmii_control_OFFSET_REG,data_read);
     	        data_read[4:2] =j ;
	 	p_sequencer.env.reg_write(`usxgmii_control_OFFSET_REG,data_read);
		`uvm_info("SWITCH_SEQUENCE", $sformatf("Register with address usxgmii_control ('h400) write data is  :'h%0h",data_read), UVM_NONE);
	        `uvm_info("SWITCH SEQUENCE", $sformatf("Configuring VIP with speed = %0s",array[i]),UVM_NONE);
  	        `ifdef ENABLE_ETH_VIP	
	 	p_sequencer.env.`MAC_CFG.usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,j,1'b1,1'b1,6'd0,1'b1};
 	        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.mac_cfg.cfg[0]);
               `endif
	   `else
	   //TODO LL10G   		p_sequencer.env.reg_read(`usxgmii_control_OFFSET_REG,data_read);
           //TODO LL10G     	        data_read[4:2] =j ;
           //TODO LL10G	 	p_sequencer.env.reg_write(`usxgmii_control_OFFSET_REG,data_read);
           //TODO LL10G		`uvm_info("SWITCH_SEQUENCE", $sformatf("Register with address usxgmii_control ('h400) write data is  :'h%0h",data_read), UVM_NONE);
           //TODO LL10G	    `uvm_info("SWITCH SEQUENCE", $sformatf("Configuring VIP with speed = %0s",array[i]),UVM_NONE);
           //TODO LL10G  	   `ifdef ENABLE_ETH_VIP	
           //TODO LL10G		p_sequencer.env.mac_cfg.cfg[0].usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,j,1'b1,1'b1,6'd0,1'b1};
           //TODO LL10G 	    p_sequencer.env.m_snps_eth_pcs66_agent.reconfigure_via_task(p_sequencer.env.mac_cfg.cfg[0]);
           //TODO LL10G            `endif
	   `endif
    	#10us;
      `ifdef ENABLE_ETH_VIP	
		fork
   		send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);
   		send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);
   		join
      `endif

   		num_of_frames_new = num_of_frames_new+num_of_frames;
     `ifdef ENABLE_ETH_VIP
   		p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames_new),.timeout_time(200us));
      `endif
   		p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames_new),.timeout_time(250us));
   		#1us;
   	end

 endtask
 endclass
