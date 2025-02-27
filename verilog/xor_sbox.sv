module xor_sbox(
    input   [7:0]   text,
    input   [7:0]   key,
    output  [7:0]   out 
);

logic   [7:0]   xor_out;

assign xor_out = text ^ key;

sbox sbox_inst(
    .a(xor_out),
    .c(out)
);
endmodule