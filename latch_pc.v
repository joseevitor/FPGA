// ============================================================
// latch_pc.v
// Latch tipo D, transparente quando EN=1, com PRESET_n e CLEAR_n
// assincronos (prioritarios sobre o relogio/EN), ativos em 0.
// Construido inteiramente com portas nand de 2 entradas (via
// not_n / and_n / or_n de nand_lib.v).
//
// Equacoes (derivadas e verificadas por simulacao):
//   Sn0 = NAND(D, EN)         -> linha de "set" normal (ativa em 0)
//   Rn0 = NAND(D', EN)        -> linha de "reset" normal (ativa em 0)
//   Sn_eff = PRE_n AND (CLR_n' OR Sn0)
//   Rn_eff = CLR_n AND (PRE_n' OR Rn0)
//   Q  = NAND(Sn_eff, Qn)
//   Qn = NAND(Rn_eff, Q)
//
// Regra do datasheet 74LS74: PRE_n e CLR_n NUNCA devem ser 0 ao
// mesmo tempo.
// ============================================================
module latch_pc(
    output Q,
    output Qn,
    input  D,
    input  EN,
    input  PRE_n,
    input  CLR_n
);

    wire Dn;
    wire Sn0, Rn0;

    // ---------------- LOGICA DE ENTRADA (D/EN) -----------------
    not_n  u_dn (Dn, D);
    nand   u_sn0(Sn0, D,  EN);
    nand   u_rn0(Rn0, Dn, EN);

    // ---------------- CONTROLE DE PRESET (PRE_n) ----------------
    // Sn_eff = PRE_n AND (CLR_n' OR Sn0)
    wire clr_n_bar, or_pre, sn_eff;
    not_n  u_clrnbar (clr_n_bar, CLR_n);
    or_n   u_or_pre  (or_pre, clr_n_bar, Sn0);
    and_n  u_and_pre (sn_eff, PRE_n, or_pre);

    // ---------------- CONTROLE DE CLEAR (CLR_n) ----------------
    // Rn_eff = CLR_n AND (PRE_n' OR Rn0)
    wire pre_n_bar, or_clr, rn_eff;
    not_n  u_prenbar (pre_n_bar, PRE_n);
    or_n   u_or_clr  (or_clr, pre_n_bar, Rn0);
    and_n  u_and_clr (rn_eff, CLR_n, or_clr);

    // ---------------- LATCH DE SAIDA (par de NAND cruzado) -----
    nand u_q  (Q,  sn_eff, Qn);
    nand u_qn (Qn, rn_eff, Q);

endmodule
