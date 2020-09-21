#include "testbench_vbase.h"
#include "elf_load.h"
#include <getopt.h>
#include <unistd.h>

#include "riscv_top.h"
#include "tb_axi4_mem.h"

#include "verilated.h"
#include "verilated_vcd_sc.h"

#define MEM_BASE 0x80000000

//-----------------------------------------------------------------
// Command line options
//-----------------------------------------------------------------
#define GETOPTS_ARGS "f:c:h"

static struct option long_options[] =
{
    {"elf",        required_argument, 0, 'f'},
    {"cycles",     required_argument, 0, 'c'},
    {"help",       no_argument,       0, 'h'},
    {0, 0, 0, 0}
};

static void help_options(void)
{
    fprintf (stderr,"Usage:\n");
    fprintf (stderr,"  --elf         | -f FILE       File to load\n");
    fprintf (stderr,"  --cycles      | -c NUM        Max instructions to execute\n");
    exit(-1);
}

//-----------------------------------------------------------------
// Module
//-----------------------------------------------------------------
class testbench: public testbench_vbase, public mem_api
{
public:
    //-----------------------------------------------------------------
    // Instances / Members
    //-----------------------------------------------------------------      
    riscv_top                   *m_dut;
    tb_axi4_mem                 *m_icache_mem;
    tb_axi4_mem                 *m_dcache_mem;

    int                          m_argc;
    char**                       m_argv;

    sc_signal <axi4_slave>      mem_i_in;
    sc_signal <axi4_master>     mem_i_out;

    sc_signal <axi4_slave>      mem_d_in;
    sc_signal <axi4_master>     mem_d_out;

    sc_signal < bool >          intr_in;

    sc_signal < sc_uint <32> >  reset_vector_in;

    //-----------------------------------------------------------------
    // process: Main loop for CPU execution
    //-----------------------------------------------------------------
    void process(void) 
    {
        uint64_t       cycles         = 0;
        int64_t        max_cycles     = (int64_t)-1;
        const char *   filename       = NULL;
        int            help           = 0;
        int c;        

        int option_index = 0;
        while ((c = getopt_long (m_argc, m_argv, GETOPTS_ARGS, long_options, &option_index)) != -1)
        {
            switch(c)
            {
                case 'f':
                    filename = optarg;
                    break;
                case 'c':
                    max_cycles = (int64_t)strtoull(optarg, NULL, 0);
                    break;
                case '?':
                default:
                    help = 1;   
                    break;
            }
        }        

        if (help || filename == NULL)
        {
            help_options();
            sc_stop();
            return;
        }

        // Load Firmware
        printf("Running: %s\n", filename);
        elf_load elf(filename, this);
        if (!elf.load())
        {
            fprintf (stderr,"Error: Could not open %s\n", filename);
            sc_stop();
        }

        // Set reset vector
        reset_vector_in.write(MEM_BASE);
        
        while (true)
        {
            cycles += 1;
            if (cycles >= max_cycles && max_cycles != -1)
                break;

            wait();
        }

        sc_stop();        
    }

    void set_argcv(int argc, char* argv[]) { m_argc = argc; m_argv = argv; }

    //-----------------------------------------------------------------
    // Construction
    //-----------------------------------------------------------------
    SC_HAS_PROCESS(testbench);
    testbench(sc_module_name name): testbench_vbase(name)
    {
        m_dut = new riscv_top("DUT");
        m_dut->clk_in(clk);
        m_dut->rst_in(rst);
        m_dut->axi_i_out(mem_i_out);
        m_dut->axi_i_in(mem_i_in);
        m_dut->axi_d_out(mem_d_out);
        m_dut->axi_d_in(mem_d_in);
        m_dut->intr_in(intr_in);
        m_dut->reset_vector_in(reset_vector_in);

        // Instruction Cache Memory
        m_icache_mem = new tb_axi4_mem("ICACHE_MEM");
        m_icache_mem->clk_in(clk);
        m_icache_mem->rst_in(rst);
        m_icache_mem->axi_in(mem_i_out);
        m_icache_mem->axi_out(mem_i_in);

        // Data Cache Memory
        m_dcache_mem = new tb_axi4_mem("DCACHE_MEM");
        m_dcache_mem->clk_in(clk);
        m_dcache_mem->rst_in(rst);
        m_dcache_mem->axi_in(mem_d_out);
        m_dcache_mem->axi_out(mem_d_in);
		
		verilator_trace_enable("verilator.vcd", m_dut);
    }
    //-----------------------------------------------------------------
    // Trace
    //-----------------------------------------------------------------
    void add_trace(sc_trace_file * fp, std::string prefix)
    {
        if (!waves_enabled())
            return;

        // Add signals to trace file
        #define TRACE_SIGNAL(a) sc_trace(fp,a,#a);
        TRACE_SIGNAL(clk);
        TRACE_SIGNAL(rst);

        m_dut->add_trace(fp, "");
    }

    //-----------------------------------------------------------------
    // create_memory: Create memory region
    //-----------------------------------------------------------------
    bool create_memory(uint32_t base, uint32_t size, uint8_t *mem = NULL)
    {
        base = base & ~(32-1);
        size = (size + 31) & ~(32-1);

        while (m_icache_mem->valid_addr(base))
            base += 1;

        while (m_icache_mem->valid_addr(base + size - 1))
            size -= 1;

        m_icache_mem->add_region(base, size);
        m_dcache_mem->add_region(m_icache_mem->get_array(base), base, size);

        memset(m_icache_mem->get_array(base), 0, size);
        return true;
    }
    //-----------------------------------------------------------------
    // valid_addr: Check address range
    //-----------------------------------------------------------------
    bool valid_addr(uint32_t addr) { return true; } 
    //-----------------------------------------------------------------
    // write: Write byte into memory
    //-----------------------------------------------------------------
    void write(uint32_t addr, uint8_t data)
    {
        m_dcache_mem->write(addr, data);
    }
    //-----------------------------------------------------------------
    // write: Read byte from memory
    //-----------------------------------------------------------------
    uint8_t read(uint32_t addr)
    {
        return m_dcache_mem->read(addr);
    }
};
