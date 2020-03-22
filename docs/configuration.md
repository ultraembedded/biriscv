## Core Configuration

#### Static Configuration Parameters

| Param Name                | Valid Range          | Description                                   |
| ------------------------- |:--------------------:| ----------------------------------------------|
| SUPPORT_SUPER             | 1/0                  | Enable supervisor / user privilege levels.    |
| SUPPORT_MMU               | 1/0                  | Enable basic memory management unit.          |
| SUPPORT_MULDIV            | 1/0                  | Enable HW multiply / divide (RV-M).           |
| SUPPORT_DUAL_ISSUE        | 1/0                  | Support superscalar operation.                |
| SUPPORT_LOAD_BYPASS       | 1/0                  | Support load result bypass paths.             |
| SUPPORT_MUL_BYPASS        | 1/0                  | Support multiply result bypass paths.         |
| SUPPORT_REGFILE_XILINX    | 1/0                  | Support Xilinx optimised register file.       |
| SUPPORT_BRANCH_PREDICTION | 1/0                  | Enable branch prediction structures.          |
| NUM_BTB_ENTRIES           | 2 -                  | Number of branch target buffer entries.       |
| NUM_BTB_ENTRIES_W         | 1 -                  | Set to log2(NUM_BTB_ENTRIES).                 |
| NUM_BHT_ENTRIES           | 2 -                  | Number of branch history table entries.       |
| NUM_BHT_ENTRIES_W         | 1 -                  | Set to log2(NUM_BHT_ENTRIES_W).               |
| BHT_ENABLE                | 1/0                  | Enable branch history table based prediction. |
| GSHARE_ENABLE             | 1/0                  | Enable GSHARE branch prediction algorithm.    |
| RAS_ENABLE                | 1/0                  | Enable return address stack prediction.       |
| NUM_RAS_ENTRIES           | 2 -                  | Number of return stack addresses supported.   |
| NUM_RAS_ENTRIES_W         | 1 -                  | Set to log2(NUM_RAS_ENTRIES_W).               |
| EXTRA_DECODE_STAGE        | 1/0                  | Extra decode pipe stage for improved timing.  |
| MEM_CACHE_ADDR_MIN        | 32'h0 - 32'hffffffff | Lowest cacheable memory address.              |
| MEM_CACHE_ADDR_MAX        | 32'h0 - 32'hffffffff | Highest cacheable memory address.             |


#### Configuration: Default
```
     .SUPPORT_BRANCH_PREDICTION(1)
    ,.SUPPORT_MULDIV(1)
    ,.SUPPORT_SUPER(0)
    ,.SUPPORT_MMU(0)
    ,.SUPPORT_DUAL_ISSUE(1)
    ,.SUPPORT_LOAD_BYPASS(1)
    ,.SUPPORT_MUL_BYPASS(1)
    ,.SUPPORT_REGFILE_XILINX(0)
    ,.EXTRA_DECODE_STAGE(0)
    ,.MEM_CACHE_ADDR_MIN(32'h80000000)
    ,.MEM_CACHE_ADDR_MAX(32'h8fffffff)
    ,.NUM_BTB_ENTRIES(32)
    ,.NUM_BTB_ENTRIES_W(5)
    ,.NUM_BHT_ENTRIES(512)
    ,.NUM_BHT_ENTRIES_W(9)
    ,.RAS_ENABLE(1)
    ,.GSHARE_ENABLE(0)
    ,.BHT_ENABLE(1)
    ,.NUM_RAS_ENTRIES(8)
    ,.NUM_RAS_ENTRIES_W(3)
```

#### Configuration: Minimal Area (RV32I)
```
     .SUPPORT_BRANCH_PREDICTION(0)
    ,.SUPPORT_MULDIV(0)
    ,.SUPPORT_SUPER(0)
    ,.SUPPORT_MMU(0)
    ,.SUPPORT_DUAL_ISSUE(0)
    ,.SUPPORT_LOAD_BYPASS(0)
    ,.SUPPORT_MUL_BYPASS(0)
    ,.SUPPORT_REGFILE_XILINX(0) // Set to 1 if building for Xilinx FPGAs
    ,.EXTRA_DECODE_STAGE(0)
    ,.MEM_CACHE_ADDR_MIN(32'h80000000)
    ,.MEM_CACHE_ADDR_MAX(32'h8fffffff)
```

#### Configuration: Minimal Area (RV32IM)
```
     .SUPPORT_BRANCH_PREDICTION(0)
    ,.SUPPORT_MULDIV(1)
    ,.SUPPORT_SUPER(0)
    ,.SUPPORT_MMU(0)
    ,.SUPPORT_DUAL_ISSUE(0)
    ,.SUPPORT_LOAD_BYPASS(0)
    ,.SUPPORT_MUL_BYPASS(0)
    ,.SUPPORT_REGFILE_XILINX(0) // Set to 1 if building for Xilinx FPGAs
    ,.EXTRA_DECODE_STAGE(0)
    ,.MEM_CACHE_ADDR_MIN(32'h80000000)
    ,.MEM_CACHE_ADDR_MAX(32'h8fffffff)
```

#### Configuration: Linux Capable
```
     .SUPPORT_BRANCH_PREDICTION(1)
    ,.SUPPORT_MULDIV(1)
    ,.SUPPORT_SUPER(1)
    ,.SUPPORT_MMU(1)
    ,.SUPPORT_DUAL_ISSUE(1)
    ,.SUPPORT_LOAD_BYPASS(1)
    ,.SUPPORT_MUL_BYPASS(1)
    ,.SUPPORT_REGFILE_XILINX(0) // Set to 1 if building for Xilinx FPGAs
    ,.EXTRA_DECODE_STAGE(1)
    ,.MEM_CACHE_ADDR_MIN(32'h80000000)
    ,.MEM_CACHE_ADDR_MAX(32'h8fffffff)
    ,.NUM_BTB_ENTRIES(32)
    ,.NUM_BTB_ENTRIES_W(5)
    ,.NUM_BHT_ENTRIES(512)
    ,.NUM_BHT_ENTRIES_W(9)
    ,.RAS_ENABLE(1)
    ,.GSHARE_ENABLE(0)
    ,.BHT_ENABLE(1)
    ,.NUM_RAS_ENTRIES(8)
    ,.NUM_RAS_ENTRIES_W(3)
```

#### Configuration: High FMAX
```
     .SUPPORT_BRANCH_PREDICTION(1) // Set to 0 for even higher FMAX but much worse IPC
    ,.SUPPORT_MULDIV(1)
    ,.SUPPORT_SUPER(0)
    ,.SUPPORT_MMU(0)
    ,.SUPPORT_DUAL_ISSUE(0)
    ,.SUPPORT_LOAD_BYPASS(0)
    ,.SUPPORT_MUL_BYPASS(0)
    ,.SUPPORT_REGFILE_XILINX(0) // Set to 1 if building for Xilinx FPGAs
    ,.EXTRA_DECODE_STAGE(1)
    ,.MEM_CACHE_ADDR_MIN(32'h80000000)
    ,.MEM_CACHE_ADDR_MAX(32'h8fffffff)
    ,.NUM_BTB_ENTRIES(16)
    ,.NUM_BTB_ENTRIES_W(4)
    ,.NUM_BHT_ENTRIES(256)
    ,.NUM_BHT_ENTRIES_W(8)
    ,.RAS_ENABLE(1)
    ,.GSHARE_ENABLE(0)
    ,.BHT_ENABLE(1)
    ,.NUM_RAS_ENTRIES(8)
    ,.NUM_RAS_ENTRIES_W(3)
```
