module Top(
    input clk, rst,
    input [7:0] SW,
    input PB1, PB2, PB3,
    output [7:0] LED,
    output [6:0] seg
);

    wire q1,q2,q3;
    wire Q1,Q2,Q3;
    wire PB1_db, PB2_db, PB3_db,rst_db;
    wire clk_out;
    wire [3:0] letters;
    wire [3:0] AN_sel, digit;
    wire [1:0] sel;
    wire [8:0] C_out;
    wire [11:0] BCD_in;
    assign rst_db = rst;

    clk_divider clk_Div (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );
    D_FF db1_1 (
        .clk(clk_out),
        .rst(rst),
        .PB(PB1),
        .PB_db(q1)
    );
    D_FF db1_2 (
        .clk(clk_out),
        .rst(rst),
        .PB(q1),
        .PB_db(Q1)
    );
    assign PB1_db = q1 & ~Q1;
    D_FF db2_1 (
        .clk(clk_out),
        .rst(rst),
        .PB(PB2),
        .PB_db(q2)
    );
    D_FF db2_2 (
        .clk(clk_out),
        .rst(rst),
        .PB(q2),
        .PB_db(Q2)
    );
    assign PB2_db = q2 & ~Q2;
    D_FF db3_1 (
        .clk(clk_out),
        .rst(rst),
        .PB(PB3),
        .PB_db(q3)
    );
    D_FF db3_2 (
        .clk(clk_out),
        .rst(rst),
        .PB(q3),
        .PB_db(Q3)
    );
    assign PB3_db = q3 & ~Q3;

    ALU alu_inst (
        .SW(SW),
        .PB1_db(PB1_db),
        .PB2_db(PB2_db),
        .PB3_db(PB3_db),
        .clk(clk),
        .rst_db(rst_db),
        .LED(LED),
        .C_out(C_out),
        .letters(letters)
    );
    Dec2BCD_converter D2BCD_inst (
        .Dec_in(C_out), 
        .BCD_out(BCD_in)
    );
    AN_selector an_sel_inst (
        .clk_out(clk_out),
        .rst_db(rst_db),
        .sel(sel),
        .AN_sel(AN_sel)
    );
    mux mux_inst (
        .BCD_in(BCD_in),
        .sel(sel),
        .digit(digit),
        .letters(letters)
    );
   seg_decoder seg_decoder_inst (
        .digit(digit),
        .seg(seg)
    );
endmodule