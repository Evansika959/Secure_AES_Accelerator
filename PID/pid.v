`define PRECISION 8

//  PID values coming from outside or interal flip flops, guessing we store in flash memory???

module pid (
    input   wire                        clk,
    input   wire                        reset,

    input   wire    [`PRECISION-1:0]    target,
    input   wire    [`PRECISION-1:0]    current,

    input   wire    [`PRECISION-1:0]    kp,
    input   wire    [`PRECISION-1:0]    ki,
    input   wire    [`PRECISION-1:0]    kd,

    output  wire                        out
);

    wire    [`PRECISION-1:0]    error;
    wire    [`PRECISION-1:0]    derivative;
    reg     [`PRECISION-1:0]    integral;

    reg     [`PRECISION-1:0]    prev_error, current_error;

    assign error = target - current;
    assign derivative = current_error - prev_error;

    assign out = kp * error + ki * integral + kd * derivative;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_error   <=  0;
            prev_error      <=  0;
            integral        <=  0;
        end else begin
            current_error   <=  error;
            prev_error      <=  current_error;
            integral        <=  integral + error;
        end
    end
endmodule