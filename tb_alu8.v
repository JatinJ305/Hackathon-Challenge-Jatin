`timescale 1ns/1ps
module tb_alu8;
    reg  [7:0] A, B;
    reg  [3:0] op;
    reg  [2:0] sh;
    wire [7:0] Y;
    wire Z,C,N,V;

    alu8_sky130 dut(.A(A),.B(B),.opcode(op),.shamt(sh),.Y(Y),.Z(Z),.C(C),.N(N),.V(V));

    task t(input[7:0]a,b,input[3:0]o,input[2:0]s);
    begin A=a;B=b;op=o;sh=s; #1;
        $display("op=%h A=%h B=%h sh=%0d -> Y=%h Z=%b C=%b N=%b V=%b",
                  o,a,b,s,Y,Z,C,N,V);
    end endtask

    initial begin
        t(8'h14,8'h22,4'h0,0);
        t(8'hFE,8'h02,4'h0,0);
        t(8'h10,8'h01,4'h1,0);
        t(8'hFF,8'h00,4'h2,0);
        t(8'h00,8'h00,4'h3,0);
        t(8'hA5,8'h3C,4'h4,0);
        t(8'b10110110,0,4'h8,3);
        t(8'b10110110,0,4'h9,3);
        t(8'b10110110,0,4'hA,3);
        $finish;
    end
endmodule

