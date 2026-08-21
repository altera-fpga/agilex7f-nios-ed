//----------------------------------------------------------------------------------------------------------
// Copyright (C) 2015-2022 Intel Corporation
// 
// This code and the related documents are Intel copyrighted materials, and 
// your use of them is governed by the express license under which they were 
// provided to you ("License"). Unless the License provides otherwise, you may 
// not use, modify, copy, publish, distribute, disclose or transmit this 
// code or the related documents without Intel's prior written permission.
//
// This code and the related documents are provided as is, with no express 
// or implied warranties, other than those that are expressly stated in the 
// License.
//
//----------------------------------------------------------------------------------------------------------

module hyper_pipe #(
	parameter DWIDTH = 1,
	parameter NUM_PIPES = 1)
(
input clk,
input [DWIDTH-1:0] din,
output [DWIDTH-1:0] dout);

reg [DWIDTH-1:0] hp [NUM_PIPES-1:0];

genvar i;
generate
	if (NUM_PIPES == 0) begin
		assign dout = din;
	end
	else begin
		always @ (posedge clk) 
			hp[0] <= din;
		for (i=1;i < NUM_PIPES;i++) begin : hregs
			always @ ( posedge clk) begin
					hp[i] <= hp[i-1];
			end
		end
		assign dout = hp[NUM_PIPES-1];
	end
		

endgenerate

endmodule













