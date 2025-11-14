module alu(
  input [31:0] a, b,
  input [1:0] aluctrl,
  output reg [31:0] result,
  output zero
);
  always @(*) begin
   case(aluctrl)
    2'b00: result = a + b; // ADD
    4'b01: result = a - b; // SUB
    4'b10: result = a & b; // AND
    4'b11: result = a | b; // OR
      default: result = 32'b0;
   endcase
  end
    assign zero = (result == 0);
endmodule
