`timescale 1ns/1ps
`include "sysdef.svh"  // Ensure that job_t and related definitions are available

module aes_engine_tb;

   // Signals
    logic clk;
    logic rstn;
    in_packet_t data_in, input_buffer_in;
    out_packet_t data_out, output_buffer_in;
    logic load_data;
    logic start;
    logic wr_en_input;

    // DUT instantiation
    aes_engine DUT (
        .clk(clk),
        .rstn(rstn),
        .data_in(data_in),
        .data_out(data_out),
        .load_data(load_data)
    );

    fifo # (
    .DEPTH(32),
    .WIDTH(131)
    )
    input_buffer_inst (
        .clk(clk),
        .rstn(rstn),
        .wr_en(wr_en_input),
        .rd_en(load_data & start),
        .din(input_buffer_in),
        .dout(data_in),
        .full(_),
        .empty(_)
    );



    // Clock generation: 100MHz
    always #5 clk = ~clk;

    int file;
    int status;
    string line;
    // Test sequence
    initial begin
        // Initialization
        file = $fopen("../run/tb_input.txt", "r");
        if (file == 0) begin
            $display("Error: Could not open file!");
            $finish;
        end

        clk = 0;
        rstn = 0;

        // Reset assertion
        #20;
        rstn = 1;

        #10;
        // fill the input buffer
        wr_en_input = 1;
        while (!$feof(file)) begin
            // Read the next line
            status = $fgets(line, file);
            if (status == 0) begin
                $display("Error: Could not read file here!");
                wr_en_input = 0;
                break;
            end
            $sscanf(line, "%h %b %b", input_buffer_in.data, input_buffer_in.en_de, input_buffer_in.set_key);
            input_buffer_in.valid = 1;

            // $display("input data: %h", data_in.data);
            #10;
        end

        #10;
        start = 1;

        #1000;
        
        // End simulation
        #20;
        $finish;
    end

    int line_count = 0;
    int max_lines = 1000;  // Set your desired number of output lines here
    int file_output;

    initial begin
    file_output = $fopen("../run/aes_out.txt", "w");
    if (file_output == 0) begin
      $display("Error: Could not open output file!");
      $finish;
    end

    forever begin
      @(posedge clk);
      if (data_out.valid) begin
        $fwrite(file_output, "%h %b\n", data_out.data, data_out.en_de);
        line_count++;

          if (line_count >= max_lines) begin
            $display("Reached maximum number of output lines (%0d). Closing file.", max_lines);
            $fclose(file_output);
            $finish; // or use `disable` to exit only this block if desired
          end
        end
      end
    end

    initial begin
      int cycle_count = 0;
      int max_cycles = 1000;  // Set the desired number of cycles here

      forever begin
        @(posedge clk);
        cycle_count++;

        if (cycle_count >= max_cycles) begin
          $display("Reached maximum simulation cycles (%0d). Ending simulation.", max_cycles);
          $finish;
        end
      end
    end
endmodule
