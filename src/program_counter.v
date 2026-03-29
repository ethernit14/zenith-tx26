module program_counter (
    input clk,
    input jump,
    input [15:0] jump_addr,
    input reset,
    output reg [15:0] pc
);

    always @(posedge clk) begin
        if (reset)
            pc <= 0;
        else if (jump)
            pc <= jump_addr;
        else
            pc <= pc + 1;
    end
endmodule