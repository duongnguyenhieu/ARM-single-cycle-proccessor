`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2025 11:13:25
// Design Name: 
// Module Name: Datapath
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


module Datapath(
    input         clk,
    input         PCSrc,
    input         MemtoReg,
    input         MemWrite,
    input  [1:0]  ALUControl,
    input  [1:0]  ImmSrc,
    input         RegWrite,
    input  [1:0]  RegSrc,

    output [31:0] Instr,
    output        N, Z, C, V
);

    // INTERNAL WIRES
    wire [31:0] PC, PCNext, PCPlus4, PCPlus8;
    wire [31:0] Result, ALUResult, WriteData;
    wire [31:0] ReadData;
    wire [31:0] SrcA, SrcB;
    wire [31:0] ExtImm;

    wire [31:0] RD; // instruction
    wire [3:0] RA1, RA2;

    //Thanh ghi Program counter
    reg [31:0] PCReg = 0;
    assign PC = PCReg;

    always @(posedge clk) begin
        PCReg <= PCNext;
    end

    assign PCPlus4 = PC + 32'd4;
    assign PCPlus8 = PC + 32'd8;   // ARM pipeline (trong single cycle thì sẽ chậm 1 nhịp để có thời gian đi vào)


    Instruction_Memory imem(
        .A(PC),
        .RD(RD)
    );

    assign Instr = RD;

    mux #(.N(4)) muxA (
        .a(RD[19:16]),
        .b(4'b1111),       //Chọn thanh ghi PC làm Rn cho một số lệnh
        .sel(RegSrc[0]),
        .y(RA1)
    );

    mux #(.N(4)) muxB (
        .a(RD[3:0]),
        .b(RD[15:12]),
        .sel(RegSrc[1]),
        .y(RA2)
    );

    wire [31:0] RD2;

    Register_file rf (
        .clk(clk),
        .WE3(RegWrite),
        .A1(RA1),         // Rn
        .A2(RA2),         // Rm or Rd
        .A3(RD[15:12]),   // Rd (destination)
        .R15(PCPlus8),    
        .WD3(Result),     
        .RD1(SrcA),       
        .RD2(RD2)         
    );

    assign WriteData = RD2;

    Extender ext (
        .Instr(RD[23:0]),
        .ImmSrc(ImmSrc),
        .ExtImm(ExtImm)
    );

    mux #(.N(32)) muxSrcB (
        .a(RD2),
        .b(ExtImm),
        .sel(ImmSrc[0]),   
        .y(SrcB)
    );

    alu ALU (
        .A(SrcA),
        .B(SrcB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );

    data_mem dmem (
        .clk(clk),
        .WE(MemWrite),
        .A(ALUResult),
        .WD(WriteData),
        .ReadData(ReadData)
    );

    mux #(.N(32)) muxResult (
        .a(ALUResult),
        .b(ReadData),
        .sel(MemtoReg),
        .y(Result)
    );

    mux #(.N(32)) muxPC (
        .a(PCPlus4),
        .b(Result),        
        .sel(PCSrc),
        .y(PCNext)
    );

endmodule
