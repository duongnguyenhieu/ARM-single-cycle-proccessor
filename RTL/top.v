`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: top
// Description: Top level module k?t n?i Datapath và Control Unit
//              ?ã l??c b? các output debug ?? t?i ?u cho vi?c n?p FPGA
//////////////////////////////////////////////////////////////////////////////////

module top (
    input  clk,
    input  reset,
    output [31:0] pc_out // Các chân I/O th?c t? (n?u có) s? thêm ? ?ây, ví d?: output [7:0] led
);

    // --- Internal wires connecting Control <-> Datapath ---
    wire        PCSrc;
    wire        MemtoReg;
    wire        MemWrite;
    wire [1:0]  ALUControl;
    wire [1:0]  ImmSrc;
    wire        RegWrite;
    wire        ALUSrc;
    wire [1:0]  RegSrc;

    // Datapath internal signals
    wire [31:0] Instr;
    wire [31:0] PC;
    wire [31:0] ALUResult;
    wire [31:0] WriteData;
    wire [31:0] ReadData;
    wire [31:0] SrcA, SrcB, ExtImm;
    wire [31:0] RD1, RD2;
    wire N, Z, C, V;

    // Instruction fields derived from Instr
    wire [3:0]  Cond;
    wire [1:0]  Op;
    wire [5:0]  Funct;
    wire [3:0]  Rd;

    // --- Instantiate Datapath ---
    Datapath datapath_inst (
        .clk(clk),
        .reset(reset),
        .PCSrc(PCSrc),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .RegSrc(RegSrc),

        .Instr(Instr),
        .N(N), .Z(Z), .C(C), .V(V),

        // Các tín hi?u n?i b? v?n k?t n?i vào wire ?? dùng cho ILA sau này
        .PC(PC),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ExtImm(ExtImm),
        .RD1(RD1),
        .RD2(RD2)
    );

    // --- Decode instruction fields to feed Control_Unit ---
    assign Cond  = Instr[31:28];
    assign Op    = Instr[27:26];
    assign Funct = { Instr[25], Instr[24:21], Instr[20] }; // {I, CMD[3:0], S}
    assign Rd    = Instr[15:12];

    // --- Instantiate Control Unit ---
    Control_Unit control_inst (
        .clk(clk),
        .reset(reset),
        .Rd(Rd),
        .Op(Op),
        .Funct(Funct),
        .Cond(Cond),
        .N(N), .Z(Z), .C(C), .V(V),
        .PCSrc(PCSrc),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .RegSrc(RegSrc)
    );
    assign pc_out = PC;

endmodule
