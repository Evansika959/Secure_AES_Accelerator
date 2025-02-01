module addRoundKey (
    input [127:0] state,
    input [127:0] key,
    output [127:0] out
);

    // always_ff @(posedge clk or negedge rst_n) begin
    //     if (~rst_n) begin
    //         out <= 128'h0;
    //     end else begin
    //         out <= state ^ key;
    //     end
    // end

    assign out = state ^ key;

endmodule