`timescale 1ns/1ps

module top_tb();
    reg clk;
    reg rst;
    reg [7:0] SW;
    reg PB1, PB2, PB3;
    reg [7:0] A,B,tmp;
    wire [7:0] LED;
    wire [6:0] seg;
    integer i;

    Top uut (
        .clk(clk),
        .rst(rst),
        .SW(SW),
        .PB1(PB1),
        .PB2(PB2),
        .PB3(PB3),
        .LED(LED),
        .seg(seg)
    );

    initial clk = 0;
    always #10 clk = ~clk; 

    initial begin
        rst = 1;
        SW  = 8'd0;
        PB1 = 0; PB2 = 0; PB3 = 0;
        #100 rst = 0;  

            for (i = 1; i <= 6; i = i + 1) begin
                
            A = $random;
            B = $random;

            if (i == 2 && A < B) begin
                tmp = A; A = B; B = tmp;
            end

                // PB1
                PB1 = 1; PB2 = 0; PB3 = 0;
                SW = $random; A=SW;
                repeat(4000000) @(negedge clk);
                
                // PB2
                PB1 = 0; PB2 = 1; PB3 = 0;
                SW = $random; B=SW;
                repeat(4000000) @(negedge clk);

                if (i==2) begin
                    if (A < B) 
                    {A, B} = {B, A};  
                end

                // PB3
                PB1 = 0; PB2 = 0;PB3 = 1;  
                SW = {5'b00000, i};    
                repeat(4000000) @(negedge clk);
            
                // All released
                PB1 = 0; PB2 = 0; PB3 = 0;
                repeat(4000000) @(negedge clk);

                $display("--------------------------");
            end
        $stop;
    end

    initial begin
        $monitor("A:%b, B:%b, mode:%b, segment:%b",A,B,SW[2:0],seg);
    end
endmodule
