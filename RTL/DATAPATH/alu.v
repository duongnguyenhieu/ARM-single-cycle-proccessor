module alu (
    input  [31:0] A,   
    input  [31:0] B,    
    input  [1:0]  ALUControl,
    output reg  [31:0] Result,
    output reg         N,    // Negative
    output reg         Z,    // Zero
    output reg         C,    // Carry (no borrow)
    output reg         V     // Overflow (signed)
);
     reg [32:0] temp;
  always @(*) begin
   case( ALUControl)
    2'b00: begin
     temp = {1'b0, A} + {1'b0, B};
     Result = A+B;
    end
    2'b01: begin
     temp = {1'b0, A} - {1'b0, B};
     Result = A-B;
    end
    2'b10: begin
     Result = A & B;
    end
    2'b11: begin
     Result = A | B;
    end
   endcase
    C = ~ALUControl[1] & temp[32];
    V =  ~(A[31]^B[31]^ALUControl[0]) & (A[31]^Result[31])&~ALUControl[1];
    N =  Result[31];
    Z = (Result==0);
  end
endmodule
