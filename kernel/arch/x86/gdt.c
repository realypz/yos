#include "gdt.h"

#include "segments.h"

static GDTEntry64 gdt[NUM_GDT_ENTRIES];

GDTDescriptorPtr gdt_ptr = {sizeof(gdt) - 1, gdt};

void __attribute__((noinline)) __lgdt(GDTDescriptorPtr *)
{
    __asm__("mov %%rdi, %%rax;"
            "lgdt (%%rax);"
            "sti"
            :
            :
            : "rdx");
}

void init_gdt()
{
    write_gdt_entry(&gdt[GDT_ENTRY_KERNEL32_CS], 0xc09b, 0, 0xfffff);
    write_gdt_entry(&gdt[GDT_ENTRY_KERNEL_CS], 0xa09b, 0, 0xfffff);
    write_gdt_entry(&gdt[GDT_ENTRY_KERNEL_DS], 0xc093, 0, 0xfffff);
    write_gdt_entry(&gdt[GDT_ENTRY_USER32_CS], 0xc0fb, 0, 0xfffff);
    write_gdt_entry(&gdt[GDT_ENTRY_USER_DS], 0xc0f3, 0, 0xfffff);
    write_gdt_entry(&gdt[GDT_ENTRY_USER_CS], 0xa0fb, 0, 0xfffff);

    __lgdt(&gdt_ptr);
}

void write_gdt_entry(GDTEntry64 *gdt_entry, uint16_t const flags, uint32_t const base, uint32_t const limit)
{
    gdt_entry->limit_0 = (uint16_t)(limit);
    gdt_entry->limit_1 = ((limit) >> 16) & 0x0F;
    gdt_entry->base_0 = (uint16_t)(base);
    gdt_entry->base_1 = ((base) >> 16) & 0xFF;
    gdt_entry->base_2 = ((base) >> 24) & 0xFF;
    gdt_entry->type = (flags & 0x0f);
    gdt_entry->s = (flags >> 4) & 0x01;
    gdt_entry->dpl = (flags >> 5) & 0x03;
    gdt_entry->p = (flags >> 7) & 0x01;
    gdt_entry->avl = (flags >> 12) & 0x01;
    gdt_entry->l = (flags >> 13) & 0x01;
    gdt_entry->d = (flags >> 14) & 0x01;
    gdt_entry->g = (flags >> 15) & 0x01;
}
