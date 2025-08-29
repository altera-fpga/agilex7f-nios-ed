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


## Generated SDC file "top.out.sdc"

## Copyright (C) 2022  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Intel Corporation"
## PROGRAM "Quartus Prime"
## VERSION "Version 22.4.0 Internal Build 51 10/09/2022 SC Pro Edition"

## DATE    "Tue Oct 18 01:52:55 2022"

##
## DEVICE  "AGFB014R24B2E2V"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 62.500 -waveform { 0.000 31.250 } [get_ports {altera_reserved_tck}]
create_clock -name {altera_int_osc_clk} -period 4.000 -waveform { 0.000 2.000 } [get_nodes {*|intosc|oscillator_dut~oscillator_clock}]
create_clock -name {internal_clk} -period 10.000 -waveform { 0.000 5.000 } [get_nodes { auto_fab*|*|*sdm_gpo_out_user_reset~internal_ctrl_clock }]
create_clock -name {u0|ddr4_emif|emif_fm_0_ref_clock} -period 30.000 -waveform { 0.000 15.012 } [get_ports {ddr4_emif_pll_ref_clk_clk}]
create_clock -name {ddr4_emif_mem_mem_dqs[0]_IN} -period 0.833 -waveform { 0.000 0.417 } [get_ports {ddr4_emif_mem_mem_dqs[0]}]
create_clock -name {ddr4_emif_mem_mem_dqs[1]_IN} -period 0.833 -waveform { 0.000 0.417 } [get_ports {ddr4_emif_mem_mem_dqs[1]}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {u0|ddr4_emif|emif_fm_0_vco_clk} -source [get_ports {ddr4_emif_pll_ref_clk_clk}] -multiply_by 36 -master_clock {u0|ddr4_emif|emif_fm_0_ref_clock} [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|phy_clk_phs[0]}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_vco_clk_1} -source [get_ports {ddr4_emif_pll_ref_clk_clk}] -multiply_by 36 -master_clock {u0|ddr4_emif|emif_fm_0_ref_clock} [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst~_DuplicateVCOPH0}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_core_usr_clk} -source [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|phy_clk_phs[0]}] -divide_by 4 -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk} [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[0].tile_ctrl_inst|pa_core_clk_out[0]}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_phy_clk_0} -source [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|phy_clk_phs[0]}] -divide_by 2 -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk} [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|phy_clk[0]}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_phy_clk_1} -source [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst~_DuplicateVCOPH0}] -divide_by 2 -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk_1} [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst~_DuplicateLOADEN0}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_phy_clk_l_0} -source [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|phy_clk_phs[0]}] -divide_by 4 -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk} [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|phy_clk[1]}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_phy_clk_l_1} -source [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst~_DuplicateVCOPH0}] -divide_by 4 -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk_1} [get_nets {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst~_DuplicateLVDS_CLK0}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_wf_clk_0} -source [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst|vcoph[0]}] -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk} [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[0].lane_gen[0].lane_inst|lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_wf_clk_1} -source [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst|vcoph[0]}] -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk} [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[0].lane_gen[1].lane_inst|lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_wf_clk_2} -source [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst|vcoph[0]}] -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk} [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[0].lane_gen[2].lane_inst|lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_wf_clk_3} -source [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst|vcoph[0]}] -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk} [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[0].lane_gen[3].lane_inst|lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_wf_clk_4} -source [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst~_Duplicate|vcoph[0]}] -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk_1} [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[1].lane_gen[1].lane_inst|lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_emif|emif_fm_0_wf_clk_5} -source [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|pll_inst|pll_inst~_Duplicate|vcoph[0]}] -master_clock {u0|ddr4_emif|emif_fm_0_vco_clk_1} [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[1].lane_gen[0].lane_inst|lane_inst~out_phy_reg}] 
create_generated_clock -name {osc_clk_div2} -source [get_nodes {*|intosc|oscillator_dut~oscillator_clock}] -divide_by 16 -master_clock {altera_int_osc_clk} [get_pins {osc_clk_div2[1]|q}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}]  0.366  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}]  0.366  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}]  0.366  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}]  0.366  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}]  0.366  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}]  0.366  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}]  0.366  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}]  0.366  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -setup 0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -setup 0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -setup 0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -setup 0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_0}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.366  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.366  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -setup 0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -setup 0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.366  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.366  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -setup 0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -setup 0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_1}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -setup 0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -setup 0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -setup 0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -setup 0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_0}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.366  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.366  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -setup 0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -setup 0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.366  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.366  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -setup 0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -setup 0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_phy_clk_l_1}] -hold 0.020  -enable_same_physical_edge
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}] -rise_to [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}] -fall_to [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}] -rise_to [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}] -fall_to [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}] -rise_to [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}] -fall_to [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}] -rise_to [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}] -fall_to [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {osc_clk_div2}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {osc_clk_div2}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {osc_clk_div2}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {osc_clk_div2}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {osc_clk_div2}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {osc_clk_div2}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {osc_clk_div2}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {osc_clk_div2}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_core_usr_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -rise_to [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}]  0.180  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -fall_to [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}]  0.180  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -rise_to [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}]  0.180  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -fall_to [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}]  0.180  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -rise_to [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}]  0.180  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -fall_to [get_clocks {ddr4_emif_mem_mem_dqs[0]_IN}]  0.180  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -rise_to [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}]  0.180  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -fall_to [get_clocks {ddr4_emif_mem_mem_dqs[1]_IN}]  0.180  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_vco_clk_1}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_0}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_1}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_2}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_3}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_3}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_3}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_3}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_3}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_3}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_3}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_3}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_4}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.330  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}] -rise_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}] -fall_to [get_clocks {u0|ddr4_emif|emif_fm_0_wf_clk_5}]  0.030  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock_fall -clock [get_clocks {altera_reserved_tck}]  -3.108 [get_ports {altera_reserved_tms}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {altera_reserved_tck}]  -7.162 [get_ports {altera_reserved_tms}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {altera_reserved_tck}]  -4.025 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {altera_reserved_tck}]  -8.079 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_dq[0]} {ddr4_emif_mem_mem_dq[1]} {ddr4_emif_mem_mem_dq[2]} {ddr4_emif_mem_mem_dq[3]} {ddr4_emif_mem_mem_dq[4]} {ddr4_emif_mem_mem_dq[5]} {ddr4_emif_mem_mem_dq[6]} {ddr4_emif_mem_mem_dq[7]} {ddr4_emif_mem_mem_dq[8]} {ddr4_emif_mem_mem_dq[9]} {ddr4_emif_mem_mem_dq[10]} {ddr4_emif_mem_mem_dq[11]} {ddr4_emif_mem_mem_dq[12]} {ddr4_emif_mem_mem_dq[13]} {ddr4_emif_mem_mem_dq[14]} {ddr4_emif_mem_mem_dq[15]}}]
set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_dbi_n[0]} {ddr4_emif_mem_mem_dbi_n[1]}}]
set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {ddr4_emif_mem_mem_alert_n[0]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock_fall -clock [get_clocks {altera_reserved_tck}]  44.688 [get_ports {altera_reserved_tdo}]
set_output_delay -add_delay -min -clock_fall -clock [get_clocks {altera_reserved_tck}]  36.454 [get_ports {altera_reserved_tdo}]
set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_a[0]} {ddr4_emif_mem_mem_a[1]} {ddr4_emif_mem_mem_a[2]} {ddr4_emif_mem_mem_a[3]} {ddr4_emif_mem_mem_a[4]} {ddr4_emif_mem_mem_a[5]} {ddr4_emif_mem_mem_a[6]} {ddr4_emif_mem_mem_a[7]} {ddr4_emif_mem_mem_a[8]} {ddr4_emif_mem_mem_a[9]} {ddr4_emif_mem_mem_a[10]} {ddr4_emif_mem_mem_a[11]} {ddr4_emif_mem_mem_a[12]} {ddr4_emif_mem_mem_a[13]} {ddr4_emif_mem_mem_a[14]} {ddr4_emif_mem_mem_a[15]} {ddr4_emif_mem_mem_a[16]} {ddr4_emif_mem_mem_act_n[0]} {ddr4_emif_mem_mem_ba[0]} {ddr4_emif_mem_mem_ba[1]} {ddr4_emif_mem_mem_bg[0]} {ddr4_emif_mem_mem_bg[1]} {ddr4_emif_mem_mem_cke[0]} {ddr4_emif_mem_mem_cs_n[0]} {ddr4_emif_mem_mem_odt[0]} {ddr4_emif_mem_mem_par[0]}}]
set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_dq[0]} {ddr4_emif_mem_mem_dq[1]} {ddr4_emif_mem_mem_dq[2]} {ddr4_emif_mem_mem_dq[3]} {ddr4_emif_mem_mem_dq[4]} {ddr4_emif_mem_mem_dq[5]} {ddr4_emif_mem_mem_dq[6]} {ddr4_emif_mem_mem_dq[7]} {ddr4_emif_mem_mem_dq[8]} {ddr4_emif_mem_mem_dq[9]} {ddr4_emif_mem_mem_dq[10]} {ddr4_emif_mem_mem_dq[11]} {ddr4_emif_mem_mem_dq[12]} {ddr4_emif_mem_mem_dq[13]} {ddr4_emif_mem_mem_dq[14]} {ddr4_emif_mem_mem_dq[15]}}]
set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_dbi_n[0]} {ddr4_emif_mem_mem_dbi_n[1]}}]
set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_dqs[0]} {ddr4_emif_mem_mem_dqs[1]}}]
set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_dqs_n[0]} {ddr4_emif_mem_mem_dqs_n[1]}}]
set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_ck[0]}}]
set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {{ddr4_emif_mem_mem_ck_n[0]}}]
set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_emif|emif_fm_0_ref_clock}]  0.000 [get_ports {ddr4_emif_mem_mem_reset_n[0]}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {internal_clk}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_registers {*|alt_jtag_atlantic:*|jupdate}] -to [get_registers {*|alt_jtag_atlantic:*|jupdate1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rdata[*]}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read}] -to [get_registers {*|alt_jtag_atlantic:*|read1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_req}] 
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rvalid}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|tck_t_dav}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|user_saw_rvalid}] -to [get_registers {*|alt_jtag_atlantic:*|rvalid0*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|wdata[*]}] -to [get_registers *]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write}] -to [get_registers {*|alt_jtag_atlantic:*|write1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_ena*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_pause*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_valid}] 
set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -from [get_ports {altera_reserved_tdi}] -to [get_ports {altera_reserved_tdo}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_req_sync_in_rst|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_req_sync_out_rst|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -to [get_keepers {{ddr4_emif_mem_mem_a[0]} {ddr4_emif_mem_mem_a[1]} {ddr4_emif_mem_mem_a[2]} {ddr4_emif_mem_mem_a[3]} {ddr4_emif_mem_mem_a[4]} {ddr4_emif_mem_mem_a[5]} {ddr4_emif_mem_mem_a[6]} {ddr4_emif_mem_mem_a[7]} {ddr4_emif_mem_mem_a[8]} {ddr4_emif_mem_mem_a[9]} {ddr4_emif_mem_mem_a[10]} {ddr4_emif_mem_mem_a[11]} {ddr4_emif_mem_mem_a[12]} {ddr4_emif_mem_mem_a[13]} {ddr4_emif_mem_mem_a[14]} {ddr4_emif_mem_mem_a[15]} {ddr4_emif_mem_mem_a[16]} {ddr4_emif_mem_mem_act_n[0]} {ddr4_emif_mem_mem_ba[0]} {ddr4_emif_mem_mem_ba[1]} {ddr4_emif_mem_mem_bg[0]} {ddr4_emif_mem_mem_bg[1]} {ddr4_emif_mem_mem_cke[0]} {ddr4_emif_mem_mem_cs_n[0]} {ddr4_emif_mem_mem_odt[0]} {ddr4_emif_mem_mem_par[0]}}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|non_hps.core_clks_rsts_inst|local_reset_req_sync_gen_master.local_reset_req_sync_inst|din_s1|d u0|ddr4_emif|emif_fm_0|arch|arch_inst|non_hps.core_clks_rsts_inst|local_reset_req_sync_gen_master.local_reset_req_sync_inst|din_s1|*data}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|non_hps.core_clks_rsts_inst|local_reset_req_sync_gen_master.local_reset_req_sync_inst|din_s1}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|non_hps.core_clks_rsts_inst|*reset_sync*|clrn}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|non_hps.core_clks_rsts_inst|*reset_sync*}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.seq2core_reset_done_sync_inst|din_s1|d u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.seq2core_reset_done_sync_inst|din_s1|*data}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.seq2core_reset_done_sync_inst|din_s1}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.seq2core_ac_parity_sync_inst|din_s1|d u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.seq2core_ac_parity_sync_inst|din_s1|*data}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.seq2core_ac_parity_sync_inst|din_s1}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_in_progress_sync_inst|din_s1|d u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_in_progress_sync_inst|din_s1|*data}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_in_progress_sync_inst|din_s1}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_success_sync_inst|din_s1|d u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_success_sync_inst|din_s1|*data}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_success_sync_inst|din_s1}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_fail_sync_inst|din_s1|d u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_fail_sync_inst|din_s1|*data}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|seq_if_inst|non_hps.afi_cal_fail_sync_inst|din_s1}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|cal_counter_inst|non_hps.inst_sync_reset_n|din_s1|d u0|ddr4_emif|emif_fm_0|arch|arch_inst|cal_counter_inst|non_hps.inst_sync_reset_n|din_s1|*data}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|cal_counter_inst|non_hps.inst_sync_reset_n|din_s1}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|cal_counter_inst|non_hps.inst_sync_cal_in_progress|din_s1|d u0|ddr4_emif|emif_fm_0|arch|arch_inst|cal_counter_inst|non_hps.inst_sync_cal_in_progress|din_s1|*data}]  -to [get_registers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|cal_counter_inst|non_hps.inst_sync_cal_in_progress|din_s1}]
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_ck.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[1].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[2].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[3].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[4].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[5].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[6].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[7].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[8].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[9].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[10].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[11].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[12].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[13].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[14].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[15].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[16].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_act_n.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_ba.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_ba.inst[1].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_bg.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_bg.inst[1].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_cke.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_cs_n.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_odt.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_par.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_reset_n.inst[0].b|no_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_ck.inst[0].b|cal_oct.obuf_bar|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dqs.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dqs.inst[1].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[1].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[2].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[3].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[4].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[5].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[6].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[7].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[8].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[9].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[10].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[11].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[12].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[13].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[14].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[15].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dbi_n.inst[0].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dbi_n.inst[1].b|cal_oct.obuf|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dqs.inst[0].b|cal_oct.obuf_bar|oe}]  
set_false_path -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dqs.inst[1].b|cal_oct.obuf_bar|oe}]  
set_false_path -to [get_keepers {{ddr4_emif_mem_mem_dq[0]} {ddr4_emif_mem_mem_dq[1]} {ddr4_emif_mem_mem_dq[2]} {ddr4_emif_mem_mem_dq[3]} {ddr4_emif_mem_mem_dq[4]} {ddr4_emif_mem_mem_dq[5]} {ddr4_emif_mem_mem_dq[6]} {ddr4_emif_mem_mem_dq[7]} {ddr4_emif_mem_mem_dq[8]} {ddr4_emif_mem_mem_dq[9]} {ddr4_emif_mem_mem_dq[10]} {ddr4_emif_mem_mem_dq[11]} {ddr4_emif_mem_mem_dq[12]} {ddr4_emif_mem_mem_dq[13]} {ddr4_emif_mem_mem_dq[14]} {ddr4_emif_mem_mem_dq[15]}}]
set_false_path -from [get_keepers {{ddr4_emif_mem_mem_dq[0]} {ddr4_emif_mem_mem_dq[1]} {ddr4_emif_mem_mem_dq[2]} {ddr4_emif_mem_mem_dq[3]} {ddr4_emif_mem_mem_dq[4]} {ddr4_emif_mem_mem_dq[5]} {ddr4_emif_mem_mem_dq[6]} {ddr4_emif_mem_mem_dq[7]} {ddr4_emif_mem_mem_dq[8]} {ddr4_emif_mem_mem_dq[9]} {ddr4_emif_mem_mem_dq[10]} {ddr4_emif_mem_mem_dq[11]} {ddr4_emif_mem_mem_dq[12]} {ddr4_emif_mem_mem_dq[13]} {ddr4_emif_mem_mem_dq[14]} {ddr4_emif_mem_mem_dq[15]}}] 
set_false_path -to [get_keepers {{ddr4_emif_mem_mem_dbi_n[0]} {ddr4_emif_mem_mem_dbi_n[1]}}]
set_false_path -from [get_keepers {{ddr4_emif_mem_mem_dbi_n[0]} {ddr4_emif_mem_mem_dbi_n[1]}}] 
set_false_path -to [get_keepers {{ddr4_emif_mem_mem_dqs[0]} {ddr4_emif_mem_mem_dqs[1]}}]
set_false_path -to [get_keepers {{ddr4_emif_mem_mem_dqs_n[0]} {ddr4_emif_mem_mem_dqs_n[1]}}]
set_false_path -from [get_keepers {{ddr4_emif_mem_mem_dqs[0]} {ddr4_emif_mem_mem_dqs[1]}}] 
set_false_path -from [get_keepers {{ddr4_emif_mem_mem_dqs_n[0]} {ddr4_emif_mem_mem_dqs_n[1]}}] 
set_false_path -to [get_keepers {{ddr4_emif_mem_mem_ck[0]}}]
set_false_path -to [get_keepers {{ddr4_emif_mem_mem_ck_n[0]}}]
set_false_path -to [get_keepers {{ddr4_emif_mem_mem_reset_n[0]} {ddr4_emif_mem_mem_alert_n[0]}}]
set_false_path -from [get_keepers {{ddr4_emif_mem_mem_reset_n[0]} {ddr4_emif_mem_mem_alert_n[0]}}] 
set_false_path -from [get_registers {*altera_jtag_src_crosser:*|sink_data_buffer*}] -to [get_registers {*altera_jtag_src_crosser:*|src_data*}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]


