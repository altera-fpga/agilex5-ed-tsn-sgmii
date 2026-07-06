
namespace eval alt_em10g32_0 {
  proc get_design_libraries {} {
    set libraries [dict create]
    dict set libraries intel_eth_em10g32_100 1
    dict set libraries alt_em10g32_0         1
    return $libraries
  }
  
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    return $memory_files
  }
  
  proc get_common_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [dict create]
    return $design_files
  }
  
  proc get_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [list]
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/intel_eth_em10g32.v"]\"  -work intel_eth_em10g32_100"                         
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32unit.v"]\"  -work intel_eth_em10g32_100"                           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_clk_rst.v"]\"  -work intel_eth_em10g32_100"                       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_clock_crosser.v"]\"  -work intel_eth_em10g32_100"                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_crc32.v"]\"  -work intel_eth_em10g32_100"                         
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_crc32_gf_mult32_kc.v"]\"  -work intel_eth_em10g32_100"            
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_creg_map.v"]\"  -work intel_eth_em10g32_100"                      
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_creg_top.v"]\"  -work intel_eth_em10g32_100"                      
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_frm_decoder.v"]\"  -work intel_eth_em10g32_100"                   
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_rs_gmii_mii_layer.v"]\"  -work intel_eth_em10g32_100"          
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_pipeline_base.v"]\"  -work intel_eth_em10g32_100"                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_reset_synchronizer.v"]\"  -work intel_eth_em10g32_100"            
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rr_clock_crosser.v"]\"  -work intel_eth_em10g32_100"              
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rst_cnt.v"]\"  -work intel_eth_em10g32_100"                       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_fctl_filter_crcpad_rem.v"]\"  -work intel_eth_em10g32_100"     
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_fctl_overflow.v"]\"  -work intel_eth_em10g32_100"              
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_fctl_preamble.v"]\"  -work intel_eth_em10g32_100"              
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_frm_control.v"]\"  -work intel_eth_em10g32_100"                
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_pfc_flow_control.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_pfc_pause_conversion.v"]\"  -work intel_eth_em10g32_100"       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_pkt_backpressure_control.v"]\"  -work intel_eth_em10g32_100"   
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_rs_gmii16b.v"]\"  -work intel_eth_em10g32_100"                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_rs_gmii16b_top.v"]\"  -work intel_eth_em10g32_100"             
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_rs_gmii_mii.v"]\"  -work intel_eth_em10g32_100"                
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_rs_layer.v"]\"  -work intel_eth_em10g32_100"                   
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_rs_xgmii.v"]\"  -work intel_eth_em10g32_100"                   
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_status_aligner.v"]\"  -work intel_eth_em10g32_100"             
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_top.v"]\"  -work intel_eth_em10g32_100"                        
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_stat_mem.v"]\"  -work intel_eth_em10g32_100"                      
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_stat_reg.v"]\"  -work intel_eth_em10g32_100"                      
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_data_frm_gen.v"]\"  -work intel_eth_em10g32_100"               
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_srcaddr_inserter.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_err_aligner.v"]\"  -work intel_eth_em10g32_100"                
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_flow_control.v"]\"  -work intel_eth_em10g32_100"               
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_frm_arbiter.v"]\"  -work intel_eth_em10g32_100"                
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_frm_muxer.v"]\"  -work intel_eth_em10g32_100"                  
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_pause_beat_conversion.v"]\"  -work intel_eth_em10g32_100"      
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_pause_frm_gen.v"]\"  -work intel_eth_em10g32_100"              
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_pause_req.v"]\"  -work intel_eth_em10g32_100"                  
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_pfc_frm_gen.v"]\"  -work intel_eth_em10g32_100"                
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rr_buffer.v"]\"  -work intel_eth_em10g32_100"                     
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_rs_gmii16b.v"]\"  -work intel_eth_em10g32_100"                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_rs_gmii16b_top.v"]\"  -work intel_eth_em10g32_100"             
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_rs_layer.v"]\"  -work intel_eth_em10g32_100"                   
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_rs_xgmii_layer.v"]\"  -work intel_eth_em10g32_100"             
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_sc_fifo.v"]\"  -work intel_eth_em10g32_100"                       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_top.v"]\"  -work intel_eth_em10g32_100"                        
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_gmii_decoder.v"]\"  -work intel_eth_em10g32_100"               
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_gmii_decoder_dfa.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_gmii_encoder.v"]\"  -work intel_eth_em10g32_100"               
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_gmii_encoder_dfa.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_gmii_mii_decoder_if.v"]\"  -work intel_eth_em10g32_100"        
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_gmii_mii_encoder_if.v"]\"  -work intel_eth_em10g32_100"        
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/altera_eth_avalon_mm_adapter.v"]\"  -work intel_eth_em10g32_100"              
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/altera_eth_avalon_st_adapter.v"]\"  -work intel_eth_em10g32_100"              
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/avalon_st_adapter_avalon_st_rx.v"]\"  -work intel_eth_em10g32_100"            
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/avalon_st_adapter_avalon_st_tx.v"]\"  -work intel_eth_em10g32_100"            
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/avalon_st_adapter.v"]\"  -work intel_eth_em10g32_100"                         
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_vldpkt_rddly.v"]\"  -work intel_eth_em10g32_100"                  
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/sideband_adapter_rx.v"]\"  -work intel_eth_em10g32_100"                       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/sideband_adapter_tx.v"]\"  -work intel_eth_em10g32_100"                       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/sideband_adapter.v"]\"  -work intel_eth_em10g32_100"                          
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/altera_eth_sideband_crosser.v"]\"  -work intel_eth_em10g32_100"               
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/altera_eth_sideband_crosser_sync.v"]\"  -work intel_eth_em10g32_100"          
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g_32_64_xgmii_conversion.v"]\"  -work intel_eth_em10g32_100"          
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g_32_to_64_xgmii_conversion.v"]\"  -work intel_eth_em10g32_100"       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g_64_to_32_xgmii_conversion.v"]\"  -work intel_eth_em10g32_100"       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g_dcfifo_32_to_64_xgmii_conversion.v"]\"  -work intel_eth_em10g32_100"
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g_dcfifo_64_to_32_xgmii_conversion.v"]\"  -work intel_eth_em10g32_100"
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_xgmii_32_to_64_adapter.v"]\"  -work intel_eth_em10g32_100"        
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_xgmii_64_to_32_adapter.v"]\"  -work intel_eth_em10g32_100"        
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_xgmii_data_format_adapter.v"]\"  -work intel_eth_em10g32_100"     
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_altsyncram_bundle.v"]\"  -work intel_eth_em10g32_100"             
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_altsyncram.v"]\"  -work intel_eth_em10g32_100"                    
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_avalon_dc_fifo_lat_calc.v"]\"  -work intel_eth_em10g32_100"       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_avalon_dc_fifo_hecc.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_avalon_dc_fifo_secc.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_avalon_sc_fifo.v"]\"  -work intel_eth_em10g32_100"                
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_avalon_sc_fifo_hecc.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_avalon_sc_fifo_secc.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_ecc_dec_18_12.v"]\"  -work intel_eth_em10g32_100"                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_ecc_dec_39_32.v"]\"  -work intel_eth_em10g32_100"                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_ecc_enc_12_18.v"]\"  -work intel_eth_em10g32_100"                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_ecc_enc_32_39.v"]\"  -work intel_eth_em10g32_100"                 
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_tx_rs_xgmii_layer_ultra.v"]\"  -work intel_eth_em10g32_100"       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/mentor/alt_em10g32_rx_rs_xgmii_ultra.v"]\"  -work intel_eth_em10g32_100"             
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/alt_em10g32_avalon_dc_fifo.v"]\"  -work intel_eth_em10g32_100"                       
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/alt_em10g32_dcfifo_synchronizer_bundle.v"]\"  -work intel_eth_em10g32_100"           
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/alt_em10g32_std_synchronizer.v"]\"  -work intel_eth_em10g32_100"                     
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_eth_em10g32_100/sim/altera_std_synchronizer_nocut.v"]\"  -work intel_eth_em10g32_100"                    
    lappend design_files "vlog $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/alt_em10g32_0.v"]\"  -work alt_em10g32_0"                                                                         
    return $design_files
  }
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc normalize_path {FILEPATH} {
      if {[catch { package require fileutil } err]} { 
          return $FILEPATH 
      } 
      set path [fileutil::lexnormalize [file join [pwd] $FILEPATH]]  
      if {[file pathtype $FILEPATH] eq "relative"} { 
          set path [fileutil::relative [pwd] $path] 
      } 
      return $path 
  } 
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    
    return $libraries
  }
  
}
