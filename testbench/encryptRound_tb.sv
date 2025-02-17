`include "sysdef.svh"

module tb_encryptRound;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic [127:0] state;
    logic [127:0] key;
    logic [127:0] out;
    logic in_valid;
    logic out_valid;
    // Instantiate the DUT (Device Under Test)
    // encryptRound dut (
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .state(state),
    //     .key(key),
    //     .out(out)
    // );

    // aesRound dut (
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .state(state),
    //     .in_type(in_type),
    //     .key(key),
    //     .out(out)
    // );

    decryptRound dut (
        .clk(clk),
        .rst_n(rst_n),
        .state(state),
        .in_valid(in_valid),
        .key(key),
        .out(out),
        .out_valid(out_valid)
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
        state = 128'h7ad5fda789ef4e272bca100b3d9ff59f;
        key = 128'h549932d1f08557681093ed9cbe2c974e;
        in_valid = 1;

        // Apply reset
        #10;
        rst_n = 1;

        // Wait for the encryption round to complete
        #10;

        // Display results
        $display("State:        %h", state);
        $display("Key:          %h", key);
        $display("Decrypted:    %h", out);

        // End simulation
        #100;
        $finish;
    end

endmodule
