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
//(* tile_ip_sip  *)
module intel_directphy_gts_sip_twelxbq #(
    parameter          simulation_sip_only                                      = 0,
    parameter          num_sys_cop                                              = 1,
    parameter          num_fec_ch                                               = 1,
    parameter          num_xcvr_per_sys                                         = 1,
    parameter          l_num_aib_per_xcvr                                       = 1,
    parameter          l_sys_xcvrs                                              = 1,
    parameter          l_sys_aibs                                               = 1,
    parameter          l_tx_enable                                              = 1,
    parameter          l_rx_enable                                              = 1,
    parameter          tx_custom_cadence_enable                                 = 0,
    parameter          enable_port_tx_cadence_slow_clk_locked                   = 0,
    parameter          fec_on                                                   = 0,
    parameter          bb_f_ehip_xcvr_type                                      = "XCVR_TYPE_UX",
    parameter          bb_f_ehip_xcvr_mode                                      = "XCVR_MODE_NRZ",
    parameter          l_soft_csr_enable                                        = 0,
    parameter          l_line_rate_p1ghz                                        = 250,   
    parameter          avmm1_split                                              = 0,
    parameter          avmm1_jtag_enable                                        = 0,
    parameter          avmm1_readdv_enable                                      = 0,
    parameter          l_av1_enable                                             = 0,
    parameter          l_av1_aib_enable                                         = 0,
    parameter          l_num_avmm1                                              = 1,
    parameter          l_av1_ifaces                                             = 1,
    parameter          l_av1_addr_bits                                          = 21,
    parameter          l_fec_mode                                               = "IEEE 802.3 RS(528,514) (CL 91,KR)", // RSFEC mode
    parameter          pldif_tx_double_width_transfer_enable                    = 1, // TX double/single data width transfer
    parameter          pldif_rx_double_width_transfer_enable                    = 1, // RX double/single data width transfer
    parameter          rx_deskew_en                                             = 1, // enable RX de-skew checkbox
    parameter          txsimpleinterface_enable                                 = 0, // Mux for selecting data path for simplified interface
    parameter 	       pldif_tx_fifo_mode				        = "phase_comp", // PLDIF TX FIFO Mode
    parameter          l_rx_deskew_enable                                       = 1 // enable RX de-skew feature
    ) (
  // User interface:  Clock and data and reset    
    input               [num_sys_cop-1:0]                           i_tx_reset,
    input               [num_sys_cop-1:0]                           i_rx_reset,
    output              [num_sys_cop-1:0]                           o_tx_reset_ack,
    output              [num_sys_cop-1:0]                           o_rx_reset_ack,
    input               [l_sys_xcvrs-1:0]                           i_tx_coreclkin,
    input               [l_sys_xcvrs-1:0]                           i_rx_coreclkin,
    output wire         [l_sys_xcvrs-1:0]                           o_tx_clkout,
    output wire         [l_sys_xcvrs-1:0]                           o_tx_clkout2,
    output wire         [l_sys_xcvrs-1:0]                           o_rx_clkout,
    output wire         [l_sys_xcvrs-1:0]                           o_rx_clkout2,
    output wire         [l_sys_xcvrs-1:0]                           o_refclk2core,            
    output              [num_sys_cop-1:0]                           o_tx_am_gen_start,
    input               [num_sys_cop-1:0]                           i_tx_am_gen_2x_ack,
                    
    output              [num_sys_cop-1:0]                           o_tx_ready,
    output              [num_sys_cop-1:0]                           o_rx_ready,
                
    input               [(l_sys_xcvrs*80)-1:0]                       i_tx_parallel_data, 
    output              [l_sys_xcvrs*80-1:0]                         o_rx_parallel_data,
    // Custom Cadence     
    input               [num_sys_cop-1:0]                           i_tx_cadence_fast_clk,
    input               [num_sys_cop-1:0]                           i_tx_cadence_slow_clk,
    input               [num_sys_cop-1:0]                           i_tx_cadence_slow_clk_locked,
    output              [num_sys_cop-1:0]                           o_tx_cadence,
    // User interface for xcvr (fgt)    
    //output              [l_sys_xcvrs-1:0]                           o_rx_signal_detect,           // NO Connection P
    //output              [l_sys_xcvrs-1:0]                           o_rx_signal_detect_lfps,      // NO Connection P
    output              [l_sys_xcvrs-1:0]                           o_tx_pll_locked,                  
    output              [l_sys_xcvrs-1:0]                           o_rx_is_lockedtodata,             
    output              [l_sys_xcvrs-1:0]                           o_rx_is_lockedtoref,              
    input               [l_sys_xcvrs-1:0]                           i_rx_set_locktoref,           
    //input               [l_sys_xcvrs-1:0]                           i_rx_set_locktodata,           
    input               [l_sys_xcvrs-1:0]                           i_rx_cdr_freeze,              // NO Connection P
    //input               [l_sys_xcvrs-1:0]                           i_tx_beacon,                  
    input               [l_sys_xcvrs-1:0]                           i_rx_cdr_fast_freeze_sel,     // NO Connection P
    input               [l_sys_xcvrs-1:0]                           i_rx_cdr_set_locktoref,       
    input               [l_sys_xcvrs*4-1:0]                          i_tx_pma_elecidle,
    // User interface for fec
    output  wire        [num_sys_cop-1:0]                           o_fec_status_rx_not_deskew,     
    output  wire        [num_sys_cop-1:0]                           o_fec_status_rx_not_locked,     
    output  wire        [num_sys_cop-1:0]                           o_fec_status_rx_not_align,      
    output  wire        [num_sys_cop-1:0]                           o_fec_sf,                       
    input   wire        [ l_sys_xcvrs-1:0]                           i_fec_snapshot,                   
    // user interface for aib    
    output  wire        [l_sys_xcvrs-1:0]                            o_tx_fifo_full,
    output  wire        [l_sys_xcvrs-1:0]                            o_tx_fifo_empty,
    output  wire        [l_sys_xcvrs-1:0]                            o_tx_fifo_pfull,
    output  wire        [l_sys_xcvrs-1:0]                            o_tx_fifo_pempty,
    output  wire        [l_sys_xcvrs-1:0]                            o_rx_fifo_full,
    output  wire        [l_sys_xcvrs-1:0]                            o_rx_fifo_empty,
    output  wire        [l_sys_xcvrs-1:0]                            o_rx_fifo_pfull,
    output  wire        [l_sys_xcvrs-1:0]                            o_rx_fifo_pempty,
    input   wire        [l_sys_xcvrs-1:0]                            i_rx_fifo_rd_en,

    // User interface for xcvr-if    
    output  wire        [l_sys_xcvrs-1:0]                            o_rx_pmaif_fifo_empty,            
    output  wire        [l_sys_xcvrs-1:0]                            o_rx_pmaif_fifo_pempty,           
    output  wire        [l_sys_xcvrs-1:0]                            o_rx_pmaif_fifo_pfull,            
                                                                                                    
    output  wire        [l_sys_xcvrs-1:0]                            o_tx_pmaif_fifo_empty,            
    output  wire        [l_sys_xcvrs-1:0]                            o_tx_pmaif_fifo_pempty,           
    output  wire        [l_sys_xcvrs-1:0]                            o_tx_pmaif_fifo_pfull,            

    // Deterministic Latency
    input            [l_sys_xcvrs-1:0]                          i_det_lat_rx_mux_select,
    input            [l_sys_xcvrs-1:0]                          i_det_lat_tx_mux_select,
    
    // Configuration lavmm
    input               [l_av1_ifaces-1:0]                          i_reconfig_clk,
    input               [l_av1_ifaces-1:0]                          i_reconfig_reset,
    input               [l_av1_ifaces-1:0]                          i_reconfig_write,
    input               [l_av1_ifaces-1:0]                          i_reconfig_read,
    input               [l_av1_addr_bits*l_av1_ifaces-1:0]          i_reconfig_address,
    input               [l_av1_ifaces*4-1:0]                        i_reconfig_byteenable,
    input               [l_av1_ifaces*32-1:0]                       i_reconfig_writedata,
    output              [l_av1_ifaces*32-1:0]                       o_reconfig_readdata,
    output              [l_av1_ifaces-1:0]                          o_reconfig_waitrequest,
    output              [l_av1_ifaces-1:0]                          o_reconfig_readdatavalid,
    
     // PCS Status                                                                                    
    output              [num_xcvr_per_sys*num_sys_cop-1:0]          o_rx_block_lock,                  
    output              [num_xcvr_per_sys*num_sys_cop-1:0]          o_rx_am_lock,                     
    output              [num_xcvr_per_sys*num_sys_cop-1:0]          o_local_fault_status,             
    output              [num_xcvr_per_sys*num_sys_cop-1:0]          o_rx_hi_ber,                      
    output              [num_xcvr_per_sys*num_sys_cop-1:0]          o_rx_pcs_fully_aligned,           
    
       // Soft reset controller:
       // Replaced the parameter l_sys_xcvrs with num_xcvr_per_sys*num_sys_cop to make it more explicit that the soft reset controller operates
       // on each transceiver lane in a system copy, or reset group, but each reset group is tied to a single system copy
       // The number of ports is unchanged.  the ports with the '__MB__ markup are not brought out to the top level in the IP, but are
       // connected at the qtlg step using cross-module references.
       // TX outputs are present only if the tx is enabled
    output  wire        [num_xcvr_per_sys*num_sys_cop-1:0]          tx_lane_desired_state, // 0:operate  1:reset
    output  wire        [num_xcvr_per_sys*num_sys_cop-1:0]          tx_clear_alarm,                  
// At the input to the soft reset controller, there is one sip_am_gen_start output per transceiver lane and one
// sip_am_gen_2_ack input per transceiver lane.  the soft ip component (this file) maps this to a single
// port accessible to the user ip for each system copy.
    output  wire        [num_xcvr_per_sys*num_sys_cop-1:0]          sip_am_gen_2x_ack,
       // RX outputs are present only if the rx is enabled
    output  wire        [num_xcvr_per_sys*num_sys_cop-1:0]          rx_lane_desired_state, // 0:operate  1:reset
    output  wire        [num_xcvr_per_sys*num_sys_cop-1:0]          rx_clear_alarm,                 
    output  wire        [num_xcvr_per_sys*num_sys_cop-1:0]          sip_rx_ignore_lock2data,
    input   wire        [num_xcvr_per_sys*num_sys_cop-1:0]          sip_am_gen_start,
    input   wire        [num_xcvr_per_sys*num_sys_cop-1:0]          tx_alarm,                       
    input   wire        [num_xcvr_per_sys*num_sys_cop-1:0]          rx_alarm,                       
    input   wire        [num_xcvr_per_sys*num_sys_cop-1:0][1:0]     tx_lane_current_state,
       // 100 - in a transitional state
       // 101 - in the full reset state
       // 110 - in the normal operational state
    input   wire        [num_xcvr_per_sys*num_sys_cop-1:0][1:0]     rx_lane_current_state,
       // 100 - in a transitional state
       // 101 - in the full reset state
       // 110 - in the normal operational state



    // Configuration LAVMM towards HIP:
 
    output              [(num_sys_cop*20)-1:0]                                      i_hio_ch0_lavmm_addr,
    output              [(num_sys_cop*4)-1:0]                                       i_hio_ch0_lavmm_be,
    output              [num_sys_cop-1:0]                                           i_hio_ch0_lavmm_read,
    output              [num_sys_cop-1:0]                                           i_hio_ch0_lavmm_write,
    output              [(num_sys_cop*32)-1:0]                                      i_hio_ch0_lavmm_wdata,
    input               [(num_sys_cop*32)-1:0]                                      o_hio_ch0_lavmm_rdata,
    input               [num_sys_cop-1:0]                                           o_hio_ch0_lavmm_rdata_valid,
    input               [num_sys_cop-1:0]                                           o_hio_ch0_lavmm_waitreq,
    output              [num_sys_cop-1:0]                                           i_hio_ch0_lavmm_rstn,
    output              [num_sys_cop-1:0]                                           i_hio_ch0_lavmm_clk,  
       
       
       
    output             [num_sys_cop-1:0]                                        i_hio_ch0_pld_rx_clk_in_row_clk,           
    output             [num_sys_cop-1:0]                                        i_hio_ch0_pld_tx_clk_in_row_clk,           
    input              [num_sys_cop-1:0]                                        o_hio_ch0_user_rx_clk1_clk,  
    input              [num_sys_cop-1:0]                                        o_hio_ch0_user_rx_clk2_clk,  
    input              [num_sys_cop-1:0]                                        o_hio_ch0_user_tx_clk1_clk,  
    input              [num_sys_cop-1:0]                                        o_hio_ch0_user_tx_clk2_clk,  
    input              [num_sys_cop-1:0]                                        o_hio_ch0_ux_chnl_refclk_mux,
 
       
    output              [l_sys_xcvrs-1:0] [79:0]                     i_hio_uxquad_async,                  
    output              [l_sys_xcvrs-1:0] [79:0]                     i_hio_uxquad_async_pcie_mux,                 

    output              [l_sys_xcvrs-1:0] [79:0]                     i_hio_txdata,
    output              [l_sys_xcvrs-1:0] [9:0]                      i_hio_txdata_extra,                  // NO Connection
    output              [l_sys_xcvrs-1:0]                            i_hio_txdata_fifo_wr_en,             // NO Connection
    input               [l_sys_xcvrs-1:0]                            o_hio_txdata_fifo_wr_empty,
    input               [l_sys_xcvrs-1:0]                            o_hio_txdata_fifo_wr_full,
    input               [l_sys_xcvrs-1:0]                            o_hio_txdata_fifo_wr_pempty,
    input               [l_sys_xcvrs-1:0]                            o_hio_txdata_fifo_wr_pfull,
            
    input               [l_sys_xcvrs-1:0] [79:0]                     o_hio_rxdata,                         
    input               [l_sys_xcvrs-1:0] [9:0]                      o_hio_rxdata_extra,                   // NO Connection
    input               [l_sys_xcvrs-1:0]                            o_hio_rxdata_fifo_rd_empty,
    input               [l_sys_xcvrs-1:0]                            o_hio_rxdata_fifo_rd_full,
    input               [l_sys_xcvrs-1:0]                            o_hio_rxdata_fifo_rd_pempty,
    input               [l_sys_xcvrs-1:0]                            o_hio_rxdata_fifo_rd_pfull,
    output              [l_sys_xcvrs-1:0]                            i_hio_rxdata_fifo_rd_en,
        
    input               [l_sys_xcvrs-1:0]                            o_hio_rst_ux_all_synthlockstatus           ,
    input               [l_sys_xcvrs-1:0]                            o_hio_rst_ux_octl_pcs_rxstatus             , // NO Connection
    input               [l_sys_xcvrs-1:0]                            o_hio_rst_ux_octl_pcs_txstatus             ,
    input               [l_sys_xcvrs-1:0]                            o_hio_rst_ux_rxcdrlock2data                ,
    input               [l_sys_xcvrs-1:0]                            o_hio_rst_ux_rxcdrlockstatus               ,
    input               [l_sys_xcvrs-1:0]                            o_hio_rstfec_fec_rx_rdy_n                  ,
    output              [l_sys_xcvrs-1:0]                            i_hio_ehip_signal_ok                       ,
    
    input               [l_sys_xcvrs-1:0] [49:0]                     o_hio_uxquad_async_tx                      , //DS Support
    input               [l_sys_xcvrs-1:0] [49:0]                     o_hio_uxquad_async_rx                      , //DS Support
    input               [l_sys_xcvrs-1:0] [99:0]                     o_hio_rxdata_async_tx                      , //DS Support
    input               [l_sys_xcvrs-1:0] [99:0]                     o_hio_rxdata_async_rx                      , //DS Support
    
                                                                                                               
    output              [l_sys_xcvrs-1:0][99:0]                      i_hio_txdata_async,                    
    output              [l_sys_xcvrs-1:0][9:0]                       i_hio_txdata_direct,                   // NO Connection 
    input               [l_sys_xcvrs-1:0][9:0]                       o_hio_rxdata_direct                    // NO Connection
    

/*     // RECHECK
    // User interface for XCVR (FGT/FHT)
     input   wire   [num_xcvr_per_sys*num_sys_cop-1:0]   tx_enable_xcvr,         // Each channel or only 1 bit for ALL?
     output   wire   [num_xcvr_per_sys*num_sys_cop-1:0]   pll_locked_xcvr,

    output   wire   [l_sys_xcvrs-1:0]  xcvrif_hold_interrupt */


);


