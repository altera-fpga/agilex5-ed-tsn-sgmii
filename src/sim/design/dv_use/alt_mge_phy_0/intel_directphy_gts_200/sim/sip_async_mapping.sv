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
module sip_async_mapping #(
    parameter          num_sys_cop                                              = 1,
    parameter          num_xcvr_per_sys                                         = 1,
    parameter          l_sys_xcvrs                                              = 1,
    parameter          l_sys_aibs                                               = 1
    ) (  
                                                                                                    
    input       [l_sys_xcvrs-1:0]                       i_rxelecidle,                               // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       i_ictl_pcs_txbist_en_lx_a,                  // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       i_ictl_pcs_rxbist_en_lx_a,                  // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       i_ictl_pcs_rxeyediag_start_lx_a,            // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       i_ictl_pcs_rxeq_clr_lx_a,                   // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       i_ictl_pcs_andme_en_lx_a,                   // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       ictl_pcs_rxovrcdrlock2data_lx_a,            // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       ictl_pcs_rxovrcdrlock2dataen_lx_a,          // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       i_det_lat_rx_mux_select,                    // i_hio_uxquad_async
    input       [l_sys_xcvrs-1:0]                       i_det_lat_tx_mux_select,                    // i_hio_uxquad_async
    
    input       [l_sys_xcvrs-1:0]   [7:0]               i_tx_pfc,                                   // i_hio_txdata_async
    input       [l_sys_xcvrs-1:0]                       i_tx_pause ,                                // i_hio_txdata_async
    input       [l_sys_xcvrs-1:0]                       i_pld_ready,                                // i_hio_txdata_async
    input       [l_sys_xcvrs-1:0]                       i_clear_internal,                           // i_hio_txdata_async
    input       [l_sys_xcvrs-1:0]                       i_take_snapshot,                            // i_hio_txdata_async
    
    input       [l_sys_xcvrs-1:0]                       ictl_pcs_txbeacon_lx_a,                     // i_hio_uxquad_async_pcie_mux
    input       [l_sys_xcvrs-1:0]                       i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t,     // NO Connection // connected to hip in Ftile
    input       [l_sys_xcvrs-1:0]                       ictl_pcs_rxeiosdetectstat_lx_a,             // i_hio_uxquad_async_pcie_mux
    input       [l_sys_xcvrs-1:0]                       i_dphy_iflux_ingress_input,                 // NO Connection // Connected via QTLG In SIP in FTILE
    input       [l_sys_xcvrs-1:0]                       i_pld_pma_ppm_lock,                         // NO Connection // connected to hip in Ftile
    
    output      [l_sys_xcvrs-1:0]                       oct_pcs_rxsignaldetect_lx_a,                // NO Connection // connected to hip in Ftile
    output      [l_sys_xcvrs-1:0]                       octl_pcs_rxsignaldetect_lfps_lx_a,          // NO Connection // connected to hip in Ftile
    output      [l_sys_xcvrs-1:0]                       o_pcs_rx_sf,                                // NO Connection // connected to hip_aib_ssr_out in Ftile
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_hold_inter,                        // NO Connection
    
    output      [l_sys_xcvrs-1:0]                       o_fec_not_align,                            // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_fec_not_deskew,                           // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_fec_not_locked,                           // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_rxfifo_empty,                      // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_rxfifo_pempty,                     // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_rxfifo_pfull,                      // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_txfifo_empty,                      // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_txfifo_pempty,                     // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_txfifo_pfull,                      // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_block_lock,                            // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_am_lock,                               // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_local_fault_status,                       // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_hi_ber,                                // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_pcs_fully_aligned,                     // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_pcs_internal_err,                      // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_dsk_done,                              // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_hip_ready,                                // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_tx_deskew_error,                          // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_fifo_underflow,                        // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_fifo_overflow,                         // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]   [7:0]               o_rx_pfc,                                   // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_pause,                                 // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_remote_fault,                             // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_tx_lane_hold_inter,                       // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_lane_hold_inter,                       // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_rx_aggr_hold_inter,                       // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_rxfifo_gb_restarted,               // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_xcvrif_txfifo_gb_restarted,               // o_hio_rxdata_async
    output      [l_sys_xcvrs-1:0]                       o_sm_xcvrif_irq_hold,                       // o_hio_rxdata_async
    
    output      [l_sys_xcvrs-1:0]               	    o_flux_srds_rdy,                            // o_hio_uxquad_async
    output      [l_sys_xcvrs-1:0]               	    o_flux_int,                                 // o_hio_uxquad_async
    output      [l_sys_xcvrs-1:0]               	    o_flux_cpi_int,                             // o_hio_uxquad_async
    output      [l_sys_xcvrs-1:0]               	    o_octl_pcs_synthlcfast_ready_a,             // o_hio_uxquad_async
    output      [l_sys_xcvrs-1:0]               	    o_octl_pcs_synthlcslow_ready_a,             // o_hio_uxquad_async
    output      [l_sys_xcvrs-1:0]               	    o_octl_pcs_cmn_ready_a,                     // o_hio_uxquad_async
    output      [l_sys_xcvrs-1:0]               	    o_octl_pcs_rxbist_done_lx_a,                // o_hio_uxquad_async
    output      [l_sys_xcvrs-1:0]               	    o_octl_pcs_rxbist_rxlocked_lx_a,            // o_hio_uxquad_async
    output      [l_sys_xcvrs-1:0]   [31:0]         	    o_odat_pcs_rxbist_errcount_lx_a,            // o_hio_uxquad_async
        
    output      [l_sys_xcvrs-1:0]   [79:0]              i_hio_uxquad_async,             
    output      [l_sys_xcvrs-1:0]   [79:0]              i_hio_uxquad_async_pcie_mux,                
    input       [l_sys_xcvrs-1:0]   [49:0]              o_hio_uxquad_async,                         
                                                        
    output      [l_sys_xcvrs-1:0]   [99:0]              i_hio_txdata_async,                         
    output      [l_sys_xcvrs-1:0]   [9:0]               i_hio_txdata_direct,                        // NO Connection
    input       [l_sys_xcvrs-1:0]   [99:0]              o_hio_rxdata_async,                         
    input       [l_sys_xcvrs-1:0]   [9:0]               o_hio_rxdata_direct                         // NO Connection
    
    );

