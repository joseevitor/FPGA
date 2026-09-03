`timescale 1ns/1ps

module`timescale 1ns/1ps

module full_adder_tb;

    reg  a_i, b_i, s_o, c_o;
    wire full_adder_tb;

    reg  a_i, b_i, s_o, c_o;
    wire sum, cout;

    // Instancia o DUT (Device Under Test)
    full_adder DUT (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    integer i;

    initial begin
        $display("  a  b cin | sum cout");
        $display("");

        // Testa todas as 8 combinações possiveis
        for (i = 0; i < 8; i = i + 1) begin
            {a_i, b_i, s_o, c_o} = i[2:0];
            #10; // espera propagar
            $display("  %b  %b  %b  |  %b   %b", a, b, cin, sum, cout);
        end

        $finish;
    end

    // Opcional: gera arquivo .vcd para visualizar no waveform viewer
    initial begin
        $dumpfile("full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);
    end

endmodule
