module register_file (
    input clk,
    input reset,
    input [2:0] read_addr1,
    input [2:0] read_addr2,
    input [2:0] write_addr,
    input [15:0] write_data,
    input write_en,
    output [15:0] read_data1,
    output [15:0] read_data2
);

    reg [15:0] registers [0:7];

    integer i;

    // Write logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] <= 16'b0;
            end
        end else if (write_en && write_addr != 3'b000) begin
            registers[write_addr] <= write_data;
        end
    end

    // Read logic (combinational)
    assign read_data1 = (read_addr1 == 3'b000) ? 16'b0 : registers[read_addr1];
    assign read_data2 = (read_addr2 == 3'b000) ? 16'b0 : registers[read_addr2];

endmodule