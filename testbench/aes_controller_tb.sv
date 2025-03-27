`timescale 1ns/1ps

`include "sysdef.svh"

module aes_controller_tb;

    // Testbench signals
    logic clk;
    logic rst_n;
    in_packet_t data_in;
    in_packet_t data_out;
    logic load_data;
    logic [127:0] key_out;
    logic [10:0] set_key_onehot;

    // Clock generation (10ns period = 100MHz)
    always #5 clk = ~clk;

    // DUT instantiation
    aes_controller DUT (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out),
        .load_data(load_data),
        .key_out(key_out),
        .set_key_onehot(set_key_onehot)
        // .set_inv_key() // Uncomment if needed
    );

    initial begin
        clk = 0;
        rst_n = 0;
    
        data_in = '{default:0};
    
        // Release reset after a few cycles
        #20;
        rst_n = 1;
    
        // Apply stimulus after reset
        repeat (5) @(posedge clk);
    
        // Example stimulus using your struct
        data_in.valid   = 1'b1;
        data_in.data    = 128'hDEADBEEF_CAFE1234_5678ABCD_01234567;
        data_in.en_de   = 1'b1;
        data_in.set_key = 1'b0;
    
        @(posedge clk);
    
        // Additional test stimulus example
        data_in.valid   = 1'b1;
        data_in.data    = 128'h000102030405060708090a0b0c0d0e0f;
        data_in.en_de   = 1'b0;
        data_in.set_key = 1'b1;
    
        @(posedge clk);
        @(negedge clk);
        data_in.set_key = 1'b0;
    
        // Complete simulation
        #150;
        $finish;
    end
    
    // Monitor key and set_key_onehot outputs
    initial begin
        $display("Time\t\tclk\treset\tload_data\t\tkey_out\t\t\tset_key_onehot");
        $monitor("%0t\t%b\t%b\t%b\t%h\t%b", $time, clk, rst_n, load_data, key_out, set_key_onehot);
    end


endmodule
