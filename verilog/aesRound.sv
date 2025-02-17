`ifndef AESROUND
`define AESROUND

`include "sysdef.svh"

module aesRound (
    input clk,
    input rst_n,
    input [127:0] state,
    input job_t in_type,
    input [127:0] key,
    output logic [127:0] out,
    output job_t out_type
);

logic [127:0] after_mixcolumn_en, after_subbytes_en, after_shiftrows_en;

logic [127:0] after_mixcolumn_de, after_subbytes_de, after_shiftrows_de;

logic [127:0] state_en, state_de;

logic [127:0] addRoundKey_in, out_temp;

assign state_en = (in_type == ENCRYPT) ? state : 128'h0;

assign state_de = (in_type == DECRYPT) ? state : 128'h0;

subBytes subBytes_inst(
    .state(state_en),
    .out(after_subbytes_en)
);

shiftRows shiftRows_inst (
    .state(after_subbytes_en),
    .out(after_shiftrows_en)
);

mixColumns mixColumns_inst (
    .state(after_shiftrows_en),
    .out(after_mixcolumn_en)
);

inv_subBytes inv_subBytes_inst(
    .state(state_de),
    .out(after_subbytes_de)
);

inv_shiftRows inv_shiftRows_inst (
    .state(after_subbytes_de),
    .out(after_shiftrows_de)
);

inv_mixColumns inv_mixColumns_inst (
    .state(after_shiftrows_de),
    .out(after_mixcolumn_de)
);

assign addRoundKey_in = (in_type == ENCRYPT) ? after_mixcolumn_en : 
                        (in_type == DECRYPT) ? after_mixcolumn_de : 128'h0;

addRoundKey addRoundKey_inst (
    .state(addRoundKey_in),
    .key(key),
    .out(out_temp)
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out <= 128'h0;
        out_type <= INVALID;
    end else begin
        out <= out_temp;
        out_type <= in_type;
    end
end

endmodule

`endif