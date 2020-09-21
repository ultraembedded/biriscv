// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Western Digital Corporation or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//********************************************************************************
// $Id$
//
// Function: Verilator testbench for SweRVolf
// Comments:
//
//********************************************************************************

#include <stdint.h>
#include <signal.h>

//#include <jtagServer.h>

#include "verilated_vcd_c.h"
#include "Valtusoc_core_tb.h"

using namespace std;

static bool done;

//const int JTAG_VPI_SERVER_PORT = 5555;
//const int JTAG_VPI_USE_ONLY_LOOPBACK = true;

vluint64_t main_time = 0;       // Current simulation time
// This is a 64-bit integer to reduce wrap over issues and
// allow modulus.  You can also use a double, if you wish.

double sc_time_stamp () {       // Called by $time in Verilog
  return main_time;           // converts to double, to match
  // what SystemC does
}

void INThandler(int signal)
{
	printf("\nCaught ctrl-c\n");
	done = true;
}


int main(int argc, char **argv, char **env)
{
  Verilated::commandArgs(argc, argv);
  bool gpio0 = false;
  Valtusoc_core_tb* top = new Valtusoc_core_tb;

  VerilatedVcdC * tfp = 0;
  const char *vcd = Verilated::commandArgsPlusMatch("vcd=");
  if (vcd[0]) {
    Verilated::traceEverOn(true);
    tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("trace.vcd");
  }

  vluint64_t timeout = 0;
  const char *arg_timeout = Verilated::commandArgsPlusMatch("timeout=");
  if (arg_timeout[0])
    timeout = atoi(arg_timeout+9);

  signal(SIGINT, INThandler);

  top->clk = 1;
  top->rst = 1;
  while (!(done || Verilated::gotFinish())) {
    if (main_time == 100) {
      printf("Releasing reset\n");
      top->rst = 0;
    }
     top->eval();
    if (tfp)
      tfp->dump(main_time);
        if (gpio0 != top->o_gpio) {
      printf("%lu: gpio0 is %s\n", main_time, top->o_gpio ? "on" : "off");
      gpio0 = top->o_gpio;
    }
    if (timeout && (main_time >= timeout)) {
      printf("Timeout: Exiting at time %lu\n", main_time);
      done = true;
    }
    top->clk = !top->clk;
    main_time+=10;
  }

  if (tfp)
    tfp->close();

  exit(0);
}
