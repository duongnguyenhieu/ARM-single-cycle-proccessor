`timescale 1ns/1ps

module top_tb;

    reg clk;
    reg reset;

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
    wire        ALUSrc_out;
    wire [1:0]  ALUControl_out;
    wire [1:0]  ImmSrc_out;
    wire [1:0]  RegSrc_out;
    wire        N_out, Z_out, C_out, V_out;

    // --- Instantiate top module ---
    top dut (
        .clk(clk),
        .reset(reset),
        
        // Debug Connections
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
        .ALUSrc_out(ALUSrc_out),
        .ALUControl_out(ALUControl_out),
        .ImmSrc_out(ImmSrc_out),
        .RegSrc_out(RegSrc_out),
        
        .N_out(N_out), .Z_out(Z_out), .C_out(C_out), .V_out(V_out)
    );

    // -------- CLOCK GENERATION ------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ 10ns (100 MHz)
    end
    
    // -------- RESET SEQUENCE ------------
    initial begin
        reset = 1'b1;   // Kích hoạt Reset
        #22;            // Giữ Reset trong 22ns (hơn 2 chu kỳ clock)
        reset = 1'b0;   // Nhả Reset
    end

    // -------- INSTRUCTION DECODER FOR LOGGING ------------
    // Hàm này giúp hiển thị tên lệnh (String) thay vì mã Hex khó đọc
    function [80*8:1] decode_instr;
        input [31:0] instr;
        reg [1:0] op;       // Opcode chính (Bit 27:26)
        reg [3:0] cmd;      // Command cho lệnh tính toán (Bit 24:21)
        reg       l_bit;    // Bit L để phân biệt LDR/STR (Bit 20)
        begin
            op    = instr[27:26]; 
            cmd   = instr[24:21];
            l_bit = instr[20];

            case (op)
                2'b00: begin
                    case (cmd)
                        4'b0100: decode_instr = "ADD"; 
                        4'b0010: decode_instr = "SUB"; 
                        4'b0000: decode_instr = "AND"; 
                        4'b1100: decode_instr = "ORR"; 
                        default: decode_instr = "UNKNOWN_DP";
                    endcase
                end
                2'b01: begin
                    if (l_bit) 
                        decode_instr = "LDR"; // Load
                    else       
                        decode_instr = "STR"; // Store
                end
                2'b10: begin
                    decode_instr = "B";
                end
                default: decode_instr = "UNKNOWN";
            endcase
        end
    endfunction

    // -------- SIMULATION CONTROL ----------
    initial begin
        $dumpfile("top_wave.vcd"); // Tạo file sóng để xem trên GTKWave/Vivado
        $dumpvars(0, top_tb);

        $display("==== ARM CPU SIMULATION START ====");
        #250; // Chạy mô phỏng trong 250ns (đủ cho khoảng 20 lệnh)
        $display("==== SIMULATION FINISHED ====");
        $finish;
    end

    // ---------- LOGGING PER CYCLE ------------
    integer cycle = 0;
    
    // Sử dụng negedge clk để log dữ liệu sau khi mọi thứ đã ổn định trong chu kỳ đó
    // hoặc posedge nếu muốn xem giá trị ngay khi clock đánh lên.
    always @(posedge clk) begin
        if (!reset) begin // Chỉ log khi đã hết reset
            $display("\n===== Cycle %0d (Time: %0t ns) =====", cycle, $time);
            $display(" PC        = %h", PC_out);
            $display(" Instr     = %h  --> %s", Instr_out, decode_instr(Instr_out));
            
            // Hiển thị các giá trị quan trọng
            if (MemWrite_out) 
                $display(" [MEM] WRITE: Data %h -> Addr %h", WriteData_out, ALUResult_out);
            else if (RegWrite_out)
                $display(" [REG] WRITE: Data %h (Result of ALU/Mem)", ALUResult_out); // Đơn giản hóa, thực tế có thể là Mem data
            
            $display(" ALU: SrcA=%h  SrcB=%h  Result=%h", SrcA_out, SrcB_out, ALUResult_out);
            $display(" Flags: N=%b Z=%b C=%b V=%b | PCSrc=%b", N_out, Z_out, C_out, V_out, PCSrc_out);
            
            cycle = cycle + 1;
        end
    end

endmodule
