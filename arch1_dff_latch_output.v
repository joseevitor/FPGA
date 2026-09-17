// ============================================================
// ARCH1 - dff_latch_output
// Flip-flop D sensivel a borda de SUBIDA do clock, com PRESET_n
// e CLEAR_n assincronos, no estilo do 74LS74/54LS74.
//
// Implementado como dois latches D (mestre + escravo):
//   - MESTRE  : transparente quando CLK = 0 (capta D)
//   - ESCRAVO : transparente quando CLK = 1 (entrega para Q/Qn)
// Essa combinacao "mestre-escravo" e o que gera a sensibilidade
// a borda de subida. PRE_n/CLR_n atuam de forma assincrona nos
// dois latches, exatamente como no CI real.
//
// Hierarquia mais baixa do Lab3: usa SOMENTE portas nand de
// 2 entradas (diretamente, ou via nand_lib.v).
// ============================================================
module dff_latch_output(
    output Q,
    output Q_n,
    input  D,
    input  CLK,
    input  PRE_n,
    input  CLR_n
);

    wire CLKn;
    wire Qm, Qmn;   // saidas do latch mestre

    // Inversor de clock construido so com nand
    not_n u_clkn(CLKn, CLK);

    // ---------------- LATCH MESTRE (transparente com CLK=0) -----
    latch_pc u_master(
        .Q    (Qm),
        .Qn   (Qmn),
        .D    (D),
        .EN   (CLKn),
        .PRE_n(PRE_n),
        .CLR_n(CLR_n)
    );

    // ---------------- LATCH ESCRAVO (transparente com CLK=1) ----
    latch_pc u_slave(
        .Q    (Q),
        .Qn   (Q_n),
        .D    (Qm),
        .EN   (CLK),
        .PRE_n(PRE_n),
        .CLR_n(CLR_n)
    );

endmodule
