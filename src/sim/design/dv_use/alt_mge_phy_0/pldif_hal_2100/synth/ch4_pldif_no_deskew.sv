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


module ch4_pldif_no_deskew #(
	parameter x_decoder_sm_pld_tx_demux_0__sel	= "SEL_UNUSED",
	parameter x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__sel	= "SEL_UNUSED",
	parameter x_mux_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0__sel	= "SEL_UNUSED",
	parameter x_mux_sm_pld_rx_mux_0__sel	= "SEL_UNUSED",
	parameter x_std_sm_hssi_pld_chnl_dp_0__dr_enabled	= "DR_ENABLED_DR_DISABLED",
	parameter x_std_sm_hssi_pld_chnl_dp_0__duplex_mode	= "DUPLEX_MODE_DUPLEX",
	parameter x_std_sm_hssi_pld_chnl_dp_0__pld_channel_identifier	= "PLD_CHANNEL_IDENTIFIER_GENERIC",
	parameter x_std_sm_hssi_pld_chnl_dp_0__rx_clkout1_divider	= "RX_CLKOUT1_DIVIDER_DIV1",
	parameter x_std_sm_hssi_pld_chnl_dp_0__rx_clkout2_divider	= "RX_CLKOUT2_DIVIDER_DIV1",
	parameter x_std_sm_hssi_pld_chnl_dp_0__rx_en	= "FALSE",
	parameter x_std_sm_hssi_pld_chnl_dp_0__rx_fifo_mode	= "RX_FIFO_MODE_PHASE_COMP",
	parameter x_std_sm_hssi_pld_chnl_dp_0__rx_fifo_width	= "RX_FIFO_WIDTH_DOUBLE_WIDTH",
	parameter x_std_sm_hssi_pld_chnl_dp_0__rx_fifo_wr_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_sm_hssi_pld_chnl_dp_0__rx_user1_clk_dynamic_mux	= "RX_USER1_CLK_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_hssi_pld_chnl_dp_0__rx_user2_clk_dynamic_mux	= "RX_USER2_CLK_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_hssi_pld_chnl_dp_0__sup_mode	= "SUP_MODE_USER_MODE",
	parameter x_std_sm_hssi_pld_chnl_dp_0__tx_clkout1_divider	= "TX_CLKOUT1_DIVIDER_DIV1",
	parameter x_std_sm_hssi_pld_chnl_dp_0__tx_clkout2_divider	= "TX_CLKOUT2_DIVIDER_DIV1",
	parameter x_std_sm_hssi_pld_chnl_dp_0__tx_en	= "FALSE",
	parameter x_std_sm_hssi_pld_chnl_dp_0__tx_fifo_mode	= "TX_FIFO_MODE_PHASE_COMP",
	parameter x_std_sm_hssi_pld_chnl_dp_0__tx_fifo_rd_clk_hz	= 36'b000000000000000000000000000000000000,
	parameter x_std_sm_hssi_pld_chnl_dp_0__tx_fifo_width	= "TX_FIFO_WIDTH_DOUBLE_WIDTH",
	parameter x_std_sm_hssi_pld_chnl_dp_0__tx_user1_clk_dynamic_mux	= "TX_USER1_CLK_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_hssi_pld_chnl_dp_0__tx_user2_clk_dynamic_mux	= "TX_USER2_CLK_DYNAMIC_MUX_UNUSED",
	parameter x_std_sm_hssi_pld_chnl_dp_0__vc_rx_pldif_wm_en	= "VC_RX_PLDIF_WM_EN_ENABLE"
)
 (
	input [11:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async,
	input [13:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async,
	input [13:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async,
	input [13:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async,
	input [20:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr,
	input [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata,
	input [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata,
	input [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata,
	input [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata,
	input [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata,
	input [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata,
	input [31:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata,
	input [31:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata,
	input [39:0] x_mux_sm_pld_rx_mux_0__i_eth,
	input [3:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be,
	input [3:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async,
	input [49:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async,
	input [79:0] x_mux_sm_pld_rx_mux_0__i_pcie,
	input [79:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata,
	input [79:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async,
	input [79:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux,
	input [99:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async,
	input [9:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct,
	input [9:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra,
	input x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_eth_or_ptp,
	input x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_pcie,
	input x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_pcie_top,
	input x_mux_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0__i_eth_or_ptp,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_valid,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_waitreq,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_valid,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_waitreq,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_valid,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_waitreq,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_valid,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_waitreq,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_valid,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_waitreq,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_valid,
	input x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_waitreq,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_dl_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_mux_select,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_flop,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_gen_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_trig_flop,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_sampling_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_dl_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_mux_select,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_flop,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_gen_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_trig_flop,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_rx_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_signal_ok,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_tx_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_read,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_rstn,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_write,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_reset_clk_row,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_rx_clk_in_row_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_tx_clk_in_row_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_rx_pld_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_tx_pld_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_ready,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_pma_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_sfrz,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_tx_pma_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_csr_ret,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_rx_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_tx_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_rx_fec_sfrz_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_tx_fec_sfrz_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_rx_xcvrif_sfrz_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_tx_xcvrif_sfrz_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_rx_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_signal_ok,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_tx_rst_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_rxdata_fifo_rd_en,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_2_r03f_rx_mac_srfz_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_3_c2f_tx_deskew_srfz_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_fifo_wr_en,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_rx_async_pulse,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_tx_async_pulse,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_direct,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_direct,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_direct,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_direct,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_direct,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_valid,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_waitreq,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_flux0_cpi_cmn_busy,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_oflux_rx_srds_rdy,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_all_synthlockstatus,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_rxstatus,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_txstatus,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlock2data,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlockstatus,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstepcs_rx_pcs_fully_aligned,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstfec_fec_rx_rdy_n,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk1_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk2_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk1_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk2_clk,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_rx_latency_pulse,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_tx_latency_pulse,
	input x_std_sm_hssi_pld_chnl_dp_0__i_ux_chnl_refclk_mux,
	output [13:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async,
	output [16:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr,
	output [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr,
	output [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr,
	output [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr,
	output [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr,
	output [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr,
	output [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr,
	output [2:0] x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel,
	output [2:0] x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel,
	output [2:0] x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel,
	output [2:0] x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel,
	output [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata,
	output [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata,
	output [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata,
	output [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata,
	output [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata,
	output [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata,
	output [31:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata,
	output [31:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata,
	output [39:0] x_decoder_sm_pld_tx_demux_0__o_eth,
	output [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be,
	output [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be,
	output [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be,
	output [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be,
	output [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be,
	output [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be,
	output [3:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async,
	output [3:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be,
	output [49:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async,
	output [6:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async,
	output [6:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async,
	output [79:0] x_decoder_sm_pld_tx_demux_0__o_pcie,
	output [79:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata,
	output [79:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async,
	output [79:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux,
	output [7:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async,
	output [99:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async,
	output [9:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct,
	output [9:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_clk,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_read,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_rstn,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_write,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_clk,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_read,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_rstn,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_write,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_clk,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_read,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_rstn,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_write,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_clk,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_read,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_rstn,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_write,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_clk,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_read,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_rstn,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_write,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_clk,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_read,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_rstn,
	output x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_write,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_dl_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_pulse,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_sample_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_sclk_sample_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_trig_sample_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_dl_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_pulse,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_sample_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_sclk_sample_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_trig_sample_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_valid,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_waitreq,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_flux0_cpi_cmn_busy,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_oflux_rx_srds_rdy,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_all_synthlockstatus,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_rxstatus,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_txstatus,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlock2data,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlockstatus,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstepcs_rx_pcs_fully_aligned,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstfec_fec_rx_rdy_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_empty,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_full,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pempty,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pfull,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_empty,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_full,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pempty,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pfull,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk1_clk,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk2_clk,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk1_clk,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk2_clk,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_chnl_refclk_mux,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_tx_ch_ptr_smpl,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_rx_latency_pulse,
	output x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_tx_latency_pulse,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_clk,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_clk,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_sync,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_rx_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_signal_ok,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_tx_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_direct,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_direct,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_direct,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_direct,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_direct,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_clk,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_read,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_rstn,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_write,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_rx_pld_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_tx_pld_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_ready,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_pma_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_sfrz,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_tx_pma_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_csr_ret,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_rx_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_tx_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_rx_fec_sfrz_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_tx_fec_sfrz_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_rx_xcvrif_sfrz_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_tx_xcvrif_sfrz_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_rx_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_signal_ok,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_tx_rst_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_2_r03f_rx_mac_srfz_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_3_c2f_tx_deskew_srfz_n,
	output x_std_sm_hssi_pld_chnl_dp_0__o_ss_t03f_sfreeze_1_tx_pcs_sfrz_n
);
	wire [11:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0;
	wire [13:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0;
	wire [13:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0;
	wire [13:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0;
	wire [13:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0;
	wire [16:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0;
	wire [19:0] o_ss_ch4_lavmm_ethe_addr_0;
	wire [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0;
	wire [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0;
	wire [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0;
	wire [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0;
	wire [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0;
	wire [19:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0;
	wire [1:0] pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0;
	wire [20:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0;
	wire [2:0] x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel_0;
	wire [2:0] x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel_0;
	wire [2:0] x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel_0;
	wire [2:0] x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel_0;
	wire [31:0] o_ss_ch4_lavmm_ethe_wdata_0;
	wire [31:0] pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0;
	wire [31:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0;
	wire [31:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0;
	wire [31:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0;
	wire [31:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0;
	wire [31:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0;
	wire [39:0] x_decoder_sm_pld_tx_demux_0__o_eth_0;
	wire [39:0] x_mux_sm_pld_rx_mux_0__i_eth_0;
	wire [3:0] o_ss_ch4_lavmm_ethe_be_0;
	wire [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0;
	wire [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0;
	wire [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0;
	wire [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0;
	wire [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0;
	wire [3:0] x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0;
	wire [3:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0;
	wire [3:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0;
	wire [3:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0;
	wire [3:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0;
	wire [49:0] x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0;
	wire [49:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0;
	wire [6:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0;
	wire [6:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0;
	wire [79:0] o_ss_tx_fifo_data_4;
	wire [79:0] pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0;
	wire [79:0] x_decoder_sm_pld_tx_demux_0__o_pcie_0;
	wire [79:0] x_mux_sm_pld_rx_mux_0__i_pcie_0;
	wire [79:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0;
	wire [79:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0;
	wire [79:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0;
	wire [79:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0;
	wire [79:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0;
	wire [79:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0;
	wire [7:0] x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0;
	wire [99:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0;
	wire [99:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0;
	wire [9:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0;
	wire [9:0] x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0;
	wire [9:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0;
	wire [9:0] x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0;
	wire n2_0;
	wire o_pld_pcie_clk_4;
	wire o_rxfifo_ss_write_clk_4;
	wire o_ss_ch4_lavmm_ethe_clk_0;
	wire o_ss_ch4_lavmm_ethe_read_0;
	wire o_ss_ch4_lavmm_ethe_rstn_0;
	wire o_ss_ch4_lavmm_ethe_write_0;
	wire o_txfifo_ss_read_clk_4;
	wire pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_valid_0;
	wire pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_waitreq_0;
	wire quartus_i_dft_hssi_scan_mode_0;
	wire s441_51_1__hssi_clk__clk;
	wire tmp;
	wire tmp_100;
	wire tmp_101;
	wire tmp_102;
	wire tmp_103;
	wire tmp_104;
	wire tmp_105;
	wire tmp_106;
	wire tmp_107;
	wire tmp_108;
	wire tmp_109;
	wire tmp_10;
	wire tmp_110;
	wire tmp_111;
	wire tmp_112;
	wire tmp_113;
	wire tmp_114;
	wire tmp_115;
	wire tmp_116;
	wire tmp_117;
	wire tmp_118;
	wire tmp_119;
	wire tmp_11;
	wire tmp_120;
	wire tmp_121;
	wire tmp_122;
	wire tmp_123;
	wire tmp_124;
	wire tmp_125;
	wire tmp_126;
	wire tmp_127;
	wire tmp_128;
	wire tmp_129;
	wire tmp_12;
	wire tmp_130;
	wire tmp_131;
	wire tmp_132;
	wire tmp_133;
	wire tmp_134;
	wire tmp_135;
	wire tmp_136;
	wire tmp_137;
	wire tmp_138;
	wire tmp_139;
	wire tmp_13;
	wire tmp_140;
	wire tmp_141;
	wire tmp_142;
	wire tmp_143;
	wire tmp_144;
	wire tmp_145;
	wire tmp_146;
	wire tmp_147;
	wire tmp_148;
	wire tmp_149;
	wire tmp_14;
	wire tmp_150;
	wire tmp_151;
	wire tmp_152;
	wire tmp_153;
	wire tmp_154;
	wire tmp_155;
	wire tmp_156;
	wire tmp_157;
	wire tmp_158;
	wire tmp_159;
	wire tmp_15;
	wire tmp_160;
	wire tmp_161;
	wire tmp_162;
	wire tmp_163;
	wire tmp_164;
	wire tmp_165;
	wire tmp_166;
	wire tmp_167;
	wire tmp_168;
	wire tmp_169;
	wire tmp_16;
	wire tmp_170;
	wire tmp_171;
	wire tmp_172;
	wire tmp_173;
	wire tmp_174;
	wire tmp_175;
	wire tmp_176;
	wire tmp_177;
	wire tmp_178;
	wire tmp_179;
	wire tmp_17;
	wire tmp_180;
	wire tmp_181;
	wire tmp_182;
	wire tmp_183;
	wire tmp_184;
	wire tmp_185;
	wire tmp_186;
	wire tmp_187;
	wire tmp_188;
	wire tmp_189;
	wire tmp_18;
	wire tmp_190;
	wire tmp_191;
	wire tmp_192;
	wire tmp_193;
	wire tmp_194;
	wire tmp_195;
	wire tmp_196;
	wire tmp_197;
	wire tmp_198;
	wire tmp_199;
	wire tmp_19;
	wire tmp_1;
	wire tmp_200;
	wire tmp_201;
	wire tmp_202;
	wire tmp_203;
	wire tmp_204;
	wire tmp_205;
	wire tmp_206;
	wire tmp_207;
	wire tmp_208;
	wire tmp_209;
	wire tmp_20;
	wire tmp_210;
	wire tmp_211;
	wire tmp_212;
	wire tmp_213;
	wire tmp_214;
	wire tmp_215;
	wire tmp_216;
	wire tmp_217;
	wire tmp_218;
	wire tmp_219;
	wire tmp_21;
	wire tmp_220;
	wire tmp_221;
	wire tmp_222;
	wire tmp_223;
	wire tmp_224;
	wire tmp_225;
	wire tmp_226;
	wire tmp_227;
	wire tmp_228;
	wire tmp_229;
	wire tmp_22;
	wire tmp_230;
	wire tmp_231;
	wire tmp_232;
	wire tmp_233;
	wire tmp_234;
	wire tmp_235;
	wire tmp_236;
	wire tmp_237;
	wire tmp_238;
	wire tmp_239;
	wire tmp_23;
	wire tmp_240;
	wire tmp_24;
	wire tmp_25;
	wire tmp_26;
	wire tmp_27;
	wire tmp_28;
	wire tmp_29;
	wire tmp_2;
	wire tmp_30;
	wire tmp_31;
	wire tmp_32;
	wire tmp_33;
	wire tmp_34;
	wire tmp_35;
	wire tmp_36;
	wire tmp_37;
	wire tmp_38;
	wire tmp_39;
	wire tmp_3;
	wire tmp_40;
	wire tmp_41;
	wire tmp_42;
	wire tmp_43;
	wire tmp_44;
	wire tmp_45;
	wire tmp_46;
	wire tmp_47;
	wire tmp_48;
	wire tmp_49;
	wire tmp_4;
	wire tmp_50;
	wire tmp_51;
	wire tmp_52;
	wire tmp_53;
	wire tmp_54;
	wire tmp_55;
	wire tmp_56;
	wire tmp_57;
	wire tmp_58;
	wire tmp_59;
	wire tmp_5;
	wire tmp_60;
	wire tmp_61;
	wire tmp_62;
	wire tmp_63;
	wire tmp_64;
	wire tmp_65;
	wire tmp_66;
	wire tmp_67;
	wire tmp_68;
	wire tmp_69;
	wire tmp_6;
	wire tmp_70;
	wire tmp_71;
	wire tmp_72;
	wire tmp_73;
	wire tmp_74;
	wire tmp_75;
	wire tmp_76;
	wire tmp_77;
	wire tmp_78;
	wire tmp_79;
	wire tmp_7;
	wire tmp_80;
	wire tmp_81;
	wire tmp_82;
	wire tmp_83;
	wire tmp_84;
	wire tmp_85;
	wire tmp_86;
	wire tmp_87;
	wire tmp_88;
	wire tmp_89;
	wire tmp_8;
	wire tmp_90;
	wire tmp_91;
	wire tmp_92;
	wire tmp_93;
	wire tmp_94;
	wire tmp_95;
	wire tmp_96;
	wire tmp_97;
	wire tmp_98;
	wire tmp_99;
	wire tmp_9;
	wire x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_eth_or_ptp_1;
	wire x_mux_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0__i_eth_or_ptp_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_valid_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_waitreq_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_valid_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_waitreq_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_valid_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_waitreq_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_valid_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_waitreq_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_valid_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_waitreq_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_valid_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_waitreq_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_clk_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_read_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_rstn_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_write_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_clk_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_read_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_rstn_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_write_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_clk_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_read_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_rstn_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_write_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_clk_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_read_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_rstn_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_write_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_clk_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_read_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_rstn_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_write_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_clk_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_read_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_rstn_1;
	wire x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_write_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_dl_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_mux_select_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_flop_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_gen_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_trig_flop_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_sampling_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_dl_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_mux_select_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_flop_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_gen_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_trig_flop_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_rx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_signal_ok_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_tx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_read_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_rstn_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_write_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_reset_clk_row_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_rx_clk_in_row_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_tx_clk_in_row_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_rx_pld_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_tx_pld_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_ready_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_pma_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_sfrz_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_tx_pma_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_csr_ret_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_rx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_tx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_rx_fec_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_tx_fec_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_rx_xcvrif_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_tx_xcvrif_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_rx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_signal_ok_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_tx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_rxdata_fifo_rd_en_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_2_r03f_rx_mac_srfz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_3_c2f_tx_deskew_srfz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_fifo_wr_en_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_rx_async_pulse_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_tx_async_pulse_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_valid_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_waitreq_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_flux0_cpi_cmn_busy_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_oflux_rx_srds_rdy_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_all_synthlockstatus_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_rxstatus_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_txstatus_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlock2data_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlockstatus_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstepcs_rx_pcs_fully_aligned_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstfec_fec_rx_rdy_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk1_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk2_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk1_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk2_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_rx_latency_pulse_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_tx_latency_pulse_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__i_ux_chnl_refclk_mux_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_dl_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_pulse_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_sample_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_sclk_sample_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_trig_sample_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_dl_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_pulse_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_sample_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_sclk_sample_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_trig_sample_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_valid_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_waitreq_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_flux0_cpi_cmn_busy_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_oflux_rx_srds_rdy_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_all_synthlockstatus_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_rxstatus_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_txstatus_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlock2data_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlockstatus_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstepcs_rx_pcs_fully_aligned_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstfec_fec_rx_rdy_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_empty_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_full_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pempty_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pfull_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_empty_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_full_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pempty_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pfull_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk1_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk2_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk1_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk2_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_chnl_refclk_mux_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_tx_ch_ptr_smpl_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_rx_latency_pulse_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_tx_latency_pulse_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_sync_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_rx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_signal_ok_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_tx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_direct_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_clk_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_read_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_rstn_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_write_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_rx_pld_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_tx_pld_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_ready_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_pma_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_sfrz_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_tx_pma_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_csr_ret_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_rx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_tx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_rx_fec_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_tx_fec_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_rx_xcvrif_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_tx_xcvrif_sfrz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_rx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_signal_ok_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_tx_rst_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_2_r03f_rx_mac_srfz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_3_c2f_tx_deskew_srfz_n_1;
	wire x_std_sm_hssi_pld_chnl_dp_0__o_ss_t03f_sfreeze_1_tx_pcs_sfrz_n_1;
	assign n2_0 = 1'b1;
	assign o_pld_pcie_clk_4 = x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_pcie;
	assign pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1] = 1'b0;
	assign quartus_i_dft_hssi_scan_mode_0 = 1'b0;
	assign s441_51_1__hssi_clk__clk = x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_pcie_top;
	assign x_decoder_sm_pld_tx_demux_0__o_eth[0] = x_decoder_sm_pld_tx_demux_0__o_eth_0[0];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[10] = x_decoder_sm_pld_tx_demux_0__o_eth_0[10];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[11] = x_decoder_sm_pld_tx_demux_0__o_eth_0[11];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[12] = x_decoder_sm_pld_tx_demux_0__o_eth_0[12];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[13] = x_decoder_sm_pld_tx_demux_0__o_eth_0[13];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[14] = x_decoder_sm_pld_tx_demux_0__o_eth_0[14];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[15] = x_decoder_sm_pld_tx_demux_0__o_eth_0[15];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[16] = x_decoder_sm_pld_tx_demux_0__o_eth_0[16];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[17] = x_decoder_sm_pld_tx_demux_0__o_eth_0[17];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[18] = x_decoder_sm_pld_tx_demux_0__o_eth_0[18];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[19] = x_decoder_sm_pld_tx_demux_0__o_eth_0[19];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[1] = x_decoder_sm_pld_tx_demux_0__o_eth_0[1];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[20] = x_decoder_sm_pld_tx_demux_0__o_eth_0[20];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[21] = x_decoder_sm_pld_tx_demux_0__o_eth_0[21];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[22] = x_decoder_sm_pld_tx_demux_0__o_eth_0[22];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[23] = x_decoder_sm_pld_tx_demux_0__o_eth_0[23];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[24] = x_decoder_sm_pld_tx_demux_0__o_eth_0[24];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[25] = x_decoder_sm_pld_tx_demux_0__o_eth_0[25];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[26] = x_decoder_sm_pld_tx_demux_0__o_eth_0[26];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[27] = x_decoder_sm_pld_tx_demux_0__o_eth_0[27];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[28] = x_decoder_sm_pld_tx_demux_0__o_eth_0[28];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[29] = x_decoder_sm_pld_tx_demux_0__o_eth_0[29];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[2] = x_decoder_sm_pld_tx_demux_0__o_eth_0[2];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[30] = x_decoder_sm_pld_tx_demux_0__o_eth_0[30];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[31] = x_decoder_sm_pld_tx_demux_0__o_eth_0[31];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[32] = x_decoder_sm_pld_tx_demux_0__o_eth_0[32];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[33] = x_decoder_sm_pld_tx_demux_0__o_eth_0[33];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[34] = x_decoder_sm_pld_tx_demux_0__o_eth_0[34];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[35] = x_decoder_sm_pld_tx_demux_0__o_eth_0[35];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[36] = x_decoder_sm_pld_tx_demux_0__o_eth_0[36];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[37] = x_decoder_sm_pld_tx_demux_0__o_eth_0[37];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[38] = x_decoder_sm_pld_tx_demux_0__o_eth_0[38];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[39] = x_decoder_sm_pld_tx_demux_0__o_eth_0[39];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[3] = x_decoder_sm_pld_tx_demux_0__o_eth_0[3];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[4] = x_decoder_sm_pld_tx_demux_0__o_eth_0[4];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[5] = x_decoder_sm_pld_tx_demux_0__o_eth_0[5];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[6] = x_decoder_sm_pld_tx_demux_0__o_eth_0[6];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[7] = x_decoder_sm_pld_tx_demux_0__o_eth_0[7];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[8] = x_decoder_sm_pld_tx_demux_0__o_eth_0[8];
	assign x_decoder_sm_pld_tx_demux_0__o_eth[9] = x_decoder_sm_pld_tx_demux_0__o_eth_0[9];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[0] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[0];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[10] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[10];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[11] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[11];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[12] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[12];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[13] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[13];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[14] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[14];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[15] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[15];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[16] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[16];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[17] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[17];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[18] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[18];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[19] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[19];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[1] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[1];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[20] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[20];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[21] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[21];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[22] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[22];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[23] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[23];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[24] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[24];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[25] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[25];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[26] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[26];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[27] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[27];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[28] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[28];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[29] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[29];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[2] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[2];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[30] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[30];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[31] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[31];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[32] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[32];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[33] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[33];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[34] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[34];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[35] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[35];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[36] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[36];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[37] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[37];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[38] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[38];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[39] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[39];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[3] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[3];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[40] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[40];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[41] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[41];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[42] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[42];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[43] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[43];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[44] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[44];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[45] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[45];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[46] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[46];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[47] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[47];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[48] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[48];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[49] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[49];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[4] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[4];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[50] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[50];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[51] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[51];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[52] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[52];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[53] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[53];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[54] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[54];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[55] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[55];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[56] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[56];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[57] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[57];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[58] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[58];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[59] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[59];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[5] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[5];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[60] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[60];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[61] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[61];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[62] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[62];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[63] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[63];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[64] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[64];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[65] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[65];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[66] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[66];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[67] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[67];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[68] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[68];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[69] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[69];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[6] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[6];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[70] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[70];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[71] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[71];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[72] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[72];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[73] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[73];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[74] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[74];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[75] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[75];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[76] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[76];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[77] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[77];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[78] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[78];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[79] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[79];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[7] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[7];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[8] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[8];
	assign x_decoder_sm_pld_tx_demux_0__o_pcie[9] = x_decoder_sm_pld_tx_demux_0__o_pcie_0[9];
	assign x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_eth_or_ptp_1 = x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_eth_or_ptp;
	assign x_mux_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0__i_eth_or_ptp_1 = x_mux_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0__i_eth_or_ptp;
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[0] = x_mux_sm_pld_rx_mux_0__i_eth[0];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[10] = x_mux_sm_pld_rx_mux_0__i_eth[10];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[11] = x_mux_sm_pld_rx_mux_0__i_eth[11];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[12] = x_mux_sm_pld_rx_mux_0__i_eth[12];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[13] = x_mux_sm_pld_rx_mux_0__i_eth[13];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[14] = x_mux_sm_pld_rx_mux_0__i_eth[14];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[15] = x_mux_sm_pld_rx_mux_0__i_eth[15];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[16] = x_mux_sm_pld_rx_mux_0__i_eth[16];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[17] = x_mux_sm_pld_rx_mux_0__i_eth[17];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[18] = x_mux_sm_pld_rx_mux_0__i_eth[18];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[19] = x_mux_sm_pld_rx_mux_0__i_eth[19];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[1] = x_mux_sm_pld_rx_mux_0__i_eth[1];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[20] = x_mux_sm_pld_rx_mux_0__i_eth[20];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[21] = x_mux_sm_pld_rx_mux_0__i_eth[21];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[22] = x_mux_sm_pld_rx_mux_0__i_eth[22];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[23] = x_mux_sm_pld_rx_mux_0__i_eth[23];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[24] = x_mux_sm_pld_rx_mux_0__i_eth[24];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[25] = x_mux_sm_pld_rx_mux_0__i_eth[25];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[26] = x_mux_sm_pld_rx_mux_0__i_eth[26];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[27] = x_mux_sm_pld_rx_mux_0__i_eth[27];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[28] = x_mux_sm_pld_rx_mux_0__i_eth[28];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[29] = x_mux_sm_pld_rx_mux_0__i_eth[29];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[2] = x_mux_sm_pld_rx_mux_0__i_eth[2];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[30] = x_mux_sm_pld_rx_mux_0__i_eth[30];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[31] = x_mux_sm_pld_rx_mux_0__i_eth[31];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[32] = x_mux_sm_pld_rx_mux_0__i_eth[32];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[33] = x_mux_sm_pld_rx_mux_0__i_eth[33];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[34] = x_mux_sm_pld_rx_mux_0__i_eth[34];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[35] = x_mux_sm_pld_rx_mux_0__i_eth[35];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[36] = x_mux_sm_pld_rx_mux_0__i_eth[36];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[37] = x_mux_sm_pld_rx_mux_0__i_eth[37];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[38] = x_mux_sm_pld_rx_mux_0__i_eth[38];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[39] = x_mux_sm_pld_rx_mux_0__i_eth[39];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[3] = x_mux_sm_pld_rx_mux_0__i_eth[3];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[4] = x_mux_sm_pld_rx_mux_0__i_eth[4];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[5] = x_mux_sm_pld_rx_mux_0__i_eth[5];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[6] = x_mux_sm_pld_rx_mux_0__i_eth[6];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[7] = x_mux_sm_pld_rx_mux_0__i_eth[7];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[8] = x_mux_sm_pld_rx_mux_0__i_eth[8];
	assign x_mux_sm_pld_rx_mux_0__i_eth_0[9] = x_mux_sm_pld_rx_mux_0__i_eth[9];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[0] = x_mux_sm_pld_rx_mux_0__i_pcie[0];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[10] = x_mux_sm_pld_rx_mux_0__i_pcie[10];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[11] = x_mux_sm_pld_rx_mux_0__i_pcie[11];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[12] = x_mux_sm_pld_rx_mux_0__i_pcie[12];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[13] = x_mux_sm_pld_rx_mux_0__i_pcie[13];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[14] = x_mux_sm_pld_rx_mux_0__i_pcie[14];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[15] = x_mux_sm_pld_rx_mux_0__i_pcie[15];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[16] = x_mux_sm_pld_rx_mux_0__i_pcie[16];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[17] = x_mux_sm_pld_rx_mux_0__i_pcie[17];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[18] = x_mux_sm_pld_rx_mux_0__i_pcie[18];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[19] = x_mux_sm_pld_rx_mux_0__i_pcie[19];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[1] = x_mux_sm_pld_rx_mux_0__i_pcie[1];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[20] = x_mux_sm_pld_rx_mux_0__i_pcie[20];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[21] = x_mux_sm_pld_rx_mux_0__i_pcie[21];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[22] = x_mux_sm_pld_rx_mux_0__i_pcie[22];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[23] = x_mux_sm_pld_rx_mux_0__i_pcie[23];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[24] = x_mux_sm_pld_rx_mux_0__i_pcie[24];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[25] = x_mux_sm_pld_rx_mux_0__i_pcie[25];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[26] = x_mux_sm_pld_rx_mux_0__i_pcie[26];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[27] = x_mux_sm_pld_rx_mux_0__i_pcie[27];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[28] = x_mux_sm_pld_rx_mux_0__i_pcie[28];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[29] = x_mux_sm_pld_rx_mux_0__i_pcie[29];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[2] = x_mux_sm_pld_rx_mux_0__i_pcie[2];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[30] = x_mux_sm_pld_rx_mux_0__i_pcie[30];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[31] = x_mux_sm_pld_rx_mux_0__i_pcie[31];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[32] = x_mux_sm_pld_rx_mux_0__i_pcie[32];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[33] = x_mux_sm_pld_rx_mux_0__i_pcie[33];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[34] = x_mux_sm_pld_rx_mux_0__i_pcie[34];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[35] = x_mux_sm_pld_rx_mux_0__i_pcie[35];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[36] = x_mux_sm_pld_rx_mux_0__i_pcie[36];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[37] = x_mux_sm_pld_rx_mux_0__i_pcie[37];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[38] = x_mux_sm_pld_rx_mux_0__i_pcie[38];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[39] = x_mux_sm_pld_rx_mux_0__i_pcie[39];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[3] = x_mux_sm_pld_rx_mux_0__i_pcie[3];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[40] = x_mux_sm_pld_rx_mux_0__i_pcie[40];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[41] = x_mux_sm_pld_rx_mux_0__i_pcie[41];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[42] = x_mux_sm_pld_rx_mux_0__i_pcie[42];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[43] = x_mux_sm_pld_rx_mux_0__i_pcie[43];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[44] = x_mux_sm_pld_rx_mux_0__i_pcie[44];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[45] = x_mux_sm_pld_rx_mux_0__i_pcie[45];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[46] = x_mux_sm_pld_rx_mux_0__i_pcie[46];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[47] = x_mux_sm_pld_rx_mux_0__i_pcie[47];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[48] = x_mux_sm_pld_rx_mux_0__i_pcie[48];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[49] = x_mux_sm_pld_rx_mux_0__i_pcie[49];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[4] = x_mux_sm_pld_rx_mux_0__i_pcie[4];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[50] = x_mux_sm_pld_rx_mux_0__i_pcie[50];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[51] = x_mux_sm_pld_rx_mux_0__i_pcie[51];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[52] = x_mux_sm_pld_rx_mux_0__i_pcie[52];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[53] = x_mux_sm_pld_rx_mux_0__i_pcie[53];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[54] = x_mux_sm_pld_rx_mux_0__i_pcie[54];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[55] = x_mux_sm_pld_rx_mux_0__i_pcie[55];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[56] = x_mux_sm_pld_rx_mux_0__i_pcie[56];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[57] = x_mux_sm_pld_rx_mux_0__i_pcie[57];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[58] = x_mux_sm_pld_rx_mux_0__i_pcie[58];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[59] = x_mux_sm_pld_rx_mux_0__i_pcie[59];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[5] = x_mux_sm_pld_rx_mux_0__i_pcie[5];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[60] = x_mux_sm_pld_rx_mux_0__i_pcie[60];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[61] = x_mux_sm_pld_rx_mux_0__i_pcie[61];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[62] = x_mux_sm_pld_rx_mux_0__i_pcie[62];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[63] = x_mux_sm_pld_rx_mux_0__i_pcie[63];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[64] = x_mux_sm_pld_rx_mux_0__i_pcie[64];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[65] = x_mux_sm_pld_rx_mux_0__i_pcie[65];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[66] = x_mux_sm_pld_rx_mux_0__i_pcie[66];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[67] = x_mux_sm_pld_rx_mux_0__i_pcie[67];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[68] = x_mux_sm_pld_rx_mux_0__i_pcie[68];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[69] = x_mux_sm_pld_rx_mux_0__i_pcie[69];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[6] = x_mux_sm_pld_rx_mux_0__i_pcie[6];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[70] = x_mux_sm_pld_rx_mux_0__i_pcie[70];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[71] = x_mux_sm_pld_rx_mux_0__i_pcie[71];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[72] = x_mux_sm_pld_rx_mux_0__i_pcie[72];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[73] = x_mux_sm_pld_rx_mux_0__i_pcie[73];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[74] = x_mux_sm_pld_rx_mux_0__i_pcie[74];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[75] = x_mux_sm_pld_rx_mux_0__i_pcie[75];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[76] = x_mux_sm_pld_rx_mux_0__i_pcie[76];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[77] = x_mux_sm_pld_rx_mux_0__i_pcie[77];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[78] = x_mux_sm_pld_rx_mux_0__i_pcie[78];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[79] = x_mux_sm_pld_rx_mux_0__i_pcie[79];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[7] = x_mux_sm_pld_rx_mux_0__i_pcie[7];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[8] = x_mux_sm_pld_rx_mux_0__i_pcie[8];
	assign x_mux_sm_pld_rx_mux_0__i_pcie_0[9] = x_mux_sm_pld_rx_mux_0__i_pcie[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[0] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[10] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[11] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[12] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[13] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[14] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[15] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[16] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[17] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[18] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[19] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[1] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[20] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[21] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[22] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[23] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[24] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[25] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[26] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[27] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[28] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[29] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[2] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[30] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[31] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[3] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[4] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[5] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[6] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[7] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[8] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[9] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_valid_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_valid;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_waitreq_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_waitreq;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[0] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[10] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[11] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[12] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[13] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[14] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[15] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[16] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[17] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[18] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[19] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[1] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[20] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[21] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[22] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[23] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[24] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[25] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[26] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[27] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[28] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[29] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[2] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[30] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[31] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[3] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[4] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[5] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[6] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[7] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[8] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[9] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_valid_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_valid;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_waitreq_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_waitreq;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[0] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[10] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[11] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[12] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[13] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[14] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[15] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[16] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[17] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[18] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[19] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[1] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[20] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[21] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[22] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[23] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[24] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[25] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[26] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[27] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[28] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[29] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[2] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[30] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[31] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[3] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[4] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[5] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[6] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[7] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[8] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[9] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_valid_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_valid;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_waitreq_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_waitreq;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[0] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[10] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[11] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[12] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[13] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[14] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[15] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[16] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[17] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[18] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[19] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[1] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[20] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[21] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[22] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[23] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[24] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[25] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[26] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[27] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[28] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[29] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[2] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[30] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[31] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[3] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[4] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[5] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[6] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[7] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[8] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[9] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_valid_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_valid;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_waitreq_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_waitreq;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[0] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[10] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[11] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[12] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[13] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[14] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[15] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[16] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[17] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[18] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[19] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[1] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[20] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[21] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[22] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[23] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[24] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[25] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[26] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[27] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[28] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[29] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[2] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[30] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[31] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[3] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[4] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[5] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[6] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[7] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[8] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[9] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_valid_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_valid;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_waitreq_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_waitreq;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[0] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[10] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[11] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[12] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[13] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[14] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[15] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[16] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[17] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[18] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[19] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[1] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[20] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[21] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[22] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[23] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[24] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[25] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[26] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[27] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[28] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[29] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[2] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[30] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[31] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[3] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[4] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[5] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[6] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[7] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[8] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[9] = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_valid_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_valid;
	assign x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_waitreq_1 = x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_waitreq;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_clk = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_clk_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_read = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_read_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_rstn = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_rstn_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[20] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[21] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[22] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[23] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[24] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[25] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[26] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[27] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[28] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[29] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[30] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[31] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_write = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_write_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_clk = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_clk_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_read = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_read_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_rstn = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_rstn_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[20] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[21] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[22] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[23] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[24] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[25] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[26] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[27] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[28] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[29] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[30] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[31] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_write = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_write_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_clk = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_clk_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_read = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_read_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_rstn = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_rstn_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[20] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[21] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[22] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[23] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[24] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[25] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[26] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[27] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[28] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[29] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[30] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[31] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_write = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_write_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_clk = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_clk_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_read = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_read_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_rstn = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_rstn_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[20] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[21] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[22] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[23] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[24] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[25] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[26] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[27] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[28] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[29] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[30] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[31] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_write = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_write_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_clk = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_clk_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_read = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_read_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_rstn = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_rstn_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[20] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[21] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[22] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[23] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[24] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[25] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[26] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[27] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[28] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[29] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[30] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[31] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_write = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_write_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_clk = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_clk_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_read = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_read_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_rstn = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_rstn_1;
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[0] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[0];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[10] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[10];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[11] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[11];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[12] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[12];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[13] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[13];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[14] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[14];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[15] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[15];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[16] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[16];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[17] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[17];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[18] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[18];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[19] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[19];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[1] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[1];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[20] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[20];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[21] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[21];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[22] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[22];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[23] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[23];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[24] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[24];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[25] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[25];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[26] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[26];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[27] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[27];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[28] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[28];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[29] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[29];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[2] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[2];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[30] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[30];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[31] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[31];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[3] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[3];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[4] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[4];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[5] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[5];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[6] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[6];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[7] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[7];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[8] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[8];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata[9] = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[9];
	assign x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_write = x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_write_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_dl_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_dl_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_mux_select_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_mux_select;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_flop_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_flop;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_gen_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_gen_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_trig_flop_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_trig_flop;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_sampling_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_sampling_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_dl_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_dl_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_mux_select_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_mux_select;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_flop_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_flop;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_gen_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_gen_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_trig_flop_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_trig_flop;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_rx_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_rx_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_signal_ok_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_signal_ok;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_tx_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_tx_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[14] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[15] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[16] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[17] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[18] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[19] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[20] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_read_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_read;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_rstn_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_rstn;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[14] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[15] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[16] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[17] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[18] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[19] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[20] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[21] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[22] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[23] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[24] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[25] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[26] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[27] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[28] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[29] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[30] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[31] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_write_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_write;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_reset_clk_row_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_reset_clk_row;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_rx_clk_in_row_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_rx_clk_in_row_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_tx_clk_in_row_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_tx_clk_in_row_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_rx_pld_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_rx_pld_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_tx_pld_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_tx_pld_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_ready_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_ready;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_pma_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_pma_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_sfrz_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_sfrz;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_tx_pma_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_tx_pma_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_csr_ret_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_csr_ret;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_rx_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_rx_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_tx_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_tx_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_rx_fec_sfrz_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_rx_fec_sfrz_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_tx_fec_sfrz_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_tx_fec_sfrz_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_rx_xcvrif_sfrz_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_rx_xcvrif_sfrz_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_tx_xcvrif_sfrz_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_tx_xcvrif_sfrz_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_rx_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_rx_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_signal_ok_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_signal_ok;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_tx_rst_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_tx_rst_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_rxdata_fifo_rd_en_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_rxdata_fifo_rd_en;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_2_r03f_rx_mac_srfz_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_2_r03f_rx_mac_srfz_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_3_c2f_tx_deskew_srfz_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_3_c2f_tx_deskew_srfz_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[14] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[15] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[16] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[17] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[18] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[19] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[20] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[21] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[22] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[23] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[24] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[25] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[26] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[27] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[28] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[29] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[30] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[31] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[32] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[33] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[34] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[35] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[36] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[37] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[38] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[39] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[40] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[41] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[42] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[43] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[44] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[45] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[46] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[47] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[48] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[49] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[50] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[50];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[51] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[51];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[52] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[52];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[53] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[53];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[54] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[54];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[55] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[55];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[56] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[56];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[57] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[57];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[58] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[58];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[59] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[59];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[60] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[60];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[61] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[61];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[62] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[62];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[63] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[63];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[64] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[64];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[65] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[65];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[66] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[66];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[67] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[67];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[68] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[68];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[69] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[69];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[70] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[70];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[71] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[71];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[72] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[72];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[73] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[73];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[74] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[74];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[75] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[75];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[76] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[76];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[77] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[77];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[78] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[78];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[79] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[79];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[14] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[15] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[16] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[17] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[18] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[19] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[20] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[21] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[22] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[23] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[24] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[25] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[26] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[27] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[28] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[29] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[30] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[31] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[32] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[33] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[34] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[35] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[36] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[37] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[38] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[39] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[40] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[41] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[42] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[43] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[44] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[45] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[46] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[47] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[48] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[49] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[50] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[50];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[51] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[51];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[52] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[52];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[53] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[53];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[54] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[54];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[55] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[55];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[56] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[56];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[57] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[57];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[58] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[58];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[59] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[59];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[60] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[60];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[61] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[61];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[62] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[62];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[63] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[63];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[64] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[64];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[65] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[65];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[66] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[66];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[67] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[67];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[68] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[68];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[69] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[69];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[70] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[70];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[71] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[71];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[72] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[72];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[73] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[73];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[74] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[74];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[75] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[75];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[76] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[76];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[77] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[77];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[78] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[78];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[79] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[79];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[80] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[80];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[81] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[81];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[82] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[82];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[83] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[83];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[84] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[84];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[85] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[85];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[86] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[86];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[87] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[87];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[88] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[88];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[89] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[89];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[90] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[90];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[91] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[91];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[92] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[92];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[93] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[93];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[94] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[94];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[95] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[95];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[96] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[96];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[97] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[97];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[98] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[98];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[99] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[99];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_fifo_wr_en_1 = x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_fifo_wr_en;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[14] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[15] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[16] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[17] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[18] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[19] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[20] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[21] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[22] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[23] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[24] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[25] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[26] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[27] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[28] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[29] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[30] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[31] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[32] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[33] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[34] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[35] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[36] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[37] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[38] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[39] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[40] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[41] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[42] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[43] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[44] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[45] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[46] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[47] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[48] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[49] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[50] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[50];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[51] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[51];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[52] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[52];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[53] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[53];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[54] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[54];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[55] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[55];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[56] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[56];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[57] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[57];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[58] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[58];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[59] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[59];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[60] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[60];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[61] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[61];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[62] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[62];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[63] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[63];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[64] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[64];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[65] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[65];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[66] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[66];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[67] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[67];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[68] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[68];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[69] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[69];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[70] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[70];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[71] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[71];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[72] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[72];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[73] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[73];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[74] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[74];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[75] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[75];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[76] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[76];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[77] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[77];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[78] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[78];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[79] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[79];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[14] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[15] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[16] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[17] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[18] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[19] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[20] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[21] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[22] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[23] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[24] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[25] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[26] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[27] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[28] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[29] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[30] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[31] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[32] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[33] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[34] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[35] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[36] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[37] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[38] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[39] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[40] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[41] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[42] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[43] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[44] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[45] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[46] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[47] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[48] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[49] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[50] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[50];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[51] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[51];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[52] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[52];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[53] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[53];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[54] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[54];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[55] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[55];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[56] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[56];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[57] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[57];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[58] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[58];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[59] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[59];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[60] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[60];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[61] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[61];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[62] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[62];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[63] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[63];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[64] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[64];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[65] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[65];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[66] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[66];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[67] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[67];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[68] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[68];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[69] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[69];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[70] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[70];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[71] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[71];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[72] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[72];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[73] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[73];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[74] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[74];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[75] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[75];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[76] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[76];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[77] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[77];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[78] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[78];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[79] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[79];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_rx_async_pulse_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_rx_async_pulse;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_tx_async_pulse_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_tx_async_pulse;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_direct_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_direct;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_direct_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_direct;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_direct_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_direct;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_direct_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_direct;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_direct_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_direct;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[14] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[15] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[16] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[17] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[18] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[19] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[20] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[21] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[22] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[23] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[24] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[25] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[26] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[27] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[28] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[29] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[30] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[31] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_valid_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_valid;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_waitreq_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_waitreq;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_flux0_cpi_cmn_busy_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_flux0_cpi_cmn_busy;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_oflux_rx_srds_rdy_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_oflux_rx_srds_rdy;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_all_synthlockstatus_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_all_synthlockstatus;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_rxstatus_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_rxstatus;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_txstatus_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_txstatus;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlock2data_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlock2data;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlockstatus_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlockstatus;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstepcs_rx_pcs_fully_aligned_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstepcs_rx_pcs_fully_aligned;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstfec_fec_rx_rdy_n_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstfec_fec_rx_rdy_n;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk1_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk1_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk2_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk2_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk1_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk1_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk2_clk_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk2_clk;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[0] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[10] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[11] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[12] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[13] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[14] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[15] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[16] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[17] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[18] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[19] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[1] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[20] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[21] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[22] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[23] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[24] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[25] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[26] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[27] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[28] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[29] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[2] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[30] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[31] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[32] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[33] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[34] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[35] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[36] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[37] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[38] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[39] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[3] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[40] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[41] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[42] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[43] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[44] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[45] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[46] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[47] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[48] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[49] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[4] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[5] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[6] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[7] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[8] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[9] = x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_rx_latency_pulse_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_rx_latency_pulse;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_tx_latency_pulse_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_tx_latency_pulse;
	assign x_std_sm_hssi_pld_chnl_dp_0__i_ux_chnl_refclk_mux_1 = x_std_sm_hssi_pld_chnl_dp_0__i_ux_chnl_refclk_mux;
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel[0] = x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel[1] = x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel[2] = x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel[0] = x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel[1] = x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel[2] = x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel[0] = x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel[1] = x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel[2] = x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel[0] = x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel[1] = x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel[2] = x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_dl_sync = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_dl_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_pulse = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_pulse_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_sample_sync = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_sample_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_sclk_sample_sync = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_sclk_sample_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_trig_sample_sync = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_trig_sample_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_dl_sync = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_dl_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_pulse = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_pulse_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_sample_sync = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_sample_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_sclk_sample_sync = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_sclk_sample_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_trig_sample_sync = x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_trig_sample_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[0] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[10] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[11] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[12] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[13] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[14] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[15] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[16] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[17] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[18] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[19] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[1] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[20] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[21] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[22] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[23] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[24] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[25] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[26] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[27] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[28] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[29] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[2] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[30] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[31] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[3] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[4] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[5] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[6] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[7] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[8] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata[9] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_valid = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_valid_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_waitreq = x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_waitreq_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_flux0_cpi_cmn_busy = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_flux0_cpi_cmn_busy_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_oflux_rx_srds_rdy = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_oflux_rx_srds_rdy_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_all_synthlockstatus = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_all_synthlockstatus_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_rxstatus = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_rxstatus_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_txstatus = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_txstatus_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlock2data = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlock2data_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlockstatus = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlockstatus_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstepcs_rx_pcs_fully_aligned = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstepcs_rx_pcs_fully_aligned_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstfec_fec_rx_rdy_n = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstfec_fec_rx_rdy_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[0] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[10] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[11] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[12] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[13] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[14] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[15] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[16] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[17] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[18] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[19] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[1] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[20] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[21] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[22] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[23] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[24] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[25] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[26] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[27] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[28] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[29] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[2] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[30] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[31] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[32] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[33] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[34] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[35] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[36] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[37] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[38] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[39] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[3] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[40] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[41] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[42] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[43] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[44] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[45] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[46] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[47] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[48] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[49] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[4] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[50] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[50];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[51] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[51];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[52] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[52];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[53] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[53];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[54] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[54];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[55] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[55];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[56] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[56];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[57] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[57];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[58] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[58];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[59] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[59];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[5] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[60] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[60];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[61] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[61];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[62] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[62];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[63] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[63];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[64] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[64];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[65] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[65];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[66] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[66];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[67] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[67];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[68] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[68];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[69] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[69];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[6] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[70] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[70];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[71] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[71];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[72] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[72];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[73] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[73];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[74] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[74];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[75] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[75];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[76] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[76];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[77] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[77];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[78] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[78];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[79] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[79];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[7] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[8] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata[9] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[0] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[10] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[11] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[12] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[13] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[14] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[15] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[16] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[17] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[18] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[19] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[1] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[20] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[21] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[22] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[23] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[24] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[25] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[26] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[27] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[28] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[29] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[2] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[30] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[31] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[32] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[33] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[34] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[35] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[36] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[37] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[38] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[39] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[3] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[40] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[41] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[42] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[43] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[44] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[45] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[46] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[47] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[48] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[49] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[4] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[50] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[50];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[51] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[51];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[52] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[52];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[53] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[53];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[54] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[54];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[55] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[55];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[56] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[56];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[57] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[57];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[58] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[58];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[59] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[59];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[5] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[60] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[60];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[61] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[61];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[62] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[62];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[63] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[63];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[64] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[64];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[65] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[65];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[66] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[66];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[67] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[67];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[68] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[68];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[69] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[69];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[6] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[70] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[70];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[71] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[71];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[72] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[72];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[73] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[73];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[74] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[74];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[75] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[75];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[76] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[76];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[77] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[77];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[78] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[78];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[79] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[79];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[7] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[80] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[80];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[81] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[81];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[82] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[82];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[83] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[83];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[84] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[84];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[85] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[85];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[86] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[86];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[87] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[87];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[88] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[88];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[89] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[89];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[8] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[90] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[90];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[91] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[91];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[92] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[92];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[93] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[93];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[94] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[94];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[95] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[95];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[96] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[96];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[97] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[97];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[98] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[98];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[99] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[99];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async[9] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[0] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[1] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[2] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[3] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[4] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[5] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[6] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[7] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[8] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct[9] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[0] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[1] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[2] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[3] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[4] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[5] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[6] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[7] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[8] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra[9] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_empty = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_empty_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_full = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_full_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pempty = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pempty_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pfull = x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pfull_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_empty = x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_empty_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_full = x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_full_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pempty = x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pempty_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pfull = x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pfull_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk1_clk = x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk1_clk_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk2_clk = x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk2_clk_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk1_clk = x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk1_clk_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk2_clk = x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk2_clk_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_chnl_refclk_mux = x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_chnl_refclk_mux_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_tx_ch_ptr_smpl = x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_tx_ch_ptr_smpl_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[0] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[10] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[11] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[12] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[13] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[14] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[15] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[16] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[17] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[18] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[19] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[1] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[20] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[21] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[22] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[23] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[24] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[25] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[26] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[27] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[28] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[29] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[2] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[30] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[31] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[32] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[33] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[34] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[35] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[36] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[37] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[38] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[39] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[3] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[40] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[41] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[42] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[43] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[44] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[45] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[46] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[47] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[48] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[49] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[4] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[5] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[6] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[7] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[8] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async[9] = x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_rx_latency_pulse = x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_rx_latency_pulse_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_tx_latency_pulse = x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_tx_latency_pulse_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_clk = x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_clk_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_sync = x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_clk = x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_clk_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_sync = x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_sync_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_rx_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_rx_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_signal_ok = x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_signal_ok_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_tx_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_tx_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_direct = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_direct_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async[4] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async[5] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async[6] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_direct = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_direct_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[10] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[11] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[12] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[13] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[4] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[5] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[6] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[7] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[8] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async[9] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_direct = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_direct_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async[4] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async[5] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async[6] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async[7] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_direct = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_direct_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async[4] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async[5] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async[6] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_direct = x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_direct_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[10] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[11] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[12] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[13] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[14] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[15] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[16] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[4] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[5] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[6] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[7] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[8] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr[9] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_clk = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_clk_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_read = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_read_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_rstn = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_rstn_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[10] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[11] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[12] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[13] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[14] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[15] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[16] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[17] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[18] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[19] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[20] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[21] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[22] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[23] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[24] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[25] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[26] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[27] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[28] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[29] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[30] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[31] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[4] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[5] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[6] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[7] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[8] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata[9] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_write = x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_write_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_rx_pld_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_rx_pld_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_tx_pld_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_tx_pld_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_ready = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_ready_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_pma_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_pma_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_sfrz = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_sfrz_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_tx_pma_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_tx_pma_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_csr_ret = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_csr_ret_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_rx_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_rx_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_tx_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_tx_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_rx_fec_sfrz_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_rx_fec_sfrz_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_tx_fec_sfrz_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_tx_fec_sfrz_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_rx_xcvrif_sfrz_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_rx_xcvrif_sfrz_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_tx_xcvrif_sfrz_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_tx_xcvrif_sfrz_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_rx_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_rx_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_signal_ok = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_signal_ok_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_tx_rst_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_tx_rst_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_2_r03f_rx_mac_srfz_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_2_r03f_rx_mac_srfz_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_3_c2f_tx_deskew_srfz_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_3_c2f_tx_deskew_srfz_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_t03f_sfreeze_1_tx_pcs_sfrz_n = x_std_sm_hssi_pld_chnl_dp_0__o_ss_t03f_sfreeze_1_tx_pcs_sfrz_n_1;
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[10] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[11] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[12] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[13] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[14] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[15] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[16] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[17] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[18] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[19] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[20] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[21] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[22] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[23] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[24] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[25] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[26] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[27] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[28] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[29] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[30] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[31] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[32] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[33] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[34] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[35] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[36] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[37] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[38] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[39] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[40] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[41] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[42] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[43] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[44] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[45] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[46] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[47] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[48] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[49] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[4] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[50] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[50];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[51] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[51];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[52] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[52];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[53] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[53];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[54] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[54];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[55] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[55];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[56] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[56];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[57] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[57];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[58] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[58];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[59] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[59];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[5] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[60] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[60];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[61] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[61];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[62] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[62];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[63] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[63];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[64] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[64];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[65] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[65];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[66] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[66];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[67] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[67];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[68] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[68];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[69] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[69];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[6] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[70] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[70];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[71] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[71];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[72] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[72];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[73] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[73];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[74] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[74];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[75] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[75];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[76] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[76];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[77] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[77];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[78] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[78];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[79] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[79];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[7] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[8] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async[9] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[9];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[0] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[0];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[10] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[10];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[11] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[11];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[12] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[12];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[13] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[13];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[14] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[14];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[15] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[15];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[16] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[16];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[17] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[17];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[18] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[18];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[19] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[19];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[1] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[1];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[20] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[20];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[21] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[21];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[22] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[22];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[23] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[23];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[24] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[24];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[25] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[25];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[26] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[26];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[27] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[27];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[28] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[28];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[29] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[29];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[2] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[2];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[30] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[30];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[31] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[31];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[32] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[32];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[33] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[33];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[34] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[34];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[35] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[35];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[36] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[36];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[37] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[37];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[38] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[38];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[39] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[39];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[3] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[3];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[40] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[40];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[41] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[41];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[42] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[42];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[43] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[43];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[44] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[44];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[45] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[45];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[46] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[46];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[47] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[47];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[48] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[48];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[49] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[49];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[4] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[4];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[50] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[50];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[51] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[51];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[52] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[52];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[53] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[53];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[54] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[54];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[55] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[55];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[56] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[56];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[57] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[57];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[58] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[58];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[59] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[59];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[5] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[5];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[60] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[60];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[61] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[61];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[62] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[62];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[63] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[63];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[64] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[64];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[65] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[65];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[66] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[66];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[67] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[67];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[68] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[68];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[69] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[69];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[6] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[6];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[70] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[70];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[71] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[71];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[72] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[72];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[73] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[73];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[74] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[74];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[75] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[75];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[76] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[76];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[77] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[77];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[78] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[78];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[79] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[79];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[7] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[7];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[8] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[8];
	assign x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux[9] = x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[9];


	tennm_sm_pld_rx_mux #(
		.sel(x_mux_sm_pld_rx_mux_0__sel)
	) x_mux_sm_pld_rx_mux_0 (
		.i_eth({ x_mux_sm_pld_rx_mux_0__i_eth_0[39], x_mux_sm_pld_rx_mux_0__i_eth_0[38], x_mux_sm_pld_rx_mux_0__i_eth_0[37], x_mux_sm_pld_rx_mux_0__i_eth_0[36], x_mux_sm_pld_rx_mux_0__i_eth_0[35], x_mux_sm_pld_rx_mux_0__i_eth_0[34], x_mux_sm_pld_rx_mux_0__i_eth_0[33], x_mux_sm_pld_rx_mux_0__i_eth_0[32], x_mux_sm_pld_rx_mux_0__i_eth_0[31], x_mux_sm_pld_rx_mux_0__i_eth_0[30], x_mux_sm_pld_rx_mux_0__i_eth_0[29], x_mux_sm_pld_rx_mux_0__i_eth_0[28], x_mux_sm_pld_rx_mux_0__i_eth_0[27], x_mux_sm_pld_rx_mux_0__i_eth_0[26], x_mux_sm_pld_rx_mux_0__i_eth_0[25], x_mux_sm_pld_rx_mux_0__i_eth_0[24], x_mux_sm_pld_rx_mux_0__i_eth_0[23], x_mux_sm_pld_rx_mux_0__i_eth_0[22], x_mux_sm_pld_rx_mux_0__i_eth_0[21], x_mux_sm_pld_rx_mux_0__i_eth_0[20], x_mux_sm_pld_rx_mux_0__i_eth_0[19], x_mux_sm_pld_rx_mux_0__i_eth_0[18], x_mux_sm_pld_rx_mux_0__i_eth_0[17], x_mux_sm_pld_rx_mux_0__i_eth_0[16], x_mux_sm_pld_rx_mux_0__i_eth_0[15], x_mux_sm_pld_rx_mux_0__i_eth_0[14], x_mux_sm_pld_rx_mux_0__i_eth_0[13], x_mux_sm_pld_rx_mux_0__i_eth_0[12], x_mux_sm_pld_rx_mux_0__i_eth_0[11], x_mux_sm_pld_rx_mux_0__i_eth_0[10], x_mux_sm_pld_rx_mux_0__i_eth_0[9], x_mux_sm_pld_rx_mux_0__i_eth_0[8], x_mux_sm_pld_rx_mux_0__i_eth_0[7], x_mux_sm_pld_rx_mux_0__i_eth_0[6], x_mux_sm_pld_rx_mux_0__i_eth_0[5], x_mux_sm_pld_rx_mux_0__i_eth_0[4], x_mux_sm_pld_rx_mux_0__i_eth_0[3], x_mux_sm_pld_rx_mux_0__i_eth_0[2], x_mux_sm_pld_rx_mux_0__i_eth_0[1], x_mux_sm_pld_rx_mux_0__i_eth_0[0] }),
		.i_pcie({ x_mux_sm_pld_rx_mux_0__i_pcie_0[79], x_mux_sm_pld_rx_mux_0__i_pcie_0[78], x_mux_sm_pld_rx_mux_0__i_pcie_0[77], x_mux_sm_pld_rx_mux_0__i_pcie_0[76], x_mux_sm_pld_rx_mux_0__i_pcie_0[75], x_mux_sm_pld_rx_mux_0__i_pcie_0[74], x_mux_sm_pld_rx_mux_0__i_pcie_0[73], x_mux_sm_pld_rx_mux_0__i_pcie_0[72], x_mux_sm_pld_rx_mux_0__i_pcie_0[71], x_mux_sm_pld_rx_mux_0__i_pcie_0[70], x_mux_sm_pld_rx_mux_0__i_pcie_0[69], x_mux_sm_pld_rx_mux_0__i_pcie_0[68], x_mux_sm_pld_rx_mux_0__i_pcie_0[67], x_mux_sm_pld_rx_mux_0__i_pcie_0[66], x_mux_sm_pld_rx_mux_0__i_pcie_0[65], x_mux_sm_pld_rx_mux_0__i_pcie_0[64], x_mux_sm_pld_rx_mux_0__i_pcie_0[63], x_mux_sm_pld_rx_mux_0__i_pcie_0[62], x_mux_sm_pld_rx_mux_0__i_pcie_0[61], x_mux_sm_pld_rx_mux_0__i_pcie_0[60], x_mux_sm_pld_rx_mux_0__i_pcie_0[59], x_mux_sm_pld_rx_mux_0__i_pcie_0[58], x_mux_sm_pld_rx_mux_0__i_pcie_0[57], x_mux_sm_pld_rx_mux_0__i_pcie_0[56], x_mux_sm_pld_rx_mux_0__i_pcie_0[55], x_mux_sm_pld_rx_mux_0__i_pcie_0[54], x_mux_sm_pld_rx_mux_0__i_pcie_0[53], x_mux_sm_pld_rx_mux_0__i_pcie_0[52], x_mux_sm_pld_rx_mux_0__i_pcie_0[51], x_mux_sm_pld_rx_mux_0__i_pcie_0[50], x_mux_sm_pld_rx_mux_0__i_pcie_0[49], x_mux_sm_pld_rx_mux_0__i_pcie_0[48], x_mux_sm_pld_rx_mux_0__i_pcie_0[47], x_mux_sm_pld_rx_mux_0__i_pcie_0[46], x_mux_sm_pld_rx_mux_0__i_pcie_0[45], x_mux_sm_pld_rx_mux_0__i_pcie_0[44], x_mux_sm_pld_rx_mux_0__i_pcie_0[43], x_mux_sm_pld_rx_mux_0__i_pcie_0[42], x_mux_sm_pld_rx_mux_0__i_pcie_0[41], x_mux_sm_pld_rx_mux_0__i_pcie_0[40], x_mux_sm_pld_rx_mux_0__i_pcie_0[39], x_mux_sm_pld_rx_mux_0__i_pcie_0[38], x_mux_sm_pld_rx_mux_0__i_pcie_0[37], x_mux_sm_pld_rx_mux_0__i_pcie_0[36], x_mux_sm_pld_rx_mux_0__i_pcie_0[35], x_mux_sm_pld_rx_mux_0__i_pcie_0[34], x_mux_sm_pld_rx_mux_0__i_pcie_0[33], x_mux_sm_pld_rx_mux_0__i_pcie_0[32], x_mux_sm_pld_rx_mux_0__i_pcie_0[31], x_mux_sm_pld_rx_mux_0__i_pcie_0[30], x_mux_sm_pld_rx_mux_0__i_pcie_0[29], x_mux_sm_pld_rx_mux_0__i_pcie_0[28], x_mux_sm_pld_rx_mux_0__i_pcie_0[27], x_mux_sm_pld_rx_mux_0__i_pcie_0[26], x_mux_sm_pld_rx_mux_0__i_pcie_0[25], x_mux_sm_pld_rx_mux_0__i_pcie_0[24], x_mux_sm_pld_rx_mux_0__i_pcie_0[23], x_mux_sm_pld_rx_mux_0__i_pcie_0[22], x_mux_sm_pld_rx_mux_0__i_pcie_0[21], x_mux_sm_pld_rx_mux_0__i_pcie_0[20], x_mux_sm_pld_rx_mux_0__i_pcie_0[19], x_mux_sm_pld_rx_mux_0__i_pcie_0[18], x_mux_sm_pld_rx_mux_0__i_pcie_0[17], x_mux_sm_pld_rx_mux_0__i_pcie_0[16], x_mux_sm_pld_rx_mux_0__i_pcie_0[15], x_mux_sm_pld_rx_mux_0__i_pcie_0[14], x_mux_sm_pld_rx_mux_0__i_pcie_0[13], x_mux_sm_pld_rx_mux_0__i_pcie_0[12], x_mux_sm_pld_rx_mux_0__i_pcie_0[11], x_mux_sm_pld_rx_mux_0__i_pcie_0[10], x_mux_sm_pld_rx_mux_0__i_pcie_0[9], x_mux_sm_pld_rx_mux_0__i_pcie_0[8], x_mux_sm_pld_rx_mux_0__i_pcie_0[7], x_mux_sm_pld_rx_mux_0__i_pcie_0[6], x_mux_sm_pld_rx_mux_0__i_pcie_0[5], x_mux_sm_pld_rx_mux_0__i_pcie_0[4], x_mux_sm_pld_rx_mux_0__i_pcie_0[3], x_mux_sm_pld_rx_mux_0__i_pcie_0[2], x_mux_sm_pld_rx_mux_0__i_pcie_0[1], x_mux_sm_pld_rx_mux_0__i_pcie_0[0] }),
		.i_pcie_bond({ quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0 }),
		.o_rx_data({ pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[79], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[78], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[77], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[76], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[75], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[74], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[73], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[72], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[71], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[70], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[69], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[68], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[67], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[66], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[65], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[64], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[63], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[62], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[61], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[60], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[59], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[58], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[57], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[56], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[55], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[54], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[53], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[52], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[51], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[50], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[49], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[48], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[47], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[46], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[45], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[44], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[43], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[42], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[41], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[40], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[39], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[38], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[37], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[36], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[35], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[34], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[33], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[32], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[31], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[30], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[29], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[28], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[27], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[26], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[25], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[24], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[23], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[22], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[21], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[20], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[19], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[18], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[17], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[16], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[15], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[14], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[13], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[12], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[11], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[10], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[9], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[8], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[7], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[6], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[5], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[4], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[3], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[2], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[1], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[0] })
	);

	tennm_sm_pld_tx_demux #(
		.sel(x_decoder_sm_pld_tx_demux_0__sel)
	) x_decoder_sm_pld_tx_demux_0 (
		.i_ss_tx_fifo_rd_empty(),
		.i_ss_tx_fifo_rd_pempty(),
		.i_tx_data({ o_ss_tx_fifo_data_4[79], o_ss_tx_fifo_data_4[78], o_ss_tx_fifo_data_4[77], o_ss_tx_fifo_data_4[76], o_ss_tx_fifo_data_4[75], o_ss_tx_fifo_data_4[74], o_ss_tx_fifo_data_4[73], o_ss_tx_fifo_data_4[72], o_ss_tx_fifo_data_4[71], o_ss_tx_fifo_data_4[70], o_ss_tx_fifo_data_4[69], o_ss_tx_fifo_data_4[68], o_ss_tx_fifo_data_4[67], o_ss_tx_fifo_data_4[66], o_ss_tx_fifo_data_4[65], o_ss_tx_fifo_data_4[64], o_ss_tx_fifo_data_4[63], o_ss_tx_fifo_data_4[62], o_ss_tx_fifo_data_4[61], o_ss_tx_fifo_data_4[60], o_ss_tx_fifo_data_4[59], o_ss_tx_fifo_data_4[58], o_ss_tx_fifo_data_4[57], o_ss_tx_fifo_data_4[56], o_ss_tx_fifo_data_4[55], o_ss_tx_fifo_data_4[54], o_ss_tx_fifo_data_4[53], o_ss_tx_fifo_data_4[52], o_ss_tx_fifo_data_4[51], o_ss_tx_fifo_data_4[50], o_ss_tx_fifo_data_4[49], o_ss_tx_fifo_data_4[48], o_ss_tx_fifo_data_4[47], o_ss_tx_fifo_data_4[46], o_ss_tx_fifo_data_4[45], o_ss_tx_fifo_data_4[44], o_ss_tx_fifo_data_4[43], o_ss_tx_fifo_data_4[42], o_ss_tx_fifo_data_4[41], o_ss_tx_fifo_data_4[40], o_ss_tx_fifo_data_4[39], o_ss_tx_fifo_data_4[38], o_ss_tx_fifo_data_4[37], o_ss_tx_fifo_data_4[36], o_ss_tx_fifo_data_4[35], o_ss_tx_fifo_data_4[34], o_ss_tx_fifo_data_4[33], o_ss_tx_fifo_data_4[32], o_ss_tx_fifo_data_4[31], o_ss_tx_fifo_data_4[30], o_ss_tx_fifo_data_4[29], o_ss_tx_fifo_data_4[28], o_ss_tx_fifo_data_4[27], o_ss_tx_fifo_data_4[26], o_ss_tx_fifo_data_4[25], o_ss_tx_fifo_data_4[24], o_ss_tx_fifo_data_4[23], o_ss_tx_fifo_data_4[22], o_ss_tx_fifo_data_4[21], o_ss_tx_fifo_data_4[20], o_ss_tx_fifo_data_4[19], o_ss_tx_fifo_data_4[18], o_ss_tx_fifo_data_4[17], o_ss_tx_fifo_data_4[16], o_ss_tx_fifo_data_4[15], o_ss_tx_fifo_data_4[14], o_ss_tx_fifo_data_4[13], o_ss_tx_fifo_data_4[12], o_ss_tx_fifo_data_4[11], o_ss_tx_fifo_data_4[10], o_ss_tx_fifo_data_4[9], o_ss_tx_fifo_data_4[8], o_ss_tx_fifo_data_4[7], o_ss_tx_fifo_data_4[6], o_ss_tx_fifo_data_4[5], o_ss_tx_fifo_data_4[4], o_ss_tx_fifo_data_4[3], o_ss_tx_fifo_data_4[2], o_ss_tx_fifo_data_4[1], o_ss_tx_fifo_data_4[0] }),
		.o_eth({ x_decoder_sm_pld_tx_demux_0__o_eth_0[39], x_decoder_sm_pld_tx_demux_0__o_eth_0[38], x_decoder_sm_pld_tx_demux_0__o_eth_0[37], x_decoder_sm_pld_tx_demux_0__o_eth_0[36], x_decoder_sm_pld_tx_demux_0__o_eth_0[35], x_decoder_sm_pld_tx_demux_0__o_eth_0[34], x_decoder_sm_pld_tx_demux_0__o_eth_0[33], x_decoder_sm_pld_tx_demux_0__o_eth_0[32], x_decoder_sm_pld_tx_demux_0__o_eth_0[31], x_decoder_sm_pld_tx_demux_0__o_eth_0[30], x_decoder_sm_pld_tx_demux_0__o_eth_0[29], x_decoder_sm_pld_tx_demux_0__o_eth_0[28], x_decoder_sm_pld_tx_demux_0__o_eth_0[27], x_decoder_sm_pld_tx_demux_0__o_eth_0[26], x_decoder_sm_pld_tx_demux_0__o_eth_0[25], x_decoder_sm_pld_tx_demux_0__o_eth_0[24], x_decoder_sm_pld_tx_demux_0__o_eth_0[23], x_decoder_sm_pld_tx_demux_0__o_eth_0[22], x_decoder_sm_pld_tx_demux_0__o_eth_0[21], x_decoder_sm_pld_tx_demux_0__o_eth_0[20], x_decoder_sm_pld_tx_demux_0__o_eth_0[19], x_decoder_sm_pld_tx_demux_0__o_eth_0[18], x_decoder_sm_pld_tx_demux_0__o_eth_0[17], x_decoder_sm_pld_tx_demux_0__o_eth_0[16], x_decoder_sm_pld_tx_demux_0__o_eth_0[15], x_decoder_sm_pld_tx_demux_0__o_eth_0[14], x_decoder_sm_pld_tx_demux_0__o_eth_0[13], x_decoder_sm_pld_tx_demux_0__o_eth_0[12], x_decoder_sm_pld_tx_demux_0__o_eth_0[11], x_decoder_sm_pld_tx_demux_0__o_eth_0[10], x_decoder_sm_pld_tx_demux_0__o_eth_0[9], x_decoder_sm_pld_tx_demux_0__o_eth_0[8], x_decoder_sm_pld_tx_demux_0__o_eth_0[7], x_decoder_sm_pld_tx_demux_0__o_eth_0[6], x_decoder_sm_pld_tx_demux_0__o_eth_0[5], x_decoder_sm_pld_tx_demux_0__o_eth_0[4], x_decoder_sm_pld_tx_demux_0__o_eth_0[3], x_decoder_sm_pld_tx_demux_0__o_eth_0[2], x_decoder_sm_pld_tx_demux_0__o_eth_0[1], x_decoder_sm_pld_tx_demux_0__o_eth_0[0] }),
		.o_pcie({ x_decoder_sm_pld_tx_demux_0__o_pcie_0[79], x_decoder_sm_pld_tx_demux_0__o_pcie_0[78], x_decoder_sm_pld_tx_demux_0__o_pcie_0[77], x_decoder_sm_pld_tx_demux_0__o_pcie_0[76], x_decoder_sm_pld_tx_demux_0__o_pcie_0[75], x_decoder_sm_pld_tx_demux_0__o_pcie_0[74], x_decoder_sm_pld_tx_demux_0__o_pcie_0[73], x_decoder_sm_pld_tx_demux_0__o_pcie_0[72], x_decoder_sm_pld_tx_demux_0__o_pcie_0[71], x_decoder_sm_pld_tx_demux_0__o_pcie_0[70], x_decoder_sm_pld_tx_demux_0__o_pcie_0[69], x_decoder_sm_pld_tx_demux_0__o_pcie_0[68], x_decoder_sm_pld_tx_demux_0__o_pcie_0[67], x_decoder_sm_pld_tx_demux_0__o_pcie_0[66], x_decoder_sm_pld_tx_demux_0__o_pcie_0[65], x_decoder_sm_pld_tx_demux_0__o_pcie_0[64], x_decoder_sm_pld_tx_demux_0__o_pcie_0[63], x_decoder_sm_pld_tx_demux_0__o_pcie_0[62], x_decoder_sm_pld_tx_demux_0__o_pcie_0[61], x_decoder_sm_pld_tx_demux_0__o_pcie_0[60], x_decoder_sm_pld_tx_demux_0__o_pcie_0[59], x_decoder_sm_pld_tx_demux_0__o_pcie_0[58], x_decoder_sm_pld_tx_demux_0__o_pcie_0[57], x_decoder_sm_pld_tx_demux_0__o_pcie_0[56], x_decoder_sm_pld_tx_demux_0__o_pcie_0[55], x_decoder_sm_pld_tx_demux_0__o_pcie_0[54], x_decoder_sm_pld_tx_demux_0__o_pcie_0[53], x_decoder_sm_pld_tx_demux_0__o_pcie_0[52], x_decoder_sm_pld_tx_demux_0__o_pcie_0[51], x_decoder_sm_pld_tx_demux_0__o_pcie_0[50], x_decoder_sm_pld_tx_demux_0__o_pcie_0[49], x_decoder_sm_pld_tx_demux_0__o_pcie_0[48], x_decoder_sm_pld_tx_demux_0__o_pcie_0[47], x_decoder_sm_pld_tx_demux_0__o_pcie_0[46], x_decoder_sm_pld_tx_demux_0__o_pcie_0[45], x_decoder_sm_pld_tx_demux_0__o_pcie_0[44], x_decoder_sm_pld_tx_demux_0__o_pcie_0[43], x_decoder_sm_pld_tx_demux_0__o_pcie_0[42], x_decoder_sm_pld_tx_demux_0__o_pcie_0[41], x_decoder_sm_pld_tx_demux_0__o_pcie_0[40], x_decoder_sm_pld_tx_demux_0__o_pcie_0[39], x_decoder_sm_pld_tx_demux_0__o_pcie_0[38], x_decoder_sm_pld_tx_demux_0__o_pcie_0[37], x_decoder_sm_pld_tx_demux_0__o_pcie_0[36], x_decoder_sm_pld_tx_demux_0__o_pcie_0[35], x_decoder_sm_pld_tx_demux_0__o_pcie_0[34], x_decoder_sm_pld_tx_demux_0__o_pcie_0[33], x_decoder_sm_pld_tx_demux_0__o_pcie_0[32], x_decoder_sm_pld_tx_demux_0__o_pcie_0[31], x_decoder_sm_pld_tx_demux_0__o_pcie_0[30], x_decoder_sm_pld_tx_demux_0__o_pcie_0[29], x_decoder_sm_pld_tx_demux_0__o_pcie_0[28], x_decoder_sm_pld_tx_demux_0__o_pcie_0[27], x_decoder_sm_pld_tx_demux_0__o_pcie_0[26], x_decoder_sm_pld_tx_demux_0__o_pcie_0[25], x_decoder_sm_pld_tx_demux_0__o_pcie_0[24], x_decoder_sm_pld_tx_demux_0__o_pcie_0[23], x_decoder_sm_pld_tx_demux_0__o_pcie_0[22], x_decoder_sm_pld_tx_demux_0__o_pcie_0[21], x_decoder_sm_pld_tx_demux_0__o_pcie_0[20], x_decoder_sm_pld_tx_demux_0__o_pcie_0[19], x_decoder_sm_pld_tx_demux_0__o_pcie_0[18], x_decoder_sm_pld_tx_demux_0__o_pcie_0[17], x_decoder_sm_pld_tx_demux_0__o_pcie_0[16], x_decoder_sm_pld_tx_demux_0__o_pcie_0[15], x_decoder_sm_pld_tx_demux_0__o_pcie_0[14], x_decoder_sm_pld_tx_demux_0__o_pcie_0[13], x_decoder_sm_pld_tx_demux_0__o_pcie_0[12], x_decoder_sm_pld_tx_demux_0__o_pcie_0[11], x_decoder_sm_pld_tx_demux_0__o_pcie_0[10], x_decoder_sm_pld_tx_demux_0__o_pcie_0[9], x_decoder_sm_pld_tx_demux_0__o_pcie_0[8], x_decoder_sm_pld_tx_demux_0__o_pcie_0[7], x_decoder_sm_pld_tx_demux_0__o_pcie_0[6], x_decoder_sm_pld_tx_demux_0__o_pcie_0[5], x_decoder_sm_pld_tx_demux_0__o_pcie_0[4], x_decoder_sm_pld_tx_demux_0__o_pcie_0[3], x_decoder_sm_pld_tx_demux_0__o_pcie_0[2], x_decoder_sm_pld_tx_demux_0__o_pcie_0[1], x_decoder_sm_pld_tx_demux_0__o_pcie_0[0] }),
		.o_pcie_bond({ tmp, tmp_1, tmp_2, tmp_3, tmp_4, tmp_5, tmp_6, tmp_7, tmp_8, tmp_9, tmp_10, tmp_11, tmp_12, tmp_13, tmp_14, tmp_15, tmp_16, tmp_17, tmp_18, tmp_19, tmp_20, tmp_21, tmp_22, tmp_23, tmp_24, tmp_25, tmp_26, tmp_27, tmp_28, tmp_29, tmp_30, tmp_31, tmp_32, tmp_33, tmp_34, tmp_35, tmp_36, tmp_37, tmp_38, tmp_39, tmp_40, tmp_41, tmp_42, tmp_43, tmp_44, tmp_45, tmp_46, tmp_47, tmp_48, tmp_49, tmp_50, tmp_51, tmp_52, tmp_53, tmp_54, tmp_55, tmp_56, tmp_57, tmp_58, tmp_59, tmp_60, tmp_61, tmp_62, tmp_63, tmp_64, tmp_65, tmp_66, tmp_67, tmp_68, tmp_69, tmp_70, tmp_71, tmp_72, tmp_73, tmp_74, tmp_75, tmp_76, tmp_77, tmp_78, tmp_79 }),
		.o_ss_tx_fifo_rd_en(tmp_80)
	);

	tennm_sm_hssi_eth_lavmm_dec x_std_sm_hssi_eth_lavmm_dec_0 (
		.i_lavmm_addr({ o_ss_ch4_lavmm_ethe_addr_0[19], o_ss_ch4_lavmm_ethe_addr_0[18], o_ss_ch4_lavmm_ethe_addr_0[17], o_ss_ch4_lavmm_ethe_addr_0[16], o_ss_ch4_lavmm_ethe_addr_0[15], o_ss_ch4_lavmm_ethe_addr_0[14], o_ss_ch4_lavmm_ethe_addr_0[13], o_ss_ch4_lavmm_ethe_addr_0[12], o_ss_ch4_lavmm_ethe_addr_0[11], o_ss_ch4_lavmm_ethe_addr_0[10], o_ss_ch4_lavmm_ethe_addr_0[9], o_ss_ch4_lavmm_ethe_addr_0[8], o_ss_ch4_lavmm_ethe_addr_0[7], o_ss_ch4_lavmm_ethe_addr_0[6], o_ss_ch4_lavmm_ethe_addr_0[5], o_ss_ch4_lavmm_ethe_addr_0[4], o_ss_ch4_lavmm_ethe_addr_0[3], o_ss_ch4_lavmm_ethe_addr_0[2], o_ss_ch4_lavmm_ethe_addr_0[1], o_ss_ch4_lavmm_ethe_addr_0[0] }),
		.i_lavmm_be({ o_ss_ch4_lavmm_ethe_be_0[3], o_ss_ch4_lavmm_ethe_be_0[2], o_ss_ch4_lavmm_ethe_be_0[1], o_ss_ch4_lavmm_ethe_be_0[0] }),
		.i_lavmm_clk(o_ss_ch4_lavmm_ethe_clk_0),
		.i_lavmm_deskew_rdata({ x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_0[0] }),
		.i_lavmm_deskew_rdata_valid(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_rdata_valid_1),
		.i_lavmm_deskew_waitreq(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_deskew_waitreq_1),
		.i_lavmm_emac_rdata({ x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_0[0] }),
		.i_lavmm_emac_rdata_valid(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_rdata_valid_1),
		.i_lavmm_emac_waitreq(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_emac_waitreq_1),
		.i_lavmm_epcs_rdata({ x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_0[0] }),
		.i_lavmm_epcs_rdata_valid(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_rdata_valid_1),
		.i_lavmm_epcs_waitreq(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_epcs_waitreq_1),
		.i_lavmm_fec_rdata({ x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_0[0] }),
		.i_lavmm_fec_rdata_valid(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_rdata_valid_1),
		.i_lavmm_fec_waitreq(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_fec_waitreq_1),
		.i_lavmm_ptp_rdata({ pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1], pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1] }),
		.i_lavmm_ptp_rdata_valid(pld_pwr_level_shifter_u0__o_dft_ptcb_eth_top_edt_channel_in_0[1]),
		.i_lavmm_ptp_waitreq(n2_0),
		.i_lavmm_read(o_ss_ch4_lavmm_ethe_read_0),
		.i_lavmm_rstn(o_ss_ch4_lavmm_ethe_rstn_0),
		.i_lavmm_ux_rdata({ x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_0[0] }),
		.i_lavmm_ux_rdata_valid(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_rdata_valid_1),
		.i_lavmm_ux_waitreq(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_ux_waitreq_1),
		.i_lavmm_wdata({ o_ss_ch4_lavmm_ethe_wdata_0[31], o_ss_ch4_lavmm_ethe_wdata_0[30], o_ss_ch4_lavmm_ethe_wdata_0[29], o_ss_ch4_lavmm_ethe_wdata_0[28], o_ss_ch4_lavmm_ethe_wdata_0[27], o_ss_ch4_lavmm_ethe_wdata_0[26], o_ss_ch4_lavmm_ethe_wdata_0[25], o_ss_ch4_lavmm_ethe_wdata_0[24], o_ss_ch4_lavmm_ethe_wdata_0[23], o_ss_ch4_lavmm_ethe_wdata_0[22], o_ss_ch4_lavmm_ethe_wdata_0[21], o_ss_ch4_lavmm_ethe_wdata_0[20], o_ss_ch4_lavmm_ethe_wdata_0[19], o_ss_ch4_lavmm_ethe_wdata_0[18], o_ss_ch4_lavmm_ethe_wdata_0[17], o_ss_ch4_lavmm_ethe_wdata_0[16], o_ss_ch4_lavmm_ethe_wdata_0[15], o_ss_ch4_lavmm_ethe_wdata_0[14], o_ss_ch4_lavmm_ethe_wdata_0[13], o_ss_ch4_lavmm_ethe_wdata_0[12], o_ss_ch4_lavmm_ethe_wdata_0[11], o_ss_ch4_lavmm_ethe_wdata_0[10], o_ss_ch4_lavmm_ethe_wdata_0[9], o_ss_ch4_lavmm_ethe_wdata_0[8], o_ss_ch4_lavmm_ethe_wdata_0[7], o_ss_ch4_lavmm_ethe_wdata_0[6], o_ss_ch4_lavmm_ethe_wdata_0[5], o_ss_ch4_lavmm_ethe_wdata_0[4], o_ss_ch4_lavmm_ethe_wdata_0[3], o_ss_ch4_lavmm_ethe_wdata_0[2], o_ss_ch4_lavmm_ethe_wdata_0[1], o_ss_ch4_lavmm_ethe_wdata_0[0] }),
		.i_lavmm_write(o_ss_ch4_lavmm_ethe_write_0),
		.i_lavmm_xcvrif_rdata({ x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_0[0] }),
		.i_lavmm_xcvrif_rdata_valid(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_rdata_valid_1),
		.i_lavmm_xcvrif_waitreq(x_std_sm_hssi_eth_lavmm_dec_0__i_lavmm_xcvrif_waitreq_1),
		.o_lavmm_deskew_addr({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_addr_0[0] }),
		.o_lavmm_deskew_be({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_be_0[0] }),
		.o_lavmm_deskew_clk(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_clk_1),
		.o_lavmm_deskew_read(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_read_1),
		.o_lavmm_deskew_rstn(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_rstn_1),
		.o_lavmm_deskew_wdata({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_wdata_0[0] }),
		.o_lavmm_deskew_write(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_deskew_write_1),
		.o_lavmm_emac_addr({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_addr_0[0] }),
		.o_lavmm_emac_be({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_be_0[0] }),
		.o_lavmm_emac_clk(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_clk_1),
		.o_lavmm_emac_read(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_read_1),
		.o_lavmm_emac_rstn(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_rstn_1),
		.o_lavmm_emac_wdata({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_wdata_0[0] }),
		.o_lavmm_emac_write(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_emac_write_1),
		.o_lavmm_epcs_addr({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_addr_0[0] }),
		.o_lavmm_epcs_be({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_be_0[0] }),
		.o_lavmm_epcs_clk(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_clk_1),
		.o_lavmm_epcs_read(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_read_1),
		.o_lavmm_epcs_rstn(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_rstn_1),
		.o_lavmm_epcs_wdata({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_wdata_0[0] }),
		.o_lavmm_epcs_write(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_epcs_write_1),
		.o_lavmm_fec_addr({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_addr_0[0] }),
		.o_lavmm_fec_be({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_be_0[0] }),
		.o_lavmm_fec_clk(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_clk_1),
		.o_lavmm_fec_read(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_read_1),
		.o_lavmm_fec_rstn(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_rstn_1),
		.o_lavmm_fec_wdata({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_wdata_0[0] }),
		.o_lavmm_fec_write(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_fec_write_1),
		.o_lavmm_ptp_addr({ tmp_81, tmp_82, tmp_83, tmp_84, tmp_85, tmp_86, tmp_87, tmp_88, tmp_89, tmp_90, tmp_91, tmp_92, tmp_93, tmp_94, tmp_95, tmp_96, tmp_97, tmp_98, tmp_99, tmp_100 }),
		.o_lavmm_ptp_be({ tmp_101, tmp_102, tmp_103, tmp_104 }),
		.o_lavmm_ptp_clk(tmp_105),
		.o_lavmm_ptp_read(tmp_106),
		.o_lavmm_ptp_rstn(tmp_107),
		.o_lavmm_ptp_wdata({ tmp_108, tmp_109, tmp_110, tmp_111, tmp_112, tmp_113, tmp_114, tmp_115, tmp_116, tmp_117, tmp_118, tmp_119, tmp_120, tmp_121, tmp_122, tmp_123, tmp_124, tmp_125, tmp_126, tmp_127, tmp_128, tmp_129, tmp_130, tmp_131, tmp_132, tmp_133, tmp_134, tmp_135, tmp_136, tmp_137, tmp_138, tmp_139 }),
		.o_lavmm_ptp_write(tmp_140),
		.o_lavmm_rdata({ pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[31], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[30], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[29], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[28], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[27], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[26], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[25], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[24], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[23], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[22], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[21], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[20], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[19], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[18], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[17], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[16], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[15], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[14], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[13], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[12], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[11], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[10], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[9], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[8], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[7], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[6], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[5], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[4], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[3], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[2], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[1], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[0] }),
		.o_lavmm_rdata_valid(pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_valid_0),
		.o_lavmm_ux_addr({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_addr_0[0] }),
		.o_lavmm_ux_be({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_be_0[0] }),
		.o_lavmm_ux_clk(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_clk_1),
		.o_lavmm_ux_read(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_read_1),
		.o_lavmm_ux_rstn(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_rstn_1),
		.o_lavmm_ux_wdata({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_wdata_0[0] }),
		.o_lavmm_ux_write(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_ux_write_1),
		.o_lavmm_waitreq(pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_waitreq_0),
		.o_lavmm_xcvrif_addr({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_addr_0[0] }),
		.o_lavmm_xcvrif_be({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_be_0[0] }),
		.o_lavmm_xcvrif_clk(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_clk_1),
		.o_lavmm_xcvrif_read(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_read_1),
		.o_lavmm_xcvrif_rstn(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_rstn_1),
		.o_lavmm_xcvrif_wdata({ x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[31], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[30], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[29], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[28], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[27], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[26], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[25], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[24], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[23], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[22], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[21], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[20], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[19], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[18], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[17], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[16], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[15], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[14], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[13], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[12], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[11], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[10], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[9], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[8], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[7], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[6], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[5], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[4], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[3], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[2], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[1], x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_wdata_0[0] }),
		.o_lavmm_xcvrif_write(x_std_sm_hssi_eth_lavmm_dec_0__o_lavmm_xcvrif_write_1)
	);

	tennm_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux #(
		.sel(x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__sel)
	) x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0 (
		.i_eth_or_ptp(x_mux_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux_0__i_eth_or_ptp_1),
		.i_pcie(o_pld_pcie_clk_4),
		.i_pcie_top(s441_51_1__hssi_clk__clk),
		.o_rxfifo_ss_write_clk(o_rxfifo_ss_write_clk_4)
	);

	tennm_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux #(
		.sel(x_mux_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0__sel)
	) x_mux_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0 (
		.i_eth_or_ptp(x_mux_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux_0__i_eth_or_ptp_1),
		.i_pcie(o_pld_pcie_clk_4),
		.i_pcie_top(s441_51_1__hssi_clk__clk),
		.o_tx_fifo_ss_read_clk(o_txfifo_ss_read_clk_4)
	);

	tennm_sm_hssi_pld_chnl_dp #(
		.dr_enabled(x_std_sm_hssi_pld_chnl_dp_0__dr_enabled),
		.duplex_mode(x_std_sm_hssi_pld_chnl_dp_0__duplex_mode),
		.pld_channel_identifier(x_std_sm_hssi_pld_chnl_dp_0__pld_channel_identifier),
		.rx_clkout1_divider(x_std_sm_hssi_pld_chnl_dp_0__rx_clkout1_divider),
		.rx_clkout2_divider(x_std_sm_hssi_pld_chnl_dp_0__rx_clkout2_divider),
		.rx_en(x_std_sm_hssi_pld_chnl_dp_0__rx_en),
		.rx_fifo_mode(x_std_sm_hssi_pld_chnl_dp_0__rx_fifo_mode),
		.rx_fifo_width(x_std_sm_hssi_pld_chnl_dp_0__rx_fifo_width),
		.rx_fifo_wr_clk_hz(x_std_sm_hssi_pld_chnl_dp_0__rx_fifo_wr_clk_hz),
		.rx_user1_clk_dynamic_mux(x_std_sm_hssi_pld_chnl_dp_0__rx_user1_clk_dynamic_mux),
		.rx_user2_clk_dynamic_mux(x_std_sm_hssi_pld_chnl_dp_0__rx_user2_clk_dynamic_mux),
		.sup_mode(x_std_sm_hssi_pld_chnl_dp_0__sup_mode),
		.tx_clkout1_divider(x_std_sm_hssi_pld_chnl_dp_0__tx_clkout1_divider),
		.tx_clkout2_divider(x_std_sm_hssi_pld_chnl_dp_0__tx_clkout2_divider),
		.tx_en(x_std_sm_hssi_pld_chnl_dp_0__tx_en),
		.tx_fifo_mode(x_std_sm_hssi_pld_chnl_dp_0__tx_fifo_mode),
		.tx_fifo_rd_clk_hz(x_std_sm_hssi_pld_chnl_dp_0__tx_fifo_rd_clk_hz),
		.tx_fifo_width(x_std_sm_hssi_pld_chnl_dp_0__tx_fifo_width),
		.tx_user1_clk_dynamic_mux(x_std_sm_hssi_pld_chnl_dp_0__tx_user1_clk_dynamic_mux),
		.tx_user2_clk_dynamic_mux(x_std_sm_hssi_pld_chnl_dp_0__tx_user2_clk_dynamic_mux),
		.vc_rx_pldif_wm_en(x_std_sm_hssi_pld_chnl_dp_0__vc_rx_pldif_wm_en)
	) x_std_sm_hssi_pld_chnl_dp_0 (
		.i_hio_det_lat_rx_dl_clk(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_dl_clk_1),
		.i_hio_det_lat_rx_mux_select(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_mux_select_1),
		.i_hio_det_lat_rx_sclk_flop(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_flop_1),
		.i_hio_det_lat_rx_sclk_gen_clk(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_sclk_gen_clk_1),
		.i_hio_det_lat_rx_trig_flop(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_rx_trig_flop_1),
		.i_hio_det_lat_sampling_clk(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_sampling_clk_1),
		.i_hio_det_lat_tx_dl_clk(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_dl_clk_1),
		.i_hio_det_lat_tx_mux_select(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_mux_select_1),
		.i_hio_det_lat_tx_sclk_flop(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_flop_1),
		.i_hio_det_lat_tx_sclk_gen_clk(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_sclk_gen_clk_1),
		.i_hio_det_lat_tx_trig_flop(x_std_sm_hssi_pld_chnl_dp_0__i_hio_det_lat_tx_trig_flop_1),
		.i_hio_ehip_rx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_rx_rst_n_1),
		.i_hio_ehip_signal_ok(x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_signal_ok_1),
		.i_hio_ehip_tx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_ehip_tx_rst_n_1),
		.i_hio_lavmm_addr({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[20], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[19], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[18], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[17], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[16], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[15], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[14], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_addr_0[0] }),
		.i_hio_lavmm_be({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_be_0[0] }),
		.i_hio_lavmm_clk(x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_clk_1),
		.i_hio_lavmm_read(x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_read_1),
		.i_hio_lavmm_rstn(x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_rstn_1),
		.i_hio_lavmm_wdata({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[31], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[30], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[29], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[28], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[27], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[26], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[25], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[24], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[23], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[22], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[21], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[20], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[19], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[18], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[17], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[16], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[15], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[14], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_wdata_0[0] }),
		.i_hio_lavmm_write(x_std_sm_hssi_pld_chnl_dp_0__i_hio_lavmm_write_1),
		.i_hio_pld_reset_clk_row(x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_reset_clk_row_1),
		.i_hio_pld_rx_clk_in_row_clk(x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_rx_clk_in_row_clk_1),
		.i_hio_pld_tx_clk_in_row_clk(x_std_sm_hssi_pld_chnl_dp_0__i_hio_pld_tx_clk_in_row_clk_1),
		.i_hio_ptp_rst_n(quartus_i_dft_hssi_scan_mode_0),
		.i_hio_rst_pld_adapter_rx_pld_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_rx_pld_rst_n_1),
		.i_hio_rst_pld_adapter_tx_pld_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_adapter_tx_pld_rst_n_1),
		.i_hio_rst_pld_clrhip(quartus_i_dft_hssi_scan_mode_0),
		.i_hio_rst_pld_clrpcs(quartus_i_dft_hssi_scan_mode_0),
		.i_hio_rst_pld_perstn(quartus_i_dft_hssi_scan_mode_0),
		.i_hio_rst_pld_ready(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_pld_ready_1),
		.i_hio_rst_ux_rx_pma_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_pma_rst_n_1),
		.i_hio_rst_ux_rx_sfrz(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_rx_sfrz_1),
		.i_hio_rst_ux_tx_pma_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rst_ux_tx_pma_rst_n_1),
		.i_hio_rstfec_fec_csr_ret(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_csr_ret_1),
		.i_hio_rstfec_fec_rx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_rx_rst_n_1),
		.i_hio_rstfec_fec_tx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_fec_tx_rst_n_1),
		.i_hio_rstfec_rx_fec_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_rx_fec_sfrz_n_1),
		.i_hio_rstfec_tx_fec_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstfec_tx_fec_sfrz_n_1),
		.i_hio_rstxcvrif_rx_xcvrif_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_rx_xcvrif_sfrz_n_1),
		.i_hio_rstxcvrif_tx_xcvrif_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_tx_xcvrif_sfrz_n_1),
		.i_hio_rstxcvrif_xcvrif_rx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_rx_rst_n_1),
		.i_hio_rstxcvrif_xcvrif_signal_ok(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_signal_ok_1),
		.i_hio_rstxcvrif_xcvrif_tx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rstxcvrif_xcvrif_tx_rst_n_1),
		.i_hio_rxdata_fifo_rd_en(x_std_sm_hssi_pld_chnl_dp_0__i_hio_rxdata_fifo_rd_en_1),
		.i_hio_sfreeze_2_r03f_rx_mac_srfz_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_2_r03f_rx_mac_srfz_n_1),
		.i_hio_sfreeze_3_c2f_tx_deskew_srfz_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_sfreeze_3_c2f_tx_deskew_srfz_n_1),
		.i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n_1),
		.i_hio_txdata({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[79], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[78], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[77], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[76], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[75], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[74], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[73], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[72], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[71], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[70], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[69], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[68], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[67], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[66], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[65], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[64], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[63], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[62], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[61], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[60], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[59], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[58], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[57], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[56], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[55], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[54], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[53], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[52], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[51], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[50], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[49], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[48], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[47], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[46], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[45], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[44], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[43], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[42], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[41], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[40], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[39], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[38], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[37], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[36], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[35], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[34], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[33], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[32], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[31], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[30], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[29], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[28], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[27], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[26], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[25], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[24], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[23], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[22], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[21], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[20], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[19], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[18], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[17], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[16], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[15], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[14], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_0[0] }),
		.i_hio_txdata_async({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[99], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[98], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[97], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[96], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[95], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[94], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[93], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[92], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[91], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[90], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[89], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[88], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[87], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[86], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[85], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[84], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[83], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[82], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[81], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[80], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[79], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[78], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[77], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[76], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[75], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[74], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[73], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[72], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[71], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[70], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[69], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[68], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[67], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[66], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[65], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[64], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[63], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[62], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[61], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[60], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[59], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[58], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[57], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[56], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[55], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[54], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[53], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[52], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[51], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[50], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[49], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[48], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[47], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[46], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[45], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[44], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[43], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[42], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[41], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[40], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[39], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[38], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[37], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[36], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[35], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[34], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[33], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[32], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[31], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[30], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[29], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[28], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[27], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[26], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[25], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[24], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[23], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[22], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[21], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[20], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[19], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[18], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[17], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[16], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[15], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[14], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_async_0[0] }),
		.i_hio_txdata_direct({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_direct_0[0] }),
		.i_hio_txdata_extra({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_extra_0[0] }),
		.i_hio_txdata_fifo_wr_en(x_std_sm_hssi_pld_chnl_dp_0__i_hio_txdata_fifo_wr_en_1),
		.i_hio_uxquad_async({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[79], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[78], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[77], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[76], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[75], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[74], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[73], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[72], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[71], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[70], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[69], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[68], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[67], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[66], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[65], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[64], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[63], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[62], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[61], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[60], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[59], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[58], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[57], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[56], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[55], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[54], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[53], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[52], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[51], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[50], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[49], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[48], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[47], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[46], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[45], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[44], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[43], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[42], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[41], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[40], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[39], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[38], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[37], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[36], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[35], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[34], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[33], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[32], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[31], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[30], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[29], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[28], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[27], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[26], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[25], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[24], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[23], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[22], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[21], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[20], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[19], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[18], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[17], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[16], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[15], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[14], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_0[0] }),
		.i_hio_uxquad_async_pcie_mux({ x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[79], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[78], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[77], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[76], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[75], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[74], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[73], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[72], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[71], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[70], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[69], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[68], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[67], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[66], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[65], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[64], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[63], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[62], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[61], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[60], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[59], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[58], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[57], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[56], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[55], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[54], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[53], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[52], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[51], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[50], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[49], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[48], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[47], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[46], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[45], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[44], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[43], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[42], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[41], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[40], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[39], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[38], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[37], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[36], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[35], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[34], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[33], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[32], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[31], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[30], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[29], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[28], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[27], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[26], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[25], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[24], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[23], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[22], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[21], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[20], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[19], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[18], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[17], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[16], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[15], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[14], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_hio_uxquad_async_pcie_mux_0[0] }),
		.i_ss_det_lat_rx_async_pulse(x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_rx_async_pulse_1),
		.i_ss_det_lat_tx_async_pulse(x_std_sm_hssi_pld_chnl_dp_0__i_ss_det_lat_tx_async_pulse_1),
		.i_ss_eth_dkw_rx_async({ x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_async_0[0] }),
		.i_ss_eth_dkw_rx_direct(x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_dkw_rx_direct_1),
		.i_ss_eth_fec_rx_async({ x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_async_0[0] }),
		.i_ss_eth_fec_rx_direct(x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_fec_rx_direct_1),
		.i_ss_eth_mac_rx_async({ x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_async_0[0] }),
		.i_ss_eth_mac_rx_direct(x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_mac_rx_direct_1),
		.i_ss_eth_pcs_rx_async({ x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_async_0[0] }),
		.i_ss_eth_pcs_rx_direct(x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_pcs_rx_direct_1),
		.i_ss_eth_xcvrif_rx_async({ x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_async_0[0] }),
		.i_ss_eth_xcvrif_rx_direct(x_std_sm_hssi_pld_chnl_dp_0__i_ss_eth_xcvrif_rx_direct_1),
		.i_ss_lavmm_ethe_rdata({ pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[31], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[30], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[29], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[28], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[27], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[26], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[25], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[24], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[23], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[22], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[21], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[20], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[19], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[18], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[17], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[16], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[15], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[14], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[13], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[12], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[11], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[10], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[9], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[8], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[7], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[6], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[5], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[4], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[3], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[2], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[1], pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_0[0] }),
		.i_ss_lavmm_ethe_rdata_valid(pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_rdata_valid_0),
		.i_ss_lavmm_ethe_waitreq(pld_chnl_dp_wr_u4__i_ss_lavmm_ethe_waitreq_0),
		.i_ss_lavmm_pcie_rdata({ x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[31], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[30], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[29], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[28], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[27], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[26], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[25], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[24], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[23], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[22], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[21], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[20], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[19], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[18], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[17], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[16], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[15], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[14], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_0[0] }),
		.i_ss_lavmm_pcie_rdata_valid(x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_rdata_valid_1),
		.i_ss_lavmm_pcie_waitreq(x_std_sm_hssi_pld_chnl_dp_0__i_ss_lavmm_pcie_waitreq_1),
		.i_ss_pcie_ctrl_rx_async({ quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0 }),
		.i_ss_pcie_ctrl_rx_direct({ quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0, quartus_i_dft_hssi_scan_mode_0 }),
		.i_ss_rst_flux0_cpi_cmn_busy(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_flux0_cpi_cmn_busy_1),
		.i_ss_rst_oflux_rx_srds_rdy(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_oflux_rx_srds_rdy_1),
		.i_ss_rst_ux_all_synthlockstatus(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_all_synthlockstatus_1),
		.i_ss_rst_ux_octl_pcs_rxstatus(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_rxstatus_1),
		.i_ss_rst_ux_octl_pcs_txstatus(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_octl_pcs_txstatus_1),
		.i_ss_rst_ux_rxcdrlock2data(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlock2data_1),
		.i_ss_rst_ux_rxcdrlockstatus(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rst_ux_rxcdrlockstatus_1),
		.i_ss_rstepcs_rx_pcs_fully_aligned(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstepcs_rx_pcs_fully_aligned_1),
		.i_ss_rstfec_fec_rx_rdy_n(x_std_sm_hssi_pld_chnl_dp_0__i_ss_rstfec_fec_rx_rdy_n_1),
		.i_ss_rx_fifo_clk(o_rxfifo_ss_write_clk_4),
		.i_ss_rx_fifo_data({ pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[79], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[78], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[77], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[76], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[75], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[74], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[73], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[72], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[71], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[70], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[69], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[68], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[67], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[66], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[65], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[64], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[63], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[62], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[61], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[60], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[59], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[58], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[57], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[56], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[55], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[54], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[53], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[52], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[51], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[50], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[49], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[48], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[47], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[46], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[45], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[44], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[43], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[42], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[41], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[40], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[39], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[38], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[37], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[36], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[35], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[34], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[33], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[32], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[31], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[30], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[29], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[28], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[27], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[26], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[25], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[24], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[23], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[22], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[21], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[20], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[19], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[18], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[17], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[16], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[15], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[14], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[13], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[12], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[11], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[10], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[9], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[8], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[7], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[6], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[5], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[4], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[3], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[2], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[1], pld_chnl_dp_wr_u4__i_ss_rx_fifo_data_0[0] }),
		.i_ss_tx_fifo_clk(o_txfifo_ss_read_clk_4),
		.i_ss_user_rx_clk1_clk(x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk1_clk_1),
		.i_ss_user_rx_clk2_clk(x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_rx_clk2_clk_1),
		.i_ss_user_tx_clk1_clk(x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk1_clk_1),
		.i_ss_user_tx_clk2_clk(x_std_sm_hssi_pld_chnl_dp_0__i_ss_user_tx_clk2_clk_1),
		.i_ss_uxquad_async({ x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[49], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[48], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[47], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[46], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[45], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[44], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[43], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[42], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[41], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[40], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[39], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[38], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[37], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[36], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[35], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[34], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[33], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[32], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[31], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[30], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[29], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[28], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[27], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[26], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[25], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[24], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[23], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[22], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[21], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[20], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[19], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[18], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[17], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[16], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[15], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[14], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__i_ss_uxquad_async_0[0] }),
		.i_ss_xcvrif_rx_latency_pulse(x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_rx_latency_pulse_1),
		.i_ss_xcvrif_tx_latency_pulse(x_std_sm_hssi_pld_chnl_dp_0__i_ss_xcvrif_tx_latency_pulse_1),
		.i_ux_chnl_refclk_mux(x_std_sm_hssi_pld_chnl_dp_0__i_ux_chnl_refclk_mux_1),
		.i_ux_tx_ch_ptr_smpl(quartus_i_dft_hssi_scan_mode_0),
		.k_user_rx_clk1_c0c1c2_sel({ x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel_0[2], x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel_0[1], x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk1_c0c1c2_sel_0[0] }),
		.k_user_rx_clk2_c0c1c2_sel({ x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel_0[2], x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel_0[1], x_std_sm_hssi_pld_chnl_dp_0__k_user_rx_clk2_c0c1c2_sel_0[0] }),
		.k_user_tx_clk1_c0c1c2_sel({ x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel_0[2], x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel_0[1], x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk1_c0c1c2_sel_0[0] }),
		.k_user_tx_clk2_c0c1c2_sel({ x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel_0[2], x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel_0[1], x_std_sm_hssi_pld_chnl_dp_0__k_user_tx_clk2_c0c1c2_sel_0[0] }),
		.o_hio_det_lat_rx_async_dl_sync(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_dl_sync_1),
		.o_hio_det_lat_rx_async_pulse(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_pulse_1),
		.o_hio_det_lat_rx_async_sample_sync(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_async_sample_sync_1),
		.o_hio_det_lat_rx_sclk_sample_sync(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_sclk_sample_sync_1),
		.o_hio_det_lat_rx_trig_sample_sync(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_rx_trig_sample_sync_1),
		.o_hio_det_lat_tx_async_dl_sync(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_dl_sync_1),
		.o_hio_det_lat_tx_async_pulse(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_pulse_1),
		.o_hio_det_lat_tx_async_sample_sync(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_async_sample_sync_1),
		.o_hio_det_lat_tx_sclk_sample_sync(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_sclk_sample_sync_1),
		.o_hio_det_lat_tx_trig_sample_sync(x_std_sm_hssi_pld_chnl_dp_0__o_hio_det_lat_tx_trig_sample_sync_1),
		.o_hio_lavmm_rdata({ x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[31], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[30], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[29], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[28], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[27], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[26], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[25], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[24], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[23], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[22], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[21], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[20], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[19], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[18], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[17], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[16], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[15], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[14], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_0[0] }),
		.o_hio_lavmm_rdata_valid(x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_rdata_valid_1),
		.o_hio_lavmm_waitreq(x_std_sm_hssi_pld_chnl_dp_0__o_hio_lavmm_waitreq_1),
		.o_hio_rst_flux0_cpi_cmn_busy(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_flux0_cpi_cmn_busy_1),
		.o_hio_rst_oflux_rx_srds_rdy(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_oflux_rx_srds_rdy_1),
		.o_hio_rst_ux_all_synthlockstatus(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_all_synthlockstatus_1),
		.o_hio_rst_ux_octl_pcs_rxstatus(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_rxstatus_1),
		.o_hio_rst_ux_octl_pcs_txstatus(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_octl_pcs_txstatus_1),
		.o_hio_rst_ux_rxcdrlock2data(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlock2data_1),
		.o_hio_rst_ux_rxcdrlockstatus(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rst_ux_rxcdrlockstatus_1),
		.o_hio_rstepcs_rx_pcs_fully_aligned(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstepcs_rx_pcs_fully_aligned_1),
		.o_hio_rstfec_fec_rx_rdy_n(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rstfec_fec_rx_rdy_n_1),
		.o_hio_rxdata({ x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[79], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[78], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[77], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[76], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[75], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[74], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[73], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[72], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[71], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[70], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[69], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[68], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[67], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[66], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[65], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[64], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[63], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[62], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[61], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[60], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[59], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[58], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[57], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[56], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[55], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[54], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[53], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[52], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[51], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[50], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[49], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[48], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[47], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[46], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[45], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[44], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[43], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[42], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[41], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[40], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[39], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[38], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[37], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[36], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[35], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[34], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[33], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[32], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[31], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[30], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[29], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[28], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[27], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[26], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[25], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[24], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[23], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[22], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[21], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[20], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[19], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[18], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[17], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[16], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[15], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[14], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_0[0] }),
		.o_hio_rxdata_async({ x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[99], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[98], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[97], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[96], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[95], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[94], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[93], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[92], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[91], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[90], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[89], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[88], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[87], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[86], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[85], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[84], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[83], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[82], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[81], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[80], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[79], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[78], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[77], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[76], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[75], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[74], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[73], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[72], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[71], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[70], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[69], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[68], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[67], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[66], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[65], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[64], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[63], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[62], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[61], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[60], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[59], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[58], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[57], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[56], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[55], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[54], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[53], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[52], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[51], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[50], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[49], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[48], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[47], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[46], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[45], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[44], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[43], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[42], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[41], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[40], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[39], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[38], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[37], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[36], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[35], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[34], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[33], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[32], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[31], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[30], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[29], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[28], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[27], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[26], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[25], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[24], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[23], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[22], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[21], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[20], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[19], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[18], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[17], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[16], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[15], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[14], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_async_0[0] }),
		.o_hio_rxdata_direct({ x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_direct_0[0] }),
		.o_hio_rxdata_extra({ x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_extra_0[0] }),
		.o_hio_rxdata_fifo_rd_empty(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_empty_1),
		.o_hio_rxdata_fifo_rd_full(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_full_1),
		.o_hio_rxdata_fifo_rd_pempty(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pempty_1),
		.o_hio_rxdata_fifo_rd_pfull(x_std_sm_hssi_pld_chnl_dp_0__o_hio_rxdata_fifo_rd_pfull_1),
		.o_hio_txdata_fifo_wr_empty(x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_empty_1),
		.o_hio_txdata_fifo_wr_full(x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_full_1),
		.o_hio_txdata_fifo_wr_pempty(x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pempty_1),
		.o_hio_txdata_fifo_wr_pfull(x_std_sm_hssi_pld_chnl_dp_0__o_hio_txdata_fifo_wr_pfull_1),
		.o_hio_user_rx_clk1_clk(x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk1_clk_1),
		.o_hio_user_rx_clk2_clk(x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_rx_clk2_clk_1),
		.o_hio_user_tx_clk1_clk(x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk1_clk_1),
		.o_hio_user_tx_clk2_clk(x_std_sm_hssi_pld_chnl_dp_0__o_hio_user_tx_clk2_clk_1),
		.o_hio_ux_chnl_refclk_mux(x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_chnl_refclk_mux_1),
		.o_hio_ux_tx_ch_ptr_smpl(x_std_sm_hssi_pld_chnl_dp_0__o_hio_ux_tx_ch_ptr_smpl_1),
		.o_hio_uxquad_async({ x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[49], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[48], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[47], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[46], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[45], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[44], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[43], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[42], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[41], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[40], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[39], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[38], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[37], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[36], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[35], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[34], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[33], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[32], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[31], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[30], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[29], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[28], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[27], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[26], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[25], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[24], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[23], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[22], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[21], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[20], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[19], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[18], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[17], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[16], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[15], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[14], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_hio_uxquad_async_0[0] }),
		.o_hio_xcvrif_rx_latency_pulse(x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_rx_latency_pulse_1),
		.o_hio_xcvrif_tx_latency_pulse(x_std_sm_hssi_pld_chnl_dp_0__o_hio_xcvrif_tx_latency_pulse_1),
		.o_ss_det_lat_rx_sclk_clk(x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_clk_1),
		.o_ss_det_lat_rx_sclk_sync(x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_rx_sclk_sync_1),
		.o_ss_det_lat_tx_sclk_clk(x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_clk_1),
		.o_ss_det_lat_tx_sclk_sync(x_std_sm_hssi_pld_chnl_dp_0__o_ss_det_lat_tx_sclk_sync_1),
		.o_ss_ehip_rx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_rx_rst_n_1),
		.o_ss_ehip_signal_ok(x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_signal_ok_1),
		.o_ss_ehip_tx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_ehip_tx_rst_n_1),
		.o_ss_eth_dkw_tx_async({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_async_0[0] }),
		.o_ss_eth_dkw_tx_direct(x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_dkw_tx_direct_1),
		.o_ss_eth_fec_tx_async({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_async_0[0] }),
		.o_ss_eth_fec_tx_direct(x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_fec_tx_direct_1),
		.o_ss_eth_mac_tx_async({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_async_0[0] }),
		.o_ss_eth_mac_tx_direct(x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_mac_tx_direct_1),
		.o_ss_eth_pcs_tx_async({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_async_0[0] }),
		.o_ss_eth_pcs_tx_direct(x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_pcs_tx_direct_1),
		.o_ss_eth_xcvrif_tx_async({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_async_0[0] }),
		.o_ss_eth_xcvrif_tx_direct(x_std_sm_hssi_pld_chnl_dp_0__o_ss_eth_xcvrif_tx_direct_1),
		.o_ss_lavmm_ethe_addr({ o_ss_ch4_lavmm_ethe_addr_0[19], o_ss_ch4_lavmm_ethe_addr_0[18], o_ss_ch4_lavmm_ethe_addr_0[17], o_ss_ch4_lavmm_ethe_addr_0[16], o_ss_ch4_lavmm_ethe_addr_0[15], o_ss_ch4_lavmm_ethe_addr_0[14], o_ss_ch4_lavmm_ethe_addr_0[13], o_ss_ch4_lavmm_ethe_addr_0[12], o_ss_ch4_lavmm_ethe_addr_0[11], o_ss_ch4_lavmm_ethe_addr_0[10], o_ss_ch4_lavmm_ethe_addr_0[9], o_ss_ch4_lavmm_ethe_addr_0[8], o_ss_ch4_lavmm_ethe_addr_0[7], o_ss_ch4_lavmm_ethe_addr_0[6], o_ss_ch4_lavmm_ethe_addr_0[5], o_ss_ch4_lavmm_ethe_addr_0[4], o_ss_ch4_lavmm_ethe_addr_0[3], o_ss_ch4_lavmm_ethe_addr_0[2], o_ss_ch4_lavmm_ethe_addr_0[1], o_ss_ch4_lavmm_ethe_addr_0[0] }),
		.o_ss_lavmm_ethe_be({ o_ss_ch4_lavmm_ethe_be_0[3], o_ss_ch4_lavmm_ethe_be_0[2], o_ss_ch4_lavmm_ethe_be_0[1], o_ss_ch4_lavmm_ethe_be_0[0] }),
		.o_ss_lavmm_ethe_clk(o_ss_ch4_lavmm_ethe_clk_0),
		.o_ss_lavmm_ethe_read(o_ss_ch4_lavmm_ethe_read_0),
		.o_ss_lavmm_ethe_rstn(o_ss_ch4_lavmm_ethe_rstn_0),
		.o_ss_lavmm_ethe_wdata({ o_ss_ch4_lavmm_ethe_wdata_0[31], o_ss_ch4_lavmm_ethe_wdata_0[30], o_ss_ch4_lavmm_ethe_wdata_0[29], o_ss_ch4_lavmm_ethe_wdata_0[28], o_ss_ch4_lavmm_ethe_wdata_0[27], o_ss_ch4_lavmm_ethe_wdata_0[26], o_ss_ch4_lavmm_ethe_wdata_0[25], o_ss_ch4_lavmm_ethe_wdata_0[24], o_ss_ch4_lavmm_ethe_wdata_0[23], o_ss_ch4_lavmm_ethe_wdata_0[22], o_ss_ch4_lavmm_ethe_wdata_0[21], o_ss_ch4_lavmm_ethe_wdata_0[20], o_ss_ch4_lavmm_ethe_wdata_0[19], o_ss_ch4_lavmm_ethe_wdata_0[18], o_ss_ch4_lavmm_ethe_wdata_0[17], o_ss_ch4_lavmm_ethe_wdata_0[16], o_ss_ch4_lavmm_ethe_wdata_0[15], o_ss_ch4_lavmm_ethe_wdata_0[14], o_ss_ch4_lavmm_ethe_wdata_0[13], o_ss_ch4_lavmm_ethe_wdata_0[12], o_ss_ch4_lavmm_ethe_wdata_0[11], o_ss_ch4_lavmm_ethe_wdata_0[10], o_ss_ch4_lavmm_ethe_wdata_0[9], o_ss_ch4_lavmm_ethe_wdata_0[8], o_ss_ch4_lavmm_ethe_wdata_0[7], o_ss_ch4_lavmm_ethe_wdata_0[6], o_ss_ch4_lavmm_ethe_wdata_0[5], o_ss_ch4_lavmm_ethe_wdata_0[4], o_ss_ch4_lavmm_ethe_wdata_0[3], o_ss_ch4_lavmm_ethe_wdata_0[2], o_ss_ch4_lavmm_ethe_wdata_0[1], o_ss_ch4_lavmm_ethe_wdata_0[0] }),
		.o_ss_lavmm_ethe_write(o_ss_ch4_lavmm_ethe_write_0),
		.o_ss_lavmm_pcie_addr({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[16], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[15], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[14], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_addr_0[0] }),
		.o_ss_lavmm_pcie_be({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_be_0[0] }),
		.o_ss_lavmm_pcie_clk(x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_clk_1),
		.o_ss_lavmm_pcie_read(x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_read_1),
		.o_ss_lavmm_pcie_rstn(x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_rstn_1),
		.o_ss_lavmm_pcie_wdata({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[31], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[30], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[29], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[28], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[27], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[26], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[25], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[24], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[23], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[22], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[21], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[20], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[19], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[18], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[17], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[16], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[15], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[14], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_wdata_0[0] }),
		.o_ss_lavmm_pcie_write(x_std_sm_hssi_pld_chnl_dp_0__o_ss_lavmm_pcie_write_1),
		.o_ss_pcie_ctrl_tx_async({ tmp_141, tmp_142, tmp_143, tmp_144, tmp_145, tmp_146, tmp_147, tmp_148, tmp_149, tmp_150, tmp_151, tmp_152, tmp_153, tmp_154, tmp_155, tmp_156, tmp_157, tmp_158, tmp_159, tmp_160, tmp_161, tmp_162, tmp_163, tmp_164, tmp_165, tmp_166, tmp_167, tmp_168, tmp_169, tmp_170, tmp_171, tmp_172, tmp_173, tmp_174, tmp_175, tmp_176, tmp_177, tmp_178, tmp_179, tmp_180, tmp_181, tmp_182, tmp_183, tmp_184, tmp_185, tmp_186, tmp_187, tmp_188, tmp_189, tmp_190, tmp_191, tmp_192, tmp_193, tmp_194, tmp_195, tmp_196, tmp_197, tmp_198, tmp_199, tmp_200, tmp_201, tmp_202, tmp_203, tmp_204, tmp_205, tmp_206, tmp_207, tmp_208, tmp_209, tmp_210, tmp_211, tmp_212, tmp_213, tmp_214, tmp_215, tmp_216, tmp_217, tmp_218, tmp_219, tmp_220, tmp_221, tmp_222, tmp_223, tmp_224, tmp_225, tmp_226, tmp_227, tmp_228 }),
		.o_ss_pcie_ctrl_tx_direct({ tmp_229, tmp_230, tmp_231, tmp_232, tmp_233, tmp_234, tmp_235, tmp_236 }),
		.o_ss_pcie_rst_pld_clrhip(tmp_237),
		.o_ss_pcie_rst_pld_clrpcs(tmp_238),
		.o_ss_pcie_rst_pld_perstn(tmp_239),
		.o_ss_ptp_rst_n(tmp_240),
		.o_ss_rst_pld_adapter_deskew_rx_pld_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_rx_pld_rst_n_1),
		.o_ss_rst_pld_adapter_deskew_tx_pld_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_adapter_deskew_tx_pld_rst_n_1),
		.o_ss_rst_pld_ready(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_pld_ready_1),
		.o_ss_rst_ux_rx_pma_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_pma_rst_n_1),
		.o_ss_rst_ux_rx_sfrz(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_rx_sfrz_1),
		.o_ss_rst_ux_tx_pma_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rst_ux_tx_pma_rst_n_1),
		.o_ss_rstfec_fec_csr_ret(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_csr_ret_1),
		.o_ss_rstfec_fec_rx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_rx_rst_n_1),
		.o_ss_rstfec_fec_tx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_fec_tx_rst_n_1),
		.o_ss_rstfec_rx_fec_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_rx_fec_sfrz_n_1),
		.o_ss_rstfec_tx_fec_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstfec_tx_fec_sfrz_n_1),
		.o_ss_rstxcvrif_rx_xcvrif_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_rx_xcvrif_sfrz_n_1),
		.o_ss_rstxcvrif_tx_xcvrif_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_tx_xcvrif_sfrz_n_1),
		.o_ss_rstxcvrif_xcvrif_rx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_rx_rst_n_1),
		.o_ss_rstxcvrif_xcvrif_signal_ok(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_signal_ok_1),
		.o_ss_rstxcvrif_xcvrif_tx_rst_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_rstxcvrif_xcvrif_tx_rst_n_1),
		.o_ss_sfreeze_2_r03f_rx_mac_srfz_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_2_r03f_rx_mac_srfz_n_1),
		.o_ss_sfreeze_3_c2f_tx_deskew_srfz_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_sfreeze_3_c2f_tx_deskew_srfz_n_1),
		.o_ss_t03f_sfreeze_1_tx_pcs_sfrz_n(x_std_sm_hssi_pld_chnl_dp_0__o_ss_t03f_sfreeze_1_tx_pcs_sfrz_n_1),
		.o_ss_tx_fifo_data({ o_ss_tx_fifo_data_4[79], o_ss_tx_fifo_data_4[78], o_ss_tx_fifo_data_4[77], o_ss_tx_fifo_data_4[76], o_ss_tx_fifo_data_4[75], o_ss_tx_fifo_data_4[74], o_ss_tx_fifo_data_4[73], o_ss_tx_fifo_data_4[72], o_ss_tx_fifo_data_4[71], o_ss_tx_fifo_data_4[70], o_ss_tx_fifo_data_4[69], o_ss_tx_fifo_data_4[68], o_ss_tx_fifo_data_4[67], o_ss_tx_fifo_data_4[66], o_ss_tx_fifo_data_4[65], o_ss_tx_fifo_data_4[64], o_ss_tx_fifo_data_4[63], o_ss_tx_fifo_data_4[62], o_ss_tx_fifo_data_4[61], o_ss_tx_fifo_data_4[60], o_ss_tx_fifo_data_4[59], o_ss_tx_fifo_data_4[58], o_ss_tx_fifo_data_4[57], o_ss_tx_fifo_data_4[56], o_ss_tx_fifo_data_4[55], o_ss_tx_fifo_data_4[54], o_ss_tx_fifo_data_4[53], o_ss_tx_fifo_data_4[52], o_ss_tx_fifo_data_4[51], o_ss_tx_fifo_data_4[50], o_ss_tx_fifo_data_4[49], o_ss_tx_fifo_data_4[48], o_ss_tx_fifo_data_4[47], o_ss_tx_fifo_data_4[46], o_ss_tx_fifo_data_4[45], o_ss_tx_fifo_data_4[44], o_ss_tx_fifo_data_4[43], o_ss_tx_fifo_data_4[42], o_ss_tx_fifo_data_4[41], o_ss_tx_fifo_data_4[40], o_ss_tx_fifo_data_4[39], o_ss_tx_fifo_data_4[38], o_ss_tx_fifo_data_4[37], o_ss_tx_fifo_data_4[36], o_ss_tx_fifo_data_4[35], o_ss_tx_fifo_data_4[34], o_ss_tx_fifo_data_4[33], o_ss_tx_fifo_data_4[32], o_ss_tx_fifo_data_4[31], o_ss_tx_fifo_data_4[30], o_ss_tx_fifo_data_4[29], o_ss_tx_fifo_data_4[28], o_ss_tx_fifo_data_4[27], o_ss_tx_fifo_data_4[26], o_ss_tx_fifo_data_4[25], o_ss_tx_fifo_data_4[24], o_ss_tx_fifo_data_4[23], o_ss_tx_fifo_data_4[22], o_ss_tx_fifo_data_4[21], o_ss_tx_fifo_data_4[20], o_ss_tx_fifo_data_4[19], o_ss_tx_fifo_data_4[18], o_ss_tx_fifo_data_4[17], o_ss_tx_fifo_data_4[16], o_ss_tx_fifo_data_4[15], o_ss_tx_fifo_data_4[14], o_ss_tx_fifo_data_4[13], o_ss_tx_fifo_data_4[12], o_ss_tx_fifo_data_4[11], o_ss_tx_fifo_data_4[10], o_ss_tx_fifo_data_4[9], o_ss_tx_fifo_data_4[8], o_ss_tx_fifo_data_4[7], o_ss_tx_fifo_data_4[6], o_ss_tx_fifo_data_4[5], o_ss_tx_fifo_data_4[4], o_ss_tx_fifo_data_4[3], o_ss_tx_fifo_data_4[2], o_ss_tx_fifo_data_4[1], o_ss_tx_fifo_data_4[0] }),
		.o_ss_uxquad_async({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[79], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[78], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[77], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[76], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[75], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[74], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[73], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[72], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[71], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[70], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[69], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[68], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[67], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[66], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[65], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[64], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[63], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[62], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[61], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[60], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[59], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[58], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[57], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[56], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[55], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[54], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[53], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[52], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[51], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[50], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[49], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[48], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[47], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[46], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[45], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[44], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[43], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[42], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[41], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[40], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[39], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[38], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[37], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[36], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[35], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[34], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[33], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[32], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[31], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[30], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[29], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[28], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[27], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[26], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[25], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[24], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[23], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[22], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[21], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[20], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[19], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[18], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[17], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[16], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[15], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[14], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_0[0] }),
		.o_ss_uxquad_async_pcie_mux({ x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[79], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[78], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[77], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[76], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[75], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[74], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[73], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[72], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[71], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[70], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[69], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[68], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[67], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[66], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[65], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[64], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[63], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[62], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[61], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[60], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[59], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[58], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[57], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[56], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[55], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[54], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[53], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[52], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[51], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[50], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[49], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[48], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[47], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[46], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[45], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[44], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[43], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[42], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[41], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[40], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[39], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[38], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[37], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[36], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[35], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[34], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[33], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[32], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[31], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[30], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[29], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[28], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[27], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[26], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[25], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[24], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[23], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[22], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[21], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[20], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[19], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[18], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[17], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[16], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[15], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[14], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[13], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[12], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[11], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[10], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[9], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[8], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[7], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[6], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[5], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[4], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[3], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[2], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[1], x_std_sm_hssi_pld_chnl_dp_0__o_ss_uxquad_async_pcie_mux_0[0] })
	);

endmodule
