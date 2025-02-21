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


    int file;
    int status;
    string line;

    // Test sequence
    initial begin
        // open file
        file = $fopen("../run/encrypt_goldenbrick_in", "r");
        if (file == 0) begin
            $display("Error: Could not open file!");
            $finish;
        end
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
        
        

        // Read Testcase from file 
        while (!$feof(file)) begin
            #10;
            set_key = 0;
            in_type = ENCRYPT;

            status = $fgets(line, file);
            if (status != 0) begin
                status = $sscanf(line, "%h", state);
                if (status == 1) begin
                $display("Read plaintext: %h", state);
                // You can store the plaintext_data in a register array if needed
                end else begin
                $display("Error parsing line: %s", line);
                end
            end


        end


        //

        #10;
        // Additional test case: halt scenario
        halt = 1;
        #10 halt = 0;

        // Finish simulation
        #50;
        $finish;
    end


    // Output file
    int file_output;
    initial begin
      file_output = $fopen("../run/aes_out", "w");
      if (file_output == 0) begin
        $display("Error: Could not open output file!");
        $finish;
      end
    
      forever begin
        @(posedge clk);
        if (out_type == ENCRYPT) begin
          $fwrite(file_output, "%h\n", out);
        end
      end
    end

endmodule
