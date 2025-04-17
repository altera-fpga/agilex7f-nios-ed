// (C) 2001-2025 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


module quartus_ag(
	input wire	fpga_clk_100,
	input wire	fpga_reset_reset
);

    qsys_ag u0 (
        .clk_clk       (fpga_clk_100),       //   input,  width = 1,   clk.clk
        .reset_reset_n (fpga_reset_reset)  //   input,  width = 1, reset.reset_n
    );
endmodule