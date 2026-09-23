# Lab3 – Flip-flop D (ffd) em Verilog — versão simples para testar e aprender

## Aviso importante sobre fidelidade ao diagrama
Eu **não reproduzi o netlist gate-a-gate exato** da sua figura (os 18 `nand`
`u1..u18` com aqueles nomes de fio). Reconstruir isso com 100% de certeza a
partir de uma imagem estática é arriscado — um fio mal interpretado gera um
circuito "parecido" mas errado, o que é pior para aprender.

Em vez disso, implementei um **flip-flop D mestre-escravo sensível à borda de
subida, com PRE_n/CLR_n assíncronos, construído somente com `nand` de 2
entradas**, que se comporta exatamente como o 74LS74/54LS74 pedido no
enunciado. **Eu compilei e simulei tudo com o Icarus Verilog aqui mesmo antes
de te entregar** — os 3 testbenches passaram em todos os casos de teste
(preset, clear, captura na borda, não-captura fora da borda, sobreposição
assíncrona do clear/preset em relação ao clock).

Se o seu professor exigir o netlist idêntico ao desenho (mesmos nomes
`u1..u18`), use isto como uma versão de estudo/validação e depois ajuste os
nomes de instância/fios no Logisim para bater com a figura — a lógica
(equações) que derivei abaixo é a mesma usada internamente no 74LS74 real.

## Como o circuito funciona
- `nand_lib.v` — NOT, AND, OR construídos **somente** com `nand` de 2 entradas
  (requisito do lab).
- `latch_pc.v` / `latch_parts.v` — um latch D transparente em `EN=1`, com
  PRESET_n e CLEAR_n assíncronos e prioritários. Equações (derivadas e
  verificadas por simulação):
  ```
  Sn0 = NAND(D, EN)
  Rn0 = NAND(D', EN)
  Sn_eff = PRE_n AND (CLR_n' OR Sn0)
  Rn_eff = CLR_n AND (PRE_n' OR Rn0)
  Q  = NAND(Sn_eff, Qn)
  Qn = NAND(Rn_eff, Q)
  ```
- O flip-flop completo = **latch mestre** (transparente quando `CLK=0`) +
  **latch escravo** (transparente quando `CLK=1`). Essa combinação
  mestre-escravo é o que cria a sensibilidade à borda de subida.

## As 3 hierarquias pedidas
- **ARCH1 — `dff_latch_output`** (`arch1_dff_latch_output.v`): hierarquia mais
  baixa, tudo explícito com os blocos `latch_pc` (mestre e escravo).
- **ARCH2 — `dff_combined_logic`** (`arch2_dff_combined_logic.v`): reaproveita
  a ARCH1 e agrupa quase tudo (inversor de clock + latch mestre completo +
  lógica de controle do escravo) em um único bloco `input_logic`, que
  alimenta apenas o par final de NAND cruzado (`output_pair`).
- **ARCH3 — `dff_modular_blocks`** (`arch3_dff_modular_blocks.v`): reaproveita
  a ARCH2 e separa em 3 blocos bem definidos: `preset_block` (controle do
  PRE_n), `data_clk_clr_block` (lógica de D/CLK/CLR_n, inclui o latch
  mestre) e `output_pair` (latch de saída).

## Testbench único (`tb/tb_ffd_shared.v`)
O mesmo arquivo de testbench serve para as 3 arquiteturas — você escolhe qual
DUT instanciar na hora de compilar, usando uma macro:

```bash
# ARCH1
iverilog -DUSE_ARCH1 -o sim1.out nand_lib.v latch_pc.v latch_parts.v \
    arch1_dff_latch_output.v arch2_dff_combined_logic.v arch3_dff_modular_blocks.v \
    tb/tb_ffd_shared.v
vvp sim1.out

# ARCH2
iverilog -DUSE_ARCH2 -o sim2.out nand_lib.v latch_pc.v latch_parts.v \
    arch1_dff_latch_output.v arch2_dff_combined_logic.v arch3_dff_modular_blocks.v \
    tb/tb_ffd_shared.v
vvp sim2.out

# ARCH3
iverilog -DUSE_ARCH3 -o sim3.out nand_lib.v latch_pc.v latch_parts.v \
    arch1_dff_latch_output.v arch2_dff_combined_logic.v arch3_dff_modular_blocks.v \
    tb/tb_ffd_shared.v
vvp sim3.out
```

Isso gera um arquivo `.vcd` que você pode abrir no **GTKWave** para ver as
formas de onda. As 3 rodadas acima já foram testadas por mim e passam em
todos os casos (`*** TODOS OS TESTES PASSARAM ***`).

## Regras que o testbench respeita (e que você deve manter se editar)
- PRE_n e CLR_n nunca ficam em 0 ao mesmo tempo.
- Nenhum sinal amostrado (D, e também PRE_n/CLR_n) muda exatamente no
  instante da borda de subida do clock — sempre há uma folga (setup/hold)
  antes e depois da borda.

## Para simular no Logisim-evolution / ModelSim
- **Logisim-evolution**: crie os componentes com portas NAND de 2 entradas
  seguindo exatamente as equações acima (ou importe a estrutura hierárquica:
  latch → mestre/escravo → FF completo).
- **ModelSim**: os mesmos arquivos `.v` compilam direto (`vlog *.v tb/*.v`,
  depois `vsim` no módulo de teste).
