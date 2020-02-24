# biRISC-V - 32-bit dual issue RISC-V CPU

Github: [http://github.com/ultraembedded/biriscv](http://github.com/ultraembedded/biriscv)

![biRISC-V](docs/biRISC-V.png)

## Features
* 32-bit RISC-V ISA CPU core.
* Superscalar (dual-issue) in-order 6 or 7 stage pipeline.
* Support RISC-V’s integer (I), multiplication and division (M), and CSR instructions (Z) extensions (RV32IMZicsr).
* Branch prediction (bimodel/gshare) with configurable depth branch target buffer (BTB) and return address stack (RAS).
* 64-bit instruction fetch, 32-bit data access.
* 2 x integer ALU (arithmetic, shifters and branch units).
* 1 x load store unit, 1 x out-of-pipeline divider.
* Issue and complete up to 2 independent instructions per cycle.
* Verified using [Google's RISCV-DV](https://github.com/google/riscv-dv) random instruction sequences using cosimulation against [C++ ISA model](https://github.com/ultraembedded/exactstep).
* Support for instruction / data cache, AXI bus interfaces or tightly coupled memories.
* Configurable number of pipeline stages, result forwarding options, and branch prediction resources.
* Synthesizable Verilog 2001, Verilator and FPGA friendly.
* Coremark:  **4.1 CoreMark/MHz**
* Dhrystone: **1.9 DMIPS/MHz** ('legal compile options' / 337 instructions per iteration)

## Similar Cores
* [SiFive E76](https://www.sifive.com/cores/e76)
  * RV32IMAFC
  * Dual issue in-order 8 stage pipeline
  * 4 ALU units (2 early, 2 late)
  * -*Commercial core/$$*
* [WD SweRV RISC-V Core EH1](https://github.com/chipsalliance/Cores-SweRV)
  * RV32IMC
  * Dual issue in-order 9 stage pipeline
  * 4 ALU units (2 early, 2 late)
  * -*System Verilog + auto signal hookup*
  * -*No data cache option*

## Project Aims
* Achieve competitive performance for this class of in-order machine (i.e. aim for 80% of WD SweRV CoreMark score).
* Reasonable PPA / FPGA resource friendly.
* Fit easily onto cheap hobbyist FPGAs (e.g. Xilinx Artix 7) without using all LUT resources and synthesize > 50MHz.
* Support various cache and TCM options.
* Be constructed using readable, maintainable and documented IEEE 1364-2001 Verilog.
* Simulate in open-source tools such as Verilator and Icarus Verilog.
* *In later releases, add support for atomic extensions and MMU/supervisor mode to enable booting Linux.*

## Prior Work
Based on my previous work;
* Github: [http://github.com/ultraembedded/riscv](http://github.com/ultraembedded/riscv)

## Getting Started

#### Cloning

To clone this project and its dependencies;

```
git clone --recursive https://github.com/ultraembedded/biriscv.git

```