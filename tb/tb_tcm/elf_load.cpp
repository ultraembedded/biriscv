#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <libelf.h>
#include <fcntl.h>
#include <gelf.h>
#include <bfd.h>
#include <string>

#include "elf_load.h"

//--------------------------------------------------------------------
// Constructor
//--------------------------------------------------------------------
elf_load::elf_load(const char *filename, mem_api *target)
{
    m_filename    = std::string(filename);
    m_target      = target;
    m_entry_point = 0;
}
//--------------------------------------------------------------------
// load: Load ELF to target
//--------------------------------------------------------------------
bool elf_load::load(void)
{
    int fd;
    Elf * e;
    Elf_Kind ek;
    Elf_Scn *scn;
    Elf_Data *data;
    size_t shstrndx;

    if (elf_version ( EV_CURRENT ) == EV_NONE)
        return false;
    
    if ((fd = open ( m_filename.c_str() , O_RDONLY , 0)) < 0)
        return false;

    if ((e = elf_begin ( fd , ELF_C_READ, NULL )) == NULL)
        return false;
    
    ek = elf_kind ( e );
    if (ek != ELF_K_ELF)
        return false;

    // Get section name header index
    if (elf_getshdrstrndx(e, &shstrndx)!=0)
        return false;

    // Get entry point
    {
        GElf_Ehdr _ehdr;
        GElf_Ehdr *ehdr = gelf_getehdr(e, &_ehdr);
        m_entry_point = ehdr ? (uint32_t)ehdr->e_entry : 0;
    }

    int section_idx = 0;
    while ((scn = elf_getscn(e, section_idx)) != NULL)
    {
        Elf32_Shdr *shdr = elf32_getshdr(scn);

        // 64-bit target
        if (!shdr)
        {
            Elf64_Shdr *shdr64 = elf64_getshdr(scn);

            if ((shdr64->sh_flags & SHF_ALLOC) && (shdr64->sh_size > 0))
            {
                data = elf_getdata(scn, NULL);

                printf("Memory: 0x%lx - 0x%lx (Size=%ldKB) [%s]\n", shdr64->sh_addr, shdr64->sh_addr + shdr64->sh_size - 1, shdr64->sh_size / 1024, elf_strptr(e, shstrndx, shdr64->sh_name));

                if (!m_target->create_memory(shdr64->sh_addr, shdr64->sh_size))
                {
                    fprintf(stderr, "ERROR: Cannot allocate memory region\n");
                    close (fd);
                    return false;
                }

                if (shdr64->sh_type == SHT_PROGBITS)
                {                
                    int i;
                    for (i=0;i<shdr64->sh_size;i++)
                    {
                        uint32_t load_addr = shdr64->sh_addr + i;
                        if (m_target->valid_addr(load_addr))
                            m_target->write(load_addr, ((uint8_t*)data->d_buf)[i]);
                        else
                        {
                            fprintf(stderr, "ERROR: Cannot write byte to 0x%08x\n", load_addr);
                            close (fd);
                            return false;
                        }
                    }
                }
            }            
        }
        // 32-bit target - section which need allocating
        else if ((shdr->sh_flags & SHF_ALLOC) && (shdr->sh_size > 0))
        {
            data = elf_getdata(scn, NULL);

            printf("Memory: 0x%x - 0x%x (Size=%dKB) [%s]\n", shdr->sh_addr, shdr->sh_addr + shdr->sh_size - 1, shdr->sh_size / 1024, elf_strptr(e, shstrndx, shdr->sh_name));

            if (!m_target->create_memory(shdr->sh_addr, shdr->sh_size))
            {
                fprintf(stderr, "ERROR: Cannot allocate memory region\n");
                close (fd);
                return false;
            }

            if (shdr->sh_type == SHT_PROGBITS)
            {                
                int i;
                for (i=0;i<shdr->sh_size;i++)
                {
                    uint32_t load_addr = shdr->sh_addr + i;
                    if (m_target->valid_addr(load_addr))
                        m_target->write(load_addr, ((uint8_t*)data->d_buf)[i]);
                    else
                    {
                        fprintf(stderr, "ERROR: Cannot write byte to 0x%08x\n", load_addr);
                        close (fd);
                        return false;
                    }
                }
            }
        }

        section_idx++;
    }    

    elf_end ( e );
    close ( fd );
    
    return true;
}
//--------------------------------------------------------------------
// get_symbol: Get symbol from ELF
//--------------------------------------------------------------------
bool elf_load::get_symbol(const char *symname, uint32_t &value)
{
    bfd *ibfd;
    asymbol **symtab;
    long nsize, nsyms, i;
    symbol_info syminfo;
    char **matching;

    bfd_init();

    ibfd = bfd_openr(m_filename.c_str(), NULL);
    if (ibfd == NULL) 
    {
        printf("ERROR: get_symbol: bfd_openr error\n");
        return false;
    }

    if (!bfd_check_format_matches(ibfd, bfd_object, &matching)) 
    {
        printf("ERROR: get_symbol: format_matches\n");
        return false;
    }
 
    nsize  = bfd_get_symtab_upper_bound (ibfd);
    symtab = (asymbol **)malloc(nsize);
    nsyms  = bfd_canonicalize_symtab(ibfd, symtab);

    bool found = false;

    for (i = 0; i < nsyms; i++)
    {
        if (strcmp(symtab[i]->name, symname) == 0)
        {
            bfd_symbol_info(symtab[i], &syminfo);
            value = syminfo.value;
            found = true;
            break;
        }
    }

    bfd_close(ibfd);    

    return found;
}