#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from [get_keepers {*reset*}] -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].tile_ctrl_inst|afi_core2ctl[6]}]  -to [get_keepers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].tile_ctrl_inst~hmc_reg0}] 3
set_multicycle_path -hold -end -from [get_keepers {*reset*}] -through [get_pins {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].tile_ctrl_inst|afi_core2ctl[6]}]  -to [get_keepers {u0|ddr4_emif|emif_fm_0|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].tile_ctrl_inst~hmc_reg0}] 2


#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_registers {*alt_hiconnect_clock_crosser:*|in_data_buffer*}] -to [get_registers {*alt_hiconnect_clock_crosser:*|out_data_buffer*}] 100.000 
set_max_delay -from [get_registers {*alt_hiconnect_clock_crosser:*}] -to [get_registers {*alt_hiconnect_clock_crosser:*|altera_std_synchronizer:*|din_s1}] 100.000 


#**************************************************************
# Set Minimum Delay
#**************************************************************

set_min_delay -from [get_registers {*alt_hiconnect_clock_crosser:*|in_data_buffer*}] -to [get_registers {*alt_hiconnect_clock_crosser:*|out_data_buffer*}] -100.000
set_min_delay -from [get_registers {*alt_hiconnect_clock_crosser:*}] -to [get_registers {*alt_hiconnect_clock_crosser:*|altera_std_synchronizer:*|din_s1}] -100.000


