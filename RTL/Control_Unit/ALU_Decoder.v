`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2025 21:19:09
// Design Name: 
// Module Name: ALU_Decoder
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


module ALU_Decoder(
  input  [4:0] Funct,
  input        ALUOp,
  output reg [1:0] ALUControl,  
  output reg [1:0] FlagW         
);

  always @(*) begin
    if (ALUOp) begin
      case(Funct[4:1])
        4'b0100: begin // ADD
          ALUControl = 2'b00;
        end
        4'b0010: begin // SUB
          ALUControl = 2'b01;
        end
        4'b0000: begin // AND
          ALUControl = 2'b10;
        end
        4'b1100: begin // ORR
          ALUControl = 2'b11;
        end
        default: begin
          ALUControl = 2'bxx;
        end
      endcase

      // S là bit set cờ, nếu S=1 thì cập nhật cờ còn S=0 thì không update
      FlagW[1] = Funct[0];  // S-bit
      FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01); // C , V chỉ dùng cho ADD/SUB

    end else begin
      ALUControl = 2'b00;  // Dùng cho câu lệnh không phải data-processing (memory, branch)
      FlagW      = 2'b00;  // không update flags
    end
  end

endmodule
