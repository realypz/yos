#ifndef KERNEL_INTERRUPT_IDT
#define KERNEL_INTERRUPT_IDT

#include <stdint.h>

#define NUM_IDT_ENTRIES 256

typedef struct
{
    uint16_t offset_1;        // offset bits 0..15
    uint16_t selector;        // a code segment selector in GDT or LDT
    uint8_t  ist;             // bits 0..2 holds Interrupt Stack Table offset, rest of bits zero.
    uint8_t  type_attributes; // gate type, dpl, and p fields
    uint16_t offset_2;        // offset bits 16..31
    uint32_t offset_3;        // offset bits 32..63
    uint32_t zero;            // reserved
} __attribute__((packed)) IDTEntry64; /// @brief The data entry in interrupt descriptor table.

typedef struct
{
    /// Size of the interrupt descriptor table. 
    uint16_t limit;

    /// Starting address of Interrupt desriptor table.
    IDTEntry64* base;
} __attribute__((packed)) IDTDescriptor;  /// Meta info of the interrupt desriptor table.

/// @brief Initialize interrupt descriptor table.
/// @details Including set the interrupt service routine function address,
///          and other related data members.
void __attribute__((cdecl)) init_idt();

#endif /* KERNEL_INTERRUPT_IDT */
