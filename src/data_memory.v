module data_memory (
    input clk,
    input we,
    input [7:0] addr,
    input [15:0] wdata,
    output [15:0] rdata
);

    reg [15:0] ram [0:255];

    always @(posedge clk) begin
        if (we) begin
            ram[addr] <= wdata;
        end
    end

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            ram[i] = 16'b0;
    end

    assign rdata = ram[addr];

endmodule
