#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct top level qsys for the GHRD
# The value of the variables is passed in through Makefile flow argument (QSYS_TCL_CMDS).
#
# To use this script independently from Makefile flow, following command can be used 
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="<TCL command to set variables' value>"
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set qsys_name soc_system; set devicefamily STRATIX10; set device 1SX280LU3F50E3VG"
#
#****************************************************************************

puts "\[GHRD:info\] \$prjroot = ${prjroot} "
source ${prjroot}/arguments_solver.tcl
source ${prjroot}/utils.tcl

package require -exact qsys 23.4
# Derive channel and width from hps_emif_topology
set mystring $hps_emif_topology
set pattern {[0-9]+}

# Find and print each number individually
set start 0
while {[regexp $pattern [string range $mystring $start end] match]} {
    set number $match
if {$number <=5} {
    set hps_emif_channel $number
} else {
	set hps_emif_width $number
}
    set start [expr {[string first $match $mystring] + [string length $match]}]
}


create_system $qsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

# Following IP components are present as basic of GHRD in FPGA fabric
#   - Clock Bridge
#   - Reset Bridge
#   - Reset Release IP
#   - Onchip Memory 
add_component_param "altera_clock_bridge clk_100
                    IP_FILE_PATH ip/$qsys_name/clk_100.ip 
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_reset_bridge rst_in
                    IP_FILE_PATH ip/$qsys_name/rst_in.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES none
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "

# add_component_param "intel_user_rst_clkgate user_rst_clkgate_0
                    # IP_FILE_PATH ip/$qsys_name/user_rst_clkgate_0.ip 
                    # "
					
add_component_param "intel_onchip_memory ocm
                    IP_FILE_PATH ip/$qsys_name/ocm.ip 
                    dataWidth $ocm_datawidth
                    memorySize $ocm_memsize
                    singleClockOperation 1
                    interfaceType 1
                    idWidth 10
                    "
					

if {$tsn_en == 1} {
	if {$tsn_concurrent == 1} {
	add_component_param "intel_srcss_gts gts_inst
				 IP_FILE_PATH ip/$qsys_name/gts_inst.ip
				 SRC_RS_DISABLE 0
				 NUM_BANKS_SHORELINE 1
				 NUM_LANES_SHORELINE 3
				 "
	} else {
	add_component_param "intel_srcss_gts gts_inst
				 IP_FILE_PATH ip/$qsys_name/gts_inst.ip
				 SRC_RS_DISABLE 0
				 NUM_BANKS_SHORELINE 1
				 NUM_LANES_SHORELINE 1
				 "
	}
} else {
	if {$hps_usb0_en == 1 | $hps_usb1_en == 1 } {
	add_component_param "intel_srcss_gts gts_inst
					 IP_FILE_PATH ip/$qsys_name/gts_inst.ip
					 SRC_RS_DISABLE 1
					 NUM_BANKS_SHORELINE 1
					 "
	}
}

if {$clk_gate_en == 1} {
add_component_param "stratix10_clkctrl clkctrl_0
                    IP_FILE_PATH ip/$qsys_name/clkctrl_0.ip 
                    NUM_CLOCKS 1
                    ENABLE 1
                    ENABLE_REGISTER_TYPE 1
                    ENABLE_TYPE 1
                    "
}

if {$f2s_address_width > 32} {
	if {$cct_en == 1} {
	add_component_param "intel_cache_coherency_translator intel_cache_coherency_translator_0
						IP_FILE_PATH ip/$qsys_name/intel_cache_coherency_translator_0.ip
						CONTROL_INTERFACE $cct_control_interface
						ADDR_WIDTH $f2s_address_width
						AXM_ID_WIDTH 5
						AXS_ID_WIDTH 5
						ARDOMAIN_OVERRIDE 0
						ARBAR_OVERRIDE 0
						ARSNOOP_OVERRIDE 0
						ARCACHE_OVERRIDE 2
						AWDOMAIN_OVERRIDE 0
						AWBAR_OVERRIDE 0
						AWSNOOP_OVERRIDE 0
						AWCACHE_OVERRIDE 2
						AxUSER_OVERRIDE 0xE0
						AxPROT_OVERRIDE 1
						DATA_WIDTH $f2s_data_width
						"
	}
}

if {$sub_fpga_rgmii_en == 1} {
add_instance subsys_fpga_rgmii fpga_rgmii_subsys
reload_ip_catalog
}

if {$sub_hps_en == 1} {
add_instance subsys_hps hps_subsys
reload_ip_catalog
}

if {$sub_peri_en == 1} {
add_instance subsys_periph peripheral_subsys
reload_ip_catalog
}

