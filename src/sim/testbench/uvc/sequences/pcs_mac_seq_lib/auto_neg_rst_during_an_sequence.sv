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


class auto_neg_rst_during_an_sequence extends eth_base_sequence;

  `uvm_object_utils(auto_neg_rst_during_an_sequence)
  int rand_delay;
  bit[31:0] data_read;
  bit[31:0] data_read_1;
  bit [2:0] speed_sel;
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=10;
   end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
    `uvm_info("eth_seq_lib", "running auto_neg_rst_during_an sequence\n",UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("DM PCS operating speed configured is  :%0s",p_sequencer.env.dyn_rcfg_obj_inst.ll_speed), UVM_NONE)   
   case(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed)
     _10G : begin
       speed_sel = 3'b011;
     end
     _5G : begin
       speed_sel = 3'b101;
     end
     _2p5G : begin
       speed_sel = 3'b100;
     end
     _1G : begin
       speed_sel = 3'b010;
     end
     _10M : begin
       speed_sel = 3'b000;
     end
     _100M : begin
       speed_sel = 3'b001;
     end
   endcase
         `ifdef ENABLE_ETH_VIP
   p_sequencer.env.disable_snps_errors();   
         `endif   
   fork
     begin
       fork 
         begin
           `uvm_info(get_type_name(), $sformatf("Waiting for Tx PMA ready to go high"), UVM_NONE);
           wait(p_sequencer.env.sideband_if.tx_lane_stable==1);
           `uvm_info(get_type_name(), $sformatf("Done waiting for Tx PMA ready to go high"), UVM_NONE);
           `uvm_info(get_type_name(), $sformatf("Waiting for Rx PMA ready to go high"), UVM_NONE);
           wait(p_sequencer.env.spy_if.rx_pcs_ready == 1'b1);
           `uvm_info(get_type_name(), $sformatf("Done waiting Tx/Rx PMA Ready signals to go high"), UVM_NONE);
           wait(p_sequencer.env.spy_if.rx_block_lock == 1'b1);
           `uvm_info(get_type_name(), $sformatf("Done waiting for Block lock to go high"), UVM_NONE);
           #30us;
         end
         begin
         `ifdef ENABLE_ETH_VIP
           `uvm_info(get_type_name(), $psprintf("wait vip rx link down"), UVM_NONE)
           p_sequencer.env.ts_tasks_if.wait_vip_rx_link_down();
           `uvm_info(get_type_name(), $psprintf("wait vip rx link down Done"), UVM_NONE)
           p_sequencer.env.ts_tasks_if.wait_vip_rx_link_up(); 
           `uvm_info(get_type_name(), $psprintf("wait vip_rx_link_up Done"), UVM_NONE)
         `endif   
         end
       join
     end
     begin
       #400us;
	   `uvm_error(get_type_name(), $sformatf("Timeout waiting for DUT/VIP Link-up"));
     end
   join_any
   disable fork;  

      p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("usxgmii_control"),data_read);
   `uvm_info("AVMM REG READ", $sformatf("Register with address usxgmii_control ('h400) read data is  :'h%0h",data_read), UVM_NONE);

   data_read[1:0] = 2'b11; 
   data_read[4:2] = speed_sel;
   `uvm_info("AVMM REG READ", $sformatf("Register with address usxgmii_control ('h400) write data is :'h%0h",data_read), UVM_NONE);
   p_sequencer.env.reg_write(p_sequencer.env.gdr_ral_offset("usxgmii_control"),data_read);
   p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("usxgmii_control"),data_read);
   `uvm_info("AVMM REG READ", $sformatf("Register with address usxgmii_control ('h400) read data is  :'h%0h",data_read), UVM_NONE);
   p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("usxgmii_dev_ability"),data_read_1);
   data_read_1 = {data_read_1[15:12],speed_sel,data_read_1[8:0]};
   p_sequencer.env.reg_write(p_sequencer.env.gdr_ral_offset("usxgmii_dev_ability"),data_read_1);

   p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("usxgmii_link_timer"),data_read_1);
   data_read_1 = {5'b00001,data_read_1[13:0]};
   p_sequencer.env.reg_write(p_sequencer.env.gdr_ral_offset("usxgmii_link_timer"),data_read_1);
   `uvm_info(get_type_name(), $sformatf("Started waiting for AN to be in ack state for speed = %0s",p_sequencer.env.dyn_rcfg_obj_inst.ll_speed),UVM_NONE);
     wait(p_sequencer.env.spy_if.an_state == 3'b011)
         `ifdef ENABLE_ETH_VIP
       p_sequencer.env.svt_ethernet_txrx_inst.reset = 1;
      #5us;
      p_sequencer.env.svt_ethernet_txrx_inst.reset = 0;
      p_sequencer.env.`MAC_CFG.enable_usxgmii_an      = 1;
      p_sequencer.env.`MAC_CFG.enable_usxgmii_soft_an = 0;
      p_sequencer.env.`MAC_CFG.usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,3'b011,1'b1,1'b1,6'd0,1'b1};
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.`MAC_CFG);
      `uvm_info("AN_SEQ", $sformatf("VIP reconfigured, interface select is :'h%0h",p_sequencer.env.`MAC_CFG.interface_select), UVM_NONE);

         `endif   
   `uvm_info(get_type_name(), $sformatf("Started waiting for AN to complete for speed = %0s",p_sequencer.env.dyn_rcfg_obj_inst.ll_speed),UVM_NONE);
     wait(p_sequencer.env.spy_if.pcs_led_an_o == 1'b1)
       `ifdef ENABLE_ETH_VIP
      `uvm_info("AN_SEQ", $sformatf("done waiting for pcs_led_an_o :'h%0h",p_sequencer.env.`MAC_CFG.interface_select), UVM_NONE);
         `endif   
      #5us;
         `ifdef ENABLE_ETH_VIP
      send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
      send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
         `endif   
  
  endtask
endclass
