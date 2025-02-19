`timescale 1ns/1ps
`include "sysdef.svh"  // Ensure that job_t and related definitions are available

module aes_engine_tb;

  // Testbench signals
  logic         clk;
  logic         rst_n;
  job_t         in_type;
  logic         set_key;
  logic         halt;
  logic [127:0] state;
  logic [127:0] key;
  logic [127:0] out;
  job_t         out_type;
  logic         in_valid; // if needed, include any handshake signals

  // Clock generation: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Instantiate the DUT
  aes_engine dut (
    .clk      (clk),
    .rst_n    (rst_n),
    .in_type  (in_type),
    .set_key  (set_key),
    .halt     (halt),
    .state    (state),
    .key      (key),
    .out      (out),
    .out_type (out_type)
  );

  // Helper function to convert job_t to a string (adjust according to your job_t enum)
  function automatic string job_type_to_string(job_t jt);
    if(jt == ENCRYPT)
      job_type_to_string = "ENCRYPT";
    else if(jt == DECRYPT)
      job_type_to_string = "DECRYPT";
    else 
      job_type_to_string = "UNKNOWN";
  endfunction


    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        set_key = 0;
        halt = 0;
        state = 128'h00112233445566778899aabbccddeeff; // Example plaintext state
        key = 128'h000102030405060708090a0b0c0d0e0f; // Example AES round key
        in_type = INVALID;
        
        // Reset phase
        #10 rst_n = 1;
        #10;

        // Apply key
        set_key = 1;
        #10;
        set_key = 0;
        in_type = ENCRYPT;
        // #10 set_key = 0;
        
        // #120;
        $display("=== Stage Key Registers ===");
        for (int i = 0; i < 12; i++) begin
            #10
            $display("Time: %0t, key_idx_cnt = %d, fsm_state = %d, key_gen = (%h) -> (%h), out = %h, out_type = %2b", $time, dut.key_gen_idx, dut.fsm_state, dut.key_expansion_in, dut.key_expansion_out, out, out_type);
            for (int j = 0; j < 10; j++) begin
                // $display("stage_key_regs[%0d] = %h", j, dut.stage_key_regs[j]);
                if (j == 8) begin
                    $display("stage_out_regs[%0d] = %h [%2b]", j, dut.last_stage_in, dut.last_stage_type);
                end else if (j == 9) begin
                    $display("stage_out_regs[%0d] = %h [%2b]", j, dut.out, dut.out_type);
                end else begin
                    $display("stage_out_regs[%0d] = %h [%2b]", j, dut.stage_out_regs[j], dut.stage_type[j]);
                end

            end

            for (int j = 0; j < 10; j++) begin
                $display("stage_key_regs[%0d] = %h", j, dut.stage_key_regs[j]);
            end
        end

        #10;
        // Decrypt test
        state = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
        in_type = DECRYPT;

        $display("=== Stage Key Registers ===");
        for (int i = 0; i < 12; i++) begin
            #10
            $display("Time: %0t, key_idx_cnt = %d, fsm_state = %d, key_gen = (%h) -> (%h), out = %h, out_type = %2b", $time, dut.key_gen_idx, dut.fsm_state, dut.key_expansion_in, dut.key_expansion_out, out, out_type);
            for (int j = 0; j < 10; j++) begin
                // $display("stage_key_regs[%0d] = %h", j, dut.stage_key_regs[j]);
                if (j == 8) begin
                    $display("stage_out_regs[%0d] = %h [%2b]", j, dut.last_stage_in, dut.last_stage_type);
                end else if (j == 9) begin
                    $display("stage_out_regs[%0d] = %h [%2b]", j, dut.out, dut.out_type);
                end else begin
                    $display("stage_out_regs[%0d] = %h [%2b]", j, dut.stage_out_regs[j], dut.stage_type[j]);
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
    // initial begin
    //     $monitor("Time: %0t | Start: %b | State: %h | Key: %h | Out: %h | Valid: %b", 
    //              $time, start, state, key, out, out_valid);
    // end

endmodule