// Wires for TX de-skew pulses generation   
    wire    [l_sys_xcvrs*80-1:0]                     int_tx_parallel_data;

    wire    [num_sys_cop-1:0]                       dphy_adme_avmm1_clk;
    wire    [num_sys_cop-1:0]                       dphy_adme_avmm1_reset;
    wire    [num_sys_cop-1:0]                       dphy_adme_avmm1_write;
    wire    [num_sys_cop-1:0]                       dphy_adme_avmm1_read;
    wire    [num_sys_cop*l_av1_addr_bits-1:0]       dphy_adme_avmm1_address;
    wire    [num_sys_cop*4-1:0]                     dphy_adme_avmm1_byteenable;
    wire    [num_sys_cop*32-1:0]                    dphy_adme_avmm1_writedata;
    wire    [num_sys_cop*32-1:0]                    dphy_adme_avmm1_readdata;
    wire    [num_sys_cop-1:0]                       dphy_adme_avmm1_waitrequest;
    wire    [num_sys_cop-1:0]                       dphy_adme_avmm1_readdatavalid;
    
    wire    [l_av1_ifaces*32-1:0]                   dphy_avmm1_readdata;
    wire    [l_av1_ifaces-1:0]                      dphy_avmm1_waitrequest;
    wire    [l_av1_ifaces-1:0]                      dphy_avmm1_readdatavalid;
    wire    [num_xcvr_per_sys*num_sys_cop-1:0]      w_hio_rst_ux_all_synthlockstatus;
    wire    [num_xcvr_per_sys*num_sys_cop-1:0]      w_hio_rst_ux_octl_pcs_txstatus;
    
    wire [num_xcvr_per_sys*num_sys_cop-1:0]         tx_lane_is_in_reset;
    wire [num_xcvr_per_sys*num_sys_cop-1:0]         rx_lane_is_in_reset;
    wire [num_xcvr_per_sys*num_sys_cop-1:0]         tx_lane_out_of_reset;
    wire [num_xcvr_per_sys*num_sys_cop-1:0]         rx_lane_out_of_reset;
    // ctrl  signals from and and status signals to soft CSR
    wire    [num_sys_cop-1:0]                       dphy_reset_soft_tx_rst;
    wire    [num_sys_cop-1:0]                       dphy_reset_tx_rst_ovr;
    wire    [num_sys_cop-1:0]                       dphy_reset_soft_rx_rst;
    wire    [num_sys_cop-1:0]                       dphy_reset_rx_rst_ovr;
    
    wire [num_xcvr_per_sys-1:0]                     tx_per_lane_sip_am_gen_start[num_sys_cop-1:0];
    wire [num_xcvr_per_sys-1:0]                     tx_per_lane_sip_am_gen_2x_ack[num_sys_cop-1:0];
    
    wire [num_sys_cop-1:0]                          w_src_ctrl_rx_ignore_locked2data;
    
    wire [l_num_avmm1-1:0]                          i_hio_lavmm_clk               ;
    wire [l_num_avmm1-1:0]                          i_hio_lavmm_rstn              ;
    wire [l_num_avmm1-1:0]                          i_hio_lavmm_write             ;
    wire [l_num_avmm1-1:0]                          i_hio_lavmm_read              ;
    wire [l_num_avmm1*(20)-1:0]                     i_hio_lavmm_addr              ;
    wire [l_num_avmm1*32-1:0]                       i_hio_lavmm_wdata             ;
    wire [l_num_avmm1*4-1:0]                        i_hio_lavmm_be                ;
    wire [l_num_avmm1*32-1:0]                       o_hio_lavmm_rdata             ;
    wire [l_num_avmm1-1:0]                          o_hio_lavmm_waitreq           ;
    wire [l_num_avmm1-1:0]                          o_hio_lavmm_rdata_valid       ;
    
 // Interface to ux bb
    wire [num_xcvr_per_sys*num_sys_cop-1:0]     w_oct_pcs_rxsignaldetect_lx_a;    
    wire [num_xcvr_per_sys*num_sys_cop-1:0]     w_octl_pcs_rxsignaldetect_lfps_lx_a;                  
    wire [num_xcvr_per_sys*num_sys_cop-1:0]     w_ictl_pcs_rxovrcdrlock2dataen_lx_a;  
    wire [num_xcvr_per_sys*num_sys_cop-1:0]     w_ictl_pcs_rxovrcdrlock2data_lx_a;  
    wire [num_xcvr_per_sys*num_sys_cop-1:0]     w_ictl_pcs_txbeacon_lx_a;
    wire [num_xcvr_per_sys*num_sys_cop-1:0]     w_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t;
    wire [num_xcvr_per_sys*num_sys_cop-1:0]     w_ictl_pcs_rxeiosdetectstat_lx_a;
    wire [num_xcvr_per_sys*num_sys_cop-1:0]     w_dphy_iflux_ingress_input;
    wire  [l_sys_xcvrs-1:0]                      w_pcs_rx_sf;
    wire  [l_sys_xcvrs-1:0]                      w_fec_not_align;
    wire  [l_sys_xcvrs-1:0]                      w_fec_not_deskew;
    wire  [l_sys_xcvrs-1:0]                      w_fec_not_locked;
    wire   [l_sys_xcvrs-1:0]                     w_pld_pma_ppm_lock;
    wire  [l_sys_xcvrs-1:0]                      w_xcvrif_rxfifo_empty;
    wire  [l_sys_xcvrs-1:0]                      w_xcvrif_rxfifo_pempty;
    wire  [l_sys_xcvrs-1:0]                      w_xcvrif_rxfifo_pfull;
    wire  [l_sys_xcvrs-1:0]                      w_xcvrif_txfifo_empty;
    wire  [l_sys_xcvrs-1:0]                      w_xcvrif_txfifo_pempty;
    wire  [l_sys_xcvrs-1:0]                      w_xcvrif_txfifo_pfull;
    wire  [l_sys_xcvrs-1:0]                      w_xcvrif_hold_inter;
    wire  [l_sys_xcvrs-1:0][99:0]                w_hio_rxdata_async ; //DS Support
    wire  [l_sys_xcvrs-1:0] [49:0]               w_hio_uxquad_async ; //DS Support
    
    // TX parallel data select
  wire [l_sys_xcvrs*80-1:0]         tx_parallel_data_sel;
    
    // assign w__ictl_pcs_txenable      = tx_enable_xcvr;          // copied from Agilex 7

   //DS Support 
    assign w_hio_rxdata_async = o_hio_rxdata_async_tx | o_hio_rxdata_async_rx;
    assign w_hio_uxquad_async = o_hio_uxquad_async_tx | o_hio_uxquad_async_rx;
    
    
    
