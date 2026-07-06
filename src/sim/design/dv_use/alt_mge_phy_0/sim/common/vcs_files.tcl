
namespace eval alt_mge_phy_0 {
  proc get_memory_files {QSYS_SIMDIR} {
    set memory_files [list]
    lappend memory_files "$QSYS_SIMDIR/../n_channel_superset_2100/sim/SM_SRC_VLIW_MIF.mif"
    return $memory_files
  }
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    dict set design_files "altera_common_sv_packages::alt_mge_phy_f_ptp_package" "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/alt_mge_phy_f_ptp_package.sv"
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    dict set design_files "alt_mge_phy_async_fifo_fpga.sv"                                     "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_async_fifo_fpga.sv"                             
    dict set design_files "alt_mge_phy_bitsync.v"                                              "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_bitsync.v"                                      
    dict set design_files "alt_mge_phy_mbow_clock_crosser.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_mbow_clock_crosser.v"                           
    dict set design_files "alt_mge_phy_pcs_csr_top.v"                                          "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_pcs_csr_top.v"                                  
    dict set design_files "alt_mge_phy_pipeline_base.v"                                        "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_pipeline_base.v"                                
    dict set design_files "alt_mge_phy_std_synchronizer_bundle.v"                              "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_std_synchronizer_bundle.v"                      
    dict set design_files "alt_mge_phy_usxg32_an_top.v"                                        "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_an_top.v"                                
    dict set design_files "alt_mge_phy_usxg32_creg_map.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_creg_map.v"                              
    dict set design_files "alt_mge_phy_usxg32_creg_top.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_creg_top.v"                              
    dict set design_files "alt_mge_phy_usxg32_f_ptp_latency_measure_top.v"                     "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_f_ptp_latency_measure_top.v"             
    dict set design_files "alt_mge_phy_usxg32_incr_cnt.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_incr_cnt.v"                              
    dict set design_files "alt_mge_phy_usxg32_pcs.v"                                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_pcs.v"                                   
    dict set design_files "alt_mge_phy_usxg32_rx_64_to_32_wadpt.v"                             "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_rx_64_to_32_wadpt.v"                     
    dict set design_files "alt_mge_phy_usxg32_rx_clockcomp_fifo.v"                             "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_rx_clockcomp_fifo.v"                     
    dict set design_files "alt_mge_phy_usxg32_rx_data_derep.v"                                 "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_rx_data_derep.v"                         
    dict set design_files "alt_mge_phy_usxg32_rx_rm_fifo.v"                                    "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_rx_rm_fifo.v"                            
    dict set design_files "alt_mge_phy_usxg32_rx_rm_fifo_top.v"                                "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_rx_rm_fifo_top.v"                        
    dict set design_files "alt_mge_phy_usxg32_rx_top.v"                                        "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_rx_top.v"                                
    dict set design_files "alt_mge_phy_usxg32_tx_32_to_64_wadpt.v"                             "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_tx_32_to_64_wadpt.v"                     
    dict set design_files "alt_mge_phy_usxg32_tx_clockcomp_fifo.v"                             "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_tx_clockcomp_fifo.v"                     
    dict set design_files "alt_mge_phy_usxg32_tx_data_mux.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_tx_data_mux.v"                           
    dict set design_files "alt_mge_phy_usxg32_tx_data_rep.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_tx_data_rep.v"                           
    dict set design_files "alt_mge_phy_usxg32_tx_top.v"                                        "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_tx_top.v"                                
    dict set design_files "alt_mge_phy_usxg32_umii_fault.v"                                    "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxg32_umii_fault.v"                            
    dict set design_files "alt_mge_phy_xgmii_1588_latency.sv"                                  "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_xgmii_1588_latency.sv"                          
    dict set design_files "alt_mge_phy_xgmii_1588_ppm_counter.sv"                              "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_xgmii_1588_ppm_counter.sv"                      
    dict set design_files "alt_mge_phy_xgmii_clockcomp.sv"                                     "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_xgmii_clockcomp.sv"                             
    dict set design_files "alt_mge_phy_xgmii_pcs.v"                                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_xgmii_pcs.v"                                    
    dict set design_files "alt_mge_phy_xgmii_rx_fifo.sv"                                       "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_xgmii_rx_fifo.sv"                               
    dict set design_files "alt_mge_phy_xgmii_soft_fifo.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_xgmii_soft_fifo.v"                              
    dict set design_files "alt_mge16_pcs_1588_ppm_counter.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_1588_ppm_counter.v"                           
    dict set design_files "alt_mge16_pcs_a_fifo_24.v"                                          "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_a_fifo_24.v"                                  
    dict set design_files "alt_mge16_pcs_carrier_sense.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_carrier_sense.v"                              
    dict set design_files "alt_mge16_pcs_clock_crosser.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_clock_crosser.v"                              
    dict set design_files "alt_mge16_pcs_colision_detect.v"                                    "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_colision_detect.v"                            
    dict set design_files "alt_mge16_pcs_gray_cnt.v"                                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_gray_cnt.v"                                   
    dict set design_files "alt_mge16_pcs_gxb_aligned_rxsync.v"                                 "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_gxb_aligned_rxsync.v"                         
    dict set design_files "alt_mge16_pcs_host_control.v"                                       "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_host_control.v"                               
    dict set design_files "alt_mge16_pcs_mii_rx_if_pcs.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_mii_rx_if_pcs.v"                              
    dict set design_files "alt_mge16_pcs_mii_tx_if_pcs.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_mii_tx_if_pcs.v"                              
    dict set design_files "alt_mge16_pcs_ph_calculator.sv"                                     "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_ph_calculator.sv"                             
    dict set design_files "alt_mge16_pcs_reset_synchronizer.v"                                 "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_reset_synchronizer.v"                         
    dict set design_files "alt_mge16_pcs_rx_converter.v"                                       "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_rx_converter.v"                               
    dict set design_files "alt_mge16_pcs_rx_encapsulation_strx_gx.v"                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_rx_encapsulation_strx_gx.v"                   
    dict set design_files "alt_mge16_pcs_rx_fifo_rd.v"                                         "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_rx_fifo_rd.v"                                 
    dict set design_files "alt_mge16_pcs_sdpm_altsyncram.v"                                    "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_sdpm_altsyncram.v"                            
    dict set design_files "alt_mge16_pcs_std_synchronizer.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_std_synchronizer.v"                           
    dict set design_files "alt_mge16_pcs_top_autoneg.v"                                        "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_top_autoneg.v"                                
    dict set design_files "alt_mge16_pcs_top_pcs_strx_gx.v"                                    "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_top_pcs_strx_gx.v"                            
    dict set design_files "alt_mge16_pcs_top_rx_converter.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_top_rx_converter.v"                           
    dict set design_files "alt_mge16_pcs_top_tx_converter.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_top_tx_converter.v"                           
    dict set design_files "alt_mge16_pcs_tx_converter.v"                                       "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_tx_converter.v"                               
    dict set design_files "alt_mge16_pcs_tx_encapsulation.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_tx_encapsulation.v"                           
    dict set design_files "alt_mge16_pcs_xcvr_resync.v"                                        "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_xcvr_resync.v"                                
    dict set design_files "alt_mge_xcvr_latency_pulse_measurement.v"                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_xcvr_latency_pulse_measurement.v"                   
    dict set design_files "latency_pulse_measurement.v"                                        "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/latency_pulse_measurement.v"                                
    dict set design_files "alt_mge16_pcs_sgmii_8_to_16_converter.v"                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_sgmii_8_to_16_converter.v"                    
    dict set design_files "alt_mge16_pcs_sgmii_16_to_8_converter.v"                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_sgmii_16_to_8_converter.v"                    
    dict set design_files "alt_mge_phy_usxgmii_1588_latency.sv"                                "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_usxgmii_1588_latency.sv"                        
    dict set design_files "alt_mge_phy_f_ptp_async_pulse_gen.v"                                "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_f_ptp_async_pulse_gen.v"                        
    dict set design_files "alt_mge_phy_f_ptp_calc_delay.v"                                     "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_f_ptp_calc_delay.v"                             
    dict set design_files "alt_mge_phy_f_ptp_latency_count_async.v"                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_f_ptp_latency_count_async.v"                    
    dict set design_files "alt_mge_phy_f_ptp_latency_count_rxsync.sv"                          "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_f_ptp_latency_count_rxsync.sv"                  
    dict set design_files "alt_mge_phy_f_ptp_latency_count_txsync.v"                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_f_ptp_latency_count_txsync.v"                   
    dict set design_files "alt_mge_phy_f_ptp_latency_measure.sv"                               "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_f_ptp_latency_measure.sv"                       
    dict set design_files "alt_mge_phy_f_ptp_rx_am_muxsel_gen.v"                               "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_f_ptp_rx_am_muxsel_gen.v"                       
    dict set design_files "alt_mge_phy_f_ptp_tx_am_muxsel_gen.v"                               "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_f_ptp_tx_am_muxsel_gen.v"                       
    dict set design_files "alt_mge16_pcs_sgmii_clk_enable.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_sgmii_clk_enable.v"                           
    dict set design_files "alt_mge_carrier_detect.v"                                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_carrier_detect.v"                                   
    dict set design_files "alt_mge_encoder_8b10b.v"                                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_encoder_8b10b.v"                                    
    dict set design_files "alt_mge_wordalign20.v"                                              "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_wordalign20.v"                                      
    dict set design_files "alt_mge_x2_decoder_8b10b.v"                                         "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_x2_decoder_8b10b.v"                                 
    dict set design_files "alt_mge_x2_rx_sync.v"                                               "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_x2_rx_sync.v"                                       
    dict set design_files "alt_mge_decoder_8b10b.v"                                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_decoder_8b10b.v"                                    
    dict set design_files "alt_mge_pcs20.v"                                                    "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_pcs20.v"                                            
    dict set design_files "alt_mge_x2_carrier_detect.v"                                        "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_x2_carrier_detect.v"                                
    dict set design_files "alt_mge_x2_encoder_8b10b.v"                                         "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_x2_encoder_8b10b.v"                                 
    dict set design_files "alt_tse16_16_to_8_gmii_conversion.v"                                "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_tse16_16_to_8_gmii_conversion.v"                        
    dict set design_files "alt_tse16_8_to_16_gmii_conversion.v"                                "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_tse16_8_to_16_gmii_conversion.v"                        
    dict set design_files "alt_tse16_gmii16b_conv.v"                                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_tse16_gmii16b_conv.v"                                   
    dict set design_files "alt_tse16_pcs_sgmii_clk_enable.v"                                   "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_tse16_pcs_sgmii_clk_enable.v"                           
    dict set design_files "alt_mge16_pcs_pma.v"                                                "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_pma.v"                                        
    dict set design_files "alt_mge16_pcs_pma_gige.v"                                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_pma_gige.v"                                   
    dict set design_files "alt_mge16_pcs_top_1000_base_x_strx_gx.v"                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_top_1000_base_x_strx_gx.v"                    
    dict set design_files "alt_mge16_pcs_top_sgmii_strx_gx.v"                                  "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_top_sgmii_strx_gx.v"                          
    dict set design_files "alt_mge_phy_pcs.v"                                                  "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_pcs.v"                                          
    dict set design_files "alt_mge16_pcs_mdio_reg.v"                                           "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_mdio_reg.v"                                   
    dict set design_files "alt_mge_phy_pcs_rst_sync.v"                                         "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge_phy_pcs_rst_sync.v"                                 
    dict set design_files "hps_mge_bin_gray.v"                                                 "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_bin_gray.v"                                         
    dict set design_files "hps_mge_csr.v"                                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_csr.v"                                              
    dict set design_files "hps_mge_data_packer.v"                                              "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_data_packer.v"                                      
    dict set design_files "hps_mge_data_unpacker.v"                                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_data_unpacker.v"                                    
    dict set design_files "hps_mge_elasticbuffer.v"                                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_elasticbuffer.v"                                    
    dict set design_files "hps_mge_fifomem.v"                                                  "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_fifomem.v"                                          
    dict set design_files "hps_mge_gray_bin.v"                                                 "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_gray_bin.v"                                         
    dict set design_files "hps_mge_reset_synchronizer.v"                                       "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_reset_synchronizer.v"                               
    dict set design_files "hps_mge_synchronizer_bundle.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_mge_synchronizer_bundle.v"                              
    dict set design_files "hps_to_mge_clk_mux_macspeed.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_to_mge_clk_mux_macspeed.v"                              
    dict set design_files "hps_to_mge_clk_mux_physpeed.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_to_mge_clk_mux_physpeed.v"                              
    dict set design_files "hps_to_mge_gmii_adapter_core.v"                                     "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/hps_to_mge_gmii_adapter_core.v"                             
    dict set design_files "alt_mge16_pcs_control.v"                                            "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/synopsys/alt_mge16_pcs_control.v"                                    
    dict set design_files "altera_std_synchronizer_nocut.v"                                    "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/altera_std_synchronizer_nocut.v"                                     
    dict set design_files "alt_xcvr_resync_std.sv"                                             "$QSYS_SIMDIR/../intel_mge_phy_pcs_100/sim/alt_xcvr_resync_std.sv"                                              
    dict set design_files "alt_mge_phy_gf_clock_mux.v"                                         "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/alt_mge_phy_gf_clock_mux.v"                           
    dict set design_files "alt_mge16_phy_xcvr_term.v"                                          "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/alt_mge16_phy_xcvr_term.v"                            
    dict set design_files "alt_xcvr_resync_std.sv"                                             "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/alt_xcvr_resync_std.sv"                               
    dict set design_files "altera_std_synchronizer_nocut.v"                                    "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/altera_std_synchronizer_nocut.v"                      
    dict set design_files "ftile_efifo_async_fifo.sv"                                          "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/ftile_efifo_async_fifo.sv"                            
    dict set design_files "ftile_efifo_ccc.v"                                                  "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/ftile_efifo_ccc.v"                                    
    dict set design_files "ftile_efifo_wrapper_top.sv"                                         "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/ftile_efifo_wrapper_top.sv"                           
    dict set design_files "tse_ftile_efifo_rd_en_toggle.sv"                                    "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_efifo_rd_en_toggle.sv"                      
    dict set design_files "tse_ftile_efifo_wr_en_toggle.sv"                                    "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_efifo_wr_en_toggle.sv"                      
    dict set design_files "tse_ftile_eq_5_ena.v"                                               "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_eq_5_ena.v"                                 
    dict set design_files "tse_ftile_gray_cntr_5_sl.v"                                         "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_gray_cntr_5_sl.v"                           
    dict set design_files "tse_ftile_gray_to_bin_5.v"                                          "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_gray_to_bin_5.v"                            
    dict set design_files "tse_ftile_lut6.v"                                                   "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_lut6.v"                                     
    dict set design_files "tse_ftile_mlab.v"                                                   "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_mlab.v"                                     
    dict set design_files "tse_ftile_neq_5_ena.v"                                              "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_neq_5_ena.v"                                
    dict set design_files "tse_ftile_sync_regs_aclr_m2.v"                                      "$QSYS_SIMDIR/../intel_mge_phy_xcvr_term_100/sim/synopsys/tse_ftile_sync_regs_aclr_m2.v"                        
    dict set design_files "alt_mge_phy_0_intel_adme_gts_100_m3ka7xa.sv"                        "$QSYS_SIMDIR/../intel_adme_gts_100/sim/alt_mge_phy_0_intel_adme_gts_100_m3ka7xa.sv"                            
    dict set design_files "alt_xcvr_avmm_arb.sv"                                               "$QSYS_SIMDIR/../intel_adme_gts_100/sim/alt_xcvr_avmm_arb.sv"                                                   
    dict set design_files "alt_xcvr_arbiter.sv"                                                "$QSYS_SIMDIR/../intel_adme_gts_100/sim/alt_xcvr_arbiter.sv"                                                    
    dict set design_files "alt_mge_phy_0_intel_directphy_gts_intel_adme_gts_200_fmptqqy.v"     "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/alt_mge_phy_0_intel_directphy_gts_intel_adme_gts_200_fmptqqy.v"    
    dict set design_files "alt_mge_phy_0_pcs_hal_2100_iateojy.sv"                              "$QSYS_SIMDIR/../pcs_hal_2100/sim/alt_mge_phy_0_pcs_hal_2100_iateojy.sv"                                        
    dict set design_files "ch4_pcs.sv"                                                         "$QSYS_SIMDIR/../pcs_hal_2100/sim/ch4_pcs.sv"                                                                   
    dict set design_files "pcs_hal_coreip.sv"                                                  "$QSYS_SIMDIR/../pcs_hal_2100/sim/pcs_hal_coreip.sv"                                                            
    dict set design_files "alt_mge_phy_0_one_lane_hal_pcs_hal_2100_msmb2ci.v"                  "$QSYS_SIMDIR/../one_lane_hal_2100/sim/alt_mge_phy_0_one_lane_hal_pcs_hal_2100_msmb2ci.v"                       
    dict set design_files "alt_mge_phy_0_fec_hal_2100_tq72q4i.sv"                              "$QSYS_SIMDIR/../fec_hal_2100/sim/alt_mge_phy_0_fec_hal_2100_tq72q4i.sv"                                        
    dict set design_files "ch4_fec.sv"                                                         "$QSYS_SIMDIR/../fec_hal_2100/sim/ch4_fec.sv"                                                                   
    dict set design_files "fec_hal_coreip.sv"                                                  "$QSYS_SIMDIR/../fec_hal_2100/sim/fec_hal_coreip.sv"                                                            
    dict set design_files "alt_mge_phy_0_one_lane_hal_fec_hal_2100_gsknnly.v"                  "$QSYS_SIMDIR/../one_lane_hal_2100/sim/alt_mge_phy_0_one_lane_hal_fec_hal_2100_gsknnly.v"                       
    dict set design_files "alt_mge_phy_0_pldif_hal_2100_4ge3b5q.sv"                            "$QSYS_SIMDIR/../pldif_hal_2100/sim/alt_mge_phy_0_pldif_hal_2100_4ge3b5q.sv"                                    
    dict set design_files "ch4_pldif.sv"                                                       "$QSYS_SIMDIR/../pldif_hal_2100/sim/ch4_pldif.sv"                                                               
    dict set design_files "ch4_pldif_no_deskew.sv"                                             "$QSYS_SIMDIR/../pldif_hal_2100/sim/ch4_pldif_no_deskew.sv"                                                     
    dict set design_files "pldif_hal_coreip.sv"                                                "$QSYS_SIMDIR/../pldif_hal_2100/sim/pldif_hal_coreip.sv"                                                        
    dict set design_files "pldif_staticmux.sv"                                                 "$QSYS_SIMDIR/../pldif_hal_2100/sim/pldif_staticmux.sv"                                                         
    dict set design_files "alt_mge_phy_0_one_lane_hal_pldif_hal_2100_g7omyzi.v"                "$QSYS_SIMDIR/../one_lane_hal_2100/sim/alt_mge_phy_0_one_lane_hal_pldif_hal_2100_g7omyzi.v"                     
    dict set design_files "alt_mge_phy_0_phy_hal_2100_jc3ca3q.sv"                              "$QSYS_SIMDIR/../phy_hal_2100/sim/alt_mge_phy_0_phy_hal_2100_jc3ca3q.sv"                                        
    dict set design_files "ch4_phy.sv"                                                         "$QSYS_SIMDIR/../phy_hal_2100/sim/ch4_phy.sv"                                                                   
    dict set design_files "phy_hal_coreip.sv"                                                  "$QSYS_SIMDIR/../phy_hal_2100/sim/phy_hal_coreip.sv"                                                            
    dict set design_files "phy_staticmux.sv"                                                   "$QSYS_SIMDIR/../phy_hal_2100/sim/phy_staticmux.sv"                                                             
    dict set design_files "alt_mge_phy_0_one_lane_hal_phy_hal_2100_hfv7ity.v"                  "$QSYS_SIMDIR/../one_lane_hal_2100/sim/alt_mge_phy_0_one_lane_hal_phy_hal_2100_hfv7ity.v"                       
    dict set design_files "alt_mge_phy_0_one_lane_hal_2100_qsx6jsi.sv"                         "$QSYS_SIMDIR/../one_lane_hal_2100/sim/alt_mge_phy_0_one_lane_hal_2100_qsx6jsi.sv"                              
    dict set design_files "alt_mge_phy_0_hal_top_one_lane_hal_2100_n3mbdsq.v"                  "$QSYS_SIMDIR/../hal_top_2100/sim/alt_mge_phy_0_hal_top_one_lane_hal_2100_n3mbdsq.v"                            
    dict set design_files "alt_mge_phy_0_hal_top_2100_smtnyja.sv"                              "$QSYS_SIMDIR/../hal_top_2100/sim/alt_mge_phy_0_hal_top_2100_smtnyja.sv"                                        
    dict set design_files "hip_sip_boundary_smtnyja.sv"                                        "$QSYS_SIMDIR/../hal_top_2100/sim/hip_sip_boundary_smtnyja.sv"                                                  
    dict set design_files "chptp.sv"                                                           "$QSYS_SIMDIR/../hal_top_2100/sim/chptp.sv"                                                                     
    dict set design_files "mc.sv"                                                              "$QSYS_SIMDIR/../hal_top_2100/sim/mc.sv"                                                                        
    dict set design_files "shared_hal_coreip.v"                                                "$QSYS_SIMDIR/../hal_top_2100/sim/shared_hal_coreip.v"                                                          
    dict set design_files "shared_ptp.v"                                                       "$QSYS_SIMDIR/../hal_top_2100/sim/shared_ptp.v"                                                                 
    dict set design_files "alt_mge_phy_0_n_channel_superset_hal_top_2100_ckyu45q.v"            "$QSYS_SIMDIR/../n_channel_superset_2100/sim/alt_mge_phy_0_n_channel_superset_hal_top_2100_ckyu45q.v"           
    dict set design_files "alt_mge_phy_0_n_channel_superset_2100_7mcaoay.sv"                   "$QSYS_SIMDIR/../n_channel_superset_2100/sim/alt_mge_phy_0_n_channel_superset_2100_7mcaoay.sv"                  
    dict set design_files "tennm_sm_hssi_pld_chnl_dp_sip_atom.sv"                              "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/tennm_sm_hssi_pld_chnl_dp_sip_atom.sv"                   
    dict set design_files "ncss_avmm_decoder.sv"                                               "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/ncss_avmm_decoder.sv"                                    
    dict set design_files "ncss_common_ptp_top.sv"                                             "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/ncss_common_ptp_top.sv"                                  
    dict set design_files "intel_src_addr_gen.sv"                                              "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_addr_gen.sv"                                   
    dict set design_files "intel_src_lane.sv"                                                  "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_lane.sv"                                       
    dict set design_files "intel_src_lane2lane.sv"                                             "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_lane2lane.sv"                                  
    dict set design_files "intel_src_lane_rst_sequence_fsm.sv"                                 "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_lane_rst_sequence_fsm.sv"                      
    dict set design_files "intel_src_lane_wrapper.sv"                                          "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_lane_wrapper.sv"                               
    dict set design_files "intel_src_monitor.sv"                                               "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_monitor.sv"                                    
    dict set design_files "intel_src_stagger_block.sv"                                         "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_stagger_block.sv"                              
    dict set design_files "intel_src_synchronizers.sv"                                         "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_synchronizers.sv"                              
    dict set design_files "sopc_synchronizer.v"                                                "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/sopc_synchronizer.v"                                     
    dict set design_files "intel_src_csr.sv"                                                   "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_csr.sv"                                        
    dict set design_files "intel_src_flow_ctrl.sv"                                             "$QSYS_SIMDIR/../n_channel_superset_2100/sim/intelfpga/intel_src_flow_ctrl.sv"                                  
    dict set design_files "alt_mge_phy_0_intel_directphy_gts_n_channel_superset_200_vtl75gi.v" "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/alt_mge_phy_0_intel_directphy_gts_n_channel_superset_200_vtl75gi.v"
    dict set design_files "sip_async_mapping.sv"                                               "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/sip_async_mapping.sv"                                              
    dict set design_files "intel_directphy_avmm.sv"                                            "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/intel_directphy_avmm.sv"                                           
    dict set design_files "intel_directphy_csr_wrap.v"                                         "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/intel_directphy_csr_wrap.v"                                        
    dict set design_files "dphy_ccg.v"                                                         "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/dphy_ccg.v"                                                        
    dict set design_files "directphy_gray_cntr_3.v"                                            "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/directphy_gray_cntr_3.v"                                           
    dict set design_files "directphy_gray_cntr_5_sl.v"                                         "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/directphy_gray_cntr_5_sl.v"                                        
    dict set design_files "directphy_eq_5_ena.v"                                               "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/directphy_eq_5_ena.v"                                              
    dict set design_files "directphy_neq_5_ena.v"                                              "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/directphy_neq_5_ena.v"                                             
    dict set design_files "directphy_wys_lut.v"                                                "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/directphy_wys_lut.v"                                               
    dict set design_files "intel_directphy_sip_csr.v"                                          "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/intel_directphy_sip_csr.v"                                         
    dict set design_files "dphy_tx_dsk_gen.sv"                                                 "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/dphy_tx_dsk_gen.sv"                                                
    dict set design_files "directphy_rx_deskew.sv"                                             "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/directphy_rx_deskew.sv"                                            
    dict set design_files "directphy_word_delay.v"                                             "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/directphy_word_delay.v"                                            
    dict set design_files "directphy_mlab.v"                                                   "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/directphy_mlab.v"                                                  
    dict set design_files "alt_xcvr_resync_etile.sv"                                           "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/alt_xcvr_resync_etile.sv"                                          
    dict set design_files "altera_std_synchronizer_nocut_etile.v"                              "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/altera_std_synchronizer_nocut_etile.v"                             
    dict set design_files "alt_mge_phy_0_intel_directphy_gts_200_twelxbq.sv"                   "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/alt_mge_phy_0_intel_directphy_gts_200_twelxbq.sv"                  
    dict set design_files "intel_directphy_gts_sip_200_twelxbq.sv"                             "$QSYS_SIMDIR/../intel_directphy_gts_200/sim/intel_directphy_gts_sip_200_twelxbq.sv"                            
    dict set design_files "alt_mge_phy_0_altera_iopll_1931_tktuxka.vo"                         "$QSYS_SIMDIR/../altera_iopll_1931/sim/alt_mge_phy_0_altera_iopll_1931_tktuxka.vo"                              
    dict set design_files "alt_mge_phy_0_intel_mge_phy_100_mdesbaq.v"                          "$QSYS_SIMDIR/../intel_mge_phy_100/sim/alt_mge_phy_0_intel_mge_phy_100_mdesbaq.v"                               
    dict set design_files "alt_mge_phy_0.v"                                                    "$QSYS_SIMDIR/alt_mge_phy_0.v"                                                                                  
    return $design_files
  }
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
      append ELAB_OPTIONS { $QUARTUS_INSTALL_DIR/eda/sim_lib/quartus_dpi.c -debug_access+f +define+QUARTUS_ENABLE_DPI_FORCE}
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
  
  
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    
    return $libraries
  }
  
}
