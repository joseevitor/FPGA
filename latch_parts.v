// ============================================================
// latch_parts.v
// Mesma logica de latch_pc.v, mas dividida em duas pecas para
// poder ser reaproveitada nas hierarquias ARCH2 e ARCH3:
//
//   latch_logic  -> calcula os sinais de controle Sn_eff/Rn_eff
//                   (ainda nao e' o latch em si)
//   output_pair  -> o par de NAND cruzado que efetivamente
//                   guarda o estado (Q, Q_n)
//
// latch_pc (ARCH1) = latch_logic + output_pair
// ============================================================

module latch_logic(
    output Sn_eff,
    output Rn_eff,
    input  D,
    input  EN,
    input  PRE_n,
    input  CLR_n
);
    wire Dn, Sn0, Rn0;
    not_n u_dn (Dn, D);
    nand  u_sn0(Sn0, D,  EN);
    nand  u_rn0(Rn0, Dn, EN);

    wire clr_n_bar, or_pre;
    not_n u_clrnbar(clr_n_bar, CLR_n);
    or_n  u_or_pre (or_pre, clr_n_bar, Sn0);
    and_n u_and_pre(Sn_eff, PRE_n, or_pre);

    wire pre_n_bar, or_clr;
    not_n u_prenbar(pre_n_bar, PRE_n);
    or_n  u_or_clr (or_clr, pre_n_bar, Rn0);
    and_n u_and_clr(Rn_eff, CLR_n, or_clr);
endmodule

module output_pair(
    output Q,
    output Qn,
    input  Sn_eff,
    input  Rn_eff
);
    nand u_q  (Q,  Sn_eff, Qn);
    nand u_qn (Qn, Rn_eff, Q);
endmodule
