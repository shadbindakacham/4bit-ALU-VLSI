# 4-bit ALU — RTL to Synthesis
**Tools:** Verilog · iVerilog · GTKWave · Yosys  
**Platform:** MacBook Air M3 · June 2026

## Overview
A fully verified 8-operation 4-bit ALU designed from scratch in Verilog,
simulated with a comprehensive testbench, and synthesized to a 154-gate
netlist using open-source EDA tools — covering the complete RTL-to-netlist
VLSI design flow.

## Operations
| Opcode | Operation | Description |
|--------|-----------|-------------|
| 000 | ADD | A + B with carry |
| 001 | SUB | A - B via 2's complement |
| 010 | AND | Bitwise AND |
| 011 | OR  | Bitwise OR |
| 100 | XOR | Bitwise XOR |
| 101 | NOT | Bitwise NOT of A |
| 110 | SHL | Logical shift left |
| 111 | SHR | Logical shift right |

## Results
- ✅ 11/11 testcases passed
- ✅ carry_out and zero_flag verified across all operations
- ✅ Synthesized to **154 gates** (54 NAND · 50 AND · 33 OR)
- ✅ NAND-optimized netlist — consistent with CMOS fabrication principles

## Project Structure

├── rtl/                  ← Verilog source files

│   ├── full_adder.v      ← 1-bit full adder cell

│   ├── ripple_adder.v    ← 4-bit ripple carry adder

│   └── alu.v             ← Top-level ALU module

├── testbench/

│   └── alu_tb.v          ← 11-case testbench

├── simulation/

│   └── alu_wave.vcd      ← GTKWave waveform output

└── synthesis/

├── synth.ys          ← Yosys synthesis script

└── alu_netlist.v     ← Gate-level netlist output


## How to Run
```bash
# Simulate
iverilog -o simulation/alu_sim rtl/full_adder.v rtl/ripple_adder.v rtl/alu.v testbench/alu_tb.v
vvp simulation/alu_sim

# Synthesize
cd synthesis
yosys synth.ys
```
