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


//Quartus Warnings
(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)

// tennm_sm_hssi_pld_chnl_dp_sip_atom.sv ==========================================================
// To be added before the module definition

`define interpose_connection(mux_type) \
    tileip_interpose_module=`"tennm_sm_hssi_pld_chnl_dp_sip_atom_mux_``mux_type```", \
    tileip_interpose_instance=`"tennm_sm_hssi_pld_chnl_dp_sip_atom_mux_``mux_type``_ch${tileip_net_channel_location}`", \
    tileip_interpose_dst_port=`"d_${port_name}${port_select[0]}`", \
    tileip_interpose_src_port=`"${port_name}[${ip_local_id}]${port_select[0]}`"

`define merge_param(type, op, param_name) \
    tileip_merge_type_of_``param_name``=`"``type```", \
    tileip_merge_op_of_``param_name``=`"``op```"

`define MUX__RX `interpose_connection(rx)
`define MUX__TX `interpose_connection(tx)
`define MUX__TX_RX `interpose_connection(tx_rx)
`define ARBITER `interpose_connection(arbiter)
`define ARBITER__USE_ONE `interpose_connection(arbiter)
`define DIRECT direct
`define SRC_SRC short
`define SRC_DR_CTLR export_to_top
`define SRC_SSS export_to_top
`define SIP sip
`define DR_CTLR export_to_top
`define MASTER_CLK short

`define ATTR_DS_MERGE__TX(param_name)       `merge_param(tx,  copy,     param_name)
`define ATTR_DS_MERGE__RX(param_name)       `merge_param(rx,  copy,     param_name)
`define ATTR_DS_MERGE__TX_RX(param_name)    `merge_param(all, same,     param_name)
`define ATTR_DS_MERGE__COMPUTE(param_name)  `merge_param(all, special,  param_name)

// -----------------------------------------------------------------------------------------------

(*
    common_sip,
    `ATTR_DS_MERGE__COMPUTE(NUM_LANES),
    `ATTR_DS_MERGE__TX(TX_ENABLE),
    `ATTR_DS_MERGE__RX(RX_ENABLE),
    `ATTR_DS_MERGE__TX(TX_INITIATOR),
    `ATTR_DS_MERGE__RX(RX_INITIATOR),
    `ATTR_DS_MERGE__TX(TX_INITIATOR_INDEX),
    `ATTR_DS_MERGE__RX(RX_INITIATOR_INDEX),
    `ATTR_DS_MERGE__TX(TX_TARGET_ENABLE),
    `ATTR_DS_MERGE__RX(RX_TARGET_ENABLE),
    `ATTR_DS_MERGE__RX(RX_LANE_FUCTIONAL_MODE),
    `ATTR_DS_MERGE__TX(TX_LANE_FUCTIONAL_MODE),
    `ATTR_DS_MERGE__TX_RX(NON_PTP_CHANNEL),
    `ATTR_DS_MERGE__RX(RX_PCS_EN),
    `ATTR_DS_MERGE__TX(TX_PCS_EN),
    `ATTR_DS_MERGE__TX_RX(UX_EN),
    `ATTR_DS_MERGE__RX(RX_DL_EN),
    `ATTR_DS_MERGE__TX(TX_DL_EN),
    `ATTR_DS_MERGE__RX(FLUX_USED_FOR_RX_ADAPTATION),
    `ATTR_DS_MERGE__TX_RX(PTP_EN),
    `ATTR_DS_MERGE__RX(RX_FEC_EN),
    `ATTR_DS_MERGE__TX(TX_FEC_EN),
    `ATTR_DS_MERGE__TX_RX(ETHERNET_SYSPLL_CLK_MODE),
    `ATTR_DS_MERGE__TX_RX(UX_USING_SYSPLL_CLK),
    `ATTR_DS_MERGE__TX_RX(FLUX_USING_SYSPLL_CLK),
    `ATTR_DS_MERGE__TX_RX(FLUX_EN),
    `ATTR_DS_MERGE__TX_RX(SRC_LANE_INDEX),
    `ATTR_DS_MERGE__TX(LEADER_LANE),
    `ATTR_DS_MERGE__TX_RX(SIM_SCALE_DOWN)
*)
module tennm_sm_hssi_pld_chnl_dp_sip_atom
#(
    /* `ATTR_DS_MERGE__COMPUTE   */ parameter int                                   NUM_LANES                                        = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   TX_ENABLE                                        = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   RX_ENABLE                                        = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   TX_INITIATOR                                     = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   RX_INITIATOR                                     = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   TX_INITIATOR_INDEX                               = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   RX_INITIATOR_INDEX                               = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   TX_TARGET_ENABLE                                 = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   RX_TARGET_ENABLE                                 = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   RX_LANE_FUCTIONAL_MODE                           = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   TX_LANE_FUCTIONAL_MODE                           = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   NON_PTP_CHANNEL                                  = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   RX_PCS_EN                                        = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   TX_PCS_EN                                        = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   UX_EN                                            = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   RX_DL_EN                                         = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   TX_DL_EN                                         = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   FLUX_USED_FOR_RX_ADAPTATION                      = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   PTP_EN                                           = -1,
    /* `ATTR_DS_MERGE__RX        */ parameter int                                   RX_FEC_EN                                        = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   TX_FEC_EN                                        = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   ETHERNET_SYSPLL_CLK_MODE                         = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   UX_USING_SYSPLL_CLK                              = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   FLUX_USING_SYSPLL_CLK                            = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   FLUX_EN                                          = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   SRC_LANE_INDEX                                   = -1,
    /* `ATTR_DS_MERGE__TX        */ parameter int                                   LEADER_LANE                                      = -1,
    /* `ATTR_DS_MERGE__TX_RX     */ parameter int                                   SIM_SCALE_DOWN                                   = -1
)
(
    (* `MUX__RX                  *) input                                           i_hio_det_lat_rx_dl_clk,
    (* `MUX__RX                  *) input                                           i_hio_det_lat_rx_mux_select,
    (* `MUX__RX                  *) input                                           i_hio_det_lat_rx_sclk_flop,
    (* `MUX__RX                  *) input                                           i_hio_det_lat_rx_sclk_gen_clk,
    (* `MUX__RX                  *) input                                           i_hio_det_lat_rx_trig_flop,
    (* `ARBITER__USE_ONE         *) input                                           i_hio_det_lat_sampling_clk,
    (* `MUX__TX                  *) input                                           i_hio_det_lat_tx_dl_clk,
    (* `MUX__TX                  *) input                                           i_hio_det_lat_tx_mux_select,
    (* `MUX__TX                  *) input                                           i_hio_det_lat_tx_sclk_flop,
    (* `MUX__TX                  *) input                                           i_hio_det_lat_tx_sclk_gen_clk,
    (* `MUX__TX                  *) input                                           i_hio_det_lat_tx_trig_flop,
    (* `MUX__RX                  *) input                                           i_hio_ehip_signal_ok,
    (* `ARBITER                  *) input           [20:0]                          i_hio_lavmm_addr,
    (* `ARBITER                  *) input           [3:0]                           i_hio_lavmm_be,
    (* `ARBITER                  *) input                                           i_hio_lavmm_clk,
    (* `ARBITER                  *) input                                           i_hio_lavmm_read,
    (* `ARBITER                  *) input                                           i_hio_lavmm_rstn,
    (* `ARBITER                  *) input           [31:0]                          i_hio_lavmm_wdata,
    (* `ARBITER                  *) input                                           i_hio_lavmm_write,
    (* `MUX__RX                  *) input                                           i_hio_pld_rx_clk_in_row_clk,
    (* `MUX__TX                  *) input                                           i_hio_pld_tx_clk_in_row_clk,
    (* `MUX__RX                  *) input                                           i_hio_rxdata_fifo_rd_en,
    (* `MUX__TX                  *) input           [79:0]                          i_hio_txdata,
    (* `MUX__TX                  *) input           [9:0]                           i_hio_txdata_direct,
    (* `MUX__TX                  *) input           [9:0]                           i_hio_txdata_extra,
    (* `MUX__TX                  *) input                                           i_hio_txdata_fifo_wr_en,
    (* `MUX__RX                  *) output                                          o_hio_det_lat_rx_async_dl_sync,
    (* `MUX__RX                  *) output                                          o_hio_det_lat_rx_async_pulse,
    (* `MUX__RX                  *) output                                          o_hio_det_lat_rx_async_sample_sync,
    (* `MUX__RX                  *) output                                          o_hio_det_lat_rx_sclk_sample_sync,
    (* `MUX__RX                  *) output                                          o_hio_det_lat_rx_trig_sample_sync,
    (* `MUX__TX                  *) output                                          o_hio_det_lat_tx_async_dl_sync,
    (* `MUX__TX                  *) output                                          o_hio_det_lat_tx_async_pulse,
    (* `MUX__TX                  *) output                                          o_hio_det_lat_tx_async_sample_sync,
    (* `MUX__TX                  *) output                                          o_hio_det_lat_tx_sclk_sample_sync,
    (* `MUX__TX                  *) output                                          o_hio_det_lat_tx_trig_sample_sync,
    (* `ARBITER                  *) output          [31:0]                          o_hio_lavmm_rdata,
    (* `ARBITER                  *) output                                          o_hio_lavmm_rdata_valid,
    (* `ARBITER                  *) output                                          o_hio_lavmm_waitreq,
    (* `MUX__TX_RX               *) output                                          o_hio_rst_flux0_cpi_cmn_busy,
    (* `MUX__RX                  *) output                                          o_hio_rst_oflux_rx_srds_rdy,
    (* `MUX__TX_RX               *) output                                          o_hio_rst_ux_all_synthlockstatus,
    (* `MUX__RX                  *) output                                          o_hio_rst_ux_octl_pcs_rxstatus,
    (* `MUX__TX                  *) output                                          o_hio_rst_ux_octl_pcs_txstatus,
    (* `MUX__RX                  *) output                                          o_hio_rst_ux_rxcdrlock2data,
    (* `MUX__RX                  *) output                                          o_hio_rst_ux_rxcdrlockstatus,
    (* `MUX__RX                  *) output                                          o_hio_rstepcs_rx_pcs_fully_aligned,
    (* `MUX__RX                  *) output                                          o_hio_rstfec_fec_rx_rdy_n,
    (* `MUX__RX                  *) output          [79:0]                          o_hio_rxdata,
    (* `MUX__RX                  *) output          [9:0]                           o_hio_rxdata_direct,
    (* `MUX__RX                  *) output          [9:0]                           o_hio_rxdata_extra,
    (* `MUX__RX                  *) output                                          o_hio_rxdata_fifo_rd_empty,
    (* `MUX__RX                  *) output                                          o_hio_rxdata_fifo_rd_full,
    (* `MUX__RX                  *) output                                          o_hio_rxdata_fifo_rd_pempty,
    (* `MUX__RX                  *) output                                          o_hio_rxdata_fifo_rd_pfull,
    (* `MUX__TX                  *) output                                          o_hio_txdata_fifo_wr_empty,
    (* `MUX__TX                  *) output                                          o_hio_txdata_fifo_wr_full,
    (* `MUX__TX                  *) output                                          o_hio_txdata_fifo_wr_pempty,
    (* `MUX__TX                  *) output                                          o_hio_txdata_fifo_wr_pfull,
    (* `MUX__RX                  *) output                                          o_hio_user_rx_clk1_clk,
    (* `MUX__RX                  *) output                                          o_hio_user_rx_clk2_clk,
    (* `MUX__TX                  *) output                                          o_hio_user_tx_clk1_clk,
    (* `MUX__TX                  *) output                                          o_hio_user_tx_clk2_clk,
    (* `MUX__TX                  *) output                                          o_hio_ux_chnl_refclk_mux,
    (* `MUX__TX                  *) output                                          o_hio_ux_tx_ch_ptr_smpl,
    (* `MUX__RX                  *) output                                          o_hio_xcvrif_rx_latency_pulse,
    (* `MUX__TX                  *) output                                          o_hio_xcvrif_tx_latency_pulse,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_rx_dl_clk,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_rx_mux_select,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_rx_sclk_flop,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_rx_sclk_gen_clk,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_rx_trig_flop,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_sampling_clk,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_tx_dl_clk,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_tx_mux_select,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_tx_sclk_flop,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_tx_sclk_gen_clk,
    (* `DIRECT                   *) output                                          d_i_hio_det_lat_tx_trig_flop,
    (* `DIRECT                   *) output                                          d_i_hio_ehip_rx_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_ehip_signal_ok,
    (* `DIRECT                   *) output                                          d_i_hio_ehip_tx_rst_n,
    (* `DIRECT                   *) output          [20:0]                          d_i_hio_lavmm_addr,
    (* `DIRECT                   *) output          [3:0]                           d_i_hio_lavmm_be,
    (* `DIRECT                   *) output                                          d_i_hio_lavmm_clk,
    (* `DIRECT                   *) output                                          d_i_hio_lavmm_read,
    (* `DIRECT                   *) output                                          d_i_hio_lavmm_rstn,
    (* `DIRECT                   *) output          [31:0]                          d_i_hio_lavmm_wdata,
    (* `DIRECT                   *) output                                          d_i_hio_lavmm_write,
    (* `DIRECT                   *) output                                          d_i_hio_pld_reset_clk_row,
    (* `DIRECT                   *) output                                          d_i_hio_pld_rx_clk_in_row_clk,
    (* `DIRECT                   *) output                                          d_i_hio_pld_tx_clk_in_row_clk,
    (* `DIRECT                   *) output                                          d_i_hio_ptp_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rst_pld_adapter_rx_pld_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rst_pld_adapter_tx_pld_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rst_pld_clrhip,
    (* `DIRECT                   *) output                                          d_i_hio_rst_pld_clrpcs,
    (* `DIRECT                   *) output                                          d_i_hio_rst_pld_perstn,
    (* `DIRECT                   *) output                                          d_i_hio_rst_pld_ready,
    (* `DIRECT                   *) output                                          d_i_hio_rst_ux_rx_pma_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rst_ux_rx_sfrz,
    (* `DIRECT                   *) output                                          d_i_hio_rst_ux_tx_pma_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rstfec_fec_csr_ret,
    (* `DIRECT                   *) output                                          d_i_hio_rstfec_fec_rx_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rstfec_fec_tx_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rstfec_rx_fec_sfrz_n,
    (* `DIRECT                   *) output                                          d_i_hio_rstfec_tx_fec_sfrz_n,
    (* `DIRECT                   *) output                                          d_i_hio_rstxcvrif_rx_xcvrif_sfrz_n,
    (* `DIRECT                   *) output                                          d_i_hio_rstxcvrif_tx_xcvrif_sfrz_n,
    (* `DIRECT                   *) output                                          d_i_hio_rstxcvrif_xcvrif_rx_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rstxcvrif_xcvrif_signal_ok,
    (* `DIRECT                   *) output                                          d_i_hio_rstxcvrif_xcvrif_tx_rst_n,
    (* `DIRECT                   *) output                                          d_i_hio_rxdata_fifo_rd_en,
    (* `DIRECT                   *) output                                          d_i_hio_sfreeze_2_r03f_rx_mac_srfz_n,
    (* `DIRECT                   *) output                                          d_i_hio_sfreeze_3_c2f_tx_deskew_srfz_n,
    (* `DIRECT                   *) output                                          d_i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n,
    (* `DIRECT                   *) output          [79:0]                          d_i_hio_txdata,
    (* `DIRECT                   *) output          [99:0]                          d_i_hio_txdata_async,
    (* `DIRECT                   *) output          [9:0]                           d_i_hio_txdata_direct,
    (* `DIRECT                   *) output          [9:0]                           d_i_hio_txdata_extra,
    (* `DIRECT                   *) output                                          d_i_hio_txdata_fifo_wr_en,
    (* `DIRECT                   *) output          [79:0]                          d_i_hio_uxquad_async,
    (* `DIRECT                   *) output          [79:0]                          d_i_hio_uxquad_async_pcie_mux,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_rx_async_dl_sync,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_rx_async_pulse,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_rx_async_sample_sync,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_rx_sclk_sample_sync,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_rx_trig_sample_sync,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_tx_async_dl_sync,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_tx_async_pulse,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_tx_async_sample_sync,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_tx_sclk_sample_sync,
    (* `DIRECT                   *) input                                           d_o_hio_det_lat_tx_trig_sample_sync,
    (* `DIRECT                   *) input           [31:0]                          d_o_hio_lavmm_rdata,
    (* `DIRECT                   *) input                                           d_o_hio_lavmm_rdata_valid,
    (* `DIRECT                   *) input                                           d_o_hio_lavmm_waitreq,
    (* `DIRECT                   *) input                                           d_o_hio_rst_flux0_cpi_cmn_busy,
    (* `DIRECT                   *) input                                           d_o_hio_rst_oflux_rx_srds_rdy,
    (* `DIRECT                   *) input                                           d_o_hio_rst_ux_all_synthlockstatus,
    (* `DIRECT                   *) input                                           d_o_hio_rst_ux_octl_pcs_rxstatus,
    (* `DIRECT                   *) input                                           d_o_hio_rst_ux_octl_pcs_txstatus,
    (* `DIRECT                   *) input                                           d_o_hio_rst_ux_rxcdrlock2data,
    (* `DIRECT                   *) input                                           d_o_hio_rst_ux_rxcdrlockstatus,
    (* `DIRECT                   *) input                                           d_o_hio_rstepcs_rx_pcs_fully_aligned,
    (* `DIRECT                   *) input                                           d_o_hio_rstfec_fec_rx_rdy_n,
    (* `DIRECT                   *) input           [79:0]                          d_o_hio_rxdata,
    (* `DIRECT                   *) input           [99:0]                          d_o_hio_rxdata_async,
    (* `DIRECT                   *) input           [9:0]                           d_o_hio_rxdata_direct,
    (* `DIRECT                   *) input           [9:0]                           d_o_hio_rxdata_extra,
    (* `DIRECT                   *) input                                           d_o_hio_rxdata_fifo_rd_empty,
    (* `DIRECT                   *) input                                           d_o_hio_rxdata_fifo_rd_full,
    (* `DIRECT                   *) input                                           d_o_hio_rxdata_fifo_rd_pempty,
    (* `DIRECT                   *) input                                           d_o_hio_rxdata_fifo_rd_pfull,
    (* `DIRECT                   *) input                                           d_o_hio_txdata_fifo_wr_empty,
    (* `DIRECT                   *) input                                           d_o_hio_txdata_fifo_wr_full,
    (* `DIRECT                   *) input                                           d_o_hio_txdata_fifo_wr_pempty,
    (* `DIRECT                   *) input                                           d_o_hio_txdata_fifo_wr_pfull,
    (* `DIRECT                   *) input                                           d_o_hio_user_rx_clk1_clk,
    (* `DIRECT                   *) input                                           d_o_hio_user_rx_clk2_clk,
    (* `DIRECT                   *) input                                           d_o_hio_user_tx_clk1_clk,
    (* `DIRECT                   *) input                                           d_o_hio_user_tx_clk2_clk,
    (* `DIRECT                   *) input                                           d_o_hio_ux_chnl_refclk_mux,
    (* `DIRECT                   *) input                                           d_o_hio_ux_tx_ch_ptr_smpl,
    (* `DIRECT                   *) input           [49:0]                          d_o_hio_uxquad_async,
    (* `DIRECT                   *) input                                           d_o_hio_xcvrif_rx_latency_pulse,
    (* `DIRECT                   *) input                                           d_o_hio_xcvrif_tx_latency_pulse,
    (* `MUX__RX                  *) input           [79:0]                          i_hio_uxquad_async_rx,
    (* `MUX__TX                  *) input           [79:0]                          i_hio_uxquad_async_tx,
    (* `MUX__RX                  *) input           [79:0]                          i_hio_uxquad_async_pcie_mux_rx,
    (* `MUX__TX                  *) input           [79:0]                          i_hio_uxquad_async_pcie_mux_tx,
    (* `MUX__RX                  *) output          [49:0]                          o_hio_uxquad_async_rx,
    (* `MUX__TX                  *) output          [49:0]                          o_hio_uxquad_async_tx,
    (* `MUX__RX                  *) output          [99:0]                          o_hio_rxdata_async_rx,
    (* `MUX__TX                  *) output          [99:0]                          o_hio_rxdata_async_tx,
    (* `MUX__RX                  *) input           [99:0]                          i_hio_txdata_async_rx,
    (* `MUX__TX                  *) input           [99:0]                          i_hio_txdata_async_tx,
    (* `MUX__TX                  *) output          [1:0]                           tx_lane_current_state,
    (* `MUX__TX                  *) output                                          tx_alarm,
    (* `MUX__TX                  *) output                                          sip_am_gen_start,
    (* `MUX__RX                  *) output          [1:0]                           rx_lane_current_state,
    (* `MUX__RX                  *) output                                          rx_alarm,
    (* `MUX__RX                  *) output                                          sip_freeze_rx_acknowledge,
    (* `MUX__TX                  *) output                                          sip_freeze_tx_acknowledge,
    (* `MUX__RX                  *) output                                          iflux_ingress_direct_231,
    (* `MUX__TX                  *) input                                           tx_clear_alarm,
    (* `MUX__RX                  *) input                                           rx_clear_alarm,
    (* `MUX__TX                  *) input                                           tx_lane_desired_state,
    (* `MUX__RX                  *) input                                           rx_lane_desired_state,
    (* `MUX__RX                  *) input                                           sip_rx_ignore_lock2data,
    (* `MUX__TX                  *) input                                           sip_freeze_tx_SRC_sequence,
    (* `MUX__RX                  *) input                                           sip_freeze_rx_SRC_sequence,
    (* `MUX__TX                  *) input                                           sip_am_gen_2x_ack,
    (* `SRC_DR_CTLR              *) input                                           pause_request,
    (* `SRC_DR_CTLR              *) output                                          pause_grant,
    (* `SRC_SSS                  *) output                                          sss_request,
    (* `SRC_SSS                  *) input                                           sss_grant,
    (* `ARBITER__USE_ONE         *) input                                           i_spll_lock,
    (* `ARBITER__USE_ONE         *) output                                          ptp_pld_adapter_tx_pld_rst_n,
    (* `ARBITER__USE_ONE         *) output                                          ptp_pld_adapter_rx_pld_rst_n,
    (* `ARBITER__USE_ONE         *) output                                          ptp_pld_ready,
    (* `SRC_SRC                  *) inout           [NUM_LANES*NUM_LANES-1:0]       io_sl2l_trigger_or_error_resp,
    (* `SRC_SRC                  *) inout           [NUM_LANES*NUM_LANES-1:0]       io_sl2l_desired_state_or_ready,
    (* `SRC_SRC                  *) inout           [NUM_LANES*NUM_LANES-1:0]       io_sl2l_tx_rx,
    (* `SRC_SRC                  *) inout           [NUM_LANES-1:0]                 io_addr_gen_common_block_rst_done_reg
);

`ifndef __TILE_IP__

wire [NUM_LANES-1:0] w_i_sl2l_trigger_or_error_resp;
wire [NUM_LANES-1:0] w_o_sl2l_trigger_or_error_resp;
wire [NUM_LANES-1:0] w_i_sl2l_desired_state_or_ready;
wire [NUM_LANES-1:0] w_o_sl2l_desired_state_or_ready;
wire [NUM_LANES-1:0] w_i_sl2l_tx_rx;
wire [NUM_LANES-1:0] w_o_sl2l_tx_rx;
wire w_o_addr_gen_common_block_rst_done_reg;
wire [NUM_LANES-1:0] w_i_addr_gen_common_block_rst_done_reg;

assign d_i_hio_lavmm_clk                  = i_hio_lavmm_clk;
assign d_i_hio_lavmm_rstn                 = i_hio_lavmm_rstn;

assign d_i_hio_pld_rx_clk_in_row_clk      = i_hio_pld_rx_clk_in_row_clk;
assign d_i_hio_pld_tx_clk_in_row_clk      = i_hio_pld_tx_clk_in_row_clk;
assign d_i_hio_det_lat_rx_dl_clk          = i_hio_det_lat_rx_dl_clk;
assign d_i_hio_det_lat_rx_mux_select      = i_hio_det_lat_rx_mux_select;
assign d_i_hio_det_lat_rx_sclk_flop       = i_hio_det_lat_rx_sclk_flop;
assign d_i_hio_det_lat_rx_sclk_gen_clk    = i_hio_det_lat_rx_sclk_gen_clk;
assign d_i_hio_det_lat_rx_trig_flop       = i_hio_det_lat_rx_trig_flop;
assign d_i_hio_det_lat_sampling_clk       = i_hio_det_lat_sampling_clk;
assign d_i_hio_det_lat_tx_dl_clk          = i_hio_det_lat_tx_dl_clk;
assign d_i_hio_det_lat_tx_mux_select      = i_hio_det_lat_tx_mux_select;
assign d_i_hio_det_lat_tx_sclk_flop       = i_hio_det_lat_tx_sclk_flop;
assign d_i_hio_det_lat_tx_sclk_gen_clk    = i_hio_det_lat_tx_sclk_gen_clk;
assign d_i_hio_det_lat_tx_trig_flop       = i_hio_det_lat_tx_trig_flop;

assign o_hio_user_rx_clk1_clk             = d_o_hio_user_rx_clk1_clk;                         
assign o_hio_user_rx_clk2_clk             = d_o_hio_user_rx_clk2_clk;                         
assign o_hio_user_tx_clk1_clk             = d_o_hio_user_tx_clk1_clk;                         
assign o_hio_user_tx_clk2_clk             = d_o_hio_user_tx_clk2_clk;                         
assign o_hio_ux_chnl_refclk_mux           = d_o_hio_ux_chnl_refclk_mux;                           
assign o_hio_det_lat_rx_async_dl_sync     = d_o_hio_det_lat_rx_async_dl_sync;                                 
assign o_hio_det_lat_rx_async_pulse       = d_o_hio_det_lat_rx_async_pulse;                               
assign o_hio_det_lat_rx_async_sample_sync = d_o_hio_det_lat_rx_async_sample_sync;                                     
assign o_hio_det_lat_rx_sclk_sample_sync  = d_o_hio_det_lat_rx_sclk_sample_sync;                                    
assign o_hio_det_lat_rx_trig_sample_sync  = d_o_hio_det_lat_rx_trig_sample_sync;                                    
assign o_hio_det_lat_tx_async_dl_sync     = d_o_hio_det_lat_tx_async_dl_sync;                                 
assign o_hio_det_lat_tx_async_pulse       = d_o_hio_det_lat_tx_async_pulse;                               
assign o_hio_det_lat_tx_async_sample_sync = d_o_hio_det_lat_tx_async_sample_sync;                                     
assign o_hio_det_lat_tx_sclk_sample_sync  = d_o_hio_det_lat_tx_sclk_sample_sync;                                    
assign o_hio_det_lat_tx_trig_sample_sync  = d_o_hio_det_lat_tx_trig_sample_sync;                                    
assign o_hio_xcvrif_rx_latency_pulse      = d_o_hio_xcvrif_rx_latency_pulse;                                
assign o_hio_xcvrif_tx_latency_pulse      = d_o_hio_xcvrif_tx_latency_pulse;   

assign d_i_hio_txdata                     = i_hio_txdata;                                          
assign d_i_hio_txdata_extra               = i_hio_txdata_extra;                                          
assign d_i_hio_txdata_fifo_wr_en          = i_hio_txdata_fifo_wr_en;                                          
assign d_i_hio_rxdata_fifo_rd_en          = i_hio_rxdata_fifo_rd_en;                                          
assign d_i_hio_uxquad_async               = i_hio_uxquad_async_rx | i_hio_uxquad_async_tx;                                          
assign d_i_hio_uxquad_async_pcie_mux      = i_hio_uxquad_async_pcie_mux_rx | i_hio_uxquad_async_pcie_mux_tx;                                          
assign o_hio_txdata_fifo_wr_empty         = d_o_hio_txdata_fifo_wr_empty;                                 
assign o_hio_txdata_fifo_wr_pempty        = d_o_hio_txdata_fifo_wr_pempty;                                  
assign o_hio_txdata_fifo_wr_full          = d_o_hio_txdata_fifo_wr_full;                                
assign o_hio_txdata_fifo_wr_pfull         = d_o_hio_txdata_fifo_wr_pfull;                                 
assign o_hio_rxdata                       = d_o_hio_rxdata;                   
assign o_hio_rxdata_extra                 = d_o_hio_rxdata_extra;                         
assign o_hio_rxdata_fifo_rd_empty         = d_o_hio_rxdata_fifo_rd_empty;                                 
assign o_hio_rxdata_fifo_rd_pempty        = d_o_hio_rxdata_fifo_rd_pempty;                                  
assign o_hio_rxdata_fifo_rd_full          = d_o_hio_rxdata_fifo_rd_full;                                
assign o_hio_rxdata_fifo_rd_pfull         = d_o_hio_rxdata_fifo_rd_pfull;                                 
assign d_i_hio_txdata_async               = i_hio_txdata_async_rx | i_hio_txdata_async_tx;                                          
assign d_i_hio_txdata_direct              = i_hio_txdata_direct;                                          
assign o_hio_rxdata_direct                = d_o_hio_rxdata_direct;                          
assign o_hio_rstfec_fec_rx_rdy_n          = d_o_hio_rstfec_fec_rx_rdy_n;                                
assign o_hio_rst_ux_octl_pcs_rxstatus     = d_o_hio_rst_ux_octl_pcs_rxstatus;                                  
assign o_hio_rst_ux_octl_pcs_txstatus     = d_o_hio_rst_ux_octl_pcs_txstatus;                                 
assign o_hio_rst_ux_all_synthlockstatus   = d_o_hio_rst_ux_all_synthlockstatus;                                   
assign o_hio_rst_ux_rxcdrlock2data        = d_o_hio_rst_ux_rxcdrlock2data;                               
assign o_hio_rst_ux_rxcdrlockstatus       = d_o_hio_rst_ux_rxcdrlockstatus;        
assign d_i_hio_ehip_signal_ok             = i_hio_ehip_signal_ok;
assign o_hio_ux_tx_ch_ptr_smpl            = d_o_hio_ux_tx_ch_ptr_smpl;

//Splitting uxquad and rxdata signals
assign o_hio_uxquad_async_rx = {{10{1'b0}},d_o_hio_uxquad_async[39:37],{2{1'b0}},d_o_hio_uxquad_async[34:0]};
assign o_hio_uxquad_async_tx = {{11{1'b0}},d_o_hio_uxquad_async[38:34],{34{1'b0}}};

assign o_hio_rxdata_async_rx = {{23{1'b0}},d_o_hio_rxdata_async[76],1'b0,d_o_hio_rxdata_async[74],1'b0,d_o_hio_rxdata_async[72:70],{8{1'b0}},d_o_hio_rxdata_async[61:57],{9{1'b0}},d_o_hio_rxdata_async[47:42],{3{1'b0}},d_o_hio_rxdata_async[38:28],{28{1'b0}}};
assign o_hio_rxdata_async_tx = {{23{1'b0}},d_o_hio_rxdata_async[76:75],{1'b0},d_o_hio_rxdata_async[73],{3{1'b0}},d_o_hio_rxdata_async[69:68],{11{1'b0}},d_o_hio_rxdata_async[56],{44{1'b0}},d_o_hio_rxdata_async[11:8],{8{1'b0}}};


assign d_i_hio_rst_pld_clrhip = 'z;
assign d_i_hio_rst_pld_clrpcs = 'z;
assign d_i_hio_rst_pld_perstn = 'z;


//Slave : HAL - SRC (DR) AVMM Decoder

localparam  SLAVE_NUM           = 2;
localparam  AVMM_ADDR_WIDTH     = 21;
localparam  AVMM_HAL_START_ADDR = 21'h2_0000;
localparam  AVMM_HAL_END_ADDR   = 21'hC_FFFC;
localparam  AVMM_SRC_START_ADDR = 21'h1_0000;
localparam  AVMM_SRC_END_ADDR   = 21'h1_FFFC;

// [0] = SRC, [1] = HAL
logic   [AVMM_ADDR_WIDTH-1:0]       slave_addr;
logic   [31:0]                      slave_writedata;
logic   [3:0]                       slave_byteenable;
logic   [SLAVE_NUM-1:0]             slave_read;
logic   [SLAVE_NUM-1:0]             slave_write;
logic   [SLAVE_NUM*32-1:0]          slave_readdata;
logic   [SLAVE_NUM-1:0]             slave_readdatavalid;
logic   [SLAVE_NUM-1:0]             slave_waitrequest;


ncss_avmm_decoder #(
  .SLAVE_NUM(SLAVE_NUM),
  .ADDR_WIDTH(AVMM_ADDR_WIDTH)
) avmm_decoder_src_hal (
  .clk (i_hio_lavmm_clk),
  .rst (~i_hio_lavmm_rstn),

  //---avmm master from Jtag---
  .master_addr             (i_hio_lavmm_addr       ),
  .master_read             (i_hio_lavmm_read       ),
  .master_write            (i_hio_lavmm_write      ),
  .master_writedata        (i_hio_lavmm_wdata      ),
  .master_byteenable       (i_hio_lavmm_be         ),
  .master_readdata         (o_hio_lavmm_rdata      ),
  .master_readdatavalid    (o_hio_lavmm_rdata_valid),
  .master_waitrequest      (o_hio_lavmm_waitreq    ),

  //---avmm slave IF to HW IP---
  .slave_addr              (slave_addr          ),
  .slave_read              (slave_read          ),
  .slave_write             (slave_write         ),
  .slave_writedata         (slave_writedata     ),
  .slave_byteenable        (slave_byteenable    ),
  .slave_readdata          (slave_readdata      ),
  .slave_readdatavalid     (slave_readdatavalid ),
  .slave_waitrequest       (slave_waitrequest   ),

  //---Ctrl IF---
  .slave_start_addr        ({AVMM_HAL_START_ADDR, AVMM_SRC_START_ADDR}),
  .slave_end_addr          ({AVMM_HAL_END_ADDR, AVMM_SRC_END_ADDR})
);  

//HAL LAVMM Ports connection
assign d_i_hio_lavmm_addr       = slave_addr;
assign d_i_hio_lavmm_be         = slave_byteenable;
assign d_i_hio_lavmm_read       = slave_read[1];
assign d_i_hio_lavmm_write      = slave_write[1];
assign d_i_hio_lavmm_wdata      = slave_writedata;
assign slave_readdata[63:32]    = d_o_hio_lavmm_rdata;
assign slave_readdatavalid[1]   = d_o_hio_lavmm_rdata_valid;
assign slave_waitrequest[1]     = d_o_hio_lavmm_waitreq;



//-------------------------------------------------------------------------------------------------
// SRC Lane module instantiation based on QHIP configuration
//-------------------------------------------------------------------------------------------------
intel_src_lane #(
  //Parameters are unique to each SRC Lane , QHIP will share dedicated parameters to each SRC lane in QHIP
  .NUM_LANES                        ( NUM_LANES                             ),
  .TX_ENABLE                        ( TX_ENABLE                             ), 
  .RX_ENABLE                        ( RX_ENABLE                             ),     
  .TX_INITIATOR                     ( TX_INITIATOR                          ),
  .RX_INITIATOR                     ( RX_INITIATOR                          ),
  .TX_INITIATOR_INDEX               ( TX_INITIATOR_INDEX                    ),
  .RX_INITIATOR_INDEX               ( RX_INITIATOR_INDEX                    ),
  .TX_TARGET_ENABLE                 ( TX_TARGET_ENABLE                      ),
  .RX_TARGET_ENABLE                 ( RX_TARGET_ENABLE                      ),    
  .TX_LANE_FUCTIONAL_MODE           ( TX_LANE_FUCTIONAL_MODE                ),
  .RX_LANE_FUCTIONAL_MODE           ( RX_LANE_FUCTIONAL_MODE                ),
  .NON_PTP_CHANNEL                  ( NON_PTP_CHANNEL                       ),
  .TX_PCS_EN                        ( TX_PCS_EN                             ),
  .RX_PCS_EN                        ( RX_PCS_EN                             ),
  .UX_EN                            ( UX_EN                                 ),
  .TX_DL_EN                         ( TX_DL_EN                              ),
  .RX_DL_EN                         ( RX_DL_EN                              ),
  .FLUX_USED_FOR_RX_ADAPTATION      ( FLUX_USED_FOR_RX_ADAPTATION           ),
  .PTP_EN                           ( PTP_EN                                ),
  .TX_FEC_EN                        ( TX_FEC_EN                             ),
  .RX_FEC_EN                        ( RX_FEC_EN                             ),
  .ETHERNET_SYSPLL_CLK_MODE         ( ETHERNET_SYSPLL_CLK_MODE              ),
  .UX_USING_SYSPLL_CLK              ( UX_USING_SYSPLL_CLK                   ),
  .FLUX_USING_SYSPLL_CLK            ( FLUX_USING_SYSPLL_CLK                 ),
  .FLUX_EN                          ( FLUX_EN                               ),
  .SRC_LANE_INDEX                   ( SRC_LANE_INDEX                        ),
  .LEADER_LANE                      ( LEADER_LANE                           ),
  .SIM_SCALE_DOWN                   ( SIM_SCALE_DOWN                        )
) src_lane (
  //SRC Lane Control Interface with SIP (or DR MUX)
  .tx_lane_desired_state            (tx_lane_desired_state                  ),
  .tx_lane_current_state            (tx_lane_current_state                  ),                 
  .tx_alarm                         (tx_alarm                               ), 
  .tx_clear_alarm                   (tx_clear_alarm                         ),
  .rx_lane_desired_state            (rx_lane_desired_state                  ),
  .rx_lane_current_state            (rx_lane_current_state                  ),
  .rx_alarm                         (rx_alarm                               ),
  .rx_clear_alarm                   (rx_clear_alarm                         ),
  .sip_rx_ignore_lock2data          (sip_rx_ignore_lock2data                ),
  .sip_freeze_tx_SRC_sequence       (sip_freeze_tx_SRC_sequence             ),
  .sip_freeze_rx_SRC_sequence       (sip_freeze_rx_SRC_sequence             ),
  .sip_freeze_tx_acknowledge        (sip_freeze_tx_acknowledge              ),
  .sip_freeze_rx_acknowledge        (sip_freeze_rx_acknowledge              ),
  .sip_am_gen_start                 (sip_am_gen_start                       ),
  .sip_am_gen_2x_ack                (sip_am_gen_2x_ack                      ),
  //Reset/Status Interface to HIP
  // SRC Lane to HAL interfaaces
  .ptp_pld_adapter_tx_pld_rst_n     (ptp_pld_adapter_tx_pld_rst_n           ),                
  .ptp_pld_adapter_rx_pld_rst_n     (ptp_pld_adapter_rx_pld_rst_n           ),              
  .ptp_pld_ready                    (ptp_pld_ready                          ),      
  .ptp_rst_n                        (d_i_hio_ptp_rst_n                      ),
  .pld_adapter_tx_pld_rst_n         (d_i_hio_rst_pld_adapter_tx_pld_rst_n   ),             
  .pld_adapter_rx_pld_rst_n         (d_i_hio_rst_pld_adapter_rx_pld_rst_n   ),            
  .ehip_tx_rst_n                    (d_i_hio_ehip_tx_rst_n                  ),
  .ehip_rx_rst_n                    (d_i_hio_ehip_rx_rst_n                  ),
  .tx_pcs_sfrz_n                    (d_i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n   ),
  .rx_mac_deskew_sfrz_n             (d_i_hio_sfreeze_2_r03f_rx_mac_srfz_n   ),        
  .tx_deskew_sfrz_n                 (d_i_hio_sfreeze_3_c2f_tx_deskew_srfz_n ),     
  .fec_tx_rst_n                     (d_i_hio_rstfec_fec_tx_rst_n            ), 
  .fec_rx_rst_n                     (d_i_hio_rstfec_fec_rx_rst_n            ), 
  .fec_csr_ret                      (d_i_hio_rstfec_fec_csr_ret             ),  
  .tx_fec_sfrz_n                    (d_i_hio_rstfec_tx_fec_sfrz_n           ), 
  .rx_fec_sfrz_n                    (d_i_hio_rstfec_rx_fec_sfrz_n           ), 
  .xcvrif_tx_rst_n                  (d_i_hio_rstxcvrif_xcvrif_tx_rst_n      ),     
  .xcvrif_rx_rst_n                  (d_i_hio_rstxcvrif_xcvrif_rx_rst_n      ),     
  .tx_xcvrif_sfrz_n                 (d_i_hio_rstxcvrif_tx_xcvrif_sfrz_n     ),    
  .rx_xcvrif_sfrz_n                 (d_i_hio_rstxcvrif_rx_xcvrif_sfrz_n     ),    
  .xcvrif_signal_ok                 (d_i_hio_rstxcvrif_xcvrif_signal_ok     ),     
  .ux_tx_pma_rst_n                  (d_i_hio_rst_ux_tx_pma_rst_n            ),    
  .ux_rx_pma_rst_n                  (d_i_hio_rst_ux_rx_pma_rst_n            ),    
  .ux_rx_sfrz_n                     (d_i_hio_rst_ux_rx_sfrz                 ), 
  .iflux_ingress_direct_231         (iflux_ingress_direct_231               ),
  // .ehip_signal_ok                   (ehip_signal_ok                         ),
  .pld_ready                        (d_i_hio_rst_pld_ready                  ),
  // HAL to SRC Lane interfaaces
  .o_rx_pcs_fully_aligned           (d_o_hio_rstepcs_rx_pcs_fully_aligned   ),
  .ux_octl_pcs_txstatus             (d_o_hio_rst_ux_octl_pcs_txstatus       ),
  .ux_octl_pcs_rxstatus             (d_o_hio_rst_ux_octl_pcs_rxstatus       ),
  .ux_all_synthlockstatus           (d_o_hio_rst_ux_all_synthlockstatus     ),
  .ux_rxcdrlockstatus               (d_o_hio_rst_ux_rxcdrlockstatus         ),
  .ux_rxcdrlock2data                (d_o_hio_rst_ux_rxcdrlock2data          ),
  .flux_cpi_cmn_busy                (d_o_hio_rst_flux0_cpi_cmn_busy         ),
  .oflux_rx_srds_rdy                (d_o_hio_rst_oflux_rx_srds_rdy          ),
  .c0_syspll_lockstatus             (i_spll_lock                            ),   
  .c1_syspll_lockstatus             (i_spll_lock                            ),   
  .c2_syspll_lockstatus             (i_spll_lock                            ),   
  .o_fec_rx_rdy_n                   (d_o_hio_rstfec_fec_rx_rdy_n            ),
  .hip_ready                        (d_o_hio_rxdata_async[8]                ),
  //Inter SRC Lane Interface  
  .i_sl2l_trigger_or_error_resp     (w_i_sl2l_trigger_or_error_resp         ),
  .i_sl2l_desired_state_or_ready    (w_i_sl2l_desired_state_or_ready        ),
  .i_sl2l_tx_rx                     (w_i_sl2l_tx_rx                           ),
  .o_sl2l_error_resp_or_trigger     (w_o_sl2l_trigger_or_error_resp         ),
  .o_sl2l_ready_or_desired_state    (w_o_sl2l_desired_state_or_ready        ),
  .o_sl2l_tx_rx                     (w_o_sl2l_tx_rx                           ),
  //DR Controller Interface   
  //DR controller team confirmed DR-SRC IF will be channelized - Each SRC Lane will have dedicated DR CTRLLER interface signal
  .csr_clk                          (i_hio_lavmm_clk                        ),
  .src_clk                          (d_i_hio_pld_reset_clk_row              ),
  .pause_request                    (pause_request                          ),
  .pause_grant                      (pause_grant                            ),
  .dr_csr_addr                      (slave_addr                             ),
  .dr_csr_write                     (slave_write[0]                         ),
  .dr_csr_read                      (slave_read[0]                          ),
  .dr_csr_be                        (slave_byteenable                       ),
  .dr_csr_wdata                     (slave_writedata                        ),
  .dr_csr_rdata                     (slave_readdata[31:0]                   ),
  .dr_csr_waitrequest               (slave_waitrequest[0]                   ),
  .dr_csr_rdata_valid               (slave_readdatavalid[0]                 ),
  //SRC Shoreline Sequencer Interface
  .sss_req                          (sss_request                            ),
  .sss_grant                        (sss_grant                              ),
  .i_addr_gen_common_block_rst_done_reg (w_i_addr_gen_common_block_rst_done_reg),
  .o_addr_gen_common_block_rst_done_reg (w_o_addr_gen_common_block_rst_done_reg)
); 


genvar i;
generate
  for ( i = 0 ; i < (NUM_LANES); i = i + 1 ) begin : src_lane2lane
    if (SRC_LANE_INDEX != i ) begin
      assign io_sl2l_trigger_or_error_resp[i* NUM_LANES + SRC_LANE_INDEX]  = w_o_sl2l_trigger_or_error_resp[i];
      assign io_sl2l_desired_state_or_ready[i*NUM_LANES + SRC_LANE_INDEX] = w_o_sl2l_desired_state_or_ready[i];
      assign io_sl2l_tx_rx[i*NUM_LANES +SRC_LANE_INDEX] = w_o_sl2l_tx_rx[i];
    end  
      assign w_i_sl2l_trigger_or_error_resp[i]  = io_sl2l_trigger_or_error_resp[SRC_LANE_INDEX*NUM_LANES + i] ;
      assign w_i_sl2l_desired_state_or_ready[i] = io_sl2l_desired_state_or_ready[SRC_LANE_INDEX*NUM_LANES + i] ;
      assign w_i_sl2l_tx_rx[i] = io_sl2l_tx_rx[SRC_LANE_INDEX*NUM_LANES + i] ;


    if (NUM_LANES > 1) begin
     if(SRC_LANE_INDEX == i) begin //Sahana ww31.3
          assign io_addr_gen_common_block_rst_done_reg[i] = w_o_addr_gen_common_block_rst_done_reg;
      end else begin 
        assign w_i_addr_gen_common_block_rst_done_reg = io_addr_gen_common_block_rst_done_reg;
      end 
    end else begin 
        assign w_i_addr_gen_common_block_rst_done_reg = w_o_addr_gen_common_block_rst_done_reg;
    end
end
endgenerate

`endif // ifndef __TILE_IP__

endmodule // tennm_sm_hssi_pld_chnl_dp_sip_atom

// -----------------------------------------------------------------------------------------------

`undef interpose_connection
`undef merge_param

`undef MUX__RX
`undef MUX__TX
`undef MUX__TX_RX
`undef ARBITER
`undef ARBITER__USE_ONE
`undef DIRECT
`undef SRC_SRC
`undef SRC_DR_CTLR
`undef SRC_SSS
`undef SIP
`undef DR_CTLR
`undef MASTER_CLK

`undef ATTR_DS_MERGE__TX
`undef ATTR_DS_MERGE__RX
`undef ATTR_DS_MERGE__TX_RX
`undef ATTR_DS_MERGE__COMPUTE

// ===============================================================================================
