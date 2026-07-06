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


typedef class eth_env_env;
typedef class eth_top_env;
import reset_uvc_pkg::*;

class eth_virtual_sequencer extends uvm_sequencer;
   //import reset_uvc_pkg::*;
   reset_seqr reset_seqr_inst;
   eth_tx_layering_sqr tx_seqr;
   eth_fc_sqr fc_sqr;
   typedef uvm_sequencer #(eth_packet) client_tx_sequencer;
   client_tx_sequencer              v_m_sqr;
  `ifdef ENABLE_ETH_VIP
   svt_ethernet_transaction_sequencer eth_vip_seqr_inst;
   svt_ethernet_transaction_sequencer eth_vip_seqr_inst_otn_flexe;
 `endif
   altuvm_avalon_mm_sequencer status_seqr;
   altuvm_avalon_mm_sequencer status_mac_seqr;
   altuvm_avalon_mm_sequencer status_rcfg_seqr;
   altuvm_avalon_mm_sequencer xcvr_avmm_sequencer_0,xcvr_avmm_sequencer_1,xcvr_avmm_sequencer_2,xcvr_avmm_sequencer_3,
                              xcvr_avmm_sequencer_4,xcvr_avmm_sequencer_5,xcvr_avmm_sequencer_6,xcvr_avmm_sequencer_7;

   altuvm_avalon_mm_sequencer kr25g_sqr,kr50g_sqr,kr100g_sqr,kr200g_sqr,kr400g_sqr;
   altuvm_avalon_mm_sequencer avmm_p2p_sqr, avmm_asm_sqr;

   registers_urm reg_model;
   gdr_ehip_p2p_urm             p2p_reg_model;
   gdr_ehip_asm_urm             asm_reg_model;

   eth_env_env env;
   eth_top_env top_env;
   int txdp_pkt_cnt,rxdp_pkt_cnt; //used in sequences to chek the packet count
   svt_axi_master_sequencer         axi_mst_seqr;

  `uvm_component_utils(eth_virtual_sequencer)

  function new(string name="eth_virtual_sequencer", uvm_component parent);
    super.new(name, parent);    
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
endclass: eth_virtual_sequencer


