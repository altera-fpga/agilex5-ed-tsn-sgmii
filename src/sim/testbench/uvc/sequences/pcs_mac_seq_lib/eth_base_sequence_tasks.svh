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


 
 
 //Task: read_and_compare_stats
 //This task will read all stats counter register and compare read value with mirrored value which is predicted in ref model
 task read_and_compare_stats(input bit disable_check=1);
#2000ns;
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,(disable_check||dis_ehip_drop_frame_cntr));
   //Temporary disable for PTP/Non-PTP due to reading X
   // Refer https://hsdes.intel.com/appstore/article/#/1508679051
   //DM_TODO: p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_63_32_OFFSET_REG,read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);

   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_stats_framesOK0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_stats_framesOK1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_stats_framesErr0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_stats_framesErr1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_stats_ifErrors0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(rx_stats_ifErrors1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(tx_stats_framesOK0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(tx_stats_framesOK1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(tx_stats_framesErr0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(tx_stats_framesErr1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(tx_stats_ifErrors0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(tx_stats_ifErrors1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_utcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_utcast_data_err_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   

 endtask : read_and_compare_stats


 task read_and_check_non_zero_stats(input bit disable_check=0);
#2000ns;
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data,disable_check);
   //if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));

   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   if(read_data === 'h0) `uvm_error(get_name(), $sformatf("Read data = %0h : Register should have non zero value here",read_data));

 endtask : read_and_check_non_zero_stats


 //Task to read and check stats registers value for 10G and 25G
task read_1025_stats(input bit disable_rxcheck=0, input bit disable_txcheck=0);
#2000ns;
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_rx_counter["RX_FRAGMENTS_31_0"] ,disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),          stats_rx_counter["RX_JABBERS_31_0"]   ,disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),           stats_rx_counter["RX_FCSERR_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),     stats_rx_counter["RX_CRCERR_OKPKT_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_MCAST_DATA_ERR_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_BCAST_DATA_ERR_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_UCAST_DATA_ERR_31_0"],disable_rxcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_MCAST_CTRL_ERR_31_0"],disable_rxcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_BCAST_CTRL_ERR_31_0"],disable_rxcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_UCAST_CTRL_ERR_31_0"],disable_rxcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_rx_counter["RX_PAUSE_ERR_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),              stats_rx_counter["RX_64B_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),             stats_rx_counter["RX_64B_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),         stats_rx_counter["RX_65to127B_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_rx_counter["RX_65to127B_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_rx_counter["RX_128to255B_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_rx_counter["RX_128to255B_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_rx_counter["RX_256to511B_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_rx_counter["RX_256to511B_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_rx_counter["RX_512to1023B_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),      stats_rx_counter["RX_512to1023B_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),      stats_rx_counter["RX_1024to1518B_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),     stats_rx_counter["RX_1024to1518B_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_rx_counter["RX_1519toMAXB_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),      stats_rx_counter["RX_1519toMAXB_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),         stats_rx_counter["RX_OVERSIZE_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_rx_counter["RX_MCAST_DATA_OK_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_MCAST_DATA_OK_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_rx_counter["RX_BCAST_DATA_OK_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_BCAST_DATA_OK_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_rx_counter["RX_UCAST_DATA_OK_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_UCAST_DATA_OK_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_rx_counter["RX_MCAST_CTRL_OK_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_MCAST_CTRL_OK_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_rx_counter["RX_BCAST_CTRL_OK_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_BCAST_CTRL_OK_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_rx_counter["RX_UCAST_CTRL_OK_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_UCAST_CTRL_OK_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),            stats_rx_counter["RX_PAUSE_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),           stats_rx_counter["RX_PAUSE_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),              stats_rx_counter["RX_RNT_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), stats_rx_counter["RX_Payload_OctetsOK_31_0"],disable_rxcheck);        //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),stats_rx_counter["RX_Payload_OctetsOK_63_32"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["RX_Frame_OctetsOK_31_0"],disable_rxcheck);          //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),  stats_rx_counter["RX_Frame_OctetsOK_63_32"],disable_rxcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),     stats_rx_counter["cntr_rx_dropped_31_0"],disable_rxcheck);            //TODO: Sending
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_rx_counter["cntr_rx_malformed_31_0"],disable_rxcheck);          //TODO: Sending
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),          stats_rx_counter["RX_pfc_err_31_0"],disable_rxcheck);                 //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),              stats_rx_counter["RX_pfc_31_0"],disable_rxcheck);                     //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),             stats_rx_counter["RX_pfc_63_32"],disable_rxcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_rx_counter["cntr_rx_badlt_31_0"],disable_rxcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),           stats_rx_counter["RX_lenerr_31_0"],disable_rxcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),               stats_rx_counter["RX_st_31_0"],disable_rxcheck);                      //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),              stats_rx_counter["RX_st_63_32"],disable_rxcheck);
     
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_tx_counter["TX_FRAGMENTS_31_0"] ,disable_txcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),          stats_tx_counter["TX_JABBERS_31_0"]   ,disable_txcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),           stats_tx_counter["TX_FCSERR_31_0"],disable_txcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),     stats_tx_counter["TX_CRCERR_OKPKT_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_MCAST_DATA_ERR_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_BCAST_DATA_ERR_31_0"],disable_txcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_UCAST_DATA_ERR_31_0"],disable_txcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_MCAST_CTRL_ERR_31_0"],disable_txcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_BCAST_CTRL_ERR_31_0"],disable_txcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_UCAST_CTRL_ERR_31_0"],disable_txcheck);
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_tx_counter["TX_PAUSE_ERR_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),              stats_tx_counter["TX_64B_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),             stats_tx_counter["TX_64B_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),         stats_tx_counter["TX_65to127B_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_tx_counter["TX_65to127B_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_tx_counter["TX_128to255B_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_tx_counter["TX_128to255B_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),        stats_tx_counter["TX_256to511B_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_tx_counter["TX_256to511B_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_tx_counter["TX_512to1023B_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),      stats_tx_counter["TX_512to1023B_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),      stats_tx_counter["TX_1024to1518B_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),     stats_tx_counter["TX_1024to1518B_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_tx_counter["TX_1519toMAXB_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),      stats_tx_counter["TX_1519toMAXB_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),         stats_tx_counter["TX_OVERSIZE_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_tx_counter["TX_MCAST_DATA_OK_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_MCAST_DATA_OK_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_tx_counter["TX_BCAST_DATA_OK_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_BCAST_DATA_OK_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_tx_counter["TX_UCAST_DATA_OK_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_UCAST_DATA_OK_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_tx_counter["TX_MCAST_CTRL_OK_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_MCAST_CTRL_OK_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_tx_counter["TX_BCAST_CTRL_OK_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_BCAST_CTRL_OK_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),    stats_tx_counter["TX_UCAST_CTRL_OK_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_UCAST_CTRL_OK_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),            stats_tx_counter["TX_PAUSE_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),           stats_tx_counter["TX_PAUSE_63_32"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),              stats_tx_counter["TX_RNT_31_0"],disable_txcheck);
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), stats_tx_counter["TX_Payload_OctetsOK_31_0"],disable_txcheck);        //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),stats_tx_counter["TX_Payload_OctetsOK_63_32"],disable_txcheck);       
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["TX_Frame_OctetsOK_31_0"],disable_txcheck);          //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),  stats_tx_counter["TX_Frame_OctetsOK_63_32"],disable_txcheck);         
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),     stats_tx_counter["cntr_tx_dropped_31_0"],disable_txcheck);            //TODO: Sending
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),   stats_tx_counter["cntr_tx_malformed_31_0"],disable_txcheck);          //TODO: Sending
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),          stats_tx_counter["TX_pfc_err_31_0"],disable_txcheck);                 //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),              stats_tx_counter["TX_pfc_31_0"],disable_txcheck);                     //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),             stats_tx_counter["TX_pfc_63_32"],disable_txcheck);                    
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),       stats_tx_counter["cntr_tx_badlt_31_0"],disable_txcheck);              
     //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),           stats_tx_counter["TX_lenerr_31_0"],disable_txcheck);                  
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),               stats_tx_counter["TX_st_31_0"],disable_txcheck);                      //TODO: Sending
     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),              stats_tx_counter["TX_st_63_32"],disable_txcheck);

endtask : read_1025_stats

 task read_and_compare_tx_error_stats(input bit disable_check=0);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //Temporary disable for PTP/Non-PTP due to reading X
   // Refer https://hsdes.intel.com/appstore/article/#/1508679051
   //DM_TODO: p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_63_32_OFFSET_REG,read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   
   //Disabling some registers' checking for tx_error insetion(FB - 515409 , EHIP spec. 5.5.3.5 - DUT behavior unpredictable) 

   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
  
   //HSD : 16013665614
   if(disable_check != 1) begin
     // HSD 16011665451
     if( read_data >= ( p_sequencer.env.eth_ref_model_inst.tx_payload_ok_cntr[31:0] ) && 
       read_data <= ( p_sequencer.env.eth_ref_model_inst.tx_octet_error + 
                      p_sequencer.env.eth_ref_model_inst.tx_payload_ok_cntr[31:0] ) )
        `uvm_info("check_tx_status", $sformatf("TX_PAYLOAD_OCTET value is %0d which is under expected margin of %0d",p_sequencer.env.eth_ref_model_inst.tx_payload_ok_cntr[31:0],p_sequencer.env.eth_ref_model_inst.tx_octet_error), UVM_NONE)
     else 
      `uvm_error("check_tx_status", $sformatf("TX_PAYLOAD_OCTET value is %0d which is not under expected margin of %0d",p_sequencer.env.eth_ref_model_inst.tx_payload_ok_cntr[31:0],p_sequencer.env.eth_ref_model_inst.tx_octet_error));
   end

   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);

   //HSD : 16013665614
   if(disable_check != 1) begin
     if( read_data >= ( p_sequencer.env.eth_ref_model_inst.tx_frame_ok_cntr[31:0] ) && 
       read_data <= ( p_sequencer.env.eth_ref_model_inst.tx_octet_error + 
                      p_sequencer.env.eth_ref_model_inst.tx_frame_ok_cntr[31:0] ) )
       `uvm_info("check_tx_status", $sformatf("TX_OCTET value is %0d which is under expected margin of %0d",p_sequencer.env.eth_ref_model_inst.tx_frame_ok_cntr[31:0],p_sequencer.env.eth_ref_model_inst.tx_octet_error), UVM_NONE)
     else 
      `uvm_error("check_tx_status", $sformatf("TX_OCTET value is %0d which is not under expected margin of %0d",p_sequencer.env.eth_ref_model_inst.tx_payload_ok_cntr[31:0],p_sequencer.env.eth_ref_model_inst.tx_octet_error));
   end

   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);

 endtask : read_and_compare_tx_error_stats

 task read_and_compare_malformed_stats(input bit disable_check=1);
