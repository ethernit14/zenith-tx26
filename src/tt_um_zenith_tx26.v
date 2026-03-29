`default_nettype none

module tt_um_zenith_tx26 (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // Unused outputs
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // CPU wires
    wire [15:0] pc;
    wire [15:0] r1_out;

    // Instantiate CPU
    cpu_top cpu (
        .clk(clk),
        .reset(~rst_n),
        .pc(pc),
        .r1_out(r1_out)
    );

    // Show R1 on output pins
    assign uo_out = r1_out[7:0];

endmodule