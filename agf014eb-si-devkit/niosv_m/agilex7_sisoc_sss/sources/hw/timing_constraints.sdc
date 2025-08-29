# Copyright (C) 2022 Intel Corporation
#
# This software and the related documents are Intel copyrighted materials, and
# your use of them is governed by the express license under which they were
# provided to you ("License"). Unless the License provides otherwise, you may
# not use, modify, copy, publish, distribute, disclose or transmit this
# software or the related documents without Intel's prior written permission.
#
# This software and the related documents are provided as is, with no express
# or implied warranties, other than those that are expressly stated in the
# License.
#
# ----------------------------------------------------------------------------
# File: timing_constraints.sdc
# ----------------------------------------------------------------------------

derive_pll_clocks
derive_clock_uncertainty

create_clock -name {clk_50m_fpga} -period 20.000 {clk_50m_fpga}
create_clock -name {clk_enet_fpga_p} -period 8.000 {clk_enet_fpga_p}

set_input_delay   -clock [ get_clocks clk_50m_fpga ] 2   [ get_ports {eneta_mdio} ]
set_output_delay  -clock [ get_clocks clk_50m_fpga ] 2   [ get_ports {eneta_mdio} ]
set_output_delay  -clock [ get_clocks clk_50m_fpga ] 2   [ get_ports {eneta_mdc} ]
set_output_delay  -clock [ get_clocks clk_50m_fpga ] 2   [ get_ports {eneta_resetn} ]
