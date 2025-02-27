`ifndef MIX_COLUMNS
`define MIX_COLUMNS

module mixColumns(
    input [127:0] state,
    output [127:0] out
);

logic [127:0] state_out;

function [7:0] mult2;  
    input [7:0] x;
    begin 
        mult2 = (x[7] == 1) ? (x << 1) ^ 8'h1b : x << 1;                // multiply by 2 in GF(2^8)
    end
endfunction

function [7:0] mult3;  
    input [7:0] x;
    begin 
        mult3 = x ^ mult2(x);                                           // multiply by 3 in GF(2^8)
    end
endfunction

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin  : mixColumns
        assign state_out[(i*32 + 24)+:8]= mult2(state[(i*32 + 24)+:8]) ^ mult3(state[(i*32 + 16)+:8]) ^ state[(i*32 + 8)+:8] ^ state[i*32+:8];
        assign state_out[(i*32 + 16)+:8]= state[(i*32 + 24)+:8] ^ mult2(state[(i*32 + 16)+:8]) ^ mult3(state[(i*32 + 8)+:8]) ^ state[i*32+:8];
        assign state_out[(i*32 + 8)+:8]= state[(i*32 + 24)+:8] ^ state[(i*32 + 16)+:8] ^ mult2(state[(i*32 + 8)+:8]) ^ mult3(state[i*32+:8]);
        assign state_out[i*32+:8]= mult3(state[(i*32 + 24)+:8]) ^ state[(i*32 + 16)+:8] ^ state[(i*32 + 8)+:8] ^ mult2(state[i*32+:8]);
    end
endgenerate

assign out = state_out;

endmodule

`endif