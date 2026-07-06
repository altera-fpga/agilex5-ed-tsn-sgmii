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
// altera message_off 16788
(* altera_attribute= "-name MESSAGE_DISABLE 13049" *)

  module alt_mge_phy_0_hal_top_2100_smtnyja 
  #(    
    parameter ch0_quad0_xcvr_tx_preloaded_hardware_configs_atom   = "CH0_TX_PRELOADED_HARDWARE_CONFIGS_NONE"             ,   
    parameter ch0_quad0_xcvr_rx_preloaded_hardware_configs_atom   = "CH0_RX_PRELOADED_HARDWARE_CONFIGS_NONE"             ,   
    parameter ch0_quad0_lc_postdiv_sel_atom                       = "CH0_LC_POSTDIV_SEL_SYNTH_FAST"                      ,   
    parameter ch0_quad0_sequencer_reg_en_atom                     = "CH0_SEQUENCER_REG_EN_DISABLE"                       ,   
    parameter ch0_quad0_rst_mux_static_sel_atom                   = "CH0_RST_MUX_STATIC_SEL_UNUSED"                      ,
    parameter ch0_quad0_xcvr_tx_prbs_pattern_atom                 = 4'd0                                                 ,
    parameter ch0_quad0_xcvr_rx_prbs_pattern_atom                 = 4'd0                                                 ,
    parameter ch0_quad0_xcvr_tx_user_clk_only_mode_atom           = "CH0_TX_USER_CLK_ONLY_MODE_ENABLE"                   ,
    parameter ch0_quad0_xcvr_tx_width_atom                        = "CH0_TX_WIDTH_DISABLED"                              ,
    parameter ch0_quad0_xcvr_rx_width_atom                        = "CH0_RX_WIDTH_DISABLED"                              ,
    parameter ch0_quad0_phy_loopback_mode_atom                    = "CH0_LOOPBACK_MODE_DISABLED"                         ,
    parameter ch0_quad0_flux_mode_atom                            = "CH0_FLUX_MODE_DISABLED"                             ,
    parameter ch0_quad0_tx_sim_mode_atom                          = "CH0_TX_SIM_MODE_DISABLE"                            ,
    parameter ch0_quad0_rx_sim_mode_atom                          = "CH0_RX_SIM_MODE_DISABLE"                            ,
    parameter ch0_quad0_tx_dl_enable_atom                         = "CH0_TX_DL_ENABLE_DISABLE"                           , 
    parameter ch0_quad0_rx_dl_enable_atom                         = "CH0_RX_DL_ENABLE_DISABLE"                           , 
    parameter ch0_quad0_rx_fec_type_used_atom                     = "CH0_RX_FEC_TYPE_USED_NONE"                          , 
    parameter ch0_quad0_xcvr_rx_prbs_monitor_en_atom              = "CH0_RX_PRBS_MONITOR_EN_DISABLE"                     , 
    parameter ch0_quad0_tx_prbs_gen_en_atom                       = "CH0_TX_PRBS_GEN_EN_DISABLE"                         , 
    parameter ch0_quad0_rx_user1_clk_mux_dynamic_sel_atom         = "CH0_RX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch0_quad0_rx_user2_clk_mux_dynamic_sel_atom         = "CH0_RX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch0_quad0_tx_user1_clk_mux_dynamic_sel_atom         = "CH0_TX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch0_quad0_tx_user2_clk_mux_dynamic_sel_atom         = "CH0_TX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch0_quad0_xcvr_rx_protocol_hint_atom                = "CH0_RX_PROTOCOL_HINT_DISABLED"                      , 
    parameter ch0_quad0_pcie_mode_atom                            = "CH0_PCIE_MODE_DISABLED"                             , 
    parameter ch1_quad0_xcvr_tx_preloaded_hardware_configs_atom   = "CH1_TX_PRELOADED_HARDWARE_CONFIGS_NONE"             ,
    parameter ch1_quad0_xcvr_rx_preloaded_hardware_configs_atom   = "CH1_RX_PRELOADED_HARDWARE_CONFIGS_NONE"             ,
    parameter ch1_quad0_lc_postdiv_sel_atom                       = "CH1_LC_POSTDIV_SEL_SYNTH_FAST"                      ,
    parameter ch1_quad0_sequencer_reg_en_atom                     = "CH1_SEQUENCER_REG_EN_DISABLE"                       ,  
    parameter ch1_quad0_rst_mux_static_sel_atom                   = "CH1_RST_MUX_STATIC_SEL_UNUSED"                      ,  
    parameter ch1_quad0_xcvr_tx_prbs_pattern_atom                 = 4'd0                                                 ,
    parameter ch1_quad0_xcvr_rx_prbs_pattern_atom                 = 4'd0                                                 ,  
    parameter ch1_quad0_xcvr_tx_user_clk_only_mode_atom           = "CH1_TX_USER_CLK_ONLY_MODE_ENABLE"                   ,  
    parameter ch1_quad0_xcvr_tx_width_atom                        = "CH1_TX_WIDTH_DISABLED"                              ,
    parameter ch1_quad0_xcvr_rx_width_atom                        = "CH1_RX_WIDTH_DISABLED"                              , 
    parameter ch1_quad0_phy_loopback_mode_atom                    = "CH1_LOOPBACK_MODE_DISABLED"                         , 
    parameter ch1_quad0_flux_mode_atom                            = "CH1_FLUX_MODE_DISABLED"                             , 
    parameter ch1_quad0_tx_sim_mode_atom                          = "CH1_TX_SIM_MODE_DISABLE"                            , 
    parameter ch1_quad0_rx_sim_mode_atom                          = "CH1_RX_SIM_MODE_DISABLE"                            ,
    parameter ch1_quad0_tx_dl_enable_atom                         = "CH1_TX_DL_ENABLE_DISABLE"                           ,
    parameter ch1_quad0_rx_dl_enable_atom                         = "CH1_RX_DL_ENABLE_DISABLE"                           ,
    parameter ch1_quad0_rx_fec_type_used_atom                     = "CH1_RX_FEC_TYPE_USED_NONE"                          ,
    parameter ch1_quad0_xcvr_rx_prbs_monitor_en_atom              = "CH1_RX_PRBS_MONITOR_EN_DISABLE"                     , 
    parameter ch1_quad0_tx_prbs_gen_en_atom                       = "CH1_TX_PRBS_GEN_EN_DISABLE"                         , 
    parameter ch1_quad0_rx_user1_clk_mux_dynamic_sel_atom         = "CH1_RX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch1_quad0_rx_user2_clk_mux_dynamic_sel_atom         = "CH1_RX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch1_quad0_tx_user1_clk_mux_dynamic_sel_atom         = "CH1_TX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch1_quad0_tx_user2_clk_mux_dynamic_sel_atom         = "CH1_TX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch1_quad0_xcvr_rx_protocol_hint_atom                = "CH1_RX_PROTOCOL_HINT_DISABLED"                      , 
    parameter ch1_quad0_pcie_mode_atom                            = "CH1_PCIE_MODE_DISABLED"                             , 
    parameter ch2_quad0_xcvr_tx_preloaded_hardware_configs_atom   = "CH2_TX_PRELOADED_HARDWARE_CONFIGS_NONE"             ,
    parameter ch2_quad0_xcvr_rx_preloaded_hardware_configs_atom   = "CH2_RX_PRELOADED_HARDWARE_CONFIGS_NONE"             ,
    parameter ch2_quad0_lc_postdiv_sel_atom                       = "CH2_LC_POSTDIV_SEL_SYNTH_FAST"                      ,
    parameter ch2_quad0_sequencer_reg_en_atom                     = "CH2_SEQUENCER_REG_EN_DISABLE"                       ,
    parameter ch2_quad0_rst_mux_static_sel_atom                   = "CH2_RST_MUX_STATIC_SEL_UNUSED"                      , 
    parameter ch2_quad0_xcvr_tx_prbs_pattern_atom                 = 4'd0                                                 , 
    parameter ch2_quad0_xcvr_rx_prbs_pattern_atom                 = 4'd0                                                 , 
    parameter ch2_quad0_xcvr_tx_user_clk_only_mode_atom           = "CH2_TX_USER_CLK_ONLY_MODE_ENABLE"                   , 
    parameter ch2_quad0_xcvr_tx_width_atom                        = "CH2_TX_WIDTH_DISABLED"                              ,
    parameter ch2_quad0_xcvr_rx_width_atom                        = "CH2_RX_WIDTH_DISABLED"                              ,
    parameter ch2_quad0_phy_loopback_mode_atom                    = "CH2_LOOPBACK_MODE_DISABLED"                         ,
    parameter ch2_quad0_flux_mode_atom                            = "CH2_FLUX_MODE_DISABLED"                             ,
    parameter ch2_quad0_tx_sim_mode_atom                          = "CH2_TX_SIM_MODE_DISABLE"                            ,
    parameter ch2_quad0_rx_sim_mode_atom                          = "CH2_RX_SIM_MODE_DISABLE"                            ,
    parameter ch2_quad0_tx_dl_enable_atom                         = "CH2_TX_DL_ENABLE_DISABLE"                           ,
    parameter ch2_quad0_rx_dl_enable_atom                         = "CH2_RX_DL_ENABLE_DISABLE"                           ,
    parameter ch2_quad0_rx_fec_type_used_atom                     = "CH2_RX_FEC_TYPE_USED_NONE"                          ,
    parameter ch2_quad0_xcvr_rx_prbs_monitor_en_atom              = "CH2_RX_PRBS_MONITOR_EN_DISABLE"                     , 
    parameter ch2_quad0_tx_prbs_gen_en_atom                       = "CH2_TX_PRBS_GEN_EN_DISABLE"                         , 
    parameter ch2_quad0_rx_user1_clk_mux_dynamic_sel_atom         = "CH2_RX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch2_quad0_rx_user2_clk_mux_dynamic_sel_atom         = "CH2_RX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch2_quad0_tx_user1_clk_mux_dynamic_sel_atom         = "CH2_TX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch2_quad0_tx_user2_clk_mux_dynamic_sel_atom         = "CH2_TX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch2_quad0_xcvr_rx_protocol_hint_atom                = "CH2_RX_PROTOCOL_HINT_DISABLED"                      , 
    parameter ch2_quad0_pcie_mode_atom                            = "CH2_PCIE_MODE_DISABLED"                             , 
    parameter ch3_quad0_xcvr_tx_preloaded_hardware_configs_atom   = "CH3_TX_PRELOADED_HARDWARE_CONFIGS_NONE"             ,
    parameter ch3_quad0_xcvr_rx_preloaded_hardware_configs_atom   = "CH3_RX_PRELOADED_HARDWARE_CONFIGS_NONE"             ,
    parameter ch3_quad0_lc_postdiv_sel_atom                       = "CH3_LC_POSTDIV_SEL_SYNTH_FAST"                      ,
    parameter ch3_quad0_sequencer_reg_en_atom                     = "CH3_SEQUENCER_REG_EN_DISABLE"                       ,
    parameter ch3_quad0_rst_mux_static_sel_atom                   = "CH3_RST_MUX_STATIC_SEL_UNUSED"                      ,
    parameter ch3_quad0_xcvr_tx_prbs_pattern_atom                 = 4'd0                                                 ,
    parameter ch3_quad0_xcvr_rx_prbs_pattern_atom                 = 4'd0                                                 ,
    parameter ch3_quad0_xcvr_tx_user_clk_only_mode_atom           = "CH3_TX_USER_CLK_ONLY_MODE_ENABLE"                   ,
    parameter ch3_quad0_xcvr_tx_width_atom                        = "CH3_TX_WIDTH_DISABLED"                              ,
    parameter ch3_quad0_xcvr_rx_width_atom                        = "CH3_RX_WIDTH_DISABLED"                              ,
    parameter ch3_quad0_phy_loopback_mode_atom                    = "CH3_LOOPBACK_MODE_DISABLED"                         ,
    parameter ch3_quad0_flux_mode_atom                            = "CH3_FLUX_MODE_DISABLED"                             ,
    parameter ch3_quad0_tx_sim_mode_atom                          = "CH3_TX_SIM_MODE_DISABLE"                            ,
    parameter ch3_quad0_rx_sim_mode_atom                          = "CH3_RX_SIM_MODE_DISABLE"                            ,
    parameter ch3_quad0_tx_dl_enable_atom                         = "CH3_TX_DL_ENABLE_DISABLE"                           ,
    parameter ch3_quad0_rx_dl_enable_atom                         = "CH3_RX_DL_ENABLE_DISABLE"                           ,
    parameter ch3_quad0_rx_fec_type_used_atom                     = "CH3_RX_FEC_TYPE_USED_NONE"                          ,
    parameter ch3_quad0_xcvr_rx_prbs_monitor_en_atom              = "CH3_RX_PRBS_MONITOR_EN_DISABLE"                     , 
    parameter ch3_quad0_tx_prbs_gen_en_atom                       = "CH3_TX_PRBS_GEN_EN_DISABLE"                         , 
    parameter ch3_quad0_rx_user1_clk_mux_dynamic_sel_atom         = "CH3_RX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch3_quad0_rx_user2_clk_mux_dynamic_sel_atom         = "CH3_RX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch3_quad0_tx_user1_clk_mux_dynamic_sel_atom         = "CH3_TX_USER1_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch3_quad0_tx_user2_clk_mux_dynamic_sel_atom         = "CH3_TX_USER2_CLK_MUX_DYNAMIC_SEL_UNUSED"            , 
    parameter ch3_quad0_xcvr_rx_protocol_hint_atom                = "CH3_RX_PROTOCOL_HINT_DISABLED"                      , 
    parameter ch3_quad0_pcie_mode_atom                            = "CH3_PCIE_MODE_DISABLED"                             , 
    //Added 0p8 Allignment
    parameter ch0_quad0_tx_pll_l_counter_atom                     = 6'd0                                                 ,
    parameter ch0_quad0_cdr_l_counter_atom                        = 6'd0                                                 ,
    parameter ch0_quad0_tx_pll_refclk_select_atom                 = "CH0_TX_PLL_REFCLK_SELECT_GLOBAL_REFCLK0"            ,
    parameter ch0_quad0_cdr_refclk_select_atom                    = "CH0_CDR_REFCLK_SELECT_GLOBAL_REFCLK0"               ,
    parameter ch1_quad0_tx_pll_l_counter_atom                     = 6'd0                                                 ,
    parameter ch1_quad0_cdr_l_counter_atom                        = 6'd0                                                 ,
    parameter ch1_quad0_tx_pll_refclk_select_atom                 = "CH1_TX_PLL_REFCLK_SELECT_GLOBAL_REFCLK0"            ,
    parameter ch1_quad0_cdr_refclk_select_atom                    = "CH1_CDR_REFCLK_SELECT_GLOBAL_REFCLK0"               ,
    parameter ch2_quad0_tx_pll_l_counter_atom                     = 6'd0                                                 ,
    parameter ch2_quad0_cdr_l_counter_atom                        = 6'd0                                                 ,
    parameter ch2_quad0_tx_pll_refclk_select_atom                 = "CH2_TX_PLL_REFCLK_SELECT_GLOBAL_REFCLK0"            ,
    parameter ch2_quad0_cdr_refclk_select_atom                    = "CH2_CDR_REFCLK_SELECT_GLOBAL_REFCLK0"               ,
    parameter ch3_quad0_tx_pll_l_counter_atom                     = 6'd0                                                 ,
    parameter ch3_quad0_cdr_l_counter_atom                        = 6'd0                                                 ,
    parameter ch3_quad0_tx_pll_refclk_select_atom                 = "CH3_TX_PLL_REFCLK_SELECT_GLOBAL_REFCLK0"            ,
    parameter ch3_quad0_cdr_refclk_select_atom                    = "CH3_CDR_REFCLK_SELECT_GLOBAL_REFCLK0"               ,
    parameter ch0_quad0_rx_dl_rx_lat_bit_for_async_atom           = 18'd0                                                ,
    parameter ch0_quad0_rx_dl_rxbit_cntr_pma_atom                 = "CH0_RX_DL_RXBIT_CNTR_PMA_DISABLE"                   ,
    parameter ch0_quad0_rx_dl_rxbit_rollover_atom                 = 18'd0                                                ,
    parameter ch1_quad0_rx_dl_rx_lat_bit_for_async_atom           = 18'd0                                                ,
    parameter ch1_quad0_rx_dl_rxbit_cntr_pma_atom                 = "CH1_RX_DL_RXBIT_CNTR_PMA_DISABLE"                   ,
    parameter ch1_quad0_rx_dl_rxbit_rollover_atom                 = 18'd0                                                ,
    parameter ch2_quad0_rx_dl_rx_lat_bit_for_async_atom           = 18'd0                                                ,
    parameter ch2_quad0_rx_dl_rxbit_cntr_pma_atom                 = "CH2_RX_DL_RXBIT_CNTR_PMA_DISABLE"                   ,
    parameter ch2_quad0_rx_dl_rxbit_rollover_atom                 = 18'd0                                                ,
    parameter ch3_quad0_rx_dl_rx_lat_bit_for_async_atom           = 18'd0                                                ,
    parameter ch3_quad0_rx_dl_rxbit_cntr_pma_atom                 = "CH3_RX_DL_RXBIT_CNTR_PMA_DISABLE"                   ,
    parameter ch3_quad0_rx_dl_rxbit_rollover_atom                 = 18'd0                                                ,
    parameter ch0_quad0_tx_bonding_category_atom                  = "CH0_TX_BONDING_CATEGORY_UNUSED"                     ,
    parameter ch1_quad0_tx_bonding_category_atom                  = "CH1_TX_BONDING_CATEGORY_UNUSED"                     ,
    parameter ch2_quad0_tx_bonding_category_atom                  = "CH2_TX_BONDING_CATEGORY_UNUSED"                     ,
    parameter ch3_quad0_tx_bonding_category_atom                  = "CH3_TX_BONDING_CATEGORY_UNUSED"                     ,
    parameter ch0_quad0_tx_bond_size_atom                         = "CH0_TX_BOND_SIZE_UNUSED"                            ,
    parameter ch1_quad0_tx_bond_size_atom                         = "CH1_TX_BOND_SIZE_UNUSED"                            ,
    parameter ch2_quad0_tx_bond_size_atom                         = "CH2_TX_BOND_SIZE_UNUSED"                            ,
    parameter ch3_quad0_tx_bond_size_atom                         = "CH3_TX_BOND_SIZE_UNUSED"                            ,
                  
    parameter ch0_quad0_duplex_mode_atom                      =  "CH0_DUPLEX_MODE_DUPLEX"   ,
    parameter ch0_quad0_fec_spec_atom                         =  "CH0_FEC_SPEC_DISABLED"    ,
    parameter ch0_quad0_fracture_atom                         =  "CH0_FRACTURE_F25G"        ,
    parameter ch0_quad0_dr_enabled_atom                       =  "CH0_DR_ENABLED_DR_ENABLED",
    parameter ch0_quad0_sup_mode_atom                         =  "CH0_SUP_MODE_USER_MODE"   ,
    parameter ch0_quad0_sim_mode_atom                         =  "CH0_SIM_MODE_DISABLE"     ,
    parameter ch1_quad0_duplex_mode_atom                      =  "CH1_DUPLEX_MODE_DUPLEX"   ,
    parameter ch1_quad0_fec_spec_atom                         =  "CH1_FEC_SPEC_DISABLED"    ,
    parameter ch1_quad0_fracture_atom                         =  "CH1_FRACTURE_F25G"        ,
    parameter ch1_quad0_dr_enabled_atom                       =  "CH1_DR_ENABLED_DR_ENABLED",
    parameter ch1_quad0_sup_mode_atom                         =  "CH1_SUP_MODE_USER_MODE"   ,
    parameter ch1_quad0_sim_mode_atom                         =  "CH1_SIM_MODE_DISABLE"     ,
    parameter ch2_quad0_duplex_mode_atom                      =  "CH2_DUPLEX_MODE_DUPLEX"   ,
    parameter ch2_quad0_fec_spec_atom                         =  "CH2_FEC_SPEC_DISABLED"    ,
    parameter ch2_quad0_fracture_atom                         =  "CH2_FRACTURE_F25G"        ,
    parameter ch2_quad0_dr_enabled_atom                       =  "CH2_DR_ENABLED_DR_ENABLED",
    parameter ch2_quad0_sup_mode_atom                         =  "CH2_SUP_MODE_USER_MODE"   ,
    parameter ch2_quad0_sim_mode_atom                         =  "CH2_SIM_MODE_DISABLE"     ,
    parameter ch3_quad0_duplex_mode_atom                      =  "CH3_DUPLEX_MODE_DUPLEX"   ,
    parameter ch3_quad0_fec_spec_atom                         =  "CH3_FEC_SPEC_DISABLED"    ,
    parameter ch3_quad0_fracture_atom                         =  "CH3_FRACTURE_F25G"        ,
    parameter ch3_quad0_dr_enabled_atom                       =  "CH3_DR_ENABLED_DR_ENABLED",
    parameter ch3_quad0_sup_mode_atom                         =  "CH3_SUP_MODE_USER_MODE"   ,
    parameter ch3_quad0_sim_mode_atom                         =  "CH3_SIM_MODE_DISABLE"     ,
    parameter ch0_quad0_pcs_l_tx_en_atom                      = "FALSE"                     ,
    parameter ch0_quad0_pcs_l_rx_en_atom                      = "FALSE"                     ,
    parameter ch0_quad0_fec_loopback_mode_atom                = "CH0_LOOPBACK_MODE_DISABLE" ,
    parameter ch0_quad0_fec_dyn_tx_mux_atom                   = "CH0_DYN_TX_MUX_UNUSED"     ,
    parameter ch0_quad0_fec_error_atom                        = "FALSE"                     ,
    parameter ch0_quad0_fec_rx_en_atom                        = "FALSE"                     ,
    parameter ch0_quad0_fec_tx_en_atom                        = "FALSE"                     ,
    parameter ch0_quad0_fec_mode_atom                         = "CH0_FEC_MODE_DISABLED"     ,
    parameter ch1_quad0_pcs_l_tx_en_atom                      = "FALSE"                     ,
    parameter ch1_quad0_pcs_l_rx_en_atom                      = "FALSE"                     ,
    parameter ch1_quad0_fec_loopback_mode_atom                = "CH1_LOOPBACK_MODE_DISABLE" ,
    parameter ch1_quad0_fec_dyn_tx_mux_atom                   = "CH1_DYN_TX_MUX_UNUSED"     ,
    parameter ch1_quad0_fec_error_atom                        = "FALSE"                     ,
    parameter ch1_quad0_fec_rx_en_atom                        = "FALSE"                     ,
    parameter ch1_quad0_fec_tx_en_atom                        = "FALSE"                     ,
    parameter ch1_quad0_fec_mode_atom                         = "CH1_FEC_MODE_DISABLED"     ,
    parameter ch2_quad0_pcs_l_tx_en_atom                      = "FALSE"                     ,
    parameter ch2_quad0_pcs_l_rx_en_atom                      = "FALSE"                     ,
    parameter ch2_quad0_fec_loopback_mode_atom                = "CH2_LOOPBACK_MODE_DISABLE" ,
    parameter ch2_quad0_fec_dyn_tx_mux_atom                   = "CH2_DYN_TX_MUX_UNUSED"     ,
    parameter ch2_quad0_fec_error_atom                        = "FALSE"                     ,
    parameter ch2_quad0_fec_rx_en_atom                        = "FALSE"                     ,
    parameter ch2_quad0_fec_tx_en_atom                        = "FALSE"                     ,
    parameter ch2_quad0_fec_mode_atom                         = "CH2_FEC_MODE_DISABLED"     ,
    parameter ch3_quad0_pcs_l_tx_en_atom                      = "FALSE"                     ,
    parameter ch3_quad0_pcs_l_rx_en_atom                      = "FALSE"                     ,
    parameter ch3_quad0_fec_loopback_mode_atom                = "CH3_LOOPBACK_MODE_DISABLE" ,
    parameter ch3_quad0_fec_dyn_tx_mux_atom                   = "CH3_DYN_TX_MUX_UNUSED"     ,
    parameter ch3_quad0_fec_error_atom                        = "FALSE"                     ,
    parameter ch3_quad0_fec_rx_en_atom                        = "FALSE"                     ,
    parameter ch3_quad0_fec_tx_en_atom                        = "FALSE"                     ,
    parameter ch3_quad0_fec_mode_atom                         = "CH3_FEC_MODE_DISABLED"     ,
    
    parameter ch0_quad0_clkrx_refclk_cssm_fw_control_atom                = "CH0_CLKRX_REFCLK_CSSM_FW_CONTROL_ENABLE"                ,
    parameter ch1_quad0_clkrx_refclk_cssm_fw_control_atom                = "CH1_CLKRX_REFCLK_CSSM_FW_CONTROL_ENABLE"                ,
    parameter ch2_quad0_clkrx_refclk_cssm_fw_control_atom                = "CH2_CLKRX_REFCLK_CSSM_FW_CONTROL_ENABLE"                ,
    parameter ch3_quad0_clkrx_refclk_cssm_fw_control_atom                = "CH3_CLKRX_REFCLK_CSSM_FW_CONTROL_ENABLE"                ,
    parameter ch0_quad0_clkrx_refclk_sector_specifies_refclk_ready_atom  = "CH0_CLKRX_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE"  ,
    parameter ch1_quad0_clkrx_refclk_sector_specifies_refclk_ready_atom  = "CH1_CLKRX_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE"  ,
    parameter ch2_quad0_clkrx_refclk_sector_specifies_refclk_ready_atom  = "CH2_CLKRX_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE"  ,
    parameter ch3_quad0_clkrx_refclk_sector_specifies_refclk_ready_atom  = "CH3_CLKRX_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE"  ,
    parameter ch0_quad0_local_refclk_cssm_fw_control_atom                = "CH0_LOCAL_REFCLK_CSSM_FW_CONTROL_ENABLE"                   ,
    parameter ch1_quad0_local_refclk_cssm_fw_control_atom                = "CH1_LOCAL_REFCLK_CSSM_FW_CONTROL_ENABLE"                   ,
    parameter ch2_quad0_local_refclk_cssm_fw_control_atom                = "CH2_LOCAL_REFCLK_CSSM_FW_CONTROL_ENABLE"                   ,
    parameter ch3_quad0_local_refclk_cssm_fw_control_atom                = "CH3_LOCAL_REFCLK_CSSM_FW_CONTROL_ENABLE"                   ,
    parameter ch0_quad0_local_refclk_sector_specifies_refclk_ready_atom  = "CH0_LOCAL_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE"  ,
    parameter ch1_quad0_local_refclk_sector_specifies_refclk_ready_atom  = "CH1_LOCAL_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE"  ,
    parameter ch2_quad0_local_refclk_sector_specifies_refclk_ready_atom  = "CH2_LOCAL_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE"  ,
    parameter ch3_quad0_local_refclk_sector_specifies_refclk_ready_atom  = "CH3_LOCAL_REFCLK_SECTOR_SPECIFIES_REFCLK_READY_ENABLE"  ,
  
