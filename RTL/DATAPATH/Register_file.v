module Register_file(
    input         clk,
    input         WE3,          // Write enable
    input  [3:0]  A1,           // Read address 1 (Rn)
    input  [3:0]  A2,           // Read address 2 (Rm)
    input  [3:0]  A3,           // Write address (Rd)
    input  [31:0] R15,          // PC + 8 (from datapath)
    input  [31:0] WD3,          // Write data
    output [31:0] RD1,          // Read data 1
    output [31:0] RD2           // Read data 2
);

    // 16 thanh ghi: R0 đến R15
    reg [31:0] rf[0:15];
    integer i;

    // 1. Logic đọc (không đồng bộ)
    assign RD1 = (A1 == 4'd15) ? R15 : rf[A1];
    assign RD2 = (A2 == 4'd15) ? R15 : rf[A2];

    // 2. Logic ghi (đồng bộ cạnh lên)
    always @(posedge clk) begin
        if (WE3 && (A3 != 4'd15)) begin
            rf[A3] <= WD3;
        end
    end
    // 3. Khởi tạo (chỉ để mô phỏng)
    initial begin
        for (i = 0; i < 16; i = i + 1)
            rf[i] = 32'b0;
    end

endmodule
