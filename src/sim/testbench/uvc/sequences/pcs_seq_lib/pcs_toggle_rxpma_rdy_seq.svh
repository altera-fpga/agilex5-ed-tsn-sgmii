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


class pcs_toggle_rxpma_rdy_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(pcs_toggle_rxpma_rdy_sequence)

  class local_seq_var extends seq_var; 

  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_toggle_rxpma_rdy_sequence");
    super.new(name);
    m_seq_var = new(); 
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
     int num_frames;
     bit link_lost;
     bit am_lock_lost;
     bit am_lock;
     bit lock_lost;
     integer timeout_cntr=0;
     int error_cnt=0;
     uvm_status_e status;
     bit [31:0] am_lock_rd_data;
     bit [31:0] phy_rxpcs_status_rd_data;
     bit [31:0] lanes_deskewed_rd_data;
     bit link_down;
     bit link_up;
     int loop_cnt = 3;
     bit [15:0] len;


    //-------------------------------------------------------------------
    //toggle rxpma_rdy after hard reset
    //pcs_rdy should go down when rx_pma rdy low
    //dut link should come up after rxpma_rdy goes back to high
    // frames sent on rx path during this toggling. After every link up, all frames should be received
    //-------------------------------------------------------------------


    `uvm_info(get_type_name(), "PCS TOGGLE RXPMA RDY  SEQ BEGIN", UVM_LOW)
    apply_hard_reset(0,0,1,11);
    rx_crc_pass=$urandom;


    //toggle rx_pma_rdy
    fork

    forever begin
      //force $root.eth_env_top.dut.top.rx_pma_ready[3:0] = 0;
       p_sequencer.env.ts_tasks_if.force_rx_pma_rdy();
       repeat(100) @(p_sequencer.env.spy_if.clk);
       p_sequencer.env.ts_tasks_if.release_rx_pma_rdy();
       //repeat(6000) @(p_sequencer.env.spy_if.clk);
       repeat(40000) @(p_sequencer.env.spy_if.clk);
      `uvm_info(get_type_name(), "FORCE/RELEASE RX_PMA_RDY DONE", UVM_LOW)
     end
    join_none


    fork
      //dut link up
      begin
        p_sequencer.env.wait_rx_pcs_ready();
      end
    join


    //send frames
    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,2000);
    
    //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_DATA,`ETH_INCR);
    //`uvm_info(get_type_name(), "Sent 2000 frames", UVM_LOW)
    //for(int i=0;i<2000;i++) begin
    //  len = 64 + i;
    //  p_sequencer.env.ts_tasks_if.do_drv_cmd(`ETH_MAC_DATA_FRAME,`ETH_MAC1_INDVL_ADDRESS,len);
    //end
         

      `uvm_info(get_type_name(), "PCS TOGGLE RXPMA RDY  SEQ END", UVM_LOW)
  endtask
endclass
