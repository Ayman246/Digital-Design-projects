module D_FF (
    input clk,
    input rst,
    input PB,
    output reg PB_db
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PB_db <= 0;
        end else begin
            PB_db <= PB;
        end
    end
endmodule