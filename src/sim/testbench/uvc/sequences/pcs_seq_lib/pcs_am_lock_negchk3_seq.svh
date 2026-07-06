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


////////////////////////////////////////////////////////////////////////
/// Sequence : pcs_am_lock_negchk3_sequence
/// lock loss should not happen when we corrupt 4 consecutive BIP in AM
/// PCS BIP corruption is not applicable for 200G/400G
////////////////////////////////////////////////////////////////////////

class pcs_am_lock_negchk3_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(pcs_am_lock_negchk3_sequence)

  class local_seq_var extends seq_var; 

   //num_lanes: 1, 4 or more
   // constraint num_lanes_c {
   //   //num_lanes == 1; 
   //   //num_lanes == 4; 
   // }

    constraint num_invalid_am_c {
      //num_invalid_am == 3;
      num_invalid_am dist { 3:= 90, 1:=10, 2:=10} ;
    }
  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_am_lock_negchk3_sequence");
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
     int num_iter = 10;

     //-------------------------------------------------------------------
     // choose lane/lanes to replace bip (where BIP7 is not bitwise inverse if BIP3) 
     // For all above cases, DUT should not lose lock
     // Fire Data Packets from VIP 

    $display("start pcs_am_lock_negchk3_sequence");
    // apply_hard_reset(0,0,1,11);
    // fork
    //   //dut link up
    //   begin
    //     p_sequencer.env.wait_rx_pcs_ready();
    //   end
    //   //vip link up(FIXME RR)
    //   begin
    //   end
    // join

    if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) begin
      `uvm_info(get_type_name(), $sformatf("BIP doesn't exists in 200/400G alignment markers"), UVM_LOW)
    end else begin
       rx_crc_pass=$urandom;
       //pcs_mac register not accessible in pcs_only mode   
       //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
       $display("DONE!!! WRITING TO REG");

       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::NOTE);

       fork    
          //poll for loss of lock
          forever begin
            @(posedge p_sequencer.env.spy_if.clk);
            if(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0) begin
               `uvm_fatal(get_type_name(), "DUT LINK DOWN UNEXPECTED")
            end
          end
       join_none

      //insert invalid bip 
      //send 4 consecutive invalid bip 
      for(int i=0;i<4;i++) begin 
        //randomize num of lanes, invalid am on each lane
        if (!m_seq_var.randomize()) begin
          `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
        end
        `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)
        @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
        insert_invalid_bip_2(m_seq_var);
        `uvm_info(get_type_name(), $sformatf("inserted invalid_bip i:%d, num_lanes:%d", i, m_seq_var.num_lanes), UVM_LOW)
      end
    
      fork 
       begin
         //check to see if lock lsot
         am_lock_lost = 0;
         wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0);
         link_down=1;
       end
       begin
         //timeout check
         //while(am_lock_lost == 0) begin
         while(link_down== 0) begin
           @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
           `uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr), UVM_LOW)
           timeout_cntr++;
           if(timeout_cntr == 50) begin
             break;
           end
         end
       end
      join_any


      `uvm_info(get_type_name(), $sformatf("after first fork exit  timeout_cntr:%d", timeout_cntr), UVM_LOW)
      if(link_down == 1) begin
        `uvm_error(get_type_name(), $sformatf("UNEXPECTED LOSS OF LOCK after 3 invalid ams inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
      end
      else if(link_down == 0) begin
        `uvm_info(get_type_name(), $sformatf("NO LOSS OF LOCK AS EXPECTED am_lock_lost :%d", link_down), UVM_LOW)
      end

      //wait for 1 good am after 3 bad from previous loop
      @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);

     fork 

       //send frames
       begin
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1500);
         `uvm_info(get_type_name(), "Sent 1000 frames", UVM_LOW)
       end
 
       //corrupt ams (alternate good & bad) 
       begin

         for(int s=0; s<num_iter; s++) begin
           if(s%2 == 1) begin
             @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
             `uvm_info(get_type_name(), "Skipping sending invalid AMs for this iteration", UVM_LOW)
           end
           else begin
             if (!m_seq_var.randomize()) begin
               `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
             end
             for(int i=0; i<m_seq_var.num_invalid_am ; i++) begin
               `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)
               @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
               insert_invalid_bip_2(m_seq_var);
               `uvm_info(get_type_name(), $sformatf("inserted invalid_bip i:%d, num_lanes:%d, num_invalid_am:%d", i, m_seq_var.num_lanes, m_seq_var.num_invalid_am), UVM_LOW)
             end //num_invalid_am
           end //s
         end //num_iter
       end //invalid am insert thread
     join


      `uvm_info(get_type_name(), "PCS AM LOCK NEGCHK2 SEQ END", UVM_LOW)
    end  
  endtask
endclass
