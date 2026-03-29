module cpu_top(
    input clk,
    input reset,
    output [15:0] pc,
    output wire [15:0] r1_out
);
    // internal wires
    wire [15:0] instruction;
    wire [3:0]  opcode;
    wire [2:0]  rd, ra, rb;
    wire [15:0] immediate_ext;
    wire        is_r_type, is_i_type, is_j_type;
    wire [3:0]  alu_op;
    wire        reg_write_en, mem_write_en;
    wire        jump_en, branch_en, use_immediate;
    wire [15:0] reg_data1, reg_data2;
    wire [15:0] alu_b;
    wire [15:0] alu_result;
    wire        zero, negative, carry;
    wire [15:0] mem_rdata;
    wire [15:0] write_back_data;
    wire        pc_jump;
    wire [15:0] pc_jump_addr;

    // Program Counter
    program_counter pc_inst(
        .clk(clk),
        .reset(reset),
        .jump(pc_jump),
        .jump_addr(pc_jump_addr),
        .pc(pc)
    );

    // Instruction Memory
    instruction_mem im_inst(
        .addr(pc[7:0]),
        .instruction(instruction)
    );

    // Instruction Decoder
    instruction_decoder id_inst(
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .ra(ra),
        .rb(rb),
        .immediate_ext(immediate_ext),
        .is_r_type(is_r_type),
        .is_i_type(is_i_type),
        .is_j_type(is_j_type)
    );

    // Control Unit
    control_unit cu_inst(
        .opcode(opcode),
        .is_r_type(is_r_type),
        .is_i_type(is_i_type),
        .is_j_type(is_j_type),
        .zero(zero),
        .negative(negative),
        .alu_op(alu_op),
        .reg_write_en(reg_write_en),
        .mem_write_en(mem_write_en),
        .jump_en(jump_en),
        .branch_en(branch_en),
        .use_immediate(use_immediate)
    );

    // Register File
    register_file rf_inst(
        .clk(clk),
        .reset(reset),
        .read_addr1((opcode == 4'b1011) ? rd : 
                (opcode == 4'b1101 || opcode == 4'b1110) ? rd : ra),
        .read_addr2((opcode == 4'b1011) ? ra : 
                (opcode == 4'b1101 || opcode == 4'b1110) ? ra : rb),
        .write_addr(rd),
        .write_data(write_back_data),
        .write_en(reg_write_en),    
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    // ALU input B mux — register or immediate
    assign alu_b = use_immediate ? immediate_ext : reg_data2;

    // ALU
    alu alu_inst(
        .a(reg_data1),
        .b(alu_b),
        .op(alu_op),
        .result(alu_result),
        .zero(zero),
        .carry(carry),
        .negative(negative)
    );

    // Data Memory
    data_memory dm_inst(
        .clk(clk),
        .we(mem_write_en),
        .addr(alu_result[7:0]),
        .wdata(reg_data2),
        .rdata(mem_rdata)
    );

    // Write back — ALU result or memory data
    assign write_back_data = (opcode == 4'b1010) ? mem_rdata : alu_result;

    // Jump/Branch logic
    assign pc_jump      = jump_en | branch_en;
    assign pc_jump_addr = jump_en ? immediate_ext : pc + 1 + immediate_ext;

    assign r1_out = rf_inst.registers[1];

endmodule