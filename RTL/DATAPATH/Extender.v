module Extender(
    input  [23:0] Instr,
    input  [1:0]  ImmSrc,
    output reg [31:0] ExtImm
);

    always @(*) begin
        case (ImmSrc)

            // 00: DP immediate (8-bit immediate, thực ra có rotate để mở rộng nhưng bỏ qua )
            2'b00: ExtImm = {24'b0, Instr[7:0]};

            // 01: Memory offset (12-bit unsigned)
            2'b01: ExtImm = {20'b0, Instr[11:0]};

            // 10: Branch offset (signed, 24-bit, <<2)
            2'b10: ExtImm = {{6{Instr[23]}}, Instr, 2'b00};

            default: ExtImm = 32'b0;

        endcase
    end

endmodule

