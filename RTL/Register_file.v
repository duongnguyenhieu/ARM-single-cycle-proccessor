`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2025 20:51:51
// Design Name: 
// Module Name: Register_file
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


module Register_file(
    input clk,
    input WE3,           // Write Enable
    input  [3:0] A1,     // Address Read 1 (Rn)
    input  [3:0] A2,     // Address Read 2 (Rm)
    input  [3:0] A3,     // Address Write (Rd)
    input  [31:0] R15,   // PC + 8 (input from Datapath)
    input  [31:0] WD3,   // Write Data
    output [31:0] RD1,   // Read Data 1
    output [31:0] RD2    // Read Data 2
    );

    // Khai báo mảng lưu trữ cho R0 đến R14 (15 thanh ghi)
    reg [31:0] rf[14:0];
    integer i;

    // ---------------------------------------------------------
    // 1. Logic Đọc (Combinational / Asynchronous)
    // ---------------------------------------------------------
    // Nếu địa chỉ là 15 (4'b1111), output giá trị R15 (PC+8).
    // Nếu không, output giá trị từ mảng rf.
    assign RD1 = (A1 == 4'd15) ? R15 : rf[A1];
    assign RD2 = (A2 == 4'd15) ? R15 : rf[A2];

    // ---------------------------------------------------------
    // 2. Logic Ghi (Sequential / Synchronous)
    // ---------------------------------------------------------
    always @(posedge clk) begin
        if (WE3) begin
            // Chỉ ghi nếu địa chỉ KHÁC 15. 
            // Việc ghi vào PC (R15) do bộ cộng PC hoặc nhánh điều khiển.
            if (A3 != 4'd15) begin
                rf[A3] <= WD3;
            end
        end
    end
    
    // (Tùy chọn) Khởi tạo giá trị ban đầu cho mô phỏng để tránh lỗi 'X'
    initial begin
        for (i = 0; i < 15; i = i + 1)
            rf[i] = 0;
    end

endmodule
