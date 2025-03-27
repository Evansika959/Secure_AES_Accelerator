`timescale 1ns/1ps
`include "sysdef.svh"  // Ensure that job_t and related definitions are available

module aes_engine_tb;

   // Signals
    logic clk;
    logic rst_n;
    in_packet_t data_in;
    out_packet_t data_out;
    logic load_data;

    // DUT instantiation
    aes_engine DUT (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out),
        .load_data(load_data)
    );

    // Clock generation: 100MHz
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialization
        clk = 0;
        rst_n = 0;
        data_in = '{valid: 0, data: 128'b0, en_de: 0, set_key: 0};

        // Reset assertion
        #20;
        rst_n = 1;

        // First transaction: Encryption
        #10;
        data_in = '{valid: 1, data: 128'h000102030405060708090a0b0c0d0e0f, en_de: 1, set_key: 1};
        #10;
        data_in.valid = 0;

        repeat (15) @(posedge clk);

        #10;
        data_in = '{valid: 1, data: 128'hffeeddccbbaa99887766554433221100, en_de: 0, set_key: 0};
        #10;
        data_in.valid = 0;

        repeat (15) @(posedge clk);

        // End simulation
        #20;
        $finish;
    end
endmodule
