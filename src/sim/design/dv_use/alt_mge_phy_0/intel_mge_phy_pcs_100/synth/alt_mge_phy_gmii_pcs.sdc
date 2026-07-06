# (C) 2001-2023 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# (C) 2001-2023 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


set old_mode [set_project_mode -get_mode_value always_show_entity_name] 
set_project_mode -always_show_entity_name on

# Function to constraint non-std_synchronizer path
proc alt_mge16_pcs_constraint_net_delay {from_reg to_reg max_net_delay {check_exist 0}} {
    
    # Check for instances
    set inst [get_registers -nowarn ${to_reg}]
    
    # Check number of instances
    set inst_num [llength [query_collection -report -all $inst]]
    if {$inst_num > 0} {
        # Uncomment line below for debug purpose
        #puts "${inst_num} ${to_reg} instance(s) found"
    } else {
        # Uncomment line below for debug purpose
        #puts "No ${to_reg} instance found"
    }
    
    if {($check_exist == 0) || ($inst_num > 0)} {
        if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -200ns
        } else {
            set_net_delay -from [get_pins -compatibility_mode ${from_reg}|q] -to [get_registers ${to_reg}] -max $max_net_delay
            
            # Relax the fitter effort
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -200ns
        }
    }
}

# Function to constraint std_synchronizer
proc alt_mge16_pcs_constraint_std_sync {} {
   
    alt_mge16_pcs_constraint_net_delay  *  *alt_mge16_pcs_pma:*|alt_mge16_pcs_std_synchronizer:*|altera_std_synchronizer_nocut:*|din_s1  5.4ns
   
}

# Function to constraint pointers
proc alt_mge16_pcs_constraint_ptr {from_path from_reg to_path to_reg max_skew max_net_delay} {
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${from_path}|${from_reg}\[0\]]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${from_path}|${from_reg} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${from_path}|${from_reg} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
        foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp]
            
            # Get the path to instance
            regexp "(.*${from_path})(.*|)(${from_reg})" $each_inst reg_path inst_path inst_name reg_name
            
            set_max_skew -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] $max_skew
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] 200ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] -200ns
        }
        
    } else {
        set_net_delay -from [get_pins -compatibility_mode *${from_path}|${from_reg}[*]|q] -to [get_registers *${to_path}|${to_reg}*] -max $max_net_delay
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${from_path}|${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] 200ns
        set_min_delay -from [get_registers *${from_path}|${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] -200ns
        
    }
    
}

# Function to constraint clock crosser
proc alt_mge16_pcs_constraint_clock_crosser {} {
    set module_name alt_mge16_pcs_clock_crosser
    
    set from_reg1 in_data_toggle
    set to_reg1 alt_mge16_pcs_std_synchronizer:in_to_out_synchronizer|altera_std_synchronizer_nocut:*|din_s1
    
    set from_reg2 in_data_buffer
    set to_reg2 out_data_buffer
    
    set from_reg3 out_data_toggle_flopped
    set to_reg3 alt_mge16_pcs_std_synchronizer:out_to_in_synchronizer|altera_std_synchronizer_nocut:*|din_s1
    
    set max_skew 3ns
    
    set max_delay1 3ns
    set max_delay2 2ns
    set max_delay3 3ns
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${module_name}:*|${from_reg1}]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${module_name} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${module_name} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
        foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp]
            
            # Get the path to instance
            regexp "(.*${module_name})(:.*|)(${from_reg1})" $each_inst reg_path inst_path inst_name reg_name
            
            # Check if unused data buffer get synthesized away
            set reg2_collection [get_registers -nowarn ${inst_path}${inst_name}${to_reg2}[*]]
            set reg2_num [llength [query_collection -report -all $reg2_collection]]
            
            if {$reg2_num > 0} {
                set_max_skew -from [get_registers "${inst_path}${inst_name}${from_reg1} ${inst_path}${inst_name}${from_reg2}[*]"] -to [get_registers "${inst_path}${inst_name}${to_reg1} ${inst_path}${inst_name}${to_reg2}[*]"] $max_skew
                
                set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg2}[*]] -to [get_registers ${inst_path}${inst_name}${to_reg2}[*]] 200ns
                set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg2}[*]] -to [get_registers ${inst_path}${inst_name}${to_reg2}[*]] -200ns
            }
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg1}] -to [get_registers ${inst_path}${inst_name}${to_reg1}] 200ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg1}] -to [get_registers ${inst_path}${inst_name}${to_reg1}] -200ns
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg3}] -to [get_registers ${inst_path}${inst_name}${to_reg3}] 200ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg3}] -to [get_registers ${inst_path}${inst_name}${to_reg3}] -200ns
        }
        
    } else {
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg1}|q]    -to [get_registers *${module_name}:*|${to_reg1}] -max $max_delay1
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg2}[*]|q] -to [get_registers *${module_name}:*|${to_reg2}[*]] -max $max_delay2
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg3}|q]    -to [get_registers *${module_name}:*|${to_reg3}] -max $max_delay3
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] 200ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] -200ns
        
        set_max_delay -from [get_registers *${module_name}:*|${from_reg2}[*]] -to [get_registers *${module_name}:*|${to_reg2}[*]] 200ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg2}[*]] -to [get_registers *${module_name}:*|${to_reg2}[*]] -200ns
        
        set_max_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] 200ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] -200ns
        
    }
    
}

