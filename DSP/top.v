module top(A,B,C,D,CLK,CARRYIN,OPMODE,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE
,CEA,CEB,CEC,CED,CEM,CMP,CEOPMODE,CECARRYIN,PCIN,BCIN
,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

parameter A0REG = 0,A1REG = 1,B0REG = 0,B1REG = 1,CREG = 1,DREG = 1,MREG = 1,PREG = 1;
parameter CARRYINREG = 1,CARRYOUTREG = 1,OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";

  input [17:0] A;
  input [17:0] B,BCIN;
  input [47:0] C,PCIN;
  input [17:0] D;
  input [7:0] OPMODE;
  input CLK;
  input CARRYIN;
  input RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
  input CEA,CEB,CEC,CED,CEM,CMP,CEOPMODE,CECARRYIN;
  output [47:0] PCOUT,P;
  output [17:0] BCOUT;
  output [35:0] M;
  output CARRYOUT,CARRYOUTF;

wire [17:0] A0_int,B0_int,D_int,A1_int,B_IN;
wire [47:0] C_int;
wire [35:0] multiplier;
wire [17:0] D_B,pre;
wire CYI,CIN,CO;
wire [47:0] post; 
wire [7:0] OPMODE_int;
reg [47:0]MUX_X_out,MUX_Z_out;

assign pre = (OPMODE_int[6]) ? (D_int - B0_int) : (D_int + B0_int);
assign D_B = (OPMODE_int[4]) ? pre : B0_int;
assign multiplier = BCOUT*A1_int;
assign PCOUT = P;
assign CYI = (CARRYINSEL=="OPMODE5") ? OPMODE_int[5] : CARRYIN;
assign {CO,post} = (~OPMODE_int[7]) ? (MUX_Z_out + MUX_X_out + CIN)  : (MUX_Z_out - (MUX_X_out + CIN) );
assign CARRYOUTF = CARRYOUT;
assign B_IN = (B_INPUT=="CASCADE") ? BCIN : B;

PIPELINE #(.WIDTH(18), .RSTTYPE(RSTTYPE), .INREG(A0REG)) A0_reg (
  .in(A), .clk(CLK), .clk_en(CEA), .rst(RSTA), .out(A0_int));

PIPELINE #(.WIDTH(18), .RSTTYPE(RSTTYPE), .INREG(B0REG)) B0_reg (
  .in(B_IN), .clk(CLK), .clk_en(CEB), .rst(RSTB), .out(B0_int));

PIPELINE #(.WIDTH(48), .RSTTYPE(RSTTYPE), .INREG(CREG)) C_reg (
  .in(C), .clk(CLK), .clk_en(CEC), .rst(RSTC), .out(C_int));

PIPELINE #(.WIDTH(18), .RSTTYPE(RSTTYPE), .INREG(DREG)) D_reg (
  .in(D), .clk(CLK), .clk_en(CED), .rst(RSTD), .out(D_int));

PIPELINE #(.WIDTH(18), .RSTTYPE(RSTTYPE), .INREG(A1REG)) A1_reg (
  .in(A0_int), .clk(CLK), .clk_en(CEA), .rst(RSTA), .out(A1_int));

PIPELINE #(.WIDTH(18), .RSTTYPE(RSTTYPE), .INREG(B1REG)) D_B_reg (
  .in(D_B), .clk(CLK), .clk_en(CEB), .rst(RSTB), .out(BCOUT));

PIPELINE #(.WIDTH(36), .RSTTYPE(RSTTYPE), .INREG(MREG)) M_reg (
  .in(multiplier), .clk(CLK), .clk_en(CEM), .rst(RSTM), .out(M));

PIPELINE #(.WIDTH(1), .RSTTYPE(RSTTYPE), .INREG(CARRYINREG)) CARRYIN_reg (
    .in(CYI), .clk(CLK), .clk_en(CECARRYIN), .rst(RSTCARRYIN), .out(CIN));

PIPELINE #(.WIDTH(48), .RSTTYPE(RSTTYPE), .INREG(PREG)) P_reg (
    .in(post), .clk(CLK), .clk_en(CMP), .rst(RSTP), .out(P));

PIPELINE #(.WIDTH(8), .RSTTYPE(RSTTYPE), .INREG(OPMODEREG)) OPMODE_reg (
    .in(OPMODE), .clk(CLK), .clk_en(CEOPMODE), .rst(RSTOPMODE), .out(OPMODE_int));

PIPELINE #(.WIDTH(1), .RSTTYPE(RSTTYPE), .INREG(CARRYOUTREG)) CYO_reg (
    .in(CO), .clk(CLK), .clk_en(CECARRYIN), .rst(RSTCARRYIN), .out(CARRYOUT));

    always @(*) begin

            case (OPMODE_int[1:0]) 
                2'b00:  MUX_X_out = 0;
                2'b01:  MUX_X_out = {12'b0, M};
                2'b10:  MUX_X_out = P[47:0];
                2'b11:  MUX_X_out = {D_int[11:0], A0_int[17:0], B0_int[17:0]};
            endcase
    end

    always @(*) begin

            case (OPMODE_int[3:2]) 
                2'b00:  MUX_Z_out = 0;
                2'b01:  MUX_Z_out = PCIN[47:0];
                2'b10:  MUX_Z_out = P[47:0];
                2'b11:  MUX_Z_out = C_int[47:0];
            endcase
    end

endmodule