#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Net Delay
#**************************************************************

set_net_delay -max -value_multiplier 0.800 -get_value_from_clock_period dst_clock_period -from [get_registers {u0|mm_interconnect_0|crosser|clock_xer|in_data_buffer*}] -to [get_registers {u0|mm_interconnect_0|crosser|clock_xer|out_data_buffer*}]
set_net_delay -max -value_multiplier 0.800 -get_value_from_clock_period dst_clock_period -from [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|in_data_buffer*}] -to [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|out_data_buffer*}]
set_net_delay -max -value_multiplier 0.800 -get_value_from_clock_period dst_clock_period -from [get_registers {u0|mm_interconnect_0|crosser|clock_xer|in_data_toggle}] -to [get_registers {u0|mm_interconnect_0|crosser|clock_xer|in_to_out_synchronizer|din_s1}]
set_net_delay -max -value_multiplier 0.800 -get_value_from_clock_period dst_clock_period -from [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|in_data_toggle}] -to [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|in_to_out_synchronizer|din_s1}]
set_net_delay -max -value_multiplier 0.800 -get_value_from_clock_period dst_clock_period -from [get_registers {u0|mm_interconnect_0|crosser|clock_xer|out_data_toggle_flopped_n}] -to [get_registers {u0|mm_interconnect_0|crosser|clock_xer|out_to_in_synchronizer|din_s1}]
set_net_delay -max -value_multiplier 0.800 -get_value_from_clock_period dst_clock_period -from [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|out_data_toggle_flopped_n}] -to [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|out_to_in_synchronizer|din_s1}]


