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


class sweep_parameter_sequence extends eth_base_sequence;

  uvm_reg 	regs; 
  bit [1:0] exp_lf;
  bit [1:0] exp_ipg;
  int       exp_ipg_col_rem;
  bit       exp_pp;

  `uvm_object_utils(sweep_parameter_sequence)
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction:new

 virtual task body();
   super.body();
   `uvm_info("eth_seq_lib", "running sweep parameter sequence\n",UVM_LOW)
   
   //FIXME for GDR_ANLT if required , otherwise remove
   //if (p_sequencer.env.dyn_rcfg_obj_inst.anlt==1) begin
   //    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   //end

   //Wait for tx_lane_Stable
   wait(p_sequencer.env.sideband_if.tx_lane_stable==1);
   case(p_sequencer.env.dyn_rcfg_obj_inst.lf)
     2'b00 : exp_lf = 2'b00;       
     2'b01 : exp_lf = 2'b11;       
     2'b10 : exp_lf = 2'b01;       
   endcase
   case(p_sequencer.env.dyn_rcfg_obj_inst.ipg)
     'd1  : exp_ipg = 2'd3;     
     'd8  : exp_ipg = 2'd2;     
     'd10 : exp_ipg = 2'd1;     
     'd12 : exp_ipg = 2'd0;     
   endcase

   case(p_sequencer.env.dyn_rcfg_obj_inst.speed)

      _10G  : exp_ipg_col_rem = 8 + p_sequencer.env.dyn_rcfg_obj_inst.ipg_rm_perperiod;//For no-FEC rates like 10G/40G in GDR, there are no AM period settings, use the values for 25G itself
      _25G  : if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
                exp_ipg_col_rem = 8 + p_sequencer.env.dyn_rcfg_obj_inst.ipg_rm_perperiod;
              end 
      _40G  : exp_ipg_col_rem = 4 + p_sequencer.env.dyn_rcfg_obj_inst.ipg_rm_perperiod;
      _50G  : exp_ipg_col_rem = 4 + p_sequencer.env.dyn_rcfg_obj_inst.ipg_rm_perperiod;
      _100G : exp_ipg_col_rem = 20 + p_sequencer.env.dyn_rcfg_obj_inst.ipg_rm_perperiod;
      _200G : exp_ipg_col_rem = 16 + p_sequencer.env.dyn_rcfg_obj_inst.ipg_rm_perperiod;
      _400G : exp_ipg_col_rem = 32 + p_sequencer.env.dyn_rcfg_obj_inst.ipg_rm_perperiod;
   endcase

   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   if(read_data[1:0] != exp_lf)
     `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR LINKFAULT CONFIG REG for address.reg value bit:%b,exp value:%b ",read_data,exp_lf));
   
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
   if(read_data[2:1]!=exp_ipg )
      `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR IPG CONFIG REG for address.reg value:%h,exp value:%h",read_data[2:1],exp_ipg));
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_50G,_40G} && p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
        exp_pp = 1;
   end else begin
       exp_pp = this.p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough;
   end
   if(read_data[0]!=exp_pp) 
      `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR TX_MAC CONFIG REG for address.reg value:%h,parameter value:%h ",read_data[0],exp_pp));

   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); 
   if(read_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough) 
      `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR RX_MAC CONFIG REG for address.reg value:%h,parameter value:%h ",read_data[0],p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough));
        
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
    if(read_data[1]!=(p_sequencer.env.dyn_rcfg_obj_inst.rxvlan ? 1'h0 : 1'h1)) 
        `uvm_error("SWEEP_PARAMETER_SEQUENCE",$sformatf("read data mismatach for REGISTERS_RXMAC_CONTROL_OFFSET_REG for address.reg value bit[1]:%h,parameter value:%h" , read_data[1],p_sequencer.env.dyn_rcfg_obj_inst.rxvlan));

    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
    if(read_data[1]!=(p_sequencer.env.dyn_rcfg_obj_inst.txvlan ? 1'h0 : 1'h1))
       `uvm_error("SWEEP_PARAMETER_SEQUENCE",$sformatf("read data mismatach for REGISTERS_TX_MAC_CONTROL_OFFSET_REG for address.reg value bit[1]:%h,parameter value:%h" , read_data[1],p_sequencer.env.dyn_rcfg_obj_inst.txvlan));
   
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); 
   if(read_data!=p_sequencer.env.dyn_rcfg_obj_inst.tx_frm_size)
      `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR MAC_TX_SIZE_CONFIG REG for address 0x407.reg value:%h,parameter value:%h ",read_data,p_sequencer.env.dyn_rcfg_obj_inst.tx_frm_size));
	
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   if(read_data!=p_sequencer.env.dyn_rcfg_obj_inst.rx_frm_size) 
      `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR MAC_TX_SIZE_CONFIG REG for address 0x506.reg value:%h,parameter value:%h ",read_data,p_sequencer.env.dyn_rcfg_obj_inst.rx_frm_size));
 //for 25g/10g nofec case no need to check for ipg_col_rem register HSD:https://hsdes.intel.com/appstore/article/#/16013794219
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
   if(read_data!= exp_ipg_col_rem && (!(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G} && p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC)) )
      `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR REGISTERS_ipg_col_rem_OFFSET_REG for address 0x406.reg value:%h,parameter value:%h ",read_data,exp_ipg_col_rem));
   
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
   if(read_data[3]!=p_sequencer.env.dyn_rcfg_obj_inst.sa) 
    `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR REGISTERS_TX_MAC_CONTROL_OFFSET_REG for address 0x40a.reg value:%h,parameter value:%h ",read_data[3],p_sequencer.env.dyn_rcfg_obj_inst.sa));
   
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
    if(p_sequencer.env.dyn_rcfg_obj_inst.sfd!=read_data[3] || p_sequencer.env.dyn_rcfg_obj_inst.en_mx_frsz!=read_data[7] || p_sequencer.env.dyn_rcfg_obj_inst.strict_preamble != read_data[4])
    `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR REGISTERS_RXMAC_CONTROL_OFFSET_REG for address 0x50a.reg value bit3,7,4:%b,parameter values:%h, %h,  %h",read_data,p_sequencer.env.dyn_rcfg_obj_inst.sfd,p_sequencer.env.dyn_rcfg_obj_inst.en_mx_frsz,p_sequencer.env.dyn_rcfg_obj_inst.strict_preamble));
   
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   if(read_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.rx_fc_fwd) 
    `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR REGISTERS_rx_pause_fwd_OFFSET_REG for address 0x706.reg value :%h,parameter values:%h",read_data[0],p_sequencer.env.dyn_rcfg_obj_inst.rx_fc_fwd));

   // dsamantx:Revisit for GDR_ANLT as anlt register is missing.please uncomment below lines if found.
   /*
   if(p_sequencer.env.dyn_rcfg_obj_inst.anlt!=1) begin 
// FIXME-MISSING_REG_IN_GDR      regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_an_cfg1_OFFSET_REG); 
     regs.predict(.value('h0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
   end	
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_cfg1_OFFSET_REG,read_data);
   if(read_data[0]!=(p_sequencer.env.dyn_rcfg_obj_inst.anlt ? 'h737d0281 : 'h0 )) 
      `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR REGISTERS_an_cfg1_OFFSET_REG for address 0xC0.reg value bit [0] :%h,parameter values:%h",read_data[0],p_sequencer.env.dyn_rcfg_obj_inst.anlt));
	
   if(p_sequencer.env.dyn_rcfg_obj_inst.anlt!=1) begin 
// FIXME-MISSING_REG_IN_GDR	regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_lt_cfg1_OFFSET_REG); 
	regs.predict(.value('h0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
   end	

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data); 
   if(read_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.anlt)
      `uvm_error("SWEEP_PARAMETER_SEQUENCE", $sformatf(" read data mismatch FOR REGISTERS_lt_cfg1_OFFSET_REG for address 0xD0.reg value bit [0] :%h,parameter values:%h",read_data[0],p_sequencer.env.dyn_rcfg_obj_inst.anlt));
*/

`ifdef ENABLE_ETH_VIP
      fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,5);  
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
      join
`else
      send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
`endif

  endtask
endclass
