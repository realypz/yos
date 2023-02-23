#ifndef KERNEL_ARCH_X86_GDT
#define KERNEL_ARCH_X86_GDT

#include <stdint.h>

// typedef struct
// {
//     uint16_t segment_limit_low;
//     uint16_t base_address_low;
//     uint8_t base_address_mid;
//     uint8_t access_byte;
//     uint8_t flags; // Bits 48 to 51 are segment limit high.
//     uint8_t base_address_high;
// } __attribute__((packed)) GDTEntry64;

typedef struct
{
    uint16_t limit_0 : 16;
    uint16_t base_0 : 16;
    uint8_t base_1 : 8;
    uint8_t type : 4, s : 1, dpl : 2, p : 1;
    uint8_t limit_1 : 4, avl : 1, l : 1, d : 1, g : 1;
    uint8_t base_2 : 8;
} __attribute__((packed)) GDTEntry64;

// TODO: Merge this struct with `DescriptorPtr` in kernel/interrupt/idt.h.
typedef struct
{
    /// Size of the interrupt descriptor table.
    uint16_t limit;

    /// Starting address of Interrupt desriptor table.
    GDTEntry64 *base;
} __attribute__((packed)) GDTDescriptorPtr;

// TODO: Can I reload the GDT after the OS jumped to long mode?
void init_gdt();

void write_gdt_entry(GDTEntry64 *gdt_entry, uint16_t const flags, uint32_t const base, uint32_t const limit);

#endif /* KERNEL_ARCH_X86_GDT */
