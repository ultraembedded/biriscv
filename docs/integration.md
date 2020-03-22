## Integration Guide

### Core: riscv_tcm_top - CPU + Tightly Coupled Memory

The top (src/top/riscv_tcm_top.v) contains;
* biRISC-V CPU instance.
* 64KB dual ported RAM for (I/D code and data).
* AXI4 slave port for loading the RAM, DMA access, etc (including support for burst access).
* AXI4-Lite master port for CPU access to peripherals / external memory.
* Separate reset for CPU core to dual ported RAM / AXI interface (to allow program code to be loaded prior to CPU reset de-assertion).

#### Interfaces

| Name         | Description                                                           |
| ------------ | --------------------------------------------------------------------- |
| clk_i        | Clock input                                                           |
| rst_i        | Async reset, active-high. Reset memory / AXI interface.               |
| rst_cpu_i    | Async reset, active-high. Reset CPU core (excluding AXI / memory).    |
| axi_t_*      | AXI4 slave interface for access to 64KB TCM memory.                   |
| axi_i_*      | AXI4-Lite master interface for CPU access to peripherals.             |
| intr_i       | Active high interrupt input (for connection external int controller). |

#### Configuration

| Param Name                | Description                                   |
| ------------------------- | ----------------------------------------------|
| BOOT_VECTOR               | Location of first instruction to execute.     |
| TCM_MEM_BASE              | Base address of TCM memory.                   |
| CORE_ID                   | CPU instance ID (MHARTID).                    |
| SUPPORT_REGFILE_XILINX    | Support Xilinx optimised register file.       |

#### FPGA: Xilinx
* Set SUPPORT_REGFILE_XILINX = 1 to use Xilinx specific register file cells which reduce LUT/FF usage.
* Nothing to do for TCM RAM inference.

#### FPGA: Altera / Intel
* Set SUPPORT_REGFILE_XILINX = 0 to infer a flop based register file.
* You may need to adjust the TCM RAM inference coding style (src/tcm/tcm_mem_ram.v) - or it may just work....

#### ASIC
* Set SUPPORT_REGFILE_XILINX = 0 to infer a flop based register file.
* Replace dual ported TCM RAM (8191x64 with byte write enables) with technology specific cells (src/tcm/tcm_mem_ram.v).


### Core: riscv_top - CPU with instruction and data caches

The top (src/top/riscv_top.v) contains;
* biRISC-V CPU instance.
* 16KB 2-way set associative instruction cache
* 16KB 2-way set associative data cache with write-back and allocate on write.
* 2 x AXI4 master port for CPU access to instruction / data / peripherals.

#### Interfaces

| Name           | Description                                                           |
| -------------- | --------------------------------------------------------------------- |
| clk_i          | Clock input                                                           |
| rst_i          | Async reset, active-high. Reset memory / AXI interface.               |
| axi_i_*        | AXI4 master interface for CPU access to instruction memory.           |
| axi_d_*        | AXI4 master interface for CPU access to data / peripheral memories.   |
| intr_i         | Active high interrupt input (for connection external int controller). |
| reset_vector_i | Boot vector.                                                          |

#### Configuration

| Param Name                | Description                                   |
| ------------------------- | ----------------------------------------------|
| ICACHE_AXI_ID             | AXI ID to use for instruction cache accesses. |
| DCACHE_AXI_ID             | AXI ID to use for data cache accesses.        |
| TCM_MEM_BASE              | Base address of TCM memory.                   |
| CORE_ID                   | CPU instance ID (MHARTID).                    |
| SUPPORT_REGFILE_XILINX    | Support Xilinx optimised register file.       |

#### FPGA: Xilinx
* Set SUPPORT_REGFILE_XILINX = 1 to use Xilinx specific register file cells which reduce LUT/FF usage.
* Nothing to do for cache RAM inference.

#### FPGA: Altera / Intel
* Set SUPPORT_REGFILE_XILINX = 0 to infer a flop based register file.
* You may need to adjust the cache RAM inference coding style or it may just work....

#### ASIC
* Set SUPPORT_REGFILE_XILINX = 0 to infer a flop based register file.
* Replace cache RAMS (src/dcache/dcache_core_*ram.v, src/icache/icache_*_ram.v)
