###############################################################################
# Variables: Program ELF
###############################################################################
ELF_FILE ?= test.elf

OBJCOPY ?= riscv32-unknown-elf-objcopy
ifeq ($(shell which $(OBJCOPY)),)
  ${error $(OBJCOPY) missing from PATH}
endif

###############################################################################
# Variables: Defaults
###############################################################################
TRACE          ?= 1

SRC_V_DIR      ?= ../../src/core .
SRC_DIR        ?= .

EXE            ?= output.out

###############################################################################
# Variables: Verilog
###############################################################################
SRC_V       ?= $(foreach src,$(SRC_V_DIR),$(wildcard $(src)/*.v))

VFLAGS      += $(patsubst %,-I%,$(SRC_V_DIR))
VFLAGS      += -DTRACE=$(TRACE)
VFLAGS      += -Dverilog_sim

###############################################################################
# Variables: Lists of objects, source and deps
###############################################################################
BUILD_DIR      ?= build/

###############################################################################
# Rules
###############################################################################
all: run

$(BUILD_DIR):
	@mkdir -p $@

$(BUILD_DIR)/tcm.bin: $(ELF_FILE) | $(BUILD_DIR)
	$(OBJCOPY) $< -O binary $@

$(BUILD_DIR)/$(EXE): $(SRC_V) | $(BUILD_DIR)
	@echo "# Compiling verilog"
	iverilog -o $@ $(SRC_V) $(VFLAGS)

run: $(BUILD_DIR)/$(EXE) $(BUILD_DIR)/tcm.bin
	vvp $(BUILD_DIR)/$(EXE) -vcd

view:
	gtkwave waveform.vcd gtksettings.sav  

clean:
	rm -rf $(BUILD_DIR) *.vcd

