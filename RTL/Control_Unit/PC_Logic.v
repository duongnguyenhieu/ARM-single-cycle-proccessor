`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2025 21:19:09
// Design Name: 
// Module Name: PC_Logic
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


module PC_Logic(
  input [3:0]RD,
  input  Branch,
  input RegW,
  output PCS
    );
    //PC update khi Branch = 1 hoặc RegW = 1
    assign PCS = ((RD==15) & RegW) | Branch;
endmodule
