package require -exact qsys 23.4

# create the system "hps_subsys"
proc do_create_hps_subsys {} {
	# create the system
	create_system hps_subsys
	set_project_property BOARD {default}
	set_project_property DEVICE {A5ED065BB32AE5SR0}
	set_project_property DEVICE_FAMILY {Agilex 5}
	set_project_property HIDE_FROM_IP_CATALOG {false}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_component agilex_hps ip/hps_subsys/agilex_hps.ip intel_agilex_5_soc intel_agilex_5_soc_inst 2.0.0
	load_component agilex_hps
	set_component_parameter_value ATB_Enable {0}
	set_component_parameter_value CM_Mode {N/A}
	set_component_parameter_value CM_PinMuxing {Unused}
	set_component_parameter_value CTI_Enable {0}
	set_component_parameter_value DMA_Enable {No}
	set_component_parameter_value Debug_APB_Enable {0}
	set_component_parameter_value EMAC0_Mode {RGMII_with_MDIO}
	set_component_parameter_value EMAC0_PTP {0}
	set_component_parameter_value EMAC0_PinMuxing {FPGA}
	set_component_parameter_value EMAC1_Mode {N/A}
	set_component_parameter_value EMAC1_PTP {0}
	set_component_parameter_value EMAC1_PinMuxing {Unused}
	set_component_parameter_value EMAC2_Mode {N/A}
	set_component_parameter_value EMAC2_PTP {0}
	set_component_parameter_value EMAC2_PinMuxing {Unused}
	set_component_parameter_value EMIF_AXI_Enable {1}
	set_component_parameter_value EMIF_Topology {0}
	set_component_parameter_value F2H_IRQ_Enable {1}
	set_component_parameter_value F2H_free_clk_mhz {200}
	set_component_parameter_value F2H_free_clock_enable {0}
	set_component_parameter_value FPGA_EMAC0_gtx_clk_mhz {125.0}
	set_component_parameter_value FPGA_EMAC0_md_clk_mhz {2.5}
	set_component_parameter_value FPGA_EMAC1_gtx_clk_mhz {125.0}
	set_component_parameter_value FPGA_EMAC1_md_clk_mhz {2.5}
	set_component_parameter_value FPGA_EMAC2_gtx_clk_mhz {125.0}
	set_component_parameter_value FPGA_EMAC2_md_clk_mhz {2.5}
	set_component_parameter_value FPGA_I2C0_sclk_mhz {125.0}
	set_component_parameter_value FPGA_I2C1_sclk_mhz {125.0}
	set_component_parameter_value FPGA_I2CEMAC0_clk_mhz {125.0}
	set_component_parameter_value FPGA_I2CEMAC1_clk_mhz {125.0}
	set_component_parameter_value FPGA_I2CEMAC2_clk_mhz {125.0}
	set_component_parameter_value FPGA_I3C0_sclk_mhz {125.0}
	set_component_parameter_value FPGA_I3C1_sclk_mhz {125.0}
	set_component_parameter_value FPGA_SPIM0_sclk_mhz {125.0}
	set_component_parameter_value FPGA_SPIM1_sclk_mhz {125.0}
	set_component_parameter_value GP_Enable {0}
	set_component_parameter_value H2F_Address_Width {38}
	set_component_parameter_value H2F_IRQ_DMA_Enable0 {0}
	set_component_parameter_value H2F_IRQ_DMA_Enable1 {0}
	set_component_parameter_value H2F_IRQ_ECC_SERR_Enable {0}
	set_component_parameter_value H2F_IRQ_EMAC0_Enable {0}
	set_component_parameter_value H2F_IRQ_EMAC1_Enable {0}
	set_component_parameter_value H2F_IRQ_EMAC2_Enable {0}
	set_component_parameter_value H2F_IRQ_GPIO0_Enable {0}
	set_component_parameter_value H2F_IRQ_GPIO1_Enable {0}
	set_component_parameter_value H2F_IRQ_I2C0_Enable {0}
	set_component_parameter_value H2F_IRQ_I2C1_Enable {0}
	set_component_parameter_value H2F_IRQ_I2CEMAC0_Enable {0}
	set_component_parameter_value H2F_IRQ_I2CEMAC1_Enable {0}
	set_component_parameter_value H2F_IRQ_I2CEMAC2_Enable {0}
	set_component_parameter_value H2F_IRQ_I3C0_Enable {0}
	set_component_parameter_value H2F_IRQ_I3C1_Enable {0}
	set_component_parameter_value H2F_IRQ_L4Timer_Enable {0}
	set_component_parameter_value H2F_IRQ_NAND_Enable {0}
	set_component_parameter_value H2F_IRQ_PeriphClock_Enable {0}
	set_component_parameter_value H2F_IRQ_SDMMC_Enable {0}
	set_component_parameter_value H2F_IRQ_SPIM0_Enable {0}
	set_component_parameter_value H2F_IRQ_SPIM1_Enable {0}
	set_component_parameter_value H2F_IRQ_SPIS0_Enable {0}
	set_component_parameter_value H2F_IRQ_SPIS1_Enable {0}
	set_component_parameter_value H2F_IRQ_SYSTimer_Enable {0}
	set_component_parameter_value H2F_IRQ_UART0_Enable {0}
	set_component_parameter_value H2F_IRQ_UART1_Enable {0}
	set_component_parameter_value H2F_IRQ_USB0_Enable {0}
	set_component_parameter_value H2F_IRQ_USB1_Enable {0}
	set_component_parameter_value H2F_IRQ_Watchdog_Enable {0}
	set_component_parameter_value H2F_Width {0}
	set_component_parameter_value HPS_IO_Enable {unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused}
	set_component_parameter_value I2C0_Mode {N/A}
	set_component_parameter_value I2C0_PinMuxing {Unused}
	set_component_parameter_value I2C1_Mode {N/A}
	set_component_parameter_value I2C1_PinMuxing {Unused}
	set_component_parameter_value I2CEMAC0_Mode {N/A}
	set_component_parameter_value I2CEMAC0_PinMuxing {Unused}
	set_component_parameter_value I2CEMAC1_Mode {N/A}
	set_component_parameter_value I2CEMAC1_PinMuxing {Unused}
	set_component_parameter_value I2CEMAC2_Mode {N/A}
	set_component_parameter_value I2CEMAC2_PinMuxing {Unused}
	set_component_parameter_value I3C0_Mode {N/A}
	set_component_parameter_value I3C0_PinMuxing {Unused}
	set_component_parameter_value I3C1_Mode {N/A}
	set_component_parameter_value I3C1_PinMuxing {Unused}
	set_component_parameter_value IO_INPUT_DELAY0 {-1}
	set_component_parameter_value IO_INPUT_DELAY1 {-1}
	set_component_parameter_value IO_INPUT_DELAY10 {-1}
	set_component_parameter_value IO_INPUT_DELAY11 {-1}
	set_component_parameter_value IO_INPUT_DELAY12 {-1}
	set_component_parameter_value IO_INPUT_DELAY13 {-1}
	set_component_parameter_value IO_INPUT_DELAY14 {-1}
	set_component_parameter_value IO_INPUT_DELAY15 {-1}
	set_component_parameter_value IO_INPUT_DELAY16 {-1}
	set_component_parameter_value IO_INPUT_DELAY17 {-1}
	set_component_parameter_value IO_INPUT_DELAY18 {-1}
	set_component_parameter_value IO_INPUT_DELAY19 {-1}
	set_component_parameter_value IO_INPUT_DELAY2 {-1}
	set_component_parameter_value IO_INPUT_DELAY20 {-1}
	set_component_parameter_value IO_INPUT_DELAY21 {-1}
	set_component_parameter_value IO_INPUT_DELAY22 {-1}
	set_component_parameter_value IO_INPUT_DELAY23 {-1}
	set_component_parameter_value IO_INPUT_DELAY24 {-1}
	set_component_parameter_value IO_INPUT_DELAY25 {-1}
	set_component_parameter_value IO_INPUT_DELAY26 {-1}
	set_component_parameter_value IO_INPUT_DELAY27 {-1}
	set_component_parameter_value IO_INPUT_DELAY28 {-1}
	set_component_parameter_value IO_INPUT_DELAY29 {-1}
	set_component_parameter_value IO_INPUT_DELAY3 {-1}
	set_component_parameter_value IO_INPUT_DELAY30 {-1}
	set_component_parameter_value IO_INPUT_DELAY31 {-1}
	set_component_parameter_value IO_INPUT_DELAY32 {-1}
	set_component_parameter_value IO_INPUT_DELAY33 {-1}
	set_component_parameter_value IO_INPUT_DELAY34 {-1}
	set_component_parameter_value IO_INPUT_DELAY35 {-1}
	set_component_parameter_value IO_INPUT_DELAY36 {-1}
	set_component_parameter_value IO_INPUT_DELAY37 {-1}
	set_component_parameter_value IO_INPUT_DELAY38 {-1}
	set_component_parameter_value IO_INPUT_DELAY39 {-1}
	set_component_parameter_value IO_INPUT_DELAY4 {-1}
	set_component_parameter_value IO_INPUT_DELAY40 {-1}
	set_component_parameter_value IO_INPUT_DELAY41 {-1}
	set_component_parameter_value IO_INPUT_DELAY42 {-1}
	set_component_parameter_value IO_INPUT_DELAY43 {-1}
	set_component_parameter_value IO_INPUT_DELAY44 {-1}
	set_component_parameter_value IO_INPUT_DELAY45 {-1}
	set_component_parameter_value IO_INPUT_DELAY46 {-1}
	set_component_parameter_value IO_INPUT_DELAY47 {-1}
	set_component_parameter_value IO_INPUT_DELAY5 {-1}
	set_component_parameter_value IO_INPUT_DELAY6 {-1}
	set_component_parameter_value IO_INPUT_DELAY7 {-1}
	set_component_parameter_value IO_INPUT_DELAY8 {-1}
	set_component_parameter_value IO_INPUT_DELAY9 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY0 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY1 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY10 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY11 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY12 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY13 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY14 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY15 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY16 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY17 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY18 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY19 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY2 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY20 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY21 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY22 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY23 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY24 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY25 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY26 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY27 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY28 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY29 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY3 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY30 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY31 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY32 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY33 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY34 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY35 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY36 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY37 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY38 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY39 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY4 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY40 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY41 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY42 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY43 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY44 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY45 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY46 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY47 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY5 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY6 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY7 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY8 {-1}
	set_component_parameter_value IO_OUTPUT_DELAY9 {-1}
	set_component_parameter_value JTAG_Enable {0}
	set_component_parameter_value LWH2F_Address_Width {29}
	set_component_parameter_value LWH2F_Width {32}
	set_component_parameter_value MPLL_C0_Override_mhz {1600.0}
	set_component_parameter_value MPLL_C1_Override_mhz {800.0}
	set_component_parameter_value MPLL_C2_Override_mhz {1066.67}
	set_component_parameter_value MPLL_C3_Override_mhz {400.0}
	set_component_parameter_value MPLL_Clock_Source {0}
	set_component_parameter_value MPLL_Override {0}
	set_component_parameter_value MPLL_VCO_Override_mhz {3200.0}
	set_component_parameter_value MPU_Events_Enable {0}
	set_component_parameter_value MPU_clk_ccu_div {1}
	set_component_parameter_value MPU_clk_freq_override_mhz {1066.67}
	set_component_parameter_value MPU_clk_override {0}
	set_component_parameter_value MPU_clk_periph_div {1}
	set_component_parameter_value MPU_clk_src_override {2}
	set_component_parameter_value MPU_core01_src_override {1}
	set_component_parameter_value MPU_core0_freq_override_mhz {1033.33}
	set_component_parameter_value MPU_core1_freq_override_mhz {800.0}
	set_component_parameter_value MPU_core23_src_override {0}
	set_component_parameter_value MPU_core2_freq_override_mhz {1600.0}
	set_component_parameter_value MPU_core3_freq_override_mhz {1600.0}
	set_component_parameter_value NAND_Mode {N/A}
	set_component_parameter_value NAND_PinMuxing {Unused}
	set_component_parameter_value NOC_clk_cs_debug_div {4}
	set_component_parameter_value NOC_clk_cs_div {1}
	set_component_parameter_value NOC_clk_cs_trace_div {4}
	set_component_parameter_value NOC_clk_free_l4_div {4}
	set_component_parameter_value NOC_clk_periph_l4_div {2}
	set_component_parameter_value NOC_clk_phy_div {4}
	set_component_parameter_value NOC_clk_slow_l4_div {4}
	set_component_parameter_value NOC_clk_src_select {3}
	set_component_parameter_value PLL_CLK0 {Unused}
	set_component_parameter_value PLL_CLK1 {Unused}
	set_component_parameter_value PLL_CLK2 {Unused}
	set_component_parameter_value PLL_CLK3 {Unused}
	set_component_parameter_value PLL_CLK4 {Unused}
	set_component_parameter_value PPLL_C0_Override_mhz {1600.0}
	set_component_parameter_value PPLL_C1_Override_mhz {800.0}
	set_component_parameter_value PPLL_C2_Override_mhz {1066.67}
	set_component_parameter_value PPLL_C3_Override_mhz {400.0}
	set_component_parameter_value PPLL_Clock_Source {0}
	set_component_parameter_value PPLL_Override {0}
	set_component_parameter_value PPLL_VCO_Override_mhz {3200.0}
	set_component_parameter_value Periph_clk_emac0_sel {50}
	set_component_parameter_value Periph_clk_emac1_sel {50}
	set_component_parameter_value Periph_clk_emac2_sel {50}
	set_component_parameter_value Periph_clk_override {0}
	set_component_parameter_value Periph_emac_ptp_freq_override {400.0}
	set_component_parameter_value Periph_emac_ptp_src_override {7}
	set_component_parameter_value Periph_emaca_src_override {7}
	set_component_parameter_value Periph_emacb_src_override {7}
	set_component_parameter_value Periph_gpio_freq_override {400.0}
	set_component_parameter_value Periph_gpio_src_override {3}
	set_component_parameter_value Periph_psi_freq_override {500.0}
	set_component_parameter_value Periph_psi_src_override {7}
	set_component_parameter_value Periph_usb_freq_override {20.0}
	set_component_parameter_value Periph_usb_src_override {3}
	set_component_parameter_value Pwr_a55_core0_1_on {1}
	set_component_parameter_value Pwr_a76_core2_on {1}
	set_component_parameter_value Pwr_a76_core3_on {1}
	set_component_parameter_value Pwr_boot_core_sel {0}
	set_component_parameter_value Pwr_cpu_app_select {0}
	set_component_parameter_value Pwr_mpu_l3_cache_size {2}
	set_component_parameter_value Rst_h2f_cold_en {0}
	set_component_parameter_value Rst_hps_warm_en {0}
	set_component_parameter_value Rst_sdm_wd_config {0}
	set_component_parameter_value Rst_watchdog_en {0}
	set_component_parameter_value SDMMC_Mode {N/A}
	set_component_parameter_value SDMMC_PinMuxing {Unused}
	set_component_parameter_value SPIM0_Mode {N/A}
	set_component_parameter_value SPIM0_PinMuxing {Unused}
	set_component_parameter_value SPIM1_Mode {N/A}
	set_component_parameter_value SPIM1_PinMuxing {Unused}
	set_component_parameter_value SPIS0_Mode {N/A}
	set_component_parameter_value SPIS0_PinMuxing {Unused}
	set_component_parameter_value SPIS1_Mode {N/A}
	set_component_parameter_value SPIS1_PinMuxing {Unused}
	set_component_parameter_value STM_Enable {0}
	set_component_parameter_value TPIU_Select {HPS Clock Manager}
	set_component_parameter_value TRACE_Mode {N/A}
	set_component_parameter_value TRACE_PinMuxing {Unused}
	set_component_parameter_value UART0_Mode {N/A}
	set_component_parameter_value UART0_PinMuxing {Unused}
	set_component_parameter_value UART1_Mode {N/A}
	set_component_parameter_value UART1_PinMuxing {Unused}
	set_component_parameter_value USB0_Mode {N/A}
	set_component_parameter_value USB0_PinMuxing {Unused}
	set_component_parameter_value USB1_Mode {N/A}
	set_component_parameter_value USB1_PinMuxing {Unused}
	set_component_parameter_value User0_clk_enable {0}
	set_component_parameter_value User0_clk_freq {500.0}
	set_component_parameter_value User0_clk_src_select {7}
	set_component_parameter_value User1_clk_enable {0}
	set_component_parameter_value User1_clk_freq {500.0}
	set_component_parameter_value User1_clk_src_select {7}
	set_component_parameter_value eosc1_clk_mhz {25.0}
	set_component_parameter_value f2s_SMMU {0}
	set_component_parameter_value f2s_address_width {32}
	set_component_parameter_value f2s_data_width {0}
	set_component_parameter_value f2s_mode {acelite}
	set_component_parameter_value f2sdram_address_width {32}
	set_component_parameter_value f2sdram_data_width {0}
	set_component_parameter_value hps_ioa10_opd_en {0}
	set_component_parameter_value hps_ioa11_opd_en {0}
	set_component_parameter_value hps_ioa12_opd_en {0}
	set_component_parameter_value hps_ioa13_opd_en {0}
	set_component_parameter_value hps_ioa14_opd_en {0}
	set_component_parameter_value hps_ioa15_opd_en {0}
	set_component_parameter_value hps_ioa16_opd_en {0}
	set_component_parameter_value hps_ioa17_opd_en {0}
	set_component_parameter_value hps_ioa18_opd_en {0}
	set_component_parameter_value hps_ioa19_opd_en {0}
	set_component_parameter_value hps_ioa1_opd_en {0}
	set_component_parameter_value hps_ioa20_opd_en {0}
	set_component_parameter_value hps_ioa21_opd_en {0}
	set_component_parameter_value hps_ioa22_opd_en {0}
	set_component_parameter_value hps_ioa23_opd_en {0}
	set_component_parameter_value hps_ioa24_opd_en {0}
	set_component_parameter_value hps_ioa2_opd_en {0}
	set_component_parameter_value hps_ioa3_opd_en {0}
	set_component_parameter_value hps_ioa4_opd_en {0}
	set_component_parameter_value hps_ioa5_opd_en {0}
	set_component_parameter_value hps_ioa6_opd_en {0}
	set_component_parameter_value hps_ioa7_opd_en {0}
	set_component_parameter_value hps_ioa8_opd_en {0}
	set_component_parameter_value hps_ioa9_opd_en {0}
	set_component_parameter_value hps_iob10_opd_en {0}
	set_component_parameter_value hps_iob11_opd_en {0}
	set_component_parameter_value hps_iob12_opd_en {0}
	set_component_parameter_value hps_iob13_opd_en {0}
	set_component_parameter_value hps_iob14_opd_en {0}
	set_component_parameter_value hps_iob15_opd_en {0}
	set_component_parameter_value hps_iob16_opd_en {0}
	set_component_parameter_value hps_iob17_opd_en {0}
	set_component_parameter_value hps_iob18_opd_en {0}
	set_component_parameter_value hps_iob19_opd_en {0}
	set_component_parameter_value hps_iob1_opd_en {0}
	set_component_parameter_value hps_iob20_opd_en {0}
	set_component_parameter_value hps_iob21_opd_en {0}
	set_component_parameter_value hps_iob22_opd_en {0}
	set_component_parameter_value hps_iob23_opd_en {0}
	set_component_parameter_value hps_iob24_opd_en {0}
	set_component_parameter_value hps_iob2_opd_en {0}
	set_component_parameter_value hps_iob3_opd_en {0}
	set_component_parameter_value hps_iob4_opd_en {0}
	set_component_parameter_value hps_iob5_opd_en {0}
	set_component_parameter_value hps_iob6_opd_en {0}
	set_component_parameter_value hps_iob7_opd_en {0}
	set_component_parameter_value hps_iob8_opd_en {0}
	set_component_parameter_value hps_iob9_opd_en {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation agilex_hps
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface h2f_reset reset OUTPUT
	set_instantiation_interface_parameter_value h2f_reset associatedClock {}
	set_instantiation_interface_parameter_value h2f_reset associatedDirectReset {}
	set_instantiation_interface_parameter_value h2f_reset associatedResetSinks {none}
	set_instantiation_interface_parameter_value h2f_reset synchronousEdges {NONE}
	add_instantiation_interface_port h2f_reset h2f_reset_reset_n reset_n 1 STD_LOGIC Output
	add_instantiation_interface lwhps2fpga_axi_clock clock INPUT
	set_instantiation_interface_parameter_value lwhps2fpga_axi_clock clockRate {0}
	set_instantiation_interface_parameter_value lwhps2fpga_axi_clock externallyDriven {false}
	set_instantiation_interface_parameter_value lwhps2fpga_axi_clock ptfSchematicName {}
	add_instantiation_interface_port lwhps2fpga_axi_clock lwhps2fpga_axi_clock_clk clk 1 STD_LOGIC Input
	add_instantiation_interface lwhps2fpga_axi_reset reset INPUT
	set_instantiation_interface_parameter_value lwhps2fpga_axi_reset associatedClock {}
	set_instantiation_interface_parameter_value lwhps2fpga_axi_reset synchronousEdges {NONE}
	add_instantiation_interface_port lwhps2fpga_axi_reset lwhps2fpga_axi_reset_reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface lwhps2fpga axi4 OUTPUT
	set_instantiation_interface_parameter_value lwhps2fpga associatedClock {lwhps2fpga_axi_clock}
	set_instantiation_interface_parameter_value lwhps2fpga associatedReset {lwhps2fpga_axi_reset}
	set_instantiation_interface_parameter_value lwhps2fpga combinedIssuingCapability {1}
	set_instantiation_interface_parameter_value lwhps2fpga issuesFIXEDBursts {true}
	set_instantiation_interface_parameter_value lwhps2fpga issuesINCRBursts {true}
	set_instantiation_interface_parameter_value lwhps2fpga issuesWRAPBursts {true}
	set_instantiation_interface_parameter_value lwhps2fpga maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value lwhps2fpga maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value lwhps2fpga maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value lwhps2fpga poison {false}
	set_instantiation_interface_parameter_value lwhps2fpga readIssuingCapability {1}
	set_instantiation_interface_parameter_value lwhps2fpga traceSignals {false}
	set_instantiation_interface_parameter_value lwhps2fpga trustzoneAware {true}
	set_instantiation_interface_parameter_value lwhps2fpga uniqueIdSupport {false}
	set_instantiation_interface_parameter_value lwhps2fpga wakeupSignals {false}
	set_instantiation_interface_parameter_value lwhps2fpga writeIssuingCapability {1}
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awid awid 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awaddr awaddr 29 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awlen awlen 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awsize awsize 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awburst awburst 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awlock awlock 1 STD_LOGIC Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awcache awcache 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awprot awprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awvalid awvalid 1 STD_LOGIC Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_awready awready 1 STD_LOGIC Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_wdata wdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_wstrb wstrb 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_wlast wlast 1 STD_LOGIC Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_wvalid wvalid 1 STD_LOGIC Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_wready wready 1 STD_LOGIC Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_bid bid 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_bresp bresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_bvalid bvalid 1 STD_LOGIC Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_bready bready 1 STD_LOGIC Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arid arid 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_araddr araddr 29 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arlen arlen 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arsize arsize 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arburst arburst 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arlock arlock 1 STD_LOGIC Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arcache arcache 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arprot arprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arvalid arvalid 1 STD_LOGIC Output
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_arready arready 1 STD_LOGIC Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_rid rid 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_rdata rdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_rresp rresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_rlast rlast 1 STD_LOGIC Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_rvalid rvalid 1 STD_LOGIC Input
	add_instantiation_interface_port lwhps2fpga lwhps2fpga_rready rready 1 STD_LOGIC Output
	add_instantiation_interface emac_ptp_clk clock INPUT
	set_instantiation_interface_parameter_value emac_ptp_clk clockRate {0}
	set_instantiation_interface_parameter_value emac_ptp_clk externallyDriven {false}
	set_instantiation_interface_parameter_value emac_ptp_clk ptfSchematicName {}
	add_instantiation_interface_port emac_ptp_clk emac_ptp_clk_clk clk 1 STD_LOGIC Input
	add_instantiation_interface emac_timestamp_clk clock INPUT
	set_instantiation_interface_parameter_value emac_timestamp_clk clockRate {0}
	set_instantiation_interface_parameter_value emac_timestamp_clk externallyDriven {false}
	set_instantiation_interface_parameter_value emac_timestamp_clk ptfSchematicName {}
	add_instantiation_interface_port emac_timestamp_clk emac_timestamp_clk_clk clk 1 STD_LOGIC Input
	add_instantiation_interface emac_timestamp_data conduit INPUT
	set_instantiation_interface_parameter_value emac_timestamp_data associatedClock {}
	set_instantiation_interface_parameter_value emac_timestamp_data associatedReset {}
	set_instantiation_interface_parameter_value emac_timestamp_data prSafe {false}
	add_instantiation_interface_port emac_timestamp_data emac_timestamp_data_data_in data_in 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface emac0_mdio conduit INPUT
	set_instantiation_interface_parameter_value emac0_mdio associatedClock {}
	set_instantiation_interface_parameter_value emac0_mdio associatedReset {}
	set_instantiation_interface_parameter_value emac0_mdio prSafe {false}
	add_instantiation_interface_port emac0_mdio emac0_mdio_mac_mdc mac_mdc 1 STD_LOGIC Output
	add_instantiation_interface_port emac0_mdio emac0_mdio_mac_mdi mac_mdi 1 STD_LOGIC Input
	add_instantiation_interface_port emac0_mdio emac0_mdio_mac_mdo mac_mdo 1 STD_LOGIC Output
	add_instantiation_interface_port emac0_mdio emac0_mdio_mac_mdoe mac_mdoe 1 STD_LOGIC Output
	add_instantiation_interface emac0_app_rst reset OUTPUT
	set_instantiation_interface_parameter_value emac0_app_rst associatedClock {}
	set_instantiation_interface_parameter_value emac0_app_rst associatedDirectReset {}
	set_instantiation_interface_parameter_value emac0_app_rst associatedResetSinks {none}
	set_instantiation_interface_parameter_value emac0_app_rst synchronousEdges {NONE}
	add_instantiation_interface_port emac0_app_rst emac0_app_rst_reset_n reset_n 1 STD_LOGIC Output
	add_instantiation_interface emac0 conduit INPUT
	set_instantiation_interface_parameter_value emac0 associatedClock {}
	set_instantiation_interface_parameter_value emac0 associatedReset {}
	set_instantiation_interface_parameter_value emac0 prSafe {false}
	add_instantiation_interface_port emac0 emac0_mac_tx_clk_o mac_tx_clk_o 1 STD_LOGIC Output
	add_instantiation_interface_port emac0 emac0_mac_tx_clk_i mac_tx_clk_i 1 STD_LOGIC Input
	add_instantiation_interface_port emac0 emac0_mac_rx_clk mac_rx_clk 1 STD_LOGIC Input
	add_instantiation_interface_port emac0 emac0_mac_rst_tx_n mac_rst_tx_n 1 STD_LOGIC Output
	add_instantiation_interface_port emac0 emac0_mac_rst_rx_n mac_rst_rx_n 1 STD_LOGIC Output
	add_instantiation_interface_port emac0 emac0_mac_txen mac_txen 1 STD_LOGIC Output
	add_instantiation_interface_port emac0 emac0_mac_txer mac_txer 1 STD_LOGIC Output
	add_instantiation_interface_port emac0 emac0_mac_rxdv mac_rxdv 1 STD_LOGIC Input
	add_instantiation_interface_port emac0 emac0_mac_rxer mac_rxer 1 STD_LOGIC Input
	add_instantiation_interface_port emac0 emac0_mac_rxd mac_rxd 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port emac0 emac0_mac_col mac_col 1 STD_LOGIC Input
	add_instantiation_interface_port emac0 emac0_mac_crs mac_crs 1 STD_LOGIC Input
	add_instantiation_interface_port emac0 emac0_mac_speed mac_speed 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port emac0 emac0_mac_txd_o mac_txd_o 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface fpga2hps_interrupt interrupt OUTPUT
	set_instantiation_interface_parameter_value fpga2hps_interrupt associatedAddressablePoint {}
	set_instantiation_interface_parameter_value fpga2hps_interrupt associatedClock {}
	set_instantiation_interface_parameter_value fpga2hps_interrupt associatedReset {}
	set_instantiation_interface_parameter_value fpga2hps_interrupt irqMap {}
	set_instantiation_interface_parameter_value fpga2hps_interrupt irqScheme {INDIVIDUAL_REQUESTS}
	add_instantiation_interface_port fpga2hps_interrupt fpga2hps_interrupt_irq irq 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface io96b0_csr_axi_clk clock INPUT
	set_instantiation_interface_parameter_value io96b0_csr_axi_clk clockRate {0}
	set_instantiation_interface_parameter_value io96b0_csr_axi_clk externallyDriven {false}
	set_instantiation_interface_parameter_value io96b0_csr_axi_clk ptfSchematicName {}
	add_instantiation_interface_port io96b0_csr_axi_clk io96b0_csr_axi_clk_clk clk 1 STD_LOGIC Input
	add_instantiation_interface io96b0_csr_axi_rst reset INPUT
	set_instantiation_interface_parameter_value io96b0_csr_axi_rst associatedClock {io96b0_csr_axi_clk}
	set_instantiation_interface_parameter_value io96b0_csr_axi_rst synchronousEdges {DEASSERT}
	add_instantiation_interface_port io96b0_csr_axi_rst io96b0_csr_axi_rst_reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface io96b0_csr_axi axi4lite OUTPUT
	set_instantiation_interface_parameter_value io96b0_csr_axi associatedClock {io96b0_csr_axi_clk}
	set_instantiation_interface_parameter_value io96b0_csr_axi associatedReset {io96b0_csr_axi_rst}
	set_instantiation_interface_parameter_value io96b0_csr_axi combinedIssuingCapability {1}
	set_instantiation_interface_parameter_value io96b0_csr_axi maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value io96b0_csr_axi maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value io96b0_csr_axi maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value io96b0_csr_axi poison {false}
	set_instantiation_interface_parameter_value io96b0_csr_axi readIssuingCapability {1}
	set_instantiation_interface_parameter_value io96b0_csr_axi traceSignals {false}
	set_instantiation_interface_parameter_value io96b0_csr_axi trustzoneAware {true}
	set_instantiation_interface_parameter_value io96b0_csr_axi uniqueIdSupport {false}
	set_instantiation_interface_parameter_value io96b0_csr_axi wakeupSignals {false}
	set_instantiation_interface_parameter_value io96b0_csr_axi writeIssuingCapability {1}
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_arready arready 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_awready awready 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_bresp bresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_bvalid bvalid 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_rdata rdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_rresp rresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_rvalid rvalid 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_wready wready 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_araddr araddr 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_arvalid arvalid 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_awaddr awaddr 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_awvalid awvalid 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_bready bready 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_rready rready 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_wdata wdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_wstrb wstrb 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_wvalid wvalid 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_arprot arprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_csr_axi io96b0_csr_axi_awprot awprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface io96b0_ch0_axi_clk clock INPUT
	set_instantiation_interface_parameter_value io96b0_ch0_axi_clk clockRate {0}
	set_instantiation_interface_parameter_value io96b0_ch0_axi_clk externallyDriven {false}
	set_instantiation_interface_parameter_value io96b0_ch0_axi_clk ptfSchematicName {}
	add_instantiation_interface_port io96b0_ch0_axi_clk io96b0_ch0_axi_clk_clk clk 1 STD_LOGIC Input
	add_instantiation_interface io96b0_ch0_axi_rst reset INPUT
	set_instantiation_interface_parameter_value io96b0_ch0_axi_rst associatedClock {io96b0_ch0_axi_clk}
	set_instantiation_interface_parameter_value io96b0_ch0_axi_rst synchronousEdges {DEASSERT}
	add_instantiation_interface_port io96b0_ch0_axi_rst io96b0_ch0_axi_rst_reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface io96b0_ch0_axi axi4 OUTPUT
	set_instantiation_interface_parameter_value io96b0_ch0_axi associatedClock {io96b0_ch0_axi_clk}
	set_instantiation_interface_parameter_value io96b0_ch0_axi associatedReset {io96b0_ch0_axi_rst}
	set_instantiation_interface_parameter_value io96b0_ch0_axi combinedIssuingCapability {1}
	set_instantiation_interface_parameter_value io96b0_ch0_axi issuesFIXEDBursts {true}
	set_instantiation_interface_parameter_value io96b0_ch0_axi issuesINCRBursts {true}
	set_instantiation_interface_parameter_value io96b0_ch0_axi issuesWRAPBursts {true}
	set_instantiation_interface_parameter_value io96b0_ch0_axi maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value io96b0_ch0_axi maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value io96b0_ch0_axi maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value io96b0_ch0_axi poison {false}
	set_instantiation_interface_parameter_value io96b0_ch0_axi readIssuingCapability {1}
	set_instantiation_interface_parameter_value io96b0_ch0_axi traceSignals {false}
	set_instantiation_interface_parameter_value io96b0_ch0_axi trustzoneAware {true}
	set_instantiation_interface_parameter_value io96b0_ch0_axi uniqueIdSupport {false}
	set_instantiation_interface_parameter_value io96b0_ch0_axi wakeupSignals {false}
	set_instantiation_interface_parameter_value io96b0_ch0_axi writeIssuingCapability {1}
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arready arready 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awready awready 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_bid bid 7 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_bresp bresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_bvalid bvalid 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_rdata rdata 256 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_rid rid 7 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_rlast rlast 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_rresp rresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_ruser ruser 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_rvalid rvalid 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_wready wready 1 STD_LOGIC Input
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_araddr araddr 44 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arburst arburst 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arid arid 7 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arlen arlen 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arlock arlock 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arqos arqos 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arsize arsize 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_aruser aruser 14 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arvalid arvalid 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awaddr awaddr 44 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awburst awburst 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awid awid 7 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awlen awlen 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awlock awlock 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awqos awqos 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awsize awsize 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awuser awuser 14 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awvalid awvalid 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_bready bready 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_rready rready 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_wdata wdata 256 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_wlast wlast 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_wstrb wstrb 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_wuser wuser 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_wvalid wvalid 1 STD_LOGIC Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_arprot arprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port io96b0_ch0_axi io96b0_ch0_axi_awprot awprot 3 STD_LOGIC_VECTOR Output
	save_instantiation
	add_component emif_hps ip/qsys_top/emif_hps.ip emif_hps_ph2 emif_hps_ph2_inst 5.0.0
	load_component emif_hps
	set_component_parameter_value AXI4_USER_DATA_ENABLE {0}
	set_component_parameter_value AXI4_USER_DATA_ENABLE_AUTO_BOOL {1}
	set_component_parameter_value AXI_SIDEBAND_ACCESS_MODE {FABRIC}
	set_component_parameter_value AXI_SIDEBAND_ACCESS_MODE_AUTO_BOOL {1}
	set_component_parameter_value CTRL_ECC_AUTOCORRECT_EN {0}
	set_component_parameter_value CTRL_ECC_AUTOCORRECT_EN_AUTO_BOOL {1}
	set_component_parameter_value CTRL_ECC_MODE {CTRL_ECC_MODE_DISABLED}
	set_component_parameter_value CTRL_ECC_MODE_AUTO_BOOL {1}
	set_component_parameter_value CTRL_PERFORMANCE_PROFILE {CTRL_PERFORMANCE_PROFILE_TEMP1}
	set_component_parameter_value CTRL_PERFORMANCE_PROFILE_AUTO_BOOL {1}
	set_component_parameter_value CTRL_PHY_ONLY_EN {0}
	set_component_parameter_value CTRL_PHY_ONLY_EN_AUTO_BOOL {1}
	set_component_parameter_value CTRL_SCRAMBLER_EN {0}
	set_component_parameter_value DEBUG_TOOLS_EN {0}
	set_component_parameter_value DIAG_EXTRA_PARAMETERS {}
	set_component_parameter_value EX_DESIGN_CORE_CLK_FREQ_MHZ {200}
	set_component_parameter_value EX_DESIGN_CORE_CLK_FREQ_MHZ_AUTO_BOOL {1}
	set_component_parameter_value EX_DESIGN_CORE_REFCLK_FREQ_MHZ {100}
	set_component_parameter_value EX_DESIGN_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_HYDRA_REMOTE {CONFIG_INTF_MODE_REMOTE_JTAG}
	set_component_parameter_value EX_DESIGN_NOC_REFCLK_FREQ_MHZ {100}
	set_component_parameter_value EX_DESIGN_NOC_REFCLK_FREQ_MHZ_AUTO_BOOL {1}
	set_component_parameter_value EX_DESIGN_PMON_CH0_EN {0}
	set_component_parameter_value EX_DESIGN_PMON_CH1_EN {0}
	set_component_parameter_value EX_DESIGN_PMON_CH2_EN {0}
	set_component_parameter_value EX_DESIGN_PMON_CH3_EN {0}
	set_component_parameter_value EX_DESIGN_PMON_ENABLED {0}
	set_component_parameter_value GRP_MEM_DFE_AUTO_BOOL {1}
	set_component_parameter_value GRP_MEM_DFE_X_TAP_1 {MEM_DFE_TAP_1_LP5_5}
	set_component_parameter_value GRP_MEM_DFE_X_TAP_2 {MEM_DFE_TAP_2_0}
	set_component_parameter_value GRP_MEM_DFE_X_TAP_3 {MEM_DFE_TAP_3_0}
	set_component_parameter_value GRP_MEM_DFE_X_TAP_4 {MEM_DFE_TAP_4_0}
	set_component_parameter_value GRP_MEM_DQ_VREF_AUTO_BOOL {1}
	set_component_parameter_value GRP_MEM_DQ_VREF_X_RANGE {MEM_VREF_RANGE_DDR4_2}
	set_component_parameter_value GRP_MEM_DQ_VREF_X_VALUE {67.75}
	set_component_parameter_value GRP_MEM_ODT_CA_AUTO_BOOL {1}
	set_component_parameter_value GRP_MEM_ODT_CA_X_CA {MEM_RTT_CA_DDR5_6}
	set_component_parameter_value GRP_MEM_ODT_CA_X_CA_COMM {MEM_RTT_COMM_OFF}
	set_component_parameter_value GRP_MEM_ODT_CA_X_CA_ENABLE {MEM_RTT_COMM_EN_FALSE}
	set_component_parameter_value GRP_MEM_ODT_CA_X_CK {MEM_RTT_CA_DDR5_6}
	set_component_parameter_value GRP_MEM_ODT_CA_X_CK_ENABLE {MEM_RTT_COMM_EN_FALSE}
	set_component_parameter_value GRP_MEM_ODT_CA_X_CS {MEM_RTT_CA_DDR5_6}
	set_component_parameter_value GRP_MEM_ODT_CA_X_CS_ENABLE {MEM_RTT_COMM_EN_FALSE}
	set_component_parameter_value GRP_MEM_ODT_DQ_AUTO_BOOL {1}
	set_component_parameter_value GRP_MEM_ODT_DQ_X_IDLE {MEM_RTT_COMM_OFF}
	set_component_parameter_value GRP_MEM_ODT_DQ_X_NON_TGT {MEM_RTT_COMM_OFF}
	set_component_parameter_value GRP_MEM_ODT_DQ_X_NON_TGT_RD {MEM_RTT_COMM_OFF}
	set_component_parameter_value GRP_MEM_ODT_DQ_X_NON_TGT_WR {MEM_RTT_COMM_OFF}
	set_component_parameter_value GRP_MEM_ODT_DQ_X_RON {MEM_DRIVE_STRENGTH_7}
	set_component_parameter_value GRP_MEM_ODT_DQ_X_TGT_WR {MEM_RTT_COMM_4}
	set_component_parameter_value GRP_MEM_ODT_DQ_X_WCK {MEM_RTT_COMM_4}
	set_component_parameter_value GRP_MEM_VREF_CA_AUTO_BOOL {1}
	set_component_parameter_value GRP_MEM_VREF_CA_X_CA_RANGE {MEM_CA_VREF_RANGE_LP4_2}
	set_component_parameter_value GRP_MEM_VREF_CA_X_CA_VALUE {50.0}
	set_component_parameter_value GRP_MEM_VREF_CA_X_CS_VALUE {50.0}
	set_component_parameter_value GRP_PHY_AC_AUTO_BOOL {1}
	set_component_parameter_value GRP_PHY_AC_X_R_S_AC_OUTPUT_OHM {RTT_PHY_OUT_34_CAL}
	set_component_parameter_value GRP_PHY_CLK_AUTO_BOOL {1}
	set_component_parameter_value GRP_PHY_CLK_X_R_S_CK_OUTPUT_OHM {RTT_PHY_OUT_34_CAL}
	set_component_parameter_value GRP_PHY_DATA_AUTO_BOOL {1}
	set_component_parameter_value GRP_PHY_DATA_X_DQS_IO_STD_TYPE {PHY_IO_STD_TYPE_DF_POD}
	set_component_parameter_value GRP_PHY_DATA_X_DQ_IO_STD_TYPE {PHY_IO_STD_TYPE_POD}
	set_component_parameter_value GRP_PHY_DATA_X_DQ_SLEW_RATE {PHY_SLEW_RATE_FASTEST}
	set_component_parameter_value GRP_PHY_DATA_X_DQ_VREF {68.3}
	set_component_parameter_value GRP_PHY_DATA_X_R_S_DQ_OUTPUT_OHM {RTT_PHY_OUT_34_CAL}
	set_component_parameter_value GRP_PHY_DATA_X_R_T_DQ_INPUT_OHM {RTT_PHY_IN_50_CAL}
	set_component_parameter_value GRP_PHY_DFE_AUTO_BOOL {1}
	set_component_parameter_value GRP_PHY_DFE_X_TAP_1 {PHY_DFE_TAP_1_LP5_0}
	set_component_parameter_value GRP_PHY_DFE_X_TAP_2 {PHY_DFE_TAP_2_3_LP5_0}
	set_component_parameter_value GRP_PHY_DFE_X_TAP_3 {PHY_DFE_TAP_2_3_LP5_0}
	set_component_parameter_value GRP_PHY_DFE_X_TAP_4 {PHY_DFE_TAP_4_LP5_0}
	set_component_parameter_value GRP_PHY_IN_AUTO_BOOL {1}
	set_component_parameter_value GRP_PHY_IN_X_R_T_REFCLK_INPUT_OHM {LVDS_DIFF_TERM_ON}
	set_component_parameter_value HMC_ADDR_SWAP {0}
	set_component_parameter_value HPS_EMIF_CONFIG {HPS_EMIF_1x32}
	set_component_parameter_value HPS_EMIF_CONFIG_AUTO_BOOL {0}
	set_component_parameter_value INSTANCE_ID {0}
	set_component_parameter_value INSTANCE_ID_IP0 {0}
	set_component_parameter_value INSTANCE_ID_IP1 {1}
	set_component_parameter_value MEM_AC_MIRRORING {0}
	set_component_parameter_value MEM_AC_MIRRORING_AUTO_BOOL {1}
	set_component_parameter_value MEM_COMPS_PER_RANK {2}
	set_component_parameter_value MEM_DEVICE_DQ_WIDTH {16}
	set_component_parameter_value MEM_FORMAT {MEM_FORMAT_DISCRETE}
	set_component_parameter_value MEM_NUM_CHANNELS {1}
	set_component_parameter_value MEM_NUM_RANKS {1}
	set_component_parameter_value MEM_PRESET_FILE_EN {0}
	set_component_parameter_value MEM_PRESET_FILE_EN_FSP0 {0}
	set_component_parameter_value MEM_PRESET_FILE_EN_FSP1 {0}
	set_component_parameter_value MEM_PRESET_FILE_EN_FSP2 {0}
	set_component_parameter_value MEM_PRESET_FILE_QPRS {mem_preset_file_qprs.qprs}
	set_component_parameter_value MEM_PRESET_FILE_QPRS_FSP0 {mem_preset_file_qprs_fsp0.qprs}
	set_component_parameter_value MEM_PRESET_FILE_QPRS_FSP1 {mem_preset_file_qprs_fsp1.qprs}
	set_component_parameter_value MEM_PRESET_FILE_QPRS_FSP2 {mem_preset_file_qprs_fsp2.qprs}
	set_component_parameter_value MEM_PRESET_ID {DDR4-3200AA CL22 Component 1CS 8Gb 512Mb x16}
	set_component_parameter_value MEM_PRESET_ID_AUTO_BOOL {1}
	set_component_parameter_value MEM_PRESET_ID_FSP0 {{No Presets Found}}
	set_component_parameter_value MEM_PRESET_ID_FSP0_AUTO_BOOL {1}
	set_component_parameter_value MEM_PRESET_ID_FSP1 {{No Presets Found}}
	set_component_parameter_value MEM_PRESET_ID_FSP1_AUTO_BOOL {1}
	set_component_parameter_value MEM_PRESET_ID_FSP2 {{No Presets Found}}
	set_component_parameter_value MEM_PRESET_ID_FSP2_AUTO_BOOL {1}
	set_component_parameter_value MEM_RANKS_SHARE_CLOCKS {0}
	set_component_parameter_value MEM_TECHNOLOGY {MEM_TECHNOLOGY_DDR4}
	set_component_parameter_value MEM_TECHNOLOGY_AUTO_BOOL {0}
	set_component_parameter_value MEM_TECH_IS_X {0}
	set_component_parameter_value MEM_TOPOLOGY {MEM_TOPOLOGY_FLYBY}
	set_component_parameter_value MEM_USER_READ_LATENCY_CYC {5}
	set_component_parameter_value MEM_USER_READ_LATENCY_CYC_AUTO_BOOL {1}
	set_component_parameter_value MEM_USER_WRITE_LATENCY_CYC {10}
	set_component_parameter_value MEM_USER_WRITE_LATENCY_CYC_AUTO_BOOL {1}
	set_component_parameter_value PHY_AC_PLACEMENT {PHY_AC_PLACEMENT_BOT}
	set_component_parameter_value PHY_AC_PLACEMENT_AUTO_BOOL {1}
	set_component_parameter_value PHY_ALERT_N_PLACEMENT {PHY_ALERT_N_PLACEMENT_AC2}
	set_component_parameter_value PHY_ASYNC_EN {1}
	set_component_parameter_value PHY_FSP1_EN {0}
	set_component_parameter_value PHY_FSP2_EN {0}
	set_component_parameter_value PHY_MEMCLK_FREQ_MHZ {1600.0}
	set_component_parameter_value PHY_MEMCLK_FREQ_MHZ_AUTO_BOOL {1}
	set_component_parameter_value PHY_MEMCLK_FSP0_FREQ_MHZ {1600.0}
	set_component_parameter_value PHY_MEMCLK_FSP0_FREQ_MHZ_AUTO_BOOL {1}
	set_component_parameter_value PHY_MEMCLK_FSP1_FREQ_MHZ {1600.0}
	set_component_parameter_value PHY_MEMCLK_FSP1_FREQ_MHZ_AUTO_BOOL {1}
	set_component_parameter_value PHY_MEMCLK_FSP2_FREQ_MHZ {1600.0}
	set_component_parameter_value PHY_MEMCLK_FSP2_FREQ_MHZ_AUTO_BOOL {1}
	set_component_parameter_value PHY_NOC_EN {0}
	set_component_parameter_value PHY_NOC_EN_AUTO_BOOL {1}
	set_component_parameter_value PHY_REFCLK_FREQ_MHZ {200.0}
	set_component_parameter_value PHY_REFCLK_FREQ_MHZ_AUTO_BOOL {1}
	set_component_parameter_value SHOW_INTERNAL_SETTINGS {0}
	set_component_parameter_value SHOW_LPDDR4 {0}
	set_component_parameter_value USER_EXTRA_PARAMETERS {}
	set_component_parameter_value USER_MIN_NUM_AC_LANES {3}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation emif_hps
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface usr_clk_0 clock OUTPUT
	set_instantiation_interface_parameter_value usr_clk_0 associatedDirectClock {}
	set_instantiation_interface_parameter_value usr_clk_0 clockRate {0}
	set_instantiation_interface_parameter_value usr_clk_0 clockRateKnown {false}
	set_instantiation_interface_parameter_value usr_clk_0 externallyDriven {false}
	set_instantiation_interface_parameter_value usr_clk_0 ptfSchematicName {}
	set_instantiation_interface_sysinfo_parameter_value usr_clk_0 clock_rate {0}
	add_instantiation_interface_port usr_clk_0 noc_aclk_0 clk 1 STD_LOGIC Output
	add_instantiation_interface s0_axi4 axi4 INPUT
	set_instantiation_interface_parameter_value s0_axi4 associatedClock {usr_clk_0}
	set_instantiation_interface_parameter_value s0_axi4 associatedReset {usr_rst_n_0}
	set_instantiation_interface_parameter_value s0_axi4 bridgesToMaster {}
	set_instantiation_interface_parameter_value s0_axi4 combinedAcceptanceCapability {1}
	set_instantiation_interface_parameter_value s0_axi4 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s0_axi4 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s0_axi4 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s0_axi4 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s0_axi4 dfhGroupId {0}
	set_instantiation_interface_parameter_value s0_axi4 dfhParameterData {}
	set_instantiation_interface_parameter_value s0_axi4 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s0_axi4 dfhParameterId {}
	set_instantiation_interface_parameter_value s0_axi4 dfhParameterName {}
	set_instantiation_interface_parameter_value s0_axi4 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s0_axi4 maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value s0_axi4 maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value s0_axi4 maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value s0_axi4 poison {false}
	set_instantiation_interface_parameter_value s0_axi4 readAcceptanceCapability {1}
	set_instantiation_interface_parameter_value s0_axi4 readDataReorderingDepth {1}
	set_instantiation_interface_parameter_value s0_axi4 traceSignals {false}
	set_instantiation_interface_parameter_value s0_axi4 trustzoneAware {true}
	set_instantiation_interface_parameter_value s0_axi4 uniqueIdSupport {false}
	set_instantiation_interface_parameter_value s0_axi4 wakeupSignals {false}
	set_instantiation_interface_parameter_value s0_axi4 writeAcceptanceCapability {1}
	set_instantiation_interface_sysinfo_parameter_value s0_axi4 address_map {<address-map><slave name='s0_axi4' start='0x0' end='0x10000000000' datawidth='256' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s0_axi4 address_width {40}
	set_instantiation_interface_sysinfo_parameter_value s0_axi4 max_slave_data_width {256}
	add_instantiation_interface_port s0_axi4 s0_axi4_araddr araddr 40 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_arburst arburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_arid arid 7 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_arlen arlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_arlock arlock 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axi4 s0_axi4_arqos arqos 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_arsize arsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_arvalid arvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axi4 s0_axi4_aruser aruser 14 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_arprot arprot 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awaddr awaddr 40 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awburst awburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awid awid 7 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awlen awlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awlock awlock 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awqos awqos 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awsize awsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awvalid awvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awuser awuser 14 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_awprot awprot 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_bready bready 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axi4 s0_axi4_rready rready 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axi4 s0_axi4_wdata wdata 256 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_wstrb wstrb 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_wlast wlast 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axi4 s0_axi4_wvalid wvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axi4 s0_axi4_wuser wuser 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axi4 s0_axi4_ruser ruser 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axi4 s0_axi4_arready arready 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axi4 s0_axi4_awready awready 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axi4 s0_axi4_bid bid 7 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axi4 s0_axi4_bresp bresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axi4 s0_axi4_bvalid bvalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axi4 s0_axi4_rdata rdata 256 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axi4 s0_axi4_rid rid 7 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axi4 s0_axi4_rlast rlast 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axi4 s0_axi4_rresp rresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axi4 s0_axi4_rvalid rvalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axi4 s0_axi4_wready wready 1 STD_LOGIC Output
	add_instantiation_interface emif_mem_0 conduit INPUT
	set_instantiation_interface_parameter_value emif_mem_0 associatedClock {}
	set_instantiation_interface_parameter_value emif_mem_0 associatedReset {}
	set_instantiation_interface_parameter_value emif_mem_0 prSafe {false}
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_ck_t mem_ck_t 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_ck_c mem_ck_c 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_cke mem_cke 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_odt mem_odt 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_cs_n mem_cs_n 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_a mem_a 17 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_ba mem_ba 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_bg mem_bg 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_act_n mem_act_n 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_par mem_par 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_alert_n mem_alert_n 1 STD_LOGIC Input
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_reset_n mem_reset_n 1 STD_LOGIC Output
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_dq mem_dq 32 STD_LOGIC_VECTOR Bidir
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_dqs_t mem_dqs_t 4 STD_LOGIC_VECTOR Bidir
	add_instantiation_interface_port emif_mem_0 emif_mem_0_mem_dqs_c mem_dqs_c 4 STD_LOGIC_VECTOR Bidir
	add_instantiation_interface emif_oct_0 conduit INPUT
	set_instantiation_interface_parameter_value emif_oct_0 associatedClock {}
	set_instantiation_interface_parameter_value emif_oct_0 associatedReset {}
	set_instantiation_interface_parameter_value emif_oct_0 prSafe {false}
	add_instantiation_interface_port emif_oct_0 emif_oct_0_oct_rzqin oct_rzqin 1 STD_LOGIC Input
	add_instantiation_interface s0_axil_clk clock OUTPUT
	set_instantiation_interface_parameter_value s0_axil_clk associatedDirectClock {}
	set_instantiation_interface_parameter_value s0_axil_clk clockRate {0}
	set_instantiation_interface_parameter_value s0_axil_clk clockRateKnown {false}
	set_instantiation_interface_parameter_value s0_axil_clk externallyDriven {false}
	set_instantiation_interface_parameter_value s0_axil_clk ptfSchematicName {}
	set_instantiation_interface_sysinfo_parameter_value s0_axil_clk clock_rate {0}
	add_instantiation_interface_port s0_axil_clk s0_noc_axi4lite_clk clk 1 STD_LOGIC Output
	add_instantiation_interface s0_axil_rst_n reset OUTPUT
	set_instantiation_interface_parameter_value s0_axil_rst_n associatedClock {s0_axil_clk}
	set_instantiation_interface_parameter_value s0_axil_rst_n associatedDirectReset {}
	set_instantiation_interface_parameter_value s0_axil_rst_n associatedResetSinks {none}
	set_instantiation_interface_parameter_value s0_axil_rst_n synchronousEdges {DEASSERT}
	add_instantiation_interface_port s0_axil_rst_n s0_noc_axi4lite_rst_n reset_n 1 STD_LOGIC Output
	add_instantiation_interface s0_axil axi4lite INPUT
	set_instantiation_interface_parameter_value s0_axil associatedClock {s0_axil_clk}
	set_instantiation_interface_parameter_value s0_axil associatedReset {s0_axil_rst_n}
	set_instantiation_interface_parameter_value s0_axil bridgesToMaster {}
	set_instantiation_interface_parameter_value s0_axil combinedAcceptanceCapability {1}
	set_instantiation_interface_parameter_value s0_axil dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s0_axil dfhFeatureId {35}
	set_instantiation_interface_parameter_value s0_axil dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s0_axil dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s0_axil dfhGroupId {0}
	set_instantiation_interface_parameter_value s0_axil dfhParameterData {}
	set_instantiation_interface_parameter_value s0_axil dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s0_axil dfhParameterId {}
	set_instantiation_interface_parameter_value s0_axil dfhParameterName {}
	set_instantiation_interface_parameter_value s0_axil dfhParameterVersion {}
	set_instantiation_interface_parameter_value s0_axil maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value s0_axil maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value s0_axil maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value s0_axil poison {false}
	set_instantiation_interface_parameter_value s0_axil readAcceptanceCapability {1}
	set_instantiation_interface_parameter_value s0_axil readDataReorderingDepth {1}
	set_instantiation_interface_parameter_value s0_axil traceSignals {false}
	set_instantiation_interface_parameter_value s0_axil trustzoneAware {true}
	set_instantiation_interface_parameter_value s0_axil uniqueIdSupport {false}
	set_instantiation_interface_parameter_value s0_axil wakeupSignals {false}
	set_instantiation_interface_parameter_value s0_axil writeAcceptanceCapability {1}
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_awaddr awaddr 27 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_awvalid awvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_awready awready 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_wdata wdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_wstrb wstrb 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_wvalid wvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_wready wready 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_bresp bresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_bvalid bvalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_bready bready 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_araddr araddr 27 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_arvalid arvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_arready arready 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_rdata rdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_rresp rresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_rvalid rvalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_rready rready 1 STD_LOGIC Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_awprot awprot 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0_axil s0_noc_axi4lite_arprot arprot 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface usr_rst_n_0 reset OUTPUT
	set_instantiation_interface_parameter_value usr_rst_n_0 associatedClock {}
	set_instantiation_interface_parameter_value usr_rst_n_0 associatedDirectReset {}
	set_instantiation_interface_parameter_value usr_rst_n_0 associatedResetSinks {none}
	set_instantiation_interface_parameter_value usr_rst_n_0 synchronousEdges {NONE}
	add_instantiation_interface_port usr_rst_n_0 out_reset_0_n reset_n 1 STD_LOGIC Output
	add_instantiation_interface emif_ref_clk_0 clock INPUT
	set_instantiation_interface_parameter_value emif_ref_clk_0 clockRate {0}
	set_instantiation_interface_parameter_value emif_ref_clk_0 externallyDriven {false}
	set_instantiation_interface_parameter_value emif_ref_clk_0 ptfSchematicName {}
	add_instantiation_interface_port emif_ref_clk_0 emif_ref_clk_0_clk clk 1 STD_LOGIC Input
	save_instantiation
	add_component sub_clk ip/hps_subsys/sub_clk.ip altera_clock_bridge altera_clock_bridge_inst 19.2.0
	load_component sub_clk
	set_component_parameter_value EXPLICIT_CLOCK_RATE {100000000.0}
	set_component_parameter_value NUM_CLOCK_OUTPUTS {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation sub_clk
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface in_clk clock INPUT
	set_instantiation_interface_parameter_value in_clk clockRate {0}
	set_instantiation_interface_parameter_value in_clk externallyDriven {false}
	set_instantiation_interface_parameter_value in_clk ptfSchematicName {}
	add_instantiation_interface_port in_clk in_clk clk 1 STD_LOGIC Input
	add_instantiation_interface out_clk clock OUTPUT
	set_instantiation_interface_parameter_value out_clk associatedDirectClock {in_clk}
	set_instantiation_interface_parameter_value out_clk clockRate {100000000}
	set_instantiation_interface_parameter_value out_clk clockRateKnown {true}
	set_instantiation_interface_parameter_value out_clk externallyDriven {false}
	set_instantiation_interface_parameter_value out_clk ptfSchematicName {}
	set_instantiation_interface_sysinfo_parameter_value out_clk clock_rate {100000000}
	add_instantiation_interface_port out_clk out_clk clk 1 STD_LOGIC Output
	save_instantiation
	add_component sub_rst_in ip/hps_subsys/sub_rst_in.ip altera_reset_bridge altera_reset_bridge_inst 19.2.0
	load_component sub_rst_in
	set_component_parameter_value ACTIVE_LOW_RESET {1}
	set_component_parameter_value NUM_RESET_OUTPUTS {1}
	set_component_parameter_value SYNCHRONOUS_EDGES {both}
	set_component_parameter_value SYNC_RESET {0}
	set_component_parameter_value USE_RESET_REQUEST {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation sub_rst_in
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface in_reset reset INPUT
	set_instantiation_interface_parameter_value in_reset associatedClock {clk}
	set_instantiation_interface_parameter_value in_reset synchronousEdges {BOTH}
	add_instantiation_interface_port in_reset in_reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface out_reset reset OUTPUT
	set_instantiation_interface_parameter_value out_reset associatedClock {clk}
	set_instantiation_interface_parameter_value out_reset associatedDirectReset {in_reset}
	set_instantiation_interface_parameter_value out_reset associatedResetSinks {in_reset}
	set_instantiation_interface_parameter_value out_reset synchronousEdges {BOTH}
	add_instantiation_interface_port out_reset out_reset_n reset_n 1 STD_LOGIC Output
	save_instantiation

	# add wirelevel expressions

	# preserve ports for debug

	# add the connections
	add_connection agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 addressMapSysInfo {}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 addressWidthSysInfo {}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 arbitrationPriority {1}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 baseAddress {0x0000}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 defaultConnection {0}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 domainAlias {}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value agilex_hps.io96b0_ch0_axi/emif_hps.s0_axi4 slaveDataWidthSysInfo {-1}
	add_connection agilex_hps.io96b0_csr_axi/emif_hps.s0_axil
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil addressMapSysInfo {}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil addressWidthSysInfo {}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil arbitrationPriority {1}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil baseAddress {0x0000}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil defaultConnection {0}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil domainAlias {}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.syncResets {TRUE}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value agilex_hps.io96b0_csr_axi/emif_hps.s0_axil slaveDataWidthSysInfo {-1}
	add_connection emif_hps.s0_axil_clk/agilex_hps.io96b0_csr_axi_clk
	set_connection_parameter_value emif_hps.s0_axil_clk/agilex_hps.io96b0_csr_axi_clk clockDomainSysInfo {-1}
	set_connection_parameter_value emif_hps.s0_axil_clk/agilex_hps.io96b0_csr_axi_clk clockRateSysInfo {}
	set_connection_parameter_value emif_hps.s0_axil_clk/agilex_hps.io96b0_csr_axi_clk clockResetSysInfo {}
	set_connection_parameter_value emif_hps.s0_axil_clk/agilex_hps.io96b0_csr_axi_clk resetDomainSysInfo {-1}
	add_connection emif_hps.s0_axil_rst_n/agilex_hps.io96b0_csr_axi_rst
	set_connection_parameter_value emif_hps.s0_axil_rst_n/agilex_hps.io96b0_csr_axi_rst clockDomainSysInfo {-1}
	set_connection_parameter_value emif_hps.s0_axil_rst_n/agilex_hps.io96b0_csr_axi_rst clockResetSysInfo {}
	set_connection_parameter_value emif_hps.s0_axil_rst_n/agilex_hps.io96b0_csr_axi_rst resetDomainSysInfo {-1}
	add_connection emif_hps.usr_clk_0/agilex_hps.io96b0_ch0_axi_clk
	set_connection_parameter_value emif_hps.usr_clk_0/agilex_hps.io96b0_ch0_axi_clk clockDomainSysInfo {-1}
	set_connection_parameter_value emif_hps.usr_clk_0/agilex_hps.io96b0_ch0_axi_clk clockRateSysInfo {}
	set_connection_parameter_value emif_hps.usr_clk_0/agilex_hps.io96b0_ch0_axi_clk clockResetSysInfo {}
	set_connection_parameter_value emif_hps.usr_clk_0/agilex_hps.io96b0_ch0_axi_clk resetDomainSysInfo {-1}
	add_connection emif_hps.usr_rst_n_0/agilex_hps.io96b0_ch0_axi_rst
	set_connection_parameter_value emif_hps.usr_rst_n_0/agilex_hps.io96b0_ch0_axi_rst clockDomainSysInfo {-1}
	set_connection_parameter_value emif_hps.usr_rst_n_0/agilex_hps.io96b0_ch0_axi_rst clockResetSysInfo {}
	set_connection_parameter_value emif_hps.usr_rst_n_0/agilex_hps.io96b0_ch0_axi_rst resetDomainSysInfo {-1}
	add_connection sub_clk.out_clk/sub_rst_in.clk
	set_connection_parameter_value sub_clk.out_clk/sub_rst_in.clk clockDomainSysInfo {-1}
	set_connection_parameter_value sub_clk.out_clk/sub_rst_in.clk clockRateSysInfo {100000000.0}
	set_connection_parameter_value sub_clk.out_clk/sub_rst_in.clk clockResetSysInfo {}
	set_connection_parameter_value sub_clk.out_clk/sub_rst_in.clk resetDomainSysInfo {-1}

	# add the exports
	set_interface_property h2f_reset EXPORT_OF agilex_hps.h2f_reset
	set_interface_property lwhps2fpga_clk EXPORT_OF agilex_hps.lwhps2fpga_axi_clock
	set_interface_property lwhps2fpga_rst EXPORT_OF agilex_hps.lwhps2fpga_axi_reset
	set_interface_property lwhps2fpga EXPORT_OF agilex_hps.lwhps2fpga
	set_interface_property emac_ptp_clk EXPORT_OF agilex_hps.emac_ptp_clk
	set_interface_property emac_timestamp_clk EXPORT_OF agilex_hps.emac_timestamp_clk
	set_interface_property emac0_mdio EXPORT_OF agilex_hps.emac0_mdio
	set_interface_property emac0 EXPORT_OF agilex_hps.emac0
	set_interface_property emif_hps_emif_mem_0 EXPORT_OF emif_hps.emif_mem_0
	set_interface_property emif_hps_emif_oct_0 EXPORT_OF emif_hps.emif_oct_0
	set_interface_property emif_hps_emif_ref_clk_0 EXPORT_OF emif_hps.emif_ref_clk_0
	set_interface_property clk EXPORT_OF sub_clk.in_clk
	set_interface_property reset EXPORT_OF sub_rst_in.in_reset

	# set values for exposed HDL parameters
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.burstAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.clockCrossingAdapter HANDSHAKE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.enableAllPipelines FALSE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.enableEccProtection FALSE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.enableInstrumentation FALSE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.enableOutOfOrderSupport FALSE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.insertDefaultSlave FALSE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.interconnectResetSource DEFAULT
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.interconnectType STANDARD
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.maxAdditionalLatency 1
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.optimizeRdFifoSize FALSE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.piplineType PIPELINE_STAGE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.responseFifoType REGISTER_BASED
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.syncResets TRUE
	set_domain_assignment agilex_hps.io96b0_ch0_axi qsys_mm.widthAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.burstAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.clockCrossingAdapter HANDSHAKE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.enableAllPipelines FALSE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.enableEccProtection FALSE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.enableInstrumentation FALSE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.enableOutOfOrderSupport FALSE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.insertDefaultSlave FALSE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.interconnectResetSource DEFAULT
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.interconnectType STANDARD
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.maxAdditionalLatency 1
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.optimizeRdFifoSize FALSE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.piplineType PIPELINE_STAGE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.responseFifoType REGISTER_BASED
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.syncResets TRUE
	set_domain_assignment agilex_hps.io96b0_csr_axi qsys_mm.widthAdapterImplementation GENERIC_CONVERTER

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="agilex_hps">
  <datum __value="_sortIndex" value="2" type="int" />
 </element>
 <element __value="emif_hps">
  <datum __value="_sortIndex" value="3" type="int" />
 </element>
 <element __value="sub_clk">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
 <element __value="sub_rst_in">
  <datum __value="_sortIndex" value="1" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {hps_subsys.qsys}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {hps_subsys}

	# save the system
	sync_sysinfo_parameters
	save_system hps_subsys
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_hps_subsys

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
