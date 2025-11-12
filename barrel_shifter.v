`timescale 1ns/1ps
module barrel_shifter #(
    parameter WIDTH = 8
)(
    input      [WIDTH-1:0] in,
    input      [2:0]       shamt,
    input      [1:0]       mode,     // 00 LSL, 01 LSR, 10 ASR
    output reg [WIDTH-1:0] out,
    output reg             cout
);

    reg [WIDTH-1:0] lsl_res, lsr_res, asr_res;
    reg             lsl_cout, lsr_cout, asr_cout;

    always @* begin
        lsl_res  = in << shamt;
        lsr_res  = in >> shamt;
        asr_res  = $signed(in) >>> shamt;

        lsl_cout = (shamt != 0) ? in[WIDTH-shamt] : 0;
        lsr_cout = (shamt != 0) ? in[shamt-1]     : 0;
        asr_cout = (shamt != 0) ? in[shamt-1]     : 0;
    end

    always @* begin
        case (mode)
            2'b00: begin out = lsl_res; cout = lsl_cout; end
            2'b01: begin out = lsr_res; cout = lsr_cout; end
            2'b10: begin out = asr_res; cout = asr_cout; end
            default: begin out = in; cout = 0; end
        endcase
    end
endmodule

