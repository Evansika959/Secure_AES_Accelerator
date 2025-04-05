`include "sysdef.svh"

module input_buffer (
    input logic clk,
    input logic rstn,
    input logic wr_en,           // Write enable
    input logic rd_en,           // Read enable
    input logic [WIDTH-1:0] din, // Data input
    output logic [WIDTH-1:0] dout // Data output
    // output logic full,           // FIFO full flag
    // output logic empty           // FIFO empty flag
);

fifo # (
    .DEPTH(32),
    .WIDTH(131)
    )
    input_buffer_inst (
        .clk(clk),
        .rstn(rstn),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(_),
        .empty(_)
    );

endmodule