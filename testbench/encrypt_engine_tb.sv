`timescale 1ns / 1ps

module encryptRound_tb;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic start;
    logic set_key;
    logic halt;
    logic [127:0] state;
    logic [127:0] key;
    logic [127:0] out;
    logic out_valid;

    // Clock generation (100MHz, 10ns period)
    always #5 clk = ~clk;

    // Instantiate the DUT (Device Under Test)
    encryptRound dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .set_key(set_key),
        .halt(halt),
        .state(state),
        .key(key),
        .out(out),
        .out_valid(out_valid)
    );

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        start = 0;
        set_key = 0;
        halt = 0;
        state = 128'h00112233445566778899aabbccddeeff; // Example plaintext state
        key = 128'h000102030405060708090a0b0c0d0e0f; // Example AES round key
        
        // Reset phase
        #10 rst_n = 1;
        #10;

        // Apply key
        set_key = 1;
        start = 1;
        #10 set_key = 0;
        
        #120;
        // Additional test case: halt scenario
        halt = 1;
        #10 halt = 0;

        // Finish simulation
        #50;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | Start: %b | State: %h | Key: %h | Out: %h | Valid: %b", 
                 $time, start, state, key, out, out_valid);
    end

endmodule
