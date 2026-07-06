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


`timescale 1 ps/1 ps
(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)
module alt_mge_phy_0_intel_directphy_gts_200_twelxbq #(
    parameter          simulation_sip_only                                  = 0,
    parameter          simulation_only                                      = 0,
    parameter          avmm1_jtag_enable                                    = 0,
    parameter          avmm1_split                                          = 0,
    parameter          avmm1_readdv_enable                                  = 1,
    parameter          device_revision                                      = "10nm6agdra",
    parameter          silicon_revision                                     = "10nm6agdra",
    parameter          l_av1_enable                                         = 0,
    parameter          l_av1_aib_enable                                     = 0,
    parameter          l_soft_csr_enable                                    = 0,
    parameter          l_line_rate_p1ghz                                    = 250,
    parameter          l_av1_addr_bits                                      = 21,
    parameter          l_av1_ifaces                                         = 1,
    parameter          l_num_aib_per_xcvr                                   = 1,
    parameter          l_num_avmm1                                          = 1,
    parameter          l_rx_enable                                          = 1,
    parameter          l_sys_aibs                                           = 1,
    parameter          l_sys_xcvrs                                          = 1,
    parameter          l_tx_enable                                          = 1,
    parameter          num_sys_cop                                          = 1,
    parameter          num_xcvr_per_sys                                     = 1,
    parameter          l_sys_xcvrs_cascade                                  = 1,
    parameter          tx_custom_cadence_enable                             = 0,
    parameter          enable_port_tx_cadence_slow_clk_locked               = 0,
  // CDR Clockout:          
    parameter          enable_port_rx_cdr_divclk_link0                      = 0,
    parameter          enable_port_rx_cdr_divclk_link1                      = 0,
    parameter          rx_cdr_divclk_link0_sel                              = 0,
    parameter          rx_cdr_divclk_link1_sel                              = 0,
     
//  Building block attributes:
    parameter          bb_f_ehip_rx_fec_enable                              = "RX_FEC_ENABLE_DISABLED", 
    parameter          bb_f_ehip_tx_fec_enable                              = "TX_FEC_ENABLE_DISABLED", 
    parameter          bb_f_ehip_xcvr_mode                                  = "XCVR_MODE_NRZ",
    parameter          bb_f_ehip_xcvr_type                                  = "XCVR_TYPE_UX",
    parameter          duplex_mode                                          = "duplex", // duplex/simplex
    parameter          pldif_tx_double_width_transfer_enable                = 1, // TX double/single data width transfer
    parameter          pldif_rx_double_width_transfer_enable                = 1, // RX double/single data width transfer
    parameter          l_fec_mode                                           = "IEEE 802.3 RS(528,514) (CL 91,KR)", // RSFEC mode
    parameter          rx_deskew_en                                         = 1, // enable RX de-skew checkbox
    parameter          l_rx_deskew_enable                                   = 1, // enable RX de-skew feature
    parameter          enable_port_latency_measurement                      = 0, // enable deterministic latency 
    parameter          txparalleldata_width                                 = 80, // parallel data width
    parameter          l_quad_num                                           = 1, // parallel data width
    parameter 	       pldif_tx_fifo_mode				    = "phase_comp", // TX PLDIF Fifo mode
    parameter          txsimpleinterface_enable                             = 0 // Mux for selecting data path for simplified interface

) (

    output          [l_sys_xcvrs-1:0]                           o_rx_cdr_divclk,

    input           [num_sys_cop-1:0]                           i_rx_cdr_refclk_p,

    input           [num_sys_cop-1:0]                           i_tx_pll_refclk_p,

    input           [l_quad_num-1:0]                           i_pma_cu_clk,//i_flux_clk,
    //input           [num_sys_cop-1:0]                           i_flux_clk,
    input           [num_sys_cop-1:0]                           i_system_pll_clk,
    input           [num_sys_cop-1:0]                           i_system_pll_lock,
    


// Device Pins:
    input           [l_sys_xcvrs-1:0]                           i_rx_serial_data,
    input           [l_sys_xcvrs-1:0]                           i_rx_serial_data_n,
    output          [l_sys_xcvrs-1:0]                           o_tx_serial_data,
    output          [l_sys_xcvrs-1:0]                           o_tx_serial_data_n,


// User interface:  Clock and data and reset
    input           [num_sys_cop-1:0]                           i_tx_reset,
    input           [num_sys_cop-1:0]                           i_rx_reset,
    output          [num_sys_cop-1:0]                           o_tx_reset_ack,
    output          [num_sys_cop-1:0]                           o_rx_reset_ack,
    
    output          [num_sys_cop-1:0]                           o_tx_am_gen_start,
    input           [num_sys_cop-1:0]                           i_tx_am_gen_2x_ack,
            
    output          [num_sys_cop-1:0]                           o_tx_ready,
    output          [num_sys_cop-1:0]                           o_rx_ready,
    
    input           [(l_sys_xcvrs*txparalleldata_width)-1:0]     i_tx_parallel_data,
    input           [l_sys_xcvrs*4-1:0]                          i_tx_pma_elecidle, 
    output          [l_sys_xcvrs*80-1:0]                         o_rx_parallel_data,

// User interface PLD Clocks
    input           [l_sys_xcvrs-1:0]                            i_tx_coreclkin,
    input           [l_sys_xcvrs-1:0]                            i_rx_coreclkin,
    output wire     [l_sys_xcvrs-1:0]                            o_tx_clkout,
    output wire     [l_sys_xcvrs-1:0]                            o_tx_clkout2,
    output wire     [l_sys_xcvrs-1:0]                            o_rx_clkout,
    output wire     [l_sys_xcvrs-1:0]                            o_rx_clkout2,
     
    // Custom Cadence     
    input           [num_sys_cop-1:0]                           i_tx_cadence_fast_clk,
    input           [num_sys_cop-1:0]                           i_tx_cadence_slow_clk,
    input           [num_sys_cop-1:0]                           i_tx_cadence_slow_clk_locked,
    output          [num_sys_cop-1:0]                           o_tx_cadence,
    
    // User interface for XCVR (FGT)    
    //output          [l_sys_xcvrs-1:0]                           o_rx_signal_detect,// 23.2 not supported Need PFE FPGA.AR 16020319472     
    //output          [l_sys_xcvrs-1:0]                           o_rx_signal_detect_lfps,// 23.2 not supported Need PFE FPGA.AR 16020319472    
    output          [l_sys_xcvrs-1:0]                           o_tx_pll_locked,                 
    output          [l_sys_xcvrs-1:0]                           o_rx_is_lockedtodata,          
    output          [l_sys_xcvrs-1:0]                           o_rx_is_lockedtoref,          
    input           [l_sys_xcvrs-1:0]                           i_rx_set_locktoref,
    //input           [l_sys_xcvrs-1:0]                           i_rx_set_locktodata,
    //input           [l_sys_xcvrs-1:0]                           i_rx_cdr_freeze,
    //input           [l_sys_xcvrs-1:0]                           i_tx_beacon,// 23.2 not supported Need PFE FPGA.AR 16020319472 
    //input           [l_sys_xcvrs-1:0]                           i_rx_cdr_fast_freeze_sel, 
    //input           [l_sys_xcvrs-1:0]                           i_rx_cdr_set_locktoref,


    // User interface for FEC
    output   wire   [num_sys_cop-1:0]                           o_fec_status_rx_not_deskew,
    output   wire   [num_sys_cop-1:0]                           o_fec_status_rx_not_locked,
    output   wire   [num_sys_cop-1:0]                           o_fec_status_rx_not_align,
    output   wire   [num_sys_cop-1:0]                           o_fec_sf,
    input    wire   [ l_sys_xcvrs-1:0]                           i_fec_snapshot,
    
    
    // User interface for AIB       
    output   wire   [l_sys_xcvrs-1:0]                            o_tx_fifo_full,
    output   wire   [l_sys_xcvrs-1:0]                            o_tx_fifo_empty,
    output   wire   [l_sys_xcvrs-1:0]                            o_tx_fifo_pfull,
    output   wire   [l_sys_xcvrs-1:0]                            o_tx_fifo_pempty,
    output   wire   [l_sys_xcvrs-1:0]                            o_rx_fifo_full,
    output   wire   [l_sys_xcvrs-1:0]                            o_rx_fifo_empty,
    output   wire   [l_sys_xcvrs-1:0]                            o_rx_fifo_pfull,
    output   wire   [l_sys_xcvrs-1:0]                            o_rx_fifo_pempty,
    input    wire   [l_sys_xcvrs-1:0]                            i_rx_fifo_rd_en,
    
    // User interface for XCVR-IF    
    output   wire   [l_sys_xcvrs-1:0]                            o_rx_pmaif_fifo_empty,
    output   wire   [l_sys_xcvrs-1:0]                            o_rx_pmaif_fifo_pempty,
    output   wire   [l_sys_xcvrs-1:0]                            o_rx_pmaif_fifo_pfull,
        
    output   wire   [l_sys_xcvrs-1:0]                            o_tx_pmaif_fifo_empty,
    output   wire   [l_sys_xcvrs-1:0]                            o_tx_pmaif_fifo_pempty,
    output   wire   [l_sys_xcvrs-1:0]                            o_tx_pmaif_fifo_pfull,


    // Configuration LAVMM:
    input           [l_av1_ifaces-1:0]                          i_reconfig_clk,         //   i_reconfig_pdp_clk.clk
    input           [l_av1_ifaces-1:0]                          i_reconfig_reset,       // i_reconfig_pdp_reset.reset
    input           [l_av1_ifaces-1:0]                          i_reconfig_write,       //  reconfig_pdp_avmm.write
    input           [l_av1_ifaces-1:0]                          i_reconfig_read,        //                   .read
    input           [l_av1_addr_bits*l_av1_ifaces-1:0]          i_reconfig_address,     //                   .address
    input           [l_av1_ifaces*32-1:0]                       i_reconfig_writedata,   //                   .writedata
    input           [l_av1_ifaces*4-1:0]                        i_reconfig_byteenable,  //                   .byteenable
    output          [l_av1_ifaces*32-1:0]                       o_reconfig_readdata,    //                   .readdata
    output          [l_av1_ifaces-1:0]                          o_reconfig_waitrequest,  //                   .waitrequest
    output          [l_av1_ifaces-1:0]                          o_reconfig_readdatavalid,   //                   .readdatavalid
    
    // SRC Shoreline Sequencer Interface
    output          [l_sys_xcvrs-1:0]                           o_src_rs_req ,   
    input           [l_sys_xcvrs-1:0]                           i_src_rs_grant,


    input              [(l_sys_xcvrs*80) -1:0]                       i_uxquad_async,                  
    input              [(l_sys_xcvrs*80) -1:0]                       i_uxquad_async_pcie_mux,         
    output             [(l_sys_xcvrs*50) -1:0]                       o_uxquad_async, 
    input              [(l_sys_xcvrs*100)-1:0]                       i_txdata_async,                    
    input              [(l_sys_xcvrs*10) -1:0]                       i_txdata_direct,                   
    output             [(l_sys_xcvrs*100)-1:0]                       o_rxdata_async,                    
    output             [(l_sys_xcvrs*10) -1:0]                       o_rxdata_direct,                    


    //DETERMINISTIC LATENCY -- will be directly connected to TOP interface TEMPORARY
    input            [l_sys_xcvrs-1:0]                          i_det_lat_rx_dl_clk,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_rx_mux_select,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_rx_sclk_flop,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_rx_sclk_gen_clk,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_rx_trig_flop,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_sampling_clk,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_tx_dl_clk,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_tx_mux_select,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_tx_sclk_flop,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_tx_sclk_gen_clk,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_tx_trig_flop,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_rx_async_dl_sync,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_rx_async_pulse,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_rx_async_sample_sync,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_rx_sclk_sample_sync,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_rx_trig_sample_sync,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_tx_async_dl_sync,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_tx_async_pulse,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_tx_async_sample_sync,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_tx_sclk_sample_sync,
    output           [l_sys_xcvrs-1:0]                          o_det_lat_tx_trig_sample_sync,
    output           [l_sys_xcvrs-1:0]                          o_xcvrif_rx_latency_pulse,
    output           [l_sys_xcvrs-1:0]                          o_xcvrif_tx_latency_pulse,

     //Refclock to core hdmi
    output           [l_sys_xcvrs-1:0]                          o_refclk2core,
    

    
    // PCS Status
    output          [num_xcvr_per_sys*num_sys_cop-1:0]          o_rx_block_lock,
    output          [num_xcvr_per_sys*num_sys_cop-1:0]          o_rx_am_lock,
    output          [num_xcvr_per_sys*num_sys_cop-1:0]          o_local_fault_status,
    output          [num_xcvr_per_sys*num_sys_cop-1:0]          o_rx_hi_ber,
    output          [num_xcvr_per_sys*num_sys_cop-1:0]          o_rx_pcs_fully_aligned 

 
    
);
    
    //wire           [l_sys_xcvrs-1:0]                           i_rx_cdr_freeze;         //UNUSED
    //wire           [l_sys_xcvrs-1:0]                           i_rx_cdr_fast_freeze_sel; //UNUSED
    //wire           [l_sys_xcvrs-1:0]                           i_rx_cdr_set_locktoref; // UNUSED



            // PCS Status
    wire            [num_xcvr_per_sys*num_sys_cop-1:0]          w_hio_rx_block_lock;
    wire            [num_xcvr_per_sys*num_sys_cop-1:0]          w_hio_rx_am_lock;
    wire            [num_xcvr_per_sys*num_sys_cop-1:0]          w_hio_rx_pcs_internal_err;
    wire            [num_xcvr_per_sys*num_sys_cop-1:0]          w_hio_rx_dsk_done;
    wire            [num_xcvr_per_sys*num_sys_cop-1:0]          w_hio_rx_pcs_fully_aligned;
    
    //wire           [num_sys_cop-1:0]                           w_rx_cdr_refclk_n;
    //wire           [num_sys_cop-1:0]                           w_tx_pll_refclk_n;
    
    //HIP SIGNALS
    // DR Controller Interface - Temporary
    wire            [0:0]                                       csr_clk                 =   'b0;
    wire            [l_sys_xcvrs-1:0]                           pause_request           =   'b0;
    wire            [l_sys_xcvrs-1:0]                           pause_grant             ;
    wire            [(16*l_sys_xcvrs)-1:0]                      dr_csr_addr             =   'b0;
    wire            [l_sys_xcvrs-1:0]                           dr_csr_write            =   'b0; 
    wire            [l_sys_xcvrs-1:0]                           dr_csr_read             =   'b0;
    wire            [(32*l_sys_xcvrs)-1:0]                      dr_csr_wdata            =   'b0;
    wire            [(32*l_sys_xcvrs)-1:0]                      dr_csr_rdata            ;
    wire            [l_sys_xcvrs-1:0]                           dr_csr_waitrequest      ; 
    wire            [(4*l_sys_xcvrs)-1:0]                       dr_csr_be               =   'b0;
    wire            [l_sys_xcvrs-1:0]                           dr_csr_rdata_valid      ;    

    //DETERMINISTIC LATENCY -- will be directly connected to TOP interface TEMPORARY
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_rx_dl_clk;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_rx_mux_select;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_rx_sclk_flop;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_rx_sclk_gen_clk;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_rx_trig_flop;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_sampling_clk;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_tx_dl_clk;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_tx_mux_select;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_tx_sclk_flop;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_tx_sclk_gen_clk;
    wire            [num_sys_cop-1:0]                                       i_hio_ch0_det_lat_tx_trig_flop;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_rx_async_dl_sync;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_rx_async_pulse;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_rx_async_sample_sync;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_rx_sclk_sample_sync;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_rx_trig_sample_sync;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_tx_async_dl_sync;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_tx_async_pulse;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_tx_async_sample_sync;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_tx_sclk_sample_sync;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_det_lat_tx_trig_sample_sync;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_xcvrif_rx_latency_pulse;
    wire            [num_sys_cop-1:0]                                       o_hio_ch0_xcvrif_tx_latency_pulse;


    //DETERMINISTIC LATENCY -- will be directly connected to TOP interface TEMPORARY
    wire            [num_sys_cop-1:0]                                       w_hio_ch0_pld_rx_clk_in_row_clk;
    wire            [num_sys_cop-1:0]                                       w_hio_ch0_pld_tx_clk_in_row_clk;
    wire            [num_sys_cop-1:0]                                       w_hio_ch0_user_rx_clk1_clk;     
    wire            [num_sys_cop-1:0]                                       w_hio_ch0_user_rx_clk2_clk;     
    wire            [num_sys_cop-1:0]                                       w_hio_ch0_user_tx_clk1_clk;     
    wire            [num_sys_cop-1:0]                                       w_hio_ch0_user_tx_clk2_clk;     
    wire            [num_sys_cop-1:0]                                       w_hio_ch0_ux_chnl_refclk_mux;

    
    
    //LAVMM
    wire            [(num_sys_cop*20)-1:0]                       w_hio_ch0_lavmm_addr;
    wire            [(num_sys_cop*(21-20))-1:0]                    w_hio_ch0_lavmm_addr_extra;
    wire            [(num_sys_cop*4)-1:0]                                       w_hio_ch0_lavmm_be;
    wire            [num_sys_cop-1:0]                                           w_hio_ch0_lavmm_read;
    wire            [num_sys_cop-1:0]                                           w_hio_ch0_lavmm_write;
    wire            [(num_sys_cop*32)-1:0]                                      w_hio_ch0_lavmm_wdata;
    wire            [(num_sys_cop*32)-1:0]                                      w_hio_ch0_lavmm_rdata;
    wire            [num_sys_cop-1:0]                                           w_hio_ch0_lavmm_rdata_valid;
    wire            [num_sys_cop-1:0]                                           w_hio_ch0_lavmm_waitreq;
    wire            [num_sys_cop-1:0]                                           w_hio_ch0_lavmm_rstn;
    wire            [num_sys_cop-1:0]                                           w_hio_ch0_lavmm_clk;
    
    //ASYNC
    wire    [l_sys_xcvrs-1:0] [79:0]                             w_tx_hio_uxquad_async;
    wire    [l_sys_xcvrs-1:0] [79:0]                             w_hio_uxquad_async_pcie_mux;
    wire    [l_sys_xcvrs-1:0] [49:0]                             w_rx_hio_uxquad_async;
    wire    [l_sys_xcvrs-1:0] [49:0]                             w_rx_hio_uxquad_async_tx;
    wire    [l_sys_xcvrs-1:0] [49:0]                             w_rx_hio_uxquad_async_rx;
    wire    [l_sys_xcvrs-1:0] [99:0]                             w_hio_rxdata_async;
    wire    [l_sys_xcvrs-1:0] [99:0]                             w_hio_rxdata_async_tx;
    wire    [l_sys_xcvrs-1:0] [99:0]                             w_hio_rxdata_async_rx;
    //DATA
    wire    [l_sys_xcvrs-1:0] [79:0]                             w_hio_txdata;
    wire    [l_sys_xcvrs-1:0] [9:0]                              w_hio_txdata_extra;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_txdata_fifo_wr_en;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_txdata_fifo_wr_empty;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_txdata_fifo_wr_full;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_txdata_fifo_wr_pempty;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_txdata_fifo_wr_pfull;                                                    
    wire    [l_sys_xcvrs-1:0] [79:0]                             w_hio_rxdata;
    wire    [l_sys_xcvrs-1:0] [9:0]                              w_hio_rxdata_extra;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_rxdata_fifo_rd_empty;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_rxdata_fifo_rd_full;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_rxdata_fifo_rd_pempty;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_rxdata_fifo_rd_pfull;
    wire    [l_sys_xcvrs-1:0]                                    w_hio_rxdata_fifo_rd_en;

    //FIFO STATUS
    wire    [l_sys_xcvrs-1:0]                                    o_hio_tx_fifo_status_fifo_empty;
    wire    [l_sys_xcvrs-1:0]                                    o_hio_tx_fifo_status_fifo_pempty;
    wire    [l_sys_xcvrs-1:0]                                    o_hio_tx_fifo_status_fifo_wr_pfull;
    wire    [l_sys_xcvrs-1:0]                                    o_hio_tx_fifo_status_gb_restarted;
    wire    [l_sys_xcvrs-1:0]                                    o_hio_rx_fifo_status_fifo_empty;
    wire    [l_sys_xcvrs-1:0]                                    o_hio_rx_fifo_status_fifo_pempty;
    wire    [l_sys_xcvrs-1:0]                                    o_hio_rx_fifo_status_fifo_wr_pfull;
    wire    [l_sys_xcvrs-1:0]                                    o_hio_rx_fifo_status_gb_restarted;
    //SRC Controller
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_tx_lane_desired_state; // 0:operate  1:reset
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_tx_clear_alarm;
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_sip_am_gen_2x_ack;
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_rx_lane_desired_state; // 0:operate  1:reset
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_rx_clear_alarm;
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_sip_rx_ignore_lock2data;
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_sip_am_gen_start;
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_tx_alarm;
    wire     [num_xcvr_per_sys*num_sys_cop-1:0]                 w_rx_alarm;
    wire     [num_xcvr_per_sys*num_sys_cop-1:0][1:0]            w_tx_lane_current_state;
    wire     [num_xcvr_per_sys*num_sys_cop-1:0][1:0]            w_rx_lane_current_state;    
    // Other Signals coming out of HIP
    wire      [l_sys_xcvrs-1:0][99:0]                            w_hio_txdata_async;
    wire      [l_sys_xcvrs-1:0][9:0]                             w_hio_txdata_direct;
    wire      [l_sys_xcvrs-1:0][9:0]                             w_hio_rxdata_direct;    
    
    wire      [l_sys_xcvrs-1:0]                                  w_hio_rst_ux_all_synthlockstatus     ;
    wire      [l_sys_xcvrs-1:0]                                  w_hio_rst_ux_octl_pcs_rxstatus       ;
    wire      [l_sys_xcvrs-1:0]                                  w_hio_rst_ux_octl_pcs_txstatus       ;
    wire      [l_sys_xcvrs-1:0]                                  w_hio_rst_ux_rxcdrlock2data          ;
    wire      [l_sys_xcvrs-1:0]                                  w_hio_rst_ux_rxcdrlockstatus         ;   
    wire      [l_sys_xcvrs-1:0]                                  w_hio_rstfec_fec_rx_rdy_n           ;
    wire      [l_sys_xcvrs-1:0]                                  w_hio_ehip_signal_ok                ;

    
    localparam fec_on = (bb_f_ehip_rx_fec_enable == "RX_FEC_ENABLE_ENABLED" )|| (bb_f_ehip_tx_fec_enable == "TX_FEC_ENABLE_ENABLED") ;


intel_directphy_gts_sip_twelxbq 
    #(
    .simulation_sip_only                        (simulation_sip_only),
    .num_sys_cop                                (num_sys_cop),                          
    .num_xcvr_per_sys                           (num_xcvr_per_sys),
    .l_num_aib_per_xcvr                         (l_num_aib_per_xcvr),
    .l_sys_xcvrs                                (l_sys_xcvrs),
    .l_sys_aibs                                 (l_sys_aibs),
    .l_tx_enable                                (l_tx_enable),
    .l_rx_enable                                (l_rx_enable),
    .tx_custom_cadence_enable                   (tx_custom_cadence_enable),
    .enable_port_tx_cadence_slow_clk_locked     (enable_port_tx_cadence_slow_clk_locked),
    .fec_on                                     (fec_on),
    .bb_f_ehip_xcvr_type                        (bb_f_ehip_xcvr_type),
    .bb_f_ehip_xcvr_mode                        (bb_f_ehip_xcvr_mode),
    .l_soft_csr_enable                          (l_soft_csr_enable),
    .l_line_rate_p1ghz                          (l_line_rate_p1ghz),
    .avmm1_split                                (avmm1_split),
    .avmm1_jtag_enable                          (avmm1_jtag_enable),
    .avmm1_readdv_enable                        (avmm1_readdv_enable),
    .l_av1_enable                               (l_av1_enable),
    .l_av1_aib_enable                           (l_av1_aib_enable),
    .l_num_avmm1                                (l_num_avmm1),
    .l_av1_ifaces                               (l_av1_ifaces),
    .l_av1_addr_bits                            (l_av1_addr_bits),
    .l_fec_mode                                 (l_fec_mode),
    .pldif_tx_double_width_transfer_enable      (pldif_tx_double_width_transfer_enable),
    .pldif_rx_double_width_transfer_enable      (pldif_rx_double_width_transfer_enable),
    .rx_deskew_en                               (rx_deskew_en),
    .txsimpleinterface_enable                   (txsimpleinterface_enable),
    .pldif_tx_fifo_mode				(pldif_tx_fifo_mode),
    .l_rx_deskew_enable                         (l_rx_deskew_enable)
    )
    sip_inst 
    (
    .i_tx_reset                                 (i_tx_reset                       ),          // OK - TOP
    .i_rx_reset                                 (i_rx_reset                       ),          // OK - TOP
    .o_tx_reset_ack                             (o_tx_reset_ack                   ),          // OK - TOP
    .o_rx_reset_ack                             (o_rx_reset_ack                   ),          // OK - TOP
    .i_rx_coreclkin                             (i_rx_coreclkin                   ),          // OK - TOP
    .i_tx_coreclkin                             (i_tx_coreclkin                   ),          // OK - TOP
    .o_tx_clkout                                (o_tx_clkout                      ),          // OK - TOP
    .o_tx_clkout2                               (o_tx_clkout2                     ),          // OK - TOP
    .o_rx_clkout                                (o_rx_clkout                      ),          // OK - TOP
    .o_rx_clkout2                               (o_rx_clkout2                     ),          // OK - TOP
    .o_refclk2core                              (o_refclk2core                    ),          // OK - TOP
    .o_tx_am_gen_start                          (o_tx_am_gen_start                ),          // OK - TOP
    .i_tx_am_gen_2x_ack                         (i_tx_am_gen_2x_ack               ),          // OK - TOP
    .o_tx_ready                                 (o_tx_ready                       ),          // OK - TOP
    .o_rx_ready                                 (o_rx_ready                       ),          // OK - TOP
    .i_tx_parallel_data                         (i_tx_parallel_data               ),          // OK - TOP
    .o_rx_parallel_data                         (o_rx_parallel_data               ),          // OK - TOP
    .i_tx_cadence_fast_clk                      (i_tx_cadence_fast_clk            ),          // OK - TOP
    .i_tx_cadence_slow_clk                      (i_tx_cadence_slow_clk            ),          // OK - TOP
    .i_tx_cadence_slow_clk_locked               (i_tx_cadence_slow_clk_locked     ),          // OK - TOP
    .o_tx_cadence                               (o_tx_cadence                     ),          // OK - TOP
    //.o_rx_signal_detect                         (o_rx_signal_detect               ),          // OK - TOP
    //.o_rx_signal_detect_lfps                    (o_rx_signal_detect_lfps          ),          // OK - TOP
    .o_tx_pll_locked                            (o_tx_pll_locked                  ),          // OK - TOP       
    .o_rx_is_lockedtodata                       (o_rx_is_lockedtodata             ),          // OK - TOP
    .o_rx_is_lockedtoref                        (o_rx_is_lockedtoref              ),          // OK - TOP
    .i_rx_set_locktoref                         (i_rx_set_locktoref               ),          // OK - TOP
    //.i_rx_set_locktodata                         (i_rx_set_locktodata               ),          // OK - TOP
    //.i_rx_cdr_freeze                            (i_rx_cdr_freeze                  ),          // OK - TOP
    //.i_tx_beacon                                (i_tx_beacon                      ),          // OK - TOP
    //.i_rx_cdr_fast_freeze_sel                   (i_rx_cdr_fast_freeze_sel         ),          // OK - TOP
    //.i_rx_cdr_set_locktoref                     (i_rx_cdr_set_locktoref           ),          // OK - TOP
    .i_tx_pma_elecidle                          (i_tx_pma_elecidle                ),          // OK - TOP
    .o_fec_status_rx_not_deskew                 (o_fec_status_rx_not_deskew       ),          // OK - TOP
    .o_fec_status_rx_not_locked                 (o_fec_status_rx_not_locked       ),          // OK - TOP
    .o_fec_status_rx_not_align                  (o_fec_status_rx_not_align        ),          // OK - TOP
    .o_fec_sf                                   (o_fec_sf                         ),          // OK - TOP
    .i_fec_snapshot                             (i_fec_snapshot                   ),          // OK - TOP
    .o_tx_fifo_full                             (o_tx_fifo_full                   ),          // OK - TOP
    .o_tx_fifo_empty                            (o_tx_fifo_empty                  ),          // OK - TOP
    .o_tx_fifo_pfull                            (o_tx_fifo_pfull                  ),          // OK - TOP
    .o_tx_fifo_pempty                           (o_tx_fifo_pempty                 ),          // OK - TOP
    .o_rx_fifo_full                             (o_rx_fifo_full                   ),          // OK - TOP
    .o_rx_fifo_empty                            (o_rx_fifo_empty                  ),          // OK - TOP
    .o_rx_fifo_pfull                            (o_rx_fifo_pfull                  ),          // OK - TOP
    .o_rx_fifo_pempty                           (o_rx_fifo_pempty                 ),          // OK - TOP
    .i_rx_fifo_rd_en                            (i_rx_fifo_rd_en                  ),          // OK - TOP
    .o_rx_pmaif_fifo_empty                      (o_rx_pmaif_fifo_empty            ),          // OK - TOP
    .o_rx_pmaif_fifo_pempty                     (o_rx_pmaif_fifo_pempty           ),          // OK - TOP
    .o_rx_pmaif_fifo_pfull                      (o_rx_pmaif_fifo_pfull            ),          // OK - TOP
    .o_tx_pmaif_fifo_empty                      (o_tx_pmaif_fifo_empty            ),          // OK - TOP
    .o_tx_pmaif_fifo_pempty                     (o_tx_pmaif_fifo_pempty           ),          // OK - TOP
    .o_tx_pmaif_fifo_pfull                      (o_tx_pmaif_fifo_pfull            ),          // OK - TOP
    .i_det_lat_rx_mux_select                    (i_det_lat_rx_mux_select          ),
    .i_det_lat_tx_mux_select                    (i_det_lat_tx_mux_select          ),
    .i_reconfig_clk                             (i_reconfig_clk              ),          // OK - TOP
    .i_reconfig_reset                           (i_reconfig_reset            ),          // OK - TOP
    .i_reconfig_write                           (i_reconfig_write            ),          // OK - TOP
    .i_reconfig_read                            (i_reconfig_read             ),          // OK - TOP
    .i_reconfig_address                         (i_reconfig_address          ),          // OK - TOP
    .i_reconfig_writedata                       (i_reconfig_writedata        ),          // OK - TOP
    .i_reconfig_byteenable                      (i_reconfig_byteenable       ),          // OK - TOP
    .o_reconfig_readdata                        (o_reconfig_readdata         ),          // OK - TOP
    .o_reconfig_waitrequest                     (o_reconfig_waitrequest      ),          // OK - TOP
    .o_reconfig_readdatavalid                   (o_reconfig_readdatavalid    ),          // OK - TOP
    // PCS Status
    .o_rx_block_lock                            (o_rx_block_lock                ),            // OK - TOP
    .o_rx_am_lock                               (o_rx_am_lock                   ),            // OK - TOP
    .o_local_fault_status                       (o_local_fault_status           ),            // OK - TOP
    .o_rx_hi_ber                                (o_rx_hi_ber                    ),            // OK - TOP
    .o_rx_pcs_fully_aligned                     (o_rx_pcs_fully_aligned         ),            // OK - TOP
    .tx_lane_desired_state                      (w_tx_lane_desired_state        ),          // OK - NCSS
    .tx_clear_alarm                             (w_tx_clear_alarm               ),          // OK - NCSS
    .sip_am_gen_2x_ack                          (w_sip_am_gen_2x_ack            ),          // OK - NCSS
    .rx_lane_desired_state                      (w_rx_lane_desired_state        ),          // OK - NCSS
    .rx_clear_alarm                             (w_rx_clear_alarm               ),          // OK - NCSS
    .sip_rx_ignore_lock2data                    (w_sip_rx_ignore_lock2data      ),          // OK - NCSS
    .sip_am_gen_start                           (w_sip_am_gen_start             ),          // OK - NCSS
    .tx_alarm                                   (w_tx_alarm                     ),          // OK - NCSS
    .rx_alarm                                   (w_rx_alarm                     ),          // OK - NCSS
    .tx_lane_current_state                      (w_tx_lane_current_state        ),          // OK - NCSS
    .rx_lane_current_state                      (w_rx_lane_current_state        ),          // OK - NCSS



    
    .i_hio_ch0_lavmm_addr                    (w_hio_ch0_lavmm_addr        ),          // OK - NCSS
    .i_hio_ch0_lavmm_be                      (w_hio_ch0_lavmm_be          ),          // OK - NCSS
    .i_hio_ch0_lavmm_read                    (w_hio_ch0_lavmm_read        ),          // OK - NCSS
    .i_hio_ch0_lavmm_write                   (w_hio_ch0_lavmm_write       ),          // OK - NCSS
    .i_hio_ch0_lavmm_wdata                   (w_hio_ch0_lavmm_wdata       ),          // OK - NCSS
    .o_hio_ch0_lavmm_rdata                   (w_hio_ch0_lavmm_rdata       ),          // OK - NCSS
    .o_hio_ch0_lavmm_rdata_valid             (w_hio_ch0_lavmm_rdata_valid ),          // OK - NCSS
    .o_hio_ch0_lavmm_waitreq                 (w_hio_ch0_lavmm_waitreq     ),          // OK - NCSS
    .i_hio_ch0_lavmm_rstn                    (w_hio_ch0_lavmm_rstn        ),          // OK - NCSS
    .i_hio_ch0_lavmm_clk                     (w_hio_ch0_lavmm_clk         ),          // OK - NCSS
           
    
    .i_hio_ch0_pld_rx_clk_in_row_clk         (w_hio_ch0_pld_rx_clk_in_row_clk             ),  // OK - NCSS
    .i_hio_ch0_pld_tx_clk_in_row_clk         (w_hio_ch0_pld_tx_clk_in_row_clk             ),  // OK - NCSS
    .o_hio_ch0_user_rx_clk1_clk              (w_hio_ch0_user_rx_clk1_clk                  ),  // OK - NCSS
    .o_hio_ch0_user_rx_clk2_clk              (w_hio_ch0_user_rx_clk2_clk                  ),  // OK - NCSS
    .o_hio_ch0_user_tx_clk1_clk              (w_hio_ch0_user_tx_clk1_clk                  ),  // OK - NCSS
    .o_hio_ch0_user_tx_clk2_clk              (w_hio_ch0_user_tx_clk2_clk                  ),  // OK - NCSS
    .o_hio_ch0_ux_chnl_refclk_mux            (w_hio_ch0_ux_chnl_refclk_mux                ),  // OK - NCSS
        
    
    .i_hio_uxquad_async                         (w_tx_hio_uxquad_async          ),          // OK - NCSS
    .i_hio_uxquad_async_pcie_mux                (w_hio_uxquad_async_pcie_mux    ),          // OK - NCSS
    
    .o_hio_rst_ux_all_synthlockstatus           (w_hio_rst_ux_all_synthlockstatus),        // OK - NCSS
    .o_hio_rst_ux_octl_pcs_rxstatus             (w_hio_rst_ux_octl_pcs_rxstatus  ),        // OK - NCSS
    .o_hio_rst_ux_octl_pcs_txstatus             (w_hio_rst_ux_octl_pcs_txstatus  ),        // OK - NCSS
    .o_hio_rst_ux_rxcdrlock2data                (w_hio_rst_ux_rxcdrlock2data     ),        // OK - NCSS
    .o_hio_rst_ux_rxcdrlockstatus               (w_hio_rst_ux_rxcdrlockstatus    ),        // OK - NCSS
    .o_hio_rstfec_fec_rx_rdy_n                  (w_hio_rstfec_fec_rx_rdy_n       ),        // OK - NCSS
    .i_hio_ehip_signal_ok                       (w_hio_ehip_signal_ok            ),        // OK - NCSS

    .o_hio_uxquad_async_tx                      (w_rx_hio_uxquad_async_tx        ),  // DS Support
    .o_hio_uxquad_async_rx                      (w_rx_hio_uxquad_async_rx        ),  // DS Support
    .o_hio_rxdata_async_tx                      (w_hio_rxdata_async_tx           ),  // DS Support
    .o_hio_rxdata_async_rx                      (w_hio_rxdata_async_rx           ),  // DS Support
   
    
    .i_hio_txdata                               (w_hio_txdata                   ),          // OK - NCSS
    .i_hio_txdata_extra                         (w_hio_txdata_extra             ),          // OK - NCSS
    .i_hio_txdata_fifo_wr_en                    (w_hio_txdata_fifo_wr_en        ),          // OK - NCSS
    .o_hio_txdata_fifo_wr_empty                 (w_hio_txdata_fifo_wr_empty     ),          // OK - NCSS
    .o_hio_txdata_fifo_wr_full                  (w_hio_txdata_fifo_wr_full      ),          // OK - NCSS
    .o_hio_txdata_fifo_wr_pempty                (w_hio_txdata_fifo_wr_pempty    ),          // OK - NCSS
    .o_hio_txdata_fifo_wr_pfull                 (w_hio_txdata_fifo_wr_pfull     ),          // OK - NCSS
    .o_hio_rxdata                               (w_hio_rxdata                   ),          // OK - NCSS
    .o_hio_rxdata_extra                         (w_hio_rxdata_extra             ),          // OK - NCSS
    .o_hio_rxdata_fifo_rd_empty                 (w_hio_rxdata_fifo_rd_empty     ),          // OK - NCSS
    .o_hio_rxdata_fifo_rd_full                  (w_hio_rxdata_fifo_rd_full      ),          // OK - NCSS
    .o_hio_rxdata_fifo_rd_pempty                (w_hio_rxdata_fifo_rd_pempty    ),          // OK - NCSS
    .o_hio_rxdata_fifo_rd_pfull                 (w_hio_rxdata_fifo_rd_pfull     ),          // OK - NCSS
    .i_hio_rxdata_fifo_rd_en                    (w_hio_rxdata_fifo_rd_en        ),          // OK - NCSS
    
    .i_hio_txdata_async                         (w_hio_txdata_async             ),          // OK - NCSS
    .i_hio_txdata_direct                        (w_hio_txdata_direct            ),          // OK - NCSS
    .o_hio_rxdata_direct                        (w_hio_rxdata_direct            )           // OK - NCSS
    
);

genvar idx_sys_cop;
generate
begin : g1
   if(simulation_sip_only == 1)
   begin
        assign w_hio_rxdata = w_hio_txdata; //LOOPBACK
   end 
   else
   begin:n

for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: sys

                // Num channel 0
                assign i_hio_ch0_det_lat_rx_dl_clk       [idx_sys_cop]         =   i_det_lat_rx_dl_clk                       [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_rx_mux_select   [idx_sys_cop]         =   i_det_lat_rx_mux_select                   [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_rx_sclk_flop    [idx_sys_cop]         =   i_det_lat_rx_sclk_flop                    [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_rx_sclk_gen_clk [idx_sys_cop]         =   i_det_lat_rx_sclk_gen_clk                 [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_rx_trig_flop    [idx_sys_cop]         =   i_det_lat_rx_trig_flop                    [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_sampling_clk    [idx_sys_cop]         =   i_det_lat_sampling_clk                    [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_tx_dl_clk       [idx_sys_cop]         =   i_det_lat_tx_dl_clk                       [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_tx_mux_select   [idx_sys_cop]         =   i_det_lat_tx_mux_select                   [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_tx_sclk_flop    [idx_sys_cop]         =   i_det_lat_tx_sclk_flop                    [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_tx_sclk_gen_clk [idx_sys_cop]         =   i_det_lat_tx_sclk_gen_clk                 [idx_sys_cop+0]  ;
                assign i_hio_ch0_det_lat_tx_trig_flop    [idx_sys_cop]         =   i_det_lat_tx_trig_flop                    [idx_sys_cop+0]  ;
                assign o_det_lat_rx_async_dl_sync           [idx_sys_cop+0]    =   o_hio_ch0_det_lat_rx_async_dl_sync     [idx_sys_cop]       ;
                assign o_det_lat_rx_async_pulse             [idx_sys_cop+0]    =   o_hio_ch0_det_lat_rx_async_pulse       [idx_sys_cop]       ;
                assign o_det_lat_rx_async_sample_sync       [idx_sys_cop+0]    =   o_hio_ch0_det_lat_rx_async_sample_sync [idx_sys_cop]       ;
                assign o_det_lat_rx_sclk_sample_sync        [idx_sys_cop+0]    =   o_hio_ch0_det_lat_rx_sclk_sample_sync  [idx_sys_cop]       ;
                assign o_det_lat_rx_trig_sample_sync        [idx_sys_cop+0]    =   o_hio_ch0_det_lat_rx_trig_sample_sync  [idx_sys_cop]       ;
                assign o_det_lat_tx_async_dl_sync           [idx_sys_cop+0]    =   o_hio_ch0_det_lat_tx_async_dl_sync     [idx_sys_cop]       ;
                assign o_det_lat_tx_async_pulse             [idx_sys_cop+0]    =   o_hio_ch0_det_lat_tx_async_pulse       [idx_sys_cop]       ;
                assign o_det_lat_tx_async_sample_sync       [idx_sys_cop+0]    =   o_hio_ch0_det_lat_tx_async_sample_sync [idx_sys_cop]       ;
                assign o_det_lat_tx_sclk_sample_sync        [idx_sys_cop+0]    =   o_hio_ch0_det_lat_tx_sclk_sample_sync  [idx_sys_cop]       ;
                assign o_det_lat_tx_trig_sample_sync        [idx_sys_cop+0]    =   o_hio_ch0_det_lat_tx_trig_sample_sync  [idx_sys_cop]       ;
                assign o_xcvrif_rx_latency_pulse            [idx_sys_cop+0]    =   o_hio_ch0_xcvrif_rx_latency_pulse      [idx_sys_cop]       ;
                assign o_xcvrif_tx_latency_pulse            [idx_sys_cop+0]    =   o_hio_ch0_xcvrif_tx_latency_pulse      [idx_sys_cop]       ;
        assign w_hio_ch0_lavmm_addr_extra                            = 'h0;


        alt_mge_phy_0_intel_directphy_gts_n_channel_superset_200_vtl75gi n_channel_superset_ip_inst (
                .i_hio_txdata                                (w_hio_txdata                                          [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_hio_txdata_extra                          (w_hio_txdata_extra                                    [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_hio_txdata_fifo_wr_en                     (w_hio_txdata_fifo_wr_en                               [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_txdata_fifo_wr_empty                  (w_hio_txdata_fifo_wr_empty                            [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_txdata_fifo_wr_pempty                 (w_hio_txdata_fifo_wr_pempty                           [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_txdata_fifo_wr_full                   (w_hio_txdata_fifo_wr_full                             [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_txdata_fifo_wr_pfull                  (w_hio_txdata_fifo_wr_pfull                            [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata                                (w_hio_rxdata                                          [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata_extra                          (w_hio_rxdata_extra                                    [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata_fifo_rd_empty                  (w_hio_rxdata_fifo_rd_empty                            [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata_fifo_rd_pempty                 (w_hio_rxdata_fifo_rd_pempty                           [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata_fifo_rd_full                   (w_hio_rxdata_fifo_rd_full                             [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata_fifo_rd_pfull                  (w_hio_rxdata_fifo_rd_pfull                            [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_hio_rxdata_fifo_rd_en                     (w_hio_rxdata_fifo_rd_en                               [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP                                                                                                      
                .i_hio_uxquad_async_rx                       (w_tx_hio_uxquad_async                                 [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_hio_uxquad_async_tx                       (w_tx_hio_uxquad_async                                 [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP   
                .i_hio_uxquad_async_pcie_mux_rx              (w_hio_uxquad_async_pcie_mux                           [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_hio_uxquad_async_pcie_mux_tx              (w_hio_uxquad_async_pcie_mux                           [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_uxquad_async_tx                       (w_rx_hio_uxquad_async_tx                              [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP 
                .o_hio_uxquad_async_rx                       (w_rx_hio_uxquad_async_rx                              [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_refclk_tx_p                               (i_tx_pll_refclk_p                                     [idx_sys_cop]                                       ),  //OK-TOP
                .i_syspll_c0_clk                             (i_system_pll_clk                                      [idx_sys_cop]                                       ),  //OK-TOP
                .i_flux_clk_0                                   (i_pma_cu_clk),//(i_flux_clk                                     ),  //OK-TOP
                .i_flux_clk_1                                   (1'b0                                           ),  //OK-TOP
                .i_refclk_rx_p                               (i_rx_cdr_refclk_p                                     [idx_sys_cop]                                       ),  //OK-TOP
                .i_hio_ch0_lavmm_addr                        ({w_hio_ch0_lavmm_addr_extra[idx_sys_cop*(21-20) +: (21-20)],w_hio_ch0_lavmm_addr[idx_sys_cop*20 +: 20]}                        ),  //OK-SIP
                .i_hio_ch0_lavmm_be                          (w_hio_ch0_lavmm_be                      [idx_sys_cop*4 +: 4]      ),  //OK-SIP
                .i_hio_ch0_lavmm_read                        (w_hio_ch0_lavmm_read                    [idx_sys_cop]             ),  //OK-SIP
                .i_hio_ch0_lavmm_write                       (w_hio_ch0_lavmm_write                   [idx_sys_cop]             ),  //OK-SIP
                .i_hio_ch0_lavmm_wdata                       (w_hio_ch0_lavmm_wdata                   [idx_sys_cop*32 +: 32]    ),  //OK-SIP
                .o_hio_ch0_lavmm_rdata                       (w_hio_ch0_lavmm_rdata                   [idx_sys_cop*32 +: 32]    ),  //OK-SIP
                .o_hio_ch0_lavmm_rdata_valid                 (w_hio_ch0_lavmm_rdata_valid             [idx_sys_cop]             ),  //OK-SIP
                .o_hio_ch0_lavmm_waitreq                     (w_hio_ch0_lavmm_waitreq                 [idx_sys_cop]             ),  //OK-SIP
                .i_hio_ch0_lavmm_rstn                        (w_hio_ch0_lavmm_rstn                    [idx_sys_cop]             ),  //OK-SIP
                .i_hio_ch0_lavmm_clk                         (w_hio_ch0_lavmm_clk                     [idx_sys_cop]             ),  //OK-SIP
                .i_hio_ch0_pld_rx_clk_in_row_clk             (w_hio_ch0_pld_rx_clk_in_row_clk         [idx_sys_cop]             ),  //OK-SIP
                .i_hio_ch0_pld_tx_clk_in_row_clk             (w_hio_ch0_pld_tx_clk_in_row_clk         [idx_sys_cop]             ),  //OK-SIP
                .i_hio_ch0_det_lat_rx_dl_clk                 (i_hio_ch0_det_lat_rx_dl_clk             [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_rx_mux_select             (i_hio_ch0_det_lat_rx_mux_select         [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_rx_sclk_flop              (i_hio_ch0_det_lat_rx_sclk_flop          [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_rx_sclk_gen_clk           (i_hio_ch0_det_lat_rx_sclk_gen_clk       [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_rx_trig_flop              (i_hio_ch0_det_lat_rx_trig_flop          [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_sampling_clk              (i_hio_ch0_det_lat_sampling_clk          [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_tx_dl_clk                 (i_hio_ch0_det_lat_tx_dl_clk             [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_tx_mux_select             (i_hio_ch0_det_lat_tx_mux_select         [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_tx_sclk_flop              (i_hio_ch0_det_lat_tx_sclk_flop          [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_tx_sclk_gen_clk           (i_hio_ch0_det_lat_tx_sclk_gen_clk       [idx_sys_cop]             ),  //OK-TOP
                .i_hio_ch0_det_lat_tx_trig_flop              (i_hio_ch0_det_lat_tx_trig_flop          [idx_sys_cop]             ),  //OK-TOP
                                                                                                            
                .o_hio_ch0_user_rx_clk1_clk                  (w_hio_ch0_user_rx_clk1_clk              [idx_sys_cop]             ),  //OK-SIP
                .o_hio_ch0_user_rx_clk2_clk                  (w_hio_ch0_user_rx_clk2_clk              [idx_sys_cop]             ),  //OK-SIP
                .o_hio_ch0_user_tx_clk1_clk                  (w_hio_ch0_user_tx_clk1_clk              [idx_sys_cop]             ),  //OK-SIP
                .o_hio_ch0_user_tx_clk2_clk                  (w_hio_ch0_user_tx_clk2_clk              [idx_sys_cop]             ),  //OK-SIP
                .o_hio_ch0_ux_chnl_refclk_mux                (w_hio_ch0_ux_chnl_refclk_mux            [idx_sys_cop]             ),  //OK-SIP
                                                                                                            
                .o_hio_ch0_det_lat_rx_async_dl_sync          (o_hio_ch0_det_lat_rx_async_dl_sync      [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_rx_async_pulse            (o_hio_ch0_det_lat_rx_async_pulse        [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_rx_async_sample_sync      (o_hio_ch0_det_lat_rx_async_sample_sync  [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_rx_sclk_sample_sync       (o_hio_ch0_det_lat_rx_sclk_sample_sync   [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_rx_trig_sample_sync       (o_hio_ch0_det_lat_rx_trig_sample_sync   [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_tx_async_dl_sync          (o_hio_ch0_det_lat_tx_async_dl_sync      [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_tx_async_pulse            (o_hio_ch0_det_lat_tx_async_pulse        [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_tx_async_sample_sync      (o_hio_ch0_det_lat_tx_async_sample_sync  [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_tx_sclk_sample_sync       (o_hio_ch0_det_lat_tx_sclk_sample_sync   [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_det_lat_tx_trig_sample_sync       (o_hio_ch0_det_lat_tx_trig_sample_sync   [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_xcvrif_rx_latency_pulse           (o_hio_ch0_xcvrif_rx_latency_pulse       [idx_sys_cop]             ),  //OK-TOP
                .o_hio_ch0_xcvrif_tx_latency_pulse           (o_hio_ch0_xcvrif_tx_latency_pulse       [idx_sys_cop]             ),  //OK-TOP
                .rx_serial_n                                 (i_rx_serial_data_n                                    [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-TOP
                .rx_serial_p                                 (i_rx_serial_data                                      [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-TOP
                .tx_serial_p                                 (o_tx_serial_data                                      [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-TOP
                .tx_serial_n                                 (o_tx_serial_data_n                                    [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-TOP                                                                                          
                .i_hio_txdata_async_tx                       (w_hio_txdata_async                                    [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_hio_txdata_async_rx                       (w_hio_txdata_async                                    [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_hio_txdata_direct                         (w_hio_txdata_direct                                   [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata_async_tx                       (w_hio_rxdata_async_tx                                 [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata_async_rx                       (w_hio_rxdata_async_rx                                 [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rxdata_direct                         (w_hio_rxdata_direct                                   [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP  
                .o_hio_rst_ux_all_synthlockstatus            (w_hio_rst_ux_all_synthlockstatus                      [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rst_ux_octl_pcs_rxstatus              (w_hio_rst_ux_octl_pcs_rxstatus                        [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rst_ux_octl_pcs_txstatus              (w_hio_rst_ux_octl_pcs_txstatus                        [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rst_ux_rxcdrlock2data                 (w_hio_rst_ux_rxcdrlock2data                           [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rst_ux_rxcdrlockstatus                (w_hio_rst_ux_rxcdrlockstatus                          [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_hio_rstfec_fec_rx_rdy_n                   (w_hio_rstfec_fec_rx_rdy_n                             [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_hio_ehip_signal_ok                        (w_hio_ehip_signal_ok                                  [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_cdrdiv_clk                                (o_rx_cdr_divclk                                       [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .o_tx_lane_current_state                     (w_tx_lane_current_state                               [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP     
                .o_tx_alarm                                  (w_tx_alarm                                            [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP     
                .o_sip_am_gen_start                          (w_sip_am_gen_start                                    [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP     
                .o_rx_lane_current_state                     (w_rx_lane_current_state                               [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP     
                .o_rx_alarm                                  (w_rx_alarm                                            [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP                
                .i_tx_clear_alarm                            (w_tx_clear_alarm                                      [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP     
                .i_tx_lane_desired_state                     (w_tx_lane_desired_state                               [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP     
                .i_rx_lane_desired_state                     (w_rx_lane_desired_state                               [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP     
                .i_rx_clear_alarm                            (w_rx_clear_alarm                                      [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP     
                .i_sip_rx_ignore_lock2data                   (w_sip_rx_ignore_lock2data                             [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP       
                .i_sip_am_gen_2x_ack                         (w_sip_am_gen_2x_ack                                   [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-SIP
                .i_spll_lock                                 (i_system_pll_lock                                     [idx_sys_cop]                                       ),  //OK-TOP
                .o_sss_req                                   (o_src_rs_req                                          [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  ),  //OK-TOP
                .i_sss_grant                                 (i_src_rs_grant                                        [idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  )   //OK-TOP
        );
        end // sys
    end //n
end // g1
endgenerate


endmodule



