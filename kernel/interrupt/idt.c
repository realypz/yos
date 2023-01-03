#include "kernel/interrupt/idt.h"
#include "kernel/interrupt/isr.h"
#include "kernel/io/io.h"

/// Interrupt desriptor table.
IDTEntry64 idt[NUM_IDT_ENTRIES];

/// Meta info of the interrupt desriptor table.
IDTDescriptor idt_descriptor = {sizeof(idt) - 1, idt};

/// @brief Load the interrupt descriptor table.
/// @details This function's detailed
/// implementation is in assembly code.
extern void __attribute__((cdecl)) load_idt_impl(IDTDescriptor *);

void init_idt()
{
#define KEYBOARD_INTERRUPT_VECTOR 0x21
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_1 = (uint16_t)((uint64_t)(&keyboard_isr) & 0x000000000000ffff);
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_2 = (uint16_t)(((uint64_t)(&keyboard_isr) & 0x00000000ffff0000) >> 16);
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_3 = (uint32_t)(((uint64_t)(&keyboard_isr) & 0xffffffff00000000) >> 32);
    idt[KEYBOARD_INTERRUPT_VECTOR].ist = 0;
    idt[KEYBOARD_INTERRUPT_VECTOR].type_attributes = 0x8e;
    idt[KEYBOARD_INTERRUPT_VECTOR].selector = 0x08;

    load_idt_impl(&idt_descriptor);
}
