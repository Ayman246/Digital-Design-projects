
module tb_Top;
    // Testbench signals
    reg clk;
    reg rst;
    reg [7:0] SW;
    reg PB1, PB2, PB3;
    wire [7:0] LED;
    wire [6:0] seg;

    // DUT
    Top dut (
        .clk(clk),
        .rst(rst),
        .SW(SW),
        .PB1(PB1),
        .PB2(PB2),
        .PB3(PB3),
        .LED(LED),
        .seg(seg)
    );

    // Clock generator (100 MHz)
    always #5 clk = ~clk;

    // Task: simulate a button press
   task pulse_btn(input integer id);
begin
    case (id)
        1: begin PB1 = 1; #1000; PB1 = 0; end // hold longer
        2: begin PB2 = 1; #1000; PB2 = 0; end
        3: begin PB3 = 1; #1000; PB3 = 0; end
    endcase
    #2000; // wait more for debouncer
end
endtask


    initial begin
        // Init
        clk = 0;
        rst = 1;
        PB1 = 0; PB2 = 0; PB3 = 0;
        SW = 8'd0;

        #100;
        rst = 0; // release reset
        #200;

        // ----------- TEST SEQUENCE -------------
        // Load A = 25
        SW = 8'd25;
        pulse_btn(1);

        // Load B = 15
        SW = 8'd15;
        pulse_btn(2);

        // Mode = ADD (001)
        SW = 8'b00000001;
        pulse_btn(3);

        // Mode = SUB (010)
        SW = 8'b00000010;
        pulse_btn(3);

        // Mode = NEG A (011)
        SW = 8'b00000011;
        pulse_btn(3);

        // Mode = AND (100)
        SW = 8'b00000100;
        pulse_btn(3);

        // Mode = OR (101)
        SW = 8'b00000101;
        pulse_btn(3);

        // Mode = XOR (110)
        SW = 8'b00000110;
        pulse_btn(3);

        // ---------------------------------------

        #1000;
        $stop;
    end

    // Monitor key signals
    initial begin
        $monitor("T=%0t | SW=%d | LED=%b | seg=%b | C_out=%d",
                 $time, SW, LED, seg, dut.C_out);
    end

endmodule
