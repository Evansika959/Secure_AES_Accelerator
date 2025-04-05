`ifndef AESFIRSTROUND
`define AESFIRSTROUND

`include "sysdef.svh"

module aesFirstRound (
    input clk,
    input rstn,
    input out_packet_t data_in,
    input [127:0] in_key,
    input set_key,
    input set_inv_key,
    output out_packet_t data_out
);

logic [127:0] state_in;
logic [127:0] key0_used, key, inv_key;
logic [127:0] after_addroundkey;
logic en_de;

logic valid_decrypt, valid_encrypt;

assign valid_decrypt = (data_in.valid && data_in.en_de) ? 1'b1 : 1'b0;
assign valid_encrypt = (data_in.valid && ~data_in.en_de) ? 1'b1 : 1'b0;

assign state_in = (data_in.valid) ? data_in.data : 128'h0;

assign key0_used = (valid_decrypt) ? inv_key : 
                   (valid_encrypt) ? key : 0;

addRoundKey first_addRoundKey_inst(
    .state(state_in),
    .key(key0_used),
    .out(after_addroundkey)
);

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        data_out <= 0;
        key <= 128'h0;
        inv_key <= 128'h0;
        en_de <= 0;
    end else begin
        // data_out <= (data_in.valid) ? {1'b1, after_addroundkey, en_de} : 130'hdeadbeef;
        data_out <= (valid_decrypt) ? {1'b1, after_addroundkey, 1'b1} : 
               (valid_encrypt) ? {1'b1, after_addroundkey, 1'b0} : 130'hdeadbeef;
        key <= (set_key) ? in_key : key;
        inv_key <= (set_inv_key) ? in_key : inv_key;
        en_de <= data_in.en_de;
    end
end

endmodule

`endif