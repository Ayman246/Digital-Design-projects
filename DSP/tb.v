module tb ();

localparam A0REG = 0,A1REG = 1,B0REG = 0,B1REG = 1,CREG = 1,DREG = 1,MREG = 1,PREG = 1;
localparam CARRYINREG = 1,CARRYOUTREG = 1,OPMODEREG = 1;
localparam CARRYINSEL = "OPMODE5";
localparam B_INPUT = "DIRECT";
localparam RSTTYPE = "SYNC";

  reg [17:0] A;
  reg [17:0] B,BCIN;
  reg [47:0] C,PCIN;
  reg [17:0] D;
  reg [7:0] OPMODE;
  reg CLK;
  reg CARRYIN,CIN;
  reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
  reg CEA,CEB,CEC,CED,CEM,CMP,CEOPMODE,CECARRYIN;

  wire [47:0] PCOUT,P;
  wire [17:0] BCOUT;
  wire [35:0] M;
  wire CARRYOUT,CARRYOUTF;

  integer i;

top #(.A0REG(A0REG),.A1REG(A1REG),.B0REG(B0REG),.B1REG(B1REG),.CREG(CREG),.DREG(DREG),.MREG(MREG),.PREG(PREG)
,.CARRYINREG(CARRYINREG),.CARRYOUTREG(CARRYOUTREG),.OPMODEREG(OPMODEREG)
,.CARRYINSEL(CARRYINSEL),.B_INPUT(B_INPUT),.RSTTYPE(RSTTYPE)
) dut (
.A(A),.B(B),.C(C),.D(D),.CLK(CLK),.CARRYIN(CARRYIN),.OPMODE(OPMODE)
,.RSTA(RSTA),.RSTB(RSTB),.RSTM(RSTM),.RSTP(RSTP),.RSTC(RSTC),.RSTD(RSTD),.RSTCARRYIN(RSTCARRYIN),.RSTOPMODE(RSTOPMODE)
,.CEA(CEA),.CEB(CEB),.CEC(CEC),.CED(CED),.CEM(CEM),.CMP(CMP),.CEOPMODE(CEOPMODE),.CECARRYIN(CECARRYIN)
,.PCIN(PCIN),.BCIN(BCIN)
,.BCOUT(BCOUT),.PCOUT(PCOUT),.P(P),.M(M),.CARRYOUT(CARRYOUT),.CARRYOUTF(CARRYOUTF)
);  

initial begin
  CLK = 0;
  forever #10 CLK = ~CLK;
end

initial begin

// Active reset and disable clock
  $display("############################");
  A = 0; B = 0; C = 0; D = 0; OPMODE = 0; CARRYIN = 0;
  RSTA = 1; RSTB = 1; RSTM = 1; RSTP = 1; RSTC = 1; RSTD = 1; RSTCARRYIN = 1; RSTOPMODE = 1;
  CEA = 0; CEB = 0; CEC = 0; CED = 0; CEM = 0; CMP = 0; CEOPMODE = 0; CECARRYIN = 0;
  PCIN = 0; BCIN = 0;
  
  repeat (2) @(negedge CLK);
// Deactive reset and enable clock
 $display("############################");
  RSTA = 0; RSTB = 0; RSTM = 0; RSTP = 0; RSTC = 0; RSTD = 0; RSTCARRYIN = 0; RSTOPMODE = 0;
  CEA = 1; CEB = 1; CEC = 1; CED = 1; CEM = 1; CMP = 1; CEOPMODE = 1; CECARRYIN = 1;
  repeat (2) @(negedge CLK);

// random test
$display("############################");
  
  for (i=0; i<256; i=i+1) begin
    repeat (2) begin
    A = $random; B = $random; C = $random; D = $random; OPMODE = i; CARRYIN = $random; PCIN = $random; BCIN = $random;
    CIN = (CARRYINSEL=="OPMODE5") ? OPMODE[5] : CARRYIN;
    
    repeat (3) @(negedge CLK);
    if(OPMODE[6] && OPMODE[4]) begin
      if(BCOUT !== (D-B)) begin 
        $display("Warning: unexpected result in pre-subtraction");
        $stop;
      end
    end
    
    if(~OPMODE[6] && OPMODE[4]) begin
      if(BCOUT !== (D+B)) begin 
        $display("Warning: unexpected result in pre-addition");
        $stop;
      end
    end
    if(M !== (BCOUT*A)) begin 
        $display("Warning: unexpected result in multiplication");
        $stop;
      end

    end
end 
    $display("############################");
    $display("Random test completed");
    $display("############################");

// directed test for the post adder/subtractor
//test 1 
    A=4; B=5; C=8; D=10; OPMODE=8'b10000000; CARRYIN=0;  
repeat (3)@(negedge CLK);
    if (~OPMODE[7]) begin
      if ({CARRYOUT, P} !== 0) begin
        $display("Warning: unexpected result in post-addition");
        $stop;
      end
    end else begin
      if ({CARRYOUT, P} !== 0) begin
        $display("Warning: unexpected result in post-subtraction");
        $stop;
      end
    end
    
    //test 2
    OPMODE=8'b10001010;
    repeat (3)@(negedge CLK);
    if (~OPMODE[7]) begin
      if ({CARRYOUT, P} !== 2*P) begin
        $display("Warning: unexpected result in post-addition");
        $stop;
      end
    end else begin
      if ({CARRYOUT, P} !== 0) begin
        $display("Warning: unexpected result in post-subtraction");
        $stop;
      end
    end
    $display("############################");
    $display("Simulation completed");
    $display("############################");
$stop;
end

initial begin
  $monitor("A:%h B:%h C:%h D:%h OPMODE:%b CARRYIN:%b | P:%h M:%h BCOUT:%h CARRYOUT:%b CARRYOUTF:%b"
  ,A,B,C,D,OPMODE,CARRYIN,P,M,BCOUT,CARRYOUT,CARRYOUTF);
end

endmodule