package require -exact qsys 23.4

# create the system "sys"
proc do_create_sys {} {
	# create the system
	create_system sys
	set_project_property BOARD {Agilex 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {false}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_component clock_in ip/sys/sys_clock_in.ip altera_clock_bridge clock_in
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
	add_component custom_pe_2_0 ip/sys/sys_custom_pe_2_0.ip custom_pe_2 custom_pe_2_0
	load_component custom_pe_2_0
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation custom_pe_2_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface niosv_custom_instruction_subordinate niosv_custom_instruction INPUT
	add_instantiation_interface_port niosv_custom_instruction_subordinate alu_result alu_result 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate clk clk 1 STD_LOGIC Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate ctrl ctrl 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate data0 data0 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate data1 data1 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate done done 1 STD_LOGIC Output
	add_instantiation_interface_port niosv_custom_instruction_subordinate enable enable 1 STD_LOGIC Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate reset reset 1 STD_LOGIC Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate result result 32 STD_LOGIC_VECTOR Output
	save_instantiation
	
	add_component intel_niosv_g_0 ip/sys/sys_intel_niosv_g_0.ip intel_niosv_g intel_niosv_g_0
	load_component intel_niosv_g_0
	apply_component_preset intel_niosv_g
	save_component
	
	add_component jtag_uart_0 ip/sys/sys_jtag_uart_0.ip altera_avalon_jtag_uart jtag_uart_0
	load_component jtag_uart_0
	set_component_parameter_value allowMultipleConnections {0}
	set_component_parameter_value hubInstanceID {0}
	set_component_parameter_value readBufferDepth {64}
	set_component_parameter_value readIRQThreshold {8}
	set_component_parameter_value simInputCharacterStream {}
	set_component_parameter_value simInteractiveOptions {NO_INTERACTIVE_WINDOWS}
	set_component_parameter_value useRegistersForReadBuffer {0}
	set_component_parameter_value useRegistersForWriteBuffer {0}
	set_component_parameter_value useRelativePathForSimFile {0}
	set_component_parameter_value writeBufferDepth {64}
	set_component_parameter_value writeIRQThreshold {8}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation jtag_uart_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.READ_DEPTH {64}
	set_instantiation_assignment_value embeddedsw.CMacro.READ_THRESHOLD {8}
	set_instantiation_assignment_value embeddedsw.CMacro.WRITE_DEPTH {64}
	set_instantiation_assignment_value embeddedsw.CMacro.WRITE_THRESHOLD {8}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,juart-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {serial}
	set_instantiation_assignment_value embeddedsw.dts.name {juart}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset rst_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface avalon_jtag_slave avalon INPUT
	set_instantiation_interface_parameter_value avalon_jtag_slave addressAlignment {NATIVE}
	set_instantiation_interface_parameter_value avalon_jtag_slave addressGroup {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave addressSpan {2}
	set_instantiation_interface_parameter_value avalon_jtag_slave addressUnits {WORDS}
	set_instantiation_interface_parameter_value avalon_jtag_slave alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave associatedClock {clk}
	set_instantiation_interface_parameter_value avalon_jtag_slave associatedReset {reset}
	set_instantiation_interface_parameter_value avalon_jtag_slave bitsPerSymbol {8}
	set_instantiation_interface_parameter_value avalon_jtag_slave bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave bridgesToMaster {}
	set_instantiation_interface_parameter_value avalon_jtag_slave burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value avalon_jtag_slave constantBurstBehavior {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureId {35}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhGroupId {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterData {}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterDataLength {}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterId {}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterName {}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterVersion {}
	set_instantiation_interface_parameter_value avalon_jtag_slave explicitAddressSpan {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave holdTime {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave interleaveBursts {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave isBigEndian {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave isFlash {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave isMemoryDevice {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave linewrapBursts {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave minimumReadLatency {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave minimumResponseLatency {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave prSafe {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave printableDevice {true}
	set_instantiation_interface_parameter_value avalon_jtag_slave readLatency {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave readWaitStates {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave readWaitTime {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave registerIncomingSignals {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave setupTime {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave timingUnits {Cycles}
	set_instantiation_interface_parameter_value avalon_jtag_slave transparentBridge {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave waitrequestAllowance {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave writeLatency {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave writeWaitStates {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave writeWaitTime {0}
	set_instantiation_interface_assignment_value avalon_jtag_slave embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value avalon_jtag_slave embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value avalon_jtag_slave embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value avalon_jtag_slave embeddedsw.configuration.isPrintableDevice {1}
	set_instantiation_interface_sysinfo_parameter_value avalon_jtag_slave address_map {<address-map><slave name='avalon_jtag_slave' start='0x0' end='0x8' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value avalon_jtag_slave address_width {3}
	set_instantiation_interface_sysinfo_parameter_value avalon_jtag_slave max_slave_data_width {32}
	add_instantiation_interface_port avalon_jtag_slave av_chipselect chipselect 1 STD_LOGIC Input
	add_instantiation_interface_port avalon_jtag_slave av_address address 1 STD_LOGIC Input
	add_instantiation_interface_port avalon_jtag_slave av_read_n read_n 1 STD_LOGIC Input
	add_instantiation_interface_port avalon_jtag_slave av_readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port avalon_jtag_slave av_write_n write_n 1 STD_LOGIC Input
	add_instantiation_interface_port avalon_jtag_slave av_writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port avalon_jtag_slave av_waitrequest waitrequest 1 STD_LOGIC Output
	add_instantiation_interface irq interrupt INPUT
	set_instantiation_interface_parameter_value irq associatedAddressablePoint {avalon_jtag_slave}
	set_instantiation_interface_parameter_value irq associatedClock {clk}
	set_instantiation_interface_parameter_value irq associatedReset {reset}
	set_instantiation_interface_parameter_value irq bridgedReceiverOffset {0}
	set_instantiation_interface_parameter_value irq bridgesToReceiver {}
	set_instantiation_interface_parameter_value irq irqScheme {NONE}
	add_instantiation_interface_port irq av_irq irq 1 STD_LOGIC Output
	save_instantiation
	
	add_component onchip_memory2_0 ip/sys/sys_intel_onchip_memory_0.ip intel_onchip_memory intel_onchip_memory_0
	load_component onchip_memory2_0
	apply_component_preset on_chip_memory_2
	save_component

	add_component reset_bridge_0 ip/sys/sys_reset_bridge_0.ip altera_reset_bridge reset_bridge_0
	load_component reset_bridge_0
	set_component_parameter_value ACTIVE_LOW_RESET {0}
	set_component_parameter_value NUM_RESET_OUTPUTS {1}
	set_component_parameter_value SYNCHRONOUS_EDGES {deassert}
	set_component_parameter_value SYNC_RESET {0}
	set_component_parameter_value USE_RESET_REQUEST {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation reset_bridge_0
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
	add_component s10_user_rst_clkgate_0 ip/sys/sys_s10_user_rst_clkgate_0.ip altera_s10_user_rst_clkgate s10_user_rst_clkgate_0
	load_component s10_user_rst_clkgate_0
	set_component_parameter_value outputType {Reset Interface}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation s10_user_rst_clkgate_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface ninit_done reset OUTPUT
	set_instantiation_interface_parameter_value ninit_done associatedClock {}
	set_instantiation_interface_parameter_value ninit_done associatedDirectReset {}
	set_instantiation_interface_parameter_value ninit_done associatedResetSinks {none}
	set_instantiation_interface_parameter_value ninit_done synchronousEdges {NONE}
	add_instantiation_interface_port ninit_done ninit_done reset 1 STD_LOGIC Output
	save_instantiation
	add_component sys_custom_pe_1_0 ip/sys/sys_custom_pe_1_0.ip custom_pe_1 sys_custom_pe_1_0
	load_component sys_custom_pe_1_0
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation sys_custom_pe_1_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface niosv_custom_instruction_subordinate niosv_custom_instruction INPUT
	add_instantiation_interface_port niosv_custom_instruction_subordinate alu_result alu_result 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate clk clk 1 STD_LOGIC Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate ctrl ctrl 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate data0 data0 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate data1 data1 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate done done 1 STD_LOGIC Output
	add_instantiation_interface_port niosv_custom_instruction_subordinate enable enable 1 STD_LOGIC Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate reset reset 1 STD_LOGIC Input
	add_instantiation_interface_port niosv_custom_instruction_subordinate result result 32 STD_LOGIC_VECTOR Output
	save_instantiation
	add_component sysid_qsys_0 ip/sys/sys_sysid_qsys_0.ip altera_avalon_sysid_qsys sysid_qsys_0
	load_component sysid_qsys_0
	set_component_parameter_value id {-1447508010}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation sysid_qsys_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.ID {-1447508010}
	set_instantiation_assignment_value embeddedsw.CMacro.TIMESTAMP {0}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,sysid-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {sysid}
	set_instantiation_assignment_value embeddedsw.dts.name {sysid}
	set_instantiation_assignment_value embeddedsw.dts.params.id {-1447508010}
	set_instantiation_assignment_value embeddedsw.dts.params.timestamp {0}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clock clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface control_slave avalon INPUT
	set_instantiation_interface_parameter_value control_slave addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value control_slave addressGroup {0}
	set_instantiation_interface_parameter_value control_slave addressSpan {8}
	set_instantiation_interface_parameter_value control_slave addressUnits {WORDS}
	set_instantiation_interface_parameter_value control_slave alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value control_slave associatedClock {clk}
	set_instantiation_interface_parameter_value control_slave associatedReset {reset}
	set_instantiation_interface_parameter_value control_slave bitsPerSymbol {8}
	set_instantiation_interface_parameter_value control_slave bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value control_slave bridgesToMaster {}
	set_instantiation_interface_parameter_value control_slave burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value control_slave burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value control_slave constantBurstBehavior {false}
	set_instantiation_interface_parameter_value control_slave dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value control_slave dfhFeatureId {35}
	set_instantiation_interface_parameter_value control_slave dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value control_slave dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value control_slave dfhGroupId {0}
	set_instantiation_interface_parameter_value control_slave dfhParameterData {}
	set_instantiation_interface_parameter_value control_slave dfhParameterDataLength {}
	set_instantiation_interface_parameter_value control_slave dfhParameterId {}
	set_instantiation_interface_parameter_value control_slave dfhParameterName {}
	set_instantiation_interface_parameter_value control_slave dfhParameterVersion {}
	set_instantiation_interface_parameter_value control_slave explicitAddressSpan {0}
	set_instantiation_interface_parameter_value control_slave holdTime {0}
	set_instantiation_interface_parameter_value control_slave interleaveBursts {false}
	set_instantiation_interface_parameter_value control_slave isBigEndian {false}
	set_instantiation_interface_parameter_value control_slave isFlash {false}
	set_instantiation_interface_parameter_value control_slave isMemoryDevice {false}
	set_instantiation_interface_parameter_value control_slave isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value control_slave linewrapBursts {false}
	set_instantiation_interface_parameter_value control_slave maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value control_slave maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value control_slave minimumReadLatency {1}
	set_instantiation_interface_parameter_value control_slave minimumResponseLatency {1}
	set_instantiation_interface_parameter_value control_slave minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value control_slave prSafe {false}
	set_instantiation_interface_parameter_value control_slave printableDevice {false}
	set_instantiation_interface_parameter_value control_slave readLatency {0}
	set_instantiation_interface_parameter_value control_slave readWaitStates {1}
	set_instantiation_interface_parameter_value control_slave readWaitTime {1}
	set_instantiation_interface_parameter_value control_slave registerIncomingSignals {false}
	set_instantiation_interface_parameter_value control_slave registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value control_slave setupTime {0}
	set_instantiation_interface_parameter_value control_slave timingUnits {Cycles}
	set_instantiation_interface_parameter_value control_slave transparentBridge {false}
	set_instantiation_interface_parameter_value control_slave waitrequestAllowance {0}
	set_instantiation_interface_parameter_value control_slave wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value control_slave writeLatency {0}
	set_instantiation_interface_parameter_value control_slave writeWaitStates {0}
	set_instantiation_interface_parameter_value control_slave writeWaitTime {0}
	set_instantiation_interface_assignment_value control_slave embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value control_slave embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value control_slave embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value control_slave embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value control_slave address_map {<address-map><slave name='control_slave' start='0x0' end='0x8' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value control_slave address_width {3}
	set_instantiation_interface_sysinfo_parameter_value control_slave max_slave_data_width {32}
	add_instantiation_interface_port control_slave readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port control_slave address address 1 STD_LOGIC Input
	save_instantiation

	# add wirelevel expressions

	# preserve ports for debug

	# add the connections
	add_connection clock_in.out_clk/intel_niosv_g_0.clk
	set_connection_parameter_value clock_in.out_clk/intel_niosv_g_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/intel_niosv_g_0.clk clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/intel_niosv_g_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/intel_niosv_g_0.clk resetDomainSysInfo {1}
	add_connection clock_in.out_clk/jtag_uart_0.clk
	set_connection_parameter_value clock_in.out_clk/jtag_uart_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/jtag_uart_0.clk clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/jtag_uart_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/jtag_uart_0.clk resetDomainSysInfo {1}
	add_connection clock_in.out_clk/onchip_memory2_0.clk1
	set_connection_parameter_value clock_in.out_clk/onchip_memory2_0.clk1 clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/onchip_memory2_0.clk1 clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/onchip_memory2_0.clk1 clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/onchip_memory2_0.clk1 resetDomainSysInfo {1}
	add_connection clock_in.out_clk/reset_bridge_0.clk
	set_connection_parameter_value clock_in.out_clk/reset_bridge_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/reset_bridge_0.clk clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/reset_bridge_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/reset_bridge_0.clk resetDomainSysInfo {1}
	add_connection clock_in.out_clk/sysid_qsys_0.clk
	set_connection_parameter_value clock_in.out_clk/sysid_qsys_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/sysid_qsys_0.clk clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/sysid_qsys_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/sysid_qsys_0.clk resetDomainSysInfo {1}
	add_connection intel_niosv_g_0.ci_custom0/sys_custom_pe_1_0.niosv_custom_instruction_subordinate
	set_connection_parameter_value intel_niosv_g_0.ci_custom0/sys_custom_pe_1_0.niosv_custom_instruction_subordinate CIName {}
	set_connection_parameter_value intel_niosv_g_0.ci_custom0/sys_custom_pe_1_0.niosv_custom_instruction_subordinate CINameUpgrade {}
	set_connection_parameter_value intel_niosv_g_0.ci_custom0/sys_custom_pe_1_0.niosv_custom_instruction_subordinate baseAddress {0.0}
	set_connection_parameter_value intel_niosv_g_0.ci_custom0/sys_custom_pe_1_0.niosv_custom_instruction_subordinate customInstructionSubordinates {}
	add_connection intel_niosv_g_0.ci_custom1/custom_pe_2_0.niosv_custom_instruction_subordinate
	set_connection_parameter_value intel_niosv_g_0.ci_custom1/custom_pe_2_0.niosv_custom_instruction_subordinate CIName {}
	set_connection_parameter_value intel_niosv_g_0.ci_custom1/custom_pe_2_0.niosv_custom_instruction_subordinate CINameUpgrade {}
	set_connection_parameter_value intel_niosv_g_0.ci_custom1/custom_pe_2_0.niosv_custom_instruction_subordinate baseAddress {0.0}
	set_connection_parameter_value intel_niosv_g_0.ci_custom1/custom_pe_2_0.niosv_custom_instruction_subordinate customInstructionSubordinates {}
	add_connection intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent addressMapSysInfo {<address-map><slave name='onchip_memory2_0.s1' start='0x0' end='0xA0000' datawidth='32' /><slave name='intel_niosv_g_0.dm_agent' start='0x100000' end='0x110000' datawidth='32' /><slave name='intel_niosv_g_0.timer_sw_agent' start='0x110000' end='0x110040' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x110040' end='0x110048' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x212040' end='0x212048' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent addressWidthSysInfo {22}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent baseAddress {0x00100000}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent defaultConnection {0}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent domainAlias {}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.dm_agent slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent addressMapSysInfo {<address-map><slave name='onchip_memory2_0.s1' start='0x0' end='0xA0000' datawidth='32' /><slave name='intel_niosv_g_0.dm_agent' start='0x100000' end='0x110000' datawidth='32' /><slave name='intel_niosv_g_0.timer_sw_agent' start='0x110000' end='0x110040' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x110040' end='0x110048' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x212040' end='0x212048' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent addressWidthSysInfo {22}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent baseAddress {0x00110000}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent defaultConnection {0}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent domainAlias {}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/intel_niosv_g_0.timer_sw_agent slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave addressMapSysInfo {<address-map><slave name='onchip_memory2_0.s1' start='0x0' end='0xA0000' datawidth='32' /><slave name='intel_niosv_g_0.dm_agent' start='0x100000' end='0x110000' datawidth='32' /><slave name='intel_niosv_g_0.timer_sw_agent' start='0x110000' end='0x110040' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x110040' end='0x110048' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x212040' end='0x212048' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave addressWidthSysInfo {22}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave baseAddress {0x00110040}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave defaultConnection {0}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave domainAlias {}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/jtag_uart_0.avalon_jtag_slave slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_g_0.data_manager/onchip_memory2_0.s1
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 addressMapSysInfo {<address-map><slave name='onchip_memory2_0.s1' start='0x0' end='0xA0000' datawidth='32' /><slave name='intel_niosv_g_0.dm_agent' start='0x100000' end='0x110000' datawidth='32' /><slave name='intel_niosv_g_0.timer_sw_agent' start='0x110000' end='0x110040' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x110040' end='0x110048' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x212040' end='0x212048' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 addressWidthSysInfo {22}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 baseAddress {0x0000}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 defaultConnection {0}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 domainAlias {}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/onchip_memory2_0.s1 slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave addressMapSysInfo {<address-map><slave name='onchip_memory2_0.s1' start='0x0' end='0xA0000' datawidth='32' /><slave name='intel_niosv_g_0.dm_agent' start='0x100000' end='0x110000' datawidth='32' /><slave name='intel_niosv_g_0.timer_sw_agent' start='0x110000' end='0x110040' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x110040' end='0x110048' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x212040' end='0x212048' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave addressWidthSysInfo {22}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave baseAddress {0x00212040}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave defaultConnection {0}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave domainAlias {}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.data_manager/sysid_qsys_0.control_slave slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent addressMapSysInfo {<address-map><slave name='onchip_memory2_0.s1' start='0x0' end='0xA0000' datawidth='32' /><slave name='intel_niosv_g_0.dm_agent' start='0x100000' end='0x110000' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent baseAddress {0x00100000}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent defaultConnection {0}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent domainAlias {}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/intel_niosv_g_0.dm_agent slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 addressMapSysInfo {<address-map><slave name='onchip_memory2_0.s1' start='0x0' end='0xA0000' datawidth='32' /><slave name='intel_niosv_g_0.dm_agent' start='0x100000' end='0x110000' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 baseAddress {0x0000}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 defaultConnection {0}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 domainAlias {}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_g_0.instruction_manager/onchip_memory2_0.s1 slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_g_0.platform_irq_rx/jtag_uart_0.irq
	set_connection_parameter_value intel_niosv_g_0.platform_irq_rx/jtag_uart_0.irq interruptsUsedSysInfo {1}
	set_connection_parameter_value intel_niosv_g_0.platform_irq_rx/jtag_uart_0.irq irqNumber {0}
	add_connection reset_bridge_0.out_reset/intel_niosv_g_0.reset
	set_connection_parameter_value reset_bridge_0.out_reset/intel_niosv_g_0.reset clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/intel_niosv_g_0.reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/intel_niosv_g_0.reset resetDomainSysInfo {2}
	add_connection reset_bridge_0.out_reset/jtag_uart_0.reset
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset resetDomainSysInfo {2}
	add_connection reset_bridge_0.out_reset/onchip_memory2_0.reset1
	set_connection_parameter_value reset_bridge_0.out_reset/onchip_memory2_0.reset1 clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/onchip_memory2_0.reset1 clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/onchip_memory2_0.reset1 resetDomainSysInfo {2}
	add_connection reset_bridge_0.out_reset/sysid_qsys_0.reset
	set_connection_parameter_value reset_bridge_0.out_reset/sysid_qsys_0.reset clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/sysid_qsys_0.reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/sysid_qsys_0.reset resetDomainSysInfo {2}
	add_connection s10_user_rst_clkgate_0.ninit_done/reset_bridge_0.in_reset
	set_connection_parameter_value s10_user_rst_clkgate_0.ninit_done/reset_bridge_0.in_reset clockDomainSysInfo {2}
	set_connection_parameter_value s10_user_rst_clkgate_0.ninit_done/reset_bridge_0.in_reset clockResetSysInfo {}
	set_connection_parameter_value s10_user_rst_clkgate_0.ninit_done/reset_bridge_0.in_reset resetDomainSysInfo {2}

	# add the exports
	set_interface_property clk EXPORT_OF clock_in.in_clk
	set_interface_port_property clk clk_clk PIN_TABLE {0,PIN_G26,True Differential Signaling}

	# set values for exposed HDL parameters
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.burstAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.clockCrossingAdapter HANDSHAKE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.enableAllPipelines FALSE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.enableEccProtection FALSE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.enableInstrumentation FALSE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.enableOutOfOrderSupport FALSE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.insertDefaultSlave FALSE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.interconnectResetSource DEFAULT
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.interconnectType STANDARD
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.maxAdditionalLatency 1
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.optimizeRdFifoSize FALSE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.piplineType PIPELINE_STAGE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.responseFifoType REGISTER_BASED
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.syncResets TRUE
	set_domain_assignment intel_niosv_g_0.data_manager qsys_mm.widthAdapterImplementation GENERIC_CONVERTER

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="clock_in">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
 <element __value="custom_pe_2_0">
  <datum __value="_sortIndex" value="5" type="int" />
 </element>
 <element __value="intel_niosv_g_0">
  <datum __value="_sortIndex" value="1" type="int" />
 </element>
 <element __value="intel_niosv_g_0.dm_agent">
  <datum __value="baseAddress" value="1048576" type="String" />
 </element>
 <element __value="intel_niosv_g_0.timer_sw_agent">
  <datum __value="baseAddress" value="1114112" type="String" />
 </element>
 <element __value="jtag_uart_0">
  <datum __value="_sortIndex" value="3" type="int" />
 </element>
 <element __value="jtag_uart_0.avalon_jtag_slave">
  <datum __value="baseAddress" value="1114176" type="String" />
 </element>
 <element __value="onchip_memory2_0">
  <datum __value="_sortIndex" value="2" type="int" />
 </element>
 <element __value="onchip_memory2_0.s1">
  <datum __value="baseAddress" value="0" type="String" />
 </element>
 <element __value="reset_bridge_0">
  <datum __value="_sortIndex" value="8" type="int" />
 </element>
 <element __value="s10_user_rst_clkgate_0">
  <datum __value="_sortIndex" value="7" type="int" />
 </element>
 <element __value="sys_custom_pe_1_0">
  <datum __value="_sortIndex" value="4" type="int" />
 </element>
 <element __value="sysid_qsys_0">
  <datum __value="_sortIndex" value="6" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {sys.qsys}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {sys}

	# save the system
	sync_sysinfo_parameters
	save_system sys
}

proc do_set_exported_interface_sysinfo_parameters {} {
	load_system sys.qsys
	set_exported_interface_sysinfo_parameter_value clk clock_rate {50000000}
	save_system sys.qsys
}

# create all the systems, from bottom up
do_create_sys

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
