module instruction_decoder (
    input [15:0] instruction,
    output [3:0] opcode,
    output [2:0] rd,
    output [2:0] ra,
    output [2:0] rb,
    output [15:0] immediate_ext,
    output reg is_r_type,
    output reg is_i_type,
    output reg is_j_type
);
    assign opcode = instruction[15:12];
    assign rd     = instruction[11:9];
    assign ra     = instruction[8:6];
    assign rb     = instruction[5:3];

    wire [5:0]  imm_6   = instruction[5:0];
    wire [11:0] imm_12  = instruction[11:0];
    wire [15:0] imm_6_ext  = {{10{imm_6[5]}},  imm_6};
    wire [15:0] imm_12_ext = {{4{imm_12[11]}}, imm_12};

    assign immediate_ext = is_i_type ? imm_6_ext : imm_12_ext;

    always @(*) begin
        case(opcode)
            4'b0000, 4'b0001, 4'b0010, 4'b0011,
            4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
                is_r_type = 1;
                is_i_type = 0;
                is_j_type = 0;
            end
            4'b1000, 4'b1001, 4'b1010, 4'b1011: begin
                is_r_type = 0;
                is_i_type = 1;
                is_j_type = 0;
            end
            4'b1100: begin  // JMP stays J-type
                is_r_type = 0;
                is_i_type = 0;
                is_j_type = 1;
            end
            4'b1101, 4'b1110: begin  // BEQ, BLT become I-type
                is_r_type = 0;
                is_i_type = 1;
                is_j_type = 0;
            end
            default: begin
                is_r_type = 0;
                is_i_type = 0;
                is_j_type = 0;
            end
        endcase
    end
endmodule