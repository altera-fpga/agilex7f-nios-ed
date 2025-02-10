module top(
	input wire			 fpga_reset_reset,
	//input wire		 clk_sys_bak_50m_p,
	//input wire		 clk_sys_100m_p,
	input wire			 fpga_clk_100,
	input  wire        ddr4_emif_pll_ref_clk_clk,                
	input  wire        ddr4_emif_oct_oct_rzqin,                   
	output wire        ddr4_emif_mem_mem_ck,                      
	output wire        ddr4_emif_mem_mem_ck_n,                    
	output wire [16:0] ddr4_emif_mem_mem_a,                       
	output wire        ddr4_emif_mem_mem_act_n,                   
	output wire [1:0]  ddr4_emif_mem_mem_ba,                      
	output wire 	    ddr4_emif_mem_mem_bg,                     
	output wire        ddr4_emif_mem_mem_cke,                     
	output wire        ddr4_emif_mem_mem_cs_n,                    
	output wire        ddr4_emif_mem_mem_odt,                     
	output wire        ddr4_emif_mem_mem_reset_n,                 
	output wire        ddr4_emif_mem_mem_par,                    
	input  wire        ddr4_emif_mem_mem_alert_n,                 
	inout  wire [8:0]  ddr4_emif_mem_mem_dqs,                     
	inout  wire [8:0]  ddr4_emif_mem_mem_dqs_n,                  
	inout  wire [71:0] ddr4_emif_mem_mem_dq,                    
	inout  wire [8:0]  ddr4_emif_mem_mem_dbi_n
);

wire  ninit_done;
wire	global_resetn;

reset_release r0 
              (
              .ninit_done (ninit_done)  // ninit_done.ninit_done
              );

assign global_resetn = !ninit_done & fpga_reset_reset;

    ag_qsys u0 (
        .clk_clk                                   (fpga_clk_100),                                   //   input,   width = 1,                       clk.clk
        .emif_fm_0_local_reset_req_local_reset_req (global_resetn), //   input,   width = 1, emif_fm_0_local_reset_req.local_reset_req
        .emif_fm_0_pll_ref_clk_clk                 (ddr4_emif_pll_ref_clk_clk),                 //   input,   width = 1,     emif_fm_0_pll_ref_clk.clk
        .emif_fm_0_oct_oct_rzqin                   (ddr4_emif_oct_oct_rzqin),                   //   input,   width = 1,             emif_fm_0_oct.oct_rzqin
        .emif_fm_0_mem_mem_ck                      (ddr4_emif_mem_mem_ck),                      //  output,   width = 1,             emif_fm_0_mem.mem_ck
        .emif_fm_0_mem_mem_ck_n                    (ddr4_emif_mem_mem_ck_n),                    //  output,   width = 1,                          .mem_ck_n
        .emif_fm_0_mem_mem_a                       (ddr4_emif_mem_mem_a),                       //  output,  width = 17,                          .mem_a
        .emif_fm_0_mem_mem_act_n                   (ddr4_emif_mem_mem_act_n),                   //  output,   width = 1,                          .mem_act_n
        .emif_fm_0_mem_mem_ba                      (ddr4_emif_mem_mem_ba),                      //  output,   width = 2,                          .mem_ba
        .emif_fm_0_mem_mem_bg                      (ddr4_emif_mem_mem_bg),                      //  output,   width = 1,                          .mem_bg
        .emif_fm_0_mem_mem_cke                     (ddr4_emif_mem_mem_cke),                     //  output,   width = 1,                          .mem_cke
        .emif_fm_0_mem_mem_cs_n                    (ddr4_emif_mem_mem_cs_n),                    //  output,   width = 1,                          .mem_cs_n
        .emif_fm_0_mem_mem_odt                     (ddr4_emif_mem_mem_odt),                     //  output,   width = 1,                          .mem_odt
        .emif_fm_0_mem_mem_reset_n                 (ddr4_emif_mem_mem_reset_n),                 //  output,   width = 1,                          .mem_reset_n
        .emif_fm_0_mem_mem_par                     (ddr4_emif_mem_mem_par),                     //  output,   width = 1,                          .mem_par
        .emif_fm_0_mem_mem_alert_n                 (ddr4_emif_mem_mem_alert_n),                 //   input,   width = 1,                          .mem_alert_n
        .emif_fm_0_mem_mem_dqs                     (ddr4_emif_mem_mem_dqs),                     //   inout,   width = 9,                          .mem_dqs
        .emif_fm_0_mem_mem_dqs_n                   (ddr4_emif_mem_mem_dqs_n),                   //   inout,   width = 9,                          .mem_dqs_n
        .emif_fm_0_mem_mem_dq                      (ddr4_emif_mem_mem_dq),                      //   inout,  width = 72,                          .mem_dq
        .emif_fm_0_mem_mem_dbi_n                   (ddr4_emif_mem_mem_dbi_n),                   //   inout,   width = 9,                          .mem_dbi_n
        .reset_reset_n                             (fpga_reset_reset)                              //   input,   width = 1,                     reset.reset_n
    );
endmodule