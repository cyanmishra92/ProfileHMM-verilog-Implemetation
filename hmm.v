`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Cyan Subhra Mishra 
// Email: cyanmishra92@gmail.com
// Create Date: 11/25/2015 11:12:15 AM
// Design Name: 
// Module Name: hmm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hmm(a11,a12,a13,a14,a21,a22,a23,a24,a31,a32,a33,a34,a41,a42,a43,a44,bk1,bk2,bk3,bk4,max);
input wire [31:0] a11,a12,a13,a14,a21,a22,a23,a24,a31,a32,a33,a34,a41,a42,a43,a44;
input wire [31:0] bk1,bk2,bk3,bk4;
output wire [63:0] max;
wire [63:0] H [6:1];
ComputeEngine uut1 (a11,bk1,a12,bk2,a13,bk3,a14,bk4,H[1]);
ComputeEngine uut2 (a21,bk1,a22,bk2,a23,bk3,a24,bk4,H[2]);
ComputeEngine uut3 (a31,bk1,a32,bk2,a33,bk3,a34,bk4,H[3]);
ComputeEngine uut4 (a41,bk1,a42,bk2,a43,bk3,a44,bk4,H[4]);
max  uut5 (H[1],H[2],H[5]);
max  uut6 (H[3],H[4],H[6]);
max  uut7 (H[5],H[6],max);

endmodule
module ComputeEngine(a11,b1k,a12,b2k,a13,b3k,a14,b4k,sum);
input wire [31:0]  a11,b1k,a12,b2k,a13,b3k,a14,b4k;
output wire [63:0] sum;
wire [63:0] mul1,mul2,mul3,mul4,max1,max2;

booth_mul uut1 (a11,b1k,mul1,1);
booth_mul uut2 (a12,b2k,mul2,1);
booth_mul uut3 (a13,b3k,mul3,1);
booth_mul uut4 (a14,b4k,mul4,1);
cla64     uut5 (mul1,mul2,0,max1);
cla64     uut6 (mul3,mul4,0,max2);
cla64     uut7 (max1,max2,0,sum);
endmodule
module booth_mul(X,Y,Z,en);
    input signed [31:0] X, Y;
       input en;
           output signed [63:0] Z;
           reg signed [63:0] Z;
           reg [1:0] temp;
           integer i;
           reg E1;
           reg [31:0] Y1;
           always @ (X, Y,en)
           begin
           Z = 64'd0;
           E1 = 1'd0;
           if (en == 1'b1)
           begin
           Z [31 : 0] = Z [31 : 0]+X;
           for (i = 0; i < 32; i = i + 1)
           begin
           temp = {X[i], E1};
           //The above statement is catenation
                 
                  Y1 = - Y;
                 
                      //Y1 is the 2' complement of Y
                 
                  case (temp)
                  2'd2 : Z [63 : 32] = Z [63 : 32] + Y1;
                  2'd1 : Z [63 : 32] = Z [63 : 32] + Y;
                  default : begin end
                  endcase
                  Z = Z >> 1;
                  /*The above statement is a logical shift of one position to
                      the right*/
                 
                  Z[63] = Z[62];
                  /*The above two statements perform arithmetic shift where
                  the sign of the number is preserved after the shift. */
                 
                  E1 = X[i];
                      end
                  if(Y==32'd2147483648)
                 
                  /*If Y = 10000000000000000000000000000000; then according to our code,
                  Y1 = 10000000000000000000000000000000 (-2147483648 not 2147483648, because Y1 is 32 bits only).
                  The statement sum = - sum adjusts the answer.*/
                 
                      begin
                          Z = - Z;
                      end
                      end
                  end
endmodule

module max(a,b,out);
input wire [63:0] a,b;
output reg [63:0] out;
always @(a,b)
begin
if(a > b)
out <= a;
else
out <= b;
end
endmodule
module cla64(
    input [63:0] d1,
    input [63:0] d2,
    input cin,
    output [63:0] sum
    );
    wire [14:0] c;
    reg [63:0] b;
    wire d;
    always@( d1,d2,cin)
    begin
     if(cin==1)
     b<=-d2;
     else
     b<=d2;
     end
   // always@(posedge clk)
    //begin
    cla4 n1(d1[3:0],b[3:0],cin,sum[3:0],c[0]);
    cla4 n2(d1[7:4],b[7:4],c[0],sum[7:4],c[1]);
    cla4 n3(d1[11:8],b[11:8],c[1],sum[11:8],c[2]);
    cla4 n4(d1[15:12],b[15:12],c[2],sum[15:12],c[3]);
    cla4 n5(d1[19:16],b[19:16],c[3],sum[19:16],c[4]);
    cla4 n6(d1[23:20],b[23:20],c[4],sum[23:20],c[5]);
    cla4 n7(d1[27:24],b[27:24],c[5],sum[27:24],c[6]);
    cla4 n8(d1[31:28],b[31:28],c[6],sum[31:28],c[7]);
    cla4 n9(d1[35:32],b[35:32],c[7],sum[35:32],c[8]);
    cla4 n10(d1[39:36],b[39:36],c[8],sum[39:36],c[9]);
    cla4 n11(d1[43:40],b[43:40],c[9],sum[43:40],c[10]);
    cla4 n12(d1[47:44],b[47:44],c[10],sum[47:44],c[11]);
    cla4 n13(d1[51:48],b[51:48],c[11],sum[51:48],c[12]);
    cla4 n14(d1[55:52],b[55:52],c[12],sum[55:52],c[13]);
    cla4 n15(d1[59:56],b[59:56],c[13],sum[59:56],c[14]);
    cla4 n16(d1[63:60],b[63:60],c[14],sum[63:60],d);
    //end
    endmodule
module cla4(
        input [3:0] a,
        input [3:0] b,
        input cin,
        output [3:0] s,
        output cout
        );
        wire[3:0] g,p; 
        wire[13:0] z;
        xor21 x1  (.a(a[0]), .b(b[0]), .z(p[0]));
        and21 x2  (.a(a[0]), .b(b[0]), .z(g[0]));
        xor21 x3  (.a(a[1]), .b(b[1]), .z(p[1]));
        and21 x4  (.a(a[1]), .b(b[1]), .z(g[1]));
        xor21 x5  (.a(a[2]), .b(b[2]), .z(p[2]));
        and21 x6  (.a(a[2]), .b(b[2]), .z(g[2]));
        xor21 x7  (.a(a[3]), .b(b[3]), .z(p[3]));
        and21 x8  (.a(a[3]), .b(b[3]), .z(g[3]));
        xor21 x9  (.a(cin),  .b(p[0]), .z(s[0]));
        and21 x10 (.a(cin),  .b(p[0]), .z(z[0]));
        or21  x11 (.a(z[0]), .b(g[0]), .z(z[1]));
        xor21 x12 (.a(z[1]), .b(p[1]), .z(s[1]));
        and31 x13 (.a(cin),  .b(p[0]), .c(p[1]),.z(z[2]));
        and21 x14 (.a(g[0]), .b(p[1]), .z(z[3]));
        or31  x15 (.a(z[2]), .b(z[3]), .c(g[1]),.z(z[4]));
        xor21 x16 (.a(z[4]), .b(p[2]), .z(s[2]));
        and41 x17 (.a(cin),  .b(p[0]), .c(p[1]),.d(p[2]),.z(z[5]));
        and31 x18 (.a(g[0]), .b(p[1]), .c(p[2]),.z(z[6]));
        and21 x19 (.a(g[1]), .b(p[2]), .z(z[7]));
        or41  x20 (.a(z[5]), .b(z[6]), .c(z[7]),.d(g[2]),.z(z[8]));
        xor21 x21 (.a(z[8]), .b(p[3]), .z(s[3]));
        and41 x22 (.a(cin),  .b(p[0]), .c(p[1]),.d(p[2]),.z(z[9]));
        and31 x23 (.a(g[0]), .b(p[1]), .c(p[2]),.z(z[10]));
        and21 x24 (.a(g[1]), .b(p[2]), .z(z[11]));
        or41  x25 (.a(z[9]), .b(z[10]),.c(z[11]),.d(g[2]),.z(z[12]));
        and21 x26 (.a(z[12]),.b(p[3]), .z(z[13]));
        or21  x27 (.a(z[13]),.b(g[3]), .z(cout));
    endmodule
    module and21(a,b,z);
    input a,b;
    output z;
    assign z = a&b;
    endmodule
    
    module and31(a,b,c,z);
    input a,b,c;
    output z;
    assign z = a & b & c;
    endmodule
    
    module and41(a,b,c,d,z);
    input a,b,c,d;
    output z;
    assign z = a & b & c & d;
    endmodule
    
    module or21(a,b,z);
    input a,b;
    output z;
    assign z = a|b;
    endmodule
    
    module or31(a,b,c,z);
    input a,b,c;
    output z;
    assign z = a|b|c;
    endmodule
    
    module or41(a,b,c,d,z);
    input a,b,c,d;
    output z;
    assign z = a|b|c|d;
    endmodule
    
    module xor21(a,b,z);
    input a,b;
    output z;
    assign z = a^b;
    endmodule