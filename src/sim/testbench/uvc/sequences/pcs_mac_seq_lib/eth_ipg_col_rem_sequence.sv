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


class eth_ipg_col_rem_sequence extends eth_base_sequence;
   rand int ipg_col_rem;
   bit preamble_pass;
   bit [1:0] tx_avg_ipg;
   uvm_reg_data_t rd_data;
   uvm_reg_data_t txmac_ehip_cfg;
   speed_e speed;
   
   `uvm_object_utils(eth_ipg_col_rem_sequence)
   
   function new(string name = "eth_ipg_col_rem_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
   endfunction:new

   //below code is not used till now
   constraint ipg_col_rem_c {
     (speed == _25G)  -> ipg_col_rem > 'd8; 
     (speed == _50G)  -> ipg_col_rem > 'd4; 
     (speed == _40G)  -> ipg_col_rem > 'd4; 
     (speed == _100G) -> ipg_col_rem > 'd20; 
     (speed == _200G) -> ipg_col_rem > 'd16; 
     (speed == _400G) -> ipg_col_rem > 'd32;
   }

   virtual task pre_body();
    p_sequencer.env.ipg_checker.ipg_check_enable = 1'b1;
    p_sequencer.env.ipg_checker.additional_ipg_enb = 1'b1;
   endtask

   virtual task body();
     `uvm_info("eth_ipg_col_rem_sequence", "Executing eth_ipg_col_rem_sequence ...", UVM_LOW)
     preamble_pass = 0;  //$urandom_range(1,0);
     tx_avg_ipg = 3;     //$urandom_range(3,0);
     ipg_col_rem='d400;  //$urandom_range(0,'d65535);

     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);

     //TX EHIP CFG
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
     if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_50G,_40G}) begin
        txmac_ehip_cfg = {rd_data[31:3],tx_avg_ipg,'h1};
        $display ("Default value for en_pp for Tx is always 1, irrespective of GUI parameter");
     end
     else begin
        txmac_ehip_cfg = {rd_data[31:3],tx_avg_ipg,preamble_pass};
        if(rd_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough)   `uvm_error("preamble_sequence", $sformatf("REGISTERS_txmac_ehip_cfg_OFFSET_REGbit 0 value must be initialized as per parameter"));
        p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough = preamble_pass;
        `uvm_info("eth_ipg_col_rem_sequence", $sformatf("Setting %0d to TX Preamble pass",preamble_pass), UVM_MEDIUM)
     end
     
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txmac_ehip_cfg); 
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),ipg_col_rem[15:0]);
     
     `uvm_info("eth_ipg_col_rem_sequence", $sformatf("Additional IPG per AM period =%0d",ipg_col_rem), UVM_LOW)
     send_eth_frame(IPG_STRESS,AVL_TX_ETH_VIP,500);
     `uvm_info("eth_ipg_col_rem_sequence", "Exiting eth_ipg_col_rem_sequence ...", UVM_LOW)
    
   endtask // body
   
endclass // eth_ipg_col_rem_sequence
