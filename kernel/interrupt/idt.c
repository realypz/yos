#include "kernel/interrupt/idt.h"
#include "kernel/interrupt/isr.h"
#include "kernel/io/io.h"

/// Interrupt desriptor table.
static IDTEntry64 idt[NUM_IDT_ENTRIES];

/// Meta info of the interrupt desriptor table.
/// TODO: In boot/switch_to_long_mode.asm, `lidt` is also called. Investigte whether there is any potential problem.
DescriptorPtr idt_descriptor = {sizeof(idt) - 1, idt};

/// @brief Load the interrupt descriptor table.
/// @details The assembly version is in `kernel/interrupt/ARCHIVED_idt.asm`.
void __attribute__((cdecl, noinline)) __lidt(DescriptorPtr *)
{
    __asm__("mov %%rdi, %%rax;" // MISC: rdi stores the first argument in x86_64 linux calling convention.
            "lidt (%%rax);"
            "sti"
            :
            :
            : "rdx");
}

void init_idt()
{
#define KEYBOARD_INTERRUPT_VECTOR 0x21
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_1 = (uint16_t)((uint64_t)(&keyboard_isr) & 0x000000000000ffff);
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_2 = (uint16_t)(((uint64_t)(&keyboard_isr) & 0x00000000ffff0000) >> 16);
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_3 = (uint32_t)(((uint64_t)(&keyboard_isr) & 0xffffffff00000000) >> 32);
    idt[KEYBOARD_INTERRUPT_VECTOR].ist = 0;
    idt[KEYBOARD_INTERRUPT_VECTOR].type_attributes = 0x8e;
    idt[KEYBOARD_INTERRUPT_VECTOR].selector = 0x08; // TODO: Should a keyboard interrupt run at level 0 or level 3?

    __lidt(&idt_descriptor);
}
