module clk_divider (
    input clk,rst,
    output reg clk_out
);
reg [24:0] count;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        count <= 0;
        clk_out <= 0;
    end else begin
        if (count < 250000) begin
            count <= count + 1;
        end else begin
            clk_out <= ~clk_out; 
            count <= 0; 
        end
    end
end
endmodule