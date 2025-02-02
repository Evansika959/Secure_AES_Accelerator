module shiftRows_tb;

  // Declare testbench signals.
  reg  [127:0] state;
  wire [127:0] out;

  // Instantiate the shiftRows module (device under test).
  shiftRows uut (
    .state(state),
    .out(out)
  );

  // Stimulus process.
  initial begin
    // Print header for simulation output.
    $display("Time\t\tInput (state)                          Output (out)");
    $display("---------------------------------------------------------------");
    
    // Test Case 1: Apply a known 128-bit pattern.
    // Example value: 00112233445566778899aabbccddeeff
    state = 128'h00112233445566778899aabbccddeeff;
    #10; // Wait for 10 time units to allow combinational logic to settle.
    $display("%0t\t%032h   %032h", $time, state, out);
    
    // Optionally, add additional test cases.
    // Test Case 2: Use a different pattern.
    state = 128'hfedcba98765432100123456789abcdef;
    #10;
    $display("%0t\t%032h   %032h", $time, state, out);
    
    // End simulation after some delay.
    #10;
    $finish;
  end

endmodule
