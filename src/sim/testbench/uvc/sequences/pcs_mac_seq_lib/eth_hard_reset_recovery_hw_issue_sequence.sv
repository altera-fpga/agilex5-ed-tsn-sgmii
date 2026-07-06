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


class eth_hard_reset_recovery_hw_issue_sequence extends eth_base_sequence;
  uvm_event_pool a_event_pool;
  uvm_event assertion_event;
  bit[1:0] csr_rx_rst;
  bit random_reset;

  `uvm_object_utils(eth_hard_reset_recovery_hw_issue_sequence)
  
  function new(string name = "eth_hard_reset_recovery_hw_issue_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   a_event_pool = new();
   a_event_pool = a_event_pool.get_global_pool();
   assertion_event = a_event_pool.get("assertion_event");
   p_sequencer.env.apply_reset("hard",0,0,1,11);
   assertion_event.trigger();
   p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 0;

   `uvm_info("eth_hard_reset_recovery_hw_issue_sequence", "Executing eth_hard_reset_recovery_hw_issue_sequence ...", UVM_LOW)
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

   fork : reset_thread_1
     begin
         send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,50);
     end
  
     begin
         send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);
     end
     begin
       for(int j=0;j<$urandom_range (20,40);j++)
       begin
       `ifdef ENABLE_ETH_VIP
        p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
       `endif
       end
       csr_rx_rst = $urandom_range(1,3);
       random_reset = $urandom_range(0,1);
       if(random_reset == 0)
        begin
          p_sequencer.env.apply_reset("hard",0,csr_rx_rst[1],csr_rx_rst[0],$urandom_range(11,50));
        end
       else
        begin
         apply_tx_rst();
        end
       disable reset_thread_1; 
     end
     begin
     @ (negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
     #1;
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n );
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n  & p_sequencer.env.reset_if.rx_rst_n);
     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n);
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
     //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
      uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_NONE);
     if(p_sequencer.env.reset_if.tx_rst_n !== 0) begin
       disable reset_thread_1; 
     end
     end
   join

   #100ns;//added delay to close previous fork join thead
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   //Enable scoreboards after pcs ready goes high
   p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
   p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
   p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
   //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0;  //patelavx

   fork : reset_thread
     begin
         send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,50);
     end
  
     begin
         send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);
     end
     begin
       for(int j=0;j<$urandom_range (20,40);j++)
       begin
      `ifdef ENABLE_ETH_VIP
       p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
      `endif
       end
       p_sequencer.env.apply_reset("hard",0,1,0,11);
       apply_tx_rst();
       disable reset_thread; 
     end
     begin
     @ (negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
     #1;
     //As vip always operate in duplex mode, independent assertion of tx or rx reset impact other
     //one as rx pcs ready go low in both case and eventually packet drop happens on both path despite respective path reset is applied 
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n );
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n  & p_sequencer.env.reset_if.rx_rst_n);
     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n);
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
     //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
      uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_NONE);
     if(p_sequencer.env.reset_if.tx_rst_n !== 0) begin
       //disable reset_thread; 
     end
     end
   join

   #100ns;//added delay to close previous fork join thead

   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0; 
   p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
   p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
   p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
   //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0;  //patelavx

   `uvm_info("eth_hard_reset_recovery_hw_issue_sequence", "Exiting eth_avalonst_to_serial_simplex_sequence ...", UVM_LOW)
  endtask

endclass : eth_hard_reset_recovery_hw_issue_sequence
