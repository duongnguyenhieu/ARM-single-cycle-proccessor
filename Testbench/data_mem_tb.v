`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2025 22:46:48
// Design Name: 
// Module Name: data_mem_tb
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
module data_mem_tb;

  reg clk;
  reg WE;
  reg [31:0] A;
  reg [31:0] WD;
  wire [31:0] ReadData;

  // Gọi module datamem
  data_mem uut (
    .clk(clk),
    .WE(WE),
    .A(A),
    .WD(WD),
    .ReadData(ReadData)
  );

  // Tạo xung clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // chu kỳ 10ns
  end

  // Mô phỏng
  initial begin
    // Khởi tạo
    WE = 0; A = 0; WD = 0;

    // Ghi dữ liệu vào ô 0
    #10 WE = 1; A = 32'h00000000; WD = 32'hDEADBEEF;
    #10 WE = 0;

    // Ghi dữ liệu vào ô 4
    #10 WE = 1; A = 32'h00000004; WD = 32'hCAFEBABE;
    #10 WE = 0;

    // Đọc dữ liệu từ ô 0
    #10 A = 32'h00000000;
    #10 $display("ReadData at addr 0 = %h", ReadData);

    // Đọc dữ liệu từ ô 4
    #10 A = 32'h00000004;
    #10 $display("ReadData at addr 4 = %h", ReadData);
     $display("Project cua Duong Nguyen Hieu");
    #20 $finish;
  end

endmodule
