`timescale 1ns/1ps

module Datapath(
    input         clk,
    input         reset,
    input         PCSrc,
    input         MemtoReg,
    input         MemWrite,
    input         ALUSrc,
    input  [1:0]  ALUControl,
    input  [1:0]  ImmSrc,
    input         RegWrite,
    input  [1:0]  RegSrc,

    // Outputs
    output [31:0] Instr,
    output [31:0] PC,
    output [31:0] ALUResult,
    output [31:0] WriteData,
    output [31:0] ReadData,
    output [31:0] SrcA,
    output [31:0] SrcB,
    output [31:0] ExtImm,
    output [31:0] RD1,
    output [31:0] RD2,
    output        N,
    output        Z,
    output        C,
    output        V
);

    // INTERNAL WIRES
    wire [31:0] PCNext, PCPlus4, PCPlus8;
    wire [31:0] Result;
    wire [31:0] RD;
    wire [3:0] RA1, RA2;

    // Program Counter
    reg [31:0] PCReg = 0;
    assign PC = PCReg;

    always @(posedge clk or posedge reset) begin
        if(reset) PCReg<=0;
        else PCReg <= PCNext;
    end

    assign PCPlus4 = PC + 32'd4;
    assign PCPlus8 = PC + 32'd8;

    // Instruction Memory
    Instruction_Memory imem(
        .A(PC),
        .RD(RD)
    );

    assign Instr = RD;

    // Mux for register selection
    mux #(.N(4)) muxA (
        .a(RD[19:16]),
        .b(4'b1111),
        .sel(RegSrc[0]),
        .y(RA1)
    );

    mux #(.N(4)) muxB (
        .a(RD[3:0]),
        .b(RD[15:12]),
        .sel(RegSrc[1]),
        .y(RA2)
    );

    // Register File
    Register_file rf (
        .clk(clk),
        .WE3(RegWrite),
        .A1(RA1),
        .A2(RA2),
        .A3(RD[15:12]),
        .R15(PCPlus8),
        .WD3(Result),
        .RD1(RD1),
        .RD2(RD2)
    );

    assign SrcA = RD1;
    assign WriteData = RD2;

    // Immediate Extender
    Extender ext (
        .Instr(RD[23:0]),
        .ImmSrc(ImmSrc),
        .ExtImm(ExtImm)
    );

    // Mux for ALU B input
    mux #(.N(32)) muxSrcB (
        .a(RD2),
        .b(ExtImm),
        .sel(ALUSrc),
        .y(SrcB)
    );

    // ALU
    alu ALU_inst (
        .A(SrcA),
        .B(SrcB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );

    // Data Memory
    data_mem dmem (
        .clk(clk),
        .WE(MemWrite),
        .A(ALUResult),
        .WD(WriteData),
        .ReadData(ReadData)
    );

    // Mux for writeback
    mux #(.N(32)) muxResult (
        .a(ALUResult),
        .b(ReadData),
        .sel(MemtoReg),
        .y(Result)
    );

    // Mux for PC update
    mux #(.N(32)) muxPC (
        .a(PCPlus4),
        .b(Result),
        .sel(PCSrc),
        .y(PCNext)
    );

endmodule
