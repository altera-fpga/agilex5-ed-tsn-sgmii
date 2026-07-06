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


  module ncss_common_ptp_top (

  input                         i_hio_lavmm_clk_ptp,
  input                         i_hio_lavmm_rstn_ptp,
  input    [20:0]               i_hio_lavmm_addr_ptp,
  input    [31:0]               i_hio_lavmm_wdata_ptp,
  input    [3:0 ]               i_hio_lavmm_be_ptp,
  input                         i_hio_lavmm_read_ptp,
  input                         i_hio_lavmm_write_ptp,
  output   [31:0]               o_hio_lavmm_rdata_ptp,
  output                        o_hio_lavmm_rdata_valid_ptp,
  output                        o_hio_lavmm_waitreq_ptp,

  input    [79:0]               i_hio_txdata_ptp,
  input                         i_hio_det_lat_rx_dl_clk_ptp,
  input                         i_hio_det_lat_rx_mux_select_ptp,
  input                         i_hio_det_lat_rx_sclk_flop_ptp,
  input                         i_hio_det_lat_rx_sclk_gen_clk_ptp,
  input                         i_hio_det_lat_rx_trig_flop_ptp,
  input                         i_hio_det_lat_sampling_clk_ptp,
  input                         i_hio_det_lat_tx_dl_clk_ptp,
  input                         i_hio_det_lat_tx_mux_select_ptp,
  input                         i_hio_det_lat_tx_sclk_flop_ptp,
  input                         i_hio_det_lat_tx_sclk_gen_clk_ptp,
  input                         i_hio_det_lat_tx_trig_flop_ptp,
  input                         i_hio_pld_reset_clk_row_ptp,
  input                         i_hio_pld_rx_clk_in_row_clk_ptp,
  input                         i_hio_pld_tx_clk_in_row_clk_ptp,
  input                         i_hio_ptp_rst_n_ptp,
  input                         i_hio_rst_pld_adapter_rx_pld_rst_n_ptp,
  input                         i_hio_rst_pld_adapter_tx_pld_rst_n_ptp,
  input                         i_hio_rst_pld_ready_ptp,

  output   [79:0]               o_hio_rxdata_ptp,
  output                        o_hio_det_lat_rx_async_dl_sync_ptp,
  output                        o_hio_det_lat_rx_async_pulse_ptp,
  output                        o_hio_det_lat_rx_async_sample_sync_ptp,
  output                        o_hio_det_lat_rx_sclk_sample_sync_ptp,
  output                        o_hio_det_lat_rx_trig_sample_sync_ptp,
  output                        o_hio_det_lat_tx_async_dl_sync_ptp,
  output                        o_hio_det_lat_tx_async_pulse_ptp,
  output                        o_hio_det_lat_tx_async_sample_sync_ptp,
  output                        o_hio_det_lat_tx_sclk_sample_sync_ptp,
  output                        o_hio_det_lat_tx_trig_sample_sync_ptp,
  output                        o_hio_user_rx_clk1_clk_ptp,
  output                        o_hio_user_tx_clk1_clk_ptp,
    
  output                        o_hio_lavmm_clk_ptp,
  output                        o_hio_lavmm_rstn_ptp,
  output   [20:0]               o_hio_lavmm_addr_ptp,
  output   [31:0]               o_hio_lavmm_wdata_ptp,
  output   [3:0 ]               o_hio_lavmm_be_ptp,
  output                        o_hio_lavmm_read_ptp,
  output                        o_hio_lavmm_write_ptp,
  input                         i_hio_lavmm_rdata_valid_ptp,
  input                         i_hio_lavmm_waitreq_ptp,
  input    [31:0]               i_hio_lavmm_rdata_ptp,

  output   [79:0]               o_hio_txdata_ptp,
  output                        o_hio_det_lat_rx_dl_clk_ptp,
  output                        o_hio_det_lat_rx_mux_select_ptp,
  output                        o_hio_det_lat_rx_sclk_flop_ptp,
  output                        o_hio_det_lat_rx_sclk_gen_clk_ptp,
  output                        o_hio_det_lat_rx_trig_flop_ptp,
  output                        o_hio_det_lat_sampling_clk_ptp,
  output                        o_hio_det_lat_tx_dl_clk_ptp,
  output                        o_hio_det_lat_tx_mux_select_ptp,
  output                        o_hio_det_lat_tx_sclk_flop_ptp,
  output                        o_hio_det_lat_tx_sclk_gen_clk_ptp,
  output                        o_hio_det_lat_tx_trig_flop_ptp,
  output                        o_hio_pld_reset_clk_row_ptp,
  output                        o_hio_pld_rx_clk_in_row_clk_ptp,
  output                        o_hio_pld_tx_clk_in_row_clk_ptp,
  output                        o_hio_ptp_rst_n_ptp,
  output                        o_hio_rst_pld_adapter_rx_pld_rst_n_ptp,
  output                        o_hio_rst_pld_adapter_tx_pld_rst_n_ptp,
  output                        o_hio_rst_pld_ready_ptp,
  input    [79:0]               i_hio_rxdata_ptp,
  input                         i_hio_det_lat_rx_async_dl_sync_ptp,
  input                         i_hio_det_lat_rx_async_pulse_ptp,
  input                         i_hio_det_lat_rx_async_sample_sync_ptp,
  input                         i_hio_det_lat_rx_sclk_sample_sync_ptp,
  input                         i_hio_det_lat_rx_trig_sample_sync_ptp,
  input                         i_hio_det_lat_tx_async_dl_sync_ptp,
  input                         i_hio_det_lat_tx_async_pulse_ptp,
  input                         i_hio_det_lat_tx_async_sample_sync_ptp,
  input                         i_hio_det_lat_tx_sclk_sample_sync_ptp,
  input                         i_hio_det_lat_tx_trig_sample_sync_ptp,
  input                         i_hio_user_rx_clk1_clk_ptp,
  input                         i_hio_user_tx_clk1_clk_ptp
  );


