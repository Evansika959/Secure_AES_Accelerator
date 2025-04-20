module clk_div (
    input  wire clk,           
    input  wire rstn,          
    output reg  clk_div2_out,  
    output wire  clk_div5_out   
);

    // 3-bit counter for ÷5
    reg cnt5_pos;
    reg cnt5_neg;

    reg [2:0] cnt;

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            clk_div2_out <= 1'b0;
        else
            clk_div2_out <= ~clk_div2_out;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt5_pos <= 1'b0;
        end else if (cnt == 3'd2) begin
            cnt5_pos <= 1'b1;
        end else if (cnt == 3'd4) begin
            cnt5_pos <= 1'b0;
        end
    end 
    
     always @(negedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt5_neg <= 1'b0;
        end else if (cnt == 3'd2) begin
            cnt5_neg <= 1'b1;
        end else if (cnt == 3'd4) begin
            cnt5_neg <= 1'b0;
        end
    end 
    
    always @(negedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt <= 3'b0;
        end else if (cnt == 3'd4) begin
            cnt <= 3'b0;
        end else begin
            cnt <= cnt + 1;
        end
    end
    
    assign clk_div5_out = cnt5_pos | cnt5_neg;

endmodule