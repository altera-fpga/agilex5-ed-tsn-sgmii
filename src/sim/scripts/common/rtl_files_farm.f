// XCVR Simulation Speed-Up
+define+DWC_E32MP_X4NS_SHORT_RESET

// XCVR CSR Interface
+define+EIP_DM_XCVR_CSR_AVMM

// Memory definition
+define+EIP_DM_ALTERA_NAMESPACE

// Define with unclear purpose used in design_libs files
+define+EPG_PWRPORT_SUPPLY

// Define macro to improve clock accuracy in PMA
+define+DWC_E32MP_X4NS_IMPROVE_MPLL_ACCURACY

+incdir+${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/common/src/include/sverilog/
+incdir+${EASIC_ETOOLS_HOME}/data_dm/ip_lib/mgio/wrappers/src/rtl/sverilog

-f ${EASIC_ETOOLS_HOME}/data_dm/design_libs/sim/fe_design_libs.f

-v ${EASIC_ETOOLS_HOME}/data_dm/ip_lib/afpga/dcfifo/src/rtl/verilog/eip_dm_afpga_dcfifo.v
-v ${EASIC_ETOOLS_HOME}/data_dm/ip_lib/afpga/dcfifo/src/rtl/verilog/eip_dm_altera_dcfifo.v

-v ${EASIC_ETOOLS_HOME}/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_afpga_ram_base.v
-v ${EASIC_ETOOLS_HOME}/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_altera_syncram.v
-v ${EASIC_ETOOLS_HOME}/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_altsyncram.v

${EASIC_ETOOLS_HOME}/data_dm/ip_lib/basic/clkdiv/src/rtl/sverilog/eip_dm_clkdiv.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/common/src/include/sverilog/eip_dm_mem_pkg.svh
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/xcvr/wrappers/src/rtl/sverilog/eip_dm_xcvr_pkg.sv
-v ${EASIC_ETOOLS_HOME}/data_dm/ip_lib/basic/resync/src/rtl/verilog/eip_dm_resync.v
-v ${EASIC_ETOOLS_HOME}/data_dm/ip_lib/basic/resync/src/rtl/verilog/eip_dm_syncrst.v
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/common/src/rtl/sverilog/eip_dm_mem_inst_port_config.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/common/src/rtl/sverilog/eip_dm_mem_oe_gen.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/common/src/rtl/sverilog/eip_dm_mem_regout_merge.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/common/src/rtl/sverilog/eip_dm_mem_port_handler.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/bram_dp/src/rtl/sverilog/eip_dm_bram_array.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/bram_dp/src/rtl/sverilog/eip_dm_bram_inst.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/bram_sdp/src/rtl/sverilog/eip_dm_bram_sdp_array.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/bram_sp/src/rtl/sverilog/eip_dm_bram_sp_array.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/bram_sp/src/rtl/sverilog/eip_dm_bram_sp_inst.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/dcfifo/src/rtl/sverilog/eip_dm_dcfifo.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/dff_base/src/rtl/sverilog/eip_dm_dff_array_base.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/dff_sdp/src/rtl/sverilog/eip_dm_dff_sdp_array.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/rfile_sdp/src/rtl/sverilog/eip_dm_rfile_sdp_array.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/rfile_sdp/src/rtl/sverilog/eip_dm_rfile_sdp_inst.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/simplemem/src/rtl/sverilog/eip_dm_simplemem_rw_r.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/simplemem/src/rtl/sverilog/eip_dm_simplemem_rw_rw.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/simplemem/src/rtl/sverilog/eip_dm_simplemem_rw.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/simplemem/src/rtl/sverilog/eip_dm_simplemem_w_r_r.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/memory/simplemem/src/rtl/sverilog/eip_dm_simplemem_w_r.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/xcvr/common/src/rtl/sverilog/eip_dm_xcvr_apb2csr.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/xcvr/common/src/rtl/sverilog/eip_dm_xcvr_avmm2csr.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/xcvr/common/src/rtl/sverilog/eip_dm_xcvr_csr_arb.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/xcvr/initware/src/rtl/sverilog/eip_dm_xcvr_initware.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/xcvr/initware/src/rtl/sverilog/eip_dm_xcvr_initware_ln.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/xcvr/initware/src/rtl/sverilog/eip_dm_xcvr_initware_qd.sv
${EASIC_ETOOLS_HOME}/data_dm/ip_lib/xcvr/wrappers/src/rtl/sverilog/eip_dm_xcvr32g_pma_wrapper.sv

-v ${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/ip/clkmux/src/rtl/verilog/eip_dm_clock_mux2.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/rtl/sverilog/eip_dm_generic_csr.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/rtl/sverilog/eip_dm_xcvr32g_generic_phy.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/rtl/sverilog/eip_dm_generic_bist.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/rtl/sverilog/eip_dm_generic_prbs_chk.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/rtl/sverilog/eip_dm_generic_prbs_gen.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/rtl/sverilog/eip_dm_generic_prbs_lfsr.sv

${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_altsyncram.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_altsyncram_bundle.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_avalon_dc_fifo.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_avalon_dc_fifo_hecc.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_avalon_dc_fifo_lat_calc.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_avalon_dc_fifo_secc.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_avalon_sc_fifo.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_avalon_sc_fifo_hecc.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_avalon_sc_fifo_secc.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_avst_to_gmii_if.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_clk_rst.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_clock_crosser.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_crc32.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_crc32_gf_mult32_kc.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_crc32ctl8.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_crc32galois8.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_crc328generator.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_creg_map.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_creg_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_dcfifo_synchronizer_bundle.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_ecc_dec_18_12.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_ecc_dec_39_32.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_ecc_enc_12_18.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_ecc_enc_32_39.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_frm_decoder.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_gmii16b_crc32.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_gmii16b_crc_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_gmii16b_tsu.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_gmii_crc_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_gmii_to_avst_if.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_gmii_tsu.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_lpm_mult.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_multi.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_pipeline_base.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_reset_synchronizer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rr_buffer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rr_clock_crosser.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rst_cnt.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_fctl_filter_crcpad_rem.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_fctl_overflow.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_fctl_preamble.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_frm_control.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_gmii_decoder.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_gmii_decoder_dfa.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_gmii_mii_decoder_if.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_pfc_flow_control.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_pfc_pause_conversion.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_pkt_backpressure_control.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_ptp_aligner.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_ptp_detector.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_ptp_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_rs_gmii16b.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_rs_gmii16b_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_rs_gmii_mii.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_rs_layer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_rs_xgmii.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_rs_xgmii_ultra.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_status_aligner.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_rx_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_sc_fifo.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_stat_mem.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_stat_reg.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_std_synchronizer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_data_frm_gen.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_err_aligner.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_flow_control.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_frm_arbiter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_frm_muxer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_gmii16b_crc_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_gmii16b_ptp_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_gmii16b_ptp_inserter_1g2p5g10g.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_gmii_crc_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_gmii_encoder.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_gmii_encoder_dfa.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_gmii_mii_encoder_if.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_gmii_ptp_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_pause_beat_conversion.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_pause_frm_gen.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_pause_req.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_pfc_frm_gen.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_preamble_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_ptp_processor.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_ptp_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_rs_gmii16b.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_rs_gmii16b_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_rs_gmii_mii_layer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_rs_layer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_rs_xgmii_layer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_rs_xgmii_layer_ultra.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_srcaddr_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_xgmii_crc_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_tx_xgmii_ptp_inserter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32_xgmii_tsu.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/alt_em10g32unit.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/lpm_decode.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_mm_adapter/altera_eth_avalon_mm_adapter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/alt_em10g32_vldpkt_rddly.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/altera_eth_avalon_st_adapter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/altera_eth_sideband_crosser.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/altera_eth_sideband_crosser_sync.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/avalon_st_adapter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/avalon_st_adapter_avalon_st_rx.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/avalon_st_adapter_avalon_st_tx.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/sideband_adapter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/sideband_adapter_rx.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_avalon_st_adapter/sideband_adapter_tx.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_32_to_64_adapter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_64_to_32_adapter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_data_format_adapter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_xgmii_width_adaptor/alt_em10g_32_64_xgmii_conversion.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_xgmii_width_adaptor/alt_em10g_32_to_64_xgmii_conversion.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_xgmii_width_adaptor/alt_em10g_64_to_32_xgmii_conversion.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_xgmii_width_adaptor/alt_em10g_dcfifo_32_to_64_xgmii_conversion.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/alt_em10g32/adapters/altera_eth_xgmii_width_adaptor/alt_em10g_dcfifo_64_to_32_xgmii_conversion.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/rtl/top/alt_usxgmii_mac_def.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_addc2h0t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and2t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and2t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and3t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and4t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and4t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and5t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and5t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and6t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and6t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_and8t2.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_cnt2c.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_cnt4ic.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_cnt6.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_cnt6c.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_compressor_4to3.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_delay1w2.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_delay2w2.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_delay2w64c.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_delay3w1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_delay3w64c.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_delay4w1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_delay5w1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_delay6w1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_descram64.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_epcs_r.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_epcs_rxg.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_epcs_t.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_epcs_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eq2t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eq2t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eq3t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eq3t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eq4t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eq8t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eq9t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eqc4hft1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eqc5h1bt1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eqc5h1dt1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eqc9h1fbt2.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_eqc9h1fdt2.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_etag.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_ethdec.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_ethenc.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_frmwatch.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_hw_reg.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_lut6.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_mlab64a2r1w1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_mx4r.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_mx16r.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_or2t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_or2t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_or4t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_or4t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_pcs_ber.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_pcs_ber_cnt_ns.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_pcs_ber_sm.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_pulse64.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_pulse_stretcher.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_scram64.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_state_r.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_state_t.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_subc2h0t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_xor1t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_xor1t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_xor2t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_xor2t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_xor3t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_xor3t1.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_xor4t0.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_1588_ppm_counter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_a_fifo_24.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_carrier_sense.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_clock_crosser.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_colision_detect.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_control.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_gray_cnt.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_gxb_aligned_rxsync.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_host_control.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_mdio_reg.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_mii_rx_if_pcs.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_mii_tx_if_pcs.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_pma.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_pma_gige.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_reset_synchronizer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_rx_converter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_rx_encapsulation_strx_gx.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_rx_fifo_rd.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_sdpm_altsyncram.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_sgmii_8_to_16_converter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_sgmii_16_to_8_converter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_sgmii_clk_enable.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_std_synchronizer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_top_1000_base_x_strx_gx.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_top_autoneg.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_top_pcs_strx_gx.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_top_rx_converter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_top_sgmii_strx_gx.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_top_tx_converter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_tx_converter.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_tx_encapsulation.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_xcvr_resync.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_bitsync.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_mbow_clock_crosser.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_pcs.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_pcs_csr_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_pcs_rst_sync.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_pipeline_base.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_std_synchronizer_bundle.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_an_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_creg_map.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_creg_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_incr_cnt.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_pcs.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_rx_64_to_32_wadpt.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_rx_data_derep.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_rx_rm_fifo.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_rx_rm_fifo_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_rx_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_tx_32_to_64_wadpt.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_tx_clockcomp_fifo.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_tx_data_mux.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_tx_data_rep.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_tx_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxg32_umii_fault.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_xgmii_pcs.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_xgmii_soft_fifo.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_xcvr_latency_pulse_measurement.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/latency_pulse_measurement.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/common/altera_std_synchronizer_nocut.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/ed/pma_wrapper/gbx_32_66/gbx_32_66_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/ed/pma_wrapper/gbx_32_66/gearbox_32_33.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/ed/pma_wrapper/gbx_32_66/gearbox_32_66.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/ed/pma_wrapper/gbx_32_66/gearbox_33_32.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/ed/pma_wrapper/gbx_32_66/gearbox_66_32.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/ed/pma_wrapper/gbx_32_66/two_to_one.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/top/alt_mge_phy_pcs_top.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_mlab.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_epcs/alt_mge_or_r.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge16_pcs_ph_calculator.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_async_fifo_fpga.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_usxgmii_1588_latency.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_xgmii_1588_latency.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_xgmii_1588_ppm_counter.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_xgmii_clockcomp.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii/rtl/alt_mge_phy_pcs/alt_mge_phy_xgmii_rx_fifo.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_controller.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_synchronizer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/usxgmii_reset_sequencer.v
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_sequencer_deglitch.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_sequencer_deglitch_main.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_sequencer_dlycntr.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_sequencer_main.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_sequencer_seq.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_sequencer.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/reset_sequencer/altera_reset_sequencer_av_csr.sv
${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_pma/eip_dm_mongoose_usxgmii/rtl/top/eip_dm_mongoose_usxgmii.sv


///p/psg/swip/releases/acdskit/21.1/169/linux64/quartus/../ip/altera/sopc_builder_ip/verification/lib/verbosity_pkg.sv
///p/psg/swip/releases/acdskit/21.1/169/linux64/quartus/../ip/altera/sopc_builder_ip/verification/lib/avalon_utilities_pkg.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_master_translator_181/sim/address_decoder_channel_altera_merlin_master_translator_181_mhudjri.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_slave_translator_181/sim/address_decoder_channel_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_master_agent_181/sim/address_decoder_channel_altera_merlin_master_agent_181_t5eyqrq.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_slave_agent_181/sim/address_decoder_channel_altera_merlin_slave_agent_181_a7g37xa.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_slave_agent_181/sim/altera_merlin_burst_uncompressor.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_avalon_sc_fifo_181/sim/address_decoder_channel_altera_avalon_sc_fifo_181_oywqgnq.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_router_181/sim/address_decoder_channel_altera_merlin_router_181_4jbpu4a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_router_181/sim/address_decoder_channel_altera_merlin_router_181_uk6yv3a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_traffic_limiter_181/sim/address_decoder_channel_altera_merlin_traffic_limiter_181_hcubngq.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/alt_hiconnect_sc_fifo_181/sim/address_decoder_channel_alt_hiconnect_sc_fifo_181_cjmuh4a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/alt_hiconnect_sc_fifo_181/sim/alt_st_infer_scfifo.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/alt_hiconnect_sc_fifo_181/sim/alt_st_mlab_scfifo.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/alt_hiconnect_sc_fifo_181/sim/alt_st_fifo_empty.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/alt_hiconnect_sc_fifo_181/sim/alt_st_mlab_scfifo_a6.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/alt_hiconnect_sc_fifo_181/sim/alt_st_mlab_scfifo_a7.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/alt_hiconnect_sc_fifo_181/sim/alt_st_reg_scfifo.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_traffic_limiter_181/sim/address_decoder_channel_altera_merlin_traffic_limiter_181_cjprurq.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_traffic_limiter_181/sim/altera_merlin_reorder_memory.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_traffic_limiter_181/sim/altera_avalon_st_pipeline_base.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_traffic_limiter_181/sim/address_decoder_channel_altera_merlin_traffic_limiter_181_reppfiq.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_demultiplexer_181/sim/address_decoder_channel_altera_merlin_demultiplexer_181_y2e6rja.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_multiplexer_181/sim/address_decoder_channel_altera_merlin_multiplexer_181_gmpl2wy.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_multiplexer_181/sim/altera_merlin_arbitrator.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_demultiplexer_181/sim/address_decoder_channel_altera_merlin_demultiplexer_181_ksbszea.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_merlin_multiplexer_181/sim/address_decoder_channel_altera_merlin_multiplexer_181_ldjjaaa.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/altera_mm_interconnect_181/sim/address_decoder_channel_altera_mm_interconnect_181_6ft6n7a.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_channel/sim/address_decoder_channel.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_csr_clk/sim/address_decoder_channel_csr_clk.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_mac/altera_merlin_slave_translator_181/sim/address_decoder_channel_mac_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_mac/sim/address_decoder_channel_mac.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_master/altera_merlin_master_translator_181/sim/address_decoder_channel_master_altera_merlin_master_translator_181_mhudjri.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_master/sim/address_decoder_channel_master.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_phy/altera_merlin_slave_translator_181/sim/address_decoder_channel_phy_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_phy/sim/address_decoder_channel_phy.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_xcvr_rcfg/altera_merlin_slave_translator_181/sim/address_decoder_channel_xcvr_rcfg_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_channel/address_decoder_channel_xcvr_rcfg/sim/address_decoder_channel_xcvr_rcfg.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_top/address_decoder_top_mm_clock_crossing_bridge/altera_avalon_mm_clock_crossing_bridge_181/sim/address_decoder_top_mm_clock_crossing_bridge_altera_avalon_mm_clock_crossing_bridge_181_kqxyhsq.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_master_translator_181/sim/address_decoder_multi_channel_altera_merlin_master_translator_181_mhudjri.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_master_agent_181/sim/address_decoder_multi_channel_altera_merlin_master_agent_181_t5eyqrq.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_slave_agent_181/sim/address_decoder_multi_channel_altera_merlin_slave_agent_181_a7g37xa.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_avalon_sc_fifo_181/sim/address_decoder_multi_channel_altera_avalon_sc_fifo_181_oywqgnq.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_router_181/sim/address_decoder_multi_channel_altera_merlin_router_181_2r62dfa.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_router_181/sim/address_decoder_multi_channel_altera_merlin_router_181_ssua6gq.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_traffic_limiter_181/sim/address_decoder_multi_channel_altera_merlin_traffic_limiter_181_hcubngq.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/alt_hiconnect_sc_fifo_181/sim/address_decoder_multi_channel_alt_hiconnect_sc_fifo_181_cjmuh4a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_traffic_limiter_181/sim/address_decoder_multi_channel_altera_merlin_traffic_limiter_181_cjprurq.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_traffic_limiter_181/sim/address_decoder_multi_channel_altera_merlin_traffic_limiter_181_reppfiq.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_demultiplexer_181/sim/address_decoder_multi_channel_altera_merlin_demultiplexer_181_5j5bexa.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_multiplexer_181/sim/address_decoder_multi_channel_altera_merlin_multiplexer_181_grdugky.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_demultiplexer_181/sim/address_decoder_multi_channel_altera_merlin_demultiplexer_181_otwqgqi.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_merlin_multiplexer_181/sim/address_decoder_multi_channel_altera_merlin_multiplexer_181_txx6epa.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/altera_mm_interconnect_181/sim/address_decoder_multi_channel_altera_mm_interconnect_181_ghqb2yi.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/address_decoder_multi_channel/sim/address_decoder_multi_channel.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_7/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_7_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_7/sim/address_decoder_multi_channel_channel_7.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_8/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_8_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_8/sim/address_decoder_multi_channel_channel_8.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_master/altera_merlin_master_translator_181/sim/address_decoder_multi_channel_master_altera_merlin_master_translator_181_mhudjri.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_master/sim/address_decoder_multi_channel_master.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_4/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_4_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_4/sim/address_decoder_multi_channel_channel_4.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_3/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_3_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_3/sim/address_decoder_multi_channel_channel_3.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_0/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_0_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_0/sim/address_decoder_multi_channel_channel_0.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_2/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_2_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_2/sim/address_decoder_multi_channel_channel_2.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_csr_clk/sim/address_decoder_multi_channel_csr_clk.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_11/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_11_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_11/sim/address_decoder_multi_channel_channel_11.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_9/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_9_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_9/sim/address_decoder_multi_channel_channel_9.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_10/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_10_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_10/sim/address_decoder_multi_channel_channel_10.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_5/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_5_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_5/sim/address_decoder_multi_channel_channel_5.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_1/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_1_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_1/sim/address_decoder_multi_channel_channel_1.v
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_6/altera_merlin_slave_translator_181/sim/address_decoder_multi_channel_channel_6_altera_merlin_slave_translator_181_5aswt6a.sv
//${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/alt_em10g32/usxgmii_mac/ed_nonptp/rtl/address_decoder/ip/address_decoder_multi_channel/address_decoder_multi_channel_channel_6/sim/address_decoder_multi_channel_channel_6.v
//
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_core_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_bram_base.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_bram.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_corner.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_clock.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_ecell.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_ecellwrp.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_eio.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_eiowrp.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_hecell.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_hs.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_hs.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_iodig.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_xcvr32.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_smu.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_sys.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_dft2.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_sys_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_smu_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_logic_eio_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/dcfifo/src/rtl/verilog/eip_dm_afpga_dcfifo.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/dcfifo/src/rtl/verilog/eip_dm_altera_dcfifo.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_afpga_ram_base.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_altera_syncram.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_altsyncram.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/basic/resync/src/rtl/verilog/eip_dm_resync.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/basic/resync/src/rtl/verilog/eip_dm_syncrst.v
//-v ${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/ip/clkmux/src/rtl/verilog/eip_dm_clock_mux2.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_core_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_bram_base.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_bram.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_corner.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_clock.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_ecell.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_ecellwrp.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_eio.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_eiowrp.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_hecell.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_hs.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_hs.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_iodig.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_smu.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_sys.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_dft2.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_sys_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_smu_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_logic_eio_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/dcfifo/src/rtl/verilog/eip_dm_afpga_dcfifo.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/dcfifo/src/rtl/verilog/eip_dm_altera_dcfifo.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_afpga_ram_base.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_altera_syncram.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_altsyncram.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/basic/resync/src/rtl/verilog/eip_dm_resync.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/basic/resync/src/rtl/verilog/eip_dm_syncrst.v
//-v ${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/ip/clkmux/src/rtl/verilog/eip_dm_clock_mux2.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_core_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_bram_base.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_bram.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_corner.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_clock.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_ecell.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_ecellwrp.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_eio.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_eiowrp.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_hecell.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_hs.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_hs.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_iodig.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_smu.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_sys.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_dft2.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_sys_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_smu_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/design_libs/sim/dm_fe_logic_eio_wrapper.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/dcfifo/src/rtl/verilog/eip_dm_afpga_dcfifo.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/dcfifo/src/rtl/verilog/eip_dm_altera_dcfifo.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_afpga_ram_base.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_altera_syncram.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/afpga/syncram/src/rtl/verilog/eip_dm_altsyncram.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/basic/resync/src/rtl/verilog/eip_dm_resync.v
//-v $EASIC_ETOOLS_HOME/data_dm/ip_lib/basic/resync/src/rtl/verilog/eip_dm_syncrst.v
//-v ${REG_LOCAL_ROOT_DIR_PATH}/ip/ethernet/alt_ethernet_crete_dm/qhip/scripts/funct_deterministic/DM_RUN/epg/ip/eip_dm_xcvr32g_generic_phy/ip/clkmux/src/rtl/verilog/eip_dm_clock_mux2.v
