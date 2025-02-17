`ifndef INV_SHIFTROWS
`define INV_SHIFTROWS

module inv_shiftRows (
    input  [127:0] state,
    output logic [127:0] out
);

logic [127:0] inv_shifted;

assign out = inv_shifted;

// Inverse ShiftRows
// ---------------------------------
// Row 0 (r = 0): No shift (unchanged)
assign inv_shifted[24+:8]  = state[24+:8];
assign inv_shifted[56+:8]  = state[56+:8];
assign inv_shifted[88+:8]  = state[88+:8];
assign inv_shifted[120+:8] = state[120+:8];

// Row 1 (r = 1): Cyclic right shift by 1
assign inv_shifted[112+:8] = state[16+:8];  // state[16] becomes original byte at [112]
assign inv_shifted[16+:8]  = state[48+:8];   // state[48] becomes original byte at [16]
assign inv_shifted[48+:8]  = state[80+:8];   // state[80] becomes original byte at [48]
assign inv_shifted[80+:8]  = state[112+:8];  // state[112] becomes original byte at [80]

// Row 2 (r = 2): Cyclic right shift by 2
assign inv_shifted[72+:8]  = state[8+:8];   // state[8]  -> original [72]
assign inv_shifted[104+:8] = state[40+:8];  // state[40] -> original [104]
assign inv_shifted[8+:8]   = state[72+:8];   // state[72] -> original [8]
assign inv_shifted[40+:8]  = state[104+:8];  // state[104]-> original [40]

// Row 3 (r = 3): Cyclic right shift by 3
assign inv_shifted[32+:8] = state[0+:8];    // state[0]  -> original [32]
assign inv_shifted[64+:8] = state[32+:8];   // state[32] -> original [64]
assign inv_shifted[96+:8] = state[64+:8];    // state[64] -> original [96]
assign inv_shifted[0+:8]  = state[96+:8];    // state[96] -> original [0]

endmodule

`endif