#ifndef __ELF_LOAD_H__
#define __ELF_LOAD_H__

#include "mem_api.h"
#include <string>

//--------------------------------------------------------------------
// ELF loader
//--------------------------------------------------------------------
class elf_load
{
public:
    elf_load(const char *filename, mem_api *target);

    bool     load(void);
    uint32_t get_entry_point(void) { return m_entry_point; }
    bool     get_symbol(const char *symname, uint32_t &value);

protected:
    std::string m_filename;
    mem_api *   m_target;
    uint32_t    m_entry_point;
};

#endif