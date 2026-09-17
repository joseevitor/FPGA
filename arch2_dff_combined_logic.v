// ============================================================
// ARCH2 - dff_combined_logic
// Mesma funcionalidade da ARCH1, reorganizada em hierarquia
// intermediaria: quase todo o circuito (inversor de clock +
// latch mestre completo + logica de controle do escravo) e'
// tratado como UM bloco unico de "logica de entrada" (input_logic),
// que alimenta apenas o par final de NAND cruzado (output_pair).
//
// Reaproveita os MESMOS blocos primitivos usados na ARCH1
// (latch_pc para o mestre, latch_logic/output_pair de
// latch_parts.v), apenas agrupados de forma diferente.
// ============================================================

module input_logic(
    output Sn_eff,   // vai para o par de saida (comando de SET)
    output Rn_eff,   // vai para o par de saida (comando de RESET)
    input  D,
    input  CLK,
    input  PRE_n,
    input  CLR_n
);
    wire CLKn;
    wire Qm, Qmn; // saida do latch mestre

    not_n u_clkn(CLKn, CLK);

    // latch mestre completo (reaproveita o mesmo bloco da ARCH1)
    latch_pc u_master(
        .Q(Qm), .Qn(Qmn),
        .D(D), .EN(CLKn),
        .PRE_n(PRE_n), .CLR_n(CLR_n)
    );

    // logica de controle do escravo (ainda nao e' o latch final)
    latch_logic u_slave_logic(
        .Sn_eff(Sn_eff), .Rn_eff(Rn_eff),
        .D(Qm), .EN(CLK),
        .PRE_n(PRE_n), .CLR_n(CLR_n)
    );
endmodule

module dff_combined_logic(
    output Q,
    output Q_n,
    input  D,
    input  CLK,
    input  PRE_n,
    input  CLR_n
);
    wire Sn_eff, Rn_eff;

    input_logic u_logic(
        .Sn_eff(Sn_eff), .Rn_eff(Rn_eff),
        .D(D), .CLK(CLK), .PRE_n(PRE_n), .CLR_n(CLR_n)
    );

    output_pair u_out(
        .Q(Q), .Qn(Q_n),
        .Sn_eff(Sn_eff), .Rn_eff(Rn_eff)
    );
endmodule
