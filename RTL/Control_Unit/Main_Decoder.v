`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2025 21:20:23
// Design Name: 
// Module Name: Main_Decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Main_Decoder(
    input  [1:0] Op,
    input  [5:0] Funct,
    output       RegW, MemW,
    output       MemtoReg, ALUSrc,
    output [1:0] ImmSrc, RegSrc,
    output      Branch, ALUOp
    );
    reg [9:0] controls;

  // Main Decoder
  
  always @(*) begin
  	casex(Op)
  	                        
  	  2'b00:   // Data-Processing Instructions
		   if (Funct[5]) //immediate=1
		      controls = 10'b0000101001; 
  	           else      //immediate=0
		      controls = 10'b0000001001; // Data processing register
  	  2'b01:   // Memory Instructions
		   if (Funct[0])
		      controls = 10'b0001111000; // LDR
  	           else
		   begin
		      if (Funct[2])
		         controls = 10'b1001110100; // STRB
		      else
		         controls = 10'b1001110100; // STR
		   end
  	  2'b10:   // Branch Instructions
		   controls = 10'b0110100010; // B
  	  default: // Unimplemented
		   controls = 10'b0;
  	endcase
  end
  assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, 
          RegW, MemW, Branch, ALUOp} = controls; 
endmodule
