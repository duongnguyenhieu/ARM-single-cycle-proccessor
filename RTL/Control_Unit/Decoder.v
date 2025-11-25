`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2025 15:26:32
// Design Name: 
// Module Name: Decoder
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


module Decoder(
  input [3:0] Rd,
  input [1:0] Op,
  input [5:0] Funct,
  output PCS,
  output RegW, MemW, MemtoReg, AluSr,
  output [1:0] ImmSrc,RegSrc,
  output [1:0] ALUControl,FlagW
    );
    //Internal
    wire Branch;
    wire ALUOp;
    
     PC_Logic pc_logic(
     .Rd(Rd),
     .Branch(Branch),
     .RegW(RegW),
     .PCS(PCS)
    );
    
    Main_Decoder main_decoder(
    .Op(Op),
    .Funct(Funct),
    .RegW(RegW),
    .MemW(MemW),
    .MemtoReg(MemtoReg), 
    .ALUSrc(AluSr),
    .ImmSrc(ImmSrc), 
    .RegSrc(RegSrc),
    .Branch(Branch), 
    .ALUOp(ALUOp)
    );
     
     ALU_Decoder alu_decoder(
      .Funct(Funct [4:0]),
      .ALUOp(ALUOp),
      .ALUControl(ALUControl),  
      .FlagW(FlagW)         
);
endmodule
