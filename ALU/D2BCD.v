module Dec2BCD_converter(
    input [8:0] Dec_in,
    output reg [11:0] BCD_out
);
reg [3:0] hundreds, tens, ones;
reg [6:0] temp_reg;
always @(*) begin
        hundreds = Dec_in / 100;
        temp_reg=Dec_in % 100;
        tens = temp_reg / 10;
        ones = temp_reg % 10;
        BCD_out = {hundreds, tens, ones};  
end
endmodule