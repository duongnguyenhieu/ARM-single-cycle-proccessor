module Decoder (
    input  [1:0] Op,
    input  [5:0] Funct,
    input  [3:0] Rd,

    output [1:0] FlagW,
    output       PCS,
    output       RegW,
    output       MemW,
    output       MemtoReg,
    output       ALUSrc,
    output [1:0] ImmSrc,
    output [1:0] RegSrc,
    output [1:0] ALUControl
);

    reg  [9:0] controls;
    reg  [1:0] FlagW_r;
    reg  [1:0] ALUControl_r;

    wire Branch;
    wire ALUOp;

    assign FlagW      = FlagW_r;
    assign ALUControl = ALUControl_r;

    // =========================
    // Main Decoder
    // =========================
    always @(*) begin
        case (Op)
            // Data-processing
            2'b00: begin
                if (Funct[5])       // immediate
                    controls = 10'b0000101001;
                else                // register
                    controls = 10'b0000001001;
            end

            // Memory
            2'b01: begin
                if (Funct[0])       // LDR
                    controls = 10'b0001111000;
                else                // STR
                    controls = 10'b1001110100;
            end

            // Branch
            2'b10: begin
                controls = 10'b0110100010;
            end

            default: begin
                controls = 10'b0000000000;
            end
        endcase
    end

    assign { RegSrc,
             ImmSrc,
             ALUSrc,
             MemtoReg,
             RegW,
             MemW,
             Branch,
             ALUOp } = controls;

    // =========================
    // ALU Decoder
    // =========================
    always @(*) begin
        if (ALUOp) begin
            case (Funct[4:1])
                4'b0100: ALUControl_r = 2'b00; // ADD
                4'b0010: ALUControl_r = 2'b01; // SUB
                4'b0000: ALUControl_r = 2'b10; // AND
                4'b1100: ALUControl_r = 2'b11; // ORR
                default: ALUControl_r = 2'b00;
            endcase

            // Flag write enable
            FlagW_r[1] = Funct[0];
            FlagW_r[0] = Funct[0] &
                        ((ALUControl_r == 2'b00) |
                         (ALUControl_r == 2'b01));
        end
        else begin
            ALUControl_r = 2'b00;
            FlagW_r      = 2'b00;
        end
    end

    // =========================
    // PC Logic (GI? NGUYÊN)
    // =========================
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

endmodule
