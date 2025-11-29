`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2025 21:19:09
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
   input clk,
   input [3:0]Rd,
   input  [1:0] Op,
   input  [5:0] Funct,
   input  [3:0] Cond,
   input  N, Z, C, V,
   output         PCSrc,
   output         MemtoReg,
   output         MemWrite,
   output  [1:0]  ALUControl,
   output  [1:0]  ImmSrc,
   output         RegWrite,
   output  [1:0]  RegSrc
    );
    //Internal
    wire PCS;
    wire RegW;
    wire MemW;
    wire CondEx;
    wire [1:0] FlagW;
    wire [1:0] FlagWrite;
    reg N_reg, Z_reg, C_reg, V_reg;
    
    //Combinational
    assign FlagWrite = FlagW & {CondEx, CondEx};
   assign PCSrc = PCS & CondEx;
   assign RegWrite = RegW & CondEx;
   assign MemWrite = MemW & CondEx;
    
    //Sequential
    always @(posedge clk) begin
        // Write N,Z
        if (FlagWrite[1]) begin
            N_reg <= N;
            Z_reg <= Z;
        end
        // Write C,V
        if (FlagWrite[0]) begin
            C_reg <= C;
            V_reg <= V;
        end
    end
    
    Decoder decoder(
        .Rd(Rd),
        .Op(Op),
        .Funct(Funct),
        .PCS(PCS),
        .RegW(RegW),
        .MemW(MemW),
        .MemtoReg(MemtoReg),
        .AluSr(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegSrc(RegSrc),
        .ALUControl(ALUControl),
        .FlagW(FlagW)
    );
    
    Condition_Check cond_check(
        .Cond(Cond),
        .N(N), .Z(Z), .C(C), .V(V),
        .CondEx(CondEx)
    );
    
endmodule