# Standard Synchronizer
alt_mge16_pcs_constraint_std_sync

# FIFO
alt_mge16_pcs_constraint_ptr  alt_mge16_pcs_pma:*|alt_mge16_pcs_a_fifo_24:*|alt_mge16_pcs_gray_cnt:U_RD  g_out  alt_mge16_pcs_pma:*|alt_mge16_pcs_a_fifo_24:*|alt_mge16_pcs_std_synchronizer:*  din_s1  6ns  5.4ns
alt_mge16_pcs_constraint_ptr  alt_mge16_pcs_pma:*|alt_mge16_pcs_a_fifo_24:*|alt_mge16_pcs_gray_cnt:U_WRT  g_out  alt_mge16_pcs_pma:*|alt_mge16_pcs_a_fifo_24:*|alt_mge16_pcs_std_synchronizer:*  din_s1  6ns  5.4ns

# Clock Crosser
alt_mge16_pcs_constraint_clock_crosser

# PCS Internal
alt_mge16_pcs_constraint_net_delay  *alt_mge16_pcs_pma:*|alt_mge16_pcs_mdio_reg:*|dev_ability*  *alt_mge16_pcs_pma:*|alt_mge16_pcs_top_autoneg:*|*  4ns
alt_mge16_pcs_constraint_net_delay  *alt_mge16_pcs_pma:*|alt_mge16_pcs_mdio_reg:*|link_timer_reg*  *alt_mge16_pcs_pma:*|alt_mge16_pcs_top_autoneg:*|*  4ns

# 1588
alt_mge16_pcs_constraint_net_delay  *alt_mge16_pcs_pma:*|alt_mge16_pcs_rx_encapsulation_strx_gx:*|lane_alignment  *alt_mge16_pcs_pma:*|alt_mge16_pcs_top_rx_converter:*|latency_adj_sum*  5.4ns  1
alt_mge16_pcs_constraint_net_delay  *  *alt_mge16_pcs_pma:*|alt_mge16_pcs_top_rx_converter:*|wa_boundary_reg*  5.4ns  1

set regs [get_registers -nowarn *alt_mge16_pcs_ph_calculator*sync_wr_ptr[2]*]
if {[llength [query_collection -report -all $regs]] > 0} {
  alt_mge16_pcs_constraint_ptr  alt_mge16_pcs_ph_calculator:phase_calculator.ph_cal_inst  wr_ptr_sample  alt_mge16_pcs_ph_calculator:*|alt_mge16_pcs_std_synchronizer:*  din_s1  4.5ns  3ns
}

set regs [get_registers -nowarn *alt_mge16_pcs_ph_calculator*sync_rd_ptr[2]*]
if {[llength [query_collection -report -all $regs]] > 0} {
  alt_mge16_pcs_constraint_ptr  alt_mge16_pcs_ph_calculator:phase_calculator.ph_cal_inst  rd_ptr_sample  alt_mge16_pcs_ph_calculator:*|alt_mge16_pcs_std_synchronizer:*  din_s1  4.5ns  3ns
}
set_false_path -from [get_registers *|alt_mge16_pcs_pma:*|alt_mge16_pcs_control:U_REG|alt_mge16_pcs_mdio_reg:U_REG|if_mode\[*\]*] -to [get_registers *|alt_mge16_pcs_pma:*|alt_mge16_pcs_top_sgmii_strx_gx:U_SGMII|alt_mge16_pcs_top_pcs_strx_gx:U_PCS|alt_mge16_pcs_top_autoneg:U_AUTONEG|an_ability_out\[*\]*]

