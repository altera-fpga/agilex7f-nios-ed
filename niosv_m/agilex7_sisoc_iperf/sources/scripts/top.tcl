# Copyright (C) 2024  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the Intel FPGA Software License Subscription Agreements 
# on the Quartus Prime software download page.

# Quartus Prime: Generate Tcl File for Project
# File: top.tcl
# Generated on: Tue Jun 25 02:33:39 2024

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "top"]} {
		puts "Project top is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists top]} {
		project_open -revision top top
	} else {
		project_new -revision top top
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name TOP_LEVEL_ENTITY top
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 17.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "20:40:19  NOVEMBER 23, 2017"
	set_global_assignment -name LAST_QUARTUS_VERSION "24.3.0 Pro Edition"
	set_global_assignment -name FAMILY "Agilex 7"
	set_global_assignment -name DEVICE AGFB014R24B2E2V
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON
	set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
	set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
	set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
	set_global_assignment -name USE_CONF_DONE SDM_IO16
	set_global_assignment -name PWRMGT_BUS_SPEED_MODE "100 KHZ"
	set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTC3888
	set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 28
	set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
	set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
	set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
	set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
	set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "AVST X32"
	set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
	set_global_assignment -name GENERATE_PR_RBF_FILE ON
	set_global_assignment -name ENABLE_ED_CRC_CHECK ON
	set_global_assignment -name MINIMUM_SEU_INTERVAL 0
	set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_115MHZ_IOSC
	set_global_assignment -name ENABLE_SIGNALTAP OFF
	set_global_assignment -name USE_SIGNALTAP_FILE tse_stp_042419.stp
	set_global_assignment -name PROJECT_IP_REGENERATION_POLICY NEVER_REGENERATE_IP
	set_global_assignment -name FLOW_DISABLE_ASSEMBLER OFF
	set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL
	set_global_assignment -name NUMBER_OF_SLAVE_DEVICE 1
	set_global_assignment -name BOARD "Agilex 7 FPGA F-Series Transceiver-SoC Development Kit P-Tile and E-Tile DK-SI-AGF014EB"
	set_global_assignment -name VERILOG_FILE top.v
	set_global_assignment -name SDC_FILE top.sdc
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_eth_tse_0.ip
	set_global_assignment -name QSYS_FILE qsys_top.qsys
	set_global_assignment -name IP_FILE reset_release.ip
	set_global_assignment -name IP_FILE sys_pll.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_intel_niosv_m_0.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_intel_onchip_memory_0.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_intel_onchip_memory_1.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_jtag_uart_0.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_sysid_qsys_0.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_msgdma_0.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_msgdma_1.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_clock_bridge_0.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_reset_bridge_0.ip
	set_global_assignment -name IP_FILE ip/qsys_top/qsys_top_pio_0.ip
	set_location_assignment PIN_AT13 -to refclk_preserve_xcvr
	set_location_assignment PIN_AP13 -to "refclk_preserve_xcvr(n)"
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL LVPECL" -to refclk_preserve_xcvr -entity top
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL LVPECL" -to "refclk_preserve_xcvr(n)" -entity top
	set_instance_assignment -name HSSI_PARAMETER "refclk_divider_use_as_BTI_clock=TRUE" -to refclk_preserve_xcvr -entity top
	set_instance_assignment -name HSSI_PARAMETER "refclk_divider_input_freq=156250000" -to refclk_preserve_xcvr -entity top
	set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to REF_CLK -entity top
	set_location_assignment PIN_CN22 -to REF_CLK
	set_location_assignment PIN_CL22 -to "REF_CLK(n)"
	set_location_assignment PIN_F41 -to RESET_N
	set_location_assignment PIN_CG22 -to TXP
	set_location_assignment PIN_CH21 -to RXP
	set_instance_assignment -name IO_STANDARD "1.2 V" -to MDC -entity top
	set_instance_assignment -name IO_STANDARD "1.2 V" -to MDIO -entity top
	set_instance_assignment -name IO_STANDARD "1.2 V" -to PHY_RESET_N -entity top
	set_location_assignment PIN_CL56 -to PHY_RESET_N
	set_location_assignment PIN_CE46 -to MDIO
	set_location_assignment PIN_CL50 -to MDC
	set_location_assignment PIN_B41 -to LED_CHAR_ERR_N
	set_location_assignment PIN_D41 -to LED_DISP_ERR_N
	set_location_assignment PIN_A40 -to LED_LINK_N
	set_location_assignment PIN_C40 -to LED_PANEL_LINK_N
	set_instance_assignment -name PARTITION_COLOUR 4289977599 -to top -entity top
	set_instance_assignment -name PARTITION_COLOUR 4285964287 -to auto_fab_0 -entity top
	set_location_assignment PIN_CF21 -to RXN
	set_location_assignment PIN_CE22 -to TXN
	set_instance_assignment -name IO_STANDARD "1.2 V" -to LED_LINK_N -entity top
	set_instance_assignment -name IO_STANDARD "1.2 V" -to LED_AN_N -entity top
	set_instance_assignment -name IO_STANDARD "1.2 V" -to LED_PANEL_LINK_N -entity top
	set_instance_assignment -name IO_STANDARD "1.2 V" -to LED_CHAR_ERR_N -entity top
	set_instance_assignment -name IO_STANDARD "1.2 V" -to LED_DISP_ERR_N -entity top
	set_location_assignment PIN_CN38 -to CLK_100M
	set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to CLK_100M -entity top
	set_location_assignment PIN_CL38 -to "CLK_100M(n)"
	set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to REF_CLK -entity top
	set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to CLK_100M -entity top
	set_instance_assignment -name IO_STANDARD "1.2 V" -to RESET_N -entity top
	set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to "REF_CLK(n)" -entity top
	set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to "CLK_100M(n)" -entity top
	set_instance_assignment -name SLEW_RATE 2 -to PHY_RESET_N -entity top
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 40 OHM WITHOUT CALIBRATION" -to PHY_RESET_N -entity top
	set_instance_assignment -name SLEW_RATE 2 -to LED_AN_N -entity top
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 40 OHM WITHOUT CALIBRATION" -to LED_AN_N -entity top
	set_instance_assignment -name SLEW_RATE 2 -to LED_CHAR_ERR_N -entity top
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 40 OHM WITHOUT CALIBRATION" -to LED_CHAR_ERR_N -entity top
	set_instance_assignment -name SLEW_RATE 2 -to LED_DISP_ERR_N -entity top
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 40 OHM WITHOUT CALIBRATION" -to LED_DISP_ERR_N -entity top
	set_instance_assignment -name SLEW_RATE 2 -to LED_LINK_N -entity top
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 40 OHM WITHOUT CALIBRATION" -to LED_LINK_N -entity top
	set_instance_assignment -name SLEW_RATE 2 -to LED_PANEL_LINK_N -entity top
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 40 OHM WITHOUT CALIBRATION" -to LED_PANEL_LINK_N -entity top
	set_instance_assignment -name SLEW_RATE 2 -to MDIO -entity top
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 40 OHM WITHOUT CALIBRATION" -to MDIO -entity top
	set_instance_assignment -name SLEW_RATE 2 -to MDC -entity top
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 40 OHM WITHOUT CALIBRATION" -to MDC -entity top
	set_location_assignment PIN_D43 -to user_led[0]
	set_location_assignment PIN_B43 -to user_led[1]
	set_location_assignment PIN_C42 -to user_led[2]
	set_location_assignment PIN_A42 -to user_led[3]

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
