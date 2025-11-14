`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2025 16:27:20
// Design Name: 
// Module Name: alu_tb
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

`timescale 1ns/1ps

module alu_tb;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [1:0]  ALUControl;

    wire [31:0] Result;
    wire N, Z, C, V;

    // Instantiate the ALU
    alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );

    initial begin
        $display("Time | ALUControl | A         | B         | Result     | N Z C V");
        $display("---------------------------------------------------------------");

        // --- Test ADD ---
        ALUControl = 2'b00; A = 32'd10; B = 32'd5; #10;
        $display("%4dns | %b         | %0d | %0d | %0d | %b %b %b %b",
                 $time, ALUControl, A, B, Result, N,Z,C,V);

        ALUControl = 2'b00; A = 32'd2000000000; B = 32'd2000000000; #10;
        $display("%4dns | %b         | %0d | %0d | %0d | %b %b %b %b",
                 $time, ALUControl, A, B, Result, N,Z,C,V);

        // --- Test SUB ---
        ALUControl = 2'b01; A = 32'd5; B = 32'd10; #10;
        $display("%4dns | %b         | %0d | %0d | %0d | %b %b %b %b",
                 $time, ALUControl, A, B, Result, N,Z,C,V);

        ALUControl = 2'b01; A = -32'd2000000000; B = 32'd1500000000; #10;
        $display("%4dns | %b         | %0d | %0d | %0d | %b %b %b %b",
                 $time, ALUControl, A, B, Result, N,Z,C,V);

        // --- Test AND ---
        ALUControl = 2'b10; A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; #10;
        $display("%4dns | %b         | %h | %h | %h | %b %b %b %b",
                 $time, ALUControl, A, B, Result, N,Z,C,V);

        // --- Test OR ---
        ALUControl = 2'b11; A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; #10;
        $display("%4dns | %b         | %h | %h | %h | %b %b %b %b",
                 $time, ALUControl, A, B, Result, N,Z,C,V);
        $display("Project cua Duong Nguyen Hieu");
        $finish;
    end

endmodule
