
SRC ?= main.c

CC = riscv64-unknown-elf-gcc
OBJDUMP = riscv64-unknown-elf-objdump
READELF = riscv64-unknown-elf-readelf
OBJCOPY = riscv64-unknown-elf-objcopy

CFLAGS = -march=rv32im -mabi=ilp32
GCC_LDFLAGS = -T link.ld -nostartfiles -e main -O2

OBJ = $(SRC:.c=.o)
ELF = $(SRC:.c=.elf)
ASM = $(SRC:.c=.s)
BIN = $(SRC:.c=.bin)

# Regras
all: gcc_elf

info: $(ELF)
	$(READELF) -h $(ELF)

gcc_elf: $(SRC)
	$(CC) $(CFLAGS) $(GCC_LDFLAGS) -o $(ELF) $<
	$(OBJCOPY) -O binary $(ELF) $(BIN)
	$(OBJDUMP) -d $(ELF) > $(ASM)
	$(READELF) -h $(ELF)

clean:
	rm -f *.o *.elf *.s *.bin

.PHONY: all clean info