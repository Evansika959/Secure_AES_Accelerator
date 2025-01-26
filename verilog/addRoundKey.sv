module addRoundKey (
    input clk,
    input rst_n,
    input [127:0] state,
    input [127:0] key,
    output logic [127:0] out
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            out <= 128'h0;
        end else begin
            out <= state ^ key;
        end
    end

endmodule