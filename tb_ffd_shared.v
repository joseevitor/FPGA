`timescale 1ns/1ps
// ============================================================
// Testbench UNICO usado para ARCH1, ARCH2 e ARCH3, conforme
// pedido no enunciado ("usar o mesmo testbench para as 3
// hierarquias"). O modulo instanciado (DUT) e escolhido na
// hora da compilacao, atraves de uma macro `define:
//
//   iverilog -DUSE_ARCH1 ... tb_ffd_shared.v   -> testa ARCH1
//   iverilog -DUSE_ARCH2 ... tb_ffd_shared.v   -> testa ARCH2
//   iverilog -DUSE_ARCH3 ... tb_ffd_shared.v   -> testa ARCH3
// ============================================================

module tb_ffd_shared;

    reg D, CLK, PRE_n, CLR_n;
    wire Q, Q_n;
    integer errors = 0;

`ifdef USE_ARCH1
    dff_latch_output DUT(.Q(Q), .Q_n(Q_n), .D(D), .CLK(CLK), .PRE_n(PRE_n), .CLR_n(CLR_n));
`elsif USE_ARCH2
    dff_combined_logic DUT(.Q(Q), .Q_n(Q_n), .D(D), .CLK(CLK), .PRE_n(PRE_n), .CLR_n(CLR_n));
`elsif USE_ARCH3
    dff_modular_blocks DUT(.Q(Q), .Q_n(Q_n), .D(D), .CLK(CLK), .PRE_n(PRE_n), .CLR_n(CLR_n));
`else
    // padrao, caso nenhuma macro seja passada
    dff_latch_output DUT(.Q(Q), .Q_n(Q_n), .D(D), .CLK(CLK), .PRE_n(PRE_n), .CLR_n(CLR_n));
`endif

    task check(input exp_q, input exp_qn, input [191:0] msg);
        begin
            if (Q !== exp_q || Q_n !== exp_qn) begin
                errors = errors + 1;
                $display("ERRO em t=%0t (%0s): Q=%b Q_n=%b (esperado Q=%b Q_n=%b)",
                          $time, msg, Q, Q_n, exp_q, exp_qn);
            end else begin
                $display("OK   em t=%0t (%0s): Q=%b Q_n=%b", $time, msg, Q, Q_n);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_ffd_shared.vcd");
        $dumpvars(0, tb_ffd_shared);

        D = 0; CLK = 0; PRE_n = 1; CLR_n = 0;
        #10;  check(0, 1, "CLR_n=0 forca Q=0 (assincrono)");
        CLR_n = 1; #10; check(0, 1, "segura apos soltar CLR_n");

        PRE_n = 0; #10; check(1, 0, "PRE_n=0 forca Q=1 (assincrono)");
        PRE_n = 1; #10; check(1, 0, "segura apos soltar PRE_n");

        D = 0; #10;
        CLK = 1; #10; check(0, 1, "borda de subida, D=0 -> Q=0");

        D = 1; #10;   check(0, 1, "D muda com CLK=1 parado -> nao amostra");
        CLK = 0; #10; check(0, 1, "descida do clock -> nao amostra");
        CLK = 1; #10; check(1, 0, "borda de subida, D=1 -> Q=1");

        CLK = 0; #10; CLK = 1; #10; check(1, 0, "borda repetida, D=1 -> Q continua 1");

        CLK = 0; #10; D = 0; #10; CLK = 1; #10; check(0, 1, "nova borda, D=0 -> Q=0");

        D = 1; CLK = 1; #5;
        CLR_n = 0; #10; check(0, 1, "CLR_n sobrepoe o clock -> Q=0");
        CLR_n = 1; #10;

        if (errors == 0) $display("\n*** TODOS OS TESTES PASSARAM ***\n");
        else $display("\n*** %0d TESTE(S) FALHARAM ***\n", errors);

        $finish;
    end
endmodule
