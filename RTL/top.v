`timescale 1ns/1ps

module top (
    input  clk,

    output [31:0] Instr_out,
    output [31:0] PC_out,
    output [31:0] ALUResult_out,
    output [31:0] WriteData_out,
    output [31:0] ReadData_out,
    output [31:0] SrcA_out,
    output [31:0] SrcB_out,
    output [31:0] ExtImm_out,
    output [31:0] RD1_out,
    output [31:0] RD2_out,

    output        PCSrc_out,
    output        MemtoReg_out,
    output        MemWrite_out,
    output        RegWrite_out,
    output [1:0]  ALUControl_out,
    output [1:0]  ImmSrc_out,
    output [1:0]  RegSrc_out,
    output        N_out,
    output        Z_out,
    output        C_out,
    output        V_out
);

    wire        PCSrc;
    wire        MemtoReg;
    wire        MemWrite;
    wire [1:0]  ALUControl;
    wire [1:0]  ImmSrc;
    wire        RegWrite;
    wire        ALUSrc;
    wire [1:0]  RegSrc;

    wire [31:0] Instr;
    wire [31:0] PC;
    wire [31:0] ALUResult;
    wire [31:0] WriteData;
    wire [31:0] ReadData;
    wire [31:0] SrcA, SrcB, ExtImm;
    wire [31:0] RD1, RD2;
    wire N, Z, C, V;

    wire [3:0]  Cond;
    wire [1:0]  Op;
    wire [5:0]  Funct;
    wire [3:0]  Rd;

    // Datapath
    Datapath datapath_inst (
        .clk(clk),
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

        // Internal signals exposed for debug
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

    assign Cond  = Instr[31:28];
    assign Op    = Instr[27:26];
    assign Funct = { Instr[25], Instr[24:21], Instr[20] }; // {I, CMD[3:0], S}
    assign Rd    = Instr[15:12];

    // Control Unit 
    Control_Unit control_inst (
        .clk(clk),
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

    assign Instr_out      = Instr;
    assign PC_out         = PC;
    assign ALUResult_out  = ALUResult;
    assign WriteData_out  = WriteData;
    assign ReadData_out   = ReadData;
    assign SrcA_out       = SrcA;
    assign SrcB_out       = SrcB;
    assign ExtImm_out     = ExtImm;
    assign RD1_out        = RD1;
    assign RD2_out        = RD2;

    assign PCSrc_out      = PCSrc;
    assign MemtoReg_out   = MemtoReg;
    assign MemWrite_out   = MemWrite;
    assign RegWrite_out   = RegWrite;
    assign ALUControl_out = ALUControl;
    assign ImmSrc_out     = ImmSrc;
    assign RegSrc_out     = RegSrc;
    assign N_out          = N;
    assign Z_out          = Z;
    assign C_out          = C;
    assign V_out          = V;

endmodule