genvar idx_sys_cop;
generate
for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: persystem
   //-----------------------------------------------------------------------------
   //   Instantiations of soft custom cadence generation (CCG)
   //-----------------------------------------------------------------------------
   if (tx_custom_cadence_enable == 1) begin : ccg
       // custom cadence controller with it's ram disabled
       // follows example in regtest/ip/efifo_f/hsl_dcfifo_v3_ext_ram/test/dut.sv
       dphy_ccg # (
          .WIDTH       (80),
          .DISABLE_RAM (1),
          .ADDR_WIDTH (5)
        ) ccg (
          .aclr   ((enable_port_tx_cadence_slow_clk_locked == 0) ? i_tx_reset[idx_sys_cop] | ~(&o_tx_pll_locked[num_xcvr_per_sys*idx_sys_cop +: num_xcvr_per_sys]) : i_tx_reset[idx_sys_cop] | ~i_tx_cadence_slow_clk_locked[idx_sys_cop]),       //avmm1_inst need for  o_tx_pll_locked
          .wclk   (i_tx_cadence_slow_clk[idx_sys_cop]),
          .wreq   (1'b1),  
          .rclk   (i_tx_cadence_fast_clk[idx_sys_cop]),
          .rreq   (1'b1),
          .rempty (),
          .data_valid (o_tx_cadence[idx_sys_cop])
        );
   end
   end //end for persystem
endgenerate


 genvar ig;
     for(ig=0;ig<num_sys_cop;ig=ig+1) begin:gts_dphy_adme
        alt_mge_phy_0_intel_directphy_gts_intel_adme_gts_200_fmptqqy #(
           .avmm1_addr_width   (l_av1_addr_bits)
        ) intel_adme_gts_inst (

           .avmm1_clk_user                ( i_reconfig_clk[ig] ),
           .avmm1_reset_user              ( i_reconfig_reset[ig] ),
           .avmm1_address_user            ( i_reconfig_address[ig*l_av1_addr_bits+:l_av1_addr_bits] ),
           .avmm1_byte_enable_user        ( i_reconfig_byteenable[ig*4+:4] ),
           .avmm1_write_user              ( i_reconfig_write[ig] ),
           .avmm1_read_user               ( i_reconfig_read[ig] ),
           .avmm1_write_data_user         ( i_reconfig_writedata[ig*32+:32] ),
           .avmm1_read_data_user          ( dphy_adme_avmm1_readdata[ig*32+:32] ),
           .avmm1_waitrequest_user        ( dphy_adme_avmm1_waitrequest[ig] ),
           .avmm1_read_data_valid_user    ( dphy_adme_avmm1_readdatavalid[ig] ),

           .avmm1_clk_tile                ( dphy_adme_avmm1_clk[ig] ),
           .avmm1_reset_tile              ( dphy_adme_avmm1_reset[ig] ),
           .avmm1_address_tile            ( dphy_adme_avmm1_address[ig*l_av1_addr_bits+:l_av1_addr_bits] ),
           .avmm1_byte_enable_tile        ( dphy_adme_avmm1_byteenable[ig*4+:4] ),
           .avmm1_write_tile              ( dphy_adme_avmm1_write[ig] ),
           .avmm1_read_tile               ( dphy_adme_avmm1_read[ig] ),
           .avmm1_write_data_tile         ( dphy_adme_avmm1_writedata[ig*32+:32] ),
           .avmm1_read_data_tile          ( dphy_avmm1_readdata[ig*32+:32] ),
           .avmm1_waitrequest_tile        ( dphy_avmm1_waitrequest[ig] ),
           .avmm1_read_data_valid_tile    ( dphy_avmm1_readdatavalid[ig] )

    );
     end
    assign  o_reconfig_readdata       = ( (avmm1_jtag_enable) ? dphy_adme_avmm1_readdata      : dphy_avmm1_readdata);
    assign  o_reconfig_waitrequest    = ( (avmm1_jtag_enable) ? dphy_adme_avmm1_waitrequest   : dphy_avmm1_waitrequest);
    assign  o_reconfig_readdatavalid  = ( (avmm1_jtag_enable) ? dphy_adme_avmm1_readdatavalid : dphy_avmm1_readdatavalid);

for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: avmmpersystem       
    // ch0 assignments
        assign i_hio_ch0_lavmm_clk       [idx_sys_cop]                    = i_hio_lavmm_clk       [(idx_sys_cop+0)] ;                                       
        assign i_hio_ch0_lavmm_rstn      [idx_sys_cop]                    = i_hio_lavmm_rstn      [(idx_sys_cop+0)] ;
        assign i_hio_ch0_lavmm_write     [idx_sys_cop]                    = i_hio_lavmm_write     [(idx_sys_cop+0)] ;                                       
        assign i_hio_ch0_lavmm_read      [idx_sys_cop]                    = i_hio_lavmm_read      [(idx_sys_cop+0)] ;                                    
        assign i_hio_ch0_lavmm_addr      [20*idx_sys_cop+:20]             = i_hio_lavmm_addr [(20)*(idx_sys_cop+0)+:(20)] ;   
        assign i_hio_ch0_lavmm_wdata     [32*idx_sys_cop+:32]             = i_hio_lavmm_wdata  [32*(idx_sys_cop+0)+:32] ;                             
        assign i_hio_ch0_lavmm_be        [4*idx_sys_cop+:4]               = i_hio_lavmm_be      [4*(idx_sys_cop+0)+:4] ;         
        
        assign o_hio_lavmm_rdata     [32*(idx_sys_cop+0)+:32]             = o_hio_ch0_lavmm_rdata[32*idx_sys_cop+:32];     
        assign o_hio_lavmm_waitreq      [(idx_sys_cop+0)]                 = o_hio_ch0_lavmm_waitreq[idx_sys_cop];
        assign o_hio_lavmm_rdata_valid  [(idx_sys_cop+0)]                 = o_hio_ch0_lavmm_rdata_valid[idx_sys_cop];
        
end

  

 intel_directphy_avmm #(
    .num_sys_cop                               (num_sys_cop),
    .num_xcvr_per_sys                          (num_xcvr_per_sys),
    .l_num_aib_per_xcvr                        (l_num_aib_per_xcvr),
    .l_sys_aibs                                (l_sys_aibs),
    .l_tx_enable                               (l_tx_enable),
    .l_rx_enable                               (l_rx_enable),
    .xcvr_type                                 ((bb_f_ehip_xcvr_type=="XCVR_TYPE_UX"? 1'b0 : 1'b1)),
    .modulation_type                           ((bb_f_ehip_xcvr_mode=="XCVR_MODE_NRZ")? 1'b0: 1'b1),
    .l_soft_csr_enable                         (l_soft_csr_enable),
    .l_line_rate_p1ghz                         (l_line_rate_p1ghz),
    .avmm1_readdv_enable                       (avmm1_readdv_enable),
    .fec_enable                                (fec_on),
    .avmm1_split                               (avmm1_split),
    .l_av1_enable                              (l_av1_enable),
    .l_av1_aib_enable                          (l_av1_aib_enable),
    .l_num_avmm1                               (l_num_avmm1),
    .l_av1_ifaces                              (l_av1_ifaces),
    .l_av1_addr_bits                           (l_av1_addr_bits)
  ) intel_directphy_avmm_inst (

    .reconfig_pdp_clk                          ( (avmm1_jtag_enable) ? dphy_adme_avmm1_clk           : i_reconfig_clk),
    .reconfig_pdp_reset                        ( (avmm1_jtag_enable) ? dphy_adme_avmm1_reset         : i_reconfig_reset),
    .reconfig_pdp_address                      ( (avmm1_jtag_enable) ? dphy_adme_avmm1_address       : i_reconfig_address),
    .reconfig_pdp_byteenable                   ( (avmm1_jtag_enable) ? dphy_adme_avmm1_byteenable    : i_reconfig_byteenable),     
    .reconfig_pdp_write                        ( (avmm1_jtag_enable) ? dphy_adme_avmm1_write         : i_reconfig_write),           
    .reconfig_pdp_read                         ( (avmm1_jtag_enable) ? dphy_adme_avmm1_read          : i_reconfig_read),            
    .reconfig_pdp_writedata                    ( (avmm1_jtag_enable) ? dphy_adme_avmm1_writedata     : i_reconfig_writedata),      
    .reconfig_pdp_readdata                     ( dphy_avmm1_readdata      ),       
    .reconfig_pdp_waitrequest                  ( dphy_avmm1_waitrequest   ),     
    .reconfig_pdp_readdatavalid                ( dphy_avmm1_readdatavalid ), 

// AVMM1 ports
      .pldif_o_lavmm_clk                             (i_hio_lavmm_clk        ) ,  //  input       [l_av1_ifaces-1:0]       
      .pldif_o_lavmm_rstn                            (i_hio_lavmm_rstn       ) ,  //  input       [l_av1_ifaces-1:0]       
      .pldif_o_lavmm_write                           (i_hio_lavmm_write         ),//(pldif_o_lavmm_write      ),  //  input       [l_av1_ifaces-1:0]       
      .pldif_o_lavmm_read                            (i_hio_lavmm_read          ),//(pldif_o_lavmm_read       ),  //  input       [l_av1_ifaces-1:0]       
      .pldif_o_lavmm_addr                            (i_hio_lavmm_addr          ),//(pldif_o_lavmm_addr       ),  //  input       [l_av1_addr_bits*l_av1_ifaces-1:0]  
      .pldif_o_lavmm_wdata                           (i_hio_lavmm_wdata         ),//(pldif_o_lavmm_wdata      ),  //  input       [l_av1_ifaces*32-1:0]     
      .pldif_o_lavmm_be                              (i_hio_lavmm_be            ),//(pldif_o_lavmm_be         ),  //  input       [l_av1_ifaces*4-1:0]      
      .pldif_i_lavmm_rdata                           (o_hio_lavmm_rdata         ),//(pldif_i_lavmm_rdata      ),  //  output      [l_av1_ifaces*32-1:0]     
      .pldif_i_lavmm_waitreq                         (o_hio_lavmm_waitreq       ),//(pldif_i_lavmm_waitreq    ),  //  output      [l_av1_ifaces-1:0]        
      .pldif_i_lavmm_rdata_valid                     (o_hio_lavmm_rdata_valid   ),//(pldif_i_lavmm_rdata_valid),  //  output      [l_av1_ifaces-1:0]        

// ctrl/status
    .dphy_reset_soft_tx_rst                        (dphy_reset_soft_tx_rst),
    .dphy_reset_tx_rst_ovr                         (dphy_reset_tx_rst_ovr),
    .dphy_reset_soft_rx_rst                        (dphy_reset_soft_rx_rst),
    .dphy_reset_rx_rst_ovr                         (dphy_reset_rx_rst_ovr),
    .dphy_reset_status_tx_rst_ack_n_i              (o_tx_reset_ack),
    .dphy_reset_status_rx_rst_ack_n_i              (o_rx_reset_ack),
    .dphy_reset_status_tx_ready_i                  (o_tx_ready),
    .dphy_reset_status_rx_ready_i                  (o_rx_ready),
    .phy_tx_pll_locked_tx_pll_locked_i             (o_tx_pll_locked),
    .phy_rx_cdr_locked_rx_cdr_locked_i             (o_rx_is_lockedtoref),
    .phy_rx_cdr_locked_rx_cdr_locked2data_i        (o_rx_is_lockedtodata),
    .src_ctrl_rx_ignore_locked2data                (w_src_ctrl_rx_ignore_locked2data),
    .tx_clear_alarm                                (tx_clear_alarm    ),
    .rx_clear_alarm                                (rx_clear_alarm    ),
    .tx_alarm                                      (tx_alarm          ),
    .rx_alarm                                      (rx_alarm          )
  );