//Shared PTP parameters
    parameter num_of_lanes                                              = 1
)
(
    input      [(num_of_lanes*80)-1:0]   i_hio_txdata                             ,
    input      [(num_of_lanes*10)-1:0]   i_hio_txdata_extra                       ,
    input      [num_of_lanes-1:0]        i_hio_txdata_fifo_wr_en                  ,
    input      [num_of_lanes-1:0]        i_hio_rxdata_fifo_rd_en                  ,

      
    input   [20:0]                            i_hio_ch0_lavmm_addr                    ,
    input   [3:0]                             i_hio_ch0_lavmm_be                      ,
    input                                     i_hio_ch0_lavmm_read                    ,
    input                                     i_hio_ch0_lavmm_write                   ,
    input   [31:0]                            i_hio_ch0_lavmm_wdata                   ,
    output  [31:0]                            o_hio_ch0_lavmm_rdata                   ,
    output                                    o_hio_ch0_lavmm_rdata_valid             ,
    output                                    o_hio_ch0_lavmm_waitreq                 ,
    input                                     i_hio_ch0_lavmm_rstn                    ,
    input                                     i_hio_ch0_lavmm_clk                     ,

    input                                     i_hio_ch0_pld_rx_clk_in_row_clk         ,
    input                                     i_hio_ch0_pld_tx_clk_in_row_clk         ,
    input                                     i_hio_ch0_det_lat_rx_dl_clk             ,
    input                                     i_hio_ch0_det_lat_rx_mux_select         ,
    input                                     i_hio_ch0_det_lat_rx_sclk_flop          ,
    input                                     i_hio_ch0_det_lat_rx_sclk_gen_clk       ,
    input                                     i_hio_ch0_det_lat_rx_trig_flop          ,
    input                                     i_hio_ch0_det_lat_sampling_clk          ,
    input                                     i_hio_ch0_det_lat_tx_dl_clk             ,
    input                                     i_hio_ch0_det_lat_tx_mux_select         ,
    input                                     i_hio_ch0_det_lat_tx_sclk_flop          ,
    input                                     i_hio_ch0_det_lat_tx_sclk_gen_clk       ,
    input                                     i_hio_ch0_det_lat_tx_trig_flop          ,
   /*  input                                     i_ch0_i_refclk_tx_p   ,
    input                                     i_ch0_i_refclk_tx_n   ,
    input                                     i_ch0_i_syspll_c0_clk ,
    input                                     i_ch0_i_syspll_c1_clk ,
    input                                     i_ch0_i_syspll_c2_clk ,
    input                                     i_ch0_i_flux_clk      ,
    input                                     i_ch0_i_refclk_rx_p   ,
    input                                     i_ch0_i_refclk_rx_n   , */
    output                                    o_hio_ch0_user_rx_clk1_clk              ,
    output                                    o_hio_ch0_user_rx_clk2_clk              ,
    output                                    o_hio_ch0_user_tx_clk1_clk              ,
    output                                    o_hio_ch0_user_tx_clk2_clk              ,
    output                                    o_hio_ch0_ux_chnl_refclk_mux            ,
    output                                    o_hio_ch0_det_lat_rx_async_dl_sync      ,
    output                                    o_hio_ch0_det_lat_rx_async_pulse        ,
    output                                    o_hio_ch0_det_lat_rx_async_sample_sync  ,
    output                                    o_hio_ch0_det_lat_rx_sclk_sample_sync   ,
    output                                    o_hio_ch0_det_lat_rx_trig_sample_sync   ,
    output                                    o_hio_ch0_det_lat_tx_async_dl_sync      ,
    output                                    o_hio_ch0_det_lat_tx_async_pulse        ,
    output                                    o_hio_ch0_det_lat_tx_async_sample_sync  ,
    output                                    o_hio_ch0_det_lat_tx_sclk_sample_sync   ,
    output                                    o_hio_ch0_det_lat_tx_trig_sample_sync   ,
    output                                    o_hio_ch0_xcvrif_rx_latency_pulse       ,
    output                                    o_hio_ch0_xcvrif_tx_latency_pulse       ,


    input      [num_of_lanes-1:0]        i_hio_ptp_rst_n                          ,
    input      [num_of_lanes-1:0]        i_hio_ehip_rx_rst_n                      ,
    input      [num_of_lanes-1:0]        i_hio_ehip_tx_rst_n                      ,
    input      [num_of_lanes-1:0]        i_hio_ehip_signal_ok                     ,
    input      [num_of_lanes-1:0]        i_hio_sfreeze_2_r03f_rx_mac_srfz_n       ,
    input      [num_of_lanes-1:0]        i_hio_sfreeze_3_c2f_tx_deskew_srfz_n    ,
    input      [num_of_lanes-1:0]        i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n       ,
    input      [num_of_lanes-1:0]        i_hio_rstfec_fec_rx_rst_n                ,
    input      [num_of_lanes-1:0]        i_hio_rstfec_fec_tx_rst_n                ,
    input      [num_of_lanes-1:0]        i_hio_rstfec_fec_csr_ret                 ,
    input      [num_of_lanes-1:0]        i_hio_rstfec_rx_fec_sfrz_n               ,
    input      [num_of_lanes-1:0]        i_hio_rstfec_tx_fec_sfrz_n               ,
    input      [num_of_lanes-1:0]        i_hio_rstxcvrif_xcvrif_rx_rst_n          ,
    input      [num_of_lanes-1:0]        i_hio_rstxcvrif_xcvrif_tx_rst_n          ,
    input      [num_of_lanes-1:0]        i_hio_rstxcvrif_xcvrif_signal_ok         ,
    input      [num_of_lanes-1:0]        i_hio_rstxcvrif_rx_xcvrif_sfrz_n         ,
    input      [num_of_lanes-1:0]        i_hio_rstxcvrif_tx_xcvrif_sfrz_n         ,
    input      [num_of_lanes-1:0]        i_hio_rst_pld_clrhip                     ,
    input      [num_of_lanes-1:0]        i_hio_rst_pld_clrpcs                     ,
    input      [num_of_lanes-1:0]        i_hio_rst_pld_perstn                     ,
    input      [num_of_lanes-1:0]        i_hio_rst_pld_ready                      ,
    input      [num_of_lanes-1:0]        i_hio_rst_pld_adapter_rx_pld_rst_n       ,
    input      [num_of_lanes-1:0]        i_hio_rst_pld_adapter_tx_pld_rst_n       ,
    input      [num_of_lanes-1:0]        i_hio_rst_ux_rx_pma_rst_n                ,
    input      [num_of_lanes-1:0]        i_hio_rst_ux_rx_sfrz                     ,
    input      [num_of_lanes-1:0]        i_hio_rst_ux_tx_pma_rst_n                ,
    input      [num_of_lanes-1:0]        i_hio_pld_reset_clk_row                  ,
    input      [(num_of_lanes*80)-1:0]   i_hio_uxquad_async                       ,
    input      [(num_of_lanes*80)-1:0]   i_hio_uxquad_async_pcie_mux              ,
    //input      [num_of_lanes-1:0] [20:0] i_hio_lavmm_addr                         ,
    //input      [num_of_lanes-1:0]  [3:0] i_hio_lavmm_be                           ,
    //input      [num_of_lanes-1:0]        i_hio_lavmm_clk                          ,
    //input      [num_of_lanes-1:0]        i_hio_lavmm_read                         ,
    //input      [num_of_lanes-1:0]        i_hio_lavmm_rstn                         ,
    //input      [num_of_lanes-1:0][31:0]  i_hio_lavmm_wdata                        ,
    //input      [num_of_lanes-1:0]        i_hio_lavmm_write                        ,
    //input      [num_of_lanes-1:0]        i_hio_pld_rx_clk_in_row_clk              ,
    //input      [num_of_lanes-1:0]        i_hio_pld_tx_clk_in_row_clk              ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_rx_dl_clk                  ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_rx_mux_select              ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_rx_sclk_flop               ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_rx_sclk_gen_clk            ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_rx_trig_flop               ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_sampling_clk               ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_tx_dl_clk                  ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_tx_mux_select              ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_tx_sclk_flop               ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_tx_sclk_gen_clk            ,
    //input      [num_of_lanes-1:0]        i_hio_det_lat_tx_trig_flop               ,
    input      [num_of_lanes-1:0]        rx_serial_n                              ,
    input      [num_of_lanes-1:0]        rx_serial_p                              ,   
    //input      [num_of_lanes-1:0] [7:0]  i_hio_tx_pfc                             , //bits defined
    //input      [num_of_lanes-1:0]        i_hio_tx_pause                           , //bits defined
    //input      [num_of_lanes-1:0]        i_hio_clear_internal                     , //bits defined
    //input      [num_of_lanes-1:0]        i_hio_signal_ok                          , //bits defined
    //input      [num_of_lanes-1:0]        i_hio_pld_ready                          , //bits defined
    //input      [num_of_lanes-1:0]        i_hio_pma_rx_sf                          , //bits defined
    //input      [num_of_lanes-1:0]        i_hio_ch_rstxcvrif_lphy_signal_ok        , //bits defined
    //input      [num_of_lanes-1:0]        i_clear_tx_internal_err                  , //bits defined 
    output     [num_of_lanes-1:0]        o_hio_txdata_fifo_wr_empty               ,
    output     [num_of_lanes-1:0]        o_hio_txdata_fifo_wr_pempty              ,
    output     [num_of_lanes-1:0]        o_hio_txdata_fifo_wr_full                ,
    output     [num_of_lanes-1:0]        o_hio_txdata_fifo_wr_pfull               ,
    output     [(num_of_lanes*80)-1:0]   o_hio_rxdata                             ,
    output     [(num_of_lanes*10)-1:0]   o_hio_rxdata_extra                       ,
    output     [num_of_lanes-1:0]        o_hio_rxdata_fifo_rd_empty               ,
    output     [num_of_lanes-1:0]        o_hio_rxdata_fifo_rd_pempty              ,
    output     [num_of_lanes-1:0]        o_hio_rxdata_fifo_rd_full                ,
    output     [num_of_lanes-1:0]        o_hio_rxdata_fifo_rd_pfull               ,
    output     [num_of_lanes-1:0]        o_hio_rstepcs_rx_pcs_fully_aligned       ,
    output     [num_of_lanes-1:0]        o_hio_rstfec_fec_rx_rdy_n                ,
    output     [num_of_lanes-1:0]        o_hio_rst_flux0_cpi_cmn_busy             ,
    output     [num_of_lanes-1:0]        o_hio_rst_oflux_rx_srds_rdy              ,
    output     [num_of_lanes-1:0]        o_hio_rst_ux_all_synthlockstatus         ,
    output     [num_of_lanes-1:0]        o_hio_rst_ux_octl_pcs_rxstatus           ,
    output     [num_of_lanes-1:0]        o_hio_rst_ux_octl_pcs_txstatus           ,
    output     [num_of_lanes-1:0]        o_hio_rst_ux_rxcdrlock2data              ,
    output     [num_of_lanes-1:0]        o_hio_rst_ux_rxcdrlockstatus             ,
    output     [(num_of_lanes*50)-1:0]   o_hio_uxquad_async                       ,
    //output     [num_of_lanes-1:0] [31:0] o_hio_lavmm_rdata                        ,
    //output     [num_of_lanes-1:0]        o_hio_lavmm_rdata_valid                  ,
    //output     [num_of_lanes-1:0]        o_hio_lavmm_waitreq                      ,
   // output     [num_of_lanes-1:0] [2:0]  k_user_rx_clk1_c0c1c2_sel                ,
   // output     [num_of_lanes-1:0] [2:0]  k_user_rx_clk2_c0c1c2_sel                ,
   // output     [num_of_lanes-1:0] [2:0]  k_user_tx_clk1_c0c1c2_sel                ,
   // output     [num_of_lanes-1:0] [2:0]  k_user_tx_clk2_c0c1c2_sel                ,
    //output     [num_of_lanes-1:0]        o_hio_user_rx_clk1_clk                   ,
    //output     [num_of_lanes-1:0]        o_hio_user_rx_clk2_clk                   ,
    //output     [num_of_lanes-1:0]        o_hio_user_tx_clk1_clk                   ,
    //output     [num_of_lanes-1:0]        o_hio_user_tx_clk2_clk                   ,
    //output     [num_of_lanes-1:0]        o_hio_ux_chnl_refclk_mux                 ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_rx_async_dl_sync           ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_rx_async_pulse             ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_rx_async_sample_sync       ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_rx_sclk_sample_sync        ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_rx_trig_sample_sync        ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_tx_async_dl_sync           ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_tx_async_pulse             ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_tx_async_sample_sync       ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_tx_sclk_sample_sync        ,
    //output     [num_of_lanes-1:0]        o_hio_det_lat_tx_trig_sample_sync        ,
    //output     [num_of_lanes-1:0]        o_hio_xcvrif_rx_latency_pulse            ,
    //output     [num_of_lanes-1:0]        o_hio_xcvrif_tx_latency_pulse            ,
    output     [num_of_lanes-1:0]        tx_serial_p                              ,
    output     [num_of_lanes-1:0]        tx_serial_n                              ,
    //output     [num_of_lanes-1:0]        o_hio_local_fault                        , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_remote_fault                       , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_pause                           , //bits defined
    //output     [num_of_lanes-1:0] [7:0]  o_hio_rx_pfc                             , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_txfifo_pfull                       , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_dsk_err                            , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_dsk_mon_err                        , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_hip_ready                          , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_block_lock                      , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_dsk_done                        , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_am_lock                         , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_pcs_fully_aligned               , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_hi_ber                             , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_pcs_internal_err                , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_tx_fifo_status_fifo_wr_pfull       , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_tx_fifo_status_fifo_pempty         , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_fifo_status_fifo_pempty         , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_fifo_status_fifo_wr_pfull       , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_fifo_status_fifo_empty          , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_tx_fifo_status_fifo_empty          , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_rx_fifo_status_gb_restarted        , //bits defined
    //output     [num_of_lanes-1:0]        o_hio_tx_fifo_status_gb_restarted          //bits defined 

    input [(num_of_lanes*100)-1:0] i_hio_txdata_async  ,    
    input [(num_of_lanes*10)-1:0]  i_hio_txdata_direct ,    
    output [(num_of_lanes*100)-1:0] o_hio_rxdata_async ,     
    output [(num_of_lanes*10)-1:0]  o_hio_rxdata_direct ,
    
    input                           i_refclk_tx_p   ,
//    input                           i_refclk_tx_n   ,//can derive as negated i_refclk_tx_p
    input                           i_syspll_c0_clk ,
    input                           i_syspll_c1_clk ,
    input                           i_syspll_c2_clk ,
    input                           i_flux_clk_0    ,
    input                           i_flux_clk_1    ,
    input                           i_refclk_rx_p   ,
//    input                           i_refclk_rx_n   ,
/* //As per 0p8 Signals Exposed to HAL_TOP 
    input                 [3:0]     i_q2q_xcvrrc_ux_ux__txstatus_rc_ux   ,
    output                [3:0]     o_q2q_xcvrrc_ux_ux__txstatus_ux_rc */
    
/*    //PTP PORTS */
    input  [20:0] i_hio_lavmm_addr_ptp,
    input  [31:0] i_hio_lavmm_wdata_ptp,
    input  [3:0 ] i_hio_lavmm_be_ptp                           ,
    input  [79:0] i_hio_txdata_ptp,
    input  [79:0] i_hio_uxquad_async_ptp,
    input  [79:0] i_hio_uxquad_async_pcie_mux_ptp,
    input  [99:0] i_hio_txdata_async_ptp,    
    input  [9:0 ] i_hio_txdata_direct_ptp,
    input  [9:0 ] i_hio_txdata_extra_ptp,
    input  i_hio_det_lat_rx_dl_clk_ptp,
    input  i_hio_det_lat_rx_mux_select_ptp  ,
    input  i_hio_det_lat_rx_sclk_flop_ptp   ,
    input  i_hio_det_lat_rx_sclk_gen_clk_ptp,
    input  i_hio_det_lat_rx_trig_flop_ptp   ,
    input  i_hio_det_lat_sampling_clk_ptp   ,
    input  i_hio_det_lat_tx_dl_clk_ptp      ,
    input  i_hio_det_lat_tx_mux_select_ptp  ,
    input  i_hio_det_lat_tx_sclk_flop_ptp   ,
    input  i_hio_det_lat_tx_sclk_gen_clk_ptp,
    input  i_hio_det_lat_tx_trig_flop_ptp   ,
    input  i_hio_lavmm_clk_ptp,
    input  i_hio_lavmm_read_ptp,
    input  i_hio_lavmm_rstn_ptp,
    input  i_hio_lavmm_write_ptp,
    input  i_hio_pld_reset_clk_row_ptp,
    input  i_hio_pld_rx_clk_in_row_clk_ptp,
    input  i_hio_pld_tx_clk_in_row_clk_ptp,
    input  i_hio_ptp_rst_n_ptp,
    input  i_hio_rst_pld_adapter_rx_pld_rst_n_ptp,
    input  i_hio_rst_pld_adapter_tx_pld_rst_n_ptp,
    input  i_hio_rst_pld_ready_ptp,
    input  i_hio_rxdata_fifo_rd_en_ptp,
    input  i_hio_txdata_fifo_wr_en_ptp,
    output [31:0] o_hio_lavmm_rdata_ptp,
    output [49:0] o_hio_uxquad_async_ptp,
    output [79:0] o_hio_rxdata_ptp,
    output [99:0] o_hio_rxdata_async_ptp ,     
    output [9:0 ] o_hio_rxdata_direct_ptp ,
    output [9:0 ] o_hio_rxdata_extra_ptp,
    output  o_hio_det_lat_rx_async_dl_sync_ptp    ,
    output  o_hio_det_lat_rx_async_pulse_ptp      ,
    output  o_hio_det_lat_rx_async_sample_sync_ptp,
    output  o_hio_det_lat_rx_sclk_sample_sync_ptp ,
    output  o_hio_det_lat_rx_trig_sample_sync_ptp ,
    output  o_hio_det_lat_tx_async_dl_sync_ptp    ,
    output  o_hio_det_lat_tx_async_pulse_ptp      ,
    output  o_hio_det_lat_tx_async_sample_sync_ptp,
    output  o_hio_det_lat_tx_sclk_sample_sync_ptp ,
    output  o_hio_det_lat_tx_trig_sample_sync_ptp ,
    output  o_hio_lavmm_rdata_valid_ptp,
    output  o_hio_lavmm_waitreq_ptp    ,
    output  o_hio_rxdata_fifo_rd_empty_ptp ,
    output  o_hio_rxdata_fifo_rd_full_ptp  ,
    output  o_hio_rxdata_fifo_rd_pempty_ptp,
    output  o_hio_rxdata_fifo_rd_pfull_ptp ,
    output  o_hio_txdata_fifo_wr_empty_ptp ,
    output  o_hio_txdata_fifo_wr_pempty_ptp,
    output  o_hio_txdata_fifo_wr_full_ptp  ,    
    output  o_hio_txdata_fifo_wr_pfull_ptp ,
    output  o_hio_user_rx_clk1_clk_ptp,
    output  o_hio_user_rx_clk2_clk_ptp,
    output  o_hio_user_tx_clk1_clk_ptp,
    output  o_hio_user_tx_clk2_clk_ptp,
    output  o_hio_ux_chnl_refclk_mux_ptp,
    output  o_hio_xcvrif_rx_latency_pulse_ptp,
    output  o_hio_xcvrif_tx_latency_pulse_ptp,
    output [num_of_lanes-1:0]      ioack_cdrdiv_left_ux_bidir_out

);

  //  wire [num_of_lanes-1:0] [99:0] i_hio_txdata_async  ;     
  //  wire [num_of_lanes-1:0] [9:0 ] i_hio_txdata_direct ;     
  //  wire [num_of_lanes-1:0] [99:0] o_hio_rxdata_async  ;     
  //  wire [num_of_lanes-1:0] [9:0 ] o_hio_rxdata_direct ;

