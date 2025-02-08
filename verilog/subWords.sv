module subWords(
    input [31:0] state,
    output [31:0] out
);

logic [31:0] sbox_out;

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : sbox_luts
        sbox sbox_inst (
            .a(state[i*8 +: 8]),
            .c(sbox_out[i*8 +: 8])
        );
    end
endgenerate

assign out = sbox_out;

endmodule