module quartus_ag(
	input wire	fpga_clk_100,
	input wire	fpga_reset_reset
);

    qsys_ag u0 (
        .clk_clk       (fpga_clk_100),       //   input,  width = 1,   clk.clk
        .reset_reset_n (fpga_reset_reset)  //   input,  width = 1, reset.reset_n
    );
endmodule