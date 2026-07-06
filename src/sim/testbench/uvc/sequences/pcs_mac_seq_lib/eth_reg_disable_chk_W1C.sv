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


if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
  compare_disable[`GET_REG_ADDR(fec_e25g_s0_xcvrif_stat_hold_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
  compare_disable[`GET_REG_ADDR(fec_e25g_s0_xcvrif_stat_hold_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
  compare_disable[`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_aggr_rx_hold_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
  compare_disable[`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_lane_rx_hold_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1; 
  compare_disable[`GET_REG_ADDR(fec_stats_e25g_stat_s0_rsfec_lane_tx_hold_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
  if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G) ) begin
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s1_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s1_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s2_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s2_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s3_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s3_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s4_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s4_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s5_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s5_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s6_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s6_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s7_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s7_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s8_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s8_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s9_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s9_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s10_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s10_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s11_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s11_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s12_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s12_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s13_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s13_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s14_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s14_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s15_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_e25g_s15_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s1_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s1_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s1_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s2_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s2_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s2_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s3_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s3_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s3_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s4_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s4_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s4_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s5_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s5_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s5_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s6_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s6_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s6_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s7_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s7_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s7_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s8_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s8_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s8_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s9_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s9_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s9_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s10_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s10_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s10_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s11_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s11_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s11_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s12_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s12_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s12_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s13_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s13_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s13_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s14_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s14_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s14_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s15_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s15_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e400_fec_stats_e25g_stat_s15_rsfec_lane_tx_hold_OFFSET_REG] = 1;
  end 
  if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) ) begin
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s1_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s1_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s2_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s2_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s3_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s3_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s4_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s4_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s5_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s5_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s6_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s6_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s7_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_e25g_s7_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s1_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s1_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s1_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s2_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s2_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s2_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s3_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s3_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s3_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s4_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s4_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s4_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s5_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s5_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s5_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s6_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s6_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s6_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s7_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s7_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e200_fec_stats_e25g_stat_s7_rsfec_lane_tx_hold_OFFSET_REG] = 1;
  end 
  if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) ) begin
    compare_disable[`ETH_F_ALL_e100_fec_e25g_s1_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_e25g_s1_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_e25g_s2_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_e25g_s2_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_e25g_s3_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_e25g_s3_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s1_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s1_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s1_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s2_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s2_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s2_rsfec_lane_tx_hold_OFFSET_REG] = 1;
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s3_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s3_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e100_fec_stats_e25g_stat_s3_rsfec_lane_tx_hold_OFFSET_REG] = 1;
  end 
  if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) ) begin
    compare_disable[`ETH_F_ALL_e50_fec_e25g_s1_xcvrif_stat_hold_1_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e50_fec_e25g_s1_xcvrif_stat_hold_4_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e50_fec_stats_e25g_stat_s1_rsfec_aggr_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e50_fec_stats_e25g_stat_s1_rsfec_lane_rx_hold_OFFSET_REG] = 1; 
    compare_disable[`ETH_F_ALL_e50_fec_stats_e25g_stat_s1_rsfec_lane_tx_hold_OFFSET_REG] = 1;
  end 
end 
