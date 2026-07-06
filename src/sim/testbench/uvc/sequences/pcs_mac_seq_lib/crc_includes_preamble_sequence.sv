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


class crc_includes_preamble_sequence extends eth_base_sequence;
  bit rx_crc;
  int pl_size, frame_size;
  bit[31:0] fcs;
  bit[7:0] dyn_arr[$];
  bit[15:0] eth_type_length;
  int count;
  uvm_reg_data_t rd_data;
  uvm_reg_data_t txcrc_covers_preamble;
  uvm_reg_data_t rxcrc_covers_preamble;
  
  `uvm_object_utils(crc_includes_preamble_sequence)
  
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   $display("running crc pass sequence");
   
   //FIXME for GDR_ANLT if required,Otherwise remove
   //if (p_sequencer.env.dyn_rcfg_obj_inst.anlt==1) begin
   //    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   //end
   
   //Wait for tx_lane_Stable
   wait(p_sequencer.env.sideband_if.tx_lane_stable==1);
   
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   if(rd_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.crc_pass)   `uvm_error("crc_includes_preamble_sequence", $sformatf("mac_cfg_mac_crc_config_OFFSET_REG bit 0 value must be initialized as per parameter"));  
   
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
   //Shabbir- FB560308 CRC passthrough can not be enabled with remove pads (bytestoremove=2) (rx_bytes_to_remove = "Remove CRC and PAD bytes")
   if(rd_data[8] == 0)
   begin
     rx_crc = 'h1;
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc); 
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
     txcrc_covers_preamble = {rd_data[31:10],1'b1,rd_data[8:0]};
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txcrc_covers_preamble); 
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
     rxcrc_covers_preamble = {rd_data[31:2],1'b1,rd_data[0]};
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rxcrc_covers_preamble); 
   end // txcrc_covers_preamble
   `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     
    fork
        begin
         // Need to create a packet in which FCS is calculated over CRC, creating user defined packet in a dynamic array
         for(int i = 0; i<20; i++ ) begin
         pl_size = 1200;
         frame_size = pl_size + 22 + 4; 
         dyn_arr[0] = 8'hFB; 
         dyn_arr[1] = 8'h55; 
         dyn_arr[2] = 8'h55; 
         dyn_arr[3] = 8'h55; 
         dyn_arr[4] = 8'h55; 
         dyn_arr[5] = 8'h55; 
         dyn_arr[6] = 8'h55; 
         dyn_arr[7] = 8'hD5; 
         eth_type_length = pl_size;
         `uvm_info("crc_includes_preamble_sequence", $sformatf("value of Eth Length Type field is=%0h", eth_type_length), UVM_MEDIUM)
         `uvm_info("crc_includes_preamble_sequence", $sformatf("value of Eth Length Type field[15:8] is=%0h and [7:0] is=%0h", eth_type_length[15:8], eth_type_length[7:0]), UVM_MEDIUM)
         for(int i = 0; i<12 ;i++ ) begin // SA+DA
            dyn_arr[i+8] = i+8;
         end
         dyn_arr[20] = eth_type_length[15:8]; // Eth length type field 
         dyn_arr[21] = eth_type_length[7:0];
         for(int i = 0; i<pl_size ;i++ ) begin //Payload 
            dyn_arr[i+22] = i;
         end
         fcs = p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.common.eth_calculate_fcs(dyn_arr);
         count = count +1;
         `uvm_info("crc_includes_preamble_sequence", $sformatf("value of FCS calculated by Synopsys API is =%0h", fcs), UVM_MEDIUM)
         `uvm_info("crc_includes_preamble_sequence", $sformatf("iteration number =%0d",count), UVM_MEDIUM)
         dyn_arr = {dyn_arr,fcs[31:24],fcs[23:16],fcs[15:8],fcs[7:0]};
         eth_pkt.command_type          = svt_ethernet_enum_pkg:: ETH_USER_FRAME_WITH_PREAMBLE_SFD_HEADER;  
         eth_pkt.user_packet_type      = svt_ethernet_enum_pkg:: DATA_FRAME;
         eth_pkt.enable_apply_user_pkt = 1;
         eth_pkt.enable_mac_frame_user_fcs = 1;
         eth_pkt.user_pkt_data = new[frame_size];
         for(int i = 0; i<frame_size; i++ ) begin
            eth_pkt.user_pkt_data[i] = dyn_arr[i];
         end
         send_eth_frame(FRAME_CRC_COVERS_PREAMBLE,ETH_VIP_AVL_RX,1);
          $display("[Before-Delete] Queue size is %0d",dyn_arr.size());
          dyn_arr.delete();
          $display("[After -Delete] Queue size is %0d",dyn_arr.size());
//         `uvm_do_on (eth_pkt,p_sequencer.eth_virtual_sequencer)
        end  
      end
    begin
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,20); 
    end
    join
   `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,300);  
   `endif
   endtask
endclass
