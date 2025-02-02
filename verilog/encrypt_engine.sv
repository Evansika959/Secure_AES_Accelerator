module encrypt_engine (
    input clk,
    input rst_n,
    input start,
    input set_key,
    input halt,
    input [127:0] state,
    input [127:0] key,
    output logic [127:0] out,
    output logic out_valid
);

localparam INIT = 0;
localparam READY = 1;
localparam PROCESS = 2;

logic [1:0] fsm_state, next_fsm_state;

logic [8:0] [127:0]   stage_out_regs ;
logic [9:0] [127:0]   stage_key_regs ;
logic [8:0]          stage_valid   ;
logic           stage_in_valid;

logic [127:0]   key_reg;
// logic           key_valid;

logic [127:0]   after_addroundkey, stage0_in;

// process key loading
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        key_reg <= 128'h0;
    end else begin
        if (set_key && state == INIT) begin
            key_reg <= key;
        end
    end
end
// ===========================================================

// process initial round key
addRoundKey first_addRoundKey_inst (
    .state(state),
    .key(key),
    .out(after_addroundkey)
);

// process initial key expansion
key_expansion_stage #(.Round_idx(0)) key_expansion_stage_initial_inst (
    .clk(clk),
    .rst(rst_n),
    .in_key(key_reg),
    .out_key(stage_key_regs[0])
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage0_in <= 128'h0;
        stage_in_valid <= 1'b0;
    end else begin
        if (start) begin
            stage0_in <= after_addroundkey;
            stage_in_valid <= 1'b1;
        end
    end
end

// ===========================================================
// process key expansions
genvar i;
generate
    for (i = 1; i < 10; i = i + 1) begin : key_expansion
        key_expansion_stage #(.Round_idx(i)) key_expansion_stage_inst (
            .clk(clk),
            .rst(rst_n),
            .in_key(stage_key_regs[i-1]),
            .out_key(stage_key_regs[i])
        );
    end
endgenerate

// process rounds
encryptRound encryptRound_insts [9:0] (
    .clk(clk),
    .rst_n(rst_n),
    .state({stage_out_regs,stage0_in}),
    .in_valid({stage_valid,stage_in_valid}),
    .key(stage_key_regs),
    .out({out,stage_out_regs}),
    .out_valid({out_valid,stage_valid})
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