module tb_encryptRound;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic [127:0] state;
    logic [127:0] key;
    logic [127:0] out;

    // Instantiate the DUT (Device Under Test)
    encryptRound dut (
        .clk(clk),
        .rst_n(rst_n),
        .state(state),
        .key(key),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test procedure
    initial begin
        // Initialize signals
        rst_n = 0;
        state = 128'h00112233445566778899aabbccddeeff;
        key = 128'h000102030405060708090a0b0c0d0e0f;

        // Apply reset
        #10;
        rst_n = 1;

        // Wait for the encryption round to complete
        #10;

        // Display results
        $display("State:        %h", state);
        $display("Key:          %h", key);
        $display("Encrypted:    %h", out);

        // End simulation
        #100;
        $finish;
    end

endmodule
