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


module ch4_phy #(
	parameter x_decoder_sm_flux_rx_demux_0__sel	= "SEL_UNUSED",
	parameter x_decoder_sm_flux_rx_rxword_clk_demux_0__sel	= "SEL_UNUSED",
	parameter x_decoder_sm_flux_tx_txword_clk_demux_0__sel	= "SEL_UNUSED",
	parameter x_mux_sm_flux_tx_mux_0__sel	= "SEL_UNUSED",
	parameter x_mux_sm_flux_tx_txword_clk_mux_0__sel	= "SEL_UNUSED",
	parameter x_mux_sm_xcvrif_rx_ch_clk_mux_0__sel	= "SEL_UNUSED",
	parameter x_mux_sm_xcvrif_tx_ch_clk_mux_0__sel	= "SEL_UNUSED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__cdr_f_out_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__cdr_f_pfd_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__cdr_f_ref_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__cdr_f_vco_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__cdr_l_counter	= 6'b000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__cdr_m_counter	= 9'b000000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__cdr_n_counter	= 6'b000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__cdr_refclk_select	= "CDR_REFCLK_SELECT_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__clk_debug_select_0_enable	= "CLK_DEBUG_SELECT_0_ENABLE_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__clk_debug_select_0_setting	= "CLK_DEBUG_SELECT_0_SETTING_SLOW_MEDIUM",
	parameter x_std_ipfluxtop_uxtop_wrap_0__clk_debug_select_1_enable	= "CLK_DEBUG_SELECT_1_ENABLE_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__clk_debug_select_1_setting	= "CLK_DEBUG_SELECT_1_SETTING_SLOW_MEDIUM",
	parameter x_std_ipfluxtop_uxtop_wrap_0__duplex_mode	= "DUPLEX_MODE_DUPLEX",
	parameter x_std_ipfluxtop_uxtop_wrap_0__ick_tx_word_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__lane_common_ref_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__loopback_mode	= "LOOPBACK_MODE_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__pcie_mode	= "PCIE_MODE_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__pcs_ref_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_adaptation_mode	= "RX_ADAPTATION_MODE_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_cdrdivout_en	= "RX_CDRDIVOUT_EN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_datarate_bps	= 37'b0000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_en	= "FALSE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_eq_dfe_tap_1	= 6'b000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_eq_hf_boost	= 6'b000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_eq_vga_gain	= 7'b0000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_external_couple_type	= "RX_EXTERNAL_COUPLE_TYPE_AC",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_force_cdr_ltr	= "FALSE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_invert_pin	= "RX_INVERT_PIN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_onchip_termination_setting	= "RX_ONCHIP_TERMINATION_SETTING_R_1",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_postdiv_clk_divider	= 8'b00000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_postdiv_clk_en	= "RX_POSTDIV_CLK_EN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_postdiv_clk_fractional_en	= "RX_POSTDIV_CLK_FRACTIONAL_EN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_postdiv_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_prbs_monitor_en	= "RX_PRBS_MONITOR_EN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_prbs_pattern	= 4'b0001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_preloaded_hardware_configs	= "RX_PRELOADED_HARDWARE_CONFIGS_NONE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_protocol_hint	= "RX_PROTOCOL_HINT_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_sim_mode	= "RX_SIM_MODE_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_termination_mode	= "RX_TERMINATION_MODE_HIGH_Z",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_width	= "RX_WIDTH_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__rx_word_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__speed_grade	= "SPEED_GRADE_DASH_1",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_bond_size	= "TX_BOND_SIZE_UNUSED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_bonding_category	= "TX_BONDING_CATEGORY_UNUSED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_datarate_bps	= 37'b0000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_en	= "FALSE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_eq_main_tap	= 6'b000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_eq_post_tap_1	= 5'b00000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_eq_pre_tap_1	= 5'b00000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_eq_pre_tap_2	= 3'b000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_invert_pin	= "TX_INVERT_PIN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_master_pll_mode	= "TX_MASTER_PLL_MODE_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_bw_sel	= "TX_PLL_BW_SEL_LOW",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_f_out_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_f_pfd_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_f_ref_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_f_vco_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_fb_counter	= 2'b10,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_feed_forward_gain	= 8'b00000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_k_counter	= 22'b0000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_l_counter	= 6'b000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_m_counter	= 9'b000000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_n_counter	= 6'b000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_postdiv_sel	= "TX_PLL_POSTDIV_SEL_SYNTH_FAST",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_pll_refclk_select	= "TX_PLL_REFCLK_SELECT_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_cdr_refclk_divider	= 8'b00000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_cdr_refclk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_clk_divider	= 8'b00000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_clk_fractional_en	= "TX_POSTDIV_CLK_FRACTIONAL_EN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_prbs_gen_en	= "TX_PRBS_GEN_EN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_prbs_pattern	= 4'b0001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_preloaded_hardware_configs	= "TX_PRELOADED_HARDWARE_CONFIGS_NONE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_protocol_hint	= "TX_PROTOCOL_HINT_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_sim_mode	= "TX_SIM_MODE_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_spread_spectrum_en	= "TX_SPREAD_SPECTRUM_EN_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_synthdiv_out_divider	= 8'b00000001,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_synthdiv_out_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_user_clk_only_mode	= "TX_USER_CLK_ONLY_MODE_ENABLE",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_width	= "TX_WIDTH_DISABLED",
	parameter x_std_ipfluxtop_uxtop_wrap_0__tx_word_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_ipfluxtop_uxtop_wrap_0__usb_mode	= "USB_MODE_DISABLED",
	parameter x_std_sm_flux_ingress_0__clkrx_refclk_cssm_fw_control	= "CLKRX_REFCLK_CSSM_FW_CONTROL_ENABLE",
	parameter x_std_sm_flux_ingress_0__clkrx_refclk_sector_specifies_refclk_ready	= "CLKRX_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE",
	parameter x_std_sm_flux_ingress_0__dr_enabled	= "DR_ENABLED_DR_DISABLED",
	parameter x_std_sm_flux_ingress_0__flux_mode	= "FLUX_MODE_DISABLED",
	parameter x_std_sm_flux_ingress_0__local_refclk_cssm_fw_control	= "LOCAL_REFCLK_CSSM_FW_CONTROL_ENABLE",
	parameter x_std_sm_flux_ingress_0__local_refclk_sector_specifies_refclk_ready	= "LOCAL_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE",
	parameter x_std_sm_flux_ingress_0__rx_dl_enable	= "RX_DL_ENABLE_ENABLE",
	parameter x_std_sm_flux_ingress_0__rx_dl_rx_lat_bit_for_async	= 18'b000000000000000000,
	parameter x_std_sm_flux_ingress_0__rx_dl_rxbit_cntr_pma	= "RX_DL_RXBIT_CNTR_PMA_ENABLE",
	parameter x_std_sm_flux_ingress_0__rx_dl_rxbit_rollover	= 18'b000000000000000000,
	parameter x_std_sm_flux_ingress_0__rx_fec_type_used	= "RX_FEC_TYPE_USED_NONE",
	parameter x_std_sm_flux_ingress_0__rx_protocol_hint	= "RX_PROTOCOL_HINT_DISABLED",
	parameter x_std_sm_flux_ingress_0__rx_sim_mode	= "RX_SIM_MODE_ENABLE",
	parameter x_std_sm_flux_ingress_0__rx_user1_clk_mux_dynamic_sel	= "RX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED",
	parameter x_std_sm_flux_ingress_0__rx_user2_clk_mux_dynamic_sel	= "RX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED",
	parameter x_std_sm_flux_ingress_0__sequencer_reg_en	= "SEQUENCER_REG_EN_ENABLE",
	parameter x_std_sm_flux_ingress_0__tx_bond_size	= "TX_BOND_SIZE_UNUSED",
	parameter x_std_sm_flux_ingress_0__tx_dl_enable	= "TX_DL_ENABLE_ENABLE",
	parameter x_std_sm_flux_ingress_0__tx_sim_mode	= "TX_SIM_MODE_ENABLE",
	parameter x_std_sm_flux_ingress_0__tx_user1_clk_mux_dynamic_sel	= "TX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED",
	parameter x_std_sm_flux_ingress_0__tx_user2_clk_mux_dynamic_sel	= "TX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__dr_enabled	= "DR_ENABLED_DR_DISABLED",
	parameter x_std_sm_xcvrif_1ch_0__duplex_mode	= "DUPLEX_MODE_DUPLEX",
	parameter x_std_sm_xcvrif_1ch_0__eth_rx_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_sm_xcvrif_1ch_0__eth_tx_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_sm_xcvrif_1ch_0__loopback_mode	= "LOOPBACK_MODE_ENABLE",
	parameter x_std_sm_xcvrif_1ch_0__rx_bond_size	= "RX_BOND_SIZE_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__rx_bonding_mode	= "RX_BONDING_MODE_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__rx_dl_enable	= "RX_DL_ENABLE_ENABLE",
	parameter x_std_sm_xcvrif_1ch_0__rx_en	= "FALSE",
	parameter x_std_sm_xcvrif_1ch_0__rx_fifo_mode	= "RX_FIFO_MODE_PHASE_COMP",
	parameter x_std_sm_xcvrif_1ch_0__rx_fifo_rd_en_dynamic_mux	= "RX_FIFO_RD_EN_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__rx_gb_width	= "RX_GB_WIDTH_DISABLED",
	parameter x_std_sm_xcvrif_1ch_0__rx_word_clk_dynamic_mux	= "RX_WORD_CLK_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__sim_mode	= "SIM_MODE_ENABLE",
	parameter x_std_sm_xcvrif_1ch_0__sup_mode	= "SUP_MODE_USER_MODE",
	parameter x_std_sm_xcvrif_1ch_0__tx_bond_size	= "TX_BOND_SIZE_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__tx_bonding_mode	= "TX_BONDING_MODE_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__tx_dl_enable	= "TX_DL_ENABLE_ENABLE",
	parameter x_std_sm_xcvrif_1ch_0__tx_dynamic_mux	= "TX_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__tx_en	= "FALSE",
	parameter x_std_sm_xcvrif_1ch_0__tx_fifo_mode	= "TX_FIFO_MODE_PHASE_COMP",
	parameter x_std_sm_xcvrif_1ch_0__tx_fifo_rd_en_dynamic_mux	= "TX_FIFO_RD_EN_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__tx_gb_width	= "TX_GB_WIDTH_DISABLED",
	parameter x_std_sm_xcvrif_1ch_0__tx_rst_dynamic_mux	= "TX_RST_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__tx_word_clk_dynamic_mux	= "TX_WORD_CLK_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_xcvrif_1ch_0__xcvr_rxword_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_sm_xcvrif_1ch_0__xcvr_txword_clk_hz	= 36'b000000000000000000000000000000000000
)
 (
	input [124:0] x_std_sm_flux_ingress_0__i_sync_cfg_data,
	input [19:0] x_std_sm_flux_ingress_0__i_lavmm_addr,
	input [19:0] x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr,
	input [1:0] x_std_sm_flux_ingress_0__i_pcie_l1ctrla,
	input [1:0] x_std_sm_flux_ingress_0__i_ux_rxuser1_sel,
	input [1:0] x_std_sm_flux_ingress_0__i_ux_rxuser2_sel,
	input [1:0] x_std_sm_flux_ingress_0__i_ux_txuser1_sel,
	input [1:0] x_std_sm_flux_ingress_0__i_ux_txuser2_sel,
	input [249:0] x_std_sm_flux_ingress_0__i_sync_interface_control,
	input [256:0] x_std_sm_flux_ingress_0__i_sm_flux_egress,
	input [2:0] x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt,
	input [2:0] x_std_sm_flux_ingress_0__i_rxpstate,
	input [2:0] x_std_sm_flux_ingress_0__i_rxwidth,
	input [2:0] x_std_sm_flux_ingress_0__i_txclkdivrate,
	input [2:0] x_std_sm_flux_ingress_0__i_txdrv_levnm2,
	input [2:0] x_std_sm_flux_ingress_0__i_txpstate,
	input [2:0] x_std_sm_flux_ingress_0__i_txwidth,
	input [31:0] x_std_sm_flux_ingress_0__i_lavmm_rdata,
	input [31:0] x_std_sm_flux_ingress_0__i_lavmm_wdata,
	input [31:0] x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata,
	input [39:0] x_mux_sm_flux_tx_mux_0__i_pcie_pcs,
	input [3:0] x_std_sm_flux_ingress_0__i_lavmm_be,
	input [3:0] x_std_sm_flux_ingress_0__i_rxrate,
	input [3:0] x_std_sm_flux_ingress_0__i_txdrv_slew,
	input [3:0] x_std_sm_flux_ingress_0__i_txelecidle,
	input [3:0] x_std_sm_flux_ingress_0__i_txrate,
	input [3:0] x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be,
	input [42:0] x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data,
	input [4:0] x_std_sm_flux_ingress_0__i_sync_common_control,
	input [4:0] x_std_sm_flux_ingress_0__i_txdrv_levnm1,
	input [4:0] x_std_sm_flux_ingress_0__i_txdrv_levnp1,
	input [5:0] x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in,
	input [5:0] x_std_sm_flux_ingress_0__i_txdrv_levn,
	input [6:0] x_std_sm_flux_ingress_0__i_rxmargin_offset_nt,
	input [6:0] x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async,
	input [767:0] x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in,
	input [79:0] x_std_sm_flux_ingress_0__i_rx_data,
	input [79:0] x_std_sm_flux_ingress_0__i_ss_async_pldif,
	input [79:0] x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux,
	input x_mux_sm_flux_tx_txword_clk_mux_0__i_ux_ock_pma_clk,
	input x_mux_sm_flux_tx_txword_clk_mux_0__i_xcvr_txword_clk,
	input x_mux_sm_xcvrif_rx_ch_clk_mux_0__i_rxword_clk,
	input x_mux_sm_xcvrif_rx_ch_clk_mux_0__i_sys_clk,
	input x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_n_l0_ux,
	input x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_p_l0_ux,
	input x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_in,
	input x_std_ipfluxtop_uxtop_wrap_0__ioack_hsref_left_p_ux_bidir_in,
	input x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_in,
	input x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_in,
	input x_std_sm_flux_ingress_0__i_dat_pcs_measlatbit,
	input x_std_sm_flux_ingress_0__i_dpma_refclk,
	input x_std_sm_flux_ingress_0__i_flux_cpi_int,
	input x_std_sm_flux_ingress_0__i_flux_int,
	input x_std_sm_flux_ingress_0__i_flux_srds_rdy,
	input x_std_sm_flux_ingress_0__i_ft_rx_async_pulse_ch,
	input x_std_sm_flux_ingress_0__i_ft_rx_sclk_sync_ch,
	input x_std_sm_flux_ingress_0__i_ft_tx_async_pulse_ch,
	input x_std_sm_flux_ingress_0__i_ft_tx_sclk_sync_ch,
	input x_std_sm_flux_ingress_0__i_ick_sclk_rx,
	input x_std_sm_flux_ingress_0__i_ick_sclk_tx,
	input x_std_sm_flux_ingress_0__i_ictl_pcs_txenable_a,
	input x_std_sm_flux_ingress_0__i_lavmm_clk,
	input x_std_sm_flux_ingress_0__i_lavmm_rdata_valid,
	input x_std_sm_flux_ingress_0__i_lavmm_read,
	input x_std_sm_flux_ingress_0__i_lavmm_rstn,
	input x_std_sm_flux_ingress_0__i_lavmm_waitreq,
	input x_std_sm_flux_ingress_0__i_lavmm_write,
	input x_std_sm_flux_ingress_0__i_lfps_ennt,
	input x_std_sm_flux_ingress_0__i_ock_pcs_txword,
	input x_std_sm_flux_ingress_0__i_oflux_octl_pcs_txptr_smpl_lane,
	input x_std_sm_flux_ingress_0__i_pcie_pcs_rx_rst,
	input x_std_sm_flux_ingress_0__i_pcie_pcs_tx_rst,
	input x_std_sm_flux_ingress_0__i_pcs_pipe_rstn,
	input x_std_sm_flux_ingress_0__i_pcs_rxpostdiv,
	input x_std_sm_flux_ingress_0__i_pcs_rxword,
	input x_std_sm_flux_ingress_0__i_pma_cmn_ctrl,
	input x_std_sm_flux_ingress_0__i_pma_ctrl,
	input x_std_sm_flux_ingress_0__i_quartus_flux_s_to_ingress,
	input x_std_sm_flux_ingress_0__i_rst_pld_ux_rx_pma_rst_n,
	input x_std_sm_flux_ingress_0__i_rst_pld_ux_tx_pma_rst_n,
	input x_std_sm_flux_ingress_0__i_rst_ux_rx_sfrz,
	input x_std_sm_flux_ingress_0__i_rx_dl_ch_bit,
	input x_std_sm_flux_ingress_0__i_rxeiosdetectstata,
	input x_std_sm_flux_ingress_0__i_rxeq_starta,
	input x_std_sm_flux_ingress_0__i_rxeq_static_ena,
	input x_std_sm_flux_ingress_0__i_rxmargin_direction_nt,
	input x_std_sm_flux_ingress_0__i_rxmargin_mode_nt,
	input x_std_sm_flux_ingress_0__i_rxmargin_offset_change_a,
	input x_std_sm_flux_ingress_0__i_rxmargin_start_a,
	input x_std_sm_flux_ingress_0__i_rxterm_hiz_ena,
	input x_std_sm_flux_ingress_0__i_tstbus_lane,
	input x_std_sm_flux_ingress_0__i_txbeacona,
	input x_std_sm_flux_ingress_0__i_txdetectrx_reqa,
	input x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_direct,
	input x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_clk,
	input x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_read,
	input x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_rstn,
	input x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_write,
	input x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_rx_fifo_rd_en,
	input x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_tx_fifo_rd_en,
	input x_std_sm_xcvrif_1ch_0__i_rstxcvrif_rx_xcvrif_sfrz_n,
	input x_std_sm_xcvrif_1ch_0__i_rstxcvrif_tx_xcvrif_sfrz_n,
	input x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_rx_rst_n,
	input x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_signal_ok,
	input x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rd_rst_n,
	input x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rst_n,
	input x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_wr_rst_n,
	output [13:0] x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala,
	output [13:0] x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async,
	output [19:0] x_std_sm_flux_ingress_0__o_lavmm_addr,
	output [1:0] x_std_sm_flux_ingress_0__o_rxmargin_status_gray,
	output [1:0] x_std_sm_flux_ingress_0__o_ux_rxuser1_sel,
	output [1:0] x_std_sm_flux_ingress_0__o_ux_rxuser2_sel,
	output [1:0] x_std_sm_flux_ingress_0__o_ux_txuser1_sel,
	output [1:0] x_std_sm_flux_ingress_0__o_ux_txuser2_sel,
	output [1:0] x_std_sm_xcvrif_1ch_0__o_rx_xcvr_wordclk_sel,
	output [1:0] x_std_sm_xcvrif_1ch_0__o_tx_source_sel,
	output [2:0] x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel,
	output [2:0] x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel,
	output [2:0] x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel,
	output [319:0] x_std_sm_flux_ingress_0__o_sm_flux_ingress,
	output [31:0] x_std_sm_flux_ingress_0__o_lavmm_rdata,
	output [31:0] x_std_sm_flux_ingress_0__o_lavmm_wdata,
	output [31:0] x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata,
	output [39:0] x_decoder_sm_flux_rx_demux_0__o_pcie_pcs,
	output [3:0] x_std_sm_flux_ingress_0__o_lavmm_be,
	output [42:0] x_std_sm_xcvrif_1ch_0__o_rx_data,
	output [49:0] x_std_sm_flux_ingress_0__o_ss_async_pldif,
	output [703:0] x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out,
	output [79:0] x_std_sm_flux_ingress_0__o_tx_data,
	output x_decoder_sm_flux_rx_rxword_clk_demux_0__o_eth_rxword_clk,
	output x_decoder_sm_flux_rx_rxword_clk_demux_0__o_pcie_rxword_clk,
	output x_decoder_sm_flux_tx_txword_clk_demux_0__o_eth_txword_clk,
	output x_decoder_sm_flux_tx_txword_clk_demux_0__o_pcie_txword_clk,
	output x_mux_sm_xcvrif_rx_ch_clk_mux_0__o_eth_rx_ch_clk,
	output x_mux_sm_xcvrif_tx_ch_clk_mux_0__o_eth_tx_ch_clk,
	output x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_out,
	output x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_out,
	output x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_out,
	output x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_n_l0_ux,
	output x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_p_l0_ux,
	output x_std_sm_flux_ingress_0__o_dat_pcs_measlatrndtripbit,
	output x_std_sm_flux_ingress_0__o_ft_rx_async_pulse_ch,
	output x_std_sm_flux_ingress_0__o_ft_rx_sclk_sync_ch,
	output x_std_sm_flux_ingress_0__o_ft_tx_async_pulse_ch,
	output x_std_sm_flux_ingress_0__o_ft_tx_sclk_sync_ch,
	output x_std_sm_flux_ingress_0__o_ick_pcs_txword,
	output x_std_sm_flux_ingress_0__o_ick_sclk_rx,
	output x_std_sm_flux_ingress_0__o_ick_sclk_tx,
	output x_std_sm_flux_ingress_0__o_lavmm_clk,
	output x_std_sm_flux_ingress_0__o_lavmm_rdata_valid,
	output x_std_sm_flux_ingress_0__o_lavmm_read,
	output x_std_sm_flux_ingress_0__o_lavmm_rstn,
	output x_std_sm_flux_ingress_0__o_lavmm_waitreq,
	output x_std_sm_flux_ingress_0__o_lavmm_write,
	output x_std_sm_flux_ingress_0__o_ock_pcs_cdrfbclk,
	output x_std_sm_flux_ingress_0__o_ock_pcs_ref,
	output x_std_sm_flux_ingress_0__o_ock_pcs_txword,
	output x_std_sm_flux_ingress_0__o_octl_pcs_txstatus_a,
	output x_std_sm_flux_ingress_0__o_pcs_rxpostdiv,
	output x_std_sm_flux_ingress_0__o_pcs_rxword,
	output x_std_sm_flux_ingress_0__o_rst_flux0_cpi_cmn_busy,
	output x_std_sm_flux_ingress_0__o_rst_oflux_rx_srds_rdy,
	output x_std_sm_flux_ingress_0__o_rst_ux_all_synthlockstatus,
	output x_std_sm_flux_ingress_0__o_rst_ux_rx_pma_rst_n,
	output x_std_sm_flux_ingress_0__o_rst_ux_rxcdrlockstatus,
	output x_std_sm_flux_ingress_0__o_rst_ux_tx_pma_rst_n,
	output x_std_sm_flux_ingress_0__o_rxcdrlock2dataa,
	output x_std_sm_flux_ingress_0__o_rxeq_donea,
	output x_std_sm_flux_ingress_0__o_rxmargin_nacka,
	output x_std_sm_flux_ingress_0__o_rxmargin_statusa,
	output x_std_sm_flux_ingress_0__o_rxsignaldetect_lfpsa,
	output x_std_sm_flux_ingress_0__o_rxsignaldetecta,
	output x_std_sm_flux_ingress_0__o_rxstatusa,
	output x_std_sm_flux_ingress_0__o_sclk_return_sel_rx,
	output x_std_sm_flux_ingress_0__o_sclk_return_sel_tx,
	output x_std_sm_flux_ingress_0__o_synthlcfast_postdiv,
	output x_std_sm_flux_ingress_0__o_synthlcmed_postdiv,
	output x_std_sm_flux_ingress_0__o_synthlcslow_postdiv,
	output x_std_sm_flux_ingress_0__o_tx_dl_ch_bit,
	output x_std_sm_flux_ingress_0__o_txdetectrx_acka,
	output x_std_sm_flux_ingress_0__o_txdetectrx_statct,
	output x_std_sm_flux_ingress_0__o_txstatusa,
	output x_std_sm_flux_ingress_0__o_ux_txlc_clk,
	output x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_direct,
	output x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_valid,
	output x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_waitreq,
	output x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_rx_fifo_rd_en,
	output x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_tx_fifo_rd_en,
	output x_std_sm_xcvrif_1ch_0__o_pma_rx_sf,
	output x_std_sm_xcvrif_1ch_0__o_rx_latency_pulse,
	output x_std_sm_xcvrif_1ch_0__o_tx_latency_pulse,
	output x_std_sm_xcvrif_1ch_0__o_tx_rst_rd_sync_rst_n,
	output x_std_sm_xcvrif_1ch_0__o_tx_rst_wr_sync_rst_n,
        output x_std_sm_flux_ingress_0__o_ux_tx_ch_ptr_smpl
);
	wire [124:0] x_std_sm_flux_ingress_0__i_sync_cfg_data_0;
	wire [13:0] x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0;
	wire [13:0] x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0;
	wire [19:0] x_std_sm_flux_ingress_0__i_lavmm_addr_0;
	wire [19:0] x_std_sm_flux_ingress_0__o_lavmm_addr_0;
	wire [19:0] x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0;
	wire [1:0] pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0;
	wire [1:0] x_std_sm_flux_ingress_0__i_pcie_l1ctrla_0;
	wire [1:0] x_std_sm_flux_ingress_0__i_ux_rxuser1_sel_0;
	wire [1:0] x_std_sm_flux_ingress_0__i_ux_rxuser2_sel_0;
	wire [1:0] x_std_sm_flux_ingress_0__i_ux_txuser1_sel_0;
	wire [1:0] x_std_sm_flux_ingress_0__i_ux_txuser2_sel_0;
	wire [1:0] x_std_sm_flux_ingress_0__o_rxmargin_status_gray_0;
	wire [1:0] x_std_sm_flux_ingress_0__o_ux_rxuser1_sel_0;
	wire [1:0] x_std_sm_flux_ingress_0__o_ux_rxuser2_sel_0;
	wire [1:0] x_std_sm_flux_ingress_0__o_ux_txuser1_sel_0;
	wire [1:0] x_std_sm_flux_ingress_0__o_ux_txuser2_sel_0;
	wire [1:0] x_std_sm_xcvrif_1ch_0__o_rx_xcvr_wordclk_sel_0;
	wire [1:0] x_std_sm_xcvrif_1ch_0__o_tx_source_sel_0;
	wire [249:0] x_std_sm_flux_ingress_0__i_sync_interface_control_0;
	wire [256:0] x_std_sm_flux_ingress_0__i_sm_flux_egress_0;
	wire [2:0] x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt_0;
	wire [2:0] x_std_sm_flux_ingress_0__i_rxpstate_0;
	wire [2:0] x_std_sm_flux_ingress_0__i_rxwidth_0;
	wire [2:0] x_std_sm_flux_ingress_0__i_txclkdivrate_0;
	wire [2:0] x_std_sm_flux_ingress_0__i_txdrv_levnm2_0;
	wire [2:0] x_std_sm_flux_ingress_0__i_txpstate_0;
	wire [2:0] x_std_sm_flux_ingress_0__i_txwidth_0;
	wire [2:0] x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel_0;
	wire [2:0] x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel_0;
	wire [2:0] x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel_0;
	wire [319:0] x_std_sm_flux_ingress_0__o_sm_flux_ingress_0;
	wire [31:0] o_eth_rx_data_3;
	wire [31:0] o_ux_tx_ch3_data_1;
	wire [31:0] x_std_sm_flux_ingress_0__i_lavmm_rdata_0;
	wire [31:0] x_std_sm_flux_ingress_0__i_lavmm_wdata_0;
	wire [31:0] x_std_sm_flux_ingress_0__o_lavmm_rdata_0;
	wire [31:0] x_std_sm_flux_ingress_0__o_lavmm_wdata_0;
	wire [31:0] x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0;
	wire [31:0] x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0;
	wire [39:0] flux_mux_wrapper_u3__i_rx_data_0;
	wire [39:0] o_tx_data_3;
	wire [39:0] x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0;
	wire [39:0] x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0;
	wire [3:0] x_std_sm_flux_ingress_0__i_lavmm_be_0;
	wire [3:0] x_std_sm_flux_ingress_0__i_rxrate_0;
	wire [3:0] x_std_sm_flux_ingress_0__i_txdrv_slew_0;
	wire [3:0] x_std_sm_flux_ingress_0__i_txelecidle_0;
	wire [3:0] x_std_sm_flux_ingress_0__i_txrate_0;
	wire [3:0] x_std_sm_flux_ingress_0__o_lavmm_be_0;
	wire [3:0] x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0;
	wire [42:0] x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0;
	wire [42:0] x_std_sm_xcvrif_1ch_0__o_rx_data_0;
	wire [49:0] x_std_sm_flux_ingress_0__o_ss_async_pldif_0;
	wire [4:0] x_std_sm_flux_ingress_0__i_sync_common_control_0;
	wire [4:0] x_std_sm_flux_ingress_0__i_txdrv_levnm1_0;
	wire [4:0] x_std_sm_flux_ingress_0__i_txdrv_levnp1_0;
	wire [5:0] x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0;
	wire [5:0] x_std_sm_flux_ingress_0__i_txdrv_levn_0;
	wire [6:0] o_ux_tx_ch3_sync_data_1;
	wire [6:0] x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0;
	wire [6:0] x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0;
	wire [703:0] x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0;
	wire [767:0] x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0;
	wire [79:0] x_std_sm_flux_ingress_0__i_rx_data_0;
	wire [79:0] x_std_sm_flux_ingress_0__i_ss_async_pldif_0;
	wire [79:0] x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0;
	wire [79:0] x_std_sm_flux_ingress_0__o_tx_data_0;
	wire flux_ingress_u3__o_ock_pcs_txword_0;
	wire flux_ingress_u3__o_pcs_rxword_0;
	wire mac_pcs_fec_top_u0__o_ux_sclk_rx_ch3_0;
	wire mac_pcs_fec_top_u0__o_ux_sclk_tx_ch3_0;
	wire o_eth_rx_ch3_clk_4;
	wire o_eth_tx_ch3_clk_4;
	wire o_pcs_txword_3;
	wire o_quartus_connection_to_serdes_lane3_0;
	wire o_rx_dl_ch3_bit_1;
	wire o_tx_dl_ch3_bit_0;
	wire o_xcvr_rxword_ch_clk_3;
	wire o_xcvr_txword_ch_clk_3;
	wire tmp;
	wire x_decoder_sm_flux_rx_rxword_clk_demux_0__o_eth_rxword_clk_1;
	wire x_decoder_sm_flux_rx_rxword_clk_demux_0__o_pcie_rxword_clk_1;
	wire x_decoder_sm_flux_tx_txword_clk_demux_0__o_eth_txword_clk_1;
	wire x_decoder_sm_flux_tx_txword_clk_demux_0__o_pcie_txword_clk_1;
	wire x_mux_sm_flux_tx_txword_clk_mux_0__i_ux_ock_pma_clk_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_n_l0_ux_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_p_l0_ux_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_in_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_out_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__ioack_hsref_left_p_ux_bidir_in_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_in_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_out_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_in_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_out_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_n_l0_ux_1;
	wire x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_p_l0_ux_1;
	wire x_std_sm_flux_ingress_0__i_dat_pcs_measlatbit_1;
	wire x_std_sm_flux_ingress_0__i_dpma_refclk_1;
	wire x_std_sm_flux_ingress_0__i_flux_cpi_int_1;
	wire x_std_sm_flux_ingress_0__i_flux_int_1;
	wire x_std_sm_flux_ingress_0__i_flux_srds_rdy_1;
	wire x_std_sm_flux_ingress_0__i_ft_rx_async_pulse_ch_1;
	wire x_std_sm_flux_ingress_0__i_ft_rx_sclk_sync_ch_1;
	wire x_std_sm_flux_ingress_0__i_ft_tx_async_pulse_ch_1;
	wire x_std_sm_flux_ingress_0__i_ft_tx_sclk_sync_ch_1;
	wire x_std_sm_flux_ingress_0__i_ictl_pcs_txenable_a_1;
	wire x_std_sm_flux_ingress_0__i_lavmm_clk_1;
	wire x_std_sm_flux_ingress_0__i_lavmm_rdata_valid_1;
	wire x_std_sm_flux_ingress_0__i_lavmm_read_1;
	wire x_std_sm_flux_ingress_0__i_lavmm_rstn_1;
	wire x_std_sm_flux_ingress_0__i_lavmm_waitreq_1;
	wire x_std_sm_flux_ingress_0__i_lavmm_write_1;
	wire x_std_sm_flux_ingress_0__i_lfps_ennt_1;
	wire x_std_sm_flux_ingress_0__i_ock_pcs_txword_1;
	wire x_std_sm_flux_ingress_0__i_oflux_octl_pcs_txptr_smpl_lane_1;
	wire x_std_sm_flux_ingress_0__i_pcie_pcs_rx_rst_1;
	wire x_std_sm_flux_ingress_0__i_pcie_pcs_tx_rst_1;
	wire x_std_sm_flux_ingress_0__i_pcs_pipe_rstn_1;
	wire x_std_sm_flux_ingress_0__i_pcs_rxpostdiv_1;
	wire x_std_sm_flux_ingress_0__i_pcs_rxword_1;
	wire x_std_sm_flux_ingress_0__i_pma_cmn_ctrl_1;
	wire x_std_sm_flux_ingress_0__i_pma_ctrl_1;
	wire x_std_sm_flux_ingress_0__i_quartus_flux_s_to_ingress_1;
	wire x_std_sm_flux_ingress_0__i_rst_pld_ux_rx_pma_rst_n_1;
	wire x_std_sm_flux_ingress_0__i_rst_pld_ux_tx_pma_rst_n_1;
	wire x_std_sm_flux_ingress_0__i_rst_ux_rx_sfrz_1;
	wire x_std_sm_flux_ingress_0__i_rx_dl_ch_bit_1;
	wire x_std_sm_flux_ingress_0__i_rxeiosdetectstata_1;
	wire x_std_sm_flux_ingress_0__i_rxeq_starta_1;
	wire x_std_sm_flux_ingress_0__i_rxeq_static_ena_1;
	wire x_std_sm_flux_ingress_0__i_rxmargin_direction_nt_1;
	wire x_std_sm_flux_ingress_0__i_rxmargin_mode_nt_1;
	wire x_std_sm_flux_ingress_0__i_rxmargin_offset_change_a_1;
	wire x_std_sm_flux_ingress_0__i_rxmargin_start_a_1;
	wire x_std_sm_flux_ingress_0__i_rxterm_hiz_ena_1;
	wire x_std_sm_flux_ingress_0__i_tstbus_lane_1;
	wire x_std_sm_flux_ingress_0__i_txbeacona_1;
	wire x_std_sm_flux_ingress_0__i_txdetectrx_reqa_1;
	wire x_std_sm_flux_ingress_0__o_dat_pcs_measlatrndtripbit_1;
	wire x_std_sm_flux_ingress_0__o_ft_rx_async_pulse_ch_1;
	wire x_std_sm_flux_ingress_0__o_ft_rx_sclk_sync_ch_1;
	wire x_std_sm_flux_ingress_0__o_ft_tx_async_pulse_ch_1;
	wire x_std_sm_flux_ingress_0__o_ft_tx_sclk_sync_ch_1;
	wire x_std_sm_flux_ingress_0__o_ick_pcs_txword_1;
	wire x_std_sm_flux_ingress_0__o_ick_sclk_rx_1;
	wire x_std_sm_flux_ingress_0__o_ick_sclk_tx_1;
	wire x_std_sm_flux_ingress_0__o_lavmm_clk_1;
	wire x_std_sm_flux_ingress_0__o_lavmm_rdata_valid_1;
	wire x_std_sm_flux_ingress_0__o_lavmm_read_1;
	wire x_std_sm_flux_ingress_0__o_lavmm_rstn_1;
	wire x_std_sm_flux_ingress_0__o_lavmm_waitreq_1;
	wire x_std_sm_flux_ingress_0__o_lavmm_write_1;
	wire x_std_sm_flux_ingress_0__o_ock_pcs_cdrfbclk_1;
	wire x_std_sm_flux_ingress_0__o_ock_pcs_ref_1;
	wire x_std_sm_flux_ingress_0__o_octl_pcs_txstatus_a_1;
	wire x_std_sm_flux_ingress_0__o_pcs_rxpostdiv_1;
	wire x_std_sm_flux_ingress_0__o_rst_flux0_cpi_cmn_busy_1;
	wire x_std_sm_flux_ingress_0__o_rst_oflux_rx_srds_rdy_1;
	wire x_std_sm_flux_ingress_0__o_rst_ux_all_synthlockstatus_1;
	wire x_std_sm_flux_ingress_0__o_rst_ux_rx_pma_rst_n_1;
	wire x_std_sm_flux_ingress_0__o_rst_ux_rxcdrlockstatus_1;
	wire x_std_sm_flux_ingress_0__o_rst_ux_tx_pma_rst_n_1;
	wire x_std_sm_flux_ingress_0__o_rxcdrlock2dataa_1;
	wire x_std_sm_flux_ingress_0__o_rxeq_donea_1;
	wire x_std_sm_flux_ingress_0__o_rxmargin_nacka_1;
	wire x_std_sm_flux_ingress_0__o_rxmargin_statusa_1;
	wire x_std_sm_flux_ingress_0__o_rxsignaldetect_lfpsa_1;
	wire x_std_sm_flux_ingress_0__o_rxsignaldetecta_1;
	wire x_std_sm_flux_ingress_0__o_rxstatusa_1;
	wire x_std_sm_flux_ingress_0__o_sclk_return_sel_rx_1;
	wire x_std_sm_flux_ingress_0__o_sclk_return_sel_tx_1;
	wire x_std_sm_flux_ingress_0__o_synthlcfast_postdiv_1;
	wire x_std_sm_flux_ingress_0__o_synthlcmed_postdiv_1;
	wire x_std_sm_flux_ingress_0__o_synthlcslow_postdiv_1;
	wire x_std_sm_flux_ingress_0__o_tx_dl_ch_bit_1;
	wire x_std_sm_flux_ingress_0__o_txdetectrx_acka_1;
	wire x_std_sm_flux_ingress_0__o_txdetectrx_statct_1;
	wire x_std_sm_flux_ingress_0__o_txstatusa_1;
	wire x_std_sm_flux_ingress_0__o_ux_txlc_clk_1;
	wire x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_direct_1;
	wire x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_clk_1;
	wire x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_read_1;
	wire x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_rstn_1;
	wire x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_write_1;
	wire x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_rx_fifo_rd_en_1;
	wire x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_tx_fifo_rd_en_1;
	wire x_std_sm_xcvrif_1ch_0__i_rstxcvrif_rx_xcvrif_sfrz_n_1;
	wire x_std_sm_xcvrif_1ch_0__i_rstxcvrif_tx_xcvrif_sfrz_n_1;
	wire x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_rx_rst_n_1;
	wire x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_signal_ok_1;
	wire x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rd_rst_n_1;
	wire x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rst_n_1;
	wire x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_wr_rst_n_1;
	wire x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_direct_1;
	wire x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_valid_1;
	wire x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_waitreq_1;
	wire x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_rx_fifo_rd_en_1;
	wire x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_tx_fifo_rd_en_1;
	wire x_std_sm_xcvrif_1ch_0__o_pma_rx_sf_1;
	wire x_std_sm_xcvrif_1ch_0__o_rx_latency_pulse_1;
	wire x_std_sm_xcvrif_1ch_0__o_tx_latency_pulse_1;
	wire x_std_sm_xcvrif_1ch_0__o_tx_rst_rd_sync_rst_n_1;
	wire x_std_sm_xcvrif_1ch_0__o_tx_rst_wr_sync_rst_n_1;
	wire xcvrif_tx_esys_clk_mux_u0__o_esys_ch_clk_3;
    	wire x_std_sm_flux_ingress_0__o_ux_tx_ch_ptr_smpl_1;	
	assign mac_pcs_fec_top_u0__o_ux_sclk_rx_ch3_0 = x_std_sm_flux_ingress_0__i_ick_sclk_rx;
	assign mac_pcs_fec_top_u0__o_ux_sclk_tx_ch3_0 = x_std_sm_flux_ingress_0__i_ick_sclk_tx;
	assign o_xcvr_rxword_ch_clk_3 = x_mux_sm_xcvrif_rx_ch_clk_mux_0__i_rxword_clk;
	assign o_xcvr_txword_ch_clk_3 = x_mux_sm_flux_tx_txword_clk_mux_0__i_xcvr_txword_clk;
	assign pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1] = 1'b0;
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[0] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[0];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[10] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[10];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[11] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[11];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[12] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[12];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[13] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[13];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[14] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[14];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[15] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[15];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[16] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[16];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[17] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[17];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[18] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[18];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[19] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[19];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[1] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[1];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[20] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[20];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[21] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[21];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[22] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[22];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[23] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[23];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[24] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[24];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[25] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[25];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[26] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[26];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[27] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[27];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[28] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[28];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[29] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[29];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[2] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[2];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[30] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[30];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[31] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[31];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[32] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[32];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[33] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[33];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[34] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[34];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[35] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[35];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[36] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[36];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[37] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[37];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[38] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[38];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[39] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[39];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[3] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[3];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[4] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[4];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[5] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[5];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[6] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[6];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[7] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[7];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[8] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[8];
	assign x_decoder_sm_flux_rx_demux_0__o_pcie_pcs[9] = x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[9];
	assign x_decoder_sm_flux_rx_rxword_clk_demux_0__o_eth_rxword_clk = x_decoder_sm_flux_rx_rxword_clk_demux_0__o_eth_rxword_clk_1;
	assign x_decoder_sm_flux_rx_rxword_clk_demux_0__o_pcie_rxword_clk = x_decoder_sm_flux_rx_rxword_clk_demux_0__o_pcie_rxword_clk_1;
	assign x_decoder_sm_flux_tx_txword_clk_demux_0__o_eth_txword_clk = x_decoder_sm_flux_tx_txword_clk_demux_0__o_eth_txword_clk_1;
	assign x_decoder_sm_flux_tx_txword_clk_demux_0__o_pcie_txword_clk = x_decoder_sm_flux_tx_txword_clk_demux_0__o_pcie_txword_clk_1;
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[0] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[0];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[10] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[10];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[11] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[11];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[12] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[12];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[13] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[13];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[14] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[14];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[15] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[15];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[16] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[16];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[17] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[17];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[18] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[18];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[19] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[19];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[1] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[1];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[20] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[20];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[21] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[21];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[22] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[22];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[23] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[23];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[24] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[24];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[25] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[25];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[26] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[26];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[27] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[27];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[28] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[28];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[29] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[29];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[2] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[2];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[30] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[30];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[31] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[31];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[32] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[32];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[33] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[33];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[34] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[34];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[35] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[35];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[36] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[36];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[37] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[37];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[38] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[38];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[39] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[39];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[3] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[3];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[4] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[4];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[5] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[5];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[6] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[6];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[7] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[7];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[8] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[8];
	assign x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[9] = x_mux_sm_flux_tx_mux_0__i_pcie_pcs[9];
	assign x_mux_sm_flux_tx_txword_clk_mux_0__i_ux_ock_pma_clk_1 = x_mux_sm_flux_tx_txword_clk_mux_0__i_ux_ock_pma_clk;
	assign x_mux_sm_xcvrif_rx_ch_clk_mux_0__o_eth_rx_ch_clk = o_eth_rx_ch3_clk_4;
	assign x_mux_sm_xcvrif_tx_ch_clk_mux_0__o_eth_tx_ch_clk = o_eth_tx_ch3_clk_4;
	assign x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_n_l0_ux_1 = x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_n_l0_ux;
	assign x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_p_l0_ux_1 = x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_p_l0_ux;
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_in_1 = x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_in;
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_out = x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_out_1;
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_hsref_left_p_ux_bidir_in_1 = x_std_ipfluxtop_uxtop_wrap_0__ioack_hsref_left_p_ux_bidir_in;
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[0] = x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in[0];
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[1] = x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in[1];
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[2] = x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in[2];
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[3] = x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in[3];
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[4] = x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in[4];
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[5] = x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in[5];
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_in_1 = x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_in;
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_out = x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_out_1;
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_in_1 = x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_in;
	assign x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_out = x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_out_1;
	assign x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_n_l0_ux = x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_n_l0_ux_1;
	assign x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_p_l0_ux = x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_p_l0_ux_1;
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[0] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[0];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[100] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[100];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[101] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[101];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[102] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[102];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[103] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[103];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[104] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[104];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[105] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[105];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[106] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[106];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[107] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[107];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[108] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[108];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[109] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[109];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[10] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[10];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[110] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[110];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[111] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[111];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[112] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[112];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[113] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[113];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[114] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[114];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[115] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[115];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[116] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[116];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[117] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[117];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[118] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[118];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[119] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[119];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[11] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[11];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[120] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[120];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[121] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[121];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[122] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[122];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[123] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[123];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[124] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[124];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[125] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[125];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[126] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[126];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[127] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[127];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[128] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[128];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[129] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[129];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[12] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[12];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[130] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[130];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[131] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[131];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[132] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[132];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[133] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[133];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[134] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[134];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[135] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[135];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[136] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[136];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[137] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[137];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[138] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[138];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[139] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[139];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[13] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[13];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[140] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[140];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[141] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[141];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[142] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[142];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[143] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[143];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[144] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[144];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[145] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[145];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[146] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[146];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[147] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[147];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[148] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[148];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[149] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[149];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[14] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[14];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[150] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[150];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[151] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[151];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[152] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[152];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[153] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[153];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[154] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[154];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[155] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[155];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[156] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[156];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[157] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[157];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[158] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[158];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[159] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[159];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[15] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[15];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[160] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[160];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[161] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[161];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[162] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[162];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[163] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[163];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[164] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[164];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[165] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[165];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[166] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[166];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[167] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[167];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[168] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[168];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[169] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[169];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[16] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[16];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[170] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[170];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[171] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[171];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[172] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[172];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[173] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[173];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[174] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[174];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[175] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[175];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[176] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[176];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[177] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[177];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[178] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[178];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[179] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[179];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[17] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[17];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[180] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[180];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[181] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[181];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[182] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[182];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[183] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[183];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[184] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[184];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[185] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[185];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[186] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[186];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[187] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[187];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[188] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[188];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[189] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[189];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[18] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[18];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[190] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[190];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[191] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[191];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[192] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[192];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[193] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[193];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[194] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[194];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[195] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[195];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[196] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[196];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[197] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[197];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[198] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[198];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[199] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[199];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[19] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[19];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[1] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[1];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[200] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[200];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[201] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[201];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[202] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[202];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[203] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[203];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[204] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[204];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[205] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[205];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[206] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[206];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[207] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[207];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[208] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[208];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[209] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[209];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[20] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[20];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[210] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[210];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[211] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[211];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[212] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[212];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[213] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[213];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[214] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[214];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[215] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[215];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[216] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[216];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[217] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[217];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[218] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[218];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[219] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[219];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[21] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[21];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[220] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[220];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[221] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[221];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[222] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[222];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[223] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[223];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[224] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[224];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[225] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[225];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[226] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[226];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[227] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[227];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[228] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[228];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[229] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[229];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[22] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[22];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[230] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[230];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[231] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[231];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[232] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[232];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[233] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[233];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[234] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[234];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[235] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[235];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[236] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[236];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[237] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[237];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[238] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[238];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[239] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[239];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[23] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[23];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[240] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[240];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[241] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[241];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[242] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[242];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[243] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[243];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[244] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[244];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[245] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[245];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[246] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[246];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[247] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[247];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[248] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[248];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[249] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[249];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[24] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[24];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[250] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[250];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[251] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[251];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[252] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[252];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[253] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[253];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[254] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[254];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[255] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[255];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[256] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[256];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[257] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[257];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[258] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[258];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[259] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[259];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[25] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[25];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[260] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[260];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[261] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[261];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[262] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[262];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[263] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[263];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[264] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[264];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[265] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[265];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[266] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[266];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[267] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[267];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[268] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[268];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[269] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[269];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[26] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[26];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[270] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[270];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[271] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[271];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[272] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[272];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[273] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[273];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[274] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[274];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[275] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[275];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[276] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[276];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[277] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[277];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[278] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[278];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[279] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[279];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[27] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[27];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[280] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[280];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[281] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[281];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[282] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[282];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[283] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[283];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[284] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[284];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[285] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[285];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[286] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[286];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[287] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[287];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[288] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[288];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[289] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[289];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[28] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[28];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[290] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[290];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[291] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[291];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[292] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[292];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[293] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[293];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[294] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[294];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[295] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[295];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[296] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[296];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[297] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[297];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[298] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[298];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[299] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[299];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[29] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[29];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[2] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[2];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[300] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[300];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[301] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[301];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[302] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[302];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[303] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[303];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[304] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[304];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[305] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[305];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[306] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[306];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[307] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[307];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[308] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[308];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[309] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[309];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[30] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[30];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[310] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[310];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[311] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[311];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[312] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[312];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[313] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[313];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[314] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[314];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[315] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[315];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[316] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[316];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[317] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[317];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[318] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[318];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[319] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[319];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[31] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[31];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[320] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[320];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[321] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[321];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[322] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[322];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[323] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[323];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[324] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[324];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[325] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[325];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[326] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[326];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[327] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[327];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[328] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[328];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[329] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[329];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[32] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[32];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[330] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[330];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[331] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[331];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[332] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[332];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[333] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[333];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[334] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[334];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[335] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[335];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[336] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[336];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[337] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[337];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[338] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[338];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[339] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[339];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[33] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[33];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[340] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[340];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[341] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[341];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[342] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[342];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[343] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[343];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[344] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[344];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[345] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[345];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[346] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[346];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[347] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[347];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[348] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[348];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[349] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[349];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[34] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[34];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[350] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[350];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[351] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[351];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[352] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[352];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[353] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[353];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[354] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[354];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[355] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[355];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[356] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[356];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[357] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[357];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[358] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[358];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[359] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[359];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[35] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[35];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[360] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[360];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[361] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[361];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[362] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[362];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[363] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[363];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[364] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[364];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[365] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[365];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[366] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[366];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[367] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[367];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[368] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[368];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[369] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[369];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[36] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[36];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[370] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[370];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[371] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[371];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[372] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[372];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[373] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[373];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[374] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[374];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[375] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[375];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[376] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[376];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[377] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[377];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[378] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[378];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[379] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[379];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[37] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[37];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[380] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[380];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[381] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[381];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[382] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[382];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[383] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[383];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[384] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[384];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[385] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[385];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[386] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[386];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[387] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[387];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[388] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[388];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[389] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[389];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[38] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[38];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[390] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[390];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[391] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[391];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[392] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[392];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[393] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[393];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[394] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[394];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[395] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[395];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[396] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[396];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[397] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[397];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[398] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[398];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[399] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[399];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[39] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[39];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[3] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[3];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[400] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[400];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[401] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[401];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[402] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[402];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[403] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[403];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[404] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[404];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[405] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[405];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[406] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[406];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[407] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[407];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[408] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[408];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[409] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[409];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[40] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[40];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[410] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[410];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[411] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[411];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[412] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[412];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[413] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[413];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[414] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[414];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[415] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[415];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[416] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[416];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[417] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[417];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[418] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[418];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[419] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[419];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[41] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[41];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[420] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[420];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[421] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[421];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[422] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[422];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[423] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[423];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[424] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[424];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[425] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[425];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[426] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[426];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[427] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[427];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[428] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[428];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[429] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[429];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[42] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[42];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[430] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[430];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[431] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[431];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[432] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[432];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[433] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[433];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[434] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[434];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[435] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[435];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[436] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[436];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[437] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[437];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[438] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[438];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[439] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[439];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[43] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[43];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[440] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[440];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[441] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[441];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[442] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[442];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[443] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[443];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[444] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[444];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[445] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[445];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[446] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[446];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[447] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[447];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[448] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[448];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[449] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[449];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[44] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[44];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[450] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[450];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[451] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[451];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[452] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[452];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[453] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[453];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[454] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[454];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[455] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[455];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[456] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[456];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[457] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[457];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[458] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[458];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[459] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[459];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[45] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[45];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[460] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[460];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[461] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[461];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[462] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[462];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[463] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[463];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[464] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[464];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[465] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[465];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[466] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[466];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[467] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[467];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[468] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[468];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[469] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[469];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[46] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[46];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[470] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[470];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[471] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[471];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[472] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[472];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[473] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[473];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[474] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[474];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[475] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[475];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[476] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[476];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[477] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[477];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[478] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[478];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[479] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[479];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[47] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[47];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[480] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[480];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[481] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[481];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[482] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[482];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[483] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[483];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[484] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[484];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[485] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[485];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[486] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[486];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[487] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[487];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[488] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[488];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[489] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[489];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[48] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[48];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[490] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[490];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[491] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[491];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[492] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[492];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[493] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[493];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[494] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[494];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[495] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[495];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[496] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[496];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[497] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[497];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[498] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[498];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[499] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[499];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[49] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[49];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[4] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[4];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[500] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[500];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[501] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[501];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[502] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[502];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[503] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[503];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[504] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[504];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[505] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[505];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[506] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[506];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[507] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[507];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[508] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[508];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[509] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[509];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[50] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[50];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[510] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[510];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[511] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[511];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[512] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[512];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[513] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[513];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[514] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[514];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[515] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[515];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[516] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[516];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[517] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[517];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[518] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[518];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[519] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[519];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[51] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[51];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[520] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[520];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[521] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[521];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[522] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[522];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[523] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[523];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[524] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[524];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[525] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[525];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[526] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[526];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[527] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[527];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[528] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[528];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[529] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[529];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[52] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[52];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[530] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[530];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[531] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[531];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[532] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[532];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[533] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[533];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[534] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[534];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[535] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[535];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[536] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[536];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[537] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[537];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[538] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[538];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[539] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[539];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[53] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[53];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[540] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[540];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[541] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[541];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[542] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[542];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[543] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[543];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[544] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[544];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[545] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[545];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[546] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[546];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[547] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[547];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[548] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[548];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[549] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[549];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[54] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[54];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[550] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[550];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[551] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[551];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[552] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[552];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[553] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[553];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[554] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[554];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[555] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[555];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[556] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[556];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[557] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[557];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[558] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[558];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[559] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[559];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[55] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[55];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[560] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[560];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[561] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[561];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[562] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[562];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[563] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[563];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[564] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[564];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[565] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[565];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[566] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[566];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[567] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[567];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[568] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[568];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[569] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[569];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[56] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[56];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[570] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[570];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[571] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[571];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[572] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[572];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[573] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[573];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[574] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[574];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[575] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[575];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[576] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[576];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[577] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[577];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[578] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[578];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[579] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[579];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[57] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[57];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[580] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[580];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[581] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[581];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[582] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[582];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[583] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[583];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[584] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[584];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[585] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[585];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[586] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[586];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[587] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[587];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[588] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[588];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[589] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[589];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[58] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[58];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[590] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[590];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[591] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[591];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[592] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[592];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[593] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[593];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[594] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[594];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[595] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[595];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[596] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[596];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[597] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[597];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[598] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[598];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[599] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[599];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[59] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[59];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[5] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[5];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[600] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[600];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[601] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[601];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[602] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[602];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[603] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[603];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[604] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[604];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[605] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[605];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[606] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[606];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[607] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[607];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[608] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[608];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[609] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[609];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[60] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[60];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[610] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[610];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[611] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[611];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[612] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[612];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[613] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[613];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[614] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[614];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[615] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[615];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[616] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[616];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[617] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[617];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[618] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[618];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[619] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[619];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[61] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[61];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[620] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[620];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[621] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[621];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[622] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[622];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[623] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[623];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[624] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[624];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[625] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[625];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[626] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[626];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[627] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[627];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[628] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[628];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[629] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[629];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[62] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[62];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[630] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[630];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[631] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[631];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[632] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[632];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[633] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[633];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[634] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[634];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[635] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[635];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[636] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[636];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[637] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[637];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[638] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[638];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[639] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[639];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[63] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[63];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[640] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[640];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[641] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[641];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[642] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[642];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[643] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[643];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[644] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[644];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[645] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[645];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[646] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[646];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[647] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[647];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[648] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[648];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[649] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[649];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[64] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[64];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[650] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[650];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[651] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[651];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[652] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[652];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[653] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[653];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[654] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[654];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[655] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[655];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[656] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[656];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[657] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[657];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[658] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[658];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[659] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[659];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[65] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[65];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[660] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[660];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[661] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[661];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[662] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[662];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[663] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[663];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[664] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[664];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[665] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[665];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[666] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[666];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[667] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[667];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[668] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[668];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[669] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[669];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[66] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[66];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[670] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[670];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[671] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[671];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[672] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[672];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[673] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[673];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[674] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[674];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[675] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[675];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[676] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[676];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[677] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[677];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[678] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[678];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[679] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[679];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[67] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[67];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[680] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[680];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[681] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[681];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[682] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[682];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[683] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[683];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[684] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[684];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[685] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[685];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[686] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[686];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[687] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[687];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[688] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[688];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[689] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[689];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[68] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[68];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[690] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[690];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[691] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[691];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[692] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[692];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[693] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[693];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[694] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[694];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[695] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[695];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[696] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[696];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[697] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[697];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[698] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[698];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[699] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[699];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[69] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[69];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[6] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[6];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[700] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[700];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[701] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[701];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[702] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[702];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[703] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[703];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[704] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[704];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[705] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[705];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[706] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[706];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[707] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[707];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[708] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[708];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[709] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[709];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[70] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[70];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[710] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[710];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[711] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[711];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[712] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[712];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[713] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[713];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[714] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[714];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[715] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[715];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[716] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[716];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[717] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[717];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[718] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[718];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[719] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[719];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[71] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[71];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[720] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[720];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[721] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[721];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[722] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[722];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[723] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[723];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[724] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[724];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[725] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[725];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[726] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[726];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[727] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[727];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[728] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[728];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[729] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[729];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[72] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[72];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[730] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[730];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[731] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[731];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[732] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[732];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[733] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[733];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[734] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[734];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[735] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[735];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[736] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[736];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[737] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[737];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[738] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[738];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[739] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[739];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[73] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[73];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[740] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[740];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[741] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[741];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[742] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[742];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[743] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[743];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[744] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[744];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[745] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[745];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[746] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[746];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[747] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[747];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[748] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[748];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[749] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[749];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[74] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[74];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[750] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[750];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[751] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[751];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[752] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[752];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[753] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[753];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[754] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[754];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[755] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[755];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[756] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[756];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[757] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[757];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[758] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[758];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[759] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[759];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[75] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[75];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[760] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[760];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[761] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[761];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[762] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[762];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[763] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[763];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[764] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[764];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[765] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[765];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[766] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[766];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[767] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[767];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[76] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[76];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[77] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[77];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[78] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[78];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[79] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[79];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[7] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[7];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[80] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[80];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[81] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[81];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[82] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[82];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[83] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[83];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[84] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[84];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[85] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[85];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[86] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[86];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[87] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[87];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[88] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[88];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[89] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[89];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[8] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[8];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[90] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[90];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[91] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[91];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[92] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[92];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[93] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[93];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[94] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[94];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[95] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[95];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[96] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[96];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[97] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[97];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[98] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[98];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[99] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[99];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[9] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in[9];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[0] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[0];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[100] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[100];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[101] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[101];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[102] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[102];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[103] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[103];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[104] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[104];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[105] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[105];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[106] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[106];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[107] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[107];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[108] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[108];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[109] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[109];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[10] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[10];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[110] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[110];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[111] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[111];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[112] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[112];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[113] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[113];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[114] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[114];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[115] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[115];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[116] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[116];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[117] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[117];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[118] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[118];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[119] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[119];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[11] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[11];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[120] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[120];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[121] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[121];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[122] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[122];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[123] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[123];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[124] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[124];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[125] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[125];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[126] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[126];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[127] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[127];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[128] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[128];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[129] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[129];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[12] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[12];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[130] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[130];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[131] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[131];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[132] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[132];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[133] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[133];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[134] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[134];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[135] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[135];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[136] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[136];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[137] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[137];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[138] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[138];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[139] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[139];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[13] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[13];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[140] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[140];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[141] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[141];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[142] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[142];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[143] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[143];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[144] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[144];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[145] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[145];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[146] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[146];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[147] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[147];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[148] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[148];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[149] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[149];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[14] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[14];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[150] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[150];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[151] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[151];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[152] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[152];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[153] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[153];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[154] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[154];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[155] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[155];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[156] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[156];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[157] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[157];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[158] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[158];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[159] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[159];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[15] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[15];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[160] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[160];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[161] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[161];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[162] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[162];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[163] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[163];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[164] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[164];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[165] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[165];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[166] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[166];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[167] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[167];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[168] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[168];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[169] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[169];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[16] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[16];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[170] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[170];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[171] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[171];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[172] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[172];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[173] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[173];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[174] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[174];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[175] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[175];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[176] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[176];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[177] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[177];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[178] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[178];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[179] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[179];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[17] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[17];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[180] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[180];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[181] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[181];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[182] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[182];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[183] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[183];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[184] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[184];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[185] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[185];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[186] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[186];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[187] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[187];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[188] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[188];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[189] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[189];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[18] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[18];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[190] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[190];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[191] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[191];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[192] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[192];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[193] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[193];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[194] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[194];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[195] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[195];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[196] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[196];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[197] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[197];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[198] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[198];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[199] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[199];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[19] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[19];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[1] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[1];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[200] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[200];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[201] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[201];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[202] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[202];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[203] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[203];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[204] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[204];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[205] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[205];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[206] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[206];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[207] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[207];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[208] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[208];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[209] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[209];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[20] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[20];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[210] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[210];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[211] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[211];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[212] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[212];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[213] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[213];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[214] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[214];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[215] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[215];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[216] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[216];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[217] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[217];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[218] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[218];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[219] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[219];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[21] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[21];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[220] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[220];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[221] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[221];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[222] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[222];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[223] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[223];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[224] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[224];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[225] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[225];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[226] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[226];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[227] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[227];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[228] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[228];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[229] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[229];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[22] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[22];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[230] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[230];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[231] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[231];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[232] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[232];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[233] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[233];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[234] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[234];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[235] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[235];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[236] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[236];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[237] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[237];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[238] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[238];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[239] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[239];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[23] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[23];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[240] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[240];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[241] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[241];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[242] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[242];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[243] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[243];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[244] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[244];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[245] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[245];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[246] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[246];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[247] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[247];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[248] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[248];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[249] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[249];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[24] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[24];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[250] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[250];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[251] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[251];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[252] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[252];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[253] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[253];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[254] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[254];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[255] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[255];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[256] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[256];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[257] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[257];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[258] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[258];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[259] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[259];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[25] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[25];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[260] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[260];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[261] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[261];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[262] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[262];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[263] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[263];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[264] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[264];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[265] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[265];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[266] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[266];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[267] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[267];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[268] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[268];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[269] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[269];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[26] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[26];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[270] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[270];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[271] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[271];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[272] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[272];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[273] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[273];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[274] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[274];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[275] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[275];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[276] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[276];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[277] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[277];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[278] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[278];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[279] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[279];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[27] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[27];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[280] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[280];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[281] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[281];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[282] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[282];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[283] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[283];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[284] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[284];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[285] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[285];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[286] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[286];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[287] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[287];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[288] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[288];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[289] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[289];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[28] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[28];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[290] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[290];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[291] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[291];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[292] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[292];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[293] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[293];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[294] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[294];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[295] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[295];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[296] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[296];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[297] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[297];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[298] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[298];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[299] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[299];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[29] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[29];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[2] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[2];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[300] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[300];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[301] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[301];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[302] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[302];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[303] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[303];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[304] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[304];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[305] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[305];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[306] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[306];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[307] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[307];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[308] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[308];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[309] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[309];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[30] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[30];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[310] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[310];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[311] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[311];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[312] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[312];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[313] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[313];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[314] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[314];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[315] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[315];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[316] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[316];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[317] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[317];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[318] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[318];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[319] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[319];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[31] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[31];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[320] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[320];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[321] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[321];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[322] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[322];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[323] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[323];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[324] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[324];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[325] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[325];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[326] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[326];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[327] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[327];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[328] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[328];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[329] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[329];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[32] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[32];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[330] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[330];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[331] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[331];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[332] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[332];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[333] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[333];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[334] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[334];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[335] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[335];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[336] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[336];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[337] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[337];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[338] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[338];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[339] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[339];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[33] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[33];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[340] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[340];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[341] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[341];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[342] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[342];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[343] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[343];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[344] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[344];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[345] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[345];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[346] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[346];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[347] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[347];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[348] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[348];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[349] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[349];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[34] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[34];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[350] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[350];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[351] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[351];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[352] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[352];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[353] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[353];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[354] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[354];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[355] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[355];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[356] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[356];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[357] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[357];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[358] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[358];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[359] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[359];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[35] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[35];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[360] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[360];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[361] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[361];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[362] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[362];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[363] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[363];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[364] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[364];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[365] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[365];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[366] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[366];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[367] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[367];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[368] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[368];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[369] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[369];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[36] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[36];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[370] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[370];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[371] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[371];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[372] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[372];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[373] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[373];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[374] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[374];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[375] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[375];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[376] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[376];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[377] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[377];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[378] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[378];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[379] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[379];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[37] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[37];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[380] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[380];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[381] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[381];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[382] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[382];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[383] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[383];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[384] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[384];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[385] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[385];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[386] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[386];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[387] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[387];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[388] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[388];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[389] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[389];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[38] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[38];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[390] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[390];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[391] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[391];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[392] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[392];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[393] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[393];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[394] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[394];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[395] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[395];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[396] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[396];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[397] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[397];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[398] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[398];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[399] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[399];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[39] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[39];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[3] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[3];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[400] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[400];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[401] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[401];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[402] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[402];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[403] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[403];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[404] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[404];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[405] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[405];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[406] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[406];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[407] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[407];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[408] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[408];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[409] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[409];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[40] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[40];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[410] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[410];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[411] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[411];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[412] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[412];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[413] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[413];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[414] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[414];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[415] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[415];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[416] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[416];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[417] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[417];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[418] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[418];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[419] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[419];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[41] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[41];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[420] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[420];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[421] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[421];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[422] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[422];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[423] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[423];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[424] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[424];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[425] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[425];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[426] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[426];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[427] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[427];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[428] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[428];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[429] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[429];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[42] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[42];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[430] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[430];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[431] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[431];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[432] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[432];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[433] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[433];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[434] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[434];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[435] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[435];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[436] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[436];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[437] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[437];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[438] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[438];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[439] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[439];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[43] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[43];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[440] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[440];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[441] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[441];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[442] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[442];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[443] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[443];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[444] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[444];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[445] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[445];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[446] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[446];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[447] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[447];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[448] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[448];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[449] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[449];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[44] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[44];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[450] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[450];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[451] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[451];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[452] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[452];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[453] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[453];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[454] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[454];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[455] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[455];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[456] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[456];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[457] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[457];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[458] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[458];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[459] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[459];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[45] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[45];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[460] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[460];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[461] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[461];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[462] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[462];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[463] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[463];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[464] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[464];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[465] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[465];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[466] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[466];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[467] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[467];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[468] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[468];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[469] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[469];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[46] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[46];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[470] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[470];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[471] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[471];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[472] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[472];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[473] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[473];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[474] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[474];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[475] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[475];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[476] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[476];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[477] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[477];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[478] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[478];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[479] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[479];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[47] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[47];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[480] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[480];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[481] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[481];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[482] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[482];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[483] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[483];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[484] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[484];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[485] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[485];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[486] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[486];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[487] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[487];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[488] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[488];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[489] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[489];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[48] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[48];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[490] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[490];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[491] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[491];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[492] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[492];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[493] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[493];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[494] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[494];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[495] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[495];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[496] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[496];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[497] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[497];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[498] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[498];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[499] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[499];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[49] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[49];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[4] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[4];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[500] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[500];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[501] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[501];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[502] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[502];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[503] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[503];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[504] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[504];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[505] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[505];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[506] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[506];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[507] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[507];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[508] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[508];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[509] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[509];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[50] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[50];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[510] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[510];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[511] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[511];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[512] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[512];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[513] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[513];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[514] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[514];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[515] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[515];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[516] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[516];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[517] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[517];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[518] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[518];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[519] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[519];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[51] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[51];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[520] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[520];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[521] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[521];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[522] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[522];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[523] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[523];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[524] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[524];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[525] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[525];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[526] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[526];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[527] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[527];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[528] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[528];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[529] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[529];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[52] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[52];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[530] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[530];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[531] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[531];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[532] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[532];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[533] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[533];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[534] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[534];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[535] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[535];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[536] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[536];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[537] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[537];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[538] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[538];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[539] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[539];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[53] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[53];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[540] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[540];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[541] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[541];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[542] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[542];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[543] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[543];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[544] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[544];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[545] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[545];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[546] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[546];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[547] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[547];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[548] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[548];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[549] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[549];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[54] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[54];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[550] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[550];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[551] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[551];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[552] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[552];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[553] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[553];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[554] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[554];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[555] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[555];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[556] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[556];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[557] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[557];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[558] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[558];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[559] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[559];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[55] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[55];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[560] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[560];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[561] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[561];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[562] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[562];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[563] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[563];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[564] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[564];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[565] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[565];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[566] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[566];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[567] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[567];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[568] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[568];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[569] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[569];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[56] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[56];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[570] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[570];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[571] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[571];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[572] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[572];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[573] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[573];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[574] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[574];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[575] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[575];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[576] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[576];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[577] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[577];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[578] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[578];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[579] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[579];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[57] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[57];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[580] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[580];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[581] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[581];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[582] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[582];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[583] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[583];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[584] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[584];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[585] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[585];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[586] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[586];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[587] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[587];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[588] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[588];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[589] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[589];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[58] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[58];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[590] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[590];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[591] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[591];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[592] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[592];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[593] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[593];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[594] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[594];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[595] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[595];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[596] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[596];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[597] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[597];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[598] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[598];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[599] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[599];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[59] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[59];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[5] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[5];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[600] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[600];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[601] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[601];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[602] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[602];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[603] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[603];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[604] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[604];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[605] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[605];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[606] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[606];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[607] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[607];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[608] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[608];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[609] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[609];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[60] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[60];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[610] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[610];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[611] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[611];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[612] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[612];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[613] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[613];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[614] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[614];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[615] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[615];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[616] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[616];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[617] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[617];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[618] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[618];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[619] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[619];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[61] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[61];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[620] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[620];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[621] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[621];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[622] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[622];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[623] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[623];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[624] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[624];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[625] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[625];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[626] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[626];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[627] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[627];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[628] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[628];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[629] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[629];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[62] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[62];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[630] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[630];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[631] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[631];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[632] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[632];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[633] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[633];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[634] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[634];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[635] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[635];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[636] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[636];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[637] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[637];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[638] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[638];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[639] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[639];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[63] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[63];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[640] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[640];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[641] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[641];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[642] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[642];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[643] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[643];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[644] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[644];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[645] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[645];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[646] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[646];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[647] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[647];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[648] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[648];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[649] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[649];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[64] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[64];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[650] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[650];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[651] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[651];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[652] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[652];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[653] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[653];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[654] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[654];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[655] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[655];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[656] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[656];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[657] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[657];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[658] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[658];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[659] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[659];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[65] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[65];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[660] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[660];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[661] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[661];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[662] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[662];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[663] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[663];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[664] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[664];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[665] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[665];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[666] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[666];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[667] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[667];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[668] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[668];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[669] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[669];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[66] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[66];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[670] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[670];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[671] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[671];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[672] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[672];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[673] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[673];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[674] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[674];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[675] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[675];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[676] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[676];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[677] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[677];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[678] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[678];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[679] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[679];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[67] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[67];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[680] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[680];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[681] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[681];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[682] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[682];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[683] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[683];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[684] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[684];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[685] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[685];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[686] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[686];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[687] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[687];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[688] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[688];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[689] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[689];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[68] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[68];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[690] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[690];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[691] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[691];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[692] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[692];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[693] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[693];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[694] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[694];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[695] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[695];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[696] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[696];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[697] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[697];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[698] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[698];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[699] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[699];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[69] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[69];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[6] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[6];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[700] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[700];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[701] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[701];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[702] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[702];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[703] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[703];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[70] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[70];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[71] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[71];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[72] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[72];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[73] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[73];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[74] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[74];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[75] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[75];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[76] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[76];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[77] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[77];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[78] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[78];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[79] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[79];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[7] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[7];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[80] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[80];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[81] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[81];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[82] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[82];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[83] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[83];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[84] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[84];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[85] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[85];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[86] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[86];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[87] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[87];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[88] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[88];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[89] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[89];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[8] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[8];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[90] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[90];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[91] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[91];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[92] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[92];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[93] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[93];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[94] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[94];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[95] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[95];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[96] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[96];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[97] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[97];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[98] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[98];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[99] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[99];
	assign x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out[9] = x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[9];
	assign x_std_sm_flux_ingress_0__i_dat_pcs_measlatbit_1 = x_std_sm_flux_ingress_0__i_dat_pcs_measlatbit;
	assign x_std_sm_flux_ingress_0__i_dpma_refclk_1 = x_std_sm_flux_ingress_0__i_dpma_refclk;
	assign x_std_sm_flux_ingress_0__i_flux_cpi_int_1 = x_std_sm_flux_ingress_0__i_flux_cpi_int;
	assign x_std_sm_flux_ingress_0__i_flux_int_1 = x_std_sm_flux_ingress_0__i_flux_int;
	assign x_std_sm_flux_ingress_0__i_flux_srds_rdy_1 = x_std_sm_flux_ingress_0__i_flux_srds_rdy;
	assign x_std_sm_flux_ingress_0__i_ft_rx_async_pulse_ch_1 = x_std_sm_flux_ingress_0__i_ft_rx_async_pulse_ch;
	assign x_std_sm_flux_ingress_0__i_ft_rx_sclk_sync_ch_1 = x_std_sm_flux_ingress_0__i_ft_rx_sclk_sync_ch;
	assign x_std_sm_flux_ingress_0__i_ft_tx_async_pulse_ch_1 = x_std_sm_flux_ingress_0__i_ft_tx_async_pulse_ch;
	assign x_std_sm_flux_ingress_0__i_ft_tx_sclk_sync_ch_1 = x_std_sm_flux_ingress_0__i_ft_tx_sclk_sync_ch;
	assign x_std_sm_flux_ingress_0__i_ictl_pcs_txenable_a_1 = x_std_sm_flux_ingress_0__i_ictl_pcs_txenable_a;
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[0] = x_std_sm_flux_ingress_0__i_lavmm_addr[0];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[10] = x_std_sm_flux_ingress_0__i_lavmm_addr[10];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[11] = x_std_sm_flux_ingress_0__i_lavmm_addr[11];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[12] = x_std_sm_flux_ingress_0__i_lavmm_addr[12];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[13] = x_std_sm_flux_ingress_0__i_lavmm_addr[13];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[14] = x_std_sm_flux_ingress_0__i_lavmm_addr[14];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[15] = x_std_sm_flux_ingress_0__i_lavmm_addr[15];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[16] = x_std_sm_flux_ingress_0__i_lavmm_addr[16];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[17] = x_std_sm_flux_ingress_0__i_lavmm_addr[17];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[18] = x_std_sm_flux_ingress_0__i_lavmm_addr[18];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[19] = x_std_sm_flux_ingress_0__i_lavmm_addr[19];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[1] = x_std_sm_flux_ingress_0__i_lavmm_addr[1];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[2] = x_std_sm_flux_ingress_0__i_lavmm_addr[2];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[3] = x_std_sm_flux_ingress_0__i_lavmm_addr[3];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[4] = x_std_sm_flux_ingress_0__i_lavmm_addr[4];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[5] = x_std_sm_flux_ingress_0__i_lavmm_addr[5];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[6] = x_std_sm_flux_ingress_0__i_lavmm_addr[6];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[7] = x_std_sm_flux_ingress_0__i_lavmm_addr[7];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[8] = x_std_sm_flux_ingress_0__i_lavmm_addr[8];
	assign x_std_sm_flux_ingress_0__i_lavmm_addr_0[9] = x_std_sm_flux_ingress_0__i_lavmm_addr[9];
	assign x_std_sm_flux_ingress_0__i_lavmm_be_0[0] = x_std_sm_flux_ingress_0__i_lavmm_be[0];
	assign x_std_sm_flux_ingress_0__i_lavmm_be_0[1] = x_std_sm_flux_ingress_0__i_lavmm_be[1];
	assign x_std_sm_flux_ingress_0__i_lavmm_be_0[2] = x_std_sm_flux_ingress_0__i_lavmm_be[2];
	assign x_std_sm_flux_ingress_0__i_lavmm_be_0[3] = x_std_sm_flux_ingress_0__i_lavmm_be[3];
	assign x_std_sm_flux_ingress_0__i_lavmm_clk_1 = x_std_sm_flux_ingress_0__i_lavmm_clk;
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[0] = x_std_sm_flux_ingress_0__i_lavmm_rdata[0];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[10] = x_std_sm_flux_ingress_0__i_lavmm_rdata[10];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[11] = x_std_sm_flux_ingress_0__i_lavmm_rdata[11];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[12] = x_std_sm_flux_ingress_0__i_lavmm_rdata[12];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[13] = x_std_sm_flux_ingress_0__i_lavmm_rdata[13];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[14] = x_std_sm_flux_ingress_0__i_lavmm_rdata[14];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[15] = x_std_sm_flux_ingress_0__i_lavmm_rdata[15];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[16] = x_std_sm_flux_ingress_0__i_lavmm_rdata[16];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[17] = x_std_sm_flux_ingress_0__i_lavmm_rdata[17];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[18] = x_std_sm_flux_ingress_0__i_lavmm_rdata[18];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[19] = x_std_sm_flux_ingress_0__i_lavmm_rdata[19];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[1] = x_std_sm_flux_ingress_0__i_lavmm_rdata[1];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[20] = x_std_sm_flux_ingress_0__i_lavmm_rdata[20];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[21] = x_std_sm_flux_ingress_0__i_lavmm_rdata[21];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[22] = x_std_sm_flux_ingress_0__i_lavmm_rdata[22];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[23] = x_std_sm_flux_ingress_0__i_lavmm_rdata[23];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[24] = x_std_sm_flux_ingress_0__i_lavmm_rdata[24];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[25] = x_std_sm_flux_ingress_0__i_lavmm_rdata[25];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[26] = x_std_sm_flux_ingress_0__i_lavmm_rdata[26];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[27] = x_std_sm_flux_ingress_0__i_lavmm_rdata[27];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[28] = x_std_sm_flux_ingress_0__i_lavmm_rdata[28];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[29] = x_std_sm_flux_ingress_0__i_lavmm_rdata[29];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[2] = x_std_sm_flux_ingress_0__i_lavmm_rdata[2];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[30] = x_std_sm_flux_ingress_0__i_lavmm_rdata[30];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[31] = x_std_sm_flux_ingress_0__i_lavmm_rdata[31];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[3] = x_std_sm_flux_ingress_0__i_lavmm_rdata[3];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[4] = x_std_sm_flux_ingress_0__i_lavmm_rdata[4];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[5] = x_std_sm_flux_ingress_0__i_lavmm_rdata[5];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[6] = x_std_sm_flux_ingress_0__i_lavmm_rdata[6];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[7] = x_std_sm_flux_ingress_0__i_lavmm_rdata[7];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[8] = x_std_sm_flux_ingress_0__i_lavmm_rdata[8];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_0[9] = x_std_sm_flux_ingress_0__i_lavmm_rdata[9];
	assign x_std_sm_flux_ingress_0__i_lavmm_rdata_valid_1 = x_std_sm_flux_ingress_0__i_lavmm_rdata_valid;
	assign x_std_sm_flux_ingress_0__i_lavmm_read_1 = x_std_sm_flux_ingress_0__i_lavmm_read;
	assign x_std_sm_flux_ingress_0__i_lavmm_rstn_1 = x_std_sm_flux_ingress_0__i_lavmm_rstn;
	assign x_std_sm_flux_ingress_0__i_lavmm_waitreq_1 = x_std_sm_flux_ingress_0__i_lavmm_waitreq;
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[0] = x_std_sm_flux_ingress_0__i_lavmm_wdata[0];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[10] = x_std_sm_flux_ingress_0__i_lavmm_wdata[10];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[11] = x_std_sm_flux_ingress_0__i_lavmm_wdata[11];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[12] = x_std_sm_flux_ingress_0__i_lavmm_wdata[12];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[13] = x_std_sm_flux_ingress_0__i_lavmm_wdata[13];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[14] = x_std_sm_flux_ingress_0__i_lavmm_wdata[14];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[15] = x_std_sm_flux_ingress_0__i_lavmm_wdata[15];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[16] = x_std_sm_flux_ingress_0__i_lavmm_wdata[16];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[17] = x_std_sm_flux_ingress_0__i_lavmm_wdata[17];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[18] = x_std_sm_flux_ingress_0__i_lavmm_wdata[18];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[19] = x_std_sm_flux_ingress_0__i_lavmm_wdata[19];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[1] = x_std_sm_flux_ingress_0__i_lavmm_wdata[1];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[20] = x_std_sm_flux_ingress_0__i_lavmm_wdata[20];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[21] = x_std_sm_flux_ingress_0__i_lavmm_wdata[21];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[22] = x_std_sm_flux_ingress_0__i_lavmm_wdata[22];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[23] = x_std_sm_flux_ingress_0__i_lavmm_wdata[23];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[24] = x_std_sm_flux_ingress_0__i_lavmm_wdata[24];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[25] = x_std_sm_flux_ingress_0__i_lavmm_wdata[25];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[26] = x_std_sm_flux_ingress_0__i_lavmm_wdata[26];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[27] = x_std_sm_flux_ingress_0__i_lavmm_wdata[27];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[28] = x_std_sm_flux_ingress_0__i_lavmm_wdata[28];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[29] = x_std_sm_flux_ingress_0__i_lavmm_wdata[29];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[2] = x_std_sm_flux_ingress_0__i_lavmm_wdata[2];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[30] = x_std_sm_flux_ingress_0__i_lavmm_wdata[30];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[31] = x_std_sm_flux_ingress_0__i_lavmm_wdata[31];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[3] = x_std_sm_flux_ingress_0__i_lavmm_wdata[3];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[4] = x_std_sm_flux_ingress_0__i_lavmm_wdata[4];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[5] = x_std_sm_flux_ingress_0__i_lavmm_wdata[5];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[6] = x_std_sm_flux_ingress_0__i_lavmm_wdata[6];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[7] = x_std_sm_flux_ingress_0__i_lavmm_wdata[7];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[8] = x_std_sm_flux_ingress_0__i_lavmm_wdata[8];
	assign x_std_sm_flux_ingress_0__i_lavmm_wdata_0[9] = x_std_sm_flux_ingress_0__i_lavmm_wdata[9];
	assign x_std_sm_flux_ingress_0__i_lavmm_write_1 = x_std_sm_flux_ingress_0__i_lavmm_write;
	assign x_std_sm_flux_ingress_0__i_lfps_ennt_1 = x_std_sm_flux_ingress_0__i_lfps_ennt;
	assign x_std_sm_flux_ingress_0__i_ock_pcs_txword_1 = x_std_sm_flux_ingress_0__i_ock_pcs_txword;
	assign x_std_sm_flux_ingress_0__i_oflux_octl_pcs_txptr_smpl_lane_1 = x_std_sm_flux_ingress_0__i_oflux_octl_pcs_txptr_smpl_lane;
	assign x_std_sm_flux_ingress_0__i_pcie_l1ctrla_0[0] = x_std_sm_flux_ingress_0__i_pcie_l1ctrla[0];
	assign x_std_sm_flux_ingress_0__i_pcie_l1ctrla_0[1] = x_std_sm_flux_ingress_0__i_pcie_l1ctrla[1];
	assign x_std_sm_flux_ingress_0__i_pcie_pcs_rx_rst_1 = x_std_sm_flux_ingress_0__i_pcie_pcs_rx_rst;
	assign x_std_sm_flux_ingress_0__i_pcie_pcs_tx_rst_1 = x_std_sm_flux_ingress_0__i_pcie_pcs_tx_rst;
	assign x_std_sm_flux_ingress_0__i_pcs_pipe_rstn_1 = x_std_sm_flux_ingress_0__i_pcs_pipe_rstn;
	assign x_std_sm_flux_ingress_0__i_pcs_rxpostdiv_1 = x_std_sm_flux_ingress_0__i_pcs_rxpostdiv;
	assign x_std_sm_flux_ingress_0__i_pcs_rxword_1 = x_std_sm_flux_ingress_0__i_pcs_rxword;
	assign x_std_sm_flux_ingress_0__i_pma_cmn_ctrl_1 = x_std_sm_flux_ingress_0__i_pma_cmn_ctrl;
	assign x_std_sm_flux_ingress_0__i_pma_ctrl_1 = x_std_sm_flux_ingress_0__i_pma_ctrl;
	assign x_std_sm_flux_ingress_0__i_quartus_flux_s_to_ingress_1 = x_std_sm_flux_ingress_0__i_quartus_flux_s_to_ingress;
	assign x_std_sm_flux_ingress_0__i_rst_pld_ux_rx_pma_rst_n_1 = x_std_sm_flux_ingress_0__i_rst_pld_ux_rx_pma_rst_n;
	assign x_std_sm_flux_ingress_0__i_rst_pld_ux_tx_pma_rst_n_1 = x_std_sm_flux_ingress_0__i_rst_pld_ux_tx_pma_rst_n;
	assign x_std_sm_flux_ingress_0__i_rst_ux_rx_sfrz_1 = x_std_sm_flux_ingress_0__i_rst_ux_rx_sfrz;
	assign x_std_sm_flux_ingress_0__i_rx_data_0[0] = x_std_sm_flux_ingress_0__i_rx_data[0];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[10] = x_std_sm_flux_ingress_0__i_rx_data[10];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[11] = x_std_sm_flux_ingress_0__i_rx_data[11];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[12] = x_std_sm_flux_ingress_0__i_rx_data[12];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[13] = x_std_sm_flux_ingress_0__i_rx_data[13];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[14] = x_std_sm_flux_ingress_0__i_rx_data[14];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[15] = x_std_sm_flux_ingress_0__i_rx_data[15];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[16] = x_std_sm_flux_ingress_0__i_rx_data[16];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[17] = x_std_sm_flux_ingress_0__i_rx_data[17];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[18] = x_std_sm_flux_ingress_0__i_rx_data[18];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[19] = x_std_sm_flux_ingress_0__i_rx_data[19];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[1] = x_std_sm_flux_ingress_0__i_rx_data[1];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[20] = x_std_sm_flux_ingress_0__i_rx_data[20];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[21] = x_std_sm_flux_ingress_0__i_rx_data[21];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[22] = x_std_sm_flux_ingress_0__i_rx_data[22];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[23] = x_std_sm_flux_ingress_0__i_rx_data[23];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[24] = x_std_sm_flux_ingress_0__i_rx_data[24];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[25] = x_std_sm_flux_ingress_0__i_rx_data[25];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[26] = x_std_sm_flux_ingress_0__i_rx_data[26];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[27] = x_std_sm_flux_ingress_0__i_rx_data[27];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[28] = x_std_sm_flux_ingress_0__i_rx_data[28];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[29] = x_std_sm_flux_ingress_0__i_rx_data[29];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[2] = x_std_sm_flux_ingress_0__i_rx_data[2];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[30] = x_std_sm_flux_ingress_0__i_rx_data[30];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[31] = x_std_sm_flux_ingress_0__i_rx_data[31];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[32] = x_std_sm_flux_ingress_0__i_rx_data[32];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[33] = x_std_sm_flux_ingress_0__i_rx_data[33];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[34] = x_std_sm_flux_ingress_0__i_rx_data[34];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[35] = x_std_sm_flux_ingress_0__i_rx_data[35];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[36] = x_std_sm_flux_ingress_0__i_rx_data[36];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[37] = x_std_sm_flux_ingress_0__i_rx_data[37];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[38] = x_std_sm_flux_ingress_0__i_rx_data[38];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[39] = x_std_sm_flux_ingress_0__i_rx_data[39];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[3] = x_std_sm_flux_ingress_0__i_rx_data[3];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[40] = x_std_sm_flux_ingress_0__i_rx_data[40];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[41] = x_std_sm_flux_ingress_0__i_rx_data[41];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[42] = x_std_sm_flux_ingress_0__i_rx_data[42];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[43] = x_std_sm_flux_ingress_0__i_rx_data[43];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[44] = x_std_sm_flux_ingress_0__i_rx_data[44];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[45] = x_std_sm_flux_ingress_0__i_rx_data[45];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[46] = x_std_sm_flux_ingress_0__i_rx_data[46];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[47] = x_std_sm_flux_ingress_0__i_rx_data[47];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[48] = x_std_sm_flux_ingress_0__i_rx_data[48];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[49] = x_std_sm_flux_ingress_0__i_rx_data[49];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[4] = x_std_sm_flux_ingress_0__i_rx_data[4];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[50] = x_std_sm_flux_ingress_0__i_rx_data[50];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[51] = x_std_sm_flux_ingress_0__i_rx_data[51];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[52] = x_std_sm_flux_ingress_0__i_rx_data[52];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[53] = x_std_sm_flux_ingress_0__i_rx_data[53];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[54] = x_std_sm_flux_ingress_0__i_rx_data[54];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[55] = x_std_sm_flux_ingress_0__i_rx_data[55];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[56] = x_std_sm_flux_ingress_0__i_rx_data[56];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[57] = x_std_sm_flux_ingress_0__i_rx_data[57];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[58] = x_std_sm_flux_ingress_0__i_rx_data[58];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[59] = x_std_sm_flux_ingress_0__i_rx_data[59];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[5] = x_std_sm_flux_ingress_0__i_rx_data[5];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[60] = x_std_sm_flux_ingress_0__i_rx_data[60];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[61] = x_std_sm_flux_ingress_0__i_rx_data[61];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[62] = x_std_sm_flux_ingress_0__i_rx_data[62];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[63] = x_std_sm_flux_ingress_0__i_rx_data[63];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[64] = x_std_sm_flux_ingress_0__i_rx_data[64];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[65] = x_std_sm_flux_ingress_0__i_rx_data[65];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[66] = x_std_sm_flux_ingress_0__i_rx_data[66];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[67] = x_std_sm_flux_ingress_0__i_rx_data[67];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[68] = x_std_sm_flux_ingress_0__i_rx_data[68];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[69] = x_std_sm_flux_ingress_0__i_rx_data[69];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[6] = x_std_sm_flux_ingress_0__i_rx_data[6];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[70] = x_std_sm_flux_ingress_0__i_rx_data[70];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[71] = x_std_sm_flux_ingress_0__i_rx_data[71];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[72] = x_std_sm_flux_ingress_0__i_rx_data[72];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[73] = x_std_sm_flux_ingress_0__i_rx_data[73];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[74] = x_std_sm_flux_ingress_0__i_rx_data[74];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[75] = x_std_sm_flux_ingress_0__i_rx_data[75];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[76] = x_std_sm_flux_ingress_0__i_rx_data[76];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[77] = x_std_sm_flux_ingress_0__i_rx_data[77];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[78] = x_std_sm_flux_ingress_0__i_rx_data[78];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[79] = x_std_sm_flux_ingress_0__i_rx_data[79];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[7] = x_std_sm_flux_ingress_0__i_rx_data[7];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[8] = x_std_sm_flux_ingress_0__i_rx_data[8];
	assign x_std_sm_flux_ingress_0__i_rx_data_0[9] = x_std_sm_flux_ingress_0__i_rx_data[9];
	assign x_std_sm_flux_ingress_0__i_rx_dl_ch_bit_1 = x_std_sm_flux_ingress_0__i_rx_dl_ch_bit;
	assign x_std_sm_flux_ingress_0__i_rxeiosdetectstata_1 = x_std_sm_flux_ingress_0__i_rxeiosdetectstata;
	assign x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt_0[0] = x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt[0];
	assign x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt_0[1] = x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt[1];
	assign x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt_0[2] = x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt[2];
	assign x_std_sm_flux_ingress_0__i_rxeq_starta_1 = x_std_sm_flux_ingress_0__i_rxeq_starta;
	assign x_std_sm_flux_ingress_0__i_rxeq_static_ena_1 = x_std_sm_flux_ingress_0__i_rxeq_static_ena;
	assign x_std_sm_flux_ingress_0__i_rxmargin_direction_nt_1 = x_std_sm_flux_ingress_0__i_rxmargin_direction_nt;
	assign x_std_sm_flux_ingress_0__i_rxmargin_mode_nt_1 = x_std_sm_flux_ingress_0__i_rxmargin_mode_nt;
	assign x_std_sm_flux_ingress_0__i_rxmargin_offset_change_a_1 = x_std_sm_flux_ingress_0__i_rxmargin_offset_change_a;
	assign x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[0] = x_std_sm_flux_ingress_0__i_rxmargin_offset_nt[0];
	assign x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[1] = x_std_sm_flux_ingress_0__i_rxmargin_offset_nt[1];
	assign x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[2] = x_std_sm_flux_ingress_0__i_rxmargin_offset_nt[2];
	assign x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[3] = x_std_sm_flux_ingress_0__i_rxmargin_offset_nt[3];
	assign x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[4] = x_std_sm_flux_ingress_0__i_rxmargin_offset_nt[4];
	assign x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[5] = x_std_sm_flux_ingress_0__i_rxmargin_offset_nt[5];
	assign x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[6] = x_std_sm_flux_ingress_0__i_rxmargin_offset_nt[6];
	assign x_std_sm_flux_ingress_0__i_rxmargin_start_a_1 = x_std_sm_flux_ingress_0__i_rxmargin_start_a;
	assign x_std_sm_flux_ingress_0__i_rxpstate_0[0] = x_std_sm_flux_ingress_0__i_rxpstate[0];
	assign x_std_sm_flux_ingress_0__i_rxpstate_0[1] = x_std_sm_flux_ingress_0__i_rxpstate[1];
	assign x_std_sm_flux_ingress_0__i_rxpstate_0[2] = x_std_sm_flux_ingress_0__i_rxpstate[2];
	assign x_std_sm_flux_ingress_0__i_rxrate_0[0] = x_std_sm_flux_ingress_0__i_rxrate[0];
	assign x_std_sm_flux_ingress_0__i_rxrate_0[1] = x_std_sm_flux_ingress_0__i_rxrate[1];
	assign x_std_sm_flux_ingress_0__i_rxrate_0[2] = x_std_sm_flux_ingress_0__i_rxrate[2];
	assign x_std_sm_flux_ingress_0__i_rxrate_0[3] = x_std_sm_flux_ingress_0__i_rxrate[3];
	assign x_std_sm_flux_ingress_0__i_rxterm_hiz_ena_1 = x_std_sm_flux_ingress_0__i_rxterm_hiz_ena;
	assign x_std_sm_flux_ingress_0__i_rxwidth_0[0] = x_std_sm_flux_ingress_0__i_rxwidth[0];
	assign x_std_sm_flux_ingress_0__i_rxwidth_0[1] = x_std_sm_flux_ingress_0__i_rxwidth[1];
	assign x_std_sm_flux_ingress_0__i_rxwidth_0[2] = x_std_sm_flux_ingress_0__i_rxwidth[2];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[0] = x_std_sm_flux_ingress_0__i_sm_flux_egress[0];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[100] = x_std_sm_flux_ingress_0__i_sm_flux_egress[100];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[101] = x_std_sm_flux_ingress_0__i_sm_flux_egress[101];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[102] = x_std_sm_flux_ingress_0__i_sm_flux_egress[102];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[103] = x_std_sm_flux_ingress_0__i_sm_flux_egress[103];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[104] = x_std_sm_flux_ingress_0__i_sm_flux_egress[104];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[105] = x_std_sm_flux_ingress_0__i_sm_flux_egress[105];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[106] = x_std_sm_flux_ingress_0__i_sm_flux_egress[106];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[107] = x_std_sm_flux_ingress_0__i_sm_flux_egress[107];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[108] = x_std_sm_flux_ingress_0__i_sm_flux_egress[108];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[109] = x_std_sm_flux_ingress_0__i_sm_flux_egress[109];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[10] = x_std_sm_flux_ingress_0__i_sm_flux_egress[10];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[110] = x_std_sm_flux_ingress_0__i_sm_flux_egress[110];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[111] = x_std_sm_flux_ingress_0__i_sm_flux_egress[111];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[112] = x_std_sm_flux_ingress_0__i_sm_flux_egress[112];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[113] = x_std_sm_flux_ingress_0__i_sm_flux_egress[113];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[114] = x_std_sm_flux_ingress_0__i_sm_flux_egress[114];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[115] = x_std_sm_flux_ingress_0__i_sm_flux_egress[115];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[116] = x_std_sm_flux_ingress_0__i_sm_flux_egress[116];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[117] = x_std_sm_flux_ingress_0__i_sm_flux_egress[117];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[118] = x_std_sm_flux_ingress_0__i_sm_flux_egress[118];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[119] = x_std_sm_flux_ingress_0__i_sm_flux_egress[119];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[11] = x_std_sm_flux_ingress_0__i_sm_flux_egress[11];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[120] = x_std_sm_flux_ingress_0__i_sm_flux_egress[120];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[121] = x_std_sm_flux_ingress_0__i_sm_flux_egress[121];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[122] = x_std_sm_flux_ingress_0__i_sm_flux_egress[122];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[123] = x_std_sm_flux_ingress_0__i_sm_flux_egress[123];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[124] = x_std_sm_flux_ingress_0__i_sm_flux_egress[124];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[125] = x_std_sm_flux_ingress_0__i_sm_flux_egress[125];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[126] = x_std_sm_flux_ingress_0__i_sm_flux_egress[126];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[127] = x_std_sm_flux_ingress_0__i_sm_flux_egress[127];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[128] = x_std_sm_flux_ingress_0__i_sm_flux_egress[128];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[129] = x_std_sm_flux_ingress_0__i_sm_flux_egress[129];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[12] = x_std_sm_flux_ingress_0__i_sm_flux_egress[12];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[130] = x_std_sm_flux_ingress_0__i_sm_flux_egress[130];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[131] = x_std_sm_flux_ingress_0__i_sm_flux_egress[131];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[132] = x_std_sm_flux_ingress_0__i_sm_flux_egress[132];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[133] = x_std_sm_flux_ingress_0__i_sm_flux_egress[133];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[134] = x_std_sm_flux_ingress_0__i_sm_flux_egress[134];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[135] = x_std_sm_flux_ingress_0__i_sm_flux_egress[135];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[136] = x_std_sm_flux_ingress_0__i_sm_flux_egress[136];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[137] = x_std_sm_flux_ingress_0__i_sm_flux_egress[137];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[138] = x_std_sm_flux_ingress_0__i_sm_flux_egress[138];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[139] = x_std_sm_flux_ingress_0__i_sm_flux_egress[139];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[13] = x_std_sm_flux_ingress_0__i_sm_flux_egress[13];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[140] = x_std_sm_flux_ingress_0__i_sm_flux_egress[140];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[141] = x_std_sm_flux_ingress_0__i_sm_flux_egress[141];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[142] = x_std_sm_flux_ingress_0__i_sm_flux_egress[142];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[143] = x_std_sm_flux_ingress_0__i_sm_flux_egress[143];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[144] = x_std_sm_flux_ingress_0__i_sm_flux_egress[144];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[145] = x_std_sm_flux_ingress_0__i_sm_flux_egress[145];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[146] = x_std_sm_flux_ingress_0__i_sm_flux_egress[146];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[147] = x_std_sm_flux_ingress_0__i_sm_flux_egress[147];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[148] = x_std_sm_flux_ingress_0__i_sm_flux_egress[148];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[149] = x_std_sm_flux_ingress_0__i_sm_flux_egress[149];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[14] = x_std_sm_flux_ingress_0__i_sm_flux_egress[14];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[150] = x_std_sm_flux_ingress_0__i_sm_flux_egress[150];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[151] = x_std_sm_flux_ingress_0__i_sm_flux_egress[151];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[152] = x_std_sm_flux_ingress_0__i_sm_flux_egress[152];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[153] = x_std_sm_flux_ingress_0__i_sm_flux_egress[153];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[154] = x_std_sm_flux_ingress_0__i_sm_flux_egress[154];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[155] = x_std_sm_flux_ingress_0__i_sm_flux_egress[155];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[156] = x_std_sm_flux_ingress_0__i_sm_flux_egress[156];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[157] = x_std_sm_flux_ingress_0__i_sm_flux_egress[157];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[158] = x_std_sm_flux_ingress_0__i_sm_flux_egress[158];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[159] = x_std_sm_flux_ingress_0__i_sm_flux_egress[159];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[15] = x_std_sm_flux_ingress_0__i_sm_flux_egress[15];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[160] = x_std_sm_flux_ingress_0__i_sm_flux_egress[160];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[161] = x_std_sm_flux_ingress_0__i_sm_flux_egress[161];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[162] = x_std_sm_flux_ingress_0__i_sm_flux_egress[162];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[163] = x_std_sm_flux_ingress_0__i_sm_flux_egress[163];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[164] = x_std_sm_flux_ingress_0__i_sm_flux_egress[164];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[165] = x_std_sm_flux_ingress_0__i_sm_flux_egress[165];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[166] = x_std_sm_flux_ingress_0__i_sm_flux_egress[166];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[167] = x_std_sm_flux_ingress_0__i_sm_flux_egress[167];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[168] = x_std_sm_flux_ingress_0__i_sm_flux_egress[168];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[169] = x_std_sm_flux_ingress_0__i_sm_flux_egress[169];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[16] = x_std_sm_flux_ingress_0__i_sm_flux_egress[16];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[170] = x_std_sm_flux_ingress_0__i_sm_flux_egress[170];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[171] = x_std_sm_flux_ingress_0__i_sm_flux_egress[171];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[172] = x_std_sm_flux_ingress_0__i_sm_flux_egress[172];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[173] = x_std_sm_flux_ingress_0__i_sm_flux_egress[173];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[174] = x_std_sm_flux_ingress_0__i_sm_flux_egress[174];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[175] = x_std_sm_flux_ingress_0__i_sm_flux_egress[175];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[176] = x_std_sm_flux_ingress_0__i_sm_flux_egress[176];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[177] = x_std_sm_flux_ingress_0__i_sm_flux_egress[177];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[178] = x_std_sm_flux_ingress_0__i_sm_flux_egress[178];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[179] = x_std_sm_flux_ingress_0__i_sm_flux_egress[179];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[17] = x_std_sm_flux_ingress_0__i_sm_flux_egress[17];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[180] = x_std_sm_flux_ingress_0__i_sm_flux_egress[180];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[181] = x_std_sm_flux_ingress_0__i_sm_flux_egress[181];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[182] = x_std_sm_flux_ingress_0__i_sm_flux_egress[182];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[183] = x_std_sm_flux_ingress_0__i_sm_flux_egress[183];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[184] = x_std_sm_flux_ingress_0__i_sm_flux_egress[184];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[185] = x_std_sm_flux_ingress_0__i_sm_flux_egress[185];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[186] = x_std_sm_flux_ingress_0__i_sm_flux_egress[186];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[187] = x_std_sm_flux_ingress_0__i_sm_flux_egress[187];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[188] = x_std_sm_flux_ingress_0__i_sm_flux_egress[188];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[189] = x_std_sm_flux_ingress_0__i_sm_flux_egress[189];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[18] = x_std_sm_flux_ingress_0__i_sm_flux_egress[18];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[190] = x_std_sm_flux_ingress_0__i_sm_flux_egress[190];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[191] = x_std_sm_flux_ingress_0__i_sm_flux_egress[191];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[192] = x_std_sm_flux_ingress_0__i_sm_flux_egress[192];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[193] = x_std_sm_flux_ingress_0__i_sm_flux_egress[193];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[194] = x_std_sm_flux_ingress_0__i_sm_flux_egress[194];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[195] = x_std_sm_flux_ingress_0__i_sm_flux_egress[195];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[196] = x_std_sm_flux_ingress_0__i_sm_flux_egress[196];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[197] = x_std_sm_flux_ingress_0__i_sm_flux_egress[197];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[198] = x_std_sm_flux_ingress_0__i_sm_flux_egress[198];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[199] = x_std_sm_flux_ingress_0__i_sm_flux_egress[199];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[19] = x_std_sm_flux_ingress_0__i_sm_flux_egress[19];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[1] = x_std_sm_flux_ingress_0__i_sm_flux_egress[1];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[200] = x_std_sm_flux_ingress_0__i_sm_flux_egress[200];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[201] = x_std_sm_flux_ingress_0__i_sm_flux_egress[201];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[202] = x_std_sm_flux_ingress_0__i_sm_flux_egress[202];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[203] = x_std_sm_flux_ingress_0__i_sm_flux_egress[203];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[204] = x_std_sm_flux_ingress_0__i_sm_flux_egress[204];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[205] = x_std_sm_flux_ingress_0__i_sm_flux_egress[205];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[206] = x_std_sm_flux_ingress_0__i_sm_flux_egress[206];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[207] = x_std_sm_flux_ingress_0__i_sm_flux_egress[207];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[208] = x_std_sm_flux_ingress_0__i_sm_flux_egress[208];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[209] = x_std_sm_flux_ingress_0__i_sm_flux_egress[209];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[20] = x_std_sm_flux_ingress_0__i_sm_flux_egress[20];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[210] = x_std_sm_flux_ingress_0__i_sm_flux_egress[210];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[211] = x_std_sm_flux_ingress_0__i_sm_flux_egress[211];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[212] = x_std_sm_flux_ingress_0__i_sm_flux_egress[212];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[213] = x_std_sm_flux_ingress_0__i_sm_flux_egress[213];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[214] = x_std_sm_flux_ingress_0__i_sm_flux_egress[214];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[215] = x_std_sm_flux_ingress_0__i_sm_flux_egress[215];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[216] = x_std_sm_flux_ingress_0__i_sm_flux_egress[216];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[217] = x_std_sm_flux_ingress_0__i_sm_flux_egress[217];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[218] = x_std_sm_flux_ingress_0__i_sm_flux_egress[218];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[219] = x_std_sm_flux_ingress_0__i_sm_flux_egress[219];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[21] = x_std_sm_flux_ingress_0__i_sm_flux_egress[21];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[220] = x_std_sm_flux_ingress_0__i_sm_flux_egress[220];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[221] = x_std_sm_flux_ingress_0__i_sm_flux_egress[221];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[222] = x_std_sm_flux_ingress_0__i_sm_flux_egress[222];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[223] = x_std_sm_flux_ingress_0__i_sm_flux_egress[223];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[224] = x_std_sm_flux_ingress_0__i_sm_flux_egress[224];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[225] = x_std_sm_flux_ingress_0__i_sm_flux_egress[225];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[226] = x_std_sm_flux_ingress_0__i_sm_flux_egress[226];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[227] = x_std_sm_flux_ingress_0__i_sm_flux_egress[227];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[228] = x_std_sm_flux_ingress_0__i_sm_flux_egress[228];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[229] = x_std_sm_flux_ingress_0__i_sm_flux_egress[229];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[22] = x_std_sm_flux_ingress_0__i_sm_flux_egress[22];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[230] = x_std_sm_flux_ingress_0__i_sm_flux_egress[230];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[231] = x_std_sm_flux_ingress_0__i_sm_flux_egress[231];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[232] = x_std_sm_flux_ingress_0__i_sm_flux_egress[232];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[233] = x_std_sm_flux_ingress_0__i_sm_flux_egress[233];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[234] = x_std_sm_flux_ingress_0__i_sm_flux_egress[234];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[235] = x_std_sm_flux_ingress_0__i_sm_flux_egress[235];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[236] = x_std_sm_flux_ingress_0__i_sm_flux_egress[236];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[237] = x_std_sm_flux_ingress_0__i_sm_flux_egress[237];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[238] = x_std_sm_flux_ingress_0__i_sm_flux_egress[238];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[239] = x_std_sm_flux_ingress_0__i_sm_flux_egress[239];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[23] = x_std_sm_flux_ingress_0__i_sm_flux_egress[23];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[240] = x_std_sm_flux_ingress_0__i_sm_flux_egress[240];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[241] = x_std_sm_flux_ingress_0__i_sm_flux_egress[241];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[242] = x_std_sm_flux_ingress_0__i_sm_flux_egress[242];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[243] = x_std_sm_flux_ingress_0__i_sm_flux_egress[243];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[244] = x_std_sm_flux_ingress_0__i_sm_flux_egress[244];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[245] = x_std_sm_flux_ingress_0__i_sm_flux_egress[245];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[246] = x_std_sm_flux_ingress_0__i_sm_flux_egress[246];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[247] = x_std_sm_flux_ingress_0__i_sm_flux_egress[247];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[248] = x_std_sm_flux_ingress_0__i_sm_flux_egress[248];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[249] = x_std_sm_flux_ingress_0__i_sm_flux_egress[249];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[24] = x_std_sm_flux_ingress_0__i_sm_flux_egress[24];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[250] = x_std_sm_flux_ingress_0__i_sm_flux_egress[250];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[251] = x_std_sm_flux_ingress_0__i_sm_flux_egress[251];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[252] = x_std_sm_flux_ingress_0__i_sm_flux_egress[252];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[253] = x_std_sm_flux_ingress_0__i_sm_flux_egress[253];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[254] = x_std_sm_flux_ingress_0__i_sm_flux_egress[254];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[255] = x_std_sm_flux_ingress_0__i_sm_flux_egress[255];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[256] = x_std_sm_flux_ingress_0__i_sm_flux_egress[256];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[25] = x_std_sm_flux_ingress_0__i_sm_flux_egress[25];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[26] = x_std_sm_flux_ingress_0__i_sm_flux_egress[26];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[27] = x_std_sm_flux_ingress_0__i_sm_flux_egress[27];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[28] = x_std_sm_flux_ingress_0__i_sm_flux_egress[28];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[29] = x_std_sm_flux_ingress_0__i_sm_flux_egress[29];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[2] = x_std_sm_flux_ingress_0__i_sm_flux_egress[2];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[30] = x_std_sm_flux_ingress_0__i_sm_flux_egress[30];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[31] = x_std_sm_flux_ingress_0__i_sm_flux_egress[31];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[32] = x_std_sm_flux_ingress_0__i_sm_flux_egress[32];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[33] = x_std_sm_flux_ingress_0__i_sm_flux_egress[33];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[34] = x_std_sm_flux_ingress_0__i_sm_flux_egress[34];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[35] = x_std_sm_flux_ingress_0__i_sm_flux_egress[35];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[36] = x_std_sm_flux_ingress_0__i_sm_flux_egress[36];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[37] = x_std_sm_flux_ingress_0__i_sm_flux_egress[37];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[38] = x_std_sm_flux_ingress_0__i_sm_flux_egress[38];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[39] = x_std_sm_flux_ingress_0__i_sm_flux_egress[39];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[3] = x_std_sm_flux_ingress_0__i_sm_flux_egress[3];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[40] = x_std_sm_flux_ingress_0__i_sm_flux_egress[40];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[41] = x_std_sm_flux_ingress_0__i_sm_flux_egress[41];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[42] = x_std_sm_flux_ingress_0__i_sm_flux_egress[42];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[43] = x_std_sm_flux_ingress_0__i_sm_flux_egress[43];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[44] = x_std_sm_flux_ingress_0__i_sm_flux_egress[44];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[45] = x_std_sm_flux_ingress_0__i_sm_flux_egress[45];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[46] = x_std_sm_flux_ingress_0__i_sm_flux_egress[46];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[47] = x_std_sm_flux_ingress_0__i_sm_flux_egress[47];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[48] = x_std_sm_flux_ingress_0__i_sm_flux_egress[48];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[49] = x_std_sm_flux_ingress_0__i_sm_flux_egress[49];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[4] = x_std_sm_flux_ingress_0__i_sm_flux_egress[4];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[50] = x_std_sm_flux_ingress_0__i_sm_flux_egress[50];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[51] = x_std_sm_flux_ingress_0__i_sm_flux_egress[51];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[52] = x_std_sm_flux_ingress_0__i_sm_flux_egress[52];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[53] = x_std_sm_flux_ingress_0__i_sm_flux_egress[53];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[54] = x_std_sm_flux_ingress_0__i_sm_flux_egress[54];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[55] = x_std_sm_flux_ingress_0__i_sm_flux_egress[55];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[56] = x_std_sm_flux_ingress_0__i_sm_flux_egress[56];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[57] = x_std_sm_flux_ingress_0__i_sm_flux_egress[57];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[58] = x_std_sm_flux_ingress_0__i_sm_flux_egress[58];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[59] = x_std_sm_flux_ingress_0__i_sm_flux_egress[59];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[5] = x_std_sm_flux_ingress_0__i_sm_flux_egress[5];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[60] = x_std_sm_flux_ingress_0__i_sm_flux_egress[60];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[61] = x_std_sm_flux_ingress_0__i_sm_flux_egress[61];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[62] = x_std_sm_flux_ingress_0__i_sm_flux_egress[62];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[63] = x_std_sm_flux_ingress_0__i_sm_flux_egress[63];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[64] = x_std_sm_flux_ingress_0__i_sm_flux_egress[64];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[65] = x_std_sm_flux_ingress_0__i_sm_flux_egress[65];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[66] = x_std_sm_flux_ingress_0__i_sm_flux_egress[66];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[67] = x_std_sm_flux_ingress_0__i_sm_flux_egress[67];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[68] = x_std_sm_flux_ingress_0__i_sm_flux_egress[68];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[69] = x_std_sm_flux_ingress_0__i_sm_flux_egress[69];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[6] = x_std_sm_flux_ingress_0__i_sm_flux_egress[6];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[70] = x_std_sm_flux_ingress_0__i_sm_flux_egress[70];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[71] = x_std_sm_flux_ingress_0__i_sm_flux_egress[71];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[72] = x_std_sm_flux_ingress_0__i_sm_flux_egress[72];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[73] = x_std_sm_flux_ingress_0__i_sm_flux_egress[73];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[74] = x_std_sm_flux_ingress_0__i_sm_flux_egress[74];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[75] = x_std_sm_flux_ingress_0__i_sm_flux_egress[75];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[76] = x_std_sm_flux_ingress_0__i_sm_flux_egress[76];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[77] = x_std_sm_flux_ingress_0__i_sm_flux_egress[77];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[78] = x_std_sm_flux_ingress_0__i_sm_flux_egress[78];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[79] = x_std_sm_flux_ingress_0__i_sm_flux_egress[79];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[7] = x_std_sm_flux_ingress_0__i_sm_flux_egress[7];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[80] = x_std_sm_flux_ingress_0__i_sm_flux_egress[80];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[81] = x_std_sm_flux_ingress_0__i_sm_flux_egress[81];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[82] = x_std_sm_flux_ingress_0__i_sm_flux_egress[82];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[83] = x_std_sm_flux_ingress_0__i_sm_flux_egress[83];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[84] = x_std_sm_flux_ingress_0__i_sm_flux_egress[84];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[85] = x_std_sm_flux_ingress_0__i_sm_flux_egress[85];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[86] = x_std_sm_flux_ingress_0__i_sm_flux_egress[86];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[87] = x_std_sm_flux_ingress_0__i_sm_flux_egress[87];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[88] = x_std_sm_flux_ingress_0__i_sm_flux_egress[88];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[89] = x_std_sm_flux_ingress_0__i_sm_flux_egress[89];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[8] = x_std_sm_flux_ingress_0__i_sm_flux_egress[8];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[90] = x_std_sm_flux_ingress_0__i_sm_flux_egress[90];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[91] = x_std_sm_flux_ingress_0__i_sm_flux_egress[91];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[92] = x_std_sm_flux_ingress_0__i_sm_flux_egress[92];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[93] = x_std_sm_flux_ingress_0__i_sm_flux_egress[93];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[94] = x_std_sm_flux_ingress_0__i_sm_flux_egress[94];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[95] = x_std_sm_flux_ingress_0__i_sm_flux_egress[95];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[96] = x_std_sm_flux_ingress_0__i_sm_flux_egress[96];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[97] = x_std_sm_flux_ingress_0__i_sm_flux_egress[97];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[98] = x_std_sm_flux_ingress_0__i_sm_flux_egress[98];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[99] = x_std_sm_flux_ingress_0__i_sm_flux_egress[99];
	assign x_std_sm_flux_ingress_0__i_sm_flux_egress_0[9] = x_std_sm_flux_ingress_0__i_sm_flux_egress[9];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[0] = x_std_sm_flux_ingress_0__i_ss_async_pldif[0];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[10] = x_std_sm_flux_ingress_0__i_ss_async_pldif[10];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[11] = x_std_sm_flux_ingress_0__i_ss_async_pldif[11];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[12] = x_std_sm_flux_ingress_0__i_ss_async_pldif[12];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[13] = x_std_sm_flux_ingress_0__i_ss_async_pldif[13];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[14] = x_std_sm_flux_ingress_0__i_ss_async_pldif[14];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[15] = x_std_sm_flux_ingress_0__i_ss_async_pldif[15];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[16] = x_std_sm_flux_ingress_0__i_ss_async_pldif[16];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[17] = x_std_sm_flux_ingress_0__i_ss_async_pldif[17];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[18] = x_std_sm_flux_ingress_0__i_ss_async_pldif[18];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[19] = x_std_sm_flux_ingress_0__i_ss_async_pldif[19];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[1] = x_std_sm_flux_ingress_0__i_ss_async_pldif[1];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[20] = x_std_sm_flux_ingress_0__i_ss_async_pldif[20];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[21] = x_std_sm_flux_ingress_0__i_ss_async_pldif[21];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[22] = x_std_sm_flux_ingress_0__i_ss_async_pldif[22];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[23] = x_std_sm_flux_ingress_0__i_ss_async_pldif[23];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[24] = x_std_sm_flux_ingress_0__i_ss_async_pldif[24];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[25] = x_std_sm_flux_ingress_0__i_ss_async_pldif[25];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[26] = x_std_sm_flux_ingress_0__i_ss_async_pldif[26];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[27] = x_std_sm_flux_ingress_0__i_ss_async_pldif[27];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[28] = x_std_sm_flux_ingress_0__i_ss_async_pldif[28];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[29] = x_std_sm_flux_ingress_0__i_ss_async_pldif[29];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[2] = x_std_sm_flux_ingress_0__i_ss_async_pldif[2];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[30] = x_std_sm_flux_ingress_0__i_ss_async_pldif[30];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[31] = x_std_sm_flux_ingress_0__i_ss_async_pldif[31];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[32] = x_std_sm_flux_ingress_0__i_ss_async_pldif[32];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[33] = x_std_sm_flux_ingress_0__i_ss_async_pldif[33];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[34] = x_std_sm_flux_ingress_0__i_ss_async_pldif[34];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[35] = x_std_sm_flux_ingress_0__i_ss_async_pldif[35];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[36] = x_std_sm_flux_ingress_0__i_ss_async_pldif[36];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[37] = x_std_sm_flux_ingress_0__i_ss_async_pldif[37];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[38] = x_std_sm_flux_ingress_0__i_ss_async_pldif[38];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[39] = x_std_sm_flux_ingress_0__i_ss_async_pldif[39];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[3] = x_std_sm_flux_ingress_0__i_ss_async_pldif[3];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[40] = x_std_sm_flux_ingress_0__i_ss_async_pldif[40];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[41] = x_std_sm_flux_ingress_0__i_ss_async_pldif[41];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[42] = x_std_sm_flux_ingress_0__i_ss_async_pldif[42];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[43] = x_std_sm_flux_ingress_0__i_ss_async_pldif[43];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[44] = x_std_sm_flux_ingress_0__i_ss_async_pldif[44];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[45] = x_std_sm_flux_ingress_0__i_ss_async_pldif[45];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[46] = x_std_sm_flux_ingress_0__i_ss_async_pldif[46];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[47] = x_std_sm_flux_ingress_0__i_ss_async_pldif[47];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[48] = x_std_sm_flux_ingress_0__i_ss_async_pldif[48];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[49] = x_std_sm_flux_ingress_0__i_ss_async_pldif[49];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[4] = x_std_sm_flux_ingress_0__i_ss_async_pldif[4];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[50] = x_std_sm_flux_ingress_0__i_ss_async_pldif[50];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[51] = x_std_sm_flux_ingress_0__i_ss_async_pldif[51];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[52] = x_std_sm_flux_ingress_0__i_ss_async_pldif[52];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[53] = x_std_sm_flux_ingress_0__i_ss_async_pldif[53];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[54] = x_std_sm_flux_ingress_0__i_ss_async_pldif[54];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[55] = x_std_sm_flux_ingress_0__i_ss_async_pldif[55];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[56] = x_std_sm_flux_ingress_0__i_ss_async_pldif[56];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[57] = x_std_sm_flux_ingress_0__i_ss_async_pldif[57];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[58] = x_std_sm_flux_ingress_0__i_ss_async_pldif[58];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[59] = x_std_sm_flux_ingress_0__i_ss_async_pldif[59];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[5] = x_std_sm_flux_ingress_0__i_ss_async_pldif[5];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[60] = x_std_sm_flux_ingress_0__i_ss_async_pldif[60];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[61] = x_std_sm_flux_ingress_0__i_ss_async_pldif[61];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[62] = x_std_sm_flux_ingress_0__i_ss_async_pldif[62];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[63] = x_std_sm_flux_ingress_0__i_ss_async_pldif[63];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[64] = x_std_sm_flux_ingress_0__i_ss_async_pldif[64];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[65] = x_std_sm_flux_ingress_0__i_ss_async_pldif[65];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[66] = x_std_sm_flux_ingress_0__i_ss_async_pldif[66];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[67] = x_std_sm_flux_ingress_0__i_ss_async_pldif[67];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[68] = x_std_sm_flux_ingress_0__i_ss_async_pldif[68];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[69] = x_std_sm_flux_ingress_0__i_ss_async_pldif[69];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[6] = x_std_sm_flux_ingress_0__i_ss_async_pldif[6];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[70] = x_std_sm_flux_ingress_0__i_ss_async_pldif[70];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[71] = x_std_sm_flux_ingress_0__i_ss_async_pldif[71];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[72] = x_std_sm_flux_ingress_0__i_ss_async_pldif[72];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[73] = x_std_sm_flux_ingress_0__i_ss_async_pldif[73];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[74] = x_std_sm_flux_ingress_0__i_ss_async_pldif[74];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[75] = x_std_sm_flux_ingress_0__i_ss_async_pldif[75];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[76] = x_std_sm_flux_ingress_0__i_ss_async_pldif[76];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[77] = x_std_sm_flux_ingress_0__i_ss_async_pldif[77];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[78] = x_std_sm_flux_ingress_0__i_ss_async_pldif[78];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[79] = x_std_sm_flux_ingress_0__i_ss_async_pldif[79];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[7] = x_std_sm_flux_ingress_0__i_ss_async_pldif[7];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[8] = x_std_sm_flux_ingress_0__i_ss_async_pldif[8];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_0[9] = x_std_sm_flux_ingress_0__i_ss_async_pldif[9];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[0] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[0];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[10] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[10];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[11] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[11];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[12] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[12];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[13] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[13];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[14] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[14];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[15] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[15];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[16] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[16];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[17] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[17];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[18] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[18];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[19] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[19];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[1] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[1];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[20] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[20];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[21] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[21];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[22] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[22];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[23] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[23];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[24] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[24];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[25] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[25];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[26] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[26];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[27] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[27];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[28] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[28];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[29] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[29];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[2] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[2];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[30] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[30];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[31] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[31];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[32] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[32];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[33] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[33];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[34] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[34];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[35] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[35];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[36] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[36];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[37] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[37];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[38] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[38];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[39] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[39];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[3] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[3];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[40] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[40];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[41] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[41];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[42] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[42];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[43] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[43];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[44] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[44];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[45] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[45];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[46] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[46];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[47] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[47];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[48] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[48];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[49] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[49];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[4] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[4];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[50] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[50];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[51] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[51];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[52] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[52];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[53] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[53];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[54] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[54];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[55] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[55];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[56] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[56];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[57] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[57];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[58] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[58];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[59] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[59];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[5] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[5];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[60] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[60];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[61] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[61];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[62] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[62];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[63] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[63];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[64] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[64];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[65] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[65];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[66] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[66];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[67] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[67];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[68] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[68];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[69] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[69];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[6] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[6];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[70] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[70];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[71] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[71];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[72] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[72];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[73] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[73];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[74] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[74];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[75] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[75];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[76] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[76];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[77] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[77];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[78] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[78];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[79] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[79];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[7] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[7];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[8] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[8];
	assign x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[9] = x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux[9];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[0] = x_std_sm_flux_ingress_0__i_sync_cfg_data[0];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[100] = x_std_sm_flux_ingress_0__i_sync_cfg_data[100];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[101] = x_std_sm_flux_ingress_0__i_sync_cfg_data[101];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[102] = x_std_sm_flux_ingress_0__i_sync_cfg_data[102];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[103] = x_std_sm_flux_ingress_0__i_sync_cfg_data[103];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[104] = x_std_sm_flux_ingress_0__i_sync_cfg_data[104];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[105] = x_std_sm_flux_ingress_0__i_sync_cfg_data[105];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[106] = x_std_sm_flux_ingress_0__i_sync_cfg_data[106];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[107] = x_std_sm_flux_ingress_0__i_sync_cfg_data[107];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[108] = x_std_sm_flux_ingress_0__i_sync_cfg_data[108];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[109] = x_std_sm_flux_ingress_0__i_sync_cfg_data[109];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[10] = x_std_sm_flux_ingress_0__i_sync_cfg_data[10];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[110] = x_std_sm_flux_ingress_0__i_sync_cfg_data[110];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[111] = x_std_sm_flux_ingress_0__i_sync_cfg_data[111];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[112] = x_std_sm_flux_ingress_0__i_sync_cfg_data[112];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[113] = x_std_sm_flux_ingress_0__i_sync_cfg_data[113];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[114] = x_std_sm_flux_ingress_0__i_sync_cfg_data[114];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[115] = x_std_sm_flux_ingress_0__i_sync_cfg_data[115];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[116] = x_std_sm_flux_ingress_0__i_sync_cfg_data[116];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[117] = x_std_sm_flux_ingress_0__i_sync_cfg_data[117];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[118] = x_std_sm_flux_ingress_0__i_sync_cfg_data[118];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[119] = x_std_sm_flux_ingress_0__i_sync_cfg_data[119];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[11] = x_std_sm_flux_ingress_0__i_sync_cfg_data[11];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[120] = x_std_sm_flux_ingress_0__i_sync_cfg_data[120];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[121] = x_std_sm_flux_ingress_0__i_sync_cfg_data[121];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[122] = x_std_sm_flux_ingress_0__i_sync_cfg_data[122];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[123] = x_std_sm_flux_ingress_0__i_sync_cfg_data[123];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[124] = x_std_sm_flux_ingress_0__i_sync_cfg_data[124];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[12] = x_std_sm_flux_ingress_0__i_sync_cfg_data[12];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[13] = x_std_sm_flux_ingress_0__i_sync_cfg_data[13];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[14] = x_std_sm_flux_ingress_0__i_sync_cfg_data[14];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[15] = x_std_sm_flux_ingress_0__i_sync_cfg_data[15];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[16] = x_std_sm_flux_ingress_0__i_sync_cfg_data[16];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[17] = x_std_sm_flux_ingress_0__i_sync_cfg_data[17];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[18] = x_std_sm_flux_ingress_0__i_sync_cfg_data[18];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[19] = x_std_sm_flux_ingress_0__i_sync_cfg_data[19];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[1] = x_std_sm_flux_ingress_0__i_sync_cfg_data[1];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[20] = x_std_sm_flux_ingress_0__i_sync_cfg_data[20];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[21] = x_std_sm_flux_ingress_0__i_sync_cfg_data[21];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[22] = x_std_sm_flux_ingress_0__i_sync_cfg_data[22];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[23] = x_std_sm_flux_ingress_0__i_sync_cfg_data[23];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[24] = x_std_sm_flux_ingress_0__i_sync_cfg_data[24];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[25] = x_std_sm_flux_ingress_0__i_sync_cfg_data[25];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[26] = x_std_sm_flux_ingress_0__i_sync_cfg_data[26];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[27] = x_std_sm_flux_ingress_0__i_sync_cfg_data[27];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[28] = x_std_sm_flux_ingress_0__i_sync_cfg_data[28];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[29] = x_std_sm_flux_ingress_0__i_sync_cfg_data[29];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[2] = x_std_sm_flux_ingress_0__i_sync_cfg_data[2];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[30] = x_std_sm_flux_ingress_0__i_sync_cfg_data[30];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[31] = x_std_sm_flux_ingress_0__i_sync_cfg_data[31];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[32] = x_std_sm_flux_ingress_0__i_sync_cfg_data[32];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[33] = x_std_sm_flux_ingress_0__i_sync_cfg_data[33];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[34] = x_std_sm_flux_ingress_0__i_sync_cfg_data[34];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[35] = x_std_sm_flux_ingress_0__i_sync_cfg_data[35];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[36] = x_std_sm_flux_ingress_0__i_sync_cfg_data[36];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[37] = x_std_sm_flux_ingress_0__i_sync_cfg_data[37];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[38] = x_std_sm_flux_ingress_0__i_sync_cfg_data[38];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[39] = x_std_sm_flux_ingress_0__i_sync_cfg_data[39];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[3] = x_std_sm_flux_ingress_0__i_sync_cfg_data[3];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[40] = x_std_sm_flux_ingress_0__i_sync_cfg_data[40];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[41] = x_std_sm_flux_ingress_0__i_sync_cfg_data[41];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[42] = x_std_sm_flux_ingress_0__i_sync_cfg_data[42];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[43] = x_std_sm_flux_ingress_0__i_sync_cfg_data[43];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[44] = x_std_sm_flux_ingress_0__i_sync_cfg_data[44];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[45] = x_std_sm_flux_ingress_0__i_sync_cfg_data[45];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[46] = x_std_sm_flux_ingress_0__i_sync_cfg_data[46];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[47] = x_std_sm_flux_ingress_0__i_sync_cfg_data[47];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[48] = x_std_sm_flux_ingress_0__i_sync_cfg_data[48];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[49] = x_std_sm_flux_ingress_0__i_sync_cfg_data[49];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[4] = x_std_sm_flux_ingress_0__i_sync_cfg_data[4];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[50] = x_std_sm_flux_ingress_0__i_sync_cfg_data[50];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[51] = x_std_sm_flux_ingress_0__i_sync_cfg_data[51];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[52] = x_std_sm_flux_ingress_0__i_sync_cfg_data[52];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[53] = x_std_sm_flux_ingress_0__i_sync_cfg_data[53];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[54] = x_std_sm_flux_ingress_0__i_sync_cfg_data[54];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[55] = x_std_sm_flux_ingress_0__i_sync_cfg_data[55];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[56] = x_std_sm_flux_ingress_0__i_sync_cfg_data[56];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[57] = x_std_sm_flux_ingress_0__i_sync_cfg_data[57];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[58] = x_std_sm_flux_ingress_0__i_sync_cfg_data[58];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[59] = x_std_sm_flux_ingress_0__i_sync_cfg_data[59];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[5] = x_std_sm_flux_ingress_0__i_sync_cfg_data[5];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[60] = x_std_sm_flux_ingress_0__i_sync_cfg_data[60];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[61] = x_std_sm_flux_ingress_0__i_sync_cfg_data[61];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[62] = x_std_sm_flux_ingress_0__i_sync_cfg_data[62];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[63] = x_std_sm_flux_ingress_0__i_sync_cfg_data[63];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[64] = x_std_sm_flux_ingress_0__i_sync_cfg_data[64];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[65] = x_std_sm_flux_ingress_0__i_sync_cfg_data[65];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[66] = x_std_sm_flux_ingress_0__i_sync_cfg_data[66];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[67] = x_std_sm_flux_ingress_0__i_sync_cfg_data[67];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[68] = x_std_sm_flux_ingress_0__i_sync_cfg_data[68];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[69] = x_std_sm_flux_ingress_0__i_sync_cfg_data[69];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[6] = x_std_sm_flux_ingress_0__i_sync_cfg_data[6];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[70] = x_std_sm_flux_ingress_0__i_sync_cfg_data[70];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[71] = x_std_sm_flux_ingress_0__i_sync_cfg_data[71];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[72] = x_std_sm_flux_ingress_0__i_sync_cfg_data[72];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[73] = x_std_sm_flux_ingress_0__i_sync_cfg_data[73];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[74] = x_std_sm_flux_ingress_0__i_sync_cfg_data[74];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[75] = x_std_sm_flux_ingress_0__i_sync_cfg_data[75];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[76] = x_std_sm_flux_ingress_0__i_sync_cfg_data[76];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[77] = x_std_sm_flux_ingress_0__i_sync_cfg_data[77];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[78] = x_std_sm_flux_ingress_0__i_sync_cfg_data[78];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[79] = x_std_sm_flux_ingress_0__i_sync_cfg_data[79];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[7] = x_std_sm_flux_ingress_0__i_sync_cfg_data[7];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[80] = x_std_sm_flux_ingress_0__i_sync_cfg_data[80];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[81] = x_std_sm_flux_ingress_0__i_sync_cfg_data[81];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[82] = x_std_sm_flux_ingress_0__i_sync_cfg_data[82];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[83] = x_std_sm_flux_ingress_0__i_sync_cfg_data[83];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[84] = x_std_sm_flux_ingress_0__i_sync_cfg_data[84];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[85] = x_std_sm_flux_ingress_0__i_sync_cfg_data[85];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[86] = x_std_sm_flux_ingress_0__i_sync_cfg_data[86];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[87] = x_std_sm_flux_ingress_0__i_sync_cfg_data[87];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[88] = x_std_sm_flux_ingress_0__i_sync_cfg_data[88];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[89] = x_std_sm_flux_ingress_0__i_sync_cfg_data[89];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[8] = x_std_sm_flux_ingress_0__i_sync_cfg_data[8];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[90] = x_std_sm_flux_ingress_0__i_sync_cfg_data[90];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[91] = x_std_sm_flux_ingress_0__i_sync_cfg_data[91];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[92] = x_std_sm_flux_ingress_0__i_sync_cfg_data[92];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[93] = x_std_sm_flux_ingress_0__i_sync_cfg_data[93];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[94] = x_std_sm_flux_ingress_0__i_sync_cfg_data[94];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[95] = x_std_sm_flux_ingress_0__i_sync_cfg_data[95];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[96] = x_std_sm_flux_ingress_0__i_sync_cfg_data[96];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[97] = x_std_sm_flux_ingress_0__i_sync_cfg_data[97];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[98] = x_std_sm_flux_ingress_0__i_sync_cfg_data[98];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[99] = x_std_sm_flux_ingress_0__i_sync_cfg_data[99];
	assign x_std_sm_flux_ingress_0__i_sync_cfg_data_0[9] = x_std_sm_flux_ingress_0__i_sync_cfg_data[9];
	assign x_std_sm_flux_ingress_0__i_sync_common_control_0[0] = x_std_sm_flux_ingress_0__i_sync_common_control[0];
	assign x_std_sm_flux_ingress_0__i_sync_common_control_0[1] = x_std_sm_flux_ingress_0__i_sync_common_control[1];
	assign x_std_sm_flux_ingress_0__i_sync_common_control_0[2] = x_std_sm_flux_ingress_0__i_sync_common_control[2];
	assign x_std_sm_flux_ingress_0__i_sync_common_control_0[3] = x_std_sm_flux_ingress_0__i_sync_common_control[3];
	assign x_std_sm_flux_ingress_0__i_sync_common_control_0[4] = x_std_sm_flux_ingress_0__i_sync_common_control[4];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[0] = x_std_sm_flux_ingress_0__i_sync_interface_control[0];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[100] = x_std_sm_flux_ingress_0__i_sync_interface_control[100];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[101] = x_std_sm_flux_ingress_0__i_sync_interface_control[101];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[102] = x_std_sm_flux_ingress_0__i_sync_interface_control[102];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[103] = x_std_sm_flux_ingress_0__i_sync_interface_control[103];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[104] = x_std_sm_flux_ingress_0__i_sync_interface_control[104];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[105] = x_std_sm_flux_ingress_0__i_sync_interface_control[105];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[106] = x_std_sm_flux_ingress_0__i_sync_interface_control[106];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[107] = x_std_sm_flux_ingress_0__i_sync_interface_control[107];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[108] = x_std_sm_flux_ingress_0__i_sync_interface_control[108];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[109] = x_std_sm_flux_ingress_0__i_sync_interface_control[109];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[10] = x_std_sm_flux_ingress_0__i_sync_interface_control[10];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[110] = x_std_sm_flux_ingress_0__i_sync_interface_control[110];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[111] = x_std_sm_flux_ingress_0__i_sync_interface_control[111];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[112] = x_std_sm_flux_ingress_0__i_sync_interface_control[112];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[113] = x_std_sm_flux_ingress_0__i_sync_interface_control[113];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[114] = x_std_sm_flux_ingress_0__i_sync_interface_control[114];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[115] = x_std_sm_flux_ingress_0__i_sync_interface_control[115];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[116] = x_std_sm_flux_ingress_0__i_sync_interface_control[116];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[117] = x_std_sm_flux_ingress_0__i_sync_interface_control[117];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[118] = x_std_sm_flux_ingress_0__i_sync_interface_control[118];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[119] = x_std_sm_flux_ingress_0__i_sync_interface_control[119];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[11] = x_std_sm_flux_ingress_0__i_sync_interface_control[11];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[120] = x_std_sm_flux_ingress_0__i_sync_interface_control[120];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[121] = x_std_sm_flux_ingress_0__i_sync_interface_control[121];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[122] = x_std_sm_flux_ingress_0__i_sync_interface_control[122];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[123] = x_std_sm_flux_ingress_0__i_sync_interface_control[123];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[124] = x_std_sm_flux_ingress_0__i_sync_interface_control[124];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[125] = x_std_sm_flux_ingress_0__i_sync_interface_control[125];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[126] = x_std_sm_flux_ingress_0__i_sync_interface_control[126];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[127] = x_std_sm_flux_ingress_0__i_sync_interface_control[127];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[128] = x_std_sm_flux_ingress_0__i_sync_interface_control[128];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[129] = x_std_sm_flux_ingress_0__i_sync_interface_control[129];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[12] = x_std_sm_flux_ingress_0__i_sync_interface_control[12];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[130] = x_std_sm_flux_ingress_0__i_sync_interface_control[130];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[131] = x_std_sm_flux_ingress_0__i_sync_interface_control[131];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[132] = x_std_sm_flux_ingress_0__i_sync_interface_control[132];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[133] = x_std_sm_flux_ingress_0__i_sync_interface_control[133];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[134] = x_std_sm_flux_ingress_0__i_sync_interface_control[134];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[135] = x_std_sm_flux_ingress_0__i_sync_interface_control[135];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[136] = x_std_sm_flux_ingress_0__i_sync_interface_control[136];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[137] = x_std_sm_flux_ingress_0__i_sync_interface_control[137];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[138] = x_std_sm_flux_ingress_0__i_sync_interface_control[138];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[139] = x_std_sm_flux_ingress_0__i_sync_interface_control[139];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[13] = x_std_sm_flux_ingress_0__i_sync_interface_control[13];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[140] = x_std_sm_flux_ingress_0__i_sync_interface_control[140];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[141] = x_std_sm_flux_ingress_0__i_sync_interface_control[141];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[142] = x_std_sm_flux_ingress_0__i_sync_interface_control[142];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[143] = x_std_sm_flux_ingress_0__i_sync_interface_control[143];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[144] = x_std_sm_flux_ingress_0__i_sync_interface_control[144];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[145] = x_std_sm_flux_ingress_0__i_sync_interface_control[145];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[146] = x_std_sm_flux_ingress_0__i_sync_interface_control[146];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[147] = x_std_sm_flux_ingress_0__i_sync_interface_control[147];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[148] = x_std_sm_flux_ingress_0__i_sync_interface_control[148];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[149] = x_std_sm_flux_ingress_0__i_sync_interface_control[149];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[14] = x_std_sm_flux_ingress_0__i_sync_interface_control[14];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[150] = x_std_sm_flux_ingress_0__i_sync_interface_control[150];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[151] = x_std_sm_flux_ingress_0__i_sync_interface_control[151];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[152] = x_std_sm_flux_ingress_0__i_sync_interface_control[152];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[153] = x_std_sm_flux_ingress_0__i_sync_interface_control[153];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[154] = x_std_sm_flux_ingress_0__i_sync_interface_control[154];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[155] = x_std_sm_flux_ingress_0__i_sync_interface_control[155];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[156] = x_std_sm_flux_ingress_0__i_sync_interface_control[156];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[157] = x_std_sm_flux_ingress_0__i_sync_interface_control[157];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[158] = x_std_sm_flux_ingress_0__i_sync_interface_control[158];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[159] = x_std_sm_flux_ingress_0__i_sync_interface_control[159];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[15] = x_std_sm_flux_ingress_0__i_sync_interface_control[15];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[160] = x_std_sm_flux_ingress_0__i_sync_interface_control[160];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[161] = x_std_sm_flux_ingress_0__i_sync_interface_control[161];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[162] = x_std_sm_flux_ingress_0__i_sync_interface_control[162];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[163] = x_std_sm_flux_ingress_0__i_sync_interface_control[163];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[164] = x_std_sm_flux_ingress_0__i_sync_interface_control[164];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[165] = x_std_sm_flux_ingress_0__i_sync_interface_control[165];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[166] = x_std_sm_flux_ingress_0__i_sync_interface_control[166];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[167] = x_std_sm_flux_ingress_0__i_sync_interface_control[167];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[168] = x_std_sm_flux_ingress_0__i_sync_interface_control[168];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[169] = x_std_sm_flux_ingress_0__i_sync_interface_control[169];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[16] = x_std_sm_flux_ingress_0__i_sync_interface_control[16];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[170] = x_std_sm_flux_ingress_0__i_sync_interface_control[170];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[171] = x_std_sm_flux_ingress_0__i_sync_interface_control[171];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[172] = x_std_sm_flux_ingress_0__i_sync_interface_control[172];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[173] = x_std_sm_flux_ingress_0__i_sync_interface_control[173];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[174] = x_std_sm_flux_ingress_0__i_sync_interface_control[174];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[175] = x_std_sm_flux_ingress_0__i_sync_interface_control[175];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[176] = x_std_sm_flux_ingress_0__i_sync_interface_control[176];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[177] = x_std_sm_flux_ingress_0__i_sync_interface_control[177];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[178] = x_std_sm_flux_ingress_0__i_sync_interface_control[178];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[179] = x_std_sm_flux_ingress_0__i_sync_interface_control[179];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[17] = x_std_sm_flux_ingress_0__i_sync_interface_control[17];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[180] = x_std_sm_flux_ingress_0__i_sync_interface_control[180];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[181] = x_std_sm_flux_ingress_0__i_sync_interface_control[181];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[182] = x_std_sm_flux_ingress_0__i_sync_interface_control[182];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[183] = x_std_sm_flux_ingress_0__i_sync_interface_control[183];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[184] = x_std_sm_flux_ingress_0__i_sync_interface_control[184];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[185] = x_std_sm_flux_ingress_0__i_sync_interface_control[185];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[186] = x_std_sm_flux_ingress_0__i_sync_interface_control[186];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[187] = x_std_sm_flux_ingress_0__i_sync_interface_control[187];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[188] = x_std_sm_flux_ingress_0__i_sync_interface_control[188];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[189] = x_std_sm_flux_ingress_0__i_sync_interface_control[189];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[18] = x_std_sm_flux_ingress_0__i_sync_interface_control[18];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[190] = x_std_sm_flux_ingress_0__i_sync_interface_control[190];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[191] = x_std_sm_flux_ingress_0__i_sync_interface_control[191];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[192] = x_std_sm_flux_ingress_0__i_sync_interface_control[192];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[193] = x_std_sm_flux_ingress_0__i_sync_interface_control[193];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[194] = x_std_sm_flux_ingress_0__i_sync_interface_control[194];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[195] = x_std_sm_flux_ingress_0__i_sync_interface_control[195];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[196] = x_std_sm_flux_ingress_0__i_sync_interface_control[196];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[197] = x_std_sm_flux_ingress_0__i_sync_interface_control[197];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[198] = x_std_sm_flux_ingress_0__i_sync_interface_control[198];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[199] = x_std_sm_flux_ingress_0__i_sync_interface_control[199];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[19] = x_std_sm_flux_ingress_0__i_sync_interface_control[19];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[1] = x_std_sm_flux_ingress_0__i_sync_interface_control[1];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[200] = x_std_sm_flux_ingress_0__i_sync_interface_control[200];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[201] = x_std_sm_flux_ingress_0__i_sync_interface_control[201];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[202] = x_std_sm_flux_ingress_0__i_sync_interface_control[202];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[203] = x_std_sm_flux_ingress_0__i_sync_interface_control[203];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[204] = x_std_sm_flux_ingress_0__i_sync_interface_control[204];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[205] = x_std_sm_flux_ingress_0__i_sync_interface_control[205];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[206] = x_std_sm_flux_ingress_0__i_sync_interface_control[206];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[207] = x_std_sm_flux_ingress_0__i_sync_interface_control[207];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[208] = x_std_sm_flux_ingress_0__i_sync_interface_control[208];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[209] = x_std_sm_flux_ingress_0__i_sync_interface_control[209];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[20] = x_std_sm_flux_ingress_0__i_sync_interface_control[20];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[210] = x_std_sm_flux_ingress_0__i_sync_interface_control[210];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[211] = x_std_sm_flux_ingress_0__i_sync_interface_control[211];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[212] = x_std_sm_flux_ingress_0__i_sync_interface_control[212];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[213] = x_std_sm_flux_ingress_0__i_sync_interface_control[213];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[214] = x_std_sm_flux_ingress_0__i_sync_interface_control[214];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[215] = x_std_sm_flux_ingress_0__i_sync_interface_control[215];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[216] = x_std_sm_flux_ingress_0__i_sync_interface_control[216];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[217] = x_std_sm_flux_ingress_0__i_sync_interface_control[217];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[218] = x_std_sm_flux_ingress_0__i_sync_interface_control[218];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[219] = x_std_sm_flux_ingress_0__i_sync_interface_control[219];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[21] = x_std_sm_flux_ingress_0__i_sync_interface_control[21];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[220] = x_std_sm_flux_ingress_0__i_sync_interface_control[220];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[221] = x_std_sm_flux_ingress_0__i_sync_interface_control[221];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[222] = x_std_sm_flux_ingress_0__i_sync_interface_control[222];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[223] = x_std_sm_flux_ingress_0__i_sync_interface_control[223];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[224] = x_std_sm_flux_ingress_0__i_sync_interface_control[224];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[225] = x_std_sm_flux_ingress_0__i_sync_interface_control[225];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[226] = x_std_sm_flux_ingress_0__i_sync_interface_control[226];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[227] = x_std_sm_flux_ingress_0__i_sync_interface_control[227];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[228] = x_std_sm_flux_ingress_0__i_sync_interface_control[228];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[229] = x_std_sm_flux_ingress_0__i_sync_interface_control[229];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[22] = x_std_sm_flux_ingress_0__i_sync_interface_control[22];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[230] = x_std_sm_flux_ingress_0__i_sync_interface_control[230];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[231] = x_std_sm_flux_ingress_0__i_sync_interface_control[231];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[232] = x_std_sm_flux_ingress_0__i_sync_interface_control[232];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[233] = x_std_sm_flux_ingress_0__i_sync_interface_control[233];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[234] = x_std_sm_flux_ingress_0__i_sync_interface_control[234];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[235] = x_std_sm_flux_ingress_0__i_sync_interface_control[235];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[236] = x_std_sm_flux_ingress_0__i_sync_interface_control[236];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[237] = x_std_sm_flux_ingress_0__i_sync_interface_control[237];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[238] = x_std_sm_flux_ingress_0__i_sync_interface_control[238];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[239] = x_std_sm_flux_ingress_0__i_sync_interface_control[239];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[23] = x_std_sm_flux_ingress_0__i_sync_interface_control[23];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[240] = x_std_sm_flux_ingress_0__i_sync_interface_control[240];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[241] = x_std_sm_flux_ingress_0__i_sync_interface_control[241];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[242] = x_std_sm_flux_ingress_0__i_sync_interface_control[242];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[243] = x_std_sm_flux_ingress_0__i_sync_interface_control[243];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[244] = x_std_sm_flux_ingress_0__i_sync_interface_control[244];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[245] = x_std_sm_flux_ingress_0__i_sync_interface_control[245];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[246] = x_std_sm_flux_ingress_0__i_sync_interface_control[246];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[247] = x_std_sm_flux_ingress_0__i_sync_interface_control[247];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[248] = x_std_sm_flux_ingress_0__i_sync_interface_control[248];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[249] = x_std_sm_flux_ingress_0__i_sync_interface_control[249];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[24] = x_std_sm_flux_ingress_0__i_sync_interface_control[24];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[25] = x_std_sm_flux_ingress_0__i_sync_interface_control[25];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[26] = x_std_sm_flux_ingress_0__i_sync_interface_control[26];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[27] = x_std_sm_flux_ingress_0__i_sync_interface_control[27];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[28] = x_std_sm_flux_ingress_0__i_sync_interface_control[28];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[29] = x_std_sm_flux_ingress_0__i_sync_interface_control[29];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[2] = x_std_sm_flux_ingress_0__i_sync_interface_control[2];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[30] = x_std_sm_flux_ingress_0__i_sync_interface_control[30];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[31] = x_std_sm_flux_ingress_0__i_sync_interface_control[31];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[32] = x_std_sm_flux_ingress_0__i_sync_interface_control[32];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[33] = x_std_sm_flux_ingress_0__i_sync_interface_control[33];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[34] = x_std_sm_flux_ingress_0__i_sync_interface_control[34];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[35] = x_std_sm_flux_ingress_0__i_sync_interface_control[35];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[36] = x_std_sm_flux_ingress_0__i_sync_interface_control[36];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[37] = x_std_sm_flux_ingress_0__i_sync_interface_control[37];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[38] = x_std_sm_flux_ingress_0__i_sync_interface_control[38];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[39] = x_std_sm_flux_ingress_0__i_sync_interface_control[39];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[3] = x_std_sm_flux_ingress_0__i_sync_interface_control[3];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[40] = x_std_sm_flux_ingress_0__i_sync_interface_control[40];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[41] = x_std_sm_flux_ingress_0__i_sync_interface_control[41];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[42] = x_std_sm_flux_ingress_0__i_sync_interface_control[42];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[43] = x_std_sm_flux_ingress_0__i_sync_interface_control[43];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[44] = x_std_sm_flux_ingress_0__i_sync_interface_control[44];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[45] = x_std_sm_flux_ingress_0__i_sync_interface_control[45];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[46] = x_std_sm_flux_ingress_0__i_sync_interface_control[46];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[47] = x_std_sm_flux_ingress_0__i_sync_interface_control[47];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[48] = x_std_sm_flux_ingress_0__i_sync_interface_control[48];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[49] = x_std_sm_flux_ingress_0__i_sync_interface_control[49];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[4] = x_std_sm_flux_ingress_0__i_sync_interface_control[4];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[50] = x_std_sm_flux_ingress_0__i_sync_interface_control[50];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[51] = x_std_sm_flux_ingress_0__i_sync_interface_control[51];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[52] = x_std_sm_flux_ingress_0__i_sync_interface_control[52];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[53] = x_std_sm_flux_ingress_0__i_sync_interface_control[53];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[54] = x_std_sm_flux_ingress_0__i_sync_interface_control[54];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[55] = x_std_sm_flux_ingress_0__i_sync_interface_control[55];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[56] = x_std_sm_flux_ingress_0__i_sync_interface_control[56];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[57] = x_std_sm_flux_ingress_0__i_sync_interface_control[57];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[58] = x_std_sm_flux_ingress_0__i_sync_interface_control[58];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[59] = x_std_sm_flux_ingress_0__i_sync_interface_control[59];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[5] = x_std_sm_flux_ingress_0__i_sync_interface_control[5];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[60] = x_std_sm_flux_ingress_0__i_sync_interface_control[60];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[61] = x_std_sm_flux_ingress_0__i_sync_interface_control[61];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[62] = x_std_sm_flux_ingress_0__i_sync_interface_control[62];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[63] = x_std_sm_flux_ingress_0__i_sync_interface_control[63];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[64] = x_std_sm_flux_ingress_0__i_sync_interface_control[64];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[65] = x_std_sm_flux_ingress_0__i_sync_interface_control[65];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[66] = x_std_sm_flux_ingress_0__i_sync_interface_control[66];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[67] = x_std_sm_flux_ingress_0__i_sync_interface_control[67];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[68] = x_std_sm_flux_ingress_0__i_sync_interface_control[68];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[69] = x_std_sm_flux_ingress_0__i_sync_interface_control[69];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[6] = x_std_sm_flux_ingress_0__i_sync_interface_control[6];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[70] = x_std_sm_flux_ingress_0__i_sync_interface_control[70];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[71] = x_std_sm_flux_ingress_0__i_sync_interface_control[71];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[72] = x_std_sm_flux_ingress_0__i_sync_interface_control[72];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[73] = x_std_sm_flux_ingress_0__i_sync_interface_control[73];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[74] = x_std_sm_flux_ingress_0__i_sync_interface_control[74];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[75] = x_std_sm_flux_ingress_0__i_sync_interface_control[75];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[76] = x_std_sm_flux_ingress_0__i_sync_interface_control[76];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[77] = x_std_sm_flux_ingress_0__i_sync_interface_control[77];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[78] = x_std_sm_flux_ingress_0__i_sync_interface_control[78];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[79] = x_std_sm_flux_ingress_0__i_sync_interface_control[79];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[7] = x_std_sm_flux_ingress_0__i_sync_interface_control[7];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[80] = x_std_sm_flux_ingress_0__i_sync_interface_control[80];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[81] = x_std_sm_flux_ingress_0__i_sync_interface_control[81];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[82] = x_std_sm_flux_ingress_0__i_sync_interface_control[82];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[83] = x_std_sm_flux_ingress_0__i_sync_interface_control[83];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[84] = x_std_sm_flux_ingress_0__i_sync_interface_control[84];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[85] = x_std_sm_flux_ingress_0__i_sync_interface_control[85];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[86] = x_std_sm_flux_ingress_0__i_sync_interface_control[86];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[87] = x_std_sm_flux_ingress_0__i_sync_interface_control[87];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[88] = x_std_sm_flux_ingress_0__i_sync_interface_control[88];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[89] = x_std_sm_flux_ingress_0__i_sync_interface_control[89];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[8] = x_std_sm_flux_ingress_0__i_sync_interface_control[8];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[90] = x_std_sm_flux_ingress_0__i_sync_interface_control[90];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[91] = x_std_sm_flux_ingress_0__i_sync_interface_control[91];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[92] = x_std_sm_flux_ingress_0__i_sync_interface_control[92];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[93] = x_std_sm_flux_ingress_0__i_sync_interface_control[93];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[94] = x_std_sm_flux_ingress_0__i_sync_interface_control[94];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[95] = x_std_sm_flux_ingress_0__i_sync_interface_control[95];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[96] = x_std_sm_flux_ingress_0__i_sync_interface_control[96];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[97] = x_std_sm_flux_ingress_0__i_sync_interface_control[97];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[98] = x_std_sm_flux_ingress_0__i_sync_interface_control[98];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[99] = x_std_sm_flux_ingress_0__i_sync_interface_control[99];
	assign x_std_sm_flux_ingress_0__i_sync_interface_control_0[9] = x_std_sm_flux_ingress_0__i_sync_interface_control[9];
	assign x_std_sm_flux_ingress_0__i_tstbus_lane_1 = x_std_sm_flux_ingress_0__i_tstbus_lane;
	assign x_std_sm_flux_ingress_0__i_txbeacona_1 = x_std_sm_flux_ingress_0__i_txbeacona;
	assign x_std_sm_flux_ingress_0__i_txclkdivrate_0[0] = x_std_sm_flux_ingress_0__i_txclkdivrate[0];
	assign x_std_sm_flux_ingress_0__i_txclkdivrate_0[1] = x_std_sm_flux_ingress_0__i_txclkdivrate[1];
	assign x_std_sm_flux_ingress_0__i_txclkdivrate_0[2] = x_std_sm_flux_ingress_0__i_txclkdivrate[2];
	assign x_std_sm_flux_ingress_0__i_txdetectrx_reqa_1 = x_std_sm_flux_ingress_0__i_txdetectrx_reqa;
	assign x_std_sm_flux_ingress_0__i_txdrv_levn_0[0] = x_std_sm_flux_ingress_0__i_txdrv_levn[0];
	assign x_std_sm_flux_ingress_0__i_txdrv_levn_0[1] = x_std_sm_flux_ingress_0__i_txdrv_levn[1];
	assign x_std_sm_flux_ingress_0__i_txdrv_levn_0[2] = x_std_sm_flux_ingress_0__i_txdrv_levn[2];
	assign x_std_sm_flux_ingress_0__i_txdrv_levn_0[3] = x_std_sm_flux_ingress_0__i_txdrv_levn[3];
	assign x_std_sm_flux_ingress_0__i_txdrv_levn_0[4] = x_std_sm_flux_ingress_0__i_txdrv_levn[4];
	assign x_std_sm_flux_ingress_0__i_txdrv_levn_0[5] = x_std_sm_flux_ingress_0__i_txdrv_levn[5];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[0] = x_std_sm_flux_ingress_0__i_txdrv_levnm1[0];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[1] = x_std_sm_flux_ingress_0__i_txdrv_levnm1[1];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[2] = x_std_sm_flux_ingress_0__i_txdrv_levnm1[2];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[3] = x_std_sm_flux_ingress_0__i_txdrv_levnm1[3];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[4] = x_std_sm_flux_ingress_0__i_txdrv_levnm1[4];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnm2_0[0] = x_std_sm_flux_ingress_0__i_txdrv_levnm2[0];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnm2_0[1] = x_std_sm_flux_ingress_0__i_txdrv_levnm2[1];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnm2_0[2] = x_std_sm_flux_ingress_0__i_txdrv_levnm2[2];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[0] = x_std_sm_flux_ingress_0__i_txdrv_levnp1[0];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[1] = x_std_sm_flux_ingress_0__i_txdrv_levnp1[1];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[2] = x_std_sm_flux_ingress_0__i_txdrv_levnp1[2];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[3] = x_std_sm_flux_ingress_0__i_txdrv_levnp1[3];
	assign x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[4] = x_std_sm_flux_ingress_0__i_txdrv_levnp1[4];
	assign x_std_sm_flux_ingress_0__i_txdrv_slew_0[0] = x_std_sm_flux_ingress_0__i_txdrv_slew[0];
	assign x_std_sm_flux_ingress_0__i_txdrv_slew_0[1] = x_std_sm_flux_ingress_0__i_txdrv_slew[1];
	assign x_std_sm_flux_ingress_0__i_txdrv_slew_0[2] = x_std_sm_flux_ingress_0__i_txdrv_slew[2];
	assign x_std_sm_flux_ingress_0__i_txdrv_slew_0[3] = x_std_sm_flux_ingress_0__i_txdrv_slew[3];
	assign x_std_sm_flux_ingress_0__i_txelecidle_0[0] = x_std_sm_flux_ingress_0__i_txelecidle[0];
	assign x_std_sm_flux_ingress_0__i_txelecidle_0[1] = x_std_sm_flux_ingress_0__i_txelecidle[1];
	assign x_std_sm_flux_ingress_0__i_txelecidle_0[2] = x_std_sm_flux_ingress_0__i_txelecidle[2];
	assign x_std_sm_flux_ingress_0__i_txelecidle_0[3] = x_std_sm_flux_ingress_0__i_txelecidle[3];
	assign x_std_sm_flux_ingress_0__i_txpstate_0[0] = x_std_sm_flux_ingress_0__i_txpstate[0];
	assign x_std_sm_flux_ingress_0__i_txpstate_0[1] = x_std_sm_flux_ingress_0__i_txpstate[1];
	assign x_std_sm_flux_ingress_0__i_txpstate_0[2] = x_std_sm_flux_ingress_0__i_txpstate[2];
	assign x_std_sm_flux_ingress_0__i_txrate_0[0] = x_std_sm_flux_ingress_0__i_txrate[0];
	assign x_std_sm_flux_ingress_0__i_txrate_0[1] = x_std_sm_flux_ingress_0__i_txrate[1];
	assign x_std_sm_flux_ingress_0__i_txrate_0[2] = x_std_sm_flux_ingress_0__i_txrate[2];
	assign x_std_sm_flux_ingress_0__i_txrate_0[3] = x_std_sm_flux_ingress_0__i_txrate[3];
	assign x_std_sm_flux_ingress_0__i_txwidth_0[0] = x_std_sm_flux_ingress_0__i_txwidth[0];
	assign x_std_sm_flux_ingress_0__i_txwidth_0[1] = x_std_sm_flux_ingress_0__i_txwidth[1];
	assign x_std_sm_flux_ingress_0__i_txwidth_0[2] = x_std_sm_flux_ingress_0__i_txwidth[2];
	assign x_std_sm_flux_ingress_0__i_ux_rxuser1_sel_0[0] = x_std_sm_flux_ingress_0__i_ux_rxuser1_sel[0];
	assign x_std_sm_flux_ingress_0__i_ux_rxuser1_sel_0[1] = x_std_sm_flux_ingress_0__i_ux_rxuser1_sel[1];
	assign x_std_sm_flux_ingress_0__i_ux_rxuser2_sel_0[0] = x_std_sm_flux_ingress_0__i_ux_rxuser2_sel[0];
	assign x_std_sm_flux_ingress_0__i_ux_rxuser2_sel_0[1] = x_std_sm_flux_ingress_0__i_ux_rxuser2_sel[1];
	assign x_std_sm_flux_ingress_0__i_ux_txuser1_sel_0[0] = x_std_sm_flux_ingress_0__i_ux_txuser1_sel[0];
	assign x_std_sm_flux_ingress_0__i_ux_txuser1_sel_0[1] = x_std_sm_flux_ingress_0__i_ux_txuser1_sel[1];
	assign x_std_sm_flux_ingress_0__i_ux_txuser2_sel_0[0] = x_std_sm_flux_ingress_0__i_ux_txuser2_sel[0];
	assign x_std_sm_flux_ingress_0__i_ux_txuser2_sel_0[1] = x_std_sm_flux_ingress_0__i_ux_txuser2_sel[1];
	assign x_std_sm_flux_ingress_0__o_dat_pcs_measlatrndtripbit = x_std_sm_flux_ingress_0__o_dat_pcs_measlatrndtripbit_1;
	assign x_std_sm_flux_ingress_0__o_ft_rx_async_pulse_ch = x_std_sm_flux_ingress_0__o_ft_rx_async_pulse_ch_1;
	assign x_std_sm_flux_ingress_0__o_ft_rx_sclk_sync_ch = x_std_sm_flux_ingress_0__o_ft_rx_sclk_sync_ch_1;
	assign x_std_sm_flux_ingress_0__o_ft_tx_async_pulse_ch = x_std_sm_flux_ingress_0__o_ft_tx_async_pulse_ch_1;
	assign x_std_sm_flux_ingress_0__o_ft_tx_sclk_sync_ch = x_std_sm_flux_ingress_0__o_ft_tx_sclk_sync_ch_1;
	assign x_std_sm_flux_ingress_0__o_ick_pcs_txword = x_std_sm_flux_ingress_0__o_ick_pcs_txword_1;
	assign x_std_sm_flux_ingress_0__o_ick_sclk_rx = x_std_sm_flux_ingress_0__o_ick_sclk_rx_1;
	assign x_std_sm_flux_ingress_0__o_ick_sclk_tx = x_std_sm_flux_ingress_0__o_ick_sclk_tx_1;
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[0] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[0];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[10] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[10];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[11] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[11];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[12] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[12];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[13] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[13];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[14] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[14];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[15] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[15];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[16] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[16];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[17] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[17];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[18] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[18];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[19] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[19];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[1] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[1];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[2] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[2];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[3] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[3];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[4] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[4];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[5] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[5];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[6] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[6];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[7] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[7];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[8] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[8];
	assign x_std_sm_flux_ingress_0__o_lavmm_addr[9] = x_std_sm_flux_ingress_0__o_lavmm_addr_0[9];
	assign x_std_sm_flux_ingress_0__o_lavmm_be[0] = x_std_sm_flux_ingress_0__o_lavmm_be_0[0];
	assign x_std_sm_flux_ingress_0__o_lavmm_be[1] = x_std_sm_flux_ingress_0__o_lavmm_be_0[1];
	assign x_std_sm_flux_ingress_0__o_lavmm_be[2] = x_std_sm_flux_ingress_0__o_lavmm_be_0[2];
	assign x_std_sm_flux_ingress_0__o_lavmm_be[3] = x_std_sm_flux_ingress_0__o_lavmm_be_0[3];
	assign x_std_sm_flux_ingress_0__o_lavmm_clk = x_std_sm_flux_ingress_0__o_lavmm_clk_1;
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[0] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[0];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[10] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[10];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[11] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[11];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[12] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[12];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[13] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[13];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[14] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[14];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[15] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[15];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[16] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[16];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[17] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[17];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[18] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[18];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[19] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[19];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[1] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[1];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[20] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[20];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[21] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[21];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[22] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[22];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[23] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[23];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[24] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[24];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[25] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[25];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[26] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[26];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[27] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[27];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[28] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[28];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[29] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[29];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[2] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[2];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[30] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[30];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[31] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[31];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[3] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[3];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[4] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[4];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[5] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[5];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[6] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[6];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[7] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[7];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[8] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[8];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata[9] = x_std_sm_flux_ingress_0__o_lavmm_rdata_0[9];
	assign x_std_sm_flux_ingress_0__o_lavmm_rdata_valid = x_std_sm_flux_ingress_0__o_lavmm_rdata_valid_1;
	assign x_std_sm_flux_ingress_0__o_lavmm_read = x_std_sm_flux_ingress_0__o_lavmm_read_1;
	assign x_std_sm_flux_ingress_0__o_lavmm_rstn = x_std_sm_flux_ingress_0__o_lavmm_rstn_1;
	assign x_std_sm_flux_ingress_0__o_lavmm_waitreq = x_std_sm_flux_ingress_0__o_lavmm_waitreq_1;
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[0] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[0];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[10] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[10];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[11] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[11];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[12] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[12];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[13] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[13];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[14] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[14];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[15] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[15];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[16] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[16];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[17] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[17];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[18] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[18];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[19] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[19];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[1] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[1];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[20] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[20];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[21] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[21];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[22] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[22];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[23] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[23];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[24] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[24];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[25] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[25];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[26] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[26];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[27] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[27];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[28] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[28];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[29] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[29];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[2] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[2];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[30] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[30];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[31] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[31];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[3] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[3];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[4] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[4];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[5] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[5];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[6] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[6];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[7] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[7];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[8] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[8];
	assign x_std_sm_flux_ingress_0__o_lavmm_wdata[9] = x_std_sm_flux_ingress_0__o_lavmm_wdata_0[9];
	assign x_std_sm_flux_ingress_0__o_lavmm_write = x_std_sm_flux_ingress_0__o_lavmm_write_1;
	assign x_std_sm_flux_ingress_0__o_ock_pcs_cdrfbclk = x_std_sm_flux_ingress_0__o_ock_pcs_cdrfbclk_1;
	assign x_std_sm_flux_ingress_0__o_ock_pcs_ref = x_std_sm_flux_ingress_0__o_ock_pcs_ref_1;
	assign x_std_sm_flux_ingress_0__o_ock_pcs_txword = flux_ingress_u3__o_ock_pcs_txword_0;
	assign x_std_sm_flux_ingress_0__o_octl_pcs_txstatus_a = x_std_sm_flux_ingress_0__o_octl_pcs_txstatus_a_1;
	assign x_std_sm_flux_ingress_0__o_pcs_rxpostdiv = x_std_sm_flux_ingress_0__o_pcs_rxpostdiv_1;
	assign x_std_sm_flux_ingress_0__o_pcs_rxword = flux_ingress_u3__o_pcs_rxword_0;
	assign x_std_sm_flux_ingress_0__o_rst_flux0_cpi_cmn_busy = x_std_sm_flux_ingress_0__o_rst_flux0_cpi_cmn_busy_1;
	assign x_std_sm_flux_ingress_0__o_rst_oflux_rx_srds_rdy = x_std_sm_flux_ingress_0__o_rst_oflux_rx_srds_rdy_1;
	assign x_std_sm_flux_ingress_0__o_rst_ux_all_synthlockstatus = x_std_sm_flux_ingress_0__o_rst_ux_all_synthlockstatus_1;
	assign x_std_sm_flux_ingress_0__o_rst_ux_rx_pma_rst_n = x_std_sm_flux_ingress_0__o_rst_ux_rx_pma_rst_n_1;
	assign x_std_sm_flux_ingress_0__o_rst_ux_rxcdrlockstatus = x_std_sm_flux_ingress_0__o_rst_ux_rxcdrlockstatus_1;
	assign x_std_sm_flux_ingress_0__o_rst_ux_tx_pma_rst_n = x_std_sm_flux_ingress_0__o_rst_ux_tx_pma_rst_n_1;
	assign x_std_sm_flux_ingress_0__o_rxcdrlock2dataa = x_std_sm_flux_ingress_0__o_rxcdrlock2dataa_1;
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[0] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[0];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[10] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[10];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[11] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[11];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[12] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[12];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[13] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[13];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[1] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[1];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[2] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[2];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[3] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[3];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[4] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[4];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[5] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[5];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[6] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[6];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[7] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[7];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[8] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[8];
	assign x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala[9] = x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[9];
	assign x_std_sm_flux_ingress_0__o_rxeq_donea = x_std_sm_flux_ingress_0__o_rxeq_donea_1;
	assign x_std_sm_flux_ingress_0__o_rxmargin_nacka = x_std_sm_flux_ingress_0__o_rxmargin_nacka_1;
	assign x_std_sm_flux_ingress_0__o_rxmargin_status_gray[0] = x_std_sm_flux_ingress_0__o_rxmargin_status_gray_0[0];
	assign x_std_sm_flux_ingress_0__o_rxmargin_status_gray[1] = x_std_sm_flux_ingress_0__o_rxmargin_status_gray_0[1];
	assign x_std_sm_flux_ingress_0__o_rxmargin_statusa = x_std_sm_flux_ingress_0__o_rxmargin_statusa_1;
	assign x_std_sm_flux_ingress_0__o_rxsignaldetect_lfpsa = x_std_sm_flux_ingress_0__o_rxsignaldetect_lfpsa_1;
	assign x_std_sm_flux_ingress_0__o_rxsignaldetecta = x_std_sm_flux_ingress_0__o_rxsignaldetecta_1;
	assign x_std_sm_flux_ingress_0__o_rxstatusa = x_std_sm_flux_ingress_0__o_rxstatusa_1;
	assign x_std_sm_flux_ingress_0__o_sclk_return_sel_rx = x_std_sm_flux_ingress_0__o_sclk_return_sel_rx_1;
	assign x_std_sm_flux_ingress_0__o_sclk_return_sel_tx = x_std_sm_flux_ingress_0__o_sclk_return_sel_tx_1;
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[0] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[0];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[100] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[100];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[101] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[101];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[102] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[102];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[103] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[103];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[104] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[104];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[105] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[105];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[106] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[106];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[107] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[107];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[108] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[108];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[109] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[109];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[10] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[10];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[110] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[110];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[111] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[111];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[112] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[112];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[113] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[113];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[114] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[114];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[115] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[115];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[116] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[116];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[117] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[117];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[118] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[118];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[119] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[119];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[11] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[11];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[120] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[120];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[121] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[121];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[122] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[122];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[123] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[123];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[124] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[124];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[125] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[125];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[126] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[126];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[127] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[127];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[128] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[128];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[129] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[129];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[12] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[12];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[130] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[130];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[131] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[131];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[132] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[132];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[133] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[133];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[134] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[134];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[135] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[135];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[136] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[136];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[137] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[137];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[138] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[138];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[139] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[139];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[13] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[13];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[140] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[140];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[141] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[141];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[142] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[142];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[143] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[143];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[144] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[144];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[145] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[145];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[146] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[146];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[147] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[147];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[148] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[148];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[149] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[149];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[14] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[14];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[150] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[150];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[151] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[151];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[152] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[152];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[153] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[153];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[154] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[154];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[155] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[155];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[156] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[156];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[157] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[157];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[158] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[158];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[159] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[159];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[15] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[15];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[160] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[160];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[161] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[161];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[162] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[162];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[163] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[163];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[164] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[164];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[165] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[165];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[166] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[166];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[167] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[167];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[168] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[168];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[169] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[169];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[16] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[16];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[170] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[170];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[171] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[171];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[172] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[172];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[173] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[173];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[174] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[174];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[175] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[175];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[176] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[176];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[177] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[177];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[178] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[178];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[179] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[179];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[17] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[17];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[180] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[180];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[181] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[181];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[182] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[182];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[183] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[183];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[184] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[184];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[185] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[185];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[186] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[186];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[187] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[187];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[188] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[188];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[189] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[189];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[18] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[18];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[190] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[190];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[191] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[191];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[192] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[192];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[193] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[193];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[194] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[194];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[195] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[195];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[196] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[196];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[197] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[197];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[198] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[198];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[199] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[199];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[19] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[19];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[1] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[1];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[200] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[200];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[201] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[201];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[202] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[202];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[203] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[203];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[204] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[204];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[205] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[205];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[206] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[206];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[207] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[207];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[208] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[208];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[209] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[209];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[20] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[20];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[210] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[210];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[211] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[211];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[212] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[212];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[213] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[213];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[214] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[214];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[215] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[215];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[216] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[216];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[217] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[217];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[218] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[218];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[219] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[219];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[21] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[21];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[220] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[220];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[221] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[221];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[222] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[222];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[223] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[223];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[224] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[224];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[225] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[225];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[226] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[226];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[227] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[227];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[228] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[228];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[229] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[229];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[22] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[22];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[230] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[230];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[231] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[231];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[232] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[232];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[233] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[233];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[234] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[234];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[235] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[235];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[236] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[236];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[237] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[237];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[238] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[238];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[239] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[239];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[23] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[23];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[240] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[240];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[241] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[241];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[242] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[242];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[243] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[243];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[244] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[244];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[245] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[245];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[246] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[246];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[247] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[247];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[248] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[248];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[249] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[249];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[24] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[24];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[250] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[250];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[251] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[251];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[252] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[252];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[253] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[253];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[254] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[254];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[255] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[255];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[256] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[256];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[257] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[257];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[258] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[258];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[259] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[259];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[25] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[25];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[260] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[260];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[261] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[261];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[262] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[262];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[263] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[263];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[264] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[264];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[265] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[265];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[266] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[266];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[267] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[267];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[268] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[268];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[269] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[269];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[26] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[26];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[270] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[270];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[271] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[271];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[272] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[272];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[273] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[273];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[274] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[274];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[275] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[275];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[276] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[276];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[277] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[277];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[278] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[278];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[279] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[279];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[27] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[27];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[280] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[280];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[281] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[281];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[282] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[282];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[283] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[283];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[284] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[284];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[285] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[285];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[286] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[286];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[287] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[287];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[288] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[288];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[289] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[289];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[28] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[28];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[290] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[290];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[291] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[291];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[292] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[292];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[293] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[293];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[294] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[294];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[295] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[295];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[296] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[296];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[297] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[297];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[298] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[298];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[299] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[299];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[29] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[29];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[2] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[2];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[300] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[300];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[301] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[301];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[302] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[302];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[303] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[303];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[304] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[304];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[305] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[305];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[306] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[306];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[307] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[307];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[308] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[308];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[309] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[309];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[30] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[30];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[310] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[310];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[311] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[311];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[312] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[312];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[313] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[313];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[314] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[314];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[315] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[315];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[316] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[316];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[317] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[317];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[318] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[318];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[319] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[319];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[31] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[31];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[32] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[32];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[33] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[33];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[34] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[34];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[35] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[35];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[36] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[36];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[37] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[37];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[38] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[38];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[39] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[39];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[3] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[3];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[40] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[40];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[41] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[41];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[42] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[42];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[43] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[43];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[44] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[44];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[45] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[45];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[46] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[46];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[47] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[47];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[48] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[48];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[49] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[49];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[4] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[4];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[50] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[50];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[51] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[51];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[52] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[52];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[53] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[53];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[54] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[54];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[55] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[55];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[56] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[56];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[57] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[57];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[58] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[58];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[59] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[59];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[5] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[5];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[60] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[60];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[61] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[61];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[62] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[62];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[63] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[63];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[64] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[64];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[65] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[65];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[66] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[66];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[67] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[67];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[68] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[68];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[69] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[69];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[6] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[6];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[70] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[70];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[71] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[71];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[72] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[72];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[73] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[73];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[74] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[74];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[75] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[75];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[76] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[76];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[77] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[77];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[78] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[78];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[79] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[79];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[7] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[7];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[80] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[80];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[81] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[81];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[82] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[82];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[83] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[83];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[84] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[84];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[85] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[85];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[86] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[86];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[87] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[87];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[88] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[88];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[89] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[89];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[8] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[8];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[90] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[90];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[91] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[91];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[92] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[92];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[93] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[93];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[94] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[94];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[95] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[95];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[96] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[96];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[97] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[97];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[98] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[98];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[99] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[99];
	assign x_std_sm_flux_ingress_0__o_sm_flux_ingress[9] = x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[9];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[0] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[0];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[10] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[10];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[11] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[11];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[12] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[12];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[13] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[13];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[14] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[14];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[15] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[15];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[16] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[16];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[17] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[17];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[18] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[18];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[19] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[19];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[1] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[1];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[20] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[20];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[21] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[21];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[22] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[22];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[23] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[23];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[24] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[24];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[25] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[25];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[26] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[26];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[27] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[27];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[28] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[28];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[29] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[29];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[2] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[2];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[30] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[30];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[31] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[31];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[32] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[32];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[33] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[33];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[34] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[34];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[35] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[35];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[36] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[36];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[37] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[37];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[38] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[38];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[39] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[39];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[3] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[3];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[40] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[40];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[41] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[41];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[42] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[42];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[43] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[43];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[44] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[44];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[45] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[45];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[46] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[46];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[47] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[47];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[48] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[48];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[49] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[49];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[4] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[4];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[5] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[5];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[6] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[6];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[7] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[7];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[8] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[8];
	assign x_std_sm_flux_ingress_0__o_ss_async_pldif[9] = x_std_sm_flux_ingress_0__o_ss_async_pldif_0[9];
	assign x_std_sm_flux_ingress_0__o_synthlcfast_postdiv = x_std_sm_flux_ingress_0__o_synthlcfast_postdiv_1;
	assign x_std_sm_flux_ingress_0__o_synthlcmed_postdiv = x_std_sm_flux_ingress_0__o_synthlcmed_postdiv_1;
	assign x_std_sm_flux_ingress_0__o_synthlcslow_postdiv = x_std_sm_flux_ingress_0__o_synthlcslow_postdiv_1;
	assign x_std_sm_flux_ingress_0__o_tx_data[0] = x_std_sm_flux_ingress_0__o_tx_data_0[0];
	assign x_std_sm_flux_ingress_0__o_tx_data[10] = x_std_sm_flux_ingress_0__o_tx_data_0[10];
	assign x_std_sm_flux_ingress_0__o_tx_data[11] = x_std_sm_flux_ingress_0__o_tx_data_0[11];
	assign x_std_sm_flux_ingress_0__o_tx_data[12] = x_std_sm_flux_ingress_0__o_tx_data_0[12];
	assign x_std_sm_flux_ingress_0__o_tx_data[13] = x_std_sm_flux_ingress_0__o_tx_data_0[13];
	assign x_std_sm_flux_ingress_0__o_tx_data[14] = x_std_sm_flux_ingress_0__o_tx_data_0[14];
	assign x_std_sm_flux_ingress_0__o_tx_data[15] = x_std_sm_flux_ingress_0__o_tx_data_0[15];
	assign x_std_sm_flux_ingress_0__o_tx_data[16] = x_std_sm_flux_ingress_0__o_tx_data_0[16];
	assign x_std_sm_flux_ingress_0__o_tx_data[17] = x_std_sm_flux_ingress_0__o_tx_data_0[17];
	assign x_std_sm_flux_ingress_0__o_tx_data[18] = x_std_sm_flux_ingress_0__o_tx_data_0[18];
	assign x_std_sm_flux_ingress_0__o_tx_data[19] = x_std_sm_flux_ingress_0__o_tx_data_0[19];
	assign x_std_sm_flux_ingress_0__o_tx_data[1] = x_std_sm_flux_ingress_0__o_tx_data_0[1];
	assign x_std_sm_flux_ingress_0__o_tx_data[20] = x_std_sm_flux_ingress_0__o_tx_data_0[20];
	assign x_std_sm_flux_ingress_0__o_tx_data[21] = x_std_sm_flux_ingress_0__o_tx_data_0[21];
	assign x_std_sm_flux_ingress_0__o_tx_data[22] = x_std_sm_flux_ingress_0__o_tx_data_0[22];
	assign x_std_sm_flux_ingress_0__o_tx_data[23] = x_std_sm_flux_ingress_0__o_tx_data_0[23];
	assign x_std_sm_flux_ingress_0__o_tx_data[24] = x_std_sm_flux_ingress_0__o_tx_data_0[24];
	assign x_std_sm_flux_ingress_0__o_tx_data[25] = x_std_sm_flux_ingress_0__o_tx_data_0[25];
	assign x_std_sm_flux_ingress_0__o_tx_data[26] = x_std_sm_flux_ingress_0__o_tx_data_0[26];
	assign x_std_sm_flux_ingress_0__o_tx_data[27] = x_std_sm_flux_ingress_0__o_tx_data_0[27];
	assign x_std_sm_flux_ingress_0__o_tx_data[28] = x_std_sm_flux_ingress_0__o_tx_data_0[28];
	assign x_std_sm_flux_ingress_0__o_tx_data[29] = x_std_sm_flux_ingress_0__o_tx_data_0[29];
	assign x_std_sm_flux_ingress_0__o_tx_data[2] = x_std_sm_flux_ingress_0__o_tx_data_0[2];
	assign x_std_sm_flux_ingress_0__o_tx_data[30] = x_std_sm_flux_ingress_0__o_tx_data_0[30];
	assign x_std_sm_flux_ingress_0__o_tx_data[31] = x_std_sm_flux_ingress_0__o_tx_data_0[31];
	assign x_std_sm_flux_ingress_0__o_tx_data[32] = x_std_sm_flux_ingress_0__o_tx_data_0[32];
	assign x_std_sm_flux_ingress_0__o_tx_data[33] = x_std_sm_flux_ingress_0__o_tx_data_0[33];
	assign x_std_sm_flux_ingress_0__o_tx_data[34] = x_std_sm_flux_ingress_0__o_tx_data_0[34];
	assign x_std_sm_flux_ingress_0__o_tx_data[35] = x_std_sm_flux_ingress_0__o_tx_data_0[35];
	assign x_std_sm_flux_ingress_0__o_tx_data[36] = x_std_sm_flux_ingress_0__o_tx_data_0[36];
	assign x_std_sm_flux_ingress_0__o_tx_data[37] = x_std_sm_flux_ingress_0__o_tx_data_0[37];
	assign x_std_sm_flux_ingress_0__o_tx_data[38] = x_std_sm_flux_ingress_0__o_tx_data_0[38];
	assign x_std_sm_flux_ingress_0__o_tx_data[39] = x_std_sm_flux_ingress_0__o_tx_data_0[39];
	assign x_std_sm_flux_ingress_0__o_tx_data[3] = x_std_sm_flux_ingress_0__o_tx_data_0[3];
	assign x_std_sm_flux_ingress_0__o_tx_data[40] = x_std_sm_flux_ingress_0__o_tx_data_0[40];
	assign x_std_sm_flux_ingress_0__o_tx_data[41] = x_std_sm_flux_ingress_0__o_tx_data_0[41];
	assign x_std_sm_flux_ingress_0__o_tx_data[42] = x_std_sm_flux_ingress_0__o_tx_data_0[42];
	assign x_std_sm_flux_ingress_0__o_tx_data[43] = x_std_sm_flux_ingress_0__o_tx_data_0[43];
	assign x_std_sm_flux_ingress_0__o_tx_data[44] = x_std_sm_flux_ingress_0__o_tx_data_0[44];
	assign x_std_sm_flux_ingress_0__o_tx_data[45] = x_std_sm_flux_ingress_0__o_tx_data_0[45];
	assign x_std_sm_flux_ingress_0__o_tx_data[46] = x_std_sm_flux_ingress_0__o_tx_data_0[46];
	assign x_std_sm_flux_ingress_0__o_tx_data[47] = x_std_sm_flux_ingress_0__o_tx_data_0[47];
	assign x_std_sm_flux_ingress_0__o_tx_data[48] = x_std_sm_flux_ingress_0__o_tx_data_0[48];
	assign x_std_sm_flux_ingress_0__o_tx_data[49] = x_std_sm_flux_ingress_0__o_tx_data_0[49];
	assign x_std_sm_flux_ingress_0__o_tx_data[4] = x_std_sm_flux_ingress_0__o_tx_data_0[4];
	assign x_std_sm_flux_ingress_0__o_tx_data[50] = x_std_sm_flux_ingress_0__o_tx_data_0[50];
	assign x_std_sm_flux_ingress_0__o_tx_data[51] = x_std_sm_flux_ingress_0__o_tx_data_0[51];
	assign x_std_sm_flux_ingress_0__o_tx_data[52] = x_std_sm_flux_ingress_0__o_tx_data_0[52];
	assign x_std_sm_flux_ingress_0__o_tx_data[53] = x_std_sm_flux_ingress_0__o_tx_data_0[53];
	assign x_std_sm_flux_ingress_0__o_tx_data[54] = x_std_sm_flux_ingress_0__o_tx_data_0[54];
	assign x_std_sm_flux_ingress_0__o_tx_data[55] = x_std_sm_flux_ingress_0__o_tx_data_0[55];
	assign x_std_sm_flux_ingress_0__o_tx_data[56] = x_std_sm_flux_ingress_0__o_tx_data_0[56];
	assign x_std_sm_flux_ingress_0__o_tx_data[57] = x_std_sm_flux_ingress_0__o_tx_data_0[57];
	assign x_std_sm_flux_ingress_0__o_tx_data[58] = x_std_sm_flux_ingress_0__o_tx_data_0[58];
	assign x_std_sm_flux_ingress_0__o_tx_data[59] = x_std_sm_flux_ingress_0__o_tx_data_0[59];
	assign x_std_sm_flux_ingress_0__o_tx_data[5] = x_std_sm_flux_ingress_0__o_tx_data_0[5];
	assign x_std_sm_flux_ingress_0__o_tx_data[60] = x_std_sm_flux_ingress_0__o_tx_data_0[60];
	assign x_std_sm_flux_ingress_0__o_tx_data[61] = x_std_sm_flux_ingress_0__o_tx_data_0[61];
	assign x_std_sm_flux_ingress_0__o_tx_data[62] = x_std_sm_flux_ingress_0__o_tx_data_0[62];
	assign x_std_sm_flux_ingress_0__o_tx_data[63] = x_std_sm_flux_ingress_0__o_tx_data_0[63];
	assign x_std_sm_flux_ingress_0__o_tx_data[64] = x_std_sm_flux_ingress_0__o_tx_data_0[64];
	assign x_std_sm_flux_ingress_0__o_tx_data[65] = x_std_sm_flux_ingress_0__o_tx_data_0[65];
	assign x_std_sm_flux_ingress_0__o_tx_data[66] = x_std_sm_flux_ingress_0__o_tx_data_0[66];
	assign x_std_sm_flux_ingress_0__o_tx_data[67] = x_std_sm_flux_ingress_0__o_tx_data_0[67];
	assign x_std_sm_flux_ingress_0__o_tx_data[68] = x_std_sm_flux_ingress_0__o_tx_data_0[68];
	assign x_std_sm_flux_ingress_0__o_tx_data[69] = x_std_sm_flux_ingress_0__o_tx_data_0[69];
	assign x_std_sm_flux_ingress_0__o_tx_data[6] = x_std_sm_flux_ingress_0__o_tx_data_0[6];
	assign x_std_sm_flux_ingress_0__o_tx_data[70] = x_std_sm_flux_ingress_0__o_tx_data_0[70];
	assign x_std_sm_flux_ingress_0__o_tx_data[71] = x_std_sm_flux_ingress_0__o_tx_data_0[71];
	assign x_std_sm_flux_ingress_0__o_tx_data[72] = x_std_sm_flux_ingress_0__o_tx_data_0[72];
	assign x_std_sm_flux_ingress_0__o_tx_data[73] = x_std_sm_flux_ingress_0__o_tx_data_0[73];
	assign x_std_sm_flux_ingress_0__o_tx_data[74] = x_std_sm_flux_ingress_0__o_tx_data_0[74];
	assign x_std_sm_flux_ingress_0__o_tx_data[75] = x_std_sm_flux_ingress_0__o_tx_data_0[75];
	assign x_std_sm_flux_ingress_0__o_tx_data[76] = x_std_sm_flux_ingress_0__o_tx_data_0[76];
	assign x_std_sm_flux_ingress_0__o_tx_data[77] = x_std_sm_flux_ingress_0__o_tx_data_0[77];
	assign x_std_sm_flux_ingress_0__o_tx_data[78] = x_std_sm_flux_ingress_0__o_tx_data_0[78];
	assign x_std_sm_flux_ingress_0__o_tx_data[79] = x_std_sm_flux_ingress_0__o_tx_data_0[79];
	assign x_std_sm_flux_ingress_0__o_tx_data[7] = x_std_sm_flux_ingress_0__o_tx_data_0[7];
	assign x_std_sm_flux_ingress_0__o_tx_data[8] = x_std_sm_flux_ingress_0__o_tx_data_0[8];
	assign x_std_sm_flux_ingress_0__o_tx_data[9] = x_std_sm_flux_ingress_0__o_tx_data_0[9];
	assign x_std_sm_flux_ingress_0__o_tx_dl_ch_bit = x_std_sm_flux_ingress_0__o_tx_dl_ch_bit_1;
	assign x_std_sm_flux_ingress_0__o_txdetectrx_acka = x_std_sm_flux_ingress_0__o_txdetectrx_acka_1;
	assign x_std_sm_flux_ingress_0__o_txdetectrx_statct = x_std_sm_flux_ingress_0__o_txdetectrx_statct_1;
	assign x_std_sm_flux_ingress_0__o_txstatusa = x_std_sm_flux_ingress_0__o_txstatusa_1;
	assign x_std_sm_flux_ingress_0__o_ux_rxuser1_sel[0] = x_std_sm_flux_ingress_0__o_ux_rxuser1_sel_0[0];
	assign x_std_sm_flux_ingress_0__o_ux_rxuser1_sel[1] = x_std_sm_flux_ingress_0__o_ux_rxuser1_sel_0[1];
	assign x_std_sm_flux_ingress_0__o_ux_rxuser2_sel[0] = x_std_sm_flux_ingress_0__o_ux_rxuser2_sel_0[0];
	assign x_std_sm_flux_ingress_0__o_ux_rxuser2_sel[1] = x_std_sm_flux_ingress_0__o_ux_rxuser2_sel_0[1];
	assign x_std_sm_flux_ingress_0__o_ux_txlc_clk = x_std_sm_flux_ingress_0__o_ux_txlc_clk_1;
	assign x_std_sm_flux_ingress_0__o_ux_txuser1_sel[0] = x_std_sm_flux_ingress_0__o_ux_txuser1_sel_0[0];
	assign x_std_sm_flux_ingress_0__o_ux_txuser1_sel[1] = x_std_sm_flux_ingress_0__o_ux_txuser1_sel_0[1];
	assign x_std_sm_flux_ingress_0__o_ux_txuser2_sel[0] = x_std_sm_flux_ingress_0__o_ux_txuser2_sel_0[0];
	assign x_std_sm_flux_ingress_0__o_ux_txuser2_sel[1] = x_std_sm_flux_ingress_0__o_ux_txuser2_sel_0[1];
	assign x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[0] = x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async[0];
	assign x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[1] = x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async[1];
	assign x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[2] = x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async[2];
	assign x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[3] = x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async[3];
	assign x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[4] = x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async[4];
	assign x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[5] = x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async[5];
	assign x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[6] = x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async[6];
	assign x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_direct_1 = x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_direct;
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[0] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[0];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[10] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[10];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[11] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[11];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[12] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[12];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[13] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[13];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[14] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[14];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[15] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[15];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[16] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[16];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[17] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[17];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[18] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[18];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[19] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[19];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[1] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[1];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[2] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[2];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[3] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[3];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[4] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[4];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[5] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[5];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[6] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[6];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[7] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[7];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[8] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[8];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[9] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr[9];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0[0] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be[0];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0[1] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be[1];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0[2] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be[2];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0[3] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be[3];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_clk_1 = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_clk;
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_read_1 = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_read;
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_rstn_1 = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_rstn;
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[0] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[0];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[10] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[10];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[11] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[11];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[12] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[12];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[13] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[13];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[14] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[14];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[15] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[15];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[16] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[16];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[17] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[17];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[18] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[18];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[19] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[19];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[1] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[1];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[20] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[20];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[21] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[21];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[22] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[22];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[23] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[23];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[24] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[24];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[25] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[25];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[26] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[26];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[27] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[27];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[28] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[28];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[29] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[29];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[2] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[2];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[30] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[30];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[31] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[31];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[3] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[3];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[4] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[4];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[5] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[5];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[6] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[6];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[7] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[7];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[8] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[8];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[9] = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata[9];
	assign x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_write_1 = x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_write;
	assign x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_rx_fifo_rd_en_1 = x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_rx_fifo_rd_en;
	assign x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_tx_fifo_rd_en_1 = x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_tx_fifo_rd_en;
	assign x_std_sm_xcvrif_1ch_0__i_rstxcvrif_rx_xcvrif_sfrz_n_1 = x_std_sm_xcvrif_1ch_0__i_rstxcvrif_rx_xcvrif_sfrz_n;
	assign x_std_sm_xcvrif_1ch_0__i_rstxcvrif_tx_xcvrif_sfrz_n_1 = x_std_sm_xcvrif_1ch_0__i_rstxcvrif_tx_xcvrif_sfrz_n;
	assign x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_rx_rst_n_1 = x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_rx_rst_n;
	assign x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_signal_ok_1 = x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_signal_ok;
	assign x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rd_rst_n_1 = x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rd_rst_n;
	assign x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rst_n_1 = x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rst_n;
	assign x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_wr_rst_n_1 = x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_wr_rst_n;
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[0] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[0];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[10] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[10];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[11] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[11];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[12] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[12];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[13] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[13];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[14] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[14];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[15] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[15];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[16] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[16];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[17] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[17];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[18] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[18];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[19] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[19];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[1] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[1];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[20] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[20];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[21] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[21];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[22] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[22];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[23] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[23];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[24] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[24];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[25] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[25];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[26] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[26];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[27] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[27];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[28] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[28];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[29] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[29];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[2] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[2];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[30] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[30];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[31] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[31];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[32] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[32];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[33] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[33];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[34] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[34];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[35] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[35];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[36] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[36];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[37] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[37];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[38] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[38];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[39] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[39];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[3] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[3];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[40] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[40];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[41] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[41];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[42] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[42];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[4] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[4];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[5] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[5];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[6] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[6];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[7] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[7];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[8] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[8];
	assign x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[9] = x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data[9];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[0] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[0];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[10] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[10];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[11] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[11];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[12] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[12];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[13] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[13];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[1] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[1];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[2] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[2];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[3] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[3];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[4] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[4];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[5] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[5];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[6] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[6];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[7] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[7];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[8] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[8];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async[9] = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[9];
	assign x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_direct = x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_direct_1;
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[0] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[0];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[10] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[10];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[11] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[11];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[12] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[12];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[13] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[13];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[14] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[14];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[15] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[15];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[16] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[16];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[17] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[17];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[18] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[18];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[19] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[19];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[1] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[1];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[20] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[20];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[21] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[21];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[22] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[22];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[23] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[23];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[24] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[24];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[25] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[25];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[26] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[26];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[27] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[27];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[28] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[28];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[29] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[29];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[2] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[2];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[30] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[30];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[31] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[31];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[3] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[3];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[4] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[4];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[5] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[5];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[6] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[6];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[7] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[7];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[8] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[8];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata[9] = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[9];
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_valid = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_valid_1;
	assign x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_waitreq = x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_waitreq_1;
	assign x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_rx_fifo_rd_en = x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_rx_fifo_rd_en_1;
	assign x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_tx_fifo_rd_en = x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_tx_fifo_rd_en_1;
	assign x_std_sm_xcvrif_1ch_0__o_pma_rx_sf = x_std_sm_xcvrif_1ch_0__o_pma_rx_sf_1;
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[0] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[0];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[10] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[10];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[11] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[11];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[12] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[12];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[13] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[13];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[14] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[14];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[15] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[15];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[16] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[16];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[17] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[17];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[18] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[18];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[19] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[19];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[1] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[1];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[20] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[20];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[21] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[21];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[22] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[22];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[23] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[23];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[24] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[24];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[25] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[25];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[26] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[26];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[27] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[27];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[28] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[28];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[29] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[29];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[2] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[2];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[30] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[30];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[31] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[31];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[32] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[32];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[33] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[33];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[34] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[34];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[35] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[35];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[36] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[36];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[37] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[37];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[38] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[38];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[39] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[39];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[3] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[3];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[40] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[40];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[41] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[41];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[42] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[42];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[4] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[4];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[5] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[5];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[6] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[6];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[7] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[7];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[8] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[8];
	assign x_std_sm_xcvrif_1ch_0__o_rx_data[9] = x_std_sm_xcvrif_1ch_0__o_rx_data_0[9];
	assign x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel[0] = x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel_0[0];
	assign x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel[1] = x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel_0[1];
	assign x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel[2] = x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel_0[2];
	assign x_std_sm_xcvrif_1ch_0__o_rx_latency_pulse = x_std_sm_xcvrif_1ch_0__o_rx_latency_pulse_1;
	assign x_std_sm_xcvrif_1ch_0__o_rx_xcvr_wordclk_sel[0] = x_std_sm_xcvrif_1ch_0__o_rx_xcvr_wordclk_sel_0[0];
	assign x_std_sm_xcvrif_1ch_0__o_rx_xcvr_wordclk_sel[1] = x_std_sm_xcvrif_1ch_0__o_rx_xcvr_wordclk_sel_0[1];
	assign x_std_sm_xcvrif_1ch_0__o_tx_latency_pulse = x_std_sm_xcvrif_1ch_0__o_tx_latency_pulse_1;
	assign x_std_sm_xcvrif_1ch_0__o_tx_rst_rd_sync_rst_n = x_std_sm_xcvrif_1ch_0__o_tx_rst_rd_sync_rst_n_1;
	assign x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel[0] = x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel_0[0];
	assign x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel[1] = x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel_0[1];
	assign x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel[2] = x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel_0[2];
	assign x_std_sm_xcvrif_1ch_0__o_tx_rst_wr_sync_rst_n = x_std_sm_xcvrif_1ch_0__o_tx_rst_wr_sync_rst_n_1;
	assign x_std_sm_xcvrif_1ch_0__o_tx_source_sel[0] = x_std_sm_xcvrif_1ch_0__o_tx_source_sel_0[0];
	assign x_std_sm_xcvrif_1ch_0__o_tx_source_sel[1] = x_std_sm_xcvrif_1ch_0__o_tx_source_sel_0[1];
	assign x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel[0] = x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel_0[0];
	assign x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel[1] = x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel_0[1];
	assign x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel[2] = x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel_0[2];
	assign xcvrif_tx_esys_clk_mux_u0__o_esys_ch_clk_3 = x_mux_sm_xcvrif_rx_ch_clk_mux_0__i_sys_clk;
        assign x_std_sm_flux_ingress_0__o_ux_tx_ch_ptr_smpl = x_std_sm_flux_ingress_0__o_ux_tx_ch_ptr_smpl_1;

	tennm_sm_xcvrif_1ch #(
		.dr_enabled(x_std_sm_xcvrif_1ch_0__dr_enabled),
		.duplex_mode(x_std_sm_xcvrif_1ch_0__duplex_mode),
		.eth_rx_clk_hz(x_std_sm_xcvrif_1ch_0__eth_rx_clk_hz),
		.eth_tx_clk_hz(x_std_sm_xcvrif_1ch_0__eth_tx_clk_hz),
		.loopback_mode(x_std_sm_xcvrif_1ch_0__loopback_mode),
		.rx_bond_size(x_std_sm_xcvrif_1ch_0__rx_bond_size),
		.rx_bonding_mode(x_std_sm_xcvrif_1ch_0__rx_bonding_mode),
		.rx_dl_enable(x_std_sm_xcvrif_1ch_0__rx_dl_enable),
		.rx_en(x_std_sm_xcvrif_1ch_0__rx_en),
		.rx_fifo_mode(x_std_sm_xcvrif_1ch_0__rx_fifo_mode),
		.rx_fifo_rd_en_dynamic_mux(x_std_sm_xcvrif_1ch_0__rx_fifo_rd_en_dynamic_mux),
		.rx_gb_width(x_std_sm_xcvrif_1ch_0__rx_gb_width),
		.rx_word_clk_dynamic_mux(x_std_sm_xcvrif_1ch_0__rx_word_clk_dynamic_mux),
		.sim_mode(x_std_sm_xcvrif_1ch_0__sim_mode),
		.sup_mode(x_std_sm_xcvrif_1ch_0__sup_mode),
		.tx_bond_size(x_std_sm_xcvrif_1ch_0__tx_bond_size),
		.tx_bonding_mode(x_std_sm_xcvrif_1ch_0__tx_bonding_mode),
		.tx_dl_enable(x_std_sm_xcvrif_1ch_0__tx_dl_enable),
		.tx_dynamic_mux(x_std_sm_xcvrif_1ch_0__tx_dynamic_mux),
		.tx_en(x_std_sm_xcvrif_1ch_0__tx_en),
		.tx_fifo_mode(x_std_sm_xcvrif_1ch_0__tx_fifo_mode),
		.tx_fifo_rd_en_dynamic_mux(x_std_sm_xcvrif_1ch_0__tx_fifo_rd_en_dynamic_mux),
		.tx_gb_width(x_std_sm_xcvrif_1ch_0__tx_gb_width),
		.tx_rst_dynamic_mux(x_std_sm_xcvrif_1ch_0__tx_rst_dynamic_mux),
		.tx_word_clk_dynamic_mux(x_std_sm_xcvrif_1ch_0__tx_word_clk_dynamic_mux),
		.xcvr_rxword_clk_hz(x_std_sm_xcvrif_1ch_0__xcvr_rxword_clk_hz),
		.xcvr_txword_clk_hz(x_std_sm_xcvrif_1ch_0__xcvr_txword_clk_hz)
	) x_std_sm_xcvrif_1ch_0 (
		.i_ch_eth_xcvrif_tx_async({ x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[6], x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[5], x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[4], x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[3], x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[2], x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[1], x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_async_0[0] }),
		.i_ch_eth_xcvrif_tx_direct(x_std_sm_xcvrif_1ch_0__i_ch_eth_xcvrif_tx_direct_1),
		.i_ch_lavmm_xcvrif_addr({ x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[19], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[18], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[17], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[16], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[15], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[14], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[13], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[12], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[11], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[10], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[9], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[8], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[7], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[6], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[5], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[4], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[3], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[2], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[1], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_addr_0[0] }),
		.i_ch_lavmm_xcvrif_be({ x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0[3], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0[2], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0[1], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_be_0[0] }),
		.i_ch_lavmm_xcvrif_clk(x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_clk_1),
		.i_ch_lavmm_xcvrif_read(x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_read_1),
		.i_ch_lavmm_xcvrif_rstn(x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_rstn_1),
		.i_ch_lavmm_xcvrif_wdata({ x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[31], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[30], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[29], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[28], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[27], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[26], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[25], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[24], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[23], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[22], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[21], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[20], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[19], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[18], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[17], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[16], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[15], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[14], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[13], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[12], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[11], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[10], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[9], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[8], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[7], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[6], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[5], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[4], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[3], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[2], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[1], x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_wdata_0[0] }),
		.i_ch_lavmm_xcvrif_write(x_std_sm_xcvrif_1ch_0__i_ch_lavmm_xcvrif_write_1),
		.i_ch_xcvrif_rx_fifo_rd_en(x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_rx_fifo_rd_en_1),
		.i_ch_xcvrif_tx_fifo_rd_en(x_std_sm_xcvrif_1ch_0__i_ch_xcvrif_tx_fifo_rd_en_1),
		.i_eth_rx_ch_clk(o_eth_rx_ch3_clk_4),
		.i_eth_tx_ch_clk(o_eth_tx_ch3_clk_4),
		.i_pld_rx_lat_sclk_ch(mac_pcs_fec_top_u0__o_ux_sclk_rx_ch3_0),
		.i_pld_tx_lat_sclk_ch(mac_pcs_fec_top_u0__o_ux_sclk_tx_ch3_0),
		.i_rstxcvrif_rx_xcvrif_sfrz_n(x_std_sm_xcvrif_1ch_0__i_rstxcvrif_rx_xcvrif_sfrz_n_1),
		.i_rstxcvrif_tx_xcvrif_sfrz_n(x_std_sm_xcvrif_1ch_0__i_rstxcvrif_tx_xcvrif_sfrz_n_1),
		.i_rstxcvrif_xcvrif_rx_rst_n(x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_rx_rst_n_1),
		.i_rstxcvrif_xcvrif_signal_ok(x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_signal_ok_1),
		.i_rstxcvrif_xcvrif_tx_rd_rst_n(x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rd_rst_n_1),
		.i_rstxcvrif_xcvrif_tx_rst_n(x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_rst_n_1),
		.i_rstxcvrif_xcvrif_tx_wr_rst_n(x_std_sm_xcvrif_1ch_0__i_rstxcvrif_xcvrif_tx_wr_rst_n_1),
		.i_rx_dl_bit(o_rx_dl_ch3_bit_1),
		.i_ux_rx_ch_data({ o_eth_rx_data_3[31], o_eth_rx_data_3[30], o_eth_rx_data_3[29], o_eth_rx_data_3[28], o_eth_rx_data_3[27], o_eth_rx_data_3[26], o_eth_rx_data_3[25], o_eth_rx_data_3[24], o_eth_rx_data_3[23], o_eth_rx_data_3[22], o_eth_rx_data_3[21], o_eth_rx_data_3[20], o_eth_rx_data_3[19], o_eth_rx_data_3[18], o_eth_rx_data_3[17], o_eth_rx_data_3[16], o_eth_rx_data_3[15], o_eth_rx_data_3[14], o_eth_rx_data_3[13], o_eth_rx_data_3[12], o_eth_rx_data_3[11], o_eth_rx_data_3[10], o_eth_rx_data_3[9], o_eth_rx_data_3[8], o_eth_rx_data_3[7], o_eth_rx_data_3[6], o_eth_rx_data_3[5], o_eth_rx_data_3[4], o_eth_rx_data_3[3], o_eth_rx_data_3[2], o_eth_rx_data_3[1], o_eth_rx_data_3[0] }),
		.i_xcvr_rx_ch_clk(o_xcvr_rxword_ch_clk_3),
		.i_xcvr_tx_ch_clk(o_xcvr_txword_ch_clk_3),
		.i_xcvrif_tx_mux_data({ x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[42], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[41], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[40], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[39], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[38], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[37], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[36], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[35], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[34], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[33], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[32], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[31], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[30], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[29], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[28], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[27], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[26], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[25], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[24], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[23], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[22], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[21], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[20], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[19], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[18], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[17], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[16], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[15], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[14], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[13], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[12], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[11], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[10], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[9], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[8], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[7], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[6], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[5], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[4], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[3], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[2], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[1], x_std_sm_xcvrif_1ch_0__i_xcvrif_tx_mux_data_0[0] }),
		.o_ch_eth_xcvrif_rx_async({ x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[13], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[12], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[11], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[10], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[9], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[8], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[7], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[6], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[5], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[4], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[3], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[2], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[1], x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_async_0[0] }),
		.o_ch_eth_xcvrif_rx_direct(x_std_sm_xcvrif_1ch_0__o_ch_eth_xcvrif_rx_direct_1),
		.o_ch_lavmm_xcvrif_rdata({ x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[31], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[30], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[29], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[28], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[27], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[26], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[25], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[24], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[23], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[22], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[21], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[20], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[19], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[18], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[17], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[16], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[15], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[14], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[13], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[12], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[11], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[10], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[9], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[8], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[7], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[6], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[5], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[4], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[3], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[2], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[1], x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_0[0] }),
		.o_ch_lavmm_xcvrif_rdata_valid(x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_rdata_valid_1),
		.o_ch_lavmm_xcvrif_waitreq(x_std_sm_xcvrif_1ch_0__o_ch_lavmm_xcvrif_waitreq_1),
		.o_ch_xcvrif_rx_fifo_rd_en(x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_rx_fifo_rd_en_1),
		.o_ch_xcvrif_tx_fifo_rd_en(x_std_sm_xcvrif_1ch_0__o_ch_xcvrif_tx_fifo_rd_en_1),
		.o_pma_rx_sf(x_std_sm_xcvrif_1ch_0__o_pma_rx_sf_1),
		.o_rx_data({ x_std_sm_xcvrif_1ch_0__o_rx_data_0[42], x_std_sm_xcvrif_1ch_0__o_rx_data_0[41], x_std_sm_xcvrif_1ch_0__o_rx_data_0[40], x_std_sm_xcvrif_1ch_0__o_rx_data_0[39], x_std_sm_xcvrif_1ch_0__o_rx_data_0[38], x_std_sm_xcvrif_1ch_0__o_rx_data_0[37], x_std_sm_xcvrif_1ch_0__o_rx_data_0[36], x_std_sm_xcvrif_1ch_0__o_rx_data_0[35], x_std_sm_xcvrif_1ch_0__o_rx_data_0[34], x_std_sm_xcvrif_1ch_0__o_rx_data_0[33], x_std_sm_xcvrif_1ch_0__o_rx_data_0[32], x_std_sm_xcvrif_1ch_0__o_rx_data_0[31], x_std_sm_xcvrif_1ch_0__o_rx_data_0[30], x_std_sm_xcvrif_1ch_0__o_rx_data_0[29], x_std_sm_xcvrif_1ch_0__o_rx_data_0[28], x_std_sm_xcvrif_1ch_0__o_rx_data_0[27], x_std_sm_xcvrif_1ch_0__o_rx_data_0[26], x_std_sm_xcvrif_1ch_0__o_rx_data_0[25], x_std_sm_xcvrif_1ch_0__o_rx_data_0[24], x_std_sm_xcvrif_1ch_0__o_rx_data_0[23], x_std_sm_xcvrif_1ch_0__o_rx_data_0[22], x_std_sm_xcvrif_1ch_0__o_rx_data_0[21], x_std_sm_xcvrif_1ch_0__o_rx_data_0[20], x_std_sm_xcvrif_1ch_0__o_rx_data_0[19], x_std_sm_xcvrif_1ch_0__o_rx_data_0[18], x_std_sm_xcvrif_1ch_0__o_rx_data_0[17], x_std_sm_xcvrif_1ch_0__o_rx_data_0[16], x_std_sm_xcvrif_1ch_0__o_rx_data_0[15], x_std_sm_xcvrif_1ch_0__o_rx_data_0[14], x_std_sm_xcvrif_1ch_0__o_rx_data_0[13], x_std_sm_xcvrif_1ch_0__o_rx_data_0[12], x_std_sm_xcvrif_1ch_0__o_rx_data_0[11], x_std_sm_xcvrif_1ch_0__o_rx_data_0[10], x_std_sm_xcvrif_1ch_0__o_rx_data_0[9], x_std_sm_xcvrif_1ch_0__o_rx_data_0[8], x_std_sm_xcvrif_1ch_0__o_rx_data_0[7], x_std_sm_xcvrif_1ch_0__o_rx_data_0[6], x_std_sm_xcvrif_1ch_0__o_rx_data_0[5], x_std_sm_xcvrif_1ch_0__o_rx_data_0[4], x_std_sm_xcvrif_1ch_0__o_rx_data_0[3], x_std_sm_xcvrif_1ch_0__o_rx_data_0[2], x_std_sm_xcvrif_1ch_0__o_rx_data_0[1], x_std_sm_xcvrif_1ch_0__o_rx_data_0[0] }),
		.o_rx_fifo_en_sel({ x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel_0[2], x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel_0[1], x_std_sm_xcvrif_1ch_0__o_rx_fifo_en_sel_0[0] }),
		.o_rx_latency_pulse(x_std_sm_xcvrif_1ch_0__o_rx_latency_pulse_1),
		.o_rx_xcvr_wordclk_sel({ x_std_sm_xcvrif_1ch_0__o_rx_xcvr_wordclk_sel_0[1], x_std_sm_xcvrif_1ch_0__o_rx_xcvr_wordclk_sel_0[0] }),
		.o_tx_dl_bit(o_tx_dl_ch3_bit_0),
		.o_tx_latency_pulse(x_std_sm_xcvrif_1ch_0__o_tx_latency_pulse_1),
		.o_tx_rst_rd_sync_rst_n(x_std_sm_xcvrif_1ch_0__o_tx_rst_rd_sync_rst_n_1),
		.o_tx_rst_source_sel({ x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel_0[2], x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel_0[1], x_std_sm_xcvrif_1ch_0__o_tx_rst_source_sel_0[0] }),
		.o_tx_rst_wr_sync_rst_n(x_std_sm_xcvrif_1ch_0__o_tx_rst_wr_sync_rst_n_1),
		.o_tx_source_sel({ x_std_sm_xcvrif_1ch_0__o_tx_source_sel_0[1], x_std_sm_xcvrif_1ch_0__o_tx_source_sel_0[0] }),
		.o_tx_xcvr_wordclk_sel({ x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel_0[2], x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel_0[1], x_std_sm_xcvrif_1ch_0__o_tx_xcvr_wordclk_sel_0[0] }),
		.o_ux_tx_ch_data({ o_ux_tx_ch3_data_1[31], o_ux_tx_ch3_data_1[30], o_ux_tx_ch3_data_1[29], o_ux_tx_ch3_data_1[28], o_ux_tx_ch3_data_1[27], o_ux_tx_ch3_data_1[26], o_ux_tx_ch3_data_1[25], o_ux_tx_ch3_data_1[24], o_ux_tx_ch3_data_1[23], o_ux_tx_ch3_data_1[22], o_ux_tx_ch3_data_1[21], o_ux_tx_ch3_data_1[20], o_ux_tx_ch3_data_1[19], o_ux_tx_ch3_data_1[18], o_ux_tx_ch3_data_1[17], o_ux_tx_ch3_data_1[16], o_ux_tx_ch3_data_1[15], o_ux_tx_ch3_data_1[14], o_ux_tx_ch3_data_1[13], o_ux_tx_ch3_data_1[12], o_ux_tx_ch3_data_1[11], o_ux_tx_ch3_data_1[10], o_ux_tx_ch3_data_1[9], o_ux_tx_ch3_data_1[8], o_ux_tx_ch3_data_1[7], o_ux_tx_ch3_data_1[6], o_ux_tx_ch3_data_1[5], o_ux_tx_ch3_data_1[4], o_ux_tx_ch3_data_1[3], o_ux_tx_ch3_data_1[2], o_ux_tx_ch3_data_1[1], o_ux_tx_ch3_data_1[0] }),
		.o_ux_tx_ch_sync_data({ o_ux_tx_ch3_sync_data_1[6], o_ux_tx_ch3_sync_data_1[5], o_ux_tx_ch3_sync_data_1[4], o_ux_tx_ch3_sync_data_1[3], o_ux_tx_ch3_sync_data_1[2], o_ux_tx_ch3_sync_data_1[1], o_ux_tx_ch3_sync_data_1[0] })
	);

	tennm_sm_flux_ingress #(
		.clkrx_refclk_cssm_fw_control(x_std_sm_flux_ingress_0__clkrx_refclk_cssm_fw_control),
		.clkrx_refclk_sector_specifies_refclk_ready(x_std_sm_flux_ingress_0__clkrx_refclk_sector_specifies_refclk_ready),
		.dr_enabled(x_std_sm_flux_ingress_0__dr_enabled),
		.flux_mode(x_std_sm_flux_ingress_0__flux_mode),
		.local_refclk_cssm_fw_control(x_std_sm_flux_ingress_0__local_refclk_cssm_fw_control),
		.local_refclk_sector_specifies_refclk_ready(x_std_sm_flux_ingress_0__local_refclk_sector_specifies_refclk_ready),
		.rx_dl_enable(x_std_sm_flux_ingress_0__rx_dl_enable),
		.rx_dl_rx_lat_bit_for_async(x_std_sm_flux_ingress_0__rx_dl_rx_lat_bit_for_async),
		.rx_dl_rxbit_cntr_pma(x_std_sm_flux_ingress_0__rx_dl_rxbit_cntr_pma),
		.rx_dl_rxbit_rollover(x_std_sm_flux_ingress_0__rx_dl_rxbit_rollover),
		.rx_fec_type_used(x_std_sm_flux_ingress_0__rx_fec_type_used),
		.rx_protocol_hint(x_std_sm_flux_ingress_0__rx_protocol_hint),
		.rx_sim_mode(x_std_sm_flux_ingress_0__rx_sim_mode),
		.rx_user1_clk_mux_dynamic_sel(x_std_sm_flux_ingress_0__rx_user1_clk_mux_dynamic_sel),
		.rx_user2_clk_mux_dynamic_sel(x_std_sm_flux_ingress_0__rx_user2_clk_mux_dynamic_sel),
		.sequencer_reg_en(x_std_sm_flux_ingress_0__sequencer_reg_en),
		.tx_bond_size(x_std_sm_flux_ingress_0__tx_bond_size),
		.tx_dl_enable(x_std_sm_flux_ingress_0__tx_dl_enable),
		.tx_sim_mode(x_std_sm_flux_ingress_0__tx_sim_mode),
		.tx_user1_clk_mux_dynamic_sel(x_std_sm_flux_ingress_0__tx_user1_clk_mux_dynamic_sel),
		.tx_user2_clk_mux_dynamic_sel(x_std_sm_flux_ingress_0__tx_user2_clk_mux_dynamic_sel)
	) x_std_sm_flux_ingress_0 (
		.i_dat_pcs_measlatbit(x_std_sm_flux_ingress_0__i_dat_pcs_measlatbit_1),
		.i_dpma_refclk(x_std_sm_flux_ingress_0__i_dpma_refclk_1),
		.i_flux_cpi_int(x_std_sm_flux_ingress_0__i_flux_cpi_int_1),
		.i_flux_int(x_std_sm_flux_ingress_0__i_flux_int_1),
		.i_flux_srds_rdy(x_std_sm_flux_ingress_0__i_flux_srds_rdy_1),
		.i_ft_rx_async_pulse_ch(x_std_sm_flux_ingress_0__i_ft_rx_async_pulse_ch_1),
		.i_ft_rx_sclk_sync_ch(x_std_sm_flux_ingress_0__i_ft_rx_sclk_sync_ch_1),
		.i_ft_tx_async_pulse_ch(x_std_sm_flux_ingress_0__i_ft_tx_async_pulse_ch_1),
		.i_ft_tx_sclk_sync_ch(x_std_sm_flux_ingress_0__i_ft_tx_sclk_sync_ch_1),
		.i_ick_pcs_txword(o_pcs_txword_3),
		.i_ick_sclk_rx(mac_pcs_fec_top_u0__o_ux_sclk_rx_ch3_0),
		.i_ick_sclk_tx(mac_pcs_fec_top_u0__o_ux_sclk_tx_ch3_0),
		.i_ictl_pcs_txenable_a(x_std_sm_flux_ingress_0__i_ictl_pcs_txenable_a_1),
		.i_lavmm_addr({ x_std_sm_flux_ingress_0__i_lavmm_addr_0[19], x_std_sm_flux_ingress_0__i_lavmm_addr_0[18], x_std_sm_flux_ingress_0__i_lavmm_addr_0[17], x_std_sm_flux_ingress_0__i_lavmm_addr_0[16], x_std_sm_flux_ingress_0__i_lavmm_addr_0[15], x_std_sm_flux_ingress_0__i_lavmm_addr_0[14], x_std_sm_flux_ingress_0__i_lavmm_addr_0[13], x_std_sm_flux_ingress_0__i_lavmm_addr_0[12], x_std_sm_flux_ingress_0__i_lavmm_addr_0[11], x_std_sm_flux_ingress_0__i_lavmm_addr_0[10], x_std_sm_flux_ingress_0__i_lavmm_addr_0[9], x_std_sm_flux_ingress_0__i_lavmm_addr_0[8], x_std_sm_flux_ingress_0__i_lavmm_addr_0[7], x_std_sm_flux_ingress_0__i_lavmm_addr_0[6], x_std_sm_flux_ingress_0__i_lavmm_addr_0[5], x_std_sm_flux_ingress_0__i_lavmm_addr_0[4], x_std_sm_flux_ingress_0__i_lavmm_addr_0[3], x_std_sm_flux_ingress_0__i_lavmm_addr_0[2], x_std_sm_flux_ingress_0__i_lavmm_addr_0[1], x_std_sm_flux_ingress_0__i_lavmm_addr_0[0] }),
		.i_lavmm_be({ x_std_sm_flux_ingress_0__i_lavmm_be_0[3], x_std_sm_flux_ingress_0__i_lavmm_be_0[2], x_std_sm_flux_ingress_0__i_lavmm_be_0[1], x_std_sm_flux_ingress_0__i_lavmm_be_0[0] }),
		.i_lavmm_clk(x_std_sm_flux_ingress_0__i_lavmm_clk_1),
		.i_lavmm_rdata({ x_std_sm_flux_ingress_0__i_lavmm_rdata_0[31], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[30], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[29], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[28], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[27], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[26], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[25], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[24], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[23], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[22], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[21], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[20], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[19], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[18], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[17], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[16], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[15], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[14], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[13], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[12], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[11], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[10], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[9], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[8], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[7], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[6], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[5], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[4], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[3], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[2], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[1], x_std_sm_flux_ingress_0__i_lavmm_rdata_0[0] }),
		.i_lavmm_rdata_valid(x_std_sm_flux_ingress_0__i_lavmm_rdata_valid_1),
		.i_lavmm_read(x_std_sm_flux_ingress_0__i_lavmm_read_1),
		.i_lavmm_rstn(x_std_sm_flux_ingress_0__i_lavmm_rstn_1),
		.i_lavmm_waitreq(x_std_sm_flux_ingress_0__i_lavmm_waitreq_1),
		.i_lavmm_wdata({ x_std_sm_flux_ingress_0__i_lavmm_wdata_0[31], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[30], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[29], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[28], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[27], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[26], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[25], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[24], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[23], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[22], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[21], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[20], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[19], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[18], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[17], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[16], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[15], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[14], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[13], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[12], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[11], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[10], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[9], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[8], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[7], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[6], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[5], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[4], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[3], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[2], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[1], x_std_sm_flux_ingress_0__i_lavmm_wdata_0[0] }),
		.i_lavmm_write(x_std_sm_flux_ingress_0__i_lavmm_write_1),
		.i_lfps_ennt(x_std_sm_flux_ingress_0__i_lfps_ennt_1),
		.i_ock_pcs_txword(x_std_sm_flux_ingress_0__i_ock_pcs_txword_1),
		.i_oflux_octl_pcs_txptr_smpl_lane(x_std_sm_flux_ingress_0__i_oflux_octl_pcs_txptr_smpl_lane_1),
		.i_pcie_l1ctrla({ x_std_sm_flux_ingress_0__i_pcie_l1ctrla_0[1], x_std_sm_flux_ingress_0__i_pcie_l1ctrla_0[0] }),
		.i_pcie_pcs_rx_rst(x_std_sm_flux_ingress_0__i_pcie_pcs_rx_rst_1),
		.i_pcie_pcs_tx_rst(x_std_sm_flux_ingress_0__i_pcie_pcs_tx_rst_1),
		.i_pcs_pipe_rstn(x_std_sm_flux_ingress_0__i_pcs_pipe_rstn_1),
		.i_pcs_rxpostdiv(x_std_sm_flux_ingress_0__i_pcs_rxpostdiv_1),
		.i_pcs_rxword(x_std_sm_flux_ingress_0__i_pcs_rxword_1),
		.i_pma_cmn_ctrl(x_std_sm_flux_ingress_0__i_pma_cmn_ctrl_1),
		.i_pma_ctrl(x_std_sm_flux_ingress_0__i_pma_ctrl_1),
		.i_rst_pld_ux_rx_pma_rst_n(x_std_sm_flux_ingress_0__i_rst_pld_ux_rx_pma_rst_n_1),
		.i_rst_pld_ux_tx_pma_rst_n(x_std_sm_flux_ingress_0__i_rst_pld_ux_tx_pma_rst_n_1),
		.i_rst_ux_rx_sfrz(x_std_sm_flux_ingress_0__i_rst_ux_rx_sfrz_1),
		.i_rx_data({ x_std_sm_flux_ingress_0__i_rx_data_0[79], x_std_sm_flux_ingress_0__i_rx_data_0[78], x_std_sm_flux_ingress_0__i_rx_data_0[77], x_std_sm_flux_ingress_0__i_rx_data_0[76], x_std_sm_flux_ingress_0__i_rx_data_0[75], x_std_sm_flux_ingress_0__i_rx_data_0[74], x_std_sm_flux_ingress_0__i_rx_data_0[73], x_std_sm_flux_ingress_0__i_rx_data_0[72], x_std_sm_flux_ingress_0__i_rx_data_0[71], x_std_sm_flux_ingress_0__i_rx_data_0[70], x_std_sm_flux_ingress_0__i_rx_data_0[69], x_std_sm_flux_ingress_0__i_rx_data_0[68], x_std_sm_flux_ingress_0__i_rx_data_0[67], x_std_sm_flux_ingress_0__i_rx_data_0[66], x_std_sm_flux_ingress_0__i_rx_data_0[65], x_std_sm_flux_ingress_0__i_rx_data_0[64], x_std_sm_flux_ingress_0__i_rx_data_0[63], x_std_sm_flux_ingress_0__i_rx_data_0[62], x_std_sm_flux_ingress_0__i_rx_data_0[61], x_std_sm_flux_ingress_0__i_rx_data_0[60], x_std_sm_flux_ingress_0__i_rx_data_0[59], x_std_sm_flux_ingress_0__i_rx_data_0[58], x_std_sm_flux_ingress_0__i_rx_data_0[57], x_std_sm_flux_ingress_0__i_rx_data_0[56], x_std_sm_flux_ingress_0__i_rx_data_0[55], x_std_sm_flux_ingress_0__i_rx_data_0[54], x_std_sm_flux_ingress_0__i_rx_data_0[53], x_std_sm_flux_ingress_0__i_rx_data_0[52], x_std_sm_flux_ingress_0__i_rx_data_0[51], x_std_sm_flux_ingress_0__i_rx_data_0[50], x_std_sm_flux_ingress_0__i_rx_data_0[49], x_std_sm_flux_ingress_0__i_rx_data_0[48], x_std_sm_flux_ingress_0__i_rx_data_0[47], x_std_sm_flux_ingress_0__i_rx_data_0[46], x_std_sm_flux_ingress_0__i_rx_data_0[45], x_std_sm_flux_ingress_0__i_rx_data_0[44], x_std_sm_flux_ingress_0__i_rx_data_0[43], x_std_sm_flux_ingress_0__i_rx_data_0[42], x_std_sm_flux_ingress_0__i_rx_data_0[41], x_std_sm_flux_ingress_0__i_rx_data_0[40], x_std_sm_flux_ingress_0__i_rx_data_0[39], x_std_sm_flux_ingress_0__i_rx_data_0[38], x_std_sm_flux_ingress_0__i_rx_data_0[37], x_std_sm_flux_ingress_0__i_rx_data_0[36], x_std_sm_flux_ingress_0__i_rx_data_0[35], x_std_sm_flux_ingress_0__i_rx_data_0[34], x_std_sm_flux_ingress_0__i_rx_data_0[33], x_std_sm_flux_ingress_0__i_rx_data_0[32], x_std_sm_flux_ingress_0__i_rx_data_0[31], x_std_sm_flux_ingress_0__i_rx_data_0[30], x_std_sm_flux_ingress_0__i_rx_data_0[29], x_std_sm_flux_ingress_0__i_rx_data_0[28], x_std_sm_flux_ingress_0__i_rx_data_0[27], x_std_sm_flux_ingress_0__i_rx_data_0[26], x_std_sm_flux_ingress_0__i_rx_data_0[25], x_std_sm_flux_ingress_0__i_rx_data_0[24], x_std_sm_flux_ingress_0__i_rx_data_0[23], x_std_sm_flux_ingress_0__i_rx_data_0[22], x_std_sm_flux_ingress_0__i_rx_data_0[21], x_std_sm_flux_ingress_0__i_rx_data_0[20], x_std_sm_flux_ingress_0__i_rx_data_0[19], x_std_sm_flux_ingress_0__i_rx_data_0[18], x_std_sm_flux_ingress_0__i_rx_data_0[17], x_std_sm_flux_ingress_0__i_rx_data_0[16], x_std_sm_flux_ingress_0__i_rx_data_0[15], x_std_sm_flux_ingress_0__i_rx_data_0[14], x_std_sm_flux_ingress_0__i_rx_data_0[13], x_std_sm_flux_ingress_0__i_rx_data_0[12], x_std_sm_flux_ingress_0__i_rx_data_0[11], x_std_sm_flux_ingress_0__i_rx_data_0[10], x_std_sm_flux_ingress_0__i_rx_data_0[9], x_std_sm_flux_ingress_0__i_rx_data_0[8], x_std_sm_flux_ingress_0__i_rx_data_0[7], x_std_sm_flux_ingress_0__i_rx_data_0[6], x_std_sm_flux_ingress_0__i_rx_data_0[5], x_std_sm_flux_ingress_0__i_rx_data_0[4], x_std_sm_flux_ingress_0__i_rx_data_0[3], x_std_sm_flux_ingress_0__i_rx_data_0[2], x_std_sm_flux_ingress_0__i_rx_data_0[1], x_std_sm_flux_ingress_0__i_rx_data_0[0] }),
		.i_rx_dl_ch_bit(x_std_sm_flux_ingress_0__i_rx_dl_ch_bit_1),
		.i_rxeiosdetectstata(x_std_sm_flux_ingress_0__i_rxeiosdetectstata_1),
		.i_rxeq_precal_code_selnt({ x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt_0[2], x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt_0[1], x_std_sm_flux_ingress_0__i_rxeq_precal_code_selnt_0[0] }),
		.i_rxeq_starta(x_std_sm_flux_ingress_0__i_rxeq_starta_1),
		.i_rxeq_static_ena(x_std_sm_flux_ingress_0__i_rxeq_static_ena_1),
		.i_rxmargin_direction_nt(x_std_sm_flux_ingress_0__i_rxmargin_direction_nt_1),
		.i_rxmargin_mode_nt(x_std_sm_flux_ingress_0__i_rxmargin_mode_nt_1),
		.i_rxmargin_offset_change_a(x_std_sm_flux_ingress_0__i_rxmargin_offset_change_a_1),
		.i_rxmargin_offset_nt({ x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[6], x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[5], x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[4], x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[3], x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[2], x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[1], x_std_sm_flux_ingress_0__i_rxmargin_offset_nt_0[0] }),
		.i_rxmargin_start_a(x_std_sm_flux_ingress_0__i_rxmargin_start_a_1),
		.i_rxpstate({ x_std_sm_flux_ingress_0__i_rxpstate_0[2], x_std_sm_flux_ingress_0__i_rxpstate_0[1], x_std_sm_flux_ingress_0__i_rxpstate_0[0] }),
		.i_rxrate({ x_std_sm_flux_ingress_0__i_rxrate_0[3], x_std_sm_flux_ingress_0__i_rxrate_0[2], x_std_sm_flux_ingress_0__i_rxrate_0[1], x_std_sm_flux_ingress_0__i_rxrate_0[0] }),
		.i_rxterm_hiz_ena(x_std_sm_flux_ingress_0__i_rxterm_hiz_ena_1),
		.i_rxwidth({ x_std_sm_flux_ingress_0__i_rxwidth_0[2], x_std_sm_flux_ingress_0__i_rxwidth_0[1], x_std_sm_flux_ingress_0__i_rxwidth_0[0] }),
		.i_sm_flux_egress({ x_std_sm_flux_ingress_0__i_sm_flux_egress_0[256], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[255], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[254], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[253], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[252], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[251], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[250], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[249], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[248], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[247], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[246], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[245], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[244], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[243], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[242], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[241], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[240], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[239], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[238], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[237], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[236], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[235], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[234], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[233], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[232], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[231], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[230], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[229], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[228], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[227], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[226], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[225], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[224], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[223], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[222], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[221], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[220], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[219], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[218], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[217], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[216], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[215], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[214], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[213], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[212], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[211], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[210], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[209], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[208], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[207], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[206], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[205], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[204], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[203], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[202], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[201], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[200], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[199], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[198], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[197], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[196], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[195], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[194], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[193], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[192], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[191], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[190], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[189], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[188], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[187], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[186], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[185], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[184], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[183], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[182], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[181], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[180], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[179], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[178], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[177], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[176], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[175], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[174], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[173], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[172], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[171], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[170], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[169], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[168], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[167], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[166], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[165], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[164], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[163], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[162], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[161], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[160], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[159], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[158], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[157], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[156], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[155], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[154], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[153], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[152], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[151], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[150], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[149], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[148], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[147], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[146], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[145], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[144], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[143], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[142], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[141], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[140], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[139], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[138], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[137], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[136], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[135], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[134], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[133], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[132], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[131], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[130], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[129], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[128], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[127], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[126], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[125], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[124], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[123], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[122], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[121], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[120], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[119], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[118], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[117], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[116], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[115], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[114], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[113], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[112], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[111], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[110], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[109], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[108], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[107], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[106], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[105], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[104], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[103], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[102], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[101], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[100], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[99], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[98], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[97], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[96], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[95], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[94], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[93], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[92], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[91], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[90], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[89], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[88], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[87], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[86], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[85], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[84], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[83], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[82], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[81], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[80], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[79], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[78], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[77], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[76], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[75], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[74], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[73], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[72], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[71], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[70], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[69], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[68], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[67], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[66], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[65], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[64], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[63], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[62], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[61], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[60], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[59], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[58], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[57], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[56], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[55], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[54], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[53], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[52], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[51], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[50], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[49], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[48], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[47], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[46], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[45], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[44], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[43], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[42], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[41], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[40], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[39], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[38], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[37], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[36], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[35], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[34], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[33], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[32], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[31], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[30], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[29], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[28], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[27], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[26], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[25], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[24], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[23], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[22], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[21], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[20], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[19], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[18], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[17], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[16], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[15], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[14], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[13], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[12], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[11], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[10], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[9], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[8], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[7], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[6], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[5], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[4], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[3], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[2], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[1], x_std_sm_flux_ingress_0__i_sm_flux_egress_0[0] }),
		.i_ss_async_pldif({ x_std_sm_flux_ingress_0__i_ss_async_pldif_0[79], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[78], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[77], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[76], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[75], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[74], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[73], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[72], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[71], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[70], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[69], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[68], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[67], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[66], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[65], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[64], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[63], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[62], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[61], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[60], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[59], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[58], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[57], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[56], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[55], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[54], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[53], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[52], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[51], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[50], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[49], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[48], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[47], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[46], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[45], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[44], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[43], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[42], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[41], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[40], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[39], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[38], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[37], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[36], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[35], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[34], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[33], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[32], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[31], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[30], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[29], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[28], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[27], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[26], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[25], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[24], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[23], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[22], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[21], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[20], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[19], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[18], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[17], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[16], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[15], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[14], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[13], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[12], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[11], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[10], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[9], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[8], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[7], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[6], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[5], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[4], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[3], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[2], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[1], x_std_sm_flux_ingress_0__i_ss_async_pldif_0[0] }),
		.i_ss_async_pldif_pcie_mux({ x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[79], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[78], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[77], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[76], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[75], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[74], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[73], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[72], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[71], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[70], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[69], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[68], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[67], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[66], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[65], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[64], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[63], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[62], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[61], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[60], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[59], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[58], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[57], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[56], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[55], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[54], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[53], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[52], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[51], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[50], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[49], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[48], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[47], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[46], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[45], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[44], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[43], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[42], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[41], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[40], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[39], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[38], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[37], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[36], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[35], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[34], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[33], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[32], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[31], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[30], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[29], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[28], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[27], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[26], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[25], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[24], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[23], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[22], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[21], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[20], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[19], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[18], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[17], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[16], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[15], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[14], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[13], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[12], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[11], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[10], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[9], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[8], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[7], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[6], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[5], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[4], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[3], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[2], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[1], x_std_sm_flux_ingress_0__i_ss_async_pldif_pcie_mux_0[0] }),
		.i_sync_cfg_data({ x_std_sm_flux_ingress_0__i_sync_cfg_data_0[124], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[123], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[122], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[121], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[120], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[119], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[118], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[117], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[116], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[115], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[114], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[113], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[112], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[111], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[110], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[109], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[108], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[107], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[106], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[105], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[104], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[103], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[102], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[101], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[100], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[99], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[98], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[97], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[96], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[95], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[94], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[93], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[92], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[91], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[90], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[89], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[88], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[87], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[86], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[85], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[84], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[83], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[82], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[81], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[80], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[79], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[78], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[77], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[76], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[75], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[74], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[73], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[72], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[71], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[70], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[69], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[68], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[67], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[66], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[65], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[64], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[63], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[62], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[61], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[60], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[59], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[58], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[57], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[56], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[55], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[54], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[53], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[52], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[51], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[50], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[49], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[48], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[47], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[46], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[45], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[44], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[43], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[42], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[41], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[40], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[39], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[38], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[37], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[36], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[35], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[34], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[33], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[32], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[31], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[30], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[29], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[28], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[27], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[26], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[25], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[24], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[23], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[22], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[21], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[20], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[19], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[18], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[17], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[16], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[15], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[14], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[13], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[12], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[11], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[10], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[9], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[8], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[7], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[6], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[5], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[4], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[3], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[2], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[1], x_std_sm_flux_ingress_0__i_sync_cfg_data_0[0] }),
		.i_sync_common_control({ x_std_sm_flux_ingress_0__i_sync_common_control_0[4], x_std_sm_flux_ingress_0__i_sync_common_control_0[3], x_std_sm_flux_ingress_0__i_sync_common_control_0[2], x_std_sm_flux_ingress_0__i_sync_common_control_0[1], x_std_sm_flux_ingress_0__i_sync_common_control_0[0] }),
		.i_sync_interface_control({ x_std_sm_flux_ingress_0__i_sync_interface_control_0[249], x_std_sm_flux_ingress_0__i_sync_interface_control_0[248], x_std_sm_flux_ingress_0__i_sync_interface_control_0[247], x_std_sm_flux_ingress_0__i_sync_interface_control_0[246], x_std_sm_flux_ingress_0__i_sync_interface_control_0[245], x_std_sm_flux_ingress_0__i_sync_interface_control_0[244], x_std_sm_flux_ingress_0__i_sync_interface_control_0[243], x_std_sm_flux_ingress_0__i_sync_interface_control_0[242], x_std_sm_flux_ingress_0__i_sync_interface_control_0[241], x_std_sm_flux_ingress_0__i_sync_interface_control_0[240], x_std_sm_flux_ingress_0__i_sync_interface_control_0[239], x_std_sm_flux_ingress_0__i_sync_interface_control_0[238], x_std_sm_flux_ingress_0__i_sync_interface_control_0[237], x_std_sm_flux_ingress_0__i_sync_interface_control_0[236], x_std_sm_flux_ingress_0__i_sync_interface_control_0[235], x_std_sm_flux_ingress_0__i_sync_interface_control_0[234], x_std_sm_flux_ingress_0__i_sync_interface_control_0[233], x_std_sm_flux_ingress_0__i_sync_interface_control_0[232], x_std_sm_flux_ingress_0__i_sync_interface_control_0[231], x_std_sm_flux_ingress_0__i_sync_interface_control_0[230], x_std_sm_flux_ingress_0__i_sync_interface_control_0[229], x_std_sm_flux_ingress_0__i_sync_interface_control_0[228], x_std_sm_flux_ingress_0__i_sync_interface_control_0[227], x_std_sm_flux_ingress_0__i_sync_interface_control_0[226], x_std_sm_flux_ingress_0__i_sync_interface_control_0[225], x_std_sm_flux_ingress_0__i_sync_interface_control_0[224], x_std_sm_flux_ingress_0__i_sync_interface_control_0[223], x_std_sm_flux_ingress_0__i_sync_interface_control_0[222], x_std_sm_flux_ingress_0__i_sync_interface_control_0[221], x_std_sm_flux_ingress_0__i_sync_interface_control_0[220], x_std_sm_flux_ingress_0__i_sync_interface_control_0[219], x_std_sm_flux_ingress_0__i_sync_interface_control_0[218], x_std_sm_flux_ingress_0__i_sync_interface_control_0[217], x_std_sm_flux_ingress_0__i_sync_interface_control_0[216], x_std_sm_flux_ingress_0__i_sync_interface_control_0[215], x_std_sm_flux_ingress_0__i_sync_interface_control_0[214], x_std_sm_flux_ingress_0__i_sync_interface_control_0[213], x_std_sm_flux_ingress_0__i_sync_interface_control_0[212], x_std_sm_flux_ingress_0__i_sync_interface_control_0[211], x_std_sm_flux_ingress_0__i_sync_interface_control_0[210], x_std_sm_flux_ingress_0__i_sync_interface_control_0[209], x_std_sm_flux_ingress_0__i_sync_interface_control_0[208], x_std_sm_flux_ingress_0__i_sync_interface_control_0[207], x_std_sm_flux_ingress_0__i_sync_interface_control_0[206], x_std_sm_flux_ingress_0__i_sync_interface_control_0[205], x_std_sm_flux_ingress_0__i_sync_interface_control_0[204], x_std_sm_flux_ingress_0__i_sync_interface_control_0[203], x_std_sm_flux_ingress_0__i_sync_interface_control_0[202], x_std_sm_flux_ingress_0__i_sync_interface_control_0[201], x_std_sm_flux_ingress_0__i_sync_interface_control_0[200], x_std_sm_flux_ingress_0__i_sync_interface_control_0[199], x_std_sm_flux_ingress_0__i_sync_interface_control_0[198], x_std_sm_flux_ingress_0__i_sync_interface_control_0[197], x_std_sm_flux_ingress_0__i_sync_interface_control_0[196], x_std_sm_flux_ingress_0__i_sync_interface_control_0[195], x_std_sm_flux_ingress_0__i_sync_interface_control_0[194], x_std_sm_flux_ingress_0__i_sync_interface_control_0[193], x_std_sm_flux_ingress_0__i_sync_interface_control_0[192], x_std_sm_flux_ingress_0__i_sync_interface_control_0[191], x_std_sm_flux_ingress_0__i_sync_interface_control_0[190], x_std_sm_flux_ingress_0__i_sync_interface_control_0[189], x_std_sm_flux_ingress_0__i_sync_interface_control_0[188], x_std_sm_flux_ingress_0__i_sync_interface_control_0[187], x_std_sm_flux_ingress_0__i_sync_interface_control_0[186], x_std_sm_flux_ingress_0__i_sync_interface_control_0[185], x_std_sm_flux_ingress_0__i_sync_interface_control_0[184], x_std_sm_flux_ingress_0__i_sync_interface_control_0[183], x_std_sm_flux_ingress_0__i_sync_interface_control_0[182], x_std_sm_flux_ingress_0__i_sync_interface_control_0[181], x_std_sm_flux_ingress_0__i_sync_interface_control_0[180], x_std_sm_flux_ingress_0__i_sync_interface_control_0[179], x_std_sm_flux_ingress_0__i_sync_interface_control_0[178], x_std_sm_flux_ingress_0__i_sync_interface_control_0[177], x_std_sm_flux_ingress_0__i_sync_interface_control_0[176], x_std_sm_flux_ingress_0__i_sync_interface_control_0[175], x_std_sm_flux_ingress_0__i_sync_interface_control_0[174], x_std_sm_flux_ingress_0__i_sync_interface_control_0[173], x_std_sm_flux_ingress_0__i_sync_interface_control_0[172], x_std_sm_flux_ingress_0__i_sync_interface_control_0[171], x_std_sm_flux_ingress_0__i_sync_interface_control_0[170], x_std_sm_flux_ingress_0__i_sync_interface_control_0[169], x_std_sm_flux_ingress_0__i_sync_interface_control_0[168], x_std_sm_flux_ingress_0__i_sync_interface_control_0[167], x_std_sm_flux_ingress_0__i_sync_interface_control_0[166], x_std_sm_flux_ingress_0__i_sync_interface_control_0[165], x_std_sm_flux_ingress_0__i_sync_interface_control_0[164], x_std_sm_flux_ingress_0__i_sync_interface_control_0[163], x_std_sm_flux_ingress_0__i_sync_interface_control_0[162], x_std_sm_flux_ingress_0__i_sync_interface_control_0[161], x_std_sm_flux_ingress_0__i_sync_interface_control_0[160], x_std_sm_flux_ingress_0__i_sync_interface_control_0[159], x_std_sm_flux_ingress_0__i_sync_interface_control_0[158], x_std_sm_flux_ingress_0__i_sync_interface_control_0[157], x_std_sm_flux_ingress_0__i_sync_interface_control_0[156], x_std_sm_flux_ingress_0__i_sync_interface_control_0[155], x_std_sm_flux_ingress_0__i_sync_interface_control_0[154], x_std_sm_flux_ingress_0__i_sync_interface_control_0[153], x_std_sm_flux_ingress_0__i_sync_interface_control_0[152], x_std_sm_flux_ingress_0__i_sync_interface_control_0[151], x_std_sm_flux_ingress_0__i_sync_interface_control_0[150], x_std_sm_flux_ingress_0__i_sync_interface_control_0[149], x_std_sm_flux_ingress_0__i_sync_interface_control_0[148], x_std_sm_flux_ingress_0__i_sync_interface_control_0[147], x_std_sm_flux_ingress_0__i_sync_interface_control_0[146], x_std_sm_flux_ingress_0__i_sync_interface_control_0[145], x_std_sm_flux_ingress_0__i_sync_interface_control_0[144], x_std_sm_flux_ingress_0__i_sync_interface_control_0[143], x_std_sm_flux_ingress_0__i_sync_interface_control_0[142], x_std_sm_flux_ingress_0__i_sync_interface_control_0[141], x_std_sm_flux_ingress_0__i_sync_interface_control_0[140], x_std_sm_flux_ingress_0__i_sync_interface_control_0[139], x_std_sm_flux_ingress_0__i_sync_interface_control_0[138], x_std_sm_flux_ingress_0__i_sync_interface_control_0[137], x_std_sm_flux_ingress_0__i_sync_interface_control_0[136], x_std_sm_flux_ingress_0__i_sync_interface_control_0[135], x_std_sm_flux_ingress_0__i_sync_interface_control_0[134], x_std_sm_flux_ingress_0__i_sync_interface_control_0[133], x_std_sm_flux_ingress_0__i_sync_interface_control_0[132], x_std_sm_flux_ingress_0__i_sync_interface_control_0[131], x_std_sm_flux_ingress_0__i_sync_interface_control_0[130], x_std_sm_flux_ingress_0__i_sync_interface_control_0[129], x_std_sm_flux_ingress_0__i_sync_interface_control_0[128], x_std_sm_flux_ingress_0__i_sync_interface_control_0[127], x_std_sm_flux_ingress_0__i_sync_interface_control_0[126], x_std_sm_flux_ingress_0__i_sync_interface_control_0[125], x_std_sm_flux_ingress_0__i_sync_interface_control_0[124], x_std_sm_flux_ingress_0__i_sync_interface_control_0[123], x_std_sm_flux_ingress_0__i_sync_interface_control_0[122], x_std_sm_flux_ingress_0__i_sync_interface_control_0[121], x_std_sm_flux_ingress_0__i_sync_interface_control_0[120], x_std_sm_flux_ingress_0__i_sync_interface_control_0[119], x_std_sm_flux_ingress_0__i_sync_interface_control_0[118], x_std_sm_flux_ingress_0__i_sync_interface_control_0[117], x_std_sm_flux_ingress_0__i_sync_interface_control_0[116], x_std_sm_flux_ingress_0__i_sync_interface_control_0[115], x_std_sm_flux_ingress_0__i_sync_interface_control_0[114], x_std_sm_flux_ingress_0__i_sync_interface_control_0[113], x_std_sm_flux_ingress_0__i_sync_interface_control_0[112], x_std_sm_flux_ingress_0__i_sync_interface_control_0[111], x_std_sm_flux_ingress_0__i_sync_interface_control_0[110], x_std_sm_flux_ingress_0__i_sync_interface_control_0[109], x_std_sm_flux_ingress_0__i_sync_interface_control_0[108], x_std_sm_flux_ingress_0__i_sync_interface_control_0[107], x_std_sm_flux_ingress_0__i_sync_interface_control_0[106], x_std_sm_flux_ingress_0__i_sync_interface_control_0[105], x_std_sm_flux_ingress_0__i_sync_interface_control_0[104], x_std_sm_flux_ingress_0__i_sync_interface_control_0[103], x_std_sm_flux_ingress_0__i_sync_interface_control_0[102], x_std_sm_flux_ingress_0__i_sync_interface_control_0[101], x_std_sm_flux_ingress_0__i_sync_interface_control_0[100], x_std_sm_flux_ingress_0__i_sync_interface_control_0[99], x_std_sm_flux_ingress_0__i_sync_interface_control_0[98], x_std_sm_flux_ingress_0__i_sync_interface_control_0[97], x_std_sm_flux_ingress_0__i_sync_interface_control_0[96], x_std_sm_flux_ingress_0__i_sync_interface_control_0[95], x_std_sm_flux_ingress_0__i_sync_interface_control_0[94], x_std_sm_flux_ingress_0__i_sync_interface_control_0[93], x_std_sm_flux_ingress_0__i_sync_interface_control_0[92], x_std_sm_flux_ingress_0__i_sync_interface_control_0[91], x_std_sm_flux_ingress_0__i_sync_interface_control_0[90], x_std_sm_flux_ingress_0__i_sync_interface_control_0[89], x_std_sm_flux_ingress_0__i_sync_interface_control_0[88], x_std_sm_flux_ingress_0__i_sync_interface_control_0[87], x_std_sm_flux_ingress_0__i_sync_interface_control_0[86], x_std_sm_flux_ingress_0__i_sync_interface_control_0[85], x_std_sm_flux_ingress_0__i_sync_interface_control_0[84], x_std_sm_flux_ingress_0__i_sync_interface_control_0[83], x_std_sm_flux_ingress_0__i_sync_interface_control_0[82], x_std_sm_flux_ingress_0__i_sync_interface_control_0[81], x_std_sm_flux_ingress_0__i_sync_interface_control_0[80], x_std_sm_flux_ingress_0__i_sync_interface_control_0[79], x_std_sm_flux_ingress_0__i_sync_interface_control_0[78], x_std_sm_flux_ingress_0__i_sync_interface_control_0[77], x_std_sm_flux_ingress_0__i_sync_interface_control_0[76], x_std_sm_flux_ingress_0__i_sync_interface_control_0[75], x_std_sm_flux_ingress_0__i_sync_interface_control_0[74], x_std_sm_flux_ingress_0__i_sync_interface_control_0[73], x_std_sm_flux_ingress_0__i_sync_interface_control_0[72], x_std_sm_flux_ingress_0__i_sync_interface_control_0[71], x_std_sm_flux_ingress_0__i_sync_interface_control_0[70], x_std_sm_flux_ingress_0__i_sync_interface_control_0[69], x_std_sm_flux_ingress_0__i_sync_interface_control_0[68], x_std_sm_flux_ingress_0__i_sync_interface_control_0[67], x_std_sm_flux_ingress_0__i_sync_interface_control_0[66], x_std_sm_flux_ingress_0__i_sync_interface_control_0[65], x_std_sm_flux_ingress_0__i_sync_interface_control_0[64], x_std_sm_flux_ingress_0__i_sync_interface_control_0[63], x_std_sm_flux_ingress_0__i_sync_interface_control_0[62], x_std_sm_flux_ingress_0__i_sync_interface_control_0[61], x_std_sm_flux_ingress_0__i_sync_interface_control_0[60], x_std_sm_flux_ingress_0__i_sync_interface_control_0[59], x_std_sm_flux_ingress_0__i_sync_interface_control_0[58], x_std_sm_flux_ingress_0__i_sync_interface_control_0[57], x_std_sm_flux_ingress_0__i_sync_interface_control_0[56], x_std_sm_flux_ingress_0__i_sync_interface_control_0[55], x_std_sm_flux_ingress_0__i_sync_interface_control_0[54], x_std_sm_flux_ingress_0__i_sync_interface_control_0[53], x_std_sm_flux_ingress_0__i_sync_interface_control_0[52], x_std_sm_flux_ingress_0__i_sync_interface_control_0[51], x_std_sm_flux_ingress_0__i_sync_interface_control_0[50], x_std_sm_flux_ingress_0__i_sync_interface_control_0[49], x_std_sm_flux_ingress_0__i_sync_interface_control_0[48], x_std_sm_flux_ingress_0__i_sync_interface_control_0[47], x_std_sm_flux_ingress_0__i_sync_interface_control_0[46], x_std_sm_flux_ingress_0__i_sync_interface_control_0[45], x_std_sm_flux_ingress_0__i_sync_interface_control_0[44], x_std_sm_flux_ingress_0__i_sync_interface_control_0[43], x_std_sm_flux_ingress_0__i_sync_interface_control_0[42], x_std_sm_flux_ingress_0__i_sync_interface_control_0[41], x_std_sm_flux_ingress_0__i_sync_interface_control_0[40], x_std_sm_flux_ingress_0__i_sync_interface_control_0[39], x_std_sm_flux_ingress_0__i_sync_interface_control_0[38], x_std_sm_flux_ingress_0__i_sync_interface_control_0[37], x_std_sm_flux_ingress_0__i_sync_interface_control_0[36], x_std_sm_flux_ingress_0__i_sync_interface_control_0[35], x_std_sm_flux_ingress_0__i_sync_interface_control_0[34], x_std_sm_flux_ingress_0__i_sync_interface_control_0[33], x_std_sm_flux_ingress_0__i_sync_interface_control_0[32], x_std_sm_flux_ingress_0__i_sync_interface_control_0[31], x_std_sm_flux_ingress_0__i_sync_interface_control_0[30], x_std_sm_flux_ingress_0__i_sync_interface_control_0[29], x_std_sm_flux_ingress_0__i_sync_interface_control_0[28], x_std_sm_flux_ingress_0__i_sync_interface_control_0[27], x_std_sm_flux_ingress_0__i_sync_interface_control_0[26], x_std_sm_flux_ingress_0__i_sync_interface_control_0[25], x_std_sm_flux_ingress_0__i_sync_interface_control_0[24], x_std_sm_flux_ingress_0__i_sync_interface_control_0[23], x_std_sm_flux_ingress_0__i_sync_interface_control_0[22], x_std_sm_flux_ingress_0__i_sync_interface_control_0[21], x_std_sm_flux_ingress_0__i_sync_interface_control_0[20], x_std_sm_flux_ingress_0__i_sync_interface_control_0[19], x_std_sm_flux_ingress_0__i_sync_interface_control_0[18], x_std_sm_flux_ingress_0__i_sync_interface_control_0[17], x_std_sm_flux_ingress_0__i_sync_interface_control_0[16], x_std_sm_flux_ingress_0__i_sync_interface_control_0[15], x_std_sm_flux_ingress_0__i_sync_interface_control_0[14], x_std_sm_flux_ingress_0__i_sync_interface_control_0[13], x_std_sm_flux_ingress_0__i_sync_interface_control_0[12], x_std_sm_flux_ingress_0__i_sync_interface_control_0[11], x_std_sm_flux_ingress_0__i_sync_interface_control_0[10], x_std_sm_flux_ingress_0__i_sync_interface_control_0[9], x_std_sm_flux_ingress_0__i_sync_interface_control_0[8], x_std_sm_flux_ingress_0__i_sync_interface_control_0[7], x_std_sm_flux_ingress_0__i_sync_interface_control_0[6], x_std_sm_flux_ingress_0__i_sync_interface_control_0[5], x_std_sm_flux_ingress_0__i_sync_interface_control_0[4], x_std_sm_flux_ingress_0__i_sync_interface_control_0[3], x_std_sm_flux_ingress_0__i_sync_interface_control_0[2], x_std_sm_flux_ingress_0__i_sync_interface_control_0[1], x_std_sm_flux_ingress_0__i_sync_interface_control_0[0] }),
		.i_tstbus_lane(x_std_sm_flux_ingress_0__i_tstbus_lane_1),
		.i_tx_data({ o_tx_data_3[39], o_tx_data_3[38], o_tx_data_3[37], o_tx_data_3[36], o_tx_data_3[35], o_tx_data_3[34], o_tx_data_3[33], o_tx_data_3[32], o_tx_data_3[31], o_tx_data_3[30], o_tx_data_3[29], o_tx_data_3[28], o_tx_data_3[27], o_tx_data_3[26], o_tx_data_3[25], o_tx_data_3[24], o_tx_data_3[23], o_tx_data_3[22], o_tx_data_3[21], o_tx_data_3[20], o_tx_data_3[19], o_tx_data_3[18], o_tx_data_3[17], o_tx_data_3[16], o_tx_data_3[15], o_tx_data_3[14], o_tx_data_3[13], o_tx_data_3[12], o_tx_data_3[11], o_tx_data_3[10], o_tx_data_3[9], o_tx_data_3[8], o_tx_data_3[7], o_tx_data_3[6], o_tx_data_3[5], o_tx_data_3[4], o_tx_data_3[3], o_tx_data_3[2], o_tx_data_3[1], o_tx_data_3[0] }),
		.i_tx_dl_ch_bit(o_tx_dl_ch3_bit_0),
		.i_txbeacona(x_std_sm_flux_ingress_0__i_txbeacona_1),
		.i_txclkdivrate({ x_std_sm_flux_ingress_0__i_txclkdivrate_0[2], x_std_sm_flux_ingress_0__i_txclkdivrate_0[1], x_std_sm_flux_ingress_0__i_txclkdivrate_0[0] }),
		.i_txdetectrx_reqa(x_std_sm_flux_ingress_0__i_txdetectrx_reqa_1),
		.i_txdrv_levn({ x_std_sm_flux_ingress_0__i_txdrv_levn_0[5], x_std_sm_flux_ingress_0__i_txdrv_levn_0[4], x_std_sm_flux_ingress_0__i_txdrv_levn_0[3], x_std_sm_flux_ingress_0__i_txdrv_levn_0[2], x_std_sm_flux_ingress_0__i_txdrv_levn_0[1], x_std_sm_flux_ingress_0__i_txdrv_levn_0[0] }),
		.i_txdrv_levnm1({ x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[4], x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[3], x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[2], x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[1], x_std_sm_flux_ingress_0__i_txdrv_levnm1_0[0] }),
		.i_txdrv_levnm2({ x_std_sm_flux_ingress_0__i_txdrv_levnm2_0[2], x_std_sm_flux_ingress_0__i_txdrv_levnm2_0[1], x_std_sm_flux_ingress_0__i_txdrv_levnm2_0[0] }),
		.i_txdrv_levnp1({ x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[4], x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[3], x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[2], x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[1], x_std_sm_flux_ingress_0__i_txdrv_levnp1_0[0] }),
		.i_txdrv_slew({ x_std_sm_flux_ingress_0__i_txdrv_slew_0[3], x_std_sm_flux_ingress_0__i_txdrv_slew_0[2], x_std_sm_flux_ingress_0__i_txdrv_slew_0[1], x_std_sm_flux_ingress_0__i_txdrv_slew_0[0] }),
		.i_txelecidle({ x_std_sm_flux_ingress_0__i_txelecidle_0[3], x_std_sm_flux_ingress_0__i_txelecidle_0[2], x_std_sm_flux_ingress_0__i_txelecidle_0[1], x_std_sm_flux_ingress_0__i_txelecidle_0[0] }),
		.i_txpstate({ x_std_sm_flux_ingress_0__i_txpstate_0[2], x_std_sm_flux_ingress_0__i_txpstate_0[1], x_std_sm_flux_ingress_0__i_txpstate_0[0] }),
		.i_txrate({ x_std_sm_flux_ingress_0__i_txrate_0[3], x_std_sm_flux_ingress_0__i_txrate_0[2], x_std_sm_flux_ingress_0__i_txrate_0[1], x_std_sm_flux_ingress_0__i_txrate_0[0] }),
		.i_txwidth({ x_std_sm_flux_ingress_0__i_txwidth_0[2], x_std_sm_flux_ingress_0__i_txwidth_0[1], x_std_sm_flux_ingress_0__i_txwidth_0[0] }),
		.i_ux_rxuser1_sel({ x_std_sm_flux_ingress_0__i_ux_rxuser1_sel_0[1], x_std_sm_flux_ingress_0__i_ux_rxuser1_sel_0[0] }),
		.i_ux_rxuser2_sel({ x_std_sm_flux_ingress_0__i_ux_rxuser2_sel_0[1], x_std_sm_flux_ingress_0__i_ux_rxuser2_sel_0[0] }),
		.i_ux_tx_sync_data({ o_ux_tx_ch3_sync_data_1[6], o_ux_tx_ch3_sync_data_1[5], o_ux_tx_ch3_sync_data_1[4], o_ux_tx_ch3_sync_data_1[3], o_ux_tx_ch3_sync_data_1[2], o_ux_tx_ch3_sync_data_1[1], o_ux_tx_ch3_sync_data_1[0] }),
		.i_ux_txuser1_sel({ x_std_sm_flux_ingress_0__i_ux_txuser1_sel_0[1], x_std_sm_flux_ingress_0__i_ux_txuser1_sel_0[0] }),
		.i_ux_txuser2_sel({ x_std_sm_flux_ingress_0__i_ux_txuser2_sel_0[1], x_std_sm_flux_ingress_0__i_ux_txuser2_sel_0[0] }),
		.o_dat_pcs_measlatrndtripbit(x_std_sm_flux_ingress_0__o_dat_pcs_measlatrndtripbit_1),
		.o_ft_rx_async_pulse_ch(x_std_sm_flux_ingress_0__o_ft_rx_async_pulse_ch_1),
		.o_ft_rx_sclk_sync_ch(x_std_sm_flux_ingress_0__o_ft_rx_sclk_sync_ch_1),
		.o_ft_tx_async_pulse_ch(x_std_sm_flux_ingress_0__o_ft_tx_async_pulse_ch_1),
		.o_ft_tx_sclk_sync_ch(x_std_sm_flux_ingress_0__o_ft_tx_sclk_sync_ch_1),
		.o_ick_pcs_txword(x_std_sm_flux_ingress_0__o_ick_pcs_txword_1),
		.o_ick_sclk_rx(x_std_sm_flux_ingress_0__o_ick_sclk_rx_1),
		.o_ick_sclk_tx(x_std_sm_flux_ingress_0__o_ick_sclk_tx_1),
		.o_lavmm_addr({ x_std_sm_flux_ingress_0__o_lavmm_addr_0[19], x_std_sm_flux_ingress_0__o_lavmm_addr_0[18], x_std_sm_flux_ingress_0__o_lavmm_addr_0[17], x_std_sm_flux_ingress_0__o_lavmm_addr_0[16], x_std_sm_flux_ingress_0__o_lavmm_addr_0[15], x_std_sm_flux_ingress_0__o_lavmm_addr_0[14], x_std_sm_flux_ingress_0__o_lavmm_addr_0[13], x_std_sm_flux_ingress_0__o_lavmm_addr_0[12], x_std_sm_flux_ingress_0__o_lavmm_addr_0[11], x_std_sm_flux_ingress_0__o_lavmm_addr_0[10], x_std_sm_flux_ingress_0__o_lavmm_addr_0[9], x_std_sm_flux_ingress_0__o_lavmm_addr_0[8], x_std_sm_flux_ingress_0__o_lavmm_addr_0[7], x_std_sm_flux_ingress_0__o_lavmm_addr_0[6], x_std_sm_flux_ingress_0__o_lavmm_addr_0[5], x_std_sm_flux_ingress_0__o_lavmm_addr_0[4], x_std_sm_flux_ingress_0__o_lavmm_addr_0[3], x_std_sm_flux_ingress_0__o_lavmm_addr_0[2], x_std_sm_flux_ingress_0__o_lavmm_addr_0[1], x_std_sm_flux_ingress_0__o_lavmm_addr_0[0] }),
		.o_lavmm_be({ x_std_sm_flux_ingress_0__o_lavmm_be_0[3], x_std_sm_flux_ingress_0__o_lavmm_be_0[2], x_std_sm_flux_ingress_0__o_lavmm_be_0[1], x_std_sm_flux_ingress_0__o_lavmm_be_0[0] }),
		.o_lavmm_clk(x_std_sm_flux_ingress_0__o_lavmm_clk_1),
		.o_lavmm_rdata({ x_std_sm_flux_ingress_0__o_lavmm_rdata_0[31], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[30], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[29], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[28], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[27], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[26], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[25], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[24], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[23], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[22], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[21], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[20], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[19], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[18], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[17], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[16], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[15], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[14], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[13], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[12], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[11], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[10], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[9], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[8], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[7], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[6], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[5], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[4], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[3], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[2], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[1], x_std_sm_flux_ingress_0__o_lavmm_rdata_0[0] }),
		.o_lavmm_rdata_valid(x_std_sm_flux_ingress_0__o_lavmm_rdata_valid_1),
		.o_lavmm_read(x_std_sm_flux_ingress_0__o_lavmm_read_1),
		.o_lavmm_rstn(x_std_sm_flux_ingress_0__o_lavmm_rstn_1),
		.o_lavmm_waitreq(x_std_sm_flux_ingress_0__o_lavmm_waitreq_1),
		.o_lavmm_wdata({ x_std_sm_flux_ingress_0__o_lavmm_wdata_0[31], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[30], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[29], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[28], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[27], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[26], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[25], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[24], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[23], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[22], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[21], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[20], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[19], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[18], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[17], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[16], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[15], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[14], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[13], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[12], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[11], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[10], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[9], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[8], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[7], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[6], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[5], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[4], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[3], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[2], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[1], x_std_sm_flux_ingress_0__o_lavmm_wdata_0[0] }),
		.o_lavmm_write(x_std_sm_flux_ingress_0__o_lavmm_write_1),
		.o_ock_pcs_cdrfbclk(x_std_sm_flux_ingress_0__o_ock_pcs_cdrfbclk_1),
		.o_ock_pcs_ref(x_std_sm_flux_ingress_0__o_ock_pcs_ref_1),
		.o_ock_pcs_txword(flux_ingress_u3__o_ock_pcs_txword_0),
		.o_octl_pcs_txstatus_a(x_std_sm_flux_ingress_0__o_octl_pcs_txstatus_a_1),
		.o_pcs_rxpostdiv(x_std_sm_flux_ingress_0__o_pcs_rxpostdiv_1),
		.o_pcs_rxword(flux_ingress_u3__o_pcs_rxword_0),
		.o_rst_flux0_cpi_cmn_busy(x_std_sm_flux_ingress_0__o_rst_flux0_cpi_cmn_busy_1),
		.o_rst_oflux_rx_srds_rdy(x_std_sm_flux_ingress_0__o_rst_oflux_rx_srds_rdy_1),
		.o_rst_ux_all_synthlockstatus(x_std_sm_flux_ingress_0__o_rst_ux_all_synthlockstatus_1),
		.o_rst_ux_rx_pma_rst_n(x_std_sm_flux_ingress_0__o_rst_ux_rx_pma_rst_n_1),
		.o_rst_ux_rxcdrlockstatus(x_std_sm_flux_ingress_0__o_rst_ux_rxcdrlockstatus_1),
		.o_rst_ux_tx_pma_rst_n(x_std_sm_flux_ingress_0__o_rst_ux_tx_pma_rst_n_1),
		.o_rx_data({ flux_mux_wrapper_u3__i_rx_data_0[39], flux_mux_wrapper_u3__i_rx_data_0[38], flux_mux_wrapper_u3__i_rx_data_0[37], flux_mux_wrapper_u3__i_rx_data_0[36], flux_mux_wrapper_u3__i_rx_data_0[35], flux_mux_wrapper_u3__i_rx_data_0[34], flux_mux_wrapper_u3__i_rx_data_0[33], flux_mux_wrapper_u3__i_rx_data_0[32], flux_mux_wrapper_u3__i_rx_data_0[31], flux_mux_wrapper_u3__i_rx_data_0[30], flux_mux_wrapper_u3__i_rx_data_0[29], flux_mux_wrapper_u3__i_rx_data_0[28], flux_mux_wrapper_u3__i_rx_data_0[27], flux_mux_wrapper_u3__i_rx_data_0[26], flux_mux_wrapper_u3__i_rx_data_0[25], flux_mux_wrapper_u3__i_rx_data_0[24], flux_mux_wrapper_u3__i_rx_data_0[23], flux_mux_wrapper_u3__i_rx_data_0[22], flux_mux_wrapper_u3__i_rx_data_0[21], flux_mux_wrapper_u3__i_rx_data_0[20], flux_mux_wrapper_u3__i_rx_data_0[19], flux_mux_wrapper_u3__i_rx_data_0[18], flux_mux_wrapper_u3__i_rx_data_0[17], flux_mux_wrapper_u3__i_rx_data_0[16], flux_mux_wrapper_u3__i_rx_data_0[15], flux_mux_wrapper_u3__i_rx_data_0[14], flux_mux_wrapper_u3__i_rx_data_0[13], flux_mux_wrapper_u3__i_rx_data_0[12], flux_mux_wrapper_u3__i_rx_data_0[11], flux_mux_wrapper_u3__i_rx_data_0[10], flux_mux_wrapper_u3__i_rx_data_0[9], flux_mux_wrapper_u3__i_rx_data_0[8], flux_mux_wrapper_u3__i_rx_data_0[7], flux_mux_wrapper_u3__i_rx_data_0[6], flux_mux_wrapper_u3__i_rx_data_0[5], flux_mux_wrapper_u3__i_rx_data_0[4], flux_mux_wrapper_u3__i_rx_data_0[3], flux_mux_wrapper_u3__i_rx_data_0[2], flux_mux_wrapper_u3__i_rx_data_0[1], flux_mux_wrapper_u3__i_rx_data_0[0] }),
		.o_rx_dl_ch_bit(o_rx_dl_ch3_bit_1),
		.o_rxcdrlock2dataa(x_std_sm_flux_ingress_0__o_rxcdrlock2dataa_1),
		.o_rxeq_best_eye_vala({ x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[13], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[12], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[11], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[10], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[9], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[8], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[7], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[6], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[5], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[4], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[3], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[2], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[1], x_std_sm_flux_ingress_0__o_rxeq_best_eye_vala_0[0] }),
		.o_rxeq_donea(x_std_sm_flux_ingress_0__o_rxeq_donea_1),
		.o_rxmargin_nacka(x_std_sm_flux_ingress_0__o_rxmargin_nacka_1),
		.o_rxmargin_status_gray({ x_std_sm_flux_ingress_0__o_rxmargin_status_gray_0[1], x_std_sm_flux_ingress_0__o_rxmargin_status_gray_0[0] }),
		.o_rxmargin_statusa(x_std_sm_flux_ingress_0__o_rxmargin_statusa_1),
		.o_rxsignaldetect_lfpsa(x_std_sm_flux_ingress_0__o_rxsignaldetect_lfpsa_1),
		.o_rxsignaldetecta(x_std_sm_flux_ingress_0__o_rxsignaldetecta_1),
		.o_rxstatusa(x_std_sm_flux_ingress_0__o_rxstatusa_1),
		.o_sclk_return_sel_rx(x_std_sm_flux_ingress_0__o_sclk_return_sel_rx_1),
		.o_sclk_return_sel_tx(x_std_sm_flux_ingress_0__o_sclk_return_sel_tx_1),
		.o_sm_flux_ingress({ x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[319], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[318], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[317], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[316], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[315], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[314], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[313], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[312], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[311], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[310], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[309], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[308], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[307], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[306], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[305], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[304], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[303], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[302], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[301], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[300], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[299], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[298], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[297], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[296], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[295], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[294], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[293], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[292], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[291], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[290], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[289], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[288], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[287], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[286], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[285], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[284], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[283], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[282], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[281], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[280], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[279], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[278], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[277], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[276], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[275], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[274], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[273], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[272], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[271], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[270], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[269], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[268], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[267], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[266], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[265], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[264], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[263], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[262], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[261], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[260], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[259], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[258], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[257], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[256], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[255], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[254], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[253], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[252], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[251], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[250], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[249], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[248], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[247], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[246], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[245], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[244], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[243], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[242], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[241], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[240], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[239], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[238], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[237], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[236], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[235], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[234], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[233], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[232], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[231], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[230], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[229], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[228], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[227], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[226], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[225], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[224], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[223], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[222], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[221], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[220], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[219], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[218], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[217], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[216], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[215], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[214], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[213], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[212], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[211], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[210], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[209], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[208], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[207], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[206], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[205], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[204], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[203], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[202], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[201], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[200], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[199], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[198], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[197], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[196], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[195], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[194], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[193], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[192], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[191], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[190], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[189], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[188], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[187], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[186], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[185], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[184], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[183], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[182], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[181], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[180], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[179], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[178], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[177], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[176], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[175], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[174], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[173], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[172], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[171], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[170], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[169], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[168], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[167], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[166], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[165], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[164], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[163], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[162], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[161], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[160], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[159], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[158], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[157], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[156], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[155], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[154], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[153], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[152], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[151], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[150], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[149], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[148], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[147], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[146], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[145], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[144], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[143], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[142], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[141], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[140], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[139], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[138], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[137], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[136], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[135], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[134], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[133], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[132], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[131], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[130], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[129], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[128], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[127], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[126], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[125], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[124], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[123], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[122], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[121], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[120], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[119], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[118], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[117], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[116], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[115], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[114], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[113], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[112], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[111], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[110], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[109], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[108], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[107], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[106], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[105], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[104], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[103], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[102], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[101], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[100], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[99], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[98], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[97], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[96], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[95], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[94], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[93], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[92], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[91], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[90], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[89], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[88], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[87], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[86], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[85], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[84], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[83], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[82], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[81], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[80], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[79], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[78], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[77], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[76], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[75], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[74], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[73], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[72], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[71], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[70], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[69], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[68], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[67], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[66], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[65], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[64], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[63], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[62], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[61], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[60], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[59], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[58], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[57], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[56], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[55], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[54], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[53], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[52], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[51], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[50], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[49], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[48], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[47], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[46], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[45], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[44], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[43], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[42], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[41], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[40], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[39], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[38], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[37], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[36], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[35], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[34], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[33], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[32], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[31], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[30], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[29], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[28], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[27], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[26], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[25], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[24], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[23], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[22], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[21], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[20], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[19], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[18], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[17], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[16], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[15], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[14], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[13], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[12], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[11], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[10], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[9], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[8], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[7], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[6], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[5], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[4], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[3], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[2], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[1], x_std_sm_flux_ingress_0__o_sm_flux_ingress_0[0] }),
		.o_ss_async_pldif({ x_std_sm_flux_ingress_0__o_ss_async_pldif_0[49], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[48], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[47], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[46], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[45], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[44], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[43], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[42], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[41], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[40], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[39], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[38], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[37], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[36], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[35], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[34], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[33], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[32], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[31], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[30], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[29], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[28], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[27], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[26], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[25], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[24], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[23], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[22], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[21], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[20], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[19], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[18], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[17], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[16], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[15], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[14], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[13], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[12], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[11], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[10], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[9], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[8], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[7], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[6], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[5], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[4], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[3], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[2], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[1], x_std_sm_flux_ingress_0__o_ss_async_pldif_0[0] }),
		.o_synthlcfast_postdiv(x_std_sm_flux_ingress_0__o_synthlcfast_postdiv_1),
		.o_synthlcmed_postdiv(x_std_sm_flux_ingress_0__o_synthlcmed_postdiv_1),
		.o_synthlcslow_postdiv(x_std_sm_flux_ingress_0__o_synthlcslow_postdiv_1),
		.o_tx_data({ x_std_sm_flux_ingress_0__o_tx_data_0[79], x_std_sm_flux_ingress_0__o_tx_data_0[78], x_std_sm_flux_ingress_0__o_tx_data_0[77], x_std_sm_flux_ingress_0__o_tx_data_0[76], x_std_sm_flux_ingress_0__o_tx_data_0[75], x_std_sm_flux_ingress_0__o_tx_data_0[74], x_std_sm_flux_ingress_0__o_tx_data_0[73], x_std_sm_flux_ingress_0__o_tx_data_0[72], x_std_sm_flux_ingress_0__o_tx_data_0[71], x_std_sm_flux_ingress_0__o_tx_data_0[70], x_std_sm_flux_ingress_0__o_tx_data_0[69], x_std_sm_flux_ingress_0__o_tx_data_0[68], x_std_sm_flux_ingress_0__o_tx_data_0[67], x_std_sm_flux_ingress_0__o_tx_data_0[66], x_std_sm_flux_ingress_0__o_tx_data_0[65], x_std_sm_flux_ingress_0__o_tx_data_0[64], x_std_sm_flux_ingress_0__o_tx_data_0[63], x_std_sm_flux_ingress_0__o_tx_data_0[62], x_std_sm_flux_ingress_0__o_tx_data_0[61], x_std_sm_flux_ingress_0__o_tx_data_0[60], x_std_sm_flux_ingress_0__o_tx_data_0[59], x_std_sm_flux_ingress_0__o_tx_data_0[58], x_std_sm_flux_ingress_0__o_tx_data_0[57], x_std_sm_flux_ingress_0__o_tx_data_0[56], x_std_sm_flux_ingress_0__o_tx_data_0[55], x_std_sm_flux_ingress_0__o_tx_data_0[54], x_std_sm_flux_ingress_0__o_tx_data_0[53], x_std_sm_flux_ingress_0__o_tx_data_0[52], x_std_sm_flux_ingress_0__o_tx_data_0[51], x_std_sm_flux_ingress_0__o_tx_data_0[50], x_std_sm_flux_ingress_0__o_tx_data_0[49], x_std_sm_flux_ingress_0__o_tx_data_0[48], x_std_sm_flux_ingress_0__o_tx_data_0[47], x_std_sm_flux_ingress_0__o_tx_data_0[46], x_std_sm_flux_ingress_0__o_tx_data_0[45], x_std_sm_flux_ingress_0__o_tx_data_0[44], x_std_sm_flux_ingress_0__o_tx_data_0[43], x_std_sm_flux_ingress_0__o_tx_data_0[42], x_std_sm_flux_ingress_0__o_tx_data_0[41], x_std_sm_flux_ingress_0__o_tx_data_0[40], x_std_sm_flux_ingress_0__o_tx_data_0[39], x_std_sm_flux_ingress_0__o_tx_data_0[38], x_std_sm_flux_ingress_0__o_tx_data_0[37], x_std_sm_flux_ingress_0__o_tx_data_0[36], x_std_sm_flux_ingress_0__o_tx_data_0[35], x_std_sm_flux_ingress_0__o_tx_data_0[34], x_std_sm_flux_ingress_0__o_tx_data_0[33], x_std_sm_flux_ingress_0__o_tx_data_0[32], x_std_sm_flux_ingress_0__o_tx_data_0[31], x_std_sm_flux_ingress_0__o_tx_data_0[30], x_std_sm_flux_ingress_0__o_tx_data_0[29], x_std_sm_flux_ingress_0__o_tx_data_0[28], x_std_sm_flux_ingress_0__o_tx_data_0[27], x_std_sm_flux_ingress_0__o_tx_data_0[26], x_std_sm_flux_ingress_0__o_tx_data_0[25], x_std_sm_flux_ingress_0__o_tx_data_0[24], x_std_sm_flux_ingress_0__o_tx_data_0[23], x_std_sm_flux_ingress_0__o_tx_data_0[22], x_std_sm_flux_ingress_0__o_tx_data_0[21], x_std_sm_flux_ingress_0__o_tx_data_0[20], x_std_sm_flux_ingress_0__o_tx_data_0[19], x_std_sm_flux_ingress_0__o_tx_data_0[18], x_std_sm_flux_ingress_0__o_tx_data_0[17], x_std_sm_flux_ingress_0__o_tx_data_0[16], x_std_sm_flux_ingress_0__o_tx_data_0[15], x_std_sm_flux_ingress_0__o_tx_data_0[14], x_std_sm_flux_ingress_0__o_tx_data_0[13], x_std_sm_flux_ingress_0__o_tx_data_0[12], x_std_sm_flux_ingress_0__o_tx_data_0[11], x_std_sm_flux_ingress_0__o_tx_data_0[10], x_std_sm_flux_ingress_0__o_tx_data_0[9], x_std_sm_flux_ingress_0__o_tx_data_0[8], x_std_sm_flux_ingress_0__o_tx_data_0[7], x_std_sm_flux_ingress_0__o_tx_data_0[6], x_std_sm_flux_ingress_0__o_tx_data_0[5], x_std_sm_flux_ingress_0__o_tx_data_0[4], x_std_sm_flux_ingress_0__o_tx_data_0[3], x_std_sm_flux_ingress_0__o_tx_data_0[2], x_std_sm_flux_ingress_0__o_tx_data_0[1], x_std_sm_flux_ingress_0__o_tx_data_0[0] }),
		.o_tx_dl_ch_bit(x_std_sm_flux_ingress_0__o_tx_dl_ch_bit_1),
		.o_txdetectrx_acka(x_std_sm_flux_ingress_0__o_txdetectrx_acka_1),
		.o_txdetectrx_statct(x_std_sm_flux_ingress_0__o_txdetectrx_statct_1),
		.o_txstatusa(x_std_sm_flux_ingress_0__o_txstatusa_1),
		.o_ux_rxuser1_sel({ x_std_sm_flux_ingress_0__o_ux_rxuser1_sel_0[1], x_std_sm_flux_ingress_0__o_ux_rxuser1_sel_0[0] }),
		.o_ux_rxuser2_sel({ x_std_sm_flux_ingress_0__o_ux_rxuser2_sel_0[1], x_std_sm_flux_ingress_0__o_ux_rxuser2_sel_0[0] }),
		.o_ux_tx_ch_ptr_smpl(x_std_sm_flux_ingress_0__o_ux_tx_ch_ptr_smpl_1),
		.o_ux_txlc_clk(x_std_sm_flux_ingress_0__o_ux_txlc_clk_1),
		.o_ux_txuser1_sel({ x_std_sm_flux_ingress_0__o_ux_txuser1_sel_0[1], x_std_sm_flux_ingress_0__o_ux_txuser1_sel_0[0] }),
		.o_ux_txuser2_sel({ x_std_sm_flux_ingress_0__o_ux_txuser2_sel_0[1], x_std_sm_flux_ingress_0__o_ux_txuser2_sel_0[0] }),
		.o_quartus_connection_to_serdes(o_quartus_connection_to_serdes_lane3_0),
		.i_quartus_flux_s_to_ingress(x_std_sm_flux_ingress_0__i_quartus_flux_s_to_ingress_1)
	);

	tennm_sm_xcvrif_rx_ch_clk_mux #(
		.sel(x_mux_sm_xcvrif_rx_ch_clk_mux_0__sel)
	) x_mux_sm_xcvrif_rx_ch_clk_mux_0 (
		.i_ground_clk(pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1]),
		.i_rxword_clk(o_xcvr_rxword_ch_clk_3),
		.i_sys_clk(xcvrif_tx_esys_clk_mux_u0__o_esys_ch_clk_3),
		.o_eth_rx_ch_clk(o_eth_rx_ch3_clk_4)
	);

	tennm_sm_xcvrif_tx_ch_clk_mux #(
		.sel(x_mux_sm_xcvrif_tx_ch_clk_mux_0__sel)
	) x_mux_sm_xcvrif_tx_ch_clk_mux_0 (
		.i_ground_clk(pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1]),
		.i_sys_clk(xcvrif_tx_esys_clk_mux_u0__o_esys_ch_clk_3),
		.i_txword_clk(o_xcvr_txword_ch_clk_3),
		.o_eth_tx_ch_clk(o_eth_tx_ch3_clk_4)
	);

	tennm_sm_flux_rx_rxword_clk_demux #(
		.sel(x_decoder_sm_flux_rx_rxword_clk_demux_0__sel)
	) x_decoder_sm_flux_rx_rxword_clk_demux_0 (
		.i_ock_pcs_rxword(flux_ingress_u3__o_pcs_rxword_0),
		.o_eth_rxword_clk(x_decoder_sm_flux_rx_rxword_clk_demux_0__o_eth_rxword_clk_1),
		.o_pcie_rxword_clk(x_decoder_sm_flux_rx_rxword_clk_demux_0__o_pcie_rxword_clk_1)
	);

	tennm_sm_flux_tx_txword_clk_demux #(
		.sel(x_decoder_sm_flux_tx_txword_clk_demux_0__sel)
	) x_decoder_sm_flux_tx_txword_clk_demux_0 (
		.i_ock_pcs_txword(flux_ingress_u3__o_ock_pcs_txword_0),
		.o_eth_txword_clk(x_decoder_sm_flux_tx_txword_clk_demux_0__o_eth_txword_clk_1),
		.o_pcie_txword_clk(x_decoder_sm_flux_tx_txword_clk_demux_0__o_pcie_txword_clk_1)
	);

	tennm_sm_flux_tx_txword_clk_mux #(
		.sel(x_mux_sm_flux_tx_txword_clk_mux_0__sel)
	) x_mux_sm_flux_tx_txword_clk_mux_0 (
		.i_ux_ock_pma_clk(x_mux_sm_flux_tx_txword_clk_mux_0__i_ux_ock_pma_clk_1),
		.i_xcvr_txword_clk(o_xcvr_txword_ch_clk_3),
		.o_pcs_txword(o_pcs_txword_3)
	);

	tennm_sm_flux_rx_demux #(
		.sel(x_decoder_sm_flux_rx_demux_0__sel)
	) x_decoder_sm_flux_rx_demux_0 (
		.i_rx_data({ flux_mux_wrapper_u3__i_rx_data_0[39], flux_mux_wrapper_u3__i_rx_data_0[38], flux_mux_wrapper_u3__i_rx_data_0[37], flux_mux_wrapper_u3__i_rx_data_0[36], flux_mux_wrapper_u3__i_rx_data_0[35], flux_mux_wrapper_u3__i_rx_data_0[34], flux_mux_wrapper_u3__i_rx_data_0[33], flux_mux_wrapper_u3__i_rx_data_0[32], flux_mux_wrapper_u3__i_rx_data_0[31], flux_mux_wrapper_u3__i_rx_data_0[30], flux_mux_wrapper_u3__i_rx_data_0[29], flux_mux_wrapper_u3__i_rx_data_0[28], flux_mux_wrapper_u3__i_rx_data_0[27], flux_mux_wrapper_u3__i_rx_data_0[26], flux_mux_wrapper_u3__i_rx_data_0[25], flux_mux_wrapper_u3__i_rx_data_0[24], flux_mux_wrapper_u3__i_rx_data_0[23], flux_mux_wrapper_u3__i_rx_data_0[22], flux_mux_wrapper_u3__i_rx_data_0[21], flux_mux_wrapper_u3__i_rx_data_0[20], flux_mux_wrapper_u3__i_rx_data_0[19], flux_mux_wrapper_u3__i_rx_data_0[18], flux_mux_wrapper_u3__i_rx_data_0[17], flux_mux_wrapper_u3__i_rx_data_0[16], flux_mux_wrapper_u3__i_rx_data_0[15], flux_mux_wrapper_u3__i_rx_data_0[14], flux_mux_wrapper_u3__i_rx_data_0[13], flux_mux_wrapper_u3__i_rx_data_0[12], flux_mux_wrapper_u3__i_rx_data_0[11], flux_mux_wrapper_u3__i_rx_data_0[10], flux_mux_wrapper_u3__i_rx_data_0[9], flux_mux_wrapper_u3__i_rx_data_0[8], flux_mux_wrapper_u3__i_rx_data_0[7], flux_mux_wrapper_u3__i_rx_data_0[6], flux_mux_wrapper_u3__i_rx_data_0[5], flux_mux_wrapper_u3__i_rx_data_0[4], flux_mux_wrapper_u3__i_rx_data_0[3], flux_mux_wrapper_u3__i_rx_data_0[2], flux_mux_wrapper_u3__i_rx_data_0[1], flux_mux_wrapper_u3__i_rx_data_0[0] }),
		.o_pcie_pcs({ x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[39], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[38], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[37], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[36], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[35], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[34], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[33], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[32], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[31], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[30], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[29], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[28], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[27], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[26], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[25], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[24], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[23], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[22], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[21], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[20], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[19], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[18], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[17], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[16], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[15], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[14], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[13], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[12], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[11], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[10], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[9], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[8], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[7], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[6], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[5], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[4], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[3], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[2], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[1], x_decoder_sm_flux_rx_demux_0__o_pcie_pcs_0[0] }),
		.o_xcvrif({ o_eth_rx_data_3[31], o_eth_rx_data_3[30], o_eth_rx_data_3[29], o_eth_rx_data_3[28], o_eth_rx_data_3[27], o_eth_rx_data_3[26], o_eth_rx_data_3[25], o_eth_rx_data_3[24], o_eth_rx_data_3[23], o_eth_rx_data_3[22], o_eth_rx_data_3[21], o_eth_rx_data_3[20], o_eth_rx_data_3[19], o_eth_rx_data_3[18], o_eth_rx_data_3[17], o_eth_rx_data_3[16], o_eth_rx_data_3[15], o_eth_rx_data_3[14], o_eth_rx_data_3[13], o_eth_rx_data_3[12], o_eth_rx_data_3[11], o_eth_rx_data_3[10], o_eth_rx_data_3[9], o_eth_rx_data_3[8], o_eth_rx_data_3[7], o_eth_rx_data_3[6], o_eth_rx_data_3[5], o_eth_rx_data_3[4], o_eth_rx_data_3[3], o_eth_rx_data_3[2], o_eth_rx_data_3[1], o_eth_rx_data_3[0] })
	);

	tennm_sm_flux_tx_mux #(
		.sel(x_mux_sm_flux_tx_mux_0__sel)
	) x_mux_sm_flux_tx_mux_0 (
		.i_pcie_pcs({ x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[39], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[38], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[37], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[36], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[35], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[34], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[33], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[32], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[31], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[30], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[29], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[28], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[27], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[26], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[25], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[24], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[23], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[22], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[21], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[20], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[19], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[18], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[17], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[16], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[15], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[14], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[13], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[12], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[11], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[10], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[9], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[8], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[7], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[6], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[5], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[4], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[3], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[2], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[1], x_mux_sm_flux_tx_mux_0__i_pcie_pcs_0[0] }),
		.i_xcvrif({ o_ux_tx_ch3_data_1[31], o_ux_tx_ch3_data_1[30], o_ux_tx_ch3_data_1[29], o_ux_tx_ch3_data_1[28], o_ux_tx_ch3_data_1[27], o_ux_tx_ch3_data_1[26], o_ux_tx_ch3_data_1[25], o_ux_tx_ch3_data_1[24], o_ux_tx_ch3_data_1[23], o_ux_tx_ch3_data_1[22], o_ux_tx_ch3_data_1[21], o_ux_tx_ch3_data_1[20], o_ux_tx_ch3_data_1[19], o_ux_tx_ch3_data_1[18], o_ux_tx_ch3_data_1[17], o_ux_tx_ch3_data_1[16], o_ux_tx_ch3_data_1[15], o_ux_tx_ch3_data_1[14], o_ux_tx_ch3_data_1[13], o_ux_tx_ch3_data_1[12], o_ux_tx_ch3_data_1[11], o_ux_tx_ch3_data_1[10], o_ux_tx_ch3_data_1[9], o_ux_tx_ch3_data_1[8], o_ux_tx_ch3_data_1[7], o_ux_tx_ch3_data_1[6], o_ux_tx_ch3_data_1[5], o_ux_tx_ch3_data_1[4], o_ux_tx_ch3_data_1[3], o_ux_tx_ch3_data_1[2], o_ux_tx_ch3_data_1[1], o_ux_tx_ch3_data_1[0] }),
		.o_tx_data({ o_tx_data_3[39], o_tx_data_3[38], o_tx_data_3[37], o_tx_data_3[36], o_tx_data_3[35], o_tx_data_3[34], o_tx_data_3[33], o_tx_data_3[32], o_tx_data_3[31], o_tx_data_3[30], o_tx_data_3[29], o_tx_data_3[28], o_tx_data_3[27], o_tx_data_3[26], o_tx_data_3[25], o_tx_data_3[24], o_tx_data_3[23], o_tx_data_3[22], o_tx_data_3[21], o_tx_data_3[20], o_tx_data_3[19], o_tx_data_3[18], o_tx_data_3[17], o_tx_data_3[16], o_tx_data_3[15], o_tx_data_3[14], o_tx_data_3[13], o_tx_data_3[12], o_tx_data_3[11], o_tx_data_3[10], o_tx_data_3[9], o_tx_data_3[8], o_tx_data_3[7], o_tx_data_3[6], o_tx_data_3[5], o_tx_data_3[4], o_tx_data_3[3], o_tx_data_3[2], o_tx_data_3[1], o_tx_data_3[0] })
	);

	tennm_ipfluxtop_uxtop_wrap #(
		.cdr_f_out_hz(x_std_ipfluxtop_uxtop_wrap_0__cdr_f_out_hz),
		.cdr_f_pfd_hz(x_std_ipfluxtop_uxtop_wrap_0__cdr_f_pfd_hz),
		.cdr_f_ref_hz(x_std_ipfluxtop_uxtop_wrap_0__cdr_f_ref_hz),
		.cdr_f_vco_hz(x_std_ipfluxtop_uxtop_wrap_0__cdr_f_vco_hz),
		.cdr_l_counter(x_std_ipfluxtop_uxtop_wrap_0__cdr_l_counter),
		.cdr_m_counter(x_std_ipfluxtop_uxtop_wrap_0__cdr_m_counter),
		.cdr_n_counter(x_std_ipfluxtop_uxtop_wrap_0__cdr_n_counter),
		.cdr_refclk_select(x_std_ipfluxtop_uxtop_wrap_0__cdr_refclk_select),
		.clk_debug_select_0_enable(x_std_ipfluxtop_uxtop_wrap_0__clk_debug_select_0_enable),
		.clk_debug_select_0_setting(x_std_ipfluxtop_uxtop_wrap_0__clk_debug_select_0_setting),
		.clk_debug_select_1_enable(x_std_ipfluxtop_uxtop_wrap_0__clk_debug_select_1_enable),
		.clk_debug_select_1_setting(x_std_ipfluxtop_uxtop_wrap_0__clk_debug_select_1_setting),
		.duplex_mode(x_std_ipfluxtop_uxtop_wrap_0__duplex_mode),
		.ick_tx_word_clk_hz(x_std_ipfluxtop_uxtop_wrap_0__ick_tx_word_clk_hz),
		.lane_common_ref_clk_hz(x_std_ipfluxtop_uxtop_wrap_0__lane_common_ref_clk_hz),
		.loopback_mode(x_std_ipfluxtop_uxtop_wrap_0__loopback_mode),
		.pcie_mode(x_std_ipfluxtop_uxtop_wrap_0__pcie_mode),
		.pcs_ref_clk_hz(x_std_ipfluxtop_uxtop_wrap_0__pcs_ref_clk_hz),
		.rx_adaptation_mode(x_std_ipfluxtop_uxtop_wrap_0__rx_adaptation_mode),
		.rx_cdrdivout_en(x_std_ipfluxtop_uxtop_wrap_0__rx_cdrdivout_en),
		.rx_datarate_bps(x_std_ipfluxtop_uxtop_wrap_0__rx_datarate_bps),
		.rx_en(x_std_ipfluxtop_uxtop_wrap_0__rx_en),
		.rx_eq_dfe_tap_1(x_std_ipfluxtop_uxtop_wrap_0__rx_eq_dfe_tap_1),
		.rx_eq_hf_boost(x_std_ipfluxtop_uxtop_wrap_0__rx_eq_hf_boost),
		.rx_eq_vga_gain(x_std_ipfluxtop_uxtop_wrap_0__rx_eq_vga_gain),
		.rx_external_couple_type(x_std_ipfluxtop_uxtop_wrap_0__rx_external_couple_type),
		.rx_force_cdr_ltr(x_std_ipfluxtop_uxtop_wrap_0__rx_force_cdr_ltr),
		.rx_invert_pin(x_std_ipfluxtop_uxtop_wrap_0__rx_invert_pin),
		.rx_onchip_termination_setting(x_std_ipfluxtop_uxtop_wrap_0__rx_onchip_termination_setting),
		.rx_postdiv_clk_divider(x_std_ipfluxtop_uxtop_wrap_0__rx_postdiv_clk_divider),
		.rx_postdiv_clk_en(x_std_ipfluxtop_uxtop_wrap_0__rx_postdiv_clk_en),
		.rx_postdiv_clk_fractional_en(x_std_ipfluxtop_uxtop_wrap_0__rx_postdiv_clk_fractional_en),
		.rx_postdiv_clk_hz(x_std_ipfluxtop_uxtop_wrap_0__rx_postdiv_clk_hz),
		.rx_prbs_monitor_en(x_std_ipfluxtop_uxtop_wrap_0__rx_prbs_monitor_en),
		.rx_prbs_pattern(x_std_ipfluxtop_uxtop_wrap_0__rx_prbs_pattern),
		.rx_preloaded_hardware_configs(x_std_ipfluxtop_uxtop_wrap_0__rx_preloaded_hardware_configs),
		.rx_protocol_hint(x_std_ipfluxtop_uxtop_wrap_0__rx_protocol_hint),
		.rx_sim_mode(x_std_ipfluxtop_uxtop_wrap_0__rx_sim_mode),
		.rx_termination_mode(x_std_ipfluxtop_uxtop_wrap_0__rx_termination_mode),
		.rx_width(x_std_ipfluxtop_uxtop_wrap_0__rx_width),
		.rx_word_clk_hz(x_std_ipfluxtop_uxtop_wrap_0__rx_word_clk_hz),
		.speed_grade(x_std_ipfluxtop_uxtop_wrap_0__speed_grade),
		.tx_bond_size(x_std_ipfluxtop_uxtop_wrap_0__tx_bond_size),
		.tx_bonding_category(x_std_ipfluxtop_uxtop_wrap_0__tx_bonding_category),
		.tx_datarate_bps(x_std_ipfluxtop_uxtop_wrap_0__tx_datarate_bps),
		.tx_en(x_std_ipfluxtop_uxtop_wrap_0__tx_en),
		.tx_eq_main_tap(x_std_ipfluxtop_uxtop_wrap_0__tx_eq_main_tap),
		.tx_eq_post_tap_1(x_std_ipfluxtop_uxtop_wrap_0__tx_eq_post_tap_1),
		.tx_eq_pre_tap_1(x_std_ipfluxtop_uxtop_wrap_0__tx_eq_pre_tap_1),
		.tx_eq_pre_tap_2(x_std_ipfluxtop_uxtop_wrap_0__tx_eq_pre_tap_2),
		.tx_invert_pin(x_std_ipfluxtop_uxtop_wrap_0__tx_invert_pin),
		.tx_master_pll_mode(x_std_ipfluxtop_uxtop_wrap_0__tx_master_pll_mode),
		.tx_pll_bw_sel(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_bw_sel),
		.tx_pll_f_out_hz(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_f_out_hz),
		.tx_pll_f_pfd_hz(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_f_pfd_hz),
		.tx_pll_f_ref_hz(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_f_ref_hz),
		.tx_pll_f_vco_hz(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_f_vco_hz),
		.tx_pll_fb_counter(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_fb_counter),
		.tx_pll_feed_forward_gain(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_feed_forward_gain),
		.tx_pll_k_counter(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_k_counter),
		.tx_pll_l_counter(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_l_counter),
		.tx_pll_m_counter(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_m_counter),
		.tx_pll_n_counter(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_n_counter),
		.tx_pll_postdiv_sel(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_postdiv_sel),
		.tx_pll_refclk_select(x_std_ipfluxtop_uxtop_wrap_0__tx_pll_refclk_select),
		.tx_postdiv_cdr_refclk_divider(x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_cdr_refclk_divider),
		.tx_postdiv_cdr_refclk_hz(x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_cdr_refclk_hz),
		.tx_postdiv_clk_divider(x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_clk_divider),
		.tx_postdiv_clk_fractional_en(x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_clk_fractional_en),
		.tx_postdiv_clk_hz(x_std_ipfluxtop_uxtop_wrap_0__tx_postdiv_clk_hz),
		.tx_prbs_gen_en(x_std_ipfluxtop_uxtop_wrap_0__tx_prbs_gen_en),
		.tx_prbs_pattern(x_std_ipfluxtop_uxtop_wrap_0__tx_prbs_pattern),
		.tx_preloaded_hardware_configs(x_std_ipfluxtop_uxtop_wrap_0__tx_preloaded_hardware_configs),
		.tx_protocol_hint(x_std_ipfluxtop_uxtop_wrap_0__tx_protocol_hint),
		.tx_sim_mode(x_std_ipfluxtop_uxtop_wrap_0__tx_sim_mode),
		.tx_spread_spectrum_en(x_std_ipfluxtop_uxtop_wrap_0__tx_spread_spectrum_en),
		.tx_synthdiv_out_divider(x_std_ipfluxtop_uxtop_wrap_0__tx_synthdiv_out_divider),
		.tx_synthdiv_out_hz(x_std_ipfluxtop_uxtop_wrap_0__tx_synthdiv_out_hz),
		.tx_user_clk_only_mode(x_std_ipfluxtop_uxtop_wrap_0__tx_user_clk_only_mode),
		.tx_width(x_std_ipfluxtop_uxtop_wrap_0__tx_width),
		.tx_word_clk_hz(x_std_ipfluxtop_uxtop_wrap_0__tx_word_clk_hz),
		.usb_mode(x_std_ipfluxtop_uxtop_wrap_0__usb_mode)
	) x_std_ipfluxtop_uxtop_wrap_0 (
		.iflux_xia_rx_n_l0_ux(x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_n_l0_ux_1),
		.iflux_xia_rx_p_l0_ux(x_std_ipfluxtop_uxtop_wrap_0__iflux_xia_rx_p_l0_ux_1),
		.ioack_cdrdiv_left_ux_bidir_in(x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_in_1),
		.ioack_cdrdiv_left_ux_bidir_out(x_std_ipfluxtop_uxtop_wrap_0__ioack_cdrdiv_left_ux_bidir_out_1),
		.ioack_hsref_left_p_ux_bidir_in(x_std_ipfluxtop_uxtop_wrap_0__ioack_hsref_left_p_ux_bidir_in_1),
		.ioack_ref_left_p_ux_bidir_in({ x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[5], x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[4], x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[3], x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[2], x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[1], x_std_ipfluxtop_uxtop_wrap_0__ioack_ref_left_p_ux_bidir_in_0[0] }),
		.ioack_synthdiv1_left_ux_bidir_in(x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_in_1),
		.ioack_synthdiv1_left_ux_bidir_out(x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv1_left_ux_bidir_out_1),
		.ioack_synthdiv2_left_ux_bidir_in(x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_in_1),
		.ioack_synthdiv2_left_ux_bidir_out(x_std_ipfluxtop_uxtop_wrap_0__ioack_synthdiv2_left_ux_bidir_out_1),
		.oflux_xoa_tx_n_l0_ux(x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_n_l0_ux_1),
		.oflux_xoa_tx_p_l0_ux(x_std_ipfluxtop_uxtop_wrap_0__oflux_xoa_tx_p_l0_ux_1),
		.uxwrap_bus_in({ x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[767], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[766], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[765], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[764], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[763], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[762], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[761], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[760], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[759], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[758], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[757], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[756], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[755], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[754], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[753], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[752], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[751], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[750], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[749], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[748], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[747], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[746], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[745], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[744], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[743], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[742], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[741], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[740], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[739], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[738], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[737], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[736], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[735], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[734], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[733], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[732], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[731], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[730], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[729], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[728], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[727], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[726], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[725], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[724], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[723], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[722], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[721], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[720], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[719], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[718], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[717], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[716], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[715], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[714], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[713], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[712], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[711], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[710], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[709], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[708], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[707], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[706], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[705], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[704], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[703], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[702], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[701], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[700], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[699], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[698], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[697], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[696], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[695], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[694], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[693], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[692], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[691], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[690], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[689], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[688], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[687], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[686], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[685], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[684], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[683], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[682], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[681], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[680], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[679], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[678], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[677], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[676], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[675], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[674], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[673], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[672], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[671], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[670], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[669], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[668], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[667], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[666], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[665], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[664], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[663], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[662], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[661], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[660], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[659], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[658], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[657], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[656], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[655], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[654], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[653], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[652], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[651], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[650], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[649], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[648], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[647], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[646], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[645], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[644], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[643], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[642], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[641], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[640], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[639], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[638], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[637], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[636], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[635], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[634], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[633], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[632], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[631], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[630], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[629], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[628], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[627], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[626], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[625], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[624], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[623], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[622], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[621], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[620], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[619], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[618], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[617], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[616], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[615], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[614], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[613], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[612], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[611], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[610], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[609], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[608], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[607], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[606], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[605], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[604], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[603], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[602], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[601], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[600], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[599], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[598], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[597], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[596], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[595], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[594], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[593], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[592], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[591], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[590], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[589], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[588], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[587], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[586], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[585], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[584], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[583], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[582], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[581], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[580], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[579], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[578], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[577], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[576], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[575], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[574], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[573], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[572], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[571], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[570], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[569], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[568], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[567], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[566], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[565], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[564], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[563], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[562], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[561], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[560], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[559], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[558], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[557], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[556], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[555], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[554], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[553], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[552], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[551], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[550], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[549], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[548], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[547], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[546], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[545], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[544], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[543], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[542], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[541], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[540], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[539], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[538], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[537], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[536], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[535], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[534], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[533], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[532], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[531], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[530], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[529], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[528], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[527], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[526], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[525], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[524], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[523], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[522], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[521], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[520], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[519], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[518], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[517], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[516], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[515], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[514], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[513], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[512], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[511], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[510], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[509], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[508], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[507], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[506], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[505], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[504], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[503], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[502], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[501], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[500], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[499], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[498], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[497], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[496], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[495], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[494], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[493], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[492], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[491], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[490], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[489], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[488], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[487], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[486], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[485], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[484], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[483], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[482], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[481], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[480], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[479], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[478], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[477], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[476], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[475], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[474], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[473], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[472], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[471], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[470], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[469], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[468], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[467], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[466], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[465], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[464], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[463], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[462], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[461], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[460], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[459], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[458], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[457], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[456], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[455], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[454], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[453], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[452], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[451], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[450], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[449], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[448], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[447], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[446], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[445], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[444], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[443], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[442], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[441], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[440], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[439], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[438], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[437], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[436], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[435], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[434], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[433], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[432], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[431], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[430], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[429], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[428], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[427], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[426], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[425], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[424], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[423], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[422], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[421], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[420], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[419], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[418], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[417], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[416], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[415], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[414], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[413], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[412], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[411], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[410], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[409], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[408], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[407], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[406], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[405], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[404], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[403], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[402], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[401], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[400], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[399], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[398], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[397], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[396], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[395], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[394], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[393], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[392], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[391], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[390], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[389], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[388], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[387], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[386], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[385], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[384], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[383], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[382], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[381], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[380], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[379], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[378], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[377], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[376], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[375], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[374], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[373], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[372], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[371], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[370], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[369], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[368], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[367], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[366], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[365], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[364], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[363], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[362], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[361], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[360], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[359], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[358], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[357], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[356], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[355], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[354], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[353], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[352], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[351], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[350], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[349], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[348], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[347], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[346], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[345], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[344], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[343], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[342], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[341], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[340], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[339], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[338], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[337], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[336], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[335], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[334], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[333], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[332], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[331], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[330], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[329], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[328], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[327], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[326], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[325], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[324], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[323], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[322], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[321], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[320], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[319], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[318], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[317], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[316], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[315], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[314], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[313], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[312], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[311], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[310], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[309], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[308], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[307], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[306], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[305], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[304], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[303], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[302], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[301], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[300], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[299], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[298], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[297], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[296], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[295], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[294], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[293], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[292], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[291], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[290], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[289], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[288], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[287], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[286], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[285], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[284], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[283], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[282], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[281], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[280], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[279], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[278], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[277], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[276], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[275], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[274], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[273], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[272], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[271], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[270], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[269], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[268], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[267], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[266], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[265], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[264], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[263], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[262], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[261], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[260], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[259], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[258], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[257], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[256], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[255], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[254], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[253], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[252], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[251], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[250], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[249], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[248], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[247], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[246], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[245], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[244], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[243], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[242], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[241], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[240], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[239], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[238], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[237], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[236], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[235], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[234], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[233], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[232], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[231], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[230], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[229], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[228], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[227], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[226], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[225], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[224], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[223], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[222], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[221], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[220], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[219], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[218], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[217], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[216], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[215], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[214], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[213], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[212], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[211], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[210], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[209], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[208], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[207], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[206], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[205], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[204], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[203], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[202], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[201], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[200], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[199], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[198], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[197], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[196], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[195], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[194], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[193], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[192], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[191], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[190], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[189], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[188], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[187], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[186], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[185], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[184], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[183], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[182], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[181], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[180], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[179], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[178], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[177], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[176], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[175], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[174], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[173], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[172], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[171], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[170], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[169], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[168], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[167], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[166], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[165], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[164], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[163], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[162], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[161], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[160], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[159], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[158], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[157], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[156], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[155], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[154], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[153], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[152], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[151], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[150], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[149], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[148], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[147], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[146], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[145], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[144], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[143], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[142], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[141], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[140], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[139], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[138], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[137], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[136], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[135], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[134], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[133], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[132], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[131], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[130], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[129], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[128], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[127], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[126], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[125], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[124], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[123], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[122], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[121], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[120], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[119], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[118], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[117], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[116], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[115], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[114], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[113], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[112], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[111], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[110], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[109], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[108], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[107], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[106], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[105], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[104], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[103], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[102], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[101], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[100], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[99], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[98], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[97], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[96], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[95], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[94], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[93], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[92], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[91], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[90], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[89], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[88], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[87], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[86], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[85], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[84], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[83], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[82], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[81], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[80], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[79], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[78], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[77], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[76], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[75], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[74], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[73], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[72], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[71], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[70], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[69], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[68], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[67], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[66], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[65], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[64], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[63], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[62], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[61], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[60], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[59], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[58], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[57], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[56], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[55], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[54], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[53], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[52], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[51], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[50], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[49], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[48], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[47], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[46], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[45], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[44], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[43], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[42], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[41], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[40], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[39], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[38], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[37], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[36], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[35], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[34], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[33], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[32], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[31], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[30], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[29], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[28], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[27], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[26], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[25], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[24], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[23], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[22], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[21], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[20], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[19], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[18], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[17], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[16], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[15], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[14], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[13], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[12], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[11], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[10], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[9], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[8], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[7], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[6], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[5], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[4], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[3], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[2], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[1], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_in_0[0] }),
		.uxwrap_bus_out({ x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[703], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[702], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[701], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[700], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[699], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[698], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[697], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[696], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[695], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[694], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[693], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[692], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[691], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[690], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[689], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[688], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[687], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[686], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[685], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[684], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[683], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[682], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[681], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[680], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[679], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[678], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[677], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[676], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[675], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[674], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[673], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[672], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[671], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[670], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[669], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[668], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[667], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[666], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[665], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[664], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[663], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[662], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[661], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[660], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[659], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[658], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[657], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[656], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[655], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[654], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[653], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[652], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[651], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[650], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[649], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[648], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[647], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[646], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[645], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[644], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[643], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[642], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[641], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[640], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[639], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[638], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[637], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[636], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[635], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[634], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[633], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[632], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[631], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[630], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[629], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[628], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[627], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[626], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[625], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[624], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[623], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[622], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[621], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[620], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[619], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[618], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[617], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[616], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[615], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[614], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[613], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[612], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[611], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[610], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[609], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[608], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[607], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[606], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[605], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[604], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[603], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[602], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[601], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[600], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[599], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[598], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[597], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[596], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[595], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[594], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[593], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[592], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[591], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[590], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[589], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[588], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[587], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[586], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[585], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[584], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[583], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[582], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[581], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[580], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[579], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[578], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[577], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[576], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[575], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[574], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[573], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[572], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[571], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[570], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[569], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[568], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[567], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[566], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[565], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[564], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[563], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[562], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[561], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[560], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[559], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[558], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[557], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[556], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[555], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[554], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[553], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[552], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[551], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[550], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[549], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[548], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[547], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[546], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[545], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[544], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[543], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[542], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[541], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[540], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[539], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[538], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[537], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[536], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[535], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[534], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[533], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[532], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[531], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[530], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[529], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[528], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[527], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[526], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[525], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[524], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[523], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[522], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[521], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[520], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[519], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[518], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[517], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[516], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[515], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[514], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[513], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[512], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[511], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[510], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[509], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[508], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[507], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[506], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[505], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[504], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[503], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[502], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[501], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[500], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[499], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[498], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[497], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[496], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[495], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[494], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[493], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[492], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[491], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[490], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[489], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[488], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[487], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[486], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[485], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[484], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[483], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[482], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[481], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[480], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[479], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[478], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[477], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[476], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[475], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[474], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[473], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[472], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[471], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[470], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[469], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[468], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[467], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[466], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[465], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[464], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[463], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[462], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[461], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[460], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[459], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[458], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[457], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[456], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[455], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[454], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[453], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[452], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[451], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[450], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[449], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[448], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[447], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[446], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[445], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[444], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[443], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[442], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[441], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[440], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[439], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[438], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[437], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[436], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[435], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[434], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[433], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[432], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[431], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[430], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[429], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[428], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[427], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[426], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[425], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[424], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[423], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[422], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[421], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[420], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[419], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[418], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[417], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[416], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[415], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[414], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[413], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[412], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[411], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[410], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[409], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[408], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[407], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[406], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[405], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[404], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[403], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[402], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[401], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[400], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[399], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[398], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[397], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[396], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[395], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[394], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[393], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[392], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[391], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[390], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[389], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[388], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[387], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[386], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[385], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[384], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[383], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[382], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[381], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[380], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[379], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[378], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[377], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[376], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[375], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[374], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[373], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[372], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[371], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[370], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[369], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[368], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[367], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[366], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[365], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[364], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[363], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[362], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[361], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[360], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[359], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[358], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[357], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[356], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[355], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[354], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[353], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[352], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[351], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[350], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[349], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[348], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[347], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[346], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[345], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[344], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[343], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[342], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[341], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[340], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[339], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[338], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[337], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[336], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[335], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[334], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[333], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[332], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[331], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[330], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[329], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[328], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[327], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[326], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[325], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[324], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[323], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[322], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[321], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[320], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[319], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[318], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[317], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[316], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[315], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[314], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[313], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[312], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[311], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[310], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[309], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[308], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[307], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[306], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[305], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[304], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[303], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[302], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[301], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[300], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[299], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[298], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[297], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[296], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[295], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[294], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[293], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[292], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[291], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[290], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[289], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[288], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[287], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[286], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[285], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[284], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[283], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[282], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[281], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[280], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[279], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[278], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[277], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[276], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[275], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[274], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[273], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[272], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[271], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[270], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[269], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[268], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[267], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[266], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[265], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[264], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[263], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[262], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[261], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[260], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[259], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[258], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[257], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[256], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[255], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[254], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[253], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[252], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[251], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[250], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[249], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[248], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[247], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[246], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[245], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[244], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[243], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[242], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[241], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[240], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[239], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[238], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[237], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[236], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[235], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[234], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[233], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[232], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[231], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[230], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[229], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[228], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[227], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[226], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[225], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[224], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[223], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[222], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[221], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[220], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[219], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[218], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[217], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[216], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[215], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[214], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[213], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[212], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[211], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[210], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[209], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[208], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[207], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[206], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[205], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[204], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[203], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[202], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[201], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[200], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[199], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[198], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[197], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[196], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[195], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[194], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[193], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[192], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[191], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[190], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[189], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[188], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[187], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[186], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[185], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[184], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[183], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[182], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[181], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[180], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[179], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[178], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[177], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[176], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[175], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[174], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[173], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[172], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[171], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[170], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[169], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[168], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[167], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[166], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[165], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[164], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[163], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[162], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[161], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[160], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[159], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[158], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[157], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[156], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[155], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[154], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[153], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[152], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[151], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[150], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[149], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[148], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[147], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[146], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[145], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[144], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[143], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[142], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[141], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[140], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[139], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[138], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[137], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[136], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[135], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[134], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[133], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[132], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[131], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[130], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[129], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[128], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[127], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[126], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[125], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[124], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[123], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[122], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[121], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[120], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[119], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[118], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[117], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[116], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[115], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[114], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[113], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[112], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[111], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[110], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[109], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[108], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[107], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[106], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[105], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[104], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[103], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[102], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[101], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[100], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[99], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[98], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[97], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[96], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[95], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[94], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[93], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[92], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[91], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[90], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[89], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[88], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[87], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[86], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[85], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[84], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[83], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[82], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[81], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[80], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[79], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[78], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[77], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[76], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[75], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[74], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[73], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[72], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[71], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[70], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[69], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[68], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[67], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[66], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[65], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[64], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[63], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[62], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[61], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[60], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[59], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[58], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[57], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[56], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[55], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[54], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[53], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[52], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[51], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[50], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[49], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[48], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[47], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[46], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[45], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[44], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[43], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[42], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[41], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[40], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[39], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[38], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[37], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[36], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[35], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[34], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[33], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[32], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[31], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[30], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[29], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[28], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[27], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[26], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[25], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[24], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[23], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[22], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[21], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[20], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[19], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[18], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[17], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[16], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[15], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[14], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[13], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[12], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[11], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[10], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[9], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[8], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[7], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[6], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[5], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[4], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[3], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[2], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[1], x_std_ipfluxtop_uxtop_wrap_0__uxwrap_bus_out_0[0] }),
		.quartus_connection_to_serdes(o_quartus_connection_to_serdes_lane3_0)
	);

endmodule