genvar idx_xcvr;
genvar idx_sys_cop;
    
//-----------------------------------------------------------------------------
//   i_hio_uxquad_async Mapping from SIP
//-----------------------------------------------------------------------------
generate
    for (idx_xcvr=0;idx_xcvr<l_sys_xcvrs;idx_xcvr=idx_xcvr+1) begin: o_uxquad_async
    
        //assign i_hio_uxquad_async[idx_xcvr] [79:10]         = 70'b0                                           ;
        assign i_hio_uxquad_async[idx_xcvr] [9]             = i_rxelecidle                        [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [8]             = i_det_lat_tx_mux_select             [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [7]             = i_det_lat_rx_mux_select             [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [6]             = i_ictl_pcs_txbist_en_lx_a           [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [5]             = i_ictl_pcs_rxbist_en_lx_a           [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [4]             = i_ictl_pcs_rxeyediag_start_lx_a     [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [3]             = i_ictl_pcs_rxeq_clr_lx_a            [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [2]             = i_ictl_pcs_andme_en_lx_a            [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [1]             = ictl_pcs_rxovrcdrlock2data_lx_a     [idx_xcvr]    ;
        assign i_hio_uxquad_async[idx_xcvr] [0]             = ictl_pcs_rxovrcdrlock2dataen_lx_a   [idx_xcvr]    ;
        
    end //end for o_uxquad_async
endgenerate

//-----------------------------------------------------------------------------
//   i_hio_uxquad_async_pcie_mux Mapping from SIP
//-----------------------------------------------------------------------------
generate
    for (idx_xcvr=0;idx_xcvr<l_sys_xcvrs;idx_xcvr=idx_xcvr+1) begin: o_uxquad_async_pcie_mux
     
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [79:73]    = rxmargin_offset_nt                [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [72]       = rxmargin_start_a                  [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [71]       = rxmargin_offset_change_a          [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [70]       = rxmargin_mode_nt                  [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [69]       = rxmargin_direction_nt             [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [68:66]    = rxeq_precal_code_selnt            [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [65]       = rxterm_hiz_ena                    [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [64]       = rxeq_starta                       [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [63]       = ictl_pcs_txbeacon_lx_a            [idx_xcvr]      ;                  
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [62]       = txdetectrx_reqa                   [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [61]       = rxeq_static_ena                   [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [60]       = ictl_pcs_rxeiosdetectstat_lx_a    [idx_xcvr]      ;                  
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [59]       = lfps_ennt                         [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [58:57]    = pcie_l1ctrla                      [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [56:53]    = 4'b0                              [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [52:43]    = txdrv_spare                       [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [42:39]    = txdrv_slew                        [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [38:34]    = txdrv_levnp1                      [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [33:31]    = txdrv_levnm2                      [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [30:26]    = txdrv_levnm1                      [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [25:20]    = txdrv_levn                        [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [19:17]    = txpstate                          [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [16:14]    = txwidth                           [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [13:10]    = txrate                            [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [9:7]      = rxpstate                          [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [6:4]      = rxwidth                           [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        //assign i_hio_uxquad_async_pcie_mux[idx_xcvr] [3:0]      = rxrate                            [idx_xcvr]      ;                // CHECK and give signal declaration if needed
        
    end //end for o_uxquad_async_pcie_mux
endgenerate


//-----------------------------------------------------------------------------
//   o_sip Mapping - from o_hio_uxquad_async
//-----------------------------------------------------------------------------
generate
    for (idx_xcvr=0;idx_xcvr<l_sys_xcvrs;idx_xcvr=idx_xcvr+1) begin: i_uxquad_async

        assign o_flux_srds_rdy                  [idx_xcvr]    = o_hio_uxquad_async[idx_xcvr][39];
        assign o_flux_int                       [idx_xcvr]    = o_hio_uxquad_async[idx_xcvr][38];
        assign o_flux_cpi_int                   [idx_xcvr]    = o_hio_uxquad_async[idx_xcvr][37];
        assign o_octl_pcs_synthlcfast_ready_a  [idx_xcvr]     = o_hio_uxquad_async[idx_xcvr][36];
        assign o_octl_pcs_synthlcslow_ready_a  [idx_xcvr]     = o_hio_uxquad_async[idx_xcvr][35];
        assign o_octl_pcs_cmn_ready_a          [idx_xcvr]     = o_hio_uxquad_async[idx_xcvr][34];
        assign o_octl_pcs_rxbist_done_lx_a     [idx_xcvr]     = o_hio_uxquad_async[idx_xcvr][33];
        assign o_octl_pcs_rxbist_rxlocked_lx_a [idx_xcvr]     = o_hio_uxquad_async[idx_xcvr][32];
        assign o_odat_pcs_rxbist_errcount_lx_a [idx_xcvr]     = o_hio_uxquad_async[idx_xcvr][31:0];

    end //end for i_uxquad_async
endgenerate

//-----------------------------------------------------------------------------
//   o_sip Mapping - from o_hio_rxdata_async/o_hio_rxdata_direct
//-----------------------------------------------------------------------------
generate
    for (idx_xcvr=0;idx_xcvr<l_sys_xcvrs;idx_xcvr=idx_xcvr+1) begin: i_rxdata_async

        assign o_hip_ready                  [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][8];
        assign o_tx_deskew_error            [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][9];
        assign o_rx_fifo_underflow          [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][10];
        assign o_rx_fifo_overflow           [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][11];
                                                                        
        assign o_rx_pfc                     [idx_xcvr] [7:0]  = o_hio_rxdata_async[idx_xcvr][35:28];
                                                                        
        assign o_rx_pause                   [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][36];
        assign o_remote_fault               [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][37];
        assign o_local_fault_status         [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][38];
                                                                        
        assign o_rx_pcs_internal_err        [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][42];
        assign o_rx_hi_ber                  [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][43];
        assign o_rx_pcs_fully_aligned       [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][44];
        assign o_rx_am_lock                 [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][45];
        assign o_rx_dsk_done                [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][46];
        assign o_rx_block_lock              [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][47];
                                                                        
        assign o_tx_lane_hold_inter         [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][56];
        assign o_rx_lane_hold_inter         [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][57];
        assign o_rx_aggr_hold_inter         [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][58];
        assign o_fec_not_locked             [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][59];
        assign o_fec_not_deskew             [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][60];
        assign o_fec_not_align              [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][61];
                                                                        
        assign o_xcvrif_txfifo_pfull        [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][68];
        assign o_xcvrif_txfifo_pempty       [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][69];
        assign o_xcvrif_rxfifo_pempty       [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][70];
        assign o_xcvrif_rxfifo_pfull        [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][71];
        assign o_xcvrif_rxfifo_empty        [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][72];
        assign o_xcvrif_txfifo_empty        [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][73];
        assign o_xcvrif_rxfifo_gb_restarted [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][74];
        assign o_xcvrif_txfifo_gb_restarted [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][75];
        assign o_sm_xcvrif_irq_hold         [idx_xcvr]        = o_hio_rxdata_async[idx_xcvr][76];
     
    end //end for i_rxdata_async
endgenerate


//-----------------------------------------------------------------------------
//   i_hio_txdata_async/i_hio_txdata_direct  from SIP
//-----------------------------------------------------------------------------
generate
    for (idx_xcvr=0;idx_xcvr<l_sys_xcvrs;idx_xcvr=idx_xcvr+1) begin: o_txdata_async

        //assign i_hio_txdata_async [idx_xcvr][7:0]   = 8'b0                             ;
        //assign i_hio_txdata_async [idx_xcvr][11:8]  = 4'b0                             ; // reserved
        //assign i_hio_txdata_async [idx_xcvr][27:12] = 16'b0                            ;
        assign i_hio_txdata_async [idx_xcvr][35:28] = i_tx_pfc          [idx_xcvr][7:0]; 
        assign i_hio_txdata_async [idx_xcvr][36]    = i_tx_pause        [idx_xcvr]     ;
        //assign i_hio_txdata_async [idx_xcvr][41:37] = 5'b0                             ;
        assign i_hio_txdata_async [idx_xcvr][42]    = i_pld_ready       [idx_xcvr]     ;
        //assign i_hio_txdata_async [idx_xcvr][43]    = 1'b0                             ; //reserved
        assign i_hio_txdata_async [idx_xcvr][44]    = i_clear_internal  [idx_xcvr]     ;
        //assign i_hio_txdata_async [idx_xcvr][49:45] = 5'b0                             ;
        assign i_hio_txdata_async [idx_xcvr][50]    = i_take_snapshot   [idx_xcvr]     ;
        //assign i_hio_txdata_async [idx_xcvr][62:51] = 12'b0                            ; // reserved
        //assign i_hio_txdata_async [idx_xcvr][99:63] = 37'b0                            ;
        
        
        //assign i_hio_txdata_direct[idx_xcvr][9:0]   = 10'b0;
        
    end //end for o_txdata_async
endgenerate
    
endmodule

