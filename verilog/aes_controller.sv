`ifndef AES_CONTROLLER
`define AES_CONTROLLER

`include "sysdef.svh"

module aes_controller (
    input clk,
    input rst_n,
    input in_packet_t data_in,
    output in_packet_t data_out,
    output logic load_data,  // controll the data loading from fifo
    output logic [127:0] key_out,
    output logic [10:0] set_key
    // output logic [10:0] set_inv_key
)

fsm_state_t fsm_state, next_fsm_state;

logic key_gen_start;
logic [3:0] key_gen_idx, key_gen_idx_next;

logic 
logic [127:0]   key_expansion_in;
logic [127:0]   key_expansion_out, key_expansion_out_reg;

assign key_gen_start = data_in.valid && data_in.set_key;

assign load_data = (fsm_state == PROCESS || fsm_state == IDLE);

assign key_in = data_in.data;

assign data_out = (fsm_state == KEY_GEN) ? 0 : data_in;

assign key_gen_idx_next = (fsm_state == IDLE) ? 4'd0: 
                          (fsm_state == KEY_GEN || key_gen_start) ? key_gen_idx + 1 : 0; 

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
    end else begin
        fsm_state <= next_fsm_state;
        key_gen_idx <= key_gen_idx_next;
        key_out <= (key_gen_idx == 0 && key_gen_start) ? data_in.data : key_expansion_out;
    end
end

key_expansion_stage key_expansion_stage_initial_inst (
    .clk(clk),
    .rst_n(rst_n),
    .round_idx(key_gen_idx),
    .in_key(key_expansion_in),
    .out_key(key_expansion_out)
);

always_comb begin
    case (key_gen_idx)
        4'd0: set_inv_key = 10'b0000000001; 
        4'd1: set_inv_key = 10'b0000000010;
        4'd2: set_inv_key = 10'b0000000100;
        4'd3: set_inv_key = 10'b0000001000;
        4'd4: set_inv_key = 10'b0000010000;
        4'd5: set_inv_key = 10'b0000100000;
        4'd6: set_inv_key = 10'b0001000000;
        4'd7: set_inv_key = 10'b0010000000;
        4'd8: set_inv_key = 10'b0100000000;
        4'd9: set_inv_key = 10'b1000000000;
        default: set_inv_key = 10'b0000000000;
    endcase
end


endmodule
`endif 