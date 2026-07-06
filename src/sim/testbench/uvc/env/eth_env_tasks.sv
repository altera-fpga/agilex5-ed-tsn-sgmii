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


 
//Method : read_data_chk
// This fuction meant to do direct comaprision.
 function void eth_env_env::read_data_chk(bit[31:0] act,bit[31:0] exp);
   if(act != exp)
   begin
   `uvm_error("read_data_chk", $sformatf("comparision failed actual value:'h%h expected value:'h%0h",act,exp));
   end
   else
   begin
     `uvm_info("read_data_chk",$sformatf("comprision passed , actual value:'h%h expected value:'h%0h",act,exp), UVM_MEDIUM)
   end
 endfunction

 //Task: write_stat_regs
 //This task will write to all stats counter registers with random data
 task eth_env_env::write_stat_regs();
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());

   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());

 endtask : write_stat_regs
 
 task eth_env_env::reset_vip();
    `ifdef ENABLE_ETH_VIP
      svt_ethernet_txrx_inst.reset = 0;
      if(dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})
         svt_ethernet_pcs_mode_txrx_inst.reset = 0;
      #10;
      svt_ethernet_txrx_inst.reset = 1;
      if(dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})
         svt_ethernet_pcs_mode_txrx_inst.reset = 1;
      #10;
      svt_ethernet_txrx_inst.reset = 0;
      if(dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})
         svt_ethernet_pcs_mode_txrx_inst.reset = 0;
      `endif
 endtask // reset_vip

 task eth_env_env::read_status_registers();
   uvm_reg 	regs[$];
   uvm_reg_data_t read_data;
 //  reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data);
 //  reg_read(`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data);
 //  reg_read(`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data);
 //  reg_read(`ETH_F_ALL_clk_rx_khz_OFFSET_REG,read_data);
 //  reg_read(`ETH_F_ALL_clk_tx_khz_OFFSET_REG,read_data);
 //  reg_read(`ETH_F_ALL_clk_tx_khz_RS_OFFSET_REG,read_data);
 //  reg_read(`ETH_F_ALL_clk_rx_khz_RS_OFFSET_REG,read_data);
 endtask

 task eth_env_env::wait_avst_tx_frames_done(int exp_num, time timeout_time=200us);
      string func_name = "wait_avst_tx_frames_done";
      bit    condition_met;
      int  act_pkt_cnt;
      
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for %0d transmitted by AVST",func_name,exp_num), UVM_NONE);
      condition_met = 1'b0;
      fork
        begin 
      	while (condition_met!=1'b1) begin
	  if (master_agent.mast_mon.transaction_id<exp_num) begin
	 	#10ns;
	  end
	  else begin 
	   condition_met=1'b1;
	   `uvm_info(get_type_name(), $sformatf("%s: %0d frames transmitted by AVST",func_name,exp_num), UVM_NONE);
	  end
	end
	end
	
        begin 
	  #(timeout_time); 
	  `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for %0d transmitted by AVST. Waited %0t.",func_name,exp_num,timeout_time));
	end
       join_any
       disable fork;
  endtask // wait_avst_tx_frames_done

  function int eth_env_env::set_masked_val(uvm_reg_data_t addr, input bit[1:0] en_mask_fld = 2);
   uvm_reg 	select_reg;
   uvm_reg_field flds[$];
   int lsb,masked_val;
   bit arr[string];
    
   // en_mask_fid is used for choosing the fields to be masked where 0=WO mask; 1=RO mask; 2=Both WO & RO register mask
   case(en_mask_fld)
      0: begin arr["WO"]=1; arr["RO"]=0; end
      1: begin arr["RO"]=1; arr["WO"]=0; end
      2: begin arr["WO"]=1; arr["RO"]=1; end
   endcase
   
   select_reg = reg_model.default_map.get_reg_by_offset(addr);
   masked_val='hFFFF_FFFF;
   if (select_reg != null)
   begin
     // masking WO fields
     flds={};
     select_reg.get_fields(flds);
     foreach (flds[i]) begin
      if(arr[flds[i].get_access()]==1) begin
	  lsb  = flds[i].get_lsb_pos();
          masked_val &= ~(((1 << flds[i].get_n_bits()) - 1) << lsb);
	  $display("masked value =%0b",masked_val);
       end
     end
     return masked_val;
    end
endfunction
