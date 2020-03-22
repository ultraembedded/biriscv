## Booting Linux on biRISC-V

The core currently implements RV32IM + machine/supervisor/user mode and has basic MMU support.  
The mainline Linux kernel requires RV-A (atomics) instruction support (this is a future planned feature for biRISC-V).  

Atomic instruction support can be emulated with a machine mode bootloader (with a performance penalty), allowing unmodified Linux kernel and userspace images to be used.  
This currently allows biRISC-V to successfully boot Linux to userspace.

### Required SW components
* riscv-linux-boot (SBI bootloader) - [https://github.com/ultraembedded/riscv-linux-boot](https://github.com/ultraembedded/riscv-linux-boot)
* Prebuilt Kernel images - [https://github.com/ultraembedded/riscv-linux-prebuilt](https://github.com/ultraembedded/riscv-linux-prebuilt)

### Required HW components
* biRISC-V configured to run Linux (see [configuration guide](docs/configuration.md))
* 32MB+ SDRAM/DDR available @ 0x80000000
* Xilinx UART-Lite accessible @ 0x92000000

### Building combined kernel + bootloader
```
cd riscv-linux-boot
make LINUX_DIR=/path/to/riscv-linux-prebuilt VMLINUX=/path/to/riscv-linux-prebuilt/kernel/vmlinux-rv32ima-5.0 DTS_FILE=/path/to/riscv-linux-prebuilt/dts/config32.dts
```

### Example Output
Running on a Digilent Arty Artix 7 (35T);

![Linux-Boot](docs/linux-boot.png)
