module key_expansion_stage (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  round_idx,
    input  logic [127:0] in_key,
    output logic [127:0] out_key
);

logic [31:0] rot_word_out, sub_word_t;

logic [31:0] w0, w1, w2, w3, t, rcon;

logic [127:0] next_round_key;

assign rot_word_out = {in_key[23:0], in_key[31:24]};

subWords sub_words_inst (
    .state(rot_word_out),
    .out(sub_word_t)
);

always_comb begin
    w0 = in_key[127:96];
    w1 = in_key[95:64];
    w2 = in_key[63:32];
    w3 = in_key[31:0];

    // get round constant
    case (round_idx)
    1: rcon = 32'h01000000;
    2: rcon = 32'h02000000;
    3: rcon = 32'h04000000;
    4: rcon = 32'h08000000;
    5: rcon = 32'h10000000;
    6: rcon = 32'h20000000;
    7: rcon = 32'h40000000;
    8: rcon = 32'h80000000;
    9: rcon = 32'h1B000000;
    10: rcon = 32'h36000000;
    default: rcon = 32'h00000000;
  endcase

    t = sub_word_t ^ rcon;
    // Compute new words
    w0 = w0 ^ t;
    w1 = w1 ^ w0;
    w2 = w2 ^ w1;
    w3 = w3 ^ w2;
    next_round_key = {w0, w1, w2, w3};
end

// Register the computed key
always_ff @(posedge clk or negedge rst_n) begin
if (!rst_n)
    out_key <= 128'b0;
else
    out_key <= next_round_key;
end

endmodule