//-----------------------------------------------------------------------------
//   Interface mapping:  XCVR IF
//-----------------------------------------------------------------------------
   
    assign o_tx_fifo_full                 = o_hio_txdata_fifo_wr_full;
    assign o_tx_fifo_empty                = o_hio_txdata_fifo_wr_empty;
    assign o_tx_fifo_pfull                = o_hio_txdata_fifo_wr_pfull;
    assign o_tx_fifo_pempty               = o_hio_txdata_fifo_wr_pempty;
    assign o_rx_fifo_full                 = o_hio_rxdata_fifo_rd_full;
    assign o_rx_fifo_empty                = o_hio_rxdata_fifo_rd_empty;
    assign o_rx_fifo_pfull                = o_hio_rxdata_fifo_rd_pfull;
    assign o_rx_fifo_pempty               = o_hio_rxdata_fifo_rd_pempty;
    assign i_hio_rxdata_fifo_rd_en      = i_rx_fifo_rd_en;

//-----------------------------------------------------------------------------
//   Interface mapping:  Clocks and Data
//-----------------------------------------------------------------------------
     // TO DO, map the parallel data in simplified data bus
     // for now, just pass through
    //assign i_hio_txdata                 = int_tx_parallel_data;
    //assign o_rx_parallel_data                    = o_hio_rxdata;                     



   generate
      for (idx_sys_cop = 0; idx_sys_cop < num_sys_cop; idx_sys_cop = idx_sys_cop + 1) begin: tx_deskew_generate_block

      // TX de-skew pulse generation ////
     dphy_tx_dsk_gen # 
             (
              .WIDTH            (80),
              .LANES            (num_xcvr_per_sys * l_num_aib_per_xcvr),
              .FEC_ON           (fec_on),
              .FEC_MODE         (l_fec_mode),
	      .pldif_tx_fifo_mode (pldif_tx_fifo_mode),
              .DOUBLE_WIDTH_ON  (pldif_tx_double_width_transfer_enable)
              )
     tx_dsk_gen_inst
             (
              // Outputs
              .o_data       (int_tx_parallel_data[((idx_sys_cop) * num_xcvr_per_sys * l_num_aib_per_xcvr * 80) +: (num_xcvr_per_sys * l_num_aib_per_xcvr * 80)]),
              // Inputs
              .i_clk        (i_tx_coreclkin[idx_sys_cop * num_xcvr_per_sys * l_num_aib_per_xcvr]),    
              //    .i_reset      (i_tx_reset),   
              .i_data       (tx_parallel_data_sel[((idx_sys_cop) * num_xcvr_per_sys * l_num_aib_per_xcvr * 80) +: (num_xcvr_per_sys * l_num_aib_per_xcvr * 80)])
              );
      end : tx_deskew_generate_block
   endgenerate

