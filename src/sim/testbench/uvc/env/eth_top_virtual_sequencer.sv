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


typedef class eth_top_env;
   import reset_uvc_pkg::*;
class eth_top_virtual_sequencer extends uvm_sequencer;

   //import reset_uvc_pkg::*;
   eth_virtual_sequencer virtual_sequencer_inst[`NUM_INST];

   eth_top_env top_env;

   eth_env_env env;

   altuvm_avalon_mm_sequencer kr10g_sqr,kr25g_sqr,kr40g_sqr,kr50g_sqr,kr100g_sqr,kr200g_sqr,kr400g_sqr;
   altuvm_avalon_mm_sequencer avmm_p2p_sqr,avmm_asm_sqr,status_seqr;

   eth_anlt_f_csr_doc_urm kr25g_reg_model;
   /*eth_anlt_f_csr_doc_urm kr50g_reg_model;
   eth_anlt_f_csr_doc_urm kr100g_reg_model;
   eth_anlt_f_csr_doc_urm kr200g_reg_model;
   eth_anlt_f_csr_doc_urm kr400g_reg_model;*/

  `uvm_component_utils(eth_top_virtual_sequencer)

  function new(string name="eth_top_virtual_sequencer", uvm_component parent);
    super.new(name, parent);    
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
endclass: eth_top_virtual_sequencer
