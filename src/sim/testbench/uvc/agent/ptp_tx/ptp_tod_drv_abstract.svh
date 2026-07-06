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


typedef class dyn_rcfg; 
typedef class eth_packet;
typedef class ptp_config;

//typedef  bit[95:0] bit96;
virtual class ptp_tod_drv_abstract extends uvm_report_object;
 
virtual eth_sideband_interface v_if;
dyn_rcfg dyn_rcfg_obj_inst; 
virtual spy_interface spy_if;
ptp_config m_ptp_config;
//virtual client_tx_if#(.NUM_WORDS(16)) v_if_seg;
pure virtual function bit[95:0] get_tod_timestamp();
pure virtual function bit[95:0] get_ing_timestamp();
pure virtual task drv_tod_timestamp();
pure virtual task drv_ing_timestamp(); 
pure virtual task update_tod_ns();
pure virtual task update_tod_seconds();
pure virtual task update_ing_ns();
pure virtual task update_ing_seconds();
pure virtual task drv_rx_tod;
pure virtual task drv_tx_its;
pure virtual task seg_tx_tod_drv;
pure virtual task drv_seg_rx_tod;
pure virtual function clear_all_ts;

endclass