localparam quad_num_reg = (1 <= 4)? 1 : 2;
//phy_hal_shared signals
    wire [(4*quad_num_reg)-1:0][767:0]  uxwrap_bus_in_phy_shared                  ;
    wire [(4*quad_num_reg)-1:0][703:0]  uxwrap_bus_out_phy_shared                 ;
    wire [(4*quad_num_reg)-1:0][19:0]   lavmm_addr_phy_shared                     ;
    wire [(4*quad_num_reg)-1:0][3:0]    lavmm_be_phy_shared                       ;
    wire [(4*quad_num_reg)-1:0]         lavmm_clk_phy_shared                      ;
    wire [(4*quad_num_reg)-1:0]         lavmm_read_phy_shared                     ;
    wire [(4*quad_num_reg)-1:0]         lavmm_rstn_phy_shared                     ;
    wire [(4*quad_num_reg)-1:0][31:0]   lavmm_wdata_phy_shared                    ;
    wire [(4*quad_num_reg)-1:0]         lavmm_write_phy_shared                    ;
    wire [(4*quad_num_reg)-1:0][31:0]   lavmm_rdata_phy_shared                    ;
    wire [(4*quad_num_reg)-1:0]         lavmm_rdata_valid_phy_shared              ;
    wire [(4*quad_num_reg)-1:0]         lavmm_waitreq_phy_shared                  ;
    wire [(4*quad_num_reg)-1:0]         dat_pcs_measlatrndtripbit_phy_shared      ;
    wire [(4*quad_num_reg)-1:0]         sclk_return_sel_rx_phy_shared             ;
    wire [(4*quad_num_reg)-1:0]         sclk_return_sel_tx_phy_shared             ;
    wire [(4*quad_num_reg)-1:0]         s_o_ick_sclk_rx_phy_shared                ;
    wire [(4*quad_num_reg)-1:0] [4:0]   sync_common_control_phy_shared            ;   
    wire [(4*quad_num_reg)-1:0]         ft_rx_sclk_sync_ch_phy_shared             ;
    wire [(4*quad_num_reg)-1:0]         ft_tx_sclk_sync_ch_phy_shared             ;
    wire [(4*quad_num_reg)-1:0]         rst_ux_rx_pma_rst_n_phy_shared            ;
    wire [(4*quad_num_reg)-1:0]         rst_ux_tx_pma_rst_n_phy_shared            ;
    wire [(4*quad_num_reg)-1:0]         ick_pcs_txword_phy_shared                 ;
    wire [(4*quad_num_reg)-1:0]         tx_dl_ch_bit_phy_shared                   ;
    wire [(4*quad_num_reg)-1:0]         dat_pcs_measlatbit_phy_shared             ;
    wire [(4*quad_num_reg)-1:0]         ft_rx_async_pulse_ch_phy_shared           ;
    wire [(4*quad_num_reg)-1:0]         ft_tx_async_pulse_ch_phy_shared           ;
    wire [(4*quad_num_reg)-1:0]         rx_dl_ch_bit_phy_shared                   ;
    wire [(4*quad_num_reg)-1:0] [1:0]   ux_rxuser1_sel_phy_shared                 ;
    wire [(4*quad_num_reg)-1:0] [1:0]   ux_rxuser2_sel_phy_shared                 ;
    wire [(4*quad_num_reg)-1:0] [1:0]   ux_txuser1_sel_phy_shared                 ;
    wire [(4*quad_num_reg)-1:0] [1:0]   ux_txuser2_sel_phy_shared                 ;
    wire [(4*quad_num_reg)-1:0]         octl_pcs_txstatus_a_phy_shared            ;
    wire [(4*quad_num_reg)-1:0]         ictl_pcs_txenable_a_phy_shared            ;
    wire [(4*quad_num_reg)-1:0] [124:0] sync_cfg_data_phy_shared                  ;
    wire [(4*quad_num_reg)-1:0] [249:0] sync_interface_control_phy_shared         ;
    wire [(4*quad_num_reg)-1:0] [79:0]  tx_data_phy_shared                        ;
    wire [(4*quad_num_reg)-1:0] [79:0]  rx_data_phy_shared                        ;
    wire [(4*quad_num_reg)-1:0] [319:0] sm_flux_ingress_phy_shared                ;
    wire [(4*quad_num_reg)-1:0] [256:0] sm_flux_egress_phy_shared                 ;
    wire [(4*quad_num_reg)-1:0]         flux_cpi_int_phy_shared                   ;               
    wire [(4*quad_num_reg)-1:0]         flux_int_phy_shared                       ;
    wire [(4*quad_num_reg)-1:0]         oflux_octl_pcs_txptr_smpl_lane_phy_shared ;
    wire [(4*quad_num_reg)-1:0]         ick_sclk_tx_phy_shared                    ;
    wire [(4*quad_num_reg)-1:0]         flux_srds_rdy_phy_shared                  ;
    wire [(4*quad_num_reg)-1:0]         pcs_rxword_phy_shared                     ;
    wire [(4*quad_num_reg)-1:0]         pcs_rxpostdiv_phy_shared                  ;
    wire [(4*quad_num_reg)-1:0]         ock_pcs_txword_phy_shared                 ;
    
//fec_wrap signals
    wire [(4*quad_num_reg)-1:0][19:0]   ch_lavmm_fec_addr_fec_wrap        ;
    wire [(4*quad_num_reg)-1:0][3:0]    ch_lavmm_fec_be_fec_wrap          ;
    wire [(4*quad_num_reg)-1:0]         ch_lavmm_fec_clk_fec_wrap         ;
    wire [(4*quad_num_reg)-1:0]         ch_lavmm_fec_read_fec_wrap        ;
    wire [(4*quad_num_reg)-1:0]         ch_lavmm_fec_rstn_fec_wrap        ;
    wire [(4*quad_num_reg)-1:0][31:0]   ch_lavmm_fec_wdata_fec_wrap       ;
    wire [(4*quad_num_reg)-1:0]         ch_lavmm_fec_write_fec_wrap       ;
    wire [(4*quad_num_reg)-1:0][31:0]   ch_lavmm_fec_rdata_fec_wrap       ;
    wire [(4*quad_num_reg)-1:0]         ch_lavmm_fec_rdata_valid_fec_wrap ;
    wire [(4*quad_num_reg)-1:0]         ch_lavmm_fec_waitreq_fec_wrap     ;
    wire [(4*quad_num_reg)-1:0][11:0]   ch_eth_fec_rx_async_fec_wrap      ;
    wire [(4*quad_num_reg)-1:0]         ch_eth_fec_rx_direct_fec_wrap     ;
    wire [(4*quad_num_reg)-1:0][6:0]    ch_eth_fec_tx_async_fec_wrap      ;
    wire [(4*quad_num_reg)-1:0]         ch_eth_fec_tx_direct_fec_wrap     ;
    wire [(4*quad_num_reg)-1:0]         rstfec_fec_csr_ret_fec_wrap       ;
    wire [(4*quad_num_reg)-1:0]         fec_rx_rdy_n_fec_wrap             ;
    wire [(4*quad_num_reg)-1:0]         rstfec_fec_rx_rst_n_fec_wrap      ;
    wire [(4*quad_num_reg)-1:0]         rstfec_fec_tx_rst_n_fec_wrap      ;
    wire [(4*quad_num_reg)-1:0]         rstfec_rx_fec_sfrz_n_fec_wrap     ;
    wire [(4*quad_num_reg)-1:0]         rstfec_tx_fec_sfrz_n_fec_wrap     ;
    wire [(4*quad_num_reg)-1:0]         fec_tx_data_mux_sel_fec_wrap      ;
    wire [(4*quad_num_reg)-1:0][42:0]   fec_rx_data_fec_wrap              ;
    wire [(4*quad_num_reg)-1:0][42:0]   fec_i_tx_mux_data_fec_wrap        ;
    wire [(4*quad_num_reg)-1:0][42:0]   xcvr_rx_data                      ;
    wire [(4*quad_num_reg)-1:0][42:0]   xcvr_tx_data                      ;
    wire [(4*quad_num_reg)-1:0]         pma_rx_sf                         ;

    wire  [1-1:0]  xcvrif_tx_fifo_rd_en_mux_x1             ;
    wire  [1-1:0]  xcvrif_tx_rst_mux_x1                    ;
    wire  [1-1:0]  xcvrif_tx_word_clk_mux_x1               ;
    wire  [1-1:0]  xcvrif_tx_fifo_rd_en_mux_x2             ;
    wire  [1-1:0]  xcvrif_tx_fifo_rd_en_mux_x4             ;
    wire  [1-1:0]  xcvrif_tx_fifo_rd_en_mux_x6_bot         ;
    wire  [1-1:0]  xcvrif_tx_fifo_rd_en_mux_x6_top         ;
    wire  [1-1:0]  xcvrif_tx_fifo_rd_en_mux_x8_bot         ;
    wire  [1-1:0]  xcvrif_tx_fifo_rd_en_mux_x8_top         ;
    wire  [1-1:0]  xcvrif_tx_rst_mux_x2                    ;
    wire  [1-1:0]  xcvrif_tx_rst_mux_x4                    ;
    wire  [1-1:0]  xcvrif_tx_rst_mux_x6_bot                ;
    wire  [1-1:0]  xcvrif_tx_rst_mux_x6_top                ;
    wire  [1-1:0]  xcvrif_tx_rst_mux_x8_bot                ;
    wire  [1-1:0]  xcvrif_tx_rst_mux_x8_top                ;
    wire  [1-1:0]  xcvrif_tx_word_clk_mux_x2               ;
    wire  [1-1:0]  xcvrif_tx_word_clk_mux_x4               ;
    wire  [1-1:0]  xcvrif_tx_word_clk_mux_x6_bot           ;
    wire  [1-1:0]  xcvrif_tx_word_clk_mux_x6_top           ;
    wire  [1-1:0]  xcvrif_tx_word_clk_mux_x8_bot           ;
    wire  [1-1:0]  xcvrif_tx_word_clk_mux_x8_top           ;
//1p0 Allignment
    wire  [1-1:0]  xcvrif_tx_rst_wr_sync_mux_x1            ;
    wire  [1-1:0]  xcvrif_tx_rst_wr_sync_mux_x2            ;
    wire  [1-1:0]  xcvrif_tx_rst_wr_sync_mux_x4            ;
    wire  [1-1:0]  xcvrif_tx_rst_wr_sync_mux_x6_bot        ;
    wire  [1-1:0]  xcvrif_tx_rst_wr_sync_mux_x6_top        ;
    wire  [1-1:0]  xcvrif_tx_rst_wr_sync_mux_x8_bot        ;
    wire  [1-1:0]  xcvrif_tx_rst_wr_sync_mux_x8_top        ;

    wire  [1-1:0]  marker_found_up                         ;
    wire  [1-1:0]  marker_found_dn                         ;
    wire  [1-1:0]  marker_found                            ;

    wire  [1-1:0]  ioack_synthdiv1_left_ux_bidir_out_reg   ;
    wire  [1-1:0]  ioack_synthdiv1_left_ux_bidir_in_reg    ;

    wire  flux_cpi_int_phy_shared_reg                               ;

    wire  [1-1:0] [7:0] ptp_rx_data_shared_ptp             ;
    wire  [1-1:0] [8:0] ptp_tx_intfc_ptp_data_shared_ptp   ;
    wire  [1-1:0] [8:0] ptp_tx_data_ld_shared_ptp          ;
    wire  [1-1:0]       ptp_tx_wa_ld_shared_ptp            ;
    wire  [1-1:0] [3071:0] ptp_cfg_tx_asm_ch1_shared_ptp   ;
    wire  [1-1:0] [3071:0] ptp_cfg_tx_p2p_ch1_shared_ptp   ;
    wire  [1-1:0] [7:0] ingress1_ptp_rx_intfc_ptp_data_shared_ptp;
    wire  [1-1:0] [8:0] egress1_ptp_tx_data_shared_ptp     ;
    wire  [1-1:0] [8:0] egress1_ptp_tx_data_ld_shared_ptp  ;
    wire  [1-1:0]       ch1_ptp_mas_word_align_shared_ptp  ;
    wire  [1-1:0]       egress1_ptp_tx_wa_ld_shared_ptp    ;
    wire  [1-1:0]       ingress1_ptp_rx_dsk_marker_shared_ptp;
    wire  [1-1:0]       ptp_ptpi_link_shared_ptp           ;
    wire  [1-1:0] [9:0] ptp_rx_data_mux_0_shared_ptp       ;
    wire  [1-1:0] [9:0] ptp_rx_data_mux_1_shared_ptp       ;
    wire  [1-1:0] [39:0] sm_pld_tx_demux_0_o_eth_shared_ptp;
    wire  [1-1:0]       ptp_clk_shared_ptp;
    wire  [1:0] [3:0]  q2q_xcvrrc_ux_ux__txstatus_rc_ux  ;
    wire  [1:0] [3:0]  q2q_xcvrrc_ux_ux__txstatus_ux_rc  ;

//Quartus Warnings
        assign ptp_cfg_tx_asm_ch1_shared_ptp[0][3071:0]          = 3072'b0;
        assign ptp_cfg_tx_p2p_ch1_shared_ptp[0][3071:0]          = 3072'b0;
        assign ingress1_ptp_rx_intfc_ptp_data_shared_ptp[0][7:0] = 8'b0;
        assign egress1_ptp_tx_data_shared_ptp[0][8:0]            = 9'b0;
        assign egress1_ptp_tx_data_ld_shared_ptp[0][8:0]         = 9'b0;
        assign ch1_ptp_mas_word_align_shared_ptp[0]              = 1'b0;
        assign egress1_ptp_tx_wa_ld_shared_ptp[0]                = 1'b0;
        assign ingress1_ptp_rx_dsk_marker_shared_ptp[0]          = 1'b0;
        assign ptp_ptpi_link_shared_ptp[0]                       = 1'b0;
        assign ptp_rx_data_mux_0_shared_ptp[0][9:0]              = 10'b0;
        assign ptp_rx_data_mux_1_shared_ptp[0][9:0]              = 10'b0;
        assign sm_pld_tx_demux_0_o_eth_shared_ptp[0][39:0]       = 40'b0;