if {$sub_debug_en == 1} {
	add_instance subsys_debug jtag_subsys
	reload_ip_catalog	
	if { $f2sdram_width > 0 } {	
		add_component_param "altera_address_span_extender ext_hps_f2sdram_master
							IP_FILE_PATH ip/$qsys_name/ext_hps_f2sdram_master.ip
							BURSTCOUNT_WIDTH 1
							MASTER_ADDRESS_WIDTH 33
							SLAVE_ADDRESS_WIDTH 30
							ENABLE_SLAVE_PORT 0
							MAX_PENDING_READS 1
							"
							
		connect "         clk_100.out_clk                        ext_hps_f2sdram_master.clock
						rst_in.out_reset                       ext_hps_f2sdram_master.reset"
														
		connect_map "     subsys_debug.hps_f2sdram_master              ext_hps_f2sdram_master.windowed_slave 0x0 "
		connect_map "     ext_hps_f2sdram_master.expanded_master       subsys_hps.f2sdram_adapter_axi4_sub 0x0000 "
	}

	if { $f2s_data_width > 0 } {												 
		connect_map "     subsys_debug.hps_m_master            subsys_hps.fpga2hps 0x0000 "
	}
}

if {$tsn_en == 1} {
add_instance subsys_tsn tsn_subsys
reload_ip_catalog
}

if {$tsn_concurrent == 1} {
add_instance subsys_phymgmt phy_mgmt
reload_ip_catalog
}

