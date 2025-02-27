`ifndef INV_MIXCOLUMNS  
`define INV_MIXCOLUMNS

module inv_mixColumns(
    input  [127:0] state,
    output [127:0] out
);

  logic [127:0] state_out;

  // Reuse mult2 and mult3 definitions (if needed elsewhere)
  function [7:0] mult2;  
      input [7:0] x;
      begin 
          mult2 = (x[7] == 1'b1) ? (x << 1) ^ 8'h1b : x << 1; // multiply by 2 in GF(2^8)
      end
  endfunction

  function [7:0] mult3;  
      input [7:0] x;
      begin 
          mult3 = x ^ mult2(x); // multiply by 3 in GF(2^8)
      end
  endfunction

  // Functions for inverse MixColumns multiplications
  // Note: In GF(2^8), multiplication by 9, 11, 13, and 14 can be expressed as:
  //   mult9(x)  = mult2(mult2(mult2(x))) ^ x       (i.e. (x*8) ^ x)
  //   mult11(x) = mult2(mult2(mult2(x))) ^ mult2(x) ^ x  (i.e. (x*8) ^ (x*2) ^ x)
  //   mult13(x) = mult2(mult2(mult2(x))) ^ mult2(mult2(x)) ^ x  (i.e. (x*8) ^ (x*4) ^ x)
  //   mult14(x) = mult2(mult2(mult2(x))) ^ mult2(mult2(x)) ^ mult2(x)  (i.e. (x*8) ^ (x*4) ^ (x*2))
  function [7:0] mult9;  
      input [7:0] x;
      begin 
          mult9 = mult2(mult2(mult2(x))) ^ x;
      end
  endfunction

  function [7:0] mult11;  
      input [7:0] x;
      begin 
          mult11 = mult2(mult2(mult2(x))) ^ mult2(x) ^ x;
      end
  endfunction

  function [7:0] mult13;  
      input [7:0] x;
      begin 
          mult13 = mult2(mult2(mult2(x))) ^ mult2(mult2(x)) ^ x;
      end
  endfunction

  function [7:0] mult14;  
      input [7:0] x;
      begin 
          mult14 = mult2(mult2(mult2(x))) ^ mult2(mult2(x)) ^ mult2(x);
      end
  endfunction

  // Generate the inverse MixColumns for each column.
  // For a column with bytes {s0, s1, s2, s3} arranged as:
  //   state[i*32 +:8]         -> s0 (lowest 8 bits of the column)
  //   state[(i*32 + 8)+:8]     -> s1
  //   state[(i*32 + 16)+:8]    -> s2
  //   state[(i*32 + 24)+:8]    -> s3 (highest 8 bits of the column)
  // The inverse transformation is defined as:
  //   s0' = mult14(s0) ^ mult11(s1) ^ mult13(s2) ^ mult9(s3)
  //   s1' = mult9(s0)  ^ mult14(s1) ^ mult11(s2) ^ mult13(s3)
  //   s2' = mult13(s0) ^ mult9(s1)  ^ mult14(s2) ^ mult11(s3)
  //   s3' = mult11(s0) ^ mult13(s1) ^ mult9(s2)  ^ mult14(s3)
  genvar i;
  generate
      for (i = 0; i < 4; i = i + 1) begin : invMixColumnsLoop
          assign state_out[(i*32 + 24)+:8] = mult14(state[(i*32 + 24)+:8]) ^
                                              mult11(state[(i*32 + 16)+:8]) ^
                                              mult13(state[(i*32 + 8)+:8])  ^
                                              mult9(state[i*32+:8]);

          assign state_out[(i*32 + 16)+:8] = mult9(state[(i*32 + 24)+:8])  ^
                                              mult14(state[(i*32 + 16)+:8]) ^
                                              mult11(state[(i*32 + 8)+:8])  ^
                                              mult13(state[i*32+:8]);

          assign state_out[(i*32 + 8)+:8]  = mult13(state[(i*32 + 24)+:8]) ^
                                              mult9(state[(i*32 + 16)+:8])  ^
                                              mult14(state[(i*32 + 8)+:8])  ^
                                              mult11(state[i*32+:8]);

          assign state_out[i*32+:8]        = mult11(state[(i*32 + 24)+:8]) ^
                                              mult13(state[(i*32 + 16)+:8]) ^
                                              mult9(state[(i*32 + 8)+:8])  ^
                                              mult14(state[i*32+:8]);
      end
  endgenerate

  assign out = state_out;

endmodule

`endif