//PFE Need to Fix --AG

    assign xcvrif_tx_fifo_rd_en_mux_x2[0]     = ((1>=2 && 0<2)? xcvrif_tx_fifo_rd_en_mux_x1[0] : ((1>=2 && 0<4)? xcvrif_tx_fifo_rd_en_mux_x1[2] : ((1>=2 && 0<6)? xcvrif_tx_fifo_rd_en_mux_x1[4] : ((1>=2 && 0<8)? xcvrif_tx_fifo_rd_en_mux_x1[6] : 1'bz)))) ;
    assign xcvrif_tx_fifo_rd_en_mux_x4[0]     = ((1>=3 && 0<=3)? xcvrif_tx_fifo_rd_en_mux_x1[0] : ((1==8)? xcvrif_tx_fifo_rd_en_mux_x1[4] : 1'bz));
    assign xcvrif_tx_fifo_rd_en_mux_x6_bot[0] = (((1==5 || 1==6) && (0==4 || 0==5))? xcvrif_tx_fifo_rd_en_mux_x1[0] : ((1==8) && (0==6 || 0==7)) ? xcvrif_tx_fifo_rd_en_mux_x1[0] : 1'bz);
    assign xcvrif_tx_fifo_rd_en_mux_x6_top[0] = ((1>=5 && 0<4)? xcvrif_tx_fifo_rd_en_mux_x1[0] : 1'bz);
    assign xcvrif_tx_fifo_rd_en_mux_x8_bot[0] = ((1>=7 && 0>=4)? xcvrif_tx_fifo_rd_en_mux_x1[0] : 1'bz);
    assign xcvrif_tx_fifo_rd_en_mux_x8_top[0] = ((1>=7 && 0<=3)? xcvrif_tx_fifo_rd_en_mux_x1[0] : 1'bz);

    assign xcvrif_tx_rst_mux_x2[0]     = ((1>=2 && 0<2)? xcvrif_tx_rst_mux_x1[0] : ((1>=2 && 0<4)? xcvrif_tx_rst_mux_x1[2] : ((1>=2 && 0<6)? xcvrif_tx_rst_mux_x1[4] : ((1>=2 && 0<8)? xcvrif_tx_rst_mux_x1[6] : 1'bz)))) ;
    assign xcvrif_tx_rst_mux_x4[0]     = ((1>=3 && 0<=3)? xcvrif_tx_rst_mux_x1[0] : ((1==8)? xcvrif_tx_rst_mux_x1[4] : 1'bz));
    assign xcvrif_tx_rst_mux_x6_bot[0] = (((1==5 || 1==6) && (0==4 || 0==5))? xcvrif_tx_rst_mux_x1[0] : ((1==8) && (0==6 || 0==7)) ? xcvrif_tx_rst_mux_x1[0] : 1'bz);
    assign xcvrif_tx_rst_mux_x6_top[0] = ((1>=5 && 0<4)? xcvrif_tx_rst_mux_x1[0] : 1'bz);
    assign xcvrif_tx_rst_mux_x8_bot[0] = ((1>=7 && 0>=4)? xcvrif_tx_rst_mux_x1[0] : 1'bz);
    assign xcvrif_tx_rst_mux_x8_top[0] = ((1>=7 && 0<=3)? xcvrif_tx_rst_mux_x1[0] : 1'bz);
    
    assign xcvrif_tx_word_clk_mux_x2[0]     = ((1>=2 && 0<2)? xcvrif_tx_word_clk_mux_x1[0] : ((1>=2 && 0<4)? xcvrif_tx_word_clk_mux_x1[2] : ((1>=2 && 0<6)? xcvrif_tx_word_clk_mux_x1[4] : ((1>=2 && 0<8)? xcvrif_tx_word_clk_mux_x1[6] : 1'bz)))) ;
    assign xcvrif_tx_word_clk_mux_x4[0]     = ((1>=3 && 0<=3)? xcvrif_tx_word_clk_mux_x1[0] : ((1==8)? xcvrif_tx_word_clk_mux_x1[4] : 1'bz));
    assign xcvrif_tx_word_clk_mux_x6_bot[0] = (((1==5 || 1==6) && (0==4 || 0==5))? xcvrif_tx_word_clk_mux_x1[0] : ((1==8) && (0==6 || 0==7)) ? xcvrif_tx_word_clk_mux_x1[0] : 1'bz);
    assign xcvrif_tx_word_clk_mux_x6_top[0] = ((1>=5 && 0<4)? xcvrif_tx_word_clk_mux_x1[0] : 1'bz);
    assign xcvrif_tx_word_clk_mux_x8_bot[0] = ((1>=7 && 0>=4)? xcvrif_tx_word_clk_mux_x1[0] : 1'bz);
    assign xcvrif_tx_word_clk_mux_x8_top[0] = ((1>=7 && 0<=3)? xcvrif_tx_word_clk_mux_x1[0] : 1'bz);   
//1p0 Allignment
    assign xcvrif_tx_rst_wr_sync_mux_x2[0]     = ((1>=2 && 0<2)? xcvrif_tx_rst_wr_sync_mux_x1[0] : ((1>=2 && 0<4)? xcvrif_tx_rst_wr_sync_mux_x1[2] : ((1>=2 && 0<6)? xcvrif_tx_rst_wr_sync_mux_x1[4] : ((1>=2 && 0<8)? xcvrif_tx_rst_wr_sync_mux_x1[6] : 1'bz)))) ;
    assign xcvrif_tx_rst_wr_sync_mux_x4[0]     = ((1>=3 && 0<=3)? xcvrif_tx_rst_wr_sync_mux_x1[0] : ((1==8)? xcvrif_tx_rst_wr_sync_mux_x1[4] : 1'bz));
    assign xcvrif_tx_rst_wr_sync_mux_x6_bot[0] = (((1==5 || 1==6) && (0==4 || 0==5))? xcvrif_tx_rst_wr_sync_mux_x1[0] : ((1==8) && (0==6 || 0==7)) ? xcvrif_tx_rst_wr_sync_mux_x1[0] : 1'bz);
    assign xcvrif_tx_rst_wr_sync_mux_x6_top[0] = ((1>=5 && 0<4)? xcvrif_tx_rst_wr_sync_mux_x1[0] : 1'bz);
    assign xcvrif_tx_rst_wr_sync_mux_x8_bot[0] = ((1>=7 && 0>=4)? xcvrif_tx_rst_wr_sync_mux_x1[0] : 1'bz);
    assign xcvrif_tx_rst_wr_sync_mux_x8_top[0] = ((1>=7 && 0<=3)? xcvrif_tx_rst_wr_sync_mux_x1[0] : 1'bz);


    assign marker_found_up[0]     = 1'bz;
    assign marker_found_dn[0]     = 1'bz;

        assign ioack_synthdiv1_left_ux_bidir_in_reg[0] =   1'bz;
//for KM This offset value need to update
localparam offset = (1 == 6)? 2 : 0;
    
    assign flux_cpi_int_phy_shared_reg = ({1>4}? flux_cpi_int_phy_shared[1] : flux_cpi_int_phy_shared[0]);

    assign q2q_xcvrrc_ux_ux__txstatus_rc_ux[0][3:0] = 4'b0000;
    assign q2q_xcvrrc_ux_ux__txstatus_rc_ux[1][3:0] = 4'b0000;



   alt_mge_phy_0_hal_top_one_lane_hal_2100_n3mbdsq one_lane_inst_0(

    .i_hio_txdata                                   (i_hio_txdata[0*80 +: 80]                  ),
    .i_hio_txdata_extra                             (i_hio_txdata_extra[0*10 +: 10]            ),
    .i_hio_txdata_fifo_wr_en                        (i_hio_txdata_fifo_wr_en[0]                ),
    .i_hio_rxdata_fifo_rd_en                        (i_hio_rxdata_fifo_rd_en[0]                ),
    .i_hio_ptp_rst_n                                (i_hio_ptp_rst_n[0]                        ),
    .i_hio_ehip_rx_rst_n                            (i_hio_ehip_rx_rst_n[0]                    ),
    .i_hio_ehip_tx_rst_n                            (i_hio_ehip_tx_rst_n[0]                    ),
    .i_hio_ehip_signal_ok                           (i_hio_ehip_signal_ok[0]                   ),
    .i_hio_sfreeze_2_r03f_rx_mac_srfz_n             (i_hio_sfreeze_2_r03f_rx_mac_srfz_n[0]     ),
    .i_hio_sfreeze_3_c2f_tx_deskew_srfz_n           (i_hio_sfreeze_3_c2f_tx_deskew_srfz_n[0]   ),
    .i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n             (i_hio_t03f_sfreeze_1_tx_pcs_sfrz_n[0]     ),
    .i_hio_rstfec_fec_rx_rst_n                      (i_hio_rstfec_fec_rx_rst_n[0]              ),
    .i_hio_rstfec_fec_tx_rst_n                      (i_hio_rstfec_fec_tx_rst_n[0]              ),
    .i_hio_rstfec_fec_csr_ret                       (i_hio_rstfec_fec_csr_ret[0]               ),
    .i_hio_rstfec_rx_fec_sfrz_n                     (i_hio_rstfec_rx_fec_sfrz_n[0]             ),
    .i_hio_rstfec_tx_fec_sfrz_n                     (i_hio_rstfec_tx_fec_sfrz_n[0]             ),
    .i_hio_rstxcvrif_xcvrif_rx_rst_n                (i_hio_rstxcvrif_xcvrif_rx_rst_n[0]        ),
    .i_hio_rstxcvrif_xcvrif_tx_rst_n                (i_hio_rstxcvrif_xcvrif_tx_rst_n[0]        ),
    .i_hio_rstxcvrif_xcvrif_signal_ok               (i_hio_rstxcvrif_xcvrif_signal_ok[0]       ),
    .i_hio_rstxcvrif_rx_xcvrif_sfrz_n               (i_hio_rstxcvrif_rx_xcvrif_sfrz_n[0]       ),
    .i_hio_rstxcvrif_tx_xcvrif_sfrz_n               (i_hio_rstxcvrif_tx_xcvrif_sfrz_n[0]       ),
    .i_hio_rst_pld_clrhip                           (i_hio_rst_pld_clrhip[0]                   ),
    .i_hio_rst_pld_clrpcs                           (i_hio_rst_pld_clrpcs[0]                   ),
    .i_hio_rst_pld_perstn                           (i_hio_rst_pld_perstn[0]                   ),
    .i_hio_rst_pld_ready                            (i_hio_rst_pld_ready[0]                    ),
    .i_hio_rst_pld_adapter_rx_pld_rst_n             (i_hio_rst_pld_adapter_rx_pld_rst_n[0]     ),
    .i_hio_rst_pld_adapter_tx_pld_rst_n             (i_hio_rst_pld_adapter_tx_pld_rst_n[0]     ),
    .i_hio_rst_ux_rx_pma_rst_n                      (i_hio_rst_ux_rx_pma_rst_n[0]              ),
    .i_hio_rst_ux_rx_sfrz                           (i_hio_rst_ux_rx_sfrz[0]                   ),
    .i_hio_rst_ux_tx_pma_rst_n                      (i_hio_rst_ux_tx_pma_rst_n[0]              ),
    .i_hio_pld_reset_clk_row                        (i_hio_pld_reset_clk_row[0]                ),
    .i_hio_uxquad_async                             (i_hio_uxquad_async[0*80 +: 80]            ),
    .i_hio_uxquad_async_pcie_mux                    (i_hio_uxquad_async_pcie_mux[0*80 +: 80]   ),

    .i_hio_lavmm_clk                                (i_hio_ch0_lavmm_clk                             ),
    .i_hio_lavmm_rstn                               (i_hio_ch0_lavmm_rstn                            ),
    .i_hio_lavmm_addr                               (i_hio_ch0_lavmm_addr                            ),
    .i_hio_lavmm_be                                 (i_hio_ch0_lavmm_be                              ),
    .i_hio_lavmm_read                               (i_hio_ch0_lavmm_read                            ),
    .i_hio_lavmm_wdata                              (i_hio_ch0_lavmm_wdata                           ),
    .i_hio_lavmm_write                              (i_hio_ch0_lavmm_write                           ),
    .o_hio_lavmm_rdata                              (o_hio_ch0_lavmm_rdata                           ),
    .o_hio_lavmm_rdata_valid                        (o_hio_ch0_lavmm_rdata_valid                     ),
    .o_hio_lavmm_waitreq                            (o_hio_ch0_lavmm_waitreq                         ),
    .i_hio_pld_rx_clk_in_row_clk                    (i_hio_ch0_pld_rx_clk_in_row_clk                 ),
    .i_hio_pld_tx_clk_in_row_clk                    (i_hio_ch0_pld_tx_clk_in_row_clk                 ),
    .i_hio_det_lat_rx_dl_clk                        (i_hio_ch0_det_lat_rx_dl_clk                     ),
    .i_hio_det_lat_rx_mux_select                    (i_hio_ch0_det_lat_rx_mux_select                 ),
    .i_hio_det_lat_rx_sclk_flop                     (i_hio_ch0_det_lat_rx_sclk_flop                  ),
    .i_hio_det_lat_rx_sclk_gen_clk                  (i_hio_ch0_det_lat_rx_sclk_gen_clk               ),
    .i_hio_det_lat_rx_trig_flop                     (i_hio_ch0_det_lat_rx_trig_flop                  ),
    .i_hio_det_lat_sampling_clk                     (i_hio_ch0_det_lat_sampling_clk                  ),
    .i_hio_det_lat_tx_dl_clk                        (i_hio_ch0_det_lat_tx_dl_clk                     ),
    .i_hio_det_lat_tx_mux_select                    (i_hio_ch0_det_lat_tx_mux_select                 ),
    .i_hio_det_lat_tx_sclk_flop                     (i_hio_ch0_det_lat_tx_sclk_flop                  ),
    .i_hio_det_lat_tx_sclk_gen_clk                  (i_hio_ch0_det_lat_tx_sclk_gen_clk               ),
    .i_hio_det_lat_tx_trig_flop                     (i_hio_ch0_det_lat_tx_trig_flop                  ),

    .rx_serial_n                                    (rx_serial_n[0]                            ),
    .rx_serial_p                                    (rx_serial_p[0]                            ),
    //.i_hio_tx_pfc                                   (i_hio_tx_pfc[0]                           ),
    //.i_hio_tx_pause                                 (i_hio_tx_pause[0]                         ),
    //.i_hio_clear_internal                           (i_hio_clear_internal[0]                   ),
    //.i_hio_signal_ok                                (i_hio_signal_ok[0]                        ),
    //.i_hio_pld_ready                                (i_hio_pld_ready[0]                        ),
    //.i_hio_pma_rx_sf                                (i_hio_pma_rx_sf[0]                        ),
    //.i_hio_ch_rstxcvrif_lphy_signal_ok              (i_hio_ch_rstxcvrif_lphy_signal_ok[0]      ),
    //.i_clear_tx_internal_err                        (i_clear_tx_internal_err[0]                ),
    .o_hio_txdata_fifo_wr_empty                     (o_hio_txdata_fifo_wr_empty[0]             ),
    .i_hio_txdata_async                             (i_hio_txdata_async [0*100 +: 100]         ),
    .i_hio_txdata_direct                            (i_hio_txdata_direct[0*10 +: 10]           ),
    .o_hio_rxdata_async                             (o_hio_rxdata_async [0*100 +: 100]         ),
    .o_hio_rxdata_direct                            (o_hio_rxdata_direct[0*10 +: 10]           ),
    .o_hio_txdata_fifo_wr_pempty                    (o_hio_txdata_fifo_wr_pempty[0]            ),
    .o_hio_txdata_fifo_wr_full                      (o_hio_txdata_fifo_wr_full[0]              ),
    .o_hio_txdata_fifo_wr_pfull                     (o_hio_txdata_fifo_wr_pfull[0]             ),
    .o_hio_rxdata                                   (o_hio_rxdata[0*80 +: 80]                  ),
    .o_hio_rxdata_extra                             (o_hio_rxdata_extra[0*10 +: 10]            ),
    .o_hio_rxdata_fifo_rd_empty                     (o_hio_rxdata_fifo_rd_empty[0]             ),
    .o_hio_rxdata_fifo_rd_pempty                    (o_hio_rxdata_fifo_rd_pempty[0]            ),
    .o_hio_rxdata_fifo_rd_full                      (o_hio_rxdata_fifo_rd_full[0]              ),
    .o_hio_rxdata_fifo_rd_pfull                     (o_hio_rxdata_fifo_rd_pfull[0]             ),
    .o_hio_rstepcs_rx_pcs_fully_aligned             (o_hio_rstepcs_rx_pcs_fully_aligned[0]     ),
    .o_hio_rstfec_fec_rx_rdy_n                      (o_hio_rstfec_fec_rx_rdy_n[0]              ),
    .o_hio_rst_flux0_cpi_cmn_busy                   (o_hio_rst_flux0_cpi_cmn_busy[0]           ),
    .o_hio_rst_oflux_rx_srds_rdy                    (o_hio_rst_oflux_rx_srds_rdy[0]            ),
    .o_hio_rst_ux_all_synthlockstatus               (o_hio_rst_ux_all_synthlockstatus[0]       ),
    .o_hio_rst_ux_octl_pcs_rxstatus                 (o_hio_rst_ux_octl_pcs_rxstatus[0]         ),
    .o_hio_rst_ux_octl_pcs_txstatus                 (o_hio_rst_ux_octl_pcs_txstatus[0]         ),
    .o_hio_rst_ux_rxcdrlock2data                    (o_hio_rst_ux_rxcdrlock2data[0]            ),
    .o_hio_rst_ux_rxcdrlockstatus                   (o_hio_rst_ux_rxcdrlockstatus[0]           ),
    .o_hio_uxquad_async                             (o_hio_uxquad_async[0*50 +: 50]            ),
    //.k_user_rx_clk1_c0c1c2_sel                      (k_user_rx_clk1_c0c1c2_sel[0]              ),
    //.k_user_rx_clk2_c0c1c2_sel                      (k_user_rx_clk2_c0c1c2_sel[0]              ),
    //.k_user_tx_clk1_c0c1c2_sel                      (k_user_tx_clk1_c0c1c2_sel[0]              ),
    //.k_user_tx_clk2_c0c1c2_sel                      (k_user_tx_clk2_c0c1c2_sel[0]              ),

    .o_hio_user_rx_clk1_clk                         (o_hio_ch0_user_rx_clk1_clk                      ),
    .o_hio_user_rx_clk2_clk                         (o_hio_ch0_user_rx_clk2_clk                      ),
    .o_hio_user_tx_clk1_clk                         (o_hio_ch0_user_tx_clk1_clk                      ),
    .o_hio_user_tx_clk2_clk                         (o_hio_ch0_user_tx_clk2_clk                      ),
    .o_hio_ux_chnl_refclk_mux                       (o_hio_ch0_ux_chnl_refclk_mux                    ),
    .o_hio_det_lat_rx_async_dl_sync                 (o_hio_ch0_det_lat_rx_async_dl_sync              ),
    .o_hio_det_lat_rx_async_pulse                   (o_hio_ch0_det_lat_rx_async_pulse                ),
    .o_hio_det_lat_rx_async_sample_sync             (o_hio_ch0_det_lat_rx_async_sample_sync          ),
    .o_hio_det_lat_rx_sclk_sample_sync              (o_hio_ch0_det_lat_rx_sclk_sample_sync           ),
    .o_hio_det_lat_rx_trig_sample_sync              (o_hio_ch0_det_lat_rx_trig_sample_sync           ),
    .o_hio_det_lat_tx_async_dl_sync                 (o_hio_ch0_det_lat_tx_async_dl_sync              ),
    .o_hio_det_lat_tx_async_pulse                   (o_hio_ch0_det_lat_tx_async_pulse                ),
    .o_hio_det_lat_tx_async_sample_sync             (o_hio_ch0_det_lat_tx_async_sample_sync          ),
    .o_hio_det_lat_tx_sclk_sample_sync              (o_hio_ch0_det_lat_tx_sclk_sample_sync           ),
    .o_hio_det_lat_tx_trig_sample_sync              (o_hio_ch0_det_lat_tx_trig_sample_sync           ),
    .o_hio_xcvrif_rx_latency_pulse                  (o_hio_ch0_xcvrif_rx_latency_pulse               ),
    .o_hio_xcvrif_tx_latency_pulse                  (o_hio_ch0_xcvrif_tx_latency_pulse               ),

    .tx_serial_p                                    (tx_serial_p[0]                            ),
    .tx_serial_n                                    (tx_serial_n[0]                            ),
   // .o_hio_local_fault                              (o_hio_local_fault[0]                      ),
   // .o_hio_remote_fault                             (o_hio_remote_fault[0]                     ),
   // .o_hio_rx_pause                                 (o_hio_rx_pause[0]                         ),
   // .o_hio_rx_pfc                                   (o_hio_rx_pfc[0]                           ),
   // .o_hio_txfifo_pfull                             (o_hio_txfifo_pfull[0]                     ),
   // .o_hio_dsk_mon_err                              (o_hio_dsk_mon_err[0]                      ),
   // .o_hio_hip_ready                                (o_hio_hip_ready[0]                        ),
   // .o_hio_rx_block_lock                            (o_hio_rx_block_lock[0]                    ),
   // .o_hio_rx_dsk_done                              (o_hio_rx_dsk_done[0]                      ),
   // .o_hio_rx_am_lock                               (o_hio_rx_am_lock[0]                       ),
   // .o_hio_rx_pcs_fully_aligned                     (o_hio_rx_pcs_fully_aligned[0]             ),
   // .o_hio_hi_ber                                   (o_hio_hi_ber[0]                           ),
   // .o_hio_rx_pcs_internal_err                      (o_hio_rx_pcs_internal_err[0]              ),
   // .o_hio_tx_fifo_status_fifo_wr_pfull             (o_hio_tx_fifo_status_fifo_wr_pfull[0]     ),
   // .o_hio_tx_fifo_status_fifo_pempty               (o_hio_tx_fifo_status_fifo_pempty[0]       ),
   // .o_hio_rx_fifo_status_fifo_pempty               (o_hio_rx_fifo_status_fifo_pempty[0]       ),
   // .o_hio_rx_fifo_status_fifo_wr_pfull             (o_hio_rx_fifo_status_fifo_wr_pfull[0]     ),
   // .o_hio_rx_fifo_status_fifo_empty                (o_hio_rx_fifo_status_fifo_empty[0]        ),
   // .o_hio_tx_fifo_status_fifo_empty                (o_hio_tx_fifo_status_fifo_empty[0]        ),
   // .o_hio_rx_fifo_status_gb_restarted              (o_hio_rx_fifo_status_gb_restarted[0]      ),
   // .o_hio_tx_fifo_status_gb_restarted              (o_hio_tx_fifo_status_gb_restarted[0]      ),
    
    .i_uxwrap_bus_in_phy_shared                     (uxwrap_bus_in_phy_shared[0]              ),      //ipfluxtop_uxtop_wrap signals to phy_hal_shared
    .o_uxwrap_bus_out_phy_shared                    (uxwrap_bus_out_phy_shared[0]             ),
    //.o_flux_sclk_mux_phy_shared                   (flux_sclk_mux_phy_shared[0]              ),      //sm_flux_ingress_signals to phy_hal_shared////not used, should i remove 
    //.i_ss_async_pldif_phy_shared                  (ss_async_pldif_phy_shared[0]             ),      //sm_flux_ingress_signals to phy_hal_shared 
    //.o_ss_async_pldif_phy_shared                    (ss_async_pldif_phy_shared[0]             ),    
    //.i_ss_async_pldif_pcie_mux_phy_shared           (ss_async_pldif_pcie_mux_phy_shared[0]    ),    
    .o_lavmm_addr_phy_shared                        (lavmm_addr_phy_shared[0]                 ),
    .o_lavmm_be_phy_shared                          (lavmm_be_phy_shared[0]                   ),
    .o_lavmm_clk_phy_shared                         (lavmm_clk_phy_shared[0]                  ),
    .o_lavmm_read_phy_shared                        (lavmm_read_phy_shared[0]                 ),
    .o_lavmm_rstn_phy_shared                        (lavmm_rstn_phy_shared[0]                 ),
    .o_lavmm_wdata_phy_shared                       (lavmm_wdata_phy_shared[0]                ),
    .o_lavmm_write_phy_shared                       (lavmm_write_phy_shared[0]                ),
    .i_lavmm_rdata_phy_shared                       (lavmm_rdata_phy_shared[0]                ),
    .i_lavmm_rdata_valid_phy_shared                 (lavmm_rdata_valid_phy_shared[0]          ),
    .i_lavmm_waitreq_phy_shared                     (lavmm_waitreq_phy_shared[0]              ),
//  .i_rxpstate_phy_shared                          (rxpstate_phy_shared[0]                   ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_rxrate_phy_shared                            (rxrate_phy_shared[0]                     ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_rxterm_hiz_ena_phy_shared                    (rxterm_hiz_ena_phy_shared[0]             ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_rxwidth_phy_shared                           (rxwidth_phy_shared[0]                    ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_tstbus_lane_phy_shared                       (tstbus_lane_phy_shared[0]                ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txbeacona_phy_shared                         (txbeacona_phy_shared[0]                  ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txclkdivrate_phy_shared                      (txclkdivrate_phy_shared[0]               ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txdetectrx_reqa_phy_shared                   (txdetectrx_reqa_phy_shared[0]            ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txdrv_levn_phy_shared                        (txdrv_levn_phy_shared[0]                 ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txdrv_levnm1_phy_shared                      (txdrv_levnm1_phy_shared[0]               ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txdrv_levnm2_phy_shared                      (txdrv_levnm2_phy_shared[0]               ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txdrv_levnp1_phy_shared                      (txdrv_levnp1_phy_shared[0]               ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txdrv_slew_phy_shared                        (txdrv_slew_phy_shared[0]                 ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txelecidle_phy_shared                        (txelecidle_phy_shared[0]                 ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txpstate_phy_shared                          (txpstate_phy_shared[0]                   ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txrate_phy_shared                            (txrate_phy_shared[0]                     ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_txwidth_phy_shared                           (txwidth_phy_shared[0]                    ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .o_rxmargin_status_gray_phy_shared              (rxmargin_status_gray_phy_shared[0]       ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to ppcs
//  .i_rst_ux_rx_sfrz_phy_shared                    (rst_ux_rx_sfrz_phy_shared[0]             ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to pldif
//  .o_rst_flux0_cpi_cmn_busy_phy_shared            (rst_flux0_cpi_cmn_busy_phy_shared[0]     ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to pldif
//  .o_rst_oflux_rx_srds_rdy_phy_shared             (rst_oflux_rx_srds_rdy_phy_shared[0]      ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to pldif
//  .o_rst_ux_all_synthlockstatus_phy_shared        (rst_ux_all_synthlockstatus_phy_shared[0] ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's different
//  .o_rst_ux_rxcdrlockstatus_phy_shared            (rst_ux_rxcdrlockstatus_phy_shared[0]     ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's different
//  .o_ock_pcs_cdrfbclk_phy_shared                  (ock_pcs_cdrfbclk_phy_shared[0]           ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's different
//  .o_ock_pcs_ref_phy_shared                       (ock_pcs_ref_phy_shared[0]                ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's different
//  .o_ux_tx_ch_ptr_smpl_phy_shared                 (ux_tx_ch_ptr_smpl_phy_shared[0]          ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's different
    .o_dat_pcs_measlatrndtripbit_phy_shared         (dat_pcs_measlatrndtripbit_phy_shared[0]  ),      ////Navid sheet says to sm_ux_toolbox, but in toolbox it says to fluxcore, so not added in phy_shared. In sujoys, connected to toolbox. Should I add this to physhared
    .o_sclk_return_sel_rx_phy_shared                (sclk_return_sel_rx_phy_shared[0]         ),
    .o_sclk_return_sel_tx_phy_shared                (sclk_return_sel_tx_phy_shared[0]         ),
//  .i_ick_sclk_rx_phy_shared                       (s_i_ick_sclk_rx_phy_shared[0]                ),  ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to pldif
//  .i_ick_sclk_tx_phy_shared                       (ick_sclk_tx_phy_shared[0]                ),      ////Navid sheet says to sm_ux_toolbox, but sujoy's connected to pldif
    .o_ick_sclk_rx_phy_shared                       (s_o_ick_sclk_rx_phy_shared[0]                ),
    .i_sync_common_control_phy_shared               (sync_common_control_phy_shared[0]        ),
    
    .o_ft_rx_sclk_sync_ch_phy_shared                (ft_rx_sclk_sync_ch_phy_shared[0]             ),
    .o_ft_tx_sclk_sync_ch_phy_shared                (ft_tx_sclk_sync_ch_phy_shared[0]            ) ,
    .o_rst_ux_rx_pma_rst_n_phy_shared               (rst_ux_rx_pma_rst_n_phy_shared[0]           ) ,
    .o_rst_ux_tx_pma_rst_n_phy_shared               (rst_ux_tx_pma_rst_n_phy_shared[0]           ) ,
    .o_ick_pcs_txword_phy_shared                    (ick_pcs_txword_phy_shared[0]                ) ,
    .o_tx_dl_ch_bit_phy_shared                      (tx_dl_ch_bit_phy_shared[0]                  ) ,
    .i_dat_pcs_measlatbit_phy_shared                (dat_pcs_measlatbit_phy_shared[0]            ) ,
    .i_ft_rx_async_pulse_ch_phy_shared              (ft_rx_async_pulse_ch_phy_shared[0]          ) ,
    .i_ft_tx_async_pulse_ch_phy_shared              (ft_tx_async_pulse_ch_phy_shared[0]          ) ,
    .i_rx_dl_ch_bit_phy_shared                      (rx_dl_ch_bit_phy_shared[0]                  ) ,
    .i_ux_rxuser1_sel_phy_shared                    (ux_rxuser1_sel_phy_shared[0]                ) ,
    .i_ux_rxuser2_sel_phy_shared                    (ux_rxuser2_sel_phy_shared[0]                ) ,
    .i_ux_txuser1_sel_phy_shared                    (ux_txuser1_sel_phy_shared[0]                ) ,
    .i_ux_txuser2_sel_phy_shared                    (ux_txuser2_sel_phy_shared[0]                ) ,
    .o_octl_pcs_txstatus_a_phy_shared               (octl_pcs_txstatus_a_phy_shared[0]           ) ,
    .i_ictl_pcs_txenable_a_phy_shared               (ictl_pcs_txenable_a_phy_shared[0]           ) ,
    .i_sync_cfg_data_phy_shared                     (sync_cfg_data_phy_shared[0]                 ) ,
    .i_sync_interface_control_phy_shared            (sync_interface_control_phy_shared[0]        ) ,
    .o_tx_data_phy_shared                           (tx_data_phy_shared[0]                       ) ,
    .i_rx_data_phy_shared                           (rx_data_phy_shared[0]                       ) ,
    .o_sm_flux_ingress_phy_shared                   (sm_flux_ingress_phy_shared[0]               ) ,
    .i_sm_flux_egress_phy_shared                    (sm_flux_egress_phy_shared[0]                ) ,
    .i_flux_cpi_int_phy_shared                      (flux_cpi_int_phy_shared_reg                           ),      //only one bit needed
    .i_flux_int_phy_shared                          (flux_int_phy_shared[0]                      ) ,
    .i_oflux_octl_pcs_txptr_smpl_lane_phy_shared    (oflux_octl_pcs_txptr_smpl_lane_phy_shared[0]) ,
    .o_ick_sclk_tx_phy_shared                       (ick_sclk_tx_phy_shared[0]                  ) ,
    .i_flux_srds_rdy_phy_shared                     (flux_srds_rdy_phy_shared[0]                 ) ,
    .i_pcs_rxword_phy_shared                        (pcs_rxword_phy_shared[0]                    ) ,
    .i_pcs_rxpostdiv_phy_shared                     (pcs_rxpostdiv_phy_shared[0]                 ) ,
    .i_ock_pcs_txword_phy_shared                    (ock_pcs_txword_phy_shared[0]                ) ,

    .o_ch_lavmm_fec_addr_fec_wrap                   (ch_lavmm_fec_addr_fec_wrap[0]),
    .o_ch_lavmm_fec_be_fec_wrap                     (ch_lavmm_fec_be_fec_wrap[0]),
    .o_ch_lavmm_fec_clk_fec_wrap                    (ch_lavmm_fec_clk_fec_wrap[0]),
    .o_ch_lavmm_fec_read_fec_wrap                   (ch_lavmm_fec_read_fec_wrap[0]),
    .o_ch_lavmm_fec_rstn_fec_wrap                   (ch_lavmm_fec_rstn_fec_wrap[0]),
    .o_ch_lavmm_fec_wdata_fec_wrap                  (ch_lavmm_fec_wdata_fec_wrap[0]),
    .o_ch_lavmm_fec_write_fec_wrap                  (ch_lavmm_fec_write_fec_wrap[0]),
    .i_ch_lavmm_fec_rdata_fec_wrap                  (ch_lavmm_fec_rdata_fec_wrap[0]),
    .i_ch_lavmm_fec_rdata_valid_fec_wrap            (ch_lavmm_fec_rdata_valid_fec_wrap[0]),
    .i_ch_lavmm_fec_waitreq_fec_wrap                (ch_lavmm_fec_waitreq_fec_wrap[0]),
    .i_ch_eth_fec_rx_async_fec_wrap                 (ch_eth_fec_rx_async_fec_wrap[0]),
    .i_ch_eth_fec_rx_direct_fec_wrap                (ch_eth_fec_rx_direct_fec_wrap[0]),
    .o_ch_eth_fec_tx_async_fec_wrap                 (ch_eth_fec_tx_async_fec_wrap[0]),
    .o_ch_eth_fec_tx_direct_fec_wrap                (ch_eth_fec_tx_direct_fec_wrap[0]),
    .o_rstfec_fec_csr_ret_fec_wrap                  (rstfec_fec_csr_ret_fec_wrap[0]),
    .i_fec_rx_rdy_n_fec_wrap                        (fec_rx_rdy_n_fec_wrap[0]),
    .o_rstfec_fec_rx_rst_n_fec_wrap                 (rstfec_fec_rx_rst_n_fec_wrap[0]),
    .o_rstfec_fec_tx_rst_n_fec_wrap                 (rstfec_fec_tx_rst_n_fec_wrap[0]),
    .o_rstfec_rx_fec_sfrz_n_fec_wrap                (rstfec_rx_fec_sfrz_n_fec_wrap[0]),
    .o_rstfec_tx_fec_sfrz_n_fec_wrap                (rstfec_tx_fec_sfrz_n_fec_wrap[0]),
    .i_fec_tx_data_mux_sel_fec_wrap                 (fec_tx_data_mux_sel_fec_wrap[0]),
    .i_fec_rx_data_fec_wrap                         (fec_rx_data_fec_wrap[0]),
    .o_fec_i_tx_mux_data_fec_wrap                   (fec_i_tx_mux_data_fec_wrap[0]),
    .o_xcvr_rx_data                                 (xcvr_rx_data[0]),
    .i_xcvr_tx_data                                 (xcvr_tx_data[0]),
    .o_pma_rx_sf                                    (pma_rx_sf[0]),

    .i_refclk_tx_p                                  (i_refclk_tx_p   ),
//    .i_refclk_tx_n                                  (i_refclk_tx_n   ),//can derive as negated i_refclk_tx_p
    .i_syspll_c0_clk                                (i_syspll_c0_clk ),
    .i_syspll_c1_clk                                (i_syspll_c1_clk ),
    .i_syspll_c2_clk                                (i_syspll_c2_clk ),
    .i_flux_clk                                     (i_flux_clk_0    ),
    .i_refclk_rx_p                                  (i_refclk_rx_p   ),
//    .i_refclk_rx_n                                  (i_refclk_rx_n   ),

    .i_ux_chnl_refclk_mux_phy_shared                (sm_flux_egress_phy_shared[0][193]),
    .o_xcvrif_tx_fifo_rd_en_mux_x1                  (xcvrif_tx_fifo_rd_en_mux_x1[0]),
    .i_xcvrif_tx_fifo_rd_en_mux_x2                  (xcvrif_tx_fifo_rd_en_mux_x2[0]),
    .i_xcvrif_tx_fifo_rd_en_mux_x4                  (xcvrif_tx_fifo_rd_en_mux_x4[0]),
    .i_xcvrif_tx_fifo_rd_en_mux_x6_bot              (xcvrif_tx_fifo_rd_en_mux_x6_bot[0]),
    .i_xcvrif_tx_fifo_rd_en_mux_x6_top              (xcvrif_tx_fifo_rd_en_mux_x6_top[0]),
    .i_xcvrif_tx_fifo_rd_en_mux_x8_bot              (xcvrif_tx_fifo_rd_en_mux_x8_bot[0]),
    .i_xcvrif_tx_fifo_rd_en_mux_x8_top              (xcvrif_tx_fifo_rd_en_mux_x8_top[0]),
    .o_xcvrif_tx_rst_mux_x1                         (xcvrif_tx_rst_mux_x1[0]),
    .i_xcvrif_tx_rst_mux_x2                         (xcvrif_tx_rst_mux_x2[0]),
    .i_xcvrif_tx_rst_mux_x4                         (xcvrif_tx_rst_mux_x4[0]),
    .i_xcvrif_tx_rst_mux_x6_bot                     (xcvrif_tx_rst_mux_x6_bot[0]),
    .i_xcvrif_tx_rst_mux_x6_top                     (xcvrif_tx_rst_mux_x6_top[0]),
    .i_xcvrif_tx_rst_mux_x8_bot                     (xcvrif_tx_rst_mux_x8_bot[0]),
    .i_xcvrif_tx_rst_mux_x8_top                     (xcvrif_tx_rst_mux_x8_top[0]),
    .o_xcvrif_tx_word_clk_mux_x1                    (xcvrif_tx_word_clk_mux_x1[0]),
    .i_xcvrif_tx_word_clk_mux_x2                    (xcvrif_tx_word_clk_mux_x2[0]),
    .i_xcvrif_tx_word_clk_mux_x4                    (xcvrif_tx_word_clk_mux_x4[0]),
    .i_xcvrif_tx_word_clk_mux_x6_bot                (xcvrif_tx_word_clk_mux_x6_bot[0]),
    .i_xcvrif_tx_word_clk_mux_x6_top                (xcvrif_tx_word_clk_mux_x6_top[0]),
    .i_xcvrif_tx_word_clk_mux_x8_bot                (xcvrif_tx_word_clk_mux_x8_bot[0]),
    .i_xcvrif_tx_word_clk_mux_x8_top                (xcvrif_tx_word_clk_mux_x8_top[0]),
    .ioack_cdrdiv_left_ux_bidir_in                  (),
    .ioack_synthdiv1_left_ux_bidir_in               (ioack_synthdiv1_left_ux_bidir_in_reg[0]),
    .ioack_synthdiv2_left_ux_bidir_in               (),
    .ioack_cdrdiv_left_ux_bidir_out                 (ioack_cdrdiv_left_ux_bidir_out[0]),
    .ioack_synthdiv1_left_ux_bidir_out              (ioack_synthdiv1_left_ux_bidir_out_reg[0]),
    .ioack_synthdiv2_left_ux_bidir_out              (),
    .i_marker_found_up                              (marker_found_up[0]),
    .i_marker_found_dn                              (marker_found_dn[0]),
    .o_marker_found                                 (marker_found[0]),
    .o_xcvrif_tx_rst_wr_sync_mux_x1                 (xcvrif_tx_rst_wr_sync_mux_x1[0]),
    .i_xcvrif_tx_rst_wr_sync_mux_x2                 (xcvrif_tx_rst_wr_sync_mux_x2[0]),
    .i_xcvrif_tx_rst_wr_sync_mux_x4                 (xcvrif_tx_rst_wr_sync_mux_x4[0]),
    .i_xcvrif_tx_rst_wr_sync_mux_x6_bot             (xcvrif_tx_rst_wr_sync_mux_x6_bot[0]),
    .i_xcvrif_tx_rst_wr_sync_mux_x6_top             (xcvrif_tx_rst_wr_sync_mux_x6_top[0]),
    .i_xcvrif_tx_rst_wr_sync_mux_x8_bot             (xcvrif_tx_rst_wr_sync_mux_x8_bot[0]),
    .i_xcvrif_tx_rst_wr_sync_mux_x8_top             (xcvrif_tx_rst_wr_sync_mux_x8_top[0]),
    .o_ptp_rx_data_shared_ptp                       (ptp_rx_data_shared_ptp[0]),
    .o_ptp_tx_intfc_ptp_data_shared_ptp             (ptp_tx_intfc_ptp_data_shared_ptp[0]),
    .o_ptp_tx_data_ld_shared_ptp                    (ptp_tx_data_ld_shared_ptp[0]),
    .o_ptp_tx_wa_ld_shared_ptp                      (ptp_tx_wa_ld_shared_ptp[0]),
    .i_ptp_cfg_tx_asm_ch1_shared_ptp                (ptp_cfg_tx_asm_ch1_shared_ptp[0]),
    .i_ptp_cfg_tx_p2p_ch1_shared_ptp                (ptp_cfg_tx_p2p_ch1_shared_ptp[0]),
    .i_ingress1_ptp_rx_intfc_ptp_data_shared_ptp    (ingress1_ptp_rx_intfc_ptp_data_shared_ptp[0]),
    .i_egress1_ptp_tx_data_shared_ptp               (egress1_ptp_tx_data_shared_ptp[0]),
    .i_egress1_ptp_tx_data_ld_shared_ptp            (egress1_ptp_tx_data_ld_shared_ptp[0]),
    .i_ch1_ptp_mas_word_align_shared_ptp            (ch1_ptp_mas_word_align_shared_ptp[0]),
    .i_egress1_ptp_tx_wa_ld_shared_ptp              (egress1_ptp_tx_wa_ld_shared_ptp[0]),
    .i_ingress1_ptp_rx_dsk_marker_shared_ptp        (ingress1_ptp_rx_dsk_marker_shared_ptp[0]),
    .i_ptp_ptpi_link_shared_ptp                     (ptp_ptpi_link_shared_ptp[0]),
    .o_ptp_rx_data_mux_0_shared_ptp                 (ptp_rx_data_mux_0_shared_ptp[0]),
    .o_ptp_rx_data_mux_1_shared_ptp                 (ptp_rx_data_mux_1_shared_ptp[0]),
    .i_sm_pld_tx_demux_0_i_eth_shared_ptp           (sm_pld_tx_demux_0_o_eth_shared_ptp[0]),
    .o_ptp_clk_shared_ptp                           (ptp_clk_shared_ptp[0])
  );


shared_hal_coreip
#(
    .ch0_duplex_mode_atom               (ch0_quad0_duplex_mode_atom       ),      
    .ch0_fec_spec_atom                  (ch0_quad0_fec_spec_atom          ),  
    .ch0_fracture_atom                  (ch0_quad0_fracture_atom          ),  
    .ch0_dr_enabled_atom                (ch0_quad0_dr_enabled_atom        ),  
    .ch0_sup_mode_atom                  (ch0_quad0_sup_mode_atom          ),  
`ifdef ALTERA_RESERVED_QIS
    .ch0_sim_mode_atom                  ("CH0_SIM_MODE_DISABLE"     ),
    .ch1_sim_mode_atom                  ("CH1_SIM_MODE_DISABLE"     ),
    .ch2_sim_mode_atom                  ("CH2_SIM_MODE_DISABLE"     ),
    .ch3_sim_mode_atom                  ("CH3_SIM_MODE_DISABLE"     ),

    .ch0_tx_sim_mode_atom               ("CH0_TX_SIM_MODE_DISABLE"  ),
    .ch0_rx_sim_mode_atom               ("CH0_RX_SIM_MODE_DISABLE"  ),
    .ch1_tx_sim_mode_atom               ("CH1_TX_SIM_MODE_DISABLE"  ),
    .ch1_rx_sim_mode_atom               ("CH1_RX_SIM_MODE_DISABLE"  ),
    .ch2_tx_sim_mode_atom               ("CH2_TX_SIM_MODE_DISABLE"  ),
    .ch2_rx_sim_mode_atom               ("CH2_RX_SIM_MODE_DISABLE"  ),
    .ch3_tx_sim_mode_atom               ("CH3_TX_SIM_MODE_DISABLE"  ),
    .ch3_rx_sim_mode_atom               ("CH3_RX_SIM_MODE_DISABLE"  ),  
    
    .ch0_flux_mode_atom                 ("CH0_FLUX_MODE_FLUX_MODE_SNIFFER"          ),
    .ch1_flux_mode_atom                 ("CH1_FLUX_MODE_FLUX_MODE_SNIFFER"          ),
    .ch2_flux_mode_atom                 ("CH2_FLUX_MODE_FLUX_MODE_SNIFFER"          ),
    .ch3_flux_mode_atom                 ("CH3_FLUX_MODE_FLUX_MODE_SNIFFER"          ),  
`else   
    .ch0_sim_mode_atom                  (ch0_quad0_sim_mode_atom          ),
    .ch1_sim_mode_atom                  (ch1_quad0_sim_mode_atom          ),
    .ch2_sim_mode_atom                  (ch2_quad0_sim_mode_atom          ),  
    .ch3_sim_mode_atom                  (ch3_quad0_sim_mode_atom          ), 
                                             
    .ch0_tx_sim_mode_atom               (ch0_quad0_tx_sim_mode_atom       ),
    .ch0_rx_sim_mode_atom               (ch0_quad0_rx_sim_mode_atom       ),
    .ch1_tx_sim_mode_atom               (ch1_quad0_tx_sim_mode_atom       ),
    .ch1_rx_sim_mode_atom               (ch1_quad0_rx_sim_mode_atom       ),
    .ch2_tx_sim_mode_atom               (ch2_quad0_tx_sim_mode_atom       ),
    .ch2_rx_sim_mode_atom               (ch2_quad0_rx_sim_mode_atom       ),
    .ch3_tx_sim_mode_atom               (ch3_quad0_tx_sim_mode_atom       ),
    .ch3_rx_sim_mode_atom               (ch3_quad0_rx_sim_mode_atom       ),

    .ch0_flux_mode_atom                 (ch0_quad0_flux_mode_atom         ),
    .ch1_flux_mode_atom                 (ch1_quad0_flux_mode_atom         ),
    .ch2_flux_mode_atom                 (ch2_quad0_flux_mode_atom         ),
    .ch3_flux_mode_atom                 (ch3_quad0_flux_mode_atom         ),
    
`endif                                       
    .ch1_duplex_mode_atom               (ch1_quad0_duplex_mode_atom       ),  
    .ch1_fec_spec_atom                  (ch1_quad0_fec_spec_atom          ),  
    .ch1_fracture_atom                  (ch1_quad0_fracture_atom          ),  
    .ch1_dr_enabled_atom                (ch1_quad0_dr_enabled_atom        ),  
    .ch1_sup_mode_atom                  (ch1_quad0_sup_mode_atom          ),  
    .ch2_duplex_mode_atom               (ch2_quad0_duplex_mode_atom       ),  
    .ch2_fec_spec_atom                  (ch2_quad0_fec_spec_atom          ),  
    .ch2_fracture_atom                  (ch2_quad0_fracture_atom          ),  
    .ch2_dr_enabled_atom                (ch2_quad0_dr_enabled_atom        ),  
    .ch2_sup_mode_atom                  (ch2_quad0_sup_mode_atom          ),  
    .ch3_duplex_mode_atom               (ch3_quad0_duplex_mode_atom       ),  
    .ch3_fec_spec_atom                  (ch3_quad0_fec_spec_atom          ),  
    .ch3_fracture_atom                  (ch3_quad0_fracture_atom          ),  
    .ch3_dr_enabled_atom                (ch3_quad0_dr_enabled_atom        ),  
    .ch3_sup_mode_atom                  (ch3_quad0_sup_mode_atom          ),  
    .ch0_pcs_l_tx_en_atom               (ch0_quad0_pcs_l_tx_en_atom       ),  
    .ch0_pcs_l_rx_en_atom               (ch0_quad0_pcs_l_rx_en_atom       ),  
    .ch0_fec_loopback_mode_atom         (ch0_quad0_fec_loopback_mode_atom ),  
    .ch0_fec_dyn_tx_mux_atom            (ch0_quad0_fec_dyn_tx_mux_atom    ),  
    .ch0_fec_error_atom                 (ch0_quad0_fec_error_atom         ),  
    .ch0_fec_rx_en_atom                 (ch0_quad0_fec_rx_en_atom         ),  
    .ch0_fec_tx_en_atom                 (ch0_quad0_fec_tx_en_atom         ),  
    .ch0_fec_mode_atom                  (ch0_quad0_fec_mode_atom          ),  
    .ch1_pcs_l_tx_en_atom               (ch1_quad0_pcs_l_tx_en_atom       ),  
    .ch1_pcs_l_rx_en_atom               (ch1_quad0_pcs_l_rx_en_atom       ),  
    .ch1_fec_loopback_mode_atom         (ch1_quad0_fec_loopback_mode_atom ),  
    .ch1_fec_dyn_tx_mux_atom            (ch1_quad0_fec_dyn_tx_mux_atom    ),  
    .ch1_fec_error_atom                 (ch1_quad0_fec_error_atom         ),  
    .ch1_fec_rx_en_atom                 (ch1_quad0_fec_rx_en_atom         ),  
    .ch1_fec_tx_en_atom                 (ch1_quad0_fec_tx_en_atom         ),  
    .ch1_fec_mode_atom                  (ch1_quad0_fec_mode_atom          ),  
    .ch2_pcs_l_tx_en_atom               (ch2_quad0_pcs_l_tx_en_atom       ),  
    .ch2_pcs_l_rx_en_atom               (ch2_quad0_pcs_l_rx_en_atom       ),  
    .ch2_fec_loopback_mode_atom         (ch2_quad0_fec_loopback_mode_atom ),  
    .ch2_fec_dyn_tx_mux_atom            (ch2_quad0_fec_dyn_tx_mux_atom    ),  
    .ch2_fec_error_atom                 (ch2_quad0_fec_error_atom         ),  
    .ch2_fec_rx_en_atom                 (ch2_quad0_fec_rx_en_atom         ),  
    .ch2_fec_tx_en_atom                 (ch2_quad0_fec_tx_en_atom         ),  
    .ch2_fec_mode_atom                  (ch2_quad0_fec_mode_atom          ),  
    .ch3_pcs_l_tx_en_atom               (ch3_quad0_pcs_l_tx_en_atom       ),  
    .ch3_pcs_l_rx_en_atom               (ch3_quad0_pcs_l_rx_en_atom       ),  
    .ch3_fec_loopback_mode_atom         (ch3_quad0_fec_loopback_mode_atom ),  
    .ch3_fec_dyn_tx_mux_atom            (ch3_quad0_fec_dyn_tx_mux_atom    ),  
    .ch3_fec_error_atom                 (ch3_quad0_fec_error_atom         ),  
    .ch3_fec_rx_en_atom                 (ch3_quad0_fec_rx_en_atom         ),  
    .ch3_fec_tx_en_atom                 (ch3_quad0_fec_tx_en_atom         ),  
    .ch3_fec_mode_atom                  (ch3_quad0_fec_mode_atom          ),

    .ch0_xcvr_tx_preloaded_hardware_configs_atom    (ch0_quad0_xcvr_tx_preloaded_hardware_configs_atom ),
    .ch0_xcvr_rx_preloaded_hardware_configs_atom    (ch0_quad0_xcvr_rx_preloaded_hardware_configs_atom ),
    .ch0_lc_postdiv_sel_atom                        (ch0_quad0_lc_postdiv_sel_atom                     ),
    .ch0_sequencer_reg_en_atom                      (ch0_quad0_sequencer_reg_en_atom                   ),
    .ch0_rst_mux_static_sel_atom                    (ch0_quad0_rst_mux_static_sel_atom                 ),
    .ch0_xcvr_tx_prbs_pattern_atom                  (ch0_quad0_xcvr_tx_prbs_pattern_atom               ),
    .ch0_xcvr_rx_prbs_pattern_atom                  (ch0_quad0_xcvr_rx_prbs_pattern_atom               ),
    .ch0_xcvr_tx_user_clk_only_mode_atom            (ch0_quad0_xcvr_tx_user_clk_only_mode_atom         ),
    .ch0_xcvr_tx_width_atom                         (ch0_quad0_xcvr_tx_width_atom                      ),
    .ch0_xcvr_rx_width_atom                         (ch0_quad0_xcvr_rx_width_atom                      ),
    .ch0_phy_loopback_mode_atom                     (ch0_quad0_phy_loopback_mode_atom                  ),
    .ch0_tx_dl_enable_atom                          (ch0_quad0_tx_dl_enable_atom                       ),
    .ch0_rx_dl_enable_atom                          (ch0_quad0_rx_dl_enable_atom                       ),
    .ch0_rx_fec_type_used_atom                      (ch0_quad0_rx_fec_type_used_atom                   ),
    .ch0_xcvr_rx_prbs_monitor_en_atom               (ch0_quad0_xcvr_rx_prbs_monitor_en_atom            ),
    .ch0_tx_prbs_gen_en_atom                        (ch0_quad0_tx_prbs_gen_en_atom                     ),
    .ch0_rx_user1_clk_mux_dynamic_sel_atom          (ch0_quad0_rx_user1_clk_mux_dynamic_sel_atom       ),
    .ch0_rx_user2_clk_mux_dynamic_sel_atom          (ch0_quad0_rx_user2_clk_mux_dynamic_sel_atom       ),
    .ch0_tx_user1_clk_mux_dynamic_sel_atom          (ch0_quad0_tx_user1_clk_mux_dynamic_sel_atom       ),
    .ch0_tx_user2_clk_mux_dynamic_sel_atom          (ch0_quad0_tx_user2_clk_mux_dynamic_sel_atom       ),
    .ch0_xcvr_rx_protocol_hint_atom                 (ch0_quad0_xcvr_rx_protocol_hint_atom              ),
    .ch0_pcie_mode_atom                             (ch0_quad0_pcie_mode_atom                          ),
    .ch1_xcvr_tx_preloaded_hardware_configs_atom    (ch1_quad0_xcvr_tx_preloaded_hardware_configs_atom ),
    .ch1_xcvr_rx_preloaded_hardware_configs_atom    (ch1_quad0_xcvr_rx_preloaded_hardware_configs_atom ),
    .ch1_lc_postdiv_sel_atom                        (ch1_quad0_lc_postdiv_sel_atom                     ),
    .ch1_sequencer_reg_en_atom                      (ch1_quad0_sequencer_reg_en_atom                   ),
    .ch1_rst_mux_static_sel_atom                    (ch1_quad0_rst_mux_static_sel_atom                 ),
    .ch1_xcvr_tx_prbs_pattern_atom                  (ch1_quad0_xcvr_tx_prbs_pattern_atom               ),
    .ch1_xcvr_rx_prbs_pattern_atom                  (ch1_quad0_xcvr_rx_prbs_pattern_atom               ),
    .ch1_xcvr_tx_user_clk_only_mode_atom            (ch1_quad0_xcvr_tx_user_clk_only_mode_atom         ),
    .ch1_xcvr_tx_width_atom                         (ch1_quad0_xcvr_tx_width_atom                      ),
    .ch1_xcvr_rx_width_atom                         (ch1_quad0_xcvr_rx_width_atom                      ),
    .ch1_phy_loopback_mode_atom                     (ch1_quad0_phy_loopback_mode_atom                  ),
    .ch1_tx_dl_enable_atom                          (ch1_quad0_tx_dl_enable_atom                       ),
    .ch1_rx_dl_enable_atom                          (ch1_quad0_rx_dl_enable_atom                       ),
    .ch1_rx_fec_type_used_atom                      (ch1_quad0_rx_fec_type_used_atom                   ),
    .ch1_xcvr_rx_prbs_monitor_en_atom               (ch1_quad0_xcvr_rx_prbs_monitor_en_atom            ),
    .ch1_tx_prbs_gen_en_atom                        (ch1_quad0_tx_prbs_gen_en_atom                     ),
    .ch1_rx_user1_clk_mux_dynamic_sel_atom          (ch1_quad0_rx_user1_clk_mux_dynamic_sel_atom       ),
    .ch1_rx_user2_clk_mux_dynamic_sel_atom          (ch1_quad0_rx_user2_clk_mux_dynamic_sel_atom       ),
    .ch1_tx_user1_clk_mux_dynamic_sel_atom          (ch1_quad0_tx_user1_clk_mux_dynamic_sel_atom       ),
    .ch1_tx_user2_clk_mux_dynamic_sel_atom          (ch1_quad0_tx_user2_clk_mux_dynamic_sel_atom       ),
    .ch1_xcvr_rx_protocol_hint_atom                 (ch1_quad0_xcvr_rx_protocol_hint_atom              ),
    .ch1_pcie_mode_atom                             (ch1_quad0_pcie_mode_atom                          ),
    .ch2_xcvr_tx_preloaded_hardware_configs_atom    (ch2_quad0_xcvr_tx_preloaded_hardware_configs_atom ),
    .ch2_xcvr_rx_preloaded_hardware_configs_atom    (ch2_quad0_xcvr_rx_preloaded_hardware_configs_atom ),
    .ch2_lc_postdiv_sel_atom                        (ch2_quad0_lc_postdiv_sel_atom                     ),
    .ch2_sequencer_reg_en_atom                      (ch2_quad0_sequencer_reg_en_atom                   ),
    .ch2_rst_mux_static_sel_atom                    (ch2_quad0_rst_mux_static_sel_atom                 ),
    .ch2_xcvr_tx_prbs_pattern_atom                  (ch2_quad0_xcvr_tx_prbs_pattern_atom               ),
    .ch2_xcvr_rx_prbs_pattern_atom                  (ch2_quad0_xcvr_rx_prbs_pattern_atom               ),
    .ch2_xcvr_tx_user_clk_only_mode_atom            (ch2_quad0_xcvr_tx_user_clk_only_mode_atom         ),
    .ch2_xcvr_tx_width_atom                         (ch2_quad0_xcvr_tx_width_atom                      ),
    .ch2_xcvr_rx_width_atom                         (ch2_quad0_xcvr_rx_width_atom                      ),
    .ch2_phy_loopback_mode_atom                     (ch2_quad0_phy_loopback_mode_atom                  ),
    .ch2_tx_dl_enable_atom                          (ch2_quad0_tx_dl_enable_atom                       ),
    .ch2_rx_dl_enable_atom                          (ch2_quad0_rx_dl_enable_atom                       ),
    .ch2_rx_fec_type_used_atom                      (ch2_quad0_rx_fec_type_used_atom                   ),
    .ch2_xcvr_rx_prbs_monitor_en_atom               (ch2_quad0_xcvr_rx_prbs_monitor_en_atom            ),
    .ch2_tx_prbs_gen_en_atom                        (ch2_quad0_tx_prbs_gen_en_atom                     ),
    .ch2_rx_user1_clk_mux_dynamic_sel_atom          (ch2_quad0_rx_user1_clk_mux_dynamic_sel_atom       ),
    .ch2_rx_user2_clk_mux_dynamic_sel_atom          (ch2_quad0_rx_user2_clk_mux_dynamic_sel_atom       ),
    .ch2_tx_user1_clk_mux_dynamic_sel_atom          (ch2_quad0_tx_user1_clk_mux_dynamic_sel_atom       ),
    .ch2_tx_user2_clk_mux_dynamic_sel_atom          (ch2_quad0_tx_user2_clk_mux_dynamic_sel_atom       ),
    .ch2_xcvr_rx_protocol_hint_atom                 (ch2_quad0_xcvr_rx_protocol_hint_atom              ),
    .ch2_pcie_mode_atom                             (ch2_quad0_pcie_mode_atom                          ),
    .ch3_xcvr_tx_preloaded_hardware_configs_atom    (ch3_quad0_xcvr_tx_preloaded_hardware_configs_atom ),
    .ch3_xcvr_rx_preloaded_hardware_configs_atom    (ch3_quad0_xcvr_rx_preloaded_hardware_configs_atom ),
    .ch3_lc_postdiv_sel_atom                        (ch3_quad0_lc_postdiv_sel_atom                     ),
    .ch3_sequencer_reg_en_atom                      (ch3_quad0_sequencer_reg_en_atom                   ),
    .ch3_rst_mux_static_sel_atom                    (ch3_quad0_rst_mux_static_sel_atom                 ),
    .ch3_xcvr_tx_prbs_pattern_atom                  (ch3_quad0_xcvr_tx_prbs_pattern_atom               ),
    .ch3_xcvr_rx_prbs_pattern_atom                  (ch3_quad0_xcvr_rx_prbs_pattern_atom               ),
    .ch3_xcvr_tx_user_clk_only_mode_atom            (ch3_quad0_xcvr_tx_user_clk_only_mode_atom         ),
    .ch3_xcvr_tx_width_atom                         (ch3_quad0_xcvr_tx_width_atom                      ),
    .ch3_xcvr_rx_width_atom                         (ch3_quad0_xcvr_rx_width_atom                      ),
    .ch3_phy_loopback_mode_atom                     (ch3_quad0_phy_loopback_mode_atom                  ),
    .ch3_tx_dl_enable_atom                          (ch3_quad0_tx_dl_enable_atom                       ),
    .ch3_rx_dl_enable_atom                          (ch3_quad0_rx_dl_enable_atom                       ),
    .ch3_rx_fec_type_used_atom                      (ch3_quad0_rx_fec_type_used_atom                   ),
    .ch3_xcvr_rx_prbs_monitor_en_atom               (ch3_quad0_xcvr_rx_prbs_monitor_en_atom            ),
    .ch3_tx_prbs_gen_en_atom                        (ch3_quad0_tx_prbs_gen_en_atom                     ),
    .ch3_rx_user1_clk_mux_dynamic_sel_atom          (ch3_quad0_rx_user1_clk_mux_dynamic_sel_atom       ),
    .ch3_rx_user2_clk_mux_dynamic_sel_atom          (ch3_quad0_rx_user2_clk_mux_dynamic_sel_atom       ),
    .ch3_tx_user1_clk_mux_dynamic_sel_atom          (ch3_quad0_tx_user1_clk_mux_dynamic_sel_atom       ),
    .ch3_tx_user2_clk_mux_dynamic_sel_atom          (ch3_quad0_tx_user2_clk_mux_dynamic_sel_atom       ),
    .ch3_xcvr_rx_protocol_hint_atom                 (ch3_quad0_xcvr_rx_protocol_hint_atom              ),
    .ch3_pcie_mode_atom                             (ch3_quad0_pcie_mode_atom                          ),
    .ch0_tx_pll_l_counter_atom                      (ch0_quad0_tx_pll_l_counter_atom           ),
    .ch0_cdr_l_counter_atom                         (ch0_quad0_cdr_l_counter_atom              ),
    .ch0_tx_pll_refclk_select_atom                  (ch0_quad0_tx_pll_refclk_select_atom       ),
    .ch0_cdr_refclk_select_atom                     (ch0_quad0_cdr_refclk_select_atom          ),
    .ch1_tx_pll_l_counter_atom                      (ch1_quad0_tx_pll_l_counter_atom           ),
    .ch1_cdr_l_counter_atom                         (ch1_quad0_cdr_l_counter_atom              ),
    .ch1_tx_pll_refclk_select_atom                  (ch1_quad0_tx_pll_refclk_select_atom       ),
    .ch1_cdr_refclk_select_atom                     (ch1_quad0_cdr_refclk_select_atom          ),
    .ch2_tx_pll_l_counter_atom                      (ch2_quad0_tx_pll_l_counter_atom           ),
    .ch2_cdr_l_counter_atom                         (ch2_quad0_cdr_l_counter_atom              ),
    .ch2_tx_pll_refclk_select_atom                  (ch2_quad0_tx_pll_refclk_select_atom       ),
    .ch2_cdr_refclk_select_atom                     (ch2_quad0_cdr_refclk_select_atom          ),
    .ch3_tx_pll_l_counter_atom                      (ch3_quad0_tx_pll_l_counter_atom           ),
    .ch3_cdr_l_counter_atom                         (ch3_quad0_cdr_l_counter_atom              ),
    .ch3_tx_pll_refclk_select_atom                  (ch3_quad0_tx_pll_refclk_select_atom       ),
    .ch3_cdr_refclk_select_atom                     (ch3_quad0_cdr_refclk_select_atom          ),
    .ch0_rx_dl_rx_lat_bit_for_async_atom            (ch0_quad0_rx_dl_rx_lat_bit_for_async_atom ),
    .ch0_rx_dl_rxbit_cntr_pma_atom                  (ch0_quad0_rx_dl_rxbit_cntr_pma_atom       ),
    .ch0_rx_dl_rxbit_rollover_atom                  (ch0_quad0_rx_dl_rxbit_rollover_atom       ),
    .ch1_rx_dl_rx_lat_bit_for_async_atom            (ch1_quad0_rx_dl_rx_lat_bit_for_async_atom ),
    .ch1_rx_dl_rxbit_cntr_pma_atom                  (ch1_quad0_rx_dl_rxbit_cntr_pma_atom       ),
    .ch1_rx_dl_rxbit_rollover_atom                  (ch1_quad0_rx_dl_rxbit_rollover_atom       ),
    .ch2_rx_dl_rx_lat_bit_for_async_atom            (ch2_quad0_rx_dl_rx_lat_bit_for_async_atom ),
    .ch2_rx_dl_rxbit_cntr_pma_atom                  (ch2_quad0_rx_dl_rxbit_cntr_pma_atom       ),
    .ch2_rx_dl_rxbit_rollover_atom                  (ch2_quad0_rx_dl_rxbit_rollover_atom       ),
    .ch3_rx_dl_rx_lat_bit_for_async_atom            (ch3_quad0_rx_dl_rx_lat_bit_for_async_atom ),
    .ch3_rx_dl_rxbit_cntr_pma_atom                  (ch3_quad0_rx_dl_rxbit_cntr_pma_atom       ),
    .ch3_rx_dl_rxbit_rollover_atom                  (ch3_quad0_rx_dl_rxbit_rollover_atom       ), 
    .ch0_tx_bonding_category_atom                   (ch0_quad0_tx_bonding_category_atom        ), 
    .ch1_tx_bonding_category_atom                   (ch1_quad0_tx_bonding_category_atom        ), 
    .ch2_tx_bonding_category_atom                   (ch2_quad0_tx_bonding_category_atom        ), 
    .ch3_tx_bonding_category_atom                   (ch3_quad0_tx_bonding_category_atom        ), 
    .ch0_tx_bond_size_atom                          (ch0_quad0_tx_bond_size_atom               ), 
    .ch1_tx_bond_size_atom                          (ch1_quad0_tx_bond_size_atom               ), 
    .ch2_tx_bond_size_atom                          (ch2_quad0_tx_bond_size_atom               ), 
    .ch3_tx_bond_size_atom                          (ch3_quad0_tx_bond_size_atom               ),
    .ch0_clkrx_refclk_cssm_fw_control_atom               (ch0_quad0_clkrx_refclk_cssm_fw_control_atom               ),
    .ch1_clkrx_refclk_cssm_fw_control_atom               (ch1_quad0_clkrx_refclk_cssm_fw_control_atom               ),
    .ch2_clkrx_refclk_cssm_fw_control_atom               (ch2_quad0_clkrx_refclk_cssm_fw_control_atom               ),
    .ch3_clkrx_refclk_cssm_fw_control_atom               (ch3_quad0_clkrx_refclk_cssm_fw_control_atom               ),
    .ch0_clkrx_refclk_sector_specifies_refclk_ready_atom (ch0_quad0_clkrx_refclk_sector_specifies_refclk_ready_atom ),
    .ch1_clkrx_refclk_sector_specifies_refclk_ready_atom (ch1_quad0_clkrx_refclk_sector_specifies_refclk_ready_atom ),
    .ch2_clkrx_refclk_sector_specifies_refclk_ready_atom (ch2_quad0_clkrx_refclk_sector_specifies_refclk_ready_atom ),
    .ch3_clkrx_refclk_sector_specifies_refclk_ready_atom (ch3_quad0_clkrx_refclk_sector_specifies_refclk_ready_atom ),
    .ch0_local_refclk_cssm_fw_control_atom               (ch0_quad0_local_refclk_cssm_fw_control_atom               ),
    .ch1_local_refclk_cssm_fw_control_atom               (ch1_quad0_local_refclk_cssm_fw_control_atom               ),
    .ch2_local_refclk_cssm_fw_control_atom               (ch2_quad0_local_refclk_cssm_fw_control_atom               ),
    .ch3_local_refclk_cssm_fw_control_atom               (ch3_quad0_local_refclk_cssm_fw_control_atom               ),
    .ch0_local_refclk_sector_specifies_refclk_ready_atom (ch0_quad0_local_refclk_sector_specifies_refclk_ready_atom ),
    .ch1_local_refclk_sector_specifies_refclk_ready_atom (ch1_quad0_local_refclk_sector_specifies_refclk_ready_atom ),
    .ch2_local_refclk_sector_specifies_refclk_ready_atom (ch2_quad0_local_refclk_sector_specifies_refclk_ready_atom ),
    .ch3_local_refclk_sector_specifies_refclk_ready_atom (ch3_quad0_local_refclk_sector_specifies_refclk_ready_atom ),
    .num_of_lanes                                        (num_of_lanes)
)
shared_hal_coreip_inst_0(
    .i_fec_wrap_ch0_tx_mux_data     (fec_i_tx_mux_data_fec_wrap[{0*4} + 0 + {0*offset}]       ),
    .i_fec_wrap_ch1_tx_mux_data     (fec_i_tx_mux_data_fec_wrap[{0*4} + 1 + {0*offset}]       ),
    .i_fec_wrap_ch2_tx_mux_data     (fec_i_tx_mux_data_fec_wrap[{0*4} + 2 - {0*offset}]       ),
    .i_fec_wrap_ch3_tx_mux_data     (fec_i_tx_mux_data_fec_wrap[{0*4} + 3 - {0*offset}]       ),
    .o_fec_ch0_rx_data              (fec_rx_data_fec_wrap[{0*4} + 0 + {0*offset}]             ),
    .o_fec_ch1_rx_data              (fec_rx_data_fec_wrap[{0*4} + 1 + {0*offset}]             ),
    .o_fec_ch2_rx_data              (fec_rx_data_fec_wrap[{0*4} + 2 - {0*offset}]             ),
    .o_fec_ch3_rx_data              (fec_rx_data_fec_wrap[{0*4} + 3 - {0*offset}]             ),
    .i_xcvr_ch0_rx_data             (xcvr_rx_data[{0*4} + 0 + {0*offset}]                     ),
    .i_xcvr_ch1_rx_data             (xcvr_rx_data[{0*4} + 1 + {0*offset}]                     ),
    .i_xcvr_ch2_rx_data             (xcvr_rx_data[{0*4} + 2 - {0*offset}]                     ),
    .i_xcvr_ch3_rx_data             (xcvr_rx_data[{0*4} + 3 - {0*offset}]                     ),
    .o_xcvr_ch0_tx_data             (xcvr_tx_data[{0*4} + 0 + {0*offset}]                     ),
    .o_xcvr_ch1_tx_data             (xcvr_tx_data[{0*4} + 1 + {0*offset}]                     ),
    .o_xcvr_ch2_tx_data             (xcvr_tx_data[{0*4} + 2 - {0*offset}]                     ),
    .o_xcvr_ch3_tx_data             (xcvr_tx_data[{0*4} + 3 - {0*offset}]                     ),
    .i_fec_clk                      (i_syspll_c0_clk                                                          ),
    .o_fec_tx_data_mux_sel_ch0      (fec_tx_data_mux_sel_fec_wrap[{0*4} + 0 + {0*offset}]     ),
    .o_fec_tx_data_mux_sel_ch1      (fec_tx_data_mux_sel_fec_wrap[{0*4} + 1 + {0*offset}]     ),
    .o_fec_tx_data_mux_sel_ch2      (fec_tx_data_mux_sel_fec_wrap[{0*4} + 2 - {0*offset}]     ),
    .o_fec_tx_data_mux_sel_ch3      (fec_tx_data_mux_sel_fec_wrap[{0*4} + 3 - {0*offset}]     ),
    .o_ch0_lavmm_fec_rdata          (ch_lavmm_fec_rdata_fec_wrap[{0*4} + 0 + {0*offset}]      ),
    .o_ch0_lavmm_fec_rdata_valid    (ch_lavmm_fec_rdata_valid_fec_wrap[{0*4} + 0 + {0*offset}]),
    .o_ch0_lavmm_fec_waitreq        (ch_lavmm_fec_waitreq_fec_wrap[{0*4} + 0 + {0*offset}]    ),
    .i_ch0_lavmm_fec_addr           (ch_lavmm_fec_addr_fec_wrap[{0*4} + 0 + {0*offset}]       ),
    .i_ch0_lavmm_fec_be             (ch_lavmm_fec_be_fec_wrap[{0*4} + 0 + {0*offset}]         ),
    .i_ch0_lavmm_fec_clk            (ch_lavmm_fec_clk_fec_wrap[{0*4} + 0 + {0*offset}]        ),
    .i_ch0_lavmm_fec_read           (ch_lavmm_fec_read_fec_wrap[{0*4} + 0 + {0*offset}]       ),
    .i_ch0_lavmm_fec_rstn           (ch_lavmm_fec_rstn_fec_wrap[{0*4} + 0 + {0*offset}]       ),
    .i_ch0_lavmm_fec_wdata          (ch_lavmm_fec_wdata_fec_wrap[{0*4} + 0 + {0*offset}]      ),
    .i_ch0_lavmm_fec_write          (ch_lavmm_fec_write_fec_wrap[{0*4} + 0 + {0*offset}]      ),
    .o_ch1_lavmm_fec_rdata          (ch_lavmm_fec_rdata_fec_wrap[{0*4} + 1 + {0*offset}]      ),
    .o_ch1_lavmm_fec_rdata_valid    (ch_lavmm_fec_rdata_valid_fec_wrap[{0*4} + 1 + {0*offset}]),
    .o_ch1_lavmm_fec_waitreq        (ch_lavmm_fec_waitreq_fec_wrap[{0*4} + 1 + {0*offset}]    ),
    .i_ch1_lavmm_fec_addr           (ch_lavmm_fec_addr_fec_wrap[{0*4} + 1 + {0*offset}]       ),
    .i_ch1_lavmm_fec_be             (ch_lavmm_fec_be_fec_wrap[{0*4} + 1 + {0*offset}]         ),
    .i_ch1_lavmm_fec_clk            (ch_lavmm_fec_clk_fec_wrap[{0*4} + 1 + {0*offset}]        ),
    .i_ch1_lavmm_fec_read           (ch_lavmm_fec_read_fec_wrap[{0*4} + 1 + {0*offset}]       ),
    .i_ch1_lavmm_fec_rstn           (ch_lavmm_fec_rstn_fec_wrap[{0*4} + 1 + {0*offset}]       ),
    .i_ch1_lavmm_fec_wdata          (ch_lavmm_fec_wdata_fec_wrap[{0*4} + 1 + {0*offset}]      ),
    .i_ch1_lavmm_fec_write          (ch_lavmm_fec_write_fec_wrap[{0*4} + 1 + {0*offset}]      ),
    .o_ch2_lavmm_fec_rdata          (ch_lavmm_fec_rdata_fec_wrap[{0*4} + 2 - {0*offset}]      ),
    .o_ch2_lavmm_fec_rdata_valid    (ch_lavmm_fec_rdata_valid_fec_wrap[{0*4} + 2 - {0*offset}]),
    .o_ch2_lavmm_fec_waitreq        (ch_lavmm_fec_waitreq_fec_wrap[{0*4} + 2 - {0*offset}]    ),
    .i_ch2_lavmm_fec_addr           (ch_lavmm_fec_addr_fec_wrap[{0*4} + 2 - {0*offset}]       ),
    .i_ch2_lavmm_fec_be             (ch_lavmm_fec_be_fec_wrap[{0*4} + 2 - {0*offset}]         ),
    .i_ch2_lavmm_fec_clk            (ch_lavmm_fec_clk_fec_wrap[{0*4} + 2 - {0*offset}]        ),
    .i_ch2_lavmm_fec_read           (ch_lavmm_fec_read_fec_wrap[{0*4} + 2 - {0*offset}]       ),
    .i_ch2_lavmm_fec_rstn           (ch_lavmm_fec_rstn_fec_wrap[{0*4} + 2 - {0*offset}]       ),
    .i_ch2_lavmm_fec_wdata          (ch_lavmm_fec_wdata_fec_wrap[{0*4} + 2 - {0*offset}]      ),
    .i_ch2_lavmm_fec_write          (ch_lavmm_fec_write_fec_wrap[{0*4} + 2 - {0*offset}]      ),
    .o_ch3_lavmm_fec_rdata          (ch_lavmm_fec_rdata_fec_wrap[{0*4} + 3 - {0*offset}]      ),
    .o_ch3_lavmm_fec_rdata_valid    (ch_lavmm_fec_rdata_valid_fec_wrap[{0*4} + 3 - {0*offset}]),
    .o_ch3_lavmm_fec_waitreq        (ch_lavmm_fec_waitreq_fec_wrap[{0*4} + 3 - {0*offset}]    ),
    .i_ch3_lavmm_fec_addr           (ch_lavmm_fec_addr_fec_wrap[{0*4} + 3 - {0*offset}]       ),
    .i_ch3_lavmm_fec_be             (ch_lavmm_fec_be_fec_wrap[{0*4} + 3 - {0*offset}]         ),
    .i_ch3_lavmm_fec_clk            (ch_lavmm_fec_clk_fec_wrap[{0*4} + 3 - {0*offset}]        ),
    .i_ch3_lavmm_fec_read           (ch_lavmm_fec_read_fec_wrap[{0*4} + 3 - {0*offset}]       ),
    .i_ch3_lavmm_fec_rstn           (ch_lavmm_fec_rstn_fec_wrap[{0*4} + 3 - {0*offset}]       ),
    .i_ch3_lavmm_fec_wdata          (ch_lavmm_fec_wdata_fec_wrap[{0*4} + 3 - {0*offset}]      ),
    .i_ch3_lavmm_fec_write          (ch_lavmm_fec_write_fec_wrap[{0*4} + 3 - {0*offset}]      ),
    .i_ch0_eth_fec_tx_async         (ch_eth_fec_tx_async_fec_wrap[{0*4} + 0 + {0*offset}]     ),
    .i_ch0_eth_fec_tx_direct        (ch_eth_fec_tx_direct_fec_wrap[{0*4} + 0 + {0*offset}]    ),
    .o_ch0_eth_fec_rx_async         (ch_eth_fec_rx_async_fec_wrap[{0*4} + 0 + {0*offset}]     ),
    .o_ch0_eth_fec_rx_direct        (ch_eth_fec_rx_direct_fec_wrap[{0*4} + 0 + {0*offset}]    ),
    .i_ch1_eth_fec_tx_async         (ch_eth_fec_tx_async_fec_wrap[{0*4} + 1 + {0*offset}]     ),
    .i_ch1_eth_fec_tx_direct        (ch_eth_fec_tx_direct_fec_wrap[{0*4} + 1 + {0*offset}]    ),
    .o_ch1_eth_fec_rx_async         (ch_eth_fec_rx_async_fec_wrap[{0*4} + 1 + {0*offset}]     ),
    .o_ch1_eth_fec_rx_direct        (ch_eth_fec_rx_direct_fec_wrap[{0*4} + 1 + {0*offset}]    ),
    .i_ch2_eth_fec_tx_async         (ch_eth_fec_tx_async_fec_wrap[{0*4} + 2 - {0*offset}]     ),
    .i_ch2_eth_fec_tx_direct        (ch_eth_fec_tx_direct_fec_wrap[{0*4} + 2 - {0*offset}]    ),
    .o_ch2_eth_fec_rx_async         (ch_eth_fec_rx_async_fec_wrap[{0*4} + 2 - {0*offset}]     ),
    .o_ch2_eth_fec_rx_direct        (ch_eth_fec_rx_direct_fec_wrap[{0*4} + 2 - {0*offset}]    ),
    .i_ch3_eth_fec_tx_async         (ch_eth_fec_tx_async_fec_wrap[{0*4} + 3 - {0*offset}]     ),
    .i_ch3_eth_fec_tx_direct        (ch_eth_fec_tx_direct_fec_wrap[{0*4} + 3 - {0*offset}]    ),
    .o_ch3_eth_fec_rx_async         (ch_eth_fec_rx_async_fec_wrap[{0*4} + 3 - {0*offset}]     ),
    .o_ch3_eth_fec_rx_direct        (ch_eth_fec_rx_direct_fec_wrap[{0*4} + 3 - {0*offset}]    ),
    .i_ch0_rstfec_fec_csr_ret       (rstfec_fec_csr_ret_fec_wrap[{0*4} + 0 + {0*offset}]      ),
    .o_ch0_fec_rx_rdy_n             (fec_rx_rdy_n_fec_wrap[{0*4} + 0 + {0*offset}]            ),
    .i_ch0_rstfec_fec_rx_rst_n      (rstfec_fec_rx_rst_n_fec_wrap[{0*4} + 0 + {0*offset}]     ),
    .i_ch0_rstfec_fec_tx_rst_n      (rstfec_fec_tx_rst_n_fec_wrap[{0*4} + 0 + {0*offset}]     ),
    .i_ch0_rstfec_rx_fec_sfrz_n     (rstfec_rx_fec_sfrz_n_fec_wrap[{0*4} + 0 + {0*offset}]    ),
    .i_ch0_rstfec_tx_fec_sfrz_n     (rstfec_tx_fec_sfrz_n_fec_wrap[{0*4} + 0 + {0*offset}]    ),
    .i_ch1_rstfec_fec_csr_ret       (rstfec_fec_csr_ret_fec_wrap[{0*4} + 1 + {0*offset}]      ),
    .o_ch1_fec_rx_rdy_n             (fec_rx_rdy_n_fec_wrap[{0*4} + 1 + {0*offset}]            ),
    .i_ch1_rstfec_fec_rx_rst_n      (rstfec_fec_rx_rst_n_fec_wrap[{0*4} + 1 + {0*offset}]     ),
    .i_ch1_rstfec_fec_tx_rst_n      (rstfec_fec_tx_rst_n_fec_wrap[{0*4} + 1 + {0*offset}]     ),
    .i_ch1_rstfec_rx_fec_sfrz_n     (rstfec_rx_fec_sfrz_n_fec_wrap[{0*4} + 1 + {0*offset}]    ),
    .i_ch1_rstfec_tx_fec_sfrz_n     (rstfec_tx_fec_sfrz_n_fec_wrap[{0*4} + 1 + {0*offset}]    ),
    .i_ch2_rstfec_fec_csr_ret       (rstfec_fec_csr_ret_fec_wrap[{0*4} + 2 - {0*offset}]      ),
    .o_ch2_fec_rx_rdy_n             (fec_rx_rdy_n_fec_wrap[{0*4} + 2 - {0*offset}]            ),
    .i_ch2_rstfec_fec_rx_rst_n      (rstfec_fec_rx_rst_n_fec_wrap[{0*4} + 2 - {0*offset}]     ),
    .i_ch2_rstfec_fec_tx_rst_n      (rstfec_fec_tx_rst_n_fec_wrap[{0*4} + 2 - {0*offset}]     ),
    .i_ch2_rstfec_rx_fec_sfrz_n     (rstfec_rx_fec_sfrz_n_fec_wrap[{0*4} + 2 - {0*offset}]    ),
    .i_ch2_rstfec_tx_fec_sfrz_n     (rstfec_tx_fec_sfrz_n_fec_wrap[{0*4} + 2 - {0*offset}]    ),
    .i_ch3_rstfec_fec_csr_ret       (rstfec_fec_csr_ret_fec_wrap[{0*4} + 3 - {0*offset}]      ),
    .o_ch3_fec_rx_rdy_n             (fec_rx_rdy_n_fec_wrap[{0*4} + 3 - {0*offset}]            ),
    .i_ch3_rstfec_fec_rx_rst_n      (rstfec_fec_rx_rst_n_fec_wrap[{0*4} + 3 - {0*offset}]     ),
    .i_ch3_rstfec_fec_tx_rst_n      (rstfec_fec_tx_rst_n_fec_wrap[{0*4} + 3 - {0*offset}]     ),
    .i_ch3_rstfec_rx_fec_sfrz_n     (rstfec_rx_fec_sfrz_n_fec_wrap[{0*4} + 3 - {0*offset}]    ),
    .i_ch3_rstfec_tx_fec_sfrz_n     (rstfec_tx_fec_sfrz_n_fec_wrap[{0*4} + 3 - {0*offset}]    ),
    .i_pma_rx_sf_ch0                (pma_rx_sf[{0*4} + 0 + {0*offset}]                        ),
    .i_pma_rx_sf_ch1                (pma_rx_sf[{0*4} + 1 + {0*offset}]                        ),
    .i_pma_rx_sf_ch2                (pma_rx_sf[{0*4} + 2 - {0*offset}]                        ),
    .i_pma_rx_sf_ch3                (pma_rx_sf[{0*4} + 3 - {0*offset}]                        ),
    
    .i_ch0_lavmm_addr                      (lavmm_addr_phy_shared[{0*4} + 0 + {0*offset}]                     ),
    .i_ch0_lavmm_be                        (lavmm_be_phy_shared[{0*4} + 0 + {0*offset}]                       ),
    .i_ch0_lavmm_clk                       (lavmm_clk_phy_shared[{0*4} + 0 + {0*offset}]                      ),
    .i_ch0_lavmm_read                      (lavmm_read_phy_shared[{0*4} + 0 + {0*offset}]                     ),
    .i_ch0_lavmm_rstn                      (lavmm_rstn_phy_shared[{0*4} + 0 + {0*offset}]                     ),
    .i_ch0_lavmm_wdata                     (lavmm_wdata_phy_shared[{0*4} + 0 + {0*offset}]                    ),
    .i_ch0_lavmm_write                     (lavmm_write_phy_shared[{0*4} + 0 + {0*offset}]                    ),
    .i_ch1_lavmm_addr                      (lavmm_addr_phy_shared[{0*4} + 1 + {0*offset}]                     ),
    .i_ch1_lavmm_be                        (lavmm_be_phy_shared[{0*4} + 1 + {0*offset}]                       ),
    .i_ch1_lavmm_clk                       (lavmm_clk_phy_shared[{0*4} + 1 + {0*offset}]                      ),
    .i_ch1_lavmm_read                      (lavmm_read_phy_shared[{0*4} + 1 + {0*offset}]                     ),
    .i_ch1_lavmm_rstn                      (lavmm_rstn_phy_shared[{0*4} + 1 + {0*offset}]                     ),
    .i_ch1_lavmm_wdata                     (lavmm_wdata_phy_shared[{0*4} + 1 + {0*offset}]                    ),
    .i_ch1_lavmm_write                     (lavmm_write_phy_shared[{0*4} + 1 + {0*offset}]                    ),
    .i_ch2_lavmm_addr                      (lavmm_addr_phy_shared[{0*4} + 2 - {0*offset}]                     ),
    .i_ch2_lavmm_be                        (lavmm_be_phy_shared[{0*4} + 2 - {0*offset}]                       ),
    .i_ch2_lavmm_clk                       (lavmm_clk_phy_shared[{0*4} + 2 - {0*offset}]                      ),
    .i_ch2_lavmm_read                      (lavmm_read_phy_shared[{0*4} + 2 - {0*offset}]                     ),
    .i_ch2_lavmm_rstn                      (lavmm_rstn_phy_shared[{0*4} + 2 - {0*offset}]                     ),
    .i_ch2_lavmm_wdata                     (lavmm_wdata_phy_shared[{0*4} + 2 - {0*offset}]                    ),
    .i_ch2_lavmm_write                     (lavmm_write_phy_shared[{0*4} + 2 - {0*offset}]                    ),
    .i_ch3_lavmm_addr                      (lavmm_addr_phy_shared[{0*4} + 3 - {0*offset}]                     ),
    .i_ch3_lavmm_be                        (lavmm_be_phy_shared[{0*4} + 3 - {0*offset}]                       ),
    .i_ch3_lavmm_clk                       (lavmm_clk_phy_shared[{0*4} + 3 - {0*offset}]                      ),
    .i_ch3_lavmm_read                      (lavmm_read_phy_shared[{0*4} + 3 - {0*offset}]                     ),
    .i_ch3_lavmm_rstn                      (lavmm_rstn_phy_shared[{0*4} + 3 - {0*offset}]                     ),
    .i_ch3_lavmm_wdata                     (lavmm_wdata_phy_shared[{0*4} + 3 - {0*offset}]                    ),
    .i_ch3_lavmm_write                     (lavmm_write_phy_shared[{0*4} + 3 - {0*offset}]                    ),
    .o_ch0_lavmm_rdata                     (lavmm_rdata_phy_shared[{0*4} + 0 + {0*offset}]                    ),
    .o_ch0_lavmm_rdata_valid               (lavmm_rdata_valid_phy_shared[{0*4} + 0 + {0*offset}]              ),
    .o_ch0_lavmm_waitreq                   (lavmm_waitreq_phy_shared[{0*4} + 0 + {0*offset}]                  ),
    .o_ch1_lavmm_rdata                     (lavmm_rdata_phy_shared[{0*4} + 1 + {0*offset}]                    ),
    .o_ch1_lavmm_rdata_valid               (lavmm_rdata_valid_phy_shared[{0*4} + 1 + {0*offset}]              ),
    .o_ch1_lavmm_waitreq                   (lavmm_waitreq_phy_shared[{0*4} + 1 + {0*offset}]                  ),
    .o_ch2_lavmm_rdata                     (lavmm_rdata_phy_shared[{0*4} + 2 - {0*offset}]                    ),
    .o_ch2_lavmm_rdata_valid               (lavmm_rdata_valid_phy_shared[{0*4} + 2 - {0*offset}]              ),
    .o_ch2_lavmm_waitreq                   (lavmm_waitreq_phy_shared[{0*4} + 2 - {0*offset}]                  ),
    .o_ch3_lavmm_rdata                     (lavmm_rdata_phy_shared[{0*4} + 3 - {0*offset}]                    ),
    .o_ch3_lavmm_rdata_valid               (lavmm_rdata_valid_phy_shared[{0*4} + 3 - {0*offset}]              ),
    .o_ch3_lavmm_waitreq                   (lavmm_waitreq_phy_shared[{0*4} + 3 - {0*offset}]                  ),
    .i_dat_pcs_measlatrndtripbit_ch0       (dat_pcs_measlatrndtripbit_phy_shared[{0*4} + 0 + {0*offset}]      ),
    .i_dat_pcs_measlatrndtripbit_ch1       (dat_pcs_measlatrndtripbit_phy_shared[{0*4} + 1 + {0*offset}]      ),
    .i_dat_pcs_measlatrndtripbit_ch2       (dat_pcs_measlatrndtripbit_phy_shared[{0*4} + 2 - {0*offset}]      ),
    .i_dat_pcs_measlatrndtripbit_ch3       (dat_pcs_measlatrndtripbit_phy_shared[{0*4} + 3 - {0*offset}]      ),
    .i_ft_rx_sclk_sync_ch0                 (ft_rx_sclk_sync_ch_phy_shared[{0*4} + 0 + {0*offset}]             ),                  ////out from flux_ingress as per Navid.But in flux ingress-going to pcie_pcs_lane. In Sujoy's connected one-to-one. So adding this fec_ingress port too
    .i_ft_rx_sclk_sync_ch1                 (ft_rx_sclk_sync_ch_phy_shared[{0*4} + 1 + {0*offset}]             ),
    .i_ft_rx_sclk_sync_ch2                 (ft_rx_sclk_sync_ch_phy_shared[{0*4} + 2 - {0*offset}]             ),
    .i_ft_rx_sclk_sync_ch3                 (ft_rx_sclk_sync_ch_phy_shared[{0*4} + 3 - {0*offset}]             ),
    .i_ft_tx_sclk_sync_ch0                 (ft_tx_sclk_sync_ch_phy_shared[{0*4} + 0 + {0*offset}]             ),
    .i_ft_tx_sclk_sync_ch1                 (ft_tx_sclk_sync_ch_phy_shared[{0*4} + 1 + {0*offset}]             ),
    .i_ft_tx_sclk_sync_ch2                 (ft_tx_sclk_sync_ch_phy_shared[{0*4} + 2 - {0*offset}]             ),
    .i_ft_tx_sclk_sync_ch3                 (ft_tx_sclk_sync_ch_phy_shared[{0*4} + 3 - {0*offset}]             ),
    .i_rst_ux_rx_pma_rst_n_ch0             (rst_ux_rx_pma_rst_n_phy_shared[{0*4} + 0 + {0*offset}]            ),
    .i_rst_ux_rx_pma_rst_n_ch1             (rst_ux_rx_pma_rst_n_phy_shared[{0*4} + 1 + {0*offset}]            ),
    .i_rst_ux_rx_pma_rst_n_ch2             (rst_ux_rx_pma_rst_n_phy_shared[{0*4} + 2 - {0*offset}]            ),
    .i_rst_ux_rx_pma_rst_n_ch3             (rst_ux_rx_pma_rst_n_phy_shared[{0*4} + 3 - {0*offset}]            ),
    .i_rst_ux_tx_pma_rst_n_ch0             (rst_ux_tx_pma_rst_n_phy_shared[{0*4} + 0 + {0*offset}]            ),
    .i_rst_ux_tx_pma_rst_n_ch1             (rst_ux_tx_pma_rst_n_phy_shared[{0*4} + 1 + {0*offset}]            ),
    .i_rst_ux_tx_pma_rst_n_ch2             (rst_ux_tx_pma_rst_n_phy_shared[{0*4} + 2 - {0*offset}]            ),
    .i_rst_ux_tx_pma_rst_n_ch3             (rst_ux_tx_pma_rst_n_phy_shared[{0*4} + 3 - {0*offset}]            ),
/*     .i_pcs_ick_txword_ch0                  (ick_pcs_txword_phy_shared[{0*4} + 0 + {0*offset}]                 ), In Shared HAL Connected iflux_srds_tx_clk_lane0 
    .i_pcs_ick_txword_ch1                  (ick_pcs_txword_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .i_pcs_ick_txword_ch2                  (ick_pcs_txword_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .i_pcs_ick_txword_ch3                  (ick_pcs_txword_phy_shared[{0*4} + 3 - {0*offset}]                 ), */
    .i_tx_dl_ch0_bit                       (tx_dl_ch_bit_phy_shared[{0*4} + 0 + {0*offset}]                   ),
    .i_tx_dl_ch1_bit                       (tx_dl_ch_bit_phy_shared[{0*4} + 1 + {0*offset}]                   ),
    .i_tx_dl_ch2_bit                       (tx_dl_ch_bit_phy_shared[{0*4} + 2 - {0*offset}]                   ),
    .i_tx_dl_ch3_bit                       (tx_dl_ch_bit_phy_shared[{0*4} + 3 - {0*offset}]                   ),
    .o_dat_pcs_measlatbit_ch0              (dat_pcs_measlatbit_phy_shared[{0*4} + 0 + {0*offset}]             ),
    .o_dat_pcs_measlatbit_ch1              (dat_pcs_measlatbit_phy_shared[{0*4} + 1 + {0*offset}]             ),
    .o_dat_pcs_measlatbit_ch2              (dat_pcs_measlatbit_phy_shared[{0*4} + 2 - {0*offset}]             ),
    .o_dat_pcs_measlatbit_ch3              (dat_pcs_measlatbit_phy_shared[{0*4} + 3 - {0*offset}]             ),
    .o_ft_rx_async_pulse_ch0               (ft_rx_async_pulse_ch_phy_shared[{0*4} + 0 + {0*offset}]           ),
    .o_ft_rx_async_pulse_ch1               (ft_rx_async_pulse_ch_phy_shared[{0*4} + 1 + {0*offset}]           ),
    .o_ft_rx_async_pulse_ch2               (ft_rx_async_pulse_ch_phy_shared[{0*4} + 2 - {0*offset}]           ),
    .o_ft_rx_async_pulse_ch3               (ft_rx_async_pulse_ch_phy_shared[{0*4} + 3 - {0*offset}]           ),
    .o_ft_tx_async_pulse_ch0               (ft_tx_async_pulse_ch_phy_shared[{0*4} + 0 + {0*offset}]           ),
    .o_ft_tx_async_pulse_ch1               (ft_tx_async_pulse_ch_phy_shared[{0*4} + 1 + {0*offset}]           ),
    .o_ft_tx_async_pulse_ch2               (ft_tx_async_pulse_ch_phy_shared[{0*4} + 2 - {0*offset}]           ),
    .o_ft_tx_async_pulse_ch3               (ft_tx_async_pulse_ch_phy_shared[{0*4} + 3 - {0*offset}]           ),
    .o_rx_dl_ch0_bit                       (rx_dl_ch_bit_phy_shared[{0*4} + 0 + {0*offset}]                   ),
    .o_rx_dl_ch1_bit                       (rx_dl_ch_bit_phy_shared[{0*4} + 1 + {0*offset}]                   ),
    .o_rx_dl_ch2_bit                       (rx_dl_ch_bit_phy_shared[{0*4} + 2 - {0*offset}]                   ),
    .o_rx_dl_ch3_bit                       (rx_dl_ch_bit_phy_shared[{0*4} + 3 - {0*offset}]                   ),
    .o_ux0_rxuser1_sel                     (ux_rxuser1_sel_phy_shared[{0*4} + 0 + {0*offset}]                 ),
    .o_ux0_rxuser2_sel                     (ux_rxuser2_sel_phy_shared[{0*4} + 0 + {0*offset}]                 ),
    .o_ux0_txuser1_sel                     (ux_txuser1_sel_phy_shared[{0*4} + 0 + {0*offset}]                 ),
    .o_ux0_txuser2_sel                     (ux_txuser2_sel_phy_shared[{0*4} + 0 + {0*offset}]                 ),
    .o_ux1_rxuser1_sel                     (ux_rxuser1_sel_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .o_ux1_rxuser2_sel                     (ux_rxuser2_sel_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .o_ux1_txuser1_sel                     (ux_txuser1_sel_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .o_ux1_txuser2_sel                     (ux_txuser2_sel_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .o_ux2_rxuser1_sel                     (ux_rxuser1_sel_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .o_ux2_rxuser2_sel                     (ux_rxuser2_sel_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .o_ux2_txuser1_sel                     (ux_txuser1_sel_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .o_ux2_txuser2_sel                     (ux_txuser2_sel_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .o_ux3_rxuser1_sel                     (ux_rxuser1_sel_phy_shared[{0*4} + 3 - {0*offset}]                 ),
    .o_ux3_rxuser2_sel                     (ux_rxuser2_sel_phy_shared[{0*4} + 3 - {0*offset}]                 ),
    .o_ux3_txuser1_sel                     (ux_txuser1_sel_phy_shared[{0*4} + 3 - {0*offset}]                 ),
    .o_ux3_txuser2_sel                     (ux_txuser2_sel_phy_shared[{0*4} + 3 - {0*offset}]                 ),
    .i_octl_pcs_txstatus_ch0_a             (octl_pcs_txstatus_a_phy_shared[{0*4} + 0 + {0*offset}]            ),
    .i_octl_pcs_txstatus_ch1_a             (octl_pcs_txstatus_a_phy_shared[{0*4} + 1 + {0*offset}]            ),
    .i_octl_pcs_txstatus_ch2_a             (octl_pcs_txstatus_a_phy_shared[{0*4} + 2 - {0*offset}]            ),
    .i_octl_pcs_txstatus_ch3_a             (octl_pcs_txstatus_a_phy_shared[{0*4} + 3 - {0*offset}]            ),
    .o_ictl_pcs_txenable_ch0_a             (ictl_pcs_txenable_a_phy_shared[{0*4} + 0 + {0*offset}]            ),
    .o_ictl_pcs_txenable_ch1_a             (ictl_pcs_txenable_a_phy_shared[{0*4} + 1 + {0*offset}]            ),
    .o_ictl_pcs_txenable_ch2_a             (ictl_pcs_txenable_a_phy_shared[{0*4} + 2 - {0*offset}]            ),
    .o_ictl_pcs_txenable_ch3_a             (ictl_pcs_txenable_a_phy_shared[{0*4} + 3 - {0*offset}]            ),
    .i_ick_sclk_rx_ch0                     (s_o_ick_sclk_rx_phy_shared[{0*4} + 0 + {0*offset}]                ),
    .i_ick_sclk_rx_ch1                     (s_o_ick_sclk_rx_phy_shared[{0*4} + 1 + {0*offset}]                ),
    .i_ick_sclk_rx_ch2                     (s_o_ick_sclk_rx_phy_shared[{0*4} + 2 - {0*offset}]                ),
    .i_ick_sclk_rx_ch3                     (s_o_ick_sclk_rx_phy_shared[{0*4} + 3 - {0*offset}]                ),
    .i_sclk_return_sel_rx_ch0              (sclk_return_sel_rx_phy_shared[{0*4} + 0 + {0*offset}]             ),
    .i_sclk_return_sel_rx_ch1              (sclk_return_sel_rx_phy_shared[{0*4} + 1 + {0*offset}]             ),
    .i_sclk_return_sel_rx_ch2              (sclk_return_sel_rx_phy_shared[{0*4} + 2 - {0*offset}]             ),
    .i_sclk_return_sel_rx_ch3              (sclk_return_sel_rx_phy_shared[{0*4} + 3 - {0*offset}]             ),
    .i_sclk_return_sel_tx_ch0              (sclk_return_sel_tx_phy_shared[{0*4} + 0 + {0*offset}]             ),
    .i_sclk_return_sel_tx_ch1              (sclk_return_sel_tx_phy_shared[{0*4} + 1 + {0*offset}]             ),
    .i_sclk_return_sel_tx_ch2              (sclk_return_sel_tx_phy_shared[{0*4} + 2 - {0*offset}]             ),
    .i_sclk_return_sel_tx_ch3              (sclk_return_sel_tx_phy_shared[{0*4} + 3 - {0*offset}]             ),
    .o_sync_cfg_data_ch0                   (sync_cfg_data_phy_shared[{0*4} + 0 + {0*offset}]                  ),
    .o_sync_cfg_data_ch1                   (sync_cfg_data_phy_shared[{0*4} + 1 + {0*offset}]                  ),
    .o_sync_cfg_data_ch2                   (sync_cfg_data_phy_shared[{0*4} + 2 - {0*offset}]                  ),
    .o_sync_cfg_data_ch3                   (sync_cfg_data_phy_shared[{0*4} + 3 - {0*offset}]                  ),
    .o_sync_common_control_ch0             (sync_common_control_phy_shared[{0*4} + 0 + {0*offset}]            ),
    .o_sync_common_control_ch1             (sync_common_control_phy_shared[{0*4} + 1 + {0*offset}]            ),
    .o_sync_common_control_ch2             (sync_common_control_phy_shared[{0*4} + 2 - {0*offset}]            ),
    .o_sync_common_control_ch3             (sync_common_control_phy_shared[{0*4} + 3 - {0*offset}]            ),
    .o_sync_interface_control_ch0          (sync_interface_control_phy_shared[{0*4} + 0 + {0*offset}]         ),
    .o_sync_interface_control_ch1          (sync_interface_control_phy_shared[{0*4} + 1 + {0*offset}]         ),
    .o_sync_interface_control_ch2          (sync_interface_control_phy_shared[{0*4} + 2 - {0*offset}]         ),
    .o_sync_interface_control_ch3          (sync_interface_control_phy_shared[{0*4} + 3 - {0*offset}]         ),
    .iflux_ext_cpu_fast_clk                (i_flux_clk_0                                                            ),
    .iflux_pcs_txword_lane0                (tx_data_phy_shared[{0*4} + 0 + {0*offset}]                        ),
    .iflux_pcs_txword_lane1                (tx_data_phy_shared[{0*4} + 1 + {0*offset}]                        ),
    .iflux_pcs_txword_lane2                (tx_data_phy_shared[{0*4} + 2 - {0*offset}]                        ),
    .iflux_pcs_txword_lane3                (tx_data_phy_shared[{0*4} + 3 - {0*offset}]                        ),
    .oflux_pcs_rxword_lane0                (rx_data_phy_shared[{0*4} + 0 + {0*offset}]                        ),
    .oflux_pcs_rxword_lane1                (rx_data_phy_shared[{0*4} + 1 + {0*offset}]                        ),
    .oflux_pcs_rxword_lane2                (rx_data_phy_shared[{0*4} + 2 - {0*offset}]                        ),
    .oflux_pcs_rxword_lane3                (rx_data_phy_shared[{0*4} + 3 - {0*offset}]                        ),
    .iflux_ingress_direct_lane0            (sm_flux_ingress_phy_shared[{0*4} + 0 + {0*offset}]                ),
    .iflux_ingress_direct_lane1            (sm_flux_ingress_phy_shared[{0*4} + 1 + {0*offset}]                ),
    .iflux_ingress_direct_lane2            (sm_flux_ingress_phy_shared[{0*4} + 2 - {0*offset}]                ),
    .iflux_ingress_direct_lane3            (sm_flux_ingress_phy_shared[{0*4} + 3 - {0*offset}]                ),
    .oflux_egress_direct_lane0             (sm_flux_egress_phy_shared[{0*4} + 0 + {0*offset}]                 ),
    .oflux_egress_direct_lane1             (sm_flux_egress_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .oflux_egress_direct_lane2             (sm_flux_egress_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .oflux_egress_direct_lane3             (sm_flux_egress_phy_shared[{0*4} + 3 - {0*offset}]                 ),
    .iflux_srds_tx_clk_lane0               (ick_pcs_txword_phy_shared[{0*4} + 0 + {0*offset}]                 ),
    .iflux_srds_tx_clk_lane1               (ick_pcs_txword_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .iflux_srds_tx_clk_lane2               (ick_pcs_txword_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .iflux_srds_tx_clk_lane3               (ick_pcs_txword_phy_shared[{0*4} + 3 - {0*offset}]                 ),
    .oflux_cpi_int                         (flux_cpi_int_phy_shared[0]                                              ),
    .oflux_int0                            (flux_int_phy_shared[{0*4} + 0 + {0*offset}]                       ),
    .oflux_int1                            (flux_int_phy_shared[{0*4} + 1 + {0*offset}]                       ),
    .oflux_int2                            (flux_int_phy_shared[{0*4} + 2 - {0*offset}]                       ),
    .oflux_int3                            (flux_int_phy_shared[{0*4} + 3 - {0*offset}]                       ),
    .oflux_octl_pcs_txptr_smpl_lane0       (oflux_octl_pcs_txptr_smpl_lane_phy_shared[{0*4} + 0 + {0*offset}] ),
    .oflux_octl_pcs_txptr_smpl_lane1       (oflux_octl_pcs_txptr_smpl_lane_phy_shared[{0*4} + 1 + {0*offset}] ),
    .oflux_octl_pcs_txptr_smpl_lane2       (oflux_octl_pcs_txptr_smpl_lane_phy_shared[{0*4} + 2 - {0*offset}] ),
    .oflux_octl_pcs_txptr_smpl_lane3       (oflux_octl_pcs_txptr_smpl_lane_phy_shared[{0*4} + 3 - {0*offset}] ),
    .iflux_ick_pcs_txptr_smpl_clk_l0_lane0 (ick_sclk_tx_phy_shared[{0*4} + 0 + {0*offset}]                    ),
    .iflux_ick_pcs_txptr_smpl_clk_l0_lane1 (ick_sclk_tx_phy_shared[{0*4} + 1 + {0*offset}]                    ),
    .iflux_ick_pcs_txptr_smpl_clk_l0_lane2 (ick_sclk_tx_phy_shared[{0*4} + 2 - {0*offset}]                    ),
    .iflux_ick_pcs_txptr_smpl_clk_l0_lane3 (ick_sclk_tx_phy_shared[{0*4} + 3 - {0*offset}]                    ),
    .oflux_srds_rdy0                       (flux_srds_rdy_phy_shared[{0*4} + 0 + {0*offset}]                  ),
    .oflux_srds_rdy1                       (flux_srds_rdy_phy_shared[{0*4} + 1 + {0*offset}]                  ),
    .oflux_srds_rdy2                       (flux_srds_rdy_phy_shared[{0*4} + 2 - {0*offset}]                  ),
    .oflux_srds_rdy3                       (flux_srds_rdy_phy_shared[{0*4} + 3 - {0*offset}]                  ),
    .oflux_srds_rx_clk_lane0               (pcs_rxword_phy_shared[{0*4} + 0 + {0*offset}]                     ),
    .oflux_srds_rx_clk_lane1               (pcs_rxword_phy_shared[{0*4} + 1 + {0*offset}]                     ),
    .oflux_srds_rx_clk_lane2               (pcs_rxword_phy_shared[{0*4} + 2 - {0*offset}]                     ),
    .oflux_srds_rx_clk_lane3               (pcs_rxword_phy_shared[{0*4} + 3 - {0*offset}]                     ),
    .oflux_srds_rx_divn_clk_lane0          (pcs_rxpostdiv_phy_shared[{0*4} + 0 + {0*offset}]                  ),
    .oflux_srds_rx_divn_clk_lane1          (pcs_rxpostdiv_phy_shared[{0*4} + 1 + {0*offset}]                  ),
    .oflux_srds_rx_divn_clk_lane2          (pcs_rxpostdiv_phy_shared[{0*4} + 2 - {0*offset}]                  ),
    .oflux_srds_rx_divn_clk_lane3          (pcs_rxpostdiv_phy_shared[{0*4} + 3 - {0*offset}]                  ),
    .oflux_srds_tx_clk_lane0               (ock_pcs_txword_phy_shared[{0*4} + 0 + {0*offset}]                 ),
    .oflux_srds_tx_clk_lane1               (ock_pcs_txword_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .oflux_srds_tx_clk_lane2               (ock_pcs_txword_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .oflux_srds_tx_clk_lane3               (ock_pcs_txword_phy_shared[{0*4} + 3 - {0*offset}]                 ),
    .uxwrap_bus_in_lane0                   (uxwrap_bus_in_phy_shared[{0*4} + 0 + {0*offset}]                  ),
    .uxwrap_bus_in_lane1                   (uxwrap_bus_in_phy_shared[{0*4} + 1 + {0*offset}]                  ),
    .uxwrap_bus_in_lane2                   (uxwrap_bus_in_phy_shared[{0*4} + 2 - {0*offset}]                  ),
    .uxwrap_bus_in_lane3                   (uxwrap_bus_in_phy_shared[{0*4} + 3 - {0*offset}]                  ),
    .uxwrap_bus_out_lane0                  (uxwrap_bus_out_phy_shared[{0*4} + 0 + {0*offset}]                 ),
    .uxwrap_bus_out_lane1                  (uxwrap_bus_out_phy_shared[{0*4} + 1 + {0*offset}]                 ),
    .uxwrap_bus_out_lane2                  (uxwrap_bus_out_phy_shared[{0*4} + 2 - {0*offset}]                 ),
    .uxwrap_bus_out_lane3                  (uxwrap_bus_out_phy_shared[{0*4} + 3 - {0*offset}]                 ),

    .i_q2q_xcvrrc_ux_ux__txstatus_rc_ux    (q2q_xcvrrc_ux_ux__txstatus_rc_ux[0]                                     ),
    .o_q2q_xcvrrc_ux_ux__txstatus_ux_rc    (q2q_xcvrrc_ux_ux__txstatus_ux_rc[0]                                     )

);
//CH0 = PCIE, CH1-CH4 = Other Channels, CH5 = PTP

endmodule