#**************************************************************
# Set Max Skew
#**************************************************************

set_max_skew -from [get_registers {u0|mm_interconnect_0|crosser|clock_xer|in_data_buffer*}] -to [get_registers {u0|mm_interconnect_0|crosser|clock_xer|out_data_buffer*}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 -nowarn
set_max_skew -from [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|in_data_buffer*}] -to [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|out_data_buffer*}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 -nowarn
set_max_skew -from [get_registers {u0|mm_interconnect_0|crosser|clock_xer|in_data_toggle}] -to [get_registers {u0|mm_interconnect_0|crosser|clock_xer|in_to_out_synchronizer|din_s1}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 -nowarn
set_max_skew -from [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|in_data_toggle}] -to [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|in_to_out_synchronizer|din_s1}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 -nowarn
set_max_skew -from [get_registers {u0|mm_interconnect_0|crosser|clock_xer|out_data_toggle_flopped_n}] -to [get_registers {u0|mm_interconnect_0|crosser|clock_xer|out_to_in_synchronizer|din_s1}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 -nowarn
set_max_skew -from [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|out_data_toggle_flopped_n}] -to [get_registers {u0|mm_interconnect_0|crosser_001|clock_xer|out_to_in_synchronizer|din_s1}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.800 -nowarn


#**************************************************************
# Set Disable Timing
#**************************************************************

set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_ck.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[1].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[2].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[3].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[4].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[5].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[6].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[7].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[8].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[9].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[10].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[11].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[12].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[13].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[14].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[15].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_a.inst[16].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_act_n.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_ba.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_ba.inst[1].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_bg.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_bg.inst[1].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_cke.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_cs_n.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_odt.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_par.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_reset_n.inst[0].b|no_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_ck.inst[0].b|cal_oct.obuf_bar}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dqs.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dqs.inst[1].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[1].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[2].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[3].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[4].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[5].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[6].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[7].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[8].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[9].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[10].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[11].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[12].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[13].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[14].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dq.inst[15].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dbi_n.inst[0].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dbi_n.inst[1].b|cal_oct.obuf}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dqs.inst[0].b|cal_oct.obuf_bar}]
set_disable_timing -from oe -to o [get_cells {u0|ddr4_emif|emif_fm_0|arch|arch_inst|bufs_inst|gen_mem_dqs.inst[1].b|cal_oct.obuf_bar}]
