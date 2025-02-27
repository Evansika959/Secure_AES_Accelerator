module encrypt_engine_tb;

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
    encrypt_engine dut (
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
        #10;
        set_key = 0;
        start = 1;
        // #10 set_key = 0;
        
        // #120;
        $display("=== Stage Key Registers ===");
        for (int i = 0; i < 12; i++) begin
            #10
            $display("Time: %0t, key_idx_cnt = %d, fsm_state = %d, key_gen = (%h) -> (%h), out = %h, out_valid = %b", $time, dut.key_gen_idx, dut.fsm_state, dut.key_expansion_in, dut.key_expansion_out, out, out_valid);
            for (int j = 0; j < 10; j++) begin
                // $display("stage_key_regs[%0d] = %h", j, dut.stage_key_regs[j]);
                if (j == 8) begin
                    $display("stage_out_regs[%0d] = %h [%b]", j, dut.last_stage_in, dut.last_in_valid);
                end else if (j == 9) begin
                    $display("stage_out_regs[%0d] = %h [%b]", j, dut.out, dut.out_valid);
                end else begin
                    $display("stage_out_regs[%0d] = %h [%b]", j, dut.stage_out_regs[j], dut.stage_valid[j]);
                end

            end

            for (int j = 0; j < 10; j++) begin
                $display("stage_key_regs[%0d] = %h", j, dut.stage_key_regs[j]);
            end
        end
        #10;
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
