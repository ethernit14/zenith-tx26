module control_unit (
    input [3:0] opcode,
    input is_r_type,
    input is_i_type,
    input is_j_type,
    input zero,      // from ALU
    input negative,  // from ALU
    output reg [3:0] alu_op,
    output reg reg_write_en,
    output reg mem_write_en,
    output reg jump_en,
    output reg branch_en,
    output reg use_immediate  // for ALU operand B mux
);

    always @(*) begin
        // Default values
        alu_op = 4'b0000;
        reg_write_en = 0;
        mem_write_en = 0;
        jump_en = 0;
        branch_en = 0;
        use_immediate = 0;

        case(opcode)
            // R-type instructions
            4'b0000: begin  // ADD
                alu_op = 4'b0000;
                reg_write_en = 1;
            end
            4'b0001: begin  // SUB
                alu_op = 4'b0001;
                reg_write_en = 1;
            end
            4'b0010: begin  // AND
                alu_op = 4'b0010;
                reg_write_en = 1;
            end
            4'b0011: begin  // OR
                alu_op = 4'b0011;
                reg_write_en = 1;
            end
            4'b0100: begin  // XOR
                alu_op = 4'b0100;
                reg_write_en = 1;
            end
            4'b0101: begin  // SHL
                alu_op = 4'b0110;
                reg_write_en = 1;
            end
            4'b0110: begin  // SHR
                alu_op = 4'b0111;
                reg_write_en = 1;
            end
            4'b0111: begin  // SLT
                alu_op = 4'b1000;
                reg_write_en = 1;
            end
            
            // I-type instructions
            4'b1000: begin  // LDI
                use_immediate = 1;
                alu_op = 4'b0000;  // ADD 0 + immediate
                reg_write_en = 1;
            end
            4'b1001: begin  // ADDI
                alu_op = 4'b0000;  // ADD
                use_immediate = 1;
                reg_write_en = 1;
            end
            4'b1010: begin  // LD (load from memory)
                alu_op = 4'b0000;  // ADD for address calculation
                use_immediate = 1;
                reg_write_en = 1;
            end
            4'b1011: begin  // ST (store to memory)
                alu_op = 4'b0000;  // ADD for address calculation
                use_immediate = 1;
                mem_write_en = 1;
            end
            
            // J-type instructions
            4'b1100: begin  // JMP
                jump_en = 1;
            end
            4'b1101: begin  // BEQ
                alu_op = 4'b0001;
                if (zero) branch_en = 1;
            end
            4'b1110: begin  // BLT 
                alu_op = 4'b0001;
                if (negative) branch_en = 1;
            end
            
            // 4'b1111: NOP - all signals stay 0
            
            default: begin
                // All signals stay 0
            end
        endcase
    end

endmodule
