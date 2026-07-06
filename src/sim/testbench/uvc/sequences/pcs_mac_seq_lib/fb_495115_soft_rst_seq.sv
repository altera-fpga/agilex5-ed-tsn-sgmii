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


class fb_495115_soft_rst_seq extends eth_base_sequence;
  bit[2:0] hard_rst_sig;
  bit[2:0] soft_rst_sig;
  bit[2:0] rst_sig;
  `uvm_object_utils(fb_495115_soft_rst_seq)
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("body", "started fb_495115_soft_rst_seq ...", UVM_NONE)
   p_sequencer.env.apply_reset("hard",0,0,1,11);
   //`ifdef CRETE3   //dsamantx:FIX_ME for GDR
     p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   //`else
   // rx_pcs_ready_timeout();//Shabbir - FB 534015
   //`endif  
    
   for (int i=0;i<7;i++) begin
     
     `ifdef ENABLE_ETH_VIP
        fork
          send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
        join
     `else
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
     `endif
     #2000ns;
     //Disable scoreboard 
    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0;
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
     //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 1; //patelavx
    `else
     p_sequencer.env.sb_loopbk.scb_dis = 1;
    `endif
     `uvm_info("fb_495115_soft_rst_seq", "5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter", UVM_NONE)
     // soft rst
     soft_rst_sig++;
     `uvm_info("apply_hard_reset", $sformatf("soft_reset := %0d | soft_rst_combination := %0d",i,soft_rst_sig),UVM_NONE)
     p_sequencer.env.apply_reset("soft",soft_rst_sig[2],soft_rst_sig[1],soft_rst_sig[0]);
     reconfig_for_an(soft_rst_sig);
    `ifndef ENABLE_ETH_VIP
     if(soft_rst_sig == 3'b100) begin // Tx reset only
       // For tx reset only, there is delay for rx pcs ready to go low.
       //This delay will ensure following function will start waiting for rx pcs ready at correct time.
       #3000ns;
     end
    `endif
     p_sequencer.env.wait_for_linkup(.tx_sync(soft_rst_sig[2]),.rx_sync(soft_rst_sig[1]),.ip_sync(soft_rst_sig[0]));

     //Enable scoreboard
    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
     //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0; //patelavx
    `else
     p_sequencer.env.sb_loopbk.scb_dis = 0;
    `endif
     
     `ifdef ENABLE_ETH_VIP
        fork
          send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
        join
     `else
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
     `endif
     #2000ns; 
   end  
    `uvm_info("body", "ended fb_495115_soft_rst_seq ...", UVM_NONE)
  endtask
endclass : fb_495115_soft_rst_seq
