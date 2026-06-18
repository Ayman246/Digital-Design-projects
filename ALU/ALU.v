module ALU (
    input [7:0] SW,
    input PB1_db, PB2_db, PB3_db, 
    input clk, rst_db,
    output reg [7:0] LED,
    output reg [3:0] letters,
    output reg [8:0] C_out
); 
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] mode;
    always @(posedge clk or posedge rst_db) begin
        if (rst_db) begin
            A <= 0;
            B <= 0;
            mode <= 0;
            C_out <= 9'd0;
            LED <= 8'd0;
            letters <= 4'd0;
        end else 
        begin if (PB1_db) begin
                A <= SW;
                LED <= SW;
                C_out <= SW;
                letters <= 4'hA;
            end else if (PB2_db) begin
                B <= SW;
                LED <= SW;
                C_out <= SW;
                letters <= 4'hB;
            end else if (PB3_db) begin
                mode <= SW[2:0];
                LED <= {5'b00000, SW[2:0]};
                letters <= 4'hC;
                case (SW[2:0])
                    3'b001: C_out <= A + B;
                    3'b010: C_out <= A - B;
                    3'b011: C_out <= {1'b0,-A};
                    3'b100: C_out <= {1'b0, A & B};
                    3'b101: C_out <= {1'b0, A | B};
                    3'b110: C_out <= {1'b0, A ^ B};
                    default: C_out <= 9'b0;
                endcase
            end
        end
        end
endmodule