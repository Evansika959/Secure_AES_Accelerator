`ifndef INV_SUBBYTES
`define INV_SUBBYTES

module inv_subBytes(
    input [127:0] state,
    output [127:0] out
);

logic [127:0] sbox_out;

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : sbox_luts
        inv_sbox inv_sbox_inst (
            .a(state[i*8 +: 8]),
            .c(sbox_out[i*8 +: 8])
        );
    end
endgenerate

assign out = sbox_out;

endmodule

`endif