set regs [get_registers -nowarn *U_REG*sgmii_speed*]
if {[llength [query_collection -report -all $regs]] > 0} {
    set_false_path -from [get_registers *|alt_mge16_pcs_pma_gige:*|alt_mge16_pcs_control:U_REG|alt_mge16_pcs_mdio_reg:U_REG|partner_ability\[*\]*] -to [get_registers *|alt_mge_phy_pcs:mge_pcs|alt_mge16_pcs_pma:*|alt_mge16_pcs_control:U_REG|alt_mge16_pcs_mdio_reg:U_REG|sgmii_speed\[*\]*]
}

#**************************************************************
# Set False Path for alt_mge16_pcs_reset_synchronizer
#**************************************************************


set_false_path -from [get_keepers -no_duplicates {*|xcvr_term|fifo_wrapper|rx_efifo|dcfifo_componenet|auto_generated|delayed_wrptr_*}] -to [get_keepers -no_duplicates {*|xcvr_term|fifo_wrapper|rx_efifo|dcfifo_componenet|auto_generated|rdemp_eq_comp_*}]
set_false_path -from [get_keepers -no_duplicates {*|xcvr_term|fifo_wrapper|rx_efifo|dcfifo_componenet|auto_generated|rdptr_g*}] -to [get_keepers -no_duplicates {*|xcvr_term|fifo_wrapper|rx_efifo|dcfifo_componenet|auto_generated|wrfull_eq_comp_*}]
set_false_path -from [get_keepers -no_duplicates {*|mge_pcs|rst_sync|rsync__gtx_reset__rx_pma_clk|alt_mge16_pcs_reset_synchronizer_chain_out}] -to [get_keepers -no_duplicates {*|xcvr_term|fifo_wrapper|rx_efifo|wr_full_reg}]
set_false_path -from [get_keepers -no_duplicates {*|mge_pcs|rst_sync|rsync__gtx_reset__rx_pma_clk|alt_mge16_pcs_reset_synchronizer_chain_out}] -to [get_keepers -no_duplicates {*|xcvr_term|fifo_wrapper|rx_efifo|dcfifo_componenet|auto_generated|wraclr|dffe*}]
set_false_path -from [get_keepers -no_duplicates {*|alt_mge_xcvr_directphy|g1.n.sys[0].n_channel_superset_ip_inst|n_channel_superset_top_wrapper|ncss_common_sip_top_0|src_lane|src_flow_ctrl|src_addr_gen|addr_gen_tx_fully_op}] -to [get_keepers -no_duplicates {*|iopll_tx|tennm_ph2_iopll~pll_ctrl_reg}]
 


# False path for Cross Clock domain of Elastic Buffer
set_false_path -from [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|u_fifomem|fifomem*}] -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|u_fifomem|fifomem_s1*}]
set_false_path -from [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|wr_gray_ptr[*]}] -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|u_wr_to_rd_synch|synch_flp*}]
set_false_path -from [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|wr_bin_ptr[*]}] -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|u_wr_to_rd_synch|synch_flp*}]
set_false_path -from [get_registers {*|u_hps_to_mge_gmii_adapter_core|u_rxbuffer|*}] -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|u_rxbuffer|*}]

# False Path for CSR status
set_false_path -from * -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|u_csr|readdata[*]}]

# Constraint for reset synchronizer 
set_false_path -from * -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|din_sync_*}]
set_net_delay -from [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|din_sync_1}] -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|*|din_sync_2}] -max 3

# False path for mac_speed and phy_speed
set_false_path -from [get_registers {*|u_hps_to_mge_gmii_adapter_core|mac_speed_int*}] -to *
set_false_path -from [get_registers {*|u_hps_to_mge_gmii_adapter_core|phy_speed_int*}] -to *
set_false_path -from * -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|mac_speed_int*}]
set_false_path -from * -to [get_registers {*|u_hps_to_mge_gmii_adapter_core|phy_speed_int*}]





set reset_sync_aclr_counter 0
set reset_sync_clrn_counter 0
set reset_sync_aclr_collection [get_pins -compatibility_mode -nocase -nowarn *|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain*|aclr]
set reset_sync_clrn_collection [get_pins -compatibility_mode -nocase -nowarn *|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain*|clrn]

foreach_in_collection reset_sync_aclr_pin $reset_sync_aclr_collection {
    set reset_sync_aclr_counter [expr $reset_sync_aclr_counter + 1]
}

foreach_in_collection reset_sync_clrn_pin $reset_sync_clrn_collection {
    set reset_sync_clrn_counter [expr $reset_sync_clrn_counter + 1]
}

if {$reset_sync_aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain*|aclr]
}

if {$reset_sync_clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain*|clrn]
}

set_project_mode -always_show_entity_name $old_mode
