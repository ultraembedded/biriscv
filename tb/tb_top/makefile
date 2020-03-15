###############################################################################
## Tool paths
###############################################################################
VERILATOR_SRC ?= /usr/share/verilator/include
SYSTEMC_HOME  ?= /usr/local/systemc-2.3.1

TEST_IMAGE ?= $(abspath ./test.elf)

export VERILATOR_SRC
export SYSTEMC_HOME

ifeq (,$(wildcard $(VERILATOR_SRC)))
  ${error VERILATOR_SRC must be set to VERILATOR_INSTALL/include}
endif
ifeq (,$(wildcard $(SYSTEMC_HOME)))
  ${error SYSTEMC_HOME must be set}
endif

###############################################################################
## Makefile
###############################################################################
.PHONY: build
all: build

build:
	make -f makefile.generate_verilated
	make -f makefile.build_verilated
	make -f makefile.build_sysc_tb

clean:
	make -f makefile.generate_verilated
	make -f makefile.build_verilated $@
	make -f makefile.build_sysc_tb $@
	-rm -rf *.vcd verilated

run: build
	./build/test.x -f $(TEST_IMAGE)