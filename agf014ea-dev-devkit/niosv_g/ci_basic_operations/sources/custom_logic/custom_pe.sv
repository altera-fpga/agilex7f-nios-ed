module custom_pe_bsc (
   input clk,
   input reset,

   input [31:0] data0,
   input [31:0] data1,
   input [31:0] alu_result,
   input [31:0] ctrl,
   input        enable,
   output logic [31:0] result,
   output        done
);

   reg instr_pending;
   logic instr_done;
   logic [2:0] instr_f3;

   assign instr_f3 = ctrl[14:12];

   always @(posedge clk, posedge reset) begin
      if(reset)
         instr_pending <= 1'b0;
      else if(enable)
         instr_pending <= 1'b1;
      else if(instr_done)
         instr_pending <= 1'b0;
   end

   
   always @ (posedge clk, posedge reset) begin
      if(reset)
         instr_done <= 1'b0;
      else if(enable)
         instr_done <= 1'b1;
      else 
         instr_done <= 1'b0;
   end

   always @ (*) begin
      case (instr_f3)
         // 1's complement of data0
         3'd0 : result = ~data0;
         // 2's complement of data0
         3'd1 : result = ~data0 + 1'b1;
         // Multiplication of data0 & data1
         3'd2 : result = data0 * data1;
         // Bit Reversal of data0 
         3'd3 : result = {<<{data0}};
         // Byte Reversal of data0
         3'd4 : result = {<<8{data0}};
         // Word Reversal of data0
         3'd5 : result = {<<16{data0}};
         // Lower word merge of data0 & data1
         3'd6 : result = {data0[15:0], data1[15:0]};
         // Higher word merge of data0 & data1
         3'd7 : result = {data0[31:16], data1[31:16]};
      endcase
   end

   assign done = instr_done;

endmodule
