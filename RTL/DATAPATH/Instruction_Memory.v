`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2025 21:28:43
// Design Name: 
// Module Name: Instruction_Memory
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


module Instruction_Memory(
    input  [31:0] A,      // Address (Địa chỉ từ PC)
    output [31:0] RD      // Read Data (Lệnh đọc ra)
    );

    // 1. Khai báo mảng nhớ (Memory Array)
    // Tạo 64 từ nhớ (words), mỗi từ 32-bit.
    // Bạn có thể tăng số lượng [63:0] lên nếu chương trình dài hơn.
    reg [31:0] mem[63:0];

    // 2. Logic Đọc (Read Logic)
    // Quan trọng: Dùng A[31:2] thay vì A.
    // Lý do: PC đếm theo Byte (0, 4, 8...), còn mảng mem đánh số theo Word (0, 1, 2...).
    // Phép toán [31:2] tương đương với việc chia địa chỉ cho 4.
    assign RD = mem[A[31:2]];

    // 3. Nạp chương trình (Load Program)
    // Dùng để nạp mã máy từ file hex/dat bên ngoài vào mảng nhớ khi bắt đầu mô phỏng.
    initial begin
        // "memfile.dat" là tên file chứa mã hex của chương trình test.
        // Nếu file không tồn tại, mô phỏng sẽ báo lỗi hoặc bộ nhớ sẽ toàn 0.
        $readmemh("memfile.dat", mem);
    end

endmodule
