module PIPELINE (in, clk, clk_en, rst, out);
  
parameter WIDTH = 18;
parameter RSTTYPE = "ASYNC"; 
parameter INREG = 1;

  input [WIDTH-1:0] in;
  input clk,clk_en;
  input rst;
  output reg [WIDTH-1:0] out;

  generate
  if (INREG) begin 
    if (RSTTYPE == "ASYNC") begin 
      always @(posedge clk or posedge rst) begin
        if (rst) out <= {WIDTH{1'b0}};
        else if (clk_en) 
        out <= in;
      end
    end else begin 
      always @(posedge clk) begin
        if (rst) out <= {WIDTH{1'b0}};
        else if (clk_en) 
        out <= in;
      end
    end
  end else begin 
    always @ (*) out = in;
  end
endgenerate

endmodule