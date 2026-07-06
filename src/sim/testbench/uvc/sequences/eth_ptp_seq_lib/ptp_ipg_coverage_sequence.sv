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


class ptp_ipg_coverage_sequence extends eth_ptp_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
uvm_reg_data_t rd_data;
     uvm_reg_data_t txmac_ehip_cfg;
int sel;
bit [31:0] write_data;
bit [1:0] ipg_val;

 //bit[31:0] mac_cfg_data;

//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(ptp_ipg_coverage_sequence)
  function new(string name = "ptp_ipg_coverage_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();

    super.body();
    //write_ptp_reg;
    `uvm_info("eth_seq_lib", "running ptp ipg coverage sequence\n",UVM_LOW)
   rx_crc_pass=$urandom;
	 repeat(4) begin
	
	$display ("[ipgmanoj info] sel = %0d", sel);
 	if (sel == 0 ) begin
   		ipg_val = 2'b00;
	end else if (sel == 1) begin
 		ipg_val = 2'b01;
	end else if (sel == 2) begin
 		ipg_val = 2'b10;
	end else if (sel == 3) begin
 		ipg_val = 2'b11;
	end 
$display ("lets change ipg value");
 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
     // p_sequencer.env.reg_read(`GET_REG_ADDR(txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h9EE41B);  
     //mac_cfg_data = rd_data;
       `uvm_info("ptp_ipg_coverage_sequence", $sformatf("Setting %0h to mac_cfg data",rd_data), UVM_MEDIUM)

rd_data[2:1] = ipg_val;
write_data = rd_data;

`uvm_info("ptp_ipg_coverage_sequence", $sformatf("now the write data is %0h",write_data), UVM_MEDIUM)
p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),write_data);

 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
`uvm_info("ptp_ipg_coverage_sequence", $sformatf("Setting %0h to mac_cfg data second time",rd_data), UVM_MEDIUM)

 
   fork
   begin
      send_ptp_frame(INS_V2,DATA_FRAME,1);  
      send_ptp_frame(INS_V2_W_UDP_CS_0,DATA_FRAME,1);  
      send_ptp_frame(INS_V2_W_EB,DATA_FRAME,1);  
      send_ptp_frame(INS_CF,DATA_FRAME,1);  
      send_ptp_frame(INS_CF_W_UDP_CS_0,DATA_FRAME,1);  
      send_ptp_frame(INS_CF_W_EB,DATA_FRAME,1);  
      
      send_ptp_frame(INS_V2,VLAN_FRAME,1);  
      send_ptp_frame(INS_V2_W_UDP_CS_0,VLAN_FRAME,1);  
      send_ptp_frame(INS_V2_W_EB,VLAN_FRAME,1);  
      send_ptp_frame(INS_CF,VLAN_FRAME,1);  
      send_ptp_frame(INS_CF_W_UDP_CS_0,VLAN_FRAME,1);  
      send_ptp_frame(INS_CF_W_EB,VLAN_FRAME,1);
      
      send_ptp_frame(INS_2STEP,VLAN_FRAME,1);
   end
   begin
     `ifdef ENABLE_ETH_VIP
      send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,30);  
     `endif
   end
   join   

	 sel = sel +1;
  end//repeat
  endtask
endclass

