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


// Template for UVM-compliant physical-level monitor

`ifndef ETH_MACSEG_TX_LAYERING_MON__SV
`define ETH_MACSEG_TX_LAYERING_MON__SV

typedef class eth_packet;
`uvm_analysis_imp_decl(_macseg_tx)

class eth_macseg_tx_layering_mon extends eth_tx_layering_mon;
   uvm_analysis_imp_macseg_tx #(eth_packet,eth_macseg_tx_layering_mon) frm_macseg_mon;
 
   extern function new(string name = "eth_macseg_tx_layering_mon",uvm_component parent);
   
   `uvm_component_utils_begin(eth_macseg_tx_layering_mon)

   `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void write_macseg_tx(input eth_packet pkt_item);
   extern virtual function void chg_eth_packet_to_avst_req_base_pkt(input eth_packet pkt_item);
 
endclass: eth_macseg_tx_layering_mon

function eth_macseg_tx_layering_mon::new(string name = "eth_macseg_tx_layering_mon",uvm_component parent);
   super.new(name, parent);
   frm_macseg_mon = new("frm_macseg_mon", this);
endfunction: new

function void eth_macseg_tx_layering_mon::build_phase(uvm_phase phase);
      super.build_phase(phase);
endfunction

function void eth_macseg_tx_layering_mon::write_macseg_tx(input eth_packet pkt_item);
  `uvm_info("seg tx layering monitor",$sformatf("Received pkt frm TX-MACSEG monitor in macseg_tx_layering_mon %s \n",pkt_item.sprint()),UVM_LOW);
  chg_eth_packet_to_avst_req_base_pkt(pkt_item); //conversion of eth_packet to respected avst_req_base
  `uvm_info("seg tx layering monitor",$sformatf("completed pkt in macseg_tx_layering_mon\n"),UVM_LOW);
endfunction: write_macseg_tx

 function void eth_macseg_tx_layering_mon::chg_eth_packet_to_avst_req_base_pkt(input eth_packet pkt_item);
  avst_req_base   avst_item;
  logic[7:0] temp_packed_bytes[$];
  
  avst_item=avst_req_base::type_id::create("avst_item",this);
  `uvm_info("seg tx layering monitor",$sformatf("Time =%t skip_crc=%0h tx_error =%0d transaction id=%0d",$time,pkt_item.skip_tx_crc_insertion,pkt_item.tx_error_insertion, pkt_item.transaction_id),UVM_HIGH);
  // TODO : Add necessary eth_packet items & convert it to avst_req_base
  temp_packed_bytes  = pkt_item.seg_to_avst_pack_bytes(pkt_item.seg_packed_bytes);
   for(int i = 0 ; i < pkt_item.empty_bytes ; i++)begin  //Remove empty bytes
      void'(temp_packed_bytes.pop_back());
   end
  avst_item.data_symbols= new[temp_packed_bytes.size](temp_packed_bytes);
  avst_item.num_symbols = avst_item.data_symbols.size;
  avst_item.transaction_id=pkt_item.transaction_id;
  avst_item.channel[0]  = pkt_item.skip_tx_crc_insertion;
  avst_item.protocol_error_sop=0; //Looks like not implemented in tx macseg monitor
  avst_item.protocol_error_eop=0; //Looks like not implemented in tx macseg monitor
  //avst_item.ipg = pkt_item.interpacket_gap; //not required
  mon_if.tx_error=pkt_item.tx_error_insertion;

  mon_is_ptp_seq = pkt_item.is_ptp_seq;
  mon_ptp_val = pkt_item.m_ptp_op;
  ptp_kind = pkt_item.m_ptp_kind;
  mon_ingress_ts = pkt_item.ingress_ts; 
  mon_i_ptp_tx_fp = pkt_item.i_ptp_tx_fp;
  mon_i_asym_sign = pkt_item.asym_sign;
  mon_i_asym_p2p_idx = pkt_item.asym_p2p_idx;
  mon_ptp_offset = pkt_item.ptp_offset;
  mon_cf_offset = pkt_item.cf_offset;
  mon_cs_offset = pkt_item.cs_offset;

  frm_avst_mon.write(avst_item);
endfunction

`endif // ETH_MACSEG_TX_LAYERING_MON__SV

