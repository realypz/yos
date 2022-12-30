#ifndef KERNEL_IO
#define KERNEL_IO

#include <stdint.h>

/// { 8259 common definitions
// https://wiki.osdev.org/8259_PIC
#define PIC1_COMMAND_PORT	0x20
#define PIC1_DATA_PORT	0x21
#define PIC2_COMMAND_PORT	0xA0
#define PIC2_DATA_PORT	0xA1
#define PIC2_EOI_CODE    0x20
#define PIC2_EOI_CODE    0x20
/// }

/// @brief Read the a word to the designated port.
/// @param port the 16-bit port number.
/// @return The 8-bit data read from the port.
extern uint8_t inb(uint16_t port);

/// @brief Write a byte to the port.
/// @param port the 16-bit port number.
/// @param data The byte to be written.
extern void outb(uint16_t port, uint8_t data);

#endif /* KERNEL_IO */
