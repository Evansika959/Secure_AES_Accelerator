`ifndef decryptRound
`define decryptRound

module decryptRound (
    input clk,
    input rst_n,
    input [127:0] state,
    input         in_valid,
    input [127:0] key,
    output logic [127:0] out,
    output logic out_valid
);

logic [127:0] after_roundkey, after_subbytes, after_shiftrows, out_temp;

inv_shiftRows inv_shiftRows_inst (
    .state(state),
    .out(after_shiftrows)
);

inv_subBytes inv_subBytes_inst (
    .state(after_shiftrows),
    .out(after_subbytes)
);

addRoundKey addRoundKey_inst (
    .state(after_subbytes),
    .key(key),
    .out(after_roundkey)
);

inv_mixColumns inv_mixColumns_inst (
    .state(after_roundkey),
    .out(out_temp)
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out <= 128'h0;
        out_valid <= 1'b0;
    end else begin
        if (in_valid) begin
            out <= out_temp;
            out_valid <= 1'b1;
        end
    end
end

endmodule

`endif