assign o_hio_rxdata_ptp                             = i_hio_rxdata_ptp; 
assign o_hio_det_lat_rx_async_dl_sync_ptp           = i_hio_det_lat_rx_async_dl_sync_ptp; 
assign o_hio_det_lat_rx_async_pulse_ptp             = i_hio_det_lat_rx_async_pulse_ptp; 
assign o_hio_det_lat_rx_async_sample_sync_ptp       = i_hio_det_lat_rx_async_sample_sync_ptp; 
assign o_hio_det_lat_rx_sclk_sample_sync_ptp        = i_hio_det_lat_rx_sclk_sample_sync_ptp; 
assign o_hio_det_lat_rx_trig_sample_sync_ptp        = i_hio_det_lat_rx_trig_sample_sync_ptp; 
assign o_hio_det_lat_tx_async_dl_sync_ptp           = i_hio_det_lat_tx_async_dl_sync_ptp; 
assign o_hio_det_lat_tx_async_pulse_ptp             = i_hio_det_lat_tx_async_pulse_ptp; 
assign o_hio_det_lat_tx_async_sample_sync_ptp       = i_hio_det_lat_tx_async_sample_sync_ptp; 
assign o_hio_det_lat_tx_sclk_sample_sync_ptp        = i_hio_det_lat_tx_sclk_sample_sync_ptp; 
assign o_hio_det_lat_tx_trig_sample_sync_ptp        = i_hio_det_lat_tx_trig_sample_sync_ptp; 
assign o_hio_user_rx_clk1_clk_ptp                   = i_hio_user_rx_clk1_clk_ptp; 
assign o_hio_user_tx_clk1_clk_ptp                   = i_hio_user_tx_clk1_clk_ptp; 
assign o_hio_txdata_ptp                             = i_hio_txdata_ptp; 
assign o_hio_det_lat_rx_dl_clk_ptp                  = i_hio_det_lat_rx_dl_clk_ptp; 
assign o_hio_det_lat_rx_mux_select_ptp              = i_hio_det_lat_rx_mux_select_ptp; 
assign o_hio_det_lat_rx_sclk_flop_ptp               = i_hio_det_lat_rx_sclk_flop_ptp; 
assign o_hio_det_lat_rx_sclk_gen_clk_ptp            = i_hio_det_lat_rx_sclk_gen_clk_ptp; 
assign o_hio_det_lat_rx_trig_flop_ptp               = i_hio_det_lat_rx_trig_flop_ptp; 
assign o_hio_det_lat_sampling_clk_ptp               = i_hio_det_lat_sampling_clk_ptp; 
assign o_hio_det_lat_tx_dl_clk_ptp                  = i_hio_det_lat_tx_dl_clk_ptp; 
assign o_hio_det_lat_tx_mux_select_ptp              = i_hio_det_lat_tx_mux_select_ptp; 
assign o_hio_det_lat_tx_sclk_flop_ptp               = i_hio_det_lat_tx_sclk_flop_ptp; 
assign o_hio_det_lat_tx_sclk_gen_clk_ptp            = i_hio_det_lat_tx_sclk_gen_clk_ptp; 
assign o_hio_det_lat_tx_trig_flop_ptp               = i_hio_det_lat_tx_trig_flop_ptp; 

assign o_hio_pld_reset_clk_row_ptp                  = i_hio_pld_reset_clk_row_ptp; 
assign o_hio_pld_rx_clk_in_row_clk_ptp              = i_hio_pld_rx_clk_in_row_clk_ptp; 
assign o_hio_pld_tx_clk_in_row_clk_ptp              = i_hio_pld_tx_clk_in_row_clk_ptp; 
assign o_hio_ptp_rst_n_ptp                          = i_hio_ptp_rst_n_ptp; 
assign o_hio_rst_pld_adapter_rx_pld_rst_n_ptp       = i_hio_rst_pld_adapter_rx_pld_rst_n_ptp; 
assign o_hio_rst_pld_adapter_tx_pld_rst_n_ptp       = i_hio_rst_pld_adapter_tx_pld_rst_n_ptp; 
assign o_hio_rst_pld_ready_ptp                      = i_hio_rst_pld_ready_ptp; 

//PTP LAVMM Ports connection
assign o_hio_lavmm_addr_ptp                         = i_hio_lavmm_addr_ptp;
assign o_hio_lavmm_be_ptp                           = i_hio_lavmm_be_ptp;
assign o_hio_lavmm_read_ptp                         = i_hio_lavmm_read_ptp;
assign o_hio_lavmm_write_ptp                        = i_hio_lavmm_write_ptp;
assign o_hio_lavmm_wdata_ptp                        = i_hio_lavmm_wdata_ptp;
assign o_hio_lavmm_rdata_ptp                        = i_hio_lavmm_rdata_ptp;
assign o_hio_lavmm_rdata_valid_ptp                  = i_hio_lavmm_rdata_valid_ptp;
assign o_hio_lavmm_waitreq_ptp                      = i_hio_lavmm_waitreq_ptp;
assign o_hio_lavmm_clk_ptp                          = i_hio_lavmm_clk_ptp; 
assign o_hio_lavmm_rstn_ptp                         = i_hio_lavmm_rstn_ptp; 

endmodule
