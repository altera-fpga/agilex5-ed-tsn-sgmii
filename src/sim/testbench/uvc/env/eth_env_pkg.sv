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


`ifndef FTILE_TOP_PATH
`define QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0
`else
`define QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH `FTILE_TOP_PATH
`endif

 `ifdef ENABLE_ETH_VIP
    `include "svt_ethernet.uvm.pkg"
    `ifdef ETH_MULTI_PORT
    `include "svt_ethernet_multi_port.uvm.pkg"
    `endif
    `ifndef NON_ANLT_PTP 
       `include "svt_ethernet_test_suite.uvm.pkg"   //schauh1x
    `endif
    `ifdef COMPL_TC
       `include "svt_ethernet_test_suite.uvm.pkg"   //schauh1x
       `ifdef ETH_MULTI_PORT
         `include "svt_ethernet_test_suite_multi_port.uvm.pkg"
       `endif
    `endif
 `endif
package eth_env_pkg;
 import uvm_pkg::*;

    `include "uvm_macros.svh"
    `include "altuvm_macros.svh"
    `include "eth_alt_defines.sv"
    `include "dyn_rcfg.sv"
    `include "kr_cfg.sv"
    `include "vector_uvc_defines.sv"
    `ifdef ENABLE_ETH_VIP
    `include "svt_ethernet.uvm.pkg"
    `ifdef ETH_MULTI_PORT
    `include "svt_ethernet_multi_port.uvm.pkg"
    `endif
    import svt_ethernet_uvm_pkg::*;
    `ifdef ETH_MULTI_PORT
    import svt_ethernet_multi_port_uvm_pkg::*;
    `endif
    import svt_uvm_pkg::*;
    import svt_axi_uvm_pkg::*;

    `ifndef NON_ANLT_PTP 
    import svt_ethernet_test_suite_uvm_pkg::*;    //schauh1x
    `endif
    `ifdef COMPL_TC
     import svt_ethernet_test_suite_uvm_pkg::*;    //schauh1x
     `ifdef ETH_MULTI_PORT
        import svt_ethernet_test_suite_multi_port_uvm_pkg::*;    //schauh1x
     `endif
    `endif
   `endif
    import altuvm_pkg::*;
    import altuvm_avalon_st_test_pkg::*;
    import altuvm_avalon_mm_test_pkg::*;
	import altuvm_avalon_mm_pkg::*;
    import reset_uvc_pkg::*;
    import vector_uvc_pkg::*;
    typedef enum {C,S,T,D,E} R_TYPE;
    //`include "eth_f_all.vh"
    //`include "eth_f_all_urm.svh"
    `include "tsn_axi_agt_cfg.sv"

    `ifdef ETH_MULTI_PORT
    `include "ll10g_mp_reg_defines.vh"
    `include "ll10g_reg_file.sv"
    `else
      `ifdef ETH_MGE
        `include "mge_reg_defines.vh"
        `include "mge_reg_file.sv"
      `endif
      `ifdef ETH_BASERS10
        `include "baser_reg_define.vh"
        `include "baser_reg_file.sv"
      `endif
      `ifdef ETH_BASERS10_ARRIA
        `include "baser_reg_define.vh"
        `include "baser_reg_file.sv"
      `endif
      `ifdef ETH_MGBASET
        `ifdef DEVICE_SM
        `include "sm_reg_defines.vh"
        `include "sm_reg_file.sv"
        `else
        `include "mge_reg_defines.vh"
        `include "mge_reg_file.sv"
         `endif
      `endif
      `ifdef ETH_NF_10G
        `include "nf_reg_define.vh"
        `include "nf_reg_file.sv"
      `endif
     
     `endif
    `include "gdr_ehip_asm_urm_cover_user.svh"
    `include "gdr_ehip_asm_urm.svh"
    `include "gdr_ehip_p2p_urm_cover_user.svh"
    `include "gdr_ehip_p2p_urm.svh"
    `include "ip758brktop_urm_cover_user.svh"
    `include "ip758brktop_urm.svh"
    `include "gdr_barak_quad_avmm_cfgcsr_urm_cover_user.svh"
    `include "gdr_barak_quad_avmm_cfgcsr_urm.svh"
    `include "gdr_barak_quad_cfg_ctrl_urm.svh"
    `include "gdr_barak_quad_urm.svh"
    `include "gdr_ux_quad_avmm_cfgcsr.vh"
    `include "gdr_ux_quad_avmm_cfgcsr_urm.svh"
    `include "gdr_xcvr_reconfig_urm.svh"
    typedef gdr_xcvr_reconfig_urm xcvr_reconfig_urm; //This is for eth_env_env 
    `include "registers.vh"
    `include "eth_anlt_f_csr_doc.vh"
    `include "eth_anlt_f_csr_doc_urm.svh"
    //`include "registers_urm.svh"
    `include "rsfec_cfgcsr_csr_urm.svh"
    `include "rsfec_cfgcsr_csr.vh"
    //`include "xcvr_reconfig.vh"
    //`include "xcvr_reconfig_urm.svh"
    `include "reg_config.sv"
    `include "reg_top_config.sv"
   //`include "reg_top_model.sv"
    `include "eth_env.sv"
    `include "vector_uvc_scoreboard.sv"
    `include "ethernet_usr_config_66b_block_callbacks.sv"
    `include "ethernet_mac_sb_callbacks.sv"  
    `include "ethernet_mac_rs_fec_err_encoder_callbacks.sv"
    `include "eth_ipg_checker.sv"
    `include "eth_virtual_sequencer.sv"
    `include "eth_top_virtual_sequencer.sv"    
    `include "eth_ref_model.sv"
   // `include "eth_rx_mac_cov.sv" -- Need to add it back after cleaning eth_param_tb requirement
    `include "register_coverage.sv"
    `include "anlt_register_coverage.sv"
	 `include "dm_register_map_params.sv"
    `include "altuvm_avalon_mm_reg_adapter_eth.svh"

    `include "eth_env_env.sv"
    `include "eth_top_env.sv"
     `include "eth_sequence_library.sv"
	`ifdef NON_ANLT_PTP	
     `include "eth_gdr_multi_instance_sanity_sequence.sv"
     `include "eth_gdr_multi_instance_random_sequence.sv"
	`endif 	 
    `ifdef PTP_EN
       `include "eth_gdr_multi_instance_ptp_sanity_sequence.sv"
       `include "eth_gdr_multi_instance_ptp_2step_accuracy_sequence.sv"
    `endif
     `include "eth_gdr_base_test.sv"
//     `include "eth_dr_base_test.sv"
 //    `include "eth_dr_test_lib.sv"
endpackage
