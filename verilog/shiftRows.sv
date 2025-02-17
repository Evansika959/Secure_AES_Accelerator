module shiftRows (
    input [127:0] state,
    output logic [127:0] out
);

logic [127:0] shifted;

assign out = shifted;

// First row (r = 0) is not shifted
assign shifted[24+:8] = state[24+:8];
assign shifted[56+:8] = state[56+:8];
assign shifted[88+:8] = state[88+:8];
assign shifted[120+:8] = state[120+:8];


// // Second row (r = 1) is cyclically left shifted by 1 offset
assign shifted[16+:8] = state[112+:8];
assign shifted[48+:8] = state[16+:8];
assign shifted[80+:8] = state[48+:8];
assign shifted[112+:8] = state[80+:8];

// // Third row (r = 2) is cyclically left shifted by 2 offsets
assign shifted[8+:8] = state[72+:8];
assign shifted[40+:8] = state[104+:8];
assign shifted[72+:8] = state[8+:8];
assign shifted[104+:8] = state[40+:8];

// // Fourth row (r = 3) is cyclically left shifted by 3 offsets
assign shifted[0+:8] = state[32+:8];
assign shifted[32+:8] = state[64+:8];
assign shifted[64+:8] = state[96+:8];
assign shifted[96+:8] = state[0+:8];

endmodule