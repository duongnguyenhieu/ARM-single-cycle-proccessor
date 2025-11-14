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
  reg  [31:0] a, b;
  reg  [1:0]  aluctrl;
  wire [31:0] result;
  wire zero;

  // DUT
  alu dut(
    .a(a), .b(b), .aluctrl(aluctrl),
    .result(result), .zero(zero)
  );

  initial begin
    $display("==== ALU TESTBENCH START ====");

   // ADD
    a = 32'd10;
    b = 32'd15;
    aluctrl = 2'b00;
    #10;
    $display("ADD: result=%d zero=%b", result, zero);

    // SUB
    a = 32'd10;
    b = 32'd15;
    aluctrl = 2'b01;
    #10;
    $display("SUB: result=%d zero=%b", result, zero);

    // AND
    a = 32'd10;
    b = 32'd15;
    aluctrl = 2'b10;
    #10;
    $display("AND: result=%d zero=%b", result, zero);

   // OR
    a = 32'd10;
    b = 32'd15;
    aluctrl = 2'b11;
    #10;
    $display("ORR: result=%d zero=%b", result, zero);
    $display("Project cua Duong Nguyen Hieu");
    $finish;
  end
endmodule
