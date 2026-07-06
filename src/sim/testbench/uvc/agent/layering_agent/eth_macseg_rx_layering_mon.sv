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


`ifndef ETH_MACSEG_RX_LAYERING_MON__SV
`define ETH_MACSEG_RX_LAYERING_MON__SV

typedef class eth_packet;
`uvm_analysis_imp_decl(_macseg_rx)
//------------------------------------------------------------------------------
// Class:  eth_macseg_rx_layering_mon
// This class gets the transcation from MACSEG RX monitor and converts it from eth_
// packet to avst_pkt and then passes that to scoreboard via eth_avst_rx_pkt_adapter.
//------------------------------------------------------------------------------
class eth_macseg_rx_layering_mon extends eth_avst_rx_pkt_adapter;

   //Port: frm_rx_macseg_mon
   //This port receives item recived from the RX MACSEG monitor
   uvm_analysis_imp_macseg_rx #(eth_packet,eth_macseg_rx_layering_mon) frm_rx_macseg_mon;
   
   extern function new(string name = "eth_macseg_rx_layering_mon",uvm_component parent); 
   
   `uvm_component_utils(eth_macseg_rx_layering_mon)
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void write_macseg_rx(input eth_packet pkt_item);
   extern virtual function void chg_eth_packet_to_avst_req_base_pkt(input eth_packet pkt_item);
 
endclass: eth_macseg_rx_layering_mon

function eth_macseg_rx_layering_mon::new(string name = "eth_macseg_rx_layering_mon",uvm_component parent);
   super.new(name, parent);
   frm_rx_macseg_mon = new("frm_rx_macseg_mon", this);
endfunction: new

function void eth_macseg_rx_layering_mon::build_phase(uvm_phase phase);
      super.build_phase(phase);
endfunction


    //------------------------------------------------------------------------------
    //  function:  write
    //
    //  This write function gets invoke whenever the RX-MACSEG monitor gets some transcation 
    //  and convert the mac seg packet to avst packet and sends to rx_pkt_adapter to follow up    //------------------------------------------------------------------------------
function void eth_macseg_rx_layering_mon::write_macseg_rx(input eth_packet pkt_item);
  `uvm_info("seg rx layering monitor",$sformatf("Received pkt frm RX-MACSEG monitor in macseg_rx_layering_mon %s \n",pkt_item.sprint()),UVM_LOW);
  chg_eth_packet_to_avst_req_base_pkt(pkt_item); //conversion of eth_packet to respected avst_req_base & send to parent
  `uvm_info("seg rx layering monitor",$sformatf("completed pkt in macseg_rx_layering_mon\n"),UVM_LOW);
endfunction: write_macseg_rx

function void eth_macseg_rx_layering_mon::chg_eth_packet_to_avst_req_base_pkt(input eth_packet pkt_item);
  avst_req_base   avst_item;
  logic[7:0] temp_packed_bytes[$];
  bit[5:0] rx_error;
  bit[1:0] temp_mac_error;
  
  avst_item=avst_req_base::type_id::create("avst_item",this);
  // TODO : Add necessary eth_packet items & convert it to avst_req_base
  temp_packed_bytes  = pkt_item.seg_to_avst_pack_bytes(pkt_item.seg_packed_bytes);
   for(int i = 0 ; i < pkt_item.empty_bytes ; i++)begin  //Remove empty bytes
      void'(temp_packed_bytes.pop_back());
   end
  avst_item.data_symbols= new[temp_packed_bytes.size](temp_packed_bytes);
  avst_item.num_symbols = avst_item.data_symbols.size;
  avst_item.transaction_id=pkt_item.transaction_id;
  avst_item.protocol_error_sop=0; //it looks like not implemented in rx macseg monitor
  avst_item.protocol_error_eop=0; //it looks like not implemented in rx macseg monitor
  avst_item.error.delete();
  avst_item.error=new[1];
  avst_item.error[0]=pkt_item.rx_mac_error;
  `uvm_info("seg rx layering monitor",$sformatf("Time =%t rx_error = %0h transaction id=%0d",$time,pkt_item.rx_mac_error, pkt_item.transaction_id),UVM_MEDIUM);
  frm_rx_avst_mon.write(avst_item);
endfunction

`endif //ETH_MACSEG_RX_LAYERING_MON__SV

