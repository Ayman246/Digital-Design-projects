module AN_selector(
    input clk_out,rst_db,
    output reg [1:0] sel,
    output reg [3:0] AN_sel
);
    always @(posedge clk_out or posedge rst_db) begin
    if (rst_db) begin
        sel <= 2'b00; 
    end else begin
        sel <= sel + 1; 
    end 
end
    always @(* ) begin
        case (sel)
            2'b00:   AN_sel <= 4'b1110;  
            2'b01:   AN_sel <= 4'b1101;  
            2'b10:   AN_sel <= 4'b1011; 
            2'b11:   AN_sel <= 4'b0111; 
            default: AN_sel <= 4'b1111; 
        endcase
    end
endmodule

module mux (
    input [11:0] BCD_in,
    input [3:0] letters,
    input [1:0] sel,
    output reg [3:0] digit
);
always @(*) begin
    case (sel)
        2'b00: digit = BCD_in[3:0];   
        2'b01: digit = BCD_in[7:4];   
        2'b10: digit = BCD_in[11:8];
        2'b11: digit = letters;
        default: digit = 4'b0000;      
    endcase
end
endmodule