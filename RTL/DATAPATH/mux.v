module mux #(parameter N = 32)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    input  wire sel,
    output reg  [N-1:0] y
);

    always @(*) begin
        y = sel ? b : a;
    end
endmodule
