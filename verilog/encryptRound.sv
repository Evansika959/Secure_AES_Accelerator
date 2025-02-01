module encryptRound (
    input clk,
    input rst_n,
    input [127:0] state,
    input [127:0] key,
    output logic [127:0] out
);

logic [127:0] after_roundkey, after_subbytes, after_shiftrows;

addRoundKey addRoundKey_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .state(state),
    .key(key),
    .out(after_roundkey)
);

subBytes subBytes_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .state(after_roundkey),
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
    .out(out)
);

endmodule