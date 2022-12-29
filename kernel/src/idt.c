#include "kernel/idt.h"
#include "kernel/interrupt.h"
#include "kernel/io.h"

IDTEntry64 idt[NUM_IDT_ENTRIES];
IDTDescriptor idt_descriptor = {sizeof(idt) - 1, idt};

void __attribute__((cdecl)) loadIDTImpl(IDTDescriptor* idtDescriptor);

#define UNUSED_PORT 0x80

void io_wait()
{
    outb(UNUSED_PORT, 0);
}

void initPIC8259()
{
    // Standard ISA IRQs: https://wiki.osdev.org/index.php?title=Interrupts#Standard_ISA_IRQs
    // https://gist.github.com/Sachin-Tharaka/e1d7ec022a1868c5ad7d1557e3319b0a
	outb(PIC1_COMMAND, 0x11);
	outb(PIC2_COMMAND, 0x11);
    // io_wait();

    outb(PIC1_DATA, 0x20);
	outb(PIC2_DATA, 0x28);
    // io_wait();

    outb(PIC1_DATA, 0x04);
    outb(PIC2_DATA, 0x02);
    // io_wait();

    outb(PIC1_DATA, 0x01);
    outb(PIC2_DATA, 0x01);
    // io_wait();

    outb(PIC1_DATA, 0xfd);
    outb(PIC2_DATA, 0xff);
    // io_wait();
}

void initIDT()
{
    #define KEYBOARD_INTERRUPT_VECTOR 0x21
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_1 = (uint16_t)( (uint64_t)(&keyboard_isr) & 0x000000000000ffff);
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_2 = (uint16_t)( ((uint64_t)(&keyboard_isr) & 0x00000000ffff0000) >> 16);
    idt[KEYBOARD_INTERRUPT_VECTOR].offset_3 = (uint32_t)( ((uint64_t)(&keyboard_isr) & 0xffffffff00000000) >> 32);
    idt[KEYBOARD_INTERRUPT_VECTOR].ist = 0;
    idt[KEYBOARD_INTERRUPT_VECTOR].type_attributes = 0x8e;
    idt[KEYBOARD_INTERRUPT_VECTOR].selector = 0x08;

    // Find the code in this video why it fails https://www.youtube.com/watch?v=QRhFo-CnpvQ&t=452s.
    initPIC8259();

    loadIDTImpl(&idt_descriptor);
}
