module subBytes(
    input [127:0] state,
    output [127:0] out
);

logic [127:0] sbox_out;

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : sbox_luts
        sbox sbox_inst (
            .a(state[i*8 +: 8]),
            .c(sbox_out[i*8 +: 8])
        );
    end
endgenerate

// always_ff @(posedge clk or negedge rst_n) begin
//     if (~rst_n) begin
//         out <= 128'h0;
//     end else begin
//         out <= sbox_out;
//     end
// end

assign out = sbox_out;

endmodule