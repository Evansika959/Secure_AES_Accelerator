module key_expansion_stage_tb;

    // Parameters
    parameter int Round_idx = 1;

    // Testbench signals
    logic clk;
    logic rst;
    logic [127:0] in_key;
    logic [3:0] round_idx;
    logic [127:0] out_key;

    // Clock generation
    always #5 clk = ~clk;  // 100MHz clock (10ns period)

    // Instantiate the DUT (Device Under Test)
    key_expansion_stage #(
        .Round_idx(Round_idx)
    ) dut (
        .clk(clk),
        .rst(rst),
        .in_key(in_key),
        .round_idx(round_idx),
        .out_key(out_key)
    );

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        in_key = 128'h2b7e151628aed2a6abf7158809cf4f3c; // Example AES key
        round_idx = 4'd1;

        // Reset the module
        #10 rst = 0;
        #10;

        // Apply different test cases
        repeat (10) begin
            round_idx = round_idx + 1;
            in_key = in_key ^ (round_idx * 32'h01020304);  // Change the input key for testing
            #20;
        end

        // End simulation
        #50;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0t | round_idx: %d | in_key: %h | out_key: %h", 
                 $time, round_idx, in_key, out_key);
    end

endmodule
