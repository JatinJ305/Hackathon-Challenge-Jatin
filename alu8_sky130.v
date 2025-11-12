`timescale 1ns/1ps
module alu8_sky130 #(
    parameter WIDTH = 8
)(
    input      [WIDTH-1:0] A, B,
    input      [3:0]       opcode,
    input      [2:0]       shamt,
    output reg [WIDTH-1:0] Y,
    output reg             Z, C, N, V
);

    reg [1:0] sh_mode;
    wire [WIDTH-1:0] sh_out;
    wire             sh_cout;

    barrel_shifter #(.WIDTH(WIDTH)) u_sh (
        .in(A), .shamt(shamt), .mode(sh_mode),
        .out(sh_out), .cout(sh_cout)
    );

    wire [WIDTH:0] add_ext = {1'b0,A} + {1'b0,B};
    wire [WIDTH:0] sub_ext = {1'b0,A} + {1'b0,(~B+1'b1)};
    wire [WIDTH:0] inc_ext = {1'b0,A} + 1;
    wire [WIDTH:0] dec_ext = {1'b0,A} + { {WIDTH{1'b1}},1'b1};

    wire add_ov = (A[WIDTH-1]==B[WIDTH-1]) && (add_ext[WIDTH-1]!=A[WIDTH-1]);
    wire sub_ov = (A[WIDTH-1]!=B[WIDTH-1]) && (sub_ext[WIDTH-1]!=A[WIDTH-1]);

    always @* begin
        Y = 0; Z = 0; C = 0; N = 0; V = 0; sh_mode = 0;

        case(opcode)
            4'h0: begin Y=add_ext[WIDTH-1:0]; C=add_ext[WIDTH]; V=add_ov; end
            4'h1: begin Y=sub_ext[WIDTH-1:0]; C=sub_ext[WIDTH]; V=sub_ov; end
            4'h2: begin Y=inc_ext[WIDTH-1:0]; C=inc_ext[WIDTH]; V=(A[WIDTH-1]==0 && Y[WIDTH-1]==1); end
            4'h3: begin Y=dec_ext[WIDTH-1:0]; C=dec_ext[WIDTH]; V=(A[WIDTH-1]==1 && Y[WIDTH-1]==0); end
            4'h4: Y=A&B;
            4'h5: Y=A|B;
            4'h6: Y=A^B;
            4'h7: Y=~A;
            4'h8: begin sh_mode=2'b00; Y=sh_out; C=(shamt!=0)?sh_cout:0; end
            4'h9: begin sh_mode=2'b01; Y=sh_out; C=(shamt!=0)?sh_cout:0; end
            4'hA: begin sh_mode=2'b10; Y=sh_out; C=(shamt!=0)?sh_cout:0; end
            4'hB: Y=A;
            4'hC: Y=B;
            default: Y=0;
        endcase

        Z = (Y==0);
        N = Y[WIDTH-1];
    end
endmodule