#2000ns;
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //Temporary disable for PTP/Non-PTP due to reading X
   // Refer https://hsdes.intel.com/appstore/article/#/1508679051
   //DM_TODO: p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_63_32_OFFSET_REG,read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);

   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_dropped_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_malformed_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_badlt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_lenerr_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);

 endtask : read_and_compare_malformed_stats

task read_bcast_regs();
   #2000ns;
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
endtask:read_bcast_regs

task read_mcast_regs();
   #2000ns;
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
endtask:read_mcast_regs

task read_ucast_regs();
   #2000ns;
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
endtask:read_ucast_regs
task read_and_compare_destination_address_regs();
   #2000ns;
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   //DM_TODO: p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
endtask:read_and_compare_destination_address_regs

 //task send_random_frames(int transaction_count)
 //This task will send random frames with transaction_count
//Shabbir: To reproduce issue of FB 596537, I had to add support for not inserting FCS error
 task send_random_frames(int transaction_count, bit tx_error_en = 0, bit do_not_insert_fcs_err=0);
    int rx_count=0;
    int tx_count=0;

    fork
    begin//begin1
    `ifdef ENABLE_ETH_VIP
      `uvm_info("send_random_frames", "send random RX frames", UVM_NONE)
      repeat (transaction_count) begin
        randcase
        1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME undersize with FCS, Target Reg:RX FRAGMENTS",rx_count), UVM_NONE)
            //FIXME Shabbir: update random range after FB476157 fix
             //send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(18,63));
             send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63),.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

        1: begin
          rx_count++;
          `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME oversize with FCS, Target Reg:RX JABBERS",rx_count), UVM_NONE)
          send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+1000),.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

        1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with FCS, Target Reg:RX FCSERR",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

        1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: DATA_FRAME with FCS, Target Reg:RX CRCERR_OKPKT",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: MCAST_DATA_FRAME with FCS, Target Reg:RX MCAST_DATA_ERR",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: BCAST_DATA_FRAME with FCS, Target Reg:RX BCAST_DATA_ERR",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: UCAST_DATA_FRAME with FCS, Target Reg:RX UCAST_DATA_ERR",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: MCAST_CTRL_FRAME with FCS, Target Reg:RX MCAST_CTRL_ERR",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: BCAST_CTRL_FRAME with FCS, Target Reg:RX BCAST_CTRL_ERR",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: UCAST_CTRL_FRAME with FCS, Target Reg:RX UCAST_CTRL_ERR",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

        1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: SFC_FRAME with FCS, Target Reg:RX PAUSE_ERR",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,SFC_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 64B, Target Reg:RX 64B",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 65to127B, Target Reg:RX 65to127B",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(65,127)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 128to255B, Target Reg:RX 128to255B",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(128,255)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 256to511B, Target Reg:RX 256to511B",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(256,511)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 512to1023B, Target Reg:RX 512to1023B",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(512,1023)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 1024to1518B, Target Reg:RX 1024to1518B",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(1024,1518)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 1519toMAXB, Target Reg:RX 1519toMAXB",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(1519,rx_max_frame_size)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with oversize, Target Reg:RX OVERSIZE",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(rx_max_frame_size+1,rx_max_frame_size+1000)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: MCAST_DATA_FRAME without FCS, Target Reg:RX MCAST_DATA_OK",rx_count), UVM_NONE)
             send_eth_frame(MCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: BCAST_DATA_FRAME without FCS, Target Reg:RX BCAST_DATA_OK",rx_count), UVM_NONE)
             send_eth_frame(BCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: UCAST_DATA_FRAME without FCS, Target Reg:RX UCAST_DATA_OK",rx_count), UVM_NONE)
             send_eth_frame(UCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: MCAST_CTRL_FRAME without FCS, Target Reg:RX MCAST_CTRL_OK",rx_count), UVM_NONE)
             send_eth_frame(MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: BCAST_CTRL_FRAME without FCS, Target Reg:RX BCAST_CTRL_OK",rx_count), UVM_NONE)
             send_eth_frame(BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);
           end

           1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: UCAST_CTRL_FRAME without FCS, Target Reg:RX UCAST_CTRL_OK",rx_count), UVM_NONE)
             send_eth_frame(UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);
           end

        1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: SFC_FRAME without FCS, Target Reg:RX PAUSE",rx_count), UVM_NONE)
             send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,1);
           end

        1: begin
            rx_count++;
            `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: DATA_FRAME with less than 64Bytes, Target Reg:RX RNT",rx_count), UVM_NONE)
            //FIXME Shabbir: update random range after FB476157 fix
            //send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(18,63)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
            send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(46,63)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

        //PAUSE reg should not increment
        1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: PFC_FRAME without FCS",rx_count), UVM_NONE)
             send_eth_frame(PFC_FRAME,ETH_VIP_AVL_RX,1);
           end

        1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: PFC_FRAME with FCS",rx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,PFC_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
           end

        1: begin
             rx_count++;
             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with invalid length/type, Target Reg:badlt",rx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1519,1553)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
           end

        1: begin 
             rx_count++;
//             `uvm_info("send_random_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with length error, Target Reg:lenerr",rx_count), UVM_NONE)
//             send_eth_frame_with_length_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);
             randcase
             1 : begin 
                   rx_count++;
                   `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: ETH_DATA_FRAME with length error, Target Reg:lenerr",rx_count), UVM_NONE)
                   send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);
                 end
             1 : begin 
                   rx_count++;
                   `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: ETH_VLAN_FRAME with length error, Target Reg:lenerr",rx_count), UVM_NONE)
                   send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,-1);
                 end
             1 : begin 
                   rx_count++;
                   `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: ETH_STACKED_VLAN_FRAME with length error, Target Reg:lenerr",rx_count), UVM_NONE)
                   send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,-1);
                 end
             endcase     
           end
        endcase
      end//repeat (transaction_count)
    `endif//ifdef ENABLE_ETH_VIP
    end//fork...begin1

    begin//begin2
    //FIXME Shabbir: TX error support required
      `uvm_info("send_random_frames", "send random TX frames", UVM_NONE)
      repeat (transaction_count) begin
        randcase
        1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: DATA_FRAME undersize with FCS, Target Reg:TX FRAGMENTS",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(18,63));
             end else begin
               send_eth_frame_with_tx_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(18,63));
             end
           end

         1: begin
           tx_count++;
           `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: DATA_FRAME oversize with FCS, Target Reg:TX JABBERS",tx_count), UVM_NONE)
           if(tx_error_en == 0)begin
             send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+1000));
           end else begin
             send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+1000));
           end
         end

        1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with FCS, Target Reg:TX FCSERR",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
             end else begin
               send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
             end             
           end

        1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: DATA_FRAME with FCS, Target Reg:TX CRCERR_OKPKT",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
             end else begin
               send_eth_frame_with_tx_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
             end
           end

         1: begin
           tx_count++;
           `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: MCAST_DATA_FRAME with FCS, Target Reg:TX MCAST_DATA_ERR",tx_count), UVM_NONE)
           if(tx_error_en == 0)begin
             send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
           end else begin
             send_eth_frame_with_tx_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
           end                      
         end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: BCAST_DATA_FRAME with FCS, Target Reg:TX BCAST_DATA_ERR",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);             
             end else begin
               send_eth_frame_with_tx_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
             end               
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: UCAST_DATA_FRAME with FCS, Target Reg:TX UCAST_DATA_ERR",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
             end else begin
               send_eth_frame_with_tx_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
             end
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: MCAST_CTRL_FRAME with FCS, Target Reg:TX MCAST_CTRL_ERR",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
             end else begin
               send_eth_frame_with_tx_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
             end
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: BCAST_CTRL_FRAME with FCS, Target Reg:TX BCAST_CTRL_ERR",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
             end else begin
               send_eth_frame_with_tx_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
             end
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: UCAST_CTRL_FRAME with FCS, Target Reg:TX UCAST_CTRL_ERR",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
             end else begin
               send_eth_frame_with_tx_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
             end
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: SFC_FRAME with FCS, Target Reg:TX PAUSE_ERR",tx_count), UVM_NONE)
             if(tx_error_en == 0)begin
               send_eth_frame_with_fcs_error(1,SFC_FRAME,AVL_TX_ETH_VIP,-1);
             end else begin
               send_eth_frame_with_tx_error(1,SFC_FRAME,AVL_TX_ETH_VIP,-1);
             end
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 64B, Target Reg:TX 64B",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(64),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 65to127B, Target Reg:TX 65to127B",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(65,127)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 128to255B, Target Reg:TX 128to255B",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(128,255)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 256to511B, Target Reg:TX 256to511B",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(256,511)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 512to1023B, Target Reg:TX 512to1023B",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(512,1023)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 1024to1518B, Target Reg:TX 1024to1518B",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(1024,1518)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 1519toMAXB, Target Reg:TX 1519toMAXB",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(1519,tx_max_frame_size)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with oversize, Target Reg:TX OVERSIZE",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(tx_max_frame_size+1,tx_max_frame_size+1000)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: MCAST_DATA_FRAME without FCS, Target Reg:TX MCAST_DATA_OK",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(MCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: BCAST_DATA_FRAME without FCS, Target Reg:TX BCAST_DATA_OK",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(BCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: UCAST_DATA_FRAME without FCS, Target Reg:TX UCAST_DATA_OK",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: MCAST_CTRL_FRAME without FCS, Target Reg:TX MCAST_CTRL_OK",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,-1,1,AVL_TX_ETH_VIP);
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: BCAST_CTRL_FRAME without FCS, Target Reg:TX BCAST_CTRL_OK",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,-1,1,AVL_TX_ETH_VIP);
           end

           1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: UCAST_CTRL_FRAME without FCS, Target Reg:TX UCAST_CTRL_OK",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,-1,1,AVL_TX_ETH_VIP);
           end

        1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: SFC_FRAME without FCS, Target Reg:TX PAUSE",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(SFC_FRAME,-1,1,AVL_TX_ETH_VIP);
           end

        1: begin
            tx_count++;
            `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: DATA_FRAME with less than 64Bytes, Target Reg:TX RNT",tx_count), UVM_NONE)
            send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(18,63)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

        //PAUSE reg should not increment
        1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: PFC_FRAME without FCS",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(PFC_FRAME,-1,1,AVL_TX_ETH_VIP);
           end

        1: begin
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: PFC_FRAME with FCS, Target Reg:TX PAUSE_ERR",tx_count), UVM_NONE)
             send_eth_frame_with_fcs_error(1,PFC_FRAME,AVL_TX_ETH_VIP,-1);
           end

        1: begin 
             tx_count++;
             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with invalid length/type , Target Reg:badlt",tx_count), UVM_NONE)
             send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1519,1553)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
           end

        1: begin
             tx_count++;
