`timescale 1ns/1ps

module tb_Control_Unit();

    reg clk;
    reg [3:0] Rd;
    reg [1:0] Op;
    reg [5:0] Funct;
    reg [3:0] Cond;
    reg N, Z, C, V;

    wire PCSrc;
    wire MemtoReg;
    wire MemWrite;
    wire [1:0] ALUControl;
    wire [1:0] ImmSrc;
    wire RegWrite;
    wire [1:0] RegSrc;

    // DUT
    Control_Unit dut(
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
        .RegSrc(RegSrc)
    );

    // T?o clock
    always #5 clk = ~clk;

    initial begin
        $display("=== TESTBENCH CONTROL UNIT ===");
        
        clk = 0;
        Rd = 0; Op = 0; Funct = 0; Cond = 0;
        N = 0; Z = 0; C = 0; V = 0;

        #10;

        // ========================
        // 1) Test l?nh Data Processing
        // Op = 00 ? DP
        // Funct = 6'b010000 ? ADD
        // ========================
        $display("\n--- Test DP: ADD ---");
        Op = 2'b00;
        Funct = 6'b001000; // ví d? mã ADD
        Cond = 4'b1110;    // AL (Always)
        #10;
        $display("ALUControl=%b RegWrite=%b", ALUControl, RegWrite);

        // ========================
        // 2) Test l?nh Memory Load
        // Op = 01 ? Memory
        // Funct = don't care
        // ========================
        $display("\n--- Test LOAD ---");
        Op = 2'b01;
        Funct = 6'b000000;
        Rd = 4'd2;
        Cond = 4'b1110;
        #10;
        $display("MemtoReg=%b MemWrite=%b RegWrite=%b", 
                 MemtoReg, MemWrite, RegWrite);

        // ========================
        // 3) Test l?nh Branch
        // Op = 10 ? Branch
        // ========================
        $display("\n--- Test BRANCH ---");
        Op = 2'b10;
        Cond = 4'b1110; // Always
        #10;
        $display("PCSrc=%b", PCSrc);

        // ========================
        // 4) Test Condition Check
        // Cond = EQ (Z==1)
        // ========================
        $display("\n--- Test Condition EQ ---");
        Op = 2'b00;
        Funct = 6'b001000;

        Cond = 4'b0000; // EQ
        Z = 1;
        #10;
        $display("CondEx (PCSrc? RegWrite?) = PCSrc=%b RegWrite=%b", PCSrc, RegWrite);

        Z = 0;
        #10;
        $display("CondEx fail: PCSrc=%b RegWrite=%b", PCSrc, RegWrite);

       $display("Project cua Duong Nguyen Hieu");
        $finish;
    end

endmodule
