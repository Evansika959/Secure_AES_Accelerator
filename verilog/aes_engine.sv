`ifndef AES_ENGINE
`define AES_ENGINE

`include "sysdef.svh"

module aes_engine (
    input clk,
    input rst_n,
    input in_packet_t data_in,
    output out_packet_t data_out,
    output logic load_data
);

logic [127:0] key_out;
logic [10:0] set_key_onehot;
out_packet_t        stage_in;
out_packet_t [9:0]  stage_out_regs;

aes_controller  aes_controller_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .data_out(stage_in),
    .load_data(load_data),
    .key_out(key_out),
    .set_key(set_key_onehot)
);

aesFirstRound aesFirstRound_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(stage_in),
    .in_key(key_out),
    .set_key(set_key_onehot[0]),
    .set_inv_key(set_key_onehot[10]),
    .data_out(stage_out_regs[0])
);

genvar i;
generate
  for (i = 0; i < 9; i = i + 1) begin : gen_aesRound
    aesRound aesRound_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(stage_out_regs[i]),
        .in_key(key_out),
        .set_key(set_key_onehot[i+1]),
        .set_inv_key(set_key_onehot[9-i]),
        .data_out(stage_out_regs[i+1])
    );
  end
endgenerate

aesLastRound  aesLastRound_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(stage_out_regs[9]),
    .in_key(in_key),
    .set_key(set_key_onehot[10]),
    .set_inv_key(set_key_onehot[0]),
    .data_out(data_out)
);

endmodule   

`endif