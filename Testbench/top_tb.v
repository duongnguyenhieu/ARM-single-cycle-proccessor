module top_tb;

    reg clk;

    // --- Outputs from top module for observation ---
    wire [31:0] Instr_out;
    wire [31:0] PC_out;
    wire [31:0] ALUResult_out;
    wire [31:0] WriteData_out;
    wire [31:0] ReadData_out;
    wire [31:0] SrcA_out;
    wire [31:0] SrcB_out;
    wire [31:0] ExtImm_out;
    wire [31:0] RD1_out;
    wire [31:0] RD2_out;

    wire        PCSrc_out;
    wire        MemtoReg_out;
    wire        MemWrite_out;
    wire        RegWrite_out;
    wire [1:0]  ALUControl_out;
    wire [1:0]  ImmSrc_out;
    wire [1:0]  RegSrc_out;
    wire        N_out;
    wire        Z_out;
    wire        C_out;
    wire        V_out;

    // --- Instantiate top module ---
    top dut (
        .clk(clk),
        .Instr_out(Instr_out),
        .PC_out(PC_out),
        .ALUResult_out(ALUResult_out),
        .WriteData_out(WriteData_out),
        .ReadData_out(ReadData_out),
        .SrcA_out(SrcA_out),
        .SrcB_out(SrcB_out),
        .ExtImm_out(ExtImm_out),
        .RD1_out(RD1_out),
        .RD2_out(RD2_out),
        .PCSrc_out(PCSrc_out),
        .MemtoReg_out(MemtoReg_out),
        .MemWrite_out(MemWrite_out),
        .RegWrite_out(RegWrite_out),
        .ALUControl_out(ALUControl_out),
        .ImmSrc_out(ImmSrc_out),
        .RegSrc_out(RegSrc_out),
        .N_out(N_out),
        .Z_out(Z_out),
        .C_out(C_out),
        .V_out(V_out)
    );

    // --- Clock 100 MHz ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns period
    end

    // --- Simulation dump ---
    initial begin
        $dumpfile("top_wave.vcd");
        $dumpvars(0, top_tb);  

        $display("Time  PC       Instr      ALUResult  WriteData  ReadData  N Z C V  PCSrc MemW RegW");

        #500;  // run enough cycles to observe
        $finish;
    end

    // --- Display all signals every posedge clk ---
    always @(posedge clk) begin
        $display("%0dns %h %h %h %h %h %b %b %b %b %b %b %b",
            $time,
            PC_out,
            Instr_out,
            ALUResult_out,
            WriteData_out,
            ReadData_out,
            N_out, Z_out, C_out, V_out,
            PCSrc_out, MemWrite_out, RegWrite_out
        );
    end

endmodule