if {$tsn_en == 1} {
add_component csr_rst ip/qsys_top/csr_rst.ip altera_reset_bridge altera_reset_bridge_inst 19.2.0
load_component csr_rst
set_component_parameter_value ACTIVE_LOW_RESET {1}
set_component_parameter_value NUM_RESET_OUTPUTS {1}
set_component_parameter_value SYNCHRONOUS_EDGES {none}
set_component_parameter_value SYNC_RESET {0}
set_component_parameter_value USE_RESET_REQUEST {0}
set_component_project_property HIDE_FROM_IP_CATALOG {false}
save_component
load_instantiation csr_rst


add_connection csr_rst.out_reset/subsys_hps.lwhps2fpga_rst
set_connection_parameter_value csr_rst.out_reset/subsys_hps.lwhps2fpga_rst clockDomainSysInfo {2}
set_connection_parameter_value csr_rst.out_reset/subsys_hps.lwhps2fpga_rst clockResetSysInfo {}
set_connection_parameter_value csr_rst.out_reset/subsys_hps.lwhps2fpga_rst resetDomainSysInfo {2}
add_connection csr_rst.out_reset/subsys_tsn.csr_reset
set_connection_parameter_value csr_rst.out_reset/subsys_tsn.csr_reset clockDomainSysInfo {2}
set_connection_parameter_value csr_rst.out_reset/subsys_tsn.csr_reset clockResetSysInfo {}
set_connection_parameter_value csr_rst.out_reset/subsys_tsn.csr_reset resetDomainSysInfo {2}

# add the exports
set_interface_property csr_rst EXPORT_OF csr_rst.in_reset


add_connection clk_100.out_clk/subsys_hps.lwhps2fpga_clk
set_connection_parameter_value clk_100.out_clk/subsys_hps.lwhps2fpga_clk clockDomainSysInfo {1}
set_connection_parameter_value clk_100.out_clk/subsys_hps.lwhps2fpga_clk clockRateSysInfo {100000000.0}
set_connection_parameter_value clk_100.out_clk/subsys_hps.lwhps2fpga_clk clockResetSysInfo {}
set_connection_parameter_value clk_100.out_clk/subsys_hps.lwhps2fpga_clk resetDomainSysInfo {1}


add_connection subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 addressMapSysInfo {<address-map><slave name='subsys_tsn.axi_bridge_0_s0' start='0x0' end='0x4000' datawidth='32' /></address-map>}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 addressWidthSysInfo {14}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 arbitrationPriority {1}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 baseAddress {0x1000_0000}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 defaultConnection {0}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 domainAlias {}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.clockCrossingAdapter {HANDSHAKE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.enableAllPipelines {FALSE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.enableEccProtection {FALSE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.enableInstrumentation {FALSE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.enableOutOfOrderSupport {FALSE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.insertDefaultSlave {FALSE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.interconnectResetSource {DEFAULT}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.interconnectType {STANDARD}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.maxAdditionalLatency {1}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.optimizeRdFifoSize {FALSE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.piplineType {PIPELINE_STAGE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.responseFifoType {REGISTER_BASED}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.syncResets {TRUE}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
set_connection_parameter_value subsys_hps.lwhps2fpga/subsys_tsn.axi_bridge_0_s0 slaveDataWidthSysInfo {-1}


# set values for exposed HDL parameters
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.burstAdapterImplementation GENERIC_CONVERTER
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.clockCrossingAdapter HANDSHAKE
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.enableAllPipelines FALSE
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.enableEccProtection FALSE
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.enableInstrumentation FALSE 
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.enableOutOfOrderSupport FALSE
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.insertDefaultSlave FALSE
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.interconnectResetSource DEFAULT
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.interconnectType STANDARD
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.maxAdditionalLatency 1
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.optimizeRdFifoSize FALSE
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.piplineType PIPELINE_STAGE
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.responseFifoType REGISTER_BASED
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.syncResets TRUE
set_domain_assignment subsys_hps.lwhps2fpga qsys_mm.widthAdapterImplementation GENERIC_CONVERTER
}

													     
													     
if {$cct_en == 1} {	                                     
	connect "	  clk_100.out_clk                        intel_cache_coherency_translator_0.clock
			      rst_in.out_reset                       intel_cache_coherency_translator_0.reset
		"                                                
													     
    if {$cct_control_interface == 2} {                   
        connect " clk_100.out_clk                        intel_cache_coherency_translator_0.csr_clock
                  rst_in.out_reset                       intel_cache_coherency_translator_0.csr_reset
                "
    }

    if {$f2s_address_width >32} {
        connect_map "subsys_debug.hps_m_master           ext_hps_f2sdram_master.windowed_slave            0x0"
        connect_map "ext_hps_f2sdram_master.expanded_master    intel_cache_coherency_translator_0.s0      0x0"
    } else {                                             
        connect_map "subsys_debug.hps_m_master           intel_cache_coherency_translator_0.s0      0x0"
    }
	
	connect_map "intel_cache_coherency_translator_0.m0   subsys_hps.fpga2hps 0x0000 "
	connect_map "subsys_hps.lwhps2fpga                   intel_cache_coherency_translator_0.csr "
	connect_map "subsys_debug.fpga_m_master              intel_cache_coherency_translator_0.csr 0x10200 "
}

# --------------- Connections and connection parameters ------------------#


connect "clk_100.out_clk   ocm.clk1
         rst_in.out_reset  ocm.reset1 
        "
           
if {$sub_hps_en == 1} {
  
  if {$hps_clk_source == 1} {
  connect " clk_100.out_clk   subsys_hps.clk
            rst_in.out_reset  subsys_hps.reset 
          "
  }
 
  if {$f2sdram_width > 0} {
	connect " clk_100.out_clk   subsys_hps.f2sdram_clk
            rst_in.out_reset  subsys_hps.f2sdram_rst
			clk_100.out_clk   subsys_hps.f2sdram_adapter_clk
            rst_in.out_reset  subsys_hps.f2sdram_adapter_rst
          "
  }
  #if {$lwh2f_width > 0} {
  #connect " clk_100.out_clk   subsys_hps.lwhps2fpga_clk
  #          rst_in.out_reset  subsys_hps.lwhps2fpga_rst 			
  #        "
  #}
  if {$h2f_width > 0} {
  connect " clk_100.out_clk   subsys_hps.hps2fpga_clk
            rst_in.out_reset  subsys_hps.hps2fpga_rst 
          "
  }
  if {$f2s_data_width > 0} {
  connect " clk_100.out_clk   subsys_hps.fpga2hps_clk
            rst_in.out_reset  subsys_hps.fpga2hps_rst 
          "
  }

}


           
if {$sub_debug_en == 1} {
    connect_map "subsys_debug.fpga_m_master ocm.axi_s1 0x40000"
    connect "clk_100.out_clk     subsys_debug.clk
             rst_in.out_reset    subsys_debug.reset   
            "

    if {$hps_usb0_en == 1 | $hps_usb1_en == 1} {
        connect_map "subsys_debug.fpga_m_master subsys_hps.usb31_phy_reconfig_slave 0x800000"
    }
}

if {$tsn_en == 1} {
	#connect_map "subsys_tsn.csr_reset csr_rst.out_reset"
	connect "clk_100.out_clk subsys_tsn.csr_clk"
	#connect_map "subsys_hps.lwhps2fpga subsys_tsn.axi_bridge_0_s0"				
}


#if {$sub_peri_en == 1} {
#	connect_map "   subsys_debug.fpga_m_master   subsys_periph.control_slave 0x10000"
#}

if {$sub_peri_en == 1} {
connect "clk_100.out_clk   subsys_periph.clk
         rst_in.out_reset  subsys_periph.reset
		"
if {$fpga_data_mover_en == 1} {			 
connect "clk_100.out_clk   subsys_periph.ssgdma_host_clk
         rst_in.out_reset  subsys_periph.ssgdma_host_aresetn
         clk_100.out_clk   subsys_periph.ssgdma_h2d0_mm_clk
         rst_in.out_reset  subsys_periph.ssgdma_h2d0_mm_resetn
         "
}
}

if {$sub_peri_en == 1} {
    if {$fpga_button_pio_width >0} {
#       connect "agilex_hps.f2h_irq0      periph.button_pio_irq"
#       set_connection_parameter_value agilex_hps.f2h_irq0/periph.button_pio_irq irqNumber {1}
      # connect "subsys_periph.ILC_irq       subsys_periph.button_pio_irq"
      # set_connection_parameter_value subsys_periph.ILC_irq/subsys_periph.button_pio_irq irqNumber {1}
    }
    if {$fpga_dipsw_pio_width >0} {
#       connect "agilex_hps.f2h_irq0      periph.dipsw_pio_irq"
#       set_connection_parameter_value agilex_hps.f2h_irq0/periph.dipsw_pio_irq irqNumber {0}
      # connect "subsys_periph.ILC_irq       subsys_periph.dipsw_pio_irq"
      # set_connection_parameter_value subsys_periph.ILC_irq/subsys_periph.dipsw_pio_irq irqNumber {0}
    }
}

if {$h2f_width > 0} {
    connect_map "subsys_hps.hps2fpga ocm.axi_s1 0x0000"
}

if {$sub_peri_en == 1} {
   if {$lwh2f_width > 0} {
     connect_map "subsys_hps.lwhps2fpga subsys_periph.pb_cpu_0_s0 0x0"
     
      if {$hps_f2h_irq_en == 1} {
        connect "subsys_hps.f2h_irq0_in subsys_periph.button_pio_irq"
        set_connection_parameter_value subsys_hps.f2h_irq0_in/subsys_periph.button_pio_irq irqNumber {0}
        connect "subsys_hps.f2h_irq0_in subsys_periph.dipsw_pio_irq"
        set_connection_parameter_value subsys_hps.f2h_irq0_in/subsys_periph.dipsw_pio_irq irqNumber {1}

	      if {$fpga_data_mover_en == 1} {	
	        connect "subsys_hps.f2h_irq0_in subsys_periph.ssgdma_interrupt"
          set_connection_parameter_value subsys_hps.f2h_irq0_in/subsys_periph.ssgdma_interrupt irqNumber {2}
        }
      }
    }
    if {$fpga_data_mover_en == 1} {	
      connect_map "subsys_periph.ssgdma_host ext_hps_f2sdram_master.windowed_slave 0x0"
      connect_map "subsys_periph.ssgdma_h2d0 ext_hps_f2sdram_master.windowed_slave 0x0"
    }
}

if {$hps_usb0_en == 1 | $hps_usb1_en == 1} {
     connect "rst_in.out_reset subsys_hps.usb31_phy_reconfig_rst 
              clk_100.out_clk subsys_hps.usb31_phy_reconfig_clk 
             "
	if {$lwh2f_width > 0} {		 
     connect_map "subsys_hps.lwhps2fpga subsys_hps.usb31_phy_reconfig_slave 0x80_0000"
}
}


if {$sub_fpga_rgmii_en == 1} {
   connect "subsys_fpga_rgmii.hps_gmii subsys_hps.emac1
            clk_100.out_clk   subsys_fpga_rgmii.clk
            rst_in.out_reset  subsys_fpga_rgmii.reset
           "
}

# ---------------- Exported Interfaces ----------------------------------------#
export clk_100 in_clk clk_100
export rst_in in_reset reset
export subsys_hps hps_io hps_io
if {$hps_usb0_en == 1 | $hps_usb1_en == 1} {
export gts_inst o_pma_cu_clk o_pma_cu_clk
export subsys_hps usb31_io usb31_io
export subsys_hps usb31_phy_pma_cpu_clk usb31_phy_pma_cpu_clk
export subsys_hps usb31_phy_refclk_p usb31_phy_refclk_p
export subsys_hps usb31_phy_refclk_n usb31_phy_refclk_n
export subsys_hps usb31_phy_rx_serial_n usb31_phy_rx_serial_n
export subsys_hps usb31_phy_rx_serial_p usb31_phy_rx_serial_p
export subsys_hps usb31_phy_tx_serial_n usb31_phy_tx_serial_n
export subsys_hps usb31_phy_tx_serial_p usb31_phy_tx_serial_p
}

if {$reset_watchdog_en == 1} {
export subsys_hps h2f_watchdog_reset h2f_watchdog_reset
}

# h2f_warm_reset_handshake conduit is exposed when the f2sdram bridge is enabled
if {$f2sdram_width > 0} {
export subsys_hps h2f_warm_reset_handshake h2f_warm_reset_handshake
}
					 
if {$reset_h2f_cold_en == 1} {
export subsys_hps h2f_cold_reset h2f_cold_reset
}

if {$hps_emif_en == 1} {
export subsys_hps emif_hps_emif_mem_0 emif_hps_emif_mem_0
export subsys_hps emif_hps_emif_oct_0 emif_hps_emif_oct_0
export subsys_hps emif_hps_emif_ref_clk_0 emif_hps_emif_ref_clk_0
export subsys_hps emif_hps_emif_mem_ck_0 emif_hps_emif_mem_ck_0
export subsys_hps emif_hps_emif_mem_reset_n emif_hps_emif_mem_reset_n

if {($hps_emif_channel == 2) && ($emif_topology == 2)} {
export subsys_hps emif_hps_emif_mem_1 emif_hps_emif_mem_1
export subsys_hps emif_hps_emif_oct_1 emif_hps_emif_oct_1
}
}

if {$clk_gate_en == 1} {
export clkctrl_0 clkctrl_input clkctrl_input
export clkctrl_0 clkctrl_output clkctrl_output
}

if {$tsn_en == 1} {
		
		export subsys_tsn phy_0_gmii8b_tx_clkin phy_0_gmii8b_tx_clkin
		export subsys_tsn phy_0_gmii8b_tx_rst_n phy_0_gmii8b_tx_rst_n
		export subsys_tsn phy_0_gmii8b_rx_rst_n phy_0_gmii8b_rx_rst_n
		export subsys_tsn phy_0_gmii8b_rx_clkout phy_0_gmii8b_rx_clkout
		export subsys_tsn phy_0_gmii8b_tx_clkout phy_0_gmii8b_tx_clkout
		export subsys_tsn phy_0_tx_clkout phy_0_tx_clkout 
       	 	export subsys_tsn phy_0_rx_clkout phy_0_rx_clkout
		export subsys_tsn phy_0_rx_digitalreset phy_0_rx_digitalreset
		export subsys_tsn phy_0_tx_digitalreset phy_0_tx_digitalreset
		export subsys_tsn phy_0_gmii8b_mac_txen phy_0_gmii8b_mac_txen
		export subsys_tsn phy_0_gmii8b_mac_tx_d phy_0_gmii8b_mac_tx_d
		export subsys_tsn phy_0_gmii8b_mac_txer phy_0_gmii8b_mac_txer
		export subsys_tsn phy_0_gmii8b_mac_rxdv phy_0_gmii8b_mac_rxdv
		export subsys_tsn phy_0_gmii8b_mac_rxd phy_0_gmii8b_mac_rxd
		export subsys_tsn phy_0_gmii8b_mac_rxer phy_0_gmii8b_mac_rxer
		export subsys_tsn phy_0_gmii8b_mac_speed phy_0_gmii8b_mac_speed
		export subsys_tsn phy_0_operating_speed phy_0_operating_speed
		export subsys_tsn phy_0_mrphy_pll_lock phy_0_mrphy_pll_lock
		export subsys_tsn phy_0_i_src_ch_pause_request phy_0_i_src_ch_pause_request
		export subsys_tsn phy_0_o_src_ch_pause_grant phy_0_o_src_ch_pause_grant
		export subsys_tsn phy_0_i_rst_n phy_0_i_rst_n
		export subsys_tsn phy_0_o_rst_ack_n phy_0_o_rst_ack_n
		export subsys_tsn phy_0_i_tx_rst_n phy_0_i_tx_rst_n
		export subsys_tsn phy_0_i_rx_rst_n phy_0_i_rx_rst_n
		export subsys_tsn phy_0_o_tx_rst_ack_n phy_0_o_tx_rst_ack_n
		export subsys_tsn phy_0_o_rx_rst_ack_n phy_0_o_rx_rst_ack_n
		export subsys_tsn phy_0_tx_ready phy_0_tx_ready
		export subsys_tsn phy_0_rx_ready phy_0_rx_ready
		export subsys_tsn phy_0_xcvr_mode phy_0_xcvr_mode
		export subsys_tsn phy_0_i_pma_cu_clk phy_0_i_pma_cu_clk
		export subsys_tsn phy_0_i_system_pll_lock phy_0_i_system_pll_lock
		export subsys_tsn intel_mge_phy_0_i_src_rs_grant phy_0_i_src_rs_grant
		export subsys_tsn phy_0_o_src_rs_req phy_0_o_src_rs_req
		export subsys_tsn phy_0_tx_serial_data phy_0_tx_serial_data
		export subsys_tsn phy_0_tx_serial_data_n phy_0_tx_serial_data_n
		export subsys_tsn phy_0_rx_serial_data phy_0_rx_serial_data
		export subsys_tsn phy_0_rx_serial_data_n phy_0_rx_serial_data_n
		export subsys_tsn phy_0_rx_is_lockedtodata phy_0_rx_is_lockedtodata
		export subsys_tsn phy_0_rx_cdr_refclk_p phy_0_rx_cdr_refclk_p
		export subsys_tsn phy_0_tx_pll_refclk_p phy_0_tx_pll_refclk_p
		export subsys_tsn intel_systemclk_gts_0_refclk_xcvr intel_systemclk_gts_0_refclk_xcvr
		export subsys_tsn intel_systemclk_gts_0_o_pll_lock intel_systemclk_gts_0_o_pll_lock
		export subsys_tsn i_refclk_rdy i_refclk_rdy
		export subsys_tsn intel_mge_phy_0_reconfig rsif0
		# export subsys_tsn intel_srcss_gts_0_o_src_rs_grant  srcss_o_src_rs_grant
		# export subsys_tsn intel_srcss_gts_0_i_src_rs_priority  srcss_i_src_rs_priority
		# export subsys_tsn intel_srcss_gts_0_i_src_rs_req  srcss_i_src_rs_req
		# export subsys_tsn intel_srcss_gts_0_o_pma_cu_clk srcss_o_pma_cu_clk
		export gts_inst o_src_rs_grant o_src_rs_grant
		export gts_inst i_src_rs_priority i_src_rs_priority
		export gts_inst i_src_rs_req i_src_rs_req
		export gts_inst o_pma_cu_clk o_pma_cu_clk
		export subsys_tsn mm_bridge_0_m0 mm_bridge_0_m0
		export subsys_tsn iopll_locked iopll_locked
		export subsys_tsn iopll_reset iopll_reset 
		if {$tsn_concurrent == 0} {
		export subsys_tsn mm_bridge_0140_017f_m0 mm_bridge_0140_017f_m0 
		export subsys_tsn mm_bridge_0180_01ff_m0 mm_bridge_0180_01ff_m0
		export subsys_tsn mm_bridge_0200_02ff_m0 mm_bridge_0200_02ff_m0
		export subsys_tsn mm_bridge_0380_03ff_m0 mm_bridge_0380_03ff_m0
		export subsys_tsn mm_bridge_0400_07ff_m0 mm_bridge_0400_07ff_m0
		}
		export subsys_tsn phy_rst phy_rst
		export subsys_tsn avmm_reset avmm_reset
		export subsys_tsn ninit_done ninit_done
		

			 if {$tsn_concurrent == 1} {
				
				export subsys_tsn mm_bridge_0140_017f_m0 mm_bridge_0140_017f_m0
				export subsys_tsn mm_bridge_01c0_01ff_m0 mm_bridge_01c0_01ff_m0
				export subsys_tsn mm_bridge_0240_027f_m0 mm_bridge_0240_027f_m0
				export subsys_tsn mm_bridge_0280_02ff_m0 mm_bridge_0280_02ff_m0
				export subsys_tsn mm_bridge_0380_03ff_m0 mm_bridge_0380_03ff_m0
				export subsys_tsn mm_bridge_0400_04ff_m0 mm_bridge_0400_04ff_m0
				export subsys_tsn mm_bridge_0500_05ff_m0 mm_bridge_0500_05ff_m0
				export subsys_tsn mm_bridge_0600_06ff_m0 mm_bridge_0600_06ff_m0
				export subsys_tsn phy_1_gmii8b_tx_clkin phy_1_gmii8b_tx_clkin
				export subsys_tsn phy_2_gmii8b_tx_clkin phy_2_gmii8b_tx_clkin
				
				export subsys_tsn phy_1_gmii8b_tx_clkin phy_1_gmii8b_tx_clkin
				export subsys_tsn phy_1_gmii8b_tx_rst_n phy_1_gmii8b_tx_rst_n
				export subsys_tsn phy_1_gmii8b_rx_rst_n phy_1_gmii8b_rx_rst_n
				export subsys_tsn phy_1_tx_clkout phy_1_tx_clkout 
				export subsys_tsn phy_1_rx_clkout phy_1_rx_clkout
				export subsys_tsn phy_1_gmii8b_rx_clkout phy_1_gmii8b_rx_clkout
				export subsys_tsn phy_1_gmii8b_tx_clkout phy_1_gmii8b_tx_clkout
				export subsys_tsn phy_1_rx_digitalreset phy_1_rx_digitalreset
				export subsys_tsn phy_1_tx_digitalreset phy_1_tx_digitalreset
				export subsys_tsn phy_1_gmii8b_mac_txen phy_1_gmii8b_mac_txen
				export subsys_tsn phy_1_gmii8b_mac_tx_d phy_1_gmii8b_mac_tx_d
				export subsys_tsn phy_1_gmii8b_mac_txer phy_1_gmii8b_mac_txer
				export subsys_tsn phy_1_gmii8b_mac_rxdv phy_1_gmii8b_mac_rxdv
				export subsys_tsn phy_1_gmii8b_mac_rxd phy_1_gmii8b_mac_rxd
				export subsys_tsn phy_1_gmii8b_mac_rxer phy_1_gmii8b_mac_rxer
				export subsys_tsn phy_1_gmii8b_mac_speed phy_1_gmii8b_mac_speed
				export subsys_tsn phy_1_operating_speed phy_1_operating_speed
				export subsys_tsn phy_1_mrphy_pll_lock phy_1_mrphy_pll_lock
				export subsys_tsn phy_1_i_src_ch_pause_request phy_1_i_src_ch_pause_request
				export subsys_tsn phy_1_o_src_ch_pause_grant phy_1_o_src_ch_pause_grant
				export subsys_tsn phy_1_i_rst_n phy_1_i_rst_n
				export subsys_tsn phy_1_o_rst_ack_n phy_1_o_rst_ack_n
				export subsys_tsn phy_1_i_tx_rst_n phy_1_i_tx_rst_n
				export subsys_tsn phy_1_i_rx_rst_n phy_1_i_rx_rst_n
				export subsys_tsn phy_1_o_tx_rst_ack_n phy_1_o_tx_rst_ack_n
				export subsys_tsn phy_1_o_rx_rst_ack_n phy_1_o_rx_rst_ack_n
				export subsys_tsn phy_1_tx_ready phy_1_tx_ready
				export subsys_tsn phy_1_rx_ready phy_1_rx_ready
				export subsys_tsn phy_1_xcvr_mode phy_1_xcvr_mode
				export subsys_tsn phy_1_i_pma_cu_clk phy_1_i_pma_cu_clk
				export subsys_tsn phy_1_i_system_pll_lock phy_1_i_system_pll_lock
				export subsys_tsn intel_mge_phy_1_i_src_rs_grant phy_1_i_src_rs_grant
				export subsys_tsn phy_1_o_src_rs_req phy_1_o_src_rs_req
				export subsys_tsn phy_1_tx_serial_data phy_1_tx_serial_data
				export subsys_tsn phy_1_tx_serial_data_n phy_1_tx_serial_data_n
				export subsys_tsn phy_1_rx_serial_data phy_1_rx_serial_data
				export subsys_tsn phy_1_rx_serial_data_n phy_1_rx_serial_data_n
				export subsys_tsn phy_1_rx_is_lockedtodata phy_1_rx_is_lockedtodata
				export subsys_tsn phy_1_rx_cdr_refclk_p phy_1_rx_cdr_refclk_p
				export subsys_tsn phy_1_tx_pll_refclk_p phy_1_tx_pll_refclk_p
				export subsys_tsn phy_2_gmii8b_tx_clkin phy_2_gmii8b_tx_clkin
				export subsys_tsn phy_2_gmii8b_tx_rst_n phy_2_gmii8b_tx_rst_n
				export subsys_tsn phy_2_gmii8b_rx_rst_n phy_2_gmii8b_rx_rst_n
			    export subsys_tsn phy_2_tx_clkout phy_2_tx_clkout 
       	 	    export subsys_tsn phy_2_rx_clkout phy_2_rx_clkout
				export subsys_tsn phy_2_gmii8b_rx_clkout phy_2_gmii8b_rx_clkout
				export subsys_tsn phy_2_gmii8b_tx_clkout phy_2_gmii8b_tx_clkout
				export subsys_tsn phy_2_rx_digitalreset phy_2_rx_digitalreset
				export subsys_tsn phy_2_tx_digitalreset phy_2_tx_digitalreset
				export subsys_tsn phy_2_gmii8b_mac_txen phy_2_gmii8b_mac_txen
				export subsys_tsn phy_2_gmii8b_mac_tx_d phy_2_gmii8b_mac_tx_d
				export subsys_tsn phy_2_gmii8b_mac_txer phy_2_gmii8b_mac_txer
				export subsys_tsn phy_2_gmii8b_mac_rxdv phy_2_gmii8b_mac_rxdv
				export subsys_tsn phy_2_gmii8b_mac_rxd phy_2_gmii8b_mac_rxd
				export subsys_tsn phy_2_gmii8b_mac_rxer phy_2_gmii8b_mac_rxer
				export subsys_tsn phy_2_gmii8b_mac_speed phy_2_gmii8b_mac_speed
				export subsys_tsn phy_2_operating_speed phy_2_operating_speed
				export subsys_tsn phy_2_mrphy_pll_lock phy_2_mrphy_pll_lock
				export subsys_tsn phy_2_i_src_ch_pause_request phy_2_i_src_ch_pause_request
				export subsys_tsn phy_2_o_src_ch_pause_grant phy_2_o_src_ch_pause_grant
				export subsys_tsn phy_2_i_rst_n phy_2_i_rst_n
				export subsys_tsn phy_2_o_rst_ack_n phy_2_o_rst_ack_n
				export subsys_tsn phy_2_i_tx_rst_n phy_2_i_tx_rst_n
				export subsys_tsn phy_2_i_rx_rst_n phy_2_i_rx_rst_n
				export subsys_tsn phy_2_o_tx_rst_ack_n phy_2_o_tx_rst_ack_n
				export subsys_tsn phy_2_o_rx_rst_ack_n phy_2_o_rx_rst_ack_n
				export subsys_tsn phy_2_tx_ready phy_2_tx_ready
				export subsys_tsn phy_2_rx_ready phy_2_rx_ready
				export subsys_tsn phy_2_xcvr_mode phy_2_xcvr_mode
				export subsys_tsn phy_2_i_pma_cu_clk phy_2_i_pma_cu_clk
				export subsys_tsn phy_2_i_system_pll_lock phy_2_i_system_pll_lock
				export subsys_tsn intel_mge_phy_2_i_src_rs_grant phy_2_i_src_rs_grant
				export subsys_tsn phy_2_o_src_rs_req phy_2_o_src_rs_req
				export subsys_tsn phy_2_tx_serial_data phy_2_tx_serial_data
				export subsys_tsn phy_2_tx_serial_data_n phy_2_tx_serial_data_n
				export subsys_tsn phy_2_rx_serial_data phy_2_rx_serial_data
				export subsys_tsn phy_2_rx_serial_data_n phy_2_rx_serial_data_n
				export subsys_tsn phy_2_rx_is_lockedtodata phy_2_rx_is_lockedtodata
				export subsys_tsn phy_2_rx_cdr_refclk_p phy_2_rx_cdr_refclk_p
				export subsys_tsn phy_2_tx_pll_refclk_p phy_2_tx_pll_refclk_p
				export subsys_tsn intel_mge_phy_1_reconfig rsif1
				export subsys_tsn intel_mge_phy_2_reconfig rsif2
				
				export subsys_phymgmt phy_clk  phy_clk
				export subsys_phymgmt i2c_interrupt_sender  i2c_interrupt_sender
				export subsys_phymgmt i2c_serial  i2c_serial
				export subsys_phymgmt i2c_csr  i2c_csr
				export subsys_phymgmt phy_reset phy_reset 
				
			 }
}
if {$sub_hps_en == 1} {
		if {$tsn_en == 1} {
		
		export subsys_hps h2f_reset h2f_reset
		export subsys_hps hps_io hps_io
		
		export subsys_hps emac0 emac0
		export subsys_hps emac0_mdio emac0_mdio
		
		export subsys_hps emac_ptp_clk emac_ptp_clk
		export subsys_hps emac_timestamp_clk emac_timestamp_clk
		export subsys_hps emac_timestamp_data emac_timestamp_data
		export subsys_hps emac0_ptp emac0_ptp
		#export subsys_hps fpga2hps_interrupt fpga2hps_interrupt
	

			if {$tsn_concurrent == 1} {
				export subsys_hps emac1_ptp emac1_ptp
				export subsys_hps emac2_ptp emac2_ptp
				
				export subsys_hps emac1 emac1
				#export subsys_hps emac1_mdio emac1_mdio
				export subsys_hps emac2 emac2
				#export subsys_hps emac2_mdio emac2_mdio	
		}
	}
}


if {$sub_peri_en == 1} {
if {$fpga_button_pio_width >0} {
export subsys_periph button_pio_external_connection button_pio_external_connection
}
if {$fpga_dipsw_pio_width >0} {
export subsys_periph dipsw_pio_external_connection dipsw_pio_external_connection
}
if {$fpga_led_pio_width >0} {
export subsys_periph led_pio_external_connection led_pio_external_connection
}
}

if {$sub_fpga_rgmii_en == 1} {
export subsys_fpga_rgmii phy_rgmii phy_rgmii
export subsys_hps emac_timestamp_clk emac_timestamp_clk
export subsys_hps emac_ptp_clk emac_ptp_clk
export subsys_hps emac1_mdio emac1_mdio
}

if {($hps_f2h_irq_en == 1) && ($sub_hps_en == 1)} {
export subsys_hps f2h_irq1_in f2h_irq1_in
}


# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {4}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_domain_assignment {$system} {qsys_mm.burstAdapterImplementation} {PER_BURST_TYPE_CONVERTER}

sync_sysinfo_parameters 
save_system ${qsys_name}.qsys
sync_sysinfo_parameters
save_system ${qsys_name}.qsys

