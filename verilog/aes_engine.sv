`ifndef AES_ENGINE
`define AES_ENGINE

`include "sysdef.svh"

module aes_engine (
    input clk,
    input rst_n,
    input job_t in_type,
    input set_key,
    input halt,
    input [127:0] state,
    input [127:0] key,
    output logic [127:0] out,
    output job_t out_type
);

localparam INIT = 0;
localparam READY = 1;
localparam KEY_GEN = 2;
localparam PROCESS = 3;

logic [1:0] fsm_state, next_fsm_state;

logic [7:0] [127:0]   stage_out_regs ;
logic [9:0] [127:0]   stage_key_regs ;
job_t [7:0]           stage_type;
job_t                 stage_in_type;

// for last round
logic [127:0] last_stage_in;
job_t         last_stage_type;

logic [127:0]   key_reg;

logic [3:0]     key_gen_idx, key_gen_idx_next;

logic [127:0]   key_expansion_in;
logic [127:0]   key_expansion_out, key_expansion_out_reg;
// logic           key_valid;

logic [127:0]   after_addroundkey, stage0_in;

logic [127:0]   key0_used, input_state;   // for the initial round key

logic start;    // start signal for the first round

assign start = ~(in_type == INVALID);

// process key loading
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        key_reg <= 128'h0;
    end else begin
        if (set_key && fsm_state == INIT) begin
            key_reg <= key;
        end
    end
end
// ===========================================================

// process initial round key
always_comb begin
    key0_used = (in_type == ENCRYPT) ? key_reg :
                (in_type == DECRYPT) ? stage_key_regs[9] : 128'h0;
    input_state = (in_type == INVALID) ? 128'h0 : state;
end

addRoundKey first_addRoundKey_inst (
    .state(input_state),
    .key(key0_used),
    .out(after_addroundkey)
);

// process initial key expansion
key_expansion_stage key_expansion_stage_initial_inst (
    .clk(clk),
    .rst_n(rst_n),
    .round_idx(key_gen_idx),
    .in_key(key_expansion_in),
    .out_key(key_expansion_out)
);

assign key_gen_idx_next = (fsm_state == READY && ~start) ? 4'd1 : 
                          (fsm_state == KEY_GEN || (fsm_state == READY && start)) ? key_gen_idx + 1 : 1;

assign key_expansion_in = (fsm_state == READY) ? key_reg :
                               (fsm_state == KEY_GEN) ? key_expansion_out_reg : key_reg;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        key_gen_idx <= 4'd0;
        stage_key_regs <= 0;
        key_expansion_out_reg <= 128'h0;
    end else begin
        key_gen_idx <= key_gen_idx_next;
        key_expansion_out_reg <= (fsm_state == KEY_GEN || (fsm_state == READY && start)) ? key_expansion_out : key_expansion_in;

        if (fsm_state == KEY_GEN || (fsm_state == READY && start)) begin
            stage_key_regs[key_gen_idx-1] <= key_expansion_out;
        end
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage0_in <= 128'h0;
        stage_in_type <= INVALID;
    end else begin
        stage0_in <= after_addroundkey;
        stage_in_type <= in_type;
    end
end

// ===========================================================
// process rounds
genvar i;
generate
    for (i = 0; i < 9; i = i + 1) begin : gen_aesRound
        aesRound aesRound_inst (
            .clk(clk),
            .rst_n(rst_n),
            .state((i == 0) ? stage0_in : stage_out_regs[i]),
            .in_type((i == 0) ? stage_in_type : stage_type[i-1]),
            .key(stage_key_regs[i]),
            .inv_key(stage_key_regs[i+1]),
            .out((i == 8) ? last_stage_in : stage_out_regs[i]),
            .out_type((i == 8) ? last_stage_type : stage_type[i])
        );
    end
endgenerate

aesLastRound aesLastRound_inst (
    .clk(clk),
    .rst_n(rst_n),
    .state(last_stage_in),
    .in_type(last_stage_type),
    .key(stage_key_regs[9]),
    .inv_key(key_reg),
    .out(out),
    .out_type(out_type)
);

// ===========================================================
// state transfer function
always_comb begin
    next_fsm_state = fsm_state;
    case (fsm_state)
        INIT: begin
            if (set_key) begin
                next_fsm_state = READY;
            end
        end
        READY: begin
            if (start) begin
                next_fsm_state = KEY_GEN;
            end
        end
        KEY_GEN: begin
            if (halt) begin
                next_fsm_state = INIT;
            end else if (key_gen_idx == 10) begin
                next_fsm_state = PROCESS;
            end
        end
        PROCESS: begin
            if (halt) begin
                next_fsm_state = INIT;
            end
        end
        default: next_fsm_state = fsm_state;
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fsm_state <= INIT;
    end else begin
        fsm_state <= next_fsm_state;
    end
end
// ====================================================================================================

endmodule   

`endif