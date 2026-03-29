module instruction_mem (
    input [7:0] addr,
    output [15:0] instruction
);

    reg [15:0] rom [0:255];

    initial begin
        $readmemb("programs/program.mem", rom);
    end

    assign instruction = rom[addr];

endmodule
