package require -exact qsys 23.4

# create the system "phy_mgmt"
proc do_create_phy_mgmt {} {
	# create the system
	create_system phy_mgmt
	set_project_property BOARD {default}
	set_project_property DEVICE {A5ED065BB32AE5SR0}
	set_project_property DEVICE_FAMILY {Agilex 5}
	set_project_property HIDE_FROM_IP_CATALOG {false}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_component avmm_m_i2c ip/phy_mgmt/phy_mgmt_mm_bridge_1.ip altera_avalon_mm_bridge phy_mgmt_mm_bridge_1 20.1.0
	load_component avmm_m_i2c
	set_component_parameter_value ADDRESS_UNITS {SYMBOLS}
	set_component_parameter_value ADDRESS_WIDTH {8}
	set_component_parameter_value DATA_WIDTH {32}
	set_component_parameter_value LINEWRAPBURSTS {0}
	set_component_parameter_value M0_WAITREQUEST_ALLOWANCE {0}
	set_component_parameter_value MAX_BURST_SIZE {1}
	set_component_parameter_value MAX_PENDING_RESPONSES {4}
	set_component_parameter_value MAX_PENDING_WRITES {0}
	set_component_parameter_value PIPELINE_COMMAND {1}
	set_component_parameter_value PIPELINE_RESPONSE {1}
	set_component_parameter_value S0_WAITREQUEST_ALLOWANCE {0}
	set_component_parameter_value SYMBOL_WIDTH {8}
	set_component_parameter_value SYNC_RESET {0}
	set_component_parameter_value USE_AUTO_ADDRESS_WIDTH {0}
	set_component_parameter_value USE_RESPONSE {0}
	set_component_parameter_value USE_WRITERESPONSE {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation avmm_m_i2c
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset reset 1 STD_LOGIC Input
	add_instantiation_interface s0 avalon INPUT
	set_instantiation_interface_parameter_value s0 addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value s0 addressGroup {0}
	set_instantiation_interface_parameter_value s0 addressSpan {256}
	set_instantiation_interface_parameter_value s0 addressUnits {SYMBOLS}
	set_instantiation_interface_parameter_value s0 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s0 associatedClock {clk}
	set_instantiation_interface_parameter_value s0 associatedReset {reset}
	set_instantiation_interface_parameter_value s0 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s0 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s0 bridgesToMaster {m0}
	set_instantiation_interface_parameter_value s0 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s0 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s0 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s0 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s0 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhGroupId {0}
	set_instantiation_interface_parameter_value s0 dfhParameterData {}
	set_instantiation_interface_parameter_value s0 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s0 dfhParameterId {}
	set_instantiation_interface_parameter_value s0 dfhParameterName {}
	set_instantiation_interface_parameter_value s0 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s0 explicitAddressSpan {0}
	set_instantiation_interface_parameter_value s0 holdTime {0}
	set_instantiation_interface_parameter_value s0 interleaveBursts {false}
	set_instantiation_interface_parameter_value s0 isBigEndian {false}
	set_instantiation_interface_parameter_value s0 isFlash {false}
	set_instantiation_interface_parameter_value s0 isMemoryDevice {false}
	set_instantiation_interface_parameter_value s0 isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value s0 linewrapBursts {false}
	set_instantiation_interface_parameter_value s0 maximumPendingReadTransactions {4}
	set_instantiation_interface_parameter_value s0 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value s0 minimumReadLatency {1}
	set_instantiation_interface_parameter_value s0 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value s0 minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value s0 prSafe {false}
	set_instantiation_interface_parameter_value s0 printableDevice {false}
	set_instantiation_interface_parameter_value s0 readLatency {0}
	set_instantiation_interface_parameter_value s0 readWaitStates {0}
	set_instantiation_interface_parameter_value s0 readWaitTime {0}
	set_instantiation_interface_parameter_value s0 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value s0 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value s0 setupTime {0}
	set_instantiation_interface_parameter_value s0 timingUnits {Cycles}
	set_instantiation_interface_parameter_value s0 transparentBridge {false}
	set_instantiation_interface_parameter_value s0 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value s0 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s0 writeLatency {0}
	set_instantiation_interface_parameter_value s0 writeWaitStates {0}
	set_instantiation_interface_parameter_value s0 writeWaitTime {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value s0 address_map {}
	set_instantiation_interface_sysinfo_parameter_value s0 address_width {}
	set_instantiation_interface_sysinfo_parameter_value s0 max_slave_data_width {}
	add_instantiation_interface_port s0 s0_waitrequest waitrequest 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_readdatavalid readdatavalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_burstcount burstcount 1 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_address address 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_write write 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_read read 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_byteenable byteenable 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_debugaccess debugaccess 1 STD_LOGIC Input
	add_instantiation_interface m0 avalon OUTPUT
	set_instantiation_interface_parameter_value m0 adaptsTo {}
	set_instantiation_interface_parameter_value m0 addressGroup {0}
	set_instantiation_interface_parameter_value m0 addressUnits {SYMBOLS}
	set_instantiation_interface_parameter_value m0 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value m0 associatedClock {clk}
	set_instantiation_interface_parameter_value m0 associatedReset {reset}
	set_instantiation_interface_parameter_value m0 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value m0 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value m0 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value m0 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value m0 dBSBigEndian {false}
	set_instantiation_interface_parameter_value m0 doStreamReads {false}
	set_instantiation_interface_parameter_value m0 doStreamWrites {false}
	set_instantiation_interface_parameter_value m0 holdTime {0}
	set_instantiation_interface_parameter_value m0 interleaveBursts {false}
	set_instantiation_interface_parameter_value m0 isAsynchronous {false}
	set_instantiation_interface_parameter_value m0 isBigEndian {false}
	set_instantiation_interface_parameter_value m0 isReadable {false}
	set_instantiation_interface_parameter_value m0 isWriteable {false}
	set_instantiation_interface_parameter_value m0 linewrapBursts {false}
	set_instantiation_interface_parameter_value m0 maxAddressWidth {32}
	set_instantiation_interface_parameter_value m0 maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value m0 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value m0 minimumReadLatency {1}
	set_instantiation_interface_parameter_value m0 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value m0 prSafe {false}
	set_instantiation_interface_parameter_value m0 readLatency {0}
	set_instantiation_interface_parameter_value m0 readWaitTime {1}
	set_instantiation_interface_parameter_value m0 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value m0 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value m0 setupTime {0}
	set_instantiation_interface_parameter_value m0 timingUnits {Cycles}
	set_instantiation_interface_parameter_value m0 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value m0 writeWaitTime {0}
	add_instantiation_interface_port m0 m0_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_readdatavalid readdatavalid 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_burstcount burstcount 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_address address 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_write write 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_read read 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_debugaccess debugaccess 1 STD_LOGIC Output
	save_instantiation
	set_instance_property avmm_m_i2c ENABLED false
	add_component clock_in ip/phy_mgmt/phy_mgmt_clock_in.ip altera_clock_bridge clock_in 19.2.0
	load_component clock_in
	set_component_parameter_value EXPLICIT_CLOCK_RATE {50000000.0}
	set_component_parameter_value NUM_CLOCK_OUTPUTS {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation clock_in
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface in_clk clock INPUT
	set_instantiation_interface_parameter_value in_clk clockRate {0}
	set_instantiation_interface_parameter_value in_clk externallyDriven {false}
	set_instantiation_interface_parameter_value in_clk ptfSchematicName {}
	add_instantiation_interface_port in_clk in_clk clk 1 STD_LOGIC Input
	add_instantiation_interface out_clk clock OUTPUT
	set_instantiation_interface_parameter_value out_clk associatedDirectClock {in_clk}
	set_instantiation_interface_parameter_value out_clk clockRate {50000000}
	set_instantiation_interface_parameter_value out_clk clockRateKnown {true}
	set_instantiation_interface_parameter_value out_clk externallyDriven {false}
	set_instantiation_interface_parameter_value out_clk ptfSchematicName {}
	set_instantiation_interface_sysinfo_parameter_value out_clk clock_rate {50000000}
	add_instantiation_interface_port out_clk out_clk clk 1 STD_LOGIC Output
	save_instantiation
	add_component i2c_0 ip/phy_mgmt/phy_mgmt_i2c_0.ip altera_avalon_i2c i2c_0 19.2.5
	load_component i2c_0
	set_component_parameter_value FIFO_DEPTH {256}
	set_component_parameter_value USE_AV_ST {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation i2c_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.FIFO_DEPTH {256}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {50000000}
	set_instantiation_assignment_value embeddedsw.CMacro.USE_AV_ST {0}
	add_instantiation_interface clock clock INPUT
	set_instantiation_interface_parameter_value clock clockRate {0}
	set_instantiation_interface_parameter_value clock externallyDriven {false}
	set_instantiation_interface_parameter_value clock ptfSchematicName {}
	add_instantiation_interface_port clock clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset_sink reset INPUT
	set_instantiation_interface_parameter_value reset_sink associatedClock {clock}
	set_instantiation_interface_parameter_value reset_sink synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset_sink rst_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface interrupt_sender interrupt INPUT
	set_instantiation_interface_parameter_value interrupt_sender associatedAddressablePoint {csr}
	set_instantiation_interface_parameter_value interrupt_sender associatedClock {clock}
	set_instantiation_interface_parameter_value interrupt_sender associatedReset {reset_sink}
	set_instantiation_interface_parameter_value interrupt_sender bridgedReceiverOffset {0}
	set_instantiation_interface_parameter_value interrupt_sender bridgesToReceiver {}
	set_instantiation_interface_parameter_value interrupt_sender irqScheme {NONE}
	add_instantiation_interface_port interrupt_sender intr irq 1 STD_LOGIC Output
	add_instantiation_interface csr avalon INPUT
	set_instantiation_interface_parameter_value csr addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value csr addressGroup {0}
	set_instantiation_interface_parameter_value csr addressSpan {64}
	set_instantiation_interface_parameter_value csr addressUnits {WORDS}
	set_instantiation_interface_parameter_value csr alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value csr associatedClock {clock}
	set_instantiation_interface_parameter_value csr associatedReset {reset_sink}
	set_instantiation_interface_parameter_value csr bitsPerSymbol {8}
	set_instantiation_interface_parameter_value csr bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value csr bridgesToMaster {}
	set_instantiation_interface_parameter_value csr burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value csr burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value csr constantBurstBehavior {false}
	set_instantiation_interface_parameter_value csr dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value csr dfhFeatureId {35}
	set_instantiation_interface_parameter_value csr dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value csr dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value csr dfhGroupId {0}
	set_instantiation_interface_parameter_value csr dfhParameterData {}
	set_instantiation_interface_parameter_value csr dfhParameterDataLength {}
	set_instantiation_interface_parameter_value csr dfhParameterId {}
	set_instantiation_interface_parameter_value csr dfhParameterName {}
	set_instantiation_interface_parameter_value csr dfhParameterVersion {}
	set_instantiation_interface_parameter_value csr explicitAddressSpan {0}
	set_instantiation_interface_parameter_value csr holdTime {0}
	set_instantiation_interface_parameter_value csr interleaveBursts {false}
	set_instantiation_interface_parameter_value csr isBigEndian {false}
	set_instantiation_interface_parameter_value csr isFlash {false}
	set_instantiation_interface_parameter_value csr isMemoryDevice {false}
	set_instantiation_interface_parameter_value csr isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value csr linewrapBursts {false}
	set_instantiation_interface_parameter_value csr maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value csr maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value csr minimumReadLatency {1}
	set_instantiation_interface_parameter_value csr minimumResponseLatency {1}
	set_instantiation_interface_parameter_value csr minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value csr prSafe {false}
	set_instantiation_interface_parameter_value csr printableDevice {false}
	set_instantiation_interface_parameter_value csr readLatency {2}
	set_instantiation_interface_parameter_value csr readWaitStates {0}
	set_instantiation_interface_parameter_value csr readWaitTime {0}
	set_instantiation_interface_parameter_value csr registerIncomingSignals {false}
	set_instantiation_interface_parameter_value csr registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value csr setupTime {0}
	set_instantiation_interface_parameter_value csr timingUnits {Cycles}
	set_instantiation_interface_parameter_value csr transparentBridge {false}
	set_instantiation_interface_parameter_value csr waitrequestAllowance {0}
	set_instantiation_interface_parameter_value csr wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value csr writeLatency {0}
	set_instantiation_interface_parameter_value csr writeWaitStates {0}
	set_instantiation_interface_parameter_value csr writeWaitTime {0}
	set_instantiation_interface_assignment_value csr embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value csr embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value csr embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value csr embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value csr address_map {<address-map><slave name='csr' start='0x0' end='0x40' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value csr address_width {6}
	set_instantiation_interface_sysinfo_parameter_value csr max_slave_data_width {32}
	add_instantiation_interface_port csr addr address 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port csr read read 1 STD_LOGIC Input
	add_instantiation_interface_port csr write write 1 STD_LOGIC Input
	add_instantiation_interface_port csr writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port csr readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface i2c_serial conduit INPUT
	set_instantiation_interface_parameter_value i2c_serial associatedClock {}
	set_instantiation_interface_parameter_value i2c_serial associatedReset {}
	set_instantiation_interface_parameter_value i2c_serial prSafe {false}
	add_instantiation_interface_port i2c_serial sda_in sda_in 1 STD_LOGIC Input
	add_instantiation_interface_port i2c_serial scl_in scl_in 1 STD_LOGIC Input
	add_instantiation_interface_port i2c_serial sda_oe sda_oe 1 STD_LOGIC Output
	add_instantiation_interface_port i2c_serial scl_oe scl_oe 1 STD_LOGIC Output
	save_instantiation
	add_component reset_in ip/phy_mgmt/phy_mgmt_reset_in.ip altera_reset_bridge reset_in 19.2.0
	load_component reset_in
	set_component_parameter_value ACTIVE_LOW_RESET {0}
	set_component_parameter_value NUM_RESET_OUTPUTS {1}
	set_component_parameter_value SYNCHRONOUS_EDGES {deassert}
	set_component_parameter_value SYNC_RESET {0}
	set_component_parameter_value USE_RESET_REQUEST {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation reset_in
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface in_reset reset INPUT
	set_instantiation_interface_parameter_value in_reset associatedClock {clk}
	set_instantiation_interface_parameter_value in_reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port in_reset in_reset reset 1 STD_LOGIC Input
	add_instantiation_interface out_reset reset OUTPUT
	set_instantiation_interface_parameter_value out_reset associatedClock {clk}
	set_instantiation_interface_parameter_value out_reset associatedDirectReset {in_reset}
	set_instantiation_interface_parameter_value out_reset associatedResetSinks {in_reset}
	set_instantiation_interface_parameter_value out_reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port out_reset out_reset reset 1 STD_LOGIC Output
	save_instantiation

	# add wirelevel expressions

	# preserve ports for debug

	# add the connections
	add_connection clock_in.out_clk/i2c_0.clock
	set_connection_parameter_value clock_in.out_clk/i2c_0.clock clockDomainSysInfo {-1}
	set_connection_parameter_value clock_in.out_clk/i2c_0.clock clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/i2c_0.clock clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/i2c_0.clock resetDomainSysInfo {-1}
	add_connection clock_in.out_clk/reset_in.clk
	set_connection_parameter_value clock_in.out_clk/reset_in.clk clockDomainSysInfo {-1}
	set_connection_parameter_value clock_in.out_clk/reset_in.clk clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/reset_in.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/reset_in.clk resetDomainSysInfo {-1}
	add_connection reset_in.out_reset/i2c_0.reset_sink
	set_connection_parameter_value reset_in.out_reset/i2c_0.reset_sink clockDomainSysInfo {-1}
	set_connection_parameter_value reset_in.out_reset/i2c_0.reset_sink clockResetSysInfo {}
	set_connection_parameter_value reset_in.out_reset/i2c_0.reset_sink resetDomainSysInfo {-1}

	# add the exports
	set_interface_property phy_clk EXPORT_OF clock_in.in_clk
	set_interface_property i2c_interrupt_sender EXPORT_OF i2c_0.interrupt_sender
	set_interface_property i2c_csr EXPORT_OF i2c_0.csr
	set_interface_property i2c_serial EXPORT_OF i2c_0.i2c_serial
	set_interface_property phy_reset EXPORT_OF reset_in.in_reset

	# set values for exposed HDL parameters

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="avmm_m_i2c">
  <datum __value="_sortIndex" value="2" type="int" />
  <datum __value="sopceditor_expanded" value="1" type="boolean" />
 </element>
 <element __value="avmm_m_i2c.s0">
  <datum __value="baseAddress" value="1024" type="String" />
 </element>
 <element __value="clock_in">
  <datum __value="_sortIndex" value="0" type="int" />
  <datum __value="sopceditor_expanded" value="1" type="boolean" />
 </element>
 <element __value="i2c_0">
  <datum __value="_sortIndex" value="3" type="int" />
  <datum __value="sopceditor_expanded" value="1" type="boolean" />
 </element>
 <element __value="i2c_0.csr">
  <datum __value="baseAddress" value="0" type="String" />
 </element>
 <element __value="reset_in">
  <datum __value="_sortIndex" value="1" type="int" />
  <datum __value="sopceditor_expanded" value="1" type="boolean" />
 </element>
 <element __value="sysA_0">
  <datum __value="_sortIndex" value="3" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {phy_mgmt.qsys}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {phy_mgmt}

	# save the system
	sync_sysinfo_parameters
	save_system phy_mgmt
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_phy_mgmt

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
