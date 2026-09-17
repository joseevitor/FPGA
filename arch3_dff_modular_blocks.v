// ============================================================
// ARCH3 - dff_modular_blocks
// Visao mais modular: TRES blocos bem delimitados, reaproveitando
// a ARCH2 (que reaproveita a ARCH1):
//
//   1) preset_block     -> logica de controle do PRESET (PRE_n)
//   2) data_clk_clr_blk -> logica de entrada D / CLK / CLR_n
//                          (inclui o latch mestre inteiro)
//   3) output_latch      -> latch de saida (par de NAND cruzado)
// ============================================================

// Bloco 1: controle de PRESET para o estagio de saida.
// (usa a mesma equacao Sn_eff = PRE_n AND (CLR_n' OR Sn0) do
//  latch_logic, isolada aqui como bloco proprio)
module preset_block(
    output Sn_eff,
    input  Qm,      // valor ja amostrado pelo latch mestre
    input  CLK,
    input  PRE_n,
    input  CLR_n
);
    wire Sn0;
    nand u_sn0(Sn0, Qm, CLK);

    wire clr_n_bar, or_pre;
    not_n u_clrnbar(clr_n_bar, CLR_n);
    or_n  u_or_pre (or_pre, clr_n_bar, Sn0);
    and_n u_and_pre(Sn_eff, PRE_n, or_pre);
endmodule

// Bloco 2: logica de entrada D / CLK / CLR_n. Contem o latch
// mestre inteiro (que ja trata PRE_n/CLR_n internamente) e produz
// tambem o comando de RESET (Rn_eff) para o latch de saida.
module data_clk_clr_block(
    output Qm,       // saida do latch mestre, usada pelo preset_block
    output Rn_eff,   // comando de RESET para o latch de saida
    input  D,
    input  CLK,
    input  PRE_n,
    input  CLR_n
);
    wire CLKn, Qmn;
    not_n u_clkn(CLKn, CLK);

    latch_pc u_master(
        .Q(Qm), .Qn(Qmn),
        .D(D), .EN(CLKn),
        .PRE_n(PRE_n), .CLR_n(CLR_n)
    );

    wire Qmn2, Rn0;
    not_n u_qmn(Qmn2, Qm);
    nand  u_rn0(Rn0, Qmn2, CLK);

    wire pre_n_bar, or_clr;
    not_n u_prenbar(pre_n_bar, PRE_n);
    or_n  u_or_clr (or_clr, pre_n_bar, Rn0);
    and_n u_and_clr(Rn_eff, CLR_n, or_clr);
endmodule

// Topo: junta os 3 blocos
module dff_modular_blocks(
    output Q,
    output Q_n,
    input  D,
    input  CLK,
    input  PRE_n,
    input  CLR_n
);
    wire Qm, Sn_eff, Rn_eff;

    data_clk_clr_block u_data(
        .Qm(Qm), .Rn_eff(Rn_eff),
        .D(D), .CLK(CLK), .PRE_n(PRE_n), .CLR_n(CLR_n)
    );

    preset_block u_preset(
        .Sn_eff(Sn_eff),
        .Qm(Qm), .CLK(CLK), .PRE_n(PRE_n), .CLR_n(CLR_n)
    );

    output_pair u_out(
        .Q(Q), .Qn(Q_n),
        .Sn_eff(Sn_eff), .Rn_eff(Rn_eff)
    );
endmodule
