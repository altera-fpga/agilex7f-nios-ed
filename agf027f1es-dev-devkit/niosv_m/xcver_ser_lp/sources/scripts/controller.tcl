package require -exact qsys 24.2

# create the system "controller"
proc do_create_controller {} {
	# create the system
	create_system controller
	set_project_property BOARD {Agilex 7 FPGA F-Series Development Kit 2xF-Tile DK-DEV-AGF027F1ES}
	set_project_property DEVICE {AGFB027R24C2E2VR2}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {false}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_component clock_bridge_0 ip/controller/controller_clock_bridge_0.ip altera_clock_bridge clock_bridge_0
	load_component clock_bridge_0
	set_component_parameter_value EXPLICIT_CLOCK_RATE {125000000.0}
	set_component_parameter_value NUM_CLOCK_OUTPUTS {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation clock_bridge_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface in_clk clock INPUT
	set_instantiation_interface_parameter_value in_clk clockRate {0}
	set_instantiation_interface_parameter_value in_clk externallyDriven {false}
	set_instantiation_interface_parameter_value in_clk ptfSchematicName {}
	add_instantiation_interface_port in_clk in_clk clk 1 STD_LOGIC Input
	add_instantiation_interface out_clk clock OUTPUT
	set_instantiation_interface_parameter_value out_clk associatedDirectClock {in_clk}
	set_instantiation_interface_parameter_value out_clk clockRate {125000000}
	set_instantiation_interface_parameter_value out_clk clockRateKnown {true}
	set_instantiation_interface_parameter_value out_clk externallyDriven {false}
	set_instantiation_interface_parameter_value out_clk ptfSchematicName {}
	set_instantiation_interface_sysinfo_parameter_value out_clk clock_rate {125000000}
	add_instantiation_interface_port out_clk out_clk clk 1 STD_LOGIC Output
	save_instantiation
	add_component controller_reset_sequencer_0 ip/controller/controller_reset_sequencer_0.ip altera_reset_sequencer controller_reset_sequencer_0
	load_component controller_reset_sequencer_0
	set_component_parameter_value ENABLE_CSR {0}
	set_component_parameter_value ENABLE_RESET_REQUEST_INPUT {0}
	set_component_parameter_value LIST_ASRT_DELAY {5 5 0 0 0 0 0 0 0 0}
	set_component_parameter_value LIST_ASRT_SEQ {0 1 2 3 4 5 6 7 8 9}
	set_component_parameter_value LIST_DSRT_DELAY {5 5 0 0 0 0 0 0 0 0}
	set_component_parameter_value LIST_DSRT_SEQ {0 1 2 3 4 5 6 7 8 9}
	set_component_parameter_value MIN_ASRT_TIME {1}
	set_component_parameter_value NUM_INPUTS {1}
	set_component_parameter_value NUM_OUTPUTS {2}
	set_component_parameter_value USE_DSRT_QUAL {0 0 0 0 0 0 0 0 0 0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation controller_reset_sequencer_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset_in0 reset INPUT
	set_instantiation_interface_parameter_value reset_in0 associatedClock {}
	set_instantiation_interface_parameter_value reset_in0 synchronousEdges {NONE}
	add_instantiation_interface_port reset_in0 reset_in0 reset 1 STD_LOGIC Input
	add_instantiation_interface reset_out0 reset OUTPUT
	set_instantiation_interface_parameter_value reset_out0 associatedClock {clk}
	set_instantiation_interface_parameter_value reset_out0 associatedDirectReset {}
	set_instantiation_interface_parameter_value reset_out0 associatedResetSinks {reset_in0}
	set_instantiation_interface_parameter_value reset_out0 synchronousEdges {BOTH}
	add_instantiation_interface_port reset_out0 reset_out0 reset 1 STD_LOGIC Output
	add_instantiation_interface reset_out1 reset OUTPUT
	set_instantiation_interface_parameter_value reset_out1 associatedClock {clk}
	set_instantiation_interface_parameter_value reset_out1 associatedDirectReset {}
	set_instantiation_interface_parameter_value reset_out1 associatedResetSinks {reset_in0}
	set_instantiation_interface_parameter_value reset_out1 synchronousEdges {BOTH}
	add_instantiation_interface_port reset_out1 reset_out1 reset 1 STD_LOGIC Output
	save_instantiation
	add_component i2c_0 ip/controller/controller_i2c_0.ip altera_avalon_i2c i2c_0
	load_component i2c_0
	set_component_parameter_value FIFO_DEPTH {4}
	set_component_parameter_value USE_AV_ST {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation i2c_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.FIFO_DEPTH {4}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {125000000}
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
	set_instantiation_interface_parameter_value csr dfhFeatureType {3}
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
	set_instantiation_interface_parameter_value csr waitrequestTimeout {1024}
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
	add_component internal_noise ip/controller/internal_noise.ip altera_avalon_pio internal_noise
	load_component internal_noise
	set_component_parameter_value bitClearingEdgeCapReg {0}
	set_component_parameter_value bitModifyingOutReg {0}
	set_component_parameter_value captureEdge {0}
	set_component_parameter_value direction {Output}
	set_component_parameter_value edgeType {RISING}
	set_component_parameter_value generateIRQ {0}
	set_component_parameter_value irqType {LEVEL}
	set_component_parameter_value resetValue {0.0}
	set_component_parameter_value simDoTestBenchWiring {0}
	set_component_parameter_value simDrivenValue {0.0}
	set_component_parameter_value width {32}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation internal_noise
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_CLEARING_EDGE_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_MODIFYING_OUTPUT_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.CAPTURE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DATA_WIDTH {32}
	set_instantiation_assignment_value embeddedsw.CMacro.DO_TEST_BENCH_WIRING {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DRIVEN_SIM_VALUE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.EDGE_TYPE {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {125000000}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_IN {0}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_OUT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_TRI {0}
	set_instantiation_assignment_value embeddedsw.CMacro.IRQ_TYPE {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.RESET_VALUE {0}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,pio-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {gpio}
	set_instantiation_assignment_value embeddedsw.dts.name {pio}
	set_instantiation_assignment_value embeddedsw.dts.params.altr,gpio-bank-width {32}
	set_instantiation_assignment_value embeddedsw.dts.params.resetvalue {0}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface s1 avalon INPUT
	set_instantiation_interface_parameter_value s1 addressAlignment {NATIVE}
	set_instantiation_interface_parameter_value s1 addressGroup {0}
	set_instantiation_interface_parameter_value s1 addressSpan {4}
	set_instantiation_interface_parameter_value s1 addressUnits {WORDS}
	set_instantiation_interface_parameter_value s1 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s1 associatedClock {clk}
	set_instantiation_interface_parameter_value s1 associatedReset {reset}
	set_instantiation_interface_parameter_value s1 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s1 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s1 bridgesToMaster {}
	set_instantiation_interface_parameter_value s1 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s1 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s1 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s1 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s1 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureType {3}
	set_instantiation_interface_parameter_value s1 dfhGroupId {0}
	set_instantiation_interface_parameter_value s1 dfhParameterData {}
	set_instantiation_interface_parameter_value s1 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s1 dfhParameterId {}
	set_instantiation_interface_parameter_value s1 dfhParameterName {}
	set_instantiation_interface_parameter_value s1 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s1 explicitAddressSpan {0}
	set_instantiation_interface_parameter_value s1 holdTime {0}
	set_instantiation_interface_parameter_value s1 interleaveBursts {false}
	set_instantiation_interface_parameter_value s1 isBigEndian {false}
	set_instantiation_interface_parameter_value s1 isFlash {false}
	set_instantiation_interface_parameter_value s1 isMemoryDevice {false}
	set_instantiation_interface_parameter_value s1 isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value s1 linewrapBursts {false}
	set_instantiation_interface_parameter_value s1 maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value s1 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value s1 minimumReadLatency {1}
	set_instantiation_interface_parameter_value s1 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value s1 minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value s1 prSafe {false}
	set_instantiation_interface_parameter_value s1 printableDevice {false}
	set_instantiation_interface_parameter_value s1 readLatency {0}
	set_instantiation_interface_parameter_value s1 readWaitStates {1}
	set_instantiation_interface_parameter_value s1 readWaitTime {1}
	set_instantiation_interface_parameter_value s1 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value s1 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value s1 setupTime {0}
	set_instantiation_interface_parameter_value s1 timingUnits {Cycles}
	set_instantiation_interface_parameter_value s1 transparentBridge {false}
	set_instantiation_interface_parameter_value s1 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value s1 waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value s1 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s1 writeLatency {0}
	set_instantiation_interface_parameter_value s1 writeWaitStates {0}
	set_instantiation_interface_parameter_value s1 writeWaitTime {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value s1 address_map {<address-map><slave name='s1' start='0x0' end='0x10' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s1 address_width {4}
	set_instantiation_interface_sysinfo_parameter_value s1 max_slave_data_width {32}
	add_instantiation_interface_port s1 address address 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 write_n write_n 1 STD_LOGIC Input
	add_instantiation_interface_port s1 writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 chipselect chipselect 1 STD_LOGIC Input
	add_instantiation_interface_port s1 readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface external_connection conduit INPUT
	set_instantiation_interface_parameter_value external_connection associatedClock {}
	set_instantiation_interface_parameter_value external_connection associatedReset {}
	set_instantiation_interface_parameter_value external_connection prSafe {false}
	add_instantiation_interface_port external_connection out_port export 32 STD_LOGIC_VECTOR Output
	save_instantiation
	add_component irq_10us ip/controller/controller_irq_10us.ip altera_avalon_timer irq_10us
	load_component irq_10us
	set_component_parameter_value alwaysRun {0}
	set_component_parameter_value counterSize {32}
	set_component_parameter_value fixedPeriod {0}
	set_component_parameter_value period {10}
	set_component_parameter_value periodUnits {USEC}
	set_component_parameter_value resetOutput {0}
	set_component_parameter_value snapshot {1}
	set_component_parameter_value timeoutPulseOutput {0}
	set_component_parameter_value watchdogPulse {2}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation irq_10us
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.ALWAYS_RUN {0}
	set_instantiation_assignment_value embeddedsw.CMacro.COUNTER_SIZE {32}
	set_instantiation_assignment_value embeddedsw.CMacro.FIXED_PERIOD {0}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {125000000}
	set_instantiation_assignment_value embeddedsw.CMacro.LOAD_VALUE {1249}
	set_instantiation_assignment_value embeddedsw.CMacro.MULT {0.000001}
	set_instantiation_assignment_value embeddedsw.CMacro.PERIOD {10}
	set_instantiation_assignment_value embeddedsw.CMacro.PERIOD_UNITS {us}
	set_instantiation_assignment_value embeddedsw.CMacro.RESET_OUTPUT {0}
	set_instantiation_assignment_value embeddedsw.CMacro.SNAPSHOT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.TICKS_PER_SEC {100000}
	set_instantiation_assignment_value embeddedsw.CMacro.TIMEOUT_PULSE_OUTPUT {0}
	set_instantiation_assignment_value embeddedsw.CMacro.TIMER_DEVICE_TYPE {1}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,timer-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {timer}
	set_instantiation_assignment_value embeddedsw.dts.name {timer}
	set_instantiation_assignment_value embeddedsw.dts.params.clock-frequency {125000000}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface s1 avalon INPUT
	set_instantiation_interface_parameter_value s1 addressAlignment {NATIVE}
	set_instantiation_interface_parameter_value s1 addressGroup {0}
	set_instantiation_interface_parameter_value s1 addressSpan {8}
	set_instantiation_interface_parameter_value s1 addressUnits {WORDS}
	set_instantiation_interface_parameter_value s1 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s1 associatedClock {clk}
	set_instantiation_interface_parameter_value s1 associatedReset {reset}
	set_instantiation_interface_parameter_value s1 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s1 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s1 bridgesToMaster {}
	set_instantiation_interface_parameter_value s1 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s1 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s1 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s1 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s1 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureType {3}
	set_instantiation_interface_parameter_value s1 dfhGroupId {0}
	set_instantiation_interface_parameter_value s1 dfhParameterData {}
	set_instantiation_interface_parameter_value s1 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s1 dfhParameterId {}
	set_instantiation_interface_parameter_value s1 dfhParameterName {}
	set_instantiation_interface_parameter_value s1 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s1 explicitAddressSpan {0}
	set_instantiation_interface_parameter_value s1 holdTime {0}
	set_instantiation_interface_parameter_value s1 interleaveBursts {false}
	set_instantiation_interface_parameter_value s1 isBigEndian {false}
	set_instantiation_interface_parameter_value s1 isFlash {false}
	set_instantiation_interface_parameter_value s1 isMemoryDevice {false}
	set_instantiation_interface_parameter_value s1 isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value s1 linewrapBursts {false}
	set_instantiation_interface_parameter_value s1 maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value s1 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value s1 minimumReadLatency {1}
	set_instantiation_interface_parameter_value s1 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value s1 minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value s1 prSafe {false}
	set_instantiation_interface_parameter_value s1 printableDevice {false}
	set_instantiation_interface_parameter_value s1 readLatency {0}
	set_instantiation_interface_parameter_value s1 readWaitStates {1}
	set_instantiation_interface_parameter_value s1 readWaitTime {1}
	set_instantiation_interface_parameter_value s1 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value s1 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value s1 setupTime {0}
	set_instantiation_interface_parameter_value s1 timingUnits {Cycles}
	set_instantiation_interface_parameter_value s1 transparentBridge {false}
	set_instantiation_interface_parameter_value s1 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value s1 waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value s1 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s1 writeLatency {0}
	set_instantiation_interface_parameter_value s1 writeWaitStates {0}
	set_instantiation_interface_parameter_value s1 writeWaitTime {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isTimerDevice {1}
	set_instantiation_interface_sysinfo_parameter_value s1 address_map {<address-map><slave name='s1' start='0x0' end='0x20' datawidth='16' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s1 address_width {5}
	set_instantiation_interface_sysinfo_parameter_value s1 max_slave_data_width {16}
	add_instantiation_interface_port s1 address address 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 writedata writedata 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 readdata readdata 16 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s1 chipselect chipselect 1 STD_LOGIC Input
	add_instantiation_interface_port s1 write_n write_n 1 STD_LOGIC Input
	add_instantiation_interface irq interrupt INPUT
	set_instantiation_interface_parameter_value irq associatedAddressablePoint {s1}
	set_instantiation_interface_parameter_value irq associatedClock {clk}
	set_instantiation_interface_parameter_value irq associatedReset {reset}
	set_instantiation_interface_parameter_value irq bridgedReceiverOffset {0}
	set_instantiation_interface_parameter_value irq bridgesToReceiver {}
	set_instantiation_interface_parameter_value irq irqScheme {NONE}
	add_instantiation_interface_port irq irq irq 1 STD_LOGIC Output
	save_instantiation
	add_component jtag_uart ip/controller/controller_jtag_uart.ip altera_avalon_jtag_uart jtag_uart
	load_component jtag_uart
	set_component_parameter_value allowMultipleConnections {0}
	set_component_parameter_value hubInstanceID {0}
	set_component_parameter_value readBufferDepth {64}
	set_component_parameter_value readIRQThreshold {8}
	set_component_parameter_value simInputCharacterStream {}
	set_component_parameter_value simInteractiveOptions {INTERACTIVE_INPUT_OUTPUT}
	set_component_parameter_value useRegistersForReadBuffer {0}
	set_component_parameter_value useRegistersForWriteBuffer {0}
	set_component_parameter_value useRelativePathForSimFile {0}
	set_component_parameter_value writeBufferDepth {64}
	set_component_parameter_value writeIRQThreshold {8}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation jtag_uart
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
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureType {3}
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
	set_instantiation_interface_parameter_value avalon_jtag_slave waitrequestTimeout {1024}
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
	add_component module_input_reg ip/controller/controller_pio_2.ip altera_avalon_pio pio_2
	load_component module_input_reg
	set_component_parameter_value bitClearingEdgeCapReg {0}
	set_component_parameter_value bitModifyingOutReg {0}
	set_component_parameter_value captureEdge {1}
	set_component_parameter_value direction {Input}
	set_component_parameter_value edgeType {RISING}
	set_component_parameter_value generateIRQ {0}
	set_component_parameter_value irqType {LEVEL}
	set_component_parameter_value resetValue {0.0}
	set_component_parameter_value simDoTestBenchWiring {0}
	set_component_parameter_value simDrivenValue {0.0}
	set_component_parameter_value width {32}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation module_input_reg
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_CLEARING_EDGE_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_MODIFYING_OUTPUT_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.CAPTURE {1}
	set_instantiation_assignment_value embeddedsw.CMacro.DATA_WIDTH {32}
	set_instantiation_assignment_value embeddedsw.CMacro.DO_TEST_BENCH_WIRING {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DRIVEN_SIM_VALUE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.EDGE_TYPE {RISING}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {125000000}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_IN {1}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_OUT {0}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_TRI {0}
	set_instantiation_assignment_value embeddedsw.CMacro.IRQ_TYPE {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.RESET_VALUE {0}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,pio-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {gpio}
	set_instantiation_assignment_value embeddedsw.dts.name {pio}
	set_instantiation_assignment_value embeddedsw.dts.params.altr,gpio-bank-width {32}
	set_instantiation_assignment_value embeddedsw.dts.params.resetvalue {0}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface s1 avalon INPUT
	set_instantiation_interface_parameter_value s1 addressAlignment {NATIVE}
	set_instantiation_interface_parameter_value s1 addressGroup {0}
	set_instantiation_interface_parameter_value s1 addressSpan {4}
	set_instantiation_interface_parameter_value s1 addressUnits {WORDS}
	set_instantiation_interface_parameter_value s1 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s1 associatedClock {clk}
	set_instantiation_interface_parameter_value s1 associatedReset {reset}
	set_instantiation_interface_parameter_value s1 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s1 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s1 bridgesToMaster {}
	set_instantiation_interface_parameter_value s1 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s1 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s1 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s1 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s1 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureType {3}
	set_instantiation_interface_parameter_value s1 dfhGroupId {0}
	set_instantiation_interface_parameter_value s1 dfhParameterData {}
	set_instantiation_interface_parameter_value s1 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s1 dfhParameterId {}
	set_instantiation_interface_parameter_value s1 dfhParameterName {}
	set_instantiation_interface_parameter_value s1 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s1 explicitAddressSpan {0}
	set_instantiation_interface_parameter_value s1 holdTime {0}
	set_instantiation_interface_parameter_value s1 interleaveBursts {false}
	set_instantiation_interface_parameter_value s1 isBigEndian {false}
	set_instantiation_interface_parameter_value s1 isFlash {false}
	set_instantiation_interface_parameter_value s1 isMemoryDevice {false}
	set_instantiation_interface_parameter_value s1 isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value s1 linewrapBursts {false}
	set_instantiation_interface_parameter_value s1 maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value s1 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value s1 minimumReadLatency {1}
	set_instantiation_interface_parameter_value s1 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value s1 minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value s1 prSafe {false}
	set_instantiation_interface_parameter_value s1 printableDevice {false}
	set_instantiation_interface_parameter_value s1 readLatency {0}
	set_instantiation_interface_parameter_value s1 readWaitStates {1}
	set_instantiation_interface_parameter_value s1 readWaitTime {1}
	set_instantiation_interface_parameter_value s1 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value s1 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value s1 setupTime {0}
	set_instantiation_interface_parameter_value s1 timingUnits {Cycles}
	set_instantiation_interface_parameter_value s1 transparentBridge {false}
	set_instantiation_interface_parameter_value s1 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value s1 waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value s1 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s1 writeLatency {0}
	set_instantiation_interface_parameter_value s1 writeWaitStates {0}
	set_instantiation_interface_parameter_value s1 writeWaitTime {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value s1 address_map {<address-map><slave name='s1' start='0x0' end='0x10' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s1 address_width {4}
	set_instantiation_interface_sysinfo_parameter_value s1 max_slave_data_width {32}
	add_instantiation_interface_port s1 address address 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 write_n write_n 1 STD_LOGIC Input
	add_instantiation_interface_port s1 writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 chipselect chipselect 1 STD_LOGIC Input
	add_instantiation_interface_port s1 readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface external_connection conduit INPUT
	set_instantiation_interface_parameter_value external_connection associatedClock {}
	set_instantiation_interface_parameter_value external_connection associatedReset {}
	set_instantiation_interface_parameter_value external_connection prSafe {false}
	add_instantiation_interface_port external_connection in_port export 32 STD_LOGIC_VECTOR Input
	save_instantiation
	add_component module_output_reg ip/controller/controller_pio_3.ip altera_avalon_pio pio_3
	load_component module_output_reg
	set_component_parameter_value bitClearingEdgeCapReg {0}
	set_component_parameter_value bitModifyingOutReg {0}
	set_component_parameter_value captureEdge {0}
	set_component_parameter_value direction {Output}
	set_component_parameter_value edgeType {RISING}
	set_component_parameter_value generateIRQ {0}
	set_component_parameter_value irqType {LEVEL}
	set_component_parameter_value resetValue {858993459.0}
	set_component_parameter_value simDoTestBenchWiring {0}
	set_component_parameter_value simDrivenValue {0.0}
	set_component_parameter_value width {32}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation module_output_reg
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_CLEARING_EDGE_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_MODIFYING_OUTPUT_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.CAPTURE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DATA_WIDTH {32}
	set_instantiation_assignment_value embeddedsw.CMacro.DO_TEST_BENCH_WIRING {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DRIVEN_SIM_VALUE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.EDGE_TYPE {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {125000000}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_IN {0}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_OUT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_TRI {0}
	set_instantiation_assignment_value embeddedsw.CMacro.IRQ_TYPE {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.RESET_VALUE {858993459}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,pio-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {gpio}
	set_instantiation_assignment_value embeddedsw.dts.name {pio}
	set_instantiation_assignment_value embeddedsw.dts.params.altr,gpio-bank-width {32}
	set_instantiation_assignment_value embeddedsw.dts.params.resetvalue {858993459}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface s1 avalon INPUT
	set_instantiation_interface_parameter_value s1 addressAlignment {NATIVE}
	set_instantiation_interface_parameter_value s1 addressGroup {0}
	set_instantiation_interface_parameter_value s1 addressSpan {4}
	set_instantiation_interface_parameter_value s1 addressUnits {WORDS}
	set_instantiation_interface_parameter_value s1 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s1 associatedClock {clk}
	set_instantiation_interface_parameter_value s1 associatedReset {reset}
	set_instantiation_interface_parameter_value s1 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s1 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s1 bridgesToMaster {}
	set_instantiation_interface_parameter_value s1 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s1 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s1 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s1 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s1 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureType {3}
	set_instantiation_interface_parameter_value s1 dfhGroupId {0}
	set_instantiation_interface_parameter_value s1 dfhParameterData {}
	set_instantiation_interface_parameter_value s1 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s1 dfhParameterId {}
	set_instantiation_interface_parameter_value s1 dfhParameterName {}
	set_instantiation_interface_parameter_value s1 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s1 explicitAddressSpan {0}
	set_instantiation_interface_parameter_value s1 holdTime {0}
	set_instantiation_interface_parameter_value s1 interleaveBursts {false}
	set_instantiation_interface_parameter_value s1 isBigEndian {false}
	set_instantiation_interface_parameter_value s1 isFlash {false}
	set_instantiation_interface_parameter_value s1 isMemoryDevice {false}
	set_instantiation_interface_parameter_value s1 isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value s1 linewrapBursts {false}
	set_instantiation_interface_parameter_value s1 maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value s1 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value s1 minimumReadLatency {1}
	set_instantiation_interface_parameter_value s1 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value s1 minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value s1 prSafe {false}
	set_instantiation_interface_parameter_value s1 printableDevice {false}
	set_instantiation_interface_parameter_value s1 readLatency {0}
	set_instantiation_interface_parameter_value s1 readWaitStates {1}
	set_instantiation_interface_parameter_value s1 readWaitTime {1}
	set_instantiation_interface_parameter_value s1 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value s1 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value s1 setupTime {0}
	set_instantiation_interface_parameter_value s1 timingUnits {Cycles}
	set_instantiation_interface_parameter_value s1 transparentBridge {false}
	set_instantiation_interface_parameter_value s1 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value s1 waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value s1 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s1 writeLatency {0}
	set_instantiation_interface_parameter_value s1 writeWaitStates {0}
	set_instantiation_interface_parameter_value s1 writeWaitTime {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value s1 address_map {<address-map><slave name='s1' start='0x0' end='0x10' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s1 address_width {4}
	set_instantiation_interface_sysinfo_parameter_value s1 max_slave_data_width {32}
	add_instantiation_interface_port s1 address address 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 write_n write_n 1 STD_LOGIC Input
	add_instantiation_interface_port s1 writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 chipselect chipselect 1 STD_LOGIC Input
	add_instantiation_interface_port s1 readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface external_connection conduit INPUT
	set_instantiation_interface_parameter_value external_connection associatedClock {}
	set_instantiation_interface_parameter_value external_connection associatedReset {}
	set_instantiation_interface_parameter_value external_connection prSafe {false}
	add_instantiation_interface_port external_connection out_port export 32 STD_LOGIC_VECTOR Output
	save_instantiation
	add_component niosv_m ip/controller/controller_intel_niosv_m_0.ip intel_niosv_m intel_niosv_m_0
	load_component niosv_m
	set_component_parameter_value enableDebug {1}
	set_component_parameter_value enableDebugReset {0}
	set_component_parameter_value enableECCLite {0}
	set_component_parameter_value hartId {0}
	set_component_parameter_value numGpr {32}
	set_component_parameter_value pipelineArch {1}
	set_component_parameter_value resetOffset {0}
	set_component_parameter_value resetSlave {prg_ram.axi_s1}
	set_component_parameter_value useResetReq {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation niosv_m
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.CPU_FREQ {125000000u}
	set_instantiation_assignment_value embeddedsw.CMacro.DATA_ADDR_WIDTH {32}
	set_instantiation_assignment_value embeddedsw.CMacro.DCACHE_LINE_SIZE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DCACHE_LINE_SIZE_LOG2 {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DCACHE_SIZE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_CSR_SUPPORT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_DEBUG_STUB {}
	set_instantiation_assignment_value embeddedsw.CMacro.ICACHE_LINE_SIZE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.ICACHE_LINE_SIZE_LOG2 {0}
	set_instantiation_assignment_value embeddedsw.CMacro.ICACHE_SIZE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.INST_ADDR_WIDTH {32}
	set_instantiation_assignment_value embeddedsw.CMacro.MTIME_OFFSET {0x00410200}
	set_instantiation_assignment_value embeddedsw.CMacro.NIOSV_CORE_VARIANT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.NUM_GPR {32}
	set_instantiation_assignment_value embeddedsw.CMacro.RESET_ADDR {0x00000000}
	set_instantiation_assignment_value embeddedsw.CMacro.TICKS_PER_SEC {no_quote(NIOSV_INTERNAL_TIMER_TICKS_PER_SECOND)}
	set_instantiation_assignment_value embeddedsw.CMacro.TIMER_DEVICE_TYPE {2}
	set_instantiation_assignment_value embeddedsw.configuration.HDLSimCachesCleared {1}
	set_instantiation_assignment_value embeddedsw.configuration.cpuArchitecture {Abbotts Lake}
	set_instantiation_assignment_value embeddedsw.configuration.fpuEnabled {0}
	set_instantiation_assignment_value embeddedsw.configuration.isTimerDevice {1}
	set_instantiation_assignment_value embeddedsw.configuration.numGpr {32}
	set_instantiation_assignment_value embeddedsw.configuration.resetOffset {0}
	set_instantiation_assignment_value embeddedsw.configuration.resetSlave {prg_ram.axi_s1}
	set_instantiation_assignment_value embeddedsw.dts.params.altr,reset-addr {0x00000000}
	set_instantiation_assignment_value embeddedsw.dts.params.clock-frequency {125000000u}
	set_instantiation_assignment_value embeddedsw.dts.params.dcache-line-size {0}
	set_instantiation_assignment_value embeddedsw.dts.params.dcache-size {0}
	set_instantiation_assignment_value embeddedsw.dts.params.icache-line-size {0}
	set_instantiation_assignment_value embeddedsw.dts.params.icache-size {0}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset_reset reset 1 STD_LOGIC Input
	add_instantiation_interface platform_irq_rx interrupt OUTPUT
	set_instantiation_interface_parameter_value platform_irq_rx associatedAddressablePoint {}
	set_instantiation_interface_parameter_value platform_irq_rx associatedClock {clk}
	set_instantiation_interface_parameter_value platform_irq_rx associatedReset {reset}
	set_instantiation_interface_parameter_value platform_irq_rx irqMap {}
	set_instantiation_interface_parameter_value platform_irq_rx irqScheme {INDIVIDUAL_REQUESTS}
	add_instantiation_interface_port platform_irq_rx platform_irq_rx_irq irq 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface instruction_manager axi4lite OUTPUT
	set_instantiation_interface_parameter_value instruction_manager associatedClock {clk}
	set_instantiation_interface_parameter_value instruction_manager associatedReset {reset}
	set_instantiation_interface_parameter_value instruction_manager combinedIssuingCapability {8}
	set_instantiation_interface_parameter_value instruction_manager maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value instruction_manager maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value instruction_manager maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value instruction_manager poison {false}
	set_instantiation_interface_parameter_value instruction_manager readIssuingCapability {8}
	set_instantiation_interface_parameter_value instruction_manager traceSignals {false}
	set_instantiation_interface_parameter_value instruction_manager trustzoneAware {true}
	set_instantiation_interface_parameter_value instruction_manager uniqueIdSupport {false}
	set_instantiation_interface_parameter_value instruction_manager wakeupSignals {false}
	set_instantiation_interface_parameter_value instruction_manager writeIssuingCapability {1}
	add_instantiation_interface_port instruction_manager instruction_manager_awaddr awaddr 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port instruction_manager instruction_manager_awprot awprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port instruction_manager instruction_manager_awvalid awvalid 1 STD_LOGIC Output
	add_instantiation_interface_port instruction_manager instruction_manager_awready awready 1 STD_LOGIC Input
	add_instantiation_interface_port instruction_manager instruction_manager_wdata wdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port instruction_manager instruction_manager_wstrb wstrb 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port instruction_manager instruction_manager_wvalid wvalid 1 STD_LOGIC Output
	add_instantiation_interface_port instruction_manager instruction_manager_wready wready 1 STD_LOGIC Input
	add_instantiation_interface_port instruction_manager instruction_manager_bresp bresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port instruction_manager instruction_manager_bvalid bvalid 1 STD_LOGIC Input
	add_instantiation_interface_port instruction_manager instruction_manager_bready bready 1 STD_LOGIC Output
	add_instantiation_interface_port instruction_manager instruction_manager_araddr araddr 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port instruction_manager instruction_manager_arprot arprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port instruction_manager instruction_manager_arvalid arvalid 1 STD_LOGIC Output
	add_instantiation_interface_port instruction_manager instruction_manager_arready arready 1 STD_LOGIC Input
	add_instantiation_interface_port instruction_manager instruction_manager_rdata rdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port instruction_manager instruction_manager_rresp rresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port instruction_manager instruction_manager_rvalid rvalid 1 STD_LOGIC Input
	add_instantiation_interface_port instruction_manager instruction_manager_rready rready 1 STD_LOGIC Output
	add_instantiation_interface data_manager axi4lite OUTPUT
	set_instantiation_interface_parameter_value data_manager associatedClock {clk}
	set_instantiation_interface_parameter_value data_manager associatedReset {reset}
	set_instantiation_interface_parameter_value data_manager combinedIssuingCapability {1}
	set_instantiation_interface_parameter_value data_manager maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value data_manager maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value data_manager maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value data_manager poison {false}
	set_instantiation_interface_parameter_value data_manager readIssuingCapability {1}
	set_instantiation_interface_parameter_value data_manager traceSignals {false}
	set_instantiation_interface_parameter_value data_manager trustzoneAware {true}
	set_instantiation_interface_parameter_value data_manager uniqueIdSupport {false}
	set_instantiation_interface_parameter_value data_manager wakeupSignals {false}
	set_instantiation_interface_parameter_value data_manager writeIssuingCapability {1}
	add_instantiation_interface_port data_manager data_manager_awaddr awaddr 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port data_manager data_manager_awprot awprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port data_manager data_manager_awvalid awvalid 1 STD_LOGIC Output
	add_instantiation_interface_port data_manager data_manager_awready awready 1 STD_LOGIC Input
	add_instantiation_interface_port data_manager data_manager_wdata wdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port data_manager data_manager_wstrb wstrb 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port data_manager data_manager_wvalid wvalid 1 STD_LOGIC Output
	add_instantiation_interface_port data_manager data_manager_wready wready 1 STD_LOGIC Input
	add_instantiation_interface_port data_manager data_manager_bresp bresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port data_manager data_manager_bvalid bvalid 1 STD_LOGIC Input
	add_instantiation_interface_port data_manager data_manager_bready bready 1 STD_LOGIC Output
	add_instantiation_interface_port data_manager data_manager_araddr araddr 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port data_manager data_manager_arprot arprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port data_manager data_manager_arvalid arvalid 1 STD_LOGIC Output
	add_instantiation_interface_port data_manager data_manager_arready arready 1 STD_LOGIC Input
	add_instantiation_interface_port data_manager data_manager_rdata rdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port data_manager data_manager_rresp rresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port data_manager data_manager_rvalid rvalid 1 STD_LOGIC Input
	add_instantiation_interface_port data_manager data_manager_rready rready 1 STD_LOGIC Output
	add_instantiation_interface timer_sw_agent avalon INPUT
	set_instantiation_interface_parameter_value timer_sw_agent addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value timer_sw_agent addressGroup {0}
	set_instantiation_interface_parameter_value timer_sw_agent addressSpan {64}
	set_instantiation_interface_parameter_value timer_sw_agent addressUnits {SYMBOLS}
	set_instantiation_interface_parameter_value timer_sw_agent alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value timer_sw_agent associatedClock {clk}
	set_instantiation_interface_parameter_value timer_sw_agent associatedReset {reset}
	set_instantiation_interface_parameter_value timer_sw_agent bitsPerSymbol {8}
	set_instantiation_interface_parameter_value timer_sw_agent bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value timer_sw_agent bridgesToMaster {}
	set_instantiation_interface_parameter_value timer_sw_agent burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value timer_sw_agent burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value timer_sw_agent constantBurstBehavior {false}
	set_instantiation_interface_parameter_value timer_sw_agent dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value timer_sw_agent dfhFeatureId {35}
	set_instantiation_interface_parameter_value timer_sw_agent dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value timer_sw_agent dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value timer_sw_agent dfhFeatureType {3}
	set_instantiation_interface_parameter_value timer_sw_agent dfhGroupId {0}
	set_instantiation_interface_parameter_value timer_sw_agent dfhParameterData {}
	set_instantiation_interface_parameter_value timer_sw_agent dfhParameterDataLength {}
	set_instantiation_interface_parameter_value timer_sw_agent dfhParameterId {}
	set_instantiation_interface_parameter_value timer_sw_agent dfhParameterName {}
	set_instantiation_interface_parameter_value timer_sw_agent dfhParameterVersion {}
	set_instantiation_interface_parameter_value timer_sw_agent explicitAddressSpan {0}
	set_instantiation_interface_parameter_value timer_sw_agent holdTime {0}
	set_instantiation_interface_parameter_value timer_sw_agent interleaveBursts {false}
	set_instantiation_interface_parameter_value timer_sw_agent isBigEndian {false}
	set_instantiation_interface_parameter_value timer_sw_agent isFlash {false}
	set_instantiation_interface_parameter_value timer_sw_agent isMemoryDevice {false}
	set_instantiation_interface_parameter_value timer_sw_agent isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value timer_sw_agent linewrapBursts {false}
	set_instantiation_interface_parameter_value timer_sw_agent maximumPendingReadTransactions {2}
	set_instantiation_interface_parameter_value timer_sw_agent maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value timer_sw_agent minimumReadLatency {1}
	set_instantiation_interface_parameter_value timer_sw_agent minimumResponseLatency {1}
	set_instantiation_interface_parameter_value timer_sw_agent minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value timer_sw_agent prSafe {false}
	set_instantiation_interface_parameter_value timer_sw_agent printableDevice {false}
	set_instantiation_interface_parameter_value timer_sw_agent readLatency {0}
	set_instantiation_interface_parameter_value timer_sw_agent readWaitStates {1}
	set_instantiation_interface_parameter_value timer_sw_agent readWaitTime {1}
	set_instantiation_interface_parameter_value timer_sw_agent registerIncomingSignals {false}
	set_instantiation_interface_parameter_value timer_sw_agent registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value timer_sw_agent setupTime {0}
	set_instantiation_interface_parameter_value timer_sw_agent timingUnits {Cycles}
	set_instantiation_interface_parameter_value timer_sw_agent transparentBridge {false}
	set_instantiation_interface_parameter_value timer_sw_agent waitrequestAllowance {0}
	set_instantiation_interface_parameter_value timer_sw_agent waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value timer_sw_agent wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value timer_sw_agent writeLatency {0}
	set_instantiation_interface_parameter_value timer_sw_agent writeWaitStates {0}
	set_instantiation_interface_parameter_value timer_sw_agent writeWaitTime {0}
	set_instantiation_interface_assignment_value timer_sw_agent embeddedsw.configuration.hideDevice {1}
	set_instantiation_interface_assignment_value timer_sw_agent embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value timer_sw_agent embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value timer_sw_agent embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value timer_sw_agent embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_assignment_value timer_sw_agent qsys.ui.connect {data_manager}
	set_instantiation_interface_sysinfo_parameter_value timer_sw_agent address_map {<address-map><slave name='timer_sw_agent' start='0x0' end='0x40' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value timer_sw_agent address_width {6}
	set_instantiation_interface_sysinfo_parameter_value timer_sw_agent max_slave_data_width {32}
	add_instantiation_interface_port timer_sw_agent timer_sw_agent_address address 6 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port timer_sw_agent timer_sw_agent_byteenable byteenable 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port timer_sw_agent timer_sw_agent_read read 1 STD_LOGIC Input
	add_instantiation_interface_port timer_sw_agent timer_sw_agent_readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port timer_sw_agent timer_sw_agent_write write 1 STD_LOGIC Input
	add_instantiation_interface_port timer_sw_agent timer_sw_agent_writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port timer_sw_agent timer_sw_agent_waitrequest waitrequest 1 STD_LOGIC Output
	add_instantiation_interface_port timer_sw_agent timer_sw_agent_readdatavalid readdatavalid 1 STD_LOGIC Output
	add_instantiation_interface dm_agent avalon INPUT
	set_instantiation_interface_parameter_value dm_agent addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value dm_agent addressGroup {0}
	set_instantiation_interface_parameter_value dm_agent addressSpan {65536}
	set_instantiation_interface_parameter_value dm_agent addressUnits {SYMBOLS}
	set_instantiation_interface_parameter_value dm_agent alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value dm_agent associatedClock {clk}
	set_instantiation_interface_parameter_value dm_agent associatedReset {reset}
	set_instantiation_interface_parameter_value dm_agent bitsPerSymbol {8}
	set_instantiation_interface_parameter_value dm_agent bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value dm_agent bridgesToMaster {}
	set_instantiation_interface_parameter_value dm_agent burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value dm_agent burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value dm_agent constantBurstBehavior {false}
	set_instantiation_interface_parameter_value dm_agent dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value dm_agent dfhFeatureId {35}
	set_instantiation_interface_parameter_value dm_agent dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value dm_agent dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value dm_agent dfhFeatureType {3}
	set_instantiation_interface_parameter_value dm_agent dfhGroupId {0}
	set_instantiation_interface_parameter_value dm_agent dfhParameterData {}
	set_instantiation_interface_parameter_value dm_agent dfhParameterDataLength {}
	set_instantiation_interface_parameter_value dm_agent dfhParameterId {}
	set_instantiation_interface_parameter_value dm_agent dfhParameterName {}
	set_instantiation_interface_parameter_value dm_agent dfhParameterVersion {}
	set_instantiation_interface_parameter_value dm_agent explicitAddressSpan {0}
	set_instantiation_interface_parameter_value dm_agent holdTime {0}
	set_instantiation_interface_parameter_value dm_agent interleaveBursts {false}
	set_instantiation_interface_parameter_value dm_agent isBigEndian {false}
	set_instantiation_interface_parameter_value dm_agent isFlash {false}
	set_instantiation_interface_parameter_value dm_agent isMemoryDevice {false}
	set_instantiation_interface_parameter_value dm_agent isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value dm_agent linewrapBursts {false}
	set_instantiation_interface_parameter_value dm_agent maximumPendingReadTransactions {2}
	set_instantiation_interface_parameter_value dm_agent maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value dm_agent minimumReadLatency {1}
	set_instantiation_interface_parameter_value dm_agent minimumResponseLatency {1}
	set_instantiation_interface_parameter_value dm_agent minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value dm_agent prSafe {false}
	set_instantiation_interface_parameter_value dm_agent printableDevice {false}
	set_instantiation_interface_parameter_value dm_agent readLatency {0}
	set_instantiation_interface_parameter_value dm_agent readWaitStates {1}
	set_instantiation_interface_parameter_value dm_agent readWaitTime {1}
	set_instantiation_interface_parameter_value dm_agent registerIncomingSignals {false}
	set_instantiation_interface_parameter_value dm_agent registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value dm_agent setupTime {0}
	set_instantiation_interface_parameter_value dm_agent timingUnits {Cycles}
	set_instantiation_interface_parameter_value dm_agent transparentBridge {false}
	set_instantiation_interface_parameter_value dm_agent waitrequestAllowance {0}
	set_instantiation_interface_parameter_value dm_agent waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value dm_agent wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value dm_agent writeLatency {0}
	set_instantiation_interface_parameter_value dm_agent writeWaitStates {0}
	set_instantiation_interface_parameter_value dm_agent writeWaitTime {0}
	set_instantiation_interface_assignment_value dm_agent embeddedsw.configuration.hideDevice {1}
	set_instantiation_interface_assignment_value dm_agent embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value dm_agent embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value dm_agent embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value dm_agent embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_assignment_value dm_agent qsys.ui.connect {instruction_manager,data_manager}
	set_instantiation_interface_sysinfo_parameter_value dm_agent address_map {<address-map><slave name='dm_agent' start='0x0' end='0x10000' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value dm_agent address_width {16}
	set_instantiation_interface_sysinfo_parameter_value dm_agent max_slave_data_width {32}
	add_instantiation_interface_port dm_agent dm_agent_address address 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port dm_agent dm_agent_read read 1 STD_LOGIC Input
	add_instantiation_interface_port dm_agent dm_agent_readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port dm_agent dm_agent_write write 1 STD_LOGIC Input
	add_instantiation_interface_port dm_agent dm_agent_writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port dm_agent dm_agent_waitrequest waitrequest 1 STD_LOGIC Output
	add_instantiation_interface_port dm_agent dm_agent_readdatavalid readdatavalid 1 STD_LOGIC Output
	save_instantiation
	add_component phy_reg_set ip/controller/controller_phy_reg_set_0.ip phy_reg_set phy_reg_set_0
	load_component phy_reg_set
	set_component_parameter_value NAVMM_PER_PHY {4}
	set_component_parameter_value NPHYS {2}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation phy_reg_set
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.BITRATE_0_OFFSET {268435488}
	set_instantiation_assignment_value embeddedsw.CMacro.BITRATE_1_OFFSET {268435568}
	set_instantiation_assignment_value embeddedsw.CMacro.CONTROL2_REG_0_OFFSET {268435472}
	set_instantiation_assignment_value embeddedsw.CMacro.CONTROL2_REG_1_OFFSET {268435552}
	set_instantiation_assignment_value embeddedsw.CMacro.CONTROL_REG_0_OFFSET {268435456}
	set_instantiation_assignment_value embeddedsw.CMacro.CONTROL_REG_1_OFFSET {268435536}
	set_instantiation_assignment_value embeddedsw.CMacro.COUNTER_1MS_REG_0_OFFSET {268435520}
	set_instantiation_assignment_value embeddedsw.CMacro.COUNTER_1MS_REG_1_OFFSET {268435600}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_PDP_0_OFFSET {67108864}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_PDP_1_OFFSET {83886080}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_PDP_2_OFFSET {100663296}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_PDP_3_OFFSET {117440512}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_PDP_4_OFFSET {201326592}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_PDP_5_OFFSET {218103808}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_PDP_6_OFFSET {234881024}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_PDP_7_OFFSET {251658240}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_XCVR_0_OFFSET {0}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_XCVR_1_OFFSET {16777216}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_XCVR_2_OFFSET {33554432}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_XCVR_3_OFFSET {50331648}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_XCVR_4_OFFSET {134217728}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_XCVR_5_OFFSET {150994944}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_XCVR_6_OFFSET {167772160}
	set_instantiation_assignment_value embeddedsw.CMacro.RECONFIG_XCVR_7_OFFSET {184549376}
	set_instantiation_assignment_value embeddedsw.CMacro.RXCLOCK_0_OFFSET {268435504}
	set_instantiation_assignment_value embeddedsw.CMacro.RXCLOCK_1_OFFSET {268435584}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk_clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {BOTH}
	add_instantiation_interface_port reset reset_reset reset 1 STD_LOGIC Input
	add_instantiation_interface s0 avalon INPUT
	set_instantiation_interface_parameter_value s0 addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value s0 addressGroup {0}
	set_instantiation_interface_parameter_value s0 addressSpan {536870912}
	set_instantiation_interface_parameter_value s0 addressUnits {WORDS}
	set_instantiation_interface_parameter_value s0 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s0 associatedClock {clk}
	set_instantiation_interface_parameter_value s0 associatedReset {reset}
	set_instantiation_interface_parameter_value s0 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s0 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s0 bridgesToMaster {}
	set_instantiation_interface_parameter_value s0 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s0 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s0 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s0 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s0 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureType {3}
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
	set_instantiation_interface_parameter_value s0 maximumPendingReadTransactions {1}
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
	set_instantiation_interface_parameter_value s0 waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value s0 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s0 writeLatency {0}
	set_instantiation_interface_parameter_value s0 writeWaitStates {0}
	set_instantiation_interface_parameter_value s0 writeWaitTime {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value s0 address_map {<address-map><slave name='s0' start='0x0' end='0x20000000' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s0 address_width {29}
	set_instantiation_interface_sysinfo_parameter_value s0 max_slave_data_width {32}
	add_instantiation_interface_port s0 s0_waitrequest waitrequest 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_readdatavalid readdatavalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_burstcount burstcount 1 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_address address 27 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_write write 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_read read 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_byteenable byteenable 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_debugaccess debugaccess 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_0 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_0 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_0 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_0 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_0 qsys.ui.export_name {reconfig_xcvr_0_s0}
	add_instantiation_interface_port reconfig_xcvr_0 reconfig_xcvr_0_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_0 reconfig_xcvr_0_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_0 reconfig_xcvr_0_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_0 reconfig_xcvr_0_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_xcvr_0 reconfig_xcvr_0_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_0 reconfig_xcvr_0_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_0 reconfig_xcvr_0_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_reset_0 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_0 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_0 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_0 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_reset_0 qsys.ui.export_name {reconfig_xcvr_0_reset}
	add_instantiation_interface_port reconfig_xcvr_reset_0 reconfig_xcvr_reset_0_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_pdp_0 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_0 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_0 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_0 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_0 qsys.ui.export_name {reconfig_pdp_0_s0}
	add_instantiation_interface_port reconfig_pdp_0 reconfig_pdp_0_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_0 reconfig_pdp_0_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_0 reconfig_pdp_0_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_0 reconfig_pdp_0_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_pdp_0 reconfig_pdp_0_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_0 reconfig_pdp_0_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_0 reconfig_pdp_0_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_pdp_reset_0 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_reset_0 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_0 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_0 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_reset_0 qsys.ui.export_name {reconfig_pdp_0_reset}
	add_instantiation_interface_port reconfig_pdp_reset_0 reconfig_pdp_reset_0_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_xcvr_1 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_1 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_1 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_1 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_1 qsys.ui.export_name {reconfig_xcvr_1_s0}
	add_instantiation_interface_port reconfig_xcvr_1 reconfig_xcvr_1_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_1 reconfig_xcvr_1_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_1 reconfig_xcvr_1_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_1 reconfig_xcvr_1_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_xcvr_1 reconfig_xcvr_1_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_1 reconfig_xcvr_1_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_1 reconfig_xcvr_1_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_reset_1 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_1 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_1 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_1 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_reset_1 qsys.ui.export_name {reconfig_xcvr_1_reset}
	add_instantiation_interface_port reconfig_xcvr_reset_1 reconfig_xcvr_reset_1_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_pdp_1 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_1 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_1 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_1 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_1 qsys.ui.export_name {reconfig_pdp_1_s0}
	add_instantiation_interface_port reconfig_pdp_1 reconfig_pdp_1_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_1 reconfig_pdp_1_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_1 reconfig_pdp_1_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_1 reconfig_pdp_1_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_pdp_1 reconfig_pdp_1_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_1 reconfig_pdp_1_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_1 reconfig_pdp_1_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_pdp_reset_1 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_reset_1 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_1 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_1 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_reset_1 qsys.ui.export_name {reconfig_pdp_1_reset}
	add_instantiation_interface_port reconfig_pdp_reset_1 reconfig_pdp_reset_1_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_xcvr_2 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_2 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_2 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_2 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_2 qsys.ui.export_name {reconfig_xcvr_2_s0}
	add_instantiation_interface_port reconfig_xcvr_2 reconfig_xcvr_2_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_2 reconfig_xcvr_2_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_2 reconfig_xcvr_2_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_2 reconfig_xcvr_2_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_xcvr_2 reconfig_xcvr_2_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_2 reconfig_xcvr_2_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_2 reconfig_xcvr_2_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_reset_2 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_2 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_2 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_2 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_reset_2 qsys.ui.export_name {reconfig_xcvr_2_reset}
	add_instantiation_interface_port reconfig_xcvr_reset_2 reconfig_xcvr_reset_2_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_pdp_2 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_2 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_2 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_2 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_2 qsys.ui.export_name {reconfig_pdp_2_s0}
	add_instantiation_interface_port reconfig_pdp_2 reconfig_pdp_2_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_2 reconfig_pdp_2_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_2 reconfig_pdp_2_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_2 reconfig_pdp_2_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_pdp_2 reconfig_pdp_2_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_2 reconfig_pdp_2_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_2 reconfig_pdp_2_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_pdp_reset_2 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_reset_2 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_2 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_2 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_reset_2 qsys.ui.export_name {reconfig_pdp_2_reset}
	add_instantiation_interface_port reconfig_pdp_reset_2 reconfig_pdp_reset_2_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_xcvr_3 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_3 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_3 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_3 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_3 qsys.ui.export_name {reconfig_xcvr_3_s0}
	add_instantiation_interface_port reconfig_xcvr_3 reconfig_xcvr_3_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_3 reconfig_xcvr_3_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_3 reconfig_xcvr_3_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_3 reconfig_xcvr_3_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_xcvr_3 reconfig_xcvr_3_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_3 reconfig_xcvr_3_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_3 reconfig_xcvr_3_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_reset_3 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_3 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_3 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_3 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_reset_3 qsys.ui.export_name {reconfig_xcvr_3_reset}
	add_instantiation_interface_port reconfig_xcvr_reset_3 reconfig_xcvr_reset_3_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_pdp_3 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_3 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_3 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_3 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_3 qsys.ui.export_name {reconfig_pdp_3_s0}
	add_instantiation_interface_port reconfig_pdp_3 reconfig_pdp_3_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_3 reconfig_pdp_3_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_3 reconfig_pdp_3_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_3 reconfig_pdp_3_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_pdp_3 reconfig_pdp_3_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_3 reconfig_pdp_3_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_3 reconfig_pdp_3_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_pdp_reset_3 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_reset_3 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_3 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_3 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_reset_3 qsys.ui.export_name {reconfig_pdp_3_reset}
	add_instantiation_interface_port reconfig_pdp_reset_3 reconfig_pdp_reset_3_reset reset 1 STD_LOGIC Output
	add_instantiation_interface control_reg_0 conduit INPUT
	set_instantiation_interface_parameter_value control_reg_0 associatedClock {}
	set_instantiation_interface_parameter_value control_reg_0 associatedReset {}
	set_instantiation_interface_parameter_value control_reg_0 prSafe {false}
	add_instantiation_interface_port control_reg_0 control_reg_0_export export 16 STD_LOGIC_VECTOR Output
	add_instantiation_interface control2_reg_0 conduit INPUT
	set_instantiation_interface_parameter_value control2_reg_0 associatedClock {}
	set_instantiation_interface_parameter_value control2_reg_0 associatedReset {}
	set_instantiation_interface_parameter_value control2_reg_0 prSafe {false}
	add_instantiation_interface_port control2_reg_0 control2_reg_0_export export 16 STD_LOGIC_VECTOR Output
	add_instantiation_interface bitrate_0 conduit INPUT
	set_instantiation_interface_parameter_value bitrate_0 associatedClock {}
	set_instantiation_interface_parameter_value bitrate_0 associatedReset {}
	set_instantiation_interface_parameter_value bitrate_0 prSafe {false}
	add_instantiation_interface_port bitrate_0 bitrate_0_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface rxclock_0 conduit INPUT
	set_instantiation_interface_parameter_value rxclock_0 associatedClock {}
	set_instantiation_interface_parameter_value rxclock_0 associatedReset {}
	set_instantiation_interface_parameter_value rxclock_0 prSafe {false}
	add_instantiation_interface_port rxclock_0 rxclock_0_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface counter_1ms_reg_0 conduit INPUT
	set_instantiation_interface_parameter_value counter_1ms_reg_0 associatedClock {}
	set_instantiation_interface_parameter_value counter_1ms_reg_0 associatedReset {}
	set_instantiation_interface_parameter_value counter_1ms_reg_0 prSafe {false}
	add_instantiation_interface_port counter_1ms_reg_0 counter_1ms_reg_0_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface reconfig_xcvr_4 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_4 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_4 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_4 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_4 qsys.ui.export_name {reconfig_xcvr_4_s0}
	add_instantiation_interface_port reconfig_xcvr_4 reconfig_xcvr_4_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_4 reconfig_xcvr_4_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_4 reconfig_xcvr_4_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_4 reconfig_xcvr_4_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_xcvr_4 reconfig_xcvr_4_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_4 reconfig_xcvr_4_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_4 reconfig_xcvr_4_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_reset_4 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_4 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_4 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_4 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_reset_4 qsys.ui.export_name {reconfig_xcvr_4_reset}
	add_instantiation_interface_port reconfig_xcvr_reset_4 reconfig_xcvr_reset_4_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_pdp_4 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_4 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_4 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_4 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_4 qsys.ui.export_name {reconfig_pdp_4_s0}
	add_instantiation_interface_port reconfig_pdp_4 reconfig_pdp_4_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_4 reconfig_pdp_4_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_4 reconfig_pdp_4_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_4 reconfig_pdp_4_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_pdp_4 reconfig_pdp_4_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_4 reconfig_pdp_4_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_4 reconfig_pdp_4_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_pdp_reset_4 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_reset_4 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_4 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_4 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_reset_4 qsys.ui.export_name {reconfig_pdp_4_reset}
	add_instantiation_interface_port reconfig_pdp_reset_4 reconfig_pdp_reset_4_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_xcvr_5 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_5 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_5 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_5 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_5 qsys.ui.export_name {reconfig_xcvr_5_s0}
	add_instantiation_interface_port reconfig_xcvr_5 reconfig_xcvr_5_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_5 reconfig_xcvr_5_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_5 reconfig_xcvr_5_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_5 reconfig_xcvr_5_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_xcvr_5 reconfig_xcvr_5_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_5 reconfig_xcvr_5_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_5 reconfig_xcvr_5_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_reset_5 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_5 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_5 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_5 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_reset_5 qsys.ui.export_name {reconfig_xcvr_5_reset}
	add_instantiation_interface_port reconfig_xcvr_reset_5 reconfig_xcvr_reset_5_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_pdp_5 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_5 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_5 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_5 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_5 qsys.ui.export_name {reconfig_pdp_5_s0}
	add_instantiation_interface_port reconfig_pdp_5 reconfig_pdp_5_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_5 reconfig_pdp_5_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_5 reconfig_pdp_5_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_5 reconfig_pdp_5_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_pdp_5 reconfig_pdp_5_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_5 reconfig_pdp_5_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_5 reconfig_pdp_5_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_pdp_reset_5 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_reset_5 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_5 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_5 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_reset_5 qsys.ui.export_name {reconfig_pdp_5_reset}
	add_instantiation_interface_port reconfig_pdp_reset_5 reconfig_pdp_reset_5_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_xcvr_6 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_6 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_6 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_6 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_6 qsys.ui.export_name {reconfig_xcvr_6_s0}
	add_instantiation_interface_port reconfig_xcvr_6 reconfig_xcvr_6_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_6 reconfig_xcvr_6_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_6 reconfig_xcvr_6_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_6 reconfig_xcvr_6_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_xcvr_6 reconfig_xcvr_6_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_6 reconfig_xcvr_6_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_6 reconfig_xcvr_6_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_reset_6 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_6 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_6 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_6 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_reset_6 qsys.ui.export_name {reconfig_xcvr_6_reset}
	add_instantiation_interface_port reconfig_xcvr_reset_6 reconfig_xcvr_reset_6_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_pdp_6 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_6 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_6 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_6 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_6 qsys.ui.export_name {reconfig_pdp_6_s0}
	add_instantiation_interface_port reconfig_pdp_6 reconfig_pdp_6_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_6 reconfig_pdp_6_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_6 reconfig_pdp_6_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_6 reconfig_pdp_6_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_pdp_6 reconfig_pdp_6_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_6 reconfig_pdp_6_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_6 reconfig_pdp_6_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_pdp_reset_6 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_reset_6 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_6 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_6 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_reset_6 qsys.ui.export_name {reconfig_pdp_6_reset}
	add_instantiation_interface_port reconfig_pdp_reset_6 reconfig_pdp_reset_6_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_xcvr_7 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_7 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_7 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_7 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_7 qsys.ui.export_name {reconfig_xcvr_7_s0}
	add_instantiation_interface_port reconfig_xcvr_7 reconfig_xcvr_7_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_7 reconfig_xcvr_7_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_7 reconfig_xcvr_7_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_7 reconfig_xcvr_7_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_xcvr_7 reconfig_xcvr_7_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_xcvr_7 reconfig_xcvr_7_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_xcvr_7 reconfig_xcvr_7_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_xcvr_reset_7 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_7 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_7 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_xcvr_reset_7 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_xcvr_reset_7 qsys.ui.export_name {reconfig_xcvr_7_reset}
	add_instantiation_interface_port reconfig_xcvr_reset_7 reconfig_xcvr_reset_7_reset reset 1 STD_LOGIC Output
	add_instantiation_interface reconfig_pdp_7 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_7 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_7 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_7 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_7 qsys.ui.export_name {reconfig_pdp_7_s0}
	add_instantiation_interface_port reconfig_pdp_7 reconfig_pdp_7_address address 21 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_7 reconfig_pdp_7_byteenable byteenable 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_7 reconfig_pdp_7_read read 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_7 reconfig_pdp_7_readdata readdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port reconfig_pdp_7 reconfig_pdp_7_write write 1 STD_LOGIC Output
	add_instantiation_interface_port reconfig_pdp_7 reconfig_pdp_7_writedata writedata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port reconfig_pdp_7 reconfig_pdp_7_waitrequest waitrequest 1 STD_LOGIC Input
	add_instantiation_interface reconfig_pdp_reset_7 conduit INPUT
	set_instantiation_interface_parameter_value reconfig_pdp_reset_7 associatedClock {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_7 associatedReset {}
	set_instantiation_interface_parameter_value reconfig_pdp_reset_7 prSafe {false}
	set_instantiation_interface_assignment_value reconfig_pdp_reset_7 qsys.ui.export_name {reconfig_pdp_7_reset}
	add_instantiation_interface_port reconfig_pdp_reset_7 reconfig_pdp_reset_7_reset reset 1 STD_LOGIC Output
	add_instantiation_interface control_reg_1 conduit INPUT
	set_instantiation_interface_parameter_value control_reg_1 associatedClock {}
	set_instantiation_interface_parameter_value control_reg_1 associatedReset {}
	set_instantiation_interface_parameter_value control_reg_1 prSafe {false}
	add_instantiation_interface_port control_reg_1 control_reg_1_export export 16 STD_LOGIC_VECTOR Output
	add_instantiation_interface control2_reg_1 conduit INPUT
	set_instantiation_interface_parameter_value control2_reg_1 associatedClock {}
	set_instantiation_interface_parameter_value control2_reg_1 associatedReset {}
	set_instantiation_interface_parameter_value control2_reg_1 prSafe {false}
	add_instantiation_interface_port control2_reg_1 control2_reg_1_export export 16 STD_LOGIC_VECTOR Output
	add_instantiation_interface bitrate_1 conduit INPUT
	set_instantiation_interface_parameter_value bitrate_1 associatedClock {}
	set_instantiation_interface_parameter_value bitrate_1 associatedReset {}
	set_instantiation_interface_parameter_value bitrate_1 prSafe {false}
	add_instantiation_interface_port bitrate_1 bitrate_1_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface rxclock_1 conduit INPUT
	set_instantiation_interface_parameter_value rxclock_1 associatedClock {}
	set_instantiation_interface_parameter_value rxclock_1 associatedReset {}
	set_instantiation_interface_parameter_value rxclock_1 prSafe {false}
	add_instantiation_interface_port rxclock_1 rxclock_1_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface counter_1ms_reg_1 conduit INPUT
	set_instantiation_interface_parameter_value counter_1ms_reg_1 associatedClock {}
	set_instantiation_interface_parameter_value counter_1ms_reg_1 associatedReset {}
	set_instantiation_interface_parameter_value counter_1ms_reg_1 prSafe {false}
	add_instantiation_interface_port counter_1ms_reg_1 counter_1ms_reg_1_export export 32 STD_LOGIC_VECTOR Input
	save_instantiation
	add_component prg_ram ip/controller/controller_intel_onchip_memory_0.ip intel_onchip_memory intel_onchip_memory_0
	load_component prg_ram
	set_component_parameter_value AXI_interface {1}
	set_component_parameter_value allowInSystemMemoryContentEditor {0}
	set_component_parameter_value blockType {AUTO}
	set_component_parameter_value clockEnable {0}
	set_component_parameter_value copyInitFile {0}
	set_component_parameter_value dataWidth {32}
	set_component_parameter_value dataWidth2 {32}
	set_component_parameter_value dualPort {0}
	set_component_parameter_value ecc_check {0}
	set_component_parameter_value ecc_encoder_bypass {0}
	set_component_parameter_value ecc_pipeline_reg {0}
	set_component_parameter_value enPRInitMode {0}
	set_component_parameter_value enableDiffWidth {0}
	set_component_parameter_value gui_debugaccess {0}
	set_component_parameter_value idWidth {2}
	set_component_parameter_value initMemContent {1}
	set_component_parameter_value initializationFileName {onchip_mem.hex}
	set_component_parameter_value instanceID {NONE}
	set_component_parameter_value interfaceType {1}
	set_component_parameter_value lvl1OutputRegA {0}
	set_component_parameter_value lvl1OutputRegB {0}
	set_component_parameter_value lvl2OutputRegA {0}
	set_component_parameter_value lvl2OutputRegB {0}
	set_component_parameter_value memorySize {4194304.0}
	set_component_parameter_value poison_enable {0}
	set_component_parameter_value readDuringWriteMode_Mixed {DONT_CARE}
	set_component_parameter_value resetrequest_enabled {1}
	set_component_parameter_value singleClockOperation {0}
	set_component_parameter_value tightly_coupled_ecc {0}
	set_component_parameter_value useNonDefaultInitFile {0}
	set_component_parameter_value writable {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation prg_ram
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR {0}
	set_instantiation_assignment_value embeddedsw.CMacro.CONTENTS_INFO {""}
	set_instantiation_assignment_value embeddedsw.CMacro.DUAL_PORT {0}
	set_instantiation_assignment_value embeddedsw.CMacro.GUI_RAM_BLOCK_TYPE {AUTO}
	set_instantiation_assignment_value embeddedsw.CMacro.INIT_CONTENTS_FILE {controller_intel_onchip_memory_0_intel_onchip_memory_0}
	set_instantiation_assignment_value embeddedsw.CMacro.INIT_MEM_CONTENT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.INSTANCE_ID {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.NON_DEFAULT_INIT_FILE_ENABLED {0}
	set_instantiation_assignment_value embeddedsw.CMacro.RAM_BLOCK_TYPE {AUTO}
	set_instantiation_assignment_value embeddedsw.CMacro.READ_DURING_WRITE_MODE {DONT_CARE}
	set_instantiation_assignment_value embeddedsw.CMacro.SINGLE_CLOCK_OP {0}
	set_instantiation_assignment_value embeddedsw.CMacro.SIZE_MULTIPLE {1}
	set_instantiation_assignment_value embeddedsw.CMacro.SIZE_VALUE {4194304}
	set_instantiation_assignment_value embeddedsw.CMacro.WRITABLE {1}
	set_instantiation_assignment_value embeddedsw.memoryInfo.DAT_SYM_INSTALL_DIR {SIM_DIR}
	set_instantiation_assignment_value embeddedsw.memoryInfo.GENERATE_DAT_SYM {1}
	set_instantiation_assignment_value embeddedsw.memoryInfo.GENERATE_HEX {1}
	set_instantiation_assignment_value embeddedsw.memoryInfo.HAS_BYTE_LANE {0}
	set_instantiation_assignment_value embeddedsw.memoryInfo.HEX_INSTALL_DIR {QPF_DIR}
	set_instantiation_assignment_value embeddedsw.memoryInfo.MEM_INIT_DATA_WIDTH {32}
	set_instantiation_assignment_value embeddedsw.memoryInfo.MEM_INIT_FILENAME {controller_intel_onchip_memory_0_intel_onchip_memory_0}
	set_instantiation_assignment_value postgeneration.simulation.init_file.param_name {INIT_FILE}
	set_instantiation_assignment_value postgeneration.simulation.init_file.type {MEM_INIT}
	add_instantiation_interface clk1 clock INPUT
	set_instantiation_interface_parameter_value clk1 clockRate {0}
	set_instantiation_interface_parameter_value clk1 externallyDriven {false}
	set_instantiation_interface_parameter_value clk1 ptfSchematicName {}
	add_instantiation_interface_port clk1 clk clk 1 STD_LOGIC Input
	add_instantiation_interface axi_s1 axi4 INPUT
	set_instantiation_interface_parameter_value axi_s1 associatedClock {clk1}
	set_instantiation_interface_parameter_value axi_s1 associatedReset {reset1}
	set_instantiation_interface_parameter_value axi_s1 bridgesToMaster {}
	set_instantiation_interface_parameter_value axi_s1 combinedAcceptanceCapability {1}
	set_instantiation_interface_parameter_value axi_s1 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value axi_s1 dfhFeatureId {35}
	set_instantiation_interface_parameter_value axi_s1 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value axi_s1 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value axi_s1 dfhFeatureType {3}
	set_instantiation_interface_parameter_value axi_s1 dfhGroupId {0}
	set_instantiation_interface_parameter_value axi_s1 dfhParameterData {}
	set_instantiation_interface_parameter_value axi_s1 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value axi_s1 dfhParameterId {}
	set_instantiation_interface_parameter_value axi_s1 dfhParameterName {}
	set_instantiation_interface_parameter_value axi_s1 dfhParameterVersion {}
	set_instantiation_interface_parameter_value axi_s1 maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value axi_s1 maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value axi_s1 maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value axi_s1 poison {false}
	set_instantiation_interface_parameter_value axi_s1 readAcceptanceCapability {1}
	set_instantiation_interface_parameter_value axi_s1 readDataReorderingDepth {1}
	set_instantiation_interface_parameter_value axi_s1 traceSignals {false}
	set_instantiation_interface_parameter_value axi_s1 trustzoneAware {true}
	set_instantiation_interface_parameter_value axi_s1 uniqueIdSupport {false}
	set_instantiation_interface_parameter_value axi_s1 wakeupSignals {false}
	set_instantiation_interface_parameter_value axi_s1 writeAcceptanceCapability {1}
	set_instantiation_interface_assignment_value axi_s1 embeddedsw.configuration.isMemoryDevice {1}
	set_instantiation_interface_sysinfo_parameter_value axi_s1 address_map {<address-map><slave name='axi_s1' start='0x0' end='0x400000' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value axi_s1 address_width {22}
	set_instantiation_interface_sysinfo_parameter_value axi_s1 max_slave_data_width {32}
	add_instantiation_interface_port axi_s1 s1_arid arid 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_araddr araddr 22 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_arlen arlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_arsize arsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_arburst arburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_arready arready 1 STD_LOGIC Output
	add_instantiation_interface_port axi_s1 s1_arvalid arvalid 1 STD_LOGIC Input
	add_instantiation_interface_port axi_s1 s1_awid awid 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_awaddr awaddr 22 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_awlen awlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_awsize awsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_awburst awburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_awready awready 1 STD_LOGIC Output
	add_instantiation_interface_port axi_s1 s1_awvalid awvalid 1 STD_LOGIC Input
	add_instantiation_interface_port axi_s1 s1_rid rid 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port axi_s1 s1_rdata rdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port axi_s1 s1_rlast rlast 1 STD_LOGIC Output
	add_instantiation_interface_port axi_s1 s1_rready rready 1 STD_LOGIC Input
	add_instantiation_interface_port axi_s1 s1_rvalid rvalid 1 STD_LOGIC Output
	add_instantiation_interface_port axi_s1 s1_rresp rresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port axi_s1 s1_wdata wdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_wstrb wstrb 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_wlast wlast 1 STD_LOGIC Input
	add_instantiation_interface_port axi_s1 s1_wready wready 1 STD_LOGIC Output
	add_instantiation_interface_port axi_s1 s1_wvalid wvalid 1 STD_LOGIC Input
	add_instantiation_interface_port axi_s1 s1_bid bid 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port axi_s1 s1_bresp bresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port axi_s1 s1_bready bready 1 STD_LOGIC Input
	add_instantiation_interface_port axi_s1 s1_bvalid bvalid 1 STD_LOGIC Output
	add_instantiation_interface reset1 reset INPUT
	set_instantiation_interface_parameter_value reset1 associatedClock {clk1}
	set_instantiation_interface_parameter_value reset1 synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset1 reset reset 1 STD_LOGIC Input
	add_instantiation_interface_port reset1 reset_req reset_req 1 STD_LOGIC Input
	save_instantiation
	add_component reg_set ip/controller/controller_channel_reg_set_0.ip channel_reg_set controller_channel_reg_set_0
	load_component reg_set
	set_component_parameter_value NCHAN {8}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation reg_set
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.CHANNEL_0_OFFSET {0}
	set_instantiation_assignment_value embeddedsw.CMacro.CHANNEL_1_OFFSET {64}
	set_instantiation_assignment_value embeddedsw.CMacro.CHANNEL_2_OFFSET {128}
	set_instantiation_assignment_value embeddedsw.CMacro.CHANNEL_3_OFFSET {192}
	set_instantiation_assignment_value embeddedsw.CMacro.CHANNEL_4_OFFSET {256}
	set_instantiation_assignment_value embeddedsw.CMacro.CHANNEL_5_OFFSET {320}
	set_instantiation_assignment_value embeddedsw.CMacro.CHANNEL_6_OFFSET {384}
	set_instantiation_assignment_value embeddedsw.CMacro.CHANNEL_7_OFFSET {448}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_H_0_OFFSET {16}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_H_1_OFFSET {80}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_H_2_OFFSET {144}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_H_3_OFFSET {208}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_H_4_OFFSET {272}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_H_5_OFFSET {336}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_H_6_OFFSET {400}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_H_7_OFFSET {464}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_L_0_OFFSET {32}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_L_1_OFFSET {96}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_L_2_OFFSET {160}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_L_3_OFFSET {224}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_L_4_OFFSET {288}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_L_5_OFFSET {352}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_L_6_OFFSET {416}
	set_instantiation_assignment_value embeddedsw.CMacro.ERROR_COUNT_L_7_OFFSET {480}
	set_instantiation_assignment_value embeddedsw.CMacro.PRBSLOCK_ALARM_COUNT_0_OFFSET {48}
	set_instantiation_assignment_value embeddedsw.CMacro.PRBSLOCK_ALARM_COUNT_1_OFFSET {112}
	set_instantiation_assignment_value embeddedsw.CMacro.PRBSLOCK_ALARM_COUNT_2_OFFSET {176}
	set_instantiation_assignment_value embeddedsw.CMacro.PRBSLOCK_ALARM_COUNT_3_OFFSET {240}
	set_instantiation_assignment_value embeddedsw.CMacro.PRBSLOCK_ALARM_COUNT_4_OFFSET {304}
	set_instantiation_assignment_value embeddedsw.CMacro.PRBSLOCK_ALARM_COUNT_5_OFFSET {368}
	set_instantiation_assignment_value embeddedsw.CMacro.PRBSLOCK_ALARM_COUNT_6_OFFSET {432}
	set_instantiation_assignment_value embeddedsw.CMacro.PRBSLOCK_ALARM_COUNT_7_OFFSET {496}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk_clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {BOTH}
	add_instantiation_interface_port reset reset_reset reset 1 STD_LOGIC Input
	add_instantiation_interface s0 avalon INPUT
	set_instantiation_interface_parameter_value s0 addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value s0 addressGroup {0}
	set_instantiation_interface_parameter_value s0 addressSpan {512}
	set_instantiation_interface_parameter_value s0 addressUnits {WORDS}
	set_instantiation_interface_parameter_value s0 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s0 associatedClock {clk}
	set_instantiation_interface_parameter_value s0 associatedReset {reset}
	set_instantiation_interface_parameter_value s0 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s0 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s0 bridgesToMaster {}
	set_instantiation_interface_parameter_value s0 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s0 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s0 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s0 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s0 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureType {3}
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
	set_instantiation_interface_parameter_value s0 maximumPendingReadTransactions {1}
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
	set_instantiation_interface_parameter_value s0 waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value s0 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s0 writeLatency {0}
	set_instantiation_interface_parameter_value s0 writeWaitStates {0}
	set_instantiation_interface_parameter_value s0 writeWaitTime {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s0 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value s0 address_map {<address-map><slave name='s0' start='0x0' end='0x200' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s0 address_width {9}
	set_instantiation_interface_sysinfo_parameter_value s0 max_slave_data_width {32}
	add_instantiation_interface_port s0 s0_waitrequest waitrequest 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_readdatavalid readdatavalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_burstcount burstcount 1 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_address address 7 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_write write 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_read read 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_byteenable byteenable 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_debugaccess debugaccess 1 STD_LOGIC Input
	add_instantiation_interface channel_0 conduit INPUT
	set_instantiation_interface_parameter_value channel_0 associatedClock {}
	set_instantiation_interface_parameter_value channel_0 associatedReset {}
	set_instantiation_interface_parameter_value channel_0 prSafe {false}
	add_instantiation_interface_port channel_0 channel_0_export export 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_h_0 conduit INPUT
	set_instantiation_interface_parameter_value error_count_h_0 associatedClock {}
	set_instantiation_interface_parameter_value error_count_h_0 associatedReset {}
	set_instantiation_interface_parameter_value error_count_h_0 prSafe {false}
	add_instantiation_interface_port error_count_h_0 error_count_h_0_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_l_0 conduit INPUT
	set_instantiation_interface_parameter_value error_count_l_0 associatedClock {}
	set_instantiation_interface_parameter_value error_count_l_0 associatedReset {}
	set_instantiation_interface_parameter_value error_count_l_0 prSafe {false}
	add_instantiation_interface_port error_count_l_0 error_count_l_0_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface prbslock_alarm_count_0 conduit INPUT
	set_instantiation_interface_parameter_value prbslock_alarm_count_0 associatedClock {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_0 associatedReset {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_0 prSafe {false}
	add_instantiation_interface_port prbslock_alarm_count_0 prbslock_alarm_count_0_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface channel_1 conduit INPUT
	set_instantiation_interface_parameter_value channel_1 associatedClock {}
	set_instantiation_interface_parameter_value channel_1 associatedReset {}
	set_instantiation_interface_parameter_value channel_1 prSafe {false}
	add_instantiation_interface_port channel_1 channel_1_export export 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_h_1 conduit INPUT
	set_instantiation_interface_parameter_value error_count_h_1 associatedClock {}
	set_instantiation_interface_parameter_value error_count_h_1 associatedReset {}
	set_instantiation_interface_parameter_value error_count_h_1 prSafe {false}
	add_instantiation_interface_port error_count_h_1 error_count_h_1_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_l_1 conduit INPUT
	set_instantiation_interface_parameter_value error_count_l_1 associatedClock {}
	set_instantiation_interface_parameter_value error_count_l_1 associatedReset {}
	set_instantiation_interface_parameter_value error_count_l_1 prSafe {false}
	add_instantiation_interface_port error_count_l_1 error_count_l_1_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface prbslock_alarm_count_1 conduit INPUT
	set_instantiation_interface_parameter_value prbslock_alarm_count_1 associatedClock {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_1 associatedReset {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_1 prSafe {false}
	add_instantiation_interface_port prbslock_alarm_count_1 prbslock_alarm_count_1_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface channel_2 conduit INPUT
	set_instantiation_interface_parameter_value channel_2 associatedClock {}
	set_instantiation_interface_parameter_value channel_2 associatedReset {}
	set_instantiation_interface_parameter_value channel_2 prSafe {false}
	add_instantiation_interface_port channel_2 channel_2_export export 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_h_2 conduit INPUT
	set_instantiation_interface_parameter_value error_count_h_2 associatedClock {}
	set_instantiation_interface_parameter_value error_count_h_2 associatedReset {}
	set_instantiation_interface_parameter_value error_count_h_2 prSafe {false}
	add_instantiation_interface_port error_count_h_2 error_count_h_2_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_l_2 conduit INPUT
	set_instantiation_interface_parameter_value error_count_l_2 associatedClock {}
	set_instantiation_interface_parameter_value error_count_l_2 associatedReset {}
	set_instantiation_interface_parameter_value error_count_l_2 prSafe {false}
	add_instantiation_interface_port error_count_l_2 error_count_l_2_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface prbslock_alarm_count_2 conduit INPUT
	set_instantiation_interface_parameter_value prbslock_alarm_count_2 associatedClock {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_2 associatedReset {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_2 prSafe {false}
	add_instantiation_interface_port prbslock_alarm_count_2 prbslock_alarm_count_2_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface channel_3 conduit INPUT
	set_instantiation_interface_parameter_value channel_3 associatedClock {}
	set_instantiation_interface_parameter_value channel_3 associatedReset {}
	set_instantiation_interface_parameter_value channel_3 prSafe {false}
	add_instantiation_interface_port channel_3 channel_3_export export 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_h_3 conduit INPUT
	set_instantiation_interface_parameter_value error_count_h_3 associatedClock {}
	set_instantiation_interface_parameter_value error_count_h_3 associatedReset {}
	set_instantiation_interface_parameter_value error_count_h_3 prSafe {false}
	add_instantiation_interface_port error_count_h_3 error_count_h_3_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_l_3 conduit INPUT
	set_instantiation_interface_parameter_value error_count_l_3 associatedClock {}
	set_instantiation_interface_parameter_value error_count_l_3 associatedReset {}
	set_instantiation_interface_parameter_value error_count_l_3 prSafe {false}
	add_instantiation_interface_port error_count_l_3 error_count_l_3_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface prbslock_alarm_count_3 conduit INPUT
	set_instantiation_interface_parameter_value prbslock_alarm_count_3 associatedClock {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_3 associatedReset {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_3 prSafe {false}
	add_instantiation_interface_port prbslock_alarm_count_3 prbslock_alarm_count_3_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface channel_4 conduit INPUT
	set_instantiation_interface_parameter_value channel_4 associatedClock {}
	set_instantiation_interface_parameter_value channel_4 associatedReset {}
	set_instantiation_interface_parameter_value channel_4 prSafe {false}
	add_instantiation_interface_port channel_4 channel_4_export export 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_h_4 conduit INPUT
	set_instantiation_interface_parameter_value error_count_h_4 associatedClock {}
	set_instantiation_interface_parameter_value error_count_h_4 associatedReset {}
	set_instantiation_interface_parameter_value error_count_h_4 prSafe {false}
	add_instantiation_interface_port error_count_h_4 error_count_h_4_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_l_4 conduit INPUT
	set_instantiation_interface_parameter_value error_count_l_4 associatedClock {}
	set_instantiation_interface_parameter_value error_count_l_4 associatedReset {}
	set_instantiation_interface_parameter_value error_count_l_4 prSafe {false}
	add_instantiation_interface_port error_count_l_4 error_count_l_4_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface prbslock_alarm_count_4 conduit INPUT
	set_instantiation_interface_parameter_value prbslock_alarm_count_4 associatedClock {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_4 associatedReset {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_4 prSafe {false}
	add_instantiation_interface_port prbslock_alarm_count_4 prbslock_alarm_count_4_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface channel_5 conduit INPUT
	set_instantiation_interface_parameter_value channel_5 associatedClock {}
	set_instantiation_interface_parameter_value channel_5 associatedReset {}
	set_instantiation_interface_parameter_value channel_5 prSafe {false}
	add_instantiation_interface_port channel_5 channel_5_export export 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_h_5 conduit INPUT
	set_instantiation_interface_parameter_value error_count_h_5 associatedClock {}
	set_instantiation_interface_parameter_value error_count_h_5 associatedReset {}
	set_instantiation_interface_parameter_value error_count_h_5 prSafe {false}
	add_instantiation_interface_port error_count_h_5 error_count_h_5_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_l_5 conduit INPUT
	set_instantiation_interface_parameter_value error_count_l_5 associatedClock {}
	set_instantiation_interface_parameter_value error_count_l_5 associatedReset {}
	set_instantiation_interface_parameter_value error_count_l_5 prSafe {false}
	add_instantiation_interface_port error_count_l_5 error_count_l_5_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface prbslock_alarm_count_5 conduit INPUT
	set_instantiation_interface_parameter_value prbslock_alarm_count_5 associatedClock {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_5 associatedReset {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_5 prSafe {false}
	add_instantiation_interface_port prbslock_alarm_count_5 prbslock_alarm_count_5_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface channel_6 conduit INPUT
	set_instantiation_interface_parameter_value channel_6 associatedClock {}
	set_instantiation_interface_parameter_value channel_6 associatedReset {}
	set_instantiation_interface_parameter_value channel_6 prSafe {false}
	add_instantiation_interface_port channel_6 channel_6_export export 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_h_6 conduit INPUT
	set_instantiation_interface_parameter_value error_count_h_6 associatedClock {}
	set_instantiation_interface_parameter_value error_count_h_6 associatedReset {}
	set_instantiation_interface_parameter_value error_count_h_6 prSafe {false}
	add_instantiation_interface_port error_count_h_6 error_count_h_6_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_l_6 conduit INPUT
	set_instantiation_interface_parameter_value error_count_l_6 associatedClock {}
	set_instantiation_interface_parameter_value error_count_l_6 associatedReset {}
	set_instantiation_interface_parameter_value error_count_l_6 prSafe {false}
	add_instantiation_interface_port error_count_l_6 error_count_l_6_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface prbslock_alarm_count_6 conduit INPUT
	set_instantiation_interface_parameter_value prbslock_alarm_count_6 associatedClock {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_6 associatedReset {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_6 prSafe {false}
	add_instantiation_interface_port prbslock_alarm_count_6 prbslock_alarm_count_6_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface channel_7 conduit INPUT
	set_instantiation_interface_parameter_value channel_7 associatedClock {}
	set_instantiation_interface_parameter_value channel_7 associatedReset {}
	set_instantiation_interface_parameter_value channel_7 prSafe {false}
	add_instantiation_interface_port channel_7 channel_7_export export 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_h_7 conduit INPUT
	set_instantiation_interface_parameter_value error_count_h_7 associatedClock {}
	set_instantiation_interface_parameter_value error_count_h_7 associatedReset {}
	set_instantiation_interface_parameter_value error_count_h_7 prSafe {false}
	add_instantiation_interface_port error_count_h_7 error_count_h_7_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface error_count_l_7 conduit INPUT
	set_instantiation_interface_parameter_value error_count_l_7 associatedClock {}
	set_instantiation_interface_parameter_value error_count_l_7 associatedReset {}
	set_instantiation_interface_parameter_value error_count_l_7 prSafe {false}
	add_instantiation_interface_port error_count_l_7 error_count_l_7_export export 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface prbslock_alarm_count_7 conduit INPUT
	set_instantiation_interface_parameter_value prbslock_alarm_count_7 associatedClock {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_7 associatedReset {}
	set_instantiation_interface_parameter_value prbslock_alarm_count_7 prSafe {false}
	add_instantiation_interface_port prbslock_alarm_count_7 prbslock_alarm_count_7_export export 32 STD_LOGIC_VECTOR Input
	save_instantiation
	add_component reset_bridge_0 ip/controller/controller_reset_bridge_0.ip altera_reset_bridge reset_bridge_0
	load_component reset_bridge_0
	set_component_parameter_value ACTIVE_LOW_RESET {1}
	set_component_parameter_value NUM_RESET_OUTPUTS {1}
	set_component_parameter_value SYNCHRONOUS_EDGES {deassert}
	set_component_parameter_value SYNC_RESET {1}
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
	set_instantiation_interface_parameter_value in_reset synchronousEdges {BOTH}
	add_instantiation_interface_port in_reset in_reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface out_reset reset OUTPUT
	set_instantiation_interface_parameter_value out_reset associatedClock {clk}
	set_instantiation_interface_parameter_value out_reset associatedDirectReset {in_reset}
	set_instantiation_interface_parameter_value out_reset associatedResetSinks {in_reset}
	set_instantiation_interface_parameter_value out_reset synchronousEdges {BOTH}
	add_instantiation_interface_port out_reset out_reset_n reset_n 1 STD_LOGIC Output
	save_instantiation
	add_component s10_mailbox_client_0 ip/controller/controller_s10_mailbox_client_0.ip altera_s10_mailbox_client s10_mailbox_client_0
	load_component s10_mailbox_client_0
	set_component_parameter_value CMD_FIFO_DEPTH {16}
	set_component_parameter_value CMD_USE_MEMORY_BLOCKS {1}
	set_component_parameter_value CRYPTO_MEMORY_TIMEOUT_VALUE {10000}
	set_component_parameter_value DEBUG {0}
	set_component_parameter_value HAS_OFFLOAD {0}
	set_component_parameter_value HAS_STATUS {1}
	set_component_parameter_value HAS_STREAM {0}
	set_component_parameter_value HAS_URGENT {0}
	set_component_parameter_value RSP_FIFO_DEPTH {16}
	set_component_parameter_value RSP_USE_MEMORY_BLOCKS {1}
	set_component_parameter_value STREAM_WIDTH {32}
	set_component_parameter_value URG_FIFO_DEPTH {4}
	set_component_parameter_value URG_USE_MEMORY_BLOCKS {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation s10_mailbox_client_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface in_clk clock INPUT
	set_instantiation_interface_parameter_value in_clk clockRate {0}
	set_instantiation_interface_parameter_value in_clk externallyDriven {false}
	set_instantiation_interface_parameter_value in_clk ptfSchematicName {}
	add_instantiation_interface_port in_clk in_clk_clk clk 1 STD_LOGIC Input
	add_instantiation_interface in_reset reset INPUT
	set_instantiation_interface_parameter_value in_reset associatedClock {in_clk}
	set_instantiation_interface_parameter_value in_reset synchronousEdges {BOTH}
	add_instantiation_interface_port in_reset in_reset_reset reset 1 STD_LOGIC Input
	add_instantiation_interface avmm avalon INPUT
	set_instantiation_interface_parameter_value avmm addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value avmm addressGroup {0}
	set_instantiation_interface_parameter_value avmm addressSpan {64}
	set_instantiation_interface_parameter_value avmm addressUnits {WORDS}
	set_instantiation_interface_parameter_value avmm alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value avmm associatedClock {in_clk}
	set_instantiation_interface_parameter_value avmm associatedReset {in_reset}
	set_instantiation_interface_parameter_value avmm bitsPerSymbol {8}
	set_instantiation_interface_parameter_value avmm bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value avmm bridgesToMaster {}
	set_instantiation_interface_parameter_value avmm burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value avmm burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value avmm constantBurstBehavior {false}
	set_instantiation_interface_parameter_value avmm dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value avmm dfhFeatureId {35}
	set_instantiation_interface_parameter_value avmm dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value avmm dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value avmm dfhFeatureType {3}
	set_instantiation_interface_parameter_value avmm dfhGroupId {0}
	set_instantiation_interface_parameter_value avmm dfhParameterData {}
	set_instantiation_interface_parameter_value avmm dfhParameterDataLength {}
	set_instantiation_interface_parameter_value avmm dfhParameterId {}
	set_instantiation_interface_parameter_value avmm dfhParameterName {}
	set_instantiation_interface_parameter_value avmm dfhParameterVersion {}
	set_instantiation_interface_parameter_value avmm explicitAddressSpan {0}
	set_instantiation_interface_parameter_value avmm holdTime {0}
	set_instantiation_interface_parameter_value avmm interleaveBursts {false}
	set_instantiation_interface_parameter_value avmm isBigEndian {false}
	set_instantiation_interface_parameter_value avmm isFlash {false}
	set_instantiation_interface_parameter_value avmm isMemoryDevice {false}
	set_instantiation_interface_parameter_value avmm isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value avmm linewrapBursts {false}
	set_instantiation_interface_parameter_value avmm maximumPendingReadTransactions {1}
	set_instantiation_interface_parameter_value avmm maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value avmm minimumReadLatency {1}
	set_instantiation_interface_parameter_value avmm minimumResponseLatency {1}
	set_instantiation_interface_parameter_value avmm minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value avmm prSafe {false}
	set_instantiation_interface_parameter_value avmm printableDevice {false}
	set_instantiation_interface_parameter_value avmm readLatency {0}
	set_instantiation_interface_parameter_value avmm readWaitStates {0}
	set_instantiation_interface_parameter_value avmm readWaitTime {0}
	set_instantiation_interface_parameter_value avmm registerIncomingSignals {false}
	set_instantiation_interface_parameter_value avmm registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value avmm setupTime {0}
	set_instantiation_interface_parameter_value avmm timingUnits {Cycles}
	set_instantiation_interface_parameter_value avmm transparentBridge {false}
	set_instantiation_interface_parameter_value avmm waitrequestAllowance {0}
	set_instantiation_interface_parameter_value avmm waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value avmm wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value avmm writeLatency {0}
	set_instantiation_interface_parameter_value avmm writeWaitStates {0}
	set_instantiation_interface_parameter_value avmm writeWaitTime {0}
	set_instantiation_interface_assignment_value avmm embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value avmm embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value avmm embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value avmm embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value avmm address_map {<address-map><slave name='avmm' start='0x0' end='0x40' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value avmm address_width {6}
	set_instantiation_interface_sysinfo_parameter_value avmm max_slave_data_width {32}
	add_instantiation_interface_port avmm avmm_address address 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port avmm avmm_write write 1 STD_LOGIC Input
	add_instantiation_interface_port avmm avmm_writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port avmm avmm_read read 1 STD_LOGIC Input
	add_instantiation_interface_port avmm avmm_readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port avmm avmm_readdatavalid readdatavalid 1 STD_LOGIC Output
	add_instantiation_interface_port avmm avmm_waitrequest waitrequest 1 STD_LOGIC Output
	add_instantiation_interface irq interrupt INPUT
	set_instantiation_interface_parameter_value irq associatedAddressablePoint {avmm}
	set_instantiation_interface_parameter_value irq associatedClock {in_clk}
	set_instantiation_interface_parameter_value irq associatedReset {in_reset}
	set_instantiation_interface_parameter_value irq bridgedReceiverOffset {0}
	set_instantiation_interface_parameter_value irq bridgesToReceiver {}
	set_instantiation_interface_parameter_value irq irqScheme {NONE}
	add_instantiation_interface_port irq irq_irq irq 1 STD_LOGIC Output
	save_instantiation
	add_component sys_clk_timer ip/controller/controller_sys_clk_timer.ip altera_avalon_timer sys_clk_timer
	load_component sys_clk_timer
	set_component_parameter_value alwaysRun {0}
	set_component_parameter_value counterSize {32}
	set_component_parameter_value fixedPeriod {0}
	set_component_parameter_value period {1}
	set_component_parameter_value periodUnits {MSEC}
	set_component_parameter_value resetOutput {0}
	set_component_parameter_value snapshot {1}
	set_component_parameter_value timeoutPulseOutput {0}
	set_component_parameter_value watchdogPulse {2}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation sys_clk_timer
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.ALWAYS_RUN {0}
	set_instantiation_assignment_value embeddedsw.CMacro.COUNTER_SIZE {32}
	set_instantiation_assignment_value embeddedsw.CMacro.FIXED_PERIOD {0}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {125000000}
	set_instantiation_assignment_value embeddedsw.CMacro.LOAD_VALUE {124999}
	set_instantiation_assignment_value embeddedsw.CMacro.MULT {0.001}
	set_instantiation_assignment_value embeddedsw.CMacro.PERIOD {1}
	set_instantiation_assignment_value embeddedsw.CMacro.PERIOD_UNITS {ms}
	set_instantiation_assignment_value embeddedsw.CMacro.RESET_OUTPUT {0}
	set_instantiation_assignment_value embeddedsw.CMacro.SNAPSHOT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.TICKS_PER_SEC {1000}
	set_instantiation_assignment_value embeddedsw.CMacro.TIMEOUT_PULSE_OUTPUT {0}
	set_instantiation_assignment_value embeddedsw.CMacro.TIMER_DEVICE_TYPE {1}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,timer-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {timer}
	set_instantiation_assignment_value embeddedsw.dts.name {timer}
	set_instantiation_assignment_value embeddedsw.dts.params.clock-frequency {125000000}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface s1 avalon INPUT
	set_instantiation_interface_parameter_value s1 addressAlignment {NATIVE}
	set_instantiation_interface_parameter_value s1 addressGroup {0}
	set_instantiation_interface_parameter_value s1 addressSpan {8}
	set_instantiation_interface_parameter_value s1 addressUnits {WORDS}
	set_instantiation_interface_parameter_value s1 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s1 associatedClock {clk}
	set_instantiation_interface_parameter_value s1 associatedReset {reset}
	set_instantiation_interface_parameter_value s1 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s1 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s1 bridgesToMaster {}
	set_instantiation_interface_parameter_value s1 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s1 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s1 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s1 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s1 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureType {3}
	set_instantiation_interface_parameter_value s1 dfhGroupId {0}
	set_instantiation_interface_parameter_value s1 dfhParameterData {}
	set_instantiation_interface_parameter_value s1 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s1 dfhParameterId {}
	set_instantiation_interface_parameter_value s1 dfhParameterName {}
	set_instantiation_interface_parameter_value s1 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s1 explicitAddressSpan {0}
	set_instantiation_interface_parameter_value s1 holdTime {0}
	set_instantiation_interface_parameter_value s1 interleaveBursts {false}
	set_instantiation_interface_parameter_value s1 isBigEndian {false}
	set_instantiation_interface_parameter_value s1 isFlash {false}
	set_instantiation_interface_parameter_value s1 isMemoryDevice {false}
	set_instantiation_interface_parameter_value s1 isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value s1 linewrapBursts {false}
	set_instantiation_interface_parameter_value s1 maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value s1 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value s1 minimumReadLatency {1}
	set_instantiation_interface_parameter_value s1 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value s1 minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value s1 prSafe {false}
	set_instantiation_interface_parameter_value s1 printableDevice {false}
	set_instantiation_interface_parameter_value s1 readLatency {0}
	set_instantiation_interface_parameter_value s1 readWaitStates {1}
	set_instantiation_interface_parameter_value s1 readWaitTime {1}
	set_instantiation_interface_parameter_value s1 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value s1 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value s1 setupTime {0}
	set_instantiation_interface_parameter_value s1 timingUnits {Cycles}
	set_instantiation_interface_parameter_value s1 transparentBridge {false}
	set_instantiation_interface_parameter_value s1 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value s1 waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value s1 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s1 writeLatency {0}
	set_instantiation_interface_parameter_value s1 writeWaitStates {0}
	set_instantiation_interface_parameter_value s1 writeWaitTime {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isTimerDevice {1}
	set_instantiation_interface_sysinfo_parameter_value s1 address_map {<address-map><slave name='s1' start='0x0' end='0x20' datawidth='16' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s1 address_width {5}
	set_instantiation_interface_sysinfo_parameter_value s1 max_slave_data_width {16}
	add_instantiation_interface_port s1 address address 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 writedata writedata 16 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 readdata readdata 16 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s1 chipselect chipselect 1 STD_LOGIC Input
	add_instantiation_interface_port s1 write_n write_n 1 STD_LOGIC Input
	add_instantiation_interface irq interrupt INPUT
	set_instantiation_interface_parameter_value irq associatedAddressablePoint {s1}
	set_instantiation_interface_parameter_value irq associatedClock {clk}
	set_instantiation_interface_parameter_value irq associatedReset {reset}
	set_instantiation_interface_parameter_value irq bridgedReceiverOffset {0}
	set_instantiation_interface_parameter_value irq bridgesToReceiver {}
	set_instantiation_interface_parameter_value irq irqScheme {NONE}
	add_instantiation_interface_port irq irq irq 1 STD_LOGIC Output
	save_instantiation
	add_component sysid_qsys_0 ip/controller/controller_sysid_qsys_0.ip altera_avalon_sysid_qsys sysid_qsys_0
	load_component sysid_qsys_0
	set_component_parameter_value id {-87110914}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation sysid_qsys_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.ID {-87110914}
	set_instantiation_assignment_value embeddedsw.CMacro.TIMESTAMP {0}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,sysid-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {sysid}
	set_instantiation_assignment_value embeddedsw.dts.name {sysid}
	set_instantiation_assignment_value embeddedsw.dts.params.id {-87110914}
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
	set_instantiation_interface_parameter_value control_slave dfhFeatureType {3}
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
	set_instantiation_interface_parameter_value control_slave waitrequestTimeout {1024}
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
	add_component version ip/controller/tile4_temp_reg_2.ip altera_avalon_pio tile4_temp_reg_2
	load_component version
	set_component_parameter_value bitClearingEdgeCapReg {0}
	set_component_parameter_value bitModifyingOutReg {0}
	set_component_parameter_value captureEdge {1}
	set_component_parameter_value direction {Input}
	set_component_parameter_value edgeType {RISING}
	set_component_parameter_value generateIRQ {0}
	set_component_parameter_value irqType {LEVEL}
	set_component_parameter_value resetValue {0.0}
	set_component_parameter_value simDoTestBenchWiring {0}
	set_component_parameter_value simDrivenValue {0.0}
	set_component_parameter_value width {32}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation version
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_CLEARING_EDGE_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_MODIFYING_OUTPUT_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.CAPTURE {1}
	set_instantiation_assignment_value embeddedsw.CMacro.DATA_WIDTH {32}
	set_instantiation_assignment_value embeddedsw.CMacro.DO_TEST_BENCH_WIRING {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DRIVEN_SIM_VALUE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.EDGE_TYPE {RISING}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {125000000}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_IN {1}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_OUT {0}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_TRI {0}
	set_instantiation_assignment_value embeddedsw.CMacro.IRQ_TYPE {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.RESET_VALUE {0}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,pio-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {gpio}
	set_instantiation_assignment_value embeddedsw.dts.name {pio}
	set_instantiation_assignment_value embeddedsw.dts.params.altr,gpio-bank-width {32}
	set_instantiation_assignment_value embeddedsw.dts.params.resetvalue {0}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset reset_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface s1 avalon INPUT
	set_instantiation_interface_parameter_value s1 addressAlignment {NATIVE}
	set_instantiation_interface_parameter_value s1 addressGroup {0}
	set_instantiation_interface_parameter_value s1 addressSpan {4}
	set_instantiation_interface_parameter_value s1 addressUnits {WORDS}
	set_instantiation_interface_parameter_value s1 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value s1 associatedClock {clk}
	set_instantiation_interface_parameter_value s1 associatedReset {reset}
	set_instantiation_interface_parameter_value s1 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value s1 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value s1 bridgesToMaster {}
	set_instantiation_interface_parameter_value s1 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value s1 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value s1 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value s1 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s1 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s1 dfhFeatureType {3}
	set_instantiation_interface_parameter_value s1 dfhGroupId {0}
	set_instantiation_interface_parameter_value s1 dfhParameterData {}
	set_instantiation_interface_parameter_value s1 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s1 dfhParameterId {}
	set_instantiation_interface_parameter_value s1 dfhParameterName {}
	set_instantiation_interface_parameter_value s1 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s1 explicitAddressSpan {0}
	set_instantiation_interface_parameter_value s1 holdTime {0}
	set_instantiation_interface_parameter_value s1 interleaveBursts {false}
	set_instantiation_interface_parameter_value s1 isBigEndian {false}
	set_instantiation_interface_parameter_value s1 isFlash {false}
	set_instantiation_interface_parameter_value s1 isMemoryDevice {false}
	set_instantiation_interface_parameter_value s1 isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value s1 linewrapBursts {false}
	set_instantiation_interface_parameter_value s1 maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value s1 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value s1 minimumReadLatency {1}
	set_instantiation_interface_parameter_value s1 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value s1 minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value s1 prSafe {false}
	set_instantiation_interface_parameter_value s1 printableDevice {false}
	set_instantiation_interface_parameter_value s1 readLatency {0}
	set_instantiation_interface_parameter_value s1 readWaitStates {1}
	set_instantiation_interface_parameter_value s1 readWaitTime {1}
	set_instantiation_interface_parameter_value s1 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value s1 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value s1 setupTime {0}
	set_instantiation_interface_parameter_value s1 timingUnits {Cycles}
	set_instantiation_interface_parameter_value s1 transparentBridge {false}
	set_instantiation_interface_parameter_value s1 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value s1 waitrequestTimeout {1024}
	set_instantiation_interface_parameter_value s1 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value s1 writeLatency {0}
	set_instantiation_interface_parameter_value s1 writeWaitStates {0}
	set_instantiation_interface_parameter_value s1 writeWaitTime {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value s1 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value s1 address_map {<address-map><slave name='s1' start='0x0' end='0x10' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value s1 address_width {4}
	set_instantiation_interface_sysinfo_parameter_value s1 max_slave_data_width {32}
	add_instantiation_interface_port s1 address address 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 write_n write_n 1 STD_LOGIC Input
	add_instantiation_interface_port s1 writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s1 chipselect chipselect 1 STD_LOGIC Input
	add_instantiation_interface_port s1 readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface external_connection conduit INPUT
	set_instantiation_interface_parameter_value external_connection associatedClock {}
	set_instantiation_interface_parameter_value external_connection associatedReset {}
	set_instantiation_interface_parameter_value external_connection prSafe {false}
	add_instantiation_interface_port external_connection in_port export 32 STD_LOGIC_VECTOR Input
	save_instantiation

	# add wirelevel expressions

	# preserve ports for debug

	# add the connections
	add_connection clock_bridge_0.out_clk/controller_reset_sequencer_0.clk
	set_connection_parameter_value clock_bridge_0.out_clk/controller_reset_sequencer_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/controller_reset_sequencer_0.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/controller_reset_sequencer_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/controller_reset_sequencer_0.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/i2c_0.clock
	set_connection_parameter_value clock_bridge_0.out_clk/i2c_0.clock clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/i2c_0.clock clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/i2c_0.clock clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/i2c_0.clock resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/internal_noise.clk
	set_connection_parameter_value clock_bridge_0.out_clk/internal_noise.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/internal_noise.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/internal_noise.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/internal_noise.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/irq_10us.clk
	set_connection_parameter_value clock_bridge_0.out_clk/irq_10us.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/irq_10us.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/irq_10us.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/irq_10us.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/jtag_uart.clk
	set_connection_parameter_value clock_bridge_0.out_clk/jtag_uart.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/jtag_uart.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/jtag_uart.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/jtag_uart.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/module_input_reg.clk
	set_connection_parameter_value clock_bridge_0.out_clk/module_input_reg.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/module_input_reg.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/module_input_reg.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/module_input_reg.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/module_output_reg.clk
	set_connection_parameter_value clock_bridge_0.out_clk/module_output_reg.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/module_output_reg.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/module_output_reg.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/module_output_reg.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/niosv_m.clk
	set_connection_parameter_value clock_bridge_0.out_clk/niosv_m.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/niosv_m.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/niosv_m.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/niosv_m.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/phy_reg_set.clk
	set_connection_parameter_value clock_bridge_0.out_clk/phy_reg_set.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/phy_reg_set.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/phy_reg_set.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/phy_reg_set.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/prg_ram.clk1
	set_connection_parameter_value clock_bridge_0.out_clk/prg_ram.clk1 clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/prg_ram.clk1 clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/prg_ram.clk1 clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/prg_ram.clk1 resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/reg_set.clk
	set_connection_parameter_value clock_bridge_0.out_clk/reg_set.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/reg_set.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/reg_set.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/reg_set.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/reset_bridge_0.clk
	set_connection_parameter_value clock_bridge_0.out_clk/reset_bridge_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/reset_bridge_0.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/reset_bridge_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/reset_bridge_0.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/s10_mailbox_client_0.in_clk
	set_connection_parameter_value clock_bridge_0.out_clk/s10_mailbox_client_0.in_clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/s10_mailbox_client_0.in_clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/s10_mailbox_client_0.in_clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/s10_mailbox_client_0.in_clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/sys_clk_timer.clk
	set_connection_parameter_value clock_bridge_0.out_clk/sys_clk_timer.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/sys_clk_timer.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/sys_clk_timer.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/sys_clk_timer.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/sysid_qsys_0.clk
	set_connection_parameter_value clock_bridge_0.out_clk/sysid_qsys_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/sysid_qsys_0.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/sysid_qsys_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/sysid_qsys_0.clk resetDomainSysInfo {1}
	add_connection clock_bridge_0.out_clk/version.clk
	set_connection_parameter_value clock_bridge_0.out_clk/version.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_bridge_0.out_clk/version.clk clockRateSysInfo {125000000.0}
	set_connection_parameter_value clock_bridge_0.out_clk/version.clk clockResetSysInfo {}
	set_connection_parameter_value clock_bridge_0.out_clk/version.clk resetDomainSysInfo {1}
	add_connection controller_reset_sequencer_0.reset_out0/i2c_0.reset_sink
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/i2c_0.reset_sink clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/i2c_0.reset_sink clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/i2c_0.reset_sink resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/internal_noise.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/internal_noise.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/internal_noise.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/internal_noise.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/irq_10us.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/irq_10us.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/irq_10us.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/irq_10us.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/jtag_uart.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/jtag_uart.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/jtag_uart.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/jtag_uart.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/module_input_reg.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/module_input_reg.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/module_input_reg.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/module_input_reg.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/module_output_reg.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/module_output_reg.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/module_output_reg.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/module_output_reg.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/niosv_m.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/niosv_m.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/niosv_m.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/niosv_m.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/phy_reg_set.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/phy_reg_set.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/phy_reg_set.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/phy_reg_set.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/prg_ram.reset1
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/prg_ram.reset1 clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/prg_ram.reset1 clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/prg_ram.reset1 resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/reg_set.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/reg_set.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/reg_set.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/reg_set.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/s10_mailbox_client_0.in_reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/s10_mailbox_client_0.in_reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/s10_mailbox_client_0.in_reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/s10_mailbox_client_0.in_reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/sys_clk_timer.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/sys_clk_timer.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/sys_clk_timer.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/sys_clk_timer.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/sysid_qsys_0.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/sysid_qsys_0.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/sysid_qsys_0.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/sysid_qsys_0.reset resetDomainSysInfo {3}
	add_connection controller_reset_sequencer_0.reset_out0/version.reset
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/version.reset clockDomainSysInfo {3}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/version.reset clockResetSysInfo {}
	set_connection_parameter_value controller_reset_sequencer_0.reset_out0/version.reset resetDomainSysInfo {3}
	add_connection niosv_m.data_manager/i2c_0.csr
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr baseAddress {0x00410240}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/i2c_0.csr slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/internal_noise.s1
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 baseAddress {0x00410330}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/internal_noise.s1 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/irq_10us.s1
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 baseAddress {0x004102e0}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/irq_10us.s1 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/jtag_uart.avalon_jtag_slave
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave baseAddress {0x00410348}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/jtag_uart.avalon_jtag_slave slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/module_input_reg.s1
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 baseAddress {0x00410320}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/module_input_reg.s1 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/module_output_reg.s1
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 baseAddress {0x00410310}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/module_output_reg.s1 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/niosv_m.dm_agent
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent baseAddress {0x00400000}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.dm_agent slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/niosv_m.timer_sw_agent
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent baseAddress {0x00410200}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/niosv_m.timer_sw_agent slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/phy_reg_set.s0
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 baseAddress {0x20000000}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/phy_reg_set.s0 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/prg_ram.axi_s1
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 baseAddress {0x0000}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/prg_ram.axi_s1 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/reg_set.s0
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 baseAddress {0x00410000}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/reg_set.s0 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/s10_mailbox_client_0.avmm
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm baseAddress {0x00410280}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/s10_mailbox_client_0.avmm slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/sys_clk_timer.s1
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 baseAddress {0x004102c0}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/sys_clk_timer.s1 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/sysid_qsys_0.control_slave
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave baseAddress {0x00410340}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/sysid_qsys_0.control_slave slaveDataWidthSysInfo {-1}
	add_connection niosv_m.data_manager/version.s1
	set_connection_parameter_value niosv_m.data_manager/version.s1 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /><slave name='reg_set.s0' start='0x410000' end='0x410200' datawidth='32' /><slave name='niosv_m.timer_sw_agent' start='0x410200' end='0x410240' datawidth='32' /><slave name='i2c_0.csr' start='0x410240' end='0x410280' datawidth='32' /><slave name='s10_mailbox_client_0.avmm' start='0x410280' end='0x4102C0' datawidth='32' /><slave name='sys_clk_timer.s1' start='0x4102C0' end='0x4102E0' datawidth='16' /><slave name='irq_10us.s1' start='0x4102E0' end='0x410300' datawidth='16' /><slave name='version.s1' start='0x410300' end='0x410310' datawidth='32' /><slave name='module_output_reg.s1' start='0x410310' end='0x410320' datawidth='32' /><slave name='module_input_reg.s1' start='0x410320' end='0x410330' datawidth='32' /><slave name='internal_noise.s1' start='0x410330' end='0x410340' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x410340' end='0x410348' datawidth='32' /><slave name='jtag_uart.avalon_jtag_slave' start='0x410348' end='0x410350' datawidth='32' /><slave name='phy_reg_set.s0' start='0x20000000' end='0x40000000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.data_manager/version.s1 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.data_manager/version.s1 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.data_manager/version.s1 baseAddress {0x00410300}
	set_connection_parameter_value niosv_m.data_manager/version.s1 defaultConnection {0}
	set_connection_parameter_value niosv_m.data_manager/version.s1 domainAlias {}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.data_manager/version.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.data_manager/version.s1 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.instruction_manager/niosv_m.dm_agent
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent arbitrationPriority {1}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent baseAddress {0x00400000}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent defaultConnection {0}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent domainAlias {}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.instruction_manager/niosv_m.dm_agent slaveDataWidthSysInfo {-1}
	add_connection niosv_m.instruction_manager/prg_ram.axi_s1
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 addressMapSysInfo {<address-map><slave name='prg_ram.axi_s1' start='0x0' end='0x400000' datawidth='32' /><slave name='niosv_m.dm_agent' start='0x400000' end='0x410000' datawidth='32' /></address-map>}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 addressWidthSysInfo {}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 arbitrationPriority {1}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 baseAddress {0x0000}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 defaultConnection {0}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 domainAlias {}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value niosv_m.instruction_manager/prg_ram.axi_s1 slaveDataWidthSysInfo {-1}
	add_connection niosv_m.platform_irq_rx/i2c_0.interrupt_sender
	set_connection_parameter_value niosv_m.platform_irq_rx/i2c_0.interrupt_sender interruptsUsedSysInfo {31}
	set_connection_parameter_value niosv_m.platform_irq_rx/i2c_0.interrupt_sender irqNumber {1}
	add_connection niosv_m.platform_irq_rx/irq_10us.irq
	set_connection_parameter_value niosv_m.platform_irq_rx/irq_10us.irq interruptsUsedSysInfo {31}
	set_connection_parameter_value niosv_m.platform_irq_rx/irq_10us.irq irqNumber {0}
	add_connection niosv_m.platform_irq_rx/jtag_uart.irq
	set_connection_parameter_value niosv_m.platform_irq_rx/jtag_uart.irq interruptsUsedSysInfo {31}
	set_connection_parameter_value niosv_m.platform_irq_rx/jtag_uart.irq irqNumber {2}
	add_connection niosv_m.platform_irq_rx/s10_mailbox_client_0.irq
	set_connection_parameter_value niosv_m.platform_irq_rx/s10_mailbox_client_0.irq interruptsUsedSysInfo {31}
	set_connection_parameter_value niosv_m.platform_irq_rx/s10_mailbox_client_0.irq irqNumber {3}
	add_connection niosv_m.platform_irq_rx/sys_clk_timer.irq
	set_connection_parameter_value niosv_m.platform_irq_rx/sys_clk_timer.irq interruptsUsedSysInfo {31}
	set_connection_parameter_value niosv_m.platform_irq_rx/sys_clk_timer.irq irqNumber {4}
	add_connection reset_bridge_0.out_reset/controller_reset_sequencer_0.reset_in0
	set_connection_parameter_value reset_bridge_0.out_reset/controller_reset_sequencer_0.reset_in0 clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/controller_reset_sequencer_0.reset_in0 clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/controller_reset_sequencer_0.reset_in0 resetDomainSysInfo {2}

	# add the exports
	set_interface_property clk_in EXPORT_OF clock_bridge_0.in_clk
	set_interface_property i2c_0_i2c_serial EXPORT_OF i2c_0.i2c_serial
	set_interface_property internal_noise_control EXPORT_OF internal_noise.external_connection
	set_interface_property module_input_reg EXPORT_OF module_input_reg.external_connection
	set_interface_property module_output_reg EXPORT_OF module_output_reg.external_connection
	set_interface_property reconfig_xcvr_0_s0 EXPORT_OF phy_reg_set.reconfig_xcvr_0
	set_interface_property reconfig_xcvr_0_reset EXPORT_OF phy_reg_set.reconfig_xcvr_reset_0
	set_interface_property reconfig_pdp_0_s0 EXPORT_OF phy_reg_set.reconfig_pdp_0
	set_interface_property reconfig_pdp_0_reset EXPORT_OF phy_reg_set.reconfig_pdp_reset_0
	set_interface_property reconfig_xcvr_1_s0 EXPORT_OF phy_reg_set.reconfig_xcvr_1
	set_interface_property reconfig_xcvr_1_reset EXPORT_OF phy_reg_set.reconfig_xcvr_reset_1
	set_interface_property reconfig_pdp_1_s0 EXPORT_OF phy_reg_set.reconfig_pdp_1
	set_interface_property reconfig_pdp_1_reset EXPORT_OF phy_reg_set.reconfig_pdp_reset_1
	set_interface_property reconfig_xcvr_2_s0 EXPORT_OF phy_reg_set.reconfig_xcvr_2
	set_interface_property reconfig_xcvr_2_reset EXPORT_OF phy_reg_set.reconfig_xcvr_reset_2
	set_interface_property reconfig_pdp_2_s0 EXPORT_OF phy_reg_set.reconfig_pdp_2
	set_interface_property reconfig_pdp_2_reset EXPORT_OF phy_reg_set.reconfig_pdp_reset_2
	set_interface_property reconfig_xcvr_3_s0 EXPORT_OF phy_reg_set.reconfig_xcvr_3
	set_interface_property reconfig_xcvr_3_reset EXPORT_OF phy_reg_set.reconfig_xcvr_reset_3
	set_interface_property reconfig_pdp_3_s0 EXPORT_OF phy_reg_set.reconfig_pdp_3
	set_interface_property reconfig_pdp_3_reset EXPORT_OF phy_reg_set.reconfig_pdp_reset_3
	set_interface_property phy_reg_set_control_reg_0 EXPORT_OF phy_reg_set.control_reg_0
	set_interface_property phy_reg_set_control2_reg_0 EXPORT_OF phy_reg_set.control2_reg_0
	set_interface_property phy_reg_set_bitrate_0 EXPORT_OF phy_reg_set.bitrate_0
	set_interface_property phy_reg_set_rxclock_0 EXPORT_OF phy_reg_set.rxclock_0
	set_interface_property phy_reg_set_counter_1ms_reg_0 EXPORT_OF phy_reg_set.counter_1ms_reg_0
	set_interface_property reconfig_xcvr_4_s0 EXPORT_OF phy_reg_set.reconfig_xcvr_4
	set_interface_property reconfig_xcvr_4_reset EXPORT_OF phy_reg_set.reconfig_xcvr_reset_4
	set_interface_property reconfig_pdp_4_s0 EXPORT_OF phy_reg_set.reconfig_pdp_4
	set_interface_property reconfig_pdp_4_reset EXPORT_OF phy_reg_set.reconfig_pdp_reset_4
	set_interface_property reconfig_xcvr_5_s0 EXPORT_OF phy_reg_set.reconfig_xcvr_5
	set_interface_property reconfig_xcvr_5_reset EXPORT_OF phy_reg_set.reconfig_xcvr_reset_5
	set_interface_property reconfig_pdp_5_s0 EXPORT_OF phy_reg_set.reconfig_pdp_5
	set_interface_property reconfig_pdp_5_reset EXPORT_OF phy_reg_set.reconfig_pdp_reset_5
	set_interface_property reconfig_xcvr_6_s0 EXPORT_OF phy_reg_set.reconfig_xcvr_6
	set_interface_property reconfig_xcvr_6_reset EXPORT_OF phy_reg_set.reconfig_xcvr_reset_6
	set_interface_property reconfig_pdp_6_s0 EXPORT_OF phy_reg_set.reconfig_pdp_6
	set_interface_property reconfig_pdp_6_reset EXPORT_OF phy_reg_set.reconfig_pdp_reset_6
	set_interface_property reconfig_xcvr_7_s0 EXPORT_OF phy_reg_set.reconfig_xcvr_7
	set_interface_property reconfig_xcvr_7_reset EXPORT_OF phy_reg_set.reconfig_xcvr_reset_7
	set_interface_property reconfig_pdp_7_s0 EXPORT_OF phy_reg_set.reconfig_pdp_7
	set_interface_property reconfig_pdp_7_reset EXPORT_OF phy_reg_set.reconfig_pdp_reset_7
	set_interface_property phy_reg_set_control_reg_1 EXPORT_OF phy_reg_set.control_reg_1
	set_interface_property phy_reg_set_control2_reg_1 EXPORT_OF phy_reg_set.control2_reg_1
	set_interface_property phy_reg_set_bitrate_1 EXPORT_OF phy_reg_set.bitrate_1
	set_interface_property phy_reg_set_rxclock_1 EXPORT_OF phy_reg_set.rxclock_1
	set_interface_property phy_reg_set_counter_1ms_reg_1 EXPORT_OF phy_reg_set.counter_1ms_reg_1
	set_interface_property reg_set_channel_0 EXPORT_OF reg_set.channel_0
	set_interface_property reg_set_error_count_h_0 EXPORT_OF reg_set.error_count_h_0
	set_interface_property reg_set_error_count_l_0 EXPORT_OF reg_set.error_count_l_0
	set_interface_property reg_set_prbslock_alarm_count_0 EXPORT_OF reg_set.prbslock_alarm_count_0
	set_interface_property reg_set_channel_1 EXPORT_OF reg_set.channel_1
	set_interface_property reg_set_error_count_h_1 EXPORT_OF reg_set.error_count_h_1
	set_interface_property reg_set_error_count_l_1 EXPORT_OF reg_set.error_count_l_1
	set_interface_property reg_set_prbslock_alarm_count_1 EXPORT_OF reg_set.prbslock_alarm_count_1
	set_interface_property reg_set_channel_2 EXPORT_OF reg_set.channel_2
	set_interface_property reg_set_error_count_h_2 EXPORT_OF reg_set.error_count_h_2
	set_interface_property reg_set_error_count_l_2 EXPORT_OF reg_set.error_count_l_2
	set_interface_property reg_set_prbslock_alarm_count_2 EXPORT_OF reg_set.prbslock_alarm_count_2
	set_interface_property reg_set_channel_3 EXPORT_OF reg_set.channel_3
	set_interface_property reg_set_error_count_h_3 EXPORT_OF reg_set.error_count_h_3
	set_interface_property reg_set_error_count_l_3 EXPORT_OF reg_set.error_count_l_3
	set_interface_property reg_set_prbslock_alarm_count_3 EXPORT_OF reg_set.prbslock_alarm_count_3
	set_interface_property reg_set_channel_4 EXPORT_OF reg_set.channel_4
	set_interface_property reg_set_error_count_h_4 EXPORT_OF reg_set.error_count_h_4
	set_interface_property reg_set_error_count_l_4 EXPORT_OF reg_set.error_count_l_4
	set_interface_property reg_set_prbslock_alarm_count_4 EXPORT_OF reg_set.prbslock_alarm_count_4
	set_interface_property reg_set_channel_5 EXPORT_OF reg_set.channel_5
	set_interface_property reg_set_error_count_h_5 EXPORT_OF reg_set.error_count_h_5
	set_interface_property reg_set_error_count_l_5 EXPORT_OF reg_set.error_count_l_5
	set_interface_property reg_set_prbslock_alarm_count_5 EXPORT_OF reg_set.prbslock_alarm_count_5
	set_interface_property reg_set_channel_6 EXPORT_OF reg_set.channel_6
	set_interface_property reg_set_error_count_h_6 EXPORT_OF reg_set.error_count_h_6
	set_interface_property reg_set_error_count_l_6 EXPORT_OF reg_set.error_count_l_6
	set_interface_property reg_set_prbslock_alarm_count_6 EXPORT_OF reg_set.prbslock_alarm_count_6
	set_interface_property reg_set_channel_7 EXPORT_OF reg_set.channel_7
	set_interface_property reg_set_error_count_h_7 EXPORT_OF reg_set.error_count_h_7
	set_interface_property reg_set_error_count_l_7 EXPORT_OF reg_set.error_count_l_7
	set_interface_property reg_set_prbslock_alarm_count_7 EXPORT_OF reg_set.prbslock_alarm_count_7
	set_interface_property reset_in_n EXPORT_OF reset_bridge_0.in_reset
	set_interface_property version EXPORT_OF version.external_connection

	# set values for exposed HDL parameters
	set_domain_assignment niosv_m.data_manager qsys_mm.burstAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment niosv_m.data_manager qsys_mm.clockCrossingAdapter HANDSHAKE
	set_domain_assignment niosv_m.data_manager qsys_mm.enableAllPipelines FALSE
	set_domain_assignment niosv_m.data_manager qsys_mm.enableEccProtection FALSE
	set_domain_assignment niosv_m.data_manager qsys_mm.enableInstrumentation FALSE
	set_domain_assignment niosv_m.data_manager qsys_mm.enableOutOfOrderSupport FALSE
	set_domain_assignment niosv_m.data_manager qsys_mm.insertDefaultSlave FALSE
	set_domain_assignment niosv_m.data_manager qsys_mm.interconnectResetSource DEFAULT
	set_domain_assignment niosv_m.data_manager qsys_mm.interconnectType STANDARD
	set_domain_assignment niosv_m.data_manager qsys_mm.maxAdditionalLatency 1
	set_domain_assignment niosv_m.data_manager qsys_mm.optimizeRdFifoSize FALSE
	set_domain_assignment niosv_m.data_manager qsys_mm.piplineType PIPELINE_STAGE
	set_domain_assignment niosv_m.data_manager qsys_mm.responseFifoType REGISTER_BASED
	set_domain_assignment niosv_m.data_manager qsys_mm.syncResets TRUE
	set_domain_assignment niosv_m.data_manager qsys_mm.widthAdapterImplementation GENERIC_CONVERTER

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="PMA_Control1_Reg">
  <datum __value="_sortIndex" value="12" type="int" />
 </element>
 <element __value="PMA_Control2_Reg">
  <datum __value="_sortIndex" value="13" type="int" />
 </element>
 <element __value="clock_bridge_0">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
 <element __value="controller_reset_sequencer_0">
  <datum __value="_sortIndex" value="2" type="int" />
 </element>
 <element __value="i2c_0">
  <datum __value="_sortIndex" value="4" type="int" />
 </element>
 <element __value="i2c_0.csr">
  <datum __value="baseAddress" value="4260416" type="String" />
 </element>
 <element __value="internal_noise">
  <datum __value="_sortIndex" value="13" type="int" />
 </element>
 <element __value="internal_noise.s1">
  <datum __value="baseAddress" value="4260656" type="String" />
 </element>
 <element __value="irq_10us">
  <datum __value="_sortIndex" value="5" type="int" />
 </element>
 <element __value="irq_10us.s1">
  <datum __value="baseAddress" value="4260576" type="String" />
 </element>
 <element __value="jtag_uart">
  <datum __value="_sortIndex" value="3" type="int" />
 </element>
 <element __value="jtag_uart.avalon_jtag_slave">
  <datum __value="baseAddress" value="4260680" type="String" />
 </element>
 <element __value="module_input_reg">
  <datum __value="_sortIndex" value="11" type="int" />
 </element>
 <element __value="module_input_reg.s1">
  <datum __value="baseAddress" value="4260640" type="String" />
 </element>
 <element __value="module_output_reg">
  <datum __value="_sortIndex" value="12" type="int" />
 </element>
 <element __value="module_output_reg.s1">
  <datum __value="baseAddress" value="4260624" type="String" />
 </element>
 <element __value="niosv_m">
  <datum __value="_sortIndex" value="8" type="int" />
 </element>
 <element __value="niosv_m.dm_agent">
  <datum __value="baseAddress" value="4194304" type="String" />
 </element>
 <element __value="niosv_m.timer_sw_agent">
  <datum __value="baseAddress" value="4260352" type="String" />
 </element>
 <element __value="phy_reg_set">
  <datum __value="_sortIndex" value="16" type="int" />
 </element>
 <element __value="phy_reg_set.s0">
  <datum __value="baseAddress" value="536870912" type="String" />
 </element>
 <element __value="prg_ram">
  <datum __value="_sortIndex" value="7" type="int" />
 </element>
 <element __value="prg_ram.axi_s1">
  <datum __value="baseAddress" value="0" type="String" />
 </element>
 <element __value="reg_set">
  <datum __value="_sortIndex" value="15" type="int" />
 </element>
 <element __value="reg_set.s0">
  <datum __value="baseAddress" value="4259840" type="String" />
 </element>
 <element __value="reset_bridge_0">
  <datum __value="_sortIndex" value="1" type="int" />
 </element>
 <element __value="s10_mailbox_client_0">
  <datum __value="_sortIndex" value="14" type="int" />
 </element>
 <element __value="s10_mailbox_client_0.avmm">
  <datum __value="baseAddress" value="4260480" type="String" />
 </element>
 <element __value="sys_clk_timer">
  <datum __value="_sortIndex" value="6" type="int" />
 </element>
 <element __value="sys_clk_timer.s1">
  <datum __value="baseAddress" value="4260544" type="String" />
 </element>
 <element __value="sysid_qsys_0">
  <datum __value="_sortIndex" value="10" type="int" />
 </element>
 <element __value="sysid_qsys_0.control_slave">
  <datum __value="baseAddress" value="4260672" type="String" />
 </element>
 <element __value="version">
  <datum __value="_sortIndex" value="9" type="int" />
 </element>
 <element __value="version.s1">
  <datum __value="baseAddress" value="4260608" type="String" />
 </element>
</bonusData>
}
	set_module_property FILE {controller.qsys}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {controller}

	# save the system
	sync_sysinfo_parameters
	save_system controller
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_controller

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
