
# ARM Single-Cycle Processor

![Full Architecture](image/full_arch.png)

## Overview
This repository contains the RTL implementation (Verilog/SystemVerilog) of a **Single-Cycle ARM Processor**. In this microarchitecture, the entire instruction execution process—from fetching the instruction to writing back the result—is completed within a single clock cycle.

While the single-cycle design limits the maximum clock frequency (due to the critical path length of the slowest instruction), it offers a straightforward control logic design and serves as an excellent educational model for understanding computer architecture fundamentals.

## Architecture Description
The processor datapath is designed based on the standard 5-stage execution flow, though all stages occur in one cycle:

1.  **Instruction Fetch**:
    * The **Program Counter (PC)** drives the instruction memory address.
    * The instruction is retrieved, and the PC is incremented (`PC + 4`) for the next cycle.

2.  **Decode & Register Read**:
    * The 32-bit instruction is split into fields (Opcode, Rd, Rn, Rm/Imm).
    * The **Control Unit** decodes the Opcode and generates control signals (RegWrite, ALUSrc, MemWrite, etc.).
    * The **Register File** outputs the values of the source operands.
    * Immediate values are processed by the **Sign Extender**.

3.  **Execute (ALU)**:
    * The **ALU (Arithmetic Logic Unit)** performs the operation (ADD, SUB, AND, ORR) on the operands.
    * For memory instructions, the ALU calculates the effective memory address.
    * For branch instructions, the ALU calculates the target address.

4.  **Memory Access**:
    * If the instruction is `LDR` (Load) or `STR` (Store), the **Data Memory** is accessed using the address calculated by the ALU.

5.  **Write Back**:
    * The result (either from the ALU or Data Memory) is written back into the destination register in the Register File.

## Supported Instructions
The processor currently supports a subset of the ARM instruction set, including:
* **Data Processing:** `ADD`, `SUB`, `AND`, `ORR`
* **Memory Access:** `LDR`, `STR`
* **Branching:** `B` (Unconditional Branch)

## References & Credits
This architecture and datapath design are based on the **Single-Cycle ARM Processor** model described in:

> **Harris, D. M., & Harris, S. L. (2015).** *Digital Design and Computer Architecture: ARM Edition.* Morgan Kaufmann.

Specifically, this implementation follows the datapath and control unit schematics found in **Chapter 7 (Microarchitecture)** of the textbook.
