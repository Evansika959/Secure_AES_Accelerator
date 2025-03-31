`ifndef AES_CONTROLLER
`define AES_CONTROLLER

`include "sysdef.svh"

module aes_controller (
    input clk,
    input rst_n,
    input in_packet_t data_in,
    output out_packet_t data_out,
    output logic load_data,  // controll the data loading from fifo
    output logic [127:0] key_out,
    output logic [10:0] set_key_onehot
    // output logic [10:0] set_inv_key
);

fsm_state_t fsm_state, next_fsm_state;

logic key_gen_start;
logic [3:0] key_gen_idx, key_gen_idx_next;

logic [127:0]   key_expansion_in;
logic [127:0]   key_expansion_out;

logic [10:0] next_set_key;

assign key_gen_start = (fsm_state != KEY_GEN) && data_in.valid && data_in.set_key;

assign load_data = (fsm_state == PROCESS || fsm_state == IDLE) & ~key_gen_start;

assign key_in = data_in.data;

assign data_out = (fsm_state == KEY_GEN || key_gen_start) ? 0 : {data_in.valid, data_in.data, data_in.en_de};

assign key_gen_idx_next = (fsm_state == IDLE) ? 4'd0: 
                          (fsm_state == KEY_GEN || key_gen_start) ? key_gen_idx + 1 : 0; 

assign key_expansion_in = (fsm_state == KEY_GEN) ? key_out : 128'h0;

always_comb begin
    case (fsm_state)
        IDLE: begin
            if (key_gen_start) begin
                next_fsm_state = KEY_GEN;
            end else begin
                next_fsm_state = IDLE;
            end
        end
        KEY_GEN: begin
            if (key_gen_idx == 10) begin
                next_fsm_state = PROCESS;
            end else begin
                next_fsm_state = KEY_GEN;
            end
        end
        PROCESS: begin
            if (key_gen_start) begin
                next_fsm_state = KEY_GEN;
            end else begin
                next_fsm_state = PROCESS;
            end
        end
        default: begin
            next_fsm_state = IDLE;
        end
    endcase
end


always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fsm_state <= IDLE;
        key_gen_idx <= 4'd0;
        key_out <= 128'h0;
        set_key_onehot <= 10'h0;
    end else begin
        fsm_state <= next_fsm_state;
        key_gen_idx <= key_gen_idx_next;
        key_out <= (key_gen_idx == 0 && key_gen_start) ? data_in.data : key_expansion_out;
        set_key_onehot <= (fsm_state == KEY_GEN || key_gen_start) ? next_set_key : 10'h0;
    end
end

key_expansion_stage key_expansion_stage_initial_inst (
    // .clk(clk),
    // .rst_n(rst_n),
    .round_idx(key_gen_idx),
    .in_key(key_expansion_in),
    .out_key(key_expansion_out)
);

always_comb begin
    case (key_gen_idx_next)
        4'd0: next_set_key = 11'b0000000001; 
        4'd1: next_set_key = 11'b0000000010;
        4'd2: next_set_key = 11'b0000000100;
        4'd3: next_set_key = 11'b0000001000;
        4'd4: next_set_key = 11'b0000010000;
        4'd5: next_set_key = 11'b0000100000;
        4'd6: next_set_key = 11'b0001000000;
        4'd7: next_set_key = 11'b0010000000;
        4'd8: next_set_key = 11'b0100000000;
        4'd9: next_set_key = 11'b1000000000;
        4'd10: next_set_key = 11'b10000000000;
        default: next_set_key = 10'b0000000000;
    endcase
end


endmodule
`endif 