generate
  genvar k; 
       for(k=0; k<l_sys_xcvrs; k=k+1) begin: tx_data_sel
           assign tx_parallel_data_sel[k*80+:80] =  txsimpleinterface_enable ? {i_tx_parallel_data[((k*76)+36)+:40],i_tx_pma_elecidle[((4*k)+3)],i_tx_parallel_data[((76*k)+35)],i_tx_pma_elecidle[k*4+:3],i_tx_parallel_data[k*76+:35]} : i_tx_parallel_data[k*80+:80];
           assign i_hio_txdata[k]                = int_tx_parallel_data[k*80+:80];
       end    
endgenerate



// RX de-skew ////
localparam rx_deskew_bit        = pldif_rx_double_width_transfer_enable ? 7'd78 : 7'd36; 
localparam rx_deskew_on         = rx_deskew_en && l_rx_deskew_enable;

localparam l_per_rx_dsk_inst    = fec_on ? (l_num_aib_per_xcvr*num_xcvr_per_sys) : l_num_aib_per_xcvr;
localparam num_rx_dsk_inst      = fec_on ? 1 : num_xcvr_per_sys; //per sys

   reg  [l_sys_xcvrs-1:0][80-1:0]                rx_skewed_data;
   reg  [l_sys_xcvrs-1:0]                        rx_skewed_pulse;
   wire [l_sys_xcvrs-1:0][80-1:0]                o_aib_deskew_data;
   wire [num_rx_dsk_inst*num_sys_cop-1:0]       int_o_deskew_done;
   wire [num_sys_cop-1:0]                       o_deskew_done;
   reg  [l_sys_xcvrs*80-1:0]                     int_rx_parallel_data;
   

generate
if (rx_deskew_on) begin: directphy_rx_deskew
   wire [num_sys_cop-1:0]                                rx_deskew_reset_n_fec_per_sys;
   wire [num_xcvr_per_sys*num_sys_cop-1:0]               rx_deskew_reset_n;
   wire [num_xcvr_per_sys*num_sys_cop-1:0]               rx_deskew_reset_n_resync;

  genvar l;
       for(l=0;l<l_sys_xcvrs;l=l+1)begin: skewed_data_ln
          // assign rx_skewed_data[l] = o_hio_rxdata[l*80+:80];
          // assign rx_skewed_pulse[l] = o_hio_rxdata[l*80+rx_deskew_bit]; //de-skew bit
          assign rx_skewed_data[l] = o_hio_rxdata[l];
          assign rx_skewed_pulse[l] = o_hio_rxdata[l][rx_deskew_bit]; //de-skew bit
       end
 for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: persys
     
   // RX de-skew reset
     assign rx_deskew_reset_n_fec_per_sys[idx_sys_cop] = &rx_lane_out_of_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
     assign rx_deskew_reset_n[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys] = fec_on ? {{num_xcvr_per_sys}{rx_deskew_reset_n_fec_per_sys[idx_sys_cop]}} : rx_lane_out_of_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]; 

     genvar idx_rx_dsk_inst;
     for (idx_rx_dsk_inst=idx_sys_cop*num_rx_dsk_inst;idx_rx_dsk_inst<num_rx_dsk_inst*(idx_sys_cop+1);idx_rx_dsk_inst=idx_rx_dsk_inst+1) begin: per_rx_dsk_inst

           localparam idx_rx_dsk_rst = fec_on ? idx_rx_dsk_inst*num_xcvr_per_sys : idx_rx_dsk_inst;

             alt_xcvr_resync_etile #(
                           .SYNC_CHAIN_LENGTH (2),
                           .WIDTH(1),
                           .INIT_VALUE(0)
                           ) U_rst_resync_inst (
                          .clk   (i_rx_coreclkin[idx_rx_dsk_inst*l_per_rx_dsk_inst]),
                          .reset (1'b0),
                          .d     (rx_deskew_reset_n[idx_rx_dsk_rst]),
                          .q     (rx_deskew_reset_n_resync[idx_rx_dsk_rst])
                     );        

           directphy_rx_deskew  #(.WIDTH       (80),
                                  .LANES       (l_per_rx_dsk_inst),
                                  .SIM_EMULATE (0)
                                 ) U_aib_dsk_rx (
                                 // Outputs
                                  .o_data           (o_aib_deskew_data[idx_rx_dsk_inst*l_per_rx_dsk_inst+:l_per_rx_dsk_inst]), 
                                  .o_deskew_done    (int_o_deskew_done[idx_rx_dsk_inst]),
                                 // Inputs
                                  .i_clk            (i_rx_coreclkin[idx_rx_dsk_inst*l_per_rx_dsk_inst]),    
                                  .i_reset          (~rx_deskew_reset_n_resync[idx_rx_dsk_rst]),   
                                  .i_data           (rx_skewed_data[idx_rx_dsk_inst*l_per_rx_dsk_inst+:l_per_rx_dsk_inst]), 
                                  .i_sync_pulse     (rx_skewed_pulse[idx_rx_dsk_inst*l_per_rx_dsk_inst+:l_per_rx_dsk_inst])); 
      end // per_rx_dsk_inst
      assign o_deskew_done[idx_sys_cop] = &int_o_deskew_done[idx_sys_cop*num_rx_dsk_inst+:num_rx_dsk_inst];

  end // persys       
                     for(l=0;l<l_sys_xcvrs;l=l+1)begin: deskew_data_ln
                      assign int_rx_parallel_data[l*80+:80] = o_aib_deskew_data[l];
                       end
    assign o_rx_parallel_data = int_rx_parallel_data;
    //assign o_rx_ready = int_rx_ready&o_deskew_done; //// RECHECK 09/11/2022
