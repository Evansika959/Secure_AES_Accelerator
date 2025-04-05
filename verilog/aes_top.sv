`include "sysdef.svh"

module aes_top (
    input clk,
    input rstn,
    input in_packet_t top_data_in,
    input input_valid,
    output out_packet_t top_data_out,
    output read_out
);

in_packet_t data_in;
out_packet_t data_out;
logic load_data;

input_buffer input_buffer_inst (
    .clk(clk),
    .rstn(rstn),
    .wr_en(input_valid),
    .rd_en(load_data),
    .din(top_data_in),
    .dout(data_in)
);

aes_engine aes_engine_inst (
    .clk(clk),
    .rstn(rstn),
    .data_in(data_in),
    .data_out(data_out),
    .load_data(load_data)
);

output_buffer output_buffer_inst (
    .clk(clk),
    .rstn(rstn),
    .wr_en(data_out.valid),
    .rd_en(read_out),
    .din(data_out),
    .dout(top_data_out)
);

endmodule
