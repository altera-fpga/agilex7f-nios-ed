// Copyright (C) 2022 Intel Corporation
//
// This software and the related documents are Intel copyrighted materials, and
// your use of them is governed by the express license under which they were
// provided to you ("License"). Unless the License provides otherwise, you may
// not use, modify, copy, publish, distribute, disclose or transmit this
// software or the related documents without Intel's prior written permission.
//
// This software and the related documents are provided as is, with no express
// or implied warranties, other than those that are expressly stated in the
// License.
//
// ----------------------------------------------------------------------------
// File: top.v
// ----------------------------------------------------------------------------
//
// Top level module which allows for Power-on reset and ISSP.

module top
(
      input            clk_50m_fpga,
      output           eneta_mdc,
      inout            eneta_mdio,
      input            clk_enet_fpga_p,
      input            eneta_rx_p,
      output           eneta_tx_p,
      output           eneta_intn,
      output           eneta_resetn,
      output[3:0]      user_led
);


// reset wire which takes into account Power-on reset and the ISSP.
wire por_reset;
wire issp_reset_wire;
wire reset;
assign reset = issp_reset_wire | por_reset;

// Power-on reset.
power_on_reset por_inst (
    .clk   (clk_50m_fpga),
    .reset (por_reset)
);

// ISSP virtual reset button - tied into the eneta_resetn wire.
altsource_probe #(
        .probe_width(1),
        .source_width(1),
        .source_initial_value("0")
) issp_inst (
    .source(issp_reset_wire),
    .probe(reset)
);

// Ethernet interface assignments
wire   mdio_in;
wire   mdio_oen;
wire   mdio_out;

assign mdio_in    = eneta_mdio;
assign eneta_mdio = mdio_oen == 0 ? mdio_out : 1'bz;

assign eneta_resetn = ~reset;

sys u0 (
    .in_clk_clk                                 (clk_50m_fpga),
    .in_125m_clk_clk                            (clk_enet_fpga_p),
    .in_rst_reset                               (reset),
    .led_pio_external_connection_export         (user_led),
    .eth_tse_serial_connection_txp              (eneta_tx_p),
    .eth_tse_serial_connection_rxp              (eneta_rx_p),
    .eth_tse_mac_mdio_connection_mdc            (eneta_mdc),
    .eth_tse_mac_mdio_connection_mdio_in        (mdio_in),
    .eth_tse_mac_mdio_connection_mdio_out       (mdio_out),
    .eth_tse_mac_mdio_connection_mdio_oen       (mdio_oen),
    .eth_tse_status_led_connection_crs          (),
    .eth_tse_status_led_connection_link         (),
    .eth_tse_status_led_connection_col          (),
    .eth_tse_status_led_connection_an           (),
    .eth_tse_status_led_connection_char_err     (),
    .eth_tse_status_led_connection_disp_err     (),
    .xcvr_atx_pll_pll_locked_pll_locked         (),
    .xcvr_atx_pll_pll_cal_busy_pll_cal_busy     ()
);

endmodule


module power_on_reset #(
    parameter POR_COUNT = 20 // MUST BE 2 or greater
) (
    input wire clk,
    output wire reset
);

wire sync_dout;
altera_std_synchronizer #(
    .depth (POR_COUNT)
) power_on_reset_std_sync_inst (
    .clk (clk),
    .reset_n (1'b1),
    .din (1'b1),
    .dout (sync_dout)
);

reg output_reg;
initial begin
    output_reg <= 1'b0;
end

always @ (posedge clk) begin
    output_reg <= sync_dout;
end


assign reset = ~output_reg;

endmodule
