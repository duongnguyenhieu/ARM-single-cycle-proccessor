module data_mem(
  input clk,
  input WE,                // Write Enable lấy từ MemWrite của Control Unit
  input [31:0] A,          // Address
  input [31:0] WD,         // Write Data
  output reg [31:0] ReadData // Read Data
);

  // Bộ nhớ RAM 256 ô, mỗi ô 32-bit ,thiết kế mô phỏng nên ta chỉ cần 8 bit(255 ô) để đánh địa chỉ. ứng với 1KB bộ nhớ
  reg [31:0] ram [0:255];
  integer i;

  // Khởi tạo RAM về 0
  initial begin
    for (i = 0; i < 256; i = i + 1)
      ram[i] = 32'b0;
  end

  // Ghi dữ liệu vào RAM khi WE = 1 tại cạnh lên của clk
  always @(posedge clk) begin
    if (WE)
      ram[A[9:2]] <= WD; // Dùng A[9:2] để đánh địa chỉ (256 ô) ( giải thích: Mỗi lần tăng 4 byte (1 word) nên t phải dịch trái 2 bit )
  end

  // Đọc dữ liệu từ RAM 
  always @(*) begin
    ReadData = ram[A[9:2]];
  end
  
  endmodule 
