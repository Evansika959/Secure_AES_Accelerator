`ifndef AESLASTROUND
`define AESLASTROUND

`include "sysdef.svh"

module aesLastRound (
    input clk,
    input rst_n,
    input [127:0] state,
    input job_t in_type,
    input [127:0] key,
    input [127:0] inv_key,
    output logic [127:0] out,
    output job_t out_type
);

logic [127:0] state_in_decrypt, state_in_encrypt;
logic [127:0] out_decrypt, out_encrypt;

logic out_valid_decrypt, out_valid_encrypt;

assign state_in_decrypt = (in_type == DECRYPT) ? state : 128'h0;

assign state_in_encrypt = (in_type == ENCRYPT) ? state : 128'h0;

decryptLastRound decryptLastRound_inst (
    .clk(clk),
    .rst_n(rst_n),
    .state(state_in_decrypt),
    .in_valid(in_type == DECRYPT),
    .key(inv_key),
    .out(out_decrypt),
    .out_valid(out_valid_decrypt)
);

encryptLastRound encryptLastRound_inst (
    .clk(clk),
    .rst_n(rst_n),
    .state(state_in_encrypt),
    .in_valid(in_type == ENCRYPT),
    .key(key),
    .out(out_encrypt),
    .out_valid(out_valid_encrypt)
);

assign out = (in_type == DECRYPT) ? out_decrypt : 
             (in_type == ENCRYPT) ? out_encrypt : 128'hdeadbeef;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_type <= INVALID;
    end else begin
        out_type <= in_type;
    end
end

endmodule

`endif