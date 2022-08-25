module dff(q,d,rst,clk);
input d,clk,rst;
output reg q;

always@(posedge clk or posedge rst)
begin
if(rst==1)
q<=1'b0;
else
 q<=d;
end
endmodule


module mux4to1(in,sel,out);
   
   input [3:0] in;
   input [1:0] sel;
   output out;
   
   assign out=in[sel];
endmodule



module and_gate(i1,i2,o);
   input i1,i2;
   output o;
   
   assign o=i1&i2;
endmodule

module Bus_arbiter(RA,RB,GA,GB,rst,clk);

input RA,RB,clk,rst;
output GA,GB;

wire [3:0]a;
wire [3:0]c;
wire [1:0]b;
wire [1:0]d;

wire t1,t2,t3,t4,t5,t6;

assign t5=~RA;
assign t6=~RB;


assign b[1]=t3;
assign d[1]=t3;
assign b[0]=t4;
assign d[0]=t4;
and_gate And1(t5,RB,a[0]);
and_gate And2(t5,RB,a[1]);
and_gate And3(1'b1,RB,a[2]);
and_gate And4(1'b0,1'b0,a[3]);

and_gate And5(1'b1,RA,c[0]);
and_gate And6(1'b1,RA,c[1]);
and_gate And7(RA,t6,c[2]);
and_gate And8(1'b0,1'b0,c[3]);


mux4to1 M1(a,b,t1);
mux4to1 M2(c,d,t2);

dff D1(t3,t1,rst,clk);
dff D2(t4,t2,rst,clk);

assign GA=~t3&t4;

assign GB=t3&~t4;
endmodule

module bus_arbiter_test;

reg rst1,rst2,clk,rst;
wire grt1,grt2;

Bus_arbiter B1(rst1,rst2,grt1,grt2,rst,clk);
initial
assign clk=1'b0;
always
#5 assign clk=~clk;

initial
begin
$dumpfile("Bus_arbiter.vcd");
$dumpvars(0,bus_arbiter_test);
$monitor($time,"rst1=%b,rst2=%b,grt1=%b,grt2=%b,clk=%b,rst=%b",rst1,rst2,grt1,grt2,clk,rst);

#0 rst=1;
#1 rst1=0; rst2=1;rst=0;
#5 rst1=1; rst2=1;
#5 rst1=1; rst2=0;
#5 rst1=1; rst2=1;
#5 rst1=0; rst2=1;
#2 rst1=1; rst2=1;
#8 rst1=0; rst2=0;
#5 rst1=1; rst2=1;
#15$finish;
end
endmodule

       
   
