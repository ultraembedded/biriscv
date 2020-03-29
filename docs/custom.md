## Custom Features (non RISC-V standard)

### Timer

The timer supported in bi-RISC-V is a 32-bit cycle counter with the option to generate timer interrupts on match.

The RISC-V privileged spec refers to memory mapped **mtime** and **mtimecmp** registers.  
In bi-RISC-V these are mapped to CSR registers for fast access and low external dependence.

**mtime** is mapped to CSR **mcycle** and **rdtime** and is limited to 32-bits (continuously counting, wrapping).
**mtimecmp** is mapped to a custom CSR address and is limited to 32-bits and will generate an interrupt on matching **mtime** (interrupt routed to **MSTATUS.MTIP**).

```
#define csr_read(reg) ({ uint32_t __tmp; \
  asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
  __tmp; })

#define csr_write(reg, val) ({ \
  asm volatile ("csrw " #reg ", %0" :: "rK"(val)); })

void timer_set_mtimecmp(uint32_t next)
{
    csr_write(0x7c0, next);
}

uint32_t timer_get_mtime(void)
{
    return csr_read(0xc00); // or 0xc01
}
void timer_set_mtime(uint32_t value)
{
    csr_write(0xc01, value);
}
```

### Instruction Cache Flush

Flushing the instruction cache is achieved using **fence.i** which is in-keeping with the behaviour specified in the *Zifence* section of the RISC-V ISA specification;

```
void icache_flush(void)
{
    asm volatile ("fence.i");
}
```

### Data Cache Control

Cacheable regions of memory are specified at the core build time using the following parameters;

```
    ,.MEM_CACHE_ADDR_MIN(32'h80000000)
    ,.MEM_CACHE_ADDR_MAX(32'h8fffffff)
```

The data cache also has the following dynamic controls;
* Flush: Writeback all dirty lines, mark all lines as invalid (global flush).
* Writeback: Writeback a specific line (if dirty), leave line as valid in the cache (if it was present).
* Invalidate: Invalidate a specific line without writing back if dirty, mark line as invalid in the cache (if it was present).

These controls are mapped to **pmpcfg0**, **pmpcfg1** and **pmpcfg2** CSRs currently;

```
void dcache_flush(void)
{
    asm volatile ("csrw pmpcfg0, x0"); // 0x3a0
}
void dcache_writeback(uint32_t addr)
{
    asm volatile ("csrw pmpcfg1, %0": : "r" (addr)); // 0x3a1
}
void dcache_invalidate(uint32_t addr)
{
    asm volatile ("csrw pmpcfg2, %0": : "r" (addr)); // 0x3a2
}
```

However, these mappings can be changed by altering the following definitions;
```
`define CSR_DFLUSH            12'h3a0
`define CSR_DWRITEBACK        12'h3a1
`define CSR_DINVALIDATE       12'h3a2
```
