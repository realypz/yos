#ifndef KERNEL_IO
#define KERNEL_IO

#include <stdint.h>

/// { 8259 common definitions
// https://wiki.osdev.org/8259_PIC
#define PIC1_COMMAND	0x20
#define PIC1_DATA	0x21
#define PIC2_COMMAND	0xA0
#define PIC2_DATA	0xA1
/// }

extern uint8_t inb(unsigned short port);
extern void outb(unsigned short port, unsigned char data);

#endif /* KERNEL_IO */
