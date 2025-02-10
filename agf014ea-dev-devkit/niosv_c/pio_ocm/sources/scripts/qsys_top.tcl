package require -exact qsys 23.4

# create the system "qsys_top"
proc do_create_qsys_top {} {
	# create the system
	create_system qsys_top
	set_project_property BOARD {Agilex 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {false}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_component clock_in ip/qsys_top/qsys_top_clock_in.ip altera_clock_bridge clock_in
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

	add_component intel_niosv_c_0 ip/qsys_top/qsys_top_intel_niosv_c_1.ip intel_niosv_c intel_niosv_c_1
	load_component intel_niosv_c_0
	apply_component_preset intel_niosv_c
	save_component

	add_component intel_onchip_memory_0 ip/qsys_top/qsys_top_intel_onchip_memory_0.ip intel_onchip_memory intel_onchip_memory_0
	load_component intel_onchip_memory_0
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
	set_component_parameter_value memorySize {1048576.0}
	set_component_parameter_value poison_enable {0}
	set_component_parameter_value readDuringWriteMode_Mixed {DONT_CARE}
	set_component_parameter_value resetrequest_enabled {1}
	set_component_parameter_value singleClockOperation {0}
	set_component_parameter_value tightly_coupled_ecc {0}
	set_component_parameter_value useNonDefaultInitFile {1}
	set_component_parameter_value writable {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation intel_onchip_memory_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR {0}
	set_instantiation_assignment_value embeddedsw.CMacro.CONTENTS_INFO {""}
	set_instantiation_assignment_value embeddedsw.CMacro.DUAL_PORT {0}
	set_instantiation_assignment_value embeddedsw.CMacro.GUI_RAM_BLOCK_TYPE {AUTO}
	set_instantiation_assignment_value embeddedsw.CMacro.INIT_CONTENTS_FILE {onchip_mem}
	set_instantiation_assignment_value embeddedsw.CMacro.INIT_MEM_CONTENT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.INSTANCE_ID {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.NON_DEFAULT_INIT_FILE_ENABLED {1}
	set_instantiation_assignment_value embeddedsw.CMacro.RAM_BLOCK_TYPE {AUTO}
	set_instantiation_assignment_value embeddedsw.CMacro.READ_DURING_WRITE_MODE {DONT_CARE}
	set_instantiation_assignment_value embeddedsw.CMacro.SINGLE_CLOCK_OP {0}
	set_instantiation_assignment_value embeddedsw.CMacro.SIZE_MULTIPLE {1}
	set_instantiation_assignment_value embeddedsw.CMacro.SIZE_VALUE {1048576}
	set_instantiation_assignment_value embeddedsw.CMacro.WRITABLE {1}
	set_instantiation_assignment_value embeddedsw.memoryInfo.DAT_SYM_INSTALL_DIR {SIM_DIR}
	set_instantiation_assignment_value embeddedsw.memoryInfo.GENERATE_DAT_SYM {1}
	set_instantiation_assignment_value embeddedsw.memoryInfo.GENERATE_HEX {1}
	set_instantiation_assignment_value embeddedsw.memoryInfo.HAS_BYTE_LANE {0}
	set_instantiation_assignment_value embeddedsw.memoryInfo.HEX_INSTALL_DIR {QPF_DIR}
	set_instantiation_assignment_value embeddedsw.memoryInfo.MEM_INIT_DATA_WIDTH {32}
	set_instantiation_assignment_value embeddedsw.memoryInfo.MEM_INIT_FILENAME {onchip_mem}
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
	set_instantiation_interface_sysinfo_parameter_value axi_s1 address_map {<address-map><slave name='axi_s1' start='0x0' end='0x100000' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value axi_s1 address_width {20}
	set_instantiation_interface_sysinfo_parameter_value axi_s1 max_slave_data_width {32}
	add_instantiation_interface_port axi_s1 s1_arid arid 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_araddr araddr 20 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_arlen arlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_arsize arsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_arburst arburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_arready arready 1 STD_LOGIC Output
	add_instantiation_interface_port axi_s1 s1_arvalid arvalid 1 STD_LOGIC Input
	add_instantiation_interface_port axi_s1 s1_awid awid 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port axi_s1 s1_awaddr awaddr 20 STD_LOGIC_VECTOR Input
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
	add_component jtag_uart_0 ip/qsys_top/qsys_top_jtag_uart_0.ip altera_avalon_jtag_uart jtag_uart_0
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
	add_component pio_0 ip/qsys_top/qsys_top_pio_0.ip altera_avalon_pio pio_0
	load_component pio_0
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
	set_component_parameter_value width {4}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation pio_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_CLEARING_EDGE_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.BIT_MODIFYING_OUTPUT_REGISTER {0}
	set_instantiation_assignment_value embeddedsw.CMacro.CAPTURE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DATA_WIDTH {4}
	set_instantiation_assignment_value embeddedsw.CMacro.DO_TEST_BENCH_WIRING {0}
	set_instantiation_assignment_value embeddedsw.CMacro.DRIVEN_SIM_VALUE {0}
	set_instantiation_assignment_value embeddedsw.CMacro.EDGE_TYPE {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.FREQ {50000000}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_IN {0}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_OUT {1}
	set_instantiation_assignment_value embeddedsw.CMacro.HAS_TRI {0}
	set_instantiation_assignment_value embeddedsw.CMacro.IRQ_TYPE {NONE}
	set_instantiation_assignment_value embeddedsw.CMacro.RESET_VALUE {0}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,pio-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {gpio}
	set_instantiation_assignment_value embeddedsw.dts.name {pio}
	set_instantiation_assignment_value embeddedsw.dts.params.altr,gpio-bank-width {4}
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
	add_instantiation_interface_port external_connection out_port export 4 STD_LOGIC_VECTOR Output
	save_instantiation
	add_component reset_bridge_0 ip/qsys_top/qsys_top_reset_bridge_0.ip altera_reset_bridge reset_bridge_0
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
	add_component s10_user_rst_clkgate_0 ip/qsys_top/qsys_top_s10_user_rst_clkgate_0.ip altera_s10_user_rst_clkgate s10_user_rst_clkgate_0
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
	add_component sysid_qsys_0 ip/qsys_top/qsys_top_sysid_qsys_0.ip altera_avalon_sysid_qsys sysid_qsys_0
	load_component sysid_qsys_0
	set_component_parameter_value id {165}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation sysid_qsys_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.ID {165}
	set_instantiation_assignment_value embeddedsw.CMacro.TIMESTAMP {0}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,sysid-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {sysid}
	set_instantiation_assignment_value embeddedsw.dts.name {sysid}
	set_instantiation_assignment_value embeddedsw.dts.params.id {165}
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
	add_connection clock_in.out_clk/intel_niosv_c_0.clk
	set_connection_parameter_value clock_in.out_clk/intel_niosv_c_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/intel_niosv_c_0.clk clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/intel_niosv_c_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/intel_niosv_c_0.clk resetDomainSysInfo {1}
	add_connection clock_in.out_clk/intel_onchip_memory_0.clk1
	set_connection_parameter_value clock_in.out_clk/intel_onchip_memory_0.clk1 clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/intel_onchip_memory_0.clk1 clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/intel_onchip_memory_0.clk1 clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/intel_onchip_memory_0.clk1 resetDomainSysInfo {1}
	add_connection clock_in.out_clk/jtag_uart_0.clk
	set_connection_parameter_value clock_in.out_clk/jtag_uart_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/jtag_uart_0.clk clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/jtag_uart_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/jtag_uart_0.clk resetDomainSysInfo {1}
	add_connection clock_in.out_clk/pio_0.clk
	set_connection_parameter_value clock_in.out_clk/pio_0.clk clockDomainSysInfo {1}
	set_connection_parameter_value clock_in.out_clk/pio_0.clk clockRateSysInfo {50000000.0}
	set_connection_parameter_value clock_in.out_clk/pio_0.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/pio_0.clk resetDomainSysInfo {1}
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
	add_connection intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 addressMapSysInfo {<address-map><slave name='intel_onchip_memory_0.axi_s1' start='0x0' end='0x100000' datawidth='32' /><slave name='pio_0.s1' start='0x100040' end='0x100050' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x100050' end='0x100058' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x100058' end='0x100060' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 baseAddress {0x0000}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 defaultConnection {0}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 domainAlias {}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.data_manager/intel_onchip_memory_0.axi_s1 slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave addressMapSysInfo {<address-map><slave name='intel_onchip_memory_0.axi_s1' start='0x0' end='0x100000' datawidth='32' /><slave name='pio_0.s1' start='0x100040' end='0x100050' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x100050' end='0x100058' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x100058' end='0x100060' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave baseAddress {0x00100058}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave defaultConnection {0}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave domainAlias {}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.data_manager/jtag_uart_0.avalon_jtag_slave slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_c_0.data_manager/pio_0.s1
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 addressMapSysInfo {<address-map><slave name='intel_onchip_memory_0.axi_s1' start='0x0' end='0x100000' datawidth='32' /><slave name='pio_0.s1' start='0x100040' end='0x100050' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x100050' end='0x100058' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x100058' end='0x100060' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 baseAddress {0x00100040}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 defaultConnection {0}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 domainAlias {}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.data_manager/pio_0.s1 slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave addressMapSysInfo {<address-map><slave name='intel_onchip_memory_0.axi_s1' start='0x0' end='0x100000' datawidth='32' /><slave name='pio_0.s1' start='0x100040' end='0x100050' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x100050' end='0x100058' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x100058' end='0x100060' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave baseAddress {0x00100050}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave defaultConnection {0}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave domainAlias {}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.data_manager/sysid_qsys_0.control_slave slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 addressMapSysInfo {<address-map><slave name='intel_onchip_memory_0.axi_s1' start='0x0' end='0x100000' datawidth='32' /><slave name='intel_niosv_c_0.timer_sw_agent' start='0x100000' end='0x100040' datawidth='32' /><slave name='pio_0.s1' start='0x100040' end='0x100050' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x100050' end='0x100058' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x100058' end='0x100060' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 baseAddress {0x0000}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 defaultConnection {0}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 domainAlias {}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/intel_onchip_memory_0.axi_s1 slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave addressMapSysInfo {<address-map><slave name='intel_onchip_memory_0.axi_s1' start='0x0' end='0x100000' datawidth='32' /><slave name='intel_niosv_c_0.timer_sw_agent' start='0x100000' end='0x100040' datawidth='32' /><slave name='pio_0.s1' start='0x100040' end='0x100050' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x100050' end='0x100058' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x100058' end='0x100060' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave baseAddress {0x00100058}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave defaultConnection {0}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave domainAlias {}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/jtag_uart_0.avalon_jtag_slave slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_c_0.instruction_manager/pio_0.s1
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 addressMapSysInfo {<address-map><slave name='intel_onchip_memory_0.axi_s1' start='0x0' end='0x100000' datawidth='32' /><slave name='intel_niosv_c_0.timer_sw_agent' start='0x100000' end='0x100040' datawidth='32' /><slave name='pio_0.s1' start='0x100040' end='0x100050' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x100050' end='0x100058' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x100058' end='0x100060' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 baseAddress {0x00100040}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 defaultConnection {0}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 domainAlias {}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/pio_0.s1 slaveDataWidthSysInfo {-1}
	add_connection intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave addressMapSysInfo {<address-map><slave name='intel_onchip_memory_0.axi_s1' start='0x0' end='0x100000' datawidth='32' /><slave name='intel_niosv_c_0.timer_sw_agent' start='0x100000' end='0x100040' datawidth='32' /><slave name='pio_0.s1' start='0x100040' end='0x100050' datawidth='32' /><slave name='sysid_qsys_0.control_slave' start='0x100050' end='0x100058' datawidth='32' /><slave name='jtag_uart_0.avalon_jtag_slave' start='0x100058' end='0x100060' datawidth='32' /></address-map>}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave addressWidthSysInfo {21}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave arbitrationPriority {1}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave baseAddress {0x00100050}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave defaultConnection {0}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave domainAlias {}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value intel_niosv_c_0.instruction_manager/sysid_qsys_0.control_slave slaveDataWidthSysInfo {-1}
	add_connection reset_bridge_0.out_reset/intel_niosv_c_0.reset
	set_connection_parameter_value reset_bridge_0.out_reset/intel_niosv_c_0.reset clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/intel_niosv_c_0.reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/intel_niosv_c_0.reset resetDomainSysInfo {2}
	add_connection reset_bridge_0.out_reset/intel_onchip_memory_0.reset1
	set_connection_parameter_value reset_bridge_0.out_reset/intel_onchip_memory_0.reset1 clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/intel_onchip_memory_0.reset1 clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/intel_onchip_memory_0.reset1 resetDomainSysInfo {2}
	add_connection reset_bridge_0.out_reset/jtag_uart_0.reset
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset resetDomainSysInfo {2}
	add_connection reset_bridge_0.out_reset/pio_0.reset
	set_connection_parameter_value reset_bridge_0.out_reset/pio_0.reset clockDomainSysInfo {2}
	set_connection_parameter_value reset_bridge_0.out_reset/pio_0.reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/pio_0.reset resetDomainSysInfo {2}
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
	set_interface_property pio_0_external_connection EXPORT_OF pio_0.external_connection
	set_interface_port_property pio_0_external_connection pio_0_external_connection_export PIN_TABLE {0,PIN_B31,1.2-V;1,PIN_D31,1.2-V;2,PIN_A30,1.2-V;3,PIN_C30,1.2-V}

	# set values for exposed HDL parameters
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.burstAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.clockCrossingAdapter HANDSHAKE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.enableAllPipelines FALSE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.enableEccProtection FALSE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.enableInstrumentation FALSE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.enableOutOfOrderSupport FALSE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.insertDefaultSlave FALSE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.interconnectResetSource DEFAULT
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.interconnectType STANDARD
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.maxAdditionalLatency 1
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.optimizeRdFifoSize FALSE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.piplineType PIPELINE_STAGE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.responseFifoType REGISTER_BASED
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.syncResets TRUE
	set_domain_assignment intel_niosv_c_0.data_manager qsys_mm.widthAdapterImplementation GENERIC_CONVERTER

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="clock_in">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
 <element __value="intel_niosv_c_0">
  <datum __value="_sortIndex" value="5" type="int" />
 </element>
 <element __value="intel_niosv_c_0.timer_sw_agent">
  <datum __value="baseAddress" value="1048576" type="String" />
 </element>
 <element __value="intel_onchip_memory_0">
  <datum __value="_sortIndex" value="1" type="int" />
 </element>
 <element __value="intel_onchip_memory_0.axi_s1">
  <datum __value="baseAddress" value="0" type="String" />
 </element>
 <element __value="jtag_uart_0">
  <datum __value="_sortIndex" value="3" type="int" />
 </element>
 <element __value="jtag_uart_0.avalon_jtag_slave">
  <datum __value="baseAddress" value="1048664" type="String" />
 </element>
 <element __value="pio_0">
  <datum __value="_sortIndex" value="4" type="int" />
 </element>
 <element __value="pio_0.s1">
  <datum __value="baseAddress" value="1048640" type="String" />
 </element>
 <element __value="reset_bridge_0">
  <datum __value="_sortIndex" value="7" type="int" />
 </element>
 <element __value="s10_user_rst_clkgate_0">
  <datum __value="_sortIndex" value="6" type="int" />
 </element>
 <element __value="sysid_qsys_0">
  <datum __value="_sortIndex" value="2" type="int" />
 </element>
 <element __value="sysid_qsys_0.control_slave">
  <datum __value="baseAddress" value="1048656" type="String" />
 </element>
</bonusData>
}
	set_module_property FILE {qsys_top.qsys}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {qsys_top}

	# save the system
	sync_sysinfo_parameters
	save_system qsys_top
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_qsys_top

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
