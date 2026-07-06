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


class auto_neg_rst_during_data_sequence extends eth_base_sequence;

  `uvm_object_utils(auto_neg_rst_during_data_sequence)
  int rand_delay;
  bit[31:0] data_read;
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
    `uvm_info("eth_seq_lib", "running auto_neg_rst_during_data sequence\n",UVM_LOW)
   
    `ifdef ENABLE_ETH_VIP
      fork : reset_seq
        begin
//          fork 
            send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
            send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
//          join
        end
        begin
	      rand_delay = $urandom_range(5,10); //Waiting for random delay before restarting auto-neg 
	      #(rand_delay*1ns); 
          p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("usxgmii_control"),data_read);
          `uvm_info("AVMM REG READ", $sformatf("usxgmii_control ('h400) read data is  :'h%0h",data_read), UVM_NONE);
          data_read = {data_read[31:10],1'b1,data_read[8:0]};
          p_sequencer.env.reg_write(p_sequencer.env.gdr_ral_offset("usxgmii_control"),data_read);
	      p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
	      p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
	      p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0;
	      p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
          disable reset_seq;
        end
      join
      //Resetting VIP
//      p_sequencer.top_env.env_ip[inst].svt_ethernet_txrx_inst.reset = 1;
      p_sequencer.env.svt_ethernet_txrx_inst.reset = 1;
      #5us;
      p_sequencer.env.svt_ethernet_txrx_inst.reset = 0;
      //p_sequencer.env.vip_cfg_inst.cfg[0].enable_usxgmii_an      = 1;
      //p_sequencer.env.vip_cfg_inst.cfg[0].enable_usxgmii_soft_an = 0;
      `uvm_info("AN_SEQ", $sformatf("Reconfiguring VIP, interface select is :'h%0h",p_sequencer.env.`MAC_CFG.interface_select), UVM_NONE);
      //p_sequencer.env.`MAC_CFG.interface_select = 1;
      p_sequencer.env.`MAC_CFG.enable_usxgmii_an      = 1;
      p_sequencer.env.`MAC_CFG.enable_usxgmii_soft_an = 0;
      p_sequencer.env.`MAC_CFG.usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,3'b011,1'b1,1'b1,6'd0,1'b1};
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.`MAC_CFG);
      `uvm_info("AN_SEQ", $sformatf("VIP reconfigured, interface select is :'h%0h",p_sequencer.env.`MAC_CFG.interface_select), UVM_NONE);
      p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
      p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
      p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
      p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
      `uvm_info("AN_SEQ", $sformatf("waiting for pcs_led_an_o :'h%0h",p_sequencer.env.`MAC_CFG.interface_select), UVM_NONE);
      wait(p_sequencer.env.spy_if.pcs_led_an_o == 1'b1);
      `uvm_info("AN_SEQ", $sformatf("done waiting for pcs_led_an_o :'h%0h",p_sequencer.env.`MAC_CFG.interface_select), UVM_NONE);
      #10us;
      send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
      send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
    `endif
  
  endtask
endclass