//             `uvm_info("send_random_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with length error, Target Reg:lenerr",tx_count), UVM_NONE)
//             send_eth_frame_with_length_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
             randcase
             1 : begin 
                   tx_count++;
                   `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: ETH_DATA_FRAME with length error, Target Reg:lenerr",tx_count), UVM_NONE)
                   send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
                 end
             1 : begin 
                   tx_count++;
                   `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: ETH_VLAN_FRAME with length error, Target Reg:lenerr",tx_count), UVM_NONE)
                   send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,-1);
                 end
             1 : begin 
                   tx_count++;
                   `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: ETH_STACKED_VLAN_FRAME with length error, Target Reg:lenerr",tx_count), UVM_NONE)
                   send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,-1);
                 end
             endcase  	
           end
        endcase
      end//repeat (transaction_count)
    end//fork....begin2
    join//fork
 endtask : send_random_frames


  task apply_rst_to_clear_stat_reg();
    uvm_reg_data_t read_data_tx;
    uvm_reg_data_t read_data_rx;

    //reset randomly
    randcase
    1: begin
         //apply csr_rst_n
         // Resets full IP. Includes transmit and receive MACs, PCS, adapters, transceivers, as well as configuration and status registers. Active low
         //leads to deassertion of both tx_lanes_stable and rx_pcs_ready signals
         `uvm_info("apply_rst_to_clear_stat_reg", " apply csr_rst_n", UVM_NONE)
	 p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period($urandom_range(10,20)));
         
	 p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
       end
    1: begin
         //apply soft reset eio_sys_rst
         // Resets full IP similar to csr_rst_n except configuration registers
         //leads to deassertion of both tx_lanes_stable and rx_pcs_ready signals
         //FIXME Shabbir: for 40G, eio_sys_rst and tx_lanes_stable are not aligned and getting VIP RX errors before tx_lanes_stable goes low, so ignoring these errors. FB495347
         //`ifdef G40
         //`ifdef ENABLE_ETH_VIP
         //p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         //p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
         //p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
         //p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
         //`endif
         //`endif

         `uvm_info("apply_rst_to_clear_stat_reg", "5. apply soft reset eio_sys_rst", UVM_NONE)
         p_sequencer.env.apply_reset(.rst_type("soft"),.ip_rst(1));
         
	 p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

         //`ifdef G40
         //`ifdef ENABLE_ETH_VIP
         //p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
         //p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
         //p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
         //p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::ERROR);
         //`endif
         //`endif

         //EHIP Shabbir: eio_sys_rst will reset CSRs so no need to explicitly clear_stat_counters
         //`ifdef ENABLE_ETH_VIP
         //`uvm_info("apply_rst_to_clear_stat_reg", "Read stat registers. They should retain values", UVM_NONE)
         //read_and_compare_stats();

         //`uvm_info("apply_rst_to_clear_stat_reg", "Write to CNTR_CONFIG reg to clear stat registers", UVM_NONE)
         //clear_stat_counters();
         //#400ns;
         //`endif
       end
    endcase

    //EHIP Shabbir: in EHIP, eio_sys_rst will reset the CSRs. FB 517791
    //FIXME EHIP Shabbir: FB 505364, need to fix DV, scripts
    //DM_TODO: p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);

    `ifdef ENABLE_ETH_VIP
    `uvm_info("apply_rst_to_clear_stat_reg", "Check stats registers are cleared", UVM_NONE)
    read_and_compare_stats();
    //Need to demote error again for tx error insertion as wait_rx_pcs_ready enables those errors
    enable_tx_error_insertion();
    `endif
 endtask: apply_rst_to_clear_stat_reg

// frame_size = -1 : random payload, else fix paylod(calculated based on frame size and frame type)
 task send_eth_frame_with_fcs_error(int frame_num = 1,frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int f_size = -1, bit do_not_insert_fcs_err=0, bit is_ptp = 0,ptp_op_e ptp_op=INS_NOOP,bit ucast_en=0, bit[47:0] unicast_addr=0,bit frame_length_64 = 0);
  bit l_crc_pass = 1;
  registers_urm reg_model;
  uvm_reg_data_t tx_crc_control;
  uvm_reg_data_t tx_pad_control;
  uvm_reg 	regs;
  l_crc_pass = p_sequencer.env.dyn_rcfg_obj_inst.crc_pass; 
  `ifdef ENABLE_ETH_VIP
   if(path == ETH_VIP_AVL_RX) begin
     alt_eth_error_vip_base_sequence err_seq;

     `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)

     `uvm_info("send_eth_frame_with_fcs_error", $sformatf("Path - ETH_VIP_AVL_RX : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);
     if(do_not_insert_fcs_err==0) begin
       p_sequencer.env.mac_callback.enable_fcs_err = 1; //Workaround for injecting FCS error using call back, SNPS case#8001153887
     end
          
     err_seq.send_fcs_error_frame(.no_of_frames(frame_num),.eth_frame(f_type),.frame_size(f_size),.ucast_en(ucast_en),.unicast_addr(unicast_addr),.frame_length_64(frame_length_64));
     
     p_sequencer.env.mac_callback.enable_fcs_err = 0; //Disable FCS error injection
     
   end  
  `endif

   if(path == AVL_TX_ETH_VIP) begin
     alt_eth_avalonst_base_sequence avl_tx_pkt;
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
     end
     else begin
        `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
     end

     `uvm_info("send_eth_frame_with_fcs_error", $sformatf("Path - AVL_TX_ETH_VIP : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);
     tx_crc_control = p_sequencer.env.gdr_ral_get("tx_crc_control");
     tx_pad_control = p_sequencer.env.gdr_ral_get("tx_pad_control");
     if((tx_pad_control[0]==1'b0) && (f_size < 'd64)) begin //If padding is disabled, client should not send undersized frames
       f_size = 'd64;
     end
     if((tx_pad_control[0]==1'b0) && (f_type == UNDERSIZE_FRAME)) begin //If padding is disabled, client should not send undersized frames
       f_type = DATA_FRAME;
     end
     if(tx_crc_control[1] == 1'b0) begin //Insert error only when CRC has to be calculated and sent from AvST
        `uvm_info("eth_base_sequence_task", "crc included by AVST", UVM_NONE)
         avl_tx_pkt.send_eth_frames_avalon_tx_with_fcs_error(.no_of_frames(frame_num),.eth_frame(f_type),.frame_size(f_size),.crc_pass(l_crc_pass),.is_ptp(is_ptp),.ptp_op(ptp_op),.ucast_en(ucast_en),.unicast_addr(unicast_addr));//Inserting incorrect Tx FCS and driving l8/l2 tx error randomly
     end
     else begin
        `uvm_info("eth_base_sequence_task", "crc included by MAC", UVM_NONE)
        avl_tx_pkt.send_eth_frames_avalon_tx(.no_of_frames(1),.eth_frame(f_type),.frame_size(f_size),.crc_pass(l_crc_pass));
     end
     
   end 
 endtask : send_eth_frame_with_fcs_error

task send_vlan_control_pause_frame(int frame_num = 1,frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int f_size = -1, bit is_ptp = 0,ptp_op_e ptp_op=INS_NOOP, bit [47:0]dest_address = 48'h0,int length_type_value = 0);
  bit l_crc_pass = 1;
  l_crc_pass = p_sequencer.env.dyn_rcfg_obj_inst.crc_pass; 

   `ifdef ENABLE_ETH_VIP
   if(path == ETH_VIP_AVL_RX) begin
     alt_eth_vip_base_sequence base_seq;

     `uvm_create_on(base_seq,p_sequencer.eth_vip_seqr_inst)

     `uvm_info("send_eth_frame_with_fix_size", $sformatf("Path - ETH_VIP_AVL_RX : sending %0d %0s frame with frame size = %0d",frame_num,f_type,f_size),UVM_NONE);
     base_seq.send_vlan_control_rx_frame(.eth_frame(f_type),.frame_size(f_size),.no_of_frame(frame_num),.dest_address(dest_address),.length_type_value(length_type_value));
   end  
  `endif


   if(path == AVL_TX_ETH_VIP) begin
     alt_eth_avalonst_base_sequence avl_tx_pkt;
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
     end
     else begin
     `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
     end
     `uvm_info("send_eth_frame_with_length_error", $sformatf("Path - AVL_TX_ETH_VIP : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);
     avl_tx_pkt.send_vlan_control_pause_eth_frame(.no_of_frames(frame_num),.frame_size(f_size),.dest_address(dest_address));//Inserting length error 
     
   end  
 endtask : send_vlan_control_pause_frame

 task send_eth_frame_with_tx_error(int frame_num = 1,frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int f_size = -1, bit is_ptp = 0,ptp_op_e ptp_op=INS_NOOP);

  bit l_crc_pass = 1;
  l_crc_pass = p_sequencer.env.dyn_rcfg_obj_inst.crc_pass; 

   if(path == AVL_TX_ETH_VIP) begin
     alt_eth_avalonst_base_sequence avl_tx_pkt;
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
     end
     else begin
     `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
     end
     `uvm_info("send_eth_frame_with_tx_error", $sformatf("Path - AVL_TX_ETH_VIP : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);
     avl_tx_pkt.send_eth_frames_avalon_tx_with_tx_error(frame_num,f_type,f_size,l_crc_pass,is_ptp,ptp_op);//Inserting incorrect Tx FCS and driving l8/l2 tx error randomly
     
   end 
 endtask : send_eth_frame_with_tx_error

 task send_eth_frame_with_length_error(int frame_num = 1,frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int f_size = -1, bit is_ptp = 0,ptp_op_e ptp_op=INS_NOOP, bit [47:0]dest_address = 48'h0,int length_type_value = 0);
  bit l_crc_pass = 1;
  l_crc_pass = p_sequencer.env.dyn_rcfg_obj_inst.crc_pass; 

  `ifdef ENABLE_ETH_VIP
   if(path == ETH_VIP_AVL_RX) begin
     alt_eth_error_vip_base_sequence err_seq;

     `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)

     `uvm_info("send_eth_frame_with_length_error", $sformatf("Path - ETH_VIP_AVL_RX : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);

     err_seq.send_length_error_frame(.no_of_frames(frame_num),.eth_frame(f_type),.frame_size(f_size),.dest_address(dest_address),.length_type_value(length_type_value));
	  
   end  
  `endif

   if(path == AVL_TX_ETH_VIP) begin
     alt_eth_avalonst_base_sequence avl_tx_pkt;
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
     end
     else begin
     `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
     end
     `uvm_info("send_eth_frame_with_length_error", $sformatf("Path - AVL_TX_ETH_VIP : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);
     avl_tx_pkt.send_eth_frames_avalon_tx_with_length_error(.no_of_frames(frame_num),.eth_frame(f_type),.frame_size(f_size),.crc_pass(l_crc_pass),.is_ptp(is_ptp),.ptp_op(ptp_op),.length_type_value(length_type_value));//Inserting length error 
     
   end  
 endtask : send_eth_frame_with_length_error

task send_eth_frame_with_sfd_preamble_error(int frame_num = 1,frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int f_size = -1);
  bit l_crc_pass = 1;
  l_crc_pass = p_sequencer.env.dyn_rcfg_obj_inst.crc_pass; 

  `ifdef ENABLE_ETH_VIP
   if(path == ETH_VIP_AVL_RX) begin
     alt_eth_error_vip_base_sequence err_seq;

     `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)

     `uvm_info("send_eth_frame_with_sfd_preamble_error", $sformatf("Path - ETH_VIP_AVL_RX : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);
	 
	 p_sequencer.env.mac_callback.enable_sfd_preamble_err = 1; //Workaround for injecting sfd/preamble error using call back, SNPS case#8001153887
	 
     err_seq.send_sfd_preamble_error_frame(.no_of_frames(frame_num),.eth_frame(f_type),.frame_size(f_size));
	 
	 p_sequencer.env.mac_callback.enable_sfd_preamble_err = 0; //Workaround, to disable sfd/preamble injection
	 
   end  
  `endif
 endtask : send_eth_frame_with_sfd_preamble_error

 task send_eth_frame_with_malformed_error(int frame_num = 1,frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int f_size = -1,bit [47:0]dest_address = 48'h0);
  bit l_crc_pass = 1;
  l_crc_pass = p_sequencer.env.dyn_rcfg_obj_inst.crc_pass; 

  `ifdef ENABLE_ETH_VIP
   if(path == ETH_VIP_AVL_RX) begin
     alt_eth_error_vip_base_sequence err_seq;

     `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)

     `uvm_info("send_eth_frame_with_malformed_error", $sformatf("Path - ETH_VIP_AVL_RX : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);
    
      p_sequencer.env.mac_callback.enable_malformed_err = 1; //Workaround for injecting malformed error using call back, SNPS case#8001153887

      err_seq.send_malformed_error_frame(.no_of_frames(frame_num),.eth_frame(f_type),.frame_size(f_size),.dest_address(dest_address));

      p_sequencer.env.mac_callback.enable_malformed_err = 0; //Workaround, to disable malformed error injection

   end  
  `endif
 endtask : send_eth_frame_with_malformed_error

 task send_eth_frame_with_error_in_between(int frame_num = 1,frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int f_size = -1);

  bit l_crc_pass = 1;
  l_crc_pass = p_sequencer.env.dyn_rcfg_obj_inst.crc_pass; 

  `ifdef ENABLE_ETH_VIP
   if(path == ETH_VIP_AVL_RX) begin
     alt_eth_error_vip_base_sequence err_seq;

     `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)

     `uvm_info("send_eth_frame_with_error_in_between", $sformatf("Path - ETH_VIP_AVL_RX : sending %0d %0s frame with frame size = %0d",frame_num,f_type.name(),f_size),UVM_NONE);
	 
	 p_sequencer.env.mac_callback.enable_error_inside_err = 1; //Workaround for injecting error_inside error using call back, SNPS case#8001153887
	 
     err_seq.send_error_inside_frame(.no_of_frames(frame_num),.eth_frame(f_type),.frame_size(f_size));
	 
	 p_sequencer.env.mac_callback.enable_error_inside_err = 0; //Workaround, to disable error_inside error injection
	 
   end  
  `endif
 endtask : send_eth_frame_with_error_in_between

 task send_eth_frame_with_fix_size(frame_type eth_frame = DATA_FRAME, int frame_size = -1, int no_of_frame = 1, xfer_path path = AVL_TX_ETH_VIP,int unicast_addr =0, bit [47:0]ucast_addr=0,int frame_length_64=0,  bit misc_control_frame=0);
  bit l_crc_pass = 1;
  uvm_reg_data_t tx_crc_control;
  uvm_reg_data_t tx_pad_control;

  l_crc_pass = p_sequencer.env.dyn_rcfg_obj_inst.crc_pass; 
  `ifdef ENABLE_ETH_VIP
   if(path == ETH_VIP_AVL_RX) begin
     alt_eth_vip_base_sequence base_seq;

     `uvm_create_on(base_seq,p_sequencer.eth_vip_seqr_inst)

     `uvm_info("send_eth_frame_with_fix_size", $sformatf("Path - ETH_VIP_AVL_RX : sending %0d %0s frame with frame size = %0d",no_of_frame,eth_frame,frame_size),UVM_NONE);
     base_seq.send_fix_size_eth_frame(eth_frame,frame_size,no_of_frame,unicast_addr,ucast_addr);
   end  
  `endif

   if(path == AVL_TX_ETH_VIP) begin
     alt_eth_avalonst_base_sequence avl_tx_pkt;

     if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
     end
     else begin
     `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
     end
     `uvm_info("send_eth_frame_with_fix_size", $sformatf("Path - AVL_TX_ETH_VIP, frame type is %0s, frame_size is %0d",eth_frame.name(),frame_size),UVM_NONE);
     tx_crc_control = p_sequencer.env.gdr_ral_get("tx_crc_control");
     tx_pad_control = p_sequencer.env.gdr_ral_get("tx_pad_control");
     if((tx_pad_control[0]==1'b0) && (frame_size < 'd64)) begin
       frame_size = 'd64;
     end
     if((tx_pad_control[0]==1'b0) && (eth_frame == UNDERSIZE_FRAME)) begin //If padding is disabled, client should not send undersized frames
       eth_frame = DATA_FRAME;
     `uvm_info("send_eth_frame_with_fix_size", $sformatf("Path - AVL_TX_ETH_VIP Updating undersize frame to data frame: sending %0d %0s frame with frame size = %0d",no_of_frame,eth_frame.name(),frame_size),UVM_NONE);
     end
     `uvm_info("send_eth_frame_with_fix_size", $sformatf("Path - AVL_TX_ETH_VIP : sending %0d %0s frame with frame size = %0d",no_of_frame,eth_frame.name(),frame_size),UVM_NONE);
     avl_tx_pkt.send_eth_frames_avalon_tx(.no_of_frames(no_of_frame),.eth_frame(eth_frame),.frame_size(frame_size),.crc_pass(l_crc_pass), .unicast_addr(unicast_addr),.ucast_addr(ucast_addr),.frame_length_64(frame_length_64),.misc_control_frame(misc_control_frame));
   end
 endtask : send_eth_frame_with_fix_size

  task apply_shadow_request();
    uvm_reg_data_t read_data;
    `uvm_info("apply_shadow_request", "Write to CONFIG_CTRL reg for shadow request 1", UVM_NONE)
  //DM_TODO:  randcase
  //DM_TODO:  1: begin
  //DM_TODO:        p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_config_ctrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b11);
  //DM_TODO:        `uvm_info("apply_shadow_request", "Wait till TX/RX shadow request is granted", UVM_NONE)
  //DM_TODO:        while(read_data[0]==0 || read_data[1]==0) begin
  //DM_TODO:          p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
  //DM_TODO:        end
  //DM_TODO:        //To update eth_ref_model local signals in check_to_clr_stat_cntr task
  //DM_TODO:        p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
  //DM_TODO:    end
  //DM_TODO: 1: begin
  //DM_TODO:      p_sequencer.env.sideband_if.snapshot_en = 1;
  //DM_TODO:      `uvm_info("apply_shadow_request", $sformatf("snapshot_en = %0d",p_sequencer.env.sideband_if.snapshot_en),UVM_NONE);
  //DM_TODO:      while(read_data[0]==0 || read_data[1]==0) begin
  //DM_TODO:      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
  //DM_TODO:       end
  //DM_TODO:    end 
  //DM_TODO: endcase
  endtask: apply_shadow_request

 task apply_adapter_shadow_request();
    // TODO  Need to add condition for shadow request register Fb:596887
    `uvm_info("apply_adapter_shadow_request", "Write to CNTR_CONFIG reg for shadow request 1", UVM_NONE)
     begin
         p_sequencer.env.sideband_if.snapshot_en = 1;
         //`uvm_info("apply_shadow_request", $sformatf("snapshot_en = %0d",p_sequencer.env.master_agent.mast_agt_if.snapshot_en),UVM_NONE);
       end 
 endtask: apply_adapter_shadow_request

  task clear_shadow_request();
    uvm_reg_data_t read_data;
    `uvm_info("clear_shadow_request", "Read to CONFIG_CTRL reg for shadow request 0", UVM_NONE)
    //DM_TODO: if(p_sequencer.env.sideband_if.snapshot_en != 1 ) begin
    //DM_TODO:      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_cfg_config_ctrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //DM_TODO:      read_data='b00;
    //DM_TODO:      `uvm_info("clear_shadow_request", "Write to CONFIG_CTRL reg for shadow request 0", UVM_NONE)
    //DM_TODO:      p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_config_ctrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    //DM_TODO:      `uvm_info("clear_shadow_request", "Wait till TX/RX shadow request is granted", UVM_NONE)
    //DM_TODO:      read_data='b11;
    //DM_TODO:      while(read_data[0]==1 || read_data[1]==1) begin
    //DM_TODO:      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
    //DM_TODO:     end
    //DM_TODO:     //To update eth_ref_model local signals in check_to_clr_stat_cntr task
    //DM_TODO:      p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
    //DM_TODO:   end       
	//DM_TODO: 
    //DM_TODO: else begin
    //DM_TODO:   p_sequencer.env.sideband_if.snapshot_en = 0;
    //DM_TODO:   p_sequencer.env.eth_ref_model_inst.predict_stats_registers();
    //DM_TODO: end
  endtask: clear_shadow_request

  task clear_stat_counters();
    uvm_reg_data_t read_data_tx;
    uvm_reg_data_t read_data_rx;
    
    `uvm_info("clear_stat_counters", "Read to TX/RX STAT CLR reg for stat counters", UVM_NONE)
     p_sequencer.env.reg_read(`GET_REG_ADDR(tx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx);
     p_sequencer.env.reg_read(`GET_REG_ADDR(rx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx);
     read_data_tx[0] = 1;
     read_data_rx[0] = 1;
     `uvm_info("clear_stat_counters", "Write to TX/RX STAT CLR reg for stat counters", UVM_NONE)
     p_sequencer.env.reg_write(`GET_REG_ADDR(tx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx);
     p_sequencer.env.reg_write(`GET_REG_ADDR(rx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx);
     
     p_sequencer.env.reg_read(`GET_REG_ADDR(tx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
     if(read_data_tx[0]==1) begin
       `uvm_error("clear_stat_counters", $sformatf("tx_stats_clr is not getting auto-cleared"));
     end
     p_sequencer.env.reg_read(`GET_REG_ADDR(rx_stats_clr_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
     if(read_data_rx[0]==1) begin
       `uvm_error("clear_stat_counters", $sformatf("rx_stats_clr is not getting auto-cleared"));
     end

  endtask: clear_stat_counters

  function void dis_vec_sb();
    `uvm_info("dis_vec_sb", "Disable vector SB", UVM_NONE)
    p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
    p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
  endfunction: dis_vec_sb
  
  function enable_tx_error_insertion ();
  
`ifdef ENABLE_ETH_VIP

      p_sequencer.env.sb_mac_tx_vip_rx.tx_error_insertion_test = 1;
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_flowcontrol_rsvrd_fields_within_paus_frame_not_zeroes.set_default_fail_effect(svt_err_check_stats::IGNORE);
      
      if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) begin
          p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end
      else if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G) begin
          p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end
      
`endif

  endfunction : enable_tx_error_insertion

 //Task: read_and_compare_frame_size_reg
 //This task will read all stats counter register and compare read value with mirrored value which is predicted in ref model
 task read_and_compare_frame_size_reg();
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
 endtask : read_and_compare_frame_size_reg  

 //Task: read_max_frame_size
//This task will Read register to get max_frame_size
task read_max_frame_size();
  //Read register to get max_frame_size
  p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
  p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
endtask: read_max_frame_size

 //task send_directed_frames(int repeat_count=1)
 //This task will send directed frames to make sure all stat counters incrementsto make sure all stat counters increments 
//Shabbir: To reproduce issue of FB 596537, I had to add support for not inserting FCS error
 task send_directed_frames(int repeat_count=1, bit tx_error_en = 0, bit do_not_insert_fcs_err=0);
    int rx_count=0;
    int tx_count=0;
    int rx_rpt_cnt=0;
    int tx_rpt_cnt=0;

    repeat(repeat_count) begin
    fork
    begin//begin1
    `ifdef ENABLE_ETH_VIP
    //FIXME Shabbir: figure out which other type of frames required to cover all stat counters
    `uvm_info("send_directed_frames", "send directed kind of RX frames to make sure all stat counters increments", UVM_NONE)
    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME undersize with FCS, Target Reg:RX FRAGMENTS",rx_count), UVM_NONE)
        //FIXME Shabbir: update random range after FB476157 fix
        //send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(18,63));
        send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63),.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME oversize with FCS, Target Reg:RX JABBERS",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+1000),.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with FCS, Target Reg:RX FCSERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: DATA_FRAME with FCS, Target Reg:RX CRCERR_OKPKT",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: MCAST_DATA_FRAME with FCS, Target Reg:RX MCAST_DATA_ERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: BCAST_DATA_FRAME with FCS, Target Reg:RX BCAST_DATA_ERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: UCAST_DATA_FRAME with FCS, Target Reg:RX UCAST_DATA_ERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: MCAST_CTRL_FRAME with FCS, Target Reg:RX MCAST_CTRL_ERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: BCAST_CTRL_FRAME with FCS, Target Reg:RX BCAST_CTRL_ERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: UCAST_CTRL_FRAME with FCS, Target Reg:RX UCAST_CTRL_ERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: PFC_FRAME with FCS, Target Reg:RX PFC_ERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,PFC_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: SFC_FRAME with FCS, Target Reg:RX PAUSE_ERR",rx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,SFC_FRAME,ETH_VIP_AVL_RX,-1,.do_not_insert_fcs_err(do_not_insert_fcs_err));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 64B, Target Reg:RX 64B",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 65to127B, Target Reg:RX 65to127B",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(65,127)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 128to255B, Target Reg:RX 128to255B",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(128,255)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 256to511B, Target Reg:RX 256to511B",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(256,511)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 512to1023B, Target Reg:RX 512to1023B",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(512,1023)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 1024to1518B, Target Reg:RX 1024to1518B",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(1024,1518)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with 1519toMAXB, Target Reg:RX 1519toMAXB",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(1519,rx_max_frame_size)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with oversize, Target Reg:RX OVERSIZE",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(rx_max_frame_size+1,rx_max_frame_size+1000)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: MCAST_DATA_FRAME without FCS, Target Reg:RX MCAST_DATA_OK",rx_count), UVM_NONE)
        send_eth_frame(MCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: BCAST_DATA_FRAME without FCS, Target Reg:RX BCAST_DATA_OK",rx_count), UVM_NONE)
        send_eth_frame(BCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: UCAST_DATA_FRAME without FCS, Target Reg:RX UCAST_DATA_OK",rx_count), UVM_NONE)
        send_eth_frame(UCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: MCAST_CTRL_FRAME without FCS, Target Reg:RX MCAST_CTRL_OK",rx_count), UVM_NONE)
        send_eth_frame(MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: BCAST_CTRL_FRAME without FCS, Target Reg:RX BCAST_CTRL_OK",rx_count), UVM_NONE)
        send_eth_frame(BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: UCAST_CTRL_FRAME without FCS, Target Reg:RX UCAST_CTRL_OK",rx_count), UVM_NONE)
        send_eth_frame(UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,1);
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: PFC_FRAME without FCS, Target Reg:Rx PFC",rx_count), UVM_NONE)
        send_eth_frame(PFC_FRAME,ETH_VIP_AVL_RX,1);
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: SFC_FRAME without FCS, Target Reg:RX PAUSE",rx_count), UVM_NONE)
        send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,1);
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: DATA_FRAME with less than 64Bytes, Target Reg:RX RNT",rx_count), UVM_NONE)
        //FIXME Shabbir: update random range after FB476157 fix
        //send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(18,63)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(46,63)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(1,2);
    repeat (rx_rpt_cnt) begin
        rx_count++;
        `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with invalid length/type, Target Reg:badlt",rx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1519,1553)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end

    rx_rpt_cnt=$urandom_range(10,20);
    // random frame out of data frames,vlan and stack vlan
    //repeat (rx_rpt_cnt) begin
    //    rx_count++;
    //    `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: RANDOM_FRAME with length error, Target Reg:lenerr",rx_count), UVM_NONE)
    //    send_eth_frame_with_length_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);
    //end
    repeat (rx_rpt_cnt) begin
      rx_count++;
      `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: ETH_DATA_FRAME with length error, Target Reg:lenerr",rx_count), UVM_NONE)
      send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);

      randcase
      1 : begin 
            rx_count++;
            `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: ETH_VLAN_FRAME with length error, Target Reg:lenerr",rx_count), UVM_NONE)
            send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,-1);
          end
      1 : begin 
            rx_count++;
            `uvm_info("send_directed_frames", $psprintf("RX Frame # %0d: ETH_STACKED_VLAN_FRAME with length error, Target Reg:lenerr",rx_count), UVM_NONE)
            send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,-1);
          end
      endcase     
    end
    
    `endif//ifdef ENABLE_ETH_VIP
    end//fork...begin1

    begin//begin2
    //FIXME Shabbir: TX error support required
    //FIXME Shabbir: figure out which other type of frames required to cover all stat counters
    `uvm_info("send_directed_frames", "send directed kind of TX frames to make sure all stat counters increments", UVM_NONE)
    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: DATA_FRAME undersize with FCS, Target Reg:TX FRAGMENTS",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(18,63));
        end else begin
          send_eth_frame_with_tx_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(18,63));
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: DATA_FRAME oversize with FCS, Target Reg:TX JABBERS",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+1000));
        end else begin
          send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+1000));
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with FCS, Target Reg:TX FCSERR",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: DATA_FRAME with FCS, Target Reg:TX CRCERR_OKPKT",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: MCAST_DATA_FRAME with FCS, Target Reg:TX MCAST_DATA_ERR",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: BCAST_DATA_FRAME with FCS, Target Reg:TX BCAST_DATA_ERR",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: UCAST_DATA_FRAME with FCS, Target Reg:TX UCAST_DATA_ERR",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: MCAST_CTRL_FRAME with FCS, Target Reg:TX MCAST_CTRL_ERR",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: BCAST_CTRL_FRAME with FCS, Target Reg:TX BCAST_CTRL_ERR",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: UCAST_CTRL_FRAME with FCS, Target Reg:TX UCAST_CTRL_ERR",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: PFC_FRAME with FCS, Target Reg:TX PFC_ERR",tx_count), UVM_NONE)
        send_eth_frame_with_fcs_error(1,PFC_FRAME,AVL_TX_ETH_VIP,-1);
        if(tx_error_en == 1) begin
          send_eth_frame_with_fcs_error(1,PFC_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: SFC_FRAME with FCS, Target Reg:TX PAUSE_ERR",tx_count), UVM_NONE)
        if(tx_error_en == 0) begin
          send_eth_frame_with_fcs_error(1,SFC_FRAME,AVL_TX_ETH_VIP,-1);
        end else begin
          send_eth_frame_with_tx_error(1,SFC_FRAME,AVL_TX_ETH_VIP,-1);
        end
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 64B, Target Reg:TX 64B",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(64),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 65to127B, Target Reg:TX 65to127B",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(65,127)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 128to255B, Target Reg:TX 128to255B",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(128,255)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 256to511B, Target Reg:TX 256to511B",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(256,511)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 512to1023B, Target Reg:TX 512to1023B",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(512,1023)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 1024to1518B, Target Reg:TX 1024to1518B",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(1024,1518)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with 1519toMAXB, Target Reg:TX 1519toMAXB",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(1519,tx_max_frame_size)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with oversize, Target Reg:TX OVERSIZE",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size($urandom_range(tx_max_frame_size+1,tx_max_frame_size+1000)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: MCAST_DATA_FRAME without FCS, Target Reg:TX MCAST_DATA_OK",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(MCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: BCAST_DATA_FRAME without FCS, Target Reg:TX BCAST_DATA_OK",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(BCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: UCAST_DATA_FRAME without FCS, Target Reg:TX UCAST_DATA_OK",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: MCAST_CTRL_FRAME without FCS, Target Reg:TX MCAST_CTRL_OK",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,-1,1,AVL_TX_ETH_VIP);
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: BCAST_CTRL_FRAME without FCS, Target Reg:TX BCAST_CTRL_OK",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,-1,1,AVL_TX_ETH_VIP);
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: UCAST_CTRL_FRAME without FCS, Target Reg:TX UCAST_CTRL_OK",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,-1,1,AVL_TX_ETH_VIP);
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: PFC_FRAME without FCS, Target Reg:TX PFC",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(PFC_FRAME,-1,1,AVL_TX_ETH_VIP);
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: SFC_FRAME without FCS, Target Reg:TX PAUSE",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(SFC_FRAME,-1,1,AVL_TX_ETH_VIP);
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: DATA_FRAME with less than 64Bytes, Target Reg:TX RNT",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(18,63)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(1,2);
    repeat (tx_rpt_cnt) begin
        tx_count++;
        `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: RANDOM_FRAME with invalid length/type , Target Reg:badlt",tx_count), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1519,1553)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end

    tx_rpt_cnt=$urandom_range(10,20);
    // random frame out of data frames,vlan and stack vlan
    repeat (tx_rpt_cnt) begin
      tx_count++;
      `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: ETH_DATA_FRAME with length error, Target Reg:lenerr",tx_count), UVM_NONE)
      send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);

      randcase
      1 : begin 
            tx_count++;
            `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: ETH_VLAN_FRAME with length error, Target Reg:lenerr",tx_count), UVM_NONE)
            send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,-1);
          end
      1 : begin 
            tx_count++;
            `uvm_info("send_directed_frames", $psprintf("TX Frame # %0d: ETH_STACKED_VLAN_FRAME with length error, Target Reg:lenerr",tx_count), UVM_NONE)
            send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,-1);
          end
      endcase  	
    end


    end//fork....begin2
    join//fork
    end//repeat(repeat_count)
 endtask : send_directed_frames

//This task will expect RX PCS ready should assert within some time else fire an error
task rx_pcs_ready_timeout();
  bit rx_pcs_ready=0;

  fork:rx_pcs_rdy
    begin
      p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
      rx_pcs_ready=1;
    end
    `ifndef ANLT //Shabbir: in the case of ANLT, pcs_ready may take longer than 200000ns
      begin
        #200000ns;
        `uvm_error("rx_pcs_ready_timeout","rx_pcs_ready didn't asserted within 200000ns");
      end
    `endif
  join_any

  if(rx_pcs_ready == 1) begin
    //disable rx_pcs_rdy;
    disable fork;
    `uvm_info("rx_pcs_ready_timeout", "Disabling fork", UVM_NONE)
  end
  else begin
    `uvm_info("rx_pcs_ready_timeout", "Wait fork", UVM_NONE)
    wait fork;
    `uvm_info("rx_pcs_ready_timeout", "Wait fork done", UVM_NONE)
  end
endtask : rx_pcs_ready_timeout

task rand_regs();
  uvm_reg_data_t rd_data;
  string func_name="body";
  bit rx_crc_pass;
  bit[1:0] rx_padcrc;
  bit tx_crc_control = 0;

  /*p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
  //Shabbir- FB560308 CRC passthrough can not be enabled with remove pads (bytestoremove=2) (rx_bytes_to_remove = "Remove CRC and PAD bytes")
  if(rd_data[8] == 0)
  begin
    rx_crc_pass=$urandom;
    `uvm_info("eth_stat_base_sequence", $psprintf("Writing MAC_CRC_CONFIG 'h%0h",rx_crc_pass), UVM_NONE)
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
  end
  rd_data[1]=$urandom_range(0,1);
  `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL VLAN detection disable=%0b",rd_data[1]), UVM_NONE)
  rd_data[3]=$urandom_range(0,1);
  rd_data[4]=$urandom_range(0,1);
  `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL SFD check=%0b, SYNOPT_STRICT_SOP=%0b",rd_data[3],p_sequencer.env.dyn_rcfg_obj_inst.sfd), UVM_NONE)
  `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL PREAMBLE check=%0b, SYNOPT_STRICT_SOP=%0b",rd_data[4],p_sequencer.env.dyn_rcfg_obj_inst.sfd), UVM_NONE)
  p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 

  //randomize tx/rx vlan detection disable configuration
  p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
  rd_data[1]=$urandom_range(0,1);
  `uvm_info("eth_stat_base_sequence", $psprintf("Writing TX_MAC_CONTROL VLAN detection disable=%0b",rd_data[1]), UVM_NONE)
  p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); */

  p_sequencer.env.reg_read(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
//  rd_data[1:0] = $urandom_range(0,3); //DM: Value 2 is reserved
  std::randomize(rx_padcrc) with {rx_padcrc inside {0,1,3};};
  std::randomize(tx_crc_control) with {tx_crc_control inside {0,1};};
  rd_data[1:0] = rx_padcrc;
  p_sequencer.env.reg_write(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
  p_sequencer.env.reg_read(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
  rd_data = {rd_data[31:2],tx_crc_control,rd_data[0]};
  p_sequencer.env.reg_write(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
  p_sequencer.env.reg_read(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
  rd_data = {rd_data[31:1],tx_crc_control};
  //If padding is enabled, tx_crc_control should be 'h11
  p_sequencer.env.reg_write(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
  p_sequencer.env.reg_read(`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
  rd_data[0]=$urandom_range(0,1);
  `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL VLAN detection disable=%0b",rd_data[0]), UVM_NONE)
  p_sequencer.env.reg_write(`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
  p_sequencer.env.reg_read(`GET_REG_ADDR(tx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
  rd_data[0]=$urandom_range(0,1);
  `uvm_info("eth_stat_base_sequence", $psprintf("Writing TX_MAC_CONTROL VLAN detection disable=%0b",rd_data[0]), UVM_NONE)
  p_sequencer.env.reg_write(`GET_REG_ADDR(tx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);

  //Read register to get max_frame_size
  read_max_frame_size();
endtask: rand_regs

//This task will randomly insert tx/rx hard/soft reset
task apply_tx_rx_hard_soft_rst();
  randcase
  1: begin
       `uvm_info("apply_tx_rx_hard_soft_rst", " Apply hard tx reset", UVM_NONE)
       p_sequencer.env.apply_reset(.rst_type("hard"),.tx_rst(1),.reset_period($urandom_range(10,20)));
       p_sequencer.env.wait_for_linkup(.tx_sync(1));
       //apply_tx_rst("hard");
     end

  1: begin
       `uvm_info("apply_tx_rx_hard_soft_rst", " Apply hard rx reset", UVM_NONE)
       p_sequencer.env.apply_reset(.rst_type("hard"),.rx_rst(1),.reset_period($urandom_range(10,20)));
       p_sequencer.env.wait_for_linkup(.rx_sync(1));
     end

  1: begin
       `uvm_info("apply_tx_rx_hard_soft_rst", " Apply soft tx reset", UVM_NONE)
       //apply_tx_rst("soft");
       p_sequencer.env.apply_reset(.rst_type("soft"),.tx_rst(1));
       p_sequencer.env.wait_for_linkup(.tx_sync(1));
     end

  1: begin
       `uvm_info("apply_tx_rx_hard_soft_rst", " Apply soft rx reset", UVM_NONE)
       p_sequencer.env.apply_reset(.rst_type("soft"),.rx_rst(1));
       p_sequencer.env.wait_for_linkup(.rx_sync(1));
     end
  endcase

  //have to wait for rx_pcs_ready for tx reset also because tx_lane_stable de-assertion makes VIP reset and rx_pcs_ready goes low
  //`uvm_info("apply_tx_rx_hard_soft_rst", " Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly. wait for rx_pcs_ready", UVM_NONE)
  ////p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
  ////rx_pcs_ready_timeout();
  //`ifdef CRETE3
  //  p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
  //`else  
  //  rx_pcs_ready_timeout();//Shabbir - FB 534015
  //`endif 	 
endtask : apply_tx_rx_hard_soft_rst

//This task will rinsert tx hard/soft reset. Follow reest sequence as mentioned in FB 519882
task apply_tx_rst(string rst_type="hard");
//DM_TODO:   //assert reset
//DM_TODO:   `uvm_info("apply_tx_rst", $psprintf(" Apply %0s tx reset. ",rst_type), UVM_NONE)
//DM_TODO:   if(rst_type == "hard") 
//DM_TODO:   begin
//DM_TODO:     p_sequencer.env.reset_uvc_inst.slv_drv.drv_if.tx_rst_n=0;
//DM_TODO:   end
//DM_TODO:   else
//DM_TODO:   begin
//DM_TODO:     p_sequencer.env.reg_write(`ETH_F_ALL_eth_reset_OFFSET_REG,'b010);
//DM_TODO:   end
//DM_TODO: 
//DM_TODO:   fork
//DM_TODO:   begin
//DM_TODO:     `uvm_info("apply_tx_rst", $psprintf(" Apply %0s tx reset. wait for tx_lanes_stable to go low",rst_type), UVM_NONE)
//DM_TODO:     wait(p_sequencer.env.sideband_if.tx_lane_stable==0);
//DM_TODO:   end
//DM_TODO:   begin
//DM_TODO:     `uvm_info("apply_tx_rst", $psprintf(" Apply %0s tx reset. wait for ehip_ready to go low",rst_type), UVM_NONE)
//DM_TODO:     wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0);
//DM_TODO:   end
//DM_TODO:   join
//DM_TODO: 
//DM_TODO:   //de-assert reset
//DM_TODO:   `uvm_info("apply_tx_rst", $psprintf(" de-assert %0s tx reset. ",rst_type), UVM_NONE)
//DM_TODO:   if(rst_type == "hard") 
//DM_TODO:   begin
//DM_TODO:     p_sequencer.env.reset_uvc_inst.slv_drv.drv_if.tx_rst_n=1;
//DM_TODO:   end
//DM_TODO:   else
//DM_TODO:   begin
//DM_TODO:     p_sequencer.env.reg_write(`ETH_F_ALL_eth_reset_OFFSET_REG,'b000);
//DM_TODO:   end
//DM_TODO: 
//DM_TODO:   fork
//DM_TODO:   begin
//DM_TODO:     `uvm_info("apply_tx_rst", $psprintf(" Apply %0s tx reset. wait for tx_lanes_stable to go high",rst_type), UVM_NONE)
//DM_TODO:     wait(p_sequencer.env.sideband_if.tx_lane_stable==1);
//DM_TODO:   end
//DM_TODO:   begin
//DM_TODO:     `uvm_info("apply_tx_rst", $psprintf(" Apply %0s tx reset. wait for ehip_ready to go high",rst_type), UVM_NONE)
//DM_TODO:     wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
//DM_TODO:   end
//DM_TODO:   join
//DM_TODO: 
//DM_TODO:   //`uvm_info("apply_tx_rst", $psprintf(" Apply %0s tx reset. wait for rx_pcs_ready go low",rst_type), UVM_NONE)
//DM_TODO:   //wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==0);

endtask : apply_tx_rst

// FIXME for GDR if required
 task check_rsfec_am_lock();
   uvm_reg_data_t read_data_am;
   int num_lanes;

   case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
      _400G      : num_lanes = 16;
      _200G      : num_lanes = 8;
      _100G,_40G : num_lanes = 4;
      _50G       : num_lanes = 2;
      _25G,_10G  : num_lanes = 1;
   endcase

   for(int i =0; i<num_lanes; i++) begin
    //DM_TODO:  p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_lane_rx_stat",i)),read_data_am,1);
     if(read_data_am[1] !== 1'b0) begin
       `uvm_error(get_name(),$sformatf("AM lock is broken for lane - %0d : read data = %0h",i,read_data_am));
     end      
   end        
   
 endtask : check_rsfec_am_lock

//This task will do DUT and VIP reconfiguration for ANLT for midsim hard/soft ip reset
//reference from an_csr_reset_during_an_sequence
task reconfig_for_an(bit[2:0] rst);
  if(p_sequencer.env.dyn_rcfg_obj_inst.anlt==1) begin
   if(rst[0] == 1)
    begin
    //reprogram_an_after_reset();
    `ifdef ENABLE_ETH_VIP  // Added if test is run with anlt1 and vip_en=0
     p_sequencer.env.reset_vip();
     // TBD venkatkx need to fix anlt in itf p_sequencer.env.reconfig_vip_for_an_mode();
    `endif
  end
 end
endtask : reconfig_for_an

//YCtask write_asym_p2p_latency(bit [23:0] asym_lat= 130, bit [23:0] p2p_lat= 131, bit rand_asym_p2p_lat= 1);
//YC
//YC   `uvm_info("asym_p2p_latency", $psprintf("Start the write_asym_p2p_latency task"), UVM_MEDIUM)
//YC     fork
//YC     begin
//YC        string tx_reg_asm;
//YC        for (int i = 0; i < 128; i ++) begin
//YC	    if (rand_asym_p2p_lat) begin
//YC		asym_lat = $urandom_range(24'h000080,24'hffffff);
//YC	    end
//YC            tx_reg_asm = {"tx_asm",$sformatf("%0d",i)};
//YC            p_sequencer.top_env.gdr_ral_write_asm($sformatf("%s", tx_reg_asm), ('h0040 + ('h4 * i)), asym_lat);
//YC	    `uvm_info("asym_p2p_latency", $psprintf(" Writing tx_ptp_asym_latency register %s with %0d ", tx_reg_asm, asym_lat), UVM_MEDIUM)
//YC        end
//YC     end
//YC     begin
//YC        string tx_reg_p2p;
//YC        for (int i = 0; i < 128; i ++) begin
//YC	    if (rand_asym_p2p_lat) begin
//YC		p2p_lat = $urandom_range(24'h000080,24'hffffff);
//YC	    end
//YC            tx_reg_p2p = {"tx_p2p",$sformatf("%0d",i)};
//YC            p_sequencer.top_env.gdr_ral_write_p2p($sformatf("%s", tx_reg_p2p), ('h0040 + ('h4 * i)), p2p_lat);
//YC	    `uvm_info("asym_p2p_latency", $psprintf(" Writing tx_ptp_p2p_latency register %s with %0d ", tx_reg_p2p, p2p_lat), UVM_MEDIUM)
//YC        end
//YC     end
//YC     join
//YC   
//YC   `uvm_info("asym_p2p_latency", $psprintf("Completed the write_asym_p2p_latency task"), UVM_MEDIUM)
//YC
//YC  endtask : write_asym_p2p_latency
//YC  
//YCtask read_asym_p2p_latency(bit compare_dis = 0);
//YC
//YC	uvm_reg_data_t read_data;
//YC
//YC	`uvm_info("asym_p2p_latency", $psprintf("Start the read_asym_p2p_latency task"), UVM_MEDIUM)
//YC
//YC	fork
//YC	begin
//YC		string tx_reg_asm;
//YC		for (int i = 0; i < 128; i ++) begin
//YC			tx_reg_asm = {"tx_asm",$sformatf("%0d",i)};
//YC			p_sequencer.top_env.reg_read_asm($sformatf("%s", tx_reg_asm), read_data);			
//YC		end	
//YC	end
//YC	begin
//YC		string tx_reg_p2p;
//YC		for (int i = 0; i < 128; i ++) begin
//YC			tx_reg_p2p = {"tx_p2p",$sformatf("%0d",i)};
//YC			p_sequencer.top_env.reg_read_p2p($sformatf("%s", tx_reg_p2p), read_data);			
//YC		end	
//YC	end
//YC	join
//YC	
//YC	`uvm_info("asym_p2p_latency", $psprintf("Completed the read_asym_p2p_latency task"), UVM_MEDIUM)
//YC
//YCendtask: read_asym_p2p_latency  

 // dsamantx: Collect register bank which is necceassy
 task collect_gdr_register_bank(output uvm_reg range_regs[$]);
    uvm_reg 	regs_org[$];
    uvm_reg 	temp_regs[$];
    string       register_range; // All,Aib,SoftCsr,EhipPcsCfg,EhipPcsStat,EhipMacCfg,EhipMacStat,LphyFec
    bit [31:0] start_addr = 'h0;
    bit [31:0] end_addr = 'h00FC;
    bit minimal_test;
    string       hip_reg_ranges[] = '{"EhipPcsCfg","EhipPcsStat","EhipMacCfg","EhipMacStat","LphyFec"};

    p_sequencer.env.reg_model.default_map.get_registers(regs_org);
    
    //Pick the register range from command line
    if (!($value$plusargs("registers=%0s",register_range))) begin
       register_range="All";
    end
    //HSD: 16013451889
    if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {PCSONLY,OTN,FLEXE}) begin
      `uvm_info(get_type_name, "Accessing only pcsonly address space for PCSONLY/OTN/FLEXE modes",UVM_NONE);	    
      register_range = "pcsonly";
    end
    //GDR 400G/200G :Run is consuming more time to complete, so reducing the register access count.
    if((p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_400G,_200G}) && (register_range=="All")) begin 
      hip_reg_ranges.shuffle();  
      hip_reg_ranges= new[2](hip_reg_ranges);
     end
    else begin
      hip_reg_ranges=new[1];
      hip_reg_ranges[0]=register_range;
    end

    if(!($value$plusargs("minimal_test=%0d", minimal_test))) minimal_test=0;

    `uvm_info(get_type_name, $psprintf("register_ranges=%0s",register_range), UVM_NONE)
    
    foreach(hip_reg_ranges[i]) begin
     register_range=hip_reg_ranges[i];
     //Aib registers not found in GDR RAL
     if(register_range inside {"Aib","All"}) begin
      range_regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
      range_regs = {range_regs,temp_regs};
     end

     //common Registers
     if(register_range inside {"SoftCsr","All","pcsonly"}) begin
       start_addr = 'h100;
       end_addr   = 'h0FFC;
       temp_regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
       range_regs = {range_regs,temp_regs};
     end
     //EHIP PCS CFG Registers
     if(register_range inside {"EhipPcsCfg","All","pcsonly"}) begin
      case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
       _25G,_10G : begin end_addr = 'h107C; start_addr = 'h1000; end  
       _50G :      begin end_addr = 'h207C; start_addr = 'h2000; end
       _100G,_40G :begin end_addr = 'h307C; start_addr = 'h3000; end
       _200G :     begin end_addr = 'h407C; start_addr = 'h4000; end
       _400G :     begin end_addr = 'h507C; start_addr = 'h5000; end
      endcase
      temp_regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
      range_regs = {range_regs,temp_regs};
     end

     //EHIP PCS STAT Registers
     if(register_range inside {"EhipPcsStat","All","pcsonly"}) begin
      case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
       _25G,_10G : begin end_addr = 'h11fc; start_addr = 'h1080; end  
       _50G :      begin end_addr = 'h21fc; start_addr = 'h2080; end
       _100G,_40G :begin end_addr = 'h31fc; start_addr = 'h3080; end
       _200G :     begin end_addr = 'h41fc; start_addr = 'h4080; end
       _400G :     begin end_addr = 'h51fc; start_addr = 'h5080; end
      endcase
      temp_regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
      range_regs = {range_regs,temp_regs};
     end
     //Mac cfg Registers
     if(register_range inside {"EhipMacCfg","All"}) begin
      case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
       _25G,_10G : begin end_addr = 'h17fc; start_addr = 'h1200; end 
       _50G :      begin end_addr = 'h27fc; start_addr = 'h2200; end
       _100G,_40G :begin end_addr = 'h37fc; start_addr = 'h3200; end
       _200G :     begin end_addr = 'h47fc; start_addr = 'h4200; end
       _400G :     begin end_addr = 'h57fc; start_addr = 'h5200; end
      endcase
      temp_regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
      range_regs = {range_regs,temp_regs};
     end

     //Mac stat Registers
     if(register_range inside {"EhipMacStat","All"}) begin
      case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
       _25G,_10G : begin end_addr = 'h1ffc; start_addr = 'h1800; end 
       _50G :      begin end_addr = 'h2ffc; start_addr = 'h2800; end
       _100G,_40G :begin end_addr = 'h3ffc; start_addr = 'h3800; end
       _200G :     begin end_addr = 'h4ffc; start_addr = 'h4800; end
       _400G :     begin end_addr = 'h5ffc; start_addr = 'h5800; end
      endcase
      temp_regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
      range_regs = {range_regs,temp_regs};
     end

     //Below Registers should have check for FEC   
     if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
       //LPHY FEC Registers
       if(register_range inside {"LphyFec","All","pcsonly"}) begin
        case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
         _25G,_10G : begin end_addr = 'h61fc; start_addr = 'h6000; end 
         _50G :      begin end_addr = 'h65fc; start_addr = 'h6200; end
         _100G,_40G :begin end_addr = 'h6dfc; start_addr = 'h6600; end
         _200G :     begin end_addr = 'h7dfc; start_addr = 'h6e00; end
         _400G :     begin end_addr = 'h9dfc; start_addr = 'h7e00; end
        endcase
        temp_regs = regs_org.find(item) with ( ((item.get_address()>=start_addr)&&(item.get_address()<=end_addr)) );
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_400G,_200G}) begin
	 temp_regs.shuffle();
         for(int i=0; i<50;i++) range_regs.push_back(temp_regs[i]);
	end
	else 
         range_regs = {range_regs,temp_regs};
       end
     end
    end
    //range_regs.sort();
    if(minimal_test==1) begin
      temp_regs= range_regs;
      temp_regs.shuffle();
      range_regs={};
      for(int i=0; i<20;i++) begin
        range_regs.push_back(temp_regs[i]);
      end
     end
    `uvm_info("ADDR_RANGES", $psprintf("addr range size=%0d",range_regs.size()), UVM_NONE)
 endtask

 //Task to read rsfec codeword registers
task read_rsfec_cw_registers();
  uvm_reg_data_t read_data;
  int num_lanes;

   case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
      _400G      : num_lanes = 16;
      _200G      : num_lanes = 8;
      _100G,_40G : num_lanes = 4;
      _50G       : num_lanes = 2;
      _25G,_10G  : num_lanes = 1;
   endcase
  
   for(int i=0;i<num_lanes;i++) begin  
    //DM_TODO:  p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_corr_cw_cnt_lo", i)),read_data);
    //DM_TODO:  `uvm_info(get_name(),$sformatf("RSFEC rsfec_corr_cw_cnt_lo  lane%0d register read data : %0d",i, read_data),UVM_MEDIUM);
    //DM_TODO:  p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_corr_cw_cnt_hi", i)),read_data);
    //DM_TODO:  `uvm_info(get_name(),$sformatf("RSFEC rsfec_corr_cw_cnt_hi  lane%0d register read data : %0d",i, read_data),UVM_MEDIUM);
    //DM_TODO:  p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_uncorr_cw_cnt_lo",i)),read_data); 
    //DM_TODO:  `uvm_info(get_name(),$sformatf("RSFEC rsfec_uncorr_cw_cnt_lo lane%0d register read data : %0d",i, read_data),UVM_MEDIUM);      
    //DM_TODO:  p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_uncorr_cw_cnt_hi",i)),read_data); 
    //DM_TODO:  `uvm_info(get_name(),$sformatf("RSFEC rsfec_uncorr_cw_cnt_hi lane%0d register read data : %0d",i, read_data),UVM_MEDIUM);      
   end        

endtask

task program_rsfec_debug_cfg_registers();

  int num_lanes;
  bit data=1;

  case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
      _400G      : num_lanes = 16;
      _200G      : num_lanes = 8;
      _100G,_40G : num_lanes = 4;
      _50G       : num_lanes = 2;
      _25G,_10G  : num_lanes = 1;
   endcase

  for(int i=0;i<num_lanes;i++) begin  
    //DM_TODO: p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_debug_cfg",i)),read_data,1);
    //DM_TODO: read_data[4] = 1'b1;//4'hF;
    //DM_TODO: `uvm_info(get_name(),$sformatf("Program lane %0d rsfec_debug_cfg register with shadow_clear as 1", i),UVM_LOW);
    //DM_TODO: p_sequencer.env.reg_write(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_debug_cfg",i)),read_data);
    //DM_TODO: p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_debug_cfg",i)),read_data,1);
    //DM_TODO: read_data[4] = 1'b0; //4'h0;
    //DM_TODO: `uvm_info(get_name(),$sformatf("Program lane %0d rsfec_debug_cfg register with shadow_clear as 0", i),UVM_LOW);
    //DM_TODO: p_sequencer.env.reg_write(p_sequencer.env.gdr_ral_offset($sformatf("fec_stats_e25g_stat_s%0d_rsfec_debug_cfg",i)),read_data);
  end

endtask

   `ifdef ENABLE_ETH_VIP
   //task to reset and enable scoreboard based on reset
   task reset_scb();
   
      fork
      begin
         //reset
         forever
         begin
            `uvm_info(get_full_name(), "waiting for Reset ...", UVM_LOW)
            @(negedge p_sequencer.env.reset_if.csr_rst_n , negedge p_sequencer.env.reset_if.tx_rst_n , negedge p_sequencer.env.reset_if.rx_rst_n , posedge p_sequencer.env.spy_if.soft_tx_rst , posedge p_sequencer.env.spy_if.soft_rx_rst ); 
            `uvm_info(get_full_name(), "Reset asserted, clearing scoreboard queues", UVM_LOW)
            p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; 
            p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
            p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
            p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
            uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_LOW);
            `ifdef ENABLE_ETH_VIP
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
            `endif
         end      
      end
      begin
         //deassert
         forever
         begin
            @(posedge p_sequencer.env.reset_if.csr_rst_n , posedge p_sequencer.env.reset_if.tx_rst_n , posedge p_sequencer.env.reset_if.rx_rst_n , negedge p_sequencer.env.spy_if.soft_tx_rst , negedge p_sequencer.env.spy_if.soft_rx_rst ); 
            //For PTP need to wait until PTP TX and RX ptp ready is up
            if(p_sequencer.env.dyn_rcfg_obj_inst.ptp == 1)begin
               wait(p_sequencer.env.spy_if.o_tx_ptp_ready & p_sequencer.env.spy_if.o_rx_ptp_ready);
               
               //Workaround for PTP midsim traffic issue to turn on scoreboard after 1us due to corrupted FEFE packet prior to previous reset
               if(p_sequencer.env.spy_if.delayed_scb_en == 1)begin
                  #10us; //sometimes packet sending takes around 3us
                  p_sequencer.env.spy_if.delayed_scb_en = 0;
               end
               
            end
            
            `uvm_info(get_full_name(), "Enable scoreboard", UVM_LOW)
            p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0; 
            p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
            p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=1;  
            p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=1;
            //Enable avst monitor assertions after getting lock
            `ifdef ENABLE_ETH_VIP
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(1);
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(1);
            `endif
         
         end
      end     
      join_none
   endtask: reset_scb   
   `endif
   `ifdef ETH_MULTI_PORT
   task csr_pcs_regs(bit val=0);
     if(val == 1) begin
       registers_urm reg_model;
       bit [31:0] dev_ability;
       bit [31:0] partner_ability;
       bit [31:0] rx_pcs_fully_aligned;
       bit  rx_pcs_word_lock;
       `uvm_info("pcs_reg_predict","updating default values",UVM_MEDIUM);	  
//       rx_pcs_word_lock=1'b0;
//       rx_pcs_fully_aligned={30'h0,rx_pcs_word_lock};
//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
//       p_sequencer.env.reg_model.RX_PCS_FULLY_ALIGNED_S.predict(.value(rx_pcs_fully_aligned[31:0]),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.env.reg_model.default_map));
       dev_ability=32'h1;
       p_sequencer.env.reg_model.usxgmii_dev_ability.predict(.value(dev_ability[31:0]),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.env.reg_model.default_map));
       partner_ability=32'h0;
       p_sequencer.env.reg_model.usxgmii_partner_ability.predict(.value(partner_ability[31:0]),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.env.reg_model.default_map));
    end	  
  endtask:csr_pcs_regs
  `endif
