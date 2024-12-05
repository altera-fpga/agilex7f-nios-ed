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


# Copyright (C) 2001-2022 Intel Corporation 
#
# This code and the related documents are Intel copyrighted materials, and
# your use of them is governed by the express license under which they were
# provided to you ("License"). Unless the License provides otherwise, you may
# not use, modify, copy, publish, distribute, disclose or transmit this
# code or the related documents without Intel's prior written permission
#
# This code and the related documents are provided as is, with no express
# or implied warranties, other than those that are expressly stated in the
# License.
#
# Revision    Date         Quartus version      Comment 
# ========    ====         ===============      =======
# 1.0         28-Jul-20    20.2                 Initial release
# 

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************
create_clock -name "REF_CLK" -period "125 MHz" [get_ports "REF_CLK"]
create_clock -name "CLK_100M" -period "100 MHz" [get_ports "CLK_100M"]

#  Each group will be analyzed with its clock domain within the group
set_clock_groups -asynchronous -group "REF_CLK"

#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty

#**************************************************************
# Sourcing JTAG related SDC
#**************************************************************
source ./jtag.sdc

#**************************************************************
# Set False Path
#**************************************************************
set_false_path -from RESET_N
set_false_path -from * -to PHY_RESET_N
set_false_path -from * -to [get_ports LED_*]

# Soft-CDR path and timing is not critical
set_false_path -from RXP

#**************************************************************
# Ethernet MDIO interface
#**************************************************************
set_output_delay  -clock [ get_clocks "REF_CLK" ] 2   [ get_ports {MDC} ]
set_input_delay   -clock [ get_clocks "REF_CLK" ] 2   [ get_ports {MDIO} ]
set_output_delay  -clock [ get_clocks "REF_CLK" ] 2   [ get_ports {MDIO} ]
