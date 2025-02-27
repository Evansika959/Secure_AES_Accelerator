`ifndef ENCRYPTROUND
`define ENCRYPTROUND

module encryptRound (
    // input clk,
    // input rst_n,
    input [127:0] state,
    input         in_valid,
    input [127:0] key,
    output logic [127:0] out
    // output logic out_valid
);

logic [127:0] after_mixcolumn, after_subbytes, after_shiftrows;

subBytes subBytes_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .state(state),
    .out(after_subbytes)
);

shiftRows shiftRows_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .state(after_subbytes),
    .out(after_shiftrows)
);

mixColumns mixColumns_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .state(after_shiftrows),
    .out(after_mixcolumn)
);

addRoundKey addRoundKey_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .state(after_mixcolumn),
    .key(key),
    .out(out)
);

// always_ff @(posedge clk or negedge rst_n) begin
//     if (~rst_n) begin
//         out <= 128'h0;
//         out_valid <= 1'b0;
//     end else begin
//         if (in_valid) begin
//             out <= out_temp;
//             out_valid <= 1'b1;
//         end
//     end
// end

endmodule

`endif