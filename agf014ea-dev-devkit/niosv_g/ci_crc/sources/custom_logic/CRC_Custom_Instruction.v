/*
  Legal Notice: (C)2006 Altera Corporation. All rights reserved.  Your
  use of Altera Corporation's design tools, logic functions and other
  software and tools, and its AMPP partner logic functions, and any
  output files any of the foregoing (including device programming or
  simulation files), and any associated documentation or information are
  expressly subject to the terms and conditions of the Altera Program
  License Subscription Agreement or other applicable license agreement,
  including, without limitation, that your use is for the sole purpose
  of programming logic devices manufactured by Altera and sold by Altera
  or its authorized distributors.  Please refer to the applicable
  agreement for further details.
*/

/* 
  This thin wrapper re-uses the CRC Avalon component as a Nios V
  custom instruction. The funct3 port of custom instruction is used as
  control to the Avalon CRC component. Below are the values of funct3 and
  the corresponding operations perform by the custom instruction:
  funct3 = 0, Initialize the custom instruction to the initial remainder value
  funct3 = 1, Write  8 bits data to custom instruction
  funct3 = 2, Write 16 bits data to custom instruction
  funct3 = 3, Write 32 bits data to custom instruction
  funct3 = 4, Read  32 bits data from the custom instruction
  funct3 = 5, Read  64 bits data from the custom instruction
  funct3 = 6, Read  96 bits data from the custom instruction
  funct3 = 7, Read 128 bits data from the custom instruction 
*/



module CRC_Custom_Instruction(	clk,
								reset,
								data0,
								data1,
								enable,
								done,
								result,
								alu_result,
								ctrl);
								
  /*
    See the Avalon CRC component for details on the meaning of each
    parameter listed below.
  */
  parameter crc_width = 32;
  parameter polynomial_inital = 32'hFFFFFFFF;
  parameter polynomial = 32'h04C11DB7;
  parameter reflected_input = 1;
  parameter reflected_output = 1;
  parameter xor_output = 32'hFFFFFFFF;

  input clk;
  input reset;
  input [31:0] data0;  
  input [31:0] data1;  
  input [31:0] alu_result;     
  input [31:0] ctrl;  
  input enable;
  output done;
  output [31:0] result;
  
  wire [2:0] funct3;
  assign funct3 = ctrl[14:12];

  wire [2:0] address;
  wire [3:0] byteenable;
  wire write;
  wire read;
  reg done_delay;

  assign write = (funct3<4);
  assign read = (funct3>3);
  assign byteenable = (funct3==1)?4'b0001 : (funct3==2)?4'b0011 : (funct3==3)?4'b1111 : 4'b0000;
  assign address = (funct3==0)?3'b000 : ((funct3==1)|(funct3==2)|(funct3==3))?3'b001 : (funct3==4)?3'b100 : (funct3==5)?3'b101 : (funct3==6)?3'b110 : 3'b11;
  assign done = done_delay;

  always @ (posedge clk or posedge reset)
  begin
  if (reset)
		done_delay <= 0;
  else
		done_delay <= enable;
  end

  /* 
    Instantiating the Avalon CRC component and wiring it to be
    custom instruction compilant
  */
  CRC_Component wrapper_wiring(.clk(clk),
                               .reset(reset),
                               .address(address),
                               .writedata(data0),
                               .byteenable(byteenable),
                               .write(write & enable),
                               .read(read),
                               .chipselect(1),
                               .readdata(result));

  defparam wrapper_wiring.crc_width = crc_width;
  defparam wrapper_wiring.polynomial_inital = polynomial_inital;
  defparam wrapper_wiring.polynomial = polynomial;
  defparam wrapper_wiring.reflected_input = reflected_input;
  defparam wrapper_wiring.reflected_output = reflected_output;
  defparam wrapper_wiring.xor_output = xor_output;

endmodule