end // directphy_rx_deskew
else begin // NOT directphy_rx_deskew
     //assign o_rx_parallel_data = o_hio_rxdata;
            genvar l;
            for(l=0;l<l_sys_xcvrs;l=l+1)begin: rx_data
                assign o_rx_parallel_data[l*80+:80] = o_hio_rxdata[l];
            end
     //assign o_rx_ready = int_rx_ready;                //// RECHECK 09/11/2022
     assign o_deskew_done = {(num_sys_cop){1'b0}}; 
end // NOT directphy_rx_deskew

endgenerate


//TEST SIMULATION ED
    reg     [num_sys_cop-1:0]       tx_reset_ack_reg;
    reg     [num_sys_cop-1:0]       rx_reset_ack_reg;
    reg     [num_sys_cop-1:0]       tx_ready_reg;
    reg     [num_sys_cop-1:0]       rx_ready_reg;

generate
    if (simulation_sip_only == 1)          // <-----TEST SIMULATION ED
    begin
       
        assign o_tx_reset_ack = tx_reset_ack_reg;
        assign o_rx_reset_ack = rx_reset_ack_reg;
        assign o_tx_ready     = tx_ready_reg;
        assign o_rx_ready     = rx_ready_reg;

        always @(posedge i_tx_coreclkin , posedge i_tx_reset)
         begin
            if(i_tx_reset)
            begin
                tx_reset_ack_reg    <= i_tx_reset;
                tx_ready_reg        <= 1'b0;
            end
            else
            begin
                tx_reset_ack_reg    <= i_tx_reset;
                tx_ready_reg        <= 1'b1;
            end
        end

        always @(posedge i_rx_coreclkin , posedge i_rx_reset)
         begin
            if(i_rx_reset)
            begin

                rx_reset_ack_reg    <= i_rx_reset;
                rx_ready_reg        <= 1'b0;
            end
            else
            begin
                rx_reset_ack_reg    <= i_rx_reset;
                rx_ready_reg        <= 1'b1;
            end
        end

            for (idx_sys_cop = 0; idx_sys_cop < l_sys_xcvrs; idx_sys_cop = idx_sys_cop + 1) begin: ed_simulation_block2

                assign w_hio_rst_ux_all_synthlockstatus[idx_sys_cop]    = 1'b1;
                assign w_hio_rst_ux_octl_pcs_txstatus[idx_sys_cop]      = 1'b1;
                assign o_rx_is_lockedtodata[idx_sys_cop]                  = 1'b1;
                assign o_rx_is_lockedtoref[idx_sys_cop]                   = 1'b1;
            
              end : ed_simulation_block2
        
        assign o_tx_pll_locked = w_hio_rst_ux_all_synthlockstatus & w_hio_rst_ux_octl_pcs_txstatus ;
    end  
    else
    begin
        assign o_tx_pll_locked            = o_hio_rst_ux_all_synthlockstatus & o_hio_rst_ux_octl_pcs_txstatus ;
        assign o_rx_is_lockedtodata       = o_hio_rst_ux_rxcdrlock2data;
        assign o_rx_is_lockedtoref        = o_hio_rst_ux_rxcdrlockstatus;
        
        //-----------------------------------------------------------------------------
        //    HW Block <-> Soft-IP
        //-----------------------------------------------------------------------------
         //assign    w_pld_pma_ppm_lock = i_fec_snapshot;
        
        // And together all the lane state wires of one system to get a top-level output.  
        
              // Connect soft reset controller current lane state outputs
        for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: persystem
            
               // Ingress_231 GPON signal routing through SRC
                assign w_dphy_iflux_ingress_input[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  = i_rx_cdr_freeze[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
            //-----------------------------------------------------------------------------
            //   Interface mapping:  RSFEC
            //-----------------------------------------------------------------------------
            if (num_fec_ch>0) begin:mapping_fec
                assign  o_fec_status_rx_not_deskew[idx_sys_cop] = w_fec_not_deskew[idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr];
                assign  o_fec_status_rx_not_locked[idx_sys_cop] = w_fec_not_locked[idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr];
                assign   o_fec_status_rx_not_align[idx_sys_cop] = w_fec_not_align[idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr];
                assign                    o_fec_sf[idx_sys_cop] = o_hio_rstfec_fec_rx_rdy_n[idx_sys_cop*num_xcvr_per_sys*l_num_aib_per_xcvr];
                //assign                   fec_ready = w_ehip__o_hip_ready;
            end
            

            genvar idx_xcvr;
            for (idx_xcvr=0;idx_xcvr<num_xcvr_per_sys;idx_xcvr=idx_xcvr+1) begin: perxcvr
                localparam idx_sys_xcvr = num_xcvr_per_sys*idx_sys_cop + idx_xcvr;
                 // Connect soft reset controller desired lane state inputs
                // For right now, there is a single i_tx_reset and a single i_rx_reset input - JRJ
                      assign tx_lane_desired_state[idx_sys_xcvr] = (dphy_reset_tx_rst_ovr[idx_sys_cop])? dphy_reset_soft_tx_rst[idx_sys_cop] : i_tx_reset[idx_sys_cop];
                      assign rx_lane_desired_state[idx_sys_xcvr] = (dphy_reset_rx_rst_ovr[idx_sys_cop])? dphy_reset_soft_rx_rst[idx_sys_cop] : i_rx_reset[idx_sys_cop];
                

        assign tx_lane_is_in_reset[idx_sys_xcvr]  = (tx_lane_current_state[idx_sys_xcvr][1:0] == 2'b00);    // <--- new logic for o_tx_reset_ack
                assign rx_lane_is_in_reset[idx_sys_xcvr]  = (rx_lane_current_state[idx_sys_xcvr][1:0] == 2'b00);    // <--- new logic for o_rx_reset_ack
                assign tx_lane_out_of_reset[idx_sys_xcvr] = (tx_lane_current_state[idx_sys_xcvr][1:0] == 2'b01);    // <--- new logic for tx reset done
                assign rx_lane_out_of_reset[idx_sys_xcvr] = (rx_lane_current_state[idx_sys_xcvr][1:0] == 2'b01);    // <--- new logic for rx reset done
                assign i_hio_ehip_signal_ok[idx_sys_xcvr]      = (rx_lane_current_state[idx_sys_xcvr][1:0]==2'b01);
               
		assign i_hio_txdata_fifo_wr_en[idx_sys_xcvr] = i_hio_txdata[idx_sys_xcvr][79]; // ELASTIC MODE
 
                // Connect soft reset controller sip_am_gen_start and sip_am_gen_2x_ack ports for each transceiver
                    assign tx_per_lane_sip_am_gen_start[idx_sys_cop][idx_xcvr] = sip_am_gen_start[idx_sys_xcvr];
                    assign sip_am_gen_2x_ack[idx_sys_xcvr] = tx_per_lane_sip_am_gen_2x_ack[idx_sys_cop][idx_xcvr];
            end // end for perxcvr
        
            assign sip_rx_ignore_lock2data[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys] = {num_xcvr_per_sys{w_src_ctrl_rx_ignore_locked2data[idx_sys_cop]}};
        // Ingress_231 GPON signal routing through SRC
        //assign i_dphy_iflux_ingress_input[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]  = i_rx_cdr_freeze[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys]; // No i_dphy_iflux_ingress_input signal
        
        assign o_tx_reset_ack[idx_sys_cop] = &tx_lane_is_in_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
        assign o_rx_reset_ack[idx_sys_cop] = &rx_lane_is_in_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
        assign o_tx_ready[idx_sys_cop]     = &tx_lane_out_of_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
        assign o_rx_ready[idx_sys_cop]     = &rx_lane_out_of_reset[idx_sys_cop*num_xcvr_per_sys +: num_xcvr_per_sys];
        
        // Assign the alignment marker start and acknowledge lines
        assign o_tx_am_gen_start[idx_sys_cop] = &tx_per_lane_sip_am_gen_start[idx_sys_cop];
        assign tx_per_lane_sip_am_gen_2x_ack[idx_sys_cop] = {num_xcvr_per_sys {i_tx_am_gen_2x_ack[idx_sys_cop]}};
        // Num channel 0
        assign i_hio_ch0_pld_rx_clk_in_row_clk  [idx_sys_cop]             =  i_rx_coreclkin[idx_sys_cop+0]                      ;
        assign i_hio_ch0_pld_tx_clk_in_row_clk  [idx_sys_cop]             =  i_tx_coreclkin[idx_sys_cop+0]                      ;
        assign o_rx_clkout    [idx_sys_cop+0]                =  o_hio_ch0_user_rx_clk1_clk     [idx_sys_cop]        ;
        assign o_rx_clkout2   [idx_sys_cop+0]                =  o_hio_ch0_user_rx_clk2_clk     [idx_sys_cop]        ;
        assign o_tx_clkout    [idx_sys_cop+0]                =  o_hio_ch0_user_tx_clk1_clk      [idx_sys_cop]       ;
        assign o_tx_clkout2   [idx_sys_cop+0]                =  o_hio_ch0_user_tx_clk2_clk      [idx_sys_cop]       ;
        assign o_refclk2core  [idx_sys_cop+0]                =  o_hio_ch0_ux_chnl_refclk_mux    [idx_sys_cop]       ;
        //assign w_hio_pld_reset_clk_row[0]                  =  w_hio_ch0_lavmm_clk                    ;
        
        end // end for persystem
        
        //-----------------------------------------------------------------------------
        //   Interface mapping:  UX
        //-----------------------------------------------------------------------------
        //assign o_rx_signal_detect      = w_oct_pcs_rxsignaldetect_lx_a;// 23.2 not supported Need PFE FPGA.AR 16020319472     
        //assign o_rx_signal_detect_lfps = w_octl_pcs_rxsignaldetect_lfps_lx_a;
        
        assign w_ictl_pcs_rxovrcdrlock2dataen_lx_a        = i_rx_set_locktoref;
        //assign w_ictl_pcs_rxovrcdrlock2data_lx_a          = i_rx_set_locktodata;
	assign w_ictl_pcs_txbeacon_lx_a                   = 0;// 23.2 not supported Need PFE FPGA.AR 16020319472 i_tx_beacon;
        assign w_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t   = i_rx_cdr_fast_freeze_sel;
        assign w_ictl_pcs_rxeiosdetectstat_lx_a           = i_rx_cdr_set_locktoref;
                
        //-----------------------------------------------------------------------------
        //   Interface mapping:  XCVR IF
        //-----------------------------------------------------------------------------
        assign  o_rx_pmaif_fifo_empty     = w_xcvrif_rxfifo_empty;
        assign  o_rx_pmaif_fifo_pempty    = w_xcvrif_rxfifo_pempty;
        assign  o_rx_pmaif_fifo_pfull     = w_xcvrif_rxfifo_pfull;
                                          
        assign  o_tx_pmaif_fifo_empty     = w_xcvrif_txfifo_empty;
        assign  o_tx_pmaif_fifo_pempty    = w_xcvrif_txfifo_pempty;
        assign  o_tx_pmaif_fifo_pfull     = w_xcvrif_txfifo_pfull;

        //assign xcvrif_hold_interrupt    = w_xcvrif_hold_inter;
        
                
 ////  for IP SDC ////
            wire [l_sys_xcvrs-1:0] dummy_tx_user_clk1_wire /* synthesis syn_noprune syn_preserve = 1 */;
            reg  [l_sys_xcvrs-1:0] dummy_tx_user_clk1_reg /* synthesis syn_noprune syn_preserve = 1 */;

            wire [l_sys_xcvrs-1:0] dummy_tx_user_clk2_wire /* synthesis syn_noprune syn_preserve = 1 */;
            reg  [l_sys_xcvrs-1:0] dummy_tx_user_clk2_reg /* synthesis syn_noprune syn_preserve = 1 */;

            wire [l_sys_xcvrs-1:0] dummy_rx_user_clk1_wire /* synthesis syn_noprune syn_preserve = 1 */;
            reg  [l_sys_xcvrs-1:0] dummy_rx_user_clk1_reg /* synthesis syn_noprune syn_preserve = 1 */;

            wire [l_sys_xcvrs-1:0] dummy_rx_user_clk2_wire /* synthesis syn_noprune syn_preserve = 1 */;
            reg  [l_sys_xcvrs-1:0] dummy_rx_user_clk2_reg /* synthesis syn_noprune syn_preserve = 1 */;
for(idx_sys_cop=0;idx_sys_cop<num_sys_cop;idx_sys_cop=idx_sys_cop+1) begin: dummypersystem  
        // Num channel 0
            assign dummy_tx_user_clk1_wire[idx_sys_cop+0] = 1'b0;
            assign dummy_tx_user_clk2_wire[idx_sys_cop+0] = 1'b0;
            assign dummy_rx_user_clk1_wire[idx_sys_cop+0] = 1'b0;
            assign dummy_rx_user_clk2_wire[idx_sys_cop+0] = 1'b0;
            
            always @ (posedge o_tx_clkout[idx_sys_cop+0]) begin
                dummy_tx_user_clk1_reg[idx_sys_cop+0] <= dummy_tx_user_clk1_wire[idx_sys_cop+0];
            end

            always @ (posedge o_tx_clkout2[idx_sys_cop+0]) begin
                dummy_tx_user_clk2_reg[idx_sys_cop+0] <= dummy_tx_user_clk2_wire[idx_sys_cop+0];
            end

            always @ (posedge o_rx_clkout[idx_sys_cop+0]) begin
                dummy_rx_user_clk1_reg[idx_sys_cop+0] <= dummy_rx_user_clk1_wire[idx_sys_cop+0];
            end

            always @ (posedge o_rx_clkout2[idx_sys_cop+0]) begin
                dummy_rx_user_clk2_reg[idx_sys_cop+0] <= dummy_rx_user_clk2_wire[idx_sys_cop+0];
            end
            
end // dummypersystem


        sip_async_mapping #(
            .num_sys_cop  (num_sys_cop),
            .l_sys_xcvrs  (l_sys_xcvrs)   
        ) sip_async_mapping_inst (

            //.i_rxelecidle                               (i_rxelecidle                               ), // i_hio_uxquad_async    Maybe Needed Later
            //.i_ictl_pcs_txbist_en_lx_a                  (i_ictl_pcs_txbist_en_lx_a                  ), // i_hio_uxquad_async    No connection    
            //.i_ictl_pcs_rxbist_en_lx_a                  (i_ictl_pcs_rxbist_en_lx_a                  ), // i_hio_uxquad_async    No connection
            //.i_ictl_pcs_rxeyediag_start_lx_a            (i_ictl_pcs_rxeyediag_start_lx_a            ), // i_hio_uxquad_async    No connection
            //.i_ictl_pcs_rxeq_clr_lx_a                   (i_ictl_pcs_rxeq_clr_lx_a                   ), // i_hio_uxquad_async    No connection
            //.i_ictl_pcs_andme_en_lx_a                   (i_ictl_pcs_andme_en_lx_a                   ), // i_hio_uxquad_async    No connection
            //.ictl_pcs_rxovrcdrlock2data_lx_a              (w_ictl_pcs_rxovrcdrlock2data_lx_a          ), // i_hio_uxquad_async
            .ictl_pcs_rxovrcdrlock2dataen_lx_a            (w_ictl_pcs_rxovrcdrlock2dataen_lx_a        ), // i_hio_uxquad_async
            .i_det_lat_rx_mux_select                        (i_det_lat_rx_mux_select),
            .i_det_lat_tx_mux_select                        (i_det_lat_tx_mux_select),
                                                                                                       
            //.i_tx_pfc                                   (i_tx_pfc                                   ), // i_hio_txdata_async    No connection
            //.i_tx_pause                                 (i_tx_pause                                 ), // i_hio_txdata_async    No connection
            //.i_pld_ready                                (i_pld_ready                                ), // i_hio_txdata_async
            //.i_clear_internal                           (i_clear_internal                           ), // i_hio_txdata_async
            .i_take_snapshot                            (i_fec_snapshot                               ), // i_hio_txdata_async
                                                                                                       
            .ictl_pcs_txbeacon_lx_a                     (w_ictl_pcs_txbeacon_lx_a                   ), // i_hio_uxquad_async_pcie_mux
            .i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t     (w_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t     ), // NO Connection // connected to hip in Ftile
            .ictl_pcs_rxeiosdetectstat_lx_a             (w_ictl_pcs_rxeiosdetectstat_lx_a           ), // i_hio_uxquad_async_pcie_mux
            .i_dphy_iflux_ingress_input                 (w_dphy_iflux_ingress_input                 ), // NO Connection // Connected via QTLG In SIP in FTILE
            //.i_pld_pma_ppm_lock                         (w_pld_pma_ppm_lock                         ), // NO Connection // connected to hip in Ftile
                                                                                                       
            .oct_pcs_rxsignaldetect_lx_a                (w_oct_pcs_rxsignaldetect_lx_a              ), // NO Connection // connected to hip in Ftile
            .octl_pcs_rxsignaldetect_lfps_lx_a          (w_octl_pcs_rxsignaldetect_lfps_lx_a        ), // NO Connection // connected to hip in Ftile
            .o_pcs_rx_sf                                (w_pcs_rx_sf                                ), // NO Connection // connected to hip_aib_ssr_out in Ftile
            .o_xcvrif_hold_inter                        (w_xcvrif_hold_inter                        ), // NO Connection
 //           .o_refclk2core                              (o_refclk2core                              ), // NO Connection
                                                                                                       
            .o_fec_not_align                            (w_fec_not_align                            ), // o_hio_rxdata_async
            .o_fec_not_deskew                           (w_fec_not_deskew                           ), // o_hio_rxdata_async
            .o_fec_not_locked                           (w_fec_not_locked                           ), // o_hio_rxdata_async
            .o_xcvrif_rxfifo_empty                      (w_xcvrif_rxfifo_empty                      ), // o_hio_rxdata_async
            .o_xcvrif_rxfifo_pempty                     (w_xcvrif_rxfifo_pempty                     ), // o_hio_rxdata_async
            .o_xcvrif_rxfifo_pfull                      (w_xcvrif_rxfifo_pfull                      ), // o_hio_rxdata_async
            .o_xcvrif_txfifo_empty                      (w_xcvrif_txfifo_empty                      ), // o_hio_rxdata_async
            .o_xcvrif_txfifo_pempty                     (w_xcvrif_txfifo_pempty                     ), // o_hio_rxdata_async
            .o_xcvrif_txfifo_pfull                      (w_xcvrif_txfifo_pfull                      ), // o_hio_rxdata_async
            .o_rx_block_lock                            (o_rx_block_lock                            ), // o_hio_rxdata_async
            .o_rx_am_lock                               (o_rx_am_lock                               ), // o_hio_rxdata_async
            .o_local_fault_status                       (o_local_fault_status                       ), // o_hio_rxdata_async
            .o_rx_hi_ber                                (o_rx_hi_ber                                ), // o_hio_rxdata_async
            .o_rx_pcs_fully_aligned                     (o_rx_pcs_fully_aligned                     ), // o_hio_rxdata_async
            //.o_rx_pcs_internal_err                      (o_rx_pcs_internal_err                      ), // o_hio_rxdata_async
            //.o_rx_dsk_done                              (o_rx_dsk_done                              ), // o_hio_rxdata_async
            //.o_hip_ready                                (o_hip_ready                                ), // o_hio_rxdata_async
            //.o_tx_deskew_error                          (o_tx_deskew_error                          ), // o_hio_rxdata_async
            //.o_rx_fifo_underflow                        (o_rx_fifo_underflow                        ), // o_hio_rxdata_async
            //.o_rx_fifo_overflow                         (o_rx_fifo_overflow                         ), // o_hio_rxdata_async
            //.o_rx_pfc                                   (o_rx_pfc                                   ), // o_hio_rxdata_async
            //.o_rx_pause                                 (o_rx_pause                                 ), // o_hio_rxdata_async
            //.o_remote_fault                             (o_remote_fault                             ), // o_hio_rxdata_async
            //.o_tx_lane_hold_inter                       (o_tx_lane_hold_inter                       ), // o_hio_rxdata_async
            //.o_rx_lane_hold_inter                       (o_rx_lane_hold_inter                       ), // o_hio_rxdata_async
            //.o_rx_aggr_hold_inter                       (o_rx_aggr_hold_inter                       ), // o_hio_rxdata_async
            //.o_xcvrif_rxfifo_gb_restarted               (o_xcvrif_rxfifo_gb_restarted               ), // o_hio_rxdata_async
            //.o_xcvrif_txfifo_gb_restarted               (o_xcvrif_txfifo_gb_restarted               ), // o_hio_rxdata_async
            //.o_sm_xcvrif_irq_hold                       (o_sm_xcvrif_irq_hold                       ), // o_hio_rxdata_async
                                                                                                       
            //.o_flux_srds_rdy                            (o_flux_srds_rdy                            ), // o_hio_uxquad_async
            //.o_flux_int                                 (o_flux_int                                 ), // o_hio_uxquad_async
            //.o_flux_cpi_int                             (o_flux_cpi_int                             ), // o_hio_uxquad_async
            //.o_octl_pcs_synthlcfast_ready_a             (o_octl_pcs_synthlcfast_ready_a             ), // o_hio_uxquad_async
            //.o_octl_pcs_synthlcslow_ready_a             (o_octl_pcs_synthlcslow_ready_a             ), // o_hio_uxquad_async
            //.o_octl_pcs_cmn_ready_a                     (o_octl_pcs_cmn_ready_a                     ), // o_hio_uxquad_async
            //.o_octl_pcs_rxbist_done_lx_a                (o_octl_pcs_rxbist_done_lx_a                ), // o_hio_uxquad_async
            //.o_octl_pcs_rxbist_rxlocked_lx_a            (o_octl_pcs_rxbist_rxlocked_lx_a            ), // o_hio_uxquad_async
            //.o_odat_pcs_rxbist_errcount_lx_a            (o_odat_pcs_rxbist_errcount_lx_a            ), // o_hio_uxquad_async

            .i_hio_uxquad_async                         (i_hio_uxquad_async                         ), 
            .i_hio_uxquad_async_pcie_mux                (i_hio_uxquad_async_pcie_mux                ), 
            .o_hio_uxquad_async                         (w_hio_uxquad_async                         ), 
            .i_hio_txdata_async                         (i_hio_txdata_async                         ), 
            .i_hio_txdata_direct                        (i_hio_txdata_direct                        ), // NO Connection
            .o_hio_rxdata_async                         (w_hio_rxdata_async                         ), 
            .o_hio_rxdata_direct                        (o_hio_rxdata_direct                        ));// NO Connection 

        
        
    end
endgenerate

   

//TEST SIMULATION ED   
    
endmodule

// Change log:



