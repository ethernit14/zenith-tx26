module alu(
    input  [15:0] a,        // first operand
    input  [15:0] b,        // second operand
    input  [3:0]  op,       // operation select
    output reg [15:0] result, // result
    output reg zero,        // 1 if result == 0
    output reg carry,       // carry out
    output reg negative     // 1 if result is negative
);

    always @(*) begin
        carry = 0;  // default
        
        case(op)
            4'b0000: result = a + b;           // ADD
            4'b0001: result = a - b;           // SUB
            4'b0010: result = a & b;           // AND
            4'b0011: result = a | b;           // OR
            4'b0100: result = a ^ b;           // XOR
            4'b0101: result = ~a;              // NOT
            4'b0110: result = a << 1;          // shift left
            4'b0111: result = a >> 1;          // shift right
            4'b1000: result = (a < b) ? 1 : 0; // SLT set less than
            default: result = 16'b0;
        endcase
        
        // flags
        zero     = (result == 16'b0);
        negative = result[15];
    end

endmodule