#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for Agilex GHRD.
#
#****************************************************************************

set_time_format -unit ns -decimal_places 3

# 100MHz board input clock, 133.3333MHz for EMIF refclk
#MAIN_CLOCK is the 100MHz clk
create_clock -name MAIN_CLOCK -period 10 [get_ports fpga_clk_100]
#OSC_CLOCK is the system_pll_refclk
create_clock -name OSC_CLOCK -period 6.4 [get_ports osc_clk]
create_clock -name EMIF_REF_CLOCK -period 200MHz [get_ports emif_hps_emif_ref_clk_0_clk] 

set_false_path -from [get_ports {fpga_reset_n}]

# sourcing JTAG related SDC
source ./jtag.sdc

# FPGA IO port constraints
set_false_path -from [get_ports {fpga_button_pio[0]}] -to *
set_false_path -from [get_ports {fpga_button_pio[1]}] -to *
set_false_path -from [get_ports {fpga_button_pio[2]}] -to *
set_false_path -from [get_ports {fpga_button_pio[3]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[0]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[1]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[2]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[3]}] -to *
#set_false_path -from [get_ports {fpga_led_pio[0]}] -to *
#set_false_path -from [get_ports {fpga_led_pio[1]}] -to *
#set_false_path -from [get_ports {fpga_led_pio[2]}] -to *
#set_false_path -from [get_ports {fpga_led_pio[3]}] -to *
set_false_path -from * -to [get_ports {fpga_led_pio[0]}]
set_false_path -from * -to [get_ports {fpga_led_pio[1]}]
set_false_path -from * -to [get_ports {fpga_led_pio[2]}]
set_false_path -from * -to [get_ports {fpga_led_pio[3]}]
set_output_delay -clock MAIN_CLOCK 5 [get_ports {fpga_led_pio[3]}] 
 
# False Path between debounced and reset synchronizer
set_false_path -from [get_registers {fpga_reset_n_debounced}] -to {soc_inst|rst_controller_*|altera_reset_synchronizer_int_chain[1]}

#DRC constraint
set_output_delay -clock MAIN_CLOCK 1 [get_ports {fpga_led_pio[3]}]

create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx_n_cnt_clk} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 1 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_registers {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll~ncntr_reg}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx_n_cnt_clk} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 1 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_registers {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll~ncntr_reg}]  
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx_n_cnt_clk} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 1 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_registers {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll~ncntr_reg}] 

create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx_m_cnt_clk} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 1 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_registers {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll~mcntr_reg}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx_m_cnt_clk} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 1 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_registers {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll~mcntr_reg}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx_m_cnt_clk} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 1 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_registers {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll~mcntr_reg}] 

create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx_outclk0} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 7 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll|out_clk[0]}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx_outclk0} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 7 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll|out_clk[0]}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx_outclk0} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 7 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll|out_clk[0]}] 

create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx_outclk2} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 35 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll|out_clk[2]}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx_outclk2} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 35 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll|out_clk[2]}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx_outclk2} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 35 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll|out_clk[2]}] 

create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx_outclk3} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 350 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx|tennm_ph2_iopll|out_clk[3]}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx_outclk3} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 350 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx|tennm_ph2_iopll|out_clk[3]}] 
create_generated_clock -name {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx_outclk3} -source [get_pins {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll|ref_clk0}] -duty_cycle 50/1 -multiply_by 14 -divide_by 350 -master_clock {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_o_tx_clkout2[0]} [get_pins {dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx|tennm_ph2_iopll|out_clk[3]}] 

