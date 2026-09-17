// ============================================================
// nand_lib.v
// Biblioteca de portas auxiliares (NOT, AND, OR) construidas
// usando EXCLUSIVAMENTE a primitiva nand de 2 entradas.
// Isso satisfaz o requisito do laboratorio: "usar somente a
// primitiva NAND com duas entradas".
// ============================================================

// NOT a partir de NAND: liga as duas entradas da NAND juntas
module not_n(output Y, input A);
    nand g1(Y, A, A);
endmodule

// AND a partir de NAND: NAND seguida de um NOT (outra NAND)
module and_n(output Y, input A, input B);
    wire n;
    nand g1(n, A, B);
    nand g2(Y, n, n);
endmodule

// OR a partir de NAND: inverte as duas entradas e aplica NAND
// (Lei de De Morgan: A + B = NAND(A', B'))
module or_n(output Y, input A, input B);
    wire na, nb;
    nand g1(na, A, A);
    nand g2(nb, B, B);
    nand g3(Y, na, nb);
endmodule
