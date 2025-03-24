`ifndef AESLASTROUND
`define AESLASTROUND

`include "sysdef.svh"

module aesLastRound (
    input clk,
    input rst_n,
    input out_packet_t data_in,
    input [127:0] in_key,
    input set_key,
    input set_inv_key,
    output out_packet_t data_out,
);

logic [127:0] state_in_decrypt, state_in_encrypt;
logic [127:0] out_decrypt, out_encrypt;
logic [127:0] key, inv_key;

logic valid_decrypt, valid_encrypt;

assign valid_decrypt = (data_in.valid && data_in.en_de) ? 1'b1 : 1'b0;
assign valid_encrypt = (data_in.valid && ~data_in.en_de) ? 1'b1 : 1'b0;

assign state_in_decrypt = (valid_decrypt) ? data_in.data : 128'h0;

assign state_in_encrypt = (valid_encrypt) ? data_in.data : 128'h0;

decryptLastRound decryptRound_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .state(state_in_decrypt),
    .in_valid(valid_decrypt),
    .key(inv_key),
    .out(out_decrypt)
    // .out_valid(out_valid_decrypt)
);

encryptLastRound encryptRound_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .state(state_in_encrypt),
    .in_valid(valid_encrypt),
    .key(key),
    .out(out_encrypt)
    // .out_valid(out_valid_encrypt)
);

// assign out = (in_type == DECRYPT) ? out_decrypt : 
//              (in_type == ENCRYPT) ? out_encrypt : 128'hdeadbeef;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_out <= 0;
        key <= 128'h0;
        inv_key <= 128'h0;
    end else begin
        data_out <= (valid_decrypt) ? {1'b1, out_decrypt, 1'b1} : 
               (valid_encrypt) ? {1'b1, out_encrypt, 1,b0} : 130'hdeadbeef;
        key <= (set_key) ? in_key : key;
        inv_key <= (set_inv_key) ? in_key : inv_key;
    end
end

endmodule

`endif